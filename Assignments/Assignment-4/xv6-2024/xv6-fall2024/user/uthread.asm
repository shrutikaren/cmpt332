
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	add	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	e2278793          	add	a5,a5,-478 # e28 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	e0f73523          	sd	a5,-502(a4) # e18 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	e8f72023          	sw	a5,-384(a4) # 2e98 <__global_pointer$+0x189f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	add	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	add	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	add	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001517          	auipc	a0,0x1
  32:	dea53503          	ld	a0,-534(a0) # e18 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	add	a1,a1,120 # 2078 <__global_pointer$+0xa7f>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	fc880813          	add	a6,a6,-56 # 9008 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	add	a7,a3,120 # 2078 <__global_pointer$+0xa7f>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	5b38                	lw	a4,112(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	dc258593          	add	a1,a1,-574 # e28 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	c7050513          	add	a0,a0,-912 # ce0 <malloc+0xe8>
  78:	00001097          	auipc	ra,0x1
  7c:	ac8080e7          	jalr	-1336(ra) # b40 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	654080e7          	jalr	1620(ra) # 6d6 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	00b50e63          	beq	a0,a1,a6 <thread_schedule+0x80>
    next_thread->state = RUNNING;
  8e:	6789                	lui	a5,0x2
  90:	97ae                	add	a5,a5,a1
  92:	4705                	li	a4,1
  94:	dbb8                	sw	a4,112(a5)
    t = current_thread;
    current_thread = next_thread;
  96:	00001797          	auipc	a5,0x1
  9a:	d8b7b123          	sd	a1,-638(a5) # e18 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64) t, (uint64)next_thread);
  9e:	00000097          	auipc	ra,0x0
  a2:	366080e7          	jalr	870(ra) # 404 <thread_switch>
  } else
    next_thread = 0;
}
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	add	sp,sp,16
  ac:	8082                	ret

00000000000000ae <thread_create>:

void 
thread_create(void (*func)())
{
  ae:	1141                	add	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	add	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  b4:	00001797          	auipc	a5,0x1
  b8:	d7478793          	add	a5,a5,-652 # e28 <all_thread>
    if (t->state == FREE) break;
  bc:	6709                	lui	a4,0x2
  be:	07070613          	add	a2,a4,112 # 2070 <__global_pointer$+0xa77>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c2:	07870713          	add	a4,a4,120
  c6:	00009597          	auipc	a1,0x9
  ca:	f4258593          	add	a1,a1,-190 # 9008 <base>
    if (t->state == FREE) break;
  ce:	00c786b3          	add	a3,a5,a2
  d2:	4294                	lw	a3,0(a3)
  d4:	c681                	beqz	a3,dc <thread_create+0x2e>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  d6:	97ba                	add	a5,a5,a4
  d8:	feb79be3          	bne	a5,a1,ce <thread_create+0x20>
  }
  t->state = RUNNABLE;
  dc:	6689                	lui	a3,0x2
  de:	00d78733          	add	a4,a5,a3
  e2:	4609                	li	a2,2
  e4:	db30                	sw	a2,112(a4)
  // YOUR CODE HERE
  t->ra = (uint64) func;
  e6:	e388                	sd	a0,0(a5)
  t->sp = (uint64) t->stack + STACK_SIZE;
  e8:	07078713          	add	a4,a5,112
  ec:	9736                	add	a4,a4,a3
  ee:	e798                	sd	a4,8(a5)
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	add	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <thread_yield>:

void 
thread_yield(void)
{
  f6:	1141                	add	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	add	s0,sp,16
  current_thread->state = RUNNABLE;
  fe:	00001797          	auipc	a5,0x1
 102:	d1a7b783          	ld	a5,-742(a5) # e18 <current_thread>
 106:	6709                	lui	a4,0x2
 108:	97ba                	add	a5,a5,a4
 10a:	4709                	li	a4,2
 10c:	dbb8                	sw	a4,112(a5)
  thread_schedule();
 10e:	00000097          	auipc	ra,0x0
 112:	f18080e7          	jalr	-232(ra) # 26 <thread_schedule>
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	add	sp,sp,16
 11c:	8082                	ret

000000000000011e <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 11e:	7179                	add	sp,sp,-48
 120:	f406                	sd	ra,40(sp)
 122:	f022                	sd	s0,32(sp)
 124:	ec26                	sd	s1,24(sp)
 126:	e84a                	sd	s2,16(sp)
 128:	e44e                	sd	s3,8(sp)
 12a:	e052                	sd	s4,0(sp)
 12c:	1800                	add	s0,sp,48
  int i;
  printf("thread_a started\n");
 12e:	00001517          	auipc	a0,0x1
 132:	bda50513          	add	a0,a0,-1062 # d08 <malloc+0x110>
 136:	00001097          	auipc	ra,0x1
 13a:	a0a080e7          	jalr	-1526(ra) # b40 <printf>
  a_started = 1;
 13e:	4785                	li	a5,1
 140:	00001717          	auipc	a4,0x1
 144:	ccf72a23          	sw	a5,-812(a4) # e14 <a_started>
  while(b_started == 0 || c_started == 0)
 148:	00001497          	auipc	s1,0x1
 14c:	cc848493          	add	s1,s1,-824 # e10 <b_started>
 150:	00001917          	auipc	s2,0x1
 154:	cbc90913          	add	s2,s2,-836 # e0c <c_started>
 158:	a029                	j	162 <thread_a+0x44>
    thread_yield();
 15a:	00000097          	auipc	ra,0x0
 15e:	f9c080e7          	jalr	-100(ra) # f6 <thread_yield>
  while(b_started == 0 || c_started == 0)
 162:	409c                	lw	a5,0(s1)
 164:	2781                	sext.w	a5,a5
 166:	dbf5                	beqz	a5,15a <thread_a+0x3c>
 168:	00092783          	lw	a5,0(s2)
 16c:	2781                	sext.w	a5,a5
 16e:	d7f5                	beqz	a5,15a <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 170:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 172:	00001a17          	auipc	s4,0x1
 176:	baea0a13          	add	s4,s4,-1106 # d20 <malloc+0x128>
    a_n += 1;
 17a:	00001917          	auipc	s2,0x1
 17e:	c8e90913          	add	s2,s2,-882 # e08 <a_n>
  for (i = 0; i < 100; i++) {
 182:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 186:	85a6                	mv	a1,s1
 188:	8552                	mv	a0,s4
 18a:	00001097          	auipc	ra,0x1
 18e:	9b6080e7          	jalr	-1610(ra) # b40 <printf>
    a_n += 1;
 192:	00092783          	lw	a5,0(s2)
 196:	2785                	addw	a5,a5,1
 198:	00f92023          	sw	a5,0(s2)
    thread_yield();
 19c:	00000097          	auipc	ra,0x0
 1a0:	f5a080e7          	jalr	-166(ra) # f6 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a4:	2485                	addw	s1,s1,1
 1a6:	ff3490e3          	bne	s1,s3,186 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1aa:	00001597          	auipc	a1,0x1
 1ae:	c5e5a583          	lw	a1,-930(a1) # e08 <a_n>
 1b2:	00001517          	auipc	a0,0x1
 1b6:	b7e50513          	add	a0,a0,-1154 # d30 <malloc+0x138>
 1ba:	00001097          	auipc	ra,0x1
 1be:	986080e7          	jalr	-1658(ra) # b40 <printf>

  current_thread->state = FREE;
 1c2:	00001797          	auipc	a5,0x1
 1c6:	c567b783          	ld	a5,-938(a5) # e18 <current_thread>
 1ca:	6709                	lui	a4,0x2
 1cc:	97ba                	add	a5,a5,a4
 1ce:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 1d2:	00000097          	auipc	ra,0x0
 1d6:	e54080e7          	jalr	-428(ra) # 26 <thread_schedule>
}
 1da:	70a2                	ld	ra,40(sp)
 1dc:	7402                	ld	s0,32(sp)
 1de:	64e2                	ld	s1,24(sp)
 1e0:	6942                	ld	s2,16(sp)
 1e2:	69a2                	ld	s3,8(sp)
 1e4:	6a02                	ld	s4,0(sp)
 1e6:	6145                	add	sp,sp,48
 1e8:	8082                	ret

00000000000001ea <thread_b>:

void 
thread_b(void)
{
 1ea:	7179                	add	sp,sp,-48
 1ec:	f406                	sd	ra,40(sp)
 1ee:	f022                	sd	s0,32(sp)
 1f0:	ec26                	sd	s1,24(sp)
 1f2:	e84a                	sd	s2,16(sp)
 1f4:	e44e                	sd	s3,8(sp)
 1f6:	e052                	sd	s4,0(sp)
 1f8:	1800                	add	s0,sp,48
  int i;
  printf("thread_b started\n");
 1fa:	00001517          	auipc	a0,0x1
 1fe:	b5650513          	add	a0,a0,-1194 # d50 <malloc+0x158>
 202:	00001097          	auipc	ra,0x1
 206:	93e080e7          	jalr	-1730(ra) # b40 <printf>
  b_started = 1;
 20a:	4785                	li	a5,1
 20c:	00001717          	auipc	a4,0x1
 210:	c0f72223          	sw	a5,-1020(a4) # e10 <b_started>
  while(a_started == 0 || c_started == 0)
 214:	00001497          	auipc	s1,0x1
 218:	c0048493          	add	s1,s1,-1024 # e14 <a_started>
 21c:	00001917          	auipc	s2,0x1
 220:	bf090913          	add	s2,s2,-1040 # e0c <c_started>
 224:	a029                	j	22e <thread_b+0x44>
    thread_yield();
 226:	00000097          	auipc	ra,0x0
 22a:	ed0080e7          	jalr	-304(ra) # f6 <thread_yield>
  while(a_started == 0 || c_started == 0)
 22e:	409c                	lw	a5,0(s1)
 230:	2781                	sext.w	a5,a5
 232:	dbf5                	beqz	a5,226 <thread_b+0x3c>
 234:	00092783          	lw	a5,0(s2)
 238:	2781                	sext.w	a5,a5
 23a:	d7f5                	beqz	a5,226 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 23c:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 23e:	00001a17          	auipc	s4,0x1
 242:	b2aa0a13          	add	s4,s4,-1238 # d68 <malloc+0x170>
    b_n += 1;
 246:	00001917          	auipc	s2,0x1
 24a:	bbe90913          	add	s2,s2,-1090 # e04 <b_n>
  for (i = 0; i < 100; i++) {
 24e:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 252:	85a6                	mv	a1,s1
 254:	8552                	mv	a0,s4
 256:	00001097          	auipc	ra,0x1
 25a:	8ea080e7          	jalr	-1814(ra) # b40 <printf>
    b_n += 1;
 25e:	00092783          	lw	a5,0(s2)
 262:	2785                	addw	a5,a5,1
 264:	00f92023          	sw	a5,0(s2)
    thread_yield();
 268:	00000097          	auipc	ra,0x0
 26c:	e8e080e7          	jalr	-370(ra) # f6 <thread_yield>
  for (i = 0; i < 100; i++) {
 270:	2485                	addw	s1,s1,1
 272:	ff3490e3          	bne	s1,s3,252 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 276:	00001597          	auipc	a1,0x1
 27a:	b8e5a583          	lw	a1,-1138(a1) # e04 <b_n>
 27e:	00001517          	auipc	a0,0x1
 282:	afa50513          	add	a0,a0,-1286 # d78 <malloc+0x180>
 286:	00001097          	auipc	ra,0x1
 28a:	8ba080e7          	jalr	-1862(ra) # b40 <printf>

  current_thread->state = FREE;
 28e:	00001797          	auipc	a5,0x1
 292:	b8a7b783          	ld	a5,-1142(a5) # e18 <current_thread>
 296:	6709                	lui	a4,0x2
 298:	97ba                	add	a5,a5,a4
 29a:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 29e:	00000097          	auipc	ra,0x0
 2a2:	d88080e7          	jalr	-632(ra) # 26 <thread_schedule>
}
 2a6:	70a2                	ld	ra,40(sp)
 2a8:	7402                	ld	s0,32(sp)
 2aa:	64e2                	ld	s1,24(sp)
 2ac:	6942                	ld	s2,16(sp)
 2ae:	69a2                	ld	s3,8(sp)
 2b0:	6a02                	ld	s4,0(sp)
 2b2:	6145                	add	sp,sp,48
 2b4:	8082                	ret

00000000000002b6 <thread_c>:

void 
thread_c(void)
{
 2b6:	7179                	add	sp,sp,-48
 2b8:	f406                	sd	ra,40(sp)
 2ba:	f022                	sd	s0,32(sp)
 2bc:	ec26                	sd	s1,24(sp)
 2be:	e84a                	sd	s2,16(sp)
 2c0:	e44e                	sd	s3,8(sp)
 2c2:	e052                	sd	s4,0(sp)
 2c4:	1800                	add	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c6:	00001517          	auipc	a0,0x1
 2ca:	ad250513          	add	a0,a0,-1326 # d98 <malloc+0x1a0>
 2ce:	00001097          	auipc	ra,0x1
 2d2:	872080e7          	jalr	-1934(ra) # b40 <printf>
  c_started = 1;
 2d6:	4785                	li	a5,1
 2d8:	00001717          	auipc	a4,0x1
 2dc:	b2f72a23          	sw	a5,-1228(a4) # e0c <c_started>
  while(a_started == 0 || b_started == 0)
 2e0:	00001497          	auipc	s1,0x1
 2e4:	b3448493          	add	s1,s1,-1228 # e14 <a_started>
 2e8:	00001917          	auipc	s2,0x1
 2ec:	b2890913          	add	s2,s2,-1240 # e10 <b_started>
 2f0:	a029                	j	2fa <thread_c+0x44>
    thread_yield();
 2f2:	00000097          	auipc	ra,0x0
 2f6:	e04080e7          	jalr	-508(ra) # f6 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2fa:	409c                	lw	a5,0(s1)
 2fc:	2781                	sext.w	a5,a5
 2fe:	dbf5                	beqz	a5,2f2 <thread_c+0x3c>
 300:	00092783          	lw	a5,0(s2)
 304:	2781                	sext.w	a5,a5
 306:	d7f5                	beqz	a5,2f2 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 308:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 30a:	00001a17          	auipc	s4,0x1
 30e:	aa6a0a13          	add	s4,s4,-1370 # db0 <malloc+0x1b8>
    c_n += 1;
 312:	00001917          	auipc	s2,0x1
 316:	aee90913          	add	s2,s2,-1298 # e00 <c_n>
  for (i = 0; i < 100; i++) {
 31a:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31e:	85a6                	mv	a1,s1
 320:	8552                	mv	a0,s4
 322:	00001097          	auipc	ra,0x1
 326:	81e080e7          	jalr	-2018(ra) # b40 <printf>
    c_n += 1;
 32a:	00092783          	lw	a5,0(s2)
 32e:	2785                	addw	a5,a5,1
 330:	00f92023          	sw	a5,0(s2)
    thread_yield();
 334:	00000097          	auipc	ra,0x0
 338:	dc2080e7          	jalr	-574(ra) # f6 <thread_yield>
  for (i = 0; i < 100; i++) {
 33c:	2485                	addw	s1,s1,1
 33e:	ff3490e3          	bne	s1,s3,31e <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 342:	00001597          	auipc	a1,0x1
 346:	abe5a583          	lw	a1,-1346(a1) # e00 <c_n>
 34a:	00001517          	auipc	a0,0x1
 34e:	a7650513          	add	a0,a0,-1418 # dc0 <malloc+0x1c8>
 352:	00000097          	auipc	ra,0x0
 356:	7ee080e7          	jalr	2030(ra) # b40 <printf>

  current_thread->state = FREE;
 35a:	00001797          	auipc	a5,0x1
 35e:	abe7b783          	ld	a5,-1346(a5) # e18 <current_thread>
 362:	6709                	lui	a4,0x2
 364:	97ba                	add	a5,a5,a4
 366:	0607a823          	sw	zero,112(a5)
  thread_schedule();
 36a:	00000097          	auipc	ra,0x0
 36e:	cbc080e7          	jalr	-836(ra) # 26 <thread_schedule>
}
 372:	70a2                	ld	ra,40(sp)
 374:	7402                	ld	s0,32(sp)
 376:	64e2                	ld	s1,24(sp)
 378:	6942                	ld	s2,16(sp)
 37a:	69a2                	ld	s3,8(sp)
 37c:	6a02                	ld	s4,0(sp)
 37e:	6145                	add	sp,sp,48
 380:	8082                	ret

0000000000000382 <main>:

int 
main(int argc, char *argv[]) 
{
 382:	1141                	add	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	add	s0,sp,16
  a_started = b_started = c_started = 0;
 38a:	00001797          	auipc	a5,0x1
 38e:	a807a123          	sw	zero,-1406(a5) # e0c <c_started>
 392:	00001797          	auipc	a5,0x1
 396:	a607af23          	sw	zero,-1410(a5) # e10 <b_started>
 39a:	00001797          	auipc	a5,0x1
 39e:	a607ad23          	sw	zero,-1414(a5) # e14 <a_started>
  a_n = b_n = c_n = 0;
 3a2:	00001797          	auipc	a5,0x1
 3a6:	a407af23          	sw	zero,-1442(a5) # e00 <c_n>
 3aa:	00001797          	auipc	a5,0x1
 3ae:	a407ad23          	sw	zero,-1446(a5) # e04 <b_n>
 3b2:	00001797          	auipc	a5,0x1
 3b6:	a407ab23          	sw	zero,-1450(a5) # e08 <a_n>
  thread_init();
 3ba:	00000097          	auipc	ra,0x0
 3be:	c46080e7          	jalr	-954(ra) # 0 <thread_init>
  thread_create(thread_a);
 3c2:	00000517          	auipc	a0,0x0
 3c6:	d5c50513          	add	a0,a0,-676 # 11e <thread_a>
 3ca:	00000097          	auipc	ra,0x0
 3ce:	ce4080e7          	jalr	-796(ra) # ae <thread_create>
  thread_create(thread_b);
 3d2:	00000517          	auipc	a0,0x0
 3d6:	e1850513          	add	a0,a0,-488 # 1ea <thread_b>
 3da:	00000097          	auipc	ra,0x0
 3de:	cd4080e7          	jalr	-812(ra) # ae <thread_create>
  thread_create(thread_c);
 3e2:	00000517          	auipc	a0,0x0
 3e6:	ed450513          	add	a0,a0,-300 # 2b6 <thread_c>
 3ea:	00000097          	auipc	ra,0x0
 3ee:	cc4080e7          	jalr	-828(ra) # ae <thread_create>
  thread_schedule();
 3f2:	00000097          	auipc	ra,0x0
 3f6:	c34080e7          	jalr	-972(ra) # 26 <thread_schedule>
  exit(0);
 3fa:	4501                	li	a0,0
 3fc:	00000097          	auipc	ra,0x0
 400:	2da080e7          	jalr	730(ra) # 6d6 <exit>

0000000000000404 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	addi sp, sp, -104
 404:	f9810113          	add	sp,sp,-104
	sd ra, 0(sp)
 408:	e006                	sd	ra,0(sp)
	sd sp, 8(sp)
 40a:	e40a                	sd	sp,8(sp)
	sd s0, 16(sp)
 40c:	e822                	sd	s0,16(sp)
	sd s1, 24(sp)
 40e:	ec26                	sd	s1,24(sp)
	sd s2, 32(sp)
 410:	f04a                	sd	s2,32(sp)
	sd s3, 40(sp)
 412:	f44e                	sd	s3,40(sp)
	sd s4, 48(sp)
 414:	f852                	sd	s4,48(sp)
	sd s5, 56(sp)
 416:	fc56                	sd	s5,56(sp)
	sd s6, 64(sp)
 418:	e0da                	sd	s6,64(sp)
	sd s7, 72(sp)
 41a:	e4de                	sd	s7,72(sp)
	sd s8, 80(sp)
 41c:	e8e2                	sd	s8,80(sp)
	sd s9, 88(sp)
 41e:	ece6                	sd	s9,88(sp)
	sd s10, 96(a0)
 420:	07a53023          	sd	s10,96(a0)
	sd s11, 104(sp)
 424:	f4ee                	sd	s11,104(sp)
	
	sd sp, 0(a0)
 426:	00253023          	sd	sp,0(a0)
	
	ld ra, 0(sp)
 42a:	6082                	ld	ra,0(sp)
	ld sp, 8(sp)
 42c:	6122                	ld	sp,8(sp)
	ld s0, 16(sp)
 42e:	6442                	ld	s0,16(sp)
	ld s1, 24(sp)
 430:	64e2                	ld	s1,24(sp)
	ld s2, 32(sp)
 432:	7902                	ld	s2,32(sp)
	ld s3, 40(sp) 
 434:	79a2                	ld	s3,40(sp)
	ld s4, 48(sp)
 436:	7a42                	ld	s4,48(sp)
	ld s5, 56(sp)
 438:	7ae2                	ld	s5,56(sp)
	ld s6, 64(sp)
 43a:	6b06                	ld	s6,64(sp)
	ld s7, 72(sp)
 43c:	6ba6                	ld	s7,72(sp)
	ld s8, 80(sp)
 43e:	6c46                	ld	s8,80(sp)
	ld s9, 88(sp)
 440:	6ce6                	ld	s9,88(sp)
	ld s10, 96(sp)
 442:	7d06                	ld	s10,96(sp)
	ld s11, 104(sp)
 444:	7da6                	ld	s11,104(sp)
	
	sd sp, 0(a1) 
 446:	0025b023          	sd	sp,0(a1)

	addi sp, sp, 104
 44a:	06810113          	add	sp,sp,104
	ret    /* return to ra */
 44e:	8082                	ret

0000000000000450 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 450:	1141                	add	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	add	s0,sp,16
  extern int main();
  main();
 458:	00000097          	auipc	ra,0x0
 45c:	f2a080e7          	jalr	-214(ra) # 382 <main>
  exit(0);
 460:	4501                	li	a0,0
 462:	00000097          	auipc	ra,0x0
 466:	274080e7          	jalr	628(ra) # 6d6 <exit>

000000000000046a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 46a:	1141                	add	sp,sp,-16
 46c:	e422                	sd	s0,8(sp)
 46e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 470:	87aa                	mv	a5,a0
 472:	0585                	add	a1,a1,1
 474:	0785                	add	a5,a5,1
 476:	fff5c703          	lbu	a4,-1(a1)
 47a:	fee78fa3          	sb	a4,-1(a5)
 47e:	fb75                	bnez	a4,472 <strcpy+0x8>
    ;
  return os;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	add	sp,sp,16
 484:	8082                	ret

0000000000000486 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 486:	1141                	add	sp,sp,-16
 488:	e422                	sd	s0,8(sp)
 48a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 48c:	00054783          	lbu	a5,0(a0)
 490:	cb91                	beqz	a5,4a4 <strcmp+0x1e>
 492:	0005c703          	lbu	a4,0(a1)
 496:	00f71763          	bne	a4,a5,4a4 <strcmp+0x1e>
    p++, q++;
 49a:	0505                	add	a0,a0,1
 49c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 49e:	00054783          	lbu	a5,0(a0)
 4a2:	fbe5                	bnez	a5,492 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4a4:	0005c503          	lbu	a0,0(a1)
}
 4a8:	40a7853b          	subw	a0,a5,a0
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	add	sp,sp,16
 4b0:	8082                	ret

00000000000004b2 <strlen>:

uint
strlen(const char *s)
{
 4b2:	1141                	add	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	cf91                	beqz	a5,4d8 <strlen+0x26>
 4be:	0505                	add	a0,a0,1
 4c0:	87aa                	mv	a5,a0
 4c2:	86be                	mv	a3,a5
 4c4:	0785                	add	a5,a5,1
 4c6:	fff7c703          	lbu	a4,-1(a5)
 4ca:	ff65                	bnez	a4,4c2 <strlen+0x10>
 4cc:	40a6853b          	subw	a0,a3,a0
 4d0:	2505                	addw	a0,a0,1
    ;
  return n;
}
 4d2:	6422                	ld	s0,8(sp)
 4d4:	0141                	add	sp,sp,16
 4d6:	8082                	ret
  for(n = 0; s[n]; n++)
 4d8:	4501                	li	a0,0
 4da:	bfe5                	j	4d2 <strlen+0x20>

00000000000004dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 4dc:	1141                	add	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4e2:	ca19                	beqz	a2,4f8 <memset+0x1c>
 4e4:	87aa                	mv	a5,a0
 4e6:	1602                	sll	a2,a2,0x20
 4e8:	9201                	srl	a2,a2,0x20
 4ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4f2:	0785                	add	a5,a5,1
 4f4:	fee79de3          	bne	a5,a4,4ee <memset+0x12>
  }
  return dst;
}
 4f8:	6422                	ld	s0,8(sp)
 4fa:	0141                	add	sp,sp,16
 4fc:	8082                	ret

00000000000004fe <strchr>:

char*
strchr(const char *s, char c)
{
 4fe:	1141                	add	sp,sp,-16
 500:	e422                	sd	s0,8(sp)
 502:	0800                	add	s0,sp,16
  for(; *s; s++)
 504:	00054783          	lbu	a5,0(a0)
 508:	cb99                	beqz	a5,51e <strchr+0x20>
    if(*s == c)
 50a:	00f58763          	beq	a1,a5,518 <strchr+0x1a>
  for(; *s; s++)
 50e:	0505                	add	a0,a0,1
 510:	00054783          	lbu	a5,0(a0)
 514:	fbfd                	bnez	a5,50a <strchr+0xc>
      return (char*)s;
  return 0;
 516:	4501                	li	a0,0
}
 518:	6422                	ld	s0,8(sp)
 51a:	0141                	add	sp,sp,16
 51c:	8082                	ret
  return 0;
 51e:	4501                	li	a0,0
 520:	bfe5                	j	518 <strchr+0x1a>

0000000000000522 <gets>:

char*
gets(char *buf, int max)
{
 522:	711d                	add	sp,sp,-96
 524:	ec86                	sd	ra,88(sp)
 526:	e8a2                	sd	s0,80(sp)
 528:	e4a6                	sd	s1,72(sp)
 52a:	e0ca                	sd	s2,64(sp)
 52c:	fc4e                	sd	s3,56(sp)
 52e:	f852                	sd	s4,48(sp)
 530:	f456                	sd	s5,40(sp)
 532:	f05a                	sd	s6,32(sp)
 534:	ec5e                	sd	s7,24(sp)
 536:	1080                	add	s0,sp,96
 538:	8baa                	mv	s7,a0
 53a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 53c:	892a                	mv	s2,a0
 53e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 540:	4aa9                	li	s5,10
 542:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 544:	89a6                	mv	s3,s1
 546:	2485                	addw	s1,s1,1
 548:	0344d863          	bge	s1,s4,578 <gets+0x56>
    cc = read(0, &c, 1);
 54c:	4605                	li	a2,1
 54e:	faf40593          	add	a1,s0,-81
 552:	4501                	li	a0,0
 554:	00000097          	auipc	ra,0x0
 558:	19a080e7          	jalr	410(ra) # 6ee <read>
    if(cc < 1)
 55c:	00a05e63          	blez	a0,578 <gets+0x56>
    buf[i++] = c;
 560:	faf44783          	lbu	a5,-81(s0)
 564:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 568:	01578763          	beq	a5,s5,576 <gets+0x54>
 56c:	0905                	add	s2,s2,1
 56e:	fd679be3          	bne	a5,s6,544 <gets+0x22>
  for(i=0; i+1 < max; ){
 572:	89a6                	mv	s3,s1
 574:	a011                	j	578 <gets+0x56>
 576:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 578:	99de                	add	s3,s3,s7
 57a:	00098023          	sb	zero,0(s3)
  return buf;
}
 57e:	855e                	mv	a0,s7
 580:	60e6                	ld	ra,88(sp)
 582:	6446                	ld	s0,80(sp)
 584:	64a6                	ld	s1,72(sp)
 586:	6906                	ld	s2,64(sp)
 588:	79e2                	ld	s3,56(sp)
 58a:	7a42                	ld	s4,48(sp)
 58c:	7aa2                	ld	s5,40(sp)
 58e:	7b02                	ld	s6,32(sp)
 590:	6be2                	ld	s7,24(sp)
 592:	6125                	add	sp,sp,96
 594:	8082                	ret

0000000000000596 <stat>:

int
stat(const char *n, struct stat *st)
{
 596:	1101                	add	sp,sp,-32
 598:	ec06                	sd	ra,24(sp)
 59a:	e822                	sd	s0,16(sp)
 59c:	e426                	sd	s1,8(sp)
 59e:	e04a                	sd	s2,0(sp)
 5a0:	1000                	add	s0,sp,32
 5a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a4:	4581                	li	a1,0
 5a6:	00000097          	auipc	ra,0x0
 5aa:	170080e7          	jalr	368(ra) # 716 <open>
  if(fd < 0)
 5ae:	02054563          	bltz	a0,5d8 <stat+0x42>
 5b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5b4:	85ca                	mv	a1,s2
 5b6:	00000097          	auipc	ra,0x0
 5ba:	178080e7          	jalr	376(ra) # 72e <fstat>
 5be:	892a                	mv	s2,a0
  close(fd);
 5c0:	8526                	mv	a0,s1
 5c2:	00000097          	auipc	ra,0x0
 5c6:	13c080e7          	jalr	316(ra) # 6fe <close>
  return r;
}
 5ca:	854a                	mv	a0,s2
 5cc:	60e2                	ld	ra,24(sp)
 5ce:	6442                	ld	s0,16(sp)
 5d0:	64a2                	ld	s1,8(sp)
 5d2:	6902                	ld	s2,0(sp)
 5d4:	6105                	add	sp,sp,32
 5d6:	8082                	ret
    return -1;
 5d8:	597d                	li	s2,-1
 5da:	bfc5                	j	5ca <stat+0x34>

00000000000005dc <atoi>:

int
atoi(const char *s)
{
 5dc:	1141                	add	sp,sp,-16
 5de:	e422                	sd	s0,8(sp)
 5e0:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e2:	00054683          	lbu	a3,0(a0)
 5e6:	fd06879b          	addw	a5,a3,-48 # 1fd0 <__global_pointer$+0x9d7>
 5ea:	0ff7f793          	zext.b	a5,a5
 5ee:	4625                	li	a2,9
 5f0:	02f66863          	bltu	a2,a5,620 <atoi+0x44>
 5f4:	872a                	mv	a4,a0
  n = 0;
 5f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5f8:	0705                	add	a4,a4,1 # 2001 <__global_pointer$+0xa08>
 5fa:	0025179b          	sllw	a5,a0,0x2
 5fe:	9fa9                	addw	a5,a5,a0
 600:	0017979b          	sllw	a5,a5,0x1
 604:	9fb5                	addw	a5,a5,a3
 606:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 60a:	00074683          	lbu	a3,0(a4)
 60e:	fd06879b          	addw	a5,a3,-48
 612:	0ff7f793          	zext.b	a5,a5
 616:	fef671e3          	bgeu	a2,a5,5f8 <atoi+0x1c>
  return n;
}
 61a:	6422                	ld	s0,8(sp)
 61c:	0141                	add	sp,sp,16
 61e:	8082                	ret
  n = 0;
 620:	4501                	li	a0,0
 622:	bfe5                	j	61a <atoi+0x3e>

0000000000000624 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 624:	1141                	add	sp,sp,-16
 626:	e422                	sd	s0,8(sp)
 628:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 62a:	02b57463          	bgeu	a0,a1,652 <memmove+0x2e>
    while(n-- > 0)
 62e:	00c05f63          	blez	a2,64c <memmove+0x28>
 632:	1602                	sll	a2,a2,0x20
 634:	9201                	srl	a2,a2,0x20
 636:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 63a:	872a                	mv	a4,a0
      *dst++ = *src++;
 63c:	0585                	add	a1,a1,1
 63e:	0705                	add	a4,a4,1
 640:	fff5c683          	lbu	a3,-1(a1)
 644:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 648:	fee79ae3          	bne	a5,a4,63c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 64c:	6422                	ld	s0,8(sp)
 64e:	0141                	add	sp,sp,16
 650:	8082                	ret
    dst += n;
 652:	00c50733          	add	a4,a0,a2
    src += n;
 656:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 658:	fec05ae3          	blez	a2,64c <memmove+0x28>
 65c:	fff6079b          	addw	a5,a2,-1
 660:	1782                	sll	a5,a5,0x20
 662:	9381                	srl	a5,a5,0x20
 664:	fff7c793          	not	a5,a5
 668:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 66a:	15fd                	add	a1,a1,-1
 66c:	177d                	add	a4,a4,-1
 66e:	0005c683          	lbu	a3,0(a1)
 672:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 676:	fee79ae3          	bne	a5,a4,66a <memmove+0x46>
 67a:	bfc9                	j	64c <memmove+0x28>

000000000000067c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 67c:	1141                	add	sp,sp,-16
 67e:	e422                	sd	s0,8(sp)
 680:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 682:	ca05                	beqz	a2,6b2 <memcmp+0x36>
 684:	fff6069b          	addw	a3,a2,-1
 688:	1682                	sll	a3,a3,0x20
 68a:	9281                	srl	a3,a3,0x20
 68c:	0685                	add	a3,a3,1
 68e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 690:	00054783          	lbu	a5,0(a0)
 694:	0005c703          	lbu	a4,0(a1)
 698:	00e79863          	bne	a5,a4,6a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 69c:	0505                	add	a0,a0,1
    p2++;
 69e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 6a0:	fed518e3          	bne	a0,a3,690 <memcmp+0x14>
  }
  return 0;
 6a4:	4501                	li	a0,0
 6a6:	a019                	j	6ac <memcmp+0x30>
      return *p1 - *p2;
 6a8:	40e7853b          	subw	a0,a5,a4
}
 6ac:	6422                	ld	s0,8(sp)
 6ae:	0141                	add	sp,sp,16
 6b0:	8082                	ret
  return 0;
 6b2:	4501                	li	a0,0
 6b4:	bfe5                	j	6ac <memcmp+0x30>

00000000000006b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6b6:	1141                	add	sp,sp,-16
 6b8:	e406                	sd	ra,8(sp)
 6ba:	e022                	sd	s0,0(sp)
 6bc:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 6be:	00000097          	auipc	ra,0x0
 6c2:	f66080e7          	jalr	-154(ra) # 624 <memmove>
}
 6c6:	60a2                	ld	ra,8(sp)
 6c8:	6402                	ld	s0,0(sp)
 6ca:	0141                	add	sp,sp,16
 6cc:	8082                	ret

00000000000006ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ce:	4885                	li	a7,1
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6d6:	4889                	li	a7,2
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <wait>:
.global wait
wait:
 li a7, SYS_wait
 6de:	488d                	li	a7,3
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6e6:	4891                	li	a7,4
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <read>:
.global read
read:
 li a7, SYS_read
 6ee:	4895                	li	a7,5
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <write>:
.global write
write:
 li a7, SYS_write
 6f6:	48c1                	li	a7,16
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <close>:
.global close
close:
 li a7, SYS_close
 6fe:	48d5                	li	a7,21
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <kill>:
.global kill
kill:
 li a7, SYS_kill
 706:	4899                	li	a7,6
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <exec>:
.global exec
exec:
 li a7, SYS_exec
 70e:	489d                	li	a7,7
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <open>:
.global open
open:
 li a7, SYS_open
 716:	48bd                	li	a7,15
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 71e:	48c5                	li	a7,17
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 726:	48c9                	li	a7,18
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 72e:	48a1                	li	a7,8
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <link>:
.global link
link:
 li a7, SYS_link
 736:	48cd                	li	a7,19
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 73e:	48d1                	li	a7,20
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 746:	48a5                	li	a7,9
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <dup>:
.global dup
dup:
 li a7, SYS_dup
 74e:	48a9                	li	a7,10
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 756:	48ad                	li	a7,11
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 75e:	48b1                	li	a7,12
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 766:	48b5                	li	a7,13
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 76e:	48b9                	li	a7,14
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 776:	1101                	add	sp,sp,-32
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	add	s0,sp,32
 77e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 782:	4605                	li	a2,1
 784:	fef40593          	add	a1,s0,-17
 788:	00000097          	auipc	ra,0x0
 78c:	f6e080e7          	jalr	-146(ra) # 6f6 <write>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6105                	add	sp,sp,32
 796:	8082                	ret

0000000000000798 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 798:	7139                	add	sp,sp,-64
 79a:	fc06                	sd	ra,56(sp)
 79c:	f822                	sd	s0,48(sp)
 79e:	f426                	sd	s1,40(sp)
 7a0:	f04a                	sd	s2,32(sp)
 7a2:	ec4e                	sd	s3,24(sp)
 7a4:	0080                	add	s0,sp,64
 7a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7a8:	c299                	beqz	a3,7ae <printint+0x16>
 7aa:	0805c963          	bltz	a1,83c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ae:	2581                	sext.w	a1,a1
  neg = 0;
 7b0:	4881                	li	a7,0
 7b2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 7b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7b8:	2601                	sext.w	a2,a2
 7ba:	00000517          	auipc	a0,0x0
 7be:	62e50513          	add	a0,a0,1582 # de8 <digits>
 7c2:	883a                	mv	a6,a4
 7c4:	2705                	addw	a4,a4,1
 7c6:	02c5f7bb          	remuw	a5,a1,a2
 7ca:	1782                	sll	a5,a5,0x20
 7cc:	9381                	srl	a5,a5,0x20
 7ce:	97aa                	add	a5,a5,a0
 7d0:	0007c783          	lbu	a5,0(a5)
 7d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7d8:	0005879b          	sext.w	a5,a1
 7dc:	02c5d5bb          	divuw	a1,a1,a2
 7e0:	0685                	add	a3,a3,1
 7e2:	fec7f0e3          	bgeu	a5,a2,7c2 <printint+0x2a>
  if(neg)
 7e6:	00088c63          	beqz	a7,7fe <printint+0x66>
    buf[i++] = '-';
 7ea:	fd070793          	add	a5,a4,-48
 7ee:	00878733          	add	a4,a5,s0
 7f2:	02d00793          	li	a5,45
 7f6:	fef70823          	sb	a5,-16(a4)
 7fa:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 7fe:	02e05863          	blez	a4,82e <printint+0x96>
 802:	fc040793          	add	a5,s0,-64
 806:	00e78933          	add	s2,a5,a4
 80a:	fff78993          	add	s3,a5,-1
 80e:	99ba                	add	s3,s3,a4
 810:	377d                	addw	a4,a4,-1
 812:	1702                	sll	a4,a4,0x20
 814:	9301                	srl	a4,a4,0x20
 816:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 81a:	fff94583          	lbu	a1,-1(s2)
 81e:	8526                	mv	a0,s1
 820:	00000097          	auipc	ra,0x0
 824:	f56080e7          	jalr	-170(ra) # 776 <putc>
  while(--i >= 0)
 828:	197d                	add	s2,s2,-1
 82a:	ff3918e3          	bne	s2,s3,81a <printint+0x82>
}
 82e:	70e2                	ld	ra,56(sp)
 830:	7442                	ld	s0,48(sp)
 832:	74a2                	ld	s1,40(sp)
 834:	7902                	ld	s2,32(sp)
 836:	69e2                	ld	s3,24(sp)
 838:	6121                	add	sp,sp,64
 83a:	8082                	ret
    x = -xx;
 83c:	40b005bb          	negw	a1,a1
    neg = 1;
 840:	4885                	li	a7,1
    x = -xx;
 842:	bf85                	j	7b2 <printint+0x1a>

0000000000000844 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 844:	711d                	add	sp,sp,-96
 846:	ec86                	sd	ra,88(sp)
 848:	e8a2                	sd	s0,80(sp)
 84a:	e4a6                	sd	s1,72(sp)
 84c:	e0ca                	sd	s2,64(sp)
 84e:	fc4e                	sd	s3,56(sp)
 850:	f852                	sd	s4,48(sp)
 852:	f456                	sd	s5,40(sp)
 854:	f05a                	sd	s6,32(sp)
 856:	ec5e                	sd	s7,24(sp)
 858:	e862                	sd	s8,16(sp)
 85a:	e466                	sd	s9,8(sp)
 85c:	e06a                	sd	s10,0(sp)
 85e:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 860:	0005c903          	lbu	s2,0(a1)
 864:	28090963          	beqz	s2,af6 <vprintf+0x2b2>
 868:	8b2a                	mv	s6,a0
 86a:	8a2e                	mv	s4,a1
 86c:	8bb2                	mv	s7,a2
  state = 0;
 86e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 870:	4481                	li	s1,0
 872:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 874:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 878:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 87c:	06c00c93          	li	s9,108
 880:	a015                	j	8a4 <vprintf+0x60>
        putc(fd, c0);
 882:	85ca                	mv	a1,s2
 884:	855a                	mv	a0,s6
 886:	00000097          	auipc	ra,0x0
 88a:	ef0080e7          	jalr	-272(ra) # 776 <putc>
 88e:	a019                	j	894 <vprintf+0x50>
    } else if(state == '%'){
 890:	03598263          	beq	s3,s5,8b4 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 894:	2485                	addw	s1,s1,1
 896:	8726                	mv	a4,s1
 898:	009a07b3          	add	a5,s4,s1
 89c:	0007c903          	lbu	s2,0(a5)
 8a0:	24090b63          	beqz	s2,af6 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 8a4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8a8:	fe0994e3          	bnez	s3,890 <vprintf+0x4c>
      if(c0 == '%'){
 8ac:	fd579be3          	bne	a5,s5,882 <vprintf+0x3e>
        state = '%';
 8b0:	89be                	mv	s3,a5
 8b2:	b7cd                	j	894 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 8b4:	cbc9                	beqz	a5,946 <vprintf+0x102>
 8b6:	00ea06b3          	add	a3,s4,a4
 8ba:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8be:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 8c0:	c681                	beqz	a3,8c8 <vprintf+0x84>
 8c2:	9752                	add	a4,a4,s4
 8c4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 8c8:	05878163          	beq	a5,s8,90a <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 8cc:	05978d63          	beq	a5,s9,926 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 8d0:	07500713          	li	a4,117
 8d4:	10e78163          	beq	a5,a4,9d6 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 8d8:	07800713          	li	a4,120
 8dc:	14e78963          	beq	a5,a4,a2e <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 8e0:	07000713          	li	a4,112
 8e4:	18e78263          	beq	a5,a4,a68 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 8e8:	07300713          	li	a4,115
 8ec:	1ce78663          	beq	a5,a4,ab8 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 8f0:	02500713          	li	a4,37
 8f4:	04e79963          	bne	a5,a4,946 <vprintf+0x102>
        putc(fd, '%');
 8f8:	02500593          	li	a1,37
 8fc:	855a                	mv	a0,s6
 8fe:	00000097          	auipc	ra,0x0
 902:	e78080e7          	jalr	-392(ra) # 776 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 906:	4981                	li	s3,0
 908:	b771                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 90a:	008b8913          	add	s2,s7,8
 90e:	4685                	li	a3,1
 910:	4629                	li	a2,10
 912:	000ba583          	lw	a1,0(s7)
 916:	855a                	mv	a0,s6
 918:	00000097          	auipc	ra,0x0
 91c:	e80080e7          	jalr	-384(ra) # 798 <printint>
 920:	8bca                	mv	s7,s2
      state = 0;
 922:	4981                	li	s3,0
 924:	bf85                	j	894 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 926:	06400793          	li	a5,100
 92a:	02f68d63          	beq	a3,a5,964 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 92e:	06c00793          	li	a5,108
 932:	04f68863          	beq	a3,a5,982 <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 936:	07500793          	li	a5,117
 93a:	0af68c63          	beq	a3,a5,9f2 <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 93e:	07800793          	li	a5,120
 942:	10f68463          	beq	a3,a5,a4a <vprintf+0x206>
        putc(fd, '%');
 946:	02500593          	li	a1,37
 94a:	855a                	mv	a0,s6
 94c:	00000097          	auipc	ra,0x0
 950:	e2a080e7          	jalr	-470(ra) # 776 <putc>
        putc(fd, c0);
 954:	85ca                	mv	a1,s2
 956:	855a                	mv	a0,s6
 958:	00000097          	auipc	ra,0x0
 95c:	e1e080e7          	jalr	-482(ra) # 776 <putc>
      state = 0;
 960:	4981                	li	s3,0
 962:	bf0d                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 964:	008b8913          	add	s2,s7,8
 968:	4685                	li	a3,1
 96a:	4629                	li	a2,10
 96c:	000ba583          	lw	a1,0(s7)
 970:	855a                	mv	a0,s6
 972:	00000097          	auipc	ra,0x0
 976:	e26080e7          	jalr	-474(ra) # 798 <printint>
        i += 1;
 97a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 97c:	8bca                	mv	s7,s2
      state = 0;
 97e:	4981                	li	s3,0
        i += 1;
 980:	bf11                	j	894 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 982:	06400793          	li	a5,100
 986:	02f60963          	beq	a2,a5,9b8 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 98a:	07500793          	li	a5,117
 98e:	08f60163          	beq	a2,a5,a10 <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 992:	07800793          	li	a5,120
 996:	faf618e3          	bne	a2,a5,946 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 99a:	008b8913          	add	s2,s7,8
 99e:	4681                	li	a3,0
 9a0:	4641                	li	a2,16
 9a2:	000ba583          	lw	a1,0(s7)
 9a6:	855a                	mv	a0,s6
 9a8:	00000097          	auipc	ra,0x0
 9ac:	df0080e7          	jalr	-528(ra) # 798 <printint>
        i += 2;
 9b0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b2:	8bca                	mv	s7,s2
      state = 0;
 9b4:	4981                	li	s3,0
        i += 2;
 9b6:	bdf9                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9b8:	008b8913          	add	s2,s7,8
 9bc:	4685                	li	a3,1
 9be:	4629                	li	a2,10
 9c0:	000ba583          	lw	a1,0(s7)
 9c4:	855a                	mv	a0,s6
 9c6:	00000097          	auipc	ra,0x0
 9ca:	dd2080e7          	jalr	-558(ra) # 798 <printint>
        i += 2;
 9ce:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9d0:	8bca                	mv	s7,s2
      state = 0;
 9d2:	4981                	li	s3,0
        i += 2;
 9d4:	b5c1                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 9d6:	008b8913          	add	s2,s7,8
 9da:	4681                	li	a3,0
 9dc:	4629                	li	a2,10
 9de:	000ba583          	lw	a1,0(s7)
 9e2:	855a                	mv	a0,s6
 9e4:	00000097          	auipc	ra,0x0
 9e8:	db4080e7          	jalr	-588(ra) # 798 <printint>
 9ec:	8bca                	mv	s7,s2
      state = 0;
 9ee:	4981                	li	s3,0
 9f0:	b555                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f2:	008b8913          	add	s2,s7,8
 9f6:	4681                	li	a3,0
 9f8:	4629                	li	a2,10
 9fa:	000ba583          	lw	a1,0(s7)
 9fe:	855a                	mv	a0,s6
 a00:	00000097          	auipc	ra,0x0
 a04:	d98080e7          	jalr	-616(ra) # 798 <printint>
        i += 1;
 a08:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0a:	8bca                	mv	s7,s2
      state = 0;
 a0c:	4981                	li	s3,0
        i += 1;
 a0e:	b559                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a10:	008b8913          	add	s2,s7,8
 a14:	4681                	li	a3,0
 a16:	4629                	li	a2,10
 a18:	000ba583          	lw	a1,0(s7)
 a1c:	855a                	mv	a0,s6
 a1e:	00000097          	auipc	ra,0x0
 a22:	d7a080e7          	jalr	-646(ra) # 798 <printint>
        i += 2;
 a26:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a28:	8bca                	mv	s7,s2
      state = 0;
 a2a:	4981                	li	s3,0
        i += 2;
 a2c:	b5a5                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 a2e:	008b8913          	add	s2,s7,8
 a32:	4681                	li	a3,0
 a34:	4641                	li	a2,16
 a36:	000ba583          	lw	a1,0(s7)
 a3a:	855a                	mv	a0,s6
 a3c:	00000097          	auipc	ra,0x0
 a40:	d5c080e7          	jalr	-676(ra) # 798 <printint>
 a44:	8bca                	mv	s7,s2
      state = 0;
 a46:	4981                	li	s3,0
 a48:	b5b1                	j	894 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a4a:	008b8913          	add	s2,s7,8
 a4e:	4681                	li	a3,0
 a50:	4641                	li	a2,16
 a52:	000ba583          	lw	a1,0(s7)
 a56:	855a                	mv	a0,s6
 a58:	00000097          	auipc	ra,0x0
 a5c:	d40080e7          	jalr	-704(ra) # 798 <printint>
        i += 1;
 a60:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a62:	8bca                	mv	s7,s2
      state = 0;
 a64:	4981                	li	s3,0
        i += 1;
 a66:	b53d                	j	894 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 a68:	008b8d13          	add	s10,s7,8
 a6c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a70:	03000593          	li	a1,48
 a74:	855a                	mv	a0,s6
 a76:	00000097          	auipc	ra,0x0
 a7a:	d00080e7          	jalr	-768(ra) # 776 <putc>
  putc(fd, 'x');
 a7e:	07800593          	li	a1,120
 a82:	855a                	mv	a0,s6
 a84:	00000097          	auipc	ra,0x0
 a88:	cf2080e7          	jalr	-782(ra) # 776 <putc>
 a8c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a8e:	00000b97          	auipc	s7,0x0
 a92:	35ab8b93          	add	s7,s7,858 # de8 <digits>
 a96:	03c9d793          	srl	a5,s3,0x3c
 a9a:	97de                	add	a5,a5,s7
 a9c:	0007c583          	lbu	a1,0(a5)
 aa0:	855a                	mv	a0,s6
 aa2:	00000097          	auipc	ra,0x0
 aa6:	cd4080e7          	jalr	-812(ra) # 776 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 aaa:	0992                	sll	s3,s3,0x4
 aac:	397d                	addw	s2,s2,-1
 aae:	fe0914e3          	bnez	s2,a96 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 ab2:	8bea                	mv	s7,s10
      state = 0;
 ab4:	4981                	li	s3,0
 ab6:	bbf9                	j	894 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 ab8:	008b8993          	add	s3,s7,8
 abc:	000bb903          	ld	s2,0(s7)
 ac0:	02090163          	beqz	s2,ae2 <vprintf+0x29e>
        for(; *s; s++)
 ac4:	00094583          	lbu	a1,0(s2)
 ac8:	c585                	beqz	a1,af0 <vprintf+0x2ac>
          putc(fd, *s);
 aca:	855a                	mv	a0,s6
 acc:	00000097          	auipc	ra,0x0
 ad0:	caa080e7          	jalr	-854(ra) # 776 <putc>
        for(; *s; s++)
 ad4:	0905                	add	s2,s2,1
 ad6:	00094583          	lbu	a1,0(s2)
 ada:	f9e5                	bnez	a1,aca <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 adc:	8bce                	mv	s7,s3
      state = 0;
 ade:	4981                	li	s3,0
 ae0:	bb55                	j	894 <vprintf+0x50>
          s = "(null)";
 ae2:	00000917          	auipc	s2,0x0
 ae6:	2fe90913          	add	s2,s2,766 # de0 <malloc+0x1e8>
        for(; *s; s++)
 aea:	02800593          	li	a1,40
 aee:	bff1                	j	aca <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 af0:	8bce                	mv	s7,s3
      state = 0;
 af2:	4981                	li	s3,0
 af4:	b345                	j	894 <vprintf+0x50>
    }
  }
}
 af6:	60e6                	ld	ra,88(sp)
 af8:	6446                	ld	s0,80(sp)
 afa:	64a6                	ld	s1,72(sp)
 afc:	6906                	ld	s2,64(sp)
 afe:	79e2                	ld	s3,56(sp)
 b00:	7a42                	ld	s4,48(sp)
 b02:	7aa2                	ld	s5,40(sp)
 b04:	7b02                	ld	s6,32(sp)
 b06:	6be2                	ld	s7,24(sp)
 b08:	6c42                	ld	s8,16(sp)
 b0a:	6ca2                	ld	s9,8(sp)
 b0c:	6d02                	ld	s10,0(sp)
 b0e:	6125                	add	sp,sp,96
 b10:	8082                	ret

0000000000000b12 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b12:	715d                	add	sp,sp,-80
 b14:	ec06                	sd	ra,24(sp)
 b16:	e822                	sd	s0,16(sp)
 b18:	1000                	add	s0,sp,32
 b1a:	e010                	sd	a2,0(s0)
 b1c:	e414                	sd	a3,8(s0)
 b1e:	e818                	sd	a4,16(s0)
 b20:	ec1c                	sd	a5,24(s0)
 b22:	03043023          	sd	a6,32(s0)
 b26:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b2a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b2e:	8622                	mv	a2,s0
 b30:	00000097          	auipc	ra,0x0
 b34:	d14080e7          	jalr	-748(ra) # 844 <vprintf>
}
 b38:	60e2                	ld	ra,24(sp)
 b3a:	6442                	ld	s0,16(sp)
 b3c:	6161                	add	sp,sp,80
 b3e:	8082                	ret

0000000000000b40 <printf>:

void
printf(const char *fmt, ...)
{
 b40:	711d                	add	sp,sp,-96
 b42:	ec06                	sd	ra,24(sp)
 b44:	e822                	sd	s0,16(sp)
 b46:	1000                	add	s0,sp,32
 b48:	e40c                	sd	a1,8(s0)
 b4a:	e810                	sd	a2,16(s0)
 b4c:	ec14                	sd	a3,24(s0)
 b4e:	f018                	sd	a4,32(s0)
 b50:	f41c                	sd	a5,40(s0)
 b52:	03043823          	sd	a6,48(s0)
 b56:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b5a:	00840613          	add	a2,s0,8
 b5e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b62:	85aa                	mv	a1,a0
 b64:	4505                	li	a0,1
 b66:	00000097          	auipc	ra,0x0
 b6a:	cde080e7          	jalr	-802(ra) # 844 <vprintf>
}
 b6e:	60e2                	ld	ra,24(sp)
 b70:	6442                	ld	s0,16(sp)
 b72:	6125                	add	sp,sp,96
 b74:	8082                	ret

0000000000000b76 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b76:	1141                	add	sp,sp,-16
 b78:	e422                	sd	s0,8(sp)
 b7a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b7c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b80:	00000797          	auipc	a5,0x0
 b84:	2a07b783          	ld	a5,672(a5) # e20 <freep>
 b88:	a02d                	j	bb2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b8a:	4618                	lw	a4,8(a2)
 b8c:	9f2d                	addw	a4,a4,a1
 b8e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b92:	6398                	ld	a4,0(a5)
 b94:	6310                	ld	a2,0(a4)
 b96:	a83d                	j	bd4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b98:	ff852703          	lw	a4,-8(a0)
 b9c:	9f31                	addw	a4,a4,a2
 b9e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ba0:	ff053683          	ld	a3,-16(a0)
 ba4:	a091                	j	be8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ba6:	6398                	ld	a4,0(a5)
 ba8:	00e7e463          	bltu	a5,a4,bb0 <free+0x3a>
 bac:	00e6ea63          	bltu	a3,a4,bc0 <free+0x4a>
{
 bb0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb2:	fed7fae3          	bgeu	a5,a3,ba6 <free+0x30>
 bb6:	6398                	ld	a4,0(a5)
 bb8:	00e6e463          	bltu	a3,a4,bc0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bbc:	fee7eae3          	bltu	a5,a4,bb0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bc0:	ff852583          	lw	a1,-8(a0)
 bc4:	6390                	ld	a2,0(a5)
 bc6:	02059813          	sll	a6,a1,0x20
 bca:	01c85713          	srl	a4,a6,0x1c
 bce:	9736                	add	a4,a4,a3
 bd0:	fae60de3          	beq	a2,a4,b8a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bd4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bd8:	4790                	lw	a2,8(a5)
 bda:	02061593          	sll	a1,a2,0x20
 bde:	01c5d713          	srl	a4,a1,0x1c
 be2:	973e                	add	a4,a4,a5
 be4:	fae68ae3          	beq	a3,a4,b98 <free+0x22>
    p->s.ptr = bp->s.ptr;
 be8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bea:	00000717          	auipc	a4,0x0
 bee:	22f73b23          	sd	a5,566(a4) # e20 <freep>
}
 bf2:	6422                	ld	s0,8(sp)
 bf4:	0141                	add	sp,sp,16
 bf6:	8082                	ret

0000000000000bf8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bf8:	7139                	add	sp,sp,-64
 bfa:	fc06                	sd	ra,56(sp)
 bfc:	f822                	sd	s0,48(sp)
 bfe:	f426                	sd	s1,40(sp)
 c00:	f04a                	sd	s2,32(sp)
 c02:	ec4e                	sd	s3,24(sp)
 c04:	e852                	sd	s4,16(sp)
 c06:	e456                	sd	s5,8(sp)
 c08:	e05a                	sd	s6,0(sp)
 c0a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c0c:	02051493          	sll	s1,a0,0x20
 c10:	9081                	srl	s1,s1,0x20
 c12:	04bd                	add	s1,s1,15
 c14:	8091                	srl	s1,s1,0x4
 c16:	0014899b          	addw	s3,s1,1
 c1a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c1c:	00000517          	auipc	a0,0x0
 c20:	20453503          	ld	a0,516(a0) # e20 <freep>
 c24:	c515                	beqz	a0,c50 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c28:	4798                	lw	a4,8(a5)
 c2a:	02977f63          	bgeu	a4,s1,c68 <malloc+0x70>
  if(nu < 4096)
 c2e:	8a4e                	mv	s4,s3
 c30:	0009871b          	sext.w	a4,s3
 c34:	6685                	lui	a3,0x1
 c36:	00d77363          	bgeu	a4,a3,c3c <malloc+0x44>
 c3a:	6a05                	lui	s4,0x1
 c3c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c40:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c44:	00000917          	auipc	s2,0x0
 c48:	1dc90913          	add	s2,s2,476 # e20 <freep>
  if(p == (char*)-1)
 c4c:	5afd                	li	s5,-1
 c4e:	a895                	j	cc2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c50:	00008797          	auipc	a5,0x8
 c54:	3b878793          	add	a5,a5,952 # 9008 <base>
 c58:	00000717          	auipc	a4,0x0
 c5c:	1cf73423          	sd	a5,456(a4) # e20 <freep>
 c60:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c62:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c66:	b7e1                	j	c2e <malloc+0x36>
      if(p->s.size == nunits)
 c68:	02e48c63          	beq	s1,a4,ca0 <malloc+0xa8>
        p->s.size -= nunits;
 c6c:	4137073b          	subw	a4,a4,s3
 c70:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c72:	02071693          	sll	a3,a4,0x20
 c76:	01c6d713          	srl	a4,a3,0x1c
 c7a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c7c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c80:	00000717          	auipc	a4,0x0
 c84:	1aa73023          	sd	a0,416(a4) # e20 <freep>
      return (void*)(p + 1);
 c88:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c8c:	70e2                	ld	ra,56(sp)
 c8e:	7442                	ld	s0,48(sp)
 c90:	74a2                	ld	s1,40(sp)
 c92:	7902                	ld	s2,32(sp)
 c94:	69e2                	ld	s3,24(sp)
 c96:	6a42                	ld	s4,16(sp)
 c98:	6aa2                	ld	s5,8(sp)
 c9a:	6b02                	ld	s6,0(sp)
 c9c:	6121                	add	sp,sp,64
 c9e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ca0:	6398                	ld	a4,0(a5)
 ca2:	e118                	sd	a4,0(a0)
 ca4:	bff1                	j	c80 <malloc+0x88>
  hp->s.size = nu;
 ca6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 caa:	0541                	add	a0,a0,16
 cac:	00000097          	auipc	ra,0x0
 cb0:	eca080e7          	jalr	-310(ra) # b76 <free>
  return freep;
 cb4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cb8:	d971                	beqz	a0,c8c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cbc:	4798                	lw	a4,8(a5)
 cbe:	fa9775e3          	bgeu	a4,s1,c68 <malloc+0x70>
    if(p == freep)
 cc2:	00093703          	ld	a4,0(s2)
 cc6:	853e                	mv	a0,a5
 cc8:	fef719e3          	bne	a4,a5,cba <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 ccc:	8552                	mv	a0,s4
 cce:	00000097          	auipc	ra,0x0
 cd2:	a90080e7          	jalr	-1392(ra) # 75e <sbrk>
  if(p == (char*)-1)
 cd6:	fd5518e3          	bne	a0,s5,ca6 <malloc+0xae>
        return 0;
 cda:	4501                	li	a0,0
 cdc:	bf45                	j	c8c <malloc+0x94>
