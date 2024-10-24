
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
   a:	6ea78793          	add	a5,a5,1770 # 16f0 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	ecf73923          	sd	a5,-302(a4) # ee0 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	6cf72c23          	sw	a5,1752(a4) # 36f0 <all_thread+0x2000>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	add	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1101                	add	sp,sp,-32
  28:	ec06                	sd	ra,24(sp)
  2a:	e822                	sd	s0,16(sp)
  2c:	e426                	sd	s1,8(sp)
  2e:	e04a                	sd	s2,0(sp)
  30:	1000                	add	s0,sp,32

  /* CMPT 332 GROUP 01, FALL 2024 */
  /* initializing the threads first */
  struct thread *t = (struct thread*)malloc(sizeof(struct thread));
  32:	6489                	lui	s1,0x2
  34:	06848513          	add	a0,s1,104 # 2068 <all_thread+0x978>
  38:	00001097          	auipc	ra,0x1
  3c:	c7e080e7          	jalr	-898(ra) # cb6 <malloc>
  40:	892a                	mv	s2,a0
  struct thread *next_thread = (struct thread*)malloc(sizeof(struct thread));
  42:	06848513          	add	a0,s1,104
  46:	00001097          	auipc	ra,0x1
  4a:	c70080e7          	jalr	-912(ra) # cb6 <malloc>
  4e:	85aa                	mv	a1,a0
  current_stack = (uint64_t)t->stack; 
  next_stack = (uint64_t)next_thread->stack;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  50:	00001517          	auipc	a0,0x1
  54:	e9053503          	ld	a0,-368(a0) # ee0 <current_thread>
  58:	06848793          	add	a5,s1,104
  5c:	97aa                	add	a5,a5,a0
  5e:	4711                	li	a4,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  60:	0000a897          	auipc	a7,0xa
  64:	83088893          	add	a7,a7,-2000 # 9890 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  68:	6609                	lui	a2,0x2
  6a:	4809                	li	a6,2
      next_thread = t;
      break;
    }
    t = t + 1;
  6c:	06860313          	add	t1,a2,104 # 2068 <all_thread+0x978>
  70:	a809                	j	82 <thread_schedule+0x5c>
    if(t->state == RUNNABLE) {
  72:	00c786b3          	add	a3,a5,a2
  76:	4294                	lw	a3,0(a3)
  78:	03068963          	beq	a3,a6,aa <thread_schedule+0x84>
    t = t + 1;
  7c:	979a                	add	a5,a5,t1
  for(int i = 0; i < MAX_THREAD; i++){
  7e:	377d                	addw	a4,a4,-1
  80:	cb01                	beqz	a4,90 <thread_schedule+0x6a>
    if(t >= all_thread + MAX_THREAD)
  82:	ff17e8e3          	bltu	a5,a7,72 <thread_schedule+0x4c>
      t = all_thread;
  86:	00001797          	auipc	a5,0x1
  8a:	66a78793          	add	a5,a5,1642 # 16f0 <all_thread>
  8e:	b7d5                	j	72 <thread_schedule+0x4c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  90:	00001517          	auipc	a0,0x1
  94:	d1050513          	add	a0,a0,-752 # da0 <malloc+0xea>
  98:	00001097          	auipc	ra,0x1
  9c:	b66080e7          	jalr	-1178(ra) # bfe <printf>
    exit(-1);
  a0:	557d                	li	a0,-1
  a2:	00000097          	auipc	ra,0x0
  a6:	6f2080e7          	jalr	1778(ra) # 794 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  aa:	00f50f63          	beq	a0,a5,c8 <thread_schedule+0xa2>
    next_thread->state = RUNNING;
  ae:	6709                	lui	a4,0x2
  b0:	973e                	add	a4,a4,a5
  b2:	4685                	li	a3,1
  b4:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  b6:	00001717          	auipc	a4,0x1
  ba:	e2f73523          	sd	a5,-470(a4) # ee0 <current_thread>

    /* CMPT 332 GROUP 01, FALL 2024 */
    thread_switch(current_stack, next_stack);
  be:	854a                	mv	a0,s2
  c0:	00000097          	auipc	ra,0x0
  c4:	414080e7          	jalr	1044(ra) # 4d4 <thread_switch>
  } else
    next_thread = 0;
}
  c8:	60e2                	ld	ra,24(sp)
  ca:	6442                	ld	s0,16(sp)
  cc:	64a2                	ld	s1,8(sp)
  ce:	6902                	ld	s2,0(sp)
  d0:	6105                	add	sp,sp,32
  d2:	8082                	ret

00000000000000d4 <thread_create>:

void 
thread_create(void (*func)())
{
  d4:	1141                	add	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	add	s0,sp,16
  
  /* CMPT 332 GROUP 01, FALL 2024 */
  struct thread *t = (struct thread *) malloc (sizeof(struct thread));
  dc:	6509                	lui	a0,0x2
  de:	06850513          	add	a0,a0,104 # 2068 <all_thread+0x978>
  e2:	00001097          	auipc	ra,0x1
  e6:	bd4080e7          	jalr	-1068(ra) # cb6 <malloc>

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  ea:	00001797          	auipc	a5,0x1
  ee:	60678793          	add	a5,a5,1542 # 16f0 <all_thread>
    if (t->state == FREE) break;
  f2:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  f4:	06868593          	add	a1,a3,104 # 2068 <all_thread+0x978>
  f8:	00009617          	auipc	a2,0x9
  fc:	79860613          	add	a2,a2,1944 # 9890 <base>
    if (t->state == FREE) break;
 100:	00d78733          	add	a4,a5,a3
 104:	4318                	lw	a4,0(a4)
 106:	c701                	beqz	a4,10e <thread_create+0x3a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 108:	97ae                	add	a5,a5,a1
 10a:	fec79be3          	bne	a5,a2,100 <thread_create+0x2c>
  }
  t->state = RUNNABLE;
 10e:	6709                	lui	a4,0x2
 110:	97ba                	add	a5,a5,a4
 112:	4709                	li	a4,2
 114:	c398                	sw	a4,0(a5)
  
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	add	sp,sp,16
 11c:	8082                	ret

000000000000011e <thread_yield>:

void 
thread_yield(void)
{
 11e:	1141                	add	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	add	s0,sp,16
  current_thread->state = RUNNABLE;
 126:	00001797          	auipc	a5,0x1
 12a:	dba7b783          	ld	a5,-582(a5) # ee0 <current_thread>
 12e:	6709                	lui	a4,0x2
 130:	97ba                	add	a5,a5,a4
 132:	4709                	li	a4,2
 134:	c398                	sw	a4,0(a5)
  thread_schedule();
 136:	00000097          	auipc	ra,0x0
 13a:	ef0080e7          	jalr	-272(ra) # 26 <thread_schedule>
}
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	add	sp,sp,16
 144:	8082                	ret

0000000000000146 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 146:	7179                	add	sp,sp,-48
 148:	f406                	sd	ra,40(sp)
 14a:	f022                	sd	s0,32(sp)
 14c:	ec26                	sd	s1,24(sp)
 14e:	e84a                	sd	s2,16(sp)
 150:	e44e                	sd	s3,8(sp)
 152:	e052                	sd	s4,0(sp)
 154:	1800                	add	s0,sp,48
  int i;
  printf("thread_a started\n");
 156:	00001517          	auipc	a0,0x1
 15a:	c7250513          	add	a0,a0,-910 # dc8 <malloc+0x112>
 15e:	00001097          	auipc	ra,0x1
 162:	aa0080e7          	jalr	-1376(ra) # bfe <printf>
  a_started = 1;
 166:	4785                	li	a5,1
 168:	00001717          	auipc	a4,0x1
 16c:	d6f72623          	sw	a5,-660(a4) # ed4 <a_started>
  while(b_started == 0 || c_started == 0)
 170:	00001497          	auipc	s1,0x1
 174:	d6048493          	add	s1,s1,-672 # ed0 <b_started>
 178:	00001917          	auipc	s2,0x1
 17c:	d5490913          	add	s2,s2,-684 # ecc <c_started>
 180:	a029                	j	18a <thread_a+0x44>
    thread_yield();
 182:	00000097          	auipc	ra,0x0
 186:	f9c080e7          	jalr	-100(ra) # 11e <thread_yield>
  while(b_started == 0 || c_started == 0)
 18a:	409c                	lw	a5,0(s1)
 18c:	2781                	sext.w	a5,a5
 18e:	dbf5                	beqz	a5,182 <thread_a+0x3c>
 190:	00092783          	lw	a5,0(s2)
 194:	2781                	sext.w	a5,a5
 196:	d7f5                	beqz	a5,182 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 198:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 19a:	00001a17          	auipc	s4,0x1
 19e:	c46a0a13          	add	s4,s4,-954 # de0 <malloc+0x12a>
    a_n += 1;
 1a2:	00001917          	auipc	s2,0x1
 1a6:	d2690913          	add	s2,s2,-730 # ec8 <a_n>
  for (i = 0; i < 100; i++) {
 1aa:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 1ae:	85a6                	mv	a1,s1
 1b0:	8552                	mv	a0,s4
 1b2:	00001097          	auipc	ra,0x1
 1b6:	a4c080e7          	jalr	-1460(ra) # bfe <printf>
    a_n += 1;
 1ba:	00092783          	lw	a5,0(s2)
 1be:	2785                	addw	a5,a5,1
 1c0:	00f92023          	sw	a5,0(s2)
    thread_yield();
 1c4:	00000097          	auipc	ra,0x0
 1c8:	f5a080e7          	jalr	-166(ra) # 11e <thread_yield>
  for (i = 0; i < 100; i++) {
 1cc:	2485                	addw	s1,s1,1
 1ce:	ff3490e3          	bne	s1,s3,1ae <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1d2:	00001597          	auipc	a1,0x1
 1d6:	cf65a583          	lw	a1,-778(a1) # ec8 <a_n>
 1da:	00001517          	auipc	a0,0x1
 1de:	c1650513          	add	a0,a0,-1002 # df0 <malloc+0x13a>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	a1c080e7          	jalr	-1508(ra) # bfe <printf>

  current_thread->state = FREE;
 1ea:	00001797          	auipc	a5,0x1
 1ee:	cf67b783          	ld	a5,-778(a5) # ee0 <current_thread>
 1f2:	6709                	lui	a4,0x2
 1f4:	97ba                	add	a5,a5,a4
 1f6:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1fa:	00000097          	auipc	ra,0x0
 1fe:	e2c080e7          	jalr	-468(ra) # 26 <thread_schedule>
}
 202:	70a2                	ld	ra,40(sp)
 204:	7402                	ld	s0,32(sp)
 206:	64e2                	ld	s1,24(sp)
 208:	6942                	ld	s2,16(sp)
 20a:	69a2                	ld	s3,8(sp)
 20c:	6a02                	ld	s4,0(sp)
 20e:	6145                	add	sp,sp,48
 210:	8082                	ret

0000000000000212 <thread_b>:

void 
thread_b(void)
{
 212:	7179                	add	sp,sp,-48
 214:	f406                	sd	ra,40(sp)
 216:	f022                	sd	s0,32(sp)
 218:	ec26                	sd	s1,24(sp)
 21a:	e84a                	sd	s2,16(sp)
 21c:	e44e                	sd	s3,8(sp)
 21e:	e052                	sd	s4,0(sp)
 220:	1800                	add	s0,sp,48
  int i;
  printf("thread_b started\n");
 222:	00001517          	auipc	a0,0x1
 226:	bee50513          	add	a0,a0,-1042 # e10 <malloc+0x15a>
 22a:	00001097          	auipc	ra,0x1
 22e:	9d4080e7          	jalr	-1580(ra) # bfe <printf>
  b_started = 1;
 232:	4785                	li	a5,1
 234:	00001717          	auipc	a4,0x1
 238:	c8f72e23          	sw	a5,-868(a4) # ed0 <b_started>
  while(a_started == 0 || c_started == 0)
 23c:	00001497          	auipc	s1,0x1
 240:	c9848493          	add	s1,s1,-872 # ed4 <a_started>
 244:	00001917          	auipc	s2,0x1
 248:	c8890913          	add	s2,s2,-888 # ecc <c_started>
 24c:	a029                	j	256 <thread_b+0x44>
    thread_yield();
 24e:	00000097          	auipc	ra,0x0
 252:	ed0080e7          	jalr	-304(ra) # 11e <thread_yield>
  while(a_started == 0 || c_started == 0)
 256:	409c                	lw	a5,0(s1)
 258:	2781                	sext.w	a5,a5
 25a:	dbf5                	beqz	a5,24e <thread_b+0x3c>
 25c:	00092783          	lw	a5,0(s2)
 260:	2781                	sext.w	a5,a5
 262:	d7f5                	beqz	a5,24e <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 264:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 266:	00001a17          	auipc	s4,0x1
 26a:	bc2a0a13          	add	s4,s4,-1086 # e28 <malloc+0x172>
    b_n += 1;
 26e:	00001917          	auipc	s2,0x1
 272:	c5690913          	add	s2,s2,-938 # ec4 <b_n>
  for (i = 0; i < 100; i++) {
 276:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 27a:	85a6                	mv	a1,s1
 27c:	8552                	mv	a0,s4
 27e:	00001097          	auipc	ra,0x1
 282:	980080e7          	jalr	-1664(ra) # bfe <printf>
    b_n += 1;
 286:	00092783          	lw	a5,0(s2)
 28a:	2785                	addw	a5,a5,1
 28c:	00f92023          	sw	a5,0(s2)
    thread_yield();
 290:	00000097          	auipc	ra,0x0
 294:	e8e080e7          	jalr	-370(ra) # 11e <thread_yield>
  for (i = 0; i < 100; i++) {
 298:	2485                	addw	s1,s1,1
 29a:	ff3490e3          	bne	s1,s3,27a <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 29e:	00001597          	auipc	a1,0x1
 2a2:	c265a583          	lw	a1,-986(a1) # ec4 <b_n>
 2a6:	00001517          	auipc	a0,0x1
 2aa:	b9250513          	add	a0,a0,-1134 # e38 <malloc+0x182>
 2ae:	00001097          	auipc	ra,0x1
 2b2:	950080e7          	jalr	-1712(ra) # bfe <printf>

  current_thread->state = FREE;
 2b6:	00001797          	auipc	a5,0x1
 2ba:	c2a7b783          	ld	a5,-982(a5) # ee0 <current_thread>
 2be:	6709                	lui	a4,0x2
 2c0:	97ba                	add	a5,a5,a4
 2c2:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2c6:	00000097          	auipc	ra,0x0
 2ca:	d60080e7          	jalr	-672(ra) # 26 <thread_schedule>
}
 2ce:	70a2                	ld	ra,40(sp)
 2d0:	7402                	ld	s0,32(sp)
 2d2:	64e2                	ld	s1,24(sp)
 2d4:	6942                	ld	s2,16(sp)
 2d6:	69a2                	ld	s3,8(sp)
 2d8:	6a02                	ld	s4,0(sp)
 2da:	6145                	add	sp,sp,48
 2dc:	8082                	ret

00000000000002de <thread_c>:

void 
thread_c(void)
{
 2de:	7179                	add	sp,sp,-48
 2e0:	f406                	sd	ra,40(sp)
 2e2:	f022                	sd	s0,32(sp)
 2e4:	ec26                	sd	s1,24(sp)
 2e6:	e84a                	sd	s2,16(sp)
 2e8:	e44e                	sd	s3,8(sp)
 2ea:	e052                	sd	s4,0(sp)
 2ec:	1800                	add	s0,sp,48
  int i;
  printf("thread_c started\n");
 2ee:	00001517          	auipc	a0,0x1
 2f2:	b6a50513          	add	a0,a0,-1174 # e58 <malloc+0x1a2>
 2f6:	00001097          	auipc	ra,0x1
 2fa:	908080e7          	jalr	-1784(ra) # bfe <printf>
  c_started = 1;
 2fe:	4785                	li	a5,1
 300:	00001717          	auipc	a4,0x1
 304:	bcf72623          	sw	a5,-1076(a4) # ecc <c_started>
  while(a_started == 0 || b_started == 0)
 308:	00001497          	auipc	s1,0x1
 30c:	bcc48493          	add	s1,s1,-1076 # ed4 <a_started>
 310:	00001917          	auipc	s2,0x1
 314:	bc090913          	add	s2,s2,-1088 # ed0 <b_started>
 318:	a029                	j	322 <thread_c+0x44>
    thread_yield();
 31a:	00000097          	auipc	ra,0x0
 31e:	e04080e7          	jalr	-508(ra) # 11e <thread_yield>
  while(a_started == 0 || b_started == 0)
 322:	409c                	lw	a5,0(s1)
 324:	2781                	sext.w	a5,a5
 326:	dbf5                	beqz	a5,31a <thread_c+0x3c>
 328:	00092783          	lw	a5,0(s2)
 32c:	2781                	sext.w	a5,a5
 32e:	d7f5                	beqz	a5,31a <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 330:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 332:	00001a17          	auipc	s4,0x1
 336:	b3ea0a13          	add	s4,s4,-1218 # e70 <malloc+0x1ba>
    c_n += 1;
 33a:	00001917          	auipc	s2,0x1
 33e:	b8690913          	add	s2,s2,-1146 # ec0 <c_n>
  for (i = 0; i < 100; i++) {
 342:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 346:	85a6                	mv	a1,s1
 348:	8552                	mv	a0,s4
 34a:	00001097          	auipc	ra,0x1
 34e:	8b4080e7          	jalr	-1868(ra) # bfe <printf>
    c_n += 1;
 352:	00092783          	lw	a5,0(s2)
 356:	2785                	addw	a5,a5,1
 358:	00f92023          	sw	a5,0(s2)
    thread_yield();
 35c:	00000097          	auipc	ra,0x0
 360:	dc2080e7          	jalr	-574(ra) # 11e <thread_yield>
  for (i = 0; i < 100; i++) {
 364:	2485                	addw	s1,s1,1
 366:	ff3490e3          	bne	s1,s3,346 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 36a:	00001597          	auipc	a1,0x1
 36e:	b565a583          	lw	a1,-1194(a1) # ec0 <c_n>
 372:	00001517          	auipc	a0,0x1
 376:	b0e50513          	add	a0,a0,-1266 # e80 <malloc+0x1ca>
 37a:	00001097          	auipc	ra,0x1
 37e:	884080e7          	jalr	-1916(ra) # bfe <printf>

  current_thread->state = FREE;
 382:	00001797          	auipc	a5,0x1
 386:	b5e7b783          	ld	a5,-1186(a5) # ee0 <current_thread>
 38a:	6709                	lui	a4,0x2
 38c:	97ba                	add	a5,a5,a4
 38e:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 392:	00000097          	auipc	ra,0x0
 396:	c94080e7          	jalr	-876(ra) # 26 <thread_schedule>
}
 39a:	70a2                	ld	ra,40(sp)
 39c:	7402                	ld	s0,32(sp)
 39e:	64e2                	ld	s1,24(sp)
 3a0:	6942                	ld	s2,16(sp)
 3a2:	69a2                	ld	s3,8(sp)
 3a4:	6a02                	ld	s4,0(sp)
 3a6:	6145                	add	sp,sp,48
 3a8:	8082                	ret

00000000000003aa <mtx_create>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_create(int locked){
   int locked_id;
   if (m_count > MUTEX_SIZE){
 3aa:	00001717          	auipc	a4,0x1
 3ae:	b2e72703          	lw	a4,-1234(a4) # ed8 <m_count>
 3b2:	10000793          	li	a5,256
 3b6:	04e7c663          	blt	a5,a4,402 <mtx_create+0x58>
int mtx_create(int locked){
 3ba:	1101                	add	sp,sp,-32
 3bc:	ec06                	sd	ra,24(sp)
 3be:	e822                	sd	s0,16(sp)
 3c0:	e426                	sd	s1,8(sp)
 3c2:	1000                	add	s0,sp,32
 3c4:	84aa                	mv	s1,a0
	return -1;
   }
   mutex_t *m = (mutex_t *)malloc(sizeof(mutex_t));
 3c6:	4511                	li	a0,4
 3c8:	00001097          	auipc	ra,0x1
 3cc:	8ee080e7          	jalr	-1810(ra) # cb6 <malloc>
 3d0:	87aa                	mv	a5,a0
   
   if (m == NULL){
 3d2:	c915                	beqz	a0,406 <mtx_create+0x5c>
	return -1;
   }
   m->locked = locked;
 3d4:	c104                	sw	s1,0(a0)
   all_m[m_count++] = m;
 3d6:	00001617          	auipc	a2,0x1
 3da:	b0260613          	add	a2,a2,-1278 # ed8 <m_count>
 3de:	4218                	lw	a4,0(a2)
 3e0:	0017051b          	addw	a0,a4,1
 3e4:	00371593          	sll	a1,a4,0x3
 3e8:	00001697          	auipc	a3,0x1
 3ec:	b0868693          	add	a3,a3,-1272 # ef0 <all_m>
 3f0:	96ae                	add	a3,a3,a1
 3f2:	e29c                	sd	a5,0(a3)

   locked_id = m_count++;
 3f4:	2709                	addw	a4,a4,2
 3f6:	c218                	sw	a4,0(a2)
   return locked_id;
}
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	64a2                	ld	s1,8(sp)
 3fe:	6105                	add	sp,sp,32
 400:	8082                	ret
	return -1;
 402:	557d                	li	a0,-1
}
 404:	8082                	ret
	return -1;
 406:	557d                	li	a0,-1
 408:	bfc5                	j	3f8 <mtx_create+0x4e>

000000000000040a <mtx_lock>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_lock(int lock_id){
 40a:	1141                	add	sp,sp,-16
 40c:	e422                	sd	s0,8(sp)
 40e:	0800                	add	s0,sp,16
   mutex_t* m = all_m[lock_id];
 410:	050e                	sll	a0,a0,0x3
 412:	00001797          	auipc	a5,0x1
 416:	ade78793          	add	a5,a5,-1314 # ef0 <all_m>
 41a:	97aa                	add	a5,a5,a0
   while (m->locked){
 41c:	639c                	ld	a5,0(a5)
 41e:	439c                	lw	a5,0(a5)
 420:	e381                	bnez	a5,420 <mtx_lock+0x16>
	/* wait indefinitely */
   }
   m->locked = 0;
   return 0;
}
 422:	4501                	li	a0,0
 424:	6422                	ld	s0,8(sp)
 426:	0141                	add	sp,sp,16
 428:	8082                	ret

000000000000042a <mtx_unlock>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_unlock(int lock_id){
 42a:	1141                	add	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	add	s0,sp,16
   mutex_t* m = all_m[lock_id];
 430:	050e                	sll	a0,a0,0x3
 432:	00001797          	auipc	a5,0x1
 436:	abe78793          	add	a5,a5,-1346 # ef0 <all_m>
 43a:	97aa                	add	a5,a5,a0
 43c:	639c                	ld	a5,0(a5)
   while (!m->locked){return -1;}
 43e:	4398                	lw	a4,0(a5)
 440:	c719                	beqz	a4,44e <mtx_unlock+0x24>
   m->locked = 1;
 442:	4705                	li	a4,1
 444:	c398                	sw	a4,0(a5)
   return 0;
 446:	4501                	li	a0,0
}
 448:	6422                	ld	s0,8(sp)
 44a:	0141                	add	sp,sp,16
 44c:	8082                	ret
   while (!m->locked){return -1;}
 44e:	557d                	li	a0,-1
 450:	bfe5                	j	448 <mtx_unlock+0x1e>

0000000000000452 <main>:

int main(int argc, char *argv[]) 
{
 452:	1141                	add	sp,sp,-16
 454:	e406                	sd	ra,8(sp)
 456:	e022                	sd	s0,0(sp)
 458:	0800                	add	s0,sp,16
  a_started = b_started = c_started = 0;
 45a:	00001797          	auipc	a5,0x1
 45e:	a607a923          	sw	zero,-1422(a5) # ecc <c_started>
 462:	00001797          	auipc	a5,0x1
 466:	a607a723          	sw	zero,-1426(a5) # ed0 <b_started>
 46a:	00001797          	auipc	a5,0x1
 46e:	a607a523          	sw	zero,-1430(a5) # ed4 <a_started>
  a_n = b_n = c_n = 0;
 472:	00001797          	auipc	a5,0x1
 476:	a407a723          	sw	zero,-1458(a5) # ec0 <c_n>
 47a:	00001797          	auipc	a5,0x1
 47e:	a407a523          	sw	zero,-1462(a5) # ec4 <b_n>
 482:	00001797          	auipc	a5,0x1
 486:	a407a323          	sw	zero,-1466(a5) # ec8 <a_n>
  thread_init();
 48a:	00000097          	auipc	ra,0x0
 48e:	b76080e7          	jalr	-1162(ra) # 0 <thread_init>
  thread_create(thread_a);
 492:	00000517          	auipc	a0,0x0
 496:	cb450513          	add	a0,a0,-844 # 146 <thread_a>
 49a:	00000097          	auipc	ra,0x0
 49e:	c3a080e7          	jalr	-966(ra) # d4 <thread_create>
  thread_create(thread_b);
 4a2:	00000517          	auipc	a0,0x0
 4a6:	d7050513          	add	a0,a0,-656 # 212 <thread_b>
 4aa:	00000097          	auipc	ra,0x0
 4ae:	c2a080e7          	jalr	-982(ra) # d4 <thread_create>
  thread_create(thread_c);
 4b2:	00000517          	auipc	a0,0x0
 4b6:	e2c50513          	add	a0,a0,-468 # 2de <thread_c>
 4ba:	00000097          	auipc	ra,0x0
 4be:	c1a080e7          	jalr	-998(ra) # d4 <thread_create>
  thread_schedule();
 4c2:	00000097          	auipc	ra,0x0
 4c6:	b64080e7          	jalr	-1180(ra) # 26 <thread_schedule>
  exit(0);
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	2c8080e7          	jalr	712(ra) # 794 <exit>

00000000000004d4 <thread_switch>:

	.globl thread_switch
thread_switch:
	/* First parameter in a0, second is in a1, stack pointer reg is sp  */
	/* Saving all of the saved registers from the current_thread*/
	addi sp, sp, -48
 4d4:	7179                	add	sp,sp,-48
	sw s0, 0(sp)	
 4d6:	c022                	sw	s0,0(sp)
	sw s1, 4(sp)
 4d8:	c226                	sw	s1,4(sp)
	sw s2, 8(sp)
 4da:	c44a                	sw	s2,8(sp)
	sw s3, 12(sp)
 4dc:	c64e                	sw	s3,12(sp)
	sw s4, 16(sp)
 4de:	c852                	sw	s4,16(sp)
	sw s5, 20(sp)
 4e0:	ca56                	sw	s5,20(sp)
	sw s6, 24(sp)
 4e2:	cc5a                	sw	s6,24(sp)
	sw s7, 28(sp)
 4e4:	ce5e                	sw	s7,28(sp)
	sw s8, 32(sp)
 4e6:	d062                	sw	s8,32(sp)
	sw s9, 36(sp)
 4e8:	d266                	sw	s9,36(sp)
	sw s10, 40(sp)
 4ea:	d46a                	sw	s10,40(sp)
	sw s11, 44(sp)
 4ec:	d66e                	sw	s11,44(sp)
	sw sp, 48(sp) 
 4ee:	d80a                	sw	sp,48(sp)

	lw sp, 48(a1)
 4f0:	0305a103          	lw	sp,48(a1)
	lw s0, 0(sp)
 4f4:	4402                	lw	s0,0(sp)
	lw s1, 4(sp)
 4f6:	4492                	lw	s1,4(sp)
	lw s2, 8(sp)
 4f8:	4922                	lw	s2,8(sp)
	lw s3, 12(sp)
 4fa:	49b2                	lw	s3,12(sp)
	lw s4, 16(sp)
 4fc:	4a42                	lw	s4,16(sp)
	lw s5, 20(sp)
 4fe:	4ad2                	lw	s5,20(sp)
	lw s6, 24(sp)
 500:	4b62                	lw	s6,24(sp)
	lw s7, 28(sp)
 502:	4bf2                	lw	s7,28(sp)
	lw s8, 32(sp)
 504:	5c02                	lw	s8,32(sp)
	lw s9, 36(sp)
 506:	5c92                	lw	s9,36(sp)
	lw s10, 40(sp)
 508:	5d22                	lw	s10,40(sp)
	lw s11, 44(sp)
 50a:	5db2                	lw	s11,44(sp)
	
	ret    /* return to ra */
 50c:	8082                	ret

000000000000050e <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 50e:	1141                	add	sp,sp,-16
 510:	e406                	sd	ra,8(sp)
 512:	e022                	sd	s0,0(sp)
 514:	0800                	add	s0,sp,16
  extern int main();
  main();
 516:	00000097          	auipc	ra,0x0
 51a:	f3c080e7          	jalr	-196(ra) # 452 <main>
  exit(0);
 51e:	4501                	li	a0,0
 520:	00000097          	auipc	ra,0x0
 524:	274080e7          	jalr	628(ra) # 794 <exit>

0000000000000528 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 528:	1141                	add	sp,sp,-16
 52a:	e422                	sd	s0,8(sp)
 52c:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 52e:	87aa                	mv	a5,a0
 530:	0585                	add	a1,a1,1
 532:	0785                	add	a5,a5,1
 534:	fff5c703          	lbu	a4,-1(a1)
 538:	fee78fa3          	sb	a4,-1(a5)
 53c:	fb75                	bnez	a4,530 <strcpy+0x8>
    ;
  return os;
}
 53e:	6422                	ld	s0,8(sp)
 540:	0141                	add	sp,sp,16
 542:	8082                	ret

0000000000000544 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 544:	1141                	add	sp,sp,-16
 546:	e422                	sd	s0,8(sp)
 548:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 54a:	00054783          	lbu	a5,0(a0)
 54e:	cb91                	beqz	a5,562 <strcmp+0x1e>
 550:	0005c703          	lbu	a4,0(a1)
 554:	00f71763          	bne	a4,a5,562 <strcmp+0x1e>
    p++, q++;
 558:	0505                	add	a0,a0,1
 55a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 55c:	00054783          	lbu	a5,0(a0)
 560:	fbe5                	bnez	a5,550 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 562:	0005c503          	lbu	a0,0(a1)
}
 566:	40a7853b          	subw	a0,a5,a0
 56a:	6422                	ld	s0,8(sp)
 56c:	0141                	add	sp,sp,16
 56e:	8082                	ret

0000000000000570 <strlen>:

uint
strlen(const char *s)
{
 570:	1141                	add	sp,sp,-16
 572:	e422                	sd	s0,8(sp)
 574:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 576:	00054783          	lbu	a5,0(a0)
 57a:	cf91                	beqz	a5,596 <strlen+0x26>
 57c:	0505                	add	a0,a0,1
 57e:	87aa                	mv	a5,a0
 580:	86be                	mv	a3,a5
 582:	0785                	add	a5,a5,1
 584:	fff7c703          	lbu	a4,-1(a5)
 588:	ff65                	bnez	a4,580 <strlen+0x10>
 58a:	40a6853b          	subw	a0,a3,a0
 58e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 590:	6422                	ld	s0,8(sp)
 592:	0141                	add	sp,sp,16
 594:	8082                	ret
  for(n = 0; s[n]; n++)
 596:	4501                	li	a0,0
 598:	bfe5                	j	590 <strlen+0x20>

000000000000059a <memset>:

void*
memset(void *dst, int c, uint n)
{
 59a:	1141                	add	sp,sp,-16
 59c:	e422                	sd	s0,8(sp)
 59e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5a0:	ca19                	beqz	a2,5b6 <memset+0x1c>
 5a2:	87aa                	mv	a5,a0
 5a4:	1602                	sll	a2,a2,0x20
 5a6:	9201                	srl	a2,a2,0x20
 5a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5b0:	0785                	add	a5,a5,1
 5b2:	fee79de3          	bne	a5,a4,5ac <memset+0x12>
  }
  return dst;
}
 5b6:	6422                	ld	s0,8(sp)
 5b8:	0141                	add	sp,sp,16
 5ba:	8082                	ret

00000000000005bc <strchr>:

char*
strchr(const char *s, char c)
{
 5bc:	1141                	add	sp,sp,-16
 5be:	e422                	sd	s0,8(sp)
 5c0:	0800                	add	s0,sp,16
  for(; *s; s++)
 5c2:	00054783          	lbu	a5,0(a0)
 5c6:	cb99                	beqz	a5,5dc <strchr+0x20>
    if(*s == c)
 5c8:	00f58763          	beq	a1,a5,5d6 <strchr+0x1a>
  for(; *s; s++)
 5cc:	0505                	add	a0,a0,1
 5ce:	00054783          	lbu	a5,0(a0)
 5d2:	fbfd                	bnez	a5,5c8 <strchr+0xc>
      return (char*)s;
  return 0;
 5d4:	4501                	li	a0,0
}
 5d6:	6422                	ld	s0,8(sp)
 5d8:	0141                	add	sp,sp,16
 5da:	8082                	ret
  return 0;
 5dc:	4501                	li	a0,0
 5de:	bfe5                	j	5d6 <strchr+0x1a>

00000000000005e0 <gets>:

char*
gets(char *buf, int max)
{
 5e0:	711d                	add	sp,sp,-96
 5e2:	ec86                	sd	ra,88(sp)
 5e4:	e8a2                	sd	s0,80(sp)
 5e6:	e4a6                	sd	s1,72(sp)
 5e8:	e0ca                	sd	s2,64(sp)
 5ea:	fc4e                	sd	s3,56(sp)
 5ec:	f852                	sd	s4,48(sp)
 5ee:	f456                	sd	s5,40(sp)
 5f0:	f05a                	sd	s6,32(sp)
 5f2:	ec5e                	sd	s7,24(sp)
 5f4:	1080                	add	s0,sp,96
 5f6:	8baa                	mv	s7,a0
 5f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5fa:	892a                	mv	s2,a0
 5fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5fe:	4aa9                	li	s5,10
 600:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 602:	89a6                	mv	s3,s1
 604:	2485                	addw	s1,s1,1
 606:	0344d863          	bge	s1,s4,636 <gets+0x56>
    cc = read(0, &c, 1);
 60a:	4605                	li	a2,1
 60c:	faf40593          	add	a1,s0,-81
 610:	4501                	li	a0,0
 612:	00000097          	auipc	ra,0x0
 616:	19a080e7          	jalr	410(ra) # 7ac <read>
    if(cc < 1)
 61a:	00a05e63          	blez	a0,636 <gets+0x56>
    buf[i++] = c;
 61e:	faf44783          	lbu	a5,-81(s0)
 622:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 626:	01578763          	beq	a5,s5,634 <gets+0x54>
 62a:	0905                	add	s2,s2,1
 62c:	fd679be3          	bne	a5,s6,602 <gets+0x22>
  for(i=0; i+1 < max; ){
 630:	89a6                	mv	s3,s1
 632:	a011                	j	636 <gets+0x56>
 634:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 636:	99de                	add	s3,s3,s7
 638:	00098023          	sb	zero,0(s3)
  return buf;
}
 63c:	855e                	mv	a0,s7
 63e:	60e6                	ld	ra,88(sp)
 640:	6446                	ld	s0,80(sp)
 642:	64a6                	ld	s1,72(sp)
 644:	6906                	ld	s2,64(sp)
 646:	79e2                	ld	s3,56(sp)
 648:	7a42                	ld	s4,48(sp)
 64a:	7aa2                	ld	s5,40(sp)
 64c:	7b02                	ld	s6,32(sp)
 64e:	6be2                	ld	s7,24(sp)
 650:	6125                	add	sp,sp,96
 652:	8082                	ret

0000000000000654 <stat>:

int
stat(const char *n, struct stat *st)
{
 654:	1101                	add	sp,sp,-32
 656:	ec06                	sd	ra,24(sp)
 658:	e822                	sd	s0,16(sp)
 65a:	e426                	sd	s1,8(sp)
 65c:	e04a                	sd	s2,0(sp)
 65e:	1000                	add	s0,sp,32
 660:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 662:	4581                	li	a1,0
 664:	00000097          	auipc	ra,0x0
 668:	170080e7          	jalr	368(ra) # 7d4 <open>
  if(fd < 0)
 66c:	02054563          	bltz	a0,696 <stat+0x42>
 670:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 672:	85ca                	mv	a1,s2
 674:	00000097          	auipc	ra,0x0
 678:	178080e7          	jalr	376(ra) # 7ec <fstat>
 67c:	892a                	mv	s2,a0
  close(fd);
 67e:	8526                	mv	a0,s1
 680:	00000097          	auipc	ra,0x0
 684:	13c080e7          	jalr	316(ra) # 7bc <close>
  return r;
}
 688:	854a                	mv	a0,s2
 68a:	60e2                	ld	ra,24(sp)
 68c:	6442                	ld	s0,16(sp)
 68e:	64a2                	ld	s1,8(sp)
 690:	6902                	ld	s2,0(sp)
 692:	6105                	add	sp,sp,32
 694:	8082                	ret
    return -1;
 696:	597d                	li	s2,-1
 698:	bfc5                	j	688 <stat+0x34>

000000000000069a <atoi>:

int
atoi(const char *s)
{
 69a:	1141                	add	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6a0:	00054683          	lbu	a3,0(a0)
 6a4:	fd06879b          	addw	a5,a3,-48
 6a8:	0ff7f793          	zext.b	a5,a5
 6ac:	4625                	li	a2,9
 6ae:	02f66863          	bltu	a2,a5,6de <atoi+0x44>
 6b2:	872a                	mv	a4,a0
  n = 0;
 6b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6b6:	0705                	add	a4,a4,1
 6b8:	0025179b          	sllw	a5,a0,0x2
 6bc:	9fa9                	addw	a5,a5,a0
 6be:	0017979b          	sllw	a5,a5,0x1
 6c2:	9fb5                	addw	a5,a5,a3
 6c4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6c8:	00074683          	lbu	a3,0(a4)
 6cc:	fd06879b          	addw	a5,a3,-48
 6d0:	0ff7f793          	zext.b	a5,a5
 6d4:	fef671e3          	bgeu	a2,a5,6b6 <atoi+0x1c>
  return n;
}
 6d8:	6422                	ld	s0,8(sp)
 6da:	0141                	add	sp,sp,16
 6dc:	8082                	ret
  n = 0;
 6de:	4501                	li	a0,0
 6e0:	bfe5                	j	6d8 <atoi+0x3e>

00000000000006e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6e2:	1141                	add	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6e8:	02b57463          	bgeu	a0,a1,710 <memmove+0x2e>
    while(n-- > 0)
 6ec:	00c05f63          	blez	a2,70a <memmove+0x28>
 6f0:	1602                	sll	a2,a2,0x20
 6f2:	9201                	srl	a2,a2,0x20
 6f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 6fa:	0585                	add	a1,a1,1
 6fc:	0705                	add	a4,a4,1
 6fe:	fff5c683          	lbu	a3,-1(a1)
 702:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 706:	fee79ae3          	bne	a5,a4,6fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 70a:	6422                	ld	s0,8(sp)
 70c:	0141                	add	sp,sp,16
 70e:	8082                	ret
    dst += n;
 710:	00c50733          	add	a4,a0,a2
    src += n;
 714:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 716:	fec05ae3          	blez	a2,70a <memmove+0x28>
 71a:	fff6079b          	addw	a5,a2,-1
 71e:	1782                	sll	a5,a5,0x20
 720:	9381                	srl	a5,a5,0x20
 722:	fff7c793          	not	a5,a5
 726:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 728:	15fd                	add	a1,a1,-1
 72a:	177d                	add	a4,a4,-1
 72c:	0005c683          	lbu	a3,0(a1)
 730:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 734:	fee79ae3          	bne	a5,a4,728 <memmove+0x46>
 738:	bfc9                	j	70a <memmove+0x28>

000000000000073a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 73a:	1141                	add	sp,sp,-16
 73c:	e422                	sd	s0,8(sp)
 73e:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 740:	ca05                	beqz	a2,770 <memcmp+0x36>
 742:	fff6069b          	addw	a3,a2,-1
 746:	1682                	sll	a3,a3,0x20
 748:	9281                	srl	a3,a3,0x20
 74a:	0685                	add	a3,a3,1
 74c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 74e:	00054783          	lbu	a5,0(a0)
 752:	0005c703          	lbu	a4,0(a1)
 756:	00e79863          	bne	a5,a4,766 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 75a:	0505                	add	a0,a0,1
    p2++;
 75c:	0585                	add	a1,a1,1
  while (n-- > 0) {
 75e:	fed518e3          	bne	a0,a3,74e <memcmp+0x14>
  }
  return 0;
 762:	4501                	li	a0,0
 764:	a019                	j	76a <memcmp+0x30>
      return *p1 - *p2;
 766:	40e7853b          	subw	a0,a5,a4
}
 76a:	6422                	ld	s0,8(sp)
 76c:	0141                	add	sp,sp,16
 76e:	8082                	ret
  return 0;
 770:	4501                	li	a0,0
 772:	bfe5                	j	76a <memcmp+0x30>

0000000000000774 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 774:	1141                	add	sp,sp,-16
 776:	e406                	sd	ra,8(sp)
 778:	e022                	sd	s0,0(sp)
 77a:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 77c:	00000097          	auipc	ra,0x0
 780:	f66080e7          	jalr	-154(ra) # 6e2 <memmove>
}
 784:	60a2                	ld	ra,8(sp)
 786:	6402                	ld	s0,0(sp)
 788:	0141                	add	sp,sp,16
 78a:	8082                	ret

000000000000078c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 78c:	4885                	li	a7,1
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <exit>:
.global exit
exit:
 li a7, SYS_exit
 794:	4889                	li	a7,2
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <wait>:
.global wait
wait:
 li a7, SYS_wait
 79c:	488d                	li	a7,3
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7a4:	4891                	li	a7,4
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <read>:
.global read
read:
 li a7, SYS_read
 7ac:	4895                	li	a7,5
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <write>:
.global write
write:
 li a7, SYS_write
 7b4:	48c1                	li	a7,16
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <close>:
.global close
close:
 li a7, SYS_close
 7bc:	48d5                	li	a7,21
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7c4:	4899                	li	a7,6
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 7cc:	489d                	li	a7,7
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <open>:
.global open
open:
 li a7, SYS_open
 7d4:	48bd                	li	a7,15
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7dc:	48c5                	li	a7,17
 ecall
 7de:	00000073          	ecall
 ret
 7e2:	8082                	ret

00000000000007e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7e4:	48c9                	li	a7,18
 ecall
 7e6:	00000073          	ecall
 ret
 7ea:	8082                	ret

00000000000007ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7ec:	48a1                	li	a7,8
 ecall
 7ee:	00000073          	ecall
 ret
 7f2:	8082                	ret

00000000000007f4 <link>:
.global link
link:
 li a7, SYS_link
 7f4:	48cd                	li	a7,19
 ecall
 7f6:	00000073          	ecall
 ret
 7fa:	8082                	ret

00000000000007fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7fc:	48d1                	li	a7,20
 ecall
 7fe:	00000073          	ecall
 ret
 802:	8082                	ret

0000000000000804 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 804:	48a5                	li	a7,9
 ecall
 806:	00000073          	ecall
 ret
 80a:	8082                	ret

000000000000080c <dup>:
.global dup
dup:
 li a7, SYS_dup
 80c:	48a9                	li	a7,10
 ecall
 80e:	00000073          	ecall
 ret
 812:	8082                	ret

0000000000000814 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 814:	48ad                	li	a7,11
 ecall
 816:	00000073          	ecall
 ret
 81a:	8082                	ret

000000000000081c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 81c:	48b1                	li	a7,12
 ecall
 81e:	00000073          	ecall
 ret
 822:	8082                	ret

0000000000000824 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 824:	48b5                	li	a7,13
 ecall
 826:	00000073          	ecall
 ret
 82a:	8082                	ret

000000000000082c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 82c:	48b9                	li	a7,14
 ecall
 82e:	00000073          	ecall
 ret
 832:	8082                	ret

0000000000000834 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 834:	1101                	add	sp,sp,-32
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	add	s0,sp,32
 83c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 840:	4605                	li	a2,1
 842:	fef40593          	add	a1,s0,-17
 846:	00000097          	auipc	ra,0x0
 84a:	f6e080e7          	jalr	-146(ra) # 7b4 <write>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6105                	add	sp,sp,32
 854:	8082                	ret

0000000000000856 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 856:	7139                	add	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f426                	sd	s1,40(sp)
 85e:	f04a                	sd	s2,32(sp)
 860:	ec4e                	sd	s3,24(sp)
 862:	0080                	add	s0,sp,64
 864:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 866:	c299                	beqz	a3,86c <printint+0x16>
 868:	0805c963          	bltz	a1,8fa <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 86c:	2581                	sext.w	a1,a1
  neg = 0;
 86e:	4881                	li	a7,0
 870:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 874:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 876:	2601                	sext.w	a2,a2
 878:	00000517          	auipc	a0,0x0
 87c:	63050513          	add	a0,a0,1584 # ea8 <digits>
 880:	883a                	mv	a6,a4
 882:	2705                	addw	a4,a4,1
 884:	02c5f7bb          	remuw	a5,a1,a2
 888:	1782                	sll	a5,a5,0x20
 88a:	9381                	srl	a5,a5,0x20
 88c:	97aa                	add	a5,a5,a0
 88e:	0007c783          	lbu	a5,0(a5)
 892:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 896:	0005879b          	sext.w	a5,a1
 89a:	02c5d5bb          	divuw	a1,a1,a2
 89e:	0685                	add	a3,a3,1
 8a0:	fec7f0e3          	bgeu	a5,a2,880 <printint+0x2a>
  if(neg)
 8a4:	00088c63          	beqz	a7,8bc <printint+0x66>
    buf[i++] = '-';
 8a8:	fd070793          	add	a5,a4,-48
 8ac:	00878733          	add	a4,a5,s0
 8b0:	02d00793          	li	a5,45
 8b4:	fef70823          	sb	a5,-16(a4)
 8b8:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8bc:	02e05863          	blez	a4,8ec <printint+0x96>
 8c0:	fc040793          	add	a5,s0,-64
 8c4:	00e78933          	add	s2,a5,a4
 8c8:	fff78993          	add	s3,a5,-1
 8cc:	99ba                	add	s3,s3,a4
 8ce:	377d                	addw	a4,a4,-1
 8d0:	1702                	sll	a4,a4,0x20
 8d2:	9301                	srl	a4,a4,0x20
 8d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8d8:	fff94583          	lbu	a1,-1(s2)
 8dc:	8526                	mv	a0,s1
 8de:	00000097          	auipc	ra,0x0
 8e2:	f56080e7          	jalr	-170(ra) # 834 <putc>
  while(--i >= 0)
 8e6:	197d                	add	s2,s2,-1
 8e8:	ff3918e3          	bne	s2,s3,8d8 <printint+0x82>
}
 8ec:	70e2                	ld	ra,56(sp)
 8ee:	7442                	ld	s0,48(sp)
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	7902                	ld	s2,32(sp)
 8f4:	69e2                	ld	s3,24(sp)
 8f6:	6121                	add	sp,sp,64
 8f8:	8082                	ret
    x = -xx;
 8fa:	40b005bb          	negw	a1,a1
    neg = 1;
 8fe:	4885                	li	a7,1
    x = -xx;
 900:	bf85                	j	870 <printint+0x1a>

0000000000000902 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 902:	711d                	add	sp,sp,-96
 904:	ec86                	sd	ra,88(sp)
 906:	e8a2                	sd	s0,80(sp)
 908:	e4a6                	sd	s1,72(sp)
 90a:	e0ca                	sd	s2,64(sp)
 90c:	fc4e                	sd	s3,56(sp)
 90e:	f852                	sd	s4,48(sp)
 910:	f456                	sd	s5,40(sp)
 912:	f05a                	sd	s6,32(sp)
 914:	ec5e                	sd	s7,24(sp)
 916:	e862                	sd	s8,16(sp)
 918:	e466                	sd	s9,8(sp)
 91a:	e06a                	sd	s10,0(sp)
 91c:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 91e:	0005c903          	lbu	s2,0(a1)
 922:	28090963          	beqz	s2,bb4 <vprintf+0x2b2>
 926:	8b2a                	mv	s6,a0
 928:	8a2e                	mv	s4,a1
 92a:	8bb2                	mv	s7,a2
  state = 0;
 92c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 92e:	4481                	li	s1,0
 930:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 932:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 936:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 93a:	06c00c93          	li	s9,108
 93e:	a015                	j	962 <vprintf+0x60>
        putc(fd, c0);
 940:	85ca                	mv	a1,s2
 942:	855a                	mv	a0,s6
 944:	00000097          	auipc	ra,0x0
 948:	ef0080e7          	jalr	-272(ra) # 834 <putc>
 94c:	a019                	j	952 <vprintf+0x50>
    } else if(state == '%'){
 94e:	03598263          	beq	s3,s5,972 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 952:	2485                	addw	s1,s1,1
 954:	8726                	mv	a4,s1
 956:	009a07b3          	add	a5,s4,s1
 95a:	0007c903          	lbu	s2,0(a5)
 95e:	24090b63          	beqz	s2,bb4 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 962:	0009079b          	sext.w	a5,s2
    if(state == 0){
 966:	fe0994e3          	bnez	s3,94e <vprintf+0x4c>
      if(c0 == '%'){
 96a:	fd579be3          	bne	a5,s5,940 <vprintf+0x3e>
        state = '%';
 96e:	89be                	mv	s3,a5
 970:	b7cd                	j	952 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 972:	cbc9                	beqz	a5,a04 <vprintf+0x102>
 974:	00ea06b3          	add	a3,s4,a4
 978:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 97c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 97e:	c681                	beqz	a3,986 <vprintf+0x84>
 980:	9752                	add	a4,a4,s4
 982:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 986:	05878163          	beq	a5,s8,9c8 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 98a:	05978d63          	beq	a5,s9,9e4 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 98e:	07500713          	li	a4,117
 992:	10e78163          	beq	a5,a4,a94 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 996:	07800713          	li	a4,120
 99a:	14e78963          	beq	a5,a4,aec <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 99e:	07000713          	li	a4,112
 9a2:	18e78263          	beq	a5,a4,b26 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9a6:	07300713          	li	a4,115
 9aa:	1ce78663          	beq	a5,a4,b76 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9ae:	02500713          	li	a4,37
 9b2:	04e79963          	bne	a5,a4,a04 <vprintf+0x102>
        putc(fd, '%');
 9b6:	02500593          	li	a1,37
 9ba:	855a                	mv	a0,s6
 9bc:	00000097          	auipc	ra,0x0
 9c0:	e78080e7          	jalr	-392(ra) # 834 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9c4:	4981                	li	s3,0
 9c6:	b771                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 9c8:	008b8913          	add	s2,s7,8
 9cc:	4685                	li	a3,1
 9ce:	4629                	li	a2,10
 9d0:	000ba583          	lw	a1,0(s7)
 9d4:	855a                	mv	a0,s6
 9d6:	00000097          	auipc	ra,0x0
 9da:	e80080e7          	jalr	-384(ra) # 856 <printint>
 9de:	8bca                	mv	s7,s2
      state = 0;
 9e0:	4981                	li	s3,0
 9e2:	bf85                	j	952 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 9e4:	06400793          	li	a5,100
 9e8:	02f68d63          	beq	a3,a5,a22 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9ec:	06c00793          	li	a5,108
 9f0:	04f68863          	beq	a3,a5,a40 <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 9f4:	07500793          	li	a5,117
 9f8:	0af68c63          	beq	a3,a5,ab0 <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 9fc:	07800793          	li	a5,120
 a00:	10f68463          	beq	a3,a5,b08 <vprintf+0x206>
        putc(fd, '%');
 a04:	02500593          	li	a1,37
 a08:	855a                	mv	a0,s6
 a0a:	00000097          	auipc	ra,0x0
 a0e:	e2a080e7          	jalr	-470(ra) # 834 <putc>
        putc(fd, c0);
 a12:	85ca                	mv	a1,s2
 a14:	855a                	mv	a0,s6
 a16:	00000097          	auipc	ra,0x0
 a1a:	e1e080e7          	jalr	-482(ra) # 834 <putc>
      state = 0;
 a1e:	4981                	li	s3,0
 a20:	bf0d                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a22:	008b8913          	add	s2,s7,8
 a26:	4685                	li	a3,1
 a28:	4629                	li	a2,10
 a2a:	000ba583          	lw	a1,0(s7)
 a2e:	855a                	mv	a0,s6
 a30:	00000097          	auipc	ra,0x0
 a34:	e26080e7          	jalr	-474(ra) # 856 <printint>
        i += 1;
 a38:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a3a:	8bca                	mv	s7,s2
      state = 0;
 a3c:	4981                	li	s3,0
        i += 1;
 a3e:	bf11                	j	952 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a40:	06400793          	li	a5,100
 a44:	02f60963          	beq	a2,a5,a76 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a48:	07500793          	li	a5,117
 a4c:	08f60163          	beq	a2,a5,ace <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a50:	07800793          	li	a5,120
 a54:	faf618e3          	bne	a2,a5,a04 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a58:	008b8913          	add	s2,s7,8
 a5c:	4681                	li	a3,0
 a5e:	4641                	li	a2,16
 a60:	000ba583          	lw	a1,0(s7)
 a64:	855a                	mv	a0,s6
 a66:	00000097          	auipc	ra,0x0
 a6a:	df0080e7          	jalr	-528(ra) # 856 <printint>
        i += 2;
 a6e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a70:	8bca                	mv	s7,s2
      state = 0;
 a72:	4981                	li	s3,0
        i += 2;
 a74:	bdf9                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a76:	008b8913          	add	s2,s7,8
 a7a:	4685                	li	a3,1
 a7c:	4629                	li	a2,10
 a7e:	000ba583          	lw	a1,0(s7)
 a82:	855a                	mv	a0,s6
 a84:	00000097          	auipc	ra,0x0
 a88:	dd2080e7          	jalr	-558(ra) # 856 <printint>
        i += 2;
 a8c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a8e:	8bca                	mv	s7,s2
      state = 0;
 a90:	4981                	li	s3,0
        i += 2;
 a92:	b5c1                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 a94:	008b8913          	add	s2,s7,8
 a98:	4681                	li	a3,0
 a9a:	4629                	li	a2,10
 a9c:	000ba583          	lw	a1,0(s7)
 aa0:	855a                	mv	a0,s6
 aa2:	00000097          	auipc	ra,0x0
 aa6:	db4080e7          	jalr	-588(ra) # 856 <printint>
 aaa:	8bca                	mv	s7,s2
      state = 0;
 aac:	4981                	li	s3,0
 aae:	b555                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab0:	008b8913          	add	s2,s7,8
 ab4:	4681                	li	a3,0
 ab6:	4629                	li	a2,10
 ab8:	000ba583          	lw	a1,0(s7)
 abc:	855a                	mv	a0,s6
 abe:	00000097          	auipc	ra,0x0
 ac2:	d98080e7          	jalr	-616(ra) # 856 <printint>
        i += 1;
 ac6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 ac8:	8bca                	mv	s7,s2
      state = 0;
 aca:	4981                	li	s3,0
        i += 1;
 acc:	b559                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ace:	008b8913          	add	s2,s7,8
 ad2:	4681                	li	a3,0
 ad4:	4629                	li	a2,10
 ad6:	000ba583          	lw	a1,0(s7)
 ada:	855a                	mv	a0,s6
 adc:	00000097          	auipc	ra,0x0
 ae0:	d7a080e7          	jalr	-646(ra) # 856 <printint>
        i += 2;
 ae4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ae6:	8bca                	mv	s7,s2
      state = 0;
 ae8:	4981                	li	s3,0
        i += 2;
 aea:	b5a5                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 aec:	008b8913          	add	s2,s7,8
 af0:	4681                	li	a3,0
 af2:	4641                	li	a2,16
 af4:	000ba583          	lw	a1,0(s7)
 af8:	855a                	mv	a0,s6
 afa:	00000097          	auipc	ra,0x0
 afe:	d5c080e7          	jalr	-676(ra) # 856 <printint>
 b02:	8bca                	mv	s7,s2
      state = 0;
 b04:	4981                	li	s3,0
 b06:	b5b1                	j	952 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b08:	008b8913          	add	s2,s7,8
 b0c:	4681                	li	a3,0
 b0e:	4641                	li	a2,16
 b10:	000ba583          	lw	a1,0(s7)
 b14:	855a                	mv	a0,s6
 b16:	00000097          	auipc	ra,0x0
 b1a:	d40080e7          	jalr	-704(ra) # 856 <printint>
        i += 1;
 b1e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b20:	8bca                	mv	s7,s2
      state = 0;
 b22:	4981                	li	s3,0
        i += 1;
 b24:	b53d                	j	952 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 b26:	008b8d13          	add	s10,s7,8
 b2a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b2e:	03000593          	li	a1,48
 b32:	855a                	mv	a0,s6
 b34:	00000097          	auipc	ra,0x0
 b38:	d00080e7          	jalr	-768(ra) # 834 <putc>
  putc(fd, 'x');
 b3c:	07800593          	li	a1,120
 b40:	855a                	mv	a0,s6
 b42:	00000097          	auipc	ra,0x0
 b46:	cf2080e7          	jalr	-782(ra) # 834 <putc>
 b4a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b4c:	00000b97          	auipc	s7,0x0
 b50:	35cb8b93          	add	s7,s7,860 # ea8 <digits>
 b54:	03c9d793          	srl	a5,s3,0x3c
 b58:	97de                	add	a5,a5,s7
 b5a:	0007c583          	lbu	a1,0(a5)
 b5e:	855a                	mv	a0,s6
 b60:	00000097          	auipc	ra,0x0
 b64:	cd4080e7          	jalr	-812(ra) # 834 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b68:	0992                	sll	s3,s3,0x4
 b6a:	397d                	addw	s2,s2,-1
 b6c:	fe0914e3          	bnez	s2,b54 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 b70:	8bea                	mv	s7,s10
      state = 0;
 b72:	4981                	li	s3,0
 b74:	bbf9                	j	952 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 b76:	008b8993          	add	s3,s7,8
 b7a:	000bb903          	ld	s2,0(s7)
 b7e:	02090163          	beqz	s2,ba0 <vprintf+0x29e>
        for(; *s; s++)
 b82:	00094583          	lbu	a1,0(s2)
 b86:	c585                	beqz	a1,bae <vprintf+0x2ac>
          putc(fd, *s);
 b88:	855a                	mv	a0,s6
 b8a:	00000097          	auipc	ra,0x0
 b8e:	caa080e7          	jalr	-854(ra) # 834 <putc>
        for(; *s; s++)
 b92:	0905                	add	s2,s2,1
 b94:	00094583          	lbu	a1,0(s2)
 b98:	f9e5                	bnez	a1,b88 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 b9a:	8bce                	mv	s7,s3
      state = 0;
 b9c:	4981                	li	s3,0
 b9e:	bb55                	j	952 <vprintf+0x50>
          s = "(null)";
 ba0:	00000917          	auipc	s2,0x0
 ba4:	30090913          	add	s2,s2,768 # ea0 <malloc+0x1ea>
        for(; *s; s++)
 ba8:	02800593          	li	a1,40
 bac:	bff1                	j	b88 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 bae:	8bce                	mv	s7,s3
      state = 0;
 bb0:	4981                	li	s3,0
 bb2:	b345                	j	952 <vprintf+0x50>
    }
  }
}
 bb4:	60e6                	ld	ra,88(sp)
 bb6:	6446                	ld	s0,80(sp)
 bb8:	64a6                	ld	s1,72(sp)
 bba:	6906                	ld	s2,64(sp)
 bbc:	79e2                	ld	s3,56(sp)
 bbe:	7a42                	ld	s4,48(sp)
 bc0:	7aa2                	ld	s5,40(sp)
 bc2:	7b02                	ld	s6,32(sp)
 bc4:	6be2                	ld	s7,24(sp)
 bc6:	6c42                	ld	s8,16(sp)
 bc8:	6ca2                	ld	s9,8(sp)
 bca:	6d02                	ld	s10,0(sp)
 bcc:	6125                	add	sp,sp,96
 bce:	8082                	ret

0000000000000bd0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 bd0:	715d                	add	sp,sp,-80
 bd2:	ec06                	sd	ra,24(sp)
 bd4:	e822                	sd	s0,16(sp)
 bd6:	1000                	add	s0,sp,32
 bd8:	e010                	sd	a2,0(s0)
 bda:	e414                	sd	a3,8(s0)
 bdc:	e818                	sd	a4,16(s0)
 bde:	ec1c                	sd	a5,24(s0)
 be0:	03043023          	sd	a6,32(s0)
 be4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 be8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bec:	8622                	mv	a2,s0
 bee:	00000097          	auipc	ra,0x0
 bf2:	d14080e7          	jalr	-748(ra) # 902 <vprintf>
}
 bf6:	60e2                	ld	ra,24(sp)
 bf8:	6442                	ld	s0,16(sp)
 bfa:	6161                	add	sp,sp,80
 bfc:	8082                	ret

0000000000000bfe <printf>:

void
printf(const char *fmt, ...)
{
 bfe:	711d                	add	sp,sp,-96
 c00:	ec06                	sd	ra,24(sp)
 c02:	e822                	sd	s0,16(sp)
 c04:	1000                	add	s0,sp,32
 c06:	e40c                	sd	a1,8(s0)
 c08:	e810                	sd	a2,16(s0)
 c0a:	ec14                	sd	a3,24(s0)
 c0c:	f018                	sd	a4,32(s0)
 c0e:	f41c                	sd	a5,40(s0)
 c10:	03043823          	sd	a6,48(s0)
 c14:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c18:	00840613          	add	a2,s0,8
 c1c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c20:	85aa                	mv	a1,a0
 c22:	4505                	li	a0,1
 c24:	00000097          	auipc	ra,0x0
 c28:	cde080e7          	jalr	-802(ra) # 902 <vprintf>
}
 c2c:	60e2                	ld	ra,24(sp)
 c2e:	6442                	ld	s0,16(sp)
 c30:	6125                	add	sp,sp,96
 c32:	8082                	ret

0000000000000c34 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c34:	1141                	add	sp,sp,-16
 c36:	e422                	sd	s0,8(sp)
 c38:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c3a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c3e:	00000797          	auipc	a5,0x0
 c42:	2aa7b783          	ld	a5,682(a5) # ee8 <freep>
 c46:	a02d                	j	c70 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c48:	4618                	lw	a4,8(a2)
 c4a:	9f2d                	addw	a4,a4,a1
 c4c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c50:	6398                	ld	a4,0(a5)
 c52:	6310                	ld	a2,0(a4)
 c54:	a83d                	j	c92 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c56:	ff852703          	lw	a4,-8(a0)
 c5a:	9f31                	addw	a4,a4,a2
 c5c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c5e:	ff053683          	ld	a3,-16(a0)
 c62:	a091                	j	ca6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c64:	6398                	ld	a4,0(a5)
 c66:	00e7e463          	bltu	a5,a4,c6e <free+0x3a>
 c6a:	00e6ea63          	bltu	a3,a4,c7e <free+0x4a>
{
 c6e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c70:	fed7fae3          	bgeu	a5,a3,c64 <free+0x30>
 c74:	6398                	ld	a4,0(a5)
 c76:	00e6e463          	bltu	a3,a4,c7e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c7a:	fee7eae3          	bltu	a5,a4,c6e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c7e:	ff852583          	lw	a1,-8(a0)
 c82:	6390                	ld	a2,0(a5)
 c84:	02059813          	sll	a6,a1,0x20
 c88:	01c85713          	srl	a4,a6,0x1c
 c8c:	9736                	add	a4,a4,a3
 c8e:	fae60de3          	beq	a2,a4,c48 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c92:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c96:	4790                	lw	a2,8(a5)
 c98:	02061593          	sll	a1,a2,0x20
 c9c:	01c5d713          	srl	a4,a1,0x1c
 ca0:	973e                	add	a4,a4,a5
 ca2:	fae68ae3          	beq	a3,a4,c56 <free+0x22>
    p->s.ptr = bp->s.ptr;
 ca6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ca8:	00000717          	auipc	a4,0x0
 cac:	24f73023          	sd	a5,576(a4) # ee8 <freep>
}
 cb0:	6422                	ld	s0,8(sp)
 cb2:	0141                	add	sp,sp,16
 cb4:	8082                	ret

0000000000000cb6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cb6:	7139                	add	sp,sp,-64
 cb8:	fc06                	sd	ra,56(sp)
 cba:	f822                	sd	s0,48(sp)
 cbc:	f426                	sd	s1,40(sp)
 cbe:	f04a                	sd	s2,32(sp)
 cc0:	ec4e                	sd	s3,24(sp)
 cc2:	e852                	sd	s4,16(sp)
 cc4:	e456                	sd	s5,8(sp)
 cc6:	e05a                	sd	s6,0(sp)
 cc8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cca:	02051493          	sll	s1,a0,0x20
 cce:	9081                	srl	s1,s1,0x20
 cd0:	04bd                	add	s1,s1,15
 cd2:	8091                	srl	s1,s1,0x4
 cd4:	0014899b          	addw	s3,s1,1
 cd8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 cda:	00000517          	auipc	a0,0x0
 cde:	20e53503          	ld	a0,526(a0) # ee8 <freep>
 ce2:	c515                	beqz	a0,d0e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ce6:	4798                	lw	a4,8(a5)
 ce8:	02977f63          	bgeu	a4,s1,d26 <malloc+0x70>
  if(nu < 4096)
 cec:	8a4e                	mv	s4,s3
 cee:	0009871b          	sext.w	a4,s3
 cf2:	6685                	lui	a3,0x1
 cf4:	00d77363          	bgeu	a4,a3,cfa <malloc+0x44>
 cf8:	6a05                	lui	s4,0x1
 cfa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cfe:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d02:	00000917          	auipc	s2,0x0
 d06:	1e690913          	add	s2,s2,486 # ee8 <freep>
  if(p == (char*)-1)
 d0a:	5afd                	li	s5,-1
 d0c:	a895                	j	d80 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 d0e:	00009797          	auipc	a5,0x9
 d12:	b8278793          	add	a5,a5,-1150 # 9890 <base>
 d16:	00000717          	auipc	a4,0x0
 d1a:	1cf73923          	sd	a5,466(a4) # ee8 <freep>
 d1e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d20:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d24:	b7e1                	j	cec <malloc+0x36>
      if(p->s.size == nunits)
 d26:	02e48c63          	beq	s1,a4,d5e <malloc+0xa8>
        p->s.size -= nunits;
 d2a:	4137073b          	subw	a4,a4,s3
 d2e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d30:	02071693          	sll	a3,a4,0x20
 d34:	01c6d713          	srl	a4,a3,0x1c
 d38:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d3a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d3e:	00000717          	auipc	a4,0x0
 d42:	1aa73523          	sd	a0,426(a4) # ee8 <freep>
      return (void*)(p + 1);
 d46:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d4a:	70e2                	ld	ra,56(sp)
 d4c:	7442                	ld	s0,48(sp)
 d4e:	74a2                	ld	s1,40(sp)
 d50:	7902                	ld	s2,32(sp)
 d52:	69e2                	ld	s3,24(sp)
 d54:	6a42                	ld	s4,16(sp)
 d56:	6aa2                	ld	s5,8(sp)
 d58:	6b02                	ld	s6,0(sp)
 d5a:	6121                	add	sp,sp,64
 d5c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d5e:	6398                	ld	a4,0(a5)
 d60:	e118                	sd	a4,0(a0)
 d62:	bff1                	j	d3e <malloc+0x88>
  hp->s.size = nu;
 d64:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d68:	0541                	add	a0,a0,16
 d6a:	00000097          	auipc	ra,0x0
 d6e:	eca080e7          	jalr	-310(ra) # c34 <free>
  return freep;
 d72:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d76:	d971                	beqz	a0,d4a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d78:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d7a:	4798                	lw	a4,8(a5)
 d7c:	fa9775e3          	bgeu	a4,s1,d26 <malloc+0x70>
    if(p == freep)
 d80:	00093703          	ld	a4,0(s2)
 d84:	853e                	mv	a0,a5
 d86:	fef719e3          	bne	a4,a5,d78 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 d8a:	8552                	mv	a0,s4
 d8c:	00000097          	auipc	ra,0x0
 d90:	a90080e7          	jalr	-1392(ra) # 81c <sbrk>
  if(p == (char*)-1)
 d94:	fd5518e3          	bne	a0,s5,d64 <malloc+0xae>
        return 0;
 d98:	4501                	li	a0,0
 d9a:	bf45                	j	d4a <malloc+0x94>
