
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
   a:	72278793          	add	a5,a5,1826 # 1728 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	f0f73523          	sd	a5,-246(a4) # f18 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	70f72823          	sw	a5,1808(a4) # 3728 <all_thread+0x2000>
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
  2e:	1000                	add	s0,sp,32

  /* CMPT 332 GROUP 01, FALL 2024 */
  /* initializing the threads first */
  /*struct thread *t = (struct thread*)malloc(sizeof(struct thread));*/
  struct thread *next_thread = (struct thread*)malloc(sizeof(struct thread));
  30:	6489                	lui	s1,0x2
  32:	06848513          	add	a0,s1,104 # 2068 <all_thread+0x940>
  36:	00001097          	auipc	ra,0x1
  3a:	cba080e7          	jalr	-838(ra) # cf0 <malloc>
  3e:	85aa                	mv	a1,a0
  uint64_t current_stack, next_stack;
  current_stack = (uint64_t)current_thread->stack; 
  40:	00001717          	auipc	a4,0x1
  44:	ed870713          	add	a4,a4,-296 # f18 <current_thread>
  48:	6308                	ld	a0,0(a4)
  next_stack = (uint64_t)next_thread->stack;

  /* Find another runnable thread. */
  next_thread = 0;
  current_thread = current_thread + 1;
  4a:	06848793          	add	a5,s1,104
  4e:	97aa                	add	a5,a5,a0
  50:	e31c                	sd	a5,0(a4)
  52:	4711                	li	a4,4
  54:	4601                	li	a2,0
  for(int i = 0; i < MAX_THREAD; i++){
    if(current_thread >= all_thread + MAX_THREAD)
  56:	0000ae17          	auipc	t3,0xa
  5a:	872e0e13          	add	t3,t3,-1934 # 98c8 <base>
  5e:	4805                	li	a6,1
      current_thread = all_thread;
    if(current_thread->state == RUNNABLE) {
  60:	6889                	lui	a7,0x2
  62:	4309                	li	t1,2
      next_thread = current_thread;
      break;
    }
    current_thread = current_thread + 1;
  64:	06888e93          	add	t4,a7,104 # 2068 <all_thread+0x940>
  68:	a811                	j	7c <thread_schedule+0x56>
    if(current_thread->state == RUNNABLE) {
  6a:	011786b3          	add	a3,a5,a7
  6e:	4294                	lw	a3,0(a3)
  70:	00668e63          	beq	a3,t1,8c <thread_schedule+0x66>
    current_thread = current_thread + 1;
  74:	97f6                	add	a5,a5,t4
  for(int i = 0; i < MAX_THREAD; i++){
  76:	377d                	addw	a4,a4,-1
  78:	8642                	mv	a2,a6
  7a:	c729                	beqz	a4,c4 <thread_schedule+0x9e>
    if(current_thread >= all_thread + MAX_THREAD)
  7c:	ffc7e7e3          	bltu	a5,t3,6a <thread_schedule+0x44>
  80:	8642                	mv	a2,a6
      current_thread = all_thread;
  82:	00001797          	auipc	a5,0x1
  86:	6a678793          	add	a5,a5,1702 # 1728 <all_thread>
  8a:	b7c5                	j	6a <thread_schedule+0x44>
  8c:	c609                	beqz	a2,96 <thread_schedule+0x70>
  8e:	00001717          	auipc	a4,0x1
  92:	e8f73523          	sd	a5,-374(a4) # f18 <current_thread>
  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  96:	00001717          	auipc	a4,0x1
  9a:	e8273703          	ld	a4,-382(a4) # f18 <current_thread>
  9e:	00f70e63          	beq	a4,a5,ba <thread_schedule+0x94>
    next_thread->state = RUNNING;
  a2:	6709                	lui	a4,0x2
  a4:	973e                	add	a4,a4,a5
  a6:	4685                	li	a3,1
  a8:	c314                	sw	a3,0(a4)
    /*t = current_thread;*/
    current_thread = next_thread;
  aa:	00001717          	auipc	a4,0x1
  ae:	e6f73723          	sd	a5,-402(a4) # f18 <current_thread>

    /* CMPT 332 GROUP 01, FALL 2024 */
    thread_switch(current_stack, next_stack);
  b2:	00000097          	auipc	ra,0x0
  b6:	450080e7          	jalr	1104(ra) # 502 <thread_switch>
  } else
    next_thread = 0;
}
  ba:	60e2                	ld	ra,24(sp)
  bc:	6442                	ld	s0,16(sp)
  be:	64a2                	ld	s1,8(sp)
  c0:	6105                	add	sp,sp,32
  c2:	8082                	ret
  c4:	00001717          	auipc	a4,0x1
  c8:	e4f73a23          	sd	a5,-428(a4) # f18 <current_thread>
    printf("thread_schedule: no runnable threads\n");
  cc:	00001517          	auipc	a0,0x1
  d0:	d0c50513          	add	a0,a0,-756 # dd8 <malloc+0xe8>
  d4:	00001097          	auipc	ra,0x1
  d8:	b64080e7          	jalr	-1180(ra) # c38 <printf>
    exit(-1);
  dc:	557d                	li	a0,-1
  de:	00000097          	auipc	ra,0x0
  e2:	6f0080e7          	jalr	1776(ra) # 7ce <exit>

00000000000000e6 <thread_create>:

void 
thread_create(void (*func)())
{
  e6:	1141                	add	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	add	s0,sp,16
  
  /* CMPT 332 GROUP 01, FALL 2024 */
  /*struct thread *t = (struct thread *) malloc (sizeof(struct thread));*/

  for (current_thread = all_thread; current_thread < all_thread + MAX_THREAD; current_thread++) { 
  ec:	00001797          	auipc	a5,0x1
  f0:	63c78793          	add	a5,a5,1596 # 1728 <all_thread>
  f4:	00001717          	auipc	a4,0x1
  f8:	e2f73223          	sd	a5,-476(a4) # f18 <current_thread>
  fc:	4601                	li	a2,0
    if (current_thread->state == FREE) break;
  fe:	6689                	lui	a3,0x2
  for (current_thread = all_thread; current_thread < all_thread + MAX_THREAD; current_thread++) { 
 100:	06868813          	add	a6,a3,104 # 2068 <all_thread+0x940>
 104:	4505                	li	a0,1
 106:	00009597          	auipc	a1,0x9
 10a:	7c258593          	add	a1,a1,1986 # 98c8 <base>
 10e:	a011                	j	112 <thread_create+0x2c>
 110:	88be                	mv	a7,a5
    if (current_thread->state == FREE) break;
 112:	00d78733          	add	a4,a5,a3
 116:	4318                	lw	a4,0(a4)
 118:	c705                	beqz	a4,140 <thread_create+0x5a>
  for (current_thread = all_thread; current_thread < all_thread + MAX_THREAD; current_thread++) { 
 11a:	97c2                	add	a5,a5,a6
 11c:	862a                	mv	a2,a0
 11e:	feb799e3          	bne	a5,a1,110 <thread_create+0x2a>
 122:	00009717          	auipc	a4,0x9
 126:	7a670713          	add	a4,a4,1958 # 98c8 <base>
 12a:	00001697          	auipc	a3,0x1
 12e:	dee6b723          	sd	a4,-530(a3) # f18 <current_thread>
  }
  current_thread->state = RUNNABLE;
 132:	6709                	lui	a4,0x2
 134:	97ba                	add	a5,a5,a4
 136:	4709                	li	a4,2
 138:	c398                	sw	a4,0(a5)
  
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	add	sp,sp,16
 13e:	8082                	ret
 140:	da6d                	beqz	a2,132 <thread_create+0x4c>
 142:	00001717          	auipc	a4,0x1
 146:	dd173b23          	sd	a7,-554(a4) # f18 <current_thread>
 14a:	b7e5                	j	132 <thread_create+0x4c>

000000000000014c <thread_yield>:

void 
thread_yield(void)
{
 14c:	1141                	add	sp,sp,-16
 14e:	e406                	sd	ra,8(sp)
 150:	e022                	sd	s0,0(sp)
 152:	0800                	add	s0,sp,16
  current_thread->state = RUNNABLE;
 154:	00001797          	auipc	a5,0x1
 158:	dc47b783          	ld	a5,-572(a5) # f18 <current_thread>
 15c:	6709                	lui	a4,0x2
 15e:	97ba                	add	a5,a5,a4
 160:	4709                	li	a4,2
 162:	c398                	sw	a4,0(a5)
  thread_schedule();
 164:	00000097          	auipc	ra,0x0
 168:	ec2080e7          	jalr	-318(ra) # 26 <thread_schedule>
}
 16c:	60a2                	ld	ra,8(sp)
 16e:	6402                	ld	s0,0(sp)
 170:	0141                	add	sp,sp,16
 172:	8082                	ret

0000000000000174 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 174:	7179                	add	sp,sp,-48
 176:	f406                	sd	ra,40(sp)
 178:	f022                	sd	s0,32(sp)
 17a:	ec26                	sd	s1,24(sp)
 17c:	e84a                	sd	s2,16(sp)
 17e:	e44e                	sd	s3,8(sp)
 180:	e052                	sd	s4,0(sp)
 182:	1800                	add	s0,sp,48
  int i;
  printf("thread_a started\n");
 184:	00001517          	auipc	a0,0x1
 188:	c7c50513          	add	a0,a0,-900 # e00 <malloc+0x110>
 18c:	00001097          	auipc	ra,0x1
 190:	aac080e7          	jalr	-1364(ra) # c38 <printf>
  a_started = 1;
 194:	4785                	li	a5,1
 196:	00001717          	auipc	a4,0x1
 19a:	d6f72b23          	sw	a5,-650(a4) # f0c <a_started>
  while(b_started == 0 || c_started == 0)
 19e:	00001497          	auipc	s1,0x1
 1a2:	d6a48493          	add	s1,s1,-662 # f08 <b_started>
 1a6:	00001917          	auipc	s2,0x1
 1aa:	d5e90913          	add	s2,s2,-674 # f04 <c_started>
 1ae:	a029                	j	1b8 <thread_a+0x44>
    thread_yield();
 1b0:	00000097          	auipc	ra,0x0
 1b4:	f9c080e7          	jalr	-100(ra) # 14c <thread_yield>
  while(b_started == 0 || c_started == 0)
 1b8:	409c                	lw	a5,0(s1)
 1ba:	2781                	sext.w	a5,a5
 1bc:	dbf5                	beqz	a5,1b0 <thread_a+0x3c>
 1be:	00092783          	lw	a5,0(s2)
 1c2:	2781                	sext.w	a5,a5
 1c4:	d7f5                	beqz	a5,1b0 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 1c6:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 1c8:	00001a17          	auipc	s4,0x1
 1cc:	c50a0a13          	add	s4,s4,-944 # e18 <malloc+0x128>
    a_n += 1;
 1d0:	00001917          	auipc	s2,0x1
 1d4:	d3090913          	add	s2,s2,-720 # f00 <a_n>
  for (i = 0; i < 100; i++) {
 1d8:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 1dc:	85a6                	mv	a1,s1
 1de:	8552                	mv	a0,s4
 1e0:	00001097          	auipc	ra,0x1
 1e4:	a58080e7          	jalr	-1448(ra) # c38 <printf>
    a_n += 1;
 1e8:	00092783          	lw	a5,0(s2)
 1ec:	2785                	addw	a5,a5,1
 1ee:	00f92023          	sw	a5,0(s2)
    thread_yield();
 1f2:	00000097          	auipc	ra,0x0
 1f6:	f5a080e7          	jalr	-166(ra) # 14c <thread_yield>
  for (i = 0; i < 100; i++) {
 1fa:	2485                	addw	s1,s1,1
 1fc:	ff3490e3          	bne	s1,s3,1dc <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 200:	00001597          	auipc	a1,0x1
 204:	d005a583          	lw	a1,-768(a1) # f00 <a_n>
 208:	00001517          	auipc	a0,0x1
 20c:	c2050513          	add	a0,a0,-992 # e28 <malloc+0x138>
 210:	00001097          	auipc	ra,0x1
 214:	a28080e7          	jalr	-1496(ra) # c38 <printf>

  current_thread->state = FREE;
 218:	00001797          	auipc	a5,0x1
 21c:	d007b783          	ld	a5,-768(a5) # f18 <current_thread>
 220:	6709                	lui	a4,0x2
 222:	97ba                	add	a5,a5,a4
 224:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 228:	00000097          	auipc	ra,0x0
 22c:	dfe080e7          	jalr	-514(ra) # 26 <thread_schedule>
}
 230:	70a2                	ld	ra,40(sp)
 232:	7402                	ld	s0,32(sp)
 234:	64e2                	ld	s1,24(sp)
 236:	6942                	ld	s2,16(sp)
 238:	69a2                	ld	s3,8(sp)
 23a:	6a02                	ld	s4,0(sp)
 23c:	6145                	add	sp,sp,48
 23e:	8082                	ret

0000000000000240 <thread_b>:

void 
thread_b(void)
{
 240:	7179                	add	sp,sp,-48
 242:	f406                	sd	ra,40(sp)
 244:	f022                	sd	s0,32(sp)
 246:	ec26                	sd	s1,24(sp)
 248:	e84a                	sd	s2,16(sp)
 24a:	e44e                	sd	s3,8(sp)
 24c:	e052                	sd	s4,0(sp)
 24e:	1800                	add	s0,sp,48
  int i;
  printf("thread_b started\n");
 250:	00001517          	auipc	a0,0x1
 254:	bf850513          	add	a0,a0,-1032 # e48 <malloc+0x158>
 258:	00001097          	auipc	ra,0x1
 25c:	9e0080e7          	jalr	-1568(ra) # c38 <printf>
  b_started = 1;
 260:	4785                	li	a5,1
 262:	00001717          	auipc	a4,0x1
 266:	caf72323          	sw	a5,-858(a4) # f08 <b_started>
  while(a_started == 0 || c_started == 0)
 26a:	00001497          	auipc	s1,0x1
 26e:	ca248493          	add	s1,s1,-862 # f0c <a_started>
 272:	00001917          	auipc	s2,0x1
 276:	c9290913          	add	s2,s2,-878 # f04 <c_started>
 27a:	a029                	j	284 <thread_b+0x44>
    thread_yield();
 27c:	00000097          	auipc	ra,0x0
 280:	ed0080e7          	jalr	-304(ra) # 14c <thread_yield>
  while(a_started == 0 || c_started == 0)
 284:	409c                	lw	a5,0(s1)
 286:	2781                	sext.w	a5,a5
 288:	dbf5                	beqz	a5,27c <thread_b+0x3c>
 28a:	00092783          	lw	a5,0(s2)
 28e:	2781                	sext.w	a5,a5
 290:	d7f5                	beqz	a5,27c <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 292:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 294:	00001a17          	auipc	s4,0x1
 298:	bcca0a13          	add	s4,s4,-1076 # e60 <malloc+0x170>
    b_n += 1;
 29c:	00001917          	auipc	s2,0x1
 2a0:	c6090913          	add	s2,s2,-928 # efc <b_n>
  for (i = 0; i < 100; i++) {
 2a4:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 2a8:	85a6                	mv	a1,s1
 2aa:	8552                	mv	a0,s4
 2ac:	00001097          	auipc	ra,0x1
 2b0:	98c080e7          	jalr	-1652(ra) # c38 <printf>
    b_n += 1;
 2b4:	00092783          	lw	a5,0(s2)
 2b8:	2785                	addw	a5,a5,1
 2ba:	00f92023          	sw	a5,0(s2)
    thread_yield();
 2be:	00000097          	auipc	ra,0x0
 2c2:	e8e080e7          	jalr	-370(ra) # 14c <thread_yield>
  for (i = 0; i < 100; i++) {
 2c6:	2485                	addw	s1,s1,1
 2c8:	ff3490e3          	bne	s1,s3,2a8 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 2cc:	00001597          	auipc	a1,0x1
 2d0:	c305a583          	lw	a1,-976(a1) # efc <b_n>
 2d4:	00001517          	auipc	a0,0x1
 2d8:	b9c50513          	add	a0,a0,-1124 # e70 <malloc+0x180>
 2dc:	00001097          	auipc	ra,0x1
 2e0:	95c080e7          	jalr	-1700(ra) # c38 <printf>

  current_thread->state = FREE;
 2e4:	00001797          	auipc	a5,0x1
 2e8:	c347b783          	ld	a5,-972(a5) # f18 <current_thread>
 2ec:	6709                	lui	a4,0x2
 2ee:	97ba                	add	a5,a5,a4
 2f0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2f4:	00000097          	auipc	ra,0x0
 2f8:	d32080e7          	jalr	-718(ra) # 26 <thread_schedule>
}
 2fc:	70a2                	ld	ra,40(sp)
 2fe:	7402                	ld	s0,32(sp)
 300:	64e2                	ld	s1,24(sp)
 302:	6942                	ld	s2,16(sp)
 304:	69a2                	ld	s3,8(sp)
 306:	6a02                	ld	s4,0(sp)
 308:	6145                	add	sp,sp,48
 30a:	8082                	ret

000000000000030c <thread_c>:

void 
thread_c(void)
{
 30c:	7179                	add	sp,sp,-48
 30e:	f406                	sd	ra,40(sp)
 310:	f022                	sd	s0,32(sp)
 312:	ec26                	sd	s1,24(sp)
 314:	e84a                	sd	s2,16(sp)
 316:	e44e                	sd	s3,8(sp)
 318:	e052                	sd	s4,0(sp)
 31a:	1800                	add	s0,sp,48
  int i;
  printf("thread_c started\n");
 31c:	00001517          	auipc	a0,0x1
 320:	b7450513          	add	a0,a0,-1164 # e90 <malloc+0x1a0>
 324:	00001097          	auipc	ra,0x1
 328:	914080e7          	jalr	-1772(ra) # c38 <printf>
  c_started = 1;
 32c:	4785                	li	a5,1
 32e:	00001717          	auipc	a4,0x1
 332:	bcf72b23          	sw	a5,-1066(a4) # f04 <c_started>
  while(a_started == 0 || b_started == 0)
 336:	00001497          	auipc	s1,0x1
 33a:	bd648493          	add	s1,s1,-1066 # f0c <a_started>
 33e:	00001917          	auipc	s2,0x1
 342:	bca90913          	add	s2,s2,-1078 # f08 <b_started>
 346:	a029                	j	350 <thread_c+0x44>
    thread_yield();
 348:	00000097          	auipc	ra,0x0
 34c:	e04080e7          	jalr	-508(ra) # 14c <thread_yield>
  while(a_started == 0 || b_started == 0)
 350:	409c                	lw	a5,0(s1)
 352:	2781                	sext.w	a5,a5
 354:	dbf5                	beqz	a5,348 <thread_c+0x3c>
 356:	00092783          	lw	a5,0(s2)
 35a:	2781                	sext.w	a5,a5
 35c:	d7f5                	beqz	a5,348 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 35e:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 360:	00001a17          	auipc	s4,0x1
 364:	b48a0a13          	add	s4,s4,-1208 # ea8 <malloc+0x1b8>
    c_n += 1;
 368:	00001917          	auipc	s2,0x1
 36c:	b9090913          	add	s2,s2,-1136 # ef8 <c_n>
  for (i = 0; i < 100; i++) {
 370:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 374:	85a6                	mv	a1,s1
 376:	8552                	mv	a0,s4
 378:	00001097          	auipc	ra,0x1
 37c:	8c0080e7          	jalr	-1856(ra) # c38 <printf>
    c_n += 1;
 380:	00092783          	lw	a5,0(s2)
 384:	2785                	addw	a5,a5,1
 386:	00f92023          	sw	a5,0(s2)
    thread_yield();
 38a:	00000097          	auipc	ra,0x0
 38e:	dc2080e7          	jalr	-574(ra) # 14c <thread_yield>
  for (i = 0; i < 100; i++) {
 392:	2485                	addw	s1,s1,1
 394:	ff3490e3          	bne	s1,s3,374 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 398:	00001597          	auipc	a1,0x1
 39c:	b605a583          	lw	a1,-1184(a1) # ef8 <c_n>
 3a0:	00001517          	auipc	a0,0x1
 3a4:	b1850513          	add	a0,a0,-1256 # eb8 <malloc+0x1c8>
 3a8:	00001097          	auipc	ra,0x1
 3ac:	890080e7          	jalr	-1904(ra) # c38 <printf>

  current_thread->state = FREE;
 3b0:	00001797          	auipc	a5,0x1
 3b4:	b687b783          	ld	a5,-1176(a5) # f18 <current_thread>
 3b8:	6709                	lui	a4,0x2
 3ba:	97ba                	add	a5,a5,a4
 3bc:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 3c0:	00000097          	auipc	ra,0x0
 3c4:	c66080e7          	jalr	-922(ra) # 26 <thread_schedule>
}
 3c8:	70a2                	ld	ra,40(sp)
 3ca:	7402                	ld	s0,32(sp)
 3cc:	64e2                	ld	s1,24(sp)
 3ce:	6942                	ld	s2,16(sp)
 3d0:	69a2                	ld	s3,8(sp)
 3d2:	6a02                	ld	s4,0(sp)
 3d4:	6145                	add	sp,sp,48
 3d6:	8082                	ret

00000000000003d8 <mtx_create>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_create(int locked){
   int locked_id;
   if (m_count > MUTEX_SIZE){
 3d8:	00001717          	auipc	a4,0x1
 3dc:	b3872703          	lw	a4,-1224(a4) # f10 <m_count>
 3e0:	10000793          	li	a5,256
 3e4:	04e7c663          	blt	a5,a4,430 <mtx_create+0x58>
int mtx_create(int locked){
 3e8:	1101                	add	sp,sp,-32
 3ea:	ec06                	sd	ra,24(sp)
 3ec:	e822                	sd	s0,16(sp)
 3ee:	e426                	sd	s1,8(sp)
 3f0:	1000                	add	s0,sp,32
 3f2:	84aa                	mv	s1,a0
	return -1;
   }
   mutex_t *m = (mutex_t *)malloc(sizeof(mutex_t));
 3f4:	4511                	li	a0,4
 3f6:	00001097          	auipc	ra,0x1
 3fa:	8fa080e7          	jalr	-1798(ra) # cf0 <malloc>
 3fe:	87aa                	mv	a5,a0
   
   if (m == NULL){
 400:	c915                	beqz	a0,434 <mtx_create+0x5c>
	return -1;
   }
   m->locked = locked;
 402:	c104                	sw	s1,0(a0)
   all_m[m_count++] = m;
 404:	00001617          	auipc	a2,0x1
 408:	b0c60613          	add	a2,a2,-1268 # f10 <m_count>
 40c:	4218                	lw	a4,0(a2)
 40e:	0017051b          	addw	a0,a4,1
 412:	00371593          	sll	a1,a4,0x3
 416:	00001697          	auipc	a3,0x1
 41a:	b1268693          	add	a3,a3,-1262 # f28 <all_m>
 41e:	96ae                	add	a3,a3,a1
 420:	e29c                	sd	a5,0(a3)

   locked_id = m_count++;
 422:	2709                	addw	a4,a4,2
 424:	c218                	sw	a4,0(a2)
   return locked_id;
}
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	64a2                	ld	s1,8(sp)
 42c:	6105                	add	sp,sp,32
 42e:	8082                	ret
	return -1;
 430:	557d                	li	a0,-1
}
 432:	8082                	ret
	return -1;
 434:	557d                	li	a0,-1
 436:	bfc5                	j	426 <mtx_create+0x4e>

0000000000000438 <mtx_lock>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_lock(int lock_id){
 438:	1141                	add	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	add	s0,sp,16
   mutex_t* m = all_m[lock_id];
 43e:	050e                	sll	a0,a0,0x3
 440:	00001797          	auipc	a5,0x1
 444:	ae878793          	add	a5,a5,-1304 # f28 <all_m>
 448:	97aa                	add	a5,a5,a0
   while (m->locked){
 44a:	639c                	ld	a5,0(a5)
 44c:	439c                	lw	a5,0(a5)
 44e:	e381                	bnez	a5,44e <mtx_lock+0x16>
	/* wait indefinitely */
   }
   m->locked = 0;
   return 0;
}
 450:	4501                	li	a0,0
 452:	6422                	ld	s0,8(sp)
 454:	0141                	add	sp,sp,16
 456:	8082                	ret

0000000000000458 <mtx_unlock>:

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_unlock(int lock_id){
 458:	1141                	add	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	add	s0,sp,16
   mutex_t* m = all_m[lock_id];
 45e:	050e                	sll	a0,a0,0x3
 460:	00001797          	auipc	a5,0x1
 464:	ac878793          	add	a5,a5,-1336 # f28 <all_m>
 468:	97aa                	add	a5,a5,a0
 46a:	639c                	ld	a5,0(a5)
   while (!m->locked){return -1;}
 46c:	4398                	lw	a4,0(a5)
 46e:	c719                	beqz	a4,47c <mtx_unlock+0x24>
   m->locked = 1;
 470:	4705                	li	a4,1
 472:	c398                	sw	a4,0(a5)
   return 0;
 474:	4501                	li	a0,0
}
 476:	6422                	ld	s0,8(sp)
 478:	0141                	add	sp,sp,16
 47a:	8082                	ret
   while (!m->locked){return -1;}
 47c:	557d                	li	a0,-1
 47e:	bfe5                	j	476 <mtx_unlock+0x1e>

0000000000000480 <main>:

int main(int argc, char *argv[]) 
{
 480:	1141                	add	sp,sp,-16
 482:	e406                	sd	ra,8(sp)
 484:	e022                	sd	s0,0(sp)
 486:	0800                	add	s0,sp,16
  a_started = b_started = c_started = 0;
 488:	00001797          	auipc	a5,0x1
 48c:	a607ae23          	sw	zero,-1412(a5) # f04 <c_started>
 490:	00001797          	auipc	a5,0x1
 494:	a607ac23          	sw	zero,-1416(a5) # f08 <b_started>
 498:	00001797          	auipc	a5,0x1
 49c:	a607aa23          	sw	zero,-1420(a5) # f0c <a_started>
  a_n = b_n = c_n = 0;
 4a0:	00001797          	auipc	a5,0x1
 4a4:	a407ac23          	sw	zero,-1448(a5) # ef8 <c_n>
 4a8:	00001797          	auipc	a5,0x1
 4ac:	a407aa23          	sw	zero,-1452(a5) # efc <b_n>
 4b0:	00001797          	auipc	a5,0x1
 4b4:	a407a823          	sw	zero,-1456(a5) # f00 <a_n>
  thread_init();
 4b8:	00000097          	auipc	ra,0x0
 4bc:	b48080e7          	jalr	-1208(ra) # 0 <thread_init>
  thread_create(thread_a);
 4c0:	00000517          	auipc	a0,0x0
 4c4:	cb450513          	add	a0,a0,-844 # 174 <thread_a>
 4c8:	00000097          	auipc	ra,0x0
 4cc:	c1e080e7          	jalr	-994(ra) # e6 <thread_create>
  thread_create(thread_b);
 4d0:	00000517          	auipc	a0,0x0
 4d4:	d7050513          	add	a0,a0,-656 # 240 <thread_b>
 4d8:	00000097          	auipc	ra,0x0
 4dc:	c0e080e7          	jalr	-1010(ra) # e6 <thread_create>
  thread_create(thread_c);
 4e0:	00000517          	auipc	a0,0x0
 4e4:	e2c50513          	add	a0,a0,-468 # 30c <thread_c>
 4e8:	00000097          	auipc	ra,0x0
 4ec:	bfe080e7          	jalr	-1026(ra) # e6 <thread_create>
  thread_schedule();
 4f0:	00000097          	auipc	ra,0x0
 4f4:	b36080e7          	jalr	-1226(ra) # 26 <thread_schedule>
  exit(0);
 4f8:	4501                	li	a0,0
 4fa:	00000097          	auipc	ra,0x0
 4fe:	2d4080e7          	jalr	724(ra) # 7ce <exit>

0000000000000502 <thread_switch>:

	.globl thread_switch
thread_switch:
	/* First parameter in a0, second is in a1, stack pointer reg is sp  */
	/* Saving all of the saved registers from the current_thread*/
	addi sp, sp, -104 /* Moving the stack pointer to give it space */
 502:	f9810113          	add	sp,sp,-104
	sd sp, 0(a0)
 506:	00253023          	sd	sp,0(a0)
	sd ra, 8(sp)	
 50a:	e406                	sd	ra,8(sp)
	sd s0, 16(sp)	
 50c:	e822                	sd	s0,16(sp)
	sd s1, 24(sp)
 50e:	ec26                	sd	s1,24(sp)
	sd s2, 32(sp)
 510:	f04a                	sd	s2,32(sp)
	sd s3, 40(sp)
 512:	f44e                	sd	s3,40(sp)
	sd s4, 48(sp)
 514:	f852                	sd	s4,48(sp)
	sd s5, 56(sp)
 516:	fc56                	sd	s5,56(sp)
	sd s6, 64(sp)
 518:	e0da                	sd	s6,64(sp)
	sd s7, 72(sp)
 51a:	e4de                	sd	s7,72(sp)
	sd s8, 80(sp)
 51c:	e8e2                	sd	s8,80(sp)
	sd s9, 88(sp)
 51e:	ece6                	sd	s9,88(sp)
	sd s10, 96(sp)
 520:	f0ea                	sd	s10,96(sp)
	sd s11, 104(sp)
 522:	f4ee                	sd	s11,104(sp)
	
	ld sp, 0(a1) /* store next one */
 524:	0005b103          	ld	sp,0(a1)
	ld ra, 8(sp)
 528:	60a2                	ld	ra,8(sp)
	ld s0, 16(sp)
 52a:	6442                	ld	s0,16(sp)
	ld s1, 24(sp)
 52c:	64e2                	ld	s1,24(sp)
	ld s2, 32(sp)
 52e:	7902                	ld	s2,32(sp)
	ld s3, 40(sp)
 530:	79a2                	ld	s3,40(sp)
	ld s4, 48(sp)
 532:	7a42                	ld	s4,48(sp)
	ld s5, 56(sp)
 534:	7ae2                	ld	s5,56(sp)
	ld s6, 64(sp)
 536:	6b06                	ld	s6,64(sp)
	ld s7, 72(sp)
 538:	6ba6                	ld	s7,72(sp)
	ld s8, 80(sp)
 53a:	6c46                	ld	s8,80(sp)
	ld s9, 88(sp)
 53c:	6ce6                	ld	s9,88(sp)
	ld s10, 96(sp)
 53e:	7d06                	ld	s10,96(sp)
	ld s11, 104(sp)
 540:	7da6                	ld	s11,104(sp)
	
	addi sp, sp, 104 /* Adding the stack pointer back */
 542:	06810113          	add	sp,sp,104
	ret    /* return to ra */
 546:	8082                	ret

0000000000000548 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 548:	1141                	add	sp,sp,-16
 54a:	e406                	sd	ra,8(sp)
 54c:	e022                	sd	s0,0(sp)
 54e:	0800                	add	s0,sp,16
  extern int main();
  main();
 550:	00000097          	auipc	ra,0x0
 554:	f30080e7          	jalr	-208(ra) # 480 <main>
  exit(0);
 558:	4501                	li	a0,0
 55a:	00000097          	auipc	ra,0x0
 55e:	274080e7          	jalr	628(ra) # 7ce <exit>

0000000000000562 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 562:	1141                	add	sp,sp,-16
 564:	e422                	sd	s0,8(sp)
 566:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 568:	87aa                	mv	a5,a0
 56a:	0585                	add	a1,a1,1
 56c:	0785                	add	a5,a5,1
 56e:	fff5c703          	lbu	a4,-1(a1)
 572:	fee78fa3          	sb	a4,-1(a5)
 576:	fb75                	bnez	a4,56a <strcpy+0x8>
    ;
  return os;
}
 578:	6422                	ld	s0,8(sp)
 57a:	0141                	add	sp,sp,16
 57c:	8082                	ret

000000000000057e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 57e:	1141                	add	sp,sp,-16
 580:	e422                	sd	s0,8(sp)
 582:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 584:	00054783          	lbu	a5,0(a0)
 588:	cb91                	beqz	a5,59c <strcmp+0x1e>
 58a:	0005c703          	lbu	a4,0(a1)
 58e:	00f71763          	bne	a4,a5,59c <strcmp+0x1e>
    p++, q++;
 592:	0505                	add	a0,a0,1
 594:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 596:	00054783          	lbu	a5,0(a0)
 59a:	fbe5                	bnez	a5,58a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 59c:	0005c503          	lbu	a0,0(a1)
}
 5a0:	40a7853b          	subw	a0,a5,a0
 5a4:	6422                	ld	s0,8(sp)
 5a6:	0141                	add	sp,sp,16
 5a8:	8082                	ret

00000000000005aa <strlen>:

uint
strlen(const char *s)
{
 5aa:	1141                	add	sp,sp,-16
 5ac:	e422                	sd	s0,8(sp)
 5ae:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5b0:	00054783          	lbu	a5,0(a0)
 5b4:	cf91                	beqz	a5,5d0 <strlen+0x26>
 5b6:	0505                	add	a0,a0,1
 5b8:	87aa                	mv	a5,a0
 5ba:	86be                	mv	a3,a5
 5bc:	0785                	add	a5,a5,1
 5be:	fff7c703          	lbu	a4,-1(a5)
 5c2:	ff65                	bnez	a4,5ba <strlen+0x10>
 5c4:	40a6853b          	subw	a0,a3,a0
 5c8:	2505                	addw	a0,a0,1
    ;
  return n;
}
 5ca:	6422                	ld	s0,8(sp)
 5cc:	0141                	add	sp,sp,16
 5ce:	8082                	ret
  for(n = 0; s[n]; n++)
 5d0:	4501                	li	a0,0
 5d2:	bfe5                	j	5ca <strlen+0x20>

00000000000005d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5d4:	1141                	add	sp,sp,-16
 5d6:	e422                	sd	s0,8(sp)
 5d8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5da:	ca19                	beqz	a2,5f0 <memset+0x1c>
 5dc:	87aa                	mv	a5,a0
 5de:	1602                	sll	a2,a2,0x20
 5e0:	9201                	srl	a2,a2,0x20
 5e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5ea:	0785                	add	a5,a5,1
 5ec:	fee79de3          	bne	a5,a4,5e6 <memset+0x12>
  }
  return dst;
}
 5f0:	6422                	ld	s0,8(sp)
 5f2:	0141                	add	sp,sp,16
 5f4:	8082                	ret

00000000000005f6 <strchr>:

char*
strchr(const char *s, char c)
{
 5f6:	1141                	add	sp,sp,-16
 5f8:	e422                	sd	s0,8(sp)
 5fa:	0800                	add	s0,sp,16
  for(; *s; s++)
 5fc:	00054783          	lbu	a5,0(a0)
 600:	cb99                	beqz	a5,616 <strchr+0x20>
    if(*s == c)
 602:	00f58763          	beq	a1,a5,610 <strchr+0x1a>
  for(; *s; s++)
 606:	0505                	add	a0,a0,1
 608:	00054783          	lbu	a5,0(a0)
 60c:	fbfd                	bnez	a5,602 <strchr+0xc>
      return (char*)s;
  return 0;
 60e:	4501                	li	a0,0
}
 610:	6422                	ld	s0,8(sp)
 612:	0141                	add	sp,sp,16
 614:	8082                	ret
  return 0;
 616:	4501                	li	a0,0
 618:	bfe5                	j	610 <strchr+0x1a>

000000000000061a <gets>:

char*
gets(char *buf, int max)
{
 61a:	711d                	add	sp,sp,-96
 61c:	ec86                	sd	ra,88(sp)
 61e:	e8a2                	sd	s0,80(sp)
 620:	e4a6                	sd	s1,72(sp)
 622:	e0ca                	sd	s2,64(sp)
 624:	fc4e                	sd	s3,56(sp)
 626:	f852                	sd	s4,48(sp)
 628:	f456                	sd	s5,40(sp)
 62a:	f05a                	sd	s6,32(sp)
 62c:	ec5e                	sd	s7,24(sp)
 62e:	1080                	add	s0,sp,96
 630:	8baa                	mv	s7,a0
 632:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 634:	892a                	mv	s2,a0
 636:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 638:	4aa9                	li	s5,10
 63a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 63c:	89a6                	mv	s3,s1
 63e:	2485                	addw	s1,s1,1
 640:	0344d863          	bge	s1,s4,670 <gets+0x56>
    cc = read(0, &c, 1);
 644:	4605                	li	a2,1
 646:	faf40593          	add	a1,s0,-81
 64a:	4501                	li	a0,0
 64c:	00000097          	auipc	ra,0x0
 650:	19a080e7          	jalr	410(ra) # 7e6 <read>
    if(cc < 1)
 654:	00a05e63          	blez	a0,670 <gets+0x56>
    buf[i++] = c;
 658:	faf44783          	lbu	a5,-81(s0)
 65c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 660:	01578763          	beq	a5,s5,66e <gets+0x54>
 664:	0905                	add	s2,s2,1
 666:	fd679be3          	bne	a5,s6,63c <gets+0x22>
  for(i=0; i+1 < max; ){
 66a:	89a6                	mv	s3,s1
 66c:	a011                	j	670 <gets+0x56>
 66e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 670:	99de                	add	s3,s3,s7
 672:	00098023          	sb	zero,0(s3)
  return buf;
}
 676:	855e                	mv	a0,s7
 678:	60e6                	ld	ra,88(sp)
 67a:	6446                	ld	s0,80(sp)
 67c:	64a6                	ld	s1,72(sp)
 67e:	6906                	ld	s2,64(sp)
 680:	79e2                	ld	s3,56(sp)
 682:	7a42                	ld	s4,48(sp)
 684:	7aa2                	ld	s5,40(sp)
 686:	7b02                	ld	s6,32(sp)
 688:	6be2                	ld	s7,24(sp)
 68a:	6125                	add	sp,sp,96
 68c:	8082                	ret

000000000000068e <stat>:

int
stat(const char *n, struct stat *st)
{
 68e:	1101                	add	sp,sp,-32
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	e426                	sd	s1,8(sp)
 696:	e04a                	sd	s2,0(sp)
 698:	1000                	add	s0,sp,32
 69a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 69c:	4581                	li	a1,0
 69e:	00000097          	auipc	ra,0x0
 6a2:	170080e7          	jalr	368(ra) # 80e <open>
  if(fd < 0)
 6a6:	02054563          	bltz	a0,6d0 <stat+0x42>
 6aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6ac:	85ca                	mv	a1,s2
 6ae:	00000097          	auipc	ra,0x0
 6b2:	178080e7          	jalr	376(ra) # 826 <fstat>
 6b6:	892a                	mv	s2,a0
  close(fd);
 6b8:	8526                	mv	a0,s1
 6ba:	00000097          	auipc	ra,0x0
 6be:	13c080e7          	jalr	316(ra) # 7f6 <close>
  return r;
}
 6c2:	854a                	mv	a0,s2
 6c4:	60e2                	ld	ra,24(sp)
 6c6:	6442                	ld	s0,16(sp)
 6c8:	64a2                	ld	s1,8(sp)
 6ca:	6902                	ld	s2,0(sp)
 6cc:	6105                	add	sp,sp,32
 6ce:	8082                	ret
    return -1;
 6d0:	597d                	li	s2,-1
 6d2:	bfc5                	j	6c2 <stat+0x34>

00000000000006d4 <atoi>:

int
atoi(const char *s)
{
 6d4:	1141                	add	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6da:	00054683          	lbu	a3,0(a0)
 6de:	fd06879b          	addw	a5,a3,-48
 6e2:	0ff7f793          	zext.b	a5,a5
 6e6:	4625                	li	a2,9
 6e8:	02f66863          	bltu	a2,a5,718 <atoi+0x44>
 6ec:	872a                	mv	a4,a0
  n = 0;
 6ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6f0:	0705                	add	a4,a4,1
 6f2:	0025179b          	sllw	a5,a0,0x2
 6f6:	9fa9                	addw	a5,a5,a0
 6f8:	0017979b          	sllw	a5,a5,0x1
 6fc:	9fb5                	addw	a5,a5,a3
 6fe:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 702:	00074683          	lbu	a3,0(a4)
 706:	fd06879b          	addw	a5,a3,-48
 70a:	0ff7f793          	zext.b	a5,a5
 70e:	fef671e3          	bgeu	a2,a5,6f0 <atoi+0x1c>
  return n;
}
 712:	6422                	ld	s0,8(sp)
 714:	0141                	add	sp,sp,16
 716:	8082                	ret
  n = 0;
 718:	4501                	li	a0,0
 71a:	bfe5                	j	712 <atoi+0x3e>

000000000000071c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 71c:	1141                	add	sp,sp,-16
 71e:	e422                	sd	s0,8(sp)
 720:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 722:	02b57463          	bgeu	a0,a1,74a <memmove+0x2e>
    while(n-- > 0)
 726:	00c05f63          	blez	a2,744 <memmove+0x28>
 72a:	1602                	sll	a2,a2,0x20
 72c:	9201                	srl	a2,a2,0x20
 72e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 732:	872a                	mv	a4,a0
      *dst++ = *src++;
 734:	0585                	add	a1,a1,1
 736:	0705                	add	a4,a4,1
 738:	fff5c683          	lbu	a3,-1(a1)
 73c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 740:	fee79ae3          	bne	a5,a4,734 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 744:	6422                	ld	s0,8(sp)
 746:	0141                	add	sp,sp,16
 748:	8082                	ret
    dst += n;
 74a:	00c50733          	add	a4,a0,a2
    src += n;
 74e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 750:	fec05ae3          	blez	a2,744 <memmove+0x28>
 754:	fff6079b          	addw	a5,a2,-1
 758:	1782                	sll	a5,a5,0x20
 75a:	9381                	srl	a5,a5,0x20
 75c:	fff7c793          	not	a5,a5
 760:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 762:	15fd                	add	a1,a1,-1
 764:	177d                	add	a4,a4,-1
 766:	0005c683          	lbu	a3,0(a1)
 76a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 76e:	fee79ae3          	bne	a5,a4,762 <memmove+0x46>
 772:	bfc9                	j	744 <memmove+0x28>

0000000000000774 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 774:	1141                	add	sp,sp,-16
 776:	e422                	sd	s0,8(sp)
 778:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 77a:	ca05                	beqz	a2,7aa <memcmp+0x36>
 77c:	fff6069b          	addw	a3,a2,-1
 780:	1682                	sll	a3,a3,0x20
 782:	9281                	srl	a3,a3,0x20
 784:	0685                	add	a3,a3,1
 786:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 788:	00054783          	lbu	a5,0(a0)
 78c:	0005c703          	lbu	a4,0(a1)
 790:	00e79863          	bne	a5,a4,7a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 794:	0505                	add	a0,a0,1
    p2++;
 796:	0585                	add	a1,a1,1
  while (n-- > 0) {
 798:	fed518e3          	bne	a0,a3,788 <memcmp+0x14>
  }
  return 0;
 79c:	4501                	li	a0,0
 79e:	a019                	j	7a4 <memcmp+0x30>
      return *p1 - *p2;
 7a0:	40e7853b          	subw	a0,a5,a4
}
 7a4:	6422                	ld	s0,8(sp)
 7a6:	0141                	add	sp,sp,16
 7a8:	8082                	ret
  return 0;
 7aa:	4501                	li	a0,0
 7ac:	bfe5                	j	7a4 <memcmp+0x30>

00000000000007ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7ae:	1141                	add	sp,sp,-16
 7b0:	e406                	sd	ra,8(sp)
 7b2:	e022                	sd	s0,0(sp)
 7b4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 7b6:	00000097          	auipc	ra,0x0
 7ba:	f66080e7          	jalr	-154(ra) # 71c <memmove>
}
 7be:	60a2                	ld	ra,8(sp)
 7c0:	6402                	ld	s0,0(sp)
 7c2:	0141                	add	sp,sp,16
 7c4:	8082                	ret

00000000000007c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7c6:	4885                	li	a7,1
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 7ce:	4889                	li	a7,2
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7d6:	488d                	li	a7,3
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7de:	4891                	li	a7,4
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <read>:
.global read
read:
 li a7, SYS_read
 7e6:	4895                	li	a7,5
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <write>:
.global write
write:
 li a7, SYS_write
 7ee:	48c1                	li	a7,16
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <close>:
.global close
close:
 li a7, SYS_close
 7f6:	48d5                	li	a7,21
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 7fe:	4899                	li	a7,6
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <exec>:
.global exec
exec:
 li a7, SYS_exec
 806:	489d                	li	a7,7
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <open>:
.global open
open:
 li a7, SYS_open
 80e:	48bd                	li	a7,15
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 816:	48c5                	li	a7,17
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 81e:	48c9                	li	a7,18
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 826:	48a1                	li	a7,8
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <link>:
.global link
link:
 li a7, SYS_link
 82e:	48cd                	li	a7,19
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 836:	48d1                	li	a7,20
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 83e:	48a5                	li	a7,9
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <dup>:
.global dup
dup:
 li a7, SYS_dup
 846:	48a9                	li	a7,10
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 84e:	48ad                	li	a7,11
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 856:	48b1                	li	a7,12
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 85e:	48b5                	li	a7,13
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 866:	48b9                	li	a7,14
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 86e:	1101                	add	sp,sp,-32
 870:	ec06                	sd	ra,24(sp)
 872:	e822                	sd	s0,16(sp)
 874:	1000                	add	s0,sp,32
 876:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 87a:	4605                	li	a2,1
 87c:	fef40593          	add	a1,s0,-17
 880:	00000097          	auipc	ra,0x0
 884:	f6e080e7          	jalr	-146(ra) # 7ee <write>
}
 888:	60e2                	ld	ra,24(sp)
 88a:	6442                	ld	s0,16(sp)
 88c:	6105                	add	sp,sp,32
 88e:	8082                	ret

0000000000000890 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 890:	7139                	add	sp,sp,-64
 892:	fc06                	sd	ra,56(sp)
 894:	f822                	sd	s0,48(sp)
 896:	f426                	sd	s1,40(sp)
 898:	f04a                	sd	s2,32(sp)
 89a:	ec4e                	sd	s3,24(sp)
 89c:	0080                	add	s0,sp,64
 89e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8a0:	c299                	beqz	a3,8a6 <printint+0x16>
 8a2:	0805c963          	bltz	a1,934 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8a6:	2581                	sext.w	a1,a1
  neg = 0;
 8a8:	4881                	li	a7,0
 8aa:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 8ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8b0:	2601                	sext.w	a2,a2
 8b2:	00000517          	auipc	a0,0x0
 8b6:	62e50513          	add	a0,a0,1582 # ee0 <digits>
 8ba:	883a                	mv	a6,a4
 8bc:	2705                	addw	a4,a4,1
 8be:	02c5f7bb          	remuw	a5,a1,a2
 8c2:	1782                	sll	a5,a5,0x20
 8c4:	9381                	srl	a5,a5,0x20
 8c6:	97aa                	add	a5,a5,a0
 8c8:	0007c783          	lbu	a5,0(a5)
 8cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8d0:	0005879b          	sext.w	a5,a1
 8d4:	02c5d5bb          	divuw	a1,a1,a2
 8d8:	0685                	add	a3,a3,1
 8da:	fec7f0e3          	bgeu	a5,a2,8ba <printint+0x2a>
  if(neg)
 8de:	00088c63          	beqz	a7,8f6 <printint+0x66>
    buf[i++] = '-';
 8e2:	fd070793          	add	a5,a4,-48
 8e6:	00878733          	add	a4,a5,s0
 8ea:	02d00793          	li	a5,45
 8ee:	fef70823          	sb	a5,-16(a4)
 8f2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 8f6:	02e05863          	blez	a4,926 <printint+0x96>
 8fa:	fc040793          	add	a5,s0,-64
 8fe:	00e78933          	add	s2,a5,a4
 902:	fff78993          	add	s3,a5,-1
 906:	99ba                	add	s3,s3,a4
 908:	377d                	addw	a4,a4,-1
 90a:	1702                	sll	a4,a4,0x20
 90c:	9301                	srl	a4,a4,0x20
 90e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 912:	fff94583          	lbu	a1,-1(s2)
 916:	8526                	mv	a0,s1
 918:	00000097          	auipc	ra,0x0
 91c:	f56080e7          	jalr	-170(ra) # 86e <putc>
  while(--i >= 0)
 920:	197d                	add	s2,s2,-1
 922:	ff3918e3          	bne	s2,s3,912 <printint+0x82>
}
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	74a2                	ld	s1,40(sp)
 92c:	7902                	ld	s2,32(sp)
 92e:	69e2                	ld	s3,24(sp)
 930:	6121                	add	sp,sp,64
 932:	8082                	ret
    x = -xx;
 934:	40b005bb          	negw	a1,a1
    neg = 1;
 938:	4885                	li	a7,1
    x = -xx;
 93a:	bf85                	j	8aa <printint+0x1a>

000000000000093c <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 93c:	711d                	add	sp,sp,-96
 93e:	ec86                	sd	ra,88(sp)
 940:	e8a2                	sd	s0,80(sp)
 942:	e4a6                	sd	s1,72(sp)
 944:	e0ca                	sd	s2,64(sp)
 946:	fc4e                	sd	s3,56(sp)
 948:	f852                	sd	s4,48(sp)
 94a:	f456                	sd	s5,40(sp)
 94c:	f05a                	sd	s6,32(sp)
 94e:	ec5e                	sd	s7,24(sp)
 950:	e862                	sd	s8,16(sp)
 952:	e466                	sd	s9,8(sp)
 954:	e06a                	sd	s10,0(sp)
 956:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 958:	0005c903          	lbu	s2,0(a1)
 95c:	28090963          	beqz	s2,bee <vprintf+0x2b2>
 960:	8b2a                	mv	s6,a0
 962:	8a2e                	mv	s4,a1
 964:	8bb2                	mv	s7,a2
  state = 0;
 966:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 968:	4481                	li	s1,0
 96a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 96c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 970:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 974:	06c00c93          	li	s9,108
 978:	a015                	j	99c <vprintf+0x60>
        putc(fd, c0);
 97a:	85ca                	mv	a1,s2
 97c:	855a                	mv	a0,s6
 97e:	00000097          	auipc	ra,0x0
 982:	ef0080e7          	jalr	-272(ra) # 86e <putc>
 986:	a019                	j	98c <vprintf+0x50>
    } else if(state == '%'){
 988:	03598263          	beq	s3,s5,9ac <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 98c:	2485                	addw	s1,s1,1
 98e:	8726                	mv	a4,s1
 990:	009a07b3          	add	a5,s4,s1
 994:	0007c903          	lbu	s2,0(a5)
 998:	24090b63          	beqz	s2,bee <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 99c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9a0:	fe0994e3          	bnez	s3,988 <vprintf+0x4c>
      if(c0 == '%'){
 9a4:	fd579be3          	bne	a5,s5,97a <vprintf+0x3e>
        state = '%';
 9a8:	89be                	mv	s3,a5
 9aa:	b7cd                	j	98c <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 9ac:	cbc9                	beqz	a5,a3e <vprintf+0x102>
 9ae:	00ea06b3          	add	a3,s4,a4
 9b2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 9b6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 9b8:	c681                	beqz	a3,9c0 <vprintf+0x84>
 9ba:	9752                	add	a4,a4,s4
 9bc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9c0:	05878163          	beq	a5,s8,a02 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 9c4:	05978d63          	beq	a5,s9,a1e <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9c8:	07500713          	li	a4,117
 9cc:	10e78163          	beq	a5,a4,ace <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9d0:	07800713          	li	a4,120
 9d4:	14e78963          	beq	a5,a4,b26 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9d8:	07000713          	li	a4,112
 9dc:	18e78263          	beq	a5,a4,b60 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9e0:	07300713          	li	a4,115
 9e4:	1ce78663          	beq	a5,a4,bb0 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9e8:	02500713          	li	a4,37
 9ec:	04e79963          	bne	a5,a4,a3e <vprintf+0x102>
        putc(fd, '%');
 9f0:	02500593          	li	a1,37
 9f4:	855a                	mv	a0,s6
 9f6:	00000097          	auipc	ra,0x0
 9fa:	e78080e7          	jalr	-392(ra) # 86e <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9fe:	4981                	li	s3,0
 a00:	b771                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 a02:	008b8913          	add	s2,s7,8
 a06:	4685                	li	a3,1
 a08:	4629                	li	a2,10
 a0a:	000ba583          	lw	a1,0(s7)
 a0e:	855a                	mv	a0,s6
 a10:	00000097          	auipc	ra,0x0
 a14:	e80080e7          	jalr	-384(ra) # 890 <printint>
 a18:	8bca                	mv	s7,s2
      state = 0;
 a1a:	4981                	li	s3,0
 a1c:	bf85                	j	98c <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 a1e:	06400793          	li	a5,100
 a22:	02f68d63          	beq	a3,a5,a5c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a26:	06c00793          	li	a5,108
 a2a:	04f68863          	beq	a3,a5,a7a <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 a2e:	07500793          	li	a5,117
 a32:	0af68c63          	beq	a3,a5,aea <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 a36:	07800793          	li	a5,120
 a3a:	10f68463          	beq	a3,a5,b42 <vprintf+0x206>
        putc(fd, '%');
 a3e:	02500593          	li	a1,37
 a42:	855a                	mv	a0,s6
 a44:	00000097          	auipc	ra,0x0
 a48:	e2a080e7          	jalr	-470(ra) # 86e <putc>
        putc(fd, c0);
 a4c:	85ca                	mv	a1,s2
 a4e:	855a                	mv	a0,s6
 a50:	00000097          	auipc	ra,0x0
 a54:	e1e080e7          	jalr	-482(ra) # 86e <putc>
      state = 0;
 a58:	4981                	li	s3,0
 a5a:	bf0d                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a5c:	008b8913          	add	s2,s7,8
 a60:	4685                	li	a3,1
 a62:	4629                	li	a2,10
 a64:	000ba583          	lw	a1,0(s7)
 a68:	855a                	mv	a0,s6
 a6a:	00000097          	auipc	ra,0x0
 a6e:	e26080e7          	jalr	-474(ra) # 890 <printint>
        i += 1;
 a72:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a74:	8bca                	mv	s7,s2
      state = 0;
 a76:	4981                	li	s3,0
        i += 1;
 a78:	bf11                	j	98c <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a7a:	06400793          	li	a5,100
 a7e:	02f60963          	beq	a2,a5,ab0 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a82:	07500793          	li	a5,117
 a86:	08f60163          	beq	a2,a5,b08 <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a8a:	07800793          	li	a5,120
 a8e:	faf618e3          	bne	a2,a5,a3e <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a92:	008b8913          	add	s2,s7,8
 a96:	4681                	li	a3,0
 a98:	4641                	li	a2,16
 a9a:	000ba583          	lw	a1,0(s7)
 a9e:	855a                	mv	a0,s6
 aa0:	00000097          	auipc	ra,0x0
 aa4:	df0080e7          	jalr	-528(ra) # 890 <printint>
        i += 2;
 aa8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 aaa:	8bca                	mv	s7,s2
      state = 0;
 aac:	4981                	li	s3,0
        i += 2;
 aae:	bdf9                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 ab0:	008b8913          	add	s2,s7,8
 ab4:	4685                	li	a3,1
 ab6:	4629                	li	a2,10
 ab8:	000ba583          	lw	a1,0(s7)
 abc:	855a                	mv	a0,s6
 abe:	00000097          	auipc	ra,0x0
 ac2:	dd2080e7          	jalr	-558(ra) # 890 <printint>
        i += 2;
 ac6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 ac8:	8bca                	mv	s7,s2
      state = 0;
 aca:	4981                	li	s3,0
        i += 2;
 acc:	b5c1                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 ace:	008b8913          	add	s2,s7,8
 ad2:	4681                	li	a3,0
 ad4:	4629                	li	a2,10
 ad6:	000ba583          	lw	a1,0(s7)
 ada:	855a                	mv	a0,s6
 adc:	00000097          	auipc	ra,0x0
 ae0:	db4080e7          	jalr	-588(ra) # 890 <printint>
 ae4:	8bca                	mv	s7,s2
      state = 0;
 ae6:	4981                	li	s3,0
 ae8:	b555                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 aea:	008b8913          	add	s2,s7,8
 aee:	4681                	li	a3,0
 af0:	4629                	li	a2,10
 af2:	000ba583          	lw	a1,0(s7)
 af6:	855a                	mv	a0,s6
 af8:	00000097          	auipc	ra,0x0
 afc:	d98080e7          	jalr	-616(ra) # 890 <printint>
        i += 1;
 b00:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b02:	8bca                	mv	s7,s2
      state = 0;
 b04:	4981                	li	s3,0
        i += 1;
 b06:	b559                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b08:	008b8913          	add	s2,s7,8
 b0c:	4681                	li	a3,0
 b0e:	4629                	li	a2,10
 b10:	000ba583          	lw	a1,0(s7)
 b14:	855a                	mv	a0,s6
 b16:	00000097          	auipc	ra,0x0
 b1a:	d7a080e7          	jalr	-646(ra) # 890 <printint>
        i += 2;
 b1e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b20:	8bca                	mv	s7,s2
      state = 0;
 b22:	4981                	li	s3,0
        i += 2;
 b24:	b5a5                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 b26:	008b8913          	add	s2,s7,8
 b2a:	4681                	li	a3,0
 b2c:	4641                	li	a2,16
 b2e:	000ba583          	lw	a1,0(s7)
 b32:	855a                	mv	a0,s6
 b34:	00000097          	auipc	ra,0x0
 b38:	d5c080e7          	jalr	-676(ra) # 890 <printint>
 b3c:	8bca                	mv	s7,s2
      state = 0;
 b3e:	4981                	li	s3,0
 b40:	b5b1                	j	98c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b42:	008b8913          	add	s2,s7,8
 b46:	4681                	li	a3,0
 b48:	4641                	li	a2,16
 b4a:	000ba583          	lw	a1,0(s7)
 b4e:	855a                	mv	a0,s6
 b50:	00000097          	auipc	ra,0x0
 b54:	d40080e7          	jalr	-704(ra) # 890 <printint>
        i += 1;
 b58:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b5a:	8bca                	mv	s7,s2
      state = 0;
 b5c:	4981                	li	s3,0
        i += 1;
 b5e:	b53d                	j	98c <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 b60:	008b8d13          	add	s10,s7,8
 b64:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b68:	03000593          	li	a1,48
 b6c:	855a                	mv	a0,s6
 b6e:	00000097          	auipc	ra,0x0
 b72:	d00080e7          	jalr	-768(ra) # 86e <putc>
  putc(fd, 'x');
 b76:	07800593          	li	a1,120
 b7a:	855a                	mv	a0,s6
 b7c:	00000097          	auipc	ra,0x0
 b80:	cf2080e7          	jalr	-782(ra) # 86e <putc>
 b84:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b86:	00000b97          	auipc	s7,0x0
 b8a:	35ab8b93          	add	s7,s7,858 # ee0 <digits>
 b8e:	03c9d793          	srl	a5,s3,0x3c
 b92:	97de                	add	a5,a5,s7
 b94:	0007c583          	lbu	a1,0(a5)
 b98:	855a                	mv	a0,s6
 b9a:	00000097          	auipc	ra,0x0
 b9e:	cd4080e7          	jalr	-812(ra) # 86e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ba2:	0992                	sll	s3,s3,0x4
 ba4:	397d                	addw	s2,s2,-1
 ba6:	fe0914e3          	bnez	s2,b8e <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 baa:	8bea                	mv	s7,s10
      state = 0;
 bac:	4981                	li	s3,0
 bae:	bbf9                	j	98c <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 bb0:	008b8993          	add	s3,s7,8
 bb4:	000bb903          	ld	s2,0(s7)
 bb8:	02090163          	beqz	s2,bda <vprintf+0x29e>
        for(; *s; s++)
 bbc:	00094583          	lbu	a1,0(s2)
 bc0:	c585                	beqz	a1,be8 <vprintf+0x2ac>
          putc(fd, *s);
 bc2:	855a                	mv	a0,s6
 bc4:	00000097          	auipc	ra,0x0
 bc8:	caa080e7          	jalr	-854(ra) # 86e <putc>
        for(; *s; s++)
 bcc:	0905                	add	s2,s2,1
 bce:	00094583          	lbu	a1,0(s2)
 bd2:	f9e5                	bnez	a1,bc2 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 bd4:	8bce                	mv	s7,s3
      state = 0;
 bd6:	4981                	li	s3,0
 bd8:	bb55                	j	98c <vprintf+0x50>
          s = "(null)";
 bda:	00000917          	auipc	s2,0x0
 bde:	2fe90913          	add	s2,s2,766 # ed8 <malloc+0x1e8>
        for(; *s; s++)
 be2:	02800593          	li	a1,40
 be6:	bff1                	j	bc2 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 be8:	8bce                	mv	s7,s3
      state = 0;
 bea:	4981                	li	s3,0
 bec:	b345                	j	98c <vprintf+0x50>
    }
  }
}
 bee:	60e6                	ld	ra,88(sp)
 bf0:	6446                	ld	s0,80(sp)
 bf2:	64a6                	ld	s1,72(sp)
 bf4:	6906                	ld	s2,64(sp)
 bf6:	79e2                	ld	s3,56(sp)
 bf8:	7a42                	ld	s4,48(sp)
 bfa:	7aa2                	ld	s5,40(sp)
 bfc:	7b02                	ld	s6,32(sp)
 bfe:	6be2                	ld	s7,24(sp)
 c00:	6c42                	ld	s8,16(sp)
 c02:	6ca2                	ld	s9,8(sp)
 c04:	6d02                	ld	s10,0(sp)
 c06:	6125                	add	sp,sp,96
 c08:	8082                	ret

0000000000000c0a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c0a:	715d                	add	sp,sp,-80
 c0c:	ec06                	sd	ra,24(sp)
 c0e:	e822                	sd	s0,16(sp)
 c10:	1000                	add	s0,sp,32
 c12:	e010                	sd	a2,0(s0)
 c14:	e414                	sd	a3,8(s0)
 c16:	e818                	sd	a4,16(s0)
 c18:	ec1c                	sd	a5,24(s0)
 c1a:	03043023          	sd	a6,32(s0)
 c1e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c22:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c26:	8622                	mv	a2,s0
 c28:	00000097          	auipc	ra,0x0
 c2c:	d14080e7          	jalr	-748(ra) # 93c <vprintf>
}
 c30:	60e2                	ld	ra,24(sp)
 c32:	6442                	ld	s0,16(sp)
 c34:	6161                	add	sp,sp,80
 c36:	8082                	ret

0000000000000c38 <printf>:

void
printf(const char *fmt, ...)
{
 c38:	711d                	add	sp,sp,-96
 c3a:	ec06                	sd	ra,24(sp)
 c3c:	e822                	sd	s0,16(sp)
 c3e:	1000                	add	s0,sp,32
 c40:	e40c                	sd	a1,8(s0)
 c42:	e810                	sd	a2,16(s0)
 c44:	ec14                	sd	a3,24(s0)
 c46:	f018                	sd	a4,32(s0)
 c48:	f41c                	sd	a5,40(s0)
 c4a:	03043823          	sd	a6,48(s0)
 c4e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c52:	00840613          	add	a2,s0,8
 c56:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c5a:	85aa                	mv	a1,a0
 c5c:	4505                	li	a0,1
 c5e:	00000097          	auipc	ra,0x0
 c62:	cde080e7          	jalr	-802(ra) # 93c <vprintf>
}
 c66:	60e2                	ld	ra,24(sp)
 c68:	6442                	ld	s0,16(sp)
 c6a:	6125                	add	sp,sp,96
 c6c:	8082                	ret

0000000000000c6e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c6e:	1141                	add	sp,sp,-16
 c70:	e422                	sd	s0,8(sp)
 c72:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c74:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c78:	00000797          	auipc	a5,0x0
 c7c:	2a87b783          	ld	a5,680(a5) # f20 <freep>
 c80:	a02d                	j	caa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c82:	4618                	lw	a4,8(a2)
 c84:	9f2d                	addw	a4,a4,a1
 c86:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c8a:	6398                	ld	a4,0(a5)
 c8c:	6310                	ld	a2,0(a4)
 c8e:	a83d                	j	ccc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c90:	ff852703          	lw	a4,-8(a0)
 c94:	9f31                	addw	a4,a4,a2
 c96:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c98:	ff053683          	ld	a3,-16(a0)
 c9c:	a091                	j	ce0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c9e:	6398                	ld	a4,0(a5)
 ca0:	00e7e463          	bltu	a5,a4,ca8 <free+0x3a>
 ca4:	00e6ea63          	bltu	a3,a4,cb8 <free+0x4a>
{
 ca8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 caa:	fed7fae3          	bgeu	a5,a3,c9e <free+0x30>
 cae:	6398                	ld	a4,0(a5)
 cb0:	00e6e463          	bltu	a3,a4,cb8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cb4:	fee7eae3          	bltu	a5,a4,ca8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 cb8:	ff852583          	lw	a1,-8(a0)
 cbc:	6390                	ld	a2,0(a5)
 cbe:	02059813          	sll	a6,a1,0x20
 cc2:	01c85713          	srl	a4,a6,0x1c
 cc6:	9736                	add	a4,a4,a3
 cc8:	fae60de3          	beq	a2,a4,c82 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ccc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 cd0:	4790                	lw	a2,8(a5)
 cd2:	02061593          	sll	a1,a2,0x20
 cd6:	01c5d713          	srl	a4,a1,0x1c
 cda:	973e                	add	a4,a4,a5
 cdc:	fae68ae3          	beq	a3,a4,c90 <free+0x22>
    p->s.ptr = bp->s.ptr;
 ce0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ce2:	00000717          	auipc	a4,0x0
 ce6:	22f73f23          	sd	a5,574(a4) # f20 <freep>
}
 cea:	6422                	ld	s0,8(sp)
 cec:	0141                	add	sp,sp,16
 cee:	8082                	ret

0000000000000cf0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cf0:	7139                	add	sp,sp,-64
 cf2:	fc06                	sd	ra,56(sp)
 cf4:	f822                	sd	s0,48(sp)
 cf6:	f426                	sd	s1,40(sp)
 cf8:	f04a                	sd	s2,32(sp)
 cfa:	ec4e                	sd	s3,24(sp)
 cfc:	e852                	sd	s4,16(sp)
 cfe:	e456                	sd	s5,8(sp)
 d00:	e05a                	sd	s6,0(sp)
 d02:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d04:	02051493          	sll	s1,a0,0x20
 d08:	9081                	srl	s1,s1,0x20
 d0a:	04bd                	add	s1,s1,15
 d0c:	8091                	srl	s1,s1,0x4
 d0e:	0014899b          	addw	s3,s1,1
 d12:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 d14:	00000517          	auipc	a0,0x0
 d18:	20c53503          	ld	a0,524(a0) # f20 <freep>
 d1c:	c515                	beqz	a0,d48 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d1e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d20:	4798                	lw	a4,8(a5)
 d22:	02977f63          	bgeu	a4,s1,d60 <malloc+0x70>
  if(nu < 4096)
 d26:	8a4e                	mv	s4,s3
 d28:	0009871b          	sext.w	a4,s3
 d2c:	6685                	lui	a3,0x1
 d2e:	00d77363          	bgeu	a4,a3,d34 <malloc+0x44>
 d32:	6a05                	lui	s4,0x1
 d34:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d38:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d3c:	00000917          	auipc	s2,0x0
 d40:	1e490913          	add	s2,s2,484 # f20 <freep>
  if(p == (char*)-1)
 d44:	5afd                	li	s5,-1
 d46:	a895                	j	dba <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 d48:	00009797          	auipc	a5,0x9
 d4c:	b8078793          	add	a5,a5,-1152 # 98c8 <base>
 d50:	00000717          	auipc	a4,0x0
 d54:	1cf73823          	sd	a5,464(a4) # f20 <freep>
 d58:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d5a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d5e:	b7e1                	j	d26 <malloc+0x36>
      if(p->s.size == nunits)
 d60:	02e48c63          	beq	s1,a4,d98 <malloc+0xa8>
        p->s.size -= nunits;
 d64:	4137073b          	subw	a4,a4,s3
 d68:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d6a:	02071693          	sll	a3,a4,0x20
 d6e:	01c6d713          	srl	a4,a3,0x1c
 d72:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d74:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d78:	00000717          	auipc	a4,0x0
 d7c:	1aa73423          	sd	a0,424(a4) # f20 <freep>
      return (void*)(p + 1);
 d80:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d84:	70e2                	ld	ra,56(sp)
 d86:	7442                	ld	s0,48(sp)
 d88:	74a2                	ld	s1,40(sp)
 d8a:	7902                	ld	s2,32(sp)
 d8c:	69e2                	ld	s3,24(sp)
 d8e:	6a42                	ld	s4,16(sp)
 d90:	6aa2                	ld	s5,8(sp)
 d92:	6b02                	ld	s6,0(sp)
 d94:	6121                	add	sp,sp,64
 d96:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 d98:	6398                	ld	a4,0(a5)
 d9a:	e118                	sd	a4,0(a0)
 d9c:	bff1                	j	d78 <malloc+0x88>
  hp->s.size = nu;
 d9e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 da2:	0541                	add	a0,a0,16
 da4:	00000097          	auipc	ra,0x0
 da8:	eca080e7          	jalr	-310(ra) # c6e <free>
  return freep;
 dac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 db0:	d971                	beqz	a0,d84 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 db4:	4798                	lw	a4,8(a5)
 db6:	fa9775e3          	bgeu	a4,s1,d60 <malloc+0x70>
    if(p == freep)
 dba:	00093703          	ld	a4,0(s2)
 dbe:	853e                	mv	a0,a5
 dc0:	fef719e3          	bne	a4,a5,db2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 dc4:	8552                	mv	a0,s4
 dc6:	00000097          	auipc	ra,0x0
 dca:	a90080e7          	jalr	-1392(ra) # 856 <sbrk>
  if(p == (char*)-1)
 dce:	fd5518e3          	bne	a0,s5,d9e <malloc+0xae>
        return 0;
 dd2:	4501                	li	a0,0
 dd4:	bf45                	j	d84 <malloc+0x94>
