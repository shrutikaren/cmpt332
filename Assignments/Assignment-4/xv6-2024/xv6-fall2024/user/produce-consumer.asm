
user/_produce-consumer:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <P>:
int right;
int buffer_count; /* The shared variable*/
int mutex_id;

/* Produces an item inside the buffer */
void P(void){
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	add	s0,sp,48
	while (1){
		mutex = malloc(sizeof(mutex_t));
  10:	00001a17          	auipc	s4,0x1
  14:	f30a0a13          	add	s4,s4,-208 # f40 <mutex>
		mtx_lock(mutex->locked);
		if (buffer_count < FULL_BUFFER_SIZE){
  18:	00001497          	auipc	s1,0x1
  1c:	f1c48493          	add	s1,s1,-228 # f34 <buffer_count>
  20:	49a5                	li	s3,9
			buffer_count ++;
		}	
		mtx_unlock(mutex_id);
  22:	00001917          	auipc	s2,0x1
  26:	f0e90913          	add	s2,s2,-242 # f30 <mutex_id>
  2a:	a809                	j	3c <P+0x3c>
			buffer_count ++;
  2c:	2785                	addw	a5,a5,1
  2e:	c09c                	sw	a5,0(s1)
		mtx_unlock(mutex_id);
  30:	00092503          	lw	a0,0(s2)
  34:	00000097          	auipc	ra,0x0
  38:	524080e7          	jalr	1316(ra) # 558 <mtx_unlock>
		mutex = malloc(sizeof(mutex_t));
  3c:	4511                	li	a0,4
  3e:	00001097          	auipc	ra,0x1
  42:	ce8080e7          	jalr	-792(ra) # d26 <malloc>
  46:	00aa3023          	sd	a0,0(s4)
		mtx_lock(mutex->locked);
  4a:	4108                	lw	a0,0(a0)
  4c:	00000097          	auipc	ra,0x0
  50:	4ec080e7          	jalr	1260(ra) # 538 <mtx_lock>
		if (buffer_count < FULL_BUFFER_SIZE){
  54:	409c                	lw	a5,0(s1)
  56:	fcf9dbe3          	bge	s3,a5,2c <P+0x2c>
  5a:	bfd9                	j	30 <P+0x30>

000000000000005c <V>:
	}
	thread_yield(); /* Put it into a RUNNABLE state*/
}

void V(void){
  5c:	7179                	add	sp,sp,-48
  5e:	f406                	sd	ra,40(sp)
  60:	f022                	sd	s0,32(sp)
  62:	ec26                	sd	s1,24(sp)
  64:	e84a                	sd	s2,16(sp)
  66:	e44e                	sd	s3,8(sp)
  68:	1800                	add	s0,sp,48
	while(1){
	/* Check if the buffer is full */
		mutex = malloc(sizeof(mutex_t));
  6a:	00001997          	auipc	s3,0x1
  6e:	ed698993          	add	s3,s3,-298 # f40 <mutex>
		mtx_lock(mutex->locked);
		if (buffer_count > 0){
  72:	00001497          	auipc	s1,0x1
  76:	ec248493          	add	s1,s1,-318 # f34 <buffer_count>
			buffer_count --;
		}
		mtx_unlock(mutex_id);
  7a:	00001917          	auipc	s2,0x1
  7e:	eb690913          	add	s2,s2,-330 # f30 <mutex_id>
  82:	a809                	j	94 <V+0x38>
			buffer_count --;
  84:	37fd                	addw	a5,a5,-1
  86:	c09c                	sw	a5,0(s1)
		mtx_unlock(mutex_id);
  88:	00092503          	lw	a0,0(s2)
  8c:	00000097          	auipc	ra,0x0
  90:	4cc080e7          	jalr	1228(ra) # 558 <mtx_unlock>
		mutex = malloc(sizeof(mutex_t));
  94:	4511                	li	a0,4
  96:	00001097          	auipc	ra,0x1
  9a:	c90080e7          	jalr	-880(ra) # d26 <malloc>
  9e:	00a9b023          	sd	a0,0(s3)
		mtx_lock(mutex->locked);
  a2:	4108                	lw	a0,0(a0)
  a4:	00000097          	auipc	ra,0x0
  a8:	494080e7          	jalr	1172(ra) # 538 <mtx_lock>
		if (buffer_count > 0){
  ac:	409c                	lw	a5,0(s1)
  ae:	fcf04be3          	bgtz	a5,84 <V+0x28>
  b2:	bfd9                	j	88 <V+0x2c>

00000000000000b4 <main>:
	 		
	}
	thread_yield(); /* Put it into the RUNNABLE queue*/
}

int main(int argc, char *argv[]){
  b4:	1141                	add	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	add	s0,sp,16
	mutex_id = mtx_create(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	42e080e7          	jalr	1070(ra) # 4ec <mtx_create>
  c6:	00001797          	auipc	a5,0x1
  ca:	e6a7a523          	sw	a0,-406(a5) # f30 <mutex_id>
	thread_init();
  ce:	00000097          	auipc	ra,0x0
  d2:	09c080e7          	jalr	156(ra) # 16a <thread_init>
	thread_create(P);
  d6:	00000517          	auipc	a0,0x0
  da:	f2a50513          	add	a0,a0,-214 # 0 <P>
  de:	00000097          	auipc	ra,0x0
  e2:	13a080e7          	jalr	314(ra) # 218 <thread_create>
	thread_create(V);
  e6:	00000517          	auipc	a0,0x0
  ea:	f7650513          	add	a0,a0,-138 # 5c <V>
  ee:	00000097          	auipc	ra,0x0
  f2:	12a080e7          	jalr	298(ra) # 218 <thread_create>
	return 0;
}
  f6:	4501                	li	a0,0
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	add	sp,sp,16
  fe:	8082                	ret

0000000000000100 <thread_switch>:
 100:	00153023          	sd	ra,0(a0)
 104:	00253423          	sd	sp,8(a0)
 108:	e900                	sd	s0,16(a0)
 10a:	ed04                	sd	s1,24(a0)
 10c:	03253023          	sd	s2,32(a0)
 110:	03353423          	sd	s3,40(a0)
 114:	03453823          	sd	s4,48(a0)
 118:	03553c23          	sd	s5,56(a0)
 11c:	05653023          	sd	s6,64(a0)
 120:	05753423          	sd	s7,72(a0)
 124:	05853823          	sd	s8,80(a0)
 128:	05953c23          	sd	s9,88(a0)
 12c:	07a53023          	sd	s10,96(a0)
 130:	07b53423          	sd	s11,104(a0)
 134:	0005b083          	ld	ra,0(a1)
 138:	0085b103          	ld	sp,8(a1)
 13c:	6980                	ld	s0,16(a1)
 13e:	6d84                	ld	s1,24(a1)
 140:	0205b903          	ld	s2,32(a1)
 144:	0285b983          	ld	s3,40(a1)
 148:	0305ba03          	ld	s4,48(a1)
 14c:	0385ba83          	ld	s5,56(a1)
 150:	0405bb03          	ld	s6,64(a1)
 154:	0485bb83          	ld	s7,72(a1)
 158:	0505bc03          	ld	s8,80(a1)
 15c:	0585bc83          	ld	s9,88(a1)
 160:	0605bd03          	ld	s10,96(a1)
 164:	0685bd83          	ld	s11,104(a1)
 168:	8082                	ret

000000000000016a <thread_init>:
struct mutex_t* all_m[MUTEX_SIZE];
static int m_count = 0;
              
void 
thread_init(void)
{
 16a:	1141                	add	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	add	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
 170:	00001797          	auipc	a5,0x1
 174:	63078793          	add	a5,a5,1584 # 17a0 <all_thread>
 178:	00001717          	auipc	a4,0x1
 17c:	def73823          	sd	a5,-528(a4) # f68 <current_thread>
  current_thread->state = RUNNING;
 180:	4785                	li	a5,1
 182:	00003717          	auipc	a4,0x3
 186:	68f72723          	sw	a5,1678(a4) # 3810 <all_thread+0x2070>
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	add	sp,sp,16
 18e:	8082                	ret

0000000000000190 <thread_schedule>:

void 
thread_schedule(void)
{
 190:	1141                	add	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	add	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
 198:	00001517          	auipc	a0,0x1
 19c:	dd053503          	ld	a0,-560(a0) # f68 <current_thread>
 1a0:	6589                	lui	a1,0x2
 1a2:	07858593          	add	a1,a1,120 # 2078 <all_thread+0x8d8>
 1a6:	95aa                	add	a1,a1,a0
 1a8:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
 1aa:	00009817          	auipc	a6,0x9
 1ae:	7d680813          	add	a6,a6,2006 # 9980 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
 1b2:	6689                	lui	a3,0x2
 1b4:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
 1b6:	07868893          	add	a7,a3,120 # 2078 <all_thread+0x8d8>
 1ba:	a809                	j	1cc <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
 1bc:	00d58733          	add	a4,a1,a3
 1c0:	5b38                	lw	a4,112(a4)
 1c2:	02c70963          	beq	a4,a2,1f4 <thread_schedule+0x64>
    t = t + 1;
 1c6:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
 1c8:	37fd                	addw	a5,a5,-1
 1ca:	cb81                	beqz	a5,1da <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
 1cc:	ff05e8e3          	bltu	a1,a6,1bc <thread_schedule+0x2c>
      t = all_thread;
 1d0:	00001597          	auipc	a1,0x1
 1d4:	5d058593          	add	a1,a1,1488 # 17a0 <all_thread>
 1d8:	b7d5                	j	1bc <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	c3650513          	add	a0,a0,-970 # e10 <malloc+0xea>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	a8c080e7          	jalr	-1396(ra) # c6e <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	618080e7          	jalr	1560(ra) # 804 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
 1f4:	00b50e63          	beq	a0,a1,210 <thread_schedule+0x80>
    next_thread->state = RUNNING;
 1f8:	6789                	lui	a5,0x2
 1fa:	97ae                	add	a5,a5,a1
 1fc:	4705                	li	a4,1
 1fe:	dbb8                	sw	a4,112(a5)
    t = current_thread;
    current_thread = next_thread;
 200:	00001797          	auipc	a5,0x1
 204:	d6b7b423          	sd	a1,-664(a5) # f68 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64) t, (uint64)next_thread);
 208:	00000097          	auipc	ra,0x0
 20c:	ef8080e7          	jalr	-264(ra) # 100 <thread_switch>
  } else
    next_thread = 0;
}
 210:	60a2                	ld	ra,8(sp)
 212:	6402                	ld	s0,0(sp)
 214:	0141                	add	sp,sp,16
 216:	8082                	ret

0000000000000218 <thread_create>:

void 
thread_create(void (*func)())
{
 218:	1141                	add	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	add	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 21e:	00001797          	auipc	a5,0x1
 222:	58278793          	add	a5,a5,1410 # 17a0 <all_thread>
    if (t->state == FREE) break;
 226:	6709                	lui	a4,0x2
 228:	07070613          	add	a2,a4,112 # 2070 <all_thread+0x8d0>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 22c:	07870713          	add	a4,a4,120
 230:	00009597          	auipc	a1,0x9
 234:	75058593          	add	a1,a1,1872 # 9980 <base>
    if (t->state == FREE) break;
 238:	00c786b3          	add	a3,a5,a2
 23c:	4294                	lw	a3,0(a3)
 23e:	c681                	beqz	a3,246 <thread_create+0x2e>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 240:	97ba                	add	a5,a5,a4
 242:	feb79be3          	bne	a5,a1,238 <thread_create+0x20>
  }
  t->state = RUNNABLE;
 246:	6689                	lui	a3,0x2
 248:	00d78733          	add	a4,a5,a3
 24c:	4609                	li	a2,2
 24e:	db30                	sw	a2,112(a4)
  // YOUR CODE HERE
  t->ra = (uint64) func;
 250:	e388                	sd	a0,0(a5)
  t->sp = (uint64) t->stack + STACK_SIZE;
 252:	07078713          	add	a4,a5,112
 256:	9736                	add	a4,a4,a3
 258:	e798                	sd	a4,8(a5)
}
 25a:	6422                	ld	s0,8(sp)
 25c:	0141                	add	sp,sp,16
 25e:	8082                	ret

0000000000000260 <thread_yield>:

void 
thread_yield(void)
{
 260:	1141                	add	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	add	s0,sp,16
  current_thread->state = RUNNABLE;
 268:	00001797          	auipc	a5,0x1
 26c:	d007b783          	ld	a5,-768(a5) # f68 <current_thread>
 270:	6709                	lui	a4,0x2
 272:	97ba                	add	a5,a5,a4
 274:	4709                	li	a4,2
 276:	dbb8                	sw	a4,112(a5)
  thread_schedule();
 278:	00000097          	auipc	ra,0x0
 27c:	f18080e7          	jalr	-232(ra) # 190 <thread_schedule>
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	add	sp,sp,16
 286:	8082                	ret

0000000000000288 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 288:	7179                	add	sp,sp,-48
 28a:	f406                	sd	ra,40(sp)
 28c:	f022                	sd	s0,32(sp)
 28e:	ec26                	sd	s1,24(sp)
 290:	e84a                	sd	s2,16(sp)
 292:	e44e                	sd	s3,8(sp)
 294:	e052                	sd	s4,0(sp)
 296:	1800                	add	s0,sp,48
  int i;
  printf("thread_a started\n");
 298:	00001517          	auipc	a0,0x1
 29c:	ba050513          	add	a0,a0,-1120 # e38 <malloc+0x112>
 2a0:	00001097          	auipc	ra,0x1
 2a4:	9ce080e7          	jalr	-1586(ra) # c6e <printf>
  a_started = 1;
 2a8:	4785                	li	a5,1
 2aa:	00001717          	auipc	a4,0x1
 2ae:	caf72923          	sw	a5,-846(a4) # f5c <a_started>
  while(b_started == 0 || c_started == 0)
 2b2:	00001497          	auipc	s1,0x1
 2b6:	ca648493          	add	s1,s1,-858 # f58 <b_started>
 2ba:	00001917          	auipc	s2,0x1
 2be:	c9a90913          	add	s2,s2,-870 # f54 <c_started>
 2c2:	a029                	j	2cc <thread_a+0x44>
    thread_yield();
 2c4:	00000097          	auipc	ra,0x0
 2c8:	f9c080e7          	jalr	-100(ra) # 260 <thread_yield>
  while(b_started == 0 || c_started == 0)
 2cc:	409c                	lw	a5,0(s1)
 2ce:	2781                	sext.w	a5,a5
 2d0:	dbf5                	beqz	a5,2c4 <thread_a+0x3c>
 2d2:	00092783          	lw	a5,0(s2)
 2d6:	2781                	sext.w	a5,a5
 2d8:	d7f5                	beqz	a5,2c4 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 2da:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 2dc:	00001a17          	auipc	s4,0x1
 2e0:	b74a0a13          	add	s4,s4,-1164 # e50 <malloc+0x12a>
    a_n += 1;
 2e4:	00001917          	auipc	s2,0x1
 2e8:	c6c90913          	add	s2,s2,-916 # f50 <a_n>
  for (i = 0; i < 100; i++) {
 2ec:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 2f0:	85a6                	mv	a1,s1
 2f2:	8552                	mv	a0,s4
 2f4:	00001097          	auipc	ra,0x1
 2f8:	97a080e7          	jalr	-1670(ra) # c6e <printf>
    a_n += 1;
 2fc:	00092783          	lw	a5,0(s2)
 300:	2785                	addw	a5,a5,1
 302:	00f92023          	sw	a5,0(s2)
    thread_yield();
 306:	00000097          	auipc	ra,0x0
 30a:	f5a080e7          	jalr	-166(ra) # 260 <thread_yield>
  for (i = 0; i < 100; i++) {
 30e:	2485                	addw	s1,s1,1
 310:	ff3490e3          	bne	s1,s3,2f0 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 314:	00001597          	auipc	a1,0x1
 318:	c3c5a583          	lw	a1,-964(a1) # f50 <a_n>
 31c:	00001517          	auipc	a0,0x1
 320:	b4450513          	add	a0,a0,-1212 # e60 <malloc+0x13a>
 324:	00001097          	auipc	ra,0x1
 328:	94a080e7          	jalr	-1718(ra) # c6e <printf>

  current_thread->state = FREE;
 32c:	00001797          	auipc	a5,0x1
 330:	c3c7b783          	ld	a5,-964(a5) # f68 <current_thread>
 334:	6709                	lui	a4,0x2
 336:	97ba                	add	a5,a5,a4
 338:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 33c:	00000097          	auipc	ra,0x0
 340:	e54080e7          	jalr	-428(ra) # 190 <thread_schedule>
}
 344:	70a2                	ld	ra,40(sp)
 346:	7402                	ld	s0,32(sp)
 348:	64e2                	ld	s1,24(sp)
 34a:	6942                	ld	s2,16(sp)
 34c:	69a2                	ld	s3,8(sp)
 34e:	6a02                	ld	s4,0(sp)
 350:	6145                	add	sp,sp,48
 352:	8082                	ret

0000000000000354 <thread_b>:

void 
thread_b(void)
{
 354:	7179                	add	sp,sp,-48
 356:	f406                	sd	ra,40(sp)
 358:	f022                	sd	s0,32(sp)
 35a:	ec26                	sd	s1,24(sp)
 35c:	e84a                	sd	s2,16(sp)
 35e:	e44e                	sd	s3,8(sp)
 360:	e052                	sd	s4,0(sp)
 362:	1800                	add	s0,sp,48
  int i;
  printf("thread_b started\n");
 364:	00001517          	auipc	a0,0x1
 368:	b1c50513          	add	a0,a0,-1252 # e80 <malloc+0x15a>
 36c:	00001097          	auipc	ra,0x1
 370:	902080e7          	jalr	-1790(ra) # c6e <printf>
  b_started = 1;
 374:	4785                	li	a5,1
 376:	00001717          	auipc	a4,0x1
 37a:	bef72123          	sw	a5,-1054(a4) # f58 <b_started>
  while(a_started == 0 || c_started == 0)
 37e:	00001497          	auipc	s1,0x1
 382:	bde48493          	add	s1,s1,-1058 # f5c <a_started>
 386:	00001917          	auipc	s2,0x1
 38a:	bce90913          	add	s2,s2,-1074 # f54 <c_started>
 38e:	a029                	j	398 <thread_b+0x44>
    thread_yield();
 390:	00000097          	auipc	ra,0x0
 394:	ed0080e7          	jalr	-304(ra) # 260 <thread_yield>
  while(a_started == 0 || c_started == 0)
 398:	409c                	lw	a5,0(s1)
 39a:	2781                	sext.w	a5,a5
 39c:	dbf5                	beqz	a5,390 <thread_b+0x3c>
 39e:	00092783          	lw	a5,0(s2)
 3a2:	2781                	sext.w	a5,a5
 3a4:	d7f5                	beqz	a5,390 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 3a6:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 3a8:	00001a17          	auipc	s4,0x1
 3ac:	af0a0a13          	add	s4,s4,-1296 # e98 <malloc+0x172>
    b_n += 1;
 3b0:	00001917          	auipc	s2,0x1
 3b4:	b9c90913          	add	s2,s2,-1124 # f4c <b_n>
  for (i = 0; i < 100; i++) {
 3b8:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 3bc:	85a6                	mv	a1,s1
 3be:	8552                	mv	a0,s4
 3c0:	00001097          	auipc	ra,0x1
 3c4:	8ae080e7          	jalr	-1874(ra) # c6e <printf>
    b_n += 1;
 3c8:	00092783          	lw	a5,0(s2)
 3cc:	2785                	addw	a5,a5,1
 3ce:	00f92023          	sw	a5,0(s2)
    thread_yield();
 3d2:	00000097          	auipc	ra,0x0
 3d6:	e8e080e7          	jalr	-370(ra) # 260 <thread_yield>
  for (i = 0; i < 100; i++) {
 3da:	2485                	addw	s1,s1,1
 3dc:	ff3490e3          	bne	s1,s3,3bc <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 3e0:	00001597          	auipc	a1,0x1
 3e4:	b6c5a583          	lw	a1,-1172(a1) # f4c <b_n>
 3e8:	00001517          	auipc	a0,0x1
 3ec:	ac050513          	add	a0,a0,-1344 # ea8 <malloc+0x182>
 3f0:	00001097          	auipc	ra,0x1
 3f4:	87e080e7          	jalr	-1922(ra) # c6e <printf>

  current_thread->state = FREE;
 3f8:	00001797          	auipc	a5,0x1
 3fc:	b707b783          	ld	a5,-1168(a5) # f68 <current_thread>
 400:	6709                	lui	a4,0x2
 402:	97ba                	add	a5,a5,a4
 404:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 408:	00000097          	auipc	ra,0x0
 40c:	d88080e7          	jalr	-632(ra) # 190 <thread_schedule>
}
 410:	70a2                	ld	ra,40(sp)
 412:	7402                	ld	s0,32(sp)
 414:	64e2                	ld	s1,24(sp)
 416:	6942                	ld	s2,16(sp)
 418:	69a2                	ld	s3,8(sp)
 41a:	6a02                	ld	s4,0(sp)
 41c:	6145                	add	sp,sp,48
 41e:	8082                	ret

0000000000000420 <thread_c>:

void 
thread_c(void)
{
 420:	7179                	add	sp,sp,-48
 422:	f406                	sd	ra,40(sp)
 424:	f022                	sd	s0,32(sp)
 426:	ec26                	sd	s1,24(sp)
 428:	e84a                	sd	s2,16(sp)
 42a:	e44e                	sd	s3,8(sp)
 42c:	e052                	sd	s4,0(sp)
 42e:	1800                	add	s0,sp,48
  int i;
  printf("thread_c started\n");
 430:	00001517          	auipc	a0,0x1
 434:	a9850513          	add	a0,a0,-1384 # ec8 <malloc+0x1a2>
 438:	00001097          	auipc	ra,0x1
 43c:	836080e7          	jalr	-1994(ra) # c6e <printf>
  c_started = 1;
 440:	4785                	li	a5,1
 442:	00001717          	auipc	a4,0x1
 446:	b0f72923          	sw	a5,-1262(a4) # f54 <c_started>
  while(a_started == 0 || b_started == 0)
 44a:	00001497          	auipc	s1,0x1
 44e:	b1248493          	add	s1,s1,-1262 # f5c <a_started>
 452:	00001917          	auipc	s2,0x1
 456:	b0690913          	add	s2,s2,-1274 # f58 <b_started>
 45a:	a029                	j	464 <thread_c+0x44>
    thread_yield();
 45c:	00000097          	auipc	ra,0x0
 460:	e04080e7          	jalr	-508(ra) # 260 <thread_yield>
  while(a_started == 0 || b_started == 0)
 464:	409c                	lw	a5,0(s1)
 466:	2781                	sext.w	a5,a5
 468:	dbf5                	beqz	a5,45c <thread_c+0x3c>
 46a:	00092783          	lw	a5,0(s2)
 46e:	2781                	sext.w	a5,a5
 470:	d7f5                	beqz	a5,45c <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 472:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 474:	00001a17          	auipc	s4,0x1
 478:	a6ca0a13          	add	s4,s4,-1428 # ee0 <malloc+0x1ba>
    c_n += 1;
 47c:	00001917          	auipc	s2,0x1
 480:	acc90913          	add	s2,s2,-1332 # f48 <c_n>
  for (i = 0; i < 100; i++) {
 484:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 488:	85a6                	mv	a1,s1
 48a:	8552                	mv	a0,s4
 48c:	00000097          	auipc	ra,0x0
 490:	7e2080e7          	jalr	2018(ra) # c6e <printf>
    c_n += 1;
 494:	00092783          	lw	a5,0(s2)
 498:	2785                	addw	a5,a5,1
 49a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 49e:	00000097          	auipc	ra,0x0
 4a2:	dc2080e7          	jalr	-574(ra) # 260 <thread_yield>
  for (i = 0; i < 100; i++) {
 4a6:	2485                	addw	s1,s1,1
 4a8:	ff3490e3          	bne	s1,s3,488 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 4ac:	00001597          	auipc	a1,0x1
 4b0:	a9c5a583          	lw	a1,-1380(a1) # f48 <c_n>
 4b4:	00001517          	auipc	a0,0x1
 4b8:	a3c50513          	add	a0,a0,-1476 # ef0 <malloc+0x1ca>
 4bc:	00000097          	auipc	ra,0x0
 4c0:	7b2080e7          	jalr	1970(ra) # c6e <printf>

  current_thread->state = FREE;
 4c4:	00001797          	auipc	a5,0x1
 4c8:	aa47b783          	ld	a5,-1372(a5) # f68 <current_thread>
 4cc:	6709                	lui	a4,0x2
 4ce:	97ba                	add	a5,a5,a4
 4d0:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 4d4:	00000097          	auipc	ra,0x0
 4d8:	cbc080e7          	jalr	-836(ra) # 190 <thread_schedule>
}
 4dc:	70a2                	ld	ra,40(sp)
 4de:	7402                	ld	s0,32(sp)
 4e0:	64e2                	ld	s1,24(sp)
 4e2:	6942                	ld	s2,16(sp)
 4e4:	69a2                	ld	s3,8(sp)
 4e6:	6a02                	ld	s4,0(sp)
 4e8:	6145                	add	sp,sp,48
 4ea:	8082                	ret

00000000000004ec <mtx_create>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_create(int locked){
   int locked_id;
   if (m_count > MUTEX_SIZE){
 4ec:	00001717          	auipc	a4,0x1
 4f0:	a7472703          	lw	a4,-1420(a4) # f60 <m_count>
 4f4:	10000793          	li	a5,256
 4f8:	02e7cc63          	blt	a5,a4,530 <mtx_create+0x44>
int mtx_create(int locked){
 4fc:	1101                	add	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	e426                	sd	s1,8(sp)
 504:	1000                	add	s0,sp,32
 506:	84aa                	mv	s1,a0
	return -1;
   }
   mutex_t *m = (mutex_t *)malloc(sizeof(mutex_t));
 508:	4511                	li	a0,4
 50a:	00001097          	auipc	ra,0x1
 50e:	81c080e7          	jalr	-2020(ra) # d26 <malloc>

   if (m == NULL){
 512:	c10d                	beqz	a0,534 <mtx_create+0x48>
	return -1;
   }
   m->locked = locked;
 514:	c104                	sw	s1,0(a0)

   locked_id = m_count++;
 516:	00001797          	auipc	a5,0x1
 51a:	a4a78793          	add	a5,a5,-1462 # f60 <m_count>
 51e:	4388                	lw	a0,0(a5)
 520:	0015071b          	addw	a4,a0,1
 524:	c398                	sw	a4,0(a5)
   return locked_id;
}
 526:	60e2                	ld	ra,24(sp)
 528:	6442                	ld	s0,16(sp)
 52a:	64a2                	ld	s1,8(sp)
 52c:	6105                	add	sp,sp,32
 52e:	8082                	ret
	return -1;
 530:	557d                	li	a0,-1
}
 532:	8082                	ret
	return -1;
 534:	557d                	li	a0,-1
 536:	bfc5                	j	526 <mtx_create+0x3a>

0000000000000538 <mtx_lock>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_lock(int lock_id){
 538:	1141                	add	sp,sp,-16
 53a:	e422                	sd	s0,8(sp)
 53c:	0800                	add	s0,sp,16
    mutex_t * m = all_m[lock_id];
 53e:	050e                	sll	a0,a0,0x3
 540:	00001797          	auipc	a5,0x1
 544:	a6078793          	add	a5,a5,-1440 # fa0 <all_m>
 548:	97aa                	add	a5,a5,a0

    while (m->locked);
 54a:	639c                	ld	a5,0(a5)
 54c:	439c                	lw	a5,0(a5)
 54e:	e381                	bnez	a5,54e <mtx_lock+0x16>
    m->locked = 0; /* Unlock the lock */
    return 0;
}
 550:	4501                	li	a0,0
 552:	6422                	ld	s0,8(sp)
 554:	0141                	add	sp,sp,16
 556:	8082                	ret

0000000000000558 <mtx_unlock>:


/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_unlock(int lock_id){
 558:	1141                	add	sp,sp,-16
 55a:	e422                	sd	s0,8(sp)
 55c:	0800                	add	s0,sp,16
    mutex_t * m = all_m[lock_id];
 55e:	050e                	sll	a0,a0,0x3
 560:	00001797          	auipc	a5,0x1
 564:	a4078793          	add	a5,a5,-1472 # fa0 <all_m>
 568:	97aa                	add	a5,a5,a0
 56a:	639c                	ld	a5,0(a5)
    while (m->locked){
 56c:	4388                	lw	a0,0(a5)
 56e:	e511                	bnez	a0,57a <mtx_unlock+0x22>
	return -1;
    }
    
    m->locked = 1;
 570:	4705                	li	a4,1
 572:	c398                	sw	a4,0(a5)
    return 0;
}
 574:	6422                	ld	s0,8(sp)
 576:	0141                	add	sp,sp,16
 578:	8082                	ret
	return -1;
 57a:	557d                	li	a0,-1
 57c:	bfe5                	j	574 <mtx_unlock+0x1c>

000000000000057e <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 57e:	1141                	add	sp,sp,-16
 580:	e406                	sd	ra,8(sp)
 582:	e022                	sd	s0,0(sp)
 584:	0800                	add	s0,sp,16
  extern int main();
  main();
 586:	00000097          	auipc	ra,0x0
 58a:	b2e080e7          	jalr	-1234(ra) # b4 <main>
  exit(0);
 58e:	4501                	li	a0,0
 590:	00000097          	auipc	ra,0x0
 594:	274080e7          	jalr	628(ra) # 804 <exit>

0000000000000598 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 598:	1141                	add	sp,sp,-16
 59a:	e422                	sd	s0,8(sp)
 59c:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 59e:	87aa                	mv	a5,a0
 5a0:	0585                	add	a1,a1,1
 5a2:	0785                	add	a5,a5,1
 5a4:	fff5c703          	lbu	a4,-1(a1)
 5a8:	fee78fa3          	sb	a4,-1(a5)
 5ac:	fb75                	bnez	a4,5a0 <strcpy+0x8>
    ;
  return os;
}
 5ae:	6422                	ld	s0,8(sp)
 5b0:	0141                	add	sp,sp,16
 5b2:	8082                	ret

00000000000005b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5b4:	1141                	add	sp,sp,-16
 5b6:	e422                	sd	s0,8(sp)
 5b8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 5ba:	00054783          	lbu	a5,0(a0)
 5be:	cb91                	beqz	a5,5d2 <strcmp+0x1e>
 5c0:	0005c703          	lbu	a4,0(a1)
 5c4:	00f71763          	bne	a4,a5,5d2 <strcmp+0x1e>
    p++, q++;
 5c8:	0505                	add	a0,a0,1
 5ca:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 5cc:	00054783          	lbu	a5,0(a0)
 5d0:	fbe5                	bnez	a5,5c0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 5d2:	0005c503          	lbu	a0,0(a1)
}
 5d6:	40a7853b          	subw	a0,a5,a0
 5da:	6422                	ld	s0,8(sp)
 5dc:	0141                	add	sp,sp,16
 5de:	8082                	ret

00000000000005e0 <strlen>:

uint
strlen(const char *s)
{
 5e0:	1141                	add	sp,sp,-16
 5e2:	e422                	sd	s0,8(sp)
 5e4:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5e6:	00054783          	lbu	a5,0(a0)
 5ea:	cf91                	beqz	a5,606 <strlen+0x26>
 5ec:	0505                	add	a0,a0,1
 5ee:	87aa                	mv	a5,a0
 5f0:	86be                	mv	a3,a5
 5f2:	0785                	add	a5,a5,1
 5f4:	fff7c703          	lbu	a4,-1(a5)
 5f8:	ff65                	bnez	a4,5f0 <strlen+0x10>
 5fa:	40a6853b          	subw	a0,a3,a0
 5fe:	2505                	addw	a0,a0,1
    ;
  return n;
}
 600:	6422                	ld	s0,8(sp)
 602:	0141                	add	sp,sp,16
 604:	8082                	ret
  for(n = 0; s[n]; n++)
 606:	4501                	li	a0,0
 608:	bfe5                	j	600 <strlen+0x20>

000000000000060a <memset>:

void*
memset(void *dst, int c, uint n)
{
 60a:	1141                	add	sp,sp,-16
 60c:	e422                	sd	s0,8(sp)
 60e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 610:	ca19                	beqz	a2,626 <memset+0x1c>
 612:	87aa                	mv	a5,a0
 614:	1602                	sll	a2,a2,0x20
 616:	9201                	srl	a2,a2,0x20
 618:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 61c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 620:	0785                	add	a5,a5,1
 622:	fee79de3          	bne	a5,a4,61c <memset+0x12>
  }
  return dst;
}
 626:	6422                	ld	s0,8(sp)
 628:	0141                	add	sp,sp,16
 62a:	8082                	ret

000000000000062c <strchr>:

char*
strchr(const char *s, char c)
{
 62c:	1141                	add	sp,sp,-16
 62e:	e422                	sd	s0,8(sp)
 630:	0800                	add	s0,sp,16
  for(; *s; s++)
 632:	00054783          	lbu	a5,0(a0)
 636:	cb99                	beqz	a5,64c <strchr+0x20>
    if(*s == c)
 638:	00f58763          	beq	a1,a5,646 <strchr+0x1a>
  for(; *s; s++)
 63c:	0505                	add	a0,a0,1
 63e:	00054783          	lbu	a5,0(a0)
 642:	fbfd                	bnez	a5,638 <strchr+0xc>
      return (char*)s;
  return 0;
 644:	4501                	li	a0,0
}
 646:	6422                	ld	s0,8(sp)
 648:	0141                	add	sp,sp,16
 64a:	8082                	ret
  return 0;
 64c:	4501                	li	a0,0
 64e:	bfe5                	j	646 <strchr+0x1a>

0000000000000650 <gets>:

char*
gets(char *buf, int max)
{
 650:	711d                	add	sp,sp,-96
 652:	ec86                	sd	ra,88(sp)
 654:	e8a2                	sd	s0,80(sp)
 656:	e4a6                	sd	s1,72(sp)
 658:	e0ca                	sd	s2,64(sp)
 65a:	fc4e                	sd	s3,56(sp)
 65c:	f852                	sd	s4,48(sp)
 65e:	f456                	sd	s5,40(sp)
 660:	f05a                	sd	s6,32(sp)
 662:	ec5e                	sd	s7,24(sp)
 664:	1080                	add	s0,sp,96
 666:	8baa                	mv	s7,a0
 668:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 66a:	892a                	mv	s2,a0
 66c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 66e:	4aa9                	li	s5,10
 670:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 672:	89a6                	mv	s3,s1
 674:	2485                	addw	s1,s1,1
 676:	0344d863          	bge	s1,s4,6a6 <gets+0x56>
    cc = read(0, &c, 1);
 67a:	4605                	li	a2,1
 67c:	faf40593          	add	a1,s0,-81
 680:	4501                	li	a0,0
 682:	00000097          	auipc	ra,0x0
 686:	19a080e7          	jalr	410(ra) # 81c <read>
    if(cc < 1)
 68a:	00a05e63          	blez	a0,6a6 <gets+0x56>
    buf[i++] = c;
 68e:	faf44783          	lbu	a5,-81(s0)
 692:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 696:	01578763          	beq	a5,s5,6a4 <gets+0x54>
 69a:	0905                	add	s2,s2,1
 69c:	fd679be3          	bne	a5,s6,672 <gets+0x22>
  for(i=0; i+1 < max; ){
 6a0:	89a6                	mv	s3,s1
 6a2:	a011                	j	6a6 <gets+0x56>
 6a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 6a6:	99de                	add	s3,s3,s7
 6a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 6ac:	855e                	mv	a0,s7
 6ae:	60e6                	ld	ra,88(sp)
 6b0:	6446                	ld	s0,80(sp)
 6b2:	64a6                	ld	s1,72(sp)
 6b4:	6906                	ld	s2,64(sp)
 6b6:	79e2                	ld	s3,56(sp)
 6b8:	7a42                	ld	s4,48(sp)
 6ba:	7aa2                	ld	s5,40(sp)
 6bc:	7b02                	ld	s6,32(sp)
 6be:	6be2                	ld	s7,24(sp)
 6c0:	6125                	add	sp,sp,96
 6c2:	8082                	ret

00000000000006c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 6c4:	1101                	add	sp,sp,-32
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	e426                	sd	s1,8(sp)
 6cc:	e04a                	sd	s2,0(sp)
 6ce:	1000                	add	s0,sp,32
 6d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6d2:	4581                	li	a1,0
 6d4:	00000097          	auipc	ra,0x0
 6d8:	170080e7          	jalr	368(ra) # 844 <open>
  if(fd < 0)
 6dc:	02054563          	bltz	a0,706 <stat+0x42>
 6e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6e2:	85ca                	mv	a1,s2
 6e4:	00000097          	auipc	ra,0x0
 6e8:	178080e7          	jalr	376(ra) # 85c <fstat>
 6ec:	892a                	mv	s2,a0
  close(fd);
 6ee:	8526                	mv	a0,s1
 6f0:	00000097          	auipc	ra,0x0
 6f4:	13c080e7          	jalr	316(ra) # 82c <close>
  return r;
}
 6f8:	854a                	mv	a0,s2
 6fa:	60e2                	ld	ra,24(sp)
 6fc:	6442                	ld	s0,16(sp)
 6fe:	64a2                	ld	s1,8(sp)
 700:	6902                	ld	s2,0(sp)
 702:	6105                	add	sp,sp,32
 704:	8082                	ret
    return -1;
 706:	597d                	li	s2,-1
 708:	bfc5                	j	6f8 <stat+0x34>

000000000000070a <atoi>:

int
atoi(const char *s)
{
 70a:	1141                	add	sp,sp,-16
 70c:	e422                	sd	s0,8(sp)
 70e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 710:	00054683          	lbu	a3,0(a0)
 714:	fd06879b          	addw	a5,a3,-48 # 1fd0 <all_thread+0x830>
 718:	0ff7f793          	zext.b	a5,a5
 71c:	4625                	li	a2,9
 71e:	02f66863          	bltu	a2,a5,74e <atoi+0x44>
 722:	872a                	mv	a4,a0
  n = 0;
 724:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 726:	0705                	add	a4,a4,1
 728:	0025179b          	sllw	a5,a0,0x2
 72c:	9fa9                	addw	a5,a5,a0
 72e:	0017979b          	sllw	a5,a5,0x1
 732:	9fb5                	addw	a5,a5,a3
 734:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 738:	00074683          	lbu	a3,0(a4)
 73c:	fd06879b          	addw	a5,a3,-48
 740:	0ff7f793          	zext.b	a5,a5
 744:	fef671e3          	bgeu	a2,a5,726 <atoi+0x1c>
  return n;
}
 748:	6422                	ld	s0,8(sp)
 74a:	0141                	add	sp,sp,16
 74c:	8082                	ret
  n = 0;
 74e:	4501                	li	a0,0
 750:	bfe5                	j	748 <atoi+0x3e>

0000000000000752 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 752:	1141                	add	sp,sp,-16
 754:	e422                	sd	s0,8(sp)
 756:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 758:	02b57463          	bgeu	a0,a1,780 <memmove+0x2e>
    while(n-- > 0)
 75c:	00c05f63          	blez	a2,77a <memmove+0x28>
 760:	1602                	sll	a2,a2,0x20
 762:	9201                	srl	a2,a2,0x20
 764:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 768:	872a                	mv	a4,a0
      *dst++ = *src++;
 76a:	0585                	add	a1,a1,1
 76c:	0705                	add	a4,a4,1
 76e:	fff5c683          	lbu	a3,-1(a1)
 772:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 776:	fee79ae3          	bne	a5,a4,76a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 77a:	6422                	ld	s0,8(sp)
 77c:	0141                	add	sp,sp,16
 77e:	8082                	ret
    dst += n;
 780:	00c50733          	add	a4,a0,a2
    src += n;
 784:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 786:	fec05ae3          	blez	a2,77a <memmove+0x28>
 78a:	fff6079b          	addw	a5,a2,-1
 78e:	1782                	sll	a5,a5,0x20
 790:	9381                	srl	a5,a5,0x20
 792:	fff7c793          	not	a5,a5
 796:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 798:	15fd                	add	a1,a1,-1
 79a:	177d                	add	a4,a4,-1
 79c:	0005c683          	lbu	a3,0(a1)
 7a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 7a4:	fee79ae3          	bne	a5,a4,798 <memmove+0x46>
 7a8:	bfc9                	j	77a <memmove+0x28>

00000000000007aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 7aa:	1141                	add	sp,sp,-16
 7ac:	e422                	sd	s0,8(sp)
 7ae:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 7b0:	ca05                	beqz	a2,7e0 <memcmp+0x36>
 7b2:	fff6069b          	addw	a3,a2,-1
 7b6:	1682                	sll	a3,a3,0x20
 7b8:	9281                	srl	a3,a3,0x20
 7ba:	0685                	add	a3,a3,1
 7bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 7be:	00054783          	lbu	a5,0(a0)
 7c2:	0005c703          	lbu	a4,0(a1)
 7c6:	00e79863          	bne	a5,a4,7d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 7ca:	0505                	add	a0,a0,1
    p2++;
 7cc:	0585                	add	a1,a1,1
  while (n-- > 0) {
 7ce:	fed518e3          	bne	a0,a3,7be <memcmp+0x14>
  }
  return 0;
 7d2:	4501                	li	a0,0
 7d4:	a019                	j	7da <memcmp+0x30>
      return *p1 - *p2;
 7d6:	40e7853b          	subw	a0,a5,a4
}
 7da:	6422                	ld	s0,8(sp)
 7dc:	0141                	add	sp,sp,16
 7de:	8082                	ret
  return 0;
 7e0:	4501                	li	a0,0
 7e2:	bfe5                	j	7da <memcmp+0x30>

00000000000007e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7e4:	1141                	add	sp,sp,-16
 7e6:	e406                	sd	ra,8(sp)
 7e8:	e022                	sd	s0,0(sp)
 7ea:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 7ec:	00000097          	auipc	ra,0x0
 7f0:	f66080e7          	jalr	-154(ra) # 752 <memmove>
}
 7f4:	60a2                	ld	ra,8(sp)
 7f6:	6402                	ld	s0,0(sp)
 7f8:	0141                	add	sp,sp,16
 7fa:	8082                	ret

00000000000007fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7fc:	4885                	li	a7,1
 ecall
 7fe:	00000073          	ecall
 ret
 802:	8082                	ret

0000000000000804 <exit>:
.global exit
exit:
 li a7, SYS_exit
 804:	4889                	li	a7,2
 ecall
 806:	00000073          	ecall
 ret
 80a:	8082                	ret

000000000000080c <wait>:
.global wait
wait:
 li a7, SYS_wait
 80c:	488d                	li	a7,3
 ecall
 80e:	00000073          	ecall
 ret
 812:	8082                	ret

0000000000000814 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 814:	4891                	li	a7,4
 ecall
 816:	00000073          	ecall
 ret
 81a:	8082                	ret

000000000000081c <read>:
.global read
read:
 li a7, SYS_read
 81c:	4895                	li	a7,5
 ecall
 81e:	00000073          	ecall
 ret
 822:	8082                	ret

0000000000000824 <write>:
.global write
write:
 li a7, SYS_write
 824:	48c1                	li	a7,16
 ecall
 826:	00000073          	ecall
 ret
 82a:	8082                	ret

000000000000082c <close>:
.global close
close:
 li a7, SYS_close
 82c:	48d5                	li	a7,21
 ecall
 82e:	00000073          	ecall
 ret
 832:	8082                	ret

0000000000000834 <kill>:
.global kill
kill:
 li a7, SYS_kill
 834:	4899                	li	a7,6
 ecall
 836:	00000073          	ecall
 ret
 83a:	8082                	ret

000000000000083c <exec>:
.global exec
exec:
 li a7, SYS_exec
 83c:	489d                	li	a7,7
 ecall
 83e:	00000073          	ecall
 ret
 842:	8082                	ret

0000000000000844 <open>:
.global open
open:
 li a7, SYS_open
 844:	48bd                	li	a7,15
 ecall
 846:	00000073          	ecall
 ret
 84a:	8082                	ret

000000000000084c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 84c:	48c5                	li	a7,17
 ecall
 84e:	00000073          	ecall
 ret
 852:	8082                	ret

0000000000000854 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 854:	48c9                	li	a7,18
 ecall
 856:	00000073          	ecall
 ret
 85a:	8082                	ret

000000000000085c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 85c:	48a1                	li	a7,8
 ecall
 85e:	00000073          	ecall
 ret
 862:	8082                	ret

0000000000000864 <link>:
.global link
link:
 li a7, SYS_link
 864:	48cd                	li	a7,19
 ecall
 866:	00000073          	ecall
 ret
 86a:	8082                	ret

000000000000086c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 86c:	48d1                	li	a7,20
 ecall
 86e:	00000073          	ecall
 ret
 872:	8082                	ret

0000000000000874 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 874:	48a5                	li	a7,9
 ecall
 876:	00000073          	ecall
 ret
 87a:	8082                	ret

000000000000087c <dup>:
.global dup
dup:
 li a7, SYS_dup
 87c:	48a9                	li	a7,10
 ecall
 87e:	00000073          	ecall
 ret
 882:	8082                	ret

0000000000000884 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 884:	48ad                	li	a7,11
 ecall
 886:	00000073          	ecall
 ret
 88a:	8082                	ret

000000000000088c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 88c:	48b1                	li	a7,12
 ecall
 88e:	00000073          	ecall
 ret
 892:	8082                	ret

0000000000000894 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 894:	48b5                	li	a7,13
 ecall
 896:	00000073          	ecall
 ret
 89a:	8082                	ret

000000000000089c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 89c:	48b9                	li	a7,14
 ecall
 89e:	00000073          	ecall
 ret
 8a2:	8082                	ret

00000000000008a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8a4:	1101                	add	sp,sp,-32
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	add	s0,sp,32
 8ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8b0:	4605                	li	a2,1
 8b2:	fef40593          	add	a1,s0,-17
 8b6:	00000097          	auipc	ra,0x0
 8ba:	f6e080e7          	jalr	-146(ra) # 824 <write>
}
 8be:	60e2                	ld	ra,24(sp)
 8c0:	6442                	ld	s0,16(sp)
 8c2:	6105                	add	sp,sp,32
 8c4:	8082                	ret

00000000000008c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8c6:	7139                	add	sp,sp,-64
 8c8:	fc06                	sd	ra,56(sp)
 8ca:	f822                	sd	s0,48(sp)
 8cc:	f426                	sd	s1,40(sp)
 8ce:	f04a                	sd	s2,32(sp)
 8d0:	ec4e                	sd	s3,24(sp)
 8d2:	0080                	add	s0,sp,64
 8d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8d6:	c299                	beqz	a3,8dc <printint+0x16>
 8d8:	0805c963          	bltz	a1,96a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8dc:	2581                	sext.w	a1,a1
  neg = 0;
 8de:	4881                	li	a7,0
 8e0:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 8e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8e6:	2601                	sext.w	a2,a2
 8e8:	00000517          	auipc	a0,0x0
 8ec:	63050513          	add	a0,a0,1584 # f18 <digits>
 8f0:	883a                	mv	a6,a4
 8f2:	2705                	addw	a4,a4,1
 8f4:	02c5f7bb          	remuw	a5,a1,a2
 8f8:	1782                	sll	a5,a5,0x20
 8fa:	9381                	srl	a5,a5,0x20
 8fc:	97aa                	add	a5,a5,a0
 8fe:	0007c783          	lbu	a5,0(a5)
 902:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 906:	0005879b          	sext.w	a5,a1
 90a:	02c5d5bb          	divuw	a1,a1,a2
 90e:	0685                	add	a3,a3,1
 910:	fec7f0e3          	bgeu	a5,a2,8f0 <printint+0x2a>
  if(neg)
 914:	00088c63          	beqz	a7,92c <printint+0x66>
    buf[i++] = '-';
 918:	fd070793          	add	a5,a4,-48
 91c:	00878733          	add	a4,a5,s0
 920:	02d00793          	li	a5,45
 924:	fef70823          	sb	a5,-16(a4)
 928:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 92c:	02e05863          	blez	a4,95c <printint+0x96>
 930:	fc040793          	add	a5,s0,-64
 934:	00e78933          	add	s2,a5,a4
 938:	fff78993          	add	s3,a5,-1
 93c:	99ba                	add	s3,s3,a4
 93e:	377d                	addw	a4,a4,-1
 940:	1702                	sll	a4,a4,0x20
 942:	9301                	srl	a4,a4,0x20
 944:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 948:	fff94583          	lbu	a1,-1(s2)
 94c:	8526                	mv	a0,s1
 94e:	00000097          	auipc	ra,0x0
 952:	f56080e7          	jalr	-170(ra) # 8a4 <putc>
  while(--i >= 0)
 956:	197d                	add	s2,s2,-1
 958:	ff3918e3          	bne	s2,s3,948 <printint+0x82>
}
 95c:	70e2                	ld	ra,56(sp)
 95e:	7442                	ld	s0,48(sp)
 960:	74a2                	ld	s1,40(sp)
 962:	7902                	ld	s2,32(sp)
 964:	69e2                	ld	s3,24(sp)
 966:	6121                	add	sp,sp,64
 968:	8082                	ret
    x = -xx;
 96a:	40b005bb          	negw	a1,a1
    neg = 1;
 96e:	4885                	li	a7,1
    x = -xx;
 970:	bf85                	j	8e0 <printint+0x1a>

0000000000000972 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 972:	711d                	add	sp,sp,-96
 974:	ec86                	sd	ra,88(sp)
 976:	e8a2                	sd	s0,80(sp)
 978:	e4a6                	sd	s1,72(sp)
 97a:	e0ca                	sd	s2,64(sp)
 97c:	fc4e                	sd	s3,56(sp)
 97e:	f852                	sd	s4,48(sp)
 980:	f456                	sd	s5,40(sp)
 982:	f05a                	sd	s6,32(sp)
 984:	ec5e                	sd	s7,24(sp)
 986:	e862                	sd	s8,16(sp)
 988:	e466                	sd	s9,8(sp)
 98a:	e06a                	sd	s10,0(sp)
 98c:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 98e:	0005c903          	lbu	s2,0(a1)
 992:	28090963          	beqz	s2,c24 <vprintf+0x2b2>
 996:	8b2a                	mv	s6,a0
 998:	8a2e                	mv	s4,a1
 99a:	8bb2                	mv	s7,a2
  state = 0;
 99c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 99e:	4481                	li	s1,0
 9a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 9a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 9a6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 9aa:	06c00c93          	li	s9,108
 9ae:	a015                	j	9d2 <vprintf+0x60>
        putc(fd, c0);
 9b0:	85ca                	mv	a1,s2
 9b2:	855a                	mv	a0,s6
 9b4:	00000097          	auipc	ra,0x0
 9b8:	ef0080e7          	jalr	-272(ra) # 8a4 <putc>
 9bc:	a019                	j	9c2 <vprintf+0x50>
    } else if(state == '%'){
 9be:	03598263          	beq	s3,s5,9e2 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 9c2:	2485                	addw	s1,s1,1
 9c4:	8726                	mv	a4,s1
 9c6:	009a07b3          	add	a5,s4,s1
 9ca:	0007c903          	lbu	s2,0(a5)
 9ce:	24090b63          	beqz	s2,c24 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 9d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9d6:	fe0994e3          	bnez	s3,9be <vprintf+0x4c>
      if(c0 == '%'){
 9da:	fd579be3          	bne	a5,s5,9b0 <vprintf+0x3e>
        state = '%';
 9de:	89be                	mv	s3,a5
 9e0:	b7cd                	j	9c2 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 9e2:	cbc9                	beqz	a5,a74 <vprintf+0x102>
 9e4:	00ea06b3          	add	a3,s4,a4
 9e8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 9ec:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 9ee:	c681                	beqz	a3,9f6 <vprintf+0x84>
 9f0:	9752                	add	a4,a4,s4
 9f2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9f6:	05878163          	beq	a5,s8,a38 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 9fa:	05978d63          	beq	a5,s9,a54 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9fe:	07500713          	li	a4,117
 a02:	10e78163          	beq	a5,a4,b04 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 a06:	07800713          	li	a4,120
 a0a:	14e78963          	beq	a5,a4,b5c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a0e:	07000713          	li	a4,112
 a12:	18e78263          	beq	a5,a4,b96 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 a16:	07300713          	li	a4,115
 a1a:	1ce78663          	beq	a5,a4,be6 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 a1e:	02500713          	li	a4,37
 a22:	04e79963          	bne	a5,a4,a74 <vprintf+0x102>
        putc(fd, '%');
 a26:	02500593          	li	a1,37
 a2a:	855a                	mv	a0,s6
 a2c:	00000097          	auipc	ra,0x0
 a30:	e78080e7          	jalr	-392(ra) # 8a4 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 a34:	4981                	li	s3,0
 a36:	b771                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 a38:	008b8913          	add	s2,s7,8
 a3c:	4685                	li	a3,1
 a3e:	4629                	li	a2,10
 a40:	000ba583          	lw	a1,0(s7)
 a44:	855a                	mv	a0,s6
 a46:	00000097          	auipc	ra,0x0
 a4a:	e80080e7          	jalr	-384(ra) # 8c6 <printint>
 a4e:	8bca                	mv	s7,s2
      state = 0;
 a50:	4981                	li	s3,0
 a52:	bf85                	j	9c2 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 a54:	06400793          	li	a5,100
 a58:	02f68d63          	beq	a3,a5,a92 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a5c:	06c00793          	li	a5,108
 a60:	04f68863          	beq	a3,a5,ab0 <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 a64:	07500793          	li	a5,117
 a68:	0af68c63          	beq	a3,a5,b20 <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 a6c:	07800793          	li	a5,120
 a70:	10f68463          	beq	a3,a5,b78 <vprintf+0x206>
        putc(fd, '%');
 a74:	02500593          	li	a1,37
 a78:	855a                	mv	a0,s6
 a7a:	00000097          	auipc	ra,0x0
 a7e:	e2a080e7          	jalr	-470(ra) # 8a4 <putc>
        putc(fd, c0);
 a82:	85ca                	mv	a1,s2
 a84:	855a                	mv	a0,s6
 a86:	00000097          	auipc	ra,0x0
 a8a:	e1e080e7          	jalr	-482(ra) # 8a4 <putc>
      state = 0;
 a8e:	4981                	li	s3,0
 a90:	bf0d                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a92:	008b8913          	add	s2,s7,8
 a96:	4685                	li	a3,1
 a98:	4629                	li	a2,10
 a9a:	000ba583          	lw	a1,0(s7)
 a9e:	855a                	mv	a0,s6
 aa0:	00000097          	auipc	ra,0x0
 aa4:	e26080e7          	jalr	-474(ra) # 8c6 <printint>
        i += 1;
 aa8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 aaa:	8bca                	mv	s7,s2
      state = 0;
 aac:	4981                	li	s3,0
        i += 1;
 aae:	bf11                	j	9c2 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 ab0:	06400793          	li	a5,100
 ab4:	02f60963          	beq	a2,a5,ae6 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 ab8:	07500793          	li	a5,117
 abc:	08f60163          	beq	a2,a5,b3e <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 ac0:	07800793          	li	a5,120
 ac4:	faf618e3          	bne	a2,a5,a74 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ac8:	008b8913          	add	s2,s7,8
 acc:	4681                	li	a3,0
 ace:	4641                	li	a2,16
 ad0:	000ba583          	lw	a1,0(s7)
 ad4:	855a                	mv	a0,s6
 ad6:	00000097          	auipc	ra,0x0
 ada:	df0080e7          	jalr	-528(ra) # 8c6 <printint>
        i += 2;
 ade:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 ae0:	8bca                	mv	s7,s2
      state = 0;
 ae2:	4981                	li	s3,0
        i += 2;
 ae4:	bdf9                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 ae6:	008b8913          	add	s2,s7,8
 aea:	4685                	li	a3,1
 aec:	4629                	li	a2,10
 aee:	000ba583          	lw	a1,0(s7)
 af2:	855a                	mv	a0,s6
 af4:	00000097          	auipc	ra,0x0
 af8:	dd2080e7          	jalr	-558(ra) # 8c6 <printint>
        i += 2;
 afc:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 afe:	8bca                	mv	s7,s2
      state = 0;
 b00:	4981                	li	s3,0
        i += 2;
 b02:	b5c1                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 b04:	008b8913          	add	s2,s7,8
 b08:	4681                	li	a3,0
 b0a:	4629                	li	a2,10
 b0c:	000ba583          	lw	a1,0(s7)
 b10:	855a                	mv	a0,s6
 b12:	00000097          	auipc	ra,0x0
 b16:	db4080e7          	jalr	-588(ra) # 8c6 <printint>
 b1a:	8bca                	mv	s7,s2
      state = 0;
 b1c:	4981                	li	s3,0
 b1e:	b555                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b20:	008b8913          	add	s2,s7,8
 b24:	4681                	li	a3,0
 b26:	4629                	li	a2,10
 b28:	000ba583          	lw	a1,0(s7)
 b2c:	855a                	mv	a0,s6
 b2e:	00000097          	auipc	ra,0x0
 b32:	d98080e7          	jalr	-616(ra) # 8c6 <printint>
        i += 1;
 b36:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b38:	8bca                	mv	s7,s2
      state = 0;
 b3a:	4981                	li	s3,0
        i += 1;
 b3c:	b559                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b3e:	008b8913          	add	s2,s7,8
 b42:	4681                	li	a3,0
 b44:	4629                	li	a2,10
 b46:	000ba583          	lw	a1,0(s7)
 b4a:	855a                	mv	a0,s6
 b4c:	00000097          	auipc	ra,0x0
 b50:	d7a080e7          	jalr	-646(ra) # 8c6 <printint>
        i += 2;
 b54:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b56:	8bca                	mv	s7,s2
      state = 0;
 b58:	4981                	li	s3,0
        i += 2;
 b5a:	b5a5                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 b5c:	008b8913          	add	s2,s7,8
 b60:	4681                	li	a3,0
 b62:	4641                	li	a2,16
 b64:	000ba583          	lw	a1,0(s7)
 b68:	855a                	mv	a0,s6
 b6a:	00000097          	auipc	ra,0x0
 b6e:	d5c080e7          	jalr	-676(ra) # 8c6 <printint>
 b72:	8bca                	mv	s7,s2
      state = 0;
 b74:	4981                	li	s3,0
 b76:	b5b1                	j	9c2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b78:	008b8913          	add	s2,s7,8
 b7c:	4681                	li	a3,0
 b7e:	4641                	li	a2,16
 b80:	000ba583          	lw	a1,0(s7)
 b84:	855a                	mv	a0,s6
 b86:	00000097          	auipc	ra,0x0
 b8a:	d40080e7          	jalr	-704(ra) # 8c6 <printint>
        i += 1;
 b8e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b90:	8bca                	mv	s7,s2
      state = 0;
 b92:	4981                	li	s3,0
        i += 1;
 b94:	b53d                	j	9c2 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 b96:	008b8d13          	add	s10,s7,8
 b9a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b9e:	03000593          	li	a1,48
 ba2:	855a                	mv	a0,s6
 ba4:	00000097          	auipc	ra,0x0
 ba8:	d00080e7          	jalr	-768(ra) # 8a4 <putc>
  putc(fd, 'x');
 bac:	07800593          	li	a1,120
 bb0:	855a                	mv	a0,s6
 bb2:	00000097          	auipc	ra,0x0
 bb6:	cf2080e7          	jalr	-782(ra) # 8a4 <putc>
 bba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bbc:	00000b97          	auipc	s7,0x0
 bc0:	35cb8b93          	add	s7,s7,860 # f18 <digits>
 bc4:	03c9d793          	srl	a5,s3,0x3c
 bc8:	97de                	add	a5,a5,s7
 bca:	0007c583          	lbu	a1,0(a5)
 bce:	855a                	mv	a0,s6
 bd0:	00000097          	auipc	ra,0x0
 bd4:	cd4080e7          	jalr	-812(ra) # 8a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bd8:	0992                	sll	s3,s3,0x4
 bda:	397d                	addw	s2,s2,-1
 bdc:	fe0914e3          	bnez	s2,bc4 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 be0:	8bea                	mv	s7,s10
      state = 0;
 be2:	4981                	li	s3,0
 be4:	bbf9                	j	9c2 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 be6:	008b8993          	add	s3,s7,8
 bea:	000bb903          	ld	s2,0(s7)
 bee:	02090163          	beqz	s2,c10 <vprintf+0x29e>
        for(; *s; s++)
 bf2:	00094583          	lbu	a1,0(s2)
 bf6:	c585                	beqz	a1,c1e <vprintf+0x2ac>
          putc(fd, *s);
 bf8:	855a                	mv	a0,s6
 bfa:	00000097          	auipc	ra,0x0
 bfe:	caa080e7          	jalr	-854(ra) # 8a4 <putc>
        for(; *s; s++)
 c02:	0905                	add	s2,s2,1
 c04:	00094583          	lbu	a1,0(s2)
 c08:	f9e5                	bnez	a1,bf8 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 c0a:	8bce                	mv	s7,s3
      state = 0;
 c0c:	4981                	li	s3,0
 c0e:	bb55                	j	9c2 <vprintf+0x50>
          s = "(null)";
 c10:	00000917          	auipc	s2,0x0
 c14:	30090913          	add	s2,s2,768 # f10 <malloc+0x1ea>
        for(; *s; s++)
 c18:	02800593          	li	a1,40
 c1c:	bff1                	j	bf8 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 c1e:	8bce                	mv	s7,s3
      state = 0;
 c20:	4981                	li	s3,0
 c22:	b345                	j	9c2 <vprintf+0x50>
    }
  }
}
 c24:	60e6                	ld	ra,88(sp)
 c26:	6446                	ld	s0,80(sp)
 c28:	64a6                	ld	s1,72(sp)
 c2a:	6906                	ld	s2,64(sp)
 c2c:	79e2                	ld	s3,56(sp)
 c2e:	7a42                	ld	s4,48(sp)
 c30:	7aa2                	ld	s5,40(sp)
 c32:	7b02                	ld	s6,32(sp)
 c34:	6be2                	ld	s7,24(sp)
 c36:	6c42                	ld	s8,16(sp)
 c38:	6ca2                	ld	s9,8(sp)
 c3a:	6d02                	ld	s10,0(sp)
 c3c:	6125                	add	sp,sp,96
 c3e:	8082                	ret

0000000000000c40 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c40:	715d                	add	sp,sp,-80
 c42:	ec06                	sd	ra,24(sp)
 c44:	e822                	sd	s0,16(sp)
 c46:	1000                	add	s0,sp,32
 c48:	e010                	sd	a2,0(s0)
 c4a:	e414                	sd	a3,8(s0)
 c4c:	e818                	sd	a4,16(s0)
 c4e:	ec1c                	sd	a5,24(s0)
 c50:	03043023          	sd	a6,32(s0)
 c54:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c58:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c5c:	8622                	mv	a2,s0
 c5e:	00000097          	auipc	ra,0x0
 c62:	d14080e7          	jalr	-748(ra) # 972 <vprintf>
}
 c66:	60e2                	ld	ra,24(sp)
 c68:	6442                	ld	s0,16(sp)
 c6a:	6161                	add	sp,sp,80
 c6c:	8082                	ret

0000000000000c6e <printf>:

void
printf(const char *fmt, ...)
{
 c6e:	711d                	add	sp,sp,-96
 c70:	ec06                	sd	ra,24(sp)
 c72:	e822                	sd	s0,16(sp)
 c74:	1000                	add	s0,sp,32
 c76:	e40c                	sd	a1,8(s0)
 c78:	e810                	sd	a2,16(s0)
 c7a:	ec14                	sd	a3,24(s0)
 c7c:	f018                	sd	a4,32(s0)
 c7e:	f41c                	sd	a5,40(s0)
 c80:	03043823          	sd	a6,48(s0)
 c84:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c88:	00840613          	add	a2,s0,8
 c8c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c90:	85aa                	mv	a1,a0
 c92:	4505                	li	a0,1
 c94:	00000097          	auipc	ra,0x0
 c98:	cde080e7          	jalr	-802(ra) # 972 <vprintf>
}
 c9c:	60e2                	ld	ra,24(sp)
 c9e:	6442                	ld	s0,16(sp)
 ca0:	6125                	add	sp,sp,96
 ca2:	8082                	ret

0000000000000ca4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ca4:	1141                	add	sp,sp,-16
 ca6:	e422                	sd	s0,8(sp)
 ca8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 caa:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cae:	00000797          	auipc	a5,0x0
 cb2:	2c27b783          	ld	a5,706(a5) # f70 <freep>
 cb6:	a02d                	j	ce0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cb8:	4618                	lw	a4,8(a2)
 cba:	9f2d                	addw	a4,a4,a1
 cbc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cc0:	6398                	ld	a4,0(a5)
 cc2:	6310                	ld	a2,0(a4)
 cc4:	a83d                	j	d02 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 cc6:	ff852703          	lw	a4,-8(a0)
 cca:	9f31                	addw	a4,a4,a2
 ccc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cce:	ff053683          	ld	a3,-16(a0)
 cd2:	a091                	j	d16 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cd4:	6398                	ld	a4,0(a5)
 cd6:	00e7e463          	bltu	a5,a4,cde <free+0x3a>
 cda:	00e6ea63          	bltu	a3,a4,cee <free+0x4a>
{
 cde:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ce0:	fed7fae3          	bgeu	a5,a3,cd4 <free+0x30>
 ce4:	6398                	ld	a4,0(a5)
 ce6:	00e6e463          	bltu	a3,a4,cee <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cea:	fee7eae3          	bltu	a5,a4,cde <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 cee:	ff852583          	lw	a1,-8(a0)
 cf2:	6390                	ld	a2,0(a5)
 cf4:	02059813          	sll	a6,a1,0x20
 cf8:	01c85713          	srl	a4,a6,0x1c
 cfc:	9736                	add	a4,a4,a3
 cfe:	fae60de3          	beq	a2,a4,cb8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d02:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d06:	4790                	lw	a2,8(a5)
 d08:	02061593          	sll	a1,a2,0x20
 d0c:	01c5d713          	srl	a4,a1,0x1c
 d10:	973e                	add	a4,a4,a5
 d12:	fae68ae3          	beq	a3,a4,cc6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d16:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d18:	00000717          	auipc	a4,0x0
 d1c:	24f73c23          	sd	a5,600(a4) # f70 <freep>
}
 d20:	6422                	ld	s0,8(sp)
 d22:	0141                	add	sp,sp,16
 d24:	8082                	ret

0000000000000d26 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d26:	7139                	add	sp,sp,-64
 d28:	fc06                	sd	ra,56(sp)
 d2a:	f822                	sd	s0,48(sp)
 d2c:	f426                	sd	s1,40(sp)
 d2e:	f04a                	sd	s2,32(sp)
 d30:	ec4e                	sd	s3,24(sp)
 d32:	e852                	sd	s4,16(sp)
 d34:	e456                	sd	s5,8(sp)
 d36:	e05a                	sd	s6,0(sp)
 d38:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d3a:	02051493          	sll	s1,a0,0x20
 d3e:	9081                	srl	s1,s1,0x20
 d40:	04bd                	add	s1,s1,15
 d42:	8091                	srl	s1,s1,0x4
 d44:	0014899b          	addw	s3,s1,1
 d48:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 d4a:	00000517          	auipc	a0,0x0
 d4e:	22653503          	ld	a0,550(a0) # f70 <freep>
 d52:	c515                	beqz	a0,d7e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d56:	4798                	lw	a4,8(a5)
 d58:	02977f63          	bgeu	a4,s1,d96 <malloc+0x70>
  if(nu < 4096)
 d5c:	8a4e                	mv	s4,s3
 d5e:	0009871b          	sext.w	a4,s3
 d62:	6685                	lui	a3,0x1
 d64:	00d77363          	bgeu	a4,a3,d6a <malloc+0x44>
 d68:	6a05                	lui	s4,0x1
 d6a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d6e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d72:	00000917          	auipc	s2,0x0
 d76:	1fe90913          	add	s2,s2,510 # f70 <freep>
  if(p == (char*)-1)
 d7a:	5afd                	li	s5,-1
 d7c:	a895                	j	df0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 d7e:	00009797          	auipc	a5,0x9
 d82:	c0278793          	add	a5,a5,-1022 # 9980 <base>
 d86:	00000717          	auipc	a4,0x0
 d8a:	1ef73523          	sd	a5,490(a4) # f70 <freep>
 d8e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d90:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d94:	b7e1                	j	d5c <malloc+0x36>
      if(p->s.size == nunits)
 d96:	02e48c63          	beq	s1,a4,dce <malloc+0xa8>
        p->s.size -= nunits;
 d9a:	4137073b          	subw	a4,a4,s3
 d9e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 da0:	02071693          	sll	a3,a4,0x20
 da4:	01c6d713          	srl	a4,a3,0x1c
 da8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 daa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dae:	00000717          	auipc	a4,0x0
 db2:	1ca73123          	sd	a0,450(a4) # f70 <freep>
      return (void*)(p + 1);
 db6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 dba:	70e2                	ld	ra,56(sp)
 dbc:	7442                	ld	s0,48(sp)
 dbe:	74a2                	ld	s1,40(sp)
 dc0:	7902                	ld	s2,32(sp)
 dc2:	69e2                	ld	s3,24(sp)
 dc4:	6a42                	ld	s4,16(sp)
 dc6:	6aa2                	ld	s5,8(sp)
 dc8:	6b02                	ld	s6,0(sp)
 dca:	6121                	add	sp,sp,64
 dcc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 dce:	6398                	ld	a4,0(a5)
 dd0:	e118                	sd	a4,0(a0)
 dd2:	bff1                	j	dae <malloc+0x88>
  hp->s.size = nu;
 dd4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 dd8:	0541                	add	a0,a0,16
 dda:	00000097          	auipc	ra,0x0
 dde:	eca080e7          	jalr	-310(ra) # ca4 <free>
  return freep;
 de2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 de6:	d971                	beqz	a0,dba <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 de8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dea:	4798                	lw	a4,8(a5)
 dec:	fa9775e3          	bgeu	a4,s1,d96 <malloc+0x70>
    if(p == freep)
 df0:	00093703          	ld	a4,0(s2)
 df4:	853e                	mv	a0,a5
 df6:	fef719e3          	bne	a4,a5,de8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 dfa:	8552                	mv	a0,s4
 dfc:	00000097          	auipc	ra,0x0
 e00:	a90080e7          	jalr	-1392(ra) # 88c <sbrk>
  if(p == (char*)-1)
 e04:	fd5518e3          	bne	a0,s5,dd4 <malloc+0xae>
        return 0;
 e08:	4501                	li	a0,0
 e0a:	bf45                	j	dba <malloc+0x94>
