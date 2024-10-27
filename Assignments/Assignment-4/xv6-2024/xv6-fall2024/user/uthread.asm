
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
   a:	e4278793          	add	a5,a5,-446 # e48 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	e2f73523          	sd	a5,-470(a4) # e38 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	eaf72023          	sw	a5,-352(a4) # 2eb8 <__global_pointer$+0x189f>
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
  32:	e0a53503          	ld	a0,-502(a0) # e38 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	add	a1,a1,120 # 2078 <__global_pointer$+0xa5f>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	fe880813          	add	a6,a6,-24 # 9028 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	add	a7,a3,120 # 2078 <__global_pointer$+0xa5f>
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
  6a:	de258593          	add	a1,a1,-542 # e48 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	c9050513          	add	a0,a0,-880 # d00 <malloc+0xea>
  78:	00001097          	auipc	ra,0x1
  7c:	ae6080e7          	jalr	-1306(ra) # b5e <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	672080e7          	jalr	1650(ra) # 6f4 <exit>
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
  9a:	dab7b123          	sd	a1,-606(a5) # e38 <current_thread>
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
  b8:	d9478793          	add	a5,a5,-620 # e48 <all_thread>
    if (t->state == FREE) break;
  bc:	6709                	lui	a4,0x2
  be:	07070613          	add	a2,a4,112 # 2070 <__global_pointer$+0xa57>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c2:	07870713          	add	a4,a4,120
  c6:	00009597          	auipc	a1,0x9
  ca:	f6258593          	add	a1,a1,-158 # 9028 <base>
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
 102:	d3a7b783          	ld	a5,-710(a5) # e38 <current_thread>
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
 132:	bfa50513          	add	a0,a0,-1030 # d28 <malloc+0x112>
 136:	00001097          	auipc	ra,0x1
 13a:	a28080e7          	jalr	-1496(ra) # b5e <printf>
  a_started = 1;
 13e:	4785                	li	a5,1
 140:	00001717          	auipc	a4,0x1
 144:	cef72a23          	sw	a5,-780(a4) # e34 <a_started>
  while(b_started == 0 || c_started == 0)
 148:	00001497          	auipc	s1,0x1
 14c:	ce848493          	add	s1,s1,-792 # e30 <b_started>
 150:	00001917          	auipc	s2,0x1
 154:	cdc90913          	add	s2,s2,-804 # e2c <c_started>
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
 176:	bcea0a13          	add	s4,s4,-1074 # d40 <malloc+0x12a>
    a_n += 1;
 17a:	00001917          	auipc	s2,0x1
 17e:	cae90913          	add	s2,s2,-850 # e28 <a_n>
  for (i = 0; i < 100; i++) {
 182:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 186:	85a6                	mv	a1,s1
 188:	8552                	mv	a0,s4
 18a:	00001097          	auipc	ra,0x1
 18e:	9d4080e7          	jalr	-1580(ra) # b5e <printf>
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
 1ae:	c7e5a583          	lw	a1,-898(a1) # e28 <a_n>
 1b2:	00001517          	auipc	a0,0x1
 1b6:	b9e50513          	add	a0,a0,-1122 # d50 <malloc+0x13a>
 1ba:	00001097          	auipc	ra,0x1
 1be:	9a4080e7          	jalr	-1628(ra) # b5e <printf>

  current_thread->state = FREE;
 1c2:	00001797          	auipc	a5,0x1
 1c6:	c767b783          	ld	a5,-906(a5) # e38 <current_thread>
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
 1fe:	b7650513          	add	a0,a0,-1162 # d70 <malloc+0x15a>
 202:	00001097          	auipc	ra,0x1
 206:	95c080e7          	jalr	-1700(ra) # b5e <printf>
  b_started = 1;
 20a:	4785                	li	a5,1
 20c:	00001717          	auipc	a4,0x1
 210:	c2f72223          	sw	a5,-988(a4) # e30 <b_started>
  while(a_started == 0 || c_started == 0)
 214:	00001497          	auipc	s1,0x1
 218:	c2048493          	add	s1,s1,-992 # e34 <a_started>
 21c:	00001917          	auipc	s2,0x1
 220:	c1090913          	add	s2,s2,-1008 # e2c <c_started>
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
 242:	b4aa0a13          	add	s4,s4,-1206 # d88 <malloc+0x172>
    b_n += 1;
 246:	00001917          	auipc	s2,0x1
 24a:	bde90913          	add	s2,s2,-1058 # e24 <b_n>
  for (i = 0; i < 100; i++) {
 24e:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 252:	85a6                	mv	a1,s1
 254:	8552                	mv	a0,s4
 256:	00001097          	auipc	ra,0x1
 25a:	908080e7          	jalr	-1784(ra) # b5e <printf>
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
 27a:	bae5a583          	lw	a1,-1106(a1) # e24 <b_n>
 27e:	00001517          	auipc	a0,0x1
 282:	b1a50513          	add	a0,a0,-1254 # d98 <malloc+0x182>
 286:	00001097          	auipc	ra,0x1
 28a:	8d8080e7          	jalr	-1832(ra) # b5e <printf>

  current_thread->state = FREE;
 28e:	00001797          	auipc	a5,0x1
 292:	baa7b783          	ld	a5,-1110(a5) # e38 <current_thread>
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
 2ca:	af250513          	add	a0,a0,-1294 # db8 <malloc+0x1a2>
 2ce:	00001097          	auipc	ra,0x1
 2d2:	890080e7          	jalr	-1904(ra) # b5e <printf>
  c_started = 1;
 2d6:	4785                	li	a5,1
 2d8:	00001717          	auipc	a4,0x1
 2dc:	b4f72a23          	sw	a5,-1196(a4) # e2c <c_started>
  while(a_started == 0 || b_started == 0)
 2e0:	00001497          	auipc	s1,0x1
 2e4:	b5448493          	add	s1,s1,-1196 # e34 <a_started>
 2e8:	00001917          	auipc	s2,0x1
 2ec:	b4890913          	add	s2,s2,-1208 # e30 <b_started>
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
 30e:	ac6a0a13          	add	s4,s4,-1338 # dd0 <malloc+0x1ba>
    c_n += 1;
 312:	00001917          	auipc	s2,0x1
 316:	b0e90913          	add	s2,s2,-1266 # e20 <c_n>
  for (i = 0; i < 100; i++) {
 31a:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31e:	85a6                	mv	a1,s1
 320:	8552                	mv	a0,s4
 322:	00001097          	auipc	ra,0x1
 326:	83c080e7          	jalr	-1988(ra) # b5e <printf>
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
 346:	ade5a583          	lw	a1,-1314(a1) # e20 <c_n>
 34a:	00001517          	auipc	a0,0x1
 34e:	a9650513          	add	a0,a0,-1386 # de0 <malloc+0x1ca>
 352:	00001097          	auipc	ra,0x1
 356:	80c080e7          	jalr	-2036(ra) # b5e <printf>

  current_thread->state = FREE;
 35a:	00001797          	auipc	a5,0x1
 35e:	ade7b783          	ld	a5,-1314(a5) # e38 <current_thread>
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
 38e:	aa07a123          	sw	zero,-1374(a5) # e2c <c_started>
 392:	00001797          	auipc	a5,0x1
 396:	a807af23          	sw	zero,-1378(a5) # e30 <b_started>
 39a:	00001797          	auipc	a5,0x1
 39e:	a807ad23          	sw	zero,-1382(a5) # e34 <a_started>
  a_n = b_n = c_n = 0;
 3a2:	00001797          	auipc	a5,0x1
 3a6:	a607af23          	sw	zero,-1410(a5) # e20 <c_n>
 3aa:	00001797          	auipc	a5,0x1
 3ae:	a607ad23          	sw	zero,-1414(a5) # e24 <b_n>
 3b2:	00001797          	auipc	a5,0x1
 3b6:	a607ab23          	sw	zero,-1418(a5) # e28 <a_n>
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
 400:	2f8080e7          	jalr	760(ra) # 6f4 <exit>

0000000000000404 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	sd ra, 0(a0)
 404:	00153023          	sd	ra,0(a0)
	sd sp, 8(a0)
 408:	00253423          	sd	sp,8(a0)
	sd s0, 16(a0)
 40c:	e900                	sd	s0,16(a0)
	sd s1, 24(a0)
 40e:	ed04                	sd	s1,24(a0)
	sd s2, 32(a0)
 410:	03253023          	sd	s2,32(a0)
	sd s3, 40(a0)
 414:	03353423          	sd	s3,40(a0)
	sd s4, 48(a0)
 418:	03453823          	sd	s4,48(a0)
	sd s5, 56(a0)
 41c:	03553c23          	sd	s5,56(a0)
	sd s6, 64(a0)
 420:	05653023          	sd	s6,64(a0)
	sd s7, 72(a0)
 424:	05753423          	sd	s7,72(a0)
	sd s8, 80(a0)
 428:	05853823          	sd	s8,80(a0)
	sd s9, 88(a0)
 42c:	05953c23          	sd	s9,88(a0)
	sd s10, 96(a0)
 430:	07a53023          	sd	s10,96(a0)
	sd s11, 104(a0)
 434:	07b53423          	sd	s11,104(a0)
	
	
	ld ra, 0(a1)
 438:	0005b083          	ld	ra,0(a1)
	ld sp, 8(a1)
 43c:	0085b103          	ld	sp,8(a1)
	ld s0, 16(a1)
 440:	6980                	ld	s0,16(a1)
	ld s1, 24(a1)
 442:	6d84                	ld	s1,24(a1)
	ld s2, 32(a1)
 444:	0205b903          	ld	s2,32(a1)
	ld s3, 40(a1) 
 448:	0285b983          	ld	s3,40(a1)
	ld s4, 48(a1)
 44c:	0305ba03          	ld	s4,48(a1)
	ld s5, 56(a1)
 450:	0385ba83          	ld	s5,56(a1)
	ld s6, 64(a1)
 454:	0405bb03          	ld	s6,64(a1)
	ld s7, 72(a1)
 458:	0485bb83          	ld	s7,72(a1)
	ld s8, 80(a1)
 45c:	0505bc03          	ld	s8,80(a1)
	ld s9, 88(a1)
 460:	0585bc83          	ld	s9,88(a1)
	ld s10, 96(a1)
 464:	0605bd03          	ld	s10,96(a1)
	ld s11, 104(a1)
 468:	0685bd83          	ld	s11,104(a1)
	

	ret    /* return to ra */
 46c:	8082                	ret

000000000000046e <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 46e:	1141                	add	sp,sp,-16
 470:	e406                	sd	ra,8(sp)
 472:	e022                	sd	s0,0(sp)
 474:	0800                	add	s0,sp,16
  extern int main();
  main();
 476:	00000097          	auipc	ra,0x0
 47a:	f0c080e7          	jalr	-244(ra) # 382 <main>
  exit(0);
 47e:	4501                	li	a0,0
 480:	00000097          	auipc	ra,0x0
 484:	274080e7          	jalr	628(ra) # 6f4 <exit>

0000000000000488 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 488:	1141                	add	sp,sp,-16
 48a:	e422                	sd	s0,8(sp)
 48c:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 48e:	87aa                	mv	a5,a0
 490:	0585                	add	a1,a1,1
 492:	0785                	add	a5,a5,1
 494:	fff5c703          	lbu	a4,-1(a1)
 498:	fee78fa3          	sb	a4,-1(a5)
 49c:	fb75                	bnez	a4,490 <strcpy+0x8>
    ;
  return os;
}
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	add	sp,sp,16
 4a2:	8082                	ret

00000000000004a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a4:	1141                	add	sp,sp,-16
 4a6:	e422                	sd	s0,8(sp)
 4a8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 4aa:	00054783          	lbu	a5,0(a0)
 4ae:	cb91                	beqz	a5,4c2 <strcmp+0x1e>
 4b0:	0005c703          	lbu	a4,0(a1)
 4b4:	00f71763          	bne	a4,a5,4c2 <strcmp+0x1e>
    p++, q++;
 4b8:	0505                	add	a0,a0,1
 4ba:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 4bc:	00054783          	lbu	a5,0(a0)
 4c0:	fbe5                	bnez	a5,4b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4c2:	0005c503          	lbu	a0,0(a1)
}
 4c6:	40a7853b          	subw	a0,a5,a0
 4ca:	6422                	ld	s0,8(sp)
 4cc:	0141                	add	sp,sp,16
 4ce:	8082                	ret

00000000000004d0 <strlen>:

uint
strlen(const char *s)
{
 4d0:	1141                	add	sp,sp,-16
 4d2:	e422                	sd	s0,8(sp)
 4d4:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4d6:	00054783          	lbu	a5,0(a0)
 4da:	cf91                	beqz	a5,4f6 <strlen+0x26>
 4dc:	0505                	add	a0,a0,1
 4de:	87aa                	mv	a5,a0
 4e0:	86be                	mv	a3,a5
 4e2:	0785                	add	a5,a5,1
 4e4:	fff7c703          	lbu	a4,-1(a5)
 4e8:	ff65                	bnez	a4,4e0 <strlen+0x10>
 4ea:	40a6853b          	subw	a0,a3,a0
 4ee:	2505                	addw	a0,a0,1
    ;
  return n;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	add	sp,sp,16
 4f4:	8082                	ret
  for(n = 0; s[n]; n++)
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <strlen+0x20>

00000000000004fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 4fa:	1141                	add	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 500:	ca19                	beqz	a2,516 <memset+0x1c>
 502:	87aa                	mv	a5,a0
 504:	1602                	sll	a2,a2,0x20
 506:	9201                	srl	a2,a2,0x20
 508:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 50c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 510:	0785                	add	a5,a5,1
 512:	fee79de3          	bne	a5,a4,50c <memset+0x12>
  }
  return dst;
}
 516:	6422                	ld	s0,8(sp)
 518:	0141                	add	sp,sp,16
 51a:	8082                	ret

000000000000051c <strchr>:

char*
strchr(const char *s, char c)
{
 51c:	1141                	add	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	add	s0,sp,16
  for(; *s; s++)
 522:	00054783          	lbu	a5,0(a0)
 526:	cb99                	beqz	a5,53c <strchr+0x20>
    if(*s == c)
 528:	00f58763          	beq	a1,a5,536 <strchr+0x1a>
  for(; *s; s++)
 52c:	0505                	add	a0,a0,1
 52e:	00054783          	lbu	a5,0(a0)
 532:	fbfd                	bnez	a5,528 <strchr+0xc>
      return (char*)s;
  return 0;
 534:	4501                	li	a0,0
}
 536:	6422                	ld	s0,8(sp)
 538:	0141                	add	sp,sp,16
 53a:	8082                	ret
  return 0;
 53c:	4501                	li	a0,0
 53e:	bfe5                	j	536 <strchr+0x1a>

0000000000000540 <gets>:

char*
gets(char *buf, int max)
{
 540:	711d                	add	sp,sp,-96
 542:	ec86                	sd	ra,88(sp)
 544:	e8a2                	sd	s0,80(sp)
 546:	e4a6                	sd	s1,72(sp)
 548:	e0ca                	sd	s2,64(sp)
 54a:	fc4e                	sd	s3,56(sp)
 54c:	f852                	sd	s4,48(sp)
 54e:	f456                	sd	s5,40(sp)
 550:	f05a                	sd	s6,32(sp)
 552:	ec5e                	sd	s7,24(sp)
 554:	1080                	add	s0,sp,96
 556:	8baa                	mv	s7,a0
 558:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 55a:	892a                	mv	s2,a0
 55c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 55e:	4aa9                	li	s5,10
 560:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 562:	89a6                	mv	s3,s1
 564:	2485                	addw	s1,s1,1
 566:	0344d863          	bge	s1,s4,596 <gets+0x56>
    cc = read(0, &c, 1);
 56a:	4605                	li	a2,1
 56c:	faf40593          	add	a1,s0,-81
 570:	4501                	li	a0,0
 572:	00000097          	auipc	ra,0x0
 576:	19a080e7          	jalr	410(ra) # 70c <read>
    if(cc < 1)
 57a:	00a05e63          	blez	a0,596 <gets+0x56>
    buf[i++] = c;
 57e:	faf44783          	lbu	a5,-81(s0)
 582:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 586:	01578763          	beq	a5,s5,594 <gets+0x54>
 58a:	0905                	add	s2,s2,1
 58c:	fd679be3          	bne	a5,s6,562 <gets+0x22>
  for(i=0; i+1 < max; ){
 590:	89a6                	mv	s3,s1
 592:	a011                	j	596 <gets+0x56>
 594:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 596:	99de                	add	s3,s3,s7
 598:	00098023          	sb	zero,0(s3)
  return buf;
}
 59c:	855e                	mv	a0,s7
 59e:	60e6                	ld	ra,88(sp)
 5a0:	6446                	ld	s0,80(sp)
 5a2:	64a6                	ld	s1,72(sp)
 5a4:	6906                	ld	s2,64(sp)
 5a6:	79e2                	ld	s3,56(sp)
 5a8:	7a42                	ld	s4,48(sp)
 5aa:	7aa2                	ld	s5,40(sp)
 5ac:	7b02                	ld	s6,32(sp)
 5ae:	6be2                	ld	s7,24(sp)
 5b0:	6125                	add	sp,sp,96
 5b2:	8082                	ret

00000000000005b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 5b4:	1101                	add	sp,sp,-32
 5b6:	ec06                	sd	ra,24(sp)
 5b8:	e822                	sd	s0,16(sp)
 5ba:	e426                	sd	s1,8(sp)
 5bc:	e04a                	sd	s2,0(sp)
 5be:	1000                	add	s0,sp,32
 5c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5c2:	4581                	li	a1,0
 5c4:	00000097          	auipc	ra,0x0
 5c8:	170080e7          	jalr	368(ra) # 734 <open>
  if(fd < 0)
 5cc:	02054563          	bltz	a0,5f6 <stat+0x42>
 5d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5d2:	85ca                	mv	a1,s2
 5d4:	00000097          	auipc	ra,0x0
 5d8:	178080e7          	jalr	376(ra) # 74c <fstat>
 5dc:	892a                	mv	s2,a0
  close(fd);
 5de:	8526                	mv	a0,s1
 5e0:	00000097          	auipc	ra,0x0
 5e4:	13c080e7          	jalr	316(ra) # 71c <close>
  return r;
}
 5e8:	854a                	mv	a0,s2
 5ea:	60e2                	ld	ra,24(sp)
 5ec:	6442                	ld	s0,16(sp)
 5ee:	64a2                	ld	s1,8(sp)
 5f0:	6902                	ld	s2,0(sp)
 5f2:	6105                	add	sp,sp,32
 5f4:	8082                	ret
    return -1;
 5f6:	597d                	li	s2,-1
 5f8:	bfc5                	j	5e8 <stat+0x34>

00000000000005fa <atoi>:

int
atoi(const char *s)
{
 5fa:	1141                	add	sp,sp,-16
 5fc:	e422                	sd	s0,8(sp)
 5fe:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 600:	00054683          	lbu	a3,0(a0)
 604:	fd06879b          	addw	a5,a3,-48 # 1fd0 <__global_pointer$+0x9b7>
 608:	0ff7f793          	zext.b	a5,a5
 60c:	4625                	li	a2,9
 60e:	02f66863          	bltu	a2,a5,63e <atoi+0x44>
 612:	872a                	mv	a4,a0
  n = 0;
 614:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 616:	0705                	add	a4,a4,1 # 2001 <__global_pointer$+0x9e8>
 618:	0025179b          	sllw	a5,a0,0x2
 61c:	9fa9                	addw	a5,a5,a0
 61e:	0017979b          	sllw	a5,a5,0x1
 622:	9fb5                	addw	a5,a5,a3
 624:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 628:	00074683          	lbu	a3,0(a4)
 62c:	fd06879b          	addw	a5,a3,-48
 630:	0ff7f793          	zext.b	a5,a5
 634:	fef671e3          	bgeu	a2,a5,616 <atoi+0x1c>
  return n;
}
 638:	6422                	ld	s0,8(sp)
 63a:	0141                	add	sp,sp,16
 63c:	8082                	ret
  n = 0;
 63e:	4501                	li	a0,0
 640:	bfe5                	j	638 <atoi+0x3e>

0000000000000642 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 642:	1141                	add	sp,sp,-16
 644:	e422                	sd	s0,8(sp)
 646:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 648:	02b57463          	bgeu	a0,a1,670 <memmove+0x2e>
    while(n-- > 0)
 64c:	00c05f63          	blez	a2,66a <memmove+0x28>
 650:	1602                	sll	a2,a2,0x20
 652:	9201                	srl	a2,a2,0x20
 654:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 658:	872a                	mv	a4,a0
      *dst++ = *src++;
 65a:	0585                	add	a1,a1,1
 65c:	0705                	add	a4,a4,1
 65e:	fff5c683          	lbu	a3,-1(a1)
 662:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 666:	fee79ae3          	bne	a5,a4,65a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 66a:	6422                	ld	s0,8(sp)
 66c:	0141                	add	sp,sp,16
 66e:	8082                	ret
    dst += n;
 670:	00c50733          	add	a4,a0,a2
    src += n;
 674:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 676:	fec05ae3          	blez	a2,66a <memmove+0x28>
 67a:	fff6079b          	addw	a5,a2,-1
 67e:	1782                	sll	a5,a5,0x20
 680:	9381                	srl	a5,a5,0x20
 682:	fff7c793          	not	a5,a5
 686:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 688:	15fd                	add	a1,a1,-1
 68a:	177d                	add	a4,a4,-1
 68c:	0005c683          	lbu	a3,0(a1)
 690:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 694:	fee79ae3          	bne	a5,a4,688 <memmove+0x46>
 698:	bfc9                	j	66a <memmove+0x28>

000000000000069a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 69a:	1141                	add	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6a0:	ca05                	beqz	a2,6d0 <memcmp+0x36>
 6a2:	fff6069b          	addw	a3,a2,-1
 6a6:	1682                	sll	a3,a3,0x20
 6a8:	9281                	srl	a3,a3,0x20
 6aa:	0685                	add	a3,a3,1
 6ac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6ae:	00054783          	lbu	a5,0(a0)
 6b2:	0005c703          	lbu	a4,0(a1)
 6b6:	00e79863          	bne	a5,a4,6c6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6ba:	0505                	add	a0,a0,1
    p2++;
 6bc:	0585                	add	a1,a1,1
  while (n-- > 0) {
 6be:	fed518e3          	bne	a0,a3,6ae <memcmp+0x14>
  }
  return 0;
 6c2:	4501                	li	a0,0
 6c4:	a019                	j	6ca <memcmp+0x30>
      return *p1 - *p2;
 6c6:	40e7853b          	subw	a0,a5,a4
}
 6ca:	6422                	ld	s0,8(sp)
 6cc:	0141                	add	sp,sp,16
 6ce:	8082                	ret
  return 0;
 6d0:	4501                	li	a0,0
 6d2:	bfe5                	j	6ca <memcmp+0x30>

00000000000006d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6d4:	1141                	add	sp,sp,-16
 6d6:	e406                	sd	ra,8(sp)
 6d8:	e022                	sd	s0,0(sp)
 6da:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 6dc:	00000097          	auipc	ra,0x0
 6e0:	f66080e7          	jalr	-154(ra) # 642 <memmove>
}
 6e4:	60a2                	ld	ra,8(sp)
 6e6:	6402                	ld	s0,0(sp)
 6e8:	0141                	add	sp,sp,16
 6ea:	8082                	ret

00000000000006ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ec:	4885                	li	a7,1
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6f4:	4889                	li	a7,2
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 6fc:	488d                	li	a7,3
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 704:	4891                	li	a7,4
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <read>:
.global read
read:
 li a7, SYS_read
 70c:	4895                	li	a7,5
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <write>:
.global write
write:
 li a7, SYS_write
 714:	48c1                	li	a7,16
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <close>:
.global close
close:
 li a7, SYS_close
 71c:	48d5                	li	a7,21
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <kill>:
.global kill
kill:
 li a7, SYS_kill
 724:	4899                	li	a7,6
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <exec>:
.global exec
exec:
 li a7, SYS_exec
 72c:	489d                	li	a7,7
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <open>:
.global open
open:
 li a7, SYS_open
 734:	48bd                	li	a7,15
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 73c:	48c5                	li	a7,17
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 744:	48c9                	li	a7,18
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 74c:	48a1                	li	a7,8
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <link>:
.global link
link:
 li a7, SYS_link
 754:	48cd                	li	a7,19
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 75c:	48d1                	li	a7,20
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 764:	48a5                	li	a7,9
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <dup>:
.global dup
dup:
 li a7, SYS_dup
 76c:	48a9                	li	a7,10
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 774:	48ad                	li	a7,11
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 77c:	48b1                	li	a7,12
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 784:	48b5                	li	a7,13
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 78c:	48b9                	li	a7,14
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 794:	1101                	add	sp,sp,-32
 796:	ec06                	sd	ra,24(sp)
 798:	e822                	sd	s0,16(sp)
 79a:	1000                	add	s0,sp,32
 79c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7a0:	4605                	li	a2,1
 7a2:	fef40593          	add	a1,s0,-17
 7a6:	00000097          	auipc	ra,0x0
 7aa:	f6e080e7          	jalr	-146(ra) # 714 <write>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6105                	add	sp,sp,32
 7b4:	8082                	ret

00000000000007b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b6:	7139                	add	sp,sp,-64
 7b8:	fc06                	sd	ra,56(sp)
 7ba:	f822                	sd	s0,48(sp)
 7bc:	f426                	sd	s1,40(sp)
 7be:	f04a                	sd	s2,32(sp)
 7c0:	ec4e                	sd	s3,24(sp)
 7c2:	0080                	add	s0,sp,64
 7c4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7c6:	c299                	beqz	a3,7cc <printint+0x16>
 7c8:	0805c963          	bltz	a1,85a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7cc:	2581                	sext.w	a1,a1
  neg = 0;
 7ce:	4881                	li	a7,0
 7d0:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 7d4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7d6:	2601                	sext.w	a2,a2
 7d8:	00000517          	auipc	a0,0x0
 7dc:	63050513          	add	a0,a0,1584 # e08 <digits>
 7e0:	883a                	mv	a6,a4
 7e2:	2705                	addw	a4,a4,1
 7e4:	02c5f7bb          	remuw	a5,a1,a2
 7e8:	1782                	sll	a5,a5,0x20
 7ea:	9381                	srl	a5,a5,0x20
 7ec:	97aa                	add	a5,a5,a0
 7ee:	0007c783          	lbu	a5,0(a5)
 7f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7f6:	0005879b          	sext.w	a5,a1
 7fa:	02c5d5bb          	divuw	a1,a1,a2
 7fe:	0685                	add	a3,a3,1
 800:	fec7f0e3          	bgeu	a5,a2,7e0 <printint+0x2a>
  if(neg)
 804:	00088c63          	beqz	a7,81c <printint+0x66>
    buf[i++] = '-';
 808:	fd070793          	add	a5,a4,-48
 80c:	00878733          	add	a4,a5,s0
 810:	02d00793          	li	a5,45
 814:	fef70823          	sb	a5,-16(a4)
 818:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 81c:	02e05863          	blez	a4,84c <printint+0x96>
 820:	fc040793          	add	a5,s0,-64
 824:	00e78933          	add	s2,a5,a4
 828:	fff78993          	add	s3,a5,-1
 82c:	99ba                	add	s3,s3,a4
 82e:	377d                	addw	a4,a4,-1
 830:	1702                	sll	a4,a4,0x20
 832:	9301                	srl	a4,a4,0x20
 834:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 838:	fff94583          	lbu	a1,-1(s2)
 83c:	8526                	mv	a0,s1
 83e:	00000097          	auipc	ra,0x0
 842:	f56080e7          	jalr	-170(ra) # 794 <putc>
  while(--i >= 0)
 846:	197d                	add	s2,s2,-1
 848:	ff3918e3          	bne	s2,s3,838 <printint+0x82>
}
 84c:	70e2                	ld	ra,56(sp)
 84e:	7442                	ld	s0,48(sp)
 850:	74a2                	ld	s1,40(sp)
 852:	7902                	ld	s2,32(sp)
 854:	69e2                	ld	s3,24(sp)
 856:	6121                	add	sp,sp,64
 858:	8082                	ret
    x = -xx;
 85a:	40b005bb          	negw	a1,a1
    neg = 1;
 85e:	4885                	li	a7,1
    x = -xx;
 860:	bf85                	j	7d0 <printint+0x1a>

0000000000000862 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 862:	711d                	add	sp,sp,-96
 864:	ec86                	sd	ra,88(sp)
 866:	e8a2                	sd	s0,80(sp)
 868:	e4a6                	sd	s1,72(sp)
 86a:	e0ca                	sd	s2,64(sp)
 86c:	fc4e                	sd	s3,56(sp)
 86e:	f852                	sd	s4,48(sp)
 870:	f456                	sd	s5,40(sp)
 872:	f05a                	sd	s6,32(sp)
 874:	ec5e                	sd	s7,24(sp)
 876:	e862                	sd	s8,16(sp)
 878:	e466                	sd	s9,8(sp)
 87a:	e06a                	sd	s10,0(sp)
 87c:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 87e:	0005c903          	lbu	s2,0(a1)
 882:	28090963          	beqz	s2,b14 <vprintf+0x2b2>
 886:	8b2a                	mv	s6,a0
 888:	8a2e                	mv	s4,a1
 88a:	8bb2                	mv	s7,a2
  state = 0;
 88c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 88e:	4481                	li	s1,0
 890:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 892:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 896:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 89a:	06c00c93          	li	s9,108
 89e:	a015                	j	8c2 <vprintf+0x60>
        putc(fd, c0);
 8a0:	85ca                	mv	a1,s2
 8a2:	855a                	mv	a0,s6
 8a4:	00000097          	auipc	ra,0x0
 8a8:	ef0080e7          	jalr	-272(ra) # 794 <putc>
 8ac:	a019                	j	8b2 <vprintf+0x50>
    } else if(state == '%'){
 8ae:	03598263          	beq	s3,s5,8d2 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 8b2:	2485                	addw	s1,s1,1
 8b4:	8726                	mv	a4,s1
 8b6:	009a07b3          	add	a5,s4,s1
 8ba:	0007c903          	lbu	s2,0(a5)
 8be:	24090b63          	beqz	s2,b14 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 8c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8c6:	fe0994e3          	bnez	s3,8ae <vprintf+0x4c>
      if(c0 == '%'){
 8ca:	fd579be3          	bne	a5,s5,8a0 <vprintf+0x3e>
        state = '%';
 8ce:	89be                	mv	s3,a5
 8d0:	b7cd                	j	8b2 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 8d2:	cbc9                	beqz	a5,964 <vprintf+0x102>
 8d4:	00ea06b3          	add	a3,s4,a4
 8d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 8de:	c681                	beqz	a3,8e6 <vprintf+0x84>
 8e0:	9752                	add	a4,a4,s4
 8e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 8e6:	05878163          	beq	a5,s8,928 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 8ea:	05978d63          	beq	a5,s9,944 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 8ee:	07500713          	li	a4,117
 8f2:	10e78163          	beq	a5,a4,9f4 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 8f6:	07800713          	li	a4,120
 8fa:	14e78963          	beq	a5,a4,a4c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 8fe:	07000713          	li	a4,112
 902:	18e78263          	beq	a5,a4,a86 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 906:	07300713          	li	a4,115
 90a:	1ce78663          	beq	a5,a4,ad6 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 90e:	02500713          	li	a4,37
 912:	04e79963          	bne	a5,a4,964 <vprintf+0x102>
        putc(fd, '%');
 916:	02500593          	li	a1,37
 91a:	855a                	mv	a0,s6
 91c:	00000097          	auipc	ra,0x0
 920:	e78080e7          	jalr	-392(ra) # 794 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 924:	4981                	li	s3,0
 926:	b771                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 928:	008b8913          	add	s2,s7,8
 92c:	4685                	li	a3,1
 92e:	4629                	li	a2,10
 930:	000ba583          	lw	a1,0(s7)
 934:	855a                	mv	a0,s6
 936:	00000097          	auipc	ra,0x0
 93a:	e80080e7          	jalr	-384(ra) # 7b6 <printint>
 93e:	8bca                	mv	s7,s2
      state = 0;
 940:	4981                	li	s3,0
 942:	bf85                	j	8b2 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 944:	06400793          	li	a5,100
 948:	02f68d63          	beq	a3,a5,982 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 94c:	06c00793          	li	a5,108
 950:	04f68863          	beq	a3,a5,9a0 <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 954:	07500793          	li	a5,117
 958:	0af68c63          	beq	a3,a5,a10 <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 95c:	07800793          	li	a5,120
 960:	10f68463          	beq	a3,a5,a68 <vprintf+0x206>
        putc(fd, '%');
 964:	02500593          	li	a1,37
 968:	855a                	mv	a0,s6
 96a:	00000097          	auipc	ra,0x0
 96e:	e2a080e7          	jalr	-470(ra) # 794 <putc>
        putc(fd, c0);
 972:	85ca                	mv	a1,s2
 974:	855a                	mv	a0,s6
 976:	00000097          	auipc	ra,0x0
 97a:	e1e080e7          	jalr	-482(ra) # 794 <putc>
      state = 0;
 97e:	4981                	li	s3,0
 980:	bf0d                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 982:	008b8913          	add	s2,s7,8
 986:	4685                	li	a3,1
 988:	4629                	li	a2,10
 98a:	000ba583          	lw	a1,0(s7)
 98e:	855a                	mv	a0,s6
 990:	00000097          	auipc	ra,0x0
 994:	e26080e7          	jalr	-474(ra) # 7b6 <printint>
        i += 1;
 998:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 99a:	8bca                	mv	s7,s2
      state = 0;
 99c:	4981                	li	s3,0
        i += 1;
 99e:	bf11                	j	8b2 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9a0:	06400793          	li	a5,100
 9a4:	02f60963          	beq	a2,a5,9d6 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9a8:	07500793          	li	a5,117
 9ac:	08f60163          	beq	a2,a5,a2e <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9b0:	07800793          	li	a5,120
 9b4:	faf618e3          	bne	a2,a5,964 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b8:	008b8913          	add	s2,s7,8
 9bc:	4681                	li	a3,0
 9be:	4641                	li	a2,16
 9c0:	000ba583          	lw	a1,0(s7)
 9c4:	855a                	mv	a0,s6
 9c6:	00000097          	auipc	ra,0x0
 9ca:	df0080e7          	jalr	-528(ra) # 7b6 <printint>
        i += 2;
 9ce:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9d0:	8bca                	mv	s7,s2
      state = 0;
 9d2:	4981                	li	s3,0
        i += 2;
 9d4:	bdf9                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9d6:	008b8913          	add	s2,s7,8
 9da:	4685                	li	a3,1
 9dc:	4629                	li	a2,10
 9de:	000ba583          	lw	a1,0(s7)
 9e2:	855a                	mv	a0,s6
 9e4:	00000097          	auipc	ra,0x0
 9e8:	dd2080e7          	jalr	-558(ra) # 7b6 <printint>
        i += 2;
 9ec:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9ee:	8bca                	mv	s7,s2
      state = 0;
 9f0:	4981                	li	s3,0
        i += 2;
 9f2:	b5c1                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 9f4:	008b8913          	add	s2,s7,8
 9f8:	4681                	li	a3,0
 9fa:	4629                	li	a2,10
 9fc:	000ba583          	lw	a1,0(s7)
 a00:	855a                	mv	a0,s6
 a02:	00000097          	auipc	ra,0x0
 a06:	db4080e7          	jalr	-588(ra) # 7b6 <printint>
 a0a:	8bca                	mv	s7,s2
      state = 0;
 a0c:	4981                	li	s3,0
 a0e:	b555                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a10:	008b8913          	add	s2,s7,8
 a14:	4681                	li	a3,0
 a16:	4629                	li	a2,10
 a18:	000ba583          	lw	a1,0(s7)
 a1c:	855a                	mv	a0,s6
 a1e:	00000097          	auipc	ra,0x0
 a22:	d98080e7          	jalr	-616(ra) # 7b6 <printint>
        i += 1;
 a26:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a28:	8bca                	mv	s7,s2
      state = 0;
 a2a:	4981                	li	s3,0
        i += 1;
 a2c:	b559                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a2e:	008b8913          	add	s2,s7,8
 a32:	4681                	li	a3,0
 a34:	4629                	li	a2,10
 a36:	000ba583          	lw	a1,0(s7)
 a3a:	855a                	mv	a0,s6
 a3c:	00000097          	auipc	ra,0x0
 a40:	d7a080e7          	jalr	-646(ra) # 7b6 <printint>
        i += 2;
 a44:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a46:	8bca                	mv	s7,s2
      state = 0;
 a48:	4981                	li	s3,0
        i += 2;
 a4a:	b5a5                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 a4c:	008b8913          	add	s2,s7,8
 a50:	4681                	li	a3,0
 a52:	4641                	li	a2,16
 a54:	000ba583          	lw	a1,0(s7)
 a58:	855a                	mv	a0,s6
 a5a:	00000097          	auipc	ra,0x0
 a5e:	d5c080e7          	jalr	-676(ra) # 7b6 <printint>
 a62:	8bca                	mv	s7,s2
      state = 0;
 a64:	4981                	li	s3,0
 a66:	b5b1                	j	8b2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a68:	008b8913          	add	s2,s7,8
 a6c:	4681                	li	a3,0
 a6e:	4641                	li	a2,16
 a70:	000ba583          	lw	a1,0(s7)
 a74:	855a                	mv	a0,s6
 a76:	00000097          	auipc	ra,0x0
 a7a:	d40080e7          	jalr	-704(ra) # 7b6 <printint>
        i += 1;
 a7e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a80:	8bca                	mv	s7,s2
      state = 0;
 a82:	4981                	li	s3,0
        i += 1;
 a84:	b53d                	j	8b2 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 a86:	008b8d13          	add	s10,s7,8
 a8a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a8e:	03000593          	li	a1,48
 a92:	855a                	mv	a0,s6
 a94:	00000097          	auipc	ra,0x0
 a98:	d00080e7          	jalr	-768(ra) # 794 <putc>
  putc(fd, 'x');
 a9c:	07800593          	li	a1,120
 aa0:	855a                	mv	a0,s6
 aa2:	00000097          	auipc	ra,0x0
 aa6:	cf2080e7          	jalr	-782(ra) # 794 <putc>
 aaa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aac:	00000b97          	auipc	s7,0x0
 ab0:	35cb8b93          	add	s7,s7,860 # e08 <digits>
 ab4:	03c9d793          	srl	a5,s3,0x3c
 ab8:	97de                	add	a5,a5,s7
 aba:	0007c583          	lbu	a1,0(a5)
 abe:	855a                	mv	a0,s6
 ac0:	00000097          	auipc	ra,0x0
 ac4:	cd4080e7          	jalr	-812(ra) # 794 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ac8:	0992                	sll	s3,s3,0x4
 aca:	397d                	addw	s2,s2,-1
 acc:	fe0914e3          	bnez	s2,ab4 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 ad0:	8bea                	mv	s7,s10
      state = 0;
 ad2:	4981                	li	s3,0
 ad4:	bbf9                	j	8b2 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 ad6:	008b8993          	add	s3,s7,8
 ada:	000bb903          	ld	s2,0(s7)
 ade:	02090163          	beqz	s2,b00 <vprintf+0x29e>
        for(; *s; s++)
 ae2:	00094583          	lbu	a1,0(s2)
 ae6:	c585                	beqz	a1,b0e <vprintf+0x2ac>
          putc(fd, *s);
 ae8:	855a                	mv	a0,s6
 aea:	00000097          	auipc	ra,0x0
 aee:	caa080e7          	jalr	-854(ra) # 794 <putc>
        for(; *s; s++)
 af2:	0905                	add	s2,s2,1
 af4:	00094583          	lbu	a1,0(s2)
 af8:	f9e5                	bnez	a1,ae8 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 afa:	8bce                	mv	s7,s3
      state = 0;
 afc:	4981                	li	s3,0
 afe:	bb55                	j	8b2 <vprintf+0x50>
          s = "(null)";
 b00:	00000917          	auipc	s2,0x0
 b04:	30090913          	add	s2,s2,768 # e00 <malloc+0x1ea>
        for(; *s; s++)
 b08:	02800593          	li	a1,40
 b0c:	bff1                	j	ae8 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 b0e:	8bce                	mv	s7,s3
      state = 0;
 b10:	4981                	li	s3,0
 b12:	b345                	j	8b2 <vprintf+0x50>
    }
  }
}
 b14:	60e6                	ld	ra,88(sp)
 b16:	6446                	ld	s0,80(sp)
 b18:	64a6                	ld	s1,72(sp)
 b1a:	6906                	ld	s2,64(sp)
 b1c:	79e2                	ld	s3,56(sp)
 b1e:	7a42                	ld	s4,48(sp)
 b20:	7aa2                	ld	s5,40(sp)
 b22:	7b02                	ld	s6,32(sp)
 b24:	6be2                	ld	s7,24(sp)
 b26:	6c42                	ld	s8,16(sp)
 b28:	6ca2                	ld	s9,8(sp)
 b2a:	6d02                	ld	s10,0(sp)
 b2c:	6125                	add	sp,sp,96
 b2e:	8082                	ret

0000000000000b30 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b30:	715d                	add	sp,sp,-80
 b32:	ec06                	sd	ra,24(sp)
 b34:	e822                	sd	s0,16(sp)
 b36:	1000                	add	s0,sp,32
 b38:	e010                	sd	a2,0(s0)
 b3a:	e414                	sd	a3,8(s0)
 b3c:	e818                	sd	a4,16(s0)
 b3e:	ec1c                	sd	a5,24(s0)
 b40:	03043023          	sd	a6,32(s0)
 b44:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b48:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b4c:	8622                	mv	a2,s0
 b4e:	00000097          	auipc	ra,0x0
 b52:	d14080e7          	jalr	-748(ra) # 862 <vprintf>
}
 b56:	60e2                	ld	ra,24(sp)
 b58:	6442                	ld	s0,16(sp)
 b5a:	6161                	add	sp,sp,80
 b5c:	8082                	ret

0000000000000b5e <printf>:

void
printf(const char *fmt, ...)
{
 b5e:	711d                	add	sp,sp,-96
 b60:	ec06                	sd	ra,24(sp)
 b62:	e822                	sd	s0,16(sp)
 b64:	1000                	add	s0,sp,32
 b66:	e40c                	sd	a1,8(s0)
 b68:	e810                	sd	a2,16(s0)
 b6a:	ec14                	sd	a3,24(s0)
 b6c:	f018                	sd	a4,32(s0)
 b6e:	f41c                	sd	a5,40(s0)
 b70:	03043823          	sd	a6,48(s0)
 b74:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b78:	00840613          	add	a2,s0,8
 b7c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b80:	85aa                	mv	a1,a0
 b82:	4505                	li	a0,1
 b84:	00000097          	auipc	ra,0x0
 b88:	cde080e7          	jalr	-802(ra) # 862 <vprintf>
}
 b8c:	60e2                	ld	ra,24(sp)
 b8e:	6442                	ld	s0,16(sp)
 b90:	6125                	add	sp,sp,96
 b92:	8082                	ret

0000000000000b94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b94:	1141                	add	sp,sp,-16
 b96:	e422                	sd	s0,8(sp)
 b98:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b9a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9e:	00000797          	auipc	a5,0x0
 ba2:	2a27b783          	ld	a5,674(a5) # e40 <freep>
 ba6:	a02d                	j	bd0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ba8:	4618                	lw	a4,8(a2)
 baa:	9f2d                	addw	a4,a4,a1
 bac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 bb0:	6398                	ld	a4,0(a5)
 bb2:	6310                	ld	a2,0(a4)
 bb4:	a83d                	j	bf2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 bb6:	ff852703          	lw	a4,-8(a0)
 bba:	9f31                	addw	a4,a4,a2
 bbc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bbe:	ff053683          	ld	a3,-16(a0)
 bc2:	a091                	j	c06 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc4:	6398                	ld	a4,0(a5)
 bc6:	00e7e463          	bltu	a5,a4,bce <free+0x3a>
 bca:	00e6ea63          	bltu	a3,a4,bde <free+0x4a>
{
 bce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd0:	fed7fae3          	bgeu	a5,a3,bc4 <free+0x30>
 bd4:	6398                	ld	a4,0(a5)
 bd6:	00e6e463          	bltu	a3,a4,bde <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bda:	fee7eae3          	bltu	a5,a4,bce <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bde:	ff852583          	lw	a1,-8(a0)
 be2:	6390                	ld	a2,0(a5)
 be4:	02059813          	sll	a6,a1,0x20
 be8:	01c85713          	srl	a4,a6,0x1c
 bec:	9736                	add	a4,a4,a3
 bee:	fae60de3          	beq	a2,a4,ba8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bf2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bf6:	4790                	lw	a2,8(a5)
 bf8:	02061593          	sll	a1,a2,0x20
 bfc:	01c5d713          	srl	a4,a1,0x1c
 c00:	973e                	add	a4,a4,a5
 c02:	fae68ae3          	beq	a3,a4,bb6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c06:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c08:	00000717          	auipc	a4,0x0
 c0c:	22f73c23          	sd	a5,568(a4) # e40 <freep>
}
 c10:	6422                	ld	s0,8(sp)
 c12:	0141                	add	sp,sp,16
 c14:	8082                	ret

0000000000000c16 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c16:	7139                	add	sp,sp,-64
 c18:	fc06                	sd	ra,56(sp)
 c1a:	f822                	sd	s0,48(sp)
 c1c:	f426                	sd	s1,40(sp)
 c1e:	f04a                	sd	s2,32(sp)
 c20:	ec4e                	sd	s3,24(sp)
 c22:	e852                	sd	s4,16(sp)
 c24:	e456                	sd	s5,8(sp)
 c26:	e05a                	sd	s6,0(sp)
 c28:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c2a:	02051493          	sll	s1,a0,0x20
 c2e:	9081                	srl	s1,s1,0x20
 c30:	04bd                	add	s1,s1,15
 c32:	8091                	srl	s1,s1,0x4
 c34:	0014899b          	addw	s3,s1,1
 c38:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 c3a:	00000517          	auipc	a0,0x0
 c3e:	20653503          	ld	a0,518(a0) # e40 <freep>
 c42:	c515                	beqz	a0,c6e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c44:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c46:	4798                	lw	a4,8(a5)
 c48:	02977f63          	bgeu	a4,s1,c86 <malloc+0x70>
  if(nu < 4096)
 c4c:	8a4e                	mv	s4,s3
 c4e:	0009871b          	sext.w	a4,s3
 c52:	6685                	lui	a3,0x1
 c54:	00d77363          	bgeu	a4,a3,c5a <malloc+0x44>
 c58:	6a05                	lui	s4,0x1
 c5a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c5e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c62:	00000917          	auipc	s2,0x0
 c66:	1de90913          	add	s2,s2,478 # e40 <freep>
  if(p == (char*)-1)
 c6a:	5afd                	li	s5,-1
 c6c:	a895                	j	ce0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c6e:	00008797          	auipc	a5,0x8
 c72:	3ba78793          	add	a5,a5,954 # 9028 <base>
 c76:	00000717          	auipc	a4,0x0
 c7a:	1cf73523          	sd	a5,458(a4) # e40 <freep>
 c7e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c80:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c84:	b7e1                	j	c4c <malloc+0x36>
      if(p->s.size == nunits)
 c86:	02e48c63          	beq	s1,a4,cbe <malloc+0xa8>
        p->s.size -= nunits;
 c8a:	4137073b          	subw	a4,a4,s3
 c8e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c90:	02071693          	sll	a3,a4,0x20
 c94:	01c6d713          	srl	a4,a3,0x1c
 c98:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c9a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c9e:	00000717          	auipc	a4,0x0
 ca2:	1aa73123          	sd	a0,418(a4) # e40 <freep>
      return (void*)(p + 1);
 ca6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 caa:	70e2                	ld	ra,56(sp)
 cac:	7442                	ld	s0,48(sp)
 cae:	74a2                	ld	s1,40(sp)
 cb0:	7902                	ld	s2,32(sp)
 cb2:	69e2                	ld	s3,24(sp)
 cb4:	6a42                	ld	s4,16(sp)
 cb6:	6aa2                	ld	s5,8(sp)
 cb8:	6b02                	ld	s6,0(sp)
 cba:	6121                	add	sp,sp,64
 cbc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cbe:	6398                	ld	a4,0(a5)
 cc0:	e118                	sd	a4,0(a0)
 cc2:	bff1                	j	c9e <malloc+0x88>
  hp->s.size = nu;
 cc4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cc8:	0541                	add	a0,a0,16
 cca:	00000097          	auipc	ra,0x0
 cce:	eca080e7          	jalr	-310(ra) # b94 <free>
  return freep;
 cd2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cd6:	d971                	beqz	a0,caa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cda:	4798                	lw	a4,8(a5)
 cdc:	fa9775e3          	bgeu	a4,s1,c86 <malloc+0x70>
    if(p == freep)
 ce0:	00093703          	ld	a4,0(s2)
 ce4:	853e                	mv	a0,a5
 ce6:	fef719e3          	bne	a4,a5,cd8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 cea:	8552                	mv	a0,s4
 cec:	00000097          	auipc	ra,0x0
 cf0:	a90080e7          	jalr	-1392(ra) # 77c <sbrk>
  if(p == (char*)-1)
 cf4:	fd5518e3          	bne	a0,s5,cc4 <malloc+0xae>
        return 0;
 cf8:	4501                	li	a0,0
 cfa:	bf45                	j	caa <malloc+0x94>
