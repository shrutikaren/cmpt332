// proc.c
#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

// Process table
struct cpu cpus[NCPU];
struct proc proc[NPROC];
struct proc *initproc;

// PID management
int nextpid = 1;
struct spinlock pid_lock;

// External functions
extern void forkret(void);
extern char trampoline[]; // trampoline.S

// Spinlock for wait
struct spinlock wait_lock;

// MLFQ-related global variables
static int mlfqFlag = 0;         // Flag to enable MLFQ scheduler
static int levelsInMlfq = 1;     // Number of levels in MLFQ (default: 1)
static int maxTicksAtBottom = 1; // Max ticks at bottom level (default: 1)

// Ready queues for each MLFQ level
struct MLFQQueuePerLevel mlfqQueues[MLFQ_MAX_LEVEL];

// Function to initialize the MLFQ scheduler
void initialize_mlfq(void)
{
  mlfqFlag = 0; // Disabled by default
  levelsInMlfq = 1;
  maxTicksAtBottom = 1;

  // Initialize all MLFQ queues
  for(int i = 0; i < MLFQ_MAX_LEVEL; i++) {
    mlfqQueues[i].head = 0;
    mlfqQueues[i].tail = 0;
  }
}

// Setter and Getter for MLFQ Flag
void setMLFQFlag(int flag)
{
  mlfqFlag = flag;
}

int getMLFQFlag(void)
{
  return mlfqFlag;
}

// Setter and Getter for Levels in MLFQ
void setLevelsInMLFQ(int levels)
{
  if(levels > 0 && levels <= MLFQ_MAX_LEVEL) {
    levelsInMlfq = levels;
  }
}

int getLevelsInMLFQ(void)
{
  return levelsInMlfq;
}

// Setter and Getter for Max Ticks at Bottom Level
void setMaxTicksAtBottom(int ticks)
{
  if(ticks > 0) {
    maxTicksAtBottom = ticks;
  }
}

int getMaxTicksAtBottom(void)
{
  return maxTicksAtBottom;
}

// Enqueue a process to a specific MLFQ level
void mlfq_enqueue(int level, struct proc *p)
{
  if(level < 0 || level >= levelsInMlfq) {
    panic("mlfq_enqueue: Invalid level");
  }

  struct MLFQProcessNode *procNode = (struct MLFQProcessNode *)kalloc();
  if(procNode == 0) {
    panic("mlfq_enqueue: kalloc failed");
  }

  procNode->pcb = p;
  procNode->next = 0;

  struct MLFQQueuePerLevel *targetQueue = &mlfqQueues[level];

  if(targetQueue->head == 0) { // Queue is empty
    procNode->prev = 0;
    targetQueue->head = procNode;
    targetQueue->tail = procNode;
  }
  else { // Append to the tail
    procNode->prev = targetQueue->tail;
    targetQueue->tail->next = procNode;
    targetQueue->tail = procNode;
  }

  p->mlfq_node = procNode;
  p->lvl = level;
  p->currLvlTicks = 0;
  p->inQueue = 1;
}

// Unlink a process node from its MLFQ queue and free memory
void unlink_and_free(struct MLFQQueuePerLevel *queue, struct MLFQProcessNode *node)
{
  if(node->prev != 0) { // Not the head
    node->prev->next = node->next;
  }
  else { // Node is the head
    queue->head = node->next;
  }

  if(node->next != 0) { // Not the tail
    node->next->prev = node->prev;
  }
  else { // Node is the tail
    queue->tail = node->prev;
  }

  kfree((void *)node);
}

// Dequeue a specific process from a specific MLFQ level
void mlfq_dequeue(int level, struct proc *p)
{
  if(level < 0 || level >= levelsInMlfq) {
    panic("mlfq_dequeue: Invalid level");
  }

  struct MLFQQueuePerLevel *targetQueue = &mlfqQueues[level];
  struct MLFQProcessNode *procNode = p->mlfq_node;

  if(procNode == 0) {
    // Process is not in any queue
    return;
  }

  unlink_and_free(targetQueue, procNode);

  p->mlfq_node = 0;
  p->inQueue = 0;
}

// Delete a process from its current MLFQ level
void mlfq_delete(int level, struct proc *p)
{
  mlfq_dequeue(level, p);
}

// Select the next runnable process from the MLFQ queues
struct proc* mlfq_select_process(void)
{
  for(int i = 0; i < levelsInMlfq; i++) { // Start from highest priority
    struct MLFQQueuePerLevel *currentQueue = &mlfqQueues[i];
    struct MLFQProcessNode *node = currentQueue->head;

    while(node != 0) {
      struct proc *p = node->pcb;
      if(p->state == RUNNABLE) {
        mlfq_dequeue(i, p); // Remove from queue
        return p;
      }
      node = node->next;
    }
  }
  return 0; // No runnable process found
}

// Update a process's tick counts and handle demotion
void mlfq_update_process(struct proc *p)
{
  p->currLvlTicks++;
  p->report.tickCounts[p->lvl] = p->currLvlTicks;

  if(p->currLvlTicks >= 2 * (p->lvl + 1)) { // Time quantum expired
    if(p->lvl < levelsInMlfq - 1) { // Not at lowest level
      mlfq_dequeue(p->lvl, p); // Remove from current queue
      p->lvl++;                 // Demote to next lower level
      p->currLvlTicks = 0;      // Reset ticks

      mlfq_enqueue(p->lvl, p);  // Enqueue to lower level
    }
    else { // At lowest level, do not demote
      p->currLvlTicks = 0; // Reset ticks
      mlfq_enqueue(p->lvl, p); // Re-enqueue to same level
    }
  }
}

// Priority boost: Promote processes stuck at the lowest level to highest level
void mlfq_priority_boost(void)
{
  struct MLFQQueuePerLevel *bottomQueue = &mlfqQueues[levelsInMlfq - 1];
  struct MLFQProcessNode *node = bottomQueue->head;

  while(node != 0) {
    struct proc *p = node->pcb;
    node = node->next; // Move to next node before potential modifications

    p->maxLvlTicks++;
    if(p->maxLvlTicks >= maxTicksAtBottom) {
      mlfq_dequeue(levelsInMlfq - 1, p); // Remove from bottom queue
      p->maxLvlTicks = 0;                 // Reset max level ticks
      p->currLvlTicks = 0;                // Reset current level ticks
      p->lvl = 0;                          // Promote to highest level

      mlfq_enqueue(0, p);                  // Enqueue to top level
    }
  }
}

// Scheduler for MLFQ
void MLFQ_scheduler(struct cpu *c)
{
  struct proc *p = mlfq_select_process();

  if(p != 0) {
    acquire(&p->lock);
    p->state = RUNNING;
    c->proc = p;

    // Increment run count before switching
    p->runCount++;

    swtch(&c->context, &p->context); // Context switch to process
    c->proc = 0;
    release(&p->lock);

    // After process runs, update its tick counts and handle demotion
    mlfq_update_process(p);
  }

  // Perform priority boost if necessary
  mlfq_priority_boost();
}

// Round Robin Scheduler
void RR_scheduler(struct cpu *c)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == RUNNABLE) {
      p->state = RUNNING;
      c->proc = p;

      // Increment run count before switching
      p->runCount++;

      swtch(&c->context, &p->context); // Context switch to process
      c->proc = 0;
    }
    release(&p->lock);
  }
}

// Main scheduler function
void scheduler(void)
{
  struct cpu *c = mycpu();
  c->proc = 0;

  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();

    if(getMLFQFlag()) {
      // Run MLFQ scheduler
      MLFQ_scheduler(c);
    }
    else {
      // Run Round Robin scheduler
      RR_scheduler(c);
    }
  }
}

// Allocate a new process
static struct proc* allocproc(void)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    }
    else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate trapframe
  if((p->trapframe = (struct trapframe*)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Allocate pagetable
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Initialize context to forkret
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  // Initialize MLFQ-related fields
  p->inQueue = 0;
  p->lvl = 0;
  p->currLvlTicks = 0;
  p->maxLvlTicks = 0;
  p->mlfq_node = 0;
  memset(p->report.tickCounts, 0, sizeof(p->report.tickCounts));

  return p;
}

// Free a process structure and its associated data
static void freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;

  // Reset system call metrics
  p->runCount = 0;
  p->sleepCount = 0;
  p->systemcallCount = 0;
  p->trapCount = 0;
  p->interruptCount = 0;
  p->preemptCount = 0;

  // Reset MLFQ-related fields
  p->inQueue = 0;
  p->lvl = 0;
  p->currLvlTicks = 0;
  p->maxLvlTicks = 0;
  p->mlfq_node = 0;
  memset(p->report.tickCounts, 0, sizeof(p->report.tickCounts));
}

// Allocate PID
static int allocpid(void)
{
  int pid;

  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // Map the trampoline code (for system call return)
  // at the highest user virtual address.
  // Only the supervisor uses it, on the way to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE, 
             (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }

  // Map the trapframe page just below the trampoline page, for trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE, 
             (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// Initialize the first user process
void userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;

  // Allocate one user page and copy initcode's instructions and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // Prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;     // User program counter
  p->trapframe->sp = PGSIZE; // User stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  // Enqueue to MLFQ if enabled
  enqueue_if_mlfq(p);

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
      return -1;
  }
  else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Fork a new process, copying the parent.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // Copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // Increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;

  // Enqueue to MLFQ if enabled
  enqueue_if_mlfq(np);

  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++) {
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process. Does not return.
void exit(int status)
{
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++) {
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Reparent children to init.
  reparent(p);

  // Wake up parent in case it's waiting.
  wakeup(p->parent);

  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  // Dequeue from MLFQ if enabled
  if(getMLFQFlag() && p->inQueue) {
    mlfq_dequeue(p->lvl, p);
  }

  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(pp = proc; pp < &proc[NPROC]; pp++) {
      if(pp->parent == p){
        acquire(&pp->lock);
        havekids = 1;
        if(pp->state == ZOMBIE){
          // Found one.
          pid = pp->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate, sizeof(pp->xstate)) < 0){
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
  }
}

// Schedule a process
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Yield the CPU for one scheduling round.
void yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;

  if(getMLFQFlag()) {
    mlfq_enqueue(p->lvl, p);
  }

  sched();
  release(&p->lock);
}

// Fork return function
void forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if(first){
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
}

// Sleep on a channel
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  acquire(&p->lock);
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  // Increment the sleepCount before scheduling
  p->sleepCount++;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan){
        p->state = RUNNABLE;
        enqueue_if_mlfq(p);
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
int kill(int pid)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
        enqueue_if_mlfq(p);
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

// Set a process as killed.
void setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

// Check if a process is killed.
int killed(struct proc *p)
{
  int k;

  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address or kernel address, depending on usr_dst.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  }
  else{
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address or kernel address, depending on usr_src.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  }
  else{
    memmove(dst, (char *)src, len);
    return 0;
  }
}

// Print a process listing to console. For debugging.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [USED] "used",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++) {
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}

// Enqueue a process to MLFQ if enabled and not already in a queue
void enqueue_if_mlfq(struct proc *p)
{
  if(getMLFQFlag() && p->state == RUNNABLE && p->inQueue == 0){
    mlfq_enqueue(0, p); // Enqueue to highest priority level
  }
}
