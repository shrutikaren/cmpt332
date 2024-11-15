
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
    80000102:	5c2080e7          	jalr	1474(ra) # 800026c0 <either_copyin>
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
    80000194:	37a080e7          	jalr	890(ra) # 8000250a <killed>
    80000198:	ed2d                	bnez	a0,80000212 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    8000019a:	85a6                	mv	a1,s1
    8000019c:	854a                	mv	a0,s2
    8000019e:	00002097          	auipc	ra,0x2
    800001a2:	0c4080e7          	jalr	196(ra) # 80002262 <sleep>
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
    800001e8:	486080e7          	jalr	1158(ra) # 8000266a <either_copyout>
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
    800002c6:	454080e7          	jalr	1108(ra) # 80002716 <procdump>
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
    8000041a:	eb0080e7          	jalr	-336(ra) # 800022c6 <wakeup>
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
    8000097e:	94c080e7          	jalr	-1716(ra) # 800022c6 <wakeup>
    
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
    80000a18:	84e080e7          	jalr	-1970(ra) # 80002262 <sleep>
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
    80000fb6:	8a6080e7          	jalr	-1882(ra) # 80002858 <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	d6a080e7          	jalr	-662(ra) # 80005d24 <plicinithart>
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
    8000102a:	00002097          	auipc	ra,0x2
    8000102e:	806080e7          	jalr	-2042(ra) # 80002830 <trapinit>
    trapinithart();  /* install kernel trap vector */
    80001032:	00002097          	auipc	ra,0x2
    80001036:	826080e7          	jalr	-2010(ra) # 80002858 <trapinithart>
    plicinit();      /* set up interrupt controller */
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	cd4080e7          	jalr	-812(ra) # 80005d0e <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80001042:	00005097          	auipc	ra,0x5
    80001046:	ce2080e7          	jalr	-798(ra) # 80005d24 <plicinithart>
    binit();         /* buffer cache */
    8000104a:	00002097          	auipc	ra,0x2
    8000104e:	f3c080e7          	jalr	-196(ra) # 80002f86 <binit>
    iinit();         /* inode table */
    80001052:	00002097          	auipc	ra,0x2
    80001056:	5da080e7          	jalr	1498(ra) # 8000362c <iinit>
    fileinit();      /* file table */
    8000105a:	00003097          	auipc	ra,0x3
    8000105e:	550080e7          	jalr	1360(ra) # 800045aa <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80001062:	00005097          	auipc	ra,0x5
    80001066:	dca080e7          	jalr	-566(ra) # 80005e2c <virtio_disk_init>
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
    80001b6e:	d06080e7          	jalr	-762(ra) # 80002870 <usertrapret>
}
    80001b72:	60a2                	ld	ra,8(sp)
    80001b74:	6402                	ld	s0,0(sp)
    80001b76:	0141                	add	sp,sp,16
    80001b78:	8082                	ret
    fsinit(ROOTDEV);
    80001b7a:	4505                	li	a0,1
    80001b7c:	00002097          	auipc	ra,0x2
    80001b80:	a30080e7          	jalr	-1488(ra) # 800035ac <fsinit>
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
    80001e56:	178080e7          	jalr	376(ra) # 80003fca <namei>
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
    80001f86:	6ba080e7          	jalr	1722(ra) # 8000463c <filedup>
    80001f8a:	00a93023          	sd	a0,0(s2)
    80001f8e:	b7e5                	j	80001f76 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001f90:	160ab503          	ld	a0,352(s5)
    80001f94:	00002097          	auipc	ra,0x2
    80001f98:	852080e7          	jalr	-1966(ra) # 800037e6 <idup>
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
    80002050:	715d                	add	sp,sp,-80
    80002052:	e486                	sd	ra,72(sp)
    80002054:	e0a2                	sd	s0,64(sp)
    80002056:	fc26                	sd	s1,56(sp)
    80002058:	f84a                	sd	s2,48(sp)
    8000205a:	f44e                	sd	s3,40(sp)
    8000205c:	f052                	sd	s4,32(sp)
    8000205e:	ec56                	sd	s5,24(sp)
    80002060:	e85a                	sd	s6,16(sp)
    80002062:	e45e                	sd	s7,8(sp)
    80002064:	0880                	add	s0,sp,80
    80002066:	8592                	mv	a1,tp
  int id = r_tp();
    80002068:	2581                	sext.w	a1,a1
	for (i = 0; i < PRIQUEUES; i ++){
    8000206a:	00010697          	auipc	a3,0x10
    8000206e:	84e68693          	add	a3,a3,-1970 # 800118b8 <multifeedbackqueue+0xa18>
    80002072:	0000f717          	auipc	a4,0xf
    80002076:	04670713          	add	a4,a4,70 # 800110b8 <multifeedbackqueue+0x218>
    8000207a:	00010617          	auipc	a2,0x10
    8000207e:	a3e60613          	add	a2,a2,-1474 # 80011ab8 <proc+0x1d8>
		for (j = 0; j < NPROC; j++){
    80002082:	e0070793          	add	a5,a4,-512
			multifeedbackqueue.proc[i][j] = 0;
    80002086:	0007b023          	sd	zero,0(a5)
		for (j = 0; j < NPROC; j++){
    8000208a:	07a1                	add	a5,a5,8
    8000208c:	fef71de3          	bne	a4,a5,80002086 <scheduler+0x36>
		multifeedbackqueue.beginning[i] = 0;
    80002090:	0006a023          	sw	zero,0(a3)
	for (i = 0; i < PRIQUEUES; i ++){
    80002094:	0691                	add	a3,a3,4
    80002096:	20070713          	add	a4,a4,512
    8000209a:	fee614e3          	bne	a2,a4,80002082 <scheduler+0x32>
    8000209e:	00010797          	auipc	a5,0x10
    800020a2:	9207a723          	sw	zero,-1746(a5) # 800119cc <proc+0xec>
		swtch(&c->context, &p->context);	
    800020a6:	00459a93          	sll	s5,a1,0x4
    800020aa:	9aae                	add	s5,s5,a1
    800020ac:	0a8e                	sll	s5,s5,0x3
    800020ae:	0000f797          	auipc	a5,0xf
    800020b2:	9ba78793          	add	a5,a5,-1606 # 80010a68 <cpus+0x8>
    800020b6:	9abe                	add	s5,s5,a5
		acquire(&wait_lock);
    800020b8:	0000fa17          	auipc	s4,0xf
    800020bc:	990a0a13          	add	s4,s4,-1648 # 80010a48 <wait_lock>
			p = multifeedbackqueue.proc[priorityLevel][0];
    800020c0:	0000f997          	auipc	s3,0xf
    800020c4:	de098993          	add	s3,s3,-544 # 80010ea0 <multifeedbackqueue>
    800020c8:	00010b97          	auipc	s7,0x10
    800020cc:	dd8b8b93          	add	s7,s7,-552 # 80011ea0 <proc+0x5c0>
			p->state = RUNNING;
    800020d0:	4491                	li	s1,4
		while (ticks - ticksNum < slicingTime && p->state == RUNNING){};
    800020d2:	00007b17          	auipc	s6,0x7
    800020d6:	82eb0b13          	add	s6,s6,-2002 # 80008900 <ticks>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020de:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020e2:	10079073          	csrw	sstatus,a5
		acquire(&wait_lock);
    800020e6:	8552                	mv	a0,s4
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	be4080e7          	jalr	-1052(ra) # 80000ccc <acquire>
			p = multifeedbackqueue.proc[priorityLevel][0];
    800020f0:	818bb783          	ld	a5,-2024(s7)
			p->state = RUNNING;
    800020f4:	cf84                	sw	s1,24(a5)
			p = multifeedbackqueue.proc[priorityLevel][0];
    800020f6:	6189b783          	ld	a5,1560(s3)
			p->state = RUNNING;
    800020fa:	cf84                	sw	s1,24(a5)
			p = multifeedbackqueue.proc[priorityLevel][0];
    800020fc:	4189b783          	ld	a5,1048(s3)
			p->state = RUNNING;
    80002100:	cf84                	sw	s1,24(a5)
			p = multifeedbackqueue.proc[priorityLevel][0];
    80002102:	2189b783          	ld	a5,536(s3)
			p->state = RUNNING;
    80002106:	cf84                	sw	s1,24(a5)
			p = multifeedbackqueue.proc[priorityLevel][0];
    80002108:	0189b903          	ld	s2,24(s3)
			p->state = RUNNING;
    8000210c:	00992c23          	sw	s1,24(s2)
		swtch(&c->context, &p->context);	
    80002110:	07090593          	add	a1,s2,112
    80002114:	8556                	mv	a0,s5
    80002116:	00000097          	auipc	ra,0x0
    8000211a:	6b0080e7          	jalr	1712(ra) # 800027c6 <swtch>
		p->ticks += ticks - ticksNum;
    8000211e:	04492703          	lw	a4,68(s2)
    80002122:	000b2783          	lw	a5,0(s6)
    80002126:	9fb9                	addw	a5,a5,a4
    80002128:	04f92223          	sw	a5,68(s2)
		release(&wait_lock);
    8000212c:	8552                	mv	a0,s4
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	c52080e7          	jalr	-942(ra) # 80000d80 <release>
	for (;;){
    80002136:	b755                	j	800020da <scheduler+0x8a>

0000000080002138 <sched>:
{
    80002138:	7179                	add	sp,sp,-48
    8000213a:	f406                	sd	ra,40(sp)
    8000213c:	f022                	sd	s0,32(sp)
    8000213e:	ec26                	sd	s1,24(sp)
    80002140:	e84a                	sd	s2,16(sp)
    80002142:	e44e                	sd	s3,8(sp)
    80002144:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	9c4080e7          	jalr	-1596(ra) # 80001b0a <myproc>
    8000214e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	b02080e7          	jalr	-1278(ra) # 80000c52 <holding>
    80002158:	c559                	beqz	a0,800021e6 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000215a:	8712                	mv	a4,tp
  if(mycpu()->noff != 1)
    8000215c:	2701                	sext.w	a4,a4
    8000215e:	00471793          	sll	a5,a4,0x4
    80002162:	97ba                	add	a5,a5,a4
    80002164:	078e                	sll	a5,a5,0x3
    80002166:	0000f717          	auipc	a4,0xf
    8000216a:	8ca70713          	add	a4,a4,-1846 # 80010a30 <pid_lock>
    8000216e:	97ba                	add	a5,a5,a4
    80002170:	0a87a703          	lw	a4,168(a5)
    80002174:	4785                	li	a5,1
    80002176:	08f71063          	bne	a4,a5,800021f6 <sched+0xbe>
  if(p->state == RUNNING)
    8000217a:	4c98                	lw	a4,24(s1)
    8000217c:	4791                	li	a5,4
    8000217e:	08f70463          	beq	a4,a5,80002206 <sched+0xce>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002182:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002186:	8b89                	and	a5,a5,2
  if(intr_get())
    80002188:	e7d9                	bnez	a5,80002216 <sched+0xde>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000218a:	8712                	mv	a4,tp
  intena = mycpu()->intena;
    8000218c:	0000f917          	auipc	s2,0xf
    80002190:	8a490913          	add	s2,s2,-1884 # 80010a30 <pid_lock>
    80002194:	2701                	sext.w	a4,a4
    80002196:	00471793          	sll	a5,a4,0x4
    8000219a:	97ba                	add	a5,a5,a4
    8000219c:	078e                	sll	a5,a5,0x3
    8000219e:	97ca                	add	a5,a5,s2
    800021a0:	0ac7a983          	lw	s3,172(a5)
    800021a4:	8712                	mv	a4,tp
  swtch(&p->context, &mycpu()->context);
    800021a6:	2701                	sext.w	a4,a4
    800021a8:	00471793          	sll	a5,a4,0x4
    800021ac:	97ba                	add	a5,a5,a4
    800021ae:	078e                	sll	a5,a5,0x3
    800021b0:	0000f597          	auipc	a1,0xf
    800021b4:	8b858593          	add	a1,a1,-1864 # 80010a68 <cpus+0x8>
    800021b8:	95be                	add	a1,a1,a5
    800021ba:	07048513          	add	a0,s1,112
    800021be:	00000097          	auipc	ra,0x0
    800021c2:	608080e7          	jalr	1544(ra) # 800027c6 <swtch>
    800021c6:	8712                	mv	a4,tp
  mycpu()->intena = intena;
    800021c8:	2701                	sext.w	a4,a4
    800021ca:	00471793          	sll	a5,a4,0x4
    800021ce:	97ba                	add	a5,a5,a4
    800021d0:	078e                	sll	a5,a5,0x3
    800021d2:	993e                	add	s2,s2,a5
    800021d4:	0b392623          	sw	s3,172(s2)
}
    800021d8:	70a2                	ld	ra,40(sp)
    800021da:	7402                	ld	s0,32(sp)
    800021dc:	64e2                	ld	s1,24(sp)
    800021de:	6942                	ld	s2,16(sp)
    800021e0:	69a2                	ld	s3,8(sp)
    800021e2:	6145                	add	sp,sp,48
    800021e4:	8082                	ret
    panic("sched p->lock");
    800021e6:	00006517          	auipc	a0,0x6
    800021ea:	06a50513          	add	a0,a0,106 # 80008250 <digits+0x218>
    800021ee:	ffffe097          	auipc	ra,0xffffe
    800021f2:	620080e7          	jalr	1568(ra) # 8000080e <panic>
    panic("sched locks");
    800021f6:	00006517          	auipc	a0,0x6
    800021fa:	06a50513          	add	a0,a0,106 # 80008260 <digits+0x228>
    800021fe:	ffffe097          	auipc	ra,0xffffe
    80002202:	610080e7          	jalr	1552(ra) # 8000080e <panic>
    panic("sched running");
    80002206:	00006517          	auipc	a0,0x6
    8000220a:	06a50513          	add	a0,a0,106 # 80008270 <digits+0x238>
    8000220e:	ffffe097          	auipc	ra,0xffffe
    80002212:	600080e7          	jalr	1536(ra) # 8000080e <panic>
    panic("sched interruptible");
    80002216:	00006517          	auipc	a0,0x6
    8000221a:	06a50513          	add	a0,a0,106 # 80008280 <digits+0x248>
    8000221e:	ffffe097          	auipc	ra,0xffffe
    80002222:	5f0080e7          	jalr	1520(ra) # 8000080e <panic>

0000000080002226 <yield>:
{
    80002226:	1101                	add	sp,sp,-32
    80002228:	ec06                	sd	ra,24(sp)
    8000222a:	e822                	sd	s0,16(sp)
    8000222c:	e426                	sd	s1,8(sp)
    8000222e:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80002230:	00000097          	auipc	ra,0x0
    80002234:	8da080e7          	jalr	-1830(ra) # 80001b0a <myproc>
    80002238:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	a92080e7          	jalr	-1390(ra) # 80000ccc <acquire>
  p->state = RUNNABLE;
    80002242:	478d                	li	a5,3
    80002244:	cc9c                	sw	a5,24(s1)
  sched();
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	ef2080e7          	jalr	-270(ra) # 80002138 <sched>
  release(&p->lock);
    8000224e:	8526                	mv	a0,s1
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	b30080e7          	jalr	-1232(ra) # 80000d80 <release>
}
    80002258:	60e2                	ld	ra,24(sp)
    8000225a:	6442                	ld	s0,16(sp)
    8000225c:	64a2                	ld	s1,8(sp)
    8000225e:	6105                	add	sp,sp,32
    80002260:	8082                	ret

0000000080002262 <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    80002262:	7179                	add	sp,sp,-48
    80002264:	f406                	sd	ra,40(sp)
    80002266:	f022                	sd	s0,32(sp)
    80002268:	ec26                	sd	s1,24(sp)
    8000226a:	e84a                	sd	s2,16(sp)
    8000226c:	e44e                	sd	s3,8(sp)
    8000226e:	1800                	add	s0,sp,48
    80002270:	89aa                	mv	s3,a0
    80002272:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002274:	00000097          	auipc	ra,0x0
    80002278:	896080e7          	jalr	-1898(ra) # 80001b0a <myproc>
    8000227c:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	a4e080e7          	jalr	-1458(ra) # 80000ccc <acquire>
  release(lk);
    80002286:	854a                	mv	a0,s2
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	af8080e7          	jalr	-1288(ra) # 80000d80 <release>

  /* Go to sleep. */
  p->chan = chan;
    80002290:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002294:	4789                	li	a5,2
    80002296:	cc9c                	sw	a5,24(s1)

  sched();
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	ea0080e7          	jalr	-352(ra) # 80002138 <sched>

  /* Tidy up. */
  p->chan = 0;
    800022a0:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    800022a4:	8526                	mv	a0,s1
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	ada080e7          	jalr	-1318(ra) # 80000d80 <release>
  acquire(lk);
    800022ae:	854a                	mv	a0,s2
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	a1c080e7          	jalr	-1508(ra) # 80000ccc <acquire>
}
    800022b8:	70a2                	ld	ra,40(sp)
    800022ba:	7402                	ld	s0,32(sp)
    800022bc:	64e2                	ld	s1,24(sp)
    800022be:	6942                	ld	s2,16(sp)
    800022c0:	69a2                	ld	s3,8(sp)
    800022c2:	6145                	add	sp,sp,48
    800022c4:	8082                	ret

00000000800022c6 <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    800022c6:	7139                	add	sp,sp,-64
    800022c8:	fc06                	sd	ra,56(sp)
    800022ca:	f822                	sd	s0,48(sp)
    800022cc:	f426                	sd	s1,40(sp)
    800022ce:	f04a                	sd	s2,32(sp)
    800022d0:	ec4e                	sd	s3,24(sp)
    800022d2:	e852                	sd	s4,16(sp)
    800022d4:	e456                	sd	s5,8(sp)
    800022d6:	0080                	add	s0,sp,64
    800022d8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800022da:	0000f497          	auipc	s1,0xf
    800022de:	60648493          	add	s1,s1,1542 # 800118e0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800022e2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800022e4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800022e6:	00015917          	auipc	s2,0x15
    800022ea:	3fa90913          	add	s2,s2,1018 # 800176e0 <tickslock>
    800022ee:	a811                	j	80002302 <wakeup+0x3c>
      }
      release(&p->lock);
    800022f0:	8526                	mv	a0,s1
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	a8e080e7          	jalr	-1394(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022fa:	17848493          	add	s1,s1,376
    800022fe:	03248663          	beq	s1,s2,8000232a <wakeup+0x64>
    if(p != myproc()){
    80002302:	00000097          	auipc	ra,0x0
    80002306:	808080e7          	jalr	-2040(ra) # 80001b0a <myproc>
    8000230a:	fea488e3          	beq	s1,a0,800022fa <wakeup+0x34>
      acquire(&p->lock);
    8000230e:	8526                	mv	a0,s1
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	9bc080e7          	jalr	-1604(ra) # 80000ccc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002318:	4c9c                	lw	a5,24(s1)
    8000231a:	fd379be3          	bne	a5,s3,800022f0 <wakeup+0x2a>
    8000231e:	709c                	ld	a5,32(s1)
    80002320:	fd4798e3          	bne	a5,s4,800022f0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002324:	0154ac23          	sw	s5,24(s1)
    80002328:	b7e1                	j	800022f0 <wakeup+0x2a>
    }
  }
}
    8000232a:	70e2                	ld	ra,56(sp)
    8000232c:	7442                	ld	s0,48(sp)
    8000232e:	74a2                	ld	s1,40(sp)
    80002330:	7902                	ld	s2,32(sp)
    80002332:	69e2                	ld	s3,24(sp)
    80002334:	6a42                	ld	s4,16(sp)
    80002336:	6aa2                	ld	s5,8(sp)
    80002338:	6121                	add	sp,sp,64
    8000233a:	8082                	ret

000000008000233c <reparent>:
{
    8000233c:	7179                	add	sp,sp,-48
    8000233e:	f406                	sd	ra,40(sp)
    80002340:	f022                	sd	s0,32(sp)
    80002342:	ec26                	sd	s1,24(sp)
    80002344:	e84a                	sd	s2,16(sp)
    80002346:	e44e                	sd	s3,8(sp)
    80002348:	e052                	sd	s4,0(sp)
    8000234a:	1800                	add	s0,sp,48
    8000234c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000234e:	0000f497          	auipc	s1,0xf
    80002352:	59248493          	add	s1,s1,1426 # 800118e0 <proc>
      pp->parent = initproc;
    80002356:	00006a17          	auipc	s4,0x6
    8000235a:	5a2a0a13          	add	s4,s4,1442 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000235e:	00015997          	auipc	s3,0x15
    80002362:	38298993          	add	s3,s3,898 # 800176e0 <tickslock>
    80002366:	a029                	j	80002370 <reparent+0x34>
    80002368:	17848493          	add	s1,s1,376
    8000236c:	01348d63          	beq	s1,s3,80002386 <reparent+0x4a>
    if(pp->parent == p){
    80002370:	64bc                	ld	a5,72(s1)
    80002372:	ff279be3          	bne	a5,s2,80002368 <reparent+0x2c>
      pp->parent = initproc;
    80002376:	000a3503          	ld	a0,0(s4)
    8000237a:	e4a8                	sd	a0,72(s1)
      wakeup(initproc);
    8000237c:	00000097          	auipc	ra,0x0
    80002380:	f4a080e7          	jalr	-182(ra) # 800022c6 <wakeup>
    80002384:	b7d5                	j	80002368 <reparent+0x2c>
}
    80002386:	70a2                	ld	ra,40(sp)
    80002388:	7402                	ld	s0,32(sp)
    8000238a:	64e2                	ld	s1,24(sp)
    8000238c:	6942                	ld	s2,16(sp)
    8000238e:	69a2                	ld	s3,8(sp)
    80002390:	6a02                	ld	s4,0(sp)
    80002392:	6145                	add	sp,sp,48
    80002394:	8082                	ret

0000000080002396 <exit>:
{
    80002396:	7179                	add	sp,sp,-48
    80002398:	f406                	sd	ra,40(sp)
    8000239a:	f022                	sd	s0,32(sp)
    8000239c:	ec26                	sd	s1,24(sp)
    8000239e:	e84a                	sd	s2,16(sp)
    800023a0:	e44e                	sd	s3,8(sp)
    800023a2:	e052                	sd	s4,0(sp)
    800023a4:	1800                	add	s0,sp,48
    800023a6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	762080e7          	jalr	1890(ra) # 80001b0a <myproc>
    800023b0:	89aa                	mv	s3,a0
  if(p == initproc)
    800023b2:	00006797          	auipc	a5,0x6
    800023b6:	5467b783          	ld	a5,1350(a5) # 800088f8 <initproc>
    800023ba:	0e050493          	add	s1,a0,224
    800023be:	16050913          	add	s2,a0,352
    800023c2:	02a79363          	bne	a5,a0,800023e8 <exit+0x52>
    panic("init exiting");
    800023c6:	00006517          	auipc	a0,0x6
    800023ca:	ed250513          	add	a0,a0,-302 # 80008298 <digits+0x260>
    800023ce:	ffffe097          	auipc	ra,0xffffe
    800023d2:	440080e7          	jalr	1088(ra) # 8000080e <panic>
      fileclose(f);
    800023d6:	00002097          	auipc	ra,0x2
    800023da:	2b8080e7          	jalr	696(ra) # 8000468e <fileclose>
      p->ofile[fd] = 0;
    800023de:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800023e2:	04a1                	add	s1,s1,8
    800023e4:	01248563          	beq	s1,s2,800023ee <exit+0x58>
    if(p->ofile[fd]){
    800023e8:	6088                	ld	a0,0(s1)
    800023ea:	f575                	bnez	a0,800023d6 <exit+0x40>
    800023ec:	bfdd                	j	800023e2 <exit+0x4c>
  begin_op();
    800023ee:	00002097          	auipc	ra,0x2
    800023f2:	ddc080e7          	jalr	-548(ra) # 800041ca <begin_op>
  iput(p->cwd);
    800023f6:	1609b503          	ld	a0,352(s3)
    800023fa:	00001097          	auipc	ra,0x1
    800023fe:	5e4080e7          	jalr	1508(ra) # 800039de <iput>
  end_op();
    80002402:	00002097          	auipc	ra,0x2
    80002406:	e42080e7          	jalr	-446(ra) # 80004244 <end_op>
  p->cwd = 0;
    8000240a:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    8000240e:	0000e497          	auipc	s1,0xe
    80002412:	63a48493          	add	s1,s1,1594 # 80010a48 <wait_lock>
    80002416:	8526                	mv	a0,s1
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	8b4080e7          	jalr	-1868(ra) # 80000ccc <acquire>
  reparent(p);
    80002420:	854e                	mv	a0,s3
    80002422:	00000097          	auipc	ra,0x0
    80002426:	f1a080e7          	jalr	-230(ra) # 8000233c <reparent>
  wakeup(p->parent);
    8000242a:	0489b503          	ld	a0,72(s3)
    8000242e:	00000097          	auipc	ra,0x0
    80002432:	e98080e7          	jalr	-360(ra) # 800022c6 <wakeup>
  acquire(&p->lock);
    80002436:	854e                	mv	a0,s3
    80002438:	fffff097          	auipc	ra,0xfffff
    8000243c:	894080e7          	jalr	-1900(ra) # 80000ccc <acquire>
  p->xstate = status;
    80002440:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002444:	4795                	li	a5,5
    80002446:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000244a:	8526                	mv	a0,s1
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	934080e7          	jalr	-1740(ra) # 80000d80 <release>
  sched();
    80002454:	00000097          	auipc	ra,0x0
    80002458:	ce4080e7          	jalr	-796(ra) # 80002138 <sched>
  panic("zombie exit");
    8000245c:	00006517          	auipc	a0,0x6
    80002460:	e4c50513          	add	a0,a0,-436 # 800082a8 <digits+0x270>
    80002464:	ffffe097          	auipc	ra,0xffffe
    80002468:	3aa080e7          	jalr	938(ra) # 8000080e <panic>

000000008000246c <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    8000246c:	7179                	add	sp,sp,-48
    8000246e:	f406                	sd	ra,40(sp)
    80002470:	f022                	sd	s0,32(sp)
    80002472:	ec26                	sd	s1,24(sp)
    80002474:	e84a                	sd	s2,16(sp)
    80002476:	e44e                	sd	s3,8(sp)
    80002478:	1800                	add	s0,sp,48
    8000247a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000247c:	0000f497          	auipc	s1,0xf
    80002480:	46448493          	add	s1,s1,1124 # 800118e0 <proc>
    80002484:	00015997          	auipc	s3,0x15
    80002488:	25c98993          	add	s3,s3,604 # 800176e0 <tickslock>
    acquire(&p->lock);
    8000248c:	8526                	mv	a0,s1
    8000248e:	fffff097          	auipc	ra,0xfffff
    80002492:	83e080e7          	jalr	-1986(ra) # 80000ccc <acquire>
    if(p->pid == pid){
    80002496:	589c                	lw	a5,48(s1)
    80002498:	01278d63          	beq	a5,s2,800024b2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000249c:	8526                	mv	a0,s1
    8000249e:	fffff097          	auipc	ra,0xfffff
    800024a2:	8e2080e7          	jalr	-1822(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024a6:	17848493          	add	s1,s1,376
    800024aa:	ff3491e3          	bne	s1,s3,8000248c <kill+0x20>
  }
  return -1;
    800024ae:	557d                	li	a0,-1
    800024b0:	a829                	j	800024ca <kill+0x5e>
      p->killed = 1;
    800024b2:	4785                	li	a5,1
    800024b4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800024b6:	4c98                	lw	a4,24(s1)
    800024b8:	4789                	li	a5,2
    800024ba:	00f70f63          	beq	a4,a5,800024d8 <kill+0x6c>
      release(&p->lock);
    800024be:	8526                	mv	a0,s1
    800024c0:	fffff097          	auipc	ra,0xfffff
    800024c4:	8c0080e7          	jalr	-1856(ra) # 80000d80 <release>
      return 0;
    800024c8:	4501                	li	a0,0
}
    800024ca:	70a2                	ld	ra,40(sp)
    800024cc:	7402                	ld	s0,32(sp)
    800024ce:	64e2                	ld	s1,24(sp)
    800024d0:	6942                	ld	s2,16(sp)
    800024d2:	69a2                	ld	s3,8(sp)
    800024d4:	6145                	add	sp,sp,48
    800024d6:	8082                	ret
        p->state = RUNNABLE;
    800024d8:	478d                	li	a5,3
    800024da:	cc9c                	sw	a5,24(s1)
    800024dc:	b7cd                	j	800024be <kill+0x52>

00000000800024de <setkilled>:

void
setkilled(struct proc *p)
{
    800024de:	1101                	add	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	1000                	add	s0,sp,32
    800024e8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800024ea:	ffffe097          	auipc	ra,0xffffe
    800024ee:	7e2080e7          	jalr	2018(ra) # 80000ccc <acquire>
  p->killed = 1;
    800024f2:	4785                	li	a5,1
    800024f4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	fffff097          	auipc	ra,0xfffff
    800024fc:	888080e7          	jalr	-1912(ra) # 80000d80 <release>
}
    80002500:	60e2                	ld	ra,24(sp)
    80002502:	6442                	ld	s0,16(sp)
    80002504:	64a2                	ld	s1,8(sp)
    80002506:	6105                	add	sp,sp,32
    80002508:	8082                	ret

000000008000250a <killed>:

int
killed(struct proc *p)
{
    8000250a:	1101                	add	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	e04a                	sd	s2,0(sp)
    80002514:	1000                	add	s0,sp,32
    80002516:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002518:	ffffe097          	auipc	ra,0xffffe
    8000251c:	7b4080e7          	jalr	1972(ra) # 80000ccc <acquire>
  k = p->killed;
    80002520:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002524:	8526                	mv	a0,s1
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	85a080e7          	jalr	-1958(ra) # 80000d80 <release>
  return k;
}
    8000252e:	854a                	mv	a0,s2
    80002530:	60e2                	ld	ra,24(sp)
    80002532:	6442                	ld	s0,16(sp)
    80002534:	64a2                	ld	s1,8(sp)
    80002536:	6902                	ld	s2,0(sp)
    80002538:	6105                	add	sp,sp,32
    8000253a:	8082                	ret

000000008000253c <wait>:
{
    8000253c:	715d                	add	sp,sp,-80
    8000253e:	e486                	sd	ra,72(sp)
    80002540:	e0a2                	sd	s0,64(sp)
    80002542:	fc26                	sd	s1,56(sp)
    80002544:	f84a                	sd	s2,48(sp)
    80002546:	f44e                	sd	s3,40(sp)
    80002548:	f052                	sd	s4,32(sp)
    8000254a:	ec56                	sd	s5,24(sp)
    8000254c:	e85a                	sd	s6,16(sp)
    8000254e:	e45e                	sd	s7,8(sp)
    80002550:	e062                	sd	s8,0(sp)
    80002552:	0880                	add	s0,sp,80
    80002554:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002556:	fffff097          	auipc	ra,0xfffff
    8000255a:	5b4080e7          	jalr	1460(ra) # 80001b0a <myproc>
    8000255e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002560:	0000e517          	auipc	a0,0xe
    80002564:	4e850513          	add	a0,a0,1256 # 80010a48 <wait_lock>
    80002568:	ffffe097          	auipc	ra,0xffffe
    8000256c:	764080e7          	jalr	1892(ra) # 80000ccc <acquire>
    havekids = 0;
    80002570:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002572:	4a15                	li	s4,5
        havekids = 1;
    80002574:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002576:	00015997          	auipc	s3,0x15
    8000257a:	16a98993          	add	s3,s3,362 # 800176e0 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    8000257e:	0000ec17          	auipc	s8,0xe
    80002582:	4cac0c13          	add	s8,s8,1226 # 80010a48 <wait_lock>
    80002586:	a0d1                	j	8000264a <wait+0x10e>
          pid = pp->pid;
    80002588:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000258c:	000b0e63          	beqz	s6,800025a8 <wait+0x6c>
    80002590:	4691                	li	a3,4
    80002592:	02c48613          	add	a2,s1,44
    80002596:	85da                	mv	a1,s6
    80002598:	06093503          	ld	a0,96(s2)
    8000259c:	fffff097          	auipc	ra,0xfffff
    800025a0:	1e8080e7          	jalr	488(ra) # 80001784 <copyout>
    800025a4:	04054163          	bltz	a0,800025e6 <wait+0xaa>
          freeproc(pp);
    800025a8:	8526                	mv	a0,s1
    800025aa:	fffff097          	auipc	ra,0xfffff
    800025ae:	71c080e7          	jalr	1820(ra) # 80001cc6 <freeproc>
          release(&pp->lock);
    800025b2:	8526                	mv	a0,s1
    800025b4:	ffffe097          	auipc	ra,0xffffe
    800025b8:	7cc080e7          	jalr	1996(ra) # 80000d80 <release>
          release(&wait_lock);
    800025bc:	0000e517          	auipc	a0,0xe
    800025c0:	48c50513          	add	a0,a0,1164 # 80010a48 <wait_lock>
    800025c4:	ffffe097          	auipc	ra,0xffffe
    800025c8:	7bc080e7          	jalr	1980(ra) # 80000d80 <release>
}
    800025cc:	854e                	mv	a0,s3
    800025ce:	60a6                	ld	ra,72(sp)
    800025d0:	6406                	ld	s0,64(sp)
    800025d2:	74e2                	ld	s1,56(sp)
    800025d4:	7942                	ld	s2,48(sp)
    800025d6:	79a2                	ld	s3,40(sp)
    800025d8:	7a02                	ld	s4,32(sp)
    800025da:	6ae2                	ld	s5,24(sp)
    800025dc:	6b42                	ld	s6,16(sp)
    800025de:	6ba2                	ld	s7,8(sp)
    800025e0:	6c02                	ld	s8,0(sp)
    800025e2:	6161                	add	sp,sp,80
    800025e4:	8082                	ret
            release(&pp->lock);
    800025e6:	8526                	mv	a0,s1
    800025e8:	ffffe097          	auipc	ra,0xffffe
    800025ec:	798080e7          	jalr	1944(ra) # 80000d80 <release>
            release(&wait_lock);
    800025f0:	0000e517          	auipc	a0,0xe
    800025f4:	45850513          	add	a0,a0,1112 # 80010a48 <wait_lock>
    800025f8:	ffffe097          	auipc	ra,0xffffe
    800025fc:	788080e7          	jalr	1928(ra) # 80000d80 <release>
            return -1;
    80002600:	59fd                	li	s3,-1
    80002602:	b7e9                	j	800025cc <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002604:	17848493          	add	s1,s1,376
    80002608:	03348463          	beq	s1,s3,80002630 <wait+0xf4>
      if(pp->parent == p){
    8000260c:	64bc                	ld	a5,72(s1)
    8000260e:	ff279be3          	bne	a5,s2,80002604 <wait+0xc8>
        acquire(&pp->lock);
    80002612:	8526                	mv	a0,s1
    80002614:	ffffe097          	auipc	ra,0xffffe
    80002618:	6b8080e7          	jalr	1720(ra) # 80000ccc <acquire>
        if(pp->state == ZOMBIE){
    8000261c:	4c9c                	lw	a5,24(s1)
    8000261e:	f74785e3          	beq	a5,s4,80002588 <wait+0x4c>
        release(&pp->lock);
    80002622:	8526                	mv	a0,s1
    80002624:	ffffe097          	auipc	ra,0xffffe
    80002628:	75c080e7          	jalr	1884(ra) # 80000d80 <release>
        havekids = 1;
    8000262c:	8756                	mv	a4,s5
    8000262e:	bfd9                	j	80002604 <wait+0xc8>
    if(!havekids || killed(p)){
    80002630:	c31d                	beqz	a4,80002656 <wait+0x11a>
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	ed6080e7          	jalr	-298(ra) # 8000250a <killed>
    8000263c:	ed09                	bnez	a0,80002656 <wait+0x11a>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    8000263e:	85e2                	mv	a1,s8
    80002640:	854a                	mv	a0,s2
    80002642:	00000097          	auipc	ra,0x0
    80002646:	c20080e7          	jalr	-992(ra) # 80002262 <sleep>
    havekids = 0;
    8000264a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000264c:	0000f497          	auipc	s1,0xf
    80002650:	29448493          	add	s1,s1,660 # 800118e0 <proc>
    80002654:	bf65                	j	8000260c <wait+0xd0>
      release(&wait_lock);
    80002656:	0000e517          	auipc	a0,0xe
    8000265a:	3f250513          	add	a0,a0,1010 # 80010a48 <wait_lock>
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	722080e7          	jalr	1826(ra) # 80000d80 <release>
      return -1;
    80002666:	59fd                	li	s3,-1
    80002668:	b795                	j	800025cc <wait+0x90>

000000008000266a <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000266a:	7179                	add	sp,sp,-48
    8000266c:	f406                	sd	ra,40(sp)
    8000266e:	f022                	sd	s0,32(sp)
    80002670:	ec26                	sd	s1,24(sp)
    80002672:	e84a                	sd	s2,16(sp)
    80002674:	e44e                	sd	s3,8(sp)
    80002676:	e052                	sd	s4,0(sp)
    80002678:	1800                	add	s0,sp,48
    8000267a:	84aa                	mv	s1,a0
    8000267c:	892e                	mv	s2,a1
    8000267e:	89b2                	mv	s3,a2
    80002680:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002682:	fffff097          	auipc	ra,0xfffff
    80002686:	488080e7          	jalr	1160(ra) # 80001b0a <myproc>
  if(user_dst){
    8000268a:	c08d                	beqz	s1,800026ac <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000268c:	86d2                	mv	a3,s4
    8000268e:	864e                	mv	a2,s3
    80002690:	85ca                	mv	a1,s2
    80002692:	7128                	ld	a0,96(a0)
    80002694:	fffff097          	auipc	ra,0xfffff
    80002698:	0f0080e7          	jalr	240(ra) # 80001784 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000269c:	70a2                	ld	ra,40(sp)
    8000269e:	7402                	ld	s0,32(sp)
    800026a0:	64e2                	ld	s1,24(sp)
    800026a2:	6942                	ld	s2,16(sp)
    800026a4:	69a2                	ld	s3,8(sp)
    800026a6:	6a02                	ld	s4,0(sp)
    800026a8:	6145                	add	sp,sp,48
    800026aa:	8082                	ret
    memmove((char *)dst, src, len);
    800026ac:	000a061b          	sext.w	a2,s4
    800026b0:	85ce                	mv	a1,s3
    800026b2:	854a                	mv	a0,s2
    800026b4:	ffffe097          	auipc	ra,0xffffe
    800026b8:	770080e7          	jalr	1904(ra) # 80000e24 <memmove>
    return 0;
    800026bc:	8526                	mv	a0,s1
    800026be:	bff9                	j	8000269c <either_copyout+0x32>

00000000800026c0 <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800026c0:	7179                	add	sp,sp,-48
    800026c2:	f406                	sd	ra,40(sp)
    800026c4:	f022                	sd	s0,32(sp)
    800026c6:	ec26                	sd	s1,24(sp)
    800026c8:	e84a                	sd	s2,16(sp)
    800026ca:	e44e                	sd	s3,8(sp)
    800026cc:	e052                	sd	s4,0(sp)
    800026ce:	1800                	add	s0,sp,48
    800026d0:	892a                	mv	s2,a0
    800026d2:	84ae                	mv	s1,a1
    800026d4:	89b2                	mv	s3,a2
    800026d6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026d8:	fffff097          	auipc	ra,0xfffff
    800026dc:	432080e7          	jalr	1074(ra) # 80001b0a <myproc>
  if(user_src){
    800026e0:	c08d                	beqz	s1,80002702 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800026e2:	86d2                	mv	a3,s4
    800026e4:	864e                	mv	a2,s3
    800026e6:	85ca                	mv	a1,s2
    800026e8:	7128                	ld	a0,96(a0)
    800026ea:	fffff097          	auipc	ra,0xfffff
    800026ee:	15a080e7          	jalr	346(ra) # 80001844 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800026f2:	70a2                	ld	ra,40(sp)
    800026f4:	7402                	ld	s0,32(sp)
    800026f6:	64e2                	ld	s1,24(sp)
    800026f8:	6942                	ld	s2,16(sp)
    800026fa:	69a2                	ld	s3,8(sp)
    800026fc:	6a02                	ld	s4,0(sp)
    800026fe:	6145                	add	sp,sp,48
    80002700:	8082                	ret
    memmove(dst, (char*)src, len);
    80002702:	000a061b          	sext.w	a2,s4
    80002706:	85ce                	mv	a1,s3
    80002708:	854a                	mv	a0,s2
    8000270a:	ffffe097          	auipc	ra,0xffffe
    8000270e:	71a080e7          	jalr	1818(ra) # 80000e24 <memmove>
    return 0;
    80002712:	8526                	mv	a0,s1
    80002714:	bff9                	j	800026f2 <either_copyin+0x32>

0000000080002716 <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    80002716:	715d                	add	sp,sp,-80
    80002718:	e486                	sd	ra,72(sp)
    8000271a:	e0a2                	sd	s0,64(sp)
    8000271c:	fc26                	sd	s1,56(sp)
    8000271e:	f84a                	sd	s2,48(sp)
    80002720:	f44e                	sd	s3,40(sp)
    80002722:	f052                	sd	s4,32(sp)
    80002724:	ec56                	sd	s5,24(sp)
    80002726:	e85a                	sd	s6,16(sp)
    80002728:	e45e                	sd	s7,8(sp)
    8000272a:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000272c:	00006517          	auipc	a0,0x6
    80002730:	99450513          	add	a0,a0,-1644 # 800080c0 <digits+0x88>
    80002734:	ffffe097          	auipc	ra,0xffffe
    80002738:	dce080e7          	jalr	-562(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000273c:	0000f497          	auipc	s1,0xf
    80002740:	30c48493          	add	s1,s1,780 # 80011a48 <proc+0x168>
    80002744:	00015917          	auipc	s2,0x15
    80002748:	10490913          	add	s2,s2,260 # 80017848 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000274c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000274e:	00006997          	auipc	s3,0x6
    80002752:	b6a98993          	add	s3,s3,-1174 # 800082b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002756:	00006a97          	auipc	s5,0x6
    8000275a:	b6aa8a93          	add	s5,s5,-1174 # 800082c0 <digits+0x288>
    printf("\n");
    8000275e:	00006a17          	auipc	s4,0x6
    80002762:	962a0a13          	add	s4,s4,-1694 # 800080c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002766:	00006b97          	auipc	s7,0x6
    8000276a:	b9ab8b93          	add	s7,s7,-1126 # 80008300 <states.0>
    8000276e:	a00d                	j	80002790 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002770:	ec86a583          	lw	a1,-312(a3)
    80002774:	8556                	mv	a0,s5
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	d8c080e7          	jalr	-628(ra) # 80000502 <printf>
    printf("\n");
    8000277e:	8552                	mv	a0,s4
    80002780:	ffffe097          	auipc	ra,0xffffe
    80002784:	d82080e7          	jalr	-638(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002788:	17848493          	add	s1,s1,376
    8000278c:	03248263          	beq	s1,s2,800027b0 <procdump+0x9a>
    if(p->state == UNUSED)
    80002790:	86a6                	mv	a3,s1
    80002792:	eb04a783          	lw	a5,-336(s1)
    80002796:	dbed                	beqz	a5,80002788 <procdump+0x72>
      state = "???";
    80002798:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000279a:	fcfb6be3          	bltu	s6,a5,80002770 <procdump+0x5a>
    8000279e:	02079713          	sll	a4,a5,0x20
    800027a2:	01d75793          	srl	a5,a4,0x1d
    800027a6:	97de                	add	a5,a5,s7
    800027a8:	6390                	ld	a2,0(a5)
    800027aa:	f279                	bnez	a2,80002770 <procdump+0x5a>
      state = "???";
    800027ac:	864e                	mv	a2,s3
    800027ae:	b7c9                	j	80002770 <procdump+0x5a>
  }
}
    800027b0:	60a6                	ld	ra,72(sp)
    800027b2:	6406                	ld	s0,64(sp)
    800027b4:	74e2                	ld	s1,56(sp)
    800027b6:	7942                	ld	s2,48(sp)
    800027b8:	79a2                	ld	s3,40(sp)
    800027ba:	7a02                	ld	s4,32(sp)
    800027bc:	6ae2                	ld	s5,24(sp)
    800027be:	6b42                	ld	s6,16(sp)
    800027c0:	6ba2                	ld	s7,8(sp)
    800027c2:	6161                	add	sp,sp,80
    800027c4:	8082                	ret

00000000800027c6 <swtch>:
    800027c6:	00153023          	sd	ra,0(a0)
    800027ca:	00253423          	sd	sp,8(a0)
    800027ce:	e900                	sd	s0,16(a0)
    800027d0:	ed04                	sd	s1,24(a0)
    800027d2:	03253023          	sd	s2,32(a0)
    800027d6:	03353423          	sd	s3,40(a0)
    800027da:	03453823          	sd	s4,48(a0)
    800027de:	03553c23          	sd	s5,56(a0)
    800027e2:	05653023          	sd	s6,64(a0)
    800027e6:	05753423          	sd	s7,72(a0)
    800027ea:	05853823          	sd	s8,80(a0)
    800027ee:	05953c23          	sd	s9,88(a0)
    800027f2:	07a53023          	sd	s10,96(a0)
    800027f6:	07b53423          	sd	s11,104(a0)
    800027fa:	0005b083          	ld	ra,0(a1)
    800027fe:	0085b103          	ld	sp,8(a1)
    80002802:	6980                	ld	s0,16(a1)
    80002804:	6d84                	ld	s1,24(a1)
    80002806:	0205b903          	ld	s2,32(a1)
    8000280a:	0285b983          	ld	s3,40(a1)
    8000280e:	0305ba03          	ld	s4,48(a1)
    80002812:	0385ba83          	ld	s5,56(a1)
    80002816:	0405bb03          	ld	s6,64(a1)
    8000281a:	0485bb83          	ld	s7,72(a1)
    8000281e:	0505bc03          	ld	s8,80(a1)
    80002822:	0585bc83          	ld	s9,88(a1)
    80002826:	0605bd03          	ld	s10,96(a1)
    8000282a:	0685bd83          	ld	s11,104(a1)
    8000282e:	8082                	ret

0000000080002830 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002830:	1141                	add	sp,sp,-16
    80002832:	e406                	sd	ra,8(sp)
    80002834:	e022                	sd	s0,0(sp)
    80002836:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002838:	00006597          	auipc	a1,0x6
    8000283c:	af858593          	add	a1,a1,-1288 # 80008330 <states.0+0x30>
    80002840:	00015517          	auipc	a0,0x15
    80002844:	ea050513          	add	a0,a0,-352 # 800176e0 <tickslock>
    80002848:	ffffe097          	auipc	ra,0xffffe
    8000284c:	3f4080e7          	jalr	1012(ra) # 80000c3c <initlock>
}
    80002850:	60a2                	ld	ra,8(sp)
    80002852:	6402                	ld	s0,0(sp)
    80002854:	0141                	add	sp,sp,16
    80002856:	8082                	ret

0000000080002858 <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    80002858:	1141                	add	sp,sp,-16
    8000285a:	e422                	sd	s0,8(sp)
    8000285c:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000285e:	00003797          	auipc	a5,0x3
    80002862:	45278793          	add	a5,a5,1106 # 80005cb0 <kernelvec>
    80002866:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000286a:	6422                	ld	s0,8(sp)
    8000286c:	0141                	add	sp,sp,16
    8000286e:	8082                	ret

0000000080002870 <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    80002870:	1141                	add	sp,sp,-16
    80002872:	e406                	sd	ra,8(sp)
    80002874:	e022                	sd	s0,0(sp)
    80002876:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002878:	fffff097          	auipc	ra,0xfffff
    8000287c:	292080e7          	jalr	658(ra) # 80001b0a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002880:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002884:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002886:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000288a:	00004697          	auipc	a3,0x4
    8000288e:	77668693          	add	a3,a3,1910 # 80007000 <_trampoline>
    80002892:	00004717          	auipc	a4,0x4
    80002896:	76e70713          	add	a4,a4,1902 # 80007000 <_trampoline>
    8000289a:	8f15                	sub	a4,a4,a3
    8000289c:	040007b7          	lui	a5,0x4000
    800028a0:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800028a2:	07b2                	sll	a5,a5,0xc
    800028a4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    800028aa:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800028ac:	18002673          	csrr	a2,satp
    800028b0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    800028b2:	7530                	ld	a2,104(a0)
    800028b4:	6938                	ld	a4,80(a0)
    800028b6:	6585                	lui	a1,0x1
    800028b8:	972e                	add	a4,a4,a1
    800028ba:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800028bc:	7538                	ld	a4,104(a0)
    800028be:	00000617          	auipc	a2,0x0
    800028c2:	13460613          	add	a2,a2,308 # 800029f2 <usertrap>
    800028c6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    800028c8:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800028ca:	8612                	mv	a2,tp
    800028cc:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ce:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    800028d2:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    800028d6:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028da:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    800028de:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028e0:	6f18                	ld	a4,24(a4)
    800028e2:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    800028e6:	7128                	ld	a0,96(a0)
    800028e8:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800028ea:	00004717          	auipc	a4,0x4
    800028ee:	7b270713          	add	a4,a4,1970 # 8000709c <userret>
    800028f2:	8f15                	sub	a4,a4,a3
    800028f4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800028f6:	577d                	li	a4,-1
    800028f8:	177e                	sll	a4,a4,0x3f
    800028fa:	8d59                	or	a0,a0,a4
    800028fc:	9782                	jalr	a5
}
    800028fe:	60a2                	ld	ra,8(sp)
    80002900:	6402                	ld	s0,0(sp)
    80002902:	0141                	add	sp,sp,16
    80002904:	8082                	ret

0000000080002906 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002906:	1101                	add	sp,sp,-32
    80002908:	ec06                	sd	ra,24(sp)
    8000290a:	e822                	sd	s0,16(sp)
    8000290c:	e426                	sd	s1,8(sp)
    8000290e:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    80002910:	fffff097          	auipc	ra,0xfffff
    80002914:	1c8080e7          	jalr	456(ra) # 80001ad8 <cpuid>
    80002918:	cd19                	beqz	a0,80002936 <clockintr+0x30>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000291a:	c01027f3          	rdtime	a5
  }

  /* ask for the next timer interrupt. this also clears */
  /* the interrupt request. 1000000 is about a tenth */
  /* of a second. */
  w_stimecmp(r_time() + 1000000);
    8000291e:	000f4737          	lui	a4,0xf4
    80002922:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002926:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002928:	14d79073          	csrw	stimecmp,a5
}
    8000292c:	60e2                	ld	ra,24(sp)
    8000292e:	6442                	ld	s0,16(sp)
    80002930:	64a2                	ld	s1,8(sp)
    80002932:	6105                	add	sp,sp,32
    80002934:	8082                	ret
    acquire(&tickslock);
    80002936:	00015497          	auipc	s1,0x15
    8000293a:	daa48493          	add	s1,s1,-598 # 800176e0 <tickslock>
    8000293e:	8526                	mv	a0,s1
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	38c080e7          	jalr	908(ra) # 80000ccc <acquire>
    ticks++;
    80002948:	00006517          	auipc	a0,0x6
    8000294c:	fb850513          	add	a0,a0,-72 # 80008900 <ticks>
    80002950:	411c                	lw	a5,0(a0)
    80002952:	2785                	addw	a5,a5,1
    80002954:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002956:	00000097          	auipc	ra,0x0
    8000295a:	970080e7          	jalr	-1680(ra) # 800022c6 <wakeup>
    release(&tickslock);
    8000295e:	8526                	mv	a0,s1
    80002960:	ffffe097          	auipc	ra,0xffffe
    80002964:	420080e7          	jalr	1056(ra) # 80000d80 <release>
    80002968:	bf4d                	j	8000291a <clockintr+0x14>

000000008000296a <devintr>:
/* returns 2 if timer interrupt, */
/* 1 if other device, */
/* 0 if not recognized. */
int
devintr()
{
    8000296a:	1101                	add	sp,sp,-32
    8000296c:	ec06                	sd	ra,24(sp)
    8000296e:	e822                	sd	s0,16(sp)
    80002970:	e426                	sd	s1,8(sp)
    80002972:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002974:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002978:	57fd                	li	a5,-1
    8000297a:	17fe                	sll	a5,a5,0x3f
    8000297c:	07a5                	add	a5,a5,9
    8000297e:	00f70d63          	beq	a4,a5,80002998 <devintr+0x2e>
    /* now allowed to interrupt again. */
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002982:	57fd                	li	a5,-1
    80002984:	17fe                	sll	a5,a5,0x3f
    80002986:	0795                	add	a5,a5,5
    /* timer interrupt. */
    clockintr();
    return 2;
  } else {
    return 0;
    80002988:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000298a:	04f70e63          	beq	a4,a5,800029e6 <devintr+0x7c>
  }
}
    8000298e:	60e2                	ld	ra,24(sp)
    80002990:	6442                	ld	s0,16(sp)
    80002992:	64a2                	ld	s1,8(sp)
    80002994:	6105                	add	sp,sp,32
    80002996:	8082                	ret
    int irq = plic_claim();
    80002998:	00003097          	auipc	ra,0x3
    8000299c:	3c4080e7          	jalr	964(ra) # 80005d5c <plic_claim>
    800029a0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800029a2:	47a9                	li	a5,10
    800029a4:	02f50763          	beq	a0,a5,800029d2 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    800029a8:	4785                	li	a5,1
    800029aa:	02f50963          	beq	a0,a5,800029dc <devintr+0x72>
    return 1;
    800029ae:	4505                	li	a0,1
    } else if(irq){
    800029b0:	dcf9                	beqz	s1,8000298e <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    800029b2:	85a6                	mv	a1,s1
    800029b4:	00006517          	auipc	a0,0x6
    800029b8:	98450513          	add	a0,a0,-1660 # 80008338 <states.0+0x38>
    800029bc:	ffffe097          	auipc	ra,0xffffe
    800029c0:	b46080e7          	jalr	-1210(ra) # 80000502 <printf>
      plic_complete(irq);
    800029c4:	8526                	mv	a0,s1
    800029c6:	00003097          	auipc	ra,0x3
    800029ca:	3ba080e7          	jalr	954(ra) # 80005d80 <plic_complete>
    return 1;
    800029ce:	4505                	li	a0,1
    800029d0:	bf7d                	j	8000298e <devintr+0x24>
      uartintr();
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	0bc080e7          	jalr	188(ra) # 80000a8e <uartintr>
    if(irq)
    800029da:	b7ed                	j	800029c4 <devintr+0x5a>
      virtio_disk_intr();
    800029dc:	00004097          	auipc	ra,0x4
    800029e0:	86a080e7          	jalr	-1942(ra) # 80006246 <virtio_disk_intr>
    if(irq)
    800029e4:	b7c5                	j	800029c4 <devintr+0x5a>
    clockintr();
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	f20080e7          	jalr	-224(ra) # 80002906 <clockintr>
    return 2;
    800029ee:	4509                	li	a0,2
    800029f0:	bf79                	j	8000298e <devintr+0x24>

00000000800029f2 <usertrap>:
{
    800029f2:	1101                	add	sp,sp,-32
    800029f4:	ec06                	sd	ra,24(sp)
    800029f6:	e822                	sd	s0,16(sp)
    800029f8:	e426                	sd	s1,8(sp)
    800029fa:	e04a                	sd	s2,0(sp)
    800029fc:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029fe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a02:	1007f793          	and	a5,a5,256
    80002a06:	e3b1                	bnez	a5,80002a4a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a08:	00003797          	auipc	a5,0x3
    80002a0c:	2a878793          	add	a5,a5,680 # 80005cb0 <kernelvec>
    80002a10:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a14:	fffff097          	auipc	ra,0xfffff
    80002a18:	0f6080e7          	jalr	246(ra) # 80001b0a <myproc>
    80002a1c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002a1e:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a20:	14102773          	csrr	a4,sepc
    80002a24:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a26:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002a2a:	47a1                	li	a5,8
    80002a2c:	02f70763          	beq	a4,a5,80002a5a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	f3a080e7          	jalr	-198(ra) # 8000296a <devintr>
    80002a38:	892a                	mv	s2,a0
    80002a3a:	c151                	beqz	a0,80002abe <usertrap+0xcc>
  if(killed(p))
    80002a3c:	8526                	mv	a0,s1
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	acc080e7          	jalr	-1332(ra) # 8000250a <killed>
    80002a46:	c929                	beqz	a0,80002a98 <usertrap+0xa6>
    80002a48:	a099                	j	80002a8e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002a4a:	00006517          	auipc	a0,0x6
    80002a4e:	90e50513          	add	a0,a0,-1778 # 80008358 <states.0+0x58>
    80002a52:	ffffe097          	auipc	ra,0xffffe
    80002a56:	dbc080e7          	jalr	-580(ra) # 8000080e <panic>
    if(killed(p))
    80002a5a:	00000097          	auipc	ra,0x0
    80002a5e:	ab0080e7          	jalr	-1360(ra) # 8000250a <killed>
    80002a62:	e921                	bnez	a0,80002ab2 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002a64:	74b8                	ld	a4,104(s1)
    80002a66:	6f1c                	ld	a5,24(a4)
    80002a68:	0791                	add	a5,a5,4
    80002a6a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a6c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a70:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a74:	10079073          	csrw	sstatus,a5
    syscall();
    80002a78:	00000097          	auipc	ra,0x0
    80002a7c:	2b4080e7          	jalr	692(ra) # 80002d2c <syscall>
  if(killed(p))
    80002a80:	8526                	mv	a0,s1
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	a88080e7          	jalr	-1400(ra) # 8000250a <killed>
    80002a8a:	c911                	beqz	a0,80002a9e <usertrap+0xac>
    80002a8c:	4901                	li	s2,0
    exit(-1);
    80002a8e:	557d                	li	a0,-1
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	906080e7          	jalr	-1786(ra) # 80002396 <exit>
  if(which_dev == 2)
    80002a98:	4789                	li	a5,2
    80002a9a:	04f90f63          	beq	s2,a5,80002af8 <usertrap+0x106>
  usertrapret();
    80002a9e:	00000097          	auipc	ra,0x0
    80002aa2:	dd2080e7          	jalr	-558(ra) # 80002870 <usertrapret>
}
    80002aa6:	60e2                	ld	ra,24(sp)
    80002aa8:	6442                	ld	s0,16(sp)
    80002aaa:	64a2                	ld	s1,8(sp)
    80002aac:	6902                	ld	s2,0(sp)
    80002aae:	6105                	add	sp,sp,32
    80002ab0:	8082                	ret
      exit(-1);
    80002ab2:	557d                	li	a0,-1
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	8e2080e7          	jalr	-1822(ra) # 80002396 <exit>
    80002abc:	b765                	j	80002a64 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002abe:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002ac2:	5890                	lw	a2,48(s1)
    80002ac4:	00006517          	auipc	a0,0x6
    80002ac8:	8b450513          	add	a0,a0,-1868 # 80008378 <states.0+0x78>
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	a36080e7          	jalr	-1482(ra) # 80000502 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ad4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ad8:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002adc:	00006517          	auipc	a0,0x6
    80002ae0:	8cc50513          	add	a0,a0,-1844 # 800083a8 <states.0+0xa8>
    80002ae4:	ffffe097          	auipc	ra,0xffffe
    80002ae8:	a1e080e7          	jalr	-1506(ra) # 80000502 <printf>
    setkilled(p);
    80002aec:	8526                	mv	a0,s1
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	9f0080e7          	jalr	-1552(ra) # 800024de <setkilled>
    80002af6:	b769                	j	80002a80 <usertrap+0x8e>
    yield();
    80002af8:	fffff097          	auipc	ra,0xfffff
    80002afc:	72e080e7          	jalr	1838(ra) # 80002226 <yield>
    80002b00:	bf79                	j	80002a9e <usertrap+0xac>

0000000080002b02 <kerneltrap>:
{
    80002b02:	7179                	add	sp,sp,-48
    80002b04:	f406                	sd	ra,40(sp)
    80002b06:	f022                	sd	s0,32(sp)
    80002b08:	ec26                	sd	s1,24(sp)
    80002b0a:	e84a                	sd	s2,16(sp)
    80002b0c:	e44e                	sd	s3,8(sp)
    80002b0e:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b10:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b14:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b18:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002b1c:	1004f793          	and	a5,s1,256
    80002b20:	cb85                	beqz	a5,80002b50 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b22:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002b26:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002b28:	ef85                	bnez	a5,80002b60 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002b2a:	00000097          	auipc	ra,0x0
    80002b2e:	e40080e7          	jalr	-448(ra) # 8000296a <devintr>
    80002b32:	cd1d                	beqz	a0,80002b70 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0)
    80002b34:	4789                	li	a5,2
    80002b36:	06f50263          	beq	a0,a5,80002b9a <kerneltrap+0x98>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b3a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b3e:	10049073          	csrw	sstatus,s1
}
    80002b42:	70a2                	ld	ra,40(sp)
    80002b44:	7402                	ld	s0,32(sp)
    80002b46:	64e2                	ld	s1,24(sp)
    80002b48:	6942                	ld	s2,16(sp)
    80002b4a:	69a2                	ld	s3,8(sp)
    80002b4c:	6145                	add	sp,sp,48
    80002b4e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002b50:	00006517          	auipc	a0,0x6
    80002b54:	88050513          	add	a0,a0,-1920 # 800083d0 <states.0+0xd0>
    80002b58:	ffffe097          	auipc	ra,0xffffe
    80002b5c:	cb6080e7          	jalr	-842(ra) # 8000080e <panic>
    panic("kerneltrap: interrupts enabled");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	89850513          	add	a0,a0,-1896 # 800083f8 <states.0+0xf8>
    80002b68:	ffffe097          	auipc	ra,0xffffe
    80002b6c:	ca6080e7          	jalr	-858(ra) # 8000080e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b70:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b74:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002b78:	85ce                	mv	a1,s3
    80002b7a:	00006517          	auipc	a0,0x6
    80002b7e:	89e50513          	add	a0,a0,-1890 # 80008418 <states.0+0x118>
    80002b82:	ffffe097          	auipc	ra,0xffffe
    80002b86:	980080e7          	jalr	-1664(ra) # 80000502 <printf>
    panic("kerneltrap");
    80002b8a:	00006517          	auipc	a0,0x6
    80002b8e:	8b650513          	add	a0,a0,-1866 # 80008440 <states.0+0x140>
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	c7c080e7          	jalr	-900(ra) # 8000080e <panic>
  if(which_dev == 2 && myproc() != 0)
    80002b9a:	fffff097          	auipc	ra,0xfffff
    80002b9e:	f70080e7          	jalr	-144(ra) # 80001b0a <myproc>
    80002ba2:	dd41                	beqz	a0,80002b3a <kerneltrap+0x38>
    yield();
    80002ba4:	fffff097          	auipc	ra,0xfffff
    80002ba8:	682080e7          	jalr	1666(ra) # 80002226 <yield>
    80002bac:	b779                	j	80002b3a <kerneltrap+0x38>

0000000080002bae <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002bae:	1101                	add	sp,sp,-32
    80002bb0:	ec06                	sd	ra,24(sp)
    80002bb2:	e822                	sd	s0,16(sp)
    80002bb4:	e426                	sd	s1,8(sp)
    80002bb6:	1000                	add	s0,sp,32
    80002bb8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002bba:	fffff097          	auipc	ra,0xfffff
    80002bbe:	f50080e7          	jalr	-176(ra) # 80001b0a <myproc>
  switch (n) {
    80002bc2:	4795                	li	a5,5
    80002bc4:	0497e163          	bltu	a5,s1,80002c06 <argraw+0x58>
    80002bc8:	048a                	sll	s1,s1,0x2
    80002bca:	00006717          	auipc	a4,0x6
    80002bce:	8ae70713          	add	a4,a4,-1874 # 80008478 <states.0+0x178>
    80002bd2:	94ba                	add	s1,s1,a4
    80002bd4:	409c                	lw	a5,0(s1)
    80002bd6:	97ba                	add	a5,a5,a4
    80002bd8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002bda:	753c                	ld	a5,104(a0)
    80002bdc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002bde:	60e2                	ld	ra,24(sp)
    80002be0:	6442                	ld	s0,16(sp)
    80002be2:	64a2                	ld	s1,8(sp)
    80002be4:	6105                	add	sp,sp,32
    80002be6:	8082                	ret
    return p->trapframe->a1;
    80002be8:	753c                	ld	a5,104(a0)
    80002bea:	7fa8                	ld	a0,120(a5)
    80002bec:	bfcd                	j	80002bde <argraw+0x30>
    return p->trapframe->a2;
    80002bee:	753c                	ld	a5,104(a0)
    80002bf0:	63c8                	ld	a0,128(a5)
    80002bf2:	b7f5                	j	80002bde <argraw+0x30>
    return p->trapframe->a3;
    80002bf4:	753c                	ld	a5,104(a0)
    80002bf6:	67c8                	ld	a0,136(a5)
    80002bf8:	b7dd                	j	80002bde <argraw+0x30>
    return p->trapframe->a4;
    80002bfa:	753c                	ld	a5,104(a0)
    80002bfc:	6bc8                	ld	a0,144(a5)
    80002bfe:	b7c5                	j	80002bde <argraw+0x30>
    return p->trapframe->a5;
    80002c00:	753c                	ld	a5,104(a0)
    80002c02:	6fc8                	ld	a0,152(a5)
    80002c04:	bfe9                	j	80002bde <argraw+0x30>
  panic("argraw");
    80002c06:	00006517          	auipc	a0,0x6
    80002c0a:	84a50513          	add	a0,a0,-1974 # 80008450 <states.0+0x150>
    80002c0e:	ffffe097          	auipc	ra,0xffffe
    80002c12:	c00080e7          	jalr	-1024(ra) # 8000080e <panic>

0000000080002c16 <fetchaddr>:
{
    80002c16:	1101                	add	sp,sp,-32
    80002c18:	ec06                	sd	ra,24(sp)
    80002c1a:	e822                	sd	s0,16(sp)
    80002c1c:	e426                	sd	s1,8(sp)
    80002c1e:	e04a                	sd	s2,0(sp)
    80002c20:	1000                	add	s0,sp,32
    80002c22:	84aa                	mv	s1,a0
    80002c24:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002c26:	fffff097          	auipc	ra,0xfffff
    80002c2a:	ee4080e7          	jalr	-284(ra) # 80001b0a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80002c2e:	6d3c                	ld	a5,88(a0)
    80002c30:	02f4f863          	bgeu	s1,a5,80002c60 <fetchaddr+0x4a>
    80002c34:	00848713          	add	a4,s1,8
    80002c38:	02e7e663          	bltu	a5,a4,80002c64 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002c3c:	46a1                	li	a3,8
    80002c3e:	8626                	mv	a2,s1
    80002c40:	85ca                	mv	a1,s2
    80002c42:	7128                	ld	a0,96(a0)
    80002c44:	fffff097          	auipc	ra,0xfffff
    80002c48:	c00080e7          	jalr	-1024(ra) # 80001844 <copyin>
    80002c4c:	00a03533          	snez	a0,a0
    80002c50:	40a00533          	neg	a0,a0
}
    80002c54:	60e2                	ld	ra,24(sp)
    80002c56:	6442                	ld	s0,16(sp)
    80002c58:	64a2                	ld	s1,8(sp)
    80002c5a:	6902                	ld	s2,0(sp)
    80002c5c:	6105                	add	sp,sp,32
    80002c5e:	8082                	ret
    return -1;
    80002c60:	557d                	li	a0,-1
    80002c62:	bfcd                	j	80002c54 <fetchaddr+0x3e>
    80002c64:	557d                	li	a0,-1
    80002c66:	b7fd                	j	80002c54 <fetchaddr+0x3e>

0000000080002c68 <fetchstr>:
{
    80002c68:	7179                	add	sp,sp,-48
    80002c6a:	f406                	sd	ra,40(sp)
    80002c6c:	f022                	sd	s0,32(sp)
    80002c6e:	ec26                	sd	s1,24(sp)
    80002c70:	e84a                	sd	s2,16(sp)
    80002c72:	e44e                	sd	s3,8(sp)
    80002c74:	1800                	add	s0,sp,48
    80002c76:	892a                	mv	s2,a0
    80002c78:	84ae                	mv	s1,a1
    80002c7a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c7c:	fffff097          	auipc	ra,0xfffff
    80002c80:	e8e080e7          	jalr	-370(ra) # 80001b0a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002c84:	86ce                	mv	a3,s3
    80002c86:	864a                	mv	a2,s2
    80002c88:	85a6                	mv	a1,s1
    80002c8a:	7128                	ld	a0,96(a0)
    80002c8c:	fffff097          	auipc	ra,0xfffff
    80002c90:	c46080e7          	jalr	-954(ra) # 800018d2 <copyinstr>
    80002c94:	00054e63          	bltz	a0,80002cb0 <fetchstr+0x48>
  return strlen(buf);
    80002c98:	8526                	mv	a0,s1
    80002c9a:	ffffe097          	auipc	ra,0xffffe
    80002c9e:	2a8080e7          	jalr	680(ra) # 80000f42 <strlen>
}
    80002ca2:	70a2                	ld	ra,40(sp)
    80002ca4:	7402                	ld	s0,32(sp)
    80002ca6:	64e2                	ld	s1,24(sp)
    80002ca8:	6942                	ld	s2,16(sp)
    80002caa:	69a2                	ld	s3,8(sp)
    80002cac:	6145                	add	sp,sp,48
    80002cae:	8082                	ret
    return -1;
    80002cb0:	557d                	li	a0,-1
    80002cb2:	bfc5                	j	80002ca2 <fetchstr+0x3a>

0000000080002cb4 <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    80002cb4:	1101                	add	sp,sp,-32
    80002cb6:	ec06                	sd	ra,24(sp)
    80002cb8:	e822                	sd	s0,16(sp)
    80002cba:	e426                	sd	s1,8(sp)
    80002cbc:	1000                	add	s0,sp,32
    80002cbe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	eee080e7          	jalr	-274(ra) # 80002bae <argraw>
    80002cc8:	c088                	sw	a0,0(s1)
}
    80002cca:	60e2                	ld	ra,24(sp)
    80002ccc:	6442                	ld	s0,16(sp)
    80002cce:	64a2                	ld	s1,8(sp)
    80002cd0:	6105                	add	sp,sp,32
    80002cd2:	8082                	ret

0000000080002cd4 <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    80002cd4:	1101                	add	sp,sp,-32
    80002cd6:	ec06                	sd	ra,24(sp)
    80002cd8:	e822                	sd	s0,16(sp)
    80002cda:	e426                	sd	s1,8(sp)
    80002cdc:	1000                	add	s0,sp,32
    80002cde:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ce0:	00000097          	auipc	ra,0x0
    80002ce4:	ece080e7          	jalr	-306(ra) # 80002bae <argraw>
    80002ce8:	e088                	sd	a0,0(s1)
}
    80002cea:	60e2                	ld	ra,24(sp)
    80002cec:	6442                	ld	s0,16(sp)
    80002cee:	64a2                	ld	s1,8(sp)
    80002cf0:	6105                	add	sp,sp,32
    80002cf2:	8082                	ret

0000000080002cf4 <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80002cf4:	7179                	add	sp,sp,-48
    80002cf6:	f406                	sd	ra,40(sp)
    80002cf8:	f022                	sd	s0,32(sp)
    80002cfa:	ec26                	sd	s1,24(sp)
    80002cfc:	e84a                	sd	s2,16(sp)
    80002cfe:	1800                	add	s0,sp,48
    80002d00:	84ae                	mv	s1,a1
    80002d02:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002d04:	fd840593          	add	a1,s0,-40
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	fcc080e7          	jalr	-52(ra) # 80002cd4 <argaddr>
  return fetchstr(addr, buf, max);
    80002d10:	864a                	mv	a2,s2
    80002d12:	85a6                	mv	a1,s1
    80002d14:	fd843503          	ld	a0,-40(s0)
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	f50080e7          	jalr	-176(ra) # 80002c68 <fetchstr>
}
    80002d20:	70a2                	ld	ra,40(sp)
    80002d22:	7402                	ld	s0,32(sp)
    80002d24:	64e2                	ld	s1,24(sp)
    80002d26:	6942                	ld	s2,16(sp)
    80002d28:	6145                	add	sp,sp,48
    80002d2a:	8082                	ret

0000000080002d2c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002d2c:	1101                	add	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	e04a                	sd	s2,0(sp)
    80002d36:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002d38:	fffff097          	auipc	ra,0xfffff
    80002d3c:	dd2080e7          	jalr	-558(ra) # 80001b0a <myproc>
    80002d40:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002d42:	06853903          	ld	s2,104(a0)
    80002d46:	0a893783          	ld	a5,168(s2)
    80002d4a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002d4e:	37fd                	addw	a5,a5,-1
    80002d50:	4751                	li	a4,20
    80002d52:	00f76f63          	bltu	a4,a5,80002d70 <syscall+0x44>
    80002d56:	00369713          	sll	a4,a3,0x3
    80002d5a:	00005797          	auipc	a5,0x5
    80002d5e:	73678793          	add	a5,a5,1846 # 80008490 <syscalls>
    80002d62:	97ba                	add	a5,a5,a4
    80002d64:	639c                	ld	a5,0(a5)
    80002d66:	c789                	beqz	a5,80002d70 <syscall+0x44>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    80002d68:	9782                	jalr	a5
    80002d6a:	06a93823          	sd	a0,112(s2)
    80002d6e:	a839                	j	80002d8c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002d70:	16848613          	add	a2,s1,360
    80002d74:	588c                	lw	a1,48(s1)
    80002d76:	00005517          	auipc	a0,0x5
    80002d7a:	6e250513          	add	a0,a0,1762 # 80008458 <states.0+0x158>
    80002d7e:	ffffd097          	auipc	ra,0xffffd
    80002d82:	784080e7          	jalr	1924(ra) # 80000502 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d86:	74bc                	ld	a5,104(s1)
    80002d88:	577d                	li	a4,-1
    80002d8a:	fbb8                	sd	a4,112(a5)
  }
}
    80002d8c:	60e2                	ld	ra,24(sp)
    80002d8e:	6442                	ld	s0,16(sp)
    80002d90:	64a2                	ld	s1,8(sp)
    80002d92:	6902                	ld	s2,0(sp)
    80002d94:	6105                	add	sp,sp,32
    80002d96:	8082                	ret

0000000080002d98 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d98:	1101                	add	sp,sp,-32
    80002d9a:	ec06                	sd	ra,24(sp)
    80002d9c:	e822                	sd	s0,16(sp)
    80002d9e:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002da0:	fec40593          	add	a1,s0,-20
    80002da4:	4501                	li	a0,0
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	f0e080e7          	jalr	-242(ra) # 80002cb4 <argint>
  exit(n);
    80002dae:	fec42503          	lw	a0,-20(s0)
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	5e4080e7          	jalr	1508(ra) # 80002396 <exit>
  return 0;  /* not reached */
}
    80002dba:	4501                	li	a0,0
    80002dbc:	60e2                	ld	ra,24(sp)
    80002dbe:	6442                	ld	s0,16(sp)
    80002dc0:	6105                	add	sp,sp,32
    80002dc2:	8082                	ret

0000000080002dc4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002dc4:	1141                	add	sp,sp,-16
    80002dc6:	e406                	sd	ra,8(sp)
    80002dc8:	e022                	sd	s0,0(sp)
    80002dca:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	d3e080e7          	jalr	-706(ra) # 80001b0a <myproc>
}
    80002dd4:	5908                	lw	a0,48(a0)
    80002dd6:	60a2                	ld	ra,8(sp)
    80002dd8:	6402                	ld	s0,0(sp)
    80002dda:	0141                	add	sp,sp,16
    80002ddc:	8082                	ret

0000000080002dde <sys_fork>:

uint64
sys_fork(void)
{
    80002dde:	1141                	add	sp,sp,-16
    80002de0:	e406                	sd	ra,8(sp)
    80002de2:	e022                	sd	s0,0(sp)
    80002de4:	0800                	add	s0,sp,16
  return fork();
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	0ec080e7          	jalr	236(ra) # 80001ed2 <fork>
}
    80002dee:	60a2                	ld	ra,8(sp)
    80002df0:	6402                	ld	s0,0(sp)
    80002df2:	0141                	add	sp,sp,16
    80002df4:	8082                	ret

0000000080002df6 <sys_wait>:

uint64
sys_wait(void)
{
    80002df6:	1101                	add	sp,sp,-32
    80002df8:	ec06                	sd	ra,24(sp)
    80002dfa:	e822                	sd	s0,16(sp)
    80002dfc:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002dfe:	fe840593          	add	a1,s0,-24
    80002e02:	4501                	li	a0,0
    80002e04:	00000097          	auipc	ra,0x0
    80002e08:	ed0080e7          	jalr	-304(ra) # 80002cd4 <argaddr>
  return wait(p);
    80002e0c:	fe843503          	ld	a0,-24(s0)
    80002e10:	fffff097          	auipc	ra,0xfffff
    80002e14:	72c080e7          	jalr	1836(ra) # 8000253c <wait>
}
    80002e18:	60e2                	ld	ra,24(sp)
    80002e1a:	6442                	ld	s0,16(sp)
    80002e1c:	6105                	add	sp,sp,32
    80002e1e:	8082                	ret

0000000080002e20 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002e20:	7179                	add	sp,sp,-48
    80002e22:	f406                	sd	ra,40(sp)
    80002e24:	f022                	sd	s0,32(sp)
    80002e26:	ec26                	sd	s1,24(sp)
    80002e28:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002e2a:	fdc40593          	add	a1,s0,-36
    80002e2e:	4501                	li	a0,0
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	e84080e7          	jalr	-380(ra) # 80002cb4 <argint>
  addr = myproc()->sz;
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	cd2080e7          	jalr	-814(ra) # 80001b0a <myproc>
    80002e40:	6d24                	ld	s1,88(a0)
  if(growproc(n) < 0)
    80002e42:	fdc42503          	lw	a0,-36(s0)
    80002e46:	fffff097          	auipc	ra,0xfffff
    80002e4a:	030080e7          	jalr	48(ra) # 80001e76 <growproc>
    80002e4e:	00054863          	bltz	a0,80002e5e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002e52:	8526                	mv	a0,s1
    80002e54:	70a2                	ld	ra,40(sp)
    80002e56:	7402                	ld	s0,32(sp)
    80002e58:	64e2                	ld	s1,24(sp)
    80002e5a:	6145                	add	sp,sp,48
    80002e5c:	8082                	ret
    return -1;
    80002e5e:	54fd                	li	s1,-1
    80002e60:	bfcd                	j	80002e52 <sys_sbrk+0x32>

0000000080002e62 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002e62:	7139                	add	sp,sp,-64
    80002e64:	fc06                	sd	ra,56(sp)
    80002e66:	f822                	sd	s0,48(sp)
    80002e68:	f426                	sd	s1,40(sp)
    80002e6a:	f04a                	sd	s2,32(sp)
    80002e6c:	ec4e                	sd	s3,24(sp)
    80002e6e:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002e70:	fcc40593          	add	a1,s0,-52
    80002e74:	4501                	li	a0,0
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	e3e080e7          	jalr	-450(ra) # 80002cb4 <argint>
  if(n < 0)
    80002e7e:	fcc42783          	lw	a5,-52(s0)
    80002e82:	0607cf63          	bltz	a5,80002f00 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002e86:	00015517          	auipc	a0,0x15
    80002e8a:	85a50513          	add	a0,a0,-1958 # 800176e0 <tickslock>
    80002e8e:	ffffe097          	auipc	ra,0xffffe
    80002e92:	e3e080e7          	jalr	-450(ra) # 80000ccc <acquire>
  ticks0 = ticks;
    80002e96:	00006917          	auipc	s2,0x6
    80002e9a:	a6a92903          	lw	s2,-1430(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002e9e:	fcc42783          	lw	a5,-52(s0)
    80002ea2:	cf9d                	beqz	a5,80002ee0 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ea4:	00015997          	auipc	s3,0x15
    80002ea8:	83c98993          	add	s3,s3,-1988 # 800176e0 <tickslock>
    80002eac:	00006497          	auipc	s1,0x6
    80002eb0:	a5448493          	add	s1,s1,-1452 # 80008900 <ticks>
    if(killed(myproc())){
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	c56080e7          	jalr	-938(ra) # 80001b0a <myproc>
    80002ebc:	fffff097          	auipc	ra,0xfffff
    80002ec0:	64e080e7          	jalr	1614(ra) # 8000250a <killed>
    80002ec4:	e129                	bnez	a0,80002f06 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002ec6:	85ce                	mv	a1,s3
    80002ec8:	8526                	mv	a0,s1
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	398080e7          	jalr	920(ra) # 80002262 <sleep>
  while(ticks - ticks0 < n){
    80002ed2:	409c                	lw	a5,0(s1)
    80002ed4:	412787bb          	subw	a5,a5,s2
    80002ed8:	fcc42703          	lw	a4,-52(s0)
    80002edc:	fce7ece3          	bltu	a5,a4,80002eb4 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002ee0:	00015517          	auipc	a0,0x15
    80002ee4:	80050513          	add	a0,a0,-2048 # 800176e0 <tickslock>
    80002ee8:	ffffe097          	auipc	ra,0xffffe
    80002eec:	e98080e7          	jalr	-360(ra) # 80000d80 <release>
  return 0;
    80002ef0:	4501                	li	a0,0
}
    80002ef2:	70e2                	ld	ra,56(sp)
    80002ef4:	7442                	ld	s0,48(sp)
    80002ef6:	74a2                	ld	s1,40(sp)
    80002ef8:	7902                	ld	s2,32(sp)
    80002efa:	69e2                	ld	s3,24(sp)
    80002efc:	6121                	add	sp,sp,64
    80002efe:	8082                	ret
    n = 0;
    80002f00:	fc042623          	sw	zero,-52(s0)
    80002f04:	b749                	j	80002e86 <sys_sleep+0x24>
      release(&tickslock);
    80002f06:	00014517          	auipc	a0,0x14
    80002f0a:	7da50513          	add	a0,a0,2010 # 800176e0 <tickslock>
    80002f0e:	ffffe097          	auipc	ra,0xffffe
    80002f12:	e72080e7          	jalr	-398(ra) # 80000d80 <release>
      return -1;
    80002f16:	557d                	li	a0,-1
    80002f18:	bfe9                	j	80002ef2 <sys_sleep+0x90>

0000000080002f1a <sys_kill>:

uint64
sys_kill(void)
{
    80002f1a:	1101                	add	sp,sp,-32
    80002f1c:	ec06                	sd	ra,24(sp)
    80002f1e:	e822                	sd	s0,16(sp)
    80002f20:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002f22:	fec40593          	add	a1,s0,-20
    80002f26:	4501                	li	a0,0
    80002f28:	00000097          	auipc	ra,0x0
    80002f2c:	d8c080e7          	jalr	-628(ra) # 80002cb4 <argint>
  return kill(pid);
    80002f30:	fec42503          	lw	a0,-20(s0)
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	538080e7          	jalr	1336(ra) # 8000246c <kill>
}
    80002f3c:	60e2                	ld	ra,24(sp)
    80002f3e:	6442                	ld	s0,16(sp)
    80002f40:	6105                	add	sp,sp,32
    80002f42:	8082                	ret

0000000080002f44 <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    80002f44:	1101                	add	sp,sp,-32
    80002f46:	ec06                	sd	ra,24(sp)
    80002f48:	e822                	sd	s0,16(sp)
    80002f4a:	e426                	sd	s1,8(sp)
    80002f4c:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002f4e:	00014517          	auipc	a0,0x14
    80002f52:	79250513          	add	a0,a0,1938 # 800176e0 <tickslock>
    80002f56:	ffffe097          	auipc	ra,0xffffe
    80002f5a:	d76080e7          	jalr	-650(ra) # 80000ccc <acquire>
  xticks = ticks;
    80002f5e:	00006497          	auipc	s1,0x6
    80002f62:	9a24a483          	lw	s1,-1630(s1) # 80008900 <ticks>
  release(&tickslock);
    80002f66:	00014517          	auipc	a0,0x14
    80002f6a:	77a50513          	add	a0,a0,1914 # 800176e0 <tickslock>
    80002f6e:	ffffe097          	auipc	ra,0xffffe
    80002f72:	e12080e7          	jalr	-494(ra) # 80000d80 <release>
  return xticks;
}
    80002f76:	02049513          	sll	a0,s1,0x20
    80002f7a:	9101                	srl	a0,a0,0x20
    80002f7c:	60e2                	ld	ra,24(sp)
    80002f7e:	6442                	ld	s0,16(sp)
    80002f80:	64a2                	ld	s1,8(sp)
    80002f82:	6105                	add	sp,sp,32
    80002f84:	8082                	ret

0000000080002f86 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f86:	7179                	add	sp,sp,-48
    80002f88:	f406                	sd	ra,40(sp)
    80002f8a:	f022                	sd	s0,32(sp)
    80002f8c:	ec26                	sd	s1,24(sp)
    80002f8e:	e84a                	sd	s2,16(sp)
    80002f90:	e44e                	sd	s3,8(sp)
    80002f92:	e052                	sd	s4,0(sp)
    80002f94:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f96:	00005597          	auipc	a1,0x5
    80002f9a:	5aa58593          	add	a1,a1,1450 # 80008540 <syscalls+0xb0>
    80002f9e:	00014517          	auipc	a0,0x14
    80002fa2:	75a50513          	add	a0,a0,1882 # 800176f8 <bcache>
    80002fa6:	ffffe097          	auipc	ra,0xffffe
    80002faa:	c96080e7          	jalr	-874(ra) # 80000c3c <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    80002fae:	0001c797          	auipc	a5,0x1c
    80002fb2:	74a78793          	add	a5,a5,1866 # 8001f6f8 <bcache+0x8000>
    80002fb6:	0001d717          	auipc	a4,0x1d
    80002fba:	9aa70713          	add	a4,a4,-1622 # 8001f960 <bcache+0x8268>
    80002fbe:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002fc2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002fc6:	00014497          	auipc	s1,0x14
    80002fca:	74a48493          	add	s1,s1,1866 # 80017710 <bcache+0x18>
    b->next = bcache.head.next;
    80002fce:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002fd0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002fd2:	00005a17          	auipc	s4,0x5
    80002fd6:	576a0a13          	add	s4,s4,1398 # 80008548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002fda:	2b893783          	ld	a5,696(s2)
    80002fde:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002fe0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002fe4:	85d2                	mv	a1,s4
    80002fe6:	01048513          	add	a0,s1,16
    80002fea:	00001097          	auipc	ra,0x1
    80002fee:	496080e7          	jalr	1174(ra) # 80004480 <initsleeplock>
    bcache.head.next->prev = b;
    80002ff2:	2b893783          	ld	a5,696(s2)
    80002ff6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ff8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ffc:	45848493          	add	s1,s1,1112
    80003000:	fd349de3          	bne	s1,s3,80002fda <binit+0x54>
  }
}
    80003004:	70a2                	ld	ra,40(sp)
    80003006:	7402                	ld	s0,32(sp)
    80003008:	64e2                	ld	s1,24(sp)
    8000300a:	6942                	ld	s2,16(sp)
    8000300c:	69a2                	ld	s3,8(sp)
    8000300e:	6a02                	ld	s4,0(sp)
    80003010:	6145                	add	sp,sp,48
    80003012:	8082                	ret

0000000080003014 <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    80003014:	7179                	add	sp,sp,-48
    80003016:	f406                	sd	ra,40(sp)
    80003018:	f022                	sd	s0,32(sp)
    8000301a:	ec26                	sd	s1,24(sp)
    8000301c:	e84a                	sd	s2,16(sp)
    8000301e:	e44e                	sd	s3,8(sp)
    80003020:	1800                	add	s0,sp,48
    80003022:	892a                	mv	s2,a0
    80003024:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003026:	00014517          	auipc	a0,0x14
    8000302a:	6d250513          	add	a0,a0,1746 # 800176f8 <bcache>
    8000302e:	ffffe097          	auipc	ra,0xffffe
    80003032:	c9e080e7          	jalr	-866(ra) # 80000ccc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003036:	0001d497          	auipc	s1,0x1d
    8000303a:	97a4b483          	ld	s1,-1670(s1) # 8001f9b0 <bcache+0x82b8>
    8000303e:	0001d797          	auipc	a5,0x1d
    80003042:	92278793          	add	a5,a5,-1758 # 8001f960 <bcache+0x8268>
    80003046:	02f48f63          	beq	s1,a5,80003084 <bread+0x70>
    8000304a:	873e                	mv	a4,a5
    8000304c:	a021                	j	80003054 <bread+0x40>
    8000304e:	68a4                	ld	s1,80(s1)
    80003050:	02e48a63          	beq	s1,a4,80003084 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003054:	449c                	lw	a5,8(s1)
    80003056:	ff279ce3          	bne	a5,s2,8000304e <bread+0x3a>
    8000305a:	44dc                	lw	a5,12(s1)
    8000305c:	ff3799e3          	bne	a5,s3,8000304e <bread+0x3a>
      b->refcnt++;
    80003060:	40bc                	lw	a5,64(s1)
    80003062:	2785                	addw	a5,a5,1
    80003064:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003066:	00014517          	auipc	a0,0x14
    8000306a:	69250513          	add	a0,a0,1682 # 800176f8 <bcache>
    8000306e:	ffffe097          	auipc	ra,0xffffe
    80003072:	d12080e7          	jalr	-750(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    80003076:	01048513          	add	a0,s1,16
    8000307a:	00001097          	auipc	ra,0x1
    8000307e:	440080e7          	jalr	1088(ra) # 800044ba <acquiresleep>
      return b;
    80003082:	a8b9                	j	800030e0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003084:	0001d497          	auipc	s1,0x1d
    80003088:	9244b483          	ld	s1,-1756(s1) # 8001f9a8 <bcache+0x82b0>
    8000308c:	0001d797          	auipc	a5,0x1d
    80003090:	8d478793          	add	a5,a5,-1836 # 8001f960 <bcache+0x8268>
    80003094:	00f48863          	beq	s1,a5,800030a4 <bread+0x90>
    80003098:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000309a:	40bc                	lw	a5,64(s1)
    8000309c:	cf81                	beqz	a5,800030b4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000309e:	64a4                	ld	s1,72(s1)
    800030a0:	fee49de3          	bne	s1,a4,8000309a <bread+0x86>
  panic("bget: no buffers");
    800030a4:	00005517          	auipc	a0,0x5
    800030a8:	4ac50513          	add	a0,a0,1196 # 80008550 <syscalls+0xc0>
    800030ac:	ffffd097          	auipc	ra,0xffffd
    800030b0:	762080e7          	jalr	1890(ra) # 8000080e <panic>
      b->dev = dev;
    800030b4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800030b8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800030bc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800030c0:	4785                	li	a5,1
    800030c2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030c4:	00014517          	auipc	a0,0x14
    800030c8:	63450513          	add	a0,a0,1588 # 800176f8 <bcache>
    800030cc:	ffffe097          	auipc	ra,0xffffe
    800030d0:	cb4080e7          	jalr	-844(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    800030d4:	01048513          	add	a0,s1,16
    800030d8:	00001097          	auipc	ra,0x1
    800030dc:	3e2080e7          	jalr	994(ra) # 800044ba <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800030e0:	409c                	lw	a5,0(s1)
    800030e2:	cb89                	beqz	a5,800030f4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800030e4:	8526                	mv	a0,s1
    800030e6:	70a2                	ld	ra,40(sp)
    800030e8:	7402                	ld	s0,32(sp)
    800030ea:	64e2                	ld	s1,24(sp)
    800030ec:	6942                	ld	s2,16(sp)
    800030ee:	69a2                	ld	s3,8(sp)
    800030f0:	6145                	add	sp,sp,48
    800030f2:	8082                	ret
    virtio_disk_rw(b, 0);
    800030f4:	4581                	li	a1,0
    800030f6:	8526                	mv	a0,s1
    800030f8:	00003097          	auipc	ra,0x3
    800030fc:	f1e080e7          	jalr	-226(ra) # 80006016 <virtio_disk_rw>
    b->valid = 1;
    80003100:	4785                	li	a5,1
    80003102:	c09c                	sw	a5,0(s1)
  return b;
    80003104:	b7c5                	j	800030e4 <bread+0xd0>

0000000080003106 <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    80003106:	1101                	add	sp,sp,-32
    80003108:	ec06                	sd	ra,24(sp)
    8000310a:	e822                	sd	s0,16(sp)
    8000310c:	e426                	sd	s1,8(sp)
    8000310e:	1000                	add	s0,sp,32
    80003110:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003112:	0541                	add	a0,a0,16
    80003114:	00001097          	auipc	ra,0x1
    80003118:	440080e7          	jalr	1088(ra) # 80004554 <holdingsleep>
    8000311c:	cd01                	beqz	a0,80003134 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000311e:	4585                	li	a1,1
    80003120:	8526                	mv	a0,s1
    80003122:	00003097          	auipc	ra,0x3
    80003126:	ef4080e7          	jalr	-268(ra) # 80006016 <virtio_disk_rw>
}
    8000312a:	60e2                	ld	ra,24(sp)
    8000312c:	6442                	ld	s0,16(sp)
    8000312e:	64a2                	ld	s1,8(sp)
    80003130:	6105                	add	sp,sp,32
    80003132:	8082                	ret
    panic("bwrite");
    80003134:	00005517          	auipc	a0,0x5
    80003138:	43450513          	add	a0,a0,1076 # 80008568 <syscalls+0xd8>
    8000313c:	ffffd097          	auipc	ra,0xffffd
    80003140:	6d2080e7          	jalr	1746(ra) # 8000080e <panic>

0000000080003144 <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    80003144:	1101                	add	sp,sp,-32
    80003146:	ec06                	sd	ra,24(sp)
    80003148:	e822                	sd	s0,16(sp)
    8000314a:	e426                	sd	s1,8(sp)
    8000314c:	e04a                	sd	s2,0(sp)
    8000314e:	1000                	add	s0,sp,32
    80003150:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003152:	01050913          	add	s2,a0,16
    80003156:	854a                	mv	a0,s2
    80003158:	00001097          	auipc	ra,0x1
    8000315c:	3fc080e7          	jalr	1020(ra) # 80004554 <holdingsleep>
    80003160:	c925                	beqz	a0,800031d0 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003162:	854a                	mv	a0,s2
    80003164:	00001097          	auipc	ra,0x1
    80003168:	3ac080e7          	jalr	940(ra) # 80004510 <releasesleep>

  acquire(&bcache.lock);
    8000316c:	00014517          	auipc	a0,0x14
    80003170:	58c50513          	add	a0,a0,1420 # 800176f8 <bcache>
    80003174:	ffffe097          	auipc	ra,0xffffe
    80003178:	b58080e7          	jalr	-1192(ra) # 80000ccc <acquire>
  b->refcnt--;
    8000317c:	40bc                	lw	a5,64(s1)
    8000317e:	37fd                	addw	a5,a5,-1
    80003180:	0007871b          	sext.w	a4,a5
    80003184:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003186:	e71d                	bnez	a4,800031b4 <brelse+0x70>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    80003188:	68b8                	ld	a4,80(s1)
    8000318a:	64bc                	ld	a5,72(s1)
    8000318c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000318e:	68b8                	ld	a4,80(s1)
    80003190:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003192:	0001c797          	auipc	a5,0x1c
    80003196:	56678793          	add	a5,a5,1382 # 8001f6f8 <bcache+0x8000>
    8000319a:	2b87b703          	ld	a4,696(a5)
    8000319e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800031a0:	0001c717          	auipc	a4,0x1c
    800031a4:	7c070713          	add	a4,a4,1984 # 8001f960 <bcache+0x8268>
    800031a8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800031aa:	2b87b703          	ld	a4,696(a5)
    800031ae:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800031b0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800031b4:	00014517          	auipc	a0,0x14
    800031b8:	54450513          	add	a0,a0,1348 # 800176f8 <bcache>
    800031bc:	ffffe097          	auipc	ra,0xffffe
    800031c0:	bc4080e7          	jalr	-1084(ra) # 80000d80 <release>
}
    800031c4:	60e2                	ld	ra,24(sp)
    800031c6:	6442                	ld	s0,16(sp)
    800031c8:	64a2                	ld	s1,8(sp)
    800031ca:	6902                	ld	s2,0(sp)
    800031cc:	6105                	add	sp,sp,32
    800031ce:	8082                	ret
    panic("brelse");
    800031d0:	00005517          	auipc	a0,0x5
    800031d4:	3a050513          	add	a0,a0,928 # 80008570 <syscalls+0xe0>
    800031d8:	ffffd097          	auipc	ra,0xffffd
    800031dc:	636080e7          	jalr	1590(ra) # 8000080e <panic>

00000000800031e0 <bpin>:

void
bpin(struct buf *b) {
    800031e0:	1101                	add	sp,sp,-32
    800031e2:	ec06                	sd	ra,24(sp)
    800031e4:	e822                	sd	s0,16(sp)
    800031e6:	e426                	sd	s1,8(sp)
    800031e8:	1000                	add	s0,sp,32
    800031ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031ec:	00014517          	auipc	a0,0x14
    800031f0:	50c50513          	add	a0,a0,1292 # 800176f8 <bcache>
    800031f4:	ffffe097          	auipc	ra,0xffffe
    800031f8:	ad8080e7          	jalr	-1320(ra) # 80000ccc <acquire>
  b->refcnt++;
    800031fc:	40bc                	lw	a5,64(s1)
    800031fe:	2785                	addw	a5,a5,1
    80003200:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003202:	00014517          	auipc	a0,0x14
    80003206:	4f650513          	add	a0,a0,1270 # 800176f8 <bcache>
    8000320a:	ffffe097          	auipc	ra,0xffffe
    8000320e:	b76080e7          	jalr	-1162(ra) # 80000d80 <release>
}
    80003212:	60e2                	ld	ra,24(sp)
    80003214:	6442                	ld	s0,16(sp)
    80003216:	64a2                	ld	s1,8(sp)
    80003218:	6105                	add	sp,sp,32
    8000321a:	8082                	ret

000000008000321c <bunpin>:

void
bunpin(struct buf *b) {
    8000321c:	1101                	add	sp,sp,-32
    8000321e:	ec06                	sd	ra,24(sp)
    80003220:	e822                	sd	s0,16(sp)
    80003222:	e426                	sd	s1,8(sp)
    80003224:	1000                	add	s0,sp,32
    80003226:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003228:	00014517          	auipc	a0,0x14
    8000322c:	4d050513          	add	a0,a0,1232 # 800176f8 <bcache>
    80003230:	ffffe097          	auipc	ra,0xffffe
    80003234:	a9c080e7          	jalr	-1380(ra) # 80000ccc <acquire>
  b->refcnt--;
    80003238:	40bc                	lw	a5,64(s1)
    8000323a:	37fd                	addw	a5,a5,-1
    8000323c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000323e:	00014517          	auipc	a0,0x14
    80003242:	4ba50513          	add	a0,a0,1210 # 800176f8 <bcache>
    80003246:	ffffe097          	auipc	ra,0xffffe
    8000324a:	b3a080e7          	jalr	-1222(ra) # 80000d80 <release>
}
    8000324e:	60e2                	ld	ra,24(sp)
    80003250:	6442                	ld	s0,16(sp)
    80003252:	64a2                	ld	s1,8(sp)
    80003254:	6105                	add	sp,sp,32
    80003256:	8082                	ret

0000000080003258 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    80003258:	1101                	add	sp,sp,-32
    8000325a:	ec06                	sd	ra,24(sp)
    8000325c:	e822                	sd	s0,16(sp)
    8000325e:	e426                	sd	s1,8(sp)
    80003260:	e04a                	sd	s2,0(sp)
    80003262:	1000                	add	s0,sp,32
    80003264:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003266:	00d5d59b          	srlw	a1,a1,0xd
    8000326a:	0001d797          	auipc	a5,0x1d
    8000326e:	b6a7a783          	lw	a5,-1174(a5) # 8001fdd4 <sb+0x1c>
    80003272:	9dbd                	addw	a1,a1,a5
    80003274:	00000097          	auipc	ra,0x0
    80003278:	da0080e7          	jalr	-608(ra) # 80003014 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000327c:	0074f713          	and	a4,s1,7
    80003280:	4785                	li	a5,1
    80003282:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003286:	14ce                	sll	s1,s1,0x33
    80003288:	90d9                	srl	s1,s1,0x36
    8000328a:	00950733          	add	a4,a0,s1
    8000328e:	05874703          	lbu	a4,88(a4)
    80003292:	00e7f6b3          	and	a3,a5,a4
    80003296:	c69d                	beqz	a3,800032c4 <bfree+0x6c>
    80003298:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000329a:	94aa                	add	s1,s1,a0
    8000329c:	fff7c793          	not	a5,a5
    800032a0:	8f7d                	and	a4,a4,a5
    800032a2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800032a6:	00001097          	auipc	ra,0x1
    800032aa:	0f6080e7          	jalr	246(ra) # 8000439c <log_write>
  brelse(bp);
    800032ae:	854a                	mv	a0,s2
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	e94080e7          	jalr	-364(ra) # 80003144 <brelse>
}
    800032b8:	60e2                	ld	ra,24(sp)
    800032ba:	6442                	ld	s0,16(sp)
    800032bc:	64a2                	ld	s1,8(sp)
    800032be:	6902                	ld	s2,0(sp)
    800032c0:	6105                	add	sp,sp,32
    800032c2:	8082                	ret
    panic("freeing free block");
    800032c4:	00005517          	auipc	a0,0x5
    800032c8:	2b450513          	add	a0,a0,692 # 80008578 <syscalls+0xe8>
    800032cc:	ffffd097          	auipc	ra,0xffffd
    800032d0:	542080e7          	jalr	1346(ra) # 8000080e <panic>

00000000800032d4 <balloc>:
{
    800032d4:	711d                	add	sp,sp,-96
    800032d6:	ec86                	sd	ra,88(sp)
    800032d8:	e8a2                	sd	s0,80(sp)
    800032da:	e4a6                	sd	s1,72(sp)
    800032dc:	e0ca                	sd	s2,64(sp)
    800032de:	fc4e                	sd	s3,56(sp)
    800032e0:	f852                	sd	s4,48(sp)
    800032e2:	f456                	sd	s5,40(sp)
    800032e4:	f05a                	sd	s6,32(sp)
    800032e6:	ec5e                	sd	s7,24(sp)
    800032e8:	e862                	sd	s8,16(sp)
    800032ea:	e466                	sd	s9,8(sp)
    800032ec:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800032ee:	0001d797          	auipc	a5,0x1d
    800032f2:	ace7a783          	lw	a5,-1330(a5) # 8001fdbc <sb+0x4>
    800032f6:	cff5                	beqz	a5,800033f2 <balloc+0x11e>
    800032f8:	8baa                	mv	s7,a0
    800032fa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800032fc:	0001db17          	auipc	s6,0x1d
    80003300:	abcb0b13          	add	s6,s6,-1348 # 8001fdb8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003304:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003306:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003308:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000330a:	6c89                	lui	s9,0x2
    8000330c:	a061                	j	80003394 <balloc+0xc0>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    8000330e:	97ca                	add	a5,a5,s2
    80003310:	8e55                	or	a2,a2,a3
    80003312:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003316:	854a                	mv	a0,s2
    80003318:	00001097          	auipc	ra,0x1
    8000331c:	084080e7          	jalr	132(ra) # 8000439c <log_write>
        brelse(bp);
    80003320:	854a                	mv	a0,s2
    80003322:	00000097          	auipc	ra,0x0
    80003326:	e22080e7          	jalr	-478(ra) # 80003144 <brelse>
  bp = bread(dev, bno);
    8000332a:	85a6                	mv	a1,s1
    8000332c:	855e                	mv	a0,s7
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	ce6080e7          	jalr	-794(ra) # 80003014 <bread>
    80003336:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003338:	40000613          	li	a2,1024
    8000333c:	4581                	li	a1,0
    8000333e:	05850513          	add	a0,a0,88
    80003342:	ffffe097          	auipc	ra,0xffffe
    80003346:	a86080e7          	jalr	-1402(ra) # 80000dc8 <memset>
  log_write(bp);
    8000334a:	854a                	mv	a0,s2
    8000334c:	00001097          	auipc	ra,0x1
    80003350:	050080e7          	jalr	80(ra) # 8000439c <log_write>
  brelse(bp);
    80003354:	854a                	mv	a0,s2
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	dee080e7          	jalr	-530(ra) # 80003144 <brelse>
}
    8000335e:	8526                	mv	a0,s1
    80003360:	60e6                	ld	ra,88(sp)
    80003362:	6446                	ld	s0,80(sp)
    80003364:	64a6                	ld	s1,72(sp)
    80003366:	6906                	ld	s2,64(sp)
    80003368:	79e2                	ld	s3,56(sp)
    8000336a:	7a42                	ld	s4,48(sp)
    8000336c:	7aa2                	ld	s5,40(sp)
    8000336e:	7b02                	ld	s6,32(sp)
    80003370:	6be2                	ld	s7,24(sp)
    80003372:	6c42                	ld	s8,16(sp)
    80003374:	6ca2                	ld	s9,8(sp)
    80003376:	6125                	add	sp,sp,96
    80003378:	8082                	ret
    brelse(bp);
    8000337a:	854a                	mv	a0,s2
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	dc8080e7          	jalr	-568(ra) # 80003144 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003384:	015c87bb          	addw	a5,s9,s5
    80003388:	00078a9b          	sext.w	s5,a5
    8000338c:	004b2703          	lw	a4,4(s6)
    80003390:	06eaf163          	bgeu	s5,a4,800033f2 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003394:	41fad79b          	sraw	a5,s5,0x1f
    80003398:	0137d79b          	srlw	a5,a5,0x13
    8000339c:	015787bb          	addw	a5,a5,s5
    800033a0:	40d7d79b          	sraw	a5,a5,0xd
    800033a4:	01cb2583          	lw	a1,28(s6)
    800033a8:	9dbd                	addw	a1,a1,a5
    800033aa:	855e                	mv	a0,s7
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	c68080e7          	jalr	-920(ra) # 80003014 <bread>
    800033b4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033b6:	004b2503          	lw	a0,4(s6)
    800033ba:	000a849b          	sext.w	s1,s5
    800033be:	8762                	mv	a4,s8
    800033c0:	faa4fde3          	bgeu	s1,a0,8000337a <balloc+0xa6>
      m = 1 << (bi % 8);
    800033c4:	00777693          	and	a3,a4,7
    800033c8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    800033cc:	41f7579b          	sraw	a5,a4,0x1f
    800033d0:	01d7d79b          	srlw	a5,a5,0x1d
    800033d4:	9fb9                	addw	a5,a5,a4
    800033d6:	4037d79b          	sraw	a5,a5,0x3
    800033da:	00f90633          	add	a2,s2,a5
    800033de:	05864603          	lbu	a2,88(a2)
    800033e2:	00c6f5b3          	and	a1,a3,a2
    800033e6:	d585                	beqz	a1,8000330e <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033e8:	2705                	addw	a4,a4,1
    800033ea:	2485                	addw	s1,s1,1
    800033ec:	fd471ae3          	bne	a4,s4,800033c0 <balloc+0xec>
    800033f0:	b769                	j	8000337a <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800033f2:	00005517          	auipc	a0,0x5
    800033f6:	19e50513          	add	a0,a0,414 # 80008590 <syscalls+0x100>
    800033fa:	ffffd097          	auipc	ra,0xffffd
    800033fe:	108080e7          	jalr	264(ra) # 80000502 <printf>
  return 0;
    80003402:	4481                	li	s1,0
    80003404:	bfa9                	j	8000335e <balloc+0x8a>

0000000080003406 <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    80003406:	7179                	add	sp,sp,-48
    80003408:	f406                	sd	ra,40(sp)
    8000340a:	f022                	sd	s0,32(sp)
    8000340c:	ec26                	sd	s1,24(sp)
    8000340e:	e84a                	sd	s2,16(sp)
    80003410:	e44e                	sd	s3,8(sp)
    80003412:	e052                	sd	s4,0(sp)
    80003414:	1800                	add	s0,sp,48
    80003416:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003418:	47ad                	li	a5,11
    8000341a:	02b7e863          	bltu	a5,a1,8000344a <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000341e:	02059793          	sll	a5,a1,0x20
    80003422:	01e7d593          	srl	a1,a5,0x1e
    80003426:	00b504b3          	add	s1,a0,a1
    8000342a:	0504a903          	lw	s2,80(s1)
    8000342e:	06091e63          	bnez	s2,800034aa <bmap+0xa4>
      addr = balloc(ip->dev);
    80003432:	4108                	lw	a0,0(a0)
    80003434:	00000097          	auipc	ra,0x0
    80003438:	ea0080e7          	jalr	-352(ra) # 800032d4 <balloc>
    8000343c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003440:	06090563          	beqz	s2,800034aa <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80003444:	0524a823          	sw	s2,80(s1)
    80003448:	a08d                	j	800034aa <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000344a:	ff45849b          	addw	s1,a1,-12
    8000344e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003452:	0ff00793          	li	a5,255
    80003456:	08e7e563          	bltu	a5,a4,800034e0 <bmap+0xda>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000345a:	08052903          	lw	s2,128(a0)
    8000345e:	00091d63          	bnez	s2,80003478 <bmap+0x72>
      addr = balloc(ip->dev);
    80003462:	4108                	lw	a0,0(a0)
    80003464:	00000097          	auipc	ra,0x0
    80003468:	e70080e7          	jalr	-400(ra) # 800032d4 <balloc>
    8000346c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003470:	02090d63          	beqz	s2,800034aa <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003474:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003478:	85ca                	mv	a1,s2
    8000347a:	0009a503          	lw	a0,0(s3)
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	b96080e7          	jalr	-1130(ra) # 80003014 <bread>
    80003486:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003488:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    8000348c:	02049713          	sll	a4,s1,0x20
    80003490:	01e75593          	srl	a1,a4,0x1e
    80003494:	00b784b3          	add	s1,a5,a1
    80003498:	0004a903          	lw	s2,0(s1)
    8000349c:	02090063          	beqz	s2,800034bc <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800034a0:	8552                	mv	a0,s4
    800034a2:	00000097          	auipc	ra,0x0
    800034a6:	ca2080e7          	jalr	-862(ra) # 80003144 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800034aa:	854a                	mv	a0,s2
    800034ac:	70a2                	ld	ra,40(sp)
    800034ae:	7402                	ld	s0,32(sp)
    800034b0:	64e2                	ld	s1,24(sp)
    800034b2:	6942                	ld	s2,16(sp)
    800034b4:	69a2                	ld	s3,8(sp)
    800034b6:	6a02                	ld	s4,0(sp)
    800034b8:	6145                	add	sp,sp,48
    800034ba:	8082                	ret
      addr = balloc(ip->dev);
    800034bc:	0009a503          	lw	a0,0(s3)
    800034c0:	00000097          	auipc	ra,0x0
    800034c4:	e14080e7          	jalr	-492(ra) # 800032d4 <balloc>
    800034c8:	0005091b          	sext.w	s2,a0
      if(addr){
    800034cc:	fc090ae3          	beqz	s2,800034a0 <bmap+0x9a>
        a[bn] = addr;
    800034d0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800034d4:	8552                	mv	a0,s4
    800034d6:	00001097          	auipc	ra,0x1
    800034da:	ec6080e7          	jalr	-314(ra) # 8000439c <log_write>
    800034de:	b7c9                	j	800034a0 <bmap+0x9a>
  panic("bmap: out of range");
    800034e0:	00005517          	auipc	a0,0x5
    800034e4:	0c850513          	add	a0,a0,200 # 800085a8 <syscalls+0x118>
    800034e8:	ffffd097          	auipc	ra,0xffffd
    800034ec:	326080e7          	jalr	806(ra) # 8000080e <panic>

00000000800034f0 <iget>:
{
    800034f0:	7179                	add	sp,sp,-48
    800034f2:	f406                	sd	ra,40(sp)
    800034f4:	f022                	sd	s0,32(sp)
    800034f6:	ec26                	sd	s1,24(sp)
    800034f8:	e84a                	sd	s2,16(sp)
    800034fa:	e44e                	sd	s3,8(sp)
    800034fc:	e052                	sd	s4,0(sp)
    800034fe:	1800                	add	s0,sp,48
    80003500:	89aa                	mv	s3,a0
    80003502:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003504:	0001d517          	auipc	a0,0x1d
    80003508:	8d450513          	add	a0,a0,-1836 # 8001fdd8 <itable>
    8000350c:	ffffd097          	auipc	ra,0xffffd
    80003510:	7c0080e7          	jalr	1984(ra) # 80000ccc <acquire>
  empty = 0;
    80003514:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003516:	0001d497          	auipc	s1,0x1d
    8000351a:	8da48493          	add	s1,s1,-1830 # 8001fdf0 <itable+0x18>
    8000351e:	0001e697          	auipc	a3,0x1e
    80003522:	36268693          	add	a3,a3,866 # 80021880 <log>
    80003526:	a039                	j	80003534 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80003528:	02090b63          	beqz	s2,8000355e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000352c:	08848493          	add	s1,s1,136
    80003530:	02d48a63          	beq	s1,a3,80003564 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003534:	449c                	lw	a5,8(s1)
    80003536:	fef059e3          	blez	a5,80003528 <iget+0x38>
    8000353a:	4098                	lw	a4,0(s1)
    8000353c:	ff3716e3          	bne	a4,s3,80003528 <iget+0x38>
    80003540:	40d8                	lw	a4,4(s1)
    80003542:	ff4713e3          	bne	a4,s4,80003528 <iget+0x38>
      ip->ref++;
    80003546:	2785                	addw	a5,a5,1
    80003548:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000354a:	0001d517          	auipc	a0,0x1d
    8000354e:	88e50513          	add	a0,a0,-1906 # 8001fdd8 <itable>
    80003552:	ffffe097          	auipc	ra,0xffffe
    80003556:	82e080e7          	jalr	-2002(ra) # 80000d80 <release>
      return ip;
    8000355a:	8926                	mv	s2,s1
    8000355c:	a03d                	j	8000358a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    8000355e:	f7f9                	bnez	a5,8000352c <iget+0x3c>
    80003560:	8926                	mv	s2,s1
    80003562:	b7e9                	j	8000352c <iget+0x3c>
  if(empty == 0)
    80003564:	02090c63          	beqz	s2,8000359c <iget+0xac>
  ip->dev = dev;
    80003568:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000356c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003570:	4785                	li	a5,1
    80003572:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003576:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000357a:	0001d517          	auipc	a0,0x1d
    8000357e:	85e50513          	add	a0,a0,-1954 # 8001fdd8 <itable>
    80003582:	ffffd097          	auipc	ra,0xffffd
    80003586:	7fe080e7          	jalr	2046(ra) # 80000d80 <release>
}
    8000358a:	854a                	mv	a0,s2
    8000358c:	70a2                	ld	ra,40(sp)
    8000358e:	7402                	ld	s0,32(sp)
    80003590:	64e2                	ld	s1,24(sp)
    80003592:	6942                	ld	s2,16(sp)
    80003594:	69a2                	ld	s3,8(sp)
    80003596:	6a02                	ld	s4,0(sp)
    80003598:	6145                	add	sp,sp,48
    8000359a:	8082                	ret
    panic("iget: no inodes");
    8000359c:	00005517          	auipc	a0,0x5
    800035a0:	02450513          	add	a0,a0,36 # 800085c0 <syscalls+0x130>
    800035a4:	ffffd097          	auipc	ra,0xffffd
    800035a8:	26a080e7          	jalr	618(ra) # 8000080e <panic>

00000000800035ac <fsinit>:
fsinit(int dev) {
    800035ac:	7179                	add	sp,sp,-48
    800035ae:	f406                	sd	ra,40(sp)
    800035b0:	f022                	sd	s0,32(sp)
    800035b2:	ec26                	sd	s1,24(sp)
    800035b4:	e84a                	sd	s2,16(sp)
    800035b6:	e44e                	sd	s3,8(sp)
    800035b8:	1800                	add	s0,sp,48
    800035ba:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800035bc:	4585                	li	a1,1
    800035be:	00000097          	auipc	ra,0x0
    800035c2:	a56080e7          	jalr	-1450(ra) # 80003014 <bread>
    800035c6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035c8:	0001c997          	auipc	s3,0x1c
    800035cc:	7f098993          	add	s3,s3,2032 # 8001fdb8 <sb>
    800035d0:	02000613          	li	a2,32
    800035d4:	05850593          	add	a1,a0,88
    800035d8:	854e                	mv	a0,s3
    800035da:	ffffe097          	auipc	ra,0xffffe
    800035de:	84a080e7          	jalr	-1974(ra) # 80000e24 <memmove>
  brelse(bp);
    800035e2:	8526                	mv	a0,s1
    800035e4:	00000097          	auipc	ra,0x0
    800035e8:	b60080e7          	jalr	-1184(ra) # 80003144 <brelse>
  if(sb.magic != FSMAGIC)
    800035ec:	0009a703          	lw	a4,0(s3)
    800035f0:	102037b7          	lui	a5,0x10203
    800035f4:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035f8:	02f71263          	bne	a4,a5,8000361c <fsinit+0x70>
  initlog(dev, &sb);
    800035fc:	0001c597          	auipc	a1,0x1c
    80003600:	7bc58593          	add	a1,a1,1980 # 8001fdb8 <sb>
    80003604:	854a                	mv	a0,s2
    80003606:	00001097          	auipc	ra,0x1
    8000360a:	b2c080e7          	jalr	-1236(ra) # 80004132 <initlog>
}
    8000360e:	70a2                	ld	ra,40(sp)
    80003610:	7402                	ld	s0,32(sp)
    80003612:	64e2                	ld	s1,24(sp)
    80003614:	6942                	ld	s2,16(sp)
    80003616:	69a2                	ld	s3,8(sp)
    80003618:	6145                	add	sp,sp,48
    8000361a:	8082                	ret
    panic("invalid file system");
    8000361c:	00005517          	auipc	a0,0x5
    80003620:	fb450513          	add	a0,a0,-76 # 800085d0 <syscalls+0x140>
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	1ea080e7          	jalr	490(ra) # 8000080e <panic>

000000008000362c <iinit>:
{
    8000362c:	7179                	add	sp,sp,-48
    8000362e:	f406                	sd	ra,40(sp)
    80003630:	f022                	sd	s0,32(sp)
    80003632:	ec26                	sd	s1,24(sp)
    80003634:	e84a                	sd	s2,16(sp)
    80003636:	e44e                	sd	s3,8(sp)
    80003638:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    8000363a:	00005597          	auipc	a1,0x5
    8000363e:	fae58593          	add	a1,a1,-82 # 800085e8 <syscalls+0x158>
    80003642:	0001c517          	auipc	a0,0x1c
    80003646:	79650513          	add	a0,a0,1942 # 8001fdd8 <itable>
    8000364a:	ffffd097          	auipc	ra,0xffffd
    8000364e:	5f2080e7          	jalr	1522(ra) # 80000c3c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003652:	0001c497          	auipc	s1,0x1c
    80003656:	7ae48493          	add	s1,s1,1966 # 8001fe00 <itable+0x28>
    8000365a:	0001e997          	auipc	s3,0x1e
    8000365e:	23698993          	add	s3,s3,566 # 80021890 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003662:	00005917          	auipc	s2,0x5
    80003666:	f8e90913          	add	s2,s2,-114 # 800085f0 <syscalls+0x160>
    8000366a:	85ca                	mv	a1,s2
    8000366c:	8526                	mv	a0,s1
    8000366e:	00001097          	auipc	ra,0x1
    80003672:	e12080e7          	jalr	-494(ra) # 80004480 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003676:	08848493          	add	s1,s1,136
    8000367a:	ff3498e3          	bne	s1,s3,8000366a <iinit+0x3e>
}
    8000367e:	70a2                	ld	ra,40(sp)
    80003680:	7402                	ld	s0,32(sp)
    80003682:	64e2                	ld	s1,24(sp)
    80003684:	6942                	ld	s2,16(sp)
    80003686:	69a2                	ld	s3,8(sp)
    80003688:	6145                	add	sp,sp,48
    8000368a:	8082                	ret

000000008000368c <ialloc>:
{
    8000368c:	7139                	add	sp,sp,-64
    8000368e:	fc06                	sd	ra,56(sp)
    80003690:	f822                	sd	s0,48(sp)
    80003692:	f426                	sd	s1,40(sp)
    80003694:	f04a                	sd	s2,32(sp)
    80003696:	ec4e                	sd	s3,24(sp)
    80003698:	e852                	sd	s4,16(sp)
    8000369a:	e456                	sd	s5,8(sp)
    8000369c:	e05a                	sd	s6,0(sp)
    8000369e:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800036a0:	0001c717          	auipc	a4,0x1c
    800036a4:	72472703          	lw	a4,1828(a4) # 8001fdc4 <sb+0xc>
    800036a8:	4785                	li	a5,1
    800036aa:	04e7f863          	bgeu	a5,a4,800036fa <ialloc+0x6e>
    800036ae:	8aaa                	mv	s5,a0
    800036b0:	8b2e                	mv	s6,a1
    800036b2:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800036b4:	0001ca17          	auipc	s4,0x1c
    800036b8:	704a0a13          	add	s4,s4,1796 # 8001fdb8 <sb>
    800036bc:	00495593          	srl	a1,s2,0x4
    800036c0:	018a2783          	lw	a5,24(s4)
    800036c4:	9dbd                	addw	a1,a1,a5
    800036c6:	8556                	mv	a0,s5
    800036c8:	00000097          	auipc	ra,0x0
    800036cc:	94c080e7          	jalr	-1716(ra) # 80003014 <bread>
    800036d0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800036d2:	05850993          	add	s3,a0,88
    800036d6:	00f97793          	and	a5,s2,15
    800036da:	079a                	sll	a5,a5,0x6
    800036dc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    800036de:	00099783          	lh	a5,0(s3)
    800036e2:	cf9d                	beqz	a5,80003720 <ialloc+0x94>
    brelse(bp);
    800036e4:	00000097          	auipc	ra,0x0
    800036e8:	a60080e7          	jalr	-1440(ra) # 80003144 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800036ec:	0905                	add	s2,s2,1
    800036ee:	00ca2703          	lw	a4,12(s4)
    800036f2:	0009079b          	sext.w	a5,s2
    800036f6:	fce7e3e3          	bltu	a5,a4,800036bc <ialloc+0x30>
  printf("ialloc: no inodes\n");
    800036fa:	00005517          	auipc	a0,0x5
    800036fe:	efe50513          	add	a0,a0,-258 # 800085f8 <syscalls+0x168>
    80003702:	ffffd097          	auipc	ra,0xffffd
    80003706:	e00080e7          	jalr	-512(ra) # 80000502 <printf>
  return 0;
    8000370a:	4501                	li	a0,0
}
    8000370c:	70e2                	ld	ra,56(sp)
    8000370e:	7442                	ld	s0,48(sp)
    80003710:	74a2                	ld	s1,40(sp)
    80003712:	7902                	ld	s2,32(sp)
    80003714:	69e2                	ld	s3,24(sp)
    80003716:	6a42                	ld	s4,16(sp)
    80003718:	6aa2                	ld	s5,8(sp)
    8000371a:	6b02                	ld	s6,0(sp)
    8000371c:	6121                	add	sp,sp,64
    8000371e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003720:	04000613          	li	a2,64
    80003724:	4581                	li	a1,0
    80003726:	854e                	mv	a0,s3
    80003728:	ffffd097          	auipc	ra,0xffffd
    8000372c:	6a0080e7          	jalr	1696(ra) # 80000dc8 <memset>
      dip->type = type;
    80003730:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80003734:	8526                	mv	a0,s1
    80003736:	00001097          	auipc	ra,0x1
    8000373a:	c66080e7          	jalr	-922(ra) # 8000439c <log_write>
      brelse(bp);
    8000373e:	8526                	mv	a0,s1
    80003740:	00000097          	auipc	ra,0x0
    80003744:	a04080e7          	jalr	-1532(ra) # 80003144 <brelse>
      return iget(dev, inum);
    80003748:	0009059b          	sext.w	a1,s2
    8000374c:	8556                	mv	a0,s5
    8000374e:	00000097          	auipc	ra,0x0
    80003752:	da2080e7          	jalr	-606(ra) # 800034f0 <iget>
    80003756:	bf5d                	j	8000370c <ialloc+0x80>

0000000080003758 <iupdate>:
{
    80003758:	1101                	add	sp,sp,-32
    8000375a:	ec06                	sd	ra,24(sp)
    8000375c:	e822                	sd	s0,16(sp)
    8000375e:	e426                	sd	s1,8(sp)
    80003760:	e04a                	sd	s2,0(sp)
    80003762:	1000                	add	s0,sp,32
    80003764:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003766:	415c                	lw	a5,4(a0)
    80003768:	0047d79b          	srlw	a5,a5,0x4
    8000376c:	0001c597          	auipc	a1,0x1c
    80003770:	6645a583          	lw	a1,1636(a1) # 8001fdd0 <sb+0x18>
    80003774:	9dbd                	addw	a1,a1,a5
    80003776:	4108                	lw	a0,0(a0)
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	89c080e7          	jalr	-1892(ra) # 80003014 <bread>
    80003780:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003782:	05850793          	add	a5,a0,88
    80003786:	40d8                	lw	a4,4(s1)
    80003788:	8b3d                	and	a4,a4,15
    8000378a:	071a                	sll	a4,a4,0x6
    8000378c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000378e:	04449703          	lh	a4,68(s1)
    80003792:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003796:	04649703          	lh	a4,70(s1)
    8000379a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000379e:	04849703          	lh	a4,72(s1)
    800037a2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800037a6:	04a49703          	lh	a4,74(s1)
    800037aa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800037ae:	44f8                	lw	a4,76(s1)
    800037b0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800037b2:	03400613          	li	a2,52
    800037b6:	05048593          	add	a1,s1,80
    800037ba:	00c78513          	add	a0,a5,12
    800037be:	ffffd097          	auipc	ra,0xffffd
    800037c2:	666080e7          	jalr	1638(ra) # 80000e24 <memmove>
  log_write(bp);
    800037c6:	854a                	mv	a0,s2
    800037c8:	00001097          	auipc	ra,0x1
    800037cc:	bd4080e7          	jalr	-1068(ra) # 8000439c <log_write>
  brelse(bp);
    800037d0:	854a                	mv	a0,s2
    800037d2:	00000097          	auipc	ra,0x0
    800037d6:	972080e7          	jalr	-1678(ra) # 80003144 <brelse>
}
    800037da:	60e2                	ld	ra,24(sp)
    800037dc:	6442                	ld	s0,16(sp)
    800037de:	64a2                	ld	s1,8(sp)
    800037e0:	6902                	ld	s2,0(sp)
    800037e2:	6105                	add	sp,sp,32
    800037e4:	8082                	ret

00000000800037e6 <idup>:
{
    800037e6:	1101                	add	sp,sp,-32
    800037e8:	ec06                	sd	ra,24(sp)
    800037ea:	e822                	sd	s0,16(sp)
    800037ec:	e426                	sd	s1,8(sp)
    800037ee:	1000                	add	s0,sp,32
    800037f0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037f2:	0001c517          	auipc	a0,0x1c
    800037f6:	5e650513          	add	a0,a0,1510 # 8001fdd8 <itable>
    800037fa:	ffffd097          	auipc	ra,0xffffd
    800037fe:	4d2080e7          	jalr	1234(ra) # 80000ccc <acquire>
  ip->ref++;
    80003802:	449c                	lw	a5,8(s1)
    80003804:	2785                	addw	a5,a5,1
    80003806:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003808:	0001c517          	auipc	a0,0x1c
    8000380c:	5d050513          	add	a0,a0,1488 # 8001fdd8 <itable>
    80003810:	ffffd097          	auipc	ra,0xffffd
    80003814:	570080e7          	jalr	1392(ra) # 80000d80 <release>
}
    80003818:	8526                	mv	a0,s1
    8000381a:	60e2                	ld	ra,24(sp)
    8000381c:	6442                	ld	s0,16(sp)
    8000381e:	64a2                	ld	s1,8(sp)
    80003820:	6105                	add	sp,sp,32
    80003822:	8082                	ret

0000000080003824 <ilock>:
{
    80003824:	1101                	add	sp,sp,-32
    80003826:	ec06                	sd	ra,24(sp)
    80003828:	e822                	sd	s0,16(sp)
    8000382a:	e426                	sd	s1,8(sp)
    8000382c:	e04a                	sd	s2,0(sp)
    8000382e:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003830:	c115                	beqz	a0,80003854 <ilock+0x30>
    80003832:	84aa                	mv	s1,a0
    80003834:	451c                	lw	a5,8(a0)
    80003836:	00f05f63          	blez	a5,80003854 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000383a:	0541                	add	a0,a0,16
    8000383c:	00001097          	auipc	ra,0x1
    80003840:	c7e080e7          	jalr	-898(ra) # 800044ba <acquiresleep>
  if(ip->valid == 0){
    80003844:	40bc                	lw	a5,64(s1)
    80003846:	cf99                	beqz	a5,80003864 <ilock+0x40>
}
    80003848:	60e2                	ld	ra,24(sp)
    8000384a:	6442                	ld	s0,16(sp)
    8000384c:	64a2                	ld	s1,8(sp)
    8000384e:	6902                	ld	s2,0(sp)
    80003850:	6105                	add	sp,sp,32
    80003852:	8082                	ret
    panic("ilock");
    80003854:	00005517          	auipc	a0,0x5
    80003858:	dbc50513          	add	a0,a0,-580 # 80008610 <syscalls+0x180>
    8000385c:	ffffd097          	auipc	ra,0xffffd
    80003860:	fb2080e7          	jalr	-78(ra) # 8000080e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003864:	40dc                	lw	a5,4(s1)
    80003866:	0047d79b          	srlw	a5,a5,0x4
    8000386a:	0001c597          	auipc	a1,0x1c
    8000386e:	5665a583          	lw	a1,1382(a1) # 8001fdd0 <sb+0x18>
    80003872:	9dbd                	addw	a1,a1,a5
    80003874:	4088                	lw	a0,0(s1)
    80003876:	fffff097          	auipc	ra,0xfffff
    8000387a:	79e080e7          	jalr	1950(ra) # 80003014 <bread>
    8000387e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003880:	05850593          	add	a1,a0,88
    80003884:	40dc                	lw	a5,4(s1)
    80003886:	8bbd                	and	a5,a5,15
    80003888:	079a                	sll	a5,a5,0x6
    8000388a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000388c:	00059783          	lh	a5,0(a1)
    80003890:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003894:	00259783          	lh	a5,2(a1)
    80003898:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000389c:	00459783          	lh	a5,4(a1)
    800038a0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800038a4:	00659783          	lh	a5,6(a1)
    800038a8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800038ac:	459c                	lw	a5,8(a1)
    800038ae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800038b0:	03400613          	li	a2,52
    800038b4:	05b1                	add	a1,a1,12
    800038b6:	05048513          	add	a0,s1,80
    800038ba:	ffffd097          	auipc	ra,0xffffd
    800038be:	56a080e7          	jalr	1386(ra) # 80000e24 <memmove>
    brelse(bp);
    800038c2:	854a                	mv	a0,s2
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	880080e7          	jalr	-1920(ra) # 80003144 <brelse>
    ip->valid = 1;
    800038cc:	4785                	li	a5,1
    800038ce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800038d0:	04449783          	lh	a5,68(s1)
    800038d4:	fbb5                	bnez	a5,80003848 <ilock+0x24>
      panic("ilock: no type");
    800038d6:	00005517          	auipc	a0,0x5
    800038da:	d4250513          	add	a0,a0,-702 # 80008618 <syscalls+0x188>
    800038de:	ffffd097          	auipc	ra,0xffffd
    800038e2:	f30080e7          	jalr	-208(ra) # 8000080e <panic>

00000000800038e6 <iunlock>:
{
    800038e6:	1101                	add	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	e04a                	sd	s2,0(sp)
    800038f0:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800038f2:	c905                	beqz	a0,80003922 <iunlock+0x3c>
    800038f4:	84aa                	mv	s1,a0
    800038f6:	01050913          	add	s2,a0,16
    800038fa:	854a                	mv	a0,s2
    800038fc:	00001097          	auipc	ra,0x1
    80003900:	c58080e7          	jalr	-936(ra) # 80004554 <holdingsleep>
    80003904:	cd19                	beqz	a0,80003922 <iunlock+0x3c>
    80003906:	449c                	lw	a5,8(s1)
    80003908:	00f05d63          	blez	a5,80003922 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000390c:	854a                	mv	a0,s2
    8000390e:	00001097          	auipc	ra,0x1
    80003912:	c02080e7          	jalr	-1022(ra) # 80004510 <releasesleep>
}
    80003916:	60e2                	ld	ra,24(sp)
    80003918:	6442                	ld	s0,16(sp)
    8000391a:	64a2                	ld	s1,8(sp)
    8000391c:	6902                	ld	s2,0(sp)
    8000391e:	6105                	add	sp,sp,32
    80003920:	8082                	ret
    panic("iunlock");
    80003922:	00005517          	auipc	a0,0x5
    80003926:	d0650513          	add	a0,a0,-762 # 80008628 <syscalls+0x198>
    8000392a:	ffffd097          	auipc	ra,0xffffd
    8000392e:	ee4080e7          	jalr	-284(ra) # 8000080e <panic>

0000000080003932 <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    80003932:	7179                	add	sp,sp,-48
    80003934:	f406                	sd	ra,40(sp)
    80003936:	f022                	sd	s0,32(sp)
    80003938:	ec26                	sd	s1,24(sp)
    8000393a:	e84a                	sd	s2,16(sp)
    8000393c:	e44e                	sd	s3,8(sp)
    8000393e:	e052                	sd	s4,0(sp)
    80003940:	1800                	add	s0,sp,48
    80003942:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003944:	05050493          	add	s1,a0,80
    80003948:	08050913          	add	s2,a0,128
    8000394c:	a021                	j	80003954 <itrunc+0x22>
    8000394e:	0491                	add	s1,s1,4
    80003950:	01248d63          	beq	s1,s2,8000396a <itrunc+0x38>
    if(ip->addrs[i]){
    80003954:	408c                	lw	a1,0(s1)
    80003956:	dde5                	beqz	a1,8000394e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003958:	0009a503          	lw	a0,0(s3)
    8000395c:	00000097          	auipc	ra,0x0
    80003960:	8fc080e7          	jalr	-1796(ra) # 80003258 <bfree>
      ip->addrs[i] = 0;
    80003964:	0004a023          	sw	zero,0(s1)
    80003968:	b7dd                	j	8000394e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000396a:	0809a583          	lw	a1,128(s3)
    8000396e:	e185                	bnez	a1,8000398e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003970:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003974:	854e                	mv	a0,s3
    80003976:	00000097          	auipc	ra,0x0
    8000397a:	de2080e7          	jalr	-542(ra) # 80003758 <iupdate>
}
    8000397e:	70a2                	ld	ra,40(sp)
    80003980:	7402                	ld	s0,32(sp)
    80003982:	64e2                	ld	s1,24(sp)
    80003984:	6942                	ld	s2,16(sp)
    80003986:	69a2                	ld	s3,8(sp)
    80003988:	6a02                	ld	s4,0(sp)
    8000398a:	6145                	add	sp,sp,48
    8000398c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000398e:	0009a503          	lw	a0,0(s3)
    80003992:	fffff097          	auipc	ra,0xfffff
    80003996:	682080e7          	jalr	1666(ra) # 80003014 <bread>
    8000399a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000399c:	05850493          	add	s1,a0,88
    800039a0:	45850913          	add	s2,a0,1112
    800039a4:	a021                	j	800039ac <itrunc+0x7a>
    800039a6:	0491                	add	s1,s1,4
    800039a8:	01248b63          	beq	s1,s2,800039be <itrunc+0x8c>
      if(a[j])
    800039ac:	408c                	lw	a1,0(s1)
    800039ae:	dde5                	beqz	a1,800039a6 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800039b0:	0009a503          	lw	a0,0(s3)
    800039b4:	00000097          	auipc	ra,0x0
    800039b8:	8a4080e7          	jalr	-1884(ra) # 80003258 <bfree>
    800039bc:	b7ed                	j	800039a6 <itrunc+0x74>
    brelse(bp);
    800039be:	8552                	mv	a0,s4
    800039c0:	fffff097          	auipc	ra,0xfffff
    800039c4:	784080e7          	jalr	1924(ra) # 80003144 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800039c8:	0809a583          	lw	a1,128(s3)
    800039cc:	0009a503          	lw	a0,0(s3)
    800039d0:	00000097          	auipc	ra,0x0
    800039d4:	888080e7          	jalr	-1912(ra) # 80003258 <bfree>
    ip->addrs[NDIRECT] = 0;
    800039d8:	0809a023          	sw	zero,128(s3)
    800039dc:	bf51                	j	80003970 <itrunc+0x3e>

00000000800039de <iput>:
{
    800039de:	1101                	add	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	e04a                	sd	s2,0(sp)
    800039e8:	1000                	add	s0,sp,32
    800039ea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800039ec:	0001c517          	auipc	a0,0x1c
    800039f0:	3ec50513          	add	a0,a0,1004 # 8001fdd8 <itable>
    800039f4:	ffffd097          	auipc	ra,0xffffd
    800039f8:	2d8080e7          	jalr	728(ra) # 80000ccc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039fc:	4498                	lw	a4,8(s1)
    800039fe:	4785                	li	a5,1
    80003a00:	02f70363          	beq	a4,a5,80003a26 <iput+0x48>
  ip->ref--;
    80003a04:	449c                	lw	a5,8(s1)
    80003a06:	37fd                	addw	a5,a5,-1
    80003a08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a0a:	0001c517          	auipc	a0,0x1c
    80003a0e:	3ce50513          	add	a0,a0,974 # 8001fdd8 <itable>
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	36e080e7          	jalr	878(ra) # 80000d80 <release>
}
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6902                	ld	s2,0(sp)
    80003a22:	6105                	add	sp,sp,32
    80003a24:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a26:	40bc                	lw	a5,64(s1)
    80003a28:	dff1                	beqz	a5,80003a04 <iput+0x26>
    80003a2a:	04a49783          	lh	a5,74(s1)
    80003a2e:	fbf9                	bnez	a5,80003a04 <iput+0x26>
    acquiresleep(&ip->lock);
    80003a30:	01048913          	add	s2,s1,16
    80003a34:	854a                	mv	a0,s2
    80003a36:	00001097          	auipc	ra,0x1
    80003a3a:	a84080e7          	jalr	-1404(ra) # 800044ba <acquiresleep>
    release(&itable.lock);
    80003a3e:	0001c517          	auipc	a0,0x1c
    80003a42:	39a50513          	add	a0,a0,922 # 8001fdd8 <itable>
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	33a080e7          	jalr	826(ra) # 80000d80 <release>
    itrunc(ip);
    80003a4e:	8526                	mv	a0,s1
    80003a50:	00000097          	auipc	ra,0x0
    80003a54:	ee2080e7          	jalr	-286(ra) # 80003932 <itrunc>
    ip->type = 0;
    80003a58:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a5c:	8526                	mv	a0,s1
    80003a5e:	00000097          	auipc	ra,0x0
    80003a62:	cfa080e7          	jalr	-774(ra) # 80003758 <iupdate>
    ip->valid = 0;
    80003a66:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a6a:	854a                	mv	a0,s2
    80003a6c:	00001097          	auipc	ra,0x1
    80003a70:	aa4080e7          	jalr	-1372(ra) # 80004510 <releasesleep>
    acquire(&itable.lock);
    80003a74:	0001c517          	auipc	a0,0x1c
    80003a78:	36450513          	add	a0,a0,868 # 8001fdd8 <itable>
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	250080e7          	jalr	592(ra) # 80000ccc <acquire>
    80003a84:	b741                	j	80003a04 <iput+0x26>

0000000080003a86 <iunlockput>:
{
    80003a86:	1101                	add	sp,sp,-32
    80003a88:	ec06                	sd	ra,24(sp)
    80003a8a:	e822                	sd	s0,16(sp)
    80003a8c:	e426                	sd	s1,8(sp)
    80003a8e:	1000                	add	s0,sp,32
    80003a90:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a92:	00000097          	auipc	ra,0x0
    80003a96:	e54080e7          	jalr	-428(ra) # 800038e6 <iunlock>
  iput(ip);
    80003a9a:	8526                	mv	a0,s1
    80003a9c:	00000097          	auipc	ra,0x0
    80003aa0:	f42080e7          	jalr	-190(ra) # 800039de <iput>
}
    80003aa4:	60e2                	ld	ra,24(sp)
    80003aa6:	6442                	ld	s0,16(sp)
    80003aa8:	64a2                	ld	s1,8(sp)
    80003aaa:	6105                	add	sp,sp,32
    80003aac:	8082                	ret

0000000080003aae <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80003aae:	1141                	add	sp,sp,-16
    80003ab0:	e422                	sd	s0,8(sp)
    80003ab2:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003ab4:	411c                	lw	a5,0(a0)
    80003ab6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003ab8:	415c                	lw	a5,4(a0)
    80003aba:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003abc:	04451783          	lh	a5,68(a0)
    80003ac0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003ac4:	04a51783          	lh	a5,74(a0)
    80003ac8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003acc:	04c56783          	lwu	a5,76(a0)
    80003ad0:	e99c                	sd	a5,16(a1)
}
    80003ad2:	6422                	ld	s0,8(sp)
    80003ad4:	0141                	add	sp,sp,16
    80003ad6:	8082                	ret

0000000080003ad8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ad8:	457c                	lw	a5,76(a0)
    80003ada:	0ed7e963          	bltu	a5,a3,80003bcc <readi+0xf4>
{
    80003ade:	7159                	add	sp,sp,-112
    80003ae0:	f486                	sd	ra,104(sp)
    80003ae2:	f0a2                	sd	s0,96(sp)
    80003ae4:	eca6                	sd	s1,88(sp)
    80003ae6:	e8ca                	sd	s2,80(sp)
    80003ae8:	e4ce                	sd	s3,72(sp)
    80003aea:	e0d2                	sd	s4,64(sp)
    80003aec:	fc56                	sd	s5,56(sp)
    80003aee:	f85a                	sd	s6,48(sp)
    80003af0:	f45e                	sd	s7,40(sp)
    80003af2:	f062                	sd	s8,32(sp)
    80003af4:	ec66                	sd	s9,24(sp)
    80003af6:	e86a                	sd	s10,16(sp)
    80003af8:	e46e                	sd	s11,8(sp)
    80003afa:	1880                	add	s0,sp,112
    80003afc:	8b2a                	mv	s6,a0
    80003afe:	8bae                	mv	s7,a1
    80003b00:	8a32                	mv	s4,a2
    80003b02:	84b6                	mv	s1,a3
    80003b04:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003b06:	9f35                	addw	a4,a4,a3
    return 0;
    80003b08:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003b0a:	0ad76063          	bltu	a4,a3,80003baa <readi+0xd2>
  if(off + n > ip->size)
    80003b0e:	00e7f463          	bgeu	a5,a4,80003b16 <readi+0x3e>
    n = ip->size - off;
    80003b12:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b16:	0a0a8963          	beqz	s5,80003bc8 <readi+0xf0>
    80003b1a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b1c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b20:	5c7d                	li	s8,-1
    80003b22:	a82d                	j	80003b5c <readi+0x84>
    80003b24:	020d1d93          	sll	s11,s10,0x20
    80003b28:	020ddd93          	srl	s11,s11,0x20
    80003b2c:	05890613          	add	a2,s2,88
    80003b30:	86ee                	mv	a3,s11
    80003b32:	963a                	add	a2,a2,a4
    80003b34:	85d2                	mv	a1,s4
    80003b36:	855e                	mv	a0,s7
    80003b38:	fffff097          	auipc	ra,0xfffff
    80003b3c:	b32080e7          	jalr	-1230(ra) # 8000266a <either_copyout>
    80003b40:	05850d63          	beq	a0,s8,80003b9a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003b44:	854a                	mv	a0,s2
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	5fe080e7          	jalr	1534(ra) # 80003144 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b4e:	013d09bb          	addw	s3,s10,s3
    80003b52:	009d04bb          	addw	s1,s10,s1
    80003b56:	9a6e                	add	s4,s4,s11
    80003b58:	0559f763          	bgeu	s3,s5,80003ba6 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003b5c:	00a4d59b          	srlw	a1,s1,0xa
    80003b60:	855a                	mv	a0,s6
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	8a4080e7          	jalr	-1884(ra) # 80003406 <bmap>
    80003b6a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b6e:	cd85                	beqz	a1,80003ba6 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003b70:	000b2503          	lw	a0,0(s6)
    80003b74:	fffff097          	auipc	ra,0xfffff
    80003b78:	4a0080e7          	jalr	1184(ra) # 80003014 <bread>
    80003b7c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b7e:	3ff4f713          	and	a4,s1,1023
    80003b82:	40ec87bb          	subw	a5,s9,a4
    80003b86:	413a86bb          	subw	a3,s5,s3
    80003b8a:	8d3e                	mv	s10,a5
    80003b8c:	2781                	sext.w	a5,a5
    80003b8e:	0006861b          	sext.w	a2,a3
    80003b92:	f8f679e3          	bgeu	a2,a5,80003b24 <readi+0x4c>
    80003b96:	8d36                	mv	s10,a3
    80003b98:	b771                	j	80003b24 <readi+0x4c>
      brelse(bp);
    80003b9a:	854a                	mv	a0,s2
    80003b9c:	fffff097          	auipc	ra,0xfffff
    80003ba0:	5a8080e7          	jalr	1448(ra) # 80003144 <brelse>
      tot = -1;
    80003ba4:	59fd                	li	s3,-1
  }
  return tot;
    80003ba6:	0009851b          	sext.w	a0,s3
}
    80003baa:	70a6                	ld	ra,104(sp)
    80003bac:	7406                	ld	s0,96(sp)
    80003bae:	64e6                	ld	s1,88(sp)
    80003bb0:	6946                	ld	s2,80(sp)
    80003bb2:	69a6                	ld	s3,72(sp)
    80003bb4:	6a06                	ld	s4,64(sp)
    80003bb6:	7ae2                	ld	s5,56(sp)
    80003bb8:	7b42                	ld	s6,48(sp)
    80003bba:	7ba2                	ld	s7,40(sp)
    80003bbc:	7c02                	ld	s8,32(sp)
    80003bbe:	6ce2                	ld	s9,24(sp)
    80003bc0:	6d42                	ld	s10,16(sp)
    80003bc2:	6da2                	ld	s11,8(sp)
    80003bc4:	6165                	add	sp,sp,112
    80003bc6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003bc8:	89d6                	mv	s3,s5
    80003bca:	bff1                	j	80003ba6 <readi+0xce>
    return 0;
    80003bcc:	4501                	li	a0,0
}
    80003bce:	8082                	ret

0000000080003bd0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003bd0:	457c                	lw	a5,76(a0)
    80003bd2:	10d7e863          	bltu	a5,a3,80003ce2 <writei+0x112>
{
    80003bd6:	7159                	add	sp,sp,-112
    80003bd8:	f486                	sd	ra,104(sp)
    80003bda:	f0a2                	sd	s0,96(sp)
    80003bdc:	eca6                	sd	s1,88(sp)
    80003bde:	e8ca                	sd	s2,80(sp)
    80003be0:	e4ce                	sd	s3,72(sp)
    80003be2:	e0d2                	sd	s4,64(sp)
    80003be4:	fc56                	sd	s5,56(sp)
    80003be6:	f85a                	sd	s6,48(sp)
    80003be8:	f45e                	sd	s7,40(sp)
    80003bea:	f062                	sd	s8,32(sp)
    80003bec:	ec66                	sd	s9,24(sp)
    80003bee:	e86a                	sd	s10,16(sp)
    80003bf0:	e46e                	sd	s11,8(sp)
    80003bf2:	1880                	add	s0,sp,112
    80003bf4:	8aaa                	mv	s5,a0
    80003bf6:	8bae                	mv	s7,a1
    80003bf8:	8a32                	mv	s4,a2
    80003bfa:	8936                	mv	s2,a3
    80003bfc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003bfe:	00e687bb          	addw	a5,a3,a4
    80003c02:	0ed7e263          	bltu	a5,a3,80003ce6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c06:	00043737          	lui	a4,0x43
    80003c0a:	0ef76063          	bltu	a4,a5,80003cea <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c0e:	0c0b0863          	beqz	s6,80003cde <writei+0x10e>
    80003c12:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c14:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c18:	5c7d                	li	s8,-1
    80003c1a:	a091                	j	80003c5e <writei+0x8e>
    80003c1c:	020d1d93          	sll	s11,s10,0x20
    80003c20:	020ddd93          	srl	s11,s11,0x20
    80003c24:	05848513          	add	a0,s1,88
    80003c28:	86ee                	mv	a3,s11
    80003c2a:	8652                	mv	a2,s4
    80003c2c:	85de                	mv	a1,s7
    80003c2e:	953a                	add	a0,a0,a4
    80003c30:	fffff097          	auipc	ra,0xfffff
    80003c34:	a90080e7          	jalr	-1392(ra) # 800026c0 <either_copyin>
    80003c38:	07850263          	beq	a0,s8,80003c9c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c3c:	8526                	mv	a0,s1
    80003c3e:	00000097          	auipc	ra,0x0
    80003c42:	75e080e7          	jalr	1886(ra) # 8000439c <log_write>
    brelse(bp);
    80003c46:	8526                	mv	a0,s1
    80003c48:	fffff097          	auipc	ra,0xfffff
    80003c4c:	4fc080e7          	jalr	1276(ra) # 80003144 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c50:	013d09bb          	addw	s3,s10,s3
    80003c54:	012d093b          	addw	s2,s10,s2
    80003c58:	9a6e                	add	s4,s4,s11
    80003c5a:	0569f663          	bgeu	s3,s6,80003ca6 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003c5e:	00a9559b          	srlw	a1,s2,0xa
    80003c62:	8556                	mv	a0,s5
    80003c64:	fffff097          	auipc	ra,0xfffff
    80003c68:	7a2080e7          	jalr	1954(ra) # 80003406 <bmap>
    80003c6c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003c70:	c99d                	beqz	a1,80003ca6 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003c72:	000aa503          	lw	a0,0(s5)
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	39e080e7          	jalr	926(ra) # 80003014 <bread>
    80003c7e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c80:	3ff97713          	and	a4,s2,1023
    80003c84:	40ec87bb          	subw	a5,s9,a4
    80003c88:	413b06bb          	subw	a3,s6,s3
    80003c8c:	8d3e                	mv	s10,a5
    80003c8e:	2781                	sext.w	a5,a5
    80003c90:	0006861b          	sext.w	a2,a3
    80003c94:	f8f674e3          	bgeu	a2,a5,80003c1c <writei+0x4c>
    80003c98:	8d36                	mv	s10,a3
    80003c9a:	b749                	j	80003c1c <writei+0x4c>
      brelse(bp);
    80003c9c:	8526                	mv	a0,s1
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	4a6080e7          	jalr	1190(ra) # 80003144 <brelse>
  }

  if(off > ip->size)
    80003ca6:	04caa783          	lw	a5,76(s5)
    80003caa:	0127f463          	bgeu	a5,s2,80003cb2 <writei+0xe2>
    ip->size = off;
    80003cae:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    80003cb2:	8556                	mv	a0,s5
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	aa4080e7          	jalr	-1372(ra) # 80003758 <iupdate>

  return tot;
    80003cbc:	0009851b          	sext.w	a0,s3
}
    80003cc0:	70a6                	ld	ra,104(sp)
    80003cc2:	7406                	ld	s0,96(sp)
    80003cc4:	64e6                	ld	s1,88(sp)
    80003cc6:	6946                	ld	s2,80(sp)
    80003cc8:	69a6                	ld	s3,72(sp)
    80003cca:	6a06                	ld	s4,64(sp)
    80003ccc:	7ae2                	ld	s5,56(sp)
    80003cce:	7b42                	ld	s6,48(sp)
    80003cd0:	7ba2                	ld	s7,40(sp)
    80003cd2:	7c02                	ld	s8,32(sp)
    80003cd4:	6ce2                	ld	s9,24(sp)
    80003cd6:	6d42                	ld	s10,16(sp)
    80003cd8:	6da2                	ld	s11,8(sp)
    80003cda:	6165                	add	sp,sp,112
    80003cdc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003cde:	89da                	mv	s3,s6
    80003ce0:	bfc9                	j	80003cb2 <writei+0xe2>
    return -1;
    80003ce2:	557d                	li	a0,-1
}
    80003ce4:	8082                	ret
    return -1;
    80003ce6:	557d                	li	a0,-1
    80003ce8:	bfe1                	j	80003cc0 <writei+0xf0>
    return -1;
    80003cea:	557d                	li	a0,-1
    80003cec:	bfd1                	j	80003cc0 <writei+0xf0>

0000000080003cee <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    80003cee:	1141                	add	sp,sp,-16
    80003cf0:	e406                	sd	ra,8(sp)
    80003cf2:	e022                	sd	s0,0(sp)
    80003cf4:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003cf6:	4639                	li	a2,14
    80003cf8:	ffffd097          	auipc	ra,0xffffd
    80003cfc:	1a0080e7          	jalr	416(ra) # 80000e98 <strncmp>
}
    80003d00:	60a2                	ld	ra,8(sp)
    80003d02:	6402                	ld	s0,0(sp)
    80003d04:	0141                	add	sp,sp,16
    80003d06:	8082                	ret

0000000080003d08 <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d08:	7139                	add	sp,sp,-64
    80003d0a:	fc06                	sd	ra,56(sp)
    80003d0c:	f822                	sd	s0,48(sp)
    80003d0e:	f426                	sd	s1,40(sp)
    80003d10:	f04a                	sd	s2,32(sp)
    80003d12:	ec4e                	sd	s3,24(sp)
    80003d14:	e852                	sd	s4,16(sp)
    80003d16:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d18:	04451703          	lh	a4,68(a0)
    80003d1c:	4785                	li	a5,1
    80003d1e:	00f71a63          	bne	a4,a5,80003d32 <dirlookup+0x2a>
    80003d22:	892a                	mv	s2,a0
    80003d24:	89ae                	mv	s3,a1
    80003d26:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d28:	457c                	lw	a5,76(a0)
    80003d2a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d2c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d2e:	e79d                	bnez	a5,80003d5c <dirlookup+0x54>
    80003d30:	a8a5                	j	80003da8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d32:	00005517          	auipc	a0,0x5
    80003d36:	8fe50513          	add	a0,a0,-1794 # 80008630 <syscalls+0x1a0>
    80003d3a:	ffffd097          	auipc	ra,0xffffd
    80003d3e:	ad4080e7          	jalr	-1324(ra) # 8000080e <panic>
      panic("dirlookup read");
    80003d42:	00005517          	auipc	a0,0x5
    80003d46:	90650513          	add	a0,a0,-1786 # 80008648 <syscalls+0x1b8>
    80003d4a:	ffffd097          	auipc	ra,0xffffd
    80003d4e:	ac4080e7          	jalr	-1340(ra) # 8000080e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d52:	24c1                	addw	s1,s1,16
    80003d54:	04c92783          	lw	a5,76(s2)
    80003d58:	04f4f763          	bgeu	s1,a5,80003da6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d5c:	4741                	li	a4,16
    80003d5e:	86a6                	mv	a3,s1
    80003d60:	fc040613          	add	a2,s0,-64
    80003d64:	4581                	li	a1,0
    80003d66:	854a                	mv	a0,s2
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	d70080e7          	jalr	-656(ra) # 80003ad8 <readi>
    80003d70:	47c1                	li	a5,16
    80003d72:	fcf518e3          	bne	a0,a5,80003d42 <dirlookup+0x3a>
    if(de.inum == 0)
    80003d76:	fc045783          	lhu	a5,-64(s0)
    80003d7a:	dfe1                	beqz	a5,80003d52 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d7c:	fc240593          	add	a1,s0,-62
    80003d80:	854e                	mv	a0,s3
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	f6c080e7          	jalr	-148(ra) # 80003cee <namecmp>
    80003d8a:	f561                	bnez	a0,80003d52 <dirlookup+0x4a>
      if(poff)
    80003d8c:	000a0463          	beqz	s4,80003d94 <dirlookup+0x8c>
        *poff = off;
    80003d90:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d94:	fc045583          	lhu	a1,-64(s0)
    80003d98:	00092503          	lw	a0,0(s2)
    80003d9c:	fffff097          	auipc	ra,0xfffff
    80003da0:	754080e7          	jalr	1876(ra) # 800034f0 <iget>
    80003da4:	a011                	j	80003da8 <dirlookup+0xa0>
  return 0;
    80003da6:	4501                	li	a0,0
}
    80003da8:	70e2                	ld	ra,56(sp)
    80003daa:	7442                	ld	s0,48(sp)
    80003dac:	74a2                	ld	s1,40(sp)
    80003dae:	7902                	ld	s2,32(sp)
    80003db0:	69e2                	ld	s3,24(sp)
    80003db2:	6a42                	ld	s4,16(sp)
    80003db4:	6121                	add	sp,sp,64
    80003db6:	8082                	ret

0000000080003db8 <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003db8:	711d                	add	sp,sp,-96
    80003dba:	ec86                	sd	ra,88(sp)
    80003dbc:	e8a2                	sd	s0,80(sp)
    80003dbe:	e4a6                	sd	s1,72(sp)
    80003dc0:	e0ca                	sd	s2,64(sp)
    80003dc2:	fc4e                	sd	s3,56(sp)
    80003dc4:	f852                	sd	s4,48(sp)
    80003dc6:	f456                	sd	s5,40(sp)
    80003dc8:	f05a                	sd	s6,32(sp)
    80003dca:	ec5e                	sd	s7,24(sp)
    80003dcc:	e862                	sd	s8,16(sp)
    80003dce:	e466                	sd	s9,8(sp)
    80003dd0:	1080                	add	s0,sp,96
    80003dd2:	84aa                	mv	s1,a0
    80003dd4:	8b2e                	mv	s6,a1
    80003dd6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003dd8:	00054703          	lbu	a4,0(a0)
    80003ddc:	02f00793          	li	a5,47
    80003de0:	02f70263          	beq	a4,a5,80003e04 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003de4:	ffffe097          	auipc	ra,0xffffe
    80003de8:	d26080e7          	jalr	-730(ra) # 80001b0a <myproc>
    80003dec:	16053503          	ld	a0,352(a0)
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	9f6080e7          	jalr	-1546(ra) # 800037e6 <idup>
    80003df8:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003dfa:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003dfe:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003e00:	4b85                	li	s7,1
    80003e02:	a875                	j	80003ebe <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003e04:	4585                	li	a1,1
    80003e06:	4505                	li	a0,1
    80003e08:	fffff097          	auipc	ra,0xfffff
    80003e0c:	6e8080e7          	jalr	1768(ra) # 800034f0 <iget>
    80003e10:	8a2a                	mv	s4,a0
    80003e12:	b7e5                	j	80003dfa <namex+0x42>
      iunlockput(ip);
    80003e14:	8552                	mv	a0,s4
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	c70080e7          	jalr	-912(ra) # 80003a86 <iunlockput>
      return 0;
    80003e1e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003e20:	8552                	mv	a0,s4
    80003e22:	60e6                	ld	ra,88(sp)
    80003e24:	6446                	ld	s0,80(sp)
    80003e26:	64a6                	ld	s1,72(sp)
    80003e28:	6906                	ld	s2,64(sp)
    80003e2a:	79e2                	ld	s3,56(sp)
    80003e2c:	7a42                	ld	s4,48(sp)
    80003e2e:	7aa2                	ld	s5,40(sp)
    80003e30:	7b02                	ld	s6,32(sp)
    80003e32:	6be2                	ld	s7,24(sp)
    80003e34:	6c42                	ld	s8,16(sp)
    80003e36:	6ca2                	ld	s9,8(sp)
    80003e38:	6125                	add	sp,sp,96
    80003e3a:	8082                	ret
      iunlock(ip);
    80003e3c:	8552                	mv	a0,s4
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	aa8080e7          	jalr	-1368(ra) # 800038e6 <iunlock>
      return ip;
    80003e46:	bfe9                	j	80003e20 <namex+0x68>
      iunlockput(ip);
    80003e48:	8552                	mv	a0,s4
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	c3c080e7          	jalr	-964(ra) # 80003a86 <iunlockput>
      return 0;
    80003e52:	8a4e                	mv	s4,s3
    80003e54:	b7f1                	j	80003e20 <namex+0x68>
  len = path - s;
    80003e56:	40998633          	sub	a2,s3,s1
    80003e5a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003e5e:	099c5863          	bge	s8,s9,80003eee <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003e62:	4639                	li	a2,14
    80003e64:	85a6                	mv	a1,s1
    80003e66:	8556                	mv	a0,s5
    80003e68:	ffffd097          	auipc	ra,0xffffd
    80003e6c:	fbc080e7          	jalr	-68(ra) # 80000e24 <memmove>
    80003e70:	84ce                	mv	s1,s3
  while(*path == '/')
    80003e72:	0004c783          	lbu	a5,0(s1)
    80003e76:	01279763          	bne	a5,s2,80003e84 <namex+0xcc>
    path++;
    80003e7a:	0485                	add	s1,s1,1
  while(*path == '/')
    80003e7c:	0004c783          	lbu	a5,0(s1)
    80003e80:	ff278de3          	beq	a5,s2,80003e7a <namex+0xc2>
    ilock(ip);
    80003e84:	8552                	mv	a0,s4
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	99e080e7          	jalr	-1634(ra) # 80003824 <ilock>
    if(ip->type != T_DIR){
    80003e8e:	044a1783          	lh	a5,68(s4)
    80003e92:	f97791e3          	bne	a5,s7,80003e14 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003e96:	000b0563          	beqz	s6,80003ea0 <namex+0xe8>
    80003e9a:	0004c783          	lbu	a5,0(s1)
    80003e9e:	dfd9                	beqz	a5,80003e3c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ea0:	4601                	li	a2,0
    80003ea2:	85d6                	mv	a1,s5
    80003ea4:	8552                	mv	a0,s4
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	e62080e7          	jalr	-414(ra) # 80003d08 <dirlookup>
    80003eae:	89aa                	mv	s3,a0
    80003eb0:	dd41                	beqz	a0,80003e48 <namex+0x90>
    iunlockput(ip);
    80003eb2:	8552                	mv	a0,s4
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	bd2080e7          	jalr	-1070(ra) # 80003a86 <iunlockput>
    ip = next;
    80003ebc:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003ebe:	0004c783          	lbu	a5,0(s1)
    80003ec2:	01279763          	bne	a5,s2,80003ed0 <namex+0x118>
    path++;
    80003ec6:	0485                	add	s1,s1,1
  while(*path == '/')
    80003ec8:	0004c783          	lbu	a5,0(s1)
    80003ecc:	ff278de3          	beq	a5,s2,80003ec6 <namex+0x10e>
  if(*path == 0)
    80003ed0:	cb9d                	beqz	a5,80003f06 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003ed2:	0004c783          	lbu	a5,0(s1)
    80003ed6:	89a6                	mv	s3,s1
  len = path - s;
    80003ed8:	4c81                	li	s9,0
    80003eda:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003edc:	01278963          	beq	a5,s2,80003eee <namex+0x136>
    80003ee0:	dbbd                	beqz	a5,80003e56 <namex+0x9e>
    path++;
    80003ee2:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003ee4:	0009c783          	lbu	a5,0(s3)
    80003ee8:	ff279ce3          	bne	a5,s2,80003ee0 <namex+0x128>
    80003eec:	b7ad                	j	80003e56 <namex+0x9e>
    memmove(name, s, len);
    80003eee:	2601                	sext.w	a2,a2
    80003ef0:	85a6                	mv	a1,s1
    80003ef2:	8556                	mv	a0,s5
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	f30080e7          	jalr	-208(ra) # 80000e24 <memmove>
    name[len] = 0;
    80003efc:	9cd6                	add	s9,s9,s5
    80003efe:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003f02:	84ce                	mv	s1,s3
    80003f04:	b7bd                	j	80003e72 <namex+0xba>
  if(nameiparent){
    80003f06:	f00b0de3          	beqz	s6,80003e20 <namex+0x68>
    iput(ip);
    80003f0a:	8552                	mv	a0,s4
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	ad2080e7          	jalr	-1326(ra) # 800039de <iput>
    return 0;
    80003f14:	4a01                	li	s4,0
    80003f16:	b729                	j	80003e20 <namex+0x68>

0000000080003f18 <dirlink>:
{
    80003f18:	7139                	add	sp,sp,-64
    80003f1a:	fc06                	sd	ra,56(sp)
    80003f1c:	f822                	sd	s0,48(sp)
    80003f1e:	f426                	sd	s1,40(sp)
    80003f20:	f04a                	sd	s2,32(sp)
    80003f22:	ec4e                	sd	s3,24(sp)
    80003f24:	e852                	sd	s4,16(sp)
    80003f26:	0080                	add	s0,sp,64
    80003f28:	892a                	mv	s2,a0
    80003f2a:	8a2e                	mv	s4,a1
    80003f2c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f2e:	4601                	li	a2,0
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	dd8080e7          	jalr	-552(ra) # 80003d08 <dirlookup>
    80003f38:	e93d                	bnez	a0,80003fae <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f3a:	04c92483          	lw	s1,76(s2)
    80003f3e:	c49d                	beqz	s1,80003f6c <dirlink+0x54>
    80003f40:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f42:	4741                	li	a4,16
    80003f44:	86a6                	mv	a3,s1
    80003f46:	fc040613          	add	a2,s0,-64
    80003f4a:	4581                	li	a1,0
    80003f4c:	854a                	mv	a0,s2
    80003f4e:	00000097          	auipc	ra,0x0
    80003f52:	b8a080e7          	jalr	-1142(ra) # 80003ad8 <readi>
    80003f56:	47c1                	li	a5,16
    80003f58:	06f51163          	bne	a0,a5,80003fba <dirlink+0xa2>
    if(de.inum == 0)
    80003f5c:	fc045783          	lhu	a5,-64(s0)
    80003f60:	c791                	beqz	a5,80003f6c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f62:	24c1                	addw	s1,s1,16
    80003f64:	04c92783          	lw	a5,76(s2)
    80003f68:	fcf4ede3          	bltu	s1,a5,80003f42 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003f6c:	4639                	li	a2,14
    80003f6e:	85d2                	mv	a1,s4
    80003f70:	fc240513          	add	a0,s0,-62
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	f60080e7          	jalr	-160(ra) # 80000ed4 <strncpy>
  de.inum = inum;
    80003f7c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f80:	4741                	li	a4,16
    80003f82:	86a6                	mv	a3,s1
    80003f84:	fc040613          	add	a2,s0,-64
    80003f88:	4581                	li	a1,0
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	c44080e7          	jalr	-956(ra) # 80003bd0 <writei>
    80003f94:	1541                	add	a0,a0,-16
    80003f96:	00a03533          	snez	a0,a0
    80003f9a:	40a00533          	neg	a0,a0
}
    80003f9e:	70e2                	ld	ra,56(sp)
    80003fa0:	7442                	ld	s0,48(sp)
    80003fa2:	74a2                	ld	s1,40(sp)
    80003fa4:	7902                	ld	s2,32(sp)
    80003fa6:	69e2                	ld	s3,24(sp)
    80003fa8:	6a42                	ld	s4,16(sp)
    80003faa:	6121                	add	sp,sp,64
    80003fac:	8082                	ret
    iput(ip);
    80003fae:	00000097          	auipc	ra,0x0
    80003fb2:	a30080e7          	jalr	-1488(ra) # 800039de <iput>
    return -1;
    80003fb6:	557d                	li	a0,-1
    80003fb8:	b7dd                	j	80003f9e <dirlink+0x86>
      panic("dirlink read");
    80003fba:	00004517          	auipc	a0,0x4
    80003fbe:	69e50513          	add	a0,a0,1694 # 80008658 <syscalls+0x1c8>
    80003fc2:	ffffd097          	auipc	ra,0xffffd
    80003fc6:	84c080e7          	jalr	-1972(ra) # 8000080e <panic>

0000000080003fca <namei>:

struct inode*
namei(char *path)
{
    80003fca:	1101                	add	sp,sp,-32
    80003fcc:	ec06                	sd	ra,24(sp)
    80003fce:	e822                	sd	s0,16(sp)
    80003fd0:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003fd2:	fe040613          	add	a2,s0,-32
    80003fd6:	4581                	li	a1,0
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	de0080e7          	jalr	-544(ra) # 80003db8 <namex>
}
    80003fe0:	60e2                	ld	ra,24(sp)
    80003fe2:	6442                	ld	s0,16(sp)
    80003fe4:	6105                	add	sp,sp,32
    80003fe6:	8082                	ret

0000000080003fe8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003fe8:	1141                	add	sp,sp,-16
    80003fea:	e406                	sd	ra,8(sp)
    80003fec:	e022                	sd	s0,0(sp)
    80003fee:	0800                	add	s0,sp,16
    80003ff0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ff2:	4585                	li	a1,1
    80003ff4:	00000097          	auipc	ra,0x0
    80003ff8:	dc4080e7          	jalr	-572(ra) # 80003db8 <namex>
}
    80003ffc:	60a2                	ld	ra,8(sp)
    80003ffe:	6402                	ld	s0,0(sp)
    80004000:	0141                	add	sp,sp,16
    80004002:	8082                	ret

0000000080004004 <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    80004004:	1101                	add	sp,sp,-32
    80004006:	ec06                	sd	ra,24(sp)
    80004008:	e822                	sd	s0,16(sp)
    8000400a:	e426                	sd	s1,8(sp)
    8000400c:	e04a                	sd	s2,0(sp)
    8000400e:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004010:	0001e917          	auipc	s2,0x1e
    80004014:	87090913          	add	s2,s2,-1936 # 80021880 <log>
    80004018:	01892583          	lw	a1,24(s2)
    8000401c:	02892503          	lw	a0,40(s2)
    80004020:	fffff097          	auipc	ra,0xfffff
    80004024:	ff4080e7          	jalr	-12(ra) # 80003014 <bread>
    80004028:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000402a:	02c92603          	lw	a2,44(s2)
    8000402e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004030:	00c05f63          	blez	a2,8000404e <write_head+0x4a>
    80004034:	0001e717          	auipc	a4,0x1e
    80004038:	87c70713          	add	a4,a4,-1924 # 800218b0 <log+0x30>
    8000403c:	87aa                	mv	a5,a0
    8000403e:	060a                	sll	a2,a2,0x2
    80004040:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004042:	4314                	lw	a3,0(a4)
    80004044:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004046:	0711                	add	a4,a4,4
    80004048:	0791                	add	a5,a5,4
    8000404a:	fec79ce3          	bne	a5,a2,80004042 <write_head+0x3e>
  }
  bwrite(buf);
    8000404e:	8526                	mv	a0,s1
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	0b6080e7          	jalr	182(ra) # 80003106 <bwrite>
  brelse(buf);
    80004058:	8526                	mv	a0,s1
    8000405a:	fffff097          	auipc	ra,0xfffff
    8000405e:	0ea080e7          	jalr	234(ra) # 80003144 <brelse>
}
    80004062:	60e2                	ld	ra,24(sp)
    80004064:	6442                	ld	s0,16(sp)
    80004066:	64a2                	ld	s1,8(sp)
    80004068:	6902                	ld	s2,0(sp)
    8000406a:	6105                	add	sp,sp,32
    8000406c:	8082                	ret

000000008000406e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000406e:	0001e797          	auipc	a5,0x1e
    80004072:	83e7a783          	lw	a5,-1986(a5) # 800218ac <log+0x2c>
    80004076:	0af05d63          	blez	a5,80004130 <install_trans+0xc2>
{
    8000407a:	7139                	add	sp,sp,-64
    8000407c:	fc06                	sd	ra,56(sp)
    8000407e:	f822                	sd	s0,48(sp)
    80004080:	f426                	sd	s1,40(sp)
    80004082:	f04a                	sd	s2,32(sp)
    80004084:	ec4e                	sd	s3,24(sp)
    80004086:	e852                	sd	s4,16(sp)
    80004088:	e456                	sd	s5,8(sp)
    8000408a:	e05a                	sd	s6,0(sp)
    8000408c:	0080                	add	s0,sp,64
    8000408e:	8b2a                	mv	s6,a0
    80004090:	0001ea97          	auipc	s5,0x1e
    80004094:	820a8a93          	add	s5,s5,-2016 # 800218b0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004098:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    8000409a:	0001d997          	auipc	s3,0x1d
    8000409e:	7e698993          	add	s3,s3,2022 # 80021880 <log>
    800040a2:	a00d                	j	800040c4 <install_trans+0x56>
    brelse(lbuf);
    800040a4:	854a                	mv	a0,s2
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	09e080e7          	jalr	158(ra) # 80003144 <brelse>
    brelse(dbuf);
    800040ae:	8526                	mv	a0,s1
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	094080e7          	jalr	148(ra) # 80003144 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040b8:	2a05                	addw	s4,s4,1
    800040ba:	0a91                	add	s5,s5,4
    800040bc:	02c9a783          	lw	a5,44(s3)
    800040c0:	04fa5e63          	bge	s4,a5,8000411c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    800040c4:	0189a583          	lw	a1,24(s3)
    800040c8:	014585bb          	addw	a1,a1,s4
    800040cc:	2585                	addw	a1,a1,1
    800040ce:	0289a503          	lw	a0,40(s3)
    800040d2:	fffff097          	auipc	ra,0xfffff
    800040d6:	f42080e7          	jalr	-190(ra) # 80003014 <bread>
    800040da:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    800040dc:	000aa583          	lw	a1,0(s5)
    800040e0:	0289a503          	lw	a0,40(s3)
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	f30080e7          	jalr	-208(ra) # 80003014 <bread>
    800040ec:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    800040ee:	40000613          	li	a2,1024
    800040f2:	05890593          	add	a1,s2,88
    800040f6:	05850513          	add	a0,a0,88
    800040fa:	ffffd097          	auipc	ra,0xffffd
    800040fe:	d2a080e7          	jalr	-726(ra) # 80000e24 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    80004102:	8526                	mv	a0,s1
    80004104:	fffff097          	auipc	ra,0xfffff
    80004108:	002080e7          	jalr	2(ra) # 80003106 <bwrite>
    if(recovering == 0)
    8000410c:	f80b1ce3          	bnez	s6,800040a4 <install_trans+0x36>
      bunpin(dbuf);
    80004110:	8526                	mv	a0,s1
    80004112:	fffff097          	auipc	ra,0xfffff
    80004116:	10a080e7          	jalr	266(ra) # 8000321c <bunpin>
    8000411a:	b769                	j	800040a4 <install_trans+0x36>
}
    8000411c:	70e2                	ld	ra,56(sp)
    8000411e:	7442                	ld	s0,48(sp)
    80004120:	74a2                	ld	s1,40(sp)
    80004122:	7902                	ld	s2,32(sp)
    80004124:	69e2                	ld	s3,24(sp)
    80004126:	6a42                	ld	s4,16(sp)
    80004128:	6aa2                	ld	s5,8(sp)
    8000412a:	6b02                	ld	s6,0(sp)
    8000412c:	6121                	add	sp,sp,64
    8000412e:	8082                	ret
    80004130:	8082                	ret

0000000080004132 <initlog>:
{
    80004132:	7179                	add	sp,sp,-48
    80004134:	f406                	sd	ra,40(sp)
    80004136:	f022                	sd	s0,32(sp)
    80004138:	ec26                	sd	s1,24(sp)
    8000413a:	e84a                	sd	s2,16(sp)
    8000413c:	e44e                	sd	s3,8(sp)
    8000413e:	1800                	add	s0,sp,48
    80004140:	892a                	mv	s2,a0
    80004142:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004144:	0001d497          	auipc	s1,0x1d
    80004148:	73c48493          	add	s1,s1,1852 # 80021880 <log>
    8000414c:	00004597          	auipc	a1,0x4
    80004150:	51c58593          	add	a1,a1,1308 # 80008668 <syscalls+0x1d8>
    80004154:	8526                	mv	a0,s1
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	ae6080e7          	jalr	-1306(ra) # 80000c3c <initlock>
  log.start = sb->logstart;
    8000415e:	0149a583          	lw	a1,20(s3)
    80004162:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004164:	0109a783          	lw	a5,16(s3)
    80004168:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000416a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000416e:	854a                	mv	a0,s2
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	ea4080e7          	jalr	-348(ra) # 80003014 <bread>
  log.lh.n = lh->n;
    80004178:	4d30                	lw	a2,88(a0)
    8000417a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000417c:	00c05f63          	blez	a2,8000419a <initlog+0x68>
    80004180:	87aa                	mv	a5,a0
    80004182:	0001d717          	auipc	a4,0x1d
    80004186:	72e70713          	add	a4,a4,1838 # 800218b0 <log+0x30>
    8000418a:	060a                	sll	a2,a2,0x2
    8000418c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000418e:	4ff4                	lw	a3,92(a5)
    80004190:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004192:	0791                	add	a5,a5,4
    80004194:	0711                	add	a4,a4,4
    80004196:	fec79ce3          	bne	a5,a2,8000418e <initlog+0x5c>
  brelse(buf);
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	faa080e7          	jalr	-86(ra) # 80003144 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    800041a2:	4505                	li	a0,1
    800041a4:	00000097          	auipc	ra,0x0
    800041a8:	eca080e7          	jalr	-310(ra) # 8000406e <install_trans>
  log.lh.n = 0;
    800041ac:	0001d797          	auipc	a5,0x1d
    800041b0:	7007a023          	sw	zero,1792(a5) # 800218ac <log+0x2c>
  write_head(); /* clear the log */
    800041b4:	00000097          	auipc	ra,0x0
    800041b8:	e50080e7          	jalr	-432(ra) # 80004004 <write_head>
}
    800041bc:	70a2                	ld	ra,40(sp)
    800041be:	7402                	ld	s0,32(sp)
    800041c0:	64e2                	ld	s1,24(sp)
    800041c2:	6942                	ld	s2,16(sp)
    800041c4:	69a2                	ld	s3,8(sp)
    800041c6:	6145                	add	sp,sp,48
    800041c8:	8082                	ret

00000000800041ca <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    800041ca:	1101                	add	sp,sp,-32
    800041cc:	ec06                	sd	ra,24(sp)
    800041ce:	e822                	sd	s0,16(sp)
    800041d0:	e426                	sd	s1,8(sp)
    800041d2:	e04a                	sd	s2,0(sp)
    800041d4:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800041d6:	0001d517          	auipc	a0,0x1d
    800041da:	6aa50513          	add	a0,a0,1706 # 80021880 <log>
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	aee080e7          	jalr	-1298(ra) # 80000ccc <acquire>
  while(1){
    if(log.committing){
    800041e6:	0001d497          	auipc	s1,0x1d
    800041ea:	69a48493          	add	s1,s1,1690 # 80021880 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041ee:	4979                	li	s2,30
    800041f0:	a039                	j	800041fe <begin_op+0x34>
      sleep(&log, &log.lock);
    800041f2:	85a6                	mv	a1,s1
    800041f4:	8526                	mv	a0,s1
    800041f6:	ffffe097          	auipc	ra,0xffffe
    800041fa:	06c080e7          	jalr	108(ra) # 80002262 <sleep>
    if(log.committing){
    800041fe:	50dc                	lw	a5,36(s1)
    80004200:	fbed                	bnez	a5,800041f2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004202:	5098                	lw	a4,32(s1)
    80004204:	2705                	addw	a4,a4,1
    80004206:	0027179b          	sllw	a5,a4,0x2
    8000420a:	9fb9                	addw	a5,a5,a4
    8000420c:	0017979b          	sllw	a5,a5,0x1
    80004210:	54d4                	lw	a3,44(s1)
    80004212:	9fb5                	addw	a5,a5,a3
    80004214:	00f95963          	bge	s2,a5,80004226 <begin_op+0x5c>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    80004218:	85a6                	mv	a1,s1
    8000421a:	8526                	mv	a0,s1
    8000421c:	ffffe097          	auipc	ra,0xffffe
    80004220:	046080e7          	jalr	70(ra) # 80002262 <sleep>
    80004224:	bfe9                	j	800041fe <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004226:	0001d517          	auipc	a0,0x1d
    8000422a:	65a50513          	add	a0,a0,1626 # 80021880 <log>
    8000422e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	b50080e7          	jalr	-1200(ra) # 80000d80 <release>
      break;
    }
  }
}
    80004238:	60e2                	ld	ra,24(sp)
    8000423a:	6442                	ld	s0,16(sp)
    8000423c:	64a2                	ld	s1,8(sp)
    8000423e:	6902                	ld	s2,0(sp)
    80004240:	6105                	add	sp,sp,32
    80004242:	8082                	ret

0000000080004244 <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    80004244:	7139                	add	sp,sp,-64
    80004246:	fc06                	sd	ra,56(sp)
    80004248:	f822                	sd	s0,48(sp)
    8000424a:	f426                	sd	s1,40(sp)
    8000424c:	f04a                	sd	s2,32(sp)
    8000424e:	ec4e                	sd	s3,24(sp)
    80004250:	e852                	sd	s4,16(sp)
    80004252:	e456                	sd	s5,8(sp)
    80004254:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004256:	0001d497          	auipc	s1,0x1d
    8000425a:	62a48493          	add	s1,s1,1578 # 80021880 <log>
    8000425e:	8526                	mv	a0,s1
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	a6c080e7          	jalr	-1428(ra) # 80000ccc <acquire>
  log.outstanding -= 1;
    80004268:	509c                	lw	a5,32(s1)
    8000426a:	37fd                	addw	a5,a5,-1
    8000426c:	0007891b          	sext.w	s2,a5
    80004270:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004272:	50dc                	lw	a5,36(s1)
    80004274:	e7b9                	bnez	a5,800042c2 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004276:	04091e63          	bnez	s2,800042d2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000427a:	0001d497          	auipc	s1,0x1d
    8000427e:	60648493          	add	s1,s1,1542 # 80021880 <log>
    80004282:	4785                	li	a5,1
    80004284:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    80004286:	8526                	mv	a0,s1
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	af8080e7          	jalr	-1288(ra) # 80000d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004290:	54dc                	lw	a5,44(s1)
    80004292:	06f04763          	bgtz	a5,80004300 <end_op+0xbc>
    acquire(&log.lock);
    80004296:	0001d497          	auipc	s1,0x1d
    8000429a:	5ea48493          	add	s1,s1,1514 # 80021880 <log>
    8000429e:	8526                	mv	a0,s1
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	a2c080e7          	jalr	-1492(ra) # 80000ccc <acquire>
    log.committing = 0;
    800042a8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800042ac:	8526                	mv	a0,s1
    800042ae:	ffffe097          	auipc	ra,0xffffe
    800042b2:	018080e7          	jalr	24(ra) # 800022c6 <wakeup>
    release(&log.lock);
    800042b6:	8526                	mv	a0,s1
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	ac8080e7          	jalr	-1336(ra) # 80000d80 <release>
}
    800042c0:	a03d                	j	800042ee <end_op+0xaa>
    panic("log.committing");
    800042c2:	00004517          	auipc	a0,0x4
    800042c6:	3ae50513          	add	a0,a0,942 # 80008670 <syscalls+0x1e0>
    800042ca:	ffffc097          	auipc	ra,0xffffc
    800042ce:	544080e7          	jalr	1348(ra) # 8000080e <panic>
    wakeup(&log);
    800042d2:	0001d497          	auipc	s1,0x1d
    800042d6:	5ae48493          	add	s1,s1,1454 # 80021880 <log>
    800042da:	8526                	mv	a0,s1
    800042dc:	ffffe097          	auipc	ra,0xffffe
    800042e0:	fea080e7          	jalr	-22(ra) # 800022c6 <wakeup>
  release(&log.lock);
    800042e4:	8526                	mv	a0,s1
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	a9a080e7          	jalr	-1382(ra) # 80000d80 <release>
}
    800042ee:	70e2                	ld	ra,56(sp)
    800042f0:	7442                	ld	s0,48(sp)
    800042f2:	74a2                	ld	s1,40(sp)
    800042f4:	7902                	ld	s2,32(sp)
    800042f6:	69e2                	ld	s3,24(sp)
    800042f8:	6a42                	ld	s4,16(sp)
    800042fa:	6aa2                	ld	s5,8(sp)
    800042fc:	6121                	add	sp,sp,64
    800042fe:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004300:	0001da97          	auipc	s5,0x1d
    80004304:	5b0a8a93          	add	s5,s5,1456 # 800218b0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    80004308:	0001da17          	auipc	s4,0x1d
    8000430c:	578a0a13          	add	s4,s4,1400 # 80021880 <log>
    80004310:	018a2583          	lw	a1,24(s4)
    80004314:	012585bb          	addw	a1,a1,s2
    80004318:	2585                	addw	a1,a1,1
    8000431a:	028a2503          	lw	a0,40(s4)
    8000431e:	fffff097          	auipc	ra,0xfffff
    80004322:	cf6080e7          	jalr	-778(ra) # 80003014 <bread>
    80004326:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    80004328:	000aa583          	lw	a1,0(s5)
    8000432c:	028a2503          	lw	a0,40(s4)
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	ce4080e7          	jalr	-796(ra) # 80003014 <bread>
    80004338:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000433a:	40000613          	li	a2,1024
    8000433e:	05850593          	add	a1,a0,88
    80004342:	05848513          	add	a0,s1,88
    80004346:	ffffd097          	auipc	ra,0xffffd
    8000434a:	ade080e7          	jalr	-1314(ra) # 80000e24 <memmove>
    bwrite(to);  /* write the log */
    8000434e:	8526                	mv	a0,s1
    80004350:	fffff097          	auipc	ra,0xfffff
    80004354:	db6080e7          	jalr	-586(ra) # 80003106 <bwrite>
    brelse(from);
    80004358:	854e                	mv	a0,s3
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	dea080e7          	jalr	-534(ra) # 80003144 <brelse>
    brelse(to);
    80004362:	8526                	mv	a0,s1
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	de0080e7          	jalr	-544(ra) # 80003144 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000436c:	2905                	addw	s2,s2,1
    8000436e:	0a91                	add	s5,s5,4
    80004370:	02ca2783          	lw	a5,44(s4)
    80004374:	f8f94ee3          	blt	s2,a5,80004310 <end_op+0xcc>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    80004378:	00000097          	auipc	ra,0x0
    8000437c:	c8c080e7          	jalr	-884(ra) # 80004004 <write_head>
    install_trans(0); /* Now install writes to home locations */
    80004380:	4501                	li	a0,0
    80004382:	00000097          	auipc	ra,0x0
    80004386:	cec080e7          	jalr	-788(ra) # 8000406e <install_trans>
    log.lh.n = 0;
    8000438a:	0001d797          	auipc	a5,0x1d
    8000438e:	5207a123          	sw	zero,1314(a5) # 800218ac <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    80004392:	00000097          	auipc	ra,0x0
    80004396:	c72080e7          	jalr	-910(ra) # 80004004 <write_head>
    8000439a:	bdf5                	j	80004296 <end_op+0x52>

000000008000439c <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    8000439c:	1101                	add	sp,sp,-32
    8000439e:	ec06                	sd	ra,24(sp)
    800043a0:	e822                	sd	s0,16(sp)
    800043a2:	e426                	sd	s1,8(sp)
    800043a4:	e04a                	sd	s2,0(sp)
    800043a6:	1000                	add	s0,sp,32
    800043a8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800043aa:	0001d917          	auipc	s2,0x1d
    800043ae:	4d690913          	add	s2,s2,1238 # 80021880 <log>
    800043b2:	854a                	mv	a0,s2
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	918080e7          	jalr	-1768(ra) # 80000ccc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800043bc:	02c92603          	lw	a2,44(s2)
    800043c0:	47f5                	li	a5,29
    800043c2:	06c7c563          	blt	a5,a2,8000442c <log_write+0x90>
    800043c6:	0001d797          	auipc	a5,0x1d
    800043ca:	4d67a783          	lw	a5,1238(a5) # 8002189c <log+0x1c>
    800043ce:	37fd                	addw	a5,a5,-1
    800043d0:	04f65e63          	bge	a2,a5,8000442c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800043d4:	0001d797          	auipc	a5,0x1d
    800043d8:	4cc7a783          	lw	a5,1228(a5) # 800218a0 <log+0x20>
    800043dc:	06f05063          	blez	a5,8000443c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800043e0:	4781                	li	a5,0
    800043e2:	06c05563          	blez	a2,8000444c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    800043e6:	44cc                	lw	a1,12(s1)
    800043e8:	0001d717          	auipc	a4,0x1d
    800043ec:	4c870713          	add	a4,a4,1224 # 800218b0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800043f0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    800043f2:	4314                	lw	a3,0(a4)
    800043f4:	04b68c63          	beq	a3,a1,8000444c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800043f8:	2785                	addw	a5,a5,1
    800043fa:	0711                	add	a4,a4,4
    800043fc:	fef61be3          	bne	a2,a5,800043f2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004400:	0621                	add	a2,a2,8
    80004402:	060a                	sll	a2,a2,0x2
    80004404:	0001d797          	auipc	a5,0x1d
    80004408:	47c78793          	add	a5,a5,1148 # 80021880 <log>
    8000440c:	97b2                	add	a5,a5,a2
    8000440e:	44d8                	lw	a4,12(s1)
    80004410:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    80004412:	8526                	mv	a0,s1
    80004414:	fffff097          	auipc	ra,0xfffff
    80004418:	dcc080e7          	jalr	-564(ra) # 800031e0 <bpin>
    log.lh.n++;
    8000441c:	0001d717          	auipc	a4,0x1d
    80004420:	46470713          	add	a4,a4,1124 # 80021880 <log>
    80004424:	575c                	lw	a5,44(a4)
    80004426:	2785                	addw	a5,a5,1
    80004428:	d75c                	sw	a5,44(a4)
    8000442a:	a82d                	j	80004464 <log_write+0xc8>
    panic("too big a transaction");
    8000442c:	00004517          	auipc	a0,0x4
    80004430:	25450513          	add	a0,a0,596 # 80008680 <syscalls+0x1f0>
    80004434:	ffffc097          	auipc	ra,0xffffc
    80004438:	3da080e7          	jalr	986(ra) # 8000080e <panic>
    panic("log_write outside of trans");
    8000443c:	00004517          	auipc	a0,0x4
    80004440:	25c50513          	add	a0,a0,604 # 80008698 <syscalls+0x208>
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	3ca080e7          	jalr	970(ra) # 8000080e <panic>
  log.lh.block[i] = b->blockno;
    8000444c:	00878693          	add	a3,a5,8
    80004450:	068a                	sll	a3,a3,0x2
    80004452:	0001d717          	auipc	a4,0x1d
    80004456:	42e70713          	add	a4,a4,1070 # 80021880 <log>
    8000445a:	9736                	add	a4,a4,a3
    8000445c:	44d4                	lw	a3,12(s1)
    8000445e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    80004460:	faf609e3          	beq	a2,a5,80004412 <log_write+0x76>
  }
  release(&log.lock);
    80004464:	0001d517          	auipc	a0,0x1d
    80004468:	41c50513          	add	a0,a0,1052 # 80021880 <log>
    8000446c:	ffffd097          	auipc	ra,0xffffd
    80004470:	914080e7          	jalr	-1772(ra) # 80000d80 <release>
}
    80004474:	60e2                	ld	ra,24(sp)
    80004476:	6442                	ld	s0,16(sp)
    80004478:	64a2                	ld	s1,8(sp)
    8000447a:	6902                	ld	s2,0(sp)
    8000447c:	6105                	add	sp,sp,32
    8000447e:	8082                	ret

0000000080004480 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004480:	1101                	add	sp,sp,-32
    80004482:	ec06                	sd	ra,24(sp)
    80004484:	e822                	sd	s0,16(sp)
    80004486:	e426                	sd	s1,8(sp)
    80004488:	e04a                	sd	s2,0(sp)
    8000448a:	1000                	add	s0,sp,32
    8000448c:	84aa                	mv	s1,a0
    8000448e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004490:	00004597          	auipc	a1,0x4
    80004494:	22858593          	add	a1,a1,552 # 800086b8 <syscalls+0x228>
    80004498:	0521                	add	a0,a0,8
    8000449a:	ffffc097          	auipc	ra,0xffffc
    8000449e:	7a2080e7          	jalr	1954(ra) # 80000c3c <initlock>
  lk->name = name;
    800044a2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800044a6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044aa:	0204a423          	sw	zero,40(s1)
}
    800044ae:	60e2                	ld	ra,24(sp)
    800044b0:	6442                	ld	s0,16(sp)
    800044b2:	64a2                	ld	s1,8(sp)
    800044b4:	6902                	ld	s2,0(sp)
    800044b6:	6105                	add	sp,sp,32
    800044b8:	8082                	ret

00000000800044ba <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044ba:	1101                	add	sp,sp,-32
    800044bc:	ec06                	sd	ra,24(sp)
    800044be:	e822                	sd	s0,16(sp)
    800044c0:	e426                	sd	s1,8(sp)
    800044c2:	e04a                	sd	s2,0(sp)
    800044c4:	1000                	add	s0,sp,32
    800044c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044c8:	00850913          	add	s2,a0,8
    800044cc:	854a                	mv	a0,s2
    800044ce:	ffffc097          	auipc	ra,0xffffc
    800044d2:	7fe080e7          	jalr	2046(ra) # 80000ccc <acquire>
  while (lk->locked) {
    800044d6:	409c                	lw	a5,0(s1)
    800044d8:	cb89                	beqz	a5,800044ea <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044da:	85ca                	mv	a1,s2
    800044dc:	8526                	mv	a0,s1
    800044de:	ffffe097          	auipc	ra,0xffffe
    800044e2:	d84080e7          	jalr	-636(ra) # 80002262 <sleep>
  while (lk->locked) {
    800044e6:	409c                	lw	a5,0(s1)
    800044e8:	fbed                	bnez	a5,800044da <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044ea:	4785                	li	a5,1
    800044ec:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044ee:	ffffd097          	auipc	ra,0xffffd
    800044f2:	61c080e7          	jalr	1564(ra) # 80001b0a <myproc>
    800044f6:	591c                	lw	a5,48(a0)
    800044f8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800044fa:	854a                	mv	a0,s2
    800044fc:	ffffd097          	auipc	ra,0xffffd
    80004500:	884080e7          	jalr	-1916(ra) # 80000d80 <release>
}
    80004504:	60e2                	ld	ra,24(sp)
    80004506:	6442                	ld	s0,16(sp)
    80004508:	64a2                	ld	s1,8(sp)
    8000450a:	6902                	ld	s2,0(sp)
    8000450c:	6105                	add	sp,sp,32
    8000450e:	8082                	ret

0000000080004510 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004510:	1101                	add	sp,sp,-32
    80004512:	ec06                	sd	ra,24(sp)
    80004514:	e822                	sd	s0,16(sp)
    80004516:	e426                	sd	s1,8(sp)
    80004518:	e04a                	sd	s2,0(sp)
    8000451a:	1000                	add	s0,sp,32
    8000451c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000451e:	00850913          	add	s2,a0,8
    80004522:	854a                	mv	a0,s2
    80004524:	ffffc097          	auipc	ra,0xffffc
    80004528:	7a8080e7          	jalr	1960(ra) # 80000ccc <acquire>
  lk->locked = 0;
    8000452c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004530:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004534:	8526                	mv	a0,s1
    80004536:	ffffe097          	auipc	ra,0xffffe
    8000453a:	d90080e7          	jalr	-624(ra) # 800022c6 <wakeup>
  release(&lk->lk);
    8000453e:	854a                	mv	a0,s2
    80004540:	ffffd097          	auipc	ra,0xffffd
    80004544:	840080e7          	jalr	-1984(ra) # 80000d80 <release>
}
    80004548:	60e2                	ld	ra,24(sp)
    8000454a:	6442                	ld	s0,16(sp)
    8000454c:	64a2                	ld	s1,8(sp)
    8000454e:	6902                	ld	s2,0(sp)
    80004550:	6105                	add	sp,sp,32
    80004552:	8082                	ret

0000000080004554 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004554:	7179                	add	sp,sp,-48
    80004556:	f406                	sd	ra,40(sp)
    80004558:	f022                	sd	s0,32(sp)
    8000455a:	ec26                	sd	s1,24(sp)
    8000455c:	e84a                	sd	s2,16(sp)
    8000455e:	e44e                	sd	s3,8(sp)
    80004560:	1800                	add	s0,sp,48
    80004562:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004564:	00850913          	add	s2,a0,8
    80004568:	854a                	mv	a0,s2
    8000456a:	ffffc097          	auipc	ra,0xffffc
    8000456e:	762080e7          	jalr	1890(ra) # 80000ccc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004572:	409c                	lw	a5,0(s1)
    80004574:	ef99                	bnez	a5,80004592 <holdingsleep+0x3e>
    80004576:	4481                	li	s1,0
  release(&lk->lk);
    80004578:	854a                	mv	a0,s2
    8000457a:	ffffd097          	auipc	ra,0xffffd
    8000457e:	806080e7          	jalr	-2042(ra) # 80000d80 <release>
  return r;
}
    80004582:	8526                	mv	a0,s1
    80004584:	70a2                	ld	ra,40(sp)
    80004586:	7402                	ld	s0,32(sp)
    80004588:	64e2                	ld	s1,24(sp)
    8000458a:	6942                	ld	s2,16(sp)
    8000458c:	69a2                	ld	s3,8(sp)
    8000458e:	6145                	add	sp,sp,48
    80004590:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004592:	0284a983          	lw	s3,40(s1)
    80004596:	ffffd097          	auipc	ra,0xffffd
    8000459a:	574080e7          	jalr	1396(ra) # 80001b0a <myproc>
    8000459e:	5904                	lw	s1,48(a0)
    800045a0:	413484b3          	sub	s1,s1,s3
    800045a4:	0014b493          	seqz	s1,s1
    800045a8:	bfc1                	j	80004578 <holdingsleep+0x24>

00000000800045aa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800045aa:	1141                	add	sp,sp,-16
    800045ac:	e406                	sd	ra,8(sp)
    800045ae:	e022                	sd	s0,0(sp)
    800045b0:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800045b2:	00004597          	auipc	a1,0x4
    800045b6:	11658593          	add	a1,a1,278 # 800086c8 <syscalls+0x238>
    800045ba:	0001d517          	auipc	a0,0x1d
    800045be:	40e50513          	add	a0,a0,1038 # 800219c8 <ftable>
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	67a080e7          	jalr	1658(ra) # 80000c3c <initlock>
}
    800045ca:	60a2                	ld	ra,8(sp)
    800045cc:	6402                	ld	s0,0(sp)
    800045ce:	0141                	add	sp,sp,16
    800045d0:	8082                	ret

00000000800045d2 <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    800045d2:	1101                	add	sp,sp,-32
    800045d4:	ec06                	sd	ra,24(sp)
    800045d6:	e822                	sd	s0,16(sp)
    800045d8:	e426                	sd	s1,8(sp)
    800045da:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045dc:	0001d517          	auipc	a0,0x1d
    800045e0:	3ec50513          	add	a0,a0,1004 # 800219c8 <ftable>
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	6e8080e7          	jalr	1768(ra) # 80000ccc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045ec:	0001d497          	auipc	s1,0x1d
    800045f0:	3f448493          	add	s1,s1,1012 # 800219e0 <ftable+0x18>
    800045f4:	0001e717          	auipc	a4,0x1e
    800045f8:	38c70713          	add	a4,a4,908 # 80022980 <disk>
    if(f->ref == 0){
    800045fc:	40dc                	lw	a5,4(s1)
    800045fe:	cf99                	beqz	a5,8000461c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004600:	02848493          	add	s1,s1,40
    80004604:	fee49ce3          	bne	s1,a4,800045fc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004608:	0001d517          	auipc	a0,0x1d
    8000460c:	3c050513          	add	a0,a0,960 # 800219c8 <ftable>
    80004610:	ffffc097          	auipc	ra,0xffffc
    80004614:	770080e7          	jalr	1904(ra) # 80000d80 <release>
  return 0;
    80004618:	4481                	li	s1,0
    8000461a:	a819                	j	80004630 <filealloc+0x5e>
      f->ref = 1;
    8000461c:	4785                	li	a5,1
    8000461e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004620:	0001d517          	auipc	a0,0x1d
    80004624:	3a850513          	add	a0,a0,936 # 800219c8 <ftable>
    80004628:	ffffc097          	auipc	ra,0xffffc
    8000462c:	758080e7          	jalr	1880(ra) # 80000d80 <release>
}
    80004630:	8526                	mv	a0,s1
    80004632:	60e2                	ld	ra,24(sp)
    80004634:	6442                	ld	s0,16(sp)
    80004636:	64a2                	ld	s1,8(sp)
    80004638:	6105                	add	sp,sp,32
    8000463a:	8082                	ret

000000008000463c <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    8000463c:	1101                	add	sp,sp,-32
    8000463e:	ec06                	sd	ra,24(sp)
    80004640:	e822                	sd	s0,16(sp)
    80004642:	e426                	sd	s1,8(sp)
    80004644:	1000                	add	s0,sp,32
    80004646:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004648:	0001d517          	auipc	a0,0x1d
    8000464c:	38050513          	add	a0,a0,896 # 800219c8 <ftable>
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	67c080e7          	jalr	1660(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    80004658:	40dc                	lw	a5,4(s1)
    8000465a:	02f05263          	blez	a5,8000467e <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000465e:	2785                	addw	a5,a5,1
    80004660:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004662:	0001d517          	auipc	a0,0x1d
    80004666:	36650513          	add	a0,a0,870 # 800219c8 <ftable>
    8000466a:	ffffc097          	auipc	ra,0xffffc
    8000466e:	716080e7          	jalr	1814(ra) # 80000d80 <release>
  return f;
}
    80004672:	8526                	mv	a0,s1
    80004674:	60e2                	ld	ra,24(sp)
    80004676:	6442                	ld	s0,16(sp)
    80004678:	64a2                	ld	s1,8(sp)
    8000467a:	6105                	add	sp,sp,32
    8000467c:	8082                	ret
    panic("filedup");
    8000467e:	00004517          	auipc	a0,0x4
    80004682:	05250513          	add	a0,a0,82 # 800086d0 <syscalls+0x240>
    80004686:	ffffc097          	auipc	ra,0xffffc
    8000468a:	188080e7          	jalr	392(ra) # 8000080e <panic>

000000008000468e <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    8000468e:	7139                	add	sp,sp,-64
    80004690:	fc06                	sd	ra,56(sp)
    80004692:	f822                	sd	s0,48(sp)
    80004694:	f426                	sd	s1,40(sp)
    80004696:	f04a                	sd	s2,32(sp)
    80004698:	ec4e                	sd	s3,24(sp)
    8000469a:	e852                	sd	s4,16(sp)
    8000469c:	e456                	sd	s5,8(sp)
    8000469e:	0080                	add	s0,sp,64
    800046a0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800046a2:	0001d517          	auipc	a0,0x1d
    800046a6:	32650513          	add	a0,a0,806 # 800219c8 <ftable>
    800046aa:	ffffc097          	auipc	ra,0xffffc
    800046ae:	622080e7          	jalr	1570(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    800046b2:	40dc                	lw	a5,4(s1)
    800046b4:	06f05163          	blez	a5,80004716 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800046b8:	37fd                	addw	a5,a5,-1
    800046ba:	0007871b          	sext.w	a4,a5
    800046be:	c0dc                	sw	a5,4(s1)
    800046c0:	06e04363          	bgtz	a4,80004726 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800046c4:	0004a903          	lw	s2,0(s1)
    800046c8:	0094ca83          	lbu	s5,9(s1)
    800046cc:	0104ba03          	ld	s4,16(s1)
    800046d0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046d4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046d8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046dc:	0001d517          	auipc	a0,0x1d
    800046e0:	2ec50513          	add	a0,a0,748 # 800219c8 <ftable>
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	69c080e7          	jalr	1692(ra) # 80000d80 <release>

  if(ff.type == FD_PIPE){
    800046ec:	4785                	li	a5,1
    800046ee:	04f90d63          	beq	s2,a5,80004748 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046f2:	3979                	addw	s2,s2,-2
    800046f4:	4785                	li	a5,1
    800046f6:	0527e063          	bltu	a5,s2,80004736 <fileclose+0xa8>
    begin_op();
    800046fa:	00000097          	auipc	ra,0x0
    800046fe:	ad0080e7          	jalr	-1328(ra) # 800041ca <begin_op>
    iput(ff.ip);
    80004702:	854e                	mv	a0,s3
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	2da080e7          	jalr	730(ra) # 800039de <iput>
    end_op();
    8000470c:	00000097          	auipc	ra,0x0
    80004710:	b38080e7          	jalr	-1224(ra) # 80004244 <end_op>
    80004714:	a00d                	j	80004736 <fileclose+0xa8>
    panic("fileclose");
    80004716:	00004517          	auipc	a0,0x4
    8000471a:	fc250513          	add	a0,a0,-62 # 800086d8 <syscalls+0x248>
    8000471e:	ffffc097          	auipc	ra,0xffffc
    80004722:	0f0080e7          	jalr	240(ra) # 8000080e <panic>
    release(&ftable.lock);
    80004726:	0001d517          	auipc	a0,0x1d
    8000472a:	2a250513          	add	a0,a0,674 # 800219c8 <ftable>
    8000472e:	ffffc097          	auipc	ra,0xffffc
    80004732:	652080e7          	jalr	1618(ra) # 80000d80 <release>
  }
}
    80004736:	70e2                	ld	ra,56(sp)
    80004738:	7442                	ld	s0,48(sp)
    8000473a:	74a2                	ld	s1,40(sp)
    8000473c:	7902                	ld	s2,32(sp)
    8000473e:	69e2                	ld	s3,24(sp)
    80004740:	6a42                	ld	s4,16(sp)
    80004742:	6aa2                	ld	s5,8(sp)
    80004744:	6121                	add	sp,sp,64
    80004746:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004748:	85d6                	mv	a1,s5
    8000474a:	8552                	mv	a0,s4
    8000474c:	00000097          	auipc	ra,0x0
    80004750:	348080e7          	jalr	840(ra) # 80004a94 <pipeclose>
    80004754:	b7cd                	j	80004736 <fileclose+0xa8>

0000000080004756 <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    80004756:	715d                	add	sp,sp,-80
    80004758:	e486                	sd	ra,72(sp)
    8000475a:	e0a2                	sd	s0,64(sp)
    8000475c:	fc26                	sd	s1,56(sp)
    8000475e:	f84a                	sd	s2,48(sp)
    80004760:	f44e                	sd	s3,40(sp)
    80004762:	0880                	add	s0,sp,80
    80004764:	84aa                	mv	s1,a0
    80004766:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004768:	ffffd097          	auipc	ra,0xffffd
    8000476c:	3a2080e7          	jalr	930(ra) # 80001b0a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004770:	409c                	lw	a5,0(s1)
    80004772:	37f9                	addw	a5,a5,-2
    80004774:	4705                	li	a4,1
    80004776:	04f76763          	bltu	a4,a5,800047c4 <filestat+0x6e>
    8000477a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000477c:	6c88                	ld	a0,24(s1)
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	0a6080e7          	jalr	166(ra) # 80003824 <ilock>
    stati(f->ip, &st);
    80004786:	fb840593          	add	a1,s0,-72
    8000478a:	6c88                	ld	a0,24(s1)
    8000478c:	fffff097          	auipc	ra,0xfffff
    80004790:	322080e7          	jalr	802(ra) # 80003aae <stati>
    iunlock(f->ip);
    80004794:	6c88                	ld	a0,24(s1)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	150080e7          	jalr	336(ra) # 800038e6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000479e:	46e1                	li	a3,24
    800047a0:	fb840613          	add	a2,s0,-72
    800047a4:	85ce                	mv	a1,s3
    800047a6:	06093503          	ld	a0,96(s2)
    800047aa:	ffffd097          	auipc	ra,0xffffd
    800047ae:	fda080e7          	jalr	-38(ra) # 80001784 <copyout>
    800047b2:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800047b6:	60a6                	ld	ra,72(sp)
    800047b8:	6406                	ld	s0,64(sp)
    800047ba:	74e2                	ld	s1,56(sp)
    800047bc:	7942                	ld	s2,48(sp)
    800047be:	79a2                	ld	s3,40(sp)
    800047c0:	6161                	add	sp,sp,80
    800047c2:	8082                	ret
  return -1;
    800047c4:	557d                	li	a0,-1
    800047c6:	bfc5                	j	800047b6 <filestat+0x60>

00000000800047c8 <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    800047c8:	7179                	add	sp,sp,-48
    800047ca:	f406                	sd	ra,40(sp)
    800047cc:	f022                	sd	s0,32(sp)
    800047ce:	ec26                	sd	s1,24(sp)
    800047d0:	e84a                	sd	s2,16(sp)
    800047d2:	e44e                	sd	s3,8(sp)
    800047d4:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047d6:	00854783          	lbu	a5,8(a0)
    800047da:	c3d5                	beqz	a5,8000487e <fileread+0xb6>
    800047dc:	84aa                	mv	s1,a0
    800047de:	89ae                	mv	s3,a1
    800047e0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800047e2:	411c                	lw	a5,0(a0)
    800047e4:	4705                	li	a4,1
    800047e6:	04e78963          	beq	a5,a4,80004838 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047ea:	470d                	li	a4,3
    800047ec:	04e78d63          	beq	a5,a4,80004846 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800047f0:	4709                	li	a4,2
    800047f2:	06e79e63          	bne	a5,a4,8000486e <fileread+0xa6>
    ilock(f->ip);
    800047f6:	6d08                	ld	a0,24(a0)
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	02c080e7          	jalr	44(ra) # 80003824 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004800:	874a                	mv	a4,s2
    80004802:	5094                	lw	a3,32(s1)
    80004804:	864e                	mv	a2,s3
    80004806:	4585                	li	a1,1
    80004808:	6c88                	ld	a0,24(s1)
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	2ce080e7          	jalr	718(ra) # 80003ad8 <readi>
    80004812:	892a                	mv	s2,a0
    80004814:	00a05563          	blez	a0,8000481e <fileread+0x56>
      f->off += r;
    80004818:	509c                	lw	a5,32(s1)
    8000481a:	9fa9                	addw	a5,a5,a0
    8000481c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000481e:	6c88                	ld	a0,24(s1)
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	0c6080e7          	jalr	198(ra) # 800038e6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004828:	854a                	mv	a0,s2
    8000482a:	70a2                	ld	ra,40(sp)
    8000482c:	7402                	ld	s0,32(sp)
    8000482e:	64e2                	ld	s1,24(sp)
    80004830:	6942                	ld	s2,16(sp)
    80004832:	69a2                	ld	s3,8(sp)
    80004834:	6145                	add	sp,sp,48
    80004836:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004838:	6908                	ld	a0,16(a0)
    8000483a:	00000097          	auipc	ra,0x0
    8000483e:	3c2080e7          	jalr	962(ra) # 80004bfc <piperead>
    80004842:	892a                	mv	s2,a0
    80004844:	b7d5                	j	80004828 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004846:	02451783          	lh	a5,36(a0)
    8000484a:	03079693          	sll	a3,a5,0x30
    8000484e:	92c1                	srl	a3,a3,0x30
    80004850:	4725                	li	a4,9
    80004852:	02d76863          	bltu	a4,a3,80004882 <fileread+0xba>
    80004856:	0792                	sll	a5,a5,0x4
    80004858:	0001d717          	auipc	a4,0x1d
    8000485c:	0d070713          	add	a4,a4,208 # 80021928 <devsw>
    80004860:	97ba                	add	a5,a5,a4
    80004862:	639c                	ld	a5,0(a5)
    80004864:	c38d                	beqz	a5,80004886 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004866:	4505                	li	a0,1
    80004868:	9782                	jalr	a5
    8000486a:	892a                	mv	s2,a0
    8000486c:	bf75                	j	80004828 <fileread+0x60>
    panic("fileread");
    8000486e:	00004517          	auipc	a0,0x4
    80004872:	e7a50513          	add	a0,a0,-390 # 800086e8 <syscalls+0x258>
    80004876:	ffffc097          	auipc	ra,0xffffc
    8000487a:	f98080e7          	jalr	-104(ra) # 8000080e <panic>
    return -1;
    8000487e:	597d                	li	s2,-1
    80004880:	b765                	j	80004828 <fileread+0x60>
      return -1;
    80004882:	597d                	li	s2,-1
    80004884:	b755                	j	80004828 <fileread+0x60>
    80004886:	597d                	li	s2,-1
    80004888:	b745                	j	80004828 <fileread+0x60>

000000008000488a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000488a:	00954783          	lbu	a5,9(a0)
    8000488e:	10078e63          	beqz	a5,800049aa <filewrite+0x120>
{
    80004892:	715d                	add	sp,sp,-80
    80004894:	e486                	sd	ra,72(sp)
    80004896:	e0a2                	sd	s0,64(sp)
    80004898:	fc26                	sd	s1,56(sp)
    8000489a:	f84a                	sd	s2,48(sp)
    8000489c:	f44e                	sd	s3,40(sp)
    8000489e:	f052                	sd	s4,32(sp)
    800048a0:	ec56                	sd	s5,24(sp)
    800048a2:	e85a                	sd	s6,16(sp)
    800048a4:	e45e                	sd	s7,8(sp)
    800048a6:	e062                	sd	s8,0(sp)
    800048a8:	0880                	add	s0,sp,80
    800048aa:	892a                	mv	s2,a0
    800048ac:	8b2e                	mv	s6,a1
    800048ae:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800048b0:	411c                	lw	a5,0(a0)
    800048b2:	4705                	li	a4,1
    800048b4:	02e78263          	beq	a5,a4,800048d8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048b8:	470d                	li	a4,3
    800048ba:	02e78563          	beq	a5,a4,800048e4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800048be:	4709                	li	a4,2
    800048c0:	0ce79d63          	bne	a5,a4,8000499a <filewrite+0x110>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048c4:	0ac05b63          	blez	a2,8000497a <filewrite+0xf0>
    int i = 0;
    800048c8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800048ca:	6b85                	lui	s7,0x1
    800048cc:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800048d0:	6c05                	lui	s8,0x1
    800048d2:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800048d6:	a851                	j	8000496a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800048d8:	6908                	ld	a0,16(a0)
    800048da:	00000097          	auipc	ra,0x0
    800048de:	22a080e7          	jalr	554(ra) # 80004b04 <pipewrite>
    800048e2:	a045                	j	80004982 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048e4:	02451783          	lh	a5,36(a0)
    800048e8:	03079693          	sll	a3,a5,0x30
    800048ec:	92c1                	srl	a3,a3,0x30
    800048ee:	4725                	li	a4,9
    800048f0:	0ad76f63          	bltu	a4,a3,800049ae <filewrite+0x124>
    800048f4:	0792                	sll	a5,a5,0x4
    800048f6:	0001d717          	auipc	a4,0x1d
    800048fa:	03270713          	add	a4,a4,50 # 80021928 <devsw>
    800048fe:	97ba                	add	a5,a5,a4
    80004900:	679c                	ld	a5,8(a5)
    80004902:	cbc5                	beqz	a5,800049b2 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004904:	4505                	li	a0,1
    80004906:	9782                	jalr	a5
    80004908:	a8ad                	j	80004982 <filewrite+0xf8>
      if(n1 > max)
    8000490a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000490e:	00000097          	auipc	ra,0x0
    80004912:	8bc080e7          	jalr	-1860(ra) # 800041ca <begin_op>
      ilock(f->ip);
    80004916:	01893503          	ld	a0,24(s2)
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	f0a080e7          	jalr	-246(ra) # 80003824 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004922:	8756                	mv	a4,s5
    80004924:	02092683          	lw	a3,32(s2)
    80004928:	01698633          	add	a2,s3,s6
    8000492c:	4585                	li	a1,1
    8000492e:	01893503          	ld	a0,24(s2)
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	29e080e7          	jalr	670(ra) # 80003bd0 <writei>
    8000493a:	84aa                	mv	s1,a0
    8000493c:	00a05763          	blez	a0,8000494a <filewrite+0xc0>
        f->off += r;
    80004940:	02092783          	lw	a5,32(s2)
    80004944:	9fa9                	addw	a5,a5,a0
    80004946:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000494a:	01893503          	ld	a0,24(s2)
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	f98080e7          	jalr	-104(ra) # 800038e6 <iunlock>
      end_op();
    80004956:	00000097          	auipc	ra,0x0
    8000495a:	8ee080e7          	jalr	-1810(ra) # 80004244 <end_op>

      if(r != n1){
    8000495e:	009a9f63          	bne	s5,s1,8000497c <filewrite+0xf2>
        /* error from writei */
        break;
      }
      i += r;
    80004962:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004966:	0149db63          	bge	s3,s4,8000497c <filewrite+0xf2>
      int n1 = n - i;
    8000496a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000496e:	0004879b          	sext.w	a5,s1
    80004972:	f8fbdce3          	bge	s7,a5,8000490a <filewrite+0x80>
    80004976:	84e2                	mv	s1,s8
    80004978:	bf49                	j	8000490a <filewrite+0x80>
    int i = 0;
    8000497a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000497c:	033a1d63          	bne	s4,s3,800049b6 <filewrite+0x12c>
    80004980:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004982:	60a6                	ld	ra,72(sp)
    80004984:	6406                	ld	s0,64(sp)
    80004986:	74e2                	ld	s1,56(sp)
    80004988:	7942                	ld	s2,48(sp)
    8000498a:	79a2                	ld	s3,40(sp)
    8000498c:	7a02                	ld	s4,32(sp)
    8000498e:	6ae2                	ld	s5,24(sp)
    80004990:	6b42                	ld	s6,16(sp)
    80004992:	6ba2                	ld	s7,8(sp)
    80004994:	6c02                	ld	s8,0(sp)
    80004996:	6161                	add	sp,sp,80
    80004998:	8082                	ret
    panic("filewrite");
    8000499a:	00004517          	auipc	a0,0x4
    8000499e:	d5e50513          	add	a0,a0,-674 # 800086f8 <syscalls+0x268>
    800049a2:	ffffc097          	auipc	ra,0xffffc
    800049a6:	e6c080e7          	jalr	-404(ra) # 8000080e <panic>
    return -1;
    800049aa:	557d                	li	a0,-1
}
    800049ac:	8082                	ret
      return -1;
    800049ae:	557d                	li	a0,-1
    800049b0:	bfc9                	j	80004982 <filewrite+0xf8>
    800049b2:	557d                	li	a0,-1
    800049b4:	b7f9                	j	80004982 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    800049b6:	557d                	li	a0,-1
    800049b8:	b7e9                	j	80004982 <filewrite+0xf8>

00000000800049ba <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049ba:	7179                	add	sp,sp,-48
    800049bc:	f406                	sd	ra,40(sp)
    800049be:	f022                	sd	s0,32(sp)
    800049c0:	ec26                	sd	s1,24(sp)
    800049c2:	e84a                	sd	s2,16(sp)
    800049c4:	e44e                	sd	s3,8(sp)
    800049c6:	e052                	sd	s4,0(sp)
    800049c8:	1800                	add	s0,sp,48
    800049ca:	84aa                	mv	s1,a0
    800049cc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049ce:	0005b023          	sd	zero,0(a1)
    800049d2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049d6:	00000097          	auipc	ra,0x0
    800049da:	bfc080e7          	jalr	-1028(ra) # 800045d2 <filealloc>
    800049de:	e088                	sd	a0,0(s1)
    800049e0:	c551                	beqz	a0,80004a6c <pipealloc+0xb2>
    800049e2:	00000097          	auipc	ra,0x0
    800049e6:	bf0080e7          	jalr	-1040(ra) # 800045d2 <filealloc>
    800049ea:	00aa3023          	sd	a0,0(s4)
    800049ee:	c92d                	beqz	a0,80004a60 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800049f0:	ffffc097          	auipc	ra,0xffffc
    800049f4:	1ec080e7          	jalr	492(ra) # 80000bdc <kalloc>
    800049f8:	892a                	mv	s2,a0
    800049fa:	c125                	beqz	a0,80004a5a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800049fc:	4985                	li	s3,1
    800049fe:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004a02:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004a06:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a0a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a0e:	00004597          	auipc	a1,0x4
    80004a12:	cfa58593          	add	a1,a1,-774 # 80008708 <syscalls+0x278>
    80004a16:	ffffc097          	auipc	ra,0xffffc
    80004a1a:	226080e7          	jalr	550(ra) # 80000c3c <initlock>
  (*f0)->type = FD_PIPE;
    80004a1e:	609c                	ld	a5,0(s1)
    80004a20:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a24:	609c                	ld	a5,0(s1)
    80004a26:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a2a:	609c                	ld	a5,0(s1)
    80004a2c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a30:	609c                	ld	a5,0(s1)
    80004a32:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a36:	000a3783          	ld	a5,0(s4)
    80004a3a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a3e:	000a3783          	ld	a5,0(s4)
    80004a42:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a46:	000a3783          	ld	a5,0(s4)
    80004a4a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a4e:	000a3783          	ld	a5,0(s4)
    80004a52:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a56:	4501                	li	a0,0
    80004a58:	a025                	j	80004a80 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a5a:	6088                	ld	a0,0(s1)
    80004a5c:	e501                	bnez	a0,80004a64 <pipealloc+0xaa>
    80004a5e:	a039                	j	80004a6c <pipealloc+0xb2>
    80004a60:	6088                	ld	a0,0(s1)
    80004a62:	c51d                	beqz	a0,80004a90 <pipealloc+0xd6>
    fileclose(*f0);
    80004a64:	00000097          	auipc	ra,0x0
    80004a68:	c2a080e7          	jalr	-982(ra) # 8000468e <fileclose>
  if(*f1)
    80004a6c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a70:	557d                	li	a0,-1
  if(*f1)
    80004a72:	c799                	beqz	a5,80004a80 <pipealloc+0xc6>
    fileclose(*f1);
    80004a74:	853e                	mv	a0,a5
    80004a76:	00000097          	auipc	ra,0x0
    80004a7a:	c18080e7          	jalr	-1000(ra) # 8000468e <fileclose>
  return -1;
    80004a7e:	557d                	li	a0,-1
}
    80004a80:	70a2                	ld	ra,40(sp)
    80004a82:	7402                	ld	s0,32(sp)
    80004a84:	64e2                	ld	s1,24(sp)
    80004a86:	6942                	ld	s2,16(sp)
    80004a88:	69a2                	ld	s3,8(sp)
    80004a8a:	6a02                	ld	s4,0(sp)
    80004a8c:	6145                	add	sp,sp,48
    80004a8e:	8082                	ret
  return -1;
    80004a90:	557d                	li	a0,-1
    80004a92:	b7fd                	j	80004a80 <pipealloc+0xc6>

0000000080004a94 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a94:	1101                	add	sp,sp,-32
    80004a96:	ec06                	sd	ra,24(sp)
    80004a98:	e822                	sd	s0,16(sp)
    80004a9a:	e426                	sd	s1,8(sp)
    80004a9c:	e04a                	sd	s2,0(sp)
    80004a9e:	1000                	add	s0,sp,32
    80004aa0:	84aa                	mv	s1,a0
    80004aa2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004aa4:	ffffc097          	auipc	ra,0xffffc
    80004aa8:	228080e7          	jalr	552(ra) # 80000ccc <acquire>
  if(writable){
    80004aac:	02090d63          	beqz	s2,80004ae6 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ab0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004ab4:	21848513          	add	a0,s1,536
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	80e080e7          	jalr	-2034(ra) # 800022c6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004ac0:	2204b783          	ld	a5,544(s1)
    80004ac4:	eb95                	bnez	a5,80004af8 <pipeclose+0x64>
    release(&pi->lock);
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	ffffc097          	auipc	ra,0xffffc
    80004acc:	2b8080e7          	jalr	696(ra) # 80000d80 <release>
    kfree((char*)pi);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	00c080e7          	jalr	12(ra) # 80000ade <kfree>
  } else
    release(&pi->lock);
}
    80004ada:	60e2                	ld	ra,24(sp)
    80004adc:	6442                	ld	s0,16(sp)
    80004ade:	64a2                	ld	s1,8(sp)
    80004ae0:	6902                	ld	s2,0(sp)
    80004ae2:	6105                	add	sp,sp,32
    80004ae4:	8082                	ret
    pi->readopen = 0;
    80004ae6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004aea:	21c48513          	add	a0,s1,540
    80004aee:	ffffd097          	auipc	ra,0xffffd
    80004af2:	7d8080e7          	jalr	2008(ra) # 800022c6 <wakeup>
    80004af6:	b7e9                	j	80004ac0 <pipeclose+0x2c>
    release(&pi->lock);
    80004af8:	8526                	mv	a0,s1
    80004afa:	ffffc097          	auipc	ra,0xffffc
    80004afe:	286080e7          	jalr	646(ra) # 80000d80 <release>
}
    80004b02:	bfe1                	j	80004ada <pipeclose+0x46>

0000000080004b04 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b04:	711d                	add	sp,sp,-96
    80004b06:	ec86                	sd	ra,88(sp)
    80004b08:	e8a2                	sd	s0,80(sp)
    80004b0a:	e4a6                	sd	s1,72(sp)
    80004b0c:	e0ca                	sd	s2,64(sp)
    80004b0e:	fc4e                	sd	s3,56(sp)
    80004b10:	f852                	sd	s4,48(sp)
    80004b12:	f456                	sd	s5,40(sp)
    80004b14:	f05a                	sd	s6,32(sp)
    80004b16:	ec5e                	sd	s7,24(sp)
    80004b18:	e862                	sd	s8,16(sp)
    80004b1a:	1080                	add	s0,sp,96
    80004b1c:	84aa                	mv	s1,a0
    80004b1e:	8aae                	mv	s5,a1
    80004b20:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004b22:	ffffd097          	auipc	ra,0xffffd
    80004b26:	fe8080e7          	jalr	-24(ra) # 80001b0a <myproc>
    80004b2a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	ffffc097          	auipc	ra,0xffffc
    80004b32:	19e080e7          	jalr	414(ra) # 80000ccc <acquire>
  while(i < n){
    80004b36:	0b405663          	blez	s4,80004be2 <pipewrite+0xde>
  int i = 0;
    80004b3a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b3c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b3e:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b42:	21c48b93          	add	s7,s1,540
    80004b46:	a089                	j	80004b88 <pipewrite+0x84>
      release(&pi->lock);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	ffffc097          	auipc	ra,0xffffc
    80004b4e:	236080e7          	jalr	566(ra) # 80000d80 <release>
      return -1;
    80004b52:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004b54:	854a                	mv	a0,s2
    80004b56:	60e6                	ld	ra,88(sp)
    80004b58:	6446                	ld	s0,80(sp)
    80004b5a:	64a6                	ld	s1,72(sp)
    80004b5c:	6906                	ld	s2,64(sp)
    80004b5e:	79e2                	ld	s3,56(sp)
    80004b60:	7a42                	ld	s4,48(sp)
    80004b62:	7aa2                	ld	s5,40(sp)
    80004b64:	7b02                	ld	s6,32(sp)
    80004b66:	6be2                	ld	s7,24(sp)
    80004b68:	6c42                	ld	s8,16(sp)
    80004b6a:	6125                	add	sp,sp,96
    80004b6c:	8082                	ret
      wakeup(&pi->nread);
    80004b6e:	8562                	mv	a0,s8
    80004b70:	ffffd097          	auipc	ra,0xffffd
    80004b74:	756080e7          	jalr	1878(ra) # 800022c6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b78:	85a6                	mv	a1,s1
    80004b7a:	855e                	mv	a0,s7
    80004b7c:	ffffd097          	auipc	ra,0xffffd
    80004b80:	6e6080e7          	jalr	1766(ra) # 80002262 <sleep>
  while(i < n){
    80004b84:	07495063          	bge	s2,s4,80004be4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004b88:	2204a783          	lw	a5,544(s1)
    80004b8c:	dfd5                	beqz	a5,80004b48 <pipewrite+0x44>
    80004b8e:	854e                	mv	a0,s3
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	97a080e7          	jalr	-1670(ra) # 8000250a <killed>
    80004b98:	f945                	bnez	a0,80004b48 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    80004b9a:	2184a783          	lw	a5,536(s1)
    80004b9e:	21c4a703          	lw	a4,540(s1)
    80004ba2:	2007879b          	addw	a5,a5,512
    80004ba6:	fcf704e3          	beq	a4,a5,80004b6e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004baa:	4685                	li	a3,1
    80004bac:	01590633          	add	a2,s2,s5
    80004bb0:	faf40593          	add	a1,s0,-81
    80004bb4:	0609b503          	ld	a0,96(s3)
    80004bb8:	ffffd097          	auipc	ra,0xffffd
    80004bbc:	c8c080e7          	jalr	-884(ra) # 80001844 <copyin>
    80004bc0:	03650263          	beq	a0,s6,80004be4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004bc4:	21c4a783          	lw	a5,540(s1)
    80004bc8:	0017871b          	addw	a4,a5,1
    80004bcc:	20e4ae23          	sw	a4,540(s1)
    80004bd0:	1ff7f793          	and	a5,a5,511
    80004bd4:	97a6                	add	a5,a5,s1
    80004bd6:	faf44703          	lbu	a4,-81(s0)
    80004bda:	00e78c23          	sb	a4,24(a5)
      i++;
    80004bde:	2905                	addw	s2,s2,1
    80004be0:	b755                	j	80004b84 <pipewrite+0x80>
  int i = 0;
    80004be2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004be4:	21848513          	add	a0,s1,536
    80004be8:	ffffd097          	auipc	ra,0xffffd
    80004bec:	6de080e7          	jalr	1758(ra) # 800022c6 <wakeup>
  release(&pi->lock);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	18e080e7          	jalr	398(ra) # 80000d80 <release>
  return i;
    80004bfa:	bfa9                	j	80004b54 <pipewrite+0x50>

0000000080004bfc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004bfc:	715d                	add	sp,sp,-80
    80004bfe:	e486                	sd	ra,72(sp)
    80004c00:	e0a2                	sd	s0,64(sp)
    80004c02:	fc26                	sd	s1,56(sp)
    80004c04:	f84a                	sd	s2,48(sp)
    80004c06:	f44e                	sd	s3,40(sp)
    80004c08:	f052                	sd	s4,32(sp)
    80004c0a:	ec56                	sd	s5,24(sp)
    80004c0c:	e85a                	sd	s6,16(sp)
    80004c0e:	0880                	add	s0,sp,80
    80004c10:	84aa                	mv	s1,a0
    80004c12:	892e                	mv	s2,a1
    80004c14:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004c16:	ffffd097          	auipc	ra,0xffffd
    80004c1a:	ef4080e7          	jalr	-268(ra) # 80001b0a <myproc>
    80004c1e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c20:	8526                	mv	a0,s1
    80004c22:	ffffc097          	auipc	ra,0xffffc
    80004c26:	0aa080e7          	jalr	170(ra) # 80000ccc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004c2a:	2184a703          	lw	a4,536(s1)
    80004c2e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004c32:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004c36:	02f71763          	bne	a4,a5,80004c64 <piperead+0x68>
    80004c3a:	2244a783          	lw	a5,548(s1)
    80004c3e:	c39d                	beqz	a5,80004c64 <piperead+0x68>
    if(killed(pr)){
    80004c40:	8552                	mv	a0,s4
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	8c8080e7          	jalr	-1848(ra) # 8000250a <killed>
    80004c4a:	e949                	bnez	a0,80004cdc <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004c4c:	85a6                	mv	a1,s1
    80004c4e:	854e                	mv	a0,s3
    80004c50:	ffffd097          	auipc	ra,0xffffd
    80004c54:	612080e7          	jalr	1554(ra) # 80002262 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004c58:	2184a703          	lw	a4,536(s1)
    80004c5c:	21c4a783          	lw	a5,540(s1)
    80004c60:	fcf70de3          	beq	a4,a5,80004c3a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004c64:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c66:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004c68:	05505463          	blez	s5,80004cb0 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004c6c:	2184a783          	lw	a5,536(s1)
    80004c70:	21c4a703          	lw	a4,540(s1)
    80004c74:	02f70e63          	beq	a4,a5,80004cb0 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c78:	0017871b          	addw	a4,a5,1
    80004c7c:	20e4ac23          	sw	a4,536(s1)
    80004c80:	1ff7f793          	and	a5,a5,511
    80004c84:	97a6                	add	a5,a5,s1
    80004c86:	0187c783          	lbu	a5,24(a5)
    80004c8a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c8e:	4685                	li	a3,1
    80004c90:	fbf40613          	add	a2,s0,-65
    80004c94:	85ca                	mv	a1,s2
    80004c96:	060a3503          	ld	a0,96(s4)
    80004c9a:	ffffd097          	auipc	ra,0xffffd
    80004c9e:	aea080e7          	jalr	-1302(ra) # 80001784 <copyout>
    80004ca2:	01650763          	beq	a0,s6,80004cb0 <piperead+0xb4>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004ca6:	2985                	addw	s3,s3,1
    80004ca8:	0905                	add	s2,s2,1
    80004caa:	fd3a91e3          	bne	s5,s3,80004c6c <piperead+0x70>
    80004cae:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    80004cb0:	21c48513          	add	a0,s1,540
    80004cb4:	ffffd097          	auipc	ra,0xffffd
    80004cb8:	612080e7          	jalr	1554(ra) # 800022c6 <wakeup>
  release(&pi->lock);
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	ffffc097          	auipc	ra,0xffffc
    80004cc2:	0c2080e7          	jalr	194(ra) # 80000d80 <release>
  return i;
}
    80004cc6:	854e                	mv	a0,s3
    80004cc8:	60a6                	ld	ra,72(sp)
    80004cca:	6406                	ld	s0,64(sp)
    80004ccc:	74e2                	ld	s1,56(sp)
    80004cce:	7942                	ld	s2,48(sp)
    80004cd0:	79a2                	ld	s3,40(sp)
    80004cd2:	7a02                	ld	s4,32(sp)
    80004cd4:	6ae2                	ld	s5,24(sp)
    80004cd6:	6b42                	ld	s6,16(sp)
    80004cd8:	6161                	add	sp,sp,80
    80004cda:	8082                	ret
      release(&pi->lock);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffc097          	auipc	ra,0xffffc
    80004ce2:	0a2080e7          	jalr	162(ra) # 80000d80 <release>
      return -1;
    80004ce6:	59fd                	li	s3,-1
    80004ce8:	bff9                	j	80004cc6 <piperead+0xca>

0000000080004cea <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004cea:	1141                	add	sp,sp,-16
    80004cec:	e422                	sd	s0,8(sp)
    80004cee:	0800                	add	s0,sp,16
    80004cf0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004cf2:	8905                	and	a0,a0,1
    80004cf4:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004cf6:	8b89                	and	a5,a5,2
    80004cf8:	c399                	beqz	a5,80004cfe <flags2perm+0x14>
      perm |= PTE_W;
    80004cfa:	00456513          	or	a0,a0,4
    return perm;
}
    80004cfe:	6422                	ld	s0,8(sp)
    80004d00:	0141                	add	sp,sp,16
    80004d02:	8082                	ret

0000000080004d04 <exec>:

int
exec(char *path, char **argv)
{
    80004d04:	df010113          	add	sp,sp,-528
    80004d08:	20113423          	sd	ra,520(sp)
    80004d0c:	20813023          	sd	s0,512(sp)
    80004d10:	ffa6                	sd	s1,504(sp)
    80004d12:	fbca                	sd	s2,496(sp)
    80004d14:	f7ce                	sd	s3,488(sp)
    80004d16:	f3d2                	sd	s4,480(sp)
    80004d18:	efd6                	sd	s5,472(sp)
    80004d1a:	ebda                	sd	s6,464(sp)
    80004d1c:	e7de                	sd	s7,456(sp)
    80004d1e:	e3e2                	sd	s8,448(sp)
    80004d20:	ff66                	sd	s9,440(sp)
    80004d22:	fb6a                	sd	s10,432(sp)
    80004d24:	f76e                	sd	s11,424(sp)
    80004d26:	0c00                	add	s0,sp,528
    80004d28:	892a                	mv	s2,a0
    80004d2a:	dea43c23          	sd	a0,-520(s0)
    80004d2e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d32:	ffffd097          	auipc	ra,0xffffd
    80004d36:	dd8080e7          	jalr	-552(ra) # 80001b0a <myproc>
    80004d3a:	84aa                	mv	s1,a0

  begin_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	48e080e7          	jalr	1166(ra) # 800041ca <begin_op>

  if((ip = namei(path)) == 0){
    80004d44:	854a                	mv	a0,s2
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	284080e7          	jalr	644(ra) # 80003fca <namei>
    80004d4e:	c92d                	beqz	a0,80004dc0 <exec+0xbc>
    80004d50:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	ad2080e7          	jalr	-1326(ra) # 80003824 <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d5a:	04000713          	li	a4,64
    80004d5e:	4681                	li	a3,0
    80004d60:	e5040613          	add	a2,s0,-432
    80004d64:	4581                	li	a1,0
    80004d66:	8552                	mv	a0,s4
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	d70080e7          	jalr	-656(ra) # 80003ad8 <readi>
    80004d70:	04000793          	li	a5,64
    80004d74:	00f51a63          	bne	a0,a5,80004d88 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004d78:	e5042703          	lw	a4,-432(s0)
    80004d7c:	464c47b7          	lui	a5,0x464c4
    80004d80:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d84:	04f70463          	beq	a4,a5,80004dcc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d88:	8552                	mv	a0,s4
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	cfc080e7          	jalr	-772(ra) # 80003a86 <iunlockput>
    end_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	4b2080e7          	jalr	1202(ra) # 80004244 <end_op>
  }
  return -1;
    80004d9a:	557d                	li	a0,-1
}
    80004d9c:	20813083          	ld	ra,520(sp)
    80004da0:	20013403          	ld	s0,512(sp)
    80004da4:	74fe                	ld	s1,504(sp)
    80004da6:	795e                	ld	s2,496(sp)
    80004da8:	79be                	ld	s3,488(sp)
    80004daa:	7a1e                	ld	s4,480(sp)
    80004dac:	6afe                	ld	s5,472(sp)
    80004dae:	6b5e                	ld	s6,464(sp)
    80004db0:	6bbe                	ld	s7,456(sp)
    80004db2:	6c1e                	ld	s8,448(sp)
    80004db4:	7cfa                	ld	s9,440(sp)
    80004db6:	7d5a                	ld	s10,432(sp)
    80004db8:	7dba                	ld	s11,424(sp)
    80004dba:	21010113          	add	sp,sp,528
    80004dbe:	8082                	ret
    end_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	484080e7          	jalr	1156(ra) # 80004244 <end_op>
    return -1;
    80004dc8:	557d                	li	a0,-1
    80004dca:	bfc9                	j	80004d9c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004dcc:	8526                	mv	a0,s1
    80004dce:	ffffd097          	auipc	ra,0xffffd
    80004dd2:	e0a080e7          	jalr	-502(ra) # 80001bd8 <proc_pagetable>
    80004dd6:	8b2a                	mv	s6,a0
    80004dd8:	d945                	beqz	a0,80004d88 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dda:	e7042d03          	lw	s10,-400(s0)
    80004dde:	e8845783          	lhu	a5,-376(s0)
    80004de2:	10078463          	beqz	a5,80004eea <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004de6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004de8:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004dea:	6c85                	lui	s9,0x1
    80004dec:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004df0:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004df4:	6a85                	lui	s5,0x1
    80004df6:	a0b5                	j	80004e62 <exec+0x15e>
      panic("loadseg: address should exist");
    80004df8:	00004517          	auipc	a0,0x4
    80004dfc:	91850513          	add	a0,a0,-1768 # 80008710 <syscalls+0x280>
    80004e00:	ffffc097          	auipc	ra,0xffffc
    80004e04:	a0e080e7          	jalr	-1522(ra) # 8000080e <panic>
    if(sz - i < PGSIZE)
    80004e08:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e0a:	8726                	mv	a4,s1
    80004e0c:	012c06bb          	addw	a3,s8,s2
    80004e10:	4581                	li	a1,0
    80004e12:	8552                	mv	a0,s4
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	cc4080e7          	jalr	-828(ra) # 80003ad8 <readi>
    80004e1c:	2501                	sext.w	a0,a0
    80004e1e:	24a49863          	bne	s1,a0,8000506e <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004e22:	012a893b          	addw	s2,s5,s2
    80004e26:	03397563          	bgeu	s2,s3,80004e50 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004e2a:	02091593          	sll	a1,s2,0x20
    80004e2e:	9181                	srl	a1,a1,0x20
    80004e30:	95de                	add	a1,a1,s7
    80004e32:	855a                	mv	a0,s6
    80004e34:	ffffc097          	auipc	ra,0xffffc
    80004e38:	31c080e7          	jalr	796(ra) # 80001150 <walkaddr>
    80004e3c:	862a                	mv	a2,a0
    if(pa == 0)
    80004e3e:	dd4d                	beqz	a0,80004df8 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004e40:	412984bb          	subw	s1,s3,s2
    80004e44:	0004879b          	sext.w	a5,s1
    80004e48:	fcfcf0e3          	bgeu	s9,a5,80004e08 <exec+0x104>
    80004e4c:	84d6                	mv	s1,s5
    80004e4e:	bf6d                	j	80004e08 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e50:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e54:	2d85                	addw	s11,s11,1
    80004e56:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004e5a:	e8845783          	lhu	a5,-376(s0)
    80004e5e:	08fdd763          	bge	s11,a5,80004eec <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e62:	2d01                	sext.w	s10,s10
    80004e64:	03800713          	li	a4,56
    80004e68:	86ea                	mv	a3,s10
    80004e6a:	e1840613          	add	a2,s0,-488
    80004e6e:	4581                	li	a1,0
    80004e70:	8552                	mv	a0,s4
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	c66080e7          	jalr	-922(ra) # 80003ad8 <readi>
    80004e7a:	03800793          	li	a5,56
    80004e7e:	1ef51663          	bne	a0,a5,8000506a <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004e82:	e1842783          	lw	a5,-488(s0)
    80004e86:	4705                	li	a4,1
    80004e88:	fce796e3          	bne	a5,a4,80004e54 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004e8c:	e4043483          	ld	s1,-448(s0)
    80004e90:	e3843783          	ld	a5,-456(s0)
    80004e94:	1ef4e863          	bltu	s1,a5,80005084 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e98:	e2843783          	ld	a5,-472(s0)
    80004e9c:	94be                	add	s1,s1,a5
    80004e9e:	1ef4e663          	bltu	s1,a5,8000508a <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004ea2:	df043703          	ld	a4,-528(s0)
    80004ea6:	8ff9                	and	a5,a5,a4
    80004ea8:	1e079463          	bnez	a5,80005090 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004eac:	e1c42503          	lw	a0,-484(s0)
    80004eb0:	00000097          	auipc	ra,0x0
    80004eb4:	e3a080e7          	jalr	-454(ra) # 80004cea <flags2perm>
    80004eb8:	86aa                	mv	a3,a0
    80004eba:	8626                	mv	a2,s1
    80004ebc:	85ca                	mv	a1,s2
    80004ebe:	855a                	mv	a0,s6
    80004ec0:	ffffc097          	auipc	ra,0xffffc
    80004ec4:	668080e7          	jalr	1640(ra) # 80001528 <uvmalloc>
    80004ec8:	e0a43423          	sd	a0,-504(s0)
    80004ecc:	1c050563          	beqz	a0,80005096 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ed0:	e2843b83          	ld	s7,-472(s0)
    80004ed4:	e2042c03          	lw	s8,-480(s0)
    80004ed8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004edc:	00098463          	beqz	s3,80004ee4 <exec+0x1e0>
    80004ee0:	4901                	li	s2,0
    80004ee2:	b7a1                	j	80004e2a <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004ee4:	e0843903          	ld	s2,-504(s0)
    80004ee8:	b7b5                	j	80004e54 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004eea:	4901                	li	s2,0
  iunlockput(ip);
    80004eec:	8552                	mv	a0,s4
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	b98080e7          	jalr	-1128(ra) # 80003a86 <iunlockput>
  end_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	34e080e7          	jalr	846(ra) # 80004244 <end_op>
  p = myproc();
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	c0c080e7          	jalr	-1012(ra) # 80001b0a <myproc>
    80004f06:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004f08:	05853c83          	ld	s9,88(a0)
  sz = PGROUNDUP(sz);
    80004f0c:	6985                	lui	s3,0x1
    80004f0e:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004f10:	99ca                	add	s3,s3,s2
    80004f12:	77fd                	lui	a5,0xfffff
    80004f14:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004f18:	4691                	li	a3,4
    80004f1a:	6609                	lui	a2,0x2
    80004f1c:	964e                	add	a2,a2,s3
    80004f1e:	85ce                	mv	a1,s3
    80004f20:	855a                	mv	a0,s6
    80004f22:	ffffc097          	auipc	ra,0xffffc
    80004f26:	606080e7          	jalr	1542(ra) # 80001528 <uvmalloc>
    80004f2a:	892a                	mv	s2,a0
    80004f2c:	e0a43423          	sd	a0,-504(s0)
    80004f30:	e509                	bnez	a0,80004f3a <exec+0x236>
  if(pagetable)
    80004f32:	e1343423          	sd	s3,-504(s0)
    80004f36:	4a01                	li	s4,0
    80004f38:	aa1d                	j	8000506e <exec+0x36a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004f3a:	75f9                	lui	a1,0xffffe
    80004f3c:	95aa                	add	a1,a1,a0
    80004f3e:	855a                	mv	a0,s6
    80004f40:	ffffd097          	auipc	ra,0xffffd
    80004f44:	812080e7          	jalr	-2030(ra) # 80001752 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004f48:	7bfd                	lui	s7,0xfffff
    80004f4a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004f4c:	e0043783          	ld	a5,-512(s0)
    80004f50:	6388                	ld	a0,0(a5)
    80004f52:	c52d                	beqz	a0,80004fbc <exec+0x2b8>
    80004f54:	e9040993          	add	s3,s0,-368
    80004f58:	f9040c13          	add	s8,s0,-112
    80004f5c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004f5e:	ffffc097          	auipc	ra,0xffffc
    80004f62:	fe4080e7          	jalr	-28(ra) # 80000f42 <strlen>
    80004f66:	0015079b          	addw	a5,a0,1
    80004f6a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    80004f6e:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004f72:	13796563          	bltu	s2,s7,8000509c <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f76:	e0043d03          	ld	s10,-512(s0)
    80004f7a:	000d3a03          	ld	s4,0(s10)
    80004f7e:	8552                	mv	a0,s4
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	fc2080e7          	jalr	-62(ra) # 80000f42 <strlen>
    80004f88:	0015069b          	addw	a3,a0,1
    80004f8c:	8652                	mv	a2,s4
    80004f8e:	85ca                	mv	a1,s2
    80004f90:	855a                	mv	a0,s6
    80004f92:	ffffc097          	auipc	ra,0xffffc
    80004f96:	7f2080e7          	jalr	2034(ra) # 80001784 <copyout>
    80004f9a:	10054363          	bltz	a0,800050a0 <exec+0x39c>
    ustack[argc] = sp;
    80004f9e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004fa2:	0485                	add	s1,s1,1
    80004fa4:	008d0793          	add	a5,s10,8
    80004fa8:	e0f43023          	sd	a5,-512(s0)
    80004fac:	008d3503          	ld	a0,8(s10)
    80004fb0:	c909                	beqz	a0,80004fc2 <exec+0x2be>
    if(argc >= MAXARG)
    80004fb2:	09a1                	add	s3,s3,8
    80004fb4:	fb8995e3          	bne	s3,s8,80004f5e <exec+0x25a>
  ip = 0;
    80004fb8:	4a01                	li	s4,0
    80004fba:	a855                	j	8000506e <exec+0x36a>
  sp = sz;
    80004fbc:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004fc0:	4481                	li	s1,0
  ustack[argc] = 0;
    80004fc2:	00349793          	sll	a5,s1,0x3
    80004fc6:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdc4d0>
    80004fca:	97a2                	add	a5,a5,s0
    80004fcc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004fd0:	00148693          	add	a3,s1,1
    80004fd4:	068e                	sll	a3,a3,0x3
    80004fd6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004fda:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004fde:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004fe2:	f57968e3          	bltu	s2,s7,80004f32 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004fe6:	e9040613          	add	a2,s0,-368
    80004fea:	85ca                	mv	a1,s2
    80004fec:	855a                	mv	a0,s6
    80004fee:	ffffc097          	auipc	ra,0xffffc
    80004ff2:	796080e7          	jalr	1942(ra) # 80001784 <copyout>
    80004ff6:	0a054763          	bltz	a0,800050a4 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004ffa:	068ab783          	ld	a5,104(s5) # 1068 <_entry-0x7fffef98>
    80004ffe:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005002:	df843783          	ld	a5,-520(s0)
    80005006:	0007c703          	lbu	a4,0(a5)
    8000500a:	cf11                	beqz	a4,80005026 <exec+0x322>
    8000500c:	0785                	add	a5,a5,1
    if(*s == '/')
    8000500e:	02f00693          	li	a3,47
    80005012:	a039                	j	80005020 <exec+0x31c>
      last = s+1;
    80005014:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005018:	0785                	add	a5,a5,1
    8000501a:	fff7c703          	lbu	a4,-1(a5)
    8000501e:	c701                	beqz	a4,80005026 <exec+0x322>
    if(*s == '/')
    80005020:	fed71ce3          	bne	a4,a3,80005018 <exec+0x314>
    80005024:	bfc5                	j	80005014 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80005026:	4641                	li	a2,16
    80005028:	df843583          	ld	a1,-520(s0)
    8000502c:	168a8513          	add	a0,s5,360
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	ee0080e7          	jalr	-288(ra) # 80000f10 <safestrcpy>
  oldpagetable = p->pagetable;
    80005038:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    8000503c:	076ab023          	sd	s6,96(s5)
  p->sz = sz;
    80005040:	e0843783          	ld	a5,-504(s0)
    80005044:	04fabc23          	sd	a5,88(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    80005048:	068ab783          	ld	a5,104(s5)
    8000504c:	e6843703          	ld	a4,-408(s0)
    80005050:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    80005052:	068ab783          	ld	a5,104(s5)
    80005056:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000505a:	85e6                	mv	a1,s9
    8000505c:	ffffd097          	auipc	ra,0xffffd
    80005060:	c18080e7          	jalr	-1000(ra) # 80001c74 <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    80005064:	0004851b          	sext.w	a0,s1
    80005068:	bb15                	j	80004d9c <exec+0x98>
    8000506a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000506e:	e0843583          	ld	a1,-504(s0)
    80005072:	855a                	mv	a0,s6
    80005074:	ffffd097          	auipc	ra,0xffffd
    80005078:	c00080e7          	jalr	-1024(ra) # 80001c74 <proc_freepagetable>
  return -1;
    8000507c:	557d                	li	a0,-1
  if(ip){
    8000507e:	d00a0fe3          	beqz	s4,80004d9c <exec+0x98>
    80005082:	b319                	j	80004d88 <exec+0x84>
    80005084:	e1243423          	sd	s2,-504(s0)
    80005088:	b7dd                	j	8000506e <exec+0x36a>
    8000508a:	e1243423          	sd	s2,-504(s0)
    8000508e:	b7c5                	j	8000506e <exec+0x36a>
    80005090:	e1243423          	sd	s2,-504(s0)
    80005094:	bfe9                	j	8000506e <exec+0x36a>
    80005096:	e1243423          	sd	s2,-504(s0)
    8000509a:	bfd1                	j	8000506e <exec+0x36a>
  ip = 0;
    8000509c:	4a01                	li	s4,0
    8000509e:	bfc1                	j	8000506e <exec+0x36a>
    800050a0:	4a01                	li	s4,0
  if(pagetable)
    800050a2:	b7f1                	j	8000506e <exec+0x36a>
  sz = sz1;
    800050a4:	e0843983          	ld	s3,-504(s0)
    800050a8:	b569                	j	80004f32 <exec+0x22e>

00000000800050aa <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    800050aa:	7179                	add	sp,sp,-48
    800050ac:	f406                	sd	ra,40(sp)
    800050ae:	f022                	sd	s0,32(sp)
    800050b0:	ec26                	sd	s1,24(sp)
    800050b2:	e84a                	sd	s2,16(sp)
    800050b4:	1800                	add	s0,sp,48
    800050b6:	892e                	mv	s2,a1
    800050b8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800050ba:	fdc40593          	add	a1,s0,-36
    800050be:	ffffe097          	auipc	ra,0xffffe
    800050c2:	bf6080e7          	jalr	-1034(ra) # 80002cb4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800050c6:	fdc42703          	lw	a4,-36(s0)
    800050ca:	47bd                	li	a5,15
    800050cc:	02e7eb63          	bltu	a5,a4,80005102 <argfd+0x58>
    800050d0:	ffffd097          	auipc	ra,0xffffd
    800050d4:	a3a080e7          	jalr	-1478(ra) # 80001b0a <myproc>
    800050d8:	fdc42703          	lw	a4,-36(s0)
    800050dc:	01c70793          	add	a5,a4,28
    800050e0:	078e                	sll	a5,a5,0x3
    800050e2:	953e                	add	a0,a0,a5
    800050e4:	611c                	ld	a5,0(a0)
    800050e6:	c385                	beqz	a5,80005106 <argfd+0x5c>
    return -1;
  if(pfd)
    800050e8:	00090463          	beqz	s2,800050f0 <argfd+0x46>
    *pfd = fd;
    800050ec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050f0:	4501                	li	a0,0
  if(pf)
    800050f2:	c091                	beqz	s1,800050f6 <argfd+0x4c>
    *pf = f;
    800050f4:	e09c                	sd	a5,0(s1)
}
    800050f6:	70a2                	ld	ra,40(sp)
    800050f8:	7402                	ld	s0,32(sp)
    800050fa:	64e2                	ld	s1,24(sp)
    800050fc:	6942                	ld	s2,16(sp)
    800050fe:	6145                	add	sp,sp,48
    80005100:	8082                	ret
    return -1;
    80005102:	557d                	li	a0,-1
    80005104:	bfcd                	j	800050f6 <argfd+0x4c>
    80005106:	557d                	li	a0,-1
    80005108:	b7fd                	j	800050f6 <argfd+0x4c>

000000008000510a <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    8000510a:	1101                	add	sp,sp,-32
    8000510c:	ec06                	sd	ra,24(sp)
    8000510e:	e822                	sd	s0,16(sp)
    80005110:	e426                	sd	s1,8(sp)
    80005112:	1000                	add	s0,sp,32
    80005114:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005116:	ffffd097          	auipc	ra,0xffffd
    8000511a:	9f4080e7          	jalr	-1548(ra) # 80001b0a <myproc>
    8000511e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005120:	0e050793          	add	a5,a0,224
    80005124:	4501                	li	a0,0
    80005126:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005128:	6398                	ld	a4,0(a5)
    8000512a:	cb19                	beqz	a4,80005140 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000512c:	2505                	addw	a0,a0,1
    8000512e:	07a1                	add	a5,a5,8
    80005130:	fed51ce3          	bne	a0,a3,80005128 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005134:	557d                	li	a0,-1
}
    80005136:	60e2                	ld	ra,24(sp)
    80005138:	6442                	ld	s0,16(sp)
    8000513a:	64a2                	ld	s1,8(sp)
    8000513c:	6105                	add	sp,sp,32
    8000513e:	8082                	ret
      p->ofile[fd] = f;
    80005140:	01c50793          	add	a5,a0,28
    80005144:	078e                	sll	a5,a5,0x3
    80005146:	963e                	add	a2,a2,a5
    80005148:	e204                	sd	s1,0(a2)
      return fd;
    8000514a:	b7f5                	j	80005136 <fdalloc+0x2c>

000000008000514c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000514c:	715d                	add	sp,sp,-80
    8000514e:	e486                	sd	ra,72(sp)
    80005150:	e0a2                	sd	s0,64(sp)
    80005152:	fc26                	sd	s1,56(sp)
    80005154:	f84a                	sd	s2,48(sp)
    80005156:	f44e                	sd	s3,40(sp)
    80005158:	f052                	sd	s4,32(sp)
    8000515a:	ec56                	sd	s5,24(sp)
    8000515c:	e85a                	sd	s6,16(sp)
    8000515e:	0880                	add	s0,sp,80
    80005160:	8b2e                	mv	s6,a1
    80005162:	89b2                	mv	s3,a2
    80005164:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005166:	fb040593          	add	a1,s0,-80
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	e7e080e7          	jalr	-386(ra) # 80003fe8 <nameiparent>
    80005172:	84aa                	mv	s1,a0
    80005174:	14050b63          	beqz	a0,800052ca <create+0x17e>
    return 0;

  ilock(dp);
    80005178:	ffffe097          	auipc	ra,0xffffe
    8000517c:	6ac080e7          	jalr	1708(ra) # 80003824 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005180:	4601                	li	a2,0
    80005182:	fb040593          	add	a1,s0,-80
    80005186:	8526                	mv	a0,s1
    80005188:	fffff097          	auipc	ra,0xfffff
    8000518c:	b80080e7          	jalr	-1152(ra) # 80003d08 <dirlookup>
    80005190:	8aaa                	mv	s5,a0
    80005192:	c921                	beqz	a0,800051e2 <create+0x96>
    iunlockput(dp);
    80005194:	8526                	mv	a0,s1
    80005196:	fffff097          	auipc	ra,0xfffff
    8000519a:	8f0080e7          	jalr	-1808(ra) # 80003a86 <iunlockput>
    ilock(ip);
    8000519e:	8556                	mv	a0,s5
    800051a0:	ffffe097          	auipc	ra,0xffffe
    800051a4:	684080e7          	jalr	1668(ra) # 80003824 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800051a8:	4789                	li	a5,2
    800051aa:	02fb1563          	bne	s6,a5,800051d4 <create+0x88>
    800051ae:	044ad783          	lhu	a5,68(s5)
    800051b2:	37f9                	addw	a5,a5,-2
    800051b4:	17c2                	sll	a5,a5,0x30
    800051b6:	93c1                	srl	a5,a5,0x30
    800051b8:	4705                	li	a4,1
    800051ba:	00f76d63          	bltu	a4,a5,800051d4 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800051be:	8556                	mv	a0,s5
    800051c0:	60a6                	ld	ra,72(sp)
    800051c2:	6406                	ld	s0,64(sp)
    800051c4:	74e2                	ld	s1,56(sp)
    800051c6:	7942                	ld	s2,48(sp)
    800051c8:	79a2                	ld	s3,40(sp)
    800051ca:	7a02                	ld	s4,32(sp)
    800051cc:	6ae2                	ld	s5,24(sp)
    800051ce:	6b42                	ld	s6,16(sp)
    800051d0:	6161                	add	sp,sp,80
    800051d2:	8082                	ret
    iunlockput(ip);
    800051d4:	8556                	mv	a0,s5
    800051d6:	fffff097          	auipc	ra,0xfffff
    800051da:	8b0080e7          	jalr	-1872(ra) # 80003a86 <iunlockput>
    return 0;
    800051de:	4a81                	li	s5,0
    800051e0:	bff9                	j	800051be <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800051e2:	85da                	mv	a1,s6
    800051e4:	4088                	lw	a0,0(s1)
    800051e6:	ffffe097          	auipc	ra,0xffffe
    800051ea:	4a6080e7          	jalr	1190(ra) # 8000368c <ialloc>
    800051ee:	8a2a                	mv	s4,a0
    800051f0:	c529                	beqz	a0,8000523a <create+0xee>
  ilock(ip);
    800051f2:	ffffe097          	auipc	ra,0xffffe
    800051f6:	632080e7          	jalr	1586(ra) # 80003824 <ilock>
  ip->major = major;
    800051fa:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800051fe:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005202:	4905                	li	s2,1
    80005204:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005208:	8552                	mv	a0,s4
    8000520a:	ffffe097          	auipc	ra,0xffffe
    8000520e:	54e080e7          	jalr	1358(ra) # 80003758 <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    80005212:	032b0b63          	beq	s6,s2,80005248 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005216:	004a2603          	lw	a2,4(s4)
    8000521a:	fb040593          	add	a1,s0,-80
    8000521e:	8526                	mv	a0,s1
    80005220:	fffff097          	auipc	ra,0xfffff
    80005224:	cf8080e7          	jalr	-776(ra) # 80003f18 <dirlink>
    80005228:	06054f63          	bltz	a0,800052a6 <create+0x15a>
  iunlockput(dp);
    8000522c:	8526                	mv	a0,s1
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	858080e7          	jalr	-1960(ra) # 80003a86 <iunlockput>
  return ip;
    80005236:	8ad2                	mv	s5,s4
    80005238:	b759                	j	800051be <create+0x72>
    iunlockput(dp);
    8000523a:	8526                	mv	a0,s1
    8000523c:	fffff097          	auipc	ra,0xfffff
    80005240:	84a080e7          	jalr	-1974(ra) # 80003a86 <iunlockput>
    return 0;
    80005244:	8ad2                	mv	s5,s4
    80005246:	bfa5                	j	800051be <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005248:	004a2603          	lw	a2,4(s4)
    8000524c:	00003597          	auipc	a1,0x3
    80005250:	4e458593          	add	a1,a1,1252 # 80008730 <syscalls+0x2a0>
    80005254:	8552                	mv	a0,s4
    80005256:	fffff097          	auipc	ra,0xfffff
    8000525a:	cc2080e7          	jalr	-830(ra) # 80003f18 <dirlink>
    8000525e:	04054463          	bltz	a0,800052a6 <create+0x15a>
    80005262:	40d0                	lw	a2,4(s1)
    80005264:	00003597          	auipc	a1,0x3
    80005268:	4d458593          	add	a1,a1,1236 # 80008738 <syscalls+0x2a8>
    8000526c:	8552                	mv	a0,s4
    8000526e:	fffff097          	auipc	ra,0xfffff
    80005272:	caa080e7          	jalr	-854(ra) # 80003f18 <dirlink>
    80005276:	02054863          	bltz	a0,800052a6 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    8000527a:	004a2603          	lw	a2,4(s4)
    8000527e:	fb040593          	add	a1,s0,-80
    80005282:	8526                	mv	a0,s1
    80005284:	fffff097          	auipc	ra,0xfffff
    80005288:	c94080e7          	jalr	-876(ra) # 80003f18 <dirlink>
    8000528c:	00054d63          	bltz	a0,800052a6 <create+0x15a>
    dp->nlink++;  /* for ".." */
    80005290:	04a4d783          	lhu	a5,74(s1)
    80005294:	2785                	addw	a5,a5,1
    80005296:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000529a:	8526                	mv	a0,s1
    8000529c:	ffffe097          	auipc	ra,0xffffe
    800052a0:	4bc080e7          	jalr	1212(ra) # 80003758 <iupdate>
    800052a4:	b761                	j	8000522c <create+0xe0>
  ip->nlink = 0;
    800052a6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800052aa:	8552                	mv	a0,s4
    800052ac:	ffffe097          	auipc	ra,0xffffe
    800052b0:	4ac080e7          	jalr	1196(ra) # 80003758 <iupdate>
  iunlockput(ip);
    800052b4:	8552                	mv	a0,s4
    800052b6:	ffffe097          	auipc	ra,0xffffe
    800052ba:	7d0080e7          	jalr	2000(ra) # 80003a86 <iunlockput>
  iunlockput(dp);
    800052be:	8526                	mv	a0,s1
    800052c0:	ffffe097          	auipc	ra,0xffffe
    800052c4:	7c6080e7          	jalr	1990(ra) # 80003a86 <iunlockput>
  return 0;
    800052c8:	bddd                	j	800051be <create+0x72>
    return 0;
    800052ca:	8aaa                	mv	s5,a0
    800052cc:	bdcd                	j	800051be <create+0x72>

00000000800052ce <sys_dup>:
{
    800052ce:	7179                	add	sp,sp,-48
    800052d0:	f406                	sd	ra,40(sp)
    800052d2:	f022                	sd	s0,32(sp)
    800052d4:	ec26                	sd	s1,24(sp)
    800052d6:	e84a                	sd	s2,16(sp)
    800052d8:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052da:	fd840613          	add	a2,s0,-40
    800052de:	4581                	li	a1,0
    800052e0:	4501                	li	a0,0
    800052e2:	00000097          	auipc	ra,0x0
    800052e6:	dc8080e7          	jalr	-568(ra) # 800050aa <argfd>
    return -1;
    800052ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052ec:	02054363          	bltz	a0,80005312 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800052f0:	fd843903          	ld	s2,-40(s0)
    800052f4:	854a                	mv	a0,s2
    800052f6:	00000097          	auipc	ra,0x0
    800052fa:	e14080e7          	jalr	-492(ra) # 8000510a <fdalloc>
    800052fe:	84aa                	mv	s1,a0
    return -1;
    80005300:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005302:	00054863          	bltz	a0,80005312 <sys_dup+0x44>
  filedup(f);
    80005306:	854a                	mv	a0,s2
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	334080e7          	jalr	820(ra) # 8000463c <filedup>
  return fd;
    80005310:	87a6                	mv	a5,s1
}
    80005312:	853e                	mv	a0,a5
    80005314:	70a2                	ld	ra,40(sp)
    80005316:	7402                	ld	s0,32(sp)
    80005318:	64e2                	ld	s1,24(sp)
    8000531a:	6942                	ld	s2,16(sp)
    8000531c:	6145                	add	sp,sp,48
    8000531e:	8082                	ret

0000000080005320 <sys_read>:
{
    80005320:	7179                	add	sp,sp,-48
    80005322:	f406                	sd	ra,40(sp)
    80005324:	f022                	sd	s0,32(sp)
    80005326:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80005328:	fd840593          	add	a1,s0,-40
    8000532c:	4505                	li	a0,1
    8000532e:	ffffe097          	auipc	ra,0xffffe
    80005332:	9a6080e7          	jalr	-1626(ra) # 80002cd4 <argaddr>
  argint(2, &n);
    80005336:	fe440593          	add	a1,s0,-28
    8000533a:	4509                	li	a0,2
    8000533c:	ffffe097          	auipc	ra,0xffffe
    80005340:	978080e7          	jalr	-1672(ra) # 80002cb4 <argint>
  if(argfd(0, 0, &f) < 0)
    80005344:	fe840613          	add	a2,s0,-24
    80005348:	4581                	li	a1,0
    8000534a:	4501                	li	a0,0
    8000534c:	00000097          	auipc	ra,0x0
    80005350:	d5e080e7          	jalr	-674(ra) # 800050aa <argfd>
    80005354:	87aa                	mv	a5,a0
    return -1;
    80005356:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005358:	0007cc63          	bltz	a5,80005370 <sys_read+0x50>
  return fileread(f, p, n);
    8000535c:	fe442603          	lw	a2,-28(s0)
    80005360:	fd843583          	ld	a1,-40(s0)
    80005364:	fe843503          	ld	a0,-24(s0)
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	460080e7          	jalr	1120(ra) # 800047c8 <fileread>
}
    80005370:	70a2                	ld	ra,40(sp)
    80005372:	7402                	ld	s0,32(sp)
    80005374:	6145                	add	sp,sp,48
    80005376:	8082                	ret

0000000080005378 <sys_write>:
{
    80005378:	7179                	add	sp,sp,-48
    8000537a:	f406                	sd	ra,40(sp)
    8000537c:	f022                	sd	s0,32(sp)
    8000537e:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80005380:	fd840593          	add	a1,s0,-40
    80005384:	4505                	li	a0,1
    80005386:	ffffe097          	auipc	ra,0xffffe
    8000538a:	94e080e7          	jalr	-1714(ra) # 80002cd4 <argaddr>
  argint(2, &n);
    8000538e:	fe440593          	add	a1,s0,-28
    80005392:	4509                	li	a0,2
    80005394:	ffffe097          	auipc	ra,0xffffe
    80005398:	920080e7          	jalr	-1760(ra) # 80002cb4 <argint>
  if(argfd(0, 0, &f) < 0)
    8000539c:	fe840613          	add	a2,s0,-24
    800053a0:	4581                	li	a1,0
    800053a2:	4501                	li	a0,0
    800053a4:	00000097          	auipc	ra,0x0
    800053a8:	d06080e7          	jalr	-762(ra) # 800050aa <argfd>
    800053ac:	87aa                	mv	a5,a0
    return -1;
    800053ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053b0:	0007cc63          	bltz	a5,800053c8 <sys_write+0x50>
  return filewrite(f, p, n);
    800053b4:	fe442603          	lw	a2,-28(s0)
    800053b8:	fd843583          	ld	a1,-40(s0)
    800053bc:	fe843503          	ld	a0,-24(s0)
    800053c0:	fffff097          	auipc	ra,0xfffff
    800053c4:	4ca080e7          	jalr	1226(ra) # 8000488a <filewrite>
}
    800053c8:	70a2                	ld	ra,40(sp)
    800053ca:	7402                	ld	s0,32(sp)
    800053cc:	6145                	add	sp,sp,48
    800053ce:	8082                	ret

00000000800053d0 <sys_close>:
{
    800053d0:	1101                	add	sp,sp,-32
    800053d2:	ec06                	sd	ra,24(sp)
    800053d4:	e822                	sd	s0,16(sp)
    800053d6:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053d8:	fe040613          	add	a2,s0,-32
    800053dc:	fec40593          	add	a1,s0,-20
    800053e0:	4501                	li	a0,0
    800053e2:	00000097          	auipc	ra,0x0
    800053e6:	cc8080e7          	jalr	-824(ra) # 800050aa <argfd>
    return -1;
    800053ea:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053ec:	02054463          	bltz	a0,80005414 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053f0:	ffffc097          	auipc	ra,0xffffc
    800053f4:	71a080e7          	jalr	1818(ra) # 80001b0a <myproc>
    800053f8:	fec42783          	lw	a5,-20(s0)
    800053fc:	07f1                	add	a5,a5,28
    800053fe:	078e                	sll	a5,a5,0x3
    80005400:	953e                	add	a0,a0,a5
    80005402:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005406:	fe043503          	ld	a0,-32(s0)
    8000540a:	fffff097          	auipc	ra,0xfffff
    8000540e:	284080e7          	jalr	644(ra) # 8000468e <fileclose>
  return 0;
    80005412:	4781                	li	a5,0
}
    80005414:	853e                	mv	a0,a5
    80005416:	60e2                	ld	ra,24(sp)
    80005418:	6442                	ld	s0,16(sp)
    8000541a:	6105                	add	sp,sp,32
    8000541c:	8082                	ret

000000008000541e <sys_fstat>:
{
    8000541e:	1101                	add	sp,sp,-32
    80005420:	ec06                	sd	ra,24(sp)
    80005422:	e822                	sd	s0,16(sp)
    80005424:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80005426:	fe040593          	add	a1,s0,-32
    8000542a:	4505                	li	a0,1
    8000542c:	ffffe097          	auipc	ra,0xffffe
    80005430:	8a8080e7          	jalr	-1880(ra) # 80002cd4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005434:	fe840613          	add	a2,s0,-24
    80005438:	4581                	li	a1,0
    8000543a:	4501                	li	a0,0
    8000543c:	00000097          	auipc	ra,0x0
    80005440:	c6e080e7          	jalr	-914(ra) # 800050aa <argfd>
    80005444:	87aa                	mv	a5,a0
    return -1;
    80005446:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005448:	0007ca63          	bltz	a5,8000545c <sys_fstat+0x3e>
  return filestat(f, st);
    8000544c:	fe043583          	ld	a1,-32(s0)
    80005450:	fe843503          	ld	a0,-24(s0)
    80005454:	fffff097          	auipc	ra,0xfffff
    80005458:	302080e7          	jalr	770(ra) # 80004756 <filestat>
}
    8000545c:	60e2                	ld	ra,24(sp)
    8000545e:	6442                	ld	s0,16(sp)
    80005460:	6105                	add	sp,sp,32
    80005462:	8082                	ret

0000000080005464 <sys_link>:
{
    80005464:	7169                	add	sp,sp,-304
    80005466:	f606                	sd	ra,296(sp)
    80005468:	f222                	sd	s0,288(sp)
    8000546a:	ee26                	sd	s1,280(sp)
    8000546c:	ea4a                	sd	s2,272(sp)
    8000546e:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005470:	08000613          	li	a2,128
    80005474:	ed040593          	add	a1,s0,-304
    80005478:	4501                	li	a0,0
    8000547a:	ffffe097          	auipc	ra,0xffffe
    8000547e:	87a080e7          	jalr	-1926(ra) # 80002cf4 <argstr>
    return -1;
    80005482:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005484:	10054e63          	bltz	a0,800055a0 <sys_link+0x13c>
    80005488:	08000613          	li	a2,128
    8000548c:	f5040593          	add	a1,s0,-176
    80005490:	4505                	li	a0,1
    80005492:	ffffe097          	auipc	ra,0xffffe
    80005496:	862080e7          	jalr	-1950(ra) # 80002cf4 <argstr>
    return -1;
    8000549a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000549c:	10054263          	bltz	a0,800055a0 <sys_link+0x13c>
  begin_op();
    800054a0:	fffff097          	auipc	ra,0xfffff
    800054a4:	d2a080e7          	jalr	-726(ra) # 800041ca <begin_op>
  if((ip = namei(old)) == 0){
    800054a8:	ed040513          	add	a0,s0,-304
    800054ac:	fffff097          	auipc	ra,0xfffff
    800054b0:	b1e080e7          	jalr	-1250(ra) # 80003fca <namei>
    800054b4:	84aa                	mv	s1,a0
    800054b6:	c551                	beqz	a0,80005542 <sys_link+0xde>
  ilock(ip);
    800054b8:	ffffe097          	auipc	ra,0xffffe
    800054bc:	36c080e7          	jalr	876(ra) # 80003824 <ilock>
  if(ip->type == T_DIR){
    800054c0:	04449703          	lh	a4,68(s1)
    800054c4:	4785                	li	a5,1
    800054c6:	08f70463          	beq	a4,a5,8000554e <sys_link+0xea>
  ip->nlink++;
    800054ca:	04a4d783          	lhu	a5,74(s1)
    800054ce:	2785                	addw	a5,a5,1
    800054d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054d4:	8526                	mv	a0,s1
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	282080e7          	jalr	642(ra) # 80003758 <iupdate>
  iunlock(ip);
    800054de:	8526                	mv	a0,s1
    800054e0:	ffffe097          	auipc	ra,0xffffe
    800054e4:	406080e7          	jalr	1030(ra) # 800038e6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054e8:	fd040593          	add	a1,s0,-48
    800054ec:	f5040513          	add	a0,s0,-176
    800054f0:	fffff097          	auipc	ra,0xfffff
    800054f4:	af8080e7          	jalr	-1288(ra) # 80003fe8 <nameiparent>
    800054f8:	892a                	mv	s2,a0
    800054fa:	c935                	beqz	a0,8000556e <sys_link+0x10a>
  ilock(dp);
    800054fc:	ffffe097          	auipc	ra,0xffffe
    80005500:	328080e7          	jalr	808(ra) # 80003824 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005504:	00092703          	lw	a4,0(s2)
    80005508:	409c                	lw	a5,0(s1)
    8000550a:	04f71d63          	bne	a4,a5,80005564 <sys_link+0x100>
    8000550e:	40d0                	lw	a2,4(s1)
    80005510:	fd040593          	add	a1,s0,-48
    80005514:	854a                	mv	a0,s2
    80005516:	fffff097          	auipc	ra,0xfffff
    8000551a:	a02080e7          	jalr	-1534(ra) # 80003f18 <dirlink>
    8000551e:	04054363          	bltz	a0,80005564 <sys_link+0x100>
  iunlockput(dp);
    80005522:	854a                	mv	a0,s2
    80005524:	ffffe097          	auipc	ra,0xffffe
    80005528:	562080e7          	jalr	1378(ra) # 80003a86 <iunlockput>
  iput(ip);
    8000552c:	8526                	mv	a0,s1
    8000552e:	ffffe097          	auipc	ra,0xffffe
    80005532:	4b0080e7          	jalr	1200(ra) # 800039de <iput>
  end_op();
    80005536:	fffff097          	auipc	ra,0xfffff
    8000553a:	d0e080e7          	jalr	-754(ra) # 80004244 <end_op>
  return 0;
    8000553e:	4781                	li	a5,0
    80005540:	a085                	j	800055a0 <sys_link+0x13c>
    end_op();
    80005542:	fffff097          	auipc	ra,0xfffff
    80005546:	d02080e7          	jalr	-766(ra) # 80004244 <end_op>
    return -1;
    8000554a:	57fd                	li	a5,-1
    8000554c:	a891                	j	800055a0 <sys_link+0x13c>
    iunlockput(ip);
    8000554e:	8526                	mv	a0,s1
    80005550:	ffffe097          	auipc	ra,0xffffe
    80005554:	536080e7          	jalr	1334(ra) # 80003a86 <iunlockput>
    end_op();
    80005558:	fffff097          	auipc	ra,0xfffff
    8000555c:	cec080e7          	jalr	-788(ra) # 80004244 <end_op>
    return -1;
    80005560:	57fd                	li	a5,-1
    80005562:	a83d                	j	800055a0 <sys_link+0x13c>
    iunlockput(dp);
    80005564:	854a                	mv	a0,s2
    80005566:	ffffe097          	auipc	ra,0xffffe
    8000556a:	520080e7          	jalr	1312(ra) # 80003a86 <iunlockput>
  ilock(ip);
    8000556e:	8526                	mv	a0,s1
    80005570:	ffffe097          	auipc	ra,0xffffe
    80005574:	2b4080e7          	jalr	692(ra) # 80003824 <ilock>
  ip->nlink--;
    80005578:	04a4d783          	lhu	a5,74(s1)
    8000557c:	37fd                	addw	a5,a5,-1
    8000557e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005582:	8526                	mv	a0,s1
    80005584:	ffffe097          	auipc	ra,0xffffe
    80005588:	1d4080e7          	jalr	468(ra) # 80003758 <iupdate>
  iunlockput(ip);
    8000558c:	8526                	mv	a0,s1
    8000558e:	ffffe097          	auipc	ra,0xffffe
    80005592:	4f8080e7          	jalr	1272(ra) # 80003a86 <iunlockput>
  end_op();
    80005596:	fffff097          	auipc	ra,0xfffff
    8000559a:	cae080e7          	jalr	-850(ra) # 80004244 <end_op>
  return -1;
    8000559e:	57fd                	li	a5,-1
}
    800055a0:	853e                	mv	a0,a5
    800055a2:	70b2                	ld	ra,296(sp)
    800055a4:	7412                	ld	s0,288(sp)
    800055a6:	64f2                	ld	s1,280(sp)
    800055a8:	6952                	ld	s2,272(sp)
    800055aa:	6155                	add	sp,sp,304
    800055ac:	8082                	ret

00000000800055ae <sys_unlink>:
{
    800055ae:	7151                	add	sp,sp,-240
    800055b0:	f586                	sd	ra,232(sp)
    800055b2:	f1a2                	sd	s0,224(sp)
    800055b4:	eda6                	sd	s1,216(sp)
    800055b6:	e9ca                	sd	s2,208(sp)
    800055b8:	e5ce                	sd	s3,200(sp)
    800055ba:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800055bc:	08000613          	li	a2,128
    800055c0:	f3040593          	add	a1,s0,-208
    800055c4:	4501                	li	a0,0
    800055c6:	ffffd097          	auipc	ra,0xffffd
    800055ca:	72e080e7          	jalr	1838(ra) # 80002cf4 <argstr>
    800055ce:	18054163          	bltz	a0,80005750 <sys_unlink+0x1a2>
  begin_op();
    800055d2:	fffff097          	auipc	ra,0xfffff
    800055d6:	bf8080e7          	jalr	-1032(ra) # 800041ca <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055da:	fb040593          	add	a1,s0,-80
    800055de:	f3040513          	add	a0,s0,-208
    800055e2:	fffff097          	auipc	ra,0xfffff
    800055e6:	a06080e7          	jalr	-1530(ra) # 80003fe8 <nameiparent>
    800055ea:	84aa                	mv	s1,a0
    800055ec:	c979                	beqz	a0,800056c2 <sys_unlink+0x114>
  ilock(dp);
    800055ee:	ffffe097          	auipc	ra,0xffffe
    800055f2:	236080e7          	jalr	566(ra) # 80003824 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055f6:	00003597          	auipc	a1,0x3
    800055fa:	13a58593          	add	a1,a1,314 # 80008730 <syscalls+0x2a0>
    800055fe:	fb040513          	add	a0,s0,-80
    80005602:	ffffe097          	auipc	ra,0xffffe
    80005606:	6ec080e7          	jalr	1772(ra) # 80003cee <namecmp>
    8000560a:	14050a63          	beqz	a0,8000575e <sys_unlink+0x1b0>
    8000560e:	00003597          	auipc	a1,0x3
    80005612:	12a58593          	add	a1,a1,298 # 80008738 <syscalls+0x2a8>
    80005616:	fb040513          	add	a0,s0,-80
    8000561a:	ffffe097          	auipc	ra,0xffffe
    8000561e:	6d4080e7          	jalr	1748(ra) # 80003cee <namecmp>
    80005622:	12050e63          	beqz	a0,8000575e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005626:	f2c40613          	add	a2,s0,-212
    8000562a:	fb040593          	add	a1,s0,-80
    8000562e:	8526                	mv	a0,s1
    80005630:	ffffe097          	auipc	ra,0xffffe
    80005634:	6d8080e7          	jalr	1752(ra) # 80003d08 <dirlookup>
    80005638:	892a                	mv	s2,a0
    8000563a:	12050263          	beqz	a0,8000575e <sys_unlink+0x1b0>
  ilock(ip);
    8000563e:	ffffe097          	auipc	ra,0xffffe
    80005642:	1e6080e7          	jalr	486(ra) # 80003824 <ilock>
  if(ip->nlink < 1)
    80005646:	04a91783          	lh	a5,74(s2)
    8000564a:	08f05263          	blez	a5,800056ce <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000564e:	04491703          	lh	a4,68(s2)
    80005652:	4785                	li	a5,1
    80005654:	08f70563          	beq	a4,a5,800056de <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005658:	4641                	li	a2,16
    8000565a:	4581                	li	a1,0
    8000565c:	fc040513          	add	a0,s0,-64
    80005660:	ffffb097          	auipc	ra,0xffffb
    80005664:	768080e7          	jalr	1896(ra) # 80000dc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005668:	4741                	li	a4,16
    8000566a:	f2c42683          	lw	a3,-212(s0)
    8000566e:	fc040613          	add	a2,s0,-64
    80005672:	4581                	li	a1,0
    80005674:	8526                	mv	a0,s1
    80005676:	ffffe097          	auipc	ra,0xffffe
    8000567a:	55a080e7          	jalr	1370(ra) # 80003bd0 <writei>
    8000567e:	47c1                	li	a5,16
    80005680:	0af51563          	bne	a0,a5,8000572a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005684:	04491703          	lh	a4,68(s2)
    80005688:	4785                	li	a5,1
    8000568a:	0af70863          	beq	a4,a5,8000573a <sys_unlink+0x18c>
  iunlockput(dp);
    8000568e:	8526                	mv	a0,s1
    80005690:	ffffe097          	auipc	ra,0xffffe
    80005694:	3f6080e7          	jalr	1014(ra) # 80003a86 <iunlockput>
  ip->nlink--;
    80005698:	04a95783          	lhu	a5,74(s2)
    8000569c:	37fd                	addw	a5,a5,-1
    8000569e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800056a2:	854a                	mv	a0,s2
    800056a4:	ffffe097          	auipc	ra,0xffffe
    800056a8:	0b4080e7          	jalr	180(ra) # 80003758 <iupdate>
  iunlockput(ip);
    800056ac:	854a                	mv	a0,s2
    800056ae:	ffffe097          	auipc	ra,0xffffe
    800056b2:	3d8080e7          	jalr	984(ra) # 80003a86 <iunlockput>
  end_op();
    800056b6:	fffff097          	auipc	ra,0xfffff
    800056ba:	b8e080e7          	jalr	-1138(ra) # 80004244 <end_op>
  return 0;
    800056be:	4501                	li	a0,0
    800056c0:	a84d                	j	80005772 <sys_unlink+0x1c4>
    end_op();
    800056c2:	fffff097          	auipc	ra,0xfffff
    800056c6:	b82080e7          	jalr	-1150(ra) # 80004244 <end_op>
    return -1;
    800056ca:	557d                	li	a0,-1
    800056cc:	a05d                	j	80005772 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800056ce:	00003517          	auipc	a0,0x3
    800056d2:	07250513          	add	a0,a0,114 # 80008740 <syscalls+0x2b0>
    800056d6:	ffffb097          	auipc	ra,0xffffb
    800056da:	138080e7          	jalr	312(ra) # 8000080e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056de:	04c92703          	lw	a4,76(s2)
    800056e2:	02000793          	li	a5,32
    800056e6:	f6e7f9e3          	bgeu	a5,a4,80005658 <sys_unlink+0xaa>
    800056ea:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056ee:	4741                	li	a4,16
    800056f0:	86ce                	mv	a3,s3
    800056f2:	f1840613          	add	a2,s0,-232
    800056f6:	4581                	li	a1,0
    800056f8:	854a                	mv	a0,s2
    800056fa:	ffffe097          	auipc	ra,0xffffe
    800056fe:	3de080e7          	jalr	990(ra) # 80003ad8 <readi>
    80005702:	47c1                	li	a5,16
    80005704:	00f51b63          	bne	a0,a5,8000571a <sys_unlink+0x16c>
    if(de.inum != 0)
    80005708:	f1845783          	lhu	a5,-232(s0)
    8000570c:	e7a1                	bnez	a5,80005754 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000570e:	29c1                	addw	s3,s3,16
    80005710:	04c92783          	lw	a5,76(s2)
    80005714:	fcf9ede3          	bltu	s3,a5,800056ee <sys_unlink+0x140>
    80005718:	b781                	j	80005658 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000571a:	00003517          	auipc	a0,0x3
    8000571e:	03e50513          	add	a0,a0,62 # 80008758 <syscalls+0x2c8>
    80005722:	ffffb097          	auipc	ra,0xffffb
    80005726:	0ec080e7          	jalr	236(ra) # 8000080e <panic>
    panic("unlink: writei");
    8000572a:	00003517          	auipc	a0,0x3
    8000572e:	04650513          	add	a0,a0,70 # 80008770 <syscalls+0x2e0>
    80005732:	ffffb097          	auipc	ra,0xffffb
    80005736:	0dc080e7          	jalr	220(ra) # 8000080e <panic>
    dp->nlink--;
    8000573a:	04a4d783          	lhu	a5,74(s1)
    8000573e:	37fd                	addw	a5,a5,-1
    80005740:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005744:	8526                	mv	a0,s1
    80005746:	ffffe097          	auipc	ra,0xffffe
    8000574a:	012080e7          	jalr	18(ra) # 80003758 <iupdate>
    8000574e:	b781                	j	8000568e <sys_unlink+0xe0>
    return -1;
    80005750:	557d                	li	a0,-1
    80005752:	a005                	j	80005772 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005754:	854a                	mv	a0,s2
    80005756:	ffffe097          	auipc	ra,0xffffe
    8000575a:	330080e7          	jalr	816(ra) # 80003a86 <iunlockput>
  iunlockput(dp);
    8000575e:	8526                	mv	a0,s1
    80005760:	ffffe097          	auipc	ra,0xffffe
    80005764:	326080e7          	jalr	806(ra) # 80003a86 <iunlockput>
  end_op();
    80005768:	fffff097          	auipc	ra,0xfffff
    8000576c:	adc080e7          	jalr	-1316(ra) # 80004244 <end_op>
  return -1;
    80005770:	557d                	li	a0,-1
}
    80005772:	70ae                	ld	ra,232(sp)
    80005774:	740e                	ld	s0,224(sp)
    80005776:	64ee                	ld	s1,216(sp)
    80005778:	694e                	ld	s2,208(sp)
    8000577a:	69ae                	ld	s3,200(sp)
    8000577c:	616d                	add	sp,sp,240
    8000577e:	8082                	ret

0000000080005780 <sys_open>:

uint64
sys_open(void)
{
    80005780:	7131                	add	sp,sp,-192
    80005782:	fd06                	sd	ra,184(sp)
    80005784:	f922                	sd	s0,176(sp)
    80005786:	f526                	sd	s1,168(sp)
    80005788:	f14a                	sd	s2,160(sp)
    8000578a:	ed4e                	sd	s3,152(sp)
    8000578c:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000578e:	f4c40593          	add	a1,s0,-180
    80005792:	4505                	li	a0,1
    80005794:	ffffd097          	auipc	ra,0xffffd
    80005798:	520080e7          	jalr	1312(ra) # 80002cb4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000579c:	08000613          	li	a2,128
    800057a0:	f5040593          	add	a1,s0,-176
    800057a4:	4501                	li	a0,0
    800057a6:	ffffd097          	auipc	ra,0xffffd
    800057aa:	54e080e7          	jalr	1358(ra) # 80002cf4 <argstr>
    800057ae:	87aa                	mv	a5,a0
    return -1;
    800057b0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057b2:	0a07c863          	bltz	a5,80005862 <sys_open+0xe2>

  begin_op();
    800057b6:	fffff097          	auipc	ra,0xfffff
    800057ba:	a14080e7          	jalr	-1516(ra) # 800041ca <begin_op>

  if(omode & O_CREATE){
    800057be:	f4c42783          	lw	a5,-180(s0)
    800057c2:	2007f793          	and	a5,a5,512
    800057c6:	cbdd                	beqz	a5,8000587c <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    800057c8:	4681                	li	a3,0
    800057ca:	4601                	li	a2,0
    800057cc:	4589                	li	a1,2
    800057ce:	f5040513          	add	a0,s0,-176
    800057d2:	00000097          	auipc	ra,0x0
    800057d6:	97a080e7          	jalr	-1670(ra) # 8000514c <create>
    800057da:	84aa                	mv	s1,a0
    if(ip == 0){
    800057dc:	c951                	beqz	a0,80005870 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057de:	04449703          	lh	a4,68(s1)
    800057e2:	478d                	li	a5,3
    800057e4:	00f71763          	bne	a4,a5,800057f2 <sys_open+0x72>
    800057e8:	0464d703          	lhu	a4,70(s1)
    800057ec:	47a5                	li	a5,9
    800057ee:	0ce7ec63          	bltu	a5,a4,800058c6 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800057f2:	fffff097          	auipc	ra,0xfffff
    800057f6:	de0080e7          	jalr	-544(ra) # 800045d2 <filealloc>
    800057fa:	892a                	mv	s2,a0
    800057fc:	c56d                	beqz	a0,800058e6 <sys_open+0x166>
    800057fe:	00000097          	auipc	ra,0x0
    80005802:	90c080e7          	jalr	-1780(ra) # 8000510a <fdalloc>
    80005806:	89aa                	mv	s3,a0
    80005808:	0c054a63          	bltz	a0,800058dc <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000580c:	04449703          	lh	a4,68(s1)
    80005810:	478d                	li	a5,3
    80005812:	0ef70563          	beq	a4,a5,800058fc <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005816:	4789                	li	a5,2
    80005818:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000581c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005820:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005824:	f4c42783          	lw	a5,-180(s0)
    80005828:	0017c713          	xor	a4,a5,1
    8000582c:	8b05                	and	a4,a4,1
    8000582e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005832:	0037f713          	and	a4,a5,3
    80005836:	00e03733          	snez	a4,a4
    8000583a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000583e:	4007f793          	and	a5,a5,1024
    80005842:	c791                	beqz	a5,8000584e <sys_open+0xce>
    80005844:	04449703          	lh	a4,68(s1)
    80005848:	4789                	li	a5,2
    8000584a:	0cf70063          	beq	a4,a5,8000590a <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    8000584e:	8526                	mv	a0,s1
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	096080e7          	jalr	150(ra) # 800038e6 <iunlock>
  end_op();
    80005858:	fffff097          	auipc	ra,0xfffff
    8000585c:	9ec080e7          	jalr	-1556(ra) # 80004244 <end_op>

  return fd;
    80005860:	854e                	mv	a0,s3
}
    80005862:	70ea                	ld	ra,184(sp)
    80005864:	744a                	ld	s0,176(sp)
    80005866:	74aa                	ld	s1,168(sp)
    80005868:	790a                	ld	s2,160(sp)
    8000586a:	69ea                	ld	s3,152(sp)
    8000586c:	6129                	add	sp,sp,192
    8000586e:	8082                	ret
      end_op();
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	9d4080e7          	jalr	-1580(ra) # 80004244 <end_op>
      return -1;
    80005878:	557d                	li	a0,-1
    8000587a:	b7e5                	j	80005862 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000587c:	f5040513          	add	a0,s0,-176
    80005880:	ffffe097          	auipc	ra,0xffffe
    80005884:	74a080e7          	jalr	1866(ra) # 80003fca <namei>
    80005888:	84aa                	mv	s1,a0
    8000588a:	c905                	beqz	a0,800058ba <sys_open+0x13a>
    ilock(ip);
    8000588c:	ffffe097          	auipc	ra,0xffffe
    80005890:	f98080e7          	jalr	-104(ra) # 80003824 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005894:	04449703          	lh	a4,68(s1)
    80005898:	4785                	li	a5,1
    8000589a:	f4f712e3          	bne	a4,a5,800057de <sys_open+0x5e>
    8000589e:	f4c42783          	lw	a5,-180(s0)
    800058a2:	dba1                	beqz	a5,800057f2 <sys_open+0x72>
      iunlockput(ip);
    800058a4:	8526                	mv	a0,s1
    800058a6:	ffffe097          	auipc	ra,0xffffe
    800058aa:	1e0080e7          	jalr	480(ra) # 80003a86 <iunlockput>
      end_op();
    800058ae:	fffff097          	auipc	ra,0xfffff
    800058b2:	996080e7          	jalr	-1642(ra) # 80004244 <end_op>
      return -1;
    800058b6:	557d                	li	a0,-1
    800058b8:	b76d                	j	80005862 <sys_open+0xe2>
      end_op();
    800058ba:	fffff097          	auipc	ra,0xfffff
    800058be:	98a080e7          	jalr	-1654(ra) # 80004244 <end_op>
      return -1;
    800058c2:	557d                	li	a0,-1
    800058c4:	bf79                	j	80005862 <sys_open+0xe2>
    iunlockput(ip);
    800058c6:	8526                	mv	a0,s1
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	1be080e7          	jalr	446(ra) # 80003a86 <iunlockput>
    end_op();
    800058d0:	fffff097          	auipc	ra,0xfffff
    800058d4:	974080e7          	jalr	-1676(ra) # 80004244 <end_op>
    return -1;
    800058d8:	557d                	li	a0,-1
    800058da:	b761                	j	80005862 <sys_open+0xe2>
      fileclose(f);
    800058dc:	854a                	mv	a0,s2
    800058de:	fffff097          	auipc	ra,0xfffff
    800058e2:	db0080e7          	jalr	-592(ra) # 8000468e <fileclose>
    iunlockput(ip);
    800058e6:	8526                	mv	a0,s1
    800058e8:	ffffe097          	auipc	ra,0xffffe
    800058ec:	19e080e7          	jalr	414(ra) # 80003a86 <iunlockput>
    end_op();
    800058f0:	fffff097          	auipc	ra,0xfffff
    800058f4:	954080e7          	jalr	-1708(ra) # 80004244 <end_op>
    return -1;
    800058f8:	557d                	li	a0,-1
    800058fa:	b7a5                	j	80005862 <sys_open+0xe2>
    f->type = FD_DEVICE;
    800058fc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005900:	04649783          	lh	a5,70(s1)
    80005904:	02f91223          	sh	a5,36(s2)
    80005908:	bf21                	j	80005820 <sys_open+0xa0>
    itrunc(ip);
    8000590a:	8526                	mv	a0,s1
    8000590c:	ffffe097          	auipc	ra,0xffffe
    80005910:	026080e7          	jalr	38(ra) # 80003932 <itrunc>
    80005914:	bf2d                	j	8000584e <sys_open+0xce>

0000000080005916 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005916:	7175                	add	sp,sp,-144
    80005918:	e506                	sd	ra,136(sp)
    8000591a:	e122                	sd	s0,128(sp)
    8000591c:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000591e:	fffff097          	auipc	ra,0xfffff
    80005922:	8ac080e7          	jalr	-1876(ra) # 800041ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005926:	08000613          	li	a2,128
    8000592a:	f7040593          	add	a1,s0,-144
    8000592e:	4501                	li	a0,0
    80005930:	ffffd097          	auipc	ra,0xffffd
    80005934:	3c4080e7          	jalr	964(ra) # 80002cf4 <argstr>
    80005938:	02054963          	bltz	a0,8000596a <sys_mkdir+0x54>
    8000593c:	4681                	li	a3,0
    8000593e:	4601                	li	a2,0
    80005940:	4585                	li	a1,1
    80005942:	f7040513          	add	a0,s0,-144
    80005946:	00000097          	auipc	ra,0x0
    8000594a:	806080e7          	jalr	-2042(ra) # 8000514c <create>
    8000594e:	cd11                	beqz	a0,8000596a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005950:	ffffe097          	auipc	ra,0xffffe
    80005954:	136080e7          	jalr	310(ra) # 80003a86 <iunlockput>
  end_op();
    80005958:	fffff097          	auipc	ra,0xfffff
    8000595c:	8ec080e7          	jalr	-1812(ra) # 80004244 <end_op>
  return 0;
    80005960:	4501                	li	a0,0
}
    80005962:	60aa                	ld	ra,136(sp)
    80005964:	640a                	ld	s0,128(sp)
    80005966:	6149                	add	sp,sp,144
    80005968:	8082                	ret
    end_op();
    8000596a:	fffff097          	auipc	ra,0xfffff
    8000596e:	8da080e7          	jalr	-1830(ra) # 80004244 <end_op>
    return -1;
    80005972:	557d                	li	a0,-1
    80005974:	b7fd                	j	80005962 <sys_mkdir+0x4c>

0000000080005976 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005976:	7135                	add	sp,sp,-160
    80005978:	ed06                	sd	ra,152(sp)
    8000597a:	e922                	sd	s0,144(sp)
    8000597c:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000597e:	fffff097          	auipc	ra,0xfffff
    80005982:	84c080e7          	jalr	-1972(ra) # 800041ca <begin_op>
  argint(1, &major);
    80005986:	f6c40593          	add	a1,s0,-148
    8000598a:	4505                	li	a0,1
    8000598c:	ffffd097          	auipc	ra,0xffffd
    80005990:	328080e7          	jalr	808(ra) # 80002cb4 <argint>
  argint(2, &minor);
    80005994:	f6840593          	add	a1,s0,-152
    80005998:	4509                	li	a0,2
    8000599a:	ffffd097          	auipc	ra,0xffffd
    8000599e:	31a080e7          	jalr	794(ra) # 80002cb4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059a2:	08000613          	li	a2,128
    800059a6:	f7040593          	add	a1,s0,-144
    800059aa:	4501                	li	a0,0
    800059ac:	ffffd097          	auipc	ra,0xffffd
    800059b0:	348080e7          	jalr	840(ra) # 80002cf4 <argstr>
    800059b4:	02054b63          	bltz	a0,800059ea <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800059b8:	f6841683          	lh	a3,-152(s0)
    800059bc:	f6c41603          	lh	a2,-148(s0)
    800059c0:	458d                	li	a1,3
    800059c2:	f7040513          	add	a0,s0,-144
    800059c6:	fffff097          	auipc	ra,0xfffff
    800059ca:	786080e7          	jalr	1926(ra) # 8000514c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059ce:	cd11                	beqz	a0,800059ea <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059d0:	ffffe097          	auipc	ra,0xffffe
    800059d4:	0b6080e7          	jalr	182(ra) # 80003a86 <iunlockput>
  end_op();
    800059d8:	fffff097          	auipc	ra,0xfffff
    800059dc:	86c080e7          	jalr	-1940(ra) # 80004244 <end_op>
  return 0;
    800059e0:	4501                	li	a0,0
}
    800059e2:	60ea                	ld	ra,152(sp)
    800059e4:	644a                	ld	s0,144(sp)
    800059e6:	610d                	add	sp,sp,160
    800059e8:	8082                	ret
    end_op();
    800059ea:	fffff097          	auipc	ra,0xfffff
    800059ee:	85a080e7          	jalr	-1958(ra) # 80004244 <end_op>
    return -1;
    800059f2:	557d                	li	a0,-1
    800059f4:	b7fd                	j	800059e2 <sys_mknod+0x6c>

00000000800059f6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800059f6:	7135                	add	sp,sp,-160
    800059f8:	ed06                	sd	ra,152(sp)
    800059fa:	e922                	sd	s0,144(sp)
    800059fc:	e526                	sd	s1,136(sp)
    800059fe:	e14a                	sd	s2,128(sp)
    80005a00:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a02:	ffffc097          	auipc	ra,0xffffc
    80005a06:	108080e7          	jalr	264(ra) # 80001b0a <myproc>
    80005a0a:	892a                	mv	s2,a0
  
  begin_op();
    80005a0c:	ffffe097          	auipc	ra,0xffffe
    80005a10:	7be080e7          	jalr	1982(ra) # 800041ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a14:	08000613          	li	a2,128
    80005a18:	f6040593          	add	a1,s0,-160
    80005a1c:	4501                	li	a0,0
    80005a1e:	ffffd097          	auipc	ra,0xffffd
    80005a22:	2d6080e7          	jalr	726(ra) # 80002cf4 <argstr>
    80005a26:	04054b63          	bltz	a0,80005a7c <sys_chdir+0x86>
    80005a2a:	f6040513          	add	a0,s0,-160
    80005a2e:	ffffe097          	auipc	ra,0xffffe
    80005a32:	59c080e7          	jalr	1436(ra) # 80003fca <namei>
    80005a36:	84aa                	mv	s1,a0
    80005a38:	c131                	beqz	a0,80005a7c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a3a:	ffffe097          	auipc	ra,0xffffe
    80005a3e:	dea080e7          	jalr	-534(ra) # 80003824 <ilock>
  if(ip->type != T_DIR){
    80005a42:	04449703          	lh	a4,68(s1)
    80005a46:	4785                	li	a5,1
    80005a48:	04f71063          	bne	a4,a5,80005a88 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005a4c:	8526                	mv	a0,s1
    80005a4e:	ffffe097          	auipc	ra,0xffffe
    80005a52:	e98080e7          	jalr	-360(ra) # 800038e6 <iunlock>
  iput(p->cwd);
    80005a56:	16093503          	ld	a0,352(s2)
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	f84080e7          	jalr	-124(ra) # 800039de <iput>
  end_op();
    80005a62:	ffffe097          	auipc	ra,0xffffe
    80005a66:	7e2080e7          	jalr	2018(ra) # 80004244 <end_op>
  p->cwd = ip;
    80005a6a:	16993023          	sd	s1,352(s2)
  return 0;
    80005a6e:	4501                	li	a0,0
}
    80005a70:	60ea                	ld	ra,152(sp)
    80005a72:	644a                	ld	s0,144(sp)
    80005a74:	64aa                	ld	s1,136(sp)
    80005a76:	690a                	ld	s2,128(sp)
    80005a78:	610d                	add	sp,sp,160
    80005a7a:	8082                	ret
    end_op();
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	7c8080e7          	jalr	1992(ra) # 80004244 <end_op>
    return -1;
    80005a84:	557d                	li	a0,-1
    80005a86:	b7ed                	j	80005a70 <sys_chdir+0x7a>
    iunlockput(ip);
    80005a88:	8526                	mv	a0,s1
    80005a8a:	ffffe097          	auipc	ra,0xffffe
    80005a8e:	ffc080e7          	jalr	-4(ra) # 80003a86 <iunlockput>
    end_op();
    80005a92:	ffffe097          	auipc	ra,0xffffe
    80005a96:	7b2080e7          	jalr	1970(ra) # 80004244 <end_op>
    return -1;
    80005a9a:	557d                	li	a0,-1
    80005a9c:	bfd1                	j	80005a70 <sys_chdir+0x7a>

0000000080005a9e <sys_exec>:

uint64
sys_exec(void)
{
    80005a9e:	7121                	add	sp,sp,-448
    80005aa0:	ff06                	sd	ra,440(sp)
    80005aa2:	fb22                	sd	s0,432(sp)
    80005aa4:	f726                	sd	s1,424(sp)
    80005aa6:	f34a                	sd	s2,416(sp)
    80005aa8:	ef4e                	sd	s3,408(sp)
    80005aaa:	eb52                	sd	s4,400(sp)
    80005aac:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005aae:	e4840593          	add	a1,s0,-440
    80005ab2:	4505                	li	a0,1
    80005ab4:	ffffd097          	auipc	ra,0xffffd
    80005ab8:	220080e7          	jalr	544(ra) # 80002cd4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005abc:	08000613          	li	a2,128
    80005ac0:	f5040593          	add	a1,s0,-176
    80005ac4:	4501                	li	a0,0
    80005ac6:	ffffd097          	auipc	ra,0xffffd
    80005aca:	22e080e7          	jalr	558(ra) # 80002cf4 <argstr>
    80005ace:	87aa                	mv	a5,a0
    return -1;
    80005ad0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005ad2:	0c07c263          	bltz	a5,80005b96 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005ad6:	10000613          	li	a2,256
    80005ada:	4581                	li	a1,0
    80005adc:	e5040513          	add	a0,s0,-432
    80005ae0:	ffffb097          	auipc	ra,0xffffb
    80005ae4:	2e8080e7          	jalr	744(ra) # 80000dc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ae8:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005aec:	89a6                	mv	s3,s1
    80005aee:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005af0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005af4:	00391513          	sll	a0,s2,0x3
    80005af8:	e4040593          	add	a1,s0,-448
    80005afc:	e4843783          	ld	a5,-440(s0)
    80005b00:	953e                	add	a0,a0,a5
    80005b02:	ffffd097          	auipc	ra,0xffffd
    80005b06:	114080e7          	jalr	276(ra) # 80002c16 <fetchaddr>
    80005b0a:	02054a63          	bltz	a0,80005b3e <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005b0e:	e4043783          	ld	a5,-448(s0)
    80005b12:	c3b9                	beqz	a5,80005b58 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b14:	ffffb097          	auipc	ra,0xffffb
    80005b18:	0c8080e7          	jalr	200(ra) # 80000bdc <kalloc>
    80005b1c:	85aa                	mv	a1,a0
    80005b1e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b22:	cd11                	beqz	a0,80005b3e <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b24:	6605                	lui	a2,0x1
    80005b26:	e4043503          	ld	a0,-448(s0)
    80005b2a:	ffffd097          	auipc	ra,0xffffd
    80005b2e:	13e080e7          	jalr	318(ra) # 80002c68 <fetchstr>
    80005b32:	00054663          	bltz	a0,80005b3e <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005b36:	0905                	add	s2,s2,1
    80005b38:	09a1                	add	s3,s3,8
    80005b3a:	fb491de3          	bne	s2,s4,80005af4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b3e:	f5040913          	add	s2,s0,-176
    80005b42:	6088                	ld	a0,0(s1)
    80005b44:	c921                	beqz	a0,80005b94 <sys_exec+0xf6>
    kfree(argv[i]);
    80005b46:	ffffb097          	auipc	ra,0xffffb
    80005b4a:	f98080e7          	jalr	-104(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b4e:	04a1                	add	s1,s1,8
    80005b50:	ff2499e3          	bne	s1,s2,80005b42 <sys_exec+0xa4>
  return -1;
    80005b54:	557d                	li	a0,-1
    80005b56:	a081                	j	80005b96 <sys_exec+0xf8>
      argv[i] = 0;
    80005b58:	0009079b          	sext.w	a5,s2
    80005b5c:	078e                	sll	a5,a5,0x3
    80005b5e:	fd078793          	add	a5,a5,-48
    80005b62:	97a2                	add	a5,a5,s0
    80005b64:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005b68:	e5040593          	add	a1,s0,-432
    80005b6c:	f5040513          	add	a0,s0,-176
    80005b70:	fffff097          	auipc	ra,0xfffff
    80005b74:	194080e7          	jalr	404(ra) # 80004d04 <exec>
    80005b78:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b7a:	f5040993          	add	s3,s0,-176
    80005b7e:	6088                	ld	a0,0(s1)
    80005b80:	c901                	beqz	a0,80005b90 <sys_exec+0xf2>
    kfree(argv[i]);
    80005b82:	ffffb097          	auipc	ra,0xffffb
    80005b86:	f5c080e7          	jalr	-164(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b8a:	04a1                	add	s1,s1,8
    80005b8c:	ff3499e3          	bne	s1,s3,80005b7e <sys_exec+0xe0>
  return ret;
    80005b90:	854a                	mv	a0,s2
    80005b92:	a011                	j	80005b96 <sys_exec+0xf8>
  return -1;
    80005b94:	557d                	li	a0,-1
}
    80005b96:	70fa                	ld	ra,440(sp)
    80005b98:	745a                	ld	s0,432(sp)
    80005b9a:	74ba                	ld	s1,424(sp)
    80005b9c:	791a                	ld	s2,416(sp)
    80005b9e:	69fa                	ld	s3,408(sp)
    80005ba0:	6a5a                	ld	s4,400(sp)
    80005ba2:	6139                	add	sp,sp,448
    80005ba4:	8082                	ret

0000000080005ba6 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005ba6:	7139                	add	sp,sp,-64
    80005ba8:	fc06                	sd	ra,56(sp)
    80005baa:	f822                	sd	s0,48(sp)
    80005bac:	f426                	sd	s1,40(sp)
    80005bae:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005bb0:	ffffc097          	auipc	ra,0xffffc
    80005bb4:	f5a080e7          	jalr	-166(ra) # 80001b0a <myproc>
    80005bb8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005bba:	fd840593          	add	a1,s0,-40
    80005bbe:	4501                	li	a0,0
    80005bc0:	ffffd097          	auipc	ra,0xffffd
    80005bc4:	114080e7          	jalr	276(ra) # 80002cd4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005bc8:	fc840593          	add	a1,s0,-56
    80005bcc:	fd040513          	add	a0,s0,-48
    80005bd0:	fffff097          	auipc	ra,0xfffff
    80005bd4:	dea080e7          	jalr	-534(ra) # 800049ba <pipealloc>
    return -1;
    80005bd8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005bda:	0c054463          	bltz	a0,80005ca2 <sys_pipe+0xfc>
  fd0 = -1;
    80005bde:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005be2:	fd043503          	ld	a0,-48(s0)
    80005be6:	fffff097          	auipc	ra,0xfffff
    80005bea:	524080e7          	jalr	1316(ra) # 8000510a <fdalloc>
    80005bee:	fca42223          	sw	a0,-60(s0)
    80005bf2:	08054b63          	bltz	a0,80005c88 <sys_pipe+0xe2>
    80005bf6:	fc843503          	ld	a0,-56(s0)
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	510080e7          	jalr	1296(ra) # 8000510a <fdalloc>
    80005c02:	fca42023          	sw	a0,-64(s0)
    80005c06:	06054863          	bltz	a0,80005c76 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c0a:	4691                	li	a3,4
    80005c0c:	fc440613          	add	a2,s0,-60
    80005c10:	fd843583          	ld	a1,-40(s0)
    80005c14:	70a8                	ld	a0,96(s1)
    80005c16:	ffffc097          	auipc	ra,0xffffc
    80005c1a:	b6e080e7          	jalr	-1170(ra) # 80001784 <copyout>
    80005c1e:	02054063          	bltz	a0,80005c3e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c22:	4691                	li	a3,4
    80005c24:	fc040613          	add	a2,s0,-64
    80005c28:	fd843583          	ld	a1,-40(s0)
    80005c2c:	0591                	add	a1,a1,4
    80005c2e:	70a8                	ld	a0,96(s1)
    80005c30:	ffffc097          	auipc	ra,0xffffc
    80005c34:	b54080e7          	jalr	-1196(ra) # 80001784 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c38:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c3a:	06055463          	bgez	a0,80005ca2 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005c3e:	fc442783          	lw	a5,-60(s0)
    80005c42:	07f1                	add	a5,a5,28
    80005c44:	078e                	sll	a5,a5,0x3
    80005c46:	97a6                	add	a5,a5,s1
    80005c48:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005c4c:	fc042783          	lw	a5,-64(s0)
    80005c50:	07f1                	add	a5,a5,28
    80005c52:	078e                	sll	a5,a5,0x3
    80005c54:	94be                	add	s1,s1,a5
    80005c56:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005c5a:	fd043503          	ld	a0,-48(s0)
    80005c5e:	fffff097          	auipc	ra,0xfffff
    80005c62:	a30080e7          	jalr	-1488(ra) # 8000468e <fileclose>
    fileclose(wf);
    80005c66:	fc843503          	ld	a0,-56(s0)
    80005c6a:	fffff097          	auipc	ra,0xfffff
    80005c6e:	a24080e7          	jalr	-1500(ra) # 8000468e <fileclose>
    return -1;
    80005c72:	57fd                	li	a5,-1
    80005c74:	a03d                	j	80005ca2 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005c76:	fc442783          	lw	a5,-60(s0)
    80005c7a:	0007c763          	bltz	a5,80005c88 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005c7e:	07f1                	add	a5,a5,28
    80005c80:	078e                	sll	a5,a5,0x3
    80005c82:	97a6                	add	a5,a5,s1
    80005c84:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005c88:	fd043503          	ld	a0,-48(s0)
    80005c8c:	fffff097          	auipc	ra,0xfffff
    80005c90:	a02080e7          	jalr	-1534(ra) # 8000468e <fileclose>
    fileclose(wf);
    80005c94:	fc843503          	ld	a0,-56(s0)
    80005c98:	fffff097          	auipc	ra,0xfffff
    80005c9c:	9f6080e7          	jalr	-1546(ra) # 8000468e <fileclose>
    return -1;
    80005ca0:	57fd                	li	a5,-1
}
    80005ca2:	853e                	mv	a0,a5
    80005ca4:	70e2                	ld	ra,56(sp)
    80005ca6:	7442                	ld	s0,48(sp)
    80005ca8:	74a2                	ld	s1,40(sp)
    80005caa:	6121                	add	sp,sp,64
    80005cac:	8082                	ret
	...

0000000080005cb0 <kernelvec>:
    80005cb0:	7111                	add	sp,sp,-256
    80005cb2:	e006                	sd	ra,0(sp)
    80005cb4:	e40a                	sd	sp,8(sp)
    80005cb6:	e80e                	sd	gp,16(sp)
    80005cb8:	ec12                	sd	tp,24(sp)
    80005cba:	f016                	sd	t0,32(sp)
    80005cbc:	f41a                	sd	t1,40(sp)
    80005cbe:	f81e                	sd	t2,48(sp)
    80005cc0:	e4aa                	sd	a0,72(sp)
    80005cc2:	e8ae                	sd	a1,80(sp)
    80005cc4:	ecb2                	sd	a2,88(sp)
    80005cc6:	f0b6                	sd	a3,96(sp)
    80005cc8:	f4ba                	sd	a4,104(sp)
    80005cca:	f8be                	sd	a5,112(sp)
    80005ccc:	fcc2                	sd	a6,120(sp)
    80005cce:	e146                	sd	a7,128(sp)
    80005cd0:	edf2                	sd	t3,216(sp)
    80005cd2:	f1f6                	sd	t4,224(sp)
    80005cd4:	f5fa                	sd	t5,232(sp)
    80005cd6:	f9fe                	sd	t6,240(sp)
    80005cd8:	e2bfc0ef          	jal	80002b02 <kerneltrap>
    80005cdc:	6082                	ld	ra,0(sp)
    80005cde:	6122                	ld	sp,8(sp)
    80005ce0:	61c2                	ld	gp,16(sp)
    80005ce2:	7282                	ld	t0,32(sp)
    80005ce4:	7322                	ld	t1,40(sp)
    80005ce6:	73c2                	ld	t2,48(sp)
    80005ce8:	6526                	ld	a0,72(sp)
    80005cea:	65c6                	ld	a1,80(sp)
    80005cec:	6666                	ld	a2,88(sp)
    80005cee:	7686                	ld	a3,96(sp)
    80005cf0:	7726                	ld	a4,104(sp)
    80005cf2:	77c6                	ld	a5,112(sp)
    80005cf4:	7866                	ld	a6,120(sp)
    80005cf6:	688a                	ld	a7,128(sp)
    80005cf8:	6e6e                	ld	t3,216(sp)
    80005cfa:	7e8e                	ld	t4,224(sp)
    80005cfc:	7f2e                	ld	t5,232(sp)
    80005cfe:	7fce                	ld	t6,240(sp)
    80005d00:	6111                	add	sp,sp,256
    80005d02:	10200073          	sret
	...

0000000080005d0e <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    80005d0e:	1141                	add	sp,sp,-16
    80005d10:	e422                	sd	s0,8(sp)
    80005d12:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005d14:	0c0007b7          	lui	a5,0xc000
    80005d18:	4705                	li	a4,1
    80005d1a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005d1c:	c3d8                	sw	a4,4(a5)
}
    80005d1e:	6422                	ld	s0,8(sp)
    80005d20:	0141                	add	sp,sp,16
    80005d22:	8082                	ret

0000000080005d24 <plicinithart>:

void
plicinithart(void)
{
    80005d24:	1141                	add	sp,sp,-16
    80005d26:	e406                	sd	ra,8(sp)
    80005d28:	e022                	sd	s0,0(sp)
    80005d2a:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005d2c:	ffffc097          	auipc	ra,0xffffc
    80005d30:	dac080e7          	jalr	-596(ra) # 80001ad8 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d34:	0085171b          	sllw	a4,a0,0x8
    80005d38:	0c0027b7          	lui	a5,0xc002
    80005d3c:	97ba                	add	a5,a5,a4
    80005d3e:	40200713          	li	a4,1026
    80005d42:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005d46:	00d5151b          	sllw	a0,a0,0xd
    80005d4a:	0c2017b7          	lui	a5,0xc201
    80005d4e:	97aa                	add	a5,a5,a0
    80005d50:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005d54:	60a2                	ld	ra,8(sp)
    80005d56:	6402                	ld	s0,0(sp)
    80005d58:	0141                	add	sp,sp,16
    80005d5a:	8082                	ret

0000000080005d5c <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005d5c:	1141                	add	sp,sp,-16
    80005d5e:	e406                	sd	ra,8(sp)
    80005d60:	e022                	sd	s0,0(sp)
    80005d62:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005d64:	ffffc097          	auipc	ra,0xffffc
    80005d68:	d74080e7          	jalr	-652(ra) # 80001ad8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d6c:	00d5151b          	sllw	a0,a0,0xd
    80005d70:	0c2017b7          	lui	a5,0xc201
    80005d74:	97aa                	add	a5,a5,a0
  return irq;
}
    80005d76:	43c8                	lw	a0,4(a5)
    80005d78:	60a2                	ld	ra,8(sp)
    80005d7a:	6402                	ld	s0,0(sp)
    80005d7c:	0141                	add	sp,sp,16
    80005d7e:	8082                	ret

0000000080005d80 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    80005d80:	1101                	add	sp,sp,-32
    80005d82:	ec06                	sd	ra,24(sp)
    80005d84:	e822                	sd	s0,16(sp)
    80005d86:	e426                	sd	s1,8(sp)
    80005d88:	1000                	add	s0,sp,32
    80005d8a:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d8c:	ffffc097          	auipc	ra,0xffffc
    80005d90:	d4c080e7          	jalr	-692(ra) # 80001ad8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d94:	00d5151b          	sllw	a0,a0,0xd
    80005d98:	0c2017b7          	lui	a5,0xc201
    80005d9c:	97aa                	add	a5,a5,a0
    80005d9e:	c3c4                	sw	s1,4(a5)
}
    80005da0:	60e2                	ld	ra,24(sp)
    80005da2:	6442                	ld	s0,16(sp)
    80005da4:	64a2                	ld	s1,8(sp)
    80005da6:	6105                	add	sp,sp,32
    80005da8:	8082                	ret

0000000080005daa <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    80005daa:	1141                	add	sp,sp,-16
    80005dac:	e406                	sd	ra,8(sp)
    80005dae:	e022                	sd	s0,0(sp)
    80005db0:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005db2:	479d                	li	a5,7
    80005db4:	04a7cc63          	blt	a5,a0,80005e0c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005db8:	0001d797          	auipc	a5,0x1d
    80005dbc:	bc878793          	add	a5,a5,-1080 # 80022980 <disk>
    80005dc0:	97aa                	add	a5,a5,a0
    80005dc2:	0187c783          	lbu	a5,24(a5)
    80005dc6:	ebb9                	bnez	a5,80005e1c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005dc8:	00451693          	sll	a3,a0,0x4
    80005dcc:	0001d797          	auipc	a5,0x1d
    80005dd0:	bb478793          	add	a5,a5,-1100 # 80022980 <disk>
    80005dd4:	6398                	ld	a4,0(a5)
    80005dd6:	9736                	add	a4,a4,a3
    80005dd8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005ddc:	6398                	ld	a4,0(a5)
    80005dde:	9736                	add	a4,a4,a3
    80005de0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005de4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005de8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005dec:	97aa                	add	a5,a5,a0
    80005dee:	4705                	li	a4,1
    80005df0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005df4:	0001d517          	auipc	a0,0x1d
    80005df8:	ba450513          	add	a0,a0,-1116 # 80022998 <disk+0x18>
    80005dfc:	ffffc097          	auipc	ra,0xffffc
    80005e00:	4ca080e7          	jalr	1226(ra) # 800022c6 <wakeup>
}
    80005e04:	60a2                	ld	ra,8(sp)
    80005e06:	6402                	ld	s0,0(sp)
    80005e08:	0141                	add	sp,sp,16
    80005e0a:	8082                	ret
    panic("free_desc 1");
    80005e0c:	00003517          	auipc	a0,0x3
    80005e10:	97450513          	add	a0,a0,-1676 # 80008780 <syscalls+0x2f0>
    80005e14:	ffffb097          	auipc	ra,0xffffb
    80005e18:	9fa080e7          	jalr	-1542(ra) # 8000080e <panic>
    panic("free_desc 2");
    80005e1c:	00003517          	auipc	a0,0x3
    80005e20:	97450513          	add	a0,a0,-1676 # 80008790 <syscalls+0x300>
    80005e24:	ffffb097          	auipc	ra,0xffffb
    80005e28:	9ea080e7          	jalr	-1558(ra) # 8000080e <panic>

0000000080005e2c <virtio_disk_init>:
{
    80005e2c:	1101                	add	sp,sp,-32
    80005e2e:	ec06                	sd	ra,24(sp)
    80005e30:	e822                	sd	s0,16(sp)
    80005e32:	e426                	sd	s1,8(sp)
    80005e34:	e04a                	sd	s2,0(sp)
    80005e36:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e38:	00003597          	auipc	a1,0x3
    80005e3c:	96858593          	add	a1,a1,-1688 # 800087a0 <syscalls+0x310>
    80005e40:	0001d517          	auipc	a0,0x1d
    80005e44:	c6850513          	add	a0,a0,-920 # 80022aa8 <disk+0x128>
    80005e48:	ffffb097          	auipc	ra,0xffffb
    80005e4c:	df4080e7          	jalr	-524(ra) # 80000c3c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e50:	100017b7          	lui	a5,0x10001
    80005e54:	4398                	lw	a4,0(a5)
    80005e56:	2701                	sext.w	a4,a4
    80005e58:	747277b7          	lui	a5,0x74727
    80005e5c:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e60:	14f71b63          	bne	a4,a5,80005fb6 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e64:	100017b7          	lui	a5,0x10001
    80005e68:	43dc                	lw	a5,4(a5)
    80005e6a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e6c:	4709                	li	a4,2
    80005e6e:	14e79463          	bne	a5,a4,80005fb6 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e72:	100017b7          	lui	a5,0x10001
    80005e76:	479c                	lw	a5,8(a5)
    80005e78:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e7a:	12e79e63          	bne	a5,a4,80005fb6 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e7e:	100017b7          	lui	a5,0x10001
    80005e82:	47d8                	lw	a4,12(a5)
    80005e84:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e86:	554d47b7          	lui	a5,0x554d4
    80005e8a:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e8e:	12f71463          	bne	a4,a5,80005fb6 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e92:	100017b7          	lui	a5,0x10001
    80005e96:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e9a:	4705                	li	a4,1
    80005e9c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e9e:	470d                	li	a4,3
    80005ea0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005ea2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005ea4:	c7ffe6b7          	lui	a3,0xc7ffe
    80005ea8:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbc9f>
    80005eac:	8f75                	and	a4,a4,a3
    80005eae:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005eb0:	472d                	li	a4,11
    80005eb2:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005eb4:	5bbc                	lw	a5,112(a5)
    80005eb6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005eba:	8ba1                	and	a5,a5,8
    80005ebc:	10078563          	beqz	a5,80005fc6 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005ec0:	100017b7          	lui	a5,0x10001
    80005ec4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005ec8:	43fc                	lw	a5,68(a5)
    80005eca:	2781                	sext.w	a5,a5
    80005ecc:	10079563          	bnez	a5,80005fd6 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005ed0:	100017b7          	lui	a5,0x10001
    80005ed4:	5bdc                	lw	a5,52(a5)
    80005ed6:	2781                	sext.w	a5,a5
  if(max == 0)
    80005ed8:	10078763          	beqz	a5,80005fe6 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005edc:	471d                	li	a4,7
    80005ede:	10f77c63          	bgeu	a4,a5,80005ff6 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005ee2:	ffffb097          	auipc	ra,0xffffb
    80005ee6:	cfa080e7          	jalr	-774(ra) # 80000bdc <kalloc>
    80005eea:	0001d497          	auipc	s1,0x1d
    80005eee:	a9648493          	add	s1,s1,-1386 # 80022980 <disk>
    80005ef2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005ef4:	ffffb097          	auipc	ra,0xffffb
    80005ef8:	ce8080e7          	jalr	-792(ra) # 80000bdc <kalloc>
    80005efc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005efe:	ffffb097          	auipc	ra,0xffffb
    80005f02:	cde080e7          	jalr	-802(ra) # 80000bdc <kalloc>
    80005f06:	87aa                	mv	a5,a0
    80005f08:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005f0a:	6088                	ld	a0,0(s1)
    80005f0c:	cd6d                	beqz	a0,80006006 <virtio_disk_init+0x1da>
    80005f0e:	0001d717          	auipc	a4,0x1d
    80005f12:	a7a73703          	ld	a4,-1414(a4) # 80022988 <disk+0x8>
    80005f16:	cb65                	beqz	a4,80006006 <virtio_disk_init+0x1da>
    80005f18:	c7fd                	beqz	a5,80006006 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005f1a:	6605                	lui	a2,0x1
    80005f1c:	4581                	li	a1,0
    80005f1e:	ffffb097          	auipc	ra,0xffffb
    80005f22:	eaa080e7          	jalr	-342(ra) # 80000dc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005f26:	0001d497          	auipc	s1,0x1d
    80005f2a:	a5a48493          	add	s1,s1,-1446 # 80022980 <disk>
    80005f2e:	6605                	lui	a2,0x1
    80005f30:	4581                	li	a1,0
    80005f32:	6488                	ld	a0,8(s1)
    80005f34:	ffffb097          	auipc	ra,0xffffb
    80005f38:	e94080e7          	jalr	-364(ra) # 80000dc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005f3c:	6605                	lui	a2,0x1
    80005f3e:	4581                	li	a1,0
    80005f40:	6888                	ld	a0,16(s1)
    80005f42:	ffffb097          	auipc	ra,0xffffb
    80005f46:	e86080e7          	jalr	-378(ra) # 80000dc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f4a:	100017b7          	lui	a5,0x10001
    80005f4e:	4721                	li	a4,8
    80005f50:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005f52:	4098                	lw	a4,0(s1)
    80005f54:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005f58:	40d8                	lw	a4,4(s1)
    80005f5a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005f5e:	6498                	ld	a4,8(s1)
    80005f60:	0007069b          	sext.w	a3,a4
    80005f64:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005f68:	9701                	sra	a4,a4,0x20
    80005f6a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005f6e:	6898                	ld	a4,16(s1)
    80005f70:	0007069b          	sext.w	a3,a4
    80005f74:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005f78:	9701                	sra	a4,a4,0x20
    80005f7a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005f7e:	4705                	li	a4,1
    80005f80:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005f82:	00e48c23          	sb	a4,24(s1)
    80005f86:	00e48ca3          	sb	a4,25(s1)
    80005f8a:	00e48d23          	sb	a4,26(s1)
    80005f8e:	00e48da3          	sb	a4,27(s1)
    80005f92:	00e48e23          	sb	a4,28(s1)
    80005f96:	00e48ea3          	sb	a4,29(s1)
    80005f9a:	00e48f23          	sb	a4,30(s1)
    80005f9e:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005fa2:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fa6:	0727a823          	sw	s2,112(a5)
}
    80005faa:	60e2                	ld	ra,24(sp)
    80005fac:	6442                	ld	s0,16(sp)
    80005fae:	64a2                	ld	s1,8(sp)
    80005fb0:	6902                	ld	s2,0(sp)
    80005fb2:	6105                	add	sp,sp,32
    80005fb4:	8082                	ret
    panic("could not find virtio disk");
    80005fb6:	00002517          	auipc	a0,0x2
    80005fba:	7fa50513          	add	a0,a0,2042 # 800087b0 <syscalls+0x320>
    80005fbe:	ffffb097          	auipc	ra,0xffffb
    80005fc2:	850080e7          	jalr	-1968(ra) # 8000080e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005fc6:	00003517          	auipc	a0,0x3
    80005fca:	80a50513          	add	a0,a0,-2038 # 800087d0 <syscalls+0x340>
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	840080e7          	jalr	-1984(ra) # 8000080e <panic>
    panic("virtio disk should not be ready");
    80005fd6:	00003517          	auipc	a0,0x3
    80005fda:	81a50513          	add	a0,a0,-2022 # 800087f0 <syscalls+0x360>
    80005fde:	ffffb097          	auipc	ra,0xffffb
    80005fe2:	830080e7          	jalr	-2000(ra) # 8000080e <panic>
    panic("virtio disk has no queue 0");
    80005fe6:	00003517          	auipc	a0,0x3
    80005fea:	82a50513          	add	a0,a0,-2006 # 80008810 <syscalls+0x380>
    80005fee:	ffffb097          	auipc	ra,0xffffb
    80005ff2:	820080e7          	jalr	-2016(ra) # 8000080e <panic>
    panic("virtio disk max queue too short");
    80005ff6:	00003517          	auipc	a0,0x3
    80005ffa:	83a50513          	add	a0,a0,-1990 # 80008830 <syscalls+0x3a0>
    80005ffe:	ffffb097          	auipc	ra,0xffffb
    80006002:	810080e7          	jalr	-2032(ra) # 8000080e <panic>
    panic("virtio disk kalloc");
    80006006:	00003517          	auipc	a0,0x3
    8000600a:	84a50513          	add	a0,a0,-1974 # 80008850 <syscalls+0x3c0>
    8000600e:	ffffb097          	auipc	ra,0xffffb
    80006012:	800080e7          	jalr	-2048(ra) # 8000080e <panic>

0000000080006016 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006016:	7159                	add	sp,sp,-112
    80006018:	f486                	sd	ra,104(sp)
    8000601a:	f0a2                	sd	s0,96(sp)
    8000601c:	eca6                	sd	s1,88(sp)
    8000601e:	e8ca                	sd	s2,80(sp)
    80006020:	e4ce                	sd	s3,72(sp)
    80006022:	e0d2                	sd	s4,64(sp)
    80006024:	fc56                	sd	s5,56(sp)
    80006026:	f85a                	sd	s6,48(sp)
    80006028:	f45e                	sd	s7,40(sp)
    8000602a:	f062                	sd	s8,32(sp)
    8000602c:	ec66                	sd	s9,24(sp)
    8000602e:	e86a                	sd	s10,16(sp)
    80006030:	1880                	add	s0,sp,112
    80006032:	8a2a                	mv	s4,a0
    80006034:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006036:	00c52c83          	lw	s9,12(a0)
    8000603a:	001c9c9b          	sllw	s9,s9,0x1
    8000603e:	1c82                	sll	s9,s9,0x20
    80006040:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006044:	0001d517          	auipc	a0,0x1d
    80006048:	a6450513          	add	a0,a0,-1436 # 80022aa8 <disk+0x128>
    8000604c:	ffffb097          	auipc	ra,0xffffb
    80006050:	c80080e7          	jalr	-896(ra) # 80000ccc <acquire>
  for(int i = 0; i < 3; i++){
    80006054:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80006056:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006058:	0001db17          	auipc	s6,0x1d
    8000605c:	928b0b13          	add	s6,s6,-1752 # 80022980 <disk>
  for(int i = 0; i < 3; i++){
    80006060:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006062:	0001dc17          	auipc	s8,0x1d
    80006066:	a46c0c13          	add	s8,s8,-1466 # 80022aa8 <disk+0x128>
    8000606a:	a095                	j	800060ce <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000606c:	00fb0733          	add	a4,s6,a5
    80006070:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006074:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80006076:	0207c563          	bltz	a5,800060a0 <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    8000607a:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    8000607c:	0591                	add	a1,a1,4
    8000607e:	05560d63          	beq	a2,s5,800060d8 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006082:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80006084:	0001d717          	auipc	a4,0x1d
    80006088:	8fc70713          	add	a4,a4,-1796 # 80022980 <disk>
    8000608c:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000608e:	01874683          	lbu	a3,24(a4)
    80006092:	fee9                	bnez	a3,8000606c <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80006094:	2785                	addw	a5,a5,1
    80006096:	0705                	add	a4,a4,1
    80006098:	fe979be3          	bne	a5,s1,8000608e <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    8000609c:	57fd                	li	a5,-1
    8000609e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800060a0:	00c05e63          	blez	a2,800060bc <virtio_disk_rw+0xa6>
    800060a4:	060a                	sll	a2,a2,0x2
    800060a6:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800060aa:	0009a503          	lw	a0,0(s3)
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	cfc080e7          	jalr	-772(ra) # 80005daa <free_desc>
      for(int j = 0; j < i; j++)
    800060b6:	0991                	add	s3,s3,4
    800060b8:	ffa999e3          	bne	s3,s10,800060aa <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800060bc:	85e2                	mv	a1,s8
    800060be:	0001d517          	auipc	a0,0x1d
    800060c2:	8da50513          	add	a0,a0,-1830 # 80022998 <disk+0x18>
    800060c6:	ffffc097          	auipc	ra,0xffffc
    800060ca:	19c080e7          	jalr	412(ra) # 80002262 <sleep>
  for(int i = 0; i < 3; i++){
    800060ce:	f9040993          	add	s3,s0,-112
{
    800060d2:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800060d4:	864a                	mv	a2,s2
    800060d6:	b775                	j	80006082 <virtio_disk_rw+0x6c>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800060d8:	f9042503          	lw	a0,-112(s0)
    800060dc:	00a50713          	add	a4,a0,10
    800060e0:	0712                	sll	a4,a4,0x4

  if(write)
    800060e2:	0001d797          	auipc	a5,0x1d
    800060e6:	89e78793          	add	a5,a5,-1890 # 80022980 <disk>
    800060ea:	00e786b3          	add	a3,a5,a4
    800060ee:	01703633          	snez	a2,s7
    800060f2:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    800060f4:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800060f8:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800060fc:	f6070613          	add	a2,a4,-160
    80006100:	6394                	ld	a3,0(a5)
    80006102:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006104:	00870593          	add	a1,a4,8
    80006108:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000610a:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000610c:	0007b803          	ld	a6,0(a5)
    80006110:	9642                	add	a2,a2,a6
    80006112:	46c1                	li	a3,16
    80006114:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006116:	4585                	li	a1,1
    80006118:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    8000611c:	f9442683          	lw	a3,-108(s0)
    80006120:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006124:	0692                	sll	a3,a3,0x4
    80006126:	9836                	add	a6,a6,a3
    80006128:	058a0613          	add	a2,s4,88
    8000612c:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80006130:	0007b803          	ld	a6,0(a5)
    80006134:	96c2                	add	a3,a3,a6
    80006136:	40000613          	li	a2,1024
    8000613a:	c690                	sw	a2,8(a3)
  if(write)
    8000613c:	001bb613          	seqz	a2,s7
    80006140:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006144:	00166613          	or	a2,a2,1
    80006148:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000614c:	f9842603          	lw	a2,-104(s0)
    80006150:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    80006154:	00250693          	add	a3,a0,2
    80006158:	0692                	sll	a3,a3,0x4
    8000615a:	96be                	add	a3,a3,a5
    8000615c:	58fd                	li	a7,-1
    8000615e:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006162:	0612                	sll	a2,a2,0x4
    80006164:	9832                	add	a6,a6,a2
    80006166:	f9070713          	add	a4,a4,-112
    8000616a:	973e                	add	a4,a4,a5
    8000616c:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80006170:	6398                	ld	a4,0(a5)
    80006172:	9732                	add	a4,a4,a2
    80006174:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    80006176:	4609                	li	a2,2
    80006178:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    8000617c:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    80006180:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80006184:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006188:	6794                	ld	a3,8(a5)
    8000618a:	0026d703          	lhu	a4,2(a3)
    8000618e:	8b1d                	and	a4,a4,7
    80006190:	0706                	sll	a4,a4,0x1
    80006192:	96ba                	add	a3,a3,a4
    80006194:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006198:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    8000619c:	6798                	ld	a4,8(a5)
    8000619e:	00275783          	lhu	a5,2(a4)
    800061a2:	2785                	addw	a5,a5,1
    800061a4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800061a8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    800061ac:	100017b7          	lui	a5,0x10001
    800061b0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    800061b4:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800061b8:	0001d917          	auipc	s2,0x1d
    800061bc:	8f090913          	add	s2,s2,-1808 # 80022aa8 <disk+0x128>
  while(b->disk == 1) {
    800061c0:	4485                	li	s1,1
    800061c2:	00b79c63          	bne	a5,a1,800061da <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800061c6:	85ca                	mv	a1,s2
    800061c8:	8552                	mv	a0,s4
    800061ca:	ffffc097          	auipc	ra,0xffffc
    800061ce:	098080e7          	jalr	152(ra) # 80002262 <sleep>
  while(b->disk == 1) {
    800061d2:	004a2783          	lw	a5,4(s4)
    800061d6:	fe9788e3          	beq	a5,s1,800061c6 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800061da:	f9042903          	lw	s2,-112(s0)
    800061de:	00290713          	add	a4,s2,2
    800061e2:	0712                	sll	a4,a4,0x4
    800061e4:	0001c797          	auipc	a5,0x1c
    800061e8:	79c78793          	add	a5,a5,1948 # 80022980 <disk>
    800061ec:	97ba                	add	a5,a5,a4
    800061ee:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800061f2:	0001c997          	auipc	s3,0x1c
    800061f6:	78e98993          	add	s3,s3,1934 # 80022980 <disk>
    800061fa:	00491713          	sll	a4,s2,0x4
    800061fe:	0009b783          	ld	a5,0(s3)
    80006202:	97ba                	add	a5,a5,a4
    80006204:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006208:	854a                	mv	a0,s2
    8000620a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	b9c080e7          	jalr	-1124(ra) # 80005daa <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006216:	8885                	and	s1,s1,1
    80006218:	f0ed                	bnez	s1,800061fa <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000621a:	0001d517          	auipc	a0,0x1d
    8000621e:	88e50513          	add	a0,a0,-1906 # 80022aa8 <disk+0x128>
    80006222:	ffffb097          	auipc	ra,0xffffb
    80006226:	b5e080e7          	jalr	-1186(ra) # 80000d80 <release>
}
    8000622a:	70a6                	ld	ra,104(sp)
    8000622c:	7406                	ld	s0,96(sp)
    8000622e:	64e6                	ld	s1,88(sp)
    80006230:	6946                	ld	s2,80(sp)
    80006232:	69a6                	ld	s3,72(sp)
    80006234:	6a06                	ld	s4,64(sp)
    80006236:	7ae2                	ld	s5,56(sp)
    80006238:	7b42                	ld	s6,48(sp)
    8000623a:	7ba2                	ld	s7,40(sp)
    8000623c:	7c02                	ld	s8,32(sp)
    8000623e:	6ce2                	ld	s9,24(sp)
    80006240:	6d42                	ld	s10,16(sp)
    80006242:	6165                	add	sp,sp,112
    80006244:	8082                	ret

0000000080006246 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006246:	1101                	add	sp,sp,-32
    80006248:	ec06                	sd	ra,24(sp)
    8000624a:	e822                	sd	s0,16(sp)
    8000624c:	e426                	sd	s1,8(sp)
    8000624e:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006250:	0001c497          	auipc	s1,0x1c
    80006254:	73048493          	add	s1,s1,1840 # 80022980 <disk>
    80006258:	0001d517          	auipc	a0,0x1d
    8000625c:	85050513          	add	a0,a0,-1968 # 80022aa8 <disk+0x128>
    80006260:	ffffb097          	auipc	ra,0xffffb
    80006264:	a6c080e7          	jalr	-1428(ra) # 80000ccc <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006268:	10001737          	lui	a4,0x10001
    8000626c:	533c                	lw	a5,96(a4)
    8000626e:	8b8d                	and	a5,a5,3
    80006270:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006272:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    80006276:	689c                	ld	a5,16(s1)
    80006278:	0204d703          	lhu	a4,32(s1)
    8000627c:	0027d783          	lhu	a5,2(a5)
    80006280:	04f70863          	beq	a4,a5,800062d0 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006284:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006288:	6898                	ld	a4,16(s1)
    8000628a:	0204d783          	lhu	a5,32(s1)
    8000628e:	8b9d                	and	a5,a5,7
    80006290:	078e                	sll	a5,a5,0x3
    80006292:	97ba                	add	a5,a5,a4
    80006294:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006296:	00278713          	add	a4,a5,2
    8000629a:	0712                	sll	a4,a4,0x4
    8000629c:	9726                	add	a4,a4,s1
    8000629e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800062a2:	e721                	bnez	a4,800062ea <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800062a4:	0789                	add	a5,a5,2
    800062a6:	0792                	sll	a5,a5,0x4
    800062a8:	97a6                	add	a5,a5,s1
    800062aa:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    800062ac:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800062b0:	ffffc097          	auipc	ra,0xffffc
    800062b4:	016080e7          	jalr	22(ra) # 800022c6 <wakeup>

    disk.used_idx += 1;
    800062b8:	0204d783          	lhu	a5,32(s1)
    800062bc:	2785                	addw	a5,a5,1
    800062be:	17c2                	sll	a5,a5,0x30
    800062c0:	93c1                	srl	a5,a5,0x30
    800062c2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800062c6:	6898                	ld	a4,16(s1)
    800062c8:	00275703          	lhu	a4,2(a4)
    800062cc:	faf71ce3          	bne	a4,a5,80006284 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800062d0:	0001c517          	auipc	a0,0x1c
    800062d4:	7d850513          	add	a0,a0,2008 # 80022aa8 <disk+0x128>
    800062d8:	ffffb097          	auipc	ra,0xffffb
    800062dc:	aa8080e7          	jalr	-1368(ra) # 80000d80 <release>
}
    800062e0:	60e2                	ld	ra,24(sp)
    800062e2:	6442                	ld	s0,16(sp)
    800062e4:	64a2                	ld	s1,8(sp)
    800062e6:	6105                	add	sp,sp,32
    800062e8:	8082                	ret
      panic("virtio_disk_intr status");
    800062ea:	00002517          	auipc	a0,0x2
    800062ee:	57e50513          	add	a0,a0,1406 # 80008868 <syscalls+0x3d8>
    800062f2:	ffffa097          	auipc	ra,0xffffa
    800062f6:	51c080e7          	jalr	1308(ra) # 8000080e <panic>
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
