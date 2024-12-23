
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct mutex_t* all_m[MUTEX_SIZE];
static int m_count = 0;
              
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
   a:	6da78793          	add	a5,a5,1754 # 16e0 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	ecf73123          	sd	a5,-318(a4) # ed0 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	72f72c23          	sw	a5,1848(a4) # 3750 <all_thread+0x2070>
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
  32:	ea253503          	ld	a0,-350(a0) # ed0 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	add	a1,a1,120 # 2078 <all_thread+0x998>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	0000a817          	auipc	a6,0xa
  44:	88080813          	add	a6,a6,-1920 # 98c0 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	add	a7,a3,120 # 2078 <all_thread+0x998>
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
  6a:	67a58593          	add	a1,a1,1658 # 16e0 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	d2050513          	add	a0,a0,-736 # d90 <malloc+0xe8>
  78:	00001097          	auipc	ra,0x1
  7c:	b78080e7          	jalr	-1160(ra) # bf0 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	704080e7          	jalr	1796(ra) # 786 <exit>
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
  9a:	e2b7bd23          	sd	a1,-454(a5) # ed0 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64) t, (uint64)next_thread);
  9e:	00000097          	auipc	ra,0x0
  a2:	3f8080e7          	jalr	1016(ra) # 496 <thread_switch>
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
  b8:	62c78793          	add	a5,a5,1580 # 16e0 <all_thread>
    if (t->state == FREE) break;
  bc:	6709                	lui	a4,0x2
  be:	07070613          	add	a2,a4,112 # 2070 <all_thread+0x990>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c2:	07870713          	add	a4,a4,120
  c6:	00009597          	auipc	a1,0x9
  ca:	7fa58593          	add	a1,a1,2042 # 98c0 <base>
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
 102:	dd27b783          	ld	a5,-558(a5) # ed0 <current_thread>
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
 132:	c8a50513          	add	a0,a0,-886 # db8 <malloc+0x110>
 136:	00001097          	auipc	ra,0x1
 13a:	aba080e7          	jalr	-1350(ra) # bf0 <printf>
  a_started = 1;
 13e:	4785                	li	a5,1
 140:	00001717          	auipc	a4,0x1
 144:	d8f72223          	sw	a5,-636(a4) # ec4 <a_started>
  while(b_started == 0 || c_started == 0)
 148:	00001497          	auipc	s1,0x1
 14c:	d7848493          	add	s1,s1,-648 # ec0 <b_started>
 150:	00001917          	auipc	s2,0x1
 154:	d6c90913          	add	s2,s2,-660 # ebc <c_started>
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
 176:	c5ea0a13          	add	s4,s4,-930 # dd0 <malloc+0x128>
    a_n += 1;
 17a:	00001917          	auipc	s2,0x1
 17e:	d3e90913          	add	s2,s2,-706 # eb8 <a_n>
  for (i = 0; i < 100; i++) {
 182:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 186:	85a6                	mv	a1,s1
 188:	8552                	mv	a0,s4
 18a:	00001097          	auipc	ra,0x1
 18e:	a66080e7          	jalr	-1434(ra) # bf0 <printf>
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
 1ae:	d0e5a583          	lw	a1,-754(a1) # eb8 <a_n>
 1b2:	00001517          	auipc	a0,0x1
 1b6:	c2e50513          	add	a0,a0,-978 # de0 <malloc+0x138>
 1ba:	00001097          	auipc	ra,0x1
 1be:	a36080e7          	jalr	-1482(ra) # bf0 <printf>

  current_thread->state = FREE;
 1c2:	00001797          	auipc	a5,0x1
 1c6:	d0e7b783          	ld	a5,-754(a5) # ed0 <current_thread>
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
 1fe:	c0650513          	add	a0,a0,-1018 # e00 <malloc+0x158>
 202:	00001097          	auipc	ra,0x1
 206:	9ee080e7          	jalr	-1554(ra) # bf0 <printf>
  b_started = 1;
 20a:	4785                	li	a5,1
 20c:	00001717          	auipc	a4,0x1
 210:	caf72a23          	sw	a5,-844(a4) # ec0 <b_started>
  while(a_started == 0 || c_started == 0)
 214:	00001497          	auipc	s1,0x1
 218:	cb048493          	add	s1,s1,-848 # ec4 <a_started>
 21c:	00001917          	auipc	s2,0x1
 220:	ca090913          	add	s2,s2,-864 # ebc <c_started>
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
 242:	bdaa0a13          	add	s4,s4,-1062 # e18 <malloc+0x170>
    b_n += 1;
 246:	00001917          	auipc	s2,0x1
 24a:	c6e90913          	add	s2,s2,-914 # eb4 <b_n>
  for (i = 0; i < 100; i++) {
 24e:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 252:	85a6                	mv	a1,s1
 254:	8552                	mv	a0,s4
 256:	00001097          	auipc	ra,0x1
 25a:	99a080e7          	jalr	-1638(ra) # bf0 <printf>
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
 27a:	c3e5a583          	lw	a1,-962(a1) # eb4 <b_n>
 27e:	00001517          	auipc	a0,0x1
 282:	baa50513          	add	a0,a0,-1110 # e28 <malloc+0x180>
 286:	00001097          	auipc	ra,0x1
 28a:	96a080e7          	jalr	-1686(ra) # bf0 <printf>

  current_thread->state = FREE;
 28e:	00001797          	auipc	a5,0x1
 292:	c427b783          	ld	a5,-958(a5) # ed0 <current_thread>
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
 2ca:	b8250513          	add	a0,a0,-1150 # e48 <malloc+0x1a0>
 2ce:	00001097          	auipc	ra,0x1
 2d2:	922080e7          	jalr	-1758(ra) # bf0 <printf>
  c_started = 1;
 2d6:	4785                	li	a5,1
 2d8:	00001717          	auipc	a4,0x1
 2dc:	bef72223          	sw	a5,-1052(a4) # ebc <c_started>
  while(a_started == 0 || b_started == 0)
 2e0:	00001497          	auipc	s1,0x1
 2e4:	be448493          	add	s1,s1,-1052 # ec4 <a_started>
 2e8:	00001917          	auipc	s2,0x1
 2ec:	bd890913          	add	s2,s2,-1064 # ec0 <b_started>
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
 30e:	b56a0a13          	add	s4,s4,-1194 # e60 <malloc+0x1b8>
    c_n += 1;
 312:	00001917          	auipc	s2,0x1
 316:	b9e90913          	add	s2,s2,-1122 # eb0 <c_n>
  for (i = 0; i < 100; i++) {
 31a:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31e:	85a6                	mv	a1,s1
 320:	8552                	mv	a0,s4
 322:	00001097          	auipc	ra,0x1
 326:	8ce080e7          	jalr	-1842(ra) # bf0 <printf>
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
 346:	b6e5a583          	lw	a1,-1170(a1) # eb0 <c_n>
 34a:	00001517          	auipc	a0,0x1
 34e:	b2650513          	add	a0,a0,-1242 # e70 <malloc+0x1c8>
 352:	00001097          	auipc	ra,0x1
 356:	89e080e7          	jalr	-1890(ra) # bf0 <printf>

  current_thread->state = FREE;
 35a:	00001797          	auipc	a5,0x1
 35e:	b767b783          	ld	a5,-1162(a5) # ed0 <current_thread>
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

0000000000000382 <mtx_create>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_create(int locked){
   int locked_id;
   if (m_count > MUTEX_SIZE){
 382:	00001717          	auipc	a4,0x1
 386:	b4672703          	lw	a4,-1210(a4) # ec8 <m_count>
 38a:	10000793          	li	a5,256
 38e:	02e7cc63          	blt	a5,a4,3c6 <mtx_create+0x44>
int mtx_create(int locked){
 392:	1101                	add	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	e426                	sd	s1,8(sp)
 39a:	1000                	add	s0,sp,32
 39c:	84aa                	mv	s1,a0
	return -1;
   }
   mutex_t *m = (mutex_t *)malloc(sizeof(mutex_t));
 39e:	4511                	li	a0,4
 3a0:	00001097          	auipc	ra,0x1
 3a4:	908080e7          	jalr	-1784(ra) # ca8 <malloc>

   if (m == NULL){
 3a8:	c10d                	beqz	a0,3ca <mtx_create+0x48>
	return -1;
   }
   m->locked = locked;
 3aa:	c104                	sw	s1,0(a0)

   locked_id = m_count++;
 3ac:	00001797          	auipc	a5,0x1
 3b0:	b1c78793          	add	a5,a5,-1252 # ec8 <m_count>
 3b4:	4388                	lw	a0,0(a5)
 3b6:	0015071b          	addw	a4,a0,1
 3ba:	c398                	sw	a4,0(a5)
   return locked_id;
}
 3bc:	60e2                	ld	ra,24(sp)
 3be:	6442                	ld	s0,16(sp)
 3c0:	64a2                	ld	s1,8(sp)
 3c2:	6105                	add	sp,sp,32
 3c4:	8082                	ret
	return -1;
 3c6:	557d                	li	a0,-1
}
 3c8:	8082                	ret
	return -1;
 3ca:	557d                	li	a0,-1
 3cc:	bfc5                	j	3bc <mtx_create+0x3a>

00000000000003ce <mtx_lock>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_lock(int lock_id){
 3ce:	1141                	add	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	add	s0,sp,16
    mutex_t * m = all_m[lock_id];
 3d4:	050e                	sll	a0,a0,0x3
 3d6:	00001797          	auipc	a5,0x1
 3da:	b0a78793          	add	a5,a5,-1270 # ee0 <all_m>
 3de:	97aa                	add	a5,a5,a0

    while (m->locked);
 3e0:	639c                	ld	a5,0(a5)
 3e2:	439c                	lw	a5,0(a5)
 3e4:	e381                	bnez	a5,3e4 <mtx_lock+0x16>
    m->locked = 0; /* Unlock the lock */
    return 0;
}
 3e6:	4501                	li	a0,0
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	add	sp,sp,16
 3ec:	8082                	ret

00000000000003ee <mtx_unlock>:


/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_unlock(int lock_id){
 3ee:	1141                	add	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	add	s0,sp,16
    mutex_t * m = all_m[lock_id];
 3f4:	050e                	sll	a0,a0,0x3
 3f6:	00001797          	auipc	a5,0x1
 3fa:	aea78793          	add	a5,a5,-1302 # ee0 <all_m>
 3fe:	97aa                	add	a5,a5,a0
 400:	639c                	ld	a5,0(a5)
    while (m->locked){
 402:	4388                	lw	a0,0(a5)
 404:	e511                	bnez	a0,410 <mtx_unlock+0x22>
	return -1;
    }
    
    m->locked = 1;
 406:	4705                	li	a4,1
 408:	c398                	sw	a4,0(a5)
    return 0;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	add	sp,sp,16
 40e:	8082                	ret
	return -1;
 410:	557d                	li	a0,-1
 412:	bfe5                	j	40a <mtx_unlock+0x1c>

0000000000000414 <main>:

#ifndef UTHREAD_LIBRARY
int main(int argc, char *argv[]) 
{
 414:	1141                	add	sp,sp,-16
 416:	e406                	sd	ra,8(sp)
 418:	e022                	sd	s0,0(sp)
 41a:	0800                	add	s0,sp,16
  a_started = b_started = c_started = 0;
 41c:	00001797          	auipc	a5,0x1
 420:	aa07a023          	sw	zero,-1376(a5) # ebc <c_started>
 424:	00001797          	auipc	a5,0x1
 428:	a807ae23          	sw	zero,-1380(a5) # ec0 <b_started>
 42c:	00001797          	auipc	a5,0x1
 430:	a807ac23          	sw	zero,-1384(a5) # ec4 <a_started>
  a_n = b_n = c_n = 0;
 434:	00001797          	auipc	a5,0x1
 438:	a607ae23          	sw	zero,-1412(a5) # eb0 <c_n>
 43c:	00001797          	auipc	a5,0x1
 440:	a607ac23          	sw	zero,-1416(a5) # eb4 <b_n>
 444:	00001797          	auipc	a5,0x1
 448:	a607aa23          	sw	zero,-1420(a5) # eb8 <a_n>
  thread_init();
 44c:	00000097          	auipc	ra,0x0
 450:	bb4080e7          	jalr	-1100(ra) # 0 <thread_init>
  thread_create(thread_a);
 454:	00000517          	auipc	a0,0x0
 458:	cca50513          	add	a0,a0,-822 # 11e <thread_a>
 45c:	00000097          	auipc	ra,0x0
 460:	c52080e7          	jalr	-942(ra) # ae <thread_create>
  thread_create(thread_b);
 464:	00000517          	auipc	a0,0x0
 468:	d8650513          	add	a0,a0,-634 # 1ea <thread_b>
 46c:	00000097          	auipc	ra,0x0
 470:	c42080e7          	jalr	-958(ra) # ae <thread_create>
  thread_create(thread_c);
 474:	00000517          	auipc	a0,0x0
 478:	e4250513          	add	a0,a0,-446 # 2b6 <thread_c>
 47c:	00000097          	auipc	ra,0x0
 480:	c32080e7          	jalr	-974(ra) # ae <thread_create>
  thread_schedule();
 484:	00000097          	auipc	ra,0x0
 488:	ba2080e7          	jalr	-1118(ra) # 26 <thread_schedule>
  exit(0);
 48c:	4501                	li	a0,0
 48e:	00000097          	auipc	ra,0x0
 492:	2f8080e7          	jalr	760(ra) # 786 <exit>

0000000000000496 <thread_switch>:
 496:	00153023          	sd	ra,0(a0)
 49a:	00253423          	sd	sp,8(a0)
 49e:	e900                	sd	s0,16(a0)
 4a0:	ed04                	sd	s1,24(a0)
 4a2:	03253023          	sd	s2,32(a0)
 4a6:	03353423          	sd	s3,40(a0)
 4aa:	03453823          	sd	s4,48(a0)
 4ae:	03553c23          	sd	s5,56(a0)
 4b2:	05653023          	sd	s6,64(a0)
 4b6:	05753423          	sd	s7,72(a0)
 4ba:	05853823          	sd	s8,80(a0)
 4be:	05953c23          	sd	s9,88(a0)
 4c2:	07a53023          	sd	s10,96(a0)
 4c6:	07b53423          	sd	s11,104(a0)
 4ca:	0005b083          	ld	ra,0(a1)
 4ce:	0085b103          	ld	sp,8(a1)
 4d2:	6980                	ld	s0,16(a1)
 4d4:	6d84                	ld	s1,24(a1)
 4d6:	0205b903          	ld	s2,32(a1)
 4da:	0285b983          	ld	s3,40(a1)
 4de:	0305ba03          	ld	s4,48(a1)
 4e2:	0385ba83          	ld	s5,56(a1)
 4e6:	0405bb03          	ld	s6,64(a1)
 4ea:	0485bb83          	ld	s7,72(a1)
 4ee:	0505bc03          	ld	s8,80(a1)
 4f2:	0585bc83          	ld	s9,88(a1)
 4f6:	0605bd03          	ld	s10,96(a1)
 4fa:	0685bd83          	ld	s11,104(a1)
 4fe:	8082                	ret

0000000000000500 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 500:	1141                	add	sp,sp,-16
 502:	e406                	sd	ra,8(sp)
 504:	e022                	sd	s0,0(sp)
 506:	0800                	add	s0,sp,16
  extern int main();
  main();
 508:	00000097          	auipc	ra,0x0
 50c:	f0c080e7          	jalr	-244(ra) # 414 <main>
  exit(0);
 510:	4501                	li	a0,0
 512:	00000097          	auipc	ra,0x0
 516:	274080e7          	jalr	628(ra) # 786 <exit>

000000000000051a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 51a:	1141                	add	sp,sp,-16
 51c:	e422                	sd	s0,8(sp)
 51e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 520:	87aa                	mv	a5,a0
 522:	0585                	add	a1,a1,1
 524:	0785                	add	a5,a5,1
 526:	fff5c703          	lbu	a4,-1(a1)
 52a:	fee78fa3          	sb	a4,-1(a5)
 52e:	fb75                	bnez	a4,522 <strcpy+0x8>
    ;
  return os;
}
 530:	6422                	ld	s0,8(sp)
 532:	0141                	add	sp,sp,16
 534:	8082                	ret

0000000000000536 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 536:	1141                	add	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 53c:	00054783          	lbu	a5,0(a0)
 540:	cb91                	beqz	a5,554 <strcmp+0x1e>
 542:	0005c703          	lbu	a4,0(a1)
 546:	00f71763          	bne	a4,a5,554 <strcmp+0x1e>
    p++, q++;
 54a:	0505                	add	a0,a0,1
 54c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 54e:	00054783          	lbu	a5,0(a0)
 552:	fbe5                	bnez	a5,542 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 554:	0005c503          	lbu	a0,0(a1)
}
 558:	40a7853b          	subw	a0,a5,a0
 55c:	6422                	ld	s0,8(sp)
 55e:	0141                	add	sp,sp,16
 560:	8082                	ret

0000000000000562 <strlen>:

uint
strlen(const char *s)
{
 562:	1141                	add	sp,sp,-16
 564:	e422                	sd	s0,8(sp)
 566:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 568:	00054783          	lbu	a5,0(a0)
 56c:	cf91                	beqz	a5,588 <strlen+0x26>
 56e:	0505                	add	a0,a0,1
 570:	87aa                	mv	a5,a0
 572:	86be                	mv	a3,a5
 574:	0785                	add	a5,a5,1
 576:	fff7c703          	lbu	a4,-1(a5)
 57a:	ff65                	bnez	a4,572 <strlen+0x10>
 57c:	40a6853b          	subw	a0,a3,a0
 580:	2505                	addw	a0,a0,1
    ;
  return n;
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	add	sp,sp,16
 586:	8082                	ret
  for(n = 0; s[n]; n++)
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <strlen+0x20>

000000000000058c <memset>:

void*
memset(void *dst, int c, uint n)
{
 58c:	1141                	add	sp,sp,-16
 58e:	e422                	sd	s0,8(sp)
 590:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 592:	ca19                	beqz	a2,5a8 <memset+0x1c>
 594:	87aa                	mv	a5,a0
 596:	1602                	sll	a2,a2,0x20
 598:	9201                	srl	a2,a2,0x20
 59a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 59e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5a2:	0785                	add	a5,a5,1
 5a4:	fee79de3          	bne	a5,a4,59e <memset+0x12>
  }
  return dst;
}
 5a8:	6422                	ld	s0,8(sp)
 5aa:	0141                	add	sp,sp,16
 5ac:	8082                	ret

00000000000005ae <strchr>:

char*
strchr(const char *s, char c)
{
 5ae:	1141                	add	sp,sp,-16
 5b0:	e422                	sd	s0,8(sp)
 5b2:	0800                	add	s0,sp,16
  for(; *s; s++)
 5b4:	00054783          	lbu	a5,0(a0)
 5b8:	cb99                	beqz	a5,5ce <strchr+0x20>
    if(*s == c)
 5ba:	00f58763          	beq	a1,a5,5c8 <strchr+0x1a>
  for(; *s; s++)
 5be:	0505                	add	a0,a0,1
 5c0:	00054783          	lbu	a5,0(a0)
 5c4:	fbfd                	bnez	a5,5ba <strchr+0xc>
      return (char*)s;
  return 0;
 5c6:	4501                	li	a0,0
}
 5c8:	6422                	ld	s0,8(sp)
 5ca:	0141                	add	sp,sp,16
 5cc:	8082                	ret
  return 0;
 5ce:	4501                	li	a0,0
 5d0:	bfe5                	j	5c8 <strchr+0x1a>

00000000000005d2 <gets>:

char*
gets(char *buf, int max)
{
 5d2:	711d                	add	sp,sp,-96
 5d4:	ec86                	sd	ra,88(sp)
 5d6:	e8a2                	sd	s0,80(sp)
 5d8:	e4a6                	sd	s1,72(sp)
 5da:	e0ca                	sd	s2,64(sp)
 5dc:	fc4e                	sd	s3,56(sp)
 5de:	f852                	sd	s4,48(sp)
 5e0:	f456                	sd	s5,40(sp)
 5e2:	f05a                	sd	s6,32(sp)
 5e4:	ec5e                	sd	s7,24(sp)
 5e6:	1080                	add	s0,sp,96
 5e8:	8baa                	mv	s7,a0
 5ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5ec:	892a                	mv	s2,a0
 5ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5f0:	4aa9                	li	s5,10
 5f2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5f4:	89a6                	mv	s3,s1
 5f6:	2485                	addw	s1,s1,1
 5f8:	0344d863          	bge	s1,s4,628 <gets+0x56>
    cc = read(0, &c, 1);
 5fc:	4605                	li	a2,1
 5fe:	faf40593          	add	a1,s0,-81
 602:	4501                	li	a0,0
 604:	00000097          	auipc	ra,0x0
 608:	19a080e7          	jalr	410(ra) # 79e <read>
    if(cc < 1)
 60c:	00a05e63          	blez	a0,628 <gets+0x56>
    buf[i++] = c;
 610:	faf44783          	lbu	a5,-81(s0)
 614:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 618:	01578763          	beq	a5,s5,626 <gets+0x54>
 61c:	0905                	add	s2,s2,1
 61e:	fd679be3          	bne	a5,s6,5f4 <gets+0x22>
  for(i=0; i+1 < max; ){
 622:	89a6                	mv	s3,s1
 624:	a011                	j	628 <gets+0x56>
 626:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 628:	99de                	add	s3,s3,s7
 62a:	00098023          	sb	zero,0(s3)
  return buf;
}
 62e:	855e                	mv	a0,s7
 630:	60e6                	ld	ra,88(sp)
 632:	6446                	ld	s0,80(sp)
 634:	64a6                	ld	s1,72(sp)
 636:	6906                	ld	s2,64(sp)
 638:	79e2                	ld	s3,56(sp)
 63a:	7a42                	ld	s4,48(sp)
 63c:	7aa2                	ld	s5,40(sp)
 63e:	7b02                	ld	s6,32(sp)
 640:	6be2                	ld	s7,24(sp)
 642:	6125                	add	sp,sp,96
 644:	8082                	ret

0000000000000646 <stat>:

int
stat(const char *n, struct stat *st)
{
 646:	1101                	add	sp,sp,-32
 648:	ec06                	sd	ra,24(sp)
 64a:	e822                	sd	s0,16(sp)
 64c:	e426                	sd	s1,8(sp)
 64e:	e04a                	sd	s2,0(sp)
 650:	1000                	add	s0,sp,32
 652:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 654:	4581                	li	a1,0
 656:	00000097          	auipc	ra,0x0
 65a:	170080e7          	jalr	368(ra) # 7c6 <open>
  if(fd < 0)
 65e:	02054563          	bltz	a0,688 <stat+0x42>
 662:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 664:	85ca                	mv	a1,s2
 666:	00000097          	auipc	ra,0x0
 66a:	178080e7          	jalr	376(ra) # 7de <fstat>
 66e:	892a                	mv	s2,a0
  close(fd);
 670:	8526                	mv	a0,s1
 672:	00000097          	auipc	ra,0x0
 676:	13c080e7          	jalr	316(ra) # 7ae <close>
  return r;
}
 67a:	854a                	mv	a0,s2
 67c:	60e2                	ld	ra,24(sp)
 67e:	6442                	ld	s0,16(sp)
 680:	64a2                	ld	s1,8(sp)
 682:	6902                	ld	s2,0(sp)
 684:	6105                	add	sp,sp,32
 686:	8082                	ret
    return -1;
 688:	597d                	li	s2,-1
 68a:	bfc5                	j	67a <stat+0x34>

000000000000068c <atoi>:

int
atoi(const char *s)
{
 68c:	1141                	add	sp,sp,-16
 68e:	e422                	sd	s0,8(sp)
 690:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 692:	00054683          	lbu	a3,0(a0)
 696:	fd06879b          	addw	a5,a3,-48 # 1fd0 <all_thread+0x8f0>
 69a:	0ff7f793          	zext.b	a5,a5
 69e:	4625                	li	a2,9
 6a0:	02f66863          	bltu	a2,a5,6d0 <atoi+0x44>
 6a4:	872a                	mv	a4,a0
  n = 0;
 6a6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6a8:	0705                	add	a4,a4,1
 6aa:	0025179b          	sllw	a5,a0,0x2
 6ae:	9fa9                	addw	a5,a5,a0
 6b0:	0017979b          	sllw	a5,a5,0x1
 6b4:	9fb5                	addw	a5,a5,a3
 6b6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6ba:	00074683          	lbu	a3,0(a4)
 6be:	fd06879b          	addw	a5,a3,-48
 6c2:	0ff7f793          	zext.b	a5,a5
 6c6:	fef671e3          	bgeu	a2,a5,6a8 <atoi+0x1c>
  return n;
}
 6ca:	6422                	ld	s0,8(sp)
 6cc:	0141                	add	sp,sp,16
 6ce:	8082                	ret
  n = 0;
 6d0:	4501                	li	a0,0
 6d2:	bfe5                	j	6ca <atoi+0x3e>

00000000000006d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6d4:	1141                	add	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6da:	02b57463          	bgeu	a0,a1,702 <memmove+0x2e>
    while(n-- > 0)
 6de:	00c05f63          	blez	a2,6fc <memmove+0x28>
 6e2:	1602                	sll	a2,a2,0x20
 6e4:	9201                	srl	a2,a2,0x20
 6e6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6ea:	872a                	mv	a4,a0
      *dst++ = *src++;
 6ec:	0585                	add	a1,a1,1
 6ee:	0705                	add	a4,a4,1
 6f0:	fff5c683          	lbu	a3,-1(a1)
 6f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6f8:	fee79ae3          	bne	a5,a4,6ec <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6fc:	6422                	ld	s0,8(sp)
 6fe:	0141                	add	sp,sp,16
 700:	8082                	ret
    dst += n;
 702:	00c50733          	add	a4,a0,a2
    src += n;
 706:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 708:	fec05ae3          	blez	a2,6fc <memmove+0x28>
 70c:	fff6079b          	addw	a5,a2,-1
 710:	1782                	sll	a5,a5,0x20
 712:	9381                	srl	a5,a5,0x20
 714:	fff7c793          	not	a5,a5
 718:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 71a:	15fd                	add	a1,a1,-1
 71c:	177d                	add	a4,a4,-1
 71e:	0005c683          	lbu	a3,0(a1)
 722:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 726:	fee79ae3          	bne	a5,a4,71a <memmove+0x46>
 72a:	bfc9                	j	6fc <memmove+0x28>

000000000000072c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 72c:	1141                	add	sp,sp,-16
 72e:	e422                	sd	s0,8(sp)
 730:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 732:	ca05                	beqz	a2,762 <memcmp+0x36>
 734:	fff6069b          	addw	a3,a2,-1
 738:	1682                	sll	a3,a3,0x20
 73a:	9281                	srl	a3,a3,0x20
 73c:	0685                	add	a3,a3,1
 73e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 740:	00054783          	lbu	a5,0(a0)
 744:	0005c703          	lbu	a4,0(a1)
 748:	00e79863          	bne	a5,a4,758 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 74c:	0505                	add	a0,a0,1
    p2++;
 74e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 750:	fed518e3          	bne	a0,a3,740 <memcmp+0x14>
  }
  return 0;
 754:	4501                	li	a0,0
 756:	a019                	j	75c <memcmp+0x30>
      return *p1 - *p2;
 758:	40e7853b          	subw	a0,a5,a4
}
 75c:	6422                	ld	s0,8(sp)
 75e:	0141                	add	sp,sp,16
 760:	8082                	ret
  return 0;
 762:	4501                	li	a0,0
 764:	bfe5                	j	75c <memcmp+0x30>

0000000000000766 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 766:	1141                	add	sp,sp,-16
 768:	e406                	sd	ra,8(sp)
 76a:	e022                	sd	s0,0(sp)
 76c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 76e:	00000097          	auipc	ra,0x0
 772:	f66080e7          	jalr	-154(ra) # 6d4 <memmove>
}
 776:	60a2                	ld	ra,8(sp)
 778:	6402                	ld	s0,0(sp)
 77a:	0141                	add	sp,sp,16
 77c:	8082                	ret

000000000000077e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 77e:	4885                	li	a7,1
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <exit>:
.global exit
exit:
 li a7, SYS_exit
 786:	4889                	li	a7,2
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <wait>:
.global wait
wait:
 li a7, SYS_wait
 78e:	488d                	li	a7,3
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 796:	4891                	li	a7,4
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <read>:
.global read
read:
 li a7, SYS_read
 79e:	4895                	li	a7,5
 ecall
 7a0:	00000073          	ecall
 ret
 7a4:	8082                	ret

00000000000007a6 <write>:
.global write
write:
 li a7, SYS_write
 7a6:	48c1                	li	a7,16
 ecall
 7a8:	00000073          	ecall
 ret
 7ac:	8082                	ret

00000000000007ae <close>:
.global close
close:
 li a7, SYS_close
 7ae:	48d5                	li	a7,21
 ecall
 7b0:	00000073          	ecall
 ret
 7b4:	8082                	ret

00000000000007b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7b6:	4899                	li	a7,6
 ecall
 7b8:	00000073          	ecall
 ret
 7bc:	8082                	ret

00000000000007be <exec>:
.global exec
exec:
 li a7, SYS_exec
 7be:	489d                	li	a7,7
 ecall
 7c0:	00000073          	ecall
 ret
 7c4:	8082                	ret

00000000000007c6 <open>:
.global open
open:
 li a7, SYS_open
 7c6:	48bd                	li	a7,15
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7ce:	48c5                	li	a7,17
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7d6:	48c9                	li	a7,18
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7de:	48a1                	li	a7,8
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <link>:
.global link
link:
 li a7, SYS_link
 7e6:	48cd                	li	a7,19
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7ee:	48d1                	li	a7,20
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7f6:	48a5                	li	a7,9
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 7fe:	48a9                	li	a7,10
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 806:	48ad                	li	a7,11
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 80e:	48b1                	li	a7,12
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 816:	48b5                	li	a7,13
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 81e:	48b9                	li	a7,14
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 826:	1101                	add	sp,sp,-32
 828:	ec06                	sd	ra,24(sp)
 82a:	e822                	sd	s0,16(sp)
 82c:	1000                	add	s0,sp,32
 82e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 832:	4605                	li	a2,1
 834:	fef40593          	add	a1,s0,-17
 838:	00000097          	auipc	ra,0x0
 83c:	f6e080e7          	jalr	-146(ra) # 7a6 <write>
}
 840:	60e2                	ld	ra,24(sp)
 842:	6442                	ld	s0,16(sp)
 844:	6105                	add	sp,sp,32
 846:	8082                	ret

0000000000000848 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 848:	7139                	add	sp,sp,-64
 84a:	fc06                	sd	ra,56(sp)
 84c:	f822                	sd	s0,48(sp)
 84e:	f426                	sd	s1,40(sp)
 850:	f04a                	sd	s2,32(sp)
 852:	ec4e                	sd	s3,24(sp)
 854:	0080                	add	s0,sp,64
 856:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 858:	c299                	beqz	a3,85e <printint+0x16>
 85a:	0805c963          	bltz	a1,8ec <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 85e:	2581                	sext.w	a1,a1
  neg = 0;
 860:	4881                	li	a7,0
 862:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 866:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 868:	2601                	sext.w	a2,a2
 86a:	00000517          	auipc	a0,0x0
 86e:	62e50513          	add	a0,a0,1582 # e98 <digits>
 872:	883a                	mv	a6,a4
 874:	2705                	addw	a4,a4,1
 876:	02c5f7bb          	remuw	a5,a1,a2
 87a:	1782                	sll	a5,a5,0x20
 87c:	9381                	srl	a5,a5,0x20
 87e:	97aa                	add	a5,a5,a0
 880:	0007c783          	lbu	a5,0(a5)
 884:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 888:	0005879b          	sext.w	a5,a1
 88c:	02c5d5bb          	divuw	a1,a1,a2
 890:	0685                	add	a3,a3,1
 892:	fec7f0e3          	bgeu	a5,a2,872 <printint+0x2a>
  if(neg)
 896:	00088c63          	beqz	a7,8ae <printint+0x66>
    buf[i++] = '-';
 89a:	fd070793          	add	a5,a4,-48
 89e:	00878733          	add	a4,a5,s0
 8a2:	02d00793          	li	a5,45
 8a6:	fef70823          	sb	a5,-16(a4)
 8aa:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8ae:	02e05863          	blez	a4,8de <printint+0x96>
 8b2:	fc040793          	add	a5,s0,-64
 8b6:	00e78933          	add	s2,a5,a4
 8ba:	fff78993          	add	s3,a5,-1
 8be:	99ba                	add	s3,s3,a4
 8c0:	377d                	addw	a4,a4,-1
 8c2:	1702                	sll	a4,a4,0x20
 8c4:	9301                	srl	a4,a4,0x20
 8c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8ca:	fff94583          	lbu	a1,-1(s2)
 8ce:	8526                	mv	a0,s1
 8d0:	00000097          	auipc	ra,0x0
 8d4:	f56080e7          	jalr	-170(ra) # 826 <putc>
  while(--i >= 0)
 8d8:	197d                	add	s2,s2,-1
 8da:	ff3918e3          	bne	s2,s3,8ca <printint+0x82>
}
 8de:	70e2                	ld	ra,56(sp)
 8e0:	7442                	ld	s0,48(sp)
 8e2:	74a2                	ld	s1,40(sp)
 8e4:	7902                	ld	s2,32(sp)
 8e6:	69e2                	ld	s3,24(sp)
 8e8:	6121                	add	sp,sp,64
 8ea:	8082                	ret
    x = -xx;
 8ec:	40b005bb          	negw	a1,a1
    neg = 1;
 8f0:	4885                	li	a7,1
    x = -xx;
 8f2:	bf85                	j	862 <printint+0x1a>

00000000000008f4 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8f4:	711d                	add	sp,sp,-96
 8f6:	ec86                	sd	ra,88(sp)
 8f8:	e8a2                	sd	s0,80(sp)
 8fa:	e4a6                	sd	s1,72(sp)
 8fc:	e0ca                	sd	s2,64(sp)
 8fe:	fc4e                	sd	s3,56(sp)
 900:	f852                	sd	s4,48(sp)
 902:	f456                	sd	s5,40(sp)
 904:	f05a                	sd	s6,32(sp)
 906:	ec5e                	sd	s7,24(sp)
 908:	e862                	sd	s8,16(sp)
 90a:	e466                	sd	s9,8(sp)
 90c:	e06a                	sd	s10,0(sp)
 90e:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 910:	0005c903          	lbu	s2,0(a1)
 914:	28090963          	beqz	s2,ba6 <vprintf+0x2b2>
 918:	8b2a                	mv	s6,a0
 91a:	8a2e                	mv	s4,a1
 91c:	8bb2                	mv	s7,a2
  state = 0;
 91e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 920:	4481                	li	s1,0
 922:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 924:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 928:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 92c:	06c00c93          	li	s9,108
 930:	a015                	j	954 <vprintf+0x60>
        putc(fd, c0);
 932:	85ca                	mv	a1,s2
 934:	855a                	mv	a0,s6
 936:	00000097          	auipc	ra,0x0
 93a:	ef0080e7          	jalr	-272(ra) # 826 <putc>
 93e:	a019                	j	944 <vprintf+0x50>
    } else if(state == '%'){
 940:	03598263          	beq	s3,s5,964 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 944:	2485                	addw	s1,s1,1
 946:	8726                	mv	a4,s1
 948:	009a07b3          	add	a5,s4,s1
 94c:	0007c903          	lbu	s2,0(a5)
 950:	24090b63          	beqz	s2,ba6 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 954:	0009079b          	sext.w	a5,s2
    if(state == 0){
 958:	fe0994e3          	bnez	s3,940 <vprintf+0x4c>
      if(c0 == '%'){
 95c:	fd579be3          	bne	a5,s5,932 <vprintf+0x3e>
        state = '%';
 960:	89be                	mv	s3,a5
 962:	b7cd                	j	944 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 964:	cbc9                	beqz	a5,9f6 <vprintf+0x102>
 966:	00ea06b3          	add	a3,s4,a4
 96a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 96e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 970:	c681                	beqz	a3,978 <vprintf+0x84>
 972:	9752                	add	a4,a4,s4
 974:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 978:	05878163          	beq	a5,s8,9ba <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 97c:	05978d63          	beq	a5,s9,9d6 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 980:	07500713          	li	a4,117
 984:	10e78163          	beq	a5,a4,a86 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 988:	07800713          	li	a4,120
 98c:	14e78963          	beq	a5,a4,ade <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 990:	07000713          	li	a4,112
 994:	18e78263          	beq	a5,a4,b18 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 998:	07300713          	li	a4,115
 99c:	1ce78663          	beq	a5,a4,b68 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9a0:	02500713          	li	a4,37
 9a4:	04e79963          	bne	a5,a4,9f6 <vprintf+0x102>
        putc(fd, '%');
 9a8:	02500593          	li	a1,37
 9ac:	855a                	mv	a0,s6
 9ae:	00000097          	auipc	ra,0x0
 9b2:	e78080e7          	jalr	-392(ra) # 826 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9b6:	4981                	li	s3,0
 9b8:	b771                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 9ba:	008b8913          	add	s2,s7,8
 9be:	4685                	li	a3,1
 9c0:	4629                	li	a2,10
 9c2:	000ba583          	lw	a1,0(s7)
 9c6:	855a                	mv	a0,s6
 9c8:	00000097          	auipc	ra,0x0
 9cc:	e80080e7          	jalr	-384(ra) # 848 <printint>
 9d0:	8bca                	mv	s7,s2
      state = 0;
 9d2:	4981                	li	s3,0
 9d4:	bf85                	j	944 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 9d6:	06400793          	li	a5,100
 9da:	02f68d63          	beq	a3,a5,a14 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9de:	06c00793          	li	a5,108
 9e2:	04f68863          	beq	a3,a5,a32 <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 9e6:	07500793          	li	a5,117
 9ea:	0af68c63          	beq	a3,a5,aa2 <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 9ee:	07800793          	li	a5,120
 9f2:	10f68463          	beq	a3,a5,afa <vprintf+0x206>
        putc(fd, '%');
 9f6:	02500593          	li	a1,37
 9fa:	855a                	mv	a0,s6
 9fc:	00000097          	auipc	ra,0x0
 a00:	e2a080e7          	jalr	-470(ra) # 826 <putc>
        putc(fd, c0);
 a04:	85ca                	mv	a1,s2
 a06:	855a                	mv	a0,s6
 a08:	00000097          	auipc	ra,0x0
 a0c:	e1e080e7          	jalr	-482(ra) # 826 <putc>
      state = 0;
 a10:	4981                	li	s3,0
 a12:	bf0d                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a14:	008b8913          	add	s2,s7,8
 a18:	4685                	li	a3,1
 a1a:	4629                	li	a2,10
 a1c:	000ba583          	lw	a1,0(s7)
 a20:	855a                	mv	a0,s6
 a22:	00000097          	auipc	ra,0x0
 a26:	e26080e7          	jalr	-474(ra) # 848 <printint>
        i += 1;
 a2a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a2c:	8bca                	mv	s7,s2
      state = 0;
 a2e:	4981                	li	s3,0
        i += 1;
 a30:	bf11                	j	944 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a32:	06400793          	li	a5,100
 a36:	02f60963          	beq	a2,a5,a68 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a3a:	07500793          	li	a5,117
 a3e:	08f60163          	beq	a2,a5,ac0 <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a42:	07800793          	li	a5,120
 a46:	faf618e3          	bne	a2,a5,9f6 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a4a:	008b8913          	add	s2,s7,8
 a4e:	4681                	li	a3,0
 a50:	4641                	li	a2,16
 a52:	000ba583          	lw	a1,0(s7)
 a56:	855a                	mv	a0,s6
 a58:	00000097          	auipc	ra,0x0
 a5c:	df0080e7          	jalr	-528(ra) # 848 <printint>
        i += 2;
 a60:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a62:	8bca                	mv	s7,s2
      state = 0;
 a64:	4981                	li	s3,0
        i += 2;
 a66:	bdf9                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a68:	008b8913          	add	s2,s7,8
 a6c:	4685                	li	a3,1
 a6e:	4629                	li	a2,10
 a70:	000ba583          	lw	a1,0(s7)
 a74:	855a                	mv	a0,s6
 a76:	00000097          	auipc	ra,0x0
 a7a:	dd2080e7          	jalr	-558(ra) # 848 <printint>
        i += 2;
 a7e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a80:	8bca                	mv	s7,s2
      state = 0;
 a82:	4981                	li	s3,0
        i += 2;
 a84:	b5c1                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 a86:	008b8913          	add	s2,s7,8
 a8a:	4681                	li	a3,0
 a8c:	4629                	li	a2,10
 a8e:	000ba583          	lw	a1,0(s7)
 a92:	855a                	mv	a0,s6
 a94:	00000097          	auipc	ra,0x0
 a98:	db4080e7          	jalr	-588(ra) # 848 <printint>
 a9c:	8bca                	mv	s7,s2
      state = 0;
 a9e:	4981                	li	s3,0
 aa0:	b555                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 aa2:	008b8913          	add	s2,s7,8
 aa6:	4681                	li	a3,0
 aa8:	4629                	li	a2,10
 aaa:	000ba583          	lw	a1,0(s7)
 aae:	855a                	mv	a0,s6
 ab0:	00000097          	auipc	ra,0x0
 ab4:	d98080e7          	jalr	-616(ra) # 848 <printint>
        i += 1;
 ab8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 aba:	8bca                	mv	s7,s2
      state = 0;
 abc:	4981                	li	s3,0
        i += 1;
 abe:	b559                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ac0:	008b8913          	add	s2,s7,8
 ac4:	4681                	li	a3,0
 ac6:	4629                	li	a2,10
 ac8:	000ba583          	lw	a1,0(s7)
 acc:	855a                	mv	a0,s6
 ace:	00000097          	auipc	ra,0x0
 ad2:	d7a080e7          	jalr	-646(ra) # 848 <printint>
        i += 2;
 ad6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ad8:	8bca                	mv	s7,s2
      state = 0;
 ada:	4981                	li	s3,0
        i += 2;
 adc:	b5a5                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 ade:	008b8913          	add	s2,s7,8
 ae2:	4681                	li	a3,0
 ae4:	4641                	li	a2,16
 ae6:	000ba583          	lw	a1,0(s7)
 aea:	855a                	mv	a0,s6
 aec:	00000097          	auipc	ra,0x0
 af0:	d5c080e7          	jalr	-676(ra) # 848 <printint>
 af4:	8bca                	mv	s7,s2
      state = 0;
 af6:	4981                	li	s3,0
 af8:	b5b1                	j	944 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 afa:	008b8913          	add	s2,s7,8
 afe:	4681                	li	a3,0
 b00:	4641                	li	a2,16
 b02:	000ba583          	lw	a1,0(s7)
 b06:	855a                	mv	a0,s6
 b08:	00000097          	auipc	ra,0x0
 b0c:	d40080e7          	jalr	-704(ra) # 848 <printint>
        i += 1;
 b10:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b12:	8bca                	mv	s7,s2
      state = 0;
 b14:	4981                	li	s3,0
        i += 1;
 b16:	b53d                	j	944 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 b18:	008b8d13          	add	s10,s7,8
 b1c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b20:	03000593          	li	a1,48
 b24:	855a                	mv	a0,s6
 b26:	00000097          	auipc	ra,0x0
 b2a:	d00080e7          	jalr	-768(ra) # 826 <putc>
  putc(fd, 'x');
 b2e:	07800593          	li	a1,120
 b32:	855a                	mv	a0,s6
 b34:	00000097          	auipc	ra,0x0
 b38:	cf2080e7          	jalr	-782(ra) # 826 <putc>
 b3c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b3e:	00000b97          	auipc	s7,0x0
 b42:	35ab8b93          	add	s7,s7,858 # e98 <digits>
 b46:	03c9d793          	srl	a5,s3,0x3c
 b4a:	97de                	add	a5,a5,s7
 b4c:	0007c583          	lbu	a1,0(a5)
 b50:	855a                	mv	a0,s6
 b52:	00000097          	auipc	ra,0x0
 b56:	cd4080e7          	jalr	-812(ra) # 826 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b5a:	0992                	sll	s3,s3,0x4
 b5c:	397d                	addw	s2,s2,-1
 b5e:	fe0914e3          	bnez	s2,b46 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 b62:	8bea                	mv	s7,s10
      state = 0;
 b64:	4981                	li	s3,0
 b66:	bbf9                	j	944 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 b68:	008b8993          	add	s3,s7,8
 b6c:	000bb903          	ld	s2,0(s7)
 b70:	02090163          	beqz	s2,b92 <vprintf+0x29e>
        for(; *s; s++)
 b74:	00094583          	lbu	a1,0(s2)
 b78:	c585                	beqz	a1,ba0 <vprintf+0x2ac>
          putc(fd, *s);
 b7a:	855a                	mv	a0,s6
 b7c:	00000097          	auipc	ra,0x0
 b80:	caa080e7          	jalr	-854(ra) # 826 <putc>
        for(; *s; s++)
 b84:	0905                	add	s2,s2,1
 b86:	00094583          	lbu	a1,0(s2)
 b8a:	f9e5                	bnez	a1,b7a <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 b8c:	8bce                	mv	s7,s3
      state = 0;
 b8e:	4981                	li	s3,0
 b90:	bb55                	j	944 <vprintf+0x50>
          s = "(null)";
 b92:	00000917          	auipc	s2,0x0
 b96:	2fe90913          	add	s2,s2,766 # e90 <malloc+0x1e8>
        for(; *s; s++)
 b9a:	02800593          	li	a1,40
 b9e:	bff1                	j	b7a <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 ba0:	8bce                	mv	s7,s3
      state = 0;
 ba2:	4981                	li	s3,0
 ba4:	b345                	j	944 <vprintf+0x50>
    }
  }
}
 ba6:	60e6                	ld	ra,88(sp)
 ba8:	6446                	ld	s0,80(sp)
 baa:	64a6                	ld	s1,72(sp)
 bac:	6906                	ld	s2,64(sp)
 bae:	79e2                	ld	s3,56(sp)
 bb0:	7a42                	ld	s4,48(sp)
 bb2:	7aa2                	ld	s5,40(sp)
 bb4:	7b02                	ld	s6,32(sp)
 bb6:	6be2                	ld	s7,24(sp)
 bb8:	6c42                	ld	s8,16(sp)
 bba:	6ca2                	ld	s9,8(sp)
 bbc:	6d02                	ld	s10,0(sp)
 bbe:	6125                	add	sp,sp,96
 bc0:	8082                	ret

0000000000000bc2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bc2:	715d                	add	sp,sp,-80
 bc4:	ec06                	sd	ra,24(sp)
 bc6:	e822                	sd	s0,16(sp)
 bc8:	1000                	add	s0,sp,32
 bca:	e010                	sd	a2,0(s0)
 bcc:	e414                	sd	a3,8(s0)
 bce:	e818                	sd	a4,16(s0)
 bd0:	ec1c                	sd	a5,24(s0)
 bd2:	03043023          	sd	a6,32(s0)
 bd6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bda:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bde:	8622                	mv	a2,s0
 be0:	00000097          	auipc	ra,0x0
 be4:	d14080e7          	jalr	-748(ra) # 8f4 <vprintf>
}
 be8:	60e2                	ld	ra,24(sp)
 bea:	6442                	ld	s0,16(sp)
 bec:	6161                	add	sp,sp,80
 bee:	8082                	ret

0000000000000bf0 <printf>:

void
printf(const char *fmt, ...)
{
 bf0:	711d                	add	sp,sp,-96
 bf2:	ec06                	sd	ra,24(sp)
 bf4:	e822                	sd	s0,16(sp)
 bf6:	1000                	add	s0,sp,32
 bf8:	e40c                	sd	a1,8(s0)
 bfa:	e810                	sd	a2,16(s0)
 bfc:	ec14                	sd	a3,24(s0)
 bfe:	f018                	sd	a4,32(s0)
 c00:	f41c                	sd	a5,40(s0)
 c02:	03043823          	sd	a6,48(s0)
 c06:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c0a:	00840613          	add	a2,s0,8
 c0e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c12:	85aa                	mv	a1,a0
 c14:	4505                	li	a0,1
 c16:	00000097          	auipc	ra,0x0
 c1a:	cde080e7          	jalr	-802(ra) # 8f4 <vprintf>
}
 c1e:	60e2                	ld	ra,24(sp)
 c20:	6442                	ld	s0,16(sp)
 c22:	6125                	add	sp,sp,96
 c24:	8082                	ret

0000000000000c26 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c26:	1141                	add	sp,sp,-16
 c28:	e422                	sd	s0,8(sp)
 c2a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c2c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c30:	00000797          	auipc	a5,0x0
 c34:	2a87b783          	ld	a5,680(a5) # ed8 <freep>
 c38:	a02d                	j	c62 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c3a:	4618                	lw	a4,8(a2)
 c3c:	9f2d                	addw	a4,a4,a1
 c3e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c42:	6398                	ld	a4,0(a5)
 c44:	6310                	ld	a2,0(a4)
 c46:	a83d                	j	c84 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c48:	ff852703          	lw	a4,-8(a0)
 c4c:	9f31                	addw	a4,a4,a2
 c4e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c50:	ff053683          	ld	a3,-16(a0)
 c54:	a091                	j	c98 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c56:	6398                	ld	a4,0(a5)
 c58:	00e7e463          	bltu	a5,a4,c60 <free+0x3a>
 c5c:	00e6ea63          	bltu	a3,a4,c70 <free+0x4a>
{
 c60:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c62:	fed7fae3          	bgeu	a5,a3,c56 <free+0x30>
 c66:	6398                	ld	a4,0(a5)
 c68:	00e6e463          	bltu	a3,a4,c70 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c6c:	fee7eae3          	bltu	a5,a4,c60 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c70:	ff852583          	lw	a1,-8(a0)
 c74:	6390                	ld	a2,0(a5)
 c76:	02059813          	sll	a6,a1,0x20
 c7a:	01c85713          	srl	a4,a6,0x1c
 c7e:	9736                	add	a4,a4,a3
 c80:	fae60de3          	beq	a2,a4,c3a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c84:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c88:	4790                	lw	a2,8(a5)
 c8a:	02061593          	sll	a1,a2,0x20
 c8e:	01c5d713          	srl	a4,a1,0x1c
 c92:	973e                	add	a4,a4,a5
 c94:	fae68ae3          	beq	a3,a4,c48 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c98:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c9a:	00000717          	auipc	a4,0x0
 c9e:	22f73f23          	sd	a5,574(a4) # ed8 <freep>
}
 ca2:	6422                	ld	s0,8(sp)
 ca4:	0141                	add	sp,sp,16
 ca6:	8082                	ret

0000000000000ca8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ca8:	7139                	add	sp,sp,-64
 caa:	fc06                	sd	ra,56(sp)
 cac:	f822                	sd	s0,48(sp)
 cae:	f426                	sd	s1,40(sp)
 cb0:	f04a                	sd	s2,32(sp)
 cb2:	ec4e                	sd	s3,24(sp)
 cb4:	e852                	sd	s4,16(sp)
 cb6:	e456                	sd	s5,8(sp)
 cb8:	e05a                	sd	s6,0(sp)
 cba:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cbc:	02051493          	sll	s1,a0,0x20
 cc0:	9081                	srl	s1,s1,0x20
 cc2:	04bd                	add	s1,s1,15
 cc4:	8091                	srl	s1,s1,0x4
 cc6:	0014899b          	addw	s3,s1,1
 cca:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 ccc:	00000517          	auipc	a0,0x0
 cd0:	20c53503          	ld	a0,524(a0) # ed8 <freep>
 cd4:	c515                	beqz	a0,d00 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cd8:	4798                	lw	a4,8(a5)
 cda:	02977f63          	bgeu	a4,s1,d18 <malloc+0x70>
  if(nu < 4096)
 cde:	8a4e                	mv	s4,s3
 ce0:	0009871b          	sext.w	a4,s3
 ce4:	6685                	lui	a3,0x1
 ce6:	00d77363          	bgeu	a4,a3,cec <malloc+0x44>
 cea:	6a05                	lui	s4,0x1
 cec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cf0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cf4:	00000917          	auipc	s2,0x0
 cf8:	1e490913          	add	s2,s2,484 # ed8 <freep>
  if(p == (char*)-1)
 cfc:	5afd                	li	s5,-1
 cfe:	a895                	j	d72 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 d00:	00009797          	auipc	a5,0x9
 d04:	bc078793          	add	a5,a5,-1088 # 98c0 <base>
 d08:	00000717          	auipc	a4,0x0
 d0c:	1cf73823          	sd	a5,464(a4) # ed8 <freep>
 d10:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d12:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d16:	b7e1                	j	cde <malloc+0x36>
      if(p->s.size == nunits)
 d18:	02e48c63          	beq	s1,a4,d50 <malloc+0xa8>
        p->s.size -= nunits;
 d1c:	4137073b          	subw	a4,a4,s3
 d20:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d22:	02071693          	sll	a3,a4,0x20
 d26:	01c6d713          	srl	a4,a3,0x1c
 d2a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d2c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d30:	00000717          	auipc	a4,0x0
 d34:	1aa73423          	sd	a0,424(a4) # ed8 <freep>
      return (void*)(p + 1);
 d38:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d3c:	70e2                	ld	ra,56(sp)
 d3e:	7442                	ld	s0,48(sp)
 d40:	74a2                	ld	s1,40(sp)
 d42:	7902                	ld	s2,32(sp)
 d44:	69e2                	ld	s3,24(sp)
 d46:	6a42                	ld	s4,16(sp)
 d48:	6aa2                	ld	s5,8(sp)
 d4a:	6b02                	ld	s6,0(sp)
 d4c:	6121                	add	sp,sp,64
 d4e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d50:	6398                	ld	a4,0(a5)
 d52:	e118                	sd	a4,0(a0)
 d54:	bff1                	j	d30 <malloc+0x88>
  hp->s.size = nu;
 d56:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d5a:	0541                	add	a0,a0,16
 d5c:	00000097          	auipc	ra,0x0
 d60:	eca080e7          	jalr	-310(ra) # c26 <free>
  return freep;
 d64:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d68:	d971                	beqz	a0,d3c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d6c:	4798                	lw	a4,8(a5)
 d6e:	fa9775e3          	bgeu	a4,s1,d18 <malloc+0x70>
    if(p == freep)
 d72:	00093703          	ld	a4,0(s2)
 d76:	853e                	mv	a0,a5
 d78:	fef719e3          	bne	a4,a5,d6a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 d7c:	8552                	mv	a0,s4
 d7e:	00000097          	auipc	ra,0x0
 d82:	a90080e7          	jalr	-1392(ra) # 80e <sbrk>
  if(p == (char*)-1)
 d86:	fd5518e3          	bne	a0,s5,d56 <malloc+0xae>
        return 0;
 d8a:	4501                	li	a0,0
 d8c:	bf45                	j	d3c <malloc+0x94>
