
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdbd3f>
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
    80000102:	55a080e7          	jalr	1370(ra) # 80002658 <either_copyin>
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
    8000018c:	982080e7          	jalr	-1662(ra) # 80001b0a <myproc>
    80000190:	00002097          	auipc	ra,0x2
    80000194:	312080e7          	jalr	786(ra) # 800024a2 <killed>
    80000198:	ed2d                	bnez	a0,80000212 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    8000019a:	85a6                	mv	a1,s1
    8000019c:	854a                	mv	a0,s2
    8000019e:	00002097          	auipc	ra,0x2
    800001a2:	05c080e7          	jalr	92(ra) # 800021fa <sleep>
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
    800001e8:	41e080e7          	jalr	1054(ra) # 80002602 <either_copyout>
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
    800002c6:	3ec080e7          	jalr	1004(ra) # 800026ae <procdump>
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
    8000041a:	e48080e7          	jalr	-440(ra) # 8000225e <wakeup>
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
    8000044c:	4e078793          	add	a5,a5,1248 # 80021928 <devsw>
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
    8000097e:	8e4080e7          	jalr	-1820(ra) # 8000225e <wakeup>
    
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
    80000a18:	7e6080e7          	jalr	2022(ra) # 800021fa <sleep>
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
    80000af2:	00022797          	auipc	a5,0x22
    80000af6:	fce78793          	add	a5,a5,-50 # 80022ac0 <end>
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
    80000bc4:	00022517          	auipc	a0,0x22
    80000bc8:	efc50513          	add	a0,a0,-260 # 80022ac0 <end>
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
    80000c6a:	e82080e7          	jalr	-382(ra) # 80001ae8 <mycpu>
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
    80000c9c:	e50080e7          	jalr	-432(ra) # 80001ae8 <mycpu>
    80000ca0:	5d3c                	lw	a5,120(a0)
    80000ca2:	cf89                	beqz	a5,80000cbc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ca4:	00001097          	auipc	ra,0x1
    80000ca8:	e44080e7          	jalr	-444(ra) # 80001ae8 <mycpu>
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
    80000cc0:	e2c080e7          	jalr	-468(ra) # 80001ae8 <mycpu>
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
    80000d00:	dec080e7          	jalr	-532(ra) # 80001ae8 <mycpu>
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
    80000d2c:	dc0080e7          	jalr	-576(ra) # 80001ae8 <mycpu>
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
    80000e3c:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdc541>
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
    80000f78:	b64080e7          	jalr	-1180(ra) # 80001ad8 <cpuid>
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
    80000f94:	b48080e7          	jalr	-1208(ra) # 80001ad8 <cpuid>
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
    80000fb6:	83e080e7          	jalr	-1986(ra) # 800027f0 <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	d0a080e7          	jalr	-758(ra) # 80005cc4 <plicinithart>
  }

  scheduler();        
    80000fc2:	00001097          	auipc	ra,0x1
    80000fc6:	08e080e7          	jalr	142(ra) # 80002050 <scheduler>
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
    8000102e:	79e080e7          	jalr	1950(ra) # 800027c8 <trapinit>
    trapinithart();  /* install kernel trap vector */
    80001032:	00001097          	auipc	ra,0x1
    80001036:	7be080e7          	jalr	1982(ra) # 800027f0 <trapinithart>
    plicinit();      /* set up interrupt controller */
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	c74080e7          	jalr	-908(ra) # 80005cae <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80001042:	00005097          	auipc	ra,0x5
    80001046:	c82080e7          	jalr	-894(ra) # 80005cc4 <plicinithart>
    binit();         /* buffer cache */
    8000104a:	00002097          	auipc	ra,0x2
    8000104e:	ed4080e7          	jalr	-300(ra) # 80002f1e <binit>
    iinit();         /* inode table */
    80001052:	00002097          	auipc	ra,0x2
    80001056:	572080e7          	jalr	1394(ra) # 800035c4 <iinit>
    fileinit();      /* file table */
    8000105a:	00003097          	auipc	ra,0x3
    8000105e:	4e8080e7          	jalr	1256(ra) # 80004542 <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80001062:	00005097          	auipc	ra,0x5
    80001066:	d6a080e7          	jalr	-662(ra) # 80005dcc <virtio_disk_init>
    userinit();      /* first user process */
    8000106a:	00001097          	auipc	ra,0x1
    8000106e:	d8a080e7          	jalr	-630(ra) # 80001df4 <userinit>
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
    8000110a:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdc537>
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
    80001966:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffdc53f>
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
    80001998:	00010497          	auipc	s1,0x10
    8000199c:	f4848493          	add	s1,s1,-184 # 800118e0 <proc>
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
    800019b2:	00016a17          	auipc	s4,0x16
    800019b6:	d2ea0a13          	add	s4,s4,-722 # 800176e0 <tickslock>
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
    800019ec:	17848493          	add	s1,s1,376
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
    80001a5c:	00010497          	auipc	s1,0x10
    80001a60:	e8448493          	add	s1,s1,-380 # 800118e0 <proc>
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
    80001a7e:	00016997          	auipc	s3,0x16
    80001a82:	c6298993          	add	s3,s3,-926 # 800176e0 <tickslock>
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
    80001aae:	e8bc                	sd	a5,80(s1)
   
      /* CMPT 332 Group 01 Change, Fall 2024 */
      p->cpuShare = 0;
    80001ab0:	0204aa23          	sw	zero,52(s1)
      p->cpuUsage = 0;
    80001ab4:	0204ac23          	sw	zero,56(s1)
      p->lastRunTime = 0;
    80001ab8:	0204ae23          	sw	zero,60(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001abc:	17848493          	add	s1,s1,376
    80001ac0:	fd3493e3          	bne	s1,s3,80001a86 <procinit+0x6e>
  }
}
    80001ac4:	70e2                	ld	ra,56(sp)
    80001ac6:	7442                	ld	s0,48(sp)
    80001ac8:	74a2                	ld	s1,40(sp)
    80001aca:	7902                	ld	s2,32(sp)
    80001acc:	69e2                	ld	s3,24(sp)
    80001ace:	6a42                	ld	s4,16(sp)
    80001ad0:	6aa2                	ld	s5,8(sp)
    80001ad2:	6b02                	ld	s6,0(sp)
    80001ad4:	6121                	add	sp,sp,64
    80001ad6:	8082                	ret

0000000080001ad8 <cpuid>:
/* Must be called with interrupts disabled, */
/* to prevent race with process being moved */
/* to a different CPU. */
int
cpuid()
{
    80001ad8:	1141                	add	sp,sp,-16
    80001ada:	e422                	sd	s0,8(sp)
    80001adc:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ade:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001ae0:	2501                	sext.w	a0,a0
    80001ae2:	6422                	ld	s0,8(sp)
    80001ae4:	0141                	add	sp,sp,16
    80001ae6:	8082                	ret

0000000080001ae8 <mycpu>:

/* Return this CPU's cpu struct. */
/* Interrupts must be disabled. */
struct cpu*
mycpu(void)
{
    80001ae8:	1141                	add	sp,sp,-16
    80001aea:	e422                	sd	s0,8(sp)
    80001aec:	0800                	add	s0,sp,16
    80001aee:	8712                	mv	a4,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001af0:	2701                	sext.w	a4,a4
    80001af2:	00471793          	sll	a5,a4,0x4
    80001af6:	97ba                	add	a5,a5,a4
    80001af8:	078e                	sll	a5,a5,0x3
  return c;
}
    80001afa:	0000f517          	auipc	a0,0xf
    80001afe:	f6650513          	add	a0,a0,-154 # 80010a60 <cpus>
    80001b02:	953e                	add	a0,a0,a5
    80001b04:	6422                	ld	s0,8(sp)
    80001b06:	0141                	add	sp,sp,16
    80001b08:	8082                	ret

0000000080001b0a <myproc>:

/* Return the current struct proc *, or zero if none. */
struct proc*
myproc(void)
{
    80001b0a:	1101                	add	sp,sp,-32
    80001b0c:	ec06                	sd	ra,24(sp)
    80001b0e:	e822                	sd	s0,16(sp)
    80001b10:	e426                	sd	s1,8(sp)
    80001b12:	1000                	add	s0,sp,32
  push_off();
    80001b14:	fffff097          	auipc	ra,0xfffff
    80001b18:	16c080e7          	jalr	364(ra) # 80000c80 <push_off>
    80001b1c:	8712                	mv	a4,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001b1e:	2701                	sext.w	a4,a4
    80001b20:	00471793          	sll	a5,a4,0x4
    80001b24:	97ba                	add	a5,a5,a4
    80001b26:	078e                	sll	a5,a5,0x3
    80001b28:	0000f717          	auipc	a4,0xf
    80001b2c:	f0870713          	add	a4,a4,-248 # 80010a30 <pid_lock>
    80001b30:	97ba                	add	a5,a5,a4
    80001b32:	7b84                	ld	s1,48(a5)
  pop_off();
    80001b34:	fffff097          	auipc	ra,0xfffff
    80001b38:	1ec080e7          	jalr	492(ra) # 80000d20 <pop_off>
  return p;
}
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	60e2                	ld	ra,24(sp)
    80001b40:	6442                	ld	s0,16(sp)
    80001b42:	64a2                	ld	s1,8(sp)
    80001b44:	6105                	add	sp,sp,32
    80001b46:	8082                	ret

0000000080001b48 <forkret>:

/* A fork child's very first scheduling by scheduler() */
/* will swtch to forkret. */
void
forkret(void)
{
    80001b48:	1141                	add	sp,sp,-16
    80001b4a:	e406                	sd	ra,8(sp)
    80001b4c:	e022                	sd	s0,0(sp)
    80001b4e:	0800                	add	s0,sp,16
  static int first = 1;

  /* Still holding p->lock from scheduler. */
  release(&myproc()->lock);
    80001b50:	00000097          	auipc	ra,0x0
    80001b54:	fba080e7          	jalr	-70(ra) # 80001b0a <myproc>
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	228080e7          	jalr	552(ra) # 80000d80 <release>

  if (first) {
    80001b60:	00007797          	auipc	a5,0x7
    80001b64:	d207a783          	lw	a5,-736(a5) # 80008880 <first.1>
    80001b68:	eb89                	bnez	a5,80001b7a <forkret+0x32>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    80001b6a:	00001097          	auipc	ra,0x1
    80001b6e:	c9e080e7          	jalr	-866(ra) # 80002808 <usertrapret>
}
    80001b72:	60a2                	ld	ra,8(sp)
    80001b74:	6402                	ld	s0,0(sp)
    80001b76:	0141                	add	sp,sp,16
    80001b78:	8082                	ret
    fsinit(ROOTDEV);
    80001b7a:	4505                	li	a0,1
    80001b7c:	00002097          	auipc	ra,0x2
    80001b80:	9c8080e7          	jalr	-1592(ra) # 80003544 <fsinit>
    first = 0;
    80001b84:	00007797          	auipc	a5,0x7
    80001b88:	ce07ae23          	sw	zero,-772(a5) # 80008880 <first.1>
    __sync_synchronize();
    80001b8c:	0ff0000f          	fence
    80001b90:	bfe9                	j	80001b6a <forkret+0x22>

0000000080001b92 <allocpid>:
{
    80001b92:	1101                	add	sp,sp,-32
    80001b94:	ec06                	sd	ra,24(sp)
    80001b96:	e822                	sd	s0,16(sp)
    80001b98:	e426                	sd	s1,8(sp)
    80001b9a:	e04a                	sd	s2,0(sp)
    80001b9c:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001b9e:	0000f917          	auipc	s2,0xf
    80001ba2:	e9290913          	add	s2,s2,-366 # 80010a30 <pid_lock>
    80001ba6:	854a                	mv	a0,s2
    80001ba8:	fffff097          	auipc	ra,0xfffff
    80001bac:	124080e7          	jalr	292(ra) # 80000ccc <acquire>
  pid = nextpid;
    80001bb0:	00007797          	auipc	a5,0x7
    80001bb4:	cd478793          	add	a5,a5,-812 # 80008884 <nextpid>
    80001bb8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001bba:	0014871b          	addw	a4,s1,1
    80001bbe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001bc0:	854a                	mv	a0,s2
    80001bc2:	fffff097          	auipc	ra,0xfffff
    80001bc6:	1be080e7          	jalr	446(ra) # 80000d80 <release>
}
    80001bca:	8526                	mv	a0,s1
    80001bcc:	60e2                	ld	ra,24(sp)
    80001bce:	6442                	ld	s0,16(sp)
    80001bd0:	64a2                	ld	s1,8(sp)
    80001bd2:	6902                	ld	s2,0(sp)
    80001bd4:	6105                	add	sp,sp,32
    80001bd6:	8082                	ret

0000000080001bd8 <proc_pagetable>:
{
    80001bd8:	1101                	add	sp,sp,-32
    80001bda:	ec06                	sd	ra,24(sp)
    80001bdc:	e822                	sd	s0,16(sp)
    80001bde:	e426                	sd	s1,8(sp)
    80001be0:	e04a                	sd	s2,0(sp)
    80001be2:	1000                	add	s0,sp,32
    80001be4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001be6:	00000097          	auipc	ra,0x0
    80001bea:	85a080e7          	jalr	-1958(ra) # 80001440 <uvmcreate>
    80001bee:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001bf0:	c121                	beqz	a0,80001c30 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001bf2:	4729                	li	a4,10
    80001bf4:	00005697          	auipc	a3,0x5
    80001bf8:	40c68693          	add	a3,a3,1036 # 80007000 <_trampoline>
    80001bfc:	6605                	lui	a2,0x1
    80001bfe:	040005b7          	lui	a1,0x4000
    80001c02:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c04:	05b2                	sll	a1,a1,0xc
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	58c080e7          	jalr	1420(ra) # 80001192 <mappages>
    80001c0e:	02054863          	bltz	a0,80001c3e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c12:	4719                	li	a4,6
    80001c14:	06893683          	ld	a3,104(s2)
    80001c18:	6605                	lui	a2,0x1
    80001c1a:	020005b7          	lui	a1,0x2000
    80001c1e:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c20:	05b6                	sll	a1,a1,0xd
    80001c22:	8526                	mv	a0,s1
    80001c24:	fffff097          	auipc	ra,0xfffff
    80001c28:	56e080e7          	jalr	1390(ra) # 80001192 <mappages>
    80001c2c:	02054163          	bltz	a0,80001c4e <proc_pagetable+0x76>
}
    80001c30:	8526                	mv	a0,s1
    80001c32:	60e2                	ld	ra,24(sp)
    80001c34:	6442                	ld	s0,16(sp)
    80001c36:	64a2                	ld	s1,8(sp)
    80001c38:	6902                	ld	s2,0(sp)
    80001c3a:	6105                	add	sp,sp,32
    80001c3c:	8082                	ret
    uvmfree(pagetable, 0);
    80001c3e:	4581                	li	a1,0
    80001c40:	8526                	mv	a0,s1
    80001c42:	00000097          	auipc	ra,0x0
    80001c46:	a04080e7          	jalr	-1532(ra) # 80001646 <uvmfree>
    return 0;
    80001c4a:	4481                	li	s1,0
    80001c4c:	b7d5                	j	80001c30 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c4e:	4681                	li	a3,0
    80001c50:	4605                	li	a2,1
    80001c52:	040005b7          	lui	a1,0x4000
    80001c56:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c58:	05b2                	sll	a1,a1,0xc
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	720080e7          	jalr	1824(ra) # 8000137c <uvmunmap>
    uvmfree(pagetable, 0);
    80001c64:	4581                	li	a1,0
    80001c66:	8526                	mv	a0,s1
    80001c68:	00000097          	auipc	ra,0x0
    80001c6c:	9de080e7          	jalr	-1570(ra) # 80001646 <uvmfree>
    return 0;
    80001c70:	4481                	li	s1,0
    80001c72:	bf7d                	j	80001c30 <proc_pagetable+0x58>

0000000080001c74 <proc_freepagetable>:
{
    80001c74:	1101                	add	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	e04a                	sd	s2,0(sp)
    80001c7e:	1000                	add	s0,sp,32
    80001c80:	84aa                	mv	s1,a0
    80001c82:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c84:	4681                	li	a3,0
    80001c86:	4605                	li	a2,1
    80001c88:	040005b7          	lui	a1,0x4000
    80001c8c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c8e:	05b2                	sll	a1,a1,0xc
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	6ec080e7          	jalr	1772(ra) # 8000137c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c98:	4681                	li	a3,0
    80001c9a:	4605                	li	a2,1
    80001c9c:	020005b7          	lui	a1,0x2000
    80001ca0:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ca2:	05b6                	sll	a1,a1,0xd
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	fffff097          	auipc	ra,0xfffff
    80001caa:	6d6080e7          	jalr	1750(ra) # 8000137c <uvmunmap>
  uvmfree(pagetable, sz);
    80001cae:	85ca                	mv	a1,s2
    80001cb0:	8526                	mv	a0,s1
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	994080e7          	jalr	-1644(ra) # 80001646 <uvmfree>
}
    80001cba:	60e2                	ld	ra,24(sp)
    80001cbc:	6442                	ld	s0,16(sp)
    80001cbe:	64a2                	ld	s1,8(sp)
    80001cc0:	6902                	ld	s2,0(sp)
    80001cc2:	6105                	add	sp,sp,32
    80001cc4:	8082                	ret

0000000080001cc6 <freeproc>:
{
    80001cc6:	1101                	add	sp,sp,-32
    80001cc8:	ec06                	sd	ra,24(sp)
    80001cca:	e822                	sd	s0,16(sp)
    80001ccc:	e426                	sd	s1,8(sp)
    80001cce:	1000                	add	s0,sp,32
    80001cd0:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001cd2:	7528                	ld	a0,104(a0)
    80001cd4:	c509                	beqz	a0,80001cde <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	e08080e7          	jalr	-504(ra) # 80000ade <kfree>
  p->trapframe = 0;
    80001cde:	0604b423          	sd	zero,104(s1)
  if(p->pagetable)
    80001ce2:	70a8                	ld	a0,96(s1)
    80001ce4:	c511                	beqz	a0,80001cf0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001ce6:	6cac                	ld	a1,88(s1)
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	f8c080e7          	jalr	-116(ra) # 80001c74 <proc_freepagetable>
  p->pagetable = 0;
    80001cf0:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001cf4:	0404bc23          	sd	zero,88(s1)
  p->pid = 0;
    80001cf8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001cfc:	0404b423          	sd	zero,72(s1)
  p->name[0] = 0;
    80001d00:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001d04:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001d08:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001d0c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001d10:	0004ac23          	sw	zero,24(s1)
}
    80001d14:	60e2                	ld	ra,24(sp)
    80001d16:	6442                	ld	s0,16(sp)
    80001d18:	64a2                	ld	s1,8(sp)
    80001d1a:	6105                	add	sp,sp,32
    80001d1c:	8082                	ret

0000000080001d1e <allocproc>:
allocproc(void){
    80001d1e:	1101                	add	sp,sp,-32
    80001d20:	ec06                	sd	ra,24(sp)
    80001d22:	e822                	sd	s0,16(sp)
    80001d24:	e426                	sd	s1,8(sp)
    80001d26:	e04a                	sd	s2,0(sp)
    80001d28:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d2a:	00010497          	auipc	s1,0x10
    80001d2e:	bb648493          	add	s1,s1,-1098 # 800118e0 <proc>
    80001d32:	00016917          	auipc	s2,0x16
    80001d36:	9ae90913          	add	s2,s2,-1618 # 800176e0 <tickslock>
    acquire(&p->lock);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	fffff097          	auipc	ra,0xfffff
    80001d40:	f90080e7          	jalr	-112(ra) # 80000ccc <acquire>
    if(p->state == UNUSED) {
    80001d44:	4c9c                	lw	a5,24(s1)
    80001d46:	cf81                	beqz	a5,80001d5e <allocproc+0x40>
      release(&p->lock);
    80001d48:	8526                	mv	a0,s1
    80001d4a:	fffff097          	auipc	ra,0xfffff
    80001d4e:	036080e7          	jalr	54(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d52:	17848493          	add	s1,s1,376
    80001d56:	ff2492e3          	bne	s1,s2,80001d3a <allocproc+0x1c>
  return 0;
    80001d5a:	4481                	li	s1,0
    80001d5c:	a8a9                	j	80001db6 <allocproc+0x98>
  p->pid = allocpid();
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	e34080e7          	jalr	-460(ra) # 80001b92 <allocpid>
    80001d66:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d68:	4785                	li	a5,1
    80001d6a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d6c:	fffff097          	auipc	ra,0xfffff
    80001d70:	e70080e7          	jalr	-400(ra) # 80000bdc <kalloc>
    80001d74:	892a                	mv	s2,a0
    80001d76:	f4a8                	sd	a0,104(s1)
    80001d78:	c531                	beqz	a0,80001dc4 <allocproc+0xa6>
  p->pagetable = proc_pagetable(p);
    80001d7a:	8526                	mv	a0,s1
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	e5c080e7          	jalr	-420(ra) # 80001bd8 <proc_pagetable>
    80001d84:	892a                	mv	s2,a0
    80001d86:	f0a8                	sd	a0,96(s1)
  if(p->pagetable == 0){
    80001d88:	c931                	beqz	a0,80001ddc <allocproc+0xbe>
  memset(&p->context, 0, sizeof(p->context));
    80001d8a:	07000613          	li	a2,112
    80001d8e:	4581                	li	a1,0
    80001d90:	07048513          	add	a0,s1,112
    80001d94:	fffff097          	auipc	ra,0xfffff
    80001d98:	034080e7          	jalr	52(ra) # 80000dc8 <memset>
  p->context.ra = (uint64)forkret;
    80001d9c:	00000797          	auipc	a5,0x0
    80001da0:	dac78793          	add	a5,a5,-596 # 80001b48 <forkret>
    80001da4:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001da6:	68bc                	ld	a5,80(s1)
    80001da8:	6705                	lui	a4,0x1
    80001daa:	97ba                	add	a5,a5,a4
    80001dac:	fcbc                	sd	a5,120(s1)
  p->priority = 0;
    80001dae:	0404a023          	sw	zero,64(s1)
  p->cpuUsage = 0;
    80001db2:	0204ac23          	sw	zero,56(s1)
}
    80001db6:	8526                	mv	a0,s1
    80001db8:	60e2                	ld	ra,24(sp)
    80001dba:	6442                	ld	s0,16(sp)
    80001dbc:	64a2                	ld	s1,8(sp)
    80001dbe:	6902                	ld	s2,0(sp)
    80001dc0:	6105                	add	sp,sp,32
    80001dc2:	8082                	ret
    freeproc(p);
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	00000097          	auipc	ra,0x0
    80001dca:	f00080e7          	jalr	-256(ra) # 80001cc6 <freeproc>
    release(&p->lock);
    80001dce:	8526                	mv	a0,s1
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	fb0080e7          	jalr	-80(ra) # 80000d80 <release>
    return 0;
    80001dd8:	84ca                	mv	s1,s2
    80001dda:	bff1                	j	80001db6 <allocproc+0x98>
    freeproc(p);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	ee8080e7          	jalr	-280(ra) # 80001cc6 <freeproc>
    release(&p->lock);
    80001de6:	8526                	mv	a0,s1
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	f98080e7          	jalr	-104(ra) # 80000d80 <release>
    return 0;
    80001df0:	84ca                	mv	s1,s2
    80001df2:	b7d1                	j	80001db6 <allocproc+0x98>

0000000080001df4 <userinit>:
{
    80001df4:	1101                	add	sp,sp,-32
    80001df6:	ec06                	sd	ra,24(sp)
    80001df8:	e822                	sd	s0,16(sp)
    80001dfa:	e426                	sd	s1,8(sp)
    80001dfc:	1000                	add	s0,sp,32
  p = allocproc();
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	f20080e7          	jalr	-224(ra) # 80001d1e <allocproc>
    80001e06:	84aa                	mv	s1,a0
  initproc = p;
    80001e08:	00007797          	auipc	a5,0x7
    80001e0c:	aea7b823          	sd	a0,-1296(a5) # 800088f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001e10:	03400613          	li	a2,52
    80001e14:	00007597          	auipc	a1,0x7
    80001e18:	a7c58593          	add	a1,a1,-1412 # 80008890 <initcode>
    80001e1c:	7128                	ld	a0,96(a0)
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	650080e7          	jalr	1616(ra) # 8000146e <uvmfirst>
  p->sz = PGSIZE;
    80001e26:	6785                	lui	a5,0x1
    80001e28:	ecbc                	sd	a5,88(s1)
  p->trapframe->epc = 0;      /* user program counter */
    80001e2a:	74b8                	ld	a4,104(s1)
    80001e2c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    80001e30:	74b8                	ld	a4,104(s1)
    80001e32:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e34:	4641                	li	a2,16
    80001e36:	00006597          	auipc	a1,0x6
    80001e3a:	40258593          	add	a1,a1,1026 # 80008238 <digits+0x200>
    80001e3e:	16848513          	add	a0,s1,360
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	0ce080e7          	jalr	206(ra) # 80000f10 <safestrcpy>
  p->cwd = namei("/");
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	3fe50513          	add	a0,a0,1022 # 80008248 <digits+0x210>
    80001e52:	00002097          	auipc	ra,0x2
    80001e56:	110080e7          	jalr	272(ra) # 80003f62 <namei>
    80001e5a:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80001e5e:	478d                	li	a5,3
    80001e60:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001e62:	8526                	mv	a0,s1
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	f1c080e7          	jalr	-228(ra) # 80000d80 <release>
}
    80001e6c:	60e2                	ld	ra,24(sp)
    80001e6e:	6442                	ld	s0,16(sp)
    80001e70:	64a2                	ld	s1,8(sp)
    80001e72:	6105                	add	sp,sp,32
    80001e74:	8082                	ret

0000000080001e76 <growproc>:
{
    80001e76:	1101                	add	sp,sp,-32
    80001e78:	ec06                	sd	ra,24(sp)
    80001e7a:	e822                	sd	s0,16(sp)
    80001e7c:	e426                	sd	s1,8(sp)
    80001e7e:	e04a                	sd	s2,0(sp)
    80001e80:	1000                	add	s0,sp,32
    80001e82:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001e84:	00000097          	auipc	ra,0x0
    80001e88:	c86080e7          	jalr	-890(ra) # 80001b0a <myproc>
    80001e8c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001e8e:	6d2c                	ld	a1,88(a0)
  if(n > 0){
    80001e90:	01204c63          	bgtz	s2,80001ea8 <growproc+0x32>
  } else if(n < 0){
    80001e94:	02094663          	bltz	s2,80001ec0 <growproc+0x4a>
  p->sz = sz;
    80001e98:	ecac                	sd	a1,88(s1)
  return 0;
    80001e9a:	4501                	li	a0,0
}
    80001e9c:	60e2                	ld	ra,24(sp)
    80001e9e:	6442                	ld	s0,16(sp)
    80001ea0:	64a2                	ld	s1,8(sp)
    80001ea2:	6902                	ld	s2,0(sp)
    80001ea4:	6105                	add	sp,sp,32
    80001ea6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001ea8:	4691                	li	a3,4
    80001eaa:	00b90633          	add	a2,s2,a1
    80001eae:	7128                	ld	a0,96(a0)
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	678080e7          	jalr	1656(ra) # 80001528 <uvmalloc>
    80001eb8:	85aa                	mv	a1,a0
    80001eba:	fd79                	bnez	a0,80001e98 <growproc+0x22>
      return -1;
    80001ebc:	557d                	li	a0,-1
    80001ebe:	bff9                	j	80001e9c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ec0:	00b90633          	add	a2,s2,a1
    80001ec4:	7128                	ld	a0,96(a0)
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	61a080e7          	jalr	1562(ra) # 800014e0 <uvmdealloc>
    80001ece:	85aa                	mv	a1,a0
    80001ed0:	b7e1                	j	80001e98 <growproc+0x22>

0000000080001ed2 <fork>:
{
    80001ed2:	7139                	add	sp,sp,-64
    80001ed4:	fc06                	sd	ra,56(sp)
    80001ed6:	f822                	sd	s0,48(sp)
    80001ed8:	f426                	sd	s1,40(sp)
    80001eda:	f04a                	sd	s2,32(sp)
    80001edc:	ec4e                	sd	s3,24(sp)
    80001ede:	e852                	sd	s4,16(sp)
    80001ee0:	e456                	sd	s5,8(sp)
    80001ee2:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	c26080e7          	jalr	-986(ra) # 80001b0a <myproc>
    80001eec:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001eee:	00000097          	auipc	ra,0x0
    80001ef2:	e30080e7          	jalr	-464(ra) # 80001d1e <allocproc>
    80001ef6:	10050c63          	beqz	a0,8000200e <fork+0x13c>
    80001efa:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001efc:	058ab603          	ld	a2,88(s5)
    80001f00:	712c                	ld	a1,96(a0)
    80001f02:	060ab503          	ld	a0,96(s5)
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	77a080e7          	jalr	1914(ra) # 80001680 <uvmcopy>
    80001f0e:	04054863          	bltz	a0,80001f5e <fork+0x8c>
  np->sz = p->sz;
    80001f12:	058ab783          	ld	a5,88(s5)
    80001f16:	04fa3c23          	sd	a5,88(s4)
  *(np->trapframe) = *(p->trapframe);
    80001f1a:	068ab683          	ld	a3,104(s5)
    80001f1e:	87b6                	mv	a5,a3
    80001f20:	068a3703          	ld	a4,104(s4)
    80001f24:	12068693          	add	a3,a3,288
    80001f28:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f2c:	6788                	ld	a0,8(a5)
    80001f2e:	6b8c                	ld	a1,16(a5)
    80001f30:	6f90                	ld	a2,24(a5)
    80001f32:	01073023          	sd	a6,0(a4)
    80001f36:	e708                	sd	a0,8(a4)
    80001f38:	eb0c                	sd	a1,16(a4)
    80001f3a:	ef10                	sd	a2,24(a4)
    80001f3c:	02078793          	add	a5,a5,32
    80001f40:	02070713          	add	a4,a4,32
    80001f44:	fed792e3          	bne	a5,a3,80001f28 <fork+0x56>
  np->trapframe->a0 = 0;
    80001f48:	068a3783          	ld	a5,104(s4)
    80001f4c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001f50:	0e0a8493          	add	s1,s5,224
    80001f54:	0e0a0913          	add	s2,s4,224
    80001f58:	160a8993          	add	s3,s5,352
    80001f5c:	a00d                	j	80001f7e <fork+0xac>
    freeproc(np);
    80001f5e:	8552                	mv	a0,s4
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	d66080e7          	jalr	-666(ra) # 80001cc6 <freeproc>
    release(&np->lock);
    80001f68:	8552                	mv	a0,s4
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	e16080e7          	jalr	-490(ra) # 80000d80 <release>
    return -1;
    80001f72:	597d                	li	s2,-1
    80001f74:	a059                	j	80001ffa <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001f76:	04a1                	add	s1,s1,8
    80001f78:	0921                	add	s2,s2,8
    80001f7a:	01348b63          	beq	s1,s3,80001f90 <fork+0xbe>
    if(p->ofile[i])
    80001f7e:	6088                	ld	a0,0(s1)
    80001f80:	d97d                	beqz	a0,80001f76 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f82:	00002097          	auipc	ra,0x2
    80001f86:	652080e7          	jalr	1618(ra) # 800045d4 <filedup>
    80001f8a:	00a93023          	sd	a0,0(s2)
    80001f8e:	b7e5                	j	80001f76 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001f90:	160ab503          	ld	a0,352(s5)
    80001f94:	00001097          	auipc	ra,0x1
    80001f98:	7ea080e7          	jalr	2026(ra) # 8000377e <idup>
    80001f9c:	16aa3023          	sd	a0,352(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001fa0:	4641                	li	a2,16
    80001fa2:	168a8593          	add	a1,s5,360
    80001fa6:	168a0513          	add	a0,s4,360
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	f66080e7          	jalr	-154(ra) # 80000f10 <safestrcpy>
  pid = np->pid;
    80001fb2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001fb6:	8552                	mv	a0,s4
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	dc8080e7          	jalr	-568(ra) # 80000d80 <release>
  acquire(&wait_lock);
    80001fc0:	0000f497          	auipc	s1,0xf
    80001fc4:	a8848493          	add	s1,s1,-1400 # 80010a48 <wait_lock>
    80001fc8:	8526                	mv	a0,s1
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	d02080e7          	jalr	-766(ra) # 80000ccc <acquire>
  np->parent = p;
    80001fd2:	055a3423          	sd	s5,72(s4)
  release(&wait_lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	da8080e7          	jalr	-600(ra) # 80000d80 <release>
  acquire(&np->lock);
    80001fe0:	8552                	mv	a0,s4
    80001fe2:	fffff097          	auipc	ra,0xfffff
    80001fe6:	cea080e7          	jalr	-790(ra) # 80000ccc <acquire>
  np->state = RUNNABLE;
    80001fea:	478d                	li	a5,3
    80001fec:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001ff0:	8552                	mv	a0,s4
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	d8e080e7          	jalr	-626(ra) # 80000d80 <release>
}
    80001ffa:	854a                	mv	a0,s2
    80001ffc:	70e2                	ld	ra,56(sp)
    80001ffe:	7442                	ld	s0,48(sp)
    80002000:	74a2                	ld	s1,40(sp)
    80002002:	7902                	ld	s2,32(sp)
    80002004:	69e2                	ld	s3,24(sp)
    80002006:	6a42                	ld	s4,16(sp)
    80002008:	6aa2                	ld	s5,8(sp)
    8000200a:	6121                	add	sp,sp,64
    8000200c:	8082                	ret
    return -1;
    8000200e:	597d                	li	s2,-1
    80002010:	b7ed                	j	80001ffa <fork+0x128>

0000000080002012 <enqueueprocess>:
void enqueueprocess(struct proc *p, int priorityLevel){
    80002012:	1141                	add	sp,sp,-16
    80002014:	e422                	sd	s0,8(sp)
    80002016:	0800                	add	s0,sp,16
	int r = multifeedbackqueue.ending[priorityLevel];
    80002018:	0000f697          	auipc	a3,0xf
    8000201c:	e8868693          	add	a3,a3,-376 # 80010ea0 <multifeedbackqueue>
    80002020:	28858713          	add	a4,a1,648
    80002024:	070a                	sll	a4,a4,0x2
    80002026:	9736                	add	a4,a4,a3
    80002028:	475c                	lw	a5,12(a4)
	multifeedbackqueue.proc[priorityLevel][r] = p;
    8000202a:	059a                	sll	a1,a1,0x6
    8000202c:	95be                	add	a1,a1,a5
    8000202e:	0589                	add	a1,a1,2
    80002030:	058e                	sll	a1,a1,0x3
    80002032:	96ae                	add	a3,a3,a1
    80002034:	e688                	sd	a0,8(a3)
	multifeedbackqueue.ending[priorityLevel] = (r + 1) % NPROC;
    80002036:	2785                	addw	a5,a5,1
    80002038:	41f7d69b          	sraw	a3,a5,0x1f
    8000203c:	01a6d69b          	srlw	a3,a3,0x1a
    80002040:	9fb5                	addw	a5,a5,a3
    80002042:	03f7f793          	and	a5,a5,63
    80002046:	9f95                	subw	a5,a5,a3
    80002048:	c75c                	sw	a5,12(a4)
}
    8000204a:	6422                	ld	s0,8(sp)
    8000204c:	0141                	add	sp,sp,16
    8000204e:	8082                	ret

0000000080002050 <scheduler>:
{
    80002050:	1141                	add	sp,sp,-16
    80002052:	e422                	sd	s0,8(sp)
    80002054:	0800                	add	s0,sp,16
	ticksNum = ticks; /* utilizing ticks from trap.c */
    80002056:	00007517          	auipc	a0,0x7
    8000205a:	8aa52503          	lw	a0,-1878(a0) # 80008900 <ticks>
	for (i = 0; i < PRIQUEUES; i ++){
    8000205e:	00010697          	auipc	a3,0x10
    80002062:	85a68693          	add	a3,a3,-1958 # 800118b8 <multifeedbackqueue+0xa18>
    80002066:	0000f717          	auipc	a4,0xf
    8000206a:	05270713          	add	a4,a4,82 # 800110b8 <multifeedbackqueue+0x218>
    8000206e:	00010617          	auipc	a2,0x10
    80002072:	a4a60613          	add	a2,a2,-1462 # 80011ab8 <proc+0x1d8>
		for (j = 0; j < NPROC; j++){
    80002076:	e0070793          	add	a5,a4,-512
			multifeedbackqueue.proc[i][j] = 0;
    8000207a:	0007b023          	sd	zero,0(a5)
		for (j = 0; j < NPROC; j++){
    8000207e:	07a1                	add	a5,a5,8
    80002080:	fef71de3          	bne	a4,a5,8000207a <scheduler+0x2a>
		multifeedbackqueue.beginning[i] = 0;
    80002084:	0006a023          	sw	zero,0(a3)
	for (i = 0; i < PRIQUEUES; i ++){
    80002088:	0691                	add	a3,a3,4
    8000208a:	20070713          	add	a4,a4,512
    8000208e:	fee614e3          	bne	a2,a4,80002076 <scheduler+0x26>
    80002092:	00010797          	auipc	a5,0x10
    80002096:	9207ad23          	sw	zero,-1734(a5) # 800119cc <proc+0xec>
		p = multifeedbackqueue.proc[priorityLevel][0];
    8000209a:	0000f717          	auipc	a4,0xf
    8000209e:	e0670713          	add	a4,a4,-506 # 80010ea0 <multifeedbackqueue>
    800020a2:	00010597          	auipc	a1,0x10
    800020a6:	dfe58593          	add	a1,a1,-514 # 80011ea0 <proc+0x5c0>
		p->state = RUNNING;
    800020aa:	4791                	li	a5,4
		p = multifeedbackqueue.proc[priorityLevel][0];
    800020ac:	8185b683          	ld	a3,-2024(a1)
		p->state = RUNNING;
    800020b0:	ce9c                	sw	a5,24(a3)
		p = multifeedbackqueue.proc[priorityLevel][0];
    800020b2:	61873683          	ld	a3,1560(a4)
		p->state = RUNNING;
    800020b6:	ce9c                	sw	a5,24(a3)
		p = multifeedbackqueue.proc[priorityLevel][0];
    800020b8:	41873683          	ld	a3,1048(a4)
		p->state = RUNNING;
    800020bc:	ce9c                	sw	a5,24(a3)
		p = multifeedbackqueue.proc[priorityLevel][0];
    800020be:	21873683          	ld	a3,536(a4)
		p->state = RUNNING;
    800020c2:	ce9c                	sw	a5,24(a3)
		p = multifeedbackqueue.proc[priorityLevel][0];
    800020c4:	6f14                	ld	a3,24(a4)
		p->state = RUNNING;
    800020c6:	ce9c                	sw	a5,24(a3)
	p->ticks += ticks - ticksNum;
    800020c8:	42f0                	lw	a2,68(a3)
    800020ca:	9e29                	addw	a2,a2,a0
    800020cc:	c2f0                	sw	a2,68(a3)
	if (ticksused >= slicingTime && priorityLevel > 0){
    800020ce:	bff9                	j	800020ac <scheduler+0x5c>

00000000800020d0 <sched>:
{
    800020d0:	7179                	add	sp,sp,-48
    800020d2:	f406                	sd	ra,40(sp)
    800020d4:	f022                	sd	s0,32(sp)
    800020d6:	ec26                	sd	s1,24(sp)
    800020d8:	e84a                	sd	s2,16(sp)
    800020da:	e44e                	sd	s3,8(sp)
    800020dc:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	a2c080e7          	jalr	-1492(ra) # 80001b0a <myproc>
    800020e6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	b6a080e7          	jalr	-1174(ra) # 80000c52 <holding>
    800020f0:	c559                	beqz	a0,8000217e <sched+0xae>
    800020f2:	8712                	mv	a4,tp
  if(mycpu()->noff != 1)
    800020f4:	2701                	sext.w	a4,a4
    800020f6:	00471793          	sll	a5,a4,0x4
    800020fa:	97ba                	add	a5,a5,a4
    800020fc:	078e                	sll	a5,a5,0x3
    800020fe:	0000f717          	auipc	a4,0xf
    80002102:	93270713          	add	a4,a4,-1742 # 80010a30 <pid_lock>
    80002106:	97ba                	add	a5,a5,a4
    80002108:	0a87a703          	lw	a4,168(a5)
    8000210c:	4785                	li	a5,1
    8000210e:	08f71063          	bne	a4,a5,8000218e <sched+0xbe>
  if(p->state == RUNNING)
    80002112:	4c98                	lw	a4,24(s1)
    80002114:	4791                	li	a5,4
    80002116:	08f70463          	beq	a4,a5,8000219e <sched+0xce>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000211a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000211e:	8b89                	and	a5,a5,2
  if(intr_get())
    80002120:	e7d9                	bnez	a5,800021ae <sched+0xde>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002122:	8712                	mv	a4,tp
  intena = mycpu()->intena;
    80002124:	0000f917          	auipc	s2,0xf
    80002128:	90c90913          	add	s2,s2,-1780 # 80010a30 <pid_lock>
    8000212c:	2701                	sext.w	a4,a4
    8000212e:	00471793          	sll	a5,a4,0x4
    80002132:	97ba                	add	a5,a5,a4
    80002134:	078e                	sll	a5,a5,0x3
    80002136:	97ca                	add	a5,a5,s2
    80002138:	0ac7a983          	lw	s3,172(a5)
    8000213c:	8712                	mv	a4,tp
  swtch(&p->context, &mycpu()->context);
    8000213e:	2701                	sext.w	a4,a4
    80002140:	00471793          	sll	a5,a4,0x4
    80002144:	97ba                	add	a5,a5,a4
    80002146:	078e                	sll	a5,a5,0x3
    80002148:	0000f597          	auipc	a1,0xf
    8000214c:	92058593          	add	a1,a1,-1760 # 80010a68 <cpus+0x8>
    80002150:	95be                	add	a1,a1,a5
    80002152:	07048513          	add	a0,s1,112
    80002156:	00000097          	auipc	ra,0x0
    8000215a:	608080e7          	jalr	1544(ra) # 8000275e <swtch>
    8000215e:	8712                	mv	a4,tp
  mycpu()->intena = intena;
    80002160:	2701                	sext.w	a4,a4
    80002162:	00471793          	sll	a5,a4,0x4
    80002166:	97ba                	add	a5,a5,a4
    80002168:	078e                	sll	a5,a5,0x3
    8000216a:	993e                	add	s2,s2,a5
    8000216c:	0b392623          	sw	s3,172(s2)
}
    80002170:	70a2                	ld	ra,40(sp)
    80002172:	7402                	ld	s0,32(sp)
    80002174:	64e2                	ld	s1,24(sp)
    80002176:	6942                	ld	s2,16(sp)
    80002178:	69a2                	ld	s3,8(sp)
    8000217a:	6145                	add	sp,sp,48
    8000217c:	8082                	ret
    panic("sched p->lock");
    8000217e:	00006517          	auipc	a0,0x6
    80002182:	0d250513          	add	a0,a0,210 # 80008250 <digits+0x218>
    80002186:	ffffe097          	auipc	ra,0xffffe
    8000218a:	688080e7          	jalr	1672(ra) # 8000080e <panic>
    panic("sched locks");
    8000218e:	00006517          	auipc	a0,0x6
    80002192:	0d250513          	add	a0,a0,210 # 80008260 <digits+0x228>
    80002196:	ffffe097          	auipc	ra,0xffffe
    8000219a:	678080e7          	jalr	1656(ra) # 8000080e <panic>
    panic("sched running");
    8000219e:	00006517          	auipc	a0,0x6
    800021a2:	0d250513          	add	a0,a0,210 # 80008270 <digits+0x238>
    800021a6:	ffffe097          	auipc	ra,0xffffe
    800021aa:	668080e7          	jalr	1640(ra) # 8000080e <panic>
    panic("sched interruptible");
    800021ae:	00006517          	auipc	a0,0x6
    800021b2:	0d250513          	add	a0,a0,210 # 80008280 <digits+0x248>
    800021b6:	ffffe097          	auipc	ra,0xffffe
    800021ba:	658080e7          	jalr	1624(ra) # 8000080e <panic>

00000000800021be <yield>:
{
    800021be:	1101                	add	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	e426                	sd	s1,8(sp)
    800021c6:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	942080e7          	jalr	-1726(ra) # 80001b0a <myproc>
    800021d0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	afa080e7          	jalr	-1286(ra) # 80000ccc <acquire>
  p->state = RUNNABLE;
    800021da:	478d                	li	a5,3
    800021dc:	cc9c                	sw	a5,24(s1)
  sched();
    800021de:	00000097          	auipc	ra,0x0
    800021e2:	ef2080e7          	jalr	-270(ra) # 800020d0 <sched>
  release(&p->lock);
    800021e6:	8526                	mv	a0,s1
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	b98080e7          	jalr	-1128(ra) # 80000d80 <release>
}
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	64a2                	ld	s1,8(sp)
    800021f6:	6105                	add	sp,sp,32
    800021f8:	8082                	ret

00000000800021fa <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    800021fa:	7179                	add	sp,sp,-48
    800021fc:	f406                	sd	ra,40(sp)
    800021fe:	f022                	sd	s0,32(sp)
    80002200:	ec26                	sd	s1,24(sp)
    80002202:	e84a                	sd	s2,16(sp)
    80002204:	e44e                	sd	s3,8(sp)
    80002206:	1800                	add	s0,sp,48
    80002208:	89aa                	mv	s3,a0
    8000220a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	8fe080e7          	jalr	-1794(ra) # 80001b0a <myproc>
    80002214:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	ab6080e7          	jalr	-1354(ra) # 80000ccc <acquire>
  release(lk);
    8000221e:	854a                	mv	a0,s2
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	b60080e7          	jalr	-1184(ra) # 80000d80 <release>

  /* Go to sleep. */
  p->chan = chan;
    80002228:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000222c:	4789                	li	a5,2
    8000222e:	cc9c                	sw	a5,24(s1)

  sched();
    80002230:	00000097          	auipc	ra,0x0
    80002234:	ea0080e7          	jalr	-352(ra) # 800020d0 <sched>

  /* Tidy up. */
  p->chan = 0;
    80002238:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    8000223c:	8526                	mv	a0,s1
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	b42080e7          	jalr	-1214(ra) # 80000d80 <release>
  acquire(lk);
    80002246:	854a                	mv	a0,s2
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	a84080e7          	jalr	-1404(ra) # 80000ccc <acquire>
}
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	64e2                	ld	s1,24(sp)
    80002256:	6942                	ld	s2,16(sp)
    80002258:	69a2                	ld	s3,8(sp)
    8000225a:	6145                	add	sp,sp,48
    8000225c:	8082                	ret

000000008000225e <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    8000225e:	7139                	add	sp,sp,-64
    80002260:	fc06                	sd	ra,56(sp)
    80002262:	f822                	sd	s0,48(sp)
    80002264:	f426                	sd	s1,40(sp)
    80002266:	f04a                	sd	s2,32(sp)
    80002268:	ec4e                	sd	s3,24(sp)
    8000226a:	e852                	sd	s4,16(sp)
    8000226c:	e456                	sd	s5,8(sp)
    8000226e:	0080                	add	s0,sp,64
    80002270:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002272:	0000f497          	auipc	s1,0xf
    80002276:	66e48493          	add	s1,s1,1646 # 800118e0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000227a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000227c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000227e:	00015917          	auipc	s2,0x15
    80002282:	46290913          	add	s2,s2,1122 # 800176e0 <tickslock>
    80002286:	a811                	j	8000229a <wakeup+0x3c>
      }
      release(&p->lock);
    80002288:	8526                	mv	a0,s1
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	af6080e7          	jalr	-1290(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002292:	17848493          	add	s1,s1,376
    80002296:	03248663          	beq	s1,s2,800022c2 <wakeup+0x64>
    if(p != myproc()){
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	870080e7          	jalr	-1936(ra) # 80001b0a <myproc>
    800022a2:	fea488e3          	beq	s1,a0,80002292 <wakeup+0x34>
      acquire(&p->lock);
    800022a6:	8526                	mv	a0,s1
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	a24080e7          	jalr	-1500(ra) # 80000ccc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022b0:	4c9c                	lw	a5,24(s1)
    800022b2:	fd379be3          	bne	a5,s3,80002288 <wakeup+0x2a>
    800022b6:	709c                	ld	a5,32(s1)
    800022b8:	fd4798e3          	bne	a5,s4,80002288 <wakeup+0x2a>
        p->state = RUNNABLE;
    800022bc:	0154ac23          	sw	s5,24(s1)
    800022c0:	b7e1                	j	80002288 <wakeup+0x2a>
    }
  }
}
    800022c2:	70e2                	ld	ra,56(sp)
    800022c4:	7442                	ld	s0,48(sp)
    800022c6:	74a2                	ld	s1,40(sp)
    800022c8:	7902                	ld	s2,32(sp)
    800022ca:	69e2                	ld	s3,24(sp)
    800022cc:	6a42                	ld	s4,16(sp)
    800022ce:	6aa2                	ld	s5,8(sp)
    800022d0:	6121                	add	sp,sp,64
    800022d2:	8082                	ret

00000000800022d4 <reparent>:
{
    800022d4:	7179                	add	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	e052                	sd	s4,0(sp)
    800022e2:	1800                	add	s0,sp,48
    800022e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e6:	0000f497          	auipc	s1,0xf
    800022ea:	5fa48493          	add	s1,s1,1530 # 800118e0 <proc>
      pp->parent = initproc;
    800022ee:	00006a17          	auipc	s4,0x6
    800022f2:	60aa0a13          	add	s4,s4,1546 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022f6:	00015997          	auipc	s3,0x15
    800022fa:	3ea98993          	add	s3,s3,1002 # 800176e0 <tickslock>
    800022fe:	a029                	j	80002308 <reparent+0x34>
    80002300:	17848493          	add	s1,s1,376
    80002304:	01348d63          	beq	s1,s3,8000231e <reparent+0x4a>
    if(pp->parent == p){
    80002308:	64bc                	ld	a5,72(s1)
    8000230a:	ff279be3          	bne	a5,s2,80002300 <reparent+0x2c>
      pp->parent = initproc;
    8000230e:	000a3503          	ld	a0,0(s4)
    80002312:	e4a8                	sd	a0,72(s1)
      wakeup(initproc);
    80002314:	00000097          	auipc	ra,0x0
    80002318:	f4a080e7          	jalr	-182(ra) # 8000225e <wakeup>
    8000231c:	b7d5                	j	80002300 <reparent+0x2c>
}
    8000231e:	70a2                	ld	ra,40(sp)
    80002320:	7402                	ld	s0,32(sp)
    80002322:	64e2                	ld	s1,24(sp)
    80002324:	6942                	ld	s2,16(sp)
    80002326:	69a2                	ld	s3,8(sp)
    80002328:	6a02                	ld	s4,0(sp)
    8000232a:	6145                	add	sp,sp,48
    8000232c:	8082                	ret

000000008000232e <exit>:
{
    8000232e:	7179                	add	sp,sp,-48
    80002330:	f406                	sd	ra,40(sp)
    80002332:	f022                	sd	s0,32(sp)
    80002334:	ec26                	sd	s1,24(sp)
    80002336:	e84a                	sd	s2,16(sp)
    80002338:	e44e                	sd	s3,8(sp)
    8000233a:	e052                	sd	s4,0(sp)
    8000233c:	1800                	add	s0,sp,48
    8000233e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	7ca080e7          	jalr	1994(ra) # 80001b0a <myproc>
    80002348:	89aa                	mv	s3,a0
  if(p == initproc)
    8000234a:	00006797          	auipc	a5,0x6
    8000234e:	5ae7b783          	ld	a5,1454(a5) # 800088f8 <initproc>
    80002352:	0e050493          	add	s1,a0,224
    80002356:	16050913          	add	s2,a0,352
    8000235a:	02a79363          	bne	a5,a0,80002380 <exit+0x52>
    panic("init exiting");
    8000235e:	00006517          	auipc	a0,0x6
    80002362:	f3a50513          	add	a0,a0,-198 # 80008298 <digits+0x260>
    80002366:	ffffe097          	auipc	ra,0xffffe
    8000236a:	4a8080e7          	jalr	1192(ra) # 8000080e <panic>
      fileclose(f);
    8000236e:	00002097          	auipc	ra,0x2
    80002372:	2b8080e7          	jalr	696(ra) # 80004626 <fileclose>
      p->ofile[fd] = 0;
    80002376:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000237a:	04a1                	add	s1,s1,8
    8000237c:	01248563          	beq	s1,s2,80002386 <exit+0x58>
    if(p->ofile[fd]){
    80002380:	6088                	ld	a0,0(s1)
    80002382:	f575                	bnez	a0,8000236e <exit+0x40>
    80002384:	bfdd                	j	8000237a <exit+0x4c>
  begin_op();
    80002386:	00002097          	auipc	ra,0x2
    8000238a:	ddc080e7          	jalr	-548(ra) # 80004162 <begin_op>
  iput(p->cwd);
    8000238e:	1609b503          	ld	a0,352(s3)
    80002392:	00001097          	auipc	ra,0x1
    80002396:	5e4080e7          	jalr	1508(ra) # 80003976 <iput>
  end_op();
    8000239a:	00002097          	auipc	ra,0x2
    8000239e:	e42080e7          	jalr	-446(ra) # 800041dc <end_op>
  p->cwd = 0;
    800023a2:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    800023a6:	0000e497          	auipc	s1,0xe
    800023aa:	6a248493          	add	s1,s1,1698 # 80010a48 <wait_lock>
    800023ae:	8526                	mv	a0,s1
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	91c080e7          	jalr	-1764(ra) # 80000ccc <acquire>
  reparent(p);
    800023b8:	854e                	mv	a0,s3
    800023ba:	00000097          	auipc	ra,0x0
    800023be:	f1a080e7          	jalr	-230(ra) # 800022d4 <reparent>
  wakeup(p->parent);
    800023c2:	0489b503          	ld	a0,72(s3)
    800023c6:	00000097          	auipc	ra,0x0
    800023ca:	e98080e7          	jalr	-360(ra) # 8000225e <wakeup>
  acquire(&p->lock);
    800023ce:	854e                	mv	a0,s3
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	8fc080e7          	jalr	-1796(ra) # 80000ccc <acquire>
  p->xstate = status;
    800023d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800023dc:	4795                	li	a5,5
    800023de:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800023e2:	8526                	mv	a0,s1
    800023e4:	fffff097          	auipc	ra,0xfffff
    800023e8:	99c080e7          	jalr	-1636(ra) # 80000d80 <release>
  sched();
    800023ec:	00000097          	auipc	ra,0x0
    800023f0:	ce4080e7          	jalr	-796(ra) # 800020d0 <sched>
  panic("zombie exit");
    800023f4:	00006517          	auipc	a0,0x6
    800023f8:	eb450513          	add	a0,a0,-332 # 800082a8 <digits+0x270>
    800023fc:	ffffe097          	auipc	ra,0xffffe
    80002400:	412080e7          	jalr	1042(ra) # 8000080e <panic>

0000000080002404 <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    80002404:	7179                	add	sp,sp,-48
    80002406:	f406                	sd	ra,40(sp)
    80002408:	f022                	sd	s0,32(sp)
    8000240a:	ec26                	sd	s1,24(sp)
    8000240c:	e84a                	sd	s2,16(sp)
    8000240e:	e44e                	sd	s3,8(sp)
    80002410:	1800                	add	s0,sp,48
    80002412:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002414:	0000f497          	auipc	s1,0xf
    80002418:	4cc48493          	add	s1,s1,1228 # 800118e0 <proc>
    8000241c:	00015997          	auipc	s3,0x15
    80002420:	2c498993          	add	s3,s3,708 # 800176e0 <tickslock>
    acquire(&p->lock);
    80002424:	8526                	mv	a0,s1
    80002426:	fffff097          	auipc	ra,0xfffff
    8000242a:	8a6080e7          	jalr	-1882(ra) # 80000ccc <acquire>
    if(p->pid == pid){
    8000242e:	589c                	lw	a5,48(s1)
    80002430:	01278d63          	beq	a5,s2,8000244a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002434:	8526                	mv	a0,s1
    80002436:	fffff097          	auipc	ra,0xfffff
    8000243a:	94a080e7          	jalr	-1718(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000243e:	17848493          	add	s1,s1,376
    80002442:	ff3491e3          	bne	s1,s3,80002424 <kill+0x20>
  }
  return -1;
    80002446:	557d                	li	a0,-1
    80002448:	a829                	j	80002462 <kill+0x5e>
      p->killed = 1;
    8000244a:	4785                	li	a5,1
    8000244c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000244e:	4c98                	lw	a4,24(s1)
    80002450:	4789                	li	a5,2
    80002452:	00f70f63          	beq	a4,a5,80002470 <kill+0x6c>
      release(&p->lock);
    80002456:	8526                	mv	a0,s1
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	928080e7          	jalr	-1752(ra) # 80000d80 <release>
      return 0;
    80002460:	4501                	li	a0,0
}
    80002462:	70a2                	ld	ra,40(sp)
    80002464:	7402                	ld	s0,32(sp)
    80002466:	64e2                	ld	s1,24(sp)
    80002468:	6942                	ld	s2,16(sp)
    8000246a:	69a2                	ld	s3,8(sp)
    8000246c:	6145                	add	sp,sp,48
    8000246e:	8082                	ret
        p->state = RUNNABLE;
    80002470:	478d                	li	a5,3
    80002472:	cc9c                	sw	a5,24(s1)
    80002474:	b7cd                	j	80002456 <kill+0x52>

0000000080002476 <setkilled>:

void
setkilled(struct proc *p)
{
    80002476:	1101                	add	sp,sp,-32
    80002478:	ec06                	sd	ra,24(sp)
    8000247a:	e822                	sd	s0,16(sp)
    8000247c:	e426                	sd	s1,8(sp)
    8000247e:	1000                	add	s0,sp,32
    80002480:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002482:	fffff097          	auipc	ra,0xfffff
    80002486:	84a080e7          	jalr	-1974(ra) # 80000ccc <acquire>
  p->killed = 1;
    8000248a:	4785                	li	a5,1
    8000248c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000248e:	8526                	mv	a0,s1
    80002490:	fffff097          	auipc	ra,0xfffff
    80002494:	8f0080e7          	jalr	-1808(ra) # 80000d80 <release>
}
    80002498:	60e2                	ld	ra,24(sp)
    8000249a:	6442                	ld	s0,16(sp)
    8000249c:	64a2                	ld	s1,8(sp)
    8000249e:	6105                	add	sp,sp,32
    800024a0:	8082                	ret

00000000800024a2 <killed>:

int
killed(struct proc *p)
{
    800024a2:	1101                	add	sp,sp,-32
    800024a4:	ec06                	sd	ra,24(sp)
    800024a6:	e822                	sd	s0,16(sp)
    800024a8:	e426                	sd	s1,8(sp)
    800024aa:	e04a                	sd	s2,0(sp)
    800024ac:	1000                	add	s0,sp,32
    800024ae:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800024b0:	fffff097          	auipc	ra,0xfffff
    800024b4:	81c080e7          	jalr	-2020(ra) # 80000ccc <acquire>
  k = p->killed;
    800024b8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800024bc:	8526                	mv	a0,s1
    800024be:	fffff097          	auipc	ra,0xfffff
    800024c2:	8c2080e7          	jalr	-1854(ra) # 80000d80 <release>
  return k;
}
    800024c6:	854a                	mv	a0,s2
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	64a2                	ld	s1,8(sp)
    800024ce:	6902                	ld	s2,0(sp)
    800024d0:	6105                	add	sp,sp,32
    800024d2:	8082                	ret

00000000800024d4 <wait>:
{
    800024d4:	715d                	add	sp,sp,-80
    800024d6:	e486                	sd	ra,72(sp)
    800024d8:	e0a2                	sd	s0,64(sp)
    800024da:	fc26                	sd	s1,56(sp)
    800024dc:	f84a                	sd	s2,48(sp)
    800024de:	f44e                	sd	s3,40(sp)
    800024e0:	f052                	sd	s4,32(sp)
    800024e2:	ec56                	sd	s5,24(sp)
    800024e4:	e85a                	sd	s6,16(sp)
    800024e6:	e45e                	sd	s7,8(sp)
    800024e8:	e062                	sd	s8,0(sp)
    800024ea:	0880                	add	s0,sp,80
    800024ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	61c080e7          	jalr	1564(ra) # 80001b0a <myproc>
    800024f6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800024f8:	0000e517          	auipc	a0,0xe
    800024fc:	55050513          	add	a0,a0,1360 # 80010a48 <wait_lock>
    80002500:	ffffe097          	auipc	ra,0xffffe
    80002504:	7cc080e7          	jalr	1996(ra) # 80000ccc <acquire>
    havekids = 0;
    80002508:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000250a:	4a15                	li	s4,5
        havekids = 1;
    8000250c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000250e:	00015997          	auipc	s3,0x15
    80002512:	1d298993          	add	s3,s3,466 # 800176e0 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    80002516:	0000ec17          	auipc	s8,0xe
    8000251a:	532c0c13          	add	s8,s8,1330 # 80010a48 <wait_lock>
    8000251e:	a0d1                	j	800025e2 <wait+0x10e>
          pid = pp->pid;
    80002520:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002524:	000b0e63          	beqz	s6,80002540 <wait+0x6c>
    80002528:	4691                	li	a3,4
    8000252a:	02c48613          	add	a2,s1,44
    8000252e:	85da                	mv	a1,s6
    80002530:	06093503          	ld	a0,96(s2)
    80002534:	fffff097          	auipc	ra,0xfffff
    80002538:	250080e7          	jalr	592(ra) # 80001784 <copyout>
    8000253c:	04054163          	bltz	a0,8000257e <wait+0xaa>
          freeproc(pp);
    80002540:	8526                	mv	a0,s1
    80002542:	fffff097          	auipc	ra,0xfffff
    80002546:	784080e7          	jalr	1924(ra) # 80001cc6 <freeproc>
          release(&pp->lock);
    8000254a:	8526                	mv	a0,s1
    8000254c:	fffff097          	auipc	ra,0xfffff
    80002550:	834080e7          	jalr	-1996(ra) # 80000d80 <release>
          release(&wait_lock);
    80002554:	0000e517          	auipc	a0,0xe
    80002558:	4f450513          	add	a0,a0,1268 # 80010a48 <wait_lock>
    8000255c:	fffff097          	auipc	ra,0xfffff
    80002560:	824080e7          	jalr	-2012(ra) # 80000d80 <release>
}
    80002564:	854e                	mv	a0,s3
    80002566:	60a6                	ld	ra,72(sp)
    80002568:	6406                	ld	s0,64(sp)
    8000256a:	74e2                	ld	s1,56(sp)
    8000256c:	7942                	ld	s2,48(sp)
    8000256e:	79a2                	ld	s3,40(sp)
    80002570:	7a02                	ld	s4,32(sp)
    80002572:	6ae2                	ld	s5,24(sp)
    80002574:	6b42                	ld	s6,16(sp)
    80002576:	6ba2                	ld	s7,8(sp)
    80002578:	6c02                	ld	s8,0(sp)
    8000257a:	6161                	add	sp,sp,80
    8000257c:	8082                	ret
            release(&pp->lock);
    8000257e:	8526                	mv	a0,s1
    80002580:	fffff097          	auipc	ra,0xfffff
    80002584:	800080e7          	jalr	-2048(ra) # 80000d80 <release>
            release(&wait_lock);
    80002588:	0000e517          	auipc	a0,0xe
    8000258c:	4c050513          	add	a0,a0,1216 # 80010a48 <wait_lock>
    80002590:	ffffe097          	auipc	ra,0xffffe
    80002594:	7f0080e7          	jalr	2032(ra) # 80000d80 <release>
            return -1;
    80002598:	59fd                	li	s3,-1
    8000259a:	b7e9                	j	80002564 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000259c:	17848493          	add	s1,s1,376
    800025a0:	03348463          	beq	s1,s3,800025c8 <wait+0xf4>
      if(pp->parent == p){
    800025a4:	64bc                	ld	a5,72(s1)
    800025a6:	ff279be3          	bne	a5,s2,8000259c <wait+0xc8>
        acquire(&pp->lock);
    800025aa:	8526                	mv	a0,s1
    800025ac:	ffffe097          	auipc	ra,0xffffe
    800025b0:	720080e7          	jalr	1824(ra) # 80000ccc <acquire>
        if(pp->state == ZOMBIE){
    800025b4:	4c9c                	lw	a5,24(s1)
    800025b6:	f74785e3          	beq	a5,s4,80002520 <wait+0x4c>
        release(&pp->lock);
    800025ba:	8526                	mv	a0,s1
    800025bc:	ffffe097          	auipc	ra,0xffffe
    800025c0:	7c4080e7          	jalr	1988(ra) # 80000d80 <release>
        havekids = 1;
    800025c4:	8756                	mv	a4,s5
    800025c6:	bfd9                	j	8000259c <wait+0xc8>
    if(!havekids || killed(p)){
    800025c8:	c31d                	beqz	a4,800025ee <wait+0x11a>
    800025ca:	854a                	mv	a0,s2
    800025cc:	00000097          	auipc	ra,0x0
    800025d0:	ed6080e7          	jalr	-298(ra) # 800024a2 <killed>
    800025d4:	ed09                	bnez	a0,800025ee <wait+0x11a>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800025d6:	85e2                	mv	a1,s8
    800025d8:	854a                	mv	a0,s2
    800025da:	00000097          	auipc	ra,0x0
    800025de:	c20080e7          	jalr	-992(ra) # 800021fa <sleep>
    havekids = 0;
    800025e2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025e4:	0000f497          	auipc	s1,0xf
    800025e8:	2fc48493          	add	s1,s1,764 # 800118e0 <proc>
    800025ec:	bf65                	j	800025a4 <wait+0xd0>
      release(&wait_lock);
    800025ee:	0000e517          	auipc	a0,0xe
    800025f2:	45a50513          	add	a0,a0,1114 # 80010a48 <wait_lock>
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	78a080e7          	jalr	1930(ra) # 80000d80 <release>
      return -1;
    800025fe:	59fd                	li	s3,-1
    80002600:	b795                	j	80002564 <wait+0x90>

0000000080002602 <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002602:	7179                	add	sp,sp,-48
    80002604:	f406                	sd	ra,40(sp)
    80002606:	f022                	sd	s0,32(sp)
    80002608:	ec26                	sd	s1,24(sp)
    8000260a:	e84a                	sd	s2,16(sp)
    8000260c:	e44e                	sd	s3,8(sp)
    8000260e:	e052                	sd	s4,0(sp)
    80002610:	1800                	add	s0,sp,48
    80002612:	84aa                	mv	s1,a0
    80002614:	892e                	mv	s2,a1
    80002616:	89b2                	mv	s3,a2
    80002618:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000261a:	fffff097          	auipc	ra,0xfffff
    8000261e:	4f0080e7          	jalr	1264(ra) # 80001b0a <myproc>
  if(user_dst){
    80002622:	c08d                	beqz	s1,80002644 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002624:	86d2                	mv	a3,s4
    80002626:	864e                	mv	a2,s3
    80002628:	85ca                	mv	a1,s2
    8000262a:	7128                	ld	a0,96(a0)
    8000262c:	fffff097          	auipc	ra,0xfffff
    80002630:	158080e7          	jalr	344(ra) # 80001784 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002634:	70a2                	ld	ra,40(sp)
    80002636:	7402                	ld	s0,32(sp)
    80002638:	64e2                	ld	s1,24(sp)
    8000263a:	6942                	ld	s2,16(sp)
    8000263c:	69a2                	ld	s3,8(sp)
    8000263e:	6a02                	ld	s4,0(sp)
    80002640:	6145                	add	sp,sp,48
    80002642:	8082                	ret
    memmove((char *)dst, src, len);
    80002644:	000a061b          	sext.w	a2,s4
    80002648:	85ce                	mv	a1,s3
    8000264a:	854a                	mv	a0,s2
    8000264c:	ffffe097          	auipc	ra,0xffffe
    80002650:	7d8080e7          	jalr	2008(ra) # 80000e24 <memmove>
    return 0;
    80002654:	8526                	mv	a0,s1
    80002656:	bff9                	j	80002634 <either_copyout+0x32>

0000000080002658 <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002658:	7179                	add	sp,sp,-48
    8000265a:	f406                	sd	ra,40(sp)
    8000265c:	f022                	sd	s0,32(sp)
    8000265e:	ec26                	sd	s1,24(sp)
    80002660:	e84a                	sd	s2,16(sp)
    80002662:	e44e                	sd	s3,8(sp)
    80002664:	e052                	sd	s4,0(sp)
    80002666:	1800                	add	s0,sp,48
    80002668:	892a                	mv	s2,a0
    8000266a:	84ae                	mv	s1,a1
    8000266c:	89b2                	mv	s3,a2
    8000266e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002670:	fffff097          	auipc	ra,0xfffff
    80002674:	49a080e7          	jalr	1178(ra) # 80001b0a <myproc>
  if(user_src){
    80002678:	c08d                	beqz	s1,8000269a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000267a:	86d2                	mv	a3,s4
    8000267c:	864e                	mv	a2,s3
    8000267e:	85ca                	mv	a1,s2
    80002680:	7128                	ld	a0,96(a0)
    80002682:	fffff097          	auipc	ra,0xfffff
    80002686:	1c2080e7          	jalr	450(ra) # 80001844 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000268a:	70a2                	ld	ra,40(sp)
    8000268c:	7402                	ld	s0,32(sp)
    8000268e:	64e2                	ld	s1,24(sp)
    80002690:	6942                	ld	s2,16(sp)
    80002692:	69a2                	ld	s3,8(sp)
    80002694:	6a02                	ld	s4,0(sp)
    80002696:	6145                	add	sp,sp,48
    80002698:	8082                	ret
    memmove(dst, (char*)src, len);
    8000269a:	000a061b          	sext.w	a2,s4
    8000269e:	85ce                	mv	a1,s3
    800026a0:	854a                	mv	a0,s2
    800026a2:	ffffe097          	auipc	ra,0xffffe
    800026a6:	782080e7          	jalr	1922(ra) # 80000e24 <memmove>
    return 0;
    800026aa:	8526                	mv	a0,s1
    800026ac:	bff9                	j	8000268a <either_copyin+0x32>

00000000800026ae <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    800026ae:	715d                	add	sp,sp,-80
    800026b0:	e486                	sd	ra,72(sp)
    800026b2:	e0a2                	sd	s0,64(sp)
    800026b4:	fc26                	sd	s1,56(sp)
    800026b6:	f84a                	sd	s2,48(sp)
    800026b8:	f44e                	sd	s3,40(sp)
    800026ba:	f052                	sd	s4,32(sp)
    800026bc:	ec56                	sd	s5,24(sp)
    800026be:	e85a                	sd	s6,16(sp)
    800026c0:	e45e                	sd	s7,8(sp)
    800026c2:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800026c4:	00006517          	auipc	a0,0x6
    800026c8:	9fc50513          	add	a0,a0,-1540 # 800080c0 <digits+0x88>
    800026cc:	ffffe097          	auipc	ra,0xffffe
    800026d0:	e36080e7          	jalr	-458(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026d4:	0000f497          	auipc	s1,0xf
    800026d8:	37448493          	add	s1,s1,884 # 80011a48 <proc+0x168>
    800026dc:	00015917          	auipc	s2,0x15
    800026e0:	16c90913          	add	s2,s2,364 # 80017848 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026e4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800026e6:	00006997          	auipc	s3,0x6
    800026ea:	bd298993          	add	s3,s3,-1070 # 800082b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    800026ee:	00006a97          	auipc	s5,0x6
    800026f2:	bd2a8a93          	add	s5,s5,-1070 # 800082c0 <digits+0x288>
    printf("\n");
    800026f6:	00006a17          	auipc	s4,0x6
    800026fa:	9caa0a13          	add	s4,s4,-1590 # 800080c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026fe:	00006b97          	auipc	s7,0x6
    80002702:	c02b8b93          	add	s7,s7,-1022 # 80008300 <states.0>
    80002706:	a00d                	j	80002728 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002708:	ec86a583          	lw	a1,-312(a3)
    8000270c:	8556                	mv	a0,s5
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	df4080e7          	jalr	-524(ra) # 80000502 <printf>
    printf("\n");
    80002716:	8552                	mv	a0,s4
    80002718:	ffffe097          	auipc	ra,0xffffe
    8000271c:	dea080e7          	jalr	-534(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002720:	17848493          	add	s1,s1,376
    80002724:	03248263          	beq	s1,s2,80002748 <procdump+0x9a>
    if(p->state == UNUSED)
    80002728:	86a6                	mv	a3,s1
    8000272a:	eb04a783          	lw	a5,-336(s1)
    8000272e:	dbed                	beqz	a5,80002720 <procdump+0x72>
      state = "???";
    80002730:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002732:	fcfb6be3          	bltu	s6,a5,80002708 <procdump+0x5a>
    80002736:	02079713          	sll	a4,a5,0x20
    8000273a:	01d75793          	srl	a5,a4,0x1d
    8000273e:	97de                	add	a5,a5,s7
    80002740:	6390                	ld	a2,0(a5)
    80002742:	f279                	bnez	a2,80002708 <procdump+0x5a>
      state = "???";
    80002744:	864e                	mv	a2,s3
    80002746:	b7c9                	j	80002708 <procdump+0x5a>
  }
}
    80002748:	60a6                	ld	ra,72(sp)
    8000274a:	6406                	ld	s0,64(sp)
    8000274c:	74e2                	ld	s1,56(sp)
    8000274e:	7942                	ld	s2,48(sp)
    80002750:	79a2                	ld	s3,40(sp)
    80002752:	7a02                	ld	s4,32(sp)
    80002754:	6ae2                	ld	s5,24(sp)
    80002756:	6b42                	ld	s6,16(sp)
    80002758:	6ba2                	ld	s7,8(sp)
    8000275a:	6161                	add	sp,sp,80
    8000275c:	8082                	ret

000000008000275e <swtch>:
    8000275e:	00153023          	sd	ra,0(a0)
    80002762:	00253423          	sd	sp,8(a0)
    80002766:	e900                	sd	s0,16(a0)
    80002768:	ed04                	sd	s1,24(a0)
    8000276a:	03253023          	sd	s2,32(a0)
    8000276e:	03353423          	sd	s3,40(a0)
    80002772:	03453823          	sd	s4,48(a0)
    80002776:	03553c23          	sd	s5,56(a0)
    8000277a:	05653023          	sd	s6,64(a0)
    8000277e:	05753423          	sd	s7,72(a0)
    80002782:	05853823          	sd	s8,80(a0)
    80002786:	05953c23          	sd	s9,88(a0)
    8000278a:	07a53023          	sd	s10,96(a0)
    8000278e:	07b53423          	sd	s11,104(a0)
    80002792:	0005b083          	ld	ra,0(a1)
    80002796:	0085b103          	ld	sp,8(a1)
    8000279a:	6980                	ld	s0,16(a1)
    8000279c:	6d84                	ld	s1,24(a1)
    8000279e:	0205b903          	ld	s2,32(a1)
    800027a2:	0285b983          	ld	s3,40(a1)
    800027a6:	0305ba03          	ld	s4,48(a1)
    800027aa:	0385ba83          	ld	s5,56(a1)
    800027ae:	0405bb03          	ld	s6,64(a1)
    800027b2:	0485bb83          	ld	s7,72(a1)
    800027b6:	0505bc03          	ld	s8,80(a1)
    800027ba:	0585bc83          	ld	s9,88(a1)
    800027be:	0605bd03          	ld	s10,96(a1)
    800027c2:	0685bd83          	ld	s11,104(a1)
    800027c6:	8082                	ret

00000000800027c8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800027c8:	1141                	add	sp,sp,-16
    800027ca:	e406                	sd	ra,8(sp)
    800027cc:	e022                	sd	s0,0(sp)
    800027ce:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    800027d0:	00006597          	auipc	a1,0x6
    800027d4:	b6058593          	add	a1,a1,-1184 # 80008330 <states.0+0x30>
    800027d8:	00015517          	auipc	a0,0x15
    800027dc:	f0850513          	add	a0,a0,-248 # 800176e0 <tickslock>
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	45c080e7          	jalr	1116(ra) # 80000c3c <initlock>
}
    800027e8:	60a2                	ld	ra,8(sp)
    800027ea:	6402                	ld	s0,0(sp)
    800027ec:	0141                	add	sp,sp,16
    800027ee:	8082                	ret

00000000800027f0 <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    800027f0:	1141                	add	sp,sp,-16
    800027f2:	e422                	sd	s0,8(sp)
    800027f4:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027f6:	00003797          	auipc	a5,0x3
    800027fa:	45a78793          	add	a5,a5,1114 # 80005c50 <kernelvec>
    800027fe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002802:	6422                	ld	s0,8(sp)
    80002804:	0141                	add	sp,sp,16
    80002806:	8082                	ret

0000000080002808 <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    80002808:	1141                	add	sp,sp,-16
    8000280a:	e406                	sd	ra,8(sp)
    8000280c:	e022                	sd	s0,0(sp)
    8000280e:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002810:	fffff097          	auipc	ra,0xfffff
    80002814:	2fa080e7          	jalr	762(ra) # 80001b0a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002818:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000281c:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000281e:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002822:	00004697          	auipc	a3,0x4
    80002826:	7de68693          	add	a3,a3,2014 # 80007000 <_trampoline>
    8000282a:	00004717          	auipc	a4,0x4
    8000282e:	7d670713          	add	a4,a4,2006 # 80007000 <_trampoline>
    80002832:	8f15                	sub	a4,a4,a3
    80002834:	040007b7          	lui	a5,0x4000
    80002838:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000283a:	07b2                	sll	a5,a5,0xc
    8000283c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000283e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    80002842:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002844:	18002673          	csrr	a2,satp
    80002848:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    8000284a:	7530                	ld	a2,104(a0)
    8000284c:	6938                	ld	a4,80(a0)
    8000284e:	6585                	lui	a1,0x1
    80002850:	972e                	add	a4,a4,a1
    80002852:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002854:	7538                	ld	a4,104(a0)
    80002856:	00000617          	auipc	a2,0x0
    8000285a:	13460613          	add	a2,a2,308 # 8000298a <usertrap>
    8000285e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    80002860:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002862:	8612                	mv	a2,tp
    80002864:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002866:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    8000286a:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    8000286e:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002872:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    80002876:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002878:	6f18                	ld	a4,24(a4)
    8000287a:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    8000287e:	7128                	ld	a0,96(a0)
    80002880:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002882:	00005717          	auipc	a4,0x5
    80002886:	81a70713          	add	a4,a4,-2022 # 8000709c <userret>
    8000288a:	8f15                	sub	a4,a4,a3
    8000288c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000288e:	577d                	li	a4,-1
    80002890:	177e                	sll	a4,a4,0x3f
    80002892:	8d59                	or	a0,a0,a4
    80002894:	9782                	jalr	a5
}
    80002896:	60a2                	ld	ra,8(sp)
    80002898:	6402                	ld	s0,0(sp)
    8000289a:	0141                	add	sp,sp,16
    8000289c:	8082                	ret

000000008000289e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000289e:	1101                	add	sp,sp,-32
    800028a0:	ec06                	sd	ra,24(sp)
    800028a2:	e822                	sd	s0,16(sp)
    800028a4:	e426                	sd	s1,8(sp)
    800028a6:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    800028a8:	fffff097          	auipc	ra,0xfffff
    800028ac:	230080e7          	jalr	560(ra) # 80001ad8 <cpuid>
    800028b0:	cd19                	beqz	a0,800028ce <clockintr+0x30>
  asm volatile("csrr %0, time" : "=r" (x) );
    800028b2:	c01027f3          	rdtime	a5
  }

  /* ask for the next timer interrupt. this also clears */
  /* the interrupt request. 1000000 is about a tenth */
  /* of a second. */
  w_stimecmp(r_time() + 1000000);
    800028b6:	000f4737          	lui	a4,0xf4
    800028ba:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800028be:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800028c0:	14d79073          	csrw	stimecmp,a5
}
    800028c4:	60e2                	ld	ra,24(sp)
    800028c6:	6442                	ld	s0,16(sp)
    800028c8:	64a2                	ld	s1,8(sp)
    800028ca:	6105                	add	sp,sp,32
    800028cc:	8082                	ret
    acquire(&tickslock);
    800028ce:	00015497          	auipc	s1,0x15
    800028d2:	e1248493          	add	s1,s1,-494 # 800176e0 <tickslock>
    800028d6:	8526                	mv	a0,s1
    800028d8:	ffffe097          	auipc	ra,0xffffe
    800028dc:	3f4080e7          	jalr	1012(ra) # 80000ccc <acquire>
    ticks++;
    800028e0:	00006517          	auipc	a0,0x6
    800028e4:	02050513          	add	a0,a0,32 # 80008900 <ticks>
    800028e8:	411c                	lw	a5,0(a0)
    800028ea:	2785                	addw	a5,a5,1
    800028ec:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800028ee:	00000097          	auipc	ra,0x0
    800028f2:	970080e7          	jalr	-1680(ra) # 8000225e <wakeup>
    release(&tickslock);
    800028f6:	8526                	mv	a0,s1
    800028f8:	ffffe097          	auipc	ra,0xffffe
    800028fc:	488080e7          	jalr	1160(ra) # 80000d80 <release>
    80002900:	bf4d                	j	800028b2 <clockintr+0x14>

0000000080002902 <devintr>:
/* returns 2 if timer interrupt, */
/* 1 if other device, */
/* 0 if not recognized. */
int
devintr()
{
    80002902:	1101                	add	sp,sp,-32
    80002904:	ec06                	sd	ra,24(sp)
    80002906:	e822                	sd	s0,16(sp)
    80002908:	e426                	sd	s1,8(sp)
    8000290a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000290c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002910:	57fd                	li	a5,-1
    80002912:	17fe                	sll	a5,a5,0x3f
    80002914:	07a5                	add	a5,a5,9
    80002916:	00f70d63          	beq	a4,a5,80002930 <devintr+0x2e>
    /* now allowed to interrupt again. */
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000291a:	57fd                	li	a5,-1
    8000291c:	17fe                	sll	a5,a5,0x3f
    8000291e:	0795                	add	a5,a5,5
    /* timer interrupt. */
    clockintr();
    return 2;
  } else {
    return 0;
    80002920:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002922:	04f70e63          	beq	a4,a5,8000297e <devintr+0x7c>
  }
}
    80002926:	60e2                	ld	ra,24(sp)
    80002928:	6442                	ld	s0,16(sp)
    8000292a:	64a2                	ld	s1,8(sp)
    8000292c:	6105                	add	sp,sp,32
    8000292e:	8082                	ret
    int irq = plic_claim();
    80002930:	00003097          	auipc	ra,0x3
    80002934:	3cc080e7          	jalr	972(ra) # 80005cfc <plic_claim>
    80002938:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000293a:	47a9                	li	a5,10
    8000293c:	02f50763          	beq	a0,a5,8000296a <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80002940:	4785                	li	a5,1
    80002942:	02f50963          	beq	a0,a5,80002974 <devintr+0x72>
    return 1;
    80002946:	4505                	li	a0,1
    } else if(irq){
    80002948:	dcf9                	beqz	s1,80002926 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    8000294a:	85a6                	mv	a1,s1
    8000294c:	00006517          	auipc	a0,0x6
    80002950:	9ec50513          	add	a0,a0,-1556 # 80008338 <states.0+0x38>
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	bae080e7          	jalr	-1106(ra) # 80000502 <printf>
      plic_complete(irq);
    8000295c:	8526                	mv	a0,s1
    8000295e:	00003097          	auipc	ra,0x3
    80002962:	3c2080e7          	jalr	962(ra) # 80005d20 <plic_complete>
    return 1;
    80002966:	4505                	li	a0,1
    80002968:	bf7d                	j	80002926 <devintr+0x24>
      uartintr();
    8000296a:	ffffe097          	auipc	ra,0xffffe
    8000296e:	124080e7          	jalr	292(ra) # 80000a8e <uartintr>
    if(irq)
    80002972:	b7ed                	j	8000295c <devintr+0x5a>
      virtio_disk_intr();
    80002974:	00004097          	auipc	ra,0x4
    80002978:	872080e7          	jalr	-1934(ra) # 800061e6 <virtio_disk_intr>
    if(irq)
    8000297c:	b7c5                	j	8000295c <devintr+0x5a>
    clockintr();
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	f20080e7          	jalr	-224(ra) # 8000289e <clockintr>
    return 2;
    80002986:	4509                	li	a0,2
    80002988:	bf79                	j	80002926 <devintr+0x24>

000000008000298a <usertrap>:
{
    8000298a:	1101                	add	sp,sp,-32
    8000298c:	ec06                	sd	ra,24(sp)
    8000298e:	e822                	sd	s0,16(sp)
    80002990:	e426                	sd	s1,8(sp)
    80002992:	e04a                	sd	s2,0(sp)
    80002994:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002996:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000299a:	1007f793          	and	a5,a5,256
    8000299e:	e3b1                	bnez	a5,800029e2 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029a0:	00003797          	auipc	a5,0x3
    800029a4:	2b078793          	add	a5,a5,688 # 80005c50 <kernelvec>
    800029a8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800029ac:	fffff097          	auipc	ra,0xfffff
    800029b0:	15e080e7          	jalr	350(ra) # 80001b0a <myproc>
    800029b4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800029b6:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029b8:	14102773          	csrr	a4,sepc
    800029bc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029be:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800029c2:	47a1                	li	a5,8
    800029c4:	02f70763          	beq	a4,a5,800029f2 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	f3a080e7          	jalr	-198(ra) # 80002902 <devintr>
    800029d0:	892a                	mv	s2,a0
    800029d2:	c151                	beqz	a0,80002a56 <usertrap+0xcc>
  if(killed(p))
    800029d4:	8526                	mv	a0,s1
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	acc080e7          	jalr	-1332(ra) # 800024a2 <killed>
    800029de:	c929                	beqz	a0,80002a30 <usertrap+0xa6>
    800029e0:	a099                	j	80002a26 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800029e2:	00006517          	auipc	a0,0x6
    800029e6:	97650513          	add	a0,a0,-1674 # 80008358 <states.0+0x58>
    800029ea:	ffffe097          	auipc	ra,0xffffe
    800029ee:	e24080e7          	jalr	-476(ra) # 8000080e <panic>
    if(killed(p))
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	ab0080e7          	jalr	-1360(ra) # 800024a2 <killed>
    800029fa:	e921                	bnez	a0,80002a4a <usertrap+0xc0>
    p->trapframe->epc += 4;
    800029fc:	74b8                	ld	a4,104(s1)
    800029fe:	6f1c                	ld	a5,24(a4)
    80002a00:	0791                	add	a5,a5,4
    80002a02:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a08:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a0c:	10079073          	csrw	sstatus,a5
    syscall();
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	2b4080e7          	jalr	692(ra) # 80002cc4 <syscall>
  if(killed(p))
    80002a18:	8526                	mv	a0,s1
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	a88080e7          	jalr	-1400(ra) # 800024a2 <killed>
    80002a22:	c911                	beqz	a0,80002a36 <usertrap+0xac>
    80002a24:	4901                	li	s2,0
    exit(-1);
    80002a26:	557d                	li	a0,-1
    80002a28:	00000097          	auipc	ra,0x0
    80002a2c:	906080e7          	jalr	-1786(ra) # 8000232e <exit>
  if(which_dev == 2)
    80002a30:	4789                	li	a5,2
    80002a32:	04f90f63          	beq	s2,a5,80002a90 <usertrap+0x106>
  usertrapret();
    80002a36:	00000097          	auipc	ra,0x0
    80002a3a:	dd2080e7          	jalr	-558(ra) # 80002808 <usertrapret>
}
    80002a3e:	60e2                	ld	ra,24(sp)
    80002a40:	6442                	ld	s0,16(sp)
    80002a42:	64a2                	ld	s1,8(sp)
    80002a44:	6902                	ld	s2,0(sp)
    80002a46:	6105                	add	sp,sp,32
    80002a48:	8082                	ret
      exit(-1);
    80002a4a:	557d                	li	a0,-1
    80002a4c:	00000097          	auipc	ra,0x0
    80002a50:	8e2080e7          	jalr	-1822(ra) # 8000232e <exit>
    80002a54:	b765                	j	800029fc <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002a5a:	5890                	lw	a2,48(s1)
    80002a5c:	00006517          	auipc	a0,0x6
    80002a60:	91c50513          	add	a0,a0,-1764 # 80008378 <states.0+0x78>
    80002a64:	ffffe097          	auipc	ra,0xffffe
    80002a68:	a9e080e7          	jalr	-1378(ra) # 80000502 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a70:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002a74:	00006517          	auipc	a0,0x6
    80002a78:	93450513          	add	a0,a0,-1740 # 800083a8 <states.0+0xa8>
    80002a7c:	ffffe097          	auipc	ra,0xffffe
    80002a80:	a86080e7          	jalr	-1402(ra) # 80000502 <printf>
    setkilled(p);
    80002a84:	8526                	mv	a0,s1
    80002a86:	00000097          	auipc	ra,0x0
    80002a8a:	9f0080e7          	jalr	-1552(ra) # 80002476 <setkilled>
    80002a8e:	b769                	j	80002a18 <usertrap+0x8e>
    yield();
    80002a90:	fffff097          	auipc	ra,0xfffff
    80002a94:	72e080e7          	jalr	1838(ra) # 800021be <yield>
    80002a98:	bf79                	j	80002a36 <usertrap+0xac>

0000000080002a9a <kerneltrap>:
{
    80002a9a:	7179                	add	sp,sp,-48
    80002a9c:	f406                	sd	ra,40(sp)
    80002a9e:	f022                	sd	s0,32(sp)
    80002aa0:	ec26                	sd	s1,24(sp)
    80002aa2:	e84a                	sd	s2,16(sp)
    80002aa4:	e44e                	sd	s3,8(sp)
    80002aa6:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002aa8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ab0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ab4:	1004f793          	and	a5,s1,256
    80002ab8:	cb85                	beqz	a5,80002ae8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002abe:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002ac0:	ef85                	bnez	a5,80002af8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	e40080e7          	jalr	-448(ra) # 80002902 <devintr>
    80002aca:	cd1d                	beqz	a0,80002b08 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0)
    80002acc:	4789                	li	a5,2
    80002ace:	06f50263          	beq	a0,a5,80002b32 <kerneltrap+0x98>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ad2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ad6:	10049073          	csrw	sstatus,s1
}
    80002ada:	70a2                	ld	ra,40(sp)
    80002adc:	7402                	ld	s0,32(sp)
    80002ade:	64e2                	ld	s1,24(sp)
    80002ae0:	6942                	ld	s2,16(sp)
    80002ae2:	69a2                	ld	s3,8(sp)
    80002ae4:	6145                	add	sp,sp,48
    80002ae6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	8e850513          	add	a0,a0,-1816 # 800083d0 <states.0+0xd0>
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	d1e080e7          	jalr	-738(ra) # 8000080e <panic>
    panic("kerneltrap: interrupts enabled");
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	90050513          	add	a0,a0,-1792 # 800083f8 <states.0+0xf8>
    80002b00:	ffffe097          	auipc	ra,0xffffe
    80002b04:	d0e080e7          	jalr	-754(ra) # 8000080e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b08:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b0c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002b10:	85ce                	mv	a1,s3
    80002b12:	00006517          	auipc	a0,0x6
    80002b16:	90650513          	add	a0,a0,-1786 # 80008418 <states.0+0x118>
    80002b1a:	ffffe097          	auipc	ra,0xffffe
    80002b1e:	9e8080e7          	jalr	-1560(ra) # 80000502 <printf>
    panic("kerneltrap");
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	91e50513          	add	a0,a0,-1762 # 80008440 <states.0+0x140>
    80002b2a:	ffffe097          	auipc	ra,0xffffe
    80002b2e:	ce4080e7          	jalr	-796(ra) # 8000080e <panic>
  if(which_dev == 2 && myproc() != 0)
    80002b32:	fffff097          	auipc	ra,0xfffff
    80002b36:	fd8080e7          	jalr	-40(ra) # 80001b0a <myproc>
    80002b3a:	dd41                	beqz	a0,80002ad2 <kerneltrap+0x38>
    yield();
    80002b3c:	fffff097          	auipc	ra,0xfffff
    80002b40:	682080e7          	jalr	1666(ra) # 800021be <yield>
    80002b44:	b779                	j	80002ad2 <kerneltrap+0x38>

0000000080002b46 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b46:	1101                	add	sp,sp,-32
    80002b48:	ec06                	sd	ra,24(sp)
    80002b4a:	e822                	sd	s0,16(sp)
    80002b4c:	e426                	sd	s1,8(sp)
    80002b4e:	1000                	add	s0,sp,32
    80002b50:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b52:	fffff097          	auipc	ra,0xfffff
    80002b56:	fb8080e7          	jalr	-72(ra) # 80001b0a <myproc>
  switch (n) {
    80002b5a:	4795                	li	a5,5
    80002b5c:	0497e163          	bltu	a5,s1,80002b9e <argraw+0x58>
    80002b60:	048a                	sll	s1,s1,0x2
    80002b62:	00006717          	auipc	a4,0x6
    80002b66:	91670713          	add	a4,a4,-1770 # 80008478 <states.0+0x178>
    80002b6a:	94ba                	add	s1,s1,a4
    80002b6c:	409c                	lw	a5,0(s1)
    80002b6e:	97ba                	add	a5,a5,a4
    80002b70:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b72:	753c                	ld	a5,104(a0)
    80002b74:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b76:	60e2                	ld	ra,24(sp)
    80002b78:	6442                	ld	s0,16(sp)
    80002b7a:	64a2                	ld	s1,8(sp)
    80002b7c:	6105                	add	sp,sp,32
    80002b7e:	8082                	ret
    return p->trapframe->a1;
    80002b80:	753c                	ld	a5,104(a0)
    80002b82:	7fa8                	ld	a0,120(a5)
    80002b84:	bfcd                	j	80002b76 <argraw+0x30>
    return p->trapframe->a2;
    80002b86:	753c                	ld	a5,104(a0)
    80002b88:	63c8                	ld	a0,128(a5)
    80002b8a:	b7f5                	j	80002b76 <argraw+0x30>
    return p->trapframe->a3;
    80002b8c:	753c                	ld	a5,104(a0)
    80002b8e:	67c8                	ld	a0,136(a5)
    80002b90:	b7dd                	j	80002b76 <argraw+0x30>
    return p->trapframe->a4;
    80002b92:	753c                	ld	a5,104(a0)
    80002b94:	6bc8                	ld	a0,144(a5)
    80002b96:	b7c5                	j	80002b76 <argraw+0x30>
    return p->trapframe->a5;
    80002b98:	753c                	ld	a5,104(a0)
    80002b9a:	6fc8                	ld	a0,152(a5)
    80002b9c:	bfe9                	j	80002b76 <argraw+0x30>
  panic("argraw");
    80002b9e:	00006517          	auipc	a0,0x6
    80002ba2:	8b250513          	add	a0,a0,-1870 # 80008450 <states.0+0x150>
    80002ba6:	ffffe097          	auipc	ra,0xffffe
    80002baa:	c68080e7          	jalr	-920(ra) # 8000080e <panic>

0000000080002bae <fetchaddr>:
{
    80002bae:	1101                	add	sp,sp,-32
    80002bb0:	ec06                	sd	ra,24(sp)
    80002bb2:	e822                	sd	s0,16(sp)
    80002bb4:	e426                	sd	s1,8(sp)
    80002bb6:	e04a                	sd	s2,0(sp)
    80002bb8:	1000                	add	s0,sp,32
    80002bba:	84aa                	mv	s1,a0
    80002bbc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bbe:	fffff097          	auipc	ra,0xfffff
    80002bc2:	f4c080e7          	jalr	-180(ra) # 80001b0a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80002bc6:	6d3c                	ld	a5,88(a0)
    80002bc8:	02f4f863          	bgeu	s1,a5,80002bf8 <fetchaddr+0x4a>
    80002bcc:	00848713          	add	a4,s1,8
    80002bd0:	02e7e663          	bltu	a5,a4,80002bfc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002bd4:	46a1                	li	a3,8
    80002bd6:	8626                	mv	a2,s1
    80002bd8:	85ca                	mv	a1,s2
    80002bda:	7128                	ld	a0,96(a0)
    80002bdc:	fffff097          	auipc	ra,0xfffff
    80002be0:	c68080e7          	jalr	-920(ra) # 80001844 <copyin>
    80002be4:	00a03533          	snez	a0,a0
    80002be8:	40a00533          	neg	a0,a0
}
    80002bec:	60e2                	ld	ra,24(sp)
    80002bee:	6442                	ld	s0,16(sp)
    80002bf0:	64a2                	ld	s1,8(sp)
    80002bf2:	6902                	ld	s2,0(sp)
    80002bf4:	6105                	add	sp,sp,32
    80002bf6:	8082                	ret
    return -1;
    80002bf8:	557d                	li	a0,-1
    80002bfa:	bfcd                	j	80002bec <fetchaddr+0x3e>
    80002bfc:	557d                	li	a0,-1
    80002bfe:	b7fd                	j	80002bec <fetchaddr+0x3e>

0000000080002c00 <fetchstr>:
{
    80002c00:	7179                	add	sp,sp,-48
    80002c02:	f406                	sd	ra,40(sp)
    80002c04:	f022                	sd	s0,32(sp)
    80002c06:	ec26                	sd	s1,24(sp)
    80002c08:	e84a                	sd	s2,16(sp)
    80002c0a:	e44e                	sd	s3,8(sp)
    80002c0c:	1800                	add	s0,sp,48
    80002c0e:	892a                	mv	s2,a0
    80002c10:	84ae                	mv	s1,a1
    80002c12:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	ef6080e7          	jalr	-266(ra) # 80001b0a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002c1c:	86ce                	mv	a3,s3
    80002c1e:	864a                	mv	a2,s2
    80002c20:	85a6                	mv	a1,s1
    80002c22:	7128                	ld	a0,96(a0)
    80002c24:	fffff097          	auipc	ra,0xfffff
    80002c28:	cae080e7          	jalr	-850(ra) # 800018d2 <copyinstr>
    80002c2c:	00054e63          	bltz	a0,80002c48 <fetchstr+0x48>
  return strlen(buf);
    80002c30:	8526                	mv	a0,s1
    80002c32:	ffffe097          	auipc	ra,0xffffe
    80002c36:	310080e7          	jalr	784(ra) # 80000f42 <strlen>
}
    80002c3a:	70a2                	ld	ra,40(sp)
    80002c3c:	7402                	ld	s0,32(sp)
    80002c3e:	64e2                	ld	s1,24(sp)
    80002c40:	6942                	ld	s2,16(sp)
    80002c42:	69a2                	ld	s3,8(sp)
    80002c44:	6145                	add	sp,sp,48
    80002c46:	8082                	ret
    return -1;
    80002c48:	557d                	li	a0,-1
    80002c4a:	bfc5                	j	80002c3a <fetchstr+0x3a>

0000000080002c4c <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    80002c4c:	1101                	add	sp,sp,-32
    80002c4e:	ec06                	sd	ra,24(sp)
    80002c50:	e822                	sd	s0,16(sp)
    80002c52:	e426                	sd	s1,8(sp)
    80002c54:	1000                	add	s0,sp,32
    80002c56:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c58:	00000097          	auipc	ra,0x0
    80002c5c:	eee080e7          	jalr	-274(ra) # 80002b46 <argraw>
    80002c60:	c088                	sw	a0,0(s1)
}
    80002c62:	60e2                	ld	ra,24(sp)
    80002c64:	6442                	ld	s0,16(sp)
    80002c66:	64a2                	ld	s1,8(sp)
    80002c68:	6105                	add	sp,sp,32
    80002c6a:	8082                	ret

0000000080002c6c <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    80002c6c:	1101                	add	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	1000                	add	s0,sp,32
    80002c76:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	ece080e7          	jalr	-306(ra) # 80002b46 <argraw>
    80002c80:	e088                	sd	a0,0(s1)
}
    80002c82:	60e2                	ld	ra,24(sp)
    80002c84:	6442                	ld	s0,16(sp)
    80002c86:	64a2                	ld	s1,8(sp)
    80002c88:	6105                	add	sp,sp,32
    80002c8a:	8082                	ret

0000000080002c8c <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80002c8c:	7179                	add	sp,sp,-48
    80002c8e:	f406                	sd	ra,40(sp)
    80002c90:	f022                	sd	s0,32(sp)
    80002c92:	ec26                	sd	s1,24(sp)
    80002c94:	e84a                	sd	s2,16(sp)
    80002c96:	1800                	add	s0,sp,48
    80002c98:	84ae                	mv	s1,a1
    80002c9a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c9c:	fd840593          	add	a1,s0,-40
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	fcc080e7          	jalr	-52(ra) # 80002c6c <argaddr>
  return fetchstr(addr, buf, max);
    80002ca8:	864a                	mv	a2,s2
    80002caa:	85a6                	mv	a1,s1
    80002cac:	fd843503          	ld	a0,-40(s0)
    80002cb0:	00000097          	auipc	ra,0x0
    80002cb4:	f50080e7          	jalr	-176(ra) # 80002c00 <fetchstr>
}
    80002cb8:	70a2                	ld	ra,40(sp)
    80002cba:	7402                	ld	s0,32(sp)
    80002cbc:	64e2                	ld	s1,24(sp)
    80002cbe:	6942                	ld	s2,16(sp)
    80002cc0:	6145                	add	sp,sp,48
    80002cc2:	8082                	ret

0000000080002cc4 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002cc4:	1101                	add	sp,sp,-32
    80002cc6:	ec06                	sd	ra,24(sp)
    80002cc8:	e822                	sd	s0,16(sp)
    80002cca:	e426                	sd	s1,8(sp)
    80002ccc:	e04a                	sd	s2,0(sp)
    80002cce:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002cd0:	fffff097          	auipc	ra,0xfffff
    80002cd4:	e3a080e7          	jalr	-454(ra) # 80001b0a <myproc>
    80002cd8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002cda:	06853903          	ld	s2,104(a0)
    80002cde:	0a893783          	ld	a5,168(s2)
    80002ce2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002ce6:	37fd                	addw	a5,a5,-1
    80002ce8:	4751                	li	a4,20
    80002cea:	00f76f63          	bltu	a4,a5,80002d08 <syscall+0x44>
    80002cee:	00369713          	sll	a4,a3,0x3
    80002cf2:	00005797          	auipc	a5,0x5
    80002cf6:	79e78793          	add	a5,a5,1950 # 80008490 <syscalls>
    80002cfa:	97ba                	add	a5,a5,a4
    80002cfc:	639c                	ld	a5,0(a5)
    80002cfe:	c789                	beqz	a5,80002d08 <syscall+0x44>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    80002d00:	9782                	jalr	a5
    80002d02:	06a93823          	sd	a0,112(s2)
    80002d06:	a839                	j	80002d24 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002d08:	16848613          	add	a2,s1,360
    80002d0c:	588c                	lw	a1,48(s1)
    80002d0e:	00005517          	auipc	a0,0x5
    80002d12:	74a50513          	add	a0,a0,1866 # 80008458 <states.0+0x158>
    80002d16:	ffffd097          	auipc	ra,0xffffd
    80002d1a:	7ec080e7          	jalr	2028(ra) # 80000502 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d1e:	74bc                	ld	a5,104(s1)
    80002d20:	577d                	li	a4,-1
    80002d22:	fbb8                	sd	a4,112(a5)
  }
}
    80002d24:	60e2                	ld	ra,24(sp)
    80002d26:	6442                	ld	s0,16(sp)
    80002d28:	64a2                	ld	s1,8(sp)
    80002d2a:	6902                	ld	s2,0(sp)
    80002d2c:	6105                	add	sp,sp,32
    80002d2e:	8082                	ret

0000000080002d30 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d30:	1101                	add	sp,sp,-32
    80002d32:	ec06                	sd	ra,24(sp)
    80002d34:	e822                	sd	s0,16(sp)
    80002d36:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002d38:	fec40593          	add	a1,s0,-20
    80002d3c:	4501                	li	a0,0
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	f0e080e7          	jalr	-242(ra) # 80002c4c <argint>
  exit(n);
    80002d46:	fec42503          	lw	a0,-20(s0)
    80002d4a:	fffff097          	auipc	ra,0xfffff
    80002d4e:	5e4080e7          	jalr	1508(ra) # 8000232e <exit>
  return 0;  /* not reached */
}
    80002d52:	4501                	li	a0,0
    80002d54:	60e2                	ld	ra,24(sp)
    80002d56:	6442                	ld	s0,16(sp)
    80002d58:	6105                	add	sp,sp,32
    80002d5a:	8082                	ret

0000000080002d5c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d5c:	1141                	add	sp,sp,-16
    80002d5e:	e406                	sd	ra,8(sp)
    80002d60:	e022                	sd	s0,0(sp)
    80002d62:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	da6080e7          	jalr	-602(ra) # 80001b0a <myproc>
}
    80002d6c:	5908                	lw	a0,48(a0)
    80002d6e:	60a2                	ld	ra,8(sp)
    80002d70:	6402                	ld	s0,0(sp)
    80002d72:	0141                	add	sp,sp,16
    80002d74:	8082                	ret

0000000080002d76 <sys_fork>:

uint64
sys_fork(void)
{
    80002d76:	1141                	add	sp,sp,-16
    80002d78:	e406                	sd	ra,8(sp)
    80002d7a:	e022                	sd	s0,0(sp)
    80002d7c:	0800                	add	s0,sp,16
  return fork();
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	154080e7          	jalr	340(ra) # 80001ed2 <fork>
}
    80002d86:	60a2                	ld	ra,8(sp)
    80002d88:	6402                	ld	s0,0(sp)
    80002d8a:	0141                	add	sp,sp,16
    80002d8c:	8082                	ret

0000000080002d8e <sys_wait>:

uint64
sys_wait(void)
{
    80002d8e:	1101                	add	sp,sp,-32
    80002d90:	ec06                	sd	ra,24(sp)
    80002d92:	e822                	sd	s0,16(sp)
    80002d94:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d96:	fe840593          	add	a1,s0,-24
    80002d9a:	4501                	li	a0,0
    80002d9c:	00000097          	auipc	ra,0x0
    80002da0:	ed0080e7          	jalr	-304(ra) # 80002c6c <argaddr>
  return wait(p);
    80002da4:	fe843503          	ld	a0,-24(s0)
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	72c080e7          	jalr	1836(ra) # 800024d4 <wait>
}
    80002db0:	60e2                	ld	ra,24(sp)
    80002db2:	6442                	ld	s0,16(sp)
    80002db4:	6105                	add	sp,sp,32
    80002db6:	8082                	ret

0000000080002db8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002db8:	7179                	add	sp,sp,-48
    80002dba:	f406                	sd	ra,40(sp)
    80002dbc:	f022                	sd	s0,32(sp)
    80002dbe:	ec26                	sd	s1,24(sp)
    80002dc0:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002dc2:	fdc40593          	add	a1,s0,-36
    80002dc6:	4501                	li	a0,0
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	e84080e7          	jalr	-380(ra) # 80002c4c <argint>
  addr = myproc()->sz;
    80002dd0:	fffff097          	auipc	ra,0xfffff
    80002dd4:	d3a080e7          	jalr	-710(ra) # 80001b0a <myproc>
    80002dd8:	6d24                	ld	s1,88(a0)
  if(growproc(n) < 0)
    80002dda:	fdc42503          	lw	a0,-36(s0)
    80002dde:	fffff097          	auipc	ra,0xfffff
    80002de2:	098080e7          	jalr	152(ra) # 80001e76 <growproc>
    80002de6:	00054863          	bltz	a0,80002df6 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002dea:	8526                	mv	a0,s1
    80002dec:	70a2                	ld	ra,40(sp)
    80002dee:	7402                	ld	s0,32(sp)
    80002df0:	64e2                	ld	s1,24(sp)
    80002df2:	6145                	add	sp,sp,48
    80002df4:	8082                	ret
    return -1;
    80002df6:	54fd                	li	s1,-1
    80002df8:	bfcd                	j	80002dea <sys_sbrk+0x32>

0000000080002dfa <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dfa:	7139                	add	sp,sp,-64
    80002dfc:	fc06                	sd	ra,56(sp)
    80002dfe:	f822                	sd	s0,48(sp)
    80002e00:	f426                	sd	s1,40(sp)
    80002e02:	f04a                	sd	s2,32(sp)
    80002e04:	ec4e                	sd	s3,24(sp)
    80002e06:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002e08:	fcc40593          	add	a1,s0,-52
    80002e0c:	4501                	li	a0,0
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	e3e080e7          	jalr	-450(ra) # 80002c4c <argint>
  if(n < 0)
    80002e16:	fcc42783          	lw	a5,-52(s0)
    80002e1a:	0607cf63          	bltz	a5,80002e98 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002e1e:	00015517          	auipc	a0,0x15
    80002e22:	8c250513          	add	a0,a0,-1854 # 800176e0 <tickslock>
    80002e26:	ffffe097          	auipc	ra,0xffffe
    80002e2a:	ea6080e7          	jalr	-346(ra) # 80000ccc <acquire>
  ticks0 = ticks;
    80002e2e:	00006917          	auipc	s2,0x6
    80002e32:	ad292903          	lw	s2,-1326(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002e36:	fcc42783          	lw	a5,-52(s0)
    80002e3a:	cf9d                	beqz	a5,80002e78 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e3c:	00015997          	auipc	s3,0x15
    80002e40:	8a498993          	add	s3,s3,-1884 # 800176e0 <tickslock>
    80002e44:	00006497          	auipc	s1,0x6
    80002e48:	abc48493          	add	s1,s1,-1348 # 80008900 <ticks>
    if(killed(myproc())){
    80002e4c:	fffff097          	auipc	ra,0xfffff
    80002e50:	cbe080e7          	jalr	-834(ra) # 80001b0a <myproc>
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	64e080e7          	jalr	1614(ra) # 800024a2 <killed>
    80002e5c:	e129                	bnez	a0,80002e9e <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002e5e:	85ce                	mv	a1,s3
    80002e60:	8526                	mv	a0,s1
    80002e62:	fffff097          	auipc	ra,0xfffff
    80002e66:	398080e7          	jalr	920(ra) # 800021fa <sleep>
  while(ticks - ticks0 < n){
    80002e6a:	409c                	lw	a5,0(s1)
    80002e6c:	412787bb          	subw	a5,a5,s2
    80002e70:	fcc42703          	lw	a4,-52(s0)
    80002e74:	fce7ece3          	bltu	a5,a4,80002e4c <sys_sleep+0x52>
  }
  release(&tickslock);
    80002e78:	00015517          	auipc	a0,0x15
    80002e7c:	86850513          	add	a0,a0,-1944 # 800176e0 <tickslock>
    80002e80:	ffffe097          	auipc	ra,0xffffe
    80002e84:	f00080e7          	jalr	-256(ra) # 80000d80 <release>
  return 0;
    80002e88:	4501                	li	a0,0
}
    80002e8a:	70e2                	ld	ra,56(sp)
    80002e8c:	7442                	ld	s0,48(sp)
    80002e8e:	74a2                	ld	s1,40(sp)
    80002e90:	7902                	ld	s2,32(sp)
    80002e92:	69e2                	ld	s3,24(sp)
    80002e94:	6121                	add	sp,sp,64
    80002e96:	8082                	ret
    n = 0;
    80002e98:	fc042623          	sw	zero,-52(s0)
    80002e9c:	b749                	j	80002e1e <sys_sleep+0x24>
      release(&tickslock);
    80002e9e:	00015517          	auipc	a0,0x15
    80002ea2:	84250513          	add	a0,a0,-1982 # 800176e0 <tickslock>
    80002ea6:	ffffe097          	auipc	ra,0xffffe
    80002eaa:	eda080e7          	jalr	-294(ra) # 80000d80 <release>
      return -1;
    80002eae:	557d                	li	a0,-1
    80002eb0:	bfe9                	j	80002e8a <sys_sleep+0x90>

0000000080002eb2 <sys_kill>:

uint64
sys_kill(void)
{
    80002eb2:	1101                	add	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002eba:	fec40593          	add	a1,s0,-20
    80002ebe:	4501                	li	a0,0
    80002ec0:	00000097          	auipc	ra,0x0
    80002ec4:	d8c080e7          	jalr	-628(ra) # 80002c4c <argint>
  return kill(pid);
    80002ec8:	fec42503          	lw	a0,-20(s0)
    80002ecc:	fffff097          	auipc	ra,0xfffff
    80002ed0:	538080e7          	jalr	1336(ra) # 80002404 <kill>
}
    80002ed4:	60e2                	ld	ra,24(sp)
    80002ed6:	6442                	ld	s0,16(sp)
    80002ed8:	6105                	add	sp,sp,32
    80002eda:	8082                	ret

0000000080002edc <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    80002edc:	1101                	add	sp,sp,-32
    80002ede:	ec06                	sd	ra,24(sp)
    80002ee0:	e822                	sd	s0,16(sp)
    80002ee2:	e426                	sd	s1,8(sp)
    80002ee4:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ee6:	00014517          	auipc	a0,0x14
    80002eea:	7fa50513          	add	a0,a0,2042 # 800176e0 <tickslock>
    80002eee:	ffffe097          	auipc	ra,0xffffe
    80002ef2:	dde080e7          	jalr	-546(ra) # 80000ccc <acquire>
  xticks = ticks;
    80002ef6:	00006497          	auipc	s1,0x6
    80002efa:	a0a4a483          	lw	s1,-1526(s1) # 80008900 <ticks>
  release(&tickslock);
    80002efe:	00014517          	auipc	a0,0x14
    80002f02:	7e250513          	add	a0,a0,2018 # 800176e0 <tickslock>
    80002f06:	ffffe097          	auipc	ra,0xffffe
    80002f0a:	e7a080e7          	jalr	-390(ra) # 80000d80 <release>
  return xticks;
}
    80002f0e:	02049513          	sll	a0,s1,0x20
    80002f12:	9101                	srl	a0,a0,0x20
    80002f14:	60e2                	ld	ra,24(sp)
    80002f16:	6442                	ld	s0,16(sp)
    80002f18:	64a2                	ld	s1,8(sp)
    80002f1a:	6105                	add	sp,sp,32
    80002f1c:	8082                	ret

0000000080002f1e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f1e:	7179                	add	sp,sp,-48
    80002f20:	f406                	sd	ra,40(sp)
    80002f22:	f022                	sd	s0,32(sp)
    80002f24:	ec26                	sd	s1,24(sp)
    80002f26:	e84a                	sd	s2,16(sp)
    80002f28:	e44e                	sd	s3,8(sp)
    80002f2a:	e052                	sd	s4,0(sp)
    80002f2c:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f2e:	00005597          	auipc	a1,0x5
    80002f32:	61258593          	add	a1,a1,1554 # 80008540 <syscalls+0xb0>
    80002f36:	00014517          	auipc	a0,0x14
    80002f3a:	7c250513          	add	a0,a0,1986 # 800176f8 <bcache>
    80002f3e:	ffffe097          	auipc	ra,0xffffe
    80002f42:	cfe080e7          	jalr	-770(ra) # 80000c3c <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    80002f46:	0001c797          	auipc	a5,0x1c
    80002f4a:	7b278793          	add	a5,a5,1970 # 8001f6f8 <bcache+0x8000>
    80002f4e:	0001d717          	auipc	a4,0x1d
    80002f52:	a1270713          	add	a4,a4,-1518 # 8001f960 <bcache+0x8268>
    80002f56:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f5a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f5e:	00014497          	auipc	s1,0x14
    80002f62:	7b248493          	add	s1,s1,1970 # 80017710 <bcache+0x18>
    b->next = bcache.head.next;
    80002f66:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f68:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f6a:	00005a17          	auipc	s4,0x5
    80002f6e:	5dea0a13          	add	s4,s4,1502 # 80008548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002f72:	2b893783          	ld	a5,696(s2)
    80002f76:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f78:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f7c:	85d2                	mv	a1,s4
    80002f7e:	01048513          	add	a0,s1,16
    80002f82:	00001097          	auipc	ra,0x1
    80002f86:	496080e7          	jalr	1174(ra) # 80004418 <initsleeplock>
    bcache.head.next->prev = b;
    80002f8a:	2b893783          	ld	a5,696(s2)
    80002f8e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f90:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f94:	45848493          	add	s1,s1,1112
    80002f98:	fd349de3          	bne	s1,s3,80002f72 <binit+0x54>
  }
}
    80002f9c:	70a2                	ld	ra,40(sp)
    80002f9e:	7402                	ld	s0,32(sp)
    80002fa0:	64e2                	ld	s1,24(sp)
    80002fa2:	6942                	ld	s2,16(sp)
    80002fa4:	69a2                	ld	s3,8(sp)
    80002fa6:	6a02                	ld	s4,0(sp)
    80002fa8:	6145                	add	sp,sp,48
    80002faa:	8082                	ret

0000000080002fac <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    80002fac:	7179                	add	sp,sp,-48
    80002fae:	f406                	sd	ra,40(sp)
    80002fb0:	f022                	sd	s0,32(sp)
    80002fb2:	ec26                	sd	s1,24(sp)
    80002fb4:	e84a                	sd	s2,16(sp)
    80002fb6:	e44e                	sd	s3,8(sp)
    80002fb8:	1800                	add	s0,sp,48
    80002fba:	892a                	mv	s2,a0
    80002fbc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002fbe:	00014517          	auipc	a0,0x14
    80002fc2:	73a50513          	add	a0,a0,1850 # 800176f8 <bcache>
    80002fc6:	ffffe097          	auipc	ra,0xffffe
    80002fca:	d06080e7          	jalr	-762(ra) # 80000ccc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002fce:	0001d497          	auipc	s1,0x1d
    80002fd2:	9e24b483          	ld	s1,-1566(s1) # 8001f9b0 <bcache+0x82b8>
    80002fd6:	0001d797          	auipc	a5,0x1d
    80002fda:	98a78793          	add	a5,a5,-1654 # 8001f960 <bcache+0x8268>
    80002fde:	02f48f63          	beq	s1,a5,8000301c <bread+0x70>
    80002fe2:	873e                	mv	a4,a5
    80002fe4:	a021                	j	80002fec <bread+0x40>
    80002fe6:	68a4                	ld	s1,80(s1)
    80002fe8:	02e48a63          	beq	s1,a4,8000301c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002fec:	449c                	lw	a5,8(s1)
    80002fee:	ff279ce3          	bne	a5,s2,80002fe6 <bread+0x3a>
    80002ff2:	44dc                	lw	a5,12(s1)
    80002ff4:	ff3799e3          	bne	a5,s3,80002fe6 <bread+0x3a>
      b->refcnt++;
    80002ff8:	40bc                	lw	a5,64(s1)
    80002ffa:	2785                	addw	a5,a5,1
    80002ffc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ffe:	00014517          	auipc	a0,0x14
    80003002:	6fa50513          	add	a0,a0,1786 # 800176f8 <bcache>
    80003006:	ffffe097          	auipc	ra,0xffffe
    8000300a:	d7a080e7          	jalr	-646(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    8000300e:	01048513          	add	a0,s1,16
    80003012:	00001097          	auipc	ra,0x1
    80003016:	440080e7          	jalr	1088(ra) # 80004452 <acquiresleep>
      return b;
    8000301a:	a8b9                	j	80003078 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000301c:	0001d497          	auipc	s1,0x1d
    80003020:	98c4b483          	ld	s1,-1652(s1) # 8001f9a8 <bcache+0x82b0>
    80003024:	0001d797          	auipc	a5,0x1d
    80003028:	93c78793          	add	a5,a5,-1732 # 8001f960 <bcache+0x8268>
    8000302c:	00f48863          	beq	s1,a5,8000303c <bread+0x90>
    80003030:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003032:	40bc                	lw	a5,64(s1)
    80003034:	cf81                	beqz	a5,8000304c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003036:	64a4                	ld	s1,72(s1)
    80003038:	fee49de3          	bne	s1,a4,80003032 <bread+0x86>
  panic("bget: no buffers");
    8000303c:	00005517          	auipc	a0,0x5
    80003040:	51450513          	add	a0,a0,1300 # 80008550 <syscalls+0xc0>
    80003044:	ffffd097          	auipc	ra,0xffffd
    80003048:	7ca080e7          	jalr	1994(ra) # 8000080e <panic>
      b->dev = dev;
    8000304c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003050:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003054:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003058:	4785                	li	a5,1
    8000305a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000305c:	00014517          	auipc	a0,0x14
    80003060:	69c50513          	add	a0,a0,1692 # 800176f8 <bcache>
    80003064:	ffffe097          	auipc	ra,0xffffe
    80003068:	d1c080e7          	jalr	-740(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    8000306c:	01048513          	add	a0,s1,16
    80003070:	00001097          	auipc	ra,0x1
    80003074:	3e2080e7          	jalr	994(ra) # 80004452 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003078:	409c                	lw	a5,0(s1)
    8000307a:	cb89                	beqz	a5,8000308c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000307c:	8526                	mv	a0,s1
    8000307e:	70a2                	ld	ra,40(sp)
    80003080:	7402                	ld	s0,32(sp)
    80003082:	64e2                	ld	s1,24(sp)
    80003084:	6942                	ld	s2,16(sp)
    80003086:	69a2                	ld	s3,8(sp)
    80003088:	6145                	add	sp,sp,48
    8000308a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000308c:	4581                	li	a1,0
    8000308e:	8526                	mv	a0,s1
    80003090:	00003097          	auipc	ra,0x3
    80003094:	f26080e7          	jalr	-218(ra) # 80005fb6 <virtio_disk_rw>
    b->valid = 1;
    80003098:	4785                	li	a5,1
    8000309a:	c09c                	sw	a5,0(s1)
  return b;
    8000309c:	b7c5                	j	8000307c <bread+0xd0>

000000008000309e <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    8000309e:	1101                	add	sp,sp,-32
    800030a0:	ec06                	sd	ra,24(sp)
    800030a2:	e822                	sd	s0,16(sp)
    800030a4:	e426                	sd	s1,8(sp)
    800030a6:	1000                	add	s0,sp,32
    800030a8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030aa:	0541                	add	a0,a0,16
    800030ac:	00001097          	auipc	ra,0x1
    800030b0:	440080e7          	jalr	1088(ra) # 800044ec <holdingsleep>
    800030b4:	cd01                	beqz	a0,800030cc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800030b6:	4585                	li	a1,1
    800030b8:	8526                	mv	a0,s1
    800030ba:	00003097          	auipc	ra,0x3
    800030be:	efc080e7          	jalr	-260(ra) # 80005fb6 <virtio_disk_rw>
}
    800030c2:	60e2                	ld	ra,24(sp)
    800030c4:	6442                	ld	s0,16(sp)
    800030c6:	64a2                	ld	s1,8(sp)
    800030c8:	6105                	add	sp,sp,32
    800030ca:	8082                	ret
    panic("bwrite");
    800030cc:	00005517          	auipc	a0,0x5
    800030d0:	49c50513          	add	a0,a0,1180 # 80008568 <syscalls+0xd8>
    800030d4:	ffffd097          	auipc	ra,0xffffd
    800030d8:	73a080e7          	jalr	1850(ra) # 8000080e <panic>

00000000800030dc <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    800030dc:	1101                	add	sp,sp,-32
    800030de:	ec06                	sd	ra,24(sp)
    800030e0:	e822                	sd	s0,16(sp)
    800030e2:	e426                	sd	s1,8(sp)
    800030e4:	e04a                	sd	s2,0(sp)
    800030e6:	1000                	add	s0,sp,32
    800030e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030ea:	01050913          	add	s2,a0,16
    800030ee:	854a                	mv	a0,s2
    800030f0:	00001097          	auipc	ra,0x1
    800030f4:	3fc080e7          	jalr	1020(ra) # 800044ec <holdingsleep>
    800030f8:	c925                	beqz	a0,80003168 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800030fa:	854a                	mv	a0,s2
    800030fc:	00001097          	auipc	ra,0x1
    80003100:	3ac080e7          	jalr	940(ra) # 800044a8 <releasesleep>

  acquire(&bcache.lock);
    80003104:	00014517          	auipc	a0,0x14
    80003108:	5f450513          	add	a0,a0,1524 # 800176f8 <bcache>
    8000310c:	ffffe097          	auipc	ra,0xffffe
    80003110:	bc0080e7          	jalr	-1088(ra) # 80000ccc <acquire>
  b->refcnt--;
    80003114:	40bc                	lw	a5,64(s1)
    80003116:	37fd                	addw	a5,a5,-1
    80003118:	0007871b          	sext.w	a4,a5
    8000311c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000311e:	e71d                	bnez	a4,8000314c <brelse+0x70>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    80003120:	68b8                	ld	a4,80(s1)
    80003122:	64bc                	ld	a5,72(s1)
    80003124:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003126:	68b8                	ld	a4,80(s1)
    80003128:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000312a:	0001c797          	auipc	a5,0x1c
    8000312e:	5ce78793          	add	a5,a5,1486 # 8001f6f8 <bcache+0x8000>
    80003132:	2b87b703          	ld	a4,696(a5)
    80003136:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003138:	0001d717          	auipc	a4,0x1d
    8000313c:	82870713          	add	a4,a4,-2008 # 8001f960 <bcache+0x8268>
    80003140:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003142:	2b87b703          	ld	a4,696(a5)
    80003146:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003148:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000314c:	00014517          	auipc	a0,0x14
    80003150:	5ac50513          	add	a0,a0,1452 # 800176f8 <bcache>
    80003154:	ffffe097          	auipc	ra,0xffffe
    80003158:	c2c080e7          	jalr	-980(ra) # 80000d80 <release>
}
    8000315c:	60e2                	ld	ra,24(sp)
    8000315e:	6442                	ld	s0,16(sp)
    80003160:	64a2                	ld	s1,8(sp)
    80003162:	6902                	ld	s2,0(sp)
    80003164:	6105                	add	sp,sp,32
    80003166:	8082                	ret
    panic("brelse");
    80003168:	00005517          	auipc	a0,0x5
    8000316c:	40850513          	add	a0,a0,1032 # 80008570 <syscalls+0xe0>
    80003170:	ffffd097          	auipc	ra,0xffffd
    80003174:	69e080e7          	jalr	1694(ra) # 8000080e <panic>

0000000080003178 <bpin>:

void
bpin(struct buf *b) {
    80003178:	1101                	add	sp,sp,-32
    8000317a:	ec06                	sd	ra,24(sp)
    8000317c:	e822                	sd	s0,16(sp)
    8000317e:	e426                	sd	s1,8(sp)
    80003180:	1000                	add	s0,sp,32
    80003182:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003184:	00014517          	auipc	a0,0x14
    80003188:	57450513          	add	a0,a0,1396 # 800176f8 <bcache>
    8000318c:	ffffe097          	auipc	ra,0xffffe
    80003190:	b40080e7          	jalr	-1216(ra) # 80000ccc <acquire>
  b->refcnt++;
    80003194:	40bc                	lw	a5,64(s1)
    80003196:	2785                	addw	a5,a5,1
    80003198:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000319a:	00014517          	auipc	a0,0x14
    8000319e:	55e50513          	add	a0,a0,1374 # 800176f8 <bcache>
    800031a2:	ffffe097          	auipc	ra,0xffffe
    800031a6:	bde080e7          	jalr	-1058(ra) # 80000d80 <release>
}
    800031aa:	60e2                	ld	ra,24(sp)
    800031ac:	6442                	ld	s0,16(sp)
    800031ae:	64a2                	ld	s1,8(sp)
    800031b0:	6105                	add	sp,sp,32
    800031b2:	8082                	ret

00000000800031b4 <bunpin>:

void
bunpin(struct buf *b) {
    800031b4:	1101                	add	sp,sp,-32
    800031b6:	ec06                	sd	ra,24(sp)
    800031b8:	e822                	sd	s0,16(sp)
    800031ba:	e426                	sd	s1,8(sp)
    800031bc:	1000                	add	s0,sp,32
    800031be:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031c0:	00014517          	auipc	a0,0x14
    800031c4:	53850513          	add	a0,a0,1336 # 800176f8 <bcache>
    800031c8:	ffffe097          	auipc	ra,0xffffe
    800031cc:	b04080e7          	jalr	-1276(ra) # 80000ccc <acquire>
  b->refcnt--;
    800031d0:	40bc                	lw	a5,64(s1)
    800031d2:	37fd                	addw	a5,a5,-1
    800031d4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031d6:	00014517          	auipc	a0,0x14
    800031da:	52250513          	add	a0,a0,1314 # 800176f8 <bcache>
    800031de:	ffffe097          	auipc	ra,0xffffe
    800031e2:	ba2080e7          	jalr	-1118(ra) # 80000d80 <release>
}
    800031e6:	60e2                	ld	ra,24(sp)
    800031e8:	6442                	ld	s0,16(sp)
    800031ea:	64a2                	ld	s1,8(sp)
    800031ec:	6105                	add	sp,sp,32
    800031ee:	8082                	ret

00000000800031f0 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    800031f0:	1101                	add	sp,sp,-32
    800031f2:	ec06                	sd	ra,24(sp)
    800031f4:	e822                	sd	s0,16(sp)
    800031f6:	e426                	sd	s1,8(sp)
    800031f8:	e04a                	sd	s2,0(sp)
    800031fa:	1000                	add	s0,sp,32
    800031fc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031fe:	00d5d59b          	srlw	a1,a1,0xd
    80003202:	0001d797          	auipc	a5,0x1d
    80003206:	bd27a783          	lw	a5,-1070(a5) # 8001fdd4 <sb+0x1c>
    8000320a:	9dbd                	addw	a1,a1,a5
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	da0080e7          	jalr	-608(ra) # 80002fac <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003214:	0074f713          	and	a4,s1,7
    80003218:	4785                	li	a5,1
    8000321a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000321e:	14ce                	sll	s1,s1,0x33
    80003220:	90d9                	srl	s1,s1,0x36
    80003222:	00950733          	add	a4,a0,s1
    80003226:	05874703          	lbu	a4,88(a4)
    8000322a:	00e7f6b3          	and	a3,a5,a4
    8000322e:	c69d                	beqz	a3,8000325c <bfree+0x6c>
    80003230:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003232:	94aa                	add	s1,s1,a0
    80003234:	fff7c793          	not	a5,a5
    80003238:	8f7d                	and	a4,a4,a5
    8000323a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000323e:	00001097          	auipc	ra,0x1
    80003242:	0f6080e7          	jalr	246(ra) # 80004334 <log_write>
  brelse(bp);
    80003246:	854a                	mv	a0,s2
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	e94080e7          	jalr	-364(ra) # 800030dc <brelse>
}
    80003250:	60e2                	ld	ra,24(sp)
    80003252:	6442                	ld	s0,16(sp)
    80003254:	64a2                	ld	s1,8(sp)
    80003256:	6902                	ld	s2,0(sp)
    80003258:	6105                	add	sp,sp,32
    8000325a:	8082                	ret
    panic("freeing free block");
    8000325c:	00005517          	auipc	a0,0x5
    80003260:	31c50513          	add	a0,a0,796 # 80008578 <syscalls+0xe8>
    80003264:	ffffd097          	auipc	ra,0xffffd
    80003268:	5aa080e7          	jalr	1450(ra) # 8000080e <panic>

000000008000326c <balloc>:
{
    8000326c:	711d                	add	sp,sp,-96
    8000326e:	ec86                	sd	ra,88(sp)
    80003270:	e8a2                	sd	s0,80(sp)
    80003272:	e4a6                	sd	s1,72(sp)
    80003274:	e0ca                	sd	s2,64(sp)
    80003276:	fc4e                	sd	s3,56(sp)
    80003278:	f852                	sd	s4,48(sp)
    8000327a:	f456                	sd	s5,40(sp)
    8000327c:	f05a                	sd	s6,32(sp)
    8000327e:	ec5e                	sd	s7,24(sp)
    80003280:	e862                	sd	s8,16(sp)
    80003282:	e466                	sd	s9,8(sp)
    80003284:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003286:	0001d797          	auipc	a5,0x1d
    8000328a:	b367a783          	lw	a5,-1226(a5) # 8001fdbc <sb+0x4>
    8000328e:	cff5                	beqz	a5,8000338a <balloc+0x11e>
    80003290:	8baa                	mv	s7,a0
    80003292:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003294:	0001db17          	auipc	s6,0x1d
    80003298:	b24b0b13          	add	s6,s6,-1244 # 8001fdb8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000329c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000329e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032a0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800032a2:	6c89                	lui	s9,0x2
    800032a4:	a061                	j	8000332c <balloc+0xc0>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    800032a6:	97ca                	add	a5,a5,s2
    800032a8:	8e55                	or	a2,a2,a3
    800032aa:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800032ae:	854a                	mv	a0,s2
    800032b0:	00001097          	auipc	ra,0x1
    800032b4:	084080e7          	jalr	132(ra) # 80004334 <log_write>
        brelse(bp);
    800032b8:	854a                	mv	a0,s2
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	e22080e7          	jalr	-478(ra) # 800030dc <brelse>
  bp = bread(dev, bno);
    800032c2:	85a6                	mv	a1,s1
    800032c4:	855e                	mv	a0,s7
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	ce6080e7          	jalr	-794(ra) # 80002fac <bread>
    800032ce:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032d0:	40000613          	li	a2,1024
    800032d4:	4581                	li	a1,0
    800032d6:	05850513          	add	a0,a0,88
    800032da:	ffffe097          	auipc	ra,0xffffe
    800032de:	aee080e7          	jalr	-1298(ra) # 80000dc8 <memset>
  log_write(bp);
    800032e2:	854a                	mv	a0,s2
    800032e4:	00001097          	auipc	ra,0x1
    800032e8:	050080e7          	jalr	80(ra) # 80004334 <log_write>
  brelse(bp);
    800032ec:	854a                	mv	a0,s2
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	dee080e7          	jalr	-530(ra) # 800030dc <brelse>
}
    800032f6:	8526                	mv	a0,s1
    800032f8:	60e6                	ld	ra,88(sp)
    800032fa:	6446                	ld	s0,80(sp)
    800032fc:	64a6                	ld	s1,72(sp)
    800032fe:	6906                	ld	s2,64(sp)
    80003300:	79e2                	ld	s3,56(sp)
    80003302:	7a42                	ld	s4,48(sp)
    80003304:	7aa2                	ld	s5,40(sp)
    80003306:	7b02                	ld	s6,32(sp)
    80003308:	6be2                	ld	s7,24(sp)
    8000330a:	6c42                	ld	s8,16(sp)
    8000330c:	6ca2                	ld	s9,8(sp)
    8000330e:	6125                	add	sp,sp,96
    80003310:	8082                	ret
    brelse(bp);
    80003312:	854a                	mv	a0,s2
    80003314:	00000097          	auipc	ra,0x0
    80003318:	dc8080e7          	jalr	-568(ra) # 800030dc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000331c:	015c87bb          	addw	a5,s9,s5
    80003320:	00078a9b          	sext.w	s5,a5
    80003324:	004b2703          	lw	a4,4(s6)
    80003328:	06eaf163          	bgeu	s5,a4,8000338a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000332c:	41fad79b          	sraw	a5,s5,0x1f
    80003330:	0137d79b          	srlw	a5,a5,0x13
    80003334:	015787bb          	addw	a5,a5,s5
    80003338:	40d7d79b          	sraw	a5,a5,0xd
    8000333c:	01cb2583          	lw	a1,28(s6)
    80003340:	9dbd                	addw	a1,a1,a5
    80003342:	855e                	mv	a0,s7
    80003344:	00000097          	auipc	ra,0x0
    80003348:	c68080e7          	jalr	-920(ra) # 80002fac <bread>
    8000334c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000334e:	004b2503          	lw	a0,4(s6)
    80003352:	000a849b          	sext.w	s1,s5
    80003356:	8762                	mv	a4,s8
    80003358:	faa4fde3          	bgeu	s1,a0,80003312 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000335c:	00777693          	and	a3,a4,7
    80003360:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    80003364:	41f7579b          	sraw	a5,a4,0x1f
    80003368:	01d7d79b          	srlw	a5,a5,0x1d
    8000336c:	9fb9                	addw	a5,a5,a4
    8000336e:	4037d79b          	sraw	a5,a5,0x3
    80003372:	00f90633          	add	a2,s2,a5
    80003376:	05864603          	lbu	a2,88(a2)
    8000337a:	00c6f5b3          	and	a1,a3,a2
    8000337e:	d585                	beqz	a1,800032a6 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003380:	2705                	addw	a4,a4,1
    80003382:	2485                	addw	s1,s1,1
    80003384:	fd471ae3          	bne	a4,s4,80003358 <balloc+0xec>
    80003388:	b769                	j	80003312 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000338a:	00005517          	auipc	a0,0x5
    8000338e:	20650513          	add	a0,a0,518 # 80008590 <syscalls+0x100>
    80003392:	ffffd097          	auipc	ra,0xffffd
    80003396:	170080e7          	jalr	368(ra) # 80000502 <printf>
  return 0;
    8000339a:	4481                	li	s1,0
    8000339c:	bfa9                	j	800032f6 <balloc+0x8a>

000000008000339e <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    8000339e:	7179                	add	sp,sp,-48
    800033a0:	f406                	sd	ra,40(sp)
    800033a2:	f022                	sd	s0,32(sp)
    800033a4:	ec26                	sd	s1,24(sp)
    800033a6:	e84a                	sd	s2,16(sp)
    800033a8:	e44e                	sd	s3,8(sp)
    800033aa:	e052                	sd	s4,0(sp)
    800033ac:	1800                	add	s0,sp,48
    800033ae:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800033b0:	47ad                	li	a5,11
    800033b2:	02b7e863          	bltu	a5,a1,800033e2 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800033b6:	02059793          	sll	a5,a1,0x20
    800033ba:	01e7d593          	srl	a1,a5,0x1e
    800033be:	00b504b3          	add	s1,a0,a1
    800033c2:	0504a903          	lw	s2,80(s1)
    800033c6:	06091e63          	bnez	s2,80003442 <bmap+0xa4>
      addr = balloc(ip->dev);
    800033ca:	4108                	lw	a0,0(a0)
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	ea0080e7          	jalr	-352(ra) # 8000326c <balloc>
    800033d4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033d8:	06090563          	beqz	s2,80003442 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800033dc:	0524a823          	sw	s2,80(s1)
    800033e0:	a08d                	j	80003442 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800033e2:	ff45849b          	addw	s1,a1,-12
    800033e6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033ea:	0ff00793          	li	a5,255
    800033ee:	08e7e563          	bltu	a5,a4,80003478 <bmap+0xda>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033f2:	08052903          	lw	s2,128(a0)
    800033f6:	00091d63          	bnez	s2,80003410 <bmap+0x72>
      addr = balloc(ip->dev);
    800033fa:	4108                	lw	a0,0(a0)
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	e70080e7          	jalr	-400(ra) # 8000326c <balloc>
    80003404:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003408:	02090d63          	beqz	s2,80003442 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000340c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003410:	85ca                	mv	a1,s2
    80003412:	0009a503          	lw	a0,0(s3)
    80003416:	00000097          	auipc	ra,0x0
    8000341a:	b96080e7          	jalr	-1130(ra) # 80002fac <bread>
    8000341e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003420:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80003424:	02049713          	sll	a4,s1,0x20
    80003428:	01e75593          	srl	a1,a4,0x1e
    8000342c:	00b784b3          	add	s1,a5,a1
    80003430:	0004a903          	lw	s2,0(s1)
    80003434:	02090063          	beqz	s2,80003454 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003438:	8552                	mv	a0,s4
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	ca2080e7          	jalr	-862(ra) # 800030dc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003442:	854a                	mv	a0,s2
    80003444:	70a2                	ld	ra,40(sp)
    80003446:	7402                	ld	s0,32(sp)
    80003448:	64e2                	ld	s1,24(sp)
    8000344a:	6942                	ld	s2,16(sp)
    8000344c:	69a2                	ld	s3,8(sp)
    8000344e:	6a02                	ld	s4,0(sp)
    80003450:	6145                	add	sp,sp,48
    80003452:	8082                	ret
      addr = balloc(ip->dev);
    80003454:	0009a503          	lw	a0,0(s3)
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	e14080e7          	jalr	-492(ra) # 8000326c <balloc>
    80003460:	0005091b          	sext.w	s2,a0
      if(addr){
    80003464:	fc090ae3          	beqz	s2,80003438 <bmap+0x9a>
        a[bn] = addr;
    80003468:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000346c:	8552                	mv	a0,s4
    8000346e:	00001097          	auipc	ra,0x1
    80003472:	ec6080e7          	jalr	-314(ra) # 80004334 <log_write>
    80003476:	b7c9                	j	80003438 <bmap+0x9a>
  panic("bmap: out of range");
    80003478:	00005517          	auipc	a0,0x5
    8000347c:	13050513          	add	a0,a0,304 # 800085a8 <syscalls+0x118>
    80003480:	ffffd097          	auipc	ra,0xffffd
    80003484:	38e080e7          	jalr	910(ra) # 8000080e <panic>

0000000080003488 <iget>:
{
    80003488:	7179                	add	sp,sp,-48
    8000348a:	f406                	sd	ra,40(sp)
    8000348c:	f022                	sd	s0,32(sp)
    8000348e:	ec26                	sd	s1,24(sp)
    80003490:	e84a                	sd	s2,16(sp)
    80003492:	e44e                	sd	s3,8(sp)
    80003494:	e052                	sd	s4,0(sp)
    80003496:	1800                	add	s0,sp,48
    80003498:	89aa                	mv	s3,a0
    8000349a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000349c:	0001d517          	auipc	a0,0x1d
    800034a0:	93c50513          	add	a0,a0,-1732 # 8001fdd8 <itable>
    800034a4:	ffffe097          	auipc	ra,0xffffe
    800034a8:	828080e7          	jalr	-2008(ra) # 80000ccc <acquire>
  empty = 0;
    800034ac:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034ae:	0001d497          	auipc	s1,0x1d
    800034b2:	94248493          	add	s1,s1,-1726 # 8001fdf0 <itable+0x18>
    800034b6:	0001e697          	auipc	a3,0x1e
    800034ba:	3ca68693          	add	a3,a3,970 # 80021880 <log>
    800034be:	a039                	j	800034cc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    800034c0:	02090b63          	beqz	s2,800034f6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034c4:	08848493          	add	s1,s1,136
    800034c8:	02d48a63          	beq	s1,a3,800034fc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034cc:	449c                	lw	a5,8(s1)
    800034ce:	fef059e3          	blez	a5,800034c0 <iget+0x38>
    800034d2:	4098                	lw	a4,0(s1)
    800034d4:	ff3716e3          	bne	a4,s3,800034c0 <iget+0x38>
    800034d8:	40d8                	lw	a4,4(s1)
    800034da:	ff4713e3          	bne	a4,s4,800034c0 <iget+0x38>
      ip->ref++;
    800034de:	2785                	addw	a5,a5,1
    800034e0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034e2:	0001d517          	auipc	a0,0x1d
    800034e6:	8f650513          	add	a0,a0,-1802 # 8001fdd8 <itable>
    800034ea:	ffffe097          	auipc	ra,0xffffe
    800034ee:	896080e7          	jalr	-1898(ra) # 80000d80 <release>
      return ip;
    800034f2:	8926                	mv	s2,s1
    800034f4:	a03d                	j	80003522 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    800034f6:	f7f9                	bnez	a5,800034c4 <iget+0x3c>
    800034f8:	8926                	mv	s2,s1
    800034fa:	b7e9                	j	800034c4 <iget+0x3c>
  if(empty == 0)
    800034fc:	02090c63          	beqz	s2,80003534 <iget+0xac>
  ip->dev = dev;
    80003500:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003504:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003508:	4785                	li	a5,1
    8000350a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000350e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003512:	0001d517          	auipc	a0,0x1d
    80003516:	8c650513          	add	a0,a0,-1850 # 8001fdd8 <itable>
    8000351a:	ffffe097          	auipc	ra,0xffffe
    8000351e:	866080e7          	jalr	-1946(ra) # 80000d80 <release>
}
    80003522:	854a                	mv	a0,s2
    80003524:	70a2                	ld	ra,40(sp)
    80003526:	7402                	ld	s0,32(sp)
    80003528:	64e2                	ld	s1,24(sp)
    8000352a:	6942                	ld	s2,16(sp)
    8000352c:	69a2                	ld	s3,8(sp)
    8000352e:	6a02                	ld	s4,0(sp)
    80003530:	6145                	add	sp,sp,48
    80003532:	8082                	ret
    panic("iget: no inodes");
    80003534:	00005517          	auipc	a0,0x5
    80003538:	08c50513          	add	a0,a0,140 # 800085c0 <syscalls+0x130>
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	2d2080e7          	jalr	722(ra) # 8000080e <panic>

0000000080003544 <fsinit>:
fsinit(int dev) {
    80003544:	7179                	add	sp,sp,-48
    80003546:	f406                	sd	ra,40(sp)
    80003548:	f022                	sd	s0,32(sp)
    8000354a:	ec26                	sd	s1,24(sp)
    8000354c:	e84a                	sd	s2,16(sp)
    8000354e:	e44e                	sd	s3,8(sp)
    80003550:	1800                	add	s0,sp,48
    80003552:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003554:	4585                	li	a1,1
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	a56080e7          	jalr	-1450(ra) # 80002fac <bread>
    8000355e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003560:	0001d997          	auipc	s3,0x1d
    80003564:	85898993          	add	s3,s3,-1960 # 8001fdb8 <sb>
    80003568:	02000613          	li	a2,32
    8000356c:	05850593          	add	a1,a0,88
    80003570:	854e                	mv	a0,s3
    80003572:	ffffe097          	auipc	ra,0xffffe
    80003576:	8b2080e7          	jalr	-1870(ra) # 80000e24 <memmove>
  brelse(bp);
    8000357a:	8526                	mv	a0,s1
    8000357c:	00000097          	auipc	ra,0x0
    80003580:	b60080e7          	jalr	-1184(ra) # 800030dc <brelse>
  if(sb.magic != FSMAGIC)
    80003584:	0009a703          	lw	a4,0(s3)
    80003588:	102037b7          	lui	a5,0x10203
    8000358c:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003590:	02f71263          	bne	a4,a5,800035b4 <fsinit+0x70>
  initlog(dev, &sb);
    80003594:	0001d597          	auipc	a1,0x1d
    80003598:	82458593          	add	a1,a1,-2012 # 8001fdb8 <sb>
    8000359c:	854a                	mv	a0,s2
    8000359e:	00001097          	auipc	ra,0x1
    800035a2:	b2c080e7          	jalr	-1236(ra) # 800040ca <initlog>
}
    800035a6:	70a2                	ld	ra,40(sp)
    800035a8:	7402                	ld	s0,32(sp)
    800035aa:	64e2                	ld	s1,24(sp)
    800035ac:	6942                	ld	s2,16(sp)
    800035ae:	69a2                	ld	s3,8(sp)
    800035b0:	6145                	add	sp,sp,48
    800035b2:	8082                	ret
    panic("invalid file system");
    800035b4:	00005517          	auipc	a0,0x5
    800035b8:	01c50513          	add	a0,a0,28 # 800085d0 <syscalls+0x140>
    800035bc:	ffffd097          	auipc	ra,0xffffd
    800035c0:	252080e7          	jalr	594(ra) # 8000080e <panic>

00000000800035c4 <iinit>:
{
    800035c4:	7179                	add	sp,sp,-48
    800035c6:	f406                	sd	ra,40(sp)
    800035c8:	f022                	sd	s0,32(sp)
    800035ca:	ec26                	sd	s1,24(sp)
    800035cc:	e84a                	sd	s2,16(sp)
    800035ce:	e44e                	sd	s3,8(sp)
    800035d0:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    800035d2:	00005597          	auipc	a1,0x5
    800035d6:	01658593          	add	a1,a1,22 # 800085e8 <syscalls+0x158>
    800035da:	0001c517          	auipc	a0,0x1c
    800035de:	7fe50513          	add	a0,a0,2046 # 8001fdd8 <itable>
    800035e2:	ffffd097          	auipc	ra,0xffffd
    800035e6:	65a080e7          	jalr	1626(ra) # 80000c3c <initlock>
  for(i = 0; i < NINODE; i++) {
    800035ea:	0001d497          	auipc	s1,0x1d
    800035ee:	81648493          	add	s1,s1,-2026 # 8001fe00 <itable+0x28>
    800035f2:	0001e997          	auipc	s3,0x1e
    800035f6:	29e98993          	add	s3,s3,670 # 80021890 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035fa:	00005917          	auipc	s2,0x5
    800035fe:	ff690913          	add	s2,s2,-10 # 800085f0 <syscalls+0x160>
    80003602:	85ca                	mv	a1,s2
    80003604:	8526                	mv	a0,s1
    80003606:	00001097          	auipc	ra,0x1
    8000360a:	e12080e7          	jalr	-494(ra) # 80004418 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000360e:	08848493          	add	s1,s1,136
    80003612:	ff3498e3          	bne	s1,s3,80003602 <iinit+0x3e>
}
    80003616:	70a2                	ld	ra,40(sp)
    80003618:	7402                	ld	s0,32(sp)
    8000361a:	64e2                	ld	s1,24(sp)
    8000361c:	6942                	ld	s2,16(sp)
    8000361e:	69a2                	ld	s3,8(sp)
    80003620:	6145                	add	sp,sp,48
    80003622:	8082                	ret

0000000080003624 <ialloc>:
{
    80003624:	7139                	add	sp,sp,-64
    80003626:	fc06                	sd	ra,56(sp)
    80003628:	f822                	sd	s0,48(sp)
    8000362a:	f426                	sd	s1,40(sp)
    8000362c:	f04a                	sd	s2,32(sp)
    8000362e:	ec4e                	sd	s3,24(sp)
    80003630:	e852                	sd	s4,16(sp)
    80003632:	e456                	sd	s5,8(sp)
    80003634:	e05a                	sd	s6,0(sp)
    80003636:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003638:	0001c717          	auipc	a4,0x1c
    8000363c:	78c72703          	lw	a4,1932(a4) # 8001fdc4 <sb+0xc>
    80003640:	4785                	li	a5,1
    80003642:	04e7f863          	bgeu	a5,a4,80003692 <ialloc+0x6e>
    80003646:	8aaa                	mv	s5,a0
    80003648:	8b2e                	mv	s6,a1
    8000364a:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000364c:	0001ca17          	auipc	s4,0x1c
    80003650:	76ca0a13          	add	s4,s4,1900 # 8001fdb8 <sb>
    80003654:	00495593          	srl	a1,s2,0x4
    80003658:	018a2783          	lw	a5,24(s4)
    8000365c:	9dbd                	addw	a1,a1,a5
    8000365e:	8556                	mv	a0,s5
    80003660:	00000097          	auipc	ra,0x0
    80003664:	94c080e7          	jalr	-1716(ra) # 80002fac <bread>
    80003668:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000366a:	05850993          	add	s3,a0,88
    8000366e:	00f97793          	and	a5,s2,15
    80003672:	079a                	sll	a5,a5,0x6
    80003674:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    80003676:	00099783          	lh	a5,0(s3)
    8000367a:	cf9d                	beqz	a5,800036b8 <ialloc+0x94>
    brelse(bp);
    8000367c:	00000097          	auipc	ra,0x0
    80003680:	a60080e7          	jalr	-1440(ra) # 800030dc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003684:	0905                	add	s2,s2,1
    80003686:	00ca2703          	lw	a4,12(s4)
    8000368a:	0009079b          	sext.w	a5,s2
    8000368e:	fce7e3e3          	bltu	a5,a4,80003654 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003692:	00005517          	auipc	a0,0x5
    80003696:	f6650513          	add	a0,a0,-154 # 800085f8 <syscalls+0x168>
    8000369a:	ffffd097          	auipc	ra,0xffffd
    8000369e:	e68080e7          	jalr	-408(ra) # 80000502 <printf>
  return 0;
    800036a2:	4501                	li	a0,0
}
    800036a4:	70e2                	ld	ra,56(sp)
    800036a6:	7442                	ld	s0,48(sp)
    800036a8:	74a2                	ld	s1,40(sp)
    800036aa:	7902                	ld	s2,32(sp)
    800036ac:	69e2                	ld	s3,24(sp)
    800036ae:	6a42                	ld	s4,16(sp)
    800036b0:	6aa2                	ld	s5,8(sp)
    800036b2:	6b02                	ld	s6,0(sp)
    800036b4:	6121                	add	sp,sp,64
    800036b6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800036b8:	04000613          	li	a2,64
    800036bc:	4581                	li	a1,0
    800036be:	854e                	mv	a0,s3
    800036c0:	ffffd097          	auipc	ra,0xffffd
    800036c4:	708080e7          	jalr	1800(ra) # 80000dc8 <memset>
      dip->type = type;
    800036c8:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    800036cc:	8526                	mv	a0,s1
    800036ce:	00001097          	auipc	ra,0x1
    800036d2:	c66080e7          	jalr	-922(ra) # 80004334 <log_write>
      brelse(bp);
    800036d6:	8526                	mv	a0,s1
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	a04080e7          	jalr	-1532(ra) # 800030dc <brelse>
      return iget(dev, inum);
    800036e0:	0009059b          	sext.w	a1,s2
    800036e4:	8556                	mv	a0,s5
    800036e6:	00000097          	auipc	ra,0x0
    800036ea:	da2080e7          	jalr	-606(ra) # 80003488 <iget>
    800036ee:	bf5d                	j	800036a4 <ialloc+0x80>

00000000800036f0 <iupdate>:
{
    800036f0:	1101                	add	sp,sp,-32
    800036f2:	ec06                	sd	ra,24(sp)
    800036f4:	e822                	sd	s0,16(sp)
    800036f6:	e426                	sd	s1,8(sp)
    800036f8:	e04a                	sd	s2,0(sp)
    800036fa:	1000                	add	s0,sp,32
    800036fc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036fe:	415c                	lw	a5,4(a0)
    80003700:	0047d79b          	srlw	a5,a5,0x4
    80003704:	0001c597          	auipc	a1,0x1c
    80003708:	6cc5a583          	lw	a1,1740(a1) # 8001fdd0 <sb+0x18>
    8000370c:	9dbd                	addw	a1,a1,a5
    8000370e:	4108                	lw	a0,0(a0)
    80003710:	00000097          	auipc	ra,0x0
    80003714:	89c080e7          	jalr	-1892(ra) # 80002fac <bread>
    80003718:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000371a:	05850793          	add	a5,a0,88
    8000371e:	40d8                	lw	a4,4(s1)
    80003720:	8b3d                	and	a4,a4,15
    80003722:	071a                	sll	a4,a4,0x6
    80003724:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003726:	04449703          	lh	a4,68(s1)
    8000372a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000372e:	04649703          	lh	a4,70(s1)
    80003732:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003736:	04849703          	lh	a4,72(s1)
    8000373a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000373e:	04a49703          	lh	a4,74(s1)
    80003742:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003746:	44f8                	lw	a4,76(s1)
    80003748:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000374a:	03400613          	li	a2,52
    8000374e:	05048593          	add	a1,s1,80
    80003752:	00c78513          	add	a0,a5,12
    80003756:	ffffd097          	auipc	ra,0xffffd
    8000375a:	6ce080e7          	jalr	1742(ra) # 80000e24 <memmove>
  log_write(bp);
    8000375e:	854a                	mv	a0,s2
    80003760:	00001097          	auipc	ra,0x1
    80003764:	bd4080e7          	jalr	-1068(ra) # 80004334 <log_write>
  brelse(bp);
    80003768:	854a                	mv	a0,s2
    8000376a:	00000097          	auipc	ra,0x0
    8000376e:	972080e7          	jalr	-1678(ra) # 800030dc <brelse>
}
    80003772:	60e2                	ld	ra,24(sp)
    80003774:	6442                	ld	s0,16(sp)
    80003776:	64a2                	ld	s1,8(sp)
    80003778:	6902                	ld	s2,0(sp)
    8000377a:	6105                	add	sp,sp,32
    8000377c:	8082                	ret

000000008000377e <idup>:
{
    8000377e:	1101                	add	sp,sp,-32
    80003780:	ec06                	sd	ra,24(sp)
    80003782:	e822                	sd	s0,16(sp)
    80003784:	e426                	sd	s1,8(sp)
    80003786:	1000                	add	s0,sp,32
    80003788:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000378a:	0001c517          	auipc	a0,0x1c
    8000378e:	64e50513          	add	a0,a0,1614 # 8001fdd8 <itable>
    80003792:	ffffd097          	auipc	ra,0xffffd
    80003796:	53a080e7          	jalr	1338(ra) # 80000ccc <acquire>
  ip->ref++;
    8000379a:	449c                	lw	a5,8(s1)
    8000379c:	2785                	addw	a5,a5,1
    8000379e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037a0:	0001c517          	auipc	a0,0x1c
    800037a4:	63850513          	add	a0,a0,1592 # 8001fdd8 <itable>
    800037a8:	ffffd097          	auipc	ra,0xffffd
    800037ac:	5d8080e7          	jalr	1496(ra) # 80000d80 <release>
}
    800037b0:	8526                	mv	a0,s1
    800037b2:	60e2                	ld	ra,24(sp)
    800037b4:	6442                	ld	s0,16(sp)
    800037b6:	64a2                	ld	s1,8(sp)
    800037b8:	6105                	add	sp,sp,32
    800037ba:	8082                	ret

00000000800037bc <ilock>:
{
    800037bc:	1101                	add	sp,sp,-32
    800037be:	ec06                	sd	ra,24(sp)
    800037c0:	e822                	sd	s0,16(sp)
    800037c2:	e426                	sd	s1,8(sp)
    800037c4:	e04a                	sd	s2,0(sp)
    800037c6:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037c8:	c115                	beqz	a0,800037ec <ilock+0x30>
    800037ca:	84aa                	mv	s1,a0
    800037cc:	451c                	lw	a5,8(a0)
    800037ce:	00f05f63          	blez	a5,800037ec <ilock+0x30>
  acquiresleep(&ip->lock);
    800037d2:	0541                	add	a0,a0,16
    800037d4:	00001097          	auipc	ra,0x1
    800037d8:	c7e080e7          	jalr	-898(ra) # 80004452 <acquiresleep>
  if(ip->valid == 0){
    800037dc:	40bc                	lw	a5,64(s1)
    800037de:	cf99                	beqz	a5,800037fc <ilock+0x40>
}
    800037e0:	60e2                	ld	ra,24(sp)
    800037e2:	6442                	ld	s0,16(sp)
    800037e4:	64a2                	ld	s1,8(sp)
    800037e6:	6902                	ld	s2,0(sp)
    800037e8:	6105                	add	sp,sp,32
    800037ea:	8082                	ret
    panic("ilock");
    800037ec:	00005517          	auipc	a0,0x5
    800037f0:	e2450513          	add	a0,a0,-476 # 80008610 <syscalls+0x180>
    800037f4:	ffffd097          	auipc	ra,0xffffd
    800037f8:	01a080e7          	jalr	26(ra) # 8000080e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037fc:	40dc                	lw	a5,4(s1)
    800037fe:	0047d79b          	srlw	a5,a5,0x4
    80003802:	0001c597          	auipc	a1,0x1c
    80003806:	5ce5a583          	lw	a1,1486(a1) # 8001fdd0 <sb+0x18>
    8000380a:	9dbd                	addw	a1,a1,a5
    8000380c:	4088                	lw	a0,0(s1)
    8000380e:	fffff097          	auipc	ra,0xfffff
    80003812:	79e080e7          	jalr	1950(ra) # 80002fac <bread>
    80003816:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003818:	05850593          	add	a1,a0,88
    8000381c:	40dc                	lw	a5,4(s1)
    8000381e:	8bbd                	and	a5,a5,15
    80003820:	079a                	sll	a5,a5,0x6
    80003822:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003824:	00059783          	lh	a5,0(a1)
    80003828:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000382c:	00259783          	lh	a5,2(a1)
    80003830:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003834:	00459783          	lh	a5,4(a1)
    80003838:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000383c:	00659783          	lh	a5,6(a1)
    80003840:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003844:	459c                	lw	a5,8(a1)
    80003846:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003848:	03400613          	li	a2,52
    8000384c:	05b1                	add	a1,a1,12
    8000384e:	05048513          	add	a0,s1,80
    80003852:	ffffd097          	auipc	ra,0xffffd
    80003856:	5d2080e7          	jalr	1490(ra) # 80000e24 <memmove>
    brelse(bp);
    8000385a:	854a                	mv	a0,s2
    8000385c:	00000097          	auipc	ra,0x0
    80003860:	880080e7          	jalr	-1920(ra) # 800030dc <brelse>
    ip->valid = 1;
    80003864:	4785                	li	a5,1
    80003866:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003868:	04449783          	lh	a5,68(s1)
    8000386c:	fbb5                	bnez	a5,800037e0 <ilock+0x24>
      panic("ilock: no type");
    8000386e:	00005517          	auipc	a0,0x5
    80003872:	daa50513          	add	a0,a0,-598 # 80008618 <syscalls+0x188>
    80003876:	ffffd097          	auipc	ra,0xffffd
    8000387a:	f98080e7          	jalr	-104(ra) # 8000080e <panic>

000000008000387e <iunlock>:
{
    8000387e:	1101                	add	sp,sp,-32
    80003880:	ec06                	sd	ra,24(sp)
    80003882:	e822                	sd	s0,16(sp)
    80003884:	e426                	sd	s1,8(sp)
    80003886:	e04a                	sd	s2,0(sp)
    80003888:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000388a:	c905                	beqz	a0,800038ba <iunlock+0x3c>
    8000388c:	84aa                	mv	s1,a0
    8000388e:	01050913          	add	s2,a0,16
    80003892:	854a                	mv	a0,s2
    80003894:	00001097          	auipc	ra,0x1
    80003898:	c58080e7          	jalr	-936(ra) # 800044ec <holdingsleep>
    8000389c:	cd19                	beqz	a0,800038ba <iunlock+0x3c>
    8000389e:	449c                	lw	a5,8(s1)
    800038a0:	00f05d63          	blez	a5,800038ba <iunlock+0x3c>
  releasesleep(&ip->lock);
    800038a4:	854a                	mv	a0,s2
    800038a6:	00001097          	auipc	ra,0x1
    800038aa:	c02080e7          	jalr	-1022(ra) # 800044a8 <releasesleep>
}
    800038ae:	60e2                	ld	ra,24(sp)
    800038b0:	6442                	ld	s0,16(sp)
    800038b2:	64a2                	ld	s1,8(sp)
    800038b4:	6902                	ld	s2,0(sp)
    800038b6:	6105                	add	sp,sp,32
    800038b8:	8082                	ret
    panic("iunlock");
    800038ba:	00005517          	auipc	a0,0x5
    800038be:	d6e50513          	add	a0,a0,-658 # 80008628 <syscalls+0x198>
    800038c2:	ffffd097          	auipc	ra,0xffffd
    800038c6:	f4c080e7          	jalr	-180(ra) # 8000080e <panic>

00000000800038ca <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    800038ca:	7179                	add	sp,sp,-48
    800038cc:	f406                	sd	ra,40(sp)
    800038ce:	f022                	sd	s0,32(sp)
    800038d0:	ec26                	sd	s1,24(sp)
    800038d2:	e84a                	sd	s2,16(sp)
    800038d4:	e44e                	sd	s3,8(sp)
    800038d6:	e052                	sd	s4,0(sp)
    800038d8:	1800                	add	s0,sp,48
    800038da:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038dc:	05050493          	add	s1,a0,80
    800038e0:	08050913          	add	s2,a0,128
    800038e4:	a021                	j	800038ec <itrunc+0x22>
    800038e6:	0491                	add	s1,s1,4
    800038e8:	01248d63          	beq	s1,s2,80003902 <itrunc+0x38>
    if(ip->addrs[i]){
    800038ec:	408c                	lw	a1,0(s1)
    800038ee:	dde5                	beqz	a1,800038e6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800038f0:	0009a503          	lw	a0,0(s3)
    800038f4:	00000097          	auipc	ra,0x0
    800038f8:	8fc080e7          	jalr	-1796(ra) # 800031f0 <bfree>
      ip->addrs[i] = 0;
    800038fc:	0004a023          	sw	zero,0(s1)
    80003900:	b7dd                	j	800038e6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003902:	0809a583          	lw	a1,128(s3)
    80003906:	e185                	bnez	a1,80003926 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003908:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000390c:	854e                	mv	a0,s3
    8000390e:	00000097          	auipc	ra,0x0
    80003912:	de2080e7          	jalr	-542(ra) # 800036f0 <iupdate>
}
    80003916:	70a2                	ld	ra,40(sp)
    80003918:	7402                	ld	s0,32(sp)
    8000391a:	64e2                	ld	s1,24(sp)
    8000391c:	6942                	ld	s2,16(sp)
    8000391e:	69a2                	ld	s3,8(sp)
    80003920:	6a02                	ld	s4,0(sp)
    80003922:	6145                	add	sp,sp,48
    80003924:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003926:	0009a503          	lw	a0,0(s3)
    8000392a:	fffff097          	auipc	ra,0xfffff
    8000392e:	682080e7          	jalr	1666(ra) # 80002fac <bread>
    80003932:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003934:	05850493          	add	s1,a0,88
    80003938:	45850913          	add	s2,a0,1112
    8000393c:	a021                	j	80003944 <itrunc+0x7a>
    8000393e:	0491                	add	s1,s1,4
    80003940:	01248b63          	beq	s1,s2,80003956 <itrunc+0x8c>
      if(a[j])
    80003944:	408c                	lw	a1,0(s1)
    80003946:	dde5                	beqz	a1,8000393e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003948:	0009a503          	lw	a0,0(s3)
    8000394c:	00000097          	auipc	ra,0x0
    80003950:	8a4080e7          	jalr	-1884(ra) # 800031f0 <bfree>
    80003954:	b7ed                	j	8000393e <itrunc+0x74>
    brelse(bp);
    80003956:	8552                	mv	a0,s4
    80003958:	fffff097          	auipc	ra,0xfffff
    8000395c:	784080e7          	jalr	1924(ra) # 800030dc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003960:	0809a583          	lw	a1,128(s3)
    80003964:	0009a503          	lw	a0,0(s3)
    80003968:	00000097          	auipc	ra,0x0
    8000396c:	888080e7          	jalr	-1912(ra) # 800031f0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003970:	0809a023          	sw	zero,128(s3)
    80003974:	bf51                	j	80003908 <itrunc+0x3e>

0000000080003976 <iput>:
{
    80003976:	1101                	add	sp,sp,-32
    80003978:	ec06                	sd	ra,24(sp)
    8000397a:	e822                	sd	s0,16(sp)
    8000397c:	e426                	sd	s1,8(sp)
    8000397e:	e04a                	sd	s2,0(sp)
    80003980:	1000                	add	s0,sp,32
    80003982:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003984:	0001c517          	auipc	a0,0x1c
    80003988:	45450513          	add	a0,a0,1108 # 8001fdd8 <itable>
    8000398c:	ffffd097          	auipc	ra,0xffffd
    80003990:	340080e7          	jalr	832(ra) # 80000ccc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003994:	4498                	lw	a4,8(s1)
    80003996:	4785                	li	a5,1
    80003998:	02f70363          	beq	a4,a5,800039be <iput+0x48>
  ip->ref--;
    8000399c:	449c                	lw	a5,8(s1)
    8000399e:	37fd                	addw	a5,a5,-1
    800039a0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039a2:	0001c517          	auipc	a0,0x1c
    800039a6:	43650513          	add	a0,a0,1078 # 8001fdd8 <itable>
    800039aa:	ffffd097          	auipc	ra,0xffffd
    800039ae:	3d6080e7          	jalr	982(ra) # 80000d80 <release>
}
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6902                	ld	s2,0(sp)
    800039ba:	6105                	add	sp,sp,32
    800039bc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039be:	40bc                	lw	a5,64(s1)
    800039c0:	dff1                	beqz	a5,8000399c <iput+0x26>
    800039c2:	04a49783          	lh	a5,74(s1)
    800039c6:	fbf9                	bnez	a5,8000399c <iput+0x26>
    acquiresleep(&ip->lock);
    800039c8:	01048913          	add	s2,s1,16
    800039cc:	854a                	mv	a0,s2
    800039ce:	00001097          	auipc	ra,0x1
    800039d2:	a84080e7          	jalr	-1404(ra) # 80004452 <acquiresleep>
    release(&itable.lock);
    800039d6:	0001c517          	auipc	a0,0x1c
    800039da:	40250513          	add	a0,a0,1026 # 8001fdd8 <itable>
    800039de:	ffffd097          	auipc	ra,0xffffd
    800039e2:	3a2080e7          	jalr	930(ra) # 80000d80 <release>
    itrunc(ip);
    800039e6:	8526                	mv	a0,s1
    800039e8:	00000097          	auipc	ra,0x0
    800039ec:	ee2080e7          	jalr	-286(ra) # 800038ca <itrunc>
    ip->type = 0;
    800039f0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039f4:	8526                	mv	a0,s1
    800039f6:	00000097          	auipc	ra,0x0
    800039fa:	cfa080e7          	jalr	-774(ra) # 800036f0 <iupdate>
    ip->valid = 0;
    800039fe:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a02:	854a                	mv	a0,s2
    80003a04:	00001097          	auipc	ra,0x1
    80003a08:	aa4080e7          	jalr	-1372(ra) # 800044a8 <releasesleep>
    acquire(&itable.lock);
    80003a0c:	0001c517          	auipc	a0,0x1c
    80003a10:	3cc50513          	add	a0,a0,972 # 8001fdd8 <itable>
    80003a14:	ffffd097          	auipc	ra,0xffffd
    80003a18:	2b8080e7          	jalr	696(ra) # 80000ccc <acquire>
    80003a1c:	b741                	j	8000399c <iput+0x26>

0000000080003a1e <iunlockput>:
{
    80003a1e:	1101                	add	sp,sp,-32
    80003a20:	ec06                	sd	ra,24(sp)
    80003a22:	e822                	sd	s0,16(sp)
    80003a24:	e426                	sd	s1,8(sp)
    80003a26:	1000                	add	s0,sp,32
    80003a28:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a2a:	00000097          	auipc	ra,0x0
    80003a2e:	e54080e7          	jalr	-428(ra) # 8000387e <iunlock>
  iput(ip);
    80003a32:	8526                	mv	a0,s1
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	f42080e7          	jalr	-190(ra) # 80003976 <iput>
}
    80003a3c:	60e2                	ld	ra,24(sp)
    80003a3e:	6442                	ld	s0,16(sp)
    80003a40:	64a2                	ld	s1,8(sp)
    80003a42:	6105                	add	sp,sp,32
    80003a44:	8082                	ret

0000000080003a46 <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80003a46:	1141                	add	sp,sp,-16
    80003a48:	e422                	sd	s0,8(sp)
    80003a4a:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003a4c:	411c                	lw	a5,0(a0)
    80003a4e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a50:	415c                	lw	a5,4(a0)
    80003a52:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a54:	04451783          	lh	a5,68(a0)
    80003a58:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a5c:	04a51783          	lh	a5,74(a0)
    80003a60:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a64:	04c56783          	lwu	a5,76(a0)
    80003a68:	e99c                	sd	a5,16(a1)
}
    80003a6a:	6422                	ld	s0,8(sp)
    80003a6c:	0141                	add	sp,sp,16
    80003a6e:	8082                	ret

0000000080003a70 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a70:	457c                	lw	a5,76(a0)
    80003a72:	0ed7e963          	bltu	a5,a3,80003b64 <readi+0xf4>
{
    80003a76:	7159                	add	sp,sp,-112
    80003a78:	f486                	sd	ra,104(sp)
    80003a7a:	f0a2                	sd	s0,96(sp)
    80003a7c:	eca6                	sd	s1,88(sp)
    80003a7e:	e8ca                	sd	s2,80(sp)
    80003a80:	e4ce                	sd	s3,72(sp)
    80003a82:	e0d2                	sd	s4,64(sp)
    80003a84:	fc56                	sd	s5,56(sp)
    80003a86:	f85a                	sd	s6,48(sp)
    80003a88:	f45e                	sd	s7,40(sp)
    80003a8a:	f062                	sd	s8,32(sp)
    80003a8c:	ec66                	sd	s9,24(sp)
    80003a8e:	e86a                	sd	s10,16(sp)
    80003a90:	e46e                	sd	s11,8(sp)
    80003a92:	1880                	add	s0,sp,112
    80003a94:	8b2a                	mv	s6,a0
    80003a96:	8bae                	mv	s7,a1
    80003a98:	8a32                	mv	s4,a2
    80003a9a:	84b6                	mv	s1,a3
    80003a9c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a9e:	9f35                	addw	a4,a4,a3
    return 0;
    80003aa0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003aa2:	0ad76063          	bltu	a4,a3,80003b42 <readi+0xd2>
  if(off + n > ip->size)
    80003aa6:	00e7f463          	bgeu	a5,a4,80003aae <readi+0x3e>
    n = ip->size - off;
    80003aaa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aae:	0a0a8963          	beqz	s5,80003b60 <readi+0xf0>
    80003ab2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ab4:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ab8:	5c7d                	li	s8,-1
    80003aba:	a82d                	j	80003af4 <readi+0x84>
    80003abc:	020d1d93          	sll	s11,s10,0x20
    80003ac0:	020ddd93          	srl	s11,s11,0x20
    80003ac4:	05890613          	add	a2,s2,88
    80003ac8:	86ee                	mv	a3,s11
    80003aca:	963a                	add	a2,a2,a4
    80003acc:	85d2                	mv	a1,s4
    80003ace:	855e                	mv	a0,s7
    80003ad0:	fffff097          	auipc	ra,0xfffff
    80003ad4:	b32080e7          	jalr	-1230(ra) # 80002602 <either_copyout>
    80003ad8:	05850d63          	beq	a0,s8,80003b32 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003adc:	854a                	mv	a0,s2
    80003ade:	fffff097          	auipc	ra,0xfffff
    80003ae2:	5fe080e7          	jalr	1534(ra) # 800030dc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae6:	013d09bb          	addw	s3,s10,s3
    80003aea:	009d04bb          	addw	s1,s10,s1
    80003aee:	9a6e                	add	s4,s4,s11
    80003af0:	0559f763          	bgeu	s3,s5,80003b3e <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003af4:	00a4d59b          	srlw	a1,s1,0xa
    80003af8:	855a                	mv	a0,s6
    80003afa:	00000097          	auipc	ra,0x0
    80003afe:	8a4080e7          	jalr	-1884(ra) # 8000339e <bmap>
    80003b02:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b06:	cd85                	beqz	a1,80003b3e <readi+0xce>
    bp = bread(ip->dev, addr);
    80003b08:	000b2503          	lw	a0,0(s6)
    80003b0c:	fffff097          	auipc	ra,0xfffff
    80003b10:	4a0080e7          	jalr	1184(ra) # 80002fac <bread>
    80003b14:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b16:	3ff4f713          	and	a4,s1,1023
    80003b1a:	40ec87bb          	subw	a5,s9,a4
    80003b1e:	413a86bb          	subw	a3,s5,s3
    80003b22:	8d3e                	mv	s10,a5
    80003b24:	2781                	sext.w	a5,a5
    80003b26:	0006861b          	sext.w	a2,a3
    80003b2a:	f8f679e3          	bgeu	a2,a5,80003abc <readi+0x4c>
    80003b2e:	8d36                	mv	s10,a3
    80003b30:	b771                	j	80003abc <readi+0x4c>
      brelse(bp);
    80003b32:	854a                	mv	a0,s2
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	5a8080e7          	jalr	1448(ra) # 800030dc <brelse>
      tot = -1;
    80003b3c:	59fd                	li	s3,-1
  }
  return tot;
    80003b3e:	0009851b          	sext.w	a0,s3
}
    80003b42:	70a6                	ld	ra,104(sp)
    80003b44:	7406                	ld	s0,96(sp)
    80003b46:	64e6                	ld	s1,88(sp)
    80003b48:	6946                	ld	s2,80(sp)
    80003b4a:	69a6                	ld	s3,72(sp)
    80003b4c:	6a06                	ld	s4,64(sp)
    80003b4e:	7ae2                	ld	s5,56(sp)
    80003b50:	7b42                	ld	s6,48(sp)
    80003b52:	7ba2                	ld	s7,40(sp)
    80003b54:	7c02                	ld	s8,32(sp)
    80003b56:	6ce2                	ld	s9,24(sp)
    80003b58:	6d42                	ld	s10,16(sp)
    80003b5a:	6da2                	ld	s11,8(sp)
    80003b5c:	6165                	add	sp,sp,112
    80003b5e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b60:	89d6                	mv	s3,s5
    80003b62:	bff1                	j	80003b3e <readi+0xce>
    return 0;
    80003b64:	4501                	li	a0,0
}
    80003b66:	8082                	ret

0000000080003b68 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b68:	457c                	lw	a5,76(a0)
    80003b6a:	10d7e863          	bltu	a5,a3,80003c7a <writei+0x112>
{
    80003b6e:	7159                	add	sp,sp,-112
    80003b70:	f486                	sd	ra,104(sp)
    80003b72:	f0a2                	sd	s0,96(sp)
    80003b74:	eca6                	sd	s1,88(sp)
    80003b76:	e8ca                	sd	s2,80(sp)
    80003b78:	e4ce                	sd	s3,72(sp)
    80003b7a:	e0d2                	sd	s4,64(sp)
    80003b7c:	fc56                	sd	s5,56(sp)
    80003b7e:	f85a                	sd	s6,48(sp)
    80003b80:	f45e                	sd	s7,40(sp)
    80003b82:	f062                	sd	s8,32(sp)
    80003b84:	ec66                	sd	s9,24(sp)
    80003b86:	e86a                	sd	s10,16(sp)
    80003b88:	e46e                	sd	s11,8(sp)
    80003b8a:	1880                	add	s0,sp,112
    80003b8c:	8aaa                	mv	s5,a0
    80003b8e:	8bae                	mv	s7,a1
    80003b90:	8a32                	mv	s4,a2
    80003b92:	8936                	mv	s2,a3
    80003b94:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b96:	00e687bb          	addw	a5,a3,a4
    80003b9a:	0ed7e263          	bltu	a5,a3,80003c7e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b9e:	00043737          	lui	a4,0x43
    80003ba2:	0ef76063          	bltu	a4,a5,80003c82 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ba6:	0c0b0863          	beqz	s6,80003c76 <writei+0x10e>
    80003baa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bac:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003bb0:	5c7d                	li	s8,-1
    80003bb2:	a091                	j	80003bf6 <writei+0x8e>
    80003bb4:	020d1d93          	sll	s11,s10,0x20
    80003bb8:	020ddd93          	srl	s11,s11,0x20
    80003bbc:	05848513          	add	a0,s1,88
    80003bc0:	86ee                	mv	a3,s11
    80003bc2:	8652                	mv	a2,s4
    80003bc4:	85de                	mv	a1,s7
    80003bc6:	953a                	add	a0,a0,a4
    80003bc8:	fffff097          	auipc	ra,0xfffff
    80003bcc:	a90080e7          	jalr	-1392(ra) # 80002658 <either_copyin>
    80003bd0:	07850263          	beq	a0,s8,80003c34 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bd4:	8526                	mv	a0,s1
    80003bd6:	00000097          	auipc	ra,0x0
    80003bda:	75e080e7          	jalr	1886(ra) # 80004334 <log_write>
    brelse(bp);
    80003bde:	8526                	mv	a0,s1
    80003be0:	fffff097          	auipc	ra,0xfffff
    80003be4:	4fc080e7          	jalr	1276(ra) # 800030dc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003be8:	013d09bb          	addw	s3,s10,s3
    80003bec:	012d093b          	addw	s2,s10,s2
    80003bf0:	9a6e                	add	s4,s4,s11
    80003bf2:	0569f663          	bgeu	s3,s6,80003c3e <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003bf6:	00a9559b          	srlw	a1,s2,0xa
    80003bfa:	8556                	mv	a0,s5
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	7a2080e7          	jalr	1954(ra) # 8000339e <bmap>
    80003c04:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003c08:	c99d                	beqz	a1,80003c3e <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003c0a:	000aa503          	lw	a0,0(s5)
    80003c0e:	fffff097          	auipc	ra,0xfffff
    80003c12:	39e080e7          	jalr	926(ra) # 80002fac <bread>
    80003c16:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c18:	3ff97713          	and	a4,s2,1023
    80003c1c:	40ec87bb          	subw	a5,s9,a4
    80003c20:	413b06bb          	subw	a3,s6,s3
    80003c24:	8d3e                	mv	s10,a5
    80003c26:	2781                	sext.w	a5,a5
    80003c28:	0006861b          	sext.w	a2,a3
    80003c2c:	f8f674e3          	bgeu	a2,a5,80003bb4 <writei+0x4c>
    80003c30:	8d36                	mv	s10,a3
    80003c32:	b749                	j	80003bb4 <writei+0x4c>
      brelse(bp);
    80003c34:	8526                	mv	a0,s1
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	4a6080e7          	jalr	1190(ra) # 800030dc <brelse>
  }

  if(off > ip->size)
    80003c3e:	04caa783          	lw	a5,76(s5)
    80003c42:	0127f463          	bgeu	a5,s2,80003c4a <writei+0xe2>
    ip->size = off;
    80003c46:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    80003c4a:	8556                	mv	a0,s5
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	aa4080e7          	jalr	-1372(ra) # 800036f0 <iupdate>

  return tot;
    80003c54:	0009851b          	sext.w	a0,s3
}
    80003c58:	70a6                	ld	ra,104(sp)
    80003c5a:	7406                	ld	s0,96(sp)
    80003c5c:	64e6                	ld	s1,88(sp)
    80003c5e:	6946                	ld	s2,80(sp)
    80003c60:	69a6                	ld	s3,72(sp)
    80003c62:	6a06                	ld	s4,64(sp)
    80003c64:	7ae2                	ld	s5,56(sp)
    80003c66:	7b42                	ld	s6,48(sp)
    80003c68:	7ba2                	ld	s7,40(sp)
    80003c6a:	7c02                	ld	s8,32(sp)
    80003c6c:	6ce2                	ld	s9,24(sp)
    80003c6e:	6d42                	ld	s10,16(sp)
    80003c70:	6da2                	ld	s11,8(sp)
    80003c72:	6165                	add	sp,sp,112
    80003c74:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c76:	89da                	mv	s3,s6
    80003c78:	bfc9                	j	80003c4a <writei+0xe2>
    return -1;
    80003c7a:	557d                	li	a0,-1
}
    80003c7c:	8082                	ret
    return -1;
    80003c7e:	557d                	li	a0,-1
    80003c80:	bfe1                	j	80003c58 <writei+0xf0>
    return -1;
    80003c82:	557d                	li	a0,-1
    80003c84:	bfd1                	j	80003c58 <writei+0xf0>

0000000080003c86 <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    80003c86:	1141                	add	sp,sp,-16
    80003c88:	e406                	sd	ra,8(sp)
    80003c8a:	e022                	sd	s0,0(sp)
    80003c8c:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c8e:	4639                	li	a2,14
    80003c90:	ffffd097          	auipc	ra,0xffffd
    80003c94:	208080e7          	jalr	520(ra) # 80000e98 <strncmp>
}
    80003c98:	60a2                	ld	ra,8(sp)
    80003c9a:	6402                	ld	s0,0(sp)
    80003c9c:	0141                	add	sp,sp,16
    80003c9e:	8082                	ret

0000000080003ca0 <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ca0:	7139                	add	sp,sp,-64
    80003ca2:	fc06                	sd	ra,56(sp)
    80003ca4:	f822                	sd	s0,48(sp)
    80003ca6:	f426                	sd	s1,40(sp)
    80003ca8:	f04a                	sd	s2,32(sp)
    80003caa:	ec4e                	sd	s3,24(sp)
    80003cac:	e852                	sd	s4,16(sp)
    80003cae:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003cb0:	04451703          	lh	a4,68(a0)
    80003cb4:	4785                	li	a5,1
    80003cb6:	00f71a63          	bne	a4,a5,80003cca <dirlookup+0x2a>
    80003cba:	892a                	mv	s2,a0
    80003cbc:	89ae                	mv	s3,a1
    80003cbe:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cc0:	457c                	lw	a5,76(a0)
    80003cc2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cc4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cc6:	e79d                	bnez	a5,80003cf4 <dirlookup+0x54>
    80003cc8:	a8a5                	j	80003d40 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003cca:	00005517          	auipc	a0,0x5
    80003cce:	96650513          	add	a0,a0,-1690 # 80008630 <syscalls+0x1a0>
    80003cd2:	ffffd097          	auipc	ra,0xffffd
    80003cd6:	b3c080e7          	jalr	-1220(ra) # 8000080e <panic>
      panic("dirlookup read");
    80003cda:	00005517          	auipc	a0,0x5
    80003cde:	96e50513          	add	a0,a0,-1682 # 80008648 <syscalls+0x1b8>
    80003ce2:	ffffd097          	auipc	ra,0xffffd
    80003ce6:	b2c080e7          	jalr	-1236(ra) # 8000080e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cea:	24c1                	addw	s1,s1,16
    80003cec:	04c92783          	lw	a5,76(s2)
    80003cf0:	04f4f763          	bgeu	s1,a5,80003d3e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cf4:	4741                	li	a4,16
    80003cf6:	86a6                	mv	a3,s1
    80003cf8:	fc040613          	add	a2,s0,-64
    80003cfc:	4581                	li	a1,0
    80003cfe:	854a                	mv	a0,s2
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	d70080e7          	jalr	-656(ra) # 80003a70 <readi>
    80003d08:	47c1                	li	a5,16
    80003d0a:	fcf518e3          	bne	a0,a5,80003cda <dirlookup+0x3a>
    if(de.inum == 0)
    80003d0e:	fc045783          	lhu	a5,-64(s0)
    80003d12:	dfe1                	beqz	a5,80003cea <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d14:	fc240593          	add	a1,s0,-62
    80003d18:	854e                	mv	a0,s3
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	f6c080e7          	jalr	-148(ra) # 80003c86 <namecmp>
    80003d22:	f561                	bnez	a0,80003cea <dirlookup+0x4a>
      if(poff)
    80003d24:	000a0463          	beqz	s4,80003d2c <dirlookup+0x8c>
        *poff = off;
    80003d28:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d2c:	fc045583          	lhu	a1,-64(s0)
    80003d30:	00092503          	lw	a0,0(s2)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	754080e7          	jalr	1876(ra) # 80003488 <iget>
    80003d3c:	a011                	j	80003d40 <dirlookup+0xa0>
  return 0;
    80003d3e:	4501                	li	a0,0
}
    80003d40:	70e2                	ld	ra,56(sp)
    80003d42:	7442                	ld	s0,48(sp)
    80003d44:	74a2                	ld	s1,40(sp)
    80003d46:	7902                	ld	s2,32(sp)
    80003d48:	69e2                	ld	s3,24(sp)
    80003d4a:	6a42                	ld	s4,16(sp)
    80003d4c:	6121                	add	sp,sp,64
    80003d4e:	8082                	ret

0000000080003d50 <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d50:	711d                	add	sp,sp,-96
    80003d52:	ec86                	sd	ra,88(sp)
    80003d54:	e8a2                	sd	s0,80(sp)
    80003d56:	e4a6                	sd	s1,72(sp)
    80003d58:	e0ca                	sd	s2,64(sp)
    80003d5a:	fc4e                	sd	s3,56(sp)
    80003d5c:	f852                	sd	s4,48(sp)
    80003d5e:	f456                	sd	s5,40(sp)
    80003d60:	f05a                	sd	s6,32(sp)
    80003d62:	ec5e                	sd	s7,24(sp)
    80003d64:	e862                	sd	s8,16(sp)
    80003d66:	e466                	sd	s9,8(sp)
    80003d68:	1080                	add	s0,sp,96
    80003d6a:	84aa                	mv	s1,a0
    80003d6c:	8b2e                	mv	s6,a1
    80003d6e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d70:	00054703          	lbu	a4,0(a0)
    80003d74:	02f00793          	li	a5,47
    80003d78:	02f70263          	beq	a4,a5,80003d9c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d7c:	ffffe097          	auipc	ra,0xffffe
    80003d80:	d8e080e7          	jalr	-626(ra) # 80001b0a <myproc>
    80003d84:	16053503          	ld	a0,352(a0)
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	9f6080e7          	jalr	-1546(ra) # 8000377e <idup>
    80003d90:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d92:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d96:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d98:	4b85                	li	s7,1
    80003d9a:	a875                	j	80003e56 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003d9c:	4585                	li	a1,1
    80003d9e:	4505                	li	a0,1
    80003da0:	fffff097          	auipc	ra,0xfffff
    80003da4:	6e8080e7          	jalr	1768(ra) # 80003488 <iget>
    80003da8:	8a2a                	mv	s4,a0
    80003daa:	b7e5                	j	80003d92 <namex+0x42>
      iunlockput(ip);
    80003dac:	8552                	mv	a0,s4
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	c70080e7          	jalr	-912(ra) # 80003a1e <iunlockput>
      return 0;
    80003db6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003db8:	8552                	mv	a0,s4
    80003dba:	60e6                	ld	ra,88(sp)
    80003dbc:	6446                	ld	s0,80(sp)
    80003dbe:	64a6                	ld	s1,72(sp)
    80003dc0:	6906                	ld	s2,64(sp)
    80003dc2:	79e2                	ld	s3,56(sp)
    80003dc4:	7a42                	ld	s4,48(sp)
    80003dc6:	7aa2                	ld	s5,40(sp)
    80003dc8:	7b02                	ld	s6,32(sp)
    80003dca:	6be2                	ld	s7,24(sp)
    80003dcc:	6c42                	ld	s8,16(sp)
    80003dce:	6ca2                	ld	s9,8(sp)
    80003dd0:	6125                	add	sp,sp,96
    80003dd2:	8082                	ret
      iunlock(ip);
    80003dd4:	8552                	mv	a0,s4
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	aa8080e7          	jalr	-1368(ra) # 8000387e <iunlock>
      return ip;
    80003dde:	bfe9                	j	80003db8 <namex+0x68>
      iunlockput(ip);
    80003de0:	8552                	mv	a0,s4
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	c3c080e7          	jalr	-964(ra) # 80003a1e <iunlockput>
      return 0;
    80003dea:	8a4e                	mv	s4,s3
    80003dec:	b7f1                	j	80003db8 <namex+0x68>
  len = path - s;
    80003dee:	40998633          	sub	a2,s3,s1
    80003df2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003df6:	099c5863          	bge	s8,s9,80003e86 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003dfa:	4639                	li	a2,14
    80003dfc:	85a6                	mv	a1,s1
    80003dfe:	8556                	mv	a0,s5
    80003e00:	ffffd097          	auipc	ra,0xffffd
    80003e04:	024080e7          	jalr	36(ra) # 80000e24 <memmove>
    80003e08:	84ce                	mv	s1,s3
  while(*path == '/')
    80003e0a:	0004c783          	lbu	a5,0(s1)
    80003e0e:	01279763          	bne	a5,s2,80003e1c <namex+0xcc>
    path++;
    80003e12:	0485                	add	s1,s1,1
  while(*path == '/')
    80003e14:	0004c783          	lbu	a5,0(s1)
    80003e18:	ff278de3          	beq	a5,s2,80003e12 <namex+0xc2>
    ilock(ip);
    80003e1c:	8552                	mv	a0,s4
    80003e1e:	00000097          	auipc	ra,0x0
    80003e22:	99e080e7          	jalr	-1634(ra) # 800037bc <ilock>
    if(ip->type != T_DIR){
    80003e26:	044a1783          	lh	a5,68(s4)
    80003e2a:	f97791e3          	bne	a5,s7,80003dac <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003e2e:	000b0563          	beqz	s6,80003e38 <namex+0xe8>
    80003e32:	0004c783          	lbu	a5,0(s1)
    80003e36:	dfd9                	beqz	a5,80003dd4 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e38:	4601                	li	a2,0
    80003e3a:	85d6                	mv	a1,s5
    80003e3c:	8552                	mv	a0,s4
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	e62080e7          	jalr	-414(ra) # 80003ca0 <dirlookup>
    80003e46:	89aa                	mv	s3,a0
    80003e48:	dd41                	beqz	a0,80003de0 <namex+0x90>
    iunlockput(ip);
    80003e4a:	8552                	mv	a0,s4
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	bd2080e7          	jalr	-1070(ra) # 80003a1e <iunlockput>
    ip = next;
    80003e54:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e56:	0004c783          	lbu	a5,0(s1)
    80003e5a:	01279763          	bne	a5,s2,80003e68 <namex+0x118>
    path++;
    80003e5e:	0485                	add	s1,s1,1
  while(*path == '/')
    80003e60:	0004c783          	lbu	a5,0(s1)
    80003e64:	ff278de3          	beq	a5,s2,80003e5e <namex+0x10e>
  if(*path == 0)
    80003e68:	cb9d                	beqz	a5,80003e9e <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003e6a:	0004c783          	lbu	a5,0(s1)
    80003e6e:	89a6                	mv	s3,s1
  len = path - s;
    80003e70:	4c81                	li	s9,0
    80003e72:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e74:	01278963          	beq	a5,s2,80003e86 <namex+0x136>
    80003e78:	dbbd                	beqz	a5,80003dee <namex+0x9e>
    path++;
    80003e7a:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e7c:	0009c783          	lbu	a5,0(s3)
    80003e80:	ff279ce3          	bne	a5,s2,80003e78 <namex+0x128>
    80003e84:	b7ad                	j	80003dee <namex+0x9e>
    memmove(name, s, len);
    80003e86:	2601                	sext.w	a2,a2
    80003e88:	85a6                	mv	a1,s1
    80003e8a:	8556                	mv	a0,s5
    80003e8c:	ffffd097          	auipc	ra,0xffffd
    80003e90:	f98080e7          	jalr	-104(ra) # 80000e24 <memmove>
    name[len] = 0;
    80003e94:	9cd6                	add	s9,s9,s5
    80003e96:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e9a:	84ce                	mv	s1,s3
    80003e9c:	b7bd                	j	80003e0a <namex+0xba>
  if(nameiparent){
    80003e9e:	f00b0de3          	beqz	s6,80003db8 <namex+0x68>
    iput(ip);
    80003ea2:	8552                	mv	a0,s4
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	ad2080e7          	jalr	-1326(ra) # 80003976 <iput>
    return 0;
    80003eac:	4a01                	li	s4,0
    80003eae:	b729                	j	80003db8 <namex+0x68>

0000000080003eb0 <dirlink>:
{
    80003eb0:	7139                	add	sp,sp,-64
    80003eb2:	fc06                	sd	ra,56(sp)
    80003eb4:	f822                	sd	s0,48(sp)
    80003eb6:	f426                	sd	s1,40(sp)
    80003eb8:	f04a                	sd	s2,32(sp)
    80003eba:	ec4e                	sd	s3,24(sp)
    80003ebc:	e852                	sd	s4,16(sp)
    80003ebe:	0080                	add	s0,sp,64
    80003ec0:	892a                	mv	s2,a0
    80003ec2:	8a2e                	mv	s4,a1
    80003ec4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ec6:	4601                	li	a2,0
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	dd8080e7          	jalr	-552(ra) # 80003ca0 <dirlookup>
    80003ed0:	e93d                	bnez	a0,80003f46 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ed2:	04c92483          	lw	s1,76(s2)
    80003ed6:	c49d                	beqz	s1,80003f04 <dirlink+0x54>
    80003ed8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eda:	4741                	li	a4,16
    80003edc:	86a6                	mv	a3,s1
    80003ede:	fc040613          	add	a2,s0,-64
    80003ee2:	4581                	li	a1,0
    80003ee4:	854a                	mv	a0,s2
    80003ee6:	00000097          	auipc	ra,0x0
    80003eea:	b8a080e7          	jalr	-1142(ra) # 80003a70 <readi>
    80003eee:	47c1                	li	a5,16
    80003ef0:	06f51163          	bne	a0,a5,80003f52 <dirlink+0xa2>
    if(de.inum == 0)
    80003ef4:	fc045783          	lhu	a5,-64(s0)
    80003ef8:	c791                	beqz	a5,80003f04 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003efa:	24c1                	addw	s1,s1,16
    80003efc:	04c92783          	lw	a5,76(s2)
    80003f00:	fcf4ede3          	bltu	s1,a5,80003eda <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003f04:	4639                	li	a2,14
    80003f06:	85d2                	mv	a1,s4
    80003f08:	fc240513          	add	a0,s0,-62
    80003f0c:	ffffd097          	auipc	ra,0xffffd
    80003f10:	fc8080e7          	jalr	-56(ra) # 80000ed4 <strncpy>
  de.inum = inum;
    80003f14:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f18:	4741                	li	a4,16
    80003f1a:	86a6                	mv	a3,s1
    80003f1c:	fc040613          	add	a2,s0,-64
    80003f20:	4581                	li	a1,0
    80003f22:	854a                	mv	a0,s2
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	c44080e7          	jalr	-956(ra) # 80003b68 <writei>
    80003f2c:	1541                	add	a0,a0,-16
    80003f2e:	00a03533          	snez	a0,a0
    80003f32:	40a00533          	neg	a0,a0
}
    80003f36:	70e2                	ld	ra,56(sp)
    80003f38:	7442                	ld	s0,48(sp)
    80003f3a:	74a2                	ld	s1,40(sp)
    80003f3c:	7902                	ld	s2,32(sp)
    80003f3e:	69e2                	ld	s3,24(sp)
    80003f40:	6a42                	ld	s4,16(sp)
    80003f42:	6121                	add	sp,sp,64
    80003f44:	8082                	ret
    iput(ip);
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	a30080e7          	jalr	-1488(ra) # 80003976 <iput>
    return -1;
    80003f4e:	557d                	li	a0,-1
    80003f50:	b7dd                	j	80003f36 <dirlink+0x86>
      panic("dirlink read");
    80003f52:	00004517          	auipc	a0,0x4
    80003f56:	70650513          	add	a0,a0,1798 # 80008658 <syscalls+0x1c8>
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	8b4080e7          	jalr	-1868(ra) # 8000080e <panic>

0000000080003f62 <namei>:

struct inode*
namei(char *path)
{
    80003f62:	1101                	add	sp,sp,-32
    80003f64:	ec06                	sd	ra,24(sp)
    80003f66:	e822                	sd	s0,16(sp)
    80003f68:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f6a:	fe040613          	add	a2,s0,-32
    80003f6e:	4581                	li	a1,0
    80003f70:	00000097          	auipc	ra,0x0
    80003f74:	de0080e7          	jalr	-544(ra) # 80003d50 <namex>
}
    80003f78:	60e2                	ld	ra,24(sp)
    80003f7a:	6442                	ld	s0,16(sp)
    80003f7c:	6105                	add	sp,sp,32
    80003f7e:	8082                	ret

0000000080003f80 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f80:	1141                	add	sp,sp,-16
    80003f82:	e406                	sd	ra,8(sp)
    80003f84:	e022                	sd	s0,0(sp)
    80003f86:	0800                	add	s0,sp,16
    80003f88:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f8a:	4585                	li	a1,1
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	dc4080e7          	jalr	-572(ra) # 80003d50 <namex>
}
    80003f94:	60a2                	ld	ra,8(sp)
    80003f96:	6402                	ld	s0,0(sp)
    80003f98:	0141                	add	sp,sp,16
    80003f9a:	8082                	ret

0000000080003f9c <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    80003f9c:	1101                	add	sp,sp,-32
    80003f9e:	ec06                	sd	ra,24(sp)
    80003fa0:	e822                	sd	s0,16(sp)
    80003fa2:	e426                	sd	s1,8(sp)
    80003fa4:	e04a                	sd	s2,0(sp)
    80003fa6:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003fa8:	0001e917          	auipc	s2,0x1e
    80003fac:	8d890913          	add	s2,s2,-1832 # 80021880 <log>
    80003fb0:	01892583          	lw	a1,24(s2)
    80003fb4:	02892503          	lw	a0,40(s2)
    80003fb8:	fffff097          	auipc	ra,0xfffff
    80003fbc:	ff4080e7          	jalr	-12(ra) # 80002fac <bread>
    80003fc0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003fc2:	02c92603          	lw	a2,44(s2)
    80003fc6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003fc8:	00c05f63          	blez	a2,80003fe6 <write_head+0x4a>
    80003fcc:	0001e717          	auipc	a4,0x1e
    80003fd0:	8e470713          	add	a4,a4,-1820 # 800218b0 <log+0x30>
    80003fd4:	87aa                	mv	a5,a0
    80003fd6:	060a                	sll	a2,a2,0x2
    80003fd8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003fda:	4314                	lw	a3,0(a4)
    80003fdc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003fde:	0711                	add	a4,a4,4
    80003fe0:	0791                	add	a5,a5,4
    80003fe2:	fec79ce3          	bne	a5,a2,80003fda <write_head+0x3e>
  }
  bwrite(buf);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	0b6080e7          	jalr	182(ra) # 8000309e <bwrite>
  brelse(buf);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	fffff097          	auipc	ra,0xfffff
    80003ff6:	0ea080e7          	jalr	234(ra) # 800030dc <brelse>
}
    80003ffa:	60e2                	ld	ra,24(sp)
    80003ffc:	6442                	ld	s0,16(sp)
    80003ffe:	64a2                	ld	s1,8(sp)
    80004000:	6902                	ld	s2,0(sp)
    80004002:	6105                	add	sp,sp,32
    80004004:	8082                	ret

0000000080004006 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004006:	0001e797          	auipc	a5,0x1e
    8000400a:	8a67a783          	lw	a5,-1882(a5) # 800218ac <log+0x2c>
    8000400e:	0af05d63          	blez	a5,800040c8 <install_trans+0xc2>
{
    80004012:	7139                	add	sp,sp,-64
    80004014:	fc06                	sd	ra,56(sp)
    80004016:	f822                	sd	s0,48(sp)
    80004018:	f426                	sd	s1,40(sp)
    8000401a:	f04a                	sd	s2,32(sp)
    8000401c:	ec4e                	sd	s3,24(sp)
    8000401e:	e852                	sd	s4,16(sp)
    80004020:	e456                	sd	s5,8(sp)
    80004022:	e05a                	sd	s6,0(sp)
    80004024:	0080                	add	s0,sp,64
    80004026:	8b2a                	mv	s6,a0
    80004028:	0001ea97          	auipc	s5,0x1e
    8000402c:	888a8a93          	add	s5,s5,-1912 # 800218b0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004030:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80004032:	0001e997          	auipc	s3,0x1e
    80004036:	84e98993          	add	s3,s3,-1970 # 80021880 <log>
    8000403a:	a00d                	j	8000405c <install_trans+0x56>
    brelse(lbuf);
    8000403c:	854a                	mv	a0,s2
    8000403e:	fffff097          	auipc	ra,0xfffff
    80004042:	09e080e7          	jalr	158(ra) # 800030dc <brelse>
    brelse(dbuf);
    80004046:	8526                	mv	a0,s1
    80004048:	fffff097          	auipc	ra,0xfffff
    8000404c:	094080e7          	jalr	148(ra) # 800030dc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004050:	2a05                	addw	s4,s4,1
    80004052:	0a91                	add	s5,s5,4
    80004054:	02c9a783          	lw	a5,44(s3)
    80004058:	04fa5e63          	bge	s4,a5,800040b4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    8000405c:	0189a583          	lw	a1,24(s3)
    80004060:	014585bb          	addw	a1,a1,s4
    80004064:	2585                	addw	a1,a1,1
    80004066:	0289a503          	lw	a0,40(s3)
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	f42080e7          	jalr	-190(ra) # 80002fac <bread>
    80004072:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    80004074:	000aa583          	lw	a1,0(s5)
    80004078:	0289a503          	lw	a0,40(s3)
    8000407c:	fffff097          	auipc	ra,0xfffff
    80004080:	f30080e7          	jalr	-208(ra) # 80002fac <bread>
    80004084:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    80004086:	40000613          	li	a2,1024
    8000408a:	05890593          	add	a1,s2,88
    8000408e:	05850513          	add	a0,a0,88
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	d92080e7          	jalr	-622(ra) # 80000e24 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    8000409a:	8526                	mv	a0,s1
    8000409c:	fffff097          	auipc	ra,0xfffff
    800040a0:	002080e7          	jalr	2(ra) # 8000309e <bwrite>
    if(recovering == 0)
    800040a4:	f80b1ce3          	bnez	s6,8000403c <install_trans+0x36>
      bunpin(dbuf);
    800040a8:	8526                	mv	a0,s1
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	10a080e7          	jalr	266(ra) # 800031b4 <bunpin>
    800040b2:	b769                	j	8000403c <install_trans+0x36>
}
    800040b4:	70e2                	ld	ra,56(sp)
    800040b6:	7442                	ld	s0,48(sp)
    800040b8:	74a2                	ld	s1,40(sp)
    800040ba:	7902                	ld	s2,32(sp)
    800040bc:	69e2                	ld	s3,24(sp)
    800040be:	6a42                	ld	s4,16(sp)
    800040c0:	6aa2                	ld	s5,8(sp)
    800040c2:	6b02                	ld	s6,0(sp)
    800040c4:	6121                	add	sp,sp,64
    800040c6:	8082                	ret
    800040c8:	8082                	ret

00000000800040ca <initlog>:
{
    800040ca:	7179                	add	sp,sp,-48
    800040cc:	f406                	sd	ra,40(sp)
    800040ce:	f022                	sd	s0,32(sp)
    800040d0:	ec26                	sd	s1,24(sp)
    800040d2:	e84a                	sd	s2,16(sp)
    800040d4:	e44e                	sd	s3,8(sp)
    800040d6:	1800                	add	s0,sp,48
    800040d8:	892a                	mv	s2,a0
    800040da:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800040dc:	0001d497          	auipc	s1,0x1d
    800040e0:	7a448493          	add	s1,s1,1956 # 80021880 <log>
    800040e4:	00004597          	auipc	a1,0x4
    800040e8:	58458593          	add	a1,a1,1412 # 80008668 <syscalls+0x1d8>
    800040ec:	8526                	mv	a0,s1
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	b4e080e7          	jalr	-1202(ra) # 80000c3c <initlock>
  log.start = sb->logstart;
    800040f6:	0149a583          	lw	a1,20(s3)
    800040fa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040fc:	0109a783          	lw	a5,16(s3)
    80004100:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004102:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004106:	854a                	mv	a0,s2
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	ea4080e7          	jalr	-348(ra) # 80002fac <bread>
  log.lh.n = lh->n;
    80004110:	4d30                	lw	a2,88(a0)
    80004112:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004114:	00c05f63          	blez	a2,80004132 <initlog+0x68>
    80004118:	87aa                	mv	a5,a0
    8000411a:	0001d717          	auipc	a4,0x1d
    8000411e:	79670713          	add	a4,a4,1942 # 800218b0 <log+0x30>
    80004122:	060a                	sll	a2,a2,0x2
    80004124:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004126:	4ff4                	lw	a3,92(a5)
    80004128:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000412a:	0791                	add	a5,a5,4
    8000412c:	0711                	add	a4,a4,4
    8000412e:	fec79ce3          	bne	a5,a2,80004126 <initlog+0x5c>
  brelse(buf);
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	faa080e7          	jalr	-86(ra) # 800030dc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    8000413a:	4505                	li	a0,1
    8000413c:	00000097          	auipc	ra,0x0
    80004140:	eca080e7          	jalr	-310(ra) # 80004006 <install_trans>
  log.lh.n = 0;
    80004144:	0001d797          	auipc	a5,0x1d
    80004148:	7607a423          	sw	zero,1896(a5) # 800218ac <log+0x2c>
  write_head(); /* clear the log */
    8000414c:	00000097          	auipc	ra,0x0
    80004150:	e50080e7          	jalr	-432(ra) # 80003f9c <write_head>
}
    80004154:	70a2                	ld	ra,40(sp)
    80004156:	7402                	ld	s0,32(sp)
    80004158:	64e2                	ld	s1,24(sp)
    8000415a:	6942                	ld	s2,16(sp)
    8000415c:	69a2                	ld	s3,8(sp)
    8000415e:	6145                	add	sp,sp,48
    80004160:	8082                	ret

0000000080004162 <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    80004162:	1101                	add	sp,sp,-32
    80004164:	ec06                	sd	ra,24(sp)
    80004166:	e822                	sd	s0,16(sp)
    80004168:	e426                	sd	s1,8(sp)
    8000416a:	e04a                	sd	s2,0(sp)
    8000416c:	1000                	add	s0,sp,32
  acquire(&log.lock);
    8000416e:	0001d517          	auipc	a0,0x1d
    80004172:	71250513          	add	a0,a0,1810 # 80021880 <log>
    80004176:	ffffd097          	auipc	ra,0xffffd
    8000417a:	b56080e7          	jalr	-1194(ra) # 80000ccc <acquire>
  while(1){
    if(log.committing){
    8000417e:	0001d497          	auipc	s1,0x1d
    80004182:	70248493          	add	s1,s1,1794 # 80021880 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004186:	4979                	li	s2,30
    80004188:	a039                	j	80004196 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000418a:	85a6                	mv	a1,s1
    8000418c:	8526                	mv	a0,s1
    8000418e:	ffffe097          	auipc	ra,0xffffe
    80004192:	06c080e7          	jalr	108(ra) # 800021fa <sleep>
    if(log.committing){
    80004196:	50dc                	lw	a5,36(s1)
    80004198:	fbed                	bnez	a5,8000418a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000419a:	5098                	lw	a4,32(s1)
    8000419c:	2705                	addw	a4,a4,1
    8000419e:	0027179b          	sllw	a5,a4,0x2
    800041a2:	9fb9                	addw	a5,a5,a4
    800041a4:	0017979b          	sllw	a5,a5,0x1
    800041a8:	54d4                	lw	a3,44(s1)
    800041aa:	9fb5                	addw	a5,a5,a3
    800041ac:	00f95963          	bge	s2,a5,800041be <begin_op+0x5c>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    800041b0:	85a6                	mv	a1,s1
    800041b2:	8526                	mv	a0,s1
    800041b4:	ffffe097          	auipc	ra,0xffffe
    800041b8:	046080e7          	jalr	70(ra) # 800021fa <sleep>
    800041bc:	bfe9                	j	80004196 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800041be:	0001d517          	auipc	a0,0x1d
    800041c2:	6c250513          	add	a0,a0,1730 # 80021880 <log>
    800041c6:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800041c8:	ffffd097          	auipc	ra,0xffffd
    800041cc:	bb8080e7          	jalr	-1096(ra) # 80000d80 <release>
      break;
    }
  }
}
    800041d0:	60e2                	ld	ra,24(sp)
    800041d2:	6442                	ld	s0,16(sp)
    800041d4:	64a2                	ld	s1,8(sp)
    800041d6:	6902                	ld	s2,0(sp)
    800041d8:	6105                	add	sp,sp,32
    800041da:	8082                	ret

00000000800041dc <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    800041dc:	7139                	add	sp,sp,-64
    800041de:	fc06                	sd	ra,56(sp)
    800041e0:	f822                	sd	s0,48(sp)
    800041e2:	f426                	sd	s1,40(sp)
    800041e4:	f04a                	sd	s2,32(sp)
    800041e6:	ec4e                	sd	s3,24(sp)
    800041e8:	e852                	sd	s4,16(sp)
    800041ea:	e456                	sd	s5,8(sp)
    800041ec:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041ee:	0001d497          	auipc	s1,0x1d
    800041f2:	69248493          	add	s1,s1,1682 # 80021880 <log>
    800041f6:	8526                	mv	a0,s1
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	ad4080e7          	jalr	-1324(ra) # 80000ccc <acquire>
  log.outstanding -= 1;
    80004200:	509c                	lw	a5,32(s1)
    80004202:	37fd                	addw	a5,a5,-1
    80004204:	0007891b          	sext.w	s2,a5
    80004208:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000420a:	50dc                	lw	a5,36(s1)
    8000420c:	e7b9                	bnez	a5,8000425a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000420e:	04091e63          	bnez	s2,8000426a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004212:	0001d497          	auipc	s1,0x1d
    80004216:	66e48493          	add	s1,s1,1646 # 80021880 <log>
    8000421a:	4785                	li	a5,1
    8000421c:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    8000421e:	8526                	mv	a0,s1
    80004220:	ffffd097          	auipc	ra,0xffffd
    80004224:	b60080e7          	jalr	-1184(ra) # 80000d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004228:	54dc                	lw	a5,44(s1)
    8000422a:	06f04763          	bgtz	a5,80004298 <end_op+0xbc>
    acquire(&log.lock);
    8000422e:	0001d497          	auipc	s1,0x1d
    80004232:	65248493          	add	s1,s1,1618 # 80021880 <log>
    80004236:	8526                	mv	a0,s1
    80004238:	ffffd097          	auipc	ra,0xffffd
    8000423c:	a94080e7          	jalr	-1388(ra) # 80000ccc <acquire>
    log.committing = 0;
    80004240:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004244:	8526                	mv	a0,s1
    80004246:	ffffe097          	auipc	ra,0xffffe
    8000424a:	018080e7          	jalr	24(ra) # 8000225e <wakeup>
    release(&log.lock);
    8000424e:	8526                	mv	a0,s1
    80004250:	ffffd097          	auipc	ra,0xffffd
    80004254:	b30080e7          	jalr	-1232(ra) # 80000d80 <release>
}
    80004258:	a03d                	j	80004286 <end_op+0xaa>
    panic("log.committing");
    8000425a:	00004517          	auipc	a0,0x4
    8000425e:	41650513          	add	a0,a0,1046 # 80008670 <syscalls+0x1e0>
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	5ac080e7          	jalr	1452(ra) # 8000080e <panic>
    wakeup(&log);
    8000426a:	0001d497          	auipc	s1,0x1d
    8000426e:	61648493          	add	s1,s1,1558 # 80021880 <log>
    80004272:	8526                	mv	a0,s1
    80004274:	ffffe097          	auipc	ra,0xffffe
    80004278:	fea080e7          	jalr	-22(ra) # 8000225e <wakeup>
  release(&log.lock);
    8000427c:	8526                	mv	a0,s1
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	b02080e7          	jalr	-1278(ra) # 80000d80 <release>
}
    80004286:	70e2                	ld	ra,56(sp)
    80004288:	7442                	ld	s0,48(sp)
    8000428a:	74a2                	ld	s1,40(sp)
    8000428c:	7902                	ld	s2,32(sp)
    8000428e:	69e2                	ld	s3,24(sp)
    80004290:	6a42                	ld	s4,16(sp)
    80004292:	6aa2                	ld	s5,8(sp)
    80004294:	6121                	add	sp,sp,64
    80004296:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004298:	0001da97          	auipc	s5,0x1d
    8000429c:	618a8a93          	add	s5,s5,1560 # 800218b0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    800042a0:	0001da17          	auipc	s4,0x1d
    800042a4:	5e0a0a13          	add	s4,s4,1504 # 80021880 <log>
    800042a8:	018a2583          	lw	a1,24(s4)
    800042ac:	012585bb          	addw	a1,a1,s2
    800042b0:	2585                	addw	a1,a1,1
    800042b2:	028a2503          	lw	a0,40(s4)
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	cf6080e7          	jalr	-778(ra) # 80002fac <bread>
    800042be:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    800042c0:	000aa583          	lw	a1,0(s5)
    800042c4:	028a2503          	lw	a0,40(s4)
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	ce4080e7          	jalr	-796(ra) # 80002fac <bread>
    800042d0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800042d2:	40000613          	li	a2,1024
    800042d6:	05850593          	add	a1,a0,88
    800042da:	05848513          	add	a0,s1,88
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	b46080e7          	jalr	-1210(ra) # 80000e24 <memmove>
    bwrite(to);  /* write the log */
    800042e6:	8526                	mv	a0,s1
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	db6080e7          	jalr	-586(ra) # 8000309e <bwrite>
    brelse(from);
    800042f0:	854e                	mv	a0,s3
    800042f2:	fffff097          	auipc	ra,0xfffff
    800042f6:	dea080e7          	jalr	-534(ra) # 800030dc <brelse>
    brelse(to);
    800042fa:	8526                	mv	a0,s1
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	de0080e7          	jalr	-544(ra) # 800030dc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004304:	2905                	addw	s2,s2,1
    80004306:	0a91                	add	s5,s5,4
    80004308:	02ca2783          	lw	a5,44(s4)
    8000430c:	f8f94ee3          	blt	s2,a5,800042a8 <end_op+0xcc>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    80004310:	00000097          	auipc	ra,0x0
    80004314:	c8c080e7          	jalr	-884(ra) # 80003f9c <write_head>
    install_trans(0); /* Now install writes to home locations */
    80004318:	4501                	li	a0,0
    8000431a:	00000097          	auipc	ra,0x0
    8000431e:	cec080e7          	jalr	-788(ra) # 80004006 <install_trans>
    log.lh.n = 0;
    80004322:	0001d797          	auipc	a5,0x1d
    80004326:	5807a523          	sw	zero,1418(a5) # 800218ac <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    8000432a:	00000097          	auipc	ra,0x0
    8000432e:	c72080e7          	jalr	-910(ra) # 80003f9c <write_head>
    80004332:	bdf5                	j	8000422e <end_op+0x52>

0000000080004334 <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    80004334:	1101                	add	sp,sp,-32
    80004336:	ec06                	sd	ra,24(sp)
    80004338:	e822                	sd	s0,16(sp)
    8000433a:	e426                	sd	s1,8(sp)
    8000433c:	e04a                	sd	s2,0(sp)
    8000433e:	1000                	add	s0,sp,32
    80004340:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004342:	0001d917          	auipc	s2,0x1d
    80004346:	53e90913          	add	s2,s2,1342 # 80021880 <log>
    8000434a:	854a                	mv	a0,s2
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	980080e7          	jalr	-1664(ra) # 80000ccc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004354:	02c92603          	lw	a2,44(s2)
    80004358:	47f5                	li	a5,29
    8000435a:	06c7c563          	blt	a5,a2,800043c4 <log_write+0x90>
    8000435e:	0001d797          	auipc	a5,0x1d
    80004362:	53e7a783          	lw	a5,1342(a5) # 8002189c <log+0x1c>
    80004366:	37fd                	addw	a5,a5,-1
    80004368:	04f65e63          	bge	a2,a5,800043c4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000436c:	0001d797          	auipc	a5,0x1d
    80004370:	5347a783          	lw	a5,1332(a5) # 800218a0 <log+0x20>
    80004374:	06f05063          	blez	a5,800043d4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004378:	4781                	li	a5,0
    8000437a:	06c05563          	blez	a2,800043e4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    8000437e:	44cc                	lw	a1,12(s1)
    80004380:	0001d717          	auipc	a4,0x1d
    80004384:	53070713          	add	a4,a4,1328 # 800218b0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004388:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    8000438a:	4314                	lw	a3,0(a4)
    8000438c:	04b68c63          	beq	a3,a1,800043e4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004390:	2785                	addw	a5,a5,1
    80004392:	0711                	add	a4,a4,4
    80004394:	fef61be3          	bne	a2,a5,8000438a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004398:	0621                	add	a2,a2,8
    8000439a:	060a                	sll	a2,a2,0x2
    8000439c:	0001d797          	auipc	a5,0x1d
    800043a0:	4e478793          	add	a5,a5,1252 # 80021880 <log>
    800043a4:	97b2                	add	a5,a5,a2
    800043a6:	44d8                	lw	a4,12(s1)
    800043a8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    800043aa:	8526                	mv	a0,s1
    800043ac:	fffff097          	auipc	ra,0xfffff
    800043b0:	dcc080e7          	jalr	-564(ra) # 80003178 <bpin>
    log.lh.n++;
    800043b4:	0001d717          	auipc	a4,0x1d
    800043b8:	4cc70713          	add	a4,a4,1228 # 80021880 <log>
    800043bc:	575c                	lw	a5,44(a4)
    800043be:	2785                	addw	a5,a5,1
    800043c0:	d75c                	sw	a5,44(a4)
    800043c2:	a82d                	j	800043fc <log_write+0xc8>
    panic("too big a transaction");
    800043c4:	00004517          	auipc	a0,0x4
    800043c8:	2bc50513          	add	a0,a0,700 # 80008680 <syscalls+0x1f0>
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	442080e7          	jalr	1090(ra) # 8000080e <panic>
    panic("log_write outside of trans");
    800043d4:	00004517          	auipc	a0,0x4
    800043d8:	2c450513          	add	a0,a0,708 # 80008698 <syscalls+0x208>
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	432080e7          	jalr	1074(ra) # 8000080e <panic>
  log.lh.block[i] = b->blockno;
    800043e4:	00878693          	add	a3,a5,8
    800043e8:	068a                	sll	a3,a3,0x2
    800043ea:	0001d717          	auipc	a4,0x1d
    800043ee:	49670713          	add	a4,a4,1174 # 80021880 <log>
    800043f2:	9736                	add	a4,a4,a3
    800043f4:	44d4                	lw	a3,12(s1)
    800043f6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    800043f8:	faf609e3          	beq	a2,a5,800043aa <log_write+0x76>
  }
  release(&log.lock);
    800043fc:	0001d517          	auipc	a0,0x1d
    80004400:	48450513          	add	a0,a0,1156 # 80021880 <log>
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	97c080e7          	jalr	-1668(ra) # 80000d80 <release>
}
    8000440c:	60e2                	ld	ra,24(sp)
    8000440e:	6442                	ld	s0,16(sp)
    80004410:	64a2                	ld	s1,8(sp)
    80004412:	6902                	ld	s2,0(sp)
    80004414:	6105                	add	sp,sp,32
    80004416:	8082                	ret

0000000080004418 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004418:	1101                	add	sp,sp,-32
    8000441a:	ec06                	sd	ra,24(sp)
    8000441c:	e822                	sd	s0,16(sp)
    8000441e:	e426                	sd	s1,8(sp)
    80004420:	e04a                	sd	s2,0(sp)
    80004422:	1000                	add	s0,sp,32
    80004424:	84aa                	mv	s1,a0
    80004426:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004428:	00004597          	auipc	a1,0x4
    8000442c:	29058593          	add	a1,a1,656 # 800086b8 <syscalls+0x228>
    80004430:	0521                	add	a0,a0,8
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	80a080e7          	jalr	-2038(ra) # 80000c3c <initlock>
  lk->name = name;
    8000443a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000443e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004442:	0204a423          	sw	zero,40(s1)
}
    80004446:	60e2                	ld	ra,24(sp)
    80004448:	6442                	ld	s0,16(sp)
    8000444a:	64a2                	ld	s1,8(sp)
    8000444c:	6902                	ld	s2,0(sp)
    8000444e:	6105                	add	sp,sp,32
    80004450:	8082                	ret

0000000080004452 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004452:	1101                	add	sp,sp,-32
    80004454:	ec06                	sd	ra,24(sp)
    80004456:	e822                	sd	s0,16(sp)
    80004458:	e426                	sd	s1,8(sp)
    8000445a:	e04a                	sd	s2,0(sp)
    8000445c:	1000                	add	s0,sp,32
    8000445e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004460:	00850913          	add	s2,a0,8
    80004464:	854a                	mv	a0,s2
    80004466:	ffffd097          	auipc	ra,0xffffd
    8000446a:	866080e7          	jalr	-1946(ra) # 80000ccc <acquire>
  while (lk->locked) {
    8000446e:	409c                	lw	a5,0(s1)
    80004470:	cb89                	beqz	a5,80004482 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004472:	85ca                	mv	a1,s2
    80004474:	8526                	mv	a0,s1
    80004476:	ffffe097          	auipc	ra,0xffffe
    8000447a:	d84080e7          	jalr	-636(ra) # 800021fa <sleep>
  while (lk->locked) {
    8000447e:	409c                	lw	a5,0(s1)
    80004480:	fbed                	bnez	a5,80004472 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004482:	4785                	li	a5,1
    80004484:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	684080e7          	jalr	1668(ra) # 80001b0a <myproc>
    8000448e:	591c                	lw	a5,48(a0)
    80004490:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004492:	854a                	mv	a0,s2
    80004494:	ffffd097          	auipc	ra,0xffffd
    80004498:	8ec080e7          	jalr	-1812(ra) # 80000d80 <release>
}
    8000449c:	60e2                	ld	ra,24(sp)
    8000449e:	6442                	ld	s0,16(sp)
    800044a0:	64a2                	ld	s1,8(sp)
    800044a2:	6902                	ld	s2,0(sp)
    800044a4:	6105                	add	sp,sp,32
    800044a6:	8082                	ret

00000000800044a8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800044a8:	1101                	add	sp,sp,-32
    800044aa:	ec06                	sd	ra,24(sp)
    800044ac:	e822                	sd	s0,16(sp)
    800044ae:	e426                	sd	s1,8(sp)
    800044b0:	e04a                	sd	s2,0(sp)
    800044b2:	1000                	add	s0,sp,32
    800044b4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044b6:	00850913          	add	s2,a0,8
    800044ba:	854a                	mv	a0,s2
    800044bc:	ffffd097          	auipc	ra,0xffffd
    800044c0:	810080e7          	jalr	-2032(ra) # 80000ccc <acquire>
  lk->locked = 0;
    800044c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044c8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800044cc:	8526                	mv	a0,s1
    800044ce:	ffffe097          	auipc	ra,0xffffe
    800044d2:	d90080e7          	jalr	-624(ra) # 8000225e <wakeup>
  release(&lk->lk);
    800044d6:	854a                	mv	a0,s2
    800044d8:	ffffd097          	auipc	ra,0xffffd
    800044dc:	8a8080e7          	jalr	-1880(ra) # 80000d80 <release>
}
    800044e0:	60e2                	ld	ra,24(sp)
    800044e2:	6442                	ld	s0,16(sp)
    800044e4:	64a2                	ld	s1,8(sp)
    800044e6:	6902                	ld	s2,0(sp)
    800044e8:	6105                	add	sp,sp,32
    800044ea:	8082                	ret

00000000800044ec <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044ec:	7179                	add	sp,sp,-48
    800044ee:	f406                	sd	ra,40(sp)
    800044f0:	f022                	sd	s0,32(sp)
    800044f2:	ec26                	sd	s1,24(sp)
    800044f4:	e84a                	sd	s2,16(sp)
    800044f6:	e44e                	sd	s3,8(sp)
    800044f8:	1800                	add	s0,sp,48
    800044fa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044fc:	00850913          	add	s2,a0,8
    80004500:	854a                	mv	a0,s2
    80004502:	ffffc097          	auipc	ra,0xffffc
    80004506:	7ca080e7          	jalr	1994(ra) # 80000ccc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000450a:	409c                	lw	a5,0(s1)
    8000450c:	ef99                	bnez	a5,8000452a <holdingsleep+0x3e>
    8000450e:	4481                	li	s1,0
  release(&lk->lk);
    80004510:	854a                	mv	a0,s2
    80004512:	ffffd097          	auipc	ra,0xffffd
    80004516:	86e080e7          	jalr	-1938(ra) # 80000d80 <release>
  return r;
}
    8000451a:	8526                	mv	a0,s1
    8000451c:	70a2                	ld	ra,40(sp)
    8000451e:	7402                	ld	s0,32(sp)
    80004520:	64e2                	ld	s1,24(sp)
    80004522:	6942                	ld	s2,16(sp)
    80004524:	69a2                	ld	s3,8(sp)
    80004526:	6145                	add	sp,sp,48
    80004528:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000452a:	0284a983          	lw	s3,40(s1)
    8000452e:	ffffd097          	auipc	ra,0xffffd
    80004532:	5dc080e7          	jalr	1500(ra) # 80001b0a <myproc>
    80004536:	5904                	lw	s1,48(a0)
    80004538:	413484b3          	sub	s1,s1,s3
    8000453c:	0014b493          	seqz	s1,s1
    80004540:	bfc1                	j	80004510 <holdingsleep+0x24>

0000000080004542 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004542:	1141                	add	sp,sp,-16
    80004544:	e406                	sd	ra,8(sp)
    80004546:	e022                	sd	s0,0(sp)
    80004548:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000454a:	00004597          	auipc	a1,0x4
    8000454e:	17e58593          	add	a1,a1,382 # 800086c8 <syscalls+0x238>
    80004552:	0001d517          	auipc	a0,0x1d
    80004556:	47650513          	add	a0,a0,1142 # 800219c8 <ftable>
    8000455a:	ffffc097          	auipc	ra,0xffffc
    8000455e:	6e2080e7          	jalr	1762(ra) # 80000c3c <initlock>
}
    80004562:	60a2                	ld	ra,8(sp)
    80004564:	6402                	ld	s0,0(sp)
    80004566:	0141                	add	sp,sp,16
    80004568:	8082                	ret

000000008000456a <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    8000456a:	1101                	add	sp,sp,-32
    8000456c:	ec06                	sd	ra,24(sp)
    8000456e:	e822                	sd	s0,16(sp)
    80004570:	e426                	sd	s1,8(sp)
    80004572:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004574:	0001d517          	auipc	a0,0x1d
    80004578:	45450513          	add	a0,a0,1108 # 800219c8 <ftable>
    8000457c:	ffffc097          	auipc	ra,0xffffc
    80004580:	750080e7          	jalr	1872(ra) # 80000ccc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004584:	0001d497          	auipc	s1,0x1d
    80004588:	45c48493          	add	s1,s1,1116 # 800219e0 <ftable+0x18>
    8000458c:	0001e717          	auipc	a4,0x1e
    80004590:	3f470713          	add	a4,a4,1012 # 80022980 <disk>
    if(f->ref == 0){
    80004594:	40dc                	lw	a5,4(s1)
    80004596:	cf99                	beqz	a5,800045b4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004598:	02848493          	add	s1,s1,40
    8000459c:	fee49ce3          	bne	s1,a4,80004594 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800045a0:	0001d517          	auipc	a0,0x1d
    800045a4:	42850513          	add	a0,a0,1064 # 800219c8 <ftable>
    800045a8:	ffffc097          	auipc	ra,0xffffc
    800045ac:	7d8080e7          	jalr	2008(ra) # 80000d80 <release>
  return 0;
    800045b0:	4481                	li	s1,0
    800045b2:	a819                	j	800045c8 <filealloc+0x5e>
      f->ref = 1;
    800045b4:	4785                	li	a5,1
    800045b6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800045b8:	0001d517          	auipc	a0,0x1d
    800045bc:	41050513          	add	a0,a0,1040 # 800219c8 <ftable>
    800045c0:	ffffc097          	auipc	ra,0xffffc
    800045c4:	7c0080e7          	jalr	1984(ra) # 80000d80 <release>
}
    800045c8:	8526                	mv	a0,s1
    800045ca:	60e2                	ld	ra,24(sp)
    800045cc:	6442                	ld	s0,16(sp)
    800045ce:	64a2                	ld	s1,8(sp)
    800045d0:	6105                	add	sp,sp,32
    800045d2:	8082                	ret

00000000800045d4 <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    800045d4:	1101                	add	sp,sp,-32
    800045d6:	ec06                	sd	ra,24(sp)
    800045d8:	e822                	sd	s0,16(sp)
    800045da:	e426                	sd	s1,8(sp)
    800045dc:	1000                	add	s0,sp,32
    800045de:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800045e0:	0001d517          	auipc	a0,0x1d
    800045e4:	3e850513          	add	a0,a0,1000 # 800219c8 <ftable>
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	6e4080e7          	jalr	1764(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    800045f0:	40dc                	lw	a5,4(s1)
    800045f2:	02f05263          	blez	a5,80004616 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045f6:	2785                	addw	a5,a5,1
    800045f8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045fa:	0001d517          	auipc	a0,0x1d
    800045fe:	3ce50513          	add	a0,a0,974 # 800219c8 <ftable>
    80004602:	ffffc097          	auipc	ra,0xffffc
    80004606:	77e080e7          	jalr	1918(ra) # 80000d80 <release>
  return f;
}
    8000460a:	8526                	mv	a0,s1
    8000460c:	60e2                	ld	ra,24(sp)
    8000460e:	6442                	ld	s0,16(sp)
    80004610:	64a2                	ld	s1,8(sp)
    80004612:	6105                	add	sp,sp,32
    80004614:	8082                	ret
    panic("filedup");
    80004616:	00004517          	auipc	a0,0x4
    8000461a:	0ba50513          	add	a0,a0,186 # 800086d0 <syscalls+0x240>
    8000461e:	ffffc097          	auipc	ra,0xffffc
    80004622:	1f0080e7          	jalr	496(ra) # 8000080e <panic>

0000000080004626 <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    80004626:	7139                	add	sp,sp,-64
    80004628:	fc06                	sd	ra,56(sp)
    8000462a:	f822                	sd	s0,48(sp)
    8000462c:	f426                	sd	s1,40(sp)
    8000462e:	f04a                	sd	s2,32(sp)
    80004630:	ec4e                	sd	s3,24(sp)
    80004632:	e852                	sd	s4,16(sp)
    80004634:	e456                	sd	s5,8(sp)
    80004636:	0080                	add	s0,sp,64
    80004638:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000463a:	0001d517          	auipc	a0,0x1d
    8000463e:	38e50513          	add	a0,a0,910 # 800219c8 <ftable>
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	68a080e7          	jalr	1674(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    8000464a:	40dc                	lw	a5,4(s1)
    8000464c:	06f05163          	blez	a5,800046ae <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004650:	37fd                	addw	a5,a5,-1
    80004652:	0007871b          	sext.w	a4,a5
    80004656:	c0dc                	sw	a5,4(s1)
    80004658:	06e04363          	bgtz	a4,800046be <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000465c:	0004a903          	lw	s2,0(s1)
    80004660:	0094ca83          	lbu	s5,9(s1)
    80004664:	0104ba03          	ld	s4,16(s1)
    80004668:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000466c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004670:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004674:	0001d517          	auipc	a0,0x1d
    80004678:	35450513          	add	a0,a0,852 # 800219c8 <ftable>
    8000467c:	ffffc097          	auipc	ra,0xffffc
    80004680:	704080e7          	jalr	1796(ra) # 80000d80 <release>

  if(ff.type == FD_PIPE){
    80004684:	4785                	li	a5,1
    80004686:	04f90d63          	beq	s2,a5,800046e0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000468a:	3979                	addw	s2,s2,-2
    8000468c:	4785                	li	a5,1
    8000468e:	0527e063          	bltu	a5,s2,800046ce <fileclose+0xa8>
    begin_op();
    80004692:	00000097          	auipc	ra,0x0
    80004696:	ad0080e7          	jalr	-1328(ra) # 80004162 <begin_op>
    iput(ff.ip);
    8000469a:	854e                	mv	a0,s3
    8000469c:	fffff097          	auipc	ra,0xfffff
    800046a0:	2da080e7          	jalr	730(ra) # 80003976 <iput>
    end_op();
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	b38080e7          	jalr	-1224(ra) # 800041dc <end_op>
    800046ac:	a00d                	j	800046ce <fileclose+0xa8>
    panic("fileclose");
    800046ae:	00004517          	auipc	a0,0x4
    800046b2:	02a50513          	add	a0,a0,42 # 800086d8 <syscalls+0x248>
    800046b6:	ffffc097          	auipc	ra,0xffffc
    800046ba:	158080e7          	jalr	344(ra) # 8000080e <panic>
    release(&ftable.lock);
    800046be:	0001d517          	auipc	a0,0x1d
    800046c2:	30a50513          	add	a0,a0,778 # 800219c8 <ftable>
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	6ba080e7          	jalr	1722(ra) # 80000d80 <release>
  }
}
    800046ce:	70e2                	ld	ra,56(sp)
    800046d0:	7442                	ld	s0,48(sp)
    800046d2:	74a2                	ld	s1,40(sp)
    800046d4:	7902                	ld	s2,32(sp)
    800046d6:	69e2                	ld	s3,24(sp)
    800046d8:	6a42                	ld	s4,16(sp)
    800046da:	6aa2                	ld	s5,8(sp)
    800046dc:	6121                	add	sp,sp,64
    800046de:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046e0:	85d6                	mv	a1,s5
    800046e2:	8552                	mv	a0,s4
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	348080e7          	jalr	840(ra) # 80004a2c <pipeclose>
    800046ec:	b7cd                	j	800046ce <fileclose+0xa8>

00000000800046ee <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    800046ee:	715d                	add	sp,sp,-80
    800046f0:	e486                	sd	ra,72(sp)
    800046f2:	e0a2                	sd	s0,64(sp)
    800046f4:	fc26                	sd	s1,56(sp)
    800046f6:	f84a                	sd	s2,48(sp)
    800046f8:	f44e                	sd	s3,40(sp)
    800046fa:	0880                	add	s0,sp,80
    800046fc:	84aa                	mv	s1,a0
    800046fe:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004700:	ffffd097          	auipc	ra,0xffffd
    80004704:	40a080e7          	jalr	1034(ra) # 80001b0a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004708:	409c                	lw	a5,0(s1)
    8000470a:	37f9                	addw	a5,a5,-2
    8000470c:	4705                	li	a4,1
    8000470e:	04f76763          	bltu	a4,a5,8000475c <filestat+0x6e>
    80004712:	892a                	mv	s2,a0
    ilock(f->ip);
    80004714:	6c88                	ld	a0,24(s1)
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	0a6080e7          	jalr	166(ra) # 800037bc <ilock>
    stati(f->ip, &st);
    8000471e:	fb840593          	add	a1,s0,-72
    80004722:	6c88                	ld	a0,24(s1)
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	322080e7          	jalr	802(ra) # 80003a46 <stati>
    iunlock(f->ip);
    8000472c:	6c88                	ld	a0,24(s1)
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	150080e7          	jalr	336(ra) # 8000387e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004736:	46e1                	li	a3,24
    80004738:	fb840613          	add	a2,s0,-72
    8000473c:	85ce                	mv	a1,s3
    8000473e:	06093503          	ld	a0,96(s2)
    80004742:	ffffd097          	auipc	ra,0xffffd
    80004746:	042080e7          	jalr	66(ra) # 80001784 <copyout>
    8000474a:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000474e:	60a6                	ld	ra,72(sp)
    80004750:	6406                	ld	s0,64(sp)
    80004752:	74e2                	ld	s1,56(sp)
    80004754:	7942                	ld	s2,48(sp)
    80004756:	79a2                	ld	s3,40(sp)
    80004758:	6161                	add	sp,sp,80
    8000475a:	8082                	ret
  return -1;
    8000475c:	557d                	li	a0,-1
    8000475e:	bfc5                	j	8000474e <filestat+0x60>

0000000080004760 <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80004760:	7179                	add	sp,sp,-48
    80004762:	f406                	sd	ra,40(sp)
    80004764:	f022                	sd	s0,32(sp)
    80004766:	ec26                	sd	s1,24(sp)
    80004768:	e84a                	sd	s2,16(sp)
    8000476a:	e44e                	sd	s3,8(sp)
    8000476c:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000476e:	00854783          	lbu	a5,8(a0)
    80004772:	c3d5                	beqz	a5,80004816 <fileread+0xb6>
    80004774:	84aa                	mv	s1,a0
    80004776:	89ae                	mv	s3,a1
    80004778:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000477a:	411c                	lw	a5,0(a0)
    8000477c:	4705                	li	a4,1
    8000477e:	04e78963          	beq	a5,a4,800047d0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004782:	470d                	li	a4,3
    80004784:	04e78d63          	beq	a5,a4,800047de <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004788:	4709                	li	a4,2
    8000478a:	06e79e63          	bne	a5,a4,80004806 <fileread+0xa6>
    ilock(f->ip);
    8000478e:	6d08                	ld	a0,24(a0)
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	02c080e7          	jalr	44(ra) # 800037bc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004798:	874a                	mv	a4,s2
    8000479a:	5094                	lw	a3,32(s1)
    8000479c:	864e                	mv	a2,s3
    8000479e:	4585                	li	a1,1
    800047a0:	6c88                	ld	a0,24(s1)
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	2ce080e7          	jalr	718(ra) # 80003a70 <readi>
    800047aa:	892a                	mv	s2,a0
    800047ac:	00a05563          	blez	a0,800047b6 <fileread+0x56>
      f->off += r;
    800047b0:	509c                	lw	a5,32(s1)
    800047b2:	9fa9                	addw	a5,a5,a0
    800047b4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800047b6:	6c88                	ld	a0,24(s1)
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	0c6080e7          	jalr	198(ra) # 8000387e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800047c0:	854a                	mv	a0,s2
    800047c2:	70a2                	ld	ra,40(sp)
    800047c4:	7402                	ld	s0,32(sp)
    800047c6:	64e2                	ld	s1,24(sp)
    800047c8:	6942                	ld	s2,16(sp)
    800047ca:	69a2                	ld	s3,8(sp)
    800047cc:	6145                	add	sp,sp,48
    800047ce:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800047d0:	6908                	ld	a0,16(a0)
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	3c2080e7          	jalr	962(ra) # 80004b94 <piperead>
    800047da:	892a                	mv	s2,a0
    800047dc:	b7d5                	j	800047c0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800047de:	02451783          	lh	a5,36(a0)
    800047e2:	03079693          	sll	a3,a5,0x30
    800047e6:	92c1                	srl	a3,a3,0x30
    800047e8:	4725                	li	a4,9
    800047ea:	02d76863          	bltu	a4,a3,8000481a <fileread+0xba>
    800047ee:	0792                	sll	a5,a5,0x4
    800047f0:	0001d717          	auipc	a4,0x1d
    800047f4:	13870713          	add	a4,a4,312 # 80021928 <devsw>
    800047f8:	97ba                	add	a5,a5,a4
    800047fa:	639c                	ld	a5,0(a5)
    800047fc:	c38d                	beqz	a5,8000481e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047fe:	4505                	li	a0,1
    80004800:	9782                	jalr	a5
    80004802:	892a                	mv	s2,a0
    80004804:	bf75                	j	800047c0 <fileread+0x60>
    panic("fileread");
    80004806:	00004517          	auipc	a0,0x4
    8000480a:	ee250513          	add	a0,a0,-286 # 800086e8 <syscalls+0x258>
    8000480e:	ffffc097          	auipc	ra,0xffffc
    80004812:	000080e7          	jalr	ra # 8000080e <panic>
    return -1;
    80004816:	597d                	li	s2,-1
    80004818:	b765                	j	800047c0 <fileread+0x60>
      return -1;
    8000481a:	597d                	li	s2,-1
    8000481c:	b755                	j	800047c0 <fileread+0x60>
    8000481e:	597d                	li	s2,-1
    80004820:	b745                	j	800047c0 <fileread+0x60>

0000000080004822 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004822:	00954783          	lbu	a5,9(a0)
    80004826:	10078e63          	beqz	a5,80004942 <filewrite+0x120>
{
    8000482a:	715d                	add	sp,sp,-80
    8000482c:	e486                	sd	ra,72(sp)
    8000482e:	e0a2                	sd	s0,64(sp)
    80004830:	fc26                	sd	s1,56(sp)
    80004832:	f84a                	sd	s2,48(sp)
    80004834:	f44e                	sd	s3,40(sp)
    80004836:	f052                	sd	s4,32(sp)
    80004838:	ec56                	sd	s5,24(sp)
    8000483a:	e85a                	sd	s6,16(sp)
    8000483c:	e45e                	sd	s7,8(sp)
    8000483e:	e062                	sd	s8,0(sp)
    80004840:	0880                	add	s0,sp,80
    80004842:	892a                	mv	s2,a0
    80004844:	8b2e                	mv	s6,a1
    80004846:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004848:	411c                	lw	a5,0(a0)
    8000484a:	4705                	li	a4,1
    8000484c:	02e78263          	beq	a5,a4,80004870 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004850:	470d                	li	a4,3
    80004852:	02e78563          	beq	a5,a4,8000487c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004856:	4709                	li	a4,2
    80004858:	0ce79d63          	bne	a5,a4,80004932 <filewrite+0x110>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000485c:	0ac05b63          	blez	a2,80004912 <filewrite+0xf0>
    int i = 0;
    80004860:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004862:	6b85                	lui	s7,0x1
    80004864:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004868:	6c05                	lui	s8,0x1
    8000486a:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000486e:	a851                	j	80004902 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004870:	6908                	ld	a0,16(a0)
    80004872:	00000097          	auipc	ra,0x0
    80004876:	22a080e7          	jalr	554(ra) # 80004a9c <pipewrite>
    8000487a:	a045                	j	8000491a <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000487c:	02451783          	lh	a5,36(a0)
    80004880:	03079693          	sll	a3,a5,0x30
    80004884:	92c1                	srl	a3,a3,0x30
    80004886:	4725                	li	a4,9
    80004888:	0ad76f63          	bltu	a4,a3,80004946 <filewrite+0x124>
    8000488c:	0792                	sll	a5,a5,0x4
    8000488e:	0001d717          	auipc	a4,0x1d
    80004892:	09a70713          	add	a4,a4,154 # 80021928 <devsw>
    80004896:	97ba                	add	a5,a5,a4
    80004898:	679c                	ld	a5,8(a5)
    8000489a:	cbc5                	beqz	a5,8000494a <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    8000489c:	4505                	li	a0,1
    8000489e:	9782                	jalr	a5
    800048a0:	a8ad                	j	8000491a <filewrite+0xf8>
      if(n1 > max)
    800048a2:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800048a6:	00000097          	auipc	ra,0x0
    800048aa:	8bc080e7          	jalr	-1860(ra) # 80004162 <begin_op>
      ilock(f->ip);
    800048ae:	01893503          	ld	a0,24(s2)
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	f0a080e7          	jalr	-246(ra) # 800037bc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800048ba:	8756                	mv	a4,s5
    800048bc:	02092683          	lw	a3,32(s2)
    800048c0:	01698633          	add	a2,s3,s6
    800048c4:	4585                	li	a1,1
    800048c6:	01893503          	ld	a0,24(s2)
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	29e080e7          	jalr	670(ra) # 80003b68 <writei>
    800048d2:	84aa                	mv	s1,a0
    800048d4:	00a05763          	blez	a0,800048e2 <filewrite+0xc0>
        f->off += r;
    800048d8:	02092783          	lw	a5,32(s2)
    800048dc:	9fa9                	addw	a5,a5,a0
    800048de:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800048e2:	01893503          	ld	a0,24(s2)
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	f98080e7          	jalr	-104(ra) # 8000387e <iunlock>
      end_op();
    800048ee:	00000097          	auipc	ra,0x0
    800048f2:	8ee080e7          	jalr	-1810(ra) # 800041dc <end_op>

      if(r != n1){
    800048f6:	009a9f63          	bne	s5,s1,80004914 <filewrite+0xf2>
        /* error from writei */
        break;
      }
      i += r;
    800048fa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048fe:	0149db63          	bge	s3,s4,80004914 <filewrite+0xf2>
      int n1 = n - i;
    80004902:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004906:	0004879b          	sext.w	a5,s1
    8000490a:	f8fbdce3          	bge	s7,a5,800048a2 <filewrite+0x80>
    8000490e:	84e2                	mv	s1,s8
    80004910:	bf49                	j	800048a2 <filewrite+0x80>
    int i = 0;
    80004912:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004914:	033a1d63          	bne	s4,s3,8000494e <filewrite+0x12c>
    80004918:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000491a:	60a6                	ld	ra,72(sp)
    8000491c:	6406                	ld	s0,64(sp)
    8000491e:	74e2                	ld	s1,56(sp)
    80004920:	7942                	ld	s2,48(sp)
    80004922:	79a2                	ld	s3,40(sp)
    80004924:	7a02                	ld	s4,32(sp)
    80004926:	6ae2                	ld	s5,24(sp)
    80004928:	6b42                	ld	s6,16(sp)
    8000492a:	6ba2                	ld	s7,8(sp)
    8000492c:	6c02                	ld	s8,0(sp)
    8000492e:	6161                	add	sp,sp,80
    80004930:	8082                	ret
    panic("filewrite");
    80004932:	00004517          	auipc	a0,0x4
    80004936:	dc650513          	add	a0,a0,-570 # 800086f8 <syscalls+0x268>
    8000493a:	ffffc097          	auipc	ra,0xffffc
    8000493e:	ed4080e7          	jalr	-300(ra) # 8000080e <panic>
    return -1;
    80004942:	557d                	li	a0,-1
}
    80004944:	8082                	ret
      return -1;
    80004946:	557d                	li	a0,-1
    80004948:	bfc9                	j	8000491a <filewrite+0xf8>
    8000494a:	557d                	li	a0,-1
    8000494c:	b7f9                	j	8000491a <filewrite+0xf8>
    ret = (i == n ? n : -1);
    8000494e:	557d                	li	a0,-1
    80004950:	b7e9                	j	8000491a <filewrite+0xf8>

0000000080004952 <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004952:	7179                	add	sp,sp,-48
    80004954:	f406                	sd	ra,40(sp)
    80004956:	f022                	sd	s0,32(sp)
    80004958:	ec26                	sd	s1,24(sp)
    8000495a:	e84a                	sd	s2,16(sp)
    8000495c:	e44e                	sd	s3,8(sp)
    8000495e:	e052                	sd	s4,0(sp)
    80004960:	1800                	add	s0,sp,48
    80004962:	84aa                	mv	s1,a0
    80004964:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004966:	0005b023          	sd	zero,0(a1)
    8000496a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000496e:	00000097          	auipc	ra,0x0
    80004972:	bfc080e7          	jalr	-1028(ra) # 8000456a <filealloc>
    80004976:	e088                	sd	a0,0(s1)
    80004978:	c551                	beqz	a0,80004a04 <pipealloc+0xb2>
    8000497a:	00000097          	auipc	ra,0x0
    8000497e:	bf0080e7          	jalr	-1040(ra) # 8000456a <filealloc>
    80004982:	00aa3023          	sd	a0,0(s4)
    80004986:	c92d                	beqz	a0,800049f8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004988:	ffffc097          	auipc	ra,0xffffc
    8000498c:	254080e7          	jalr	596(ra) # 80000bdc <kalloc>
    80004990:	892a                	mv	s2,a0
    80004992:	c125                	beqz	a0,800049f2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004994:	4985                	li	s3,1
    80004996:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000499a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000499e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800049a2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800049a6:	00004597          	auipc	a1,0x4
    800049aa:	d6258593          	add	a1,a1,-670 # 80008708 <syscalls+0x278>
    800049ae:	ffffc097          	auipc	ra,0xffffc
    800049b2:	28e080e7          	jalr	654(ra) # 80000c3c <initlock>
  (*f0)->type = FD_PIPE;
    800049b6:	609c                	ld	a5,0(s1)
    800049b8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800049bc:	609c                	ld	a5,0(s1)
    800049be:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800049c2:	609c                	ld	a5,0(s1)
    800049c4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800049c8:	609c                	ld	a5,0(s1)
    800049ca:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800049ce:	000a3783          	ld	a5,0(s4)
    800049d2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049d6:	000a3783          	ld	a5,0(s4)
    800049da:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049de:	000a3783          	ld	a5,0(s4)
    800049e2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049e6:	000a3783          	ld	a5,0(s4)
    800049ea:	0127b823          	sd	s2,16(a5)
  return 0;
    800049ee:	4501                	li	a0,0
    800049f0:	a025                	j	80004a18 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049f2:	6088                	ld	a0,0(s1)
    800049f4:	e501                	bnez	a0,800049fc <pipealloc+0xaa>
    800049f6:	a039                	j	80004a04 <pipealloc+0xb2>
    800049f8:	6088                	ld	a0,0(s1)
    800049fa:	c51d                	beqz	a0,80004a28 <pipealloc+0xd6>
    fileclose(*f0);
    800049fc:	00000097          	auipc	ra,0x0
    80004a00:	c2a080e7          	jalr	-982(ra) # 80004626 <fileclose>
  if(*f1)
    80004a04:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a08:	557d                	li	a0,-1
  if(*f1)
    80004a0a:	c799                	beqz	a5,80004a18 <pipealloc+0xc6>
    fileclose(*f1);
    80004a0c:	853e                	mv	a0,a5
    80004a0e:	00000097          	auipc	ra,0x0
    80004a12:	c18080e7          	jalr	-1000(ra) # 80004626 <fileclose>
  return -1;
    80004a16:	557d                	li	a0,-1
}
    80004a18:	70a2                	ld	ra,40(sp)
    80004a1a:	7402                	ld	s0,32(sp)
    80004a1c:	64e2                	ld	s1,24(sp)
    80004a1e:	6942                	ld	s2,16(sp)
    80004a20:	69a2                	ld	s3,8(sp)
    80004a22:	6a02                	ld	s4,0(sp)
    80004a24:	6145                	add	sp,sp,48
    80004a26:	8082                	ret
  return -1;
    80004a28:	557d                	li	a0,-1
    80004a2a:	b7fd                	j	80004a18 <pipealloc+0xc6>

0000000080004a2c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a2c:	1101                	add	sp,sp,-32
    80004a2e:	ec06                	sd	ra,24(sp)
    80004a30:	e822                	sd	s0,16(sp)
    80004a32:	e426                	sd	s1,8(sp)
    80004a34:	e04a                	sd	s2,0(sp)
    80004a36:	1000                	add	s0,sp,32
    80004a38:	84aa                	mv	s1,a0
    80004a3a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a3c:	ffffc097          	auipc	ra,0xffffc
    80004a40:	290080e7          	jalr	656(ra) # 80000ccc <acquire>
  if(writable){
    80004a44:	02090d63          	beqz	s2,80004a7e <pipeclose+0x52>
    pi->writeopen = 0;
    80004a48:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a4c:	21848513          	add	a0,s1,536
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	80e080e7          	jalr	-2034(ra) # 8000225e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a58:	2204b783          	ld	a5,544(s1)
    80004a5c:	eb95                	bnez	a5,80004a90 <pipeclose+0x64>
    release(&pi->lock);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	320080e7          	jalr	800(ra) # 80000d80 <release>
    kfree((char*)pi);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffc097          	auipc	ra,0xffffc
    80004a6e:	074080e7          	jalr	116(ra) # 80000ade <kfree>
  } else
    release(&pi->lock);
}
    80004a72:	60e2                	ld	ra,24(sp)
    80004a74:	6442                	ld	s0,16(sp)
    80004a76:	64a2                	ld	s1,8(sp)
    80004a78:	6902                	ld	s2,0(sp)
    80004a7a:	6105                	add	sp,sp,32
    80004a7c:	8082                	ret
    pi->readopen = 0;
    80004a7e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a82:	21c48513          	add	a0,s1,540
    80004a86:	ffffd097          	auipc	ra,0xffffd
    80004a8a:	7d8080e7          	jalr	2008(ra) # 8000225e <wakeup>
    80004a8e:	b7e9                	j	80004a58 <pipeclose+0x2c>
    release(&pi->lock);
    80004a90:	8526                	mv	a0,s1
    80004a92:	ffffc097          	auipc	ra,0xffffc
    80004a96:	2ee080e7          	jalr	750(ra) # 80000d80 <release>
}
    80004a9a:	bfe1                	j	80004a72 <pipeclose+0x46>

0000000080004a9c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a9c:	711d                	add	sp,sp,-96
    80004a9e:	ec86                	sd	ra,88(sp)
    80004aa0:	e8a2                	sd	s0,80(sp)
    80004aa2:	e4a6                	sd	s1,72(sp)
    80004aa4:	e0ca                	sd	s2,64(sp)
    80004aa6:	fc4e                	sd	s3,56(sp)
    80004aa8:	f852                	sd	s4,48(sp)
    80004aaa:	f456                	sd	s5,40(sp)
    80004aac:	f05a                	sd	s6,32(sp)
    80004aae:	ec5e                	sd	s7,24(sp)
    80004ab0:	e862                	sd	s8,16(sp)
    80004ab2:	1080                	add	s0,sp,96
    80004ab4:	84aa                	mv	s1,a0
    80004ab6:	8aae                	mv	s5,a1
    80004ab8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004aba:	ffffd097          	auipc	ra,0xffffd
    80004abe:	050080e7          	jalr	80(ra) # 80001b0a <myproc>
    80004ac2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	ffffc097          	auipc	ra,0xffffc
    80004aca:	206080e7          	jalr	518(ra) # 80000ccc <acquire>
  while(i < n){
    80004ace:	0b405663          	blez	s4,80004b7a <pipewrite+0xde>
  int i = 0;
    80004ad2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ad4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004ad6:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ada:	21c48b93          	add	s7,s1,540
    80004ade:	a089                	j	80004b20 <pipewrite+0x84>
      release(&pi->lock);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffc097          	auipc	ra,0xffffc
    80004ae6:	29e080e7          	jalr	670(ra) # 80000d80 <release>
      return -1;
    80004aea:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004aec:	854a                	mv	a0,s2
    80004aee:	60e6                	ld	ra,88(sp)
    80004af0:	6446                	ld	s0,80(sp)
    80004af2:	64a6                	ld	s1,72(sp)
    80004af4:	6906                	ld	s2,64(sp)
    80004af6:	79e2                	ld	s3,56(sp)
    80004af8:	7a42                	ld	s4,48(sp)
    80004afa:	7aa2                	ld	s5,40(sp)
    80004afc:	7b02                	ld	s6,32(sp)
    80004afe:	6be2                	ld	s7,24(sp)
    80004b00:	6c42                	ld	s8,16(sp)
    80004b02:	6125                	add	sp,sp,96
    80004b04:	8082                	ret
      wakeup(&pi->nread);
    80004b06:	8562                	mv	a0,s8
    80004b08:	ffffd097          	auipc	ra,0xffffd
    80004b0c:	756080e7          	jalr	1878(ra) # 8000225e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b10:	85a6                	mv	a1,s1
    80004b12:	855e                	mv	a0,s7
    80004b14:	ffffd097          	auipc	ra,0xffffd
    80004b18:	6e6080e7          	jalr	1766(ra) # 800021fa <sleep>
  while(i < n){
    80004b1c:	07495063          	bge	s2,s4,80004b7c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004b20:	2204a783          	lw	a5,544(s1)
    80004b24:	dfd5                	beqz	a5,80004ae0 <pipewrite+0x44>
    80004b26:	854e                	mv	a0,s3
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	97a080e7          	jalr	-1670(ra) # 800024a2 <killed>
    80004b30:	f945                	bnez	a0,80004ae0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    80004b32:	2184a783          	lw	a5,536(s1)
    80004b36:	21c4a703          	lw	a4,540(s1)
    80004b3a:	2007879b          	addw	a5,a5,512
    80004b3e:	fcf704e3          	beq	a4,a5,80004b06 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b42:	4685                	li	a3,1
    80004b44:	01590633          	add	a2,s2,s5
    80004b48:	faf40593          	add	a1,s0,-81
    80004b4c:	0609b503          	ld	a0,96(s3)
    80004b50:	ffffd097          	auipc	ra,0xffffd
    80004b54:	cf4080e7          	jalr	-780(ra) # 80001844 <copyin>
    80004b58:	03650263          	beq	a0,s6,80004b7c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b5c:	21c4a783          	lw	a5,540(s1)
    80004b60:	0017871b          	addw	a4,a5,1
    80004b64:	20e4ae23          	sw	a4,540(s1)
    80004b68:	1ff7f793          	and	a5,a5,511
    80004b6c:	97a6                	add	a5,a5,s1
    80004b6e:	faf44703          	lbu	a4,-81(s0)
    80004b72:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b76:	2905                	addw	s2,s2,1
    80004b78:	b755                	j	80004b1c <pipewrite+0x80>
  int i = 0;
    80004b7a:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b7c:	21848513          	add	a0,s1,536
    80004b80:	ffffd097          	auipc	ra,0xffffd
    80004b84:	6de080e7          	jalr	1758(ra) # 8000225e <wakeup>
  release(&pi->lock);
    80004b88:	8526                	mv	a0,s1
    80004b8a:	ffffc097          	auipc	ra,0xffffc
    80004b8e:	1f6080e7          	jalr	502(ra) # 80000d80 <release>
  return i;
    80004b92:	bfa9                	j	80004aec <pipewrite+0x50>

0000000080004b94 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b94:	715d                	add	sp,sp,-80
    80004b96:	e486                	sd	ra,72(sp)
    80004b98:	e0a2                	sd	s0,64(sp)
    80004b9a:	fc26                	sd	s1,56(sp)
    80004b9c:	f84a                	sd	s2,48(sp)
    80004b9e:	f44e                	sd	s3,40(sp)
    80004ba0:	f052                	sd	s4,32(sp)
    80004ba2:	ec56                	sd	s5,24(sp)
    80004ba4:	e85a                	sd	s6,16(sp)
    80004ba6:	0880                	add	s0,sp,80
    80004ba8:	84aa                	mv	s1,a0
    80004baa:	892e                	mv	s2,a1
    80004bac:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004bae:	ffffd097          	auipc	ra,0xffffd
    80004bb2:	f5c080e7          	jalr	-164(ra) # 80001b0a <myproc>
    80004bb6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffc097          	auipc	ra,0xffffc
    80004bbe:	112080e7          	jalr	274(ra) # 80000ccc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004bc2:	2184a703          	lw	a4,536(s1)
    80004bc6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004bca:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004bce:	02f71763          	bne	a4,a5,80004bfc <piperead+0x68>
    80004bd2:	2244a783          	lw	a5,548(s1)
    80004bd6:	c39d                	beqz	a5,80004bfc <piperead+0x68>
    if(killed(pr)){
    80004bd8:	8552                	mv	a0,s4
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	8c8080e7          	jalr	-1848(ra) # 800024a2 <killed>
    80004be2:	e949                	bnez	a0,80004c74 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004be4:	85a6                	mv	a1,s1
    80004be6:	854e                	mv	a0,s3
    80004be8:	ffffd097          	auipc	ra,0xffffd
    80004bec:	612080e7          	jalr	1554(ra) # 800021fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004bf0:	2184a703          	lw	a4,536(s1)
    80004bf4:	21c4a783          	lw	a5,540(s1)
    80004bf8:	fcf70de3          	beq	a4,a5,80004bd2 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004bfc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bfe:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004c00:	05505463          	blez	s5,80004c48 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004c04:	2184a783          	lw	a5,536(s1)
    80004c08:	21c4a703          	lw	a4,540(s1)
    80004c0c:	02f70e63          	beq	a4,a5,80004c48 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c10:	0017871b          	addw	a4,a5,1
    80004c14:	20e4ac23          	sw	a4,536(s1)
    80004c18:	1ff7f793          	and	a5,a5,511
    80004c1c:	97a6                	add	a5,a5,s1
    80004c1e:	0187c783          	lbu	a5,24(a5)
    80004c22:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c26:	4685                	li	a3,1
    80004c28:	fbf40613          	add	a2,s0,-65
    80004c2c:	85ca                	mv	a1,s2
    80004c2e:	060a3503          	ld	a0,96(s4)
    80004c32:	ffffd097          	auipc	ra,0xffffd
    80004c36:	b52080e7          	jalr	-1198(ra) # 80001784 <copyout>
    80004c3a:	01650763          	beq	a0,s6,80004c48 <piperead+0xb4>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004c3e:	2985                	addw	s3,s3,1
    80004c40:	0905                	add	s2,s2,1
    80004c42:	fd3a91e3          	bne	s5,s3,80004c04 <piperead+0x70>
    80004c46:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    80004c48:	21c48513          	add	a0,s1,540
    80004c4c:	ffffd097          	auipc	ra,0xffffd
    80004c50:	612080e7          	jalr	1554(ra) # 8000225e <wakeup>
  release(&pi->lock);
    80004c54:	8526                	mv	a0,s1
    80004c56:	ffffc097          	auipc	ra,0xffffc
    80004c5a:	12a080e7          	jalr	298(ra) # 80000d80 <release>
  return i;
}
    80004c5e:	854e                	mv	a0,s3
    80004c60:	60a6                	ld	ra,72(sp)
    80004c62:	6406                	ld	s0,64(sp)
    80004c64:	74e2                	ld	s1,56(sp)
    80004c66:	7942                	ld	s2,48(sp)
    80004c68:	79a2                	ld	s3,40(sp)
    80004c6a:	7a02                	ld	s4,32(sp)
    80004c6c:	6ae2                	ld	s5,24(sp)
    80004c6e:	6b42                	ld	s6,16(sp)
    80004c70:	6161                	add	sp,sp,80
    80004c72:	8082                	ret
      release(&pi->lock);
    80004c74:	8526                	mv	a0,s1
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	10a080e7          	jalr	266(ra) # 80000d80 <release>
      return -1;
    80004c7e:	59fd                	li	s3,-1
    80004c80:	bff9                	j	80004c5e <piperead+0xca>

0000000080004c82 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004c82:	1141                	add	sp,sp,-16
    80004c84:	e422                	sd	s0,8(sp)
    80004c86:	0800                	add	s0,sp,16
    80004c88:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004c8a:	8905                	and	a0,a0,1
    80004c8c:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004c8e:	8b89                	and	a5,a5,2
    80004c90:	c399                	beqz	a5,80004c96 <flags2perm+0x14>
      perm |= PTE_W;
    80004c92:	00456513          	or	a0,a0,4
    return perm;
}
    80004c96:	6422                	ld	s0,8(sp)
    80004c98:	0141                	add	sp,sp,16
    80004c9a:	8082                	ret

0000000080004c9c <exec>:

int
exec(char *path, char **argv)
{
    80004c9c:	df010113          	add	sp,sp,-528
    80004ca0:	20113423          	sd	ra,520(sp)
    80004ca4:	20813023          	sd	s0,512(sp)
    80004ca8:	ffa6                	sd	s1,504(sp)
    80004caa:	fbca                	sd	s2,496(sp)
    80004cac:	f7ce                	sd	s3,488(sp)
    80004cae:	f3d2                	sd	s4,480(sp)
    80004cb0:	efd6                	sd	s5,472(sp)
    80004cb2:	ebda                	sd	s6,464(sp)
    80004cb4:	e7de                	sd	s7,456(sp)
    80004cb6:	e3e2                	sd	s8,448(sp)
    80004cb8:	ff66                	sd	s9,440(sp)
    80004cba:	fb6a                	sd	s10,432(sp)
    80004cbc:	f76e                	sd	s11,424(sp)
    80004cbe:	0c00                	add	s0,sp,528
    80004cc0:	892a                	mv	s2,a0
    80004cc2:	dea43c23          	sd	a0,-520(s0)
    80004cc6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	e40080e7          	jalr	-448(ra) # 80001b0a <myproc>
    80004cd2:	84aa                	mv	s1,a0

  begin_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	48e080e7          	jalr	1166(ra) # 80004162 <begin_op>

  if((ip = namei(path)) == 0){
    80004cdc:	854a                	mv	a0,s2
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	284080e7          	jalr	644(ra) # 80003f62 <namei>
    80004ce6:	c92d                	beqz	a0,80004d58 <exec+0xbc>
    80004ce8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	ad2080e7          	jalr	-1326(ra) # 800037bc <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004cf2:	04000713          	li	a4,64
    80004cf6:	4681                	li	a3,0
    80004cf8:	e5040613          	add	a2,s0,-432
    80004cfc:	4581                	li	a1,0
    80004cfe:	8552                	mv	a0,s4
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	d70080e7          	jalr	-656(ra) # 80003a70 <readi>
    80004d08:	04000793          	li	a5,64
    80004d0c:	00f51a63          	bne	a0,a5,80004d20 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004d10:	e5042703          	lw	a4,-432(s0)
    80004d14:	464c47b7          	lui	a5,0x464c4
    80004d18:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d1c:	04f70463          	beq	a4,a5,80004d64 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d20:	8552                	mv	a0,s4
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	cfc080e7          	jalr	-772(ra) # 80003a1e <iunlockput>
    end_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	4b2080e7          	jalr	1202(ra) # 800041dc <end_op>
  }
  return -1;
    80004d32:	557d                	li	a0,-1
}
    80004d34:	20813083          	ld	ra,520(sp)
    80004d38:	20013403          	ld	s0,512(sp)
    80004d3c:	74fe                	ld	s1,504(sp)
    80004d3e:	795e                	ld	s2,496(sp)
    80004d40:	79be                	ld	s3,488(sp)
    80004d42:	7a1e                	ld	s4,480(sp)
    80004d44:	6afe                	ld	s5,472(sp)
    80004d46:	6b5e                	ld	s6,464(sp)
    80004d48:	6bbe                	ld	s7,456(sp)
    80004d4a:	6c1e                	ld	s8,448(sp)
    80004d4c:	7cfa                	ld	s9,440(sp)
    80004d4e:	7d5a                	ld	s10,432(sp)
    80004d50:	7dba                	ld	s11,424(sp)
    80004d52:	21010113          	add	sp,sp,528
    80004d56:	8082                	ret
    end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	484080e7          	jalr	1156(ra) # 800041dc <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	bfc9                	j	80004d34 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d64:	8526                	mv	a0,s1
    80004d66:	ffffd097          	auipc	ra,0xffffd
    80004d6a:	e72080e7          	jalr	-398(ra) # 80001bd8 <proc_pagetable>
    80004d6e:	8b2a                	mv	s6,a0
    80004d70:	d945                	beqz	a0,80004d20 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d72:	e7042d03          	lw	s10,-400(s0)
    80004d76:	e8845783          	lhu	a5,-376(s0)
    80004d7a:	10078463          	beqz	a5,80004e82 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d7e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d80:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004d82:	6c85                	lui	s9,0x1
    80004d84:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004d88:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004d8c:	6a85                	lui	s5,0x1
    80004d8e:	a0b5                	j	80004dfa <exec+0x15e>
      panic("loadseg: address should exist");
    80004d90:	00004517          	auipc	a0,0x4
    80004d94:	98050513          	add	a0,a0,-1664 # 80008710 <syscalls+0x280>
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	a76080e7          	jalr	-1418(ra) # 8000080e <panic>
    if(sz - i < PGSIZE)
    80004da0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004da2:	8726                	mv	a4,s1
    80004da4:	012c06bb          	addw	a3,s8,s2
    80004da8:	4581                	li	a1,0
    80004daa:	8552                	mv	a0,s4
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	cc4080e7          	jalr	-828(ra) # 80003a70 <readi>
    80004db4:	2501                	sext.w	a0,a0
    80004db6:	24a49863          	bne	s1,a0,80005006 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004dba:	012a893b          	addw	s2,s5,s2
    80004dbe:	03397563          	bgeu	s2,s3,80004de8 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004dc2:	02091593          	sll	a1,s2,0x20
    80004dc6:	9181                	srl	a1,a1,0x20
    80004dc8:	95de                	add	a1,a1,s7
    80004dca:	855a                	mv	a0,s6
    80004dcc:	ffffc097          	auipc	ra,0xffffc
    80004dd0:	384080e7          	jalr	900(ra) # 80001150 <walkaddr>
    80004dd4:	862a                	mv	a2,a0
    if(pa == 0)
    80004dd6:	dd4d                	beqz	a0,80004d90 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004dd8:	412984bb          	subw	s1,s3,s2
    80004ddc:	0004879b          	sext.w	a5,s1
    80004de0:	fcfcf0e3          	bgeu	s9,a5,80004da0 <exec+0x104>
    80004de4:	84d6                	mv	s1,s5
    80004de6:	bf6d                	j	80004da0 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004de8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dec:	2d85                	addw	s11,s11,1
    80004dee:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004df2:	e8845783          	lhu	a5,-376(s0)
    80004df6:	08fdd763          	bge	s11,a5,80004e84 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004dfa:	2d01                	sext.w	s10,s10
    80004dfc:	03800713          	li	a4,56
    80004e00:	86ea                	mv	a3,s10
    80004e02:	e1840613          	add	a2,s0,-488
    80004e06:	4581                	li	a1,0
    80004e08:	8552                	mv	a0,s4
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	c66080e7          	jalr	-922(ra) # 80003a70 <readi>
    80004e12:	03800793          	li	a5,56
    80004e16:	1ef51663          	bne	a0,a5,80005002 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004e1a:	e1842783          	lw	a5,-488(s0)
    80004e1e:	4705                	li	a4,1
    80004e20:	fce796e3          	bne	a5,a4,80004dec <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004e24:	e4043483          	ld	s1,-448(s0)
    80004e28:	e3843783          	ld	a5,-456(s0)
    80004e2c:	1ef4e863          	bltu	s1,a5,8000501c <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e30:	e2843783          	ld	a5,-472(s0)
    80004e34:	94be                	add	s1,s1,a5
    80004e36:	1ef4e663          	bltu	s1,a5,80005022 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004e3a:	df043703          	ld	a4,-528(s0)
    80004e3e:	8ff9                	and	a5,a5,a4
    80004e40:	1e079463          	bnez	a5,80005028 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e44:	e1c42503          	lw	a0,-484(s0)
    80004e48:	00000097          	auipc	ra,0x0
    80004e4c:	e3a080e7          	jalr	-454(ra) # 80004c82 <flags2perm>
    80004e50:	86aa                	mv	a3,a0
    80004e52:	8626                	mv	a2,s1
    80004e54:	85ca                	mv	a1,s2
    80004e56:	855a                	mv	a0,s6
    80004e58:	ffffc097          	auipc	ra,0xffffc
    80004e5c:	6d0080e7          	jalr	1744(ra) # 80001528 <uvmalloc>
    80004e60:	e0a43423          	sd	a0,-504(s0)
    80004e64:	1c050563          	beqz	a0,8000502e <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004e68:	e2843b83          	ld	s7,-472(s0)
    80004e6c:	e2042c03          	lw	s8,-480(s0)
    80004e70:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004e74:	00098463          	beqz	s3,80004e7c <exec+0x1e0>
    80004e78:	4901                	li	s2,0
    80004e7a:	b7a1                	j	80004dc2 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e7c:	e0843903          	ld	s2,-504(s0)
    80004e80:	b7b5                	j	80004dec <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e82:	4901                	li	s2,0
  iunlockput(ip);
    80004e84:	8552                	mv	a0,s4
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	b98080e7          	jalr	-1128(ra) # 80003a1e <iunlockput>
  end_op();
    80004e8e:	fffff097          	auipc	ra,0xfffff
    80004e92:	34e080e7          	jalr	846(ra) # 800041dc <end_op>
  p = myproc();
    80004e96:	ffffd097          	auipc	ra,0xffffd
    80004e9a:	c74080e7          	jalr	-908(ra) # 80001b0a <myproc>
    80004e9e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004ea0:	05853c83          	ld	s9,88(a0)
  sz = PGROUNDUP(sz);
    80004ea4:	6985                	lui	s3,0x1
    80004ea6:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004ea8:	99ca                	add	s3,s3,s2
    80004eaa:	77fd                	lui	a5,0xfffff
    80004eac:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004eb0:	4691                	li	a3,4
    80004eb2:	6609                	lui	a2,0x2
    80004eb4:	964e                	add	a2,a2,s3
    80004eb6:	85ce                	mv	a1,s3
    80004eb8:	855a                	mv	a0,s6
    80004eba:	ffffc097          	auipc	ra,0xffffc
    80004ebe:	66e080e7          	jalr	1646(ra) # 80001528 <uvmalloc>
    80004ec2:	892a                	mv	s2,a0
    80004ec4:	e0a43423          	sd	a0,-504(s0)
    80004ec8:	e509                	bnez	a0,80004ed2 <exec+0x236>
  if(pagetable)
    80004eca:	e1343423          	sd	s3,-504(s0)
    80004ece:	4a01                	li	s4,0
    80004ed0:	aa1d                	j	80005006 <exec+0x36a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004ed2:	75f9                	lui	a1,0xffffe
    80004ed4:	95aa                	add	a1,a1,a0
    80004ed6:	855a                	mv	a0,s6
    80004ed8:	ffffd097          	auipc	ra,0xffffd
    80004edc:	87a080e7          	jalr	-1926(ra) # 80001752 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004ee0:	7bfd                	lui	s7,0xfffff
    80004ee2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004ee4:	e0043783          	ld	a5,-512(s0)
    80004ee8:	6388                	ld	a0,0(a5)
    80004eea:	c52d                	beqz	a0,80004f54 <exec+0x2b8>
    80004eec:	e9040993          	add	s3,s0,-368
    80004ef0:	f9040c13          	add	s8,s0,-112
    80004ef4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004ef6:	ffffc097          	auipc	ra,0xffffc
    80004efa:	04c080e7          	jalr	76(ra) # 80000f42 <strlen>
    80004efe:	0015079b          	addw	a5,a0,1
    80004f02:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    80004f06:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004f0a:	13796563          	bltu	s2,s7,80005034 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f0e:	e0043d03          	ld	s10,-512(s0)
    80004f12:	000d3a03          	ld	s4,0(s10)
    80004f16:	8552                	mv	a0,s4
    80004f18:	ffffc097          	auipc	ra,0xffffc
    80004f1c:	02a080e7          	jalr	42(ra) # 80000f42 <strlen>
    80004f20:	0015069b          	addw	a3,a0,1
    80004f24:	8652                	mv	a2,s4
    80004f26:	85ca                	mv	a1,s2
    80004f28:	855a                	mv	a0,s6
    80004f2a:	ffffd097          	auipc	ra,0xffffd
    80004f2e:	85a080e7          	jalr	-1958(ra) # 80001784 <copyout>
    80004f32:	10054363          	bltz	a0,80005038 <exec+0x39c>
    ustack[argc] = sp;
    80004f36:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004f3a:	0485                	add	s1,s1,1
    80004f3c:	008d0793          	add	a5,s10,8
    80004f40:	e0f43023          	sd	a5,-512(s0)
    80004f44:	008d3503          	ld	a0,8(s10)
    80004f48:	c909                	beqz	a0,80004f5a <exec+0x2be>
    if(argc >= MAXARG)
    80004f4a:	09a1                	add	s3,s3,8
    80004f4c:	fb8995e3          	bne	s3,s8,80004ef6 <exec+0x25a>
  ip = 0;
    80004f50:	4a01                	li	s4,0
    80004f52:	a855                	j	80005006 <exec+0x36a>
  sp = sz;
    80004f54:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004f58:	4481                	li	s1,0
  ustack[argc] = 0;
    80004f5a:	00349793          	sll	a5,s1,0x3
    80004f5e:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdc4d0>
    80004f62:	97a2                	add	a5,a5,s0
    80004f64:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004f68:	00148693          	add	a3,s1,1
    80004f6c:	068e                	sll	a3,a3,0x3
    80004f6e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004f72:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004f76:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004f7a:	f57968e3          	bltu	s2,s7,80004eca <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004f7e:	e9040613          	add	a2,s0,-368
    80004f82:	85ca                	mv	a1,s2
    80004f84:	855a                	mv	a0,s6
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	7fe080e7          	jalr	2046(ra) # 80001784 <copyout>
    80004f8e:	0a054763          	bltz	a0,8000503c <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004f92:	068ab783          	ld	a5,104(s5) # 1068 <_entry-0x7fffef98>
    80004f96:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004f9a:	df843783          	ld	a5,-520(s0)
    80004f9e:	0007c703          	lbu	a4,0(a5)
    80004fa2:	cf11                	beqz	a4,80004fbe <exec+0x322>
    80004fa4:	0785                	add	a5,a5,1
    if(*s == '/')
    80004fa6:	02f00693          	li	a3,47
    80004faa:	a039                	j	80004fb8 <exec+0x31c>
      last = s+1;
    80004fac:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004fb0:	0785                	add	a5,a5,1
    80004fb2:	fff7c703          	lbu	a4,-1(a5)
    80004fb6:	c701                	beqz	a4,80004fbe <exec+0x322>
    if(*s == '/')
    80004fb8:	fed71ce3          	bne	a4,a3,80004fb0 <exec+0x314>
    80004fbc:	bfc5                	j	80004fac <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004fbe:	4641                	li	a2,16
    80004fc0:	df843583          	ld	a1,-520(s0)
    80004fc4:	168a8513          	add	a0,s5,360
    80004fc8:	ffffc097          	auipc	ra,0xffffc
    80004fcc:	f48080e7          	jalr	-184(ra) # 80000f10 <safestrcpy>
  oldpagetable = p->pagetable;
    80004fd0:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    80004fd4:	076ab023          	sd	s6,96(s5)
  p->sz = sz;
    80004fd8:	e0843783          	ld	a5,-504(s0)
    80004fdc:	04fabc23          	sd	a5,88(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    80004fe0:	068ab783          	ld	a5,104(s5)
    80004fe4:	e6843703          	ld	a4,-408(s0)
    80004fe8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    80004fea:	068ab783          	ld	a5,104(s5)
    80004fee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ff2:	85e6                	mv	a1,s9
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	c80080e7          	jalr	-896(ra) # 80001c74 <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    80004ffc:	0004851b          	sext.w	a0,s1
    80005000:	bb15                	j	80004d34 <exec+0x98>
    80005002:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80005006:	e0843583          	ld	a1,-504(s0)
    8000500a:	855a                	mv	a0,s6
    8000500c:	ffffd097          	auipc	ra,0xffffd
    80005010:	c68080e7          	jalr	-920(ra) # 80001c74 <proc_freepagetable>
  return -1;
    80005014:	557d                	li	a0,-1
  if(ip){
    80005016:	d00a0fe3          	beqz	s4,80004d34 <exec+0x98>
    8000501a:	b319                	j	80004d20 <exec+0x84>
    8000501c:	e1243423          	sd	s2,-504(s0)
    80005020:	b7dd                	j	80005006 <exec+0x36a>
    80005022:	e1243423          	sd	s2,-504(s0)
    80005026:	b7c5                	j	80005006 <exec+0x36a>
    80005028:	e1243423          	sd	s2,-504(s0)
    8000502c:	bfe9                	j	80005006 <exec+0x36a>
    8000502e:	e1243423          	sd	s2,-504(s0)
    80005032:	bfd1                	j	80005006 <exec+0x36a>
  ip = 0;
    80005034:	4a01                	li	s4,0
    80005036:	bfc1                	j	80005006 <exec+0x36a>
    80005038:	4a01                	li	s4,0
  if(pagetable)
    8000503a:	b7f1                	j	80005006 <exec+0x36a>
  sz = sz1;
    8000503c:	e0843983          	ld	s3,-504(s0)
    80005040:	b569                	j	80004eca <exec+0x22e>

0000000080005042 <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005042:	7179                	add	sp,sp,-48
    80005044:	f406                	sd	ra,40(sp)
    80005046:	f022                	sd	s0,32(sp)
    80005048:	ec26                	sd	s1,24(sp)
    8000504a:	e84a                	sd	s2,16(sp)
    8000504c:	1800                	add	s0,sp,48
    8000504e:	892e                	mv	s2,a1
    80005050:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005052:	fdc40593          	add	a1,s0,-36
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	bf6080e7          	jalr	-1034(ra) # 80002c4c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000505e:	fdc42703          	lw	a4,-36(s0)
    80005062:	47bd                	li	a5,15
    80005064:	02e7eb63          	bltu	a5,a4,8000509a <argfd+0x58>
    80005068:	ffffd097          	auipc	ra,0xffffd
    8000506c:	aa2080e7          	jalr	-1374(ra) # 80001b0a <myproc>
    80005070:	fdc42703          	lw	a4,-36(s0)
    80005074:	01c70793          	add	a5,a4,28
    80005078:	078e                	sll	a5,a5,0x3
    8000507a:	953e                	add	a0,a0,a5
    8000507c:	611c                	ld	a5,0(a0)
    8000507e:	c385                	beqz	a5,8000509e <argfd+0x5c>
    return -1;
  if(pfd)
    80005080:	00090463          	beqz	s2,80005088 <argfd+0x46>
    *pfd = fd;
    80005084:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005088:	4501                	li	a0,0
  if(pf)
    8000508a:	c091                	beqz	s1,8000508e <argfd+0x4c>
    *pf = f;
    8000508c:	e09c                	sd	a5,0(s1)
}
    8000508e:	70a2                	ld	ra,40(sp)
    80005090:	7402                	ld	s0,32(sp)
    80005092:	64e2                	ld	s1,24(sp)
    80005094:	6942                	ld	s2,16(sp)
    80005096:	6145                	add	sp,sp,48
    80005098:	8082                	ret
    return -1;
    8000509a:	557d                	li	a0,-1
    8000509c:	bfcd                	j	8000508e <argfd+0x4c>
    8000509e:	557d                	li	a0,-1
    800050a0:	b7fd                	j	8000508e <argfd+0x4c>

00000000800050a2 <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    800050a2:	1101                	add	sp,sp,-32
    800050a4:	ec06                	sd	ra,24(sp)
    800050a6:	e822                	sd	s0,16(sp)
    800050a8:	e426                	sd	s1,8(sp)
    800050aa:	1000                	add	s0,sp,32
    800050ac:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800050ae:	ffffd097          	auipc	ra,0xffffd
    800050b2:	a5c080e7          	jalr	-1444(ra) # 80001b0a <myproc>
    800050b6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800050b8:	0e050793          	add	a5,a0,224
    800050bc:	4501                	li	a0,0
    800050be:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800050c0:	6398                	ld	a4,0(a5)
    800050c2:	cb19                	beqz	a4,800050d8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800050c4:	2505                	addw	a0,a0,1
    800050c6:	07a1                	add	a5,a5,8
    800050c8:	fed51ce3          	bne	a0,a3,800050c0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800050cc:	557d                	li	a0,-1
}
    800050ce:	60e2                	ld	ra,24(sp)
    800050d0:	6442                	ld	s0,16(sp)
    800050d2:	64a2                	ld	s1,8(sp)
    800050d4:	6105                	add	sp,sp,32
    800050d6:	8082                	ret
      p->ofile[fd] = f;
    800050d8:	01c50793          	add	a5,a0,28
    800050dc:	078e                	sll	a5,a5,0x3
    800050de:	963e                	add	a2,a2,a5
    800050e0:	e204                	sd	s1,0(a2)
      return fd;
    800050e2:	b7f5                	j	800050ce <fdalloc+0x2c>

00000000800050e4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050e4:	715d                	add	sp,sp,-80
    800050e6:	e486                	sd	ra,72(sp)
    800050e8:	e0a2                	sd	s0,64(sp)
    800050ea:	fc26                	sd	s1,56(sp)
    800050ec:	f84a                	sd	s2,48(sp)
    800050ee:	f44e                	sd	s3,40(sp)
    800050f0:	f052                	sd	s4,32(sp)
    800050f2:	ec56                	sd	s5,24(sp)
    800050f4:	e85a                	sd	s6,16(sp)
    800050f6:	0880                	add	s0,sp,80
    800050f8:	8b2e                	mv	s6,a1
    800050fa:	89b2                	mv	s3,a2
    800050fc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050fe:	fb040593          	add	a1,s0,-80
    80005102:	fffff097          	auipc	ra,0xfffff
    80005106:	e7e080e7          	jalr	-386(ra) # 80003f80 <nameiparent>
    8000510a:	84aa                	mv	s1,a0
    8000510c:	14050b63          	beqz	a0,80005262 <create+0x17e>
    return 0;

  ilock(dp);
    80005110:	ffffe097          	auipc	ra,0xffffe
    80005114:	6ac080e7          	jalr	1708(ra) # 800037bc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005118:	4601                	li	a2,0
    8000511a:	fb040593          	add	a1,s0,-80
    8000511e:	8526                	mv	a0,s1
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	b80080e7          	jalr	-1152(ra) # 80003ca0 <dirlookup>
    80005128:	8aaa                	mv	s5,a0
    8000512a:	c921                	beqz	a0,8000517a <create+0x96>
    iunlockput(dp);
    8000512c:	8526                	mv	a0,s1
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	8f0080e7          	jalr	-1808(ra) # 80003a1e <iunlockput>
    ilock(ip);
    80005136:	8556                	mv	a0,s5
    80005138:	ffffe097          	auipc	ra,0xffffe
    8000513c:	684080e7          	jalr	1668(ra) # 800037bc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005140:	4789                	li	a5,2
    80005142:	02fb1563          	bne	s6,a5,8000516c <create+0x88>
    80005146:	044ad783          	lhu	a5,68(s5)
    8000514a:	37f9                	addw	a5,a5,-2
    8000514c:	17c2                	sll	a5,a5,0x30
    8000514e:	93c1                	srl	a5,a5,0x30
    80005150:	4705                	li	a4,1
    80005152:	00f76d63          	bltu	a4,a5,8000516c <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005156:	8556                	mv	a0,s5
    80005158:	60a6                	ld	ra,72(sp)
    8000515a:	6406                	ld	s0,64(sp)
    8000515c:	74e2                	ld	s1,56(sp)
    8000515e:	7942                	ld	s2,48(sp)
    80005160:	79a2                	ld	s3,40(sp)
    80005162:	7a02                	ld	s4,32(sp)
    80005164:	6ae2                	ld	s5,24(sp)
    80005166:	6b42                	ld	s6,16(sp)
    80005168:	6161                	add	sp,sp,80
    8000516a:	8082                	ret
    iunlockput(ip);
    8000516c:	8556                	mv	a0,s5
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	8b0080e7          	jalr	-1872(ra) # 80003a1e <iunlockput>
    return 0;
    80005176:	4a81                	li	s5,0
    80005178:	bff9                	j	80005156 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000517a:	85da                	mv	a1,s6
    8000517c:	4088                	lw	a0,0(s1)
    8000517e:	ffffe097          	auipc	ra,0xffffe
    80005182:	4a6080e7          	jalr	1190(ra) # 80003624 <ialloc>
    80005186:	8a2a                	mv	s4,a0
    80005188:	c529                	beqz	a0,800051d2 <create+0xee>
  ilock(ip);
    8000518a:	ffffe097          	auipc	ra,0xffffe
    8000518e:	632080e7          	jalr	1586(ra) # 800037bc <ilock>
  ip->major = major;
    80005192:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005196:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000519a:	4905                	li	s2,1
    8000519c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800051a0:	8552                	mv	a0,s4
    800051a2:	ffffe097          	auipc	ra,0xffffe
    800051a6:	54e080e7          	jalr	1358(ra) # 800036f0 <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    800051aa:	032b0b63          	beq	s6,s2,800051e0 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800051ae:	004a2603          	lw	a2,4(s4)
    800051b2:	fb040593          	add	a1,s0,-80
    800051b6:	8526                	mv	a0,s1
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	cf8080e7          	jalr	-776(ra) # 80003eb0 <dirlink>
    800051c0:	06054f63          	bltz	a0,8000523e <create+0x15a>
  iunlockput(dp);
    800051c4:	8526                	mv	a0,s1
    800051c6:	fffff097          	auipc	ra,0xfffff
    800051ca:	858080e7          	jalr	-1960(ra) # 80003a1e <iunlockput>
  return ip;
    800051ce:	8ad2                	mv	s5,s4
    800051d0:	b759                	j	80005156 <create+0x72>
    iunlockput(dp);
    800051d2:	8526                	mv	a0,s1
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	84a080e7          	jalr	-1974(ra) # 80003a1e <iunlockput>
    return 0;
    800051dc:	8ad2                	mv	s5,s4
    800051de:	bfa5                	j	80005156 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051e0:	004a2603          	lw	a2,4(s4)
    800051e4:	00003597          	auipc	a1,0x3
    800051e8:	54c58593          	add	a1,a1,1356 # 80008730 <syscalls+0x2a0>
    800051ec:	8552                	mv	a0,s4
    800051ee:	fffff097          	auipc	ra,0xfffff
    800051f2:	cc2080e7          	jalr	-830(ra) # 80003eb0 <dirlink>
    800051f6:	04054463          	bltz	a0,8000523e <create+0x15a>
    800051fa:	40d0                	lw	a2,4(s1)
    800051fc:	00003597          	auipc	a1,0x3
    80005200:	53c58593          	add	a1,a1,1340 # 80008738 <syscalls+0x2a8>
    80005204:	8552                	mv	a0,s4
    80005206:	fffff097          	auipc	ra,0xfffff
    8000520a:	caa080e7          	jalr	-854(ra) # 80003eb0 <dirlink>
    8000520e:	02054863          	bltz	a0,8000523e <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80005212:	004a2603          	lw	a2,4(s4)
    80005216:	fb040593          	add	a1,s0,-80
    8000521a:	8526                	mv	a0,s1
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	c94080e7          	jalr	-876(ra) # 80003eb0 <dirlink>
    80005224:	00054d63          	bltz	a0,8000523e <create+0x15a>
    dp->nlink++;  /* for ".." */
    80005228:	04a4d783          	lhu	a5,74(s1)
    8000522c:	2785                	addw	a5,a5,1
    8000522e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005232:	8526                	mv	a0,s1
    80005234:	ffffe097          	auipc	ra,0xffffe
    80005238:	4bc080e7          	jalr	1212(ra) # 800036f0 <iupdate>
    8000523c:	b761                	j	800051c4 <create+0xe0>
  ip->nlink = 0;
    8000523e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005242:	8552                	mv	a0,s4
    80005244:	ffffe097          	auipc	ra,0xffffe
    80005248:	4ac080e7          	jalr	1196(ra) # 800036f0 <iupdate>
  iunlockput(ip);
    8000524c:	8552                	mv	a0,s4
    8000524e:	ffffe097          	auipc	ra,0xffffe
    80005252:	7d0080e7          	jalr	2000(ra) # 80003a1e <iunlockput>
  iunlockput(dp);
    80005256:	8526                	mv	a0,s1
    80005258:	ffffe097          	auipc	ra,0xffffe
    8000525c:	7c6080e7          	jalr	1990(ra) # 80003a1e <iunlockput>
  return 0;
    80005260:	bddd                	j	80005156 <create+0x72>
    return 0;
    80005262:	8aaa                	mv	s5,a0
    80005264:	bdcd                	j	80005156 <create+0x72>

0000000080005266 <sys_dup>:
{
    80005266:	7179                	add	sp,sp,-48
    80005268:	f406                	sd	ra,40(sp)
    8000526a:	f022                	sd	s0,32(sp)
    8000526c:	ec26                	sd	s1,24(sp)
    8000526e:	e84a                	sd	s2,16(sp)
    80005270:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005272:	fd840613          	add	a2,s0,-40
    80005276:	4581                	li	a1,0
    80005278:	4501                	li	a0,0
    8000527a:	00000097          	auipc	ra,0x0
    8000527e:	dc8080e7          	jalr	-568(ra) # 80005042 <argfd>
    return -1;
    80005282:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005284:	02054363          	bltz	a0,800052aa <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005288:	fd843903          	ld	s2,-40(s0)
    8000528c:	854a                	mv	a0,s2
    8000528e:	00000097          	auipc	ra,0x0
    80005292:	e14080e7          	jalr	-492(ra) # 800050a2 <fdalloc>
    80005296:	84aa                	mv	s1,a0
    return -1;
    80005298:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000529a:	00054863          	bltz	a0,800052aa <sys_dup+0x44>
  filedup(f);
    8000529e:	854a                	mv	a0,s2
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	334080e7          	jalr	820(ra) # 800045d4 <filedup>
  return fd;
    800052a8:	87a6                	mv	a5,s1
}
    800052aa:	853e                	mv	a0,a5
    800052ac:	70a2                	ld	ra,40(sp)
    800052ae:	7402                	ld	s0,32(sp)
    800052b0:	64e2                	ld	s1,24(sp)
    800052b2:	6942                	ld	s2,16(sp)
    800052b4:	6145                	add	sp,sp,48
    800052b6:	8082                	ret

00000000800052b8 <sys_read>:
{
    800052b8:	7179                	add	sp,sp,-48
    800052ba:	f406                	sd	ra,40(sp)
    800052bc:	f022                	sd	s0,32(sp)
    800052be:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800052c0:	fd840593          	add	a1,s0,-40
    800052c4:	4505                	li	a0,1
    800052c6:	ffffe097          	auipc	ra,0xffffe
    800052ca:	9a6080e7          	jalr	-1626(ra) # 80002c6c <argaddr>
  argint(2, &n);
    800052ce:	fe440593          	add	a1,s0,-28
    800052d2:	4509                	li	a0,2
    800052d4:	ffffe097          	auipc	ra,0xffffe
    800052d8:	978080e7          	jalr	-1672(ra) # 80002c4c <argint>
  if(argfd(0, 0, &f) < 0)
    800052dc:	fe840613          	add	a2,s0,-24
    800052e0:	4581                	li	a1,0
    800052e2:	4501                	li	a0,0
    800052e4:	00000097          	auipc	ra,0x0
    800052e8:	d5e080e7          	jalr	-674(ra) # 80005042 <argfd>
    800052ec:	87aa                	mv	a5,a0
    return -1;
    800052ee:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800052f0:	0007cc63          	bltz	a5,80005308 <sys_read+0x50>
  return fileread(f, p, n);
    800052f4:	fe442603          	lw	a2,-28(s0)
    800052f8:	fd843583          	ld	a1,-40(s0)
    800052fc:	fe843503          	ld	a0,-24(s0)
    80005300:	fffff097          	auipc	ra,0xfffff
    80005304:	460080e7          	jalr	1120(ra) # 80004760 <fileread>
}
    80005308:	70a2                	ld	ra,40(sp)
    8000530a:	7402                	ld	s0,32(sp)
    8000530c:	6145                	add	sp,sp,48
    8000530e:	8082                	ret

0000000080005310 <sys_write>:
{
    80005310:	7179                	add	sp,sp,-48
    80005312:	f406                	sd	ra,40(sp)
    80005314:	f022                	sd	s0,32(sp)
    80005316:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80005318:	fd840593          	add	a1,s0,-40
    8000531c:	4505                	li	a0,1
    8000531e:	ffffe097          	auipc	ra,0xffffe
    80005322:	94e080e7          	jalr	-1714(ra) # 80002c6c <argaddr>
  argint(2, &n);
    80005326:	fe440593          	add	a1,s0,-28
    8000532a:	4509                	li	a0,2
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	920080e7          	jalr	-1760(ra) # 80002c4c <argint>
  if(argfd(0, 0, &f) < 0)
    80005334:	fe840613          	add	a2,s0,-24
    80005338:	4581                	li	a1,0
    8000533a:	4501                	li	a0,0
    8000533c:	00000097          	auipc	ra,0x0
    80005340:	d06080e7          	jalr	-762(ra) # 80005042 <argfd>
    80005344:	87aa                	mv	a5,a0
    return -1;
    80005346:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005348:	0007cc63          	bltz	a5,80005360 <sys_write+0x50>
  return filewrite(f, p, n);
    8000534c:	fe442603          	lw	a2,-28(s0)
    80005350:	fd843583          	ld	a1,-40(s0)
    80005354:	fe843503          	ld	a0,-24(s0)
    80005358:	fffff097          	auipc	ra,0xfffff
    8000535c:	4ca080e7          	jalr	1226(ra) # 80004822 <filewrite>
}
    80005360:	70a2                	ld	ra,40(sp)
    80005362:	7402                	ld	s0,32(sp)
    80005364:	6145                	add	sp,sp,48
    80005366:	8082                	ret

0000000080005368 <sys_close>:
{
    80005368:	1101                	add	sp,sp,-32
    8000536a:	ec06                	sd	ra,24(sp)
    8000536c:	e822                	sd	s0,16(sp)
    8000536e:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005370:	fe040613          	add	a2,s0,-32
    80005374:	fec40593          	add	a1,s0,-20
    80005378:	4501                	li	a0,0
    8000537a:	00000097          	auipc	ra,0x0
    8000537e:	cc8080e7          	jalr	-824(ra) # 80005042 <argfd>
    return -1;
    80005382:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005384:	02054463          	bltz	a0,800053ac <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005388:	ffffc097          	auipc	ra,0xffffc
    8000538c:	782080e7          	jalr	1922(ra) # 80001b0a <myproc>
    80005390:	fec42783          	lw	a5,-20(s0)
    80005394:	07f1                	add	a5,a5,28
    80005396:	078e                	sll	a5,a5,0x3
    80005398:	953e                	add	a0,a0,a5
    8000539a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000539e:	fe043503          	ld	a0,-32(s0)
    800053a2:	fffff097          	auipc	ra,0xfffff
    800053a6:	284080e7          	jalr	644(ra) # 80004626 <fileclose>
  return 0;
    800053aa:	4781                	li	a5,0
}
    800053ac:	853e                	mv	a0,a5
    800053ae:	60e2                	ld	ra,24(sp)
    800053b0:	6442                	ld	s0,16(sp)
    800053b2:	6105                	add	sp,sp,32
    800053b4:	8082                	ret

00000000800053b6 <sys_fstat>:
{
    800053b6:	1101                	add	sp,sp,-32
    800053b8:	ec06                	sd	ra,24(sp)
    800053ba:	e822                	sd	s0,16(sp)
    800053bc:	1000                	add	s0,sp,32
  argaddr(1, &st);
    800053be:	fe040593          	add	a1,s0,-32
    800053c2:	4505                	li	a0,1
    800053c4:	ffffe097          	auipc	ra,0xffffe
    800053c8:	8a8080e7          	jalr	-1880(ra) # 80002c6c <argaddr>
  if(argfd(0, 0, &f) < 0)
    800053cc:	fe840613          	add	a2,s0,-24
    800053d0:	4581                	li	a1,0
    800053d2:	4501                	li	a0,0
    800053d4:	00000097          	auipc	ra,0x0
    800053d8:	c6e080e7          	jalr	-914(ra) # 80005042 <argfd>
    800053dc:	87aa                	mv	a5,a0
    return -1;
    800053de:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053e0:	0007ca63          	bltz	a5,800053f4 <sys_fstat+0x3e>
  return filestat(f, st);
    800053e4:	fe043583          	ld	a1,-32(s0)
    800053e8:	fe843503          	ld	a0,-24(s0)
    800053ec:	fffff097          	auipc	ra,0xfffff
    800053f0:	302080e7          	jalr	770(ra) # 800046ee <filestat>
}
    800053f4:	60e2                	ld	ra,24(sp)
    800053f6:	6442                	ld	s0,16(sp)
    800053f8:	6105                	add	sp,sp,32
    800053fa:	8082                	ret

00000000800053fc <sys_link>:
{
    800053fc:	7169                	add	sp,sp,-304
    800053fe:	f606                	sd	ra,296(sp)
    80005400:	f222                	sd	s0,288(sp)
    80005402:	ee26                	sd	s1,280(sp)
    80005404:	ea4a                	sd	s2,272(sp)
    80005406:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005408:	08000613          	li	a2,128
    8000540c:	ed040593          	add	a1,s0,-304
    80005410:	4501                	li	a0,0
    80005412:	ffffe097          	auipc	ra,0xffffe
    80005416:	87a080e7          	jalr	-1926(ra) # 80002c8c <argstr>
    return -1;
    8000541a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000541c:	10054e63          	bltz	a0,80005538 <sys_link+0x13c>
    80005420:	08000613          	li	a2,128
    80005424:	f5040593          	add	a1,s0,-176
    80005428:	4505                	li	a0,1
    8000542a:	ffffe097          	auipc	ra,0xffffe
    8000542e:	862080e7          	jalr	-1950(ra) # 80002c8c <argstr>
    return -1;
    80005432:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005434:	10054263          	bltz	a0,80005538 <sys_link+0x13c>
  begin_op();
    80005438:	fffff097          	auipc	ra,0xfffff
    8000543c:	d2a080e7          	jalr	-726(ra) # 80004162 <begin_op>
  if((ip = namei(old)) == 0){
    80005440:	ed040513          	add	a0,s0,-304
    80005444:	fffff097          	auipc	ra,0xfffff
    80005448:	b1e080e7          	jalr	-1250(ra) # 80003f62 <namei>
    8000544c:	84aa                	mv	s1,a0
    8000544e:	c551                	beqz	a0,800054da <sys_link+0xde>
  ilock(ip);
    80005450:	ffffe097          	auipc	ra,0xffffe
    80005454:	36c080e7          	jalr	876(ra) # 800037bc <ilock>
  if(ip->type == T_DIR){
    80005458:	04449703          	lh	a4,68(s1)
    8000545c:	4785                	li	a5,1
    8000545e:	08f70463          	beq	a4,a5,800054e6 <sys_link+0xea>
  ip->nlink++;
    80005462:	04a4d783          	lhu	a5,74(s1)
    80005466:	2785                	addw	a5,a5,1
    80005468:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000546c:	8526                	mv	a0,s1
    8000546e:	ffffe097          	auipc	ra,0xffffe
    80005472:	282080e7          	jalr	642(ra) # 800036f0 <iupdate>
  iunlock(ip);
    80005476:	8526                	mv	a0,s1
    80005478:	ffffe097          	auipc	ra,0xffffe
    8000547c:	406080e7          	jalr	1030(ra) # 8000387e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005480:	fd040593          	add	a1,s0,-48
    80005484:	f5040513          	add	a0,s0,-176
    80005488:	fffff097          	auipc	ra,0xfffff
    8000548c:	af8080e7          	jalr	-1288(ra) # 80003f80 <nameiparent>
    80005490:	892a                	mv	s2,a0
    80005492:	c935                	beqz	a0,80005506 <sys_link+0x10a>
  ilock(dp);
    80005494:	ffffe097          	auipc	ra,0xffffe
    80005498:	328080e7          	jalr	808(ra) # 800037bc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000549c:	00092703          	lw	a4,0(s2)
    800054a0:	409c                	lw	a5,0(s1)
    800054a2:	04f71d63          	bne	a4,a5,800054fc <sys_link+0x100>
    800054a6:	40d0                	lw	a2,4(s1)
    800054a8:	fd040593          	add	a1,s0,-48
    800054ac:	854a                	mv	a0,s2
    800054ae:	fffff097          	auipc	ra,0xfffff
    800054b2:	a02080e7          	jalr	-1534(ra) # 80003eb0 <dirlink>
    800054b6:	04054363          	bltz	a0,800054fc <sys_link+0x100>
  iunlockput(dp);
    800054ba:	854a                	mv	a0,s2
    800054bc:	ffffe097          	auipc	ra,0xffffe
    800054c0:	562080e7          	jalr	1378(ra) # 80003a1e <iunlockput>
  iput(ip);
    800054c4:	8526                	mv	a0,s1
    800054c6:	ffffe097          	auipc	ra,0xffffe
    800054ca:	4b0080e7          	jalr	1200(ra) # 80003976 <iput>
  end_op();
    800054ce:	fffff097          	auipc	ra,0xfffff
    800054d2:	d0e080e7          	jalr	-754(ra) # 800041dc <end_op>
  return 0;
    800054d6:	4781                	li	a5,0
    800054d8:	a085                	j	80005538 <sys_link+0x13c>
    end_op();
    800054da:	fffff097          	auipc	ra,0xfffff
    800054de:	d02080e7          	jalr	-766(ra) # 800041dc <end_op>
    return -1;
    800054e2:	57fd                	li	a5,-1
    800054e4:	a891                	j	80005538 <sys_link+0x13c>
    iunlockput(ip);
    800054e6:	8526                	mv	a0,s1
    800054e8:	ffffe097          	auipc	ra,0xffffe
    800054ec:	536080e7          	jalr	1334(ra) # 80003a1e <iunlockput>
    end_op();
    800054f0:	fffff097          	auipc	ra,0xfffff
    800054f4:	cec080e7          	jalr	-788(ra) # 800041dc <end_op>
    return -1;
    800054f8:	57fd                	li	a5,-1
    800054fa:	a83d                	j	80005538 <sys_link+0x13c>
    iunlockput(dp);
    800054fc:	854a                	mv	a0,s2
    800054fe:	ffffe097          	auipc	ra,0xffffe
    80005502:	520080e7          	jalr	1312(ra) # 80003a1e <iunlockput>
  ilock(ip);
    80005506:	8526                	mv	a0,s1
    80005508:	ffffe097          	auipc	ra,0xffffe
    8000550c:	2b4080e7          	jalr	692(ra) # 800037bc <ilock>
  ip->nlink--;
    80005510:	04a4d783          	lhu	a5,74(s1)
    80005514:	37fd                	addw	a5,a5,-1
    80005516:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000551a:	8526                	mv	a0,s1
    8000551c:	ffffe097          	auipc	ra,0xffffe
    80005520:	1d4080e7          	jalr	468(ra) # 800036f0 <iupdate>
  iunlockput(ip);
    80005524:	8526                	mv	a0,s1
    80005526:	ffffe097          	auipc	ra,0xffffe
    8000552a:	4f8080e7          	jalr	1272(ra) # 80003a1e <iunlockput>
  end_op();
    8000552e:	fffff097          	auipc	ra,0xfffff
    80005532:	cae080e7          	jalr	-850(ra) # 800041dc <end_op>
  return -1;
    80005536:	57fd                	li	a5,-1
}
    80005538:	853e                	mv	a0,a5
    8000553a:	70b2                	ld	ra,296(sp)
    8000553c:	7412                	ld	s0,288(sp)
    8000553e:	64f2                	ld	s1,280(sp)
    80005540:	6952                	ld	s2,272(sp)
    80005542:	6155                	add	sp,sp,304
    80005544:	8082                	ret

0000000080005546 <sys_unlink>:
{
    80005546:	7151                	add	sp,sp,-240
    80005548:	f586                	sd	ra,232(sp)
    8000554a:	f1a2                	sd	s0,224(sp)
    8000554c:	eda6                	sd	s1,216(sp)
    8000554e:	e9ca                	sd	s2,208(sp)
    80005550:	e5ce                	sd	s3,200(sp)
    80005552:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005554:	08000613          	li	a2,128
    80005558:	f3040593          	add	a1,s0,-208
    8000555c:	4501                	li	a0,0
    8000555e:	ffffd097          	auipc	ra,0xffffd
    80005562:	72e080e7          	jalr	1838(ra) # 80002c8c <argstr>
    80005566:	18054163          	bltz	a0,800056e8 <sys_unlink+0x1a2>
  begin_op();
    8000556a:	fffff097          	auipc	ra,0xfffff
    8000556e:	bf8080e7          	jalr	-1032(ra) # 80004162 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005572:	fb040593          	add	a1,s0,-80
    80005576:	f3040513          	add	a0,s0,-208
    8000557a:	fffff097          	auipc	ra,0xfffff
    8000557e:	a06080e7          	jalr	-1530(ra) # 80003f80 <nameiparent>
    80005582:	84aa                	mv	s1,a0
    80005584:	c979                	beqz	a0,8000565a <sys_unlink+0x114>
  ilock(dp);
    80005586:	ffffe097          	auipc	ra,0xffffe
    8000558a:	236080e7          	jalr	566(ra) # 800037bc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000558e:	00003597          	auipc	a1,0x3
    80005592:	1a258593          	add	a1,a1,418 # 80008730 <syscalls+0x2a0>
    80005596:	fb040513          	add	a0,s0,-80
    8000559a:	ffffe097          	auipc	ra,0xffffe
    8000559e:	6ec080e7          	jalr	1772(ra) # 80003c86 <namecmp>
    800055a2:	14050a63          	beqz	a0,800056f6 <sys_unlink+0x1b0>
    800055a6:	00003597          	auipc	a1,0x3
    800055aa:	19258593          	add	a1,a1,402 # 80008738 <syscalls+0x2a8>
    800055ae:	fb040513          	add	a0,s0,-80
    800055b2:	ffffe097          	auipc	ra,0xffffe
    800055b6:	6d4080e7          	jalr	1748(ra) # 80003c86 <namecmp>
    800055ba:	12050e63          	beqz	a0,800056f6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800055be:	f2c40613          	add	a2,s0,-212
    800055c2:	fb040593          	add	a1,s0,-80
    800055c6:	8526                	mv	a0,s1
    800055c8:	ffffe097          	auipc	ra,0xffffe
    800055cc:	6d8080e7          	jalr	1752(ra) # 80003ca0 <dirlookup>
    800055d0:	892a                	mv	s2,a0
    800055d2:	12050263          	beqz	a0,800056f6 <sys_unlink+0x1b0>
  ilock(ip);
    800055d6:	ffffe097          	auipc	ra,0xffffe
    800055da:	1e6080e7          	jalr	486(ra) # 800037bc <ilock>
  if(ip->nlink < 1)
    800055de:	04a91783          	lh	a5,74(s2)
    800055e2:	08f05263          	blez	a5,80005666 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055e6:	04491703          	lh	a4,68(s2)
    800055ea:	4785                	li	a5,1
    800055ec:	08f70563          	beq	a4,a5,80005676 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055f0:	4641                	li	a2,16
    800055f2:	4581                	li	a1,0
    800055f4:	fc040513          	add	a0,s0,-64
    800055f8:	ffffb097          	auipc	ra,0xffffb
    800055fc:	7d0080e7          	jalr	2000(ra) # 80000dc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005600:	4741                	li	a4,16
    80005602:	f2c42683          	lw	a3,-212(s0)
    80005606:	fc040613          	add	a2,s0,-64
    8000560a:	4581                	li	a1,0
    8000560c:	8526                	mv	a0,s1
    8000560e:	ffffe097          	auipc	ra,0xffffe
    80005612:	55a080e7          	jalr	1370(ra) # 80003b68 <writei>
    80005616:	47c1                	li	a5,16
    80005618:	0af51563          	bne	a0,a5,800056c2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000561c:	04491703          	lh	a4,68(s2)
    80005620:	4785                	li	a5,1
    80005622:	0af70863          	beq	a4,a5,800056d2 <sys_unlink+0x18c>
  iunlockput(dp);
    80005626:	8526                	mv	a0,s1
    80005628:	ffffe097          	auipc	ra,0xffffe
    8000562c:	3f6080e7          	jalr	1014(ra) # 80003a1e <iunlockput>
  ip->nlink--;
    80005630:	04a95783          	lhu	a5,74(s2)
    80005634:	37fd                	addw	a5,a5,-1
    80005636:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000563a:	854a                	mv	a0,s2
    8000563c:	ffffe097          	auipc	ra,0xffffe
    80005640:	0b4080e7          	jalr	180(ra) # 800036f0 <iupdate>
  iunlockput(ip);
    80005644:	854a                	mv	a0,s2
    80005646:	ffffe097          	auipc	ra,0xffffe
    8000564a:	3d8080e7          	jalr	984(ra) # 80003a1e <iunlockput>
  end_op();
    8000564e:	fffff097          	auipc	ra,0xfffff
    80005652:	b8e080e7          	jalr	-1138(ra) # 800041dc <end_op>
  return 0;
    80005656:	4501                	li	a0,0
    80005658:	a84d                	j	8000570a <sys_unlink+0x1c4>
    end_op();
    8000565a:	fffff097          	auipc	ra,0xfffff
    8000565e:	b82080e7          	jalr	-1150(ra) # 800041dc <end_op>
    return -1;
    80005662:	557d                	li	a0,-1
    80005664:	a05d                	j	8000570a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005666:	00003517          	auipc	a0,0x3
    8000566a:	0da50513          	add	a0,a0,218 # 80008740 <syscalls+0x2b0>
    8000566e:	ffffb097          	auipc	ra,0xffffb
    80005672:	1a0080e7          	jalr	416(ra) # 8000080e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005676:	04c92703          	lw	a4,76(s2)
    8000567a:	02000793          	li	a5,32
    8000567e:	f6e7f9e3          	bgeu	a5,a4,800055f0 <sys_unlink+0xaa>
    80005682:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005686:	4741                	li	a4,16
    80005688:	86ce                	mv	a3,s3
    8000568a:	f1840613          	add	a2,s0,-232
    8000568e:	4581                	li	a1,0
    80005690:	854a                	mv	a0,s2
    80005692:	ffffe097          	auipc	ra,0xffffe
    80005696:	3de080e7          	jalr	990(ra) # 80003a70 <readi>
    8000569a:	47c1                	li	a5,16
    8000569c:	00f51b63          	bne	a0,a5,800056b2 <sys_unlink+0x16c>
    if(de.inum != 0)
    800056a0:	f1845783          	lhu	a5,-232(s0)
    800056a4:	e7a1                	bnez	a5,800056ec <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056a6:	29c1                	addw	s3,s3,16
    800056a8:	04c92783          	lw	a5,76(s2)
    800056ac:	fcf9ede3          	bltu	s3,a5,80005686 <sys_unlink+0x140>
    800056b0:	b781                	j	800055f0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800056b2:	00003517          	auipc	a0,0x3
    800056b6:	0a650513          	add	a0,a0,166 # 80008758 <syscalls+0x2c8>
    800056ba:	ffffb097          	auipc	ra,0xffffb
    800056be:	154080e7          	jalr	340(ra) # 8000080e <panic>
    panic("unlink: writei");
    800056c2:	00003517          	auipc	a0,0x3
    800056c6:	0ae50513          	add	a0,a0,174 # 80008770 <syscalls+0x2e0>
    800056ca:	ffffb097          	auipc	ra,0xffffb
    800056ce:	144080e7          	jalr	324(ra) # 8000080e <panic>
    dp->nlink--;
    800056d2:	04a4d783          	lhu	a5,74(s1)
    800056d6:	37fd                	addw	a5,a5,-1
    800056d8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800056dc:	8526                	mv	a0,s1
    800056de:	ffffe097          	auipc	ra,0xffffe
    800056e2:	012080e7          	jalr	18(ra) # 800036f0 <iupdate>
    800056e6:	b781                	j	80005626 <sys_unlink+0xe0>
    return -1;
    800056e8:	557d                	li	a0,-1
    800056ea:	a005                	j	8000570a <sys_unlink+0x1c4>
    iunlockput(ip);
    800056ec:	854a                	mv	a0,s2
    800056ee:	ffffe097          	auipc	ra,0xffffe
    800056f2:	330080e7          	jalr	816(ra) # 80003a1e <iunlockput>
  iunlockput(dp);
    800056f6:	8526                	mv	a0,s1
    800056f8:	ffffe097          	auipc	ra,0xffffe
    800056fc:	326080e7          	jalr	806(ra) # 80003a1e <iunlockput>
  end_op();
    80005700:	fffff097          	auipc	ra,0xfffff
    80005704:	adc080e7          	jalr	-1316(ra) # 800041dc <end_op>
  return -1;
    80005708:	557d                	li	a0,-1
}
    8000570a:	70ae                	ld	ra,232(sp)
    8000570c:	740e                	ld	s0,224(sp)
    8000570e:	64ee                	ld	s1,216(sp)
    80005710:	694e                	ld	s2,208(sp)
    80005712:	69ae                	ld	s3,200(sp)
    80005714:	616d                	add	sp,sp,240
    80005716:	8082                	ret

0000000080005718 <sys_open>:

uint64
sys_open(void)
{
    80005718:	7131                	add	sp,sp,-192
    8000571a:	fd06                	sd	ra,184(sp)
    8000571c:	f922                	sd	s0,176(sp)
    8000571e:	f526                	sd	s1,168(sp)
    80005720:	f14a                	sd	s2,160(sp)
    80005722:	ed4e                	sd	s3,152(sp)
    80005724:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005726:	f4c40593          	add	a1,s0,-180
    8000572a:	4505                	li	a0,1
    8000572c:	ffffd097          	auipc	ra,0xffffd
    80005730:	520080e7          	jalr	1312(ra) # 80002c4c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005734:	08000613          	li	a2,128
    80005738:	f5040593          	add	a1,s0,-176
    8000573c:	4501                	li	a0,0
    8000573e:	ffffd097          	auipc	ra,0xffffd
    80005742:	54e080e7          	jalr	1358(ra) # 80002c8c <argstr>
    80005746:	87aa                	mv	a5,a0
    return -1;
    80005748:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000574a:	0a07c863          	bltz	a5,800057fa <sys_open+0xe2>

  begin_op();
    8000574e:	fffff097          	auipc	ra,0xfffff
    80005752:	a14080e7          	jalr	-1516(ra) # 80004162 <begin_op>

  if(omode & O_CREATE){
    80005756:	f4c42783          	lw	a5,-180(s0)
    8000575a:	2007f793          	and	a5,a5,512
    8000575e:	cbdd                	beqz	a5,80005814 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80005760:	4681                	li	a3,0
    80005762:	4601                	li	a2,0
    80005764:	4589                	li	a1,2
    80005766:	f5040513          	add	a0,s0,-176
    8000576a:	00000097          	auipc	ra,0x0
    8000576e:	97a080e7          	jalr	-1670(ra) # 800050e4 <create>
    80005772:	84aa                	mv	s1,a0
    if(ip == 0){
    80005774:	c951                	beqz	a0,80005808 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005776:	04449703          	lh	a4,68(s1)
    8000577a:	478d                	li	a5,3
    8000577c:	00f71763          	bne	a4,a5,8000578a <sys_open+0x72>
    80005780:	0464d703          	lhu	a4,70(s1)
    80005784:	47a5                	li	a5,9
    80005786:	0ce7ec63          	bltu	a5,a4,8000585e <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000578a:	fffff097          	auipc	ra,0xfffff
    8000578e:	de0080e7          	jalr	-544(ra) # 8000456a <filealloc>
    80005792:	892a                	mv	s2,a0
    80005794:	c56d                	beqz	a0,8000587e <sys_open+0x166>
    80005796:	00000097          	auipc	ra,0x0
    8000579a:	90c080e7          	jalr	-1780(ra) # 800050a2 <fdalloc>
    8000579e:	89aa                	mv	s3,a0
    800057a0:	0c054a63          	bltz	a0,80005874 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800057a4:	04449703          	lh	a4,68(s1)
    800057a8:	478d                	li	a5,3
    800057aa:	0ef70563          	beq	a4,a5,80005894 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800057ae:	4789                	li	a5,2
    800057b0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800057b4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800057b8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800057bc:	f4c42783          	lw	a5,-180(s0)
    800057c0:	0017c713          	xor	a4,a5,1
    800057c4:	8b05                	and	a4,a4,1
    800057c6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800057ca:	0037f713          	and	a4,a5,3
    800057ce:	00e03733          	snez	a4,a4
    800057d2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057d6:	4007f793          	and	a5,a5,1024
    800057da:	c791                	beqz	a5,800057e6 <sys_open+0xce>
    800057dc:	04449703          	lh	a4,68(s1)
    800057e0:	4789                	li	a5,2
    800057e2:	0cf70063          	beq	a4,a5,800058a2 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    800057e6:	8526                	mv	a0,s1
    800057e8:	ffffe097          	auipc	ra,0xffffe
    800057ec:	096080e7          	jalr	150(ra) # 8000387e <iunlock>
  end_op();
    800057f0:	fffff097          	auipc	ra,0xfffff
    800057f4:	9ec080e7          	jalr	-1556(ra) # 800041dc <end_op>

  return fd;
    800057f8:	854e                	mv	a0,s3
}
    800057fa:	70ea                	ld	ra,184(sp)
    800057fc:	744a                	ld	s0,176(sp)
    800057fe:	74aa                	ld	s1,168(sp)
    80005800:	790a                	ld	s2,160(sp)
    80005802:	69ea                	ld	s3,152(sp)
    80005804:	6129                	add	sp,sp,192
    80005806:	8082                	ret
      end_op();
    80005808:	fffff097          	auipc	ra,0xfffff
    8000580c:	9d4080e7          	jalr	-1580(ra) # 800041dc <end_op>
      return -1;
    80005810:	557d                	li	a0,-1
    80005812:	b7e5                	j	800057fa <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80005814:	f5040513          	add	a0,s0,-176
    80005818:	ffffe097          	auipc	ra,0xffffe
    8000581c:	74a080e7          	jalr	1866(ra) # 80003f62 <namei>
    80005820:	84aa                	mv	s1,a0
    80005822:	c905                	beqz	a0,80005852 <sys_open+0x13a>
    ilock(ip);
    80005824:	ffffe097          	auipc	ra,0xffffe
    80005828:	f98080e7          	jalr	-104(ra) # 800037bc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000582c:	04449703          	lh	a4,68(s1)
    80005830:	4785                	li	a5,1
    80005832:	f4f712e3          	bne	a4,a5,80005776 <sys_open+0x5e>
    80005836:	f4c42783          	lw	a5,-180(s0)
    8000583a:	dba1                	beqz	a5,8000578a <sys_open+0x72>
      iunlockput(ip);
    8000583c:	8526                	mv	a0,s1
    8000583e:	ffffe097          	auipc	ra,0xffffe
    80005842:	1e0080e7          	jalr	480(ra) # 80003a1e <iunlockput>
      end_op();
    80005846:	fffff097          	auipc	ra,0xfffff
    8000584a:	996080e7          	jalr	-1642(ra) # 800041dc <end_op>
      return -1;
    8000584e:	557d                	li	a0,-1
    80005850:	b76d                	j	800057fa <sys_open+0xe2>
      end_op();
    80005852:	fffff097          	auipc	ra,0xfffff
    80005856:	98a080e7          	jalr	-1654(ra) # 800041dc <end_op>
      return -1;
    8000585a:	557d                	li	a0,-1
    8000585c:	bf79                	j	800057fa <sys_open+0xe2>
    iunlockput(ip);
    8000585e:	8526                	mv	a0,s1
    80005860:	ffffe097          	auipc	ra,0xffffe
    80005864:	1be080e7          	jalr	446(ra) # 80003a1e <iunlockput>
    end_op();
    80005868:	fffff097          	auipc	ra,0xfffff
    8000586c:	974080e7          	jalr	-1676(ra) # 800041dc <end_op>
    return -1;
    80005870:	557d                	li	a0,-1
    80005872:	b761                	j	800057fa <sys_open+0xe2>
      fileclose(f);
    80005874:	854a                	mv	a0,s2
    80005876:	fffff097          	auipc	ra,0xfffff
    8000587a:	db0080e7          	jalr	-592(ra) # 80004626 <fileclose>
    iunlockput(ip);
    8000587e:	8526                	mv	a0,s1
    80005880:	ffffe097          	auipc	ra,0xffffe
    80005884:	19e080e7          	jalr	414(ra) # 80003a1e <iunlockput>
    end_op();
    80005888:	fffff097          	auipc	ra,0xfffff
    8000588c:	954080e7          	jalr	-1708(ra) # 800041dc <end_op>
    return -1;
    80005890:	557d                	li	a0,-1
    80005892:	b7a5                	j	800057fa <sys_open+0xe2>
    f->type = FD_DEVICE;
    80005894:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005898:	04649783          	lh	a5,70(s1)
    8000589c:	02f91223          	sh	a5,36(s2)
    800058a0:	bf21                	j	800057b8 <sys_open+0xa0>
    itrunc(ip);
    800058a2:	8526                	mv	a0,s1
    800058a4:	ffffe097          	auipc	ra,0xffffe
    800058a8:	026080e7          	jalr	38(ra) # 800038ca <itrunc>
    800058ac:	bf2d                	j	800057e6 <sys_open+0xce>

00000000800058ae <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800058ae:	7175                	add	sp,sp,-144
    800058b0:	e506                	sd	ra,136(sp)
    800058b2:	e122                	sd	s0,128(sp)
    800058b4:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800058b6:	fffff097          	auipc	ra,0xfffff
    800058ba:	8ac080e7          	jalr	-1876(ra) # 80004162 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800058be:	08000613          	li	a2,128
    800058c2:	f7040593          	add	a1,s0,-144
    800058c6:	4501                	li	a0,0
    800058c8:	ffffd097          	auipc	ra,0xffffd
    800058cc:	3c4080e7          	jalr	964(ra) # 80002c8c <argstr>
    800058d0:	02054963          	bltz	a0,80005902 <sys_mkdir+0x54>
    800058d4:	4681                	li	a3,0
    800058d6:	4601                	li	a2,0
    800058d8:	4585                	li	a1,1
    800058da:	f7040513          	add	a0,s0,-144
    800058de:	00000097          	auipc	ra,0x0
    800058e2:	806080e7          	jalr	-2042(ra) # 800050e4 <create>
    800058e6:	cd11                	beqz	a0,80005902 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058e8:	ffffe097          	auipc	ra,0xffffe
    800058ec:	136080e7          	jalr	310(ra) # 80003a1e <iunlockput>
  end_op();
    800058f0:	fffff097          	auipc	ra,0xfffff
    800058f4:	8ec080e7          	jalr	-1812(ra) # 800041dc <end_op>
  return 0;
    800058f8:	4501                	li	a0,0
}
    800058fa:	60aa                	ld	ra,136(sp)
    800058fc:	640a                	ld	s0,128(sp)
    800058fe:	6149                	add	sp,sp,144
    80005900:	8082                	ret
    end_op();
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	8da080e7          	jalr	-1830(ra) # 800041dc <end_op>
    return -1;
    8000590a:	557d                	li	a0,-1
    8000590c:	b7fd                	j	800058fa <sys_mkdir+0x4c>

000000008000590e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000590e:	7135                	add	sp,sp,-160
    80005910:	ed06                	sd	ra,152(sp)
    80005912:	e922                	sd	s0,144(sp)
    80005914:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005916:	fffff097          	auipc	ra,0xfffff
    8000591a:	84c080e7          	jalr	-1972(ra) # 80004162 <begin_op>
  argint(1, &major);
    8000591e:	f6c40593          	add	a1,s0,-148
    80005922:	4505                	li	a0,1
    80005924:	ffffd097          	auipc	ra,0xffffd
    80005928:	328080e7          	jalr	808(ra) # 80002c4c <argint>
  argint(2, &minor);
    8000592c:	f6840593          	add	a1,s0,-152
    80005930:	4509                	li	a0,2
    80005932:	ffffd097          	auipc	ra,0xffffd
    80005936:	31a080e7          	jalr	794(ra) # 80002c4c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000593a:	08000613          	li	a2,128
    8000593e:	f7040593          	add	a1,s0,-144
    80005942:	4501                	li	a0,0
    80005944:	ffffd097          	auipc	ra,0xffffd
    80005948:	348080e7          	jalr	840(ra) # 80002c8c <argstr>
    8000594c:	02054b63          	bltz	a0,80005982 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005950:	f6841683          	lh	a3,-152(s0)
    80005954:	f6c41603          	lh	a2,-148(s0)
    80005958:	458d                	li	a1,3
    8000595a:	f7040513          	add	a0,s0,-144
    8000595e:	fffff097          	auipc	ra,0xfffff
    80005962:	786080e7          	jalr	1926(ra) # 800050e4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005966:	cd11                	beqz	a0,80005982 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005968:	ffffe097          	auipc	ra,0xffffe
    8000596c:	0b6080e7          	jalr	182(ra) # 80003a1e <iunlockput>
  end_op();
    80005970:	fffff097          	auipc	ra,0xfffff
    80005974:	86c080e7          	jalr	-1940(ra) # 800041dc <end_op>
  return 0;
    80005978:	4501                	li	a0,0
}
    8000597a:	60ea                	ld	ra,152(sp)
    8000597c:	644a                	ld	s0,144(sp)
    8000597e:	610d                	add	sp,sp,160
    80005980:	8082                	ret
    end_op();
    80005982:	fffff097          	auipc	ra,0xfffff
    80005986:	85a080e7          	jalr	-1958(ra) # 800041dc <end_op>
    return -1;
    8000598a:	557d                	li	a0,-1
    8000598c:	b7fd                	j	8000597a <sys_mknod+0x6c>

000000008000598e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000598e:	7135                	add	sp,sp,-160
    80005990:	ed06                	sd	ra,152(sp)
    80005992:	e922                	sd	s0,144(sp)
    80005994:	e526                	sd	s1,136(sp)
    80005996:	e14a                	sd	s2,128(sp)
    80005998:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000599a:	ffffc097          	auipc	ra,0xffffc
    8000599e:	170080e7          	jalr	368(ra) # 80001b0a <myproc>
    800059a2:	892a                	mv	s2,a0
  
  begin_op();
    800059a4:	ffffe097          	auipc	ra,0xffffe
    800059a8:	7be080e7          	jalr	1982(ra) # 80004162 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800059ac:	08000613          	li	a2,128
    800059b0:	f6040593          	add	a1,s0,-160
    800059b4:	4501                	li	a0,0
    800059b6:	ffffd097          	auipc	ra,0xffffd
    800059ba:	2d6080e7          	jalr	726(ra) # 80002c8c <argstr>
    800059be:	04054b63          	bltz	a0,80005a14 <sys_chdir+0x86>
    800059c2:	f6040513          	add	a0,s0,-160
    800059c6:	ffffe097          	auipc	ra,0xffffe
    800059ca:	59c080e7          	jalr	1436(ra) # 80003f62 <namei>
    800059ce:	84aa                	mv	s1,a0
    800059d0:	c131                	beqz	a0,80005a14 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059d2:	ffffe097          	auipc	ra,0xffffe
    800059d6:	dea080e7          	jalr	-534(ra) # 800037bc <ilock>
  if(ip->type != T_DIR){
    800059da:	04449703          	lh	a4,68(s1)
    800059de:	4785                	li	a5,1
    800059e0:	04f71063          	bne	a4,a5,80005a20 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059e4:	8526                	mv	a0,s1
    800059e6:	ffffe097          	auipc	ra,0xffffe
    800059ea:	e98080e7          	jalr	-360(ra) # 8000387e <iunlock>
  iput(p->cwd);
    800059ee:	16093503          	ld	a0,352(s2)
    800059f2:	ffffe097          	auipc	ra,0xffffe
    800059f6:	f84080e7          	jalr	-124(ra) # 80003976 <iput>
  end_op();
    800059fa:	ffffe097          	auipc	ra,0xffffe
    800059fe:	7e2080e7          	jalr	2018(ra) # 800041dc <end_op>
  p->cwd = ip;
    80005a02:	16993023          	sd	s1,352(s2)
  return 0;
    80005a06:	4501                	li	a0,0
}
    80005a08:	60ea                	ld	ra,152(sp)
    80005a0a:	644a                	ld	s0,144(sp)
    80005a0c:	64aa                	ld	s1,136(sp)
    80005a0e:	690a                	ld	s2,128(sp)
    80005a10:	610d                	add	sp,sp,160
    80005a12:	8082                	ret
    end_op();
    80005a14:	ffffe097          	auipc	ra,0xffffe
    80005a18:	7c8080e7          	jalr	1992(ra) # 800041dc <end_op>
    return -1;
    80005a1c:	557d                	li	a0,-1
    80005a1e:	b7ed                	j	80005a08 <sys_chdir+0x7a>
    iunlockput(ip);
    80005a20:	8526                	mv	a0,s1
    80005a22:	ffffe097          	auipc	ra,0xffffe
    80005a26:	ffc080e7          	jalr	-4(ra) # 80003a1e <iunlockput>
    end_op();
    80005a2a:	ffffe097          	auipc	ra,0xffffe
    80005a2e:	7b2080e7          	jalr	1970(ra) # 800041dc <end_op>
    return -1;
    80005a32:	557d                	li	a0,-1
    80005a34:	bfd1                	j	80005a08 <sys_chdir+0x7a>

0000000080005a36 <sys_exec>:

uint64
sys_exec(void)
{
    80005a36:	7121                	add	sp,sp,-448
    80005a38:	ff06                	sd	ra,440(sp)
    80005a3a:	fb22                	sd	s0,432(sp)
    80005a3c:	f726                	sd	s1,424(sp)
    80005a3e:	f34a                	sd	s2,416(sp)
    80005a40:	ef4e                	sd	s3,408(sp)
    80005a42:	eb52                	sd	s4,400(sp)
    80005a44:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005a46:	e4840593          	add	a1,s0,-440
    80005a4a:	4505                	li	a0,1
    80005a4c:	ffffd097          	auipc	ra,0xffffd
    80005a50:	220080e7          	jalr	544(ra) # 80002c6c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005a54:	08000613          	li	a2,128
    80005a58:	f5040593          	add	a1,s0,-176
    80005a5c:	4501                	li	a0,0
    80005a5e:	ffffd097          	auipc	ra,0xffffd
    80005a62:	22e080e7          	jalr	558(ra) # 80002c8c <argstr>
    80005a66:	87aa                	mv	a5,a0
    return -1;
    80005a68:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005a6a:	0c07c263          	bltz	a5,80005b2e <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005a6e:	10000613          	li	a2,256
    80005a72:	4581                	li	a1,0
    80005a74:	e5040513          	add	a0,s0,-432
    80005a78:	ffffb097          	auipc	ra,0xffffb
    80005a7c:	350080e7          	jalr	848(ra) # 80000dc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a80:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005a84:	89a6                	mv	s3,s1
    80005a86:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a88:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a8c:	00391513          	sll	a0,s2,0x3
    80005a90:	e4040593          	add	a1,s0,-448
    80005a94:	e4843783          	ld	a5,-440(s0)
    80005a98:	953e                	add	a0,a0,a5
    80005a9a:	ffffd097          	auipc	ra,0xffffd
    80005a9e:	114080e7          	jalr	276(ra) # 80002bae <fetchaddr>
    80005aa2:	02054a63          	bltz	a0,80005ad6 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005aa6:	e4043783          	ld	a5,-448(s0)
    80005aaa:	c3b9                	beqz	a5,80005af0 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005aac:	ffffb097          	auipc	ra,0xffffb
    80005ab0:	130080e7          	jalr	304(ra) # 80000bdc <kalloc>
    80005ab4:	85aa                	mv	a1,a0
    80005ab6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005aba:	cd11                	beqz	a0,80005ad6 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005abc:	6605                	lui	a2,0x1
    80005abe:	e4043503          	ld	a0,-448(s0)
    80005ac2:	ffffd097          	auipc	ra,0xffffd
    80005ac6:	13e080e7          	jalr	318(ra) # 80002c00 <fetchstr>
    80005aca:	00054663          	bltz	a0,80005ad6 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005ace:	0905                	add	s2,s2,1
    80005ad0:	09a1                	add	s3,s3,8
    80005ad2:	fb491de3          	bne	s2,s4,80005a8c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ad6:	f5040913          	add	s2,s0,-176
    80005ada:	6088                	ld	a0,0(s1)
    80005adc:	c921                	beqz	a0,80005b2c <sys_exec+0xf6>
    kfree(argv[i]);
    80005ade:	ffffb097          	auipc	ra,0xffffb
    80005ae2:	000080e7          	jalr	ra # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ae6:	04a1                	add	s1,s1,8
    80005ae8:	ff2499e3          	bne	s1,s2,80005ada <sys_exec+0xa4>
  return -1;
    80005aec:	557d                	li	a0,-1
    80005aee:	a081                	j	80005b2e <sys_exec+0xf8>
      argv[i] = 0;
    80005af0:	0009079b          	sext.w	a5,s2
    80005af4:	078e                	sll	a5,a5,0x3
    80005af6:	fd078793          	add	a5,a5,-48
    80005afa:	97a2                	add	a5,a5,s0
    80005afc:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005b00:	e5040593          	add	a1,s0,-432
    80005b04:	f5040513          	add	a0,s0,-176
    80005b08:	fffff097          	auipc	ra,0xfffff
    80005b0c:	194080e7          	jalr	404(ra) # 80004c9c <exec>
    80005b10:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b12:	f5040993          	add	s3,s0,-176
    80005b16:	6088                	ld	a0,0(s1)
    80005b18:	c901                	beqz	a0,80005b28 <sys_exec+0xf2>
    kfree(argv[i]);
    80005b1a:	ffffb097          	auipc	ra,0xffffb
    80005b1e:	fc4080e7          	jalr	-60(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b22:	04a1                	add	s1,s1,8
    80005b24:	ff3499e3          	bne	s1,s3,80005b16 <sys_exec+0xe0>
  return ret;
    80005b28:	854a                	mv	a0,s2
    80005b2a:	a011                	j	80005b2e <sys_exec+0xf8>
  return -1;
    80005b2c:	557d                	li	a0,-1
}
    80005b2e:	70fa                	ld	ra,440(sp)
    80005b30:	745a                	ld	s0,432(sp)
    80005b32:	74ba                	ld	s1,424(sp)
    80005b34:	791a                	ld	s2,416(sp)
    80005b36:	69fa                	ld	s3,408(sp)
    80005b38:	6a5a                	ld	s4,400(sp)
    80005b3a:	6139                	add	sp,sp,448
    80005b3c:	8082                	ret

0000000080005b3e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b3e:	7139                	add	sp,sp,-64
    80005b40:	fc06                	sd	ra,56(sp)
    80005b42:	f822                	sd	s0,48(sp)
    80005b44:	f426                	sd	s1,40(sp)
    80005b46:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b48:	ffffc097          	auipc	ra,0xffffc
    80005b4c:	fc2080e7          	jalr	-62(ra) # 80001b0a <myproc>
    80005b50:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005b52:	fd840593          	add	a1,s0,-40
    80005b56:	4501                	li	a0,0
    80005b58:	ffffd097          	auipc	ra,0xffffd
    80005b5c:	114080e7          	jalr	276(ra) # 80002c6c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005b60:	fc840593          	add	a1,s0,-56
    80005b64:	fd040513          	add	a0,s0,-48
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	dea080e7          	jalr	-534(ra) # 80004952 <pipealloc>
    return -1;
    80005b70:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b72:	0c054463          	bltz	a0,80005c3a <sys_pipe+0xfc>
  fd0 = -1;
    80005b76:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b7a:	fd043503          	ld	a0,-48(s0)
    80005b7e:	fffff097          	auipc	ra,0xfffff
    80005b82:	524080e7          	jalr	1316(ra) # 800050a2 <fdalloc>
    80005b86:	fca42223          	sw	a0,-60(s0)
    80005b8a:	08054b63          	bltz	a0,80005c20 <sys_pipe+0xe2>
    80005b8e:	fc843503          	ld	a0,-56(s0)
    80005b92:	fffff097          	auipc	ra,0xfffff
    80005b96:	510080e7          	jalr	1296(ra) # 800050a2 <fdalloc>
    80005b9a:	fca42023          	sw	a0,-64(s0)
    80005b9e:	06054863          	bltz	a0,80005c0e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ba2:	4691                	li	a3,4
    80005ba4:	fc440613          	add	a2,s0,-60
    80005ba8:	fd843583          	ld	a1,-40(s0)
    80005bac:	70a8                	ld	a0,96(s1)
    80005bae:	ffffc097          	auipc	ra,0xffffc
    80005bb2:	bd6080e7          	jalr	-1066(ra) # 80001784 <copyout>
    80005bb6:	02054063          	bltz	a0,80005bd6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005bba:	4691                	li	a3,4
    80005bbc:	fc040613          	add	a2,s0,-64
    80005bc0:	fd843583          	ld	a1,-40(s0)
    80005bc4:	0591                	add	a1,a1,4
    80005bc6:	70a8                	ld	a0,96(s1)
    80005bc8:	ffffc097          	auipc	ra,0xffffc
    80005bcc:	bbc080e7          	jalr	-1092(ra) # 80001784 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005bd0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bd2:	06055463          	bgez	a0,80005c3a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005bd6:	fc442783          	lw	a5,-60(s0)
    80005bda:	07f1                	add	a5,a5,28
    80005bdc:	078e                	sll	a5,a5,0x3
    80005bde:	97a6                	add	a5,a5,s1
    80005be0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005be4:	fc042783          	lw	a5,-64(s0)
    80005be8:	07f1                	add	a5,a5,28
    80005bea:	078e                	sll	a5,a5,0x3
    80005bec:	94be                	add	s1,s1,a5
    80005bee:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005bf2:	fd043503          	ld	a0,-48(s0)
    80005bf6:	fffff097          	auipc	ra,0xfffff
    80005bfa:	a30080e7          	jalr	-1488(ra) # 80004626 <fileclose>
    fileclose(wf);
    80005bfe:	fc843503          	ld	a0,-56(s0)
    80005c02:	fffff097          	auipc	ra,0xfffff
    80005c06:	a24080e7          	jalr	-1500(ra) # 80004626 <fileclose>
    return -1;
    80005c0a:	57fd                	li	a5,-1
    80005c0c:	a03d                	j	80005c3a <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005c0e:	fc442783          	lw	a5,-60(s0)
    80005c12:	0007c763          	bltz	a5,80005c20 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005c16:	07f1                	add	a5,a5,28
    80005c18:	078e                	sll	a5,a5,0x3
    80005c1a:	97a6                	add	a5,a5,s1
    80005c1c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005c20:	fd043503          	ld	a0,-48(s0)
    80005c24:	fffff097          	auipc	ra,0xfffff
    80005c28:	a02080e7          	jalr	-1534(ra) # 80004626 <fileclose>
    fileclose(wf);
    80005c2c:	fc843503          	ld	a0,-56(s0)
    80005c30:	fffff097          	auipc	ra,0xfffff
    80005c34:	9f6080e7          	jalr	-1546(ra) # 80004626 <fileclose>
    return -1;
    80005c38:	57fd                	li	a5,-1
}
    80005c3a:	853e                	mv	a0,a5
    80005c3c:	70e2                	ld	ra,56(sp)
    80005c3e:	7442                	ld	s0,48(sp)
    80005c40:	74a2                	ld	s1,40(sp)
    80005c42:	6121                	add	sp,sp,64
    80005c44:	8082                	ret
	...

0000000080005c50 <kernelvec>:
    80005c50:	7111                	add	sp,sp,-256
    80005c52:	e006                	sd	ra,0(sp)
    80005c54:	e40a                	sd	sp,8(sp)
    80005c56:	e80e                	sd	gp,16(sp)
    80005c58:	ec12                	sd	tp,24(sp)
    80005c5a:	f016                	sd	t0,32(sp)
    80005c5c:	f41a                	sd	t1,40(sp)
    80005c5e:	f81e                	sd	t2,48(sp)
    80005c60:	e4aa                	sd	a0,72(sp)
    80005c62:	e8ae                	sd	a1,80(sp)
    80005c64:	ecb2                	sd	a2,88(sp)
    80005c66:	f0b6                	sd	a3,96(sp)
    80005c68:	f4ba                	sd	a4,104(sp)
    80005c6a:	f8be                	sd	a5,112(sp)
    80005c6c:	fcc2                	sd	a6,120(sp)
    80005c6e:	e146                	sd	a7,128(sp)
    80005c70:	edf2                	sd	t3,216(sp)
    80005c72:	f1f6                	sd	t4,224(sp)
    80005c74:	f5fa                	sd	t5,232(sp)
    80005c76:	f9fe                	sd	t6,240(sp)
    80005c78:	e23fc0ef          	jal	80002a9a <kerneltrap>
    80005c7c:	6082                	ld	ra,0(sp)
    80005c7e:	6122                	ld	sp,8(sp)
    80005c80:	61c2                	ld	gp,16(sp)
    80005c82:	7282                	ld	t0,32(sp)
    80005c84:	7322                	ld	t1,40(sp)
    80005c86:	73c2                	ld	t2,48(sp)
    80005c88:	6526                	ld	a0,72(sp)
    80005c8a:	65c6                	ld	a1,80(sp)
    80005c8c:	6666                	ld	a2,88(sp)
    80005c8e:	7686                	ld	a3,96(sp)
    80005c90:	7726                	ld	a4,104(sp)
    80005c92:	77c6                	ld	a5,112(sp)
    80005c94:	7866                	ld	a6,120(sp)
    80005c96:	688a                	ld	a7,128(sp)
    80005c98:	6e6e                	ld	t3,216(sp)
    80005c9a:	7e8e                	ld	t4,224(sp)
    80005c9c:	7f2e                	ld	t5,232(sp)
    80005c9e:	7fce                	ld	t6,240(sp)
    80005ca0:	6111                	add	sp,sp,256
    80005ca2:	10200073          	sret
	...

0000000080005cae <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    80005cae:	1141                	add	sp,sp,-16
    80005cb0:	e422                	sd	s0,8(sp)
    80005cb2:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005cb4:	0c0007b7          	lui	a5,0xc000
    80005cb8:	4705                	li	a4,1
    80005cba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005cbc:	c3d8                	sw	a4,4(a5)
}
    80005cbe:	6422                	ld	s0,8(sp)
    80005cc0:	0141                	add	sp,sp,16
    80005cc2:	8082                	ret

0000000080005cc4 <plicinithart>:

void
plicinithart(void)
{
    80005cc4:	1141                	add	sp,sp,-16
    80005cc6:	e406                	sd	ra,8(sp)
    80005cc8:	e022                	sd	s0,0(sp)
    80005cca:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005ccc:	ffffc097          	auipc	ra,0xffffc
    80005cd0:	e0c080e7          	jalr	-500(ra) # 80001ad8 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005cd4:	0085171b          	sllw	a4,a0,0x8
    80005cd8:	0c0027b7          	lui	a5,0xc002
    80005cdc:	97ba                	add	a5,a5,a4
    80005cde:	40200713          	li	a4,1026
    80005ce2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005ce6:	00d5151b          	sllw	a0,a0,0xd
    80005cea:	0c2017b7          	lui	a5,0xc201
    80005cee:	97aa                	add	a5,a5,a0
    80005cf0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005cf4:	60a2                	ld	ra,8(sp)
    80005cf6:	6402                	ld	s0,0(sp)
    80005cf8:	0141                	add	sp,sp,16
    80005cfa:	8082                	ret

0000000080005cfc <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005cfc:	1141                	add	sp,sp,-16
    80005cfe:	e406                	sd	ra,8(sp)
    80005d00:	e022                	sd	s0,0(sp)
    80005d02:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005d04:	ffffc097          	auipc	ra,0xffffc
    80005d08:	dd4080e7          	jalr	-556(ra) # 80001ad8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d0c:	00d5151b          	sllw	a0,a0,0xd
    80005d10:	0c2017b7          	lui	a5,0xc201
    80005d14:	97aa                	add	a5,a5,a0
  return irq;
}
    80005d16:	43c8                	lw	a0,4(a5)
    80005d18:	60a2                	ld	ra,8(sp)
    80005d1a:	6402                	ld	s0,0(sp)
    80005d1c:	0141                	add	sp,sp,16
    80005d1e:	8082                	ret

0000000080005d20 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    80005d20:	1101                	add	sp,sp,-32
    80005d22:	ec06                	sd	ra,24(sp)
    80005d24:	e822                	sd	s0,16(sp)
    80005d26:	e426                	sd	s1,8(sp)
    80005d28:	1000                	add	s0,sp,32
    80005d2a:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d2c:	ffffc097          	auipc	ra,0xffffc
    80005d30:	dac080e7          	jalr	-596(ra) # 80001ad8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d34:	00d5151b          	sllw	a0,a0,0xd
    80005d38:	0c2017b7          	lui	a5,0xc201
    80005d3c:	97aa                	add	a5,a5,a0
    80005d3e:	c3c4                	sw	s1,4(a5)
}
    80005d40:	60e2                	ld	ra,24(sp)
    80005d42:	6442                	ld	s0,16(sp)
    80005d44:	64a2                	ld	s1,8(sp)
    80005d46:	6105                	add	sp,sp,32
    80005d48:	8082                	ret

0000000080005d4a <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    80005d4a:	1141                	add	sp,sp,-16
    80005d4c:	e406                	sd	ra,8(sp)
    80005d4e:	e022                	sd	s0,0(sp)
    80005d50:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005d52:	479d                	li	a5,7
    80005d54:	04a7cc63          	blt	a5,a0,80005dac <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005d58:	0001d797          	auipc	a5,0x1d
    80005d5c:	c2878793          	add	a5,a5,-984 # 80022980 <disk>
    80005d60:	97aa                	add	a5,a5,a0
    80005d62:	0187c783          	lbu	a5,24(a5)
    80005d66:	ebb9                	bnez	a5,80005dbc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005d68:	00451693          	sll	a3,a0,0x4
    80005d6c:	0001d797          	auipc	a5,0x1d
    80005d70:	c1478793          	add	a5,a5,-1004 # 80022980 <disk>
    80005d74:	6398                	ld	a4,0(a5)
    80005d76:	9736                	add	a4,a4,a3
    80005d78:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005d7c:	6398                	ld	a4,0(a5)
    80005d7e:	9736                	add	a4,a4,a3
    80005d80:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005d84:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005d88:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005d8c:	97aa                	add	a5,a5,a0
    80005d8e:	4705                	li	a4,1
    80005d90:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005d94:	0001d517          	auipc	a0,0x1d
    80005d98:	c0450513          	add	a0,a0,-1020 # 80022998 <disk+0x18>
    80005d9c:	ffffc097          	auipc	ra,0xffffc
    80005da0:	4c2080e7          	jalr	1218(ra) # 8000225e <wakeup>
}
    80005da4:	60a2                	ld	ra,8(sp)
    80005da6:	6402                	ld	s0,0(sp)
    80005da8:	0141                	add	sp,sp,16
    80005daa:	8082                	ret
    panic("free_desc 1");
    80005dac:	00003517          	auipc	a0,0x3
    80005db0:	9d450513          	add	a0,a0,-1580 # 80008780 <syscalls+0x2f0>
    80005db4:	ffffb097          	auipc	ra,0xffffb
    80005db8:	a5a080e7          	jalr	-1446(ra) # 8000080e <panic>
    panic("free_desc 2");
    80005dbc:	00003517          	auipc	a0,0x3
    80005dc0:	9d450513          	add	a0,a0,-1580 # 80008790 <syscalls+0x300>
    80005dc4:	ffffb097          	auipc	ra,0xffffb
    80005dc8:	a4a080e7          	jalr	-1462(ra) # 8000080e <panic>

0000000080005dcc <virtio_disk_init>:
{
    80005dcc:	1101                	add	sp,sp,-32
    80005dce:	ec06                	sd	ra,24(sp)
    80005dd0:	e822                	sd	s0,16(sp)
    80005dd2:	e426                	sd	s1,8(sp)
    80005dd4:	e04a                	sd	s2,0(sp)
    80005dd6:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005dd8:	00003597          	auipc	a1,0x3
    80005ddc:	9c858593          	add	a1,a1,-1592 # 800087a0 <syscalls+0x310>
    80005de0:	0001d517          	auipc	a0,0x1d
    80005de4:	cc850513          	add	a0,a0,-824 # 80022aa8 <disk+0x128>
    80005de8:	ffffb097          	auipc	ra,0xffffb
    80005dec:	e54080e7          	jalr	-428(ra) # 80000c3c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005df0:	100017b7          	lui	a5,0x10001
    80005df4:	4398                	lw	a4,0(a5)
    80005df6:	2701                	sext.w	a4,a4
    80005df8:	747277b7          	lui	a5,0x74727
    80005dfc:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e00:	14f71b63          	bne	a4,a5,80005f56 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e04:	100017b7          	lui	a5,0x10001
    80005e08:	43dc                	lw	a5,4(a5)
    80005e0a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e0c:	4709                	li	a4,2
    80005e0e:	14e79463          	bne	a5,a4,80005f56 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e12:	100017b7          	lui	a5,0x10001
    80005e16:	479c                	lw	a5,8(a5)
    80005e18:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e1a:	12e79e63          	bne	a5,a4,80005f56 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e1e:	100017b7          	lui	a5,0x10001
    80005e22:	47d8                	lw	a4,12(a5)
    80005e24:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e26:	554d47b7          	lui	a5,0x554d4
    80005e2a:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e2e:	12f71463          	bne	a4,a5,80005f56 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e32:	100017b7          	lui	a5,0x10001
    80005e36:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e3a:	4705                	li	a4,1
    80005e3c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e3e:	470d                	li	a4,3
    80005e40:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e42:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e44:	c7ffe6b7          	lui	a3,0xc7ffe
    80005e48:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbc9f>
    80005e4c:	8f75                	and	a4,a4,a3
    80005e4e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e50:	472d                	li	a4,11
    80005e52:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005e54:	5bbc                	lw	a5,112(a5)
    80005e56:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005e5a:	8ba1                	and	a5,a5,8
    80005e5c:	10078563          	beqz	a5,80005f66 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e60:	100017b7          	lui	a5,0x10001
    80005e64:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005e68:	43fc                	lw	a5,68(a5)
    80005e6a:	2781                	sext.w	a5,a5
    80005e6c:	10079563          	bnez	a5,80005f76 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e70:	100017b7          	lui	a5,0x10001
    80005e74:	5bdc                	lw	a5,52(a5)
    80005e76:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e78:	10078763          	beqz	a5,80005f86 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005e7c:	471d                	li	a4,7
    80005e7e:	10f77c63          	bgeu	a4,a5,80005f96 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005e82:	ffffb097          	auipc	ra,0xffffb
    80005e86:	d5a080e7          	jalr	-678(ra) # 80000bdc <kalloc>
    80005e8a:	0001d497          	auipc	s1,0x1d
    80005e8e:	af648493          	add	s1,s1,-1290 # 80022980 <disk>
    80005e92:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005e94:	ffffb097          	auipc	ra,0xffffb
    80005e98:	d48080e7          	jalr	-696(ra) # 80000bdc <kalloc>
    80005e9c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005e9e:	ffffb097          	auipc	ra,0xffffb
    80005ea2:	d3e080e7          	jalr	-706(ra) # 80000bdc <kalloc>
    80005ea6:	87aa                	mv	a5,a0
    80005ea8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005eaa:	6088                	ld	a0,0(s1)
    80005eac:	cd6d                	beqz	a0,80005fa6 <virtio_disk_init+0x1da>
    80005eae:	0001d717          	auipc	a4,0x1d
    80005eb2:	ada73703          	ld	a4,-1318(a4) # 80022988 <disk+0x8>
    80005eb6:	cb65                	beqz	a4,80005fa6 <virtio_disk_init+0x1da>
    80005eb8:	c7fd                	beqz	a5,80005fa6 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005eba:	6605                	lui	a2,0x1
    80005ebc:	4581                	li	a1,0
    80005ebe:	ffffb097          	auipc	ra,0xffffb
    80005ec2:	f0a080e7          	jalr	-246(ra) # 80000dc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005ec6:	0001d497          	auipc	s1,0x1d
    80005eca:	aba48493          	add	s1,s1,-1350 # 80022980 <disk>
    80005ece:	6605                	lui	a2,0x1
    80005ed0:	4581                	li	a1,0
    80005ed2:	6488                	ld	a0,8(s1)
    80005ed4:	ffffb097          	auipc	ra,0xffffb
    80005ed8:	ef4080e7          	jalr	-268(ra) # 80000dc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005edc:	6605                	lui	a2,0x1
    80005ede:	4581                	li	a1,0
    80005ee0:	6888                	ld	a0,16(s1)
    80005ee2:	ffffb097          	auipc	ra,0xffffb
    80005ee6:	ee6080e7          	jalr	-282(ra) # 80000dc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005eea:	100017b7          	lui	a5,0x10001
    80005eee:	4721                	li	a4,8
    80005ef0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005ef2:	4098                	lw	a4,0(s1)
    80005ef4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005ef8:	40d8                	lw	a4,4(s1)
    80005efa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005efe:	6498                	ld	a4,8(s1)
    80005f00:	0007069b          	sext.w	a3,a4
    80005f04:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005f08:	9701                	sra	a4,a4,0x20
    80005f0a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005f0e:	6898                	ld	a4,16(s1)
    80005f10:	0007069b          	sext.w	a3,a4
    80005f14:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005f18:	9701                	sra	a4,a4,0x20
    80005f1a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005f1e:	4705                	li	a4,1
    80005f20:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005f22:	00e48c23          	sb	a4,24(s1)
    80005f26:	00e48ca3          	sb	a4,25(s1)
    80005f2a:	00e48d23          	sb	a4,26(s1)
    80005f2e:	00e48da3          	sb	a4,27(s1)
    80005f32:	00e48e23          	sb	a4,28(s1)
    80005f36:	00e48ea3          	sb	a4,29(s1)
    80005f3a:	00e48f23          	sb	a4,30(s1)
    80005f3e:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005f42:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f46:	0727a823          	sw	s2,112(a5)
}
    80005f4a:	60e2                	ld	ra,24(sp)
    80005f4c:	6442                	ld	s0,16(sp)
    80005f4e:	64a2                	ld	s1,8(sp)
    80005f50:	6902                	ld	s2,0(sp)
    80005f52:	6105                	add	sp,sp,32
    80005f54:	8082                	ret
    panic("could not find virtio disk");
    80005f56:	00003517          	auipc	a0,0x3
    80005f5a:	85a50513          	add	a0,a0,-1958 # 800087b0 <syscalls+0x320>
    80005f5e:	ffffb097          	auipc	ra,0xffffb
    80005f62:	8b0080e7          	jalr	-1872(ra) # 8000080e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005f66:	00003517          	auipc	a0,0x3
    80005f6a:	86a50513          	add	a0,a0,-1942 # 800087d0 <syscalls+0x340>
    80005f6e:	ffffb097          	auipc	ra,0xffffb
    80005f72:	8a0080e7          	jalr	-1888(ra) # 8000080e <panic>
    panic("virtio disk should not be ready");
    80005f76:	00003517          	auipc	a0,0x3
    80005f7a:	87a50513          	add	a0,a0,-1926 # 800087f0 <syscalls+0x360>
    80005f7e:	ffffb097          	auipc	ra,0xffffb
    80005f82:	890080e7          	jalr	-1904(ra) # 8000080e <panic>
    panic("virtio disk has no queue 0");
    80005f86:	00003517          	auipc	a0,0x3
    80005f8a:	88a50513          	add	a0,a0,-1910 # 80008810 <syscalls+0x380>
    80005f8e:	ffffb097          	auipc	ra,0xffffb
    80005f92:	880080e7          	jalr	-1920(ra) # 8000080e <panic>
    panic("virtio disk max queue too short");
    80005f96:	00003517          	auipc	a0,0x3
    80005f9a:	89a50513          	add	a0,a0,-1894 # 80008830 <syscalls+0x3a0>
    80005f9e:	ffffb097          	auipc	ra,0xffffb
    80005fa2:	870080e7          	jalr	-1936(ra) # 8000080e <panic>
    panic("virtio disk kalloc");
    80005fa6:	00003517          	auipc	a0,0x3
    80005faa:	8aa50513          	add	a0,a0,-1878 # 80008850 <syscalls+0x3c0>
    80005fae:	ffffb097          	auipc	ra,0xffffb
    80005fb2:	860080e7          	jalr	-1952(ra) # 8000080e <panic>

0000000080005fb6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005fb6:	7159                	add	sp,sp,-112
    80005fb8:	f486                	sd	ra,104(sp)
    80005fba:	f0a2                	sd	s0,96(sp)
    80005fbc:	eca6                	sd	s1,88(sp)
    80005fbe:	e8ca                	sd	s2,80(sp)
    80005fc0:	e4ce                	sd	s3,72(sp)
    80005fc2:	e0d2                	sd	s4,64(sp)
    80005fc4:	fc56                	sd	s5,56(sp)
    80005fc6:	f85a                	sd	s6,48(sp)
    80005fc8:	f45e                	sd	s7,40(sp)
    80005fca:	f062                	sd	s8,32(sp)
    80005fcc:	ec66                	sd	s9,24(sp)
    80005fce:	e86a                	sd	s10,16(sp)
    80005fd0:	1880                	add	s0,sp,112
    80005fd2:	8a2a                	mv	s4,a0
    80005fd4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005fd6:	00c52c83          	lw	s9,12(a0)
    80005fda:	001c9c9b          	sllw	s9,s9,0x1
    80005fde:	1c82                	sll	s9,s9,0x20
    80005fe0:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005fe4:	0001d517          	auipc	a0,0x1d
    80005fe8:	ac450513          	add	a0,a0,-1340 # 80022aa8 <disk+0x128>
    80005fec:	ffffb097          	auipc	ra,0xffffb
    80005ff0:	ce0080e7          	jalr	-800(ra) # 80000ccc <acquire>
  for(int i = 0; i < 3; i++){
    80005ff4:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005ff6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005ff8:	0001db17          	auipc	s6,0x1d
    80005ffc:	988b0b13          	add	s6,s6,-1656 # 80022980 <disk>
  for(int i = 0; i < 3; i++){
    80006000:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006002:	0001dc17          	auipc	s8,0x1d
    80006006:	aa6c0c13          	add	s8,s8,-1370 # 80022aa8 <disk+0x128>
    8000600a:	a095                	j	8000606e <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000600c:	00fb0733          	add	a4,s6,a5
    80006010:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006014:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80006016:	0207c563          	bltz	a5,80006040 <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    8000601a:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    8000601c:	0591                	add	a1,a1,4
    8000601e:	05560d63          	beq	a2,s5,80006078 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006022:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80006024:	0001d717          	auipc	a4,0x1d
    80006028:	95c70713          	add	a4,a4,-1700 # 80022980 <disk>
    8000602c:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000602e:	01874683          	lbu	a3,24(a4)
    80006032:	fee9                	bnez	a3,8000600c <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80006034:	2785                	addw	a5,a5,1
    80006036:	0705                	add	a4,a4,1
    80006038:	fe979be3          	bne	a5,s1,8000602e <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    8000603c:	57fd                	li	a5,-1
    8000603e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80006040:	00c05e63          	blez	a2,8000605c <virtio_disk_rw+0xa6>
    80006044:	060a                	sll	a2,a2,0x2
    80006046:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000604a:	0009a503          	lw	a0,0(s3)
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	cfc080e7          	jalr	-772(ra) # 80005d4a <free_desc>
      for(int j = 0; j < i; j++)
    80006056:	0991                	add	s3,s3,4
    80006058:	ffa999e3          	bne	s3,s10,8000604a <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000605c:	85e2                	mv	a1,s8
    8000605e:	0001d517          	auipc	a0,0x1d
    80006062:	93a50513          	add	a0,a0,-1734 # 80022998 <disk+0x18>
    80006066:	ffffc097          	auipc	ra,0xffffc
    8000606a:	194080e7          	jalr	404(ra) # 800021fa <sleep>
  for(int i = 0; i < 3; i++){
    8000606e:	f9040993          	add	s3,s0,-112
{
    80006072:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006074:	864a                	mv	a2,s2
    80006076:	b775                	j	80006022 <virtio_disk_rw+0x6c>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006078:	f9042503          	lw	a0,-112(s0)
    8000607c:	00a50713          	add	a4,a0,10
    80006080:	0712                	sll	a4,a4,0x4

  if(write)
    80006082:	0001d797          	auipc	a5,0x1d
    80006086:	8fe78793          	add	a5,a5,-1794 # 80022980 <disk>
    8000608a:	00e786b3          	add	a3,a5,a4
    8000608e:	01703633          	snez	a2,s7
    80006092:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    80006094:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006098:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000609c:	f6070613          	add	a2,a4,-160
    800060a0:	6394                	ld	a3,0(a5)
    800060a2:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800060a4:	00870593          	add	a1,a4,8
    800060a8:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800060aa:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800060ac:	0007b803          	ld	a6,0(a5)
    800060b0:	9642                	add	a2,a2,a6
    800060b2:	46c1                	li	a3,16
    800060b4:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800060b6:	4585                	li	a1,1
    800060b8:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800060bc:	f9442683          	lw	a3,-108(s0)
    800060c0:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800060c4:	0692                	sll	a3,a3,0x4
    800060c6:	9836                	add	a6,a6,a3
    800060c8:	058a0613          	add	a2,s4,88
    800060cc:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800060d0:	0007b803          	ld	a6,0(a5)
    800060d4:	96c2                	add	a3,a3,a6
    800060d6:	40000613          	li	a2,1024
    800060da:	c690                	sw	a2,8(a3)
  if(write)
    800060dc:	001bb613          	seqz	a2,s7
    800060e0:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800060e4:	00166613          	or	a2,a2,1
    800060e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800060ec:	f9842603          	lw	a2,-104(s0)
    800060f0:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    800060f4:	00250693          	add	a3,a0,2
    800060f8:	0692                	sll	a3,a3,0x4
    800060fa:	96be                	add	a3,a3,a5
    800060fc:	58fd                	li	a7,-1
    800060fe:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006102:	0612                	sll	a2,a2,0x4
    80006104:	9832                	add	a6,a6,a2
    80006106:	f9070713          	add	a4,a4,-112
    8000610a:	973e                	add	a4,a4,a5
    8000610c:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80006110:	6398                	ld	a4,0(a5)
    80006112:	9732                	add	a4,a4,a2
    80006114:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    80006116:	4609                	li	a2,2
    80006118:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    8000611c:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    80006120:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80006124:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006128:	6794                	ld	a3,8(a5)
    8000612a:	0026d703          	lhu	a4,2(a3)
    8000612e:	8b1d                	and	a4,a4,7
    80006130:	0706                	sll	a4,a4,0x1
    80006132:	96ba                	add	a3,a3,a4
    80006134:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006138:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    8000613c:	6798                	ld	a4,8(a5)
    8000613e:	00275783          	lhu	a5,2(a4)
    80006142:	2785                	addw	a5,a5,1
    80006144:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006148:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    8000614c:	100017b7          	lui	a5,0x10001
    80006150:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    80006154:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006158:	0001d917          	auipc	s2,0x1d
    8000615c:	95090913          	add	s2,s2,-1712 # 80022aa8 <disk+0x128>
  while(b->disk == 1) {
    80006160:	4485                	li	s1,1
    80006162:	00b79c63          	bne	a5,a1,8000617a <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006166:	85ca                	mv	a1,s2
    80006168:	8552                	mv	a0,s4
    8000616a:	ffffc097          	auipc	ra,0xffffc
    8000616e:	090080e7          	jalr	144(ra) # 800021fa <sleep>
  while(b->disk == 1) {
    80006172:	004a2783          	lw	a5,4(s4)
    80006176:	fe9788e3          	beq	a5,s1,80006166 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000617a:	f9042903          	lw	s2,-112(s0)
    8000617e:	00290713          	add	a4,s2,2
    80006182:	0712                	sll	a4,a4,0x4
    80006184:	0001c797          	auipc	a5,0x1c
    80006188:	7fc78793          	add	a5,a5,2044 # 80022980 <disk>
    8000618c:	97ba                	add	a5,a5,a4
    8000618e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006192:	0001c997          	auipc	s3,0x1c
    80006196:	7ee98993          	add	s3,s3,2030 # 80022980 <disk>
    8000619a:	00491713          	sll	a4,s2,0x4
    8000619e:	0009b783          	ld	a5,0(s3)
    800061a2:	97ba                	add	a5,a5,a4
    800061a4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800061a8:	854a                	mv	a0,s2
    800061aa:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	b9c080e7          	jalr	-1124(ra) # 80005d4a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800061b6:	8885                	and	s1,s1,1
    800061b8:	f0ed                	bnez	s1,8000619a <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800061ba:	0001d517          	auipc	a0,0x1d
    800061be:	8ee50513          	add	a0,a0,-1810 # 80022aa8 <disk+0x128>
    800061c2:	ffffb097          	auipc	ra,0xffffb
    800061c6:	bbe080e7          	jalr	-1090(ra) # 80000d80 <release>
}
    800061ca:	70a6                	ld	ra,104(sp)
    800061cc:	7406                	ld	s0,96(sp)
    800061ce:	64e6                	ld	s1,88(sp)
    800061d0:	6946                	ld	s2,80(sp)
    800061d2:	69a6                	ld	s3,72(sp)
    800061d4:	6a06                	ld	s4,64(sp)
    800061d6:	7ae2                	ld	s5,56(sp)
    800061d8:	7b42                	ld	s6,48(sp)
    800061da:	7ba2                	ld	s7,40(sp)
    800061dc:	7c02                	ld	s8,32(sp)
    800061de:	6ce2                	ld	s9,24(sp)
    800061e0:	6d42                	ld	s10,16(sp)
    800061e2:	6165                	add	sp,sp,112
    800061e4:	8082                	ret

00000000800061e6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800061e6:	1101                	add	sp,sp,-32
    800061e8:	ec06                	sd	ra,24(sp)
    800061ea:	e822                	sd	s0,16(sp)
    800061ec:	e426                	sd	s1,8(sp)
    800061ee:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800061f0:	0001c497          	auipc	s1,0x1c
    800061f4:	79048493          	add	s1,s1,1936 # 80022980 <disk>
    800061f8:	0001d517          	auipc	a0,0x1d
    800061fc:	8b050513          	add	a0,a0,-1872 # 80022aa8 <disk+0x128>
    80006200:	ffffb097          	auipc	ra,0xffffb
    80006204:	acc080e7          	jalr	-1332(ra) # 80000ccc <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006208:	10001737          	lui	a4,0x10001
    8000620c:	533c                	lw	a5,96(a4)
    8000620e:	8b8d                	and	a5,a5,3
    80006210:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006212:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    80006216:	689c                	ld	a5,16(s1)
    80006218:	0204d703          	lhu	a4,32(s1)
    8000621c:	0027d783          	lhu	a5,2(a5)
    80006220:	04f70863          	beq	a4,a5,80006270 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006224:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006228:	6898                	ld	a4,16(s1)
    8000622a:	0204d783          	lhu	a5,32(s1)
    8000622e:	8b9d                	and	a5,a5,7
    80006230:	078e                	sll	a5,a5,0x3
    80006232:	97ba                	add	a5,a5,a4
    80006234:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006236:	00278713          	add	a4,a5,2
    8000623a:	0712                	sll	a4,a4,0x4
    8000623c:	9726                	add	a4,a4,s1
    8000623e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006242:	e721                	bnez	a4,8000628a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006244:	0789                	add	a5,a5,2
    80006246:	0792                	sll	a5,a5,0x4
    80006248:	97a6                	add	a5,a5,s1
    8000624a:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    8000624c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006250:	ffffc097          	auipc	ra,0xffffc
    80006254:	00e080e7          	jalr	14(ra) # 8000225e <wakeup>

    disk.used_idx += 1;
    80006258:	0204d783          	lhu	a5,32(s1)
    8000625c:	2785                	addw	a5,a5,1
    8000625e:	17c2                	sll	a5,a5,0x30
    80006260:	93c1                	srl	a5,a5,0x30
    80006262:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006266:	6898                	ld	a4,16(s1)
    80006268:	00275703          	lhu	a4,2(a4)
    8000626c:	faf71ce3          	bne	a4,a5,80006224 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006270:	0001d517          	auipc	a0,0x1d
    80006274:	83850513          	add	a0,a0,-1992 # 80022aa8 <disk+0x128>
    80006278:	ffffb097          	auipc	ra,0xffffb
    8000627c:	b08080e7          	jalr	-1272(ra) # 80000d80 <release>
}
    80006280:	60e2                	ld	ra,24(sp)
    80006282:	6442                	ld	s0,16(sp)
    80006284:	64a2                	ld	s1,8(sp)
    80006286:	6105                	add	sp,sp,32
    80006288:	8082                	ret
      panic("virtio_disk_intr status");
    8000628a:	00002517          	auipc	a0,0x2
    8000628e:	5de50513          	add	a0,a0,1502 # 80008868 <syscalls+0x3d8>
    80006292:	ffffa097          	auipc	ra,0xffffa
    80006296:	57c080e7          	jalr	1404(ra) # 8000080e <panic>
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
