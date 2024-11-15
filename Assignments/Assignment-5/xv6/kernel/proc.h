/* Saved registers for kernel context switches. */
struct context {
  uint64 ra;
  uint64 sp;

  /* callee-saved */
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

/* Per-CPU state. */
struct cpu {
  struct proc *proc;          /* The process running on this cpu, or null. */
  struct context context;     /* swtch() here to enter scheduler(). */
  int noff;                   /* Depth of push_off() nesting. */
  int intena;                 /* Were interrupts enabled before push_off()? */
};

extern struct cpu cpus[NCPU];

/* per-process data for the trap handling code in trampoline.S. */
/* sits in a page by itself just under the trampoline page in the */
/* user page table. not specially mapped in the kernel page table. */
/* uservec in trampoline.S saves user registers in the trapframe, */
/* then initializes registers from the trapframe's */
/* kernel_sp, kernel_hartid, kernel_satp, and jumps to kernel_trap. */
/* usertrapret() and userret in trampoline.S set up */
/* the trapframe's kernel_*, restore user registers from the */
/* trapframe, switch to the user page table, and enter user space. */
/* the trapframe includes callee-saved user registers like s0-s11 because the */
/* return-to-user path via usertrapret() doesn't return through */
/* the entire kernel call stack. */
struct trapframe {
  /*   0 */ uint64 kernel_satp;   /* kernel page table */
  /*   8 */ uint64 kernel_sp;     /* top of process's kernel stack */
  /*  16 */ uint64 kernel_trap;   /* usertrap() */
  /*  24 */ uint64 epc;           /* saved user program counter */
  /*  32 */ uint64 kernel_hartid; /* saved kernel tp */
  /*  40 */ uint64 ra;
  /*  48 */ uint64 sp;
  /*  56 */ uint64 gp;
  /*  64 */ uint64 tp;
  /*  72 */ uint64 t0;
  /*  80 */ uint64 t1;
  /*  88 */ uint64 t2;
  /*  96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
};

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
// Constants

#define MLFQ_MAX_LEVEL 10
#define NPROC 64 

// Structure representing a node in the MLFQ queue
struct MLFQProcessNode {
  struct proc *pcb;                      // Pointer to the process control block
  struct MLFQProcessNode *next;          // Next node in the queue
  struct MLFQProcessNode *prev;          // Previous node in the queue
};

// Structure representing a single MLFQ level queue
struct MLFQQueuePerLevel {
  struct MLFQProcessNode *head;          // Head of the queue
  struct MLFQProcessNode *tail;          // Tail of the queue
};

// Structure for MLFQ information report (for metrics)
struct MLFQInfoReport {
  int tickCounts[MLFQ_MAX_LEVEL];        // Tick counts at each priority level
};

/* Per-process state */
struct proc {
  struct spinlock lock;                  // Lock to protect the process's state

  // P->lock must be held when using these:
  enum procstate state;                  // Process state
  void *chan;                            // If non-zero, sleeping on chan
  int killed;                            // If non-zero, have been killed
  int xstate;                            // Exit status to be returned to parent's wait
  int pid;                               // Process ID

  // wait_lock must be held when using this:
  struct proc *parent;                   // Parent process

  // Private to the process
  uint64 kstack;                         // Virtual address of kernel stack
  uint64 sz;                             // Size of process memory (bytes)
  pagetable_t pagetable;                 // User page table
  struct trapframe *trapframe;           // Data page for trampoline.S
  struct context context;                // swtch() here to run process
  struct file *ofile[NOFILE];            // Open files
  struct inode *cwd;                     // Current directory
  char name[16];                         // Process name (debugging)

  // Project 1B: System Call Metrics
  int runCount;                          // Number of times scheduled to run on CPU
  int systemcallCount;                   // Number of system calls made
  int interruptCount;                    // Number of interrupts handled
  int preemptCount;                      // Number of preemptions
  int trapCount;                         // Number of traps from user to kernel
  int sleepCount;                        // Number of times voluntarily yielded CPU

  // Project 1C: MLFQ Scheduling Metrics
  int inQueue;                           // Flag indicating if the process is in any MLFQ queue
  int lvl;                               // Current priority level
  int currLvlTicks;                      // Ticks run on current queue level
  int maxLvlTicks;                       // Ticks at max priority (bottom) level
  struct MLFQProcessNode *mlfq_node;     // Pointer to the MLFQ node in the queue
  struct MLFQInfoReport report;          // Tick counts at each priority level
};

// External declarations
extern struct cpu cpus[NCPU];
extern struct proc proc[NPROC];           // Process table
extern struct proc *initproc;              // Initial process

// MLFQ-related function prototypes
void initialize_mlfq(void);
void setMLFQFlag(int flag);
int getMLFQFlag(void);
void setLevelsInMLFQ(int levels);
int getLevelsInMLFQ(void);
void setMaxTicksAtBottom(int ticks);
int getMaxTicksAtBottom(void);
void mlfq_enqueue(int level, struct proc *p);
void mlfq_dequeue(int level, struct proc *p);
struct proc* mlfq_select_process(void);
void mlfq_update_process(struct proc *p);
void mlfq_priority_boost(void);
void mlfq_delete(int level, struct proc *p);
void unlink_and_free(struct MLFQQueuePerLevel *queue, struct MLFQProcessNode *node);
void enqueue_if_mlfq(struct proc *p);
