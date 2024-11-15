
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc54f>
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
    800000fe:	00003097          	auipc	ra,0x3
    80000102:	960080e7          	jalr	-1696(ra) # 80002a5e <either_copyin>
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
    8000018c:	8c2080e7          	jalr	-1854(ra) # 80001a4a <myproc>
    80000190:	00002097          	auipc	ra,0x2
    80000194:	718080e7          	jalr	1816(ra) # 800028a8 <killed>
    80000198:	ed2d                	bnez	a0,80000212 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    8000019a:	85a6                	mv	a1,s1
    8000019c:	854a                	mv	a0,s2
    8000019e:	00002097          	auipc	ra,0x2
    800001a2:	432080e7          	jalr	1074(ra) # 800025d0 <sleep>
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
    800001e4:	00003097          	auipc	ra,0x3
    800001e8:	824080e7          	jalr	-2012(ra) # 80002a08 <either_copyout>
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
    800002c6:	7f2080e7          	jalr	2034(ra) # 80002ab4 <procdump>
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
    8000041a:	21e080e7          	jalr	542(ra) # 80002634 <wakeup>
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
    80000448:	00021797          	auipc	a5,0x21
    8000044c:	cd078793          	add	a5,a5,-816 # 80021118 <devsw>
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
    8000097e:	cba080e7          	jalr	-838(ra) # 80002634 <wakeup>
    
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
    80000a14:	00002097          	auipc	ra,0x2
    80000a18:	bbc080e7          	jalr	-1092(ra) # 800025d0 <sleep>
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
    80000af6:	7be78793          	add	a5,a5,1982 # 800222b0 <end>
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
    80000bc8:	6ec50513          	add	a0,a0,1772 # 800222b0 <end>
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
    80000c6a:	dc2080e7          	jalr	-574(ra) # 80001a28 <mycpu>
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
    80000c9c:	d90080e7          	jalr	-624(ra) # 80001a28 <mycpu>
    80000ca0:	5d3c                	lw	a5,120(a0)
    80000ca2:	cf89                	beqz	a5,80000cbc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ca4:	00001097          	auipc	ra,0x1
    80000ca8:	d84080e7          	jalr	-636(ra) # 80001a28 <mycpu>
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
    80000cc0:	d6c080e7          	jalr	-660(ra) # 80001a28 <mycpu>
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
    80000d00:	d2c080e7          	jalr	-724(ra) # 80001a28 <mycpu>
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
    80000d2c:	d00080e7          	jalr	-768(ra) # 80001a28 <mycpu>
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
    80000e3c:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcd51>
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
    80000f78:	aa4080e7          	jalr	-1372(ra) # 80001a18 <cpuid>
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
    80000f94:	a88080e7          	jalr	-1400(ra) # 80001a18 <cpuid>
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
    80000fb6:	c44080e7          	jalr	-956(ra) # 80002bf6 <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	10a080e7          	jalr	266(ra) # 800060c4 <plicinithart>
  }

  scheduler();        
    80000fc2:	00001097          	auipc	ra,0x1
    80000fc6:	d5c080e7          	jalr	-676(ra) # 80001d1e <scheduler>
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
    80001026:	b22080e7          	jalr	-1246(ra) # 80001b44 <procinit>
    trapinit();      /* trap vectors */
    8000102a:	00002097          	auipc	ra,0x2
    8000102e:	ba4080e7          	jalr	-1116(ra) # 80002bce <trapinit>
    trapinithart();  /* install kernel trap vector */
    80001032:	00002097          	auipc	ra,0x2
    80001036:	bc4080e7          	jalr	-1084(ra) # 80002bf6 <trapinithart>
    plicinit();      /* set up interrupt controller */
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	074080e7          	jalr	116(ra) # 800060ae <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80001042:	00005097          	auipc	ra,0x5
    80001046:	082080e7          	jalr	130(ra) # 800060c4 <plicinithart>
    binit();         /* buffer cache */
    8000104a:	00002097          	auipc	ra,0x2
    8000104e:	2da080e7          	jalr	730(ra) # 80003324 <binit>
    iinit();         /* inode table */
    80001052:	00003097          	auipc	ra,0x3
    80001056:	978080e7          	jalr	-1672(ra) # 800039ca <iinit>
    fileinit();      /* file table */
    8000105a:	00004097          	auipc	ra,0x4
    8000105e:	8ee080e7          	jalr	-1810(ra) # 80004948 <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80001062:	00005097          	auipc	ra,0x5
    80001066:	16a080e7          	jalr	362(ra) # 800061cc <virtio_disk_init>
    userinit();      /* first user process */
    8000106a:	00001097          	auipc	ra,0x1
    8000106e:	08e080e7          	jalr	142(ra) # 800020f8 <userinit>
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
    8000110a:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcd47>
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
    80001966:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffdcd4f>
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
void timer_interrupt(void); /* UPDATED [2024-11-13] : 13:35:00 */

/* Allocate a page for each process's kernel stack */
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
    8000199c:	53848493          	add	s1,s1,1336 # 80010ed0 <proc>
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
    800019b6:	51ea0a13          	add	s4,s4,1310 # 80016ed0 <tickslock>
    char *pa = kalloc();
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	222080e7          	jalr	546(ra) # 80000bdc <kalloc>
    800019c2:	862a                	mv	a2,a0
    if(pa == 0)
    800019c4:	c131                	beqz	a0,80001a08 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800019c6:	416485b3          	sub	a1,s1,s6
    800019ca:	859d                	sra	a1,a1,0x7
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
    800019ec:	18048493          	add	s1,s1,384
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

0000000080001a18 <cpuid>:
/* Must be called with interrupts disabled, */
/* to prevent race with process being moved */
/* to a different CPU. */
int
cpuid()
{
    80001a18:	1141                	add	sp,sp,-16
    80001a1a:	e422                	sd	s0,8(sp)
    80001a1c:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a20:	2501                	sext.w	a0,a0
    80001a22:	6422                	ld	s0,8(sp)
    80001a24:	0141                	add	sp,sp,16
    80001a26:	8082                	ret

0000000080001a28 <mycpu>:

/* Return this CPU's cpu struct. */
/* Interrupts must be disabled. */
struct cpu*
mycpu(void)
{
    80001a28:	1141                	add	sp,sp,-16
    80001a2a:	e422                	sd	s0,8(sp)
    80001a2c:	0800                	add	s0,sp,16
    80001a2e:	8712                	mv	a4,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a30:	2701                	sext.w	a4,a4
    80001a32:	00471793          	sll	a5,a4,0x4
    80001a36:	97ba                	add	a5,a5,a4
    80001a38:	078e                	sll	a5,a5,0x3
  return c;
}
    80001a3a:	0000f517          	auipc	a0,0xf
    80001a3e:	ff650513          	add	a0,a0,-10 # 80010a30 <cpus>
    80001a42:	953e                	add	a0,a0,a5
    80001a44:	6422                	ld	s0,8(sp)
    80001a46:	0141                	add	sp,sp,16
    80001a48:	8082                	ret

0000000080001a4a <myproc>:

/* Return the current struct proc *, or zero if none. */
struct proc*
myproc(void)
{
    80001a4a:	1101                	add	sp,sp,-32
    80001a4c:	ec06                	sd	ra,24(sp)
    80001a4e:	e822                	sd	s0,16(sp)
    80001a50:	e426                	sd	s1,8(sp)
    80001a52:	1000                	add	s0,sp,32
  push_off();
    80001a54:	fffff097          	auipc	ra,0xfffff
    80001a58:	22c080e7          	jalr	556(ra) # 80000c80 <push_off>
    80001a5c:	8712                	mv	a4,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a5e:	2701                	sext.w	a4,a4
    80001a60:	00471793          	sll	a5,a4,0x4
    80001a64:	97ba                	add	a5,a5,a4
    80001a66:	078e                	sll	a5,a5,0x3
    80001a68:	0000f717          	auipc	a4,0xf
    80001a6c:	fc870713          	add	a4,a4,-56 # 80010a30 <cpus>
    80001a70:	97ba                	add	a5,a5,a4
    80001a72:	6384                	ld	s1,0(a5)
  pop_off();
    80001a74:	fffff097          	auipc	ra,0xfffff
    80001a78:	2ac080e7          	jalr	684(ra) # 80000d20 <pop_off>
  return p;
}
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	60e2                	ld	ra,24(sp)
    80001a80:	6442                	ld	s0,16(sp)
    80001a82:	64a2                	ld	s1,8(sp)
    80001a84:	6105                	add	sp,sp,32
    80001a86:	8082                	ret

0000000080001a88 <forkret>:

/* A fork child's very first scheduling by scheduler() */
 /* will swtch to forkret. */
void
forkret(void)
{
    80001a88:	1141                	add	sp,sp,-16
    80001a8a:	e406                	sd	ra,8(sp)
    80001a8c:	e022                	sd	s0,0(sp)
    80001a8e:	0800                	add	s0,sp,16
  static int first = 1;

  /* Still holding p->lock from scheduler. */
  release(&myproc()->lock);
    80001a90:	00000097          	auipc	ra,0x0
    80001a94:	fba080e7          	jalr	-70(ra) # 80001a4a <myproc>
    80001a98:	fffff097          	auipc	ra,0xfffff
    80001a9c:	2e8080e7          	jalr	744(ra) # 80000d80 <release>

  if (first) {
    80001aa0:	00007797          	auipc	a5,0x7
    80001aa4:	de07a783          	lw	a5,-544(a5) # 80008880 <first.1>
    80001aa8:	eb89                	bnez	a5,80001aba <forkret+0x32>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    80001aaa:	00001097          	auipc	ra,0x1
    80001aae:	164080e7          	jalr	356(ra) # 80002c0e <usertrapret>
}
    80001ab2:	60a2                	ld	ra,8(sp)
    80001ab4:	6402                	ld	s0,0(sp)
    80001ab6:	0141                	add	sp,sp,16
    80001ab8:	8082                	ret
    fsinit(ROOTDEV);
    80001aba:	4505                	li	a0,1
    80001abc:	00002097          	auipc	ra,0x2
    80001ac0:	e8e080e7          	jalr	-370(ra) # 8000394a <fsinit>
    first = 0;
    80001ac4:	00007797          	auipc	a5,0x7
    80001ac8:	da07ae23          	sw	zero,-580(a5) # 80008880 <first.1>
    __sync_synchronize();
    80001acc:	0ff0000f          	fence
    80001ad0:	bfe9                	j	80001aaa <forkret+0x22>

0000000080001ad2 <allocpid>:
{
    80001ad2:	1101                	add	sp,sp,-32
    80001ad4:	ec06                	sd	ra,24(sp)
    80001ad6:	e822                	sd	s0,16(sp)
    80001ad8:	e426                	sd	s1,8(sp)
    80001ada:	e04a                	sd	s2,0(sp)
    80001adc:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001ade:	0000f917          	auipc	s2,0xf
    80001ae2:	39290913          	add	s2,s2,914 # 80010e70 <pid_lock>
    80001ae6:	854a                	mv	a0,s2
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	1e4080e7          	jalr	484(ra) # 80000ccc <acquire>
  pid = nextpid;
    80001af0:	00007797          	auipc	a5,0x7
    80001af4:	d9478793          	add	a5,a5,-620 # 80008884 <nextpid>
    80001af8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001afa:	0014871b          	addw	a4,s1,1
    80001afe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b00:	854a                	mv	a0,s2
    80001b02:	fffff097          	auipc	ra,0xfffff
    80001b06:	27e080e7          	jalr	638(ra) # 80000d80 <release>
}
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6902                	ld	s2,0(sp)
    80001b14:	6105                	add	sp,sp,32
    80001b16:	8082                	ret

0000000080001b18 <init_ready_queues>:
void init_ready_queues(void) { /* UPDATED [2024-11-13] : 13:35:00 */
    80001b18:	1141                	add	sp,sp,-16
    80001b1a:	e422                	sd	s0,8(sp)
    80001b1c:	0800                	add	s0,sp,16
    ready_queues[i].head = 0;
    80001b1e:	0000f797          	auipc	a5,0xf
    80001b22:	f1278793          	add	a5,a5,-238 # 80010a30 <cpus>
    80001b26:	4407bc23          	sd	zero,1112(a5)
    ready_queues[i].tail = 0;
    80001b2a:	4607b023          	sd	zero,1120(a5)
    ready_queues[i].head = 0;
    80001b2e:	4607b423          	sd	zero,1128(a5)
    ready_queues[i].tail = 0;
    80001b32:	4607b823          	sd	zero,1136(a5)
    ready_queues[i].head = 0;
    80001b36:	4607bc23          	sd	zero,1144(a5)
    ready_queues[i].tail = 0;
    80001b3a:	4807b023          	sd	zero,1152(a5)
}
    80001b3e:	6422                	ld	s0,8(sp)
    80001b40:	0141                	add	sp,sp,16
    80001b42:	8082                	ret

0000000080001b44 <procinit>:
{
    80001b44:	715d                	add	sp,sp,-80
    80001b46:	e486                	sd	ra,72(sp)
    80001b48:	e0a2                	sd	s0,64(sp)
    80001b4a:	fc26                	sd	s1,56(sp)
    80001b4c:	f84a                	sd	s2,48(sp)
    80001b4e:	f44e                	sd	s3,40(sp)
    80001b50:	f052                	sd	s4,32(sp)
    80001b52:	ec56                	sd	s5,24(sp)
    80001b54:	e85a                	sd	s6,16(sp)
    80001b56:	e45e                	sd	s7,8(sp)
    80001b58:	0880                	add	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001b5a:	00006597          	auipc	a1,0x6
    80001b5e:	6be58593          	add	a1,a1,1726 # 80008218 <digits+0x1e0>
    80001b62:	0000f517          	auipc	a0,0xf
    80001b66:	30e50513          	add	a0,a0,782 # 80010e70 <pid_lock>
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	0d2080e7          	jalr	210(ra) # 80000c3c <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b72:	00006597          	auipc	a1,0x6
    80001b76:	6ae58593          	add	a1,a1,1710 # 80008220 <digits+0x1e8>
    80001b7a:	0000f517          	auipc	a0,0xf
    80001b7e:	33e50513          	add	a0,a0,830 # 80010eb8 <wait_lock>
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	0ba080e7          	jalr	186(ra) # 80000c3c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b8a:	0000f497          	auipc	s1,0xf
    80001b8e:	34648493          	add	s1,s1,838 # 80010ed0 <proc>
      initlock(&p->lock, "proc");
    80001b92:	00006b97          	auipc	s7,0x6
    80001b96:	69eb8b93          	add	s7,s7,1694 # 80008230 <digits+0x1f8>
      p->kstack = KSTACK((int) (p - proc));
    80001b9a:	8b26                	mv	s6,s1
    80001b9c:	00006a97          	auipc	s5,0x6
    80001ba0:	464a8a93          	add	s5,s5,1124 # 80008000 <etext>
    80001ba4:	040009b7          	lui	s3,0x4000
    80001ba8:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001baa:	09b2                	sll	s3,s3,0xc
      p->time_slice = 10;   /* Default time slice */
    80001bac:	4929                	li	s2,10
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bae:	00015a17          	auipc	s4,0x15
    80001bb2:	322a0a13          	add	s4,s4,802 # 80016ed0 <tickslock>
      initlock(&p->lock, "proc");
    80001bb6:	85de                	mv	a1,s7
    80001bb8:	8526                	mv	a0,s1
    80001bba:	fffff097          	auipc	ra,0xfffff
    80001bbe:	082080e7          	jalr	130(ra) # 80000c3c <initlock>
      p->state = UNUSED;
    80001bc2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001bc6:	416487b3          	sub	a5,s1,s6
    80001bca:	879d                	sra	a5,a5,0x7
    80001bcc:	000ab703          	ld	a4,0(s5)
    80001bd0:	02e787b3          	mul	a5,a5,a4
    80001bd4:	2785                	addw	a5,a5,1
    80001bd6:	00d7979b          	sllw	a5,a5,0xd
    80001bda:	40f987b3          	sub	a5,s3,a5
    80001bde:	e0bc                	sd	a5,64(s1)
      p->priority = 0;      /* Initialize priority */
    80001be0:	1604a423          	sw	zero,360(s1)
      p->time_slice = 10;   /* Default time slice */
    80001be4:	1724a623          	sw	s2,364(s1)
      p->share = 10;        /* Default share */
    80001be8:	1724a823          	sw	s2,368(s1)
      p->group = 0;         /* Default group */
    80001bec:	1604aa23          	sw	zero,372(s1)
      p->next = 0;          /* Initialize next pointer */
    80001bf0:	1604bc23          	sd	zero,376(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bf4:	18048493          	add	s1,s1,384
    80001bf8:	fb449fe3          	bne	s1,s4,80001bb6 <procinit+0x72>
  init_ready_queues(); /* UPDATED [2024-11-13] : 13:35:00 */
    80001bfc:	00000097          	auipc	ra,0x0
    80001c00:	f1c080e7          	jalr	-228(ra) # 80001b18 <init_ready_queues>
}
    80001c04:	60a6                	ld	ra,72(sp)
    80001c06:	6406                	ld	s0,64(sp)
    80001c08:	74e2                	ld	s1,56(sp)
    80001c0a:	7942                	ld	s2,48(sp)
    80001c0c:	79a2                	ld	s3,40(sp)
    80001c0e:	7a02                	ld	s4,32(sp)
    80001c10:	6ae2                	ld	s5,24(sp)
    80001c12:	6b42                	ld	s6,16(sp)
    80001c14:	6ba2                	ld	s7,8(sp)
    80001c16:	6161                	add	sp,sp,80
    80001c18:	8082                	ret

0000000080001c1a <enqueue_process>:
void enqueue_process(struct proc *p, int priority) { /* UPDATED [2024-11-13] : 13:35:00 */
    80001c1a:	1141                	add	sp,sp,-16
    80001c1c:	e422                	sd	s0,8(sp)
    80001c1e:	0800                	add	s0,sp,16
  switch(priority){
    80001c20:	4705                	li	a4,1
    80001c22:	47a9                	li	a5,10
    80001c24:	00e58563          	beq	a1,a4,80001c2e <enqueue_process+0x14>
    80001c28:	47d1                	li	a5,20
    80001c2a:	e191                	bnez	a1,80001c2e <enqueue_process+0x14>
    80001c2c:	4795                	li	a5,5
  p->priority = priority;
    80001c2e:	16b52423          	sw	a1,360(a0)
      p->time_slice = 5;  /* Example: 5 ticks for highest priority */
    80001c32:	16f52623          	sw	a5,364(a0)
  p->next = 0;
    80001c36:	16053c23          	sd	zero,376(a0)
  if (ready_queues[priority].tail) {
    80001c3a:	00459713          	sll	a4,a1,0x4
    80001c3e:	0000f797          	auipc	a5,0xf
    80001c42:	df278793          	add	a5,a5,-526 # 80010a30 <cpus>
    80001c46:	97ba                	add	a5,a5,a4
    80001c48:	4607b783          	ld	a5,1120(a5)
    80001c4c:	cf89                	beqz	a5,80001c66 <enqueue_process+0x4c>
    ready_queues[priority].tail->next = p;
    80001c4e:	16a7bc23          	sd	a0,376(a5)
    ready_queues[priority].tail = p;
    80001c52:	0000f797          	auipc	a5,0xf
    80001c56:	dde78793          	add	a5,a5,-546 # 80010a30 <cpus>
    80001c5a:	97ba                	add	a5,a5,a4
    80001c5c:	46a7b023          	sd	a0,1120(a5)
}
    80001c60:	6422                	ld	s0,8(sp)
    80001c62:	0141                	add	sp,sp,16
    80001c64:	8082                	ret
    ready_queues[priority].head = ready_queues[priority].tail = p;
    80001c66:	0592                	sll	a1,a1,0x4
    80001c68:	0000f797          	auipc	a5,0xf
    80001c6c:	dc878793          	add	a5,a5,-568 # 80010a30 <cpus>
    80001c70:	97ae                	add	a5,a5,a1
    80001c72:	46a7b023          	sd	a0,1120(a5)
    80001c76:	44a7bc23          	sd	a0,1112(a5)
}
    80001c7a:	b7dd                	j	80001c60 <enqueue_process+0x46>

0000000080001c7c <dequeue_process>:
struct proc *dequeue_process(void) { /* UPDATED [2024-11-13] : 13:35:00 */
    80001c7c:	1141                	add	sp,sp,-16
    80001c7e:	e422                	sd	s0,8(sp)
    80001c80:	0800                	add	s0,sp,16
    if(ready_queues[i].head) {
    80001c82:	0000f517          	auipc	a0,0xf
    80001c86:	20653503          	ld	a0,518(a0) # 80010e88 <ready_queues>
    80001c8a:	ed19                	bnez	a0,80001ca8 <dequeue_process+0x2c>
    80001c8c:	0000f517          	auipc	a0,0xf
    80001c90:	20c53503          	ld	a0,524(a0) # 80010e98 <ready_queues+0x10>
    80001c94:	e915                	bnez	a0,80001cc8 <dequeue_process+0x4c>
    80001c96:	0000f517          	auipc	a0,0xf
    80001c9a:	21253503          	ld	a0,530(a0) # 80010ea8 <ready_queues+0x20>
  for(int i = 0; i < MAX_QUEUES; i++) {
    80001c9e:	4689                	li	a3,2
    if(ready_queues[i].head) {
    80001ca0:	e509                	bnez	a0,80001caa <dequeue_process+0x2e>
}
    80001ca2:	6422                	ld	s0,8(sp)
    80001ca4:	0141                	add	sp,sp,16
    80001ca6:	8082                	ret
  for(int i = 0; i < MAX_QUEUES; i++) {
    80001ca8:	4681                	li	a3,0
      ready_queues[i].head = p->next;
    80001caa:	17853703          	ld	a4,376(a0)
    80001cae:	00469613          	sll	a2,a3,0x4
    80001cb2:	0000f797          	auipc	a5,0xf
    80001cb6:	d7e78793          	add	a5,a5,-642 # 80010a30 <cpus>
    80001cba:	97b2                	add	a5,a5,a2
    80001cbc:	44e7bc23          	sd	a4,1112(a5)
      if(ready_queues[i].head == 0)
    80001cc0:	c711                	beqz	a4,80001ccc <dequeue_process+0x50>
      p->next = 0;
    80001cc2:	16053c23          	sd	zero,376(a0)
      return p;
    80001cc6:	bff1                	j	80001ca2 <dequeue_process+0x26>
  for(int i = 0; i < MAX_QUEUES; i++) {
    80001cc8:	4685                	li	a3,1
    80001cca:	b7c5                	j	80001caa <dequeue_process+0x2e>
        ready_queues[i].tail = 0;
    80001ccc:	0000f797          	auipc	a5,0xf
    80001cd0:	d6478793          	add	a5,a5,-668 # 80010a30 <cpus>
    80001cd4:	97b2                	add	a5,a5,a2
    80001cd6:	4607b023          	sd	zero,1120(a5)
    80001cda:	b7e5                	j	80001cc2 <dequeue_process+0x46>

0000000080001cdc <adjust_priority>:
void adjust_priority(struct proc *p) { /* UPDATED [2024-11-13] : 13:35:00 */
    80001cdc:	1141                	add	sp,sp,-16
    80001cde:	e406                	sd	ra,8(sp)
    80001ce0:	e022                	sd	s0,0(sp)
    80001ce2:	0800                	add	s0,sp,16
  if(p->priority < MAX_QUEUES -1){
    80001ce4:	16852583          	lw	a1,360(a0)
    80001ce8:	4785                	li	a5,1
    80001cea:	02b7d163          	bge	a5,a1,80001d0c <adjust_priority+0x30>
  switch(p->priority){
    80001cee:	16852583          	lw	a1,360(a0)
    80001cf2:	47d1                	li	a5,20
    80001cf4:	e191                	bnez	a1,80001cf8 <adjust_priority+0x1c>
    80001cf6:	4795                	li	a5,5
      p->time_slice = 5;
    80001cf8:	16f52623          	sw	a5,364(a0)
  enqueue_process(p, p->priority);
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	f1e080e7          	jalr	-226(ra) # 80001c1a <enqueue_process>
}
    80001d04:	60a2                	ld	ra,8(sp)
    80001d06:	6402                	ld	s0,0(sp)
    80001d08:	0141                	add	sp,sp,16
    80001d0a:	8082                	ret
    p->priority++;
    80001d0c:	2585                	addw	a1,a1,1
    80001d0e:	16b52423          	sw	a1,360(a0)
  switch(p->priority){
    80001d12:	2581                	sext.w	a1,a1
    80001d14:	4705                	li	a4,1
    80001d16:	47a9                	li	a5,10
    80001d18:	fee580e3          	beq	a1,a4,80001cf8 <adjust_priority+0x1c>
    80001d1c:	bfd9                	j	80001cf2 <adjust_priority+0x16>

0000000080001d1e <scheduler>:
void scheduler(void) { /* UPDATED [2024-11-13] : 13:35:00 */
    80001d1e:	7179                	add	sp,sp,-48
    80001d20:	f406                	sd	ra,40(sp)
    80001d22:	f022                	sd	s0,32(sp)
    80001d24:	ec26                	sd	s1,24(sp)
    80001d26:	e84a                	sd	s2,16(sp)
    80001d28:	e44e                	sd	s3,8(sp)
    80001d2a:	e052                	sd	s4,0(sp)
    80001d2c:	1800                	add	s0,sp,48
    80001d2e:	8712                	mv	a4,tp
  int id = r_tp();
    80001d30:	2701                	sext.w	a4,a4
  c->proc = 0;
    80001d32:	0000f997          	auipc	s3,0xf
    80001d36:	cfe98993          	add	s3,s3,-770 # 80010a30 <cpus>
    80001d3a:	00471793          	sll	a5,a4,0x4
    80001d3e:	00e786b3          	add	a3,a5,a4
    80001d42:	068e                	sll	a3,a3,0x3
    80001d44:	96ce                	add	a3,a3,s3
    80001d46:	0006b023          	sd	zero,0(a3) # 1000 <_entry-0x7ffff000>
      swtch(&c->context, &p->context);
    80001d4a:	97ba                	add	a5,a5,a4
    80001d4c:	078e                	sll	a5,a5,0x3
    80001d4e:	07a1                	add	a5,a5,8
    80001d50:	99be                	add	s3,s3,a5
    acquire(&wait_lock);
    80001d52:	0000f497          	auipc	s1,0xf
    80001d56:	16648493          	add	s1,s1,358 # 80010eb8 <wait_lock>
      p->state = RUNNING;
    80001d5a:	4a11                	li	s4,4
      c->proc = p;
    80001d5c:	8936                	mv	s2,a3
    80001d5e:	a01d                	j	80001d84 <scheduler+0x66>
      p->state = RUNNING;
    80001d60:	01452c23          	sw	s4,24(a0)
      c->proc = p;
    80001d64:	00a93023          	sd	a0,0(s2)
      swtch(&c->context, &p->context);
    80001d68:	06050593          	add	a1,a0,96
    80001d6c:	854e                	mv	a0,s3
    80001d6e:	00001097          	auipc	ra,0x1
    80001d72:	df6080e7          	jalr	-522(ra) # 80002b64 <swtch>
      c->proc = 0;
    80001d76:	00093023          	sd	zero,0(s2)
    release(&wait_lock);
    80001d7a:	8526                	mv	a0,s1
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	004080e7          	jalr	4(ra) # 80000d80 <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d88:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d8c:	10079073          	csrw	sstatus,a5
    acquire(&wait_lock);
    80001d90:	8526                	mv	a0,s1
    80001d92:	fffff097          	auipc	ra,0xfffff
    80001d96:	f3a080e7          	jalr	-198(ra) # 80000ccc <acquire>
    p = dequeue_process();
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	ee2080e7          	jalr	-286(ra) # 80001c7c <dequeue_process>
    if(p){
    80001da2:	fd5d                	bnez	a0,80001d60 <scheduler+0x42>
    80001da4:	bfd9                	j	80001d7a <scheduler+0x5c>

0000000080001da6 <sys_setshare>:
int sys_setshare(void) { /* UPDATED [2024-11-13] : 13:35:00 */
    80001da6:	7139                	add	sp,sp,-64
    80001da8:	fc06                	sd	ra,56(sp)
    80001daa:	f822                	sd	s0,48(sp)
    80001dac:	f426                	sd	s1,40(sp)
    80001dae:	f04a                	sd	s2,32(sp)
    80001db0:	ec4e                	sd	s3,24(sp)
    80001db2:	e852                	sd	s4,16(sp)
    80001db4:	0080                	add	s0,sp,64
  share = 0;
    80001db6:	fc042623          	sw	zero,-52(s0)
  group = 0;
    80001dba:	fc042423          	sw	zero,-56(s0)
  argint(0, &share);
    80001dbe:	fcc40593          	add	a1,s0,-52
    80001dc2:	4501                	li	a0,0
    80001dc4:	00001097          	auipc	ra,0x1
    80001dc8:	28e080e7          	jalr	654(ra) # 80003052 <argint>
  argint(0, &group);
    80001dcc:	fc840593          	add	a1,s0,-56
    80001dd0:	4501                	li	a0,0
    80001dd2:	00001097          	auipc	ra,0x1
    80001dd6:	280080e7          	jalr	640(ra) # 80003052 <argint>
  struct proc *p = myproc();
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	c70080e7          	jalr	-912(ra) # 80001a4a <myproc>
  if(group >=0 && group < MAX_GROUPS){ /* UPDATED [2024-11-13] : 13:35:00 */
    80001de2:	fc842703          	lw	a4,-56(s0)
    80001de6:	47a5                	li	a5,9
    80001de8:	04e7f263          	bgeu	a5,a4,80001e2c <sys_setshare+0x86>
    80001dec:	84aa                	mv	s1,a0
    if(share < 1){
    80001dee:	fcc42783          	lw	a5,-52(s0)
    80001df2:	0ef05763          	blez	a5,80001ee0 <sys_setshare+0x13a>
    acquire(&p->lock);
    80001df6:	fffff097          	auipc	ra,0xfffff
    80001dfa:	ed6080e7          	jalr	-298(ra) # 80000ccc <acquire>
    p->share = share;
    80001dfe:	fcc42783          	lw	a5,-52(s0)
    80001e02:	16f4a823          	sw	a5,368(s1)
    if(p->share >= 10 && p->priority > 0){
    80001e06:	4725                	li	a4,9
    80001e08:	0af75b63          	bge	a4,a5,80001ebe <sys_setshare+0x118>
    80001e0c:	1684a783          	lw	a5,360(s1)
    80001e10:	0af04063          	bgtz	a5,80001eb0 <sys_setshare+0x10a>
    else if(p->share >=5 && p->priority >1){
    80001e14:	1684a703          	lw	a4,360(s1)
    80001e18:	4785                	li	a5,1
    80001e1a:	0ae7d563          	bge	a5,a4,80001ec4 <sys_setshare+0x11e>
      enqueue_process(p, 1);
    80001e1e:	4585                	li	a1,1
    80001e20:	8526                	mv	a0,s1
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	df8080e7          	jalr	-520(ra) # 80001c1a <enqueue_process>
    80001e2a:	a869                	j	80001ec4 <sys_setshare+0x11e>
    acquire(&wait_lock);
    80001e2c:	0000f517          	auipc	a0,0xf
    80001e30:	08c50513          	add	a0,a0,140 # 80010eb8 <wait_lock>
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	e98080e7          	jalr	-360(ra) # 80000ccc <acquire>
    for(int i =0; i < NPROC; i++){
    80001e3c:	0000f497          	auipc	s1,0xf
    80001e40:	09448493          	add	s1,s1,148 # 80010ed0 <proc>
    80001e44:	00015997          	auipc	s3,0x15
    80001e48:	08c98993          	add	s3,s3,140 # 80016ed0 <tickslock>
        if(proc[i].share >= 10){
    80001e4c:	4a25                	li	s4,9
    80001e4e:	a811                	j	80001e62 <sys_setshare+0xbc>
        release(&proc[i].lock);
    80001e50:	854a                	mv	a0,s2
    80001e52:	fffff097          	auipc	ra,0xfffff
    80001e56:	f2e080e7          	jalr	-210(ra) # 80000d80 <release>
    for(int i =0; i < NPROC; i++){
    80001e5a:	18048493          	add	s1,s1,384
    80001e5e:	03348f63          	beq	s1,s3,80001e9c <sys_setshare+0xf6>
      if(proc[i].group == group){
    80001e62:	8926                	mv	s2,s1
    80001e64:	1744a703          	lw	a4,372(s1)
    80001e68:	fc842783          	lw	a5,-56(s0)
    80001e6c:	fef717e3          	bne	a4,a5,80001e5a <sys_setshare+0xb4>
        acquire(&proc[i].lock);
    80001e70:	8526                	mv	a0,s1
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	e5a080e7          	jalr	-422(ra) # 80000ccc <acquire>
        proc[i].share = share;
    80001e7a:	fcc42783          	lw	a5,-52(s0)
    80001e7e:	16f4a823          	sw	a5,368(s1)
        if(proc[i].share >= 10){
    80001e82:	fcfa57e3          	bge	s4,a5,80001e50 <sys_setshare+0xaa>
          if(proc[i].priority > 0){
    80001e86:	1684a783          	lw	a5,360(s1)
    80001e8a:	fcf053e3          	blez	a5,80001e50 <sys_setshare+0xaa>
            enqueue_process(&proc[i], 0);
    80001e8e:	4581                	li	a1,0
    80001e90:	8526                	mv	a0,s1
    80001e92:	00000097          	auipc	ra,0x0
    80001e96:	d88080e7          	jalr	-632(ra) # 80001c1a <enqueue_process>
    80001e9a:	bf5d                	j	80001e50 <sys_setshare+0xaa>
    release(&wait_lock);
    80001e9c:	0000f517          	auipc	a0,0xf
    80001ea0:	01c50513          	add	a0,a0,28 # 80010eb8 <wait_lock>
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	edc080e7          	jalr	-292(ra) # 80000d80 <release>
  return 0;
    80001eac:	4501                	li	a0,0
    80001eae:	a00d                	j	80001ed0 <sys_setshare+0x12a>
      enqueue_process(p, 0);
    80001eb0:	4581                	li	a1,0
    80001eb2:	8526                	mv	a0,s1
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	d66080e7          	jalr	-666(ra) # 80001c1a <enqueue_process>
    80001ebc:	a021                	j	80001ec4 <sys_setshare+0x11e>
    else if(p->share >=5 && p->priority >1){
    80001ebe:	4711                	li	a4,4
    80001ec0:	f4f74ae3          	blt	a4,a5,80001e14 <sys_setshare+0x6e>
    release(&p->lock);
    80001ec4:	8526                	mv	a0,s1
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	eba080e7          	jalr	-326(ra) # 80000d80 <release>
  return 0;
    80001ece:	4501                	li	a0,0
}
    80001ed0:	70e2                	ld	ra,56(sp)
    80001ed2:	7442                	ld	s0,48(sp)
    80001ed4:	74a2                	ld	s1,40(sp)
    80001ed6:	7902                	ld	s2,32(sp)
    80001ed8:	69e2                	ld	s3,24(sp)
    80001eda:	6a42                	ld	s4,16(sp)
    80001edc:	6121                	add	sp,sp,64
    80001ede:	8082                	ret
      return -1;
    80001ee0:	557d                	li	a0,-1
    80001ee2:	b7fd                	j	80001ed0 <sys_setshare+0x12a>

0000000080001ee4 <proc_pagetable>:
{
    80001ee4:	1101                	add	sp,sp,-32
    80001ee6:	ec06                	sd	ra,24(sp)
    80001ee8:	e822                	sd	s0,16(sp)
    80001eea:	e426                	sd	s1,8(sp)
    80001eec:	e04a                	sd	s2,0(sp)
    80001eee:	1000                	add	s0,sp,32
    80001ef0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	54e080e7          	jalr	1358(ra) # 80001440 <uvmcreate>
    80001efa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001efc:	c121                	beqz	a0,80001f3c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001efe:	4729                	li	a4,10
    80001f00:	00005697          	auipc	a3,0x5
    80001f04:	10068693          	add	a3,a3,256 # 80007000 <_trampoline>
    80001f08:	6605                	lui	a2,0x1
    80001f0a:	040005b7          	lui	a1,0x4000
    80001f0e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f10:	05b2                	sll	a1,a1,0xc
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	280080e7          	jalr	640(ra) # 80001192 <mappages>
    80001f1a:	02054863          	bltz	a0,80001f4a <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001f1e:	4719                	li	a4,6
    80001f20:	05893683          	ld	a3,88(s2)
    80001f24:	6605                	lui	a2,0x1
    80001f26:	020005b7          	lui	a1,0x2000
    80001f2a:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f2c:	05b6                	sll	a1,a1,0xd
    80001f2e:	8526                	mv	a0,s1
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	262080e7          	jalr	610(ra) # 80001192 <mappages>
    80001f38:	02054163          	bltz	a0,80001f5a <proc_pagetable+0x76>
}
    80001f3c:	8526                	mv	a0,s1
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6902                	ld	s2,0(sp)
    80001f46:	6105                	add	sp,sp,32
    80001f48:	8082                	ret
    uvmfree(pagetable, 0);
    80001f4a:	4581                	li	a1,0
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	6f8080e7          	jalr	1784(ra) # 80001646 <uvmfree>
    return 0;
    80001f56:	4481                	li	s1,0
    80001f58:	b7d5                	j	80001f3c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f5a:	4681                	li	a3,0
    80001f5c:	4605                	li	a2,1
    80001f5e:	040005b7          	lui	a1,0x4000
    80001f62:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f64:	05b2                	sll	a1,a1,0xc
    80001f66:	8526                	mv	a0,s1
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	414080e7          	jalr	1044(ra) # 8000137c <uvmunmap>
    uvmfree(pagetable, 0);
    80001f70:	4581                	li	a1,0
    80001f72:	8526                	mv	a0,s1
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	6d2080e7          	jalr	1746(ra) # 80001646 <uvmfree>
    return 0;
    80001f7c:	4481                	li	s1,0
    80001f7e:	bf7d                	j	80001f3c <proc_pagetable+0x58>

0000000080001f80 <proc_freepagetable>:
{
    80001f80:	1101                	add	sp,sp,-32
    80001f82:	ec06                	sd	ra,24(sp)
    80001f84:	e822                	sd	s0,16(sp)
    80001f86:	e426                	sd	s1,8(sp)
    80001f88:	e04a                	sd	s2,0(sp)
    80001f8a:	1000                	add	s0,sp,32
    80001f8c:	84aa                	mv	s1,a0
    80001f8e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f90:	4681                	li	a3,0
    80001f92:	4605                	li	a2,1
    80001f94:	040005b7          	lui	a1,0x4000
    80001f98:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f9a:	05b2                	sll	a1,a1,0xc
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	3e0080e7          	jalr	992(ra) # 8000137c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001fa4:	4681                	li	a3,0
    80001fa6:	4605                	li	a2,1
    80001fa8:	020005b7          	lui	a1,0x2000
    80001fac:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001fae:	05b6                	sll	a1,a1,0xd
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	3ca080e7          	jalr	970(ra) # 8000137c <uvmunmap>
  uvmfree(pagetable, sz);
    80001fba:	85ca                	mv	a1,s2
    80001fbc:	8526                	mv	a0,s1
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	688080e7          	jalr	1672(ra) # 80001646 <uvmfree>
}
    80001fc6:	60e2                	ld	ra,24(sp)
    80001fc8:	6442                	ld	s0,16(sp)
    80001fca:	64a2                	ld	s1,8(sp)
    80001fcc:	6902                	ld	s2,0(sp)
    80001fce:	6105                	add	sp,sp,32
    80001fd0:	8082                	ret

0000000080001fd2 <freeproc>:
{
    80001fd2:	1101                	add	sp,sp,-32
    80001fd4:	ec06                	sd	ra,24(sp)
    80001fd6:	e822                	sd	s0,16(sp)
    80001fd8:	e426                	sd	s1,8(sp)
    80001fda:	1000                	add	s0,sp,32
    80001fdc:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001fde:	6d28                	ld	a0,88(a0)
    80001fe0:	c509                	beqz	a0,80001fea <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001fe2:	fffff097          	auipc	ra,0xfffff
    80001fe6:	afc080e7          	jalr	-1284(ra) # 80000ade <kfree>
  p->trapframe = 0;
    80001fea:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001fee:	68a8                	ld	a0,80(s1)
    80001ff0:	c511                	beqz	a0,80001ffc <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001ff2:	64ac                	ld	a1,72(s1)
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	f8c080e7          	jalr	-116(ra) # 80001f80 <proc_freepagetable>
  p->pagetable = 0;
    80001ffc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002000:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002004:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80002008:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000200c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002010:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002014:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80002018:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000201c:	0004ac23          	sw	zero,24(s1)
}
    80002020:	60e2                	ld	ra,24(sp)
    80002022:	6442                	ld	s0,16(sp)
    80002024:	64a2                	ld	s1,8(sp)
    80002026:	6105                	add	sp,sp,32
    80002028:	8082                	ret

000000008000202a <allocproc>:
allocproc(void){
    8000202a:	1101                	add	sp,sp,-32
    8000202c:	ec06                	sd	ra,24(sp)
    8000202e:	e822                	sd	s0,16(sp)
    80002030:	e426                	sd	s1,8(sp)
    80002032:	e04a                	sd	s2,0(sp)
    80002034:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002036:	0000f497          	auipc	s1,0xf
    8000203a:	e9a48493          	add	s1,s1,-358 # 80010ed0 <proc>
    8000203e:	00015917          	auipc	s2,0x15
    80002042:	e9290913          	add	s2,s2,-366 # 80016ed0 <tickslock>
    acquire(&p->lock);
    80002046:	8526                	mv	a0,s1
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	c84080e7          	jalr	-892(ra) # 80000ccc <acquire>
    if(p->state == UNUSED) {
    80002050:	4c9c                	lw	a5,24(s1)
    80002052:	cf81                	beqz	a5,8000206a <allocproc+0x40>
      release(&p->lock);
    80002054:	8526                	mv	a0,s1
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	d2a080e7          	jalr	-726(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000205e:	18048493          	add	s1,s1,384
    80002062:	ff2492e3          	bne	s1,s2,80002046 <allocproc+0x1c>
  return 0;
    80002066:	4481                	li	s1,0
    80002068:	a889                	j	800020ba <allocproc+0x90>
  p->pid = allocpid();
    8000206a:	00000097          	auipc	ra,0x0
    8000206e:	a68080e7          	jalr	-1432(ra) # 80001ad2 <allocpid>
    80002072:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002074:	4785                	li	a5,1
    80002076:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002078:	fffff097          	auipc	ra,0xfffff
    8000207c:	b64080e7          	jalr	-1180(ra) # 80000bdc <kalloc>
    80002080:	892a                	mv	s2,a0
    80002082:	eca8                	sd	a0,88(s1)
    80002084:	c131                	beqz	a0,800020c8 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80002086:	8526                	mv	a0,s1
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	e5c080e7          	jalr	-420(ra) # 80001ee4 <proc_pagetable>
    80002090:	892a                	mv	s2,a0
    80002092:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002094:	c531                	beqz	a0,800020e0 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80002096:	07000613          	li	a2,112
    8000209a:	4581                	li	a1,0
    8000209c:	06048513          	add	a0,s1,96
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	d28080e7          	jalr	-728(ra) # 80000dc8 <memset>
  p->context.ra = (uint64)forkret;
    800020a8:	00000797          	auipc	a5,0x0
    800020ac:	9e078793          	add	a5,a5,-1568 # 80001a88 <forkret>
    800020b0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800020b2:	60bc                	ld	a5,64(s1)
    800020b4:	6705                	lui	a4,0x1
    800020b6:	97ba                	add	a5,a5,a4
    800020b8:	f4bc                	sd	a5,104(s1)
}
    800020ba:	8526                	mv	a0,s1
    800020bc:	60e2                	ld	ra,24(sp)
    800020be:	6442                	ld	s0,16(sp)
    800020c0:	64a2                	ld	s1,8(sp)
    800020c2:	6902                	ld	s2,0(sp)
    800020c4:	6105                	add	sp,sp,32
    800020c6:	8082                	ret
    freeproc(p);
    800020c8:	8526                	mv	a0,s1
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	f08080e7          	jalr	-248(ra) # 80001fd2 <freeproc>
    release(&p->lock);
    800020d2:	8526                	mv	a0,s1
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	cac080e7          	jalr	-852(ra) # 80000d80 <release>
    return 0;
    800020dc:	84ca                	mv	s1,s2
    800020de:	bff1                	j	800020ba <allocproc+0x90>
    freeproc(p);
    800020e0:	8526                	mv	a0,s1
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	ef0080e7          	jalr	-272(ra) # 80001fd2 <freeproc>
    release(&p->lock);
    800020ea:	8526                	mv	a0,s1
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	c94080e7          	jalr	-876(ra) # 80000d80 <release>
    return 0;
    800020f4:	84ca                	mv	s1,s2
    800020f6:	b7d1                	j	800020ba <allocproc+0x90>

00000000800020f8 <userinit>:
{
    800020f8:	1101                	add	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	e426                	sd	s1,8(sp)
    80002100:	1000                	add	s0,sp,32
  p = allocproc();
    80002102:	00000097          	auipc	ra,0x0
    80002106:	f28080e7          	jalr	-216(ra) # 8000202a <allocproc>
    8000210a:	84aa                	mv	s1,a0
  initproc = p;
    8000210c:	00006797          	auipc	a5,0x6
    80002110:	7ea7ba23          	sd	a0,2036(a5) # 80008900 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002114:	03400613          	li	a2,52
    80002118:	00006597          	auipc	a1,0x6
    8000211c:	77858593          	add	a1,a1,1912 # 80008890 <initcode>
    80002120:	6928                	ld	a0,80(a0)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	34c080e7          	jalr	844(ra) # 8000146e <uvmfirst>
  p->sz = PGSIZE;
    8000212a:	6785                	lui	a5,0x1
    8000212c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      /* user program counter */
    8000212e:	6cb8                	ld	a4,88(s1)
    80002130:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    80002134:	6cb8                	ld	a4,88(s1)
    80002136:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002138:	4641                	li	a2,16
    8000213a:	00006597          	auipc	a1,0x6
    8000213e:	0fe58593          	add	a1,a1,254 # 80008238 <digits+0x200>
    80002142:	15848513          	add	a0,s1,344
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	dca080e7          	jalr	-566(ra) # 80000f10 <safestrcpy>
  p->cwd = namei("/");
    8000214e:	00006517          	auipc	a0,0x6
    80002152:	0fa50513          	add	a0,a0,250 # 80008248 <digits+0x210>
    80002156:	00002097          	auipc	ra,0x2
    8000215a:	212080e7          	jalr	530(ra) # 80004368 <namei>
    8000215e:	14a4b823          	sd	a0,336(s1)
  acquire(&p->lock);
    80002162:	8526                	mv	a0,s1
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	b68080e7          	jalr	-1176(ra) # 80000ccc <acquire>
  p->state = RUNNABLE;
    8000216c:	478d                	li	a5,3
    8000216e:	cc9c                	sw	a5,24(s1)
  enqueue_process(p, p->priority); /* UPDATED [2024-11-13] : 13:35:00 */
    80002170:	1684a583          	lw	a1,360(s1)
    80002174:	8526                	mv	a0,s1
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	aa4080e7          	jalr	-1372(ra) # 80001c1a <enqueue_process>
  release(&p->lock);
    8000217e:	8526                	mv	a0,s1
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	c00080e7          	jalr	-1024(ra) # 80000d80 <release>
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	64a2                	ld	s1,8(sp)
    8000218e:	6105                	add	sp,sp,32
    80002190:	8082                	ret

0000000080002192 <growproc>:
{
    80002192:	1101                	add	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	e426                	sd	s1,8(sp)
    8000219a:	e04a                	sd	s2,0(sp)
    8000219c:	1000                	add	s0,sp,32
    8000219e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	8aa080e7          	jalr	-1878(ra) # 80001a4a <myproc>
    800021a8:	84aa                	mv	s1,a0
  sz = p->sz;
    800021aa:	652c                	ld	a1,72(a0)
  if(n > 0){
    800021ac:	01204c63          	bgtz	s2,800021c4 <growproc+0x32>
  } else if(n < 0){
    800021b0:	02094663          	bltz	s2,800021dc <growproc+0x4a>
  p->sz = sz;
    800021b4:	e4ac                	sd	a1,72(s1)
  return 0;
    800021b6:	4501                	li	a0,0
}
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6902                	ld	s2,0(sp)
    800021c0:	6105                	add	sp,sp,32
    800021c2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800021c4:	4691                	li	a3,4
    800021c6:	00b90633          	add	a2,s2,a1
    800021ca:	6928                	ld	a0,80(a0)
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	35c080e7          	jalr	860(ra) # 80001528 <uvmalloc>
    800021d4:	85aa                	mv	a1,a0
    800021d6:	fd79                	bnez	a0,800021b4 <growproc+0x22>
      return -1;
    800021d8:	557d                	li	a0,-1
    800021da:	bff9                	j	800021b8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800021dc:	00b90633          	add	a2,s2,a1
    800021e0:	6928                	ld	a0,80(a0)
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	2fe080e7          	jalr	766(ra) # 800014e0 <uvmdealloc>
    800021ea:	85aa                	mv	a1,a0
    800021ec:	b7e1                	j	800021b4 <growproc+0x22>

00000000800021ee <fork>:
{
    800021ee:	7139                	add	sp,sp,-64
    800021f0:	fc06                	sd	ra,56(sp)
    800021f2:	f822                	sd	s0,48(sp)
    800021f4:	f426                	sd	s1,40(sp)
    800021f6:	f04a                	sd	s2,32(sp)
    800021f8:	ec4e                	sd	s3,24(sp)
    800021fa:	e852                	sd	s4,16(sp)
    800021fc:	e456                	sd	s5,8(sp)
    800021fe:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80002200:	00000097          	auipc	ra,0x0
    80002204:	84a080e7          	jalr	-1974(ra) # 80001a4a <myproc>
    80002208:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	e20080e7          	jalr	-480(ra) # 8000202a <allocproc>
    80002212:	14050163          	beqz	a0,80002354 <fork+0x166>
    80002216:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002218:	048ab603          	ld	a2,72(s5)
    8000221c:	692c                	ld	a1,80(a0)
    8000221e:	050ab503          	ld	a0,80(s5)
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	45e080e7          	jalr	1118(ra) # 80001680 <uvmcopy>
    8000222a:	04054863          	bltz	a0,8000227a <fork+0x8c>
  np->sz = p->sz;
    8000222e:	048ab783          	ld	a5,72(s5)
    80002232:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80002236:	058ab683          	ld	a3,88(s5)
    8000223a:	87b6                	mv	a5,a3
    8000223c:	0589b703          	ld	a4,88(s3)
    80002240:	12068693          	add	a3,a3,288
    80002244:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002248:	6788                	ld	a0,8(a5)
    8000224a:	6b8c                	ld	a1,16(a5)
    8000224c:	6f90                	ld	a2,24(a5)
    8000224e:	01073023          	sd	a6,0(a4)
    80002252:	e708                	sd	a0,8(a4)
    80002254:	eb0c                	sd	a1,16(a4)
    80002256:	ef10                	sd	a2,24(a4)
    80002258:	02078793          	add	a5,a5,32
    8000225c:	02070713          	add	a4,a4,32
    80002260:	fed792e3          	bne	a5,a3,80002244 <fork+0x56>
  np->trapframe->a0 = 0;
    80002264:	0589b783          	ld	a5,88(s3)
    80002268:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000226c:	0d0a8493          	add	s1,s5,208
    80002270:	0d098913          	add	s2,s3,208
    80002274:	150a8a13          	add	s4,s5,336
    80002278:	a00d                	j	8000229a <fork+0xac>
    freeproc(np);
    8000227a:	854e                	mv	a0,s3
    8000227c:	00000097          	auipc	ra,0x0
    80002280:	d56080e7          	jalr	-682(ra) # 80001fd2 <freeproc>
    release(&np->lock);
    80002284:	854e                	mv	a0,s3
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	afa080e7          	jalr	-1286(ra) # 80000d80 <release>
    return -1;
    8000228e:	597d                	li	s2,-1
    80002290:	a845                	j	80002340 <fork+0x152>
  for(i = 0; i < NOFILE; i++)
    80002292:	04a1                	add	s1,s1,8
    80002294:	0921                	add	s2,s2,8
    80002296:	01448b63          	beq	s1,s4,800022ac <fork+0xbe>
    if(p->ofile[i])
    8000229a:	6088                	ld	a0,0(s1)
    8000229c:	d97d                	beqz	a0,80002292 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000229e:	00002097          	auipc	ra,0x2
    800022a2:	73c080e7          	jalr	1852(ra) # 800049da <filedup>
    800022a6:	00a93023          	sd	a0,0(s2)
    800022aa:	b7e5                	j	80002292 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800022ac:	150ab503          	ld	a0,336(s5)
    800022b0:	00002097          	auipc	ra,0x2
    800022b4:	8d4080e7          	jalr	-1836(ra) # 80003b84 <idup>
    800022b8:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(np->name));
    800022bc:	4641                	li	a2,16
    800022be:	158a8593          	add	a1,s5,344
    800022c2:	15898513          	add	a0,s3,344
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	c4a080e7          	jalr	-950(ra) # 80000f10 <safestrcpy>
  pid = np->pid;
    800022ce:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800022d2:	854e                	mv	a0,s3
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	aac080e7          	jalr	-1364(ra) # 80000d80 <release>
  acquire(&wait_lock);
    800022dc:	0000f497          	auipc	s1,0xf
    800022e0:	bdc48493          	add	s1,s1,-1060 # 80010eb8 <wait_lock>
    800022e4:	8526                	mv	a0,s1
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	9e6080e7          	jalr	-1562(ra) # 80000ccc <acquire>
  np->parent = p;
    800022ee:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800022f2:	8526                	mv	a0,s1
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	a8c080e7          	jalr	-1396(ra) # 80000d80 <release>
  acquire(&np->lock);
    800022fc:	854e                	mv	a0,s3
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	9ce080e7          	jalr	-1586(ra) # 80000ccc <acquire>
  np->priority = 0;       /* Start at highest priority */
    80002306:	1609a423          	sw	zero,360(s3)
  np->time_slice = 10;    /* Default time slice */
    8000230a:	47a9                	li	a5,10
    8000230c:	16f9a623          	sw	a5,364(s3)
  np->share = p->share;   /* Inherit share from parent */
    80002310:	170aa783          	lw	a5,368(s5)
    80002314:	16f9a823          	sw	a5,368(s3)
  np->group = p->group;   /* Inherit group from parent */
    80002318:	174aa783          	lw	a5,372(s5)
    8000231c:	16f9aa23          	sw	a5,372(s3)
  np->next = 0;
    80002320:	1609bc23          	sd	zero,376(s3)
  enqueue_process(np, np->priority); /* UPDATED [2024-11-13] : 13:35:00 */
    80002324:	4581                	li	a1,0
    80002326:	854e                	mv	a0,s3
    80002328:	00000097          	auipc	ra,0x0
    8000232c:	8f2080e7          	jalr	-1806(ra) # 80001c1a <enqueue_process>
  np->state = RUNNABLE;
    80002330:	478d                	li	a5,3
    80002332:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002336:	854e                	mv	a0,s3
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	a48080e7          	jalr	-1464(ra) # 80000d80 <release>
}
    80002340:	854a                	mv	a0,s2
    80002342:	70e2                	ld	ra,56(sp)
    80002344:	7442                	ld	s0,48(sp)
    80002346:	74a2                	ld	s1,40(sp)
    80002348:	7902                	ld	s2,32(sp)
    8000234a:	69e2                	ld	s3,24(sp)
    8000234c:	6a42                	ld	s4,16(sp)
    8000234e:	6aa2                	ld	s5,8(sp)
    80002350:	6121                	add	sp,sp,64
    80002352:	8082                	ret
    return -1;
    80002354:	597d                	li	s2,-1
    80002356:	b7ed                	j	80002340 <fork+0x152>

0000000080002358 <sched>:
{
    80002358:	7179                	add	sp,sp,-48
    8000235a:	f406                	sd	ra,40(sp)
    8000235c:	f022                	sd	s0,32(sp)
    8000235e:	ec26                	sd	s1,24(sp)
    80002360:	e84a                	sd	s2,16(sp)
    80002362:	e44e                	sd	s3,8(sp)
    80002364:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	6e4080e7          	jalr	1764(ra) # 80001a4a <myproc>
    8000236e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002370:	fffff097          	auipc	ra,0xfffff
    80002374:	8e2080e7          	jalr	-1822(ra) # 80000c52 <holding>
    80002378:	c159                	beqz	a0,800023fe <sched+0xa6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000237a:	8712                	mv	a4,tp
  if(mycpu()->noff != 1)
    8000237c:	2701                	sext.w	a4,a4
    8000237e:	00471793          	sll	a5,a4,0x4
    80002382:	97ba                	add	a5,a5,a4
    80002384:	078e                	sll	a5,a5,0x3
    80002386:	0000e717          	auipc	a4,0xe
    8000238a:	6aa70713          	add	a4,a4,1706 # 80010a30 <cpus>
    8000238e:	97ba                	add	a5,a5,a4
    80002390:	5fb8                	lw	a4,120(a5)
    80002392:	4785                	li	a5,1
    80002394:	06f71d63          	bne	a4,a5,8000240e <sched+0xb6>
  if(p->state == RUNNING)
    80002398:	4c98                	lw	a4,24(s1)
    8000239a:	4791                	li	a5,4
    8000239c:	08f70163          	beq	a4,a5,8000241e <sched+0xc6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023a0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800023a4:	8b89                	and	a5,a5,2
  if(intr_get())
    800023a6:	e7c1                	bnez	a5,8000242e <sched+0xd6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800023a8:	8712                	mv	a4,tp
  intena = mycpu()->intena;
    800023aa:	0000e917          	auipc	s2,0xe
    800023ae:	68690913          	add	s2,s2,1670 # 80010a30 <cpus>
    800023b2:	2701                	sext.w	a4,a4
    800023b4:	00471793          	sll	a5,a4,0x4
    800023b8:	97ba                	add	a5,a5,a4
    800023ba:	078e                	sll	a5,a5,0x3
    800023bc:	97ca                	add	a5,a5,s2
    800023be:	07c7a983          	lw	s3,124(a5)
    800023c2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800023c4:	2781                	sext.w	a5,a5
    800023c6:	00479593          	sll	a1,a5,0x4
    800023ca:	95be                	add	a1,a1,a5
    800023cc:	058e                	sll	a1,a1,0x3
    800023ce:	05a1                	add	a1,a1,8
    800023d0:	95ca                	add	a1,a1,s2
    800023d2:	06048513          	add	a0,s1,96
    800023d6:	00000097          	auipc	ra,0x0
    800023da:	78e080e7          	jalr	1934(ra) # 80002b64 <swtch>
    800023de:	8712                	mv	a4,tp
  mycpu()->intena = intena;
    800023e0:	2701                	sext.w	a4,a4
    800023e2:	00471793          	sll	a5,a4,0x4
    800023e6:	97ba                	add	a5,a5,a4
    800023e8:	078e                	sll	a5,a5,0x3
    800023ea:	993e                	add	s2,s2,a5
    800023ec:	07392e23          	sw	s3,124(s2)
}
    800023f0:	70a2                	ld	ra,40(sp)
    800023f2:	7402                	ld	s0,32(sp)
    800023f4:	64e2                	ld	s1,24(sp)
    800023f6:	6942                	ld	s2,16(sp)
    800023f8:	69a2                	ld	s3,8(sp)
    800023fa:	6145                	add	sp,sp,48
    800023fc:	8082                	ret
    panic("sched p->lock");
    800023fe:	00006517          	auipc	a0,0x6
    80002402:	e5250513          	add	a0,a0,-430 # 80008250 <digits+0x218>
    80002406:	ffffe097          	auipc	ra,0xffffe
    8000240a:	408080e7          	jalr	1032(ra) # 8000080e <panic>
    panic("sched locks");
    8000240e:	00006517          	auipc	a0,0x6
    80002412:	e5250513          	add	a0,a0,-430 # 80008260 <digits+0x228>
    80002416:	ffffe097          	auipc	ra,0xffffe
    8000241a:	3f8080e7          	jalr	1016(ra) # 8000080e <panic>
    panic("sched running");
    8000241e:	00006517          	auipc	a0,0x6
    80002422:	e5250513          	add	a0,a0,-430 # 80008270 <digits+0x238>
    80002426:	ffffe097          	auipc	ra,0xffffe
    8000242a:	3e8080e7          	jalr	1000(ra) # 8000080e <panic>
    panic("sched interruptible");
    8000242e:	00006517          	auipc	a0,0x6
    80002432:	e5250513          	add	a0,a0,-430 # 80008280 <digits+0x248>
    80002436:	ffffe097          	auipc	ra,0xffffe
    8000243a:	3d8080e7          	jalr	984(ra) # 8000080e <panic>

000000008000243e <yield>:
{
    8000243e:	1101                	add	sp,sp,-32
    80002440:	ec06                	sd	ra,24(sp)
    80002442:	e822                	sd	s0,16(sp)
    80002444:	e426                	sd	s1,8(sp)
    80002446:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80002448:	fffff097          	auipc	ra,0xfffff
    8000244c:	602080e7          	jalr	1538(ra) # 80001a4a <myproc>
    80002450:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	87a080e7          	jalr	-1926(ra) # 80000ccc <acquire>
  p->state = RUNNABLE;
    8000245a:	478d                	li	a5,3
    8000245c:	cc9c                	sw	a5,24(s1)
  enqueue_process(p, p->priority); /* UPDATED [2024-11-13] : 13:35:00 */
    8000245e:	1684a583          	lw	a1,360(s1)
    80002462:	8526                	mv	a0,s1
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	7b6080e7          	jalr	1974(ra) # 80001c1a <enqueue_process>
  sched();
    8000246c:	00000097          	auipc	ra,0x0
    80002470:	eec080e7          	jalr	-276(ra) # 80002358 <sched>
  release(&p->lock);
    80002474:	8526                	mv	a0,s1
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	90a080e7          	jalr	-1782(ra) # 80000d80 <release>
}
    8000247e:	60e2                	ld	ra,24(sp)
    80002480:	6442                	ld	s0,16(sp)
    80002482:	64a2                	ld	s1,8(sp)
    80002484:	6105                	add	sp,sp,32
    80002486:	8082                	ret

0000000080002488 <timer_interrupt>:
void timer_interrupt(void) { /* UPDATED [2024-11-13] : 13:35:00 */
    80002488:	7179                	add	sp,sp,-48
    8000248a:	f406                	sd	ra,40(sp)
    8000248c:	f022                	sd	s0,32(sp)
    8000248e:	ec26                	sd	s1,24(sp)
    80002490:	e84a                	sd	s2,16(sp)
    80002492:	e44e                	sd	s3,8(sp)
    80002494:	e052                	sd	s4,0(sp)
    80002496:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	5b2080e7          	jalr	1458(ra) # 80001a4a <myproc>
  if(p){
    800024a0:	c919                	beqz	a0,800024b6 <timer_interrupt+0x2e>
    800024a2:	84aa                	mv	s1,a0
    p->time_slice--;
    800024a4:	16c52783          	lw	a5,364(a0)
    800024a8:	37fd                	addw	a5,a5,-1
    800024aa:	0007871b          	sext.w	a4,a5
    800024ae:	16f52623          	sw	a5,364(a0)
    if(p->time_slice <= 0){
    800024b2:	02e05763          	blez	a4,800024e0 <timer_interrupt+0x58>
  tick_count++;
    800024b6:	00006717          	auipc	a4,0x6
    800024ba:	44270713          	add	a4,a4,1090 # 800088f8 <tick_count.2>
    800024be:	431c                	lw	a5,0(a4)
    800024c0:	2785                	addw	a5,a5,1
    800024c2:	0007869b          	sext.w	a3,a5
    800024c6:	c31c                	sw	a5,0(a4)
  if(tick_count >= 1000){ /* Example interval */
    800024c8:	3e700793          	li	a5,999
    800024cc:	08d7c563          	blt	a5,a3,80002556 <timer_interrupt+0xce>
}
    800024d0:	70a2                	ld	ra,40(sp)
    800024d2:	7402                	ld	s0,32(sp)
    800024d4:	64e2                	ld	s1,24(sp)
    800024d6:	6942                	ld	s2,16(sp)
    800024d8:	69a2                	ld	s3,8(sp)
    800024da:	6a02                	ld	s4,0(sp)
    800024dc:	6145                	add	sp,sp,48
    800024de:	8082                	ret
      acquire(&wait_lock);
    800024e0:	0000f517          	auipc	a0,0xf
    800024e4:	9d850513          	add	a0,a0,-1576 # 80010eb8 <wait_lock>
    800024e8:	ffffe097          	auipc	ra,0xffffe
    800024ec:	7e4080e7          	jalr	2020(ra) # 80000ccc <acquire>
      acquire(&p->lock);
    800024f0:	8526                	mv	a0,s1
    800024f2:	ffffe097          	auipc	ra,0xffffe
    800024f6:	7da080e7          	jalr	2010(ra) # 80000ccc <acquire>
      if(p->priority < MAX_QUEUES - 1){
    800024fa:	1684a783          	lw	a5,360(s1)
    800024fe:	4705                	li	a4,1
    80002500:	04f75263          	bge	a4,a5,80002544 <timer_interrupt+0xbc>
      switch(p->priority){
    80002504:	1684a583          	lw	a1,360(s1)
    80002508:	47d1                	li	a5,20
    8000250a:	e191                	bnez	a1,8000250e <timer_interrupt+0x86>
    8000250c:	4795                	li	a5,5
          p->time_slice = 5;
    8000250e:	16f4a623          	sw	a5,364(s1)
      enqueue_process(p, p->priority);
    80002512:	8526                	mv	a0,s1
    80002514:	fffff097          	auipc	ra,0xfffff
    80002518:	706080e7          	jalr	1798(ra) # 80001c1a <enqueue_process>
      p->state = RUNNABLE;
    8000251c:	478d                	li	a5,3
    8000251e:	cc9c                	sw	a5,24(s1)
      release(&p->lock);
    80002520:	8526                	mv	a0,s1
    80002522:	fffff097          	auipc	ra,0xfffff
    80002526:	85e080e7          	jalr	-1954(ra) # 80000d80 <release>
      release(&wait_lock);
    8000252a:	0000f517          	auipc	a0,0xf
    8000252e:	98e50513          	add	a0,a0,-1650 # 80010eb8 <wait_lock>
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	84e080e7          	jalr	-1970(ra) # 80000d80 <release>
      yield();
    8000253a:	00000097          	auipc	ra,0x0
    8000253e:	f04080e7          	jalr	-252(ra) # 8000243e <yield>
    80002542:	bf95                	j	800024b6 <timer_interrupt+0x2e>
        p->priority++;
    80002544:	2785                	addw	a5,a5,1
    80002546:	16f4a423          	sw	a5,360(s1)
      switch(p->priority){
    8000254a:	0007859b          	sext.w	a1,a5
    8000254e:	47a9                	li	a5,10
    80002550:	fae58fe3          	beq	a1,a4,8000250e <timer_interrupt+0x86>
    80002554:	bf55                	j	80002508 <timer_interrupt+0x80>
    acquire(&wait_lock);
    80002556:	0000f517          	auipc	a0,0xf
    8000255a:	96250513          	add	a0,a0,-1694 # 80010eb8 <wait_lock>
    8000255e:	ffffe097          	auipc	ra,0xffffe
    80002562:	76e080e7          	jalr	1902(ra) # 80000ccc <acquire>
    for(int i =0; i < NPROC; i++){
    80002566:	0000f497          	auipc	s1,0xf
    8000256a:	96a48493          	add	s1,s1,-1686 # 80010ed0 <proc>
    8000256e:	00015a17          	auipc	s4,0x15
    80002572:	962a0a13          	add	s4,s4,-1694 # 80016ed0 <tickslock>
      if(proc[i].state == RUNNABLE){
    80002576:	498d                	li	s3,3
    80002578:	a811                	j	8000258c <timer_interrupt+0x104>
        release(&proc[i].lock);
    8000257a:	854a                	mv	a0,s2
    8000257c:	fffff097          	auipc	ra,0xfffff
    80002580:	804080e7          	jalr	-2044(ra) # 80000d80 <release>
    for(int i =0; i < NPROC; i++){
    80002584:	18048493          	add	s1,s1,384
    80002588:	03448763          	beq	s1,s4,800025b6 <timer_interrupt+0x12e>
      if(proc[i].state == RUNNABLE){
    8000258c:	8926                	mv	s2,s1
    8000258e:	4c9c                	lw	a5,24(s1)
    80002590:	ff379ae3          	bne	a5,s3,80002584 <timer_interrupt+0xfc>
        acquire(&proc[i].lock);
    80002594:	8526                	mv	a0,s1
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	736080e7          	jalr	1846(ra) # 80000ccc <acquire>
        if(proc[i].priority != 0){
    8000259e:	1684a783          	lw	a5,360(s1)
    800025a2:	dfe1                	beqz	a5,8000257a <timer_interrupt+0xf2>
          proc[i].priority = 0; /* Boost to highest priority */
    800025a4:	1604a423          	sw	zero,360(s1)
          enqueue_process(&proc[i], proc[i].priority);
    800025a8:	4581                	li	a1,0
    800025aa:	8526                	mv	a0,s1
    800025ac:	fffff097          	auipc	ra,0xfffff
    800025b0:	66e080e7          	jalr	1646(ra) # 80001c1a <enqueue_process>
    800025b4:	b7d9                	j	8000257a <timer_interrupt+0xf2>
    tick_count = 0;
    800025b6:	00006797          	auipc	a5,0x6
    800025ba:	3407a123          	sw	zero,834(a5) # 800088f8 <tick_count.2>
    release(&wait_lock);
    800025be:	0000f517          	auipc	a0,0xf
    800025c2:	8fa50513          	add	a0,a0,-1798 # 80010eb8 <wait_lock>
    800025c6:	ffffe097          	auipc	ra,0xffffe
    800025ca:	7ba080e7          	jalr	1978(ra) # 80000d80 <release>
}
    800025ce:	b709                	j	800024d0 <timer_interrupt+0x48>

00000000800025d0 <sleep>:

/* Atomically release lock and sleep on chan. */
 /* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    800025d0:	7179                	add	sp,sp,-48
    800025d2:	f406                	sd	ra,40(sp)
    800025d4:	f022                	sd	s0,32(sp)
    800025d6:	ec26                	sd	s1,24(sp)
    800025d8:	e84a                	sd	s2,16(sp)
    800025da:	e44e                	sd	s3,8(sp)
    800025dc:	1800                	add	s0,sp,48
    800025de:	89aa                	mv	s3,a0
    800025e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800025e2:	fffff097          	auipc	ra,0xfffff
    800025e6:	468080e7          	jalr	1128(ra) # 80001a4a <myproc>
    800025ea:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    800025ec:	ffffe097          	auipc	ra,0xffffe
    800025f0:	6e0080e7          	jalr	1760(ra) # 80000ccc <acquire>
  release(lk);
    800025f4:	854a                	mv	a0,s2
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	78a080e7          	jalr	1930(ra) # 80000d80 <release>

  /* Go to sleep. */
  p->chan = chan;
    800025fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002602:	4789                	li	a5,2
    80002604:	cc9c                	sw	a5,24(s1)

  sched();
    80002606:	00000097          	auipc	ra,0x0
    8000260a:	d52080e7          	jalr	-686(ra) # 80002358 <sched>

  /* Tidy up. */
  p->chan = 0;
    8000260e:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    80002612:	8526                	mv	a0,s1
    80002614:	ffffe097          	auipc	ra,0xffffe
    80002618:	76c080e7          	jalr	1900(ra) # 80000d80 <release>
  acquire(lk);
    8000261c:	854a                	mv	a0,s2
    8000261e:	ffffe097          	auipc	ra,0xffffe
    80002622:	6ae080e7          	jalr	1710(ra) # 80000ccc <acquire>
}
    80002626:	70a2                	ld	ra,40(sp)
    80002628:	7402                	ld	s0,32(sp)
    8000262a:	64e2                	ld	s1,24(sp)
    8000262c:	6942                	ld	s2,16(sp)
    8000262e:	69a2                	ld	s3,8(sp)
    80002630:	6145                	add	sp,sp,48
    80002632:	8082                	ret

0000000080002634 <wakeup>:

/* Wake up all processes sleeping on chan. */
 /* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    80002634:	7139                	add	sp,sp,-64
    80002636:	fc06                	sd	ra,56(sp)
    80002638:	f822                	sd	s0,48(sp)
    8000263a:	f426                	sd	s1,40(sp)
    8000263c:	f04a                	sd	s2,32(sp)
    8000263e:	ec4e                	sd	s3,24(sp)
    80002640:	e852                	sd	s4,16(sp)
    80002642:	e456                	sd	s5,8(sp)
    80002644:	0080                	add	s0,sp,64
    80002646:	8a2a                	mv	s4,a0
  struct proc *p;

  acquire(&wait_lock);
    80002648:	0000f517          	auipc	a0,0xf
    8000264c:	87050513          	add	a0,a0,-1936 # 80010eb8 <wait_lock>
    80002650:	ffffe097          	auipc	ra,0xffffe
    80002654:	67c080e7          	jalr	1660(ra) # 80000ccc <acquire>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002658:	0000f497          	auipc	s1,0xf
    8000265c:	87848493          	add	s1,s1,-1928 # 80010ed0 <proc>
    if(p->state == SLEEPING && p->chan == chan){
    80002660:	4989                	li	s3,2
      acquire(&p->lock);
      p->state = RUNNABLE;
    80002662:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002664:	00015917          	auipc	s2,0x15
    80002668:	86c90913          	add	s2,s2,-1940 # 80016ed0 <tickslock>
    8000266c:	a029                	j	80002676 <wakeup+0x42>
    8000266e:	18048493          	add	s1,s1,384
    80002672:	03248c63          	beq	s1,s2,800026aa <wakeup+0x76>
    if(p->state == SLEEPING && p->chan == chan){
    80002676:	4c9c                	lw	a5,24(s1)
    80002678:	ff379be3          	bne	a5,s3,8000266e <wakeup+0x3a>
    8000267c:	709c                	ld	a5,32(s1)
    8000267e:	ff4798e3          	bne	a5,s4,8000266e <wakeup+0x3a>
      acquire(&p->lock);
    80002682:	8526                	mv	a0,s1
    80002684:	ffffe097          	auipc	ra,0xffffe
    80002688:	648080e7          	jalr	1608(ra) # 80000ccc <acquire>
      p->state = RUNNABLE;
    8000268c:	0154ac23          	sw	s5,24(s1)
      enqueue_process(p, p->priority); /* UPDATED [2024-11-13] : 13:35:00 */
    80002690:	1684a583          	lw	a1,360(s1)
    80002694:	8526                	mv	a0,s1
    80002696:	fffff097          	auipc	ra,0xfffff
    8000269a:	584080e7          	jalr	1412(ra) # 80001c1a <enqueue_process>
      release(&p->lock);
    8000269e:	8526                	mv	a0,s1
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	6e0080e7          	jalr	1760(ra) # 80000d80 <release>
    800026a8:	b7d9                	j	8000266e <wakeup+0x3a>
    }
  }
  release(&wait_lock);
    800026aa:	0000f517          	auipc	a0,0xf
    800026ae:	80e50513          	add	a0,a0,-2034 # 80010eb8 <wait_lock>
    800026b2:	ffffe097          	auipc	ra,0xffffe
    800026b6:	6ce080e7          	jalr	1742(ra) # 80000d80 <release>
}
    800026ba:	70e2                	ld	ra,56(sp)
    800026bc:	7442                	ld	s0,48(sp)
    800026be:	74a2                	ld	s1,40(sp)
    800026c0:	7902                	ld	s2,32(sp)
    800026c2:	69e2                	ld	s3,24(sp)
    800026c4:	6a42                	ld	s4,16(sp)
    800026c6:	6aa2                	ld	s5,8(sp)
    800026c8:	6121                	add	sp,sp,64
    800026ca:	8082                	ret

00000000800026cc <reparent>:
{
    800026cc:	7179                	add	sp,sp,-48
    800026ce:	f406                	sd	ra,40(sp)
    800026d0:	f022                	sd	s0,32(sp)
    800026d2:	ec26                	sd	s1,24(sp)
    800026d4:	e84a                	sd	s2,16(sp)
    800026d6:	e44e                	sd	s3,8(sp)
    800026d8:	e052                	sd	s4,0(sp)
    800026da:	1800                	add	s0,sp,48
    800026dc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800026de:	0000e497          	auipc	s1,0xe
    800026e2:	7f248493          	add	s1,s1,2034 # 80010ed0 <proc>
      pp->parent = initproc;
    800026e6:	00006a17          	auipc	s4,0x6
    800026ea:	21aa0a13          	add	s4,s4,538 # 80008900 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800026ee:	00014997          	auipc	s3,0x14
    800026f2:	7e298993          	add	s3,s3,2018 # 80016ed0 <tickslock>
    800026f6:	a029                	j	80002700 <reparent+0x34>
    800026f8:	18048493          	add	s1,s1,384
    800026fc:	01348d63          	beq	s1,s3,80002716 <reparent+0x4a>
    if(pp->parent == p){
    80002700:	7c9c                	ld	a5,56(s1)
    80002702:	ff279be3          	bne	a5,s2,800026f8 <reparent+0x2c>
      pp->parent = initproc;
    80002706:	000a3503          	ld	a0,0(s4)
    8000270a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	f28080e7          	jalr	-216(ra) # 80002634 <wakeup>
    80002714:	b7d5                	j	800026f8 <reparent+0x2c>
}
    80002716:	70a2                	ld	ra,40(sp)
    80002718:	7402                	ld	s0,32(sp)
    8000271a:	64e2                	ld	s1,24(sp)
    8000271c:	6942                	ld	s2,16(sp)
    8000271e:	69a2                	ld	s3,8(sp)
    80002720:	6a02                	ld	s4,0(sp)
    80002722:	6145                	add	sp,sp,48
    80002724:	8082                	ret

0000000080002726 <exit>:
{
    80002726:	7179                	add	sp,sp,-48
    80002728:	f406                	sd	ra,40(sp)
    8000272a:	f022                	sd	s0,32(sp)
    8000272c:	ec26                	sd	s1,24(sp)
    8000272e:	e84a                	sd	s2,16(sp)
    80002730:	e44e                	sd	s3,8(sp)
    80002732:	e052                	sd	s4,0(sp)
    80002734:	1800                	add	s0,sp,48
    80002736:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002738:	fffff097          	auipc	ra,0xfffff
    8000273c:	312080e7          	jalr	786(ra) # 80001a4a <myproc>
    80002740:	89aa                	mv	s3,a0
  if(p == initproc)
    80002742:	00006797          	auipc	a5,0x6
    80002746:	1be7b783          	ld	a5,446(a5) # 80008900 <initproc>
    8000274a:	0d050493          	add	s1,a0,208
    8000274e:	15050913          	add	s2,a0,336
    80002752:	02a79363          	bne	a5,a0,80002778 <exit+0x52>
    panic("init exiting");
    80002756:	00006517          	auipc	a0,0x6
    8000275a:	b4250513          	add	a0,a0,-1214 # 80008298 <digits+0x260>
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	0b0080e7          	jalr	176(ra) # 8000080e <panic>
      fileclose(f);
    80002766:	00002097          	auipc	ra,0x2
    8000276a:	2c6080e7          	jalr	710(ra) # 80004a2c <fileclose>
      p->ofile[fd] = 0;
    8000276e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002772:	04a1                	add	s1,s1,8
    80002774:	01248563          	beq	s1,s2,8000277e <exit+0x58>
    if(p->ofile[fd]){
    80002778:	6088                	ld	a0,0(s1)
    8000277a:	f575                	bnez	a0,80002766 <exit+0x40>
    8000277c:	bfdd                	j	80002772 <exit+0x4c>
  begin_op();
    8000277e:	00002097          	auipc	ra,0x2
    80002782:	dea080e7          	jalr	-534(ra) # 80004568 <begin_op>
  iput(p->cwd);
    80002786:	1509b503          	ld	a0,336(s3)
    8000278a:	00001097          	auipc	ra,0x1
    8000278e:	5f2080e7          	jalr	1522(ra) # 80003d7c <iput>
  end_op();
    80002792:	00002097          	auipc	ra,0x2
    80002796:	e50080e7          	jalr	-432(ra) # 800045e2 <end_op>
  p->cwd = 0;
    8000279a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000279e:	0000e497          	auipc	s1,0xe
    800027a2:	71a48493          	add	s1,s1,1818 # 80010eb8 <wait_lock>
    800027a6:	8526                	mv	a0,s1
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	524080e7          	jalr	1316(ra) # 80000ccc <acquire>
  reparent(p);
    800027b0:	854e                	mv	a0,s3
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	f1a080e7          	jalr	-230(ra) # 800026cc <reparent>
  wakeup(p->parent);
    800027ba:	0389b503          	ld	a0,56(s3)
    800027be:	00000097          	auipc	ra,0x0
    800027c2:	e76080e7          	jalr	-394(ra) # 80002634 <wakeup>
  acquire(&p->lock);
    800027c6:	854e                	mv	a0,s3
    800027c8:	ffffe097          	auipc	ra,0xffffe
    800027cc:	504080e7          	jalr	1284(ra) # 80000ccc <acquire>
  p->xstate = status;
    800027d0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800027d4:	4795                	li	a5,5
    800027d6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800027da:	8526                	mv	a0,s1
    800027dc:	ffffe097          	auipc	ra,0xffffe
    800027e0:	5a4080e7          	jalr	1444(ra) # 80000d80 <release>
  sched();
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	b74080e7          	jalr	-1164(ra) # 80002358 <sched>
  panic("zombie exit");
    800027ec:	00006517          	auipc	a0,0x6
    800027f0:	abc50513          	add	a0,a0,-1348 # 800082a8 <digits+0x270>
    800027f4:	ffffe097          	auipc	ra,0xffffe
    800027f8:	01a080e7          	jalr	26(ra) # 8000080e <panic>

00000000800027fc <kill>:
/* Kill the process with the given pid. */
 /* The victim won't exit until it tries to return */
 /* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    800027fc:	7179                	add	sp,sp,-48
    800027fe:	f406                	sd	ra,40(sp)
    80002800:	f022                	sd	s0,32(sp)
    80002802:	ec26                	sd	s1,24(sp)
    80002804:	e84a                	sd	s2,16(sp)
    80002806:	e44e                	sd	s3,8(sp)
    80002808:	1800                	add	s0,sp,48
    8000280a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000280c:	0000e497          	auipc	s1,0xe
    80002810:	6c448493          	add	s1,s1,1732 # 80010ed0 <proc>
    80002814:	00014997          	auipc	s3,0x14
    80002818:	6bc98993          	add	s3,s3,1724 # 80016ed0 <tickslock>
    acquire(&p->lock);
    8000281c:	8526                	mv	a0,s1
    8000281e:	ffffe097          	auipc	ra,0xffffe
    80002822:	4ae080e7          	jalr	1198(ra) # 80000ccc <acquire>
    if(p->pid == pid){
    80002826:	589c                	lw	a5,48(s1)
    80002828:	01278d63          	beq	a5,s2,80002842 <kill+0x46>
        enqueue_process(p, p->priority); /* UPDATED [2024-11-13] : 13:35:00 */
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000282c:	8526                	mv	a0,s1
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	552080e7          	jalr	1362(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002836:	18048493          	add	s1,s1,384
    8000283a:	ff3491e3          	bne	s1,s3,8000281c <kill+0x20>
  }
  return -1;
    8000283e:	557d                	li	a0,-1
    80002840:	a829                	j	8000285a <kill+0x5e>
      p->killed = 1;
    80002842:	4785                	li	a5,1
    80002844:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002846:	4c98                	lw	a4,24(s1)
    80002848:	4789                	li	a5,2
    8000284a:	00f70f63          	beq	a4,a5,80002868 <kill+0x6c>
      release(&p->lock);
    8000284e:	8526                	mv	a0,s1
    80002850:	ffffe097          	auipc	ra,0xffffe
    80002854:	530080e7          	jalr	1328(ra) # 80000d80 <release>
      return 0;
    80002858:	4501                	li	a0,0
}
    8000285a:	70a2                	ld	ra,40(sp)
    8000285c:	7402                	ld	s0,32(sp)
    8000285e:	64e2                	ld	s1,24(sp)
    80002860:	6942                	ld	s2,16(sp)
    80002862:	69a2                	ld	s3,8(sp)
    80002864:	6145                	add	sp,sp,48
    80002866:	8082                	ret
        p->state = RUNNABLE;
    80002868:	478d                	li	a5,3
    8000286a:	cc9c                	sw	a5,24(s1)
        enqueue_process(p, p->priority); /* UPDATED [2024-11-13] : 13:35:00 */
    8000286c:	1684a583          	lw	a1,360(s1)
    80002870:	8526                	mv	a0,s1
    80002872:	fffff097          	auipc	ra,0xfffff
    80002876:	3a8080e7          	jalr	936(ra) # 80001c1a <enqueue_process>
    8000287a:	bfd1                	j	8000284e <kill+0x52>

000000008000287c <setkilled>:

void
setkilled(struct proc *p)
{
    8000287c:	1101                	add	sp,sp,-32
    8000287e:	ec06                	sd	ra,24(sp)
    80002880:	e822                	sd	s0,16(sp)
    80002882:	e426                	sd	s1,8(sp)
    80002884:	1000                	add	s0,sp,32
    80002886:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002888:	ffffe097          	auipc	ra,0xffffe
    8000288c:	444080e7          	jalr	1092(ra) # 80000ccc <acquire>
  p->killed = 1;
    80002890:	4785                	li	a5,1
    80002892:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002894:	8526                	mv	a0,s1
    80002896:	ffffe097          	auipc	ra,0xffffe
    8000289a:	4ea080e7          	jalr	1258(ra) # 80000d80 <release>
}
    8000289e:	60e2                	ld	ra,24(sp)
    800028a0:	6442                	ld	s0,16(sp)
    800028a2:	64a2                	ld	s1,8(sp)
    800028a4:	6105                	add	sp,sp,32
    800028a6:	8082                	ret

00000000800028a8 <killed>:

int
killed(struct proc *p)
{
    800028a8:	1101                	add	sp,sp,-32
    800028aa:	ec06                	sd	ra,24(sp)
    800028ac:	e822                	sd	s0,16(sp)
    800028ae:	e426                	sd	s1,8(sp)
    800028b0:	e04a                	sd	s2,0(sp)
    800028b2:	1000                	add	s0,sp,32
    800028b4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800028b6:	ffffe097          	auipc	ra,0xffffe
    800028ba:	416080e7          	jalr	1046(ra) # 80000ccc <acquire>
  k = p->killed;
    800028be:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800028c2:	8526                	mv	a0,s1
    800028c4:	ffffe097          	auipc	ra,0xffffe
    800028c8:	4bc080e7          	jalr	1212(ra) # 80000d80 <release>
  return k;
}
    800028cc:	854a                	mv	a0,s2
    800028ce:	60e2                	ld	ra,24(sp)
    800028d0:	6442                	ld	s0,16(sp)
    800028d2:	64a2                	ld	s1,8(sp)
    800028d4:	6902                	ld	s2,0(sp)
    800028d6:	6105                	add	sp,sp,32
    800028d8:	8082                	ret

00000000800028da <wait>:
{
    800028da:	715d                	add	sp,sp,-80
    800028dc:	e486                	sd	ra,72(sp)
    800028de:	e0a2                	sd	s0,64(sp)
    800028e0:	fc26                	sd	s1,56(sp)
    800028e2:	f84a                	sd	s2,48(sp)
    800028e4:	f44e                	sd	s3,40(sp)
    800028e6:	f052                	sd	s4,32(sp)
    800028e8:	ec56                	sd	s5,24(sp)
    800028ea:	e85a                	sd	s6,16(sp)
    800028ec:	e45e                	sd	s7,8(sp)
    800028ee:	e062                	sd	s8,0(sp)
    800028f0:	0880                	add	s0,sp,80
    800028f2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800028f4:	fffff097          	auipc	ra,0xfffff
    800028f8:	156080e7          	jalr	342(ra) # 80001a4a <myproc>
    800028fc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800028fe:	0000e517          	auipc	a0,0xe
    80002902:	5ba50513          	add	a0,a0,1466 # 80010eb8 <wait_lock>
    80002906:	ffffe097          	auipc	ra,0xffffe
    8000290a:	3c6080e7          	jalr	966(ra) # 80000ccc <acquire>
    havekids = 0;
    8000290e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002910:	4a15                	li	s4,5
        havekids = 1;
    80002912:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002914:	00014997          	auipc	s3,0x14
    80002918:	5bc98993          	add	s3,s3,1468 # 80016ed0 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    8000291c:	0000ec17          	auipc	s8,0xe
    80002920:	59cc0c13          	add	s8,s8,1436 # 80010eb8 <wait_lock>
    80002924:	a0d1                	j	800029e8 <wait+0x10e>
          pid = pp->pid;
    80002926:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000292a:	000b0e63          	beqz	s6,80002946 <wait+0x6c>
    8000292e:	4691                	li	a3,4
    80002930:	02c48613          	add	a2,s1,44
    80002934:	85da                	mv	a1,s6
    80002936:	05093503          	ld	a0,80(s2)
    8000293a:	fffff097          	auipc	ra,0xfffff
    8000293e:	e4a080e7          	jalr	-438(ra) # 80001784 <copyout>
    80002942:	04054163          	bltz	a0,80002984 <wait+0xaa>
          freeproc(pp);
    80002946:	8526                	mv	a0,s1
    80002948:	fffff097          	auipc	ra,0xfffff
    8000294c:	68a080e7          	jalr	1674(ra) # 80001fd2 <freeproc>
          release(&pp->lock);
    80002950:	8526                	mv	a0,s1
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	42e080e7          	jalr	1070(ra) # 80000d80 <release>
          release(&wait_lock);
    8000295a:	0000e517          	auipc	a0,0xe
    8000295e:	55e50513          	add	a0,a0,1374 # 80010eb8 <wait_lock>
    80002962:	ffffe097          	auipc	ra,0xffffe
    80002966:	41e080e7          	jalr	1054(ra) # 80000d80 <release>
}
    8000296a:	854e                	mv	a0,s3
    8000296c:	60a6                	ld	ra,72(sp)
    8000296e:	6406                	ld	s0,64(sp)
    80002970:	74e2                	ld	s1,56(sp)
    80002972:	7942                	ld	s2,48(sp)
    80002974:	79a2                	ld	s3,40(sp)
    80002976:	7a02                	ld	s4,32(sp)
    80002978:	6ae2                	ld	s5,24(sp)
    8000297a:	6b42                	ld	s6,16(sp)
    8000297c:	6ba2                	ld	s7,8(sp)
    8000297e:	6c02                	ld	s8,0(sp)
    80002980:	6161                	add	sp,sp,80
    80002982:	8082                	ret
            release(&pp->lock);
    80002984:	8526                	mv	a0,s1
    80002986:	ffffe097          	auipc	ra,0xffffe
    8000298a:	3fa080e7          	jalr	1018(ra) # 80000d80 <release>
            release(&wait_lock);
    8000298e:	0000e517          	auipc	a0,0xe
    80002992:	52a50513          	add	a0,a0,1322 # 80010eb8 <wait_lock>
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	3ea080e7          	jalr	1002(ra) # 80000d80 <release>
            return -1;
    8000299e:	59fd                	li	s3,-1
    800029a0:	b7e9                	j	8000296a <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800029a2:	18048493          	add	s1,s1,384
    800029a6:	03348463          	beq	s1,s3,800029ce <wait+0xf4>
      if(pp->parent == p){
    800029aa:	7c9c                	ld	a5,56(s1)
    800029ac:	ff279be3          	bne	a5,s2,800029a2 <wait+0xc8>
        acquire(&pp->lock);
    800029b0:	8526                	mv	a0,s1
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	31a080e7          	jalr	794(ra) # 80000ccc <acquire>
        if(pp->state == ZOMBIE){
    800029ba:	4c9c                	lw	a5,24(s1)
    800029bc:	f74785e3          	beq	a5,s4,80002926 <wait+0x4c>
        release(&pp->lock);
    800029c0:	8526                	mv	a0,s1
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	3be080e7          	jalr	958(ra) # 80000d80 <release>
        havekids = 1;
    800029ca:	8756                	mv	a4,s5
    800029cc:	bfd9                	j	800029a2 <wait+0xc8>
    if(!havekids || killed(p)){
    800029ce:	c31d                	beqz	a4,800029f4 <wait+0x11a>
    800029d0:	854a                	mv	a0,s2
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	ed6080e7          	jalr	-298(ra) # 800028a8 <killed>
    800029da:	ed09                	bnez	a0,800029f4 <wait+0x11a>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800029dc:	85e2                	mv	a1,s8
    800029de:	854a                	mv	a0,s2
    800029e0:	00000097          	auipc	ra,0x0
    800029e4:	bf0080e7          	jalr	-1040(ra) # 800025d0 <sleep>
    havekids = 0;
    800029e8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800029ea:	0000e497          	auipc	s1,0xe
    800029ee:	4e648493          	add	s1,s1,1254 # 80010ed0 <proc>
    800029f2:	bf65                	j	800029aa <wait+0xd0>
      release(&wait_lock);
    800029f4:	0000e517          	auipc	a0,0xe
    800029f8:	4c450513          	add	a0,a0,1220 # 80010eb8 <wait_lock>
    800029fc:	ffffe097          	auipc	ra,0xffffe
    80002a00:	384080e7          	jalr	900(ra) # 80000d80 <release>
      return -1;
    80002a04:	59fd                	li	s3,-1
    80002a06:	b795                	j	8000296a <wait+0x90>

0000000080002a08 <either_copyout>:
/* Copy to either a user address, or kernel address, */
 /* depending on usr_dst. */
 /* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002a08:	7179                	add	sp,sp,-48
    80002a0a:	f406                	sd	ra,40(sp)
    80002a0c:	f022                	sd	s0,32(sp)
    80002a0e:	ec26                	sd	s1,24(sp)
    80002a10:	e84a                	sd	s2,16(sp)
    80002a12:	e44e                	sd	s3,8(sp)
    80002a14:	e052                	sd	s4,0(sp)
    80002a16:	1800                	add	s0,sp,48
    80002a18:	84aa                	mv	s1,a0
    80002a1a:	892e                	mv	s2,a1
    80002a1c:	89b2                	mv	s3,a2
    80002a1e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a20:	fffff097          	auipc	ra,0xfffff
    80002a24:	02a080e7          	jalr	42(ra) # 80001a4a <myproc>
  if(user_dst){
    80002a28:	c08d                	beqz	s1,80002a4a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002a2a:	86d2                	mv	a3,s4
    80002a2c:	864e                	mv	a2,s3
    80002a2e:	85ca                	mv	a1,s2
    80002a30:	6928                	ld	a0,80(a0)
    80002a32:	fffff097          	auipc	ra,0xfffff
    80002a36:	d52080e7          	jalr	-686(ra) # 80001784 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002a3a:	70a2                	ld	ra,40(sp)
    80002a3c:	7402                	ld	s0,32(sp)
    80002a3e:	64e2                	ld	s1,24(sp)
    80002a40:	6942                	ld	s2,16(sp)
    80002a42:	69a2                	ld	s3,8(sp)
    80002a44:	6a02                	ld	s4,0(sp)
    80002a46:	6145                	add	sp,sp,48
    80002a48:	8082                	ret
    memmove((char *)dst, src, len);
    80002a4a:	000a061b          	sext.w	a2,s4
    80002a4e:	85ce                	mv	a1,s3
    80002a50:	854a                	mv	a0,s2
    80002a52:	ffffe097          	auipc	ra,0xffffe
    80002a56:	3d2080e7          	jalr	978(ra) # 80000e24 <memmove>
    return 0;
    80002a5a:	8526                	mv	a0,s1
    80002a5c:	bff9                	j	80002a3a <either_copyout+0x32>

0000000080002a5e <either_copyin>:
/* Copy from either a user address, or kernel address, */
 /* depending on usr_src. */
 /* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002a5e:	7179                	add	sp,sp,-48
    80002a60:	f406                	sd	ra,40(sp)
    80002a62:	f022                	sd	s0,32(sp)
    80002a64:	ec26                	sd	s1,24(sp)
    80002a66:	e84a                	sd	s2,16(sp)
    80002a68:	e44e                	sd	s3,8(sp)
    80002a6a:	e052                	sd	s4,0(sp)
    80002a6c:	1800                	add	s0,sp,48
    80002a6e:	892a                	mv	s2,a0
    80002a70:	84ae                	mv	s1,a1
    80002a72:	89b2                	mv	s3,a2
    80002a74:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a76:	fffff097          	auipc	ra,0xfffff
    80002a7a:	fd4080e7          	jalr	-44(ra) # 80001a4a <myproc>
  if(user_src){
    80002a7e:	c08d                	beqz	s1,80002aa0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002a80:	86d2                	mv	a3,s4
    80002a82:	864e                	mv	a2,s3
    80002a84:	85ca                	mv	a1,s2
    80002a86:	6928                	ld	a0,80(a0)
    80002a88:	fffff097          	auipc	ra,0xfffff
    80002a8c:	dbc080e7          	jalr	-580(ra) # 80001844 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6a02                	ld	s4,0(sp)
    80002a9c:	6145                	add	sp,sp,48
    80002a9e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002aa0:	000a061b          	sext.w	a2,s4
    80002aa4:	85ce                	mv	a1,s3
    80002aa6:	854a                	mv	a0,s2
    80002aa8:	ffffe097          	auipc	ra,0xffffe
    80002aac:	37c080e7          	jalr	892(ra) # 80000e24 <memmove>
    return 0;
    80002ab0:	8526                	mv	a0,s1
    80002ab2:	bff9                	j	80002a90 <either_copyin+0x32>

0000000080002ab4 <procdump>:
/* Print a process listing to console.  For debugging. */
 /* Runs when user types ^P on console. */
 /* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    80002ab4:	715d                	add	sp,sp,-80
    80002ab6:	e486                	sd	ra,72(sp)
    80002ab8:	e0a2                	sd	s0,64(sp)
    80002aba:	fc26                	sd	s1,56(sp)
    80002abc:	f84a                	sd	s2,48(sp)
    80002abe:	f44e                	sd	s3,40(sp)
    80002ac0:	f052                	sd	s4,32(sp)
    80002ac2:	ec56                	sd	s5,24(sp)
    80002ac4:	e85a                	sd	s6,16(sp)
    80002ac6:	e45e                	sd	s7,8(sp)
    80002ac8:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002aca:	00005517          	auipc	a0,0x5
    80002ace:	5f650513          	add	a0,a0,1526 # 800080c0 <digits+0x88>
    80002ad2:	ffffe097          	auipc	ra,0xffffe
    80002ad6:	a30080e7          	jalr	-1488(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002ada:	0000e497          	auipc	s1,0xe
    80002ade:	54e48493          	add	s1,s1,1358 # 80011028 <proc+0x158>
    80002ae2:	00014917          	auipc	s2,0x14
    80002ae6:	54690913          	add	s2,s2,1350 # 80017028 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002aea:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002aec:	00005997          	auipc	s3,0x5
    80002af0:	7cc98993          	add	s3,s3,1996 # 800082b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002af4:	00005a97          	auipc	s5,0x5
    80002af8:	7cca8a93          	add	s5,s5,1996 # 800082c0 <digits+0x288>
    printf("\n");
    80002afc:	00005a17          	auipc	s4,0x5
    80002b00:	5c4a0a13          	add	s4,s4,1476 # 800080c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b04:	00005b97          	auipc	s7,0x5
    80002b08:	7fcb8b93          	add	s7,s7,2044 # 80008300 <states.0>
    80002b0c:	a00d                	j	80002b2e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002b0e:	ed86a583          	lw	a1,-296(a3)
    80002b12:	8556                	mv	a0,s5
    80002b14:	ffffe097          	auipc	ra,0xffffe
    80002b18:	9ee080e7          	jalr	-1554(ra) # 80000502 <printf>
    printf("\n");
    80002b1c:	8552                	mv	a0,s4
    80002b1e:	ffffe097          	auipc	ra,0xffffe
    80002b22:	9e4080e7          	jalr	-1564(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002b26:	18048493          	add	s1,s1,384
    80002b2a:	03248263          	beq	s1,s2,80002b4e <procdump+0x9a>
    if(p->state == UNUSED)
    80002b2e:	86a6                	mv	a3,s1
    80002b30:	ec04a783          	lw	a5,-320(s1)
    80002b34:	dbed                	beqz	a5,80002b26 <procdump+0x72>
      state = "???";
    80002b36:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b38:	fcfb6be3          	bltu	s6,a5,80002b0e <procdump+0x5a>
    80002b3c:	02079713          	sll	a4,a5,0x20
    80002b40:	01d75793          	srl	a5,a4,0x1d
    80002b44:	97de                	add	a5,a5,s7
    80002b46:	6390                	ld	a2,0(a5)
    80002b48:	f279                	bnez	a2,80002b0e <procdump+0x5a>
      state = "???";
    80002b4a:	864e                	mv	a2,s3
    80002b4c:	b7c9                	j	80002b0e <procdump+0x5a>
  }
}
    80002b4e:	60a6                	ld	ra,72(sp)
    80002b50:	6406                	ld	s0,64(sp)
    80002b52:	74e2                	ld	s1,56(sp)
    80002b54:	7942                	ld	s2,48(sp)
    80002b56:	79a2                	ld	s3,40(sp)
    80002b58:	7a02                	ld	s4,32(sp)
    80002b5a:	6ae2                	ld	s5,24(sp)
    80002b5c:	6b42                	ld	s6,16(sp)
    80002b5e:	6ba2                	ld	s7,8(sp)
    80002b60:	6161                	add	sp,sp,80
    80002b62:	8082                	ret

0000000080002b64 <swtch>:
    80002b64:	00153023          	sd	ra,0(a0)
    80002b68:	00253423          	sd	sp,8(a0)
    80002b6c:	e900                	sd	s0,16(a0)
    80002b6e:	ed04                	sd	s1,24(a0)
    80002b70:	03253023          	sd	s2,32(a0)
    80002b74:	03353423          	sd	s3,40(a0)
    80002b78:	03453823          	sd	s4,48(a0)
    80002b7c:	03553c23          	sd	s5,56(a0)
    80002b80:	05653023          	sd	s6,64(a0)
    80002b84:	05753423          	sd	s7,72(a0)
    80002b88:	05853823          	sd	s8,80(a0)
    80002b8c:	05953c23          	sd	s9,88(a0)
    80002b90:	07a53023          	sd	s10,96(a0)
    80002b94:	07b53423          	sd	s11,104(a0)
    80002b98:	0005b083          	ld	ra,0(a1)
    80002b9c:	0085b103          	ld	sp,8(a1)
    80002ba0:	6980                	ld	s0,16(a1)
    80002ba2:	6d84                	ld	s1,24(a1)
    80002ba4:	0205b903          	ld	s2,32(a1)
    80002ba8:	0285b983          	ld	s3,40(a1)
    80002bac:	0305ba03          	ld	s4,48(a1)
    80002bb0:	0385ba83          	ld	s5,56(a1)
    80002bb4:	0405bb03          	ld	s6,64(a1)
    80002bb8:	0485bb83          	ld	s7,72(a1)
    80002bbc:	0505bc03          	ld	s8,80(a1)
    80002bc0:	0585bc83          	ld	s9,88(a1)
    80002bc4:	0605bd03          	ld	s10,96(a1)
    80002bc8:	0685bd83          	ld	s11,104(a1)
    80002bcc:	8082                	ret

0000000080002bce <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002bce:	1141                	add	sp,sp,-16
    80002bd0:	e406                	sd	ra,8(sp)
    80002bd2:	e022                	sd	s0,0(sp)
    80002bd4:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002bd6:	00005597          	auipc	a1,0x5
    80002bda:	75a58593          	add	a1,a1,1882 # 80008330 <states.0+0x30>
    80002bde:	00014517          	auipc	a0,0x14
    80002be2:	2f250513          	add	a0,a0,754 # 80016ed0 <tickslock>
    80002be6:	ffffe097          	auipc	ra,0xffffe
    80002bea:	056080e7          	jalr	86(ra) # 80000c3c <initlock>
}
    80002bee:	60a2                	ld	ra,8(sp)
    80002bf0:	6402                	ld	s0,0(sp)
    80002bf2:	0141                	add	sp,sp,16
    80002bf4:	8082                	ret

0000000080002bf6 <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    80002bf6:	1141                	add	sp,sp,-16
    80002bf8:	e422                	sd	s0,8(sp)
    80002bfa:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bfc:	00003797          	auipc	a5,0x3
    80002c00:	45478793          	add	a5,a5,1108 # 80006050 <kernelvec>
    80002c04:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002c08:	6422                	ld	s0,8(sp)
    80002c0a:	0141                	add	sp,sp,16
    80002c0c:	8082                	ret

0000000080002c0e <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    80002c0e:	1141                	add	sp,sp,-16
    80002c10:	e406                	sd	ra,8(sp)
    80002c12:	e022                	sd	s0,0(sp)
    80002c14:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002c16:	fffff097          	auipc	ra,0xfffff
    80002c1a:	e34080e7          	jalr	-460(ra) # 80001a4a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c22:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c24:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c28:	00004697          	auipc	a3,0x4
    80002c2c:	3d868693          	add	a3,a3,984 # 80007000 <_trampoline>
    80002c30:	00004717          	auipc	a4,0x4
    80002c34:	3d070713          	add	a4,a4,976 # 80007000 <_trampoline>
    80002c38:	8f15                	sub	a4,a4,a3
    80002c3a:	040007b7          	lui	a5,0x4000
    80002c3e:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002c40:	07b2                	sll	a5,a5,0xc
    80002c42:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c44:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    80002c48:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002c4a:	18002673          	csrr	a2,satp
    80002c4e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    80002c50:	6d30                	ld	a2,88(a0)
    80002c52:	6138                	ld	a4,64(a0)
    80002c54:	6585                	lui	a1,0x1
    80002c56:	972e                	add	a4,a4,a1
    80002c58:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002c5a:	6d38                	ld	a4,88(a0)
    80002c5c:	00000617          	auipc	a2,0x0
    80002c60:	13460613          	add	a2,a2,308 # 80002d90 <usertrap>
    80002c64:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    80002c66:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c68:	8612                	mv	a2,tp
    80002c6a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c6c:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    80002c70:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    80002c74:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c78:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    80002c7c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c7e:	6f18                	ld	a4,24(a4)
    80002c80:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    80002c84:	6928                	ld	a0,80(a0)
    80002c86:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002c88:	00004717          	auipc	a4,0x4
    80002c8c:	41470713          	add	a4,a4,1044 # 8000709c <userret>
    80002c90:	8f15                	sub	a4,a4,a3
    80002c92:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002c94:	577d                	li	a4,-1
    80002c96:	177e                	sll	a4,a4,0x3f
    80002c98:	8d59                	or	a0,a0,a4
    80002c9a:	9782                	jalr	a5
}
    80002c9c:	60a2                	ld	ra,8(sp)
    80002c9e:	6402                	ld	s0,0(sp)
    80002ca0:	0141                	add	sp,sp,16
    80002ca2:	8082                	ret

0000000080002ca4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002ca4:	1101                	add	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	e426                	sd	s1,8(sp)
    80002cac:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    80002cae:	fffff097          	auipc	ra,0xfffff
    80002cb2:	d6a080e7          	jalr	-662(ra) # 80001a18 <cpuid>
    80002cb6:	cd19                	beqz	a0,80002cd4 <clockintr+0x30>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002cb8:	c01027f3          	rdtime	a5
  }

  /* ask for the next timer interrupt. this also clears */
  /* the interrupt request. 1000000 is about a tenth */
  /* of a second. */
  w_stimecmp(r_time() + 1000000);
    80002cbc:	000f4737          	lui	a4,0xf4
    80002cc0:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002cc4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002cc6:	14d79073          	csrw	stimecmp,a5
}
    80002cca:	60e2                	ld	ra,24(sp)
    80002ccc:	6442                	ld	s0,16(sp)
    80002cce:	64a2                	ld	s1,8(sp)
    80002cd0:	6105                	add	sp,sp,32
    80002cd2:	8082                	ret
    acquire(&tickslock);
    80002cd4:	00014497          	auipc	s1,0x14
    80002cd8:	1fc48493          	add	s1,s1,508 # 80016ed0 <tickslock>
    80002cdc:	8526                	mv	a0,s1
    80002cde:	ffffe097          	auipc	ra,0xffffe
    80002ce2:	fee080e7          	jalr	-18(ra) # 80000ccc <acquire>
    ticks++;
    80002ce6:	00006517          	auipc	a0,0x6
    80002cea:	c2250513          	add	a0,a0,-990 # 80008908 <ticks>
    80002cee:	411c                	lw	a5,0(a0)
    80002cf0:	2785                	addw	a5,a5,1
    80002cf2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	940080e7          	jalr	-1728(ra) # 80002634 <wakeup>
    release(&tickslock);
    80002cfc:	8526                	mv	a0,s1
    80002cfe:	ffffe097          	auipc	ra,0xffffe
    80002d02:	082080e7          	jalr	130(ra) # 80000d80 <release>
    80002d06:	bf4d                	j	80002cb8 <clockintr+0x14>

0000000080002d08 <devintr>:
/* returns 2 if timer interrupt, */
/* 1 if other device, */
/* 0 if not recognized. */
int
devintr()
{
    80002d08:	1101                	add	sp,sp,-32
    80002d0a:	ec06                	sd	ra,24(sp)
    80002d0c:	e822                	sd	s0,16(sp)
    80002d0e:	e426                	sd	s1,8(sp)
    80002d10:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d12:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002d16:	57fd                	li	a5,-1
    80002d18:	17fe                	sll	a5,a5,0x3f
    80002d1a:	07a5                	add	a5,a5,9
    80002d1c:	00f70d63          	beq	a4,a5,80002d36 <devintr+0x2e>
    /* now allowed to interrupt again. */
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002d20:	57fd                	li	a5,-1
    80002d22:	17fe                	sll	a5,a5,0x3f
    80002d24:	0795                	add	a5,a5,5
    /* timer interrupt. */
    clockintr();
    return 2;
  } else {
    return 0;
    80002d26:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002d28:	04f70e63          	beq	a4,a5,80002d84 <devintr+0x7c>
  }
}
    80002d2c:	60e2                	ld	ra,24(sp)
    80002d2e:	6442                	ld	s0,16(sp)
    80002d30:	64a2                	ld	s1,8(sp)
    80002d32:	6105                	add	sp,sp,32
    80002d34:	8082                	ret
    int irq = plic_claim();
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	3c6080e7          	jalr	966(ra) # 800060fc <plic_claim>
    80002d3e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002d40:	47a9                	li	a5,10
    80002d42:	02f50763          	beq	a0,a5,80002d70 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80002d46:	4785                	li	a5,1
    80002d48:	02f50963          	beq	a0,a5,80002d7a <devintr+0x72>
    return 1;
    80002d4c:	4505                	li	a0,1
    } else if(irq){
    80002d4e:	dcf9                	beqz	s1,80002d2c <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002d50:	85a6                	mv	a1,s1
    80002d52:	00005517          	auipc	a0,0x5
    80002d56:	5e650513          	add	a0,a0,1510 # 80008338 <states.0+0x38>
    80002d5a:	ffffd097          	auipc	ra,0xffffd
    80002d5e:	7a8080e7          	jalr	1960(ra) # 80000502 <printf>
      plic_complete(irq);
    80002d62:	8526                	mv	a0,s1
    80002d64:	00003097          	auipc	ra,0x3
    80002d68:	3bc080e7          	jalr	956(ra) # 80006120 <plic_complete>
    return 1;
    80002d6c:	4505                	li	a0,1
    80002d6e:	bf7d                	j	80002d2c <devintr+0x24>
      uartintr();
    80002d70:	ffffe097          	auipc	ra,0xffffe
    80002d74:	d1e080e7          	jalr	-738(ra) # 80000a8e <uartintr>
    if(irq)
    80002d78:	b7ed                	j	80002d62 <devintr+0x5a>
      virtio_disk_intr();
    80002d7a:	00004097          	auipc	ra,0x4
    80002d7e:	86c080e7          	jalr	-1940(ra) # 800065e6 <virtio_disk_intr>
    if(irq)
    80002d82:	b7c5                	j	80002d62 <devintr+0x5a>
    clockintr();
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	f20080e7          	jalr	-224(ra) # 80002ca4 <clockintr>
    return 2;
    80002d8c:	4509                	li	a0,2
    80002d8e:	bf79                	j	80002d2c <devintr+0x24>

0000000080002d90 <usertrap>:
{
    80002d90:	1101                	add	sp,sp,-32
    80002d92:	ec06                	sd	ra,24(sp)
    80002d94:	e822                	sd	s0,16(sp)
    80002d96:	e426                	sd	s1,8(sp)
    80002d98:	e04a                	sd	s2,0(sp)
    80002d9a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d9c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002da0:	1007f793          	and	a5,a5,256
    80002da4:	e3b1                	bnez	a5,80002de8 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002da6:	00003797          	auipc	a5,0x3
    80002daa:	2aa78793          	add	a5,a5,682 # 80006050 <kernelvec>
    80002dae:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	c98080e7          	jalr	-872(ra) # 80001a4a <myproc>
    80002dba:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002dbc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dbe:	14102773          	csrr	a4,sepc
    80002dc2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002dc4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002dc8:	47a1                	li	a5,8
    80002dca:	02f70763          	beq	a4,a5,80002df8 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	f3a080e7          	jalr	-198(ra) # 80002d08 <devintr>
    80002dd6:	892a                	mv	s2,a0
    80002dd8:	c151                	beqz	a0,80002e5c <usertrap+0xcc>
  if(killed(p))
    80002dda:	8526                	mv	a0,s1
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	acc080e7          	jalr	-1332(ra) # 800028a8 <killed>
    80002de4:	c929                	beqz	a0,80002e36 <usertrap+0xa6>
    80002de6:	a099                	j	80002e2c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002de8:	00005517          	auipc	a0,0x5
    80002dec:	57050513          	add	a0,a0,1392 # 80008358 <states.0+0x58>
    80002df0:	ffffe097          	auipc	ra,0xffffe
    80002df4:	a1e080e7          	jalr	-1506(ra) # 8000080e <panic>
    if(killed(p))
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	ab0080e7          	jalr	-1360(ra) # 800028a8 <killed>
    80002e00:	e921                	bnez	a0,80002e50 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002e02:	6cb8                	ld	a4,88(s1)
    80002e04:	6f1c                	ld	a5,24(a4)
    80002e06:	0791                	add	a5,a5,4
    80002e08:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e0a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e0e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e12:	10079073          	csrw	sstatus,a5
    syscall();
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	2b4080e7          	jalr	692(ra) # 800030ca <syscall>
  if(killed(p))
    80002e1e:	8526                	mv	a0,s1
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	a88080e7          	jalr	-1400(ra) # 800028a8 <killed>
    80002e28:	c911                	beqz	a0,80002e3c <usertrap+0xac>
    80002e2a:	4901                	li	s2,0
    exit(-1);
    80002e2c:	557d                	li	a0,-1
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	8f8080e7          	jalr	-1800(ra) # 80002726 <exit>
  if(which_dev == 2)
    80002e36:	4789                	li	a5,2
    80002e38:	04f90f63          	beq	s2,a5,80002e96 <usertrap+0x106>
  usertrapret();
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	dd2080e7          	jalr	-558(ra) # 80002c0e <usertrapret>
}
    80002e44:	60e2                	ld	ra,24(sp)
    80002e46:	6442                	ld	s0,16(sp)
    80002e48:	64a2                	ld	s1,8(sp)
    80002e4a:	6902                	ld	s2,0(sp)
    80002e4c:	6105                	add	sp,sp,32
    80002e4e:	8082                	ret
      exit(-1);
    80002e50:	557d                	li	a0,-1
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	8d4080e7          	jalr	-1836(ra) # 80002726 <exit>
    80002e5a:	b765                	j	80002e02 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e5c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002e60:	5890                	lw	a2,48(s1)
    80002e62:	00005517          	auipc	a0,0x5
    80002e66:	51650513          	add	a0,a0,1302 # 80008378 <states.0+0x78>
    80002e6a:	ffffd097          	auipc	ra,0xffffd
    80002e6e:	698080e7          	jalr	1688(ra) # 80000502 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e76:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002e7a:	00005517          	auipc	a0,0x5
    80002e7e:	52e50513          	add	a0,a0,1326 # 800083a8 <states.0+0xa8>
    80002e82:	ffffd097          	auipc	ra,0xffffd
    80002e86:	680080e7          	jalr	1664(ra) # 80000502 <printf>
    setkilled(p);
    80002e8a:	8526                	mv	a0,s1
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	9f0080e7          	jalr	-1552(ra) # 8000287c <setkilled>
    80002e94:	b769                	j	80002e1e <usertrap+0x8e>
    yield();
    80002e96:	fffff097          	auipc	ra,0xfffff
    80002e9a:	5a8080e7          	jalr	1448(ra) # 8000243e <yield>
    80002e9e:	bf79                	j	80002e3c <usertrap+0xac>

0000000080002ea0 <kerneltrap>:
{
    80002ea0:	7179                	add	sp,sp,-48
    80002ea2:	f406                	sd	ra,40(sp)
    80002ea4:	f022                	sd	s0,32(sp)
    80002ea6:	ec26                	sd	s1,24(sp)
    80002ea8:	e84a                	sd	s2,16(sp)
    80002eaa:	e44e                	sd	s3,8(sp)
    80002eac:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002eae:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002eb2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002eb6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002eba:	1004f793          	and	a5,s1,256
    80002ebe:	cb85                	beqz	a5,80002eee <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ec0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ec4:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002ec6:	ef85                	bnez	a5,80002efe <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002ec8:	00000097          	auipc	ra,0x0
    80002ecc:	e40080e7          	jalr	-448(ra) # 80002d08 <devintr>
    80002ed0:	cd1d                	beqz	a0,80002f0e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0)
    80002ed2:	4789                	li	a5,2
    80002ed4:	06f50263          	beq	a0,a5,80002f38 <kerneltrap+0x98>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ed8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002edc:	10049073          	csrw	sstatus,s1
}
    80002ee0:	70a2                	ld	ra,40(sp)
    80002ee2:	7402                	ld	s0,32(sp)
    80002ee4:	64e2                	ld	s1,24(sp)
    80002ee6:	6942                	ld	s2,16(sp)
    80002ee8:	69a2                	ld	s3,8(sp)
    80002eea:	6145                	add	sp,sp,48
    80002eec:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002eee:	00005517          	auipc	a0,0x5
    80002ef2:	4e250513          	add	a0,a0,1250 # 800083d0 <states.0+0xd0>
    80002ef6:	ffffe097          	auipc	ra,0xffffe
    80002efa:	918080e7          	jalr	-1768(ra) # 8000080e <panic>
    panic("kerneltrap: interrupts enabled");
    80002efe:	00005517          	auipc	a0,0x5
    80002f02:	4fa50513          	add	a0,a0,1274 # 800083f8 <states.0+0xf8>
    80002f06:	ffffe097          	auipc	ra,0xffffe
    80002f0a:	908080e7          	jalr	-1784(ra) # 8000080e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f0e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f12:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002f16:	85ce                	mv	a1,s3
    80002f18:	00005517          	auipc	a0,0x5
    80002f1c:	50050513          	add	a0,a0,1280 # 80008418 <states.0+0x118>
    80002f20:	ffffd097          	auipc	ra,0xffffd
    80002f24:	5e2080e7          	jalr	1506(ra) # 80000502 <printf>
    panic("kerneltrap");
    80002f28:	00005517          	auipc	a0,0x5
    80002f2c:	51850513          	add	a0,a0,1304 # 80008440 <states.0+0x140>
    80002f30:	ffffe097          	auipc	ra,0xffffe
    80002f34:	8de080e7          	jalr	-1826(ra) # 8000080e <panic>
  if(which_dev == 2 && myproc() != 0)
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	b12080e7          	jalr	-1262(ra) # 80001a4a <myproc>
    80002f40:	dd41                	beqz	a0,80002ed8 <kerneltrap+0x38>
    yield();
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	4fc080e7          	jalr	1276(ra) # 8000243e <yield>
    80002f4a:	b779                	j	80002ed8 <kerneltrap+0x38>

0000000080002f4c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002f4c:	1101                	add	sp,sp,-32
    80002f4e:	ec06                	sd	ra,24(sp)
    80002f50:	e822                	sd	s0,16(sp)
    80002f52:	e426                	sd	s1,8(sp)
    80002f54:	1000                	add	s0,sp,32
    80002f56:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	af2080e7          	jalr	-1294(ra) # 80001a4a <myproc>
  switch (n) {
    80002f60:	4795                	li	a5,5
    80002f62:	0497e163          	bltu	a5,s1,80002fa4 <argraw+0x58>
    80002f66:	048a                	sll	s1,s1,0x2
    80002f68:	00005717          	auipc	a4,0x5
    80002f6c:	51070713          	add	a4,a4,1296 # 80008478 <states.0+0x178>
    80002f70:	94ba                	add	s1,s1,a4
    80002f72:	409c                	lw	a5,0(s1)
    80002f74:	97ba                	add	a5,a5,a4
    80002f76:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002f78:	6d3c                	ld	a5,88(a0)
    80002f7a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002f7c:	60e2                	ld	ra,24(sp)
    80002f7e:	6442                	ld	s0,16(sp)
    80002f80:	64a2                	ld	s1,8(sp)
    80002f82:	6105                	add	sp,sp,32
    80002f84:	8082                	ret
    return p->trapframe->a1;
    80002f86:	6d3c                	ld	a5,88(a0)
    80002f88:	7fa8                	ld	a0,120(a5)
    80002f8a:	bfcd                	j	80002f7c <argraw+0x30>
    return p->trapframe->a2;
    80002f8c:	6d3c                	ld	a5,88(a0)
    80002f8e:	63c8                	ld	a0,128(a5)
    80002f90:	b7f5                	j	80002f7c <argraw+0x30>
    return p->trapframe->a3;
    80002f92:	6d3c                	ld	a5,88(a0)
    80002f94:	67c8                	ld	a0,136(a5)
    80002f96:	b7dd                	j	80002f7c <argraw+0x30>
    return p->trapframe->a4;
    80002f98:	6d3c                	ld	a5,88(a0)
    80002f9a:	6bc8                	ld	a0,144(a5)
    80002f9c:	b7c5                	j	80002f7c <argraw+0x30>
    return p->trapframe->a5;
    80002f9e:	6d3c                	ld	a5,88(a0)
    80002fa0:	6fc8                	ld	a0,152(a5)
    80002fa2:	bfe9                	j	80002f7c <argraw+0x30>
  panic("argraw");
    80002fa4:	00005517          	auipc	a0,0x5
    80002fa8:	4ac50513          	add	a0,a0,1196 # 80008450 <states.0+0x150>
    80002fac:	ffffe097          	auipc	ra,0xffffe
    80002fb0:	862080e7          	jalr	-1950(ra) # 8000080e <panic>

0000000080002fb4 <fetchaddr>:
{
    80002fb4:	1101                	add	sp,sp,-32
    80002fb6:	ec06                	sd	ra,24(sp)
    80002fb8:	e822                	sd	s0,16(sp)
    80002fba:	e426                	sd	s1,8(sp)
    80002fbc:	e04a                	sd	s2,0(sp)
    80002fbe:	1000                	add	s0,sp,32
    80002fc0:	84aa                	mv	s1,a0
    80002fc2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002fc4:	fffff097          	auipc	ra,0xfffff
    80002fc8:	a86080e7          	jalr	-1402(ra) # 80001a4a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80002fcc:	653c                	ld	a5,72(a0)
    80002fce:	02f4f863          	bgeu	s1,a5,80002ffe <fetchaddr+0x4a>
    80002fd2:	00848713          	add	a4,s1,8
    80002fd6:	02e7e663          	bltu	a5,a4,80003002 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002fda:	46a1                	li	a3,8
    80002fdc:	8626                	mv	a2,s1
    80002fde:	85ca                	mv	a1,s2
    80002fe0:	6928                	ld	a0,80(a0)
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	862080e7          	jalr	-1950(ra) # 80001844 <copyin>
    80002fea:	00a03533          	snez	a0,a0
    80002fee:	40a00533          	neg	a0,a0
}
    80002ff2:	60e2                	ld	ra,24(sp)
    80002ff4:	6442                	ld	s0,16(sp)
    80002ff6:	64a2                	ld	s1,8(sp)
    80002ff8:	6902                	ld	s2,0(sp)
    80002ffa:	6105                	add	sp,sp,32
    80002ffc:	8082                	ret
    return -1;
    80002ffe:	557d                	li	a0,-1
    80003000:	bfcd                	j	80002ff2 <fetchaddr+0x3e>
    80003002:	557d                	li	a0,-1
    80003004:	b7fd                	j	80002ff2 <fetchaddr+0x3e>

0000000080003006 <fetchstr>:
{
    80003006:	7179                	add	sp,sp,-48
    80003008:	f406                	sd	ra,40(sp)
    8000300a:	f022                	sd	s0,32(sp)
    8000300c:	ec26                	sd	s1,24(sp)
    8000300e:	e84a                	sd	s2,16(sp)
    80003010:	e44e                	sd	s3,8(sp)
    80003012:	1800                	add	s0,sp,48
    80003014:	892a                	mv	s2,a0
    80003016:	84ae                	mv	s1,a1
    80003018:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	a30080e7          	jalr	-1488(ra) # 80001a4a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003022:	86ce                	mv	a3,s3
    80003024:	864a                	mv	a2,s2
    80003026:	85a6                	mv	a1,s1
    80003028:	6928                	ld	a0,80(a0)
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	8a8080e7          	jalr	-1880(ra) # 800018d2 <copyinstr>
    80003032:	00054e63          	bltz	a0,8000304e <fetchstr+0x48>
  return strlen(buf);
    80003036:	8526                	mv	a0,s1
    80003038:	ffffe097          	auipc	ra,0xffffe
    8000303c:	f0a080e7          	jalr	-246(ra) # 80000f42 <strlen>
}
    80003040:	70a2                	ld	ra,40(sp)
    80003042:	7402                	ld	s0,32(sp)
    80003044:	64e2                	ld	s1,24(sp)
    80003046:	6942                	ld	s2,16(sp)
    80003048:	69a2                	ld	s3,8(sp)
    8000304a:	6145                	add	sp,sp,48
    8000304c:	8082                	ret
    return -1;
    8000304e:	557d                	li	a0,-1
    80003050:	bfc5                	j	80003040 <fetchstr+0x3a>

0000000080003052 <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    80003052:	1101                	add	sp,sp,-32
    80003054:	ec06                	sd	ra,24(sp)
    80003056:	e822                	sd	s0,16(sp)
    80003058:	e426                	sd	s1,8(sp)
    8000305a:	1000                	add	s0,sp,32
    8000305c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000305e:	00000097          	auipc	ra,0x0
    80003062:	eee080e7          	jalr	-274(ra) # 80002f4c <argraw>
    80003066:	c088                	sw	a0,0(s1)
}
    80003068:	60e2                	ld	ra,24(sp)
    8000306a:	6442                	ld	s0,16(sp)
    8000306c:	64a2                	ld	s1,8(sp)
    8000306e:	6105                	add	sp,sp,32
    80003070:	8082                	ret

0000000080003072 <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    80003072:	1101                	add	sp,sp,-32
    80003074:	ec06                	sd	ra,24(sp)
    80003076:	e822                	sd	s0,16(sp)
    80003078:	e426                	sd	s1,8(sp)
    8000307a:	1000                	add	s0,sp,32
    8000307c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000307e:	00000097          	auipc	ra,0x0
    80003082:	ece080e7          	jalr	-306(ra) # 80002f4c <argraw>
    80003086:	e088                	sd	a0,0(s1)
}
    80003088:	60e2                	ld	ra,24(sp)
    8000308a:	6442                	ld	s0,16(sp)
    8000308c:	64a2                	ld	s1,8(sp)
    8000308e:	6105                	add	sp,sp,32
    80003090:	8082                	ret

0000000080003092 <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80003092:	7179                	add	sp,sp,-48
    80003094:	f406                	sd	ra,40(sp)
    80003096:	f022                	sd	s0,32(sp)
    80003098:	ec26                	sd	s1,24(sp)
    8000309a:	e84a                	sd	s2,16(sp)
    8000309c:	1800                	add	s0,sp,48
    8000309e:	84ae                	mv	s1,a1
    800030a0:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800030a2:	fd840593          	add	a1,s0,-40
    800030a6:	00000097          	auipc	ra,0x0
    800030aa:	fcc080e7          	jalr	-52(ra) # 80003072 <argaddr>
  return fetchstr(addr, buf, max);
    800030ae:	864a                	mv	a2,s2
    800030b0:	85a6                	mv	a1,s1
    800030b2:	fd843503          	ld	a0,-40(s0)
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	f50080e7          	jalr	-176(ra) # 80003006 <fetchstr>
}
    800030be:	70a2                	ld	ra,40(sp)
    800030c0:	7402                	ld	s0,32(sp)
    800030c2:	64e2                	ld	s1,24(sp)
    800030c4:	6942                	ld	s2,16(sp)
    800030c6:	6145                	add	sp,sp,48
    800030c8:	8082                	ret

00000000800030ca <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800030ca:	1101                	add	sp,sp,-32
    800030cc:	ec06                	sd	ra,24(sp)
    800030ce:	e822                	sd	s0,16(sp)
    800030d0:	e426                	sd	s1,8(sp)
    800030d2:	e04a                	sd	s2,0(sp)
    800030d4:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	974080e7          	jalr	-1676(ra) # 80001a4a <myproc>
    800030de:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800030e0:	05853903          	ld	s2,88(a0)
    800030e4:	0a893783          	ld	a5,168(s2)
    800030e8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800030ec:	37fd                	addw	a5,a5,-1
    800030ee:	4751                	li	a4,20
    800030f0:	00f76f63          	bltu	a4,a5,8000310e <syscall+0x44>
    800030f4:	00369713          	sll	a4,a3,0x3
    800030f8:	00005797          	auipc	a5,0x5
    800030fc:	39878793          	add	a5,a5,920 # 80008490 <syscalls>
    80003100:	97ba                	add	a5,a5,a4
    80003102:	639c                	ld	a5,0(a5)
    80003104:	c789                	beqz	a5,8000310e <syscall+0x44>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    80003106:	9782                	jalr	a5
    80003108:	06a93823          	sd	a0,112(s2)
    8000310c:	a839                	j	8000312a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000310e:	15848613          	add	a2,s1,344
    80003112:	588c                	lw	a1,48(s1)
    80003114:	00005517          	auipc	a0,0x5
    80003118:	34450513          	add	a0,a0,836 # 80008458 <states.0+0x158>
    8000311c:	ffffd097          	auipc	ra,0xffffd
    80003120:	3e6080e7          	jalr	998(ra) # 80000502 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003124:	6cbc                	ld	a5,88(s1)
    80003126:	577d                	li	a4,-1
    80003128:	fbb8                	sd	a4,112(a5)
  }
}
    8000312a:	60e2                	ld	ra,24(sp)
    8000312c:	6442                	ld	s0,16(sp)
    8000312e:	64a2                	ld	s1,8(sp)
    80003130:	6902                	ld	s2,0(sp)
    80003132:	6105                	add	sp,sp,32
    80003134:	8082                	ret

0000000080003136 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003136:	1101                	add	sp,sp,-32
    80003138:	ec06                	sd	ra,24(sp)
    8000313a:	e822                	sd	s0,16(sp)
    8000313c:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    8000313e:	fec40593          	add	a1,s0,-20
    80003142:	4501                	li	a0,0
    80003144:	00000097          	auipc	ra,0x0
    80003148:	f0e080e7          	jalr	-242(ra) # 80003052 <argint>
  exit(n);
    8000314c:	fec42503          	lw	a0,-20(s0)
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	5d6080e7          	jalr	1494(ra) # 80002726 <exit>
  return 0;  /* not reached */
}
    80003158:	4501                	li	a0,0
    8000315a:	60e2                	ld	ra,24(sp)
    8000315c:	6442                	ld	s0,16(sp)
    8000315e:	6105                	add	sp,sp,32
    80003160:	8082                	ret

0000000080003162 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003162:	1141                	add	sp,sp,-16
    80003164:	e406                	sd	ra,8(sp)
    80003166:	e022                	sd	s0,0(sp)
    80003168:	0800                	add	s0,sp,16
  return myproc()->pid;
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	8e0080e7          	jalr	-1824(ra) # 80001a4a <myproc>
}
    80003172:	5908                	lw	a0,48(a0)
    80003174:	60a2                	ld	ra,8(sp)
    80003176:	6402                	ld	s0,0(sp)
    80003178:	0141                	add	sp,sp,16
    8000317a:	8082                	ret

000000008000317c <sys_fork>:

uint64
sys_fork(void)
{
    8000317c:	1141                	add	sp,sp,-16
    8000317e:	e406                	sd	ra,8(sp)
    80003180:	e022                	sd	s0,0(sp)
    80003182:	0800                	add	s0,sp,16
  return fork();
    80003184:	fffff097          	auipc	ra,0xfffff
    80003188:	06a080e7          	jalr	106(ra) # 800021ee <fork>
}
    8000318c:	60a2                	ld	ra,8(sp)
    8000318e:	6402                	ld	s0,0(sp)
    80003190:	0141                	add	sp,sp,16
    80003192:	8082                	ret

0000000080003194 <sys_wait>:

uint64
sys_wait(void)
{
    80003194:	1101                	add	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000319c:	fe840593          	add	a1,s0,-24
    800031a0:	4501                	li	a0,0
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	ed0080e7          	jalr	-304(ra) # 80003072 <argaddr>
  return wait(p);
    800031aa:	fe843503          	ld	a0,-24(s0)
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	72c080e7          	jalr	1836(ra) # 800028da <wait>
}
    800031b6:	60e2                	ld	ra,24(sp)
    800031b8:	6442                	ld	s0,16(sp)
    800031ba:	6105                	add	sp,sp,32
    800031bc:	8082                	ret

00000000800031be <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800031be:	7179                	add	sp,sp,-48
    800031c0:	f406                	sd	ra,40(sp)
    800031c2:	f022                	sd	s0,32(sp)
    800031c4:	ec26                	sd	s1,24(sp)
    800031c6:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800031c8:	fdc40593          	add	a1,s0,-36
    800031cc:	4501                	li	a0,0
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	e84080e7          	jalr	-380(ra) # 80003052 <argint>
  addr = myproc()->sz;
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	874080e7          	jalr	-1932(ra) # 80001a4a <myproc>
    800031de:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800031e0:	fdc42503          	lw	a0,-36(s0)
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	fae080e7          	jalr	-82(ra) # 80002192 <growproc>
    800031ec:	00054863          	bltz	a0,800031fc <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800031f0:	8526                	mv	a0,s1
    800031f2:	70a2                	ld	ra,40(sp)
    800031f4:	7402                	ld	s0,32(sp)
    800031f6:	64e2                	ld	s1,24(sp)
    800031f8:	6145                	add	sp,sp,48
    800031fa:	8082                	ret
    return -1;
    800031fc:	54fd                	li	s1,-1
    800031fe:	bfcd                	j	800031f0 <sys_sbrk+0x32>

0000000080003200 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003200:	7139                	add	sp,sp,-64
    80003202:	fc06                	sd	ra,56(sp)
    80003204:	f822                	sd	s0,48(sp)
    80003206:	f426                	sd	s1,40(sp)
    80003208:	f04a                	sd	s2,32(sp)
    8000320a:	ec4e                	sd	s3,24(sp)
    8000320c:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000320e:	fcc40593          	add	a1,s0,-52
    80003212:	4501                	li	a0,0
    80003214:	00000097          	auipc	ra,0x0
    80003218:	e3e080e7          	jalr	-450(ra) # 80003052 <argint>
  if(n < 0)
    8000321c:	fcc42783          	lw	a5,-52(s0)
    80003220:	0607cf63          	bltz	a5,8000329e <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80003224:	00014517          	auipc	a0,0x14
    80003228:	cac50513          	add	a0,a0,-852 # 80016ed0 <tickslock>
    8000322c:	ffffe097          	auipc	ra,0xffffe
    80003230:	aa0080e7          	jalr	-1376(ra) # 80000ccc <acquire>
  ticks0 = ticks;
    80003234:	00005917          	auipc	s2,0x5
    80003238:	6d492903          	lw	s2,1748(s2) # 80008908 <ticks>
  while(ticks - ticks0 < n){
    8000323c:	fcc42783          	lw	a5,-52(s0)
    80003240:	cf9d                	beqz	a5,8000327e <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003242:	00014997          	auipc	s3,0x14
    80003246:	c8e98993          	add	s3,s3,-882 # 80016ed0 <tickslock>
    8000324a:	00005497          	auipc	s1,0x5
    8000324e:	6be48493          	add	s1,s1,1726 # 80008908 <ticks>
    if(killed(myproc())){
    80003252:	ffffe097          	auipc	ra,0xffffe
    80003256:	7f8080e7          	jalr	2040(ra) # 80001a4a <myproc>
    8000325a:	fffff097          	auipc	ra,0xfffff
    8000325e:	64e080e7          	jalr	1614(ra) # 800028a8 <killed>
    80003262:	e129                	bnez	a0,800032a4 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80003264:	85ce                	mv	a1,s3
    80003266:	8526                	mv	a0,s1
    80003268:	fffff097          	auipc	ra,0xfffff
    8000326c:	368080e7          	jalr	872(ra) # 800025d0 <sleep>
  while(ticks - ticks0 < n){
    80003270:	409c                	lw	a5,0(s1)
    80003272:	412787bb          	subw	a5,a5,s2
    80003276:	fcc42703          	lw	a4,-52(s0)
    8000327a:	fce7ece3          	bltu	a5,a4,80003252 <sys_sleep+0x52>
  }
  release(&tickslock);
    8000327e:	00014517          	auipc	a0,0x14
    80003282:	c5250513          	add	a0,a0,-942 # 80016ed0 <tickslock>
    80003286:	ffffe097          	auipc	ra,0xffffe
    8000328a:	afa080e7          	jalr	-1286(ra) # 80000d80 <release>
  return 0;
    8000328e:	4501                	li	a0,0
}
    80003290:	70e2                	ld	ra,56(sp)
    80003292:	7442                	ld	s0,48(sp)
    80003294:	74a2                	ld	s1,40(sp)
    80003296:	7902                	ld	s2,32(sp)
    80003298:	69e2                	ld	s3,24(sp)
    8000329a:	6121                	add	sp,sp,64
    8000329c:	8082                	ret
    n = 0;
    8000329e:	fc042623          	sw	zero,-52(s0)
    800032a2:	b749                	j	80003224 <sys_sleep+0x24>
      release(&tickslock);
    800032a4:	00014517          	auipc	a0,0x14
    800032a8:	c2c50513          	add	a0,a0,-980 # 80016ed0 <tickslock>
    800032ac:	ffffe097          	auipc	ra,0xffffe
    800032b0:	ad4080e7          	jalr	-1324(ra) # 80000d80 <release>
      return -1;
    800032b4:	557d                	li	a0,-1
    800032b6:	bfe9                	j	80003290 <sys_sleep+0x90>

00000000800032b8 <sys_kill>:

uint64
sys_kill(void)
{
    800032b8:	1101                	add	sp,sp,-32
    800032ba:	ec06                	sd	ra,24(sp)
    800032bc:	e822                	sd	s0,16(sp)
    800032be:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    800032c0:	fec40593          	add	a1,s0,-20
    800032c4:	4501                	li	a0,0
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	d8c080e7          	jalr	-628(ra) # 80003052 <argint>
  return kill(pid);
    800032ce:	fec42503          	lw	a0,-20(s0)
    800032d2:	fffff097          	auipc	ra,0xfffff
    800032d6:	52a080e7          	jalr	1322(ra) # 800027fc <kill>
}
    800032da:	60e2                	ld	ra,24(sp)
    800032dc:	6442                	ld	s0,16(sp)
    800032de:	6105                	add	sp,sp,32
    800032e0:	8082                	ret

00000000800032e2 <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    800032e2:	1101                	add	sp,sp,-32
    800032e4:	ec06                	sd	ra,24(sp)
    800032e6:	e822                	sd	s0,16(sp)
    800032e8:	e426                	sd	s1,8(sp)
    800032ea:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800032ec:	00014517          	auipc	a0,0x14
    800032f0:	be450513          	add	a0,a0,-1052 # 80016ed0 <tickslock>
    800032f4:	ffffe097          	auipc	ra,0xffffe
    800032f8:	9d8080e7          	jalr	-1576(ra) # 80000ccc <acquire>
  xticks = ticks;
    800032fc:	00005497          	auipc	s1,0x5
    80003300:	60c4a483          	lw	s1,1548(s1) # 80008908 <ticks>
  release(&tickslock);
    80003304:	00014517          	auipc	a0,0x14
    80003308:	bcc50513          	add	a0,a0,-1076 # 80016ed0 <tickslock>
    8000330c:	ffffe097          	auipc	ra,0xffffe
    80003310:	a74080e7          	jalr	-1420(ra) # 80000d80 <release>
  return xticks;
}
    80003314:	02049513          	sll	a0,s1,0x20
    80003318:	9101                	srl	a0,a0,0x20
    8000331a:	60e2                	ld	ra,24(sp)
    8000331c:	6442                	ld	s0,16(sp)
    8000331e:	64a2                	ld	s1,8(sp)
    80003320:	6105                	add	sp,sp,32
    80003322:	8082                	ret

0000000080003324 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003324:	7179                	add	sp,sp,-48
    80003326:	f406                	sd	ra,40(sp)
    80003328:	f022                	sd	s0,32(sp)
    8000332a:	ec26                	sd	s1,24(sp)
    8000332c:	e84a                	sd	s2,16(sp)
    8000332e:	e44e                	sd	s3,8(sp)
    80003330:	e052                	sd	s4,0(sp)
    80003332:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003334:	00005597          	auipc	a1,0x5
    80003338:	20c58593          	add	a1,a1,524 # 80008540 <syscalls+0xb0>
    8000333c:	00014517          	auipc	a0,0x14
    80003340:	bac50513          	add	a0,a0,-1108 # 80016ee8 <bcache>
    80003344:	ffffe097          	auipc	ra,0xffffe
    80003348:	8f8080e7          	jalr	-1800(ra) # 80000c3c <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    8000334c:	0001c797          	auipc	a5,0x1c
    80003350:	b9c78793          	add	a5,a5,-1124 # 8001eee8 <bcache+0x8000>
    80003354:	0001c717          	auipc	a4,0x1c
    80003358:	dfc70713          	add	a4,a4,-516 # 8001f150 <bcache+0x8268>
    8000335c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003360:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003364:	00014497          	auipc	s1,0x14
    80003368:	b9c48493          	add	s1,s1,-1124 # 80016f00 <bcache+0x18>
    b->next = bcache.head.next;
    8000336c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000336e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003370:	00005a17          	auipc	s4,0x5
    80003374:	1d8a0a13          	add	s4,s4,472 # 80008548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80003378:	2b893783          	ld	a5,696(s2)
    8000337c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000337e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003382:	85d2                	mv	a1,s4
    80003384:	01048513          	add	a0,s1,16
    80003388:	00001097          	auipc	ra,0x1
    8000338c:	496080e7          	jalr	1174(ra) # 8000481e <initsleeplock>
    bcache.head.next->prev = b;
    80003390:	2b893783          	ld	a5,696(s2)
    80003394:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003396:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000339a:	45848493          	add	s1,s1,1112
    8000339e:	fd349de3          	bne	s1,s3,80003378 <binit+0x54>
  }
}
    800033a2:	70a2                	ld	ra,40(sp)
    800033a4:	7402                	ld	s0,32(sp)
    800033a6:	64e2                	ld	s1,24(sp)
    800033a8:	6942                	ld	s2,16(sp)
    800033aa:	69a2                	ld	s3,8(sp)
    800033ac:	6a02                	ld	s4,0(sp)
    800033ae:	6145                	add	sp,sp,48
    800033b0:	8082                	ret

00000000800033b2 <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    800033b2:	7179                	add	sp,sp,-48
    800033b4:	f406                	sd	ra,40(sp)
    800033b6:	f022                	sd	s0,32(sp)
    800033b8:	ec26                	sd	s1,24(sp)
    800033ba:	e84a                	sd	s2,16(sp)
    800033bc:	e44e                	sd	s3,8(sp)
    800033be:	1800                	add	s0,sp,48
    800033c0:	892a                	mv	s2,a0
    800033c2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800033c4:	00014517          	auipc	a0,0x14
    800033c8:	b2450513          	add	a0,a0,-1244 # 80016ee8 <bcache>
    800033cc:	ffffe097          	auipc	ra,0xffffe
    800033d0:	900080e7          	jalr	-1792(ra) # 80000ccc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800033d4:	0001c497          	auipc	s1,0x1c
    800033d8:	dcc4b483          	ld	s1,-564(s1) # 8001f1a0 <bcache+0x82b8>
    800033dc:	0001c797          	auipc	a5,0x1c
    800033e0:	d7478793          	add	a5,a5,-652 # 8001f150 <bcache+0x8268>
    800033e4:	02f48f63          	beq	s1,a5,80003422 <bread+0x70>
    800033e8:	873e                	mv	a4,a5
    800033ea:	a021                	j	800033f2 <bread+0x40>
    800033ec:	68a4                	ld	s1,80(s1)
    800033ee:	02e48a63          	beq	s1,a4,80003422 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800033f2:	449c                	lw	a5,8(s1)
    800033f4:	ff279ce3          	bne	a5,s2,800033ec <bread+0x3a>
    800033f8:	44dc                	lw	a5,12(s1)
    800033fa:	ff3799e3          	bne	a5,s3,800033ec <bread+0x3a>
      b->refcnt++;
    800033fe:	40bc                	lw	a5,64(s1)
    80003400:	2785                	addw	a5,a5,1
    80003402:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003404:	00014517          	auipc	a0,0x14
    80003408:	ae450513          	add	a0,a0,-1308 # 80016ee8 <bcache>
    8000340c:	ffffe097          	auipc	ra,0xffffe
    80003410:	974080e7          	jalr	-1676(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    80003414:	01048513          	add	a0,s1,16
    80003418:	00001097          	auipc	ra,0x1
    8000341c:	440080e7          	jalr	1088(ra) # 80004858 <acquiresleep>
      return b;
    80003420:	a8b9                	j	8000347e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003422:	0001c497          	auipc	s1,0x1c
    80003426:	d764b483          	ld	s1,-650(s1) # 8001f198 <bcache+0x82b0>
    8000342a:	0001c797          	auipc	a5,0x1c
    8000342e:	d2678793          	add	a5,a5,-730 # 8001f150 <bcache+0x8268>
    80003432:	00f48863          	beq	s1,a5,80003442 <bread+0x90>
    80003436:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003438:	40bc                	lw	a5,64(s1)
    8000343a:	cf81                	beqz	a5,80003452 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000343c:	64a4                	ld	s1,72(s1)
    8000343e:	fee49de3          	bne	s1,a4,80003438 <bread+0x86>
  panic("bget: no buffers");
    80003442:	00005517          	auipc	a0,0x5
    80003446:	10e50513          	add	a0,a0,270 # 80008550 <syscalls+0xc0>
    8000344a:	ffffd097          	auipc	ra,0xffffd
    8000344e:	3c4080e7          	jalr	964(ra) # 8000080e <panic>
      b->dev = dev;
    80003452:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003456:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000345a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000345e:	4785                	li	a5,1
    80003460:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003462:	00014517          	auipc	a0,0x14
    80003466:	a8650513          	add	a0,a0,-1402 # 80016ee8 <bcache>
    8000346a:	ffffe097          	auipc	ra,0xffffe
    8000346e:	916080e7          	jalr	-1770(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    80003472:	01048513          	add	a0,s1,16
    80003476:	00001097          	auipc	ra,0x1
    8000347a:	3e2080e7          	jalr	994(ra) # 80004858 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000347e:	409c                	lw	a5,0(s1)
    80003480:	cb89                	beqz	a5,80003492 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003482:	8526                	mv	a0,s1
    80003484:	70a2                	ld	ra,40(sp)
    80003486:	7402                	ld	s0,32(sp)
    80003488:	64e2                	ld	s1,24(sp)
    8000348a:	6942                	ld	s2,16(sp)
    8000348c:	69a2                	ld	s3,8(sp)
    8000348e:	6145                	add	sp,sp,48
    80003490:	8082                	ret
    virtio_disk_rw(b, 0);
    80003492:	4581                	li	a1,0
    80003494:	8526                	mv	a0,s1
    80003496:	00003097          	auipc	ra,0x3
    8000349a:	f20080e7          	jalr	-224(ra) # 800063b6 <virtio_disk_rw>
    b->valid = 1;
    8000349e:	4785                	li	a5,1
    800034a0:	c09c                	sw	a5,0(s1)
  return b;
    800034a2:	b7c5                	j	80003482 <bread+0xd0>

00000000800034a4 <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    800034a4:	1101                	add	sp,sp,-32
    800034a6:	ec06                	sd	ra,24(sp)
    800034a8:	e822                	sd	s0,16(sp)
    800034aa:	e426                	sd	s1,8(sp)
    800034ac:	1000                	add	s0,sp,32
    800034ae:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034b0:	0541                	add	a0,a0,16
    800034b2:	00001097          	auipc	ra,0x1
    800034b6:	440080e7          	jalr	1088(ra) # 800048f2 <holdingsleep>
    800034ba:	cd01                	beqz	a0,800034d2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034bc:	4585                	li	a1,1
    800034be:	8526                	mv	a0,s1
    800034c0:	00003097          	auipc	ra,0x3
    800034c4:	ef6080e7          	jalr	-266(ra) # 800063b6 <virtio_disk_rw>
}
    800034c8:	60e2                	ld	ra,24(sp)
    800034ca:	6442                	ld	s0,16(sp)
    800034cc:	64a2                	ld	s1,8(sp)
    800034ce:	6105                	add	sp,sp,32
    800034d0:	8082                	ret
    panic("bwrite");
    800034d2:	00005517          	auipc	a0,0x5
    800034d6:	09650513          	add	a0,a0,150 # 80008568 <syscalls+0xd8>
    800034da:	ffffd097          	auipc	ra,0xffffd
    800034de:	334080e7          	jalr	820(ra) # 8000080e <panic>

00000000800034e2 <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    800034e2:	1101                	add	sp,sp,-32
    800034e4:	ec06                	sd	ra,24(sp)
    800034e6:	e822                	sd	s0,16(sp)
    800034e8:	e426                	sd	s1,8(sp)
    800034ea:	e04a                	sd	s2,0(sp)
    800034ec:	1000                	add	s0,sp,32
    800034ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034f0:	01050913          	add	s2,a0,16
    800034f4:	854a                	mv	a0,s2
    800034f6:	00001097          	auipc	ra,0x1
    800034fa:	3fc080e7          	jalr	1020(ra) # 800048f2 <holdingsleep>
    800034fe:	c925                	beqz	a0,8000356e <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003500:	854a                	mv	a0,s2
    80003502:	00001097          	auipc	ra,0x1
    80003506:	3ac080e7          	jalr	940(ra) # 800048ae <releasesleep>

  acquire(&bcache.lock);
    8000350a:	00014517          	auipc	a0,0x14
    8000350e:	9de50513          	add	a0,a0,-1570 # 80016ee8 <bcache>
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	7ba080e7          	jalr	1978(ra) # 80000ccc <acquire>
  b->refcnt--;
    8000351a:	40bc                	lw	a5,64(s1)
    8000351c:	37fd                	addw	a5,a5,-1
    8000351e:	0007871b          	sext.w	a4,a5
    80003522:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003524:	e71d                	bnez	a4,80003552 <brelse+0x70>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    80003526:	68b8                	ld	a4,80(s1)
    80003528:	64bc                	ld	a5,72(s1)
    8000352a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000352c:	68b8                	ld	a4,80(s1)
    8000352e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003530:	0001c797          	auipc	a5,0x1c
    80003534:	9b878793          	add	a5,a5,-1608 # 8001eee8 <bcache+0x8000>
    80003538:	2b87b703          	ld	a4,696(a5)
    8000353c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000353e:	0001c717          	auipc	a4,0x1c
    80003542:	c1270713          	add	a4,a4,-1006 # 8001f150 <bcache+0x8268>
    80003546:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003548:	2b87b703          	ld	a4,696(a5)
    8000354c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000354e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003552:	00014517          	auipc	a0,0x14
    80003556:	99650513          	add	a0,a0,-1642 # 80016ee8 <bcache>
    8000355a:	ffffe097          	auipc	ra,0xffffe
    8000355e:	826080e7          	jalr	-2010(ra) # 80000d80 <release>
}
    80003562:	60e2                	ld	ra,24(sp)
    80003564:	6442                	ld	s0,16(sp)
    80003566:	64a2                	ld	s1,8(sp)
    80003568:	6902                	ld	s2,0(sp)
    8000356a:	6105                	add	sp,sp,32
    8000356c:	8082                	ret
    panic("brelse");
    8000356e:	00005517          	auipc	a0,0x5
    80003572:	00250513          	add	a0,a0,2 # 80008570 <syscalls+0xe0>
    80003576:	ffffd097          	auipc	ra,0xffffd
    8000357a:	298080e7          	jalr	664(ra) # 8000080e <panic>

000000008000357e <bpin>:

void
bpin(struct buf *b) {
    8000357e:	1101                	add	sp,sp,-32
    80003580:	ec06                	sd	ra,24(sp)
    80003582:	e822                	sd	s0,16(sp)
    80003584:	e426                	sd	s1,8(sp)
    80003586:	1000                	add	s0,sp,32
    80003588:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000358a:	00014517          	auipc	a0,0x14
    8000358e:	95e50513          	add	a0,a0,-1698 # 80016ee8 <bcache>
    80003592:	ffffd097          	auipc	ra,0xffffd
    80003596:	73a080e7          	jalr	1850(ra) # 80000ccc <acquire>
  b->refcnt++;
    8000359a:	40bc                	lw	a5,64(s1)
    8000359c:	2785                	addw	a5,a5,1
    8000359e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035a0:	00014517          	auipc	a0,0x14
    800035a4:	94850513          	add	a0,a0,-1720 # 80016ee8 <bcache>
    800035a8:	ffffd097          	auipc	ra,0xffffd
    800035ac:	7d8080e7          	jalr	2008(ra) # 80000d80 <release>
}
    800035b0:	60e2                	ld	ra,24(sp)
    800035b2:	6442                	ld	s0,16(sp)
    800035b4:	64a2                	ld	s1,8(sp)
    800035b6:	6105                	add	sp,sp,32
    800035b8:	8082                	ret

00000000800035ba <bunpin>:

void
bunpin(struct buf *b) {
    800035ba:	1101                	add	sp,sp,-32
    800035bc:	ec06                	sd	ra,24(sp)
    800035be:	e822                	sd	s0,16(sp)
    800035c0:	e426                	sd	s1,8(sp)
    800035c2:	1000                	add	s0,sp,32
    800035c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035c6:	00014517          	auipc	a0,0x14
    800035ca:	92250513          	add	a0,a0,-1758 # 80016ee8 <bcache>
    800035ce:	ffffd097          	auipc	ra,0xffffd
    800035d2:	6fe080e7          	jalr	1790(ra) # 80000ccc <acquire>
  b->refcnt--;
    800035d6:	40bc                	lw	a5,64(s1)
    800035d8:	37fd                	addw	a5,a5,-1
    800035da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035dc:	00014517          	auipc	a0,0x14
    800035e0:	90c50513          	add	a0,a0,-1780 # 80016ee8 <bcache>
    800035e4:	ffffd097          	auipc	ra,0xffffd
    800035e8:	79c080e7          	jalr	1948(ra) # 80000d80 <release>
}
    800035ec:	60e2                	ld	ra,24(sp)
    800035ee:	6442                	ld	s0,16(sp)
    800035f0:	64a2                	ld	s1,8(sp)
    800035f2:	6105                	add	sp,sp,32
    800035f4:	8082                	ret

00000000800035f6 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    800035f6:	1101                	add	sp,sp,-32
    800035f8:	ec06                	sd	ra,24(sp)
    800035fa:	e822                	sd	s0,16(sp)
    800035fc:	e426                	sd	s1,8(sp)
    800035fe:	e04a                	sd	s2,0(sp)
    80003600:	1000                	add	s0,sp,32
    80003602:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003604:	00d5d59b          	srlw	a1,a1,0xd
    80003608:	0001c797          	auipc	a5,0x1c
    8000360c:	fbc7a783          	lw	a5,-68(a5) # 8001f5c4 <sb+0x1c>
    80003610:	9dbd                	addw	a1,a1,a5
    80003612:	00000097          	auipc	ra,0x0
    80003616:	da0080e7          	jalr	-608(ra) # 800033b2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000361a:	0074f713          	and	a4,s1,7
    8000361e:	4785                	li	a5,1
    80003620:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003624:	14ce                	sll	s1,s1,0x33
    80003626:	90d9                	srl	s1,s1,0x36
    80003628:	00950733          	add	a4,a0,s1
    8000362c:	05874703          	lbu	a4,88(a4)
    80003630:	00e7f6b3          	and	a3,a5,a4
    80003634:	c69d                	beqz	a3,80003662 <bfree+0x6c>
    80003636:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003638:	94aa                	add	s1,s1,a0
    8000363a:	fff7c793          	not	a5,a5
    8000363e:	8f7d                	and	a4,a4,a5
    80003640:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003644:	00001097          	auipc	ra,0x1
    80003648:	0f6080e7          	jalr	246(ra) # 8000473a <log_write>
  brelse(bp);
    8000364c:	854a                	mv	a0,s2
    8000364e:	00000097          	auipc	ra,0x0
    80003652:	e94080e7          	jalr	-364(ra) # 800034e2 <brelse>
}
    80003656:	60e2                	ld	ra,24(sp)
    80003658:	6442                	ld	s0,16(sp)
    8000365a:	64a2                	ld	s1,8(sp)
    8000365c:	6902                	ld	s2,0(sp)
    8000365e:	6105                	add	sp,sp,32
    80003660:	8082                	ret
    panic("freeing free block");
    80003662:	00005517          	auipc	a0,0x5
    80003666:	f1650513          	add	a0,a0,-234 # 80008578 <syscalls+0xe8>
    8000366a:	ffffd097          	auipc	ra,0xffffd
    8000366e:	1a4080e7          	jalr	420(ra) # 8000080e <panic>

0000000080003672 <balloc>:
{
    80003672:	711d                	add	sp,sp,-96
    80003674:	ec86                	sd	ra,88(sp)
    80003676:	e8a2                	sd	s0,80(sp)
    80003678:	e4a6                	sd	s1,72(sp)
    8000367a:	e0ca                	sd	s2,64(sp)
    8000367c:	fc4e                	sd	s3,56(sp)
    8000367e:	f852                	sd	s4,48(sp)
    80003680:	f456                	sd	s5,40(sp)
    80003682:	f05a                	sd	s6,32(sp)
    80003684:	ec5e                	sd	s7,24(sp)
    80003686:	e862                	sd	s8,16(sp)
    80003688:	e466                	sd	s9,8(sp)
    8000368a:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000368c:	0001c797          	auipc	a5,0x1c
    80003690:	f207a783          	lw	a5,-224(a5) # 8001f5ac <sb+0x4>
    80003694:	cff5                	beqz	a5,80003790 <balloc+0x11e>
    80003696:	8baa                	mv	s7,a0
    80003698:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000369a:	0001cb17          	auipc	s6,0x1c
    8000369e:	f0eb0b13          	add	s6,s6,-242 # 8001f5a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036a2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800036a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800036a8:	6c89                	lui	s9,0x2
    800036aa:	a061                	j	80003732 <balloc+0xc0>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    800036ac:	97ca                	add	a5,a5,s2
    800036ae:	8e55                	or	a2,a2,a3
    800036b0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800036b4:	854a                	mv	a0,s2
    800036b6:	00001097          	auipc	ra,0x1
    800036ba:	084080e7          	jalr	132(ra) # 8000473a <log_write>
        brelse(bp);
    800036be:	854a                	mv	a0,s2
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	e22080e7          	jalr	-478(ra) # 800034e2 <brelse>
  bp = bread(dev, bno);
    800036c8:	85a6                	mv	a1,s1
    800036ca:	855e                	mv	a0,s7
    800036cc:	00000097          	auipc	ra,0x0
    800036d0:	ce6080e7          	jalr	-794(ra) # 800033b2 <bread>
    800036d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800036d6:	40000613          	li	a2,1024
    800036da:	4581                	li	a1,0
    800036dc:	05850513          	add	a0,a0,88
    800036e0:	ffffd097          	auipc	ra,0xffffd
    800036e4:	6e8080e7          	jalr	1768(ra) # 80000dc8 <memset>
  log_write(bp);
    800036e8:	854a                	mv	a0,s2
    800036ea:	00001097          	auipc	ra,0x1
    800036ee:	050080e7          	jalr	80(ra) # 8000473a <log_write>
  brelse(bp);
    800036f2:	854a                	mv	a0,s2
    800036f4:	00000097          	auipc	ra,0x0
    800036f8:	dee080e7          	jalr	-530(ra) # 800034e2 <brelse>
}
    800036fc:	8526                	mv	a0,s1
    800036fe:	60e6                	ld	ra,88(sp)
    80003700:	6446                	ld	s0,80(sp)
    80003702:	64a6                	ld	s1,72(sp)
    80003704:	6906                	ld	s2,64(sp)
    80003706:	79e2                	ld	s3,56(sp)
    80003708:	7a42                	ld	s4,48(sp)
    8000370a:	7aa2                	ld	s5,40(sp)
    8000370c:	7b02                	ld	s6,32(sp)
    8000370e:	6be2                	ld	s7,24(sp)
    80003710:	6c42                	ld	s8,16(sp)
    80003712:	6ca2                	ld	s9,8(sp)
    80003714:	6125                	add	sp,sp,96
    80003716:	8082                	ret
    brelse(bp);
    80003718:	854a                	mv	a0,s2
    8000371a:	00000097          	auipc	ra,0x0
    8000371e:	dc8080e7          	jalr	-568(ra) # 800034e2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003722:	015c87bb          	addw	a5,s9,s5
    80003726:	00078a9b          	sext.w	s5,a5
    8000372a:	004b2703          	lw	a4,4(s6)
    8000372e:	06eaf163          	bgeu	s5,a4,80003790 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003732:	41fad79b          	sraw	a5,s5,0x1f
    80003736:	0137d79b          	srlw	a5,a5,0x13
    8000373a:	015787bb          	addw	a5,a5,s5
    8000373e:	40d7d79b          	sraw	a5,a5,0xd
    80003742:	01cb2583          	lw	a1,28(s6)
    80003746:	9dbd                	addw	a1,a1,a5
    80003748:	855e                	mv	a0,s7
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	c68080e7          	jalr	-920(ra) # 800033b2 <bread>
    80003752:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003754:	004b2503          	lw	a0,4(s6)
    80003758:	000a849b          	sext.w	s1,s5
    8000375c:	8762                	mv	a4,s8
    8000375e:	faa4fde3          	bgeu	s1,a0,80003718 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003762:	00777693          	and	a3,a4,7
    80003766:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    8000376a:	41f7579b          	sraw	a5,a4,0x1f
    8000376e:	01d7d79b          	srlw	a5,a5,0x1d
    80003772:	9fb9                	addw	a5,a5,a4
    80003774:	4037d79b          	sraw	a5,a5,0x3
    80003778:	00f90633          	add	a2,s2,a5
    8000377c:	05864603          	lbu	a2,88(a2)
    80003780:	00c6f5b3          	and	a1,a3,a2
    80003784:	d585                	beqz	a1,800036ac <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003786:	2705                	addw	a4,a4,1
    80003788:	2485                	addw	s1,s1,1
    8000378a:	fd471ae3          	bne	a4,s4,8000375e <balloc+0xec>
    8000378e:	b769                	j	80003718 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003790:	00005517          	auipc	a0,0x5
    80003794:	e0050513          	add	a0,a0,-512 # 80008590 <syscalls+0x100>
    80003798:	ffffd097          	auipc	ra,0xffffd
    8000379c:	d6a080e7          	jalr	-662(ra) # 80000502 <printf>
  return 0;
    800037a0:	4481                	li	s1,0
    800037a2:	bfa9                	j	800036fc <balloc+0x8a>

00000000800037a4 <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    800037a4:	7179                	add	sp,sp,-48
    800037a6:	f406                	sd	ra,40(sp)
    800037a8:	f022                	sd	s0,32(sp)
    800037aa:	ec26                	sd	s1,24(sp)
    800037ac:	e84a                	sd	s2,16(sp)
    800037ae:	e44e                	sd	s3,8(sp)
    800037b0:	e052                	sd	s4,0(sp)
    800037b2:	1800                	add	s0,sp,48
    800037b4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800037b6:	47ad                	li	a5,11
    800037b8:	02b7e863          	bltu	a5,a1,800037e8 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800037bc:	02059793          	sll	a5,a1,0x20
    800037c0:	01e7d593          	srl	a1,a5,0x1e
    800037c4:	00b504b3          	add	s1,a0,a1
    800037c8:	0504a903          	lw	s2,80(s1)
    800037cc:	06091e63          	bnez	s2,80003848 <bmap+0xa4>
      addr = balloc(ip->dev);
    800037d0:	4108                	lw	a0,0(a0)
    800037d2:	00000097          	auipc	ra,0x0
    800037d6:	ea0080e7          	jalr	-352(ra) # 80003672 <balloc>
    800037da:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800037de:	06090563          	beqz	s2,80003848 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800037e2:	0524a823          	sw	s2,80(s1)
    800037e6:	a08d                	j	80003848 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800037e8:	ff45849b          	addw	s1,a1,-12
    800037ec:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800037f0:	0ff00793          	li	a5,255
    800037f4:	08e7e563          	bltu	a5,a4,8000387e <bmap+0xda>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    800037f8:	08052903          	lw	s2,128(a0)
    800037fc:	00091d63          	bnez	s2,80003816 <bmap+0x72>
      addr = balloc(ip->dev);
    80003800:	4108                	lw	a0,0(a0)
    80003802:	00000097          	auipc	ra,0x0
    80003806:	e70080e7          	jalr	-400(ra) # 80003672 <balloc>
    8000380a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000380e:	02090d63          	beqz	s2,80003848 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003812:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003816:	85ca                	mv	a1,s2
    80003818:	0009a503          	lw	a0,0(s3)
    8000381c:	00000097          	auipc	ra,0x0
    80003820:	b96080e7          	jalr	-1130(ra) # 800033b2 <bread>
    80003824:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003826:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    8000382a:	02049713          	sll	a4,s1,0x20
    8000382e:	01e75593          	srl	a1,a4,0x1e
    80003832:	00b784b3          	add	s1,a5,a1
    80003836:	0004a903          	lw	s2,0(s1)
    8000383a:	02090063          	beqz	s2,8000385a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000383e:	8552                	mv	a0,s4
    80003840:	00000097          	auipc	ra,0x0
    80003844:	ca2080e7          	jalr	-862(ra) # 800034e2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003848:	854a                	mv	a0,s2
    8000384a:	70a2                	ld	ra,40(sp)
    8000384c:	7402                	ld	s0,32(sp)
    8000384e:	64e2                	ld	s1,24(sp)
    80003850:	6942                	ld	s2,16(sp)
    80003852:	69a2                	ld	s3,8(sp)
    80003854:	6a02                	ld	s4,0(sp)
    80003856:	6145                	add	sp,sp,48
    80003858:	8082                	ret
      addr = balloc(ip->dev);
    8000385a:	0009a503          	lw	a0,0(s3)
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	e14080e7          	jalr	-492(ra) # 80003672 <balloc>
    80003866:	0005091b          	sext.w	s2,a0
      if(addr){
    8000386a:	fc090ae3          	beqz	s2,8000383e <bmap+0x9a>
        a[bn] = addr;
    8000386e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003872:	8552                	mv	a0,s4
    80003874:	00001097          	auipc	ra,0x1
    80003878:	ec6080e7          	jalr	-314(ra) # 8000473a <log_write>
    8000387c:	b7c9                	j	8000383e <bmap+0x9a>
  panic("bmap: out of range");
    8000387e:	00005517          	auipc	a0,0x5
    80003882:	d2a50513          	add	a0,a0,-726 # 800085a8 <syscalls+0x118>
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	f88080e7          	jalr	-120(ra) # 8000080e <panic>

000000008000388e <iget>:
{
    8000388e:	7179                	add	sp,sp,-48
    80003890:	f406                	sd	ra,40(sp)
    80003892:	f022                	sd	s0,32(sp)
    80003894:	ec26                	sd	s1,24(sp)
    80003896:	e84a                	sd	s2,16(sp)
    80003898:	e44e                	sd	s3,8(sp)
    8000389a:	e052                	sd	s4,0(sp)
    8000389c:	1800                	add	s0,sp,48
    8000389e:	89aa                	mv	s3,a0
    800038a0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800038a2:	0001c517          	auipc	a0,0x1c
    800038a6:	d2650513          	add	a0,a0,-730 # 8001f5c8 <itable>
    800038aa:	ffffd097          	auipc	ra,0xffffd
    800038ae:	422080e7          	jalr	1058(ra) # 80000ccc <acquire>
  empty = 0;
    800038b2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038b4:	0001c497          	auipc	s1,0x1c
    800038b8:	d2c48493          	add	s1,s1,-724 # 8001f5e0 <itable+0x18>
    800038bc:	0001d697          	auipc	a3,0x1d
    800038c0:	7b468693          	add	a3,a3,1972 # 80021070 <log>
    800038c4:	a039                	j	800038d2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    800038c6:	02090b63          	beqz	s2,800038fc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038ca:	08848493          	add	s1,s1,136
    800038ce:	02d48a63          	beq	s1,a3,80003902 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800038d2:	449c                	lw	a5,8(s1)
    800038d4:	fef059e3          	blez	a5,800038c6 <iget+0x38>
    800038d8:	4098                	lw	a4,0(s1)
    800038da:	ff3716e3          	bne	a4,s3,800038c6 <iget+0x38>
    800038de:	40d8                	lw	a4,4(s1)
    800038e0:	ff4713e3          	bne	a4,s4,800038c6 <iget+0x38>
      ip->ref++;
    800038e4:	2785                	addw	a5,a5,1
    800038e6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800038e8:	0001c517          	auipc	a0,0x1c
    800038ec:	ce050513          	add	a0,a0,-800 # 8001f5c8 <itable>
    800038f0:	ffffd097          	auipc	ra,0xffffd
    800038f4:	490080e7          	jalr	1168(ra) # 80000d80 <release>
      return ip;
    800038f8:	8926                	mv	s2,s1
    800038fa:	a03d                	j	80003928 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    800038fc:	f7f9                	bnez	a5,800038ca <iget+0x3c>
    800038fe:	8926                	mv	s2,s1
    80003900:	b7e9                	j	800038ca <iget+0x3c>
  if(empty == 0)
    80003902:	02090c63          	beqz	s2,8000393a <iget+0xac>
  ip->dev = dev;
    80003906:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000390a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000390e:	4785                	li	a5,1
    80003910:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003914:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003918:	0001c517          	auipc	a0,0x1c
    8000391c:	cb050513          	add	a0,a0,-848 # 8001f5c8 <itable>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	460080e7          	jalr	1120(ra) # 80000d80 <release>
}
    80003928:	854a                	mv	a0,s2
    8000392a:	70a2                	ld	ra,40(sp)
    8000392c:	7402                	ld	s0,32(sp)
    8000392e:	64e2                	ld	s1,24(sp)
    80003930:	6942                	ld	s2,16(sp)
    80003932:	69a2                	ld	s3,8(sp)
    80003934:	6a02                	ld	s4,0(sp)
    80003936:	6145                	add	sp,sp,48
    80003938:	8082                	ret
    panic("iget: no inodes");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	c8650513          	add	a0,a0,-890 # 800085c0 <syscalls+0x130>
    80003942:	ffffd097          	auipc	ra,0xffffd
    80003946:	ecc080e7          	jalr	-308(ra) # 8000080e <panic>

000000008000394a <fsinit>:
fsinit(int dev) {
    8000394a:	7179                	add	sp,sp,-48
    8000394c:	f406                	sd	ra,40(sp)
    8000394e:	f022                	sd	s0,32(sp)
    80003950:	ec26                	sd	s1,24(sp)
    80003952:	e84a                	sd	s2,16(sp)
    80003954:	e44e                	sd	s3,8(sp)
    80003956:	1800                	add	s0,sp,48
    80003958:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000395a:	4585                	li	a1,1
    8000395c:	00000097          	auipc	ra,0x0
    80003960:	a56080e7          	jalr	-1450(ra) # 800033b2 <bread>
    80003964:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003966:	0001c997          	auipc	s3,0x1c
    8000396a:	c4298993          	add	s3,s3,-958 # 8001f5a8 <sb>
    8000396e:	02000613          	li	a2,32
    80003972:	05850593          	add	a1,a0,88
    80003976:	854e                	mv	a0,s3
    80003978:	ffffd097          	auipc	ra,0xffffd
    8000397c:	4ac080e7          	jalr	1196(ra) # 80000e24 <memmove>
  brelse(bp);
    80003980:	8526                	mv	a0,s1
    80003982:	00000097          	auipc	ra,0x0
    80003986:	b60080e7          	jalr	-1184(ra) # 800034e2 <brelse>
  if(sb.magic != FSMAGIC)
    8000398a:	0009a703          	lw	a4,0(s3)
    8000398e:	102037b7          	lui	a5,0x10203
    80003992:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003996:	02f71263          	bne	a4,a5,800039ba <fsinit+0x70>
  initlog(dev, &sb);
    8000399a:	0001c597          	auipc	a1,0x1c
    8000399e:	c0e58593          	add	a1,a1,-1010 # 8001f5a8 <sb>
    800039a2:	854a                	mv	a0,s2
    800039a4:	00001097          	auipc	ra,0x1
    800039a8:	b2c080e7          	jalr	-1236(ra) # 800044d0 <initlog>
}
    800039ac:	70a2                	ld	ra,40(sp)
    800039ae:	7402                	ld	s0,32(sp)
    800039b0:	64e2                	ld	s1,24(sp)
    800039b2:	6942                	ld	s2,16(sp)
    800039b4:	69a2                	ld	s3,8(sp)
    800039b6:	6145                	add	sp,sp,48
    800039b8:	8082                	ret
    panic("invalid file system");
    800039ba:	00005517          	auipc	a0,0x5
    800039be:	c1650513          	add	a0,a0,-1002 # 800085d0 <syscalls+0x140>
    800039c2:	ffffd097          	auipc	ra,0xffffd
    800039c6:	e4c080e7          	jalr	-436(ra) # 8000080e <panic>

00000000800039ca <iinit>:
{
    800039ca:	7179                	add	sp,sp,-48
    800039cc:	f406                	sd	ra,40(sp)
    800039ce:	f022                	sd	s0,32(sp)
    800039d0:	ec26                	sd	s1,24(sp)
    800039d2:	e84a                	sd	s2,16(sp)
    800039d4:	e44e                	sd	s3,8(sp)
    800039d6:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    800039d8:	00005597          	auipc	a1,0x5
    800039dc:	c1058593          	add	a1,a1,-1008 # 800085e8 <syscalls+0x158>
    800039e0:	0001c517          	auipc	a0,0x1c
    800039e4:	be850513          	add	a0,a0,-1048 # 8001f5c8 <itable>
    800039e8:	ffffd097          	auipc	ra,0xffffd
    800039ec:	254080e7          	jalr	596(ra) # 80000c3c <initlock>
  for(i = 0; i < NINODE; i++) {
    800039f0:	0001c497          	auipc	s1,0x1c
    800039f4:	c0048493          	add	s1,s1,-1024 # 8001f5f0 <itable+0x28>
    800039f8:	0001d997          	auipc	s3,0x1d
    800039fc:	68898993          	add	s3,s3,1672 # 80021080 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a00:	00005917          	auipc	s2,0x5
    80003a04:	bf090913          	add	s2,s2,-1040 # 800085f0 <syscalls+0x160>
    80003a08:	85ca                	mv	a1,s2
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	00001097          	auipc	ra,0x1
    80003a10:	e12080e7          	jalr	-494(ra) # 8000481e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a14:	08848493          	add	s1,s1,136
    80003a18:	ff3498e3          	bne	s1,s3,80003a08 <iinit+0x3e>
}
    80003a1c:	70a2                	ld	ra,40(sp)
    80003a1e:	7402                	ld	s0,32(sp)
    80003a20:	64e2                	ld	s1,24(sp)
    80003a22:	6942                	ld	s2,16(sp)
    80003a24:	69a2                	ld	s3,8(sp)
    80003a26:	6145                	add	sp,sp,48
    80003a28:	8082                	ret

0000000080003a2a <ialloc>:
{
    80003a2a:	7139                	add	sp,sp,-64
    80003a2c:	fc06                	sd	ra,56(sp)
    80003a2e:	f822                	sd	s0,48(sp)
    80003a30:	f426                	sd	s1,40(sp)
    80003a32:	f04a                	sd	s2,32(sp)
    80003a34:	ec4e                	sd	s3,24(sp)
    80003a36:	e852                	sd	s4,16(sp)
    80003a38:	e456                	sd	s5,8(sp)
    80003a3a:	e05a                	sd	s6,0(sp)
    80003a3c:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a3e:	0001c717          	auipc	a4,0x1c
    80003a42:	b7672703          	lw	a4,-1162(a4) # 8001f5b4 <sb+0xc>
    80003a46:	4785                	li	a5,1
    80003a48:	04e7f863          	bgeu	a5,a4,80003a98 <ialloc+0x6e>
    80003a4c:	8aaa                	mv	s5,a0
    80003a4e:	8b2e                	mv	s6,a1
    80003a50:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a52:	0001ca17          	auipc	s4,0x1c
    80003a56:	b56a0a13          	add	s4,s4,-1194 # 8001f5a8 <sb>
    80003a5a:	00495593          	srl	a1,s2,0x4
    80003a5e:	018a2783          	lw	a5,24(s4)
    80003a62:	9dbd                	addw	a1,a1,a5
    80003a64:	8556                	mv	a0,s5
    80003a66:	00000097          	auipc	ra,0x0
    80003a6a:	94c080e7          	jalr	-1716(ra) # 800033b2 <bread>
    80003a6e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003a70:	05850993          	add	s3,a0,88
    80003a74:	00f97793          	and	a5,s2,15
    80003a78:	079a                	sll	a5,a5,0x6
    80003a7a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    80003a7c:	00099783          	lh	a5,0(s3)
    80003a80:	cf9d                	beqz	a5,80003abe <ialloc+0x94>
    brelse(bp);
    80003a82:	00000097          	auipc	ra,0x0
    80003a86:	a60080e7          	jalr	-1440(ra) # 800034e2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a8a:	0905                	add	s2,s2,1
    80003a8c:	00ca2703          	lw	a4,12(s4)
    80003a90:	0009079b          	sext.w	a5,s2
    80003a94:	fce7e3e3          	bltu	a5,a4,80003a5a <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003a98:	00005517          	auipc	a0,0x5
    80003a9c:	b6050513          	add	a0,a0,-1184 # 800085f8 <syscalls+0x168>
    80003aa0:	ffffd097          	auipc	ra,0xffffd
    80003aa4:	a62080e7          	jalr	-1438(ra) # 80000502 <printf>
  return 0;
    80003aa8:	4501                	li	a0,0
}
    80003aaa:	70e2                	ld	ra,56(sp)
    80003aac:	7442                	ld	s0,48(sp)
    80003aae:	74a2                	ld	s1,40(sp)
    80003ab0:	7902                	ld	s2,32(sp)
    80003ab2:	69e2                	ld	s3,24(sp)
    80003ab4:	6a42                	ld	s4,16(sp)
    80003ab6:	6aa2                	ld	s5,8(sp)
    80003ab8:	6b02                	ld	s6,0(sp)
    80003aba:	6121                	add	sp,sp,64
    80003abc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003abe:	04000613          	li	a2,64
    80003ac2:	4581                	li	a1,0
    80003ac4:	854e                	mv	a0,s3
    80003ac6:	ffffd097          	auipc	ra,0xffffd
    80003aca:	302080e7          	jalr	770(ra) # 80000dc8 <memset>
      dip->type = type;
    80003ace:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80003ad2:	8526                	mv	a0,s1
    80003ad4:	00001097          	auipc	ra,0x1
    80003ad8:	c66080e7          	jalr	-922(ra) # 8000473a <log_write>
      brelse(bp);
    80003adc:	8526                	mv	a0,s1
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	a04080e7          	jalr	-1532(ra) # 800034e2 <brelse>
      return iget(dev, inum);
    80003ae6:	0009059b          	sext.w	a1,s2
    80003aea:	8556                	mv	a0,s5
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	da2080e7          	jalr	-606(ra) # 8000388e <iget>
    80003af4:	bf5d                	j	80003aaa <ialloc+0x80>

0000000080003af6 <iupdate>:
{
    80003af6:	1101                	add	sp,sp,-32
    80003af8:	ec06                	sd	ra,24(sp)
    80003afa:	e822                	sd	s0,16(sp)
    80003afc:	e426                	sd	s1,8(sp)
    80003afe:	e04a                	sd	s2,0(sp)
    80003b00:	1000                	add	s0,sp,32
    80003b02:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b04:	415c                	lw	a5,4(a0)
    80003b06:	0047d79b          	srlw	a5,a5,0x4
    80003b0a:	0001c597          	auipc	a1,0x1c
    80003b0e:	ab65a583          	lw	a1,-1354(a1) # 8001f5c0 <sb+0x18>
    80003b12:	9dbd                	addw	a1,a1,a5
    80003b14:	4108                	lw	a0,0(a0)
    80003b16:	00000097          	auipc	ra,0x0
    80003b1a:	89c080e7          	jalr	-1892(ra) # 800033b2 <bread>
    80003b1e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b20:	05850793          	add	a5,a0,88
    80003b24:	40d8                	lw	a4,4(s1)
    80003b26:	8b3d                	and	a4,a4,15
    80003b28:	071a                	sll	a4,a4,0x6
    80003b2a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003b2c:	04449703          	lh	a4,68(s1)
    80003b30:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003b34:	04649703          	lh	a4,70(s1)
    80003b38:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003b3c:	04849703          	lh	a4,72(s1)
    80003b40:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003b44:	04a49703          	lh	a4,74(s1)
    80003b48:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003b4c:	44f8                	lw	a4,76(s1)
    80003b4e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b50:	03400613          	li	a2,52
    80003b54:	05048593          	add	a1,s1,80
    80003b58:	00c78513          	add	a0,a5,12
    80003b5c:	ffffd097          	auipc	ra,0xffffd
    80003b60:	2c8080e7          	jalr	712(ra) # 80000e24 <memmove>
  log_write(bp);
    80003b64:	854a                	mv	a0,s2
    80003b66:	00001097          	auipc	ra,0x1
    80003b6a:	bd4080e7          	jalr	-1068(ra) # 8000473a <log_write>
  brelse(bp);
    80003b6e:	854a                	mv	a0,s2
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	972080e7          	jalr	-1678(ra) # 800034e2 <brelse>
}
    80003b78:	60e2                	ld	ra,24(sp)
    80003b7a:	6442                	ld	s0,16(sp)
    80003b7c:	64a2                	ld	s1,8(sp)
    80003b7e:	6902                	ld	s2,0(sp)
    80003b80:	6105                	add	sp,sp,32
    80003b82:	8082                	ret

0000000080003b84 <idup>:
{
    80003b84:	1101                	add	sp,sp,-32
    80003b86:	ec06                	sd	ra,24(sp)
    80003b88:	e822                	sd	s0,16(sp)
    80003b8a:	e426                	sd	s1,8(sp)
    80003b8c:	1000                	add	s0,sp,32
    80003b8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b90:	0001c517          	auipc	a0,0x1c
    80003b94:	a3850513          	add	a0,a0,-1480 # 8001f5c8 <itable>
    80003b98:	ffffd097          	auipc	ra,0xffffd
    80003b9c:	134080e7          	jalr	308(ra) # 80000ccc <acquire>
  ip->ref++;
    80003ba0:	449c                	lw	a5,8(s1)
    80003ba2:	2785                	addw	a5,a5,1
    80003ba4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ba6:	0001c517          	auipc	a0,0x1c
    80003baa:	a2250513          	add	a0,a0,-1502 # 8001f5c8 <itable>
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	1d2080e7          	jalr	466(ra) # 80000d80 <release>
}
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	60e2                	ld	ra,24(sp)
    80003bba:	6442                	ld	s0,16(sp)
    80003bbc:	64a2                	ld	s1,8(sp)
    80003bbe:	6105                	add	sp,sp,32
    80003bc0:	8082                	ret

0000000080003bc2 <ilock>:
{
    80003bc2:	1101                	add	sp,sp,-32
    80003bc4:	ec06                	sd	ra,24(sp)
    80003bc6:	e822                	sd	s0,16(sp)
    80003bc8:	e426                	sd	s1,8(sp)
    80003bca:	e04a                	sd	s2,0(sp)
    80003bcc:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003bce:	c115                	beqz	a0,80003bf2 <ilock+0x30>
    80003bd0:	84aa                	mv	s1,a0
    80003bd2:	451c                	lw	a5,8(a0)
    80003bd4:	00f05f63          	blez	a5,80003bf2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003bd8:	0541                	add	a0,a0,16
    80003bda:	00001097          	auipc	ra,0x1
    80003bde:	c7e080e7          	jalr	-898(ra) # 80004858 <acquiresleep>
  if(ip->valid == 0){
    80003be2:	40bc                	lw	a5,64(s1)
    80003be4:	cf99                	beqz	a5,80003c02 <ilock+0x40>
}
    80003be6:	60e2                	ld	ra,24(sp)
    80003be8:	6442                	ld	s0,16(sp)
    80003bea:	64a2                	ld	s1,8(sp)
    80003bec:	6902                	ld	s2,0(sp)
    80003bee:	6105                	add	sp,sp,32
    80003bf0:	8082                	ret
    panic("ilock");
    80003bf2:	00005517          	auipc	a0,0x5
    80003bf6:	a1e50513          	add	a0,a0,-1506 # 80008610 <syscalls+0x180>
    80003bfa:	ffffd097          	auipc	ra,0xffffd
    80003bfe:	c14080e7          	jalr	-1004(ra) # 8000080e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c02:	40dc                	lw	a5,4(s1)
    80003c04:	0047d79b          	srlw	a5,a5,0x4
    80003c08:	0001c597          	auipc	a1,0x1c
    80003c0c:	9b85a583          	lw	a1,-1608(a1) # 8001f5c0 <sb+0x18>
    80003c10:	9dbd                	addw	a1,a1,a5
    80003c12:	4088                	lw	a0,0(s1)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	79e080e7          	jalr	1950(ra) # 800033b2 <bread>
    80003c1c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c1e:	05850593          	add	a1,a0,88
    80003c22:	40dc                	lw	a5,4(s1)
    80003c24:	8bbd                	and	a5,a5,15
    80003c26:	079a                	sll	a5,a5,0x6
    80003c28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c2a:	00059783          	lh	a5,0(a1)
    80003c2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c32:	00259783          	lh	a5,2(a1)
    80003c36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c3a:	00459783          	lh	a5,4(a1)
    80003c3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c42:	00659783          	lh	a5,6(a1)
    80003c46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c4a:	459c                	lw	a5,8(a1)
    80003c4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c4e:	03400613          	li	a2,52
    80003c52:	05b1                	add	a1,a1,12
    80003c54:	05048513          	add	a0,s1,80
    80003c58:	ffffd097          	auipc	ra,0xffffd
    80003c5c:	1cc080e7          	jalr	460(ra) # 80000e24 <memmove>
    brelse(bp);
    80003c60:	854a                	mv	a0,s2
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	880080e7          	jalr	-1920(ra) # 800034e2 <brelse>
    ip->valid = 1;
    80003c6a:	4785                	li	a5,1
    80003c6c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003c6e:	04449783          	lh	a5,68(s1)
    80003c72:	fbb5                	bnez	a5,80003be6 <ilock+0x24>
      panic("ilock: no type");
    80003c74:	00005517          	auipc	a0,0x5
    80003c78:	9a450513          	add	a0,a0,-1628 # 80008618 <syscalls+0x188>
    80003c7c:	ffffd097          	auipc	ra,0xffffd
    80003c80:	b92080e7          	jalr	-1134(ra) # 8000080e <panic>

0000000080003c84 <iunlock>:
{
    80003c84:	1101                	add	sp,sp,-32
    80003c86:	ec06                	sd	ra,24(sp)
    80003c88:	e822                	sd	s0,16(sp)
    80003c8a:	e426                	sd	s1,8(sp)
    80003c8c:	e04a                	sd	s2,0(sp)
    80003c8e:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c90:	c905                	beqz	a0,80003cc0 <iunlock+0x3c>
    80003c92:	84aa                	mv	s1,a0
    80003c94:	01050913          	add	s2,a0,16
    80003c98:	854a                	mv	a0,s2
    80003c9a:	00001097          	auipc	ra,0x1
    80003c9e:	c58080e7          	jalr	-936(ra) # 800048f2 <holdingsleep>
    80003ca2:	cd19                	beqz	a0,80003cc0 <iunlock+0x3c>
    80003ca4:	449c                	lw	a5,8(s1)
    80003ca6:	00f05d63          	blez	a5,80003cc0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003caa:	854a                	mv	a0,s2
    80003cac:	00001097          	auipc	ra,0x1
    80003cb0:	c02080e7          	jalr	-1022(ra) # 800048ae <releasesleep>
}
    80003cb4:	60e2                	ld	ra,24(sp)
    80003cb6:	6442                	ld	s0,16(sp)
    80003cb8:	64a2                	ld	s1,8(sp)
    80003cba:	6902                	ld	s2,0(sp)
    80003cbc:	6105                	add	sp,sp,32
    80003cbe:	8082                	ret
    panic("iunlock");
    80003cc0:	00005517          	auipc	a0,0x5
    80003cc4:	96850513          	add	a0,a0,-1688 # 80008628 <syscalls+0x198>
    80003cc8:	ffffd097          	auipc	ra,0xffffd
    80003ccc:	b46080e7          	jalr	-1210(ra) # 8000080e <panic>

0000000080003cd0 <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    80003cd0:	7179                	add	sp,sp,-48
    80003cd2:	f406                	sd	ra,40(sp)
    80003cd4:	f022                	sd	s0,32(sp)
    80003cd6:	ec26                	sd	s1,24(sp)
    80003cd8:	e84a                	sd	s2,16(sp)
    80003cda:	e44e                	sd	s3,8(sp)
    80003cdc:	e052                	sd	s4,0(sp)
    80003cde:	1800                	add	s0,sp,48
    80003ce0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003ce2:	05050493          	add	s1,a0,80
    80003ce6:	08050913          	add	s2,a0,128
    80003cea:	a021                	j	80003cf2 <itrunc+0x22>
    80003cec:	0491                	add	s1,s1,4
    80003cee:	01248d63          	beq	s1,s2,80003d08 <itrunc+0x38>
    if(ip->addrs[i]){
    80003cf2:	408c                	lw	a1,0(s1)
    80003cf4:	dde5                	beqz	a1,80003cec <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003cf6:	0009a503          	lw	a0,0(s3)
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	8fc080e7          	jalr	-1796(ra) # 800035f6 <bfree>
      ip->addrs[i] = 0;
    80003d02:	0004a023          	sw	zero,0(s1)
    80003d06:	b7dd                	j	80003cec <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d08:	0809a583          	lw	a1,128(s3)
    80003d0c:	e185                	bnez	a1,80003d2c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d0e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d12:	854e                	mv	a0,s3
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	de2080e7          	jalr	-542(ra) # 80003af6 <iupdate>
}
    80003d1c:	70a2                	ld	ra,40(sp)
    80003d1e:	7402                	ld	s0,32(sp)
    80003d20:	64e2                	ld	s1,24(sp)
    80003d22:	6942                	ld	s2,16(sp)
    80003d24:	69a2                	ld	s3,8(sp)
    80003d26:	6a02                	ld	s4,0(sp)
    80003d28:	6145                	add	sp,sp,48
    80003d2a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d2c:	0009a503          	lw	a0,0(s3)
    80003d30:	fffff097          	auipc	ra,0xfffff
    80003d34:	682080e7          	jalr	1666(ra) # 800033b2 <bread>
    80003d38:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d3a:	05850493          	add	s1,a0,88
    80003d3e:	45850913          	add	s2,a0,1112
    80003d42:	a021                	j	80003d4a <itrunc+0x7a>
    80003d44:	0491                	add	s1,s1,4
    80003d46:	01248b63          	beq	s1,s2,80003d5c <itrunc+0x8c>
      if(a[j])
    80003d4a:	408c                	lw	a1,0(s1)
    80003d4c:	dde5                	beqz	a1,80003d44 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003d4e:	0009a503          	lw	a0,0(s3)
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	8a4080e7          	jalr	-1884(ra) # 800035f6 <bfree>
    80003d5a:	b7ed                	j	80003d44 <itrunc+0x74>
    brelse(bp);
    80003d5c:	8552                	mv	a0,s4
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	784080e7          	jalr	1924(ra) # 800034e2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003d66:	0809a583          	lw	a1,128(s3)
    80003d6a:	0009a503          	lw	a0,0(s3)
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	888080e7          	jalr	-1912(ra) # 800035f6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003d76:	0809a023          	sw	zero,128(s3)
    80003d7a:	bf51                	j	80003d0e <itrunc+0x3e>

0000000080003d7c <iput>:
{
    80003d7c:	1101                	add	sp,sp,-32
    80003d7e:	ec06                	sd	ra,24(sp)
    80003d80:	e822                	sd	s0,16(sp)
    80003d82:	e426                	sd	s1,8(sp)
    80003d84:	e04a                	sd	s2,0(sp)
    80003d86:	1000                	add	s0,sp,32
    80003d88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d8a:	0001c517          	auipc	a0,0x1c
    80003d8e:	83e50513          	add	a0,a0,-1986 # 8001f5c8 <itable>
    80003d92:	ffffd097          	auipc	ra,0xffffd
    80003d96:	f3a080e7          	jalr	-198(ra) # 80000ccc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d9a:	4498                	lw	a4,8(s1)
    80003d9c:	4785                	li	a5,1
    80003d9e:	02f70363          	beq	a4,a5,80003dc4 <iput+0x48>
  ip->ref--;
    80003da2:	449c                	lw	a5,8(s1)
    80003da4:	37fd                	addw	a5,a5,-1
    80003da6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003da8:	0001c517          	auipc	a0,0x1c
    80003dac:	82050513          	add	a0,a0,-2016 # 8001f5c8 <itable>
    80003db0:	ffffd097          	auipc	ra,0xffffd
    80003db4:	fd0080e7          	jalr	-48(ra) # 80000d80 <release>
}
    80003db8:	60e2                	ld	ra,24(sp)
    80003dba:	6442                	ld	s0,16(sp)
    80003dbc:	64a2                	ld	s1,8(sp)
    80003dbe:	6902                	ld	s2,0(sp)
    80003dc0:	6105                	add	sp,sp,32
    80003dc2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003dc4:	40bc                	lw	a5,64(s1)
    80003dc6:	dff1                	beqz	a5,80003da2 <iput+0x26>
    80003dc8:	04a49783          	lh	a5,74(s1)
    80003dcc:	fbf9                	bnez	a5,80003da2 <iput+0x26>
    acquiresleep(&ip->lock);
    80003dce:	01048913          	add	s2,s1,16
    80003dd2:	854a                	mv	a0,s2
    80003dd4:	00001097          	auipc	ra,0x1
    80003dd8:	a84080e7          	jalr	-1404(ra) # 80004858 <acquiresleep>
    release(&itable.lock);
    80003ddc:	0001b517          	auipc	a0,0x1b
    80003de0:	7ec50513          	add	a0,a0,2028 # 8001f5c8 <itable>
    80003de4:	ffffd097          	auipc	ra,0xffffd
    80003de8:	f9c080e7          	jalr	-100(ra) # 80000d80 <release>
    itrunc(ip);
    80003dec:	8526                	mv	a0,s1
    80003dee:	00000097          	auipc	ra,0x0
    80003df2:	ee2080e7          	jalr	-286(ra) # 80003cd0 <itrunc>
    ip->type = 0;
    80003df6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003dfa:	8526                	mv	a0,s1
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	cfa080e7          	jalr	-774(ra) # 80003af6 <iupdate>
    ip->valid = 0;
    80003e04:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e08:	854a                	mv	a0,s2
    80003e0a:	00001097          	auipc	ra,0x1
    80003e0e:	aa4080e7          	jalr	-1372(ra) # 800048ae <releasesleep>
    acquire(&itable.lock);
    80003e12:	0001b517          	auipc	a0,0x1b
    80003e16:	7b650513          	add	a0,a0,1974 # 8001f5c8 <itable>
    80003e1a:	ffffd097          	auipc	ra,0xffffd
    80003e1e:	eb2080e7          	jalr	-334(ra) # 80000ccc <acquire>
    80003e22:	b741                	j	80003da2 <iput+0x26>

0000000080003e24 <iunlockput>:
{
    80003e24:	1101                	add	sp,sp,-32
    80003e26:	ec06                	sd	ra,24(sp)
    80003e28:	e822                	sd	s0,16(sp)
    80003e2a:	e426                	sd	s1,8(sp)
    80003e2c:	1000                	add	s0,sp,32
    80003e2e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e30:	00000097          	auipc	ra,0x0
    80003e34:	e54080e7          	jalr	-428(ra) # 80003c84 <iunlock>
  iput(ip);
    80003e38:	8526                	mv	a0,s1
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	f42080e7          	jalr	-190(ra) # 80003d7c <iput>
}
    80003e42:	60e2                	ld	ra,24(sp)
    80003e44:	6442                	ld	s0,16(sp)
    80003e46:	64a2                	ld	s1,8(sp)
    80003e48:	6105                	add	sp,sp,32
    80003e4a:	8082                	ret

0000000080003e4c <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80003e4c:	1141                	add	sp,sp,-16
    80003e4e:	e422                	sd	s0,8(sp)
    80003e50:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003e52:	411c                	lw	a5,0(a0)
    80003e54:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e56:	415c                	lw	a5,4(a0)
    80003e58:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e5a:	04451783          	lh	a5,68(a0)
    80003e5e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e62:	04a51783          	lh	a5,74(a0)
    80003e66:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e6a:	04c56783          	lwu	a5,76(a0)
    80003e6e:	e99c                	sd	a5,16(a1)
}
    80003e70:	6422                	ld	s0,8(sp)
    80003e72:	0141                	add	sp,sp,16
    80003e74:	8082                	ret

0000000080003e76 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e76:	457c                	lw	a5,76(a0)
    80003e78:	0ed7e963          	bltu	a5,a3,80003f6a <readi+0xf4>
{
    80003e7c:	7159                	add	sp,sp,-112
    80003e7e:	f486                	sd	ra,104(sp)
    80003e80:	f0a2                	sd	s0,96(sp)
    80003e82:	eca6                	sd	s1,88(sp)
    80003e84:	e8ca                	sd	s2,80(sp)
    80003e86:	e4ce                	sd	s3,72(sp)
    80003e88:	e0d2                	sd	s4,64(sp)
    80003e8a:	fc56                	sd	s5,56(sp)
    80003e8c:	f85a                	sd	s6,48(sp)
    80003e8e:	f45e                	sd	s7,40(sp)
    80003e90:	f062                	sd	s8,32(sp)
    80003e92:	ec66                	sd	s9,24(sp)
    80003e94:	e86a                	sd	s10,16(sp)
    80003e96:	e46e                	sd	s11,8(sp)
    80003e98:	1880                	add	s0,sp,112
    80003e9a:	8b2a                	mv	s6,a0
    80003e9c:	8bae                	mv	s7,a1
    80003e9e:	8a32                	mv	s4,a2
    80003ea0:	84b6                	mv	s1,a3
    80003ea2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003ea4:	9f35                	addw	a4,a4,a3
    return 0;
    80003ea6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003ea8:	0ad76063          	bltu	a4,a3,80003f48 <readi+0xd2>
  if(off + n > ip->size)
    80003eac:	00e7f463          	bgeu	a5,a4,80003eb4 <readi+0x3e>
    n = ip->size - off;
    80003eb0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003eb4:	0a0a8963          	beqz	s5,80003f66 <readi+0xf0>
    80003eb8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003eba:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ebe:	5c7d                	li	s8,-1
    80003ec0:	a82d                	j	80003efa <readi+0x84>
    80003ec2:	020d1d93          	sll	s11,s10,0x20
    80003ec6:	020ddd93          	srl	s11,s11,0x20
    80003eca:	05890613          	add	a2,s2,88
    80003ece:	86ee                	mv	a3,s11
    80003ed0:	963a                	add	a2,a2,a4
    80003ed2:	85d2                	mv	a1,s4
    80003ed4:	855e                	mv	a0,s7
    80003ed6:	fffff097          	auipc	ra,0xfffff
    80003eda:	b32080e7          	jalr	-1230(ra) # 80002a08 <either_copyout>
    80003ede:	05850d63          	beq	a0,s8,80003f38 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ee2:	854a                	mv	a0,s2
    80003ee4:	fffff097          	auipc	ra,0xfffff
    80003ee8:	5fe080e7          	jalr	1534(ra) # 800034e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003eec:	013d09bb          	addw	s3,s10,s3
    80003ef0:	009d04bb          	addw	s1,s10,s1
    80003ef4:	9a6e                	add	s4,s4,s11
    80003ef6:	0559f763          	bgeu	s3,s5,80003f44 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003efa:	00a4d59b          	srlw	a1,s1,0xa
    80003efe:	855a                	mv	a0,s6
    80003f00:	00000097          	auipc	ra,0x0
    80003f04:	8a4080e7          	jalr	-1884(ra) # 800037a4 <bmap>
    80003f08:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003f0c:	cd85                	beqz	a1,80003f44 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003f0e:	000b2503          	lw	a0,0(s6)
    80003f12:	fffff097          	auipc	ra,0xfffff
    80003f16:	4a0080e7          	jalr	1184(ra) # 800033b2 <bread>
    80003f1a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f1c:	3ff4f713          	and	a4,s1,1023
    80003f20:	40ec87bb          	subw	a5,s9,a4
    80003f24:	413a86bb          	subw	a3,s5,s3
    80003f28:	8d3e                	mv	s10,a5
    80003f2a:	2781                	sext.w	a5,a5
    80003f2c:	0006861b          	sext.w	a2,a3
    80003f30:	f8f679e3          	bgeu	a2,a5,80003ec2 <readi+0x4c>
    80003f34:	8d36                	mv	s10,a3
    80003f36:	b771                	j	80003ec2 <readi+0x4c>
      brelse(bp);
    80003f38:	854a                	mv	a0,s2
    80003f3a:	fffff097          	auipc	ra,0xfffff
    80003f3e:	5a8080e7          	jalr	1448(ra) # 800034e2 <brelse>
      tot = -1;
    80003f42:	59fd                	li	s3,-1
  }
  return tot;
    80003f44:	0009851b          	sext.w	a0,s3
}
    80003f48:	70a6                	ld	ra,104(sp)
    80003f4a:	7406                	ld	s0,96(sp)
    80003f4c:	64e6                	ld	s1,88(sp)
    80003f4e:	6946                	ld	s2,80(sp)
    80003f50:	69a6                	ld	s3,72(sp)
    80003f52:	6a06                	ld	s4,64(sp)
    80003f54:	7ae2                	ld	s5,56(sp)
    80003f56:	7b42                	ld	s6,48(sp)
    80003f58:	7ba2                	ld	s7,40(sp)
    80003f5a:	7c02                	ld	s8,32(sp)
    80003f5c:	6ce2                	ld	s9,24(sp)
    80003f5e:	6d42                	ld	s10,16(sp)
    80003f60:	6da2                	ld	s11,8(sp)
    80003f62:	6165                	add	sp,sp,112
    80003f64:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f66:	89d6                	mv	s3,s5
    80003f68:	bff1                	j	80003f44 <readi+0xce>
    return 0;
    80003f6a:	4501                	li	a0,0
}
    80003f6c:	8082                	ret

0000000080003f6e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f6e:	457c                	lw	a5,76(a0)
    80003f70:	10d7e863          	bltu	a5,a3,80004080 <writei+0x112>
{
    80003f74:	7159                	add	sp,sp,-112
    80003f76:	f486                	sd	ra,104(sp)
    80003f78:	f0a2                	sd	s0,96(sp)
    80003f7a:	eca6                	sd	s1,88(sp)
    80003f7c:	e8ca                	sd	s2,80(sp)
    80003f7e:	e4ce                	sd	s3,72(sp)
    80003f80:	e0d2                	sd	s4,64(sp)
    80003f82:	fc56                	sd	s5,56(sp)
    80003f84:	f85a                	sd	s6,48(sp)
    80003f86:	f45e                	sd	s7,40(sp)
    80003f88:	f062                	sd	s8,32(sp)
    80003f8a:	ec66                	sd	s9,24(sp)
    80003f8c:	e86a                	sd	s10,16(sp)
    80003f8e:	e46e                	sd	s11,8(sp)
    80003f90:	1880                	add	s0,sp,112
    80003f92:	8aaa                	mv	s5,a0
    80003f94:	8bae                	mv	s7,a1
    80003f96:	8a32                	mv	s4,a2
    80003f98:	8936                	mv	s2,a3
    80003f9a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f9c:	00e687bb          	addw	a5,a3,a4
    80003fa0:	0ed7e263          	bltu	a5,a3,80004084 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003fa4:	00043737          	lui	a4,0x43
    80003fa8:	0ef76063          	bltu	a4,a5,80004088 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fac:	0c0b0863          	beqz	s6,8000407c <writei+0x10e>
    80003fb0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fb2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003fb6:	5c7d                	li	s8,-1
    80003fb8:	a091                	j	80003ffc <writei+0x8e>
    80003fba:	020d1d93          	sll	s11,s10,0x20
    80003fbe:	020ddd93          	srl	s11,s11,0x20
    80003fc2:	05848513          	add	a0,s1,88
    80003fc6:	86ee                	mv	a3,s11
    80003fc8:	8652                	mv	a2,s4
    80003fca:	85de                	mv	a1,s7
    80003fcc:	953a                	add	a0,a0,a4
    80003fce:	fffff097          	auipc	ra,0xfffff
    80003fd2:	a90080e7          	jalr	-1392(ra) # 80002a5e <either_copyin>
    80003fd6:	07850263          	beq	a0,s8,8000403a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	00000097          	auipc	ra,0x0
    80003fe0:	75e080e7          	jalr	1886(ra) # 8000473a <log_write>
    brelse(bp);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	fffff097          	auipc	ra,0xfffff
    80003fea:	4fc080e7          	jalr	1276(ra) # 800034e2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fee:	013d09bb          	addw	s3,s10,s3
    80003ff2:	012d093b          	addw	s2,s10,s2
    80003ff6:	9a6e                	add	s4,s4,s11
    80003ff8:	0569f663          	bgeu	s3,s6,80004044 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003ffc:	00a9559b          	srlw	a1,s2,0xa
    80004000:	8556                	mv	a0,s5
    80004002:	fffff097          	auipc	ra,0xfffff
    80004006:	7a2080e7          	jalr	1954(ra) # 800037a4 <bmap>
    8000400a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000400e:	c99d                	beqz	a1,80004044 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004010:	000aa503          	lw	a0,0(s5)
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	39e080e7          	jalr	926(ra) # 800033b2 <bread>
    8000401c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000401e:	3ff97713          	and	a4,s2,1023
    80004022:	40ec87bb          	subw	a5,s9,a4
    80004026:	413b06bb          	subw	a3,s6,s3
    8000402a:	8d3e                	mv	s10,a5
    8000402c:	2781                	sext.w	a5,a5
    8000402e:	0006861b          	sext.w	a2,a3
    80004032:	f8f674e3          	bgeu	a2,a5,80003fba <writei+0x4c>
    80004036:	8d36                	mv	s10,a3
    80004038:	b749                	j	80003fba <writei+0x4c>
      brelse(bp);
    8000403a:	8526                	mv	a0,s1
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	4a6080e7          	jalr	1190(ra) # 800034e2 <brelse>
  }

  if(off > ip->size)
    80004044:	04caa783          	lw	a5,76(s5)
    80004048:	0127f463          	bgeu	a5,s2,80004050 <writei+0xe2>
    ip->size = off;
    8000404c:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    80004050:	8556                	mv	a0,s5
    80004052:	00000097          	auipc	ra,0x0
    80004056:	aa4080e7          	jalr	-1372(ra) # 80003af6 <iupdate>

  return tot;
    8000405a:	0009851b          	sext.w	a0,s3
}
    8000405e:	70a6                	ld	ra,104(sp)
    80004060:	7406                	ld	s0,96(sp)
    80004062:	64e6                	ld	s1,88(sp)
    80004064:	6946                	ld	s2,80(sp)
    80004066:	69a6                	ld	s3,72(sp)
    80004068:	6a06                	ld	s4,64(sp)
    8000406a:	7ae2                	ld	s5,56(sp)
    8000406c:	7b42                	ld	s6,48(sp)
    8000406e:	7ba2                	ld	s7,40(sp)
    80004070:	7c02                	ld	s8,32(sp)
    80004072:	6ce2                	ld	s9,24(sp)
    80004074:	6d42                	ld	s10,16(sp)
    80004076:	6da2                	ld	s11,8(sp)
    80004078:	6165                	add	sp,sp,112
    8000407a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000407c:	89da                	mv	s3,s6
    8000407e:	bfc9                	j	80004050 <writei+0xe2>
    return -1;
    80004080:	557d                	li	a0,-1
}
    80004082:	8082                	ret
    return -1;
    80004084:	557d                	li	a0,-1
    80004086:	bfe1                	j	8000405e <writei+0xf0>
    return -1;
    80004088:	557d                	li	a0,-1
    8000408a:	bfd1                	j	8000405e <writei+0xf0>

000000008000408c <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    8000408c:	1141                	add	sp,sp,-16
    8000408e:	e406                	sd	ra,8(sp)
    80004090:	e022                	sd	s0,0(sp)
    80004092:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004094:	4639                	li	a2,14
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	e02080e7          	jalr	-510(ra) # 80000e98 <strncmp>
}
    8000409e:	60a2                	ld	ra,8(sp)
    800040a0:	6402                	ld	s0,0(sp)
    800040a2:	0141                	add	sp,sp,16
    800040a4:	8082                	ret

00000000800040a6 <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800040a6:	7139                	add	sp,sp,-64
    800040a8:	fc06                	sd	ra,56(sp)
    800040aa:	f822                	sd	s0,48(sp)
    800040ac:	f426                	sd	s1,40(sp)
    800040ae:	f04a                	sd	s2,32(sp)
    800040b0:	ec4e                	sd	s3,24(sp)
    800040b2:	e852                	sd	s4,16(sp)
    800040b4:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800040b6:	04451703          	lh	a4,68(a0)
    800040ba:	4785                	li	a5,1
    800040bc:	00f71a63          	bne	a4,a5,800040d0 <dirlookup+0x2a>
    800040c0:	892a                	mv	s2,a0
    800040c2:	89ae                	mv	s3,a1
    800040c4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800040c6:	457c                	lw	a5,76(a0)
    800040c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800040ca:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040cc:	e79d                	bnez	a5,800040fa <dirlookup+0x54>
    800040ce:	a8a5                	j	80004146 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800040d0:	00004517          	auipc	a0,0x4
    800040d4:	56050513          	add	a0,a0,1376 # 80008630 <syscalls+0x1a0>
    800040d8:	ffffc097          	auipc	ra,0xffffc
    800040dc:	736080e7          	jalr	1846(ra) # 8000080e <panic>
      panic("dirlookup read");
    800040e0:	00004517          	auipc	a0,0x4
    800040e4:	56850513          	add	a0,a0,1384 # 80008648 <syscalls+0x1b8>
    800040e8:	ffffc097          	auipc	ra,0xffffc
    800040ec:	726080e7          	jalr	1830(ra) # 8000080e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040f0:	24c1                	addw	s1,s1,16
    800040f2:	04c92783          	lw	a5,76(s2)
    800040f6:	04f4f763          	bgeu	s1,a5,80004144 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040fa:	4741                	li	a4,16
    800040fc:	86a6                	mv	a3,s1
    800040fe:	fc040613          	add	a2,s0,-64
    80004102:	4581                	li	a1,0
    80004104:	854a                	mv	a0,s2
    80004106:	00000097          	auipc	ra,0x0
    8000410a:	d70080e7          	jalr	-656(ra) # 80003e76 <readi>
    8000410e:	47c1                	li	a5,16
    80004110:	fcf518e3          	bne	a0,a5,800040e0 <dirlookup+0x3a>
    if(de.inum == 0)
    80004114:	fc045783          	lhu	a5,-64(s0)
    80004118:	dfe1                	beqz	a5,800040f0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000411a:	fc240593          	add	a1,s0,-62
    8000411e:	854e                	mv	a0,s3
    80004120:	00000097          	auipc	ra,0x0
    80004124:	f6c080e7          	jalr	-148(ra) # 8000408c <namecmp>
    80004128:	f561                	bnez	a0,800040f0 <dirlookup+0x4a>
      if(poff)
    8000412a:	000a0463          	beqz	s4,80004132 <dirlookup+0x8c>
        *poff = off;
    8000412e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004132:	fc045583          	lhu	a1,-64(s0)
    80004136:	00092503          	lw	a0,0(s2)
    8000413a:	fffff097          	auipc	ra,0xfffff
    8000413e:	754080e7          	jalr	1876(ra) # 8000388e <iget>
    80004142:	a011                	j	80004146 <dirlookup+0xa0>
  return 0;
    80004144:	4501                	li	a0,0
}
    80004146:	70e2                	ld	ra,56(sp)
    80004148:	7442                	ld	s0,48(sp)
    8000414a:	74a2                	ld	s1,40(sp)
    8000414c:	7902                	ld	s2,32(sp)
    8000414e:	69e2                	ld	s3,24(sp)
    80004150:	6a42                	ld	s4,16(sp)
    80004152:	6121                	add	sp,sp,64
    80004154:	8082                	ret

0000000080004156 <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004156:	711d                	add	sp,sp,-96
    80004158:	ec86                	sd	ra,88(sp)
    8000415a:	e8a2                	sd	s0,80(sp)
    8000415c:	e4a6                	sd	s1,72(sp)
    8000415e:	e0ca                	sd	s2,64(sp)
    80004160:	fc4e                	sd	s3,56(sp)
    80004162:	f852                	sd	s4,48(sp)
    80004164:	f456                	sd	s5,40(sp)
    80004166:	f05a                	sd	s6,32(sp)
    80004168:	ec5e                	sd	s7,24(sp)
    8000416a:	e862                	sd	s8,16(sp)
    8000416c:	e466                	sd	s9,8(sp)
    8000416e:	1080                	add	s0,sp,96
    80004170:	84aa                	mv	s1,a0
    80004172:	8b2e                	mv	s6,a1
    80004174:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004176:	00054703          	lbu	a4,0(a0)
    8000417a:	02f00793          	li	a5,47
    8000417e:	02f70263          	beq	a4,a5,800041a2 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004182:	ffffe097          	auipc	ra,0xffffe
    80004186:	8c8080e7          	jalr	-1848(ra) # 80001a4a <myproc>
    8000418a:	15053503          	ld	a0,336(a0)
    8000418e:	00000097          	auipc	ra,0x0
    80004192:	9f6080e7          	jalr	-1546(ra) # 80003b84 <idup>
    80004196:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004198:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000419c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000419e:	4b85                	li	s7,1
    800041a0:	a875                	j	8000425c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800041a2:	4585                	li	a1,1
    800041a4:	4505                	li	a0,1
    800041a6:	fffff097          	auipc	ra,0xfffff
    800041aa:	6e8080e7          	jalr	1768(ra) # 8000388e <iget>
    800041ae:	8a2a                	mv	s4,a0
    800041b0:	b7e5                	j	80004198 <namex+0x42>
      iunlockput(ip);
    800041b2:	8552                	mv	a0,s4
    800041b4:	00000097          	auipc	ra,0x0
    800041b8:	c70080e7          	jalr	-912(ra) # 80003e24 <iunlockput>
      return 0;
    800041bc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800041be:	8552                	mv	a0,s4
    800041c0:	60e6                	ld	ra,88(sp)
    800041c2:	6446                	ld	s0,80(sp)
    800041c4:	64a6                	ld	s1,72(sp)
    800041c6:	6906                	ld	s2,64(sp)
    800041c8:	79e2                	ld	s3,56(sp)
    800041ca:	7a42                	ld	s4,48(sp)
    800041cc:	7aa2                	ld	s5,40(sp)
    800041ce:	7b02                	ld	s6,32(sp)
    800041d0:	6be2                	ld	s7,24(sp)
    800041d2:	6c42                	ld	s8,16(sp)
    800041d4:	6ca2                	ld	s9,8(sp)
    800041d6:	6125                	add	sp,sp,96
    800041d8:	8082                	ret
      iunlock(ip);
    800041da:	8552                	mv	a0,s4
    800041dc:	00000097          	auipc	ra,0x0
    800041e0:	aa8080e7          	jalr	-1368(ra) # 80003c84 <iunlock>
      return ip;
    800041e4:	bfe9                	j	800041be <namex+0x68>
      iunlockput(ip);
    800041e6:	8552                	mv	a0,s4
    800041e8:	00000097          	auipc	ra,0x0
    800041ec:	c3c080e7          	jalr	-964(ra) # 80003e24 <iunlockput>
      return 0;
    800041f0:	8a4e                	mv	s4,s3
    800041f2:	b7f1                	j	800041be <namex+0x68>
  len = path - s;
    800041f4:	40998633          	sub	a2,s3,s1
    800041f8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800041fc:	099c5863          	bge	s8,s9,8000428c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004200:	4639                	li	a2,14
    80004202:	85a6                	mv	a1,s1
    80004204:	8556                	mv	a0,s5
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	c1e080e7          	jalr	-994(ra) # 80000e24 <memmove>
    8000420e:	84ce                	mv	s1,s3
  while(*path == '/')
    80004210:	0004c783          	lbu	a5,0(s1)
    80004214:	01279763          	bne	a5,s2,80004222 <namex+0xcc>
    path++;
    80004218:	0485                	add	s1,s1,1
  while(*path == '/')
    8000421a:	0004c783          	lbu	a5,0(s1)
    8000421e:	ff278de3          	beq	a5,s2,80004218 <namex+0xc2>
    ilock(ip);
    80004222:	8552                	mv	a0,s4
    80004224:	00000097          	auipc	ra,0x0
    80004228:	99e080e7          	jalr	-1634(ra) # 80003bc2 <ilock>
    if(ip->type != T_DIR){
    8000422c:	044a1783          	lh	a5,68(s4)
    80004230:	f97791e3          	bne	a5,s7,800041b2 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80004234:	000b0563          	beqz	s6,8000423e <namex+0xe8>
    80004238:	0004c783          	lbu	a5,0(s1)
    8000423c:	dfd9                	beqz	a5,800041da <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000423e:	4601                	li	a2,0
    80004240:	85d6                	mv	a1,s5
    80004242:	8552                	mv	a0,s4
    80004244:	00000097          	auipc	ra,0x0
    80004248:	e62080e7          	jalr	-414(ra) # 800040a6 <dirlookup>
    8000424c:	89aa                	mv	s3,a0
    8000424e:	dd41                	beqz	a0,800041e6 <namex+0x90>
    iunlockput(ip);
    80004250:	8552                	mv	a0,s4
    80004252:	00000097          	auipc	ra,0x0
    80004256:	bd2080e7          	jalr	-1070(ra) # 80003e24 <iunlockput>
    ip = next;
    8000425a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000425c:	0004c783          	lbu	a5,0(s1)
    80004260:	01279763          	bne	a5,s2,8000426e <namex+0x118>
    path++;
    80004264:	0485                	add	s1,s1,1
  while(*path == '/')
    80004266:	0004c783          	lbu	a5,0(s1)
    8000426a:	ff278de3          	beq	a5,s2,80004264 <namex+0x10e>
  if(*path == 0)
    8000426e:	cb9d                	beqz	a5,800042a4 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80004270:	0004c783          	lbu	a5,0(s1)
    80004274:	89a6                	mv	s3,s1
  len = path - s;
    80004276:	4c81                	li	s9,0
    80004278:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000427a:	01278963          	beq	a5,s2,8000428c <namex+0x136>
    8000427e:	dbbd                	beqz	a5,800041f4 <namex+0x9e>
    path++;
    80004280:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80004282:	0009c783          	lbu	a5,0(s3)
    80004286:	ff279ce3          	bne	a5,s2,8000427e <namex+0x128>
    8000428a:	b7ad                	j	800041f4 <namex+0x9e>
    memmove(name, s, len);
    8000428c:	2601                	sext.w	a2,a2
    8000428e:	85a6                	mv	a1,s1
    80004290:	8556                	mv	a0,s5
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	b92080e7          	jalr	-1134(ra) # 80000e24 <memmove>
    name[len] = 0;
    8000429a:	9cd6                	add	s9,s9,s5
    8000429c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800042a0:	84ce                	mv	s1,s3
    800042a2:	b7bd                	j	80004210 <namex+0xba>
  if(nameiparent){
    800042a4:	f00b0de3          	beqz	s6,800041be <namex+0x68>
    iput(ip);
    800042a8:	8552                	mv	a0,s4
    800042aa:	00000097          	auipc	ra,0x0
    800042ae:	ad2080e7          	jalr	-1326(ra) # 80003d7c <iput>
    return 0;
    800042b2:	4a01                	li	s4,0
    800042b4:	b729                	j	800041be <namex+0x68>

00000000800042b6 <dirlink>:
{
    800042b6:	7139                	add	sp,sp,-64
    800042b8:	fc06                	sd	ra,56(sp)
    800042ba:	f822                	sd	s0,48(sp)
    800042bc:	f426                	sd	s1,40(sp)
    800042be:	f04a                	sd	s2,32(sp)
    800042c0:	ec4e                	sd	s3,24(sp)
    800042c2:	e852                	sd	s4,16(sp)
    800042c4:	0080                	add	s0,sp,64
    800042c6:	892a                	mv	s2,a0
    800042c8:	8a2e                	mv	s4,a1
    800042ca:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800042cc:	4601                	li	a2,0
    800042ce:	00000097          	auipc	ra,0x0
    800042d2:	dd8080e7          	jalr	-552(ra) # 800040a6 <dirlookup>
    800042d6:	e93d                	bnez	a0,8000434c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042d8:	04c92483          	lw	s1,76(s2)
    800042dc:	c49d                	beqz	s1,8000430a <dirlink+0x54>
    800042de:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042e0:	4741                	li	a4,16
    800042e2:	86a6                	mv	a3,s1
    800042e4:	fc040613          	add	a2,s0,-64
    800042e8:	4581                	li	a1,0
    800042ea:	854a                	mv	a0,s2
    800042ec:	00000097          	auipc	ra,0x0
    800042f0:	b8a080e7          	jalr	-1142(ra) # 80003e76 <readi>
    800042f4:	47c1                	li	a5,16
    800042f6:	06f51163          	bne	a0,a5,80004358 <dirlink+0xa2>
    if(de.inum == 0)
    800042fa:	fc045783          	lhu	a5,-64(s0)
    800042fe:	c791                	beqz	a5,8000430a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004300:	24c1                	addw	s1,s1,16
    80004302:	04c92783          	lw	a5,76(s2)
    80004306:	fcf4ede3          	bltu	s1,a5,800042e0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000430a:	4639                	li	a2,14
    8000430c:	85d2                	mv	a1,s4
    8000430e:	fc240513          	add	a0,s0,-62
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	bc2080e7          	jalr	-1086(ra) # 80000ed4 <strncpy>
  de.inum = inum;
    8000431a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000431e:	4741                	li	a4,16
    80004320:	86a6                	mv	a3,s1
    80004322:	fc040613          	add	a2,s0,-64
    80004326:	4581                	li	a1,0
    80004328:	854a                	mv	a0,s2
    8000432a:	00000097          	auipc	ra,0x0
    8000432e:	c44080e7          	jalr	-956(ra) # 80003f6e <writei>
    80004332:	1541                	add	a0,a0,-16
    80004334:	00a03533          	snez	a0,a0
    80004338:	40a00533          	neg	a0,a0
}
    8000433c:	70e2                	ld	ra,56(sp)
    8000433e:	7442                	ld	s0,48(sp)
    80004340:	74a2                	ld	s1,40(sp)
    80004342:	7902                	ld	s2,32(sp)
    80004344:	69e2                	ld	s3,24(sp)
    80004346:	6a42                	ld	s4,16(sp)
    80004348:	6121                	add	sp,sp,64
    8000434a:	8082                	ret
    iput(ip);
    8000434c:	00000097          	auipc	ra,0x0
    80004350:	a30080e7          	jalr	-1488(ra) # 80003d7c <iput>
    return -1;
    80004354:	557d                	li	a0,-1
    80004356:	b7dd                	j	8000433c <dirlink+0x86>
      panic("dirlink read");
    80004358:	00004517          	auipc	a0,0x4
    8000435c:	30050513          	add	a0,a0,768 # 80008658 <syscalls+0x1c8>
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	4ae080e7          	jalr	1198(ra) # 8000080e <panic>

0000000080004368 <namei>:

struct inode*
namei(char *path)
{
    80004368:	1101                	add	sp,sp,-32
    8000436a:	ec06                	sd	ra,24(sp)
    8000436c:	e822                	sd	s0,16(sp)
    8000436e:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004370:	fe040613          	add	a2,s0,-32
    80004374:	4581                	li	a1,0
    80004376:	00000097          	auipc	ra,0x0
    8000437a:	de0080e7          	jalr	-544(ra) # 80004156 <namex>
}
    8000437e:	60e2                	ld	ra,24(sp)
    80004380:	6442                	ld	s0,16(sp)
    80004382:	6105                	add	sp,sp,32
    80004384:	8082                	ret

0000000080004386 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004386:	1141                	add	sp,sp,-16
    80004388:	e406                	sd	ra,8(sp)
    8000438a:	e022                	sd	s0,0(sp)
    8000438c:	0800                	add	s0,sp,16
    8000438e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004390:	4585                	li	a1,1
    80004392:	00000097          	auipc	ra,0x0
    80004396:	dc4080e7          	jalr	-572(ra) # 80004156 <namex>
}
    8000439a:	60a2                	ld	ra,8(sp)
    8000439c:	6402                	ld	s0,0(sp)
    8000439e:	0141                	add	sp,sp,16
    800043a0:	8082                	ret

00000000800043a2 <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    800043a2:	1101                	add	sp,sp,-32
    800043a4:	ec06                	sd	ra,24(sp)
    800043a6:	e822                	sd	s0,16(sp)
    800043a8:	e426                	sd	s1,8(sp)
    800043aa:	e04a                	sd	s2,0(sp)
    800043ac:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800043ae:	0001d917          	auipc	s2,0x1d
    800043b2:	cc290913          	add	s2,s2,-830 # 80021070 <log>
    800043b6:	01892583          	lw	a1,24(s2)
    800043ba:	02892503          	lw	a0,40(s2)
    800043be:	fffff097          	auipc	ra,0xfffff
    800043c2:	ff4080e7          	jalr	-12(ra) # 800033b2 <bread>
    800043c6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800043c8:	02c92603          	lw	a2,44(s2)
    800043cc:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800043ce:	00c05f63          	blez	a2,800043ec <write_head+0x4a>
    800043d2:	0001d717          	auipc	a4,0x1d
    800043d6:	cce70713          	add	a4,a4,-818 # 800210a0 <log+0x30>
    800043da:	87aa                	mv	a5,a0
    800043dc:	060a                	sll	a2,a2,0x2
    800043de:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800043e0:	4314                	lw	a3,0(a4)
    800043e2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800043e4:	0711                	add	a4,a4,4
    800043e6:	0791                	add	a5,a5,4
    800043e8:	fec79ce3          	bne	a5,a2,800043e0 <write_head+0x3e>
  }
  bwrite(buf);
    800043ec:	8526                	mv	a0,s1
    800043ee:	fffff097          	auipc	ra,0xfffff
    800043f2:	0b6080e7          	jalr	182(ra) # 800034a4 <bwrite>
  brelse(buf);
    800043f6:	8526                	mv	a0,s1
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	0ea080e7          	jalr	234(ra) # 800034e2 <brelse>
}
    80004400:	60e2                	ld	ra,24(sp)
    80004402:	6442                	ld	s0,16(sp)
    80004404:	64a2                	ld	s1,8(sp)
    80004406:	6902                	ld	s2,0(sp)
    80004408:	6105                	add	sp,sp,32
    8000440a:	8082                	ret

000000008000440c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000440c:	0001d797          	auipc	a5,0x1d
    80004410:	c907a783          	lw	a5,-880(a5) # 8002109c <log+0x2c>
    80004414:	0af05d63          	blez	a5,800044ce <install_trans+0xc2>
{
    80004418:	7139                	add	sp,sp,-64
    8000441a:	fc06                	sd	ra,56(sp)
    8000441c:	f822                	sd	s0,48(sp)
    8000441e:	f426                	sd	s1,40(sp)
    80004420:	f04a                	sd	s2,32(sp)
    80004422:	ec4e                	sd	s3,24(sp)
    80004424:	e852                	sd	s4,16(sp)
    80004426:	e456                	sd	s5,8(sp)
    80004428:	e05a                	sd	s6,0(sp)
    8000442a:	0080                	add	s0,sp,64
    8000442c:	8b2a                	mv	s6,a0
    8000442e:	0001da97          	auipc	s5,0x1d
    80004432:	c72a8a93          	add	s5,s5,-910 # 800210a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004436:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80004438:	0001d997          	auipc	s3,0x1d
    8000443c:	c3898993          	add	s3,s3,-968 # 80021070 <log>
    80004440:	a00d                	j	80004462 <install_trans+0x56>
    brelse(lbuf);
    80004442:	854a                	mv	a0,s2
    80004444:	fffff097          	auipc	ra,0xfffff
    80004448:	09e080e7          	jalr	158(ra) # 800034e2 <brelse>
    brelse(dbuf);
    8000444c:	8526                	mv	a0,s1
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	094080e7          	jalr	148(ra) # 800034e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004456:	2a05                	addw	s4,s4,1
    80004458:	0a91                	add	s5,s5,4
    8000445a:	02c9a783          	lw	a5,44(s3)
    8000445e:	04fa5e63          	bge	s4,a5,800044ba <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80004462:	0189a583          	lw	a1,24(s3)
    80004466:	014585bb          	addw	a1,a1,s4
    8000446a:	2585                	addw	a1,a1,1
    8000446c:	0289a503          	lw	a0,40(s3)
    80004470:	fffff097          	auipc	ra,0xfffff
    80004474:	f42080e7          	jalr	-190(ra) # 800033b2 <bread>
    80004478:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    8000447a:	000aa583          	lw	a1,0(s5)
    8000447e:	0289a503          	lw	a0,40(s3)
    80004482:	fffff097          	auipc	ra,0xfffff
    80004486:	f30080e7          	jalr	-208(ra) # 800033b2 <bread>
    8000448a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    8000448c:	40000613          	li	a2,1024
    80004490:	05890593          	add	a1,s2,88
    80004494:	05850513          	add	a0,a0,88
    80004498:	ffffd097          	auipc	ra,0xffffd
    8000449c:	98c080e7          	jalr	-1652(ra) # 80000e24 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    800044a0:	8526                	mv	a0,s1
    800044a2:	fffff097          	auipc	ra,0xfffff
    800044a6:	002080e7          	jalr	2(ra) # 800034a4 <bwrite>
    if(recovering == 0)
    800044aa:	f80b1ce3          	bnez	s6,80004442 <install_trans+0x36>
      bunpin(dbuf);
    800044ae:	8526                	mv	a0,s1
    800044b0:	fffff097          	auipc	ra,0xfffff
    800044b4:	10a080e7          	jalr	266(ra) # 800035ba <bunpin>
    800044b8:	b769                	j	80004442 <install_trans+0x36>
}
    800044ba:	70e2                	ld	ra,56(sp)
    800044bc:	7442                	ld	s0,48(sp)
    800044be:	74a2                	ld	s1,40(sp)
    800044c0:	7902                	ld	s2,32(sp)
    800044c2:	69e2                	ld	s3,24(sp)
    800044c4:	6a42                	ld	s4,16(sp)
    800044c6:	6aa2                	ld	s5,8(sp)
    800044c8:	6b02                	ld	s6,0(sp)
    800044ca:	6121                	add	sp,sp,64
    800044cc:	8082                	ret
    800044ce:	8082                	ret

00000000800044d0 <initlog>:
{
    800044d0:	7179                	add	sp,sp,-48
    800044d2:	f406                	sd	ra,40(sp)
    800044d4:	f022                	sd	s0,32(sp)
    800044d6:	ec26                	sd	s1,24(sp)
    800044d8:	e84a                	sd	s2,16(sp)
    800044da:	e44e                	sd	s3,8(sp)
    800044dc:	1800                	add	s0,sp,48
    800044de:	892a                	mv	s2,a0
    800044e0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800044e2:	0001d497          	auipc	s1,0x1d
    800044e6:	b8e48493          	add	s1,s1,-1138 # 80021070 <log>
    800044ea:	00004597          	auipc	a1,0x4
    800044ee:	17e58593          	add	a1,a1,382 # 80008668 <syscalls+0x1d8>
    800044f2:	8526                	mv	a0,s1
    800044f4:	ffffc097          	auipc	ra,0xffffc
    800044f8:	748080e7          	jalr	1864(ra) # 80000c3c <initlock>
  log.start = sb->logstart;
    800044fc:	0149a583          	lw	a1,20(s3)
    80004500:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004502:	0109a783          	lw	a5,16(s3)
    80004506:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004508:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000450c:	854a                	mv	a0,s2
    8000450e:	fffff097          	auipc	ra,0xfffff
    80004512:	ea4080e7          	jalr	-348(ra) # 800033b2 <bread>
  log.lh.n = lh->n;
    80004516:	4d30                	lw	a2,88(a0)
    80004518:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000451a:	00c05f63          	blez	a2,80004538 <initlog+0x68>
    8000451e:	87aa                	mv	a5,a0
    80004520:	0001d717          	auipc	a4,0x1d
    80004524:	b8070713          	add	a4,a4,-1152 # 800210a0 <log+0x30>
    80004528:	060a                	sll	a2,a2,0x2
    8000452a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000452c:	4ff4                	lw	a3,92(a5)
    8000452e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004530:	0791                	add	a5,a5,4
    80004532:	0711                	add	a4,a4,4
    80004534:	fec79ce3          	bne	a5,a2,8000452c <initlog+0x5c>
  brelse(buf);
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	faa080e7          	jalr	-86(ra) # 800034e2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    80004540:	4505                	li	a0,1
    80004542:	00000097          	auipc	ra,0x0
    80004546:	eca080e7          	jalr	-310(ra) # 8000440c <install_trans>
  log.lh.n = 0;
    8000454a:	0001d797          	auipc	a5,0x1d
    8000454e:	b407a923          	sw	zero,-1198(a5) # 8002109c <log+0x2c>
  write_head(); /* clear the log */
    80004552:	00000097          	auipc	ra,0x0
    80004556:	e50080e7          	jalr	-432(ra) # 800043a2 <write_head>
}
    8000455a:	70a2                	ld	ra,40(sp)
    8000455c:	7402                	ld	s0,32(sp)
    8000455e:	64e2                	ld	s1,24(sp)
    80004560:	6942                	ld	s2,16(sp)
    80004562:	69a2                	ld	s3,8(sp)
    80004564:	6145                	add	sp,sp,48
    80004566:	8082                	ret

0000000080004568 <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    80004568:	1101                	add	sp,sp,-32
    8000456a:	ec06                	sd	ra,24(sp)
    8000456c:	e822                	sd	s0,16(sp)
    8000456e:	e426                	sd	s1,8(sp)
    80004570:	e04a                	sd	s2,0(sp)
    80004572:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80004574:	0001d517          	auipc	a0,0x1d
    80004578:	afc50513          	add	a0,a0,-1284 # 80021070 <log>
    8000457c:	ffffc097          	auipc	ra,0xffffc
    80004580:	750080e7          	jalr	1872(ra) # 80000ccc <acquire>
  while(1){
    if(log.committing){
    80004584:	0001d497          	auipc	s1,0x1d
    80004588:	aec48493          	add	s1,s1,-1300 # 80021070 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000458c:	4979                	li	s2,30
    8000458e:	a039                	j	8000459c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004590:	85a6                	mv	a1,s1
    80004592:	8526                	mv	a0,s1
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	03c080e7          	jalr	60(ra) # 800025d0 <sleep>
    if(log.committing){
    8000459c:	50dc                	lw	a5,36(s1)
    8000459e:	fbed                	bnez	a5,80004590 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800045a0:	5098                	lw	a4,32(s1)
    800045a2:	2705                	addw	a4,a4,1
    800045a4:	0027179b          	sllw	a5,a4,0x2
    800045a8:	9fb9                	addw	a5,a5,a4
    800045aa:	0017979b          	sllw	a5,a5,0x1
    800045ae:	54d4                	lw	a3,44(s1)
    800045b0:	9fb5                	addw	a5,a5,a3
    800045b2:	00f95963          	bge	s2,a5,800045c4 <begin_op+0x5c>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    800045b6:	85a6                	mv	a1,s1
    800045b8:	8526                	mv	a0,s1
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	016080e7          	jalr	22(ra) # 800025d0 <sleep>
    800045c2:	bfe9                	j	8000459c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800045c4:	0001d517          	auipc	a0,0x1d
    800045c8:	aac50513          	add	a0,a0,-1364 # 80021070 <log>
    800045cc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800045ce:	ffffc097          	auipc	ra,0xffffc
    800045d2:	7b2080e7          	jalr	1970(ra) # 80000d80 <release>
      break;
    }
  }
}
    800045d6:	60e2                	ld	ra,24(sp)
    800045d8:	6442                	ld	s0,16(sp)
    800045da:	64a2                	ld	s1,8(sp)
    800045dc:	6902                	ld	s2,0(sp)
    800045de:	6105                	add	sp,sp,32
    800045e0:	8082                	ret

00000000800045e2 <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    800045e2:	7139                	add	sp,sp,-64
    800045e4:	fc06                	sd	ra,56(sp)
    800045e6:	f822                	sd	s0,48(sp)
    800045e8:	f426                	sd	s1,40(sp)
    800045ea:	f04a                	sd	s2,32(sp)
    800045ec:	ec4e                	sd	s3,24(sp)
    800045ee:	e852                	sd	s4,16(sp)
    800045f0:	e456                	sd	s5,8(sp)
    800045f2:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800045f4:	0001d497          	auipc	s1,0x1d
    800045f8:	a7c48493          	add	s1,s1,-1412 # 80021070 <log>
    800045fc:	8526                	mv	a0,s1
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	6ce080e7          	jalr	1742(ra) # 80000ccc <acquire>
  log.outstanding -= 1;
    80004606:	509c                	lw	a5,32(s1)
    80004608:	37fd                	addw	a5,a5,-1
    8000460a:	0007891b          	sext.w	s2,a5
    8000460e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004610:	50dc                	lw	a5,36(s1)
    80004612:	e7b9                	bnez	a5,80004660 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004614:	04091e63          	bnez	s2,80004670 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004618:	0001d497          	auipc	s1,0x1d
    8000461c:	a5848493          	add	s1,s1,-1448 # 80021070 <log>
    80004620:	4785                	li	a5,1
    80004622:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    80004624:	8526                	mv	a0,s1
    80004626:	ffffc097          	auipc	ra,0xffffc
    8000462a:	75a080e7          	jalr	1882(ra) # 80000d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000462e:	54dc                	lw	a5,44(s1)
    80004630:	06f04763          	bgtz	a5,8000469e <end_op+0xbc>
    acquire(&log.lock);
    80004634:	0001d497          	auipc	s1,0x1d
    80004638:	a3c48493          	add	s1,s1,-1476 # 80021070 <log>
    8000463c:	8526                	mv	a0,s1
    8000463e:	ffffc097          	auipc	ra,0xffffc
    80004642:	68e080e7          	jalr	1678(ra) # 80000ccc <acquire>
    log.committing = 0;
    80004646:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000464a:	8526                	mv	a0,s1
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	fe8080e7          	jalr	-24(ra) # 80002634 <wakeup>
    release(&log.lock);
    80004654:	8526                	mv	a0,s1
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	72a080e7          	jalr	1834(ra) # 80000d80 <release>
}
    8000465e:	a03d                	j	8000468c <end_op+0xaa>
    panic("log.committing");
    80004660:	00004517          	auipc	a0,0x4
    80004664:	01050513          	add	a0,a0,16 # 80008670 <syscalls+0x1e0>
    80004668:	ffffc097          	auipc	ra,0xffffc
    8000466c:	1a6080e7          	jalr	422(ra) # 8000080e <panic>
    wakeup(&log);
    80004670:	0001d497          	auipc	s1,0x1d
    80004674:	a0048493          	add	s1,s1,-1536 # 80021070 <log>
    80004678:	8526                	mv	a0,s1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	fba080e7          	jalr	-70(ra) # 80002634 <wakeup>
  release(&log.lock);
    80004682:	8526                	mv	a0,s1
    80004684:	ffffc097          	auipc	ra,0xffffc
    80004688:	6fc080e7          	jalr	1788(ra) # 80000d80 <release>
}
    8000468c:	70e2                	ld	ra,56(sp)
    8000468e:	7442                	ld	s0,48(sp)
    80004690:	74a2                	ld	s1,40(sp)
    80004692:	7902                	ld	s2,32(sp)
    80004694:	69e2                	ld	s3,24(sp)
    80004696:	6a42                	ld	s4,16(sp)
    80004698:	6aa2                	ld	s5,8(sp)
    8000469a:	6121                	add	sp,sp,64
    8000469c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000469e:	0001da97          	auipc	s5,0x1d
    800046a2:	a02a8a93          	add	s5,s5,-1534 # 800210a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    800046a6:	0001da17          	auipc	s4,0x1d
    800046aa:	9caa0a13          	add	s4,s4,-1590 # 80021070 <log>
    800046ae:	018a2583          	lw	a1,24(s4)
    800046b2:	012585bb          	addw	a1,a1,s2
    800046b6:	2585                	addw	a1,a1,1
    800046b8:	028a2503          	lw	a0,40(s4)
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	cf6080e7          	jalr	-778(ra) # 800033b2 <bread>
    800046c4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    800046c6:	000aa583          	lw	a1,0(s5)
    800046ca:	028a2503          	lw	a0,40(s4)
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	ce4080e7          	jalr	-796(ra) # 800033b2 <bread>
    800046d6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800046d8:	40000613          	li	a2,1024
    800046dc:	05850593          	add	a1,a0,88
    800046e0:	05848513          	add	a0,s1,88
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	740080e7          	jalr	1856(ra) # 80000e24 <memmove>
    bwrite(to);  /* write the log */
    800046ec:	8526                	mv	a0,s1
    800046ee:	fffff097          	auipc	ra,0xfffff
    800046f2:	db6080e7          	jalr	-586(ra) # 800034a4 <bwrite>
    brelse(from);
    800046f6:	854e                	mv	a0,s3
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	dea080e7          	jalr	-534(ra) # 800034e2 <brelse>
    brelse(to);
    80004700:	8526                	mv	a0,s1
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	de0080e7          	jalr	-544(ra) # 800034e2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000470a:	2905                	addw	s2,s2,1
    8000470c:	0a91                	add	s5,s5,4
    8000470e:	02ca2783          	lw	a5,44(s4)
    80004712:	f8f94ee3          	blt	s2,a5,800046ae <end_op+0xcc>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    80004716:	00000097          	auipc	ra,0x0
    8000471a:	c8c080e7          	jalr	-884(ra) # 800043a2 <write_head>
    install_trans(0); /* Now install writes to home locations */
    8000471e:	4501                	li	a0,0
    80004720:	00000097          	auipc	ra,0x0
    80004724:	cec080e7          	jalr	-788(ra) # 8000440c <install_trans>
    log.lh.n = 0;
    80004728:	0001d797          	auipc	a5,0x1d
    8000472c:	9607aa23          	sw	zero,-1676(a5) # 8002109c <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    80004730:	00000097          	auipc	ra,0x0
    80004734:	c72080e7          	jalr	-910(ra) # 800043a2 <write_head>
    80004738:	bdf5                	j	80004634 <end_op+0x52>

000000008000473a <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    8000473a:	1101                	add	sp,sp,-32
    8000473c:	ec06                	sd	ra,24(sp)
    8000473e:	e822                	sd	s0,16(sp)
    80004740:	e426                	sd	s1,8(sp)
    80004742:	e04a                	sd	s2,0(sp)
    80004744:	1000                	add	s0,sp,32
    80004746:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004748:	0001d917          	auipc	s2,0x1d
    8000474c:	92890913          	add	s2,s2,-1752 # 80021070 <log>
    80004750:	854a                	mv	a0,s2
    80004752:	ffffc097          	auipc	ra,0xffffc
    80004756:	57a080e7          	jalr	1402(ra) # 80000ccc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000475a:	02c92603          	lw	a2,44(s2)
    8000475e:	47f5                	li	a5,29
    80004760:	06c7c563          	blt	a5,a2,800047ca <log_write+0x90>
    80004764:	0001d797          	auipc	a5,0x1d
    80004768:	9287a783          	lw	a5,-1752(a5) # 8002108c <log+0x1c>
    8000476c:	37fd                	addw	a5,a5,-1
    8000476e:	04f65e63          	bge	a2,a5,800047ca <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004772:	0001d797          	auipc	a5,0x1d
    80004776:	91e7a783          	lw	a5,-1762(a5) # 80021090 <log+0x20>
    8000477a:	06f05063          	blez	a5,800047da <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000477e:	4781                	li	a5,0
    80004780:	06c05563          	blez	a2,800047ea <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80004784:	44cc                	lw	a1,12(s1)
    80004786:	0001d717          	auipc	a4,0x1d
    8000478a:	91a70713          	add	a4,a4,-1766 # 800210a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000478e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80004790:	4314                	lw	a3,0(a4)
    80004792:	04b68c63          	beq	a3,a1,800047ea <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004796:	2785                	addw	a5,a5,1
    80004798:	0711                	add	a4,a4,4
    8000479a:	fef61be3          	bne	a2,a5,80004790 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000479e:	0621                	add	a2,a2,8
    800047a0:	060a                	sll	a2,a2,0x2
    800047a2:	0001d797          	auipc	a5,0x1d
    800047a6:	8ce78793          	add	a5,a5,-1842 # 80021070 <log>
    800047aa:	97b2                	add	a5,a5,a2
    800047ac:	44d8                	lw	a4,12(s1)
    800047ae:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    800047b0:	8526                	mv	a0,s1
    800047b2:	fffff097          	auipc	ra,0xfffff
    800047b6:	dcc080e7          	jalr	-564(ra) # 8000357e <bpin>
    log.lh.n++;
    800047ba:	0001d717          	auipc	a4,0x1d
    800047be:	8b670713          	add	a4,a4,-1866 # 80021070 <log>
    800047c2:	575c                	lw	a5,44(a4)
    800047c4:	2785                	addw	a5,a5,1
    800047c6:	d75c                	sw	a5,44(a4)
    800047c8:	a82d                	j	80004802 <log_write+0xc8>
    panic("too big a transaction");
    800047ca:	00004517          	auipc	a0,0x4
    800047ce:	eb650513          	add	a0,a0,-330 # 80008680 <syscalls+0x1f0>
    800047d2:	ffffc097          	auipc	ra,0xffffc
    800047d6:	03c080e7          	jalr	60(ra) # 8000080e <panic>
    panic("log_write outside of trans");
    800047da:	00004517          	auipc	a0,0x4
    800047de:	ebe50513          	add	a0,a0,-322 # 80008698 <syscalls+0x208>
    800047e2:	ffffc097          	auipc	ra,0xffffc
    800047e6:	02c080e7          	jalr	44(ra) # 8000080e <panic>
  log.lh.block[i] = b->blockno;
    800047ea:	00878693          	add	a3,a5,8
    800047ee:	068a                	sll	a3,a3,0x2
    800047f0:	0001d717          	auipc	a4,0x1d
    800047f4:	88070713          	add	a4,a4,-1920 # 80021070 <log>
    800047f8:	9736                	add	a4,a4,a3
    800047fa:	44d4                	lw	a3,12(s1)
    800047fc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    800047fe:	faf609e3          	beq	a2,a5,800047b0 <log_write+0x76>
  }
  release(&log.lock);
    80004802:	0001d517          	auipc	a0,0x1d
    80004806:	86e50513          	add	a0,a0,-1938 # 80021070 <log>
    8000480a:	ffffc097          	auipc	ra,0xffffc
    8000480e:	576080e7          	jalr	1398(ra) # 80000d80 <release>
}
    80004812:	60e2                	ld	ra,24(sp)
    80004814:	6442                	ld	s0,16(sp)
    80004816:	64a2                	ld	s1,8(sp)
    80004818:	6902                	ld	s2,0(sp)
    8000481a:	6105                	add	sp,sp,32
    8000481c:	8082                	ret

000000008000481e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000481e:	1101                	add	sp,sp,-32
    80004820:	ec06                	sd	ra,24(sp)
    80004822:	e822                	sd	s0,16(sp)
    80004824:	e426                	sd	s1,8(sp)
    80004826:	e04a                	sd	s2,0(sp)
    80004828:	1000                	add	s0,sp,32
    8000482a:	84aa                	mv	s1,a0
    8000482c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000482e:	00004597          	auipc	a1,0x4
    80004832:	e8a58593          	add	a1,a1,-374 # 800086b8 <syscalls+0x228>
    80004836:	0521                	add	a0,a0,8
    80004838:	ffffc097          	auipc	ra,0xffffc
    8000483c:	404080e7          	jalr	1028(ra) # 80000c3c <initlock>
  lk->name = name;
    80004840:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004844:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004848:	0204a423          	sw	zero,40(s1)
}
    8000484c:	60e2                	ld	ra,24(sp)
    8000484e:	6442                	ld	s0,16(sp)
    80004850:	64a2                	ld	s1,8(sp)
    80004852:	6902                	ld	s2,0(sp)
    80004854:	6105                	add	sp,sp,32
    80004856:	8082                	ret

0000000080004858 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004858:	1101                	add	sp,sp,-32
    8000485a:	ec06                	sd	ra,24(sp)
    8000485c:	e822                	sd	s0,16(sp)
    8000485e:	e426                	sd	s1,8(sp)
    80004860:	e04a                	sd	s2,0(sp)
    80004862:	1000                	add	s0,sp,32
    80004864:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004866:	00850913          	add	s2,a0,8
    8000486a:	854a                	mv	a0,s2
    8000486c:	ffffc097          	auipc	ra,0xffffc
    80004870:	460080e7          	jalr	1120(ra) # 80000ccc <acquire>
  while (lk->locked) {
    80004874:	409c                	lw	a5,0(s1)
    80004876:	cb89                	beqz	a5,80004888 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004878:	85ca                	mv	a1,s2
    8000487a:	8526                	mv	a0,s1
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	d54080e7          	jalr	-684(ra) # 800025d0 <sleep>
  while (lk->locked) {
    80004884:	409c                	lw	a5,0(s1)
    80004886:	fbed                	bnez	a5,80004878 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004888:	4785                	li	a5,1
    8000488a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000488c:	ffffd097          	auipc	ra,0xffffd
    80004890:	1be080e7          	jalr	446(ra) # 80001a4a <myproc>
    80004894:	591c                	lw	a5,48(a0)
    80004896:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004898:	854a                	mv	a0,s2
    8000489a:	ffffc097          	auipc	ra,0xffffc
    8000489e:	4e6080e7          	jalr	1254(ra) # 80000d80 <release>
}
    800048a2:	60e2                	ld	ra,24(sp)
    800048a4:	6442                	ld	s0,16(sp)
    800048a6:	64a2                	ld	s1,8(sp)
    800048a8:	6902                	ld	s2,0(sp)
    800048aa:	6105                	add	sp,sp,32
    800048ac:	8082                	ret

00000000800048ae <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800048ae:	1101                	add	sp,sp,-32
    800048b0:	ec06                	sd	ra,24(sp)
    800048b2:	e822                	sd	s0,16(sp)
    800048b4:	e426                	sd	s1,8(sp)
    800048b6:	e04a                	sd	s2,0(sp)
    800048b8:	1000                	add	s0,sp,32
    800048ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048bc:	00850913          	add	s2,a0,8
    800048c0:	854a                	mv	a0,s2
    800048c2:	ffffc097          	auipc	ra,0xffffc
    800048c6:	40a080e7          	jalr	1034(ra) # 80000ccc <acquire>
  lk->locked = 0;
    800048ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048ce:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800048d2:	8526                	mv	a0,s1
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	d60080e7          	jalr	-672(ra) # 80002634 <wakeup>
  release(&lk->lk);
    800048dc:	854a                	mv	a0,s2
    800048de:	ffffc097          	auipc	ra,0xffffc
    800048e2:	4a2080e7          	jalr	1186(ra) # 80000d80 <release>
}
    800048e6:	60e2                	ld	ra,24(sp)
    800048e8:	6442                	ld	s0,16(sp)
    800048ea:	64a2                	ld	s1,8(sp)
    800048ec:	6902                	ld	s2,0(sp)
    800048ee:	6105                	add	sp,sp,32
    800048f0:	8082                	ret

00000000800048f2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800048f2:	7179                	add	sp,sp,-48
    800048f4:	f406                	sd	ra,40(sp)
    800048f6:	f022                	sd	s0,32(sp)
    800048f8:	ec26                	sd	s1,24(sp)
    800048fa:	e84a                	sd	s2,16(sp)
    800048fc:	e44e                	sd	s3,8(sp)
    800048fe:	1800                	add	s0,sp,48
    80004900:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004902:	00850913          	add	s2,a0,8
    80004906:	854a                	mv	a0,s2
    80004908:	ffffc097          	auipc	ra,0xffffc
    8000490c:	3c4080e7          	jalr	964(ra) # 80000ccc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004910:	409c                	lw	a5,0(s1)
    80004912:	ef99                	bnez	a5,80004930 <holdingsleep+0x3e>
    80004914:	4481                	li	s1,0
  release(&lk->lk);
    80004916:	854a                	mv	a0,s2
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	468080e7          	jalr	1128(ra) # 80000d80 <release>
  return r;
}
    80004920:	8526                	mv	a0,s1
    80004922:	70a2                	ld	ra,40(sp)
    80004924:	7402                	ld	s0,32(sp)
    80004926:	64e2                	ld	s1,24(sp)
    80004928:	6942                	ld	s2,16(sp)
    8000492a:	69a2                	ld	s3,8(sp)
    8000492c:	6145                	add	sp,sp,48
    8000492e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004930:	0284a983          	lw	s3,40(s1)
    80004934:	ffffd097          	auipc	ra,0xffffd
    80004938:	116080e7          	jalr	278(ra) # 80001a4a <myproc>
    8000493c:	5904                	lw	s1,48(a0)
    8000493e:	413484b3          	sub	s1,s1,s3
    80004942:	0014b493          	seqz	s1,s1
    80004946:	bfc1                	j	80004916 <holdingsleep+0x24>

0000000080004948 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004948:	1141                	add	sp,sp,-16
    8000494a:	e406                	sd	ra,8(sp)
    8000494c:	e022                	sd	s0,0(sp)
    8000494e:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004950:	00004597          	auipc	a1,0x4
    80004954:	d7858593          	add	a1,a1,-648 # 800086c8 <syscalls+0x238>
    80004958:	0001d517          	auipc	a0,0x1d
    8000495c:	86050513          	add	a0,a0,-1952 # 800211b8 <ftable>
    80004960:	ffffc097          	auipc	ra,0xffffc
    80004964:	2dc080e7          	jalr	732(ra) # 80000c3c <initlock>
}
    80004968:	60a2                	ld	ra,8(sp)
    8000496a:	6402                	ld	s0,0(sp)
    8000496c:	0141                	add	sp,sp,16
    8000496e:	8082                	ret

0000000080004970 <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    80004970:	1101                	add	sp,sp,-32
    80004972:	ec06                	sd	ra,24(sp)
    80004974:	e822                	sd	s0,16(sp)
    80004976:	e426                	sd	s1,8(sp)
    80004978:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000497a:	0001d517          	auipc	a0,0x1d
    8000497e:	83e50513          	add	a0,a0,-1986 # 800211b8 <ftable>
    80004982:	ffffc097          	auipc	ra,0xffffc
    80004986:	34a080e7          	jalr	842(ra) # 80000ccc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000498a:	0001d497          	auipc	s1,0x1d
    8000498e:	84648493          	add	s1,s1,-1978 # 800211d0 <ftable+0x18>
    80004992:	0001d717          	auipc	a4,0x1d
    80004996:	7de70713          	add	a4,a4,2014 # 80022170 <disk>
    if(f->ref == 0){
    8000499a:	40dc                	lw	a5,4(s1)
    8000499c:	cf99                	beqz	a5,800049ba <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000499e:	02848493          	add	s1,s1,40
    800049a2:	fee49ce3          	bne	s1,a4,8000499a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800049a6:	0001d517          	auipc	a0,0x1d
    800049aa:	81250513          	add	a0,a0,-2030 # 800211b8 <ftable>
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	3d2080e7          	jalr	978(ra) # 80000d80 <release>
  return 0;
    800049b6:	4481                	li	s1,0
    800049b8:	a819                	j	800049ce <filealloc+0x5e>
      f->ref = 1;
    800049ba:	4785                	li	a5,1
    800049bc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049be:	0001c517          	auipc	a0,0x1c
    800049c2:	7fa50513          	add	a0,a0,2042 # 800211b8 <ftable>
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	3ba080e7          	jalr	954(ra) # 80000d80 <release>
}
    800049ce:	8526                	mv	a0,s1
    800049d0:	60e2                	ld	ra,24(sp)
    800049d2:	6442                	ld	s0,16(sp)
    800049d4:	64a2                	ld	s1,8(sp)
    800049d6:	6105                	add	sp,sp,32
    800049d8:	8082                	ret

00000000800049da <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    800049da:	1101                	add	sp,sp,-32
    800049dc:	ec06                	sd	ra,24(sp)
    800049de:	e822                	sd	s0,16(sp)
    800049e0:	e426                	sd	s1,8(sp)
    800049e2:	1000                	add	s0,sp,32
    800049e4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800049e6:	0001c517          	auipc	a0,0x1c
    800049ea:	7d250513          	add	a0,a0,2002 # 800211b8 <ftable>
    800049ee:	ffffc097          	auipc	ra,0xffffc
    800049f2:	2de080e7          	jalr	734(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    800049f6:	40dc                	lw	a5,4(s1)
    800049f8:	02f05263          	blez	a5,80004a1c <filedup+0x42>
    panic("filedup");
  f->ref++;
    800049fc:	2785                	addw	a5,a5,1
    800049fe:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a00:	0001c517          	auipc	a0,0x1c
    80004a04:	7b850513          	add	a0,a0,1976 # 800211b8 <ftable>
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	378080e7          	jalr	888(ra) # 80000d80 <release>
  return f;
}
    80004a10:	8526                	mv	a0,s1
    80004a12:	60e2                	ld	ra,24(sp)
    80004a14:	6442                	ld	s0,16(sp)
    80004a16:	64a2                	ld	s1,8(sp)
    80004a18:	6105                	add	sp,sp,32
    80004a1a:	8082                	ret
    panic("filedup");
    80004a1c:	00004517          	auipc	a0,0x4
    80004a20:	cb450513          	add	a0,a0,-844 # 800086d0 <syscalls+0x240>
    80004a24:	ffffc097          	auipc	ra,0xffffc
    80004a28:	dea080e7          	jalr	-534(ra) # 8000080e <panic>

0000000080004a2c <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    80004a2c:	7139                	add	sp,sp,-64
    80004a2e:	fc06                	sd	ra,56(sp)
    80004a30:	f822                	sd	s0,48(sp)
    80004a32:	f426                	sd	s1,40(sp)
    80004a34:	f04a                	sd	s2,32(sp)
    80004a36:	ec4e                	sd	s3,24(sp)
    80004a38:	e852                	sd	s4,16(sp)
    80004a3a:	e456                	sd	s5,8(sp)
    80004a3c:	0080                	add	s0,sp,64
    80004a3e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a40:	0001c517          	auipc	a0,0x1c
    80004a44:	77850513          	add	a0,a0,1912 # 800211b8 <ftable>
    80004a48:	ffffc097          	auipc	ra,0xffffc
    80004a4c:	284080e7          	jalr	644(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    80004a50:	40dc                	lw	a5,4(s1)
    80004a52:	06f05163          	blez	a5,80004ab4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004a56:	37fd                	addw	a5,a5,-1
    80004a58:	0007871b          	sext.w	a4,a5
    80004a5c:	c0dc                	sw	a5,4(s1)
    80004a5e:	06e04363          	bgtz	a4,80004ac4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a62:	0004a903          	lw	s2,0(s1)
    80004a66:	0094ca83          	lbu	s5,9(s1)
    80004a6a:	0104ba03          	ld	s4,16(s1)
    80004a6e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004a72:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004a76:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004a7a:	0001c517          	auipc	a0,0x1c
    80004a7e:	73e50513          	add	a0,a0,1854 # 800211b8 <ftable>
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	2fe080e7          	jalr	766(ra) # 80000d80 <release>

  if(ff.type == FD_PIPE){
    80004a8a:	4785                	li	a5,1
    80004a8c:	04f90d63          	beq	s2,a5,80004ae6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004a90:	3979                	addw	s2,s2,-2
    80004a92:	4785                	li	a5,1
    80004a94:	0527e063          	bltu	a5,s2,80004ad4 <fileclose+0xa8>
    begin_op();
    80004a98:	00000097          	auipc	ra,0x0
    80004a9c:	ad0080e7          	jalr	-1328(ra) # 80004568 <begin_op>
    iput(ff.ip);
    80004aa0:	854e                	mv	a0,s3
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	2da080e7          	jalr	730(ra) # 80003d7c <iput>
    end_op();
    80004aaa:	00000097          	auipc	ra,0x0
    80004aae:	b38080e7          	jalr	-1224(ra) # 800045e2 <end_op>
    80004ab2:	a00d                	j	80004ad4 <fileclose+0xa8>
    panic("fileclose");
    80004ab4:	00004517          	auipc	a0,0x4
    80004ab8:	c2450513          	add	a0,a0,-988 # 800086d8 <syscalls+0x248>
    80004abc:	ffffc097          	auipc	ra,0xffffc
    80004ac0:	d52080e7          	jalr	-686(ra) # 8000080e <panic>
    release(&ftable.lock);
    80004ac4:	0001c517          	auipc	a0,0x1c
    80004ac8:	6f450513          	add	a0,a0,1780 # 800211b8 <ftable>
    80004acc:	ffffc097          	auipc	ra,0xffffc
    80004ad0:	2b4080e7          	jalr	692(ra) # 80000d80 <release>
  }
}
    80004ad4:	70e2                	ld	ra,56(sp)
    80004ad6:	7442                	ld	s0,48(sp)
    80004ad8:	74a2                	ld	s1,40(sp)
    80004ada:	7902                	ld	s2,32(sp)
    80004adc:	69e2                	ld	s3,24(sp)
    80004ade:	6a42                	ld	s4,16(sp)
    80004ae0:	6aa2                	ld	s5,8(sp)
    80004ae2:	6121                	add	sp,sp,64
    80004ae4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ae6:	85d6                	mv	a1,s5
    80004ae8:	8552                	mv	a0,s4
    80004aea:	00000097          	auipc	ra,0x0
    80004aee:	348080e7          	jalr	840(ra) # 80004e32 <pipeclose>
    80004af2:	b7cd                	j	80004ad4 <fileclose+0xa8>

0000000080004af4 <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    80004af4:	715d                	add	sp,sp,-80
    80004af6:	e486                	sd	ra,72(sp)
    80004af8:	e0a2                	sd	s0,64(sp)
    80004afa:	fc26                	sd	s1,56(sp)
    80004afc:	f84a                	sd	s2,48(sp)
    80004afe:	f44e                	sd	s3,40(sp)
    80004b00:	0880                	add	s0,sp,80
    80004b02:	84aa                	mv	s1,a0
    80004b04:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b06:	ffffd097          	auipc	ra,0xffffd
    80004b0a:	f44080e7          	jalr	-188(ra) # 80001a4a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004b0e:	409c                	lw	a5,0(s1)
    80004b10:	37f9                	addw	a5,a5,-2
    80004b12:	4705                	li	a4,1
    80004b14:	04f76763          	bltu	a4,a5,80004b62 <filestat+0x6e>
    80004b18:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b1a:	6c88                	ld	a0,24(s1)
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	0a6080e7          	jalr	166(ra) # 80003bc2 <ilock>
    stati(f->ip, &st);
    80004b24:	fb840593          	add	a1,s0,-72
    80004b28:	6c88                	ld	a0,24(s1)
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	322080e7          	jalr	802(ra) # 80003e4c <stati>
    iunlock(f->ip);
    80004b32:	6c88                	ld	a0,24(s1)
    80004b34:	fffff097          	auipc	ra,0xfffff
    80004b38:	150080e7          	jalr	336(ra) # 80003c84 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b3c:	46e1                	li	a3,24
    80004b3e:	fb840613          	add	a2,s0,-72
    80004b42:	85ce                	mv	a1,s3
    80004b44:	05093503          	ld	a0,80(s2)
    80004b48:	ffffd097          	auipc	ra,0xffffd
    80004b4c:	c3c080e7          	jalr	-964(ra) # 80001784 <copyout>
    80004b50:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004b54:	60a6                	ld	ra,72(sp)
    80004b56:	6406                	ld	s0,64(sp)
    80004b58:	74e2                	ld	s1,56(sp)
    80004b5a:	7942                	ld	s2,48(sp)
    80004b5c:	79a2                	ld	s3,40(sp)
    80004b5e:	6161                	add	sp,sp,80
    80004b60:	8082                	ret
  return -1;
    80004b62:	557d                	li	a0,-1
    80004b64:	bfc5                	j	80004b54 <filestat+0x60>

0000000080004b66 <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b66:	7179                	add	sp,sp,-48
    80004b68:	f406                	sd	ra,40(sp)
    80004b6a:	f022                	sd	s0,32(sp)
    80004b6c:	ec26                	sd	s1,24(sp)
    80004b6e:	e84a                	sd	s2,16(sp)
    80004b70:	e44e                	sd	s3,8(sp)
    80004b72:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004b74:	00854783          	lbu	a5,8(a0)
    80004b78:	c3d5                	beqz	a5,80004c1c <fileread+0xb6>
    80004b7a:	84aa                	mv	s1,a0
    80004b7c:	89ae                	mv	s3,a1
    80004b7e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b80:	411c                	lw	a5,0(a0)
    80004b82:	4705                	li	a4,1
    80004b84:	04e78963          	beq	a5,a4,80004bd6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b88:	470d                	li	a4,3
    80004b8a:	04e78d63          	beq	a5,a4,80004be4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b8e:	4709                	li	a4,2
    80004b90:	06e79e63          	bne	a5,a4,80004c0c <fileread+0xa6>
    ilock(f->ip);
    80004b94:	6d08                	ld	a0,24(a0)
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	02c080e7          	jalr	44(ra) # 80003bc2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004b9e:	874a                	mv	a4,s2
    80004ba0:	5094                	lw	a3,32(s1)
    80004ba2:	864e                	mv	a2,s3
    80004ba4:	4585                	li	a1,1
    80004ba6:	6c88                	ld	a0,24(s1)
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	2ce080e7          	jalr	718(ra) # 80003e76 <readi>
    80004bb0:	892a                	mv	s2,a0
    80004bb2:	00a05563          	blez	a0,80004bbc <fileread+0x56>
      f->off += r;
    80004bb6:	509c                	lw	a5,32(s1)
    80004bb8:	9fa9                	addw	a5,a5,a0
    80004bba:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004bbc:	6c88                	ld	a0,24(s1)
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	0c6080e7          	jalr	198(ra) # 80003c84 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004bc6:	854a                	mv	a0,s2
    80004bc8:	70a2                	ld	ra,40(sp)
    80004bca:	7402                	ld	s0,32(sp)
    80004bcc:	64e2                	ld	s1,24(sp)
    80004bce:	6942                	ld	s2,16(sp)
    80004bd0:	69a2                	ld	s3,8(sp)
    80004bd2:	6145                	add	sp,sp,48
    80004bd4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004bd6:	6908                	ld	a0,16(a0)
    80004bd8:	00000097          	auipc	ra,0x0
    80004bdc:	3c2080e7          	jalr	962(ra) # 80004f9a <piperead>
    80004be0:	892a                	mv	s2,a0
    80004be2:	b7d5                	j	80004bc6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004be4:	02451783          	lh	a5,36(a0)
    80004be8:	03079693          	sll	a3,a5,0x30
    80004bec:	92c1                	srl	a3,a3,0x30
    80004bee:	4725                	li	a4,9
    80004bf0:	02d76863          	bltu	a4,a3,80004c20 <fileread+0xba>
    80004bf4:	0792                	sll	a5,a5,0x4
    80004bf6:	0001c717          	auipc	a4,0x1c
    80004bfa:	52270713          	add	a4,a4,1314 # 80021118 <devsw>
    80004bfe:	97ba                	add	a5,a5,a4
    80004c00:	639c                	ld	a5,0(a5)
    80004c02:	c38d                	beqz	a5,80004c24 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004c04:	4505                	li	a0,1
    80004c06:	9782                	jalr	a5
    80004c08:	892a                	mv	s2,a0
    80004c0a:	bf75                	j	80004bc6 <fileread+0x60>
    panic("fileread");
    80004c0c:	00004517          	auipc	a0,0x4
    80004c10:	adc50513          	add	a0,a0,-1316 # 800086e8 <syscalls+0x258>
    80004c14:	ffffc097          	auipc	ra,0xffffc
    80004c18:	bfa080e7          	jalr	-1030(ra) # 8000080e <panic>
    return -1;
    80004c1c:	597d                	li	s2,-1
    80004c1e:	b765                	j	80004bc6 <fileread+0x60>
      return -1;
    80004c20:	597d                	li	s2,-1
    80004c22:	b755                	j	80004bc6 <fileread+0x60>
    80004c24:	597d                	li	s2,-1
    80004c26:	b745                	j	80004bc6 <fileread+0x60>

0000000080004c28 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004c28:	00954783          	lbu	a5,9(a0)
    80004c2c:	10078e63          	beqz	a5,80004d48 <filewrite+0x120>
{
    80004c30:	715d                	add	sp,sp,-80
    80004c32:	e486                	sd	ra,72(sp)
    80004c34:	e0a2                	sd	s0,64(sp)
    80004c36:	fc26                	sd	s1,56(sp)
    80004c38:	f84a                	sd	s2,48(sp)
    80004c3a:	f44e                	sd	s3,40(sp)
    80004c3c:	f052                	sd	s4,32(sp)
    80004c3e:	ec56                	sd	s5,24(sp)
    80004c40:	e85a                	sd	s6,16(sp)
    80004c42:	e45e                	sd	s7,8(sp)
    80004c44:	e062                	sd	s8,0(sp)
    80004c46:	0880                	add	s0,sp,80
    80004c48:	892a                	mv	s2,a0
    80004c4a:	8b2e                	mv	s6,a1
    80004c4c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c4e:	411c                	lw	a5,0(a0)
    80004c50:	4705                	li	a4,1
    80004c52:	02e78263          	beq	a5,a4,80004c76 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c56:	470d                	li	a4,3
    80004c58:	02e78563          	beq	a5,a4,80004c82 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c5c:	4709                	li	a4,2
    80004c5e:	0ce79d63          	bne	a5,a4,80004d38 <filewrite+0x110>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c62:	0ac05b63          	blez	a2,80004d18 <filewrite+0xf0>
    int i = 0;
    80004c66:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004c68:	6b85                	lui	s7,0x1
    80004c6a:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004c6e:	6c05                	lui	s8,0x1
    80004c70:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004c74:	a851                	j	80004d08 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004c76:	6908                	ld	a0,16(a0)
    80004c78:	00000097          	auipc	ra,0x0
    80004c7c:	22a080e7          	jalr	554(ra) # 80004ea2 <pipewrite>
    80004c80:	a045                	j	80004d20 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c82:	02451783          	lh	a5,36(a0)
    80004c86:	03079693          	sll	a3,a5,0x30
    80004c8a:	92c1                	srl	a3,a3,0x30
    80004c8c:	4725                	li	a4,9
    80004c8e:	0ad76f63          	bltu	a4,a3,80004d4c <filewrite+0x124>
    80004c92:	0792                	sll	a5,a5,0x4
    80004c94:	0001c717          	auipc	a4,0x1c
    80004c98:	48470713          	add	a4,a4,1156 # 80021118 <devsw>
    80004c9c:	97ba                	add	a5,a5,a4
    80004c9e:	679c                	ld	a5,8(a5)
    80004ca0:	cbc5                	beqz	a5,80004d50 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004ca2:	4505                	li	a0,1
    80004ca4:	9782                	jalr	a5
    80004ca6:	a8ad                	j	80004d20 <filewrite+0xf8>
      if(n1 > max)
    80004ca8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	8bc080e7          	jalr	-1860(ra) # 80004568 <begin_op>
      ilock(f->ip);
    80004cb4:	01893503          	ld	a0,24(s2)
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	f0a080e7          	jalr	-246(ra) # 80003bc2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004cc0:	8756                	mv	a4,s5
    80004cc2:	02092683          	lw	a3,32(s2)
    80004cc6:	01698633          	add	a2,s3,s6
    80004cca:	4585                	li	a1,1
    80004ccc:	01893503          	ld	a0,24(s2)
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	29e080e7          	jalr	670(ra) # 80003f6e <writei>
    80004cd8:	84aa                	mv	s1,a0
    80004cda:	00a05763          	blez	a0,80004ce8 <filewrite+0xc0>
        f->off += r;
    80004cde:	02092783          	lw	a5,32(s2)
    80004ce2:	9fa9                	addw	a5,a5,a0
    80004ce4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004ce8:	01893503          	ld	a0,24(s2)
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	f98080e7          	jalr	-104(ra) # 80003c84 <iunlock>
      end_op();
    80004cf4:	00000097          	auipc	ra,0x0
    80004cf8:	8ee080e7          	jalr	-1810(ra) # 800045e2 <end_op>

      if(r != n1){
    80004cfc:	009a9f63          	bne	s5,s1,80004d1a <filewrite+0xf2>
        /* error from writei */
        break;
      }
      i += r;
    80004d00:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004d04:	0149db63          	bge	s3,s4,80004d1a <filewrite+0xf2>
      int n1 = n - i;
    80004d08:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004d0c:	0004879b          	sext.w	a5,s1
    80004d10:	f8fbdce3          	bge	s7,a5,80004ca8 <filewrite+0x80>
    80004d14:	84e2                	mv	s1,s8
    80004d16:	bf49                	j	80004ca8 <filewrite+0x80>
    int i = 0;
    80004d18:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004d1a:	033a1d63          	bne	s4,s3,80004d54 <filewrite+0x12c>
    80004d1e:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d20:	60a6                	ld	ra,72(sp)
    80004d22:	6406                	ld	s0,64(sp)
    80004d24:	74e2                	ld	s1,56(sp)
    80004d26:	7942                	ld	s2,48(sp)
    80004d28:	79a2                	ld	s3,40(sp)
    80004d2a:	7a02                	ld	s4,32(sp)
    80004d2c:	6ae2                	ld	s5,24(sp)
    80004d2e:	6b42                	ld	s6,16(sp)
    80004d30:	6ba2                	ld	s7,8(sp)
    80004d32:	6c02                	ld	s8,0(sp)
    80004d34:	6161                	add	sp,sp,80
    80004d36:	8082                	ret
    panic("filewrite");
    80004d38:	00004517          	auipc	a0,0x4
    80004d3c:	9c050513          	add	a0,a0,-1600 # 800086f8 <syscalls+0x268>
    80004d40:	ffffc097          	auipc	ra,0xffffc
    80004d44:	ace080e7          	jalr	-1330(ra) # 8000080e <panic>
    return -1;
    80004d48:	557d                	li	a0,-1
}
    80004d4a:	8082                	ret
      return -1;
    80004d4c:	557d                	li	a0,-1
    80004d4e:	bfc9                	j	80004d20 <filewrite+0xf8>
    80004d50:	557d                	li	a0,-1
    80004d52:	b7f9                	j	80004d20 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80004d54:	557d                	li	a0,-1
    80004d56:	b7e9                	j	80004d20 <filewrite+0xf8>

0000000080004d58 <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d58:	7179                	add	sp,sp,-48
    80004d5a:	f406                	sd	ra,40(sp)
    80004d5c:	f022                	sd	s0,32(sp)
    80004d5e:	ec26                	sd	s1,24(sp)
    80004d60:	e84a                	sd	s2,16(sp)
    80004d62:	e44e                	sd	s3,8(sp)
    80004d64:	e052                	sd	s4,0(sp)
    80004d66:	1800                	add	s0,sp,48
    80004d68:	84aa                	mv	s1,a0
    80004d6a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d6c:	0005b023          	sd	zero,0(a1)
    80004d70:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004d74:	00000097          	auipc	ra,0x0
    80004d78:	bfc080e7          	jalr	-1028(ra) # 80004970 <filealloc>
    80004d7c:	e088                	sd	a0,0(s1)
    80004d7e:	c551                	beqz	a0,80004e0a <pipealloc+0xb2>
    80004d80:	00000097          	auipc	ra,0x0
    80004d84:	bf0080e7          	jalr	-1040(ra) # 80004970 <filealloc>
    80004d88:	00aa3023          	sd	a0,0(s4)
    80004d8c:	c92d                	beqz	a0,80004dfe <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d8e:	ffffc097          	auipc	ra,0xffffc
    80004d92:	e4e080e7          	jalr	-434(ra) # 80000bdc <kalloc>
    80004d96:	892a                	mv	s2,a0
    80004d98:	c125                	beqz	a0,80004df8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004d9a:	4985                	li	s3,1
    80004d9c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004da0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004da4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004da8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004dac:	00004597          	auipc	a1,0x4
    80004db0:	95c58593          	add	a1,a1,-1700 # 80008708 <syscalls+0x278>
    80004db4:	ffffc097          	auipc	ra,0xffffc
    80004db8:	e88080e7          	jalr	-376(ra) # 80000c3c <initlock>
  (*f0)->type = FD_PIPE;
    80004dbc:	609c                	ld	a5,0(s1)
    80004dbe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004dc2:	609c                	ld	a5,0(s1)
    80004dc4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004dc8:	609c                	ld	a5,0(s1)
    80004dca:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004dce:	609c                	ld	a5,0(s1)
    80004dd0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004dd4:	000a3783          	ld	a5,0(s4)
    80004dd8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004ddc:	000a3783          	ld	a5,0(s4)
    80004de0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004de4:	000a3783          	ld	a5,0(s4)
    80004de8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004dec:	000a3783          	ld	a5,0(s4)
    80004df0:	0127b823          	sd	s2,16(a5)
  return 0;
    80004df4:	4501                	li	a0,0
    80004df6:	a025                	j	80004e1e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004df8:	6088                	ld	a0,0(s1)
    80004dfa:	e501                	bnez	a0,80004e02 <pipealloc+0xaa>
    80004dfc:	a039                	j	80004e0a <pipealloc+0xb2>
    80004dfe:	6088                	ld	a0,0(s1)
    80004e00:	c51d                	beqz	a0,80004e2e <pipealloc+0xd6>
    fileclose(*f0);
    80004e02:	00000097          	auipc	ra,0x0
    80004e06:	c2a080e7          	jalr	-982(ra) # 80004a2c <fileclose>
  if(*f1)
    80004e0a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004e0e:	557d                	li	a0,-1
  if(*f1)
    80004e10:	c799                	beqz	a5,80004e1e <pipealloc+0xc6>
    fileclose(*f1);
    80004e12:	853e                	mv	a0,a5
    80004e14:	00000097          	auipc	ra,0x0
    80004e18:	c18080e7          	jalr	-1000(ra) # 80004a2c <fileclose>
  return -1;
    80004e1c:	557d                	li	a0,-1
}
    80004e1e:	70a2                	ld	ra,40(sp)
    80004e20:	7402                	ld	s0,32(sp)
    80004e22:	64e2                	ld	s1,24(sp)
    80004e24:	6942                	ld	s2,16(sp)
    80004e26:	69a2                	ld	s3,8(sp)
    80004e28:	6a02                	ld	s4,0(sp)
    80004e2a:	6145                	add	sp,sp,48
    80004e2c:	8082                	ret
  return -1;
    80004e2e:	557d                	li	a0,-1
    80004e30:	b7fd                	j	80004e1e <pipealloc+0xc6>

0000000080004e32 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e32:	1101                	add	sp,sp,-32
    80004e34:	ec06                	sd	ra,24(sp)
    80004e36:	e822                	sd	s0,16(sp)
    80004e38:	e426                	sd	s1,8(sp)
    80004e3a:	e04a                	sd	s2,0(sp)
    80004e3c:	1000                	add	s0,sp,32
    80004e3e:	84aa                	mv	s1,a0
    80004e40:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e42:	ffffc097          	auipc	ra,0xffffc
    80004e46:	e8a080e7          	jalr	-374(ra) # 80000ccc <acquire>
  if(writable){
    80004e4a:	02090d63          	beqz	s2,80004e84 <pipeclose+0x52>
    pi->writeopen = 0;
    80004e4e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e52:	21848513          	add	a0,s1,536
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	7de080e7          	jalr	2014(ra) # 80002634 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e5e:	2204b783          	ld	a5,544(s1)
    80004e62:	eb95                	bnez	a5,80004e96 <pipeclose+0x64>
    release(&pi->lock);
    80004e64:	8526                	mv	a0,s1
    80004e66:	ffffc097          	auipc	ra,0xffffc
    80004e6a:	f1a080e7          	jalr	-230(ra) # 80000d80 <release>
    kfree((char*)pi);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	ffffc097          	auipc	ra,0xffffc
    80004e74:	c6e080e7          	jalr	-914(ra) # 80000ade <kfree>
  } else
    release(&pi->lock);
}
    80004e78:	60e2                	ld	ra,24(sp)
    80004e7a:	6442                	ld	s0,16(sp)
    80004e7c:	64a2                	ld	s1,8(sp)
    80004e7e:	6902                	ld	s2,0(sp)
    80004e80:	6105                	add	sp,sp,32
    80004e82:	8082                	ret
    pi->readopen = 0;
    80004e84:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004e88:	21c48513          	add	a0,s1,540
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	7a8080e7          	jalr	1960(ra) # 80002634 <wakeup>
    80004e94:	b7e9                	j	80004e5e <pipeclose+0x2c>
    release(&pi->lock);
    80004e96:	8526                	mv	a0,s1
    80004e98:	ffffc097          	auipc	ra,0xffffc
    80004e9c:	ee8080e7          	jalr	-280(ra) # 80000d80 <release>
}
    80004ea0:	bfe1                	j	80004e78 <pipeclose+0x46>

0000000080004ea2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ea2:	711d                	add	sp,sp,-96
    80004ea4:	ec86                	sd	ra,88(sp)
    80004ea6:	e8a2                	sd	s0,80(sp)
    80004ea8:	e4a6                	sd	s1,72(sp)
    80004eaa:	e0ca                	sd	s2,64(sp)
    80004eac:	fc4e                	sd	s3,56(sp)
    80004eae:	f852                	sd	s4,48(sp)
    80004eb0:	f456                	sd	s5,40(sp)
    80004eb2:	f05a                	sd	s6,32(sp)
    80004eb4:	ec5e                	sd	s7,24(sp)
    80004eb6:	e862                	sd	s8,16(sp)
    80004eb8:	1080                	add	s0,sp,96
    80004eba:	84aa                	mv	s1,a0
    80004ebc:	8aae                	mv	s5,a1
    80004ebe:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	b8a080e7          	jalr	-1142(ra) # 80001a4a <myproc>
    80004ec8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004eca:	8526                	mv	a0,s1
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	e00080e7          	jalr	-512(ra) # 80000ccc <acquire>
  while(i < n){
    80004ed4:	0b405663          	blez	s4,80004f80 <pipewrite+0xde>
  int i = 0;
    80004ed8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004eda:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004edc:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ee0:	21c48b93          	add	s7,s1,540
    80004ee4:	a089                	j	80004f26 <pipewrite+0x84>
      release(&pi->lock);
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	ffffc097          	auipc	ra,0xffffc
    80004eec:	e98080e7          	jalr	-360(ra) # 80000d80 <release>
      return -1;
    80004ef0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004ef2:	854a                	mv	a0,s2
    80004ef4:	60e6                	ld	ra,88(sp)
    80004ef6:	6446                	ld	s0,80(sp)
    80004ef8:	64a6                	ld	s1,72(sp)
    80004efa:	6906                	ld	s2,64(sp)
    80004efc:	79e2                	ld	s3,56(sp)
    80004efe:	7a42                	ld	s4,48(sp)
    80004f00:	7aa2                	ld	s5,40(sp)
    80004f02:	7b02                	ld	s6,32(sp)
    80004f04:	6be2                	ld	s7,24(sp)
    80004f06:	6c42                	ld	s8,16(sp)
    80004f08:	6125                	add	sp,sp,96
    80004f0a:	8082                	ret
      wakeup(&pi->nread);
    80004f0c:	8562                	mv	a0,s8
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	726080e7          	jalr	1830(ra) # 80002634 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004f16:	85a6                	mv	a1,s1
    80004f18:	855e                	mv	a0,s7
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	6b6080e7          	jalr	1718(ra) # 800025d0 <sleep>
  while(i < n){
    80004f22:	07495063          	bge	s2,s4,80004f82 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004f26:	2204a783          	lw	a5,544(s1)
    80004f2a:	dfd5                	beqz	a5,80004ee6 <pipewrite+0x44>
    80004f2c:	854e                	mv	a0,s3
    80004f2e:	ffffe097          	auipc	ra,0xffffe
    80004f32:	97a080e7          	jalr	-1670(ra) # 800028a8 <killed>
    80004f36:	f945                	bnez	a0,80004ee6 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    80004f38:	2184a783          	lw	a5,536(s1)
    80004f3c:	21c4a703          	lw	a4,540(s1)
    80004f40:	2007879b          	addw	a5,a5,512
    80004f44:	fcf704e3          	beq	a4,a5,80004f0c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f48:	4685                	li	a3,1
    80004f4a:	01590633          	add	a2,s2,s5
    80004f4e:	faf40593          	add	a1,s0,-81
    80004f52:	0509b503          	ld	a0,80(s3)
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	8ee080e7          	jalr	-1810(ra) # 80001844 <copyin>
    80004f5e:	03650263          	beq	a0,s6,80004f82 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f62:	21c4a783          	lw	a5,540(s1)
    80004f66:	0017871b          	addw	a4,a5,1
    80004f6a:	20e4ae23          	sw	a4,540(s1)
    80004f6e:	1ff7f793          	and	a5,a5,511
    80004f72:	97a6                	add	a5,a5,s1
    80004f74:	faf44703          	lbu	a4,-81(s0)
    80004f78:	00e78c23          	sb	a4,24(a5)
      i++;
    80004f7c:	2905                	addw	s2,s2,1
    80004f7e:	b755                	j	80004f22 <pipewrite+0x80>
  int i = 0;
    80004f80:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004f82:	21848513          	add	a0,s1,536
    80004f86:	ffffd097          	auipc	ra,0xffffd
    80004f8a:	6ae080e7          	jalr	1710(ra) # 80002634 <wakeup>
  release(&pi->lock);
    80004f8e:	8526                	mv	a0,s1
    80004f90:	ffffc097          	auipc	ra,0xffffc
    80004f94:	df0080e7          	jalr	-528(ra) # 80000d80 <release>
  return i;
    80004f98:	bfa9                	j	80004ef2 <pipewrite+0x50>

0000000080004f9a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f9a:	715d                	add	sp,sp,-80
    80004f9c:	e486                	sd	ra,72(sp)
    80004f9e:	e0a2                	sd	s0,64(sp)
    80004fa0:	fc26                	sd	s1,56(sp)
    80004fa2:	f84a                	sd	s2,48(sp)
    80004fa4:	f44e                	sd	s3,40(sp)
    80004fa6:	f052                	sd	s4,32(sp)
    80004fa8:	ec56                	sd	s5,24(sp)
    80004faa:	e85a                	sd	s6,16(sp)
    80004fac:	0880                	add	s0,sp,80
    80004fae:	84aa                	mv	s1,a0
    80004fb0:	892e                	mv	s2,a1
    80004fb2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	a96080e7          	jalr	-1386(ra) # 80001a4a <myproc>
    80004fbc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004fbe:	8526                	mv	a0,s1
    80004fc0:	ffffc097          	auipc	ra,0xffffc
    80004fc4:	d0c080e7          	jalr	-756(ra) # 80000ccc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004fc8:	2184a703          	lw	a4,536(s1)
    80004fcc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004fd0:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004fd4:	02f71763          	bne	a4,a5,80005002 <piperead+0x68>
    80004fd8:	2244a783          	lw	a5,548(s1)
    80004fdc:	c39d                	beqz	a5,80005002 <piperead+0x68>
    if(killed(pr)){
    80004fde:	8552                	mv	a0,s4
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	8c8080e7          	jalr	-1848(ra) # 800028a8 <killed>
    80004fe8:	e949                	bnez	a0,8000507a <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004fea:	85a6                	mv	a1,s1
    80004fec:	854e                	mv	a0,s3
    80004fee:	ffffd097          	auipc	ra,0xffffd
    80004ff2:	5e2080e7          	jalr	1506(ra) # 800025d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004ff6:	2184a703          	lw	a4,536(s1)
    80004ffa:	21c4a783          	lw	a5,540(s1)
    80004ffe:	fcf70de3          	beq	a4,a5,80004fd8 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80005002:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005004:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80005006:	05505463          	blez	s5,8000504e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000500a:	2184a783          	lw	a5,536(s1)
    8000500e:	21c4a703          	lw	a4,540(s1)
    80005012:	02f70e63          	beq	a4,a5,8000504e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005016:	0017871b          	addw	a4,a5,1
    8000501a:	20e4ac23          	sw	a4,536(s1)
    8000501e:	1ff7f793          	and	a5,a5,511
    80005022:	97a6                	add	a5,a5,s1
    80005024:	0187c783          	lbu	a5,24(a5)
    80005028:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000502c:	4685                	li	a3,1
    8000502e:	fbf40613          	add	a2,s0,-65
    80005032:	85ca                	mv	a1,s2
    80005034:	050a3503          	ld	a0,80(s4)
    80005038:	ffffc097          	auipc	ra,0xffffc
    8000503c:	74c080e7          	jalr	1868(ra) # 80001784 <copyout>
    80005040:	01650763          	beq	a0,s6,8000504e <piperead+0xb4>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80005044:	2985                	addw	s3,s3,1
    80005046:	0905                	add	s2,s2,1
    80005048:	fd3a91e3          	bne	s5,s3,8000500a <piperead+0x70>
    8000504c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    8000504e:	21c48513          	add	a0,s1,540
    80005052:	ffffd097          	auipc	ra,0xffffd
    80005056:	5e2080e7          	jalr	1506(ra) # 80002634 <wakeup>
  release(&pi->lock);
    8000505a:	8526                	mv	a0,s1
    8000505c:	ffffc097          	auipc	ra,0xffffc
    80005060:	d24080e7          	jalr	-732(ra) # 80000d80 <release>
  return i;
}
    80005064:	854e                	mv	a0,s3
    80005066:	60a6                	ld	ra,72(sp)
    80005068:	6406                	ld	s0,64(sp)
    8000506a:	74e2                	ld	s1,56(sp)
    8000506c:	7942                	ld	s2,48(sp)
    8000506e:	79a2                	ld	s3,40(sp)
    80005070:	7a02                	ld	s4,32(sp)
    80005072:	6ae2                	ld	s5,24(sp)
    80005074:	6b42                	ld	s6,16(sp)
    80005076:	6161                	add	sp,sp,80
    80005078:	8082                	ret
      release(&pi->lock);
    8000507a:	8526                	mv	a0,s1
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	d04080e7          	jalr	-764(ra) # 80000d80 <release>
      return -1;
    80005084:	59fd                	li	s3,-1
    80005086:	bff9                	j	80005064 <piperead+0xca>

0000000080005088 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005088:	1141                	add	sp,sp,-16
    8000508a:	e422                	sd	s0,8(sp)
    8000508c:	0800                	add	s0,sp,16
    8000508e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005090:	8905                	and	a0,a0,1
    80005092:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005094:	8b89                	and	a5,a5,2
    80005096:	c399                	beqz	a5,8000509c <flags2perm+0x14>
      perm |= PTE_W;
    80005098:	00456513          	or	a0,a0,4
    return perm;
}
    8000509c:	6422                	ld	s0,8(sp)
    8000509e:	0141                	add	sp,sp,16
    800050a0:	8082                	ret

00000000800050a2 <exec>:

int
exec(char *path, char **argv)
{
    800050a2:	df010113          	add	sp,sp,-528
    800050a6:	20113423          	sd	ra,520(sp)
    800050aa:	20813023          	sd	s0,512(sp)
    800050ae:	ffa6                	sd	s1,504(sp)
    800050b0:	fbca                	sd	s2,496(sp)
    800050b2:	f7ce                	sd	s3,488(sp)
    800050b4:	f3d2                	sd	s4,480(sp)
    800050b6:	efd6                	sd	s5,472(sp)
    800050b8:	ebda                	sd	s6,464(sp)
    800050ba:	e7de                	sd	s7,456(sp)
    800050bc:	e3e2                	sd	s8,448(sp)
    800050be:	ff66                	sd	s9,440(sp)
    800050c0:	fb6a                	sd	s10,432(sp)
    800050c2:	f76e                	sd	s11,424(sp)
    800050c4:	0c00                	add	s0,sp,528
    800050c6:	892a                	mv	s2,a0
    800050c8:	dea43c23          	sd	a0,-520(s0)
    800050cc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800050d0:	ffffd097          	auipc	ra,0xffffd
    800050d4:	97a080e7          	jalr	-1670(ra) # 80001a4a <myproc>
    800050d8:	84aa                	mv	s1,a0

  begin_op();
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	48e080e7          	jalr	1166(ra) # 80004568 <begin_op>

  if((ip = namei(path)) == 0){
    800050e2:	854a                	mv	a0,s2
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	284080e7          	jalr	644(ra) # 80004368 <namei>
    800050ec:	c92d                	beqz	a0,8000515e <exec+0xbc>
    800050ee:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	ad2080e7          	jalr	-1326(ra) # 80003bc2 <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800050f8:	04000713          	li	a4,64
    800050fc:	4681                	li	a3,0
    800050fe:	e5040613          	add	a2,s0,-432
    80005102:	4581                	li	a1,0
    80005104:	8552                	mv	a0,s4
    80005106:	fffff097          	auipc	ra,0xfffff
    8000510a:	d70080e7          	jalr	-656(ra) # 80003e76 <readi>
    8000510e:	04000793          	li	a5,64
    80005112:	00f51a63          	bne	a0,a5,80005126 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005116:	e5042703          	lw	a4,-432(s0)
    8000511a:	464c47b7          	lui	a5,0x464c4
    8000511e:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005122:	04f70463          	beq	a4,a5,8000516a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005126:	8552                	mv	a0,s4
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	cfc080e7          	jalr	-772(ra) # 80003e24 <iunlockput>
    end_op();
    80005130:	fffff097          	auipc	ra,0xfffff
    80005134:	4b2080e7          	jalr	1202(ra) # 800045e2 <end_op>
  }
  return -1;
    80005138:	557d                	li	a0,-1
}
    8000513a:	20813083          	ld	ra,520(sp)
    8000513e:	20013403          	ld	s0,512(sp)
    80005142:	74fe                	ld	s1,504(sp)
    80005144:	795e                	ld	s2,496(sp)
    80005146:	79be                	ld	s3,488(sp)
    80005148:	7a1e                	ld	s4,480(sp)
    8000514a:	6afe                	ld	s5,472(sp)
    8000514c:	6b5e                	ld	s6,464(sp)
    8000514e:	6bbe                	ld	s7,456(sp)
    80005150:	6c1e                	ld	s8,448(sp)
    80005152:	7cfa                	ld	s9,440(sp)
    80005154:	7d5a                	ld	s10,432(sp)
    80005156:	7dba                	ld	s11,424(sp)
    80005158:	21010113          	add	sp,sp,528
    8000515c:	8082                	ret
    end_op();
    8000515e:	fffff097          	auipc	ra,0xfffff
    80005162:	484080e7          	jalr	1156(ra) # 800045e2 <end_op>
    return -1;
    80005166:	557d                	li	a0,-1
    80005168:	bfc9                	j	8000513a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000516a:	8526                	mv	a0,s1
    8000516c:	ffffd097          	auipc	ra,0xffffd
    80005170:	d78080e7          	jalr	-648(ra) # 80001ee4 <proc_pagetable>
    80005174:	8b2a                	mv	s6,a0
    80005176:	d945                	beqz	a0,80005126 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005178:	e7042d03          	lw	s10,-400(s0)
    8000517c:	e8845783          	lhu	a5,-376(s0)
    80005180:	10078463          	beqz	a5,80005288 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005184:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005186:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005188:	6c85                	lui	s9,0x1
    8000518a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000518e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005192:	6a85                	lui	s5,0x1
    80005194:	a0b5                	j	80005200 <exec+0x15e>
      panic("loadseg: address should exist");
    80005196:	00003517          	auipc	a0,0x3
    8000519a:	57a50513          	add	a0,a0,1402 # 80008710 <syscalls+0x280>
    8000519e:	ffffb097          	auipc	ra,0xffffb
    800051a2:	670080e7          	jalr	1648(ra) # 8000080e <panic>
    if(sz - i < PGSIZE)
    800051a6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800051a8:	8726                	mv	a4,s1
    800051aa:	012c06bb          	addw	a3,s8,s2
    800051ae:	4581                	li	a1,0
    800051b0:	8552                	mv	a0,s4
    800051b2:	fffff097          	auipc	ra,0xfffff
    800051b6:	cc4080e7          	jalr	-828(ra) # 80003e76 <readi>
    800051ba:	2501                	sext.w	a0,a0
    800051bc:	24a49863          	bne	s1,a0,8000540c <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    800051c0:	012a893b          	addw	s2,s5,s2
    800051c4:	03397563          	bgeu	s2,s3,800051ee <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    800051c8:	02091593          	sll	a1,s2,0x20
    800051cc:	9181                	srl	a1,a1,0x20
    800051ce:	95de                	add	a1,a1,s7
    800051d0:	855a                	mv	a0,s6
    800051d2:	ffffc097          	auipc	ra,0xffffc
    800051d6:	f7e080e7          	jalr	-130(ra) # 80001150 <walkaddr>
    800051da:	862a                	mv	a2,a0
    if(pa == 0)
    800051dc:	dd4d                	beqz	a0,80005196 <exec+0xf4>
    if(sz - i < PGSIZE)
    800051de:	412984bb          	subw	s1,s3,s2
    800051e2:	0004879b          	sext.w	a5,s1
    800051e6:	fcfcf0e3          	bgeu	s9,a5,800051a6 <exec+0x104>
    800051ea:	84d6                	mv	s1,s5
    800051ec:	bf6d                	j	800051a6 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800051ee:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051f2:	2d85                	addw	s11,s11,1
    800051f4:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800051f8:	e8845783          	lhu	a5,-376(s0)
    800051fc:	08fdd763          	bge	s11,a5,8000528a <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005200:	2d01                	sext.w	s10,s10
    80005202:	03800713          	li	a4,56
    80005206:	86ea                	mv	a3,s10
    80005208:	e1840613          	add	a2,s0,-488
    8000520c:	4581                	li	a1,0
    8000520e:	8552                	mv	a0,s4
    80005210:	fffff097          	auipc	ra,0xfffff
    80005214:	c66080e7          	jalr	-922(ra) # 80003e76 <readi>
    80005218:	03800793          	li	a5,56
    8000521c:	1ef51663          	bne	a0,a5,80005408 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80005220:	e1842783          	lw	a5,-488(s0)
    80005224:	4705                	li	a4,1
    80005226:	fce796e3          	bne	a5,a4,800051f2 <exec+0x150>
    if(ph.memsz < ph.filesz)
    8000522a:	e4043483          	ld	s1,-448(s0)
    8000522e:	e3843783          	ld	a5,-456(s0)
    80005232:	1ef4e863          	bltu	s1,a5,80005422 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005236:	e2843783          	ld	a5,-472(s0)
    8000523a:	94be                	add	s1,s1,a5
    8000523c:	1ef4e663          	bltu	s1,a5,80005428 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80005240:	df043703          	ld	a4,-528(s0)
    80005244:	8ff9                	and	a5,a5,a4
    80005246:	1e079463          	bnez	a5,8000542e <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000524a:	e1c42503          	lw	a0,-484(s0)
    8000524e:	00000097          	auipc	ra,0x0
    80005252:	e3a080e7          	jalr	-454(ra) # 80005088 <flags2perm>
    80005256:	86aa                	mv	a3,a0
    80005258:	8626                	mv	a2,s1
    8000525a:	85ca                	mv	a1,s2
    8000525c:	855a                	mv	a0,s6
    8000525e:	ffffc097          	auipc	ra,0xffffc
    80005262:	2ca080e7          	jalr	714(ra) # 80001528 <uvmalloc>
    80005266:	e0a43423          	sd	a0,-504(s0)
    8000526a:	1c050563          	beqz	a0,80005434 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000526e:	e2843b83          	ld	s7,-472(s0)
    80005272:	e2042c03          	lw	s8,-480(s0)
    80005276:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000527a:	00098463          	beqz	s3,80005282 <exec+0x1e0>
    8000527e:	4901                	li	s2,0
    80005280:	b7a1                	j	800051c8 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005282:	e0843903          	ld	s2,-504(s0)
    80005286:	b7b5                	j	800051f2 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005288:	4901                	li	s2,0
  iunlockput(ip);
    8000528a:	8552                	mv	a0,s4
    8000528c:	fffff097          	auipc	ra,0xfffff
    80005290:	b98080e7          	jalr	-1128(ra) # 80003e24 <iunlockput>
  end_op();
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	34e080e7          	jalr	846(ra) # 800045e2 <end_op>
  p = myproc();
    8000529c:	ffffc097          	auipc	ra,0xffffc
    800052a0:	7ae080e7          	jalr	1966(ra) # 80001a4a <myproc>
    800052a4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800052a6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800052aa:	6985                	lui	s3,0x1
    800052ac:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800052ae:	99ca                	add	s3,s3,s2
    800052b0:	77fd                	lui	a5,0xfffff
    800052b2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800052b6:	4691                	li	a3,4
    800052b8:	6609                	lui	a2,0x2
    800052ba:	964e                	add	a2,a2,s3
    800052bc:	85ce                	mv	a1,s3
    800052be:	855a                	mv	a0,s6
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	268080e7          	jalr	616(ra) # 80001528 <uvmalloc>
    800052c8:	892a                	mv	s2,a0
    800052ca:	e0a43423          	sd	a0,-504(s0)
    800052ce:	e509                	bnez	a0,800052d8 <exec+0x236>
  if(pagetable)
    800052d0:	e1343423          	sd	s3,-504(s0)
    800052d4:	4a01                	li	s4,0
    800052d6:	aa1d                	j	8000540c <exec+0x36a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800052d8:	75f9                	lui	a1,0xffffe
    800052da:	95aa                	add	a1,a1,a0
    800052dc:	855a                	mv	a0,s6
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	474080e7          	jalr	1140(ra) # 80001752 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800052e6:	7bfd                	lui	s7,0xfffff
    800052e8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800052ea:	e0043783          	ld	a5,-512(s0)
    800052ee:	6388                	ld	a0,0(a5)
    800052f0:	c52d                	beqz	a0,8000535a <exec+0x2b8>
    800052f2:	e9040993          	add	s3,s0,-368
    800052f6:	f9040c13          	add	s8,s0,-112
    800052fa:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800052fc:	ffffc097          	auipc	ra,0xffffc
    80005300:	c46080e7          	jalr	-954(ra) # 80000f42 <strlen>
    80005304:	0015079b          	addw	a5,a0,1
    80005308:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    8000530c:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80005310:	13796563          	bltu	s2,s7,8000543a <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005314:	e0043d03          	ld	s10,-512(s0)
    80005318:	000d3a03          	ld	s4,0(s10)
    8000531c:	8552                	mv	a0,s4
    8000531e:	ffffc097          	auipc	ra,0xffffc
    80005322:	c24080e7          	jalr	-988(ra) # 80000f42 <strlen>
    80005326:	0015069b          	addw	a3,a0,1
    8000532a:	8652                	mv	a2,s4
    8000532c:	85ca                	mv	a1,s2
    8000532e:	855a                	mv	a0,s6
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	454080e7          	jalr	1108(ra) # 80001784 <copyout>
    80005338:	10054363          	bltz	a0,8000543e <exec+0x39c>
    ustack[argc] = sp;
    8000533c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005340:	0485                	add	s1,s1,1
    80005342:	008d0793          	add	a5,s10,8
    80005346:	e0f43023          	sd	a5,-512(s0)
    8000534a:	008d3503          	ld	a0,8(s10)
    8000534e:	c909                	beqz	a0,80005360 <exec+0x2be>
    if(argc >= MAXARG)
    80005350:	09a1                	add	s3,s3,8
    80005352:	fb8995e3          	bne	s3,s8,800052fc <exec+0x25a>
  ip = 0;
    80005356:	4a01                	li	s4,0
    80005358:	a855                	j	8000540c <exec+0x36a>
  sp = sz;
    8000535a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000535e:	4481                	li	s1,0
  ustack[argc] = 0;
    80005360:	00349793          	sll	a5,s1,0x3
    80005364:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdcce0>
    80005368:	97a2                	add	a5,a5,s0
    8000536a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000536e:	00148693          	add	a3,s1,1
    80005372:	068e                	sll	a3,a3,0x3
    80005374:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005378:	ff097913          	and	s2,s2,-16
  sz = sz1;
    8000537c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005380:	f57968e3          	bltu	s2,s7,800052d0 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005384:	e9040613          	add	a2,s0,-368
    80005388:	85ca                	mv	a1,s2
    8000538a:	855a                	mv	a0,s6
    8000538c:	ffffc097          	auipc	ra,0xffffc
    80005390:	3f8080e7          	jalr	1016(ra) # 80001784 <copyout>
    80005394:	0a054763          	bltz	a0,80005442 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80005398:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000539c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800053a0:	df843783          	ld	a5,-520(s0)
    800053a4:	0007c703          	lbu	a4,0(a5)
    800053a8:	cf11                	beqz	a4,800053c4 <exec+0x322>
    800053aa:	0785                	add	a5,a5,1
    if(*s == '/')
    800053ac:	02f00693          	li	a3,47
    800053b0:	a039                	j	800053be <exec+0x31c>
      last = s+1;
    800053b2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800053b6:	0785                	add	a5,a5,1
    800053b8:	fff7c703          	lbu	a4,-1(a5)
    800053bc:	c701                	beqz	a4,800053c4 <exec+0x322>
    if(*s == '/')
    800053be:	fed71ce3          	bne	a4,a3,800053b6 <exec+0x314>
    800053c2:	bfc5                	j	800053b2 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800053c4:	4641                	li	a2,16
    800053c6:	df843583          	ld	a1,-520(s0)
    800053ca:	158a8513          	add	a0,s5,344
    800053ce:	ffffc097          	auipc	ra,0xffffc
    800053d2:	b42080e7          	jalr	-1214(ra) # 80000f10 <safestrcpy>
  oldpagetable = p->pagetable;
    800053d6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800053da:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800053de:	e0843783          	ld	a5,-504(s0)
    800053e2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    800053e6:	058ab783          	ld	a5,88(s5)
    800053ea:	e6843703          	ld	a4,-408(s0)
    800053ee:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    800053f0:	058ab783          	ld	a5,88(s5)
    800053f4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800053f8:	85e6                	mv	a1,s9
    800053fa:	ffffd097          	auipc	ra,0xffffd
    800053fe:	b86080e7          	jalr	-1146(ra) # 80001f80 <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    80005402:	0004851b          	sext.w	a0,s1
    80005406:	bb15                	j	8000513a <exec+0x98>
    80005408:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000540c:	e0843583          	ld	a1,-504(s0)
    80005410:	855a                	mv	a0,s6
    80005412:	ffffd097          	auipc	ra,0xffffd
    80005416:	b6e080e7          	jalr	-1170(ra) # 80001f80 <proc_freepagetable>
  return -1;
    8000541a:	557d                	li	a0,-1
  if(ip){
    8000541c:	d00a0fe3          	beqz	s4,8000513a <exec+0x98>
    80005420:	b319                	j	80005126 <exec+0x84>
    80005422:	e1243423          	sd	s2,-504(s0)
    80005426:	b7dd                	j	8000540c <exec+0x36a>
    80005428:	e1243423          	sd	s2,-504(s0)
    8000542c:	b7c5                	j	8000540c <exec+0x36a>
    8000542e:	e1243423          	sd	s2,-504(s0)
    80005432:	bfe9                	j	8000540c <exec+0x36a>
    80005434:	e1243423          	sd	s2,-504(s0)
    80005438:	bfd1                	j	8000540c <exec+0x36a>
  ip = 0;
    8000543a:	4a01                	li	s4,0
    8000543c:	bfc1                	j	8000540c <exec+0x36a>
    8000543e:	4a01                	li	s4,0
  if(pagetable)
    80005440:	b7f1                	j	8000540c <exec+0x36a>
  sz = sz1;
    80005442:	e0843983          	ld	s3,-504(s0)
    80005446:	b569                	j	800052d0 <exec+0x22e>

0000000080005448 <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005448:	7179                	add	sp,sp,-48
    8000544a:	f406                	sd	ra,40(sp)
    8000544c:	f022                	sd	s0,32(sp)
    8000544e:	ec26                	sd	s1,24(sp)
    80005450:	e84a                	sd	s2,16(sp)
    80005452:	1800                	add	s0,sp,48
    80005454:	892e                	mv	s2,a1
    80005456:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005458:	fdc40593          	add	a1,s0,-36
    8000545c:	ffffe097          	auipc	ra,0xffffe
    80005460:	bf6080e7          	jalr	-1034(ra) # 80003052 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005464:	fdc42703          	lw	a4,-36(s0)
    80005468:	47bd                	li	a5,15
    8000546a:	02e7eb63          	bltu	a5,a4,800054a0 <argfd+0x58>
    8000546e:	ffffc097          	auipc	ra,0xffffc
    80005472:	5dc080e7          	jalr	1500(ra) # 80001a4a <myproc>
    80005476:	fdc42703          	lw	a4,-36(s0)
    8000547a:	01a70793          	add	a5,a4,26
    8000547e:	078e                	sll	a5,a5,0x3
    80005480:	953e                	add	a0,a0,a5
    80005482:	611c                	ld	a5,0(a0)
    80005484:	c385                	beqz	a5,800054a4 <argfd+0x5c>
    return -1;
  if(pfd)
    80005486:	00090463          	beqz	s2,8000548e <argfd+0x46>
    *pfd = fd;
    8000548a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000548e:	4501                	li	a0,0
  if(pf)
    80005490:	c091                	beqz	s1,80005494 <argfd+0x4c>
    *pf = f;
    80005492:	e09c                	sd	a5,0(s1)
}
    80005494:	70a2                	ld	ra,40(sp)
    80005496:	7402                	ld	s0,32(sp)
    80005498:	64e2                	ld	s1,24(sp)
    8000549a:	6942                	ld	s2,16(sp)
    8000549c:	6145                	add	sp,sp,48
    8000549e:	8082                	ret
    return -1;
    800054a0:	557d                	li	a0,-1
    800054a2:	bfcd                	j	80005494 <argfd+0x4c>
    800054a4:	557d                	li	a0,-1
    800054a6:	b7fd                	j	80005494 <argfd+0x4c>

00000000800054a8 <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    800054a8:	1101                	add	sp,sp,-32
    800054aa:	ec06                	sd	ra,24(sp)
    800054ac:	e822                	sd	s0,16(sp)
    800054ae:	e426                	sd	s1,8(sp)
    800054b0:	1000                	add	s0,sp,32
    800054b2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800054b4:	ffffc097          	auipc	ra,0xffffc
    800054b8:	596080e7          	jalr	1430(ra) # 80001a4a <myproc>
    800054bc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800054be:	0d050793          	add	a5,a0,208
    800054c2:	4501                	li	a0,0
    800054c4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800054c6:	6398                	ld	a4,0(a5)
    800054c8:	cb19                	beqz	a4,800054de <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800054ca:	2505                	addw	a0,a0,1
    800054cc:	07a1                	add	a5,a5,8
    800054ce:	fed51ce3          	bne	a0,a3,800054c6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800054d2:	557d                	li	a0,-1
}
    800054d4:	60e2                	ld	ra,24(sp)
    800054d6:	6442                	ld	s0,16(sp)
    800054d8:	64a2                	ld	s1,8(sp)
    800054da:	6105                	add	sp,sp,32
    800054dc:	8082                	ret
      p->ofile[fd] = f;
    800054de:	01a50793          	add	a5,a0,26
    800054e2:	078e                	sll	a5,a5,0x3
    800054e4:	963e                	add	a2,a2,a5
    800054e6:	e204                	sd	s1,0(a2)
      return fd;
    800054e8:	b7f5                	j	800054d4 <fdalloc+0x2c>

00000000800054ea <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800054ea:	715d                	add	sp,sp,-80
    800054ec:	e486                	sd	ra,72(sp)
    800054ee:	e0a2                	sd	s0,64(sp)
    800054f0:	fc26                	sd	s1,56(sp)
    800054f2:	f84a                	sd	s2,48(sp)
    800054f4:	f44e                	sd	s3,40(sp)
    800054f6:	f052                	sd	s4,32(sp)
    800054f8:	ec56                	sd	s5,24(sp)
    800054fa:	e85a                	sd	s6,16(sp)
    800054fc:	0880                	add	s0,sp,80
    800054fe:	8b2e                	mv	s6,a1
    80005500:	89b2                	mv	s3,a2
    80005502:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005504:	fb040593          	add	a1,s0,-80
    80005508:	fffff097          	auipc	ra,0xfffff
    8000550c:	e7e080e7          	jalr	-386(ra) # 80004386 <nameiparent>
    80005510:	84aa                	mv	s1,a0
    80005512:	14050b63          	beqz	a0,80005668 <create+0x17e>
    return 0;

  ilock(dp);
    80005516:	ffffe097          	auipc	ra,0xffffe
    8000551a:	6ac080e7          	jalr	1708(ra) # 80003bc2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000551e:	4601                	li	a2,0
    80005520:	fb040593          	add	a1,s0,-80
    80005524:	8526                	mv	a0,s1
    80005526:	fffff097          	auipc	ra,0xfffff
    8000552a:	b80080e7          	jalr	-1152(ra) # 800040a6 <dirlookup>
    8000552e:	8aaa                	mv	s5,a0
    80005530:	c921                	beqz	a0,80005580 <create+0x96>
    iunlockput(dp);
    80005532:	8526                	mv	a0,s1
    80005534:	fffff097          	auipc	ra,0xfffff
    80005538:	8f0080e7          	jalr	-1808(ra) # 80003e24 <iunlockput>
    ilock(ip);
    8000553c:	8556                	mv	a0,s5
    8000553e:	ffffe097          	auipc	ra,0xffffe
    80005542:	684080e7          	jalr	1668(ra) # 80003bc2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005546:	4789                	li	a5,2
    80005548:	02fb1563          	bne	s6,a5,80005572 <create+0x88>
    8000554c:	044ad783          	lhu	a5,68(s5)
    80005550:	37f9                	addw	a5,a5,-2
    80005552:	17c2                	sll	a5,a5,0x30
    80005554:	93c1                	srl	a5,a5,0x30
    80005556:	4705                	li	a4,1
    80005558:	00f76d63          	bltu	a4,a5,80005572 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000555c:	8556                	mv	a0,s5
    8000555e:	60a6                	ld	ra,72(sp)
    80005560:	6406                	ld	s0,64(sp)
    80005562:	74e2                	ld	s1,56(sp)
    80005564:	7942                	ld	s2,48(sp)
    80005566:	79a2                	ld	s3,40(sp)
    80005568:	7a02                	ld	s4,32(sp)
    8000556a:	6ae2                	ld	s5,24(sp)
    8000556c:	6b42                	ld	s6,16(sp)
    8000556e:	6161                	add	sp,sp,80
    80005570:	8082                	ret
    iunlockput(ip);
    80005572:	8556                	mv	a0,s5
    80005574:	fffff097          	auipc	ra,0xfffff
    80005578:	8b0080e7          	jalr	-1872(ra) # 80003e24 <iunlockput>
    return 0;
    8000557c:	4a81                	li	s5,0
    8000557e:	bff9                	j	8000555c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005580:	85da                	mv	a1,s6
    80005582:	4088                	lw	a0,0(s1)
    80005584:	ffffe097          	auipc	ra,0xffffe
    80005588:	4a6080e7          	jalr	1190(ra) # 80003a2a <ialloc>
    8000558c:	8a2a                	mv	s4,a0
    8000558e:	c529                	beqz	a0,800055d8 <create+0xee>
  ilock(ip);
    80005590:	ffffe097          	auipc	ra,0xffffe
    80005594:	632080e7          	jalr	1586(ra) # 80003bc2 <ilock>
  ip->major = major;
    80005598:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000559c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800055a0:	4905                	li	s2,1
    800055a2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800055a6:	8552                	mv	a0,s4
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	54e080e7          	jalr	1358(ra) # 80003af6 <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    800055b0:	032b0b63          	beq	s6,s2,800055e6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800055b4:	004a2603          	lw	a2,4(s4)
    800055b8:	fb040593          	add	a1,s0,-80
    800055bc:	8526                	mv	a0,s1
    800055be:	fffff097          	auipc	ra,0xfffff
    800055c2:	cf8080e7          	jalr	-776(ra) # 800042b6 <dirlink>
    800055c6:	06054f63          	bltz	a0,80005644 <create+0x15a>
  iunlockput(dp);
    800055ca:	8526                	mv	a0,s1
    800055cc:	fffff097          	auipc	ra,0xfffff
    800055d0:	858080e7          	jalr	-1960(ra) # 80003e24 <iunlockput>
  return ip;
    800055d4:	8ad2                	mv	s5,s4
    800055d6:	b759                	j	8000555c <create+0x72>
    iunlockput(dp);
    800055d8:	8526                	mv	a0,s1
    800055da:	fffff097          	auipc	ra,0xfffff
    800055de:	84a080e7          	jalr	-1974(ra) # 80003e24 <iunlockput>
    return 0;
    800055e2:	8ad2                	mv	s5,s4
    800055e4:	bfa5                	j	8000555c <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800055e6:	004a2603          	lw	a2,4(s4)
    800055ea:	00003597          	auipc	a1,0x3
    800055ee:	14658593          	add	a1,a1,326 # 80008730 <syscalls+0x2a0>
    800055f2:	8552                	mv	a0,s4
    800055f4:	fffff097          	auipc	ra,0xfffff
    800055f8:	cc2080e7          	jalr	-830(ra) # 800042b6 <dirlink>
    800055fc:	04054463          	bltz	a0,80005644 <create+0x15a>
    80005600:	40d0                	lw	a2,4(s1)
    80005602:	00003597          	auipc	a1,0x3
    80005606:	13658593          	add	a1,a1,310 # 80008738 <syscalls+0x2a8>
    8000560a:	8552                	mv	a0,s4
    8000560c:	fffff097          	auipc	ra,0xfffff
    80005610:	caa080e7          	jalr	-854(ra) # 800042b6 <dirlink>
    80005614:	02054863          	bltz	a0,80005644 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80005618:	004a2603          	lw	a2,4(s4)
    8000561c:	fb040593          	add	a1,s0,-80
    80005620:	8526                	mv	a0,s1
    80005622:	fffff097          	auipc	ra,0xfffff
    80005626:	c94080e7          	jalr	-876(ra) # 800042b6 <dirlink>
    8000562a:	00054d63          	bltz	a0,80005644 <create+0x15a>
    dp->nlink++;  /* for ".." */
    8000562e:	04a4d783          	lhu	a5,74(s1)
    80005632:	2785                	addw	a5,a5,1
    80005634:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005638:	8526                	mv	a0,s1
    8000563a:	ffffe097          	auipc	ra,0xffffe
    8000563e:	4bc080e7          	jalr	1212(ra) # 80003af6 <iupdate>
    80005642:	b761                	j	800055ca <create+0xe0>
  ip->nlink = 0;
    80005644:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005648:	8552                	mv	a0,s4
    8000564a:	ffffe097          	auipc	ra,0xffffe
    8000564e:	4ac080e7          	jalr	1196(ra) # 80003af6 <iupdate>
  iunlockput(ip);
    80005652:	8552                	mv	a0,s4
    80005654:	ffffe097          	auipc	ra,0xffffe
    80005658:	7d0080e7          	jalr	2000(ra) # 80003e24 <iunlockput>
  iunlockput(dp);
    8000565c:	8526                	mv	a0,s1
    8000565e:	ffffe097          	auipc	ra,0xffffe
    80005662:	7c6080e7          	jalr	1990(ra) # 80003e24 <iunlockput>
  return 0;
    80005666:	bddd                	j	8000555c <create+0x72>
    return 0;
    80005668:	8aaa                	mv	s5,a0
    8000566a:	bdcd                	j	8000555c <create+0x72>

000000008000566c <sys_dup>:
{
    8000566c:	7179                	add	sp,sp,-48
    8000566e:	f406                	sd	ra,40(sp)
    80005670:	f022                	sd	s0,32(sp)
    80005672:	ec26                	sd	s1,24(sp)
    80005674:	e84a                	sd	s2,16(sp)
    80005676:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005678:	fd840613          	add	a2,s0,-40
    8000567c:	4581                	li	a1,0
    8000567e:	4501                	li	a0,0
    80005680:	00000097          	auipc	ra,0x0
    80005684:	dc8080e7          	jalr	-568(ra) # 80005448 <argfd>
    return -1;
    80005688:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000568a:	02054363          	bltz	a0,800056b0 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000568e:	fd843903          	ld	s2,-40(s0)
    80005692:	854a                	mv	a0,s2
    80005694:	00000097          	auipc	ra,0x0
    80005698:	e14080e7          	jalr	-492(ra) # 800054a8 <fdalloc>
    8000569c:	84aa                	mv	s1,a0
    return -1;
    8000569e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800056a0:	00054863          	bltz	a0,800056b0 <sys_dup+0x44>
  filedup(f);
    800056a4:	854a                	mv	a0,s2
    800056a6:	fffff097          	auipc	ra,0xfffff
    800056aa:	334080e7          	jalr	820(ra) # 800049da <filedup>
  return fd;
    800056ae:	87a6                	mv	a5,s1
}
    800056b0:	853e                	mv	a0,a5
    800056b2:	70a2                	ld	ra,40(sp)
    800056b4:	7402                	ld	s0,32(sp)
    800056b6:	64e2                	ld	s1,24(sp)
    800056b8:	6942                	ld	s2,16(sp)
    800056ba:	6145                	add	sp,sp,48
    800056bc:	8082                	ret

00000000800056be <sys_read>:
{
    800056be:	7179                	add	sp,sp,-48
    800056c0:	f406                	sd	ra,40(sp)
    800056c2:	f022                	sd	s0,32(sp)
    800056c4:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800056c6:	fd840593          	add	a1,s0,-40
    800056ca:	4505                	li	a0,1
    800056cc:	ffffe097          	auipc	ra,0xffffe
    800056d0:	9a6080e7          	jalr	-1626(ra) # 80003072 <argaddr>
  argint(2, &n);
    800056d4:	fe440593          	add	a1,s0,-28
    800056d8:	4509                	li	a0,2
    800056da:	ffffe097          	auipc	ra,0xffffe
    800056de:	978080e7          	jalr	-1672(ra) # 80003052 <argint>
  if(argfd(0, 0, &f) < 0)
    800056e2:	fe840613          	add	a2,s0,-24
    800056e6:	4581                	li	a1,0
    800056e8:	4501                	li	a0,0
    800056ea:	00000097          	auipc	ra,0x0
    800056ee:	d5e080e7          	jalr	-674(ra) # 80005448 <argfd>
    800056f2:	87aa                	mv	a5,a0
    return -1;
    800056f4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056f6:	0007cc63          	bltz	a5,8000570e <sys_read+0x50>
  return fileread(f, p, n);
    800056fa:	fe442603          	lw	a2,-28(s0)
    800056fe:	fd843583          	ld	a1,-40(s0)
    80005702:	fe843503          	ld	a0,-24(s0)
    80005706:	fffff097          	auipc	ra,0xfffff
    8000570a:	460080e7          	jalr	1120(ra) # 80004b66 <fileread>
}
    8000570e:	70a2                	ld	ra,40(sp)
    80005710:	7402                	ld	s0,32(sp)
    80005712:	6145                	add	sp,sp,48
    80005714:	8082                	ret

0000000080005716 <sys_write>:
{
    80005716:	7179                	add	sp,sp,-48
    80005718:	f406                	sd	ra,40(sp)
    8000571a:	f022                	sd	s0,32(sp)
    8000571c:	1800                	add	s0,sp,48
  argaddr(1, &p);
    8000571e:	fd840593          	add	a1,s0,-40
    80005722:	4505                	li	a0,1
    80005724:	ffffe097          	auipc	ra,0xffffe
    80005728:	94e080e7          	jalr	-1714(ra) # 80003072 <argaddr>
  argint(2, &n);
    8000572c:	fe440593          	add	a1,s0,-28
    80005730:	4509                	li	a0,2
    80005732:	ffffe097          	auipc	ra,0xffffe
    80005736:	920080e7          	jalr	-1760(ra) # 80003052 <argint>
  if(argfd(0, 0, &f) < 0)
    8000573a:	fe840613          	add	a2,s0,-24
    8000573e:	4581                	li	a1,0
    80005740:	4501                	li	a0,0
    80005742:	00000097          	auipc	ra,0x0
    80005746:	d06080e7          	jalr	-762(ra) # 80005448 <argfd>
    8000574a:	87aa                	mv	a5,a0
    return -1;
    8000574c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000574e:	0007cc63          	bltz	a5,80005766 <sys_write+0x50>
  return filewrite(f, p, n);
    80005752:	fe442603          	lw	a2,-28(s0)
    80005756:	fd843583          	ld	a1,-40(s0)
    8000575a:	fe843503          	ld	a0,-24(s0)
    8000575e:	fffff097          	auipc	ra,0xfffff
    80005762:	4ca080e7          	jalr	1226(ra) # 80004c28 <filewrite>
}
    80005766:	70a2                	ld	ra,40(sp)
    80005768:	7402                	ld	s0,32(sp)
    8000576a:	6145                	add	sp,sp,48
    8000576c:	8082                	ret

000000008000576e <sys_close>:
{
    8000576e:	1101                	add	sp,sp,-32
    80005770:	ec06                	sd	ra,24(sp)
    80005772:	e822                	sd	s0,16(sp)
    80005774:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005776:	fe040613          	add	a2,s0,-32
    8000577a:	fec40593          	add	a1,s0,-20
    8000577e:	4501                	li	a0,0
    80005780:	00000097          	auipc	ra,0x0
    80005784:	cc8080e7          	jalr	-824(ra) # 80005448 <argfd>
    return -1;
    80005788:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000578a:	02054463          	bltz	a0,800057b2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000578e:	ffffc097          	auipc	ra,0xffffc
    80005792:	2bc080e7          	jalr	700(ra) # 80001a4a <myproc>
    80005796:	fec42783          	lw	a5,-20(s0)
    8000579a:	07e9                	add	a5,a5,26
    8000579c:	078e                	sll	a5,a5,0x3
    8000579e:	953e                	add	a0,a0,a5
    800057a0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800057a4:	fe043503          	ld	a0,-32(s0)
    800057a8:	fffff097          	auipc	ra,0xfffff
    800057ac:	284080e7          	jalr	644(ra) # 80004a2c <fileclose>
  return 0;
    800057b0:	4781                	li	a5,0
}
    800057b2:	853e                	mv	a0,a5
    800057b4:	60e2                	ld	ra,24(sp)
    800057b6:	6442                	ld	s0,16(sp)
    800057b8:	6105                	add	sp,sp,32
    800057ba:	8082                	ret

00000000800057bc <sys_fstat>:
{
    800057bc:	1101                	add	sp,sp,-32
    800057be:	ec06                	sd	ra,24(sp)
    800057c0:	e822                	sd	s0,16(sp)
    800057c2:	1000                	add	s0,sp,32
  argaddr(1, &st);
    800057c4:	fe040593          	add	a1,s0,-32
    800057c8:	4505                	li	a0,1
    800057ca:	ffffe097          	auipc	ra,0xffffe
    800057ce:	8a8080e7          	jalr	-1880(ra) # 80003072 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800057d2:	fe840613          	add	a2,s0,-24
    800057d6:	4581                	li	a1,0
    800057d8:	4501                	li	a0,0
    800057da:	00000097          	auipc	ra,0x0
    800057de:	c6e080e7          	jalr	-914(ra) # 80005448 <argfd>
    800057e2:	87aa                	mv	a5,a0
    return -1;
    800057e4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800057e6:	0007ca63          	bltz	a5,800057fa <sys_fstat+0x3e>
  return filestat(f, st);
    800057ea:	fe043583          	ld	a1,-32(s0)
    800057ee:	fe843503          	ld	a0,-24(s0)
    800057f2:	fffff097          	auipc	ra,0xfffff
    800057f6:	302080e7          	jalr	770(ra) # 80004af4 <filestat>
}
    800057fa:	60e2                	ld	ra,24(sp)
    800057fc:	6442                	ld	s0,16(sp)
    800057fe:	6105                	add	sp,sp,32
    80005800:	8082                	ret

0000000080005802 <sys_link>:
{
    80005802:	7169                	add	sp,sp,-304
    80005804:	f606                	sd	ra,296(sp)
    80005806:	f222                	sd	s0,288(sp)
    80005808:	ee26                	sd	s1,280(sp)
    8000580a:	ea4a                	sd	s2,272(sp)
    8000580c:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000580e:	08000613          	li	a2,128
    80005812:	ed040593          	add	a1,s0,-304
    80005816:	4501                	li	a0,0
    80005818:	ffffe097          	auipc	ra,0xffffe
    8000581c:	87a080e7          	jalr	-1926(ra) # 80003092 <argstr>
    return -1;
    80005820:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005822:	10054e63          	bltz	a0,8000593e <sys_link+0x13c>
    80005826:	08000613          	li	a2,128
    8000582a:	f5040593          	add	a1,s0,-176
    8000582e:	4505                	li	a0,1
    80005830:	ffffe097          	auipc	ra,0xffffe
    80005834:	862080e7          	jalr	-1950(ra) # 80003092 <argstr>
    return -1;
    80005838:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000583a:	10054263          	bltz	a0,8000593e <sys_link+0x13c>
  begin_op();
    8000583e:	fffff097          	auipc	ra,0xfffff
    80005842:	d2a080e7          	jalr	-726(ra) # 80004568 <begin_op>
  if((ip = namei(old)) == 0){
    80005846:	ed040513          	add	a0,s0,-304
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	b1e080e7          	jalr	-1250(ra) # 80004368 <namei>
    80005852:	84aa                	mv	s1,a0
    80005854:	c551                	beqz	a0,800058e0 <sys_link+0xde>
  ilock(ip);
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	36c080e7          	jalr	876(ra) # 80003bc2 <ilock>
  if(ip->type == T_DIR){
    8000585e:	04449703          	lh	a4,68(s1)
    80005862:	4785                	li	a5,1
    80005864:	08f70463          	beq	a4,a5,800058ec <sys_link+0xea>
  ip->nlink++;
    80005868:	04a4d783          	lhu	a5,74(s1)
    8000586c:	2785                	addw	a5,a5,1
    8000586e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005872:	8526                	mv	a0,s1
    80005874:	ffffe097          	auipc	ra,0xffffe
    80005878:	282080e7          	jalr	642(ra) # 80003af6 <iupdate>
  iunlock(ip);
    8000587c:	8526                	mv	a0,s1
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	406080e7          	jalr	1030(ra) # 80003c84 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005886:	fd040593          	add	a1,s0,-48
    8000588a:	f5040513          	add	a0,s0,-176
    8000588e:	fffff097          	auipc	ra,0xfffff
    80005892:	af8080e7          	jalr	-1288(ra) # 80004386 <nameiparent>
    80005896:	892a                	mv	s2,a0
    80005898:	c935                	beqz	a0,8000590c <sys_link+0x10a>
  ilock(dp);
    8000589a:	ffffe097          	auipc	ra,0xffffe
    8000589e:	328080e7          	jalr	808(ra) # 80003bc2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800058a2:	00092703          	lw	a4,0(s2)
    800058a6:	409c                	lw	a5,0(s1)
    800058a8:	04f71d63          	bne	a4,a5,80005902 <sys_link+0x100>
    800058ac:	40d0                	lw	a2,4(s1)
    800058ae:	fd040593          	add	a1,s0,-48
    800058b2:	854a                	mv	a0,s2
    800058b4:	fffff097          	auipc	ra,0xfffff
    800058b8:	a02080e7          	jalr	-1534(ra) # 800042b6 <dirlink>
    800058bc:	04054363          	bltz	a0,80005902 <sys_link+0x100>
  iunlockput(dp);
    800058c0:	854a                	mv	a0,s2
    800058c2:	ffffe097          	auipc	ra,0xffffe
    800058c6:	562080e7          	jalr	1378(ra) # 80003e24 <iunlockput>
  iput(ip);
    800058ca:	8526                	mv	a0,s1
    800058cc:	ffffe097          	auipc	ra,0xffffe
    800058d0:	4b0080e7          	jalr	1200(ra) # 80003d7c <iput>
  end_op();
    800058d4:	fffff097          	auipc	ra,0xfffff
    800058d8:	d0e080e7          	jalr	-754(ra) # 800045e2 <end_op>
  return 0;
    800058dc:	4781                	li	a5,0
    800058de:	a085                	j	8000593e <sys_link+0x13c>
    end_op();
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	d02080e7          	jalr	-766(ra) # 800045e2 <end_op>
    return -1;
    800058e8:	57fd                	li	a5,-1
    800058ea:	a891                	j	8000593e <sys_link+0x13c>
    iunlockput(ip);
    800058ec:	8526                	mv	a0,s1
    800058ee:	ffffe097          	auipc	ra,0xffffe
    800058f2:	536080e7          	jalr	1334(ra) # 80003e24 <iunlockput>
    end_op();
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	cec080e7          	jalr	-788(ra) # 800045e2 <end_op>
    return -1;
    800058fe:	57fd                	li	a5,-1
    80005900:	a83d                	j	8000593e <sys_link+0x13c>
    iunlockput(dp);
    80005902:	854a                	mv	a0,s2
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	520080e7          	jalr	1312(ra) # 80003e24 <iunlockput>
  ilock(ip);
    8000590c:	8526                	mv	a0,s1
    8000590e:	ffffe097          	auipc	ra,0xffffe
    80005912:	2b4080e7          	jalr	692(ra) # 80003bc2 <ilock>
  ip->nlink--;
    80005916:	04a4d783          	lhu	a5,74(s1)
    8000591a:	37fd                	addw	a5,a5,-1
    8000591c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005920:	8526                	mv	a0,s1
    80005922:	ffffe097          	auipc	ra,0xffffe
    80005926:	1d4080e7          	jalr	468(ra) # 80003af6 <iupdate>
  iunlockput(ip);
    8000592a:	8526                	mv	a0,s1
    8000592c:	ffffe097          	auipc	ra,0xffffe
    80005930:	4f8080e7          	jalr	1272(ra) # 80003e24 <iunlockput>
  end_op();
    80005934:	fffff097          	auipc	ra,0xfffff
    80005938:	cae080e7          	jalr	-850(ra) # 800045e2 <end_op>
  return -1;
    8000593c:	57fd                	li	a5,-1
}
    8000593e:	853e                	mv	a0,a5
    80005940:	70b2                	ld	ra,296(sp)
    80005942:	7412                	ld	s0,288(sp)
    80005944:	64f2                	ld	s1,280(sp)
    80005946:	6952                	ld	s2,272(sp)
    80005948:	6155                	add	sp,sp,304
    8000594a:	8082                	ret

000000008000594c <sys_unlink>:
{
    8000594c:	7151                	add	sp,sp,-240
    8000594e:	f586                	sd	ra,232(sp)
    80005950:	f1a2                	sd	s0,224(sp)
    80005952:	eda6                	sd	s1,216(sp)
    80005954:	e9ca                	sd	s2,208(sp)
    80005956:	e5ce                	sd	s3,200(sp)
    80005958:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000595a:	08000613          	li	a2,128
    8000595e:	f3040593          	add	a1,s0,-208
    80005962:	4501                	li	a0,0
    80005964:	ffffd097          	auipc	ra,0xffffd
    80005968:	72e080e7          	jalr	1838(ra) # 80003092 <argstr>
    8000596c:	18054163          	bltz	a0,80005aee <sys_unlink+0x1a2>
  begin_op();
    80005970:	fffff097          	auipc	ra,0xfffff
    80005974:	bf8080e7          	jalr	-1032(ra) # 80004568 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005978:	fb040593          	add	a1,s0,-80
    8000597c:	f3040513          	add	a0,s0,-208
    80005980:	fffff097          	auipc	ra,0xfffff
    80005984:	a06080e7          	jalr	-1530(ra) # 80004386 <nameiparent>
    80005988:	84aa                	mv	s1,a0
    8000598a:	c979                	beqz	a0,80005a60 <sys_unlink+0x114>
  ilock(dp);
    8000598c:	ffffe097          	auipc	ra,0xffffe
    80005990:	236080e7          	jalr	566(ra) # 80003bc2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005994:	00003597          	auipc	a1,0x3
    80005998:	d9c58593          	add	a1,a1,-612 # 80008730 <syscalls+0x2a0>
    8000599c:	fb040513          	add	a0,s0,-80
    800059a0:	ffffe097          	auipc	ra,0xffffe
    800059a4:	6ec080e7          	jalr	1772(ra) # 8000408c <namecmp>
    800059a8:	14050a63          	beqz	a0,80005afc <sys_unlink+0x1b0>
    800059ac:	00003597          	auipc	a1,0x3
    800059b0:	d8c58593          	add	a1,a1,-628 # 80008738 <syscalls+0x2a8>
    800059b4:	fb040513          	add	a0,s0,-80
    800059b8:	ffffe097          	auipc	ra,0xffffe
    800059bc:	6d4080e7          	jalr	1748(ra) # 8000408c <namecmp>
    800059c0:	12050e63          	beqz	a0,80005afc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800059c4:	f2c40613          	add	a2,s0,-212
    800059c8:	fb040593          	add	a1,s0,-80
    800059cc:	8526                	mv	a0,s1
    800059ce:	ffffe097          	auipc	ra,0xffffe
    800059d2:	6d8080e7          	jalr	1752(ra) # 800040a6 <dirlookup>
    800059d6:	892a                	mv	s2,a0
    800059d8:	12050263          	beqz	a0,80005afc <sys_unlink+0x1b0>
  ilock(ip);
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	1e6080e7          	jalr	486(ra) # 80003bc2 <ilock>
  if(ip->nlink < 1)
    800059e4:	04a91783          	lh	a5,74(s2)
    800059e8:	08f05263          	blez	a5,80005a6c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800059ec:	04491703          	lh	a4,68(s2)
    800059f0:	4785                	li	a5,1
    800059f2:	08f70563          	beq	a4,a5,80005a7c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800059f6:	4641                	li	a2,16
    800059f8:	4581                	li	a1,0
    800059fa:	fc040513          	add	a0,s0,-64
    800059fe:	ffffb097          	auipc	ra,0xffffb
    80005a02:	3ca080e7          	jalr	970(ra) # 80000dc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a06:	4741                	li	a4,16
    80005a08:	f2c42683          	lw	a3,-212(s0)
    80005a0c:	fc040613          	add	a2,s0,-64
    80005a10:	4581                	li	a1,0
    80005a12:	8526                	mv	a0,s1
    80005a14:	ffffe097          	auipc	ra,0xffffe
    80005a18:	55a080e7          	jalr	1370(ra) # 80003f6e <writei>
    80005a1c:	47c1                	li	a5,16
    80005a1e:	0af51563          	bne	a0,a5,80005ac8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005a22:	04491703          	lh	a4,68(s2)
    80005a26:	4785                	li	a5,1
    80005a28:	0af70863          	beq	a4,a5,80005ad8 <sys_unlink+0x18c>
  iunlockput(dp);
    80005a2c:	8526                	mv	a0,s1
    80005a2e:	ffffe097          	auipc	ra,0xffffe
    80005a32:	3f6080e7          	jalr	1014(ra) # 80003e24 <iunlockput>
  ip->nlink--;
    80005a36:	04a95783          	lhu	a5,74(s2)
    80005a3a:	37fd                	addw	a5,a5,-1
    80005a3c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a40:	854a                	mv	a0,s2
    80005a42:	ffffe097          	auipc	ra,0xffffe
    80005a46:	0b4080e7          	jalr	180(ra) # 80003af6 <iupdate>
  iunlockput(ip);
    80005a4a:	854a                	mv	a0,s2
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	3d8080e7          	jalr	984(ra) # 80003e24 <iunlockput>
  end_op();
    80005a54:	fffff097          	auipc	ra,0xfffff
    80005a58:	b8e080e7          	jalr	-1138(ra) # 800045e2 <end_op>
  return 0;
    80005a5c:	4501                	li	a0,0
    80005a5e:	a84d                	j	80005b10 <sys_unlink+0x1c4>
    end_op();
    80005a60:	fffff097          	auipc	ra,0xfffff
    80005a64:	b82080e7          	jalr	-1150(ra) # 800045e2 <end_op>
    return -1;
    80005a68:	557d                	li	a0,-1
    80005a6a:	a05d                	j	80005b10 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005a6c:	00003517          	auipc	a0,0x3
    80005a70:	cd450513          	add	a0,a0,-812 # 80008740 <syscalls+0x2b0>
    80005a74:	ffffb097          	auipc	ra,0xffffb
    80005a78:	d9a080e7          	jalr	-614(ra) # 8000080e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a7c:	04c92703          	lw	a4,76(s2)
    80005a80:	02000793          	li	a5,32
    80005a84:	f6e7f9e3          	bgeu	a5,a4,800059f6 <sys_unlink+0xaa>
    80005a88:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a8c:	4741                	li	a4,16
    80005a8e:	86ce                	mv	a3,s3
    80005a90:	f1840613          	add	a2,s0,-232
    80005a94:	4581                	li	a1,0
    80005a96:	854a                	mv	a0,s2
    80005a98:	ffffe097          	auipc	ra,0xffffe
    80005a9c:	3de080e7          	jalr	990(ra) # 80003e76 <readi>
    80005aa0:	47c1                	li	a5,16
    80005aa2:	00f51b63          	bne	a0,a5,80005ab8 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005aa6:	f1845783          	lhu	a5,-232(s0)
    80005aaa:	e7a1                	bnez	a5,80005af2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005aac:	29c1                	addw	s3,s3,16
    80005aae:	04c92783          	lw	a5,76(s2)
    80005ab2:	fcf9ede3          	bltu	s3,a5,80005a8c <sys_unlink+0x140>
    80005ab6:	b781                	j	800059f6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005ab8:	00003517          	auipc	a0,0x3
    80005abc:	ca050513          	add	a0,a0,-864 # 80008758 <syscalls+0x2c8>
    80005ac0:	ffffb097          	auipc	ra,0xffffb
    80005ac4:	d4e080e7          	jalr	-690(ra) # 8000080e <panic>
    panic("unlink: writei");
    80005ac8:	00003517          	auipc	a0,0x3
    80005acc:	ca850513          	add	a0,a0,-856 # 80008770 <syscalls+0x2e0>
    80005ad0:	ffffb097          	auipc	ra,0xffffb
    80005ad4:	d3e080e7          	jalr	-706(ra) # 8000080e <panic>
    dp->nlink--;
    80005ad8:	04a4d783          	lhu	a5,74(s1)
    80005adc:	37fd                	addw	a5,a5,-1
    80005ade:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ae2:	8526                	mv	a0,s1
    80005ae4:	ffffe097          	auipc	ra,0xffffe
    80005ae8:	012080e7          	jalr	18(ra) # 80003af6 <iupdate>
    80005aec:	b781                	j	80005a2c <sys_unlink+0xe0>
    return -1;
    80005aee:	557d                	li	a0,-1
    80005af0:	a005                	j	80005b10 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005af2:	854a                	mv	a0,s2
    80005af4:	ffffe097          	auipc	ra,0xffffe
    80005af8:	330080e7          	jalr	816(ra) # 80003e24 <iunlockput>
  iunlockput(dp);
    80005afc:	8526                	mv	a0,s1
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	326080e7          	jalr	806(ra) # 80003e24 <iunlockput>
  end_op();
    80005b06:	fffff097          	auipc	ra,0xfffff
    80005b0a:	adc080e7          	jalr	-1316(ra) # 800045e2 <end_op>
  return -1;
    80005b0e:	557d                	li	a0,-1
}
    80005b10:	70ae                	ld	ra,232(sp)
    80005b12:	740e                	ld	s0,224(sp)
    80005b14:	64ee                	ld	s1,216(sp)
    80005b16:	694e                	ld	s2,208(sp)
    80005b18:	69ae                	ld	s3,200(sp)
    80005b1a:	616d                	add	sp,sp,240
    80005b1c:	8082                	ret

0000000080005b1e <sys_open>:

uint64
sys_open(void)
{
    80005b1e:	7131                	add	sp,sp,-192
    80005b20:	fd06                	sd	ra,184(sp)
    80005b22:	f922                	sd	s0,176(sp)
    80005b24:	f526                	sd	s1,168(sp)
    80005b26:	f14a                	sd	s2,160(sp)
    80005b28:	ed4e                	sd	s3,152(sp)
    80005b2a:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005b2c:	f4c40593          	add	a1,s0,-180
    80005b30:	4505                	li	a0,1
    80005b32:	ffffd097          	auipc	ra,0xffffd
    80005b36:	520080e7          	jalr	1312(ra) # 80003052 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b3a:	08000613          	li	a2,128
    80005b3e:	f5040593          	add	a1,s0,-176
    80005b42:	4501                	li	a0,0
    80005b44:	ffffd097          	auipc	ra,0xffffd
    80005b48:	54e080e7          	jalr	1358(ra) # 80003092 <argstr>
    80005b4c:	87aa                	mv	a5,a0
    return -1;
    80005b4e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b50:	0a07c863          	bltz	a5,80005c00 <sys_open+0xe2>

  begin_op();
    80005b54:	fffff097          	auipc	ra,0xfffff
    80005b58:	a14080e7          	jalr	-1516(ra) # 80004568 <begin_op>

  if(omode & O_CREATE){
    80005b5c:	f4c42783          	lw	a5,-180(s0)
    80005b60:	2007f793          	and	a5,a5,512
    80005b64:	cbdd                	beqz	a5,80005c1a <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80005b66:	4681                	li	a3,0
    80005b68:	4601                	li	a2,0
    80005b6a:	4589                	li	a1,2
    80005b6c:	f5040513          	add	a0,s0,-176
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	97a080e7          	jalr	-1670(ra) # 800054ea <create>
    80005b78:	84aa                	mv	s1,a0
    if(ip == 0){
    80005b7a:	c951                	beqz	a0,80005c0e <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005b7c:	04449703          	lh	a4,68(s1)
    80005b80:	478d                	li	a5,3
    80005b82:	00f71763          	bne	a4,a5,80005b90 <sys_open+0x72>
    80005b86:	0464d703          	lhu	a4,70(s1)
    80005b8a:	47a5                	li	a5,9
    80005b8c:	0ce7ec63          	bltu	a5,a4,80005c64 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005b90:	fffff097          	auipc	ra,0xfffff
    80005b94:	de0080e7          	jalr	-544(ra) # 80004970 <filealloc>
    80005b98:	892a                	mv	s2,a0
    80005b9a:	c56d                	beqz	a0,80005c84 <sys_open+0x166>
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	90c080e7          	jalr	-1780(ra) # 800054a8 <fdalloc>
    80005ba4:	89aa                	mv	s3,a0
    80005ba6:	0c054a63          	bltz	a0,80005c7a <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005baa:	04449703          	lh	a4,68(s1)
    80005bae:	478d                	li	a5,3
    80005bb0:	0ef70563          	beq	a4,a5,80005c9a <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005bb4:	4789                	li	a5,2
    80005bb6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005bba:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005bbe:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005bc2:	f4c42783          	lw	a5,-180(s0)
    80005bc6:	0017c713          	xor	a4,a5,1
    80005bca:	8b05                	and	a4,a4,1
    80005bcc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005bd0:	0037f713          	and	a4,a5,3
    80005bd4:	00e03733          	snez	a4,a4
    80005bd8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005bdc:	4007f793          	and	a5,a5,1024
    80005be0:	c791                	beqz	a5,80005bec <sys_open+0xce>
    80005be2:	04449703          	lh	a4,68(s1)
    80005be6:	4789                	li	a5,2
    80005be8:	0cf70063          	beq	a4,a5,80005ca8 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80005bec:	8526                	mv	a0,s1
    80005bee:	ffffe097          	auipc	ra,0xffffe
    80005bf2:	096080e7          	jalr	150(ra) # 80003c84 <iunlock>
  end_op();
    80005bf6:	fffff097          	auipc	ra,0xfffff
    80005bfa:	9ec080e7          	jalr	-1556(ra) # 800045e2 <end_op>

  return fd;
    80005bfe:	854e                	mv	a0,s3
}
    80005c00:	70ea                	ld	ra,184(sp)
    80005c02:	744a                	ld	s0,176(sp)
    80005c04:	74aa                	ld	s1,168(sp)
    80005c06:	790a                	ld	s2,160(sp)
    80005c08:	69ea                	ld	s3,152(sp)
    80005c0a:	6129                	add	sp,sp,192
    80005c0c:	8082                	ret
      end_op();
    80005c0e:	fffff097          	auipc	ra,0xfffff
    80005c12:	9d4080e7          	jalr	-1580(ra) # 800045e2 <end_op>
      return -1;
    80005c16:	557d                	li	a0,-1
    80005c18:	b7e5                	j	80005c00 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80005c1a:	f5040513          	add	a0,s0,-176
    80005c1e:	ffffe097          	auipc	ra,0xffffe
    80005c22:	74a080e7          	jalr	1866(ra) # 80004368 <namei>
    80005c26:	84aa                	mv	s1,a0
    80005c28:	c905                	beqz	a0,80005c58 <sys_open+0x13a>
    ilock(ip);
    80005c2a:	ffffe097          	auipc	ra,0xffffe
    80005c2e:	f98080e7          	jalr	-104(ra) # 80003bc2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c32:	04449703          	lh	a4,68(s1)
    80005c36:	4785                	li	a5,1
    80005c38:	f4f712e3          	bne	a4,a5,80005b7c <sys_open+0x5e>
    80005c3c:	f4c42783          	lw	a5,-180(s0)
    80005c40:	dba1                	beqz	a5,80005b90 <sys_open+0x72>
      iunlockput(ip);
    80005c42:	8526                	mv	a0,s1
    80005c44:	ffffe097          	auipc	ra,0xffffe
    80005c48:	1e0080e7          	jalr	480(ra) # 80003e24 <iunlockput>
      end_op();
    80005c4c:	fffff097          	auipc	ra,0xfffff
    80005c50:	996080e7          	jalr	-1642(ra) # 800045e2 <end_op>
      return -1;
    80005c54:	557d                	li	a0,-1
    80005c56:	b76d                	j	80005c00 <sys_open+0xe2>
      end_op();
    80005c58:	fffff097          	auipc	ra,0xfffff
    80005c5c:	98a080e7          	jalr	-1654(ra) # 800045e2 <end_op>
      return -1;
    80005c60:	557d                	li	a0,-1
    80005c62:	bf79                	j	80005c00 <sys_open+0xe2>
    iunlockput(ip);
    80005c64:	8526                	mv	a0,s1
    80005c66:	ffffe097          	auipc	ra,0xffffe
    80005c6a:	1be080e7          	jalr	446(ra) # 80003e24 <iunlockput>
    end_op();
    80005c6e:	fffff097          	auipc	ra,0xfffff
    80005c72:	974080e7          	jalr	-1676(ra) # 800045e2 <end_op>
    return -1;
    80005c76:	557d                	li	a0,-1
    80005c78:	b761                	j	80005c00 <sys_open+0xe2>
      fileclose(f);
    80005c7a:	854a                	mv	a0,s2
    80005c7c:	fffff097          	auipc	ra,0xfffff
    80005c80:	db0080e7          	jalr	-592(ra) # 80004a2c <fileclose>
    iunlockput(ip);
    80005c84:	8526                	mv	a0,s1
    80005c86:	ffffe097          	auipc	ra,0xffffe
    80005c8a:	19e080e7          	jalr	414(ra) # 80003e24 <iunlockput>
    end_op();
    80005c8e:	fffff097          	auipc	ra,0xfffff
    80005c92:	954080e7          	jalr	-1708(ra) # 800045e2 <end_op>
    return -1;
    80005c96:	557d                	li	a0,-1
    80005c98:	b7a5                	j	80005c00 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80005c9a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005c9e:	04649783          	lh	a5,70(s1)
    80005ca2:	02f91223          	sh	a5,36(s2)
    80005ca6:	bf21                	j	80005bbe <sys_open+0xa0>
    itrunc(ip);
    80005ca8:	8526                	mv	a0,s1
    80005caa:	ffffe097          	auipc	ra,0xffffe
    80005cae:	026080e7          	jalr	38(ra) # 80003cd0 <itrunc>
    80005cb2:	bf2d                	j	80005bec <sys_open+0xce>

0000000080005cb4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005cb4:	7175                	add	sp,sp,-144
    80005cb6:	e506                	sd	ra,136(sp)
    80005cb8:	e122                	sd	s0,128(sp)
    80005cba:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005cbc:	fffff097          	auipc	ra,0xfffff
    80005cc0:	8ac080e7          	jalr	-1876(ra) # 80004568 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005cc4:	08000613          	li	a2,128
    80005cc8:	f7040593          	add	a1,s0,-144
    80005ccc:	4501                	li	a0,0
    80005cce:	ffffd097          	auipc	ra,0xffffd
    80005cd2:	3c4080e7          	jalr	964(ra) # 80003092 <argstr>
    80005cd6:	02054963          	bltz	a0,80005d08 <sys_mkdir+0x54>
    80005cda:	4681                	li	a3,0
    80005cdc:	4601                	li	a2,0
    80005cde:	4585                	li	a1,1
    80005ce0:	f7040513          	add	a0,s0,-144
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	806080e7          	jalr	-2042(ra) # 800054ea <create>
    80005cec:	cd11                	beqz	a0,80005d08 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005cee:	ffffe097          	auipc	ra,0xffffe
    80005cf2:	136080e7          	jalr	310(ra) # 80003e24 <iunlockput>
  end_op();
    80005cf6:	fffff097          	auipc	ra,0xfffff
    80005cfa:	8ec080e7          	jalr	-1812(ra) # 800045e2 <end_op>
  return 0;
    80005cfe:	4501                	li	a0,0
}
    80005d00:	60aa                	ld	ra,136(sp)
    80005d02:	640a                	ld	s0,128(sp)
    80005d04:	6149                	add	sp,sp,144
    80005d06:	8082                	ret
    end_op();
    80005d08:	fffff097          	auipc	ra,0xfffff
    80005d0c:	8da080e7          	jalr	-1830(ra) # 800045e2 <end_op>
    return -1;
    80005d10:	557d                	li	a0,-1
    80005d12:	b7fd                	j	80005d00 <sys_mkdir+0x4c>

0000000080005d14 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d14:	7135                	add	sp,sp,-160
    80005d16:	ed06                	sd	ra,152(sp)
    80005d18:	e922                	sd	s0,144(sp)
    80005d1a:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d1c:	fffff097          	auipc	ra,0xfffff
    80005d20:	84c080e7          	jalr	-1972(ra) # 80004568 <begin_op>
  argint(1, &major);
    80005d24:	f6c40593          	add	a1,s0,-148
    80005d28:	4505                	li	a0,1
    80005d2a:	ffffd097          	auipc	ra,0xffffd
    80005d2e:	328080e7          	jalr	808(ra) # 80003052 <argint>
  argint(2, &minor);
    80005d32:	f6840593          	add	a1,s0,-152
    80005d36:	4509                	li	a0,2
    80005d38:	ffffd097          	auipc	ra,0xffffd
    80005d3c:	31a080e7          	jalr	794(ra) # 80003052 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d40:	08000613          	li	a2,128
    80005d44:	f7040593          	add	a1,s0,-144
    80005d48:	4501                	li	a0,0
    80005d4a:	ffffd097          	auipc	ra,0xffffd
    80005d4e:	348080e7          	jalr	840(ra) # 80003092 <argstr>
    80005d52:	02054b63          	bltz	a0,80005d88 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005d56:	f6841683          	lh	a3,-152(s0)
    80005d5a:	f6c41603          	lh	a2,-148(s0)
    80005d5e:	458d                	li	a1,3
    80005d60:	f7040513          	add	a0,s0,-144
    80005d64:	fffff097          	auipc	ra,0xfffff
    80005d68:	786080e7          	jalr	1926(ra) # 800054ea <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d6c:	cd11                	beqz	a0,80005d88 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d6e:	ffffe097          	auipc	ra,0xffffe
    80005d72:	0b6080e7          	jalr	182(ra) # 80003e24 <iunlockput>
  end_op();
    80005d76:	fffff097          	auipc	ra,0xfffff
    80005d7a:	86c080e7          	jalr	-1940(ra) # 800045e2 <end_op>
  return 0;
    80005d7e:	4501                	li	a0,0
}
    80005d80:	60ea                	ld	ra,152(sp)
    80005d82:	644a                	ld	s0,144(sp)
    80005d84:	610d                	add	sp,sp,160
    80005d86:	8082                	ret
    end_op();
    80005d88:	fffff097          	auipc	ra,0xfffff
    80005d8c:	85a080e7          	jalr	-1958(ra) # 800045e2 <end_op>
    return -1;
    80005d90:	557d                	li	a0,-1
    80005d92:	b7fd                	j	80005d80 <sys_mknod+0x6c>

0000000080005d94 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005d94:	7135                	add	sp,sp,-160
    80005d96:	ed06                	sd	ra,152(sp)
    80005d98:	e922                	sd	s0,144(sp)
    80005d9a:	e526                	sd	s1,136(sp)
    80005d9c:	e14a                	sd	s2,128(sp)
    80005d9e:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005da0:	ffffc097          	auipc	ra,0xffffc
    80005da4:	caa080e7          	jalr	-854(ra) # 80001a4a <myproc>
    80005da8:	892a                	mv	s2,a0
  
  begin_op();
    80005daa:	ffffe097          	auipc	ra,0xffffe
    80005dae:	7be080e7          	jalr	1982(ra) # 80004568 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005db2:	08000613          	li	a2,128
    80005db6:	f6040593          	add	a1,s0,-160
    80005dba:	4501                	li	a0,0
    80005dbc:	ffffd097          	auipc	ra,0xffffd
    80005dc0:	2d6080e7          	jalr	726(ra) # 80003092 <argstr>
    80005dc4:	04054b63          	bltz	a0,80005e1a <sys_chdir+0x86>
    80005dc8:	f6040513          	add	a0,s0,-160
    80005dcc:	ffffe097          	auipc	ra,0xffffe
    80005dd0:	59c080e7          	jalr	1436(ra) # 80004368 <namei>
    80005dd4:	84aa                	mv	s1,a0
    80005dd6:	c131                	beqz	a0,80005e1a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005dd8:	ffffe097          	auipc	ra,0xffffe
    80005ddc:	dea080e7          	jalr	-534(ra) # 80003bc2 <ilock>
  if(ip->type != T_DIR){
    80005de0:	04449703          	lh	a4,68(s1)
    80005de4:	4785                	li	a5,1
    80005de6:	04f71063          	bne	a4,a5,80005e26 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005dea:	8526                	mv	a0,s1
    80005dec:	ffffe097          	auipc	ra,0xffffe
    80005df0:	e98080e7          	jalr	-360(ra) # 80003c84 <iunlock>
  iput(p->cwd);
    80005df4:	15093503          	ld	a0,336(s2)
    80005df8:	ffffe097          	auipc	ra,0xffffe
    80005dfc:	f84080e7          	jalr	-124(ra) # 80003d7c <iput>
  end_op();
    80005e00:	ffffe097          	auipc	ra,0xffffe
    80005e04:	7e2080e7          	jalr	2018(ra) # 800045e2 <end_op>
  p->cwd = ip;
    80005e08:	14993823          	sd	s1,336(s2)
  return 0;
    80005e0c:	4501                	li	a0,0
}
    80005e0e:	60ea                	ld	ra,152(sp)
    80005e10:	644a                	ld	s0,144(sp)
    80005e12:	64aa                	ld	s1,136(sp)
    80005e14:	690a                	ld	s2,128(sp)
    80005e16:	610d                	add	sp,sp,160
    80005e18:	8082                	ret
    end_op();
    80005e1a:	ffffe097          	auipc	ra,0xffffe
    80005e1e:	7c8080e7          	jalr	1992(ra) # 800045e2 <end_op>
    return -1;
    80005e22:	557d                	li	a0,-1
    80005e24:	b7ed                	j	80005e0e <sys_chdir+0x7a>
    iunlockput(ip);
    80005e26:	8526                	mv	a0,s1
    80005e28:	ffffe097          	auipc	ra,0xffffe
    80005e2c:	ffc080e7          	jalr	-4(ra) # 80003e24 <iunlockput>
    end_op();
    80005e30:	ffffe097          	auipc	ra,0xffffe
    80005e34:	7b2080e7          	jalr	1970(ra) # 800045e2 <end_op>
    return -1;
    80005e38:	557d                	li	a0,-1
    80005e3a:	bfd1                	j	80005e0e <sys_chdir+0x7a>

0000000080005e3c <sys_exec>:

uint64
sys_exec(void)
{
    80005e3c:	7121                	add	sp,sp,-448
    80005e3e:	ff06                	sd	ra,440(sp)
    80005e40:	fb22                	sd	s0,432(sp)
    80005e42:	f726                	sd	s1,424(sp)
    80005e44:	f34a                	sd	s2,416(sp)
    80005e46:	ef4e                	sd	s3,408(sp)
    80005e48:	eb52                	sd	s4,400(sp)
    80005e4a:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005e4c:	e4840593          	add	a1,s0,-440
    80005e50:	4505                	li	a0,1
    80005e52:	ffffd097          	auipc	ra,0xffffd
    80005e56:	220080e7          	jalr	544(ra) # 80003072 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005e5a:	08000613          	li	a2,128
    80005e5e:	f5040593          	add	a1,s0,-176
    80005e62:	4501                	li	a0,0
    80005e64:	ffffd097          	auipc	ra,0xffffd
    80005e68:	22e080e7          	jalr	558(ra) # 80003092 <argstr>
    80005e6c:	87aa                	mv	a5,a0
    return -1;
    80005e6e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005e70:	0c07c263          	bltz	a5,80005f34 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005e74:	10000613          	li	a2,256
    80005e78:	4581                	li	a1,0
    80005e7a:	e5040513          	add	a0,s0,-432
    80005e7e:	ffffb097          	auipc	ra,0xffffb
    80005e82:	f4a080e7          	jalr	-182(ra) # 80000dc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005e86:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005e8a:	89a6                	mv	s3,s1
    80005e8c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005e8e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005e92:	00391513          	sll	a0,s2,0x3
    80005e96:	e4040593          	add	a1,s0,-448
    80005e9a:	e4843783          	ld	a5,-440(s0)
    80005e9e:	953e                	add	a0,a0,a5
    80005ea0:	ffffd097          	auipc	ra,0xffffd
    80005ea4:	114080e7          	jalr	276(ra) # 80002fb4 <fetchaddr>
    80005ea8:	02054a63          	bltz	a0,80005edc <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005eac:	e4043783          	ld	a5,-448(s0)
    80005eb0:	c3b9                	beqz	a5,80005ef6 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005eb2:	ffffb097          	auipc	ra,0xffffb
    80005eb6:	d2a080e7          	jalr	-726(ra) # 80000bdc <kalloc>
    80005eba:	85aa                	mv	a1,a0
    80005ebc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ec0:	cd11                	beqz	a0,80005edc <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ec2:	6605                	lui	a2,0x1
    80005ec4:	e4043503          	ld	a0,-448(s0)
    80005ec8:	ffffd097          	auipc	ra,0xffffd
    80005ecc:	13e080e7          	jalr	318(ra) # 80003006 <fetchstr>
    80005ed0:	00054663          	bltz	a0,80005edc <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005ed4:	0905                	add	s2,s2,1
    80005ed6:	09a1                	add	s3,s3,8
    80005ed8:	fb491de3          	bne	s2,s4,80005e92 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005edc:	f5040913          	add	s2,s0,-176
    80005ee0:	6088                	ld	a0,0(s1)
    80005ee2:	c921                	beqz	a0,80005f32 <sys_exec+0xf6>
    kfree(argv[i]);
    80005ee4:	ffffb097          	auipc	ra,0xffffb
    80005ee8:	bfa080e7          	jalr	-1030(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005eec:	04a1                	add	s1,s1,8
    80005eee:	ff2499e3          	bne	s1,s2,80005ee0 <sys_exec+0xa4>
  return -1;
    80005ef2:	557d                	li	a0,-1
    80005ef4:	a081                	j	80005f34 <sys_exec+0xf8>
      argv[i] = 0;
    80005ef6:	0009079b          	sext.w	a5,s2
    80005efa:	078e                	sll	a5,a5,0x3
    80005efc:	fd078793          	add	a5,a5,-48
    80005f00:	97a2                	add	a5,a5,s0
    80005f02:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005f06:	e5040593          	add	a1,s0,-432
    80005f0a:	f5040513          	add	a0,s0,-176
    80005f0e:	fffff097          	auipc	ra,0xfffff
    80005f12:	194080e7          	jalr	404(ra) # 800050a2 <exec>
    80005f16:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f18:	f5040993          	add	s3,s0,-176
    80005f1c:	6088                	ld	a0,0(s1)
    80005f1e:	c901                	beqz	a0,80005f2e <sys_exec+0xf2>
    kfree(argv[i]);
    80005f20:	ffffb097          	auipc	ra,0xffffb
    80005f24:	bbe080e7          	jalr	-1090(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f28:	04a1                	add	s1,s1,8
    80005f2a:	ff3499e3          	bne	s1,s3,80005f1c <sys_exec+0xe0>
  return ret;
    80005f2e:	854a                	mv	a0,s2
    80005f30:	a011                	j	80005f34 <sys_exec+0xf8>
  return -1;
    80005f32:	557d                	li	a0,-1
}
    80005f34:	70fa                	ld	ra,440(sp)
    80005f36:	745a                	ld	s0,432(sp)
    80005f38:	74ba                	ld	s1,424(sp)
    80005f3a:	791a                	ld	s2,416(sp)
    80005f3c:	69fa                	ld	s3,408(sp)
    80005f3e:	6a5a                	ld	s4,400(sp)
    80005f40:	6139                	add	sp,sp,448
    80005f42:	8082                	ret

0000000080005f44 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005f44:	7139                	add	sp,sp,-64
    80005f46:	fc06                	sd	ra,56(sp)
    80005f48:	f822                	sd	s0,48(sp)
    80005f4a:	f426                	sd	s1,40(sp)
    80005f4c:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005f4e:	ffffc097          	auipc	ra,0xffffc
    80005f52:	afc080e7          	jalr	-1284(ra) # 80001a4a <myproc>
    80005f56:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005f58:	fd840593          	add	a1,s0,-40
    80005f5c:	4501                	li	a0,0
    80005f5e:	ffffd097          	auipc	ra,0xffffd
    80005f62:	114080e7          	jalr	276(ra) # 80003072 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005f66:	fc840593          	add	a1,s0,-56
    80005f6a:	fd040513          	add	a0,s0,-48
    80005f6e:	fffff097          	auipc	ra,0xfffff
    80005f72:	dea080e7          	jalr	-534(ra) # 80004d58 <pipealloc>
    return -1;
    80005f76:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005f78:	0c054463          	bltz	a0,80006040 <sys_pipe+0xfc>
  fd0 = -1;
    80005f7c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005f80:	fd043503          	ld	a0,-48(s0)
    80005f84:	fffff097          	auipc	ra,0xfffff
    80005f88:	524080e7          	jalr	1316(ra) # 800054a8 <fdalloc>
    80005f8c:	fca42223          	sw	a0,-60(s0)
    80005f90:	08054b63          	bltz	a0,80006026 <sys_pipe+0xe2>
    80005f94:	fc843503          	ld	a0,-56(s0)
    80005f98:	fffff097          	auipc	ra,0xfffff
    80005f9c:	510080e7          	jalr	1296(ra) # 800054a8 <fdalloc>
    80005fa0:	fca42023          	sw	a0,-64(s0)
    80005fa4:	06054863          	bltz	a0,80006014 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005fa8:	4691                	li	a3,4
    80005faa:	fc440613          	add	a2,s0,-60
    80005fae:	fd843583          	ld	a1,-40(s0)
    80005fb2:	68a8                	ld	a0,80(s1)
    80005fb4:	ffffb097          	auipc	ra,0xffffb
    80005fb8:	7d0080e7          	jalr	2000(ra) # 80001784 <copyout>
    80005fbc:	02054063          	bltz	a0,80005fdc <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005fc0:	4691                	li	a3,4
    80005fc2:	fc040613          	add	a2,s0,-64
    80005fc6:	fd843583          	ld	a1,-40(s0)
    80005fca:	0591                	add	a1,a1,4
    80005fcc:	68a8                	ld	a0,80(s1)
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	7b6080e7          	jalr	1974(ra) # 80001784 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005fd6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005fd8:	06055463          	bgez	a0,80006040 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005fdc:	fc442783          	lw	a5,-60(s0)
    80005fe0:	07e9                	add	a5,a5,26
    80005fe2:	078e                	sll	a5,a5,0x3
    80005fe4:	97a6                	add	a5,a5,s1
    80005fe6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005fea:	fc042783          	lw	a5,-64(s0)
    80005fee:	07e9                	add	a5,a5,26
    80005ff0:	078e                	sll	a5,a5,0x3
    80005ff2:	94be                	add	s1,s1,a5
    80005ff4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005ff8:	fd043503          	ld	a0,-48(s0)
    80005ffc:	fffff097          	auipc	ra,0xfffff
    80006000:	a30080e7          	jalr	-1488(ra) # 80004a2c <fileclose>
    fileclose(wf);
    80006004:	fc843503          	ld	a0,-56(s0)
    80006008:	fffff097          	auipc	ra,0xfffff
    8000600c:	a24080e7          	jalr	-1500(ra) # 80004a2c <fileclose>
    return -1;
    80006010:	57fd                	li	a5,-1
    80006012:	a03d                	j	80006040 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006014:	fc442783          	lw	a5,-60(s0)
    80006018:	0007c763          	bltz	a5,80006026 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000601c:	07e9                	add	a5,a5,26
    8000601e:	078e                	sll	a5,a5,0x3
    80006020:	97a6                	add	a5,a5,s1
    80006022:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006026:	fd043503          	ld	a0,-48(s0)
    8000602a:	fffff097          	auipc	ra,0xfffff
    8000602e:	a02080e7          	jalr	-1534(ra) # 80004a2c <fileclose>
    fileclose(wf);
    80006032:	fc843503          	ld	a0,-56(s0)
    80006036:	fffff097          	auipc	ra,0xfffff
    8000603a:	9f6080e7          	jalr	-1546(ra) # 80004a2c <fileclose>
    return -1;
    8000603e:	57fd                	li	a5,-1
}
    80006040:	853e                	mv	a0,a5
    80006042:	70e2                	ld	ra,56(sp)
    80006044:	7442                	ld	s0,48(sp)
    80006046:	74a2                	ld	s1,40(sp)
    80006048:	6121                	add	sp,sp,64
    8000604a:	8082                	ret
    8000604c:	0000                	unimp
	...

0000000080006050 <kernelvec>:
    80006050:	7111                	add	sp,sp,-256
    80006052:	e006                	sd	ra,0(sp)
    80006054:	e40a                	sd	sp,8(sp)
    80006056:	e80e                	sd	gp,16(sp)
    80006058:	ec12                	sd	tp,24(sp)
    8000605a:	f016                	sd	t0,32(sp)
    8000605c:	f41a                	sd	t1,40(sp)
    8000605e:	f81e                	sd	t2,48(sp)
    80006060:	e4aa                	sd	a0,72(sp)
    80006062:	e8ae                	sd	a1,80(sp)
    80006064:	ecb2                	sd	a2,88(sp)
    80006066:	f0b6                	sd	a3,96(sp)
    80006068:	f4ba                	sd	a4,104(sp)
    8000606a:	f8be                	sd	a5,112(sp)
    8000606c:	fcc2                	sd	a6,120(sp)
    8000606e:	e146                	sd	a7,128(sp)
    80006070:	edf2                	sd	t3,216(sp)
    80006072:	f1f6                	sd	t4,224(sp)
    80006074:	f5fa                	sd	t5,232(sp)
    80006076:	f9fe                	sd	t6,240(sp)
    80006078:	e29fc0ef          	jal	80002ea0 <kerneltrap>
    8000607c:	6082                	ld	ra,0(sp)
    8000607e:	6122                	ld	sp,8(sp)
    80006080:	61c2                	ld	gp,16(sp)
    80006082:	7282                	ld	t0,32(sp)
    80006084:	7322                	ld	t1,40(sp)
    80006086:	73c2                	ld	t2,48(sp)
    80006088:	6526                	ld	a0,72(sp)
    8000608a:	65c6                	ld	a1,80(sp)
    8000608c:	6666                	ld	a2,88(sp)
    8000608e:	7686                	ld	a3,96(sp)
    80006090:	7726                	ld	a4,104(sp)
    80006092:	77c6                	ld	a5,112(sp)
    80006094:	7866                	ld	a6,120(sp)
    80006096:	688a                	ld	a7,128(sp)
    80006098:	6e6e                	ld	t3,216(sp)
    8000609a:	7e8e                	ld	t4,224(sp)
    8000609c:	7f2e                	ld	t5,232(sp)
    8000609e:	7fce                	ld	t6,240(sp)
    800060a0:	6111                	add	sp,sp,256
    800060a2:	10200073          	sret
	...

00000000800060ae <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    800060ae:	1141                	add	sp,sp,-16
    800060b0:	e422                	sd	s0,8(sp)
    800060b2:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800060b4:	0c0007b7          	lui	a5,0xc000
    800060b8:	4705                	li	a4,1
    800060ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800060bc:	c3d8                	sw	a4,4(a5)
}
    800060be:	6422                	ld	s0,8(sp)
    800060c0:	0141                	add	sp,sp,16
    800060c2:	8082                	ret

00000000800060c4 <plicinithart>:

void
plicinithart(void)
{
    800060c4:	1141                	add	sp,sp,-16
    800060c6:	e406                	sd	ra,8(sp)
    800060c8:	e022                	sd	s0,0(sp)
    800060ca:	0800                	add	s0,sp,16
  int hart = cpuid();
    800060cc:	ffffc097          	auipc	ra,0xffffc
    800060d0:	94c080e7          	jalr	-1716(ra) # 80001a18 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800060d4:	0085171b          	sllw	a4,a0,0x8
    800060d8:	0c0027b7          	lui	a5,0xc002
    800060dc:	97ba                	add	a5,a5,a4
    800060de:	40200713          	li	a4,1026
    800060e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800060e6:	00d5151b          	sllw	a0,a0,0xd
    800060ea:	0c2017b7          	lui	a5,0xc201
    800060ee:	97aa                	add	a5,a5,a0
    800060f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800060f4:	60a2                	ld	ra,8(sp)
    800060f6:	6402                	ld	s0,0(sp)
    800060f8:	0141                	add	sp,sp,16
    800060fa:	8082                	ret

00000000800060fc <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    800060fc:	1141                	add	sp,sp,-16
    800060fe:	e406                	sd	ra,8(sp)
    80006100:	e022                	sd	s0,0(sp)
    80006102:	0800                	add	s0,sp,16
  int hart = cpuid();
    80006104:	ffffc097          	auipc	ra,0xffffc
    80006108:	914080e7          	jalr	-1772(ra) # 80001a18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000610c:	00d5151b          	sllw	a0,a0,0xd
    80006110:	0c2017b7          	lui	a5,0xc201
    80006114:	97aa                	add	a5,a5,a0
  return irq;
}
    80006116:	43c8                	lw	a0,4(a5)
    80006118:	60a2                	ld	ra,8(sp)
    8000611a:	6402                	ld	s0,0(sp)
    8000611c:	0141                	add	sp,sp,16
    8000611e:	8082                	ret

0000000080006120 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    80006120:	1101                	add	sp,sp,-32
    80006122:	ec06                	sd	ra,24(sp)
    80006124:	e822                	sd	s0,16(sp)
    80006126:	e426                	sd	s1,8(sp)
    80006128:	1000                	add	s0,sp,32
    8000612a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000612c:	ffffc097          	auipc	ra,0xffffc
    80006130:	8ec080e7          	jalr	-1812(ra) # 80001a18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006134:	00d5151b          	sllw	a0,a0,0xd
    80006138:	0c2017b7          	lui	a5,0xc201
    8000613c:	97aa                	add	a5,a5,a0
    8000613e:	c3c4                	sw	s1,4(a5)
}
    80006140:	60e2                	ld	ra,24(sp)
    80006142:	6442                	ld	s0,16(sp)
    80006144:	64a2                	ld	s1,8(sp)
    80006146:	6105                	add	sp,sp,32
    80006148:	8082                	ret

000000008000614a <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    8000614a:	1141                	add	sp,sp,-16
    8000614c:	e406                	sd	ra,8(sp)
    8000614e:	e022                	sd	s0,0(sp)
    80006150:	0800                	add	s0,sp,16
  if(i >= NUM)
    80006152:	479d                	li	a5,7
    80006154:	04a7cc63          	blt	a5,a0,800061ac <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006158:	0001c797          	auipc	a5,0x1c
    8000615c:	01878793          	add	a5,a5,24 # 80022170 <disk>
    80006160:	97aa                	add	a5,a5,a0
    80006162:	0187c783          	lbu	a5,24(a5)
    80006166:	ebb9                	bnez	a5,800061bc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006168:	00451693          	sll	a3,a0,0x4
    8000616c:	0001c797          	auipc	a5,0x1c
    80006170:	00478793          	add	a5,a5,4 # 80022170 <disk>
    80006174:	6398                	ld	a4,0(a5)
    80006176:	9736                	add	a4,a4,a3
    80006178:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000617c:	6398                	ld	a4,0(a5)
    8000617e:	9736                	add	a4,a4,a3
    80006180:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006184:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006188:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000618c:	97aa                	add	a5,a5,a0
    8000618e:	4705                	li	a4,1
    80006190:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006194:	0001c517          	auipc	a0,0x1c
    80006198:	ff450513          	add	a0,a0,-12 # 80022188 <disk+0x18>
    8000619c:	ffffc097          	auipc	ra,0xffffc
    800061a0:	498080e7          	jalr	1176(ra) # 80002634 <wakeup>
}
    800061a4:	60a2                	ld	ra,8(sp)
    800061a6:	6402                	ld	s0,0(sp)
    800061a8:	0141                	add	sp,sp,16
    800061aa:	8082                	ret
    panic("free_desc 1");
    800061ac:	00002517          	auipc	a0,0x2
    800061b0:	5d450513          	add	a0,a0,1492 # 80008780 <syscalls+0x2f0>
    800061b4:	ffffa097          	auipc	ra,0xffffa
    800061b8:	65a080e7          	jalr	1626(ra) # 8000080e <panic>
    panic("free_desc 2");
    800061bc:	00002517          	auipc	a0,0x2
    800061c0:	5d450513          	add	a0,a0,1492 # 80008790 <syscalls+0x300>
    800061c4:	ffffa097          	auipc	ra,0xffffa
    800061c8:	64a080e7          	jalr	1610(ra) # 8000080e <panic>

00000000800061cc <virtio_disk_init>:
{
    800061cc:	1101                	add	sp,sp,-32
    800061ce:	ec06                	sd	ra,24(sp)
    800061d0:	e822                	sd	s0,16(sp)
    800061d2:	e426                	sd	s1,8(sp)
    800061d4:	e04a                	sd	s2,0(sp)
    800061d6:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800061d8:	00002597          	auipc	a1,0x2
    800061dc:	5c858593          	add	a1,a1,1480 # 800087a0 <syscalls+0x310>
    800061e0:	0001c517          	auipc	a0,0x1c
    800061e4:	0b850513          	add	a0,a0,184 # 80022298 <disk+0x128>
    800061e8:	ffffb097          	auipc	ra,0xffffb
    800061ec:	a54080e7          	jalr	-1452(ra) # 80000c3c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061f0:	100017b7          	lui	a5,0x10001
    800061f4:	4398                	lw	a4,0(a5)
    800061f6:	2701                	sext.w	a4,a4
    800061f8:	747277b7          	lui	a5,0x74727
    800061fc:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006200:	14f71b63          	bne	a4,a5,80006356 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006204:	100017b7          	lui	a5,0x10001
    80006208:	43dc                	lw	a5,4(a5)
    8000620a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000620c:	4709                	li	a4,2
    8000620e:	14e79463          	bne	a5,a4,80006356 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006212:	100017b7          	lui	a5,0x10001
    80006216:	479c                	lw	a5,8(a5)
    80006218:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000621a:	12e79e63          	bne	a5,a4,80006356 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000621e:	100017b7          	lui	a5,0x10001
    80006222:	47d8                	lw	a4,12(a5)
    80006224:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006226:	554d47b7          	lui	a5,0x554d4
    8000622a:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000622e:	12f71463          	bne	a4,a5,80006356 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006232:	100017b7          	lui	a5,0x10001
    80006236:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000623a:	4705                	li	a4,1
    8000623c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000623e:	470d                	li	a4,3
    80006240:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006242:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006244:	c7ffe6b7          	lui	a3,0xc7ffe
    80006248:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc4af>
    8000624c:	8f75                	and	a4,a4,a3
    8000624e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006250:	472d                	li	a4,11
    80006252:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006254:	5bbc                	lw	a5,112(a5)
    80006256:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000625a:	8ba1                	and	a5,a5,8
    8000625c:	10078563          	beqz	a5,80006366 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006260:	100017b7          	lui	a5,0x10001
    80006264:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006268:	43fc                	lw	a5,68(a5)
    8000626a:	2781                	sext.w	a5,a5
    8000626c:	10079563          	bnez	a5,80006376 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006270:	100017b7          	lui	a5,0x10001
    80006274:	5bdc                	lw	a5,52(a5)
    80006276:	2781                	sext.w	a5,a5
  if(max == 0)
    80006278:	10078763          	beqz	a5,80006386 <virtio_disk_init+0x1ba>
  if(max < NUM)
    8000627c:	471d                	li	a4,7
    8000627e:	10f77c63          	bgeu	a4,a5,80006396 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80006282:	ffffb097          	auipc	ra,0xffffb
    80006286:	95a080e7          	jalr	-1702(ra) # 80000bdc <kalloc>
    8000628a:	0001c497          	auipc	s1,0x1c
    8000628e:	ee648493          	add	s1,s1,-282 # 80022170 <disk>
    80006292:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006294:	ffffb097          	auipc	ra,0xffffb
    80006298:	948080e7          	jalr	-1720(ra) # 80000bdc <kalloc>
    8000629c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	93e080e7          	jalr	-1730(ra) # 80000bdc <kalloc>
    800062a6:	87aa                	mv	a5,a0
    800062a8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800062aa:	6088                	ld	a0,0(s1)
    800062ac:	cd6d                	beqz	a0,800063a6 <virtio_disk_init+0x1da>
    800062ae:	0001c717          	auipc	a4,0x1c
    800062b2:	eca73703          	ld	a4,-310(a4) # 80022178 <disk+0x8>
    800062b6:	cb65                	beqz	a4,800063a6 <virtio_disk_init+0x1da>
    800062b8:	c7fd                	beqz	a5,800063a6 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800062ba:	6605                	lui	a2,0x1
    800062bc:	4581                	li	a1,0
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	b0a080e7          	jalr	-1270(ra) # 80000dc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    800062c6:	0001c497          	auipc	s1,0x1c
    800062ca:	eaa48493          	add	s1,s1,-342 # 80022170 <disk>
    800062ce:	6605                	lui	a2,0x1
    800062d0:	4581                	li	a1,0
    800062d2:	6488                	ld	a0,8(s1)
    800062d4:	ffffb097          	auipc	ra,0xffffb
    800062d8:	af4080e7          	jalr	-1292(ra) # 80000dc8 <memset>
  memset(disk.used, 0, PGSIZE);
    800062dc:	6605                	lui	a2,0x1
    800062de:	4581                	li	a1,0
    800062e0:	6888                	ld	a0,16(s1)
    800062e2:	ffffb097          	auipc	ra,0xffffb
    800062e6:	ae6080e7          	jalr	-1306(ra) # 80000dc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800062ea:	100017b7          	lui	a5,0x10001
    800062ee:	4721                	li	a4,8
    800062f0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800062f2:	4098                	lw	a4,0(s1)
    800062f4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800062f8:	40d8                	lw	a4,4(s1)
    800062fa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800062fe:	6498                	ld	a4,8(s1)
    80006300:	0007069b          	sext.w	a3,a4
    80006304:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006308:	9701                	sra	a4,a4,0x20
    8000630a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000630e:	6898                	ld	a4,16(s1)
    80006310:	0007069b          	sext.w	a3,a4
    80006314:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006318:	9701                	sra	a4,a4,0x20
    8000631a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000631e:	4705                	li	a4,1
    80006320:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006322:	00e48c23          	sb	a4,24(s1)
    80006326:	00e48ca3          	sb	a4,25(s1)
    8000632a:	00e48d23          	sb	a4,26(s1)
    8000632e:	00e48da3          	sb	a4,27(s1)
    80006332:	00e48e23          	sb	a4,28(s1)
    80006336:	00e48ea3          	sb	a4,29(s1)
    8000633a:	00e48f23          	sb	a4,30(s1)
    8000633e:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006342:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006346:	0727a823          	sw	s2,112(a5)
}
    8000634a:	60e2                	ld	ra,24(sp)
    8000634c:	6442                	ld	s0,16(sp)
    8000634e:	64a2                	ld	s1,8(sp)
    80006350:	6902                	ld	s2,0(sp)
    80006352:	6105                	add	sp,sp,32
    80006354:	8082                	ret
    panic("could not find virtio disk");
    80006356:	00002517          	auipc	a0,0x2
    8000635a:	45a50513          	add	a0,a0,1114 # 800087b0 <syscalls+0x320>
    8000635e:	ffffa097          	auipc	ra,0xffffa
    80006362:	4b0080e7          	jalr	1200(ra) # 8000080e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006366:	00002517          	auipc	a0,0x2
    8000636a:	46a50513          	add	a0,a0,1130 # 800087d0 <syscalls+0x340>
    8000636e:	ffffa097          	auipc	ra,0xffffa
    80006372:	4a0080e7          	jalr	1184(ra) # 8000080e <panic>
    panic("virtio disk should not be ready");
    80006376:	00002517          	auipc	a0,0x2
    8000637a:	47a50513          	add	a0,a0,1146 # 800087f0 <syscalls+0x360>
    8000637e:	ffffa097          	auipc	ra,0xffffa
    80006382:	490080e7          	jalr	1168(ra) # 8000080e <panic>
    panic("virtio disk has no queue 0");
    80006386:	00002517          	auipc	a0,0x2
    8000638a:	48a50513          	add	a0,a0,1162 # 80008810 <syscalls+0x380>
    8000638e:	ffffa097          	auipc	ra,0xffffa
    80006392:	480080e7          	jalr	1152(ra) # 8000080e <panic>
    panic("virtio disk max queue too short");
    80006396:	00002517          	auipc	a0,0x2
    8000639a:	49a50513          	add	a0,a0,1178 # 80008830 <syscalls+0x3a0>
    8000639e:	ffffa097          	auipc	ra,0xffffa
    800063a2:	470080e7          	jalr	1136(ra) # 8000080e <panic>
    panic("virtio disk kalloc");
    800063a6:	00002517          	auipc	a0,0x2
    800063aa:	4aa50513          	add	a0,a0,1194 # 80008850 <syscalls+0x3c0>
    800063ae:	ffffa097          	auipc	ra,0xffffa
    800063b2:	460080e7          	jalr	1120(ra) # 8000080e <panic>

00000000800063b6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800063b6:	7159                	add	sp,sp,-112
    800063b8:	f486                	sd	ra,104(sp)
    800063ba:	f0a2                	sd	s0,96(sp)
    800063bc:	eca6                	sd	s1,88(sp)
    800063be:	e8ca                	sd	s2,80(sp)
    800063c0:	e4ce                	sd	s3,72(sp)
    800063c2:	e0d2                	sd	s4,64(sp)
    800063c4:	fc56                	sd	s5,56(sp)
    800063c6:	f85a                	sd	s6,48(sp)
    800063c8:	f45e                	sd	s7,40(sp)
    800063ca:	f062                	sd	s8,32(sp)
    800063cc:	ec66                	sd	s9,24(sp)
    800063ce:	e86a                	sd	s10,16(sp)
    800063d0:	1880                	add	s0,sp,112
    800063d2:	8a2a                	mv	s4,a0
    800063d4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800063d6:	00c52c83          	lw	s9,12(a0)
    800063da:	001c9c9b          	sllw	s9,s9,0x1
    800063de:	1c82                	sll	s9,s9,0x20
    800063e0:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800063e4:	0001c517          	auipc	a0,0x1c
    800063e8:	eb450513          	add	a0,a0,-332 # 80022298 <disk+0x128>
    800063ec:	ffffb097          	auipc	ra,0xffffb
    800063f0:	8e0080e7          	jalr	-1824(ra) # 80000ccc <acquire>
  for(int i = 0; i < 3; i++){
    800063f4:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800063f6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800063f8:	0001cb17          	auipc	s6,0x1c
    800063fc:	d78b0b13          	add	s6,s6,-648 # 80022170 <disk>
  for(int i = 0; i < 3; i++){
    80006400:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006402:	0001cc17          	auipc	s8,0x1c
    80006406:	e96c0c13          	add	s8,s8,-362 # 80022298 <disk+0x128>
    8000640a:	a095                	j	8000646e <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000640c:	00fb0733          	add	a4,s6,a5
    80006410:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006414:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80006416:	0207c563          	bltz	a5,80006440 <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    8000641a:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    8000641c:	0591                	add	a1,a1,4
    8000641e:	05560d63          	beq	a2,s5,80006478 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006422:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80006424:	0001c717          	auipc	a4,0x1c
    80006428:	d4c70713          	add	a4,a4,-692 # 80022170 <disk>
    8000642c:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000642e:	01874683          	lbu	a3,24(a4)
    80006432:	fee9                	bnez	a3,8000640c <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80006434:	2785                	addw	a5,a5,1
    80006436:	0705                	add	a4,a4,1
    80006438:	fe979be3          	bne	a5,s1,8000642e <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    8000643c:	57fd                	li	a5,-1
    8000643e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80006440:	00c05e63          	blez	a2,8000645c <virtio_disk_rw+0xa6>
    80006444:	060a                	sll	a2,a2,0x2
    80006446:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000644a:	0009a503          	lw	a0,0(s3)
    8000644e:	00000097          	auipc	ra,0x0
    80006452:	cfc080e7          	jalr	-772(ra) # 8000614a <free_desc>
      for(int j = 0; j < i; j++)
    80006456:	0991                	add	s3,s3,4
    80006458:	ffa999e3          	bne	s3,s10,8000644a <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000645c:	85e2                	mv	a1,s8
    8000645e:	0001c517          	auipc	a0,0x1c
    80006462:	d2a50513          	add	a0,a0,-726 # 80022188 <disk+0x18>
    80006466:	ffffc097          	auipc	ra,0xffffc
    8000646a:	16a080e7          	jalr	362(ra) # 800025d0 <sleep>
  for(int i = 0; i < 3; i++){
    8000646e:	f9040993          	add	s3,s0,-112
{
    80006472:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006474:	864a                	mv	a2,s2
    80006476:	b775                	j	80006422 <virtio_disk_rw+0x6c>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006478:	f9042503          	lw	a0,-112(s0)
    8000647c:	00a50713          	add	a4,a0,10
    80006480:	0712                	sll	a4,a4,0x4

  if(write)
    80006482:	0001c797          	auipc	a5,0x1c
    80006486:	cee78793          	add	a5,a5,-786 # 80022170 <disk>
    8000648a:	00e786b3          	add	a3,a5,a4
    8000648e:	01703633          	snez	a2,s7
    80006492:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    80006494:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006498:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000649c:	f6070613          	add	a2,a4,-160
    800064a0:	6394                	ld	a3,0(a5)
    800064a2:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800064a4:	00870593          	add	a1,a4,8
    800064a8:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800064aa:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800064ac:	0007b803          	ld	a6,0(a5)
    800064b0:	9642                	add	a2,a2,a6
    800064b2:	46c1                	li	a3,16
    800064b4:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800064b6:	4585                	li	a1,1
    800064b8:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800064bc:	f9442683          	lw	a3,-108(s0)
    800064c0:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800064c4:	0692                	sll	a3,a3,0x4
    800064c6:	9836                	add	a6,a6,a3
    800064c8:	058a0613          	add	a2,s4,88
    800064cc:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800064d0:	0007b803          	ld	a6,0(a5)
    800064d4:	96c2                	add	a3,a3,a6
    800064d6:	40000613          	li	a2,1024
    800064da:	c690                	sw	a2,8(a3)
  if(write)
    800064dc:	001bb613          	seqz	a2,s7
    800064e0:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800064e4:	00166613          	or	a2,a2,1
    800064e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800064ec:	f9842603          	lw	a2,-104(s0)
    800064f0:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    800064f4:	00250693          	add	a3,a0,2
    800064f8:	0692                	sll	a3,a3,0x4
    800064fa:	96be                	add	a3,a3,a5
    800064fc:	58fd                	li	a7,-1
    800064fe:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006502:	0612                	sll	a2,a2,0x4
    80006504:	9832                	add	a6,a6,a2
    80006506:	f9070713          	add	a4,a4,-112
    8000650a:	973e                	add	a4,a4,a5
    8000650c:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80006510:	6398                	ld	a4,0(a5)
    80006512:	9732                	add	a4,a4,a2
    80006514:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    80006516:	4609                	li	a2,2
    80006518:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    8000651c:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    80006520:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80006524:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006528:	6794                	ld	a3,8(a5)
    8000652a:	0026d703          	lhu	a4,2(a3)
    8000652e:	8b1d                	and	a4,a4,7
    80006530:	0706                	sll	a4,a4,0x1
    80006532:	96ba                	add	a3,a3,a4
    80006534:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006538:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    8000653c:	6798                	ld	a4,8(a5)
    8000653e:	00275783          	lhu	a5,2(a4)
    80006542:	2785                	addw	a5,a5,1
    80006544:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006548:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    8000654c:	100017b7          	lui	a5,0x10001
    80006550:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    80006554:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006558:	0001c917          	auipc	s2,0x1c
    8000655c:	d4090913          	add	s2,s2,-704 # 80022298 <disk+0x128>
  while(b->disk == 1) {
    80006560:	4485                	li	s1,1
    80006562:	00b79c63          	bne	a5,a1,8000657a <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006566:	85ca                	mv	a1,s2
    80006568:	8552                	mv	a0,s4
    8000656a:	ffffc097          	auipc	ra,0xffffc
    8000656e:	066080e7          	jalr	102(ra) # 800025d0 <sleep>
  while(b->disk == 1) {
    80006572:	004a2783          	lw	a5,4(s4)
    80006576:	fe9788e3          	beq	a5,s1,80006566 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000657a:	f9042903          	lw	s2,-112(s0)
    8000657e:	00290713          	add	a4,s2,2
    80006582:	0712                	sll	a4,a4,0x4
    80006584:	0001c797          	auipc	a5,0x1c
    80006588:	bec78793          	add	a5,a5,-1044 # 80022170 <disk>
    8000658c:	97ba                	add	a5,a5,a4
    8000658e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006592:	0001c997          	auipc	s3,0x1c
    80006596:	bde98993          	add	s3,s3,-1058 # 80022170 <disk>
    8000659a:	00491713          	sll	a4,s2,0x4
    8000659e:	0009b783          	ld	a5,0(s3)
    800065a2:	97ba                	add	a5,a5,a4
    800065a4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800065a8:	854a                	mv	a0,s2
    800065aa:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800065ae:	00000097          	auipc	ra,0x0
    800065b2:	b9c080e7          	jalr	-1124(ra) # 8000614a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800065b6:	8885                	and	s1,s1,1
    800065b8:	f0ed                	bnez	s1,8000659a <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800065ba:	0001c517          	auipc	a0,0x1c
    800065be:	cde50513          	add	a0,a0,-802 # 80022298 <disk+0x128>
    800065c2:	ffffa097          	auipc	ra,0xffffa
    800065c6:	7be080e7          	jalr	1982(ra) # 80000d80 <release>
}
    800065ca:	70a6                	ld	ra,104(sp)
    800065cc:	7406                	ld	s0,96(sp)
    800065ce:	64e6                	ld	s1,88(sp)
    800065d0:	6946                	ld	s2,80(sp)
    800065d2:	69a6                	ld	s3,72(sp)
    800065d4:	6a06                	ld	s4,64(sp)
    800065d6:	7ae2                	ld	s5,56(sp)
    800065d8:	7b42                	ld	s6,48(sp)
    800065da:	7ba2                	ld	s7,40(sp)
    800065dc:	7c02                	ld	s8,32(sp)
    800065de:	6ce2                	ld	s9,24(sp)
    800065e0:	6d42                	ld	s10,16(sp)
    800065e2:	6165                	add	sp,sp,112
    800065e4:	8082                	ret

00000000800065e6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800065e6:	1101                	add	sp,sp,-32
    800065e8:	ec06                	sd	ra,24(sp)
    800065ea:	e822                	sd	s0,16(sp)
    800065ec:	e426                	sd	s1,8(sp)
    800065ee:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800065f0:	0001c497          	auipc	s1,0x1c
    800065f4:	b8048493          	add	s1,s1,-1152 # 80022170 <disk>
    800065f8:	0001c517          	auipc	a0,0x1c
    800065fc:	ca050513          	add	a0,a0,-864 # 80022298 <disk+0x128>
    80006600:	ffffa097          	auipc	ra,0xffffa
    80006604:	6cc080e7          	jalr	1740(ra) # 80000ccc <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006608:	10001737          	lui	a4,0x10001
    8000660c:	533c                	lw	a5,96(a4)
    8000660e:	8b8d                	and	a5,a5,3
    80006610:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006612:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    80006616:	689c                	ld	a5,16(s1)
    80006618:	0204d703          	lhu	a4,32(s1)
    8000661c:	0027d783          	lhu	a5,2(a5)
    80006620:	04f70863          	beq	a4,a5,80006670 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006624:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006628:	6898                	ld	a4,16(s1)
    8000662a:	0204d783          	lhu	a5,32(s1)
    8000662e:	8b9d                	and	a5,a5,7
    80006630:	078e                	sll	a5,a5,0x3
    80006632:	97ba                	add	a5,a5,a4
    80006634:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006636:	00278713          	add	a4,a5,2
    8000663a:	0712                	sll	a4,a4,0x4
    8000663c:	9726                	add	a4,a4,s1
    8000663e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006642:	e721                	bnez	a4,8000668a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006644:	0789                	add	a5,a5,2
    80006646:	0792                	sll	a5,a5,0x4
    80006648:	97a6                	add	a5,a5,s1
    8000664a:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    8000664c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006650:	ffffc097          	auipc	ra,0xffffc
    80006654:	fe4080e7          	jalr	-28(ra) # 80002634 <wakeup>

    disk.used_idx += 1;
    80006658:	0204d783          	lhu	a5,32(s1)
    8000665c:	2785                	addw	a5,a5,1
    8000665e:	17c2                	sll	a5,a5,0x30
    80006660:	93c1                	srl	a5,a5,0x30
    80006662:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006666:	6898                	ld	a4,16(s1)
    80006668:	00275703          	lhu	a4,2(a4)
    8000666c:	faf71ce3          	bne	a4,a5,80006624 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006670:	0001c517          	auipc	a0,0x1c
    80006674:	c2850513          	add	a0,a0,-984 # 80022298 <disk+0x128>
    80006678:	ffffa097          	auipc	ra,0xffffa
    8000667c:	708080e7          	jalr	1800(ra) # 80000d80 <release>
}
    80006680:	60e2                	ld	ra,24(sp)
    80006682:	6442                	ld	s0,16(sp)
    80006684:	64a2                	ld	s1,8(sp)
    80006686:	6105                	add	sp,sp,32
    80006688:	8082                	ret
      panic("virtio_disk_intr status");
    8000668a:	00002517          	auipc	a0,0x2
    8000668e:	1de50513          	add	a0,a0,478 # 80008868 <syscalls+0x3d8>
    80006692:	ffffa097          	auipc	ra,0xffffa
    80006696:	17c080e7          	jalr	380(ra) # 8000080e <panic>
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
