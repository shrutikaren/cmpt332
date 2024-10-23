
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91010113          	add	sp,sp,-1776 # 80008910 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

/* ask each hart to generate timer interrupts. */
void
timerinit()
{
    8000001c:	1141                	add	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	add	s0,sp,16
#define MIE_STIE (1L << 5)  /* supervisor timer */
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  /* enable supervisor-mode timer interrupts. */
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	or	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  /* asm volatile("csrr %0, menvcfg" : "=r" (x) ); */
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  /* enable the sstc extension (i.e. stimecmp). */
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	sll	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  /* asm volatile("csrw menvcfg, %0" : : "r" (x)); */
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  /* allow supervisor to use stimecmp and time. */
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	or	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
/* machine-mode cycle counter */
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  /* ask for the very first timer interrupt. */
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	add	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	add	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcbbf>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	eec78793          	add	a5,a5,-276 # 80000f6c <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srl	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	00000097          	auipc	ra,0x0
    800000bc:	f64080e7          	jalr	-156(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	add	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
/* */
/* user write()s to the console go here. */
/* */
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	715d                	add	sp,sp,-80
    800000d6:	e486                	sd	ra,72(sp)
    800000d8:	e0a2                	sd	s0,64(sp)
    800000da:	fc26                	sd	s1,56(sp)
    800000dc:	f84a                	sd	s2,48(sp)
    800000de:	f44e                	sd	s3,40(sp)
    800000e0:	f052                	sd	s4,32(sp)
    800000e2:	ec56                	sd	s5,24(sp)
    800000e4:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e6:	04c05763          	blez	a2,80000134 <consolewrite+0x60>
    800000ea:	8a2a                	mv	s4,a0
    800000ec:	84ae                	mv	s1,a1
    800000ee:	89b2                	mv	s3,a2
    800000f0:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000f2:	5afd                	li	s5,-1
    800000f4:	4685                	li	a3,1
    800000f6:	8626                	mv	a2,s1
    800000f8:	85d2                	mv	a1,s4
    800000fa:	fbf40513          	add	a0,s0,-65
    800000fe:	00002097          	auipc	ra,0x2
    80000102:	524080e7          	jalr	1316(ra) # 80002622 <either_copyin>
    80000106:	01550d63          	beq	a0,s5,80000120 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000010a:	fbf44503          	lbu	a0,-65(s0)
    8000010e:	00001097          	auipc	ra,0x1
    80000112:	8a6080e7          	jalr	-1882(ra) # 800009b4 <uartputc>
  for(i = 0; i < n; i++){
    80000116:	2905                	addw	s2,s2,1
    80000118:	0485                	add	s1,s1,1
    8000011a:	fd299de3          	bne	s3,s2,800000f4 <consolewrite+0x20>
    8000011e:	894e                	mv	s2,s3
  }

  return i;
}
    80000120:	854a                	mv	a0,s2
    80000122:	60a6                	ld	ra,72(sp)
    80000124:	6406                	ld	s0,64(sp)
    80000126:	74e2                	ld	s1,56(sp)
    80000128:	7942                	ld	s2,48(sp)
    8000012a:	79a2                	ld	s3,40(sp)
    8000012c:	7a02                	ld	s4,32(sp)
    8000012e:	6ae2                	ld	s5,24(sp)
    80000130:	6161                	add	sp,sp,80
    80000132:	8082                	ret
  for(i = 0; i < n; i++){
    80000134:	4901                	li	s2,0
    80000136:	b7ed                	j	80000120 <consolewrite+0x4c>

0000000080000138 <consoleread>:
/* user_dist indicates whether dst is a user */
/* or kernel address. */
/* */
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000138:	711d                	add	sp,sp,-96
    8000013a:	ec86                	sd	ra,88(sp)
    8000013c:	e8a2                	sd	s0,80(sp)
    8000013e:	e4a6                	sd	s1,72(sp)
    80000140:	e0ca                	sd	s2,64(sp)
    80000142:	fc4e                	sd	s3,56(sp)
    80000144:	f852                	sd	s4,48(sp)
    80000146:	f456                	sd	s5,40(sp)
    80000148:	f05a                	sd	s6,32(sp)
    8000014a:	ec5e                	sd	s7,24(sp)
    8000014c:	1080                	add	s0,sp,96
    8000014e:	8aaa                	mv	s5,a0
    80000150:	8a2e                	mv	s4,a1
    80000152:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000154:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000158:	00010517          	auipc	a0,0x10
    8000015c:	7b850513          	add	a0,a0,1976 # 80010910 <cons>
    80000160:	00001097          	auipc	ra,0x1
    80000164:	b6c080e7          	jalr	-1172(ra) # 80000ccc <acquire>
  while(n > 0){
    /* wait until interrupt handler has put some */
    /* input into cons.buffer. */
    while(cons.r == cons.w){
    80000168:	00010497          	auipc	s1,0x10
    8000016c:	7a848493          	add	s1,s1,1960 # 80010910 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000170:	00011917          	auipc	s2,0x11
    80000174:	83890913          	add	s2,s2,-1992 # 800109a8 <cons+0x98>
  while(n > 0){
    80000178:	09305263          	blez	s3,800001fc <consoleread+0xc4>
    while(cons.r == cons.w){
    8000017c:	0984a783          	lw	a5,152(s1)
    80000180:	09c4a703          	lw	a4,156(s1)
    80000184:	02f71763          	bne	a4,a5,800001b2 <consoleread+0x7a>
      if(killed(myproc())){
    80000188:	00002097          	auipc	ra,0x2
    8000018c:	970080e7          	jalr	-1680(ra) # 80001af8 <myproc>
    80000190:	00002097          	auipc	ra,0x2
    80000194:	2dc080e7          	jalr	732(ra) # 8000246c <killed>
    80000198:	ed2d                	bnez	a0,80000212 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    8000019a:	85a6                	mv	a1,s1
    8000019c:	854a                	mv	a0,s2
    8000019e:	00002097          	auipc	ra,0x2
    800001a2:	026080e7          	jalr	38(ra) # 800021c4 <sleep>
    while(cons.r == cons.w){
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	fcf70de3          	beq	a4,a5,80000188 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001b2:	00010717          	auipc	a4,0x10
    800001b6:	75e70713          	add	a4,a4,1886 # 80010910 <cons>
    800001ba:	0017869b          	addw	a3,a5,1
    800001be:	08d72c23          	sw	a3,152(a4)
    800001c2:	07f7f693          	and	a3,a5,127
    800001c6:	9736                	add	a4,a4,a3
    800001c8:	01874703          	lbu	a4,24(a4)
    800001cc:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  /* end-of-file */
    800001d0:	4691                	li	a3,4
    800001d2:	06db8463          	beq	s7,a3,8000023a <consoleread+0x102>
      }
      break;
    }

    /* copy the input byte to the user-space buffer. */
    cbuf = c;
    800001d6:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001da:	4685                	li	a3,1
    800001dc:	faf40613          	add	a2,s0,-81
    800001e0:	85d2                	mv	a1,s4
    800001e2:	8556                	mv	a0,s5
    800001e4:	00002097          	auipc	ra,0x2
    800001e8:	3e8080e7          	jalr	1000(ra) # 800025cc <either_copyout>
    800001ec:	57fd                	li	a5,-1
    800001ee:	00f50763          	beq	a0,a5,800001fc <consoleread+0xc4>
      break;

    dst++;
    800001f2:	0a05                	add	s4,s4,1
    --n;
    800001f4:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    800001f6:	47a9                	li	a5,10
    800001f8:	f8fb90e3          	bne	s7,a5,80000178 <consoleread+0x40>
      /* a whole line has arrived, return to */
      /* the user-level read(). */
      break;
    }
  }
  release(&cons.lock);
    800001fc:	00010517          	auipc	a0,0x10
    80000200:	71450513          	add	a0,a0,1812 # 80010910 <cons>
    80000204:	00001097          	auipc	ra,0x1
    80000208:	b7c080e7          	jalr	-1156(ra) # 80000d80 <release>

  return target - n;
    8000020c:	413b053b          	subw	a0,s6,s3
    80000210:	a811                	j	80000224 <consoleread+0xec>
        release(&cons.lock);
    80000212:	00010517          	auipc	a0,0x10
    80000216:	6fe50513          	add	a0,a0,1790 # 80010910 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	b66080e7          	jalr	-1178(ra) # 80000d80 <release>
        return -1;
    80000222:	557d                	li	a0,-1
}
    80000224:	60e6                	ld	ra,88(sp)
    80000226:	6446                	ld	s0,80(sp)
    80000228:	64a6                	ld	s1,72(sp)
    8000022a:	6906                	ld	s2,64(sp)
    8000022c:	79e2                	ld	s3,56(sp)
    8000022e:	7a42                	ld	s4,48(sp)
    80000230:	7aa2                	ld	s5,40(sp)
    80000232:	7b02                	ld	s6,32(sp)
    80000234:	6be2                	ld	s7,24(sp)
    80000236:	6125                	add	sp,sp,96
    80000238:	8082                	ret
      if(n < target){
    8000023a:	0009871b          	sext.w	a4,s3
    8000023e:	fb677fe3          	bgeu	a4,s6,800001fc <consoleread+0xc4>
        cons.r--;
    80000242:	00010717          	auipc	a4,0x10
    80000246:	76f72323          	sw	a5,1894(a4) # 800109a8 <cons+0x98>
    8000024a:	bf4d                	j	800001fc <consoleread+0xc4>

000000008000024c <consputc>:
{
    8000024c:	1141                	add	sp,sp,-16
    8000024e:	e406                	sd	ra,8(sp)
    80000250:	e022                	sd	s0,0(sp)
    80000252:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80000254:	10000793          	li	a5,256
    80000258:	00f50a63          	beq	a0,a5,8000026c <consputc+0x20>
    uartputc_sync(c);
    8000025c:	00000097          	auipc	ra,0x0
    80000260:	676080e7          	jalr	1654(ra) # 800008d2 <uartputc_sync>
}
    80000264:	60a2                	ld	ra,8(sp)
    80000266:	6402                	ld	s0,0(sp)
    80000268:	0141                	add	sp,sp,16
    8000026a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000026c:	4521                	li	a0,8
    8000026e:	00000097          	auipc	ra,0x0
    80000272:	664080e7          	jalr	1636(ra) # 800008d2 <uartputc_sync>
    80000276:	02000513          	li	a0,32
    8000027a:	00000097          	auipc	ra,0x0
    8000027e:	658080e7          	jalr	1624(ra) # 800008d2 <uartputc_sync>
    80000282:	4521                	li	a0,8
    80000284:	00000097          	auipc	ra,0x0
    80000288:	64e080e7          	jalr	1614(ra) # 800008d2 <uartputc_sync>
    8000028c:	bfe1                	j	80000264 <consputc+0x18>

000000008000028e <consoleintr>:
/* do erase/kill processing, append to cons.buf, */
/* wake up consoleread() if a whole line has arrived. */
/* */
void
consoleintr(int c)
{
    8000028e:	1101                	add	sp,sp,-32
    80000290:	ec06                	sd	ra,24(sp)
    80000292:	e822                	sd	s0,16(sp)
    80000294:	e426                	sd	s1,8(sp)
    80000296:	e04a                	sd	s2,0(sp)
    80000298:	1000                	add	s0,sp,32
    8000029a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000029c:	00010517          	auipc	a0,0x10
    800002a0:	67450513          	add	a0,a0,1652 # 80010910 <cons>
    800002a4:	00001097          	auipc	ra,0x1
    800002a8:	a28080e7          	jalr	-1496(ra) # 80000ccc <acquire>

  switch(c){
    800002ac:	47d5                	li	a5,21
    800002ae:	0af48663          	beq	s1,a5,8000035a <consoleintr+0xcc>
    800002b2:	0297ca63          	blt	a5,s1,800002e6 <consoleintr+0x58>
    800002b6:	47a1                	li	a5,8
    800002b8:	0ef48763          	beq	s1,a5,800003a6 <consoleintr+0x118>
    800002bc:	47c1                	li	a5,16
    800002be:	10f49a63          	bne	s1,a5,800003d2 <consoleintr+0x144>
  case C('P'):  /* Print process list. */
    procdump();
    800002c2:	00002097          	auipc	ra,0x2
    800002c6:	3b6080e7          	jalr	950(ra) # 80002678 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002ca:	00010517          	auipc	a0,0x10
    800002ce:	64650513          	add	a0,a0,1606 # 80010910 <cons>
    800002d2:	00001097          	auipc	ra,0x1
    800002d6:	aae080e7          	jalr	-1362(ra) # 80000d80 <release>
}
    800002da:	60e2                	ld	ra,24(sp)
    800002dc:	6442                	ld	s0,16(sp)
    800002de:	64a2                	ld	s1,8(sp)
    800002e0:	6902                	ld	s2,0(sp)
    800002e2:	6105                	add	sp,sp,32
    800002e4:	8082                	ret
  switch(c){
    800002e6:	07f00793          	li	a5,127
    800002ea:	0af48e63          	beq	s1,a5,800003a6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002ee:	00010717          	auipc	a4,0x10
    800002f2:	62270713          	add	a4,a4,1570 # 80010910 <cons>
    800002f6:	0a072783          	lw	a5,160(a4)
    800002fa:	09872703          	lw	a4,152(a4)
    800002fe:	9f99                	subw	a5,a5,a4
    80000300:	07f00713          	li	a4,127
    80000304:	fcf763e3          	bltu	a4,a5,800002ca <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000308:	47b5                	li	a5,13
    8000030a:	0cf48763          	beq	s1,a5,800003d8 <consoleintr+0x14a>
      consputc(c);
    8000030e:	8526                	mv	a0,s1
    80000310:	00000097          	auipc	ra,0x0
    80000314:	f3c080e7          	jalr	-196(ra) # 8000024c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000318:	00010797          	auipc	a5,0x10
    8000031c:	5f878793          	add	a5,a5,1528 # 80010910 <cons>
    80000320:	0a07a683          	lw	a3,160(a5)
    80000324:	0016871b          	addw	a4,a3,1
    80000328:	0007061b          	sext.w	a2,a4
    8000032c:	0ae7a023          	sw	a4,160(a5)
    80000330:	07f6f693          	and	a3,a3,127
    80000334:	97b6                	add	a5,a5,a3
    80000336:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000033a:	47a9                	li	a5,10
    8000033c:	0cf48563          	beq	s1,a5,80000406 <consoleintr+0x178>
    80000340:	4791                	li	a5,4
    80000342:	0cf48263          	beq	s1,a5,80000406 <consoleintr+0x178>
    80000346:	00010797          	auipc	a5,0x10
    8000034a:	6627a783          	lw	a5,1634(a5) # 800109a8 <cons+0x98>
    8000034e:	9f1d                	subw	a4,a4,a5
    80000350:	08000793          	li	a5,128
    80000354:	f6f71be3          	bne	a4,a5,800002ca <consoleintr+0x3c>
    80000358:	a07d                	j	80000406 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000035a:	00010717          	auipc	a4,0x10
    8000035e:	5b670713          	add	a4,a4,1462 # 80010910 <cons>
    80000362:	0a072783          	lw	a5,160(a4)
    80000366:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000036a:	00010497          	auipc	s1,0x10
    8000036e:	5a648493          	add	s1,s1,1446 # 80010910 <cons>
    while(cons.e != cons.w &&
    80000372:	4929                	li	s2,10
    80000374:	f4f70be3          	beq	a4,a5,800002ca <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000378:	37fd                	addw	a5,a5,-1
    8000037a:	07f7f713          	and	a4,a5,127
    8000037e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000380:	01874703          	lbu	a4,24(a4)
    80000384:	f52703e3          	beq	a4,s2,800002ca <consoleintr+0x3c>
      cons.e--;
    80000388:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000038c:	10000513          	li	a0,256
    80000390:	00000097          	auipc	ra,0x0
    80000394:	ebc080e7          	jalr	-324(ra) # 8000024c <consputc>
    while(cons.e != cons.w &&
    80000398:	0a04a783          	lw	a5,160(s1)
    8000039c:	09c4a703          	lw	a4,156(s1)
    800003a0:	fcf71ce3          	bne	a4,a5,80000378 <consoleintr+0xea>
    800003a4:	b71d                	j	800002ca <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003a6:	00010717          	auipc	a4,0x10
    800003aa:	56a70713          	add	a4,a4,1386 # 80010910 <cons>
    800003ae:	0a072783          	lw	a5,160(a4)
    800003b2:	09c72703          	lw	a4,156(a4)
    800003b6:	f0f70ae3          	beq	a4,a5,800002ca <consoleintr+0x3c>
      cons.e--;
    800003ba:	37fd                	addw	a5,a5,-1
    800003bc:	00010717          	auipc	a4,0x10
    800003c0:	5ef72a23          	sw	a5,1524(a4) # 800109b0 <cons+0xa0>
      consputc(BACKSPACE);
    800003c4:	10000513          	li	a0,256
    800003c8:	00000097          	auipc	ra,0x0
    800003cc:	e84080e7          	jalr	-380(ra) # 8000024c <consputc>
    800003d0:	bded                	j	800002ca <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003d2:	ee048ce3          	beqz	s1,800002ca <consoleintr+0x3c>
    800003d6:	bf21                	j	800002ee <consoleintr+0x60>
      consputc(c);
    800003d8:	4529                	li	a0,10
    800003da:	00000097          	auipc	ra,0x0
    800003de:	e72080e7          	jalr	-398(ra) # 8000024c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003e2:	00010797          	auipc	a5,0x10
    800003e6:	52e78793          	add	a5,a5,1326 # 80010910 <cons>
    800003ea:	0a07a703          	lw	a4,160(a5)
    800003ee:	0017069b          	addw	a3,a4,1
    800003f2:	0006861b          	sext.w	a2,a3
    800003f6:	0ad7a023          	sw	a3,160(a5)
    800003fa:	07f77713          	and	a4,a4,127
    800003fe:	97ba                	add	a5,a5,a4
    80000400:	4729                	li	a4,10
    80000402:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000406:	00010797          	auipc	a5,0x10
    8000040a:	5ac7a323          	sw	a2,1446(a5) # 800109ac <cons+0x9c>
        wakeup(&cons.r);
    8000040e:	00010517          	auipc	a0,0x10
    80000412:	59a50513          	add	a0,a0,1434 # 800109a8 <cons+0x98>
    80000416:	00002097          	auipc	ra,0x2
    8000041a:	e12080e7          	jalr	-494(ra) # 80002228 <wakeup>
    8000041e:	b575                	j	800002ca <consoleintr+0x3c>

0000000080000420 <consoleinit>:

void
consoleinit(void)
{
    80000420:	1141                	add	sp,sp,-16
    80000422:	e406                	sd	ra,8(sp)
    80000424:	e022                	sd	s0,0(sp)
    80000426:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80000428:	00008597          	auipc	a1,0x8
    8000042c:	be858593          	add	a1,a1,-1048 # 80008010 <etext+0x10>
    80000430:	00010517          	auipc	a0,0x10
    80000434:	4e050513          	add	a0,a0,1248 # 80010910 <cons>
    80000438:	00001097          	auipc	ra,0x1
    8000043c:	804080e7          	jalr	-2044(ra) # 80000c3c <initlock>

  uartinit();
    80000440:	00000097          	auipc	ra,0x0
    80000444:	442080e7          	jalr	1090(ra) # 80000882 <uartinit>

  /* connect read and write system calls */
  /* to consoleread and consolewrite. */
  devsw[CONSOLE].read = consoleread;
    80000448:	00020797          	auipc	a5,0x20
    8000044c:	66078793          	add	a5,a5,1632 # 80020aa8 <devsw>
    80000450:	00000717          	auipc	a4,0x0
    80000454:	ce870713          	add	a4,a4,-792 # 80000138 <consoleread>
    80000458:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000045a:	00000717          	auipc	a4,0x0
    8000045e:	c7a70713          	add	a4,a4,-902 # 800000d4 <consolewrite>
    80000462:	ef98                	sd	a4,24(a5)
}
    80000464:	60a2                	ld	ra,8(sp)
    80000466:	6402                	ld	s0,0(sp)
    80000468:	0141                	add	sp,sp,16
    8000046a:	8082                	ret

000000008000046c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000046c:	7179                	add	sp,sp,-48
    8000046e:	f406                	sd	ra,40(sp)
    80000470:	f022                	sd	s0,32(sp)
    80000472:	ec26                	sd	s1,24(sp)
    80000474:	e84a                	sd	s2,16(sp)
    80000476:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000478:	c219                	beqz	a2,8000047e <printint+0x12>
    8000047a:	08054063          	bltz	a0,800004fa <printint+0x8e>
    x = -xx;
  else
    x = xx;
    8000047e:	4881                	li	a7,0
    80000480:	fd040693          	add	a3,s0,-48

  i = 0;
    80000484:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000486:	00008617          	auipc	a2,0x8
    8000048a:	bb260613          	add	a2,a2,-1102 # 80008038 <digits>
    8000048e:	883e                	mv	a6,a5
    80000490:	2785                	addw	a5,a5,1
    80000492:	02b57733          	remu	a4,a0,a1
    80000496:	9732                	add	a4,a4,a2
    80000498:	00074703          	lbu	a4,0(a4)
    8000049c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800004a0:	872a                	mv	a4,a0
    800004a2:	02b55533          	divu	a0,a0,a1
    800004a6:	0685                	add	a3,a3,1
    800004a8:	feb773e3          	bgeu	a4,a1,8000048e <printint+0x22>

  if(sign)
    800004ac:	00088a63          	beqz	a7,800004c0 <printint+0x54>
    buf[i++] = '-';
    800004b0:	1781                	add	a5,a5,-32
    800004b2:	97a2                	add	a5,a5,s0
    800004b4:	02d00713          	li	a4,45
    800004b8:	fee78823          	sb	a4,-16(a5)
    800004bc:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
    800004c0:	02f05763          	blez	a5,800004ee <printint+0x82>
    800004c4:	fd040713          	add	a4,s0,-48
    800004c8:	00f704b3          	add	s1,a4,a5
    800004cc:	fff70913          	add	s2,a4,-1
    800004d0:	993e                	add	s2,s2,a5
    800004d2:	37fd                	addw	a5,a5,-1
    800004d4:	1782                	sll	a5,a5,0x20
    800004d6:	9381                	srl	a5,a5,0x20
    800004d8:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004dc:	fff4c503          	lbu	a0,-1(s1)
    800004e0:	00000097          	auipc	ra,0x0
    800004e4:	d6c080e7          	jalr	-660(ra) # 8000024c <consputc>
  while(--i >= 0)
    800004e8:	14fd                	add	s1,s1,-1
    800004ea:	ff2499e3          	bne	s1,s2,800004dc <printint+0x70>
}
    800004ee:	70a2                	ld	ra,40(sp)
    800004f0:	7402                	ld	s0,32(sp)
    800004f2:	64e2                	ld	s1,24(sp)
    800004f4:	6942                	ld	s2,16(sp)
    800004f6:	6145                	add	sp,sp,48
    800004f8:	8082                	ret
    x = -xx;
    800004fa:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004fe:	4885                	li	a7,1
    x = -xx;
    80000500:	b741                	j	80000480 <printint+0x14>

0000000080000502 <printf>:
}

/* Print to the console. */
int
printf(char *fmt, ...)
{
    80000502:	7155                	add	sp,sp,-208
    80000504:	e506                	sd	ra,136(sp)
    80000506:	e122                	sd	s0,128(sp)
    80000508:	fca6                	sd	s1,120(sp)
    8000050a:	f8ca                	sd	s2,112(sp)
    8000050c:	f4ce                	sd	s3,104(sp)
    8000050e:	f0d2                	sd	s4,96(sp)
    80000510:	ecd6                	sd	s5,88(sp)
    80000512:	e8da                	sd	s6,80(sp)
    80000514:	e4de                	sd	s7,72(sp)
    80000516:	e0e2                	sd	s8,64(sp)
    80000518:	fc66                	sd	s9,56(sp)
    8000051a:	f86a                	sd	s10,48(sp)
    8000051c:	f46e                	sd	s11,40(sp)
    8000051e:	0900                	add	s0,sp,144
    80000520:	8a2a                	mv	s4,a0
    80000522:	e40c                	sd	a1,8(s0)
    80000524:	e810                	sd	a2,16(s0)
    80000526:	ec14                	sd	a3,24(s0)
    80000528:	f018                	sd	a4,32(s0)
    8000052a:	f41c                	sd	a5,40(s0)
    8000052c:	03043823          	sd	a6,48(s0)
    80000530:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80000534:	00010797          	auipc	a5,0x10
    80000538:	49c7a783          	lw	a5,1180(a5) # 800109d0 <pr+0x18>
    8000053c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80000540:	e79d                	bnez	a5,8000056e <printf+0x6c>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000542:	00840793          	add	a5,s0,8
    80000546:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054a:	00054503          	lbu	a0,0(a0)
    8000054e:	2a050063          	beqz	a0,800007ee <printf+0x2ec>
    80000552:	4981                	li	s3,0
    if(cx != '%'){
    80000554:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000558:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000055c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000560:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000564:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000568:	07000d93          	li	s11,112
    8000056c:	a0b1                	j	800005b8 <printf+0xb6>
    acquire(&pr.lock);
    8000056e:	00010517          	auipc	a0,0x10
    80000572:	44a50513          	add	a0,a0,1098 # 800109b8 <pr>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	756080e7          	jalr	1878(ra) # 80000ccc <acquire>
  va_start(ap, fmt);
    8000057e:	00840793          	add	a5,s0,8
    80000582:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000586:	000a4503          	lbu	a0,0(s4)
    8000058a:	f561                	bnez	a0,80000552 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    8000058c:	00010517          	auipc	a0,0x10
    80000590:	42c50513          	add	a0,a0,1068 # 800109b8 <pr>
    80000594:	00000097          	auipc	ra,0x0
    80000598:	7ec080e7          	jalr	2028(ra) # 80000d80 <release>
    8000059c:	ac89                	j	800007ee <printf+0x2ec>
      consputc(cx);
    8000059e:	00000097          	auipc	ra,0x0
    800005a2:	cae080e7          	jalr	-850(ra) # 8000024c <consputc>
      continue;
    800005a6:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800005a8:	0014899b          	addw	s3,s1,1
    800005ac:	013a07b3          	add	a5,s4,s3
    800005b0:	0007c503          	lbu	a0,0(a5)
    800005b4:	22050963          	beqz	a0,800007e6 <printf+0x2e4>
    if(cx != '%'){
    800005b8:	ff5513e3          	bne	a0,s5,8000059e <printf+0x9c>
    i++;
    800005bc:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800005c0:	009a07b3          	add	a5,s4,s1
    800005c4:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800005c8:	20090f63          	beqz	s2,800007e6 <printf+0x2e4>
    800005cc:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800005d0:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800005d2:	c789                	beqz	a5,800005dc <printf+0xda>
    800005d4:	009a0733          	add	a4,s4,s1
    800005d8:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800005dc:	03690b63          	beq	s2,s6,80000612 <printf+0x110>
    } else if(c0 == 'l' && c1 == 'd'){
    800005e0:	05890763          	beq	s2,s8,8000062e <printf+0x12c>
    } else if(c0 == 'u'){
    800005e4:	0f990963          	beq	s2,s9,800006d6 <printf+0x1d4>
    } else if(c0 == 'x'){
    800005e8:	15a90563          	beq	s2,s10,80000732 <printf+0x230>
    } else if(c0 == 'p'){
    800005ec:	17b90163          	beq	s2,s11,8000074e <printf+0x24c>
    } else if(c0 == 's'){
    800005f0:	07300793          	li	a5,115
    800005f4:	1af90463          	beq	s2,a5,8000079c <printf+0x29a>
    } else if(c0 == '%'){
    800005f8:	1f590063          	beq	s2,s5,800007d8 <printf+0x2d6>
      consputc('%');
    800005fc:	8556                	mv	a0,s5
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	c4e080e7          	jalr	-946(ra) # 8000024c <consputc>
      consputc(c0);
    80000606:	854a                	mv	a0,s2
    80000608:	00000097          	auipc	ra,0x0
    8000060c:	c44080e7          	jalr	-956(ra) # 8000024c <consputc>
    80000610:	bf61                	j	800005a8 <printf+0xa6>
      printint(va_arg(ap, int), 10, 1);
    80000612:	f8843783          	ld	a5,-120(s0)
    80000616:	00878713          	add	a4,a5,8
    8000061a:	f8e43423          	sd	a4,-120(s0)
    8000061e:	4605                	li	a2,1
    80000620:	45a9                	li	a1,10
    80000622:	4388                	lw	a0,0(a5)
    80000624:	00000097          	auipc	ra,0x0
    80000628:	e48080e7          	jalr	-440(ra) # 8000046c <printint>
    8000062c:	bfb5                	j	800005a8 <printf+0xa6>
    } else if(c0 == 'l' && c1 == 'd'){
    8000062e:	03678863          	beq	a5,s6,8000065e <printf+0x15c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000632:	05878663          	beq	a5,s8,8000067e <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'u'){
    80000636:	0b978e63          	beq	a5,s9,800006f2 <printf+0x1f0>
    } else if(c0 == 'l' && c1 == 'x'){
    8000063a:	fda791e3          	bne	a5,s10,800005fc <printf+0xfa>
      printint(va_arg(ap, uint64), 16, 0);
    8000063e:	f8843783          	ld	a5,-120(s0)
    80000642:	00878713          	add	a4,a5,8
    80000646:	f8e43423          	sd	a4,-120(s0)
    8000064a:	4601                	li	a2,0
    8000064c:	45c1                	li	a1,16
    8000064e:	6388                	ld	a0,0(a5)
    80000650:	00000097          	auipc	ra,0x0
    80000654:	e1c080e7          	jalr	-484(ra) # 8000046c <printint>
      i += 1;
    80000658:	0029849b          	addw	s1,s3,2
    8000065c:	b7b1                	j	800005a8 <printf+0xa6>
      printint(va_arg(ap, uint64), 10, 1);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	add	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4605                	li	a2,1
    8000066c:	45a9                	li	a1,10
    8000066e:	6388                	ld	a0,0(a5)
    80000670:	00000097          	auipc	ra,0x0
    80000674:	dfc080e7          	jalr	-516(ra) # 8000046c <printint>
      i += 1;
    80000678:	0029849b          	addw	s1,s3,2
    8000067c:	b735                	j	800005a8 <printf+0xa6>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000067e:	06400793          	li	a5,100
    80000682:	02f68a63          	beq	a3,a5,800006b6 <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000686:	07500793          	li	a5,117
    8000068a:	08f68463          	beq	a3,a5,80000712 <printf+0x210>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000068e:	07800793          	li	a5,120
    80000692:	f6f695e3          	bne	a3,a5,800005fc <printf+0xfa>
      printint(va_arg(ap, uint64), 16, 0);
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	add	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	4601                	li	a2,0
    800006a4:	45c1                	li	a1,16
    800006a6:	6388                	ld	a0,0(a5)
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	dc4080e7          	jalr	-572(ra) # 8000046c <printint>
      i += 2;
    800006b0:	0039849b          	addw	s1,s3,3
    800006b4:	bdd5                	j	800005a8 <printf+0xa6>
      printint(va_arg(ap, uint64), 10, 1);
    800006b6:	f8843783          	ld	a5,-120(s0)
    800006ba:	00878713          	add	a4,a5,8
    800006be:	f8e43423          	sd	a4,-120(s0)
    800006c2:	4605                	li	a2,1
    800006c4:	45a9                	li	a1,10
    800006c6:	6388                	ld	a0,0(a5)
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	da4080e7          	jalr	-604(ra) # 8000046c <printint>
      i += 2;
    800006d0:	0039849b          	addw	s1,s3,3
    800006d4:	bdd1                	j	800005a8 <printf+0xa6>
      printint(va_arg(ap, int), 10, 0);
    800006d6:	f8843783          	ld	a5,-120(s0)
    800006da:	00878713          	add	a4,a5,8
    800006de:	f8e43423          	sd	a4,-120(s0)
    800006e2:	4601                	li	a2,0
    800006e4:	45a9                	li	a1,10
    800006e6:	4388                	lw	a0,0(a5)
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	d84080e7          	jalr	-636(ra) # 8000046c <printint>
    800006f0:	bd65                	j	800005a8 <printf+0xa6>
      printint(va_arg(ap, uint64), 10, 0);
    800006f2:	f8843783          	ld	a5,-120(s0)
    800006f6:	00878713          	add	a4,a5,8
    800006fa:	f8e43423          	sd	a4,-120(s0)
    800006fe:	4601                	li	a2,0
    80000700:	45a9                	li	a1,10
    80000702:	6388                	ld	a0,0(a5)
    80000704:	00000097          	auipc	ra,0x0
    80000708:	d68080e7          	jalr	-664(ra) # 8000046c <printint>
      i += 1;
    8000070c:	0029849b          	addw	s1,s3,2
    80000710:	bd61                	j	800005a8 <printf+0xa6>
      printint(va_arg(ap, uint64), 10, 0);
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	add	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	4601                	li	a2,0
    80000720:	45a9                	li	a1,10
    80000722:	6388                	ld	a0,0(a5)
    80000724:	00000097          	auipc	ra,0x0
    80000728:	d48080e7          	jalr	-696(ra) # 8000046c <printint>
      i += 2;
    8000072c:	0039849b          	addw	s1,s3,3
    80000730:	bda5                	j	800005a8 <printf+0xa6>
      printint(va_arg(ap, int), 16, 0);
    80000732:	f8843783          	ld	a5,-120(s0)
    80000736:	00878713          	add	a4,a5,8
    8000073a:	f8e43423          	sd	a4,-120(s0)
    8000073e:	4601                	li	a2,0
    80000740:	45c1                	li	a1,16
    80000742:	4388                	lw	a0,0(a5)
    80000744:	00000097          	auipc	ra,0x0
    80000748:	d28080e7          	jalr	-728(ra) # 8000046c <printint>
    8000074c:	bdb1                	j	800005a8 <printf+0xa6>
      printptr(va_arg(ap, uint64));
    8000074e:	f8843783          	ld	a5,-120(s0)
    80000752:	00878713          	add	a4,a5,8
    80000756:	f8e43423          	sd	a4,-120(s0)
    8000075a:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000075e:	03000513          	li	a0,48
    80000762:	00000097          	auipc	ra,0x0
    80000766:	aea080e7          	jalr	-1302(ra) # 8000024c <consputc>
  consputc('x');
    8000076a:	07800513          	li	a0,120
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	ade080e7          	jalr	-1314(ra) # 8000024c <consputc>
    80000776:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000778:	00008b97          	auipc	s7,0x8
    8000077c:	8c0b8b93          	add	s7,s7,-1856 # 80008038 <digits>
    80000780:	03c9d793          	srl	a5,s3,0x3c
    80000784:	97de                	add	a5,a5,s7
    80000786:	0007c503          	lbu	a0,0(a5)
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	ac2080e7          	jalr	-1342(ra) # 8000024c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000792:	0992                	sll	s3,s3,0x4
    80000794:	397d                	addw	s2,s2,-1
    80000796:	fe0915e3          	bnez	s2,80000780 <printf+0x27e>
    8000079a:	b539                	j	800005a8 <printf+0xa6>
      if((s = va_arg(ap, char*)) == 0)
    8000079c:	f8843783          	ld	a5,-120(s0)
    800007a0:	00878713          	add	a4,a5,8
    800007a4:	f8e43423          	sd	a4,-120(s0)
    800007a8:	0007b903          	ld	s2,0(a5)
    800007ac:	00090f63          	beqz	s2,800007ca <printf+0x2c8>
      for(; *s; s++)
    800007b0:	00094503          	lbu	a0,0(s2)
    800007b4:	de050ae3          	beqz	a0,800005a8 <printf+0xa6>
        consputc(*s);
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	a94080e7          	jalr	-1388(ra) # 8000024c <consputc>
      for(; *s; s++)
    800007c0:	0905                	add	s2,s2,1
    800007c2:	00094503          	lbu	a0,0(s2)
    800007c6:	f96d                	bnez	a0,800007b8 <printf+0x2b6>
    800007c8:	b3c5                	j	800005a8 <printf+0xa6>
        s = "(null)";
    800007ca:	00008917          	auipc	s2,0x8
    800007ce:	84e90913          	add	s2,s2,-1970 # 80008018 <etext+0x18>
      for(; *s; s++)
    800007d2:	02800513          	li	a0,40
    800007d6:	b7cd                	j	800007b8 <printf+0x2b6>
      consputc('%');
    800007d8:	02500513          	li	a0,37
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	a70080e7          	jalr	-1424(ra) # 8000024c <consputc>
    800007e4:	b3d1                	j	800005a8 <printf+0xa6>
  if(locking)
    800007e6:	f7843783          	ld	a5,-136(s0)
    800007ea:	da0791e3          	bnez	a5,8000058c <printf+0x8a>

  return 0;
}
    800007ee:	4501                	li	a0,0
    800007f0:	60aa                	ld	ra,136(sp)
    800007f2:	640a                	ld	s0,128(sp)
    800007f4:	74e6                	ld	s1,120(sp)
    800007f6:	7946                	ld	s2,112(sp)
    800007f8:	79a6                	ld	s3,104(sp)
    800007fa:	7a06                	ld	s4,96(sp)
    800007fc:	6ae6                	ld	s5,88(sp)
    800007fe:	6b46                	ld	s6,80(sp)
    80000800:	6ba6                	ld	s7,72(sp)
    80000802:	6c06                	ld	s8,64(sp)
    80000804:	7ce2                	ld	s9,56(sp)
    80000806:	7d42                	ld	s10,48(sp)
    80000808:	7da2                	ld	s11,40(sp)
    8000080a:	6169                	add	sp,sp,208
    8000080c:	8082                	ret

000000008000080e <panic>:

void
panic(char *s)
{
    8000080e:	1101                	add	sp,sp,-32
    80000810:	ec06                	sd	ra,24(sp)
    80000812:	e822                	sd	s0,16(sp)
    80000814:	e426                	sd	s1,8(sp)
    80000816:	1000                	add	s0,sp,32
    80000818:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000081a:	00010797          	auipc	a5,0x10
    8000081e:	1a07ab23          	sw	zero,438(a5) # 800109d0 <pr+0x18>
  printf("panic: ");
    80000822:	00007517          	auipc	a0,0x7
    80000826:	7fe50513          	add	a0,a0,2046 # 80008020 <etext+0x20>
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	cd8080e7          	jalr	-808(ra) # 80000502 <printf>
  printf("%s\n", s);
    80000832:	85a6                	mv	a1,s1
    80000834:	00007517          	auipc	a0,0x7
    80000838:	7f450513          	add	a0,a0,2036 # 80008028 <etext+0x28>
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	cc6080e7          	jalr	-826(ra) # 80000502 <printf>
  panicked = 1; /* freeze uart output from other CPUs */
    80000844:	4785                	li	a5,1
    80000846:	00008717          	auipc	a4,0x8
    8000084a:	08f72523          	sw	a5,138(a4) # 800088d0 <panicked>
  for(;;)
    8000084e:	a001                	j	8000084e <panic+0x40>

0000000080000850 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000850:	1101                	add	sp,sp,-32
    80000852:	ec06                	sd	ra,24(sp)
    80000854:	e822                	sd	s0,16(sp)
    80000856:	e426                	sd	s1,8(sp)
    80000858:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    8000085a:	00010497          	auipc	s1,0x10
    8000085e:	15e48493          	add	s1,s1,350 # 800109b8 <pr>
    80000862:	00007597          	auipc	a1,0x7
    80000866:	7ce58593          	add	a1,a1,1998 # 80008030 <etext+0x30>
    8000086a:	8526                	mv	a0,s1
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	3d0080e7          	jalr	976(ra) # 80000c3c <initlock>
  pr.locking = 1;
    80000874:	4785                	li	a5,1
    80000876:	cc9c                	sw	a5,24(s1)
}
    80000878:	60e2                	ld	ra,24(sp)
    8000087a:	6442                	ld	s0,16(sp)
    8000087c:	64a2                	ld	s1,8(sp)
    8000087e:	6105                	add	sp,sp,32
    80000880:	8082                	ret

0000000080000882 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000882:	1141                	add	sp,sp,-16
    80000884:	e406                	sd	ra,8(sp)
    80000886:	e022                	sd	s0,0(sp)
    80000888:	0800                	add	s0,sp,16
  /* disable interrupts. */
  WriteReg(IER, 0x00);
    8000088a:	100007b7          	lui	a5,0x10000
    8000088e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  /* special mode to set baud rate. */
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000892:	f8000713          	li	a4,-128
    80000896:	00e781a3          	sb	a4,3(a5)

  /* LSB for baud rate of 38.4K. */
  WriteReg(0, 0x03);
    8000089a:	470d                	li	a4,3
    8000089c:	00e78023          	sb	a4,0(a5)

  /* MSB for baud rate of 38.4K. */
  WriteReg(1, 0x00);
    800008a0:	000780a3          	sb	zero,1(a5)

  /* leave set-baud mode, */
  /* and set word length to 8 bits, no parity. */
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008a4:	00e781a3          	sb	a4,3(a5)

  /* reset and enable FIFOs. */
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008a8:	469d                	li	a3,7
    800008aa:	00d78123          	sb	a3,2(a5)

  /* enable transmit and receive interrupts. */
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ae:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800008b2:	00007597          	auipc	a1,0x7
    800008b6:	79e58593          	add	a1,a1,1950 # 80008050 <digits+0x18>
    800008ba:	00010517          	auipc	a0,0x10
    800008be:	11e50513          	add	a0,a0,286 # 800109d8 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	37a080e7          	jalr	890(ra) # 80000c3c <initlock>
}
    800008ca:	60a2                	ld	ra,8(sp)
    800008cc:	6402                	ld	s0,0(sp)
    800008ce:	0141                	add	sp,sp,16
    800008d0:	8082                	ret

00000000800008d2 <uartputc_sync>:
/* use interrupts, for use by kernel printf() and */
/* to echo characters. it spins waiting for the uart's */
/* output register to be empty. */
void
uartputc_sync(int c)
{
    800008d2:	1101                	add	sp,sp,-32
    800008d4:	ec06                	sd	ra,24(sp)
    800008d6:	e822                	sd	s0,16(sp)
    800008d8:	e426                	sd	s1,8(sp)
    800008da:	1000                	add	s0,sp,32
    800008dc:	84aa                	mv	s1,a0
  push_off();
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	3a2080e7          	jalr	930(ra) # 80000c80 <push_off>

  if(panicked){
    800008e6:	00008797          	auipc	a5,0x8
    800008ea:	fea7a783          	lw	a5,-22(a5) # 800088d0 <panicked>
    for(;;)
      ;
  }

  /* wait for Transmit Holding Empty to be set in LSR. */
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800008ee:	10000737          	lui	a4,0x10000
  if(panicked){
    800008f2:	c391                	beqz	a5,800008f6 <uartputc_sync+0x24>
    for(;;)
    800008f4:	a001                	j	800008f4 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800008f6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800008fa:	0207f793          	and	a5,a5,32
    800008fe:	dfe5                	beqz	a5,800008f6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000900:	0ff4f513          	zext.b	a0,s1
    80000904:	100007b7          	lui	a5,0x10000
    80000908:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	414080e7          	jalr	1044(ra) # 80000d20 <pop_off>
}
    80000914:	60e2                	ld	ra,24(sp)
    80000916:	6442                	ld	s0,16(sp)
    80000918:	64a2                	ld	s1,8(sp)
    8000091a:	6105                	add	sp,sp,32
    8000091c:	8082                	ret

000000008000091e <uartstart>:
/* called from both the top- and bottom-half. */
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000091e:	00008797          	auipc	a5,0x8
    80000922:	fba7b783          	ld	a5,-70(a5) # 800088d8 <uart_tx_r>
    80000926:	00008717          	auipc	a4,0x8
    8000092a:	fba73703          	ld	a4,-70(a4) # 800088e0 <uart_tx_w>
    8000092e:	06f70e63          	beq	a4,a5,800009aa <uartstart+0x8c>
{
    80000932:	7139                	add	sp,sp,-64
    80000934:	fc06                	sd	ra,56(sp)
    80000936:	f822                	sd	s0,48(sp)
    80000938:	f426                	sd	s1,40(sp)
    8000093a:	f04a                	sd	s2,32(sp)
    8000093c:	ec4e                	sd	s3,24(sp)
    8000093e:	e852                	sd	s4,16(sp)
    80000940:	e456                	sd	s5,8(sp)
    80000942:	0080                	add	s0,sp,64
      /* transmit buffer is empty. */
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000944:	10000937          	lui	s2,0x10000
      /* so we cannot give it another byte. */
      /* it will interrupt when it's ready for a new byte. */
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000948:	00010a17          	auipc	s4,0x10
    8000094c:	090a0a13          	add	s4,s4,144 # 800109d8 <uart_tx_lock>
    uart_tx_r += 1;
    80000950:	00008497          	auipc	s1,0x8
    80000954:	f8848493          	add	s1,s1,-120 # 800088d8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000958:	00008997          	auipc	s3,0x8
    8000095c:	f8898993          	add	s3,s3,-120 # 800088e0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000960:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000964:	02077713          	and	a4,a4,32
    80000968:	cb05                	beqz	a4,80000998 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000096a:	01f7f713          	and	a4,a5,31
    8000096e:	9752                	add	a4,a4,s4
    80000970:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000974:	0785                	add	a5,a5,1
    80000976:	e09c                	sd	a5,0(s1)
    
    /* maybe uartputc() is waiting for space in the buffer. */
    wakeup(&uart_tx_r);
    80000978:	8526                	mv	a0,s1
    8000097a:	00002097          	auipc	ra,0x2
    8000097e:	8ae080e7          	jalr	-1874(ra) # 80002228 <wakeup>
    
    WriteReg(THR, c);
    80000982:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000986:	609c                	ld	a5,0(s1)
    80000988:	0009b703          	ld	a4,0(s3)
    8000098c:	fcf71ae3          	bne	a4,a5,80000960 <uartstart+0x42>
      ReadReg(ISR);
    80000990:	100007b7          	lui	a5,0x10000
    80000994:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80000998:	70e2                	ld	ra,56(sp)
    8000099a:	7442                	ld	s0,48(sp)
    8000099c:	74a2                	ld	s1,40(sp)
    8000099e:	7902                	ld	s2,32(sp)
    800009a0:	69e2                	ld	s3,24(sp)
    800009a2:	6a42                	ld	s4,16(sp)
    800009a4:	6aa2                	ld	s5,8(sp)
    800009a6:	6121                	add	sp,sp,64
    800009a8:	8082                	ret
      ReadReg(ISR);
    800009aa:	100007b7          	lui	a5,0x10000
    800009ae:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800009b2:	8082                	ret

00000000800009b4 <uartputc>:
{
    800009b4:	7179                	add	sp,sp,-48
    800009b6:	f406                	sd	ra,40(sp)
    800009b8:	f022                	sd	s0,32(sp)
    800009ba:	ec26                	sd	s1,24(sp)
    800009bc:	e84a                	sd	s2,16(sp)
    800009be:	e44e                	sd	s3,8(sp)
    800009c0:	e052                	sd	s4,0(sp)
    800009c2:	1800                	add	s0,sp,48
    800009c4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800009c6:	00010517          	auipc	a0,0x10
    800009ca:	01250513          	add	a0,a0,18 # 800109d8 <uart_tx_lock>
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	2fe080e7          	jalr	766(ra) # 80000ccc <acquire>
  if(panicked){
    800009d6:	00008797          	auipc	a5,0x8
    800009da:	efa7a783          	lw	a5,-262(a5) # 800088d0 <panicked>
    800009de:	e7c9                	bnez	a5,80000a68 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009e0:	00008717          	auipc	a4,0x8
    800009e4:	f0073703          	ld	a4,-256(a4) # 800088e0 <uart_tx_w>
    800009e8:	00008797          	auipc	a5,0x8
    800009ec:	ef07b783          	ld	a5,-272(a5) # 800088d8 <uart_tx_r>
    800009f0:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800009f4:	00010997          	auipc	s3,0x10
    800009f8:	fe498993          	add	s3,s3,-28 # 800109d8 <uart_tx_lock>
    800009fc:	00008497          	auipc	s1,0x8
    80000a00:	edc48493          	add	s1,s1,-292 # 800088d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000a04:	00008917          	auipc	s2,0x8
    80000a08:	edc90913          	add	s2,s2,-292 # 800088e0 <uart_tx_w>
    80000a0c:	00e79f63          	bne	a5,a4,80000a2a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000a10:	85ce                	mv	a1,s3
    80000a12:	8526                	mv	a0,s1
    80000a14:	00001097          	auipc	ra,0x1
    80000a18:	7b0080e7          	jalr	1968(ra) # 800021c4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000a1c:	00093703          	ld	a4,0(s2)
    80000a20:	609c                	ld	a5,0(s1)
    80000a22:	02078793          	add	a5,a5,32
    80000a26:	fee785e3          	beq	a5,a4,80000a10 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000a2a:	00010497          	auipc	s1,0x10
    80000a2e:	fae48493          	add	s1,s1,-82 # 800109d8 <uart_tx_lock>
    80000a32:	01f77793          	and	a5,a4,31
    80000a36:	97a6                	add	a5,a5,s1
    80000a38:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000a3c:	0705                	add	a4,a4,1
    80000a3e:	00008797          	auipc	a5,0x8
    80000a42:	eae7b123          	sd	a4,-350(a5) # 800088e0 <uart_tx_w>
  uartstart();
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	ed8080e7          	jalr	-296(ra) # 8000091e <uartstart>
  release(&uart_tx_lock);
    80000a4e:	8526                	mv	a0,s1
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	330080e7          	jalr	816(ra) # 80000d80 <release>
}
    80000a58:	70a2                	ld	ra,40(sp)
    80000a5a:	7402                	ld	s0,32(sp)
    80000a5c:	64e2                	ld	s1,24(sp)
    80000a5e:	6942                	ld	s2,16(sp)
    80000a60:	69a2                	ld	s3,8(sp)
    80000a62:	6a02                	ld	s4,0(sp)
    80000a64:	6145                	add	sp,sp,48
    80000a66:	8082                	ret
    for(;;)
    80000a68:	a001                	j	80000a68 <uartputc+0xb4>

0000000080000a6a <uartgetc>:

/* read one input character from the UART. */
/* return -1 if none is waiting. */
int
uartgetc(void)
{
    80000a6a:	1141                	add	sp,sp,-16
    80000a6c:	e422                	sd	s0,8(sp)
    80000a6e:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a70:	100007b7          	lui	a5,0x10000
    80000a74:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a78:	8b85                	and	a5,a5,1
    80000a7a:	cb81                	beqz	a5,80000a8a <uartgetc+0x20>
    /* input data is ready. */
    return ReadReg(RHR);
    80000a7c:	100007b7          	lui	a5,0x10000
    80000a80:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a84:	6422                	ld	s0,8(sp)
    80000a86:	0141                	add	sp,sp,16
    80000a88:	8082                	ret
    return -1;
    80000a8a:	557d                	li	a0,-1
    80000a8c:	bfe5                	j	80000a84 <uartgetc+0x1a>

0000000080000a8e <uartintr>:
/* handle a uart interrupt, raised because input has */
/* arrived, or the uart is ready for more output, or */
/* both. called from devintr(). */
void
uartintr(void)
{
    80000a8e:	1101                	add	sp,sp,-32
    80000a90:	ec06                	sd	ra,24(sp)
    80000a92:	e822                	sd	s0,16(sp)
    80000a94:	e426                	sd	s1,8(sp)
    80000a96:	1000                	add	s0,sp,32
  /* read and process incoming characters. */
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a98:	54fd                	li	s1,-1
    80000a9a:	a029                	j	80000aa4 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	7f2080e7          	jalr	2034(ra) # 8000028e <consoleintr>
    int c = uartgetc();
    80000aa4:	00000097          	auipc	ra,0x0
    80000aa8:	fc6080e7          	jalr	-58(ra) # 80000a6a <uartgetc>
    if(c == -1)
    80000aac:	fe9518e3          	bne	a0,s1,80000a9c <uartintr+0xe>
  }

  /* send buffered characters. */
  acquire(&uart_tx_lock);
    80000ab0:	00010497          	auipc	s1,0x10
    80000ab4:	f2848493          	add	s1,s1,-216 # 800109d8 <uart_tx_lock>
    80000ab8:	8526                	mv	a0,s1
    80000aba:	00000097          	auipc	ra,0x0
    80000abe:	212080e7          	jalr	530(ra) # 80000ccc <acquire>
  uartstart();
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	e5c080e7          	jalr	-420(ra) # 8000091e <uartstart>
  release(&uart_tx_lock);
    80000aca:	8526                	mv	a0,s1
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	2b4080e7          	jalr	692(ra) # 80000d80 <release>
}
    80000ad4:	60e2                	ld	ra,24(sp)
    80000ad6:	6442                	ld	s0,16(sp)
    80000ad8:	64a2                	ld	s1,8(sp)
    80000ada:	6105                	add	sp,sp,32
    80000adc:	8082                	ret

0000000080000ade <kfree>:
/* which normally should have been returned by a */
/* call to kalloc().  (The exception is when */
/* initializing the allocator; see kinit above.) */
void
kfree(void *pa)
{
    80000ade:	1101                	add	sp,sp,-32
    80000ae0:	ec06                	sd	ra,24(sp)
    80000ae2:	e822                	sd	s0,16(sp)
    80000ae4:	e426                	sd	s1,8(sp)
    80000ae6:	e04a                	sd	s2,0(sp)
    80000ae8:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000aea:	03451793          	sll	a5,a0,0x34
    80000aee:	ebb9                	bnez	a5,80000b44 <kfree+0x66>
    80000af0:	84aa                	mv	s1,a0
    80000af2:	00021797          	auipc	a5,0x21
    80000af6:	14e78793          	add	a5,a5,334 # 80021c40 <end>
    80000afa:	04f56563          	bltu	a0,a5,80000b44 <kfree+0x66>
    80000afe:	47c5                	li	a5,17
    80000b00:	07ee                	sll	a5,a5,0x1b
    80000b02:	04f57163          	bgeu	a0,a5,80000b44 <kfree+0x66>
    panic("kfree");

  /* Fill with junk to catch dangling refs. */
  memset(pa, 1, PGSIZE);
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4585                	li	a1,1
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	2be080e7          	jalr	702(ra) # 80000dc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000b12:	00010917          	auipc	s2,0x10
    80000b16:	efe90913          	add	s2,s2,-258 # 80010a10 <kmem>
    80000b1a:	854a                	mv	a0,s2
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	1b0080e7          	jalr	432(ra) # 80000ccc <acquire>
  r->next = kmem.freelist;
    80000b24:	01893783          	ld	a5,24(s2)
    80000b28:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000b2a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000b2e:	854a                	mv	a0,s2
    80000b30:	00000097          	auipc	ra,0x0
    80000b34:	250080e7          	jalr	592(ra) # 80000d80 <release>
}
    80000b38:	60e2                	ld	ra,24(sp)
    80000b3a:	6442                	ld	s0,16(sp)
    80000b3c:	64a2                	ld	s1,8(sp)
    80000b3e:	6902                	ld	s2,0(sp)
    80000b40:	6105                	add	sp,sp,32
    80000b42:	8082                	ret
    panic("kfree");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	51450513          	add	a0,a0,1300 # 80008058 <digits+0x20>
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	cc2080e7          	jalr	-830(ra) # 8000080e <panic>

0000000080000b54 <freerange>:
{
    80000b54:	7179                	add	sp,sp,-48
    80000b56:	f406                	sd	ra,40(sp)
    80000b58:	f022                	sd	s0,32(sp)
    80000b5a:	ec26                	sd	s1,24(sp)
    80000b5c:	e84a                	sd	s2,16(sp)
    80000b5e:	e44e                	sd	s3,8(sp)
    80000b60:	e052                	sd	s4,0(sp)
    80000b62:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b64:	6785                	lui	a5,0x1
    80000b66:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b6a:	00e504b3          	add	s1,a0,a4
    80000b6e:	777d                	lui	a4,0xfffff
    80000b70:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b72:	94be                	add	s1,s1,a5
    80000b74:	0095ee63          	bltu	a1,s1,80000b90 <freerange+0x3c>
    80000b78:	892e                	mv	s2,a1
    kfree(p);
    80000b7a:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b7c:	6985                	lui	s3,0x1
    kfree(p);
    80000b7e:	01448533          	add	a0,s1,s4
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	f5c080e7          	jalr	-164(ra) # 80000ade <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b8a:	94ce                	add	s1,s1,s3
    80000b8c:	fe9979e3          	bgeu	s2,s1,80000b7e <freerange+0x2a>
}
    80000b90:	70a2                	ld	ra,40(sp)
    80000b92:	7402                	ld	s0,32(sp)
    80000b94:	64e2                	ld	s1,24(sp)
    80000b96:	6942                	ld	s2,16(sp)
    80000b98:	69a2                	ld	s3,8(sp)
    80000b9a:	6a02                	ld	s4,0(sp)
    80000b9c:	6145                	add	sp,sp,48
    80000b9e:	8082                	ret

0000000080000ba0 <kinit>:
{
    80000ba0:	1141                	add	sp,sp,-16
    80000ba2:	e406                	sd	ra,8(sp)
    80000ba4:	e022                	sd	s0,0(sp)
    80000ba6:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ba8:	00007597          	auipc	a1,0x7
    80000bac:	4b858593          	add	a1,a1,1208 # 80008060 <digits+0x28>
    80000bb0:	00010517          	auipc	a0,0x10
    80000bb4:	e6050513          	add	a0,a0,-416 # 80010a10 <kmem>
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	084080e7          	jalr	132(ra) # 80000c3c <initlock>
  freerange(end, (void*)PHYSTOP);
    80000bc0:	45c5                	li	a1,17
    80000bc2:	05ee                	sll	a1,a1,0x1b
    80000bc4:	00021517          	auipc	a0,0x21
    80000bc8:	07c50513          	add	a0,a0,124 # 80021c40 <end>
    80000bcc:	00000097          	auipc	ra,0x0
    80000bd0:	f88080e7          	jalr	-120(ra) # 80000b54 <freerange>
}
    80000bd4:	60a2                	ld	ra,8(sp)
    80000bd6:	6402                	ld	s0,0(sp)
    80000bd8:	0141                	add	sp,sp,16
    80000bda:	8082                	ret

0000000080000bdc <kalloc>:
/* Allocate one 4096-byte page of physical memory. */
/* Returns a pointer that the kernel can use. */
/* Returns 0 if the memory cannot be allocated. */
void *
kalloc(void)
{
    80000bdc:	1101                	add	sp,sp,-32
    80000bde:	ec06                	sd	ra,24(sp)
    80000be0:	e822                	sd	s0,16(sp)
    80000be2:	e426                	sd	s1,8(sp)
    80000be4:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000be6:	00010497          	auipc	s1,0x10
    80000bea:	e2a48493          	add	s1,s1,-470 # 80010a10 <kmem>
    80000bee:	8526                	mv	a0,s1
    80000bf0:	00000097          	auipc	ra,0x0
    80000bf4:	0dc080e7          	jalr	220(ra) # 80000ccc <acquire>
  r = kmem.freelist;
    80000bf8:	6c84                	ld	s1,24(s1)
  if(r)
    80000bfa:	c885                	beqz	s1,80000c2a <kalloc+0x4e>
    kmem.freelist = r->next;
    80000bfc:	609c                	ld	a5,0(s1)
    80000bfe:	00010517          	auipc	a0,0x10
    80000c02:	e1250513          	add	a0,a0,-494 # 80010a10 <kmem>
    80000c06:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000c08:	00000097          	auipc	ra,0x0
    80000c0c:	178080e7          	jalr	376(ra) # 80000d80 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); /* fill with junk */
    80000c10:	6605                	lui	a2,0x1
    80000c12:	4595                	li	a1,5
    80000c14:	8526                	mv	a0,s1
    80000c16:	00000097          	auipc	ra,0x0
    80000c1a:	1b2080e7          	jalr	434(ra) # 80000dc8 <memset>
  return (void*)r;
}
    80000c1e:	8526                	mv	a0,s1
    80000c20:	60e2                	ld	ra,24(sp)
    80000c22:	6442                	ld	s0,16(sp)
    80000c24:	64a2                	ld	s1,8(sp)
    80000c26:	6105                	add	sp,sp,32
    80000c28:	8082                	ret
  release(&kmem.lock);
    80000c2a:	00010517          	auipc	a0,0x10
    80000c2e:	de650513          	add	a0,a0,-538 # 80010a10 <kmem>
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	14e080e7          	jalr	334(ra) # 80000d80 <release>
  if(r)
    80000c3a:	b7d5                	j	80000c1e <kalloc+0x42>

0000000080000c3c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c3c:	1141                	add	sp,sp,-16
    80000c3e:	e422                	sd	s0,8(sp)
    80000c40:	0800                	add	s0,sp,16
  lk->name = name;
    80000c42:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c44:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c48:	00053823          	sd	zero,16(a0)
}
    80000c4c:	6422                	ld	s0,8(sp)
    80000c4e:	0141                	add	sp,sp,16
    80000c50:	8082                	ret

0000000080000c52 <holding>:
/* Interrupts must be off. */
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c52:	411c                	lw	a5,0(a0)
    80000c54:	e399                	bnez	a5,80000c5a <holding+0x8>
    80000c56:	4501                	li	a0,0
  return r;
}
    80000c58:	8082                	ret
{
    80000c5a:	1101                	add	sp,sp,-32
    80000c5c:	ec06                	sd	ra,24(sp)
    80000c5e:	e822                	sd	s0,16(sp)
    80000c60:	e426                	sd	s1,8(sp)
    80000c62:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c64:	6904                	ld	s1,16(a0)
    80000c66:	00001097          	auipc	ra,0x1
    80000c6a:	e76080e7          	jalr	-394(ra) # 80001adc <mycpu>
    80000c6e:	40a48533          	sub	a0,s1,a0
    80000c72:	00153513          	seqz	a0,a0
}
    80000c76:	60e2                	ld	ra,24(sp)
    80000c78:	6442                	ld	s0,16(sp)
    80000c7a:	64a2                	ld	s1,8(sp)
    80000c7c:	6105                	add	sp,sp,32
    80000c7e:	8082                	ret

0000000080000c80 <push_off>:
/* it takes two pop_off()s to undo two push_off()s.  Also, if interrupts */
/* are initially off, then push_off, pop_off leaves them off. */

void
push_off(void)
{
    80000c80:	1101                	add	sp,sp,-32
    80000c82:	ec06                	sd	ra,24(sp)
    80000c84:	e822                	sd	s0,16(sp)
    80000c86:	e426                	sd	s1,8(sp)
    80000c88:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c8a:	100024f3          	csrr	s1,sstatus
    80000c8e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c92:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c94:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c98:	00001097          	auipc	ra,0x1
    80000c9c:	e44080e7          	jalr	-444(ra) # 80001adc <mycpu>
    80000ca0:	5d3c                	lw	a5,120(a0)
    80000ca2:	cf89                	beqz	a5,80000cbc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ca4:	00001097          	auipc	ra,0x1
    80000ca8:	e38080e7          	jalr	-456(ra) # 80001adc <mycpu>
    80000cac:	5d3c                	lw	a5,120(a0)
    80000cae:	2785                	addw	a5,a5,1
    80000cb0:	dd3c                	sw	a5,120(a0)
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	add	sp,sp,32
    80000cba:	8082                	ret
    mycpu()->intena = old;
    80000cbc:	00001097          	auipc	ra,0x1
    80000cc0:	e20080e7          	jalr	-480(ra) # 80001adc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000cc4:	8085                	srl	s1,s1,0x1
    80000cc6:	8885                	and	s1,s1,1
    80000cc8:	dd64                	sw	s1,124(a0)
    80000cca:	bfe9                	j	80000ca4 <push_off+0x24>

0000000080000ccc <acquire>:
{
    80000ccc:	1101                	add	sp,sp,-32
    80000cce:	ec06                	sd	ra,24(sp)
    80000cd0:	e822                	sd	s0,16(sp)
    80000cd2:	e426                	sd	s1,8(sp)
    80000cd4:	1000                	add	s0,sp,32
    80000cd6:	84aa                	mv	s1,a0
  push_off(); /* disable interrupts to avoid deadlock. */
    80000cd8:	00000097          	auipc	ra,0x0
    80000cdc:	fa8080e7          	jalr	-88(ra) # 80000c80 <push_off>
  if(holding(lk))
    80000ce0:	8526                	mv	a0,s1
    80000ce2:	00000097          	auipc	ra,0x0
    80000ce6:	f70080e7          	jalr	-144(ra) # 80000c52 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cea:	4705                	li	a4,1
  if(holding(lk))
    80000cec:	e115                	bnez	a0,80000d10 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cee:	87ba                	mv	a5,a4
    80000cf0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000cf4:	2781                	sext.w	a5,a5
    80000cf6:	ffe5                	bnez	a5,80000cee <acquire+0x22>
  __sync_synchronize();
    80000cf8:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000cfc:	00001097          	auipc	ra,0x1
    80000d00:	de0080e7          	jalr	-544(ra) # 80001adc <mycpu>
    80000d04:	e888                	sd	a0,16(s1)
}
    80000d06:	60e2                	ld	ra,24(sp)
    80000d08:	6442                	ld	s0,16(sp)
    80000d0a:	64a2                	ld	s1,8(sp)
    80000d0c:	6105                	add	sp,sp,32
    80000d0e:	8082                	ret
    panic("acquire");
    80000d10:	00007517          	auipc	a0,0x7
    80000d14:	35850513          	add	a0,a0,856 # 80008068 <digits+0x30>
    80000d18:	00000097          	auipc	ra,0x0
    80000d1c:	af6080e7          	jalr	-1290(ra) # 8000080e <panic>

0000000080000d20 <pop_off>:

void
pop_off(void)
{
    80000d20:	1141                	add	sp,sp,-16
    80000d22:	e406                	sd	ra,8(sp)
    80000d24:	e022                	sd	s0,0(sp)
    80000d26:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000d28:	00001097          	auipc	ra,0x1
    80000d2c:	db4080e7          	jalr	-588(ra) # 80001adc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d30:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d34:	8b89                	and	a5,a5,2
  if(intr_get())
    80000d36:	e78d                	bnez	a5,80000d60 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d38:	5d3c                	lw	a5,120(a0)
    80000d3a:	02f05b63          	blez	a5,80000d70 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d3e:	37fd                	addw	a5,a5,-1
    80000d40:	0007871b          	sext.w	a4,a5
    80000d44:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d46:	eb09                	bnez	a4,80000d58 <pop_off+0x38>
    80000d48:	5d7c                	lw	a5,124(a0)
    80000d4a:	c799                	beqz	a5,80000d58 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d50:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d54:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d58:	60a2                	ld	ra,8(sp)
    80000d5a:	6402                	ld	s0,0(sp)
    80000d5c:	0141                	add	sp,sp,16
    80000d5e:	8082                	ret
    panic("pop_off - interruptible");
    80000d60:	00007517          	auipc	a0,0x7
    80000d64:	31050513          	add	a0,a0,784 # 80008070 <digits+0x38>
    80000d68:	00000097          	auipc	ra,0x0
    80000d6c:	aa6080e7          	jalr	-1370(ra) # 8000080e <panic>
    panic("pop_off");
    80000d70:	00007517          	auipc	a0,0x7
    80000d74:	31850513          	add	a0,a0,792 # 80008088 <digits+0x50>
    80000d78:	00000097          	auipc	ra,0x0
    80000d7c:	a96080e7          	jalr	-1386(ra) # 8000080e <panic>

0000000080000d80 <release>:
{
    80000d80:	1101                	add	sp,sp,-32
    80000d82:	ec06                	sd	ra,24(sp)
    80000d84:	e822                	sd	s0,16(sp)
    80000d86:	e426                	sd	s1,8(sp)
    80000d88:	1000                	add	s0,sp,32
    80000d8a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	ec6080e7          	jalr	-314(ra) # 80000c52 <holding>
    80000d94:	c115                	beqz	a0,80000db8 <release+0x38>
  lk->cpu = 0;
    80000d96:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d9a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d9e:	0f50000f          	fence	iorw,ow
    80000da2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000da6:	00000097          	auipc	ra,0x0
    80000daa:	f7a080e7          	jalr	-134(ra) # 80000d20 <pop_off>
}
    80000dae:	60e2                	ld	ra,24(sp)
    80000db0:	6442                	ld	s0,16(sp)
    80000db2:	64a2                	ld	s1,8(sp)
    80000db4:	6105                	add	sp,sp,32
    80000db6:	8082                	ret
    panic("release");
    80000db8:	00007517          	auipc	a0,0x7
    80000dbc:	2d850513          	add	a0,a0,728 # 80008090 <digits+0x58>
    80000dc0:	00000097          	auipc	ra,0x0
    80000dc4:	a4e080e7          	jalr	-1458(ra) # 8000080e <panic>

0000000080000dc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000dc8:	1141                	add	sp,sp,-16
    80000dca:	e422                	sd	s0,8(sp)
    80000dcc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000dce:	ca19                	beqz	a2,80000de4 <memset+0x1c>
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	1602                	sll	a2,a2,0x20
    80000dd4:	9201                	srl	a2,a2,0x20
    80000dd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000dda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000dde:	0785                	add	a5,a5,1
    80000de0:	fee79de3          	bne	a5,a4,80000dda <memset+0x12>
  }
  return dst;
}
    80000de4:	6422                	ld	s0,8(sp)
    80000de6:	0141                	add	sp,sp,16
    80000de8:	8082                	ret

0000000080000dea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000dea:	1141                	add	sp,sp,-16
    80000dec:	e422                	sd	s0,8(sp)
    80000dee:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000df0:	ca05                	beqz	a2,80000e20 <memcmp+0x36>
    80000df2:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000df6:	1682                	sll	a3,a3,0x20
    80000df8:	9281                	srl	a3,a3,0x20
    80000dfa:	0685                	add	a3,a3,1
    80000dfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000dfe:	00054783          	lbu	a5,0(a0)
    80000e02:	0005c703          	lbu	a4,0(a1)
    80000e06:	00e79863          	bne	a5,a4,80000e16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e0a:	0505                	add	a0,a0,1
    80000e0c:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000e0e:	fed518e3          	bne	a0,a3,80000dfe <memcmp+0x14>
  }

  return 0;
    80000e12:	4501                	li	a0,0
    80000e14:	a019                	j	80000e1a <memcmp+0x30>
      return *s1 - *s2;
    80000e16:	40e7853b          	subw	a0,a5,a4
}
    80000e1a:	6422                	ld	s0,8(sp)
    80000e1c:	0141                	add	sp,sp,16
    80000e1e:	8082                	ret
  return 0;
    80000e20:	4501                	li	a0,0
    80000e22:	bfe5                	j	80000e1a <memcmp+0x30>

0000000080000e24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e24:	1141                	add	sp,sp,-16
    80000e26:	e422                	sd	s0,8(sp)
    80000e28:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e2a:	c205                	beqz	a2,80000e4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e2c:	02a5e263          	bltu	a1,a0,80000e50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e30:	1602                	sll	a2,a2,0x20
    80000e32:	9201                	srl	a2,a2,0x20
    80000e34:	00c587b3          	add	a5,a1,a2
{
    80000e38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e3a:	0585                	add	a1,a1,1
    80000e3c:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd3c1>
    80000e3e:	fff5c683          	lbu	a3,-1(a1)
    80000e42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e46:	fef59ae3          	bne	a1,a5,80000e3a <memmove+0x16>

  return dst;
}
    80000e4a:	6422                	ld	s0,8(sp)
    80000e4c:	0141                	add	sp,sp,16
    80000e4e:	8082                	ret
  if(s < d && s + n > d){
    80000e50:	02061693          	sll	a3,a2,0x20
    80000e54:	9281                	srl	a3,a3,0x20
    80000e56:	00d58733          	add	a4,a1,a3
    80000e5a:	fce57be3          	bgeu	a0,a4,80000e30 <memmove+0xc>
    d += n;
    80000e5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000e60:	fff6079b          	addw	a5,a2,-1
    80000e64:	1782                	sll	a5,a5,0x20
    80000e66:	9381                	srl	a5,a5,0x20
    80000e68:	fff7c793          	not	a5,a5
    80000e6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e6e:	177d                	add	a4,a4,-1
    80000e70:	16fd                	add	a3,a3,-1
    80000e72:	00074603          	lbu	a2,0(a4)
    80000e76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e7a:	fee79ae3          	bne	a5,a4,80000e6e <memmove+0x4a>
    80000e7e:	b7f1                	j	80000e4a <memmove+0x26>

0000000080000e80 <memcpy>:

/* memcpy exists to placate GCC.  Use memmove. */
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e80:	1141                	add	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	f9c080e7          	jalr	-100(ra) # 80000e24 <memmove>
}
    80000e90:	60a2                	ld	ra,8(sp)
    80000e92:	6402                	ld	s0,0(sp)
    80000e94:	0141                	add	sp,sp,16
    80000e96:	8082                	ret

0000000080000e98 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e98:	1141                	add	sp,sp,-16
    80000e9a:	e422                	sd	s0,8(sp)
    80000e9c:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e9e:	ce11                	beqz	a2,80000eba <strncmp+0x22>
    80000ea0:	00054783          	lbu	a5,0(a0)
    80000ea4:	cf89                	beqz	a5,80000ebe <strncmp+0x26>
    80000ea6:	0005c703          	lbu	a4,0(a1)
    80000eaa:	00f71a63          	bne	a4,a5,80000ebe <strncmp+0x26>
    n--, p++, q++;
    80000eae:	367d                	addw	a2,a2,-1
    80000eb0:	0505                	add	a0,a0,1
    80000eb2:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000eb4:	f675                	bnez	a2,80000ea0 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000eb6:	4501                	li	a0,0
    80000eb8:	a809                	j	80000eca <strncmp+0x32>
    80000eba:	4501                	li	a0,0
    80000ebc:	a039                	j	80000eca <strncmp+0x32>
  if(n == 0)
    80000ebe:	ca09                	beqz	a2,80000ed0 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000ec0:	00054503          	lbu	a0,0(a0)
    80000ec4:	0005c783          	lbu	a5,0(a1)
    80000ec8:	9d1d                	subw	a0,a0,a5
}
    80000eca:	6422                	ld	s0,8(sp)
    80000ecc:	0141                	add	sp,sp,16
    80000ece:	8082                	ret
    return 0;
    80000ed0:	4501                	li	a0,0
    80000ed2:	bfe5                	j	80000eca <strncmp+0x32>

0000000080000ed4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000ed4:	1141                	add	sp,sp,-16
    80000ed6:	e422                	sd	s0,8(sp)
    80000ed8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000eda:	87aa                	mv	a5,a0
    80000edc:	86b2                	mv	a3,a2
    80000ede:	367d                	addw	a2,a2,-1
    80000ee0:	00d05963          	blez	a3,80000ef2 <strncpy+0x1e>
    80000ee4:	0785                	add	a5,a5,1
    80000ee6:	0005c703          	lbu	a4,0(a1)
    80000eea:	fee78fa3          	sb	a4,-1(a5)
    80000eee:	0585                	add	a1,a1,1
    80000ef0:	f775                	bnez	a4,80000edc <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ef2:	873e                	mv	a4,a5
    80000ef4:	9fb5                	addw	a5,a5,a3
    80000ef6:	37fd                	addw	a5,a5,-1
    80000ef8:	00c05963          	blez	a2,80000f0a <strncpy+0x36>
    *s++ = 0;
    80000efc:	0705                	add	a4,a4,1
    80000efe:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f02:	40e786bb          	subw	a3,a5,a4
    80000f06:	fed04be3          	bgtz	a3,80000efc <strncpy+0x28>
  return os;
}
    80000f0a:	6422                	ld	s0,8(sp)
    80000f0c:	0141                	add	sp,sp,16
    80000f0e:	8082                	ret

0000000080000f10 <safestrcpy>:

/* Like strncpy but guaranteed to NUL-terminate. */
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f10:	1141                	add	sp,sp,-16
    80000f12:	e422                	sd	s0,8(sp)
    80000f14:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f16:	02c05363          	blez	a2,80000f3c <safestrcpy+0x2c>
    80000f1a:	fff6069b          	addw	a3,a2,-1
    80000f1e:	1682                	sll	a3,a3,0x20
    80000f20:	9281                	srl	a3,a3,0x20
    80000f22:	96ae                	add	a3,a3,a1
    80000f24:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f26:	00d58963          	beq	a1,a3,80000f38 <safestrcpy+0x28>
    80000f2a:	0585                	add	a1,a1,1
    80000f2c:	0785                	add	a5,a5,1
    80000f2e:	fff5c703          	lbu	a4,-1(a1)
    80000f32:	fee78fa3          	sb	a4,-1(a5)
    80000f36:	fb65                	bnez	a4,80000f26 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f38:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f3c:	6422                	ld	s0,8(sp)
    80000f3e:	0141                	add	sp,sp,16
    80000f40:	8082                	ret

0000000080000f42 <strlen>:

int
strlen(const char *s)
{
    80000f42:	1141                	add	sp,sp,-16
    80000f44:	e422                	sd	s0,8(sp)
    80000f46:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f48:	00054783          	lbu	a5,0(a0)
    80000f4c:	cf91                	beqz	a5,80000f68 <strlen+0x26>
    80000f4e:	0505                	add	a0,a0,1
    80000f50:	87aa                	mv	a5,a0
    80000f52:	86be                	mv	a3,a5
    80000f54:	0785                	add	a5,a5,1
    80000f56:	fff7c703          	lbu	a4,-1(a5)
    80000f5a:	ff65                	bnez	a4,80000f52 <strlen+0x10>
    80000f5c:	40a6853b          	subw	a0,a3,a0
    80000f60:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000f62:	6422                	ld	s0,8(sp)
    80000f64:	0141                	add	sp,sp,16
    80000f66:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f68:	4501                	li	a0,0
    80000f6a:	bfe5                	j	80000f62 <strlen+0x20>

0000000080000f6c <main>:
volatile static int started = 0;

/* start() jumps here in supervisor mode on all CPUs. */
void
main()
{
    80000f6c:	1141                	add	sp,sp,-16
    80000f6e:	e406                	sd	ra,8(sp)
    80000f70:	e022                	sd	s0,0(sp)
    80000f72:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	b58080e7          	jalr	-1192(ra) # 80001acc <cpuid>
    virtio_disk_init(); /* emulated hard disk */
    userinit();      /* first user process */
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f7c:	00008717          	auipc	a4,0x8
    80000f80:	96c70713          	add	a4,a4,-1684 # 800088e8 <started>
  if(cpuid() == 0){
    80000f84:	c139                	beqz	a0,80000fca <main+0x5e>
    while(started == 0)
    80000f86:	431c                	lw	a5,0(a4)
    80000f88:	2781                	sext.w	a5,a5
    80000f8a:	dff5                	beqz	a5,80000f86 <main+0x1a>
      ;
    __sync_synchronize();
    80000f8c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f90:	00001097          	auipc	ra,0x1
    80000f94:	b3c080e7          	jalr	-1220(ra) # 80001acc <cpuid>
    80000f98:	85aa                	mv	a1,a0
    80000f9a:	00007517          	auipc	a0,0x7
    80000f9e:	11650513          	add	a0,a0,278 # 800080b0 <digits+0x78>
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	560080e7          	jalr	1376(ra) # 80000502 <printf>
    kvminithart();    /* turn on paging */
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	0d8080e7          	jalr	216(ra) # 80001082 <kvminithart>
    trapinithart();   /* install kernel trap vector */
    80000fb2:	00002097          	auipc	ra,0x2
    80000fb6:	808080e7          	jalr	-2040(ra) # 800027ba <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	cca080e7          	jalr	-822(ra) # 80005c84 <plicinithart>
  }

  scheduler();        
    80000fc2:	00001097          	auipc	ra,0x1
    80000fc6:	030080e7          	jalr	48(ra) # 80001ff2 <scheduler>
    consoleinit();
    80000fca:	fffff097          	auipc	ra,0xfffff
    80000fce:	456080e7          	jalr	1110(ra) # 80000420 <consoleinit>
    printfinit();
    80000fd2:	00000097          	auipc	ra,0x0
    80000fd6:	87e080e7          	jalr	-1922(ra) # 80000850 <printfinit>
    printf("\n");
    80000fda:	00007517          	auipc	a0,0x7
    80000fde:	0e650513          	add	a0,a0,230 # 800080c0 <digits+0x88>
    80000fe2:	fffff097          	auipc	ra,0xfffff
    80000fe6:	520080e7          	jalr	1312(ra) # 80000502 <printf>
    printf("xv6 kernel is booting\n");
    80000fea:	00007517          	auipc	a0,0x7
    80000fee:	0ae50513          	add	a0,a0,174 # 80008098 <digits+0x60>
    80000ff2:	fffff097          	auipc	ra,0xfffff
    80000ff6:	510080e7          	jalr	1296(ra) # 80000502 <printf>
    printf("\n");
    80000ffa:	00007517          	auipc	a0,0x7
    80000ffe:	0c650513          	add	a0,a0,198 # 800080c0 <digits+0x88>
    80001002:	fffff097          	auipc	ra,0xfffff
    80001006:	500080e7          	jalr	1280(ra) # 80000502 <printf>
    kinit();         /* physical page allocator */
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	b96080e7          	jalr	-1130(ra) # 80000ba0 <kinit>
    kvminit();       /* create kernel page table */
    80001012:	00000097          	auipc	ra,0x0
    80001016:	34a080e7          	jalr	842(ra) # 8000135c <kvminit>
    kvminithart();   /* turn on paging */
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	068080e7          	jalr	104(ra) # 80001082 <kvminithart>
    procinit();      /* process table */
    80001022:	00001097          	auipc	ra,0x1
    80001026:	9f6080e7          	jalr	-1546(ra) # 80001a18 <procinit>
    trapinit();      /* trap vectors */
    8000102a:	00001097          	auipc	ra,0x1
    8000102e:	768080e7          	jalr	1896(ra) # 80002792 <trapinit>
    trapinithart();  /* install kernel trap vector */
    80001032:	00001097          	auipc	ra,0x1
    80001036:	788080e7          	jalr	1928(ra) # 800027ba <trapinithart>
    plicinit();      /* set up interrupt controller */
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	c34080e7          	jalr	-972(ra) # 80005c6e <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80001042:	00005097          	auipc	ra,0x5
    80001046:	c42080e7          	jalr	-958(ra) # 80005c84 <plicinithart>
    binit();         /* buffer cache */
    8000104a:	00002097          	auipc	ra,0x2
    8000104e:	e9e080e7          	jalr	-354(ra) # 80002ee8 <binit>
    iinit();         /* inode table */
    80001052:	00002097          	auipc	ra,0x2
    80001056:	53c080e7          	jalr	1340(ra) # 8000358e <iinit>
    fileinit();      /* file table */
    8000105a:	00003097          	auipc	ra,0x3
    8000105e:	4b2080e7          	jalr	1202(ra) # 8000450c <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80001062:	00005097          	auipc	ra,0x5
    80001066:	d2a080e7          	jalr	-726(ra) # 80005d8c <virtio_disk_init>
    userinit();      /* first user process */
    8000106a:	00001097          	auipc	ra,0x1
    8000106e:	d6a080e7          	jalr	-662(ra) # 80001dd4 <userinit>
    __sync_synchronize();
    80001072:	0ff0000f          	fence
    started = 1;
    80001076:	4785                	li	a5,1
    80001078:	00008717          	auipc	a4,0x8
    8000107c:	86f72823          	sw	a5,-1936(a4) # 800088e8 <started>
    80001080:	b789                	j	80000fc2 <main+0x56>

0000000080001082 <kvminithart>:

/* Switch h/w page table register to the kernel's page table, */
/* and enable paging. */
void
kvminithart()
{
    80001082:	1141                	add	sp,sp,-16
    80001084:	e422                	sd	s0,8(sp)
    80001086:	0800                	add	s0,sp,16
/* flush the TLB. */
static inline void
sfence_vma()
{
  /* the zero, zero means flush all TLB entries. */
  asm volatile("sfence.vma zero, zero");
    80001088:	12000073          	sfence.vma
  /* wait for any previous writes to the page table memory to finish. */
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000108c:	00008797          	auipc	a5,0x8
    80001090:	8647b783          	ld	a5,-1948(a5) # 800088f0 <kernel_pagetable>
    80001094:	83b1                	srl	a5,a5,0xc
    80001096:	577d                	li	a4,-1
    80001098:	177e                	sll	a4,a4,0x3f
    8000109a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000109c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800010a0:	12000073          	sfence.vma

  /* flush stale entries from the TLB. */
  sfence_vma();
}
    800010a4:	6422                	ld	s0,8(sp)
    800010a6:	0141                	add	sp,sp,16
    800010a8:	8082                	ret

00000000800010aa <walk>:
/*   21..29 -- 9 bits of level-1 index. */
/*   12..20 -- 9 bits of level-0 index. */
/*    0..11 -- 12 bits of byte offset within the page. */
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800010aa:	7139                	add	sp,sp,-64
    800010ac:	fc06                	sd	ra,56(sp)
    800010ae:	f822                	sd	s0,48(sp)
    800010b0:	f426                	sd	s1,40(sp)
    800010b2:	f04a                	sd	s2,32(sp)
    800010b4:	ec4e                	sd	s3,24(sp)
    800010b6:	e852                	sd	s4,16(sp)
    800010b8:	e456                	sd	s5,8(sp)
    800010ba:	e05a                	sd	s6,0(sp)
    800010bc:	0080                	add	s0,sp,64
    800010be:	84aa                	mv	s1,a0
    800010c0:	89ae                	mv	s3,a1
    800010c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800010c4:	57fd                	li	a5,-1
    800010c6:	83e9                	srl	a5,a5,0x1a
    800010c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010cc:	04b7f263          	bgeu	a5,a1,80001110 <walk+0x66>
    panic("walk");
    800010d0:	00007517          	auipc	a0,0x7
    800010d4:	ff850513          	add	a0,a0,-8 # 800080c8 <digits+0x90>
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	736080e7          	jalr	1846(ra) # 8000080e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010e0:	060a8663          	beqz	s5,8000114c <walk+0xa2>
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	af8080e7          	jalr	-1288(ra) # 80000bdc <kalloc>
    800010ec:	84aa                	mv	s1,a0
    800010ee:	c529                	beqz	a0,80001138 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010f0:	6605                	lui	a2,0x1
    800010f2:	4581                	li	a1,0
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	cd4080e7          	jalr	-812(ra) # 80000dc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010fc:	00c4d793          	srl	a5,s1,0xc
    80001100:	07aa                	sll	a5,a5,0xa
    80001102:	0017e793          	or	a5,a5,1
    80001106:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000110a:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd3b7>
    8000110c:	036a0063          	beq	s4,s6,8000112c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001110:	0149d933          	srl	s2,s3,s4
    80001114:	1ff97913          	and	s2,s2,511
    80001118:	090e                	sll	s2,s2,0x3
    8000111a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000111c:	00093483          	ld	s1,0(s2)
    80001120:	0014f793          	and	a5,s1,1
    80001124:	dfd5                	beqz	a5,800010e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001126:	80a9                	srl	s1,s1,0xa
    80001128:	04b2                	sll	s1,s1,0xc
    8000112a:	b7c5                	j	8000110a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000112c:	00c9d513          	srl	a0,s3,0xc
    80001130:	1ff57513          	and	a0,a0,511
    80001134:	050e                	sll	a0,a0,0x3
    80001136:	9526                	add	a0,a0,s1
}
    80001138:	70e2                	ld	ra,56(sp)
    8000113a:	7442                	ld	s0,48(sp)
    8000113c:	74a2                	ld	s1,40(sp)
    8000113e:	7902                	ld	s2,32(sp)
    80001140:	69e2                	ld	s3,24(sp)
    80001142:	6a42                	ld	s4,16(sp)
    80001144:	6aa2                	ld	s5,8(sp)
    80001146:	6b02                	ld	s6,0(sp)
    80001148:	6121                	add	sp,sp,64
    8000114a:	8082                	ret
        return 0;
    8000114c:	4501                	li	a0,0
    8000114e:	b7ed                	j	80001138 <walk+0x8e>

0000000080001150 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001150:	57fd                	li	a5,-1
    80001152:	83e9                	srl	a5,a5,0x1a
    80001154:	00b7f463          	bgeu	a5,a1,8000115c <walkaddr+0xc>
    return 0;
    80001158:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000115a:	8082                	ret
{
    8000115c:	1141                	add	sp,sp,-16
    8000115e:	e406                	sd	ra,8(sp)
    80001160:	e022                	sd	s0,0(sp)
    80001162:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001164:	4601                	li	a2,0
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	f44080e7          	jalr	-188(ra) # 800010aa <walk>
  if(pte == 0)
    8000116e:	c105                	beqz	a0,8000118e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001170:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001172:	0117f693          	and	a3,a5,17
    80001176:	4745                	li	a4,17
    return 0;
    80001178:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000117a:	00e68663          	beq	a3,a4,80001186 <walkaddr+0x36>
}
    8000117e:	60a2                	ld	ra,8(sp)
    80001180:	6402                	ld	s0,0(sp)
    80001182:	0141                	add	sp,sp,16
    80001184:	8082                	ret
  pa = PTE2PA(*pte);
    80001186:	83a9                	srl	a5,a5,0xa
    80001188:	00c79513          	sll	a0,a5,0xc
  return pa;
    8000118c:	bfcd                	j	8000117e <walkaddr+0x2e>
    return 0;
    8000118e:	4501                	li	a0,0
    80001190:	b7fd                	j	8000117e <walkaddr+0x2e>

0000000080001192 <mappages>:
/* va and size MUST be page-aligned. */
/* Returns 0 on success, -1 if walk() couldn't */
/* allocate a needed page-table page. */
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001192:	715d                	add	sp,sp,-80
    80001194:	e486                	sd	ra,72(sp)
    80001196:	e0a2                	sd	s0,64(sp)
    80001198:	fc26                	sd	s1,56(sp)
    8000119a:	f84a                	sd	s2,48(sp)
    8000119c:	f44e                	sd	s3,40(sp)
    8000119e:	f052                	sd	s4,32(sp)
    800011a0:	ec56                	sd	s5,24(sp)
    800011a2:	e85a                	sd	s6,16(sp)
    800011a4:	e45e                	sd	s7,8(sp)
    800011a6:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011a8:	03459793          	sll	a5,a1,0x34
    800011ac:	e7b9                	bnez	a5,800011fa <mappages+0x68>
    800011ae:	8aaa                	mv	s5,a0
    800011b0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800011b2:	03461793          	sll	a5,a2,0x34
    800011b6:	ebb1                	bnez	a5,8000120a <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    800011b8:	c22d                	beqz	a2,8000121a <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800011ba:	77fd                	lui	a5,0xfffff
    800011bc:	963e                	add	a2,a2,a5
    800011be:	00b609b3          	add	s3,a2,a1
  a = va;
    800011c2:	892e                	mv	s2,a1
    800011c4:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011c8:	6b85                	lui	s7,0x1
    800011ca:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011ce:	4605                	li	a2,1
    800011d0:	85ca                	mv	a1,s2
    800011d2:	8556                	mv	a0,s5
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	ed6080e7          	jalr	-298(ra) # 800010aa <walk>
    800011dc:	cd39                	beqz	a0,8000123a <mappages+0xa8>
    if(*pte & PTE_V)
    800011de:	611c                	ld	a5,0(a0)
    800011e0:	8b85                	and	a5,a5,1
    800011e2:	e7a1                	bnez	a5,8000122a <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011e4:	80b1                	srl	s1,s1,0xc
    800011e6:	04aa                	sll	s1,s1,0xa
    800011e8:	0164e4b3          	or	s1,s1,s6
    800011ec:	0014e493          	or	s1,s1,1
    800011f0:	e104                	sd	s1,0(a0)
    if(a == last)
    800011f2:	07390063          	beq	s2,s3,80001252 <mappages+0xc0>
    a += PGSIZE;
    800011f6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011f8:	bfc9                	j	800011ca <mappages+0x38>
    panic("mappages: va not aligned");
    800011fa:	00007517          	auipc	a0,0x7
    800011fe:	ed650513          	add	a0,a0,-298 # 800080d0 <digits+0x98>
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	60c080e7          	jalr	1548(ra) # 8000080e <panic>
    panic("mappages: size not aligned");
    8000120a:	00007517          	auipc	a0,0x7
    8000120e:	ee650513          	add	a0,a0,-282 # 800080f0 <digits+0xb8>
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	5fc080e7          	jalr	1532(ra) # 8000080e <panic>
    panic("mappages: size");
    8000121a:	00007517          	auipc	a0,0x7
    8000121e:	ef650513          	add	a0,a0,-266 # 80008110 <digits+0xd8>
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	5ec080e7          	jalr	1516(ra) # 8000080e <panic>
      panic("mappages: remap");
    8000122a:	00007517          	auipc	a0,0x7
    8000122e:	ef650513          	add	a0,a0,-266 # 80008120 <digits+0xe8>
    80001232:	fffff097          	auipc	ra,0xfffff
    80001236:	5dc080e7          	jalr	1500(ra) # 8000080e <panic>
      return -1;
    8000123a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000123c:	60a6                	ld	ra,72(sp)
    8000123e:	6406                	ld	s0,64(sp)
    80001240:	74e2                	ld	s1,56(sp)
    80001242:	7942                	ld	s2,48(sp)
    80001244:	79a2                	ld	s3,40(sp)
    80001246:	7a02                	ld	s4,32(sp)
    80001248:	6ae2                	ld	s5,24(sp)
    8000124a:	6b42                	ld	s6,16(sp)
    8000124c:	6ba2                	ld	s7,8(sp)
    8000124e:	6161                	add	sp,sp,80
    80001250:	8082                	ret
  return 0;
    80001252:	4501                	li	a0,0
    80001254:	b7e5                	j	8000123c <mappages+0xaa>

0000000080001256 <kvmmap>:
{
    80001256:	1141                	add	sp,sp,-16
    80001258:	e406                	sd	ra,8(sp)
    8000125a:	e022                	sd	s0,0(sp)
    8000125c:	0800                	add	s0,sp,16
    8000125e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001260:	86b2                	mv	a3,a2
    80001262:	863e                	mv	a2,a5
    80001264:	00000097          	auipc	ra,0x0
    80001268:	f2e080e7          	jalr	-210(ra) # 80001192 <mappages>
    8000126c:	e509                	bnez	a0,80001276 <kvmmap+0x20>
}
    8000126e:	60a2                	ld	ra,8(sp)
    80001270:	6402                	ld	s0,0(sp)
    80001272:	0141                	add	sp,sp,16
    80001274:	8082                	ret
    panic("kvmmap");
    80001276:	00007517          	auipc	a0,0x7
    8000127a:	eba50513          	add	a0,a0,-326 # 80008130 <digits+0xf8>
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	590080e7          	jalr	1424(ra) # 8000080e <panic>

0000000080001286 <kvmmake>:
{
    80001286:	1101                	add	sp,sp,-32
    80001288:	ec06                	sd	ra,24(sp)
    8000128a:	e822                	sd	s0,16(sp)
    8000128c:	e426                	sd	s1,8(sp)
    8000128e:	e04a                	sd	s2,0(sp)
    80001290:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001292:	00000097          	auipc	ra,0x0
    80001296:	94a080e7          	jalr	-1718(ra) # 80000bdc <kalloc>
    8000129a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000129c:	6605                	lui	a2,0x1
    8000129e:	4581                	li	a1,0
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	b28080e7          	jalr	-1240(ra) # 80000dc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012a8:	4719                	li	a4,6
    800012aa:	6685                	lui	a3,0x1
    800012ac:	10000637          	lui	a2,0x10000
    800012b0:	100005b7          	lui	a1,0x10000
    800012b4:	8526                	mv	a0,s1
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	fa0080e7          	jalr	-96(ra) # 80001256 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012be:	4719                	li	a4,6
    800012c0:	6685                	lui	a3,0x1
    800012c2:	10001637          	lui	a2,0x10001
    800012c6:	100015b7          	lui	a1,0x10001
    800012ca:	8526                	mv	a0,s1
    800012cc:	00000097          	auipc	ra,0x0
    800012d0:	f8a080e7          	jalr	-118(ra) # 80001256 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800012d4:	4719                	li	a4,6
    800012d6:	040006b7          	lui	a3,0x4000
    800012da:	0c000637          	lui	a2,0xc000
    800012de:	0c0005b7          	lui	a1,0xc000
    800012e2:	8526                	mv	a0,s1
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	f72080e7          	jalr	-142(ra) # 80001256 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012ec:	00007917          	auipc	s2,0x7
    800012f0:	d1490913          	add	s2,s2,-748 # 80008000 <etext>
    800012f4:	4729                	li	a4,10
    800012f6:	80007697          	auipc	a3,0x80007
    800012fa:	d0a68693          	add	a3,a3,-758 # 8000 <_entry-0x7fff8000>
    800012fe:	4605                	li	a2,1
    80001300:	067e                	sll	a2,a2,0x1f
    80001302:	85b2                	mv	a1,a2
    80001304:	8526                	mv	a0,s1
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	f50080e7          	jalr	-176(ra) # 80001256 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000130e:	4719                	li	a4,6
    80001310:	46c5                	li	a3,17
    80001312:	06ee                	sll	a3,a3,0x1b
    80001314:	412686b3          	sub	a3,a3,s2
    80001318:	864a                	mv	a2,s2
    8000131a:	85ca                	mv	a1,s2
    8000131c:	8526                	mv	a0,s1
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	f38080e7          	jalr	-200(ra) # 80001256 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001326:	4729                	li	a4,10
    80001328:	6685                	lui	a3,0x1
    8000132a:	00006617          	auipc	a2,0x6
    8000132e:	cd660613          	add	a2,a2,-810 # 80007000 <_trampoline>
    80001332:	040005b7          	lui	a1,0x4000
    80001336:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001338:	05b2                	sll	a1,a1,0xc
    8000133a:	8526                	mv	a0,s1
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	f1a080e7          	jalr	-230(ra) # 80001256 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001344:	8526                	mv	a0,s1
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	63c080e7          	jalr	1596(ra) # 80001982 <proc_mapstacks>
}
    8000134e:	8526                	mv	a0,s1
    80001350:	60e2                	ld	ra,24(sp)
    80001352:	6442                	ld	s0,16(sp)
    80001354:	64a2                	ld	s1,8(sp)
    80001356:	6902                	ld	s2,0(sp)
    80001358:	6105                	add	sp,sp,32
    8000135a:	8082                	ret

000000008000135c <kvminit>:
{
    8000135c:	1141                	add	sp,sp,-16
    8000135e:	e406                	sd	ra,8(sp)
    80001360:	e022                	sd	s0,0(sp)
    80001362:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001364:	00000097          	auipc	ra,0x0
    80001368:	f22080e7          	jalr	-222(ra) # 80001286 <kvmmake>
    8000136c:	00007797          	auipc	a5,0x7
    80001370:	58a7b223          	sd	a0,1412(a5) # 800088f0 <kernel_pagetable>
}
    80001374:	60a2                	ld	ra,8(sp)
    80001376:	6402                	ld	s0,0(sp)
    80001378:	0141                	add	sp,sp,16
    8000137a:	8082                	ret

000000008000137c <uvmunmap>:
/* Remove npages of mappings starting from va. va must be */
/* page-aligned. The mappings must exist. */
/* Optionally free the physical memory. */
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000137c:	715d                	add	sp,sp,-80
    8000137e:	e486                	sd	ra,72(sp)
    80001380:	e0a2                	sd	s0,64(sp)
    80001382:	fc26                	sd	s1,56(sp)
    80001384:	f84a                	sd	s2,48(sp)
    80001386:	f44e                	sd	s3,40(sp)
    80001388:	f052                	sd	s4,32(sp)
    8000138a:	ec56                	sd	s5,24(sp)
    8000138c:	e85a                	sd	s6,16(sp)
    8000138e:	e45e                	sd	s7,8(sp)
    80001390:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001392:	03459793          	sll	a5,a1,0x34
    80001396:	e795                	bnez	a5,800013c2 <uvmunmap+0x46>
    80001398:	8a2a                	mv	s4,a0
    8000139a:	892e                	mv	s2,a1
    8000139c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000139e:	0632                	sll	a2,a2,0xc
    800013a0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800013a4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013a6:	6b05                	lui	s6,0x1
    800013a8:	0735e263          	bltu	a1,s3,8000140c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800013ac:	60a6                	ld	ra,72(sp)
    800013ae:	6406                	ld	s0,64(sp)
    800013b0:	74e2                	ld	s1,56(sp)
    800013b2:	7942                	ld	s2,48(sp)
    800013b4:	79a2                	ld	s3,40(sp)
    800013b6:	7a02                	ld	s4,32(sp)
    800013b8:	6ae2                	ld	s5,24(sp)
    800013ba:	6b42                	ld	s6,16(sp)
    800013bc:	6ba2                	ld	s7,8(sp)
    800013be:	6161                	add	sp,sp,80
    800013c0:	8082                	ret
    panic("uvmunmap: not aligned");
    800013c2:	00007517          	auipc	a0,0x7
    800013c6:	d7650513          	add	a0,a0,-650 # 80008138 <digits+0x100>
    800013ca:	fffff097          	auipc	ra,0xfffff
    800013ce:	444080e7          	jalr	1092(ra) # 8000080e <panic>
      panic("uvmunmap: walk");
    800013d2:	00007517          	auipc	a0,0x7
    800013d6:	d7e50513          	add	a0,a0,-642 # 80008150 <digits+0x118>
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	434080e7          	jalr	1076(ra) # 8000080e <panic>
      panic("uvmunmap: not mapped");
    800013e2:	00007517          	auipc	a0,0x7
    800013e6:	d7e50513          	add	a0,a0,-642 # 80008160 <digits+0x128>
    800013ea:	fffff097          	auipc	ra,0xfffff
    800013ee:	424080e7          	jalr	1060(ra) # 8000080e <panic>
      panic("uvmunmap: not a leaf");
    800013f2:	00007517          	auipc	a0,0x7
    800013f6:	d8650513          	add	a0,a0,-634 # 80008178 <digits+0x140>
    800013fa:	fffff097          	auipc	ra,0xfffff
    800013fe:	414080e7          	jalr	1044(ra) # 8000080e <panic>
    *pte = 0;
    80001402:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001406:	995a                	add	s2,s2,s6
    80001408:	fb3972e3          	bgeu	s2,s3,800013ac <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000140c:	4601                	li	a2,0
    8000140e:	85ca                	mv	a1,s2
    80001410:	8552                	mv	a0,s4
    80001412:	00000097          	auipc	ra,0x0
    80001416:	c98080e7          	jalr	-872(ra) # 800010aa <walk>
    8000141a:	84aa                	mv	s1,a0
    8000141c:	d95d                	beqz	a0,800013d2 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000141e:	6108                	ld	a0,0(a0)
    80001420:	00157793          	and	a5,a0,1
    80001424:	dfdd                	beqz	a5,800013e2 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001426:	3ff57793          	and	a5,a0,1023
    8000142a:	fd7784e3          	beq	a5,s7,800013f2 <uvmunmap+0x76>
    if(do_free){
    8000142e:	fc0a8ae3          	beqz	s5,80001402 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001432:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001434:	0532                	sll	a0,a0,0xc
    80001436:	fffff097          	auipc	ra,0xfffff
    8000143a:	6a8080e7          	jalr	1704(ra) # 80000ade <kfree>
    8000143e:	b7d1                	j	80001402 <uvmunmap+0x86>

0000000080001440 <uvmcreate>:

/* create an empty user page table. */
/* returns 0 if out of memory. */
pagetable_t
uvmcreate()
{
    80001440:	1101                	add	sp,sp,-32
    80001442:	ec06                	sd	ra,24(sp)
    80001444:	e822                	sd	s0,16(sp)
    80001446:	e426                	sd	s1,8(sp)
    80001448:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000144a:	fffff097          	auipc	ra,0xfffff
    8000144e:	792080e7          	jalr	1938(ra) # 80000bdc <kalloc>
    80001452:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001454:	c519                	beqz	a0,80001462 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001456:	6605                	lui	a2,0x1
    80001458:	4581                	li	a1,0
    8000145a:	00000097          	auipc	ra,0x0
    8000145e:	96e080e7          	jalr	-1682(ra) # 80000dc8 <memset>
  return pagetable;
}
    80001462:	8526                	mv	a0,s1
    80001464:	60e2                	ld	ra,24(sp)
    80001466:	6442                	ld	s0,16(sp)
    80001468:	64a2                	ld	s1,8(sp)
    8000146a:	6105                	add	sp,sp,32
    8000146c:	8082                	ret

000000008000146e <uvmfirst>:
/* Load the user initcode into address 0 of pagetable, */
/* for the very first process. */
/* sz must be less than a page. */
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000146e:	7179                	add	sp,sp,-48
    80001470:	f406                	sd	ra,40(sp)
    80001472:	f022                	sd	s0,32(sp)
    80001474:	ec26                	sd	s1,24(sp)
    80001476:	e84a                	sd	s2,16(sp)
    80001478:	e44e                	sd	s3,8(sp)
    8000147a:	e052                	sd	s4,0(sp)
    8000147c:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000147e:	6785                	lui	a5,0x1
    80001480:	04f67863          	bgeu	a2,a5,800014d0 <uvmfirst+0x62>
    80001484:	8a2a                	mv	s4,a0
    80001486:	89ae                	mv	s3,a1
    80001488:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000148a:	fffff097          	auipc	ra,0xfffff
    8000148e:	752080e7          	jalr	1874(ra) # 80000bdc <kalloc>
    80001492:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001494:	6605                	lui	a2,0x1
    80001496:	4581                	li	a1,0
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	930080e7          	jalr	-1744(ra) # 80000dc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014a0:	4779                	li	a4,30
    800014a2:	86ca                	mv	a3,s2
    800014a4:	6605                	lui	a2,0x1
    800014a6:	4581                	li	a1,0
    800014a8:	8552                	mv	a0,s4
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	ce8080e7          	jalr	-792(ra) # 80001192 <mappages>
  memmove(mem, src, sz);
    800014b2:	8626                	mv	a2,s1
    800014b4:	85ce                	mv	a1,s3
    800014b6:	854a                	mv	a0,s2
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	96c080e7          	jalr	-1684(ra) # 80000e24 <memmove>
}
    800014c0:	70a2                	ld	ra,40(sp)
    800014c2:	7402                	ld	s0,32(sp)
    800014c4:	64e2                	ld	s1,24(sp)
    800014c6:	6942                	ld	s2,16(sp)
    800014c8:	69a2                	ld	s3,8(sp)
    800014ca:	6a02                	ld	s4,0(sp)
    800014cc:	6145                	add	sp,sp,48
    800014ce:	8082                	ret
    panic("uvmfirst: more than a page");
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	cc050513          	add	a0,a0,-832 # 80008190 <digits+0x158>
    800014d8:	fffff097          	auipc	ra,0xfffff
    800014dc:	336080e7          	jalr	822(ra) # 8000080e <panic>

00000000800014e0 <uvmdealloc>:
/* newsz.  oldsz and newsz need not be page-aligned, nor does newsz */
/* need to be less than oldsz.  oldsz can be larger than the actual */
/* process size.  Returns the new process size. */
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014e0:	1101                	add	sp,sp,-32
    800014e2:	ec06                	sd	ra,24(sp)
    800014e4:	e822                	sd	s0,16(sp)
    800014e6:	e426                	sd	s1,8(sp)
    800014e8:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014ea:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014ec:	00b67d63          	bgeu	a2,a1,80001506 <uvmdealloc+0x26>
    800014f0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014f2:	6785                	lui	a5,0x1
    800014f4:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014f6:	00f60733          	add	a4,a2,a5
    800014fa:	76fd                	lui	a3,0xfffff
    800014fc:	8f75                	and	a4,a4,a3
    800014fe:	97ae                	add	a5,a5,a1
    80001500:	8ff5                	and	a5,a5,a3
    80001502:	00f76863          	bltu	a4,a5,80001512 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001506:	8526                	mv	a0,s1
    80001508:	60e2                	ld	ra,24(sp)
    8000150a:	6442                	ld	s0,16(sp)
    8000150c:	64a2                	ld	s1,8(sp)
    8000150e:	6105                	add	sp,sp,32
    80001510:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001512:	8f99                	sub	a5,a5,a4
    80001514:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001516:	4685                	li	a3,1
    80001518:	0007861b          	sext.w	a2,a5
    8000151c:	85ba                	mv	a1,a4
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	e5e080e7          	jalr	-418(ra) # 8000137c <uvmunmap>
    80001526:	b7c5                	j	80001506 <uvmdealloc+0x26>

0000000080001528 <uvmalloc>:
  if(newsz < oldsz)
    80001528:	0ab66563          	bltu	a2,a1,800015d2 <uvmalloc+0xaa>
{
    8000152c:	7139                	add	sp,sp,-64
    8000152e:	fc06                	sd	ra,56(sp)
    80001530:	f822                	sd	s0,48(sp)
    80001532:	f426                	sd	s1,40(sp)
    80001534:	f04a                	sd	s2,32(sp)
    80001536:	ec4e                	sd	s3,24(sp)
    80001538:	e852                	sd	s4,16(sp)
    8000153a:	e456                	sd	s5,8(sp)
    8000153c:	e05a                	sd	s6,0(sp)
    8000153e:	0080                	add	s0,sp,64
    80001540:	8aaa                	mv	s5,a0
    80001542:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001544:	6785                	lui	a5,0x1
    80001546:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001548:	95be                	add	a1,a1,a5
    8000154a:	77fd                	lui	a5,0xfffff
    8000154c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001550:	08c9f363          	bgeu	s3,a2,800015d6 <uvmalloc+0xae>
    80001554:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001556:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    8000155a:	fffff097          	auipc	ra,0xfffff
    8000155e:	682080e7          	jalr	1666(ra) # 80000bdc <kalloc>
    80001562:	84aa                	mv	s1,a0
    if(mem == 0){
    80001564:	c51d                	beqz	a0,80001592 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001566:	6605                	lui	a2,0x1
    80001568:	4581                	li	a1,0
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	85e080e7          	jalr	-1954(ra) # 80000dc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001572:	875a                	mv	a4,s6
    80001574:	86a6                	mv	a3,s1
    80001576:	6605                	lui	a2,0x1
    80001578:	85ca                	mv	a1,s2
    8000157a:	8556                	mv	a0,s5
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	c16080e7          	jalr	-1002(ra) # 80001192 <mappages>
    80001584:	e90d                	bnez	a0,800015b6 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001586:	6785                	lui	a5,0x1
    80001588:	993e                	add	s2,s2,a5
    8000158a:	fd4968e3          	bltu	s2,s4,8000155a <uvmalloc+0x32>
  return newsz;
    8000158e:	8552                	mv	a0,s4
    80001590:	a809                	j	800015a2 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001592:	864e                	mv	a2,s3
    80001594:	85ca                	mv	a1,s2
    80001596:	8556                	mv	a0,s5
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	f48080e7          	jalr	-184(ra) # 800014e0 <uvmdealloc>
      return 0;
    800015a0:	4501                	li	a0,0
}
    800015a2:	70e2                	ld	ra,56(sp)
    800015a4:	7442                	ld	s0,48(sp)
    800015a6:	74a2                	ld	s1,40(sp)
    800015a8:	7902                	ld	s2,32(sp)
    800015aa:	69e2                	ld	s3,24(sp)
    800015ac:	6a42                	ld	s4,16(sp)
    800015ae:	6aa2                	ld	s5,8(sp)
    800015b0:	6b02                	ld	s6,0(sp)
    800015b2:	6121                	add	sp,sp,64
    800015b4:	8082                	ret
      kfree(mem);
    800015b6:	8526                	mv	a0,s1
    800015b8:	fffff097          	auipc	ra,0xfffff
    800015bc:	526080e7          	jalr	1318(ra) # 80000ade <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015c0:	864e                	mv	a2,s3
    800015c2:	85ca                	mv	a1,s2
    800015c4:	8556                	mv	a0,s5
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	f1a080e7          	jalr	-230(ra) # 800014e0 <uvmdealloc>
      return 0;
    800015ce:	4501                	li	a0,0
    800015d0:	bfc9                	j	800015a2 <uvmalloc+0x7a>
    return oldsz;
    800015d2:	852e                	mv	a0,a1
}
    800015d4:	8082                	ret
  return newsz;
    800015d6:	8532                	mv	a0,a2
    800015d8:	b7e9                	j	800015a2 <uvmalloc+0x7a>

00000000800015da <freewalk>:

/* Recursively free page-table pages. */
/* All leaf mappings must already have been removed. */
void
freewalk(pagetable_t pagetable)
{
    800015da:	7179                	add	sp,sp,-48
    800015dc:	f406                	sd	ra,40(sp)
    800015de:	f022                	sd	s0,32(sp)
    800015e0:	ec26                	sd	s1,24(sp)
    800015e2:	e84a                	sd	s2,16(sp)
    800015e4:	e44e                	sd	s3,8(sp)
    800015e6:	e052                	sd	s4,0(sp)
    800015e8:	1800                	add	s0,sp,48
    800015ea:	8a2a                	mv	s4,a0
  /* there are 2^9 = 512 PTEs in a page table. */
  for(int i = 0; i < 512; i++){
    800015ec:	84aa                	mv	s1,a0
    800015ee:	6905                	lui	s2,0x1
    800015f0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015f2:	4985                	li	s3,1
    800015f4:	a829                	j	8000160e <freewalk+0x34>
      /* this PTE points to a lower-level page table. */
      uint64 child = PTE2PA(pte);
    800015f6:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015f8:	00c79513          	sll	a0,a5,0xc
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	fde080e7          	jalr	-34(ra) # 800015da <freewalk>
      pagetable[i] = 0;
    80001604:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001608:	04a1                	add	s1,s1,8
    8000160a:	03248163          	beq	s1,s2,8000162c <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000160e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001610:	00f7f713          	and	a4,a5,15
    80001614:	ff3701e3          	beq	a4,s3,800015f6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001618:	8b85                	and	a5,a5,1
    8000161a:	d7fd                	beqz	a5,80001608 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000161c:	00007517          	auipc	a0,0x7
    80001620:	b9450513          	add	a0,a0,-1132 # 800081b0 <digits+0x178>
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	1ea080e7          	jalr	490(ra) # 8000080e <panic>
    }
  }
  kfree((void*)pagetable);
    8000162c:	8552                	mv	a0,s4
    8000162e:	fffff097          	auipc	ra,0xfffff
    80001632:	4b0080e7          	jalr	1200(ra) # 80000ade <kfree>
}
    80001636:	70a2                	ld	ra,40(sp)
    80001638:	7402                	ld	s0,32(sp)
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6942                	ld	s2,16(sp)
    8000163e:	69a2                	ld	s3,8(sp)
    80001640:	6a02                	ld	s4,0(sp)
    80001642:	6145                	add	sp,sp,48
    80001644:	8082                	ret

0000000080001646 <uvmfree>:

/* Free user memory pages, */
/* then free page-table pages. */
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001646:	1101                	add	sp,sp,-32
    80001648:	ec06                	sd	ra,24(sp)
    8000164a:	e822                	sd	s0,16(sp)
    8000164c:	e426                	sd	s1,8(sp)
    8000164e:	1000                	add	s0,sp,32
    80001650:	84aa                	mv	s1,a0
  if(sz > 0)
    80001652:	e999                	bnez	a1,80001668 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001654:	8526                	mv	a0,s1
    80001656:	00000097          	auipc	ra,0x0
    8000165a:	f84080e7          	jalr	-124(ra) # 800015da <freewalk>
}
    8000165e:	60e2                	ld	ra,24(sp)
    80001660:	6442                	ld	s0,16(sp)
    80001662:	64a2                	ld	s1,8(sp)
    80001664:	6105                	add	sp,sp,32
    80001666:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001668:	6785                	lui	a5,0x1
    8000166a:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000166c:	95be                	add	a1,a1,a5
    8000166e:	4685                	li	a3,1
    80001670:	00c5d613          	srl	a2,a1,0xc
    80001674:	4581                	li	a1,0
    80001676:	00000097          	auipc	ra,0x0
    8000167a:	d06080e7          	jalr	-762(ra) # 8000137c <uvmunmap>
    8000167e:	bfd9                	j	80001654 <uvmfree+0xe>

0000000080001680 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001680:	c679                	beqz	a2,8000174e <uvmcopy+0xce>
{
    80001682:	715d                	add	sp,sp,-80
    80001684:	e486                	sd	ra,72(sp)
    80001686:	e0a2                	sd	s0,64(sp)
    80001688:	fc26                	sd	s1,56(sp)
    8000168a:	f84a                	sd	s2,48(sp)
    8000168c:	f44e                	sd	s3,40(sp)
    8000168e:	f052                	sd	s4,32(sp)
    80001690:	ec56                	sd	s5,24(sp)
    80001692:	e85a                	sd	s6,16(sp)
    80001694:	e45e                	sd	s7,8(sp)
    80001696:	0880                	add	s0,sp,80
    80001698:	8b2a                	mv	s6,a0
    8000169a:	8aae                	mv	s5,a1
    8000169c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000169e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800016a0:	4601                	li	a2,0
    800016a2:	85ce                	mv	a1,s3
    800016a4:	855a                	mv	a0,s6
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	a04080e7          	jalr	-1532(ra) # 800010aa <walk>
    800016ae:	c531                	beqz	a0,800016fa <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800016b0:	6118                	ld	a4,0(a0)
    800016b2:	00177793          	and	a5,a4,1
    800016b6:	cbb1                	beqz	a5,8000170a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800016b8:	00a75593          	srl	a1,a4,0xa
    800016bc:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800016c0:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    800016c4:	fffff097          	auipc	ra,0xfffff
    800016c8:	518080e7          	jalr	1304(ra) # 80000bdc <kalloc>
    800016cc:	892a                	mv	s2,a0
    800016ce:	c939                	beqz	a0,80001724 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800016d0:	6605                	lui	a2,0x1
    800016d2:	85de                	mv	a1,s7
    800016d4:	fffff097          	auipc	ra,0xfffff
    800016d8:	750080e7          	jalr	1872(ra) # 80000e24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800016dc:	8726                	mv	a4,s1
    800016de:	86ca                	mv	a3,s2
    800016e0:	6605                	lui	a2,0x1
    800016e2:	85ce                	mv	a1,s3
    800016e4:	8556                	mv	a0,s5
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	aac080e7          	jalr	-1364(ra) # 80001192 <mappages>
    800016ee:	e515                	bnez	a0,8000171a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800016f0:	6785                	lui	a5,0x1
    800016f2:	99be                	add	s3,s3,a5
    800016f4:	fb49e6e3          	bltu	s3,s4,800016a0 <uvmcopy+0x20>
    800016f8:	a081                	j	80001738 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800016fa:	00007517          	auipc	a0,0x7
    800016fe:	ac650513          	add	a0,a0,-1338 # 800081c0 <digits+0x188>
    80001702:	fffff097          	auipc	ra,0xfffff
    80001706:	10c080e7          	jalr	268(ra) # 8000080e <panic>
      panic("uvmcopy: page not present");
    8000170a:	00007517          	auipc	a0,0x7
    8000170e:	ad650513          	add	a0,a0,-1322 # 800081e0 <digits+0x1a8>
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	0fc080e7          	jalr	252(ra) # 8000080e <panic>
      kfree(mem);
    8000171a:	854a                	mv	a0,s2
    8000171c:	fffff097          	auipc	ra,0xfffff
    80001720:	3c2080e7          	jalr	962(ra) # 80000ade <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001724:	4685                	li	a3,1
    80001726:	00c9d613          	srl	a2,s3,0xc
    8000172a:	4581                	li	a1,0
    8000172c:	8556                	mv	a0,s5
    8000172e:	00000097          	auipc	ra,0x0
    80001732:	c4e080e7          	jalr	-946(ra) # 8000137c <uvmunmap>
  return -1;
    80001736:	557d                	li	a0,-1
}
    80001738:	60a6                	ld	ra,72(sp)
    8000173a:	6406                	ld	s0,64(sp)
    8000173c:	74e2                	ld	s1,56(sp)
    8000173e:	7942                	ld	s2,48(sp)
    80001740:	79a2                	ld	s3,40(sp)
    80001742:	7a02                	ld	s4,32(sp)
    80001744:	6ae2                	ld	s5,24(sp)
    80001746:	6b42                	ld	s6,16(sp)
    80001748:	6ba2                	ld	s7,8(sp)
    8000174a:	6161                	add	sp,sp,80
    8000174c:	8082                	ret
  return 0;
    8000174e:	4501                	li	a0,0
}
    80001750:	8082                	ret

0000000080001752 <uvmclear>:

/* mark a PTE invalid for user access. */
/* used by exec for the user stack guard page. */
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001752:	1141                	add	sp,sp,-16
    80001754:	e406                	sd	ra,8(sp)
    80001756:	e022                	sd	s0,0(sp)
    80001758:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000175a:	4601                	li	a2,0
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	94e080e7          	jalr	-1714(ra) # 800010aa <walk>
  if(pte == 0)
    80001764:	c901                	beqz	a0,80001774 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001766:	611c                	ld	a5,0(a0)
    80001768:	9bbd                	and	a5,a5,-17
    8000176a:	e11c                	sd	a5,0(a0)
}
    8000176c:	60a2                	ld	ra,8(sp)
    8000176e:	6402                	ld	s0,0(sp)
    80001770:	0141                	add	sp,sp,16
    80001772:	8082                	ret
    panic("uvmclear");
    80001774:	00007517          	auipc	a0,0x7
    80001778:	a8c50513          	add	a0,a0,-1396 # 80008200 <digits+0x1c8>
    8000177c:	fffff097          	auipc	ra,0xfffff
    80001780:	092080e7          	jalr	146(ra) # 8000080e <panic>

0000000080001784 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001784:	cac9                	beqz	a3,80001816 <copyout+0x92>
{
    80001786:	711d                	add	sp,sp,-96
    80001788:	ec86                	sd	ra,88(sp)
    8000178a:	e8a2                	sd	s0,80(sp)
    8000178c:	e4a6                	sd	s1,72(sp)
    8000178e:	e0ca                	sd	s2,64(sp)
    80001790:	fc4e                	sd	s3,56(sp)
    80001792:	f852                	sd	s4,48(sp)
    80001794:	f456                	sd	s5,40(sp)
    80001796:	f05a                	sd	s6,32(sp)
    80001798:	ec5e                	sd	s7,24(sp)
    8000179a:	e862                	sd	s8,16(sp)
    8000179c:	e466                	sd	s9,8(sp)
    8000179e:	e06a                	sd	s10,0(sp)
    800017a0:	1080                	add	s0,sp,96
    800017a2:	8baa                	mv	s7,a0
    800017a4:	8aae                	mv	s5,a1
    800017a6:	8b32                	mv	s6,a2
    800017a8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800017aa:	74fd                	lui	s1,0xfffff
    800017ac:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800017ae:	57fd                	li	a5,-1
    800017b0:	83e9                	srl	a5,a5,0x1a
    800017b2:	0697e463          	bltu	a5,s1,8000181a <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800017b6:	4cd5                	li	s9,21
    800017b8:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800017ba:	8c3e                	mv	s8,a5
    800017bc:	a035                	j	800017e8 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800017be:	83a9                	srl	a5,a5,0xa
    800017c0:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800017c2:	409a8533          	sub	a0,s5,s1
    800017c6:	0009061b          	sext.w	a2,s2
    800017ca:	85da                	mv	a1,s6
    800017cc:	953e                	add	a0,a0,a5
    800017ce:	fffff097          	auipc	ra,0xfffff
    800017d2:	656080e7          	jalr	1622(ra) # 80000e24 <memmove>

    len -= n;
    800017d6:	412989b3          	sub	s3,s3,s2
    src += n;
    800017da:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800017dc:	02098b63          	beqz	s3,80001812 <copyout+0x8e>
    if(va0 >= MAXVA)
    800017e0:	034c6f63          	bltu	s8,s4,8000181e <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    800017e4:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    800017e6:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800017e8:	4601                	li	a2,0
    800017ea:	85a6                	mv	a1,s1
    800017ec:	855e                	mv	a0,s7
    800017ee:	00000097          	auipc	ra,0x0
    800017f2:	8bc080e7          	jalr	-1860(ra) # 800010aa <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800017f6:	c515                	beqz	a0,80001822 <copyout+0x9e>
    800017f8:	611c                	ld	a5,0(a0)
    800017fa:	0157f713          	and	a4,a5,21
    800017fe:	05971163          	bne	a4,s9,80001840 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80001802:	01a48a33          	add	s4,s1,s10
    80001806:	415a0933          	sub	s2,s4,s5
    8000180a:	fb29fae3          	bgeu	s3,s2,800017be <copyout+0x3a>
    8000180e:	894e                	mv	s2,s3
    80001810:	b77d                	j	800017be <copyout+0x3a>
  }
  return 0;
    80001812:	4501                	li	a0,0
    80001814:	a801                	j	80001824 <copyout+0xa0>
    80001816:	4501                	li	a0,0
}
    80001818:	8082                	ret
      return -1;
    8000181a:	557d                	li	a0,-1
    8000181c:	a021                	j	80001824 <copyout+0xa0>
    8000181e:	557d                	li	a0,-1
    80001820:	a011                	j	80001824 <copyout+0xa0>
      return -1;
    80001822:	557d                	li	a0,-1
}
    80001824:	60e6                	ld	ra,88(sp)
    80001826:	6446                	ld	s0,80(sp)
    80001828:	64a6                	ld	s1,72(sp)
    8000182a:	6906                	ld	s2,64(sp)
    8000182c:	79e2                	ld	s3,56(sp)
    8000182e:	7a42                	ld	s4,48(sp)
    80001830:	7aa2                	ld	s5,40(sp)
    80001832:	7b02                	ld	s6,32(sp)
    80001834:	6be2                	ld	s7,24(sp)
    80001836:	6c42                	ld	s8,16(sp)
    80001838:	6ca2                	ld	s9,8(sp)
    8000183a:	6d02                	ld	s10,0(sp)
    8000183c:	6125                	add	sp,sp,96
    8000183e:	8082                	ret
      return -1;
    80001840:	557d                	li	a0,-1
    80001842:	b7cd                	j	80001824 <copyout+0xa0>

0000000080001844 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001844:	caa5                	beqz	a3,800018b4 <copyin+0x70>
{
    80001846:	715d                	add	sp,sp,-80
    80001848:	e486                	sd	ra,72(sp)
    8000184a:	e0a2                	sd	s0,64(sp)
    8000184c:	fc26                	sd	s1,56(sp)
    8000184e:	f84a                	sd	s2,48(sp)
    80001850:	f44e                	sd	s3,40(sp)
    80001852:	f052                	sd	s4,32(sp)
    80001854:	ec56                	sd	s5,24(sp)
    80001856:	e85a                	sd	s6,16(sp)
    80001858:	e45e                	sd	s7,8(sp)
    8000185a:	e062                	sd	s8,0(sp)
    8000185c:	0880                	add	s0,sp,80
    8000185e:	8b2a                	mv	s6,a0
    80001860:	8a2e                	mv	s4,a1
    80001862:	8c32                	mv	s8,a2
    80001864:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001866:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001868:	6a85                	lui	s5,0x1
    8000186a:	a01d                	j	80001890 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000186c:	018505b3          	add	a1,a0,s8
    80001870:	0004861b          	sext.w	a2,s1
    80001874:	412585b3          	sub	a1,a1,s2
    80001878:	8552                	mv	a0,s4
    8000187a:	fffff097          	auipc	ra,0xfffff
    8000187e:	5aa080e7          	jalr	1450(ra) # 80000e24 <memmove>

    len -= n;
    80001882:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001886:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001888:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000188c:	02098263          	beqz	s3,800018b0 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001890:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001894:	85ca                	mv	a1,s2
    80001896:	855a                	mv	a0,s6
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	8b8080e7          	jalr	-1864(ra) # 80001150 <walkaddr>
    if(pa0 == 0)
    800018a0:	cd01                	beqz	a0,800018b8 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800018a2:	418904b3          	sub	s1,s2,s8
    800018a6:	94d6                	add	s1,s1,s5
    800018a8:	fc99f2e3          	bgeu	s3,s1,8000186c <copyin+0x28>
    800018ac:	84ce                	mv	s1,s3
    800018ae:	bf7d                	j	8000186c <copyin+0x28>
  }
  return 0;
    800018b0:	4501                	li	a0,0
    800018b2:	a021                	j	800018ba <copyin+0x76>
    800018b4:	4501                	li	a0,0
}
    800018b6:	8082                	ret
      return -1;
    800018b8:	557d                	li	a0,-1
}
    800018ba:	60a6                	ld	ra,72(sp)
    800018bc:	6406                	ld	s0,64(sp)
    800018be:	74e2                	ld	s1,56(sp)
    800018c0:	7942                	ld	s2,48(sp)
    800018c2:	79a2                	ld	s3,40(sp)
    800018c4:	7a02                	ld	s4,32(sp)
    800018c6:	6ae2                	ld	s5,24(sp)
    800018c8:	6b42                	ld	s6,16(sp)
    800018ca:	6ba2                	ld	s7,8(sp)
    800018cc:	6c02                	ld	s8,0(sp)
    800018ce:	6161                	add	sp,sp,80
    800018d0:	8082                	ret

00000000800018d2 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800018d2:	c2dd                	beqz	a3,80001978 <copyinstr+0xa6>
{
    800018d4:	715d                	add	sp,sp,-80
    800018d6:	e486                	sd	ra,72(sp)
    800018d8:	e0a2                	sd	s0,64(sp)
    800018da:	fc26                	sd	s1,56(sp)
    800018dc:	f84a                	sd	s2,48(sp)
    800018de:	f44e                	sd	s3,40(sp)
    800018e0:	f052                	sd	s4,32(sp)
    800018e2:	ec56                	sd	s5,24(sp)
    800018e4:	e85a                	sd	s6,16(sp)
    800018e6:	e45e                	sd	s7,8(sp)
    800018e8:	0880                	add	s0,sp,80
    800018ea:	8a2a                	mv	s4,a0
    800018ec:	8b2e                	mv	s6,a1
    800018ee:	8bb2                	mv	s7,a2
    800018f0:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800018f2:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800018f4:	6985                	lui	s3,0x1
    800018f6:	a02d                	j	80001920 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800018f8:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800018fc:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800018fe:	37fd                	addw	a5,a5,-1
    80001900:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001904:	60a6                	ld	ra,72(sp)
    80001906:	6406                	ld	s0,64(sp)
    80001908:	74e2                	ld	s1,56(sp)
    8000190a:	7942                	ld	s2,48(sp)
    8000190c:	79a2                	ld	s3,40(sp)
    8000190e:	7a02                	ld	s4,32(sp)
    80001910:	6ae2                	ld	s5,24(sp)
    80001912:	6b42                	ld	s6,16(sp)
    80001914:	6ba2                	ld	s7,8(sp)
    80001916:	6161                	add	sp,sp,80
    80001918:	8082                	ret
    srcva = va0 + PGSIZE;
    8000191a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000191e:	c8a9                	beqz	s1,80001970 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80001920:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001924:	85ca                	mv	a1,s2
    80001926:	8552                	mv	a0,s4
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	828080e7          	jalr	-2008(ra) # 80001150 <walkaddr>
    if(pa0 == 0)
    80001930:	c131                	beqz	a0,80001974 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001932:	417906b3          	sub	a3,s2,s7
    80001936:	96ce                	add	a3,a3,s3
    80001938:	00d4f363          	bgeu	s1,a3,8000193e <copyinstr+0x6c>
    8000193c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000193e:	955e                	add	a0,a0,s7
    80001940:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001944:	daf9                	beqz	a3,8000191a <copyinstr+0x48>
    80001946:	87da                	mv	a5,s6
    80001948:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000194a:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000194e:	96da                	add	a3,a3,s6
    80001950:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001952:	00f60733          	add	a4,a2,a5
    80001956:	00074703          	lbu	a4,0(a4)
    8000195a:	df59                	beqz	a4,800018f8 <copyinstr+0x26>
        *dst = *p;
    8000195c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001960:	0785                	add	a5,a5,1
    while(n > 0){
    80001962:	fed797e3          	bne	a5,a3,80001950 <copyinstr+0x7e>
    80001966:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffdd3bf>
    80001968:	94c2                	add	s1,s1,a6
      --max;
    8000196a:	8c8d                	sub	s1,s1,a1
      dst++;
    8000196c:	8b3e                	mv	s6,a5
    8000196e:	b775                	j	8000191a <copyinstr+0x48>
    80001970:	4781                	li	a5,0
    80001972:	b771                	j	800018fe <copyinstr+0x2c>
      return -1;
    80001974:	557d                	li	a0,-1
    80001976:	b779                	j	80001904 <copyinstr+0x32>
  int got_null = 0;
    80001978:	4781                	li	a5,0
  if(got_null){
    8000197a:	37fd                	addw	a5,a5,-1
    8000197c:	0007851b          	sext.w	a0,a5
}
    80001980:	8082                	ret

0000000080001982 <proc_mapstacks>:
/* Allocate a page for each process's kernel stack. */
/* Map it high in memory, followed by an invalid */
/* guard page. */
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001982:	7139                	add	sp,sp,-64
    80001984:	fc06                	sd	ra,56(sp)
    80001986:	f822                	sd	s0,48(sp)
    80001988:	f426                	sd	s1,40(sp)
    8000198a:	f04a                	sd	s2,32(sp)
    8000198c:	ec4e                	sd	s3,24(sp)
    8000198e:	e852                	sd	s4,16(sp)
    80001990:	e456                	sd	s5,8(sp)
    80001992:	e05a                	sd	s6,0(sp)
    80001994:	0080                	add	s0,sp,64
    80001996:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001998:	0000f497          	auipc	s1,0xf
    8000199c:	4c848493          	add	s1,s1,1224 # 80010e60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800019a0:	8b26                	mv	s6,s1
    800019a2:	00006a97          	auipc	s5,0x6
    800019a6:	65ea8a93          	add	s5,s5,1630 # 80008000 <etext>
    800019aa:	04000937          	lui	s2,0x4000
    800019ae:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800019b0:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019b2:	00015a17          	auipc	s4,0x15
    800019b6:	eaea0a13          	add	s4,s4,-338 # 80016860 <tickslock>
    char *pa = kalloc();
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	222080e7          	jalr	546(ra) # 80000bdc <kalloc>
    800019c2:	862a                	mv	a2,a0
    if(pa == 0)
    800019c4:	c131                	beqz	a0,80001a08 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800019c6:	416485b3          	sub	a1,s1,s6
    800019ca:	858d                	sra	a1,a1,0x3
    800019cc:	000ab783          	ld	a5,0(s5)
    800019d0:	02f585b3          	mul	a1,a1,a5
    800019d4:	2585                	addw	a1,a1,1
    800019d6:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019da:	4719                	li	a4,6
    800019dc:	6685                	lui	a3,0x1
    800019de:	40b905b3          	sub	a1,s2,a1
    800019e2:	854e                	mv	a0,s3
    800019e4:	00000097          	auipc	ra,0x0
    800019e8:	872080e7          	jalr	-1934(ra) # 80001256 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ec:	16848493          	add	s1,s1,360
    800019f0:	fd4495e3          	bne	s1,s4,800019ba <proc_mapstacks+0x38>
  }
}
    800019f4:	70e2                	ld	ra,56(sp)
    800019f6:	7442                	ld	s0,48(sp)
    800019f8:	74a2                	ld	s1,40(sp)
    800019fa:	7902                	ld	s2,32(sp)
    800019fc:	69e2                	ld	s3,24(sp)
    800019fe:	6a42                	ld	s4,16(sp)
    80001a00:	6aa2                	ld	s5,8(sp)
    80001a02:	6b02                	ld	s6,0(sp)
    80001a04:	6121                	add	sp,sp,64
    80001a06:	8082                	ret
      panic("kalloc");
    80001a08:	00007517          	auipc	a0,0x7
    80001a0c:	80850513          	add	a0,a0,-2040 # 80008210 <digits+0x1d8>
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	dfe080e7          	jalr	-514(ra) # 8000080e <panic>

0000000080001a18 <procinit>:

/* initialize the proc table. */
void
procinit(void)
{
    80001a18:	7139                	add	sp,sp,-64
    80001a1a:	fc06                	sd	ra,56(sp)
    80001a1c:	f822                	sd	s0,48(sp)
    80001a1e:	f426                	sd	s1,40(sp)
    80001a20:	f04a                	sd	s2,32(sp)
    80001a22:	ec4e                	sd	s3,24(sp)
    80001a24:	e852                	sd	s4,16(sp)
    80001a26:	e456                	sd	s5,8(sp)
    80001a28:	e05a                	sd	s6,0(sp)
    80001a2a:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001a2c:	00006597          	auipc	a1,0x6
    80001a30:	7ec58593          	add	a1,a1,2028 # 80008218 <digits+0x1e0>
    80001a34:	0000f517          	auipc	a0,0xf
    80001a38:	ffc50513          	add	a0,a0,-4 # 80010a30 <pid_lock>
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	200080e7          	jalr	512(ra) # 80000c3c <initlock>
  initlock(&wait_lock, "wait_lock");
    80001a44:	00006597          	auipc	a1,0x6
    80001a48:	7dc58593          	add	a1,a1,2012 # 80008220 <digits+0x1e8>
    80001a4c:	0000f517          	auipc	a0,0xf
    80001a50:	ffc50513          	add	a0,a0,-4 # 80010a48 <wait_lock>
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	1e8080e7          	jalr	488(ra) # 80000c3c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a5c:	0000f497          	auipc	s1,0xf
    80001a60:	40448493          	add	s1,s1,1028 # 80010e60 <proc>
      initlock(&p->lock, "proc");
    80001a64:	00006b17          	auipc	s6,0x6
    80001a68:	7ccb0b13          	add	s6,s6,1996 # 80008230 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001a6c:	8aa6                	mv	s5,s1
    80001a6e:	00006a17          	auipc	s4,0x6
    80001a72:	592a0a13          	add	s4,s4,1426 # 80008000 <etext>
    80001a76:	04000937          	lui	s2,0x4000
    80001a7a:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001a7c:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a7e:	00015997          	auipc	s3,0x15
    80001a82:	de298993          	add	s3,s3,-542 # 80016860 <tickslock>
      initlock(&p->lock, "proc");
    80001a86:	85da                	mv	a1,s6
    80001a88:	8526                	mv	a0,s1
    80001a8a:	fffff097          	auipc	ra,0xfffff
    80001a8e:	1b2080e7          	jalr	434(ra) # 80000c3c <initlock>
      p->state = UNUSED;
    80001a92:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001a96:	415487b3          	sub	a5,s1,s5
    80001a9a:	878d                	sra	a5,a5,0x3
    80001a9c:	000a3703          	ld	a4,0(s4)
    80001aa0:	02e787b3          	mul	a5,a5,a4
    80001aa4:	2785                	addw	a5,a5,1
    80001aa6:	00d7979b          	sllw	a5,a5,0xd
    80001aaa:	40f907b3          	sub	a5,s2,a5
    80001aae:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ab0:	16848493          	add	s1,s1,360
    80001ab4:	fd3499e3          	bne	s1,s3,80001a86 <procinit+0x6e>
  }
}
    80001ab8:	70e2                	ld	ra,56(sp)
    80001aba:	7442                	ld	s0,48(sp)
    80001abc:	74a2                	ld	s1,40(sp)
    80001abe:	7902                	ld	s2,32(sp)
    80001ac0:	69e2                	ld	s3,24(sp)
    80001ac2:	6a42                	ld	s4,16(sp)
    80001ac4:	6aa2                	ld	s5,8(sp)
    80001ac6:	6b02                	ld	s6,0(sp)
    80001ac8:	6121                	add	sp,sp,64
    80001aca:	8082                	ret

0000000080001acc <cpuid>:
/* Must be called with interrupts disabled, */
/* to prevent race with process being moved */
/* to a different CPU. */
int
cpuid()
{
    80001acc:	1141                	add	sp,sp,-16
    80001ace:	e422                	sd	s0,8(sp)
    80001ad0:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ad2:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001ad4:	2501                	sext.w	a0,a0
    80001ad6:	6422                	ld	s0,8(sp)
    80001ad8:	0141                	add	sp,sp,16
    80001ada:	8082                	ret

0000000080001adc <mycpu>:

/* Return this CPU's cpu struct. */
/* Interrupts must be disabled. */
struct cpu*
mycpu(void)
{
    80001adc:	1141                	add	sp,sp,-16
    80001ade:	e422                	sd	s0,8(sp)
    80001ae0:	0800                	add	s0,sp,16
    80001ae2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001ae4:	2781                	sext.w	a5,a5
    80001ae6:	079e                	sll	a5,a5,0x7
  return c;
}
    80001ae8:	0000f517          	auipc	a0,0xf
    80001aec:	f7850513          	add	a0,a0,-136 # 80010a60 <cpus>
    80001af0:	953e                	add	a0,a0,a5
    80001af2:	6422                	ld	s0,8(sp)
    80001af4:	0141                	add	sp,sp,16
    80001af6:	8082                	ret

0000000080001af8 <myproc>:

/* Return the current struct proc *, or zero if none. */
struct proc*
myproc(void)
{
    80001af8:	1101                	add	sp,sp,-32
    80001afa:	ec06                	sd	ra,24(sp)
    80001afc:	e822                	sd	s0,16(sp)
    80001afe:	e426                	sd	s1,8(sp)
    80001b00:	1000                	add	s0,sp,32
  push_off();
    80001b02:	fffff097          	auipc	ra,0xfffff
    80001b06:	17e080e7          	jalr	382(ra) # 80000c80 <push_off>
    80001b0a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001b0c:	2781                	sext.w	a5,a5
    80001b0e:	079e                	sll	a5,a5,0x7
    80001b10:	0000f717          	auipc	a4,0xf
    80001b14:	f2070713          	add	a4,a4,-224 # 80010a30 <pid_lock>
    80001b18:	97ba                	add	a5,a5,a4
    80001b1a:	7b84                	ld	s1,48(a5)
  pop_off();
    80001b1c:	fffff097          	auipc	ra,0xfffff
    80001b20:	204080e7          	jalr	516(ra) # 80000d20 <pop_off>
  return p;
}
    80001b24:	8526                	mv	a0,s1
    80001b26:	60e2                	ld	ra,24(sp)
    80001b28:	6442                	ld	s0,16(sp)
    80001b2a:	64a2                	ld	s1,8(sp)
    80001b2c:	6105                	add	sp,sp,32
    80001b2e:	8082                	ret

0000000080001b30 <forkret>:

/* A fork child's very first scheduling by scheduler() */
/* will swtch to forkret. */
void
forkret(void)
{
    80001b30:	1141                	add	sp,sp,-16
    80001b32:	e406                	sd	ra,8(sp)
    80001b34:	e022                	sd	s0,0(sp)
    80001b36:	0800                	add	s0,sp,16
  static int first = 1;

  /* Still holding p->lock from scheduler. */
  release(&myproc()->lock);
    80001b38:	00000097          	auipc	ra,0x0
    80001b3c:	fc0080e7          	jalr	-64(ra) # 80001af8 <myproc>
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	240080e7          	jalr	576(ra) # 80000d80 <release>

  if (first) {
    80001b48:	00007797          	auipc	a5,0x7
    80001b4c:	d387a783          	lw	a5,-712(a5) # 80008880 <first.1>
    80001b50:	eb89                	bnez	a5,80001b62 <forkret+0x32>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    80001b52:	00001097          	auipc	ra,0x1
    80001b56:	c80080e7          	jalr	-896(ra) # 800027d2 <usertrapret>
}
    80001b5a:	60a2                	ld	ra,8(sp)
    80001b5c:	6402                	ld	s0,0(sp)
    80001b5e:	0141                	add	sp,sp,16
    80001b60:	8082                	ret
    fsinit(ROOTDEV);
    80001b62:	4505                	li	a0,1
    80001b64:	00002097          	auipc	ra,0x2
    80001b68:	9aa080e7          	jalr	-1622(ra) # 8000350e <fsinit>
    first = 0;
    80001b6c:	00007797          	auipc	a5,0x7
    80001b70:	d007aa23          	sw	zero,-748(a5) # 80008880 <first.1>
    __sync_synchronize();
    80001b74:	0ff0000f          	fence
    80001b78:	bfe9                	j	80001b52 <forkret+0x22>

0000000080001b7a <allocpid>:
{
    80001b7a:	1101                	add	sp,sp,-32
    80001b7c:	ec06                	sd	ra,24(sp)
    80001b7e:	e822                	sd	s0,16(sp)
    80001b80:	e426                	sd	s1,8(sp)
    80001b82:	e04a                	sd	s2,0(sp)
    80001b84:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001b86:	0000f917          	auipc	s2,0xf
    80001b8a:	eaa90913          	add	s2,s2,-342 # 80010a30 <pid_lock>
    80001b8e:	854a                	mv	a0,s2
    80001b90:	fffff097          	auipc	ra,0xfffff
    80001b94:	13c080e7          	jalr	316(ra) # 80000ccc <acquire>
  pid = nextpid;
    80001b98:	00007797          	auipc	a5,0x7
    80001b9c:	cec78793          	add	a5,a5,-788 # 80008884 <nextpid>
    80001ba0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ba2:	0014871b          	addw	a4,s1,1
    80001ba6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ba8:	854a                	mv	a0,s2
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	1d6080e7          	jalr	470(ra) # 80000d80 <release>
}
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	60e2                	ld	ra,24(sp)
    80001bb6:	6442                	ld	s0,16(sp)
    80001bb8:	64a2                	ld	s1,8(sp)
    80001bba:	6902                	ld	s2,0(sp)
    80001bbc:	6105                	add	sp,sp,32
    80001bbe:	8082                	ret

0000000080001bc0 <proc_pagetable>:
{
    80001bc0:	1101                	add	sp,sp,-32
    80001bc2:	ec06                	sd	ra,24(sp)
    80001bc4:	e822                	sd	s0,16(sp)
    80001bc6:	e426                	sd	s1,8(sp)
    80001bc8:	e04a                	sd	s2,0(sp)
    80001bca:	1000                	add	s0,sp,32
    80001bcc:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001bce:	00000097          	auipc	ra,0x0
    80001bd2:	872080e7          	jalr	-1934(ra) # 80001440 <uvmcreate>
    80001bd6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001bd8:	c121                	beqz	a0,80001c18 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001bda:	4729                	li	a4,10
    80001bdc:	00005697          	auipc	a3,0x5
    80001be0:	42468693          	add	a3,a3,1060 # 80007000 <_trampoline>
    80001be4:	6605                	lui	a2,0x1
    80001be6:	040005b7          	lui	a1,0x4000
    80001bea:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bec:	05b2                	sll	a1,a1,0xc
    80001bee:	fffff097          	auipc	ra,0xfffff
    80001bf2:	5a4080e7          	jalr	1444(ra) # 80001192 <mappages>
    80001bf6:	02054863          	bltz	a0,80001c26 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001bfa:	4719                	li	a4,6
    80001bfc:	05893683          	ld	a3,88(s2)
    80001c00:	6605                	lui	a2,0x1
    80001c02:	020005b7          	lui	a1,0x2000
    80001c06:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c08:	05b6                	sll	a1,a1,0xd
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	fffff097          	auipc	ra,0xfffff
    80001c10:	586080e7          	jalr	1414(ra) # 80001192 <mappages>
    80001c14:	02054163          	bltz	a0,80001c36 <proc_pagetable+0x76>
}
    80001c18:	8526                	mv	a0,s1
    80001c1a:	60e2                	ld	ra,24(sp)
    80001c1c:	6442                	ld	s0,16(sp)
    80001c1e:	64a2                	ld	s1,8(sp)
    80001c20:	6902                	ld	s2,0(sp)
    80001c22:	6105                	add	sp,sp,32
    80001c24:	8082                	ret
    uvmfree(pagetable, 0);
    80001c26:	4581                	li	a1,0
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00000097          	auipc	ra,0x0
    80001c2e:	a1c080e7          	jalr	-1508(ra) # 80001646 <uvmfree>
    return 0;
    80001c32:	4481                	li	s1,0
    80001c34:	b7d5                	j	80001c18 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c36:	4681                	li	a3,0
    80001c38:	4605                	li	a2,1
    80001c3a:	040005b7          	lui	a1,0x4000
    80001c3e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c40:	05b2                	sll	a1,a1,0xc
    80001c42:	8526                	mv	a0,s1
    80001c44:	fffff097          	auipc	ra,0xfffff
    80001c48:	738080e7          	jalr	1848(ra) # 8000137c <uvmunmap>
    uvmfree(pagetable, 0);
    80001c4c:	4581                	li	a1,0
    80001c4e:	8526                	mv	a0,s1
    80001c50:	00000097          	auipc	ra,0x0
    80001c54:	9f6080e7          	jalr	-1546(ra) # 80001646 <uvmfree>
    return 0;
    80001c58:	4481                	li	s1,0
    80001c5a:	bf7d                	j	80001c18 <proc_pagetable+0x58>

0000000080001c5c <proc_freepagetable>:
{
    80001c5c:	1101                	add	sp,sp,-32
    80001c5e:	ec06                	sd	ra,24(sp)
    80001c60:	e822                	sd	s0,16(sp)
    80001c62:	e426                	sd	s1,8(sp)
    80001c64:	e04a                	sd	s2,0(sp)
    80001c66:	1000                	add	s0,sp,32
    80001c68:	84aa                	mv	s1,a0
    80001c6a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c6c:	4681                	li	a3,0
    80001c6e:	4605                	li	a2,1
    80001c70:	040005b7          	lui	a1,0x4000
    80001c74:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c76:	05b2                	sll	a1,a1,0xc
    80001c78:	fffff097          	auipc	ra,0xfffff
    80001c7c:	704080e7          	jalr	1796(ra) # 8000137c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c80:	4681                	li	a3,0
    80001c82:	4605                	li	a2,1
    80001c84:	020005b7          	lui	a1,0x2000
    80001c88:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c8a:	05b6                	sll	a1,a1,0xd
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	6ee080e7          	jalr	1774(ra) # 8000137c <uvmunmap>
  uvmfree(pagetable, sz);
    80001c96:	85ca                	mv	a1,s2
    80001c98:	8526                	mv	a0,s1
    80001c9a:	00000097          	auipc	ra,0x0
    80001c9e:	9ac080e7          	jalr	-1620(ra) # 80001646 <uvmfree>
}
    80001ca2:	60e2                	ld	ra,24(sp)
    80001ca4:	6442                	ld	s0,16(sp)
    80001ca6:	64a2                	ld	s1,8(sp)
    80001ca8:	6902                	ld	s2,0(sp)
    80001caa:	6105                	add	sp,sp,32
    80001cac:	8082                	ret

0000000080001cae <freeproc>:
{
    80001cae:	1101                	add	sp,sp,-32
    80001cb0:	ec06                	sd	ra,24(sp)
    80001cb2:	e822                	sd	s0,16(sp)
    80001cb4:	e426                	sd	s1,8(sp)
    80001cb6:	1000                	add	s0,sp,32
    80001cb8:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001cba:	6d28                	ld	a0,88(a0)
    80001cbc:	c509                	beqz	a0,80001cc6 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	e20080e7          	jalr	-480(ra) # 80000ade <kfree>
  p->trapframe = 0;
    80001cc6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001cca:	68a8                	ld	a0,80(s1)
    80001ccc:	c511                	beqz	a0,80001cd8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001cce:	64ac                	ld	a1,72(s1)
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	f8c080e7          	jalr	-116(ra) # 80001c5c <proc_freepagetable>
  p->pagetable = 0;
    80001cd8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001cdc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ce0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ce4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ce8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001cec:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001cf0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001cf4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001cf8:	0004ac23          	sw	zero,24(s1)
}
    80001cfc:	60e2                	ld	ra,24(sp)
    80001cfe:	6442                	ld	s0,16(sp)
    80001d00:	64a2                	ld	s1,8(sp)
    80001d02:	6105                	add	sp,sp,32
    80001d04:	8082                	ret

0000000080001d06 <allocproc>:
{
    80001d06:	1101                	add	sp,sp,-32
    80001d08:	ec06                	sd	ra,24(sp)
    80001d0a:	e822                	sd	s0,16(sp)
    80001d0c:	e426                	sd	s1,8(sp)
    80001d0e:	e04a                	sd	s2,0(sp)
    80001d10:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d12:	0000f497          	auipc	s1,0xf
    80001d16:	14e48493          	add	s1,s1,334 # 80010e60 <proc>
    80001d1a:	00015917          	auipc	s2,0x15
    80001d1e:	b4690913          	add	s2,s2,-1210 # 80016860 <tickslock>
    acquire(&p->lock);
    80001d22:	8526                	mv	a0,s1
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	fa8080e7          	jalr	-88(ra) # 80000ccc <acquire>
    if(p->state == UNUSED) {
    80001d2c:	4c9c                	lw	a5,24(s1)
    80001d2e:	cf81                	beqz	a5,80001d46 <allocproc+0x40>
      release(&p->lock);
    80001d30:	8526                	mv	a0,s1
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	04e080e7          	jalr	78(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d3a:	16848493          	add	s1,s1,360
    80001d3e:	ff2492e3          	bne	s1,s2,80001d22 <allocproc+0x1c>
  return 0;
    80001d42:	4481                	li	s1,0
    80001d44:	a889                	j	80001d96 <allocproc+0x90>
  p->pid = allocpid();
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	e34080e7          	jalr	-460(ra) # 80001b7a <allocpid>
    80001d4e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d50:	4785                	li	a5,1
    80001d52:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d54:	fffff097          	auipc	ra,0xfffff
    80001d58:	e88080e7          	jalr	-376(ra) # 80000bdc <kalloc>
    80001d5c:	892a                	mv	s2,a0
    80001d5e:	eca8                	sd	a0,88(s1)
    80001d60:	c131                	beqz	a0,80001da4 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001d62:	8526                	mv	a0,s1
    80001d64:	00000097          	auipc	ra,0x0
    80001d68:	e5c080e7          	jalr	-420(ra) # 80001bc0 <proc_pagetable>
    80001d6c:	892a                	mv	s2,a0
    80001d6e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001d70:	c531                	beqz	a0,80001dbc <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001d72:	07000613          	li	a2,112
    80001d76:	4581                	li	a1,0
    80001d78:	06048513          	add	a0,s1,96
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	04c080e7          	jalr	76(ra) # 80000dc8 <memset>
  p->context.ra = (uint64)forkret;
    80001d84:	00000797          	auipc	a5,0x0
    80001d88:	dac78793          	add	a5,a5,-596 # 80001b30 <forkret>
    80001d8c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d8e:	60bc                	ld	a5,64(s1)
    80001d90:	6705                	lui	a4,0x1
    80001d92:	97ba                	add	a5,a5,a4
    80001d94:	f4bc                	sd	a5,104(s1)
}
    80001d96:	8526                	mv	a0,s1
    80001d98:	60e2                	ld	ra,24(sp)
    80001d9a:	6442                	ld	s0,16(sp)
    80001d9c:	64a2                	ld	s1,8(sp)
    80001d9e:	6902                	ld	s2,0(sp)
    80001da0:	6105                	add	sp,sp,32
    80001da2:	8082                	ret
    freeproc(p);
    80001da4:	8526                	mv	a0,s1
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	f08080e7          	jalr	-248(ra) # 80001cae <freeproc>
    release(&p->lock);
    80001dae:	8526                	mv	a0,s1
    80001db0:	fffff097          	auipc	ra,0xfffff
    80001db4:	fd0080e7          	jalr	-48(ra) # 80000d80 <release>
    return 0;
    80001db8:	84ca                	mv	s1,s2
    80001dba:	bff1                	j	80001d96 <allocproc+0x90>
    freeproc(p);
    80001dbc:	8526                	mv	a0,s1
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	ef0080e7          	jalr	-272(ra) # 80001cae <freeproc>
    release(&p->lock);
    80001dc6:	8526                	mv	a0,s1
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	fb8080e7          	jalr	-72(ra) # 80000d80 <release>
    return 0;
    80001dd0:	84ca                	mv	s1,s2
    80001dd2:	b7d1                	j	80001d96 <allocproc+0x90>

0000000080001dd4 <userinit>:
{
    80001dd4:	1101                	add	sp,sp,-32
    80001dd6:	ec06                	sd	ra,24(sp)
    80001dd8:	e822                	sd	s0,16(sp)
    80001dda:	e426                	sd	s1,8(sp)
    80001ddc:	1000                	add	s0,sp,32
  p = allocproc();
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	f28080e7          	jalr	-216(ra) # 80001d06 <allocproc>
    80001de6:	84aa                	mv	s1,a0
  initproc = p;
    80001de8:	00007797          	auipc	a5,0x7
    80001dec:	b0a7b823          	sd	a0,-1264(a5) # 800088f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001df0:	03400613          	li	a2,52
    80001df4:	00007597          	auipc	a1,0x7
    80001df8:	a9c58593          	add	a1,a1,-1380 # 80008890 <initcode>
    80001dfc:	6928                	ld	a0,80(a0)
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	670080e7          	jalr	1648(ra) # 8000146e <uvmfirst>
  p->sz = PGSIZE;
    80001e06:	6785                	lui	a5,0x1
    80001e08:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      /* user program counter */
    80001e0a:	6cb8                	ld	a4,88(s1)
    80001e0c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    80001e10:	6cb8                	ld	a4,88(s1)
    80001e12:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e14:	4641                	li	a2,16
    80001e16:	00006597          	auipc	a1,0x6
    80001e1a:	42258593          	add	a1,a1,1058 # 80008238 <digits+0x200>
    80001e1e:	15848513          	add	a0,s1,344
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	0ee080e7          	jalr	238(ra) # 80000f10 <safestrcpy>
  p->cwd = namei("/");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	41e50513          	add	a0,a0,1054 # 80008248 <digits+0x210>
    80001e32:	00002097          	auipc	ra,0x2
    80001e36:	0fa080e7          	jalr	250(ra) # 80003f2c <namei>
    80001e3a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001e3e:	478d                	li	a5,3
    80001e40:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001e42:	8526                	mv	a0,s1
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	f3c080e7          	jalr	-196(ra) # 80000d80 <release>
}
    80001e4c:	60e2                	ld	ra,24(sp)
    80001e4e:	6442                	ld	s0,16(sp)
    80001e50:	64a2                	ld	s1,8(sp)
    80001e52:	6105                	add	sp,sp,32
    80001e54:	8082                	ret

0000000080001e56 <growproc>:
{
    80001e56:	1101                	add	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	e426                	sd	s1,8(sp)
    80001e5e:	e04a                	sd	s2,0(sp)
    80001e60:	1000                	add	s0,sp,32
    80001e62:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	c94080e7          	jalr	-876(ra) # 80001af8 <myproc>
    80001e6c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001e6e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001e70:	01204c63          	bgtz	s2,80001e88 <growproc+0x32>
  } else if(n < 0){
    80001e74:	02094663          	bltz	s2,80001ea0 <growproc+0x4a>
  p->sz = sz;
    80001e78:	e4ac                	sd	a1,72(s1)
  return 0;
    80001e7a:	4501                	li	a0,0
}
    80001e7c:	60e2                	ld	ra,24(sp)
    80001e7e:	6442                	ld	s0,16(sp)
    80001e80:	64a2                	ld	s1,8(sp)
    80001e82:	6902                	ld	s2,0(sp)
    80001e84:	6105                	add	sp,sp,32
    80001e86:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001e88:	4691                	li	a3,4
    80001e8a:	00b90633          	add	a2,s2,a1
    80001e8e:	6928                	ld	a0,80(a0)
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	698080e7          	jalr	1688(ra) # 80001528 <uvmalloc>
    80001e98:	85aa                	mv	a1,a0
    80001e9a:	fd79                	bnez	a0,80001e78 <growproc+0x22>
      return -1;
    80001e9c:	557d                	li	a0,-1
    80001e9e:	bff9                	j	80001e7c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ea0:	00b90633          	add	a2,s2,a1
    80001ea4:	6928                	ld	a0,80(a0)
    80001ea6:	fffff097          	auipc	ra,0xfffff
    80001eaa:	63a080e7          	jalr	1594(ra) # 800014e0 <uvmdealloc>
    80001eae:	85aa                	mv	a1,a0
    80001eb0:	b7e1                	j	80001e78 <growproc+0x22>

0000000080001eb2 <fork>:
{
    80001eb2:	7139                	add	sp,sp,-64
    80001eb4:	fc06                	sd	ra,56(sp)
    80001eb6:	f822                	sd	s0,48(sp)
    80001eb8:	f426                	sd	s1,40(sp)
    80001eba:	f04a                	sd	s2,32(sp)
    80001ebc:	ec4e                	sd	s3,24(sp)
    80001ebe:	e852                	sd	s4,16(sp)
    80001ec0:	e456                	sd	s5,8(sp)
    80001ec2:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	c34080e7          	jalr	-972(ra) # 80001af8 <myproc>
    80001ecc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001ece:	00000097          	auipc	ra,0x0
    80001ed2:	e38080e7          	jalr	-456(ra) # 80001d06 <allocproc>
    80001ed6:	10050c63          	beqz	a0,80001fee <fork+0x13c>
    80001eda:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001edc:	048ab603          	ld	a2,72(s5)
    80001ee0:	692c                	ld	a1,80(a0)
    80001ee2:	050ab503          	ld	a0,80(s5)
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	79a080e7          	jalr	1946(ra) # 80001680 <uvmcopy>
    80001eee:	04054863          	bltz	a0,80001f3e <fork+0x8c>
  np->sz = p->sz;
    80001ef2:	048ab783          	ld	a5,72(s5)
    80001ef6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001efa:	058ab683          	ld	a3,88(s5)
    80001efe:	87b6                	mv	a5,a3
    80001f00:	058a3703          	ld	a4,88(s4)
    80001f04:	12068693          	add	a3,a3,288
    80001f08:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f0c:	6788                	ld	a0,8(a5)
    80001f0e:	6b8c                	ld	a1,16(a5)
    80001f10:	6f90                	ld	a2,24(a5)
    80001f12:	01073023          	sd	a6,0(a4)
    80001f16:	e708                	sd	a0,8(a4)
    80001f18:	eb0c                	sd	a1,16(a4)
    80001f1a:	ef10                	sd	a2,24(a4)
    80001f1c:	02078793          	add	a5,a5,32
    80001f20:	02070713          	add	a4,a4,32
    80001f24:	fed792e3          	bne	a5,a3,80001f08 <fork+0x56>
  np->trapframe->a0 = 0;
    80001f28:	058a3783          	ld	a5,88(s4)
    80001f2c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001f30:	0d0a8493          	add	s1,s5,208
    80001f34:	0d0a0913          	add	s2,s4,208
    80001f38:	150a8993          	add	s3,s5,336
    80001f3c:	a00d                	j	80001f5e <fork+0xac>
    freeproc(np);
    80001f3e:	8552                	mv	a0,s4
    80001f40:	00000097          	auipc	ra,0x0
    80001f44:	d6e080e7          	jalr	-658(ra) # 80001cae <freeproc>
    release(&np->lock);
    80001f48:	8552                	mv	a0,s4
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	e36080e7          	jalr	-458(ra) # 80000d80 <release>
    return -1;
    80001f52:	597d                	li	s2,-1
    80001f54:	a059                	j	80001fda <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001f56:	04a1                	add	s1,s1,8
    80001f58:	0921                	add	s2,s2,8
    80001f5a:	01348b63          	beq	s1,s3,80001f70 <fork+0xbe>
    if(p->ofile[i])
    80001f5e:	6088                	ld	a0,0(s1)
    80001f60:	d97d                	beqz	a0,80001f56 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f62:	00002097          	auipc	ra,0x2
    80001f66:	63c080e7          	jalr	1596(ra) # 8000459e <filedup>
    80001f6a:	00a93023          	sd	a0,0(s2)
    80001f6e:	b7e5                	j	80001f56 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001f70:	150ab503          	ld	a0,336(s5)
    80001f74:	00001097          	auipc	ra,0x1
    80001f78:	7d4080e7          	jalr	2004(ra) # 80003748 <idup>
    80001f7c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f80:	4641                	li	a2,16
    80001f82:	158a8593          	add	a1,s5,344
    80001f86:	158a0513          	add	a0,s4,344
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	f86080e7          	jalr	-122(ra) # 80000f10 <safestrcpy>
  pid = np->pid;
    80001f92:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001f96:	8552                	mv	a0,s4
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	de8080e7          	jalr	-536(ra) # 80000d80 <release>
  acquire(&wait_lock);
    80001fa0:	0000f497          	auipc	s1,0xf
    80001fa4:	aa848493          	add	s1,s1,-1368 # 80010a48 <wait_lock>
    80001fa8:	8526                	mv	a0,s1
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	d22080e7          	jalr	-734(ra) # 80000ccc <acquire>
  np->parent = p;
    80001fb2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	dc8080e7          	jalr	-568(ra) # 80000d80 <release>
  acquire(&np->lock);
    80001fc0:	8552                	mv	a0,s4
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	d0a080e7          	jalr	-758(ra) # 80000ccc <acquire>
  np->state = RUNNABLE;
    80001fca:	478d                	li	a5,3
    80001fcc:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001fd0:	8552                	mv	a0,s4
    80001fd2:	fffff097          	auipc	ra,0xfffff
    80001fd6:	dae080e7          	jalr	-594(ra) # 80000d80 <release>
}
    80001fda:	854a                	mv	a0,s2
    80001fdc:	70e2                	ld	ra,56(sp)
    80001fde:	7442                	ld	s0,48(sp)
    80001fe0:	74a2                	ld	s1,40(sp)
    80001fe2:	7902                	ld	s2,32(sp)
    80001fe4:	69e2                	ld	s3,24(sp)
    80001fe6:	6a42                	ld	s4,16(sp)
    80001fe8:	6aa2                	ld	s5,8(sp)
    80001fea:	6121                	add	sp,sp,64
    80001fec:	8082                	ret
    return -1;
    80001fee:	597d                	li	s2,-1
    80001ff0:	b7ed                	j	80001fda <fork+0x128>

0000000080001ff2 <scheduler>:
{
    80001ff2:	715d                	add	sp,sp,-80
    80001ff4:	e486                	sd	ra,72(sp)
    80001ff6:	e0a2                	sd	s0,64(sp)
    80001ff8:	fc26                	sd	s1,56(sp)
    80001ffa:	f84a                	sd	s2,48(sp)
    80001ffc:	f44e                	sd	s3,40(sp)
    80001ffe:	f052                	sd	s4,32(sp)
    80002000:	ec56                	sd	s5,24(sp)
    80002002:	e85a                	sd	s6,16(sp)
    80002004:	e45e                	sd	s7,8(sp)
    80002006:	e062                	sd	s8,0(sp)
    80002008:	0880                	add	s0,sp,80
    8000200a:	8792                	mv	a5,tp
  int id = r_tp();
    8000200c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000200e:	00779b13          	sll	s6,a5,0x7
    80002012:	0000f717          	auipc	a4,0xf
    80002016:	a1e70713          	add	a4,a4,-1506 # 80010a30 <pid_lock>
    8000201a:	975a                	add	a4,a4,s6
    8000201c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002020:	0000f717          	auipc	a4,0xf
    80002024:	a4870713          	add	a4,a4,-1464 # 80010a68 <cpus+0x8>
    80002028:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000202a:	4c11                	li	s8,4
        c->proc = p;
    8000202c:	079e                	sll	a5,a5,0x7
    8000202e:	0000fa17          	auipc	s4,0xf
    80002032:	a02a0a13          	add	s4,s4,-1534 # 80010a30 <pid_lock>
    80002036:	9a3e                	add	s4,s4,a5
        found = 1;
    80002038:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000203a:	00015997          	auipc	s3,0x15
    8000203e:	82698993          	add	s3,s3,-2010 # 80016860 <tickslock>
    80002042:	a899                	j	80002098 <scheduler+0xa6>
      release(&p->lock);
    80002044:	8526                	mv	a0,s1
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	d3a080e7          	jalr	-710(ra) # 80000d80 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000204e:	16848493          	add	s1,s1,360
    80002052:	03348963          	beq	s1,s3,80002084 <scheduler+0x92>
      acquire(&p->lock);
    80002056:	8526                	mv	a0,s1
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	c74080e7          	jalr	-908(ra) # 80000ccc <acquire>
      if(p->state == RUNNABLE) {
    80002060:	4c9c                	lw	a5,24(s1)
    80002062:	ff2791e3          	bne	a5,s2,80002044 <scheduler+0x52>
        p->state = RUNNING;
    80002066:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000206a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000206e:	06048593          	add	a1,s1,96
    80002072:	855a                	mv	a0,s6
    80002074:	00000097          	auipc	ra,0x0
    80002078:	6b4080e7          	jalr	1716(ra) # 80002728 <swtch>
        c->proc = 0;
    8000207c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80002080:	8ade                	mv	s5,s7
    80002082:	b7c9                	j	80002044 <scheduler+0x52>
    if(found == 0) {
    80002084:	000a9a63          	bnez	s5,80002098 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002088:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000208c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002090:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002094:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002098:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000209c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020a0:	10079073          	csrw	sstatus,a5
    int found = 0;
    800020a4:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800020a6:	0000f497          	auipc	s1,0xf
    800020aa:	dba48493          	add	s1,s1,-582 # 80010e60 <proc>
      if(p->state == RUNNABLE) {
    800020ae:	490d                	li	s2,3
    800020b0:	b75d                	j	80002056 <scheduler+0x64>

00000000800020b2 <sched>:
{
    800020b2:	7179                	add	sp,sp,-48
    800020b4:	f406                	sd	ra,40(sp)
    800020b6:	f022                	sd	s0,32(sp)
    800020b8:	ec26                	sd	s1,24(sp)
    800020ba:	e84a                	sd	s2,16(sp)
    800020bc:	e44e                	sd	s3,8(sp)
    800020be:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	a38080e7          	jalr	-1480(ra) # 80001af8 <myproc>
    800020c8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	b88080e7          	jalr	-1144(ra) # 80000c52 <holding>
    800020d2:	c93d                	beqz	a0,80002148 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020d4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020d6:	2781                	sext.w	a5,a5
    800020d8:	079e                	sll	a5,a5,0x7
    800020da:	0000f717          	auipc	a4,0xf
    800020de:	95670713          	add	a4,a4,-1706 # 80010a30 <pid_lock>
    800020e2:	97ba                	add	a5,a5,a4
    800020e4:	0a87a703          	lw	a4,168(a5)
    800020e8:	4785                	li	a5,1
    800020ea:	06f71763          	bne	a4,a5,80002158 <sched+0xa6>
  if(p->state == RUNNING)
    800020ee:	4c98                	lw	a4,24(s1)
    800020f0:	4791                	li	a5,4
    800020f2:	06f70b63          	beq	a4,a5,80002168 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020fa:	8b89                	and	a5,a5,2
  if(intr_get())
    800020fc:	efb5                	bnez	a5,80002178 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020fe:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002100:	0000f917          	auipc	s2,0xf
    80002104:	93090913          	add	s2,s2,-1744 # 80010a30 <pid_lock>
    80002108:	2781                	sext.w	a5,a5
    8000210a:	079e                	sll	a5,a5,0x7
    8000210c:	97ca                	add	a5,a5,s2
    8000210e:	0ac7a983          	lw	s3,172(a5)
    80002112:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002114:	2781                	sext.w	a5,a5
    80002116:	079e                	sll	a5,a5,0x7
    80002118:	0000f597          	auipc	a1,0xf
    8000211c:	95058593          	add	a1,a1,-1712 # 80010a68 <cpus+0x8>
    80002120:	95be                	add	a1,a1,a5
    80002122:	06048513          	add	a0,s1,96
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	602080e7          	jalr	1538(ra) # 80002728 <swtch>
    8000212e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002130:	2781                	sext.w	a5,a5
    80002132:	079e                	sll	a5,a5,0x7
    80002134:	993e                	add	s2,s2,a5
    80002136:	0b392623          	sw	s3,172(s2)
}
    8000213a:	70a2                	ld	ra,40(sp)
    8000213c:	7402                	ld	s0,32(sp)
    8000213e:	64e2                	ld	s1,24(sp)
    80002140:	6942                	ld	s2,16(sp)
    80002142:	69a2                	ld	s3,8(sp)
    80002144:	6145                	add	sp,sp,48
    80002146:	8082                	ret
    panic("sched p->lock");
    80002148:	00006517          	auipc	a0,0x6
    8000214c:	10850513          	add	a0,a0,264 # 80008250 <digits+0x218>
    80002150:	ffffe097          	auipc	ra,0xffffe
    80002154:	6be080e7          	jalr	1726(ra) # 8000080e <panic>
    panic("sched locks");
    80002158:	00006517          	auipc	a0,0x6
    8000215c:	10850513          	add	a0,a0,264 # 80008260 <digits+0x228>
    80002160:	ffffe097          	auipc	ra,0xffffe
    80002164:	6ae080e7          	jalr	1710(ra) # 8000080e <panic>
    panic("sched running");
    80002168:	00006517          	auipc	a0,0x6
    8000216c:	10850513          	add	a0,a0,264 # 80008270 <digits+0x238>
    80002170:	ffffe097          	auipc	ra,0xffffe
    80002174:	69e080e7          	jalr	1694(ra) # 8000080e <panic>
    panic("sched interruptible");
    80002178:	00006517          	auipc	a0,0x6
    8000217c:	10850513          	add	a0,a0,264 # 80008280 <digits+0x248>
    80002180:	ffffe097          	auipc	ra,0xffffe
    80002184:	68e080e7          	jalr	1678(ra) # 8000080e <panic>

0000000080002188 <yield>:
{
    80002188:	1101                	add	sp,sp,-32
    8000218a:	ec06                	sd	ra,24(sp)
    8000218c:	e822                	sd	s0,16(sp)
    8000218e:	e426                	sd	s1,8(sp)
    80002190:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80002192:	00000097          	auipc	ra,0x0
    80002196:	966080e7          	jalr	-1690(ra) # 80001af8 <myproc>
    8000219a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	b30080e7          	jalr	-1232(ra) # 80000ccc <acquire>
  p->state = RUNNABLE;
    800021a4:	478d                	li	a5,3
    800021a6:	cc9c                	sw	a5,24(s1)
  sched();
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	f0a080e7          	jalr	-246(ra) # 800020b2 <sched>
  release(&p->lock);
    800021b0:	8526                	mv	a0,s1
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	bce080e7          	jalr	-1074(ra) # 80000d80 <release>
}
    800021ba:	60e2                	ld	ra,24(sp)
    800021bc:	6442                	ld	s0,16(sp)
    800021be:	64a2                	ld	s1,8(sp)
    800021c0:	6105                	add	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    800021c4:	7179                	add	sp,sp,-48
    800021c6:	f406                	sd	ra,40(sp)
    800021c8:	f022                	sd	s0,32(sp)
    800021ca:	ec26                	sd	s1,24(sp)
    800021cc:	e84a                	sd	s2,16(sp)
    800021ce:	e44e                	sd	s3,8(sp)
    800021d0:	1800                	add	s0,sp,48
    800021d2:	89aa                	mv	s3,a0
    800021d4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021d6:	00000097          	auipc	ra,0x0
    800021da:	922080e7          	jalr	-1758(ra) # 80001af8 <myproc>
    800021de:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	aec080e7          	jalr	-1300(ra) # 80000ccc <acquire>
  release(lk);
    800021e8:	854a                	mv	a0,s2
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	b96080e7          	jalr	-1130(ra) # 80000d80 <release>

  /* Go to sleep. */
  p->chan = chan;
    800021f2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800021f6:	4789                	li	a5,2
    800021f8:	cc9c                	sw	a5,24(s1)

  sched();
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	eb8080e7          	jalr	-328(ra) # 800020b2 <sched>

  /* Tidy up. */
  p->chan = 0;
    80002202:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    80002206:	8526                	mv	a0,s1
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	b78080e7          	jalr	-1160(ra) # 80000d80 <release>
  acquire(lk);
    80002210:	854a                	mv	a0,s2
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	aba080e7          	jalr	-1350(ra) # 80000ccc <acquire>
}
    8000221a:	70a2                	ld	ra,40(sp)
    8000221c:	7402                	ld	s0,32(sp)
    8000221e:	64e2                	ld	s1,24(sp)
    80002220:	6942                	ld	s2,16(sp)
    80002222:	69a2                	ld	s3,8(sp)
    80002224:	6145                	add	sp,sp,48
    80002226:	8082                	ret

0000000080002228 <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    80002228:	7139                	add	sp,sp,-64
    8000222a:	fc06                	sd	ra,56(sp)
    8000222c:	f822                	sd	s0,48(sp)
    8000222e:	f426                	sd	s1,40(sp)
    80002230:	f04a                	sd	s2,32(sp)
    80002232:	ec4e                	sd	s3,24(sp)
    80002234:	e852                	sd	s4,16(sp)
    80002236:	e456                	sd	s5,8(sp)
    80002238:	0080                	add	s0,sp,64
    8000223a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000223c:	0000f497          	auipc	s1,0xf
    80002240:	c2448493          	add	s1,s1,-988 # 80010e60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002244:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002246:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002248:	00014917          	auipc	s2,0x14
    8000224c:	61890913          	add	s2,s2,1560 # 80016860 <tickslock>
    80002250:	a811                	j	80002264 <wakeup+0x3c>
      }
      release(&p->lock);
    80002252:	8526                	mv	a0,s1
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	b2c080e7          	jalr	-1236(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000225c:	16848493          	add	s1,s1,360
    80002260:	03248663          	beq	s1,s2,8000228c <wakeup+0x64>
    if(p != myproc()){
    80002264:	00000097          	auipc	ra,0x0
    80002268:	894080e7          	jalr	-1900(ra) # 80001af8 <myproc>
    8000226c:	fea488e3          	beq	s1,a0,8000225c <wakeup+0x34>
      acquire(&p->lock);
    80002270:	8526                	mv	a0,s1
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	a5a080e7          	jalr	-1446(ra) # 80000ccc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000227a:	4c9c                	lw	a5,24(s1)
    8000227c:	fd379be3          	bne	a5,s3,80002252 <wakeup+0x2a>
    80002280:	709c                	ld	a5,32(s1)
    80002282:	fd4798e3          	bne	a5,s4,80002252 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002286:	0154ac23          	sw	s5,24(s1)
    8000228a:	b7e1                	j	80002252 <wakeup+0x2a>
    }
  }
}
    8000228c:	70e2                	ld	ra,56(sp)
    8000228e:	7442                	ld	s0,48(sp)
    80002290:	74a2                	ld	s1,40(sp)
    80002292:	7902                	ld	s2,32(sp)
    80002294:	69e2                	ld	s3,24(sp)
    80002296:	6a42                	ld	s4,16(sp)
    80002298:	6aa2                	ld	s5,8(sp)
    8000229a:	6121                	add	sp,sp,64
    8000229c:	8082                	ret

000000008000229e <reparent>:
{
    8000229e:	7179                	add	sp,sp,-48
    800022a0:	f406                	sd	ra,40(sp)
    800022a2:	f022                	sd	s0,32(sp)
    800022a4:	ec26                	sd	s1,24(sp)
    800022a6:	e84a                	sd	s2,16(sp)
    800022a8:	e44e                	sd	s3,8(sp)
    800022aa:	e052                	sd	s4,0(sp)
    800022ac:	1800                	add	s0,sp,48
    800022ae:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022b0:	0000f497          	auipc	s1,0xf
    800022b4:	bb048493          	add	s1,s1,-1104 # 80010e60 <proc>
      pp->parent = initproc;
    800022b8:	00006a17          	auipc	s4,0x6
    800022bc:	640a0a13          	add	s4,s4,1600 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022c0:	00014997          	auipc	s3,0x14
    800022c4:	5a098993          	add	s3,s3,1440 # 80016860 <tickslock>
    800022c8:	a029                	j	800022d2 <reparent+0x34>
    800022ca:	16848493          	add	s1,s1,360
    800022ce:	01348d63          	beq	s1,s3,800022e8 <reparent+0x4a>
    if(pp->parent == p){
    800022d2:	7c9c                	ld	a5,56(s1)
    800022d4:	ff279be3          	bne	a5,s2,800022ca <reparent+0x2c>
      pp->parent = initproc;
    800022d8:	000a3503          	ld	a0,0(s4)
    800022dc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	f4a080e7          	jalr	-182(ra) # 80002228 <wakeup>
    800022e6:	b7d5                	j	800022ca <reparent+0x2c>
}
    800022e8:	70a2                	ld	ra,40(sp)
    800022ea:	7402                	ld	s0,32(sp)
    800022ec:	64e2                	ld	s1,24(sp)
    800022ee:	6942                	ld	s2,16(sp)
    800022f0:	69a2                	ld	s3,8(sp)
    800022f2:	6a02                	ld	s4,0(sp)
    800022f4:	6145                	add	sp,sp,48
    800022f6:	8082                	ret

00000000800022f8 <exit>:
{
    800022f8:	7179                	add	sp,sp,-48
    800022fa:	f406                	sd	ra,40(sp)
    800022fc:	f022                	sd	s0,32(sp)
    800022fe:	ec26                	sd	s1,24(sp)
    80002300:	e84a                	sd	s2,16(sp)
    80002302:	e44e                	sd	s3,8(sp)
    80002304:	e052                	sd	s4,0(sp)
    80002306:	1800                	add	s0,sp,48
    80002308:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	7ee080e7          	jalr	2030(ra) # 80001af8 <myproc>
    80002312:	89aa                	mv	s3,a0
  if(p == initproc)
    80002314:	00006797          	auipc	a5,0x6
    80002318:	5e47b783          	ld	a5,1508(a5) # 800088f8 <initproc>
    8000231c:	0d050493          	add	s1,a0,208
    80002320:	15050913          	add	s2,a0,336
    80002324:	02a79363          	bne	a5,a0,8000234a <exit+0x52>
    panic("init exiting");
    80002328:	00006517          	auipc	a0,0x6
    8000232c:	f7050513          	add	a0,a0,-144 # 80008298 <digits+0x260>
    80002330:	ffffe097          	auipc	ra,0xffffe
    80002334:	4de080e7          	jalr	1246(ra) # 8000080e <panic>
      fileclose(f);
    80002338:	00002097          	auipc	ra,0x2
    8000233c:	2b8080e7          	jalr	696(ra) # 800045f0 <fileclose>
      p->ofile[fd] = 0;
    80002340:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002344:	04a1                	add	s1,s1,8
    80002346:	01248563          	beq	s1,s2,80002350 <exit+0x58>
    if(p->ofile[fd]){
    8000234a:	6088                	ld	a0,0(s1)
    8000234c:	f575                	bnez	a0,80002338 <exit+0x40>
    8000234e:	bfdd                	j	80002344 <exit+0x4c>
  begin_op();
    80002350:	00002097          	auipc	ra,0x2
    80002354:	ddc080e7          	jalr	-548(ra) # 8000412c <begin_op>
  iput(p->cwd);
    80002358:	1509b503          	ld	a0,336(s3)
    8000235c:	00001097          	auipc	ra,0x1
    80002360:	5e4080e7          	jalr	1508(ra) # 80003940 <iput>
  end_op();
    80002364:	00002097          	auipc	ra,0x2
    80002368:	e42080e7          	jalr	-446(ra) # 800041a6 <end_op>
  p->cwd = 0;
    8000236c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002370:	0000e497          	auipc	s1,0xe
    80002374:	6d848493          	add	s1,s1,1752 # 80010a48 <wait_lock>
    80002378:	8526                	mv	a0,s1
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	952080e7          	jalr	-1710(ra) # 80000ccc <acquire>
  reparent(p);
    80002382:	854e                	mv	a0,s3
    80002384:	00000097          	auipc	ra,0x0
    80002388:	f1a080e7          	jalr	-230(ra) # 8000229e <reparent>
  wakeup(p->parent);
    8000238c:	0389b503          	ld	a0,56(s3)
    80002390:	00000097          	auipc	ra,0x0
    80002394:	e98080e7          	jalr	-360(ra) # 80002228 <wakeup>
  acquire(&p->lock);
    80002398:	854e                	mv	a0,s3
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	932080e7          	jalr	-1742(ra) # 80000ccc <acquire>
  p->xstate = status;
    800023a2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800023a6:	4795                	li	a5,5
    800023a8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800023ac:	8526                	mv	a0,s1
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	9d2080e7          	jalr	-1582(ra) # 80000d80 <release>
  sched();
    800023b6:	00000097          	auipc	ra,0x0
    800023ba:	cfc080e7          	jalr	-772(ra) # 800020b2 <sched>
  panic("zombie exit");
    800023be:	00006517          	auipc	a0,0x6
    800023c2:	eea50513          	add	a0,a0,-278 # 800082a8 <digits+0x270>
    800023c6:	ffffe097          	auipc	ra,0xffffe
    800023ca:	448080e7          	jalr	1096(ra) # 8000080e <panic>

00000000800023ce <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    800023ce:	7179                	add	sp,sp,-48
    800023d0:	f406                	sd	ra,40(sp)
    800023d2:	f022                	sd	s0,32(sp)
    800023d4:	ec26                	sd	s1,24(sp)
    800023d6:	e84a                	sd	s2,16(sp)
    800023d8:	e44e                	sd	s3,8(sp)
    800023da:	1800                	add	s0,sp,48
    800023dc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023de:	0000f497          	auipc	s1,0xf
    800023e2:	a8248493          	add	s1,s1,-1406 # 80010e60 <proc>
    800023e6:	00014997          	auipc	s3,0x14
    800023ea:	47a98993          	add	s3,s3,1146 # 80016860 <tickslock>
    acquire(&p->lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	8dc080e7          	jalr	-1828(ra) # 80000ccc <acquire>
    if(p->pid == pid){
    800023f8:	589c                	lw	a5,48(s1)
    800023fa:	01278d63          	beq	a5,s2,80002414 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	980080e7          	jalr	-1664(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002408:	16848493          	add	s1,s1,360
    8000240c:	ff3491e3          	bne	s1,s3,800023ee <kill+0x20>
  }
  return -1;
    80002410:	557d                	li	a0,-1
    80002412:	a829                	j	8000242c <kill+0x5e>
      p->killed = 1;
    80002414:	4785                	li	a5,1
    80002416:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002418:	4c98                	lw	a4,24(s1)
    8000241a:	4789                	li	a5,2
    8000241c:	00f70f63          	beq	a4,a5,8000243a <kill+0x6c>
      release(&p->lock);
    80002420:	8526                	mv	a0,s1
    80002422:	fffff097          	auipc	ra,0xfffff
    80002426:	95e080e7          	jalr	-1698(ra) # 80000d80 <release>
      return 0;
    8000242a:	4501                	li	a0,0
}
    8000242c:	70a2                	ld	ra,40(sp)
    8000242e:	7402                	ld	s0,32(sp)
    80002430:	64e2                	ld	s1,24(sp)
    80002432:	6942                	ld	s2,16(sp)
    80002434:	69a2                	ld	s3,8(sp)
    80002436:	6145                	add	sp,sp,48
    80002438:	8082                	ret
        p->state = RUNNABLE;
    8000243a:	478d                	li	a5,3
    8000243c:	cc9c                	sw	a5,24(s1)
    8000243e:	b7cd                	j	80002420 <kill+0x52>

0000000080002440 <setkilled>:

void
setkilled(struct proc *p)
{
    80002440:	1101                	add	sp,sp,-32
    80002442:	ec06                	sd	ra,24(sp)
    80002444:	e822                	sd	s0,16(sp)
    80002446:	e426                	sd	s1,8(sp)
    80002448:	1000                	add	s0,sp,32
    8000244a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	880080e7          	jalr	-1920(ra) # 80000ccc <acquire>
  p->killed = 1;
    80002454:	4785                	li	a5,1
    80002456:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002458:	8526                	mv	a0,s1
    8000245a:	fffff097          	auipc	ra,0xfffff
    8000245e:	926080e7          	jalr	-1754(ra) # 80000d80 <release>
}
    80002462:	60e2                	ld	ra,24(sp)
    80002464:	6442                	ld	s0,16(sp)
    80002466:	64a2                	ld	s1,8(sp)
    80002468:	6105                	add	sp,sp,32
    8000246a:	8082                	ret

000000008000246c <killed>:

int
killed(struct proc *p)
{
    8000246c:	1101                	add	sp,sp,-32
    8000246e:	ec06                	sd	ra,24(sp)
    80002470:	e822                	sd	s0,16(sp)
    80002472:	e426                	sd	s1,8(sp)
    80002474:	e04a                	sd	s2,0(sp)
    80002476:	1000                	add	s0,sp,32
    80002478:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000247a:	fffff097          	auipc	ra,0xfffff
    8000247e:	852080e7          	jalr	-1966(ra) # 80000ccc <acquire>
  k = p->killed;
    80002482:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002486:	8526                	mv	a0,s1
    80002488:	fffff097          	auipc	ra,0xfffff
    8000248c:	8f8080e7          	jalr	-1800(ra) # 80000d80 <release>
  return k;
}
    80002490:	854a                	mv	a0,s2
    80002492:	60e2                	ld	ra,24(sp)
    80002494:	6442                	ld	s0,16(sp)
    80002496:	64a2                	ld	s1,8(sp)
    80002498:	6902                	ld	s2,0(sp)
    8000249a:	6105                	add	sp,sp,32
    8000249c:	8082                	ret

000000008000249e <wait>:
{
    8000249e:	715d                	add	sp,sp,-80
    800024a0:	e486                	sd	ra,72(sp)
    800024a2:	e0a2                	sd	s0,64(sp)
    800024a4:	fc26                	sd	s1,56(sp)
    800024a6:	f84a                	sd	s2,48(sp)
    800024a8:	f44e                	sd	s3,40(sp)
    800024aa:	f052                	sd	s4,32(sp)
    800024ac:	ec56                	sd	s5,24(sp)
    800024ae:	e85a                	sd	s6,16(sp)
    800024b0:	e45e                	sd	s7,8(sp)
    800024b2:	e062                	sd	s8,0(sp)
    800024b4:	0880                	add	s0,sp,80
    800024b6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	640080e7          	jalr	1600(ra) # 80001af8 <myproc>
    800024c0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800024c2:	0000e517          	auipc	a0,0xe
    800024c6:	58650513          	add	a0,a0,1414 # 80010a48 <wait_lock>
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	802080e7          	jalr	-2046(ra) # 80000ccc <acquire>
    havekids = 0;
    800024d2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800024d4:	4a15                	li	s4,5
        havekids = 1;
    800024d6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024d8:	00014997          	auipc	s3,0x14
    800024dc:	38898993          	add	s3,s3,904 # 80016860 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800024e0:	0000ec17          	auipc	s8,0xe
    800024e4:	568c0c13          	add	s8,s8,1384 # 80010a48 <wait_lock>
    800024e8:	a0d1                	j	800025ac <wait+0x10e>
          pid = pp->pid;
    800024ea:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800024ee:	000b0e63          	beqz	s6,8000250a <wait+0x6c>
    800024f2:	4691                	li	a3,4
    800024f4:	02c48613          	add	a2,s1,44
    800024f8:	85da                	mv	a1,s6
    800024fa:	05093503          	ld	a0,80(s2)
    800024fe:	fffff097          	auipc	ra,0xfffff
    80002502:	286080e7          	jalr	646(ra) # 80001784 <copyout>
    80002506:	04054163          	bltz	a0,80002548 <wait+0xaa>
          freeproc(pp);
    8000250a:	8526                	mv	a0,s1
    8000250c:	fffff097          	auipc	ra,0xfffff
    80002510:	7a2080e7          	jalr	1954(ra) # 80001cae <freeproc>
          release(&pp->lock);
    80002514:	8526                	mv	a0,s1
    80002516:	fffff097          	auipc	ra,0xfffff
    8000251a:	86a080e7          	jalr	-1942(ra) # 80000d80 <release>
          release(&wait_lock);
    8000251e:	0000e517          	auipc	a0,0xe
    80002522:	52a50513          	add	a0,a0,1322 # 80010a48 <wait_lock>
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	85a080e7          	jalr	-1958(ra) # 80000d80 <release>
}
    8000252e:	854e                	mv	a0,s3
    80002530:	60a6                	ld	ra,72(sp)
    80002532:	6406                	ld	s0,64(sp)
    80002534:	74e2                	ld	s1,56(sp)
    80002536:	7942                	ld	s2,48(sp)
    80002538:	79a2                	ld	s3,40(sp)
    8000253a:	7a02                	ld	s4,32(sp)
    8000253c:	6ae2                	ld	s5,24(sp)
    8000253e:	6b42                	ld	s6,16(sp)
    80002540:	6ba2                	ld	s7,8(sp)
    80002542:	6c02                	ld	s8,0(sp)
    80002544:	6161                	add	sp,sp,80
    80002546:	8082                	ret
            release(&pp->lock);
    80002548:	8526                	mv	a0,s1
    8000254a:	fffff097          	auipc	ra,0xfffff
    8000254e:	836080e7          	jalr	-1994(ra) # 80000d80 <release>
            release(&wait_lock);
    80002552:	0000e517          	auipc	a0,0xe
    80002556:	4f650513          	add	a0,a0,1270 # 80010a48 <wait_lock>
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	826080e7          	jalr	-2010(ra) # 80000d80 <release>
            return -1;
    80002562:	59fd                	li	s3,-1
    80002564:	b7e9                	j	8000252e <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002566:	16848493          	add	s1,s1,360
    8000256a:	03348463          	beq	s1,s3,80002592 <wait+0xf4>
      if(pp->parent == p){
    8000256e:	7c9c                	ld	a5,56(s1)
    80002570:	ff279be3          	bne	a5,s2,80002566 <wait+0xc8>
        acquire(&pp->lock);
    80002574:	8526                	mv	a0,s1
    80002576:	ffffe097          	auipc	ra,0xffffe
    8000257a:	756080e7          	jalr	1878(ra) # 80000ccc <acquire>
        if(pp->state == ZOMBIE){
    8000257e:	4c9c                	lw	a5,24(s1)
    80002580:	f74785e3          	beq	a5,s4,800024ea <wait+0x4c>
        release(&pp->lock);
    80002584:	8526                	mv	a0,s1
    80002586:	ffffe097          	auipc	ra,0xffffe
    8000258a:	7fa080e7          	jalr	2042(ra) # 80000d80 <release>
        havekids = 1;
    8000258e:	8756                	mv	a4,s5
    80002590:	bfd9                	j	80002566 <wait+0xc8>
    if(!havekids || killed(p)){
    80002592:	c31d                	beqz	a4,800025b8 <wait+0x11a>
    80002594:	854a                	mv	a0,s2
    80002596:	00000097          	auipc	ra,0x0
    8000259a:	ed6080e7          	jalr	-298(ra) # 8000246c <killed>
    8000259e:	ed09                	bnez	a0,800025b8 <wait+0x11a>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800025a0:	85e2                	mv	a1,s8
    800025a2:	854a                	mv	a0,s2
    800025a4:	00000097          	auipc	ra,0x0
    800025a8:	c20080e7          	jalr	-992(ra) # 800021c4 <sleep>
    havekids = 0;
    800025ac:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025ae:	0000f497          	auipc	s1,0xf
    800025b2:	8b248493          	add	s1,s1,-1870 # 80010e60 <proc>
    800025b6:	bf65                	j	8000256e <wait+0xd0>
      release(&wait_lock);
    800025b8:	0000e517          	auipc	a0,0xe
    800025bc:	49050513          	add	a0,a0,1168 # 80010a48 <wait_lock>
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	7c0080e7          	jalr	1984(ra) # 80000d80 <release>
      return -1;
    800025c8:	59fd                	li	s3,-1
    800025ca:	b795                	j	8000252e <wait+0x90>

00000000800025cc <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800025cc:	7179                	add	sp,sp,-48
    800025ce:	f406                	sd	ra,40(sp)
    800025d0:	f022                	sd	s0,32(sp)
    800025d2:	ec26                	sd	s1,24(sp)
    800025d4:	e84a                	sd	s2,16(sp)
    800025d6:	e44e                	sd	s3,8(sp)
    800025d8:	e052                	sd	s4,0(sp)
    800025da:	1800                	add	s0,sp,48
    800025dc:	84aa                	mv	s1,a0
    800025de:	892e                	mv	s2,a1
    800025e0:	89b2                	mv	s3,a2
    800025e2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025e4:	fffff097          	auipc	ra,0xfffff
    800025e8:	514080e7          	jalr	1300(ra) # 80001af8 <myproc>
  if(user_dst){
    800025ec:	c08d                	beqz	s1,8000260e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800025ee:	86d2                	mv	a3,s4
    800025f0:	864e                	mv	a2,s3
    800025f2:	85ca                	mv	a1,s2
    800025f4:	6928                	ld	a0,80(a0)
    800025f6:	fffff097          	auipc	ra,0xfffff
    800025fa:	18e080e7          	jalr	398(ra) # 80001784 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800025fe:	70a2                	ld	ra,40(sp)
    80002600:	7402                	ld	s0,32(sp)
    80002602:	64e2                	ld	s1,24(sp)
    80002604:	6942                	ld	s2,16(sp)
    80002606:	69a2                	ld	s3,8(sp)
    80002608:	6a02                	ld	s4,0(sp)
    8000260a:	6145                	add	sp,sp,48
    8000260c:	8082                	ret
    memmove((char *)dst, src, len);
    8000260e:	000a061b          	sext.w	a2,s4
    80002612:	85ce                	mv	a1,s3
    80002614:	854a                	mv	a0,s2
    80002616:	fffff097          	auipc	ra,0xfffff
    8000261a:	80e080e7          	jalr	-2034(ra) # 80000e24 <memmove>
    return 0;
    8000261e:	8526                	mv	a0,s1
    80002620:	bff9                	j	800025fe <either_copyout+0x32>

0000000080002622 <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002622:	7179                	add	sp,sp,-48
    80002624:	f406                	sd	ra,40(sp)
    80002626:	f022                	sd	s0,32(sp)
    80002628:	ec26                	sd	s1,24(sp)
    8000262a:	e84a                	sd	s2,16(sp)
    8000262c:	e44e                	sd	s3,8(sp)
    8000262e:	e052                	sd	s4,0(sp)
    80002630:	1800                	add	s0,sp,48
    80002632:	892a                	mv	s2,a0
    80002634:	84ae                	mv	s1,a1
    80002636:	89b2                	mv	s3,a2
    80002638:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000263a:	fffff097          	auipc	ra,0xfffff
    8000263e:	4be080e7          	jalr	1214(ra) # 80001af8 <myproc>
  if(user_src){
    80002642:	c08d                	beqz	s1,80002664 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002644:	86d2                	mv	a3,s4
    80002646:	864e                	mv	a2,s3
    80002648:	85ca                	mv	a1,s2
    8000264a:	6928                	ld	a0,80(a0)
    8000264c:	fffff097          	auipc	ra,0xfffff
    80002650:	1f8080e7          	jalr	504(ra) # 80001844 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002654:	70a2                	ld	ra,40(sp)
    80002656:	7402                	ld	s0,32(sp)
    80002658:	64e2                	ld	s1,24(sp)
    8000265a:	6942                	ld	s2,16(sp)
    8000265c:	69a2                	ld	s3,8(sp)
    8000265e:	6a02                	ld	s4,0(sp)
    80002660:	6145                	add	sp,sp,48
    80002662:	8082                	ret
    memmove(dst, (char*)src, len);
    80002664:	000a061b          	sext.w	a2,s4
    80002668:	85ce                	mv	a1,s3
    8000266a:	854a                	mv	a0,s2
    8000266c:	ffffe097          	auipc	ra,0xffffe
    80002670:	7b8080e7          	jalr	1976(ra) # 80000e24 <memmove>
    return 0;
    80002674:	8526                	mv	a0,s1
    80002676:	bff9                	j	80002654 <either_copyin+0x32>

0000000080002678 <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    80002678:	715d                	add	sp,sp,-80
    8000267a:	e486                	sd	ra,72(sp)
    8000267c:	e0a2                	sd	s0,64(sp)
    8000267e:	fc26                	sd	s1,56(sp)
    80002680:	f84a                	sd	s2,48(sp)
    80002682:	f44e                	sd	s3,40(sp)
    80002684:	f052                	sd	s4,32(sp)
    80002686:	ec56                	sd	s5,24(sp)
    80002688:	e85a                	sd	s6,16(sp)
    8000268a:	e45e                	sd	s7,8(sp)
    8000268c:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000268e:	00006517          	auipc	a0,0x6
    80002692:	a3250513          	add	a0,a0,-1486 # 800080c0 <digits+0x88>
    80002696:	ffffe097          	auipc	ra,0xffffe
    8000269a:	e6c080e7          	jalr	-404(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000269e:	0000f497          	auipc	s1,0xf
    800026a2:	91a48493          	add	s1,s1,-1766 # 80010fb8 <proc+0x158>
    800026a6:	00014917          	auipc	s2,0x14
    800026aa:	31290913          	add	s2,s2,786 # 800169b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026ae:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800026b0:	00006997          	auipc	s3,0x6
    800026b4:	c0898993          	add	s3,s3,-1016 # 800082b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    800026b8:	00006a97          	auipc	s5,0x6
    800026bc:	c08a8a93          	add	s5,s5,-1016 # 800082c0 <digits+0x288>
    printf("\n");
    800026c0:	00006a17          	auipc	s4,0x6
    800026c4:	a00a0a13          	add	s4,s4,-1536 # 800080c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026c8:	00006b97          	auipc	s7,0x6
    800026cc:	c38b8b93          	add	s7,s7,-968 # 80008300 <states.0>
    800026d0:	a00d                	j	800026f2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800026d2:	ed86a583          	lw	a1,-296(a3)
    800026d6:	8556                	mv	a0,s5
    800026d8:	ffffe097          	auipc	ra,0xffffe
    800026dc:	e2a080e7          	jalr	-470(ra) # 80000502 <printf>
    printf("\n");
    800026e0:	8552                	mv	a0,s4
    800026e2:	ffffe097          	auipc	ra,0xffffe
    800026e6:	e20080e7          	jalr	-480(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026ea:	16848493          	add	s1,s1,360
    800026ee:	03248263          	beq	s1,s2,80002712 <procdump+0x9a>
    if(p->state == UNUSED)
    800026f2:	86a6                	mv	a3,s1
    800026f4:	ec04a783          	lw	a5,-320(s1)
    800026f8:	dbed                	beqz	a5,800026ea <procdump+0x72>
      state = "???";
    800026fa:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026fc:	fcfb6be3          	bltu	s6,a5,800026d2 <procdump+0x5a>
    80002700:	02079713          	sll	a4,a5,0x20
    80002704:	01d75793          	srl	a5,a4,0x1d
    80002708:	97de                	add	a5,a5,s7
    8000270a:	6390                	ld	a2,0(a5)
    8000270c:	f279                	bnez	a2,800026d2 <procdump+0x5a>
      state = "???";
    8000270e:	864e                	mv	a2,s3
    80002710:	b7c9                	j	800026d2 <procdump+0x5a>
  }
}
    80002712:	60a6                	ld	ra,72(sp)
    80002714:	6406                	ld	s0,64(sp)
    80002716:	74e2                	ld	s1,56(sp)
    80002718:	7942                	ld	s2,48(sp)
    8000271a:	79a2                	ld	s3,40(sp)
    8000271c:	7a02                	ld	s4,32(sp)
    8000271e:	6ae2                	ld	s5,24(sp)
    80002720:	6b42                	ld	s6,16(sp)
    80002722:	6ba2                	ld	s7,8(sp)
    80002724:	6161                	add	sp,sp,80
    80002726:	8082                	ret

0000000080002728 <swtch>:
    80002728:	00153023          	sd	ra,0(a0)
    8000272c:	00253423          	sd	sp,8(a0)
    80002730:	e900                	sd	s0,16(a0)
    80002732:	ed04                	sd	s1,24(a0)
    80002734:	03253023          	sd	s2,32(a0)
    80002738:	03353423          	sd	s3,40(a0)
    8000273c:	03453823          	sd	s4,48(a0)
    80002740:	03553c23          	sd	s5,56(a0)
    80002744:	05653023          	sd	s6,64(a0)
    80002748:	05753423          	sd	s7,72(a0)
    8000274c:	05853823          	sd	s8,80(a0)
    80002750:	05953c23          	sd	s9,88(a0)
    80002754:	07a53023          	sd	s10,96(a0)
    80002758:	07b53423          	sd	s11,104(a0)
    8000275c:	0005b083          	ld	ra,0(a1)
    80002760:	0085b103          	ld	sp,8(a1)
    80002764:	6980                	ld	s0,16(a1)
    80002766:	6d84                	ld	s1,24(a1)
    80002768:	0205b903          	ld	s2,32(a1)
    8000276c:	0285b983          	ld	s3,40(a1)
    80002770:	0305ba03          	ld	s4,48(a1)
    80002774:	0385ba83          	ld	s5,56(a1)
    80002778:	0405bb03          	ld	s6,64(a1)
    8000277c:	0485bb83          	ld	s7,72(a1)
    80002780:	0505bc03          	ld	s8,80(a1)
    80002784:	0585bc83          	ld	s9,88(a1)
    80002788:	0605bd03          	ld	s10,96(a1)
    8000278c:	0685bd83          	ld	s11,104(a1)
    80002790:	8082                	ret

0000000080002792 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002792:	1141                	add	sp,sp,-16
    80002794:	e406                	sd	ra,8(sp)
    80002796:	e022                	sd	s0,0(sp)
    80002798:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    8000279a:	00006597          	auipc	a1,0x6
    8000279e:	b9658593          	add	a1,a1,-1130 # 80008330 <states.0+0x30>
    800027a2:	00014517          	auipc	a0,0x14
    800027a6:	0be50513          	add	a0,a0,190 # 80016860 <tickslock>
    800027aa:	ffffe097          	auipc	ra,0xffffe
    800027ae:	492080e7          	jalr	1170(ra) # 80000c3c <initlock>
}
    800027b2:	60a2                	ld	ra,8(sp)
    800027b4:	6402                	ld	s0,0(sp)
    800027b6:	0141                	add	sp,sp,16
    800027b8:	8082                	ret

00000000800027ba <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    800027ba:	1141                	add	sp,sp,-16
    800027bc:	e422                	sd	s0,8(sp)
    800027be:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027c0:	00003797          	auipc	a5,0x3
    800027c4:	45078793          	add	a5,a5,1104 # 80005c10 <kernelvec>
    800027c8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027cc:	6422                	ld	s0,8(sp)
    800027ce:	0141                	add	sp,sp,16
    800027d0:	8082                	ret

00000000800027d2 <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    800027d2:	1141                	add	sp,sp,-16
    800027d4:	e406                	sd	ra,8(sp)
    800027d6:	e022                	sd	s0,0(sp)
    800027d8:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    800027da:	fffff097          	auipc	ra,0xfffff
    800027de:	31e080e7          	jalr	798(ra) # 80001af8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027e6:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027e8:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027ec:	00005697          	auipc	a3,0x5
    800027f0:	81468693          	add	a3,a3,-2028 # 80007000 <_trampoline>
    800027f4:	00005717          	auipc	a4,0x5
    800027f8:	80c70713          	add	a4,a4,-2036 # 80007000 <_trampoline>
    800027fc:	8f15                	sub	a4,a4,a3
    800027fe:	040007b7          	lui	a5,0x4000
    80002802:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002804:	07b2                	sll	a5,a5,0xc
    80002806:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002808:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    8000280c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000280e:	18002673          	csrr	a2,satp
    80002812:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    80002814:	6d30                	ld	a2,88(a0)
    80002816:	6138                	ld	a4,64(a0)
    80002818:	6585                	lui	a1,0x1
    8000281a:	972e                	add	a4,a4,a1
    8000281c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000281e:	6d38                	ld	a4,88(a0)
    80002820:	00000617          	auipc	a2,0x0
    80002824:	13460613          	add	a2,a2,308 # 80002954 <usertrap>
    80002828:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    8000282a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000282c:	8612                	mv	a2,tp
    8000282e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002830:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    80002834:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    80002838:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000283c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    80002840:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002842:	6f18                	ld	a4,24(a4)
    80002844:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    80002848:	6928                	ld	a0,80(a0)
    8000284a:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000284c:	00005717          	auipc	a4,0x5
    80002850:	85070713          	add	a4,a4,-1968 # 8000709c <userret>
    80002854:	8f15                	sub	a4,a4,a3
    80002856:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002858:	577d                	li	a4,-1
    8000285a:	177e                	sll	a4,a4,0x3f
    8000285c:	8d59                	or	a0,a0,a4
    8000285e:	9782                	jalr	a5
}
    80002860:	60a2                	ld	ra,8(sp)
    80002862:	6402                	ld	s0,0(sp)
    80002864:	0141                	add	sp,sp,16
    80002866:	8082                	ret

0000000080002868 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002868:	1101                	add	sp,sp,-32
    8000286a:	ec06                	sd	ra,24(sp)
    8000286c:	e822                	sd	s0,16(sp)
    8000286e:	e426                	sd	s1,8(sp)
    80002870:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    80002872:	fffff097          	auipc	ra,0xfffff
    80002876:	25a080e7          	jalr	602(ra) # 80001acc <cpuid>
    8000287a:	cd19                	beqz	a0,80002898 <clockintr+0x30>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000287c:	c01027f3          	rdtime	a5
  }

  /* ask for the next timer interrupt. this also clears */
  /* the interrupt request. 1000000 is about a tenth */
  /* of a second. */
  w_stimecmp(r_time() + 1000000);
    80002880:	000f4737          	lui	a4,0xf4
    80002884:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002888:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000288a:	14d79073          	csrw	stimecmp,a5
}
    8000288e:	60e2                	ld	ra,24(sp)
    80002890:	6442                	ld	s0,16(sp)
    80002892:	64a2                	ld	s1,8(sp)
    80002894:	6105                	add	sp,sp,32
    80002896:	8082                	ret
    acquire(&tickslock);
    80002898:	00014497          	auipc	s1,0x14
    8000289c:	fc848493          	add	s1,s1,-56 # 80016860 <tickslock>
    800028a0:	8526                	mv	a0,s1
    800028a2:	ffffe097          	auipc	ra,0xffffe
    800028a6:	42a080e7          	jalr	1066(ra) # 80000ccc <acquire>
    ticks++;
    800028aa:	00006517          	auipc	a0,0x6
    800028ae:	05650513          	add	a0,a0,86 # 80008900 <ticks>
    800028b2:	411c                	lw	a5,0(a0)
    800028b4:	2785                	addw	a5,a5,1
    800028b6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	970080e7          	jalr	-1680(ra) # 80002228 <wakeup>
    release(&tickslock);
    800028c0:	8526                	mv	a0,s1
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	4be080e7          	jalr	1214(ra) # 80000d80 <release>
    800028ca:	bf4d                	j	8000287c <clockintr+0x14>

00000000800028cc <devintr>:
/* returns 2 if timer interrupt, */
/* 1 if other device, */
/* 0 if not recognized. */
int
devintr()
{
    800028cc:	1101                	add	sp,sp,-32
    800028ce:	ec06                	sd	ra,24(sp)
    800028d0:	e822                	sd	s0,16(sp)
    800028d2:	e426                	sd	s1,8(sp)
    800028d4:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800028da:	57fd                	li	a5,-1
    800028dc:	17fe                	sll	a5,a5,0x3f
    800028de:	07a5                	add	a5,a5,9
    800028e0:	00f70d63          	beq	a4,a5,800028fa <devintr+0x2e>
    /* now allowed to interrupt again. */
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800028e4:	57fd                	li	a5,-1
    800028e6:	17fe                	sll	a5,a5,0x3f
    800028e8:	0795                	add	a5,a5,5
    /* timer interrupt. */
    clockintr();
    return 2;
  } else {
    return 0;
    800028ea:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800028ec:	04f70e63          	beq	a4,a5,80002948 <devintr+0x7c>
  }
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6105                	add	sp,sp,32
    800028f8:	8082                	ret
    int irq = plic_claim();
    800028fa:	00003097          	auipc	ra,0x3
    800028fe:	3c2080e7          	jalr	962(ra) # 80005cbc <plic_claim>
    80002902:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002904:	47a9                	li	a5,10
    80002906:	02f50763          	beq	a0,a5,80002934 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    8000290a:	4785                	li	a5,1
    8000290c:	02f50963          	beq	a0,a5,8000293e <devintr+0x72>
    return 1;
    80002910:	4505                	li	a0,1
    } else if(irq){
    80002912:	dcf9                	beqz	s1,800028f0 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002914:	85a6                	mv	a1,s1
    80002916:	00006517          	auipc	a0,0x6
    8000291a:	a2250513          	add	a0,a0,-1502 # 80008338 <states.0+0x38>
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	be4080e7          	jalr	-1052(ra) # 80000502 <printf>
      plic_complete(irq);
    80002926:	8526                	mv	a0,s1
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	3b8080e7          	jalr	952(ra) # 80005ce0 <plic_complete>
    return 1;
    80002930:	4505                	li	a0,1
    80002932:	bf7d                	j	800028f0 <devintr+0x24>
      uartintr();
    80002934:	ffffe097          	auipc	ra,0xffffe
    80002938:	15a080e7          	jalr	346(ra) # 80000a8e <uartintr>
    if(irq)
    8000293c:	b7ed                	j	80002926 <devintr+0x5a>
      virtio_disk_intr();
    8000293e:	00004097          	auipc	ra,0x4
    80002942:	868080e7          	jalr	-1944(ra) # 800061a6 <virtio_disk_intr>
    if(irq)
    80002946:	b7c5                	j	80002926 <devintr+0x5a>
    clockintr();
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	f20080e7          	jalr	-224(ra) # 80002868 <clockintr>
    return 2;
    80002950:	4509                	li	a0,2
    80002952:	bf79                	j	800028f0 <devintr+0x24>

0000000080002954 <usertrap>:
{
    80002954:	1101                	add	sp,sp,-32
    80002956:	ec06                	sd	ra,24(sp)
    80002958:	e822                	sd	s0,16(sp)
    8000295a:	e426                	sd	s1,8(sp)
    8000295c:	e04a                	sd	s2,0(sp)
    8000295e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002960:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002964:	1007f793          	and	a5,a5,256
    80002968:	e3b1                	bnez	a5,800029ac <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000296a:	00003797          	auipc	a5,0x3
    8000296e:	2a678793          	add	a5,a5,678 # 80005c10 <kernelvec>
    80002972:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002976:	fffff097          	auipc	ra,0xfffff
    8000297a:	182080e7          	jalr	386(ra) # 80001af8 <myproc>
    8000297e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002980:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002982:	14102773          	csrr	a4,sepc
    80002986:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002988:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000298c:	47a1                	li	a5,8
    8000298e:	02f70763          	beq	a4,a5,800029bc <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002992:	00000097          	auipc	ra,0x0
    80002996:	f3a080e7          	jalr	-198(ra) # 800028cc <devintr>
    8000299a:	892a                	mv	s2,a0
    8000299c:	c151                	beqz	a0,80002a20 <usertrap+0xcc>
  if(killed(p))
    8000299e:	8526                	mv	a0,s1
    800029a0:	00000097          	auipc	ra,0x0
    800029a4:	acc080e7          	jalr	-1332(ra) # 8000246c <killed>
    800029a8:	c929                	beqz	a0,800029fa <usertrap+0xa6>
    800029aa:	a099                	j	800029f0 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800029ac:	00006517          	auipc	a0,0x6
    800029b0:	9ac50513          	add	a0,a0,-1620 # 80008358 <states.0+0x58>
    800029b4:	ffffe097          	auipc	ra,0xffffe
    800029b8:	e5a080e7          	jalr	-422(ra) # 8000080e <panic>
    if(killed(p))
    800029bc:	00000097          	auipc	ra,0x0
    800029c0:	ab0080e7          	jalr	-1360(ra) # 8000246c <killed>
    800029c4:	e921                	bnez	a0,80002a14 <usertrap+0xc0>
    p->trapframe->epc += 4;
    800029c6:	6cb8                	ld	a4,88(s1)
    800029c8:	6f1c                	ld	a5,24(a4)
    800029ca:	0791                	add	a5,a5,4
    800029cc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029d2:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029d6:	10079073          	csrw	sstatus,a5
    syscall();
    800029da:	00000097          	auipc	ra,0x0
    800029de:	2b4080e7          	jalr	692(ra) # 80002c8e <syscall>
  if(killed(p))
    800029e2:	8526                	mv	a0,s1
    800029e4:	00000097          	auipc	ra,0x0
    800029e8:	a88080e7          	jalr	-1400(ra) # 8000246c <killed>
    800029ec:	c911                	beqz	a0,80002a00 <usertrap+0xac>
    800029ee:	4901                	li	s2,0
    exit(-1);
    800029f0:	557d                	li	a0,-1
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	906080e7          	jalr	-1786(ra) # 800022f8 <exit>
  if(which_dev == 2)
    800029fa:	4789                	li	a5,2
    800029fc:	04f90f63          	beq	s2,a5,80002a5a <usertrap+0x106>
  usertrapret();
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	dd2080e7          	jalr	-558(ra) # 800027d2 <usertrapret>
}
    80002a08:	60e2                	ld	ra,24(sp)
    80002a0a:	6442                	ld	s0,16(sp)
    80002a0c:	64a2                	ld	s1,8(sp)
    80002a0e:	6902                	ld	s2,0(sp)
    80002a10:	6105                	add	sp,sp,32
    80002a12:	8082                	ret
      exit(-1);
    80002a14:	557d                	li	a0,-1
    80002a16:	00000097          	auipc	ra,0x0
    80002a1a:	8e2080e7          	jalr	-1822(ra) # 800022f8 <exit>
    80002a1e:	b765                	j	800029c6 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a20:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002a24:	5890                	lw	a2,48(s1)
    80002a26:	00006517          	auipc	a0,0x6
    80002a2a:	95250513          	add	a0,a0,-1710 # 80008378 <states.0+0x78>
    80002a2e:	ffffe097          	auipc	ra,0xffffe
    80002a32:	ad4080e7          	jalr	-1324(ra) # 80000502 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a36:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a3a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002a3e:	00006517          	auipc	a0,0x6
    80002a42:	96a50513          	add	a0,a0,-1686 # 800083a8 <states.0+0xa8>
    80002a46:	ffffe097          	auipc	ra,0xffffe
    80002a4a:	abc080e7          	jalr	-1348(ra) # 80000502 <printf>
    setkilled(p);
    80002a4e:	8526                	mv	a0,s1
    80002a50:	00000097          	auipc	ra,0x0
    80002a54:	9f0080e7          	jalr	-1552(ra) # 80002440 <setkilled>
    80002a58:	b769                	j	800029e2 <usertrap+0x8e>
    yield();
    80002a5a:	fffff097          	auipc	ra,0xfffff
    80002a5e:	72e080e7          	jalr	1838(ra) # 80002188 <yield>
    80002a62:	bf79                	j	80002a00 <usertrap+0xac>

0000000080002a64 <kerneltrap>:
{
    80002a64:	7179                	add	sp,sp,-48
    80002a66:	f406                	sd	ra,40(sp)
    80002a68:	f022                	sd	s0,32(sp)
    80002a6a:	ec26                	sd	s1,24(sp)
    80002a6c:	e84a                	sd	s2,16(sp)
    80002a6e:	e44e                	sd	s3,8(sp)
    80002a70:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a72:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a76:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a7a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a7e:	1004f793          	and	a5,s1,256
    80002a82:	cb85                	beqz	a5,80002ab2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a84:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a88:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002a8a:	ef85                	bnez	a5,80002ac2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	e40080e7          	jalr	-448(ra) # 800028cc <devintr>
    80002a94:	cd1d                	beqz	a0,80002ad2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0)
    80002a96:	4789                	li	a5,2
    80002a98:	06f50263          	beq	a0,a5,80002afc <kerneltrap+0x98>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a9c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aa0:	10049073          	csrw	sstatus,s1
}
    80002aa4:	70a2                	ld	ra,40(sp)
    80002aa6:	7402                	ld	s0,32(sp)
    80002aa8:	64e2                	ld	s1,24(sp)
    80002aaa:	6942                	ld	s2,16(sp)
    80002aac:	69a2                	ld	s3,8(sp)
    80002aae:	6145                	add	sp,sp,48
    80002ab0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002ab2:	00006517          	auipc	a0,0x6
    80002ab6:	91e50513          	add	a0,a0,-1762 # 800083d0 <states.0+0xd0>
    80002aba:	ffffe097          	auipc	ra,0xffffe
    80002abe:	d54080e7          	jalr	-684(ra) # 8000080e <panic>
    panic("kerneltrap: interrupts enabled");
    80002ac2:	00006517          	auipc	a0,0x6
    80002ac6:	93650513          	add	a0,a0,-1738 # 800083f8 <states.0+0xf8>
    80002aca:	ffffe097          	auipc	ra,0xffffe
    80002ace:	d44080e7          	jalr	-700(ra) # 8000080e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ad2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ad6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002ada:	85ce                	mv	a1,s3
    80002adc:	00006517          	auipc	a0,0x6
    80002ae0:	93c50513          	add	a0,a0,-1732 # 80008418 <states.0+0x118>
    80002ae4:	ffffe097          	auipc	ra,0xffffe
    80002ae8:	a1e080e7          	jalr	-1506(ra) # 80000502 <printf>
    panic("kerneltrap");
    80002aec:	00006517          	auipc	a0,0x6
    80002af0:	95450513          	add	a0,a0,-1708 # 80008440 <states.0+0x140>
    80002af4:	ffffe097          	auipc	ra,0xffffe
    80002af8:	d1a080e7          	jalr	-742(ra) # 8000080e <panic>
  if(which_dev == 2 && myproc() != 0)
    80002afc:	fffff097          	auipc	ra,0xfffff
    80002b00:	ffc080e7          	jalr	-4(ra) # 80001af8 <myproc>
    80002b04:	dd41                	beqz	a0,80002a9c <kerneltrap+0x38>
    yield();
    80002b06:	fffff097          	auipc	ra,0xfffff
    80002b0a:	682080e7          	jalr	1666(ra) # 80002188 <yield>
    80002b0e:	b779                	j	80002a9c <kerneltrap+0x38>

0000000080002b10 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b10:	1101                	add	sp,sp,-32
    80002b12:	ec06                	sd	ra,24(sp)
    80002b14:	e822                	sd	s0,16(sp)
    80002b16:	e426                	sd	s1,8(sp)
    80002b18:	1000                	add	s0,sp,32
    80002b1a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b1c:	fffff097          	auipc	ra,0xfffff
    80002b20:	fdc080e7          	jalr	-36(ra) # 80001af8 <myproc>
  switch (n) {
    80002b24:	4795                	li	a5,5
    80002b26:	0497e163          	bltu	a5,s1,80002b68 <argraw+0x58>
    80002b2a:	048a                	sll	s1,s1,0x2
    80002b2c:	00006717          	auipc	a4,0x6
    80002b30:	94c70713          	add	a4,a4,-1716 # 80008478 <states.0+0x178>
    80002b34:	94ba                	add	s1,s1,a4
    80002b36:	409c                	lw	a5,0(s1)
    80002b38:	97ba                	add	a5,a5,a4
    80002b3a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b3c:	6d3c                	ld	a5,88(a0)
    80002b3e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b40:	60e2                	ld	ra,24(sp)
    80002b42:	6442                	ld	s0,16(sp)
    80002b44:	64a2                	ld	s1,8(sp)
    80002b46:	6105                	add	sp,sp,32
    80002b48:	8082                	ret
    return p->trapframe->a1;
    80002b4a:	6d3c                	ld	a5,88(a0)
    80002b4c:	7fa8                	ld	a0,120(a5)
    80002b4e:	bfcd                	j	80002b40 <argraw+0x30>
    return p->trapframe->a2;
    80002b50:	6d3c                	ld	a5,88(a0)
    80002b52:	63c8                	ld	a0,128(a5)
    80002b54:	b7f5                	j	80002b40 <argraw+0x30>
    return p->trapframe->a3;
    80002b56:	6d3c                	ld	a5,88(a0)
    80002b58:	67c8                	ld	a0,136(a5)
    80002b5a:	b7dd                	j	80002b40 <argraw+0x30>
    return p->trapframe->a4;
    80002b5c:	6d3c                	ld	a5,88(a0)
    80002b5e:	6bc8                	ld	a0,144(a5)
    80002b60:	b7c5                	j	80002b40 <argraw+0x30>
    return p->trapframe->a5;
    80002b62:	6d3c                	ld	a5,88(a0)
    80002b64:	6fc8                	ld	a0,152(a5)
    80002b66:	bfe9                	j	80002b40 <argraw+0x30>
  panic("argraw");
    80002b68:	00006517          	auipc	a0,0x6
    80002b6c:	8e850513          	add	a0,a0,-1816 # 80008450 <states.0+0x150>
    80002b70:	ffffe097          	auipc	ra,0xffffe
    80002b74:	c9e080e7          	jalr	-866(ra) # 8000080e <panic>

0000000080002b78 <fetchaddr>:
{
    80002b78:	1101                	add	sp,sp,-32
    80002b7a:	ec06                	sd	ra,24(sp)
    80002b7c:	e822                	sd	s0,16(sp)
    80002b7e:	e426                	sd	s1,8(sp)
    80002b80:	e04a                	sd	s2,0(sp)
    80002b82:	1000                	add	s0,sp,32
    80002b84:	84aa                	mv	s1,a0
    80002b86:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b88:	fffff097          	auipc	ra,0xfffff
    80002b8c:	f70080e7          	jalr	-144(ra) # 80001af8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80002b90:	653c                	ld	a5,72(a0)
    80002b92:	02f4f863          	bgeu	s1,a5,80002bc2 <fetchaddr+0x4a>
    80002b96:	00848713          	add	a4,s1,8
    80002b9a:	02e7e663          	bltu	a5,a4,80002bc6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b9e:	46a1                	li	a3,8
    80002ba0:	8626                	mv	a2,s1
    80002ba2:	85ca                	mv	a1,s2
    80002ba4:	6928                	ld	a0,80(a0)
    80002ba6:	fffff097          	auipc	ra,0xfffff
    80002baa:	c9e080e7          	jalr	-866(ra) # 80001844 <copyin>
    80002bae:	00a03533          	snez	a0,a0
    80002bb2:	40a00533          	neg	a0,a0
}
    80002bb6:	60e2                	ld	ra,24(sp)
    80002bb8:	6442                	ld	s0,16(sp)
    80002bba:	64a2                	ld	s1,8(sp)
    80002bbc:	6902                	ld	s2,0(sp)
    80002bbe:	6105                	add	sp,sp,32
    80002bc0:	8082                	ret
    return -1;
    80002bc2:	557d                	li	a0,-1
    80002bc4:	bfcd                	j	80002bb6 <fetchaddr+0x3e>
    80002bc6:	557d                	li	a0,-1
    80002bc8:	b7fd                	j	80002bb6 <fetchaddr+0x3e>

0000000080002bca <fetchstr>:
{
    80002bca:	7179                	add	sp,sp,-48
    80002bcc:	f406                	sd	ra,40(sp)
    80002bce:	f022                	sd	s0,32(sp)
    80002bd0:	ec26                	sd	s1,24(sp)
    80002bd2:	e84a                	sd	s2,16(sp)
    80002bd4:	e44e                	sd	s3,8(sp)
    80002bd6:	1800                	add	s0,sp,48
    80002bd8:	892a                	mv	s2,a0
    80002bda:	84ae                	mv	s1,a1
    80002bdc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bde:	fffff097          	auipc	ra,0xfffff
    80002be2:	f1a080e7          	jalr	-230(ra) # 80001af8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002be6:	86ce                	mv	a3,s3
    80002be8:	864a                	mv	a2,s2
    80002bea:	85a6                	mv	a1,s1
    80002bec:	6928                	ld	a0,80(a0)
    80002bee:	fffff097          	auipc	ra,0xfffff
    80002bf2:	ce4080e7          	jalr	-796(ra) # 800018d2 <copyinstr>
    80002bf6:	00054e63          	bltz	a0,80002c12 <fetchstr+0x48>
  return strlen(buf);
    80002bfa:	8526                	mv	a0,s1
    80002bfc:	ffffe097          	auipc	ra,0xffffe
    80002c00:	346080e7          	jalr	838(ra) # 80000f42 <strlen>
}
    80002c04:	70a2                	ld	ra,40(sp)
    80002c06:	7402                	ld	s0,32(sp)
    80002c08:	64e2                	ld	s1,24(sp)
    80002c0a:	6942                	ld	s2,16(sp)
    80002c0c:	69a2                	ld	s3,8(sp)
    80002c0e:	6145                	add	sp,sp,48
    80002c10:	8082                	ret
    return -1;
    80002c12:	557d                	li	a0,-1
    80002c14:	bfc5                	j	80002c04 <fetchstr+0x3a>

0000000080002c16 <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    80002c16:	1101                	add	sp,sp,-32
    80002c18:	ec06                	sd	ra,24(sp)
    80002c1a:	e822                	sd	s0,16(sp)
    80002c1c:	e426                	sd	s1,8(sp)
    80002c1e:	1000                	add	s0,sp,32
    80002c20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	eee080e7          	jalr	-274(ra) # 80002b10 <argraw>
    80002c2a:	c088                	sw	a0,0(s1)
}
    80002c2c:	60e2                	ld	ra,24(sp)
    80002c2e:	6442                	ld	s0,16(sp)
    80002c30:	64a2                	ld	s1,8(sp)
    80002c32:	6105                	add	sp,sp,32
    80002c34:	8082                	ret

0000000080002c36 <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    80002c36:	1101                	add	sp,sp,-32
    80002c38:	ec06                	sd	ra,24(sp)
    80002c3a:	e822                	sd	s0,16(sp)
    80002c3c:	e426                	sd	s1,8(sp)
    80002c3e:	1000                	add	s0,sp,32
    80002c40:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	ece080e7          	jalr	-306(ra) # 80002b10 <argraw>
    80002c4a:	e088                	sd	a0,0(s1)
}
    80002c4c:	60e2                	ld	ra,24(sp)
    80002c4e:	6442                	ld	s0,16(sp)
    80002c50:	64a2                	ld	s1,8(sp)
    80002c52:	6105                	add	sp,sp,32
    80002c54:	8082                	ret

0000000080002c56 <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80002c56:	7179                	add	sp,sp,-48
    80002c58:	f406                	sd	ra,40(sp)
    80002c5a:	f022                	sd	s0,32(sp)
    80002c5c:	ec26                	sd	s1,24(sp)
    80002c5e:	e84a                	sd	s2,16(sp)
    80002c60:	1800                	add	s0,sp,48
    80002c62:	84ae                	mv	s1,a1
    80002c64:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c66:	fd840593          	add	a1,s0,-40
    80002c6a:	00000097          	auipc	ra,0x0
    80002c6e:	fcc080e7          	jalr	-52(ra) # 80002c36 <argaddr>
  return fetchstr(addr, buf, max);
    80002c72:	864a                	mv	a2,s2
    80002c74:	85a6                	mv	a1,s1
    80002c76:	fd843503          	ld	a0,-40(s0)
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	f50080e7          	jalr	-176(ra) # 80002bca <fetchstr>
}
    80002c82:	70a2                	ld	ra,40(sp)
    80002c84:	7402                	ld	s0,32(sp)
    80002c86:	64e2                	ld	s1,24(sp)
    80002c88:	6942                	ld	s2,16(sp)
    80002c8a:	6145                	add	sp,sp,48
    80002c8c:	8082                	ret

0000000080002c8e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002c8e:	1101                	add	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	e04a                	sd	s2,0(sp)
    80002c98:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c9a:	fffff097          	auipc	ra,0xfffff
    80002c9e:	e5e080e7          	jalr	-418(ra) # 80001af8 <myproc>
    80002ca2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ca4:	05853903          	ld	s2,88(a0)
    80002ca8:	0a893783          	ld	a5,168(s2)
    80002cac:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cb0:	37fd                	addw	a5,a5,-1
    80002cb2:	4751                	li	a4,20
    80002cb4:	00f76f63          	bltu	a4,a5,80002cd2 <syscall+0x44>
    80002cb8:	00369713          	sll	a4,a3,0x3
    80002cbc:	00005797          	auipc	a5,0x5
    80002cc0:	7d478793          	add	a5,a5,2004 # 80008490 <syscalls>
    80002cc4:	97ba                	add	a5,a5,a4
    80002cc6:	639c                	ld	a5,0(a5)
    80002cc8:	c789                	beqz	a5,80002cd2 <syscall+0x44>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    80002cca:	9782                	jalr	a5
    80002ccc:	06a93823          	sd	a0,112(s2)
    80002cd0:	a839                	j	80002cee <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002cd2:	15848613          	add	a2,s1,344
    80002cd6:	588c                	lw	a1,48(s1)
    80002cd8:	00005517          	auipc	a0,0x5
    80002cdc:	78050513          	add	a0,a0,1920 # 80008458 <states.0+0x158>
    80002ce0:	ffffe097          	auipc	ra,0xffffe
    80002ce4:	822080e7          	jalr	-2014(ra) # 80000502 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002ce8:	6cbc                	ld	a5,88(s1)
    80002cea:	577d                	li	a4,-1
    80002cec:	fbb8                	sd	a4,112(a5)
  }
}
    80002cee:	60e2                	ld	ra,24(sp)
    80002cf0:	6442                	ld	s0,16(sp)
    80002cf2:	64a2                	ld	s1,8(sp)
    80002cf4:	6902                	ld	s2,0(sp)
    80002cf6:	6105                	add	sp,sp,32
    80002cf8:	8082                	ret

0000000080002cfa <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002cfa:	1101                	add	sp,sp,-32
    80002cfc:	ec06                	sd	ra,24(sp)
    80002cfe:	e822                	sd	s0,16(sp)
    80002d00:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002d02:	fec40593          	add	a1,s0,-20
    80002d06:	4501                	li	a0,0
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	f0e080e7          	jalr	-242(ra) # 80002c16 <argint>
  exit(n);
    80002d10:	fec42503          	lw	a0,-20(s0)
    80002d14:	fffff097          	auipc	ra,0xfffff
    80002d18:	5e4080e7          	jalr	1508(ra) # 800022f8 <exit>
  return 0;  /* not reached */
}
    80002d1c:	4501                	li	a0,0
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	6105                	add	sp,sp,32
    80002d24:	8082                	ret

0000000080002d26 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d26:	1141                	add	sp,sp,-16
    80002d28:	e406                	sd	ra,8(sp)
    80002d2a:	e022                	sd	s0,0(sp)
    80002d2c:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002d2e:	fffff097          	auipc	ra,0xfffff
    80002d32:	dca080e7          	jalr	-566(ra) # 80001af8 <myproc>
}
    80002d36:	5908                	lw	a0,48(a0)
    80002d38:	60a2                	ld	ra,8(sp)
    80002d3a:	6402                	ld	s0,0(sp)
    80002d3c:	0141                	add	sp,sp,16
    80002d3e:	8082                	ret

0000000080002d40 <sys_fork>:

uint64
sys_fork(void)
{
    80002d40:	1141                	add	sp,sp,-16
    80002d42:	e406                	sd	ra,8(sp)
    80002d44:	e022                	sd	s0,0(sp)
    80002d46:	0800                	add	s0,sp,16
  return fork();
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	16a080e7          	jalr	362(ra) # 80001eb2 <fork>
}
    80002d50:	60a2                	ld	ra,8(sp)
    80002d52:	6402                	ld	s0,0(sp)
    80002d54:	0141                	add	sp,sp,16
    80002d56:	8082                	ret

0000000080002d58 <sys_wait>:

uint64
sys_wait(void)
{
    80002d58:	1101                	add	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d60:	fe840593          	add	a1,s0,-24
    80002d64:	4501                	li	a0,0
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	ed0080e7          	jalr	-304(ra) # 80002c36 <argaddr>
  return wait(p);
    80002d6e:	fe843503          	ld	a0,-24(s0)
    80002d72:	fffff097          	auipc	ra,0xfffff
    80002d76:	72c080e7          	jalr	1836(ra) # 8000249e <wait>
}
    80002d7a:	60e2                	ld	ra,24(sp)
    80002d7c:	6442                	ld	s0,16(sp)
    80002d7e:	6105                	add	sp,sp,32
    80002d80:	8082                	ret

0000000080002d82 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d82:	7179                	add	sp,sp,-48
    80002d84:	f406                	sd	ra,40(sp)
    80002d86:	f022                	sd	s0,32(sp)
    80002d88:	ec26                	sd	s1,24(sp)
    80002d8a:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d8c:	fdc40593          	add	a1,s0,-36
    80002d90:	4501                	li	a0,0
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	e84080e7          	jalr	-380(ra) # 80002c16 <argint>
  addr = myproc()->sz;
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	d5e080e7          	jalr	-674(ra) # 80001af8 <myproc>
    80002da2:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002da4:	fdc42503          	lw	a0,-36(s0)
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	0ae080e7          	jalr	174(ra) # 80001e56 <growproc>
    80002db0:	00054863          	bltz	a0,80002dc0 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002db4:	8526                	mv	a0,s1
    80002db6:	70a2                	ld	ra,40(sp)
    80002db8:	7402                	ld	s0,32(sp)
    80002dba:	64e2                	ld	s1,24(sp)
    80002dbc:	6145                	add	sp,sp,48
    80002dbe:	8082                	ret
    return -1;
    80002dc0:	54fd                	li	s1,-1
    80002dc2:	bfcd                	j	80002db4 <sys_sbrk+0x32>

0000000080002dc4 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dc4:	7139                	add	sp,sp,-64
    80002dc6:	fc06                	sd	ra,56(sp)
    80002dc8:	f822                	sd	s0,48(sp)
    80002dca:	f426                	sd	s1,40(sp)
    80002dcc:	f04a                	sd	s2,32(sp)
    80002dce:	ec4e                	sd	s3,24(sp)
    80002dd0:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002dd2:	fcc40593          	add	a1,s0,-52
    80002dd6:	4501                	li	a0,0
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	e3e080e7          	jalr	-450(ra) # 80002c16 <argint>
  if(n < 0)
    80002de0:	fcc42783          	lw	a5,-52(s0)
    80002de4:	0607cf63          	bltz	a5,80002e62 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002de8:	00014517          	auipc	a0,0x14
    80002dec:	a7850513          	add	a0,a0,-1416 # 80016860 <tickslock>
    80002df0:	ffffe097          	auipc	ra,0xffffe
    80002df4:	edc080e7          	jalr	-292(ra) # 80000ccc <acquire>
  ticks0 = ticks;
    80002df8:	00006917          	auipc	s2,0x6
    80002dfc:	b0892903          	lw	s2,-1272(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002e00:	fcc42783          	lw	a5,-52(s0)
    80002e04:	cf9d                	beqz	a5,80002e42 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e06:	00014997          	auipc	s3,0x14
    80002e0a:	a5a98993          	add	s3,s3,-1446 # 80016860 <tickslock>
    80002e0e:	00006497          	auipc	s1,0x6
    80002e12:	af248493          	add	s1,s1,-1294 # 80008900 <ticks>
    if(killed(myproc())){
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	ce2080e7          	jalr	-798(ra) # 80001af8 <myproc>
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	64e080e7          	jalr	1614(ra) # 8000246c <killed>
    80002e26:	e129                	bnez	a0,80002e68 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002e28:	85ce                	mv	a1,s3
    80002e2a:	8526                	mv	a0,s1
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	398080e7          	jalr	920(ra) # 800021c4 <sleep>
  while(ticks - ticks0 < n){
    80002e34:	409c                	lw	a5,0(s1)
    80002e36:	412787bb          	subw	a5,a5,s2
    80002e3a:	fcc42703          	lw	a4,-52(s0)
    80002e3e:	fce7ece3          	bltu	a5,a4,80002e16 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002e42:	00014517          	auipc	a0,0x14
    80002e46:	a1e50513          	add	a0,a0,-1506 # 80016860 <tickslock>
    80002e4a:	ffffe097          	auipc	ra,0xffffe
    80002e4e:	f36080e7          	jalr	-202(ra) # 80000d80 <release>
  return 0;
    80002e52:	4501                	li	a0,0
}
    80002e54:	70e2                	ld	ra,56(sp)
    80002e56:	7442                	ld	s0,48(sp)
    80002e58:	74a2                	ld	s1,40(sp)
    80002e5a:	7902                	ld	s2,32(sp)
    80002e5c:	69e2                	ld	s3,24(sp)
    80002e5e:	6121                	add	sp,sp,64
    80002e60:	8082                	ret
    n = 0;
    80002e62:	fc042623          	sw	zero,-52(s0)
    80002e66:	b749                	j	80002de8 <sys_sleep+0x24>
      release(&tickslock);
    80002e68:	00014517          	auipc	a0,0x14
    80002e6c:	9f850513          	add	a0,a0,-1544 # 80016860 <tickslock>
    80002e70:	ffffe097          	auipc	ra,0xffffe
    80002e74:	f10080e7          	jalr	-240(ra) # 80000d80 <release>
      return -1;
    80002e78:	557d                	li	a0,-1
    80002e7a:	bfe9                	j	80002e54 <sys_sleep+0x90>

0000000080002e7c <sys_kill>:

uint64
sys_kill(void)
{
    80002e7c:	1101                	add	sp,sp,-32
    80002e7e:	ec06                	sd	ra,24(sp)
    80002e80:	e822                	sd	s0,16(sp)
    80002e82:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e84:	fec40593          	add	a1,s0,-20
    80002e88:	4501                	li	a0,0
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	d8c080e7          	jalr	-628(ra) # 80002c16 <argint>
  return kill(pid);
    80002e92:	fec42503          	lw	a0,-20(s0)
    80002e96:	fffff097          	auipc	ra,0xfffff
    80002e9a:	538080e7          	jalr	1336(ra) # 800023ce <kill>
}
    80002e9e:	60e2                	ld	ra,24(sp)
    80002ea0:	6442                	ld	s0,16(sp)
    80002ea2:	6105                	add	sp,sp,32
    80002ea4:	8082                	ret

0000000080002ea6 <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    80002ea6:	1101                	add	sp,sp,-32
    80002ea8:	ec06                	sd	ra,24(sp)
    80002eaa:	e822                	sd	s0,16(sp)
    80002eac:	e426                	sd	s1,8(sp)
    80002eae:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002eb0:	00014517          	auipc	a0,0x14
    80002eb4:	9b050513          	add	a0,a0,-1616 # 80016860 <tickslock>
    80002eb8:	ffffe097          	auipc	ra,0xffffe
    80002ebc:	e14080e7          	jalr	-492(ra) # 80000ccc <acquire>
  xticks = ticks;
    80002ec0:	00006497          	auipc	s1,0x6
    80002ec4:	a404a483          	lw	s1,-1472(s1) # 80008900 <ticks>
  release(&tickslock);
    80002ec8:	00014517          	auipc	a0,0x14
    80002ecc:	99850513          	add	a0,a0,-1640 # 80016860 <tickslock>
    80002ed0:	ffffe097          	auipc	ra,0xffffe
    80002ed4:	eb0080e7          	jalr	-336(ra) # 80000d80 <release>
  return xticks;
}
    80002ed8:	02049513          	sll	a0,s1,0x20
    80002edc:	9101                	srl	a0,a0,0x20
    80002ede:	60e2                	ld	ra,24(sp)
    80002ee0:	6442                	ld	s0,16(sp)
    80002ee2:	64a2                	ld	s1,8(sp)
    80002ee4:	6105                	add	sp,sp,32
    80002ee6:	8082                	ret

0000000080002ee8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ee8:	7179                	add	sp,sp,-48
    80002eea:	f406                	sd	ra,40(sp)
    80002eec:	f022                	sd	s0,32(sp)
    80002eee:	ec26                	sd	s1,24(sp)
    80002ef0:	e84a                	sd	s2,16(sp)
    80002ef2:	e44e                	sd	s3,8(sp)
    80002ef4:	e052                	sd	s4,0(sp)
    80002ef6:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ef8:	00005597          	auipc	a1,0x5
    80002efc:	64858593          	add	a1,a1,1608 # 80008540 <syscalls+0xb0>
    80002f00:	00014517          	auipc	a0,0x14
    80002f04:	97850513          	add	a0,a0,-1672 # 80016878 <bcache>
    80002f08:	ffffe097          	auipc	ra,0xffffe
    80002f0c:	d34080e7          	jalr	-716(ra) # 80000c3c <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    80002f10:	0001c797          	auipc	a5,0x1c
    80002f14:	96878793          	add	a5,a5,-1688 # 8001e878 <bcache+0x8000>
    80002f18:	0001c717          	auipc	a4,0x1c
    80002f1c:	bc870713          	add	a4,a4,-1080 # 8001eae0 <bcache+0x8268>
    80002f20:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f24:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f28:	00014497          	auipc	s1,0x14
    80002f2c:	96848493          	add	s1,s1,-1688 # 80016890 <bcache+0x18>
    b->next = bcache.head.next;
    80002f30:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f32:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f34:	00005a17          	auipc	s4,0x5
    80002f38:	614a0a13          	add	s4,s4,1556 # 80008548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002f3c:	2b893783          	ld	a5,696(s2)
    80002f40:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f42:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f46:	85d2                	mv	a1,s4
    80002f48:	01048513          	add	a0,s1,16
    80002f4c:	00001097          	auipc	ra,0x1
    80002f50:	496080e7          	jalr	1174(ra) # 800043e2 <initsleeplock>
    bcache.head.next->prev = b;
    80002f54:	2b893783          	ld	a5,696(s2)
    80002f58:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f5a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f5e:	45848493          	add	s1,s1,1112
    80002f62:	fd349de3          	bne	s1,s3,80002f3c <binit+0x54>
  }
}
    80002f66:	70a2                	ld	ra,40(sp)
    80002f68:	7402                	ld	s0,32(sp)
    80002f6a:	64e2                	ld	s1,24(sp)
    80002f6c:	6942                	ld	s2,16(sp)
    80002f6e:	69a2                	ld	s3,8(sp)
    80002f70:	6a02                	ld	s4,0(sp)
    80002f72:	6145                	add	sp,sp,48
    80002f74:	8082                	ret

0000000080002f76 <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    80002f76:	7179                	add	sp,sp,-48
    80002f78:	f406                	sd	ra,40(sp)
    80002f7a:	f022                	sd	s0,32(sp)
    80002f7c:	ec26                	sd	s1,24(sp)
    80002f7e:	e84a                	sd	s2,16(sp)
    80002f80:	e44e                	sd	s3,8(sp)
    80002f82:	1800                	add	s0,sp,48
    80002f84:	892a                	mv	s2,a0
    80002f86:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f88:	00014517          	auipc	a0,0x14
    80002f8c:	8f050513          	add	a0,a0,-1808 # 80016878 <bcache>
    80002f90:	ffffe097          	auipc	ra,0xffffe
    80002f94:	d3c080e7          	jalr	-708(ra) # 80000ccc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f98:	0001c497          	auipc	s1,0x1c
    80002f9c:	b984b483          	ld	s1,-1128(s1) # 8001eb30 <bcache+0x82b8>
    80002fa0:	0001c797          	auipc	a5,0x1c
    80002fa4:	b4078793          	add	a5,a5,-1216 # 8001eae0 <bcache+0x8268>
    80002fa8:	02f48f63          	beq	s1,a5,80002fe6 <bread+0x70>
    80002fac:	873e                	mv	a4,a5
    80002fae:	a021                	j	80002fb6 <bread+0x40>
    80002fb0:	68a4                	ld	s1,80(s1)
    80002fb2:	02e48a63          	beq	s1,a4,80002fe6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002fb6:	449c                	lw	a5,8(s1)
    80002fb8:	ff279ce3          	bne	a5,s2,80002fb0 <bread+0x3a>
    80002fbc:	44dc                	lw	a5,12(s1)
    80002fbe:	ff3799e3          	bne	a5,s3,80002fb0 <bread+0x3a>
      b->refcnt++;
    80002fc2:	40bc                	lw	a5,64(s1)
    80002fc4:	2785                	addw	a5,a5,1
    80002fc6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fc8:	00014517          	auipc	a0,0x14
    80002fcc:	8b050513          	add	a0,a0,-1872 # 80016878 <bcache>
    80002fd0:	ffffe097          	auipc	ra,0xffffe
    80002fd4:	db0080e7          	jalr	-592(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    80002fd8:	01048513          	add	a0,s1,16
    80002fdc:	00001097          	auipc	ra,0x1
    80002fe0:	440080e7          	jalr	1088(ra) # 8000441c <acquiresleep>
      return b;
    80002fe4:	a8b9                	j	80003042 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fe6:	0001c497          	auipc	s1,0x1c
    80002fea:	b424b483          	ld	s1,-1214(s1) # 8001eb28 <bcache+0x82b0>
    80002fee:	0001c797          	auipc	a5,0x1c
    80002ff2:	af278793          	add	a5,a5,-1294 # 8001eae0 <bcache+0x8268>
    80002ff6:	00f48863          	beq	s1,a5,80003006 <bread+0x90>
    80002ffa:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002ffc:	40bc                	lw	a5,64(s1)
    80002ffe:	cf81                	beqz	a5,80003016 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003000:	64a4                	ld	s1,72(s1)
    80003002:	fee49de3          	bne	s1,a4,80002ffc <bread+0x86>
  panic("bget: no buffers");
    80003006:	00005517          	auipc	a0,0x5
    8000300a:	54a50513          	add	a0,a0,1354 # 80008550 <syscalls+0xc0>
    8000300e:	ffffe097          	auipc	ra,0xffffe
    80003012:	800080e7          	jalr	-2048(ra) # 8000080e <panic>
      b->dev = dev;
    80003016:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000301a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000301e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003022:	4785                	li	a5,1
    80003024:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003026:	00014517          	auipc	a0,0x14
    8000302a:	85250513          	add	a0,a0,-1966 # 80016878 <bcache>
    8000302e:	ffffe097          	auipc	ra,0xffffe
    80003032:	d52080e7          	jalr	-686(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    80003036:	01048513          	add	a0,s1,16
    8000303a:	00001097          	auipc	ra,0x1
    8000303e:	3e2080e7          	jalr	994(ra) # 8000441c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003042:	409c                	lw	a5,0(s1)
    80003044:	cb89                	beqz	a5,80003056 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003046:	8526                	mv	a0,s1
    80003048:	70a2                	ld	ra,40(sp)
    8000304a:	7402                	ld	s0,32(sp)
    8000304c:	64e2                	ld	s1,24(sp)
    8000304e:	6942                	ld	s2,16(sp)
    80003050:	69a2                	ld	s3,8(sp)
    80003052:	6145                	add	sp,sp,48
    80003054:	8082                	ret
    virtio_disk_rw(b, 0);
    80003056:	4581                	li	a1,0
    80003058:	8526                	mv	a0,s1
    8000305a:	00003097          	auipc	ra,0x3
    8000305e:	f1c080e7          	jalr	-228(ra) # 80005f76 <virtio_disk_rw>
    b->valid = 1;
    80003062:	4785                	li	a5,1
    80003064:	c09c                	sw	a5,0(s1)
  return b;
    80003066:	b7c5                	j	80003046 <bread+0xd0>

0000000080003068 <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    80003068:	1101                	add	sp,sp,-32
    8000306a:	ec06                	sd	ra,24(sp)
    8000306c:	e822                	sd	s0,16(sp)
    8000306e:	e426                	sd	s1,8(sp)
    80003070:	1000                	add	s0,sp,32
    80003072:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003074:	0541                	add	a0,a0,16
    80003076:	00001097          	auipc	ra,0x1
    8000307a:	440080e7          	jalr	1088(ra) # 800044b6 <holdingsleep>
    8000307e:	cd01                	beqz	a0,80003096 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003080:	4585                	li	a1,1
    80003082:	8526                	mv	a0,s1
    80003084:	00003097          	auipc	ra,0x3
    80003088:	ef2080e7          	jalr	-270(ra) # 80005f76 <virtio_disk_rw>
}
    8000308c:	60e2                	ld	ra,24(sp)
    8000308e:	6442                	ld	s0,16(sp)
    80003090:	64a2                	ld	s1,8(sp)
    80003092:	6105                	add	sp,sp,32
    80003094:	8082                	ret
    panic("bwrite");
    80003096:	00005517          	auipc	a0,0x5
    8000309a:	4d250513          	add	a0,a0,1234 # 80008568 <syscalls+0xd8>
    8000309e:	ffffd097          	auipc	ra,0xffffd
    800030a2:	770080e7          	jalr	1904(ra) # 8000080e <panic>

00000000800030a6 <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    800030a6:	1101                	add	sp,sp,-32
    800030a8:	ec06                	sd	ra,24(sp)
    800030aa:	e822                	sd	s0,16(sp)
    800030ac:	e426                	sd	s1,8(sp)
    800030ae:	e04a                	sd	s2,0(sp)
    800030b0:	1000                	add	s0,sp,32
    800030b2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030b4:	01050913          	add	s2,a0,16
    800030b8:	854a                	mv	a0,s2
    800030ba:	00001097          	auipc	ra,0x1
    800030be:	3fc080e7          	jalr	1020(ra) # 800044b6 <holdingsleep>
    800030c2:	c925                	beqz	a0,80003132 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800030c4:	854a                	mv	a0,s2
    800030c6:	00001097          	auipc	ra,0x1
    800030ca:	3ac080e7          	jalr	940(ra) # 80004472 <releasesleep>

  acquire(&bcache.lock);
    800030ce:	00013517          	auipc	a0,0x13
    800030d2:	7aa50513          	add	a0,a0,1962 # 80016878 <bcache>
    800030d6:	ffffe097          	auipc	ra,0xffffe
    800030da:	bf6080e7          	jalr	-1034(ra) # 80000ccc <acquire>
  b->refcnt--;
    800030de:	40bc                	lw	a5,64(s1)
    800030e0:	37fd                	addw	a5,a5,-1
    800030e2:	0007871b          	sext.w	a4,a5
    800030e6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030e8:	e71d                	bnez	a4,80003116 <brelse+0x70>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    800030ea:	68b8                	ld	a4,80(s1)
    800030ec:	64bc                	ld	a5,72(s1)
    800030ee:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800030f0:	68b8                	ld	a4,80(s1)
    800030f2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030f4:	0001b797          	auipc	a5,0x1b
    800030f8:	78478793          	add	a5,a5,1924 # 8001e878 <bcache+0x8000>
    800030fc:	2b87b703          	ld	a4,696(a5)
    80003100:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003102:	0001c717          	auipc	a4,0x1c
    80003106:	9de70713          	add	a4,a4,-1570 # 8001eae0 <bcache+0x8268>
    8000310a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000310c:	2b87b703          	ld	a4,696(a5)
    80003110:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003112:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003116:	00013517          	auipc	a0,0x13
    8000311a:	76250513          	add	a0,a0,1890 # 80016878 <bcache>
    8000311e:	ffffe097          	auipc	ra,0xffffe
    80003122:	c62080e7          	jalr	-926(ra) # 80000d80 <release>
}
    80003126:	60e2                	ld	ra,24(sp)
    80003128:	6442                	ld	s0,16(sp)
    8000312a:	64a2                	ld	s1,8(sp)
    8000312c:	6902                	ld	s2,0(sp)
    8000312e:	6105                	add	sp,sp,32
    80003130:	8082                	ret
    panic("brelse");
    80003132:	00005517          	auipc	a0,0x5
    80003136:	43e50513          	add	a0,a0,1086 # 80008570 <syscalls+0xe0>
    8000313a:	ffffd097          	auipc	ra,0xffffd
    8000313e:	6d4080e7          	jalr	1748(ra) # 8000080e <panic>

0000000080003142 <bpin>:

void
bpin(struct buf *b) {
    80003142:	1101                	add	sp,sp,-32
    80003144:	ec06                	sd	ra,24(sp)
    80003146:	e822                	sd	s0,16(sp)
    80003148:	e426                	sd	s1,8(sp)
    8000314a:	1000                	add	s0,sp,32
    8000314c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000314e:	00013517          	auipc	a0,0x13
    80003152:	72a50513          	add	a0,a0,1834 # 80016878 <bcache>
    80003156:	ffffe097          	auipc	ra,0xffffe
    8000315a:	b76080e7          	jalr	-1162(ra) # 80000ccc <acquire>
  b->refcnt++;
    8000315e:	40bc                	lw	a5,64(s1)
    80003160:	2785                	addw	a5,a5,1
    80003162:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003164:	00013517          	auipc	a0,0x13
    80003168:	71450513          	add	a0,a0,1812 # 80016878 <bcache>
    8000316c:	ffffe097          	auipc	ra,0xffffe
    80003170:	c14080e7          	jalr	-1004(ra) # 80000d80 <release>
}
    80003174:	60e2                	ld	ra,24(sp)
    80003176:	6442                	ld	s0,16(sp)
    80003178:	64a2                	ld	s1,8(sp)
    8000317a:	6105                	add	sp,sp,32
    8000317c:	8082                	ret

000000008000317e <bunpin>:

void
bunpin(struct buf *b) {
    8000317e:	1101                	add	sp,sp,-32
    80003180:	ec06                	sd	ra,24(sp)
    80003182:	e822                	sd	s0,16(sp)
    80003184:	e426                	sd	s1,8(sp)
    80003186:	1000                	add	s0,sp,32
    80003188:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000318a:	00013517          	auipc	a0,0x13
    8000318e:	6ee50513          	add	a0,a0,1774 # 80016878 <bcache>
    80003192:	ffffe097          	auipc	ra,0xffffe
    80003196:	b3a080e7          	jalr	-1222(ra) # 80000ccc <acquire>
  b->refcnt--;
    8000319a:	40bc                	lw	a5,64(s1)
    8000319c:	37fd                	addw	a5,a5,-1
    8000319e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031a0:	00013517          	auipc	a0,0x13
    800031a4:	6d850513          	add	a0,a0,1752 # 80016878 <bcache>
    800031a8:	ffffe097          	auipc	ra,0xffffe
    800031ac:	bd8080e7          	jalr	-1064(ra) # 80000d80 <release>
}
    800031b0:	60e2                	ld	ra,24(sp)
    800031b2:	6442                	ld	s0,16(sp)
    800031b4:	64a2                	ld	s1,8(sp)
    800031b6:	6105                	add	sp,sp,32
    800031b8:	8082                	ret

00000000800031ba <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    800031ba:	1101                	add	sp,sp,-32
    800031bc:	ec06                	sd	ra,24(sp)
    800031be:	e822                	sd	s0,16(sp)
    800031c0:	e426                	sd	s1,8(sp)
    800031c2:	e04a                	sd	s2,0(sp)
    800031c4:	1000                	add	s0,sp,32
    800031c6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031c8:	00d5d59b          	srlw	a1,a1,0xd
    800031cc:	0001c797          	auipc	a5,0x1c
    800031d0:	d887a783          	lw	a5,-632(a5) # 8001ef54 <sb+0x1c>
    800031d4:	9dbd                	addw	a1,a1,a5
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	da0080e7          	jalr	-608(ra) # 80002f76 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031de:	0074f713          	and	a4,s1,7
    800031e2:	4785                	li	a5,1
    800031e4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031e8:	14ce                	sll	s1,s1,0x33
    800031ea:	90d9                	srl	s1,s1,0x36
    800031ec:	00950733          	add	a4,a0,s1
    800031f0:	05874703          	lbu	a4,88(a4)
    800031f4:	00e7f6b3          	and	a3,a5,a4
    800031f8:	c69d                	beqz	a3,80003226 <bfree+0x6c>
    800031fa:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800031fc:	94aa                	add	s1,s1,a0
    800031fe:	fff7c793          	not	a5,a5
    80003202:	8f7d                	and	a4,a4,a5
    80003204:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003208:	00001097          	auipc	ra,0x1
    8000320c:	0f6080e7          	jalr	246(ra) # 800042fe <log_write>
  brelse(bp);
    80003210:	854a                	mv	a0,s2
    80003212:	00000097          	auipc	ra,0x0
    80003216:	e94080e7          	jalr	-364(ra) # 800030a6 <brelse>
}
    8000321a:	60e2                	ld	ra,24(sp)
    8000321c:	6442                	ld	s0,16(sp)
    8000321e:	64a2                	ld	s1,8(sp)
    80003220:	6902                	ld	s2,0(sp)
    80003222:	6105                	add	sp,sp,32
    80003224:	8082                	ret
    panic("freeing free block");
    80003226:	00005517          	auipc	a0,0x5
    8000322a:	35250513          	add	a0,a0,850 # 80008578 <syscalls+0xe8>
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	5e0080e7          	jalr	1504(ra) # 8000080e <panic>

0000000080003236 <balloc>:
{
    80003236:	711d                	add	sp,sp,-96
    80003238:	ec86                	sd	ra,88(sp)
    8000323a:	e8a2                	sd	s0,80(sp)
    8000323c:	e4a6                	sd	s1,72(sp)
    8000323e:	e0ca                	sd	s2,64(sp)
    80003240:	fc4e                	sd	s3,56(sp)
    80003242:	f852                	sd	s4,48(sp)
    80003244:	f456                	sd	s5,40(sp)
    80003246:	f05a                	sd	s6,32(sp)
    80003248:	ec5e                	sd	s7,24(sp)
    8000324a:	e862                	sd	s8,16(sp)
    8000324c:	e466                	sd	s9,8(sp)
    8000324e:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003250:	0001c797          	auipc	a5,0x1c
    80003254:	cec7a783          	lw	a5,-788(a5) # 8001ef3c <sb+0x4>
    80003258:	cff5                	beqz	a5,80003354 <balloc+0x11e>
    8000325a:	8baa                	mv	s7,a0
    8000325c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000325e:	0001cb17          	auipc	s6,0x1c
    80003262:	cdab0b13          	add	s6,s6,-806 # 8001ef38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003266:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003268:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000326a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000326c:	6c89                	lui	s9,0x2
    8000326e:	a061                	j	800032f6 <balloc+0xc0>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    80003270:	97ca                	add	a5,a5,s2
    80003272:	8e55                	or	a2,a2,a3
    80003274:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003278:	854a                	mv	a0,s2
    8000327a:	00001097          	auipc	ra,0x1
    8000327e:	084080e7          	jalr	132(ra) # 800042fe <log_write>
        brelse(bp);
    80003282:	854a                	mv	a0,s2
    80003284:	00000097          	auipc	ra,0x0
    80003288:	e22080e7          	jalr	-478(ra) # 800030a6 <brelse>
  bp = bread(dev, bno);
    8000328c:	85a6                	mv	a1,s1
    8000328e:	855e                	mv	a0,s7
    80003290:	00000097          	auipc	ra,0x0
    80003294:	ce6080e7          	jalr	-794(ra) # 80002f76 <bread>
    80003298:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000329a:	40000613          	li	a2,1024
    8000329e:	4581                	li	a1,0
    800032a0:	05850513          	add	a0,a0,88
    800032a4:	ffffe097          	auipc	ra,0xffffe
    800032a8:	b24080e7          	jalr	-1244(ra) # 80000dc8 <memset>
  log_write(bp);
    800032ac:	854a                	mv	a0,s2
    800032ae:	00001097          	auipc	ra,0x1
    800032b2:	050080e7          	jalr	80(ra) # 800042fe <log_write>
  brelse(bp);
    800032b6:	854a                	mv	a0,s2
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	dee080e7          	jalr	-530(ra) # 800030a6 <brelse>
}
    800032c0:	8526                	mv	a0,s1
    800032c2:	60e6                	ld	ra,88(sp)
    800032c4:	6446                	ld	s0,80(sp)
    800032c6:	64a6                	ld	s1,72(sp)
    800032c8:	6906                	ld	s2,64(sp)
    800032ca:	79e2                	ld	s3,56(sp)
    800032cc:	7a42                	ld	s4,48(sp)
    800032ce:	7aa2                	ld	s5,40(sp)
    800032d0:	7b02                	ld	s6,32(sp)
    800032d2:	6be2                	ld	s7,24(sp)
    800032d4:	6c42                	ld	s8,16(sp)
    800032d6:	6ca2                	ld	s9,8(sp)
    800032d8:	6125                	add	sp,sp,96
    800032da:	8082                	ret
    brelse(bp);
    800032dc:	854a                	mv	a0,s2
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	dc8080e7          	jalr	-568(ra) # 800030a6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800032e6:	015c87bb          	addw	a5,s9,s5
    800032ea:	00078a9b          	sext.w	s5,a5
    800032ee:	004b2703          	lw	a4,4(s6)
    800032f2:	06eaf163          	bgeu	s5,a4,80003354 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800032f6:	41fad79b          	sraw	a5,s5,0x1f
    800032fa:	0137d79b          	srlw	a5,a5,0x13
    800032fe:	015787bb          	addw	a5,a5,s5
    80003302:	40d7d79b          	sraw	a5,a5,0xd
    80003306:	01cb2583          	lw	a1,28(s6)
    8000330a:	9dbd                	addw	a1,a1,a5
    8000330c:	855e                	mv	a0,s7
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	c68080e7          	jalr	-920(ra) # 80002f76 <bread>
    80003316:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003318:	004b2503          	lw	a0,4(s6)
    8000331c:	000a849b          	sext.w	s1,s5
    80003320:	8762                	mv	a4,s8
    80003322:	faa4fde3          	bgeu	s1,a0,800032dc <balloc+0xa6>
      m = 1 << (bi % 8);
    80003326:	00777693          	and	a3,a4,7
    8000332a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    8000332e:	41f7579b          	sraw	a5,a4,0x1f
    80003332:	01d7d79b          	srlw	a5,a5,0x1d
    80003336:	9fb9                	addw	a5,a5,a4
    80003338:	4037d79b          	sraw	a5,a5,0x3
    8000333c:	00f90633          	add	a2,s2,a5
    80003340:	05864603          	lbu	a2,88(a2)
    80003344:	00c6f5b3          	and	a1,a3,a2
    80003348:	d585                	beqz	a1,80003270 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000334a:	2705                	addw	a4,a4,1
    8000334c:	2485                	addw	s1,s1,1
    8000334e:	fd471ae3          	bne	a4,s4,80003322 <balloc+0xec>
    80003352:	b769                	j	800032dc <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003354:	00005517          	auipc	a0,0x5
    80003358:	23c50513          	add	a0,a0,572 # 80008590 <syscalls+0x100>
    8000335c:	ffffd097          	auipc	ra,0xffffd
    80003360:	1a6080e7          	jalr	422(ra) # 80000502 <printf>
  return 0;
    80003364:	4481                	li	s1,0
    80003366:	bfa9                	j	800032c0 <balloc+0x8a>

0000000080003368 <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    80003368:	7179                	add	sp,sp,-48
    8000336a:	f406                	sd	ra,40(sp)
    8000336c:	f022                	sd	s0,32(sp)
    8000336e:	ec26                	sd	s1,24(sp)
    80003370:	e84a                	sd	s2,16(sp)
    80003372:	e44e                	sd	s3,8(sp)
    80003374:	e052                	sd	s4,0(sp)
    80003376:	1800                	add	s0,sp,48
    80003378:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000337a:	47ad                	li	a5,11
    8000337c:	02b7e863          	bltu	a5,a1,800033ac <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80003380:	02059793          	sll	a5,a1,0x20
    80003384:	01e7d593          	srl	a1,a5,0x1e
    80003388:	00b504b3          	add	s1,a0,a1
    8000338c:	0504a903          	lw	s2,80(s1)
    80003390:	06091e63          	bnez	s2,8000340c <bmap+0xa4>
      addr = balloc(ip->dev);
    80003394:	4108                	lw	a0,0(a0)
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	ea0080e7          	jalr	-352(ra) # 80003236 <balloc>
    8000339e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033a2:	06090563          	beqz	s2,8000340c <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800033a6:	0524a823          	sw	s2,80(s1)
    800033aa:	a08d                	j	8000340c <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800033ac:	ff45849b          	addw	s1,a1,-12
    800033b0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033b4:	0ff00793          	li	a5,255
    800033b8:	08e7e563          	bltu	a5,a4,80003442 <bmap+0xda>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033bc:	08052903          	lw	s2,128(a0)
    800033c0:	00091d63          	bnez	s2,800033da <bmap+0x72>
      addr = balloc(ip->dev);
    800033c4:	4108                	lw	a0,0(a0)
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	e70080e7          	jalr	-400(ra) # 80003236 <balloc>
    800033ce:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033d2:	02090d63          	beqz	s2,8000340c <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800033d6:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800033da:	85ca                	mv	a1,s2
    800033dc:	0009a503          	lw	a0,0(s3)
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	b96080e7          	jalr	-1130(ra) # 80002f76 <bread>
    800033e8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800033ea:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800033ee:	02049713          	sll	a4,s1,0x20
    800033f2:	01e75593          	srl	a1,a4,0x1e
    800033f6:	00b784b3          	add	s1,a5,a1
    800033fa:	0004a903          	lw	s2,0(s1)
    800033fe:	02090063          	beqz	s2,8000341e <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003402:	8552                	mv	a0,s4
    80003404:	00000097          	auipc	ra,0x0
    80003408:	ca2080e7          	jalr	-862(ra) # 800030a6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000340c:	854a                	mv	a0,s2
    8000340e:	70a2                	ld	ra,40(sp)
    80003410:	7402                	ld	s0,32(sp)
    80003412:	64e2                	ld	s1,24(sp)
    80003414:	6942                	ld	s2,16(sp)
    80003416:	69a2                	ld	s3,8(sp)
    80003418:	6a02                	ld	s4,0(sp)
    8000341a:	6145                	add	sp,sp,48
    8000341c:	8082                	ret
      addr = balloc(ip->dev);
    8000341e:	0009a503          	lw	a0,0(s3)
    80003422:	00000097          	auipc	ra,0x0
    80003426:	e14080e7          	jalr	-492(ra) # 80003236 <balloc>
    8000342a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000342e:	fc090ae3          	beqz	s2,80003402 <bmap+0x9a>
        a[bn] = addr;
    80003432:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003436:	8552                	mv	a0,s4
    80003438:	00001097          	auipc	ra,0x1
    8000343c:	ec6080e7          	jalr	-314(ra) # 800042fe <log_write>
    80003440:	b7c9                	j	80003402 <bmap+0x9a>
  panic("bmap: out of range");
    80003442:	00005517          	auipc	a0,0x5
    80003446:	16650513          	add	a0,a0,358 # 800085a8 <syscalls+0x118>
    8000344a:	ffffd097          	auipc	ra,0xffffd
    8000344e:	3c4080e7          	jalr	964(ra) # 8000080e <panic>

0000000080003452 <iget>:
{
    80003452:	7179                	add	sp,sp,-48
    80003454:	f406                	sd	ra,40(sp)
    80003456:	f022                	sd	s0,32(sp)
    80003458:	ec26                	sd	s1,24(sp)
    8000345a:	e84a                	sd	s2,16(sp)
    8000345c:	e44e                	sd	s3,8(sp)
    8000345e:	e052                	sd	s4,0(sp)
    80003460:	1800                	add	s0,sp,48
    80003462:	89aa                	mv	s3,a0
    80003464:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003466:	0001c517          	auipc	a0,0x1c
    8000346a:	af250513          	add	a0,a0,-1294 # 8001ef58 <itable>
    8000346e:	ffffe097          	auipc	ra,0xffffe
    80003472:	85e080e7          	jalr	-1954(ra) # 80000ccc <acquire>
  empty = 0;
    80003476:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003478:	0001c497          	auipc	s1,0x1c
    8000347c:	af848493          	add	s1,s1,-1288 # 8001ef70 <itable+0x18>
    80003480:	0001d697          	auipc	a3,0x1d
    80003484:	58068693          	add	a3,a3,1408 # 80020a00 <log>
    80003488:	a039                	j	80003496 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    8000348a:	02090b63          	beqz	s2,800034c0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000348e:	08848493          	add	s1,s1,136
    80003492:	02d48a63          	beq	s1,a3,800034c6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003496:	449c                	lw	a5,8(s1)
    80003498:	fef059e3          	blez	a5,8000348a <iget+0x38>
    8000349c:	4098                	lw	a4,0(s1)
    8000349e:	ff3716e3          	bne	a4,s3,8000348a <iget+0x38>
    800034a2:	40d8                	lw	a4,4(s1)
    800034a4:	ff4713e3          	bne	a4,s4,8000348a <iget+0x38>
      ip->ref++;
    800034a8:	2785                	addw	a5,a5,1
    800034aa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034ac:	0001c517          	auipc	a0,0x1c
    800034b0:	aac50513          	add	a0,a0,-1364 # 8001ef58 <itable>
    800034b4:	ffffe097          	auipc	ra,0xffffe
    800034b8:	8cc080e7          	jalr	-1844(ra) # 80000d80 <release>
      return ip;
    800034bc:	8926                	mv	s2,s1
    800034be:	a03d                	j	800034ec <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    800034c0:	f7f9                	bnez	a5,8000348e <iget+0x3c>
    800034c2:	8926                	mv	s2,s1
    800034c4:	b7e9                	j	8000348e <iget+0x3c>
  if(empty == 0)
    800034c6:	02090c63          	beqz	s2,800034fe <iget+0xac>
  ip->dev = dev;
    800034ca:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034ce:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034d2:	4785                	li	a5,1
    800034d4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034d8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034dc:	0001c517          	auipc	a0,0x1c
    800034e0:	a7c50513          	add	a0,a0,-1412 # 8001ef58 <itable>
    800034e4:	ffffe097          	auipc	ra,0xffffe
    800034e8:	89c080e7          	jalr	-1892(ra) # 80000d80 <release>
}
    800034ec:	854a                	mv	a0,s2
    800034ee:	70a2                	ld	ra,40(sp)
    800034f0:	7402                	ld	s0,32(sp)
    800034f2:	64e2                	ld	s1,24(sp)
    800034f4:	6942                	ld	s2,16(sp)
    800034f6:	69a2                	ld	s3,8(sp)
    800034f8:	6a02                	ld	s4,0(sp)
    800034fa:	6145                	add	sp,sp,48
    800034fc:	8082                	ret
    panic("iget: no inodes");
    800034fe:	00005517          	auipc	a0,0x5
    80003502:	0c250513          	add	a0,a0,194 # 800085c0 <syscalls+0x130>
    80003506:	ffffd097          	auipc	ra,0xffffd
    8000350a:	308080e7          	jalr	776(ra) # 8000080e <panic>

000000008000350e <fsinit>:
fsinit(int dev) {
    8000350e:	7179                	add	sp,sp,-48
    80003510:	f406                	sd	ra,40(sp)
    80003512:	f022                	sd	s0,32(sp)
    80003514:	ec26                	sd	s1,24(sp)
    80003516:	e84a                	sd	s2,16(sp)
    80003518:	e44e                	sd	s3,8(sp)
    8000351a:	1800                	add	s0,sp,48
    8000351c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000351e:	4585                	li	a1,1
    80003520:	00000097          	auipc	ra,0x0
    80003524:	a56080e7          	jalr	-1450(ra) # 80002f76 <bread>
    80003528:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000352a:	0001c997          	auipc	s3,0x1c
    8000352e:	a0e98993          	add	s3,s3,-1522 # 8001ef38 <sb>
    80003532:	02000613          	li	a2,32
    80003536:	05850593          	add	a1,a0,88
    8000353a:	854e                	mv	a0,s3
    8000353c:	ffffe097          	auipc	ra,0xffffe
    80003540:	8e8080e7          	jalr	-1816(ra) # 80000e24 <memmove>
  brelse(bp);
    80003544:	8526                	mv	a0,s1
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	b60080e7          	jalr	-1184(ra) # 800030a6 <brelse>
  if(sb.magic != FSMAGIC)
    8000354e:	0009a703          	lw	a4,0(s3)
    80003552:	102037b7          	lui	a5,0x10203
    80003556:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000355a:	02f71263          	bne	a4,a5,8000357e <fsinit+0x70>
  initlog(dev, &sb);
    8000355e:	0001c597          	auipc	a1,0x1c
    80003562:	9da58593          	add	a1,a1,-1574 # 8001ef38 <sb>
    80003566:	854a                	mv	a0,s2
    80003568:	00001097          	auipc	ra,0x1
    8000356c:	b2c080e7          	jalr	-1236(ra) # 80004094 <initlog>
}
    80003570:	70a2                	ld	ra,40(sp)
    80003572:	7402                	ld	s0,32(sp)
    80003574:	64e2                	ld	s1,24(sp)
    80003576:	6942                	ld	s2,16(sp)
    80003578:	69a2                	ld	s3,8(sp)
    8000357a:	6145                	add	sp,sp,48
    8000357c:	8082                	ret
    panic("invalid file system");
    8000357e:	00005517          	auipc	a0,0x5
    80003582:	05250513          	add	a0,a0,82 # 800085d0 <syscalls+0x140>
    80003586:	ffffd097          	auipc	ra,0xffffd
    8000358a:	288080e7          	jalr	648(ra) # 8000080e <panic>

000000008000358e <iinit>:
{
    8000358e:	7179                	add	sp,sp,-48
    80003590:	f406                	sd	ra,40(sp)
    80003592:	f022                	sd	s0,32(sp)
    80003594:	ec26                	sd	s1,24(sp)
    80003596:	e84a                	sd	s2,16(sp)
    80003598:	e44e                	sd	s3,8(sp)
    8000359a:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    8000359c:	00005597          	auipc	a1,0x5
    800035a0:	04c58593          	add	a1,a1,76 # 800085e8 <syscalls+0x158>
    800035a4:	0001c517          	auipc	a0,0x1c
    800035a8:	9b450513          	add	a0,a0,-1612 # 8001ef58 <itable>
    800035ac:	ffffd097          	auipc	ra,0xffffd
    800035b0:	690080e7          	jalr	1680(ra) # 80000c3c <initlock>
  for(i = 0; i < NINODE; i++) {
    800035b4:	0001c497          	auipc	s1,0x1c
    800035b8:	9cc48493          	add	s1,s1,-1588 # 8001ef80 <itable+0x28>
    800035bc:	0001d997          	auipc	s3,0x1d
    800035c0:	45498993          	add	s3,s3,1108 # 80020a10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035c4:	00005917          	auipc	s2,0x5
    800035c8:	02c90913          	add	s2,s2,44 # 800085f0 <syscalls+0x160>
    800035cc:	85ca                	mv	a1,s2
    800035ce:	8526                	mv	a0,s1
    800035d0:	00001097          	auipc	ra,0x1
    800035d4:	e12080e7          	jalr	-494(ra) # 800043e2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800035d8:	08848493          	add	s1,s1,136
    800035dc:	ff3498e3          	bne	s1,s3,800035cc <iinit+0x3e>
}
    800035e0:	70a2                	ld	ra,40(sp)
    800035e2:	7402                	ld	s0,32(sp)
    800035e4:	64e2                	ld	s1,24(sp)
    800035e6:	6942                	ld	s2,16(sp)
    800035e8:	69a2                	ld	s3,8(sp)
    800035ea:	6145                	add	sp,sp,48
    800035ec:	8082                	ret

00000000800035ee <ialloc>:
{
    800035ee:	7139                	add	sp,sp,-64
    800035f0:	fc06                	sd	ra,56(sp)
    800035f2:	f822                	sd	s0,48(sp)
    800035f4:	f426                	sd	s1,40(sp)
    800035f6:	f04a                	sd	s2,32(sp)
    800035f8:	ec4e                	sd	s3,24(sp)
    800035fa:	e852                	sd	s4,16(sp)
    800035fc:	e456                	sd	s5,8(sp)
    800035fe:	e05a                	sd	s6,0(sp)
    80003600:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003602:	0001c717          	auipc	a4,0x1c
    80003606:	94272703          	lw	a4,-1726(a4) # 8001ef44 <sb+0xc>
    8000360a:	4785                	li	a5,1
    8000360c:	04e7f863          	bgeu	a5,a4,8000365c <ialloc+0x6e>
    80003610:	8aaa                	mv	s5,a0
    80003612:	8b2e                	mv	s6,a1
    80003614:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003616:	0001ca17          	auipc	s4,0x1c
    8000361a:	922a0a13          	add	s4,s4,-1758 # 8001ef38 <sb>
    8000361e:	00495593          	srl	a1,s2,0x4
    80003622:	018a2783          	lw	a5,24(s4)
    80003626:	9dbd                	addw	a1,a1,a5
    80003628:	8556                	mv	a0,s5
    8000362a:	00000097          	auipc	ra,0x0
    8000362e:	94c080e7          	jalr	-1716(ra) # 80002f76 <bread>
    80003632:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003634:	05850993          	add	s3,a0,88
    80003638:	00f97793          	and	a5,s2,15
    8000363c:	079a                	sll	a5,a5,0x6
    8000363e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    80003640:	00099783          	lh	a5,0(s3)
    80003644:	cf9d                	beqz	a5,80003682 <ialloc+0x94>
    brelse(bp);
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	a60080e7          	jalr	-1440(ra) # 800030a6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000364e:	0905                	add	s2,s2,1
    80003650:	00ca2703          	lw	a4,12(s4)
    80003654:	0009079b          	sext.w	a5,s2
    80003658:	fce7e3e3          	bltu	a5,a4,8000361e <ialloc+0x30>
  printf("ialloc: no inodes\n");
    8000365c:	00005517          	auipc	a0,0x5
    80003660:	f9c50513          	add	a0,a0,-100 # 800085f8 <syscalls+0x168>
    80003664:	ffffd097          	auipc	ra,0xffffd
    80003668:	e9e080e7          	jalr	-354(ra) # 80000502 <printf>
  return 0;
    8000366c:	4501                	li	a0,0
}
    8000366e:	70e2                	ld	ra,56(sp)
    80003670:	7442                	ld	s0,48(sp)
    80003672:	74a2                	ld	s1,40(sp)
    80003674:	7902                	ld	s2,32(sp)
    80003676:	69e2                	ld	s3,24(sp)
    80003678:	6a42                	ld	s4,16(sp)
    8000367a:	6aa2                	ld	s5,8(sp)
    8000367c:	6b02                	ld	s6,0(sp)
    8000367e:	6121                	add	sp,sp,64
    80003680:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003682:	04000613          	li	a2,64
    80003686:	4581                	li	a1,0
    80003688:	854e                	mv	a0,s3
    8000368a:	ffffd097          	auipc	ra,0xffffd
    8000368e:	73e080e7          	jalr	1854(ra) # 80000dc8 <memset>
      dip->type = type;
    80003692:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80003696:	8526                	mv	a0,s1
    80003698:	00001097          	auipc	ra,0x1
    8000369c:	c66080e7          	jalr	-922(ra) # 800042fe <log_write>
      brelse(bp);
    800036a0:	8526                	mv	a0,s1
    800036a2:	00000097          	auipc	ra,0x0
    800036a6:	a04080e7          	jalr	-1532(ra) # 800030a6 <brelse>
      return iget(dev, inum);
    800036aa:	0009059b          	sext.w	a1,s2
    800036ae:	8556                	mv	a0,s5
    800036b0:	00000097          	auipc	ra,0x0
    800036b4:	da2080e7          	jalr	-606(ra) # 80003452 <iget>
    800036b8:	bf5d                	j	8000366e <ialloc+0x80>

00000000800036ba <iupdate>:
{
    800036ba:	1101                	add	sp,sp,-32
    800036bc:	ec06                	sd	ra,24(sp)
    800036be:	e822                	sd	s0,16(sp)
    800036c0:	e426                	sd	s1,8(sp)
    800036c2:	e04a                	sd	s2,0(sp)
    800036c4:	1000                	add	s0,sp,32
    800036c6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036c8:	415c                	lw	a5,4(a0)
    800036ca:	0047d79b          	srlw	a5,a5,0x4
    800036ce:	0001c597          	auipc	a1,0x1c
    800036d2:	8825a583          	lw	a1,-1918(a1) # 8001ef50 <sb+0x18>
    800036d6:	9dbd                	addw	a1,a1,a5
    800036d8:	4108                	lw	a0,0(a0)
    800036da:	00000097          	auipc	ra,0x0
    800036de:	89c080e7          	jalr	-1892(ra) # 80002f76 <bread>
    800036e2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036e4:	05850793          	add	a5,a0,88
    800036e8:	40d8                	lw	a4,4(s1)
    800036ea:	8b3d                	and	a4,a4,15
    800036ec:	071a                	sll	a4,a4,0x6
    800036ee:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800036f0:	04449703          	lh	a4,68(s1)
    800036f4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800036f8:	04649703          	lh	a4,70(s1)
    800036fc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003700:	04849703          	lh	a4,72(s1)
    80003704:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003708:	04a49703          	lh	a4,74(s1)
    8000370c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003710:	44f8                	lw	a4,76(s1)
    80003712:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003714:	03400613          	li	a2,52
    80003718:	05048593          	add	a1,s1,80
    8000371c:	00c78513          	add	a0,a5,12
    80003720:	ffffd097          	auipc	ra,0xffffd
    80003724:	704080e7          	jalr	1796(ra) # 80000e24 <memmove>
  log_write(bp);
    80003728:	854a                	mv	a0,s2
    8000372a:	00001097          	auipc	ra,0x1
    8000372e:	bd4080e7          	jalr	-1068(ra) # 800042fe <log_write>
  brelse(bp);
    80003732:	854a                	mv	a0,s2
    80003734:	00000097          	auipc	ra,0x0
    80003738:	972080e7          	jalr	-1678(ra) # 800030a6 <brelse>
}
    8000373c:	60e2                	ld	ra,24(sp)
    8000373e:	6442                	ld	s0,16(sp)
    80003740:	64a2                	ld	s1,8(sp)
    80003742:	6902                	ld	s2,0(sp)
    80003744:	6105                	add	sp,sp,32
    80003746:	8082                	ret

0000000080003748 <idup>:
{
    80003748:	1101                	add	sp,sp,-32
    8000374a:	ec06                	sd	ra,24(sp)
    8000374c:	e822                	sd	s0,16(sp)
    8000374e:	e426                	sd	s1,8(sp)
    80003750:	1000                	add	s0,sp,32
    80003752:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003754:	0001c517          	auipc	a0,0x1c
    80003758:	80450513          	add	a0,a0,-2044 # 8001ef58 <itable>
    8000375c:	ffffd097          	auipc	ra,0xffffd
    80003760:	570080e7          	jalr	1392(ra) # 80000ccc <acquire>
  ip->ref++;
    80003764:	449c                	lw	a5,8(s1)
    80003766:	2785                	addw	a5,a5,1
    80003768:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000376a:	0001b517          	auipc	a0,0x1b
    8000376e:	7ee50513          	add	a0,a0,2030 # 8001ef58 <itable>
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	60e080e7          	jalr	1550(ra) # 80000d80 <release>
}
    8000377a:	8526                	mv	a0,s1
    8000377c:	60e2                	ld	ra,24(sp)
    8000377e:	6442                	ld	s0,16(sp)
    80003780:	64a2                	ld	s1,8(sp)
    80003782:	6105                	add	sp,sp,32
    80003784:	8082                	ret

0000000080003786 <ilock>:
{
    80003786:	1101                	add	sp,sp,-32
    80003788:	ec06                	sd	ra,24(sp)
    8000378a:	e822                	sd	s0,16(sp)
    8000378c:	e426                	sd	s1,8(sp)
    8000378e:	e04a                	sd	s2,0(sp)
    80003790:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003792:	c115                	beqz	a0,800037b6 <ilock+0x30>
    80003794:	84aa                	mv	s1,a0
    80003796:	451c                	lw	a5,8(a0)
    80003798:	00f05f63          	blez	a5,800037b6 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000379c:	0541                	add	a0,a0,16
    8000379e:	00001097          	auipc	ra,0x1
    800037a2:	c7e080e7          	jalr	-898(ra) # 8000441c <acquiresleep>
  if(ip->valid == 0){
    800037a6:	40bc                	lw	a5,64(s1)
    800037a8:	cf99                	beqz	a5,800037c6 <ilock+0x40>
}
    800037aa:	60e2                	ld	ra,24(sp)
    800037ac:	6442                	ld	s0,16(sp)
    800037ae:	64a2                	ld	s1,8(sp)
    800037b0:	6902                	ld	s2,0(sp)
    800037b2:	6105                	add	sp,sp,32
    800037b4:	8082                	ret
    panic("ilock");
    800037b6:	00005517          	auipc	a0,0x5
    800037ba:	e5a50513          	add	a0,a0,-422 # 80008610 <syscalls+0x180>
    800037be:	ffffd097          	auipc	ra,0xffffd
    800037c2:	050080e7          	jalr	80(ra) # 8000080e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037c6:	40dc                	lw	a5,4(s1)
    800037c8:	0047d79b          	srlw	a5,a5,0x4
    800037cc:	0001b597          	auipc	a1,0x1b
    800037d0:	7845a583          	lw	a1,1924(a1) # 8001ef50 <sb+0x18>
    800037d4:	9dbd                	addw	a1,a1,a5
    800037d6:	4088                	lw	a0,0(s1)
    800037d8:	fffff097          	auipc	ra,0xfffff
    800037dc:	79e080e7          	jalr	1950(ra) # 80002f76 <bread>
    800037e0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037e2:	05850593          	add	a1,a0,88
    800037e6:	40dc                	lw	a5,4(s1)
    800037e8:	8bbd                	and	a5,a5,15
    800037ea:	079a                	sll	a5,a5,0x6
    800037ec:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037ee:	00059783          	lh	a5,0(a1)
    800037f2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037f6:	00259783          	lh	a5,2(a1)
    800037fa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037fe:	00459783          	lh	a5,4(a1)
    80003802:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003806:	00659783          	lh	a5,6(a1)
    8000380a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000380e:	459c                	lw	a5,8(a1)
    80003810:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003812:	03400613          	li	a2,52
    80003816:	05b1                	add	a1,a1,12
    80003818:	05048513          	add	a0,s1,80
    8000381c:	ffffd097          	auipc	ra,0xffffd
    80003820:	608080e7          	jalr	1544(ra) # 80000e24 <memmove>
    brelse(bp);
    80003824:	854a                	mv	a0,s2
    80003826:	00000097          	auipc	ra,0x0
    8000382a:	880080e7          	jalr	-1920(ra) # 800030a6 <brelse>
    ip->valid = 1;
    8000382e:	4785                	li	a5,1
    80003830:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003832:	04449783          	lh	a5,68(s1)
    80003836:	fbb5                	bnez	a5,800037aa <ilock+0x24>
      panic("ilock: no type");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	de050513          	add	a0,a0,-544 # 80008618 <syscalls+0x188>
    80003840:	ffffd097          	auipc	ra,0xffffd
    80003844:	fce080e7          	jalr	-50(ra) # 8000080e <panic>

0000000080003848 <iunlock>:
{
    80003848:	1101                	add	sp,sp,-32
    8000384a:	ec06                	sd	ra,24(sp)
    8000384c:	e822                	sd	s0,16(sp)
    8000384e:	e426                	sd	s1,8(sp)
    80003850:	e04a                	sd	s2,0(sp)
    80003852:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003854:	c905                	beqz	a0,80003884 <iunlock+0x3c>
    80003856:	84aa                	mv	s1,a0
    80003858:	01050913          	add	s2,a0,16
    8000385c:	854a                	mv	a0,s2
    8000385e:	00001097          	auipc	ra,0x1
    80003862:	c58080e7          	jalr	-936(ra) # 800044b6 <holdingsleep>
    80003866:	cd19                	beqz	a0,80003884 <iunlock+0x3c>
    80003868:	449c                	lw	a5,8(s1)
    8000386a:	00f05d63          	blez	a5,80003884 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000386e:	854a                	mv	a0,s2
    80003870:	00001097          	auipc	ra,0x1
    80003874:	c02080e7          	jalr	-1022(ra) # 80004472 <releasesleep>
}
    80003878:	60e2                	ld	ra,24(sp)
    8000387a:	6442                	ld	s0,16(sp)
    8000387c:	64a2                	ld	s1,8(sp)
    8000387e:	6902                	ld	s2,0(sp)
    80003880:	6105                	add	sp,sp,32
    80003882:	8082                	ret
    panic("iunlock");
    80003884:	00005517          	auipc	a0,0x5
    80003888:	da450513          	add	a0,a0,-604 # 80008628 <syscalls+0x198>
    8000388c:	ffffd097          	auipc	ra,0xffffd
    80003890:	f82080e7          	jalr	-126(ra) # 8000080e <panic>

0000000080003894 <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    80003894:	7179                	add	sp,sp,-48
    80003896:	f406                	sd	ra,40(sp)
    80003898:	f022                	sd	s0,32(sp)
    8000389a:	ec26                	sd	s1,24(sp)
    8000389c:	e84a                	sd	s2,16(sp)
    8000389e:	e44e                	sd	s3,8(sp)
    800038a0:	e052                	sd	s4,0(sp)
    800038a2:	1800                	add	s0,sp,48
    800038a4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038a6:	05050493          	add	s1,a0,80
    800038aa:	08050913          	add	s2,a0,128
    800038ae:	a021                	j	800038b6 <itrunc+0x22>
    800038b0:	0491                	add	s1,s1,4
    800038b2:	01248d63          	beq	s1,s2,800038cc <itrunc+0x38>
    if(ip->addrs[i]){
    800038b6:	408c                	lw	a1,0(s1)
    800038b8:	dde5                	beqz	a1,800038b0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800038ba:	0009a503          	lw	a0,0(s3)
    800038be:	00000097          	auipc	ra,0x0
    800038c2:	8fc080e7          	jalr	-1796(ra) # 800031ba <bfree>
      ip->addrs[i] = 0;
    800038c6:	0004a023          	sw	zero,0(s1)
    800038ca:	b7dd                	j	800038b0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038cc:	0809a583          	lw	a1,128(s3)
    800038d0:	e185                	bnez	a1,800038f0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800038d2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038d6:	854e                	mv	a0,s3
    800038d8:	00000097          	auipc	ra,0x0
    800038dc:	de2080e7          	jalr	-542(ra) # 800036ba <iupdate>
}
    800038e0:	70a2                	ld	ra,40(sp)
    800038e2:	7402                	ld	s0,32(sp)
    800038e4:	64e2                	ld	s1,24(sp)
    800038e6:	6942                	ld	s2,16(sp)
    800038e8:	69a2                	ld	s3,8(sp)
    800038ea:	6a02                	ld	s4,0(sp)
    800038ec:	6145                	add	sp,sp,48
    800038ee:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038f0:	0009a503          	lw	a0,0(s3)
    800038f4:	fffff097          	auipc	ra,0xfffff
    800038f8:	682080e7          	jalr	1666(ra) # 80002f76 <bread>
    800038fc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800038fe:	05850493          	add	s1,a0,88
    80003902:	45850913          	add	s2,a0,1112
    80003906:	a021                	j	8000390e <itrunc+0x7a>
    80003908:	0491                	add	s1,s1,4
    8000390a:	01248b63          	beq	s1,s2,80003920 <itrunc+0x8c>
      if(a[j])
    8000390e:	408c                	lw	a1,0(s1)
    80003910:	dde5                	beqz	a1,80003908 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003912:	0009a503          	lw	a0,0(s3)
    80003916:	00000097          	auipc	ra,0x0
    8000391a:	8a4080e7          	jalr	-1884(ra) # 800031ba <bfree>
    8000391e:	b7ed                	j	80003908 <itrunc+0x74>
    brelse(bp);
    80003920:	8552                	mv	a0,s4
    80003922:	fffff097          	auipc	ra,0xfffff
    80003926:	784080e7          	jalr	1924(ra) # 800030a6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000392a:	0809a583          	lw	a1,128(s3)
    8000392e:	0009a503          	lw	a0,0(s3)
    80003932:	00000097          	auipc	ra,0x0
    80003936:	888080e7          	jalr	-1912(ra) # 800031ba <bfree>
    ip->addrs[NDIRECT] = 0;
    8000393a:	0809a023          	sw	zero,128(s3)
    8000393e:	bf51                	j	800038d2 <itrunc+0x3e>

0000000080003940 <iput>:
{
    80003940:	1101                	add	sp,sp,-32
    80003942:	ec06                	sd	ra,24(sp)
    80003944:	e822                	sd	s0,16(sp)
    80003946:	e426                	sd	s1,8(sp)
    80003948:	e04a                	sd	s2,0(sp)
    8000394a:	1000                	add	s0,sp,32
    8000394c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000394e:	0001b517          	auipc	a0,0x1b
    80003952:	60a50513          	add	a0,a0,1546 # 8001ef58 <itable>
    80003956:	ffffd097          	auipc	ra,0xffffd
    8000395a:	376080e7          	jalr	886(ra) # 80000ccc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000395e:	4498                	lw	a4,8(s1)
    80003960:	4785                	li	a5,1
    80003962:	02f70363          	beq	a4,a5,80003988 <iput+0x48>
  ip->ref--;
    80003966:	449c                	lw	a5,8(s1)
    80003968:	37fd                	addw	a5,a5,-1
    8000396a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000396c:	0001b517          	auipc	a0,0x1b
    80003970:	5ec50513          	add	a0,a0,1516 # 8001ef58 <itable>
    80003974:	ffffd097          	auipc	ra,0xffffd
    80003978:	40c080e7          	jalr	1036(ra) # 80000d80 <release>
}
    8000397c:	60e2                	ld	ra,24(sp)
    8000397e:	6442                	ld	s0,16(sp)
    80003980:	64a2                	ld	s1,8(sp)
    80003982:	6902                	ld	s2,0(sp)
    80003984:	6105                	add	sp,sp,32
    80003986:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003988:	40bc                	lw	a5,64(s1)
    8000398a:	dff1                	beqz	a5,80003966 <iput+0x26>
    8000398c:	04a49783          	lh	a5,74(s1)
    80003990:	fbf9                	bnez	a5,80003966 <iput+0x26>
    acquiresleep(&ip->lock);
    80003992:	01048913          	add	s2,s1,16
    80003996:	854a                	mv	a0,s2
    80003998:	00001097          	auipc	ra,0x1
    8000399c:	a84080e7          	jalr	-1404(ra) # 8000441c <acquiresleep>
    release(&itable.lock);
    800039a0:	0001b517          	auipc	a0,0x1b
    800039a4:	5b850513          	add	a0,a0,1464 # 8001ef58 <itable>
    800039a8:	ffffd097          	auipc	ra,0xffffd
    800039ac:	3d8080e7          	jalr	984(ra) # 80000d80 <release>
    itrunc(ip);
    800039b0:	8526                	mv	a0,s1
    800039b2:	00000097          	auipc	ra,0x0
    800039b6:	ee2080e7          	jalr	-286(ra) # 80003894 <itrunc>
    ip->type = 0;
    800039ba:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039be:	8526                	mv	a0,s1
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	cfa080e7          	jalr	-774(ra) # 800036ba <iupdate>
    ip->valid = 0;
    800039c8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800039cc:	854a                	mv	a0,s2
    800039ce:	00001097          	auipc	ra,0x1
    800039d2:	aa4080e7          	jalr	-1372(ra) # 80004472 <releasesleep>
    acquire(&itable.lock);
    800039d6:	0001b517          	auipc	a0,0x1b
    800039da:	58250513          	add	a0,a0,1410 # 8001ef58 <itable>
    800039de:	ffffd097          	auipc	ra,0xffffd
    800039e2:	2ee080e7          	jalr	750(ra) # 80000ccc <acquire>
    800039e6:	b741                	j	80003966 <iput+0x26>

00000000800039e8 <iunlockput>:
{
    800039e8:	1101                	add	sp,sp,-32
    800039ea:	ec06                	sd	ra,24(sp)
    800039ec:	e822                	sd	s0,16(sp)
    800039ee:	e426                	sd	s1,8(sp)
    800039f0:	1000                	add	s0,sp,32
    800039f2:	84aa                	mv	s1,a0
  iunlock(ip);
    800039f4:	00000097          	auipc	ra,0x0
    800039f8:	e54080e7          	jalr	-428(ra) # 80003848 <iunlock>
  iput(ip);
    800039fc:	8526                	mv	a0,s1
    800039fe:	00000097          	auipc	ra,0x0
    80003a02:	f42080e7          	jalr	-190(ra) # 80003940 <iput>
}
    80003a06:	60e2                	ld	ra,24(sp)
    80003a08:	6442                	ld	s0,16(sp)
    80003a0a:	64a2                	ld	s1,8(sp)
    80003a0c:	6105                	add	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80003a10:	1141                	add	sp,sp,-16
    80003a12:	e422                	sd	s0,8(sp)
    80003a14:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003a16:	411c                	lw	a5,0(a0)
    80003a18:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a1a:	415c                	lw	a5,4(a0)
    80003a1c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a1e:	04451783          	lh	a5,68(a0)
    80003a22:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a26:	04a51783          	lh	a5,74(a0)
    80003a2a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a2e:	04c56783          	lwu	a5,76(a0)
    80003a32:	e99c                	sd	a5,16(a1)
}
    80003a34:	6422                	ld	s0,8(sp)
    80003a36:	0141                	add	sp,sp,16
    80003a38:	8082                	ret

0000000080003a3a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a3a:	457c                	lw	a5,76(a0)
    80003a3c:	0ed7e963          	bltu	a5,a3,80003b2e <readi+0xf4>
{
    80003a40:	7159                	add	sp,sp,-112
    80003a42:	f486                	sd	ra,104(sp)
    80003a44:	f0a2                	sd	s0,96(sp)
    80003a46:	eca6                	sd	s1,88(sp)
    80003a48:	e8ca                	sd	s2,80(sp)
    80003a4a:	e4ce                	sd	s3,72(sp)
    80003a4c:	e0d2                	sd	s4,64(sp)
    80003a4e:	fc56                	sd	s5,56(sp)
    80003a50:	f85a                	sd	s6,48(sp)
    80003a52:	f45e                	sd	s7,40(sp)
    80003a54:	f062                	sd	s8,32(sp)
    80003a56:	ec66                	sd	s9,24(sp)
    80003a58:	e86a                	sd	s10,16(sp)
    80003a5a:	e46e                	sd	s11,8(sp)
    80003a5c:	1880                	add	s0,sp,112
    80003a5e:	8b2a                	mv	s6,a0
    80003a60:	8bae                	mv	s7,a1
    80003a62:	8a32                	mv	s4,a2
    80003a64:	84b6                	mv	s1,a3
    80003a66:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a68:	9f35                	addw	a4,a4,a3
    return 0;
    80003a6a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a6c:	0ad76063          	bltu	a4,a3,80003b0c <readi+0xd2>
  if(off + n > ip->size)
    80003a70:	00e7f463          	bgeu	a5,a4,80003a78 <readi+0x3e>
    n = ip->size - off;
    80003a74:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a78:	0a0a8963          	beqz	s5,80003b2a <readi+0xf0>
    80003a7c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a7e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a82:	5c7d                	li	s8,-1
    80003a84:	a82d                	j	80003abe <readi+0x84>
    80003a86:	020d1d93          	sll	s11,s10,0x20
    80003a8a:	020ddd93          	srl	s11,s11,0x20
    80003a8e:	05890613          	add	a2,s2,88
    80003a92:	86ee                	mv	a3,s11
    80003a94:	963a                	add	a2,a2,a4
    80003a96:	85d2                	mv	a1,s4
    80003a98:	855e                	mv	a0,s7
    80003a9a:	fffff097          	auipc	ra,0xfffff
    80003a9e:	b32080e7          	jalr	-1230(ra) # 800025cc <either_copyout>
    80003aa2:	05850d63          	beq	a0,s8,80003afc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003aa6:	854a                	mv	a0,s2
    80003aa8:	fffff097          	auipc	ra,0xfffff
    80003aac:	5fe080e7          	jalr	1534(ra) # 800030a6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ab0:	013d09bb          	addw	s3,s10,s3
    80003ab4:	009d04bb          	addw	s1,s10,s1
    80003ab8:	9a6e                	add	s4,s4,s11
    80003aba:	0559f763          	bgeu	s3,s5,80003b08 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003abe:	00a4d59b          	srlw	a1,s1,0xa
    80003ac2:	855a                	mv	a0,s6
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	8a4080e7          	jalr	-1884(ra) # 80003368 <bmap>
    80003acc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ad0:	cd85                	beqz	a1,80003b08 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003ad2:	000b2503          	lw	a0,0(s6)
    80003ad6:	fffff097          	auipc	ra,0xfffff
    80003ada:	4a0080e7          	jalr	1184(ra) # 80002f76 <bread>
    80003ade:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ae0:	3ff4f713          	and	a4,s1,1023
    80003ae4:	40ec87bb          	subw	a5,s9,a4
    80003ae8:	413a86bb          	subw	a3,s5,s3
    80003aec:	8d3e                	mv	s10,a5
    80003aee:	2781                	sext.w	a5,a5
    80003af0:	0006861b          	sext.w	a2,a3
    80003af4:	f8f679e3          	bgeu	a2,a5,80003a86 <readi+0x4c>
    80003af8:	8d36                	mv	s10,a3
    80003afa:	b771                	j	80003a86 <readi+0x4c>
      brelse(bp);
    80003afc:	854a                	mv	a0,s2
    80003afe:	fffff097          	auipc	ra,0xfffff
    80003b02:	5a8080e7          	jalr	1448(ra) # 800030a6 <brelse>
      tot = -1;
    80003b06:	59fd                	li	s3,-1
  }
  return tot;
    80003b08:	0009851b          	sext.w	a0,s3
}
    80003b0c:	70a6                	ld	ra,104(sp)
    80003b0e:	7406                	ld	s0,96(sp)
    80003b10:	64e6                	ld	s1,88(sp)
    80003b12:	6946                	ld	s2,80(sp)
    80003b14:	69a6                	ld	s3,72(sp)
    80003b16:	6a06                	ld	s4,64(sp)
    80003b18:	7ae2                	ld	s5,56(sp)
    80003b1a:	7b42                	ld	s6,48(sp)
    80003b1c:	7ba2                	ld	s7,40(sp)
    80003b1e:	7c02                	ld	s8,32(sp)
    80003b20:	6ce2                	ld	s9,24(sp)
    80003b22:	6d42                	ld	s10,16(sp)
    80003b24:	6da2                	ld	s11,8(sp)
    80003b26:	6165                	add	sp,sp,112
    80003b28:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b2a:	89d6                	mv	s3,s5
    80003b2c:	bff1                	j	80003b08 <readi+0xce>
    return 0;
    80003b2e:	4501                	li	a0,0
}
    80003b30:	8082                	ret

0000000080003b32 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b32:	457c                	lw	a5,76(a0)
    80003b34:	10d7e863          	bltu	a5,a3,80003c44 <writei+0x112>
{
    80003b38:	7159                	add	sp,sp,-112
    80003b3a:	f486                	sd	ra,104(sp)
    80003b3c:	f0a2                	sd	s0,96(sp)
    80003b3e:	eca6                	sd	s1,88(sp)
    80003b40:	e8ca                	sd	s2,80(sp)
    80003b42:	e4ce                	sd	s3,72(sp)
    80003b44:	e0d2                	sd	s4,64(sp)
    80003b46:	fc56                	sd	s5,56(sp)
    80003b48:	f85a                	sd	s6,48(sp)
    80003b4a:	f45e                	sd	s7,40(sp)
    80003b4c:	f062                	sd	s8,32(sp)
    80003b4e:	ec66                	sd	s9,24(sp)
    80003b50:	e86a                	sd	s10,16(sp)
    80003b52:	e46e                	sd	s11,8(sp)
    80003b54:	1880                	add	s0,sp,112
    80003b56:	8aaa                	mv	s5,a0
    80003b58:	8bae                	mv	s7,a1
    80003b5a:	8a32                	mv	s4,a2
    80003b5c:	8936                	mv	s2,a3
    80003b5e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b60:	00e687bb          	addw	a5,a3,a4
    80003b64:	0ed7e263          	bltu	a5,a3,80003c48 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b68:	00043737          	lui	a4,0x43
    80003b6c:	0ef76063          	bltu	a4,a5,80003c4c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b70:	0c0b0863          	beqz	s6,80003c40 <writei+0x10e>
    80003b74:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b76:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b7a:	5c7d                	li	s8,-1
    80003b7c:	a091                	j	80003bc0 <writei+0x8e>
    80003b7e:	020d1d93          	sll	s11,s10,0x20
    80003b82:	020ddd93          	srl	s11,s11,0x20
    80003b86:	05848513          	add	a0,s1,88
    80003b8a:	86ee                	mv	a3,s11
    80003b8c:	8652                	mv	a2,s4
    80003b8e:	85de                	mv	a1,s7
    80003b90:	953a                	add	a0,a0,a4
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	a90080e7          	jalr	-1392(ra) # 80002622 <either_copyin>
    80003b9a:	07850263          	beq	a0,s8,80003bfe <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b9e:	8526                	mv	a0,s1
    80003ba0:	00000097          	auipc	ra,0x0
    80003ba4:	75e080e7          	jalr	1886(ra) # 800042fe <log_write>
    brelse(bp);
    80003ba8:	8526                	mv	a0,s1
    80003baa:	fffff097          	auipc	ra,0xfffff
    80003bae:	4fc080e7          	jalr	1276(ra) # 800030a6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bb2:	013d09bb          	addw	s3,s10,s3
    80003bb6:	012d093b          	addw	s2,s10,s2
    80003bba:	9a6e                	add	s4,s4,s11
    80003bbc:	0569f663          	bgeu	s3,s6,80003c08 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003bc0:	00a9559b          	srlw	a1,s2,0xa
    80003bc4:	8556                	mv	a0,s5
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	7a2080e7          	jalr	1954(ra) # 80003368 <bmap>
    80003bce:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003bd2:	c99d                	beqz	a1,80003c08 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003bd4:	000aa503          	lw	a0,0(s5)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	39e080e7          	jalr	926(ra) # 80002f76 <bread>
    80003be0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003be2:	3ff97713          	and	a4,s2,1023
    80003be6:	40ec87bb          	subw	a5,s9,a4
    80003bea:	413b06bb          	subw	a3,s6,s3
    80003bee:	8d3e                	mv	s10,a5
    80003bf0:	2781                	sext.w	a5,a5
    80003bf2:	0006861b          	sext.w	a2,a3
    80003bf6:	f8f674e3          	bgeu	a2,a5,80003b7e <writei+0x4c>
    80003bfa:	8d36                	mv	s10,a3
    80003bfc:	b749                	j	80003b7e <writei+0x4c>
      brelse(bp);
    80003bfe:	8526                	mv	a0,s1
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	4a6080e7          	jalr	1190(ra) # 800030a6 <brelse>
  }

  if(off > ip->size)
    80003c08:	04caa783          	lw	a5,76(s5)
    80003c0c:	0127f463          	bgeu	a5,s2,80003c14 <writei+0xe2>
    ip->size = off;
    80003c10:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    80003c14:	8556                	mv	a0,s5
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	aa4080e7          	jalr	-1372(ra) # 800036ba <iupdate>

  return tot;
    80003c1e:	0009851b          	sext.w	a0,s3
}
    80003c22:	70a6                	ld	ra,104(sp)
    80003c24:	7406                	ld	s0,96(sp)
    80003c26:	64e6                	ld	s1,88(sp)
    80003c28:	6946                	ld	s2,80(sp)
    80003c2a:	69a6                	ld	s3,72(sp)
    80003c2c:	6a06                	ld	s4,64(sp)
    80003c2e:	7ae2                	ld	s5,56(sp)
    80003c30:	7b42                	ld	s6,48(sp)
    80003c32:	7ba2                	ld	s7,40(sp)
    80003c34:	7c02                	ld	s8,32(sp)
    80003c36:	6ce2                	ld	s9,24(sp)
    80003c38:	6d42                	ld	s10,16(sp)
    80003c3a:	6da2                	ld	s11,8(sp)
    80003c3c:	6165                	add	sp,sp,112
    80003c3e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c40:	89da                	mv	s3,s6
    80003c42:	bfc9                	j	80003c14 <writei+0xe2>
    return -1;
    80003c44:	557d                	li	a0,-1
}
    80003c46:	8082                	ret
    return -1;
    80003c48:	557d                	li	a0,-1
    80003c4a:	bfe1                	j	80003c22 <writei+0xf0>
    return -1;
    80003c4c:	557d                	li	a0,-1
    80003c4e:	bfd1                	j	80003c22 <writei+0xf0>

0000000080003c50 <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    80003c50:	1141                	add	sp,sp,-16
    80003c52:	e406                	sd	ra,8(sp)
    80003c54:	e022                	sd	s0,0(sp)
    80003c56:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c58:	4639                	li	a2,14
    80003c5a:	ffffd097          	auipc	ra,0xffffd
    80003c5e:	23e080e7          	jalr	574(ra) # 80000e98 <strncmp>
}
    80003c62:	60a2                	ld	ra,8(sp)
    80003c64:	6402                	ld	s0,0(sp)
    80003c66:	0141                	add	sp,sp,16
    80003c68:	8082                	ret

0000000080003c6a <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c6a:	7139                	add	sp,sp,-64
    80003c6c:	fc06                	sd	ra,56(sp)
    80003c6e:	f822                	sd	s0,48(sp)
    80003c70:	f426                	sd	s1,40(sp)
    80003c72:	f04a                	sd	s2,32(sp)
    80003c74:	ec4e                	sd	s3,24(sp)
    80003c76:	e852                	sd	s4,16(sp)
    80003c78:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c7a:	04451703          	lh	a4,68(a0)
    80003c7e:	4785                	li	a5,1
    80003c80:	00f71a63          	bne	a4,a5,80003c94 <dirlookup+0x2a>
    80003c84:	892a                	mv	s2,a0
    80003c86:	89ae                	mv	s3,a1
    80003c88:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c8a:	457c                	lw	a5,76(a0)
    80003c8c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c8e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c90:	e79d                	bnez	a5,80003cbe <dirlookup+0x54>
    80003c92:	a8a5                	j	80003d0a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c94:	00005517          	auipc	a0,0x5
    80003c98:	99c50513          	add	a0,a0,-1636 # 80008630 <syscalls+0x1a0>
    80003c9c:	ffffd097          	auipc	ra,0xffffd
    80003ca0:	b72080e7          	jalr	-1166(ra) # 8000080e <panic>
      panic("dirlookup read");
    80003ca4:	00005517          	auipc	a0,0x5
    80003ca8:	9a450513          	add	a0,a0,-1628 # 80008648 <syscalls+0x1b8>
    80003cac:	ffffd097          	auipc	ra,0xffffd
    80003cb0:	b62080e7          	jalr	-1182(ra) # 8000080e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cb4:	24c1                	addw	s1,s1,16
    80003cb6:	04c92783          	lw	a5,76(s2)
    80003cba:	04f4f763          	bgeu	s1,a5,80003d08 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cbe:	4741                	li	a4,16
    80003cc0:	86a6                	mv	a3,s1
    80003cc2:	fc040613          	add	a2,s0,-64
    80003cc6:	4581                	li	a1,0
    80003cc8:	854a                	mv	a0,s2
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	d70080e7          	jalr	-656(ra) # 80003a3a <readi>
    80003cd2:	47c1                	li	a5,16
    80003cd4:	fcf518e3          	bne	a0,a5,80003ca4 <dirlookup+0x3a>
    if(de.inum == 0)
    80003cd8:	fc045783          	lhu	a5,-64(s0)
    80003cdc:	dfe1                	beqz	a5,80003cb4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003cde:	fc240593          	add	a1,s0,-62
    80003ce2:	854e                	mv	a0,s3
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	f6c080e7          	jalr	-148(ra) # 80003c50 <namecmp>
    80003cec:	f561                	bnez	a0,80003cb4 <dirlookup+0x4a>
      if(poff)
    80003cee:	000a0463          	beqz	s4,80003cf6 <dirlookup+0x8c>
        *poff = off;
    80003cf2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cf6:	fc045583          	lhu	a1,-64(s0)
    80003cfa:	00092503          	lw	a0,0(s2)
    80003cfe:	fffff097          	auipc	ra,0xfffff
    80003d02:	754080e7          	jalr	1876(ra) # 80003452 <iget>
    80003d06:	a011                	j	80003d0a <dirlookup+0xa0>
  return 0;
    80003d08:	4501                	li	a0,0
}
    80003d0a:	70e2                	ld	ra,56(sp)
    80003d0c:	7442                	ld	s0,48(sp)
    80003d0e:	74a2                	ld	s1,40(sp)
    80003d10:	7902                	ld	s2,32(sp)
    80003d12:	69e2                	ld	s3,24(sp)
    80003d14:	6a42                	ld	s4,16(sp)
    80003d16:	6121                	add	sp,sp,64
    80003d18:	8082                	ret

0000000080003d1a <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d1a:	711d                	add	sp,sp,-96
    80003d1c:	ec86                	sd	ra,88(sp)
    80003d1e:	e8a2                	sd	s0,80(sp)
    80003d20:	e4a6                	sd	s1,72(sp)
    80003d22:	e0ca                	sd	s2,64(sp)
    80003d24:	fc4e                	sd	s3,56(sp)
    80003d26:	f852                	sd	s4,48(sp)
    80003d28:	f456                	sd	s5,40(sp)
    80003d2a:	f05a                	sd	s6,32(sp)
    80003d2c:	ec5e                	sd	s7,24(sp)
    80003d2e:	e862                	sd	s8,16(sp)
    80003d30:	e466                	sd	s9,8(sp)
    80003d32:	1080                	add	s0,sp,96
    80003d34:	84aa                	mv	s1,a0
    80003d36:	8b2e                	mv	s6,a1
    80003d38:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d3a:	00054703          	lbu	a4,0(a0)
    80003d3e:	02f00793          	li	a5,47
    80003d42:	02f70263          	beq	a4,a5,80003d66 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d46:	ffffe097          	auipc	ra,0xffffe
    80003d4a:	db2080e7          	jalr	-590(ra) # 80001af8 <myproc>
    80003d4e:	15053503          	ld	a0,336(a0)
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	9f6080e7          	jalr	-1546(ra) # 80003748 <idup>
    80003d5a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d5c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d60:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d62:	4b85                	li	s7,1
    80003d64:	a875                	j	80003e20 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003d66:	4585                	li	a1,1
    80003d68:	4505                	li	a0,1
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	6e8080e7          	jalr	1768(ra) # 80003452 <iget>
    80003d72:	8a2a                	mv	s4,a0
    80003d74:	b7e5                	j	80003d5c <namex+0x42>
      iunlockput(ip);
    80003d76:	8552                	mv	a0,s4
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	c70080e7          	jalr	-912(ra) # 800039e8 <iunlockput>
      return 0;
    80003d80:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d82:	8552                	mv	a0,s4
    80003d84:	60e6                	ld	ra,88(sp)
    80003d86:	6446                	ld	s0,80(sp)
    80003d88:	64a6                	ld	s1,72(sp)
    80003d8a:	6906                	ld	s2,64(sp)
    80003d8c:	79e2                	ld	s3,56(sp)
    80003d8e:	7a42                	ld	s4,48(sp)
    80003d90:	7aa2                	ld	s5,40(sp)
    80003d92:	7b02                	ld	s6,32(sp)
    80003d94:	6be2                	ld	s7,24(sp)
    80003d96:	6c42                	ld	s8,16(sp)
    80003d98:	6ca2                	ld	s9,8(sp)
    80003d9a:	6125                	add	sp,sp,96
    80003d9c:	8082                	ret
      iunlock(ip);
    80003d9e:	8552                	mv	a0,s4
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	aa8080e7          	jalr	-1368(ra) # 80003848 <iunlock>
      return ip;
    80003da8:	bfe9                	j	80003d82 <namex+0x68>
      iunlockput(ip);
    80003daa:	8552                	mv	a0,s4
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	c3c080e7          	jalr	-964(ra) # 800039e8 <iunlockput>
      return 0;
    80003db4:	8a4e                	mv	s4,s3
    80003db6:	b7f1                	j	80003d82 <namex+0x68>
  len = path - s;
    80003db8:	40998633          	sub	a2,s3,s1
    80003dbc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003dc0:	099c5863          	bge	s8,s9,80003e50 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003dc4:	4639                	li	a2,14
    80003dc6:	85a6                	mv	a1,s1
    80003dc8:	8556                	mv	a0,s5
    80003dca:	ffffd097          	auipc	ra,0xffffd
    80003dce:	05a080e7          	jalr	90(ra) # 80000e24 <memmove>
    80003dd2:	84ce                	mv	s1,s3
  while(*path == '/')
    80003dd4:	0004c783          	lbu	a5,0(s1)
    80003dd8:	01279763          	bne	a5,s2,80003de6 <namex+0xcc>
    path++;
    80003ddc:	0485                	add	s1,s1,1
  while(*path == '/')
    80003dde:	0004c783          	lbu	a5,0(s1)
    80003de2:	ff278de3          	beq	a5,s2,80003ddc <namex+0xc2>
    ilock(ip);
    80003de6:	8552                	mv	a0,s4
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	99e080e7          	jalr	-1634(ra) # 80003786 <ilock>
    if(ip->type != T_DIR){
    80003df0:	044a1783          	lh	a5,68(s4)
    80003df4:	f97791e3          	bne	a5,s7,80003d76 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003df8:	000b0563          	beqz	s6,80003e02 <namex+0xe8>
    80003dfc:	0004c783          	lbu	a5,0(s1)
    80003e00:	dfd9                	beqz	a5,80003d9e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e02:	4601                	li	a2,0
    80003e04:	85d6                	mv	a1,s5
    80003e06:	8552                	mv	a0,s4
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	e62080e7          	jalr	-414(ra) # 80003c6a <dirlookup>
    80003e10:	89aa                	mv	s3,a0
    80003e12:	dd41                	beqz	a0,80003daa <namex+0x90>
    iunlockput(ip);
    80003e14:	8552                	mv	a0,s4
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	bd2080e7          	jalr	-1070(ra) # 800039e8 <iunlockput>
    ip = next;
    80003e1e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e20:	0004c783          	lbu	a5,0(s1)
    80003e24:	01279763          	bne	a5,s2,80003e32 <namex+0x118>
    path++;
    80003e28:	0485                	add	s1,s1,1
  while(*path == '/')
    80003e2a:	0004c783          	lbu	a5,0(s1)
    80003e2e:	ff278de3          	beq	a5,s2,80003e28 <namex+0x10e>
  if(*path == 0)
    80003e32:	cb9d                	beqz	a5,80003e68 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003e34:	0004c783          	lbu	a5,0(s1)
    80003e38:	89a6                	mv	s3,s1
  len = path - s;
    80003e3a:	4c81                	li	s9,0
    80003e3c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e3e:	01278963          	beq	a5,s2,80003e50 <namex+0x136>
    80003e42:	dbbd                	beqz	a5,80003db8 <namex+0x9e>
    path++;
    80003e44:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e46:	0009c783          	lbu	a5,0(s3)
    80003e4a:	ff279ce3          	bne	a5,s2,80003e42 <namex+0x128>
    80003e4e:	b7ad                	j	80003db8 <namex+0x9e>
    memmove(name, s, len);
    80003e50:	2601                	sext.w	a2,a2
    80003e52:	85a6                	mv	a1,s1
    80003e54:	8556                	mv	a0,s5
    80003e56:	ffffd097          	auipc	ra,0xffffd
    80003e5a:	fce080e7          	jalr	-50(ra) # 80000e24 <memmove>
    name[len] = 0;
    80003e5e:	9cd6                	add	s9,s9,s5
    80003e60:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e64:	84ce                	mv	s1,s3
    80003e66:	b7bd                	j	80003dd4 <namex+0xba>
  if(nameiparent){
    80003e68:	f00b0de3          	beqz	s6,80003d82 <namex+0x68>
    iput(ip);
    80003e6c:	8552                	mv	a0,s4
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	ad2080e7          	jalr	-1326(ra) # 80003940 <iput>
    return 0;
    80003e76:	4a01                	li	s4,0
    80003e78:	b729                	j	80003d82 <namex+0x68>

0000000080003e7a <dirlink>:
{
    80003e7a:	7139                	add	sp,sp,-64
    80003e7c:	fc06                	sd	ra,56(sp)
    80003e7e:	f822                	sd	s0,48(sp)
    80003e80:	f426                	sd	s1,40(sp)
    80003e82:	f04a                	sd	s2,32(sp)
    80003e84:	ec4e                	sd	s3,24(sp)
    80003e86:	e852                	sd	s4,16(sp)
    80003e88:	0080                	add	s0,sp,64
    80003e8a:	892a                	mv	s2,a0
    80003e8c:	8a2e                	mv	s4,a1
    80003e8e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e90:	4601                	li	a2,0
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	dd8080e7          	jalr	-552(ra) # 80003c6a <dirlookup>
    80003e9a:	e93d                	bnez	a0,80003f10 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e9c:	04c92483          	lw	s1,76(s2)
    80003ea0:	c49d                	beqz	s1,80003ece <dirlink+0x54>
    80003ea2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ea4:	4741                	li	a4,16
    80003ea6:	86a6                	mv	a3,s1
    80003ea8:	fc040613          	add	a2,s0,-64
    80003eac:	4581                	li	a1,0
    80003eae:	854a                	mv	a0,s2
    80003eb0:	00000097          	auipc	ra,0x0
    80003eb4:	b8a080e7          	jalr	-1142(ra) # 80003a3a <readi>
    80003eb8:	47c1                	li	a5,16
    80003eba:	06f51163          	bne	a0,a5,80003f1c <dirlink+0xa2>
    if(de.inum == 0)
    80003ebe:	fc045783          	lhu	a5,-64(s0)
    80003ec2:	c791                	beqz	a5,80003ece <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ec4:	24c1                	addw	s1,s1,16
    80003ec6:	04c92783          	lw	a5,76(s2)
    80003eca:	fcf4ede3          	bltu	s1,a5,80003ea4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003ece:	4639                	li	a2,14
    80003ed0:	85d2                	mv	a1,s4
    80003ed2:	fc240513          	add	a0,s0,-62
    80003ed6:	ffffd097          	auipc	ra,0xffffd
    80003eda:	ffe080e7          	jalr	-2(ra) # 80000ed4 <strncpy>
  de.inum = inum;
    80003ede:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ee2:	4741                	li	a4,16
    80003ee4:	86a6                	mv	a3,s1
    80003ee6:	fc040613          	add	a2,s0,-64
    80003eea:	4581                	li	a1,0
    80003eec:	854a                	mv	a0,s2
    80003eee:	00000097          	auipc	ra,0x0
    80003ef2:	c44080e7          	jalr	-956(ra) # 80003b32 <writei>
    80003ef6:	1541                	add	a0,a0,-16
    80003ef8:	00a03533          	snez	a0,a0
    80003efc:	40a00533          	neg	a0,a0
}
    80003f00:	70e2                	ld	ra,56(sp)
    80003f02:	7442                	ld	s0,48(sp)
    80003f04:	74a2                	ld	s1,40(sp)
    80003f06:	7902                	ld	s2,32(sp)
    80003f08:	69e2                	ld	s3,24(sp)
    80003f0a:	6a42                	ld	s4,16(sp)
    80003f0c:	6121                	add	sp,sp,64
    80003f0e:	8082                	ret
    iput(ip);
    80003f10:	00000097          	auipc	ra,0x0
    80003f14:	a30080e7          	jalr	-1488(ra) # 80003940 <iput>
    return -1;
    80003f18:	557d                	li	a0,-1
    80003f1a:	b7dd                	j	80003f00 <dirlink+0x86>
      panic("dirlink read");
    80003f1c:	00004517          	auipc	a0,0x4
    80003f20:	73c50513          	add	a0,a0,1852 # 80008658 <syscalls+0x1c8>
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	8ea080e7          	jalr	-1814(ra) # 8000080e <panic>

0000000080003f2c <namei>:

struct inode*
namei(char *path)
{
    80003f2c:	1101                	add	sp,sp,-32
    80003f2e:	ec06                	sd	ra,24(sp)
    80003f30:	e822                	sd	s0,16(sp)
    80003f32:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f34:	fe040613          	add	a2,s0,-32
    80003f38:	4581                	li	a1,0
    80003f3a:	00000097          	auipc	ra,0x0
    80003f3e:	de0080e7          	jalr	-544(ra) # 80003d1a <namex>
}
    80003f42:	60e2                	ld	ra,24(sp)
    80003f44:	6442                	ld	s0,16(sp)
    80003f46:	6105                	add	sp,sp,32
    80003f48:	8082                	ret

0000000080003f4a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f4a:	1141                	add	sp,sp,-16
    80003f4c:	e406                	sd	ra,8(sp)
    80003f4e:	e022                	sd	s0,0(sp)
    80003f50:	0800                	add	s0,sp,16
    80003f52:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f54:	4585                	li	a1,1
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	dc4080e7          	jalr	-572(ra) # 80003d1a <namex>
}
    80003f5e:	60a2                	ld	ra,8(sp)
    80003f60:	6402                	ld	s0,0(sp)
    80003f62:	0141                	add	sp,sp,16
    80003f64:	8082                	ret

0000000080003f66 <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    80003f66:	1101                	add	sp,sp,-32
    80003f68:	ec06                	sd	ra,24(sp)
    80003f6a:	e822                	sd	s0,16(sp)
    80003f6c:	e426                	sd	s1,8(sp)
    80003f6e:	e04a                	sd	s2,0(sp)
    80003f70:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f72:	0001d917          	auipc	s2,0x1d
    80003f76:	a8e90913          	add	s2,s2,-1394 # 80020a00 <log>
    80003f7a:	01892583          	lw	a1,24(s2)
    80003f7e:	02892503          	lw	a0,40(s2)
    80003f82:	fffff097          	auipc	ra,0xfffff
    80003f86:	ff4080e7          	jalr	-12(ra) # 80002f76 <bread>
    80003f8a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f8c:	02c92603          	lw	a2,44(s2)
    80003f90:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f92:	00c05f63          	blez	a2,80003fb0 <write_head+0x4a>
    80003f96:	0001d717          	auipc	a4,0x1d
    80003f9a:	a9a70713          	add	a4,a4,-1382 # 80020a30 <log+0x30>
    80003f9e:	87aa                	mv	a5,a0
    80003fa0:	060a                	sll	a2,a2,0x2
    80003fa2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003fa4:	4314                	lw	a3,0(a4)
    80003fa6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003fa8:	0711                	add	a4,a4,4
    80003faa:	0791                	add	a5,a5,4
    80003fac:	fec79ce3          	bne	a5,a2,80003fa4 <write_head+0x3e>
  }
  bwrite(buf);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	0b6080e7          	jalr	182(ra) # 80003068 <bwrite>
  brelse(buf);
    80003fba:	8526                	mv	a0,s1
    80003fbc:	fffff097          	auipc	ra,0xfffff
    80003fc0:	0ea080e7          	jalr	234(ra) # 800030a6 <brelse>
}
    80003fc4:	60e2                	ld	ra,24(sp)
    80003fc6:	6442                	ld	s0,16(sp)
    80003fc8:	64a2                	ld	s1,8(sp)
    80003fca:	6902                	ld	s2,0(sp)
    80003fcc:	6105                	add	sp,sp,32
    80003fce:	8082                	ret

0000000080003fd0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fd0:	0001d797          	auipc	a5,0x1d
    80003fd4:	a5c7a783          	lw	a5,-1444(a5) # 80020a2c <log+0x2c>
    80003fd8:	0af05d63          	blez	a5,80004092 <install_trans+0xc2>
{
    80003fdc:	7139                	add	sp,sp,-64
    80003fde:	fc06                	sd	ra,56(sp)
    80003fe0:	f822                	sd	s0,48(sp)
    80003fe2:	f426                	sd	s1,40(sp)
    80003fe4:	f04a                	sd	s2,32(sp)
    80003fe6:	ec4e                	sd	s3,24(sp)
    80003fe8:	e852                	sd	s4,16(sp)
    80003fea:	e456                	sd	s5,8(sp)
    80003fec:	e05a                	sd	s6,0(sp)
    80003fee:	0080                	add	s0,sp,64
    80003ff0:	8b2a                	mv	s6,a0
    80003ff2:	0001da97          	auipc	s5,0x1d
    80003ff6:	a3ea8a93          	add	s5,s5,-1474 # 80020a30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ffa:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80003ffc:	0001d997          	auipc	s3,0x1d
    80004000:	a0498993          	add	s3,s3,-1532 # 80020a00 <log>
    80004004:	a00d                	j	80004026 <install_trans+0x56>
    brelse(lbuf);
    80004006:	854a                	mv	a0,s2
    80004008:	fffff097          	auipc	ra,0xfffff
    8000400c:	09e080e7          	jalr	158(ra) # 800030a6 <brelse>
    brelse(dbuf);
    80004010:	8526                	mv	a0,s1
    80004012:	fffff097          	auipc	ra,0xfffff
    80004016:	094080e7          	jalr	148(ra) # 800030a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000401a:	2a05                	addw	s4,s4,1
    8000401c:	0a91                	add	s5,s5,4
    8000401e:	02c9a783          	lw	a5,44(s3)
    80004022:	04fa5e63          	bge	s4,a5,8000407e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80004026:	0189a583          	lw	a1,24(s3)
    8000402a:	014585bb          	addw	a1,a1,s4
    8000402e:	2585                	addw	a1,a1,1
    80004030:	0289a503          	lw	a0,40(s3)
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	f42080e7          	jalr	-190(ra) # 80002f76 <bread>
    8000403c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    8000403e:	000aa583          	lw	a1,0(s5)
    80004042:	0289a503          	lw	a0,40(s3)
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	f30080e7          	jalr	-208(ra) # 80002f76 <bread>
    8000404e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    80004050:	40000613          	li	a2,1024
    80004054:	05890593          	add	a1,s2,88
    80004058:	05850513          	add	a0,a0,88
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	dc8080e7          	jalr	-568(ra) # 80000e24 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    80004064:	8526                	mv	a0,s1
    80004066:	fffff097          	auipc	ra,0xfffff
    8000406a:	002080e7          	jalr	2(ra) # 80003068 <bwrite>
    if(recovering == 0)
    8000406e:	f80b1ce3          	bnez	s6,80004006 <install_trans+0x36>
      bunpin(dbuf);
    80004072:	8526                	mv	a0,s1
    80004074:	fffff097          	auipc	ra,0xfffff
    80004078:	10a080e7          	jalr	266(ra) # 8000317e <bunpin>
    8000407c:	b769                	j	80004006 <install_trans+0x36>
}
    8000407e:	70e2                	ld	ra,56(sp)
    80004080:	7442                	ld	s0,48(sp)
    80004082:	74a2                	ld	s1,40(sp)
    80004084:	7902                	ld	s2,32(sp)
    80004086:	69e2                	ld	s3,24(sp)
    80004088:	6a42                	ld	s4,16(sp)
    8000408a:	6aa2                	ld	s5,8(sp)
    8000408c:	6b02                	ld	s6,0(sp)
    8000408e:	6121                	add	sp,sp,64
    80004090:	8082                	ret
    80004092:	8082                	ret

0000000080004094 <initlog>:
{
    80004094:	7179                	add	sp,sp,-48
    80004096:	f406                	sd	ra,40(sp)
    80004098:	f022                	sd	s0,32(sp)
    8000409a:	ec26                	sd	s1,24(sp)
    8000409c:	e84a                	sd	s2,16(sp)
    8000409e:	e44e                	sd	s3,8(sp)
    800040a0:	1800                	add	s0,sp,48
    800040a2:	892a                	mv	s2,a0
    800040a4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800040a6:	0001d497          	auipc	s1,0x1d
    800040aa:	95a48493          	add	s1,s1,-1702 # 80020a00 <log>
    800040ae:	00004597          	auipc	a1,0x4
    800040b2:	5ba58593          	add	a1,a1,1466 # 80008668 <syscalls+0x1d8>
    800040b6:	8526                	mv	a0,s1
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	b84080e7          	jalr	-1148(ra) # 80000c3c <initlock>
  log.start = sb->logstart;
    800040c0:	0149a583          	lw	a1,20(s3)
    800040c4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040c6:	0109a783          	lw	a5,16(s3)
    800040ca:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040cc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040d0:	854a                	mv	a0,s2
    800040d2:	fffff097          	auipc	ra,0xfffff
    800040d6:	ea4080e7          	jalr	-348(ra) # 80002f76 <bread>
  log.lh.n = lh->n;
    800040da:	4d30                	lw	a2,88(a0)
    800040dc:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040de:	00c05f63          	blez	a2,800040fc <initlog+0x68>
    800040e2:	87aa                	mv	a5,a0
    800040e4:	0001d717          	auipc	a4,0x1d
    800040e8:	94c70713          	add	a4,a4,-1716 # 80020a30 <log+0x30>
    800040ec:	060a                	sll	a2,a2,0x2
    800040ee:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800040f0:	4ff4                	lw	a3,92(a5)
    800040f2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040f4:	0791                	add	a5,a5,4
    800040f6:	0711                	add	a4,a4,4
    800040f8:	fec79ce3          	bne	a5,a2,800040f0 <initlog+0x5c>
  brelse(buf);
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	faa080e7          	jalr	-86(ra) # 800030a6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    80004104:	4505                	li	a0,1
    80004106:	00000097          	auipc	ra,0x0
    8000410a:	eca080e7          	jalr	-310(ra) # 80003fd0 <install_trans>
  log.lh.n = 0;
    8000410e:	0001d797          	auipc	a5,0x1d
    80004112:	9007af23          	sw	zero,-1762(a5) # 80020a2c <log+0x2c>
  write_head(); /* clear the log */
    80004116:	00000097          	auipc	ra,0x0
    8000411a:	e50080e7          	jalr	-432(ra) # 80003f66 <write_head>
}
    8000411e:	70a2                	ld	ra,40(sp)
    80004120:	7402                	ld	s0,32(sp)
    80004122:	64e2                	ld	s1,24(sp)
    80004124:	6942                	ld	s2,16(sp)
    80004126:	69a2                	ld	s3,8(sp)
    80004128:	6145                	add	sp,sp,48
    8000412a:	8082                	ret

000000008000412c <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    8000412c:	1101                	add	sp,sp,-32
    8000412e:	ec06                	sd	ra,24(sp)
    80004130:	e822                	sd	s0,16(sp)
    80004132:	e426                	sd	s1,8(sp)
    80004134:	e04a                	sd	s2,0(sp)
    80004136:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80004138:	0001d517          	auipc	a0,0x1d
    8000413c:	8c850513          	add	a0,a0,-1848 # 80020a00 <log>
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	b8c080e7          	jalr	-1140(ra) # 80000ccc <acquire>
  while(1){
    if(log.committing){
    80004148:	0001d497          	auipc	s1,0x1d
    8000414c:	8b848493          	add	s1,s1,-1864 # 80020a00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004150:	4979                	li	s2,30
    80004152:	a039                	j	80004160 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004154:	85a6                	mv	a1,s1
    80004156:	8526                	mv	a0,s1
    80004158:	ffffe097          	auipc	ra,0xffffe
    8000415c:	06c080e7          	jalr	108(ra) # 800021c4 <sleep>
    if(log.committing){
    80004160:	50dc                	lw	a5,36(s1)
    80004162:	fbed                	bnez	a5,80004154 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004164:	5098                	lw	a4,32(s1)
    80004166:	2705                	addw	a4,a4,1
    80004168:	0027179b          	sllw	a5,a4,0x2
    8000416c:	9fb9                	addw	a5,a5,a4
    8000416e:	0017979b          	sllw	a5,a5,0x1
    80004172:	54d4                	lw	a3,44(s1)
    80004174:	9fb5                	addw	a5,a5,a3
    80004176:	00f95963          	bge	s2,a5,80004188 <begin_op+0x5c>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    8000417a:	85a6                	mv	a1,s1
    8000417c:	8526                	mv	a0,s1
    8000417e:	ffffe097          	auipc	ra,0xffffe
    80004182:	046080e7          	jalr	70(ra) # 800021c4 <sleep>
    80004186:	bfe9                	j	80004160 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004188:	0001d517          	auipc	a0,0x1d
    8000418c:	87850513          	add	a0,a0,-1928 # 80020a00 <log>
    80004190:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	bee080e7          	jalr	-1042(ra) # 80000d80 <release>
      break;
    }
  }
}
    8000419a:	60e2                	ld	ra,24(sp)
    8000419c:	6442                	ld	s0,16(sp)
    8000419e:	64a2                	ld	s1,8(sp)
    800041a0:	6902                	ld	s2,0(sp)
    800041a2:	6105                	add	sp,sp,32
    800041a4:	8082                	ret

00000000800041a6 <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    800041a6:	7139                	add	sp,sp,-64
    800041a8:	fc06                	sd	ra,56(sp)
    800041aa:	f822                	sd	s0,48(sp)
    800041ac:	f426                	sd	s1,40(sp)
    800041ae:	f04a                	sd	s2,32(sp)
    800041b0:	ec4e                	sd	s3,24(sp)
    800041b2:	e852                	sd	s4,16(sp)
    800041b4:	e456                	sd	s5,8(sp)
    800041b6:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041b8:	0001d497          	auipc	s1,0x1d
    800041bc:	84848493          	add	s1,s1,-1976 # 80020a00 <log>
    800041c0:	8526                	mv	a0,s1
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	b0a080e7          	jalr	-1270(ra) # 80000ccc <acquire>
  log.outstanding -= 1;
    800041ca:	509c                	lw	a5,32(s1)
    800041cc:	37fd                	addw	a5,a5,-1
    800041ce:	0007891b          	sext.w	s2,a5
    800041d2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041d4:	50dc                	lw	a5,36(s1)
    800041d6:	e7b9                	bnez	a5,80004224 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041d8:	04091e63          	bnez	s2,80004234 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041dc:	0001d497          	auipc	s1,0x1d
    800041e0:	82448493          	add	s1,s1,-2012 # 80020a00 <log>
    800041e4:	4785                	li	a5,1
    800041e6:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    800041e8:	8526                	mv	a0,s1
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	b96080e7          	jalr	-1130(ra) # 80000d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041f2:	54dc                	lw	a5,44(s1)
    800041f4:	06f04763          	bgtz	a5,80004262 <end_op+0xbc>
    acquire(&log.lock);
    800041f8:	0001d497          	auipc	s1,0x1d
    800041fc:	80848493          	add	s1,s1,-2040 # 80020a00 <log>
    80004200:	8526                	mv	a0,s1
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	aca080e7          	jalr	-1334(ra) # 80000ccc <acquire>
    log.committing = 0;
    8000420a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000420e:	8526                	mv	a0,s1
    80004210:	ffffe097          	auipc	ra,0xffffe
    80004214:	018080e7          	jalr	24(ra) # 80002228 <wakeup>
    release(&log.lock);
    80004218:	8526                	mv	a0,s1
    8000421a:	ffffd097          	auipc	ra,0xffffd
    8000421e:	b66080e7          	jalr	-1178(ra) # 80000d80 <release>
}
    80004222:	a03d                	j	80004250 <end_op+0xaa>
    panic("log.committing");
    80004224:	00004517          	auipc	a0,0x4
    80004228:	44c50513          	add	a0,a0,1100 # 80008670 <syscalls+0x1e0>
    8000422c:	ffffc097          	auipc	ra,0xffffc
    80004230:	5e2080e7          	jalr	1506(ra) # 8000080e <panic>
    wakeup(&log);
    80004234:	0001c497          	auipc	s1,0x1c
    80004238:	7cc48493          	add	s1,s1,1996 # 80020a00 <log>
    8000423c:	8526                	mv	a0,s1
    8000423e:	ffffe097          	auipc	ra,0xffffe
    80004242:	fea080e7          	jalr	-22(ra) # 80002228 <wakeup>
  release(&log.lock);
    80004246:	8526                	mv	a0,s1
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	b38080e7          	jalr	-1224(ra) # 80000d80 <release>
}
    80004250:	70e2                	ld	ra,56(sp)
    80004252:	7442                	ld	s0,48(sp)
    80004254:	74a2                	ld	s1,40(sp)
    80004256:	7902                	ld	s2,32(sp)
    80004258:	69e2                	ld	s3,24(sp)
    8000425a:	6a42                	ld	s4,16(sp)
    8000425c:	6aa2                	ld	s5,8(sp)
    8000425e:	6121                	add	sp,sp,64
    80004260:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004262:	0001ca97          	auipc	s5,0x1c
    80004266:	7cea8a93          	add	s5,s5,1998 # 80020a30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    8000426a:	0001ca17          	auipc	s4,0x1c
    8000426e:	796a0a13          	add	s4,s4,1942 # 80020a00 <log>
    80004272:	018a2583          	lw	a1,24(s4)
    80004276:	012585bb          	addw	a1,a1,s2
    8000427a:	2585                	addw	a1,a1,1
    8000427c:	028a2503          	lw	a0,40(s4)
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	cf6080e7          	jalr	-778(ra) # 80002f76 <bread>
    80004288:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    8000428a:	000aa583          	lw	a1,0(s5)
    8000428e:	028a2503          	lw	a0,40(s4)
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	ce4080e7          	jalr	-796(ra) # 80002f76 <bread>
    8000429a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000429c:	40000613          	li	a2,1024
    800042a0:	05850593          	add	a1,a0,88
    800042a4:	05848513          	add	a0,s1,88
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	b7c080e7          	jalr	-1156(ra) # 80000e24 <memmove>
    bwrite(to);  /* write the log */
    800042b0:	8526                	mv	a0,s1
    800042b2:	fffff097          	auipc	ra,0xfffff
    800042b6:	db6080e7          	jalr	-586(ra) # 80003068 <bwrite>
    brelse(from);
    800042ba:	854e                	mv	a0,s3
    800042bc:	fffff097          	auipc	ra,0xfffff
    800042c0:	dea080e7          	jalr	-534(ra) # 800030a6 <brelse>
    brelse(to);
    800042c4:	8526                	mv	a0,s1
    800042c6:	fffff097          	auipc	ra,0xfffff
    800042ca:	de0080e7          	jalr	-544(ra) # 800030a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042ce:	2905                	addw	s2,s2,1
    800042d0:	0a91                	add	s5,s5,4
    800042d2:	02ca2783          	lw	a5,44(s4)
    800042d6:	f8f94ee3          	blt	s2,a5,80004272 <end_op+0xcc>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    800042da:	00000097          	auipc	ra,0x0
    800042de:	c8c080e7          	jalr	-884(ra) # 80003f66 <write_head>
    install_trans(0); /* Now install writes to home locations */
    800042e2:	4501                	li	a0,0
    800042e4:	00000097          	auipc	ra,0x0
    800042e8:	cec080e7          	jalr	-788(ra) # 80003fd0 <install_trans>
    log.lh.n = 0;
    800042ec:	0001c797          	auipc	a5,0x1c
    800042f0:	7407a023          	sw	zero,1856(a5) # 80020a2c <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    800042f4:	00000097          	auipc	ra,0x0
    800042f8:	c72080e7          	jalr	-910(ra) # 80003f66 <write_head>
    800042fc:	bdf5                	j	800041f8 <end_op+0x52>

00000000800042fe <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    800042fe:	1101                	add	sp,sp,-32
    80004300:	ec06                	sd	ra,24(sp)
    80004302:	e822                	sd	s0,16(sp)
    80004304:	e426                	sd	s1,8(sp)
    80004306:	e04a                	sd	s2,0(sp)
    80004308:	1000                	add	s0,sp,32
    8000430a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000430c:	0001c917          	auipc	s2,0x1c
    80004310:	6f490913          	add	s2,s2,1780 # 80020a00 <log>
    80004314:	854a                	mv	a0,s2
    80004316:	ffffd097          	auipc	ra,0xffffd
    8000431a:	9b6080e7          	jalr	-1610(ra) # 80000ccc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000431e:	02c92603          	lw	a2,44(s2)
    80004322:	47f5                	li	a5,29
    80004324:	06c7c563          	blt	a5,a2,8000438e <log_write+0x90>
    80004328:	0001c797          	auipc	a5,0x1c
    8000432c:	6f47a783          	lw	a5,1780(a5) # 80020a1c <log+0x1c>
    80004330:	37fd                	addw	a5,a5,-1
    80004332:	04f65e63          	bge	a2,a5,8000438e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004336:	0001c797          	auipc	a5,0x1c
    8000433a:	6ea7a783          	lw	a5,1770(a5) # 80020a20 <log+0x20>
    8000433e:	06f05063          	blez	a5,8000439e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004342:	4781                	li	a5,0
    80004344:	06c05563          	blez	a2,800043ae <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80004348:	44cc                	lw	a1,12(s1)
    8000434a:	0001c717          	auipc	a4,0x1c
    8000434e:	6e670713          	add	a4,a4,1766 # 80020a30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004352:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80004354:	4314                	lw	a3,0(a4)
    80004356:	04b68c63          	beq	a3,a1,800043ae <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000435a:	2785                	addw	a5,a5,1
    8000435c:	0711                	add	a4,a4,4
    8000435e:	fef61be3          	bne	a2,a5,80004354 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004362:	0621                	add	a2,a2,8
    80004364:	060a                	sll	a2,a2,0x2
    80004366:	0001c797          	auipc	a5,0x1c
    8000436a:	69a78793          	add	a5,a5,1690 # 80020a00 <log>
    8000436e:	97b2                	add	a5,a5,a2
    80004370:	44d8                	lw	a4,12(s1)
    80004372:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    80004374:	8526                	mv	a0,s1
    80004376:	fffff097          	auipc	ra,0xfffff
    8000437a:	dcc080e7          	jalr	-564(ra) # 80003142 <bpin>
    log.lh.n++;
    8000437e:	0001c717          	auipc	a4,0x1c
    80004382:	68270713          	add	a4,a4,1666 # 80020a00 <log>
    80004386:	575c                	lw	a5,44(a4)
    80004388:	2785                	addw	a5,a5,1
    8000438a:	d75c                	sw	a5,44(a4)
    8000438c:	a82d                	j	800043c6 <log_write+0xc8>
    panic("too big a transaction");
    8000438e:	00004517          	auipc	a0,0x4
    80004392:	2f250513          	add	a0,a0,754 # 80008680 <syscalls+0x1f0>
    80004396:	ffffc097          	auipc	ra,0xffffc
    8000439a:	478080e7          	jalr	1144(ra) # 8000080e <panic>
    panic("log_write outside of trans");
    8000439e:	00004517          	auipc	a0,0x4
    800043a2:	2fa50513          	add	a0,a0,762 # 80008698 <syscalls+0x208>
    800043a6:	ffffc097          	auipc	ra,0xffffc
    800043aa:	468080e7          	jalr	1128(ra) # 8000080e <panic>
  log.lh.block[i] = b->blockno;
    800043ae:	00878693          	add	a3,a5,8
    800043b2:	068a                	sll	a3,a3,0x2
    800043b4:	0001c717          	auipc	a4,0x1c
    800043b8:	64c70713          	add	a4,a4,1612 # 80020a00 <log>
    800043bc:	9736                	add	a4,a4,a3
    800043be:	44d4                	lw	a3,12(s1)
    800043c0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    800043c2:	faf609e3          	beq	a2,a5,80004374 <log_write+0x76>
  }
  release(&log.lock);
    800043c6:	0001c517          	auipc	a0,0x1c
    800043ca:	63a50513          	add	a0,a0,1594 # 80020a00 <log>
    800043ce:	ffffd097          	auipc	ra,0xffffd
    800043d2:	9b2080e7          	jalr	-1614(ra) # 80000d80 <release>
}
    800043d6:	60e2                	ld	ra,24(sp)
    800043d8:	6442                	ld	s0,16(sp)
    800043da:	64a2                	ld	s1,8(sp)
    800043dc:	6902                	ld	s2,0(sp)
    800043de:	6105                	add	sp,sp,32
    800043e0:	8082                	ret

00000000800043e2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043e2:	1101                	add	sp,sp,-32
    800043e4:	ec06                	sd	ra,24(sp)
    800043e6:	e822                	sd	s0,16(sp)
    800043e8:	e426                	sd	s1,8(sp)
    800043ea:	e04a                	sd	s2,0(sp)
    800043ec:	1000                	add	s0,sp,32
    800043ee:	84aa                	mv	s1,a0
    800043f0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043f2:	00004597          	auipc	a1,0x4
    800043f6:	2c658593          	add	a1,a1,710 # 800086b8 <syscalls+0x228>
    800043fa:	0521                	add	a0,a0,8
    800043fc:	ffffd097          	auipc	ra,0xffffd
    80004400:	840080e7          	jalr	-1984(ra) # 80000c3c <initlock>
  lk->name = name;
    80004404:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004408:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000440c:	0204a423          	sw	zero,40(s1)
}
    80004410:	60e2                	ld	ra,24(sp)
    80004412:	6442                	ld	s0,16(sp)
    80004414:	64a2                	ld	s1,8(sp)
    80004416:	6902                	ld	s2,0(sp)
    80004418:	6105                	add	sp,sp,32
    8000441a:	8082                	ret

000000008000441c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000441c:	1101                	add	sp,sp,-32
    8000441e:	ec06                	sd	ra,24(sp)
    80004420:	e822                	sd	s0,16(sp)
    80004422:	e426                	sd	s1,8(sp)
    80004424:	e04a                	sd	s2,0(sp)
    80004426:	1000                	add	s0,sp,32
    80004428:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000442a:	00850913          	add	s2,a0,8
    8000442e:	854a                	mv	a0,s2
    80004430:	ffffd097          	auipc	ra,0xffffd
    80004434:	89c080e7          	jalr	-1892(ra) # 80000ccc <acquire>
  while (lk->locked) {
    80004438:	409c                	lw	a5,0(s1)
    8000443a:	cb89                	beqz	a5,8000444c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000443c:	85ca                	mv	a1,s2
    8000443e:	8526                	mv	a0,s1
    80004440:	ffffe097          	auipc	ra,0xffffe
    80004444:	d84080e7          	jalr	-636(ra) # 800021c4 <sleep>
  while (lk->locked) {
    80004448:	409c                	lw	a5,0(s1)
    8000444a:	fbed                	bnez	a5,8000443c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000444c:	4785                	li	a5,1
    8000444e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004450:	ffffd097          	auipc	ra,0xffffd
    80004454:	6a8080e7          	jalr	1704(ra) # 80001af8 <myproc>
    80004458:	591c                	lw	a5,48(a0)
    8000445a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000445c:	854a                	mv	a0,s2
    8000445e:	ffffd097          	auipc	ra,0xffffd
    80004462:	922080e7          	jalr	-1758(ra) # 80000d80 <release>
}
    80004466:	60e2                	ld	ra,24(sp)
    80004468:	6442                	ld	s0,16(sp)
    8000446a:	64a2                	ld	s1,8(sp)
    8000446c:	6902                	ld	s2,0(sp)
    8000446e:	6105                	add	sp,sp,32
    80004470:	8082                	ret

0000000080004472 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004472:	1101                	add	sp,sp,-32
    80004474:	ec06                	sd	ra,24(sp)
    80004476:	e822                	sd	s0,16(sp)
    80004478:	e426                	sd	s1,8(sp)
    8000447a:	e04a                	sd	s2,0(sp)
    8000447c:	1000                	add	s0,sp,32
    8000447e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004480:	00850913          	add	s2,a0,8
    80004484:	854a                	mv	a0,s2
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	846080e7          	jalr	-1978(ra) # 80000ccc <acquire>
  lk->locked = 0;
    8000448e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004492:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004496:	8526                	mv	a0,s1
    80004498:	ffffe097          	auipc	ra,0xffffe
    8000449c:	d90080e7          	jalr	-624(ra) # 80002228 <wakeup>
  release(&lk->lk);
    800044a0:	854a                	mv	a0,s2
    800044a2:	ffffd097          	auipc	ra,0xffffd
    800044a6:	8de080e7          	jalr	-1826(ra) # 80000d80 <release>
}
    800044aa:	60e2                	ld	ra,24(sp)
    800044ac:	6442                	ld	s0,16(sp)
    800044ae:	64a2                	ld	s1,8(sp)
    800044b0:	6902                	ld	s2,0(sp)
    800044b2:	6105                	add	sp,sp,32
    800044b4:	8082                	ret

00000000800044b6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044b6:	7179                	add	sp,sp,-48
    800044b8:	f406                	sd	ra,40(sp)
    800044ba:	f022                	sd	s0,32(sp)
    800044bc:	ec26                	sd	s1,24(sp)
    800044be:	e84a                	sd	s2,16(sp)
    800044c0:	e44e                	sd	s3,8(sp)
    800044c2:	1800                	add	s0,sp,48
    800044c4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044c6:	00850913          	add	s2,a0,8
    800044ca:	854a                	mv	a0,s2
    800044cc:	ffffd097          	auipc	ra,0xffffd
    800044d0:	800080e7          	jalr	-2048(ra) # 80000ccc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044d4:	409c                	lw	a5,0(s1)
    800044d6:	ef99                	bnez	a5,800044f4 <holdingsleep+0x3e>
    800044d8:	4481                	li	s1,0
  release(&lk->lk);
    800044da:	854a                	mv	a0,s2
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	8a4080e7          	jalr	-1884(ra) # 80000d80 <release>
  return r;
}
    800044e4:	8526                	mv	a0,s1
    800044e6:	70a2                	ld	ra,40(sp)
    800044e8:	7402                	ld	s0,32(sp)
    800044ea:	64e2                	ld	s1,24(sp)
    800044ec:	6942                	ld	s2,16(sp)
    800044ee:	69a2                	ld	s3,8(sp)
    800044f0:	6145                	add	sp,sp,48
    800044f2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044f4:	0284a983          	lw	s3,40(s1)
    800044f8:	ffffd097          	auipc	ra,0xffffd
    800044fc:	600080e7          	jalr	1536(ra) # 80001af8 <myproc>
    80004500:	5904                	lw	s1,48(a0)
    80004502:	413484b3          	sub	s1,s1,s3
    80004506:	0014b493          	seqz	s1,s1
    8000450a:	bfc1                	j	800044da <holdingsleep+0x24>

000000008000450c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000450c:	1141                	add	sp,sp,-16
    8000450e:	e406                	sd	ra,8(sp)
    80004510:	e022                	sd	s0,0(sp)
    80004512:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004514:	00004597          	auipc	a1,0x4
    80004518:	1b458593          	add	a1,a1,436 # 800086c8 <syscalls+0x238>
    8000451c:	0001c517          	auipc	a0,0x1c
    80004520:	62c50513          	add	a0,a0,1580 # 80020b48 <ftable>
    80004524:	ffffc097          	auipc	ra,0xffffc
    80004528:	718080e7          	jalr	1816(ra) # 80000c3c <initlock>
}
    8000452c:	60a2                	ld	ra,8(sp)
    8000452e:	6402                	ld	s0,0(sp)
    80004530:	0141                	add	sp,sp,16
    80004532:	8082                	ret

0000000080004534 <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    80004534:	1101                	add	sp,sp,-32
    80004536:	ec06                	sd	ra,24(sp)
    80004538:	e822                	sd	s0,16(sp)
    8000453a:	e426                	sd	s1,8(sp)
    8000453c:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000453e:	0001c517          	auipc	a0,0x1c
    80004542:	60a50513          	add	a0,a0,1546 # 80020b48 <ftable>
    80004546:	ffffc097          	auipc	ra,0xffffc
    8000454a:	786080e7          	jalr	1926(ra) # 80000ccc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000454e:	0001c497          	auipc	s1,0x1c
    80004552:	61248493          	add	s1,s1,1554 # 80020b60 <ftable+0x18>
    80004556:	0001d717          	auipc	a4,0x1d
    8000455a:	5aa70713          	add	a4,a4,1450 # 80021b00 <disk>
    if(f->ref == 0){
    8000455e:	40dc                	lw	a5,4(s1)
    80004560:	cf99                	beqz	a5,8000457e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004562:	02848493          	add	s1,s1,40
    80004566:	fee49ce3          	bne	s1,a4,8000455e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000456a:	0001c517          	auipc	a0,0x1c
    8000456e:	5de50513          	add	a0,a0,1502 # 80020b48 <ftable>
    80004572:	ffffd097          	auipc	ra,0xffffd
    80004576:	80e080e7          	jalr	-2034(ra) # 80000d80 <release>
  return 0;
    8000457a:	4481                	li	s1,0
    8000457c:	a819                	j	80004592 <filealloc+0x5e>
      f->ref = 1;
    8000457e:	4785                	li	a5,1
    80004580:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004582:	0001c517          	auipc	a0,0x1c
    80004586:	5c650513          	add	a0,a0,1478 # 80020b48 <ftable>
    8000458a:	ffffc097          	auipc	ra,0xffffc
    8000458e:	7f6080e7          	jalr	2038(ra) # 80000d80 <release>
}
    80004592:	8526                	mv	a0,s1
    80004594:	60e2                	ld	ra,24(sp)
    80004596:	6442                	ld	s0,16(sp)
    80004598:	64a2                	ld	s1,8(sp)
    8000459a:	6105                	add	sp,sp,32
    8000459c:	8082                	ret

000000008000459e <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    8000459e:	1101                	add	sp,sp,-32
    800045a0:	ec06                	sd	ra,24(sp)
    800045a2:	e822                	sd	s0,16(sp)
    800045a4:	e426                	sd	s1,8(sp)
    800045a6:	1000                	add	s0,sp,32
    800045a8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800045aa:	0001c517          	auipc	a0,0x1c
    800045ae:	59e50513          	add	a0,a0,1438 # 80020b48 <ftable>
    800045b2:	ffffc097          	auipc	ra,0xffffc
    800045b6:	71a080e7          	jalr	1818(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    800045ba:	40dc                	lw	a5,4(s1)
    800045bc:	02f05263          	blez	a5,800045e0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045c0:	2785                	addw	a5,a5,1
    800045c2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045c4:	0001c517          	auipc	a0,0x1c
    800045c8:	58450513          	add	a0,a0,1412 # 80020b48 <ftable>
    800045cc:	ffffc097          	auipc	ra,0xffffc
    800045d0:	7b4080e7          	jalr	1972(ra) # 80000d80 <release>
  return f;
}
    800045d4:	8526                	mv	a0,s1
    800045d6:	60e2                	ld	ra,24(sp)
    800045d8:	6442                	ld	s0,16(sp)
    800045da:	64a2                	ld	s1,8(sp)
    800045dc:	6105                	add	sp,sp,32
    800045de:	8082                	ret
    panic("filedup");
    800045e0:	00004517          	auipc	a0,0x4
    800045e4:	0f050513          	add	a0,a0,240 # 800086d0 <syscalls+0x240>
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	226080e7          	jalr	550(ra) # 8000080e <panic>

00000000800045f0 <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    800045f0:	7139                	add	sp,sp,-64
    800045f2:	fc06                	sd	ra,56(sp)
    800045f4:	f822                	sd	s0,48(sp)
    800045f6:	f426                	sd	s1,40(sp)
    800045f8:	f04a                	sd	s2,32(sp)
    800045fa:	ec4e                	sd	s3,24(sp)
    800045fc:	e852                	sd	s4,16(sp)
    800045fe:	e456                	sd	s5,8(sp)
    80004600:	0080                	add	s0,sp,64
    80004602:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004604:	0001c517          	auipc	a0,0x1c
    80004608:	54450513          	add	a0,a0,1348 # 80020b48 <ftable>
    8000460c:	ffffc097          	auipc	ra,0xffffc
    80004610:	6c0080e7          	jalr	1728(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    80004614:	40dc                	lw	a5,4(s1)
    80004616:	06f05163          	blez	a5,80004678 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000461a:	37fd                	addw	a5,a5,-1
    8000461c:	0007871b          	sext.w	a4,a5
    80004620:	c0dc                	sw	a5,4(s1)
    80004622:	06e04363          	bgtz	a4,80004688 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004626:	0004a903          	lw	s2,0(s1)
    8000462a:	0094ca83          	lbu	s5,9(s1)
    8000462e:	0104ba03          	ld	s4,16(s1)
    80004632:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004636:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000463a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000463e:	0001c517          	auipc	a0,0x1c
    80004642:	50a50513          	add	a0,a0,1290 # 80020b48 <ftable>
    80004646:	ffffc097          	auipc	ra,0xffffc
    8000464a:	73a080e7          	jalr	1850(ra) # 80000d80 <release>

  if(ff.type == FD_PIPE){
    8000464e:	4785                	li	a5,1
    80004650:	04f90d63          	beq	s2,a5,800046aa <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004654:	3979                	addw	s2,s2,-2
    80004656:	4785                	li	a5,1
    80004658:	0527e063          	bltu	a5,s2,80004698 <fileclose+0xa8>
    begin_op();
    8000465c:	00000097          	auipc	ra,0x0
    80004660:	ad0080e7          	jalr	-1328(ra) # 8000412c <begin_op>
    iput(ff.ip);
    80004664:	854e                	mv	a0,s3
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	2da080e7          	jalr	730(ra) # 80003940 <iput>
    end_op();
    8000466e:	00000097          	auipc	ra,0x0
    80004672:	b38080e7          	jalr	-1224(ra) # 800041a6 <end_op>
    80004676:	a00d                	j	80004698 <fileclose+0xa8>
    panic("fileclose");
    80004678:	00004517          	auipc	a0,0x4
    8000467c:	06050513          	add	a0,a0,96 # 800086d8 <syscalls+0x248>
    80004680:	ffffc097          	auipc	ra,0xffffc
    80004684:	18e080e7          	jalr	398(ra) # 8000080e <panic>
    release(&ftable.lock);
    80004688:	0001c517          	auipc	a0,0x1c
    8000468c:	4c050513          	add	a0,a0,1216 # 80020b48 <ftable>
    80004690:	ffffc097          	auipc	ra,0xffffc
    80004694:	6f0080e7          	jalr	1776(ra) # 80000d80 <release>
  }
}
    80004698:	70e2                	ld	ra,56(sp)
    8000469a:	7442                	ld	s0,48(sp)
    8000469c:	74a2                	ld	s1,40(sp)
    8000469e:	7902                	ld	s2,32(sp)
    800046a0:	69e2                	ld	s3,24(sp)
    800046a2:	6a42                	ld	s4,16(sp)
    800046a4:	6aa2                	ld	s5,8(sp)
    800046a6:	6121                	add	sp,sp,64
    800046a8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046aa:	85d6                	mv	a1,s5
    800046ac:	8552                	mv	a0,s4
    800046ae:	00000097          	auipc	ra,0x0
    800046b2:	348080e7          	jalr	840(ra) # 800049f6 <pipeclose>
    800046b6:	b7cd                	j	80004698 <fileclose+0xa8>

00000000800046b8 <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    800046b8:	715d                	add	sp,sp,-80
    800046ba:	e486                	sd	ra,72(sp)
    800046bc:	e0a2                	sd	s0,64(sp)
    800046be:	fc26                	sd	s1,56(sp)
    800046c0:	f84a                	sd	s2,48(sp)
    800046c2:	f44e                	sd	s3,40(sp)
    800046c4:	0880                	add	s0,sp,80
    800046c6:	84aa                	mv	s1,a0
    800046c8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046ca:	ffffd097          	auipc	ra,0xffffd
    800046ce:	42e080e7          	jalr	1070(ra) # 80001af8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046d2:	409c                	lw	a5,0(s1)
    800046d4:	37f9                	addw	a5,a5,-2
    800046d6:	4705                	li	a4,1
    800046d8:	04f76763          	bltu	a4,a5,80004726 <filestat+0x6e>
    800046dc:	892a                	mv	s2,a0
    ilock(f->ip);
    800046de:	6c88                	ld	a0,24(s1)
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	0a6080e7          	jalr	166(ra) # 80003786 <ilock>
    stati(f->ip, &st);
    800046e8:	fb840593          	add	a1,s0,-72
    800046ec:	6c88                	ld	a0,24(s1)
    800046ee:	fffff097          	auipc	ra,0xfffff
    800046f2:	322080e7          	jalr	802(ra) # 80003a10 <stati>
    iunlock(f->ip);
    800046f6:	6c88                	ld	a0,24(s1)
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	150080e7          	jalr	336(ra) # 80003848 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004700:	46e1                	li	a3,24
    80004702:	fb840613          	add	a2,s0,-72
    80004706:	85ce                	mv	a1,s3
    80004708:	05093503          	ld	a0,80(s2)
    8000470c:	ffffd097          	auipc	ra,0xffffd
    80004710:	078080e7          	jalr	120(ra) # 80001784 <copyout>
    80004714:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004718:	60a6                	ld	ra,72(sp)
    8000471a:	6406                	ld	s0,64(sp)
    8000471c:	74e2                	ld	s1,56(sp)
    8000471e:	7942                	ld	s2,48(sp)
    80004720:	79a2                	ld	s3,40(sp)
    80004722:	6161                	add	sp,sp,80
    80004724:	8082                	ret
  return -1;
    80004726:	557d                	li	a0,-1
    80004728:	bfc5                	j	80004718 <filestat+0x60>

000000008000472a <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    8000472a:	7179                	add	sp,sp,-48
    8000472c:	f406                	sd	ra,40(sp)
    8000472e:	f022                	sd	s0,32(sp)
    80004730:	ec26                	sd	s1,24(sp)
    80004732:	e84a                	sd	s2,16(sp)
    80004734:	e44e                	sd	s3,8(sp)
    80004736:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004738:	00854783          	lbu	a5,8(a0)
    8000473c:	c3d5                	beqz	a5,800047e0 <fileread+0xb6>
    8000473e:	84aa                	mv	s1,a0
    80004740:	89ae                	mv	s3,a1
    80004742:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004744:	411c                	lw	a5,0(a0)
    80004746:	4705                	li	a4,1
    80004748:	04e78963          	beq	a5,a4,8000479a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000474c:	470d                	li	a4,3
    8000474e:	04e78d63          	beq	a5,a4,800047a8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004752:	4709                	li	a4,2
    80004754:	06e79e63          	bne	a5,a4,800047d0 <fileread+0xa6>
    ilock(f->ip);
    80004758:	6d08                	ld	a0,24(a0)
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	02c080e7          	jalr	44(ra) # 80003786 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004762:	874a                	mv	a4,s2
    80004764:	5094                	lw	a3,32(s1)
    80004766:	864e                	mv	a2,s3
    80004768:	4585                	li	a1,1
    8000476a:	6c88                	ld	a0,24(s1)
    8000476c:	fffff097          	auipc	ra,0xfffff
    80004770:	2ce080e7          	jalr	718(ra) # 80003a3a <readi>
    80004774:	892a                	mv	s2,a0
    80004776:	00a05563          	blez	a0,80004780 <fileread+0x56>
      f->off += r;
    8000477a:	509c                	lw	a5,32(s1)
    8000477c:	9fa9                	addw	a5,a5,a0
    8000477e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004780:	6c88                	ld	a0,24(s1)
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	0c6080e7          	jalr	198(ra) # 80003848 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000478a:	854a                	mv	a0,s2
    8000478c:	70a2                	ld	ra,40(sp)
    8000478e:	7402                	ld	s0,32(sp)
    80004790:	64e2                	ld	s1,24(sp)
    80004792:	6942                	ld	s2,16(sp)
    80004794:	69a2                	ld	s3,8(sp)
    80004796:	6145                	add	sp,sp,48
    80004798:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000479a:	6908                	ld	a0,16(a0)
    8000479c:	00000097          	auipc	ra,0x0
    800047a0:	3c2080e7          	jalr	962(ra) # 80004b5e <piperead>
    800047a4:	892a                	mv	s2,a0
    800047a6:	b7d5                	j	8000478a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800047a8:	02451783          	lh	a5,36(a0)
    800047ac:	03079693          	sll	a3,a5,0x30
    800047b0:	92c1                	srl	a3,a3,0x30
    800047b2:	4725                	li	a4,9
    800047b4:	02d76863          	bltu	a4,a3,800047e4 <fileread+0xba>
    800047b8:	0792                	sll	a5,a5,0x4
    800047ba:	0001c717          	auipc	a4,0x1c
    800047be:	2ee70713          	add	a4,a4,750 # 80020aa8 <devsw>
    800047c2:	97ba                	add	a5,a5,a4
    800047c4:	639c                	ld	a5,0(a5)
    800047c6:	c38d                	beqz	a5,800047e8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047c8:	4505                	li	a0,1
    800047ca:	9782                	jalr	a5
    800047cc:	892a                	mv	s2,a0
    800047ce:	bf75                	j	8000478a <fileread+0x60>
    panic("fileread");
    800047d0:	00004517          	auipc	a0,0x4
    800047d4:	f1850513          	add	a0,a0,-232 # 800086e8 <syscalls+0x258>
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	036080e7          	jalr	54(ra) # 8000080e <panic>
    return -1;
    800047e0:	597d                	li	s2,-1
    800047e2:	b765                	j	8000478a <fileread+0x60>
      return -1;
    800047e4:	597d                	li	s2,-1
    800047e6:	b755                	j	8000478a <fileread+0x60>
    800047e8:	597d                	li	s2,-1
    800047ea:	b745                	j	8000478a <fileread+0x60>

00000000800047ec <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800047ec:	00954783          	lbu	a5,9(a0)
    800047f0:	10078e63          	beqz	a5,8000490c <filewrite+0x120>
{
    800047f4:	715d                	add	sp,sp,-80
    800047f6:	e486                	sd	ra,72(sp)
    800047f8:	e0a2                	sd	s0,64(sp)
    800047fa:	fc26                	sd	s1,56(sp)
    800047fc:	f84a                	sd	s2,48(sp)
    800047fe:	f44e                	sd	s3,40(sp)
    80004800:	f052                	sd	s4,32(sp)
    80004802:	ec56                	sd	s5,24(sp)
    80004804:	e85a                	sd	s6,16(sp)
    80004806:	e45e                	sd	s7,8(sp)
    80004808:	e062                	sd	s8,0(sp)
    8000480a:	0880                	add	s0,sp,80
    8000480c:	892a                	mv	s2,a0
    8000480e:	8b2e                	mv	s6,a1
    80004810:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004812:	411c                	lw	a5,0(a0)
    80004814:	4705                	li	a4,1
    80004816:	02e78263          	beq	a5,a4,8000483a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000481a:	470d                	li	a4,3
    8000481c:	02e78563          	beq	a5,a4,80004846 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004820:	4709                	li	a4,2
    80004822:	0ce79d63          	bne	a5,a4,800048fc <filewrite+0x110>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004826:	0ac05b63          	blez	a2,800048dc <filewrite+0xf0>
    int i = 0;
    8000482a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000482c:	6b85                	lui	s7,0x1
    8000482e:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004832:	6c05                	lui	s8,0x1
    80004834:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004838:	a851                	j	800048cc <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    8000483a:	6908                	ld	a0,16(a0)
    8000483c:	00000097          	auipc	ra,0x0
    80004840:	22a080e7          	jalr	554(ra) # 80004a66 <pipewrite>
    80004844:	a045                	j	800048e4 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004846:	02451783          	lh	a5,36(a0)
    8000484a:	03079693          	sll	a3,a5,0x30
    8000484e:	92c1                	srl	a3,a3,0x30
    80004850:	4725                	li	a4,9
    80004852:	0ad76f63          	bltu	a4,a3,80004910 <filewrite+0x124>
    80004856:	0792                	sll	a5,a5,0x4
    80004858:	0001c717          	auipc	a4,0x1c
    8000485c:	25070713          	add	a4,a4,592 # 80020aa8 <devsw>
    80004860:	97ba                	add	a5,a5,a4
    80004862:	679c                	ld	a5,8(a5)
    80004864:	cbc5                	beqz	a5,80004914 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004866:	4505                	li	a0,1
    80004868:	9782                	jalr	a5
    8000486a:	a8ad                	j	800048e4 <filewrite+0xf8>
      if(n1 > max)
    8000486c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004870:	00000097          	auipc	ra,0x0
    80004874:	8bc080e7          	jalr	-1860(ra) # 8000412c <begin_op>
      ilock(f->ip);
    80004878:	01893503          	ld	a0,24(s2)
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	f0a080e7          	jalr	-246(ra) # 80003786 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004884:	8756                	mv	a4,s5
    80004886:	02092683          	lw	a3,32(s2)
    8000488a:	01698633          	add	a2,s3,s6
    8000488e:	4585                	li	a1,1
    80004890:	01893503          	ld	a0,24(s2)
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	29e080e7          	jalr	670(ra) # 80003b32 <writei>
    8000489c:	84aa                	mv	s1,a0
    8000489e:	00a05763          	blez	a0,800048ac <filewrite+0xc0>
        f->off += r;
    800048a2:	02092783          	lw	a5,32(s2)
    800048a6:	9fa9                	addw	a5,a5,a0
    800048a8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800048ac:	01893503          	ld	a0,24(s2)
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	f98080e7          	jalr	-104(ra) # 80003848 <iunlock>
      end_op();
    800048b8:	00000097          	auipc	ra,0x0
    800048bc:	8ee080e7          	jalr	-1810(ra) # 800041a6 <end_op>

      if(r != n1){
    800048c0:	009a9f63          	bne	s5,s1,800048de <filewrite+0xf2>
        /* error from writei */
        break;
      }
      i += r;
    800048c4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048c8:	0149db63          	bge	s3,s4,800048de <filewrite+0xf2>
      int n1 = n - i;
    800048cc:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800048d0:	0004879b          	sext.w	a5,s1
    800048d4:	f8fbdce3          	bge	s7,a5,8000486c <filewrite+0x80>
    800048d8:	84e2                	mv	s1,s8
    800048da:	bf49                	j	8000486c <filewrite+0x80>
    int i = 0;
    800048dc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048de:	033a1d63          	bne	s4,s3,80004918 <filewrite+0x12c>
    800048e2:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048e4:	60a6                	ld	ra,72(sp)
    800048e6:	6406                	ld	s0,64(sp)
    800048e8:	74e2                	ld	s1,56(sp)
    800048ea:	7942                	ld	s2,48(sp)
    800048ec:	79a2                	ld	s3,40(sp)
    800048ee:	7a02                	ld	s4,32(sp)
    800048f0:	6ae2                	ld	s5,24(sp)
    800048f2:	6b42                	ld	s6,16(sp)
    800048f4:	6ba2                	ld	s7,8(sp)
    800048f6:	6c02                	ld	s8,0(sp)
    800048f8:	6161                	add	sp,sp,80
    800048fa:	8082                	ret
    panic("filewrite");
    800048fc:	00004517          	auipc	a0,0x4
    80004900:	dfc50513          	add	a0,a0,-516 # 800086f8 <syscalls+0x268>
    80004904:	ffffc097          	auipc	ra,0xffffc
    80004908:	f0a080e7          	jalr	-246(ra) # 8000080e <panic>
    return -1;
    8000490c:	557d                	li	a0,-1
}
    8000490e:	8082                	ret
      return -1;
    80004910:	557d                	li	a0,-1
    80004912:	bfc9                	j	800048e4 <filewrite+0xf8>
    80004914:	557d                	li	a0,-1
    80004916:	b7f9                	j	800048e4 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80004918:	557d                	li	a0,-1
    8000491a:	b7e9                	j	800048e4 <filewrite+0xf8>

000000008000491c <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000491c:	7179                	add	sp,sp,-48
    8000491e:	f406                	sd	ra,40(sp)
    80004920:	f022                	sd	s0,32(sp)
    80004922:	ec26                	sd	s1,24(sp)
    80004924:	e84a                	sd	s2,16(sp)
    80004926:	e44e                	sd	s3,8(sp)
    80004928:	e052                	sd	s4,0(sp)
    8000492a:	1800                	add	s0,sp,48
    8000492c:	84aa                	mv	s1,a0
    8000492e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004930:	0005b023          	sd	zero,0(a1)
    80004934:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	bfc080e7          	jalr	-1028(ra) # 80004534 <filealloc>
    80004940:	e088                	sd	a0,0(s1)
    80004942:	c551                	beqz	a0,800049ce <pipealloc+0xb2>
    80004944:	00000097          	auipc	ra,0x0
    80004948:	bf0080e7          	jalr	-1040(ra) # 80004534 <filealloc>
    8000494c:	00aa3023          	sd	a0,0(s4)
    80004950:	c92d                	beqz	a0,800049c2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	28a080e7          	jalr	650(ra) # 80000bdc <kalloc>
    8000495a:	892a                	mv	s2,a0
    8000495c:	c125                	beqz	a0,800049bc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000495e:	4985                	li	s3,1
    80004960:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004964:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004968:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000496c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004970:	00004597          	auipc	a1,0x4
    80004974:	d9858593          	add	a1,a1,-616 # 80008708 <syscalls+0x278>
    80004978:	ffffc097          	auipc	ra,0xffffc
    8000497c:	2c4080e7          	jalr	708(ra) # 80000c3c <initlock>
  (*f0)->type = FD_PIPE;
    80004980:	609c                	ld	a5,0(s1)
    80004982:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004986:	609c                	ld	a5,0(s1)
    80004988:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000498c:	609c                	ld	a5,0(s1)
    8000498e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004992:	609c                	ld	a5,0(s1)
    80004994:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004998:	000a3783          	ld	a5,0(s4)
    8000499c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049a0:	000a3783          	ld	a5,0(s4)
    800049a4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049a8:	000a3783          	ld	a5,0(s4)
    800049ac:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049b0:	000a3783          	ld	a5,0(s4)
    800049b4:	0127b823          	sd	s2,16(a5)
  return 0;
    800049b8:	4501                	li	a0,0
    800049ba:	a025                	j	800049e2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049bc:	6088                	ld	a0,0(s1)
    800049be:	e501                	bnez	a0,800049c6 <pipealloc+0xaa>
    800049c0:	a039                	j	800049ce <pipealloc+0xb2>
    800049c2:	6088                	ld	a0,0(s1)
    800049c4:	c51d                	beqz	a0,800049f2 <pipealloc+0xd6>
    fileclose(*f0);
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	c2a080e7          	jalr	-982(ra) # 800045f0 <fileclose>
  if(*f1)
    800049ce:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049d2:	557d                	li	a0,-1
  if(*f1)
    800049d4:	c799                	beqz	a5,800049e2 <pipealloc+0xc6>
    fileclose(*f1);
    800049d6:	853e                	mv	a0,a5
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	c18080e7          	jalr	-1000(ra) # 800045f0 <fileclose>
  return -1;
    800049e0:	557d                	li	a0,-1
}
    800049e2:	70a2                	ld	ra,40(sp)
    800049e4:	7402                	ld	s0,32(sp)
    800049e6:	64e2                	ld	s1,24(sp)
    800049e8:	6942                	ld	s2,16(sp)
    800049ea:	69a2                	ld	s3,8(sp)
    800049ec:	6a02                	ld	s4,0(sp)
    800049ee:	6145                	add	sp,sp,48
    800049f0:	8082                	ret
  return -1;
    800049f2:	557d                	li	a0,-1
    800049f4:	b7fd                	j	800049e2 <pipealloc+0xc6>

00000000800049f6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049f6:	1101                	add	sp,sp,-32
    800049f8:	ec06                	sd	ra,24(sp)
    800049fa:	e822                	sd	s0,16(sp)
    800049fc:	e426                	sd	s1,8(sp)
    800049fe:	e04a                	sd	s2,0(sp)
    80004a00:	1000                	add	s0,sp,32
    80004a02:	84aa                	mv	s1,a0
    80004a04:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a06:	ffffc097          	auipc	ra,0xffffc
    80004a0a:	2c6080e7          	jalr	710(ra) # 80000ccc <acquire>
  if(writable){
    80004a0e:	02090d63          	beqz	s2,80004a48 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a12:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a16:	21848513          	add	a0,s1,536
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	80e080e7          	jalr	-2034(ra) # 80002228 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a22:	2204b783          	ld	a5,544(s1)
    80004a26:	eb95                	bnez	a5,80004a5a <pipeclose+0x64>
    release(&pi->lock);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	356080e7          	jalr	854(ra) # 80000d80 <release>
    kfree((char*)pi);
    80004a32:	8526                	mv	a0,s1
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	0aa080e7          	jalr	170(ra) # 80000ade <kfree>
  } else
    release(&pi->lock);
}
    80004a3c:	60e2                	ld	ra,24(sp)
    80004a3e:	6442                	ld	s0,16(sp)
    80004a40:	64a2                	ld	s1,8(sp)
    80004a42:	6902                	ld	s2,0(sp)
    80004a44:	6105                	add	sp,sp,32
    80004a46:	8082                	ret
    pi->readopen = 0;
    80004a48:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a4c:	21c48513          	add	a0,s1,540
    80004a50:	ffffd097          	auipc	ra,0xffffd
    80004a54:	7d8080e7          	jalr	2008(ra) # 80002228 <wakeup>
    80004a58:	b7e9                	j	80004a22 <pipeclose+0x2c>
    release(&pi->lock);
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffc097          	auipc	ra,0xffffc
    80004a60:	324080e7          	jalr	804(ra) # 80000d80 <release>
}
    80004a64:	bfe1                	j	80004a3c <pipeclose+0x46>

0000000080004a66 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a66:	711d                	add	sp,sp,-96
    80004a68:	ec86                	sd	ra,88(sp)
    80004a6a:	e8a2                	sd	s0,80(sp)
    80004a6c:	e4a6                	sd	s1,72(sp)
    80004a6e:	e0ca                	sd	s2,64(sp)
    80004a70:	fc4e                	sd	s3,56(sp)
    80004a72:	f852                	sd	s4,48(sp)
    80004a74:	f456                	sd	s5,40(sp)
    80004a76:	f05a                	sd	s6,32(sp)
    80004a78:	ec5e                	sd	s7,24(sp)
    80004a7a:	e862                	sd	s8,16(sp)
    80004a7c:	1080                	add	s0,sp,96
    80004a7e:	84aa                	mv	s1,a0
    80004a80:	8aae                	mv	s5,a1
    80004a82:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004a84:	ffffd097          	auipc	ra,0xffffd
    80004a88:	074080e7          	jalr	116(ra) # 80001af8 <myproc>
    80004a8c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a8e:	8526                	mv	a0,s1
    80004a90:	ffffc097          	auipc	ra,0xffffc
    80004a94:	23c080e7          	jalr	572(ra) # 80000ccc <acquire>
  while(i < n){
    80004a98:	0b405663          	blez	s4,80004b44 <pipewrite+0xde>
  int i = 0;
    80004a9c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a9e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004aa0:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004aa4:	21c48b93          	add	s7,s1,540
    80004aa8:	a089                	j	80004aea <pipewrite+0x84>
      release(&pi->lock);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	2d4080e7          	jalr	724(ra) # 80000d80 <release>
      return -1;
    80004ab4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004ab6:	854a                	mv	a0,s2
    80004ab8:	60e6                	ld	ra,88(sp)
    80004aba:	6446                	ld	s0,80(sp)
    80004abc:	64a6                	ld	s1,72(sp)
    80004abe:	6906                	ld	s2,64(sp)
    80004ac0:	79e2                	ld	s3,56(sp)
    80004ac2:	7a42                	ld	s4,48(sp)
    80004ac4:	7aa2                	ld	s5,40(sp)
    80004ac6:	7b02                	ld	s6,32(sp)
    80004ac8:	6be2                	ld	s7,24(sp)
    80004aca:	6c42                	ld	s8,16(sp)
    80004acc:	6125                	add	sp,sp,96
    80004ace:	8082                	ret
      wakeup(&pi->nread);
    80004ad0:	8562                	mv	a0,s8
    80004ad2:	ffffd097          	auipc	ra,0xffffd
    80004ad6:	756080e7          	jalr	1878(ra) # 80002228 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ada:	85a6                	mv	a1,s1
    80004adc:	855e                	mv	a0,s7
    80004ade:	ffffd097          	auipc	ra,0xffffd
    80004ae2:	6e6080e7          	jalr	1766(ra) # 800021c4 <sleep>
  while(i < n){
    80004ae6:	07495063          	bge	s2,s4,80004b46 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004aea:	2204a783          	lw	a5,544(s1)
    80004aee:	dfd5                	beqz	a5,80004aaa <pipewrite+0x44>
    80004af0:	854e                	mv	a0,s3
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	97a080e7          	jalr	-1670(ra) # 8000246c <killed>
    80004afa:	f945                	bnez	a0,80004aaa <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    80004afc:	2184a783          	lw	a5,536(s1)
    80004b00:	21c4a703          	lw	a4,540(s1)
    80004b04:	2007879b          	addw	a5,a5,512
    80004b08:	fcf704e3          	beq	a4,a5,80004ad0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b0c:	4685                	li	a3,1
    80004b0e:	01590633          	add	a2,s2,s5
    80004b12:	faf40593          	add	a1,s0,-81
    80004b16:	0509b503          	ld	a0,80(s3)
    80004b1a:	ffffd097          	auipc	ra,0xffffd
    80004b1e:	d2a080e7          	jalr	-726(ra) # 80001844 <copyin>
    80004b22:	03650263          	beq	a0,s6,80004b46 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b26:	21c4a783          	lw	a5,540(s1)
    80004b2a:	0017871b          	addw	a4,a5,1
    80004b2e:	20e4ae23          	sw	a4,540(s1)
    80004b32:	1ff7f793          	and	a5,a5,511
    80004b36:	97a6                	add	a5,a5,s1
    80004b38:	faf44703          	lbu	a4,-81(s0)
    80004b3c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b40:	2905                	addw	s2,s2,1
    80004b42:	b755                	j	80004ae6 <pipewrite+0x80>
  int i = 0;
    80004b44:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b46:	21848513          	add	a0,s1,536
    80004b4a:	ffffd097          	auipc	ra,0xffffd
    80004b4e:	6de080e7          	jalr	1758(ra) # 80002228 <wakeup>
  release(&pi->lock);
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffc097          	auipc	ra,0xffffc
    80004b58:	22c080e7          	jalr	556(ra) # 80000d80 <release>
  return i;
    80004b5c:	bfa9                	j	80004ab6 <pipewrite+0x50>

0000000080004b5e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b5e:	715d                	add	sp,sp,-80
    80004b60:	e486                	sd	ra,72(sp)
    80004b62:	e0a2                	sd	s0,64(sp)
    80004b64:	fc26                	sd	s1,56(sp)
    80004b66:	f84a                	sd	s2,48(sp)
    80004b68:	f44e                	sd	s3,40(sp)
    80004b6a:	f052                	sd	s4,32(sp)
    80004b6c:	ec56                	sd	s5,24(sp)
    80004b6e:	e85a                	sd	s6,16(sp)
    80004b70:	0880                	add	s0,sp,80
    80004b72:	84aa                	mv	s1,a0
    80004b74:	892e                	mv	s2,a1
    80004b76:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b78:	ffffd097          	auipc	ra,0xffffd
    80004b7c:	f80080e7          	jalr	-128(ra) # 80001af8 <myproc>
    80004b80:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b82:	8526                	mv	a0,s1
    80004b84:	ffffc097          	auipc	ra,0xffffc
    80004b88:	148080e7          	jalr	328(ra) # 80000ccc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004b8c:	2184a703          	lw	a4,536(s1)
    80004b90:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004b94:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004b98:	02f71763          	bne	a4,a5,80004bc6 <piperead+0x68>
    80004b9c:	2244a783          	lw	a5,548(s1)
    80004ba0:	c39d                	beqz	a5,80004bc6 <piperead+0x68>
    if(killed(pr)){
    80004ba2:	8552                	mv	a0,s4
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	8c8080e7          	jalr	-1848(ra) # 8000246c <killed>
    80004bac:	e949                	bnez	a0,80004c3e <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004bae:	85a6                	mv	a1,s1
    80004bb0:	854e                	mv	a0,s3
    80004bb2:	ffffd097          	auipc	ra,0xffffd
    80004bb6:	612080e7          	jalr	1554(ra) # 800021c4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004bba:	2184a703          	lw	a4,536(s1)
    80004bbe:	21c4a783          	lw	a5,540(s1)
    80004bc2:	fcf70de3          	beq	a4,a5,80004b9c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004bc6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bc8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004bca:	05505463          	blez	s5,80004c12 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004bce:	2184a783          	lw	a5,536(s1)
    80004bd2:	21c4a703          	lw	a4,540(s1)
    80004bd6:	02f70e63          	beq	a4,a5,80004c12 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004bda:	0017871b          	addw	a4,a5,1
    80004bde:	20e4ac23          	sw	a4,536(s1)
    80004be2:	1ff7f793          	and	a5,a5,511
    80004be6:	97a6                	add	a5,a5,s1
    80004be8:	0187c783          	lbu	a5,24(a5)
    80004bec:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bf0:	4685                	li	a3,1
    80004bf2:	fbf40613          	add	a2,s0,-65
    80004bf6:	85ca                	mv	a1,s2
    80004bf8:	050a3503          	ld	a0,80(s4)
    80004bfc:	ffffd097          	auipc	ra,0xffffd
    80004c00:	b88080e7          	jalr	-1144(ra) # 80001784 <copyout>
    80004c04:	01650763          	beq	a0,s6,80004c12 <piperead+0xb4>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004c08:	2985                	addw	s3,s3,1
    80004c0a:	0905                	add	s2,s2,1
    80004c0c:	fd3a91e3          	bne	s5,s3,80004bce <piperead+0x70>
    80004c10:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    80004c12:	21c48513          	add	a0,s1,540
    80004c16:	ffffd097          	auipc	ra,0xffffd
    80004c1a:	612080e7          	jalr	1554(ra) # 80002228 <wakeup>
  release(&pi->lock);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffc097          	auipc	ra,0xffffc
    80004c24:	160080e7          	jalr	352(ra) # 80000d80 <release>
  return i;
}
    80004c28:	854e                	mv	a0,s3
    80004c2a:	60a6                	ld	ra,72(sp)
    80004c2c:	6406                	ld	s0,64(sp)
    80004c2e:	74e2                	ld	s1,56(sp)
    80004c30:	7942                	ld	s2,48(sp)
    80004c32:	79a2                	ld	s3,40(sp)
    80004c34:	7a02                	ld	s4,32(sp)
    80004c36:	6ae2                	ld	s5,24(sp)
    80004c38:	6b42                	ld	s6,16(sp)
    80004c3a:	6161                	add	sp,sp,80
    80004c3c:	8082                	ret
      release(&pi->lock);
    80004c3e:	8526                	mv	a0,s1
    80004c40:	ffffc097          	auipc	ra,0xffffc
    80004c44:	140080e7          	jalr	320(ra) # 80000d80 <release>
      return -1;
    80004c48:	59fd                	li	s3,-1
    80004c4a:	bff9                	j	80004c28 <piperead+0xca>

0000000080004c4c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004c4c:	1141                	add	sp,sp,-16
    80004c4e:	e422                	sd	s0,8(sp)
    80004c50:	0800                	add	s0,sp,16
    80004c52:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004c54:	8905                	and	a0,a0,1
    80004c56:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004c58:	8b89                	and	a5,a5,2
    80004c5a:	c399                	beqz	a5,80004c60 <flags2perm+0x14>
      perm |= PTE_W;
    80004c5c:	00456513          	or	a0,a0,4
    return perm;
}
    80004c60:	6422                	ld	s0,8(sp)
    80004c62:	0141                	add	sp,sp,16
    80004c64:	8082                	ret

0000000080004c66 <exec>:

int
exec(char *path, char **argv)
{
    80004c66:	df010113          	add	sp,sp,-528
    80004c6a:	20113423          	sd	ra,520(sp)
    80004c6e:	20813023          	sd	s0,512(sp)
    80004c72:	ffa6                	sd	s1,504(sp)
    80004c74:	fbca                	sd	s2,496(sp)
    80004c76:	f7ce                	sd	s3,488(sp)
    80004c78:	f3d2                	sd	s4,480(sp)
    80004c7a:	efd6                	sd	s5,472(sp)
    80004c7c:	ebda                	sd	s6,464(sp)
    80004c7e:	e7de                	sd	s7,456(sp)
    80004c80:	e3e2                	sd	s8,448(sp)
    80004c82:	ff66                	sd	s9,440(sp)
    80004c84:	fb6a                	sd	s10,432(sp)
    80004c86:	f76e                	sd	s11,424(sp)
    80004c88:	0c00                	add	s0,sp,528
    80004c8a:	892a                	mv	s2,a0
    80004c8c:	dea43c23          	sd	a0,-520(s0)
    80004c90:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c94:	ffffd097          	auipc	ra,0xffffd
    80004c98:	e64080e7          	jalr	-412(ra) # 80001af8 <myproc>
    80004c9c:	84aa                	mv	s1,a0

  begin_op();
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	48e080e7          	jalr	1166(ra) # 8000412c <begin_op>

  if((ip = namei(path)) == 0){
    80004ca6:	854a                	mv	a0,s2
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	284080e7          	jalr	644(ra) # 80003f2c <namei>
    80004cb0:	c92d                	beqz	a0,80004d22 <exec+0xbc>
    80004cb2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	ad2080e7          	jalr	-1326(ra) # 80003786 <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004cbc:	04000713          	li	a4,64
    80004cc0:	4681                	li	a3,0
    80004cc2:	e5040613          	add	a2,s0,-432
    80004cc6:	4581                	li	a1,0
    80004cc8:	8552                	mv	a0,s4
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	d70080e7          	jalr	-656(ra) # 80003a3a <readi>
    80004cd2:	04000793          	li	a5,64
    80004cd6:	00f51a63          	bne	a0,a5,80004cea <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004cda:	e5042703          	lw	a4,-432(s0)
    80004cde:	464c47b7          	lui	a5,0x464c4
    80004ce2:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ce6:	04f70463          	beq	a4,a5,80004d2e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004cea:	8552                	mv	a0,s4
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	cfc080e7          	jalr	-772(ra) # 800039e8 <iunlockput>
    end_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	4b2080e7          	jalr	1202(ra) # 800041a6 <end_op>
  }
  return -1;
    80004cfc:	557d                	li	a0,-1
}
    80004cfe:	20813083          	ld	ra,520(sp)
    80004d02:	20013403          	ld	s0,512(sp)
    80004d06:	74fe                	ld	s1,504(sp)
    80004d08:	795e                	ld	s2,496(sp)
    80004d0a:	79be                	ld	s3,488(sp)
    80004d0c:	7a1e                	ld	s4,480(sp)
    80004d0e:	6afe                	ld	s5,472(sp)
    80004d10:	6b5e                	ld	s6,464(sp)
    80004d12:	6bbe                	ld	s7,456(sp)
    80004d14:	6c1e                	ld	s8,448(sp)
    80004d16:	7cfa                	ld	s9,440(sp)
    80004d18:	7d5a                	ld	s10,432(sp)
    80004d1a:	7dba                	ld	s11,424(sp)
    80004d1c:	21010113          	add	sp,sp,528
    80004d20:	8082                	ret
    end_op();
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	484080e7          	jalr	1156(ra) # 800041a6 <end_op>
    return -1;
    80004d2a:	557d                	li	a0,-1
    80004d2c:	bfc9                	j	80004cfe <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d2e:	8526                	mv	a0,s1
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	e90080e7          	jalr	-368(ra) # 80001bc0 <proc_pagetable>
    80004d38:	8b2a                	mv	s6,a0
    80004d3a:	d945                	beqz	a0,80004cea <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d3c:	e7042d03          	lw	s10,-400(s0)
    80004d40:	e8845783          	lhu	a5,-376(s0)
    80004d44:	10078463          	beqz	a5,80004e4c <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d48:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d4a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004d4c:	6c85                	lui	s9,0x1
    80004d4e:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004d52:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004d56:	6a85                	lui	s5,0x1
    80004d58:	a0b5                	j	80004dc4 <exec+0x15e>
      panic("loadseg: address should exist");
    80004d5a:	00004517          	auipc	a0,0x4
    80004d5e:	9b650513          	add	a0,a0,-1610 # 80008710 <syscalls+0x280>
    80004d62:	ffffc097          	auipc	ra,0xffffc
    80004d66:	aac080e7          	jalr	-1364(ra) # 8000080e <panic>
    if(sz - i < PGSIZE)
    80004d6a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d6c:	8726                	mv	a4,s1
    80004d6e:	012c06bb          	addw	a3,s8,s2
    80004d72:	4581                	li	a1,0
    80004d74:	8552                	mv	a0,s4
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	cc4080e7          	jalr	-828(ra) # 80003a3a <readi>
    80004d7e:	2501                	sext.w	a0,a0
    80004d80:	24a49863          	bne	s1,a0,80004fd0 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004d84:	012a893b          	addw	s2,s5,s2
    80004d88:	03397563          	bgeu	s2,s3,80004db2 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004d8c:	02091593          	sll	a1,s2,0x20
    80004d90:	9181                	srl	a1,a1,0x20
    80004d92:	95de                	add	a1,a1,s7
    80004d94:	855a                	mv	a0,s6
    80004d96:	ffffc097          	auipc	ra,0xffffc
    80004d9a:	3ba080e7          	jalr	954(ra) # 80001150 <walkaddr>
    80004d9e:	862a                	mv	a2,a0
    if(pa == 0)
    80004da0:	dd4d                	beqz	a0,80004d5a <exec+0xf4>
    if(sz - i < PGSIZE)
    80004da2:	412984bb          	subw	s1,s3,s2
    80004da6:	0004879b          	sext.w	a5,s1
    80004daa:	fcfcf0e3          	bgeu	s9,a5,80004d6a <exec+0x104>
    80004dae:	84d6                	mv	s1,s5
    80004db0:	bf6d                	j	80004d6a <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004db2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004db6:	2d85                	addw	s11,s11,1
    80004db8:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004dbc:	e8845783          	lhu	a5,-376(s0)
    80004dc0:	08fdd763          	bge	s11,a5,80004e4e <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004dc4:	2d01                	sext.w	s10,s10
    80004dc6:	03800713          	li	a4,56
    80004dca:	86ea                	mv	a3,s10
    80004dcc:	e1840613          	add	a2,s0,-488
    80004dd0:	4581                	li	a1,0
    80004dd2:	8552                	mv	a0,s4
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	c66080e7          	jalr	-922(ra) # 80003a3a <readi>
    80004ddc:	03800793          	li	a5,56
    80004de0:	1ef51663          	bne	a0,a5,80004fcc <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004de4:	e1842783          	lw	a5,-488(s0)
    80004de8:	4705                	li	a4,1
    80004dea:	fce796e3          	bne	a5,a4,80004db6 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004dee:	e4043483          	ld	s1,-448(s0)
    80004df2:	e3843783          	ld	a5,-456(s0)
    80004df6:	1ef4e863          	bltu	s1,a5,80004fe6 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004dfa:	e2843783          	ld	a5,-472(s0)
    80004dfe:	94be                	add	s1,s1,a5
    80004e00:	1ef4e663          	bltu	s1,a5,80004fec <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004e04:	df043703          	ld	a4,-528(s0)
    80004e08:	8ff9                	and	a5,a5,a4
    80004e0a:	1e079463          	bnez	a5,80004ff2 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e0e:	e1c42503          	lw	a0,-484(s0)
    80004e12:	00000097          	auipc	ra,0x0
    80004e16:	e3a080e7          	jalr	-454(ra) # 80004c4c <flags2perm>
    80004e1a:	86aa                	mv	a3,a0
    80004e1c:	8626                	mv	a2,s1
    80004e1e:	85ca                	mv	a1,s2
    80004e20:	855a                	mv	a0,s6
    80004e22:	ffffc097          	auipc	ra,0xffffc
    80004e26:	706080e7          	jalr	1798(ra) # 80001528 <uvmalloc>
    80004e2a:	e0a43423          	sd	a0,-504(s0)
    80004e2e:	1c050563          	beqz	a0,80004ff8 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004e32:	e2843b83          	ld	s7,-472(s0)
    80004e36:	e2042c03          	lw	s8,-480(s0)
    80004e3a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004e3e:	00098463          	beqz	s3,80004e46 <exec+0x1e0>
    80004e42:	4901                	li	s2,0
    80004e44:	b7a1                	j	80004d8c <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e46:	e0843903          	ld	s2,-504(s0)
    80004e4a:	b7b5                	j	80004db6 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e4c:	4901                	li	s2,0
  iunlockput(ip);
    80004e4e:	8552                	mv	a0,s4
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	b98080e7          	jalr	-1128(ra) # 800039e8 <iunlockput>
  end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	34e080e7          	jalr	846(ra) # 800041a6 <end_op>
  p = myproc();
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	c98080e7          	jalr	-872(ra) # 80001af8 <myproc>
    80004e68:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004e6a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004e6e:	6985                	lui	s3,0x1
    80004e70:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004e72:	99ca                	add	s3,s3,s2
    80004e74:	77fd                	lui	a5,0xfffff
    80004e76:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004e7a:	4691                	li	a3,4
    80004e7c:	6609                	lui	a2,0x2
    80004e7e:	964e                	add	a2,a2,s3
    80004e80:	85ce                	mv	a1,s3
    80004e82:	855a                	mv	a0,s6
    80004e84:	ffffc097          	auipc	ra,0xffffc
    80004e88:	6a4080e7          	jalr	1700(ra) # 80001528 <uvmalloc>
    80004e8c:	892a                	mv	s2,a0
    80004e8e:	e0a43423          	sd	a0,-504(s0)
    80004e92:	e509                	bnez	a0,80004e9c <exec+0x236>
  if(pagetable)
    80004e94:	e1343423          	sd	s3,-504(s0)
    80004e98:	4a01                	li	s4,0
    80004e9a:	aa1d                	j	80004fd0 <exec+0x36a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004e9c:	75f9                	lui	a1,0xffffe
    80004e9e:	95aa                	add	a1,a1,a0
    80004ea0:	855a                	mv	a0,s6
    80004ea2:	ffffd097          	auipc	ra,0xffffd
    80004ea6:	8b0080e7          	jalr	-1872(ra) # 80001752 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004eaa:	7bfd                	lui	s7,0xfffff
    80004eac:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004eae:	e0043783          	ld	a5,-512(s0)
    80004eb2:	6388                	ld	a0,0(a5)
    80004eb4:	c52d                	beqz	a0,80004f1e <exec+0x2b8>
    80004eb6:	e9040993          	add	s3,s0,-368
    80004eba:	f9040c13          	add	s8,s0,-112
    80004ebe:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004ec0:	ffffc097          	auipc	ra,0xffffc
    80004ec4:	082080e7          	jalr	130(ra) # 80000f42 <strlen>
    80004ec8:	0015079b          	addw	a5,a0,1
    80004ecc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    80004ed0:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004ed4:	13796563          	bltu	s2,s7,80004ffe <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ed8:	e0043d03          	ld	s10,-512(s0)
    80004edc:	000d3a03          	ld	s4,0(s10)
    80004ee0:	8552                	mv	a0,s4
    80004ee2:	ffffc097          	auipc	ra,0xffffc
    80004ee6:	060080e7          	jalr	96(ra) # 80000f42 <strlen>
    80004eea:	0015069b          	addw	a3,a0,1
    80004eee:	8652                	mv	a2,s4
    80004ef0:	85ca                	mv	a1,s2
    80004ef2:	855a                	mv	a0,s6
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	890080e7          	jalr	-1904(ra) # 80001784 <copyout>
    80004efc:	10054363          	bltz	a0,80005002 <exec+0x39c>
    ustack[argc] = sp;
    80004f00:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004f04:	0485                	add	s1,s1,1
    80004f06:	008d0793          	add	a5,s10,8
    80004f0a:	e0f43023          	sd	a5,-512(s0)
    80004f0e:	008d3503          	ld	a0,8(s10)
    80004f12:	c909                	beqz	a0,80004f24 <exec+0x2be>
    if(argc >= MAXARG)
    80004f14:	09a1                	add	s3,s3,8
    80004f16:	fb8995e3          	bne	s3,s8,80004ec0 <exec+0x25a>
  ip = 0;
    80004f1a:	4a01                	li	s4,0
    80004f1c:	a855                	j	80004fd0 <exec+0x36a>
  sp = sz;
    80004f1e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004f22:	4481                	li	s1,0
  ustack[argc] = 0;
    80004f24:	00349793          	sll	a5,s1,0x3
    80004f28:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd350>
    80004f2c:	97a2                	add	a5,a5,s0
    80004f2e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004f32:	00148693          	add	a3,s1,1
    80004f36:	068e                	sll	a3,a3,0x3
    80004f38:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004f3c:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004f40:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004f44:	f57968e3          	bltu	s2,s7,80004e94 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004f48:	e9040613          	add	a2,s0,-368
    80004f4c:	85ca                	mv	a1,s2
    80004f4e:	855a                	mv	a0,s6
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	834080e7          	jalr	-1996(ra) # 80001784 <copyout>
    80004f58:	0a054763          	bltz	a0,80005006 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004f5c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004f60:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004f64:	df843783          	ld	a5,-520(s0)
    80004f68:	0007c703          	lbu	a4,0(a5)
    80004f6c:	cf11                	beqz	a4,80004f88 <exec+0x322>
    80004f6e:	0785                	add	a5,a5,1
    if(*s == '/')
    80004f70:	02f00693          	li	a3,47
    80004f74:	a039                	j	80004f82 <exec+0x31c>
      last = s+1;
    80004f76:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004f7a:	0785                	add	a5,a5,1
    80004f7c:	fff7c703          	lbu	a4,-1(a5)
    80004f80:	c701                	beqz	a4,80004f88 <exec+0x322>
    if(*s == '/')
    80004f82:	fed71ce3          	bne	a4,a3,80004f7a <exec+0x314>
    80004f86:	bfc5                	j	80004f76 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f88:	4641                	li	a2,16
    80004f8a:	df843583          	ld	a1,-520(s0)
    80004f8e:	158a8513          	add	a0,s5,344
    80004f92:	ffffc097          	auipc	ra,0xffffc
    80004f96:	f7e080e7          	jalr	-130(ra) # 80000f10 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f9a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004f9e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004fa2:	e0843783          	ld	a5,-504(s0)
    80004fa6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    80004faa:	058ab783          	ld	a5,88(s5)
    80004fae:	e6843703          	ld	a4,-408(s0)
    80004fb2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    80004fb4:	058ab783          	ld	a5,88(s5)
    80004fb8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004fbc:	85e6                	mv	a1,s9
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	c9e080e7          	jalr	-866(ra) # 80001c5c <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    80004fc6:	0004851b          	sext.w	a0,s1
    80004fca:	bb15                	j	80004cfe <exec+0x98>
    80004fcc:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004fd0:	e0843583          	ld	a1,-504(s0)
    80004fd4:	855a                	mv	a0,s6
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	c86080e7          	jalr	-890(ra) # 80001c5c <proc_freepagetable>
  return -1;
    80004fde:	557d                	li	a0,-1
  if(ip){
    80004fe0:	d00a0fe3          	beqz	s4,80004cfe <exec+0x98>
    80004fe4:	b319                	j	80004cea <exec+0x84>
    80004fe6:	e1243423          	sd	s2,-504(s0)
    80004fea:	b7dd                	j	80004fd0 <exec+0x36a>
    80004fec:	e1243423          	sd	s2,-504(s0)
    80004ff0:	b7c5                	j	80004fd0 <exec+0x36a>
    80004ff2:	e1243423          	sd	s2,-504(s0)
    80004ff6:	bfe9                	j	80004fd0 <exec+0x36a>
    80004ff8:	e1243423          	sd	s2,-504(s0)
    80004ffc:	bfd1                	j	80004fd0 <exec+0x36a>
  ip = 0;
    80004ffe:	4a01                	li	s4,0
    80005000:	bfc1                	j	80004fd0 <exec+0x36a>
    80005002:	4a01                	li	s4,0
  if(pagetable)
    80005004:	b7f1                	j	80004fd0 <exec+0x36a>
  sz = sz1;
    80005006:	e0843983          	ld	s3,-504(s0)
    8000500a:	b569                	j	80004e94 <exec+0x22e>

000000008000500c <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000500c:	7179                	add	sp,sp,-48
    8000500e:	f406                	sd	ra,40(sp)
    80005010:	f022                	sd	s0,32(sp)
    80005012:	ec26                	sd	s1,24(sp)
    80005014:	e84a                	sd	s2,16(sp)
    80005016:	1800                	add	s0,sp,48
    80005018:	892e                	mv	s2,a1
    8000501a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000501c:	fdc40593          	add	a1,s0,-36
    80005020:	ffffe097          	auipc	ra,0xffffe
    80005024:	bf6080e7          	jalr	-1034(ra) # 80002c16 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005028:	fdc42703          	lw	a4,-36(s0)
    8000502c:	47bd                	li	a5,15
    8000502e:	02e7eb63          	bltu	a5,a4,80005064 <argfd+0x58>
    80005032:	ffffd097          	auipc	ra,0xffffd
    80005036:	ac6080e7          	jalr	-1338(ra) # 80001af8 <myproc>
    8000503a:	fdc42703          	lw	a4,-36(s0)
    8000503e:	01a70793          	add	a5,a4,26
    80005042:	078e                	sll	a5,a5,0x3
    80005044:	953e                	add	a0,a0,a5
    80005046:	611c                	ld	a5,0(a0)
    80005048:	c385                	beqz	a5,80005068 <argfd+0x5c>
    return -1;
  if(pfd)
    8000504a:	00090463          	beqz	s2,80005052 <argfd+0x46>
    *pfd = fd;
    8000504e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005052:	4501                	li	a0,0
  if(pf)
    80005054:	c091                	beqz	s1,80005058 <argfd+0x4c>
    *pf = f;
    80005056:	e09c                	sd	a5,0(s1)
}
    80005058:	70a2                	ld	ra,40(sp)
    8000505a:	7402                	ld	s0,32(sp)
    8000505c:	64e2                	ld	s1,24(sp)
    8000505e:	6942                	ld	s2,16(sp)
    80005060:	6145                	add	sp,sp,48
    80005062:	8082                	ret
    return -1;
    80005064:	557d                	li	a0,-1
    80005066:	bfcd                	j	80005058 <argfd+0x4c>
    80005068:	557d                	li	a0,-1
    8000506a:	b7fd                	j	80005058 <argfd+0x4c>

000000008000506c <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    8000506c:	1101                	add	sp,sp,-32
    8000506e:	ec06                	sd	ra,24(sp)
    80005070:	e822                	sd	s0,16(sp)
    80005072:	e426                	sd	s1,8(sp)
    80005074:	1000                	add	s0,sp,32
    80005076:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	a80080e7          	jalr	-1408(ra) # 80001af8 <myproc>
    80005080:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005082:	0d050793          	add	a5,a0,208
    80005086:	4501                	li	a0,0
    80005088:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000508a:	6398                	ld	a4,0(a5)
    8000508c:	cb19                	beqz	a4,800050a2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000508e:	2505                	addw	a0,a0,1
    80005090:	07a1                	add	a5,a5,8
    80005092:	fed51ce3          	bne	a0,a3,8000508a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005096:	557d                	li	a0,-1
}
    80005098:	60e2                	ld	ra,24(sp)
    8000509a:	6442                	ld	s0,16(sp)
    8000509c:	64a2                	ld	s1,8(sp)
    8000509e:	6105                	add	sp,sp,32
    800050a0:	8082                	ret
      p->ofile[fd] = f;
    800050a2:	01a50793          	add	a5,a0,26
    800050a6:	078e                	sll	a5,a5,0x3
    800050a8:	963e                	add	a2,a2,a5
    800050aa:	e204                	sd	s1,0(a2)
      return fd;
    800050ac:	b7f5                	j	80005098 <fdalloc+0x2c>

00000000800050ae <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050ae:	715d                	add	sp,sp,-80
    800050b0:	e486                	sd	ra,72(sp)
    800050b2:	e0a2                	sd	s0,64(sp)
    800050b4:	fc26                	sd	s1,56(sp)
    800050b6:	f84a                	sd	s2,48(sp)
    800050b8:	f44e                	sd	s3,40(sp)
    800050ba:	f052                	sd	s4,32(sp)
    800050bc:	ec56                	sd	s5,24(sp)
    800050be:	e85a                	sd	s6,16(sp)
    800050c0:	0880                	add	s0,sp,80
    800050c2:	8b2e                	mv	s6,a1
    800050c4:	89b2                	mv	s3,a2
    800050c6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050c8:	fb040593          	add	a1,s0,-80
    800050cc:	fffff097          	auipc	ra,0xfffff
    800050d0:	e7e080e7          	jalr	-386(ra) # 80003f4a <nameiparent>
    800050d4:	84aa                	mv	s1,a0
    800050d6:	14050b63          	beqz	a0,8000522c <create+0x17e>
    return 0;

  ilock(dp);
    800050da:	ffffe097          	auipc	ra,0xffffe
    800050de:	6ac080e7          	jalr	1708(ra) # 80003786 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800050e2:	4601                	li	a2,0
    800050e4:	fb040593          	add	a1,s0,-80
    800050e8:	8526                	mv	a0,s1
    800050ea:	fffff097          	auipc	ra,0xfffff
    800050ee:	b80080e7          	jalr	-1152(ra) # 80003c6a <dirlookup>
    800050f2:	8aaa                	mv	s5,a0
    800050f4:	c921                	beqz	a0,80005144 <create+0x96>
    iunlockput(dp);
    800050f6:	8526                	mv	a0,s1
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	8f0080e7          	jalr	-1808(ra) # 800039e8 <iunlockput>
    ilock(ip);
    80005100:	8556                	mv	a0,s5
    80005102:	ffffe097          	auipc	ra,0xffffe
    80005106:	684080e7          	jalr	1668(ra) # 80003786 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000510a:	4789                	li	a5,2
    8000510c:	02fb1563          	bne	s6,a5,80005136 <create+0x88>
    80005110:	044ad783          	lhu	a5,68(s5)
    80005114:	37f9                	addw	a5,a5,-2
    80005116:	17c2                	sll	a5,a5,0x30
    80005118:	93c1                	srl	a5,a5,0x30
    8000511a:	4705                	li	a4,1
    8000511c:	00f76d63          	bltu	a4,a5,80005136 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005120:	8556                	mv	a0,s5
    80005122:	60a6                	ld	ra,72(sp)
    80005124:	6406                	ld	s0,64(sp)
    80005126:	74e2                	ld	s1,56(sp)
    80005128:	7942                	ld	s2,48(sp)
    8000512a:	79a2                	ld	s3,40(sp)
    8000512c:	7a02                	ld	s4,32(sp)
    8000512e:	6ae2                	ld	s5,24(sp)
    80005130:	6b42                	ld	s6,16(sp)
    80005132:	6161                	add	sp,sp,80
    80005134:	8082                	ret
    iunlockput(ip);
    80005136:	8556                	mv	a0,s5
    80005138:	fffff097          	auipc	ra,0xfffff
    8000513c:	8b0080e7          	jalr	-1872(ra) # 800039e8 <iunlockput>
    return 0;
    80005140:	4a81                	li	s5,0
    80005142:	bff9                	j	80005120 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005144:	85da                	mv	a1,s6
    80005146:	4088                	lw	a0,0(s1)
    80005148:	ffffe097          	auipc	ra,0xffffe
    8000514c:	4a6080e7          	jalr	1190(ra) # 800035ee <ialloc>
    80005150:	8a2a                	mv	s4,a0
    80005152:	c529                	beqz	a0,8000519c <create+0xee>
  ilock(ip);
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	632080e7          	jalr	1586(ra) # 80003786 <ilock>
  ip->major = major;
    8000515c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005160:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005164:	4905                	li	s2,1
    80005166:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000516a:	8552                	mv	a0,s4
    8000516c:	ffffe097          	auipc	ra,0xffffe
    80005170:	54e080e7          	jalr	1358(ra) # 800036ba <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    80005174:	032b0b63          	beq	s6,s2,800051aa <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005178:	004a2603          	lw	a2,4(s4)
    8000517c:	fb040593          	add	a1,s0,-80
    80005180:	8526                	mv	a0,s1
    80005182:	fffff097          	auipc	ra,0xfffff
    80005186:	cf8080e7          	jalr	-776(ra) # 80003e7a <dirlink>
    8000518a:	06054f63          	bltz	a0,80005208 <create+0x15a>
  iunlockput(dp);
    8000518e:	8526                	mv	a0,s1
    80005190:	fffff097          	auipc	ra,0xfffff
    80005194:	858080e7          	jalr	-1960(ra) # 800039e8 <iunlockput>
  return ip;
    80005198:	8ad2                	mv	s5,s4
    8000519a:	b759                	j	80005120 <create+0x72>
    iunlockput(dp);
    8000519c:	8526                	mv	a0,s1
    8000519e:	fffff097          	auipc	ra,0xfffff
    800051a2:	84a080e7          	jalr	-1974(ra) # 800039e8 <iunlockput>
    return 0;
    800051a6:	8ad2                	mv	s5,s4
    800051a8:	bfa5                	j	80005120 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051aa:	004a2603          	lw	a2,4(s4)
    800051ae:	00003597          	auipc	a1,0x3
    800051b2:	58258593          	add	a1,a1,1410 # 80008730 <syscalls+0x2a0>
    800051b6:	8552                	mv	a0,s4
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	cc2080e7          	jalr	-830(ra) # 80003e7a <dirlink>
    800051c0:	04054463          	bltz	a0,80005208 <create+0x15a>
    800051c4:	40d0                	lw	a2,4(s1)
    800051c6:	00003597          	auipc	a1,0x3
    800051ca:	57258593          	add	a1,a1,1394 # 80008738 <syscalls+0x2a8>
    800051ce:	8552                	mv	a0,s4
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	caa080e7          	jalr	-854(ra) # 80003e7a <dirlink>
    800051d8:	02054863          	bltz	a0,80005208 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800051dc:	004a2603          	lw	a2,4(s4)
    800051e0:	fb040593          	add	a1,s0,-80
    800051e4:	8526                	mv	a0,s1
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	c94080e7          	jalr	-876(ra) # 80003e7a <dirlink>
    800051ee:	00054d63          	bltz	a0,80005208 <create+0x15a>
    dp->nlink++;  /* for ".." */
    800051f2:	04a4d783          	lhu	a5,74(s1)
    800051f6:	2785                	addw	a5,a5,1
    800051f8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800051fc:	8526                	mv	a0,s1
    800051fe:	ffffe097          	auipc	ra,0xffffe
    80005202:	4bc080e7          	jalr	1212(ra) # 800036ba <iupdate>
    80005206:	b761                	j	8000518e <create+0xe0>
  ip->nlink = 0;
    80005208:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000520c:	8552                	mv	a0,s4
    8000520e:	ffffe097          	auipc	ra,0xffffe
    80005212:	4ac080e7          	jalr	1196(ra) # 800036ba <iupdate>
  iunlockput(ip);
    80005216:	8552                	mv	a0,s4
    80005218:	ffffe097          	auipc	ra,0xffffe
    8000521c:	7d0080e7          	jalr	2000(ra) # 800039e8 <iunlockput>
  iunlockput(dp);
    80005220:	8526                	mv	a0,s1
    80005222:	ffffe097          	auipc	ra,0xffffe
    80005226:	7c6080e7          	jalr	1990(ra) # 800039e8 <iunlockput>
  return 0;
    8000522a:	bddd                	j	80005120 <create+0x72>
    return 0;
    8000522c:	8aaa                	mv	s5,a0
    8000522e:	bdcd                	j	80005120 <create+0x72>

0000000080005230 <sys_dup>:
{
    80005230:	7179                	add	sp,sp,-48
    80005232:	f406                	sd	ra,40(sp)
    80005234:	f022                	sd	s0,32(sp)
    80005236:	ec26                	sd	s1,24(sp)
    80005238:	e84a                	sd	s2,16(sp)
    8000523a:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000523c:	fd840613          	add	a2,s0,-40
    80005240:	4581                	li	a1,0
    80005242:	4501                	li	a0,0
    80005244:	00000097          	auipc	ra,0x0
    80005248:	dc8080e7          	jalr	-568(ra) # 8000500c <argfd>
    return -1;
    8000524c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000524e:	02054363          	bltz	a0,80005274 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005252:	fd843903          	ld	s2,-40(s0)
    80005256:	854a                	mv	a0,s2
    80005258:	00000097          	auipc	ra,0x0
    8000525c:	e14080e7          	jalr	-492(ra) # 8000506c <fdalloc>
    80005260:	84aa                	mv	s1,a0
    return -1;
    80005262:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005264:	00054863          	bltz	a0,80005274 <sys_dup+0x44>
  filedup(f);
    80005268:	854a                	mv	a0,s2
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	334080e7          	jalr	820(ra) # 8000459e <filedup>
  return fd;
    80005272:	87a6                	mv	a5,s1
}
    80005274:	853e                	mv	a0,a5
    80005276:	70a2                	ld	ra,40(sp)
    80005278:	7402                	ld	s0,32(sp)
    8000527a:	64e2                	ld	s1,24(sp)
    8000527c:	6942                	ld	s2,16(sp)
    8000527e:	6145                	add	sp,sp,48
    80005280:	8082                	ret

0000000080005282 <sys_read>:
{
    80005282:	7179                	add	sp,sp,-48
    80005284:	f406                	sd	ra,40(sp)
    80005286:	f022                	sd	s0,32(sp)
    80005288:	1800                	add	s0,sp,48
  argaddr(1, &p);
    8000528a:	fd840593          	add	a1,s0,-40
    8000528e:	4505                	li	a0,1
    80005290:	ffffe097          	auipc	ra,0xffffe
    80005294:	9a6080e7          	jalr	-1626(ra) # 80002c36 <argaddr>
  argint(2, &n);
    80005298:	fe440593          	add	a1,s0,-28
    8000529c:	4509                	li	a0,2
    8000529e:	ffffe097          	auipc	ra,0xffffe
    800052a2:	978080e7          	jalr	-1672(ra) # 80002c16 <argint>
  if(argfd(0, 0, &f) < 0)
    800052a6:	fe840613          	add	a2,s0,-24
    800052aa:	4581                	li	a1,0
    800052ac:	4501                	li	a0,0
    800052ae:	00000097          	auipc	ra,0x0
    800052b2:	d5e080e7          	jalr	-674(ra) # 8000500c <argfd>
    800052b6:	87aa                	mv	a5,a0
    return -1;
    800052b8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800052ba:	0007cc63          	bltz	a5,800052d2 <sys_read+0x50>
  return fileread(f, p, n);
    800052be:	fe442603          	lw	a2,-28(s0)
    800052c2:	fd843583          	ld	a1,-40(s0)
    800052c6:	fe843503          	ld	a0,-24(s0)
    800052ca:	fffff097          	auipc	ra,0xfffff
    800052ce:	460080e7          	jalr	1120(ra) # 8000472a <fileread>
}
    800052d2:	70a2                	ld	ra,40(sp)
    800052d4:	7402                	ld	s0,32(sp)
    800052d6:	6145                	add	sp,sp,48
    800052d8:	8082                	ret

00000000800052da <sys_write>:
{
    800052da:	7179                	add	sp,sp,-48
    800052dc:	f406                	sd	ra,40(sp)
    800052de:	f022                	sd	s0,32(sp)
    800052e0:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800052e2:	fd840593          	add	a1,s0,-40
    800052e6:	4505                	li	a0,1
    800052e8:	ffffe097          	auipc	ra,0xffffe
    800052ec:	94e080e7          	jalr	-1714(ra) # 80002c36 <argaddr>
  argint(2, &n);
    800052f0:	fe440593          	add	a1,s0,-28
    800052f4:	4509                	li	a0,2
    800052f6:	ffffe097          	auipc	ra,0xffffe
    800052fa:	920080e7          	jalr	-1760(ra) # 80002c16 <argint>
  if(argfd(0, 0, &f) < 0)
    800052fe:	fe840613          	add	a2,s0,-24
    80005302:	4581                	li	a1,0
    80005304:	4501                	li	a0,0
    80005306:	00000097          	auipc	ra,0x0
    8000530a:	d06080e7          	jalr	-762(ra) # 8000500c <argfd>
    8000530e:	87aa                	mv	a5,a0
    return -1;
    80005310:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005312:	0007cc63          	bltz	a5,8000532a <sys_write+0x50>
  return filewrite(f, p, n);
    80005316:	fe442603          	lw	a2,-28(s0)
    8000531a:	fd843583          	ld	a1,-40(s0)
    8000531e:	fe843503          	ld	a0,-24(s0)
    80005322:	fffff097          	auipc	ra,0xfffff
    80005326:	4ca080e7          	jalr	1226(ra) # 800047ec <filewrite>
}
    8000532a:	70a2                	ld	ra,40(sp)
    8000532c:	7402                	ld	s0,32(sp)
    8000532e:	6145                	add	sp,sp,48
    80005330:	8082                	ret

0000000080005332 <sys_close>:
{
    80005332:	1101                	add	sp,sp,-32
    80005334:	ec06                	sd	ra,24(sp)
    80005336:	e822                	sd	s0,16(sp)
    80005338:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000533a:	fe040613          	add	a2,s0,-32
    8000533e:	fec40593          	add	a1,s0,-20
    80005342:	4501                	li	a0,0
    80005344:	00000097          	auipc	ra,0x0
    80005348:	cc8080e7          	jalr	-824(ra) # 8000500c <argfd>
    return -1;
    8000534c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000534e:	02054463          	bltz	a0,80005376 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	7a6080e7          	jalr	1958(ra) # 80001af8 <myproc>
    8000535a:	fec42783          	lw	a5,-20(s0)
    8000535e:	07e9                	add	a5,a5,26
    80005360:	078e                	sll	a5,a5,0x3
    80005362:	953e                	add	a0,a0,a5
    80005364:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005368:	fe043503          	ld	a0,-32(s0)
    8000536c:	fffff097          	auipc	ra,0xfffff
    80005370:	284080e7          	jalr	644(ra) # 800045f0 <fileclose>
  return 0;
    80005374:	4781                	li	a5,0
}
    80005376:	853e                	mv	a0,a5
    80005378:	60e2                	ld	ra,24(sp)
    8000537a:	6442                	ld	s0,16(sp)
    8000537c:	6105                	add	sp,sp,32
    8000537e:	8082                	ret

0000000080005380 <sys_fstat>:
{
    80005380:	1101                	add	sp,sp,-32
    80005382:	ec06                	sd	ra,24(sp)
    80005384:	e822                	sd	s0,16(sp)
    80005386:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80005388:	fe040593          	add	a1,s0,-32
    8000538c:	4505                	li	a0,1
    8000538e:	ffffe097          	auipc	ra,0xffffe
    80005392:	8a8080e7          	jalr	-1880(ra) # 80002c36 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005396:	fe840613          	add	a2,s0,-24
    8000539a:	4581                	li	a1,0
    8000539c:	4501                	li	a0,0
    8000539e:	00000097          	auipc	ra,0x0
    800053a2:	c6e080e7          	jalr	-914(ra) # 8000500c <argfd>
    800053a6:	87aa                	mv	a5,a0
    return -1;
    800053a8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053aa:	0007ca63          	bltz	a5,800053be <sys_fstat+0x3e>
  return filestat(f, st);
    800053ae:	fe043583          	ld	a1,-32(s0)
    800053b2:	fe843503          	ld	a0,-24(s0)
    800053b6:	fffff097          	auipc	ra,0xfffff
    800053ba:	302080e7          	jalr	770(ra) # 800046b8 <filestat>
}
    800053be:	60e2                	ld	ra,24(sp)
    800053c0:	6442                	ld	s0,16(sp)
    800053c2:	6105                	add	sp,sp,32
    800053c4:	8082                	ret

00000000800053c6 <sys_link>:
{
    800053c6:	7169                	add	sp,sp,-304
    800053c8:	f606                	sd	ra,296(sp)
    800053ca:	f222                	sd	s0,288(sp)
    800053cc:	ee26                	sd	s1,280(sp)
    800053ce:	ea4a                	sd	s2,272(sp)
    800053d0:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053d2:	08000613          	li	a2,128
    800053d6:	ed040593          	add	a1,s0,-304
    800053da:	4501                	li	a0,0
    800053dc:	ffffe097          	auipc	ra,0xffffe
    800053e0:	87a080e7          	jalr	-1926(ra) # 80002c56 <argstr>
    return -1;
    800053e4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053e6:	10054e63          	bltz	a0,80005502 <sys_link+0x13c>
    800053ea:	08000613          	li	a2,128
    800053ee:	f5040593          	add	a1,s0,-176
    800053f2:	4505                	li	a0,1
    800053f4:	ffffe097          	auipc	ra,0xffffe
    800053f8:	862080e7          	jalr	-1950(ra) # 80002c56 <argstr>
    return -1;
    800053fc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053fe:	10054263          	bltz	a0,80005502 <sys_link+0x13c>
  begin_op();
    80005402:	fffff097          	auipc	ra,0xfffff
    80005406:	d2a080e7          	jalr	-726(ra) # 8000412c <begin_op>
  if((ip = namei(old)) == 0){
    8000540a:	ed040513          	add	a0,s0,-304
    8000540e:	fffff097          	auipc	ra,0xfffff
    80005412:	b1e080e7          	jalr	-1250(ra) # 80003f2c <namei>
    80005416:	84aa                	mv	s1,a0
    80005418:	c551                	beqz	a0,800054a4 <sys_link+0xde>
  ilock(ip);
    8000541a:	ffffe097          	auipc	ra,0xffffe
    8000541e:	36c080e7          	jalr	876(ra) # 80003786 <ilock>
  if(ip->type == T_DIR){
    80005422:	04449703          	lh	a4,68(s1)
    80005426:	4785                	li	a5,1
    80005428:	08f70463          	beq	a4,a5,800054b0 <sys_link+0xea>
  ip->nlink++;
    8000542c:	04a4d783          	lhu	a5,74(s1)
    80005430:	2785                	addw	a5,a5,1
    80005432:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005436:	8526                	mv	a0,s1
    80005438:	ffffe097          	auipc	ra,0xffffe
    8000543c:	282080e7          	jalr	642(ra) # 800036ba <iupdate>
  iunlock(ip);
    80005440:	8526                	mv	a0,s1
    80005442:	ffffe097          	auipc	ra,0xffffe
    80005446:	406080e7          	jalr	1030(ra) # 80003848 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000544a:	fd040593          	add	a1,s0,-48
    8000544e:	f5040513          	add	a0,s0,-176
    80005452:	fffff097          	auipc	ra,0xfffff
    80005456:	af8080e7          	jalr	-1288(ra) # 80003f4a <nameiparent>
    8000545a:	892a                	mv	s2,a0
    8000545c:	c935                	beqz	a0,800054d0 <sys_link+0x10a>
  ilock(dp);
    8000545e:	ffffe097          	auipc	ra,0xffffe
    80005462:	328080e7          	jalr	808(ra) # 80003786 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005466:	00092703          	lw	a4,0(s2)
    8000546a:	409c                	lw	a5,0(s1)
    8000546c:	04f71d63          	bne	a4,a5,800054c6 <sys_link+0x100>
    80005470:	40d0                	lw	a2,4(s1)
    80005472:	fd040593          	add	a1,s0,-48
    80005476:	854a                	mv	a0,s2
    80005478:	fffff097          	auipc	ra,0xfffff
    8000547c:	a02080e7          	jalr	-1534(ra) # 80003e7a <dirlink>
    80005480:	04054363          	bltz	a0,800054c6 <sys_link+0x100>
  iunlockput(dp);
    80005484:	854a                	mv	a0,s2
    80005486:	ffffe097          	auipc	ra,0xffffe
    8000548a:	562080e7          	jalr	1378(ra) # 800039e8 <iunlockput>
  iput(ip);
    8000548e:	8526                	mv	a0,s1
    80005490:	ffffe097          	auipc	ra,0xffffe
    80005494:	4b0080e7          	jalr	1200(ra) # 80003940 <iput>
  end_op();
    80005498:	fffff097          	auipc	ra,0xfffff
    8000549c:	d0e080e7          	jalr	-754(ra) # 800041a6 <end_op>
  return 0;
    800054a0:	4781                	li	a5,0
    800054a2:	a085                	j	80005502 <sys_link+0x13c>
    end_op();
    800054a4:	fffff097          	auipc	ra,0xfffff
    800054a8:	d02080e7          	jalr	-766(ra) # 800041a6 <end_op>
    return -1;
    800054ac:	57fd                	li	a5,-1
    800054ae:	a891                	j	80005502 <sys_link+0x13c>
    iunlockput(ip);
    800054b0:	8526                	mv	a0,s1
    800054b2:	ffffe097          	auipc	ra,0xffffe
    800054b6:	536080e7          	jalr	1334(ra) # 800039e8 <iunlockput>
    end_op();
    800054ba:	fffff097          	auipc	ra,0xfffff
    800054be:	cec080e7          	jalr	-788(ra) # 800041a6 <end_op>
    return -1;
    800054c2:	57fd                	li	a5,-1
    800054c4:	a83d                	j	80005502 <sys_link+0x13c>
    iunlockput(dp);
    800054c6:	854a                	mv	a0,s2
    800054c8:	ffffe097          	auipc	ra,0xffffe
    800054cc:	520080e7          	jalr	1312(ra) # 800039e8 <iunlockput>
  ilock(ip);
    800054d0:	8526                	mv	a0,s1
    800054d2:	ffffe097          	auipc	ra,0xffffe
    800054d6:	2b4080e7          	jalr	692(ra) # 80003786 <ilock>
  ip->nlink--;
    800054da:	04a4d783          	lhu	a5,74(s1)
    800054de:	37fd                	addw	a5,a5,-1
    800054e0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054e4:	8526                	mv	a0,s1
    800054e6:	ffffe097          	auipc	ra,0xffffe
    800054ea:	1d4080e7          	jalr	468(ra) # 800036ba <iupdate>
  iunlockput(ip);
    800054ee:	8526                	mv	a0,s1
    800054f0:	ffffe097          	auipc	ra,0xffffe
    800054f4:	4f8080e7          	jalr	1272(ra) # 800039e8 <iunlockput>
  end_op();
    800054f8:	fffff097          	auipc	ra,0xfffff
    800054fc:	cae080e7          	jalr	-850(ra) # 800041a6 <end_op>
  return -1;
    80005500:	57fd                	li	a5,-1
}
    80005502:	853e                	mv	a0,a5
    80005504:	70b2                	ld	ra,296(sp)
    80005506:	7412                	ld	s0,288(sp)
    80005508:	64f2                	ld	s1,280(sp)
    8000550a:	6952                	ld	s2,272(sp)
    8000550c:	6155                	add	sp,sp,304
    8000550e:	8082                	ret

0000000080005510 <sys_unlink>:
{
    80005510:	7151                	add	sp,sp,-240
    80005512:	f586                	sd	ra,232(sp)
    80005514:	f1a2                	sd	s0,224(sp)
    80005516:	eda6                	sd	s1,216(sp)
    80005518:	e9ca                	sd	s2,208(sp)
    8000551a:	e5ce                	sd	s3,200(sp)
    8000551c:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000551e:	08000613          	li	a2,128
    80005522:	f3040593          	add	a1,s0,-208
    80005526:	4501                	li	a0,0
    80005528:	ffffd097          	auipc	ra,0xffffd
    8000552c:	72e080e7          	jalr	1838(ra) # 80002c56 <argstr>
    80005530:	18054163          	bltz	a0,800056b2 <sys_unlink+0x1a2>
  begin_op();
    80005534:	fffff097          	auipc	ra,0xfffff
    80005538:	bf8080e7          	jalr	-1032(ra) # 8000412c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000553c:	fb040593          	add	a1,s0,-80
    80005540:	f3040513          	add	a0,s0,-208
    80005544:	fffff097          	auipc	ra,0xfffff
    80005548:	a06080e7          	jalr	-1530(ra) # 80003f4a <nameiparent>
    8000554c:	84aa                	mv	s1,a0
    8000554e:	c979                	beqz	a0,80005624 <sys_unlink+0x114>
  ilock(dp);
    80005550:	ffffe097          	auipc	ra,0xffffe
    80005554:	236080e7          	jalr	566(ra) # 80003786 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005558:	00003597          	auipc	a1,0x3
    8000555c:	1d858593          	add	a1,a1,472 # 80008730 <syscalls+0x2a0>
    80005560:	fb040513          	add	a0,s0,-80
    80005564:	ffffe097          	auipc	ra,0xffffe
    80005568:	6ec080e7          	jalr	1772(ra) # 80003c50 <namecmp>
    8000556c:	14050a63          	beqz	a0,800056c0 <sys_unlink+0x1b0>
    80005570:	00003597          	auipc	a1,0x3
    80005574:	1c858593          	add	a1,a1,456 # 80008738 <syscalls+0x2a8>
    80005578:	fb040513          	add	a0,s0,-80
    8000557c:	ffffe097          	auipc	ra,0xffffe
    80005580:	6d4080e7          	jalr	1748(ra) # 80003c50 <namecmp>
    80005584:	12050e63          	beqz	a0,800056c0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005588:	f2c40613          	add	a2,s0,-212
    8000558c:	fb040593          	add	a1,s0,-80
    80005590:	8526                	mv	a0,s1
    80005592:	ffffe097          	auipc	ra,0xffffe
    80005596:	6d8080e7          	jalr	1752(ra) # 80003c6a <dirlookup>
    8000559a:	892a                	mv	s2,a0
    8000559c:	12050263          	beqz	a0,800056c0 <sys_unlink+0x1b0>
  ilock(ip);
    800055a0:	ffffe097          	auipc	ra,0xffffe
    800055a4:	1e6080e7          	jalr	486(ra) # 80003786 <ilock>
  if(ip->nlink < 1)
    800055a8:	04a91783          	lh	a5,74(s2)
    800055ac:	08f05263          	blez	a5,80005630 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055b0:	04491703          	lh	a4,68(s2)
    800055b4:	4785                	li	a5,1
    800055b6:	08f70563          	beq	a4,a5,80005640 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055ba:	4641                	li	a2,16
    800055bc:	4581                	li	a1,0
    800055be:	fc040513          	add	a0,s0,-64
    800055c2:	ffffc097          	auipc	ra,0xffffc
    800055c6:	806080e7          	jalr	-2042(ra) # 80000dc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055ca:	4741                	li	a4,16
    800055cc:	f2c42683          	lw	a3,-212(s0)
    800055d0:	fc040613          	add	a2,s0,-64
    800055d4:	4581                	li	a1,0
    800055d6:	8526                	mv	a0,s1
    800055d8:	ffffe097          	auipc	ra,0xffffe
    800055dc:	55a080e7          	jalr	1370(ra) # 80003b32 <writei>
    800055e0:	47c1                	li	a5,16
    800055e2:	0af51563          	bne	a0,a5,8000568c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800055e6:	04491703          	lh	a4,68(s2)
    800055ea:	4785                	li	a5,1
    800055ec:	0af70863          	beq	a4,a5,8000569c <sys_unlink+0x18c>
  iunlockput(dp);
    800055f0:	8526                	mv	a0,s1
    800055f2:	ffffe097          	auipc	ra,0xffffe
    800055f6:	3f6080e7          	jalr	1014(ra) # 800039e8 <iunlockput>
  ip->nlink--;
    800055fa:	04a95783          	lhu	a5,74(s2)
    800055fe:	37fd                	addw	a5,a5,-1
    80005600:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005604:	854a                	mv	a0,s2
    80005606:	ffffe097          	auipc	ra,0xffffe
    8000560a:	0b4080e7          	jalr	180(ra) # 800036ba <iupdate>
  iunlockput(ip);
    8000560e:	854a                	mv	a0,s2
    80005610:	ffffe097          	auipc	ra,0xffffe
    80005614:	3d8080e7          	jalr	984(ra) # 800039e8 <iunlockput>
  end_op();
    80005618:	fffff097          	auipc	ra,0xfffff
    8000561c:	b8e080e7          	jalr	-1138(ra) # 800041a6 <end_op>
  return 0;
    80005620:	4501                	li	a0,0
    80005622:	a84d                	j	800056d4 <sys_unlink+0x1c4>
    end_op();
    80005624:	fffff097          	auipc	ra,0xfffff
    80005628:	b82080e7          	jalr	-1150(ra) # 800041a6 <end_op>
    return -1;
    8000562c:	557d                	li	a0,-1
    8000562e:	a05d                	j	800056d4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005630:	00003517          	auipc	a0,0x3
    80005634:	11050513          	add	a0,a0,272 # 80008740 <syscalls+0x2b0>
    80005638:	ffffb097          	auipc	ra,0xffffb
    8000563c:	1d6080e7          	jalr	470(ra) # 8000080e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005640:	04c92703          	lw	a4,76(s2)
    80005644:	02000793          	li	a5,32
    80005648:	f6e7f9e3          	bgeu	a5,a4,800055ba <sys_unlink+0xaa>
    8000564c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005650:	4741                	li	a4,16
    80005652:	86ce                	mv	a3,s3
    80005654:	f1840613          	add	a2,s0,-232
    80005658:	4581                	li	a1,0
    8000565a:	854a                	mv	a0,s2
    8000565c:	ffffe097          	auipc	ra,0xffffe
    80005660:	3de080e7          	jalr	990(ra) # 80003a3a <readi>
    80005664:	47c1                	li	a5,16
    80005666:	00f51b63          	bne	a0,a5,8000567c <sys_unlink+0x16c>
    if(de.inum != 0)
    8000566a:	f1845783          	lhu	a5,-232(s0)
    8000566e:	e7a1                	bnez	a5,800056b6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005670:	29c1                	addw	s3,s3,16
    80005672:	04c92783          	lw	a5,76(s2)
    80005676:	fcf9ede3          	bltu	s3,a5,80005650 <sys_unlink+0x140>
    8000567a:	b781                	j	800055ba <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000567c:	00003517          	auipc	a0,0x3
    80005680:	0dc50513          	add	a0,a0,220 # 80008758 <syscalls+0x2c8>
    80005684:	ffffb097          	auipc	ra,0xffffb
    80005688:	18a080e7          	jalr	394(ra) # 8000080e <panic>
    panic("unlink: writei");
    8000568c:	00003517          	auipc	a0,0x3
    80005690:	0e450513          	add	a0,a0,228 # 80008770 <syscalls+0x2e0>
    80005694:	ffffb097          	auipc	ra,0xffffb
    80005698:	17a080e7          	jalr	378(ra) # 8000080e <panic>
    dp->nlink--;
    8000569c:	04a4d783          	lhu	a5,74(s1)
    800056a0:	37fd                	addw	a5,a5,-1
    800056a2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800056a6:	8526                	mv	a0,s1
    800056a8:	ffffe097          	auipc	ra,0xffffe
    800056ac:	012080e7          	jalr	18(ra) # 800036ba <iupdate>
    800056b0:	b781                	j	800055f0 <sys_unlink+0xe0>
    return -1;
    800056b2:	557d                	li	a0,-1
    800056b4:	a005                	j	800056d4 <sys_unlink+0x1c4>
    iunlockput(ip);
    800056b6:	854a                	mv	a0,s2
    800056b8:	ffffe097          	auipc	ra,0xffffe
    800056bc:	330080e7          	jalr	816(ra) # 800039e8 <iunlockput>
  iunlockput(dp);
    800056c0:	8526                	mv	a0,s1
    800056c2:	ffffe097          	auipc	ra,0xffffe
    800056c6:	326080e7          	jalr	806(ra) # 800039e8 <iunlockput>
  end_op();
    800056ca:	fffff097          	auipc	ra,0xfffff
    800056ce:	adc080e7          	jalr	-1316(ra) # 800041a6 <end_op>
  return -1;
    800056d2:	557d                	li	a0,-1
}
    800056d4:	70ae                	ld	ra,232(sp)
    800056d6:	740e                	ld	s0,224(sp)
    800056d8:	64ee                	ld	s1,216(sp)
    800056da:	694e                	ld	s2,208(sp)
    800056dc:	69ae                	ld	s3,200(sp)
    800056de:	616d                	add	sp,sp,240
    800056e0:	8082                	ret

00000000800056e2 <sys_open>:

uint64
sys_open(void)
{
    800056e2:	7131                	add	sp,sp,-192
    800056e4:	fd06                	sd	ra,184(sp)
    800056e6:	f922                	sd	s0,176(sp)
    800056e8:	f526                	sd	s1,168(sp)
    800056ea:	f14a                	sd	s2,160(sp)
    800056ec:	ed4e                	sd	s3,152(sp)
    800056ee:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800056f0:	f4c40593          	add	a1,s0,-180
    800056f4:	4505                	li	a0,1
    800056f6:	ffffd097          	auipc	ra,0xffffd
    800056fa:	520080e7          	jalr	1312(ra) # 80002c16 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800056fe:	08000613          	li	a2,128
    80005702:	f5040593          	add	a1,s0,-176
    80005706:	4501                	li	a0,0
    80005708:	ffffd097          	auipc	ra,0xffffd
    8000570c:	54e080e7          	jalr	1358(ra) # 80002c56 <argstr>
    80005710:	87aa                	mv	a5,a0
    return -1;
    80005712:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005714:	0a07c863          	bltz	a5,800057c4 <sys_open+0xe2>

  begin_op();
    80005718:	fffff097          	auipc	ra,0xfffff
    8000571c:	a14080e7          	jalr	-1516(ra) # 8000412c <begin_op>

  if(omode & O_CREATE){
    80005720:	f4c42783          	lw	a5,-180(s0)
    80005724:	2007f793          	and	a5,a5,512
    80005728:	cbdd                	beqz	a5,800057de <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    8000572a:	4681                	li	a3,0
    8000572c:	4601                	li	a2,0
    8000572e:	4589                	li	a1,2
    80005730:	f5040513          	add	a0,s0,-176
    80005734:	00000097          	auipc	ra,0x0
    80005738:	97a080e7          	jalr	-1670(ra) # 800050ae <create>
    8000573c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000573e:	c951                	beqz	a0,800057d2 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005740:	04449703          	lh	a4,68(s1)
    80005744:	478d                	li	a5,3
    80005746:	00f71763          	bne	a4,a5,80005754 <sys_open+0x72>
    8000574a:	0464d703          	lhu	a4,70(s1)
    8000574e:	47a5                	li	a5,9
    80005750:	0ce7ec63          	bltu	a5,a4,80005828 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005754:	fffff097          	auipc	ra,0xfffff
    80005758:	de0080e7          	jalr	-544(ra) # 80004534 <filealloc>
    8000575c:	892a                	mv	s2,a0
    8000575e:	c56d                	beqz	a0,80005848 <sys_open+0x166>
    80005760:	00000097          	auipc	ra,0x0
    80005764:	90c080e7          	jalr	-1780(ra) # 8000506c <fdalloc>
    80005768:	89aa                	mv	s3,a0
    8000576a:	0c054a63          	bltz	a0,8000583e <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000576e:	04449703          	lh	a4,68(s1)
    80005772:	478d                	li	a5,3
    80005774:	0ef70563          	beq	a4,a5,8000585e <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005778:	4789                	li	a5,2
    8000577a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000577e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005782:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005786:	f4c42783          	lw	a5,-180(s0)
    8000578a:	0017c713          	xor	a4,a5,1
    8000578e:	8b05                	and	a4,a4,1
    80005790:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005794:	0037f713          	and	a4,a5,3
    80005798:	00e03733          	snez	a4,a4
    8000579c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057a0:	4007f793          	and	a5,a5,1024
    800057a4:	c791                	beqz	a5,800057b0 <sys_open+0xce>
    800057a6:	04449703          	lh	a4,68(s1)
    800057aa:	4789                	li	a5,2
    800057ac:	0cf70063          	beq	a4,a5,8000586c <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    800057b0:	8526                	mv	a0,s1
    800057b2:	ffffe097          	auipc	ra,0xffffe
    800057b6:	096080e7          	jalr	150(ra) # 80003848 <iunlock>
  end_op();
    800057ba:	fffff097          	auipc	ra,0xfffff
    800057be:	9ec080e7          	jalr	-1556(ra) # 800041a6 <end_op>

  return fd;
    800057c2:	854e                	mv	a0,s3
}
    800057c4:	70ea                	ld	ra,184(sp)
    800057c6:	744a                	ld	s0,176(sp)
    800057c8:	74aa                	ld	s1,168(sp)
    800057ca:	790a                	ld	s2,160(sp)
    800057cc:	69ea                	ld	s3,152(sp)
    800057ce:	6129                	add	sp,sp,192
    800057d0:	8082                	ret
      end_op();
    800057d2:	fffff097          	auipc	ra,0xfffff
    800057d6:	9d4080e7          	jalr	-1580(ra) # 800041a6 <end_op>
      return -1;
    800057da:	557d                	li	a0,-1
    800057dc:	b7e5                	j	800057c4 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    800057de:	f5040513          	add	a0,s0,-176
    800057e2:	ffffe097          	auipc	ra,0xffffe
    800057e6:	74a080e7          	jalr	1866(ra) # 80003f2c <namei>
    800057ea:	84aa                	mv	s1,a0
    800057ec:	c905                	beqz	a0,8000581c <sys_open+0x13a>
    ilock(ip);
    800057ee:	ffffe097          	auipc	ra,0xffffe
    800057f2:	f98080e7          	jalr	-104(ra) # 80003786 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800057f6:	04449703          	lh	a4,68(s1)
    800057fa:	4785                	li	a5,1
    800057fc:	f4f712e3          	bne	a4,a5,80005740 <sys_open+0x5e>
    80005800:	f4c42783          	lw	a5,-180(s0)
    80005804:	dba1                	beqz	a5,80005754 <sys_open+0x72>
      iunlockput(ip);
    80005806:	8526                	mv	a0,s1
    80005808:	ffffe097          	auipc	ra,0xffffe
    8000580c:	1e0080e7          	jalr	480(ra) # 800039e8 <iunlockput>
      end_op();
    80005810:	fffff097          	auipc	ra,0xfffff
    80005814:	996080e7          	jalr	-1642(ra) # 800041a6 <end_op>
      return -1;
    80005818:	557d                	li	a0,-1
    8000581a:	b76d                	j	800057c4 <sys_open+0xe2>
      end_op();
    8000581c:	fffff097          	auipc	ra,0xfffff
    80005820:	98a080e7          	jalr	-1654(ra) # 800041a6 <end_op>
      return -1;
    80005824:	557d                	li	a0,-1
    80005826:	bf79                	j	800057c4 <sys_open+0xe2>
    iunlockput(ip);
    80005828:	8526                	mv	a0,s1
    8000582a:	ffffe097          	auipc	ra,0xffffe
    8000582e:	1be080e7          	jalr	446(ra) # 800039e8 <iunlockput>
    end_op();
    80005832:	fffff097          	auipc	ra,0xfffff
    80005836:	974080e7          	jalr	-1676(ra) # 800041a6 <end_op>
    return -1;
    8000583a:	557d                	li	a0,-1
    8000583c:	b761                	j	800057c4 <sys_open+0xe2>
      fileclose(f);
    8000583e:	854a                	mv	a0,s2
    80005840:	fffff097          	auipc	ra,0xfffff
    80005844:	db0080e7          	jalr	-592(ra) # 800045f0 <fileclose>
    iunlockput(ip);
    80005848:	8526                	mv	a0,s1
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	19e080e7          	jalr	414(ra) # 800039e8 <iunlockput>
    end_op();
    80005852:	fffff097          	auipc	ra,0xfffff
    80005856:	954080e7          	jalr	-1708(ra) # 800041a6 <end_op>
    return -1;
    8000585a:	557d                	li	a0,-1
    8000585c:	b7a5                	j	800057c4 <sys_open+0xe2>
    f->type = FD_DEVICE;
    8000585e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005862:	04649783          	lh	a5,70(s1)
    80005866:	02f91223          	sh	a5,36(s2)
    8000586a:	bf21                	j	80005782 <sys_open+0xa0>
    itrunc(ip);
    8000586c:	8526                	mv	a0,s1
    8000586e:	ffffe097          	auipc	ra,0xffffe
    80005872:	026080e7          	jalr	38(ra) # 80003894 <itrunc>
    80005876:	bf2d                	j	800057b0 <sys_open+0xce>

0000000080005878 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005878:	7175                	add	sp,sp,-144
    8000587a:	e506                	sd	ra,136(sp)
    8000587c:	e122                	sd	s0,128(sp)
    8000587e:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005880:	fffff097          	auipc	ra,0xfffff
    80005884:	8ac080e7          	jalr	-1876(ra) # 8000412c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005888:	08000613          	li	a2,128
    8000588c:	f7040593          	add	a1,s0,-144
    80005890:	4501                	li	a0,0
    80005892:	ffffd097          	auipc	ra,0xffffd
    80005896:	3c4080e7          	jalr	964(ra) # 80002c56 <argstr>
    8000589a:	02054963          	bltz	a0,800058cc <sys_mkdir+0x54>
    8000589e:	4681                	li	a3,0
    800058a0:	4601                	li	a2,0
    800058a2:	4585                	li	a1,1
    800058a4:	f7040513          	add	a0,s0,-144
    800058a8:	00000097          	auipc	ra,0x0
    800058ac:	806080e7          	jalr	-2042(ra) # 800050ae <create>
    800058b0:	cd11                	beqz	a0,800058cc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	136080e7          	jalr	310(ra) # 800039e8 <iunlockput>
  end_op();
    800058ba:	fffff097          	auipc	ra,0xfffff
    800058be:	8ec080e7          	jalr	-1812(ra) # 800041a6 <end_op>
  return 0;
    800058c2:	4501                	li	a0,0
}
    800058c4:	60aa                	ld	ra,136(sp)
    800058c6:	640a                	ld	s0,128(sp)
    800058c8:	6149                	add	sp,sp,144
    800058ca:	8082                	ret
    end_op();
    800058cc:	fffff097          	auipc	ra,0xfffff
    800058d0:	8da080e7          	jalr	-1830(ra) # 800041a6 <end_op>
    return -1;
    800058d4:	557d                	li	a0,-1
    800058d6:	b7fd                	j	800058c4 <sys_mkdir+0x4c>

00000000800058d8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800058d8:	7135                	add	sp,sp,-160
    800058da:	ed06                	sd	ra,152(sp)
    800058dc:	e922                	sd	s0,144(sp)
    800058de:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	84c080e7          	jalr	-1972(ra) # 8000412c <begin_op>
  argint(1, &major);
    800058e8:	f6c40593          	add	a1,s0,-148
    800058ec:	4505                	li	a0,1
    800058ee:	ffffd097          	auipc	ra,0xffffd
    800058f2:	328080e7          	jalr	808(ra) # 80002c16 <argint>
  argint(2, &minor);
    800058f6:	f6840593          	add	a1,s0,-152
    800058fa:	4509                	li	a0,2
    800058fc:	ffffd097          	auipc	ra,0xffffd
    80005900:	31a080e7          	jalr	794(ra) # 80002c16 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005904:	08000613          	li	a2,128
    80005908:	f7040593          	add	a1,s0,-144
    8000590c:	4501                	li	a0,0
    8000590e:	ffffd097          	auipc	ra,0xffffd
    80005912:	348080e7          	jalr	840(ra) # 80002c56 <argstr>
    80005916:	02054b63          	bltz	a0,8000594c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000591a:	f6841683          	lh	a3,-152(s0)
    8000591e:	f6c41603          	lh	a2,-148(s0)
    80005922:	458d                	li	a1,3
    80005924:	f7040513          	add	a0,s0,-144
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	786080e7          	jalr	1926(ra) # 800050ae <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005930:	cd11                	beqz	a0,8000594c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005932:	ffffe097          	auipc	ra,0xffffe
    80005936:	0b6080e7          	jalr	182(ra) # 800039e8 <iunlockput>
  end_op();
    8000593a:	fffff097          	auipc	ra,0xfffff
    8000593e:	86c080e7          	jalr	-1940(ra) # 800041a6 <end_op>
  return 0;
    80005942:	4501                	li	a0,0
}
    80005944:	60ea                	ld	ra,152(sp)
    80005946:	644a                	ld	s0,144(sp)
    80005948:	610d                	add	sp,sp,160
    8000594a:	8082                	ret
    end_op();
    8000594c:	fffff097          	auipc	ra,0xfffff
    80005950:	85a080e7          	jalr	-1958(ra) # 800041a6 <end_op>
    return -1;
    80005954:	557d                	li	a0,-1
    80005956:	b7fd                	j	80005944 <sys_mknod+0x6c>

0000000080005958 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005958:	7135                	add	sp,sp,-160
    8000595a:	ed06                	sd	ra,152(sp)
    8000595c:	e922                	sd	s0,144(sp)
    8000595e:	e526                	sd	s1,136(sp)
    80005960:	e14a                	sd	s2,128(sp)
    80005962:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005964:	ffffc097          	auipc	ra,0xffffc
    80005968:	194080e7          	jalr	404(ra) # 80001af8 <myproc>
    8000596c:	892a                	mv	s2,a0
  
  begin_op();
    8000596e:	ffffe097          	auipc	ra,0xffffe
    80005972:	7be080e7          	jalr	1982(ra) # 8000412c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005976:	08000613          	li	a2,128
    8000597a:	f6040593          	add	a1,s0,-160
    8000597e:	4501                	li	a0,0
    80005980:	ffffd097          	auipc	ra,0xffffd
    80005984:	2d6080e7          	jalr	726(ra) # 80002c56 <argstr>
    80005988:	04054b63          	bltz	a0,800059de <sys_chdir+0x86>
    8000598c:	f6040513          	add	a0,s0,-160
    80005990:	ffffe097          	auipc	ra,0xffffe
    80005994:	59c080e7          	jalr	1436(ra) # 80003f2c <namei>
    80005998:	84aa                	mv	s1,a0
    8000599a:	c131                	beqz	a0,800059de <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000599c:	ffffe097          	auipc	ra,0xffffe
    800059a0:	dea080e7          	jalr	-534(ra) # 80003786 <ilock>
  if(ip->type != T_DIR){
    800059a4:	04449703          	lh	a4,68(s1)
    800059a8:	4785                	li	a5,1
    800059aa:	04f71063          	bne	a4,a5,800059ea <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059ae:	8526                	mv	a0,s1
    800059b0:	ffffe097          	auipc	ra,0xffffe
    800059b4:	e98080e7          	jalr	-360(ra) # 80003848 <iunlock>
  iput(p->cwd);
    800059b8:	15093503          	ld	a0,336(s2)
    800059bc:	ffffe097          	auipc	ra,0xffffe
    800059c0:	f84080e7          	jalr	-124(ra) # 80003940 <iput>
  end_op();
    800059c4:	ffffe097          	auipc	ra,0xffffe
    800059c8:	7e2080e7          	jalr	2018(ra) # 800041a6 <end_op>
  p->cwd = ip;
    800059cc:	14993823          	sd	s1,336(s2)
  return 0;
    800059d0:	4501                	li	a0,0
}
    800059d2:	60ea                	ld	ra,152(sp)
    800059d4:	644a                	ld	s0,144(sp)
    800059d6:	64aa                	ld	s1,136(sp)
    800059d8:	690a                	ld	s2,128(sp)
    800059da:	610d                	add	sp,sp,160
    800059dc:	8082                	ret
    end_op();
    800059de:	ffffe097          	auipc	ra,0xffffe
    800059e2:	7c8080e7          	jalr	1992(ra) # 800041a6 <end_op>
    return -1;
    800059e6:	557d                	li	a0,-1
    800059e8:	b7ed                	j	800059d2 <sys_chdir+0x7a>
    iunlockput(ip);
    800059ea:	8526                	mv	a0,s1
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	ffc080e7          	jalr	-4(ra) # 800039e8 <iunlockput>
    end_op();
    800059f4:	ffffe097          	auipc	ra,0xffffe
    800059f8:	7b2080e7          	jalr	1970(ra) # 800041a6 <end_op>
    return -1;
    800059fc:	557d                	li	a0,-1
    800059fe:	bfd1                	j	800059d2 <sys_chdir+0x7a>

0000000080005a00 <sys_exec>:

uint64
sys_exec(void)
{
    80005a00:	7121                	add	sp,sp,-448
    80005a02:	ff06                	sd	ra,440(sp)
    80005a04:	fb22                	sd	s0,432(sp)
    80005a06:	f726                	sd	s1,424(sp)
    80005a08:	f34a                	sd	s2,416(sp)
    80005a0a:	ef4e                	sd	s3,408(sp)
    80005a0c:	eb52                	sd	s4,400(sp)
    80005a0e:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005a10:	e4840593          	add	a1,s0,-440
    80005a14:	4505                	li	a0,1
    80005a16:	ffffd097          	auipc	ra,0xffffd
    80005a1a:	220080e7          	jalr	544(ra) # 80002c36 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005a1e:	08000613          	li	a2,128
    80005a22:	f5040593          	add	a1,s0,-176
    80005a26:	4501                	li	a0,0
    80005a28:	ffffd097          	auipc	ra,0xffffd
    80005a2c:	22e080e7          	jalr	558(ra) # 80002c56 <argstr>
    80005a30:	87aa                	mv	a5,a0
    return -1;
    80005a32:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005a34:	0c07c263          	bltz	a5,80005af8 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005a38:	10000613          	li	a2,256
    80005a3c:	4581                	li	a1,0
    80005a3e:	e5040513          	add	a0,s0,-432
    80005a42:	ffffb097          	auipc	ra,0xffffb
    80005a46:	386080e7          	jalr	902(ra) # 80000dc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a4a:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005a4e:	89a6                	mv	s3,s1
    80005a50:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a52:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a56:	00391513          	sll	a0,s2,0x3
    80005a5a:	e4040593          	add	a1,s0,-448
    80005a5e:	e4843783          	ld	a5,-440(s0)
    80005a62:	953e                	add	a0,a0,a5
    80005a64:	ffffd097          	auipc	ra,0xffffd
    80005a68:	114080e7          	jalr	276(ra) # 80002b78 <fetchaddr>
    80005a6c:	02054a63          	bltz	a0,80005aa0 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005a70:	e4043783          	ld	a5,-448(s0)
    80005a74:	c3b9                	beqz	a5,80005aba <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a76:	ffffb097          	auipc	ra,0xffffb
    80005a7a:	166080e7          	jalr	358(ra) # 80000bdc <kalloc>
    80005a7e:	85aa                	mv	a1,a0
    80005a80:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a84:	cd11                	beqz	a0,80005aa0 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a86:	6605                	lui	a2,0x1
    80005a88:	e4043503          	ld	a0,-448(s0)
    80005a8c:	ffffd097          	auipc	ra,0xffffd
    80005a90:	13e080e7          	jalr	318(ra) # 80002bca <fetchstr>
    80005a94:	00054663          	bltz	a0,80005aa0 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005a98:	0905                	add	s2,s2,1
    80005a9a:	09a1                	add	s3,s3,8
    80005a9c:	fb491de3          	bne	s2,s4,80005a56 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aa0:	f5040913          	add	s2,s0,-176
    80005aa4:	6088                	ld	a0,0(s1)
    80005aa6:	c921                	beqz	a0,80005af6 <sys_exec+0xf6>
    kfree(argv[i]);
    80005aa8:	ffffb097          	auipc	ra,0xffffb
    80005aac:	036080e7          	jalr	54(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ab0:	04a1                	add	s1,s1,8
    80005ab2:	ff2499e3          	bne	s1,s2,80005aa4 <sys_exec+0xa4>
  return -1;
    80005ab6:	557d                	li	a0,-1
    80005ab8:	a081                	j	80005af8 <sys_exec+0xf8>
      argv[i] = 0;
    80005aba:	0009079b          	sext.w	a5,s2
    80005abe:	078e                	sll	a5,a5,0x3
    80005ac0:	fd078793          	add	a5,a5,-48
    80005ac4:	97a2                	add	a5,a5,s0
    80005ac6:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005aca:	e5040593          	add	a1,s0,-432
    80005ace:	f5040513          	add	a0,s0,-176
    80005ad2:	fffff097          	auipc	ra,0xfffff
    80005ad6:	194080e7          	jalr	404(ra) # 80004c66 <exec>
    80005ada:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005adc:	f5040993          	add	s3,s0,-176
    80005ae0:	6088                	ld	a0,0(s1)
    80005ae2:	c901                	beqz	a0,80005af2 <sys_exec+0xf2>
    kfree(argv[i]);
    80005ae4:	ffffb097          	auipc	ra,0xffffb
    80005ae8:	ffa080e7          	jalr	-6(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aec:	04a1                	add	s1,s1,8
    80005aee:	ff3499e3          	bne	s1,s3,80005ae0 <sys_exec+0xe0>
  return ret;
    80005af2:	854a                	mv	a0,s2
    80005af4:	a011                	j	80005af8 <sys_exec+0xf8>
  return -1;
    80005af6:	557d                	li	a0,-1
}
    80005af8:	70fa                	ld	ra,440(sp)
    80005afa:	745a                	ld	s0,432(sp)
    80005afc:	74ba                	ld	s1,424(sp)
    80005afe:	791a                	ld	s2,416(sp)
    80005b00:	69fa                	ld	s3,408(sp)
    80005b02:	6a5a                	ld	s4,400(sp)
    80005b04:	6139                	add	sp,sp,448
    80005b06:	8082                	ret

0000000080005b08 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b08:	7139                	add	sp,sp,-64
    80005b0a:	fc06                	sd	ra,56(sp)
    80005b0c:	f822                	sd	s0,48(sp)
    80005b0e:	f426                	sd	s1,40(sp)
    80005b10:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b12:	ffffc097          	auipc	ra,0xffffc
    80005b16:	fe6080e7          	jalr	-26(ra) # 80001af8 <myproc>
    80005b1a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005b1c:	fd840593          	add	a1,s0,-40
    80005b20:	4501                	li	a0,0
    80005b22:	ffffd097          	auipc	ra,0xffffd
    80005b26:	114080e7          	jalr	276(ra) # 80002c36 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005b2a:	fc840593          	add	a1,s0,-56
    80005b2e:	fd040513          	add	a0,s0,-48
    80005b32:	fffff097          	auipc	ra,0xfffff
    80005b36:	dea080e7          	jalr	-534(ra) # 8000491c <pipealloc>
    return -1;
    80005b3a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b3c:	0c054463          	bltz	a0,80005c04 <sys_pipe+0xfc>
  fd0 = -1;
    80005b40:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b44:	fd043503          	ld	a0,-48(s0)
    80005b48:	fffff097          	auipc	ra,0xfffff
    80005b4c:	524080e7          	jalr	1316(ra) # 8000506c <fdalloc>
    80005b50:	fca42223          	sw	a0,-60(s0)
    80005b54:	08054b63          	bltz	a0,80005bea <sys_pipe+0xe2>
    80005b58:	fc843503          	ld	a0,-56(s0)
    80005b5c:	fffff097          	auipc	ra,0xfffff
    80005b60:	510080e7          	jalr	1296(ra) # 8000506c <fdalloc>
    80005b64:	fca42023          	sw	a0,-64(s0)
    80005b68:	06054863          	bltz	a0,80005bd8 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b6c:	4691                	li	a3,4
    80005b6e:	fc440613          	add	a2,s0,-60
    80005b72:	fd843583          	ld	a1,-40(s0)
    80005b76:	68a8                	ld	a0,80(s1)
    80005b78:	ffffc097          	auipc	ra,0xffffc
    80005b7c:	c0c080e7          	jalr	-1012(ra) # 80001784 <copyout>
    80005b80:	02054063          	bltz	a0,80005ba0 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b84:	4691                	li	a3,4
    80005b86:	fc040613          	add	a2,s0,-64
    80005b8a:	fd843583          	ld	a1,-40(s0)
    80005b8e:	0591                	add	a1,a1,4
    80005b90:	68a8                	ld	a0,80(s1)
    80005b92:	ffffc097          	auipc	ra,0xffffc
    80005b96:	bf2080e7          	jalr	-1038(ra) # 80001784 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b9a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b9c:	06055463          	bgez	a0,80005c04 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005ba0:	fc442783          	lw	a5,-60(s0)
    80005ba4:	07e9                	add	a5,a5,26
    80005ba6:	078e                	sll	a5,a5,0x3
    80005ba8:	97a6                	add	a5,a5,s1
    80005baa:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005bae:	fc042783          	lw	a5,-64(s0)
    80005bb2:	07e9                	add	a5,a5,26
    80005bb4:	078e                	sll	a5,a5,0x3
    80005bb6:	94be                	add	s1,s1,a5
    80005bb8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005bbc:	fd043503          	ld	a0,-48(s0)
    80005bc0:	fffff097          	auipc	ra,0xfffff
    80005bc4:	a30080e7          	jalr	-1488(ra) # 800045f0 <fileclose>
    fileclose(wf);
    80005bc8:	fc843503          	ld	a0,-56(s0)
    80005bcc:	fffff097          	auipc	ra,0xfffff
    80005bd0:	a24080e7          	jalr	-1500(ra) # 800045f0 <fileclose>
    return -1;
    80005bd4:	57fd                	li	a5,-1
    80005bd6:	a03d                	j	80005c04 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005bd8:	fc442783          	lw	a5,-60(s0)
    80005bdc:	0007c763          	bltz	a5,80005bea <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005be0:	07e9                	add	a5,a5,26
    80005be2:	078e                	sll	a5,a5,0x3
    80005be4:	97a6                	add	a5,a5,s1
    80005be6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005bea:	fd043503          	ld	a0,-48(s0)
    80005bee:	fffff097          	auipc	ra,0xfffff
    80005bf2:	a02080e7          	jalr	-1534(ra) # 800045f0 <fileclose>
    fileclose(wf);
    80005bf6:	fc843503          	ld	a0,-56(s0)
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	9f6080e7          	jalr	-1546(ra) # 800045f0 <fileclose>
    return -1;
    80005c02:	57fd                	li	a5,-1
}
    80005c04:	853e                	mv	a0,a5
    80005c06:	70e2                	ld	ra,56(sp)
    80005c08:	7442                	ld	s0,48(sp)
    80005c0a:	74a2                	ld	s1,40(sp)
    80005c0c:	6121                	add	sp,sp,64
    80005c0e:	8082                	ret

0000000080005c10 <kernelvec>:
    80005c10:	7111                	add	sp,sp,-256
    80005c12:	e006                	sd	ra,0(sp)
    80005c14:	e40a                	sd	sp,8(sp)
    80005c16:	e80e                	sd	gp,16(sp)
    80005c18:	ec12                	sd	tp,24(sp)
    80005c1a:	f016                	sd	t0,32(sp)
    80005c1c:	f41a                	sd	t1,40(sp)
    80005c1e:	f81e                	sd	t2,48(sp)
    80005c20:	e4aa                	sd	a0,72(sp)
    80005c22:	e8ae                	sd	a1,80(sp)
    80005c24:	ecb2                	sd	a2,88(sp)
    80005c26:	f0b6                	sd	a3,96(sp)
    80005c28:	f4ba                	sd	a4,104(sp)
    80005c2a:	f8be                	sd	a5,112(sp)
    80005c2c:	fcc2                	sd	a6,120(sp)
    80005c2e:	e146                	sd	a7,128(sp)
    80005c30:	edf2                	sd	t3,216(sp)
    80005c32:	f1f6                	sd	t4,224(sp)
    80005c34:	f5fa                	sd	t5,232(sp)
    80005c36:	f9fe                	sd	t6,240(sp)
    80005c38:	e2dfc0ef          	jal	80002a64 <kerneltrap>
    80005c3c:	6082                	ld	ra,0(sp)
    80005c3e:	6122                	ld	sp,8(sp)
    80005c40:	61c2                	ld	gp,16(sp)
    80005c42:	7282                	ld	t0,32(sp)
    80005c44:	7322                	ld	t1,40(sp)
    80005c46:	73c2                	ld	t2,48(sp)
    80005c48:	6526                	ld	a0,72(sp)
    80005c4a:	65c6                	ld	a1,80(sp)
    80005c4c:	6666                	ld	a2,88(sp)
    80005c4e:	7686                	ld	a3,96(sp)
    80005c50:	7726                	ld	a4,104(sp)
    80005c52:	77c6                	ld	a5,112(sp)
    80005c54:	7866                	ld	a6,120(sp)
    80005c56:	688a                	ld	a7,128(sp)
    80005c58:	6e6e                	ld	t3,216(sp)
    80005c5a:	7e8e                	ld	t4,224(sp)
    80005c5c:	7f2e                	ld	t5,232(sp)
    80005c5e:	7fce                	ld	t6,240(sp)
    80005c60:	6111                	add	sp,sp,256
    80005c62:	10200073          	sret
	...

0000000080005c6e <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    80005c6e:	1141                	add	sp,sp,-16
    80005c70:	e422                	sd	s0,8(sp)
    80005c72:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c74:	0c0007b7          	lui	a5,0xc000
    80005c78:	4705                	li	a4,1
    80005c7a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c7c:	c3d8                	sw	a4,4(a5)
}
    80005c7e:	6422                	ld	s0,8(sp)
    80005c80:	0141                	add	sp,sp,16
    80005c82:	8082                	ret

0000000080005c84 <plicinithart>:

void
plicinithart(void)
{
    80005c84:	1141                	add	sp,sp,-16
    80005c86:	e406                	sd	ra,8(sp)
    80005c88:	e022                	sd	s0,0(sp)
    80005c8a:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005c8c:	ffffc097          	auipc	ra,0xffffc
    80005c90:	e40080e7          	jalr	-448(ra) # 80001acc <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005c94:	0085171b          	sllw	a4,a0,0x8
    80005c98:	0c0027b7          	lui	a5,0xc002
    80005c9c:	97ba                	add	a5,a5,a4
    80005c9e:	40200713          	li	a4,1026
    80005ca2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005ca6:	00d5151b          	sllw	a0,a0,0xd
    80005caa:	0c2017b7          	lui	a5,0xc201
    80005cae:	97aa                	add	a5,a5,a0
    80005cb0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005cb4:	60a2                	ld	ra,8(sp)
    80005cb6:	6402                	ld	s0,0(sp)
    80005cb8:	0141                	add	sp,sp,16
    80005cba:	8082                	ret

0000000080005cbc <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005cbc:	1141                	add	sp,sp,-16
    80005cbe:	e406                	sd	ra,8(sp)
    80005cc0:	e022                	sd	s0,0(sp)
    80005cc2:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005cc4:	ffffc097          	auipc	ra,0xffffc
    80005cc8:	e08080e7          	jalr	-504(ra) # 80001acc <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005ccc:	00d5151b          	sllw	a0,a0,0xd
    80005cd0:	0c2017b7          	lui	a5,0xc201
    80005cd4:	97aa                	add	a5,a5,a0
  return irq;
}
    80005cd6:	43c8                	lw	a0,4(a5)
    80005cd8:	60a2                	ld	ra,8(sp)
    80005cda:	6402                	ld	s0,0(sp)
    80005cdc:	0141                	add	sp,sp,16
    80005cde:	8082                	ret

0000000080005ce0 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    80005ce0:	1101                	add	sp,sp,-32
    80005ce2:	ec06                	sd	ra,24(sp)
    80005ce4:	e822                	sd	s0,16(sp)
    80005ce6:	e426                	sd	s1,8(sp)
    80005ce8:	1000                	add	s0,sp,32
    80005cea:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005cec:	ffffc097          	auipc	ra,0xffffc
    80005cf0:	de0080e7          	jalr	-544(ra) # 80001acc <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005cf4:	00d5151b          	sllw	a0,a0,0xd
    80005cf8:	0c2017b7          	lui	a5,0xc201
    80005cfc:	97aa                	add	a5,a5,a0
    80005cfe:	c3c4                	sw	s1,4(a5)
}
    80005d00:	60e2                	ld	ra,24(sp)
    80005d02:	6442                	ld	s0,16(sp)
    80005d04:	64a2                	ld	s1,8(sp)
    80005d06:	6105                	add	sp,sp,32
    80005d08:	8082                	ret

0000000080005d0a <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    80005d0a:	1141                	add	sp,sp,-16
    80005d0c:	e406                	sd	ra,8(sp)
    80005d0e:	e022                	sd	s0,0(sp)
    80005d10:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005d12:	479d                	li	a5,7
    80005d14:	04a7cc63          	blt	a5,a0,80005d6c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005d18:	0001c797          	auipc	a5,0x1c
    80005d1c:	de878793          	add	a5,a5,-536 # 80021b00 <disk>
    80005d20:	97aa                	add	a5,a5,a0
    80005d22:	0187c783          	lbu	a5,24(a5)
    80005d26:	ebb9                	bnez	a5,80005d7c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005d28:	00451693          	sll	a3,a0,0x4
    80005d2c:	0001c797          	auipc	a5,0x1c
    80005d30:	dd478793          	add	a5,a5,-556 # 80021b00 <disk>
    80005d34:	6398                	ld	a4,0(a5)
    80005d36:	9736                	add	a4,a4,a3
    80005d38:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005d3c:	6398                	ld	a4,0(a5)
    80005d3e:	9736                	add	a4,a4,a3
    80005d40:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005d44:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005d48:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005d4c:	97aa                	add	a5,a5,a0
    80005d4e:	4705                	li	a4,1
    80005d50:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005d54:	0001c517          	auipc	a0,0x1c
    80005d58:	dc450513          	add	a0,a0,-572 # 80021b18 <disk+0x18>
    80005d5c:	ffffc097          	auipc	ra,0xffffc
    80005d60:	4cc080e7          	jalr	1228(ra) # 80002228 <wakeup>
}
    80005d64:	60a2                	ld	ra,8(sp)
    80005d66:	6402                	ld	s0,0(sp)
    80005d68:	0141                	add	sp,sp,16
    80005d6a:	8082                	ret
    panic("free_desc 1");
    80005d6c:	00003517          	auipc	a0,0x3
    80005d70:	a1450513          	add	a0,a0,-1516 # 80008780 <syscalls+0x2f0>
    80005d74:	ffffb097          	auipc	ra,0xffffb
    80005d78:	a9a080e7          	jalr	-1382(ra) # 8000080e <panic>
    panic("free_desc 2");
    80005d7c:	00003517          	auipc	a0,0x3
    80005d80:	a1450513          	add	a0,a0,-1516 # 80008790 <syscalls+0x300>
    80005d84:	ffffb097          	auipc	ra,0xffffb
    80005d88:	a8a080e7          	jalr	-1398(ra) # 8000080e <panic>

0000000080005d8c <virtio_disk_init>:
{
    80005d8c:	1101                	add	sp,sp,-32
    80005d8e:	ec06                	sd	ra,24(sp)
    80005d90:	e822                	sd	s0,16(sp)
    80005d92:	e426                	sd	s1,8(sp)
    80005d94:	e04a                	sd	s2,0(sp)
    80005d96:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005d98:	00003597          	auipc	a1,0x3
    80005d9c:	a0858593          	add	a1,a1,-1528 # 800087a0 <syscalls+0x310>
    80005da0:	0001c517          	auipc	a0,0x1c
    80005da4:	e8850513          	add	a0,a0,-376 # 80021c28 <disk+0x128>
    80005da8:	ffffb097          	auipc	ra,0xffffb
    80005dac:	e94080e7          	jalr	-364(ra) # 80000c3c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005db0:	100017b7          	lui	a5,0x10001
    80005db4:	4398                	lw	a4,0(a5)
    80005db6:	2701                	sext.w	a4,a4
    80005db8:	747277b7          	lui	a5,0x74727
    80005dbc:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005dc0:	14f71b63          	bne	a4,a5,80005f16 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dc4:	100017b7          	lui	a5,0x10001
    80005dc8:	43dc                	lw	a5,4(a5)
    80005dca:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dcc:	4709                	li	a4,2
    80005dce:	14e79463          	bne	a5,a4,80005f16 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dd2:	100017b7          	lui	a5,0x10001
    80005dd6:	479c                	lw	a5,8(a5)
    80005dd8:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dda:	12e79e63          	bne	a5,a4,80005f16 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005dde:	100017b7          	lui	a5,0x10001
    80005de2:	47d8                	lw	a4,12(a5)
    80005de4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005de6:	554d47b7          	lui	a5,0x554d4
    80005dea:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005dee:	12f71463          	bne	a4,a5,80005f16 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df2:	100017b7          	lui	a5,0x10001
    80005df6:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dfa:	4705                	li	a4,1
    80005dfc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dfe:	470d                	li	a4,3
    80005e00:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e02:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e04:	c7ffe6b7          	lui	a3,0xc7ffe
    80005e08:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdcb1f>
    80005e0c:	8f75                	and	a4,a4,a3
    80005e0e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e10:	472d                	li	a4,11
    80005e12:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005e14:	5bbc                	lw	a5,112(a5)
    80005e16:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005e1a:	8ba1                	and	a5,a5,8
    80005e1c:	10078563          	beqz	a5,80005f26 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e20:	100017b7          	lui	a5,0x10001
    80005e24:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005e28:	43fc                	lw	a5,68(a5)
    80005e2a:	2781                	sext.w	a5,a5
    80005e2c:	10079563          	bnez	a5,80005f36 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e30:	100017b7          	lui	a5,0x10001
    80005e34:	5bdc                	lw	a5,52(a5)
    80005e36:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e38:	10078763          	beqz	a5,80005f46 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005e3c:	471d                	li	a4,7
    80005e3e:	10f77c63          	bgeu	a4,a5,80005f56 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005e42:	ffffb097          	auipc	ra,0xffffb
    80005e46:	d9a080e7          	jalr	-614(ra) # 80000bdc <kalloc>
    80005e4a:	0001c497          	auipc	s1,0x1c
    80005e4e:	cb648493          	add	s1,s1,-842 # 80021b00 <disk>
    80005e52:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005e54:	ffffb097          	auipc	ra,0xffffb
    80005e58:	d88080e7          	jalr	-632(ra) # 80000bdc <kalloc>
    80005e5c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005e5e:	ffffb097          	auipc	ra,0xffffb
    80005e62:	d7e080e7          	jalr	-642(ra) # 80000bdc <kalloc>
    80005e66:	87aa                	mv	a5,a0
    80005e68:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005e6a:	6088                	ld	a0,0(s1)
    80005e6c:	cd6d                	beqz	a0,80005f66 <virtio_disk_init+0x1da>
    80005e6e:	0001c717          	auipc	a4,0x1c
    80005e72:	c9a73703          	ld	a4,-870(a4) # 80021b08 <disk+0x8>
    80005e76:	cb65                	beqz	a4,80005f66 <virtio_disk_init+0x1da>
    80005e78:	c7fd                	beqz	a5,80005f66 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005e7a:	6605                	lui	a2,0x1
    80005e7c:	4581                	li	a1,0
    80005e7e:	ffffb097          	auipc	ra,0xffffb
    80005e82:	f4a080e7          	jalr	-182(ra) # 80000dc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005e86:	0001c497          	auipc	s1,0x1c
    80005e8a:	c7a48493          	add	s1,s1,-902 # 80021b00 <disk>
    80005e8e:	6605                	lui	a2,0x1
    80005e90:	4581                	li	a1,0
    80005e92:	6488                	ld	a0,8(s1)
    80005e94:	ffffb097          	auipc	ra,0xffffb
    80005e98:	f34080e7          	jalr	-204(ra) # 80000dc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005e9c:	6605                	lui	a2,0x1
    80005e9e:	4581                	li	a1,0
    80005ea0:	6888                	ld	a0,16(s1)
    80005ea2:	ffffb097          	auipc	ra,0xffffb
    80005ea6:	f26080e7          	jalr	-218(ra) # 80000dc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005eaa:	100017b7          	lui	a5,0x10001
    80005eae:	4721                	li	a4,8
    80005eb0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005eb2:	4098                	lw	a4,0(s1)
    80005eb4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005eb8:	40d8                	lw	a4,4(s1)
    80005eba:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005ebe:	6498                	ld	a4,8(s1)
    80005ec0:	0007069b          	sext.w	a3,a4
    80005ec4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005ec8:	9701                	sra	a4,a4,0x20
    80005eca:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005ece:	6898                	ld	a4,16(s1)
    80005ed0:	0007069b          	sext.w	a3,a4
    80005ed4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005ed8:	9701                	sra	a4,a4,0x20
    80005eda:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005ede:	4705                	li	a4,1
    80005ee0:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005ee2:	00e48c23          	sb	a4,24(s1)
    80005ee6:	00e48ca3          	sb	a4,25(s1)
    80005eea:	00e48d23          	sb	a4,26(s1)
    80005eee:	00e48da3          	sb	a4,27(s1)
    80005ef2:	00e48e23          	sb	a4,28(s1)
    80005ef6:	00e48ea3          	sb	a4,29(s1)
    80005efa:	00e48f23          	sb	a4,30(s1)
    80005efe:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005f02:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f06:	0727a823          	sw	s2,112(a5)
}
    80005f0a:	60e2                	ld	ra,24(sp)
    80005f0c:	6442                	ld	s0,16(sp)
    80005f0e:	64a2                	ld	s1,8(sp)
    80005f10:	6902                	ld	s2,0(sp)
    80005f12:	6105                	add	sp,sp,32
    80005f14:	8082                	ret
    panic("could not find virtio disk");
    80005f16:	00003517          	auipc	a0,0x3
    80005f1a:	89a50513          	add	a0,a0,-1894 # 800087b0 <syscalls+0x320>
    80005f1e:	ffffb097          	auipc	ra,0xffffb
    80005f22:	8f0080e7          	jalr	-1808(ra) # 8000080e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005f26:	00003517          	auipc	a0,0x3
    80005f2a:	8aa50513          	add	a0,a0,-1878 # 800087d0 <syscalls+0x340>
    80005f2e:	ffffb097          	auipc	ra,0xffffb
    80005f32:	8e0080e7          	jalr	-1824(ra) # 8000080e <panic>
    panic("virtio disk should not be ready");
    80005f36:	00003517          	auipc	a0,0x3
    80005f3a:	8ba50513          	add	a0,a0,-1862 # 800087f0 <syscalls+0x360>
    80005f3e:	ffffb097          	auipc	ra,0xffffb
    80005f42:	8d0080e7          	jalr	-1840(ra) # 8000080e <panic>
    panic("virtio disk has no queue 0");
    80005f46:	00003517          	auipc	a0,0x3
    80005f4a:	8ca50513          	add	a0,a0,-1846 # 80008810 <syscalls+0x380>
    80005f4e:	ffffb097          	auipc	ra,0xffffb
    80005f52:	8c0080e7          	jalr	-1856(ra) # 8000080e <panic>
    panic("virtio disk max queue too short");
    80005f56:	00003517          	auipc	a0,0x3
    80005f5a:	8da50513          	add	a0,a0,-1830 # 80008830 <syscalls+0x3a0>
    80005f5e:	ffffb097          	auipc	ra,0xffffb
    80005f62:	8b0080e7          	jalr	-1872(ra) # 8000080e <panic>
    panic("virtio disk kalloc");
    80005f66:	00003517          	auipc	a0,0x3
    80005f6a:	8ea50513          	add	a0,a0,-1814 # 80008850 <syscalls+0x3c0>
    80005f6e:	ffffb097          	auipc	ra,0xffffb
    80005f72:	8a0080e7          	jalr	-1888(ra) # 8000080e <panic>

0000000080005f76 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f76:	7159                	add	sp,sp,-112
    80005f78:	f486                	sd	ra,104(sp)
    80005f7a:	f0a2                	sd	s0,96(sp)
    80005f7c:	eca6                	sd	s1,88(sp)
    80005f7e:	e8ca                	sd	s2,80(sp)
    80005f80:	e4ce                	sd	s3,72(sp)
    80005f82:	e0d2                	sd	s4,64(sp)
    80005f84:	fc56                	sd	s5,56(sp)
    80005f86:	f85a                	sd	s6,48(sp)
    80005f88:	f45e                	sd	s7,40(sp)
    80005f8a:	f062                	sd	s8,32(sp)
    80005f8c:	ec66                	sd	s9,24(sp)
    80005f8e:	e86a                	sd	s10,16(sp)
    80005f90:	1880                	add	s0,sp,112
    80005f92:	8a2a                	mv	s4,a0
    80005f94:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f96:	00c52c83          	lw	s9,12(a0)
    80005f9a:	001c9c9b          	sllw	s9,s9,0x1
    80005f9e:	1c82                	sll	s9,s9,0x20
    80005fa0:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005fa4:	0001c517          	auipc	a0,0x1c
    80005fa8:	c8450513          	add	a0,a0,-892 # 80021c28 <disk+0x128>
    80005fac:	ffffb097          	auipc	ra,0xffffb
    80005fb0:	d20080e7          	jalr	-736(ra) # 80000ccc <acquire>
  for(int i = 0; i < 3; i++){
    80005fb4:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005fb6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005fb8:	0001cb17          	auipc	s6,0x1c
    80005fbc:	b48b0b13          	add	s6,s6,-1208 # 80021b00 <disk>
  for(int i = 0; i < 3; i++){
    80005fc0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005fc2:	0001cc17          	auipc	s8,0x1c
    80005fc6:	c66c0c13          	add	s8,s8,-922 # 80021c28 <disk+0x128>
    80005fca:	a095                	j	8000602e <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005fcc:	00fb0733          	add	a4,s6,a5
    80005fd0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005fd4:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005fd6:	0207c563          	bltz	a5,80006000 <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005fda:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005fdc:	0591                	add	a1,a1,4
    80005fde:	05560d63          	beq	a2,s5,80006038 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005fe2:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005fe4:	0001c717          	auipc	a4,0x1c
    80005fe8:	b1c70713          	add	a4,a4,-1252 # 80021b00 <disk>
    80005fec:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005fee:	01874683          	lbu	a3,24(a4)
    80005ff2:	fee9                	bnez	a3,80005fcc <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005ff4:	2785                	addw	a5,a5,1
    80005ff6:	0705                	add	a4,a4,1
    80005ff8:	fe979be3          	bne	a5,s1,80005fee <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005ffc:	57fd                	li	a5,-1
    80005ffe:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80006000:	00c05e63          	blez	a2,8000601c <virtio_disk_rw+0xa6>
    80006004:	060a                	sll	a2,a2,0x2
    80006006:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000600a:	0009a503          	lw	a0,0(s3)
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	cfc080e7          	jalr	-772(ra) # 80005d0a <free_desc>
      for(int j = 0; j < i; j++)
    80006016:	0991                	add	s3,s3,4
    80006018:	ffa999e3          	bne	s3,s10,8000600a <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000601c:	85e2                	mv	a1,s8
    8000601e:	0001c517          	auipc	a0,0x1c
    80006022:	afa50513          	add	a0,a0,-1286 # 80021b18 <disk+0x18>
    80006026:	ffffc097          	auipc	ra,0xffffc
    8000602a:	19e080e7          	jalr	414(ra) # 800021c4 <sleep>
  for(int i = 0; i < 3; i++){
    8000602e:	f9040993          	add	s3,s0,-112
{
    80006032:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006034:	864a                	mv	a2,s2
    80006036:	b775                	j	80005fe2 <virtio_disk_rw+0x6c>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006038:	f9042503          	lw	a0,-112(s0)
    8000603c:	00a50713          	add	a4,a0,10
    80006040:	0712                	sll	a4,a4,0x4

  if(write)
    80006042:	0001c797          	auipc	a5,0x1c
    80006046:	abe78793          	add	a5,a5,-1346 # 80021b00 <disk>
    8000604a:	00e786b3          	add	a3,a5,a4
    8000604e:	01703633          	snez	a2,s7
    80006052:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    80006054:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006058:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000605c:	f6070613          	add	a2,a4,-160
    80006060:	6394                	ld	a3,0(a5)
    80006062:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006064:	00870593          	add	a1,a4,8
    80006068:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000606a:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000606c:	0007b803          	ld	a6,0(a5)
    80006070:	9642                	add	a2,a2,a6
    80006072:	46c1                	li	a3,16
    80006074:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006076:	4585                	li	a1,1
    80006078:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    8000607c:	f9442683          	lw	a3,-108(s0)
    80006080:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006084:	0692                	sll	a3,a3,0x4
    80006086:	9836                	add	a6,a6,a3
    80006088:	058a0613          	add	a2,s4,88
    8000608c:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80006090:	0007b803          	ld	a6,0(a5)
    80006094:	96c2                	add	a3,a3,a6
    80006096:	40000613          	li	a2,1024
    8000609a:	c690                	sw	a2,8(a3)
  if(write)
    8000609c:	001bb613          	seqz	a2,s7
    800060a0:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800060a4:	00166613          	or	a2,a2,1
    800060a8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800060ac:	f9842603          	lw	a2,-104(s0)
    800060b0:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    800060b4:	00250693          	add	a3,a0,2
    800060b8:	0692                	sll	a3,a3,0x4
    800060ba:	96be                	add	a3,a3,a5
    800060bc:	58fd                	li	a7,-1
    800060be:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800060c2:	0612                	sll	a2,a2,0x4
    800060c4:	9832                	add	a6,a6,a2
    800060c6:	f9070713          	add	a4,a4,-112
    800060ca:	973e                	add	a4,a4,a5
    800060cc:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800060d0:	6398                	ld	a4,0(a5)
    800060d2:	9732                	add	a4,a4,a2
    800060d4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    800060d6:	4609                	li	a2,2
    800060d8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800060dc:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    800060e0:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800060e4:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800060e8:	6794                	ld	a3,8(a5)
    800060ea:	0026d703          	lhu	a4,2(a3)
    800060ee:	8b1d                	and	a4,a4,7
    800060f0:	0706                	sll	a4,a4,0x1
    800060f2:	96ba                	add	a3,a3,a4
    800060f4:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800060f8:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    800060fc:	6798                	ld	a4,8(a5)
    800060fe:	00275783          	lhu	a5,2(a4)
    80006102:	2785                	addw	a5,a5,1
    80006104:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006108:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    8000610c:	100017b7          	lui	a5,0x10001
    80006110:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    80006114:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006118:	0001c917          	auipc	s2,0x1c
    8000611c:	b1090913          	add	s2,s2,-1264 # 80021c28 <disk+0x128>
  while(b->disk == 1) {
    80006120:	4485                	li	s1,1
    80006122:	00b79c63          	bne	a5,a1,8000613a <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006126:	85ca                	mv	a1,s2
    80006128:	8552                	mv	a0,s4
    8000612a:	ffffc097          	auipc	ra,0xffffc
    8000612e:	09a080e7          	jalr	154(ra) # 800021c4 <sleep>
  while(b->disk == 1) {
    80006132:	004a2783          	lw	a5,4(s4)
    80006136:	fe9788e3          	beq	a5,s1,80006126 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000613a:	f9042903          	lw	s2,-112(s0)
    8000613e:	00290713          	add	a4,s2,2
    80006142:	0712                	sll	a4,a4,0x4
    80006144:	0001c797          	auipc	a5,0x1c
    80006148:	9bc78793          	add	a5,a5,-1604 # 80021b00 <disk>
    8000614c:	97ba                	add	a5,a5,a4
    8000614e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006152:	0001c997          	auipc	s3,0x1c
    80006156:	9ae98993          	add	s3,s3,-1618 # 80021b00 <disk>
    8000615a:	00491713          	sll	a4,s2,0x4
    8000615e:	0009b783          	ld	a5,0(s3)
    80006162:	97ba                	add	a5,a5,a4
    80006164:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006168:	854a                	mv	a0,s2
    8000616a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	b9c080e7          	jalr	-1124(ra) # 80005d0a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006176:	8885                	and	s1,s1,1
    80006178:	f0ed                	bnez	s1,8000615a <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000617a:	0001c517          	auipc	a0,0x1c
    8000617e:	aae50513          	add	a0,a0,-1362 # 80021c28 <disk+0x128>
    80006182:	ffffb097          	auipc	ra,0xffffb
    80006186:	bfe080e7          	jalr	-1026(ra) # 80000d80 <release>
}
    8000618a:	70a6                	ld	ra,104(sp)
    8000618c:	7406                	ld	s0,96(sp)
    8000618e:	64e6                	ld	s1,88(sp)
    80006190:	6946                	ld	s2,80(sp)
    80006192:	69a6                	ld	s3,72(sp)
    80006194:	6a06                	ld	s4,64(sp)
    80006196:	7ae2                	ld	s5,56(sp)
    80006198:	7b42                	ld	s6,48(sp)
    8000619a:	7ba2                	ld	s7,40(sp)
    8000619c:	7c02                	ld	s8,32(sp)
    8000619e:	6ce2                	ld	s9,24(sp)
    800061a0:	6d42                	ld	s10,16(sp)
    800061a2:	6165                	add	sp,sp,112
    800061a4:	8082                	ret

00000000800061a6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800061a6:	1101                	add	sp,sp,-32
    800061a8:	ec06                	sd	ra,24(sp)
    800061aa:	e822                	sd	s0,16(sp)
    800061ac:	e426                	sd	s1,8(sp)
    800061ae:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800061b0:	0001c497          	auipc	s1,0x1c
    800061b4:	95048493          	add	s1,s1,-1712 # 80021b00 <disk>
    800061b8:	0001c517          	auipc	a0,0x1c
    800061bc:	a7050513          	add	a0,a0,-1424 # 80021c28 <disk+0x128>
    800061c0:	ffffb097          	auipc	ra,0xffffb
    800061c4:	b0c080e7          	jalr	-1268(ra) # 80000ccc <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800061c8:	10001737          	lui	a4,0x10001
    800061cc:	533c                	lw	a5,96(a4)
    800061ce:	8b8d                	and	a5,a5,3
    800061d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800061d2:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    800061d6:	689c                	ld	a5,16(s1)
    800061d8:	0204d703          	lhu	a4,32(s1)
    800061dc:	0027d783          	lhu	a5,2(a5)
    800061e0:	04f70863          	beq	a4,a5,80006230 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800061e4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800061e8:	6898                	ld	a4,16(s1)
    800061ea:	0204d783          	lhu	a5,32(s1)
    800061ee:	8b9d                	and	a5,a5,7
    800061f0:	078e                	sll	a5,a5,0x3
    800061f2:	97ba                	add	a5,a5,a4
    800061f4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800061f6:	00278713          	add	a4,a5,2
    800061fa:	0712                	sll	a4,a4,0x4
    800061fc:	9726                	add	a4,a4,s1
    800061fe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006202:	e721                	bnez	a4,8000624a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006204:	0789                	add	a5,a5,2
    80006206:	0792                	sll	a5,a5,0x4
    80006208:	97a6                	add	a5,a5,s1
    8000620a:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    8000620c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006210:	ffffc097          	auipc	ra,0xffffc
    80006214:	018080e7          	jalr	24(ra) # 80002228 <wakeup>

    disk.used_idx += 1;
    80006218:	0204d783          	lhu	a5,32(s1)
    8000621c:	2785                	addw	a5,a5,1
    8000621e:	17c2                	sll	a5,a5,0x30
    80006220:	93c1                	srl	a5,a5,0x30
    80006222:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006226:	6898                	ld	a4,16(s1)
    80006228:	00275703          	lhu	a4,2(a4)
    8000622c:	faf71ce3          	bne	a4,a5,800061e4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006230:	0001c517          	auipc	a0,0x1c
    80006234:	9f850513          	add	a0,a0,-1544 # 80021c28 <disk+0x128>
    80006238:	ffffb097          	auipc	ra,0xffffb
    8000623c:	b48080e7          	jalr	-1208(ra) # 80000d80 <release>
}
    80006240:	60e2                	ld	ra,24(sp)
    80006242:	6442                	ld	s0,16(sp)
    80006244:	64a2                	ld	s1,8(sp)
    80006246:	6105                	add	sp,sp,32
    80006248:	8082                	ret
      panic("virtio_disk_intr status");
    8000624a:	00002517          	auipc	a0,0x2
    8000624e:	61e50513          	add	a0,a0,1566 # 80008868 <syscalls+0x3d8>
    80006252:	ffffa097          	auipc	ra,0xffffa
    80006256:	5bc080e7          	jalr	1468(ra) # 8000080e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
