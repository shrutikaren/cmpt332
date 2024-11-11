
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc9bf>
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
    80000102:	530080e7          	jalr	1328(ra) # 8000262e <either_copyin>
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
    8000018c:	97c080e7          	jalr	-1668(ra) # 80001b04 <myproc>
    80000190:	00002097          	auipc	ra,0x2
    80000194:	2e8080e7          	jalr	744(ra) # 80002478 <killed>
    80000198:	ed2d                	bnez	a0,80000212 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    8000019a:	85a6                	mv	a1,s1
    8000019c:	854a                	mv	a0,s2
    8000019e:	00002097          	auipc	ra,0x2
    800001a2:	032080e7          	jalr	50(ra) # 800021d0 <sleep>
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
    800001e8:	3f4080e7          	jalr	1012(ra) # 800025d8 <either_copyout>
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
    800002c6:	3c2080e7          	jalr	962(ra) # 80002684 <procdump>
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
    8000041a:	e1e080e7          	jalr	-482(ra) # 80002234 <wakeup>
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
    8000044c:	86078793          	add	a5,a5,-1952 # 80020ca8 <devsw>
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
    8000097e:	8ba080e7          	jalr	-1862(ra) # 80002234 <wakeup>
    
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
    80000a18:	7bc080e7          	jalr	1980(ra) # 800021d0 <sleep>
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
    80000af6:	34e78793          	add	a5,a5,846 # 80021e40 <end>
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
    80000bc8:	27c50513          	add	a0,a0,636 # 80021e40 <end>
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
    80000e3c:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd1c1>
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
    80000fb6:	814080e7          	jalr	-2028(ra) # 800027c6 <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	cda080e7          	jalr	-806(ra) # 80005c94 <plicinithart>
  }

  scheduler();        
    80000fc2:	00001097          	auipc	ra,0x1
    80000fc6:	03c080e7          	jalr	60(ra) # 80001ffe <scheduler>
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
    8000102e:	774080e7          	jalr	1908(ra) # 8000279e <trapinit>
    trapinithart();  /* install kernel trap vector */
    80001032:	00001097          	auipc	ra,0x1
    80001036:	794080e7          	jalr	1940(ra) # 800027c6 <trapinithart>
    plicinit();      /* set up interrupt controller */
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	c44080e7          	jalr	-956(ra) # 80005c7e <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80001042:	00005097          	auipc	ra,0x5
    80001046:	c52080e7          	jalr	-942(ra) # 80005c94 <plicinithart>
    binit();         /* buffer cache */
    8000104a:	00002097          	auipc	ra,0x2
    8000104e:	eaa080e7          	jalr	-342(ra) # 80002ef4 <binit>
    iinit();         /* inode table */
    80001052:	00002097          	auipc	ra,0x2
    80001056:	548080e7          	jalr	1352(ra) # 8000359a <iinit>
    fileinit();      /* file table */
    8000105a:	00003097          	auipc	ra,0x3
    8000105e:	4be080e7          	jalr	1214(ra) # 80004518 <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80001062:	00005097          	auipc	ra,0x5
    80001066:	d3a080e7          	jalr	-710(ra) # 80005d9c <virtio_disk_init>
    userinit();      /* first user process */
    8000106a:	00001097          	auipc	ra,0x1
    8000106e:	d76080e7          	jalr	-650(ra) # 80001de0 <userinit>
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
    8000110a:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd1b7>
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
    80001966:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffdd1bf>
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
    800019b6:	0aea0a13          	add	s4,s4,174 # 80016a60 <tickslock>
    char *pa = kalloc();
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	222080e7          	jalr	546(ra) # 80000bdc <kalloc>
    800019c2:	862a                	mv	a2,a0
    if(pa == 0)
    800019c4:	c131                	beqz	a0,80001a08 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800019c6:	416485b3          	sub	a1,s1,s6
    800019ca:	8591                	sra	a1,a1,0x4
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
    800019ec:	17048493          	add	s1,s1,368
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
    80001a82:	fe298993          	add	s3,s3,-30 # 80016a60 <tickslock>
      initlock(&p->lock, "proc");
    80001a86:	85da                	mv	a1,s6
    80001a88:	8526                	mv	a0,s1
    80001a8a:	fffff097          	auipc	ra,0xfffff
    80001a8e:	1b2080e7          	jalr	434(ra) # 80000c3c <initlock>
      p->state = UNUSED;
    80001a92:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001a96:	415487b3          	sub	a5,s1,s5
    80001a9a:	8791                	sra	a5,a5,0x4
    80001a9c:	000a3703          	ld	a4,0(s4)
    80001aa0:	02e787b3          	mul	a5,a5,a4
    80001aa4:	2785                	addw	a5,a5,1
    80001aa6:	00d7979b          	sllw	a5,a5,0xd
    80001aaa:	40f907b3          	sub	a5,s2,a5
    80001aae:	e4bc                	sd	a5,72(s1)
   
      /* CMPT 332 Group 01 Change, Fall 2024 */
      p->cpuShare = 0;
    80001ab0:	0204aa23          	sw	zero,52(s1)
      p->cpuUsage = 0;
    80001ab4:	0204ac23          	sw	zero,56(s1)
      p->lastRunTime = 0;
    80001ab8:	0204ae23          	sw	zero,60(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001abc:	17048493          	add	s1,s1,368
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
    80001aee:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001af0:	2781                	sext.w	a5,a5
    80001af2:	079e                	sll	a5,a5,0x7
  return c;
}
    80001af4:	0000f517          	auipc	a0,0xf
    80001af8:	f6c50513          	add	a0,a0,-148 # 80010a60 <cpus>
    80001afc:	953e                	add	a0,a0,a5
    80001afe:	6422                	ld	s0,8(sp)
    80001b00:	0141                	add	sp,sp,16
    80001b02:	8082                	ret

0000000080001b04 <myproc>:

/* Return the current struct proc *, or zero if none. */
struct proc*
myproc(void)
{
    80001b04:	1101                	add	sp,sp,-32
    80001b06:	ec06                	sd	ra,24(sp)
    80001b08:	e822                	sd	s0,16(sp)
    80001b0a:	e426                	sd	s1,8(sp)
    80001b0c:	1000                	add	s0,sp,32
  push_off();
    80001b0e:	fffff097          	auipc	ra,0xfffff
    80001b12:	172080e7          	jalr	370(ra) # 80000c80 <push_off>
    80001b16:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001b18:	2781                	sext.w	a5,a5
    80001b1a:	079e                	sll	a5,a5,0x7
    80001b1c:	0000f717          	auipc	a4,0xf
    80001b20:	f1470713          	add	a4,a4,-236 # 80010a30 <pid_lock>
    80001b24:	97ba                	add	a5,a5,a4
    80001b26:	7b84                	ld	s1,48(a5)
  pop_off();
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	1f8080e7          	jalr	504(ra) # 80000d20 <pop_off>
  return p;
}
    80001b30:	8526                	mv	a0,s1
    80001b32:	60e2                	ld	ra,24(sp)
    80001b34:	6442                	ld	s0,16(sp)
    80001b36:	64a2                	ld	s1,8(sp)
    80001b38:	6105                	add	sp,sp,32
    80001b3a:	8082                	ret

0000000080001b3c <forkret>:

/* A fork child's very first scheduling by scheduler() */
/* will swtch to forkret. */
void
forkret(void)
{
    80001b3c:	1141                	add	sp,sp,-16
    80001b3e:	e406                	sd	ra,8(sp)
    80001b40:	e022                	sd	s0,0(sp)
    80001b42:	0800                	add	s0,sp,16
  static int first = 1;

  /* Still holding p->lock from scheduler. */
  release(&myproc()->lock);
    80001b44:	00000097          	auipc	ra,0x0
    80001b48:	fc0080e7          	jalr	-64(ra) # 80001b04 <myproc>
    80001b4c:	fffff097          	auipc	ra,0xfffff
    80001b50:	234080e7          	jalr	564(ra) # 80000d80 <release>

  if (first) {
    80001b54:	00007797          	auipc	a5,0x7
    80001b58:	d2c7a783          	lw	a5,-724(a5) # 80008880 <first.1>
    80001b5c:	eb89                	bnez	a5,80001b6e <forkret+0x32>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    80001b5e:	00001097          	auipc	ra,0x1
    80001b62:	c80080e7          	jalr	-896(ra) # 800027de <usertrapret>
}
    80001b66:	60a2                	ld	ra,8(sp)
    80001b68:	6402                	ld	s0,0(sp)
    80001b6a:	0141                	add	sp,sp,16
    80001b6c:	8082                	ret
    fsinit(ROOTDEV);
    80001b6e:	4505                	li	a0,1
    80001b70:	00002097          	auipc	ra,0x2
    80001b74:	9aa080e7          	jalr	-1622(ra) # 8000351a <fsinit>
    first = 0;
    80001b78:	00007797          	auipc	a5,0x7
    80001b7c:	d007a423          	sw	zero,-760(a5) # 80008880 <first.1>
    __sync_synchronize();
    80001b80:	0ff0000f          	fence
    80001b84:	bfe9                	j	80001b5e <forkret+0x22>

0000000080001b86 <allocpid>:
{
    80001b86:	1101                	add	sp,sp,-32
    80001b88:	ec06                	sd	ra,24(sp)
    80001b8a:	e822                	sd	s0,16(sp)
    80001b8c:	e426                	sd	s1,8(sp)
    80001b8e:	e04a                	sd	s2,0(sp)
    80001b90:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001b92:	0000f917          	auipc	s2,0xf
    80001b96:	e9e90913          	add	s2,s2,-354 # 80010a30 <pid_lock>
    80001b9a:	854a                	mv	a0,s2
    80001b9c:	fffff097          	auipc	ra,0xfffff
    80001ba0:	130080e7          	jalr	304(ra) # 80000ccc <acquire>
  pid = nextpid;
    80001ba4:	00007797          	auipc	a5,0x7
    80001ba8:	ce078793          	add	a5,a5,-800 # 80008884 <nextpid>
    80001bac:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001bae:	0014871b          	addw	a4,s1,1
    80001bb2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001bb4:	854a                	mv	a0,s2
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	1ca080e7          	jalr	458(ra) # 80000d80 <release>
}
    80001bbe:	8526                	mv	a0,s1
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6902                	ld	s2,0(sp)
    80001bc8:	6105                	add	sp,sp,32
    80001bca:	8082                	ret

0000000080001bcc <proc_pagetable>:
{
    80001bcc:	1101                	add	sp,sp,-32
    80001bce:	ec06                	sd	ra,24(sp)
    80001bd0:	e822                	sd	s0,16(sp)
    80001bd2:	e426                	sd	s1,8(sp)
    80001bd4:	e04a                	sd	s2,0(sp)
    80001bd6:	1000                	add	s0,sp,32
    80001bd8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001bda:	00000097          	auipc	ra,0x0
    80001bde:	866080e7          	jalr	-1946(ra) # 80001440 <uvmcreate>
    80001be2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001be4:	c121                	beqz	a0,80001c24 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001be6:	4729                	li	a4,10
    80001be8:	00005697          	auipc	a3,0x5
    80001bec:	41868693          	add	a3,a3,1048 # 80007000 <_trampoline>
    80001bf0:	6605                	lui	a2,0x1
    80001bf2:	040005b7          	lui	a1,0x4000
    80001bf6:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bf8:	05b2                	sll	a1,a1,0xc
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	598080e7          	jalr	1432(ra) # 80001192 <mappages>
    80001c02:	02054863          	bltz	a0,80001c32 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c06:	4719                	li	a4,6
    80001c08:	06093683          	ld	a3,96(s2)
    80001c0c:	6605                	lui	a2,0x1
    80001c0e:	020005b7          	lui	a1,0x2000
    80001c12:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c14:	05b6                	sll	a1,a1,0xd
    80001c16:	8526                	mv	a0,s1
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	57a080e7          	jalr	1402(ra) # 80001192 <mappages>
    80001c20:	02054163          	bltz	a0,80001c42 <proc_pagetable+0x76>
}
    80001c24:	8526                	mv	a0,s1
    80001c26:	60e2                	ld	ra,24(sp)
    80001c28:	6442                	ld	s0,16(sp)
    80001c2a:	64a2                	ld	s1,8(sp)
    80001c2c:	6902                	ld	s2,0(sp)
    80001c2e:	6105                	add	sp,sp,32
    80001c30:	8082                	ret
    uvmfree(pagetable, 0);
    80001c32:	4581                	li	a1,0
    80001c34:	8526                	mv	a0,s1
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	a10080e7          	jalr	-1520(ra) # 80001646 <uvmfree>
    return 0;
    80001c3e:	4481                	li	s1,0
    80001c40:	b7d5                	j	80001c24 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c42:	4681                	li	a3,0
    80001c44:	4605                	li	a2,1
    80001c46:	040005b7          	lui	a1,0x4000
    80001c4a:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c4c:	05b2                	sll	a1,a1,0xc
    80001c4e:	8526                	mv	a0,s1
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	72c080e7          	jalr	1836(ra) # 8000137c <uvmunmap>
    uvmfree(pagetable, 0);
    80001c58:	4581                	li	a1,0
    80001c5a:	8526                	mv	a0,s1
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	9ea080e7          	jalr	-1558(ra) # 80001646 <uvmfree>
    return 0;
    80001c64:	4481                	li	s1,0
    80001c66:	bf7d                	j	80001c24 <proc_pagetable+0x58>

0000000080001c68 <proc_freepagetable>:
{
    80001c68:	1101                	add	sp,sp,-32
    80001c6a:	ec06                	sd	ra,24(sp)
    80001c6c:	e822                	sd	s0,16(sp)
    80001c6e:	e426                	sd	s1,8(sp)
    80001c70:	e04a                	sd	s2,0(sp)
    80001c72:	1000                	add	s0,sp,32
    80001c74:	84aa                	mv	s1,a0
    80001c76:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c78:	4681                	li	a3,0
    80001c7a:	4605                	li	a2,1
    80001c7c:	040005b7          	lui	a1,0x4000
    80001c80:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c82:	05b2                	sll	a1,a1,0xc
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	6f8080e7          	jalr	1784(ra) # 8000137c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c8c:	4681                	li	a3,0
    80001c8e:	4605                	li	a2,1
    80001c90:	020005b7          	lui	a1,0x2000
    80001c94:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c96:	05b6                	sll	a1,a1,0xd
    80001c98:	8526                	mv	a0,s1
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	6e2080e7          	jalr	1762(ra) # 8000137c <uvmunmap>
  uvmfree(pagetable, sz);
    80001ca2:	85ca                	mv	a1,s2
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	9a0080e7          	jalr	-1632(ra) # 80001646 <uvmfree>
}
    80001cae:	60e2                	ld	ra,24(sp)
    80001cb0:	6442                	ld	s0,16(sp)
    80001cb2:	64a2                	ld	s1,8(sp)
    80001cb4:	6902                	ld	s2,0(sp)
    80001cb6:	6105                	add	sp,sp,32
    80001cb8:	8082                	ret

0000000080001cba <freeproc>:
{
    80001cba:	1101                	add	sp,sp,-32
    80001cbc:	ec06                	sd	ra,24(sp)
    80001cbe:	e822                	sd	s0,16(sp)
    80001cc0:	e426                	sd	s1,8(sp)
    80001cc2:	1000                	add	s0,sp,32
    80001cc4:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001cc6:	7128                	ld	a0,96(a0)
    80001cc8:	c509                	beqz	a0,80001cd2 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001cca:	fffff097          	auipc	ra,0xfffff
    80001cce:	e14080e7          	jalr	-492(ra) # 80000ade <kfree>
  p->trapframe = 0;
    80001cd2:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001cd6:	6ca8                	ld	a0,88(s1)
    80001cd8:	c511                	beqz	a0,80001ce4 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001cda:	68ac                	ld	a1,80(s1)
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	f8c080e7          	jalr	-116(ra) # 80001c68 <proc_freepagetable>
  p->pagetable = 0;
    80001ce4:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001ce8:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001cec:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001cf0:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001cf4:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001cf8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001cfc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001d00:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001d04:	0004ac23          	sw	zero,24(s1)
}
    80001d08:	60e2                	ld	ra,24(sp)
    80001d0a:	6442                	ld	s0,16(sp)
    80001d0c:	64a2                	ld	s1,8(sp)
    80001d0e:	6105                	add	sp,sp,32
    80001d10:	8082                	ret

0000000080001d12 <allocproc>:
{
    80001d12:	1101                	add	sp,sp,-32
    80001d14:	ec06                	sd	ra,24(sp)
    80001d16:	e822                	sd	s0,16(sp)
    80001d18:	e426                	sd	s1,8(sp)
    80001d1a:	e04a                	sd	s2,0(sp)
    80001d1c:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d1e:	0000f497          	auipc	s1,0xf
    80001d22:	14248493          	add	s1,s1,322 # 80010e60 <proc>
    80001d26:	00015917          	auipc	s2,0x15
    80001d2a:	d3a90913          	add	s2,s2,-710 # 80016a60 <tickslock>
    acquire(&p->lock);
    80001d2e:	8526                	mv	a0,s1
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	f9c080e7          	jalr	-100(ra) # 80000ccc <acquire>
    if(p->state == UNUSED) {
    80001d38:	4c9c                	lw	a5,24(s1)
    80001d3a:	cf81                	beqz	a5,80001d52 <allocproc+0x40>
      release(&p->lock);
    80001d3c:	8526                	mv	a0,s1
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	042080e7          	jalr	66(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d46:	17048493          	add	s1,s1,368
    80001d4a:	ff2492e3          	bne	s1,s2,80001d2e <allocproc+0x1c>
  return 0;
    80001d4e:	4481                	li	s1,0
    80001d50:	a889                	j	80001da2 <allocproc+0x90>
  p->pid = allocpid();
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	e34080e7          	jalr	-460(ra) # 80001b86 <allocpid>
    80001d5a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d5c:	4785                	li	a5,1
    80001d5e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	e7c080e7          	jalr	-388(ra) # 80000bdc <kalloc>
    80001d68:	892a                	mv	s2,a0
    80001d6a:	f0a8                	sd	a0,96(s1)
    80001d6c:	c131                	beqz	a0,80001db0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001d6e:	8526                	mv	a0,s1
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	e5c080e7          	jalr	-420(ra) # 80001bcc <proc_pagetable>
    80001d78:	892a                	mv	s2,a0
    80001d7a:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001d7c:	c531                	beqz	a0,80001dc8 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001d7e:	07000613          	li	a2,112
    80001d82:	4581                	li	a1,0
    80001d84:	06848513          	add	a0,s1,104
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	040080e7          	jalr	64(ra) # 80000dc8 <memset>
  p->context.ra = (uint64)forkret;
    80001d90:	00000797          	auipc	a5,0x0
    80001d94:	dac78793          	add	a5,a5,-596 # 80001b3c <forkret>
    80001d98:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d9a:	64bc                	ld	a5,72(s1)
    80001d9c:	6705                	lui	a4,0x1
    80001d9e:	97ba                	add	a5,a5,a4
    80001da0:	f8bc                	sd	a5,112(s1)
}
    80001da2:	8526                	mv	a0,s1
    80001da4:	60e2                	ld	ra,24(sp)
    80001da6:	6442                	ld	s0,16(sp)
    80001da8:	64a2                	ld	s1,8(sp)
    80001daa:	6902                	ld	s2,0(sp)
    80001dac:	6105                	add	sp,sp,32
    80001dae:	8082                	ret
    freeproc(p);
    80001db0:	8526                	mv	a0,s1
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	f08080e7          	jalr	-248(ra) # 80001cba <freeproc>
    release(&p->lock);
    80001dba:	8526                	mv	a0,s1
    80001dbc:	fffff097          	auipc	ra,0xfffff
    80001dc0:	fc4080e7          	jalr	-60(ra) # 80000d80 <release>
    return 0;
    80001dc4:	84ca                	mv	s1,s2
    80001dc6:	bff1                	j	80001da2 <allocproc+0x90>
    freeproc(p);
    80001dc8:	8526                	mv	a0,s1
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	ef0080e7          	jalr	-272(ra) # 80001cba <freeproc>
    release(&p->lock);
    80001dd2:	8526                	mv	a0,s1
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	fac080e7          	jalr	-84(ra) # 80000d80 <release>
    return 0;
    80001ddc:	84ca                	mv	s1,s2
    80001dde:	b7d1                	j	80001da2 <allocproc+0x90>

0000000080001de0 <userinit>:
{
    80001de0:	1101                	add	sp,sp,-32
    80001de2:	ec06                	sd	ra,24(sp)
    80001de4:	e822                	sd	s0,16(sp)
    80001de6:	e426                	sd	s1,8(sp)
    80001de8:	1000                	add	s0,sp,32
  p = allocproc();
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	f28080e7          	jalr	-216(ra) # 80001d12 <allocproc>
    80001df2:	84aa                	mv	s1,a0
  initproc = p;
    80001df4:	00007797          	auipc	a5,0x7
    80001df8:	b0a7b223          	sd	a0,-1276(a5) # 800088f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001dfc:	03400613          	li	a2,52
    80001e00:	00007597          	auipc	a1,0x7
    80001e04:	a9058593          	add	a1,a1,-1392 # 80008890 <initcode>
    80001e08:	6d28                	ld	a0,88(a0)
    80001e0a:	fffff097          	auipc	ra,0xfffff
    80001e0e:	664080e7          	jalr	1636(ra) # 8000146e <uvmfirst>
  p->sz = PGSIZE;
    80001e12:	6785                	lui	a5,0x1
    80001e14:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      /* user program counter */
    80001e16:	70b8                	ld	a4,96(s1)
    80001e18:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    80001e1c:	70b8                	ld	a4,96(s1)
    80001e1e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e20:	4641                	li	a2,16
    80001e22:	00006597          	auipc	a1,0x6
    80001e26:	41658593          	add	a1,a1,1046 # 80008238 <digits+0x200>
    80001e2a:	16048513          	add	a0,s1,352
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	0e2080e7          	jalr	226(ra) # 80000f10 <safestrcpy>
  p->cwd = namei("/");
    80001e36:	00006517          	auipc	a0,0x6
    80001e3a:	41250513          	add	a0,a0,1042 # 80008248 <digits+0x210>
    80001e3e:	00002097          	auipc	ra,0x2
    80001e42:	0fa080e7          	jalr	250(ra) # 80003f38 <namei>
    80001e46:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001e4a:	478d                	li	a5,3
    80001e4c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001e4e:	8526                	mv	a0,s1
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	f30080e7          	jalr	-208(ra) # 80000d80 <release>
}
    80001e58:	60e2                	ld	ra,24(sp)
    80001e5a:	6442                	ld	s0,16(sp)
    80001e5c:	64a2                	ld	s1,8(sp)
    80001e5e:	6105                	add	sp,sp,32
    80001e60:	8082                	ret

0000000080001e62 <growproc>:
{
    80001e62:	1101                	add	sp,sp,-32
    80001e64:	ec06                	sd	ra,24(sp)
    80001e66:	e822                	sd	s0,16(sp)
    80001e68:	e426                	sd	s1,8(sp)
    80001e6a:	e04a                	sd	s2,0(sp)
    80001e6c:	1000                	add	s0,sp,32
    80001e6e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001e70:	00000097          	auipc	ra,0x0
    80001e74:	c94080e7          	jalr	-876(ra) # 80001b04 <myproc>
    80001e78:	84aa                	mv	s1,a0
  sz = p->sz;
    80001e7a:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001e7c:	01204c63          	bgtz	s2,80001e94 <growproc+0x32>
  } else if(n < 0){
    80001e80:	02094663          	bltz	s2,80001eac <growproc+0x4a>
  p->sz = sz;
    80001e84:	e8ac                	sd	a1,80(s1)
  return 0;
    80001e86:	4501                	li	a0,0
}
    80001e88:	60e2                	ld	ra,24(sp)
    80001e8a:	6442                	ld	s0,16(sp)
    80001e8c:	64a2                	ld	s1,8(sp)
    80001e8e:	6902                	ld	s2,0(sp)
    80001e90:	6105                	add	sp,sp,32
    80001e92:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001e94:	4691                	li	a3,4
    80001e96:	00b90633          	add	a2,s2,a1
    80001e9a:	6d28                	ld	a0,88(a0)
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	68c080e7          	jalr	1676(ra) # 80001528 <uvmalloc>
    80001ea4:	85aa                	mv	a1,a0
    80001ea6:	fd79                	bnez	a0,80001e84 <growproc+0x22>
      return -1;
    80001ea8:	557d                	li	a0,-1
    80001eaa:	bff9                	j	80001e88 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001eac:	00b90633          	add	a2,s2,a1
    80001eb0:	6d28                	ld	a0,88(a0)
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	62e080e7          	jalr	1582(ra) # 800014e0 <uvmdealloc>
    80001eba:	85aa                	mv	a1,a0
    80001ebc:	b7e1                	j	80001e84 <growproc+0x22>

0000000080001ebe <fork>:
{
    80001ebe:	7139                	add	sp,sp,-64
    80001ec0:	fc06                	sd	ra,56(sp)
    80001ec2:	f822                	sd	s0,48(sp)
    80001ec4:	f426                	sd	s1,40(sp)
    80001ec6:	f04a                	sd	s2,32(sp)
    80001ec8:	ec4e                	sd	s3,24(sp)
    80001eca:	e852                	sd	s4,16(sp)
    80001ecc:	e456                	sd	s5,8(sp)
    80001ece:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001ed0:	00000097          	auipc	ra,0x0
    80001ed4:	c34080e7          	jalr	-972(ra) # 80001b04 <myproc>
    80001ed8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	e38080e7          	jalr	-456(ra) # 80001d12 <allocproc>
    80001ee2:	10050c63          	beqz	a0,80001ffa <fork+0x13c>
    80001ee6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ee8:	050ab603          	ld	a2,80(s5)
    80001eec:	6d2c                	ld	a1,88(a0)
    80001eee:	058ab503          	ld	a0,88(s5)
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	78e080e7          	jalr	1934(ra) # 80001680 <uvmcopy>
    80001efa:	04054863          	bltz	a0,80001f4a <fork+0x8c>
  np->sz = p->sz;
    80001efe:	050ab783          	ld	a5,80(s5)
    80001f02:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001f06:	060ab683          	ld	a3,96(s5)
    80001f0a:	87b6                	mv	a5,a3
    80001f0c:	060a3703          	ld	a4,96(s4)
    80001f10:	12068693          	add	a3,a3,288
    80001f14:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f18:	6788                	ld	a0,8(a5)
    80001f1a:	6b8c                	ld	a1,16(a5)
    80001f1c:	6f90                	ld	a2,24(a5)
    80001f1e:	01073023          	sd	a6,0(a4)
    80001f22:	e708                	sd	a0,8(a4)
    80001f24:	eb0c                	sd	a1,16(a4)
    80001f26:	ef10                	sd	a2,24(a4)
    80001f28:	02078793          	add	a5,a5,32
    80001f2c:	02070713          	add	a4,a4,32
    80001f30:	fed792e3          	bne	a5,a3,80001f14 <fork+0x56>
  np->trapframe->a0 = 0;
    80001f34:	060a3783          	ld	a5,96(s4)
    80001f38:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001f3c:	0d8a8493          	add	s1,s5,216
    80001f40:	0d8a0913          	add	s2,s4,216
    80001f44:	158a8993          	add	s3,s5,344
    80001f48:	a00d                	j	80001f6a <fork+0xac>
    freeproc(np);
    80001f4a:	8552                	mv	a0,s4
    80001f4c:	00000097          	auipc	ra,0x0
    80001f50:	d6e080e7          	jalr	-658(ra) # 80001cba <freeproc>
    release(&np->lock);
    80001f54:	8552                	mv	a0,s4
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	e2a080e7          	jalr	-470(ra) # 80000d80 <release>
    return -1;
    80001f5e:	597d                	li	s2,-1
    80001f60:	a059                	j	80001fe6 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001f62:	04a1                	add	s1,s1,8
    80001f64:	0921                	add	s2,s2,8
    80001f66:	01348b63          	beq	s1,s3,80001f7c <fork+0xbe>
    if(p->ofile[i])
    80001f6a:	6088                	ld	a0,0(s1)
    80001f6c:	d97d                	beqz	a0,80001f62 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f6e:	00002097          	auipc	ra,0x2
    80001f72:	63c080e7          	jalr	1596(ra) # 800045aa <filedup>
    80001f76:	00a93023          	sd	a0,0(s2)
    80001f7a:	b7e5                	j	80001f62 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001f7c:	158ab503          	ld	a0,344(s5)
    80001f80:	00001097          	auipc	ra,0x1
    80001f84:	7d4080e7          	jalr	2004(ra) # 80003754 <idup>
    80001f88:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f8c:	4641                	li	a2,16
    80001f8e:	160a8593          	add	a1,s5,352
    80001f92:	160a0513          	add	a0,s4,352
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	f7a080e7          	jalr	-134(ra) # 80000f10 <safestrcpy>
  pid = np->pid;
    80001f9e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001fa2:	8552                	mv	a0,s4
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	ddc080e7          	jalr	-548(ra) # 80000d80 <release>
  acquire(&wait_lock);
    80001fac:	0000f497          	auipc	s1,0xf
    80001fb0:	a9c48493          	add	s1,s1,-1380 # 80010a48 <wait_lock>
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	d16080e7          	jalr	-746(ra) # 80000ccc <acquire>
  np->parent = p;
    80001fbe:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001fc2:	8526                	mv	a0,s1
    80001fc4:	fffff097          	auipc	ra,0xfffff
    80001fc8:	dbc080e7          	jalr	-580(ra) # 80000d80 <release>
  acquire(&np->lock);
    80001fcc:	8552                	mv	a0,s4
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	cfe080e7          	jalr	-770(ra) # 80000ccc <acquire>
  np->state = RUNNABLE;
    80001fd6:	478d                	li	a5,3
    80001fd8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001fdc:	8552                	mv	a0,s4
    80001fde:	fffff097          	auipc	ra,0xfffff
    80001fe2:	da2080e7          	jalr	-606(ra) # 80000d80 <release>
}
    80001fe6:	854a                	mv	a0,s2
    80001fe8:	70e2                	ld	ra,56(sp)
    80001fea:	7442                	ld	s0,48(sp)
    80001fec:	74a2                	ld	s1,40(sp)
    80001fee:	7902                	ld	s2,32(sp)
    80001ff0:	69e2                	ld	s3,24(sp)
    80001ff2:	6a42                	ld	s4,16(sp)
    80001ff4:	6aa2                	ld	s5,8(sp)
    80001ff6:	6121                	add	sp,sp,64
    80001ff8:	8082                	ret
    return -1;
    80001ffa:	597d                	li	s2,-1
    80001ffc:	b7ed                	j	80001fe6 <fork+0x128>

0000000080001ffe <scheduler>:
{
    80001ffe:	715d                	add	sp,sp,-80
    80002000:	e486                	sd	ra,72(sp)
    80002002:	e0a2                	sd	s0,64(sp)
    80002004:	fc26                	sd	s1,56(sp)
    80002006:	f84a                	sd	s2,48(sp)
    80002008:	f44e                	sd	s3,40(sp)
    8000200a:	f052                	sd	s4,32(sp)
    8000200c:	ec56                	sd	s5,24(sp)
    8000200e:	e85a                	sd	s6,16(sp)
    80002010:	e45e                	sd	s7,8(sp)
    80002012:	e062                	sd	s8,0(sp)
    80002014:	0880                	add	s0,sp,80
    80002016:	8792                	mv	a5,tp
  int id = r_tp();
    80002018:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000201a:	00779b13          	sll	s6,a5,0x7
    8000201e:	0000f717          	auipc	a4,0xf
    80002022:	a1270713          	add	a4,a4,-1518 # 80010a30 <pid_lock>
    80002026:	975a                	add	a4,a4,s6
    80002028:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000202c:	0000f717          	auipc	a4,0xf
    80002030:	a3c70713          	add	a4,a4,-1476 # 80010a68 <cpus+0x8>
    80002034:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80002036:	4c11                	li	s8,4
        c->proc = p;
    80002038:	079e                	sll	a5,a5,0x7
    8000203a:	0000fa17          	auipc	s4,0xf
    8000203e:	9f6a0a13          	add	s4,s4,-1546 # 80010a30 <pid_lock>
    80002042:	9a3e                	add	s4,s4,a5
        found = 1;
    80002044:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80002046:	00015997          	auipc	s3,0x15
    8000204a:	a1a98993          	add	s3,s3,-1510 # 80016a60 <tickslock>
    8000204e:	a899                	j	800020a4 <scheduler+0xa6>
      release(&p->lock);
    80002050:	8526                	mv	a0,s1
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	d2e080e7          	jalr	-722(ra) # 80000d80 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000205a:	17048493          	add	s1,s1,368
    8000205e:	03348963          	beq	s1,s3,80002090 <scheduler+0x92>
      acquire(&p->lock);
    80002062:	8526                	mv	a0,s1
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	c68080e7          	jalr	-920(ra) # 80000ccc <acquire>
      if(p->state == RUNNABLE) {
    8000206c:	4c9c                	lw	a5,24(s1)
    8000206e:	ff2791e3          	bne	a5,s2,80002050 <scheduler+0x52>
        p->state = RUNNING;
    80002072:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80002076:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000207a:	06848593          	add	a1,s1,104
    8000207e:	855a                	mv	a0,s6
    80002080:	00000097          	auipc	ra,0x0
    80002084:	6b4080e7          	jalr	1716(ra) # 80002734 <swtch>
        c->proc = 0;
    80002088:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000208c:	8ade                	mv	s5,s7
    8000208e:	b7c9                	j	80002050 <scheduler+0x52>
    if(found == 0) {
    80002090:	000a9a63          	bnez	s5,800020a4 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002094:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002098:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000209c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800020a0:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020a8:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020ac:	10079073          	csrw	sstatus,a5
    int found = 0;
    800020b0:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800020b2:	0000f497          	auipc	s1,0xf
    800020b6:	dae48493          	add	s1,s1,-594 # 80010e60 <proc>
      if(p->state == RUNNABLE) {
    800020ba:	490d                	li	s2,3
    800020bc:	b75d                	j	80002062 <scheduler+0x64>

00000000800020be <sched>:
{
    800020be:	7179                	add	sp,sp,-48
    800020c0:	f406                	sd	ra,40(sp)
    800020c2:	f022                	sd	s0,32(sp)
    800020c4:	ec26                	sd	s1,24(sp)
    800020c6:	e84a                	sd	s2,16(sp)
    800020c8:	e44e                	sd	s3,8(sp)
    800020ca:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    800020cc:	00000097          	auipc	ra,0x0
    800020d0:	a38080e7          	jalr	-1480(ra) # 80001b04 <myproc>
    800020d4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	b7c080e7          	jalr	-1156(ra) # 80000c52 <holding>
    800020de:	c93d                	beqz	a0,80002154 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020e0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020e2:	2781                	sext.w	a5,a5
    800020e4:	079e                	sll	a5,a5,0x7
    800020e6:	0000f717          	auipc	a4,0xf
    800020ea:	94a70713          	add	a4,a4,-1718 # 80010a30 <pid_lock>
    800020ee:	97ba                	add	a5,a5,a4
    800020f0:	0a87a703          	lw	a4,168(a5)
    800020f4:	4785                	li	a5,1
    800020f6:	06f71763          	bne	a4,a5,80002164 <sched+0xa6>
  if(p->state == RUNNING)
    800020fa:	4c98                	lw	a4,24(s1)
    800020fc:	4791                	li	a5,4
    800020fe:	06f70b63          	beq	a4,a5,80002174 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002102:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002106:	8b89                	and	a5,a5,2
  if(intr_get())
    80002108:	efb5                	bnez	a5,80002184 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000210a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000210c:	0000f917          	auipc	s2,0xf
    80002110:	92490913          	add	s2,s2,-1756 # 80010a30 <pid_lock>
    80002114:	2781                	sext.w	a5,a5
    80002116:	079e                	sll	a5,a5,0x7
    80002118:	97ca                	add	a5,a5,s2
    8000211a:	0ac7a983          	lw	s3,172(a5)
    8000211e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002120:	2781                	sext.w	a5,a5
    80002122:	079e                	sll	a5,a5,0x7
    80002124:	0000f597          	auipc	a1,0xf
    80002128:	94458593          	add	a1,a1,-1724 # 80010a68 <cpus+0x8>
    8000212c:	95be                	add	a1,a1,a5
    8000212e:	06848513          	add	a0,s1,104
    80002132:	00000097          	auipc	ra,0x0
    80002136:	602080e7          	jalr	1538(ra) # 80002734 <swtch>
    8000213a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000213c:	2781                	sext.w	a5,a5
    8000213e:	079e                	sll	a5,a5,0x7
    80002140:	993e                	add	s2,s2,a5
    80002142:	0b392623          	sw	s3,172(s2)
}
    80002146:	70a2                	ld	ra,40(sp)
    80002148:	7402                	ld	s0,32(sp)
    8000214a:	64e2                	ld	s1,24(sp)
    8000214c:	6942                	ld	s2,16(sp)
    8000214e:	69a2                	ld	s3,8(sp)
    80002150:	6145                	add	sp,sp,48
    80002152:	8082                	ret
    panic("sched p->lock");
    80002154:	00006517          	auipc	a0,0x6
    80002158:	0fc50513          	add	a0,a0,252 # 80008250 <digits+0x218>
    8000215c:	ffffe097          	auipc	ra,0xffffe
    80002160:	6b2080e7          	jalr	1714(ra) # 8000080e <panic>
    panic("sched locks");
    80002164:	00006517          	auipc	a0,0x6
    80002168:	0fc50513          	add	a0,a0,252 # 80008260 <digits+0x228>
    8000216c:	ffffe097          	auipc	ra,0xffffe
    80002170:	6a2080e7          	jalr	1698(ra) # 8000080e <panic>
    panic("sched running");
    80002174:	00006517          	auipc	a0,0x6
    80002178:	0fc50513          	add	a0,a0,252 # 80008270 <digits+0x238>
    8000217c:	ffffe097          	auipc	ra,0xffffe
    80002180:	692080e7          	jalr	1682(ra) # 8000080e <panic>
    panic("sched interruptible");
    80002184:	00006517          	auipc	a0,0x6
    80002188:	0fc50513          	add	a0,a0,252 # 80008280 <digits+0x248>
    8000218c:	ffffe097          	auipc	ra,0xffffe
    80002190:	682080e7          	jalr	1666(ra) # 8000080e <panic>

0000000080002194 <yield>:
{
    80002194:	1101                	add	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	966080e7          	jalr	-1690(ra) # 80001b04 <myproc>
    800021a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	b24080e7          	jalr	-1244(ra) # 80000ccc <acquire>
  p->state = RUNNABLE;
    800021b0:	478d                	li	a5,3
    800021b2:	cc9c                	sw	a5,24(s1)
  sched();
    800021b4:	00000097          	auipc	ra,0x0
    800021b8:	f0a080e7          	jalr	-246(ra) # 800020be <sched>
  release(&p->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	bc2080e7          	jalr	-1086(ra) # 80000d80 <release>
}
    800021c6:	60e2                	ld	ra,24(sp)
    800021c8:	6442                	ld	s0,16(sp)
    800021ca:	64a2                	ld	s1,8(sp)
    800021cc:	6105                	add	sp,sp,32
    800021ce:	8082                	ret

00000000800021d0 <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    800021d0:	7179                	add	sp,sp,-48
    800021d2:	f406                	sd	ra,40(sp)
    800021d4:	f022                	sd	s0,32(sp)
    800021d6:	ec26                	sd	s1,24(sp)
    800021d8:	e84a                	sd	s2,16(sp)
    800021da:	e44e                	sd	s3,8(sp)
    800021dc:	1800                	add	s0,sp,48
    800021de:	89aa                	mv	s3,a0
    800021e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	922080e7          	jalr	-1758(ra) # 80001b04 <myproc>
    800021ea:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	ae0080e7          	jalr	-1312(ra) # 80000ccc <acquire>
  release(lk);
    800021f4:	854a                	mv	a0,s2
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	b8a080e7          	jalr	-1142(ra) # 80000d80 <release>

  /* Go to sleep. */
  p->chan = chan;
    800021fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002202:	4789                	li	a5,2
    80002204:	cc9c                	sw	a5,24(s1)

  sched();
    80002206:	00000097          	auipc	ra,0x0
    8000220a:	eb8080e7          	jalr	-328(ra) # 800020be <sched>

  /* Tidy up. */
  p->chan = 0;
    8000220e:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    80002212:	8526                	mv	a0,s1
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	b6c080e7          	jalr	-1172(ra) # 80000d80 <release>
  acquire(lk);
    8000221c:	854a                	mv	a0,s2
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	aae080e7          	jalr	-1362(ra) # 80000ccc <acquire>
}
    80002226:	70a2                	ld	ra,40(sp)
    80002228:	7402                	ld	s0,32(sp)
    8000222a:	64e2                	ld	s1,24(sp)
    8000222c:	6942                	ld	s2,16(sp)
    8000222e:	69a2                	ld	s3,8(sp)
    80002230:	6145                	add	sp,sp,48
    80002232:	8082                	ret

0000000080002234 <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    80002234:	7139                	add	sp,sp,-64
    80002236:	fc06                	sd	ra,56(sp)
    80002238:	f822                	sd	s0,48(sp)
    8000223a:	f426                	sd	s1,40(sp)
    8000223c:	f04a                	sd	s2,32(sp)
    8000223e:	ec4e                	sd	s3,24(sp)
    80002240:	e852                	sd	s4,16(sp)
    80002242:	e456                	sd	s5,8(sp)
    80002244:	0080                	add	s0,sp,64
    80002246:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002248:	0000f497          	auipc	s1,0xf
    8000224c:	c1848493          	add	s1,s1,-1000 # 80010e60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002250:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002252:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002254:	00015917          	auipc	s2,0x15
    80002258:	80c90913          	add	s2,s2,-2036 # 80016a60 <tickslock>
    8000225c:	a811                	j	80002270 <wakeup+0x3c>
      }
      release(&p->lock);
    8000225e:	8526                	mv	a0,s1
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	b20080e7          	jalr	-1248(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002268:	17048493          	add	s1,s1,368
    8000226c:	03248663          	beq	s1,s2,80002298 <wakeup+0x64>
    if(p != myproc()){
    80002270:	00000097          	auipc	ra,0x0
    80002274:	894080e7          	jalr	-1900(ra) # 80001b04 <myproc>
    80002278:	fea488e3          	beq	s1,a0,80002268 <wakeup+0x34>
      acquire(&p->lock);
    8000227c:	8526                	mv	a0,s1
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	a4e080e7          	jalr	-1458(ra) # 80000ccc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002286:	4c9c                	lw	a5,24(s1)
    80002288:	fd379be3          	bne	a5,s3,8000225e <wakeup+0x2a>
    8000228c:	709c                	ld	a5,32(s1)
    8000228e:	fd4798e3          	bne	a5,s4,8000225e <wakeup+0x2a>
        p->state = RUNNABLE;
    80002292:	0154ac23          	sw	s5,24(s1)
    80002296:	b7e1                	j	8000225e <wakeup+0x2a>
    }
  }
}
    80002298:	70e2                	ld	ra,56(sp)
    8000229a:	7442                	ld	s0,48(sp)
    8000229c:	74a2                	ld	s1,40(sp)
    8000229e:	7902                	ld	s2,32(sp)
    800022a0:	69e2                	ld	s3,24(sp)
    800022a2:	6a42                	ld	s4,16(sp)
    800022a4:	6aa2                	ld	s5,8(sp)
    800022a6:	6121                	add	sp,sp,64
    800022a8:	8082                	ret

00000000800022aa <reparent>:
{
    800022aa:	7179                	add	sp,sp,-48
    800022ac:	f406                	sd	ra,40(sp)
    800022ae:	f022                	sd	s0,32(sp)
    800022b0:	ec26                	sd	s1,24(sp)
    800022b2:	e84a                	sd	s2,16(sp)
    800022b4:	e44e                	sd	s3,8(sp)
    800022b6:	e052                	sd	s4,0(sp)
    800022b8:	1800                	add	s0,sp,48
    800022ba:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022bc:	0000f497          	auipc	s1,0xf
    800022c0:	ba448493          	add	s1,s1,-1116 # 80010e60 <proc>
      pp->parent = initproc;
    800022c4:	00006a17          	auipc	s4,0x6
    800022c8:	634a0a13          	add	s4,s4,1588 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022cc:	00014997          	auipc	s3,0x14
    800022d0:	79498993          	add	s3,s3,1940 # 80016a60 <tickslock>
    800022d4:	a029                	j	800022de <reparent+0x34>
    800022d6:	17048493          	add	s1,s1,368
    800022da:	01348d63          	beq	s1,s3,800022f4 <reparent+0x4a>
    if(pp->parent == p){
    800022de:	60bc                	ld	a5,64(s1)
    800022e0:	ff279be3          	bne	a5,s2,800022d6 <reparent+0x2c>
      pp->parent = initproc;
    800022e4:	000a3503          	ld	a0,0(s4)
    800022e8:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800022ea:	00000097          	auipc	ra,0x0
    800022ee:	f4a080e7          	jalr	-182(ra) # 80002234 <wakeup>
    800022f2:	b7d5                	j	800022d6 <reparent+0x2c>
}
    800022f4:	70a2                	ld	ra,40(sp)
    800022f6:	7402                	ld	s0,32(sp)
    800022f8:	64e2                	ld	s1,24(sp)
    800022fa:	6942                	ld	s2,16(sp)
    800022fc:	69a2                	ld	s3,8(sp)
    800022fe:	6a02                	ld	s4,0(sp)
    80002300:	6145                	add	sp,sp,48
    80002302:	8082                	ret

0000000080002304 <exit>:
{
    80002304:	7179                	add	sp,sp,-48
    80002306:	f406                	sd	ra,40(sp)
    80002308:	f022                	sd	s0,32(sp)
    8000230a:	ec26                	sd	s1,24(sp)
    8000230c:	e84a                	sd	s2,16(sp)
    8000230e:	e44e                	sd	s3,8(sp)
    80002310:	e052                	sd	s4,0(sp)
    80002312:	1800                	add	s0,sp,48
    80002314:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	7ee080e7          	jalr	2030(ra) # 80001b04 <myproc>
    8000231e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002320:	00006797          	auipc	a5,0x6
    80002324:	5d87b783          	ld	a5,1496(a5) # 800088f8 <initproc>
    80002328:	0d850493          	add	s1,a0,216
    8000232c:	15850913          	add	s2,a0,344
    80002330:	02a79363          	bne	a5,a0,80002356 <exit+0x52>
    panic("init exiting");
    80002334:	00006517          	auipc	a0,0x6
    80002338:	f6450513          	add	a0,a0,-156 # 80008298 <digits+0x260>
    8000233c:	ffffe097          	auipc	ra,0xffffe
    80002340:	4d2080e7          	jalr	1234(ra) # 8000080e <panic>
      fileclose(f);
    80002344:	00002097          	auipc	ra,0x2
    80002348:	2b8080e7          	jalr	696(ra) # 800045fc <fileclose>
      p->ofile[fd] = 0;
    8000234c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002350:	04a1                	add	s1,s1,8
    80002352:	01248563          	beq	s1,s2,8000235c <exit+0x58>
    if(p->ofile[fd]){
    80002356:	6088                	ld	a0,0(s1)
    80002358:	f575                	bnez	a0,80002344 <exit+0x40>
    8000235a:	bfdd                	j	80002350 <exit+0x4c>
  begin_op();
    8000235c:	00002097          	auipc	ra,0x2
    80002360:	ddc080e7          	jalr	-548(ra) # 80004138 <begin_op>
  iput(p->cwd);
    80002364:	1589b503          	ld	a0,344(s3)
    80002368:	00001097          	auipc	ra,0x1
    8000236c:	5e4080e7          	jalr	1508(ra) # 8000394c <iput>
  end_op();
    80002370:	00002097          	auipc	ra,0x2
    80002374:	e42080e7          	jalr	-446(ra) # 800041b2 <end_op>
  p->cwd = 0;
    80002378:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000237c:	0000e497          	auipc	s1,0xe
    80002380:	6cc48493          	add	s1,s1,1740 # 80010a48 <wait_lock>
    80002384:	8526                	mv	a0,s1
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	946080e7          	jalr	-1722(ra) # 80000ccc <acquire>
  reparent(p);
    8000238e:	854e                	mv	a0,s3
    80002390:	00000097          	auipc	ra,0x0
    80002394:	f1a080e7          	jalr	-230(ra) # 800022aa <reparent>
  wakeup(p->parent);
    80002398:	0409b503          	ld	a0,64(s3)
    8000239c:	00000097          	auipc	ra,0x0
    800023a0:	e98080e7          	jalr	-360(ra) # 80002234 <wakeup>
  acquire(&p->lock);
    800023a4:	854e                	mv	a0,s3
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	926080e7          	jalr	-1754(ra) # 80000ccc <acquire>
  p->xstate = status;
    800023ae:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800023b2:	4795                	li	a5,5
    800023b4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800023b8:	8526                	mv	a0,s1
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	9c6080e7          	jalr	-1594(ra) # 80000d80 <release>
  sched();
    800023c2:	00000097          	auipc	ra,0x0
    800023c6:	cfc080e7          	jalr	-772(ra) # 800020be <sched>
  panic("zombie exit");
    800023ca:	00006517          	auipc	a0,0x6
    800023ce:	ede50513          	add	a0,a0,-290 # 800082a8 <digits+0x270>
    800023d2:	ffffe097          	auipc	ra,0xffffe
    800023d6:	43c080e7          	jalr	1084(ra) # 8000080e <panic>

00000000800023da <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    800023da:	7179                	add	sp,sp,-48
    800023dc:	f406                	sd	ra,40(sp)
    800023de:	f022                	sd	s0,32(sp)
    800023e0:	ec26                	sd	s1,24(sp)
    800023e2:	e84a                	sd	s2,16(sp)
    800023e4:	e44e                	sd	s3,8(sp)
    800023e6:	1800                	add	s0,sp,48
    800023e8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023ea:	0000f497          	auipc	s1,0xf
    800023ee:	a7648493          	add	s1,s1,-1418 # 80010e60 <proc>
    800023f2:	00014997          	auipc	s3,0x14
    800023f6:	66e98993          	add	s3,s3,1646 # 80016a60 <tickslock>
    acquire(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	8d0080e7          	jalr	-1840(ra) # 80000ccc <acquire>
    if(p->pid == pid){
    80002404:	589c                	lw	a5,48(s1)
    80002406:	01278d63          	beq	a5,s2,80002420 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000240a:	8526                	mv	a0,s1
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	974080e7          	jalr	-1676(ra) # 80000d80 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002414:	17048493          	add	s1,s1,368
    80002418:	ff3491e3          	bne	s1,s3,800023fa <kill+0x20>
  }
  return -1;
    8000241c:	557d                	li	a0,-1
    8000241e:	a829                	j	80002438 <kill+0x5e>
      p->killed = 1;
    80002420:	4785                	li	a5,1
    80002422:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002424:	4c98                	lw	a4,24(s1)
    80002426:	4789                	li	a5,2
    80002428:	00f70f63          	beq	a4,a5,80002446 <kill+0x6c>
      release(&p->lock);
    8000242c:	8526                	mv	a0,s1
    8000242e:	fffff097          	auipc	ra,0xfffff
    80002432:	952080e7          	jalr	-1710(ra) # 80000d80 <release>
      return 0;
    80002436:	4501                	li	a0,0
}
    80002438:	70a2                	ld	ra,40(sp)
    8000243a:	7402                	ld	s0,32(sp)
    8000243c:	64e2                	ld	s1,24(sp)
    8000243e:	6942                	ld	s2,16(sp)
    80002440:	69a2                	ld	s3,8(sp)
    80002442:	6145                	add	sp,sp,48
    80002444:	8082                	ret
        p->state = RUNNABLE;
    80002446:	478d                	li	a5,3
    80002448:	cc9c                	sw	a5,24(s1)
    8000244a:	b7cd                	j	8000242c <kill+0x52>

000000008000244c <setkilled>:

void
setkilled(struct proc *p)
{
    8000244c:	1101                	add	sp,sp,-32
    8000244e:	ec06                	sd	ra,24(sp)
    80002450:	e822                	sd	s0,16(sp)
    80002452:	e426                	sd	s1,8(sp)
    80002454:	1000                	add	s0,sp,32
    80002456:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	874080e7          	jalr	-1932(ra) # 80000ccc <acquire>
  p->killed = 1;
    80002460:	4785                	li	a5,1
    80002462:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002464:	8526                	mv	a0,s1
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	91a080e7          	jalr	-1766(ra) # 80000d80 <release>
}
    8000246e:	60e2                	ld	ra,24(sp)
    80002470:	6442                	ld	s0,16(sp)
    80002472:	64a2                	ld	s1,8(sp)
    80002474:	6105                	add	sp,sp,32
    80002476:	8082                	ret

0000000080002478 <killed>:

int
killed(struct proc *p)
{
    80002478:	1101                	add	sp,sp,-32
    8000247a:	ec06                	sd	ra,24(sp)
    8000247c:	e822                	sd	s0,16(sp)
    8000247e:	e426                	sd	s1,8(sp)
    80002480:	e04a                	sd	s2,0(sp)
    80002482:	1000                	add	s0,sp,32
    80002484:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	846080e7          	jalr	-1978(ra) # 80000ccc <acquire>
  k = p->killed;
    8000248e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002492:	8526                	mv	a0,s1
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	8ec080e7          	jalr	-1812(ra) # 80000d80 <release>
  return k;
}
    8000249c:	854a                	mv	a0,s2
    8000249e:	60e2                	ld	ra,24(sp)
    800024a0:	6442                	ld	s0,16(sp)
    800024a2:	64a2                	ld	s1,8(sp)
    800024a4:	6902                	ld	s2,0(sp)
    800024a6:	6105                	add	sp,sp,32
    800024a8:	8082                	ret

00000000800024aa <wait>:
{
    800024aa:	715d                	add	sp,sp,-80
    800024ac:	e486                	sd	ra,72(sp)
    800024ae:	e0a2                	sd	s0,64(sp)
    800024b0:	fc26                	sd	s1,56(sp)
    800024b2:	f84a                	sd	s2,48(sp)
    800024b4:	f44e                	sd	s3,40(sp)
    800024b6:	f052                	sd	s4,32(sp)
    800024b8:	ec56                	sd	s5,24(sp)
    800024ba:	e85a                	sd	s6,16(sp)
    800024bc:	e45e                	sd	s7,8(sp)
    800024be:	e062                	sd	s8,0(sp)
    800024c0:	0880                	add	s0,sp,80
    800024c2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	640080e7          	jalr	1600(ra) # 80001b04 <myproc>
    800024cc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800024ce:	0000e517          	auipc	a0,0xe
    800024d2:	57a50513          	add	a0,a0,1402 # 80010a48 <wait_lock>
    800024d6:	ffffe097          	auipc	ra,0xffffe
    800024da:	7f6080e7          	jalr	2038(ra) # 80000ccc <acquire>
    havekids = 0;
    800024de:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800024e0:	4a15                	li	s4,5
        havekids = 1;
    800024e2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024e4:	00014997          	auipc	s3,0x14
    800024e8:	57c98993          	add	s3,s3,1404 # 80016a60 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800024ec:	0000ec17          	auipc	s8,0xe
    800024f0:	55cc0c13          	add	s8,s8,1372 # 80010a48 <wait_lock>
    800024f4:	a0d1                	j	800025b8 <wait+0x10e>
          pid = pp->pid;
    800024f6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800024fa:	000b0e63          	beqz	s6,80002516 <wait+0x6c>
    800024fe:	4691                	li	a3,4
    80002500:	02c48613          	add	a2,s1,44
    80002504:	85da                	mv	a1,s6
    80002506:	05893503          	ld	a0,88(s2)
    8000250a:	fffff097          	auipc	ra,0xfffff
    8000250e:	27a080e7          	jalr	634(ra) # 80001784 <copyout>
    80002512:	04054163          	bltz	a0,80002554 <wait+0xaa>
          freeproc(pp);
    80002516:	8526                	mv	a0,s1
    80002518:	fffff097          	auipc	ra,0xfffff
    8000251c:	7a2080e7          	jalr	1954(ra) # 80001cba <freeproc>
          release(&pp->lock);
    80002520:	8526                	mv	a0,s1
    80002522:	fffff097          	auipc	ra,0xfffff
    80002526:	85e080e7          	jalr	-1954(ra) # 80000d80 <release>
          release(&wait_lock);
    8000252a:	0000e517          	auipc	a0,0xe
    8000252e:	51e50513          	add	a0,a0,1310 # 80010a48 <wait_lock>
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	84e080e7          	jalr	-1970(ra) # 80000d80 <release>
}
    8000253a:	854e                	mv	a0,s3
    8000253c:	60a6                	ld	ra,72(sp)
    8000253e:	6406                	ld	s0,64(sp)
    80002540:	74e2                	ld	s1,56(sp)
    80002542:	7942                	ld	s2,48(sp)
    80002544:	79a2                	ld	s3,40(sp)
    80002546:	7a02                	ld	s4,32(sp)
    80002548:	6ae2                	ld	s5,24(sp)
    8000254a:	6b42                	ld	s6,16(sp)
    8000254c:	6ba2                	ld	s7,8(sp)
    8000254e:	6c02                	ld	s8,0(sp)
    80002550:	6161                	add	sp,sp,80
    80002552:	8082                	ret
            release(&pp->lock);
    80002554:	8526                	mv	a0,s1
    80002556:	fffff097          	auipc	ra,0xfffff
    8000255a:	82a080e7          	jalr	-2006(ra) # 80000d80 <release>
            release(&wait_lock);
    8000255e:	0000e517          	auipc	a0,0xe
    80002562:	4ea50513          	add	a0,a0,1258 # 80010a48 <wait_lock>
    80002566:	fffff097          	auipc	ra,0xfffff
    8000256a:	81a080e7          	jalr	-2022(ra) # 80000d80 <release>
            return -1;
    8000256e:	59fd                	li	s3,-1
    80002570:	b7e9                	j	8000253a <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002572:	17048493          	add	s1,s1,368
    80002576:	03348463          	beq	s1,s3,8000259e <wait+0xf4>
      if(pp->parent == p){
    8000257a:	60bc                	ld	a5,64(s1)
    8000257c:	ff279be3          	bne	a5,s2,80002572 <wait+0xc8>
        acquire(&pp->lock);
    80002580:	8526                	mv	a0,s1
    80002582:	ffffe097          	auipc	ra,0xffffe
    80002586:	74a080e7          	jalr	1866(ra) # 80000ccc <acquire>
        if(pp->state == ZOMBIE){
    8000258a:	4c9c                	lw	a5,24(s1)
    8000258c:	f74785e3          	beq	a5,s4,800024f6 <wait+0x4c>
        release(&pp->lock);
    80002590:	8526                	mv	a0,s1
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	7ee080e7          	jalr	2030(ra) # 80000d80 <release>
        havekids = 1;
    8000259a:	8756                	mv	a4,s5
    8000259c:	bfd9                	j	80002572 <wait+0xc8>
    if(!havekids || killed(p)){
    8000259e:	c31d                	beqz	a4,800025c4 <wait+0x11a>
    800025a0:	854a                	mv	a0,s2
    800025a2:	00000097          	auipc	ra,0x0
    800025a6:	ed6080e7          	jalr	-298(ra) # 80002478 <killed>
    800025aa:	ed09                	bnez	a0,800025c4 <wait+0x11a>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800025ac:	85e2                	mv	a1,s8
    800025ae:	854a                	mv	a0,s2
    800025b0:	00000097          	auipc	ra,0x0
    800025b4:	c20080e7          	jalr	-992(ra) # 800021d0 <sleep>
    havekids = 0;
    800025b8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025ba:	0000f497          	auipc	s1,0xf
    800025be:	8a648493          	add	s1,s1,-1882 # 80010e60 <proc>
    800025c2:	bf65                	j	8000257a <wait+0xd0>
      release(&wait_lock);
    800025c4:	0000e517          	auipc	a0,0xe
    800025c8:	48450513          	add	a0,a0,1156 # 80010a48 <wait_lock>
    800025cc:	ffffe097          	auipc	ra,0xffffe
    800025d0:	7b4080e7          	jalr	1972(ra) # 80000d80 <release>
      return -1;
    800025d4:	59fd                	li	s3,-1
    800025d6:	b795                	j	8000253a <wait+0x90>

00000000800025d8 <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800025d8:	7179                	add	sp,sp,-48
    800025da:	f406                	sd	ra,40(sp)
    800025dc:	f022                	sd	s0,32(sp)
    800025de:	ec26                	sd	s1,24(sp)
    800025e0:	e84a                	sd	s2,16(sp)
    800025e2:	e44e                	sd	s3,8(sp)
    800025e4:	e052                	sd	s4,0(sp)
    800025e6:	1800                	add	s0,sp,48
    800025e8:	84aa                	mv	s1,a0
    800025ea:	892e                	mv	s2,a1
    800025ec:	89b2                	mv	s3,a2
    800025ee:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025f0:	fffff097          	auipc	ra,0xfffff
    800025f4:	514080e7          	jalr	1300(ra) # 80001b04 <myproc>
  if(user_dst){
    800025f8:	c08d                	beqz	s1,8000261a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800025fa:	86d2                	mv	a3,s4
    800025fc:	864e                	mv	a2,s3
    800025fe:	85ca                	mv	a1,s2
    80002600:	6d28                	ld	a0,88(a0)
    80002602:	fffff097          	auipc	ra,0xfffff
    80002606:	182080e7          	jalr	386(ra) # 80001784 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000260a:	70a2                	ld	ra,40(sp)
    8000260c:	7402                	ld	s0,32(sp)
    8000260e:	64e2                	ld	s1,24(sp)
    80002610:	6942                	ld	s2,16(sp)
    80002612:	69a2                	ld	s3,8(sp)
    80002614:	6a02                	ld	s4,0(sp)
    80002616:	6145                	add	sp,sp,48
    80002618:	8082                	ret
    memmove((char *)dst, src, len);
    8000261a:	000a061b          	sext.w	a2,s4
    8000261e:	85ce                	mv	a1,s3
    80002620:	854a                	mv	a0,s2
    80002622:	fffff097          	auipc	ra,0xfffff
    80002626:	802080e7          	jalr	-2046(ra) # 80000e24 <memmove>
    return 0;
    8000262a:	8526                	mv	a0,s1
    8000262c:	bff9                	j	8000260a <either_copyout+0x32>

000000008000262e <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000262e:	7179                	add	sp,sp,-48
    80002630:	f406                	sd	ra,40(sp)
    80002632:	f022                	sd	s0,32(sp)
    80002634:	ec26                	sd	s1,24(sp)
    80002636:	e84a                	sd	s2,16(sp)
    80002638:	e44e                	sd	s3,8(sp)
    8000263a:	e052                	sd	s4,0(sp)
    8000263c:	1800                	add	s0,sp,48
    8000263e:	892a                	mv	s2,a0
    80002640:	84ae                	mv	s1,a1
    80002642:	89b2                	mv	s3,a2
    80002644:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002646:	fffff097          	auipc	ra,0xfffff
    8000264a:	4be080e7          	jalr	1214(ra) # 80001b04 <myproc>
  if(user_src){
    8000264e:	c08d                	beqz	s1,80002670 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002650:	86d2                	mv	a3,s4
    80002652:	864e                	mv	a2,s3
    80002654:	85ca                	mv	a1,s2
    80002656:	6d28                	ld	a0,88(a0)
    80002658:	fffff097          	auipc	ra,0xfffff
    8000265c:	1ec080e7          	jalr	492(ra) # 80001844 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002660:	70a2                	ld	ra,40(sp)
    80002662:	7402                	ld	s0,32(sp)
    80002664:	64e2                	ld	s1,24(sp)
    80002666:	6942                	ld	s2,16(sp)
    80002668:	69a2                	ld	s3,8(sp)
    8000266a:	6a02                	ld	s4,0(sp)
    8000266c:	6145                	add	sp,sp,48
    8000266e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002670:	000a061b          	sext.w	a2,s4
    80002674:	85ce                	mv	a1,s3
    80002676:	854a                	mv	a0,s2
    80002678:	ffffe097          	auipc	ra,0xffffe
    8000267c:	7ac080e7          	jalr	1964(ra) # 80000e24 <memmove>
    return 0;
    80002680:	8526                	mv	a0,s1
    80002682:	bff9                	j	80002660 <either_copyin+0x32>

0000000080002684 <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    80002684:	715d                	add	sp,sp,-80
    80002686:	e486                	sd	ra,72(sp)
    80002688:	e0a2                	sd	s0,64(sp)
    8000268a:	fc26                	sd	s1,56(sp)
    8000268c:	f84a                	sd	s2,48(sp)
    8000268e:	f44e                	sd	s3,40(sp)
    80002690:	f052                	sd	s4,32(sp)
    80002692:	ec56                	sd	s5,24(sp)
    80002694:	e85a                	sd	s6,16(sp)
    80002696:	e45e                	sd	s7,8(sp)
    80002698:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000269a:	00006517          	auipc	a0,0x6
    8000269e:	a2650513          	add	a0,a0,-1498 # 800080c0 <digits+0x88>
    800026a2:	ffffe097          	auipc	ra,0xffffe
    800026a6:	e60080e7          	jalr	-416(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026aa:	0000f497          	auipc	s1,0xf
    800026ae:	91648493          	add	s1,s1,-1770 # 80010fc0 <proc+0x160>
    800026b2:	00014917          	auipc	s2,0x14
    800026b6:	50e90913          	add	s2,s2,1294 # 80016bc0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026ba:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800026bc:	00006997          	auipc	s3,0x6
    800026c0:	bfc98993          	add	s3,s3,-1028 # 800082b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    800026c4:	00006a97          	auipc	s5,0x6
    800026c8:	bfca8a93          	add	s5,s5,-1028 # 800082c0 <digits+0x288>
    printf("\n");
    800026cc:	00006a17          	auipc	s4,0x6
    800026d0:	9f4a0a13          	add	s4,s4,-1548 # 800080c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026d4:	00006b97          	auipc	s7,0x6
    800026d8:	c2cb8b93          	add	s7,s7,-980 # 80008300 <states.0>
    800026dc:	a00d                	j	800026fe <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800026de:	ed06a583          	lw	a1,-304(a3)
    800026e2:	8556                	mv	a0,s5
    800026e4:	ffffe097          	auipc	ra,0xffffe
    800026e8:	e1e080e7          	jalr	-482(ra) # 80000502 <printf>
    printf("\n");
    800026ec:	8552                	mv	a0,s4
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	e14080e7          	jalr	-492(ra) # 80000502 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026f6:	17048493          	add	s1,s1,368
    800026fa:	03248263          	beq	s1,s2,8000271e <procdump+0x9a>
    if(p->state == UNUSED)
    800026fe:	86a6                	mv	a3,s1
    80002700:	eb84a783          	lw	a5,-328(s1)
    80002704:	dbed                	beqz	a5,800026f6 <procdump+0x72>
      state = "???";
    80002706:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002708:	fcfb6be3          	bltu	s6,a5,800026de <procdump+0x5a>
    8000270c:	02079713          	sll	a4,a5,0x20
    80002710:	01d75793          	srl	a5,a4,0x1d
    80002714:	97de                	add	a5,a5,s7
    80002716:	6390                	ld	a2,0(a5)
    80002718:	f279                	bnez	a2,800026de <procdump+0x5a>
      state = "???";
    8000271a:	864e                	mv	a2,s3
    8000271c:	b7c9                	j	800026de <procdump+0x5a>
  }
}
    8000271e:	60a6                	ld	ra,72(sp)
    80002720:	6406                	ld	s0,64(sp)
    80002722:	74e2                	ld	s1,56(sp)
    80002724:	7942                	ld	s2,48(sp)
    80002726:	79a2                	ld	s3,40(sp)
    80002728:	7a02                	ld	s4,32(sp)
    8000272a:	6ae2                	ld	s5,24(sp)
    8000272c:	6b42                	ld	s6,16(sp)
    8000272e:	6ba2                	ld	s7,8(sp)
    80002730:	6161                	add	sp,sp,80
    80002732:	8082                	ret

0000000080002734 <swtch>:
    80002734:	00153023          	sd	ra,0(a0)
    80002738:	00253423          	sd	sp,8(a0)
    8000273c:	e900                	sd	s0,16(a0)
    8000273e:	ed04                	sd	s1,24(a0)
    80002740:	03253023          	sd	s2,32(a0)
    80002744:	03353423          	sd	s3,40(a0)
    80002748:	03453823          	sd	s4,48(a0)
    8000274c:	03553c23          	sd	s5,56(a0)
    80002750:	05653023          	sd	s6,64(a0)
    80002754:	05753423          	sd	s7,72(a0)
    80002758:	05853823          	sd	s8,80(a0)
    8000275c:	05953c23          	sd	s9,88(a0)
    80002760:	07a53023          	sd	s10,96(a0)
    80002764:	07b53423          	sd	s11,104(a0)
    80002768:	0005b083          	ld	ra,0(a1)
    8000276c:	0085b103          	ld	sp,8(a1)
    80002770:	6980                	ld	s0,16(a1)
    80002772:	6d84                	ld	s1,24(a1)
    80002774:	0205b903          	ld	s2,32(a1)
    80002778:	0285b983          	ld	s3,40(a1)
    8000277c:	0305ba03          	ld	s4,48(a1)
    80002780:	0385ba83          	ld	s5,56(a1)
    80002784:	0405bb03          	ld	s6,64(a1)
    80002788:	0485bb83          	ld	s7,72(a1)
    8000278c:	0505bc03          	ld	s8,80(a1)
    80002790:	0585bc83          	ld	s9,88(a1)
    80002794:	0605bd03          	ld	s10,96(a1)
    80002798:	0685bd83          	ld	s11,104(a1)
    8000279c:	8082                	ret

000000008000279e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000279e:	1141                	add	sp,sp,-16
    800027a0:	e406                	sd	ra,8(sp)
    800027a2:	e022                	sd	s0,0(sp)
    800027a4:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    800027a6:	00006597          	auipc	a1,0x6
    800027aa:	b8a58593          	add	a1,a1,-1142 # 80008330 <states.0+0x30>
    800027ae:	00014517          	auipc	a0,0x14
    800027b2:	2b250513          	add	a0,a0,690 # 80016a60 <tickslock>
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	486080e7          	jalr	1158(ra) # 80000c3c <initlock>
}
    800027be:	60a2                	ld	ra,8(sp)
    800027c0:	6402                	ld	s0,0(sp)
    800027c2:	0141                	add	sp,sp,16
    800027c4:	8082                	ret

00000000800027c6 <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    800027c6:	1141                	add	sp,sp,-16
    800027c8:	e422                	sd	s0,8(sp)
    800027ca:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027cc:	00003797          	auipc	a5,0x3
    800027d0:	45478793          	add	a5,a5,1108 # 80005c20 <kernelvec>
    800027d4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027d8:	6422                	ld	s0,8(sp)
    800027da:	0141                	add	sp,sp,16
    800027dc:	8082                	ret

00000000800027de <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    800027de:	1141                	add	sp,sp,-16
    800027e0:	e406                	sd	ra,8(sp)
    800027e2:	e022                	sd	s0,0(sp)
    800027e4:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    800027e6:	fffff097          	auipc	ra,0xfffff
    800027ea:	31e080e7          	jalr	798(ra) # 80001b04 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027f2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027f4:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027f8:	00005697          	auipc	a3,0x5
    800027fc:	80868693          	add	a3,a3,-2040 # 80007000 <_trampoline>
    80002800:	00005717          	auipc	a4,0x5
    80002804:	80070713          	add	a4,a4,-2048 # 80007000 <_trampoline>
    80002808:	8f15                	sub	a4,a4,a3
    8000280a:	040007b7          	lui	a5,0x4000
    8000280e:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002810:	07b2                	sll	a5,a5,0xc
    80002812:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002814:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    80002818:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000281a:	18002673          	csrr	a2,satp
    8000281e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    80002820:	7130                	ld	a2,96(a0)
    80002822:	6538                	ld	a4,72(a0)
    80002824:	6585                	lui	a1,0x1
    80002826:	972e                	add	a4,a4,a1
    80002828:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000282a:	7138                	ld	a4,96(a0)
    8000282c:	00000617          	auipc	a2,0x0
    80002830:	13460613          	add	a2,a2,308 # 80002960 <usertrap>
    80002834:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    80002836:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002838:	8612                	mv	a2,tp
    8000283a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000283c:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    80002840:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    80002844:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002848:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    8000284c:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000284e:	6f18                	ld	a4,24(a4)
    80002850:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    80002854:	6d28                	ld	a0,88(a0)
    80002856:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002858:	00005717          	auipc	a4,0x5
    8000285c:	84470713          	add	a4,a4,-1980 # 8000709c <userret>
    80002860:	8f15                	sub	a4,a4,a3
    80002862:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002864:	577d                	li	a4,-1
    80002866:	177e                	sll	a4,a4,0x3f
    80002868:	8d59                	or	a0,a0,a4
    8000286a:	9782                	jalr	a5
}
    8000286c:	60a2                	ld	ra,8(sp)
    8000286e:	6402                	ld	s0,0(sp)
    80002870:	0141                	add	sp,sp,16
    80002872:	8082                	ret

0000000080002874 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002874:	1101                	add	sp,sp,-32
    80002876:	ec06                	sd	ra,24(sp)
    80002878:	e822                	sd	s0,16(sp)
    8000287a:	e426                	sd	s1,8(sp)
    8000287c:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    8000287e:	fffff097          	auipc	ra,0xfffff
    80002882:	25a080e7          	jalr	602(ra) # 80001ad8 <cpuid>
    80002886:	cd19                	beqz	a0,800028a4 <clockintr+0x30>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002888:	c01027f3          	rdtime	a5
  }

  /* ask for the next timer interrupt. this also clears */
  /* the interrupt request. 1000000 is about a tenth */
  /* of a second. */
  w_stimecmp(r_time() + 1000000);
    8000288c:	000f4737          	lui	a4,0xf4
    80002890:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002894:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002896:	14d79073          	csrw	stimecmp,a5
}
    8000289a:	60e2                	ld	ra,24(sp)
    8000289c:	6442                	ld	s0,16(sp)
    8000289e:	64a2                	ld	s1,8(sp)
    800028a0:	6105                	add	sp,sp,32
    800028a2:	8082                	ret
    acquire(&tickslock);
    800028a4:	00014497          	auipc	s1,0x14
    800028a8:	1bc48493          	add	s1,s1,444 # 80016a60 <tickslock>
    800028ac:	8526                	mv	a0,s1
    800028ae:	ffffe097          	auipc	ra,0xffffe
    800028b2:	41e080e7          	jalr	1054(ra) # 80000ccc <acquire>
    ticks++;
    800028b6:	00006517          	auipc	a0,0x6
    800028ba:	04a50513          	add	a0,a0,74 # 80008900 <ticks>
    800028be:	411c                	lw	a5,0(a0)
    800028c0:	2785                	addw	a5,a5,1
    800028c2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800028c4:	00000097          	auipc	ra,0x0
    800028c8:	970080e7          	jalr	-1680(ra) # 80002234 <wakeup>
    release(&tickslock);
    800028cc:	8526                	mv	a0,s1
    800028ce:	ffffe097          	auipc	ra,0xffffe
    800028d2:	4b2080e7          	jalr	1202(ra) # 80000d80 <release>
    800028d6:	bf4d                	j	80002888 <clockintr+0x14>

00000000800028d8 <devintr>:
/* returns 2 if timer interrupt, */
/* 1 if other device, */
/* 0 if not recognized. */
int
devintr()
{
    800028d8:	1101                	add	sp,sp,-32
    800028da:	ec06                	sd	ra,24(sp)
    800028dc:	e822                	sd	s0,16(sp)
    800028de:	e426                	sd	s1,8(sp)
    800028e0:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028e2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800028e6:	57fd                	li	a5,-1
    800028e8:	17fe                	sll	a5,a5,0x3f
    800028ea:	07a5                	add	a5,a5,9
    800028ec:	00f70d63          	beq	a4,a5,80002906 <devintr+0x2e>
    /* now allowed to interrupt again. */
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800028f0:	57fd                	li	a5,-1
    800028f2:	17fe                	sll	a5,a5,0x3f
    800028f4:	0795                	add	a5,a5,5
    /* timer interrupt. */
    clockintr();
    return 2;
  } else {
    return 0;
    800028f6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800028f8:	04f70e63          	beq	a4,a5,80002954 <devintr+0x7c>
  }
}
    800028fc:	60e2                	ld	ra,24(sp)
    800028fe:	6442                	ld	s0,16(sp)
    80002900:	64a2                	ld	s1,8(sp)
    80002902:	6105                	add	sp,sp,32
    80002904:	8082                	ret
    int irq = plic_claim();
    80002906:	00003097          	auipc	ra,0x3
    8000290a:	3c6080e7          	jalr	966(ra) # 80005ccc <plic_claim>
    8000290e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002910:	47a9                	li	a5,10
    80002912:	02f50763          	beq	a0,a5,80002940 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80002916:	4785                	li	a5,1
    80002918:	02f50963          	beq	a0,a5,8000294a <devintr+0x72>
    return 1;
    8000291c:	4505                	li	a0,1
    } else if(irq){
    8000291e:	dcf9                	beqz	s1,800028fc <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002920:	85a6                	mv	a1,s1
    80002922:	00006517          	auipc	a0,0x6
    80002926:	a1650513          	add	a0,a0,-1514 # 80008338 <states.0+0x38>
    8000292a:	ffffe097          	auipc	ra,0xffffe
    8000292e:	bd8080e7          	jalr	-1064(ra) # 80000502 <printf>
      plic_complete(irq);
    80002932:	8526                	mv	a0,s1
    80002934:	00003097          	auipc	ra,0x3
    80002938:	3bc080e7          	jalr	956(ra) # 80005cf0 <plic_complete>
    return 1;
    8000293c:	4505                	li	a0,1
    8000293e:	bf7d                	j	800028fc <devintr+0x24>
      uartintr();
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	14e080e7          	jalr	334(ra) # 80000a8e <uartintr>
    if(irq)
    80002948:	b7ed                	j	80002932 <devintr+0x5a>
      virtio_disk_intr();
    8000294a:	00004097          	auipc	ra,0x4
    8000294e:	86c080e7          	jalr	-1940(ra) # 800061b6 <virtio_disk_intr>
    if(irq)
    80002952:	b7c5                	j	80002932 <devintr+0x5a>
    clockintr();
    80002954:	00000097          	auipc	ra,0x0
    80002958:	f20080e7          	jalr	-224(ra) # 80002874 <clockintr>
    return 2;
    8000295c:	4509                	li	a0,2
    8000295e:	bf79                	j	800028fc <devintr+0x24>

0000000080002960 <usertrap>:
{
    80002960:	1101                	add	sp,sp,-32
    80002962:	ec06                	sd	ra,24(sp)
    80002964:	e822                	sd	s0,16(sp)
    80002966:	e426                	sd	s1,8(sp)
    80002968:	e04a                	sd	s2,0(sp)
    8000296a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000296c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002970:	1007f793          	and	a5,a5,256
    80002974:	e3b1                	bnez	a5,800029b8 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002976:	00003797          	auipc	a5,0x3
    8000297a:	2aa78793          	add	a5,a5,682 # 80005c20 <kernelvec>
    8000297e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002982:	fffff097          	auipc	ra,0xfffff
    80002986:	182080e7          	jalr	386(ra) # 80001b04 <myproc>
    8000298a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000298c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000298e:	14102773          	csrr	a4,sepc
    80002992:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002994:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002998:	47a1                	li	a5,8
    8000299a:	02f70763          	beq	a4,a5,800029c8 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	f3a080e7          	jalr	-198(ra) # 800028d8 <devintr>
    800029a6:	892a                	mv	s2,a0
    800029a8:	c151                	beqz	a0,80002a2c <usertrap+0xcc>
  if(killed(p))
    800029aa:	8526                	mv	a0,s1
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	acc080e7          	jalr	-1332(ra) # 80002478 <killed>
    800029b4:	c929                	beqz	a0,80002a06 <usertrap+0xa6>
    800029b6:	a099                	j	800029fc <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	9a050513          	add	a0,a0,-1632 # 80008358 <states.0+0x58>
    800029c0:	ffffe097          	auipc	ra,0xffffe
    800029c4:	e4e080e7          	jalr	-434(ra) # 8000080e <panic>
    if(killed(p))
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	ab0080e7          	jalr	-1360(ra) # 80002478 <killed>
    800029d0:	e921                	bnez	a0,80002a20 <usertrap+0xc0>
    p->trapframe->epc += 4;
    800029d2:	70b8                	ld	a4,96(s1)
    800029d4:	6f1c                	ld	a5,24(a4)
    800029d6:	0791                	add	a5,a5,4
    800029d8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029de:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029e2:	10079073          	csrw	sstatus,a5
    syscall();
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	2b4080e7          	jalr	692(ra) # 80002c9a <syscall>
  if(killed(p))
    800029ee:	8526                	mv	a0,s1
    800029f0:	00000097          	auipc	ra,0x0
    800029f4:	a88080e7          	jalr	-1400(ra) # 80002478 <killed>
    800029f8:	c911                	beqz	a0,80002a0c <usertrap+0xac>
    800029fa:	4901                	li	s2,0
    exit(-1);
    800029fc:	557d                	li	a0,-1
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	906080e7          	jalr	-1786(ra) # 80002304 <exit>
  if(which_dev == 2)
    80002a06:	4789                	li	a5,2
    80002a08:	04f90f63          	beq	s2,a5,80002a66 <usertrap+0x106>
  usertrapret();
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	dd2080e7          	jalr	-558(ra) # 800027de <usertrapret>
}
    80002a14:	60e2                	ld	ra,24(sp)
    80002a16:	6442                	ld	s0,16(sp)
    80002a18:	64a2                	ld	s1,8(sp)
    80002a1a:	6902                	ld	s2,0(sp)
    80002a1c:	6105                	add	sp,sp,32
    80002a1e:	8082                	ret
      exit(-1);
    80002a20:	557d                	li	a0,-1
    80002a22:	00000097          	auipc	ra,0x0
    80002a26:	8e2080e7          	jalr	-1822(ra) # 80002304 <exit>
    80002a2a:	b765                	j	800029d2 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a2c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002a30:	5890                	lw	a2,48(s1)
    80002a32:	00006517          	auipc	a0,0x6
    80002a36:	94650513          	add	a0,a0,-1722 # 80008378 <states.0+0x78>
    80002a3a:	ffffe097          	auipc	ra,0xffffe
    80002a3e:	ac8080e7          	jalr	-1336(ra) # 80000502 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a42:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a46:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002a4a:	00006517          	auipc	a0,0x6
    80002a4e:	95e50513          	add	a0,a0,-1698 # 800083a8 <states.0+0xa8>
    80002a52:	ffffe097          	auipc	ra,0xffffe
    80002a56:	ab0080e7          	jalr	-1360(ra) # 80000502 <printf>
    setkilled(p);
    80002a5a:	8526                	mv	a0,s1
    80002a5c:	00000097          	auipc	ra,0x0
    80002a60:	9f0080e7          	jalr	-1552(ra) # 8000244c <setkilled>
    80002a64:	b769                	j	800029ee <usertrap+0x8e>
    yield();
    80002a66:	fffff097          	auipc	ra,0xfffff
    80002a6a:	72e080e7          	jalr	1838(ra) # 80002194 <yield>
    80002a6e:	bf79                	j	80002a0c <usertrap+0xac>

0000000080002a70 <kerneltrap>:
{
    80002a70:	7179                	add	sp,sp,-48
    80002a72:	f406                	sd	ra,40(sp)
    80002a74:	f022                	sd	s0,32(sp)
    80002a76:	ec26                	sd	s1,24(sp)
    80002a78:	e84a                	sd	s2,16(sp)
    80002a7a:	e44e                	sd	s3,8(sp)
    80002a7c:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a7e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a82:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a86:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a8a:	1004f793          	and	a5,s1,256
    80002a8e:	cb85                	beqz	a5,80002abe <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a90:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a94:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002a96:	ef85                	bnez	a5,80002ace <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	e40080e7          	jalr	-448(ra) # 800028d8 <devintr>
    80002aa0:	cd1d                	beqz	a0,80002ade <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0)
    80002aa2:	4789                	li	a5,2
    80002aa4:	06f50263          	beq	a0,a5,80002b08 <kerneltrap+0x98>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002aa8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aac:	10049073          	csrw	sstatus,s1
}
    80002ab0:	70a2                	ld	ra,40(sp)
    80002ab2:	7402                	ld	s0,32(sp)
    80002ab4:	64e2                	ld	s1,24(sp)
    80002ab6:	6942                	ld	s2,16(sp)
    80002ab8:	69a2                	ld	s3,8(sp)
    80002aba:	6145                	add	sp,sp,48
    80002abc:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002abe:	00006517          	auipc	a0,0x6
    80002ac2:	91250513          	add	a0,a0,-1774 # 800083d0 <states.0+0xd0>
    80002ac6:	ffffe097          	auipc	ra,0xffffe
    80002aca:	d48080e7          	jalr	-696(ra) # 8000080e <panic>
    panic("kerneltrap: interrupts enabled");
    80002ace:	00006517          	auipc	a0,0x6
    80002ad2:	92a50513          	add	a0,a0,-1750 # 800083f8 <states.0+0xf8>
    80002ad6:	ffffe097          	auipc	ra,0xffffe
    80002ada:	d38080e7          	jalr	-712(ra) # 8000080e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ade:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ae2:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002ae6:	85ce                	mv	a1,s3
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	93050513          	add	a0,a0,-1744 # 80008418 <states.0+0x118>
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	a12080e7          	jalr	-1518(ra) # 80000502 <printf>
    panic("kerneltrap");
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	94850513          	add	a0,a0,-1720 # 80008440 <states.0+0x140>
    80002b00:	ffffe097          	auipc	ra,0xffffe
    80002b04:	d0e080e7          	jalr	-754(ra) # 8000080e <panic>
  if(which_dev == 2 && myproc() != 0)
    80002b08:	fffff097          	auipc	ra,0xfffff
    80002b0c:	ffc080e7          	jalr	-4(ra) # 80001b04 <myproc>
    80002b10:	dd41                	beqz	a0,80002aa8 <kerneltrap+0x38>
    yield();
    80002b12:	fffff097          	auipc	ra,0xfffff
    80002b16:	682080e7          	jalr	1666(ra) # 80002194 <yield>
    80002b1a:	b779                	j	80002aa8 <kerneltrap+0x38>

0000000080002b1c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b1c:	1101                	add	sp,sp,-32
    80002b1e:	ec06                	sd	ra,24(sp)
    80002b20:	e822                	sd	s0,16(sp)
    80002b22:	e426                	sd	s1,8(sp)
    80002b24:	1000                	add	s0,sp,32
    80002b26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b28:	fffff097          	auipc	ra,0xfffff
    80002b2c:	fdc080e7          	jalr	-36(ra) # 80001b04 <myproc>
  switch (n) {
    80002b30:	4795                	li	a5,5
    80002b32:	0497e163          	bltu	a5,s1,80002b74 <argraw+0x58>
    80002b36:	048a                	sll	s1,s1,0x2
    80002b38:	00006717          	auipc	a4,0x6
    80002b3c:	94070713          	add	a4,a4,-1728 # 80008478 <states.0+0x178>
    80002b40:	94ba                	add	s1,s1,a4
    80002b42:	409c                	lw	a5,0(s1)
    80002b44:	97ba                	add	a5,a5,a4
    80002b46:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b48:	713c                	ld	a5,96(a0)
    80002b4a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b4c:	60e2                	ld	ra,24(sp)
    80002b4e:	6442                	ld	s0,16(sp)
    80002b50:	64a2                	ld	s1,8(sp)
    80002b52:	6105                	add	sp,sp,32
    80002b54:	8082                	ret
    return p->trapframe->a1;
    80002b56:	713c                	ld	a5,96(a0)
    80002b58:	7fa8                	ld	a0,120(a5)
    80002b5a:	bfcd                	j	80002b4c <argraw+0x30>
    return p->trapframe->a2;
    80002b5c:	713c                	ld	a5,96(a0)
    80002b5e:	63c8                	ld	a0,128(a5)
    80002b60:	b7f5                	j	80002b4c <argraw+0x30>
    return p->trapframe->a3;
    80002b62:	713c                	ld	a5,96(a0)
    80002b64:	67c8                	ld	a0,136(a5)
    80002b66:	b7dd                	j	80002b4c <argraw+0x30>
    return p->trapframe->a4;
    80002b68:	713c                	ld	a5,96(a0)
    80002b6a:	6bc8                	ld	a0,144(a5)
    80002b6c:	b7c5                	j	80002b4c <argraw+0x30>
    return p->trapframe->a5;
    80002b6e:	713c                	ld	a5,96(a0)
    80002b70:	6fc8                	ld	a0,152(a5)
    80002b72:	bfe9                	j	80002b4c <argraw+0x30>
  panic("argraw");
    80002b74:	00006517          	auipc	a0,0x6
    80002b78:	8dc50513          	add	a0,a0,-1828 # 80008450 <states.0+0x150>
    80002b7c:	ffffe097          	auipc	ra,0xffffe
    80002b80:	c92080e7          	jalr	-878(ra) # 8000080e <panic>

0000000080002b84 <fetchaddr>:
{
    80002b84:	1101                	add	sp,sp,-32
    80002b86:	ec06                	sd	ra,24(sp)
    80002b88:	e822                	sd	s0,16(sp)
    80002b8a:	e426                	sd	s1,8(sp)
    80002b8c:	e04a                	sd	s2,0(sp)
    80002b8e:	1000                	add	s0,sp,32
    80002b90:	84aa                	mv	s1,a0
    80002b92:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b94:	fffff097          	auipc	ra,0xfffff
    80002b98:	f70080e7          	jalr	-144(ra) # 80001b04 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80002b9c:	693c                	ld	a5,80(a0)
    80002b9e:	02f4f863          	bgeu	s1,a5,80002bce <fetchaddr+0x4a>
    80002ba2:	00848713          	add	a4,s1,8
    80002ba6:	02e7e663          	bltu	a5,a4,80002bd2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002baa:	46a1                	li	a3,8
    80002bac:	8626                	mv	a2,s1
    80002bae:	85ca                	mv	a1,s2
    80002bb0:	6d28                	ld	a0,88(a0)
    80002bb2:	fffff097          	auipc	ra,0xfffff
    80002bb6:	c92080e7          	jalr	-878(ra) # 80001844 <copyin>
    80002bba:	00a03533          	snez	a0,a0
    80002bbe:	40a00533          	neg	a0,a0
}
    80002bc2:	60e2                	ld	ra,24(sp)
    80002bc4:	6442                	ld	s0,16(sp)
    80002bc6:	64a2                	ld	s1,8(sp)
    80002bc8:	6902                	ld	s2,0(sp)
    80002bca:	6105                	add	sp,sp,32
    80002bcc:	8082                	ret
    return -1;
    80002bce:	557d                	li	a0,-1
    80002bd0:	bfcd                	j	80002bc2 <fetchaddr+0x3e>
    80002bd2:	557d                	li	a0,-1
    80002bd4:	b7fd                	j	80002bc2 <fetchaddr+0x3e>

0000000080002bd6 <fetchstr>:
{
    80002bd6:	7179                	add	sp,sp,-48
    80002bd8:	f406                	sd	ra,40(sp)
    80002bda:	f022                	sd	s0,32(sp)
    80002bdc:	ec26                	sd	s1,24(sp)
    80002bde:	e84a                	sd	s2,16(sp)
    80002be0:	e44e                	sd	s3,8(sp)
    80002be2:	1800                	add	s0,sp,48
    80002be4:	892a                	mv	s2,a0
    80002be6:	84ae                	mv	s1,a1
    80002be8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bea:	fffff097          	auipc	ra,0xfffff
    80002bee:	f1a080e7          	jalr	-230(ra) # 80001b04 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002bf2:	86ce                	mv	a3,s3
    80002bf4:	864a                	mv	a2,s2
    80002bf6:	85a6                	mv	a1,s1
    80002bf8:	6d28                	ld	a0,88(a0)
    80002bfa:	fffff097          	auipc	ra,0xfffff
    80002bfe:	cd8080e7          	jalr	-808(ra) # 800018d2 <copyinstr>
    80002c02:	00054e63          	bltz	a0,80002c1e <fetchstr+0x48>
  return strlen(buf);
    80002c06:	8526                	mv	a0,s1
    80002c08:	ffffe097          	auipc	ra,0xffffe
    80002c0c:	33a080e7          	jalr	826(ra) # 80000f42 <strlen>
}
    80002c10:	70a2                	ld	ra,40(sp)
    80002c12:	7402                	ld	s0,32(sp)
    80002c14:	64e2                	ld	s1,24(sp)
    80002c16:	6942                	ld	s2,16(sp)
    80002c18:	69a2                	ld	s3,8(sp)
    80002c1a:	6145                	add	sp,sp,48
    80002c1c:	8082                	ret
    return -1;
    80002c1e:	557d                	li	a0,-1
    80002c20:	bfc5                	j	80002c10 <fetchstr+0x3a>

0000000080002c22 <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    80002c22:	1101                	add	sp,sp,-32
    80002c24:	ec06                	sd	ra,24(sp)
    80002c26:	e822                	sd	s0,16(sp)
    80002c28:	e426                	sd	s1,8(sp)
    80002c2a:	1000                	add	s0,sp,32
    80002c2c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	eee080e7          	jalr	-274(ra) # 80002b1c <argraw>
    80002c36:	c088                	sw	a0,0(s1)
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6105                	add	sp,sp,32
    80002c40:	8082                	ret

0000000080002c42 <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    80002c42:	1101                	add	sp,sp,-32
    80002c44:	ec06                	sd	ra,24(sp)
    80002c46:	e822                	sd	s0,16(sp)
    80002c48:	e426                	sd	s1,8(sp)
    80002c4a:	1000                	add	s0,sp,32
    80002c4c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c4e:	00000097          	auipc	ra,0x0
    80002c52:	ece080e7          	jalr	-306(ra) # 80002b1c <argraw>
    80002c56:	e088                	sd	a0,0(s1)
}
    80002c58:	60e2                	ld	ra,24(sp)
    80002c5a:	6442                	ld	s0,16(sp)
    80002c5c:	64a2                	ld	s1,8(sp)
    80002c5e:	6105                	add	sp,sp,32
    80002c60:	8082                	ret

0000000080002c62 <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80002c62:	7179                	add	sp,sp,-48
    80002c64:	f406                	sd	ra,40(sp)
    80002c66:	f022                	sd	s0,32(sp)
    80002c68:	ec26                	sd	s1,24(sp)
    80002c6a:	e84a                	sd	s2,16(sp)
    80002c6c:	1800                	add	s0,sp,48
    80002c6e:	84ae                	mv	s1,a1
    80002c70:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c72:	fd840593          	add	a1,s0,-40
    80002c76:	00000097          	auipc	ra,0x0
    80002c7a:	fcc080e7          	jalr	-52(ra) # 80002c42 <argaddr>
  return fetchstr(addr, buf, max);
    80002c7e:	864a                	mv	a2,s2
    80002c80:	85a6                	mv	a1,s1
    80002c82:	fd843503          	ld	a0,-40(s0)
    80002c86:	00000097          	auipc	ra,0x0
    80002c8a:	f50080e7          	jalr	-176(ra) # 80002bd6 <fetchstr>
}
    80002c8e:	70a2                	ld	ra,40(sp)
    80002c90:	7402                	ld	s0,32(sp)
    80002c92:	64e2                	ld	s1,24(sp)
    80002c94:	6942                	ld	s2,16(sp)
    80002c96:	6145                	add	sp,sp,48
    80002c98:	8082                	ret

0000000080002c9a <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002c9a:	1101                	add	sp,sp,-32
    80002c9c:	ec06                	sd	ra,24(sp)
    80002c9e:	e822                	sd	s0,16(sp)
    80002ca0:	e426                	sd	s1,8(sp)
    80002ca2:	e04a                	sd	s2,0(sp)
    80002ca4:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ca6:	fffff097          	auipc	ra,0xfffff
    80002caa:	e5e080e7          	jalr	-418(ra) # 80001b04 <myproc>
    80002cae:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002cb0:	06053903          	ld	s2,96(a0)
    80002cb4:	0a893783          	ld	a5,168(s2)
    80002cb8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cbc:	37fd                	addw	a5,a5,-1
    80002cbe:	4751                	li	a4,20
    80002cc0:	00f76f63          	bltu	a4,a5,80002cde <syscall+0x44>
    80002cc4:	00369713          	sll	a4,a3,0x3
    80002cc8:	00005797          	auipc	a5,0x5
    80002ccc:	7c878793          	add	a5,a5,1992 # 80008490 <syscalls>
    80002cd0:	97ba                	add	a5,a5,a4
    80002cd2:	639c                	ld	a5,0(a5)
    80002cd4:	c789                	beqz	a5,80002cde <syscall+0x44>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    80002cd6:	9782                	jalr	a5
    80002cd8:	06a93823          	sd	a0,112(s2)
    80002cdc:	a839                	j	80002cfa <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002cde:	16048613          	add	a2,s1,352
    80002ce2:	588c                	lw	a1,48(s1)
    80002ce4:	00005517          	auipc	a0,0x5
    80002ce8:	77450513          	add	a0,a0,1908 # 80008458 <states.0+0x158>
    80002cec:	ffffe097          	auipc	ra,0xffffe
    80002cf0:	816080e7          	jalr	-2026(ra) # 80000502 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002cf4:	70bc                	ld	a5,96(s1)
    80002cf6:	577d                	li	a4,-1
    80002cf8:	fbb8                	sd	a4,112(a5)
  }
}
    80002cfa:	60e2                	ld	ra,24(sp)
    80002cfc:	6442                	ld	s0,16(sp)
    80002cfe:	64a2                	ld	s1,8(sp)
    80002d00:	6902                	ld	s2,0(sp)
    80002d02:	6105                	add	sp,sp,32
    80002d04:	8082                	ret

0000000080002d06 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d06:	1101                	add	sp,sp,-32
    80002d08:	ec06                	sd	ra,24(sp)
    80002d0a:	e822                	sd	s0,16(sp)
    80002d0c:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002d0e:	fec40593          	add	a1,s0,-20
    80002d12:	4501                	li	a0,0
    80002d14:	00000097          	auipc	ra,0x0
    80002d18:	f0e080e7          	jalr	-242(ra) # 80002c22 <argint>
  exit(n);
    80002d1c:	fec42503          	lw	a0,-20(s0)
    80002d20:	fffff097          	auipc	ra,0xfffff
    80002d24:	5e4080e7          	jalr	1508(ra) # 80002304 <exit>
  return 0;  /* not reached */
}
    80002d28:	4501                	li	a0,0
    80002d2a:	60e2                	ld	ra,24(sp)
    80002d2c:	6442                	ld	s0,16(sp)
    80002d2e:	6105                	add	sp,sp,32
    80002d30:	8082                	ret

0000000080002d32 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d32:	1141                	add	sp,sp,-16
    80002d34:	e406                	sd	ra,8(sp)
    80002d36:	e022                	sd	s0,0(sp)
    80002d38:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002d3a:	fffff097          	auipc	ra,0xfffff
    80002d3e:	dca080e7          	jalr	-566(ra) # 80001b04 <myproc>
}
    80002d42:	5908                	lw	a0,48(a0)
    80002d44:	60a2                	ld	ra,8(sp)
    80002d46:	6402                	ld	s0,0(sp)
    80002d48:	0141                	add	sp,sp,16
    80002d4a:	8082                	ret

0000000080002d4c <sys_fork>:

uint64
sys_fork(void)
{
    80002d4c:	1141                	add	sp,sp,-16
    80002d4e:	e406                	sd	ra,8(sp)
    80002d50:	e022                	sd	s0,0(sp)
    80002d52:	0800                	add	s0,sp,16
  return fork();
    80002d54:	fffff097          	auipc	ra,0xfffff
    80002d58:	16a080e7          	jalr	362(ra) # 80001ebe <fork>
}
    80002d5c:	60a2                	ld	ra,8(sp)
    80002d5e:	6402                	ld	s0,0(sp)
    80002d60:	0141                	add	sp,sp,16
    80002d62:	8082                	ret

0000000080002d64 <sys_wait>:

uint64
sys_wait(void)
{
    80002d64:	1101                	add	sp,sp,-32
    80002d66:	ec06                	sd	ra,24(sp)
    80002d68:	e822                	sd	s0,16(sp)
    80002d6a:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d6c:	fe840593          	add	a1,s0,-24
    80002d70:	4501                	li	a0,0
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	ed0080e7          	jalr	-304(ra) # 80002c42 <argaddr>
  return wait(p);
    80002d7a:	fe843503          	ld	a0,-24(s0)
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	72c080e7          	jalr	1836(ra) # 800024aa <wait>
}
    80002d86:	60e2                	ld	ra,24(sp)
    80002d88:	6442                	ld	s0,16(sp)
    80002d8a:	6105                	add	sp,sp,32
    80002d8c:	8082                	ret

0000000080002d8e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d8e:	7179                	add	sp,sp,-48
    80002d90:	f406                	sd	ra,40(sp)
    80002d92:	f022                	sd	s0,32(sp)
    80002d94:	ec26                	sd	s1,24(sp)
    80002d96:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d98:	fdc40593          	add	a1,s0,-36
    80002d9c:	4501                	li	a0,0
    80002d9e:	00000097          	auipc	ra,0x0
    80002da2:	e84080e7          	jalr	-380(ra) # 80002c22 <argint>
  addr = myproc()->sz;
    80002da6:	fffff097          	auipc	ra,0xfffff
    80002daa:	d5e080e7          	jalr	-674(ra) # 80001b04 <myproc>
    80002dae:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002db0:	fdc42503          	lw	a0,-36(s0)
    80002db4:	fffff097          	auipc	ra,0xfffff
    80002db8:	0ae080e7          	jalr	174(ra) # 80001e62 <growproc>
    80002dbc:	00054863          	bltz	a0,80002dcc <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002dc0:	8526                	mv	a0,s1
    80002dc2:	70a2                	ld	ra,40(sp)
    80002dc4:	7402                	ld	s0,32(sp)
    80002dc6:	64e2                	ld	s1,24(sp)
    80002dc8:	6145                	add	sp,sp,48
    80002dca:	8082                	ret
    return -1;
    80002dcc:	54fd                	li	s1,-1
    80002dce:	bfcd                	j	80002dc0 <sys_sbrk+0x32>

0000000080002dd0 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dd0:	7139                	add	sp,sp,-64
    80002dd2:	fc06                	sd	ra,56(sp)
    80002dd4:	f822                	sd	s0,48(sp)
    80002dd6:	f426                	sd	s1,40(sp)
    80002dd8:	f04a                	sd	s2,32(sp)
    80002dda:	ec4e                	sd	s3,24(sp)
    80002ddc:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002dde:	fcc40593          	add	a1,s0,-52
    80002de2:	4501                	li	a0,0
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	e3e080e7          	jalr	-450(ra) # 80002c22 <argint>
  if(n < 0)
    80002dec:	fcc42783          	lw	a5,-52(s0)
    80002df0:	0607cf63          	bltz	a5,80002e6e <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002df4:	00014517          	auipc	a0,0x14
    80002df8:	c6c50513          	add	a0,a0,-916 # 80016a60 <tickslock>
    80002dfc:	ffffe097          	auipc	ra,0xffffe
    80002e00:	ed0080e7          	jalr	-304(ra) # 80000ccc <acquire>
  ticks0 = ticks;
    80002e04:	00006917          	auipc	s2,0x6
    80002e08:	afc92903          	lw	s2,-1284(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002e0c:	fcc42783          	lw	a5,-52(s0)
    80002e10:	cf9d                	beqz	a5,80002e4e <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e12:	00014997          	auipc	s3,0x14
    80002e16:	c4e98993          	add	s3,s3,-946 # 80016a60 <tickslock>
    80002e1a:	00006497          	auipc	s1,0x6
    80002e1e:	ae648493          	add	s1,s1,-1306 # 80008900 <ticks>
    if(killed(myproc())){
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	ce2080e7          	jalr	-798(ra) # 80001b04 <myproc>
    80002e2a:	fffff097          	auipc	ra,0xfffff
    80002e2e:	64e080e7          	jalr	1614(ra) # 80002478 <killed>
    80002e32:	e129                	bnez	a0,80002e74 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002e34:	85ce                	mv	a1,s3
    80002e36:	8526                	mv	a0,s1
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	398080e7          	jalr	920(ra) # 800021d0 <sleep>
  while(ticks - ticks0 < n){
    80002e40:	409c                	lw	a5,0(s1)
    80002e42:	412787bb          	subw	a5,a5,s2
    80002e46:	fcc42703          	lw	a4,-52(s0)
    80002e4a:	fce7ece3          	bltu	a5,a4,80002e22 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002e4e:	00014517          	auipc	a0,0x14
    80002e52:	c1250513          	add	a0,a0,-1006 # 80016a60 <tickslock>
    80002e56:	ffffe097          	auipc	ra,0xffffe
    80002e5a:	f2a080e7          	jalr	-214(ra) # 80000d80 <release>
  return 0;
    80002e5e:	4501                	li	a0,0
}
    80002e60:	70e2                	ld	ra,56(sp)
    80002e62:	7442                	ld	s0,48(sp)
    80002e64:	74a2                	ld	s1,40(sp)
    80002e66:	7902                	ld	s2,32(sp)
    80002e68:	69e2                	ld	s3,24(sp)
    80002e6a:	6121                	add	sp,sp,64
    80002e6c:	8082                	ret
    n = 0;
    80002e6e:	fc042623          	sw	zero,-52(s0)
    80002e72:	b749                	j	80002df4 <sys_sleep+0x24>
      release(&tickslock);
    80002e74:	00014517          	auipc	a0,0x14
    80002e78:	bec50513          	add	a0,a0,-1044 # 80016a60 <tickslock>
    80002e7c:	ffffe097          	auipc	ra,0xffffe
    80002e80:	f04080e7          	jalr	-252(ra) # 80000d80 <release>
      return -1;
    80002e84:	557d                	li	a0,-1
    80002e86:	bfe9                	j	80002e60 <sys_sleep+0x90>

0000000080002e88 <sys_kill>:

uint64
sys_kill(void)
{
    80002e88:	1101                	add	sp,sp,-32
    80002e8a:	ec06                	sd	ra,24(sp)
    80002e8c:	e822                	sd	s0,16(sp)
    80002e8e:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e90:	fec40593          	add	a1,s0,-20
    80002e94:	4501                	li	a0,0
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	d8c080e7          	jalr	-628(ra) # 80002c22 <argint>
  return kill(pid);
    80002e9e:	fec42503          	lw	a0,-20(s0)
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	538080e7          	jalr	1336(ra) # 800023da <kill>
}
    80002eaa:	60e2                	ld	ra,24(sp)
    80002eac:	6442                	ld	s0,16(sp)
    80002eae:	6105                	add	sp,sp,32
    80002eb0:	8082                	ret

0000000080002eb2 <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    80002eb2:	1101                	add	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	e426                	sd	s1,8(sp)
    80002eba:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ebc:	00014517          	auipc	a0,0x14
    80002ec0:	ba450513          	add	a0,a0,-1116 # 80016a60 <tickslock>
    80002ec4:	ffffe097          	auipc	ra,0xffffe
    80002ec8:	e08080e7          	jalr	-504(ra) # 80000ccc <acquire>
  xticks = ticks;
    80002ecc:	00006497          	auipc	s1,0x6
    80002ed0:	a344a483          	lw	s1,-1484(s1) # 80008900 <ticks>
  release(&tickslock);
    80002ed4:	00014517          	auipc	a0,0x14
    80002ed8:	b8c50513          	add	a0,a0,-1140 # 80016a60 <tickslock>
    80002edc:	ffffe097          	auipc	ra,0xffffe
    80002ee0:	ea4080e7          	jalr	-348(ra) # 80000d80 <release>
  return xticks;
}
    80002ee4:	02049513          	sll	a0,s1,0x20
    80002ee8:	9101                	srl	a0,a0,0x20
    80002eea:	60e2                	ld	ra,24(sp)
    80002eec:	6442                	ld	s0,16(sp)
    80002eee:	64a2                	ld	s1,8(sp)
    80002ef0:	6105                	add	sp,sp,32
    80002ef2:	8082                	ret

0000000080002ef4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ef4:	7179                	add	sp,sp,-48
    80002ef6:	f406                	sd	ra,40(sp)
    80002ef8:	f022                	sd	s0,32(sp)
    80002efa:	ec26                	sd	s1,24(sp)
    80002efc:	e84a                	sd	s2,16(sp)
    80002efe:	e44e                	sd	s3,8(sp)
    80002f00:	e052                	sd	s4,0(sp)
    80002f02:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f04:	00005597          	auipc	a1,0x5
    80002f08:	63c58593          	add	a1,a1,1596 # 80008540 <syscalls+0xb0>
    80002f0c:	00014517          	auipc	a0,0x14
    80002f10:	b6c50513          	add	a0,a0,-1172 # 80016a78 <bcache>
    80002f14:	ffffe097          	auipc	ra,0xffffe
    80002f18:	d28080e7          	jalr	-728(ra) # 80000c3c <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    80002f1c:	0001c797          	auipc	a5,0x1c
    80002f20:	b5c78793          	add	a5,a5,-1188 # 8001ea78 <bcache+0x8000>
    80002f24:	0001c717          	auipc	a4,0x1c
    80002f28:	dbc70713          	add	a4,a4,-580 # 8001ece0 <bcache+0x8268>
    80002f2c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f30:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f34:	00014497          	auipc	s1,0x14
    80002f38:	b5c48493          	add	s1,s1,-1188 # 80016a90 <bcache+0x18>
    b->next = bcache.head.next;
    80002f3c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f3e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f40:	00005a17          	auipc	s4,0x5
    80002f44:	608a0a13          	add	s4,s4,1544 # 80008548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002f48:	2b893783          	ld	a5,696(s2)
    80002f4c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f4e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f52:	85d2                	mv	a1,s4
    80002f54:	01048513          	add	a0,s1,16
    80002f58:	00001097          	auipc	ra,0x1
    80002f5c:	496080e7          	jalr	1174(ra) # 800043ee <initsleeplock>
    bcache.head.next->prev = b;
    80002f60:	2b893783          	ld	a5,696(s2)
    80002f64:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f66:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f6a:	45848493          	add	s1,s1,1112
    80002f6e:	fd349de3          	bne	s1,s3,80002f48 <binit+0x54>
  }
}
    80002f72:	70a2                	ld	ra,40(sp)
    80002f74:	7402                	ld	s0,32(sp)
    80002f76:	64e2                	ld	s1,24(sp)
    80002f78:	6942                	ld	s2,16(sp)
    80002f7a:	69a2                	ld	s3,8(sp)
    80002f7c:	6a02                	ld	s4,0(sp)
    80002f7e:	6145                	add	sp,sp,48
    80002f80:	8082                	ret

0000000080002f82 <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    80002f82:	7179                	add	sp,sp,-48
    80002f84:	f406                	sd	ra,40(sp)
    80002f86:	f022                	sd	s0,32(sp)
    80002f88:	ec26                	sd	s1,24(sp)
    80002f8a:	e84a                	sd	s2,16(sp)
    80002f8c:	e44e                	sd	s3,8(sp)
    80002f8e:	1800                	add	s0,sp,48
    80002f90:	892a                	mv	s2,a0
    80002f92:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f94:	00014517          	auipc	a0,0x14
    80002f98:	ae450513          	add	a0,a0,-1308 # 80016a78 <bcache>
    80002f9c:	ffffe097          	auipc	ra,0xffffe
    80002fa0:	d30080e7          	jalr	-720(ra) # 80000ccc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002fa4:	0001c497          	auipc	s1,0x1c
    80002fa8:	d8c4b483          	ld	s1,-628(s1) # 8001ed30 <bcache+0x82b8>
    80002fac:	0001c797          	auipc	a5,0x1c
    80002fb0:	d3478793          	add	a5,a5,-716 # 8001ece0 <bcache+0x8268>
    80002fb4:	02f48f63          	beq	s1,a5,80002ff2 <bread+0x70>
    80002fb8:	873e                	mv	a4,a5
    80002fba:	a021                	j	80002fc2 <bread+0x40>
    80002fbc:	68a4                	ld	s1,80(s1)
    80002fbe:	02e48a63          	beq	s1,a4,80002ff2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002fc2:	449c                	lw	a5,8(s1)
    80002fc4:	ff279ce3          	bne	a5,s2,80002fbc <bread+0x3a>
    80002fc8:	44dc                	lw	a5,12(s1)
    80002fca:	ff3799e3          	bne	a5,s3,80002fbc <bread+0x3a>
      b->refcnt++;
    80002fce:	40bc                	lw	a5,64(s1)
    80002fd0:	2785                	addw	a5,a5,1
    80002fd2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fd4:	00014517          	auipc	a0,0x14
    80002fd8:	aa450513          	add	a0,a0,-1372 # 80016a78 <bcache>
    80002fdc:	ffffe097          	auipc	ra,0xffffe
    80002fe0:	da4080e7          	jalr	-604(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    80002fe4:	01048513          	add	a0,s1,16
    80002fe8:	00001097          	auipc	ra,0x1
    80002fec:	440080e7          	jalr	1088(ra) # 80004428 <acquiresleep>
      return b;
    80002ff0:	a8b9                	j	8000304e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ff2:	0001c497          	auipc	s1,0x1c
    80002ff6:	d364b483          	ld	s1,-714(s1) # 8001ed28 <bcache+0x82b0>
    80002ffa:	0001c797          	auipc	a5,0x1c
    80002ffe:	ce678793          	add	a5,a5,-794 # 8001ece0 <bcache+0x8268>
    80003002:	00f48863          	beq	s1,a5,80003012 <bread+0x90>
    80003006:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003008:	40bc                	lw	a5,64(s1)
    8000300a:	cf81                	beqz	a5,80003022 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000300c:	64a4                	ld	s1,72(s1)
    8000300e:	fee49de3          	bne	s1,a4,80003008 <bread+0x86>
  panic("bget: no buffers");
    80003012:	00005517          	auipc	a0,0x5
    80003016:	53e50513          	add	a0,a0,1342 # 80008550 <syscalls+0xc0>
    8000301a:	ffffd097          	auipc	ra,0xffffd
    8000301e:	7f4080e7          	jalr	2036(ra) # 8000080e <panic>
      b->dev = dev;
    80003022:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003026:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000302a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000302e:	4785                	li	a5,1
    80003030:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003032:	00014517          	auipc	a0,0x14
    80003036:	a4650513          	add	a0,a0,-1466 # 80016a78 <bcache>
    8000303a:	ffffe097          	auipc	ra,0xffffe
    8000303e:	d46080e7          	jalr	-698(ra) # 80000d80 <release>
      acquiresleep(&b->lock);
    80003042:	01048513          	add	a0,s1,16
    80003046:	00001097          	auipc	ra,0x1
    8000304a:	3e2080e7          	jalr	994(ra) # 80004428 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000304e:	409c                	lw	a5,0(s1)
    80003050:	cb89                	beqz	a5,80003062 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003052:	8526                	mv	a0,s1
    80003054:	70a2                	ld	ra,40(sp)
    80003056:	7402                	ld	s0,32(sp)
    80003058:	64e2                	ld	s1,24(sp)
    8000305a:	6942                	ld	s2,16(sp)
    8000305c:	69a2                	ld	s3,8(sp)
    8000305e:	6145                	add	sp,sp,48
    80003060:	8082                	ret
    virtio_disk_rw(b, 0);
    80003062:	4581                	li	a1,0
    80003064:	8526                	mv	a0,s1
    80003066:	00003097          	auipc	ra,0x3
    8000306a:	f20080e7          	jalr	-224(ra) # 80005f86 <virtio_disk_rw>
    b->valid = 1;
    8000306e:	4785                	li	a5,1
    80003070:	c09c                	sw	a5,0(s1)
  return b;
    80003072:	b7c5                	j	80003052 <bread+0xd0>

0000000080003074 <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    80003074:	1101                	add	sp,sp,-32
    80003076:	ec06                	sd	ra,24(sp)
    80003078:	e822                	sd	s0,16(sp)
    8000307a:	e426                	sd	s1,8(sp)
    8000307c:	1000                	add	s0,sp,32
    8000307e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003080:	0541                	add	a0,a0,16
    80003082:	00001097          	auipc	ra,0x1
    80003086:	440080e7          	jalr	1088(ra) # 800044c2 <holdingsleep>
    8000308a:	cd01                	beqz	a0,800030a2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000308c:	4585                	li	a1,1
    8000308e:	8526                	mv	a0,s1
    80003090:	00003097          	auipc	ra,0x3
    80003094:	ef6080e7          	jalr	-266(ra) # 80005f86 <virtio_disk_rw>
}
    80003098:	60e2                	ld	ra,24(sp)
    8000309a:	6442                	ld	s0,16(sp)
    8000309c:	64a2                	ld	s1,8(sp)
    8000309e:	6105                	add	sp,sp,32
    800030a0:	8082                	ret
    panic("bwrite");
    800030a2:	00005517          	auipc	a0,0x5
    800030a6:	4c650513          	add	a0,a0,1222 # 80008568 <syscalls+0xd8>
    800030aa:	ffffd097          	auipc	ra,0xffffd
    800030ae:	764080e7          	jalr	1892(ra) # 8000080e <panic>

00000000800030b2 <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    800030b2:	1101                	add	sp,sp,-32
    800030b4:	ec06                	sd	ra,24(sp)
    800030b6:	e822                	sd	s0,16(sp)
    800030b8:	e426                	sd	s1,8(sp)
    800030ba:	e04a                	sd	s2,0(sp)
    800030bc:	1000                	add	s0,sp,32
    800030be:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030c0:	01050913          	add	s2,a0,16
    800030c4:	854a                	mv	a0,s2
    800030c6:	00001097          	auipc	ra,0x1
    800030ca:	3fc080e7          	jalr	1020(ra) # 800044c2 <holdingsleep>
    800030ce:	c925                	beqz	a0,8000313e <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800030d0:	854a                	mv	a0,s2
    800030d2:	00001097          	auipc	ra,0x1
    800030d6:	3ac080e7          	jalr	940(ra) # 8000447e <releasesleep>

  acquire(&bcache.lock);
    800030da:	00014517          	auipc	a0,0x14
    800030de:	99e50513          	add	a0,a0,-1634 # 80016a78 <bcache>
    800030e2:	ffffe097          	auipc	ra,0xffffe
    800030e6:	bea080e7          	jalr	-1046(ra) # 80000ccc <acquire>
  b->refcnt--;
    800030ea:	40bc                	lw	a5,64(s1)
    800030ec:	37fd                	addw	a5,a5,-1
    800030ee:	0007871b          	sext.w	a4,a5
    800030f2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030f4:	e71d                	bnez	a4,80003122 <brelse+0x70>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    800030f6:	68b8                	ld	a4,80(s1)
    800030f8:	64bc                	ld	a5,72(s1)
    800030fa:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800030fc:	68b8                	ld	a4,80(s1)
    800030fe:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003100:	0001c797          	auipc	a5,0x1c
    80003104:	97878793          	add	a5,a5,-1672 # 8001ea78 <bcache+0x8000>
    80003108:	2b87b703          	ld	a4,696(a5)
    8000310c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000310e:	0001c717          	auipc	a4,0x1c
    80003112:	bd270713          	add	a4,a4,-1070 # 8001ece0 <bcache+0x8268>
    80003116:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003118:	2b87b703          	ld	a4,696(a5)
    8000311c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000311e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003122:	00014517          	auipc	a0,0x14
    80003126:	95650513          	add	a0,a0,-1706 # 80016a78 <bcache>
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	c56080e7          	jalr	-938(ra) # 80000d80 <release>
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	64a2                	ld	s1,8(sp)
    80003138:	6902                	ld	s2,0(sp)
    8000313a:	6105                	add	sp,sp,32
    8000313c:	8082                	ret
    panic("brelse");
    8000313e:	00005517          	auipc	a0,0x5
    80003142:	43250513          	add	a0,a0,1074 # 80008570 <syscalls+0xe0>
    80003146:	ffffd097          	auipc	ra,0xffffd
    8000314a:	6c8080e7          	jalr	1736(ra) # 8000080e <panic>

000000008000314e <bpin>:

void
bpin(struct buf *b) {
    8000314e:	1101                	add	sp,sp,-32
    80003150:	ec06                	sd	ra,24(sp)
    80003152:	e822                	sd	s0,16(sp)
    80003154:	e426                	sd	s1,8(sp)
    80003156:	1000                	add	s0,sp,32
    80003158:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000315a:	00014517          	auipc	a0,0x14
    8000315e:	91e50513          	add	a0,a0,-1762 # 80016a78 <bcache>
    80003162:	ffffe097          	auipc	ra,0xffffe
    80003166:	b6a080e7          	jalr	-1174(ra) # 80000ccc <acquire>
  b->refcnt++;
    8000316a:	40bc                	lw	a5,64(s1)
    8000316c:	2785                	addw	a5,a5,1
    8000316e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003170:	00014517          	auipc	a0,0x14
    80003174:	90850513          	add	a0,a0,-1784 # 80016a78 <bcache>
    80003178:	ffffe097          	auipc	ra,0xffffe
    8000317c:	c08080e7          	jalr	-1016(ra) # 80000d80 <release>
}
    80003180:	60e2                	ld	ra,24(sp)
    80003182:	6442                	ld	s0,16(sp)
    80003184:	64a2                	ld	s1,8(sp)
    80003186:	6105                	add	sp,sp,32
    80003188:	8082                	ret

000000008000318a <bunpin>:

void
bunpin(struct buf *b) {
    8000318a:	1101                	add	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	1000                	add	s0,sp,32
    80003194:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003196:	00014517          	auipc	a0,0x14
    8000319a:	8e250513          	add	a0,a0,-1822 # 80016a78 <bcache>
    8000319e:	ffffe097          	auipc	ra,0xffffe
    800031a2:	b2e080e7          	jalr	-1234(ra) # 80000ccc <acquire>
  b->refcnt--;
    800031a6:	40bc                	lw	a5,64(s1)
    800031a8:	37fd                	addw	a5,a5,-1
    800031aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031ac:	00014517          	auipc	a0,0x14
    800031b0:	8cc50513          	add	a0,a0,-1844 # 80016a78 <bcache>
    800031b4:	ffffe097          	auipc	ra,0xffffe
    800031b8:	bcc080e7          	jalr	-1076(ra) # 80000d80 <release>
}
    800031bc:	60e2                	ld	ra,24(sp)
    800031be:	6442                	ld	s0,16(sp)
    800031c0:	64a2                	ld	s1,8(sp)
    800031c2:	6105                	add	sp,sp,32
    800031c4:	8082                	ret

00000000800031c6 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    800031c6:	1101                	add	sp,sp,-32
    800031c8:	ec06                	sd	ra,24(sp)
    800031ca:	e822                	sd	s0,16(sp)
    800031cc:	e426                	sd	s1,8(sp)
    800031ce:	e04a                	sd	s2,0(sp)
    800031d0:	1000                	add	s0,sp,32
    800031d2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031d4:	00d5d59b          	srlw	a1,a1,0xd
    800031d8:	0001c797          	auipc	a5,0x1c
    800031dc:	f7c7a783          	lw	a5,-132(a5) # 8001f154 <sb+0x1c>
    800031e0:	9dbd                	addw	a1,a1,a5
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	da0080e7          	jalr	-608(ra) # 80002f82 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031ea:	0074f713          	and	a4,s1,7
    800031ee:	4785                	li	a5,1
    800031f0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031f4:	14ce                	sll	s1,s1,0x33
    800031f6:	90d9                	srl	s1,s1,0x36
    800031f8:	00950733          	add	a4,a0,s1
    800031fc:	05874703          	lbu	a4,88(a4)
    80003200:	00e7f6b3          	and	a3,a5,a4
    80003204:	c69d                	beqz	a3,80003232 <bfree+0x6c>
    80003206:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003208:	94aa                	add	s1,s1,a0
    8000320a:	fff7c793          	not	a5,a5
    8000320e:	8f7d                	and	a4,a4,a5
    80003210:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003214:	00001097          	auipc	ra,0x1
    80003218:	0f6080e7          	jalr	246(ra) # 8000430a <log_write>
  brelse(bp);
    8000321c:	854a                	mv	a0,s2
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	e94080e7          	jalr	-364(ra) # 800030b2 <brelse>
}
    80003226:	60e2                	ld	ra,24(sp)
    80003228:	6442                	ld	s0,16(sp)
    8000322a:	64a2                	ld	s1,8(sp)
    8000322c:	6902                	ld	s2,0(sp)
    8000322e:	6105                	add	sp,sp,32
    80003230:	8082                	ret
    panic("freeing free block");
    80003232:	00005517          	auipc	a0,0x5
    80003236:	34650513          	add	a0,a0,838 # 80008578 <syscalls+0xe8>
    8000323a:	ffffd097          	auipc	ra,0xffffd
    8000323e:	5d4080e7          	jalr	1492(ra) # 8000080e <panic>

0000000080003242 <balloc>:
{
    80003242:	711d                	add	sp,sp,-96
    80003244:	ec86                	sd	ra,88(sp)
    80003246:	e8a2                	sd	s0,80(sp)
    80003248:	e4a6                	sd	s1,72(sp)
    8000324a:	e0ca                	sd	s2,64(sp)
    8000324c:	fc4e                	sd	s3,56(sp)
    8000324e:	f852                	sd	s4,48(sp)
    80003250:	f456                	sd	s5,40(sp)
    80003252:	f05a                	sd	s6,32(sp)
    80003254:	ec5e                	sd	s7,24(sp)
    80003256:	e862                	sd	s8,16(sp)
    80003258:	e466                	sd	s9,8(sp)
    8000325a:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000325c:	0001c797          	auipc	a5,0x1c
    80003260:	ee07a783          	lw	a5,-288(a5) # 8001f13c <sb+0x4>
    80003264:	cff5                	beqz	a5,80003360 <balloc+0x11e>
    80003266:	8baa                	mv	s7,a0
    80003268:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000326a:	0001cb17          	auipc	s6,0x1c
    8000326e:	eceb0b13          	add	s6,s6,-306 # 8001f138 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003272:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003274:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003276:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003278:	6c89                	lui	s9,0x2
    8000327a:	a061                	j	80003302 <balloc+0xc0>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    8000327c:	97ca                	add	a5,a5,s2
    8000327e:	8e55                	or	a2,a2,a3
    80003280:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003284:	854a                	mv	a0,s2
    80003286:	00001097          	auipc	ra,0x1
    8000328a:	084080e7          	jalr	132(ra) # 8000430a <log_write>
        brelse(bp);
    8000328e:	854a                	mv	a0,s2
    80003290:	00000097          	auipc	ra,0x0
    80003294:	e22080e7          	jalr	-478(ra) # 800030b2 <brelse>
  bp = bread(dev, bno);
    80003298:	85a6                	mv	a1,s1
    8000329a:	855e                	mv	a0,s7
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	ce6080e7          	jalr	-794(ra) # 80002f82 <bread>
    800032a4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032a6:	40000613          	li	a2,1024
    800032aa:	4581                	li	a1,0
    800032ac:	05850513          	add	a0,a0,88
    800032b0:	ffffe097          	auipc	ra,0xffffe
    800032b4:	b18080e7          	jalr	-1256(ra) # 80000dc8 <memset>
  log_write(bp);
    800032b8:	854a                	mv	a0,s2
    800032ba:	00001097          	auipc	ra,0x1
    800032be:	050080e7          	jalr	80(ra) # 8000430a <log_write>
  brelse(bp);
    800032c2:	854a                	mv	a0,s2
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	dee080e7          	jalr	-530(ra) # 800030b2 <brelse>
}
    800032cc:	8526                	mv	a0,s1
    800032ce:	60e6                	ld	ra,88(sp)
    800032d0:	6446                	ld	s0,80(sp)
    800032d2:	64a6                	ld	s1,72(sp)
    800032d4:	6906                	ld	s2,64(sp)
    800032d6:	79e2                	ld	s3,56(sp)
    800032d8:	7a42                	ld	s4,48(sp)
    800032da:	7aa2                	ld	s5,40(sp)
    800032dc:	7b02                	ld	s6,32(sp)
    800032de:	6be2                	ld	s7,24(sp)
    800032e0:	6c42                	ld	s8,16(sp)
    800032e2:	6ca2                	ld	s9,8(sp)
    800032e4:	6125                	add	sp,sp,96
    800032e6:	8082                	ret
    brelse(bp);
    800032e8:	854a                	mv	a0,s2
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	dc8080e7          	jalr	-568(ra) # 800030b2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800032f2:	015c87bb          	addw	a5,s9,s5
    800032f6:	00078a9b          	sext.w	s5,a5
    800032fa:	004b2703          	lw	a4,4(s6)
    800032fe:	06eaf163          	bgeu	s5,a4,80003360 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003302:	41fad79b          	sraw	a5,s5,0x1f
    80003306:	0137d79b          	srlw	a5,a5,0x13
    8000330a:	015787bb          	addw	a5,a5,s5
    8000330e:	40d7d79b          	sraw	a5,a5,0xd
    80003312:	01cb2583          	lw	a1,28(s6)
    80003316:	9dbd                	addw	a1,a1,a5
    80003318:	855e                	mv	a0,s7
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	c68080e7          	jalr	-920(ra) # 80002f82 <bread>
    80003322:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003324:	004b2503          	lw	a0,4(s6)
    80003328:	000a849b          	sext.w	s1,s5
    8000332c:	8762                	mv	a4,s8
    8000332e:	faa4fde3          	bgeu	s1,a0,800032e8 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003332:	00777693          	and	a3,a4,7
    80003336:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    8000333a:	41f7579b          	sraw	a5,a4,0x1f
    8000333e:	01d7d79b          	srlw	a5,a5,0x1d
    80003342:	9fb9                	addw	a5,a5,a4
    80003344:	4037d79b          	sraw	a5,a5,0x3
    80003348:	00f90633          	add	a2,s2,a5
    8000334c:	05864603          	lbu	a2,88(a2)
    80003350:	00c6f5b3          	and	a1,a3,a2
    80003354:	d585                	beqz	a1,8000327c <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003356:	2705                	addw	a4,a4,1
    80003358:	2485                	addw	s1,s1,1
    8000335a:	fd471ae3          	bne	a4,s4,8000332e <balloc+0xec>
    8000335e:	b769                	j	800032e8 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003360:	00005517          	auipc	a0,0x5
    80003364:	23050513          	add	a0,a0,560 # 80008590 <syscalls+0x100>
    80003368:	ffffd097          	auipc	ra,0xffffd
    8000336c:	19a080e7          	jalr	410(ra) # 80000502 <printf>
  return 0;
    80003370:	4481                	li	s1,0
    80003372:	bfa9                	j	800032cc <balloc+0x8a>

0000000080003374 <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    80003374:	7179                	add	sp,sp,-48
    80003376:	f406                	sd	ra,40(sp)
    80003378:	f022                	sd	s0,32(sp)
    8000337a:	ec26                	sd	s1,24(sp)
    8000337c:	e84a                	sd	s2,16(sp)
    8000337e:	e44e                	sd	s3,8(sp)
    80003380:	e052                	sd	s4,0(sp)
    80003382:	1800                	add	s0,sp,48
    80003384:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003386:	47ad                	li	a5,11
    80003388:	02b7e863          	bltu	a5,a1,800033b8 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000338c:	02059793          	sll	a5,a1,0x20
    80003390:	01e7d593          	srl	a1,a5,0x1e
    80003394:	00b504b3          	add	s1,a0,a1
    80003398:	0504a903          	lw	s2,80(s1)
    8000339c:	06091e63          	bnez	s2,80003418 <bmap+0xa4>
      addr = balloc(ip->dev);
    800033a0:	4108                	lw	a0,0(a0)
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	ea0080e7          	jalr	-352(ra) # 80003242 <balloc>
    800033aa:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033ae:	06090563          	beqz	s2,80003418 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800033b2:	0524a823          	sw	s2,80(s1)
    800033b6:	a08d                	j	80003418 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800033b8:	ff45849b          	addw	s1,a1,-12
    800033bc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800033c0:	0ff00793          	li	a5,255
    800033c4:	08e7e563          	bltu	a5,a4,8000344e <bmap+0xda>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    800033c8:	08052903          	lw	s2,128(a0)
    800033cc:	00091d63          	bnez	s2,800033e6 <bmap+0x72>
      addr = balloc(ip->dev);
    800033d0:	4108                	lw	a0,0(a0)
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	e70080e7          	jalr	-400(ra) # 80003242 <balloc>
    800033da:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800033de:	02090d63          	beqz	s2,80003418 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800033e2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800033e6:	85ca                	mv	a1,s2
    800033e8:	0009a503          	lw	a0,0(s3)
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	b96080e7          	jalr	-1130(ra) # 80002f82 <bread>
    800033f4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800033f6:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800033fa:	02049713          	sll	a4,s1,0x20
    800033fe:	01e75593          	srl	a1,a4,0x1e
    80003402:	00b784b3          	add	s1,a5,a1
    80003406:	0004a903          	lw	s2,0(s1)
    8000340a:	02090063          	beqz	s2,8000342a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000340e:	8552                	mv	a0,s4
    80003410:	00000097          	auipc	ra,0x0
    80003414:	ca2080e7          	jalr	-862(ra) # 800030b2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003418:	854a                	mv	a0,s2
    8000341a:	70a2                	ld	ra,40(sp)
    8000341c:	7402                	ld	s0,32(sp)
    8000341e:	64e2                	ld	s1,24(sp)
    80003420:	6942                	ld	s2,16(sp)
    80003422:	69a2                	ld	s3,8(sp)
    80003424:	6a02                	ld	s4,0(sp)
    80003426:	6145                	add	sp,sp,48
    80003428:	8082                	ret
      addr = balloc(ip->dev);
    8000342a:	0009a503          	lw	a0,0(s3)
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	e14080e7          	jalr	-492(ra) # 80003242 <balloc>
    80003436:	0005091b          	sext.w	s2,a0
      if(addr){
    8000343a:	fc090ae3          	beqz	s2,8000340e <bmap+0x9a>
        a[bn] = addr;
    8000343e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003442:	8552                	mv	a0,s4
    80003444:	00001097          	auipc	ra,0x1
    80003448:	ec6080e7          	jalr	-314(ra) # 8000430a <log_write>
    8000344c:	b7c9                	j	8000340e <bmap+0x9a>
  panic("bmap: out of range");
    8000344e:	00005517          	auipc	a0,0x5
    80003452:	15a50513          	add	a0,a0,346 # 800085a8 <syscalls+0x118>
    80003456:	ffffd097          	auipc	ra,0xffffd
    8000345a:	3b8080e7          	jalr	952(ra) # 8000080e <panic>

000000008000345e <iget>:
{
    8000345e:	7179                	add	sp,sp,-48
    80003460:	f406                	sd	ra,40(sp)
    80003462:	f022                	sd	s0,32(sp)
    80003464:	ec26                	sd	s1,24(sp)
    80003466:	e84a                	sd	s2,16(sp)
    80003468:	e44e                	sd	s3,8(sp)
    8000346a:	e052                	sd	s4,0(sp)
    8000346c:	1800                	add	s0,sp,48
    8000346e:	89aa                	mv	s3,a0
    80003470:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003472:	0001c517          	auipc	a0,0x1c
    80003476:	ce650513          	add	a0,a0,-794 # 8001f158 <itable>
    8000347a:	ffffe097          	auipc	ra,0xffffe
    8000347e:	852080e7          	jalr	-1966(ra) # 80000ccc <acquire>
  empty = 0;
    80003482:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003484:	0001c497          	auipc	s1,0x1c
    80003488:	cec48493          	add	s1,s1,-788 # 8001f170 <itable+0x18>
    8000348c:	0001d697          	auipc	a3,0x1d
    80003490:	77468693          	add	a3,a3,1908 # 80020c00 <log>
    80003494:	a039                	j	800034a2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80003496:	02090b63          	beqz	s2,800034cc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000349a:	08848493          	add	s1,s1,136
    8000349e:	02d48a63          	beq	s1,a3,800034d2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034a2:	449c                	lw	a5,8(s1)
    800034a4:	fef059e3          	blez	a5,80003496 <iget+0x38>
    800034a8:	4098                	lw	a4,0(s1)
    800034aa:	ff3716e3          	bne	a4,s3,80003496 <iget+0x38>
    800034ae:	40d8                	lw	a4,4(s1)
    800034b0:	ff4713e3          	bne	a4,s4,80003496 <iget+0x38>
      ip->ref++;
    800034b4:	2785                	addw	a5,a5,1
    800034b6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800034b8:	0001c517          	auipc	a0,0x1c
    800034bc:	ca050513          	add	a0,a0,-864 # 8001f158 <itable>
    800034c0:	ffffe097          	auipc	ra,0xffffe
    800034c4:	8c0080e7          	jalr	-1856(ra) # 80000d80 <release>
      return ip;
    800034c8:	8926                	mv	s2,s1
    800034ca:	a03d                	j	800034f8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    800034cc:	f7f9                	bnez	a5,8000349a <iget+0x3c>
    800034ce:	8926                	mv	s2,s1
    800034d0:	b7e9                	j	8000349a <iget+0x3c>
  if(empty == 0)
    800034d2:	02090c63          	beqz	s2,8000350a <iget+0xac>
  ip->dev = dev;
    800034d6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034da:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034de:	4785                	li	a5,1
    800034e0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034e4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800034e8:	0001c517          	auipc	a0,0x1c
    800034ec:	c7050513          	add	a0,a0,-912 # 8001f158 <itable>
    800034f0:	ffffe097          	auipc	ra,0xffffe
    800034f4:	890080e7          	jalr	-1904(ra) # 80000d80 <release>
}
    800034f8:	854a                	mv	a0,s2
    800034fa:	70a2                	ld	ra,40(sp)
    800034fc:	7402                	ld	s0,32(sp)
    800034fe:	64e2                	ld	s1,24(sp)
    80003500:	6942                	ld	s2,16(sp)
    80003502:	69a2                	ld	s3,8(sp)
    80003504:	6a02                	ld	s4,0(sp)
    80003506:	6145                	add	sp,sp,48
    80003508:	8082                	ret
    panic("iget: no inodes");
    8000350a:	00005517          	auipc	a0,0x5
    8000350e:	0b650513          	add	a0,a0,182 # 800085c0 <syscalls+0x130>
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	2fc080e7          	jalr	764(ra) # 8000080e <panic>

000000008000351a <fsinit>:
fsinit(int dev) {
    8000351a:	7179                	add	sp,sp,-48
    8000351c:	f406                	sd	ra,40(sp)
    8000351e:	f022                	sd	s0,32(sp)
    80003520:	ec26                	sd	s1,24(sp)
    80003522:	e84a                	sd	s2,16(sp)
    80003524:	e44e                	sd	s3,8(sp)
    80003526:	1800                	add	s0,sp,48
    80003528:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000352a:	4585                	li	a1,1
    8000352c:	00000097          	auipc	ra,0x0
    80003530:	a56080e7          	jalr	-1450(ra) # 80002f82 <bread>
    80003534:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003536:	0001c997          	auipc	s3,0x1c
    8000353a:	c0298993          	add	s3,s3,-1022 # 8001f138 <sb>
    8000353e:	02000613          	li	a2,32
    80003542:	05850593          	add	a1,a0,88
    80003546:	854e                	mv	a0,s3
    80003548:	ffffe097          	auipc	ra,0xffffe
    8000354c:	8dc080e7          	jalr	-1828(ra) # 80000e24 <memmove>
  brelse(bp);
    80003550:	8526                	mv	a0,s1
    80003552:	00000097          	auipc	ra,0x0
    80003556:	b60080e7          	jalr	-1184(ra) # 800030b2 <brelse>
  if(sb.magic != FSMAGIC)
    8000355a:	0009a703          	lw	a4,0(s3)
    8000355e:	102037b7          	lui	a5,0x10203
    80003562:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003566:	02f71263          	bne	a4,a5,8000358a <fsinit+0x70>
  initlog(dev, &sb);
    8000356a:	0001c597          	auipc	a1,0x1c
    8000356e:	bce58593          	add	a1,a1,-1074 # 8001f138 <sb>
    80003572:	854a                	mv	a0,s2
    80003574:	00001097          	auipc	ra,0x1
    80003578:	b2c080e7          	jalr	-1236(ra) # 800040a0 <initlog>
}
    8000357c:	70a2                	ld	ra,40(sp)
    8000357e:	7402                	ld	s0,32(sp)
    80003580:	64e2                	ld	s1,24(sp)
    80003582:	6942                	ld	s2,16(sp)
    80003584:	69a2                	ld	s3,8(sp)
    80003586:	6145                	add	sp,sp,48
    80003588:	8082                	ret
    panic("invalid file system");
    8000358a:	00005517          	auipc	a0,0x5
    8000358e:	04650513          	add	a0,a0,70 # 800085d0 <syscalls+0x140>
    80003592:	ffffd097          	auipc	ra,0xffffd
    80003596:	27c080e7          	jalr	636(ra) # 8000080e <panic>

000000008000359a <iinit>:
{
    8000359a:	7179                	add	sp,sp,-48
    8000359c:	f406                	sd	ra,40(sp)
    8000359e:	f022                	sd	s0,32(sp)
    800035a0:	ec26                	sd	s1,24(sp)
    800035a2:	e84a                	sd	s2,16(sp)
    800035a4:	e44e                	sd	s3,8(sp)
    800035a6:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    800035a8:	00005597          	auipc	a1,0x5
    800035ac:	04058593          	add	a1,a1,64 # 800085e8 <syscalls+0x158>
    800035b0:	0001c517          	auipc	a0,0x1c
    800035b4:	ba850513          	add	a0,a0,-1112 # 8001f158 <itable>
    800035b8:	ffffd097          	auipc	ra,0xffffd
    800035bc:	684080e7          	jalr	1668(ra) # 80000c3c <initlock>
  for(i = 0; i < NINODE; i++) {
    800035c0:	0001c497          	auipc	s1,0x1c
    800035c4:	bc048493          	add	s1,s1,-1088 # 8001f180 <itable+0x28>
    800035c8:	0001d997          	auipc	s3,0x1d
    800035cc:	64898993          	add	s3,s3,1608 # 80020c10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800035d0:	00005917          	auipc	s2,0x5
    800035d4:	02090913          	add	s2,s2,32 # 800085f0 <syscalls+0x160>
    800035d8:	85ca                	mv	a1,s2
    800035da:	8526                	mv	a0,s1
    800035dc:	00001097          	auipc	ra,0x1
    800035e0:	e12080e7          	jalr	-494(ra) # 800043ee <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800035e4:	08848493          	add	s1,s1,136
    800035e8:	ff3498e3          	bne	s1,s3,800035d8 <iinit+0x3e>
}
    800035ec:	70a2                	ld	ra,40(sp)
    800035ee:	7402                	ld	s0,32(sp)
    800035f0:	64e2                	ld	s1,24(sp)
    800035f2:	6942                	ld	s2,16(sp)
    800035f4:	69a2                	ld	s3,8(sp)
    800035f6:	6145                	add	sp,sp,48
    800035f8:	8082                	ret

00000000800035fa <ialloc>:
{
    800035fa:	7139                	add	sp,sp,-64
    800035fc:	fc06                	sd	ra,56(sp)
    800035fe:	f822                	sd	s0,48(sp)
    80003600:	f426                	sd	s1,40(sp)
    80003602:	f04a                	sd	s2,32(sp)
    80003604:	ec4e                	sd	s3,24(sp)
    80003606:	e852                	sd	s4,16(sp)
    80003608:	e456                	sd	s5,8(sp)
    8000360a:	e05a                	sd	s6,0(sp)
    8000360c:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000360e:	0001c717          	auipc	a4,0x1c
    80003612:	b3672703          	lw	a4,-1226(a4) # 8001f144 <sb+0xc>
    80003616:	4785                	li	a5,1
    80003618:	04e7f863          	bgeu	a5,a4,80003668 <ialloc+0x6e>
    8000361c:	8aaa                	mv	s5,a0
    8000361e:	8b2e                	mv	s6,a1
    80003620:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003622:	0001ca17          	auipc	s4,0x1c
    80003626:	b16a0a13          	add	s4,s4,-1258 # 8001f138 <sb>
    8000362a:	00495593          	srl	a1,s2,0x4
    8000362e:	018a2783          	lw	a5,24(s4)
    80003632:	9dbd                	addw	a1,a1,a5
    80003634:	8556                	mv	a0,s5
    80003636:	00000097          	auipc	ra,0x0
    8000363a:	94c080e7          	jalr	-1716(ra) # 80002f82 <bread>
    8000363e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003640:	05850993          	add	s3,a0,88
    80003644:	00f97793          	and	a5,s2,15
    80003648:	079a                	sll	a5,a5,0x6
    8000364a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    8000364c:	00099783          	lh	a5,0(s3)
    80003650:	cf9d                	beqz	a5,8000368e <ialloc+0x94>
    brelse(bp);
    80003652:	00000097          	auipc	ra,0x0
    80003656:	a60080e7          	jalr	-1440(ra) # 800030b2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000365a:	0905                	add	s2,s2,1
    8000365c:	00ca2703          	lw	a4,12(s4)
    80003660:	0009079b          	sext.w	a5,s2
    80003664:	fce7e3e3          	bltu	a5,a4,8000362a <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003668:	00005517          	auipc	a0,0x5
    8000366c:	f9050513          	add	a0,a0,-112 # 800085f8 <syscalls+0x168>
    80003670:	ffffd097          	auipc	ra,0xffffd
    80003674:	e92080e7          	jalr	-366(ra) # 80000502 <printf>
  return 0;
    80003678:	4501                	li	a0,0
}
    8000367a:	70e2                	ld	ra,56(sp)
    8000367c:	7442                	ld	s0,48(sp)
    8000367e:	74a2                	ld	s1,40(sp)
    80003680:	7902                	ld	s2,32(sp)
    80003682:	69e2                	ld	s3,24(sp)
    80003684:	6a42                	ld	s4,16(sp)
    80003686:	6aa2                	ld	s5,8(sp)
    80003688:	6b02                	ld	s6,0(sp)
    8000368a:	6121                	add	sp,sp,64
    8000368c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000368e:	04000613          	li	a2,64
    80003692:	4581                	li	a1,0
    80003694:	854e                	mv	a0,s3
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	732080e7          	jalr	1842(ra) # 80000dc8 <memset>
      dip->type = type;
    8000369e:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    800036a2:	8526                	mv	a0,s1
    800036a4:	00001097          	auipc	ra,0x1
    800036a8:	c66080e7          	jalr	-922(ra) # 8000430a <log_write>
      brelse(bp);
    800036ac:	8526                	mv	a0,s1
    800036ae:	00000097          	auipc	ra,0x0
    800036b2:	a04080e7          	jalr	-1532(ra) # 800030b2 <brelse>
      return iget(dev, inum);
    800036b6:	0009059b          	sext.w	a1,s2
    800036ba:	8556                	mv	a0,s5
    800036bc:	00000097          	auipc	ra,0x0
    800036c0:	da2080e7          	jalr	-606(ra) # 8000345e <iget>
    800036c4:	bf5d                	j	8000367a <ialloc+0x80>

00000000800036c6 <iupdate>:
{
    800036c6:	1101                	add	sp,sp,-32
    800036c8:	ec06                	sd	ra,24(sp)
    800036ca:	e822                	sd	s0,16(sp)
    800036cc:	e426                	sd	s1,8(sp)
    800036ce:	e04a                	sd	s2,0(sp)
    800036d0:	1000                	add	s0,sp,32
    800036d2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036d4:	415c                	lw	a5,4(a0)
    800036d6:	0047d79b          	srlw	a5,a5,0x4
    800036da:	0001c597          	auipc	a1,0x1c
    800036de:	a765a583          	lw	a1,-1418(a1) # 8001f150 <sb+0x18>
    800036e2:	9dbd                	addw	a1,a1,a5
    800036e4:	4108                	lw	a0,0(a0)
    800036e6:	00000097          	auipc	ra,0x0
    800036ea:	89c080e7          	jalr	-1892(ra) # 80002f82 <bread>
    800036ee:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036f0:	05850793          	add	a5,a0,88
    800036f4:	40d8                	lw	a4,4(s1)
    800036f6:	8b3d                	and	a4,a4,15
    800036f8:	071a                	sll	a4,a4,0x6
    800036fa:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800036fc:	04449703          	lh	a4,68(s1)
    80003700:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003704:	04649703          	lh	a4,70(s1)
    80003708:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000370c:	04849703          	lh	a4,72(s1)
    80003710:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003714:	04a49703          	lh	a4,74(s1)
    80003718:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000371c:	44f8                	lw	a4,76(s1)
    8000371e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003720:	03400613          	li	a2,52
    80003724:	05048593          	add	a1,s1,80
    80003728:	00c78513          	add	a0,a5,12
    8000372c:	ffffd097          	auipc	ra,0xffffd
    80003730:	6f8080e7          	jalr	1784(ra) # 80000e24 <memmove>
  log_write(bp);
    80003734:	854a                	mv	a0,s2
    80003736:	00001097          	auipc	ra,0x1
    8000373a:	bd4080e7          	jalr	-1068(ra) # 8000430a <log_write>
  brelse(bp);
    8000373e:	854a                	mv	a0,s2
    80003740:	00000097          	auipc	ra,0x0
    80003744:	972080e7          	jalr	-1678(ra) # 800030b2 <brelse>
}
    80003748:	60e2                	ld	ra,24(sp)
    8000374a:	6442                	ld	s0,16(sp)
    8000374c:	64a2                	ld	s1,8(sp)
    8000374e:	6902                	ld	s2,0(sp)
    80003750:	6105                	add	sp,sp,32
    80003752:	8082                	ret

0000000080003754 <idup>:
{
    80003754:	1101                	add	sp,sp,-32
    80003756:	ec06                	sd	ra,24(sp)
    80003758:	e822                	sd	s0,16(sp)
    8000375a:	e426                	sd	s1,8(sp)
    8000375c:	1000                	add	s0,sp,32
    8000375e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003760:	0001c517          	auipc	a0,0x1c
    80003764:	9f850513          	add	a0,a0,-1544 # 8001f158 <itable>
    80003768:	ffffd097          	auipc	ra,0xffffd
    8000376c:	564080e7          	jalr	1380(ra) # 80000ccc <acquire>
  ip->ref++;
    80003770:	449c                	lw	a5,8(s1)
    80003772:	2785                	addw	a5,a5,1
    80003774:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003776:	0001c517          	auipc	a0,0x1c
    8000377a:	9e250513          	add	a0,a0,-1566 # 8001f158 <itable>
    8000377e:	ffffd097          	auipc	ra,0xffffd
    80003782:	602080e7          	jalr	1538(ra) # 80000d80 <release>
}
    80003786:	8526                	mv	a0,s1
    80003788:	60e2                	ld	ra,24(sp)
    8000378a:	6442                	ld	s0,16(sp)
    8000378c:	64a2                	ld	s1,8(sp)
    8000378e:	6105                	add	sp,sp,32
    80003790:	8082                	ret

0000000080003792 <ilock>:
{
    80003792:	1101                	add	sp,sp,-32
    80003794:	ec06                	sd	ra,24(sp)
    80003796:	e822                	sd	s0,16(sp)
    80003798:	e426                	sd	s1,8(sp)
    8000379a:	e04a                	sd	s2,0(sp)
    8000379c:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000379e:	c115                	beqz	a0,800037c2 <ilock+0x30>
    800037a0:	84aa                	mv	s1,a0
    800037a2:	451c                	lw	a5,8(a0)
    800037a4:	00f05f63          	blez	a5,800037c2 <ilock+0x30>
  acquiresleep(&ip->lock);
    800037a8:	0541                	add	a0,a0,16
    800037aa:	00001097          	auipc	ra,0x1
    800037ae:	c7e080e7          	jalr	-898(ra) # 80004428 <acquiresleep>
  if(ip->valid == 0){
    800037b2:	40bc                	lw	a5,64(s1)
    800037b4:	cf99                	beqz	a5,800037d2 <ilock+0x40>
}
    800037b6:	60e2                	ld	ra,24(sp)
    800037b8:	6442                	ld	s0,16(sp)
    800037ba:	64a2                	ld	s1,8(sp)
    800037bc:	6902                	ld	s2,0(sp)
    800037be:	6105                	add	sp,sp,32
    800037c0:	8082                	ret
    panic("ilock");
    800037c2:	00005517          	auipc	a0,0x5
    800037c6:	e4e50513          	add	a0,a0,-434 # 80008610 <syscalls+0x180>
    800037ca:	ffffd097          	auipc	ra,0xffffd
    800037ce:	044080e7          	jalr	68(ra) # 8000080e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037d2:	40dc                	lw	a5,4(s1)
    800037d4:	0047d79b          	srlw	a5,a5,0x4
    800037d8:	0001c597          	auipc	a1,0x1c
    800037dc:	9785a583          	lw	a1,-1672(a1) # 8001f150 <sb+0x18>
    800037e0:	9dbd                	addw	a1,a1,a5
    800037e2:	4088                	lw	a0,0(s1)
    800037e4:	fffff097          	auipc	ra,0xfffff
    800037e8:	79e080e7          	jalr	1950(ra) # 80002f82 <bread>
    800037ec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037ee:	05850593          	add	a1,a0,88
    800037f2:	40dc                	lw	a5,4(s1)
    800037f4:	8bbd                	and	a5,a5,15
    800037f6:	079a                	sll	a5,a5,0x6
    800037f8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037fa:	00059783          	lh	a5,0(a1)
    800037fe:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003802:	00259783          	lh	a5,2(a1)
    80003806:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000380a:	00459783          	lh	a5,4(a1)
    8000380e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003812:	00659783          	lh	a5,6(a1)
    80003816:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000381a:	459c                	lw	a5,8(a1)
    8000381c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000381e:	03400613          	li	a2,52
    80003822:	05b1                	add	a1,a1,12
    80003824:	05048513          	add	a0,s1,80
    80003828:	ffffd097          	auipc	ra,0xffffd
    8000382c:	5fc080e7          	jalr	1532(ra) # 80000e24 <memmove>
    brelse(bp);
    80003830:	854a                	mv	a0,s2
    80003832:	00000097          	auipc	ra,0x0
    80003836:	880080e7          	jalr	-1920(ra) # 800030b2 <brelse>
    ip->valid = 1;
    8000383a:	4785                	li	a5,1
    8000383c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000383e:	04449783          	lh	a5,68(s1)
    80003842:	fbb5                	bnez	a5,800037b6 <ilock+0x24>
      panic("ilock: no type");
    80003844:	00005517          	auipc	a0,0x5
    80003848:	dd450513          	add	a0,a0,-556 # 80008618 <syscalls+0x188>
    8000384c:	ffffd097          	auipc	ra,0xffffd
    80003850:	fc2080e7          	jalr	-62(ra) # 8000080e <panic>

0000000080003854 <iunlock>:
{
    80003854:	1101                	add	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	e04a                	sd	s2,0(sp)
    8000385e:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003860:	c905                	beqz	a0,80003890 <iunlock+0x3c>
    80003862:	84aa                	mv	s1,a0
    80003864:	01050913          	add	s2,a0,16
    80003868:	854a                	mv	a0,s2
    8000386a:	00001097          	auipc	ra,0x1
    8000386e:	c58080e7          	jalr	-936(ra) # 800044c2 <holdingsleep>
    80003872:	cd19                	beqz	a0,80003890 <iunlock+0x3c>
    80003874:	449c                	lw	a5,8(s1)
    80003876:	00f05d63          	blez	a5,80003890 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000387a:	854a                	mv	a0,s2
    8000387c:	00001097          	auipc	ra,0x1
    80003880:	c02080e7          	jalr	-1022(ra) # 8000447e <releasesleep>
}
    80003884:	60e2                	ld	ra,24(sp)
    80003886:	6442                	ld	s0,16(sp)
    80003888:	64a2                	ld	s1,8(sp)
    8000388a:	6902                	ld	s2,0(sp)
    8000388c:	6105                	add	sp,sp,32
    8000388e:	8082                	ret
    panic("iunlock");
    80003890:	00005517          	auipc	a0,0x5
    80003894:	d9850513          	add	a0,a0,-616 # 80008628 <syscalls+0x198>
    80003898:	ffffd097          	auipc	ra,0xffffd
    8000389c:	f76080e7          	jalr	-138(ra) # 8000080e <panic>

00000000800038a0 <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    800038a0:	7179                	add	sp,sp,-48
    800038a2:	f406                	sd	ra,40(sp)
    800038a4:	f022                	sd	s0,32(sp)
    800038a6:	ec26                	sd	s1,24(sp)
    800038a8:	e84a                	sd	s2,16(sp)
    800038aa:	e44e                	sd	s3,8(sp)
    800038ac:	e052                	sd	s4,0(sp)
    800038ae:	1800                	add	s0,sp,48
    800038b0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038b2:	05050493          	add	s1,a0,80
    800038b6:	08050913          	add	s2,a0,128
    800038ba:	a021                	j	800038c2 <itrunc+0x22>
    800038bc:	0491                	add	s1,s1,4
    800038be:	01248d63          	beq	s1,s2,800038d8 <itrunc+0x38>
    if(ip->addrs[i]){
    800038c2:	408c                	lw	a1,0(s1)
    800038c4:	dde5                	beqz	a1,800038bc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800038c6:	0009a503          	lw	a0,0(s3)
    800038ca:	00000097          	auipc	ra,0x0
    800038ce:	8fc080e7          	jalr	-1796(ra) # 800031c6 <bfree>
      ip->addrs[i] = 0;
    800038d2:	0004a023          	sw	zero,0(s1)
    800038d6:	b7dd                	j	800038bc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038d8:	0809a583          	lw	a1,128(s3)
    800038dc:	e185                	bnez	a1,800038fc <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800038de:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038e2:	854e                	mv	a0,s3
    800038e4:	00000097          	auipc	ra,0x0
    800038e8:	de2080e7          	jalr	-542(ra) # 800036c6 <iupdate>
}
    800038ec:	70a2                	ld	ra,40(sp)
    800038ee:	7402                	ld	s0,32(sp)
    800038f0:	64e2                	ld	s1,24(sp)
    800038f2:	6942                	ld	s2,16(sp)
    800038f4:	69a2                	ld	s3,8(sp)
    800038f6:	6a02                	ld	s4,0(sp)
    800038f8:	6145                	add	sp,sp,48
    800038fa:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038fc:	0009a503          	lw	a0,0(s3)
    80003900:	fffff097          	auipc	ra,0xfffff
    80003904:	682080e7          	jalr	1666(ra) # 80002f82 <bread>
    80003908:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000390a:	05850493          	add	s1,a0,88
    8000390e:	45850913          	add	s2,a0,1112
    80003912:	a021                	j	8000391a <itrunc+0x7a>
    80003914:	0491                	add	s1,s1,4
    80003916:	01248b63          	beq	s1,s2,8000392c <itrunc+0x8c>
      if(a[j])
    8000391a:	408c                	lw	a1,0(s1)
    8000391c:	dde5                	beqz	a1,80003914 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000391e:	0009a503          	lw	a0,0(s3)
    80003922:	00000097          	auipc	ra,0x0
    80003926:	8a4080e7          	jalr	-1884(ra) # 800031c6 <bfree>
    8000392a:	b7ed                	j	80003914 <itrunc+0x74>
    brelse(bp);
    8000392c:	8552                	mv	a0,s4
    8000392e:	fffff097          	auipc	ra,0xfffff
    80003932:	784080e7          	jalr	1924(ra) # 800030b2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003936:	0809a583          	lw	a1,128(s3)
    8000393a:	0009a503          	lw	a0,0(s3)
    8000393e:	00000097          	auipc	ra,0x0
    80003942:	888080e7          	jalr	-1912(ra) # 800031c6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003946:	0809a023          	sw	zero,128(s3)
    8000394a:	bf51                	j	800038de <itrunc+0x3e>

000000008000394c <iput>:
{
    8000394c:	1101                	add	sp,sp,-32
    8000394e:	ec06                	sd	ra,24(sp)
    80003950:	e822                	sd	s0,16(sp)
    80003952:	e426                	sd	s1,8(sp)
    80003954:	e04a                	sd	s2,0(sp)
    80003956:	1000                	add	s0,sp,32
    80003958:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000395a:	0001b517          	auipc	a0,0x1b
    8000395e:	7fe50513          	add	a0,a0,2046 # 8001f158 <itable>
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	36a080e7          	jalr	874(ra) # 80000ccc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000396a:	4498                	lw	a4,8(s1)
    8000396c:	4785                	li	a5,1
    8000396e:	02f70363          	beq	a4,a5,80003994 <iput+0x48>
  ip->ref--;
    80003972:	449c                	lw	a5,8(s1)
    80003974:	37fd                	addw	a5,a5,-1
    80003976:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003978:	0001b517          	auipc	a0,0x1b
    8000397c:	7e050513          	add	a0,a0,2016 # 8001f158 <itable>
    80003980:	ffffd097          	auipc	ra,0xffffd
    80003984:	400080e7          	jalr	1024(ra) # 80000d80 <release>
}
    80003988:	60e2                	ld	ra,24(sp)
    8000398a:	6442                	ld	s0,16(sp)
    8000398c:	64a2                	ld	s1,8(sp)
    8000398e:	6902                	ld	s2,0(sp)
    80003990:	6105                	add	sp,sp,32
    80003992:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003994:	40bc                	lw	a5,64(s1)
    80003996:	dff1                	beqz	a5,80003972 <iput+0x26>
    80003998:	04a49783          	lh	a5,74(s1)
    8000399c:	fbf9                	bnez	a5,80003972 <iput+0x26>
    acquiresleep(&ip->lock);
    8000399e:	01048913          	add	s2,s1,16
    800039a2:	854a                	mv	a0,s2
    800039a4:	00001097          	auipc	ra,0x1
    800039a8:	a84080e7          	jalr	-1404(ra) # 80004428 <acquiresleep>
    release(&itable.lock);
    800039ac:	0001b517          	auipc	a0,0x1b
    800039b0:	7ac50513          	add	a0,a0,1964 # 8001f158 <itable>
    800039b4:	ffffd097          	auipc	ra,0xffffd
    800039b8:	3cc080e7          	jalr	972(ra) # 80000d80 <release>
    itrunc(ip);
    800039bc:	8526                	mv	a0,s1
    800039be:	00000097          	auipc	ra,0x0
    800039c2:	ee2080e7          	jalr	-286(ra) # 800038a0 <itrunc>
    ip->type = 0;
    800039c6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039ca:	8526                	mv	a0,s1
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	cfa080e7          	jalr	-774(ra) # 800036c6 <iupdate>
    ip->valid = 0;
    800039d4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800039d8:	854a                	mv	a0,s2
    800039da:	00001097          	auipc	ra,0x1
    800039de:	aa4080e7          	jalr	-1372(ra) # 8000447e <releasesleep>
    acquire(&itable.lock);
    800039e2:	0001b517          	auipc	a0,0x1b
    800039e6:	77650513          	add	a0,a0,1910 # 8001f158 <itable>
    800039ea:	ffffd097          	auipc	ra,0xffffd
    800039ee:	2e2080e7          	jalr	738(ra) # 80000ccc <acquire>
    800039f2:	b741                	j	80003972 <iput+0x26>

00000000800039f4 <iunlockput>:
{
    800039f4:	1101                	add	sp,sp,-32
    800039f6:	ec06                	sd	ra,24(sp)
    800039f8:	e822                	sd	s0,16(sp)
    800039fa:	e426                	sd	s1,8(sp)
    800039fc:	1000                	add	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a00:	00000097          	auipc	ra,0x0
    80003a04:	e54080e7          	jalr	-428(ra) # 80003854 <iunlock>
  iput(ip);
    80003a08:	8526                	mv	a0,s1
    80003a0a:	00000097          	auipc	ra,0x0
    80003a0e:	f42080e7          	jalr	-190(ra) # 8000394c <iput>
}
    80003a12:	60e2                	ld	ra,24(sp)
    80003a14:	6442                	ld	s0,16(sp)
    80003a16:	64a2                	ld	s1,8(sp)
    80003a18:	6105                	add	sp,sp,32
    80003a1a:	8082                	ret

0000000080003a1c <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80003a1c:	1141                	add	sp,sp,-16
    80003a1e:	e422                	sd	s0,8(sp)
    80003a20:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003a22:	411c                	lw	a5,0(a0)
    80003a24:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a26:	415c                	lw	a5,4(a0)
    80003a28:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a2a:	04451783          	lh	a5,68(a0)
    80003a2e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a32:	04a51783          	lh	a5,74(a0)
    80003a36:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a3a:	04c56783          	lwu	a5,76(a0)
    80003a3e:	e99c                	sd	a5,16(a1)
}
    80003a40:	6422                	ld	s0,8(sp)
    80003a42:	0141                	add	sp,sp,16
    80003a44:	8082                	ret

0000000080003a46 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a46:	457c                	lw	a5,76(a0)
    80003a48:	0ed7e963          	bltu	a5,a3,80003b3a <readi+0xf4>
{
    80003a4c:	7159                	add	sp,sp,-112
    80003a4e:	f486                	sd	ra,104(sp)
    80003a50:	f0a2                	sd	s0,96(sp)
    80003a52:	eca6                	sd	s1,88(sp)
    80003a54:	e8ca                	sd	s2,80(sp)
    80003a56:	e4ce                	sd	s3,72(sp)
    80003a58:	e0d2                	sd	s4,64(sp)
    80003a5a:	fc56                	sd	s5,56(sp)
    80003a5c:	f85a                	sd	s6,48(sp)
    80003a5e:	f45e                	sd	s7,40(sp)
    80003a60:	f062                	sd	s8,32(sp)
    80003a62:	ec66                	sd	s9,24(sp)
    80003a64:	e86a                	sd	s10,16(sp)
    80003a66:	e46e                	sd	s11,8(sp)
    80003a68:	1880                	add	s0,sp,112
    80003a6a:	8b2a                	mv	s6,a0
    80003a6c:	8bae                	mv	s7,a1
    80003a6e:	8a32                	mv	s4,a2
    80003a70:	84b6                	mv	s1,a3
    80003a72:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a74:	9f35                	addw	a4,a4,a3
    return 0;
    80003a76:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a78:	0ad76063          	bltu	a4,a3,80003b18 <readi+0xd2>
  if(off + n > ip->size)
    80003a7c:	00e7f463          	bgeu	a5,a4,80003a84 <readi+0x3e>
    n = ip->size - off;
    80003a80:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a84:	0a0a8963          	beqz	s5,80003b36 <readi+0xf0>
    80003a88:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a8a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a8e:	5c7d                	li	s8,-1
    80003a90:	a82d                	j	80003aca <readi+0x84>
    80003a92:	020d1d93          	sll	s11,s10,0x20
    80003a96:	020ddd93          	srl	s11,s11,0x20
    80003a9a:	05890613          	add	a2,s2,88
    80003a9e:	86ee                	mv	a3,s11
    80003aa0:	963a                	add	a2,a2,a4
    80003aa2:	85d2                	mv	a1,s4
    80003aa4:	855e                	mv	a0,s7
    80003aa6:	fffff097          	auipc	ra,0xfffff
    80003aaa:	b32080e7          	jalr	-1230(ra) # 800025d8 <either_copyout>
    80003aae:	05850d63          	beq	a0,s8,80003b08 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ab2:	854a                	mv	a0,s2
    80003ab4:	fffff097          	auipc	ra,0xfffff
    80003ab8:	5fe080e7          	jalr	1534(ra) # 800030b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003abc:	013d09bb          	addw	s3,s10,s3
    80003ac0:	009d04bb          	addw	s1,s10,s1
    80003ac4:	9a6e                	add	s4,s4,s11
    80003ac6:	0559f763          	bgeu	s3,s5,80003b14 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003aca:	00a4d59b          	srlw	a1,s1,0xa
    80003ace:	855a                	mv	a0,s6
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	8a4080e7          	jalr	-1884(ra) # 80003374 <bmap>
    80003ad8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003adc:	cd85                	beqz	a1,80003b14 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003ade:	000b2503          	lw	a0,0(s6)
    80003ae2:	fffff097          	auipc	ra,0xfffff
    80003ae6:	4a0080e7          	jalr	1184(ra) # 80002f82 <bread>
    80003aea:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aec:	3ff4f713          	and	a4,s1,1023
    80003af0:	40ec87bb          	subw	a5,s9,a4
    80003af4:	413a86bb          	subw	a3,s5,s3
    80003af8:	8d3e                	mv	s10,a5
    80003afa:	2781                	sext.w	a5,a5
    80003afc:	0006861b          	sext.w	a2,a3
    80003b00:	f8f679e3          	bgeu	a2,a5,80003a92 <readi+0x4c>
    80003b04:	8d36                	mv	s10,a3
    80003b06:	b771                	j	80003a92 <readi+0x4c>
      brelse(bp);
    80003b08:	854a                	mv	a0,s2
    80003b0a:	fffff097          	auipc	ra,0xfffff
    80003b0e:	5a8080e7          	jalr	1448(ra) # 800030b2 <brelse>
      tot = -1;
    80003b12:	59fd                	li	s3,-1
  }
  return tot;
    80003b14:	0009851b          	sext.w	a0,s3
}
    80003b18:	70a6                	ld	ra,104(sp)
    80003b1a:	7406                	ld	s0,96(sp)
    80003b1c:	64e6                	ld	s1,88(sp)
    80003b1e:	6946                	ld	s2,80(sp)
    80003b20:	69a6                	ld	s3,72(sp)
    80003b22:	6a06                	ld	s4,64(sp)
    80003b24:	7ae2                	ld	s5,56(sp)
    80003b26:	7b42                	ld	s6,48(sp)
    80003b28:	7ba2                	ld	s7,40(sp)
    80003b2a:	7c02                	ld	s8,32(sp)
    80003b2c:	6ce2                	ld	s9,24(sp)
    80003b2e:	6d42                	ld	s10,16(sp)
    80003b30:	6da2                	ld	s11,8(sp)
    80003b32:	6165                	add	sp,sp,112
    80003b34:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b36:	89d6                	mv	s3,s5
    80003b38:	bff1                	j	80003b14 <readi+0xce>
    return 0;
    80003b3a:	4501                	li	a0,0
}
    80003b3c:	8082                	ret

0000000080003b3e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b3e:	457c                	lw	a5,76(a0)
    80003b40:	10d7e863          	bltu	a5,a3,80003c50 <writei+0x112>
{
    80003b44:	7159                	add	sp,sp,-112
    80003b46:	f486                	sd	ra,104(sp)
    80003b48:	f0a2                	sd	s0,96(sp)
    80003b4a:	eca6                	sd	s1,88(sp)
    80003b4c:	e8ca                	sd	s2,80(sp)
    80003b4e:	e4ce                	sd	s3,72(sp)
    80003b50:	e0d2                	sd	s4,64(sp)
    80003b52:	fc56                	sd	s5,56(sp)
    80003b54:	f85a                	sd	s6,48(sp)
    80003b56:	f45e                	sd	s7,40(sp)
    80003b58:	f062                	sd	s8,32(sp)
    80003b5a:	ec66                	sd	s9,24(sp)
    80003b5c:	e86a                	sd	s10,16(sp)
    80003b5e:	e46e                	sd	s11,8(sp)
    80003b60:	1880                	add	s0,sp,112
    80003b62:	8aaa                	mv	s5,a0
    80003b64:	8bae                	mv	s7,a1
    80003b66:	8a32                	mv	s4,a2
    80003b68:	8936                	mv	s2,a3
    80003b6a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b6c:	00e687bb          	addw	a5,a3,a4
    80003b70:	0ed7e263          	bltu	a5,a3,80003c54 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b74:	00043737          	lui	a4,0x43
    80003b78:	0ef76063          	bltu	a4,a5,80003c58 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b7c:	0c0b0863          	beqz	s6,80003c4c <writei+0x10e>
    80003b80:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b82:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b86:	5c7d                	li	s8,-1
    80003b88:	a091                	j	80003bcc <writei+0x8e>
    80003b8a:	020d1d93          	sll	s11,s10,0x20
    80003b8e:	020ddd93          	srl	s11,s11,0x20
    80003b92:	05848513          	add	a0,s1,88
    80003b96:	86ee                	mv	a3,s11
    80003b98:	8652                	mv	a2,s4
    80003b9a:	85de                	mv	a1,s7
    80003b9c:	953a                	add	a0,a0,a4
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	a90080e7          	jalr	-1392(ra) # 8000262e <either_copyin>
    80003ba6:	07850263          	beq	a0,s8,80003c0a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003baa:	8526                	mv	a0,s1
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	75e080e7          	jalr	1886(ra) # 8000430a <log_write>
    brelse(bp);
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	4fc080e7          	jalr	1276(ra) # 800030b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bbe:	013d09bb          	addw	s3,s10,s3
    80003bc2:	012d093b          	addw	s2,s10,s2
    80003bc6:	9a6e                	add	s4,s4,s11
    80003bc8:	0569f663          	bgeu	s3,s6,80003c14 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003bcc:	00a9559b          	srlw	a1,s2,0xa
    80003bd0:	8556                	mv	a0,s5
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	7a2080e7          	jalr	1954(ra) # 80003374 <bmap>
    80003bda:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003bde:	c99d                	beqz	a1,80003c14 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003be0:	000aa503          	lw	a0,0(s5)
    80003be4:	fffff097          	auipc	ra,0xfffff
    80003be8:	39e080e7          	jalr	926(ra) # 80002f82 <bread>
    80003bec:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bee:	3ff97713          	and	a4,s2,1023
    80003bf2:	40ec87bb          	subw	a5,s9,a4
    80003bf6:	413b06bb          	subw	a3,s6,s3
    80003bfa:	8d3e                	mv	s10,a5
    80003bfc:	2781                	sext.w	a5,a5
    80003bfe:	0006861b          	sext.w	a2,a3
    80003c02:	f8f674e3          	bgeu	a2,a5,80003b8a <writei+0x4c>
    80003c06:	8d36                	mv	s10,a3
    80003c08:	b749                	j	80003b8a <writei+0x4c>
      brelse(bp);
    80003c0a:	8526                	mv	a0,s1
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	4a6080e7          	jalr	1190(ra) # 800030b2 <brelse>
  }

  if(off > ip->size)
    80003c14:	04caa783          	lw	a5,76(s5)
    80003c18:	0127f463          	bgeu	a5,s2,80003c20 <writei+0xe2>
    ip->size = off;
    80003c1c:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    80003c20:	8556                	mv	a0,s5
    80003c22:	00000097          	auipc	ra,0x0
    80003c26:	aa4080e7          	jalr	-1372(ra) # 800036c6 <iupdate>

  return tot;
    80003c2a:	0009851b          	sext.w	a0,s3
}
    80003c2e:	70a6                	ld	ra,104(sp)
    80003c30:	7406                	ld	s0,96(sp)
    80003c32:	64e6                	ld	s1,88(sp)
    80003c34:	6946                	ld	s2,80(sp)
    80003c36:	69a6                	ld	s3,72(sp)
    80003c38:	6a06                	ld	s4,64(sp)
    80003c3a:	7ae2                	ld	s5,56(sp)
    80003c3c:	7b42                	ld	s6,48(sp)
    80003c3e:	7ba2                	ld	s7,40(sp)
    80003c40:	7c02                	ld	s8,32(sp)
    80003c42:	6ce2                	ld	s9,24(sp)
    80003c44:	6d42                	ld	s10,16(sp)
    80003c46:	6da2                	ld	s11,8(sp)
    80003c48:	6165                	add	sp,sp,112
    80003c4a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c4c:	89da                	mv	s3,s6
    80003c4e:	bfc9                	j	80003c20 <writei+0xe2>
    return -1;
    80003c50:	557d                	li	a0,-1
}
    80003c52:	8082                	ret
    return -1;
    80003c54:	557d                	li	a0,-1
    80003c56:	bfe1                	j	80003c2e <writei+0xf0>
    return -1;
    80003c58:	557d                	li	a0,-1
    80003c5a:	bfd1                	j	80003c2e <writei+0xf0>

0000000080003c5c <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    80003c5c:	1141                	add	sp,sp,-16
    80003c5e:	e406                	sd	ra,8(sp)
    80003c60:	e022                	sd	s0,0(sp)
    80003c62:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c64:	4639                	li	a2,14
    80003c66:	ffffd097          	auipc	ra,0xffffd
    80003c6a:	232080e7          	jalr	562(ra) # 80000e98 <strncmp>
}
    80003c6e:	60a2                	ld	ra,8(sp)
    80003c70:	6402                	ld	s0,0(sp)
    80003c72:	0141                	add	sp,sp,16
    80003c74:	8082                	ret

0000000080003c76 <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c76:	7139                	add	sp,sp,-64
    80003c78:	fc06                	sd	ra,56(sp)
    80003c7a:	f822                	sd	s0,48(sp)
    80003c7c:	f426                	sd	s1,40(sp)
    80003c7e:	f04a                	sd	s2,32(sp)
    80003c80:	ec4e                	sd	s3,24(sp)
    80003c82:	e852                	sd	s4,16(sp)
    80003c84:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c86:	04451703          	lh	a4,68(a0)
    80003c8a:	4785                	li	a5,1
    80003c8c:	00f71a63          	bne	a4,a5,80003ca0 <dirlookup+0x2a>
    80003c90:	892a                	mv	s2,a0
    80003c92:	89ae                	mv	s3,a1
    80003c94:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c96:	457c                	lw	a5,76(a0)
    80003c98:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c9a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c9c:	e79d                	bnez	a5,80003cca <dirlookup+0x54>
    80003c9e:	a8a5                	j	80003d16 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003ca0:	00005517          	auipc	a0,0x5
    80003ca4:	99050513          	add	a0,a0,-1648 # 80008630 <syscalls+0x1a0>
    80003ca8:	ffffd097          	auipc	ra,0xffffd
    80003cac:	b66080e7          	jalr	-1178(ra) # 8000080e <panic>
      panic("dirlookup read");
    80003cb0:	00005517          	auipc	a0,0x5
    80003cb4:	99850513          	add	a0,a0,-1640 # 80008648 <syscalls+0x1b8>
    80003cb8:	ffffd097          	auipc	ra,0xffffd
    80003cbc:	b56080e7          	jalr	-1194(ra) # 8000080e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cc0:	24c1                	addw	s1,s1,16
    80003cc2:	04c92783          	lw	a5,76(s2)
    80003cc6:	04f4f763          	bgeu	s1,a5,80003d14 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cca:	4741                	li	a4,16
    80003ccc:	86a6                	mv	a3,s1
    80003cce:	fc040613          	add	a2,s0,-64
    80003cd2:	4581                	li	a1,0
    80003cd4:	854a                	mv	a0,s2
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	d70080e7          	jalr	-656(ra) # 80003a46 <readi>
    80003cde:	47c1                	li	a5,16
    80003ce0:	fcf518e3          	bne	a0,a5,80003cb0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003ce4:	fc045783          	lhu	a5,-64(s0)
    80003ce8:	dfe1                	beqz	a5,80003cc0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003cea:	fc240593          	add	a1,s0,-62
    80003cee:	854e                	mv	a0,s3
    80003cf0:	00000097          	auipc	ra,0x0
    80003cf4:	f6c080e7          	jalr	-148(ra) # 80003c5c <namecmp>
    80003cf8:	f561                	bnez	a0,80003cc0 <dirlookup+0x4a>
      if(poff)
    80003cfa:	000a0463          	beqz	s4,80003d02 <dirlookup+0x8c>
        *poff = off;
    80003cfe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d02:	fc045583          	lhu	a1,-64(s0)
    80003d06:	00092503          	lw	a0,0(s2)
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	754080e7          	jalr	1876(ra) # 8000345e <iget>
    80003d12:	a011                	j	80003d16 <dirlookup+0xa0>
  return 0;
    80003d14:	4501                	li	a0,0
}
    80003d16:	70e2                	ld	ra,56(sp)
    80003d18:	7442                	ld	s0,48(sp)
    80003d1a:	74a2                	ld	s1,40(sp)
    80003d1c:	7902                	ld	s2,32(sp)
    80003d1e:	69e2                	ld	s3,24(sp)
    80003d20:	6a42                	ld	s4,16(sp)
    80003d22:	6121                	add	sp,sp,64
    80003d24:	8082                	ret

0000000080003d26 <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d26:	711d                	add	sp,sp,-96
    80003d28:	ec86                	sd	ra,88(sp)
    80003d2a:	e8a2                	sd	s0,80(sp)
    80003d2c:	e4a6                	sd	s1,72(sp)
    80003d2e:	e0ca                	sd	s2,64(sp)
    80003d30:	fc4e                	sd	s3,56(sp)
    80003d32:	f852                	sd	s4,48(sp)
    80003d34:	f456                	sd	s5,40(sp)
    80003d36:	f05a                	sd	s6,32(sp)
    80003d38:	ec5e                	sd	s7,24(sp)
    80003d3a:	e862                	sd	s8,16(sp)
    80003d3c:	e466                	sd	s9,8(sp)
    80003d3e:	1080                	add	s0,sp,96
    80003d40:	84aa                	mv	s1,a0
    80003d42:	8b2e                	mv	s6,a1
    80003d44:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d46:	00054703          	lbu	a4,0(a0)
    80003d4a:	02f00793          	li	a5,47
    80003d4e:	02f70263          	beq	a4,a5,80003d72 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d52:	ffffe097          	auipc	ra,0xffffe
    80003d56:	db2080e7          	jalr	-590(ra) # 80001b04 <myproc>
    80003d5a:	15853503          	ld	a0,344(a0)
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	9f6080e7          	jalr	-1546(ra) # 80003754 <idup>
    80003d66:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d68:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d6c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d6e:	4b85                	li	s7,1
    80003d70:	a875                	j	80003e2c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003d72:	4585                	li	a1,1
    80003d74:	4505                	li	a0,1
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	6e8080e7          	jalr	1768(ra) # 8000345e <iget>
    80003d7e:	8a2a                	mv	s4,a0
    80003d80:	b7e5                	j	80003d68 <namex+0x42>
      iunlockput(ip);
    80003d82:	8552                	mv	a0,s4
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	c70080e7          	jalr	-912(ra) # 800039f4 <iunlockput>
      return 0;
    80003d8c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d8e:	8552                	mv	a0,s4
    80003d90:	60e6                	ld	ra,88(sp)
    80003d92:	6446                	ld	s0,80(sp)
    80003d94:	64a6                	ld	s1,72(sp)
    80003d96:	6906                	ld	s2,64(sp)
    80003d98:	79e2                	ld	s3,56(sp)
    80003d9a:	7a42                	ld	s4,48(sp)
    80003d9c:	7aa2                	ld	s5,40(sp)
    80003d9e:	7b02                	ld	s6,32(sp)
    80003da0:	6be2                	ld	s7,24(sp)
    80003da2:	6c42                	ld	s8,16(sp)
    80003da4:	6ca2                	ld	s9,8(sp)
    80003da6:	6125                	add	sp,sp,96
    80003da8:	8082                	ret
      iunlock(ip);
    80003daa:	8552                	mv	a0,s4
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	aa8080e7          	jalr	-1368(ra) # 80003854 <iunlock>
      return ip;
    80003db4:	bfe9                	j	80003d8e <namex+0x68>
      iunlockput(ip);
    80003db6:	8552                	mv	a0,s4
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	c3c080e7          	jalr	-964(ra) # 800039f4 <iunlockput>
      return 0;
    80003dc0:	8a4e                	mv	s4,s3
    80003dc2:	b7f1                	j	80003d8e <namex+0x68>
  len = path - s;
    80003dc4:	40998633          	sub	a2,s3,s1
    80003dc8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003dcc:	099c5863          	bge	s8,s9,80003e5c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003dd0:	4639                	li	a2,14
    80003dd2:	85a6                	mv	a1,s1
    80003dd4:	8556                	mv	a0,s5
    80003dd6:	ffffd097          	auipc	ra,0xffffd
    80003dda:	04e080e7          	jalr	78(ra) # 80000e24 <memmove>
    80003dde:	84ce                	mv	s1,s3
  while(*path == '/')
    80003de0:	0004c783          	lbu	a5,0(s1)
    80003de4:	01279763          	bne	a5,s2,80003df2 <namex+0xcc>
    path++;
    80003de8:	0485                	add	s1,s1,1
  while(*path == '/')
    80003dea:	0004c783          	lbu	a5,0(s1)
    80003dee:	ff278de3          	beq	a5,s2,80003de8 <namex+0xc2>
    ilock(ip);
    80003df2:	8552                	mv	a0,s4
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	99e080e7          	jalr	-1634(ra) # 80003792 <ilock>
    if(ip->type != T_DIR){
    80003dfc:	044a1783          	lh	a5,68(s4)
    80003e00:	f97791e3          	bne	a5,s7,80003d82 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003e04:	000b0563          	beqz	s6,80003e0e <namex+0xe8>
    80003e08:	0004c783          	lbu	a5,0(s1)
    80003e0c:	dfd9                	beqz	a5,80003daa <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e0e:	4601                	li	a2,0
    80003e10:	85d6                	mv	a1,s5
    80003e12:	8552                	mv	a0,s4
    80003e14:	00000097          	auipc	ra,0x0
    80003e18:	e62080e7          	jalr	-414(ra) # 80003c76 <dirlookup>
    80003e1c:	89aa                	mv	s3,a0
    80003e1e:	dd41                	beqz	a0,80003db6 <namex+0x90>
    iunlockput(ip);
    80003e20:	8552                	mv	a0,s4
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	bd2080e7          	jalr	-1070(ra) # 800039f4 <iunlockput>
    ip = next;
    80003e2a:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e2c:	0004c783          	lbu	a5,0(s1)
    80003e30:	01279763          	bne	a5,s2,80003e3e <namex+0x118>
    path++;
    80003e34:	0485                	add	s1,s1,1
  while(*path == '/')
    80003e36:	0004c783          	lbu	a5,0(s1)
    80003e3a:	ff278de3          	beq	a5,s2,80003e34 <namex+0x10e>
  if(*path == 0)
    80003e3e:	cb9d                	beqz	a5,80003e74 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003e40:	0004c783          	lbu	a5,0(s1)
    80003e44:	89a6                	mv	s3,s1
  len = path - s;
    80003e46:	4c81                	li	s9,0
    80003e48:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e4a:	01278963          	beq	a5,s2,80003e5c <namex+0x136>
    80003e4e:	dbbd                	beqz	a5,80003dc4 <namex+0x9e>
    path++;
    80003e50:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e52:	0009c783          	lbu	a5,0(s3)
    80003e56:	ff279ce3          	bne	a5,s2,80003e4e <namex+0x128>
    80003e5a:	b7ad                	j	80003dc4 <namex+0x9e>
    memmove(name, s, len);
    80003e5c:	2601                	sext.w	a2,a2
    80003e5e:	85a6                	mv	a1,s1
    80003e60:	8556                	mv	a0,s5
    80003e62:	ffffd097          	auipc	ra,0xffffd
    80003e66:	fc2080e7          	jalr	-62(ra) # 80000e24 <memmove>
    name[len] = 0;
    80003e6a:	9cd6                	add	s9,s9,s5
    80003e6c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e70:	84ce                	mv	s1,s3
    80003e72:	b7bd                	j	80003de0 <namex+0xba>
  if(nameiparent){
    80003e74:	f00b0de3          	beqz	s6,80003d8e <namex+0x68>
    iput(ip);
    80003e78:	8552                	mv	a0,s4
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	ad2080e7          	jalr	-1326(ra) # 8000394c <iput>
    return 0;
    80003e82:	4a01                	li	s4,0
    80003e84:	b729                	j	80003d8e <namex+0x68>

0000000080003e86 <dirlink>:
{
    80003e86:	7139                	add	sp,sp,-64
    80003e88:	fc06                	sd	ra,56(sp)
    80003e8a:	f822                	sd	s0,48(sp)
    80003e8c:	f426                	sd	s1,40(sp)
    80003e8e:	f04a                	sd	s2,32(sp)
    80003e90:	ec4e                	sd	s3,24(sp)
    80003e92:	e852                	sd	s4,16(sp)
    80003e94:	0080                	add	s0,sp,64
    80003e96:	892a                	mv	s2,a0
    80003e98:	8a2e                	mv	s4,a1
    80003e9a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e9c:	4601                	li	a2,0
    80003e9e:	00000097          	auipc	ra,0x0
    80003ea2:	dd8080e7          	jalr	-552(ra) # 80003c76 <dirlookup>
    80003ea6:	e93d                	bnez	a0,80003f1c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ea8:	04c92483          	lw	s1,76(s2)
    80003eac:	c49d                	beqz	s1,80003eda <dirlink+0x54>
    80003eae:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eb0:	4741                	li	a4,16
    80003eb2:	86a6                	mv	a3,s1
    80003eb4:	fc040613          	add	a2,s0,-64
    80003eb8:	4581                	li	a1,0
    80003eba:	854a                	mv	a0,s2
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	b8a080e7          	jalr	-1142(ra) # 80003a46 <readi>
    80003ec4:	47c1                	li	a5,16
    80003ec6:	06f51163          	bne	a0,a5,80003f28 <dirlink+0xa2>
    if(de.inum == 0)
    80003eca:	fc045783          	lhu	a5,-64(s0)
    80003ece:	c791                	beqz	a5,80003eda <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ed0:	24c1                	addw	s1,s1,16
    80003ed2:	04c92783          	lw	a5,76(s2)
    80003ed6:	fcf4ede3          	bltu	s1,a5,80003eb0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003eda:	4639                	li	a2,14
    80003edc:	85d2                	mv	a1,s4
    80003ede:	fc240513          	add	a0,s0,-62
    80003ee2:	ffffd097          	auipc	ra,0xffffd
    80003ee6:	ff2080e7          	jalr	-14(ra) # 80000ed4 <strncpy>
  de.inum = inum;
    80003eea:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eee:	4741                	li	a4,16
    80003ef0:	86a6                	mv	a3,s1
    80003ef2:	fc040613          	add	a2,s0,-64
    80003ef6:	4581                	li	a1,0
    80003ef8:	854a                	mv	a0,s2
    80003efa:	00000097          	auipc	ra,0x0
    80003efe:	c44080e7          	jalr	-956(ra) # 80003b3e <writei>
    80003f02:	1541                	add	a0,a0,-16
    80003f04:	00a03533          	snez	a0,a0
    80003f08:	40a00533          	neg	a0,a0
}
    80003f0c:	70e2                	ld	ra,56(sp)
    80003f0e:	7442                	ld	s0,48(sp)
    80003f10:	74a2                	ld	s1,40(sp)
    80003f12:	7902                	ld	s2,32(sp)
    80003f14:	69e2                	ld	s3,24(sp)
    80003f16:	6a42                	ld	s4,16(sp)
    80003f18:	6121                	add	sp,sp,64
    80003f1a:	8082                	ret
    iput(ip);
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	a30080e7          	jalr	-1488(ra) # 8000394c <iput>
    return -1;
    80003f24:	557d                	li	a0,-1
    80003f26:	b7dd                	j	80003f0c <dirlink+0x86>
      panic("dirlink read");
    80003f28:	00004517          	auipc	a0,0x4
    80003f2c:	73050513          	add	a0,a0,1840 # 80008658 <syscalls+0x1c8>
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	8de080e7          	jalr	-1826(ra) # 8000080e <panic>

0000000080003f38 <namei>:

struct inode*
namei(char *path)
{
    80003f38:	1101                	add	sp,sp,-32
    80003f3a:	ec06                	sd	ra,24(sp)
    80003f3c:	e822                	sd	s0,16(sp)
    80003f3e:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f40:	fe040613          	add	a2,s0,-32
    80003f44:	4581                	li	a1,0
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	de0080e7          	jalr	-544(ra) # 80003d26 <namex>
}
    80003f4e:	60e2                	ld	ra,24(sp)
    80003f50:	6442                	ld	s0,16(sp)
    80003f52:	6105                	add	sp,sp,32
    80003f54:	8082                	ret

0000000080003f56 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f56:	1141                	add	sp,sp,-16
    80003f58:	e406                	sd	ra,8(sp)
    80003f5a:	e022                	sd	s0,0(sp)
    80003f5c:	0800                	add	s0,sp,16
    80003f5e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f60:	4585                	li	a1,1
    80003f62:	00000097          	auipc	ra,0x0
    80003f66:	dc4080e7          	jalr	-572(ra) # 80003d26 <namex>
}
    80003f6a:	60a2                	ld	ra,8(sp)
    80003f6c:	6402                	ld	s0,0(sp)
    80003f6e:	0141                	add	sp,sp,16
    80003f70:	8082                	ret

0000000080003f72 <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    80003f72:	1101                	add	sp,sp,-32
    80003f74:	ec06                	sd	ra,24(sp)
    80003f76:	e822                	sd	s0,16(sp)
    80003f78:	e426                	sd	s1,8(sp)
    80003f7a:	e04a                	sd	s2,0(sp)
    80003f7c:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f7e:	0001d917          	auipc	s2,0x1d
    80003f82:	c8290913          	add	s2,s2,-894 # 80020c00 <log>
    80003f86:	01892583          	lw	a1,24(s2)
    80003f8a:	02892503          	lw	a0,40(s2)
    80003f8e:	fffff097          	auipc	ra,0xfffff
    80003f92:	ff4080e7          	jalr	-12(ra) # 80002f82 <bread>
    80003f96:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f98:	02c92603          	lw	a2,44(s2)
    80003f9c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f9e:	00c05f63          	blez	a2,80003fbc <write_head+0x4a>
    80003fa2:	0001d717          	auipc	a4,0x1d
    80003fa6:	c8e70713          	add	a4,a4,-882 # 80020c30 <log+0x30>
    80003faa:	87aa                	mv	a5,a0
    80003fac:	060a                	sll	a2,a2,0x2
    80003fae:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003fb0:	4314                	lw	a3,0(a4)
    80003fb2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003fb4:	0711                	add	a4,a4,4
    80003fb6:	0791                	add	a5,a5,4
    80003fb8:	fec79ce3          	bne	a5,a2,80003fb0 <write_head+0x3e>
  }
  bwrite(buf);
    80003fbc:	8526                	mv	a0,s1
    80003fbe:	fffff097          	auipc	ra,0xfffff
    80003fc2:	0b6080e7          	jalr	182(ra) # 80003074 <bwrite>
  brelse(buf);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	fffff097          	auipc	ra,0xfffff
    80003fcc:	0ea080e7          	jalr	234(ra) # 800030b2 <brelse>
}
    80003fd0:	60e2                	ld	ra,24(sp)
    80003fd2:	6442                	ld	s0,16(sp)
    80003fd4:	64a2                	ld	s1,8(sp)
    80003fd6:	6902                	ld	s2,0(sp)
    80003fd8:	6105                	add	sp,sp,32
    80003fda:	8082                	ret

0000000080003fdc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fdc:	0001d797          	auipc	a5,0x1d
    80003fe0:	c507a783          	lw	a5,-944(a5) # 80020c2c <log+0x2c>
    80003fe4:	0af05d63          	blez	a5,8000409e <install_trans+0xc2>
{
    80003fe8:	7139                	add	sp,sp,-64
    80003fea:	fc06                	sd	ra,56(sp)
    80003fec:	f822                	sd	s0,48(sp)
    80003fee:	f426                	sd	s1,40(sp)
    80003ff0:	f04a                	sd	s2,32(sp)
    80003ff2:	ec4e                	sd	s3,24(sp)
    80003ff4:	e852                	sd	s4,16(sp)
    80003ff6:	e456                	sd	s5,8(sp)
    80003ff8:	e05a                	sd	s6,0(sp)
    80003ffa:	0080                	add	s0,sp,64
    80003ffc:	8b2a                	mv	s6,a0
    80003ffe:	0001da97          	auipc	s5,0x1d
    80004002:	c32a8a93          	add	s5,s5,-974 # 80020c30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004006:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80004008:	0001d997          	auipc	s3,0x1d
    8000400c:	bf898993          	add	s3,s3,-1032 # 80020c00 <log>
    80004010:	a00d                	j	80004032 <install_trans+0x56>
    brelse(lbuf);
    80004012:	854a                	mv	a0,s2
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	09e080e7          	jalr	158(ra) # 800030b2 <brelse>
    brelse(dbuf);
    8000401c:	8526                	mv	a0,s1
    8000401e:	fffff097          	auipc	ra,0xfffff
    80004022:	094080e7          	jalr	148(ra) # 800030b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004026:	2a05                	addw	s4,s4,1
    80004028:	0a91                	add	s5,s5,4
    8000402a:	02c9a783          	lw	a5,44(s3)
    8000402e:	04fa5e63          	bge	s4,a5,8000408a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80004032:	0189a583          	lw	a1,24(s3)
    80004036:	014585bb          	addw	a1,a1,s4
    8000403a:	2585                	addw	a1,a1,1
    8000403c:	0289a503          	lw	a0,40(s3)
    80004040:	fffff097          	auipc	ra,0xfffff
    80004044:	f42080e7          	jalr	-190(ra) # 80002f82 <bread>
    80004048:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    8000404a:	000aa583          	lw	a1,0(s5)
    8000404e:	0289a503          	lw	a0,40(s3)
    80004052:	fffff097          	auipc	ra,0xfffff
    80004056:	f30080e7          	jalr	-208(ra) # 80002f82 <bread>
    8000405a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    8000405c:	40000613          	li	a2,1024
    80004060:	05890593          	add	a1,s2,88
    80004064:	05850513          	add	a0,a0,88
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	dbc080e7          	jalr	-580(ra) # 80000e24 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    80004070:	8526                	mv	a0,s1
    80004072:	fffff097          	auipc	ra,0xfffff
    80004076:	002080e7          	jalr	2(ra) # 80003074 <bwrite>
    if(recovering == 0)
    8000407a:	f80b1ce3          	bnez	s6,80004012 <install_trans+0x36>
      bunpin(dbuf);
    8000407e:	8526                	mv	a0,s1
    80004080:	fffff097          	auipc	ra,0xfffff
    80004084:	10a080e7          	jalr	266(ra) # 8000318a <bunpin>
    80004088:	b769                	j	80004012 <install_trans+0x36>
}
    8000408a:	70e2                	ld	ra,56(sp)
    8000408c:	7442                	ld	s0,48(sp)
    8000408e:	74a2                	ld	s1,40(sp)
    80004090:	7902                	ld	s2,32(sp)
    80004092:	69e2                	ld	s3,24(sp)
    80004094:	6a42                	ld	s4,16(sp)
    80004096:	6aa2                	ld	s5,8(sp)
    80004098:	6b02                	ld	s6,0(sp)
    8000409a:	6121                	add	sp,sp,64
    8000409c:	8082                	ret
    8000409e:	8082                	ret

00000000800040a0 <initlog>:
{
    800040a0:	7179                	add	sp,sp,-48
    800040a2:	f406                	sd	ra,40(sp)
    800040a4:	f022                	sd	s0,32(sp)
    800040a6:	ec26                	sd	s1,24(sp)
    800040a8:	e84a                	sd	s2,16(sp)
    800040aa:	e44e                	sd	s3,8(sp)
    800040ac:	1800                	add	s0,sp,48
    800040ae:	892a                	mv	s2,a0
    800040b0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800040b2:	0001d497          	auipc	s1,0x1d
    800040b6:	b4e48493          	add	s1,s1,-1202 # 80020c00 <log>
    800040ba:	00004597          	auipc	a1,0x4
    800040be:	5ae58593          	add	a1,a1,1454 # 80008668 <syscalls+0x1d8>
    800040c2:	8526                	mv	a0,s1
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	b78080e7          	jalr	-1160(ra) # 80000c3c <initlock>
  log.start = sb->logstart;
    800040cc:	0149a583          	lw	a1,20(s3)
    800040d0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040d2:	0109a783          	lw	a5,16(s3)
    800040d6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040d8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040dc:	854a                	mv	a0,s2
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	ea4080e7          	jalr	-348(ra) # 80002f82 <bread>
  log.lh.n = lh->n;
    800040e6:	4d30                	lw	a2,88(a0)
    800040e8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040ea:	00c05f63          	blez	a2,80004108 <initlog+0x68>
    800040ee:	87aa                	mv	a5,a0
    800040f0:	0001d717          	auipc	a4,0x1d
    800040f4:	b4070713          	add	a4,a4,-1216 # 80020c30 <log+0x30>
    800040f8:	060a                	sll	a2,a2,0x2
    800040fa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800040fc:	4ff4                	lw	a3,92(a5)
    800040fe:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004100:	0791                	add	a5,a5,4
    80004102:	0711                	add	a4,a4,4
    80004104:	fec79ce3          	bne	a5,a2,800040fc <initlog+0x5c>
  brelse(buf);
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	faa080e7          	jalr	-86(ra) # 800030b2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    80004110:	4505                	li	a0,1
    80004112:	00000097          	auipc	ra,0x0
    80004116:	eca080e7          	jalr	-310(ra) # 80003fdc <install_trans>
  log.lh.n = 0;
    8000411a:	0001d797          	auipc	a5,0x1d
    8000411e:	b007a923          	sw	zero,-1262(a5) # 80020c2c <log+0x2c>
  write_head(); /* clear the log */
    80004122:	00000097          	auipc	ra,0x0
    80004126:	e50080e7          	jalr	-432(ra) # 80003f72 <write_head>
}
    8000412a:	70a2                	ld	ra,40(sp)
    8000412c:	7402                	ld	s0,32(sp)
    8000412e:	64e2                	ld	s1,24(sp)
    80004130:	6942                	ld	s2,16(sp)
    80004132:	69a2                	ld	s3,8(sp)
    80004134:	6145                	add	sp,sp,48
    80004136:	8082                	ret

0000000080004138 <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    80004138:	1101                	add	sp,sp,-32
    8000413a:	ec06                	sd	ra,24(sp)
    8000413c:	e822                	sd	s0,16(sp)
    8000413e:	e426                	sd	s1,8(sp)
    80004140:	e04a                	sd	s2,0(sp)
    80004142:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80004144:	0001d517          	auipc	a0,0x1d
    80004148:	abc50513          	add	a0,a0,-1348 # 80020c00 <log>
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	b80080e7          	jalr	-1152(ra) # 80000ccc <acquire>
  while(1){
    if(log.committing){
    80004154:	0001d497          	auipc	s1,0x1d
    80004158:	aac48493          	add	s1,s1,-1364 # 80020c00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000415c:	4979                	li	s2,30
    8000415e:	a039                	j	8000416c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004160:	85a6                	mv	a1,s1
    80004162:	8526                	mv	a0,s1
    80004164:	ffffe097          	auipc	ra,0xffffe
    80004168:	06c080e7          	jalr	108(ra) # 800021d0 <sleep>
    if(log.committing){
    8000416c:	50dc                	lw	a5,36(s1)
    8000416e:	fbed                	bnez	a5,80004160 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004170:	5098                	lw	a4,32(s1)
    80004172:	2705                	addw	a4,a4,1
    80004174:	0027179b          	sllw	a5,a4,0x2
    80004178:	9fb9                	addw	a5,a5,a4
    8000417a:	0017979b          	sllw	a5,a5,0x1
    8000417e:	54d4                	lw	a3,44(s1)
    80004180:	9fb5                	addw	a5,a5,a3
    80004182:	00f95963          	bge	s2,a5,80004194 <begin_op+0x5c>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    80004186:	85a6                	mv	a1,s1
    80004188:	8526                	mv	a0,s1
    8000418a:	ffffe097          	auipc	ra,0xffffe
    8000418e:	046080e7          	jalr	70(ra) # 800021d0 <sleep>
    80004192:	bfe9                	j	8000416c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004194:	0001d517          	auipc	a0,0x1d
    80004198:	a6c50513          	add	a0,a0,-1428 # 80020c00 <log>
    8000419c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000419e:	ffffd097          	auipc	ra,0xffffd
    800041a2:	be2080e7          	jalr	-1054(ra) # 80000d80 <release>
      break;
    }
  }
}
    800041a6:	60e2                	ld	ra,24(sp)
    800041a8:	6442                	ld	s0,16(sp)
    800041aa:	64a2                	ld	s1,8(sp)
    800041ac:	6902                	ld	s2,0(sp)
    800041ae:	6105                	add	sp,sp,32
    800041b0:	8082                	ret

00000000800041b2 <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    800041b2:	7139                	add	sp,sp,-64
    800041b4:	fc06                	sd	ra,56(sp)
    800041b6:	f822                	sd	s0,48(sp)
    800041b8:	f426                	sd	s1,40(sp)
    800041ba:	f04a                	sd	s2,32(sp)
    800041bc:	ec4e                	sd	s3,24(sp)
    800041be:	e852                	sd	s4,16(sp)
    800041c0:	e456                	sd	s5,8(sp)
    800041c2:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041c4:	0001d497          	auipc	s1,0x1d
    800041c8:	a3c48493          	add	s1,s1,-1476 # 80020c00 <log>
    800041cc:	8526                	mv	a0,s1
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	afe080e7          	jalr	-1282(ra) # 80000ccc <acquire>
  log.outstanding -= 1;
    800041d6:	509c                	lw	a5,32(s1)
    800041d8:	37fd                	addw	a5,a5,-1
    800041da:	0007891b          	sext.w	s2,a5
    800041de:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041e0:	50dc                	lw	a5,36(s1)
    800041e2:	e7b9                	bnez	a5,80004230 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041e4:	04091e63          	bnez	s2,80004240 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041e8:	0001d497          	auipc	s1,0x1d
    800041ec:	a1848493          	add	s1,s1,-1512 # 80020c00 <log>
    800041f0:	4785                	li	a5,1
    800041f2:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    800041f4:	8526                	mv	a0,s1
    800041f6:	ffffd097          	auipc	ra,0xffffd
    800041fa:	b8a080e7          	jalr	-1142(ra) # 80000d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041fe:	54dc                	lw	a5,44(s1)
    80004200:	06f04763          	bgtz	a5,8000426e <end_op+0xbc>
    acquire(&log.lock);
    80004204:	0001d497          	auipc	s1,0x1d
    80004208:	9fc48493          	add	s1,s1,-1540 # 80020c00 <log>
    8000420c:	8526                	mv	a0,s1
    8000420e:	ffffd097          	auipc	ra,0xffffd
    80004212:	abe080e7          	jalr	-1346(ra) # 80000ccc <acquire>
    log.committing = 0;
    80004216:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000421a:	8526                	mv	a0,s1
    8000421c:	ffffe097          	auipc	ra,0xffffe
    80004220:	018080e7          	jalr	24(ra) # 80002234 <wakeup>
    release(&log.lock);
    80004224:	8526                	mv	a0,s1
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	b5a080e7          	jalr	-1190(ra) # 80000d80 <release>
}
    8000422e:	a03d                	j	8000425c <end_op+0xaa>
    panic("log.committing");
    80004230:	00004517          	auipc	a0,0x4
    80004234:	44050513          	add	a0,a0,1088 # 80008670 <syscalls+0x1e0>
    80004238:	ffffc097          	auipc	ra,0xffffc
    8000423c:	5d6080e7          	jalr	1494(ra) # 8000080e <panic>
    wakeup(&log);
    80004240:	0001d497          	auipc	s1,0x1d
    80004244:	9c048493          	add	s1,s1,-1600 # 80020c00 <log>
    80004248:	8526                	mv	a0,s1
    8000424a:	ffffe097          	auipc	ra,0xffffe
    8000424e:	fea080e7          	jalr	-22(ra) # 80002234 <wakeup>
  release(&log.lock);
    80004252:	8526                	mv	a0,s1
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	b2c080e7          	jalr	-1236(ra) # 80000d80 <release>
}
    8000425c:	70e2                	ld	ra,56(sp)
    8000425e:	7442                	ld	s0,48(sp)
    80004260:	74a2                	ld	s1,40(sp)
    80004262:	7902                	ld	s2,32(sp)
    80004264:	69e2                	ld	s3,24(sp)
    80004266:	6a42                	ld	s4,16(sp)
    80004268:	6aa2                	ld	s5,8(sp)
    8000426a:	6121                	add	sp,sp,64
    8000426c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000426e:	0001da97          	auipc	s5,0x1d
    80004272:	9c2a8a93          	add	s5,s5,-1598 # 80020c30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    80004276:	0001da17          	auipc	s4,0x1d
    8000427a:	98aa0a13          	add	s4,s4,-1654 # 80020c00 <log>
    8000427e:	018a2583          	lw	a1,24(s4)
    80004282:	012585bb          	addw	a1,a1,s2
    80004286:	2585                	addw	a1,a1,1
    80004288:	028a2503          	lw	a0,40(s4)
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	cf6080e7          	jalr	-778(ra) # 80002f82 <bread>
    80004294:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    80004296:	000aa583          	lw	a1,0(s5)
    8000429a:	028a2503          	lw	a0,40(s4)
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	ce4080e7          	jalr	-796(ra) # 80002f82 <bread>
    800042a6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800042a8:	40000613          	li	a2,1024
    800042ac:	05850593          	add	a1,a0,88
    800042b0:	05848513          	add	a0,s1,88
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	b70080e7          	jalr	-1168(ra) # 80000e24 <memmove>
    bwrite(to);  /* write the log */
    800042bc:	8526                	mv	a0,s1
    800042be:	fffff097          	auipc	ra,0xfffff
    800042c2:	db6080e7          	jalr	-586(ra) # 80003074 <bwrite>
    brelse(from);
    800042c6:	854e                	mv	a0,s3
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	dea080e7          	jalr	-534(ra) # 800030b2 <brelse>
    brelse(to);
    800042d0:	8526                	mv	a0,s1
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	de0080e7          	jalr	-544(ra) # 800030b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042da:	2905                	addw	s2,s2,1
    800042dc:	0a91                	add	s5,s5,4
    800042de:	02ca2783          	lw	a5,44(s4)
    800042e2:	f8f94ee3          	blt	s2,a5,8000427e <end_op+0xcc>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    800042e6:	00000097          	auipc	ra,0x0
    800042ea:	c8c080e7          	jalr	-884(ra) # 80003f72 <write_head>
    install_trans(0); /* Now install writes to home locations */
    800042ee:	4501                	li	a0,0
    800042f0:	00000097          	auipc	ra,0x0
    800042f4:	cec080e7          	jalr	-788(ra) # 80003fdc <install_trans>
    log.lh.n = 0;
    800042f8:	0001d797          	auipc	a5,0x1d
    800042fc:	9207aa23          	sw	zero,-1740(a5) # 80020c2c <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    80004300:	00000097          	auipc	ra,0x0
    80004304:	c72080e7          	jalr	-910(ra) # 80003f72 <write_head>
    80004308:	bdf5                	j	80004204 <end_op+0x52>

000000008000430a <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    8000430a:	1101                	add	sp,sp,-32
    8000430c:	ec06                	sd	ra,24(sp)
    8000430e:	e822                	sd	s0,16(sp)
    80004310:	e426                	sd	s1,8(sp)
    80004312:	e04a                	sd	s2,0(sp)
    80004314:	1000                	add	s0,sp,32
    80004316:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004318:	0001d917          	auipc	s2,0x1d
    8000431c:	8e890913          	add	s2,s2,-1816 # 80020c00 <log>
    80004320:	854a                	mv	a0,s2
    80004322:	ffffd097          	auipc	ra,0xffffd
    80004326:	9aa080e7          	jalr	-1622(ra) # 80000ccc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000432a:	02c92603          	lw	a2,44(s2)
    8000432e:	47f5                	li	a5,29
    80004330:	06c7c563          	blt	a5,a2,8000439a <log_write+0x90>
    80004334:	0001d797          	auipc	a5,0x1d
    80004338:	8e87a783          	lw	a5,-1816(a5) # 80020c1c <log+0x1c>
    8000433c:	37fd                	addw	a5,a5,-1
    8000433e:	04f65e63          	bge	a2,a5,8000439a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004342:	0001d797          	auipc	a5,0x1d
    80004346:	8de7a783          	lw	a5,-1826(a5) # 80020c20 <log+0x20>
    8000434a:	06f05063          	blez	a5,800043aa <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000434e:	4781                	li	a5,0
    80004350:	06c05563          	blez	a2,800043ba <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80004354:	44cc                	lw	a1,12(s1)
    80004356:	0001d717          	auipc	a4,0x1d
    8000435a:	8da70713          	add	a4,a4,-1830 # 80020c30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000435e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80004360:	4314                	lw	a3,0(a4)
    80004362:	04b68c63          	beq	a3,a1,800043ba <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004366:	2785                	addw	a5,a5,1
    80004368:	0711                	add	a4,a4,4
    8000436a:	fef61be3          	bne	a2,a5,80004360 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000436e:	0621                	add	a2,a2,8
    80004370:	060a                	sll	a2,a2,0x2
    80004372:	0001d797          	auipc	a5,0x1d
    80004376:	88e78793          	add	a5,a5,-1906 # 80020c00 <log>
    8000437a:	97b2                	add	a5,a5,a2
    8000437c:	44d8                	lw	a4,12(s1)
    8000437e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    80004380:	8526                	mv	a0,s1
    80004382:	fffff097          	auipc	ra,0xfffff
    80004386:	dcc080e7          	jalr	-564(ra) # 8000314e <bpin>
    log.lh.n++;
    8000438a:	0001d717          	auipc	a4,0x1d
    8000438e:	87670713          	add	a4,a4,-1930 # 80020c00 <log>
    80004392:	575c                	lw	a5,44(a4)
    80004394:	2785                	addw	a5,a5,1
    80004396:	d75c                	sw	a5,44(a4)
    80004398:	a82d                	j	800043d2 <log_write+0xc8>
    panic("too big a transaction");
    8000439a:	00004517          	auipc	a0,0x4
    8000439e:	2e650513          	add	a0,a0,742 # 80008680 <syscalls+0x1f0>
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	46c080e7          	jalr	1132(ra) # 8000080e <panic>
    panic("log_write outside of trans");
    800043aa:	00004517          	auipc	a0,0x4
    800043ae:	2ee50513          	add	a0,a0,750 # 80008698 <syscalls+0x208>
    800043b2:	ffffc097          	auipc	ra,0xffffc
    800043b6:	45c080e7          	jalr	1116(ra) # 8000080e <panic>
  log.lh.block[i] = b->blockno;
    800043ba:	00878693          	add	a3,a5,8
    800043be:	068a                	sll	a3,a3,0x2
    800043c0:	0001d717          	auipc	a4,0x1d
    800043c4:	84070713          	add	a4,a4,-1984 # 80020c00 <log>
    800043c8:	9736                	add	a4,a4,a3
    800043ca:	44d4                	lw	a3,12(s1)
    800043cc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    800043ce:	faf609e3          	beq	a2,a5,80004380 <log_write+0x76>
  }
  release(&log.lock);
    800043d2:	0001d517          	auipc	a0,0x1d
    800043d6:	82e50513          	add	a0,a0,-2002 # 80020c00 <log>
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	9a6080e7          	jalr	-1626(ra) # 80000d80 <release>
}
    800043e2:	60e2                	ld	ra,24(sp)
    800043e4:	6442                	ld	s0,16(sp)
    800043e6:	64a2                	ld	s1,8(sp)
    800043e8:	6902                	ld	s2,0(sp)
    800043ea:	6105                	add	sp,sp,32
    800043ec:	8082                	ret

00000000800043ee <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043ee:	1101                	add	sp,sp,-32
    800043f0:	ec06                	sd	ra,24(sp)
    800043f2:	e822                	sd	s0,16(sp)
    800043f4:	e426                	sd	s1,8(sp)
    800043f6:	e04a                	sd	s2,0(sp)
    800043f8:	1000                	add	s0,sp,32
    800043fa:	84aa                	mv	s1,a0
    800043fc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043fe:	00004597          	auipc	a1,0x4
    80004402:	2ba58593          	add	a1,a1,698 # 800086b8 <syscalls+0x228>
    80004406:	0521                	add	a0,a0,8
    80004408:	ffffd097          	auipc	ra,0xffffd
    8000440c:	834080e7          	jalr	-1996(ra) # 80000c3c <initlock>
  lk->name = name;
    80004410:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004414:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004418:	0204a423          	sw	zero,40(s1)
}
    8000441c:	60e2                	ld	ra,24(sp)
    8000441e:	6442                	ld	s0,16(sp)
    80004420:	64a2                	ld	s1,8(sp)
    80004422:	6902                	ld	s2,0(sp)
    80004424:	6105                	add	sp,sp,32
    80004426:	8082                	ret

0000000080004428 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004428:	1101                	add	sp,sp,-32
    8000442a:	ec06                	sd	ra,24(sp)
    8000442c:	e822                	sd	s0,16(sp)
    8000442e:	e426                	sd	s1,8(sp)
    80004430:	e04a                	sd	s2,0(sp)
    80004432:	1000                	add	s0,sp,32
    80004434:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004436:	00850913          	add	s2,a0,8
    8000443a:	854a                	mv	a0,s2
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	890080e7          	jalr	-1904(ra) # 80000ccc <acquire>
  while (lk->locked) {
    80004444:	409c                	lw	a5,0(s1)
    80004446:	cb89                	beqz	a5,80004458 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004448:	85ca                	mv	a1,s2
    8000444a:	8526                	mv	a0,s1
    8000444c:	ffffe097          	auipc	ra,0xffffe
    80004450:	d84080e7          	jalr	-636(ra) # 800021d0 <sleep>
  while (lk->locked) {
    80004454:	409c                	lw	a5,0(s1)
    80004456:	fbed                	bnez	a5,80004448 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004458:	4785                	li	a5,1
    8000445a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	6a8080e7          	jalr	1704(ra) # 80001b04 <myproc>
    80004464:	591c                	lw	a5,48(a0)
    80004466:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004468:	854a                	mv	a0,s2
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	916080e7          	jalr	-1770(ra) # 80000d80 <release>
}
    80004472:	60e2                	ld	ra,24(sp)
    80004474:	6442                	ld	s0,16(sp)
    80004476:	64a2                	ld	s1,8(sp)
    80004478:	6902                	ld	s2,0(sp)
    8000447a:	6105                	add	sp,sp,32
    8000447c:	8082                	ret

000000008000447e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000447e:	1101                	add	sp,sp,-32
    80004480:	ec06                	sd	ra,24(sp)
    80004482:	e822                	sd	s0,16(sp)
    80004484:	e426                	sd	s1,8(sp)
    80004486:	e04a                	sd	s2,0(sp)
    80004488:	1000                	add	s0,sp,32
    8000448a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000448c:	00850913          	add	s2,a0,8
    80004490:	854a                	mv	a0,s2
    80004492:	ffffd097          	auipc	ra,0xffffd
    80004496:	83a080e7          	jalr	-1990(ra) # 80000ccc <acquire>
  lk->locked = 0;
    8000449a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000449e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800044a2:	8526                	mv	a0,s1
    800044a4:	ffffe097          	auipc	ra,0xffffe
    800044a8:	d90080e7          	jalr	-624(ra) # 80002234 <wakeup>
  release(&lk->lk);
    800044ac:	854a                	mv	a0,s2
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	8d2080e7          	jalr	-1838(ra) # 80000d80 <release>
}
    800044b6:	60e2                	ld	ra,24(sp)
    800044b8:	6442                	ld	s0,16(sp)
    800044ba:	64a2                	ld	s1,8(sp)
    800044bc:	6902                	ld	s2,0(sp)
    800044be:	6105                	add	sp,sp,32
    800044c0:	8082                	ret

00000000800044c2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044c2:	7179                	add	sp,sp,-48
    800044c4:	f406                	sd	ra,40(sp)
    800044c6:	f022                	sd	s0,32(sp)
    800044c8:	ec26                	sd	s1,24(sp)
    800044ca:	e84a                	sd	s2,16(sp)
    800044cc:	e44e                	sd	s3,8(sp)
    800044ce:	1800                	add	s0,sp,48
    800044d0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044d2:	00850913          	add	s2,a0,8
    800044d6:	854a                	mv	a0,s2
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	7f4080e7          	jalr	2036(ra) # 80000ccc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044e0:	409c                	lw	a5,0(s1)
    800044e2:	ef99                	bnez	a5,80004500 <holdingsleep+0x3e>
    800044e4:	4481                	li	s1,0
  release(&lk->lk);
    800044e6:	854a                	mv	a0,s2
    800044e8:	ffffd097          	auipc	ra,0xffffd
    800044ec:	898080e7          	jalr	-1896(ra) # 80000d80 <release>
  return r;
}
    800044f0:	8526                	mv	a0,s1
    800044f2:	70a2                	ld	ra,40(sp)
    800044f4:	7402                	ld	s0,32(sp)
    800044f6:	64e2                	ld	s1,24(sp)
    800044f8:	6942                	ld	s2,16(sp)
    800044fa:	69a2                	ld	s3,8(sp)
    800044fc:	6145                	add	sp,sp,48
    800044fe:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004500:	0284a983          	lw	s3,40(s1)
    80004504:	ffffd097          	auipc	ra,0xffffd
    80004508:	600080e7          	jalr	1536(ra) # 80001b04 <myproc>
    8000450c:	5904                	lw	s1,48(a0)
    8000450e:	413484b3          	sub	s1,s1,s3
    80004512:	0014b493          	seqz	s1,s1
    80004516:	bfc1                	j	800044e6 <holdingsleep+0x24>

0000000080004518 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004518:	1141                	add	sp,sp,-16
    8000451a:	e406                	sd	ra,8(sp)
    8000451c:	e022                	sd	s0,0(sp)
    8000451e:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004520:	00004597          	auipc	a1,0x4
    80004524:	1a858593          	add	a1,a1,424 # 800086c8 <syscalls+0x238>
    80004528:	0001d517          	auipc	a0,0x1d
    8000452c:	82050513          	add	a0,a0,-2016 # 80020d48 <ftable>
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	70c080e7          	jalr	1804(ra) # 80000c3c <initlock>
}
    80004538:	60a2                	ld	ra,8(sp)
    8000453a:	6402                	ld	s0,0(sp)
    8000453c:	0141                	add	sp,sp,16
    8000453e:	8082                	ret

0000000080004540 <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    80004540:	1101                	add	sp,sp,-32
    80004542:	ec06                	sd	ra,24(sp)
    80004544:	e822                	sd	s0,16(sp)
    80004546:	e426                	sd	s1,8(sp)
    80004548:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000454a:	0001c517          	auipc	a0,0x1c
    8000454e:	7fe50513          	add	a0,a0,2046 # 80020d48 <ftable>
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	77a080e7          	jalr	1914(ra) # 80000ccc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000455a:	0001d497          	auipc	s1,0x1d
    8000455e:	80648493          	add	s1,s1,-2042 # 80020d60 <ftable+0x18>
    80004562:	0001d717          	auipc	a4,0x1d
    80004566:	79e70713          	add	a4,a4,1950 # 80021d00 <disk>
    if(f->ref == 0){
    8000456a:	40dc                	lw	a5,4(s1)
    8000456c:	cf99                	beqz	a5,8000458a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000456e:	02848493          	add	s1,s1,40
    80004572:	fee49ce3          	bne	s1,a4,8000456a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004576:	0001c517          	auipc	a0,0x1c
    8000457a:	7d250513          	add	a0,a0,2002 # 80020d48 <ftable>
    8000457e:	ffffd097          	auipc	ra,0xffffd
    80004582:	802080e7          	jalr	-2046(ra) # 80000d80 <release>
  return 0;
    80004586:	4481                	li	s1,0
    80004588:	a819                	j	8000459e <filealloc+0x5e>
      f->ref = 1;
    8000458a:	4785                	li	a5,1
    8000458c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000458e:	0001c517          	auipc	a0,0x1c
    80004592:	7ba50513          	add	a0,a0,1978 # 80020d48 <ftable>
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	7ea080e7          	jalr	2026(ra) # 80000d80 <release>
}
    8000459e:	8526                	mv	a0,s1
    800045a0:	60e2                	ld	ra,24(sp)
    800045a2:	6442                	ld	s0,16(sp)
    800045a4:	64a2                	ld	s1,8(sp)
    800045a6:	6105                	add	sp,sp,32
    800045a8:	8082                	ret

00000000800045aa <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    800045aa:	1101                	add	sp,sp,-32
    800045ac:	ec06                	sd	ra,24(sp)
    800045ae:	e822                	sd	s0,16(sp)
    800045b0:	e426                	sd	s1,8(sp)
    800045b2:	1000                	add	s0,sp,32
    800045b4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800045b6:	0001c517          	auipc	a0,0x1c
    800045ba:	79250513          	add	a0,a0,1938 # 80020d48 <ftable>
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	70e080e7          	jalr	1806(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    800045c6:	40dc                	lw	a5,4(s1)
    800045c8:	02f05263          	blez	a5,800045ec <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045cc:	2785                	addw	a5,a5,1
    800045ce:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045d0:	0001c517          	auipc	a0,0x1c
    800045d4:	77850513          	add	a0,a0,1912 # 80020d48 <ftable>
    800045d8:	ffffc097          	auipc	ra,0xffffc
    800045dc:	7a8080e7          	jalr	1960(ra) # 80000d80 <release>
  return f;
}
    800045e0:	8526                	mv	a0,s1
    800045e2:	60e2                	ld	ra,24(sp)
    800045e4:	6442                	ld	s0,16(sp)
    800045e6:	64a2                	ld	s1,8(sp)
    800045e8:	6105                	add	sp,sp,32
    800045ea:	8082                	ret
    panic("filedup");
    800045ec:	00004517          	auipc	a0,0x4
    800045f0:	0e450513          	add	a0,a0,228 # 800086d0 <syscalls+0x240>
    800045f4:	ffffc097          	auipc	ra,0xffffc
    800045f8:	21a080e7          	jalr	538(ra) # 8000080e <panic>

00000000800045fc <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    800045fc:	7139                	add	sp,sp,-64
    800045fe:	fc06                	sd	ra,56(sp)
    80004600:	f822                	sd	s0,48(sp)
    80004602:	f426                	sd	s1,40(sp)
    80004604:	f04a                	sd	s2,32(sp)
    80004606:	ec4e                	sd	s3,24(sp)
    80004608:	e852                	sd	s4,16(sp)
    8000460a:	e456                	sd	s5,8(sp)
    8000460c:	0080                	add	s0,sp,64
    8000460e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004610:	0001c517          	auipc	a0,0x1c
    80004614:	73850513          	add	a0,a0,1848 # 80020d48 <ftable>
    80004618:	ffffc097          	auipc	ra,0xffffc
    8000461c:	6b4080e7          	jalr	1716(ra) # 80000ccc <acquire>
  if(f->ref < 1)
    80004620:	40dc                	lw	a5,4(s1)
    80004622:	06f05163          	blez	a5,80004684 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004626:	37fd                	addw	a5,a5,-1
    80004628:	0007871b          	sext.w	a4,a5
    8000462c:	c0dc                	sw	a5,4(s1)
    8000462e:	06e04363          	bgtz	a4,80004694 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004632:	0004a903          	lw	s2,0(s1)
    80004636:	0094ca83          	lbu	s5,9(s1)
    8000463a:	0104ba03          	ld	s4,16(s1)
    8000463e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004642:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004646:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000464a:	0001c517          	auipc	a0,0x1c
    8000464e:	6fe50513          	add	a0,a0,1790 # 80020d48 <ftable>
    80004652:	ffffc097          	auipc	ra,0xffffc
    80004656:	72e080e7          	jalr	1838(ra) # 80000d80 <release>

  if(ff.type == FD_PIPE){
    8000465a:	4785                	li	a5,1
    8000465c:	04f90d63          	beq	s2,a5,800046b6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004660:	3979                	addw	s2,s2,-2
    80004662:	4785                	li	a5,1
    80004664:	0527e063          	bltu	a5,s2,800046a4 <fileclose+0xa8>
    begin_op();
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	ad0080e7          	jalr	-1328(ra) # 80004138 <begin_op>
    iput(ff.ip);
    80004670:	854e                	mv	a0,s3
    80004672:	fffff097          	auipc	ra,0xfffff
    80004676:	2da080e7          	jalr	730(ra) # 8000394c <iput>
    end_op();
    8000467a:	00000097          	auipc	ra,0x0
    8000467e:	b38080e7          	jalr	-1224(ra) # 800041b2 <end_op>
    80004682:	a00d                	j	800046a4 <fileclose+0xa8>
    panic("fileclose");
    80004684:	00004517          	auipc	a0,0x4
    80004688:	05450513          	add	a0,a0,84 # 800086d8 <syscalls+0x248>
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	182080e7          	jalr	386(ra) # 8000080e <panic>
    release(&ftable.lock);
    80004694:	0001c517          	auipc	a0,0x1c
    80004698:	6b450513          	add	a0,a0,1716 # 80020d48 <ftable>
    8000469c:	ffffc097          	auipc	ra,0xffffc
    800046a0:	6e4080e7          	jalr	1764(ra) # 80000d80 <release>
  }
}
    800046a4:	70e2                	ld	ra,56(sp)
    800046a6:	7442                	ld	s0,48(sp)
    800046a8:	74a2                	ld	s1,40(sp)
    800046aa:	7902                	ld	s2,32(sp)
    800046ac:	69e2                	ld	s3,24(sp)
    800046ae:	6a42                	ld	s4,16(sp)
    800046b0:	6aa2                	ld	s5,8(sp)
    800046b2:	6121                	add	sp,sp,64
    800046b4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046b6:	85d6                	mv	a1,s5
    800046b8:	8552                	mv	a0,s4
    800046ba:	00000097          	auipc	ra,0x0
    800046be:	348080e7          	jalr	840(ra) # 80004a02 <pipeclose>
    800046c2:	b7cd                	j	800046a4 <fileclose+0xa8>

00000000800046c4 <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    800046c4:	715d                	add	sp,sp,-80
    800046c6:	e486                	sd	ra,72(sp)
    800046c8:	e0a2                	sd	s0,64(sp)
    800046ca:	fc26                	sd	s1,56(sp)
    800046cc:	f84a                	sd	s2,48(sp)
    800046ce:	f44e                	sd	s3,40(sp)
    800046d0:	0880                	add	s0,sp,80
    800046d2:	84aa                	mv	s1,a0
    800046d4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046d6:	ffffd097          	auipc	ra,0xffffd
    800046da:	42e080e7          	jalr	1070(ra) # 80001b04 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046de:	409c                	lw	a5,0(s1)
    800046e0:	37f9                	addw	a5,a5,-2
    800046e2:	4705                	li	a4,1
    800046e4:	04f76763          	bltu	a4,a5,80004732 <filestat+0x6e>
    800046e8:	892a                	mv	s2,a0
    ilock(f->ip);
    800046ea:	6c88                	ld	a0,24(s1)
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	0a6080e7          	jalr	166(ra) # 80003792 <ilock>
    stati(f->ip, &st);
    800046f4:	fb840593          	add	a1,s0,-72
    800046f8:	6c88                	ld	a0,24(s1)
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	322080e7          	jalr	802(ra) # 80003a1c <stati>
    iunlock(f->ip);
    80004702:	6c88                	ld	a0,24(s1)
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	150080e7          	jalr	336(ra) # 80003854 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000470c:	46e1                	li	a3,24
    8000470e:	fb840613          	add	a2,s0,-72
    80004712:	85ce                	mv	a1,s3
    80004714:	05893503          	ld	a0,88(s2)
    80004718:	ffffd097          	auipc	ra,0xffffd
    8000471c:	06c080e7          	jalr	108(ra) # 80001784 <copyout>
    80004720:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004724:	60a6                	ld	ra,72(sp)
    80004726:	6406                	ld	s0,64(sp)
    80004728:	74e2                	ld	s1,56(sp)
    8000472a:	7942                	ld	s2,48(sp)
    8000472c:	79a2                	ld	s3,40(sp)
    8000472e:	6161                	add	sp,sp,80
    80004730:	8082                	ret
  return -1;
    80004732:	557d                	li	a0,-1
    80004734:	bfc5                	j	80004724 <filestat+0x60>

0000000080004736 <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80004736:	7179                	add	sp,sp,-48
    80004738:	f406                	sd	ra,40(sp)
    8000473a:	f022                	sd	s0,32(sp)
    8000473c:	ec26                	sd	s1,24(sp)
    8000473e:	e84a                	sd	s2,16(sp)
    80004740:	e44e                	sd	s3,8(sp)
    80004742:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004744:	00854783          	lbu	a5,8(a0)
    80004748:	c3d5                	beqz	a5,800047ec <fileread+0xb6>
    8000474a:	84aa                	mv	s1,a0
    8000474c:	89ae                	mv	s3,a1
    8000474e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004750:	411c                	lw	a5,0(a0)
    80004752:	4705                	li	a4,1
    80004754:	04e78963          	beq	a5,a4,800047a6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004758:	470d                	li	a4,3
    8000475a:	04e78d63          	beq	a5,a4,800047b4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000475e:	4709                	li	a4,2
    80004760:	06e79e63          	bne	a5,a4,800047dc <fileread+0xa6>
    ilock(f->ip);
    80004764:	6d08                	ld	a0,24(a0)
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	02c080e7          	jalr	44(ra) # 80003792 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000476e:	874a                	mv	a4,s2
    80004770:	5094                	lw	a3,32(s1)
    80004772:	864e                	mv	a2,s3
    80004774:	4585                	li	a1,1
    80004776:	6c88                	ld	a0,24(s1)
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	2ce080e7          	jalr	718(ra) # 80003a46 <readi>
    80004780:	892a                	mv	s2,a0
    80004782:	00a05563          	blez	a0,8000478c <fileread+0x56>
      f->off += r;
    80004786:	509c                	lw	a5,32(s1)
    80004788:	9fa9                	addw	a5,a5,a0
    8000478a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000478c:	6c88                	ld	a0,24(s1)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	0c6080e7          	jalr	198(ra) # 80003854 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004796:	854a                	mv	a0,s2
    80004798:	70a2                	ld	ra,40(sp)
    8000479a:	7402                	ld	s0,32(sp)
    8000479c:	64e2                	ld	s1,24(sp)
    8000479e:	6942                	ld	s2,16(sp)
    800047a0:	69a2                	ld	s3,8(sp)
    800047a2:	6145                	add	sp,sp,48
    800047a4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800047a6:	6908                	ld	a0,16(a0)
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	3c2080e7          	jalr	962(ra) # 80004b6a <piperead>
    800047b0:	892a                	mv	s2,a0
    800047b2:	b7d5                	j	80004796 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800047b4:	02451783          	lh	a5,36(a0)
    800047b8:	03079693          	sll	a3,a5,0x30
    800047bc:	92c1                	srl	a3,a3,0x30
    800047be:	4725                	li	a4,9
    800047c0:	02d76863          	bltu	a4,a3,800047f0 <fileread+0xba>
    800047c4:	0792                	sll	a5,a5,0x4
    800047c6:	0001c717          	auipc	a4,0x1c
    800047ca:	4e270713          	add	a4,a4,1250 # 80020ca8 <devsw>
    800047ce:	97ba                	add	a5,a5,a4
    800047d0:	639c                	ld	a5,0(a5)
    800047d2:	c38d                	beqz	a5,800047f4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047d4:	4505                	li	a0,1
    800047d6:	9782                	jalr	a5
    800047d8:	892a                	mv	s2,a0
    800047da:	bf75                	j	80004796 <fileread+0x60>
    panic("fileread");
    800047dc:	00004517          	auipc	a0,0x4
    800047e0:	f0c50513          	add	a0,a0,-244 # 800086e8 <syscalls+0x258>
    800047e4:	ffffc097          	auipc	ra,0xffffc
    800047e8:	02a080e7          	jalr	42(ra) # 8000080e <panic>
    return -1;
    800047ec:	597d                	li	s2,-1
    800047ee:	b765                	j	80004796 <fileread+0x60>
      return -1;
    800047f0:	597d                	li	s2,-1
    800047f2:	b755                	j	80004796 <fileread+0x60>
    800047f4:	597d                	li	s2,-1
    800047f6:	b745                	j	80004796 <fileread+0x60>

00000000800047f8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800047f8:	00954783          	lbu	a5,9(a0)
    800047fc:	10078e63          	beqz	a5,80004918 <filewrite+0x120>
{
    80004800:	715d                	add	sp,sp,-80
    80004802:	e486                	sd	ra,72(sp)
    80004804:	e0a2                	sd	s0,64(sp)
    80004806:	fc26                	sd	s1,56(sp)
    80004808:	f84a                	sd	s2,48(sp)
    8000480a:	f44e                	sd	s3,40(sp)
    8000480c:	f052                	sd	s4,32(sp)
    8000480e:	ec56                	sd	s5,24(sp)
    80004810:	e85a                	sd	s6,16(sp)
    80004812:	e45e                	sd	s7,8(sp)
    80004814:	e062                	sd	s8,0(sp)
    80004816:	0880                	add	s0,sp,80
    80004818:	892a                	mv	s2,a0
    8000481a:	8b2e                	mv	s6,a1
    8000481c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000481e:	411c                	lw	a5,0(a0)
    80004820:	4705                	li	a4,1
    80004822:	02e78263          	beq	a5,a4,80004846 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004826:	470d                	li	a4,3
    80004828:	02e78563          	beq	a5,a4,80004852 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000482c:	4709                	li	a4,2
    8000482e:	0ce79d63          	bne	a5,a4,80004908 <filewrite+0x110>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004832:	0ac05b63          	blez	a2,800048e8 <filewrite+0xf0>
    int i = 0;
    80004836:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004838:	6b85                	lui	s7,0x1
    8000483a:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000483e:	6c05                	lui	s8,0x1
    80004840:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004844:	a851                	j	800048d8 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004846:	6908                	ld	a0,16(a0)
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	22a080e7          	jalr	554(ra) # 80004a72 <pipewrite>
    80004850:	a045                	j	800048f0 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004852:	02451783          	lh	a5,36(a0)
    80004856:	03079693          	sll	a3,a5,0x30
    8000485a:	92c1                	srl	a3,a3,0x30
    8000485c:	4725                	li	a4,9
    8000485e:	0ad76f63          	bltu	a4,a3,8000491c <filewrite+0x124>
    80004862:	0792                	sll	a5,a5,0x4
    80004864:	0001c717          	auipc	a4,0x1c
    80004868:	44470713          	add	a4,a4,1092 # 80020ca8 <devsw>
    8000486c:	97ba                	add	a5,a5,a4
    8000486e:	679c                	ld	a5,8(a5)
    80004870:	cbc5                	beqz	a5,80004920 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004872:	4505                	li	a0,1
    80004874:	9782                	jalr	a5
    80004876:	a8ad                	j	800048f0 <filewrite+0xf8>
      if(n1 > max)
    80004878:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	8bc080e7          	jalr	-1860(ra) # 80004138 <begin_op>
      ilock(f->ip);
    80004884:	01893503          	ld	a0,24(s2)
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	f0a080e7          	jalr	-246(ra) # 80003792 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004890:	8756                	mv	a4,s5
    80004892:	02092683          	lw	a3,32(s2)
    80004896:	01698633          	add	a2,s3,s6
    8000489a:	4585                	li	a1,1
    8000489c:	01893503          	ld	a0,24(s2)
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	29e080e7          	jalr	670(ra) # 80003b3e <writei>
    800048a8:	84aa                	mv	s1,a0
    800048aa:	00a05763          	blez	a0,800048b8 <filewrite+0xc0>
        f->off += r;
    800048ae:	02092783          	lw	a5,32(s2)
    800048b2:	9fa9                	addw	a5,a5,a0
    800048b4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800048b8:	01893503          	ld	a0,24(s2)
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	f98080e7          	jalr	-104(ra) # 80003854 <iunlock>
      end_op();
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	8ee080e7          	jalr	-1810(ra) # 800041b2 <end_op>

      if(r != n1){
    800048cc:	009a9f63          	bne	s5,s1,800048ea <filewrite+0xf2>
        /* error from writei */
        break;
      }
      i += r;
    800048d0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048d4:	0149db63          	bge	s3,s4,800048ea <filewrite+0xf2>
      int n1 = n - i;
    800048d8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800048dc:	0004879b          	sext.w	a5,s1
    800048e0:	f8fbdce3          	bge	s7,a5,80004878 <filewrite+0x80>
    800048e4:	84e2                	mv	s1,s8
    800048e6:	bf49                	j	80004878 <filewrite+0x80>
    int i = 0;
    800048e8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048ea:	033a1d63          	bne	s4,s3,80004924 <filewrite+0x12c>
    800048ee:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048f0:	60a6                	ld	ra,72(sp)
    800048f2:	6406                	ld	s0,64(sp)
    800048f4:	74e2                	ld	s1,56(sp)
    800048f6:	7942                	ld	s2,48(sp)
    800048f8:	79a2                	ld	s3,40(sp)
    800048fa:	7a02                	ld	s4,32(sp)
    800048fc:	6ae2                	ld	s5,24(sp)
    800048fe:	6b42                	ld	s6,16(sp)
    80004900:	6ba2                	ld	s7,8(sp)
    80004902:	6c02                	ld	s8,0(sp)
    80004904:	6161                	add	sp,sp,80
    80004906:	8082                	ret
    panic("filewrite");
    80004908:	00004517          	auipc	a0,0x4
    8000490c:	df050513          	add	a0,a0,-528 # 800086f8 <syscalls+0x268>
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	efe080e7          	jalr	-258(ra) # 8000080e <panic>
    return -1;
    80004918:	557d                	li	a0,-1
}
    8000491a:	8082                	ret
      return -1;
    8000491c:	557d                	li	a0,-1
    8000491e:	bfc9                	j	800048f0 <filewrite+0xf8>
    80004920:	557d                	li	a0,-1
    80004922:	b7f9                	j	800048f0 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80004924:	557d                	li	a0,-1
    80004926:	b7e9                	j	800048f0 <filewrite+0xf8>

0000000080004928 <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004928:	7179                	add	sp,sp,-48
    8000492a:	f406                	sd	ra,40(sp)
    8000492c:	f022                	sd	s0,32(sp)
    8000492e:	ec26                	sd	s1,24(sp)
    80004930:	e84a                	sd	s2,16(sp)
    80004932:	e44e                	sd	s3,8(sp)
    80004934:	e052                	sd	s4,0(sp)
    80004936:	1800                	add	s0,sp,48
    80004938:	84aa                	mv	s1,a0
    8000493a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000493c:	0005b023          	sd	zero,0(a1)
    80004940:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004944:	00000097          	auipc	ra,0x0
    80004948:	bfc080e7          	jalr	-1028(ra) # 80004540 <filealloc>
    8000494c:	e088                	sd	a0,0(s1)
    8000494e:	c551                	beqz	a0,800049da <pipealloc+0xb2>
    80004950:	00000097          	auipc	ra,0x0
    80004954:	bf0080e7          	jalr	-1040(ra) # 80004540 <filealloc>
    80004958:	00aa3023          	sd	a0,0(s4)
    8000495c:	c92d                	beqz	a0,800049ce <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000495e:	ffffc097          	auipc	ra,0xffffc
    80004962:	27e080e7          	jalr	638(ra) # 80000bdc <kalloc>
    80004966:	892a                	mv	s2,a0
    80004968:	c125                	beqz	a0,800049c8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000496a:	4985                	li	s3,1
    8000496c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004970:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004974:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004978:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000497c:	00004597          	auipc	a1,0x4
    80004980:	d8c58593          	add	a1,a1,-628 # 80008708 <syscalls+0x278>
    80004984:	ffffc097          	auipc	ra,0xffffc
    80004988:	2b8080e7          	jalr	696(ra) # 80000c3c <initlock>
  (*f0)->type = FD_PIPE;
    8000498c:	609c                	ld	a5,0(s1)
    8000498e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004992:	609c                	ld	a5,0(s1)
    80004994:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004998:	609c                	ld	a5,0(s1)
    8000499a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000499e:	609c                	ld	a5,0(s1)
    800049a0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800049a4:	000a3783          	ld	a5,0(s4)
    800049a8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049ac:	000a3783          	ld	a5,0(s4)
    800049b0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049b4:	000a3783          	ld	a5,0(s4)
    800049b8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049bc:	000a3783          	ld	a5,0(s4)
    800049c0:	0127b823          	sd	s2,16(a5)
  return 0;
    800049c4:	4501                	li	a0,0
    800049c6:	a025                	j	800049ee <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049c8:	6088                	ld	a0,0(s1)
    800049ca:	e501                	bnez	a0,800049d2 <pipealloc+0xaa>
    800049cc:	a039                	j	800049da <pipealloc+0xb2>
    800049ce:	6088                	ld	a0,0(s1)
    800049d0:	c51d                	beqz	a0,800049fe <pipealloc+0xd6>
    fileclose(*f0);
    800049d2:	00000097          	auipc	ra,0x0
    800049d6:	c2a080e7          	jalr	-982(ra) # 800045fc <fileclose>
  if(*f1)
    800049da:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049de:	557d                	li	a0,-1
  if(*f1)
    800049e0:	c799                	beqz	a5,800049ee <pipealloc+0xc6>
    fileclose(*f1);
    800049e2:	853e                	mv	a0,a5
    800049e4:	00000097          	auipc	ra,0x0
    800049e8:	c18080e7          	jalr	-1000(ra) # 800045fc <fileclose>
  return -1;
    800049ec:	557d                	li	a0,-1
}
    800049ee:	70a2                	ld	ra,40(sp)
    800049f0:	7402                	ld	s0,32(sp)
    800049f2:	64e2                	ld	s1,24(sp)
    800049f4:	6942                	ld	s2,16(sp)
    800049f6:	69a2                	ld	s3,8(sp)
    800049f8:	6a02                	ld	s4,0(sp)
    800049fa:	6145                	add	sp,sp,48
    800049fc:	8082                	ret
  return -1;
    800049fe:	557d                	li	a0,-1
    80004a00:	b7fd                	j	800049ee <pipealloc+0xc6>

0000000080004a02 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a02:	1101                	add	sp,sp,-32
    80004a04:	ec06                	sd	ra,24(sp)
    80004a06:	e822                	sd	s0,16(sp)
    80004a08:	e426                	sd	s1,8(sp)
    80004a0a:	e04a                	sd	s2,0(sp)
    80004a0c:	1000                	add	s0,sp,32
    80004a0e:	84aa                	mv	s1,a0
    80004a10:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a12:	ffffc097          	auipc	ra,0xffffc
    80004a16:	2ba080e7          	jalr	698(ra) # 80000ccc <acquire>
  if(writable){
    80004a1a:	02090d63          	beqz	s2,80004a54 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a1e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a22:	21848513          	add	a0,s1,536
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	80e080e7          	jalr	-2034(ra) # 80002234 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a2e:	2204b783          	ld	a5,544(s1)
    80004a32:	eb95                	bnez	a5,80004a66 <pipeclose+0x64>
    release(&pi->lock);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffc097          	auipc	ra,0xffffc
    80004a3a:	34a080e7          	jalr	842(ra) # 80000d80 <release>
    kfree((char*)pi);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffc097          	auipc	ra,0xffffc
    80004a44:	09e080e7          	jalr	158(ra) # 80000ade <kfree>
  } else
    release(&pi->lock);
}
    80004a48:	60e2                	ld	ra,24(sp)
    80004a4a:	6442                	ld	s0,16(sp)
    80004a4c:	64a2                	ld	s1,8(sp)
    80004a4e:	6902                	ld	s2,0(sp)
    80004a50:	6105                	add	sp,sp,32
    80004a52:	8082                	ret
    pi->readopen = 0;
    80004a54:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a58:	21c48513          	add	a0,s1,540
    80004a5c:	ffffd097          	auipc	ra,0xffffd
    80004a60:	7d8080e7          	jalr	2008(ra) # 80002234 <wakeup>
    80004a64:	b7e9                	j	80004a2e <pipeclose+0x2c>
    release(&pi->lock);
    80004a66:	8526                	mv	a0,s1
    80004a68:	ffffc097          	auipc	ra,0xffffc
    80004a6c:	318080e7          	jalr	792(ra) # 80000d80 <release>
}
    80004a70:	bfe1                	j	80004a48 <pipeclose+0x46>

0000000080004a72 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a72:	711d                	add	sp,sp,-96
    80004a74:	ec86                	sd	ra,88(sp)
    80004a76:	e8a2                	sd	s0,80(sp)
    80004a78:	e4a6                	sd	s1,72(sp)
    80004a7a:	e0ca                	sd	s2,64(sp)
    80004a7c:	fc4e                	sd	s3,56(sp)
    80004a7e:	f852                	sd	s4,48(sp)
    80004a80:	f456                	sd	s5,40(sp)
    80004a82:	f05a                	sd	s6,32(sp)
    80004a84:	ec5e                	sd	s7,24(sp)
    80004a86:	e862                	sd	s8,16(sp)
    80004a88:	1080                	add	s0,sp,96
    80004a8a:	84aa                	mv	s1,a0
    80004a8c:	8aae                	mv	s5,a1
    80004a8e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004a90:	ffffd097          	auipc	ra,0xffffd
    80004a94:	074080e7          	jalr	116(ra) # 80001b04 <myproc>
    80004a98:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	ffffc097          	auipc	ra,0xffffc
    80004aa0:	230080e7          	jalr	560(ra) # 80000ccc <acquire>
  while(i < n){
    80004aa4:	0b405663          	blez	s4,80004b50 <pipewrite+0xde>
  int i = 0;
    80004aa8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004aaa:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004aac:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ab0:	21c48b93          	add	s7,s1,540
    80004ab4:	a089                	j	80004af6 <pipewrite+0x84>
      release(&pi->lock);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffc097          	auipc	ra,0xffffc
    80004abc:	2c8080e7          	jalr	712(ra) # 80000d80 <release>
      return -1;
    80004ac0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004ac2:	854a                	mv	a0,s2
    80004ac4:	60e6                	ld	ra,88(sp)
    80004ac6:	6446                	ld	s0,80(sp)
    80004ac8:	64a6                	ld	s1,72(sp)
    80004aca:	6906                	ld	s2,64(sp)
    80004acc:	79e2                	ld	s3,56(sp)
    80004ace:	7a42                	ld	s4,48(sp)
    80004ad0:	7aa2                	ld	s5,40(sp)
    80004ad2:	7b02                	ld	s6,32(sp)
    80004ad4:	6be2                	ld	s7,24(sp)
    80004ad6:	6c42                	ld	s8,16(sp)
    80004ad8:	6125                	add	sp,sp,96
    80004ada:	8082                	ret
      wakeup(&pi->nread);
    80004adc:	8562                	mv	a0,s8
    80004ade:	ffffd097          	auipc	ra,0xffffd
    80004ae2:	756080e7          	jalr	1878(ra) # 80002234 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ae6:	85a6                	mv	a1,s1
    80004ae8:	855e                	mv	a0,s7
    80004aea:	ffffd097          	auipc	ra,0xffffd
    80004aee:	6e6080e7          	jalr	1766(ra) # 800021d0 <sleep>
  while(i < n){
    80004af2:	07495063          	bge	s2,s4,80004b52 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004af6:	2204a783          	lw	a5,544(s1)
    80004afa:	dfd5                	beqz	a5,80004ab6 <pipewrite+0x44>
    80004afc:	854e                	mv	a0,s3
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	97a080e7          	jalr	-1670(ra) # 80002478 <killed>
    80004b06:	f945                	bnez	a0,80004ab6 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    80004b08:	2184a783          	lw	a5,536(s1)
    80004b0c:	21c4a703          	lw	a4,540(s1)
    80004b10:	2007879b          	addw	a5,a5,512
    80004b14:	fcf704e3          	beq	a4,a5,80004adc <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b18:	4685                	li	a3,1
    80004b1a:	01590633          	add	a2,s2,s5
    80004b1e:	faf40593          	add	a1,s0,-81
    80004b22:	0589b503          	ld	a0,88(s3)
    80004b26:	ffffd097          	auipc	ra,0xffffd
    80004b2a:	d1e080e7          	jalr	-738(ra) # 80001844 <copyin>
    80004b2e:	03650263          	beq	a0,s6,80004b52 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b32:	21c4a783          	lw	a5,540(s1)
    80004b36:	0017871b          	addw	a4,a5,1
    80004b3a:	20e4ae23          	sw	a4,540(s1)
    80004b3e:	1ff7f793          	and	a5,a5,511
    80004b42:	97a6                	add	a5,a5,s1
    80004b44:	faf44703          	lbu	a4,-81(s0)
    80004b48:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b4c:	2905                	addw	s2,s2,1
    80004b4e:	b755                	j	80004af2 <pipewrite+0x80>
  int i = 0;
    80004b50:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b52:	21848513          	add	a0,s1,536
    80004b56:	ffffd097          	auipc	ra,0xffffd
    80004b5a:	6de080e7          	jalr	1758(ra) # 80002234 <wakeup>
  release(&pi->lock);
    80004b5e:	8526                	mv	a0,s1
    80004b60:	ffffc097          	auipc	ra,0xffffc
    80004b64:	220080e7          	jalr	544(ra) # 80000d80 <release>
  return i;
    80004b68:	bfa9                	j	80004ac2 <pipewrite+0x50>

0000000080004b6a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b6a:	715d                	add	sp,sp,-80
    80004b6c:	e486                	sd	ra,72(sp)
    80004b6e:	e0a2                	sd	s0,64(sp)
    80004b70:	fc26                	sd	s1,56(sp)
    80004b72:	f84a                	sd	s2,48(sp)
    80004b74:	f44e                	sd	s3,40(sp)
    80004b76:	f052                	sd	s4,32(sp)
    80004b78:	ec56                	sd	s5,24(sp)
    80004b7a:	e85a                	sd	s6,16(sp)
    80004b7c:	0880                	add	s0,sp,80
    80004b7e:	84aa                	mv	s1,a0
    80004b80:	892e                	mv	s2,a1
    80004b82:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b84:	ffffd097          	auipc	ra,0xffffd
    80004b88:	f80080e7          	jalr	-128(ra) # 80001b04 <myproc>
    80004b8c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b8e:	8526                	mv	a0,s1
    80004b90:	ffffc097          	auipc	ra,0xffffc
    80004b94:	13c080e7          	jalr	316(ra) # 80000ccc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004b98:	2184a703          	lw	a4,536(s1)
    80004b9c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004ba0:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004ba4:	02f71763          	bne	a4,a5,80004bd2 <piperead+0x68>
    80004ba8:	2244a783          	lw	a5,548(s1)
    80004bac:	c39d                	beqz	a5,80004bd2 <piperead+0x68>
    if(killed(pr)){
    80004bae:	8552                	mv	a0,s4
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	8c8080e7          	jalr	-1848(ra) # 80002478 <killed>
    80004bb8:	e949                	bnez	a0,80004c4a <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004bba:	85a6                	mv	a1,s1
    80004bbc:	854e                	mv	a0,s3
    80004bbe:	ffffd097          	auipc	ra,0xffffd
    80004bc2:	612080e7          	jalr	1554(ra) # 800021d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004bc6:	2184a703          	lw	a4,536(s1)
    80004bca:	21c4a783          	lw	a5,540(s1)
    80004bce:	fcf70de3          	beq	a4,a5,80004ba8 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004bd2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bd4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004bd6:	05505463          	blez	s5,80004c1e <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004bda:	2184a783          	lw	a5,536(s1)
    80004bde:	21c4a703          	lw	a4,540(s1)
    80004be2:	02f70e63          	beq	a4,a5,80004c1e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004be6:	0017871b          	addw	a4,a5,1
    80004bea:	20e4ac23          	sw	a4,536(s1)
    80004bee:	1ff7f793          	and	a5,a5,511
    80004bf2:	97a6                	add	a5,a5,s1
    80004bf4:	0187c783          	lbu	a5,24(a5)
    80004bf8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bfc:	4685                	li	a3,1
    80004bfe:	fbf40613          	add	a2,s0,-65
    80004c02:	85ca                	mv	a1,s2
    80004c04:	058a3503          	ld	a0,88(s4)
    80004c08:	ffffd097          	auipc	ra,0xffffd
    80004c0c:	b7c080e7          	jalr	-1156(ra) # 80001784 <copyout>
    80004c10:	01650763          	beq	a0,s6,80004c1e <piperead+0xb4>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004c14:	2985                	addw	s3,s3,1
    80004c16:	0905                	add	s2,s2,1
    80004c18:	fd3a91e3          	bne	s5,s3,80004bda <piperead+0x70>
    80004c1c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    80004c1e:	21c48513          	add	a0,s1,540
    80004c22:	ffffd097          	auipc	ra,0xffffd
    80004c26:	612080e7          	jalr	1554(ra) # 80002234 <wakeup>
  release(&pi->lock);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffc097          	auipc	ra,0xffffc
    80004c30:	154080e7          	jalr	340(ra) # 80000d80 <release>
  return i;
}
    80004c34:	854e                	mv	a0,s3
    80004c36:	60a6                	ld	ra,72(sp)
    80004c38:	6406                	ld	s0,64(sp)
    80004c3a:	74e2                	ld	s1,56(sp)
    80004c3c:	7942                	ld	s2,48(sp)
    80004c3e:	79a2                	ld	s3,40(sp)
    80004c40:	7a02                	ld	s4,32(sp)
    80004c42:	6ae2                	ld	s5,24(sp)
    80004c44:	6b42                	ld	s6,16(sp)
    80004c46:	6161                	add	sp,sp,80
    80004c48:	8082                	ret
      release(&pi->lock);
    80004c4a:	8526                	mv	a0,s1
    80004c4c:	ffffc097          	auipc	ra,0xffffc
    80004c50:	134080e7          	jalr	308(ra) # 80000d80 <release>
      return -1;
    80004c54:	59fd                	li	s3,-1
    80004c56:	bff9                	j	80004c34 <piperead+0xca>

0000000080004c58 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004c58:	1141                	add	sp,sp,-16
    80004c5a:	e422                	sd	s0,8(sp)
    80004c5c:	0800                	add	s0,sp,16
    80004c5e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004c60:	8905                	and	a0,a0,1
    80004c62:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004c64:	8b89                	and	a5,a5,2
    80004c66:	c399                	beqz	a5,80004c6c <flags2perm+0x14>
      perm |= PTE_W;
    80004c68:	00456513          	or	a0,a0,4
    return perm;
}
    80004c6c:	6422                	ld	s0,8(sp)
    80004c6e:	0141                	add	sp,sp,16
    80004c70:	8082                	ret

0000000080004c72 <exec>:

int
exec(char *path, char **argv)
{
    80004c72:	df010113          	add	sp,sp,-528
    80004c76:	20113423          	sd	ra,520(sp)
    80004c7a:	20813023          	sd	s0,512(sp)
    80004c7e:	ffa6                	sd	s1,504(sp)
    80004c80:	fbca                	sd	s2,496(sp)
    80004c82:	f7ce                	sd	s3,488(sp)
    80004c84:	f3d2                	sd	s4,480(sp)
    80004c86:	efd6                	sd	s5,472(sp)
    80004c88:	ebda                	sd	s6,464(sp)
    80004c8a:	e7de                	sd	s7,456(sp)
    80004c8c:	e3e2                	sd	s8,448(sp)
    80004c8e:	ff66                	sd	s9,440(sp)
    80004c90:	fb6a                	sd	s10,432(sp)
    80004c92:	f76e                	sd	s11,424(sp)
    80004c94:	0c00                	add	s0,sp,528
    80004c96:	892a                	mv	s2,a0
    80004c98:	dea43c23          	sd	a0,-520(s0)
    80004c9c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ca0:	ffffd097          	auipc	ra,0xffffd
    80004ca4:	e64080e7          	jalr	-412(ra) # 80001b04 <myproc>
    80004ca8:	84aa                	mv	s1,a0

  begin_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	48e080e7          	jalr	1166(ra) # 80004138 <begin_op>

  if((ip = namei(path)) == 0){
    80004cb2:	854a                	mv	a0,s2
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	284080e7          	jalr	644(ra) # 80003f38 <namei>
    80004cbc:	c92d                	beqz	a0,80004d2e <exec+0xbc>
    80004cbe:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004cc0:	fffff097          	auipc	ra,0xfffff
    80004cc4:	ad2080e7          	jalr	-1326(ra) # 80003792 <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004cc8:	04000713          	li	a4,64
    80004ccc:	4681                	li	a3,0
    80004cce:	e5040613          	add	a2,s0,-432
    80004cd2:	4581                	li	a1,0
    80004cd4:	8552                	mv	a0,s4
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	d70080e7          	jalr	-656(ra) # 80003a46 <readi>
    80004cde:	04000793          	li	a5,64
    80004ce2:	00f51a63          	bne	a0,a5,80004cf6 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004ce6:	e5042703          	lw	a4,-432(s0)
    80004cea:	464c47b7          	lui	a5,0x464c4
    80004cee:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004cf2:	04f70463          	beq	a4,a5,80004d3a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004cf6:	8552                	mv	a0,s4
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	cfc080e7          	jalr	-772(ra) # 800039f4 <iunlockput>
    end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	4b2080e7          	jalr	1202(ra) # 800041b2 <end_op>
  }
  return -1;
    80004d08:	557d                	li	a0,-1
}
    80004d0a:	20813083          	ld	ra,520(sp)
    80004d0e:	20013403          	ld	s0,512(sp)
    80004d12:	74fe                	ld	s1,504(sp)
    80004d14:	795e                	ld	s2,496(sp)
    80004d16:	79be                	ld	s3,488(sp)
    80004d18:	7a1e                	ld	s4,480(sp)
    80004d1a:	6afe                	ld	s5,472(sp)
    80004d1c:	6b5e                	ld	s6,464(sp)
    80004d1e:	6bbe                	ld	s7,456(sp)
    80004d20:	6c1e                	ld	s8,448(sp)
    80004d22:	7cfa                	ld	s9,440(sp)
    80004d24:	7d5a                	ld	s10,432(sp)
    80004d26:	7dba                	ld	s11,424(sp)
    80004d28:	21010113          	add	sp,sp,528
    80004d2c:	8082                	ret
    end_op();
    80004d2e:	fffff097          	auipc	ra,0xfffff
    80004d32:	484080e7          	jalr	1156(ra) # 800041b2 <end_op>
    return -1;
    80004d36:	557d                	li	a0,-1
    80004d38:	bfc9                	j	80004d0a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d3a:	8526                	mv	a0,s1
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	e90080e7          	jalr	-368(ra) # 80001bcc <proc_pagetable>
    80004d44:	8b2a                	mv	s6,a0
    80004d46:	d945                	beqz	a0,80004cf6 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d48:	e7042d03          	lw	s10,-400(s0)
    80004d4c:	e8845783          	lhu	a5,-376(s0)
    80004d50:	10078463          	beqz	a5,80004e58 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d54:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d56:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004d58:	6c85                	lui	s9,0x1
    80004d5a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004d5e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004d62:	6a85                	lui	s5,0x1
    80004d64:	a0b5                	j	80004dd0 <exec+0x15e>
      panic("loadseg: address should exist");
    80004d66:	00004517          	auipc	a0,0x4
    80004d6a:	9aa50513          	add	a0,a0,-1622 # 80008710 <syscalls+0x280>
    80004d6e:	ffffc097          	auipc	ra,0xffffc
    80004d72:	aa0080e7          	jalr	-1376(ra) # 8000080e <panic>
    if(sz - i < PGSIZE)
    80004d76:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d78:	8726                	mv	a4,s1
    80004d7a:	012c06bb          	addw	a3,s8,s2
    80004d7e:	4581                	li	a1,0
    80004d80:	8552                	mv	a0,s4
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	cc4080e7          	jalr	-828(ra) # 80003a46 <readi>
    80004d8a:	2501                	sext.w	a0,a0
    80004d8c:	24a49863          	bne	s1,a0,80004fdc <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004d90:	012a893b          	addw	s2,s5,s2
    80004d94:	03397563          	bgeu	s2,s3,80004dbe <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004d98:	02091593          	sll	a1,s2,0x20
    80004d9c:	9181                	srl	a1,a1,0x20
    80004d9e:	95de                	add	a1,a1,s7
    80004da0:	855a                	mv	a0,s6
    80004da2:	ffffc097          	auipc	ra,0xffffc
    80004da6:	3ae080e7          	jalr	942(ra) # 80001150 <walkaddr>
    80004daa:	862a                	mv	a2,a0
    if(pa == 0)
    80004dac:	dd4d                	beqz	a0,80004d66 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004dae:	412984bb          	subw	s1,s3,s2
    80004db2:	0004879b          	sext.w	a5,s1
    80004db6:	fcfcf0e3          	bgeu	s9,a5,80004d76 <exec+0x104>
    80004dba:	84d6                	mv	s1,s5
    80004dbc:	bf6d                	j	80004d76 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004dbe:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dc2:	2d85                	addw	s11,s11,1
    80004dc4:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004dc8:	e8845783          	lhu	a5,-376(s0)
    80004dcc:	08fdd763          	bge	s11,a5,80004e5a <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004dd0:	2d01                	sext.w	s10,s10
    80004dd2:	03800713          	li	a4,56
    80004dd6:	86ea                	mv	a3,s10
    80004dd8:	e1840613          	add	a2,s0,-488
    80004ddc:	4581                	li	a1,0
    80004dde:	8552                	mv	a0,s4
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	c66080e7          	jalr	-922(ra) # 80003a46 <readi>
    80004de8:	03800793          	li	a5,56
    80004dec:	1ef51663          	bne	a0,a5,80004fd8 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004df0:	e1842783          	lw	a5,-488(s0)
    80004df4:	4705                	li	a4,1
    80004df6:	fce796e3          	bne	a5,a4,80004dc2 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004dfa:	e4043483          	ld	s1,-448(s0)
    80004dfe:	e3843783          	ld	a5,-456(s0)
    80004e02:	1ef4e863          	bltu	s1,a5,80004ff2 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e06:	e2843783          	ld	a5,-472(s0)
    80004e0a:	94be                	add	s1,s1,a5
    80004e0c:	1ef4e663          	bltu	s1,a5,80004ff8 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004e10:	df043703          	ld	a4,-528(s0)
    80004e14:	8ff9                	and	a5,a5,a4
    80004e16:	1e079463          	bnez	a5,80004ffe <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e1a:	e1c42503          	lw	a0,-484(s0)
    80004e1e:	00000097          	auipc	ra,0x0
    80004e22:	e3a080e7          	jalr	-454(ra) # 80004c58 <flags2perm>
    80004e26:	86aa                	mv	a3,a0
    80004e28:	8626                	mv	a2,s1
    80004e2a:	85ca                	mv	a1,s2
    80004e2c:	855a                	mv	a0,s6
    80004e2e:	ffffc097          	auipc	ra,0xffffc
    80004e32:	6fa080e7          	jalr	1786(ra) # 80001528 <uvmalloc>
    80004e36:	e0a43423          	sd	a0,-504(s0)
    80004e3a:	1c050563          	beqz	a0,80005004 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004e3e:	e2843b83          	ld	s7,-472(s0)
    80004e42:	e2042c03          	lw	s8,-480(s0)
    80004e46:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004e4a:	00098463          	beqz	s3,80004e52 <exec+0x1e0>
    80004e4e:	4901                	li	s2,0
    80004e50:	b7a1                	j	80004d98 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004e52:	e0843903          	ld	s2,-504(s0)
    80004e56:	b7b5                	j	80004dc2 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e58:	4901                	li	s2,0
  iunlockput(ip);
    80004e5a:	8552                	mv	a0,s4
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	b98080e7          	jalr	-1128(ra) # 800039f4 <iunlockput>
  end_op();
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	34e080e7          	jalr	846(ra) # 800041b2 <end_op>
  p = myproc();
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	c98080e7          	jalr	-872(ra) # 80001b04 <myproc>
    80004e74:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004e76:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004e7a:	6985                	lui	s3,0x1
    80004e7c:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004e7e:	99ca                	add	s3,s3,s2
    80004e80:	77fd                	lui	a5,0xfffff
    80004e82:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004e86:	4691                	li	a3,4
    80004e88:	6609                	lui	a2,0x2
    80004e8a:	964e                	add	a2,a2,s3
    80004e8c:	85ce                	mv	a1,s3
    80004e8e:	855a                	mv	a0,s6
    80004e90:	ffffc097          	auipc	ra,0xffffc
    80004e94:	698080e7          	jalr	1688(ra) # 80001528 <uvmalloc>
    80004e98:	892a                	mv	s2,a0
    80004e9a:	e0a43423          	sd	a0,-504(s0)
    80004e9e:	e509                	bnez	a0,80004ea8 <exec+0x236>
  if(pagetable)
    80004ea0:	e1343423          	sd	s3,-504(s0)
    80004ea4:	4a01                	li	s4,0
    80004ea6:	aa1d                	j	80004fdc <exec+0x36a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004ea8:	75f9                	lui	a1,0xffffe
    80004eaa:	95aa                	add	a1,a1,a0
    80004eac:	855a                	mv	a0,s6
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	8a4080e7          	jalr	-1884(ra) # 80001752 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004eb6:	7bfd                	lui	s7,0xfffff
    80004eb8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004eba:	e0043783          	ld	a5,-512(s0)
    80004ebe:	6388                	ld	a0,0(a5)
    80004ec0:	c52d                	beqz	a0,80004f2a <exec+0x2b8>
    80004ec2:	e9040993          	add	s3,s0,-368
    80004ec6:	f9040c13          	add	s8,s0,-112
    80004eca:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	076080e7          	jalr	118(ra) # 80000f42 <strlen>
    80004ed4:	0015079b          	addw	a5,a0,1
    80004ed8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    80004edc:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004ee0:	13796563          	bltu	s2,s7,8000500a <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ee4:	e0043d03          	ld	s10,-512(s0)
    80004ee8:	000d3a03          	ld	s4,0(s10)
    80004eec:	8552                	mv	a0,s4
    80004eee:	ffffc097          	auipc	ra,0xffffc
    80004ef2:	054080e7          	jalr	84(ra) # 80000f42 <strlen>
    80004ef6:	0015069b          	addw	a3,a0,1
    80004efa:	8652                	mv	a2,s4
    80004efc:	85ca                	mv	a1,s2
    80004efe:	855a                	mv	a0,s6
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	884080e7          	jalr	-1916(ra) # 80001784 <copyout>
    80004f08:	10054363          	bltz	a0,8000500e <exec+0x39c>
    ustack[argc] = sp;
    80004f0c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004f10:	0485                	add	s1,s1,1
    80004f12:	008d0793          	add	a5,s10,8
    80004f16:	e0f43023          	sd	a5,-512(s0)
    80004f1a:	008d3503          	ld	a0,8(s10)
    80004f1e:	c909                	beqz	a0,80004f30 <exec+0x2be>
    if(argc >= MAXARG)
    80004f20:	09a1                	add	s3,s3,8
    80004f22:	fb8995e3          	bne	s3,s8,80004ecc <exec+0x25a>
  ip = 0;
    80004f26:	4a01                	li	s4,0
    80004f28:	a855                	j	80004fdc <exec+0x36a>
  sp = sz;
    80004f2a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004f2e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004f30:	00349793          	sll	a5,s1,0x3
    80004f34:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd150>
    80004f38:	97a2                	add	a5,a5,s0
    80004f3a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004f3e:	00148693          	add	a3,s1,1
    80004f42:	068e                	sll	a3,a3,0x3
    80004f44:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004f48:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004f4c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004f50:	f57968e3          	bltu	s2,s7,80004ea0 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004f54:	e9040613          	add	a2,s0,-368
    80004f58:	85ca                	mv	a1,s2
    80004f5a:	855a                	mv	a0,s6
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	828080e7          	jalr	-2008(ra) # 80001784 <copyout>
    80004f64:	0a054763          	bltz	a0,80005012 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004f68:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80004f6c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004f70:	df843783          	ld	a5,-520(s0)
    80004f74:	0007c703          	lbu	a4,0(a5)
    80004f78:	cf11                	beqz	a4,80004f94 <exec+0x322>
    80004f7a:	0785                	add	a5,a5,1
    if(*s == '/')
    80004f7c:	02f00693          	li	a3,47
    80004f80:	a039                	j	80004f8e <exec+0x31c>
      last = s+1;
    80004f82:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004f86:	0785                	add	a5,a5,1
    80004f88:	fff7c703          	lbu	a4,-1(a5)
    80004f8c:	c701                	beqz	a4,80004f94 <exec+0x322>
    if(*s == '/')
    80004f8e:	fed71ce3          	bne	a4,a3,80004f86 <exec+0x314>
    80004f92:	bfc5                	j	80004f82 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f94:	4641                	li	a2,16
    80004f96:	df843583          	ld	a1,-520(s0)
    80004f9a:	160a8513          	add	a0,s5,352
    80004f9e:	ffffc097          	auipc	ra,0xffffc
    80004fa2:	f72080e7          	jalr	-142(ra) # 80000f10 <safestrcpy>
  oldpagetable = p->pagetable;
    80004fa6:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004faa:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80004fae:	e0843783          	ld	a5,-504(s0)
    80004fb2:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    80004fb6:	060ab783          	ld	a5,96(s5)
    80004fba:	e6843703          	ld	a4,-408(s0)
    80004fbe:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    80004fc0:	060ab783          	ld	a5,96(s5)
    80004fc4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004fc8:	85e6                	mv	a1,s9
    80004fca:	ffffd097          	auipc	ra,0xffffd
    80004fce:	c9e080e7          	jalr	-866(ra) # 80001c68 <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    80004fd2:	0004851b          	sext.w	a0,s1
    80004fd6:	bb15                	j	80004d0a <exec+0x98>
    80004fd8:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004fdc:	e0843583          	ld	a1,-504(s0)
    80004fe0:	855a                	mv	a0,s6
    80004fe2:	ffffd097          	auipc	ra,0xffffd
    80004fe6:	c86080e7          	jalr	-890(ra) # 80001c68 <proc_freepagetable>
  return -1;
    80004fea:	557d                	li	a0,-1
  if(ip){
    80004fec:	d00a0fe3          	beqz	s4,80004d0a <exec+0x98>
    80004ff0:	b319                	j	80004cf6 <exec+0x84>
    80004ff2:	e1243423          	sd	s2,-504(s0)
    80004ff6:	b7dd                	j	80004fdc <exec+0x36a>
    80004ff8:	e1243423          	sd	s2,-504(s0)
    80004ffc:	b7c5                	j	80004fdc <exec+0x36a>
    80004ffe:	e1243423          	sd	s2,-504(s0)
    80005002:	bfe9                	j	80004fdc <exec+0x36a>
    80005004:	e1243423          	sd	s2,-504(s0)
    80005008:	bfd1                	j	80004fdc <exec+0x36a>
  ip = 0;
    8000500a:	4a01                	li	s4,0
    8000500c:	bfc1                	j	80004fdc <exec+0x36a>
    8000500e:	4a01                	li	s4,0
  if(pagetable)
    80005010:	b7f1                	j	80004fdc <exec+0x36a>
  sz = sz1;
    80005012:	e0843983          	ld	s3,-504(s0)
    80005016:	b569                	j	80004ea0 <exec+0x22e>

0000000080005018 <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005018:	7179                	add	sp,sp,-48
    8000501a:	f406                	sd	ra,40(sp)
    8000501c:	f022                	sd	s0,32(sp)
    8000501e:	ec26                	sd	s1,24(sp)
    80005020:	e84a                	sd	s2,16(sp)
    80005022:	1800                	add	s0,sp,48
    80005024:	892e                	mv	s2,a1
    80005026:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005028:	fdc40593          	add	a1,s0,-36
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	bf6080e7          	jalr	-1034(ra) # 80002c22 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005034:	fdc42703          	lw	a4,-36(s0)
    80005038:	47bd                	li	a5,15
    8000503a:	02e7eb63          	bltu	a5,a4,80005070 <argfd+0x58>
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	ac6080e7          	jalr	-1338(ra) # 80001b04 <myproc>
    80005046:	fdc42703          	lw	a4,-36(s0)
    8000504a:	01a70793          	add	a5,a4,26
    8000504e:	078e                	sll	a5,a5,0x3
    80005050:	953e                	add	a0,a0,a5
    80005052:	651c                	ld	a5,8(a0)
    80005054:	c385                	beqz	a5,80005074 <argfd+0x5c>
    return -1;
  if(pfd)
    80005056:	00090463          	beqz	s2,8000505e <argfd+0x46>
    *pfd = fd;
    8000505a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000505e:	4501                	li	a0,0
  if(pf)
    80005060:	c091                	beqz	s1,80005064 <argfd+0x4c>
    *pf = f;
    80005062:	e09c                	sd	a5,0(s1)
}
    80005064:	70a2                	ld	ra,40(sp)
    80005066:	7402                	ld	s0,32(sp)
    80005068:	64e2                	ld	s1,24(sp)
    8000506a:	6942                	ld	s2,16(sp)
    8000506c:	6145                	add	sp,sp,48
    8000506e:	8082                	ret
    return -1;
    80005070:	557d                	li	a0,-1
    80005072:	bfcd                	j	80005064 <argfd+0x4c>
    80005074:	557d                	li	a0,-1
    80005076:	b7fd                	j	80005064 <argfd+0x4c>

0000000080005078 <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    80005078:	1101                	add	sp,sp,-32
    8000507a:	ec06                	sd	ra,24(sp)
    8000507c:	e822                	sd	s0,16(sp)
    8000507e:	e426                	sd	s1,8(sp)
    80005080:	1000                	add	s0,sp,32
    80005082:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005084:	ffffd097          	auipc	ra,0xffffd
    80005088:	a80080e7          	jalr	-1408(ra) # 80001b04 <myproc>
    8000508c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000508e:	0d850793          	add	a5,a0,216
    80005092:	4501                	li	a0,0
    80005094:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005096:	6398                	ld	a4,0(a5)
    80005098:	cb19                	beqz	a4,800050ae <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000509a:	2505                	addw	a0,a0,1
    8000509c:	07a1                	add	a5,a5,8
    8000509e:	fed51ce3          	bne	a0,a3,80005096 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800050a2:	557d                	li	a0,-1
}
    800050a4:	60e2                	ld	ra,24(sp)
    800050a6:	6442                	ld	s0,16(sp)
    800050a8:	64a2                	ld	s1,8(sp)
    800050aa:	6105                	add	sp,sp,32
    800050ac:	8082                	ret
      p->ofile[fd] = f;
    800050ae:	01a50793          	add	a5,a0,26
    800050b2:	078e                	sll	a5,a5,0x3
    800050b4:	963e                	add	a2,a2,a5
    800050b6:	e604                	sd	s1,8(a2)
      return fd;
    800050b8:	b7f5                	j	800050a4 <fdalloc+0x2c>

00000000800050ba <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050ba:	715d                	add	sp,sp,-80
    800050bc:	e486                	sd	ra,72(sp)
    800050be:	e0a2                	sd	s0,64(sp)
    800050c0:	fc26                	sd	s1,56(sp)
    800050c2:	f84a                	sd	s2,48(sp)
    800050c4:	f44e                	sd	s3,40(sp)
    800050c6:	f052                	sd	s4,32(sp)
    800050c8:	ec56                	sd	s5,24(sp)
    800050ca:	e85a                	sd	s6,16(sp)
    800050cc:	0880                	add	s0,sp,80
    800050ce:	8b2e                	mv	s6,a1
    800050d0:	89b2                	mv	s3,a2
    800050d2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050d4:	fb040593          	add	a1,s0,-80
    800050d8:	fffff097          	auipc	ra,0xfffff
    800050dc:	e7e080e7          	jalr	-386(ra) # 80003f56 <nameiparent>
    800050e0:	84aa                	mv	s1,a0
    800050e2:	14050b63          	beqz	a0,80005238 <create+0x17e>
    return 0;

  ilock(dp);
    800050e6:	ffffe097          	auipc	ra,0xffffe
    800050ea:	6ac080e7          	jalr	1708(ra) # 80003792 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800050ee:	4601                	li	a2,0
    800050f0:	fb040593          	add	a1,s0,-80
    800050f4:	8526                	mv	a0,s1
    800050f6:	fffff097          	auipc	ra,0xfffff
    800050fa:	b80080e7          	jalr	-1152(ra) # 80003c76 <dirlookup>
    800050fe:	8aaa                	mv	s5,a0
    80005100:	c921                	beqz	a0,80005150 <create+0x96>
    iunlockput(dp);
    80005102:	8526                	mv	a0,s1
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	8f0080e7          	jalr	-1808(ra) # 800039f4 <iunlockput>
    ilock(ip);
    8000510c:	8556                	mv	a0,s5
    8000510e:	ffffe097          	auipc	ra,0xffffe
    80005112:	684080e7          	jalr	1668(ra) # 80003792 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005116:	4789                	li	a5,2
    80005118:	02fb1563          	bne	s6,a5,80005142 <create+0x88>
    8000511c:	044ad783          	lhu	a5,68(s5)
    80005120:	37f9                	addw	a5,a5,-2
    80005122:	17c2                	sll	a5,a5,0x30
    80005124:	93c1                	srl	a5,a5,0x30
    80005126:	4705                	li	a4,1
    80005128:	00f76d63          	bltu	a4,a5,80005142 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000512c:	8556                	mv	a0,s5
    8000512e:	60a6                	ld	ra,72(sp)
    80005130:	6406                	ld	s0,64(sp)
    80005132:	74e2                	ld	s1,56(sp)
    80005134:	7942                	ld	s2,48(sp)
    80005136:	79a2                	ld	s3,40(sp)
    80005138:	7a02                	ld	s4,32(sp)
    8000513a:	6ae2                	ld	s5,24(sp)
    8000513c:	6b42                	ld	s6,16(sp)
    8000513e:	6161                	add	sp,sp,80
    80005140:	8082                	ret
    iunlockput(ip);
    80005142:	8556                	mv	a0,s5
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	8b0080e7          	jalr	-1872(ra) # 800039f4 <iunlockput>
    return 0;
    8000514c:	4a81                	li	s5,0
    8000514e:	bff9                	j	8000512c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005150:	85da                	mv	a1,s6
    80005152:	4088                	lw	a0,0(s1)
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	4a6080e7          	jalr	1190(ra) # 800035fa <ialloc>
    8000515c:	8a2a                	mv	s4,a0
    8000515e:	c529                	beqz	a0,800051a8 <create+0xee>
  ilock(ip);
    80005160:	ffffe097          	auipc	ra,0xffffe
    80005164:	632080e7          	jalr	1586(ra) # 80003792 <ilock>
  ip->major = major;
    80005168:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000516c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005170:	4905                	li	s2,1
    80005172:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005176:	8552                	mv	a0,s4
    80005178:	ffffe097          	auipc	ra,0xffffe
    8000517c:	54e080e7          	jalr	1358(ra) # 800036c6 <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    80005180:	032b0b63          	beq	s6,s2,800051b6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005184:	004a2603          	lw	a2,4(s4)
    80005188:	fb040593          	add	a1,s0,-80
    8000518c:	8526                	mv	a0,s1
    8000518e:	fffff097          	auipc	ra,0xfffff
    80005192:	cf8080e7          	jalr	-776(ra) # 80003e86 <dirlink>
    80005196:	06054f63          	bltz	a0,80005214 <create+0x15a>
  iunlockput(dp);
    8000519a:	8526                	mv	a0,s1
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	858080e7          	jalr	-1960(ra) # 800039f4 <iunlockput>
  return ip;
    800051a4:	8ad2                	mv	s5,s4
    800051a6:	b759                	j	8000512c <create+0x72>
    iunlockput(dp);
    800051a8:	8526                	mv	a0,s1
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	84a080e7          	jalr	-1974(ra) # 800039f4 <iunlockput>
    return 0;
    800051b2:	8ad2                	mv	s5,s4
    800051b4:	bfa5                	j	8000512c <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051b6:	004a2603          	lw	a2,4(s4)
    800051ba:	00003597          	auipc	a1,0x3
    800051be:	57658593          	add	a1,a1,1398 # 80008730 <syscalls+0x2a0>
    800051c2:	8552                	mv	a0,s4
    800051c4:	fffff097          	auipc	ra,0xfffff
    800051c8:	cc2080e7          	jalr	-830(ra) # 80003e86 <dirlink>
    800051cc:	04054463          	bltz	a0,80005214 <create+0x15a>
    800051d0:	40d0                	lw	a2,4(s1)
    800051d2:	00003597          	auipc	a1,0x3
    800051d6:	56658593          	add	a1,a1,1382 # 80008738 <syscalls+0x2a8>
    800051da:	8552                	mv	a0,s4
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	caa080e7          	jalr	-854(ra) # 80003e86 <dirlink>
    800051e4:	02054863          	bltz	a0,80005214 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800051e8:	004a2603          	lw	a2,4(s4)
    800051ec:	fb040593          	add	a1,s0,-80
    800051f0:	8526                	mv	a0,s1
    800051f2:	fffff097          	auipc	ra,0xfffff
    800051f6:	c94080e7          	jalr	-876(ra) # 80003e86 <dirlink>
    800051fa:	00054d63          	bltz	a0,80005214 <create+0x15a>
    dp->nlink++;  /* for ".." */
    800051fe:	04a4d783          	lhu	a5,74(s1)
    80005202:	2785                	addw	a5,a5,1
    80005204:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005208:	8526                	mv	a0,s1
    8000520a:	ffffe097          	auipc	ra,0xffffe
    8000520e:	4bc080e7          	jalr	1212(ra) # 800036c6 <iupdate>
    80005212:	b761                	j	8000519a <create+0xe0>
  ip->nlink = 0;
    80005214:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005218:	8552                	mv	a0,s4
    8000521a:	ffffe097          	auipc	ra,0xffffe
    8000521e:	4ac080e7          	jalr	1196(ra) # 800036c6 <iupdate>
  iunlockput(ip);
    80005222:	8552                	mv	a0,s4
    80005224:	ffffe097          	auipc	ra,0xffffe
    80005228:	7d0080e7          	jalr	2000(ra) # 800039f4 <iunlockput>
  iunlockput(dp);
    8000522c:	8526                	mv	a0,s1
    8000522e:	ffffe097          	auipc	ra,0xffffe
    80005232:	7c6080e7          	jalr	1990(ra) # 800039f4 <iunlockput>
  return 0;
    80005236:	bddd                	j	8000512c <create+0x72>
    return 0;
    80005238:	8aaa                	mv	s5,a0
    8000523a:	bdcd                	j	8000512c <create+0x72>

000000008000523c <sys_dup>:
{
    8000523c:	7179                	add	sp,sp,-48
    8000523e:	f406                	sd	ra,40(sp)
    80005240:	f022                	sd	s0,32(sp)
    80005242:	ec26                	sd	s1,24(sp)
    80005244:	e84a                	sd	s2,16(sp)
    80005246:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005248:	fd840613          	add	a2,s0,-40
    8000524c:	4581                	li	a1,0
    8000524e:	4501                	li	a0,0
    80005250:	00000097          	auipc	ra,0x0
    80005254:	dc8080e7          	jalr	-568(ra) # 80005018 <argfd>
    return -1;
    80005258:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000525a:	02054363          	bltz	a0,80005280 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000525e:	fd843903          	ld	s2,-40(s0)
    80005262:	854a                	mv	a0,s2
    80005264:	00000097          	auipc	ra,0x0
    80005268:	e14080e7          	jalr	-492(ra) # 80005078 <fdalloc>
    8000526c:	84aa                	mv	s1,a0
    return -1;
    8000526e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005270:	00054863          	bltz	a0,80005280 <sys_dup+0x44>
  filedup(f);
    80005274:	854a                	mv	a0,s2
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	334080e7          	jalr	820(ra) # 800045aa <filedup>
  return fd;
    8000527e:	87a6                	mv	a5,s1
}
    80005280:	853e                	mv	a0,a5
    80005282:	70a2                	ld	ra,40(sp)
    80005284:	7402                	ld	s0,32(sp)
    80005286:	64e2                	ld	s1,24(sp)
    80005288:	6942                	ld	s2,16(sp)
    8000528a:	6145                	add	sp,sp,48
    8000528c:	8082                	ret

000000008000528e <sys_read>:
{
    8000528e:	7179                	add	sp,sp,-48
    80005290:	f406                	sd	ra,40(sp)
    80005292:	f022                	sd	s0,32(sp)
    80005294:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80005296:	fd840593          	add	a1,s0,-40
    8000529a:	4505                	li	a0,1
    8000529c:	ffffe097          	auipc	ra,0xffffe
    800052a0:	9a6080e7          	jalr	-1626(ra) # 80002c42 <argaddr>
  argint(2, &n);
    800052a4:	fe440593          	add	a1,s0,-28
    800052a8:	4509                	li	a0,2
    800052aa:	ffffe097          	auipc	ra,0xffffe
    800052ae:	978080e7          	jalr	-1672(ra) # 80002c22 <argint>
  if(argfd(0, 0, &f) < 0)
    800052b2:	fe840613          	add	a2,s0,-24
    800052b6:	4581                	li	a1,0
    800052b8:	4501                	li	a0,0
    800052ba:	00000097          	auipc	ra,0x0
    800052be:	d5e080e7          	jalr	-674(ra) # 80005018 <argfd>
    800052c2:	87aa                	mv	a5,a0
    return -1;
    800052c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800052c6:	0007cc63          	bltz	a5,800052de <sys_read+0x50>
  return fileread(f, p, n);
    800052ca:	fe442603          	lw	a2,-28(s0)
    800052ce:	fd843583          	ld	a1,-40(s0)
    800052d2:	fe843503          	ld	a0,-24(s0)
    800052d6:	fffff097          	auipc	ra,0xfffff
    800052da:	460080e7          	jalr	1120(ra) # 80004736 <fileread>
}
    800052de:	70a2                	ld	ra,40(sp)
    800052e0:	7402                	ld	s0,32(sp)
    800052e2:	6145                	add	sp,sp,48
    800052e4:	8082                	ret

00000000800052e6 <sys_write>:
{
    800052e6:	7179                	add	sp,sp,-48
    800052e8:	f406                	sd	ra,40(sp)
    800052ea:	f022                	sd	s0,32(sp)
    800052ec:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800052ee:	fd840593          	add	a1,s0,-40
    800052f2:	4505                	li	a0,1
    800052f4:	ffffe097          	auipc	ra,0xffffe
    800052f8:	94e080e7          	jalr	-1714(ra) # 80002c42 <argaddr>
  argint(2, &n);
    800052fc:	fe440593          	add	a1,s0,-28
    80005300:	4509                	li	a0,2
    80005302:	ffffe097          	auipc	ra,0xffffe
    80005306:	920080e7          	jalr	-1760(ra) # 80002c22 <argint>
  if(argfd(0, 0, &f) < 0)
    8000530a:	fe840613          	add	a2,s0,-24
    8000530e:	4581                	li	a1,0
    80005310:	4501                	li	a0,0
    80005312:	00000097          	auipc	ra,0x0
    80005316:	d06080e7          	jalr	-762(ra) # 80005018 <argfd>
    8000531a:	87aa                	mv	a5,a0
    return -1;
    8000531c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000531e:	0007cc63          	bltz	a5,80005336 <sys_write+0x50>
  return filewrite(f, p, n);
    80005322:	fe442603          	lw	a2,-28(s0)
    80005326:	fd843583          	ld	a1,-40(s0)
    8000532a:	fe843503          	ld	a0,-24(s0)
    8000532e:	fffff097          	auipc	ra,0xfffff
    80005332:	4ca080e7          	jalr	1226(ra) # 800047f8 <filewrite>
}
    80005336:	70a2                	ld	ra,40(sp)
    80005338:	7402                	ld	s0,32(sp)
    8000533a:	6145                	add	sp,sp,48
    8000533c:	8082                	ret

000000008000533e <sys_close>:
{
    8000533e:	1101                	add	sp,sp,-32
    80005340:	ec06                	sd	ra,24(sp)
    80005342:	e822                	sd	s0,16(sp)
    80005344:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005346:	fe040613          	add	a2,s0,-32
    8000534a:	fec40593          	add	a1,s0,-20
    8000534e:	4501                	li	a0,0
    80005350:	00000097          	auipc	ra,0x0
    80005354:	cc8080e7          	jalr	-824(ra) # 80005018 <argfd>
    return -1;
    80005358:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000535a:	02054463          	bltz	a0,80005382 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000535e:	ffffc097          	auipc	ra,0xffffc
    80005362:	7a6080e7          	jalr	1958(ra) # 80001b04 <myproc>
    80005366:	fec42783          	lw	a5,-20(s0)
    8000536a:	07e9                	add	a5,a5,26
    8000536c:	078e                	sll	a5,a5,0x3
    8000536e:	953e                	add	a0,a0,a5
    80005370:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005374:	fe043503          	ld	a0,-32(s0)
    80005378:	fffff097          	auipc	ra,0xfffff
    8000537c:	284080e7          	jalr	644(ra) # 800045fc <fileclose>
  return 0;
    80005380:	4781                	li	a5,0
}
    80005382:	853e                	mv	a0,a5
    80005384:	60e2                	ld	ra,24(sp)
    80005386:	6442                	ld	s0,16(sp)
    80005388:	6105                	add	sp,sp,32
    8000538a:	8082                	ret

000000008000538c <sys_fstat>:
{
    8000538c:	1101                	add	sp,sp,-32
    8000538e:	ec06                	sd	ra,24(sp)
    80005390:	e822                	sd	s0,16(sp)
    80005392:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80005394:	fe040593          	add	a1,s0,-32
    80005398:	4505                	li	a0,1
    8000539a:	ffffe097          	auipc	ra,0xffffe
    8000539e:	8a8080e7          	jalr	-1880(ra) # 80002c42 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800053a2:	fe840613          	add	a2,s0,-24
    800053a6:	4581                	li	a1,0
    800053a8:	4501                	li	a0,0
    800053aa:	00000097          	auipc	ra,0x0
    800053ae:	c6e080e7          	jalr	-914(ra) # 80005018 <argfd>
    800053b2:	87aa                	mv	a5,a0
    return -1;
    800053b4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053b6:	0007ca63          	bltz	a5,800053ca <sys_fstat+0x3e>
  return filestat(f, st);
    800053ba:	fe043583          	ld	a1,-32(s0)
    800053be:	fe843503          	ld	a0,-24(s0)
    800053c2:	fffff097          	auipc	ra,0xfffff
    800053c6:	302080e7          	jalr	770(ra) # 800046c4 <filestat>
}
    800053ca:	60e2                	ld	ra,24(sp)
    800053cc:	6442                	ld	s0,16(sp)
    800053ce:	6105                	add	sp,sp,32
    800053d0:	8082                	ret

00000000800053d2 <sys_link>:
{
    800053d2:	7169                	add	sp,sp,-304
    800053d4:	f606                	sd	ra,296(sp)
    800053d6:	f222                	sd	s0,288(sp)
    800053d8:	ee26                	sd	s1,280(sp)
    800053da:	ea4a                	sd	s2,272(sp)
    800053dc:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053de:	08000613          	li	a2,128
    800053e2:	ed040593          	add	a1,s0,-304
    800053e6:	4501                	li	a0,0
    800053e8:	ffffe097          	auipc	ra,0xffffe
    800053ec:	87a080e7          	jalr	-1926(ra) # 80002c62 <argstr>
    return -1;
    800053f0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053f2:	10054e63          	bltz	a0,8000550e <sys_link+0x13c>
    800053f6:	08000613          	li	a2,128
    800053fa:	f5040593          	add	a1,s0,-176
    800053fe:	4505                	li	a0,1
    80005400:	ffffe097          	auipc	ra,0xffffe
    80005404:	862080e7          	jalr	-1950(ra) # 80002c62 <argstr>
    return -1;
    80005408:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000540a:	10054263          	bltz	a0,8000550e <sys_link+0x13c>
  begin_op();
    8000540e:	fffff097          	auipc	ra,0xfffff
    80005412:	d2a080e7          	jalr	-726(ra) # 80004138 <begin_op>
  if((ip = namei(old)) == 0){
    80005416:	ed040513          	add	a0,s0,-304
    8000541a:	fffff097          	auipc	ra,0xfffff
    8000541e:	b1e080e7          	jalr	-1250(ra) # 80003f38 <namei>
    80005422:	84aa                	mv	s1,a0
    80005424:	c551                	beqz	a0,800054b0 <sys_link+0xde>
  ilock(ip);
    80005426:	ffffe097          	auipc	ra,0xffffe
    8000542a:	36c080e7          	jalr	876(ra) # 80003792 <ilock>
  if(ip->type == T_DIR){
    8000542e:	04449703          	lh	a4,68(s1)
    80005432:	4785                	li	a5,1
    80005434:	08f70463          	beq	a4,a5,800054bc <sys_link+0xea>
  ip->nlink++;
    80005438:	04a4d783          	lhu	a5,74(s1)
    8000543c:	2785                	addw	a5,a5,1
    8000543e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005442:	8526                	mv	a0,s1
    80005444:	ffffe097          	auipc	ra,0xffffe
    80005448:	282080e7          	jalr	642(ra) # 800036c6 <iupdate>
  iunlock(ip);
    8000544c:	8526                	mv	a0,s1
    8000544e:	ffffe097          	auipc	ra,0xffffe
    80005452:	406080e7          	jalr	1030(ra) # 80003854 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005456:	fd040593          	add	a1,s0,-48
    8000545a:	f5040513          	add	a0,s0,-176
    8000545e:	fffff097          	auipc	ra,0xfffff
    80005462:	af8080e7          	jalr	-1288(ra) # 80003f56 <nameiparent>
    80005466:	892a                	mv	s2,a0
    80005468:	c935                	beqz	a0,800054dc <sys_link+0x10a>
  ilock(dp);
    8000546a:	ffffe097          	auipc	ra,0xffffe
    8000546e:	328080e7          	jalr	808(ra) # 80003792 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005472:	00092703          	lw	a4,0(s2)
    80005476:	409c                	lw	a5,0(s1)
    80005478:	04f71d63          	bne	a4,a5,800054d2 <sys_link+0x100>
    8000547c:	40d0                	lw	a2,4(s1)
    8000547e:	fd040593          	add	a1,s0,-48
    80005482:	854a                	mv	a0,s2
    80005484:	fffff097          	auipc	ra,0xfffff
    80005488:	a02080e7          	jalr	-1534(ra) # 80003e86 <dirlink>
    8000548c:	04054363          	bltz	a0,800054d2 <sys_link+0x100>
  iunlockput(dp);
    80005490:	854a                	mv	a0,s2
    80005492:	ffffe097          	auipc	ra,0xffffe
    80005496:	562080e7          	jalr	1378(ra) # 800039f4 <iunlockput>
  iput(ip);
    8000549a:	8526                	mv	a0,s1
    8000549c:	ffffe097          	auipc	ra,0xffffe
    800054a0:	4b0080e7          	jalr	1200(ra) # 8000394c <iput>
  end_op();
    800054a4:	fffff097          	auipc	ra,0xfffff
    800054a8:	d0e080e7          	jalr	-754(ra) # 800041b2 <end_op>
  return 0;
    800054ac:	4781                	li	a5,0
    800054ae:	a085                	j	8000550e <sys_link+0x13c>
    end_op();
    800054b0:	fffff097          	auipc	ra,0xfffff
    800054b4:	d02080e7          	jalr	-766(ra) # 800041b2 <end_op>
    return -1;
    800054b8:	57fd                	li	a5,-1
    800054ba:	a891                	j	8000550e <sys_link+0x13c>
    iunlockput(ip);
    800054bc:	8526                	mv	a0,s1
    800054be:	ffffe097          	auipc	ra,0xffffe
    800054c2:	536080e7          	jalr	1334(ra) # 800039f4 <iunlockput>
    end_op();
    800054c6:	fffff097          	auipc	ra,0xfffff
    800054ca:	cec080e7          	jalr	-788(ra) # 800041b2 <end_op>
    return -1;
    800054ce:	57fd                	li	a5,-1
    800054d0:	a83d                	j	8000550e <sys_link+0x13c>
    iunlockput(dp);
    800054d2:	854a                	mv	a0,s2
    800054d4:	ffffe097          	auipc	ra,0xffffe
    800054d8:	520080e7          	jalr	1312(ra) # 800039f4 <iunlockput>
  ilock(ip);
    800054dc:	8526                	mv	a0,s1
    800054de:	ffffe097          	auipc	ra,0xffffe
    800054e2:	2b4080e7          	jalr	692(ra) # 80003792 <ilock>
  ip->nlink--;
    800054e6:	04a4d783          	lhu	a5,74(s1)
    800054ea:	37fd                	addw	a5,a5,-1
    800054ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054f0:	8526                	mv	a0,s1
    800054f2:	ffffe097          	auipc	ra,0xffffe
    800054f6:	1d4080e7          	jalr	468(ra) # 800036c6 <iupdate>
  iunlockput(ip);
    800054fa:	8526                	mv	a0,s1
    800054fc:	ffffe097          	auipc	ra,0xffffe
    80005500:	4f8080e7          	jalr	1272(ra) # 800039f4 <iunlockput>
  end_op();
    80005504:	fffff097          	auipc	ra,0xfffff
    80005508:	cae080e7          	jalr	-850(ra) # 800041b2 <end_op>
  return -1;
    8000550c:	57fd                	li	a5,-1
}
    8000550e:	853e                	mv	a0,a5
    80005510:	70b2                	ld	ra,296(sp)
    80005512:	7412                	ld	s0,288(sp)
    80005514:	64f2                	ld	s1,280(sp)
    80005516:	6952                	ld	s2,272(sp)
    80005518:	6155                	add	sp,sp,304
    8000551a:	8082                	ret

000000008000551c <sys_unlink>:
{
    8000551c:	7151                	add	sp,sp,-240
    8000551e:	f586                	sd	ra,232(sp)
    80005520:	f1a2                	sd	s0,224(sp)
    80005522:	eda6                	sd	s1,216(sp)
    80005524:	e9ca                	sd	s2,208(sp)
    80005526:	e5ce                	sd	s3,200(sp)
    80005528:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000552a:	08000613          	li	a2,128
    8000552e:	f3040593          	add	a1,s0,-208
    80005532:	4501                	li	a0,0
    80005534:	ffffd097          	auipc	ra,0xffffd
    80005538:	72e080e7          	jalr	1838(ra) # 80002c62 <argstr>
    8000553c:	18054163          	bltz	a0,800056be <sys_unlink+0x1a2>
  begin_op();
    80005540:	fffff097          	auipc	ra,0xfffff
    80005544:	bf8080e7          	jalr	-1032(ra) # 80004138 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005548:	fb040593          	add	a1,s0,-80
    8000554c:	f3040513          	add	a0,s0,-208
    80005550:	fffff097          	auipc	ra,0xfffff
    80005554:	a06080e7          	jalr	-1530(ra) # 80003f56 <nameiparent>
    80005558:	84aa                	mv	s1,a0
    8000555a:	c979                	beqz	a0,80005630 <sys_unlink+0x114>
  ilock(dp);
    8000555c:	ffffe097          	auipc	ra,0xffffe
    80005560:	236080e7          	jalr	566(ra) # 80003792 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005564:	00003597          	auipc	a1,0x3
    80005568:	1cc58593          	add	a1,a1,460 # 80008730 <syscalls+0x2a0>
    8000556c:	fb040513          	add	a0,s0,-80
    80005570:	ffffe097          	auipc	ra,0xffffe
    80005574:	6ec080e7          	jalr	1772(ra) # 80003c5c <namecmp>
    80005578:	14050a63          	beqz	a0,800056cc <sys_unlink+0x1b0>
    8000557c:	00003597          	auipc	a1,0x3
    80005580:	1bc58593          	add	a1,a1,444 # 80008738 <syscalls+0x2a8>
    80005584:	fb040513          	add	a0,s0,-80
    80005588:	ffffe097          	auipc	ra,0xffffe
    8000558c:	6d4080e7          	jalr	1748(ra) # 80003c5c <namecmp>
    80005590:	12050e63          	beqz	a0,800056cc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005594:	f2c40613          	add	a2,s0,-212
    80005598:	fb040593          	add	a1,s0,-80
    8000559c:	8526                	mv	a0,s1
    8000559e:	ffffe097          	auipc	ra,0xffffe
    800055a2:	6d8080e7          	jalr	1752(ra) # 80003c76 <dirlookup>
    800055a6:	892a                	mv	s2,a0
    800055a8:	12050263          	beqz	a0,800056cc <sys_unlink+0x1b0>
  ilock(ip);
    800055ac:	ffffe097          	auipc	ra,0xffffe
    800055b0:	1e6080e7          	jalr	486(ra) # 80003792 <ilock>
  if(ip->nlink < 1)
    800055b4:	04a91783          	lh	a5,74(s2)
    800055b8:	08f05263          	blez	a5,8000563c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055bc:	04491703          	lh	a4,68(s2)
    800055c0:	4785                	li	a5,1
    800055c2:	08f70563          	beq	a4,a5,8000564c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055c6:	4641                	li	a2,16
    800055c8:	4581                	li	a1,0
    800055ca:	fc040513          	add	a0,s0,-64
    800055ce:	ffffb097          	auipc	ra,0xffffb
    800055d2:	7fa080e7          	jalr	2042(ra) # 80000dc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055d6:	4741                	li	a4,16
    800055d8:	f2c42683          	lw	a3,-212(s0)
    800055dc:	fc040613          	add	a2,s0,-64
    800055e0:	4581                	li	a1,0
    800055e2:	8526                	mv	a0,s1
    800055e4:	ffffe097          	auipc	ra,0xffffe
    800055e8:	55a080e7          	jalr	1370(ra) # 80003b3e <writei>
    800055ec:	47c1                	li	a5,16
    800055ee:	0af51563          	bne	a0,a5,80005698 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800055f2:	04491703          	lh	a4,68(s2)
    800055f6:	4785                	li	a5,1
    800055f8:	0af70863          	beq	a4,a5,800056a8 <sys_unlink+0x18c>
  iunlockput(dp);
    800055fc:	8526                	mv	a0,s1
    800055fe:	ffffe097          	auipc	ra,0xffffe
    80005602:	3f6080e7          	jalr	1014(ra) # 800039f4 <iunlockput>
  ip->nlink--;
    80005606:	04a95783          	lhu	a5,74(s2)
    8000560a:	37fd                	addw	a5,a5,-1
    8000560c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005610:	854a                	mv	a0,s2
    80005612:	ffffe097          	auipc	ra,0xffffe
    80005616:	0b4080e7          	jalr	180(ra) # 800036c6 <iupdate>
  iunlockput(ip);
    8000561a:	854a                	mv	a0,s2
    8000561c:	ffffe097          	auipc	ra,0xffffe
    80005620:	3d8080e7          	jalr	984(ra) # 800039f4 <iunlockput>
  end_op();
    80005624:	fffff097          	auipc	ra,0xfffff
    80005628:	b8e080e7          	jalr	-1138(ra) # 800041b2 <end_op>
  return 0;
    8000562c:	4501                	li	a0,0
    8000562e:	a84d                	j	800056e0 <sys_unlink+0x1c4>
    end_op();
    80005630:	fffff097          	auipc	ra,0xfffff
    80005634:	b82080e7          	jalr	-1150(ra) # 800041b2 <end_op>
    return -1;
    80005638:	557d                	li	a0,-1
    8000563a:	a05d                	j	800056e0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000563c:	00003517          	auipc	a0,0x3
    80005640:	10450513          	add	a0,a0,260 # 80008740 <syscalls+0x2b0>
    80005644:	ffffb097          	auipc	ra,0xffffb
    80005648:	1ca080e7          	jalr	458(ra) # 8000080e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000564c:	04c92703          	lw	a4,76(s2)
    80005650:	02000793          	li	a5,32
    80005654:	f6e7f9e3          	bgeu	a5,a4,800055c6 <sys_unlink+0xaa>
    80005658:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000565c:	4741                	li	a4,16
    8000565e:	86ce                	mv	a3,s3
    80005660:	f1840613          	add	a2,s0,-232
    80005664:	4581                	li	a1,0
    80005666:	854a                	mv	a0,s2
    80005668:	ffffe097          	auipc	ra,0xffffe
    8000566c:	3de080e7          	jalr	990(ra) # 80003a46 <readi>
    80005670:	47c1                	li	a5,16
    80005672:	00f51b63          	bne	a0,a5,80005688 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005676:	f1845783          	lhu	a5,-232(s0)
    8000567a:	e7a1                	bnez	a5,800056c2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000567c:	29c1                	addw	s3,s3,16
    8000567e:	04c92783          	lw	a5,76(s2)
    80005682:	fcf9ede3          	bltu	s3,a5,8000565c <sys_unlink+0x140>
    80005686:	b781                	j	800055c6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005688:	00003517          	auipc	a0,0x3
    8000568c:	0d050513          	add	a0,a0,208 # 80008758 <syscalls+0x2c8>
    80005690:	ffffb097          	auipc	ra,0xffffb
    80005694:	17e080e7          	jalr	382(ra) # 8000080e <panic>
    panic("unlink: writei");
    80005698:	00003517          	auipc	a0,0x3
    8000569c:	0d850513          	add	a0,a0,216 # 80008770 <syscalls+0x2e0>
    800056a0:	ffffb097          	auipc	ra,0xffffb
    800056a4:	16e080e7          	jalr	366(ra) # 8000080e <panic>
    dp->nlink--;
    800056a8:	04a4d783          	lhu	a5,74(s1)
    800056ac:	37fd                	addw	a5,a5,-1
    800056ae:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800056b2:	8526                	mv	a0,s1
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	012080e7          	jalr	18(ra) # 800036c6 <iupdate>
    800056bc:	b781                	j	800055fc <sys_unlink+0xe0>
    return -1;
    800056be:	557d                	li	a0,-1
    800056c0:	a005                	j	800056e0 <sys_unlink+0x1c4>
    iunlockput(ip);
    800056c2:	854a                	mv	a0,s2
    800056c4:	ffffe097          	auipc	ra,0xffffe
    800056c8:	330080e7          	jalr	816(ra) # 800039f4 <iunlockput>
  iunlockput(dp);
    800056cc:	8526                	mv	a0,s1
    800056ce:	ffffe097          	auipc	ra,0xffffe
    800056d2:	326080e7          	jalr	806(ra) # 800039f4 <iunlockput>
  end_op();
    800056d6:	fffff097          	auipc	ra,0xfffff
    800056da:	adc080e7          	jalr	-1316(ra) # 800041b2 <end_op>
  return -1;
    800056de:	557d                	li	a0,-1
}
    800056e0:	70ae                	ld	ra,232(sp)
    800056e2:	740e                	ld	s0,224(sp)
    800056e4:	64ee                	ld	s1,216(sp)
    800056e6:	694e                	ld	s2,208(sp)
    800056e8:	69ae                	ld	s3,200(sp)
    800056ea:	616d                	add	sp,sp,240
    800056ec:	8082                	ret

00000000800056ee <sys_open>:

uint64
sys_open(void)
{
    800056ee:	7131                	add	sp,sp,-192
    800056f0:	fd06                	sd	ra,184(sp)
    800056f2:	f922                	sd	s0,176(sp)
    800056f4:	f526                	sd	s1,168(sp)
    800056f6:	f14a                	sd	s2,160(sp)
    800056f8:	ed4e                	sd	s3,152(sp)
    800056fa:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800056fc:	f4c40593          	add	a1,s0,-180
    80005700:	4505                	li	a0,1
    80005702:	ffffd097          	auipc	ra,0xffffd
    80005706:	520080e7          	jalr	1312(ra) # 80002c22 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000570a:	08000613          	li	a2,128
    8000570e:	f5040593          	add	a1,s0,-176
    80005712:	4501                	li	a0,0
    80005714:	ffffd097          	auipc	ra,0xffffd
    80005718:	54e080e7          	jalr	1358(ra) # 80002c62 <argstr>
    8000571c:	87aa                	mv	a5,a0
    return -1;
    8000571e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005720:	0a07c863          	bltz	a5,800057d0 <sys_open+0xe2>

  begin_op();
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	a14080e7          	jalr	-1516(ra) # 80004138 <begin_op>

  if(omode & O_CREATE){
    8000572c:	f4c42783          	lw	a5,-180(s0)
    80005730:	2007f793          	and	a5,a5,512
    80005734:	cbdd                	beqz	a5,800057ea <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80005736:	4681                	li	a3,0
    80005738:	4601                	li	a2,0
    8000573a:	4589                	li	a1,2
    8000573c:	f5040513          	add	a0,s0,-176
    80005740:	00000097          	auipc	ra,0x0
    80005744:	97a080e7          	jalr	-1670(ra) # 800050ba <create>
    80005748:	84aa                	mv	s1,a0
    if(ip == 0){
    8000574a:	c951                	beqz	a0,800057de <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000574c:	04449703          	lh	a4,68(s1)
    80005750:	478d                	li	a5,3
    80005752:	00f71763          	bne	a4,a5,80005760 <sys_open+0x72>
    80005756:	0464d703          	lhu	a4,70(s1)
    8000575a:	47a5                	li	a5,9
    8000575c:	0ce7ec63          	bltu	a5,a4,80005834 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005760:	fffff097          	auipc	ra,0xfffff
    80005764:	de0080e7          	jalr	-544(ra) # 80004540 <filealloc>
    80005768:	892a                	mv	s2,a0
    8000576a:	c56d                	beqz	a0,80005854 <sys_open+0x166>
    8000576c:	00000097          	auipc	ra,0x0
    80005770:	90c080e7          	jalr	-1780(ra) # 80005078 <fdalloc>
    80005774:	89aa                	mv	s3,a0
    80005776:	0c054a63          	bltz	a0,8000584a <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000577a:	04449703          	lh	a4,68(s1)
    8000577e:	478d                	li	a5,3
    80005780:	0ef70563          	beq	a4,a5,8000586a <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005784:	4789                	li	a5,2
    80005786:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000578a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000578e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005792:	f4c42783          	lw	a5,-180(s0)
    80005796:	0017c713          	xor	a4,a5,1
    8000579a:	8b05                	and	a4,a4,1
    8000579c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800057a0:	0037f713          	and	a4,a5,3
    800057a4:	00e03733          	snez	a4,a4
    800057a8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057ac:	4007f793          	and	a5,a5,1024
    800057b0:	c791                	beqz	a5,800057bc <sys_open+0xce>
    800057b2:	04449703          	lh	a4,68(s1)
    800057b6:	4789                	li	a5,2
    800057b8:	0cf70063          	beq	a4,a5,80005878 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    800057bc:	8526                	mv	a0,s1
    800057be:	ffffe097          	auipc	ra,0xffffe
    800057c2:	096080e7          	jalr	150(ra) # 80003854 <iunlock>
  end_op();
    800057c6:	fffff097          	auipc	ra,0xfffff
    800057ca:	9ec080e7          	jalr	-1556(ra) # 800041b2 <end_op>

  return fd;
    800057ce:	854e                	mv	a0,s3
}
    800057d0:	70ea                	ld	ra,184(sp)
    800057d2:	744a                	ld	s0,176(sp)
    800057d4:	74aa                	ld	s1,168(sp)
    800057d6:	790a                	ld	s2,160(sp)
    800057d8:	69ea                	ld	s3,152(sp)
    800057da:	6129                	add	sp,sp,192
    800057dc:	8082                	ret
      end_op();
    800057de:	fffff097          	auipc	ra,0xfffff
    800057e2:	9d4080e7          	jalr	-1580(ra) # 800041b2 <end_op>
      return -1;
    800057e6:	557d                	li	a0,-1
    800057e8:	b7e5                	j	800057d0 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    800057ea:	f5040513          	add	a0,s0,-176
    800057ee:	ffffe097          	auipc	ra,0xffffe
    800057f2:	74a080e7          	jalr	1866(ra) # 80003f38 <namei>
    800057f6:	84aa                	mv	s1,a0
    800057f8:	c905                	beqz	a0,80005828 <sys_open+0x13a>
    ilock(ip);
    800057fa:	ffffe097          	auipc	ra,0xffffe
    800057fe:	f98080e7          	jalr	-104(ra) # 80003792 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005802:	04449703          	lh	a4,68(s1)
    80005806:	4785                	li	a5,1
    80005808:	f4f712e3          	bne	a4,a5,8000574c <sys_open+0x5e>
    8000580c:	f4c42783          	lw	a5,-180(s0)
    80005810:	dba1                	beqz	a5,80005760 <sys_open+0x72>
      iunlockput(ip);
    80005812:	8526                	mv	a0,s1
    80005814:	ffffe097          	auipc	ra,0xffffe
    80005818:	1e0080e7          	jalr	480(ra) # 800039f4 <iunlockput>
      end_op();
    8000581c:	fffff097          	auipc	ra,0xfffff
    80005820:	996080e7          	jalr	-1642(ra) # 800041b2 <end_op>
      return -1;
    80005824:	557d                	li	a0,-1
    80005826:	b76d                	j	800057d0 <sys_open+0xe2>
      end_op();
    80005828:	fffff097          	auipc	ra,0xfffff
    8000582c:	98a080e7          	jalr	-1654(ra) # 800041b2 <end_op>
      return -1;
    80005830:	557d                	li	a0,-1
    80005832:	bf79                	j	800057d0 <sys_open+0xe2>
    iunlockput(ip);
    80005834:	8526                	mv	a0,s1
    80005836:	ffffe097          	auipc	ra,0xffffe
    8000583a:	1be080e7          	jalr	446(ra) # 800039f4 <iunlockput>
    end_op();
    8000583e:	fffff097          	auipc	ra,0xfffff
    80005842:	974080e7          	jalr	-1676(ra) # 800041b2 <end_op>
    return -1;
    80005846:	557d                	li	a0,-1
    80005848:	b761                	j	800057d0 <sys_open+0xe2>
      fileclose(f);
    8000584a:	854a                	mv	a0,s2
    8000584c:	fffff097          	auipc	ra,0xfffff
    80005850:	db0080e7          	jalr	-592(ra) # 800045fc <fileclose>
    iunlockput(ip);
    80005854:	8526                	mv	a0,s1
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	19e080e7          	jalr	414(ra) # 800039f4 <iunlockput>
    end_op();
    8000585e:	fffff097          	auipc	ra,0xfffff
    80005862:	954080e7          	jalr	-1708(ra) # 800041b2 <end_op>
    return -1;
    80005866:	557d                	li	a0,-1
    80005868:	b7a5                	j	800057d0 <sys_open+0xe2>
    f->type = FD_DEVICE;
    8000586a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000586e:	04649783          	lh	a5,70(s1)
    80005872:	02f91223          	sh	a5,36(s2)
    80005876:	bf21                	j	8000578e <sys_open+0xa0>
    itrunc(ip);
    80005878:	8526                	mv	a0,s1
    8000587a:	ffffe097          	auipc	ra,0xffffe
    8000587e:	026080e7          	jalr	38(ra) # 800038a0 <itrunc>
    80005882:	bf2d                	j	800057bc <sys_open+0xce>

0000000080005884 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005884:	7175                	add	sp,sp,-144
    80005886:	e506                	sd	ra,136(sp)
    80005888:	e122                	sd	s0,128(sp)
    8000588a:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000588c:	fffff097          	auipc	ra,0xfffff
    80005890:	8ac080e7          	jalr	-1876(ra) # 80004138 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005894:	08000613          	li	a2,128
    80005898:	f7040593          	add	a1,s0,-144
    8000589c:	4501                	li	a0,0
    8000589e:	ffffd097          	auipc	ra,0xffffd
    800058a2:	3c4080e7          	jalr	964(ra) # 80002c62 <argstr>
    800058a6:	02054963          	bltz	a0,800058d8 <sys_mkdir+0x54>
    800058aa:	4681                	li	a3,0
    800058ac:	4601                	li	a2,0
    800058ae:	4585                	li	a1,1
    800058b0:	f7040513          	add	a0,s0,-144
    800058b4:	00000097          	auipc	ra,0x0
    800058b8:	806080e7          	jalr	-2042(ra) # 800050ba <create>
    800058bc:	cd11                	beqz	a0,800058d8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058be:	ffffe097          	auipc	ra,0xffffe
    800058c2:	136080e7          	jalr	310(ra) # 800039f4 <iunlockput>
  end_op();
    800058c6:	fffff097          	auipc	ra,0xfffff
    800058ca:	8ec080e7          	jalr	-1812(ra) # 800041b2 <end_op>
  return 0;
    800058ce:	4501                	li	a0,0
}
    800058d0:	60aa                	ld	ra,136(sp)
    800058d2:	640a                	ld	s0,128(sp)
    800058d4:	6149                	add	sp,sp,144
    800058d6:	8082                	ret
    end_op();
    800058d8:	fffff097          	auipc	ra,0xfffff
    800058dc:	8da080e7          	jalr	-1830(ra) # 800041b2 <end_op>
    return -1;
    800058e0:	557d                	li	a0,-1
    800058e2:	b7fd                	j	800058d0 <sys_mkdir+0x4c>

00000000800058e4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800058e4:	7135                	add	sp,sp,-160
    800058e6:	ed06                	sd	ra,152(sp)
    800058e8:	e922                	sd	s0,144(sp)
    800058ea:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800058ec:	fffff097          	auipc	ra,0xfffff
    800058f0:	84c080e7          	jalr	-1972(ra) # 80004138 <begin_op>
  argint(1, &major);
    800058f4:	f6c40593          	add	a1,s0,-148
    800058f8:	4505                	li	a0,1
    800058fa:	ffffd097          	auipc	ra,0xffffd
    800058fe:	328080e7          	jalr	808(ra) # 80002c22 <argint>
  argint(2, &minor);
    80005902:	f6840593          	add	a1,s0,-152
    80005906:	4509                	li	a0,2
    80005908:	ffffd097          	auipc	ra,0xffffd
    8000590c:	31a080e7          	jalr	794(ra) # 80002c22 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005910:	08000613          	li	a2,128
    80005914:	f7040593          	add	a1,s0,-144
    80005918:	4501                	li	a0,0
    8000591a:	ffffd097          	auipc	ra,0xffffd
    8000591e:	348080e7          	jalr	840(ra) # 80002c62 <argstr>
    80005922:	02054b63          	bltz	a0,80005958 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005926:	f6841683          	lh	a3,-152(s0)
    8000592a:	f6c41603          	lh	a2,-148(s0)
    8000592e:	458d                	li	a1,3
    80005930:	f7040513          	add	a0,s0,-144
    80005934:	fffff097          	auipc	ra,0xfffff
    80005938:	786080e7          	jalr	1926(ra) # 800050ba <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000593c:	cd11                	beqz	a0,80005958 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000593e:	ffffe097          	auipc	ra,0xffffe
    80005942:	0b6080e7          	jalr	182(ra) # 800039f4 <iunlockput>
  end_op();
    80005946:	fffff097          	auipc	ra,0xfffff
    8000594a:	86c080e7          	jalr	-1940(ra) # 800041b2 <end_op>
  return 0;
    8000594e:	4501                	li	a0,0
}
    80005950:	60ea                	ld	ra,152(sp)
    80005952:	644a                	ld	s0,144(sp)
    80005954:	610d                	add	sp,sp,160
    80005956:	8082                	ret
    end_op();
    80005958:	fffff097          	auipc	ra,0xfffff
    8000595c:	85a080e7          	jalr	-1958(ra) # 800041b2 <end_op>
    return -1;
    80005960:	557d                	li	a0,-1
    80005962:	b7fd                	j	80005950 <sys_mknod+0x6c>

0000000080005964 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005964:	7135                	add	sp,sp,-160
    80005966:	ed06                	sd	ra,152(sp)
    80005968:	e922                	sd	s0,144(sp)
    8000596a:	e526                	sd	s1,136(sp)
    8000596c:	e14a                	sd	s2,128(sp)
    8000596e:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005970:	ffffc097          	auipc	ra,0xffffc
    80005974:	194080e7          	jalr	404(ra) # 80001b04 <myproc>
    80005978:	892a                	mv	s2,a0
  
  begin_op();
    8000597a:	ffffe097          	auipc	ra,0xffffe
    8000597e:	7be080e7          	jalr	1982(ra) # 80004138 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005982:	08000613          	li	a2,128
    80005986:	f6040593          	add	a1,s0,-160
    8000598a:	4501                	li	a0,0
    8000598c:	ffffd097          	auipc	ra,0xffffd
    80005990:	2d6080e7          	jalr	726(ra) # 80002c62 <argstr>
    80005994:	04054b63          	bltz	a0,800059ea <sys_chdir+0x86>
    80005998:	f6040513          	add	a0,s0,-160
    8000599c:	ffffe097          	auipc	ra,0xffffe
    800059a0:	59c080e7          	jalr	1436(ra) # 80003f38 <namei>
    800059a4:	84aa                	mv	s1,a0
    800059a6:	c131                	beqz	a0,800059ea <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059a8:	ffffe097          	auipc	ra,0xffffe
    800059ac:	dea080e7          	jalr	-534(ra) # 80003792 <ilock>
  if(ip->type != T_DIR){
    800059b0:	04449703          	lh	a4,68(s1)
    800059b4:	4785                	li	a5,1
    800059b6:	04f71063          	bne	a4,a5,800059f6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059ba:	8526                	mv	a0,s1
    800059bc:	ffffe097          	auipc	ra,0xffffe
    800059c0:	e98080e7          	jalr	-360(ra) # 80003854 <iunlock>
  iput(p->cwd);
    800059c4:	15893503          	ld	a0,344(s2)
    800059c8:	ffffe097          	auipc	ra,0xffffe
    800059cc:	f84080e7          	jalr	-124(ra) # 8000394c <iput>
  end_op();
    800059d0:	ffffe097          	auipc	ra,0xffffe
    800059d4:	7e2080e7          	jalr	2018(ra) # 800041b2 <end_op>
  p->cwd = ip;
    800059d8:	14993c23          	sd	s1,344(s2)
  return 0;
    800059dc:	4501                	li	a0,0
}
    800059de:	60ea                	ld	ra,152(sp)
    800059e0:	644a                	ld	s0,144(sp)
    800059e2:	64aa                	ld	s1,136(sp)
    800059e4:	690a                	ld	s2,128(sp)
    800059e6:	610d                	add	sp,sp,160
    800059e8:	8082                	ret
    end_op();
    800059ea:	ffffe097          	auipc	ra,0xffffe
    800059ee:	7c8080e7          	jalr	1992(ra) # 800041b2 <end_op>
    return -1;
    800059f2:	557d                	li	a0,-1
    800059f4:	b7ed                	j	800059de <sys_chdir+0x7a>
    iunlockput(ip);
    800059f6:	8526                	mv	a0,s1
    800059f8:	ffffe097          	auipc	ra,0xffffe
    800059fc:	ffc080e7          	jalr	-4(ra) # 800039f4 <iunlockput>
    end_op();
    80005a00:	ffffe097          	auipc	ra,0xffffe
    80005a04:	7b2080e7          	jalr	1970(ra) # 800041b2 <end_op>
    return -1;
    80005a08:	557d                	li	a0,-1
    80005a0a:	bfd1                	j	800059de <sys_chdir+0x7a>

0000000080005a0c <sys_exec>:

uint64
sys_exec(void)
{
    80005a0c:	7121                	add	sp,sp,-448
    80005a0e:	ff06                	sd	ra,440(sp)
    80005a10:	fb22                	sd	s0,432(sp)
    80005a12:	f726                	sd	s1,424(sp)
    80005a14:	f34a                	sd	s2,416(sp)
    80005a16:	ef4e                	sd	s3,408(sp)
    80005a18:	eb52                	sd	s4,400(sp)
    80005a1a:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005a1c:	e4840593          	add	a1,s0,-440
    80005a20:	4505                	li	a0,1
    80005a22:	ffffd097          	auipc	ra,0xffffd
    80005a26:	220080e7          	jalr	544(ra) # 80002c42 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005a2a:	08000613          	li	a2,128
    80005a2e:	f5040593          	add	a1,s0,-176
    80005a32:	4501                	li	a0,0
    80005a34:	ffffd097          	auipc	ra,0xffffd
    80005a38:	22e080e7          	jalr	558(ra) # 80002c62 <argstr>
    80005a3c:	87aa                	mv	a5,a0
    return -1;
    80005a3e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005a40:	0c07c263          	bltz	a5,80005b04 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005a44:	10000613          	li	a2,256
    80005a48:	4581                	li	a1,0
    80005a4a:	e5040513          	add	a0,s0,-432
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	37a080e7          	jalr	890(ra) # 80000dc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a56:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005a5a:	89a6                	mv	s3,s1
    80005a5c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a5e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a62:	00391513          	sll	a0,s2,0x3
    80005a66:	e4040593          	add	a1,s0,-448
    80005a6a:	e4843783          	ld	a5,-440(s0)
    80005a6e:	953e                	add	a0,a0,a5
    80005a70:	ffffd097          	auipc	ra,0xffffd
    80005a74:	114080e7          	jalr	276(ra) # 80002b84 <fetchaddr>
    80005a78:	02054a63          	bltz	a0,80005aac <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005a7c:	e4043783          	ld	a5,-448(s0)
    80005a80:	c3b9                	beqz	a5,80005ac6 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a82:	ffffb097          	auipc	ra,0xffffb
    80005a86:	15a080e7          	jalr	346(ra) # 80000bdc <kalloc>
    80005a8a:	85aa                	mv	a1,a0
    80005a8c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a90:	cd11                	beqz	a0,80005aac <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a92:	6605                	lui	a2,0x1
    80005a94:	e4043503          	ld	a0,-448(s0)
    80005a98:	ffffd097          	auipc	ra,0xffffd
    80005a9c:	13e080e7          	jalr	318(ra) # 80002bd6 <fetchstr>
    80005aa0:	00054663          	bltz	a0,80005aac <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005aa4:	0905                	add	s2,s2,1
    80005aa6:	09a1                	add	s3,s3,8
    80005aa8:	fb491de3          	bne	s2,s4,80005a62 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aac:	f5040913          	add	s2,s0,-176
    80005ab0:	6088                	ld	a0,0(s1)
    80005ab2:	c921                	beqz	a0,80005b02 <sys_exec+0xf6>
    kfree(argv[i]);
    80005ab4:	ffffb097          	auipc	ra,0xffffb
    80005ab8:	02a080e7          	jalr	42(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005abc:	04a1                	add	s1,s1,8
    80005abe:	ff2499e3          	bne	s1,s2,80005ab0 <sys_exec+0xa4>
  return -1;
    80005ac2:	557d                	li	a0,-1
    80005ac4:	a081                	j	80005b04 <sys_exec+0xf8>
      argv[i] = 0;
    80005ac6:	0009079b          	sext.w	a5,s2
    80005aca:	078e                	sll	a5,a5,0x3
    80005acc:	fd078793          	add	a5,a5,-48
    80005ad0:	97a2                	add	a5,a5,s0
    80005ad2:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005ad6:	e5040593          	add	a1,s0,-432
    80005ada:	f5040513          	add	a0,s0,-176
    80005ade:	fffff097          	auipc	ra,0xfffff
    80005ae2:	194080e7          	jalr	404(ra) # 80004c72 <exec>
    80005ae6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ae8:	f5040993          	add	s3,s0,-176
    80005aec:	6088                	ld	a0,0(s1)
    80005aee:	c901                	beqz	a0,80005afe <sys_exec+0xf2>
    kfree(argv[i]);
    80005af0:	ffffb097          	auipc	ra,0xffffb
    80005af4:	fee080e7          	jalr	-18(ra) # 80000ade <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005af8:	04a1                	add	s1,s1,8
    80005afa:	ff3499e3          	bne	s1,s3,80005aec <sys_exec+0xe0>
  return ret;
    80005afe:	854a                	mv	a0,s2
    80005b00:	a011                	j	80005b04 <sys_exec+0xf8>
  return -1;
    80005b02:	557d                	li	a0,-1
}
    80005b04:	70fa                	ld	ra,440(sp)
    80005b06:	745a                	ld	s0,432(sp)
    80005b08:	74ba                	ld	s1,424(sp)
    80005b0a:	791a                	ld	s2,416(sp)
    80005b0c:	69fa                	ld	s3,408(sp)
    80005b0e:	6a5a                	ld	s4,400(sp)
    80005b10:	6139                	add	sp,sp,448
    80005b12:	8082                	ret

0000000080005b14 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b14:	7139                	add	sp,sp,-64
    80005b16:	fc06                	sd	ra,56(sp)
    80005b18:	f822                	sd	s0,48(sp)
    80005b1a:	f426                	sd	s1,40(sp)
    80005b1c:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b1e:	ffffc097          	auipc	ra,0xffffc
    80005b22:	fe6080e7          	jalr	-26(ra) # 80001b04 <myproc>
    80005b26:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005b28:	fd840593          	add	a1,s0,-40
    80005b2c:	4501                	li	a0,0
    80005b2e:	ffffd097          	auipc	ra,0xffffd
    80005b32:	114080e7          	jalr	276(ra) # 80002c42 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005b36:	fc840593          	add	a1,s0,-56
    80005b3a:	fd040513          	add	a0,s0,-48
    80005b3e:	fffff097          	auipc	ra,0xfffff
    80005b42:	dea080e7          	jalr	-534(ra) # 80004928 <pipealloc>
    return -1;
    80005b46:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b48:	0c054463          	bltz	a0,80005c10 <sys_pipe+0xfc>
  fd0 = -1;
    80005b4c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b50:	fd043503          	ld	a0,-48(s0)
    80005b54:	fffff097          	auipc	ra,0xfffff
    80005b58:	524080e7          	jalr	1316(ra) # 80005078 <fdalloc>
    80005b5c:	fca42223          	sw	a0,-60(s0)
    80005b60:	08054b63          	bltz	a0,80005bf6 <sys_pipe+0xe2>
    80005b64:	fc843503          	ld	a0,-56(s0)
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	510080e7          	jalr	1296(ra) # 80005078 <fdalloc>
    80005b70:	fca42023          	sw	a0,-64(s0)
    80005b74:	06054863          	bltz	a0,80005be4 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b78:	4691                	li	a3,4
    80005b7a:	fc440613          	add	a2,s0,-60
    80005b7e:	fd843583          	ld	a1,-40(s0)
    80005b82:	6ca8                	ld	a0,88(s1)
    80005b84:	ffffc097          	auipc	ra,0xffffc
    80005b88:	c00080e7          	jalr	-1024(ra) # 80001784 <copyout>
    80005b8c:	02054063          	bltz	a0,80005bac <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b90:	4691                	li	a3,4
    80005b92:	fc040613          	add	a2,s0,-64
    80005b96:	fd843583          	ld	a1,-40(s0)
    80005b9a:	0591                	add	a1,a1,4
    80005b9c:	6ca8                	ld	a0,88(s1)
    80005b9e:	ffffc097          	auipc	ra,0xffffc
    80005ba2:	be6080e7          	jalr	-1050(ra) # 80001784 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ba6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ba8:	06055463          	bgez	a0,80005c10 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005bac:	fc442783          	lw	a5,-60(s0)
    80005bb0:	07e9                	add	a5,a5,26
    80005bb2:	078e                	sll	a5,a5,0x3
    80005bb4:	97a6                	add	a5,a5,s1
    80005bb6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005bba:	fc042783          	lw	a5,-64(s0)
    80005bbe:	07e9                	add	a5,a5,26
    80005bc0:	078e                	sll	a5,a5,0x3
    80005bc2:	94be                	add	s1,s1,a5
    80005bc4:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005bc8:	fd043503          	ld	a0,-48(s0)
    80005bcc:	fffff097          	auipc	ra,0xfffff
    80005bd0:	a30080e7          	jalr	-1488(ra) # 800045fc <fileclose>
    fileclose(wf);
    80005bd4:	fc843503          	ld	a0,-56(s0)
    80005bd8:	fffff097          	auipc	ra,0xfffff
    80005bdc:	a24080e7          	jalr	-1500(ra) # 800045fc <fileclose>
    return -1;
    80005be0:	57fd                	li	a5,-1
    80005be2:	a03d                	j	80005c10 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005be4:	fc442783          	lw	a5,-60(s0)
    80005be8:	0007c763          	bltz	a5,80005bf6 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005bec:	07e9                	add	a5,a5,26
    80005bee:	078e                	sll	a5,a5,0x3
    80005bf0:	97a6                	add	a5,a5,s1
    80005bf2:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005bf6:	fd043503          	ld	a0,-48(s0)
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	a02080e7          	jalr	-1534(ra) # 800045fc <fileclose>
    fileclose(wf);
    80005c02:	fc843503          	ld	a0,-56(s0)
    80005c06:	fffff097          	auipc	ra,0xfffff
    80005c0a:	9f6080e7          	jalr	-1546(ra) # 800045fc <fileclose>
    return -1;
    80005c0e:	57fd                	li	a5,-1
}
    80005c10:	853e                	mv	a0,a5
    80005c12:	70e2                	ld	ra,56(sp)
    80005c14:	7442                	ld	s0,48(sp)
    80005c16:	74a2                	ld	s1,40(sp)
    80005c18:	6121                	add	sp,sp,64
    80005c1a:	8082                	ret
    80005c1c:	0000                	unimp
	...

0000000080005c20 <kernelvec>:
    80005c20:	7111                	add	sp,sp,-256
    80005c22:	e006                	sd	ra,0(sp)
    80005c24:	e40a                	sd	sp,8(sp)
    80005c26:	e80e                	sd	gp,16(sp)
    80005c28:	ec12                	sd	tp,24(sp)
    80005c2a:	f016                	sd	t0,32(sp)
    80005c2c:	f41a                	sd	t1,40(sp)
    80005c2e:	f81e                	sd	t2,48(sp)
    80005c30:	e4aa                	sd	a0,72(sp)
    80005c32:	e8ae                	sd	a1,80(sp)
    80005c34:	ecb2                	sd	a2,88(sp)
    80005c36:	f0b6                	sd	a3,96(sp)
    80005c38:	f4ba                	sd	a4,104(sp)
    80005c3a:	f8be                	sd	a5,112(sp)
    80005c3c:	fcc2                	sd	a6,120(sp)
    80005c3e:	e146                	sd	a7,128(sp)
    80005c40:	edf2                	sd	t3,216(sp)
    80005c42:	f1f6                	sd	t4,224(sp)
    80005c44:	f5fa                	sd	t5,232(sp)
    80005c46:	f9fe                	sd	t6,240(sp)
    80005c48:	e29fc0ef          	jal	80002a70 <kerneltrap>
    80005c4c:	6082                	ld	ra,0(sp)
    80005c4e:	6122                	ld	sp,8(sp)
    80005c50:	61c2                	ld	gp,16(sp)
    80005c52:	7282                	ld	t0,32(sp)
    80005c54:	7322                	ld	t1,40(sp)
    80005c56:	73c2                	ld	t2,48(sp)
    80005c58:	6526                	ld	a0,72(sp)
    80005c5a:	65c6                	ld	a1,80(sp)
    80005c5c:	6666                	ld	a2,88(sp)
    80005c5e:	7686                	ld	a3,96(sp)
    80005c60:	7726                	ld	a4,104(sp)
    80005c62:	77c6                	ld	a5,112(sp)
    80005c64:	7866                	ld	a6,120(sp)
    80005c66:	688a                	ld	a7,128(sp)
    80005c68:	6e6e                	ld	t3,216(sp)
    80005c6a:	7e8e                	ld	t4,224(sp)
    80005c6c:	7f2e                	ld	t5,232(sp)
    80005c6e:	7fce                	ld	t6,240(sp)
    80005c70:	6111                	add	sp,sp,256
    80005c72:	10200073          	sret
	...

0000000080005c7e <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    80005c7e:	1141                	add	sp,sp,-16
    80005c80:	e422                	sd	s0,8(sp)
    80005c82:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c84:	0c0007b7          	lui	a5,0xc000
    80005c88:	4705                	li	a4,1
    80005c8a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c8c:	c3d8                	sw	a4,4(a5)
}
    80005c8e:	6422                	ld	s0,8(sp)
    80005c90:	0141                	add	sp,sp,16
    80005c92:	8082                	ret

0000000080005c94 <plicinithart>:

void
plicinithart(void)
{
    80005c94:	1141                	add	sp,sp,-16
    80005c96:	e406                	sd	ra,8(sp)
    80005c98:	e022                	sd	s0,0(sp)
    80005c9a:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005c9c:	ffffc097          	auipc	ra,0xffffc
    80005ca0:	e3c080e7          	jalr	-452(ra) # 80001ad8 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005ca4:	0085171b          	sllw	a4,a0,0x8
    80005ca8:	0c0027b7          	lui	a5,0xc002
    80005cac:	97ba                	add	a5,a5,a4
    80005cae:	40200713          	li	a4,1026
    80005cb2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005cb6:	00d5151b          	sllw	a0,a0,0xd
    80005cba:	0c2017b7          	lui	a5,0xc201
    80005cbe:	97aa                	add	a5,a5,a0
    80005cc0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005cc4:	60a2                	ld	ra,8(sp)
    80005cc6:	6402                	ld	s0,0(sp)
    80005cc8:	0141                	add	sp,sp,16
    80005cca:	8082                	ret

0000000080005ccc <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005ccc:	1141                	add	sp,sp,-16
    80005cce:	e406                	sd	ra,8(sp)
    80005cd0:	e022                	sd	s0,0(sp)
    80005cd2:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005cd4:	ffffc097          	auipc	ra,0xffffc
    80005cd8:	e04080e7          	jalr	-508(ra) # 80001ad8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005cdc:	00d5151b          	sllw	a0,a0,0xd
    80005ce0:	0c2017b7          	lui	a5,0xc201
    80005ce4:	97aa                	add	a5,a5,a0
  return irq;
}
    80005ce6:	43c8                	lw	a0,4(a5)
    80005ce8:	60a2                	ld	ra,8(sp)
    80005cea:	6402                	ld	s0,0(sp)
    80005cec:	0141                	add	sp,sp,16
    80005cee:	8082                	ret

0000000080005cf0 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    80005cf0:	1101                	add	sp,sp,-32
    80005cf2:	ec06                	sd	ra,24(sp)
    80005cf4:	e822                	sd	s0,16(sp)
    80005cf6:	e426                	sd	s1,8(sp)
    80005cf8:	1000                	add	s0,sp,32
    80005cfa:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005cfc:	ffffc097          	auipc	ra,0xffffc
    80005d00:	ddc080e7          	jalr	-548(ra) # 80001ad8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d04:	00d5151b          	sllw	a0,a0,0xd
    80005d08:	0c2017b7          	lui	a5,0xc201
    80005d0c:	97aa                	add	a5,a5,a0
    80005d0e:	c3c4                	sw	s1,4(a5)
}
    80005d10:	60e2                	ld	ra,24(sp)
    80005d12:	6442                	ld	s0,16(sp)
    80005d14:	64a2                	ld	s1,8(sp)
    80005d16:	6105                	add	sp,sp,32
    80005d18:	8082                	ret

0000000080005d1a <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    80005d1a:	1141                	add	sp,sp,-16
    80005d1c:	e406                	sd	ra,8(sp)
    80005d1e:	e022                	sd	s0,0(sp)
    80005d20:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005d22:	479d                	li	a5,7
    80005d24:	04a7cc63          	blt	a5,a0,80005d7c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005d28:	0001c797          	auipc	a5,0x1c
    80005d2c:	fd878793          	add	a5,a5,-40 # 80021d00 <disk>
    80005d30:	97aa                	add	a5,a5,a0
    80005d32:	0187c783          	lbu	a5,24(a5)
    80005d36:	ebb9                	bnez	a5,80005d8c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005d38:	00451693          	sll	a3,a0,0x4
    80005d3c:	0001c797          	auipc	a5,0x1c
    80005d40:	fc478793          	add	a5,a5,-60 # 80021d00 <disk>
    80005d44:	6398                	ld	a4,0(a5)
    80005d46:	9736                	add	a4,a4,a3
    80005d48:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005d4c:	6398                	ld	a4,0(a5)
    80005d4e:	9736                	add	a4,a4,a3
    80005d50:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005d54:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005d58:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005d5c:	97aa                	add	a5,a5,a0
    80005d5e:	4705                	li	a4,1
    80005d60:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005d64:	0001c517          	auipc	a0,0x1c
    80005d68:	fb450513          	add	a0,a0,-76 # 80021d18 <disk+0x18>
    80005d6c:	ffffc097          	auipc	ra,0xffffc
    80005d70:	4c8080e7          	jalr	1224(ra) # 80002234 <wakeup>
}
    80005d74:	60a2                	ld	ra,8(sp)
    80005d76:	6402                	ld	s0,0(sp)
    80005d78:	0141                	add	sp,sp,16
    80005d7a:	8082                	ret
    panic("free_desc 1");
    80005d7c:	00003517          	auipc	a0,0x3
    80005d80:	a0450513          	add	a0,a0,-1532 # 80008780 <syscalls+0x2f0>
    80005d84:	ffffb097          	auipc	ra,0xffffb
    80005d88:	a8a080e7          	jalr	-1398(ra) # 8000080e <panic>
    panic("free_desc 2");
    80005d8c:	00003517          	auipc	a0,0x3
    80005d90:	a0450513          	add	a0,a0,-1532 # 80008790 <syscalls+0x300>
    80005d94:	ffffb097          	auipc	ra,0xffffb
    80005d98:	a7a080e7          	jalr	-1414(ra) # 8000080e <panic>

0000000080005d9c <virtio_disk_init>:
{
    80005d9c:	1101                	add	sp,sp,-32
    80005d9e:	ec06                	sd	ra,24(sp)
    80005da0:	e822                	sd	s0,16(sp)
    80005da2:	e426                	sd	s1,8(sp)
    80005da4:	e04a                	sd	s2,0(sp)
    80005da6:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005da8:	00003597          	auipc	a1,0x3
    80005dac:	9f858593          	add	a1,a1,-1544 # 800087a0 <syscalls+0x310>
    80005db0:	0001c517          	auipc	a0,0x1c
    80005db4:	07850513          	add	a0,a0,120 # 80021e28 <disk+0x128>
    80005db8:	ffffb097          	auipc	ra,0xffffb
    80005dbc:	e84080e7          	jalr	-380(ra) # 80000c3c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dc0:	100017b7          	lui	a5,0x10001
    80005dc4:	4398                	lw	a4,0(a5)
    80005dc6:	2701                	sext.w	a4,a4
    80005dc8:	747277b7          	lui	a5,0x74727
    80005dcc:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005dd0:	14f71b63          	bne	a4,a5,80005f26 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dd4:	100017b7          	lui	a5,0x10001
    80005dd8:	43dc                	lw	a5,4(a5)
    80005dda:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ddc:	4709                	li	a4,2
    80005dde:	14e79463          	bne	a5,a4,80005f26 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005de2:	100017b7          	lui	a5,0x10001
    80005de6:	479c                	lw	a5,8(a5)
    80005de8:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dea:	12e79e63          	bne	a5,a4,80005f26 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005dee:	100017b7          	lui	a5,0x10001
    80005df2:	47d8                	lw	a4,12(a5)
    80005df4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005df6:	554d47b7          	lui	a5,0x554d4
    80005dfa:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005dfe:	12f71463          	bne	a4,a5,80005f26 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e02:	100017b7          	lui	a5,0x10001
    80005e06:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e0a:	4705                	li	a4,1
    80005e0c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e0e:	470d                	li	a4,3
    80005e10:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e12:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e14:	c7ffe6b7          	lui	a3,0xc7ffe
    80005e18:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc91f>
    80005e1c:	8f75                	and	a4,a4,a3
    80005e1e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e20:	472d                	li	a4,11
    80005e22:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005e24:	5bbc                	lw	a5,112(a5)
    80005e26:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005e2a:	8ba1                	and	a5,a5,8
    80005e2c:	10078563          	beqz	a5,80005f36 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e30:	100017b7          	lui	a5,0x10001
    80005e34:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005e38:	43fc                	lw	a5,68(a5)
    80005e3a:	2781                	sext.w	a5,a5
    80005e3c:	10079563          	bnez	a5,80005f46 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e40:	100017b7          	lui	a5,0x10001
    80005e44:	5bdc                	lw	a5,52(a5)
    80005e46:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e48:	10078763          	beqz	a5,80005f56 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005e4c:	471d                	li	a4,7
    80005e4e:	10f77c63          	bgeu	a4,a5,80005f66 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005e52:	ffffb097          	auipc	ra,0xffffb
    80005e56:	d8a080e7          	jalr	-630(ra) # 80000bdc <kalloc>
    80005e5a:	0001c497          	auipc	s1,0x1c
    80005e5e:	ea648493          	add	s1,s1,-346 # 80021d00 <disk>
    80005e62:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005e64:	ffffb097          	auipc	ra,0xffffb
    80005e68:	d78080e7          	jalr	-648(ra) # 80000bdc <kalloc>
    80005e6c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005e6e:	ffffb097          	auipc	ra,0xffffb
    80005e72:	d6e080e7          	jalr	-658(ra) # 80000bdc <kalloc>
    80005e76:	87aa                	mv	a5,a0
    80005e78:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005e7a:	6088                	ld	a0,0(s1)
    80005e7c:	cd6d                	beqz	a0,80005f76 <virtio_disk_init+0x1da>
    80005e7e:	0001c717          	auipc	a4,0x1c
    80005e82:	e8a73703          	ld	a4,-374(a4) # 80021d08 <disk+0x8>
    80005e86:	cb65                	beqz	a4,80005f76 <virtio_disk_init+0x1da>
    80005e88:	c7fd                	beqz	a5,80005f76 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005e8a:	6605                	lui	a2,0x1
    80005e8c:	4581                	li	a1,0
    80005e8e:	ffffb097          	auipc	ra,0xffffb
    80005e92:	f3a080e7          	jalr	-198(ra) # 80000dc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005e96:	0001c497          	auipc	s1,0x1c
    80005e9a:	e6a48493          	add	s1,s1,-406 # 80021d00 <disk>
    80005e9e:	6605                	lui	a2,0x1
    80005ea0:	4581                	li	a1,0
    80005ea2:	6488                	ld	a0,8(s1)
    80005ea4:	ffffb097          	auipc	ra,0xffffb
    80005ea8:	f24080e7          	jalr	-220(ra) # 80000dc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005eac:	6605                	lui	a2,0x1
    80005eae:	4581                	li	a1,0
    80005eb0:	6888                	ld	a0,16(s1)
    80005eb2:	ffffb097          	auipc	ra,0xffffb
    80005eb6:	f16080e7          	jalr	-234(ra) # 80000dc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005eba:	100017b7          	lui	a5,0x10001
    80005ebe:	4721                	li	a4,8
    80005ec0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005ec2:	4098                	lw	a4,0(s1)
    80005ec4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005ec8:	40d8                	lw	a4,4(s1)
    80005eca:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005ece:	6498                	ld	a4,8(s1)
    80005ed0:	0007069b          	sext.w	a3,a4
    80005ed4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005ed8:	9701                	sra	a4,a4,0x20
    80005eda:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005ede:	6898                	ld	a4,16(s1)
    80005ee0:	0007069b          	sext.w	a3,a4
    80005ee4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005ee8:	9701                	sra	a4,a4,0x20
    80005eea:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005eee:	4705                	li	a4,1
    80005ef0:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005ef2:	00e48c23          	sb	a4,24(s1)
    80005ef6:	00e48ca3          	sb	a4,25(s1)
    80005efa:	00e48d23          	sb	a4,26(s1)
    80005efe:	00e48da3          	sb	a4,27(s1)
    80005f02:	00e48e23          	sb	a4,28(s1)
    80005f06:	00e48ea3          	sb	a4,29(s1)
    80005f0a:	00e48f23          	sb	a4,30(s1)
    80005f0e:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005f12:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f16:	0727a823          	sw	s2,112(a5)
}
    80005f1a:	60e2                	ld	ra,24(sp)
    80005f1c:	6442                	ld	s0,16(sp)
    80005f1e:	64a2                	ld	s1,8(sp)
    80005f20:	6902                	ld	s2,0(sp)
    80005f22:	6105                	add	sp,sp,32
    80005f24:	8082                	ret
    panic("could not find virtio disk");
    80005f26:	00003517          	auipc	a0,0x3
    80005f2a:	88a50513          	add	a0,a0,-1910 # 800087b0 <syscalls+0x320>
    80005f2e:	ffffb097          	auipc	ra,0xffffb
    80005f32:	8e0080e7          	jalr	-1824(ra) # 8000080e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005f36:	00003517          	auipc	a0,0x3
    80005f3a:	89a50513          	add	a0,a0,-1894 # 800087d0 <syscalls+0x340>
    80005f3e:	ffffb097          	auipc	ra,0xffffb
    80005f42:	8d0080e7          	jalr	-1840(ra) # 8000080e <panic>
    panic("virtio disk should not be ready");
    80005f46:	00003517          	auipc	a0,0x3
    80005f4a:	8aa50513          	add	a0,a0,-1878 # 800087f0 <syscalls+0x360>
    80005f4e:	ffffb097          	auipc	ra,0xffffb
    80005f52:	8c0080e7          	jalr	-1856(ra) # 8000080e <panic>
    panic("virtio disk has no queue 0");
    80005f56:	00003517          	auipc	a0,0x3
    80005f5a:	8ba50513          	add	a0,a0,-1862 # 80008810 <syscalls+0x380>
    80005f5e:	ffffb097          	auipc	ra,0xffffb
    80005f62:	8b0080e7          	jalr	-1872(ra) # 8000080e <panic>
    panic("virtio disk max queue too short");
    80005f66:	00003517          	auipc	a0,0x3
    80005f6a:	8ca50513          	add	a0,a0,-1846 # 80008830 <syscalls+0x3a0>
    80005f6e:	ffffb097          	auipc	ra,0xffffb
    80005f72:	8a0080e7          	jalr	-1888(ra) # 8000080e <panic>
    panic("virtio disk kalloc");
    80005f76:	00003517          	auipc	a0,0x3
    80005f7a:	8da50513          	add	a0,a0,-1830 # 80008850 <syscalls+0x3c0>
    80005f7e:	ffffb097          	auipc	ra,0xffffb
    80005f82:	890080e7          	jalr	-1904(ra) # 8000080e <panic>

0000000080005f86 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f86:	7159                	add	sp,sp,-112
    80005f88:	f486                	sd	ra,104(sp)
    80005f8a:	f0a2                	sd	s0,96(sp)
    80005f8c:	eca6                	sd	s1,88(sp)
    80005f8e:	e8ca                	sd	s2,80(sp)
    80005f90:	e4ce                	sd	s3,72(sp)
    80005f92:	e0d2                	sd	s4,64(sp)
    80005f94:	fc56                	sd	s5,56(sp)
    80005f96:	f85a                	sd	s6,48(sp)
    80005f98:	f45e                	sd	s7,40(sp)
    80005f9a:	f062                	sd	s8,32(sp)
    80005f9c:	ec66                	sd	s9,24(sp)
    80005f9e:	e86a                	sd	s10,16(sp)
    80005fa0:	1880                	add	s0,sp,112
    80005fa2:	8a2a                	mv	s4,a0
    80005fa4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005fa6:	00c52c83          	lw	s9,12(a0)
    80005faa:	001c9c9b          	sllw	s9,s9,0x1
    80005fae:	1c82                	sll	s9,s9,0x20
    80005fb0:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005fb4:	0001c517          	auipc	a0,0x1c
    80005fb8:	e7450513          	add	a0,a0,-396 # 80021e28 <disk+0x128>
    80005fbc:	ffffb097          	auipc	ra,0xffffb
    80005fc0:	d10080e7          	jalr	-752(ra) # 80000ccc <acquire>
  for(int i = 0; i < 3; i++){
    80005fc4:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005fc6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005fc8:	0001cb17          	auipc	s6,0x1c
    80005fcc:	d38b0b13          	add	s6,s6,-712 # 80021d00 <disk>
  for(int i = 0; i < 3; i++){
    80005fd0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005fd2:	0001cc17          	auipc	s8,0x1c
    80005fd6:	e56c0c13          	add	s8,s8,-426 # 80021e28 <disk+0x128>
    80005fda:	a095                	j	8000603e <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005fdc:	00fb0733          	add	a4,s6,a5
    80005fe0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005fe4:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005fe6:	0207c563          	bltz	a5,80006010 <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005fea:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005fec:	0591                	add	a1,a1,4
    80005fee:	05560d63          	beq	a2,s5,80006048 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005ff2:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005ff4:	0001c717          	auipc	a4,0x1c
    80005ff8:	d0c70713          	add	a4,a4,-756 # 80021d00 <disk>
    80005ffc:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005ffe:	01874683          	lbu	a3,24(a4)
    80006002:	fee9                	bnez	a3,80005fdc <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80006004:	2785                	addw	a5,a5,1
    80006006:	0705                	add	a4,a4,1
    80006008:	fe979be3          	bne	a5,s1,80005ffe <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    8000600c:	57fd                	li	a5,-1
    8000600e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80006010:	00c05e63          	blez	a2,8000602c <virtio_disk_rw+0xa6>
    80006014:	060a                	sll	a2,a2,0x2
    80006016:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000601a:	0009a503          	lw	a0,0(s3)
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	cfc080e7          	jalr	-772(ra) # 80005d1a <free_desc>
      for(int j = 0; j < i; j++)
    80006026:	0991                	add	s3,s3,4
    80006028:	ffa999e3          	bne	s3,s10,8000601a <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000602c:	85e2                	mv	a1,s8
    8000602e:	0001c517          	auipc	a0,0x1c
    80006032:	cea50513          	add	a0,a0,-790 # 80021d18 <disk+0x18>
    80006036:	ffffc097          	auipc	ra,0xffffc
    8000603a:	19a080e7          	jalr	410(ra) # 800021d0 <sleep>
  for(int i = 0; i < 3; i++){
    8000603e:	f9040993          	add	s3,s0,-112
{
    80006042:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006044:	864a                	mv	a2,s2
    80006046:	b775                	j	80005ff2 <virtio_disk_rw+0x6c>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006048:	f9042503          	lw	a0,-112(s0)
    8000604c:	00a50713          	add	a4,a0,10
    80006050:	0712                	sll	a4,a4,0x4

  if(write)
    80006052:	0001c797          	auipc	a5,0x1c
    80006056:	cae78793          	add	a5,a5,-850 # 80021d00 <disk>
    8000605a:	00e786b3          	add	a3,a5,a4
    8000605e:	01703633          	snez	a2,s7
    80006062:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    80006064:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006068:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000606c:	f6070613          	add	a2,a4,-160
    80006070:	6394                	ld	a3,0(a5)
    80006072:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006074:	00870593          	add	a1,a4,8
    80006078:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000607a:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000607c:	0007b803          	ld	a6,0(a5)
    80006080:	9642                	add	a2,a2,a6
    80006082:	46c1                	li	a3,16
    80006084:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006086:	4585                	li	a1,1
    80006088:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    8000608c:	f9442683          	lw	a3,-108(s0)
    80006090:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006094:	0692                	sll	a3,a3,0x4
    80006096:	9836                	add	a6,a6,a3
    80006098:	058a0613          	add	a2,s4,88
    8000609c:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800060a0:	0007b803          	ld	a6,0(a5)
    800060a4:	96c2                	add	a3,a3,a6
    800060a6:	40000613          	li	a2,1024
    800060aa:	c690                	sw	a2,8(a3)
  if(write)
    800060ac:	001bb613          	seqz	a2,s7
    800060b0:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800060b4:	00166613          	or	a2,a2,1
    800060b8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800060bc:	f9842603          	lw	a2,-104(s0)
    800060c0:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    800060c4:	00250693          	add	a3,a0,2
    800060c8:	0692                	sll	a3,a3,0x4
    800060ca:	96be                	add	a3,a3,a5
    800060cc:	58fd                	li	a7,-1
    800060ce:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800060d2:	0612                	sll	a2,a2,0x4
    800060d4:	9832                	add	a6,a6,a2
    800060d6:	f9070713          	add	a4,a4,-112
    800060da:	973e                	add	a4,a4,a5
    800060dc:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800060e0:	6398                	ld	a4,0(a5)
    800060e2:	9732                	add	a4,a4,a2
    800060e4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    800060e6:	4609                	li	a2,2
    800060e8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800060ec:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    800060f0:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800060f4:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800060f8:	6794                	ld	a3,8(a5)
    800060fa:	0026d703          	lhu	a4,2(a3)
    800060fe:	8b1d                	and	a4,a4,7
    80006100:	0706                	sll	a4,a4,0x1
    80006102:	96ba                	add	a3,a3,a4
    80006104:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006108:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    8000610c:	6798                	ld	a4,8(a5)
    8000610e:	00275783          	lhu	a5,2(a4)
    80006112:	2785                	addw	a5,a5,1
    80006114:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006118:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    8000611c:	100017b7          	lui	a5,0x10001
    80006120:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    80006124:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006128:	0001c917          	auipc	s2,0x1c
    8000612c:	d0090913          	add	s2,s2,-768 # 80021e28 <disk+0x128>
  while(b->disk == 1) {
    80006130:	4485                	li	s1,1
    80006132:	00b79c63          	bne	a5,a1,8000614a <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006136:	85ca                	mv	a1,s2
    80006138:	8552                	mv	a0,s4
    8000613a:	ffffc097          	auipc	ra,0xffffc
    8000613e:	096080e7          	jalr	150(ra) # 800021d0 <sleep>
  while(b->disk == 1) {
    80006142:	004a2783          	lw	a5,4(s4)
    80006146:	fe9788e3          	beq	a5,s1,80006136 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000614a:	f9042903          	lw	s2,-112(s0)
    8000614e:	00290713          	add	a4,s2,2
    80006152:	0712                	sll	a4,a4,0x4
    80006154:	0001c797          	auipc	a5,0x1c
    80006158:	bac78793          	add	a5,a5,-1108 # 80021d00 <disk>
    8000615c:	97ba                	add	a5,a5,a4
    8000615e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006162:	0001c997          	auipc	s3,0x1c
    80006166:	b9e98993          	add	s3,s3,-1122 # 80021d00 <disk>
    8000616a:	00491713          	sll	a4,s2,0x4
    8000616e:	0009b783          	ld	a5,0(s3)
    80006172:	97ba                	add	a5,a5,a4
    80006174:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006178:	854a                	mv	a0,s2
    8000617a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	b9c080e7          	jalr	-1124(ra) # 80005d1a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006186:	8885                	and	s1,s1,1
    80006188:	f0ed                	bnez	s1,8000616a <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000618a:	0001c517          	auipc	a0,0x1c
    8000618e:	c9e50513          	add	a0,a0,-866 # 80021e28 <disk+0x128>
    80006192:	ffffb097          	auipc	ra,0xffffb
    80006196:	bee080e7          	jalr	-1042(ra) # 80000d80 <release>
}
    8000619a:	70a6                	ld	ra,104(sp)
    8000619c:	7406                	ld	s0,96(sp)
    8000619e:	64e6                	ld	s1,88(sp)
    800061a0:	6946                	ld	s2,80(sp)
    800061a2:	69a6                	ld	s3,72(sp)
    800061a4:	6a06                	ld	s4,64(sp)
    800061a6:	7ae2                	ld	s5,56(sp)
    800061a8:	7b42                	ld	s6,48(sp)
    800061aa:	7ba2                	ld	s7,40(sp)
    800061ac:	7c02                	ld	s8,32(sp)
    800061ae:	6ce2                	ld	s9,24(sp)
    800061b0:	6d42                	ld	s10,16(sp)
    800061b2:	6165                	add	sp,sp,112
    800061b4:	8082                	ret

00000000800061b6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800061b6:	1101                	add	sp,sp,-32
    800061b8:	ec06                	sd	ra,24(sp)
    800061ba:	e822                	sd	s0,16(sp)
    800061bc:	e426                	sd	s1,8(sp)
    800061be:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800061c0:	0001c497          	auipc	s1,0x1c
    800061c4:	b4048493          	add	s1,s1,-1216 # 80021d00 <disk>
    800061c8:	0001c517          	auipc	a0,0x1c
    800061cc:	c6050513          	add	a0,a0,-928 # 80021e28 <disk+0x128>
    800061d0:	ffffb097          	auipc	ra,0xffffb
    800061d4:	afc080e7          	jalr	-1284(ra) # 80000ccc <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800061d8:	10001737          	lui	a4,0x10001
    800061dc:	533c                	lw	a5,96(a4)
    800061de:	8b8d                	and	a5,a5,3
    800061e0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800061e2:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    800061e6:	689c                	ld	a5,16(s1)
    800061e8:	0204d703          	lhu	a4,32(s1)
    800061ec:	0027d783          	lhu	a5,2(a5)
    800061f0:	04f70863          	beq	a4,a5,80006240 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800061f4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800061f8:	6898                	ld	a4,16(s1)
    800061fa:	0204d783          	lhu	a5,32(s1)
    800061fe:	8b9d                	and	a5,a5,7
    80006200:	078e                	sll	a5,a5,0x3
    80006202:	97ba                	add	a5,a5,a4
    80006204:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006206:	00278713          	add	a4,a5,2
    8000620a:	0712                	sll	a4,a4,0x4
    8000620c:	9726                	add	a4,a4,s1
    8000620e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006212:	e721                	bnez	a4,8000625a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006214:	0789                	add	a5,a5,2
    80006216:	0792                	sll	a5,a5,0x4
    80006218:	97a6                	add	a5,a5,s1
    8000621a:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    8000621c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006220:	ffffc097          	auipc	ra,0xffffc
    80006224:	014080e7          	jalr	20(ra) # 80002234 <wakeup>

    disk.used_idx += 1;
    80006228:	0204d783          	lhu	a5,32(s1)
    8000622c:	2785                	addw	a5,a5,1
    8000622e:	17c2                	sll	a5,a5,0x30
    80006230:	93c1                	srl	a5,a5,0x30
    80006232:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006236:	6898                	ld	a4,16(s1)
    80006238:	00275703          	lhu	a4,2(a4)
    8000623c:	faf71ce3          	bne	a4,a5,800061f4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006240:	0001c517          	auipc	a0,0x1c
    80006244:	be850513          	add	a0,a0,-1048 # 80021e28 <disk+0x128>
    80006248:	ffffb097          	auipc	ra,0xffffb
    8000624c:	b38080e7          	jalr	-1224(ra) # 80000d80 <release>
}
    80006250:	60e2                	ld	ra,24(sp)
    80006252:	6442                	ld	s0,16(sp)
    80006254:	64a2                	ld	s1,8(sp)
    80006256:	6105                	add	sp,sp,32
    80006258:	8082                	ret
      panic("virtio_disk_intr status");
    8000625a:	00002517          	auipc	a0,0x2
    8000625e:	60e50513          	add	a0,a0,1550 # 80008868 <syscalls+0x3d8>
    80006262:	ffffa097          	auipc	ra,0xffffa
    80006266:	5ac080e7          	jalr	1452(ra) # 8000080e <panic>
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
