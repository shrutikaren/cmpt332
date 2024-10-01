
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	a9010113          	add	sp,sp,-1392 # 80007a90 <stack0>
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd83f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	d9478793          	add	a5,a5,-620 # 80000e14 <main>
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
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	add	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
/* */
/* user write()s to the console go here. */
/* */
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	add	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	ec56                	sd	s5,24(sp)
    800000e0:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e2:	04c05363          	blez	a2,80000128 <consolewrite+0x58>
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	add	a0,s0,-65
    800000fa:	0b4020ef          	jal	800021ae <either_copyin>
    800000fe:	01550b63          	beq	a0,s5,80000114 <consolewrite+0x44>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	7e2000ef          	jal	800008e8 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addw	s2,s2,1
    8000010c:	0485                	add	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
  }

  return i;
}
    80000114:	854a                	mv	a0,s2
    80000116:	60a6                	ld	ra,72(sp)
    80000118:	6406                	ld	s0,64(sp)
    8000011a:	74e2                	ld	s1,56(sp)
    8000011c:	7942                	ld	s2,48(sp)
    8000011e:	79a2                	ld	s3,40(sp)
    80000120:	7a02                	ld	s4,32(sp)
    80000122:	6ae2                	ld	s5,24(sp)
    80000124:	6161                	add	sp,sp,80
    80000126:	8082                	ret
  for(i = 0; i < n; i++){
    80000128:	4901                	li	s2,0
    8000012a:	b7ed                	j	80000114 <consolewrite+0x44>

000000008000012c <consoleread>:
/* user_dist indicates whether dst is a user */
/* or kernel address. */
/* */
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000012c:	711d                	add	sp,sp,-96
    8000012e:	ec86                	sd	ra,88(sp)
    80000130:	e8a2                	sd	s0,80(sp)
    80000132:	e4a6                	sd	s1,72(sp)
    80000134:	e0ca                	sd	s2,64(sp)
    80000136:	fc4e                	sd	s3,56(sp)
    80000138:	f852                	sd	s4,48(sp)
    8000013a:	f456                	sd	s5,40(sp)
    8000013c:	f05a                	sd	s6,32(sp)
    8000013e:	ec5e                	sd	s7,24(sp)
    80000140:	1080                	add	s0,sp,96
    80000142:	8aaa                	mv	s5,a0
    80000144:	8a2e                	mv	s4,a1
    80000146:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000148:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000014c:	00010517          	auipc	a0,0x10
    80000150:	94450513          	add	a0,a0,-1724 # 8000fa90 <cons>
    80000154:	24d000ef          	jal	80000ba0 <acquire>
  while(n > 0){
    /* wait until interrupt handler has put some */
    /* input into cons.buffer. */
    while(cons.r == cons.w){
    80000158:	00010497          	auipc	s1,0x10
    8000015c:	93848493          	add	s1,s1,-1736 # 8000fa90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000160:	00010917          	auipc	s2,0x10
    80000164:	9c890913          	add	s2,s2,-1592 # 8000fb28 <cons+0x98>
  while(n > 0){
    80000168:	07305a63          	blez	s3,800001dc <consoleread+0xb0>
    while(cons.r == cons.w){
    8000016c:	0984a783          	lw	a5,152(s1)
    80000170:	09c4a703          	lw	a4,156(s1)
    80000174:	02f71163          	bne	a4,a5,80000196 <consoleread+0x6a>
      if(killed(myproc())){
    80000178:	6b8010ef          	jal	80001830 <myproc>
    8000017c:	6c5010ef          	jal	80002040 <killed>
    80000180:	e53d                	bnez	a0,800001ee <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80000182:	85a6                	mv	a1,s1
    80000184:	854a                	mv	a0,s2
    80000186:	483010ef          	jal	80001e08 <sleep>
    while(cons.r == cons.w){
    8000018a:	0984a783          	lw	a5,152(s1)
    8000018e:	09c4a703          	lw	a4,156(s1)
    80000192:	fef703e3          	beq	a4,a5,80000178 <consoleread+0x4c>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000196:	00010717          	auipc	a4,0x10
    8000019a:	8fa70713          	add	a4,a4,-1798 # 8000fa90 <cons>
    8000019e:	0017869b          	addw	a3,a5,1
    800001a2:	08d72c23          	sw	a3,152(a4)
    800001a6:	07f7f693          	and	a3,a5,127
    800001aa:	9736                	add	a4,a4,a3
    800001ac:	01874703          	lbu	a4,24(a4)
    800001b0:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  /* end-of-file */
    800001b4:	4691                	li	a3,4
    800001b6:	04db8e63          	beq	s7,a3,80000212 <consoleread+0xe6>
      }
      break;
    }

    /* copy the input byte to the user-space buffer. */
    cbuf = c;
    800001ba:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001be:	4685                	li	a3,1
    800001c0:	faf40613          	add	a2,s0,-81
    800001c4:	85d2                	mv	a1,s4
    800001c6:	8556                	mv	a0,s5
    800001c8:	79d010ef          	jal	80002164 <either_copyout>
    800001cc:	57fd                	li	a5,-1
    800001ce:	00f50763          	beq	a0,a5,800001dc <consoleread+0xb0>
      break;

    dst++;
    800001d2:	0a05                	add	s4,s4,1
    --n;
    800001d4:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    800001d6:	47a9                	li	a5,10
    800001d8:	f8fb98e3          	bne	s7,a5,80000168 <consoleread+0x3c>
      /* a whole line has arrived, return to */
      /* the user-level read(). */
      break;
    }
  }
  release(&cons.lock);
    800001dc:	00010517          	auipc	a0,0x10
    800001e0:	8b450513          	add	a0,a0,-1868 # 8000fa90 <cons>
    800001e4:	255000ef          	jal	80000c38 <release>

  return target - n;
    800001e8:	413b053b          	subw	a0,s6,s3
    800001ec:	a801                	j	800001fc <consoleread+0xd0>
        release(&cons.lock);
    800001ee:	00010517          	auipc	a0,0x10
    800001f2:	8a250513          	add	a0,a0,-1886 # 8000fa90 <cons>
    800001f6:	243000ef          	jal	80000c38 <release>
        return -1;
    800001fa:	557d                	li	a0,-1
}
    800001fc:	60e6                	ld	ra,88(sp)
    800001fe:	6446                	ld	s0,80(sp)
    80000200:	64a6                	ld	s1,72(sp)
    80000202:	6906                	ld	s2,64(sp)
    80000204:	79e2                	ld	s3,56(sp)
    80000206:	7a42                	ld	s4,48(sp)
    80000208:	7aa2                	ld	s5,40(sp)
    8000020a:	7b02                	ld	s6,32(sp)
    8000020c:	6be2                	ld	s7,24(sp)
    8000020e:	6125                	add	sp,sp,96
    80000210:	8082                	ret
      if(n < target){
    80000212:	0009871b          	sext.w	a4,s3
    80000216:	fd6773e3          	bgeu	a4,s6,800001dc <consoleread+0xb0>
        cons.r--;
    8000021a:	00010717          	auipc	a4,0x10
    8000021e:	90f72723          	sw	a5,-1778(a4) # 8000fb28 <cons+0x98>
    80000222:	bf6d                	j	800001dc <consoleread+0xb0>

0000000080000224 <consputc>:
{
    80000224:	1141                	add	sp,sp,-16
    80000226:	e406                	sd	ra,8(sp)
    80000228:	e022                	sd	s0,0(sp)
    8000022a:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000022c:	10000793          	li	a5,256
    80000230:	00f50863          	beq	a0,a5,80000240 <consputc+0x1c>
    uartputc_sync(c);
    80000234:	5de000ef          	jal	80000812 <uartputc_sync>
}
    80000238:	60a2                	ld	ra,8(sp)
    8000023a:	6402                	ld	s0,0(sp)
    8000023c:	0141                	add	sp,sp,16
    8000023e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000240:	4521                	li	a0,8
    80000242:	5d0000ef          	jal	80000812 <uartputc_sync>
    80000246:	02000513          	li	a0,32
    8000024a:	5c8000ef          	jal	80000812 <uartputc_sync>
    8000024e:	4521                	li	a0,8
    80000250:	5c2000ef          	jal	80000812 <uartputc_sync>
    80000254:	b7d5                	j	80000238 <consputc+0x14>

0000000080000256 <consoleintr>:
/* do erase/kill processing, append to cons.buf, */
/* wake up consoleread() if a whole line has arrived. */
/* */
void
consoleintr(int c)
{
    80000256:	1101                	add	sp,sp,-32
    80000258:	ec06                	sd	ra,24(sp)
    8000025a:	e822                	sd	s0,16(sp)
    8000025c:	e426                	sd	s1,8(sp)
    8000025e:	e04a                	sd	s2,0(sp)
    80000260:	1000                	add	s0,sp,32
    80000262:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000264:	00010517          	auipc	a0,0x10
    80000268:	82c50513          	add	a0,a0,-2004 # 8000fa90 <cons>
    8000026c:	135000ef          	jal	80000ba0 <acquire>

  switch(c){
    80000270:	47d5                	li	a5,21
    80000272:	0af48063          	beq	s1,a5,80000312 <consoleintr+0xbc>
    80000276:	0297c663          	blt	a5,s1,800002a2 <consoleintr+0x4c>
    8000027a:	47a1                	li	a5,8
    8000027c:	0cf48f63          	beq	s1,a5,8000035a <consoleintr+0x104>
    80000280:	47c1                	li	a5,16
    80000282:	10f49063          	bne	s1,a5,80000382 <consoleintr+0x12c>
  case C('P'):  /* Print process list. */
    procdump();
    80000286:	773010ef          	jal	800021f8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028a:	00010517          	auipc	a0,0x10
    8000028e:	80650513          	add	a0,a0,-2042 # 8000fa90 <cons>
    80000292:	1a7000ef          	jal	80000c38 <release>
}
    80000296:	60e2                	ld	ra,24(sp)
    80000298:	6442                	ld	s0,16(sp)
    8000029a:	64a2                	ld	s1,8(sp)
    8000029c:	6902                	ld	s2,0(sp)
    8000029e:	6105                	add	sp,sp,32
    800002a0:	8082                	ret
  switch(c){
    800002a2:	07f00793          	li	a5,127
    800002a6:	0af48a63          	beq	s1,a5,8000035a <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002aa:	0000f717          	auipc	a4,0xf
    800002ae:	7e670713          	add	a4,a4,2022 # 8000fa90 <cons>
    800002b2:	0a072783          	lw	a5,160(a4)
    800002b6:	09872703          	lw	a4,152(a4)
    800002ba:	9f99                	subw	a5,a5,a4
    800002bc:	07f00713          	li	a4,127
    800002c0:	fcf765e3          	bltu	a4,a5,8000028a <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002c4:	47b5                	li	a5,13
    800002c6:	0cf48163          	beq	s1,a5,80000388 <consoleintr+0x132>
      consputc(c);
    800002ca:	8526                	mv	a0,s1
    800002cc:	f59ff0ef          	jal	80000224 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002d0:	0000f797          	auipc	a5,0xf
    800002d4:	7c078793          	add	a5,a5,1984 # 8000fa90 <cons>
    800002d8:	0a07a683          	lw	a3,160(a5)
    800002dc:	0016871b          	addw	a4,a3,1
    800002e0:	0007061b          	sext.w	a2,a4
    800002e4:	0ae7a023          	sw	a4,160(a5)
    800002e8:	07f6f693          	and	a3,a3,127
    800002ec:	97b6                	add	a5,a5,a3
    800002ee:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002f2:	47a9                	li	a5,10
    800002f4:	0af48f63          	beq	s1,a5,800003b2 <consoleintr+0x15c>
    800002f8:	4791                	li	a5,4
    800002fa:	0af48c63          	beq	s1,a5,800003b2 <consoleintr+0x15c>
    800002fe:	00010797          	auipc	a5,0x10
    80000302:	82a7a783          	lw	a5,-2006(a5) # 8000fb28 <cons+0x98>
    80000306:	9f1d                	subw	a4,a4,a5
    80000308:	08000793          	li	a5,128
    8000030c:	f6f71fe3          	bne	a4,a5,8000028a <consoleintr+0x34>
    80000310:	a04d                	j	800003b2 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000312:	0000f717          	auipc	a4,0xf
    80000316:	77e70713          	add	a4,a4,1918 # 8000fa90 <cons>
    8000031a:	0a072783          	lw	a5,160(a4)
    8000031e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000322:	0000f497          	auipc	s1,0xf
    80000326:	76e48493          	add	s1,s1,1902 # 8000fa90 <cons>
    while(cons.e != cons.w &&
    8000032a:	4929                	li	s2,10
    8000032c:	f4f70fe3          	beq	a4,a5,8000028a <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000330:	37fd                	addw	a5,a5,-1
    80000332:	07f7f713          	and	a4,a5,127
    80000336:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000338:	01874703          	lbu	a4,24(a4)
    8000033c:	f52707e3          	beq	a4,s2,8000028a <consoleintr+0x34>
      cons.e--;
    80000340:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000344:	10000513          	li	a0,256
    80000348:	eddff0ef          	jal	80000224 <consputc>
    while(cons.e != cons.w &&
    8000034c:	0a04a783          	lw	a5,160(s1)
    80000350:	09c4a703          	lw	a4,156(s1)
    80000354:	fcf71ee3          	bne	a4,a5,80000330 <consoleintr+0xda>
    80000358:	bf0d                	j	8000028a <consoleintr+0x34>
    if(cons.e != cons.w){
    8000035a:	0000f717          	auipc	a4,0xf
    8000035e:	73670713          	add	a4,a4,1846 # 8000fa90 <cons>
    80000362:	0a072783          	lw	a5,160(a4)
    80000366:	09c72703          	lw	a4,156(a4)
    8000036a:	f2f700e3          	beq	a4,a5,8000028a <consoleintr+0x34>
      cons.e--;
    8000036e:	37fd                	addw	a5,a5,-1
    80000370:	0000f717          	auipc	a4,0xf
    80000374:	7cf72023          	sw	a5,1984(a4) # 8000fb30 <cons+0xa0>
      consputc(BACKSPACE);
    80000378:	10000513          	li	a0,256
    8000037c:	ea9ff0ef          	jal	80000224 <consputc>
    80000380:	b729                	j	8000028a <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000382:	f00484e3          	beqz	s1,8000028a <consoleintr+0x34>
    80000386:	b715                	j	800002aa <consoleintr+0x54>
      consputc(c);
    80000388:	4529                	li	a0,10
    8000038a:	e9bff0ef          	jal	80000224 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000038e:	0000f797          	auipc	a5,0xf
    80000392:	70278793          	add	a5,a5,1794 # 8000fa90 <cons>
    80000396:	0a07a703          	lw	a4,160(a5)
    8000039a:	0017069b          	addw	a3,a4,1
    8000039e:	0006861b          	sext.w	a2,a3
    800003a2:	0ad7a023          	sw	a3,160(a5)
    800003a6:	07f77713          	and	a4,a4,127
    800003aa:	97ba                	add	a5,a5,a4
    800003ac:	4729                	li	a4,10
    800003ae:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003b2:	0000f797          	auipc	a5,0xf
    800003b6:	76c7ad23          	sw	a2,1914(a5) # 8000fb2c <cons+0x9c>
        wakeup(&cons.r);
    800003ba:	0000f517          	auipc	a0,0xf
    800003be:	76e50513          	add	a0,a0,1902 # 8000fb28 <cons+0x98>
    800003c2:	293010ef          	jal	80001e54 <wakeup>
    800003c6:	b5d1                	j	8000028a <consoleintr+0x34>

00000000800003c8 <consoleinit>:

void
consoleinit(void)
{
    800003c8:	1141                	add	sp,sp,-16
    800003ca:	e406                	sd	ra,8(sp)
    800003cc:	e022                	sd	s0,0(sp)
    800003ce:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    800003d0:	00007597          	auipc	a1,0x7
    800003d4:	c4058593          	add	a1,a1,-960 # 80007010 <etext+0x10>
    800003d8:	0000f517          	auipc	a0,0xf
    800003dc:	6b850513          	add	a0,a0,1720 # 8000fa90 <cons>
    800003e0:	740000ef          	jal	80000b20 <initlock>

  uartinit();
    800003e4:	3e2000ef          	jal	800007c6 <uartinit>

  /* connect read and write system calls */
  /* to consoleread and consolewrite. */
  devsw[CONSOLE].read = consoleread;
    800003e8:	00020797          	auipc	a5,0x20
    800003ec:	a4078793          	add	a5,a5,-1472 # 8001fe28 <devsw>
    800003f0:	00000717          	auipc	a4,0x0
    800003f4:	d3c70713          	add	a4,a4,-708 # 8000012c <consoleread>
    800003f8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800003fa:	00000717          	auipc	a4,0x0
    800003fe:	cd670713          	add	a4,a4,-810 # 800000d0 <consolewrite>
    80000402:	ef98                	sd	a4,24(a5)
}
    80000404:	60a2                	ld	ra,8(sp)
    80000406:	6402                	ld	s0,0(sp)
    80000408:	0141                	add	sp,sp,16
    8000040a:	8082                	ret

000000008000040c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000040c:	7179                	add	sp,sp,-48
    8000040e:	f406                	sd	ra,40(sp)
    80000410:	f022                	sd	s0,32(sp)
    80000412:	ec26                	sd	s1,24(sp)
    80000414:	e84a                	sd	s2,16(sp)
    80000416:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000418:	c219                	beqz	a2,8000041e <printint+0x12>
    8000041a:	06054e63          	bltz	a0,80000496 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000041e:	4881                	li	a7,0
    80000420:	fd040693          	add	a3,s0,-48

  i = 0;
    80000424:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000426:	00007617          	auipc	a2,0x7
    8000042a:	c1260613          	add	a2,a2,-1006 # 80007038 <digits>
    8000042e:	883e                	mv	a6,a5
    80000430:	2785                	addw	a5,a5,1
    80000432:	02b57733          	remu	a4,a0,a1
    80000436:	9732                	add	a4,a4,a2
    80000438:	00074703          	lbu	a4,0(a4)
    8000043c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000440:	872a                	mv	a4,a0
    80000442:	02b55533          	divu	a0,a0,a1
    80000446:	0685                	add	a3,a3,1
    80000448:	feb773e3          	bgeu	a4,a1,8000042e <printint+0x22>

  if(sign)
    8000044c:	00088a63          	beqz	a7,80000460 <printint+0x54>
    buf[i++] = '-';
    80000450:	1781                	add	a5,a5,-32
    80000452:	97a2                	add	a5,a5,s0
    80000454:	02d00713          	li	a4,45
    80000458:	fee78823          	sb	a4,-16(a5)
    8000045c:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
    80000460:	02f05563          	blez	a5,8000048a <printint+0x7e>
    80000464:	fd040713          	add	a4,s0,-48
    80000468:	00f704b3          	add	s1,a4,a5
    8000046c:	fff70913          	add	s2,a4,-1
    80000470:	993e                	add	s2,s2,a5
    80000472:	37fd                	addw	a5,a5,-1
    80000474:	1782                	sll	a5,a5,0x20
    80000476:	9381                	srl	a5,a5,0x20
    80000478:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000047c:	fff4c503          	lbu	a0,-1(s1)
    80000480:	da5ff0ef          	jal	80000224 <consputc>
  while(--i >= 0)
    80000484:	14fd                	add	s1,s1,-1
    80000486:	ff249be3          	bne	s1,s2,8000047c <printint+0x70>
}
    8000048a:	70a2                	ld	ra,40(sp)
    8000048c:	7402                	ld	s0,32(sp)
    8000048e:	64e2                	ld	s1,24(sp)
    80000490:	6942                	ld	s2,16(sp)
    80000492:	6145                	add	sp,sp,48
    80000494:	8082                	ret
    x = -xx;
    80000496:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000049a:	4885                	li	a7,1
    x = -xx;
    8000049c:	b751                	j	80000420 <printint+0x14>

000000008000049e <printf>:
}

/* Print to the console. */
int
printf(char *fmt, ...)
{
    8000049e:	7155                	add	sp,sp,-208
    800004a0:	e506                	sd	ra,136(sp)
    800004a2:	e122                	sd	s0,128(sp)
    800004a4:	fca6                	sd	s1,120(sp)
    800004a6:	f8ca                	sd	s2,112(sp)
    800004a8:	f4ce                	sd	s3,104(sp)
    800004aa:	f0d2                	sd	s4,96(sp)
    800004ac:	ecd6                	sd	s5,88(sp)
    800004ae:	e8da                	sd	s6,80(sp)
    800004b0:	e4de                	sd	s7,72(sp)
    800004b2:	e0e2                	sd	s8,64(sp)
    800004b4:	fc66                	sd	s9,56(sp)
    800004b6:	f86a                	sd	s10,48(sp)
    800004b8:	f46e                	sd	s11,40(sp)
    800004ba:	0900                	add	s0,sp,144
    800004bc:	8a2a                	mv	s4,a0
    800004be:	e40c                	sd	a1,8(s0)
    800004c0:	e810                	sd	a2,16(s0)
    800004c2:	ec14                	sd	a3,24(s0)
    800004c4:	f018                	sd	a4,32(s0)
    800004c6:	f41c                	sd	a5,40(s0)
    800004c8:	03043823          	sd	a6,48(s0)
    800004cc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004d0:	0000f797          	auipc	a5,0xf
    800004d4:	6807a783          	lw	a5,1664(a5) # 8000fb50 <pr+0x18>
    800004d8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004dc:	e79d                	bnez	a5,8000050a <printf+0x6c>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004de:	00840793          	add	a5,s0,8
    800004e2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004e6:	00054503          	lbu	a0,0(a0)
    800004ea:	24050a63          	beqz	a0,8000073e <printf+0x2a0>
    800004ee:	4981                	li	s3,0
    if(cx != '%'){
    800004f0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004f4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800004f8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800004fc:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000500:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000504:	07000d93          	li	s11,112
    80000508:	a081                	j	80000548 <printf+0xaa>
    acquire(&pr.lock);
    8000050a:	0000f517          	auipc	a0,0xf
    8000050e:	62e50513          	add	a0,a0,1582 # 8000fb38 <pr>
    80000512:	68e000ef          	jal	80000ba0 <acquire>
  va_start(ap, fmt);
    80000516:	00840793          	add	a5,s0,8
    8000051a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000051e:	000a4503          	lbu	a0,0(s4)
    80000522:	f571                	bnez	a0,800004ee <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000524:	0000f517          	auipc	a0,0xf
    80000528:	61450513          	add	a0,a0,1556 # 8000fb38 <pr>
    8000052c:	70c000ef          	jal	80000c38 <release>
    80000530:	a439                	j	8000073e <printf+0x2a0>
      consputc(cx);
    80000532:	cf3ff0ef          	jal	80000224 <consputc>
      continue;
    80000536:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000538:	0014899b          	addw	s3,s1,1
    8000053c:	013a07b3          	add	a5,s4,s3
    80000540:	0007c503          	lbu	a0,0(a5)
    80000544:	1e050963          	beqz	a0,80000736 <printf+0x298>
    if(cx != '%'){
    80000548:	ff5515e3          	bne	a0,s5,80000532 <printf+0x94>
    i++;
    8000054c:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000550:	009a07b3          	add	a5,s4,s1
    80000554:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000558:	1c090f63          	beqz	s2,80000736 <printf+0x298>
    8000055c:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000560:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000562:	c789                	beqz	a5,8000056c <printf+0xce>
    80000564:	009a0733          	add	a4,s4,s1
    80000568:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    8000056c:	03690763          	beq	s2,s6,8000059a <printf+0xfc>
    } else if(c0 == 'l' && c1 == 'd'){
    80000570:	05890163          	beq	s2,s8,800005b2 <printf+0x114>
    } else if(c0 == 'u'){
    80000574:	0d990b63          	beq	s2,s9,8000064a <printf+0x1ac>
    } else if(c0 == 'x'){
    80000578:	13a90163          	beq	s2,s10,8000069a <printf+0x1fc>
    } else if(c0 == 'p'){
    8000057c:	13b90b63          	beq	s2,s11,800006b2 <printf+0x214>
    } else if(c0 == 's'){
    80000580:	07300793          	li	a5,115
    80000584:	16f90863          	beq	s2,a5,800006f4 <printf+0x256>
    } else if(c0 == '%'){
    80000588:	1b590263          	beq	s2,s5,8000072c <printf+0x28e>
      consputc('%');
    8000058c:	8556                	mv	a0,s5
    8000058e:	c97ff0ef          	jal	80000224 <consputc>
      consputc(c0);
    80000592:	854a                	mv	a0,s2
    80000594:	c91ff0ef          	jal	80000224 <consputc>
    80000598:	b745                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, int), 10, 1);
    8000059a:	f8843783          	ld	a5,-120(s0)
    8000059e:	00878713          	add	a4,a5,8
    800005a2:	f8e43423          	sd	a4,-120(s0)
    800005a6:	4605                	li	a2,1
    800005a8:	45a9                	li	a1,10
    800005aa:	4388                	lw	a0,0(a5)
    800005ac:	e61ff0ef          	jal	8000040c <printint>
    800005b0:	b761                	j	80000538 <printf+0x9a>
    } else if(c0 == 'l' && c1 == 'd'){
    800005b2:	03678663          	beq	a5,s6,800005de <printf+0x140>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005b6:	05878263          	beq	a5,s8,800005fa <printf+0x15c>
    } else if(c0 == 'l' && c1 == 'u'){
    800005ba:	0b978463          	beq	a5,s9,80000662 <printf+0x1c4>
    } else if(c0 == 'l' && c1 == 'x'){
    800005be:	fda797e3          	bne	a5,s10,8000058c <printf+0xee>
      printint(va_arg(ap, uint64), 16, 0);
    800005c2:	f8843783          	ld	a5,-120(s0)
    800005c6:	00878713          	add	a4,a5,8
    800005ca:	f8e43423          	sd	a4,-120(s0)
    800005ce:	4601                	li	a2,0
    800005d0:	45c1                	li	a1,16
    800005d2:	6388                	ld	a0,0(a5)
    800005d4:	e39ff0ef          	jal	8000040c <printint>
      i += 1;
    800005d8:	0029849b          	addw	s1,s3,2
    800005dc:	bfb1                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 1);
    800005de:	f8843783          	ld	a5,-120(s0)
    800005e2:	00878713          	add	a4,a5,8
    800005e6:	f8e43423          	sd	a4,-120(s0)
    800005ea:	4605                	li	a2,1
    800005ec:	45a9                	li	a1,10
    800005ee:	6388                	ld	a0,0(a5)
    800005f0:	e1dff0ef          	jal	8000040c <printint>
      i += 1;
    800005f4:	0029849b          	addw	s1,s3,2
    800005f8:	b781                	j	80000538 <printf+0x9a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005fa:	06400793          	li	a5,100
    800005fe:	02f68863          	beq	a3,a5,8000062e <printf+0x190>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000602:	07500793          	li	a5,117
    80000606:	06f68c63          	beq	a3,a5,8000067e <printf+0x1e0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000060a:	07800793          	li	a5,120
    8000060e:	f6f69fe3          	bne	a3,a5,8000058c <printf+0xee>
      printint(va_arg(ap, uint64), 16, 0);
    80000612:	f8843783          	ld	a5,-120(s0)
    80000616:	00878713          	add	a4,a5,8
    8000061a:	f8e43423          	sd	a4,-120(s0)
    8000061e:	4601                	li	a2,0
    80000620:	45c1                	li	a1,16
    80000622:	6388                	ld	a0,0(a5)
    80000624:	de9ff0ef          	jal	8000040c <printint>
      i += 2;
    80000628:	0039849b          	addw	s1,s3,3
    8000062c:	b731                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 1);
    8000062e:	f8843783          	ld	a5,-120(s0)
    80000632:	00878713          	add	a4,a5,8
    80000636:	f8e43423          	sd	a4,-120(s0)
    8000063a:	4605                	li	a2,1
    8000063c:	45a9                	li	a1,10
    8000063e:	6388                	ld	a0,0(a5)
    80000640:	dcdff0ef          	jal	8000040c <printint>
      i += 2;
    80000644:	0039849b          	addw	s1,s3,3
    80000648:	bdc5                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, int), 10, 0);
    8000064a:	f8843783          	ld	a5,-120(s0)
    8000064e:	00878713          	add	a4,a5,8
    80000652:	f8e43423          	sd	a4,-120(s0)
    80000656:	4601                	li	a2,0
    80000658:	45a9                	li	a1,10
    8000065a:	4388                	lw	a0,0(a5)
    8000065c:	db1ff0ef          	jal	8000040c <printint>
    80000660:	bde1                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 0);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	add	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4601                	li	a2,0
    80000670:	45a9                	li	a1,10
    80000672:	6388                	ld	a0,0(a5)
    80000674:	d99ff0ef          	jal	8000040c <printint>
      i += 1;
    80000678:	0029849b          	addw	s1,s3,2
    8000067c:	bd75                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, uint64), 10, 0);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	add	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4601                	li	a2,0
    8000068c:	45a9                	li	a1,10
    8000068e:	6388                	ld	a0,0(a5)
    80000690:	d7dff0ef          	jal	8000040c <printint>
      i += 2;
    80000694:	0039849b          	addw	s1,s3,3
    80000698:	b545                	j	80000538 <printf+0x9a>
      printint(va_arg(ap, int), 16, 0);
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	add	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	4601                	li	a2,0
    800006a8:	45c1                	li	a1,16
    800006aa:	4388                	lw	a0,0(a5)
    800006ac:	d61ff0ef          	jal	8000040c <printint>
    800006b0:	b561                	j	80000538 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	add	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006c2:	03000513          	li	a0,48
    800006c6:	b5fff0ef          	jal	80000224 <consputc>
  consputc('x');
    800006ca:	07800513          	li	a0,120
    800006ce:	b57ff0ef          	jal	80000224 <consputc>
    800006d2:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d4:	00007b97          	auipc	s7,0x7
    800006d8:	964b8b93          	add	s7,s7,-1692 # 80007038 <digits>
    800006dc:	03c9d793          	srl	a5,s3,0x3c
    800006e0:	97de                	add	a5,a5,s7
    800006e2:	0007c503          	lbu	a0,0(a5)
    800006e6:	b3fff0ef          	jal	80000224 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ea:	0992                	sll	s3,s3,0x4
    800006ec:	397d                	addw	s2,s2,-1
    800006ee:	fe0917e3          	bnez	s2,800006dc <printf+0x23e>
    800006f2:	b599                	j	80000538 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	add	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	0007b903          	ld	s2,0(a5)
    80000704:	00090d63          	beqz	s2,8000071e <printf+0x280>
      for(; *s; s++)
    80000708:	00094503          	lbu	a0,0(s2)
    8000070c:	e20506e3          	beqz	a0,80000538 <printf+0x9a>
        consputc(*s);
    80000710:	b15ff0ef          	jal	80000224 <consputc>
      for(; *s; s++)
    80000714:	0905                	add	s2,s2,1
    80000716:	00094503          	lbu	a0,0(s2)
    8000071a:	f97d                	bnez	a0,80000710 <printf+0x272>
    8000071c:	bd31                	j	80000538 <printf+0x9a>
        s = "(null)";
    8000071e:	00007917          	auipc	s2,0x7
    80000722:	8fa90913          	add	s2,s2,-1798 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000726:	02800513          	li	a0,40
    8000072a:	b7dd                	j	80000710 <printf+0x272>
      consputc('%');
    8000072c:	02500513          	li	a0,37
    80000730:	af5ff0ef          	jal	80000224 <consputc>
    80000734:	b511                	j	80000538 <printf+0x9a>
  if(locking)
    80000736:	f7843783          	ld	a5,-136(s0)
    8000073a:	de0795e3          	bnez	a5,80000524 <printf+0x86>

  return 0;
}
    8000073e:	4501                	li	a0,0
    80000740:	60aa                	ld	ra,136(sp)
    80000742:	640a                	ld	s0,128(sp)
    80000744:	74e6                	ld	s1,120(sp)
    80000746:	7946                	ld	s2,112(sp)
    80000748:	79a6                	ld	s3,104(sp)
    8000074a:	7a06                	ld	s4,96(sp)
    8000074c:	6ae6                	ld	s5,88(sp)
    8000074e:	6b46                	ld	s6,80(sp)
    80000750:	6ba6                	ld	s7,72(sp)
    80000752:	6c06                	ld	s8,64(sp)
    80000754:	7ce2                	ld	s9,56(sp)
    80000756:	7d42                	ld	s10,48(sp)
    80000758:	7da2                	ld	s11,40(sp)
    8000075a:	6169                	add	sp,sp,208
    8000075c:	8082                	ret

000000008000075e <panic>:

void
panic(char *s)
{
    8000075e:	1101                	add	sp,sp,-32
    80000760:	ec06                	sd	ra,24(sp)
    80000762:	e822                	sd	s0,16(sp)
    80000764:	e426                	sd	s1,8(sp)
    80000766:	1000                	add	s0,sp,32
    80000768:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000076a:	0000f797          	auipc	a5,0xf
    8000076e:	3e07a323          	sw	zero,998(a5) # 8000fb50 <pr+0x18>
  printf("panic: ");
    80000772:	00007517          	auipc	a0,0x7
    80000776:	8ae50513          	add	a0,a0,-1874 # 80007020 <etext+0x20>
    8000077a:	d25ff0ef          	jal	8000049e <printf>
  printf("%s\n", s);
    8000077e:	85a6                	mv	a1,s1
    80000780:	00007517          	auipc	a0,0x7
    80000784:	8a850513          	add	a0,a0,-1880 # 80007028 <etext+0x28>
    80000788:	d17ff0ef          	jal	8000049e <printf>
  panicked = 1; /* freeze uart output from other CPUs */
    8000078c:	4785                	li	a5,1
    8000078e:	00007717          	auipc	a4,0x7
    80000792:	2cf72123          	sw	a5,706(a4) # 80007a50 <panicked>
  for(;;)
    80000796:	a001                	j	80000796 <panic+0x38>

0000000080000798 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000798:	1101                	add	sp,sp,-32
    8000079a:	ec06                	sd	ra,24(sp)
    8000079c:	e822                	sd	s0,16(sp)
    8000079e:	e426                	sd	s1,8(sp)
    800007a0:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    800007a2:	0000f497          	auipc	s1,0xf
    800007a6:	39648493          	add	s1,s1,918 # 8000fb38 <pr>
    800007aa:	00007597          	auipc	a1,0x7
    800007ae:	88658593          	add	a1,a1,-1914 # 80007030 <etext+0x30>
    800007b2:	8526                	mv	a0,s1
    800007b4:	36c000ef          	jal	80000b20 <initlock>
  pr.locking = 1;
    800007b8:	4785                	li	a5,1
    800007ba:	cc9c                	sw	a5,24(s1)
}
    800007bc:	60e2                	ld	ra,24(sp)
    800007be:	6442                	ld	s0,16(sp)
    800007c0:	64a2                	ld	s1,8(sp)
    800007c2:	6105                	add	sp,sp,32
    800007c4:	8082                	ret

00000000800007c6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007c6:	1141                	add	sp,sp,-16
    800007c8:	e406                	sd	ra,8(sp)
    800007ca:	e022                	sd	s0,0(sp)
    800007cc:	0800                	add	s0,sp,16
  /* disable interrupts. */
  WriteReg(IER, 0x00);
    800007ce:	100007b7          	lui	a5,0x10000
    800007d2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  /* special mode to set baud rate. */
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007d6:	f8000713          	li	a4,-128
    800007da:	00e781a3          	sb	a4,3(a5)

  /* LSB for baud rate of 38.4K. */
  WriteReg(0, 0x03);
    800007de:	470d                	li	a4,3
    800007e0:	00e78023          	sb	a4,0(a5)

  /* MSB for baud rate of 38.4K. */
  WriteReg(1, 0x00);
    800007e4:	000780a3          	sb	zero,1(a5)

  /* leave set-baud mode, */
  /* and set word length to 8 bits, no parity. */
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007e8:	00e781a3          	sb	a4,3(a5)

  /* reset and enable FIFOs. */
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ec:	469d                	li	a3,7
    800007ee:	00d78123          	sb	a3,2(a5)

  /* enable transmit and receive interrupts. */
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007f2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007f6:	00007597          	auipc	a1,0x7
    800007fa:	85a58593          	add	a1,a1,-1958 # 80007050 <digits+0x18>
    800007fe:	0000f517          	auipc	a0,0xf
    80000802:	35a50513          	add	a0,a0,858 # 8000fb58 <uart_tx_lock>
    80000806:	31a000ef          	jal	80000b20 <initlock>
}
    8000080a:	60a2                	ld	ra,8(sp)
    8000080c:	6402                	ld	s0,0(sp)
    8000080e:	0141                	add	sp,sp,16
    80000810:	8082                	ret

0000000080000812 <uartputc_sync>:
/* use interrupts, for use by kernel printf() and */
/* to echo characters. it spins waiting for the uart's */
/* output register to be empty. */
void
uartputc_sync(int c)
{
    80000812:	1101                	add	sp,sp,-32
    80000814:	ec06                	sd	ra,24(sp)
    80000816:	e822                	sd	s0,16(sp)
    80000818:	e426                	sd	s1,8(sp)
    8000081a:	1000                	add	s0,sp,32
    8000081c:	84aa                	mv	s1,a0
  push_off();
    8000081e:	342000ef          	jal	80000b60 <push_off>

  if(panicked){
    80000822:	00007797          	auipc	a5,0x7
    80000826:	22e7a783          	lw	a5,558(a5) # 80007a50 <panicked>
    for(;;)
      ;
  }

  /* wait for Transmit Holding Empty to be set in LSR. */
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000082a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000082e:	c391                	beqz	a5,80000832 <uartputc_sync+0x20>
    for(;;)
    80000830:	a001                	j	80000830 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000832:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000836:	0207f793          	and	a5,a5,32
    8000083a:	dfe5                	beqz	a5,80000832 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000083c:	0ff4f513          	zext.b	a0,s1
    80000840:	100007b7          	lui	a5,0x10000
    80000844:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000848:	39c000ef          	jal	80000be4 <pop_off>
}
    8000084c:	60e2                	ld	ra,24(sp)
    8000084e:	6442                	ld	s0,16(sp)
    80000850:	64a2                	ld	s1,8(sp)
    80000852:	6105                	add	sp,sp,32
    80000854:	8082                	ret

0000000080000856 <uartstart>:
/* called from both the top- and bottom-half. */
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000856:	00007797          	auipc	a5,0x7
    8000085a:	2027b783          	ld	a5,514(a5) # 80007a58 <uart_tx_r>
    8000085e:	00007717          	auipc	a4,0x7
    80000862:	20273703          	ld	a4,514(a4) # 80007a60 <uart_tx_w>
    80000866:	06f70c63          	beq	a4,a5,800008de <uartstart+0x88>
{
    8000086a:	7139                	add	sp,sp,-64
    8000086c:	fc06                	sd	ra,56(sp)
    8000086e:	f822                	sd	s0,48(sp)
    80000870:	f426                	sd	s1,40(sp)
    80000872:	f04a                	sd	s2,32(sp)
    80000874:	ec4e                	sd	s3,24(sp)
    80000876:	e852                	sd	s4,16(sp)
    80000878:	e456                	sd	s5,8(sp)
    8000087a:	0080                	add	s0,sp,64
      /* transmit buffer is empty. */
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087c:	10000937          	lui	s2,0x10000
      /* so we cannot give it another byte. */
      /* it will interrupt when it's ready for a new byte. */
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000880:	0000fa17          	auipc	s4,0xf
    80000884:	2d8a0a13          	add	s4,s4,728 # 8000fb58 <uart_tx_lock>
    uart_tx_r += 1;
    80000888:	00007497          	auipc	s1,0x7
    8000088c:	1d048493          	add	s1,s1,464 # 80007a58 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000890:	00007997          	auipc	s3,0x7
    80000894:	1d098993          	add	s3,s3,464 # 80007a60 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000898:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000089c:	02077713          	and	a4,a4,32
    800008a0:	c715                	beqz	a4,800008cc <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008a2:	01f7f713          	and	a4,a5,31
    800008a6:	9752                	add	a4,a4,s4
    800008a8:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008ac:	0785                	add	a5,a5,1
    800008ae:	e09c                	sd	a5,0(s1)
    
    /* maybe uartputc() is waiting for space in the buffer. */
    wakeup(&uart_tx_r);
    800008b0:	8526                	mv	a0,s1
    800008b2:	5a2010ef          	jal	80001e54 <wakeup>
    
    WriteReg(THR, c);
    800008b6:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008ba:	609c                	ld	a5,0(s1)
    800008bc:	0009b703          	ld	a4,0(s3)
    800008c0:	fcf71ce3          	bne	a4,a5,80000898 <uartstart+0x42>
      ReadReg(ISR);
    800008c4:	100007b7          	lui	a5,0x10000
    800008c8:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008cc:	70e2                	ld	ra,56(sp)
    800008ce:	7442                	ld	s0,48(sp)
    800008d0:	74a2                	ld	s1,40(sp)
    800008d2:	7902                	ld	s2,32(sp)
    800008d4:	69e2                	ld	s3,24(sp)
    800008d6:	6a42                	ld	s4,16(sp)
    800008d8:	6aa2                	ld	s5,8(sp)
    800008da:	6121                	add	sp,sp,64
    800008dc:	8082                	ret
      ReadReg(ISR);
    800008de:	100007b7          	lui	a5,0x10000
    800008e2:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008e6:	8082                	ret

00000000800008e8 <uartputc>:
{
    800008e8:	7179                	add	sp,sp,-48
    800008ea:	f406                	sd	ra,40(sp)
    800008ec:	f022                	sd	s0,32(sp)
    800008ee:	ec26                	sd	s1,24(sp)
    800008f0:	e84a                	sd	s2,16(sp)
    800008f2:	e44e                	sd	s3,8(sp)
    800008f4:	e052                	sd	s4,0(sp)
    800008f6:	1800                	add	s0,sp,48
    800008f8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008fa:	0000f517          	auipc	a0,0xf
    800008fe:	25e50513          	add	a0,a0,606 # 8000fb58 <uart_tx_lock>
    80000902:	29e000ef          	jal	80000ba0 <acquire>
  if(panicked){
    80000906:	00007797          	auipc	a5,0x7
    8000090a:	14a7a783          	lw	a5,330(a5) # 80007a50 <panicked>
    8000090e:	efbd                	bnez	a5,8000098c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000910:	00007717          	auipc	a4,0x7
    80000914:	15073703          	ld	a4,336(a4) # 80007a60 <uart_tx_w>
    80000918:	00007797          	auipc	a5,0x7
    8000091c:	1407b783          	ld	a5,320(a5) # 80007a58 <uart_tx_r>
    80000920:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000924:	0000f997          	auipc	s3,0xf
    80000928:	23498993          	add	s3,s3,564 # 8000fb58 <uart_tx_lock>
    8000092c:	00007497          	auipc	s1,0x7
    80000930:	12c48493          	add	s1,s1,300 # 80007a58 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000934:	00007917          	auipc	s2,0x7
    80000938:	12c90913          	add	s2,s2,300 # 80007a60 <uart_tx_w>
    8000093c:	00e79d63          	bne	a5,a4,80000956 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000940:	85ce                	mv	a1,s3
    80000942:	8526                	mv	a0,s1
    80000944:	4c4010ef          	jal	80001e08 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	00093703          	ld	a4,0(s2)
    8000094c:	609c                	ld	a5,0(s1)
    8000094e:	02078793          	add	a5,a5,32
    80000952:	fee787e3          	beq	a5,a4,80000940 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000956:	0000f497          	auipc	s1,0xf
    8000095a:	20248493          	add	s1,s1,514 # 8000fb58 <uart_tx_lock>
    8000095e:	01f77793          	and	a5,a4,31
    80000962:	97a6                	add	a5,a5,s1
    80000964:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000968:	0705                	add	a4,a4,1
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	0ee7bb23          	sd	a4,246(a5) # 80007a60 <uart_tx_w>
  uartstart();
    80000972:	ee5ff0ef          	jal	80000856 <uartstart>
  release(&uart_tx_lock);
    80000976:	8526                	mv	a0,s1
    80000978:	2c0000ef          	jal	80000c38 <release>
}
    8000097c:	70a2                	ld	ra,40(sp)
    8000097e:	7402                	ld	s0,32(sp)
    80000980:	64e2                	ld	s1,24(sp)
    80000982:	6942                	ld	s2,16(sp)
    80000984:	69a2                	ld	s3,8(sp)
    80000986:	6a02                	ld	s4,0(sp)
    80000988:	6145                	add	sp,sp,48
    8000098a:	8082                	ret
    for(;;)
    8000098c:	a001                	j	8000098c <uartputc+0xa4>

000000008000098e <uartgetc>:

/* read one input character from the UART. */
/* return -1 if none is waiting. */
int
uartgetc(void)
{
    8000098e:	1141                	add	sp,sp,-16
    80000990:	e422                	sd	s0,8(sp)
    80000992:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000994:	100007b7          	lui	a5,0x10000
    80000998:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000099c:	8b85                	and	a5,a5,1
    8000099e:	cb81                	beqz	a5,800009ae <uartgetc+0x20>
    /* input data is ready. */
    return ReadReg(RHR);
    800009a0:	100007b7          	lui	a5,0x10000
    800009a4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009a8:	6422                	ld	s0,8(sp)
    800009aa:	0141                	add	sp,sp,16
    800009ac:	8082                	ret
    return -1;
    800009ae:	557d                	li	a0,-1
    800009b0:	bfe5                	j	800009a8 <uartgetc+0x1a>

00000000800009b2 <uartintr>:
/* handle a uart interrupt, raised because input has */
/* arrived, or the uart is ready for more output, or */
/* both. called from devintr(). */
void
uartintr(void)
{
    800009b2:	1101                	add	sp,sp,-32
    800009b4:	ec06                	sd	ra,24(sp)
    800009b6:	e822                	sd	s0,16(sp)
    800009b8:	e426                	sd	s1,8(sp)
    800009ba:	1000                	add	s0,sp,32
  /* read and process incoming characters. */
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009bc:	54fd                	li	s1,-1
    800009be:	a019                	j	800009c4 <uartintr+0x12>
      break;
    consoleintr(c);
    800009c0:	897ff0ef          	jal	80000256 <consoleintr>
    int c = uartgetc();
    800009c4:	fcbff0ef          	jal	8000098e <uartgetc>
    if(c == -1)
    800009c8:	fe951ce3          	bne	a0,s1,800009c0 <uartintr+0xe>
  }

  /* send buffered characters. */
  acquire(&uart_tx_lock);
    800009cc:	0000f497          	auipc	s1,0xf
    800009d0:	18c48493          	add	s1,s1,396 # 8000fb58 <uart_tx_lock>
    800009d4:	8526                	mv	a0,s1
    800009d6:	1ca000ef          	jal	80000ba0 <acquire>
  uartstart();
    800009da:	e7dff0ef          	jal	80000856 <uartstart>
  release(&uart_tx_lock);
    800009de:	8526                	mv	a0,s1
    800009e0:	258000ef          	jal	80000c38 <release>
}
    800009e4:	60e2                	ld	ra,24(sp)
    800009e6:	6442                	ld	s0,16(sp)
    800009e8:	64a2                	ld	s1,8(sp)
    800009ea:	6105                	add	sp,sp,32
    800009ec:	8082                	ret

00000000800009ee <kfree>:
/* which normally should have been returned by a */
/* call to kalloc().  (The exception is when */
/* initializing the allocator; see kinit above.) */
void
kfree(void *pa)
{
    800009ee:	1101                	add	sp,sp,-32
    800009f0:	ec06                	sd	ra,24(sp)
    800009f2:	e822                	sd	s0,16(sp)
    800009f4:	e426                	sd	s1,8(sp)
    800009f6:	e04a                	sd	s2,0(sp)
    800009f8:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009fa:	03451793          	sll	a5,a0,0x34
    800009fe:	e7a9                	bnez	a5,80000a48 <kfree+0x5a>
    80000a00:	84aa                	mv	s1,a0
    80000a02:	00020797          	auipc	a5,0x20
    80000a06:	5be78793          	add	a5,a5,1470 # 80020fc0 <end>
    80000a0a:	02f56f63          	bltu	a0,a5,80000a48 <kfree+0x5a>
    80000a0e:	47c5                	li	a5,17
    80000a10:	07ee                	sll	a5,a5,0x1b
    80000a12:	02f57b63          	bgeu	a0,a5,80000a48 <kfree+0x5a>
    panic("kfree");

  /* Fill with junk to catch dangling refs. */
  memset(pa, 1, PGSIZE);
    80000a16:	6605                	lui	a2,0x1
    80000a18:	4585                	li	a1,1
    80000a1a:	25a000ef          	jal	80000c74 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1e:	0000f917          	auipc	s2,0xf
    80000a22:	17290913          	add	s2,s2,370 # 8000fb90 <kmem>
    80000a26:	854a                	mv	a0,s2
    80000a28:	178000ef          	jal	80000ba0 <acquire>
  r->next = kmem.freelist;
    80000a2c:	01893783          	ld	a5,24(s2)
    80000a30:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a32:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a36:	854a                	mv	a0,s2
    80000a38:	200000ef          	jal	80000c38 <release>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6902                	ld	s2,0(sp)
    80000a44:	6105                	add	sp,sp,32
    80000a46:	8082                	ret
    panic("kfree");
    80000a48:	00006517          	auipc	a0,0x6
    80000a4c:	61050513          	add	a0,a0,1552 # 80007058 <digits+0x20>
    80000a50:	d0fff0ef          	jal	8000075e <panic>

0000000080000a54 <freerange>:
{
    80000a54:	7179                	add	sp,sp,-48
    80000a56:	f406                	sd	ra,40(sp)
    80000a58:	f022                	sd	s0,32(sp)
    80000a5a:	ec26                	sd	s1,24(sp)
    80000a5c:	e84a                	sd	s2,16(sp)
    80000a5e:	e44e                	sd	s3,8(sp)
    80000a60:	e052                	sd	s4,0(sp)
    80000a62:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a64:	6785                	lui	a5,0x1
    80000a66:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a6a:	00e504b3          	add	s1,a0,a4
    80000a6e:	777d                	lui	a4,0xfffff
    80000a70:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	94be                	add	s1,s1,a5
    80000a74:	0095ec63          	bltu	a1,s1,80000a8c <freerange+0x38>
    80000a78:	892e                	mv	s2,a1
    kfree(p);
    80000a7a:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	6985                	lui	s3,0x1
    kfree(p);
    80000a7e:	01448533          	add	a0,s1,s4
    80000a82:	f6dff0ef          	jal	800009ee <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	94ce                	add	s1,s1,s3
    80000a88:	fe997be3          	bgeu	s2,s1,80000a7e <freerange+0x2a>
}
    80000a8c:	70a2                	ld	ra,40(sp)
    80000a8e:	7402                	ld	s0,32(sp)
    80000a90:	64e2                	ld	s1,24(sp)
    80000a92:	6942                	ld	s2,16(sp)
    80000a94:	69a2                	ld	s3,8(sp)
    80000a96:	6a02                	ld	s4,0(sp)
    80000a98:	6145                	add	sp,sp,48
    80000a9a:	8082                	ret

0000000080000a9c <kinit>:
{
    80000a9c:	1141                	add	sp,sp,-16
    80000a9e:	e406                	sd	ra,8(sp)
    80000aa0:	e022                	sd	s0,0(sp)
    80000aa2:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aa4:	00006597          	auipc	a1,0x6
    80000aa8:	5bc58593          	add	a1,a1,1468 # 80007060 <digits+0x28>
    80000aac:	0000f517          	auipc	a0,0xf
    80000ab0:	0e450513          	add	a0,a0,228 # 8000fb90 <kmem>
    80000ab4:	06c000ef          	jal	80000b20 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab8:	45c5                	li	a1,17
    80000aba:	05ee                	sll	a1,a1,0x1b
    80000abc:	00020517          	auipc	a0,0x20
    80000ac0:	50450513          	add	a0,a0,1284 # 80020fc0 <end>
    80000ac4:	f91ff0ef          	jal	80000a54 <freerange>
}
    80000ac8:	60a2                	ld	ra,8(sp)
    80000aca:	6402                	ld	s0,0(sp)
    80000acc:	0141                	add	sp,sp,16
    80000ace:	8082                	ret

0000000080000ad0 <kalloc>:
/* Allocate one 4096-byte page of physical memory. */
/* Returns a pointer that the kernel can use. */
/* Returns 0 if the memory cannot be allocated. */
void *
kalloc(void)
{
    80000ad0:	1101                	add	sp,sp,-32
    80000ad2:	ec06                	sd	ra,24(sp)
    80000ad4:	e822                	sd	s0,16(sp)
    80000ad6:	e426                	sd	s1,8(sp)
    80000ad8:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ada:	0000f497          	auipc	s1,0xf
    80000ade:	0b648493          	add	s1,s1,182 # 8000fb90 <kmem>
    80000ae2:	8526                	mv	a0,s1
    80000ae4:	0bc000ef          	jal	80000ba0 <acquire>
  r = kmem.freelist;
    80000ae8:	6c84                	ld	s1,24(s1)
  if(r)
    80000aea:	c485                	beqz	s1,80000b12 <kalloc+0x42>
    kmem.freelist = r->next;
    80000aec:	609c                	ld	a5,0(s1)
    80000aee:	0000f517          	auipc	a0,0xf
    80000af2:	0a250513          	add	a0,a0,162 # 8000fb90 <kmem>
    80000af6:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000af8:	140000ef          	jal	80000c38 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); /* fill with junk */
    80000afc:	6605                	lui	a2,0x1
    80000afe:	4595                	li	a1,5
    80000b00:	8526                	mv	a0,s1
    80000b02:	172000ef          	jal	80000c74 <memset>
  return (void*)r;
}
    80000b06:	8526                	mv	a0,s1
    80000b08:	60e2                	ld	ra,24(sp)
    80000b0a:	6442                	ld	s0,16(sp)
    80000b0c:	64a2                	ld	s1,8(sp)
    80000b0e:	6105                	add	sp,sp,32
    80000b10:	8082                	ret
  release(&kmem.lock);
    80000b12:	0000f517          	auipc	a0,0xf
    80000b16:	07e50513          	add	a0,a0,126 # 8000fb90 <kmem>
    80000b1a:	11e000ef          	jal	80000c38 <release>
  if(r)
    80000b1e:	b7e5                	j	80000b06 <kalloc+0x36>

0000000080000b20 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b20:	1141                	add	sp,sp,-16
    80000b22:	e422                	sd	s0,8(sp)
    80000b24:	0800                	add	s0,sp,16
  lk->name = name;
    80000b26:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b28:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b2c:	00053823          	sd	zero,16(a0)
}
    80000b30:	6422                	ld	s0,8(sp)
    80000b32:	0141                	add	sp,sp,16
    80000b34:	8082                	ret

0000000080000b36 <holding>:
/* Interrupts must be off. */
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b36:	411c                	lw	a5,0(a0)
    80000b38:	e399                	bnez	a5,80000b3e <holding+0x8>
    80000b3a:	4501                	li	a0,0
  return r;
}
    80000b3c:	8082                	ret
{
    80000b3e:	1101                	add	sp,sp,-32
    80000b40:	ec06                	sd	ra,24(sp)
    80000b42:	e822                	sd	s0,16(sp)
    80000b44:	e426                	sd	s1,8(sp)
    80000b46:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	6904                	ld	s1,16(a0)
    80000b4a:	4cb000ef          	jal	80001814 <mycpu>
    80000b4e:	40a48533          	sub	a0,s1,a0
    80000b52:	00153513          	seqz	a0,a0
}
    80000b56:	60e2                	ld	ra,24(sp)
    80000b58:	6442                	ld	s0,16(sp)
    80000b5a:	64a2                	ld	s1,8(sp)
    80000b5c:	6105                	add	sp,sp,32
    80000b5e:	8082                	ret

0000000080000b60 <push_off>:
/* it takes two pop_off()s to undo two push_off()s.  Also, if interrupts */
/* are initially off, then push_off, pop_off leaves them off. */

void
push_off(void)
{
    80000b60:	1101                	add	sp,sp,-32
    80000b62:	ec06                	sd	ra,24(sp)
    80000b64:	e822                	sd	s0,16(sp)
    80000b66:	e426                	sd	s1,8(sp)
    80000b68:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b6a:	100024f3          	csrr	s1,sstatus
    80000b6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b72:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b74:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b78:	49d000ef          	jal	80001814 <mycpu>
    80000b7c:	5d3c                	lw	a5,120(a0)
    80000b7e:	cb99                	beqz	a5,80000b94 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b80:	495000ef          	jal	80001814 <mycpu>
    80000b84:	5d3c                	lw	a5,120(a0)
    80000b86:	2785                	addw	a5,a5,1
    80000b88:	dd3c                	sw	a5,120(a0)
}
    80000b8a:	60e2                	ld	ra,24(sp)
    80000b8c:	6442                	ld	s0,16(sp)
    80000b8e:	64a2                	ld	s1,8(sp)
    80000b90:	6105                	add	sp,sp,32
    80000b92:	8082                	ret
    mycpu()->intena = old;
    80000b94:	481000ef          	jal	80001814 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b98:	8085                	srl	s1,s1,0x1
    80000b9a:	8885                	and	s1,s1,1
    80000b9c:	dd64                	sw	s1,124(a0)
    80000b9e:	b7cd                	j	80000b80 <push_off+0x20>

0000000080000ba0 <acquire>:
{
    80000ba0:	1101                	add	sp,sp,-32
    80000ba2:	ec06                	sd	ra,24(sp)
    80000ba4:	e822                	sd	s0,16(sp)
    80000ba6:	e426                	sd	s1,8(sp)
    80000ba8:	1000                	add	s0,sp,32
    80000baa:	84aa                	mv	s1,a0
  push_off(); /* disable interrupts to avoid deadlock. */
    80000bac:	fb5ff0ef          	jal	80000b60 <push_off>
  if(holding(lk))
    80000bb0:	8526                	mv	a0,s1
    80000bb2:	f85ff0ef          	jal	80000b36 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb6:	4705                	li	a4,1
  if(holding(lk))
    80000bb8:	e105                	bnez	a0,80000bd8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bba:	87ba                	mv	a5,a4
    80000bbc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bc0:	2781                	sext.w	a5,a5
    80000bc2:	ffe5                	bnez	a5,80000bba <acquire+0x1a>
  __sync_synchronize();
    80000bc4:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bc8:	44d000ef          	jal	80001814 <mycpu>
    80000bcc:	e888                	sd	a0,16(s1)
}
    80000bce:	60e2                	ld	ra,24(sp)
    80000bd0:	6442                	ld	s0,16(sp)
    80000bd2:	64a2                	ld	s1,8(sp)
    80000bd4:	6105                	add	sp,sp,32
    80000bd6:	8082                	ret
    panic("acquire");
    80000bd8:	00006517          	auipc	a0,0x6
    80000bdc:	49050513          	add	a0,a0,1168 # 80007068 <digits+0x30>
    80000be0:	b7fff0ef          	jal	8000075e <panic>

0000000080000be4 <pop_off>:

void
pop_off(void)
{
    80000be4:	1141                	add	sp,sp,-16
    80000be6:	e406                	sd	ra,8(sp)
    80000be8:	e022                	sd	s0,0(sp)
    80000bea:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000bec:	429000ef          	jal	80001814 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bf4:	8b89                	and	a5,a5,2
  if(intr_get())
    80000bf6:	e78d                	bnez	a5,80000c20 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bf8:	5d3c                	lw	a5,120(a0)
    80000bfa:	02f05963          	blez	a5,80000c2c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bfe:	37fd                	addw	a5,a5,-1
    80000c00:	0007871b          	sext.w	a4,a5
    80000c04:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c06:	eb09                	bnez	a4,80000c18 <pop_off+0x34>
    80000c08:	5d7c                	lw	a5,124(a0)
    80000c0a:	c799                	beqz	a5,80000c18 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c10:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c14:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c18:	60a2                	ld	ra,8(sp)
    80000c1a:	6402                	ld	s0,0(sp)
    80000c1c:	0141                	add	sp,sp,16
    80000c1e:	8082                	ret
    panic("pop_off - interruptible");
    80000c20:	00006517          	auipc	a0,0x6
    80000c24:	45050513          	add	a0,a0,1104 # 80007070 <digits+0x38>
    80000c28:	b37ff0ef          	jal	8000075e <panic>
    panic("pop_off");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	45c50513          	add	a0,a0,1116 # 80007088 <digits+0x50>
    80000c34:	b2bff0ef          	jal	8000075e <panic>

0000000080000c38 <release>:
{
    80000c38:	1101                	add	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	add	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c44:	ef3ff0ef          	jal	80000b36 <holding>
    80000c48:	c105                	beqz	a0,80000c68 <release+0x30>
  lk->cpu = 0;
    80000c4a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c4e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c52:	0f50000f          	fence	iorw,ow
    80000c56:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c5a:	f8bff0ef          	jal	80000be4 <pop_off>
}
    80000c5e:	60e2                	ld	ra,24(sp)
    80000c60:	6442                	ld	s0,16(sp)
    80000c62:	64a2                	ld	s1,8(sp)
    80000c64:	6105                	add	sp,sp,32
    80000c66:	8082                	ret
    panic("release");
    80000c68:	00006517          	auipc	a0,0x6
    80000c6c:	42850513          	add	a0,a0,1064 # 80007090 <digits+0x58>
    80000c70:	aefff0ef          	jal	8000075e <panic>

0000000080000c74 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c74:	1141                	add	sp,sp,-16
    80000c76:	e422                	sd	s0,8(sp)
    80000c78:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c7a:	ca19                	beqz	a2,80000c90 <memset+0x1c>
    80000c7c:	87aa                	mv	a5,a0
    80000c7e:	1602                	sll	a2,a2,0x20
    80000c80:	9201                	srl	a2,a2,0x20
    80000c82:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c86:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c8a:	0785                	add	a5,a5,1
    80000c8c:	fee79de3          	bne	a5,a4,80000c86 <memset+0x12>
  }
  return dst;
}
    80000c90:	6422                	ld	s0,8(sp)
    80000c92:	0141                	add	sp,sp,16
    80000c94:	8082                	ret

0000000080000c96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c96:	1141                	add	sp,sp,-16
    80000c98:	e422                	sd	s0,8(sp)
    80000c9a:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c9c:	ca05                	beqz	a2,80000ccc <memcmp+0x36>
    80000c9e:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000ca2:	1682                	sll	a3,a3,0x20
    80000ca4:	9281                	srl	a3,a3,0x20
    80000ca6:	0685                	add	a3,a3,1
    80000ca8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000caa:	00054783          	lbu	a5,0(a0)
    80000cae:	0005c703          	lbu	a4,0(a1)
    80000cb2:	00e79863          	bne	a5,a4,80000cc2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cb6:	0505                	add	a0,a0,1
    80000cb8:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000cba:	fed518e3          	bne	a0,a3,80000caa <memcmp+0x14>
  }

  return 0;
    80000cbe:	4501                	li	a0,0
    80000cc0:	a019                	j	80000cc6 <memcmp+0x30>
      return *s1 - *s2;
    80000cc2:	40e7853b          	subw	a0,a5,a4
}
    80000cc6:	6422                	ld	s0,8(sp)
    80000cc8:	0141                	add	sp,sp,16
    80000cca:	8082                	ret
  return 0;
    80000ccc:	4501                	li	a0,0
    80000cce:	bfe5                	j	80000cc6 <memcmp+0x30>

0000000080000cd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cd0:	1141                	add	sp,sp,-16
    80000cd2:	e422                	sd	s0,8(sp)
    80000cd4:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cd6:	c205                	beqz	a2,80000cf6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cd8:	02a5e263          	bltu	a1,a0,80000cfc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cdc:	1602                	sll	a2,a2,0x20
    80000cde:	9201                	srl	a2,a2,0x20
    80000ce0:	00c587b3          	add	a5,a1,a2
{
    80000ce4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ce6:	0585                	add	a1,a1,1
    80000ce8:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde041>
    80000cea:	fff5c683          	lbu	a3,-1(a1)
    80000cee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cf2:	fef59ae3          	bne	a1,a5,80000ce6 <memmove+0x16>

  return dst;
}
    80000cf6:	6422                	ld	s0,8(sp)
    80000cf8:	0141                	add	sp,sp,16
    80000cfa:	8082                	ret
  if(s < d && s + n > d){
    80000cfc:	02061693          	sll	a3,a2,0x20
    80000d00:	9281                	srl	a3,a3,0x20
    80000d02:	00d58733          	add	a4,a1,a3
    80000d06:	fce57be3          	bgeu	a0,a4,80000cdc <memmove+0xc>
    d += n;
    80000d0a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d0c:	fff6079b          	addw	a5,a2,-1
    80000d10:	1782                	sll	a5,a5,0x20
    80000d12:	9381                	srl	a5,a5,0x20
    80000d14:	fff7c793          	not	a5,a5
    80000d18:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d1a:	177d                	add	a4,a4,-1
    80000d1c:	16fd                	add	a3,a3,-1
    80000d1e:	00074603          	lbu	a2,0(a4)
    80000d22:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d26:	fee79ae3          	bne	a5,a4,80000d1a <memmove+0x4a>
    80000d2a:	b7f1                	j	80000cf6 <memmove+0x26>

0000000080000d2c <memcpy>:

/* memcpy exists to placate GCC.  Use memmove. */
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d2c:	1141                	add	sp,sp,-16
    80000d2e:	e406                	sd	ra,8(sp)
    80000d30:	e022                	sd	s0,0(sp)
    80000d32:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000d34:	f9dff0ef          	jal	80000cd0 <memmove>
}
    80000d38:	60a2                	ld	ra,8(sp)
    80000d3a:	6402                	ld	s0,0(sp)
    80000d3c:	0141                	add	sp,sp,16
    80000d3e:	8082                	ret

0000000080000d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d40:	1141                	add	sp,sp,-16
    80000d42:	e422                	sd	s0,8(sp)
    80000d44:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d46:	ce11                	beqz	a2,80000d62 <strncmp+0x22>
    80000d48:	00054783          	lbu	a5,0(a0)
    80000d4c:	cf89                	beqz	a5,80000d66 <strncmp+0x26>
    80000d4e:	0005c703          	lbu	a4,0(a1)
    80000d52:	00f71a63          	bne	a4,a5,80000d66 <strncmp+0x26>
    n--, p++, q++;
    80000d56:	367d                	addw	a2,a2,-1
    80000d58:	0505                	add	a0,a0,1
    80000d5a:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d5c:	f675                	bnez	a2,80000d48 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d5e:	4501                	li	a0,0
    80000d60:	a809                	j	80000d72 <strncmp+0x32>
    80000d62:	4501                	li	a0,0
    80000d64:	a039                	j	80000d72 <strncmp+0x32>
  if(n == 0)
    80000d66:	ca09                	beqz	a2,80000d78 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d68:	00054503          	lbu	a0,0(a0)
    80000d6c:	0005c783          	lbu	a5,0(a1)
    80000d70:	9d1d                	subw	a0,a0,a5
}
    80000d72:	6422                	ld	s0,8(sp)
    80000d74:	0141                	add	sp,sp,16
    80000d76:	8082                	ret
    return 0;
    80000d78:	4501                	li	a0,0
    80000d7a:	bfe5                	j	80000d72 <strncmp+0x32>

0000000080000d7c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d7c:	1141                	add	sp,sp,-16
    80000d7e:	e422                	sd	s0,8(sp)
    80000d80:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d82:	87aa                	mv	a5,a0
    80000d84:	86b2                	mv	a3,a2
    80000d86:	367d                	addw	a2,a2,-1
    80000d88:	00d05963          	blez	a3,80000d9a <strncpy+0x1e>
    80000d8c:	0785                	add	a5,a5,1
    80000d8e:	0005c703          	lbu	a4,0(a1)
    80000d92:	fee78fa3          	sb	a4,-1(a5)
    80000d96:	0585                	add	a1,a1,1
    80000d98:	f775                	bnez	a4,80000d84 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d9a:	873e                	mv	a4,a5
    80000d9c:	9fb5                	addw	a5,a5,a3
    80000d9e:	37fd                	addw	a5,a5,-1
    80000da0:	00c05963          	blez	a2,80000db2 <strncpy+0x36>
    *s++ = 0;
    80000da4:	0705                	add	a4,a4,1
    80000da6:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000daa:	40e786bb          	subw	a3,a5,a4
    80000dae:	fed04be3          	bgtz	a3,80000da4 <strncpy+0x28>
  return os;
}
    80000db2:	6422                	ld	s0,8(sp)
    80000db4:	0141                	add	sp,sp,16
    80000db6:	8082                	ret

0000000080000db8 <safestrcpy>:

/* Like strncpy but guaranteed to NUL-terminate. */
char*
safestrcpy(char *s, const char *t, int n)
{
    80000db8:	1141                	add	sp,sp,-16
    80000dba:	e422                	sd	s0,8(sp)
    80000dbc:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000dbe:	02c05363          	blez	a2,80000de4 <safestrcpy+0x2c>
    80000dc2:	fff6069b          	addw	a3,a2,-1
    80000dc6:	1682                	sll	a3,a3,0x20
    80000dc8:	9281                	srl	a3,a3,0x20
    80000dca:	96ae                	add	a3,a3,a1
    80000dcc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000dce:	00d58963          	beq	a1,a3,80000de0 <safestrcpy+0x28>
    80000dd2:	0585                	add	a1,a1,1
    80000dd4:	0785                	add	a5,a5,1
    80000dd6:	fff5c703          	lbu	a4,-1(a1)
    80000dda:	fee78fa3          	sb	a4,-1(a5)
    80000dde:	fb65                	bnez	a4,80000dce <safestrcpy+0x16>
    ;
  *s = 0;
    80000de0:	00078023          	sb	zero,0(a5)
  return os;
}
    80000de4:	6422                	ld	s0,8(sp)
    80000de6:	0141                	add	sp,sp,16
    80000de8:	8082                	ret

0000000080000dea <strlen>:

int
strlen(const char *s)
{
    80000dea:	1141                	add	sp,sp,-16
    80000dec:	e422                	sd	s0,8(sp)
    80000dee:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000df0:	00054783          	lbu	a5,0(a0)
    80000df4:	cf91                	beqz	a5,80000e10 <strlen+0x26>
    80000df6:	0505                	add	a0,a0,1
    80000df8:	87aa                	mv	a5,a0
    80000dfa:	86be                	mv	a3,a5
    80000dfc:	0785                	add	a5,a5,1
    80000dfe:	fff7c703          	lbu	a4,-1(a5)
    80000e02:	ff65                	bnez	a4,80000dfa <strlen+0x10>
    80000e04:	40a6853b          	subw	a0,a3,a0
    80000e08:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000e0a:	6422                	ld	s0,8(sp)
    80000e0c:	0141                	add	sp,sp,16
    80000e0e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e10:	4501                	li	a0,0
    80000e12:	bfe5                	j	80000e0a <strlen+0x20>

0000000080000e14 <main>:
volatile static int started = 0;

/* start() jumps here in supervisor mode on all CPUs. */
void
main()
{
    80000e14:	1141                	add	sp,sp,-16
    80000e16:	e406                	sd	ra,8(sp)
    80000e18:	e022                	sd	s0,0(sp)
    80000e1a:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000e1c:	1e9000ef          	jal	80001804 <cpuid>
    virtio_disk_init(); /* emulated hard disk */
    userinit();      /* first user process */
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e20:	00007717          	auipc	a4,0x7
    80000e24:	c4870713          	add	a4,a4,-952 # 80007a68 <started>
  if(cpuid() == 0){
    80000e28:	c51d                	beqz	a0,80000e56 <main+0x42>
    while(started == 0)
    80000e2a:	431c                	lw	a5,0(a4)
    80000e2c:	2781                	sext.w	a5,a5
    80000e2e:	dff5                	beqz	a5,80000e2a <main+0x16>
      ;
    __sync_synchronize();
    80000e30:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e34:	1d1000ef          	jal	80001804 <cpuid>
    80000e38:	85aa                	mv	a1,a0
    80000e3a:	00006517          	auipc	a0,0x6
    80000e3e:	27650513          	add	a0,a0,630 # 800070b0 <digits+0x78>
    80000e42:	e5cff0ef          	jal	8000049e <printf>
    kvminithart();    /* turn on paging */
    80000e46:	080000ef          	jal	80000ec6 <kvminithart>
    trapinithart();   /* install kernel trap vector */
    80000e4a:	4e0010ef          	jal	8000232a <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    80000e4e:	286040ef          	jal	800050d4 <plicinithart>
  }

  scheduler();        
    80000e52:	61d000ef          	jal	80001c6e <scheduler>
    consoleinit();
    80000e56:	d72ff0ef          	jal	800003c8 <consoleinit>
    printfinit();
    80000e5a:	93fff0ef          	jal	80000798 <printfinit>
    printf("\n");
    80000e5e:	00006517          	auipc	a0,0x6
    80000e62:	26250513          	add	a0,a0,610 # 800070c0 <digits+0x88>
    80000e66:	e38ff0ef          	jal	8000049e <printf>
    printf("xv6 kernel is booting\n");
    80000e6a:	00006517          	auipc	a0,0x6
    80000e6e:	22e50513          	add	a0,a0,558 # 80007098 <digits+0x60>
    80000e72:	e2cff0ef          	jal	8000049e <printf>
    printf("\n");
    80000e76:	00006517          	auipc	a0,0x6
    80000e7a:	24a50513          	add	a0,a0,586 # 800070c0 <digits+0x88>
    80000e7e:	e20ff0ef          	jal	8000049e <printf>
    kinit();         /* physical page allocator */
    80000e82:	c1bff0ef          	jal	80000a9c <kinit>
    kvminit();       /* create kernel page table */
    80000e86:	2ca000ef          	jal	80001150 <kvminit>
    kvminithart();   /* turn on paging */
    80000e8a:	03c000ef          	jal	80000ec6 <kvminithart>
    procinit();      /* process table */
    80000e8e:	0cf000ef          	jal	8000175c <procinit>
    trapinit();      /* trap vectors */
    80000e92:	474010ef          	jal	80002306 <trapinit>
    trapinithart();  /* install kernel trap vector */
    80000e96:	494010ef          	jal	8000232a <trapinithart>
    plicinit();      /* set up interrupt controller */
    80000e9a:	224040ef          	jal	800050be <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80000e9e:	236040ef          	jal	800050d4 <plicinithart>
    binit();         /* buffer cache */
    80000ea2:	309010ef          	jal	800029aa <binit>
    iinit();         /* inode table */
    80000ea6:	0e2020ef          	jal	80002f88 <iinit>
    fileinit();      /* file table */
    80000eaa:	655020ef          	jal	80003cfe <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80000eae:	316040ef          	jal	800051c4 <virtio_disk_init>
    userinit();      /* first user process */
    80000eb2:	3eb000ef          	jal	80001a9c <userinit>
    __sync_synchronize();
    80000eb6:	0ff0000f          	fence
    started = 1;
    80000eba:	4785                	li	a5,1
    80000ebc:	00007717          	auipc	a4,0x7
    80000ec0:	baf72623          	sw	a5,-1108(a4) # 80007a68 <started>
    80000ec4:	b779                	j	80000e52 <main+0x3e>

0000000080000ec6 <kvminithart>:

/* Switch h/w page table register to the kernel's page table, */
/* and enable paging. */
void
kvminithart()
{
    80000ec6:	1141                	add	sp,sp,-16
    80000ec8:	e422                	sd	s0,8(sp)
    80000eca:	0800                	add	s0,sp,16
/* flush the TLB. */
static inline void
sfence_vma()
{
  /* the zero, zero means flush all TLB entries. */
  asm volatile("sfence.vma zero, zero");
    80000ecc:	12000073          	sfence.vma
  /* wait for any previous writes to the page table memory to finish. */
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ed0:	00007797          	auipc	a5,0x7
    80000ed4:	ba07b783          	ld	a5,-1120(a5) # 80007a70 <kernel_pagetable>
    80000ed8:	83b1                	srl	a5,a5,0xc
    80000eda:	577d                	li	a4,-1
    80000edc:	177e                	sll	a4,a4,0x3f
    80000ede:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000ee0:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ee4:	12000073          	sfence.vma

  /* flush stale entries from the TLB. */
  sfence_vma();
}
    80000ee8:	6422                	ld	s0,8(sp)
    80000eea:	0141                	add	sp,sp,16
    80000eec:	8082                	ret

0000000080000eee <walk>:
/*   21..29 -- 9 bits of level-1 index. */
/*   12..20 -- 9 bits of level-0 index. */
/*    0..11 -- 12 bits of byte offset within the page. */
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000eee:	7139                	add	sp,sp,-64
    80000ef0:	fc06                	sd	ra,56(sp)
    80000ef2:	f822                	sd	s0,48(sp)
    80000ef4:	f426                	sd	s1,40(sp)
    80000ef6:	f04a                	sd	s2,32(sp)
    80000ef8:	ec4e                	sd	s3,24(sp)
    80000efa:	e852                	sd	s4,16(sp)
    80000efc:	e456                	sd	s5,8(sp)
    80000efe:	e05a                	sd	s6,0(sp)
    80000f00:	0080                	add	s0,sp,64
    80000f02:	84aa                	mv	s1,a0
    80000f04:	89ae                	mv	s3,a1
    80000f06:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f08:	57fd                	li	a5,-1
    80000f0a:	83e9                	srl	a5,a5,0x1a
    80000f0c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f0e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f10:	02b7fc63          	bgeu	a5,a1,80000f48 <walk+0x5a>
    panic("walk");
    80000f14:	00006517          	auipc	a0,0x6
    80000f18:	1b450513          	add	a0,a0,436 # 800070c8 <digits+0x90>
    80000f1c:	843ff0ef          	jal	8000075e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f20:	060a8263          	beqz	s5,80000f84 <walk+0x96>
    80000f24:	badff0ef          	jal	80000ad0 <kalloc>
    80000f28:	84aa                	mv	s1,a0
    80000f2a:	c139                	beqz	a0,80000f70 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	4581                	li	a1,0
    80000f30:	d45ff0ef          	jal	80000c74 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f34:	00c4d793          	srl	a5,s1,0xc
    80000f38:	07aa                	sll	a5,a5,0xa
    80000f3a:	0017e793          	or	a5,a5,1
    80000f3e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f42:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde037>
    80000f44:	036a0063          	beq	s4,s6,80000f64 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f48:	0149d933          	srl	s2,s3,s4
    80000f4c:	1ff97913          	and	s2,s2,511
    80000f50:	090e                	sll	s2,s2,0x3
    80000f52:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f54:	00093483          	ld	s1,0(s2)
    80000f58:	0014f793          	and	a5,s1,1
    80000f5c:	d3f1                	beqz	a5,80000f20 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f5e:	80a9                	srl	s1,s1,0xa
    80000f60:	04b2                	sll	s1,s1,0xc
    80000f62:	b7c5                	j	80000f42 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f64:	00c9d513          	srl	a0,s3,0xc
    80000f68:	1ff57513          	and	a0,a0,511
    80000f6c:	050e                	sll	a0,a0,0x3
    80000f6e:	9526                	add	a0,a0,s1
}
    80000f70:	70e2                	ld	ra,56(sp)
    80000f72:	7442                	ld	s0,48(sp)
    80000f74:	74a2                	ld	s1,40(sp)
    80000f76:	7902                	ld	s2,32(sp)
    80000f78:	69e2                	ld	s3,24(sp)
    80000f7a:	6a42                	ld	s4,16(sp)
    80000f7c:	6aa2                	ld	s5,8(sp)
    80000f7e:	6b02                	ld	s6,0(sp)
    80000f80:	6121                	add	sp,sp,64
    80000f82:	8082                	ret
        return 0;
    80000f84:	4501                	li	a0,0
    80000f86:	b7ed                	j	80000f70 <walk+0x82>

0000000080000f88 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f88:	57fd                	li	a5,-1
    80000f8a:	83e9                	srl	a5,a5,0x1a
    80000f8c:	00b7f463          	bgeu	a5,a1,80000f94 <walkaddr+0xc>
    return 0;
    80000f90:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f92:	8082                	ret
{
    80000f94:	1141                	add	sp,sp,-16
    80000f96:	e406                	sd	ra,8(sp)
    80000f98:	e022                	sd	s0,0(sp)
    80000f9a:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f9c:	4601                	li	a2,0
    80000f9e:	f51ff0ef          	jal	80000eee <walk>
  if(pte == 0)
    80000fa2:	c105                	beqz	a0,80000fc2 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fa4:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fa6:	0117f693          	and	a3,a5,17
    80000faa:	4745                	li	a4,17
    return 0;
    80000fac:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fae:	00e68663          	beq	a3,a4,80000fba <walkaddr+0x32>
}
    80000fb2:	60a2                	ld	ra,8(sp)
    80000fb4:	6402                	ld	s0,0(sp)
    80000fb6:	0141                	add	sp,sp,16
    80000fb8:	8082                	ret
  pa = PTE2PA(*pte);
    80000fba:	83a9                	srl	a5,a5,0xa
    80000fbc:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000fc0:	bfcd                	j	80000fb2 <walkaddr+0x2a>
    return 0;
    80000fc2:	4501                	li	a0,0
    80000fc4:	b7fd                	j	80000fb2 <walkaddr+0x2a>

0000000080000fc6 <mappages>:
/* va and size MUST be page-aligned. */
/* Returns 0 on success, -1 if walk() couldn't */
/* allocate a needed page-table page. */
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fc6:	715d                	add	sp,sp,-80
    80000fc8:	e486                	sd	ra,72(sp)
    80000fca:	e0a2                	sd	s0,64(sp)
    80000fcc:	fc26                	sd	s1,56(sp)
    80000fce:	f84a                	sd	s2,48(sp)
    80000fd0:	f44e                	sd	s3,40(sp)
    80000fd2:	f052                	sd	s4,32(sp)
    80000fd4:	ec56                	sd	s5,24(sp)
    80000fd6:	e85a                	sd	s6,16(sp)
    80000fd8:	e45e                	sd	s7,8(sp)
    80000fda:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000fdc:	03459793          	sll	a5,a1,0x34
    80000fe0:	e7a9                	bnez	a5,8000102a <mappages+0x64>
    80000fe2:	8aaa                	mv	s5,a0
    80000fe4:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000fe6:	03461793          	sll	a5,a2,0x34
    80000fea:	e7b1                	bnez	a5,80001036 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000fec:	ca39                	beqz	a2,80001042 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000fee:	77fd                	lui	a5,0xfffff
    80000ff0:	963e                	add	a2,a2,a5
    80000ff2:	00b609b3          	add	s3,a2,a1
  a = va;
    80000ff6:	892e                	mv	s2,a1
    80000ff8:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000ffc:	6b85                	lui	s7,0x1
    80000ffe:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001002:	4605                	li	a2,1
    80001004:	85ca                	mv	a1,s2
    80001006:	8556                	mv	a0,s5
    80001008:	ee7ff0ef          	jal	80000eee <walk>
    8000100c:	c539                	beqz	a0,8000105a <mappages+0x94>
    if(*pte & PTE_V)
    8000100e:	611c                	ld	a5,0(a0)
    80001010:	8b85                	and	a5,a5,1
    80001012:	ef95                	bnez	a5,8000104e <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001014:	80b1                	srl	s1,s1,0xc
    80001016:	04aa                	sll	s1,s1,0xa
    80001018:	0164e4b3          	or	s1,s1,s6
    8000101c:	0014e493          	or	s1,s1,1
    80001020:	e104                	sd	s1,0(a0)
    if(a == last)
    80001022:	05390863          	beq	s2,s3,80001072 <mappages+0xac>
    a += PGSIZE;
    80001026:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001028:	bfd9                	j	80000ffe <mappages+0x38>
    panic("mappages: va not aligned");
    8000102a:	00006517          	auipc	a0,0x6
    8000102e:	0a650513          	add	a0,a0,166 # 800070d0 <digits+0x98>
    80001032:	f2cff0ef          	jal	8000075e <panic>
    panic("mappages: size not aligned");
    80001036:	00006517          	auipc	a0,0x6
    8000103a:	0ba50513          	add	a0,a0,186 # 800070f0 <digits+0xb8>
    8000103e:	f20ff0ef          	jal	8000075e <panic>
    panic("mappages: size");
    80001042:	00006517          	auipc	a0,0x6
    80001046:	0ce50513          	add	a0,a0,206 # 80007110 <digits+0xd8>
    8000104a:	f14ff0ef          	jal	8000075e <panic>
      panic("mappages: remap");
    8000104e:	00006517          	auipc	a0,0x6
    80001052:	0d250513          	add	a0,a0,210 # 80007120 <digits+0xe8>
    80001056:	f08ff0ef          	jal	8000075e <panic>
      return -1;
    8000105a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000105c:	60a6                	ld	ra,72(sp)
    8000105e:	6406                	ld	s0,64(sp)
    80001060:	74e2                	ld	s1,56(sp)
    80001062:	7942                	ld	s2,48(sp)
    80001064:	79a2                	ld	s3,40(sp)
    80001066:	7a02                	ld	s4,32(sp)
    80001068:	6ae2                	ld	s5,24(sp)
    8000106a:	6b42                	ld	s6,16(sp)
    8000106c:	6ba2                	ld	s7,8(sp)
    8000106e:	6161                	add	sp,sp,80
    80001070:	8082                	ret
  return 0;
    80001072:	4501                	li	a0,0
    80001074:	b7e5                	j	8000105c <mappages+0x96>

0000000080001076 <kvmmap>:
{
    80001076:	1141                	add	sp,sp,-16
    80001078:	e406                	sd	ra,8(sp)
    8000107a:	e022                	sd	s0,0(sp)
    8000107c:	0800                	add	s0,sp,16
    8000107e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001080:	86b2                	mv	a3,a2
    80001082:	863e                	mv	a2,a5
    80001084:	f43ff0ef          	jal	80000fc6 <mappages>
    80001088:	e509                	bnez	a0,80001092 <kvmmap+0x1c>
}
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	add	sp,sp,16
    80001090:	8082                	ret
    panic("kvmmap");
    80001092:	00006517          	auipc	a0,0x6
    80001096:	09e50513          	add	a0,a0,158 # 80007130 <digits+0xf8>
    8000109a:	ec4ff0ef          	jal	8000075e <panic>

000000008000109e <kvmmake>:
{
    8000109e:	1101                	add	sp,sp,-32
    800010a0:	ec06                	sd	ra,24(sp)
    800010a2:	e822                	sd	s0,16(sp)
    800010a4:	e426                	sd	s1,8(sp)
    800010a6:	e04a                	sd	s2,0(sp)
    800010a8:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010aa:	a27ff0ef          	jal	80000ad0 <kalloc>
    800010ae:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010b0:	6605                	lui	a2,0x1
    800010b2:	4581                	li	a1,0
    800010b4:	bc1ff0ef          	jal	80000c74 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010b8:	4719                	li	a4,6
    800010ba:	6685                	lui	a3,0x1
    800010bc:	10000637          	lui	a2,0x10000
    800010c0:	100005b7          	lui	a1,0x10000
    800010c4:	8526                	mv	a0,s1
    800010c6:	fb1ff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010ca:	4719                	li	a4,6
    800010cc:	6685                	lui	a3,0x1
    800010ce:	10001637          	lui	a2,0x10001
    800010d2:	100015b7          	lui	a1,0x10001
    800010d6:	8526                	mv	a0,s1
    800010d8:	f9fff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010dc:	4719                	li	a4,6
    800010de:	040006b7          	lui	a3,0x4000
    800010e2:	0c000637          	lui	a2,0xc000
    800010e6:	0c0005b7          	lui	a1,0xc000
    800010ea:	8526                	mv	a0,s1
    800010ec:	f8bff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800010f0:	00006917          	auipc	s2,0x6
    800010f4:	f1090913          	add	s2,s2,-240 # 80007000 <etext>
    800010f8:	4729                	li	a4,10
    800010fa:	80006697          	auipc	a3,0x80006
    800010fe:	f0668693          	add	a3,a3,-250 # 7000 <_entry-0x7fff9000>
    80001102:	4605                	li	a2,1
    80001104:	067e                	sll	a2,a2,0x1f
    80001106:	85b2                	mv	a1,a2
    80001108:	8526                	mv	a0,s1
    8000110a:	f6dff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000110e:	4719                	li	a4,6
    80001110:	46c5                	li	a3,17
    80001112:	06ee                	sll	a3,a3,0x1b
    80001114:	412686b3          	sub	a3,a3,s2
    80001118:	864a                	mv	a2,s2
    8000111a:	85ca                	mv	a1,s2
    8000111c:	8526                	mv	a0,s1
    8000111e:	f59ff0ef          	jal	80001076 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001122:	4729                	li	a4,10
    80001124:	6685                	lui	a3,0x1
    80001126:	00005617          	auipc	a2,0x5
    8000112a:	eda60613          	add	a2,a2,-294 # 80006000 <_trampoline>
    8000112e:	040005b7          	lui	a1,0x4000
    80001132:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001134:	05b2                	sll	a1,a1,0xc
    80001136:	8526                	mv	a0,s1
    80001138:	f3fff0ef          	jal	80001076 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000113c:	8526                	mv	a0,s1
    8000113e:	594000ef          	jal	800016d2 <proc_mapstacks>
}
    80001142:	8526                	mv	a0,s1
    80001144:	60e2                	ld	ra,24(sp)
    80001146:	6442                	ld	s0,16(sp)
    80001148:	64a2                	ld	s1,8(sp)
    8000114a:	6902                	ld	s2,0(sp)
    8000114c:	6105                	add	sp,sp,32
    8000114e:	8082                	ret

0000000080001150 <kvminit>:
{
    80001150:	1141                	add	sp,sp,-16
    80001152:	e406                	sd	ra,8(sp)
    80001154:	e022                	sd	s0,0(sp)
    80001156:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001158:	f47ff0ef          	jal	8000109e <kvmmake>
    8000115c:	00007797          	auipc	a5,0x7
    80001160:	90a7ba23          	sd	a0,-1772(a5) # 80007a70 <kernel_pagetable>
}
    80001164:	60a2                	ld	ra,8(sp)
    80001166:	6402                	ld	s0,0(sp)
    80001168:	0141                	add	sp,sp,16
    8000116a:	8082                	ret

000000008000116c <uvmunmap>:
/* Remove npages of mappings starting from va. va must be */
/* page-aligned. The mappings must exist. */
/* Optionally free the physical memory. */
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000116c:	715d                	add	sp,sp,-80
    8000116e:	e486                	sd	ra,72(sp)
    80001170:	e0a2                	sd	s0,64(sp)
    80001172:	fc26                	sd	s1,56(sp)
    80001174:	f84a                	sd	s2,48(sp)
    80001176:	f44e                	sd	s3,40(sp)
    80001178:	f052                	sd	s4,32(sp)
    8000117a:	ec56                	sd	s5,24(sp)
    8000117c:	e85a                	sd	s6,16(sp)
    8000117e:	e45e                	sd	s7,8(sp)
    80001180:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001182:	03459793          	sll	a5,a1,0x34
    80001186:	e795                	bnez	a5,800011b2 <uvmunmap+0x46>
    80001188:	8a2a                	mv	s4,a0
    8000118a:	892e                	mv	s2,a1
    8000118c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000118e:	0632                	sll	a2,a2,0xc
    80001190:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001194:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001196:	6b05                	lui	s6,0x1
    80001198:	0535ea63          	bltu	a1,s3,800011ec <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000119c:	60a6                	ld	ra,72(sp)
    8000119e:	6406                	ld	s0,64(sp)
    800011a0:	74e2                	ld	s1,56(sp)
    800011a2:	7942                	ld	s2,48(sp)
    800011a4:	79a2                	ld	s3,40(sp)
    800011a6:	7a02                	ld	s4,32(sp)
    800011a8:	6ae2                	ld	s5,24(sp)
    800011aa:	6b42                	ld	s6,16(sp)
    800011ac:	6ba2                	ld	s7,8(sp)
    800011ae:	6161                	add	sp,sp,80
    800011b0:	8082                	ret
    panic("uvmunmap: not aligned");
    800011b2:	00006517          	auipc	a0,0x6
    800011b6:	f8650513          	add	a0,a0,-122 # 80007138 <digits+0x100>
    800011ba:	da4ff0ef          	jal	8000075e <panic>
      panic("uvmunmap: walk");
    800011be:	00006517          	auipc	a0,0x6
    800011c2:	f9250513          	add	a0,a0,-110 # 80007150 <digits+0x118>
    800011c6:	d98ff0ef          	jal	8000075e <panic>
      panic("uvmunmap: not mapped");
    800011ca:	00006517          	auipc	a0,0x6
    800011ce:	f9650513          	add	a0,a0,-106 # 80007160 <digits+0x128>
    800011d2:	d8cff0ef          	jal	8000075e <panic>
      panic("uvmunmap: not a leaf");
    800011d6:	00006517          	auipc	a0,0x6
    800011da:	fa250513          	add	a0,a0,-94 # 80007178 <digits+0x140>
    800011de:	d80ff0ef          	jal	8000075e <panic>
    *pte = 0;
    800011e2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e6:	995a                	add	s2,s2,s6
    800011e8:	fb397ae3          	bgeu	s2,s3,8000119c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800011ec:	4601                	li	a2,0
    800011ee:	85ca                	mv	a1,s2
    800011f0:	8552                	mv	a0,s4
    800011f2:	cfdff0ef          	jal	80000eee <walk>
    800011f6:	84aa                	mv	s1,a0
    800011f8:	d179                	beqz	a0,800011be <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800011fa:	6108                	ld	a0,0(a0)
    800011fc:	00157793          	and	a5,a0,1
    80001200:	d7e9                	beqz	a5,800011ca <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001202:	3ff57793          	and	a5,a0,1023
    80001206:	fd7788e3          	beq	a5,s7,800011d6 <uvmunmap+0x6a>
    if(do_free){
    8000120a:	fc0a8ce3          	beqz	s5,800011e2 <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    8000120e:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001210:	0532                	sll	a0,a0,0xc
    80001212:	fdcff0ef          	jal	800009ee <kfree>
    80001216:	b7f1                	j	800011e2 <uvmunmap+0x76>

0000000080001218 <uvmcreate>:

/* create an empty user page table. */
/* returns 0 if out of memory. */
pagetable_t
uvmcreate()
{
    80001218:	1101                	add	sp,sp,-32
    8000121a:	ec06                	sd	ra,24(sp)
    8000121c:	e822                	sd	s0,16(sp)
    8000121e:	e426                	sd	s1,8(sp)
    80001220:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001222:	8afff0ef          	jal	80000ad0 <kalloc>
    80001226:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001228:	c509                	beqz	a0,80001232 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000122a:	6605                	lui	a2,0x1
    8000122c:	4581                	li	a1,0
    8000122e:	a47ff0ef          	jal	80000c74 <memset>
  return pagetable;
}
    80001232:	8526                	mv	a0,s1
    80001234:	60e2                	ld	ra,24(sp)
    80001236:	6442                	ld	s0,16(sp)
    80001238:	64a2                	ld	s1,8(sp)
    8000123a:	6105                	add	sp,sp,32
    8000123c:	8082                	ret

000000008000123e <uvmfirst>:
/* Load the user initcode into address 0 of pagetable, */
/* for the very first process. */
/* sz must be less than a page. */
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000123e:	7179                	add	sp,sp,-48
    80001240:	f406                	sd	ra,40(sp)
    80001242:	f022                	sd	s0,32(sp)
    80001244:	ec26                	sd	s1,24(sp)
    80001246:	e84a                	sd	s2,16(sp)
    80001248:	e44e                	sd	s3,8(sp)
    8000124a:	e052                	sd	s4,0(sp)
    8000124c:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000124e:	6785                	lui	a5,0x1
    80001250:	04f67063          	bgeu	a2,a5,80001290 <uvmfirst+0x52>
    80001254:	8a2a                	mv	s4,a0
    80001256:	89ae                	mv	s3,a1
    80001258:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000125a:	877ff0ef          	jal	80000ad0 <kalloc>
    8000125e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001260:	6605                	lui	a2,0x1
    80001262:	4581                	li	a1,0
    80001264:	a11ff0ef          	jal	80000c74 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001268:	4779                	li	a4,30
    8000126a:	86ca                	mv	a3,s2
    8000126c:	6605                	lui	a2,0x1
    8000126e:	4581                	li	a1,0
    80001270:	8552                	mv	a0,s4
    80001272:	d55ff0ef          	jal	80000fc6 <mappages>
  memmove(mem, src, sz);
    80001276:	8626                	mv	a2,s1
    80001278:	85ce                	mv	a1,s3
    8000127a:	854a                	mv	a0,s2
    8000127c:	a55ff0ef          	jal	80000cd0 <memmove>
}
    80001280:	70a2                	ld	ra,40(sp)
    80001282:	7402                	ld	s0,32(sp)
    80001284:	64e2                	ld	s1,24(sp)
    80001286:	6942                	ld	s2,16(sp)
    80001288:	69a2                	ld	s3,8(sp)
    8000128a:	6a02                	ld	s4,0(sp)
    8000128c:	6145                	add	sp,sp,48
    8000128e:	8082                	ret
    panic("uvmfirst: more than a page");
    80001290:	00006517          	auipc	a0,0x6
    80001294:	f0050513          	add	a0,a0,-256 # 80007190 <digits+0x158>
    80001298:	cc6ff0ef          	jal	8000075e <panic>

000000008000129c <uvmdealloc>:
/* newsz.  oldsz and newsz need not be page-aligned, nor does newsz */
/* need to be less than oldsz.  oldsz can be larger than the actual */
/* process size.  Returns the new process size. */
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000129c:	1101                	add	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012a6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012a8:	00b67d63          	bgeu	a2,a1,800012c2 <uvmdealloc+0x26>
    800012ac:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012ae:	6785                	lui	a5,0x1
    800012b0:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012b2:	00f60733          	add	a4,a2,a5
    800012b6:	76fd                	lui	a3,0xfffff
    800012b8:	8f75                	and	a4,a4,a3
    800012ba:	97ae                	add	a5,a5,a1
    800012bc:	8ff5                	and	a5,a5,a3
    800012be:	00f76863          	bltu	a4,a5,800012ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012c2:	8526                	mv	a0,s1
    800012c4:	60e2                	ld	ra,24(sp)
    800012c6:	6442                	ld	s0,16(sp)
    800012c8:	64a2                	ld	s1,8(sp)
    800012ca:	6105                	add	sp,sp,32
    800012cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ce:	8f99                	sub	a5,a5,a4
    800012d0:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012d2:	4685                	li	a3,1
    800012d4:	0007861b          	sext.w	a2,a5
    800012d8:	85ba                	mv	a1,a4
    800012da:	e93ff0ef          	jal	8000116c <uvmunmap>
    800012de:	b7d5                	j	800012c2 <uvmdealloc+0x26>

00000000800012e0 <uvmalloc>:
  if(newsz < oldsz)
    800012e0:	08b66963          	bltu	a2,a1,80001372 <uvmalloc+0x92>
{
    800012e4:	7139                	add	sp,sp,-64
    800012e6:	fc06                	sd	ra,56(sp)
    800012e8:	f822                	sd	s0,48(sp)
    800012ea:	f426                	sd	s1,40(sp)
    800012ec:	f04a                	sd	s2,32(sp)
    800012ee:	ec4e                	sd	s3,24(sp)
    800012f0:	e852                	sd	s4,16(sp)
    800012f2:	e456                	sd	s5,8(sp)
    800012f4:	e05a                	sd	s6,0(sp)
    800012f6:	0080                	add	s0,sp,64
    800012f8:	8aaa                	mv	s5,a0
    800012fa:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012fc:	6785                	lui	a5,0x1
    800012fe:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001300:	95be                	add	a1,a1,a5
    80001302:	77fd                	lui	a5,0xfffff
    80001304:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001308:	06c9f763          	bgeu	s3,a2,80001376 <uvmalloc+0x96>
    8000130c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000130e:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80001312:	fbeff0ef          	jal	80000ad0 <kalloc>
    80001316:	84aa                	mv	s1,a0
    if(mem == 0){
    80001318:	c11d                	beqz	a0,8000133e <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    8000131a:	6605                	lui	a2,0x1
    8000131c:	4581                	li	a1,0
    8000131e:	957ff0ef          	jal	80000c74 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001322:	875a                	mv	a4,s6
    80001324:	86a6                	mv	a3,s1
    80001326:	6605                	lui	a2,0x1
    80001328:	85ca                	mv	a1,s2
    8000132a:	8556                	mv	a0,s5
    8000132c:	c9bff0ef          	jal	80000fc6 <mappages>
    80001330:	e51d                	bnez	a0,8000135e <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001332:	6785                	lui	a5,0x1
    80001334:	993e                	add	s2,s2,a5
    80001336:	fd496ee3          	bltu	s2,s4,80001312 <uvmalloc+0x32>
  return newsz;
    8000133a:	8552                	mv	a0,s4
    8000133c:	a039                	j	8000134a <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    8000133e:	864e                	mv	a2,s3
    80001340:	85ca                	mv	a1,s2
    80001342:	8556                	mv	a0,s5
    80001344:	f59ff0ef          	jal	8000129c <uvmdealloc>
      return 0;
    80001348:	4501                	li	a0,0
}
    8000134a:	70e2                	ld	ra,56(sp)
    8000134c:	7442                	ld	s0,48(sp)
    8000134e:	74a2                	ld	s1,40(sp)
    80001350:	7902                	ld	s2,32(sp)
    80001352:	69e2                	ld	s3,24(sp)
    80001354:	6a42                	ld	s4,16(sp)
    80001356:	6aa2                	ld	s5,8(sp)
    80001358:	6b02                	ld	s6,0(sp)
    8000135a:	6121                	add	sp,sp,64
    8000135c:	8082                	ret
      kfree(mem);
    8000135e:	8526                	mv	a0,s1
    80001360:	e8eff0ef          	jal	800009ee <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001364:	864e                	mv	a2,s3
    80001366:	85ca                	mv	a1,s2
    80001368:	8556                	mv	a0,s5
    8000136a:	f33ff0ef          	jal	8000129c <uvmdealloc>
      return 0;
    8000136e:	4501                	li	a0,0
    80001370:	bfe9                	j	8000134a <uvmalloc+0x6a>
    return oldsz;
    80001372:	852e                	mv	a0,a1
}
    80001374:	8082                	ret
  return newsz;
    80001376:	8532                	mv	a0,a2
    80001378:	bfc9                	j	8000134a <uvmalloc+0x6a>

000000008000137a <freewalk>:

/* Recursively free page-table pages. */
/* All leaf mappings must already have been removed. */
void
freewalk(pagetable_t pagetable)
{
    8000137a:	7179                	add	sp,sp,-48
    8000137c:	f406                	sd	ra,40(sp)
    8000137e:	f022                	sd	s0,32(sp)
    80001380:	ec26                	sd	s1,24(sp)
    80001382:	e84a                	sd	s2,16(sp)
    80001384:	e44e                	sd	s3,8(sp)
    80001386:	e052                	sd	s4,0(sp)
    80001388:	1800                	add	s0,sp,48
    8000138a:	8a2a                	mv	s4,a0
  /* there are 2^9 = 512 PTEs in a page table. */
  for(int i = 0; i < 512; i++){
    8000138c:	84aa                	mv	s1,a0
    8000138e:	6905                	lui	s2,0x1
    80001390:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001392:	4985                	li	s3,1
    80001394:	a819                	j	800013aa <freewalk+0x30>
      /* this PTE points to a lower-level page table. */
      uint64 child = PTE2PA(pte);
    80001396:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001398:	00c79513          	sll	a0,a5,0xc
    8000139c:	fdfff0ef          	jal	8000137a <freewalk>
      pagetable[i] = 0;
    800013a0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800013a4:	04a1                	add	s1,s1,8
    800013a6:	01248f63          	beq	s1,s2,800013c4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800013aa:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013ac:	00f7f713          	and	a4,a5,15
    800013b0:	ff3703e3          	beq	a4,s3,80001396 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013b4:	8b85                	and	a5,a5,1
    800013b6:	d7fd                	beqz	a5,800013a4 <freewalk+0x2a>
      panic("freewalk: leaf");
    800013b8:	00006517          	auipc	a0,0x6
    800013bc:	df850513          	add	a0,a0,-520 # 800071b0 <digits+0x178>
    800013c0:	b9eff0ef          	jal	8000075e <panic>
    }
  }
  kfree((void*)pagetable);
    800013c4:	8552                	mv	a0,s4
    800013c6:	e28ff0ef          	jal	800009ee <kfree>
}
    800013ca:	70a2                	ld	ra,40(sp)
    800013cc:	7402                	ld	s0,32(sp)
    800013ce:	64e2                	ld	s1,24(sp)
    800013d0:	6942                	ld	s2,16(sp)
    800013d2:	69a2                	ld	s3,8(sp)
    800013d4:	6a02                	ld	s4,0(sp)
    800013d6:	6145                	add	sp,sp,48
    800013d8:	8082                	ret

00000000800013da <uvmfree>:

/* Free user memory pages, */
/* then free page-table pages. */
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013da:	1101                	add	sp,sp,-32
    800013dc:	ec06                	sd	ra,24(sp)
    800013de:	e822                	sd	s0,16(sp)
    800013e0:	e426                	sd	s1,8(sp)
    800013e2:	1000                	add	s0,sp,32
    800013e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800013e6:	e989                	bnez	a1,800013f8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800013e8:	8526                	mv	a0,s1
    800013ea:	f91ff0ef          	jal	8000137a <freewalk>
}
    800013ee:	60e2                	ld	ra,24(sp)
    800013f0:	6442                	ld	s0,16(sp)
    800013f2:	64a2                	ld	s1,8(sp)
    800013f4:	6105                	add	sp,sp,32
    800013f6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013f8:	6785                	lui	a5,0x1
    800013fa:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013fc:	95be                	add	a1,a1,a5
    800013fe:	4685                	li	a3,1
    80001400:	00c5d613          	srl	a2,a1,0xc
    80001404:	4581                	li	a1,0
    80001406:	d67ff0ef          	jal	8000116c <uvmunmap>
    8000140a:	bff9                	j	800013e8 <uvmfree+0xe>

000000008000140c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000140c:	c65d                	beqz	a2,800014ba <uvmcopy+0xae>
{
    8000140e:	715d                	add	sp,sp,-80
    80001410:	e486                	sd	ra,72(sp)
    80001412:	e0a2                	sd	s0,64(sp)
    80001414:	fc26                	sd	s1,56(sp)
    80001416:	f84a                	sd	s2,48(sp)
    80001418:	f44e                	sd	s3,40(sp)
    8000141a:	f052                	sd	s4,32(sp)
    8000141c:	ec56                	sd	s5,24(sp)
    8000141e:	e85a                	sd	s6,16(sp)
    80001420:	e45e                	sd	s7,8(sp)
    80001422:	0880                	add	s0,sp,80
    80001424:	8b2a                	mv	s6,a0
    80001426:	8aae                	mv	s5,a1
    80001428:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000142a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000142c:	4601                	li	a2,0
    8000142e:	85ce                	mv	a1,s3
    80001430:	855a                	mv	a0,s6
    80001432:	abdff0ef          	jal	80000eee <walk>
    80001436:	c121                	beqz	a0,80001476 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001438:	6118                	ld	a4,0(a0)
    8000143a:	00177793          	and	a5,a4,1
    8000143e:	c3b1                	beqz	a5,80001482 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001440:	00a75593          	srl	a1,a4,0xa
    80001444:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001448:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000144c:	e84ff0ef          	jal	80000ad0 <kalloc>
    80001450:	892a                	mv	s2,a0
    80001452:	c129                	beqz	a0,80001494 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001454:	6605                	lui	a2,0x1
    80001456:	85de                	mv	a1,s7
    80001458:	879ff0ef          	jal	80000cd0 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000145c:	8726                	mv	a4,s1
    8000145e:	86ca                	mv	a3,s2
    80001460:	6605                	lui	a2,0x1
    80001462:	85ce                	mv	a1,s3
    80001464:	8556                	mv	a0,s5
    80001466:	b61ff0ef          	jal	80000fc6 <mappages>
    8000146a:	e115                	bnez	a0,8000148e <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000146c:	6785                	lui	a5,0x1
    8000146e:	99be                	add	s3,s3,a5
    80001470:	fb49eee3          	bltu	s3,s4,8000142c <uvmcopy+0x20>
    80001474:	a805                	j	800014a4 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001476:	00006517          	auipc	a0,0x6
    8000147a:	d4a50513          	add	a0,a0,-694 # 800071c0 <digits+0x188>
    8000147e:	ae0ff0ef          	jal	8000075e <panic>
      panic("uvmcopy: page not present");
    80001482:	00006517          	auipc	a0,0x6
    80001486:	d5e50513          	add	a0,a0,-674 # 800071e0 <digits+0x1a8>
    8000148a:	ad4ff0ef          	jal	8000075e <panic>
      kfree(mem);
    8000148e:	854a                	mv	a0,s2
    80001490:	d5eff0ef          	jal	800009ee <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001494:	4685                	li	a3,1
    80001496:	00c9d613          	srl	a2,s3,0xc
    8000149a:	4581                	li	a1,0
    8000149c:	8556                	mv	a0,s5
    8000149e:	ccfff0ef          	jal	8000116c <uvmunmap>
  return -1;
    800014a2:	557d                	li	a0,-1
}
    800014a4:	60a6                	ld	ra,72(sp)
    800014a6:	6406                	ld	s0,64(sp)
    800014a8:	74e2                	ld	s1,56(sp)
    800014aa:	7942                	ld	s2,48(sp)
    800014ac:	79a2                	ld	s3,40(sp)
    800014ae:	7a02                	ld	s4,32(sp)
    800014b0:	6ae2                	ld	s5,24(sp)
    800014b2:	6b42                	ld	s6,16(sp)
    800014b4:	6ba2                	ld	s7,8(sp)
    800014b6:	6161                	add	sp,sp,80
    800014b8:	8082                	ret
  return 0;
    800014ba:	4501                	li	a0,0
}
    800014bc:	8082                	ret

00000000800014be <uvmclear>:

/* mark a PTE invalid for user access. */
/* used by exec for the user stack guard page. */
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014be:	1141                	add	sp,sp,-16
    800014c0:	e406                	sd	ra,8(sp)
    800014c2:	e022                	sd	s0,0(sp)
    800014c4:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014c6:	4601                	li	a2,0
    800014c8:	a27ff0ef          	jal	80000eee <walk>
  if(pte == 0)
    800014cc:	c901                	beqz	a0,800014dc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014ce:	611c                	ld	a5,0(a0)
    800014d0:	9bbd                	and	a5,a5,-17
    800014d2:	e11c                	sd	a5,0(a0)
}
    800014d4:	60a2                	ld	ra,8(sp)
    800014d6:	6402                	ld	s0,0(sp)
    800014d8:	0141                	add	sp,sp,16
    800014da:	8082                	ret
    panic("uvmclear");
    800014dc:	00006517          	auipc	a0,0x6
    800014e0:	d2450513          	add	a0,a0,-732 # 80007200 <digits+0x1c8>
    800014e4:	a7aff0ef          	jal	8000075e <panic>

00000000800014e8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800014e8:	c6c9                	beqz	a3,80001572 <copyout+0x8a>
{
    800014ea:	711d                	add	sp,sp,-96
    800014ec:	ec86                	sd	ra,88(sp)
    800014ee:	e8a2                	sd	s0,80(sp)
    800014f0:	e4a6                	sd	s1,72(sp)
    800014f2:	e0ca                	sd	s2,64(sp)
    800014f4:	fc4e                	sd	s3,56(sp)
    800014f6:	f852                	sd	s4,48(sp)
    800014f8:	f456                	sd	s5,40(sp)
    800014fa:	f05a                	sd	s6,32(sp)
    800014fc:	ec5e                	sd	s7,24(sp)
    800014fe:	e862                	sd	s8,16(sp)
    80001500:	e466                	sd	s9,8(sp)
    80001502:	e06a                	sd	s10,0(sp)
    80001504:	1080                	add	s0,sp,96
    80001506:	8baa                	mv	s7,a0
    80001508:	8aae                	mv	s5,a1
    8000150a:	8b32                	mv	s6,a2
    8000150c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000150e:	74fd                	lui	s1,0xfffff
    80001510:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001512:	57fd                	li	a5,-1
    80001514:	83e9                	srl	a5,a5,0x1a
    80001516:	0697e063          	bltu	a5,s1,80001576 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8000151a:	4cd5                	li	s9,21
    8000151c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    8000151e:	8c3e                	mv	s8,a5
    80001520:	a025                	j	80001548 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001522:	83a9                	srl	a5,a5,0xa
    80001524:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001526:	409a8533          	sub	a0,s5,s1
    8000152a:	0009061b          	sext.w	a2,s2
    8000152e:	85da                	mv	a1,s6
    80001530:	953e                	add	a0,a0,a5
    80001532:	f9eff0ef          	jal	80000cd0 <memmove>

    len -= n;
    80001536:	412989b3          	sub	s3,s3,s2
    src += n;
    8000153a:	9b4a                	add	s6,s6,s2
  while(len > 0){
    8000153c:	02098963          	beqz	s3,8000156e <copyout+0x86>
    if(va0 >= MAXVA)
    80001540:	034c6d63          	bltu	s8,s4,8000157a <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80001544:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80001546:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001548:	4601                	li	a2,0
    8000154a:	85a6                	mv	a1,s1
    8000154c:	855e                	mv	a0,s7
    8000154e:	9a1ff0ef          	jal	80000eee <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001552:	c515                	beqz	a0,8000157e <copyout+0x96>
    80001554:	611c                	ld	a5,0(a0)
    80001556:	0157f713          	and	a4,a5,21
    8000155a:	05971163          	bne	a4,s9,8000159c <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    8000155e:	01a48a33          	add	s4,s1,s10
    80001562:	415a0933          	sub	s2,s4,s5
    80001566:	fb29fee3          	bgeu	s3,s2,80001522 <copyout+0x3a>
    8000156a:	894e                	mv	s2,s3
    8000156c:	bf5d                	j	80001522 <copyout+0x3a>
  }
  return 0;
    8000156e:	4501                	li	a0,0
    80001570:	a801                	j	80001580 <copyout+0x98>
    80001572:	4501                	li	a0,0
}
    80001574:	8082                	ret
      return -1;
    80001576:	557d                	li	a0,-1
    80001578:	a021                	j	80001580 <copyout+0x98>
    8000157a:	557d                	li	a0,-1
    8000157c:	a011                	j	80001580 <copyout+0x98>
      return -1;
    8000157e:	557d                	li	a0,-1
}
    80001580:	60e6                	ld	ra,88(sp)
    80001582:	6446                	ld	s0,80(sp)
    80001584:	64a6                	ld	s1,72(sp)
    80001586:	6906                	ld	s2,64(sp)
    80001588:	79e2                	ld	s3,56(sp)
    8000158a:	7a42                	ld	s4,48(sp)
    8000158c:	7aa2                	ld	s5,40(sp)
    8000158e:	7b02                	ld	s6,32(sp)
    80001590:	6be2                	ld	s7,24(sp)
    80001592:	6c42                	ld	s8,16(sp)
    80001594:	6ca2                	ld	s9,8(sp)
    80001596:	6d02                	ld	s10,0(sp)
    80001598:	6125                	add	sp,sp,96
    8000159a:	8082                	ret
      return -1;
    8000159c:	557d                	li	a0,-1
    8000159e:	b7cd                	j	80001580 <copyout+0x98>

00000000800015a0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015a0:	c6a5                	beqz	a3,80001608 <copyin+0x68>
{
    800015a2:	715d                	add	sp,sp,-80
    800015a4:	e486                	sd	ra,72(sp)
    800015a6:	e0a2                	sd	s0,64(sp)
    800015a8:	fc26                	sd	s1,56(sp)
    800015aa:	f84a                	sd	s2,48(sp)
    800015ac:	f44e                	sd	s3,40(sp)
    800015ae:	f052                	sd	s4,32(sp)
    800015b0:	ec56                	sd	s5,24(sp)
    800015b2:	e85a                	sd	s6,16(sp)
    800015b4:	e45e                	sd	s7,8(sp)
    800015b6:	e062                	sd	s8,0(sp)
    800015b8:	0880                	add	s0,sp,80
    800015ba:	8b2a                	mv	s6,a0
    800015bc:	8a2e                	mv	s4,a1
    800015be:	8c32                	mv	s8,a2
    800015c0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015c2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015c4:	6a85                	lui	s5,0x1
    800015c6:	a00d                	j	800015e8 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015c8:	018505b3          	add	a1,a0,s8
    800015cc:	0004861b          	sext.w	a2,s1
    800015d0:	412585b3          	sub	a1,a1,s2
    800015d4:	8552                	mv	a0,s4
    800015d6:	efaff0ef          	jal	80000cd0 <memmove>

    len -= n;
    800015da:	409989b3          	sub	s3,s3,s1
    dst += n;
    800015de:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800015e0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015e4:	02098063          	beqz	s3,80001604 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800015e8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800015ec:	85ca                	mv	a1,s2
    800015ee:	855a                	mv	a0,s6
    800015f0:	999ff0ef          	jal	80000f88 <walkaddr>
    if(pa0 == 0)
    800015f4:	cd01                	beqz	a0,8000160c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800015f6:	418904b3          	sub	s1,s2,s8
    800015fa:	94d6                	add	s1,s1,s5
    800015fc:	fc99f6e3          	bgeu	s3,s1,800015c8 <copyin+0x28>
    80001600:	84ce                	mv	s1,s3
    80001602:	b7d9                	j	800015c8 <copyin+0x28>
  }
  return 0;
    80001604:	4501                	li	a0,0
    80001606:	a021                	j	8000160e <copyin+0x6e>
    80001608:	4501                	li	a0,0
}
    8000160a:	8082                	ret
      return -1;
    8000160c:	557d                	li	a0,-1
}
    8000160e:	60a6                	ld	ra,72(sp)
    80001610:	6406                	ld	s0,64(sp)
    80001612:	74e2                	ld	s1,56(sp)
    80001614:	7942                	ld	s2,48(sp)
    80001616:	79a2                	ld	s3,40(sp)
    80001618:	7a02                	ld	s4,32(sp)
    8000161a:	6ae2                	ld	s5,24(sp)
    8000161c:	6b42                	ld	s6,16(sp)
    8000161e:	6ba2                	ld	s7,8(sp)
    80001620:	6c02                	ld	s8,0(sp)
    80001622:	6161                	add	sp,sp,80
    80001624:	8082                	ret

0000000080001626 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001626:	c2cd                	beqz	a3,800016c8 <copyinstr+0xa2>
{
    80001628:	715d                	add	sp,sp,-80
    8000162a:	e486                	sd	ra,72(sp)
    8000162c:	e0a2                	sd	s0,64(sp)
    8000162e:	fc26                	sd	s1,56(sp)
    80001630:	f84a                	sd	s2,48(sp)
    80001632:	f44e                	sd	s3,40(sp)
    80001634:	f052                	sd	s4,32(sp)
    80001636:	ec56                	sd	s5,24(sp)
    80001638:	e85a                	sd	s6,16(sp)
    8000163a:	e45e                	sd	s7,8(sp)
    8000163c:	0880                	add	s0,sp,80
    8000163e:	8a2a                	mv	s4,a0
    80001640:	8b2e                	mv	s6,a1
    80001642:	8bb2                	mv	s7,a2
    80001644:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001646:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001648:	6985                	lui	s3,0x1
    8000164a:	a02d                	j	80001674 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000164c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001650:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001652:	37fd                	addw	a5,a5,-1
    80001654:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001658:	60a6                	ld	ra,72(sp)
    8000165a:	6406                	ld	s0,64(sp)
    8000165c:	74e2                	ld	s1,56(sp)
    8000165e:	7942                	ld	s2,48(sp)
    80001660:	79a2                	ld	s3,40(sp)
    80001662:	7a02                	ld	s4,32(sp)
    80001664:	6ae2                	ld	s5,24(sp)
    80001666:	6b42                	ld	s6,16(sp)
    80001668:	6ba2                	ld	s7,8(sp)
    8000166a:	6161                	add	sp,sp,80
    8000166c:	8082                	ret
    srcva = va0 + PGSIZE;
    8000166e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001672:	c4b9                	beqz	s1,800016c0 <copyinstr+0x9a>
    va0 = PGROUNDDOWN(srcva);
    80001674:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001678:	85ca                	mv	a1,s2
    8000167a:	8552                	mv	a0,s4
    8000167c:	90dff0ef          	jal	80000f88 <walkaddr>
    if(pa0 == 0)
    80001680:	c131                	beqz	a0,800016c4 <copyinstr+0x9e>
    n = PGSIZE - (srcva - va0);
    80001682:	417906b3          	sub	a3,s2,s7
    80001686:	96ce                	add	a3,a3,s3
    80001688:	00d4f363          	bgeu	s1,a3,8000168e <copyinstr+0x68>
    8000168c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000168e:	955e                	add	a0,a0,s7
    80001690:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001694:	dee9                	beqz	a3,8000166e <copyinstr+0x48>
    80001696:	87da                	mv	a5,s6
    80001698:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000169a:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000169e:	96da                	add	a3,a3,s6
    800016a0:	85be                	mv	a1,a5
      if(*p == '\0'){
    800016a2:	00f60733          	add	a4,a2,a5
    800016a6:	00074703          	lbu	a4,0(a4)
    800016aa:	d34d                	beqz	a4,8000164c <copyinstr+0x26>
        *dst = *p;
    800016ac:	00e78023          	sb	a4,0(a5)
      dst++;
    800016b0:	0785                	add	a5,a5,1
    while(n > 0){
    800016b2:	fed797e3          	bne	a5,a3,800016a0 <copyinstr+0x7a>
    800016b6:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffde03f>
    800016b8:	94c2                	add	s1,s1,a6
      --max;
    800016ba:	8c8d                	sub	s1,s1,a1
      dst++;
    800016bc:	8b3e                	mv	s6,a5
    800016be:	bf45                	j	8000166e <copyinstr+0x48>
    800016c0:	4781                	li	a5,0
    800016c2:	bf41                	j	80001652 <copyinstr+0x2c>
      return -1;
    800016c4:	557d                	li	a0,-1
    800016c6:	bf49                	j	80001658 <copyinstr+0x32>
  int got_null = 0;
    800016c8:	4781                	li	a5,0
  if(got_null){
    800016ca:	37fd                	addw	a5,a5,-1
    800016cc:	0007851b          	sext.w	a0,a5
}
    800016d0:	8082                	ret

00000000800016d2 <proc_mapstacks>:
/* Allocate a page for each process's kernel stack. */
/* Map it high in memory, followed by an invalid */
/* guard page. */
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016d2:	7139                	add	sp,sp,-64
    800016d4:	fc06                	sd	ra,56(sp)
    800016d6:	f822                	sd	s0,48(sp)
    800016d8:	f426                	sd	s1,40(sp)
    800016da:	f04a                	sd	s2,32(sp)
    800016dc:	ec4e                	sd	s3,24(sp)
    800016de:	e852                	sd	s4,16(sp)
    800016e0:	e456                	sd	s5,8(sp)
    800016e2:	e05a                	sd	s6,0(sp)
    800016e4:	0080                	add	s0,sp,64
    800016e6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e8:	0000f497          	auipc	s1,0xf
    800016ec:	8f848493          	add	s1,s1,-1800 # 8000ffe0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800016f0:	8b26                	mv	s6,s1
    800016f2:	00006a97          	auipc	s5,0x6
    800016f6:	90ea8a93          	add	s5,s5,-1778 # 80007000 <etext>
    800016fa:	04000937          	lui	s2,0x4000
    800016fe:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001700:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	00014a17          	auipc	s4,0x14
    80001706:	4dea0a13          	add	s4,s4,1246 # 80015be0 <tickslock>
    char *pa = kalloc();
    8000170a:	bc6ff0ef          	jal	80000ad0 <kalloc>
    8000170e:	862a                	mv	a2,a0
    if(pa == 0)
    80001710:	c121                	beqz	a0,80001750 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80001712:	416485b3          	sub	a1,s1,s6
    80001716:	8591                	sra	a1,a1,0x4
    80001718:	000ab783          	ld	a5,0(s5)
    8000171c:	02f585b3          	mul	a1,a1,a5
    80001720:	2585                	addw	a1,a1,1
    80001722:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001726:	4719                	li	a4,6
    80001728:	6685                	lui	a3,0x1
    8000172a:	40b905b3          	sub	a1,s2,a1
    8000172e:	854e                	mv	a0,s3
    80001730:	947ff0ef          	jal	80001076 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001734:	17048493          	add	s1,s1,368
    80001738:	fd4499e3          	bne	s1,s4,8000170a <proc_mapstacks+0x38>
  }
}
    8000173c:	70e2                	ld	ra,56(sp)
    8000173e:	7442                	ld	s0,48(sp)
    80001740:	74a2                	ld	s1,40(sp)
    80001742:	7902                	ld	s2,32(sp)
    80001744:	69e2                	ld	s3,24(sp)
    80001746:	6a42                	ld	s4,16(sp)
    80001748:	6aa2                	ld	s5,8(sp)
    8000174a:	6b02                	ld	s6,0(sp)
    8000174c:	6121                	add	sp,sp,64
    8000174e:	8082                	ret
      panic("kalloc");
    80001750:	00006517          	auipc	a0,0x6
    80001754:	ac050513          	add	a0,a0,-1344 # 80007210 <digits+0x1d8>
    80001758:	806ff0ef          	jal	8000075e <panic>

000000008000175c <procinit>:

/* initialize the proc table. */
void
procinit(void)
{
    8000175c:	7139                	add	sp,sp,-64
    8000175e:	fc06                	sd	ra,56(sp)
    80001760:	f822                	sd	s0,48(sp)
    80001762:	f426                	sd	s1,40(sp)
    80001764:	f04a                	sd	s2,32(sp)
    80001766:	ec4e                	sd	s3,24(sp)
    80001768:	e852                	sd	s4,16(sp)
    8000176a:	e456                	sd	s5,8(sp)
    8000176c:	e05a                	sd	s6,0(sp)
    8000176e:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001770:	00006597          	auipc	a1,0x6
    80001774:	aa858593          	add	a1,a1,-1368 # 80007218 <digits+0x1e0>
    80001778:	0000e517          	auipc	a0,0xe
    8000177c:	43850513          	add	a0,a0,1080 # 8000fbb0 <pid_lock>
    80001780:	ba0ff0ef          	jal	80000b20 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001784:	00006597          	auipc	a1,0x6
    80001788:	a9c58593          	add	a1,a1,-1380 # 80007220 <digits+0x1e8>
    8000178c:	0000e517          	auipc	a0,0xe
    80001790:	43c50513          	add	a0,a0,1084 # 8000fbc8 <wait_lock>
    80001794:	b8cff0ef          	jal	80000b20 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	0000f497          	auipc	s1,0xf
    8000179c:	84848493          	add	s1,s1,-1976 # 8000ffe0 <proc>
      initlock(&p->lock, "proc");
    800017a0:	00006b17          	auipc	s6,0x6
    800017a4:	a90b0b13          	add	s6,s6,-1392 # 80007230 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800017a8:	8aa6                	mv	s5,s1
    800017aa:	00006a17          	auipc	s4,0x6
    800017ae:	856a0a13          	add	s4,s4,-1962 # 80007000 <etext>
    800017b2:	04000937          	lui	s2,0x4000
    800017b6:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800017b8:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ba:	00014997          	auipc	s3,0x14
    800017be:	42698993          	add	s3,s3,1062 # 80015be0 <tickslock>
      initlock(&p->lock, "proc");
    800017c2:	85da                	mv	a1,s6
    800017c4:	8526                	mv	a0,s1
    800017c6:	b5aff0ef          	jal	80000b20 <initlock>
      p->state = UNUSED;
    800017ca:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017ce:	415487b3          	sub	a5,s1,s5
    800017d2:	8791                	sra	a5,a5,0x4
    800017d4:	000a3703          	ld	a4,0(s4)
    800017d8:	02e787b3          	mul	a5,a5,a4
    800017dc:	2785                	addw	a5,a5,1
    800017de:	00d7979b          	sllw	a5,a5,0xd
    800017e2:	40f907b3          	sub	a5,s2,a5
    800017e6:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e8:	17048493          	add	s1,s1,368
    800017ec:	fd349be3          	bne	s1,s3,800017c2 <procinit+0x66>
  }
}
    800017f0:	70e2                	ld	ra,56(sp)
    800017f2:	7442                	ld	s0,48(sp)
    800017f4:	74a2                	ld	s1,40(sp)
    800017f6:	7902                	ld	s2,32(sp)
    800017f8:	69e2                	ld	s3,24(sp)
    800017fa:	6a42                	ld	s4,16(sp)
    800017fc:	6aa2                	ld	s5,8(sp)
    800017fe:	6b02                	ld	s6,0(sp)
    80001800:	6121                	add	sp,sp,64
    80001802:	8082                	ret

0000000080001804 <cpuid>:
/* Must be called with interrupts disabled, */
/* to prevent race with process being moved */
/* to a different CPU. */
int
cpuid()
{
    80001804:	1141                	add	sp,sp,-16
    80001806:	e422                	sd	s0,8(sp)
    80001808:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000180a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000180c:	2501                	sext.w	a0,a0
    8000180e:	6422                	ld	s0,8(sp)
    80001810:	0141                	add	sp,sp,16
    80001812:	8082                	ret

0000000080001814 <mycpu>:

/* Return this CPU's cpu struct. */
/* Interrupts must be disabled. */
struct cpu*
mycpu(void)
{
    80001814:	1141                	add	sp,sp,-16
    80001816:	e422                	sd	s0,8(sp)
    80001818:	0800                	add	s0,sp,16
    8000181a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000181c:	2781                	sext.w	a5,a5
    8000181e:	079e                	sll	a5,a5,0x7
  return c;
}
    80001820:	0000e517          	auipc	a0,0xe
    80001824:	3c050513          	add	a0,a0,960 # 8000fbe0 <cpus>
    80001828:	953e                	add	a0,a0,a5
    8000182a:	6422                	ld	s0,8(sp)
    8000182c:	0141                	add	sp,sp,16
    8000182e:	8082                	ret

0000000080001830 <myproc>:

/* Return the current struct proc *, or zero if none. */
struct proc*
myproc(void)
{
    80001830:	1101                	add	sp,sp,-32
    80001832:	ec06                	sd	ra,24(sp)
    80001834:	e822                	sd	s0,16(sp)
    80001836:	e426                	sd	s1,8(sp)
    80001838:	1000                	add	s0,sp,32
  push_off();
    8000183a:	b26ff0ef          	jal	80000b60 <push_off>
    8000183e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001840:	2781                	sext.w	a5,a5
    80001842:	079e                	sll	a5,a5,0x7
    80001844:	0000e717          	auipc	a4,0xe
    80001848:	36c70713          	add	a4,a4,876 # 8000fbb0 <pid_lock>
    8000184c:	97ba                	add	a5,a5,a4
    8000184e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001850:	b94ff0ef          	jal	80000be4 <pop_off>
  return p;
}
    80001854:	8526                	mv	a0,s1
    80001856:	60e2                	ld	ra,24(sp)
    80001858:	6442                	ld	s0,16(sp)
    8000185a:	64a2                	ld	s1,8(sp)
    8000185c:	6105                	add	sp,sp,32
    8000185e:	8082                	ret

0000000080001860 <forkret>:

/* A fork child's very first scheduling by scheduler() */
/* will swtch to forkret. */
void
forkret(void)
{
    80001860:	1141                	add	sp,sp,-16
    80001862:	e406                	sd	ra,8(sp)
    80001864:	e022                	sd	s0,0(sp)
    80001866:	0800                	add	s0,sp,16
  static int first = 1;

  /* Still holding p->lock from scheduler. */
  release(&myproc()->lock);
    80001868:	fc9ff0ef          	jal	80001830 <myproc>
    8000186c:	bccff0ef          	jal	80000c38 <release>

  if (first) {
    80001870:	00006797          	auipc	a5,0x6
    80001874:	1907a783          	lw	a5,400(a5) # 80007a00 <first.1>
    80001878:	e799                	bnez	a5,80001886 <forkret+0x26>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    8000187a:	2c9000ef          	jal	80002342 <usertrapret>
}
    8000187e:	60a2                	ld	ra,8(sp)
    80001880:	6402                	ld	s0,0(sp)
    80001882:	0141                	add	sp,sp,16
    80001884:	8082                	ret
    fsinit(ROOTDEV);
    80001886:	4505                	li	a0,1
    80001888:	694010ef          	jal	80002f1c <fsinit>
    first = 0;
    8000188c:	00006797          	auipc	a5,0x6
    80001890:	1607aa23          	sw	zero,372(a5) # 80007a00 <first.1>
    __sync_synchronize();
    80001894:	0ff0000f          	fence
    80001898:	b7cd                	j	8000187a <forkret+0x1a>

000000008000189a <allocpid>:
{
    8000189a:	1101                	add	sp,sp,-32
    8000189c:	ec06                	sd	ra,24(sp)
    8000189e:	e822                	sd	s0,16(sp)
    800018a0:	e426                	sd	s1,8(sp)
    800018a2:	e04a                	sd	s2,0(sp)
    800018a4:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    800018a6:	0000e917          	auipc	s2,0xe
    800018aa:	30a90913          	add	s2,s2,778 # 8000fbb0 <pid_lock>
    800018ae:	854a                	mv	a0,s2
    800018b0:	af0ff0ef          	jal	80000ba0 <acquire>
  pid = nextpid;
    800018b4:	00006797          	auipc	a5,0x6
    800018b8:	15078793          	add	a5,a5,336 # 80007a04 <nextpid>
    800018bc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018be:	0014871b          	addw	a4,s1,1
    800018c2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018c4:	854a                	mv	a0,s2
    800018c6:	b72ff0ef          	jal	80000c38 <release>
}
    800018ca:	8526                	mv	a0,s1
    800018cc:	60e2                	ld	ra,24(sp)
    800018ce:	6442                	ld	s0,16(sp)
    800018d0:	64a2                	ld	s1,8(sp)
    800018d2:	6902                	ld	s2,0(sp)
    800018d4:	6105                	add	sp,sp,32
    800018d6:	8082                	ret

00000000800018d8 <proc_pagetable>:
{
    800018d8:	1101                	add	sp,sp,-32
    800018da:	ec06                	sd	ra,24(sp)
    800018dc:	e822                	sd	s0,16(sp)
    800018de:	e426                	sd	s1,8(sp)
    800018e0:	e04a                	sd	s2,0(sp)
    800018e2:	1000                	add	s0,sp,32
    800018e4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800018e6:	933ff0ef          	jal	80001218 <uvmcreate>
    800018ea:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800018ec:	cd05                	beqz	a0,80001924 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018ee:	4729                	li	a4,10
    800018f0:	00004697          	auipc	a3,0x4
    800018f4:	71068693          	add	a3,a3,1808 # 80006000 <_trampoline>
    800018f8:	6605                	lui	a2,0x1
    800018fa:	040005b7          	lui	a1,0x4000
    800018fe:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001900:	05b2                	sll	a1,a1,0xc
    80001902:	ec4ff0ef          	jal	80000fc6 <mappages>
    80001906:	02054663          	bltz	a0,80001932 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000190a:	4719                	li	a4,6
    8000190c:	06093683          	ld	a3,96(s2)
    80001910:	6605                	lui	a2,0x1
    80001912:	020005b7          	lui	a1,0x2000
    80001916:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001918:	05b6                	sll	a1,a1,0xd
    8000191a:	8526                	mv	a0,s1
    8000191c:	eaaff0ef          	jal	80000fc6 <mappages>
    80001920:	00054f63          	bltz	a0,8000193e <proc_pagetable+0x66>
}
    80001924:	8526                	mv	a0,s1
    80001926:	60e2                	ld	ra,24(sp)
    80001928:	6442                	ld	s0,16(sp)
    8000192a:	64a2                	ld	s1,8(sp)
    8000192c:	6902                	ld	s2,0(sp)
    8000192e:	6105                	add	sp,sp,32
    80001930:	8082                	ret
    uvmfree(pagetable, 0);
    80001932:	4581                	li	a1,0
    80001934:	8526                	mv	a0,s1
    80001936:	aa5ff0ef          	jal	800013da <uvmfree>
    return 0;
    8000193a:	4481                	li	s1,0
    8000193c:	b7e5                	j	80001924 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000193e:	4681                	li	a3,0
    80001940:	4605                	li	a2,1
    80001942:	040005b7          	lui	a1,0x4000
    80001946:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001948:	05b2                	sll	a1,a1,0xc
    8000194a:	8526                	mv	a0,s1
    8000194c:	821ff0ef          	jal	8000116c <uvmunmap>
    uvmfree(pagetable, 0);
    80001950:	4581                	li	a1,0
    80001952:	8526                	mv	a0,s1
    80001954:	a87ff0ef          	jal	800013da <uvmfree>
    return 0;
    80001958:	4481                	li	s1,0
    8000195a:	b7e9                	j	80001924 <proc_pagetable+0x4c>

000000008000195c <proc_freepagetable>:
{
    8000195c:	1101                	add	sp,sp,-32
    8000195e:	ec06                	sd	ra,24(sp)
    80001960:	e822                	sd	s0,16(sp)
    80001962:	e426                	sd	s1,8(sp)
    80001964:	e04a                	sd	s2,0(sp)
    80001966:	1000                	add	s0,sp,32
    80001968:	84aa                	mv	s1,a0
    8000196a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000196c:	4681                	li	a3,0
    8000196e:	4605                	li	a2,1
    80001970:	040005b7          	lui	a1,0x4000
    80001974:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001976:	05b2                	sll	a1,a1,0xc
    80001978:	ff4ff0ef          	jal	8000116c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000197c:	4681                	li	a3,0
    8000197e:	4605                	li	a2,1
    80001980:	020005b7          	lui	a1,0x2000
    80001984:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001986:	05b6                	sll	a1,a1,0xd
    80001988:	8526                	mv	a0,s1
    8000198a:	fe2ff0ef          	jal	8000116c <uvmunmap>
  uvmfree(pagetable, sz);
    8000198e:	85ca                	mv	a1,s2
    80001990:	8526                	mv	a0,s1
    80001992:	a49ff0ef          	jal	800013da <uvmfree>
}
    80001996:	60e2                	ld	ra,24(sp)
    80001998:	6442                	ld	s0,16(sp)
    8000199a:	64a2                	ld	s1,8(sp)
    8000199c:	6902                	ld	s2,0(sp)
    8000199e:	6105                	add	sp,sp,32
    800019a0:	8082                	ret

00000000800019a2 <freeproc>:
{
    800019a2:	1101                	add	sp,sp,-32
    800019a4:	ec06                	sd	ra,24(sp)
    800019a6:	e822                	sd	s0,16(sp)
    800019a8:	e426                	sd	s1,8(sp)
    800019aa:	1000                	add	s0,sp,32
    800019ac:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019ae:	7128                	ld	a0,96(a0)
    800019b0:	c119                	beqz	a0,800019b6 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019b2:	83cff0ef          	jal	800009ee <kfree>
  p->trapframe = 0;
    800019b6:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800019ba:	6ca8                	ld	a0,88(s1)
    800019bc:	c501                	beqz	a0,800019c4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019be:	68ac                	ld	a1,80(s1)
    800019c0:	f9dff0ef          	jal	8000195c <proc_freepagetable>
  p->pagetable = 0;
    800019c4:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    800019c8:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    800019cc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019d0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019d4:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800019d8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800019dc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800019e0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800019e4:	0004ac23          	sw	zero,24(s1)
}
    800019e8:	60e2                	ld	ra,24(sp)
    800019ea:	6442                	ld	s0,16(sp)
    800019ec:	64a2                	ld	s1,8(sp)
    800019ee:	6105                	add	sp,sp,32
    800019f0:	8082                	ret

00000000800019f2 <allocproc>:
{
    800019f2:	1101                	add	sp,sp,-32
    800019f4:	ec06                	sd	ra,24(sp)
    800019f6:	e822                	sd	s0,16(sp)
    800019f8:	e426                	sd	s1,8(sp)
    800019fa:	e04a                	sd	s2,0(sp)
    800019fc:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800019fe:	0000e497          	auipc	s1,0xe
    80001a02:	5e248493          	add	s1,s1,1506 # 8000ffe0 <proc>
    80001a06:	00014917          	auipc	s2,0x14
    80001a0a:	1da90913          	add	s2,s2,474 # 80015be0 <tickslock>
    acquire(&p->lock);
    80001a0e:	8526                	mv	a0,s1
    80001a10:	990ff0ef          	jal	80000ba0 <acquire>
    if(p->state == UNUSED) {
    80001a14:	4c9c                	lw	a5,24(s1)
    80001a16:	cb91                	beqz	a5,80001a2a <allocproc+0x38>
      release(&p->lock);
    80001a18:	8526                	mv	a0,s1
    80001a1a:	a1eff0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a1e:	17048493          	add	s1,s1,368
    80001a22:	ff2496e3          	bne	s1,s2,80001a0e <allocproc+0x1c>
  return 0;
    80001a26:	4481                	li	s1,0
    80001a28:	a099                	j	80001a6e <allocproc+0x7c>
  p->pid = allocpid();
    80001a2a:	e71ff0ef          	jal	8000189a <allocpid>
    80001a2e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a30:	4785                	li	a5,1
    80001a32:	cc9c                	sw	a5,24(s1)
  p->trace_mask = 0;
    80001a34:	0404a023          	sw	zero,64(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a38:	898ff0ef          	jal	80000ad0 <kalloc>
    80001a3c:	892a                	mv	s2,a0
    80001a3e:	f0a8                	sd	a0,96(s1)
    80001a40:	cd15                	beqz	a0,80001a7c <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80001a42:	8526                	mv	a0,s1
    80001a44:	e95ff0ef          	jal	800018d8 <proc_pagetable>
    80001a48:	892a                	mv	s2,a0
    80001a4a:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001a4c:	c121                	beqz	a0,80001a8c <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80001a4e:	07000613          	li	a2,112
    80001a52:	4581                	li	a1,0
    80001a54:	06848513          	add	a0,s1,104
    80001a58:	a1cff0ef          	jal	80000c74 <memset>
  p->context.ra = (uint64)forkret;
    80001a5c:	00000797          	auipc	a5,0x0
    80001a60:	e0478793          	add	a5,a5,-508 # 80001860 <forkret>
    80001a64:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a66:	64bc                	ld	a5,72(s1)
    80001a68:	6705                	lui	a4,0x1
    80001a6a:	97ba                	add	a5,a5,a4
    80001a6c:	f8bc                	sd	a5,112(s1)
}
    80001a6e:	8526                	mv	a0,s1
    80001a70:	60e2                	ld	ra,24(sp)
    80001a72:	6442                	ld	s0,16(sp)
    80001a74:	64a2                	ld	s1,8(sp)
    80001a76:	6902                	ld	s2,0(sp)
    80001a78:	6105                	add	sp,sp,32
    80001a7a:	8082                	ret
    freeproc(p);
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	f25ff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a82:	8526                	mv	a0,s1
    80001a84:	9b4ff0ef          	jal	80000c38 <release>
    return 0;
    80001a88:	84ca                	mv	s1,s2
    80001a8a:	b7d5                	j	80001a6e <allocproc+0x7c>
    freeproc(p);
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	f15ff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a92:	8526                	mv	a0,s1
    80001a94:	9a4ff0ef          	jal	80000c38 <release>
    return 0;
    80001a98:	84ca                	mv	s1,s2
    80001a9a:	bfd1                	j	80001a6e <allocproc+0x7c>

0000000080001a9c <userinit>:
{
    80001a9c:	1101                	add	sp,sp,-32
    80001a9e:	ec06                	sd	ra,24(sp)
    80001aa0:	e822                	sd	s0,16(sp)
    80001aa2:	e426                	sd	s1,8(sp)
    80001aa4:	1000                	add	s0,sp,32
  p = allocproc();
    80001aa6:	f4dff0ef          	jal	800019f2 <allocproc>
    80001aaa:	84aa                	mv	s1,a0
  initproc = p;
    80001aac:	00006797          	auipc	a5,0x6
    80001ab0:	fca7b623          	sd	a0,-52(a5) # 80007a78 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ab4:	03400613          	li	a2,52
    80001ab8:	00006597          	auipc	a1,0x6
    80001abc:	f5858593          	add	a1,a1,-168 # 80007a10 <initcode>
    80001ac0:	6d28                	ld	a0,88(a0)
    80001ac2:	f7cff0ef          	jal	8000123e <uvmfirst>
  p->sz = PGSIZE;
    80001ac6:	6785                	lui	a5,0x1
    80001ac8:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      /* user program counter */
    80001aca:	70b8                	ld	a4,96(s1)
    80001acc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    80001ad0:	70b8                	ld	a4,96(s1)
    80001ad2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ad4:	4641                	li	a2,16
    80001ad6:	00005597          	auipc	a1,0x5
    80001ada:	76258593          	add	a1,a1,1890 # 80007238 <digits+0x200>
    80001ade:	16048513          	add	a0,s1,352
    80001ae2:	ad6ff0ef          	jal	80000db8 <safestrcpy>
  p->cwd = namei("/");
    80001ae6:	00005517          	auipc	a0,0x5
    80001aea:	76250513          	add	a0,a0,1890 # 80007248 <digits+0x210>
    80001aee:	509010ef          	jal	800037f6 <namei>
    80001af2:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001af6:	478d                	li	a5,3
    80001af8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001afa:	8526                	mv	a0,s1
    80001afc:	93cff0ef          	jal	80000c38 <release>
}
    80001b00:	60e2                	ld	ra,24(sp)
    80001b02:	6442                	ld	s0,16(sp)
    80001b04:	64a2                	ld	s1,8(sp)
    80001b06:	6105                	add	sp,sp,32
    80001b08:	8082                	ret

0000000080001b0a <growproc>:
{
    80001b0a:	1101                	add	sp,sp,-32
    80001b0c:	ec06                	sd	ra,24(sp)
    80001b0e:	e822                	sd	s0,16(sp)
    80001b10:	e426                	sd	s1,8(sp)
    80001b12:	e04a                	sd	s2,0(sp)
    80001b14:	1000                	add	s0,sp,32
    80001b16:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b18:	d19ff0ef          	jal	80001830 <myproc>
    80001b1c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b1e:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001b20:	01204c63          	bgtz	s2,80001b38 <growproc+0x2e>
  } else if(n < 0){
    80001b24:	02094463          	bltz	s2,80001b4c <growproc+0x42>
  p->sz = sz;
    80001b28:	e8ac                	sd	a1,80(s1)
  return 0;
    80001b2a:	4501                	li	a0,0
}
    80001b2c:	60e2                	ld	ra,24(sp)
    80001b2e:	6442                	ld	s0,16(sp)
    80001b30:	64a2                	ld	s1,8(sp)
    80001b32:	6902                	ld	s2,0(sp)
    80001b34:	6105                	add	sp,sp,32
    80001b36:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b38:	4691                	li	a3,4
    80001b3a:	00b90633          	add	a2,s2,a1
    80001b3e:	6d28                	ld	a0,88(a0)
    80001b40:	fa0ff0ef          	jal	800012e0 <uvmalloc>
    80001b44:	85aa                	mv	a1,a0
    80001b46:	f16d                	bnez	a0,80001b28 <growproc+0x1e>
      return -1;
    80001b48:	557d                	li	a0,-1
    80001b4a:	b7cd                	j	80001b2c <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b4c:	00b90633          	add	a2,s2,a1
    80001b50:	6d28                	ld	a0,88(a0)
    80001b52:	f4aff0ef          	jal	8000129c <uvmdealloc>
    80001b56:	85aa                	mv	a1,a0
    80001b58:	bfc1                	j	80001b28 <growproc+0x1e>

0000000080001b5a <fork>:
{
    80001b5a:	7139                	add	sp,sp,-64
    80001b5c:	fc06                	sd	ra,56(sp)
    80001b5e:	f822                	sd	s0,48(sp)
    80001b60:	f426                	sd	s1,40(sp)
    80001b62:	f04a                	sd	s2,32(sp)
    80001b64:	ec4e                	sd	s3,24(sp)
    80001b66:	e852                	sd	s4,16(sp)
    80001b68:	e456                	sd	s5,8(sp)
    80001b6a:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001b6c:	cc5ff0ef          	jal	80001830 <myproc>
    80001b70:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b72:	e81ff0ef          	jal	800019f2 <allocproc>
    80001b76:	0e050a63          	beqz	a0,80001c6a <fork+0x110>
    80001b7a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b7c:	050ab603          	ld	a2,80(s5)
    80001b80:	6d2c                	ld	a1,88(a0)
    80001b82:	058ab503          	ld	a0,88(s5)
    80001b86:	887ff0ef          	jal	8000140c <uvmcopy>
    80001b8a:	04054863          	bltz	a0,80001bda <fork+0x80>
  np->sz = p->sz;
    80001b8e:	050ab783          	ld	a5,80(s5)
    80001b92:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001b96:	060ab683          	ld	a3,96(s5)
    80001b9a:	87b6                	mv	a5,a3
    80001b9c:	0609b703          	ld	a4,96(s3)
    80001ba0:	12068693          	add	a3,a3,288
    80001ba4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ba8:	6788                	ld	a0,8(a5)
    80001baa:	6b8c                	ld	a1,16(a5)
    80001bac:	6f90                	ld	a2,24(a5)
    80001bae:	01073023          	sd	a6,0(a4)
    80001bb2:	e708                	sd	a0,8(a4)
    80001bb4:	eb0c                	sd	a1,16(a4)
    80001bb6:	ef10                	sd	a2,24(a4)
    80001bb8:	02078793          	add	a5,a5,32
    80001bbc:	02070713          	add	a4,a4,32
    80001bc0:	fed792e3          	bne	a5,a3,80001ba4 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001bc4:	0609b783          	ld	a5,96(s3)
    80001bc8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bcc:	0d8a8493          	add	s1,s5,216
    80001bd0:	0d898913          	add	s2,s3,216
    80001bd4:	158a8a13          	add	s4,s5,344
    80001bd8:	a829                	j	80001bf2 <fork+0x98>
    freeproc(np);
    80001bda:	854e                	mv	a0,s3
    80001bdc:	dc7ff0ef          	jal	800019a2 <freeproc>
    release(&np->lock);
    80001be0:	854e                	mv	a0,s3
    80001be2:	856ff0ef          	jal	80000c38 <release>
    return -1;
    80001be6:	597d                	li	s2,-1
    80001be8:	a0bd                	j	80001c56 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001bea:	04a1                	add	s1,s1,8
    80001bec:	0921                	add	s2,s2,8
    80001bee:	01448963          	beq	s1,s4,80001c00 <fork+0xa6>
    if(p->ofile[i])
    80001bf2:	6088                	ld	a0,0(s1)
    80001bf4:	d97d                	beqz	a0,80001bea <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001bf6:	18a020ef          	jal	80003d80 <filedup>
    80001bfa:	00a93023          	sd	a0,0(s2)
    80001bfe:	b7f5                	j	80001bea <fork+0x90>
  np->cwd = idup(p->cwd);
    80001c00:	158ab503          	ld	a0,344(s5)
    80001c04:	50a010ef          	jal	8000310e <idup>
    80001c08:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c0c:	4641                	li	a2,16
    80001c0e:	160a8593          	add	a1,s5,352
    80001c12:	16098513          	add	a0,s3,352
    80001c16:	9a2ff0ef          	jal	80000db8 <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001c1a:	040aa783          	lw	a5,64(s5)
    80001c1e:	04f9a023          	sw	a5,64(s3)
  pid = np->pid;
    80001c22:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001c26:	854e                	mv	a0,s3
    80001c28:	810ff0ef          	jal	80000c38 <release>
  acquire(&wait_lock);
    80001c2c:	0000e497          	auipc	s1,0xe
    80001c30:	f9c48493          	add	s1,s1,-100 # 8000fbc8 <wait_lock>
    80001c34:	8526                	mv	a0,s1
    80001c36:	f6bfe0ef          	jal	80000ba0 <acquire>
  np->parent = p;
    80001c3a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	ff9fe0ef          	jal	80000c38 <release>
  acquire(&np->lock);
    80001c44:	854e                	mv	a0,s3
    80001c46:	f5bfe0ef          	jal	80000ba0 <acquire>
  np->state = RUNNABLE;
    80001c4a:	478d                	li	a5,3
    80001c4c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001c50:	854e                	mv	a0,s3
    80001c52:	fe7fe0ef          	jal	80000c38 <release>
}
    80001c56:	854a                	mv	a0,s2
    80001c58:	70e2                	ld	ra,56(sp)
    80001c5a:	7442                	ld	s0,48(sp)
    80001c5c:	74a2                	ld	s1,40(sp)
    80001c5e:	7902                	ld	s2,32(sp)
    80001c60:	69e2                	ld	s3,24(sp)
    80001c62:	6a42                	ld	s4,16(sp)
    80001c64:	6aa2                	ld	s5,8(sp)
    80001c66:	6121                	add	sp,sp,64
    80001c68:	8082                	ret
    return -1;
    80001c6a:	597d                	li	s2,-1
    80001c6c:	b7ed                	j	80001c56 <fork+0xfc>

0000000080001c6e <scheduler>:
{
    80001c6e:	715d                	add	sp,sp,-80
    80001c70:	e486                	sd	ra,72(sp)
    80001c72:	e0a2                	sd	s0,64(sp)
    80001c74:	fc26                	sd	s1,56(sp)
    80001c76:	f84a                	sd	s2,48(sp)
    80001c78:	f44e                	sd	s3,40(sp)
    80001c7a:	f052                	sd	s4,32(sp)
    80001c7c:	ec56                	sd	s5,24(sp)
    80001c7e:	e85a                	sd	s6,16(sp)
    80001c80:	e45e                	sd	s7,8(sp)
    80001c82:	e062                	sd	s8,0(sp)
    80001c84:	0880                	add	s0,sp,80
    80001c86:	8792                	mv	a5,tp
  int id = r_tp();
    80001c88:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c8a:	00779b13          	sll	s6,a5,0x7
    80001c8e:	0000e717          	auipc	a4,0xe
    80001c92:	f2270713          	add	a4,a4,-222 # 8000fbb0 <pid_lock>
    80001c96:	975a                	add	a4,a4,s6
    80001c98:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001c9c:	0000e717          	auipc	a4,0xe
    80001ca0:	f4c70713          	add	a4,a4,-180 # 8000fbe8 <cpus+0x8>
    80001ca4:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001ca6:	4c11                	li	s8,4
        c->proc = p;
    80001ca8:	079e                	sll	a5,a5,0x7
    80001caa:	0000ea17          	auipc	s4,0xe
    80001cae:	f06a0a13          	add	s4,s4,-250 # 8000fbb0 <pid_lock>
    80001cb2:	9a3e                	add	s4,s4,a5
        found = 1;
    80001cb4:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cb6:	00014997          	auipc	s3,0x14
    80001cba:	f2a98993          	add	s3,s3,-214 # 80015be0 <tickslock>
    80001cbe:	a0a9                	j	80001d08 <scheduler+0x9a>
      release(&p->lock);
    80001cc0:	8526                	mv	a0,s1
    80001cc2:	f77fe0ef          	jal	80000c38 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cc6:	17048493          	add	s1,s1,368
    80001cca:	03348563          	beq	s1,s3,80001cf4 <scheduler+0x86>
      acquire(&p->lock);
    80001cce:	8526                	mv	a0,s1
    80001cd0:	ed1fe0ef          	jal	80000ba0 <acquire>
      if(p->state == RUNNABLE) {
    80001cd4:	4c9c                	lw	a5,24(s1)
    80001cd6:	ff2795e3          	bne	a5,s2,80001cc0 <scheduler+0x52>
        p->state = RUNNING;
    80001cda:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001cde:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001ce2:	06848593          	add	a1,s1,104
    80001ce6:	855a                	mv	a0,s6
    80001ce8:	5b4000ef          	jal	8000229c <swtch>
        c->proc = 0;
    80001cec:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001cf0:	8ade                	mv	s5,s7
    80001cf2:	b7f9                	j	80001cc0 <scheduler+0x52>
    if(found == 0) {
    80001cf4:	000a9a63          	bnez	s5,80001d08 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cfc:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d00:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001d04:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d0c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d10:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d14:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d16:	0000e497          	auipc	s1,0xe
    80001d1a:	2ca48493          	add	s1,s1,714 # 8000ffe0 <proc>
      if(p->state == RUNNABLE) {
    80001d1e:	490d                	li	s2,3
    80001d20:	b77d                	j	80001cce <scheduler+0x60>

0000000080001d22 <sched>:
{
    80001d22:	7179                	add	sp,sp,-48
    80001d24:	f406                	sd	ra,40(sp)
    80001d26:	f022                	sd	s0,32(sp)
    80001d28:	ec26                	sd	s1,24(sp)
    80001d2a:	e84a                	sd	s2,16(sp)
    80001d2c:	e44e                	sd	s3,8(sp)
    80001d2e:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001d30:	b01ff0ef          	jal	80001830 <myproc>
    80001d34:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d36:	e01fe0ef          	jal	80000b36 <holding>
    80001d3a:	c92d                	beqz	a0,80001dac <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d3c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d3e:	2781                	sext.w	a5,a5
    80001d40:	079e                	sll	a5,a5,0x7
    80001d42:	0000e717          	auipc	a4,0xe
    80001d46:	e6e70713          	add	a4,a4,-402 # 8000fbb0 <pid_lock>
    80001d4a:	97ba                	add	a5,a5,a4
    80001d4c:	0a87a703          	lw	a4,168(a5)
    80001d50:	4785                	li	a5,1
    80001d52:	06f71363          	bne	a4,a5,80001db8 <sched+0x96>
  if(p->state == RUNNING)
    80001d56:	4c98                	lw	a4,24(s1)
    80001d58:	4791                	li	a5,4
    80001d5a:	06f70563          	beq	a4,a5,80001dc4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d62:	8b89                	and	a5,a5,2
  if(intr_get())
    80001d64:	e7b5                	bnez	a5,80001dd0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d66:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d68:	0000e917          	auipc	s2,0xe
    80001d6c:	e4890913          	add	s2,s2,-440 # 8000fbb0 <pid_lock>
    80001d70:	2781                	sext.w	a5,a5
    80001d72:	079e                	sll	a5,a5,0x7
    80001d74:	97ca                	add	a5,a5,s2
    80001d76:	0ac7a983          	lw	s3,172(a5)
    80001d7a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d7c:	2781                	sext.w	a5,a5
    80001d7e:	079e                	sll	a5,a5,0x7
    80001d80:	0000e597          	auipc	a1,0xe
    80001d84:	e6858593          	add	a1,a1,-408 # 8000fbe8 <cpus+0x8>
    80001d88:	95be                	add	a1,a1,a5
    80001d8a:	06848513          	add	a0,s1,104
    80001d8e:	50e000ef          	jal	8000229c <swtch>
    80001d92:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001d94:	2781                	sext.w	a5,a5
    80001d96:	079e                	sll	a5,a5,0x7
    80001d98:	993e                	add	s2,s2,a5
    80001d9a:	0b392623          	sw	s3,172(s2)
}
    80001d9e:	70a2                	ld	ra,40(sp)
    80001da0:	7402                	ld	s0,32(sp)
    80001da2:	64e2                	ld	s1,24(sp)
    80001da4:	6942                	ld	s2,16(sp)
    80001da6:	69a2                	ld	s3,8(sp)
    80001da8:	6145                	add	sp,sp,48
    80001daa:	8082                	ret
    panic("sched p->lock");
    80001dac:	00005517          	auipc	a0,0x5
    80001db0:	4a450513          	add	a0,a0,1188 # 80007250 <digits+0x218>
    80001db4:	9abfe0ef          	jal	8000075e <panic>
    panic("sched locks");
    80001db8:	00005517          	auipc	a0,0x5
    80001dbc:	4a850513          	add	a0,a0,1192 # 80007260 <digits+0x228>
    80001dc0:	99ffe0ef          	jal	8000075e <panic>
    panic("sched running");
    80001dc4:	00005517          	auipc	a0,0x5
    80001dc8:	4ac50513          	add	a0,a0,1196 # 80007270 <digits+0x238>
    80001dcc:	993fe0ef          	jal	8000075e <panic>
    panic("sched interruptible");
    80001dd0:	00005517          	auipc	a0,0x5
    80001dd4:	4b050513          	add	a0,a0,1200 # 80007280 <digits+0x248>
    80001dd8:	987fe0ef          	jal	8000075e <panic>

0000000080001ddc <yield>:
{
    80001ddc:	1101                	add	sp,sp,-32
    80001dde:	ec06                	sd	ra,24(sp)
    80001de0:	e822                	sd	s0,16(sp)
    80001de2:	e426                	sd	s1,8(sp)
    80001de4:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001de6:	a4bff0ef          	jal	80001830 <myproc>
    80001dea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001dec:	db5fe0ef          	jal	80000ba0 <acquire>
  p->state = RUNNABLE;
    80001df0:	478d                	li	a5,3
    80001df2:	cc9c                	sw	a5,24(s1)
  sched();
    80001df4:	f2fff0ef          	jal	80001d22 <sched>
  release(&p->lock);
    80001df8:	8526                	mv	a0,s1
    80001dfa:	e3ffe0ef          	jal	80000c38 <release>
}
    80001dfe:	60e2                	ld	ra,24(sp)
    80001e00:	6442                	ld	s0,16(sp)
    80001e02:	64a2                	ld	s1,8(sp)
    80001e04:	6105                	add	sp,sp,32
    80001e06:	8082                	ret

0000000080001e08 <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    80001e08:	7179                	add	sp,sp,-48
    80001e0a:	f406                	sd	ra,40(sp)
    80001e0c:	f022                	sd	s0,32(sp)
    80001e0e:	ec26                	sd	s1,24(sp)
    80001e10:	e84a                	sd	s2,16(sp)
    80001e12:	e44e                	sd	s3,8(sp)
    80001e14:	1800                	add	s0,sp,48
    80001e16:	89aa                	mv	s3,a0
    80001e18:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e1a:	a17ff0ef          	jal	80001830 <myproc>
    80001e1e:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    80001e20:	d81fe0ef          	jal	80000ba0 <acquire>
  release(lk);
    80001e24:	854a                	mv	a0,s2
    80001e26:	e13fe0ef          	jal	80000c38 <release>

  /* Go to sleep. */
  p->chan = chan;
    80001e2a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e2e:	4789                	li	a5,2
    80001e30:	cc9c                	sw	a5,24(s1)

  sched();
    80001e32:	ef1ff0ef          	jal	80001d22 <sched>

  /* Tidy up. */
  p->chan = 0;
    80001e36:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	dfdfe0ef          	jal	80000c38 <release>
  acquire(lk);
    80001e40:	854a                	mv	a0,s2
    80001e42:	d5ffe0ef          	jal	80000ba0 <acquire>
}
    80001e46:	70a2                	ld	ra,40(sp)
    80001e48:	7402                	ld	s0,32(sp)
    80001e4a:	64e2                	ld	s1,24(sp)
    80001e4c:	6942                	ld	s2,16(sp)
    80001e4e:	69a2                	ld	s3,8(sp)
    80001e50:	6145                	add	sp,sp,48
    80001e52:	8082                	ret

0000000080001e54 <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    80001e54:	7139                	add	sp,sp,-64
    80001e56:	fc06                	sd	ra,56(sp)
    80001e58:	f822                	sd	s0,48(sp)
    80001e5a:	f426                	sd	s1,40(sp)
    80001e5c:	f04a                	sd	s2,32(sp)
    80001e5e:	ec4e                	sd	s3,24(sp)
    80001e60:	e852                	sd	s4,16(sp)
    80001e62:	e456                	sd	s5,8(sp)
    80001e64:	0080                	add	s0,sp,64
    80001e66:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e68:	0000e497          	auipc	s1,0xe
    80001e6c:	17848493          	add	s1,s1,376 # 8000ffe0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e70:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e72:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e74:	00014917          	auipc	s2,0x14
    80001e78:	d6c90913          	add	s2,s2,-660 # 80015be0 <tickslock>
    80001e7c:	a801                	j	80001e8c <wakeup+0x38>
      }
      release(&p->lock);
    80001e7e:	8526                	mv	a0,s1
    80001e80:	db9fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e84:	17048493          	add	s1,s1,368
    80001e88:	03248263          	beq	s1,s2,80001eac <wakeup+0x58>
    if(p != myproc()){
    80001e8c:	9a5ff0ef          	jal	80001830 <myproc>
    80001e90:	fea48ae3          	beq	s1,a0,80001e84 <wakeup+0x30>
      acquire(&p->lock);
    80001e94:	8526                	mv	a0,s1
    80001e96:	d0bfe0ef          	jal	80000ba0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001e9a:	4c9c                	lw	a5,24(s1)
    80001e9c:	ff3791e3          	bne	a5,s3,80001e7e <wakeup+0x2a>
    80001ea0:	709c                	ld	a5,32(s1)
    80001ea2:	fd479ee3          	bne	a5,s4,80001e7e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001ea6:	0154ac23          	sw	s5,24(s1)
    80001eaa:	bfd1                	j	80001e7e <wakeup+0x2a>
    }
  }
}
    80001eac:	70e2                	ld	ra,56(sp)
    80001eae:	7442                	ld	s0,48(sp)
    80001eb0:	74a2                	ld	s1,40(sp)
    80001eb2:	7902                	ld	s2,32(sp)
    80001eb4:	69e2                	ld	s3,24(sp)
    80001eb6:	6a42                	ld	s4,16(sp)
    80001eb8:	6aa2                	ld	s5,8(sp)
    80001eba:	6121                	add	sp,sp,64
    80001ebc:	8082                	ret

0000000080001ebe <reparent>:
{
    80001ebe:	7179                	add	sp,sp,-48
    80001ec0:	f406                	sd	ra,40(sp)
    80001ec2:	f022                	sd	s0,32(sp)
    80001ec4:	ec26                	sd	s1,24(sp)
    80001ec6:	e84a                	sd	s2,16(sp)
    80001ec8:	e44e                	sd	s3,8(sp)
    80001eca:	e052                	sd	s4,0(sp)
    80001ecc:	1800                	add	s0,sp,48
    80001ece:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ed0:	0000e497          	auipc	s1,0xe
    80001ed4:	11048493          	add	s1,s1,272 # 8000ffe0 <proc>
      pp->parent = initproc;
    80001ed8:	00006a17          	auipc	s4,0x6
    80001edc:	ba0a0a13          	add	s4,s4,-1120 # 80007a78 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ee0:	00014997          	auipc	s3,0x14
    80001ee4:	d0098993          	add	s3,s3,-768 # 80015be0 <tickslock>
    80001ee8:	a029                	j	80001ef2 <reparent+0x34>
    80001eea:	17048493          	add	s1,s1,368
    80001eee:	01348b63          	beq	s1,s3,80001f04 <reparent+0x46>
    if(pp->parent == p){
    80001ef2:	7c9c                	ld	a5,56(s1)
    80001ef4:	ff279be3          	bne	a5,s2,80001eea <reparent+0x2c>
      pp->parent = initproc;
    80001ef8:	000a3503          	ld	a0,0(s4)
    80001efc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001efe:	f57ff0ef          	jal	80001e54 <wakeup>
    80001f02:	b7e5                	j	80001eea <reparent+0x2c>
}
    80001f04:	70a2                	ld	ra,40(sp)
    80001f06:	7402                	ld	s0,32(sp)
    80001f08:	64e2                	ld	s1,24(sp)
    80001f0a:	6942                	ld	s2,16(sp)
    80001f0c:	69a2                	ld	s3,8(sp)
    80001f0e:	6a02                	ld	s4,0(sp)
    80001f10:	6145                	add	sp,sp,48
    80001f12:	8082                	ret

0000000080001f14 <exit>:
{
    80001f14:	7179                	add	sp,sp,-48
    80001f16:	f406                	sd	ra,40(sp)
    80001f18:	f022                	sd	s0,32(sp)
    80001f1a:	ec26                	sd	s1,24(sp)
    80001f1c:	e84a                	sd	s2,16(sp)
    80001f1e:	e44e                	sd	s3,8(sp)
    80001f20:	e052                	sd	s4,0(sp)
    80001f22:	1800                	add	s0,sp,48
    80001f24:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f26:	90bff0ef          	jal	80001830 <myproc>
    80001f2a:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f2c:	00006797          	auipc	a5,0x6
    80001f30:	b4c7b783          	ld	a5,-1204(a5) # 80007a78 <initproc>
    80001f34:	0d850493          	add	s1,a0,216
    80001f38:	15850913          	add	s2,a0,344
    80001f3c:	00a79f63          	bne	a5,a0,80001f5a <exit+0x46>
    panic("init exiting");
    80001f40:	00005517          	auipc	a0,0x5
    80001f44:	35850513          	add	a0,a0,856 # 80007298 <digits+0x260>
    80001f48:	817fe0ef          	jal	8000075e <panic>
      fileclose(f);
    80001f4c:	67b010ef          	jal	80003dc6 <fileclose>
      p->ofile[fd] = 0;
    80001f50:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f54:	04a1                	add	s1,s1,8
    80001f56:	01248563          	beq	s1,s2,80001f60 <exit+0x4c>
    if(p->ofile[fd]){
    80001f5a:	6088                	ld	a0,0(s1)
    80001f5c:	f965                	bnez	a0,80001f4c <exit+0x38>
    80001f5e:	bfdd                	j	80001f54 <exit+0x40>
  begin_op();
    80001f60:	253010ef          	jal	800039b2 <begin_op>
  iput(p->cwd);
    80001f64:	1589b503          	ld	a0,344(s3)
    80001f68:	35a010ef          	jal	800032c2 <iput>
  end_op();
    80001f6c:	2b1010ef          	jal	80003a1c <end_op>
  p->cwd = 0;
    80001f70:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001f74:	0000e497          	auipc	s1,0xe
    80001f78:	c5448493          	add	s1,s1,-940 # 8000fbc8 <wait_lock>
    80001f7c:	8526                	mv	a0,s1
    80001f7e:	c23fe0ef          	jal	80000ba0 <acquire>
  reparent(p);
    80001f82:	854e                	mv	a0,s3
    80001f84:	f3bff0ef          	jal	80001ebe <reparent>
  wakeup(p->parent);
    80001f88:	0389b503          	ld	a0,56(s3)
    80001f8c:	ec9ff0ef          	jal	80001e54 <wakeup>
  acquire(&p->lock);
    80001f90:	854e                	mv	a0,s3
    80001f92:	c0ffe0ef          	jal	80000ba0 <acquire>
  p->xstate = status;
    80001f96:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001f9a:	4795                	li	a5,5
    80001f9c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001fa0:	8526                	mv	a0,s1
    80001fa2:	c97fe0ef          	jal	80000c38 <release>
  sched();
    80001fa6:	d7dff0ef          	jal	80001d22 <sched>
  panic("zombie exit");
    80001faa:	00005517          	auipc	a0,0x5
    80001fae:	2fe50513          	add	a0,a0,766 # 800072a8 <digits+0x270>
    80001fb2:	facfe0ef          	jal	8000075e <panic>

0000000080001fb6 <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    80001fb6:	7179                	add	sp,sp,-48
    80001fb8:	f406                	sd	ra,40(sp)
    80001fba:	f022                	sd	s0,32(sp)
    80001fbc:	ec26                	sd	s1,24(sp)
    80001fbe:	e84a                	sd	s2,16(sp)
    80001fc0:	e44e                	sd	s3,8(sp)
    80001fc2:	1800                	add	s0,sp,48
    80001fc4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001fc6:	0000e497          	auipc	s1,0xe
    80001fca:	01a48493          	add	s1,s1,26 # 8000ffe0 <proc>
    80001fce:	00014997          	auipc	s3,0x14
    80001fd2:	c1298993          	add	s3,s3,-1006 # 80015be0 <tickslock>
    acquire(&p->lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	bc9fe0ef          	jal	80000ba0 <acquire>
    if(p->pid == pid){
    80001fdc:	589c                	lw	a5,48(s1)
    80001fde:	01278b63          	beq	a5,s2,80001ff4 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001fe2:	8526                	mv	a0,s1
    80001fe4:	c55fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001fe8:	17048493          	add	s1,s1,368
    80001fec:	ff3495e3          	bne	s1,s3,80001fd6 <kill+0x20>
  }
  return -1;
    80001ff0:	557d                	li	a0,-1
    80001ff2:	a819                	j	80002008 <kill+0x52>
      p->killed = 1;
    80001ff4:	4785                	li	a5,1
    80001ff6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001ff8:	4c98                	lw	a4,24(s1)
    80001ffa:	4789                	li	a5,2
    80001ffc:	00f70d63          	beq	a4,a5,80002016 <kill+0x60>
      release(&p->lock);
    80002000:	8526                	mv	a0,s1
    80002002:	c37fe0ef          	jal	80000c38 <release>
      return 0;
    80002006:	4501                	li	a0,0
}
    80002008:	70a2                	ld	ra,40(sp)
    8000200a:	7402                	ld	s0,32(sp)
    8000200c:	64e2                	ld	s1,24(sp)
    8000200e:	6942                	ld	s2,16(sp)
    80002010:	69a2                	ld	s3,8(sp)
    80002012:	6145                	add	sp,sp,48
    80002014:	8082                	ret
        p->state = RUNNABLE;
    80002016:	478d                	li	a5,3
    80002018:	cc9c                	sw	a5,24(s1)
    8000201a:	b7dd                	j	80002000 <kill+0x4a>

000000008000201c <setkilled>:

void
setkilled(struct proc *p)
{
    8000201c:	1101                	add	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	e426                	sd	s1,8(sp)
    80002024:	1000                	add	s0,sp,32
    80002026:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002028:	b79fe0ef          	jal	80000ba0 <acquire>
  p->killed = 1;
    8000202c:	4785                	li	a5,1
    8000202e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002030:	8526                	mv	a0,s1
    80002032:	c07fe0ef          	jal	80000c38 <release>
}
    80002036:	60e2                	ld	ra,24(sp)
    80002038:	6442                	ld	s0,16(sp)
    8000203a:	64a2                	ld	s1,8(sp)
    8000203c:	6105                	add	sp,sp,32
    8000203e:	8082                	ret

0000000080002040 <killed>:

int
killed(struct proc *p)
{
    80002040:	1101                	add	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	e426                	sd	s1,8(sp)
    80002048:	e04a                	sd	s2,0(sp)
    8000204a:	1000                	add	s0,sp,32
    8000204c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000204e:	b53fe0ef          	jal	80000ba0 <acquire>
  k = p->killed;
    80002052:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002056:	8526                	mv	a0,s1
    80002058:	be1fe0ef          	jal	80000c38 <release>
  return k;
}
    8000205c:	854a                	mv	a0,s2
    8000205e:	60e2                	ld	ra,24(sp)
    80002060:	6442                	ld	s0,16(sp)
    80002062:	64a2                	ld	s1,8(sp)
    80002064:	6902                	ld	s2,0(sp)
    80002066:	6105                	add	sp,sp,32
    80002068:	8082                	ret

000000008000206a <wait>:
{
    8000206a:	715d                	add	sp,sp,-80
    8000206c:	e486                	sd	ra,72(sp)
    8000206e:	e0a2                	sd	s0,64(sp)
    80002070:	fc26                	sd	s1,56(sp)
    80002072:	f84a                	sd	s2,48(sp)
    80002074:	f44e                	sd	s3,40(sp)
    80002076:	f052                	sd	s4,32(sp)
    80002078:	ec56                	sd	s5,24(sp)
    8000207a:	e85a                	sd	s6,16(sp)
    8000207c:	e45e                	sd	s7,8(sp)
    8000207e:	e062                	sd	s8,0(sp)
    80002080:	0880                	add	s0,sp,80
    80002082:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002084:	facff0ef          	jal	80001830 <myproc>
    80002088:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000208a:	0000e517          	auipc	a0,0xe
    8000208e:	b3e50513          	add	a0,a0,-1218 # 8000fbc8 <wait_lock>
    80002092:	b0ffe0ef          	jal	80000ba0 <acquire>
    havekids = 0;
    80002096:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002098:	4a15                	li	s4,5
        havekids = 1;
    8000209a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000209c:	00014997          	auipc	s3,0x14
    800020a0:	b4498993          	add	s3,s3,-1212 # 80015be0 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    800020a4:	0000ec17          	auipc	s8,0xe
    800020a8:	b24c0c13          	add	s8,s8,-1244 # 8000fbc8 <wait_lock>
    800020ac:	a871                	j	80002148 <wait+0xde>
          pid = pp->pid;
    800020ae:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020b2:	000b0c63          	beqz	s6,800020ca <wait+0x60>
    800020b6:	4691                	li	a3,4
    800020b8:	02c48613          	add	a2,s1,44
    800020bc:	85da                	mv	a1,s6
    800020be:	05893503          	ld	a0,88(s2)
    800020c2:	c26ff0ef          	jal	800014e8 <copyout>
    800020c6:	02054b63          	bltz	a0,800020fc <wait+0x92>
          freeproc(pp);
    800020ca:	8526                	mv	a0,s1
    800020cc:	8d7ff0ef          	jal	800019a2 <freeproc>
          release(&pp->lock);
    800020d0:	8526                	mv	a0,s1
    800020d2:	b67fe0ef          	jal	80000c38 <release>
          release(&wait_lock);
    800020d6:	0000e517          	auipc	a0,0xe
    800020da:	af250513          	add	a0,a0,-1294 # 8000fbc8 <wait_lock>
    800020de:	b5bfe0ef          	jal	80000c38 <release>
}
    800020e2:	854e                	mv	a0,s3
    800020e4:	60a6                	ld	ra,72(sp)
    800020e6:	6406                	ld	s0,64(sp)
    800020e8:	74e2                	ld	s1,56(sp)
    800020ea:	7942                	ld	s2,48(sp)
    800020ec:	79a2                	ld	s3,40(sp)
    800020ee:	7a02                	ld	s4,32(sp)
    800020f0:	6ae2                	ld	s5,24(sp)
    800020f2:	6b42                	ld	s6,16(sp)
    800020f4:	6ba2                	ld	s7,8(sp)
    800020f6:	6c02                	ld	s8,0(sp)
    800020f8:	6161                	add	sp,sp,80
    800020fa:	8082                	ret
            release(&pp->lock);
    800020fc:	8526                	mv	a0,s1
    800020fe:	b3bfe0ef          	jal	80000c38 <release>
            release(&wait_lock);
    80002102:	0000e517          	auipc	a0,0xe
    80002106:	ac650513          	add	a0,a0,-1338 # 8000fbc8 <wait_lock>
    8000210a:	b2ffe0ef          	jal	80000c38 <release>
            return -1;
    8000210e:	59fd                	li	s3,-1
    80002110:	bfc9                	j	800020e2 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002112:	17048493          	add	s1,s1,368
    80002116:	03348063          	beq	s1,s3,80002136 <wait+0xcc>
      if(pp->parent == p){
    8000211a:	7c9c                	ld	a5,56(s1)
    8000211c:	ff279be3          	bne	a5,s2,80002112 <wait+0xa8>
        acquire(&pp->lock);
    80002120:	8526                	mv	a0,s1
    80002122:	a7ffe0ef          	jal	80000ba0 <acquire>
        if(pp->state == ZOMBIE){
    80002126:	4c9c                	lw	a5,24(s1)
    80002128:	f94783e3          	beq	a5,s4,800020ae <wait+0x44>
        release(&pp->lock);
    8000212c:	8526                	mv	a0,s1
    8000212e:	b0bfe0ef          	jal	80000c38 <release>
        havekids = 1;
    80002132:	8756                	mv	a4,s5
    80002134:	bff9                	j	80002112 <wait+0xa8>
    if(!havekids || killed(p)){
    80002136:	cf19                	beqz	a4,80002154 <wait+0xea>
    80002138:	854a                	mv	a0,s2
    8000213a:	f07ff0ef          	jal	80002040 <killed>
    8000213e:	e919                	bnez	a0,80002154 <wait+0xea>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    80002140:	85e2                	mv	a1,s8
    80002142:	854a                	mv	a0,s2
    80002144:	cc5ff0ef          	jal	80001e08 <sleep>
    havekids = 0;
    80002148:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000214a:	0000e497          	auipc	s1,0xe
    8000214e:	e9648493          	add	s1,s1,-362 # 8000ffe0 <proc>
    80002152:	b7e1                	j	8000211a <wait+0xb0>
      release(&wait_lock);
    80002154:	0000e517          	auipc	a0,0xe
    80002158:	a7450513          	add	a0,a0,-1420 # 8000fbc8 <wait_lock>
    8000215c:	addfe0ef          	jal	80000c38 <release>
      return -1;
    80002160:	59fd                	li	s3,-1
    80002162:	b741                	j	800020e2 <wait+0x78>

0000000080002164 <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002164:	7179                	add	sp,sp,-48
    80002166:	f406                	sd	ra,40(sp)
    80002168:	f022                	sd	s0,32(sp)
    8000216a:	ec26                	sd	s1,24(sp)
    8000216c:	e84a                	sd	s2,16(sp)
    8000216e:	e44e                	sd	s3,8(sp)
    80002170:	e052                	sd	s4,0(sp)
    80002172:	1800                	add	s0,sp,48
    80002174:	84aa                	mv	s1,a0
    80002176:	892e                	mv	s2,a1
    80002178:	89b2                	mv	s3,a2
    8000217a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000217c:	eb4ff0ef          	jal	80001830 <myproc>
  if(user_dst){
    80002180:	cc99                	beqz	s1,8000219e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002182:	86d2                	mv	a3,s4
    80002184:	864e                	mv	a2,s3
    80002186:	85ca                	mv	a1,s2
    80002188:	6d28                	ld	a0,88(a0)
    8000218a:	b5eff0ef          	jal	800014e8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000218e:	70a2                	ld	ra,40(sp)
    80002190:	7402                	ld	s0,32(sp)
    80002192:	64e2                	ld	s1,24(sp)
    80002194:	6942                	ld	s2,16(sp)
    80002196:	69a2                	ld	s3,8(sp)
    80002198:	6a02                	ld	s4,0(sp)
    8000219a:	6145                	add	sp,sp,48
    8000219c:	8082                	ret
    memmove((char *)dst, src, len);
    8000219e:	000a061b          	sext.w	a2,s4
    800021a2:	85ce                	mv	a1,s3
    800021a4:	854a                	mv	a0,s2
    800021a6:	b2bfe0ef          	jal	80000cd0 <memmove>
    return 0;
    800021aa:	8526                	mv	a0,s1
    800021ac:	b7cd                	j	8000218e <either_copyout+0x2a>

00000000800021ae <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800021ae:	7179                	add	sp,sp,-48
    800021b0:	f406                	sd	ra,40(sp)
    800021b2:	f022                	sd	s0,32(sp)
    800021b4:	ec26                	sd	s1,24(sp)
    800021b6:	e84a                	sd	s2,16(sp)
    800021b8:	e44e                	sd	s3,8(sp)
    800021ba:	e052                	sd	s4,0(sp)
    800021bc:	1800                	add	s0,sp,48
    800021be:	892a                	mv	s2,a0
    800021c0:	84ae                	mv	s1,a1
    800021c2:	89b2                	mv	s3,a2
    800021c4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021c6:	e6aff0ef          	jal	80001830 <myproc>
  if(user_src){
    800021ca:	cc99                	beqz	s1,800021e8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021cc:	86d2                	mv	a3,s4
    800021ce:	864e                	mv	a2,s3
    800021d0:	85ca                	mv	a1,s2
    800021d2:	6d28                	ld	a0,88(a0)
    800021d4:	bccff0ef          	jal	800015a0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800021d8:	70a2                	ld	ra,40(sp)
    800021da:	7402                	ld	s0,32(sp)
    800021dc:	64e2                	ld	s1,24(sp)
    800021de:	6942                	ld	s2,16(sp)
    800021e0:	69a2                	ld	s3,8(sp)
    800021e2:	6a02                	ld	s4,0(sp)
    800021e4:	6145                	add	sp,sp,48
    800021e6:	8082                	ret
    memmove(dst, (char*)src, len);
    800021e8:	000a061b          	sext.w	a2,s4
    800021ec:	85ce                	mv	a1,s3
    800021ee:	854a                	mv	a0,s2
    800021f0:	ae1fe0ef          	jal	80000cd0 <memmove>
    return 0;
    800021f4:	8526                	mv	a0,s1
    800021f6:	b7cd                	j	800021d8 <either_copyin+0x2a>

00000000800021f8 <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    800021f8:	715d                	add	sp,sp,-80
    800021fa:	e486                	sd	ra,72(sp)
    800021fc:	e0a2                	sd	s0,64(sp)
    800021fe:	fc26                	sd	s1,56(sp)
    80002200:	f84a                	sd	s2,48(sp)
    80002202:	f44e                	sd	s3,40(sp)
    80002204:	f052                	sd	s4,32(sp)
    80002206:	ec56                	sd	s5,24(sp)
    80002208:	e85a                	sd	s6,16(sp)
    8000220a:	e45e                	sd	s7,8(sp)
    8000220c:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000220e:	00005517          	auipc	a0,0x5
    80002212:	eb250513          	add	a0,a0,-334 # 800070c0 <digits+0x88>
    80002216:	a88fe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000221a:	0000e497          	auipc	s1,0xe
    8000221e:	f2648493          	add	s1,s1,-218 # 80010140 <proc+0x160>
    80002222:	00014917          	auipc	s2,0x14
    80002226:	b1e90913          	add	s2,s2,-1250 # 80015d40 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000222a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000222c:	00005997          	auipc	s3,0x5
    80002230:	08c98993          	add	s3,s3,140 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002234:	00005a97          	auipc	s5,0x5
    80002238:	08ca8a93          	add	s5,s5,140 # 800072c0 <digits+0x288>
    printf("\n");
    8000223c:	00005a17          	auipc	s4,0x5
    80002240:	e84a0a13          	add	s4,s4,-380 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002244:	00005b97          	auipc	s7,0x5
    80002248:	0bcb8b93          	add	s7,s7,188 # 80007300 <states.0>
    8000224c:	a829                	j	80002266 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000224e:	ed06a583          	lw	a1,-304(a3)
    80002252:	8556                	mv	a0,s5
    80002254:	a4afe0ef          	jal	8000049e <printf>
    printf("\n");
    80002258:	8552                	mv	a0,s4
    8000225a:	a44fe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000225e:	17048493          	add	s1,s1,368
    80002262:	03248263          	beq	s1,s2,80002286 <procdump+0x8e>
    if(p->state == UNUSED)
    80002266:	86a6                	mv	a3,s1
    80002268:	eb84a783          	lw	a5,-328(s1)
    8000226c:	dbed                	beqz	a5,8000225e <procdump+0x66>
      state = "???";
    8000226e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002270:	fcfb6fe3          	bltu	s6,a5,8000224e <procdump+0x56>
    80002274:	02079713          	sll	a4,a5,0x20
    80002278:	01d75793          	srl	a5,a4,0x1d
    8000227c:	97de                	add	a5,a5,s7
    8000227e:	6390                	ld	a2,0(a5)
    80002280:	f679                	bnez	a2,8000224e <procdump+0x56>
      state = "???";
    80002282:	864e                	mv	a2,s3
    80002284:	b7e9                	j	8000224e <procdump+0x56>
  }
}
    80002286:	60a6                	ld	ra,72(sp)
    80002288:	6406                	ld	s0,64(sp)
    8000228a:	74e2                	ld	s1,56(sp)
    8000228c:	7942                	ld	s2,48(sp)
    8000228e:	79a2                	ld	s3,40(sp)
    80002290:	7a02                	ld	s4,32(sp)
    80002292:	6ae2                	ld	s5,24(sp)
    80002294:	6b42                	ld	s6,16(sp)
    80002296:	6ba2                	ld	s7,8(sp)
    80002298:	6161                	add	sp,sp,80
    8000229a:	8082                	ret

000000008000229c <swtch>:
    8000229c:	00153023          	sd	ra,0(a0)
    800022a0:	00253423          	sd	sp,8(a0)
    800022a4:	e900                	sd	s0,16(a0)
    800022a6:	ed04                	sd	s1,24(a0)
    800022a8:	03253023          	sd	s2,32(a0)
    800022ac:	03353423          	sd	s3,40(a0)
    800022b0:	03453823          	sd	s4,48(a0)
    800022b4:	03553c23          	sd	s5,56(a0)
    800022b8:	05653023          	sd	s6,64(a0)
    800022bc:	05753423          	sd	s7,72(a0)
    800022c0:	05853823          	sd	s8,80(a0)
    800022c4:	05953c23          	sd	s9,88(a0)
    800022c8:	07a53023          	sd	s10,96(a0)
    800022cc:	07b53423          	sd	s11,104(a0)
    800022d0:	0005b083          	ld	ra,0(a1)
    800022d4:	0085b103          	ld	sp,8(a1)
    800022d8:	6980                	ld	s0,16(a1)
    800022da:	6d84                	ld	s1,24(a1)
    800022dc:	0205b903          	ld	s2,32(a1)
    800022e0:	0285b983          	ld	s3,40(a1)
    800022e4:	0305ba03          	ld	s4,48(a1)
    800022e8:	0385ba83          	ld	s5,56(a1)
    800022ec:	0405bb03          	ld	s6,64(a1)
    800022f0:	0485bb83          	ld	s7,72(a1)
    800022f4:	0505bc03          	ld	s8,80(a1)
    800022f8:	0585bc83          	ld	s9,88(a1)
    800022fc:	0605bd03          	ld	s10,96(a1)
    80002300:	0685bd83          	ld	s11,104(a1)
    80002304:	8082                	ret

0000000080002306 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002306:	1141                	add	sp,sp,-16
    80002308:	e406                	sd	ra,8(sp)
    8000230a:	e022                	sd	s0,0(sp)
    8000230c:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    8000230e:	00005597          	auipc	a1,0x5
    80002312:	02258593          	add	a1,a1,34 # 80007330 <states.0+0x30>
    80002316:	00014517          	auipc	a0,0x14
    8000231a:	8ca50513          	add	a0,a0,-1846 # 80015be0 <tickslock>
    8000231e:	803fe0ef          	jal	80000b20 <initlock>
}
    80002322:	60a2                	ld	ra,8(sp)
    80002324:	6402                	ld	s0,0(sp)
    80002326:	0141                	add	sp,sp,16
    80002328:	8082                	ret

000000008000232a <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    8000232a:	1141                	add	sp,sp,-16
    8000232c:	e422                	sd	s0,8(sp)
    8000232e:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002330:	00003797          	auipc	a5,0x3
    80002334:	d3078793          	add	a5,a5,-720 # 80005060 <kernelvec>
    80002338:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000233c:	6422                	ld	s0,8(sp)
    8000233e:	0141                	add	sp,sp,16
    80002340:	8082                	ret

0000000080002342 <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    80002342:	1141                	add	sp,sp,-16
    80002344:	e406                	sd	ra,8(sp)
    80002346:	e022                	sd	s0,0(sp)
    80002348:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    8000234a:	ce6ff0ef          	jal	80001830 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000234e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002352:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002354:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002358:	00004697          	auipc	a3,0x4
    8000235c:	ca868693          	add	a3,a3,-856 # 80006000 <_trampoline>
    80002360:	00004717          	auipc	a4,0x4
    80002364:	ca070713          	add	a4,a4,-864 # 80006000 <_trampoline>
    80002368:	8f15                	sub	a4,a4,a3
    8000236a:	040007b7          	lui	a5,0x4000
    8000236e:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002370:	07b2                	sll	a5,a5,0xc
    80002372:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002374:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    80002378:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000237a:	18002673          	csrr	a2,satp
    8000237e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    80002380:	7130                	ld	a2,96(a0)
    80002382:	6538                	ld	a4,72(a0)
    80002384:	6585                	lui	a1,0x1
    80002386:	972e                	add	a4,a4,a1
    80002388:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000238a:	7138                	ld	a4,96(a0)
    8000238c:	00000617          	auipc	a2,0x0
    80002390:	10c60613          	add	a2,a2,268 # 80002498 <usertrap>
    80002394:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    80002396:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002398:	8612                	mv	a2,tp
    8000239a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000239c:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    800023a0:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    800023a4:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800023a8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    800023ac:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800023ae:	6f18                	ld	a4,24(a4)
    800023b0:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    800023b4:	6d28                	ld	a0,88(a0)
    800023b6:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800023b8:	00004717          	auipc	a4,0x4
    800023bc:	ce470713          	add	a4,a4,-796 # 8000609c <userret>
    800023c0:	8f15                	sub	a4,a4,a3
    800023c2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800023c4:	577d                	li	a4,-1
    800023c6:	177e                	sll	a4,a4,0x3f
    800023c8:	8d59                	or	a0,a0,a4
    800023ca:	9782                	jalr	a5
}
    800023cc:	60a2                	ld	ra,8(sp)
    800023ce:	6402                	ld	s0,0(sp)
    800023d0:	0141                	add	sp,sp,16
    800023d2:	8082                	ret

00000000800023d4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800023d4:	1101                	add	sp,sp,-32
    800023d6:	ec06                	sd	ra,24(sp)
    800023d8:	e822                	sd	s0,16(sp)
    800023da:	e426                	sd	s1,8(sp)
    800023dc:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    800023de:	c26ff0ef          	jal	80001804 <cpuid>
    800023e2:	cd19                	beqz	a0,80002400 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800023e4:	c01027f3          	rdtime	a5
  }

  /* ask for the next timer interrupt. this also clears */
  /* the interrupt request. 1000000 is about a tenth */
  /* of a second. */
  w_stimecmp(r_time() + 1000000);
    800023e8:	000f4737          	lui	a4,0xf4
    800023ec:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800023f0:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800023f2:	14d79073          	csrw	stimecmp,a5
}
    800023f6:	60e2                	ld	ra,24(sp)
    800023f8:	6442                	ld	s0,16(sp)
    800023fa:	64a2                	ld	s1,8(sp)
    800023fc:	6105                	add	sp,sp,32
    800023fe:	8082                	ret
    acquire(&tickslock);
    80002400:	00013497          	auipc	s1,0x13
    80002404:	7e048493          	add	s1,s1,2016 # 80015be0 <tickslock>
    80002408:	8526                	mv	a0,s1
    8000240a:	f96fe0ef          	jal	80000ba0 <acquire>
    ticks++;
    8000240e:	00005517          	auipc	a0,0x5
    80002412:	67250513          	add	a0,a0,1650 # 80007a80 <ticks>
    80002416:	411c                	lw	a5,0(a0)
    80002418:	2785                	addw	a5,a5,1
    8000241a:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000241c:	a39ff0ef          	jal	80001e54 <wakeup>
    release(&tickslock);
    80002420:	8526                	mv	a0,s1
    80002422:	817fe0ef          	jal	80000c38 <release>
    80002426:	bf7d                	j	800023e4 <clockintr+0x10>

0000000080002428 <devintr>:
/* returns 2 if timer interrupt, */
/* 1 if other device, */
/* 0 if not recognized. */
int
devintr()
{
    80002428:	1101                	add	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	e426                	sd	s1,8(sp)
    80002430:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002432:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002436:	57fd                	li	a5,-1
    80002438:	17fe                	sll	a5,a5,0x3f
    8000243a:	07a5                	add	a5,a5,9
    8000243c:	00f70d63          	beq	a4,a5,80002456 <devintr+0x2e>
    /* now allowed to interrupt again. */
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002440:	57fd                	li	a5,-1
    80002442:	17fe                	sll	a5,a5,0x3f
    80002444:	0795                	add	a5,a5,5
    /* timer interrupt. */
    clockintr();
    return 2;
  } else {
    return 0;
    80002446:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002448:	04f70463          	beq	a4,a5,80002490 <devintr+0x68>
  }
}
    8000244c:	60e2                	ld	ra,24(sp)
    8000244e:	6442                	ld	s0,16(sp)
    80002450:	64a2                	ld	s1,8(sp)
    80002452:	6105                	add	sp,sp,32
    80002454:	8082                	ret
    int irq = plic_claim();
    80002456:	4b3020ef          	jal	80005108 <plic_claim>
    8000245a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000245c:	47a9                	li	a5,10
    8000245e:	02f50363          	beq	a0,a5,80002484 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80002462:	4785                	li	a5,1
    80002464:	02f50363          	beq	a0,a5,8000248a <devintr+0x62>
    return 1;
    80002468:	4505                	li	a0,1
    } else if(irq){
    8000246a:	d0ed                	beqz	s1,8000244c <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    8000246c:	85a6                	mv	a1,s1
    8000246e:	00005517          	auipc	a0,0x5
    80002472:	eca50513          	add	a0,a0,-310 # 80007338 <states.0+0x38>
    80002476:	828fe0ef          	jal	8000049e <printf>
      plic_complete(irq);
    8000247a:	8526                	mv	a0,s1
    8000247c:	4ad020ef          	jal	80005128 <plic_complete>
    return 1;
    80002480:	4505                	li	a0,1
    80002482:	b7e9                	j	8000244c <devintr+0x24>
      uartintr();
    80002484:	d2efe0ef          	jal	800009b2 <uartintr>
    if(irq)
    80002488:	bfcd                	j	8000247a <devintr+0x52>
      virtio_disk_intr();
    8000248a:	108030ef          	jal	80005592 <virtio_disk_intr>
    if(irq)
    8000248e:	b7f5                	j	8000247a <devintr+0x52>
    clockintr();
    80002490:	f45ff0ef          	jal	800023d4 <clockintr>
    return 2;
    80002494:	4509                	li	a0,2
    80002496:	bf5d                	j	8000244c <devintr+0x24>

0000000080002498 <usertrap>:
{
    80002498:	1101                	add	sp,sp,-32
    8000249a:	ec06                	sd	ra,24(sp)
    8000249c:	e822                	sd	s0,16(sp)
    8000249e:	e426                	sd	s1,8(sp)
    800024a0:	e04a                	sd	s2,0(sp)
    800024a2:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024a4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800024a8:	1007f793          	and	a5,a5,256
    800024ac:	ef85                	bnez	a5,800024e4 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024ae:	00003797          	auipc	a5,0x3
    800024b2:	bb278793          	add	a5,a5,-1102 # 80005060 <kernelvec>
    800024b6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800024ba:	b76ff0ef          	jal	80001830 <myproc>
    800024be:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800024c0:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800024c2:	14102773          	csrr	a4,sepc
    800024c6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024c8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800024cc:	47a1                	li	a5,8
    800024ce:	02f70163          	beq	a4,a5,800024f0 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800024d2:	f57ff0ef          	jal	80002428 <devintr>
    800024d6:	892a                	mv	s2,a0
    800024d8:	c135                	beqz	a0,8000253c <usertrap+0xa4>
  if(killed(p))
    800024da:	8526                	mv	a0,s1
    800024dc:	b65ff0ef          	jal	80002040 <killed>
    800024e0:	cd1d                	beqz	a0,8000251e <usertrap+0x86>
    800024e2:	a81d                	j	80002518 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800024e4:	00005517          	auipc	a0,0x5
    800024e8:	e7450513          	add	a0,a0,-396 # 80007358 <states.0+0x58>
    800024ec:	a72fe0ef          	jal	8000075e <panic>
    if(killed(p))
    800024f0:	b51ff0ef          	jal	80002040 <killed>
    800024f4:	e121                	bnez	a0,80002534 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800024f6:	70b8                	ld	a4,96(s1)
    800024f8:	6f1c                	ld	a5,24(a4)
    800024fa:	0791                	add	a5,a5,4
    800024fc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002502:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002506:	10079073          	csrw	sstatus,a5
    syscall();
    8000250a:	248000ef          	jal	80002752 <syscall>
  if(killed(p))
    8000250e:	8526                	mv	a0,s1
    80002510:	b31ff0ef          	jal	80002040 <killed>
    80002514:	c901                	beqz	a0,80002524 <usertrap+0x8c>
    80002516:	4901                	li	s2,0
    exit(-1);
    80002518:	557d                	li	a0,-1
    8000251a:	9fbff0ef          	jal	80001f14 <exit>
  if(which_dev == 2)
    8000251e:	4789                	li	a5,2
    80002520:	04f90563          	beq	s2,a5,8000256a <usertrap+0xd2>
  usertrapret();
    80002524:	e1fff0ef          	jal	80002342 <usertrapret>
}
    80002528:	60e2                	ld	ra,24(sp)
    8000252a:	6442                	ld	s0,16(sp)
    8000252c:	64a2                	ld	s1,8(sp)
    8000252e:	6902                	ld	s2,0(sp)
    80002530:	6105                	add	sp,sp,32
    80002532:	8082                	ret
      exit(-1);
    80002534:	557d                	li	a0,-1
    80002536:	9dfff0ef          	jal	80001f14 <exit>
    8000253a:	bf75                	j	800024f6 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000253c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002540:	5890                	lw	a2,48(s1)
    80002542:	00005517          	auipc	a0,0x5
    80002546:	e3650513          	add	a0,a0,-458 # 80007378 <states.0+0x78>
    8000254a:	f55fd0ef          	jal	8000049e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000254e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002552:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002556:	00005517          	auipc	a0,0x5
    8000255a:	e5250513          	add	a0,a0,-430 # 800073a8 <states.0+0xa8>
    8000255e:	f41fd0ef          	jal	8000049e <printf>
    setkilled(p);
    80002562:	8526                	mv	a0,s1
    80002564:	ab9ff0ef          	jal	8000201c <setkilled>
    80002568:	b75d                	j	8000250e <usertrap+0x76>
    yield();
    8000256a:	873ff0ef          	jal	80001ddc <yield>
    8000256e:	bf5d                	j	80002524 <usertrap+0x8c>

0000000080002570 <kerneltrap>:
{
    80002570:	7179                	add	sp,sp,-48
    80002572:	f406                	sd	ra,40(sp)
    80002574:	f022                	sd	s0,32(sp)
    80002576:	ec26                	sd	s1,24(sp)
    80002578:	e84a                	sd	s2,16(sp)
    8000257a:	e44e                	sd	s3,8(sp)
    8000257c:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000257e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002582:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002586:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000258a:	1004f793          	and	a5,s1,256
    8000258e:	c795                	beqz	a5,800025ba <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002590:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002594:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002596:	eb85                	bnez	a5,800025c6 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002598:	e91ff0ef          	jal	80002428 <devintr>
    8000259c:	c91d                	beqz	a0,800025d2 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000259e:	4789                	li	a5,2
    800025a0:	04f50a63          	beq	a0,a5,800025f4 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025a4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025a8:	10049073          	csrw	sstatus,s1
}
    800025ac:	70a2                	ld	ra,40(sp)
    800025ae:	7402                	ld	s0,32(sp)
    800025b0:	64e2                	ld	s1,24(sp)
    800025b2:	6942                	ld	s2,16(sp)
    800025b4:	69a2                	ld	s3,8(sp)
    800025b6:	6145                	add	sp,sp,48
    800025b8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800025ba:	00005517          	auipc	a0,0x5
    800025be:	e1650513          	add	a0,a0,-490 # 800073d0 <states.0+0xd0>
    800025c2:	99cfe0ef          	jal	8000075e <panic>
    panic("kerneltrap: interrupts enabled");
    800025c6:	00005517          	auipc	a0,0x5
    800025ca:	e3250513          	add	a0,a0,-462 # 800073f8 <states.0+0xf8>
    800025ce:	990fe0ef          	jal	8000075e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025d2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025d6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800025da:	85ce                	mv	a1,s3
    800025dc:	00005517          	auipc	a0,0x5
    800025e0:	e3c50513          	add	a0,a0,-452 # 80007418 <states.0+0x118>
    800025e4:	ebbfd0ef          	jal	8000049e <printf>
    panic("kerneltrap");
    800025e8:	00005517          	auipc	a0,0x5
    800025ec:	e5850513          	add	a0,a0,-424 # 80007440 <states.0+0x140>
    800025f0:	96efe0ef          	jal	8000075e <panic>
  if(which_dev == 2 && myproc() != 0)
    800025f4:	a3cff0ef          	jal	80001830 <myproc>
    800025f8:	d555                	beqz	a0,800025a4 <kerneltrap+0x34>
    yield();
    800025fa:	fe2ff0ef          	jal	80001ddc <yield>
    800025fe:	b75d                	j	800025a4 <kerneltrap+0x34>

0000000080002600 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002600:	1101                	add	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	1000                	add	s0,sp,32
    8000260a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000260c:	a24ff0ef          	jal	80001830 <myproc>
  switch (n) {
    80002610:	4795                	li	a5,5
    80002612:	0497e163          	bltu	a5,s1,80002654 <argraw+0x54>
    80002616:	048a                	sll	s1,s1,0x2
    80002618:	00005717          	auipc	a4,0x5
    8000261c:	f2070713          	add	a4,a4,-224 # 80007538 <states.0+0x238>
    80002620:	94ba                	add	s1,s1,a4
    80002622:	409c                	lw	a5,0(s1)
    80002624:	97ba                	add	a5,a5,a4
    80002626:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002628:	713c                	ld	a5,96(a0)
    8000262a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000262c:	60e2                	ld	ra,24(sp)
    8000262e:	6442                	ld	s0,16(sp)
    80002630:	64a2                	ld	s1,8(sp)
    80002632:	6105                	add	sp,sp,32
    80002634:	8082                	ret
    return p->trapframe->a1;
    80002636:	713c                	ld	a5,96(a0)
    80002638:	7fa8                	ld	a0,120(a5)
    8000263a:	bfcd                	j	8000262c <argraw+0x2c>
    return p->trapframe->a2;
    8000263c:	713c                	ld	a5,96(a0)
    8000263e:	63c8                	ld	a0,128(a5)
    80002640:	b7f5                	j	8000262c <argraw+0x2c>
    return p->trapframe->a3;
    80002642:	713c                	ld	a5,96(a0)
    80002644:	67c8                	ld	a0,136(a5)
    80002646:	b7dd                	j	8000262c <argraw+0x2c>
    return p->trapframe->a4;
    80002648:	713c                	ld	a5,96(a0)
    8000264a:	6bc8                	ld	a0,144(a5)
    8000264c:	b7c5                	j	8000262c <argraw+0x2c>
    return p->trapframe->a5;
    8000264e:	713c                	ld	a5,96(a0)
    80002650:	6fc8                	ld	a0,152(a5)
    80002652:	bfe9                	j	8000262c <argraw+0x2c>
  panic("argraw");
    80002654:	00005517          	auipc	a0,0x5
    80002658:	dfc50513          	add	a0,a0,-516 # 80007450 <states.0+0x150>
    8000265c:	902fe0ef          	jal	8000075e <panic>

0000000080002660 <fetchaddr>:
{
    80002660:	1101                	add	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	e04a                	sd	s2,0(sp)
    8000266a:	1000                	add	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
    8000266e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002670:	9c0ff0ef          	jal	80001830 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80002674:	693c                	ld	a5,80(a0)
    80002676:	02f4f663          	bgeu	s1,a5,800026a2 <fetchaddr+0x42>
    8000267a:	00848713          	add	a4,s1,8
    8000267e:	02e7e463          	bltu	a5,a4,800026a6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002682:	46a1                	li	a3,8
    80002684:	8626                	mv	a2,s1
    80002686:	85ca                	mv	a1,s2
    80002688:	6d28                	ld	a0,88(a0)
    8000268a:	f17fe0ef          	jal	800015a0 <copyin>
    8000268e:	00a03533          	snez	a0,a0
    80002692:	40a00533          	neg	a0,a0
}
    80002696:	60e2                	ld	ra,24(sp)
    80002698:	6442                	ld	s0,16(sp)
    8000269a:	64a2                	ld	s1,8(sp)
    8000269c:	6902                	ld	s2,0(sp)
    8000269e:	6105                	add	sp,sp,32
    800026a0:	8082                	ret
    return -1;
    800026a2:	557d                	li	a0,-1
    800026a4:	bfcd                	j	80002696 <fetchaddr+0x36>
    800026a6:	557d                	li	a0,-1
    800026a8:	b7fd                	j	80002696 <fetchaddr+0x36>

00000000800026aa <fetchstr>:
{
    800026aa:	7179                	add	sp,sp,-48
    800026ac:	f406                	sd	ra,40(sp)
    800026ae:	f022                	sd	s0,32(sp)
    800026b0:	ec26                	sd	s1,24(sp)
    800026b2:	e84a                	sd	s2,16(sp)
    800026b4:	e44e                	sd	s3,8(sp)
    800026b6:	1800                	add	s0,sp,48
    800026b8:	892a                	mv	s2,a0
    800026ba:	84ae                	mv	s1,a1
    800026bc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800026be:	972ff0ef          	jal	80001830 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800026c2:	86ce                	mv	a3,s3
    800026c4:	864a                	mv	a2,s2
    800026c6:	85a6                	mv	a1,s1
    800026c8:	6d28                	ld	a0,88(a0)
    800026ca:	f5dfe0ef          	jal	80001626 <copyinstr>
    800026ce:	00054c63          	bltz	a0,800026e6 <fetchstr+0x3c>
  return strlen(buf);
    800026d2:	8526                	mv	a0,s1
    800026d4:	f16fe0ef          	jal	80000dea <strlen>
}
    800026d8:	70a2                	ld	ra,40(sp)
    800026da:	7402                	ld	s0,32(sp)
    800026dc:	64e2                	ld	s1,24(sp)
    800026de:	6942                	ld	s2,16(sp)
    800026e0:	69a2                	ld	s3,8(sp)
    800026e2:	6145                	add	sp,sp,48
    800026e4:	8082                	ret
    return -1;
    800026e6:	557d                	li	a0,-1
    800026e8:	bfc5                	j	800026d8 <fetchstr+0x2e>

00000000800026ea <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    800026ea:	1101                	add	sp,sp,-32
    800026ec:	ec06                	sd	ra,24(sp)
    800026ee:	e822                	sd	s0,16(sp)
    800026f0:	e426                	sd	s1,8(sp)
    800026f2:	1000                	add	s0,sp,32
    800026f4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800026f6:	f0bff0ef          	jal	80002600 <argraw>
    800026fa:	c088                	sw	a0,0(s1)
}
    800026fc:	60e2                	ld	ra,24(sp)
    800026fe:	6442                	ld	s0,16(sp)
    80002700:	64a2                	ld	s1,8(sp)
    80002702:	6105                	add	sp,sp,32
    80002704:	8082                	ret

0000000080002706 <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    80002706:	1101                	add	sp,sp,-32
    80002708:	ec06                	sd	ra,24(sp)
    8000270a:	e822                	sd	s0,16(sp)
    8000270c:	e426                	sd	s1,8(sp)
    8000270e:	1000                	add	s0,sp,32
    80002710:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002712:	eefff0ef          	jal	80002600 <argraw>
    80002716:	e088                	sd	a0,0(s1)
}
    80002718:	60e2                	ld	ra,24(sp)
    8000271a:	6442                	ld	s0,16(sp)
    8000271c:	64a2                	ld	s1,8(sp)
    8000271e:	6105                	add	sp,sp,32
    80002720:	8082                	ret

0000000080002722 <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80002722:	7179                	add	sp,sp,-48
    80002724:	f406                	sd	ra,40(sp)
    80002726:	f022                	sd	s0,32(sp)
    80002728:	ec26                	sd	s1,24(sp)
    8000272a:	e84a                	sd	s2,16(sp)
    8000272c:	1800                	add	s0,sp,48
    8000272e:	84ae                	mv	s1,a1
    80002730:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002732:	fd840593          	add	a1,s0,-40
    80002736:	fd1ff0ef          	jal	80002706 <argaddr>
  return fetchstr(addr, buf, max);
    8000273a:	864a                	mv	a2,s2
    8000273c:	85a6                	mv	a1,s1
    8000273e:	fd843503          	ld	a0,-40(s0)
    80002742:	f69ff0ef          	jal	800026aa <fetchstr>
}
    80002746:	70a2                	ld	ra,40(sp)
    80002748:	7402                	ld	s0,32(sp)
    8000274a:	64e2                	ld	s1,24(sp)
    8000274c:	6942                	ld	s2,16(sp)
    8000274e:	6145                	add	sp,sp,48
    80002750:	8082                	ret

0000000080002752 <syscall>:



void
syscall(void)
{
    80002752:	7179                	add	sp,sp,-48
    80002754:	f406                	sd	ra,40(sp)
    80002756:	f022                	sd	s0,32(sp)
    80002758:	ec26                	sd	s1,24(sp)
    8000275a:	e84a                	sd	s2,16(sp)
    8000275c:	e44e                	sd	s3,8(sp)
    8000275e:	1800                	add	s0,sp,48
    int num;
    struct proc *p = myproc();
    80002760:	8d0ff0ef          	jal	80001830 <myproc>
    80002764:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002766:	06053903          	ld	s2,96(a0)
    8000276a:	0a893783          	ld	a5,168(s2)
    8000276e:	0007899b          	sext.w	s3,a5
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002772:	37fd                	addw	a5,a5,-1
    80002774:	4755                	li	a4,21
    80002776:	04f76463          	bltu	a4,a5,800027be <syscall+0x6c>
    8000277a:	00399713          	sll	a4,s3,0x3
    8000277e:	00005797          	auipc	a5,0x5
    80002782:	dd278793          	add	a5,a5,-558 # 80007550 <syscalls>
    80002786:	97ba                	add	a5,a5,a4
    80002788:	639c                	ld	a5,0(a5)
    8000278a:	cb95                	beqz	a5,800027be <syscall+0x6c>
        /* Use num to lookup the system call function for num, call it, */
        /* and store its return value in p->trapframe->a0 */
        p->trapframe->a0 = syscalls[num]();
    8000278c:	9782                	jalr	a5
    8000278e:	06a93823          	sd	a0,112(s2)

        /* Assignment 1E update */
        if((p->trace_mask & (1 << num)) != 0){
    80002792:	40bc                	lw	a5,64(s1)
    80002794:	4137d7bb          	sraw	a5,a5,s3
    80002798:	8b85                	and	a5,a5,1
    8000279a:	cf9d                	beqz	a5,800027d8 <syscall+0x86>
            int checkPoint = (num < NELEM(syscalls_names));
            char* name = (checkPoint) ? syscalls_names[num] : "unknown"; 

            printf("%d: syscall %s -> %ld\n", p->pid, name, p->trapframe->a0);
    8000279c:	70b8                	ld	a4,96(s1)
            char* name = (checkPoint) ? syscalls_names[num] : "unknown"; 
    8000279e:	098e                	sll	s3,s3,0x3
    800027a0:	00005797          	auipc	a5,0x5
    800027a4:	db078793          	add	a5,a5,-592 # 80007550 <syscalls>
    800027a8:	97ce                	add	a5,a5,s3
            printf("%d: syscall %s -> %ld\n", p->pid, name, p->trapframe->a0);
    800027aa:	7b34                	ld	a3,112(a4)
    800027ac:	7fd0                	ld	a2,184(a5)
    800027ae:	588c                	lw	a1,48(s1)
    800027b0:	00005517          	auipc	a0,0x5
    800027b4:	ca850513          	add	a0,a0,-856 # 80007458 <states.0+0x158>
    800027b8:	ce7fd0ef          	jal	8000049e <printf>
    800027bc:	a831                	j	800027d8 <syscall+0x86>
        }
    
    } else {
        printf("%d %s: unknown sys call %d\n",
    800027be:	86ce                	mv	a3,s3
    800027c0:	16048613          	add	a2,s1,352
    800027c4:	588c                	lw	a1,48(s1)
    800027c6:	00005517          	auipc	a0,0x5
    800027ca:	caa50513          	add	a0,a0,-854 # 80007470 <states.0+0x170>
    800027ce:	cd1fd0ef          	jal	8000049e <printf>
            p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800027d2:	70bc                	ld	a5,96(s1)
    800027d4:	577d                	li	a4,-1
    800027d6:	fbb8                	sd	a4,112(a5)
    }
}
    800027d8:	70a2                	ld	ra,40(sp)
    800027da:	7402                	ld	s0,32(sp)
    800027dc:	64e2                	ld	s1,24(sp)
    800027de:	6942                	ld	s2,16(sp)
    800027e0:	69a2                	ld	s3,8(sp)
    800027e2:	6145                	add	sp,sp,48
    800027e4:	8082                	ret

00000000800027e6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800027e6:	1101                	add	sp,sp,-32
    800027e8:	ec06                	sd	ra,24(sp)
    800027ea:	e822                	sd	s0,16(sp)
    800027ec:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800027ee:	fec40593          	add	a1,s0,-20
    800027f2:	4501                	li	a0,0
    800027f4:	ef7ff0ef          	jal	800026ea <argint>
  exit(n);
    800027f8:	fec42503          	lw	a0,-20(s0)
    800027fc:	f18ff0ef          	jal	80001f14 <exit>
  return 0;  /* not reached */
}
    80002800:	4501                	li	a0,0
    80002802:	60e2                	ld	ra,24(sp)
    80002804:	6442                	ld	s0,16(sp)
    80002806:	6105                	add	sp,sp,32
    80002808:	8082                	ret

000000008000280a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000280a:	1141                	add	sp,sp,-16
    8000280c:	e406                	sd	ra,8(sp)
    8000280e:	e022                	sd	s0,0(sp)
    80002810:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002812:	81eff0ef          	jal	80001830 <myproc>
}
    80002816:	5908                	lw	a0,48(a0)
    80002818:	60a2                	ld	ra,8(sp)
    8000281a:	6402                	ld	s0,0(sp)
    8000281c:	0141                	add	sp,sp,16
    8000281e:	8082                	ret

0000000080002820 <sys_fork>:

uint64
sys_fork(void)
{
    80002820:	1141                	add	sp,sp,-16
    80002822:	e406                	sd	ra,8(sp)
    80002824:	e022                	sd	s0,0(sp)
    80002826:	0800                	add	s0,sp,16
  return fork();
    80002828:	b32ff0ef          	jal	80001b5a <fork>
}
    8000282c:	60a2                	ld	ra,8(sp)
    8000282e:	6402                	ld	s0,0(sp)
    80002830:	0141                	add	sp,sp,16
    80002832:	8082                	ret

0000000080002834 <sys_wait>:

uint64
sys_wait(void)
{
    80002834:	1101                	add	sp,sp,-32
    80002836:	ec06                	sd	ra,24(sp)
    80002838:	e822                	sd	s0,16(sp)
    8000283a:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000283c:	fe840593          	add	a1,s0,-24
    80002840:	4501                	li	a0,0
    80002842:	ec5ff0ef          	jal	80002706 <argaddr>
  return wait(p);
    80002846:	fe843503          	ld	a0,-24(s0)
    8000284a:	821ff0ef          	jal	8000206a <wait>
}
    8000284e:	60e2                	ld	ra,24(sp)
    80002850:	6442                	ld	s0,16(sp)
    80002852:	6105                	add	sp,sp,32
    80002854:	8082                	ret

0000000080002856 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002856:	7179                	add	sp,sp,-48
    80002858:	f406                	sd	ra,40(sp)
    8000285a:	f022                	sd	s0,32(sp)
    8000285c:	ec26                	sd	s1,24(sp)
    8000285e:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002860:	fdc40593          	add	a1,s0,-36
    80002864:	4501                	li	a0,0
    80002866:	e85ff0ef          	jal	800026ea <argint>
  addr = myproc()->sz;
    8000286a:	fc7fe0ef          	jal	80001830 <myproc>
    8000286e:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002870:	fdc42503          	lw	a0,-36(s0)
    80002874:	a96ff0ef          	jal	80001b0a <growproc>
    80002878:	00054863          	bltz	a0,80002888 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    8000287c:	8526                	mv	a0,s1
    8000287e:	70a2                	ld	ra,40(sp)
    80002880:	7402                	ld	s0,32(sp)
    80002882:	64e2                	ld	s1,24(sp)
    80002884:	6145                	add	sp,sp,48
    80002886:	8082                	ret
    return -1;
    80002888:	54fd                	li	s1,-1
    8000288a:	bfcd                	j	8000287c <sys_sbrk+0x26>

000000008000288c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000288c:	7139                	add	sp,sp,-64
    8000288e:	fc06                	sd	ra,56(sp)
    80002890:	f822                	sd	s0,48(sp)
    80002892:	f426                	sd	s1,40(sp)
    80002894:	f04a                	sd	s2,32(sp)
    80002896:	ec4e                	sd	s3,24(sp)
    80002898:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000289a:	fcc40593          	add	a1,s0,-52
    8000289e:	4501                	li	a0,0
    800028a0:	e4bff0ef          	jal	800026ea <argint>
  if(n < 0)
    800028a4:	fcc42783          	lw	a5,-52(s0)
    800028a8:	0607c563          	bltz	a5,80002912 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    800028ac:	00013517          	auipc	a0,0x13
    800028b0:	33450513          	add	a0,a0,820 # 80015be0 <tickslock>
    800028b4:	aecfe0ef          	jal	80000ba0 <acquire>
  ticks0 = ticks;
    800028b8:	00005917          	auipc	s2,0x5
    800028bc:	1c892903          	lw	s2,456(s2) # 80007a80 <ticks>
  while(ticks - ticks0 < n){
    800028c0:	fcc42783          	lw	a5,-52(s0)
    800028c4:	cb8d                	beqz	a5,800028f6 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800028c6:	00013997          	auipc	s3,0x13
    800028ca:	31a98993          	add	s3,s3,794 # 80015be0 <tickslock>
    800028ce:	00005497          	auipc	s1,0x5
    800028d2:	1b248493          	add	s1,s1,434 # 80007a80 <ticks>
    if(killed(myproc())){
    800028d6:	f5bfe0ef          	jal	80001830 <myproc>
    800028da:	f66ff0ef          	jal	80002040 <killed>
    800028de:	ed0d                	bnez	a0,80002918 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800028e0:	85ce                	mv	a1,s3
    800028e2:	8526                	mv	a0,s1
    800028e4:	d24ff0ef          	jal	80001e08 <sleep>
  while(ticks - ticks0 < n){
    800028e8:	409c                	lw	a5,0(s1)
    800028ea:	412787bb          	subw	a5,a5,s2
    800028ee:	fcc42703          	lw	a4,-52(s0)
    800028f2:	fee7e2e3          	bltu	a5,a4,800028d6 <sys_sleep+0x4a>
  }
  release(&tickslock);
    800028f6:	00013517          	auipc	a0,0x13
    800028fa:	2ea50513          	add	a0,a0,746 # 80015be0 <tickslock>
    800028fe:	b3afe0ef          	jal	80000c38 <release>
  return 0;
    80002902:	4501                	li	a0,0
}
    80002904:	70e2                	ld	ra,56(sp)
    80002906:	7442                	ld	s0,48(sp)
    80002908:	74a2                	ld	s1,40(sp)
    8000290a:	7902                	ld	s2,32(sp)
    8000290c:	69e2                	ld	s3,24(sp)
    8000290e:	6121                	add	sp,sp,64
    80002910:	8082                	ret
    n = 0;
    80002912:	fc042623          	sw	zero,-52(s0)
    80002916:	bf59                	j	800028ac <sys_sleep+0x20>
      release(&tickslock);
    80002918:	00013517          	auipc	a0,0x13
    8000291c:	2c850513          	add	a0,a0,712 # 80015be0 <tickslock>
    80002920:	b18fe0ef          	jal	80000c38 <release>
      return -1;
    80002924:	557d                	li	a0,-1
    80002926:	bff9                	j	80002904 <sys_sleep+0x78>

0000000080002928 <sys_kill>:

uint64
sys_kill(void)
{
    80002928:	1101                	add	sp,sp,-32
    8000292a:	ec06                	sd	ra,24(sp)
    8000292c:	e822                	sd	s0,16(sp)
    8000292e:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002930:	fec40593          	add	a1,s0,-20
    80002934:	4501                	li	a0,0
    80002936:	db5ff0ef          	jal	800026ea <argint>
  return kill(pid);
    8000293a:	fec42503          	lw	a0,-20(s0)
    8000293e:	e78ff0ef          	jal	80001fb6 <kill>
}
    80002942:	60e2                	ld	ra,24(sp)
    80002944:	6442                	ld	s0,16(sp)
    80002946:	6105                	add	sp,sp,32
    80002948:	8082                	ret

000000008000294a <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    8000294a:	1101                	add	sp,sp,-32
    8000294c:	ec06                	sd	ra,24(sp)
    8000294e:	e822                	sd	s0,16(sp)
    80002950:	e426                	sd	s1,8(sp)
    80002952:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002954:	00013517          	auipc	a0,0x13
    80002958:	28c50513          	add	a0,a0,652 # 80015be0 <tickslock>
    8000295c:	a44fe0ef          	jal	80000ba0 <acquire>
  xticks = ticks;
    80002960:	00005497          	auipc	s1,0x5
    80002964:	1204a483          	lw	s1,288(s1) # 80007a80 <ticks>
  release(&tickslock);
    80002968:	00013517          	auipc	a0,0x13
    8000296c:	27850513          	add	a0,a0,632 # 80015be0 <tickslock>
    80002970:	ac8fe0ef          	jal	80000c38 <release>
  return xticks;
}
    80002974:	02049513          	sll	a0,s1,0x20
    80002978:	9101                	srl	a0,a0,0x20
    8000297a:	60e2                	ld	ra,24(sp)
    8000297c:	6442                	ld	s0,16(sp)
    8000297e:	64a2                	ld	s1,8(sp)
    80002980:	6105                	add	sp,sp,32
    80002982:	8082                	ret

0000000080002984 <sys_trace>:

/* Assignment 1E update */
uint64
sys_trace(void)
{
    80002984:	1101                	add	sp,sp,-32
    80002986:	ec06                	sd	ra,24(sp)
    80002988:	e822                	sd	s0,16(sp)
    8000298a:	1000                	add	s0,sp,32
    int mask;
    
    argint(0, &mask);
    8000298c:	fec40593          	add	a1,s0,-20
    80002990:	4501                	li	a0,0
    80002992:	d59ff0ef          	jal	800026ea <argint>
    
    myproc()->trace_mask = mask;
    80002996:	e9bfe0ef          	jal	80001830 <myproc>
    8000299a:	fec42783          	lw	a5,-20(s0)
    8000299e:	c13c                	sw	a5,64(a0)
    
    return 0;  /* not reached */
}
    800029a0:	4501                	li	a0,0
    800029a2:	60e2                	ld	ra,24(sp)
    800029a4:	6442                	ld	s0,16(sp)
    800029a6:	6105                	add	sp,sp,32
    800029a8:	8082                	ret

00000000800029aa <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800029aa:	7179                	add	sp,sp,-48
    800029ac:	f406                	sd	ra,40(sp)
    800029ae:	f022                	sd	s0,32(sp)
    800029b0:	ec26                	sd	s1,24(sp)
    800029b2:	e84a                	sd	s2,16(sp)
    800029b4:	e44e                	sd	s3,8(sp)
    800029b6:	e052                	sd	s4,0(sp)
    800029b8:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800029ba:	00005597          	auipc	a1,0x5
    800029be:	d0658593          	add	a1,a1,-762 # 800076c0 <syscalls_names+0xb8>
    800029c2:	00013517          	auipc	a0,0x13
    800029c6:	23650513          	add	a0,a0,566 # 80015bf8 <bcache>
    800029ca:	956fe0ef          	jal	80000b20 <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    800029ce:	0001b797          	auipc	a5,0x1b
    800029d2:	22a78793          	add	a5,a5,554 # 8001dbf8 <bcache+0x8000>
    800029d6:	0001b717          	auipc	a4,0x1b
    800029da:	48a70713          	add	a4,a4,1162 # 8001de60 <bcache+0x8268>
    800029de:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800029e2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029e6:	00013497          	auipc	s1,0x13
    800029ea:	22a48493          	add	s1,s1,554 # 80015c10 <bcache+0x18>
    b->next = bcache.head.next;
    800029ee:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800029f0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800029f2:	00005a17          	auipc	s4,0x5
    800029f6:	cd6a0a13          	add	s4,s4,-810 # 800076c8 <syscalls_names+0xc0>
    b->next = bcache.head.next;
    800029fa:	2b893783          	ld	a5,696(s2)
    800029fe:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002a00:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002a04:	85d2                	mv	a1,s4
    80002a06:	01048513          	add	a0,s1,16
    80002a0a:	1f6010ef          	jal	80003c00 <initsleeplock>
    bcache.head.next->prev = b;
    80002a0e:	2b893783          	ld	a5,696(s2)
    80002a12:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002a14:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002a18:	45848493          	add	s1,s1,1112
    80002a1c:	fd349fe3          	bne	s1,s3,800029fa <binit+0x50>
  }
}
    80002a20:	70a2                	ld	ra,40(sp)
    80002a22:	7402                	ld	s0,32(sp)
    80002a24:	64e2                	ld	s1,24(sp)
    80002a26:	6942                	ld	s2,16(sp)
    80002a28:	69a2                	ld	s3,8(sp)
    80002a2a:	6a02                	ld	s4,0(sp)
    80002a2c:	6145                	add	sp,sp,48
    80002a2e:	8082                	ret

0000000080002a30 <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    80002a30:	7179                	add	sp,sp,-48
    80002a32:	f406                	sd	ra,40(sp)
    80002a34:	f022                	sd	s0,32(sp)
    80002a36:	ec26                	sd	s1,24(sp)
    80002a38:	e84a                	sd	s2,16(sp)
    80002a3a:	e44e                	sd	s3,8(sp)
    80002a3c:	1800                	add	s0,sp,48
    80002a3e:	892a                	mv	s2,a0
    80002a40:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002a42:	00013517          	auipc	a0,0x13
    80002a46:	1b650513          	add	a0,a0,438 # 80015bf8 <bcache>
    80002a4a:	956fe0ef          	jal	80000ba0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002a4e:	0001b497          	auipc	s1,0x1b
    80002a52:	4624b483          	ld	s1,1122(s1) # 8001deb0 <bcache+0x82b8>
    80002a56:	0001b797          	auipc	a5,0x1b
    80002a5a:	40a78793          	add	a5,a5,1034 # 8001de60 <bcache+0x8268>
    80002a5e:	02f48b63          	beq	s1,a5,80002a94 <bread+0x64>
    80002a62:	873e                	mv	a4,a5
    80002a64:	a021                	j	80002a6c <bread+0x3c>
    80002a66:	68a4                	ld	s1,80(s1)
    80002a68:	02e48663          	beq	s1,a4,80002a94 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002a6c:	449c                	lw	a5,8(s1)
    80002a6e:	ff279ce3          	bne	a5,s2,80002a66 <bread+0x36>
    80002a72:	44dc                	lw	a5,12(s1)
    80002a74:	ff3799e3          	bne	a5,s3,80002a66 <bread+0x36>
      b->refcnt++;
    80002a78:	40bc                	lw	a5,64(s1)
    80002a7a:	2785                	addw	a5,a5,1
    80002a7c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a7e:	00013517          	auipc	a0,0x13
    80002a82:	17a50513          	add	a0,a0,378 # 80015bf8 <bcache>
    80002a86:	9b2fe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002a8a:	01048513          	add	a0,s1,16
    80002a8e:	1a8010ef          	jal	80003c36 <acquiresleep>
      return b;
    80002a92:	a889                	j	80002ae4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a94:	0001b497          	auipc	s1,0x1b
    80002a98:	4144b483          	ld	s1,1044(s1) # 8001dea8 <bcache+0x82b0>
    80002a9c:	0001b797          	auipc	a5,0x1b
    80002aa0:	3c478793          	add	a5,a5,964 # 8001de60 <bcache+0x8268>
    80002aa4:	00f48863          	beq	s1,a5,80002ab4 <bread+0x84>
    80002aa8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002aaa:	40bc                	lw	a5,64(s1)
    80002aac:	cb91                	beqz	a5,80002ac0 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002aae:	64a4                	ld	s1,72(s1)
    80002ab0:	fee49de3          	bne	s1,a4,80002aaa <bread+0x7a>
  panic("bget: no buffers");
    80002ab4:	00005517          	auipc	a0,0x5
    80002ab8:	c1c50513          	add	a0,a0,-996 # 800076d0 <syscalls_names+0xc8>
    80002abc:	ca3fd0ef          	jal	8000075e <panic>
      b->dev = dev;
    80002ac0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002ac4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002ac8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002acc:	4785                	li	a5,1
    80002ace:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ad0:	00013517          	auipc	a0,0x13
    80002ad4:	12850513          	add	a0,a0,296 # 80015bf8 <bcache>
    80002ad8:	960fe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002adc:	01048513          	add	a0,s1,16
    80002ae0:	156010ef          	jal	80003c36 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ae4:	409c                	lw	a5,0(s1)
    80002ae6:	cb89                	beqz	a5,80002af8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ae8:	8526                	mv	a0,s1
    80002aea:	70a2                	ld	ra,40(sp)
    80002aec:	7402                	ld	s0,32(sp)
    80002aee:	64e2                	ld	s1,24(sp)
    80002af0:	6942                	ld	s2,16(sp)
    80002af2:	69a2                	ld	s3,8(sp)
    80002af4:	6145                	add	sp,sp,48
    80002af6:	8082                	ret
    virtio_disk_rw(b, 0);
    80002af8:	4581                	li	a1,0
    80002afa:	8526                	mv	a0,s1
    80002afc:	07f020ef          	jal	8000537a <virtio_disk_rw>
    b->valid = 1;
    80002b00:	4785                	li	a5,1
    80002b02:	c09c                	sw	a5,0(s1)
  return b;
    80002b04:	b7d5                	j	80002ae8 <bread+0xb8>

0000000080002b06 <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    80002b06:	1101                	add	sp,sp,-32
    80002b08:	ec06                	sd	ra,24(sp)
    80002b0a:	e822                	sd	s0,16(sp)
    80002b0c:	e426                	sd	s1,8(sp)
    80002b0e:	1000                	add	s0,sp,32
    80002b10:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b12:	0541                	add	a0,a0,16
    80002b14:	1a0010ef          	jal	80003cb4 <holdingsleep>
    80002b18:	c911                	beqz	a0,80002b2c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002b1a:	4585                	li	a1,1
    80002b1c:	8526                	mv	a0,s1
    80002b1e:	05d020ef          	jal	8000537a <virtio_disk_rw>
}
    80002b22:	60e2                	ld	ra,24(sp)
    80002b24:	6442                	ld	s0,16(sp)
    80002b26:	64a2                	ld	s1,8(sp)
    80002b28:	6105                	add	sp,sp,32
    80002b2a:	8082                	ret
    panic("bwrite");
    80002b2c:	00005517          	auipc	a0,0x5
    80002b30:	bbc50513          	add	a0,a0,-1092 # 800076e8 <syscalls_names+0xe0>
    80002b34:	c2bfd0ef          	jal	8000075e <panic>

0000000080002b38 <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    80002b38:	1101                	add	sp,sp,-32
    80002b3a:	ec06                	sd	ra,24(sp)
    80002b3c:	e822                	sd	s0,16(sp)
    80002b3e:	e426                	sd	s1,8(sp)
    80002b40:	e04a                	sd	s2,0(sp)
    80002b42:	1000                	add	s0,sp,32
    80002b44:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002b46:	01050913          	add	s2,a0,16
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	168010ef          	jal	80003cb4 <holdingsleep>
    80002b50:	c135                	beqz	a0,80002bb4 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002b52:	854a                	mv	a0,s2
    80002b54:	128010ef          	jal	80003c7c <releasesleep>

  acquire(&bcache.lock);
    80002b58:	00013517          	auipc	a0,0x13
    80002b5c:	0a050513          	add	a0,a0,160 # 80015bf8 <bcache>
    80002b60:	840fe0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002b64:	40bc                	lw	a5,64(s1)
    80002b66:	37fd                	addw	a5,a5,-1
    80002b68:	0007871b          	sext.w	a4,a5
    80002b6c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002b6e:	e71d                	bnez	a4,80002b9c <brelse+0x64>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    80002b70:	68b8                	ld	a4,80(s1)
    80002b72:	64bc                	ld	a5,72(s1)
    80002b74:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002b76:	68b8                	ld	a4,80(s1)
    80002b78:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002b7a:	0001b797          	auipc	a5,0x1b
    80002b7e:	07e78793          	add	a5,a5,126 # 8001dbf8 <bcache+0x8000>
    80002b82:	2b87b703          	ld	a4,696(a5)
    80002b86:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002b88:	0001b717          	auipc	a4,0x1b
    80002b8c:	2d870713          	add	a4,a4,728 # 8001de60 <bcache+0x8268>
    80002b90:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002b92:	2b87b703          	ld	a4,696(a5)
    80002b96:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002b98:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002b9c:	00013517          	auipc	a0,0x13
    80002ba0:	05c50513          	add	a0,a0,92 # 80015bf8 <bcache>
    80002ba4:	894fe0ef          	jal	80000c38 <release>
}
    80002ba8:	60e2                	ld	ra,24(sp)
    80002baa:	6442                	ld	s0,16(sp)
    80002bac:	64a2                	ld	s1,8(sp)
    80002bae:	6902                	ld	s2,0(sp)
    80002bb0:	6105                	add	sp,sp,32
    80002bb2:	8082                	ret
    panic("brelse");
    80002bb4:	00005517          	auipc	a0,0x5
    80002bb8:	b3c50513          	add	a0,a0,-1220 # 800076f0 <syscalls_names+0xe8>
    80002bbc:	ba3fd0ef          	jal	8000075e <panic>

0000000080002bc0 <bpin>:

void
bpin(struct buf *b) {
    80002bc0:	1101                	add	sp,sp,-32
    80002bc2:	ec06                	sd	ra,24(sp)
    80002bc4:	e822                	sd	s0,16(sp)
    80002bc6:	e426                	sd	s1,8(sp)
    80002bc8:	1000                	add	s0,sp,32
    80002bca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002bcc:	00013517          	auipc	a0,0x13
    80002bd0:	02c50513          	add	a0,a0,44 # 80015bf8 <bcache>
    80002bd4:	fcdfd0ef          	jal	80000ba0 <acquire>
  b->refcnt++;
    80002bd8:	40bc                	lw	a5,64(s1)
    80002bda:	2785                	addw	a5,a5,1
    80002bdc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002bde:	00013517          	auipc	a0,0x13
    80002be2:	01a50513          	add	a0,a0,26 # 80015bf8 <bcache>
    80002be6:	852fe0ef          	jal	80000c38 <release>
}
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6105                	add	sp,sp,32
    80002bf2:	8082                	ret

0000000080002bf4 <bunpin>:

void
bunpin(struct buf *b) {
    80002bf4:	1101                	add	sp,sp,-32
    80002bf6:	ec06                	sd	ra,24(sp)
    80002bf8:	e822                	sd	s0,16(sp)
    80002bfa:	e426                	sd	s1,8(sp)
    80002bfc:	1000                	add	s0,sp,32
    80002bfe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002c00:	00013517          	auipc	a0,0x13
    80002c04:	ff850513          	add	a0,a0,-8 # 80015bf8 <bcache>
    80002c08:	f99fd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002c0c:	40bc                	lw	a5,64(s1)
    80002c0e:	37fd                	addw	a5,a5,-1
    80002c10:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002c12:	00013517          	auipc	a0,0x13
    80002c16:	fe650513          	add	a0,a0,-26 # 80015bf8 <bcache>
    80002c1a:	81efe0ef          	jal	80000c38 <release>
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6105                	add	sp,sp,32
    80002c26:	8082                	ret

0000000080002c28 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    80002c28:	1101                	add	sp,sp,-32
    80002c2a:	ec06                	sd	ra,24(sp)
    80002c2c:	e822                	sd	s0,16(sp)
    80002c2e:	e426                	sd	s1,8(sp)
    80002c30:	e04a                	sd	s2,0(sp)
    80002c32:	1000                	add	s0,sp,32
    80002c34:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002c36:	00d5d59b          	srlw	a1,a1,0xd
    80002c3a:	0001b797          	auipc	a5,0x1b
    80002c3e:	69a7a783          	lw	a5,1690(a5) # 8001e2d4 <sb+0x1c>
    80002c42:	9dbd                	addw	a1,a1,a5
    80002c44:	dedff0ef          	jal	80002a30 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002c48:	0074f713          	and	a4,s1,7
    80002c4c:	4785                	li	a5,1
    80002c4e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002c52:	14ce                	sll	s1,s1,0x33
    80002c54:	90d9                	srl	s1,s1,0x36
    80002c56:	00950733          	add	a4,a0,s1
    80002c5a:	05874703          	lbu	a4,88(a4)
    80002c5e:	00e7f6b3          	and	a3,a5,a4
    80002c62:	c29d                	beqz	a3,80002c88 <bfree+0x60>
    80002c64:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002c66:	94aa                	add	s1,s1,a0
    80002c68:	fff7c793          	not	a5,a5
    80002c6c:	8f7d                	and	a4,a4,a5
    80002c6e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002c72:	6bf000ef          	jal	80003b30 <log_write>
  brelse(bp);
    80002c76:	854a                	mv	a0,s2
    80002c78:	ec1ff0ef          	jal	80002b38 <brelse>
}
    80002c7c:	60e2                	ld	ra,24(sp)
    80002c7e:	6442                	ld	s0,16(sp)
    80002c80:	64a2                	ld	s1,8(sp)
    80002c82:	6902                	ld	s2,0(sp)
    80002c84:	6105                	add	sp,sp,32
    80002c86:	8082                	ret
    panic("freeing free block");
    80002c88:	00005517          	auipc	a0,0x5
    80002c8c:	a7050513          	add	a0,a0,-1424 # 800076f8 <syscalls_names+0xf0>
    80002c90:	acffd0ef          	jal	8000075e <panic>

0000000080002c94 <balloc>:
{
    80002c94:	711d                	add	sp,sp,-96
    80002c96:	ec86                	sd	ra,88(sp)
    80002c98:	e8a2                	sd	s0,80(sp)
    80002c9a:	e4a6                	sd	s1,72(sp)
    80002c9c:	e0ca                	sd	s2,64(sp)
    80002c9e:	fc4e                	sd	s3,56(sp)
    80002ca0:	f852                	sd	s4,48(sp)
    80002ca2:	f456                	sd	s5,40(sp)
    80002ca4:	f05a                	sd	s6,32(sp)
    80002ca6:	ec5e                	sd	s7,24(sp)
    80002ca8:	e862                	sd	s8,16(sp)
    80002caa:	e466                	sd	s9,8(sp)
    80002cac:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002cae:	0001b797          	auipc	a5,0x1b
    80002cb2:	60e7a783          	lw	a5,1550(a5) # 8001e2bc <sb+0x4>
    80002cb6:	cff1                	beqz	a5,80002d92 <balloc+0xfe>
    80002cb8:	8baa                	mv	s7,a0
    80002cba:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002cbc:	0001bb17          	auipc	s6,0x1b
    80002cc0:	5fcb0b13          	add	s6,s6,1532 # 8001e2b8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002cc4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002cc6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002cc8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002cca:	6c89                	lui	s9,0x2
    80002ccc:	a0b5                	j	80002d38 <balloc+0xa4>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    80002cce:	97ca                	add	a5,a5,s2
    80002cd0:	8e55                	or	a2,a2,a3
    80002cd2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002cd6:	854a                	mv	a0,s2
    80002cd8:	659000ef          	jal	80003b30 <log_write>
        brelse(bp);
    80002cdc:	854a                	mv	a0,s2
    80002cde:	e5bff0ef          	jal	80002b38 <brelse>
  bp = bread(dev, bno);
    80002ce2:	85a6                	mv	a1,s1
    80002ce4:	855e                	mv	a0,s7
    80002ce6:	d4bff0ef          	jal	80002a30 <bread>
    80002cea:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002cec:	40000613          	li	a2,1024
    80002cf0:	4581                	li	a1,0
    80002cf2:	05850513          	add	a0,a0,88
    80002cf6:	f7ffd0ef          	jal	80000c74 <memset>
  log_write(bp);
    80002cfa:	854a                	mv	a0,s2
    80002cfc:	635000ef          	jal	80003b30 <log_write>
  brelse(bp);
    80002d00:	854a                	mv	a0,s2
    80002d02:	e37ff0ef          	jal	80002b38 <brelse>
}
    80002d06:	8526                	mv	a0,s1
    80002d08:	60e6                	ld	ra,88(sp)
    80002d0a:	6446                	ld	s0,80(sp)
    80002d0c:	64a6                	ld	s1,72(sp)
    80002d0e:	6906                	ld	s2,64(sp)
    80002d10:	79e2                	ld	s3,56(sp)
    80002d12:	7a42                	ld	s4,48(sp)
    80002d14:	7aa2                	ld	s5,40(sp)
    80002d16:	7b02                	ld	s6,32(sp)
    80002d18:	6be2                	ld	s7,24(sp)
    80002d1a:	6c42                	ld	s8,16(sp)
    80002d1c:	6ca2                	ld	s9,8(sp)
    80002d1e:	6125                	add	sp,sp,96
    80002d20:	8082                	ret
    brelse(bp);
    80002d22:	854a                	mv	a0,s2
    80002d24:	e15ff0ef          	jal	80002b38 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002d28:	015c87bb          	addw	a5,s9,s5
    80002d2c:	00078a9b          	sext.w	s5,a5
    80002d30:	004b2703          	lw	a4,4(s6)
    80002d34:	04eaff63          	bgeu	s5,a4,80002d92 <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002d38:	41fad79b          	sraw	a5,s5,0x1f
    80002d3c:	0137d79b          	srlw	a5,a5,0x13
    80002d40:	015787bb          	addw	a5,a5,s5
    80002d44:	40d7d79b          	sraw	a5,a5,0xd
    80002d48:	01cb2583          	lw	a1,28(s6)
    80002d4c:	9dbd                	addw	a1,a1,a5
    80002d4e:	855e                	mv	a0,s7
    80002d50:	ce1ff0ef          	jal	80002a30 <bread>
    80002d54:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d56:	004b2503          	lw	a0,4(s6)
    80002d5a:	000a849b          	sext.w	s1,s5
    80002d5e:	8762                	mv	a4,s8
    80002d60:	fca4f1e3          	bgeu	s1,a0,80002d22 <balloc+0x8e>
      m = 1 << (bi % 8);
    80002d64:	00777693          	and	a3,a4,7
    80002d68:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    80002d6c:	41f7579b          	sraw	a5,a4,0x1f
    80002d70:	01d7d79b          	srlw	a5,a5,0x1d
    80002d74:	9fb9                	addw	a5,a5,a4
    80002d76:	4037d79b          	sraw	a5,a5,0x3
    80002d7a:	00f90633          	add	a2,s2,a5
    80002d7e:	05864603          	lbu	a2,88(a2)
    80002d82:	00c6f5b3          	and	a1,a3,a2
    80002d86:	d5a1                	beqz	a1,80002cce <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d88:	2705                	addw	a4,a4,1
    80002d8a:	2485                	addw	s1,s1,1
    80002d8c:	fd471ae3          	bne	a4,s4,80002d60 <balloc+0xcc>
    80002d90:	bf49                	j	80002d22 <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002d92:	00005517          	auipc	a0,0x5
    80002d96:	97e50513          	add	a0,a0,-1666 # 80007710 <syscalls_names+0x108>
    80002d9a:	f04fd0ef          	jal	8000049e <printf>
  return 0;
    80002d9e:	4481                	li	s1,0
    80002da0:	b79d                	j	80002d06 <balloc+0x72>

0000000080002da2 <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    80002da2:	7179                	add	sp,sp,-48
    80002da4:	f406                	sd	ra,40(sp)
    80002da6:	f022                	sd	s0,32(sp)
    80002da8:	ec26                	sd	s1,24(sp)
    80002daa:	e84a                	sd	s2,16(sp)
    80002dac:	e44e                	sd	s3,8(sp)
    80002dae:	e052                	sd	s4,0(sp)
    80002db0:	1800                	add	s0,sp,48
    80002db2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002db4:	47ad                	li	a5,11
    80002db6:	02b7e663          	bltu	a5,a1,80002de2 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
    80002dba:	02059793          	sll	a5,a1,0x20
    80002dbe:	01e7d593          	srl	a1,a5,0x1e
    80002dc2:	00b504b3          	add	s1,a0,a1
    80002dc6:	0504a903          	lw	s2,80(s1)
    80002dca:	06091663          	bnez	s2,80002e36 <bmap+0x94>
      addr = balloc(ip->dev);
    80002dce:	4108                	lw	a0,0(a0)
    80002dd0:	ec5ff0ef          	jal	80002c94 <balloc>
    80002dd4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002dd8:	04090f63          	beqz	s2,80002e36 <bmap+0x94>
        return 0;
      ip->addrs[bn] = addr;
    80002ddc:	0524a823          	sw	s2,80(s1)
    80002de0:	a899                	j	80002e36 <bmap+0x94>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002de2:	ff45849b          	addw	s1,a1,-12
    80002de6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002dea:	0ff00793          	li	a5,255
    80002dee:	06e7eb63          	bltu	a5,a4,80002e64 <bmap+0xc2>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002df2:	08052903          	lw	s2,128(a0)
    80002df6:	00091b63          	bnez	s2,80002e0c <bmap+0x6a>
      addr = balloc(ip->dev);
    80002dfa:	4108                	lw	a0,0(a0)
    80002dfc:	e99ff0ef          	jal	80002c94 <balloc>
    80002e00:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002e04:	02090963          	beqz	s2,80002e36 <bmap+0x94>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002e08:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002e0c:	85ca                	mv	a1,s2
    80002e0e:	0009a503          	lw	a0,0(s3)
    80002e12:	c1fff0ef          	jal	80002a30 <bread>
    80002e16:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002e18:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002e1c:	02049713          	sll	a4,s1,0x20
    80002e20:	01e75593          	srl	a1,a4,0x1e
    80002e24:	00b784b3          	add	s1,a5,a1
    80002e28:	0004a903          	lw	s2,0(s1)
    80002e2c:	00090e63          	beqz	s2,80002e48 <bmap+0xa6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002e30:	8552                	mv	a0,s4
    80002e32:	d07ff0ef          	jal	80002b38 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002e36:	854a                	mv	a0,s2
    80002e38:	70a2                	ld	ra,40(sp)
    80002e3a:	7402                	ld	s0,32(sp)
    80002e3c:	64e2                	ld	s1,24(sp)
    80002e3e:	6942                	ld	s2,16(sp)
    80002e40:	69a2                	ld	s3,8(sp)
    80002e42:	6a02                	ld	s4,0(sp)
    80002e44:	6145                	add	sp,sp,48
    80002e46:	8082                	ret
      addr = balloc(ip->dev);
    80002e48:	0009a503          	lw	a0,0(s3)
    80002e4c:	e49ff0ef          	jal	80002c94 <balloc>
    80002e50:	0005091b          	sext.w	s2,a0
      if(addr){
    80002e54:	fc090ee3          	beqz	s2,80002e30 <bmap+0x8e>
        a[bn] = addr;
    80002e58:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002e5c:	8552                	mv	a0,s4
    80002e5e:	4d3000ef          	jal	80003b30 <log_write>
    80002e62:	b7f9                	j	80002e30 <bmap+0x8e>
  panic("bmap: out of range");
    80002e64:	00005517          	auipc	a0,0x5
    80002e68:	8c450513          	add	a0,a0,-1852 # 80007728 <syscalls_names+0x120>
    80002e6c:	8f3fd0ef          	jal	8000075e <panic>

0000000080002e70 <iget>:
{
    80002e70:	7179                	add	sp,sp,-48
    80002e72:	f406                	sd	ra,40(sp)
    80002e74:	f022                	sd	s0,32(sp)
    80002e76:	ec26                	sd	s1,24(sp)
    80002e78:	e84a                	sd	s2,16(sp)
    80002e7a:	e44e                	sd	s3,8(sp)
    80002e7c:	e052                	sd	s4,0(sp)
    80002e7e:	1800                	add	s0,sp,48
    80002e80:	89aa                	mv	s3,a0
    80002e82:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002e84:	0001b517          	auipc	a0,0x1b
    80002e88:	45450513          	add	a0,a0,1108 # 8001e2d8 <itable>
    80002e8c:	d15fd0ef          	jal	80000ba0 <acquire>
  empty = 0;
    80002e90:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e92:	0001b497          	auipc	s1,0x1b
    80002e96:	45e48493          	add	s1,s1,1118 # 8001e2f0 <itable+0x18>
    80002e9a:	0001d697          	auipc	a3,0x1d
    80002e9e:	ee668693          	add	a3,a3,-282 # 8001fd80 <log>
    80002ea2:	a039                	j	80002eb0 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002ea4:	02090963          	beqz	s2,80002ed6 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ea8:	08848493          	add	s1,s1,136
    80002eac:	02d48863          	beq	s1,a3,80002edc <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002eb0:	449c                	lw	a5,8(s1)
    80002eb2:	fef059e3          	blez	a5,80002ea4 <iget+0x34>
    80002eb6:	4098                	lw	a4,0(s1)
    80002eb8:	ff3716e3          	bne	a4,s3,80002ea4 <iget+0x34>
    80002ebc:	40d8                	lw	a4,4(s1)
    80002ebe:	ff4713e3          	bne	a4,s4,80002ea4 <iget+0x34>
      ip->ref++;
    80002ec2:	2785                	addw	a5,a5,1
    80002ec4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ec6:	0001b517          	auipc	a0,0x1b
    80002eca:	41250513          	add	a0,a0,1042 # 8001e2d8 <itable>
    80002ece:	d6bfd0ef          	jal	80000c38 <release>
      return ip;
    80002ed2:	8926                	mv	s2,s1
    80002ed4:	a02d                	j	80002efe <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002ed6:	fbe9                	bnez	a5,80002ea8 <iget+0x38>
    80002ed8:	8926                	mv	s2,s1
    80002eda:	b7f9                	j	80002ea8 <iget+0x38>
  if(empty == 0)
    80002edc:	02090a63          	beqz	s2,80002f10 <iget+0xa0>
  ip->dev = dev;
    80002ee0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ee4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ee8:	4785                	li	a5,1
    80002eea:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002eee:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ef2:	0001b517          	auipc	a0,0x1b
    80002ef6:	3e650513          	add	a0,a0,998 # 8001e2d8 <itable>
    80002efa:	d3ffd0ef          	jal	80000c38 <release>
}
    80002efe:	854a                	mv	a0,s2
    80002f00:	70a2                	ld	ra,40(sp)
    80002f02:	7402                	ld	s0,32(sp)
    80002f04:	64e2                	ld	s1,24(sp)
    80002f06:	6942                	ld	s2,16(sp)
    80002f08:	69a2                	ld	s3,8(sp)
    80002f0a:	6a02                	ld	s4,0(sp)
    80002f0c:	6145                	add	sp,sp,48
    80002f0e:	8082                	ret
    panic("iget: no inodes");
    80002f10:	00005517          	auipc	a0,0x5
    80002f14:	83050513          	add	a0,a0,-2000 # 80007740 <syscalls_names+0x138>
    80002f18:	847fd0ef          	jal	8000075e <panic>

0000000080002f1c <fsinit>:
fsinit(int dev) {
    80002f1c:	7179                	add	sp,sp,-48
    80002f1e:	f406                	sd	ra,40(sp)
    80002f20:	f022                	sd	s0,32(sp)
    80002f22:	ec26                	sd	s1,24(sp)
    80002f24:	e84a                	sd	s2,16(sp)
    80002f26:	e44e                	sd	s3,8(sp)
    80002f28:	1800                	add	s0,sp,48
    80002f2a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002f2c:	4585                	li	a1,1
    80002f2e:	b03ff0ef          	jal	80002a30 <bread>
    80002f32:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002f34:	0001b997          	auipc	s3,0x1b
    80002f38:	38498993          	add	s3,s3,900 # 8001e2b8 <sb>
    80002f3c:	02000613          	li	a2,32
    80002f40:	05850593          	add	a1,a0,88
    80002f44:	854e                	mv	a0,s3
    80002f46:	d8bfd0ef          	jal	80000cd0 <memmove>
  brelse(bp);
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	bedff0ef          	jal	80002b38 <brelse>
  if(sb.magic != FSMAGIC)
    80002f50:	0009a703          	lw	a4,0(s3)
    80002f54:	102037b7          	lui	a5,0x10203
    80002f58:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f5c:	02f71063          	bne	a4,a5,80002f7c <fsinit+0x60>
  initlog(dev, &sb);
    80002f60:	0001b597          	auipc	a1,0x1b
    80002f64:	35858593          	add	a1,a1,856 # 8001e2b8 <sb>
    80002f68:	854a                	mv	a0,s2
    80002f6a:	1c5000ef          	jal	8000392e <initlog>
}
    80002f6e:	70a2                	ld	ra,40(sp)
    80002f70:	7402                	ld	s0,32(sp)
    80002f72:	64e2                	ld	s1,24(sp)
    80002f74:	6942                	ld	s2,16(sp)
    80002f76:	69a2                	ld	s3,8(sp)
    80002f78:	6145                	add	sp,sp,48
    80002f7a:	8082                	ret
    panic("invalid file system");
    80002f7c:	00004517          	auipc	a0,0x4
    80002f80:	7d450513          	add	a0,a0,2004 # 80007750 <syscalls_names+0x148>
    80002f84:	fdafd0ef          	jal	8000075e <panic>

0000000080002f88 <iinit>:
{
    80002f88:	7179                	add	sp,sp,-48
    80002f8a:	f406                	sd	ra,40(sp)
    80002f8c:	f022                	sd	s0,32(sp)
    80002f8e:	ec26                	sd	s1,24(sp)
    80002f90:	e84a                	sd	s2,16(sp)
    80002f92:	e44e                	sd	s3,8(sp)
    80002f94:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002f96:	00004597          	auipc	a1,0x4
    80002f9a:	7d258593          	add	a1,a1,2002 # 80007768 <syscalls_names+0x160>
    80002f9e:	0001b517          	auipc	a0,0x1b
    80002fa2:	33a50513          	add	a0,a0,826 # 8001e2d8 <itable>
    80002fa6:	b7bfd0ef          	jal	80000b20 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002faa:	0001b497          	auipc	s1,0x1b
    80002fae:	35648493          	add	s1,s1,854 # 8001e300 <itable+0x28>
    80002fb2:	0001d997          	auipc	s3,0x1d
    80002fb6:	dde98993          	add	s3,s3,-546 # 8001fd90 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002fba:	00004917          	auipc	s2,0x4
    80002fbe:	7b690913          	add	s2,s2,1974 # 80007770 <syscalls_names+0x168>
    80002fc2:	85ca                	mv	a1,s2
    80002fc4:	8526                	mv	a0,s1
    80002fc6:	43b000ef          	jal	80003c00 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002fca:	08848493          	add	s1,s1,136
    80002fce:	ff349ae3          	bne	s1,s3,80002fc2 <iinit+0x3a>
}
    80002fd2:	70a2                	ld	ra,40(sp)
    80002fd4:	7402                	ld	s0,32(sp)
    80002fd6:	64e2                	ld	s1,24(sp)
    80002fd8:	6942                	ld	s2,16(sp)
    80002fda:	69a2                	ld	s3,8(sp)
    80002fdc:	6145                	add	sp,sp,48
    80002fde:	8082                	ret

0000000080002fe0 <ialloc>:
{
    80002fe0:	7139                	add	sp,sp,-64
    80002fe2:	fc06                	sd	ra,56(sp)
    80002fe4:	f822                	sd	s0,48(sp)
    80002fe6:	f426                	sd	s1,40(sp)
    80002fe8:	f04a                	sd	s2,32(sp)
    80002fea:	ec4e                	sd	s3,24(sp)
    80002fec:	e852                	sd	s4,16(sp)
    80002fee:	e456                	sd	s5,8(sp)
    80002ff0:	e05a                	sd	s6,0(sp)
    80002ff2:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ff4:	0001b717          	auipc	a4,0x1b
    80002ff8:	2d072703          	lw	a4,720(a4) # 8001e2c4 <sb+0xc>
    80002ffc:	4785                	li	a5,1
    80002ffe:	04e7f463          	bgeu	a5,a4,80003046 <ialloc+0x66>
    80003002:	8aaa                	mv	s5,a0
    80003004:	8b2e                	mv	s6,a1
    80003006:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003008:	0001ba17          	auipc	s4,0x1b
    8000300c:	2b0a0a13          	add	s4,s4,688 # 8001e2b8 <sb>
    80003010:	00495593          	srl	a1,s2,0x4
    80003014:	018a2783          	lw	a5,24(s4)
    80003018:	9dbd                	addw	a1,a1,a5
    8000301a:	8556                	mv	a0,s5
    8000301c:	a15ff0ef          	jal	80002a30 <bread>
    80003020:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003022:	05850993          	add	s3,a0,88
    80003026:	00f97793          	and	a5,s2,15
    8000302a:	079a                	sll	a5,a5,0x6
    8000302c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    8000302e:	00099783          	lh	a5,0(s3)
    80003032:	cb9d                	beqz	a5,80003068 <ialloc+0x88>
    brelse(bp);
    80003034:	b05ff0ef          	jal	80002b38 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003038:	0905                	add	s2,s2,1
    8000303a:	00ca2703          	lw	a4,12(s4)
    8000303e:	0009079b          	sext.w	a5,s2
    80003042:	fce7e7e3          	bltu	a5,a4,80003010 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003046:	00004517          	auipc	a0,0x4
    8000304a:	73250513          	add	a0,a0,1842 # 80007778 <syscalls_names+0x170>
    8000304e:	c50fd0ef          	jal	8000049e <printf>
  return 0;
    80003052:	4501                	li	a0,0
}
    80003054:	70e2                	ld	ra,56(sp)
    80003056:	7442                	ld	s0,48(sp)
    80003058:	74a2                	ld	s1,40(sp)
    8000305a:	7902                	ld	s2,32(sp)
    8000305c:	69e2                	ld	s3,24(sp)
    8000305e:	6a42                	ld	s4,16(sp)
    80003060:	6aa2                	ld	s5,8(sp)
    80003062:	6b02                	ld	s6,0(sp)
    80003064:	6121                	add	sp,sp,64
    80003066:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003068:	04000613          	li	a2,64
    8000306c:	4581                	li	a1,0
    8000306e:	854e                	mv	a0,s3
    80003070:	c05fd0ef          	jal	80000c74 <memset>
      dip->type = type;
    80003074:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80003078:	8526                	mv	a0,s1
    8000307a:	2b7000ef          	jal	80003b30 <log_write>
      brelse(bp);
    8000307e:	8526                	mv	a0,s1
    80003080:	ab9ff0ef          	jal	80002b38 <brelse>
      return iget(dev, inum);
    80003084:	0009059b          	sext.w	a1,s2
    80003088:	8556                	mv	a0,s5
    8000308a:	de7ff0ef          	jal	80002e70 <iget>
    8000308e:	b7d9                	j	80003054 <ialloc+0x74>

0000000080003090 <iupdate>:
{
    80003090:	1101                	add	sp,sp,-32
    80003092:	ec06                	sd	ra,24(sp)
    80003094:	e822                	sd	s0,16(sp)
    80003096:	e426                	sd	s1,8(sp)
    80003098:	e04a                	sd	s2,0(sp)
    8000309a:	1000                	add	s0,sp,32
    8000309c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000309e:	415c                	lw	a5,4(a0)
    800030a0:	0047d79b          	srlw	a5,a5,0x4
    800030a4:	0001b597          	auipc	a1,0x1b
    800030a8:	22c5a583          	lw	a1,556(a1) # 8001e2d0 <sb+0x18>
    800030ac:	9dbd                	addw	a1,a1,a5
    800030ae:	4108                	lw	a0,0(a0)
    800030b0:	981ff0ef          	jal	80002a30 <bread>
    800030b4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800030b6:	05850793          	add	a5,a0,88
    800030ba:	40d8                	lw	a4,4(s1)
    800030bc:	8b3d                	and	a4,a4,15
    800030be:	071a                	sll	a4,a4,0x6
    800030c0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800030c2:	04449703          	lh	a4,68(s1)
    800030c6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800030ca:	04649703          	lh	a4,70(s1)
    800030ce:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800030d2:	04849703          	lh	a4,72(s1)
    800030d6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800030da:	04a49703          	lh	a4,74(s1)
    800030de:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800030e2:	44f8                	lw	a4,76(s1)
    800030e4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800030e6:	03400613          	li	a2,52
    800030ea:	05048593          	add	a1,s1,80
    800030ee:	00c78513          	add	a0,a5,12
    800030f2:	bdffd0ef          	jal	80000cd0 <memmove>
  log_write(bp);
    800030f6:	854a                	mv	a0,s2
    800030f8:	239000ef          	jal	80003b30 <log_write>
  brelse(bp);
    800030fc:	854a                	mv	a0,s2
    800030fe:	a3bff0ef          	jal	80002b38 <brelse>
}
    80003102:	60e2                	ld	ra,24(sp)
    80003104:	6442                	ld	s0,16(sp)
    80003106:	64a2                	ld	s1,8(sp)
    80003108:	6902                	ld	s2,0(sp)
    8000310a:	6105                	add	sp,sp,32
    8000310c:	8082                	ret

000000008000310e <idup>:
{
    8000310e:	1101                	add	sp,sp,-32
    80003110:	ec06                	sd	ra,24(sp)
    80003112:	e822                	sd	s0,16(sp)
    80003114:	e426                	sd	s1,8(sp)
    80003116:	1000                	add	s0,sp,32
    80003118:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000311a:	0001b517          	auipc	a0,0x1b
    8000311e:	1be50513          	add	a0,a0,446 # 8001e2d8 <itable>
    80003122:	a7ffd0ef          	jal	80000ba0 <acquire>
  ip->ref++;
    80003126:	449c                	lw	a5,8(s1)
    80003128:	2785                	addw	a5,a5,1
    8000312a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000312c:	0001b517          	auipc	a0,0x1b
    80003130:	1ac50513          	add	a0,a0,428 # 8001e2d8 <itable>
    80003134:	b05fd0ef          	jal	80000c38 <release>
}
    80003138:	8526                	mv	a0,s1
    8000313a:	60e2                	ld	ra,24(sp)
    8000313c:	6442                	ld	s0,16(sp)
    8000313e:	64a2                	ld	s1,8(sp)
    80003140:	6105                	add	sp,sp,32
    80003142:	8082                	ret

0000000080003144 <ilock>:
{
    80003144:	1101                	add	sp,sp,-32
    80003146:	ec06                	sd	ra,24(sp)
    80003148:	e822                	sd	s0,16(sp)
    8000314a:	e426                	sd	s1,8(sp)
    8000314c:	e04a                	sd	s2,0(sp)
    8000314e:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003150:	c105                	beqz	a0,80003170 <ilock+0x2c>
    80003152:	84aa                	mv	s1,a0
    80003154:	451c                	lw	a5,8(a0)
    80003156:	00f05d63          	blez	a5,80003170 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000315a:	0541                	add	a0,a0,16
    8000315c:	2db000ef          	jal	80003c36 <acquiresleep>
  if(ip->valid == 0){
    80003160:	40bc                	lw	a5,64(s1)
    80003162:	cf89                	beqz	a5,8000317c <ilock+0x38>
}
    80003164:	60e2                	ld	ra,24(sp)
    80003166:	6442                	ld	s0,16(sp)
    80003168:	64a2                	ld	s1,8(sp)
    8000316a:	6902                	ld	s2,0(sp)
    8000316c:	6105                	add	sp,sp,32
    8000316e:	8082                	ret
    panic("ilock");
    80003170:	00004517          	auipc	a0,0x4
    80003174:	62050513          	add	a0,a0,1568 # 80007790 <syscalls_names+0x188>
    80003178:	de6fd0ef          	jal	8000075e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000317c:	40dc                	lw	a5,4(s1)
    8000317e:	0047d79b          	srlw	a5,a5,0x4
    80003182:	0001b597          	auipc	a1,0x1b
    80003186:	14e5a583          	lw	a1,334(a1) # 8001e2d0 <sb+0x18>
    8000318a:	9dbd                	addw	a1,a1,a5
    8000318c:	4088                	lw	a0,0(s1)
    8000318e:	8a3ff0ef          	jal	80002a30 <bread>
    80003192:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003194:	05850593          	add	a1,a0,88
    80003198:	40dc                	lw	a5,4(s1)
    8000319a:	8bbd                	and	a5,a5,15
    8000319c:	079a                	sll	a5,a5,0x6
    8000319e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800031a0:	00059783          	lh	a5,0(a1)
    800031a4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800031a8:	00259783          	lh	a5,2(a1)
    800031ac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800031b0:	00459783          	lh	a5,4(a1)
    800031b4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800031b8:	00659783          	lh	a5,6(a1)
    800031bc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800031c0:	459c                	lw	a5,8(a1)
    800031c2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800031c4:	03400613          	li	a2,52
    800031c8:	05b1                	add	a1,a1,12
    800031ca:	05048513          	add	a0,s1,80
    800031ce:	b03fd0ef          	jal	80000cd0 <memmove>
    brelse(bp);
    800031d2:	854a                	mv	a0,s2
    800031d4:	965ff0ef          	jal	80002b38 <brelse>
    ip->valid = 1;
    800031d8:	4785                	li	a5,1
    800031da:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800031dc:	04449783          	lh	a5,68(s1)
    800031e0:	f3d1                	bnez	a5,80003164 <ilock+0x20>
      panic("ilock: no type");
    800031e2:	00004517          	auipc	a0,0x4
    800031e6:	5b650513          	add	a0,a0,1462 # 80007798 <syscalls_names+0x190>
    800031ea:	d74fd0ef          	jal	8000075e <panic>

00000000800031ee <iunlock>:
{
    800031ee:	1101                	add	sp,sp,-32
    800031f0:	ec06                	sd	ra,24(sp)
    800031f2:	e822                	sd	s0,16(sp)
    800031f4:	e426                	sd	s1,8(sp)
    800031f6:	e04a                	sd	s2,0(sp)
    800031f8:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800031fa:	c505                	beqz	a0,80003222 <iunlock+0x34>
    800031fc:	84aa                	mv	s1,a0
    800031fe:	01050913          	add	s2,a0,16
    80003202:	854a                	mv	a0,s2
    80003204:	2b1000ef          	jal	80003cb4 <holdingsleep>
    80003208:	cd09                	beqz	a0,80003222 <iunlock+0x34>
    8000320a:	449c                	lw	a5,8(s1)
    8000320c:	00f05b63          	blez	a5,80003222 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003210:	854a                	mv	a0,s2
    80003212:	26b000ef          	jal	80003c7c <releasesleep>
}
    80003216:	60e2                	ld	ra,24(sp)
    80003218:	6442                	ld	s0,16(sp)
    8000321a:	64a2                	ld	s1,8(sp)
    8000321c:	6902                	ld	s2,0(sp)
    8000321e:	6105                	add	sp,sp,32
    80003220:	8082                	ret
    panic("iunlock");
    80003222:	00004517          	auipc	a0,0x4
    80003226:	58650513          	add	a0,a0,1414 # 800077a8 <syscalls_names+0x1a0>
    8000322a:	d34fd0ef          	jal	8000075e <panic>

000000008000322e <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    8000322e:	7179                	add	sp,sp,-48
    80003230:	f406                	sd	ra,40(sp)
    80003232:	f022                	sd	s0,32(sp)
    80003234:	ec26                	sd	s1,24(sp)
    80003236:	e84a                	sd	s2,16(sp)
    80003238:	e44e                	sd	s3,8(sp)
    8000323a:	e052                	sd	s4,0(sp)
    8000323c:	1800                	add	s0,sp,48
    8000323e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003240:	05050493          	add	s1,a0,80
    80003244:	08050913          	add	s2,a0,128
    80003248:	a021                	j	80003250 <itrunc+0x22>
    8000324a:	0491                	add	s1,s1,4
    8000324c:	01248b63          	beq	s1,s2,80003262 <itrunc+0x34>
    if(ip->addrs[i]){
    80003250:	408c                	lw	a1,0(s1)
    80003252:	dde5                	beqz	a1,8000324a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003254:	0009a503          	lw	a0,0(s3)
    80003258:	9d1ff0ef          	jal	80002c28 <bfree>
      ip->addrs[i] = 0;
    8000325c:	0004a023          	sw	zero,0(s1)
    80003260:	b7ed                	j	8000324a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003262:	0809a583          	lw	a1,128(s3)
    80003266:	ed91                	bnez	a1,80003282 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003268:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000326c:	854e                	mv	a0,s3
    8000326e:	e23ff0ef          	jal	80003090 <iupdate>
}
    80003272:	70a2                	ld	ra,40(sp)
    80003274:	7402                	ld	s0,32(sp)
    80003276:	64e2                	ld	s1,24(sp)
    80003278:	6942                	ld	s2,16(sp)
    8000327a:	69a2                	ld	s3,8(sp)
    8000327c:	6a02                	ld	s4,0(sp)
    8000327e:	6145                	add	sp,sp,48
    80003280:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003282:	0009a503          	lw	a0,0(s3)
    80003286:	faaff0ef          	jal	80002a30 <bread>
    8000328a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000328c:	05850493          	add	s1,a0,88
    80003290:	45850913          	add	s2,a0,1112
    80003294:	a021                	j	8000329c <itrunc+0x6e>
    80003296:	0491                	add	s1,s1,4
    80003298:	01248963          	beq	s1,s2,800032aa <itrunc+0x7c>
      if(a[j])
    8000329c:	408c                	lw	a1,0(s1)
    8000329e:	dde5                	beqz	a1,80003296 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    800032a0:	0009a503          	lw	a0,0(s3)
    800032a4:	985ff0ef          	jal	80002c28 <bfree>
    800032a8:	b7fd                	j	80003296 <itrunc+0x68>
    brelse(bp);
    800032aa:	8552                	mv	a0,s4
    800032ac:	88dff0ef          	jal	80002b38 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800032b0:	0809a583          	lw	a1,128(s3)
    800032b4:	0009a503          	lw	a0,0(s3)
    800032b8:	971ff0ef          	jal	80002c28 <bfree>
    ip->addrs[NDIRECT] = 0;
    800032bc:	0809a023          	sw	zero,128(s3)
    800032c0:	b765                	j	80003268 <itrunc+0x3a>

00000000800032c2 <iput>:
{
    800032c2:	1101                	add	sp,sp,-32
    800032c4:	ec06                	sd	ra,24(sp)
    800032c6:	e822                	sd	s0,16(sp)
    800032c8:	e426                	sd	s1,8(sp)
    800032ca:	e04a                	sd	s2,0(sp)
    800032cc:	1000                	add	s0,sp,32
    800032ce:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800032d0:	0001b517          	auipc	a0,0x1b
    800032d4:	00850513          	add	a0,a0,8 # 8001e2d8 <itable>
    800032d8:	8c9fd0ef          	jal	80000ba0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032dc:	4498                	lw	a4,8(s1)
    800032de:	4785                	li	a5,1
    800032e0:	02f70163          	beq	a4,a5,80003302 <iput+0x40>
  ip->ref--;
    800032e4:	449c                	lw	a5,8(s1)
    800032e6:	37fd                	addw	a5,a5,-1
    800032e8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800032ea:	0001b517          	auipc	a0,0x1b
    800032ee:	fee50513          	add	a0,a0,-18 # 8001e2d8 <itable>
    800032f2:	947fd0ef          	jal	80000c38 <release>
}
    800032f6:	60e2                	ld	ra,24(sp)
    800032f8:	6442                	ld	s0,16(sp)
    800032fa:	64a2                	ld	s1,8(sp)
    800032fc:	6902                	ld	s2,0(sp)
    800032fe:	6105                	add	sp,sp,32
    80003300:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003302:	40bc                	lw	a5,64(s1)
    80003304:	d3e5                	beqz	a5,800032e4 <iput+0x22>
    80003306:	04a49783          	lh	a5,74(s1)
    8000330a:	ffe9                	bnez	a5,800032e4 <iput+0x22>
    acquiresleep(&ip->lock);
    8000330c:	01048913          	add	s2,s1,16
    80003310:	854a                	mv	a0,s2
    80003312:	125000ef          	jal	80003c36 <acquiresleep>
    release(&itable.lock);
    80003316:	0001b517          	auipc	a0,0x1b
    8000331a:	fc250513          	add	a0,a0,-62 # 8001e2d8 <itable>
    8000331e:	91bfd0ef          	jal	80000c38 <release>
    itrunc(ip);
    80003322:	8526                	mv	a0,s1
    80003324:	f0bff0ef          	jal	8000322e <itrunc>
    ip->type = 0;
    80003328:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000332c:	8526                	mv	a0,s1
    8000332e:	d63ff0ef          	jal	80003090 <iupdate>
    ip->valid = 0;
    80003332:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003336:	854a                	mv	a0,s2
    80003338:	145000ef          	jal	80003c7c <releasesleep>
    acquire(&itable.lock);
    8000333c:	0001b517          	auipc	a0,0x1b
    80003340:	f9c50513          	add	a0,a0,-100 # 8001e2d8 <itable>
    80003344:	85dfd0ef          	jal	80000ba0 <acquire>
    80003348:	bf71                	j	800032e4 <iput+0x22>

000000008000334a <iunlockput>:
{
    8000334a:	1101                	add	sp,sp,-32
    8000334c:	ec06                	sd	ra,24(sp)
    8000334e:	e822                	sd	s0,16(sp)
    80003350:	e426                	sd	s1,8(sp)
    80003352:	1000                	add	s0,sp,32
    80003354:	84aa                	mv	s1,a0
  iunlock(ip);
    80003356:	e99ff0ef          	jal	800031ee <iunlock>
  iput(ip);
    8000335a:	8526                	mv	a0,s1
    8000335c:	f67ff0ef          	jal	800032c2 <iput>
}
    80003360:	60e2                	ld	ra,24(sp)
    80003362:	6442                	ld	s0,16(sp)
    80003364:	64a2                	ld	s1,8(sp)
    80003366:	6105                	add	sp,sp,32
    80003368:	8082                	ret

000000008000336a <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    8000336a:	1141                	add	sp,sp,-16
    8000336c:	e422                	sd	s0,8(sp)
    8000336e:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003370:	411c                	lw	a5,0(a0)
    80003372:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003374:	415c                	lw	a5,4(a0)
    80003376:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003378:	04451783          	lh	a5,68(a0)
    8000337c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003380:	04a51783          	lh	a5,74(a0)
    80003384:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003388:	04c56783          	lwu	a5,76(a0)
    8000338c:	e99c                	sd	a5,16(a1)
}
    8000338e:	6422                	ld	s0,8(sp)
    80003390:	0141                	add	sp,sp,16
    80003392:	8082                	ret

0000000080003394 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003394:	457c                	lw	a5,76(a0)
    80003396:	0cd7ef63          	bltu	a5,a3,80003474 <readi+0xe0>
{
    8000339a:	7159                	add	sp,sp,-112
    8000339c:	f486                	sd	ra,104(sp)
    8000339e:	f0a2                	sd	s0,96(sp)
    800033a0:	eca6                	sd	s1,88(sp)
    800033a2:	e8ca                	sd	s2,80(sp)
    800033a4:	e4ce                	sd	s3,72(sp)
    800033a6:	e0d2                	sd	s4,64(sp)
    800033a8:	fc56                	sd	s5,56(sp)
    800033aa:	f85a                	sd	s6,48(sp)
    800033ac:	f45e                	sd	s7,40(sp)
    800033ae:	f062                	sd	s8,32(sp)
    800033b0:	ec66                	sd	s9,24(sp)
    800033b2:	e86a                	sd	s10,16(sp)
    800033b4:	e46e                	sd	s11,8(sp)
    800033b6:	1880                	add	s0,sp,112
    800033b8:	8b2a                	mv	s6,a0
    800033ba:	8bae                	mv	s7,a1
    800033bc:	8a32                	mv	s4,a2
    800033be:	84b6                	mv	s1,a3
    800033c0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800033c2:	9f35                	addw	a4,a4,a3
    return 0;
    800033c4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800033c6:	08d76663          	bltu	a4,a3,80003452 <readi+0xbe>
  if(off + n > ip->size)
    800033ca:	00e7f463          	bgeu	a5,a4,800033d2 <readi+0x3e>
    n = ip->size - off;
    800033ce:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033d2:	080a8f63          	beqz	s5,80003470 <readi+0xdc>
    800033d6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800033d8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800033dc:	5c7d                	li	s8,-1
    800033de:	a80d                	j	80003410 <readi+0x7c>
    800033e0:	020d1d93          	sll	s11,s10,0x20
    800033e4:	020ddd93          	srl	s11,s11,0x20
    800033e8:	05890613          	add	a2,s2,88
    800033ec:	86ee                	mv	a3,s11
    800033ee:	963a                	add	a2,a2,a4
    800033f0:	85d2                	mv	a1,s4
    800033f2:	855e                	mv	a0,s7
    800033f4:	d71fe0ef          	jal	80002164 <either_copyout>
    800033f8:	05850763          	beq	a0,s8,80003446 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800033fc:	854a                	mv	a0,s2
    800033fe:	f3aff0ef          	jal	80002b38 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003402:	013d09bb          	addw	s3,s10,s3
    80003406:	009d04bb          	addw	s1,s10,s1
    8000340a:	9a6e                	add	s4,s4,s11
    8000340c:	0559f163          	bgeu	s3,s5,8000344e <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80003410:	00a4d59b          	srlw	a1,s1,0xa
    80003414:	855a                	mv	a0,s6
    80003416:	98dff0ef          	jal	80002da2 <bmap>
    8000341a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000341e:	c985                	beqz	a1,8000344e <readi+0xba>
    bp = bread(ip->dev, addr);
    80003420:	000b2503          	lw	a0,0(s6)
    80003424:	e0cff0ef          	jal	80002a30 <bread>
    80003428:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000342a:	3ff4f713          	and	a4,s1,1023
    8000342e:	40ec87bb          	subw	a5,s9,a4
    80003432:	413a86bb          	subw	a3,s5,s3
    80003436:	8d3e                	mv	s10,a5
    80003438:	2781                	sext.w	a5,a5
    8000343a:	0006861b          	sext.w	a2,a3
    8000343e:	faf671e3          	bgeu	a2,a5,800033e0 <readi+0x4c>
    80003442:	8d36                	mv	s10,a3
    80003444:	bf71                	j	800033e0 <readi+0x4c>
      brelse(bp);
    80003446:	854a                	mv	a0,s2
    80003448:	ef0ff0ef          	jal	80002b38 <brelse>
      tot = -1;
    8000344c:	59fd                	li	s3,-1
  }
  return tot;
    8000344e:	0009851b          	sext.w	a0,s3
}
    80003452:	70a6                	ld	ra,104(sp)
    80003454:	7406                	ld	s0,96(sp)
    80003456:	64e6                	ld	s1,88(sp)
    80003458:	6946                	ld	s2,80(sp)
    8000345a:	69a6                	ld	s3,72(sp)
    8000345c:	6a06                	ld	s4,64(sp)
    8000345e:	7ae2                	ld	s5,56(sp)
    80003460:	7b42                	ld	s6,48(sp)
    80003462:	7ba2                	ld	s7,40(sp)
    80003464:	7c02                	ld	s8,32(sp)
    80003466:	6ce2                	ld	s9,24(sp)
    80003468:	6d42                	ld	s10,16(sp)
    8000346a:	6da2                	ld	s11,8(sp)
    8000346c:	6165                	add	sp,sp,112
    8000346e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003470:	89d6                	mv	s3,s5
    80003472:	bff1                	j	8000344e <readi+0xba>
    return 0;
    80003474:	4501                	li	a0,0
}
    80003476:	8082                	ret

0000000080003478 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003478:	457c                	lw	a5,76(a0)
    8000347a:	0ed7ea63          	bltu	a5,a3,8000356e <writei+0xf6>
{
    8000347e:	7159                	add	sp,sp,-112
    80003480:	f486                	sd	ra,104(sp)
    80003482:	f0a2                	sd	s0,96(sp)
    80003484:	eca6                	sd	s1,88(sp)
    80003486:	e8ca                	sd	s2,80(sp)
    80003488:	e4ce                	sd	s3,72(sp)
    8000348a:	e0d2                	sd	s4,64(sp)
    8000348c:	fc56                	sd	s5,56(sp)
    8000348e:	f85a                	sd	s6,48(sp)
    80003490:	f45e                	sd	s7,40(sp)
    80003492:	f062                	sd	s8,32(sp)
    80003494:	ec66                	sd	s9,24(sp)
    80003496:	e86a                	sd	s10,16(sp)
    80003498:	e46e                	sd	s11,8(sp)
    8000349a:	1880                	add	s0,sp,112
    8000349c:	8aaa                	mv	s5,a0
    8000349e:	8bae                	mv	s7,a1
    800034a0:	8a32                	mv	s4,a2
    800034a2:	8936                	mv	s2,a3
    800034a4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800034a6:	00e687bb          	addw	a5,a3,a4
    800034aa:	0cd7e463          	bltu	a5,a3,80003572 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800034ae:	00043737          	lui	a4,0x43
    800034b2:	0cf76263          	bltu	a4,a5,80003576 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800034b6:	0a0b0a63          	beqz	s6,8000356a <writei+0xf2>
    800034ba:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800034bc:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800034c0:	5c7d                	li	s8,-1
    800034c2:	a825                	j	800034fa <writei+0x82>
    800034c4:	020d1d93          	sll	s11,s10,0x20
    800034c8:	020ddd93          	srl	s11,s11,0x20
    800034cc:	05848513          	add	a0,s1,88
    800034d0:	86ee                	mv	a3,s11
    800034d2:	8652                	mv	a2,s4
    800034d4:	85de                	mv	a1,s7
    800034d6:	953a                	add	a0,a0,a4
    800034d8:	cd7fe0ef          	jal	800021ae <either_copyin>
    800034dc:	05850a63          	beq	a0,s8,80003530 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800034e0:	8526                	mv	a0,s1
    800034e2:	64e000ef          	jal	80003b30 <log_write>
    brelse(bp);
    800034e6:	8526                	mv	a0,s1
    800034e8:	e50ff0ef          	jal	80002b38 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800034ec:	013d09bb          	addw	s3,s10,s3
    800034f0:	012d093b          	addw	s2,s10,s2
    800034f4:	9a6e                	add	s4,s4,s11
    800034f6:	0569f063          	bgeu	s3,s6,80003536 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800034fa:	00a9559b          	srlw	a1,s2,0xa
    800034fe:	8556                	mv	a0,s5
    80003500:	8a3ff0ef          	jal	80002da2 <bmap>
    80003504:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003508:	c59d                	beqz	a1,80003536 <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000350a:	000aa503          	lw	a0,0(s5)
    8000350e:	d22ff0ef          	jal	80002a30 <bread>
    80003512:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003514:	3ff97713          	and	a4,s2,1023
    80003518:	40ec87bb          	subw	a5,s9,a4
    8000351c:	413b06bb          	subw	a3,s6,s3
    80003520:	8d3e                	mv	s10,a5
    80003522:	2781                	sext.w	a5,a5
    80003524:	0006861b          	sext.w	a2,a3
    80003528:	f8f67ee3          	bgeu	a2,a5,800034c4 <writei+0x4c>
    8000352c:	8d36                	mv	s10,a3
    8000352e:	bf59                	j	800034c4 <writei+0x4c>
      brelse(bp);
    80003530:	8526                	mv	a0,s1
    80003532:	e06ff0ef          	jal	80002b38 <brelse>
  }

  if(off > ip->size)
    80003536:	04caa783          	lw	a5,76(s5)
    8000353a:	0127f463          	bgeu	a5,s2,80003542 <writei+0xca>
    ip->size = off;
    8000353e:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    80003542:	8556                	mv	a0,s5
    80003544:	b4dff0ef          	jal	80003090 <iupdate>

  return tot;
    80003548:	0009851b          	sext.w	a0,s3
}
    8000354c:	70a6                	ld	ra,104(sp)
    8000354e:	7406                	ld	s0,96(sp)
    80003550:	64e6                	ld	s1,88(sp)
    80003552:	6946                	ld	s2,80(sp)
    80003554:	69a6                	ld	s3,72(sp)
    80003556:	6a06                	ld	s4,64(sp)
    80003558:	7ae2                	ld	s5,56(sp)
    8000355a:	7b42                	ld	s6,48(sp)
    8000355c:	7ba2                	ld	s7,40(sp)
    8000355e:	7c02                	ld	s8,32(sp)
    80003560:	6ce2                	ld	s9,24(sp)
    80003562:	6d42                	ld	s10,16(sp)
    80003564:	6da2                	ld	s11,8(sp)
    80003566:	6165                	add	sp,sp,112
    80003568:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000356a:	89da                	mv	s3,s6
    8000356c:	bfd9                	j	80003542 <writei+0xca>
    return -1;
    8000356e:	557d                	li	a0,-1
}
    80003570:	8082                	ret
    return -1;
    80003572:	557d                	li	a0,-1
    80003574:	bfe1                	j	8000354c <writei+0xd4>
    return -1;
    80003576:	557d                	li	a0,-1
    80003578:	bfd1                	j	8000354c <writei+0xd4>

000000008000357a <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    8000357a:	1141                	add	sp,sp,-16
    8000357c:	e406                	sd	ra,8(sp)
    8000357e:	e022                	sd	s0,0(sp)
    80003580:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003582:	4639                	li	a2,14
    80003584:	fbcfd0ef          	jal	80000d40 <strncmp>
}
    80003588:	60a2                	ld	ra,8(sp)
    8000358a:	6402                	ld	s0,0(sp)
    8000358c:	0141                	add	sp,sp,16
    8000358e:	8082                	ret

0000000080003590 <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003590:	7139                	add	sp,sp,-64
    80003592:	fc06                	sd	ra,56(sp)
    80003594:	f822                	sd	s0,48(sp)
    80003596:	f426                	sd	s1,40(sp)
    80003598:	f04a                	sd	s2,32(sp)
    8000359a:	ec4e                	sd	s3,24(sp)
    8000359c:	e852                	sd	s4,16(sp)
    8000359e:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800035a0:	04451703          	lh	a4,68(a0)
    800035a4:	4785                	li	a5,1
    800035a6:	00f71a63          	bne	a4,a5,800035ba <dirlookup+0x2a>
    800035aa:	892a                	mv	s2,a0
    800035ac:	89ae                	mv	s3,a1
    800035ae:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800035b0:	457c                	lw	a5,76(a0)
    800035b2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800035b4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035b6:	e39d                	bnez	a5,800035dc <dirlookup+0x4c>
    800035b8:	a095                	j	8000361c <dirlookup+0x8c>
    panic("dirlookup not DIR");
    800035ba:	00004517          	auipc	a0,0x4
    800035be:	1f650513          	add	a0,a0,502 # 800077b0 <syscalls_names+0x1a8>
    800035c2:	99cfd0ef          	jal	8000075e <panic>
      panic("dirlookup read");
    800035c6:	00004517          	auipc	a0,0x4
    800035ca:	20250513          	add	a0,a0,514 # 800077c8 <syscalls_names+0x1c0>
    800035ce:	990fd0ef          	jal	8000075e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035d2:	24c1                	addw	s1,s1,16
    800035d4:	04c92783          	lw	a5,76(s2)
    800035d8:	04f4f163          	bgeu	s1,a5,8000361a <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035dc:	4741                	li	a4,16
    800035de:	86a6                	mv	a3,s1
    800035e0:	fc040613          	add	a2,s0,-64
    800035e4:	4581                	li	a1,0
    800035e6:	854a                	mv	a0,s2
    800035e8:	dadff0ef          	jal	80003394 <readi>
    800035ec:	47c1                	li	a5,16
    800035ee:	fcf51ce3          	bne	a0,a5,800035c6 <dirlookup+0x36>
    if(de.inum == 0)
    800035f2:	fc045783          	lhu	a5,-64(s0)
    800035f6:	dff1                	beqz	a5,800035d2 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800035f8:	fc240593          	add	a1,s0,-62
    800035fc:	854e                	mv	a0,s3
    800035fe:	f7dff0ef          	jal	8000357a <namecmp>
    80003602:	f961                	bnez	a0,800035d2 <dirlookup+0x42>
      if(poff)
    80003604:	000a0463          	beqz	s4,8000360c <dirlookup+0x7c>
        *poff = off;
    80003608:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000360c:	fc045583          	lhu	a1,-64(s0)
    80003610:	00092503          	lw	a0,0(s2)
    80003614:	85dff0ef          	jal	80002e70 <iget>
    80003618:	a011                	j	8000361c <dirlookup+0x8c>
  return 0;
    8000361a:	4501                	li	a0,0
}
    8000361c:	70e2                	ld	ra,56(sp)
    8000361e:	7442                	ld	s0,48(sp)
    80003620:	74a2                	ld	s1,40(sp)
    80003622:	7902                	ld	s2,32(sp)
    80003624:	69e2                	ld	s3,24(sp)
    80003626:	6a42                	ld	s4,16(sp)
    80003628:	6121                	add	sp,sp,64
    8000362a:	8082                	ret

000000008000362c <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000362c:	711d                	add	sp,sp,-96
    8000362e:	ec86                	sd	ra,88(sp)
    80003630:	e8a2                	sd	s0,80(sp)
    80003632:	e4a6                	sd	s1,72(sp)
    80003634:	e0ca                	sd	s2,64(sp)
    80003636:	fc4e                	sd	s3,56(sp)
    80003638:	f852                	sd	s4,48(sp)
    8000363a:	f456                	sd	s5,40(sp)
    8000363c:	f05a                	sd	s6,32(sp)
    8000363e:	ec5e                	sd	s7,24(sp)
    80003640:	e862                	sd	s8,16(sp)
    80003642:	e466                	sd	s9,8(sp)
    80003644:	1080                	add	s0,sp,96
    80003646:	84aa                	mv	s1,a0
    80003648:	8b2e                	mv	s6,a1
    8000364a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000364c:	00054703          	lbu	a4,0(a0)
    80003650:	02f00793          	li	a5,47
    80003654:	00f70e63          	beq	a4,a5,80003670 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003658:	9d8fe0ef          	jal	80001830 <myproc>
    8000365c:	15853503          	ld	a0,344(a0)
    80003660:	aafff0ef          	jal	8000310e <idup>
    80003664:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003666:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000366a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000366c:	4b85                	li	s7,1
    8000366e:	a871                	j	8000370a <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003670:	4585                	li	a1,1
    80003672:	4505                	li	a0,1
    80003674:	ffcff0ef          	jal	80002e70 <iget>
    80003678:	8a2a                	mv	s4,a0
    8000367a:	b7f5                	j	80003666 <namex+0x3a>
      iunlockput(ip);
    8000367c:	8552                	mv	a0,s4
    8000367e:	ccdff0ef          	jal	8000334a <iunlockput>
      return 0;
    80003682:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003684:	8552                	mv	a0,s4
    80003686:	60e6                	ld	ra,88(sp)
    80003688:	6446                	ld	s0,80(sp)
    8000368a:	64a6                	ld	s1,72(sp)
    8000368c:	6906                	ld	s2,64(sp)
    8000368e:	79e2                	ld	s3,56(sp)
    80003690:	7a42                	ld	s4,48(sp)
    80003692:	7aa2                	ld	s5,40(sp)
    80003694:	7b02                	ld	s6,32(sp)
    80003696:	6be2                	ld	s7,24(sp)
    80003698:	6c42                	ld	s8,16(sp)
    8000369a:	6ca2                	ld	s9,8(sp)
    8000369c:	6125                	add	sp,sp,96
    8000369e:	8082                	ret
      iunlock(ip);
    800036a0:	8552                	mv	a0,s4
    800036a2:	b4dff0ef          	jal	800031ee <iunlock>
      return ip;
    800036a6:	bff9                	j	80003684 <namex+0x58>
      iunlockput(ip);
    800036a8:	8552                	mv	a0,s4
    800036aa:	ca1ff0ef          	jal	8000334a <iunlockput>
      return 0;
    800036ae:	8a4e                	mv	s4,s3
    800036b0:	bfd1                	j	80003684 <namex+0x58>
  len = path - s;
    800036b2:	40998633          	sub	a2,s3,s1
    800036b6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800036ba:	099c5063          	bge	s8,s9,8000373a <namex+0x10e>
    memmove(name, s, DIRSIZ);
    800036be:	4639                	li	a2,14
    800036c0:	85a6                	mv	a1,s1
    800036c2:	8556                	mv	a0,s5
    800036c4:	e0cfd0ef          	jal	80000cd0 <memmove>
    800036c8:	84ce                	mv	s1,s3
  while(*path == '/')
    800036ca:	0004c783          	lbu	a5,0(s1)
    800036ce:	01279763          	bne	a5,s2,800036dc <namex+0xb0>
    path++;
    800036d2:	0485                	add	s1,s1,1
  while(*path == '/')
    800036d4:	0004c783          	lbu	a5,0(s1)
    800036d8:	ff278de3          	beq	a5,s2,800036d2 <namex+0xa6>
    ilock(ip);
    800036dc:	8552                	mv	a0,s4
    800036de:	a67ff0ef          	jal	80003144 <ilock>
    if(ip->type != T_DIR){
    800036e2:	044a1783          	lh	a5,68(s4)
    800036e6:	f9779be3          	bne	a5,s7,8000367c <namex+0x50>
    if(nameiparent && *path == '\0'){
    800036ea:	000b0563          	beqz	s6,800036f4 <namex+0xc8>
    800036ee:	0004c783          	lbu	a5,0(s1)
    800036f2:	d7dd                	beqz	a5,800036a0 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800036f4:	4601                	li	a2,0
    800036f6:	85d6                	mv	a1,s5
    800036f8:	8552                	mv	a0,s4
    800036fa:	e97ff0ef          	jal	80003590 <dirlookup>
    800036fe:	89aa                	mv	s3,a0
    80003700:	d545                	beqz	a0,800036a8 <namex+0x7c>
    iunlockput(ip);
    80003702:	8552                	mv	a0,s4
    80003704:	c47ff0ef          	jal	8000334a <iunlockput>
    ip = next;
    80003708:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000370a:	0004c783          	lbu	a5,0(s1)
    8000370e:	01279763          	bne	a5,s2,8000371c <namex+0xf0>
    path++;
    80003712:	0485                	add	s1,s1,1
  while(*path == '/')
    80003714:	0004c783          	lbu	a5,0(s1)
    80003718:	ff278de3          	beq	a5,s2,80003712 <namex+0xe6>
  if(*path == 0)
    8000371c:	cb8d                	beqz	a5,8000374e <namex+0x122>
  while(*path != '/' && *path != 0)
    8000371e:	0004c783          	lbu	a5,0(s1)
    80003722:	89a6                	mv	s3,s1
  len = path - s;
    80003724:	4c81                	li	s9,0
    80003726:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003728:	01278963          	beq	a5,s2,8000373a <namex+0x10e>
    8000372c:	d3d9                	beqz	a5,800036b2 <namex+0x86>
    path++;
    8000372e:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003730:	0009c783          	lbu	a5,0(s3)
    80003734:	ff279ce3          	bne	a5,s2,8000372c <namex+0x100>
    80003738:	bfad                	j	800036b2 <namex+0x86>
    memmove(name, s, len);
    8000373a:	2601                	sext.w	a2,a2
    8000373c:	85a6                	mv	a1,s1
    8000373e:	8556                	mv	a0,s5
    80003740:	d90fd0ef          	jal	80000cd0 <memmove>
    name[len] = 0;
    80003744:	9cd6                	add	s9,s9,s5
    80003746:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000374a:	84ce                	mv	s1,s3
    8000374c:	bfbd                	j	800036ca <namex+0x9e>
  if(nameiparent){
    8000374e:	f20b0be3          	beqz	s6,80003684 <namex+0x58>
    iput(ip);
    80003752:	8552                	mv	a0,s4
    80003754:	b6fff0ef          	jal	800032c2 <iput>
    return 0;
    80003758:	4a01                	li	s4,0
    8000375a:	b72d                	j	80003684 <namex+0x58>

000000008000375c <dirlink>:
{
    8000375c:	7139                	add	sp,sp,-64
    8000375e:	fc06                	sd	ra,56(sp)
    80003760:	f822                	sd	s0,48(sp)
    80003762:	f426                	sd	s1,40(sp)
    80003764:	f04a                	sd	s2,32(sp)
    80003766:	ec4e                	sd	s3,24(sp)
    80003768:	e852                	sd	s4,16(sp)
    8000376a:	0080                	add	s0,sp,64
    8000376c:	892a                	mv	s2,a0
    8000376e:	8a2e                	mv	s4,a1
    80003770:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003772:	4601                	li	a2,0
    80003774:	e1dff0ef          	jal	80003590 <dirlookup>
    80003778:	e52d                	bnez	a0,800037e2 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000377a:	04c92483          	lw	s1,76(s2)
    8000377e:	c48d                	beqz	s1,800037a8 <dirlink+0x4c>
    80003780:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003782:	4741                	li	a4,16
    80003784:	86a6                	mv	a3,s1
    80003786:	fc040613          	add	a2,s0,-64
    8000378a:	4581                	li	a1,0
    8000378c:	854a                	mv	a0,s2
    8000378e:	c07ff0ef          	jal	80003394 <readi>
    80003792:	47c1                	li	a5,16
    80003794:	04f51b63          	bne	a0,a5,800037ea <dirlink+0x8e>
    if(de.inum == 0)
    80003798:	fc045783          	lhu	a5,-64(s0)
    8000379c:	c791                	beqz	a5,800037a8 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000379e:	24c1                	addw	s1,s1,16
    800037a0:	04c92783          	lw	a5,76(s2)
    800037a4:	fcf4efe3          	bltu	s1,a5,80003782 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800037a8:	4639                	li	a2,14
    800037aa:	85d2                	mv	a1,s4
    800037ac:	fc240513          	add	a0,s0,-62
    800037b0:	dccfd0ef          	jal	80000d7c <strncpy>
  de.inum = inum;
    800037b4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037b8:	4741                	li	a4,16
    800037ba:	86a6                	mv	a3,s1
    800037bc:	fc040613          	add	a2,s0,-64
    800037c0:	4581                	li	a1,0
    800037c2:	854a                	mv	a0,s2
    800037c4:	cb5ff0ef          	jal	80003478 <writei>
    800037c8:	1541                	add	a0,a0,-16
    800037ca:	00a03533          	snez	a0,a0
    800037ce:	40a00533          	neg	a0,a0
}
    800037d2:	70e2                	ld	ra,56(sp)
    800037d4:	7442                	ld	s0,48(sp)
    800037d6:	74a2                	ld	s1,40(sp)
    800037d8:	7902                	ld	s2,32(sp)
    800037da:	69e2                	ld	s3,24(sp)
    800037dc:	6a42                	ld	s4,16(sp)
    800037de:	6121                	add	sp,sp,64
    800037e0:	8082                	ret
    iput(ip);
    800037e2:	ae1ff0ef          	jal	800032c2 <iput>
    return -1;
    800037e6:	557d                	li	a0,-1
    800037e8:	b7ed                	j	800037d2 <dirlink+0x76>
      panic("dirlink read");
    800037ea:	00004517          	auipc	a0,0x4
    800037ee:	fee50513          	add	a0,a0,-18 # 800077d8 <syscalls_names+0x1d0>
    800037f2:	f6dfc0ef          	jal	8000075e <panic>

00000000800037f6 <namei>:

struct inode*
namei(char *path)
{
    800037f6:	1101                	add	sp,sp,-32
    800037f8:	ec06                	sd	ra,24(sp)
    800037fa:	e822                	sd	s0,16(sp)
    800037fc:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800037fe:	fe040613          	add	a2,s0,-32
    80003802:	4581                	li	a1,0
    80003804:	e29ff0ef          	jal	8000362c <namex>
}
    80003808:	60e2                	ld	ra,24(sp)
    8000380a:	6442                	ld	s0,16(sp)
    8000380c:	6105                	add	sp,sp,32
    8000380e:	8082                	ret

0000000080003810 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003810:	1141                	add	sp,sp,-16
    80003812:	e406                	sd	ra,8(sp)
    80003814:	e022                	sd	s0,0(sp)
    80003816:	0800                	add	s0,sp,16
    80003818:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000381a:	4585                	li	a1,1
    8000381c:	e11ff0ef          	jal	8000362c <namex>
}
    80003820:	60a2                	ld	ra,8(sp)
    80003822:	6402                	ld	s0,0(sp)
    80003824:	0141                	add	sp,sp,16
    80003826:	8082                	ret

0000000080003828 <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    80003828:	1101                	add	sp,sp,-32
    8000382a:	ec06                	sd	ra,24(sp)
    8000382c:	e822                	sd	s0,16(sp)
    8000382e:	e426                	sd	s1,8(sp)
    80003830:	e04a                	sd	s2,0(sp)
    80003832:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003834:	0001c917          	auipc	s2,0x1c
    80003838:	54c90913          	add	s2,s2,1356 # 8001fd80 <log>
    8000383c:	01892583          	lw	a1,24(s2)
    80003840:	02892503          	lw	a0,40(s2)
    80003844:	9ecff0ef          	jal	80002a30 <bread>
    80003848:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000384a:	02c92603          	lw	a2,44(s2)
    8000384e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003850:	00c05f63          	blez	a2,8000386e <write_head+0x46>
    80003854:	0001c717          	auipc	a4,0x1c
    80003858:	55c70713          	add	a4,a4,1372 # 8001fdb0 <log+0x30>
    8000385c:	87aa                	mv	a5,a0
    8000385e:	060a                	sll	a2,a2,0x2
    80003860:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003862:	4314                	lw	a3,0(a4)
    80003864:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003866:	0711                	add	a4,a4,4
    80003868:	0791                	add	a5,a5,4
    8000386a:	fec79ce3          	bne	a5,a2,80003862 <write_head+0x3a>
  }
  bwrite(buf);
    8000386e:	8526                	mv	a0,s1
    80003870:	a96ff0ef          	jal	80002b06 <bwrite>
  brelse(buf);
    80003874:	8526                	mv	a0,s1
    80003876:	ac2ff0ef          	jal	80002b38 <brelse>
}
    8000387a:	60e2                	ld	ra,24(sp)
    8000387c:	6442                	ld	s0,16(sp)
    8000387e:	64a2                	ld	s1,8(sp)
    80003880:	6902                	ld	s2,0(sp)
    80003882:	6105                	add	sp,sp,32
    80003884:	8082                	ret

0000000080003886 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003886:	0001c797          	auipc	a5,0x1c
    8000388a:	5267a783          	lw	a5,1318(a5) # 8001fdac <log+0x2c>
    8000388e:	08f05f63          	blez	a5,8000392c <install_trans+0xa6>
{
    80003892:	7139                	add	sp,sp,-64
    80003894:	fc06                	sd	ra,56(sp)
    80003896:	f822                	sd	s0,48(sp)
    80003898:	f426                	sd	s1,40(sp)
    8000389a:	f04a                	sd	s2,32(sp)
    8000389c:	ec4e                	sd	s3,24(sp)
    8000389e:	e852                	sd	s4,16(sp)
    800038a0:	e456                	sd	s5,8(sp)
    800038a2:	e05a                	sd	s6,0(sp)
    800038a4:	0080                	add	s0,sp,64
    800038a6:	8b2a                	mv	s6,a0
    800038a8:	0001ca97          	auipc	s5,0x1c
    800038ac:	508a8a93          	add	s5,s5,1288 # 8001fdb0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038b0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    800038b2:	0001c997          	auipc	s3,0x1c
    800038b6:	4ce98993          	add	s3,s3,1230 # 8001fd80 <log>
    800038ba:	a829                	j	800038d4 <install_trans+0x4e>
    brelse(lbuf);
    800038bc:	854a                	mv	a0,s2
    800038be:	a7aff0ef          	jal	80002b38 <brelse>
    brelse(dbuf);
    800038c2:	8526                	mv	a0,s1
    800038c4:	a74ff0ef          	jal	80002b38 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038c8:	2a05                	addw	s4,s4,1
    800038ca:	0a91                	add	s5,s5,4
    800038cc:	02c9a783          	lw	a5,44(s3)
    800038d0:	04fa5463          	bge	s4,a5,80003918 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    800038d4:	0189a583          	lw	a1,24(s3)
    800038d8:	014585bb          	addw	a1,a1,s4
    800038dc:	2585                	addw	a1,a1,1
    800038de:	0289a503          	lw	a0,40(s3)
    800038e2:	94eff0ef          	jal	80002a30 <bread>
    800038e6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    800038e8:	000aa583          	lw	a1,0(s5)
    800038ec:	0289a503          	lw	a0,40(s3)
    800038f0:	940ff0ef          	jal	80002a30 <bread>
    800038f4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    800038f6:	40000613          	li	a2,1024
    800038fa:	05890593          	add	a1,s2,88
    800038fe:	05850513          	add	a0,a0,88
    80003902:	bcefd0ef          	jal	80000cd0 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    80003906:	8526                	mv	a0,s1
    80003908:	9feff0ef          	jal	80002b06 <bwrite>
    if(recovering == 0)
    8000390c:	fa0b18e3          	bnez	s6,800038bc <install_trans+0x36>
      bunpin(dbuf);
    80003910:	8526                	mv	a0,s1
    80003912:	ae2ff0ef          	jal	80002bf4 <bunpin>
    80003916:	b75d                	j	800038bc <install_trans+0x36>
}
    80003918:	70e2                	ld	ra,56(sp)
    8000391a:	7442                	ld	s0,48(sp)
    8000391c:	74a2                	ld	s1,40(sp)
    8000391e:	7902                	ld	s2,32(sp)
    80003920:	69e2                	ld	s3,24(sp)
    80003922:	6a42                	ld	s4,16(sp)
    80003924:	6aa2                	ld	s5,8(sp)
    80003926:	6b02                	ld	s6,0(sp)
    80003928:	6121                	add	sp,sp,64
    8000392a:	8082                	ret
    8000392c:	8082                	ret

000000008000392e <initlog>:
{
    8000392e:	7179                	add	sp,sp,-48
    80003930:	f406                	sd	ra,40(sp)
    80003932:	f022                	sd	s0,32(sp)
    80003934:	ec26                	sd	s1,24(sp)
    80003936:	e84a                	sd	s2,16(sp)
    80003938:	e44e                	sd	s3,8(sp)
    8000393a:	1800                	add	s0,sp,48
    8000393c:	892a                	mv	s2,a0
    8000393e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003940:	0001c497          	auipc	s1,0x1c
    80003944:	44048493          	add	s1,s1,1088 # 8001fd80 <log>
    80003948:	00004597          	auipc	a1,0x4
    8000394c:	ea058593          	add	a1,a1,-352 # 800077e8 <syscalls_names+0x1e0>
    80003950:	8526                	mv	a0,s1
    80003952:	9cefd0ef          	jal	80000b20 <initlock>
  log.start = sb->logstart;
    80003956:	0149a583          	lw	a1,20(s3)
    8000395a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000395c:	0109a783          	lw	a5,16(s3)
    80003960:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003962:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003966:	854a                	mv	a0,s2
    80003968:	8c8ff0ef          	jal	80002a30 <bread>
  log.lh.n = lh->n;
    8000396c:	4d30                	lw	a2,88(a0)
    8000396e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003970:	00c05f63          	blez	a2,8000398e <initlog+0x60>
    80003974:	87aa                	mv	a5,a0
    80003976:	0001c717          	auipc	a4,0x1c
    8000397a:	43a70713          	add	a4,a4,1082 # 8001fdb0 <log+0x30>
    8000397e:	060a                	sll	a2,a2,0x2
    80003980:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003982:	4ff4                	lw	a3,92(a5)
    80003984:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003986:	0791                	add	a5,a5,4
    80003988:	0711                	add	a4,a4,4
    8000398a:	fec79ce3          	bne	a5,a2,80003982 <initlog+0x54>
  brelse(buf);
    8000398e:	9aaff0ef          	jal	80002b38 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    80003992:	4505                	li	a0,1
    80003994:	ef3ff0ef          	jal	80003886 <install_trans>
  log.lh.n = 0;
    80003998:	0001c797          	auipc	a5,0x1c
    8000399c:	4007aa23          	sw	zero,1044(a5) # 8001fdac <log+0x2c>
  write_head(); /* clear the log */
    800039a0:	e89ff0ef          	jal	80003828 <write_head>
}
    800039a4:	70a2                	ld	ra,40(sp)
    800039a6:	7402                	ld	s0,32(sp)
    800039a8:	64e2                	ld	s1,24(sp)
    800039aa:	6942                	ld	s2,16(sp)
    800039ac:	69a2                	ld	s3,8(sp)
    800039ae:	6145                	add	sp,sp,48
    800039b0:	8082                	ret

00000000800039b2 <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    800039b2:	1101                	add	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	e04a                	sd	s2,0(sp)
    800039bc:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800039be:	0001c517          	auipc	a0,0x1c
    800039c2:	3c250513          	add	a0,a0,962 # 8001fd80 <log>
    800039c6:	9dafd0ef          	jal	80000ba0 <acquire>
  while(1){
    if(log.committing){
    800039ca:	0001c497          	auipc	s1,0x1c
    800039ce:	3b648493          	add	s1,s1,950 # 8001fd80 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800039d2:	4979                	li	s2,30
    800039d4:	a029                	j	800039de <begin_op+0x2c>
      sleep(&log, &log.lock);
    800039d6:	85a6                	mv	a1,s1
    800039d8:	8526                	mv	a0,s1
    800039da:	c2efe0ef          	jal	80001e08 <sleep>
    if(log.committing){
    800039de:	50dc                	lw	a5,36(s1)
    800039e0:	fbfd                	bnez	a5,800039d6 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800039e2:	5098                	lw	a4,32(s1)
    800039e4:	2705                	addw	a4,a4,1
    800039e6:	0027179b          	sllw	a5,a4,0x2
    800039ea:	9fb9                	addw	a5,a5,a4
    800039ec:	0017979b          	sllw	a5,a5,0x1
    800039f0:	54d4                	lw	a3,44(s1)
    800039f2:	9fb5                	addw	a5,a5,a3
    800039f4:	00f95763          	bge	s2,a5,80003a02 <begin_op+0x50>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    800039f8:	85a6                	mv	a1,s1
    800039fa:	8526                	mv	a0,s1
    800039fc:	c0cfe0ef          	jal	80001e08 <sleep>
    80003a00:	bff9                	j	800039de <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003a02:	0001c517          	auipc	a0,0x1c
    80003a06:	37e50513          	add	a0,a0,894 # 8001fd80 <log>
    80003a0a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003a0c:	a2cfd0ef          	jal	80000c38 <release>
      break;
    }
  }
}
    80003a10:	60e2                	ld	ra,24(sp)
    80003a12:	6442                	ld	s0,16(sp)
    80003a14:	64a2                	ld	s1,8(sp)
    80003a16:	6902                	ld	s2,0(sp)
    80003a18:	6105                	add	sp,sp,32
    80003a1a:	8082                	ret

0000000080003a1c <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    80003a1c:	7139                	add	sp,sp,-64
    80003a1e:	fc06                	sd	ra,56(sp)
    80003a20:	f822                	sd	s0,48(sp)
    80003a22:	f426                	sd	s1,40(sp)
    80003a24:	f04a                	sd	s2,32(sp)
    80003a26:	ec4e                	sd	s3,24(sp)
    80003a28:	e852                	sd	s4,16(sp)
    80003a2a:	e456                	sd	s5,8(sp)
    80003a2c:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003a2e:	0001c497          	auipc	s1,0x1c
    80003a32:	35248493          	add	s1,s1,850 # 8001fd80 <log>
    80003a36:	8526                	mv	a0,s1
    80003a38:	968fd0ef          	jal	80000ba0 <acquire>
  log.outstanding -= 1;
    80003a3c:	509c                	lw	a5,32(s1)
    80003a3e:	37fd                	addw	a5,a5,-1
    80003a40:	0007891b          	sext.w	s2,a5
    80003a44:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003a46:	50dc                	lw	a5,36(s1)
    80003a48:	ef9d                	bnez	a5,80003a86 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003a4a:	04091463          	bnez	s2,80003a92 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003a4e:	0001c497          	auipc	s1,0x1c
    80003a52:	33248493          	add	s1,s1,818 # 8001fd80 <log>
    80003a56:	4785                	li	a5,1
    80003a58:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	9dcfd0ef          	jal	80000c38 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a60:	54dc                	lw	a5,44(s1)
    80003a62:	04f04b63          	bgtz	a5,80003ab8 <end_op+0x9c>
    acquire(&log.lock);
    80003a66:	0001c497          	auipc	s1,0x1c
    80003a6a:	31a48493          	add	s1,s1,794 # 8001fd80 <log>
    80003a6e:	8526                	mv	a0,s1
    80003a70:	930fd0ef          	jal	80000ba0 <acquire>
    log.committing = 0;
    80003a74:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003a78:	8526                	mv	a0,s1
    80003a7a:	bdafe0ef          	jal	80001e54 <wakeup>
    release(&log.lock);
    80003a7e:	8526                	mv	a0,s1
    80003a80:	9b8fd0ef          	jal	80000c38 <release>
}
    80003a84:	a00d                	j	80003aa6 <end_op+0x8a>
    panic("log.committing");
    80003a86:	00004517          	auipc	a0,0x4
    80003a8a:	d6a50513          	add	a0,a0,-662 # 800077f0 <syscalls_names+0x1e8>
    80003a8e:	cd1fc0ef          	jal	8000075e <panic>
    wakeup(&log);
    80003a92:	0001c497          	auipc	s1,0x1c
    80003a96:	2ee48493          	add	s1,s1,750 # 8001fd80 <log>
    80003a9a:	8526                	mv	a0,s1
    80003a9c:	bb8fe0ef          	jal	80001e54 <wakeup>
  release(&log.lock);
    80003aa0:	8526                	mv	a0,s1
    80003aa2:	996fd0ef          	jal	80000c38 <release>
}
    80003aa6:	70e2                	ld	ra,56(sp)
    80003aa8:	7442                	ld	s0,48(sp)
    80003aaa:	74a2                	ld	s1,40(sp)
    80003aac:	7902                	ld	s2,32(sp)
    80003aae:	69e2                	ld	s3,24(sp)
    80003ab0:	6a42                	ld	s4,16(sp)
    80003ab2:	6aa2                	ld	s5,8(sp)
    80003ab4:	6121                	add	sp,sp,64
    80003ab6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ab8:	0001ca97          	auipc	s5,0x1c
    80003abc:	2f8a8a93          	add	s5,s5,760 # 8001fdb0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    80003ac0:	0001ca17          	auipc	s4,0x1c
    80003ac4:	2c0a0a13          	add	s4,s4,704 # 8001fd80 <log>
    80003ac8:	018a2583          	lw	a1,24(s4)
    80003acc:	012585bb          	addw	a1,a1,s2
    80003ad0:	2585                	addw	a1,a1,1
    80003ad2:	028a2503          	lw	a0,40(s4)
    80003ad6:	f5bfe0ef          	jal	80002a30 <bread>
    80003ada:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    80003adc:	000aa583          	lw	a1,0(s5)
    80003ae0:	028a2503          	lw	a0,40(s4)
    80003ae4:	f4dfe0ef          	jal	80002a30 <bread>
    80003ae8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003aea:	40000613          	li	a2,1024
    80003aee:	05850593          	add	a1,a0,88
    80003af2:	05848513          	add	a0,s1,88
    80003af6:	9dafd0ef          	jal	80000cd0 <memmove>
    bwrite(to);  /* write the log */
    80003afa:	8526                	mv	a0,s1
    80003afc:	80aff0ef          	jal	80002b06 <bwrite>
    brelse(from);
    80003b00:	854e                	mv	a0,s3
    80003b02:	836ff0ef          	jal	80002b38 <brelse>
    brelse(to);
    80003b06:	8526                	mv	a0,s1
    80003b08:	830ff0ef          	jal	80002b38 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b0c:	2905                	addw	s2,s2,1
    80003b0e:	0a91                	add	s5,s5,4
    80003b10:	02ca2783          	lw	a5,44(s4)
    80003b14:	faf94ae3          	blt	s2,a5,80003ac8 <end_op+0xac>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    80003b18:	d11ff0ef          	jal	80003828 <write_head>
    install_trans(0); /* Now install writes to home locations */
    80003b1c:	4501                	li	a0,0
    80003b1e:	d69ff0ef          	jal	80003886 <install_trans>
    log.lh.n = 0;
    80003b22:	0001c797          	auipc	a5,0x1c
    80003b26:	2807a523          	sw	zero,650(a5) # 8001fdac <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    80003b2a:	cffff0ef          	jal	80003828 <write_head>
    80003b2e:	bf25                	j	80003a66 <end_op+0x4a>

0000000080003b30 <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    80003b30:	1101                	add	sp,sp,-32
    80003b32:	ec06                	sd	ra,24(sp)
    80003b34:	e822                	sd	s0,16(sp)
    80003b36:	e426                	sd	s1,8(sp)
    80003b38:	e04a                	sd	s2,0(sp)
    80003b3a:	1000                	add	s0,sp,32
    80003b3c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003b3e:	0001c917          	auipc	s2,0x1c
    80003b42:	24290913          	add	s2,s2,578 # 8001fd80 <log>
    80003b46:	854a                	mv	a0,s2
    80003b48:	858fd0ef          	jal	80000ba0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b4c:	02c92603          	lw	a2,44(s2)
    80003b50:	47f5                	li	a5,29
    80003b52:	06c7c363          	blt	a5,a2,80003bb8 <log_write+0x88>
    80003b56:	0001c797          	auipc	a5,0x1c
    80003b5a:	2467a783          	lw	a5,582(a5) # 8001fd9c <log+0x1c>
    80003b5e:	37fd                	addw	a5,a5,-1
    80003b60:	04f65c63          	bge	a2,a5,80003bb8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b64:	0001c797          	auipc	a5,0x1c
    80003b68:	23c7a783          	lw	a5,572(a5) # 8001fda0 <log+0x20>
    80003b6c:	04f05c63          	blez	a5,80003bc4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b70:	4781                	li	a5,0
    80003b72:	04c05f63          	blez	a2,80003bd0 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003b76:	44cc                	lw	a1,12(s1)
    80003b78:	0001c717          	auipc	a4,0x1c
    80003b7c:	23870713          	add	a4,a4,568 # 8001fdb0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b80:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003b82:	4314                	lw	a3,0(a4)
    80003b84:	04b68663          	beq	a3,a1,80003bd0 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003b88:	2785                	addw	a5,a5,1
    80003b8a:	0711                	add	a4,a4,4
    80003b8c:	fef61be3          	bne	a2,a5,80003b82 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b90:	0621                	add	a2,a2,8
    80003b92:	060a                	sll	a2,a2,0x2
    80003b94:	0001c797          	auipc	a5,0x1c
    80003b98:	1ec78793          	add	a5,a5,492 # 8001fd80 <log>
    80003b9c:	97b2                	add	a5,a5,a2
    80003b9e:	44d8                	lw	a4,12(s1)
    80003ba0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    80003ba2:	8526                	mv	a0,s1
    80003ba4:	81cff0ef          	jal	80002bc0 <bpin>
    log.lh.n++;
    80003ba8:	0001c717          	auipc	a4,0x1c
    80003bac:	1d870713          	add	a4,a4,472 # 8001fd80 <log>
    80003bb0:	575c                	lw	a5,44(a4)
    80003bb2:	2785                	addw	a5,a5,1
    80003bb4:	d75c                	sw	a5,44(a4)
    80003bb6:	a80d                	j	80003be8 <log_write+0xb8>
    panic("too big a transaction");
    80003bb8:	00004517          	auipc	a0,0x4
    80003bbc:	c4850513          	add	a0,a0,-952 # 80007800 <syscalls_names+0x1f8>
    80003bc0:	b9ffc0ef          	jal	8000075e <panic>
    panic("log_write outside of trans");
    80003bc4:	00004517          	auipc	a0,0x4
    80003bc8:	c5450513          	add	a0,a0,-940 # 80007818 <syscalls_names+0x210>
    80003bcc:	b93fc0ef          	jal	8000075e <panic>
  log.lh.block[i] = b->blockno;
    80003bd0:	00878693          	add	a3,a5,8
    80003bd4:	068a                	sll	a3,a3,0x2
    80003bd6:	0001c717          	auipc	a4,0x1c
    80003bda:	1aa70713          	add	a4,a4,426 # 8001fd80 <log>
    80003bde:	9736                	add	a4,a4,a3
    80003be0:	44d4                	lw	a3,12(s1)
    80003be2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    80003be4:	faf60fe3          	beq	a2,a5,80003ba2 <log_write+0x72>
  }
  release(&log.lock);
    80003be8:	0001c517          	auipc	a0,0x1c
    80003bec:	19850513          	add	a0,a0,408 # 8001fd80 <log>
    80003bf0:	848fd0ef          	jal	80000c38 <release>
}
    80003bf4:	60e2                	ld	ra,24(sp)
    80003bf6:	6442                	ld	s0,16(sp)
    80003bf8:	64a2                	ld	s1,8(sp)
    80003bfa:	6902                	ld	s2,0(sp)
    80003bfc:	6105                	add	sp,sp,32
    80003bfe:	8082                	ret

0000000080003c00 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003c00:	1101                	add	sp,sp,-32
    80003c02:	ec06                	sd	ra,24(sp)
    80003c04:	e822                	sd	s0,16(sp)
    80003c06:	e426                	sd	s1,8(sp)
    80003c08:	e04a                	sd	s2,0(sp)
    80003c0a:	1000                	add	s0,sp,32
    80003c0c:	84aa                	mv	s1,a0
    80003c0e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003c10:	00004597          	auipc	a1,0x4
    80003c14:	c2858593          	add	a1,a1,-984 # 80007838 <syscalls_names+0x230>
    80003c18:	0521                	add	a0,a0,8
    80003c1a:	f07fc0ef          	jal	80000b20 <initlock>
  lk->name = name;
    80003c1e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003c22:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c26:	0204a423          	sw	zero,40(s1)
}
    80003c2a:	60e2                	ld	ra,24(sp)
    80003c2c:	6442                	ld	s0,16(sp)
    80003c2e:	64a2                	ld	s1,8(sp)
    80003c30:	6902                	ld	s2,0(sp)
    80003c32:	6105                	add	sp,sp,32
    80003c34:	8082                	ret

0000000080003c36 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c36:	1101                	add	sp,sp,-32
    80003c38:	ec06                	sd	ra,24(sp)
    80003c3a:	e822                	sd	s0,16(sp)
    80003c3c:	e426                	sd	s1,8(sp)
    80003c3e:	e04a                	sd	s2,0(sp)
    80003c40:	1000                	add	s0,sp,32
    80003c42:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c44:	00850913          	add	s2,a0,8
    80003c48:	854a                	mv	a0,s2
    80003c4a:	f57fc0ef          	jal	80000ba0 <acquire>
  while (lk->locked) {
    80003c4e:	409c                	lw	a5,0(s1)
    80003c50:	c799                	beqz	a5,80003c5e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003c52:	85ca                	mv	a1,s2
    80003c54:	8526                	mv	a0,s1
    80003c56:	9b2fe0ef          	jal	80001e08 <sleep>
  while (lk->locked) {
    80003c5a:	409c                	lw	a5,0(s1)
    80003c5c:	fbfd                	bnez	a5,80003c52 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003c5e:	4785                	li	a5,1
    80003c60:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c62:	bcffd0ef          	jal	80001830 <myproc>
    80003c66:	591c                	lw	a5,48(a0)
    80003c68:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c6a:	854a                	mv	a0,s2
    80003c6c:	fcdfc0ef          	jal	80000c38 <release>
}
    80003c70:	60e2                	ld	ra,24(sp)
    80003c72:	6442                	ld	s0,16(sp)
    80003c74:	64a2                	ld	s1,8(sp)
    80003c76:	6902                	ld	s2,0(sp)
    80003c78:	6105                	add	sp,sp,32
    80003c7a:	8082                	ret

0000000080003c7c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c7c:	1101                	add	sp,sp,-32
    80003c7e:	ec06                	sd	ra,24(sp)
    80003c80:	e822                	sd	s0,16(sp)
    80003c82:	e426                	sd	s1,8(sp)
    80003c84:	e04a                	sd	s2,0(sp)
    80003c86:	1000                	add	s0,sp,32
    80003c88:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c8a:	00850913          	add	s2,a0,8
    80003c8e:	854a                	mv	a0,s2
    80003c90:	f11fc0ef          	jal	80000ba0 <acquire>
  lk->locked = 0;
    80003c94:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c98:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c9c:	8526                	mv	a0,s1
    80003c9e:	9b6fe0ef          	jal	80001e54 <wakeup>
  release(&lk->lk);
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	f95fc0ef          	jal	80000c38 <release>
}
    80003ca8:	60e2                	ld	ra,24(sp)
    80003caa:	6442                	ld	s0,16(sp)
    80003cac:	64a2                	ld	s1,8(sp)
    80003cae:	6902                	ld	s2,0(sp)
    80003cb0:	6105                	add	sp,sp,32
    80003cb2:	8082                	ret

0000000080003cb4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003cb4:	7179                	add	sp,sp,-48
    80003cb6:	f406                	sd	ra,40(sp)
    80003cb8:	f022                	sd	s0,32(sp)
    80003cba:	ec26                	sd	s1,24(sp)
    80003cbc:	e84a                	sd	s2,16(sp)
    80003cbe:	e44e                	sd	s3,8(sp)
    80003cc0:	1800                	add	s0,sp,48
    80003cc2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003cc4:	00850913          	add	s2,a0,8
    80003cc8:	854a                	mv	a0,s2
    80003cca:	ed7fc0ef          	jal	80000ba0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cce:	409c                	lw	a5,0(s1)
    80003cd0:	ef89                	bnez	a5,80003cea <holdingsleep+0x36>
    80003cd2:	4481                	li	s1,0
  release(&lk->lk);
    80003cd4:	854a                	mv	a0,s2
    80003cd6:	f63fc0ef          	jal	80000c38 <release>
  return r;
}
    80003cda:	8526                	mv	a0,s1
    80003cdc:	70a2                	ld	ra,40(sp)
    80003cde:	7402                	ld	s0,32(sp)
    80003ce0:	64e2                	ld	s1,24(sp)
    80003ce2:	6942                	ld	s2,16(sp)
    80003ce4:	69a2                	ld	s3,8(sp)
    80003ce6:	6145                	add	sp,sp,48
    80003ce8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cea:	0284a983          	lw	s3,40(s1)
    80003cee:	b43fd0ef          	jal	80001830 <myproc>
    80003cf2:	5904                	lw	s1,48(a0)
    80003cf4:	413484b3          	sub	s1,s1,s3
    80003cf8:	0014b493          	seqz	s1,s1
    80003cfc:	bfe1                	j	80003cd4 <holdingsleep+0x20>

0000000080003cfe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003cfe:	1141                	add	sp,sp,-16
    80003d00:	e406                	sd	ra,8(sp)
    80003d02:	e022                	sd	s0,0(sp)
    80003d04:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003d06:	00004597          	auipc	a1,0x4
    80003d0a:	b4258593          	add	a1,a1,-1214 # 80007848 <syscalls_names+0x240>
    80003d0e:	0001c517          	auipc	a0,0x1c
    80003d12:	1ba50513          	add	a0,a0,442 # 8001fec8 <ftable>
    80003d16:	e0bfc0ef          	jal	80000b20 <initlock>
}
    80003d1a:	60a2                	ld	ra,8(sp)
    80003d1c:	6402                	ld	s0,0(sp)
    80003d1e:	0141                	add	sp,sp,16
    80003d20:	8082                	ret

0000000080003d22 <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    80003d22:	1101                	add	sp,sp,-32
    80003d24:	ec06                	sd	ra,24(sp)
    80003d26:	e822                	sd	s0,16(sp)
    80003d28:	e426                	sd	s1,8(sp)
    80003d2a:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003d2c:	0001c517          	auipc	a0,0x1c
    80003d30:	19c50513          	add	a0,a0,412 # 8001fec8 <ftable>
    80003d34:	e6dfc0ef          	jal	80000ba0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d38:	0001c497          	auipc	s1,0x1c
    80003d3c:	1a848493          	add	s1,s1,424 # 8001fee0 <ftable+0x18>
    80003d40:	0001d717          	auipc	a4,0x1d
    80003d44:	14070713          	add	a4,a4,320 # 80020e80 <disk>
    if(f->ref == 0){
    80003d48:	40dc                	lw	a5,4(s1)
    80003d4a:	cf89                	beqz	a5,80003d64 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d4c:	02848493          	add	s1,s1,40
    80003d50:	fee49ce3          	bne	s1,a4,80003d48 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d54:	0001c517          	auipc	a0,0x1c
    80003d58:	17450513          	add	a0,a0,372 # 8001fec8 <ftable>
    80003d5c:	eddfc0ef          	jal	80000c38 <release>
  return 0;
    80003d60:	4481                	li	s1,0
    80003d62:	a809                	j	80003d74 <filealloc+0x52>
      f->ref = 1;
    80003d64:	4785                	li	a5,1
    80003d66:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d68:	0001c517          	auipc	a0,0x1c
    80003d6c:	16050513          	add	a0,a0,352 # 8001fec8 <ftable>
    80003d70:	ec9fc0ef          	jal	80000c38 <release>
}
    80003d74:	8526                	mv	a0,s1
    80003d76:	60e2                	ld	ra,24(sp)
    80003d78:	6442                	ld	s0,16(sp)
    80003d7a:	64a2                	ld	s1,8(sp)
    80003d7c:	6105                	add	sp,sp,32
    80003d7e:	8082                	ret

0000000080003d80 <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    80003d80:	1101                	add	sp,sp,-32
    80003d82:	ec06                	sd	ra,24(sp)
    80003d84:	e822                	sd	s0,16(sp)
    80003d86:	e426                	sd	s1,8(sp)
    80003d88:	1000                	add	s0,sp,32
    80003d8a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d8c:	0001c517          	auipc	a0,0x1c
    80003d90:	13c50513          	add	a0,a0,316 # 8001fec8 <ftable>
    80003d94:	e0dfc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003d98:	40dc                	lw	a5,4(s1)
    80003d9a:	02f05063          	blez	a5,80003dba <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003d9e:	2785                	addw	a5,a5,1
    80003da0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003da2:	0001c517          	auipc	a0,0x1c
    80003da6:	12650513          	add	a0,a0,294 # 8001fec8 <ftable>
    80003daa:	e8ffc0ef          	jal	80000c38 <release>
  return f;
}
    80003dae:	8526                	mv	a0,s1
    80003db0:	60e2                	ld	ra,24(sp)
    80003db2:	6442                	ld	s0,16(sp)
    80003db4:	64a2                	ld	s1,8(sp)
    80003db6:	6105                	add	sp,sp,32
    80003db8:	8082                	ret
    panic("filedup");
    80003dba:	00004517          	auipc	a0,0x4
    80003dbe:	a9650513          	add	a0,a0,-1386 # 80007850 <syscalls_names+0x248>
    80003dc2:	99dfc0ef          	jal	8000075e <panic>

0000000080003dc6 <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    80003dc6:	7139                	add	sp,sp,-64
    80003dc8:	fc06                	sd	ra,56(sp)
    80003dca:	f822                	sd	s0,48(sp)
    80003dcc:	f426                	sd	s1,40(sp)
    80003dce:	f04a                	sd	s2,32(sp)
    80003dd0:	ec4e                	sd	s3,24(sp)
    80003dd2:	e852                	sd	s4,16(sp)
    80003dd4:	e456                	sd	s5,8(sp)
    80003dd6:	0080                	add	s0,sp,64
    80003dd8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003dda:	0001c517          	auipc	a0,0x1c
    80003dde:	0ee50513          	add	a0,a0,238 # 8001fec8 <ftable>
    80003de2:	dbffc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003de6:	40dc                	lw	a5,4(s1)
    80003de8:	04f05963          	blez	a5,80003e3a <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003dec:	37fd                	addw	a5,a5,-1
    80003dee:	0007871b          	sext.w	a4,a5
    80003df2:	c0dc                	sw	a5,4(s1)
    80003df4:	04e04963          	bgtz	a4,80003e46 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003df8:	0004a903          	lw	s2,0(s1)
    80003dfc:	0094ca83          	lbu	s5,9(s1)
    80003e00:	0104ba03          	ld	s4,16(s1)
    80003e04:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003e08:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003e0c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003e10:	0001c517          	auipc	a0,0x1c
    80003e14:	0b850513          	add	a0,a0,184 # 8001fec8 <ftable>
    80003e18:	e21fc0ef          	jal	80000c38 <release>

  if(ff.type == FD_PIPE){
    80003e1c:	4785                	li	a5,1
    80003e1e:	04f90363          	beq	s2,a5,80003e64 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003e22:	3979                	addw	s2,s2,-2
    80003e24:	4785                	li	a5,1
    80003e26:	0327e663          	bltu	a5,s2,80003e52 <fileclose+0x8c>
    begin_op();
    80003e2a:	b89ff0ef          	jal	800039b2 <begin_op>
    iput(ff.ip);
    80003e2e:	854e                	mv	a0,s3
    80003e30:	c92ff0ef          	jal	800032c2 <iput>
    end_op();
    80003e34:	be9ff0ef          	jal	80003a1c <end_op>
    80003e38:	a829                	j	80003e52 <fileclose+0x8c>
    panic("fileclose");
    80003e3a:	00004517          	auipc	a0,0x4
    80003e3e:	a1e50513          	add	a0,a0,-1506 # 80007858 <syscalls_names+0x250>
    80003e42:	91dfc0ef          	jal	8000075e <panic>
    release(&ftable.lock);
    80003e46:	0001c517          	auipc	a0,0x1c
    80003e4a:	08250513          	add	a0,a0,130 # 8001fec8 <ftable>
    80003e4e:	debfc0ef          	jal	80000c38 <release>
  }
}
    80003e52:	70e2                	ld	ra,56(sp)
    80003e54:	7442                	ld	s0,48(sp)
    80003e56:	74a2                	ld	s1,40(sp)
    80003e58:	7902                	ld	s2,32(sp)
    80003e5a:	69e2                	ld	s3,24(sp)
    80003e5c:	6a42                	ld	s4,16(sp)
    80003e5e:	6aa2                	ld	s5,8(sp)
    80003e60:	6121                	add	sp,sp,64
    80003e62:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e64:	85d6                	mv	a1,s5
    80003e66:	8552                	mv	a0,s4
    80003e68:	2e8000ef          	jal	80004150 <pipeclose>
    80003e6c:	b7dd                	j	80003e52 <fileclose+0x8c>

0000000080003e6e <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    80003e6e:	715d                	add	sp,sp,-80
    80003e70:	e486                	sd	ra,72(sp)
    80003e72:	e0a2                	sd	s0,64(sp)
    80003e74:	fc26                	sd	s1,56(sp)
    80003e76:	f84a                	sd	s2,48(sp)
    80003e78:	f44e                	sd	s3,40(sp)
    80003e7a:	0880                	add	s0,sp,80
    80003e7c:	84aa                	mv	s1,a0
    80003e7e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e80:	9b1fd0ef          	jal	80001830 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e84:	409c                	lw	a5,0(s1)
    80003e86:	37f9                	addw	a5,a5,-2
    80003e88:	4705                	li	a4,1
    80003e8a:	02f76f63          	bltu	a4,a5,80003ec8 <filestat+0x5a>
    80003e8e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e90:	6c88                	ld	a0,24(s1)
    80003e92:	ab2ff0ef          	jal	80003144 <ilock>
    stati(f->ip, &st);
    80003e96:	fb840593          	add	a1,s0,-72
    80003e9a:	6c88                	ld	a0,24(s1)
    80003e9c:	cceff0ef          	jal	8000336a <stati>
    iunlock(f->ip);
    80003ea0:	6c88                	ld	a0,24(s1)
    80003ea2:	b4cff0ef          	jal	800031ee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ea6:	46e1                	li	a3,24
    80003ea8:	fb840613          	add	a2,s0,-72
    80003eac:	85ce                	mv	a1,s3
    80003eae:	05893503          	ld	a0,88(s2)
    80003eb2:	e36fd0ef          	jal	800014e8 <copyout>
    80003eb6:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003eba:	60a6                	ld	ra,72(sp)
    80003ebc:	6406                	ld	s0,64(sp)
    80003ebe:	74e2                	ld	s1,56(sp)
    80003ec0:	7942                	ld	s2,48(sp)
    80003ec2:	79a2                	ld	s3,40(sp)
    80003ec4:	6161                	add	sp,sp,80
    80003ec6:	8082                	ret
  return -1;
    80003ec8:	557d                	li	a0,-1
    80003eca:	bfc5                	j	80003eba <filestat+0x4c>

0000000080003ecc <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ecc:	7179                	add	sp,sp,-48
    80003ece:	f406                	sd	ra,40(sp)
    80003ed0:	f022                	sd	s0,32(sp)
    80003ed2:	ec26                	sd	s1,24(sp)
    80003ed4:	e84a                	sd	s2,16(sp)
    80003ed6:	e44e                	sd	s3,8(sp)
    80003ed8:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003eda:	00854783          	lbu	a5,8(a0)
    80003ede:	cbc1                	beqz	a5,80003f6e <fileread+0xa2>
    80003ee0:	84aa                	mv	s1,a0
    80003ee2:	89ae                	mv	s3,a1
    80003ee4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ee6:	411c                	lw	a5,0(a0)
    80003ee8:	4705                	li	a4,1
    80003eea:	04e78363          	beq	a5,a4,80003f30 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eee:	470d                	li	a4,3
    80003ef0:	04e78563          	beq	a5,a4,80003f3a <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ef4:	4709                	li	a4,2
    80003ef6:	06e79663          	bne	a5,a4,80003f62 <fileread+0x96>
    ilock(f->ip);
    80003efa:	6d08                	ld	a0,24(a0)
    80003efc:	a48ff0ef          	jal	80003144 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003f00:	874a                	mv	a4,s2
    80003f02:	5094                	lw	a3,32(s1)
    80003f04:	864e                	mv	a2,s3
    80003f06:	4585                	li	a1,1
    80003f08:	6c88                	ld	a0,24(s1)
    80003f0a:	c8aff0ef          	jal	80003394 <readi>
    80003f0e:	892a                	mv	s2,a0
    80003f10:	00a05563          	blez	a0,80003f1a <fileread+0x4e>
      f->off += r;
    80003f14:	509c                	lw	a5,32(s1)
    80003f16:	9fa9                	addw	a5,a5,a0
    80003f18:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003f1a:	6c88                	ld	a0,24(s1)
    80003f1c:	ad2ff0ef          	jal	800031ee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003f20:	854a                	mv	a0,s2
    80003f22:	70a2                	ld	ra,40(sp)
    80003f24:	7402                	ld	s0,32(sp)
    80003f26:	64e2                	ld	s1,24(sp)
    80003f28:	6942                	ld	s2,16(sp)
    80003f2a:	69a2                	ld	s3,8(sp)
    80003f2c:	6145                	add	sp,sp,48
    80003f2e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003f30:	6908                	ld	a0,16(a0)
    80003f32:	34a000ef          	jal	8000427c <piperead>
    80003f36:	892a                	mv	s2,a0
    80003f38:	b7e5                	j	80003f20 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f3a:	02451783          	lh	a5,36(a0)
    80003f3e:	03079693          	sll	a3,a5,0x30
    80003f42:	92c1                	srl	a3,a3,0x30
    80003f44:	4725                	li	a4,9
    80003f46:	02d76663          	bltu	a4,a3,80003f72 <fileread+0xa6>
    80003f4a:	0792                	sll	a5,a5,0x4
    80003f4c:	0001c717          	auipc	a4,0x1c
    80003f50:	edc70713          	add	a4,a4,-292 # 8001fe28 <devsw>
    80003f54:	97ba                	add	a5,a5,a4
    80003f56:	639c                	ld	a5,0(a5)
    80003f58:	cf99                	beqz	a5,80003f76 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003f5a:	4505                	li	a0,1
    80003f5c:	9782                	jalr	a5
    80003f5e:	892a                	mv	s2,a0
    80003f60:	b7c1                	j	80003f20 <fileread+0x54>
    panic("fileread");
    80003f62:	00004517          	auipc	a0,0x4
    80003f66:	90650513          	add	a0,a0,-1786 # 80007868 <syscalls_names+0x260>
    80003f6a:	ff4fc0ef          	jal	8000075e <panic>
    return -1;
    80003f6e:	597d                	li	s2,-1
    80003f70:	bf45                	j	80003f20 <fileread+0x54>
      return -1;
    80003f72:	597d                	li	s2,-1
    80003f74:	b775                	j	80003f20 <fileread+0x54>
    80003f76:	597d                	li	s2,-1
    80003f78:	b765                	j	80003f20 <fileread+0x54>

0000000080003f7a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f7a:	00954783          	lbu	a5,9(a0)
    80003f7e:	10078063          	beqz	a5,8000407e <filewrite+0x104>
{
    80003f82:	715d                	add	sp,sp,-80
    80003f84:	e486                	sd	ra,72(sp)
    80003f86:	e0a2                	sd	s0,64(sp)
    80003f88:	fc26                	sd	s1,56(sp)
    80003f8a:	f84a                	sd	s2,48(sp)
    80003f8c:	f44e                	sd	s3,40(sp)
    80003f8e:	f052                	sd	s4,32(sp)
    80003f90:	ec56                	sd	s5,24(sp)
    80003f92:	e85a                	sd	s6,16(sp)
    80003f94:	e45e                	sd	s7,8(sp)
    80003f96:	e062                	sd	s8,0(sp)
    80003f98:	0880                	add	s0,sp,80
    80003f9a:	892a                	mv	s2,a0
    80003f9c:	8b2e                	mv	s6,a1
    80003f9e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003fa0:	411c                	lw	a5,0(a0)
    80003fa2:	4705                	li	a4,1
    80003fa4:	02e78263          	beq	a5,a4,80003fc8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003fa8:	470d                	li	a4,3
    80003faa:	02e78363          	beq	a5,a4,80003fd0 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fae:	4709                	li	a4,2
    80003fb0:	0ce79163          	bne	a5,a4,80004072 <filewrite+0xf8>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003fb4:	08c05f63          	blez	a2,80004052 <filewrite+0xd8>
    int i = 0;
    80003fb8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003fba:	6b85                	lui	s7,0x1
    80003fbc:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003fc0:	6c05                	lui	s8,0x1
    80003fc2:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003fc6:	a8b5                	j	80004042 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003fc8:	6908                	ld	a0,16(a0)
    80003fca:	1de000ef          	jal	800041a8 <pipewrite>
    80003fce:	a071                	j	8000405a <filewrite+0xe0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003fd0:	02451783          	lh	a5,36(a0)
    80003fd4:	03079693          	sll	a3,a5,0x30
    80003fd8:	92c1                	srl	a3,a3,0x30
    80003fda:	4725                	li	a4,9
    80003fdc:	0ad76363          	bltu	a4,a3,80004082 <filewrite+0x108>
    80003fe0:	0792                	sll	a5,a5,0x4
    80003fe2:	0001c717          	auipc	a4,0x1c
    80003fe6:	e4670713          	add	a4,a4,-442 # 8001fe28 <devsw>
    80003fea:	97ba                	add	a5,a5,a4
    80003fec:	679c                	ld	a5,8(a5)
    80003fee:	cfc1                	beqz	a5,80004086 <filewrite+0x10c>
    ret = devsw[f->major].write(1, addr, n);
    80003ff0:	4505                	li	a0,1
    80003ff2:	9782                	jalr	a5
    80003ff4:	a09d                	j	8000405a <filewrite+0xe0>
      if(n1 > max)
    80003ff6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003ffa:	9b9ff0ef          	jal	800039b2 <begin_op>
      ilock(f->ip);
    80003ffe:	01893503          	ld	a0,24(s2)
    80004002:	942ff0ef          	jal	80003144 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004006:	8756                	mv	a4,s5
    80004008:	02092683          	lw	a3,32(s2)
    8000400c:	01698633          	add	a2,s3,s6
    80004010:	4585                	li	a1,1
    80004012:	01893503          	ld	a0,24(s2)
    80004016:	c62ff0ef          	jal	80003478 <writei>
    8000401a:	84aa                	mv	s1,a0
    8000401c:	00a05763          	blez	a0,8000402a <filewrite+0xb0>
        f->off += r;
    80004020:	02092783          	lw	a5,32(s2)
    80004024:	9fa9                	addw	a5,a5,a0
    80004026:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000402a:	01893503          	ld	a0,24(s2)
    8000402e:	9c0ff0ef          	jal	800031ee <iunlock>
      end_op();
    80004032:	9ebff0ef          	jal	80003a1c <end_op>

      if(r != n1){
    80004036:	009a9f63          	bne	s5,s1,80004054 <filewrite+0xda>
        /* error from writei */
        break;
      }
      i += r;
    8000403a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000403e:	0149db63          	bge	s3,s4,80004054 <filewrite+0xda>
      int n1 = n - i;
    80004042:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004046:	0004879b          	sext.w	a5,s1
    8000404a:	fafbd6e3          	bge	s7,a5,80003ff6 <filewrite+0x7c>
    8000404e:	84e2                	mv	s1,s8
    80004050:	b75d                	j	80003ff6 <filewrite+0x7c>
    int i = 0;
    80004052:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004054:	033a1b63          	bne	s4,s3,8000408a <filewrite+0x110>
    80004058:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000405a:	60a6                	ld	ra,72(sp)
    8000405c:	6406                	ld	s0,64(sp)
    8000405e:	74e2                	ld	s1,56(sp)
    80004060:	7942                	ld	s2,48(sp)
    80004062:	79a2                	ld	s3,40(sp)
    80004064:	7a02                	ld	s4,32(sp)
    80004066:	6ae2                	ld	s5,24(sp)
    80004068:	6b42                	ld	s6,16(sp)
    8000406a:	6ba2                	ld	s7,8(sp)
    8000406c:	6c02                	ld	s8,0(sp)
    8000406e:	6161                	add	sp,sp,80
    80004070:	8082                	ret
    panic("filewrite");
    80004072:	00004517          	auipc	a0,0x4
    80004076:	80650513          	add	a0,a0,-2042 # 80007878 <syscalls_names+0x270>
    8000407a:	ee4fc0ef          	jal	8000075e <panic>
    return -1;
    8000407e:	557d                	li	a0,-1
}
    80004080:	8082                	ret
      return -1;
    80004082:	557d                	li	a0,-1
    80004084:	bfd9                	j	8000405a <filewrite+0xe0>
    80004086:	557d                	li	a0,-1
    80004088:	bfc9                	j	8000405a <filewrite+0xe0>
    ret = (i == n ? n : -1);
    8000408a:	557d                	li	a0,-1
    8000408c:	b7f9                	j	8000405a <filewrite+0xe0>

000000008000408e <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000408e:	7179                	add	sp,sp,-48
    80004090:	f406                	sd	ra,40(sp)
    80004092:	f022                	sd	s0,32(sp)
    80004094:	ec26                	sd	s1,24(sp)
    80004096:	e84a                	sd	s2,16(sp)
    80004098:	e44e                	sd	s3,8(sp)
    8000409a:	e052                	sd	s4,0(sp)
    8000409c:	1800                	add	s0,sp,48
    8000409e:	84aa                	mv	s1,a0
    800040a0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800040a2:	0005b023          	sd	zero,0(a1)
    800040a6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800040aa:	c79ff0ef          	jal	80003d22 <filealloc>
    800040ae:	e088                	sd	a0,0(s1)
    800040b0:	cd35                	beqz	a0,8000412c <pipealloc+0x9e>
    800040b2:	c71ff0ef          	jal	80003d22 <filealloc>
    800040b6:	00aa3023          	sd	a0,0(s4)
    800040ba:	c52d                	beqz	a0,80004124 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800040bc:	a15fc0ef          	jal	80000ad0 <kalloc>
    800040c0:	892a                	mv	s2,a0
    800040c2:	cd31                	beqz	a0,8000411e <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800040c4:	4985                	li	s3,1
    800040c6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800040ca:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800040ce:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800040d2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800040d6:	00003597          	auipc	a1,0x3
    800040da:	3d258593          	add	a1,a1,978 # 800074a8 <states.0+0x1a8>
    800040de:	a43fc0ef          	jal	80000b20 <initlock>
  (*f0)->type = FD_PIPE;
    800040e2:	609c                	ld	a5,0(s1)
    800040e4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040e8:	609c                	ld	a5,0(s1)
    800040ea:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040ee:	609c                	ld	a5,0(s1)
    800040f0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040f4:	609c                	ld	a5,0(s1)
    800040f6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040fa:	000a3783          	ld	a5,0(s4)
    800040fe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004102:	000a3783          	ld	a5,0(s4)
    80004106:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000410a:	000a3783          	ld	a5,0(s4)
    8000410e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004112:	000a3783          	ld	a5,0(s4)
    80004116:	0127b823          	sd	s2,16(a5)
  return 0;
    8000411a:	4501                	li	a0,0
    8000411c:	a005                	j	8000413c <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000411e:	6088                	ld	a0,0(s1)
    80004120:	e501                	bnez	a0,80004128 <pipealloc+0x9a>
    80004122:	a029                	j	8000412c <pipealloc+0x9e>
    80004124:	6088                	ld	a0,0(s1)
    80004126:	c11d                	beqz	a0,8000414c <pipealloc+0xbe>
    fileclose(*f0);
    80004128:	c9fff0ef          	jal	80003dc6 <fileclose>
  if(*f1)
    8000412c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004130:	557d                	li	a0,-1
  if(*f1)
    80004132:	c789                	beqz	a5,8000413c <pipealloc+0xae>
    fileclose(*f1);
    80004134:	853e                	mv	a0,a5
    80004136:	c91ff0ef          	jal	80003dc6 <fileclose>
  return -1;
    8000413a:	557d                	li	a0,-1
}
    8000413c:	70a2                	ld	ra,40(sp)
    8000413e:	7402                	ld	s0,32(sp)
    80004140:	64e2                	ld	s1,24(sp)
    80004142:	6942                	ld	s2,16(sp)
    80004144:	69a2                	ld	s3,8(sp)
    80004146:	6a02                	ld	s4,0(sp)
    80004148:	6145                	add	sp,sp,48
    8000414a:	8082                	ret
  return -1;
    8000414c:	557d                	li	a0,-1
    8000414e:	b7fd                	j	8000413c <pipealloc+0xae>

0000000080004150 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004150:	1101                	add	sp,sp,-32
    80004152:	ec06                	sd	ra,24(sp)
    80004154:	e822                	sd	s0,16(sp)
    80004156:	e426                	sd	s1,8(sp)
    80004158:	e04a                	sd	s2,0(sp)
    8000415a:	1000                	add	s0,sp,32
    8000415c:	84aa                	mv	s1,a0
    8000415e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004160:	a41fc0ef          	jal	80000ba0 <acquire>
  if(writable){
    80004164:	02090763          	beqz	s2,80004192 <pipeclose+0x42>
    pi->writeopen = 0;
    80004168:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000416c:	21848513          	add	a0,s1,536
    80004170:	ce5fd0ef          	jal	80001e54 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004174:	2204b783          	ld	a5,544(s1)
    80004178:	e785                	bnez	a5,800041a0 <pipeclose+0x50>
    release(&pi->lock);
    8000417a:	8526                	mv	a0,s1
    8000417c:	abdfc0ef          	jal	80000c38 <release>
    kfree((char*)pi);
    80004180:	8526                	mv	a0,s1
    80004182:	86dfc0ef          	jal	800009ee <kfree>
  } else
    release(&pi->lock);
}
    80004186:	60e2                	ld	ra,24(sp)
    80004188:	6442                	ld	s0,16(sp)
    8000418a:	64a2                	ld	s1,8(sp)
    8000418c:	6902                	ld	s2,0(sp)
    8000418e:	6105                	add	sp,sp,32
    80004190:	8082                	ret
    pi->readopen = 0;
    80004192:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004196:	21c48513          	add	a0,s1,540
    8000419a:	cbbfd0ef          	jal	80001e54 <wakeup>
    8000419e:	bfd9                	j	80004174 <pipeclose+0x24>
    release(&pi->lock);
    800041a0:	8526                	mv	a0,s1
    800041a2:	a97fc0ef          	jal	80000c38 <release>
}
    800041a6:	b7c5                	j	80004186 <pipeclose+0x36>

00000000800041a8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800041a8:	711d                	add	sp,sp,-96
    800041aa:	ec86                	sd	ra,88(sp)
    800041ac:	e8a2                	sd	s0,80(sp)
    800041ae:	e4a6                	sd	s1,72(sp)
    800041b0:	e0ca                	sd	s2,64(sp)
    800041b2:	fc4e                	sd	s3,56(sp)
    800041b4:	f852                	sd	s4,48(sp)
    800041b6:	f456                	sd	s5,40(sp)
    800041b8:	f05a                	sd	s6,32(sp)
    800041ba:	ec5e                	sd	s7,24(sp)
    800041bc:	e862                	sd	s8,16(sp)
    800041be:	1080                	add	s0,sp,96
    800041c0:	84aa                	mv	s1,a0
    800041c2:	8aae                	mv	s5,a1
    800041c4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041c6:	e6afd0ef          	jal	80001830 <myproc>
    800041ca:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041cc:	8526                	mv	a0,s1
    800041ce:	9d3fc0ef          	jal	80000ba0 <acquire>
  while(i < n){
    800041d2:	09405c63          	blez	s4,8000426a <pipewrite+0xc2>
  int i = 0;
    800041d6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041d8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041da:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041de:	21c48b93          	add	s7,s1,540
    800041e2:	a81d                	j	80004218 <pipewrite+0x70>
      release(&pi->lock);
    800041e4:	8526                	mv	a0,s1
    800041e6:	a53fc0ef          	jal	80000c38 <release>
      return -1;
    800041ea:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041ec:	854a                	mv	a0,s2
    800041ee:	60e6                	ld	ra,88(sp)
    800041f0:	6446                	ld	s0,80(sp)
    800041f2:	64a6                	ld	s1,72(sp)
    800041f4:	6906                	ld	s2,64(sp)
    800041f6:	79e2                	ld	s3,56(sp)
    800041f8:	7a42                	ld	s4,48(sp)
    800041fa:	7aa2                	ld	s5,40(sp)
    800041fc:	7b02                	ld	s6,32(sp)
    800041fe:	6be2                	ld	s7,24(sp)
    80004200:	6c42                	ld	s8,16(sp)
    80004202:	6125                	add	sp,sp,96
    80004204:	8082                	ret
      wakeup(&pi->nread);
    80004206:	8562                	mv	a0,s8
    80004208:	c4dfd0ef          	jal	80001e54 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000420c:	85a6                	mv	a1,s1
    8000420e:	855e                	mv	a0,s7
    80004210:	bf9fd0ef          	jal	80001e08 <sleep>
  while(i < n){
    80004214:	05495c63          	bge	s2,s4,8000426c <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    80004218:	2204a783          	lw	a5,544(s1)
    8000421c:	d7e1                	beqz	a5,800041e4 <pipewrite+0x3c>
    8000421e:	854e                	mv	a0,s3
    80004220:	e21fd0ef          	jal	80002040 <killed>
    80004224:	f161                	bnez	a0,800041e4 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    80004226:	2184a783          	lw	a5,536(s1)
    8000422a:	21c4a703          	lw	a4,540(s1)
    8000422e:	2007879b          	addw	a5,a5,512
    80004232:	fcf70ae3          	beq	a4,a5,80004206 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004236:	4685                	li	a3,1
    80004238:	01590633          	add	a2,s2,s5
    8000423c:	faf40593          	add	a1,s0,-81
    80004240:	0589b503          	ld	a0,88(s3)
    80004244:	b5cfd0ef          	jal	800015a0 <copyin>
    80004248:	03650263          	beq	a0,s6,8000426c <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000424c:	21c4a783          	lw	a5,540(s1)
    80004250:	0017871b          	addw	a4,a5,1
    80004254:	20e4ae23          	sw	a4,540(s1)
    80004258:	1ff7f793          	and	a5,a5,511
    8000425c:	97a6                	add	a5,a5,s1
    8000425e:	faf44703          	lbu	a4,-81(s0)
    80004262:	00e78c23          	sb	a4,24(a5)
      i++;
    80004266:	2905                	addw	s2,s2,1
    80004268:	b775                	j	80004214 <pipewrite+0x6c>
  int i = 0;
    8000426a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000426c:	21848513          	add	a0,s1,536
    80004270:	be5fd0ef          	jal	80001e54 <wakeup>
  release(&pi->lock);
    80004274:	8526                	mv	a0,s1
    80004276:	9c3fc0ef          	jal	80000c38 <release>
  return i;
    8000427a:	bf8d                	j	800041ec <pipewrite+0x44>

000000008000427c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000427c:	715d                	add	sp,sp,-80
    8000427e:	e486                	sd	ra,72(sp)
    80004280:	e0a2                	sd	s0,64(sp)
    80004282:	fc26                	sd	s1,56(sp)
    80004284:	f84a                	sd	s2,48(sp)
    80004286:	f44e                	sd	s3,40(sp)
    80004288:	f052                	sd	s4,32(sp)
    8000428a:	ec56                	sd	s5,24(sp)
    8000428c:	e85a                	sd	s6,16(sp)
    8000428e:	0880                	add	s0,sp,80
    80004290:	84aa                	mv	s1,a0
    80004292:	892e                	mv	s2,a1
    80004294:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004296:	d9afd0ef          	jal	80001830 <myproc>
    8000429a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000429c:	8526                	mv	a0,s1
    8000429e:	903fc0ef          	jal	80000ba0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    800042a2:	2184a703          	lw	a4,536(s1)
    800042a6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    800042aa:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    800042ae:	02f71363          	bne	a4,a5,800042d4 <piperead+0x58>
    800042b2:	2244a783          	lw	a5,548(s1)
    800042b6:	cf99                	beqz	a5,800042d4 <piperead+0x58>
    if(killed(pr)){
    800042b8:	8552                	mv	a0,s4
    800042ba:	d87fd0ef          	jal	80002040 <killed>
    800042be:	e149                	bnez	a0,80004340 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    800042c0:	85a6                	mv	a1,s1
    800042c2:	854e                	mv	a0,s3
    800042c4:	b45fd0ef          	jal	80001e08 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    800042c8:	2184a703          	lw	a4,536(s1)
    800042cc:	21c4a783          	lw	a5,540(s1)
    800042d0:	fef701e3          	beq	a4,a5,800042b2 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    800042d4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042d6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    800042d8:	05505263          	blez	s5,8000431c <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    800042dc:	2184a783          	lw	a5,536(s1)
    800042e0:	21c4a703          	lw	a4,540(s1)
    800042e4:	02f70c63          	beq	a4,a5,8000431c <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042e8:	0017871b          	addw	a4,a5,1
    800042ec:	20e4ac23          	sw	a4,536(s1)
    800042f0:	1ff7f793          	and	a5,a5,511
    800042f4:	97a6                	add	a5,a5,s1
    800042f6:	0187c783          	lbu	a5,24(a5)
    800042fa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042fe:	4685                	li	a3,1
    80004300:	fbf40613          	add	a2,s0,-65
    80004304:	85ca                	mv	a1,s2
    80004306:	058a3503          	ld	a0,88(s4)
    8000430a:	9defd0ef          	jal	800014e8 <copyout>
    8000430e:	01650763          	beq	a0,s6,8000431c <piperead+0xa0>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004312:	2985                	addw	s3,s3,1
    80004314:	0905                	add	s2,s2,1
    80004316:	fd3a93e3          	bne	s5,s3,800042dc <piperead+0x60>
    8000431a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    8000431c:	21c48513          	add	a0,s1,540
    80004320:	b35fd0ef          	jal	80001e54 <wakeup>
  release(&pi->lock);
    80004324:	8526                	mv	a0,s1
    80004326:	913fc0ef          	jal	80000c38 <release>
  return i;
}
    8000432a:	854e                	mv	a0,s3
    8000432c:	60a6                	ld	ra,72(sp)
    8000432e:	6406                	ld	s0,64(sp)
    80004330:	74e2                	ld	s1,56(sp)
    80004332:	7942                	ld	s2,48(sp)
    80004334:	79a2                	ld	s3,40(sp)
    80004336:	7a02                	ld	s4,32(sp)
    80004338:	6ae2                	ld	s5,24(sp)
    8000433a:	6b42                	ld	s6,16(sp)
    8000433c:	6161                	add	sp,sp,80
    8000433e:	8082                	ret
      release(&pi->lock);
    80004340:	8526                	mv	a0,s1
    80004342:	8f7fc0ef          	jal	80000c38 <release>
      return -1;
    80004346:	59fd                	li	s3,-1
    80004348:	b7cd                	j	8000432a <piperead+0xae>

000000008000434a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000434a:	1141                	add	sp,sp,-16
    8000434c:	e422                	sd	s0,8(sp)
    8000434e:	0800                	add	s0,sp,16
    80004350:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004352:	8905                	and	a0,a0,1
    80004354:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004356:	8b89                	and	a5,a5,2
    80004358:	c399                	beqz	a5,8000435e <flags2perm+0x14>
      perm |= PTE_W;
    8000435a:	00456513          	or	a0,a0,4
    return perm;
}
    8000435e:	6422                	ld	s0,8(sp)
    80004360:	0141                	add	sp,sp,16
    80004362:	8082                	ret

0000000080004364 <exec>:

int
exec(char *path, char **argv)
{
    80004364:	df010113          	add	sp,sp,-528
    80004368:	20113423          	sd	ra,520(sp)
    8000436c:	20813023          	sd	s0,512(sp)
    80004370:	ffa6                	sd	s1,504(sp)
    80004372:	fbca                	sd	s2,496(sp)
    80004374:	f7ce                	sd	s3,488(sp)
    80004376:	f3d2                	sd	s4,480(sp)
    80004378:	efd6                	sd	s5,472(sp)
    8000437a:	ebda                	sd	s6,464(sp)
    8000437c:	e7de                	sd	s7,456(sp)
    8000437e:	e3e2                	sd	s8,448(sp)
    80004380:	ff66                	sd	s9,440(sp)
    80004382:	fb6a                	sd	s10,432(sp)
    80004384:	f76e                	sd	s11,424(sp)
    80004386:	0c00                	add	s0,sp,528
    80004388:	892a                	mv	s2,a0
    8000438a:	dea43c23          	sd	a0,-520(s0)
    8000438e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004392:	c9efd0ef          	jal	80001830 <myproc>
    80004396:	84aa                	mv	s1,a0

  begin_op();
    80004398:	e1aff0ef          	jal	800039b2 <begin_op>

  if((ip = namei(path)) == 0){
    8000439c:	854a                	mv	a0,s2
    8000439e:	c58ff0ef          	jal	800037f6 <namei>
    800043a2:	c12d                	beqz	a0,80004404 <exec+0xa0>
    800043a4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043a6:	d9ffe0ef          	jal	80003144 <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043aa:	04000713          	li	a4,64
    800043ae:	4681                	li	a3,0
    800043b0:	e5040613          	add	a2,s0,-432
    800043b4:	4581                	li	a1,0
    800043b6:	8552                	mv	a0,s4
    800043b8:	fddfe0ef          	jal	80003394 <readi>
    800043bc:	04000793          	li	a5,64
    800043c0:	00f51a63          	bne	a0,a5,800043d4 <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800043c4:	e5042703          	lw	a4,-432(s0)
    800043c8:	464c47b7          	lui	a5,0x464c4
    800043cc:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043d0:	02f70e63          	beq	a4,a5,8000440c <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043d4:	8552                	mv	a0,s4
    800043d6:	f75fe0ef          	jal	8000334a <iunlockput>
    end_op();
    800043da:	e42ff0ef          	jal	80003a1c <end_op>
  }
  return -1;
    800043de:	557d                	li	a0,-1
}
    800043e0:	20813083          	ld	ra,520(sp)
    800043e4:	20013403          	ld	s0,512(sp)
    800043e8:	74fe                	ld	s1,504(sp)
    800043ea:	795e                	ld	s2,496(sp)
    800043ec:	79be                	ld	s3,488(sp)
    800043ee:	7a1e                	ld	s4,480(sp)
    800043f0:	6afe                	ld	s5,472(sp)
    800043f2:	6b5e                	ld	s6,464(sp)
    800043f4:	6bbe                	ld	s7,456(sp)
    800043f6:	6c1e                	ld	s8,448(sp)
    800043f8:	7cfa                	ld	s9,440(sp)
    800043fa:	7d5a                	ld	s10,432(sp)
    800043fc:	7dba                	ld	s11,424(sp)
    800043fe:	21010113          	add	sp,sp,528
    80004402:	8082                	ret
    end_op();
    80004404:	e18ff0ef          	jal	80003a1c <end_op>
    return -1;
    80004408:	557d                	li	a0,-1
    8000440a:	bfd9                	j	800043e0 <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000440c:	8526                	mv	a0,s1
    8000440e:	ccafd0ef          	jal	800018d8 <proc_pagetable>
    80004412:	8b2a                	mv	s6,a0
    80004414:	d161                	beqz	a0,800043d4 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004416:	e7042d03          	lw	s10,-400(s0)
    8000441a:	e8845783          	lhu	a5,-376(s0)
    8000441e:	0e078863          	beqz	a5,8000450e <exec+0x1aa>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004422:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004424:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004426:	6c85                	lui	s9,0x1
    80004428:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000442c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004430:	6a85                	lui	s5,0x1
    80004432:	a085                	j	80004492 <exec+0x12e>
      panic("loadseg: address should exist");
    80004434:	00003517          	auipc	a0,0x3
    80004438:	45450513          	add	a0,a0,1108 # 80007888 <syscalls_names+0x280>
    8000443c:	b22fc0ef          	jal	8000075e <panic>
    if(sz - i < PGSIZE)
    80004440:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004442:	8726                	mv	a4,s1
    80004444:	012c06bb          	addw	a3,s8,s2
    80004448:	4581                	li	a1,0
    8000444a:	8552                	mv	a0,s4
    8000444c:	f49fe0ef          	jal	80003394 <readi>
    80004450:	2501                	sext.w	a0,a0
    80004452:	20a49a63          	bne	s1,a0,80004666 <exec+0x302>
  for(i = 0; i < sz; i += PGSIZE){
    80004456:	012a893b          	addw	s2,s5,s2
    8000445a:	03397363          	bgeu	s2,s3,80004480 <exec+0x11c>
    pa = walkaddr(pagetable, va + i);
    8000445e:	02091593          	sll	a1,s2,0x20
    80004462:	9181                	srl	a1,a1,0x20
    80004464:	95de                	add	a1,a1,s7
    80004466:	855a                	mv	a0,s6
    80004468:	b21fc0ef          	jal	80000f88 <walkaddr>
    8000446c:	862a                	mv	a2,a0
    if(pa == 0)
    8000446e:	d179                	beqz	a0,80004434 <exec+0xd0>
    if(sz - i < PGSIZE)
    80004470:	412984bb          	subw	s1,s3,s2
    80004474:	0004879b          	sext.w	a5,s1
    80004478:	fcfcf4e3          	bgeu	s9,a5,80004440 <exec+0xdc>
    8000447c:	84d6                	mv	s1,s5
    8000447e:	b7c9                	j	80004440 <exec+0xdc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004480:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004484:	2d85                	addw	s11,s11,1
    80004486:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000448a:	e8845783          	lhu	a5,-376(s0)
    8000448e:	08fdd163          	bge	s11,a5,80004510 <exec+0x1ac>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004492:	2d01                	sext.w	s10,s10
    80004494:	03800713          	li	a4,56
    80004498:	86ea                	mv	a3,s10
    8000449a:	e1840613          	add	a2,s0,-488
    8000449e:	4581                	li	a1,0
    800044a0:	8552                	mv	a0,s4
    800044a2:	ef3fe0ef          	jal	80003394 <readi>
    800044a6:	03800793          	li	a5,56
    800044aa:	1af51c63          	bne	a0,a5,80004662 <exec+0x2fe>
    if(ph.type != ELF_PROG_LOAD)
    800044ae:	e1842783          	lw	a5,-488(s0)
    800044b2:	4705                	li	a4,1
    800044b4:	fce798e3          	bne	a5,a4,80004484 <exec+0x120>
    if(ph.memsz < ph.filesz)
    800044b8:	e4043483          	ld	s1,-448(s0)
    800044bc:	e3843783          	ld	a5,-456(s0)
    800044c0:	1af4ec63          	bltu	s1,a5,80004678 <exec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044c4:	e2843783          	ld	a5,-472(s0)
    800044c8:	94be                	add	s1,s1,a5
    800044ca:	1af4ea63          	bltu	s1,a5,8000467e <exec+0x31a>
    if(ph.vaddr % PGSIZE != 0)
    800044ce:	df043703          	ld	a4,-528(s0)
    800044d2:	8ff9                	and	a5,a5,a4
    800044d4:	1a079863          	bnez	a5,80004684 <exec+0x320>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044d8:	e1c42503          	lw	a0,-484(s0)
    800044dc:	e6fff0ef          	jal	8000434a <flags2perm>
    800044e0:	86aa                	mv	a3,a0
    800044e2:	8626                	mv	a2,s1
    800044e4:	85ca                	mv	a1,s2
    800044e6:	855a                	mv	a0,s6
    800044e8:	df9fc0ef          	jal	800012e0 <uvmalloc>
    800044ec:	e0a43423          	sd	a0,-504(s0)
    800044f0:	18050d63          	beqz	a0,8000468a <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044f4:	e2843b83          	ld	s7,-472(s0)
    800044f8:	e2042c03          	lw	s8,-480(s0)
    800044fc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004500:	00098463          	beqz	s3,80004508 <exec+0x1a4>
    80004504:	4901                	li	s2,0
    80004506:	bfa1                	j	8000445e <exec+0xfa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004508:	e0843903          	ld	s2,-504(s0)
    8000450c:	bfa5                	j	80004484 <exec+0x120>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000450e:	4901                	li	s2,0
  iunlockput(ip);
    80004510:	8552                	mv	a0,s4
    80004512:	e39fe0ef          	jal	8000334a <iunlockput>
  end_op();
    80004516:	d06ff0ef          	jal	80003a1c <end_op>
  p = myproc();
    8000451a:	b16fd0ef          	jal	80001830 <myproc>
    8000451e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004520:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004524:	6985                	lui	s3,0x1
    80004526:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004528:	99ca                	add	s3,s3,s2
    8000452a:	77fd                	lui	a5,0xfffff
    8000452c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004530:	4691                	li	a3,4
    80004532:	6609                	lui	a2,0x2
    80004534:	964e                	add	a2,a2,s3
    80004536:	85ce                	mv	a1,s3
    80004538:	855a                	mv	a0,s6
    8000453a:	da7fc0ef          	jal	800012e0 <uvmalloc>
    8000453e:	892a                	mv	s2,a0
    80004540:	e0a43423          	sd	a0,-504(s0)
    80004544:	e509                	bnez	a0,8000454e <exec+0x1ea>
  if(pagetable)
    80004546:	e1343423          	sd	s3,-504(s0)
    8000454a:	4a01                	li	s4,0
    8000454c:	aa29                	j	80004666 <exec+0x302>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000454e:	75f9                	lui	a1,0xffffe
    80004550:	95aa                	add	a1,a1,a0
    80004552:	855a                	mv	a0,s6
    80004554:	f6bfc0ef          	jal	800014be <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004558:	7bfd                	lui	s7,0xfffff
    8000455a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000455c:	e0043783          	ld	a5,-512(s0)
    80004560:	6388                	ld	a0,0(a5)
    80004562:	cd39                	beqz	a0,800045c0 <exec+0x25c>
    80004564:	e9040993          	add	s3,s0,-368
    80004568:	f9040c13          	add	s8,s0,-112
    8000456c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000456e:	87dfc0ef          	jal	80000dea <strlen>
    80004572:	0015079b          	addw	a5,a0,1
    80004576:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    8000457a:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    8000457e:	11796963          	bltu	s2,s7,80004690 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004582:	e0043d03          	ld	s10,-512(s0)
    80004586:	000d3a03          	ld	s4,0(s10)
    8000458a:	8552                	mv	a0,s4
    8000458c:	85ffc0ef          	jal	80000dea <strlen>
    80004590:	0015069b          	addw	a3,a0,1
    80004594:	8652                	mv	a2,s4
    80004596:	85ca                	mv	a1,s2
    80004598:	855a                	mv	a0,s6
    8000459a:	f4ffc0ef          	jal	800014e8 <copyout>
    8000459e:	0e054b63          	bltz	a0,80004694 <exec+0x330>
    ustack[argc] = sp;
    800045a2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800045a6:	0485                	add	s1,s1,1
    800045a8:	008d0793          	add	a5,s10,8
    800045ac:	e0f43023          	sd	a5,-512(s0)
    800045b0:	008d3503          	ld	a0,8(s10)
    800045b4:	c909                	beqz	a0,800045c6 <exec+0x262>
    if(argc >= MAXARG)
    800045b6:	09a1                	add	s3,s3,8
    800045b8:	fb899be3          	bne	s3,s8,8000456e <exec+0x20a>
  ip = 0;
    800045bc:	4a01                	li	s4,0
    800045be:	a065                	j	80004666 <exec+0x302>
  sp = sz;
    800045c0:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800045c4:	4481                	li	s1,0
  ustack[argc] = 0;
    800045c6:	00349793          	sll	a5,s1,0x3
    800045ca:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffddfd0>
    800045ce:	97a2                	add	a5,a5,s0
    800045d0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045d4:	00148693          	add	a3,s1,1
    800045d8:	068e                	sll	a3,a3,0x3
    800045da:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045de:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800045e2:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800045e6:	f77960e3          	bltu	s2,s7,80004546 <exec+0x1e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045ea:	e9040613          	add	a2,s0,-368
    800045ee:	85ca                	mv	a1,s2
    800045f0:	855a                	mv	a0,s6
    800045f2:	ef7fc0ef          	jal	800014e8 <copyout>
    800045f6:	0a054163          	bltz	a0,80004698 <exec+0x334>
  p->trapframe->a1 = sp;
    800045fa:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    800045fe:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004602:	df843783          	ld	a5,-520(s0)
    80004606:	0007c703          	lbu	a4,0(a5)
    8000460a:	cf11                	beqz	a4,80004626 <exec+0x2c2>
    8000460c:	0785                	add	a5,a5,1
    if(*s == '/')
    8000460e:	02f00693          	li	a3,47
    80004612:	a039                	j	80004620 <exec+0x2bc>
      last = s+1;
    80004614:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004618:	0785                	add	a5,a5,1
    8000461a:	fff7c703          	lbu	a4,-1(a5)
    8000461e:	c701                	beqz	a4,80004626 <exec+0x2c2>
    if(*s == '/')
    80004620:	fed71ce3          	bne	a4,a3,80004618 <exec+0x2b4>
    80004624:	bfc5                	j	80004614 <exec+0x2b0>
  safestrcpy(p->name, last, sizeof(p->name));
    80004626:	4641                	li	a2,16
    80004628:	df843583          	ld	a1,-520(s0)
    8000462c:	160a8513          	add	a0,s5,352
    80004630:	f88fc0ef          	jal	80000db8 <safestrcpy>
  oldpagetable = p->pagetable;
    80004634:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004638:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    8000463c:	e0843783          	ld	a5,-504(s0)
    80004640:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    80004644:	060ab783          	ld	a5,96(s5)
    80004648:	e6843703          	ld	a4,-408(s0)
    8000464c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    8000464e:	060ab783          	ld	a5,96(s5)
    80004652:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004656:	85e6                	mv	a1,s9
    80004658:	b04fd0ef          	jal	8000195c <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    8000465c:	0004851b          	sext.w	a0,s1
    80004660:	b341                	j	800043e0 <exec+0x7c>
    80004662:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004666:	e0843583          	ld	a1,-504(s0)
    8000466a:	855a                	mv	a0,s6
    8000466c:	af0fd0ef          	jal	8000195c <proc_freepagetable>
  return -1;
    80004670:	557d                	li	a0,-1
  if(ip){
    80004672:	d60a07e3          	beqz	s4,800043e0 <exec+0x7c>
    80004676:	bbb9                	j	800043d4 <exec+0x70>
    80004678:	e1243423          	sd	s2,-504(s0)
    8000467c:	b7ed                	j	80004666 <exec+0x302>
    8000467e:	e1243423          	sd	s2,-504(s0)
    80004682:	b7d5                	j	80004666 <exec+0x302>
    80004684:	e1243423          	sd	s2,-504(s0)
    80004688:	bff9                	j	80004666 <exec+0x302>
    8000468a:	e1243423          	sd	s2,-504(s0)
    8000468e:	bfe1                	j	80004666 <exec+0x302>
  ip = 0;
    80004690:	4a01                	li	s4,0
    80004692:	bfd1                	j	80004666 <exec+0x302>
    80004694:	4a01                	li	s4,0
  if(pagetable)
    80004696:	bfc1                	j	80004666 <exec+0x302>
  sz = sz1;
    80004698:	e0843983          	ld	s3,-504(s0)
    8000469c:	b56d                	j	80004546 <exec+0x1e2>

000000008000469e <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000469e:	7179                	add	sp,sp,-48
    800046a0:	f406                	sd	ra,40(sp)
    800046a2:	f022                	sd	s0,32(sp)
    800046a4:	ec26                	sd	s1,24(sp)
    800046a6:	e84a                	sd	s2,16(sp)
    800046a8:	1800                	add	s0,sp,48
    800046aa:	892e                	mv	s2,a1
    800046ac:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800046ae:	fdc40593          	add	a1,s0,-36
    800046b2:	838fe0ef          	jal	800026ea <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046b6:	fdc42703          	lw	a4,-36(s0)
    800046ba:	47bd                	li	a5,15
    800046bc:	02e7e963          	bltu	a5,a4,800046ee <argfd+0x50>
    800046c0:	970fd0ef          	jal	80001830 <myproc>
    800046c4:	fdc42703          	lw	a4,-36(s0)
    800046c8:	01a70793          	add	a5,a4,26
    800046cc:	078e                	sll	a5,a5,0x3
    800046ce:	953e                	add	a0,a0,a5
    800046d0:	651c                	ld	a5,8(a0)
    800046d2:	c385                	beqz	a5,800046f2 <argfd+0x54>
    return -1;
  if(pfd)
    800046d4:	00090463          	beqz	s2,800046dc <argfd+0x3e>
    *pfd = fd;
    800046d8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046dc:	4501                	li	a0,0
  if(pf)
    800046de:	c091                	beqz	s1,800046e2 <argfd+0x44>
    *pf = f;
    800046e0:	e09c                	sd	a5,0(s1)
}
    800046e2:	70a2                	ld	ra,40(sp)
    800046e4:	7402                	ld	s0,32(sp)
    800046e6:	64e2                	ld	s1,24(sp)
    800046e8:	6942                	ld	s2,16(sp)
    800046ea:	6145                	add	sp,sp,48
    800046ec:	8082                	ret
    return -1;
    800046ee:	557d                	li	a0,-1
    800046f0:	bfcd                	j	800046e2 <argfd+0x44>
    800046f2:	557d                	li	a0,-1
    800046f4:	b7fd                	j	800046e2 <argfd+0x44>

00000000800046f6 <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    800046f6:	1101                	add	sp,sp,-32
    800046f8:	ec06                	sd	ra,24(sp)
    800046fa:	e822                	sd	s0,16(sp)
    800046fc:	e426                	sd	s1,8(sp)
    800046fe:	1000                	add	s0,sp,32
    80004700:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004702:	92efd0ef          	jal	80001830 <myproc>
    80004706:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004708:	0d850793          	add	a5,a0,216
    8000470c:	4501                	li	a0,0
    8000470e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004710:	6398                	ld	a4,0(a5)
    80004712:	cb19                	beqz	a4,80004728 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004714:	2505                	addw	a0,a0,1
    80004716:	07a1                	add	a5,a5,8
    80004718:	fed51ce3          	bne	a0,a3,80004710 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000471c:	557d                	li	a0,-1
}
    8000471e:	60e2                	ld	ra,24(sp)
    80004720:	6442                	ld	s0,16(sp)
    80004722:	64a2                	ld	s1,8(sp)
    80004724:	6105                	add	sp,sp,32
    80004726:	8082                	ret
      p->ofile[fd] = f;
    80004728:	01a50793          	add	a5,a0,26
    8000472c:	078e                	sll	a5,a5,0x3
    8000472e:	963e                	add	a2,a2,a5
    80004730:	e604                	sd	s1,8(a2)
      return fd;
    80004732:	b7f5                	j	8000471e <fdalloc+0x28>

0000000080004734 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004734:	715d                	add	sp,sp,-80
    80004736:	e486                	sd	ra,72(sp)
    80004738:	e0a2                	sd	s0,64(sp)
    8000473a:	fc26                	sd	s1,56(sp)
    8000473c:	f84a                	sd	s2,48(sp)
    8000473e:	f44e                	sd	s3,40(sp)
    80004740:	f052                	sd	s4,32(sp)
    80004742:	ec56                	sd	s5,24(sp)
    80004744:	e85a                	sd	s6,16(sp)
    80004746:	0880                	add	s0,sp,80
    80004748:	8b2e                	mv	s6,a1
    8000474a:	89b2                	mv	s3,a2
    8000474c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000474e:	fb040593          	add	a1,s0,-80
    80004752:	8beff0ef          	jal	80003810 <nameiparent>
    80004756:	84aa                	mv	s1,a0
    80004758:	10050763          	beqz	a0,80004866 <create+0x132>
    return 0;

  ilock(dp);
    8000475c:	9e9fe0ef          	jal	80003144 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004760:	4601                	li	a2,0
    80004762:	fb040593          	add	a1,s0,-80
    80004766:	8526                	mv	a0,s1
    80004768:	e29fe0ef          	jal	80003590 <dirlookup>
    8000476c:	8aaa                	mv	s5,a0
    8000476e:	c131                	beqz	a0,800047b2 <create+0x7e>
    iunlockput(dp);
    80004770:	8526                	mv	a0,s1
    80004772:	bd9fe0ef          	jal	8000334a <iunlockput>
    ilock(ip);
    80004776:	8556                	mv	a0,s5
    80004778:	9cdfe0ef          	jal	80003144 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000477c:	4789                	li	a5,2
    8000477e:	02fb1563          	bne	s6,a5,800047a8 <create+0x74>
    80004782:	044ad783          	lhu	a5,68(s5)
    80004786:	37f9                	addw	a5,a5,-2
    80004788:	17c2                	sll	a5,a5,0x30
    8000478a:	93c1                	srl	a5,a5,0x30
    8000478c:	4705                	li	a4,1
    8000478e:	00f76d63          	bltu	a4,a5,800047a8 <create+0x74>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004792:	8556                	mv	a0,s5
    80004794:	60a6                	ld	ra,72(sp)
    80004796:	6406                	ld	s0,64(sp)
    80004798:	74e2                	ld	s1,56(sp)
    8000479a:	7942                	ld	s2,48(sp)
    8000479c:	79a2                	ld	s3,40(sp)
    8000479e:	7a02                	ld	s4,32(sp)
    800047a0:	6ae2                	ld	s5,24(sp)
    800047a2:	6b42                	ld	s6,16(sp)
    800047a4:	6161                	add	sp,sp,80
    800047a6:	8082                	ret
    iunlockput(ip);
    800047a8:	8556                	mv	a0,s5
    800047aa:	ba1fe0ef          	jal	8000334a <iunlockput>
    return 0;
    800047ae:	4a81                	li	s5,0
    800047b0:	b7cd                	j	80004792 <create+0x5e>
  if((ip = ialloc(dp->dev, type)) == 0){
    800047b2:	85da                	mv	a1,s6
    800047b4:	4088                	lw	a0,0(s1)
    800047b6:	82bfe0ef          	jal	80002fe0 <ialloc>
    800047ba:	8a2a                	mv	s4,a0
    800047bc:	cd0d                	beqz	a0,800047f6 <create+0xc2>
  ilock(ip);
    800047be:	987fe0ef          	jal	80003144 <ilock>
  ip->major = major;
    800047c2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047c6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047ca:	4905                	li	s2,1
    800047cc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800047d0:	8552                	mv	a0,s4
    800047d2:	8bffe0ef          	jal	80003090 <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    800047d6:	032b0563          	beq	s6,s2,80004800 <create+0xcc>
  if(dirlink(dp, name, ip->inum) < 0)
    800047da:	004a2603          	lw	a2,4(s4)
    800047de:	fb040593          	add	a1,s0,-80
    800047e2:	8526                	mv	a0,s1
    800047e4:	f79fe0ef          	jal	8000375c <dirlink>
    800047e8:	06054363          	bltz	a0,8000484e <create+0x11a>
  iunlockput(dp);
    800047ec:	8526                	mv	a0,s1
    800047ee:	b5dfe0ef          	jal	8000334a <iunlockput>
  return ip;
    800047f2:	8ad2                	mv	s5,s4
    800047f4:	bf79                	j	80004792 <create+0x5e>
    iunlockput(dp);
    800047f6:	8526                	mv	a0,s1
    800047f8:	b53fe0ef          	jal	8000334a <iunlockput>
    return 0;
    800047fc:	8ad2                	mv	s5,s4
    800047fe:	bf51                	j	80004792 <create+0x5e>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004800:	004a2603          	lw	a2,4(s4)
    80004804:	00003597          	auipc	a1,0x3
    80004808:	0a458593          	add	a1,a1,164 # 800078a8 <syscalls_names+0x2a0>
    8000480c:	8552                	mv	a0,s4
    8000480e:	f4ffe0ef          	jal	8000375c <dirlink>
    80004812:	02054e63          	bltz	a0,8000484e <create+0x11a>
    80004816:	40d0                	lw	a2,4(s1)
    80004818:	00003597          	auipc	a1,0x3
    8000481c:	09858593          	add	a1,a1,152 # 800078b0 <syscalls_names+0x2a8>
    80004820:	8552                	mv	a0,s4
    80004822:	f3bfe0ef          	jal	8000375c <dirlink>
    80004826:	02054463          	bltz	a0,8000484e <create+0x11a>
  if(dirlink(dp, name, ip->inum) < 0)
    8000482a:	004a2603          	lw	a2,4(s4)
    8000482e:	fb040593          	add	a1,s0,-80
    80004832:	8526                	mv	a0,s1
    80004834:	f29fe0ef          	jal	8000375c <dirlink>
    80004838:	00054b63          	bltz	a0,8000484e <create+0x11a>
    dp->nlink++;  /* for ".." */
    8000483c:	04a4d783          	lhu	a5,74(s1)
    80004840:	2785                	addw	a5,a5,1
    80004842:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004846:	8526                	mv	a0,s1
    80004848:	849fe0ef          	jal	80003090 <iupdate>
    8000484c:	b745                	j	800047ec <create+0xb8>
  ip->nlink = 0;
    8000484e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004852:	8552                	mv	a0,s4
    80004854:	83dfe0ef          	jal	80003090 <iupdate>
  iunlockput(ip);
    80004858:	8552                	mv	a0,s4
    8000485a:	af1fe0ef          	jal	8000334a <iunlockput>
  iunlockput(dp);
    8000485e:	8526                	mv	a0,s1
    80004860:	aebfe0ef          	jal	8000334a <iunlockput>
  return 0;
    80004864:	b73d                	j	80004792 <create+0x5e>
    return 0;
    80004866:	8aaa                	mv	s5,a0
    80004868:	b72d                	j	80004792 <create+0x5e>

000000008000486a <sys_dup>:
{
    8000486a:	7179                	add	sp,sp,-48
    8000486c:	f406                	sd	ra,40(sp)
    8000486e:	f022                	sd	s0,32(sp)
    80004870:	ec26                	sd	s1,24(sp)
    80004872:	e84a                	sd	s2,16(sp)
    80004874:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004876:	fd840613          	add	a2,s0,-40
    8000487a:	4581                	li	a1,0
    8000487c:	4501                	li	a0,0
    8000487e:	e21ff0ef          	jal	8000469e <argfd>
    return -1;
    80004882:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004884:	00054f63          	bltz	a0,800048a2 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80004888:	fd843903          	ld	s2,-40(s0)
    8000488c:	854a                	mv	a0,s2
    8000488e:	e69ff0ef          	jal	800046f6 <fdalloc>
    80004892:	84aa                	mv	s1,a0
    return -1;
    80004894:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004896:	00054663          	bltz	a0,800048a2 <sys_dup+0x38>
  filedup(f);
    8000489a:	854a                	mv	a0,s2
    8000489c:	ce4ff0ef          	jal	80003d80 <filedup>
  return fd;
    800048a0:	87a6                	mv	a5,s1
}
    800048a2:	853e                	mv	a0,a5
    800048a4:	70a2                	ld	ra,40(sp)
    800048a6:	7402                	ld	s0,32(sp)
    800048a8:	64e2                	ld	s1,24(sp)
    800048aa:	6942                	ld	s2,16(sp)
    800048ac:	6145                	add	sp,sp,48
    800048ae:	8082                	ret

00000000800048b0 <sys_read>:
{
    800048b0:	7179                	add	sp,sp,-48
    800048b2:	f406                	sd	ra,40(sp)
    800048b4:	f022                	sd	s0,32(sp)
    800048b6:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800048b8:	fd840593          	add	a1,s0,-40
    800048bc:	4505                	li	a0,1
    800048be:	e49fd0ef          	jal	80002706 <argaddr>
  argint(2, &n);
    800048c2:	fe440593          	add	a1,s0,-28
    800048c6:	4509                	li	a0,2
    800048c8:	e23fd0ef          	jal	800026ea <argint>
  if(argfd(0, 0, &f) < 0)
    800048cc:	fe840613          	add	a2,s0,-24
    800048d0:	4581                	li	a1,0
    800048d2:	4501                	li	a0,0
    800048d4:	dcbff0ef          	jal	8000469e <argfd>
    800048d8:	87aa                	mv	a5,a0
    return -1;
    800048da:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048dc:	0007ca63          	bltz	a5,800048f0 <sys_read+0x40>
  return fileread(f, p, n);
    800048e0:	fe442603          	lw	a2,-28(s0)
    800048e4:	fd843583          	ld	a1,-40(s0)
    800048e8:	fe843503          	ld	a0,-24(s0)
    800048ec:	de0ff0ef          	jal	80003ecc <fileread>
}
    800048f0:	70a2                	ld	ra,40(sp)
    800048f2:	7402                	ld	s0,32(sp)
    800048f4:	6145                	add	sp,sp,48
    800048f6:	8082                	ret

00000000800048f8 <sys_write>:
{
    800048f8:	7179                	add	sp,sp,-48
    800048fa:	f406                	sd	ra,40(sp)
    800048fc:	f022                	sd	s0,32(sp)
    800048fe:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004900:	fd840593          	add	a1,s0,-40
    80004904:	4505                	li	a0,1
    80004906:	e01fd0ef          	jal	80002706 <argaddr>
  argint(2, &n);
    8000490a:	fe440593          	add	a1,s0,-28
    8000490e:	4509                	li	a0,2
    80004910:	ddbfd0ef          	jal	800026ea <argint>
  if(argfd(0, 0, &f) < 0)
    80004914:	fe840613          	add	a2,s0,-24
    80004918:	4581                	li	a1,0
    8000491a:	4501                	li	a0,0
    8000491c:	d83ff0ef          	jal	8000469e <argfd>
    80004920:	87aa                	mv	a5,a0
    return -1;
    80004922:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004924:	0007ca63          	bltz	a5,80004938 <sys_write+0x40>
  return filewrite(f, p, n);
    80004928:	fe442603          	lw	a2,-28(s0)
    8000492c:	fd843583          	ld	a1,-40(s0)
    80004930:	fe843503          	ld	a0,-24(s0)
    80004934:	e46ff0ef          	jal	80003f7a <filewrite>
}
    80004938:	70a2                	ld	ra,40(sp)
    8000493a:	7402                	ld	s0,32(sp)
    8000493c:	6145                	add	sp,sp,48
    8000493e:	8082                	ret

0000000080004940 <sys_close>:
{
    80004940:	1101                	add	sp,sp,-32
    80004942:	ec06                	sd	ra,24(sp)
    80004944:	e822                	sd	s0,16(sp)
    80004946:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004948:	fe040613          	add	a2,s0,-32
    8000494c:	fec40593          	add	a1,s0,-20
    80004950:	4501                	li	a0,0
    80004952:	d4dff0ef          	jal	8000469e <argfd>
    return -1;
    80004956:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004958:	02054063          	bltz	a0,80004978 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000495c:	ed5fc0ef          	jal	80001830 <myproc>
    80004960:	fec42783          	lw	a5,-20(s0)
    80004964:	07e9                	add	a5,a5,26
    80004966:	078e                	sll	a5,a5,0x3
    80004968:	953e                	add	a0,a0,a5
    8000496a:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000496e:	fe043503          	ld	a0,-32(s0)
    80004972:	c54ff0ef          	jal	80003dc6 <fileclose>
  return 0;
    80004976:	4781                	li	a5,0
}
    80004978:	853e                	mv	a0,a5
    8000497a:	60e2                	ld	ra,24(sp)
    8000497c:	6442                	ld	s0,16(sp)
    8000497e:	6105                	add	sp,sp,32
    80004980:	8082                	ret

0000000080004982 <sys_fstat>:
{
    80004982:	1101                	add	sp,sp,-32
    80004984:	ec06                	sd	ra,24(sp)
    80004986:	e822                	sd	s0,16(sp)
    80004988:	1000                	add	s0,sp,32
  argaddr(1, &st);
    8000498a:	fe040593          	add	a1,s0,-32
    8000498e:	4505                	li	a0,1
    80004990:	d77fd0ef          	jal	80002706 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004994:	fe840613          	add	a2,s0,-24
    80004998:	4581                	li	a1,0
    8000499a:	4501                	li	a0,0
    8000499c:	d03ff0ef          	jal	8000469e <argfd>
    800049a0:	87aa                	mv	a5,a0
    return -1;
    800049a2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049a4:	0007c863          	bltz	a5,800049b4 <sys_fstat+0x32>
  return filestat(f, st);
    800049a8:	fe043583          	ld	a1,-32(s0)
    800049ac:	fe843503          	ld	a0,-24(s0)
    800049b0:	cbeff0ef          	jal	80003e6e <filestat>
}
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	6105                	add	sp,sp,32
    800049ba:	8082                	ret

00000000800049bc <sys_link>:
{
    800049bc:	7169                	add	sp,sp,-304
    800049be:	f606                	sd	ra,296(sp)
    800049c0:	f222                	sd	s0,288(sp)
    800049c2:	ee26                	sd	s1,280(sp)
    800049c4:	ea4a                	sd	s2,272(sp)
    800049c6:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c8:	08000613          	li	a2,128
    800049cc:	ed040593          	add	a1,s0,-304
    800049d0:	4501                	li	a0,0
    800049d2:	d51fd0ef          	jal	80002722 <argstr>
    return -1;
    800049d6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d8:	0c054663          	bltz	a0,80004aa4 <sys_link+0xe8>
    800049dc:	08000613          	li	a2,128
    800049e0:	f5040593          	add	a1,s0,-176
    800049e4:	4505                	li	a0,1
    800049e6:	d3dfd0ef          	jal	80002722 <argstr>
    return -1;
    800049ea:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ec:	0a054c63          	bltz	a0,80004aa4 <sys_link+0xe8>
  begin_op();
    800049f0:	fc3fe0ef          	jal	800039b2 <begin_op>
  if((ip = namei(old)) == 0){
    800049f4:	ed040513          	add	a0,s0,-304
    800049f8:	dfffe0ef          	jal	800037f6 <namei>
    800049fc:	84aa                	mv	s1,a0
    800049fe:	c525                	beqz	a0,80004a66 <sys_link+0xaa>
  ilock(ip);
    80004a00:	f44fe0ef          	jal	80003144 <ilock>
  if(ip->type == T_DIR){
    80004a04:	04449703          	lh	a4,68(s1)
    80004a08:	4785                	li	a5,1
    80004a0a:	06f70263          	beq	a4,a5,80004a6e <sys_link+0xb2>
  ip->nlink++;
    80004a0e:	04a4d783          	lhu	a5,74(s1)
    80004a12:	2785                	addw	a5,a5,1
    80004a14:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	e76fe0ef          	jal	80003090 <iupdate>
  iunlock(ip);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	fcefe0ef          	jal	800031ee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a24:	fd040593          	add	a1,s0,-48
    80004a28:	f5040513          	add	a0,s0,-176
    80004a2c:	de5fe0ef          	jal	80003810 <nameiparent>
    80004a30:	892a                	mv	s2,a0
    80004a32:	c921                	beqz	a0,80004a82 <sys_link+0xc6>
  ilock(dp);
    80004a34:	f10fe0ef          	jal	80003144 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a38:	00092703          	lw	a4,0(s2)
    80004a3c:	409c                	lw	a5,0(s1)
    80004a3e:	02f71f63          	bne	a4,a5,80004a7c <sys_link+0xc0>
    80004a42:	40d0                	lw	a2,4(s1)
    80004a44:	fd040593          	add	a1,s0,-48
    80004a48:	854a                	mv	a0,s2
    80004a4a:	d13fe0ef          	jal	8000375c <dirlink>
    80004a4e:	02054763          	bltz	a0,80004a7c <sys_link+0xc0>
  iunlockput(dp);
    80004a52:	854a                	mv	a0,s2
    80004a54:	8f7fe0ef          	jal	8000334a <iunlockput>
  iput(ip);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	869fe0ef          	jal	800032c2 <iput>
  end_op();
    80004a5e:	fbffe0ef          	jal	80003a1c <end_op>
  return 0;
    80004a62:	4781                	li	a5,0
    80004a64:	a081                	j	80004aa4 <sys_link+0xe8>
    end_op();
    80004a66:	fb7fe0ef          	jal	80003a1c <end_op>
    return -1;
    80004a6a:	57fd                	li	a5,-1
    80004a6c:	a825                	j	80004aa4 <sys_link+0xe8>
    iunlockput(ip);
    80004a6e:	8526                	mv	a0,s1
    80004a70:	8dbfe0ef          	jal	8000334a <iunlockput>
    end_op();
    80004a74:	fa9fe0ef          	jal	80003a1c <end_op>
    return -1;
    80004a78:	57fd                	li	a5,-1
    80004a7a:	a02d                	j	80004aa4 <sys_link+0xe8>
    iunlockput(dp);
    80004a7c:	854a                	mv	a0,s2
    80004a7e:	8cdfe0ef          	jal	8000334a <iunlockput>
  ilock(ip);
    80004a82:	8526                	mv	a0,s1
    80004a84:	ec0fe0ef          	jal	80003144 <ilock>
  ip->nlink--;
    80004a88:	04a4d783          	lhu	a5,74(s1)
    80004a8c:	37fd                	addw	a5,a5,-1
    80004a8e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a92:	8526                	mv	a0,s1
    80004a94:	dfcfe0ef          	jal	80003090 <iupdate>
  iunlockput(ip);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	8b1fe0ef          	jal	8000334a <iunlockput>
  end_op();
    80004a9e:	f7ffe0ef          	jal	80003a1c <end_op>
  return -1;
    80004aa2:	57fd                	li	a5,-1
}
    80004aa4:	853e                	mv	a0,a5
    80004aa6:	70b2                	ld	ra,296(sp)
    80004aa8:	7412                	ld	s0,288(sp)
    80004aaa:	64f2                	ld	s1,280(sp)
    80004aac:	6952                	ld	s2,272(sp)
    80004aae:	6155                	add	sp,sp,304
    80004ab0:	8082                	ret

0000000080004ab2 <sys_unlink>:
{
    80004ab2:	7151                	add	sp,sp,-240
    80004ab4:	f586                	sd	ra,232(sp)
    80004ab6:	f1a2                	sd	s0,224(sp)
    80004ab8:	eda6                	sd	s1,216(sp)
    80004aba:	e9ca                	sd	s2,208(sp)
    80004abc:	e5ce                	sd	s3,200(sp)
    80004abe:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ac0:	08000613          	li	a2,128
    80004ac4:	f3040593          	add	a1,s0,-208
    80004ac8:	4501                	li	a0,0
    80004aca:	c59fd0ef          	jal	80002722 <argstr>
    80004ace:	12054b63          	bltz	a0,80004c04 <sys_unlink+0x152>
  begin_op();
    80004ad2:	ee1fe0ef          	jal	800039b2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ad6:	fb040593          	add	a1,s0,-80
    80004ada:	f3040513          	add	a0,s0,-208
    80004ade:	d33fe0ef          	jal	80003810 <nameiparent>
    80004ae2:	84aa                	mv	s1,a0
    80004ae4:	c54d                	beqz	a0,80004b8e <sys_unlink+0xdc>
  ilock(dp);
    80004ae6:	e5efe0ef          	jal	80003144 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004aea:	00003597          	auipc	a1,0x3
    80004aee:	dbe58593          	add	a1,a1,-578 # 800078a8 <syscalls_names+0x2a0>
    80004af2:	fb040513          	add	a0,s0,-80
    80004af6:	a85fe0ef          	jal	8000357a <namecmp>
    80004afa:	10050a63          	beqz	a0,80004c0e <sys_unlink+0x15c>
    80004afe:	00003597          	auipc	a1,0x3
    80004b02:	db258593          	add	a1,a1,-590 # 800078b0 <syscalls_names+0x2a8>
    80004b06:	fb040513          	add	a0,s0,-80
    80004b0a:	a71fe0ef          	jal	8000357a <namecmp>
    80004b0e:	10050063          	beqz	a0,80004c0e <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b12:	f2c40613          	add	a2,s0,-212
    80004b16:	fb040593          	add	a1,s0,-80
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	a75fe0ef          	jal	80003590 <dirlookup>
    80004b20:	892a                	mv	s2,a0
    80004b22:	0e050663          	beqz	a0,80004c0e <sys_unlink+0x15c>
  ilock(ip);
    80004b26:	e1efe0ef          	jal	80003144 <ilock>
  if(ip->nlink < 1)
    80004b2a:	04a91783          	lh	a5,74(s2)
    80004b2e:	06f05463          	blez	a5,80004b96 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b32:	04491703          	lh	a4,68(s2)
    80004b36:	4785                	li	a5,1
    80004b38:	06f70563          	beq	a4,a5,80004ba2 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004b3c:	4641                	li	a2,16
    80004b3e:	4581                	li	a1,0
    80004b40:	fc040513          	add	a0,s0,-64
    80004b44:	930fc0ef          	jal	80000c74 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b48:	4741                	li	a4,16
    80004b4a:	f2c42683          	lw	a3,-212(s0)
    80004b4e:	fc040613          	add	a2,s0,-64
    80004b52:	4581                	li	a1,0
    80004b54:	8526                	mv	a0,s1
    80004b56:	923fe0ef          	jal	80003478 <writei>
    80004b5a:	47c1                	li	a5,16
    80004b5c:	08f51563          	bne	a0,a5,80004be6 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004b60:	04491703          	lh	a4,68(s2)
    80004b64:	4785                	li	a5,1
    80004b66:	08f70663          	beq	a4,a5,80004bf2 <sys_unlink+0x140>
  iunlockput(dp);
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	fdefe0ef          	jal	8000334a <iunlockput>
  ip->nlink--;
    80004b70:	04a95783          	lhu	a5,74(s2)
    80004b74:	37fd                	addw	a5,a5,-1
    80004b76:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b7a:	854a                	mv	a0,s2
    80004b7c:	d14fe0ef          	jal	80003090 <iupdate>
  iunlockput(ip);
    80004b80:	854a                	mv	a0,s2
    80004b82:	fc8fe0ef          	jal	8000334a <iunlockput>
  end_op();
    80004b86:	e97fe0ef          	jal	80003a1c <end_op>
  return 0;
    80004b8a:	4501                	li	a0,0
    80004b8c:	a079                	j	80004c1a <sys_unlink+0x168>
    end_op();
    80004b8e:	e8ffe0ef          	jal	80003a1c <end_op>
    return -1;
    80004b92:	557d                	li	a0,-1
    80004b94:	a059                	j	80004c1a <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004b96:	00003517          	auipc	a0,0x3
    80004b9a:	d2250513          	add	a0,a0,-734 # 800078b8 <syscalls_names+0x2b0>
    80004b9e:	bc1fb0ef          	jal	8000075e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ba2:	04c92703          	lw	a4,76(s2)
    80004ba6:	02000793          	li	a5,32
    80004baa:	f8e7f9e3          	bgeu	a5,a4,80004b3c <sys_unlink+0x8a>
    80004bae:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bb2:	4741                	li	a4,16
    80004bb4:	86ce                	mv	a3,s3
    80004bb6:	f1840613          	add	a2,s0,-232
    80004bba:	4581                	li	a1,0
    80004bbc:	854a                	mv	a0,s2
    80004bbe:	fd6fe0ef          	jal	80003394 <readi>
    80004bc2:	47c1                	li	a5,16
    80004bc4:	00f51b63          	bne	a0,a5,80004bda <sys_unlink+0x128>
    if(de.inum != 0)
    80004bc8:	f1845783          	lhu	a5,-232(s0)
    80004bcc:	ef95                	bnez	a5,80004c08 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bce:	29c1                	addw	s3,s3,16
    80004bd0:	04c92783          	lw	a5,76(s2)
    80004bd4:	fcf9efe3          	bltu	s3,a5,80004bb2 <sys_unlink+0x100>
    80004bd8:	b795                	j	80004b3c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004bda:	00003517          	auipc	a0,0x3
    80004bde:	cf650513          	add	a0,a0,-778 # 800078d0 <syscalls_names+0x2c8>
    80004be2:	b7dfb0ef          	jal	8000075e <panic>
    panic("unlink: writei");
    80004be6:	00003517          	auipc	a0,0x3
    80004bea:	d0250513          	add	a0,a0,-766 # 800078e8 <syscalls_names+0x2e0>
    80004bee:	b71fb0ef          	jal	8000075e <panic>
    dp->nlink--;
    80004bf2:	04a4d783          	lhu	a5,74(s1)
    80004bf6:	37fd                	addw	a5,a5,-1
    80004bf8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	c92fe0ef          	jal	80003090 <iupdate>
    80004c02:	b7a5                	j	80004b6a <sys_unlink+0xb8>
    return -1;
    80004c04:	557d                	li	a0,-1
    80004c06:	a811                	j	80004c1a <sys_unlink+0x168>
    iunlockput(ip);
    80004c08:	854a                	mv	a0,s2
    80004c0a:	f40fe0ef          	jal	8000334a <iunlockput>
  iunlockput(dp);
    80004c0e:	8526                	mv	a0,s1
    80004c10:	f3afe0ef          	jal	8000334a <iunlockput>
  end_op();
    80004c14:	e09fe0ef          	jal	80003a1c <end_op>
  return -1;
    80004c18:	557d                	li	a0,-1
}
    80004c1a:	70ae                	ld	ra,232(sp)
    80004c1c:	740e                	ld	s0,224(sp)
    80004c1e:	64ee                	ld	s1,216(sp)
    80004c20:	694e                	ld	s2,208(sp)
    80004c22:	69ae                	ld	s3,200(sp)
    80004c24:	616d                	add	sp,sp,240
    80004c26:	8082                	ret

0000000080004c28 <sys_open>:

uint64
sys_open(void)
{
    80004c28:	7131                	add	sp,sp,-192
    80004c2a:	fd06                	sd	ra,184(sp)
    80004c2c:	f922                	sd	s0,176(sp)
    80004c2e:	f526                	sd	s1,168(sp)
    80004c30:	f14a                	sd	s2,160(sp)
    80004c32:	ed4e                	sd	s3,152(sp)
    80004c34:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c36:	f4c40593          	add	a1,s0,-180
    80004c3a:	4505                	li	a0,1
    80004c3c:	aaffd0ef          	jal	800026ea <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c40:	08000613          	li	a2,128
    80004c44:	f5040593          	add	a1,s0,-176
    80004c48:	4501                	li	a0,0
    80004c4a:	ad9fd0ef          	jal	80002722 <argstr>
    80004c4e:	87aa                	mv	a5,a0
    return -1;
    80004c50:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c52:	0807cc63          	bltz	a5,80004cea <sys_open+0xc2>

  begin_op();
    80004c56:	d5dfe0ef          	jal	800039b2 <begin_op>

  if(omode & O_CREATE){
    80004c5a:	f4c42783          	lw	a5,-180(s0)
    80004c5e:	2007f793          	and	a5,a5,512
    80004c62:	cfd9                	beqz	a5,80004d00 <sys_open+0xd8>
    ip = create(path, T_FILE, 0, 0);
    80004c64:	4681                	li	a3,0
    80004c66:	4601                	li	a2,0
    80004c68:	4589                	li	a1,2
    80004c6a:	f5040513          	add	a0,s0,-176
    80004c6e:	ac7ff0ef          	jal	80004734 <create>
    80004c72:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c74:	c151                	beqz	a0,80004cf8 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c76:	04449703          	lh	a4,68(s1)
    80004c7a:	478d                	li	a5,3
    80004c7c:	00f71763          	bne	a4,a5,80004c8a <sys_open+0x62>
    80004c80:	0464d703          	lhu	a4,70(s1)
    80004c84:	47a5                	li	a5,9
    80004c86:	0ae7e863          	bltu	a5,a4,80004d36 <sys_open+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c8a:	898ff0ef          	jal	80003d22 <filealloc>
    80004c8e:	892a                	mv	s2,a0
    80004c90:	cd4d                	beqz	a0,80004d4a <sys_open+0x122>
    80004c92:	a65ff0ef          	jal	800046f6 <fdalloc>
    80004c96:	89aa                	mv	s3,a0
    80004c98:	0a054663          	bltz	a0,80004d44 <sys_open+0x11c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c9c:	04449703          	lh	a4,68(s1)
    80004ca0:	478d                	li	a5,3
    80004ca2:	0af70b63          	beq	a4,a5,80004d58 <sys_open+0x130>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ca6:	4789                	li	a5,2
    80004ca8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004cac:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004cb0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004cb4:	f4c42783          	lw	a5,-180(s0)
    80004cb8:	0017c713          	xor	a4,a5,1
    80004cbc:	8b05                	and	a4,a4,1
    80004cbe:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cc2:	0037f713          	and	a4,a5,3
    80004cc6:	00e03733          	snez	a4,a4
    80004cca:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cce:	4007f793          	and	a5,a5,1024
    80004cd2:	c791                	beqz	a5,80004cde <sys_open+0xb6>
    80004cd4:	04449703          	lh	a4,68(s1)
    80004cd8:	4789                	li	a5,2
    80004cda:	08f70663          	beq	a4,a5,80004d66 <sys_open+0x13e>
    itrunc(ip);
  }

  iunlock(ip);
    80004cde:	8526                	mv	a0,s1
    80004ce0:	d0efe0ef          	jal	800031ee <iunlock>
  end_op();
    80004ce4:	d39fe0ef          	jal	80003a1c <end_op>

  return fd;
    80004ce8:	854e                	mv	a0,s3
}
    80004cea:	70ea                	ld	ra,184(sp)
    80004cec:	744a                	ld	s0,176(sp)
    80004cee:	74aa                	ld	s1,168(sp)
    80004cf0:	790a                	ld	s2,160(sp)
    80004cf2:	69ea                	ld	s3,152(sp)
    80004cf4:	6129                	add	sp,sp,192
    80004cf6:	8082                	ret
      end_op();
    80004cf8:	d25fe0ef          	jal	80003a1c <end_op>
      return -1;
    80004cfc:	557d                	li	a0,-1
    80004cfe:	b7f5                	j	80004cea <sys_open+0xc2>
    if((ip = namei(path)) == 0){
    80004d00:	f5040513          	add	a0,s0,-176
    80004d04:	af3fe0ef          	jal	800037f6 <namei>
    80004d08:	84aa                	mv	s1,a0
    80004d0a:	c115                	beqz	a0,80004d2e <sys_open+0x106>
    ilock(ip);
    80004d0c:	c38fe0ef          	jal	80003144 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d10:	04449703          	lh	a4,68(s1)
    80004d14:	4785                	li	a5,1
    80004d16:	f6f710e3          	bne	a4,a5,80004c76 <sys_open+0x4e>
    80004d1a:	f4c42783          	lw	a5,-180(s0)
    80004d1e:	d7b5                	beqz	a5,80004c8a <sys_open+0x62>
      iunlockput(ip);
    80004d20:	8526                	mv	a0,s1
    80004d22:	e28fe0ef          	jal	8000334a <iunlockput>
      end_op();
    80004d26:	cf7fe0ef          	jal	80003a1c <end_op>
      return -1;
    80004d2a:	557d                	li	a0,-1
    80004d2c:	bf7d                	j	80004cea <sys_open+0xc2>
      end_op();
    80004d2e:	ceffe0ef          	jal	80003a1c <end_op>
      return -1;
    80004d32:	557d                	li	a0,-1
    80004d34:	bf5d                	j	80004cea <sys_open+0xc2>
    iunlockput(ip);
    80004d36:	8526                	mv	a0,s1
    80004d38:	e12fe0ef          	jal	8000334a <iunlockput>
    end_op();
    80004d3c:	ce1fe0ef          	jal	80003a1c <end_op>
    return -1;
    80004d40:	557d                	li	a0,-1
    80004d42:	b765                	j	80004cea <sys_open+0xc2>
      fileclose(f);
    80004d44:	854a                	mv	a0,s2
    80004d46:	880ff0ef          	jal	80003dc6 <fileclose>
    iunlockput(ip);
    80004d4a:	8526                	mv	a0,s1
    80004d4c:	dfefe0ef          	jal	8000334a <iunlockput>
    end_op();
    80004d50:	ccdfe0ef          	jal	80003a1c <end_op>
    return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	bf51                	j	80004cea <sys_open+0xc2>
    f->type = FD_DEVICE;
    80004d58:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d5c:	04649783          	lh	a5,70(s1)
    80004d60:	02f91223          	sh	a5,36(s2)
    80004d64:	b7b1                	j	80004cb0 <sys_open+0x88>
    itrunc(ip);
    80004d66:	8526                	mv	a0,s1
    80004d68:	cc6fe0ef          	jal	8000322e <itrunc>
    80004d6c:	bf8d                	j	80004cde <sys_open+0xb6>

0000000080004d6e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d6e:	7175                	add	sp,sp,-144
    80004d70:	e506                	sd	ra,136(sp)
    80004d72:	e122                	sd	s0,128(sp)
    80004d74:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d76:	c3dfe0ef          	jal	800039b2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d7a:	08000613          	li	a2,128
    80004d7e:	f7040593          	add	a1,s0,-144
    80004d82:	4501                	li	a0,0
    80004d84:	99ffd0ef          	jal	80002722 <argstr>
    80004d88:	02054363          	bltz	a0,80004dae <sys_mkdir+0x40>
    80004d8c:	4681                	li	a3,0
    80004d8e:	4601                	li	a2,0
    80004d90:	4585                	li	a1,1
    80004d92:	f7040513          	add	a0,s0,-144
    80004d96:	99fff0ef          	jal	80004734 <create>
    80004d9a:	c911                	beqz	a0,80004dae <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d9c:	daefe0ef          	jal	8000334a <iunlockput>
  end_op();
    80004da0:	c7dfe0ef          	jal	80003a1c <end_op>
  return 0;
    80004da4:	4501                	li	a0,0
}
    80004da6:	60aa                	ld	ra,136(sp)
    80004da8:	640a                	ld	s0,128(sp)
    80004daa:	6149                	add	sp,sp,144
    80004dac:	8082                	ret
    end_op();
    80004dae:	c6ffe0ef          	jal	80003a1c <end_op>
    return -1;
    80004db2:	557d                	li	a0,-1
    80004db4:	bfcd                	j	80004da6 <sys_mkdir+0x38>

0000000080004db6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004db6:	7135                	add	sp,sp,-160
    80004db8:	ed06                	sd	ra,152(sp)
    80004dba:	e922                	sd	s0,144(sp)
    80004dbc:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dbe:	bf5fe0ef          	jal	800039b2 <begin_op>
  argint(1, &major);
    80004dc2:	f6c40593          	add	a1,s0,-148
    80004dc6:	4505                	li	a0,1
    80004dc8:	923fd0ef          	jal	800026ea <argint>
  argint(2, &minor);
    80004dcc:	f6840593          	add	a1,s0,-152
    80004dd0:	4509                	li	a0,2
    80004dd2:	919fd0ef          	jal	800026ea <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dd6:	08000613          	li	a2,128
    80004dda:	f7040593          	add	a1,s0,-144
    80004dde:	4501                	li	a0,0
    80004de0:	943fd0ef          	jal	80002722 <argstr>
    80004de4:	02054563          	bltz	a0,80004e0e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004de8:	f6841683          	lh	a3,-152(s0)
    80004dec:	f6c41603          	lh	a2,-148(s0)
    80004df0:	458d                	li	a1,3
    80004df2:	f7040513          	add	a0,s0,-144
    80004df6:	93fff0ef          	jal	80004734 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dfa:	c911                	beqz	a0,80004e0e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dfc:	d4efe0ef          	jal	8000334a <iunlockput>
  end_op();
    80004e00:	c1dfe0ef          	jal	80003a1c <end_op>
  return 0;
    80004e04:	4501                	li	a0,0
}
    80004e06:	60ea                	ld	ra,152(sp)
    80004e08:	644a                	ld	s0,144(sp)
    80004e0a:	610d                	add	sp,sp,160
    80004e0c:	8082                	ret
    end_op();
    80004e0e:	c0ffe0ef          	jal	80003a1c <end_op>
    return -1;
    80004e12:	557d                	li	a0,-1
    80004e14:	bfcd                	j	80004e06 <sys_mknod+0x50>

0000000080004e16 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e16:	7135                	add	sp,sp,-160
    80004e18:	ed06                	sd	ra,152(sp)
    80004e1a:	e922                	sd	s0,144(sp)
    80004e1c:	e526                	sd	s1,136(sp)
    80004e1e:	e14a                	sd	s2,128(sp)
    80004e20:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e22:	a0ffc0ef          	jal	80001830 <myproc>
    80004e26:	892a                	mv	s2,a0
  
  begin_op();
    80004e28:	b8bfe0ef          	jal	800039b2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e2c:	08000613          	li	a2,128
    80004e30:	f6040593          	add	a1,s0,-160
    80004e34:	4501                	li	a0,0
    80004e36:	8edfd0ef          	jal	80002722 <argstr>
    80004e3a:	04054163          	bltz	a0,80004e7c <sys_chdir+0x66>
    80004e3e:	f6040513          	add	a0,s0,-160
    80004e42:	9b5fe0ef          	jal	800037f6 <namei>
    80004e46:	84aa                	mv	s1,a0
    80004e48:	c915                	beqz	a0,80004e7c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e4a:	afafe0ef          	jal	80003144 <ilock>
  if(ip->type != T_DIR){
    80004e4e:	04449703          	lh	a4,68(s1)
    80004e52:	4785                	li	a5,1
    80004e54:	02f71863          	bne	a4,a5,80004e84 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	b94fe0ef          	jal	800031ee <iunlock>
  iput(p->cwd);
    80004e5e:	15893503          	ld	a0,344(s2)
    80004e62:	c60fe0ef          	jal	800032c2 <iput>
  end_op();
    80004e66:	bb7fe0ef          	jal	80003a1c <end_op>
  p->cwd = ip;
    80004e6a:	14993c23          	sd	s1,344(s2)
  return 0;
    80004e6e:	4501                	li	a0,0
}
    80004e70:	60ea                	ld	ra,152(sp)
    80004e72:	644a                	ld	s0,144(sp)
    80004e74:	64aa                	ld	s1,136(sp)
    80004e76:	690a                	ld	s2,128(sp)
    80004e78:	610d                	add	sp,sp,160
    80004e7a:	8082                	ret
    end_op();
    80004e7c:	ba1fe0ef          	jal	80003a1c <end_op>
    return -1;
    80004e80:	557d                	li	a0,-1
    80004e82:	b7fd                	j	80004e70 <sys_chdir+0x5a>
    iunlockput(ip);
    80004e84:	8526                	mv	a0,s1
    80004e86:	cc4fe0ef          	jal	8000334a <iunlockput>
    end_op();
    80004e8a:	b93fe0ef          	jal	80003a1c <end_op>
    return -1;
    80004e8e:	557d                	li	a0,-1
    80004e90:	b7c5                	j	80004e70 <sys_chdir+0x5a>

0000000080004e92 <sys_exec>:

uint64
sys_exec(void)
{
    80004e92:	7121                	add	sp,sp,-448
    80004e94:	ff06                	sd	ra,440(sp)
    80004e96:	fb22                	sd	s0,432(sp)
    80004e98:	f726                	sd	s1,424(sp)
    80004e9a:	f34a                	sd	s2,416(sp)
    80004e9c:	ef4e                	sd	s3,408(sp)
    80004e9e:	eb52                	sd	s4,400(sp)
    80004ea0:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004ea2:	e4840593          	add	a1,s0,-440
    80004ea6:	4505                	li	a0,1
    80004ea8:	85ffd0ef          	jal	80002706 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004eac:	08000613          	li	a2,128
    80004eb0:	f5040593          	add	a1,s0,-176
    80004eb4:	4501                	li	a0,0
    80004eb6:	86dfd0ef          	jal	80002722 <argstr>
    80004eba:	87aa                	mv	a5,a0
    return -1;
    80004ebc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ebe:	0a07c463          	bltz	a5,80004f66 <sys_exec+0xd4>
  }
  memset(argv, 0, sizeof(argv));
    80004ec2:	10000613          	li	a2,256
    80004ec6:	4581                	li	a1,0
    80004ec8:	e5040513          	add	a0,s0,-432
    80004ecc:	da9fb0ef          	jal	80000c74 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ed0:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004ed4:	89a6                	mv	s3,s1
    80004ed6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ed8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004edc:	00391513          	sll	a0,s2,0x3
    80004ee0:	e4040593          	add	a1,s0,-448
    80004ee4:	e4843783          	ld	a5,-440(s0)
    80004ee8:	953e                	add	a0,a0,a5
    80004eea:	f76fd0ef          	jal	80002660 <fetchaddr>
    80004eee:	02054663          	bltz	a0,80004f1a <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004ef2:	e4043783          	ld	a5,-448(s0)
    80004ef6:	cf8d                	beqz	a5,80004f30 <sys_exec+0x9e>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ef8:	bd9fb0ef          	jal	80000ad0 <kalloc>
    80004efc:	85aa                	mv	a1,a0
    80004efe:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f02:	cd01                	beqz	a0,80004f1a <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f04:	6605                	lui	a2,0x1
    80004f06:	e4043503          	ld	a0,-448(s0)
    80004f0a:	fa0fd0ef          	jal	800026aa <fetchstr>
    80004f0e:	00054663          	bltz	a0,80004f1a <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004f12:	0905                	add	s2,s2,1
    80004f14:	09a1                	add	s3,s3,8
    80004f16:	fd4913e3          	bne	s2,s4,80004edc <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1a:	f5040913          	add	s2,s0,-176
    80004f1e:	6088                	ld	a0,0(s1)
    80004f20:	c131                	beqz	a0,80004f64 <sys_exec+0xd2>
    kfree(argv[i]);
    80004f22:	acdfb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f26:	04a1                	add	s1,s1,8
    80004f28:	ff249be3          	bne	s1,s2,80004f1e <sys_exec+0x8c>
  return -1;
    80004f2c:	557d                	li	a0,-1
    80004f2e:	a825                	j	80004f66 <sys_exec+0xd4>
      argv[i] = 0;
    80004f30:	0009079b          	sext.w	a5,s2
    80004f34:	078e                	sll	a5,a5,0x3
    80004f36:	fd078793          	add	a5,a5,-48
    80004f3a:	97a2                	add	a5,a5,s0
    80004f3c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f40:	e5040593          	add	a1,s0,-432
    80004f44:	f5040513          	add	a0,s0,-176
    80004f48:	c1cff0ef          	jal	80004364 <exec>
    80004f4c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4e:	f5040993          	add	s3,s0,-176
    80004f52:	6088                	ld	a0,0(s1)
    80004f54:	c511                	beqz	a0,80004f60 <sys_exec+0xce>
    kfree(argv[i]);
    80004f56:	a99fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5a:	04a1                	add	s1,s1,8
    80004f5c:	ff349be3          	bne	s1,s3,80004f52 <sys_exec+0xc0>
  return ret;
    80004f60:	854a                	mv	a0,s2
    80004f62:	a011                	j	80004f66 <sys_exec+0xd4>
  return -1;
    80004f64:	557d                	li	a0,-1
}
    80004f66:	70fa                	ld	ra,440(sp)
    80004f68:	745a                	ld	s0,432(sp)
    80004f6a:	74ba                	ld	s1,424(sp)
    80004f6c:	791a                	ld	s2,416(sp)
    80004f6e:	69fa                	ld	s3,408(sp)
    80004f70:	6a5a                	ld	s4,400(sp)
    80004f72:	6139                	add	sp,sp,448
    80004f74:	8082                	ret

0000000080004f76 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f76:	7139                	add	sp,sp,-64
    80004f78:	fc06                	sd	ra,56(sp)
    80004f7a:	f822                	sd	s0,48(sp)
    80004f7c:	f426                	sd	s1,40(sp)
    80004f7e:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f80:	8b1fc0ef          	jal	80001830 <myproc>
    80004f84:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f86:	fd840593          	add	a1,s0,-40
    80004f8a:	4501                	li	a0,0
    80004f8c:	f7afd0ef          	jal	80002706 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f90:	fc840593          	add	a1,s0,-56
    80004f94:	fd040513          	add	a0,s0,-48
    80004f98:	8f6ff0ef          	jal	8000408e <pipealloc>
    return -1;
    80004f9c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f9e:	0a054463          	bltz	a0,80005046 <sys_pipe+0xd0>
  fd0 = -1;
    80004fa2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fa6:	fd043503          	ld	a0,-48(s0)
    80004faa:	f4cff0ef          	jal	800046f6 <fdalloc>
    80004fae:	fca42223          	sw	a0,-60(s0)
    80004fb2:	08054163          	bltz	a0,80005034 <sys_pipe+0xbe>
    80004fb6:	fc843503          	ld	a0,-56(s0)
    80004fba:	f3cff0ef          	jal	800046f6 <fdalloc>
    80004fbe:	fca42023          	sw	a0,-64(s0)
    80004fc2:	06054063          	bltz	a0,80005022 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fc6:	4691                	li	a3,4
    80004fc8:	fc440613          	add	a2,s0,-60
    80004fcc:	fd843583          	ld	a1,-40(s0)
    80004fd0:	6ca8                	ld	a0,88(s1)
    80004fd2:	d16fc0ef          	jal	800014e8 <copyout>
    80004fd6:	00054e63          	bltz	a0,80004ff2 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fda:	4691                	li	a3,4
    80004fdc:	fc040613          	add	a2,s0,-64
    80004fe0:	fd843583          	ld	a1,-40(s0)
    80004fe4:	0591                	add	a1,a1,4
    80004fe6:	6ca8                	ld	a0,88(s1)
    80004fe8:	d00fc0ef          	jal	800014e8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fec:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fee:	04055c63          	bgez	a0,80005046 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004ff2:	fc442783          	lw	a5,-60(s0)
    80004ff6:	07e9                	add	a5,a5,26
    80004ff8:	078e                	sll	a5,a5,0x3
    80004ffa:	97a6                	add	a5,a5,s1
    80004ffc:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005000:	fc042783          	lw	a5,-64(s0)
    80005004:	07e9                	add	a5,a5,26
    80005006:	078e                	sll	a5,a5,0x3
    80005008:	94be                	add	s1,s1,a5
    8000500a:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000500e:	fd043503          	ld	a0,-48(s0)
    80005012:	db5fe0ef          	jal	80003dc6 <fileclose>
    fileclose(wf);
    80005016:	fc843503          	ld	a0,-56(s0)
    8000501a:	dadfe0ef          	jal	80003dc6 <fileclose>
    return -1;
    8000501e:	57fd                	li	a5,-1
    80005020:	a01d                	j	80005046 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005022:	fc442783          	lw	a5,-60(s0)
    80005026:	0007c763          	bltz	a5,80005034 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000502a:	07e9                	add	a5,a5,26
    8000502c:	078e                	sll	a5,a5,0x3
    8000502e:	97a6                	add	a5,a5,s1
    80005030:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005034:	fd043503          	ld	a0,-48(s0)
    80005038:	d8ffe0ef          	jal	80003dc6 <fileclose>
    fileclose(wf);
    8000503c:	fc843503          	ld	a0,-56(s0)
    80005040:	d87fe0ef          	jal	80003dc6 <fileclose>
    return -1;
    80005044:	57fd                	li	a5,-1
}
    80005046:	853e                	mv	a0,a5
    80005048:	70e2                	ld	ra,56(sp)
    8000504a:	7442                	ld	s0,48(sp)
    8000504c:	74a2                	ld	s1,40(sp)
    8000504e:	6121                	add	sp,sp,64
    80005050:	8082                	ret
	...

0000000080005060 <kernelvec>:
    80005060:	7111                	add	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	e4aa                	sd	a0,72(sp)
    80005072:	e8ae                	sd	a1,80(sp)
    80005074:	ecb2                	sd	a2,88(sp)
    80005076:	f0b6                	sd	a3,96(sp)
    80005078:	f4ba                	sd	a4,104(sp)
    8000507a:	f8be                	sd	a5,112(sp)
    8000507c:	fcc2                	sd	a6,120(sp)
    8000507e:	e146                	sd	a7,128(sp)
    80005080:	edf2                	sd	t3,216(sp)
    80005082:	f1f6                	sd	t4,224(sp)
    80005084:	f5fa                	sd	t5,232(sp)
    80005086:	f9fe                	sd	t6,240(sp)
    80005088:	ce8fd0ef          	jal	80002570 <kerneltrap>
    8000508c:	6082                	ld	ra,0(sp)
    8000508e:	6122                	ld	sp,8(sp)
    80005090:	61c2                	ld	gp,16(sp)
    80005092:	7282                	ld	t0,32(sp)
    80005094:	7322                	ld	t1,40(sp)
    80005096:	73c2                	ld	t2,48(sp)
    80005098:	6526                	ld	a0,72(sp)
    8000509a:	65c6                	ld	a1,80(sp)
    8000509c:	6666                	ld	a2,88(sp)
    8000509e:	7686                	ld	a3,96(sp)
    800050a0:	7726                	ld	a4,104(sp)
    800050a2:	77c6                	ld	a5,112(sp)
    800050a4:	7866                	ld	a6,120(sp)
    800050a6:	688a                	ld	a7,128(sp)
    800050a8:	6e6e                	ld	t3,216(sp)
    800050aa:	7e8e                	ld	t4,224(sp)
    800050ac:	7f2e                	ld	t5,232(sp)
    800050ae:	7fce                	ld	t6,240(sp)
    800050b0:	6111                	add	sp,sp,256
    800050b2:	10200073          	sret
	...

00000000800050be <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    800050be:	1141                	add	sp,sp,-16
    800050c0:	e422                	sd	s0,8(sp)
    800050c2:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050c4:	0c0007b7          	lui	a5,0xc000
    800050c8:	4705                	li	a4,1
    800050ca:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050cc:	c3d8                	sw	a4,4(a5)
}
    800050ce:	6422                	ld	s0,8(sp)
    800050d0:	0141                	add	sp,sp,16
    800050d2:	8082                	ret

00000000800050d4 <plicinithart>:

void
plicinithart(void)
{
    800050d4:	1141                	add	sp,sp,-16
    800050d6:	e406                	sd	ra,8(sp)
    800050d8:	e022                	sd	s0,0(sp)
    800050da:	0800                	add	s0,sp,16
  int hart = cpuid();
    800050dc:	f28fc0ef          	jal	80001804 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050e0:	0085171b          	sllw	a4,a0,0x8
    800050e4:	0c0027b7          	lui	a5,0xc002
    800050e8:	97ba                	add	a5,a5,a4
    800050ea:	40200713          	li	a4,1026
    800050ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050f2:	00d5151b          	sllw	a0,a0,0xd
    800050f6:	0c2017b7          	lui	a5,0xc201
    800050fa:	97aa                	add	a5,a5,a0
    800050fc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005100:	60a2                	ld	ra,8(sp)
    80005102:	6402                	ld	s0,0(sp)
    80005104:	0141                	add	sp,sp,16
    80005106:	8082                	ret

0000000080005108 <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005108:	1141                	add	sp,sp,-16
    8000510a:	e406                	sd	ra,8(sp)
    8000510c:	e022                	sd	s0,0(sp)
    8000510e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005110:	ef4fc0ef          	jal	80001804 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005114:	00d5151b          	sllw	a0,a0,0xd
    80005118:	0c2017b7          	lui	a5,0xc201
    8000511c:	97aa                	add	a5,a5,a0
  return irq;
}
    8000511e:	43c8                	lw	a0,4(a5)
    80005120:	60a2                	ld	ra,8(sp)
    80005122:	6402                	ld	s0,0(sp)
    80005124:	0141                	add	sp,sp,16
    80005126:	8082                	ret

0000000080005128 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    80005128:	1101                	add	sp,sp,-32
    8000512a:	ec06                	sd	ra,24(sp)
    8000512c:	e822                	sd	s0,16(sp)
    8000512e:	e426                	sd	s1,8(sp)
    80005130:	1000                	add	s0,sp,32
    80005132:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005134:	ed0fc0ef          	jal	80001804 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005138:	00d5151b          	sllw	a0,a0,0xd
    8000513c:	0c2017b7          	lui	a5,0xc201
    80005140:	97aa                	add	a5,a5,a0
    80005142:	c3c4                	sw	s1,4(a5)
}
    80005144:	60e2                	ld	ra,24(sp)
    80005146:	6442                	ld	s0,16(sp)
    80005148:	64a2                	ld	s1,8(sp)
    8000514a:	6105                	add	sp,sp,32
    8000514c:	8082                	ret

000000008000514e <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    8000514e:	1141                	add	sp,sp,-16
    80005150:	e406                	sd	ra,8(sp)
    80005152:	e022                	sd	s0,0(sp)
    80005154:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005156:	479d                	li	a5,7
    80005158:	04a7ca63          	blt	a5,a0,800051ac <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000515c:	0001c797          	auipc	a5,0x1c
    80005160:	d2478793          	add	a5,a5,-732 # 80020e80 <disk>
    80005164:	97aa                	add	a5,a5,a0
    80005166:	0187c783          	lbu	a5,24(a5)
    8000516a:	e7b9                	bnez	a5,800051b8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000516c:	00451693          	sll	a3,a0,0x4
    80005170:	0001c797          	auipc	a5,0x1c
    80005174:	d1078793          	add	a5,a5,-752 # 80020e80 <disk>
    80005178:	6398                	ld	a4,0(a5)
    8000517a:	9736                	add	a4,a4,a3
    8000517c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005180:	6398                	ld	a4,0(a5)
    80005182:	9736                	add	a4,a4,a3
    80005184:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005188:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000518c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005190:	97aa                	add	a5,a5,a0
    80005192:	4705                	li	a4,1
    80005194:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005198:	0001c517          	auipc	a0,0x1c
    8000519c:	d0050513          	add	a0,a0,-768 # 80020e98 <disk+0x18>
    800051a0:	cb5fc0ef          	jal	80001e54 <wakeup>
}
    800051a4:	60a2                	ld	ra,8(sp)
    800051a6:	6402                	ld	s0,0(sp)
    800051a8:	0141                	add	sp,sp,16
    800051aa:	8082                	ret
    panic("free_desc 1");
    800051ac:	00002517          	auipc	a0,0x2
    800051b0:	74c50513          	add	a0,a0,1868 # 800078f8 <syscalls_names+0x2f0>
    800051b4:	daafb0ef          	jal	8000075e <panic>
    panic("free_desc 2");
    800051b8:	00002517          	auipc	a0,0x2
    800051bc:	75050513          	add	a0,a0,1872 # 80007908 <syscalls_names+0x300>
    800051c0:	d9efb0ef          	jal	8000075e <panic>

00000000800051c4 <virtio_disk_init>:
{
    800051c4:	1101                	add	sp,sp,-32
    800051c6:	ec06                	sd	ra,24(sp)
    800051c8:	e822                	sd	s0,16(sp)
    800051ca:	e426                	sd	s1,8(sp)
    800051cc:	e04a                	sd	s2,0(sp)
    800051ce:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051d0:	00002597          	auipc	a1,0x2
    800051d4:	74858593          	add	a1,a1,1864 # 80007918 <syscalls_names+0x310>
    800051d8:	0001c517          	auipc	a0,0x1c
    800051dc:	dd050513          	add	a0,a0,-560 # 80020fa8 <disk+0x128>
    800051e0:	941fb0ef          	jal	80000b20 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051e4:	100017b7          	lui	a5,0x10001
    800051e8:	4398                	lw	a4,0(a5)
    800051ea:	2701                	sext.w	a4,a4
    800051ec:	747277b7          	lui	a5,0x74727
    800051f0:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051f4:	12f71f63          	bne	a4,a5,80005332 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051f8:	100017b7          	lui	a5,0x10001
    800051fc:	43dc                	lw	a5,4(a5)
    800051fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005200:	4709                	li	a4,2
    80005202:	12e79863          	bne	a5,a4,80005332 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005206:	100017b7          	lui	a5,0x10001
    8000520a:	479c                	lw	a5,8(a5)
    8000520c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000520e:	12e79263          	bne	a5,a4,80005332 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005212:	100017b7          	lui	a5,0x10001
    80005216:	47d8                	lw	a4,12(a5)
    80005218:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000521a:	554d47b7          	lui	a5,0x554d4
    8000521e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005222:	10f71863          	bne	a4,a5,80005332 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005226:	100017b7          	lui	a5,0x10001
    8000522a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000522e:	4705                	li	a4,1
    80005230:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005232:	470d                	li	a4,3
    80005234:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005236:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005238:	c7ffe6b7          	lui	a3,0xc7ffe
    8000523c:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd79f>
    80005240:	8f75                	and	a4,a4,a3
    80005242:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005244:	472d                	li	a4,11
    80005246:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005248:	5bbc                	lw	a5,112(a5)
    8000524a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000524e:	8ba1                	and	a5,a5,8
    80005250:	0e078763          	beqz	a5,8000533e <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005254:	100017b7          	lui	a5,0x10001
    80005258:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000525c:	43fc                	lw	a5,68(a5)
    8000525e:	2781                	sext.w	a5,a5
    80005260:	0e079563          	bnez	a5,8000534a <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005264:	100017b7          	lui	a5,0x10001
    80005268:	5bdc                	lw	a5,52(a5)
    8000526a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000526c:	0e078563          	beqz	a5,80005356 <virtio_disk_init+0x192>
  if(max < NUM)
    80005270:	471d                	li	a4,7
    80005272:	0ef77863          	bgeu	a4,a5,80005362 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005276:	85bfb0ef          	jal	80000ad0 <kalloc>
    8000527a:	0001c497          	auipc	s1,0x1c
    8000527e:	c0648493          	add	s1,s1,-1018 # 80020e80 <disk>
    80005282:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005284:	84dfb0ef          	jal	80000ad0 <kalloc>
    80005288:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000528a:	847fb0ef          	jal	80000ad0 <kalloc>
    8000528e:	87aa                	mv	a5,a0
    80005290:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005292:	6088                	ld	a0,0(s1)
    80005294:	cd69                	beqz	a0,8000536e <virtio_disk_init+0x1aa>
    80005296:	0001c717          	auipc	a4,0x1c
    8000529a:	bf273703          	ld	a4,-1038(a4) # 80020e88 <disk+0x8>
    8000529e:	cb61                	beqz	a4,8000536e <virtio_disk_init+0x1aa>
    800052a0:	c7f9                	beqz	a5,8000536e <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    800052a2:	6605                	lui	a2,0x1
    800052a4:	4581                	li	a1,0
    800052a6:	9cffb0ef          	jal	80000c74 <memset>
  memset(disk.avail, 0, PGSIZE);
    800052aa:	0001c497          	auipc	s1,0x1c
    800052ae:	bd648493          	add	s1,s1,-1066 # 80020e80 <disk>
    800052b2:	6605                	lui	a2,0x1
    800052b4:	4581                	li	a1,0
    800052b6:	6488                	ld	a0,8(s1)
    800052b8:	9bdfb0ef          	jal	80000c74 <memset>
  memset(disk.used, 0, PGSIZE);
    800052bc:	6605                	lui	a2,0x1
    800052be:	4581                	li	a1,0
    800052c0:	6888                	ld	a0,16(s1)
    800052c2:	9b3fb0ef          	jal	80000c74 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	4721                	li	a4,8
    800052cc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052ce:	4098                	lw	a4,0(s1)
    800052d0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052d4:	40d8                	lw	a4,4(s1)
    800052d6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052da:	6498                	ld	a4,8(s1)
    800052dc:	0007069b          	sext.w	a3,a4
    800052e0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052e4:	9701                	sra	a4,a4,0x20
    800052e6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052ea:	6898                	ld	a4,16(s1)
    800052ec:	0007069b          	sext.w	a3,a4
    800052f0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052f4:	9701                	sra	a4,a4,0x20
    800052f6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052fa:	4705                	li	a4,1
    800052fc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052fe:	00e48c23          	sb	a4,24(s1)
    80005302:	00e48ca3          	sb	a4,25(s1)
    80005306:	00e48d23          	sb	a4,26(s1)
    8000530a:	00e48da3          	sb	a4,27(s1)
    8000530e:	00e48e23          	sb	a4,28(s1)
    80005312:	00e48ea3          	sb	a4,29(s1)
    80005316:	00e48f23          	sb	a4,30(s1)
    8000531a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000531e:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005322:	0727a823          	sw	s2,112(a5)
}
    80005326:	60e2                	ld	ra,24(sp)
    80005328:	6442                	ld	s0,16(sp)
    8000532a:	64a2                	ld	s1,8(sp)
    8000532c:	6902                	ld	s2,0(sp)
    8000532e:	6105                	add	sp,sp,32
    80005330:	8082                	ret
    panic("could not find virtio disk");
    80005332:	00002517          	auipc	a0,0x2
    80005336:	5f650513          	add	a0,a0,1526 # 80007928 <syscalls_names+0x320>
    8000533a:	c24fb0ef          	jal	8000075e <panic>
    panic("virtio disk FEATURES_OK unset");
    8000533e:	00002517          	auipc	a0,0x2
    80005342:	60a50513          	add	a0,a0,1546 # 80007948 <syscalls_names+0x340>
    80005346:	c18fb0ef          	jal	8000075e <panic>
    panic("virtio disk should not be ready");
    8000534a:	00002517          	auipc	a0,0x2
    8000534e:	61e50513          	add	a0,a0,1566 # 80007968 <syscalls_names+0x360>
    80005352:	c0cfb0ef          	jal	8000075e <panic>
    panic("virtio disk has no queue 0");
    80005356:	00002517          	auipc	a0,0x2
    8000535a:	63250513          	add	a0,a0,1586 # 80007988 <syscalls_names+0x380>
    8000535e:	c00fb0ef          	jal	8000075e <panic>
    panic("virtio disk max queue too short");
    80005362:	00002517          	auipc	a0,0x2
    80005366:	64650513          	add	a0,a0,1606 # 800079a8 <syscalls_names+0x3a0>
    8000536a:	bf4fb0ef          	jal	8000075e <panic>
    panic("virtio disk kalloc");
    8000536e:	00002517          	auipc	a0,0x2
    80005372:	65a50513          	add	a0,a0,1626 # 800079c8 <syscalls_names+0x3c0>
    80005376:	be8fb0ef          	jal	8000075e <panic>

000000008000537a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000537a:	7159                	add	sp,sp,-112
    8000537c:	f486                	sd	ra,104(sp)
    8000537e:	f0a2                	sd	s0,96(sp)
    80005380:	eca6                	sd	s1,88(sp)
    80005382:	e8ca                	sd	s2,80(sp)
    80005384:	e4ce                	sd	s3,72(sp)
    80005386:	e0d2                	sd	s4,64(sp)
    80005388:	fc56                	sd	s5,56(sp)
    8000538a:	f85a                	sd	s6,48(sp)
    8000538c:	f45e                	sd	s7,40(sp)
    8000538e:	f062                	sd	s8,32(sp)
    80005390:	ec66                	sd	s9,24(sp)
    80005392:	e86a                	sd	s10,16(sp)
    80005394:	1880                	add	s0,sp,112
    80005396:	8a2a                	mv	s4,a0
    80005398:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000539a:	00c52c83          	lw	s9,12(a0)
    8000539e:	001c9c9b          	sllw	s9,s9,0x1
    800053a2:	1c82                	sll	s9,s9,0x20
    800053a4:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053a8:	0001c517          	auipc	a0,0x1c
    800053ac:	c0050513          	add	a0,a0,-1024 # 80020fa8 <disk+0x128>
    800053b0:	ff0fb0ef          	jal	80000ba0 <acquire>
  for(int i = 0; i < 3; i++){
    800053b4:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800053b6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053b8:	0001cb17          	auipc	s6,0x1c
    800053bc:	ac8b0b13          	add	s6,s6,-1336 # 80020e80 <disk>
  for(int i = 0; i < 3; i++){
    800053c0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053c2:	0001cc17          	auipc	s8,0x1c
    800053c6:	be6c0c13          	add	s8,s8,-1050 # 80020fa8 <disk+0x128>
    800053ca:	a8b1                	j	80005426 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800053cc:	00fb0733          	add	a4,s6,a5
    800053d0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053d4:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800053d6:	0207c563          	bltz	a5,80005400 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    800053da:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800053dc:	0591                	add	a1,a1,4
    800053de:	05560963          	beq	a2,s5,80005430 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    800053e2:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800053e4:	0001c717          	auipc	a4,0x1c
    800053e8:	a9c70713          	add	a4,a4,-1380 # 80020e80 <disk>
    800053ec:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800053ee:	01874683          	lbu	a3,24(a4)
    800053f2:	fee9                	bnez	a3,800053cc <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800053f4:	2785                	addw	a5,a5,1
    800053f6:	0705                	add	a4,a4,1
    800053f8:	fe979be3          	bne	a5,s1,800053ee <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    800053fc:	57fd                	li	a5,-1
    800053fe:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005400:	00c05c63          	blez	a2,80005418 <virtio_disk_rw+0x9e>
    80005404:	060a                	sll	a2,a2,0x2
    80005406:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000540a:	0009a503          	lw	a0,0(s3)
    8000540e:	d41ff0ef          	jal	8000514e <free_desc>
      for(int j = 0; j < i; j++)
    80005412:	0991                	add	s3,s3,4
    80005414:	ffa99be3          	bne	s3,s10,8000540a <virtio_disk_rw+0x90>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005418:	85e2                	mv	a1,s8
    8000541a:	0001c517          	auipc	a0,0x1c
    8000541e:	a7e50513          	add	a0,a0,-1410 # 80020e98 <disk+0x18>
    80005422:	9e7fc0ef          	jal	80001e08 <sleep>
  for(int i = 0; i < 3; i++){
    80005426:	f9040993          	add	s3,s0,-112
{
    8000542a:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    8000542c:	864a                	mv	a2,s2
    8000542e:	bf55                	j	800053e2 <virtio_disk_rw+0x68>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005430:	f9042503          	lw	a0,-112(s0)
    80005434:	00a50713          	add	a4,a0,10
    80005438:	0712                	sll	a4,a4,0x4

  if(write)
    8000543a:	0001c797          	auipc	a5,0x1c
    8000543e:	a4678793          	add	a5,a5,-1466 # 80020e80 <disk>
    80005442:	00e786b3          	add	a3,a5,a4
    80005446:	01703633          	snez	a2,s7
    8000544a:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    8000544c:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005450:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005454:	f6070613          	add	a2,a4,-160
    80005458:	6394                	ld	a3,0(a5)
    8000545a:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000545c:	00870593          	add	a1,a4,8
    80005460:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005462:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005464:	0007b803          	ld	a6,0(a5)
    80005468:	9642                	add	a2,a2,a6
    8000546a:	46c1                	li	a3,16
    8000546c:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000546e:	4585                	li	a1,1
    80005470:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005474:	f9442683          	lw	a3,-108(s0)
    80005478:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000547c:	0692                	sll	a3,a3,0x4
    8000547e:	9836                	add	a6,a6,a3
    80005480:	058a0613          	add	a2,s4,88
    80005484:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005488:	0007b803          	ld	a6,0(a5)
    8000548c:	96c2                	add	a3,a3,a6
    8000548e:	40000613          	li	a2,1024
    80005492:	c690                	sw	a2,8(a3)
  if(write)
    80005494:	001bb613          	seqz	a2,s7
    80005498:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000549c:	00166613          	or	a2,a2,1
    800054a0:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054a4:	f9842603          	lw	a2,-104(s0)
    800054a8:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    800054ac:	00250693          	add	a3,a0,2
    800054b0:	0692                	sll	a3,a3,0x4
    800054b2:	96be                	add	a3,a3,a5
    800054b4:	58fd                	li	a7,-1
    800054b6:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054ba:	0612                	sll	a2,a2,0x4
    800054bc:	9832                	add	a6,a6,a2
    800054be:	f9070713          	add	a4,a4,-112
    800054c2:	973e                	add	a4,a4,a5
    800054c4:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800054c8:	6398                	ld	a4,0(a5)
    800054ca:	9732                	add	a4,a4,a2
    800054cc:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    800054ce:	4609                	li	a2,2
    800054d0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800054d4:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    800054d8:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800054dc:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054e0:	6794                	ld	a3,8(a5)
    800054e2:	0026d703          	lhu	a4,2(a3)
    800054e6:	8b1d                	and	a4,a4,7
    800054e8:	0706                	sll	a4,a4,0x1
    800054ea:	96ba                	add	a3,a3,a4
    800054ec:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800054f0:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    800054f4:	6798                	ld	a4,8(a5)
    800054f6:	00275783          	lhu	a5,2(a4)
    800054fa:	2785                	addw	a5,a5,1
    800054fc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005500:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    80005504:	100017b7          	lui	a5,0x10001
    80005508:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    8000550c:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005510:	0001c917          	auipc	s2,0x1c
    80005514:	a9890913          	add	s2,s2,-1384 # 80020fa8 <disk+0x128>
  while(b->disk == 1) {
    80005518:	4485                	li	s1,1
    8000551a:	00b79a63          	bne	a5,a1,8000552e <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    8000551e:	85ca                	mv	a1,s2
    80005520:	8552                	mv	a0,s4
    80005522:	8e7fc0ef          	jal	80001e08 <sleep>
  while(b->disk == 1) {
    80005526:	004a2783          	lw	a5,4(s4)
    8000552a:	fe978ae3          	beq	a5,s1,8000551e <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    8000552e:	f9042903          	lw	s2,-112(s0)
    80005532:	00290713          	add	a4,s2,2
    80005536:	0712                	sll	a4,a4,0x4
    80005538:	0001c797          	auipc	a5,0x1c
    8000553c:	94878793          	add	a5,a5,-1720 # 80020e80 <disk>
    80005540:	97ba                	add	a5,a5,a4
    80005542:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005546:	0001c997          	auipc	s3,0x1c
    8000554a:	93a98993          	add	s3,s3,-1734 # 80020e80 <disk>
    8000554e:	00491713          	sll	a4,s2,0x4
    80005552:	0009b783          	ld	a5,0(s3)
    80005556:	97ba                	add	a5,a5,a4
    80005558:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000555c:	854a                	mv	a0,s2
    8000555e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005562:	bedff0ef          	jal	8000514e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005566:	8885                	and	s1,s1,1
    80005568:	f0fd                	bnez	s1,8000554e <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000556a:	0001c517          	auipc	a0,0x1c
    8000556e:	a3e50513          	add	a0,a0,-1474 # 80020fa8 <disk+0x128>
    80005572:	ec6fb0ef          	jal	80000c38 <release>
}
    80005576:	70a6                	ld	ra,104(sp)
    80005578:	7406                	ld	s0,96(sp)
    8000557a:	64e6                	ld	s1,88(sp)
    8000557c:	6946                	ld	s2,80(sp)
    8000557e:	69a6                	ld	s3,72(sp)
    80005580:	6a06                	ld	s4,64(sp)
    80005582:	7ae2                	ld	s5,56(sp)
    80005584:	7b42                	ld	s6,48(sp)
    80005586:	7ba2                	ld	s7,40(sp)
    80005588:	7c02                	ld	s8,32(sp)
    8000558a:	6ce2                	ld	s9,24(sp)
    8000558c:	6d42                	ld	s10,16(sp)
    8000558e:	6165                	add	sp,sp,112
    80005590:	8082                	ret

0000000080005592 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005592:	1101                	add	sp,sp,-32
    80005594:	ec06                	sd	ra,24(sp)
    80005596:	e822                	sd	s0,16(sp)
    80005598:	e426                	sd	s1,8(sp)
    8000559a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000559c:	0001c497          	auipc	s1,0x1c
    800055a0:	8e448493          	add	s1,s1,-1820 # 80020e80 <disk>
    800055a4:	0001c517          	auipc	a0,0x1c
    800055a8:	a0450513          	add	a0,a0,-1532 # 80020fa8 <disk+0x128>
    800055ac:	df4fb0ef          	jal	80000ba0 <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055b0:	10001737          	lui	a4,0x10001
    800055b4:	533c                	lw	a5,96(a4)
    800055b6:	8b8d                	and	a5,a5,3
    800055b8:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055ba:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    800055be:	689c                	ld	a5,16(s1)
    800055c0:	0204d703          	lhu	a4,32(s1)
    800055c4:	0027d783          	lhu	a5,2(a5)
    800055c8:	04f70663          	beq	a4,a5,80005614 <virtio_disk_intr+0x82>
    __sync_synchronize();
    800055cc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055d0:	6898                	ld	a4,16(s1)
    800055d2:	0204d783          	lhu	a5,32(s1)
    800055d6:	8b9d                	and	a5,a5,7
    800055d8:	078e                	sll	a5,a5,0x3
    800055da:	97ba                	add	a5,a5,a4
    800055dc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055de:	00278713          	add	a4,a5,2
    800055e2:	0712                	sll	a4,a4,0x4
    800055e4:	9726                	add	a4,a4,s1
    800055e6:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800055ea:	e321                	bnez	a4,8000562a <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055ec:	0789                	add	a5,a5,2
    800055ee:	0792                	sll	a5,a5,0x4
    800055f0:	97a6                	add	a5,a5,s1
    800055f2:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    800055f4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055f8:	85dfc0ef          	jal	80001e54 <wakeup>

    disk.used_idx += 1;
    800055fc:	0204d783          	lhu	a5,32(s1)
    80005600:	2785                	addw	a5,a5,1
    80005602:	17c2                	sll	a5,a5,0x30
    80005604:	93c1                	srl	a5,a5,0x30
    80005606:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000560a:	6898                	ld	a4,16(s1)
    8000560c:	00275703          	lhu	a4,2(a4)
    80005610:	faf71ee3          	bne	a4,a5,800055cc <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80005614:	0001c517          	auipc	a0,0x1c
    80005618:	99450513          	add	a0,a0,-1644 # 80020fa8 <disk+0x128>
    8000561c:	e1cfb0ef          	jal	80000c38 <release>
}
    80005620:	60e2                	ld	ra,24(sp)
    80005622:	6442                	ld	s0,16(sp)
    80005624:	64a2                	ld	s1,8(sp)
    80005626:	6105                	add	sp,sp,32
    80005628:	8082                	ret
      panic("virtio_disk_intr status");
    8000562a:	00002517          	auipc	a0,0x2
    8000562e:	3b650513          	add	a0,a0,950 # 800079e0 <syscalls_names+0x3d8>
    80005632:	92cfb0ef          	jal	8000075e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	sll	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	sll	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
