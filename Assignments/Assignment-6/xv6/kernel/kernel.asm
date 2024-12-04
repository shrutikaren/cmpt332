
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	91010113          	add	sp,sp,-1776 # 80007910 <stack0>
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddd4f>
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
    800000fa:	0a8020ef          	jal	800021a2 <either_copyin>
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
    8000014c:	0000f517          	auipc	a0,0xf
    80000150:	7c450513          	add	a0,a0,1988 # 8000f910 <cons>
    80000154:	24d000ef          	jal	80000ba0 <acquire>
  while(n > 0){
    /* wait until interrupt handler has put some */
    /* input into cons.buffer. */
    while(cons.r == cons.w){
    80000158:	0000f497          	auipc	s1,0xf
    8000015c:	7b848493          	add	s1,s1,1976 # 8000f910 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000160:	00010917          	auipc	s2,0x10
    80000164:	84890913          	add	s2,s2,-1976 # 8000f9a8 <cons+0x98>
  while(n > 0){
    80000168:	07305a63          	blez	s3,800001dc <consoleread+0xb0>
    while(cons.r == cons.w){
    8000016c:	0984a783          	lw	a5,152(s1)
    80000170:	09c4a703          	lw	a4,156(s1)
    80000174:	02f71163          	bne	a4,a5,80000196 <consoleread+0x6a>
      if(killed(myproc())){
    80000178:	6b8010ef          	jal	80001830 <myproc>
    8000017c:	6b9010ef          	jal	80002034 <killed>
    80000180:	e53d                	bnez	a0,800001ee <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80000182:	85a6                	mv	a1,s1
    80000184:	854a                	mv	a0,s2
    80000186:	477010ef          	jal	80001dfc <sleep>
    while(cons.r == cons.w){
    8000018a:	0984a783          	lw	a5,152(s1)
    8000018e:	09c4a703          	lw	a4,156(s1)
    80000192:	fef703e3          	beq	a4,a5,80000178 <consoleread+0x4c>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000196:	0000f717          	auipc	a4,0xf
    8000019a:	77a70713          	add	a4,a4,1914 # 8000f910 <cons>
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
    800001c8:	791010ef          	jal	80002158 <either_copyout>
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
    800001dc:	0000f517          	auipc	a0,0xf
    800001e0:	73450513          	add	a0,a0,1844 # 8000f910 <cons>
    800001e4:	255000ef          	jal	80000c38 <release>

  return target - n;
    800001e8:	413b053b          	subw	a0,s6,s3
    800001ec:	a801                	j	800001fc <consoleread+0xd0>
        release(&cons.lock);
    800001ee:	0000f517          	auipc	a0,0xf
    800001f2:	72250513          	add	a0,a0,1826 # 8000f910 <cons>
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
    8000021a:	0000f717          	auipc	a4,0xf
    8000021e:	78f72723          	sw	a5,1934(a4) # 8000f9a8 <cons+0x98>
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
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	6ac50513          	add	a0,a0,1708 # 8000f910 <cons>
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
    80000286:	767010ef          	jal	800021ec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028a:	0000f517          	auipc	a0,0xf
    8000028e:	68650513          	add	a0,a0,1670 # 8000f910 <cons>
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
    800002ae:	66670713          	add	a4,a4,1638 # 8000f910 <cons>
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
    800002d4:	64078793          	add	a5,a5,1600 # 8000f910 <cons>
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
    800002fe:	0000f797          	auipc	a5,0xf
    80000302:	6aa7a783          	lw	a5,1706(a5) # 8000f9a8 <cons+0x98>
    80000306:	9f1d                	subw	a4,a4,a5
    80000308:	08000793          	li	a5,128
    8000030c:	f6f71fe3          	bne	a4,a5,8000028a <consoleintr+0x34>
    80000310:	a04d                	j	800003b2 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000312:	0000f717          	auipc	a4,0xf
    80000316:	5fe70713          	add	a4,a4,1534 # 8000f910 <cons>
    8000031a:	0a072783          	lw	a5,160(a4)
    8000031e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000322:	0000f497          	auipc	s1,0xf
    80000326:	5ee48493          	add	s1,s1,1518 # 8000f910 <cons>
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
    8000035e:	5b670713          	add	a4,a4,1462 # 8000f910 <cons>
    80000362:	0a072783          	lw	a5,160(a4)
    80000366:	09c72703          	lw	a4,156(a4)
    8000036a:	f2f700e3          	beq	a4,a5,8000028a <consoleintr+0x34>
      cons.e--;
    8000036e:	37fd                	addw	a5,a5,-1
    80000370:	0000f717          	auipc	a4,0xf
    80000374:	64f72023          	sw	a5,1600(a4) # 8000f9b0 <cons+0xa0>
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
    80000392:	58278793          	add	a5,a5,1410 # 8000f910 <cons>
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
    800003b6:	5ec7ad23          	sw	a2,1530(a5) # 8000f9ac <cons+0x9c>
        wakeup(&cons.r);
    800003ba:	0000f517          	auipc	a0,0xf
    800003be:	5ee50513          	add	a0,a0,1518 # 8000f9a8 <cons+0x98>
    800003c2:	287010ef          	jal	80001e48 <wakeup>
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
    800003dc:	53850513          	add	a0,a0,1336 # 8000f910 <cons>
    800003e0:	740000ef          	jal	80000b20 <initlock>

  uartinit();
    800003e4:	3e2000ef          	jal	800007c6 <uartinit>

  /* connect read and write system calls */
  /* to consoleread and consolewrite. */
  devsw[CONSOLE].read = consoleread;
    800003e8:	0001f797          	auipc	a5,0x1f
    800003ec:	53078793          	add	a5,a5,1328 # 8001f918 <devsw>
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
    800004d4:	5007a783          	lw	a5,1280(a5) # 8000f9d0 <pr+0x18>
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
    8000050e:	4ae50513          	add	a0,a0,1198 # 8000f9b8 <pr>
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
    80000528:	49450513          	add	a0,a0,1172 # 8000f9b8 <pr>
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
    8000076e:	2607a323          	sw	zero,614(a5) # 8000f9d0 <pr+0x18>
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
    80000792:	14f72123          	sw	a5,322(a4) # 800078d0 <panicked>
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
    800007a6:	21648493          	add	s1,s1,534 # 8000f9b8 <pr>
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
    80000802:	1da50513          	add	a0,a0,474 # 8000f9d8 <uart_tx_lock>
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
    80000826:	0ae7a783          	lw	a5,174(a5) # 800078d0 <panicked>
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
    8000085a:	0827b783          	ld	a5,130(a5) # 800078d8 <uart_tx_r>
    8000085e:	00007717          	auipc	a4,0x7
    80000862:	08273703          	ld	a4,130(a4) # 800078e0 <uart_tx_w>
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
    80000884:	158a0a13          	add	s4,s4,344 # 8000f9d8 <uart_tx_lock>
    uart_tx_r += 1;
    80000888:	00007497          	auipc	s1,0x7
    8000088c:	05048493          	add	s1,s1,80 # 800078d8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000890:	00007997          	auipc	s3,0x7
    80000894:	05098993          	add	s3,s3,80 # 800078e0 <uart_tx_w>
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
    800008b2:	596010ef          	jal	80001e48 <wakeup>
    
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
    800008fe:	0de50513          	add	a0,a0,222 # 8000f9d8 <uart_tx_lock>
    80000902:	29e000ef          	jal	80000ba0 <acquire>
  if(panicked){
    80000906:	00007797          	auipc	a5,0x7
    8000090a:	fca7a783          	lw	a5,-54(a5) # 800078d0 <panicked>
    8000090e:	efbd                	bnez	a5,8000098c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000910:	00007717          	auipc	a4,0x7
    80000914:	fd073703          	ld	a4,-48(a4) # 800078e0 <uart_tx_w>
    80000918:	00007797          	auipc	a5,0x7
    8000091c:	fc07b783          	ld	a5,-64(a5) # 800078d8 <uart_tx_r>
    80000920:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000924:	0000f997          	auipc	s3,0xf
    80000928:	0b498993          	add	s3,s3,180 # 8000f9d8 <uart_tx_lock>
    8000092c:	00007497          	auipc	s1,0x7
    80000930:	fac48493          	add	s1,s1,-84 # 800078d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000934:	00007917          	auipc	s2,0x7
    80000938:	fac90913          	add	s2,s2,-84 # 800078e0 <uart_tx_w>
    8000093c:	00e79d63          	bne	a5,a4,80000956 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000940:	85ce                	mv	a1,s3
    80000942:	8526                	mv	a0,s1
    80000944:	4b8010ef          	jal	80001dfc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	00093703          	ld	a4,0(s2)
    8000094c:	609c                	ld	a5,0(s1)
    8000094e:	02078793          	add	a5,a5,32
    80000952:	fee787e3          	beq	a5,a4,80000940 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000956:	0000f497          	auipc	s1,0xf
    8000095a:	08248493          	add	s1,s1,130 # 8000f9d8 <uart_tx_lock>
    8000095e:	01f77793          	and	a5,a4,31
    80000962:	97a6                	add	a5,a5,s1
    80000964:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000968:	0705                	add	a4,a4,1
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	f6e7bb23          	sd	a4,-138(a5) # 800078e0 <uart_tx_w>
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
    800009d0:	00c48493          	add	s1,s1,12 # 8000f9d8 <uart_tx_lock>
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
    80000a06:	0ae78793          	add	a5,a5,174 # 80020ab0 <end>
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
    80000a22:	ff290913          	add	s2,s2,-14 # 8000fa10 <kmem>
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
    80000ab0:	f6450513          	add	a0,a0,-156 # 8000fa10 <kmem>
    80000ab4:	06c000ef          	jal	80000b20 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab8:	45c5                	li	a1,17
    80000aba:	05ee                	sll	a1,a1,0x1b
    80000abc:	00020517          	auipc	a0,0x20
    80000ac0:	ff450513          	add	a0,a0,-12 # 80020ab0 <end>
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
    80000ade:	f3648493          	add	s1,s1,-202 # 8000fa10 <kmem>
    80000ae2:	8526                	mv	a0,s1
    80000ae4:	0bc000ef          	jal	80000ba0 <acquire>
  r = kmem.freelist;
    80000ae8:	6c84                	ld	s1,24(s1)
  if(r)
    80000aea:	c485                	beqz	s1,80000b12 <kalloc+0x42>
    kmem.freelist = r->next;
    80000aec:	609c                	ld	a5,0(s1)
    80000aee:	0000f517          	auipc	a0,0xf
    80000af2:	f2250513          	add	a0,a0,-222 # 8000fa10 <kmem>
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
    80000b16:	efe50513          	add	a0,a0,-258 # 8000fa10 <kmem>
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
    80000ce8:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde551>
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
    80000e24:	ac870713          	add	a4,a4,-1336 # 800078e8 <started>
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
    80000e4a:	4d4010ef          	jal	8000231e <trapinithart>
    plicinithart();   /* ask PLIC for device interrupts */
    80000e4e:	316040ef          	jal	80005164 <plicinithart>
  }

  scheduler();        
    80000e52:	611000ef          	jal	80001c62 <scheduler>
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
    80000e92:	468010ef          	jal	800022fa <trapinit>
    trapinithart();  /* install kernel trap vector */
    80000e96:	488010ef          	jal	8000231e <trapinithart>
    plicinit();      /* set up interrupt controller */
    80000e9a:	2b4040ef          	jal	8000514e <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80000e9e:	2c6040ef          	jal	80005164 <plicinithart>
    binit();         /* buffer cache */
    80000ea2:	2a7010ef          	jal	80002948 <binit>
    iinit();         /* inode table */
    80000ea6:	0ee020ef          	jal	80002f94 <iinit>
    fileinit();      /* file table */
    80000eaa:	6ed020ef          	jal	80003d96 <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80000eae:	3a6040ef          	jal	80005254 <virtio_disk_init>
    userinit();      /* first user process */
    80000eb2:	3e7000ef          	jal	80001a98 <userinit>
    __sync_synchronize();
    80000eb6:	0ff0000f          	fence
    started = 1;
    80000eba:	4785                	li	a5,1
    80000ebc:	00007717          	auipc	a4,0x7
    80000ec0:	a2f72623          	sw	a5,-1492(a4) # 800078e8 <started>
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
    80000ed4:	a207b783          	ld	a5,-1504(a5) # 800078f0 <kernel_pagetable>
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
    80000f42:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde547>
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
    8000115c:	00006797          	auipc	a5,0x6
    80001160:	78a7ba23          	sd	a0,1940(a5) # 800078f0 <kernel_pagetable>
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
    800016b6:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffde54f>
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
    800016e8:	0000e497          	auipc	s1,0xe
    800016ec:	77848493          	add	s1,s1,1912 # 8000fe60 <proc>
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
    80001706:	15ea0a13          	add	s4,s4,350 # 80015860 <tickslock>
    char *pa = kalloc();
    8000170a:	bc6ff0ef          	jal	80000ad0 <kalloc>
    8000170e:	862a                	mv	a2,a0
    if(pa == 0)
    80001710:	c121                	beqz	a0,80001750 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80001712:	416485b3          	sub	a1,s1,s6
    80001716:	858d                	sra	a1,a1,0x3
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
    80001734:	16848493          	add	s1,s1,360
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
    8000177c:	2b850513          	add	a0,a0,696 # 8000fa30 <pid_lock>
    80001780:	ba0ff0ef          	jal	80000b20 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001784:	00006597          	auipc	a1,0x6
    80001788:	a9c58593          	add	a1,a1,-1380 # 80007220 <digits+0x1e8>
    8000178c:	0000e517          	auipc	a0,0xe
    80001790:	2bc50513          	add	a0,a0,700 # 8000fa48 <wait_lock>
    80001794:	b8cff0ef          	jal	80000b20 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	0000e497          	auipc	s1,0xe
    8000179c:	6c848493          	add	s1,s1,1736 # 8000fe60 <proc>
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
    800017be:	0a698993          	add	s3,s3,166 # 80015860 <tickslock>
      initlock(&p->lock, "proc");
    800017c2:	85da                	mv	a1,s6
    800017c4:	8526                	mv	a0,s1
    800017c6:	b5aff0ef          	jal	80000b20 <initlock>
      p->state = UNUSED;
    800017ca:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017ce:	415487b3          	sub	a5,s1,s5
    800017d2:	878d                	sra	a5,a5,0x3
    800017d4:	000a3703          	ld	a4,0(s4)
    800017d8:	02e787b3          	mul	a5,a5,a4
    800017dc:	2785                	addw	a5,a5,1
    800017de:	00d7979b          	sllw	a5,a5,0xd
    800017e2:	40f907b3          	sub	a5,s2,a5
    800017e6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e8:	16848493          	add	s1,s1,360
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
    80001824:	24050513          	add	a0,a0,576 # 8000fa60 <cpus>
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
    80001848:	1ec70713          	add	a4,a4,492 # 8000fa30 <pid_lock>
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
    80001874:	0107a783          	lw	a5,16(a5) # 80007880 <first.1>
    80001878:	e799                	bnez	a5,80001886 <forkret+0x26>
    first = 0;
    /* ensure other cores see first=0. */
    __sync_synchronize();
  }

  usertrapret();
    8000187a:	2bd000ef          	jal	80002336 <usertrapret>
}
    8000187e:	60a2                	ld	ra,8(sp)
    80001880:	6402                	ld	s0,0(sp)
    80001882:	0141                	add	sp,sp,16
    80001884:	8082                	ret
    fsinit(ROOTDEV);
    80001886:	4505                	li	a0,1
    80001888:	6a0010ef          	jal	80002f28 <fsinit>
    first = 0;
    8000188c:	00006797          	auipc	a5,0x6
    80001890:	fe07aa23          	sw	zero,-12(a5) # 80007880 <first.1>
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
    800018aa:	18a90913          	add	s2,s2,394 # 8000fa30 <pid_lock>
    800018ae:	854a                	mv	a0,s2
    800018b0:	af0ff0ef          	jal	80000ba0 <acquire>
  pid = nextpid;
    800018b4:	00006797          	auipc	a5,0x6
    800018b8:	fd078793          	add	a5,a5,-48 # 80007884 <nextpid>
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
    8000190c:	05893683          	ld	a3,88(s2)
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
    800019ae:	6d28                	ld	a0,88(a0)
    800019b0:	c119                	beqz	a0,800019b6 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019b2:	83cff0ef          	jal	800009ee <kfree>
  p->trapframe = 0;
    800019b6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019ba:	68a8                	ld	a0,80(s1)
    800019bc:	c501                	beqz	a0,800019c4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019be:	64ac                	ld	a1,72(s1)
    800019c0:	f9dff0ef          	jal	8000195c <proc_freepagetable>
  p->pagetable = 0;
    800019c4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800019c8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800019cc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019d0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019d4:	14048c23          	sb	zero,344(s1)
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
    80001a02:	46248493          	add	s1,s1,1122 # 8000fe60 <proc>
    80001a06:	00014917          	auipc	s2,0x14
    80001a0a:	e5a90913          	add	s2,s2,-422 # 80015860 <tickslock>
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
    80001a1e:	16848493          	add	s1,s1,360
    80001a22:	ff2496e3          	bne	s1,s2,80001a0e <allocproc+0x1c>
  return 0;
    80001a26:	4481                	li	s1,0
    80001a28:	a089                	j	80001a6a <allocproc+0x78>
  p->pid = allocpid();
    80001a2a:	e71ff0ef          	jal	8000189a <allocpid>
    80001a2e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a30:	4785                	li	a5,1
    80001a32:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a34:	89cff0ef          	jal	80000ad0 <kalloc>
    80001a38:	892a                	mv	s2,a0
    80001a3a:	eca8                	sd	a0,88(s1)
    80001a3c:	cd15                	beqz	a0,80001a78 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001a3e:	8526                	mv	a0,s1
    80001a40:	e99ff0ef          	jal	800018d8 <proc_pagetable>
    80001a44:	892a                	mv	s2,a0
    80001a46:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a48:	c121                	beqz	a0,80001a88 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001a4a:	07000613          	li	a2,112
    80001a4e:	4581                	li	a1,0
    80001a50:	06048513          	add	a0,s1,96
    80001a54:	a20ff0ef          	jal	80000c74 <memset>
  p->context.ra = (uint64)forkret;
    80001a58:	00000797          	auipc	a5,0x0
    80001a5c:	e0878793          	add	a5,a5,-504 # 80001860 <forkret>
    80001a60:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a62:	60bc                	ld	a5,64(s1)
    80001a64:	6705                	lui	a4,0x1
    80001a66:	97ba                	add	a5,a5,a4
    80001a68:	f4bc                	sd	a5,104(s1)
}
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	60e2                	ld	ra,24(sp)
    80001a6e:	6442                	ld	s0,16(sp)
    80001a70:	64a2                	ld	s1,8(sp)
    80001a72:	6902                	ld	s2,0(sp)
    80001a74:	6105                	add	sp,sp,32
    80001a76:	8082                	ret
    freeproc(p);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	f29ff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a7e:	8526                	mv	a0,s1
    80001a80:	9b8ff0ef          	jal	80000c38 <release>
    return 0;
    80001a84:	84ca                	mv	s1,s2
    80001a86:	b7d5                	j	80001a6a <allocproc+0x78>
    freeproc(p);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	f19ff0ef          	jal	800019a2 <freeproc>
    release(&p->lock);
    80001a8e:	8526                	mv	a0,s1
    80001a90:	9a8ff0ef          	jal	80000c38 <release>
    return 0;
    80001a94:	84ca                	mv	s1,s2
    80001a96:	bfd1                	j	80001a6a <allocproc+0x78>

0000000080001a98 <userinit>:
{
    80001a98:	1101                	add	sp,sp,-32
    80001a9a:	ec06                	sd	ra,24(sp)
    80001a9c:	e822                	sd	s0,16(sp)
    80001a9e:	e426                	sd	s1,8(sp)
    80001aa0:	1000                	add	s0,sp,32
  p = allocproc();
    80001aa2:	f51ff0ef          	jal	800019f2 <allocproc>
    80001aa6:	84aa                	mv	s1,a0
  initproc = p;
    80001aa8:	00006797          	auipc	a5,0x6
    80001aac:	e4a7b823          	sd	a0,-432(a5) # 800078f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ab0:	03400613          	li	a2,52
    80001ab4:	00006597          	auipc	a1,0x6
    80001ab8:	ddc58593          	add	a1,a1,-548 # 80007890 <initcode>
    80001abc:	6928                	ld	a0,80(a0)
    80001abe:	f80ff0ef          	jal	8000123e <uvmfirst>
  p->sz = PGSIZE;
    80001ac2:	6785                	lui	a5,0x1
    80001ac4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      /* user program counter */
    80001ac6:	6cb8                	ld	a4,88(s1)
    80001ac8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  /* user stack pointer */
    80001acc:	6cb8                	ld	a4,88(s1)
    80001ace:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ad0:	4641                	li	a2,16
    80001ad2:	00005597          	auipc	a1,0x5
    80001ad6:	76658593          	add	a1,a1,1894 # 80007238 <digits+0x200>
    80001ada:	15848513          	add	a0,s1,344
    80001ade:	adaff0ef          	jal	80000db8 <safestrcpy>
  p->cwd = namei("/");
    80001ae2:	00005517          	auipc	a0,0x5
    80001ae6:	76650513          	add	a0,a0,1894 # 80007248 <digits+0x210>
    80001aea:	5a5010ef          	jal	8000388e <namei>
    80001aee:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001af2:	478d                	li	a5,3
    80001af4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001af6:	8526                	mv	a0,s1
    80001af8:	940ff0ef          	jal	80000c38 <release>
}
    80001afc:	60e2                	ld	ra,24(sp)
    80001afe:	6442                	ld	s0,16(sp)
    80001b00:	64a2                	ld	s1,8(sp)
    80001b02:	6105                	add	sp,sp,32
    80001b04:	8082                	ret

0000000080001b06 <growproc>:
{
    80001b06:	1101                	add	sp,sp,-32
    80001b08:	ec06                	sd	ra,24(sp)
    80001b0a:	e822                	sd	s0,16(sp)
    80001b0c:	e426                	sd	s1,8(sp)
    80001b0e:	e04a                	sd	s2,0(sp)
    80001b10:	1000                	add	s0,sp,32
    80001b12:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b14:	d1dff0ef          	jal	80001830 <myproc>
    80001b18:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b1a:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b1c:	01204c63          	bgtz	s2,80001b34 <growproc+0x2e>
  } else if(n < 0){
    80001b20:	02094463          	bltz	s2,80001b48 <growproc+0x42>
  p->sz = sz;
    80001b24:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b26:	4501                	li	a0,0
}
    80001b28:	60e2                	ld	ra,24(sp)
    80001b2a:	6442                	ld	s0,16(sp)
    80001b2c:	64a2                	ld	s1,8(sp)
    80001b2e:	6902                	ld	s2,0(sp)
    80001b30:	6105                	add	sp,sp,32
    80001b32:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b34:	4691                	li	a3,4
    80001b36:	00b90633          	add	a2,s2,a1
    80001b3a:	6928                	ld	a0,80(a0)
    80001b3c:	fa4ff0ef          	jal	800012e0 <uvmalloc>
    80001b40:	85aa                	mv	a1,a0
    80001b42:	f16d                	bnez	a0,80001b24 <growproc+0x1e>
      return -1;
    80001b44:	557d                	li	a0,-1
    80001b46:	b7cd                	j	80001b28 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b48:	00b90633          	add	a2,s2,a1
    80001b4c:	6928                	ld	a0,80(a0)
    80001b4e:	f4eff0ef          	jal	8000129c <uvmdealloc>
    80001b52:	85aa                	mv	a1,a0
    80001b54:	bfc1                	j	80001b24 <growproc+0x1e>

0000000080001b56 <fork>:
{
    80001b56:	7139                	add	sp,sp,-64
    80001b58:	fc06                	sd	ra,56(sp)
    80001b5a:	f822                	sd	s0,48(sp)
    80001b5c:	f426                	sd	s1,40(sp)
    80001b5e:	f04a                	sd	s2,32(sp)
    80001b60:	ec4e                	sd	s3,24(sp)
    80001b62:	e852                	sd	s4,16(sp)
    80001b64:	e456                	sd	s5,8(sp)
    80001b66:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001b68:	cc9ff0ef          	jal	80001830 <myproc>
    80001b6c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b6e:	e85ff0ef          	jal	800019f2 <allocproc>
    80001b72:	0e050663          	beqz	a0,80001c5e <fork+0x108>
    80001b76:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b78:	048ab603          	ld	a2,72(s5)
    80001b7c:	692c                	ld	a1,80(a0)
    80001b7e:	050ab503          	ld	a0,80(s5)
    80001b82:	88bff0ef          	jal	8000140c <uvmcopy>
    80001b86:	04054863          	bltz	a0,80001bd6 <fork+0x80>
  np->sz = p->sz;
    80001b8a:	048ab783          	ld	a5,72(s5)
    80001b8e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001b92:	058ab683          	ld	a3,88(s5)
    80001b96:	87b6                	mv	a5,a3
    80001b98:	058a3703          	ld	a4,88(s4)
    80001b9c:	12068693          	add	a3,a3,288
    80001ba0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ba4:	6788                	ld	a0,8(a5)
    80001ba6:	6b8c                	ld	a1,16(a5)
    80001ba8:	6f90                	ld	a2,24(a5)
    80001baa:	01073023          	sd	a6,0(a4)
    80001bae:	e708                	sd	a0,8(a4)
    80001bb0:	eb0c                	sd	a1,16(a4)
    80001bb2:	ef10                	sd	a2,24(a4)
    80001bb4:	02078793          	add	a5,a5,32
    80001bb8:	02070713          	add	a4,a4,32
    80001bbc:	fed792e3          	bne	a5,a3,80001ba0 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001bc0:	058a3783          	ld	a5,88(s4)
    80001bc4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bc8:	0d0a8493          	add	s1,s5,208
    80001bcc:	0d0a0913          	add	s2,s4,208
    80001bd0:	150a8993          	add	s3,s5,336
    80001bd4:	a829                	j	80001bee <fork+0x98>
    freeproc(np);
    80001bd6:	8552                	mv	a0,s4
    80001bd8:	dcbff0ef          	jal	800019a2 <freeproc>
    release(&np->lock);
    80001bdc:	8552                	mv	a0,s4
    80001bde:	85aff0ef          	jal	80000c38 <release>
    return -1;
    80001be2:	597d                	li	s2,-1
    80001be4:	a09d                	j	80001c4a <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001be6:	04a1                	add	s1,s1,8
    80001be8:	0921                	add	s2,s2,8
    80001bea:	01348963          	beq	s1,s3,80001bfc <fork+0xa6>
    if(p->ofile[i])
    80001bee:	6088                	ld	a0,0(s1)
    80001bf0:	d97d                	beqz	a0,80001be6 <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001bf2:	226020ef          	jal	80003e18 <filedup>
    80001bf6:	00a93023          	sd	a0,0(s2)
    80001bfa:	b7f5                	j	80001be6 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001bfc:	150ab503          	ld	a0,336(s5)
    80001c00:	51a010ef          	jal	8000311a <idup>
    80001c04:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c08:	4641                	li	a2,16
    80001c0a:	158a8593          	add	a1,s5,344
    80001c0e:	158a0513          	add	a0,s4,344
    80001c12:	9a6ff0ef          	jal	80000db8 <safestrcpy>
  pid = np->pid;
    80001c16:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001c1a:	8552                	mv	a0,s4
    80001c1c:	81cff0ef          	jal	80000c38 <release>
  acquire(&wait_lock);
    80001c20:	0000e497          	auipc	s1,0xe
    80001c24:	e2848493          	add	s1,s1,-472 # 8000fa48 <wait_lock>
    80001c28:	8526                	mv	a0,s1
    80001c2a:	f77fe0ef          	jal	80000ba0 <acquire>
  np->parent = p;
    80001c2e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001c32:	8526                	mv	a0,s1
    80001c34:	804ff0ef          	jal	80000c38 <release>
  acquire(&np->lock);
    80001c38:	8552                	mv	a0,s4
    80001c3a:	f67fe0ef          	jal	80000ba0 <acquire>
  np->state = RUNNABLE;
    80001c3e:	478d                	li	a5,3
    80001c40:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c44:	8552                	mv	a0,s4
    80001c46:	ff3fe0ef          	jal	80000c38 <release>
}
    80001c4a:	854a                	mv	a0,s2
    80001c4c:	70e2                	ld	ra,56(sp)
    80001c4e:	7442                	ld	s0,48(sp)
    80001c50:	74a2                	ld	s1,40(sp)
    80001c52:	7902                	ld	s2,32(sp)
    80001c54:	69e2                	ld	s3,24(sp)
    80001c56:	6a42                	ld	s4,16(sp)
    80001c58:	6aa2                	ld	s5,8(sp)
    80001c5a:	6121                	add	sp,sp,64
    80001c5c:	8082                	ret
    return -1;
    80001c5e:	597d                	li	s2,-1
    80001c60:	b7ed                	j	80001c4a <fork+0xf4>

0000000080001c62 <scheduler>:
{
    80001c62:	715d                	add	sp,sp,-80
    80001c64:	e486                	sd	ra,72(sp)
    80001c66:	e0a2                	sd	s0,64(sp)
    80001c68:	fc26                	sd	s1,56(sp)
    80001c6a:	f84a                	sd	s2,48(sp)
    80001c6c:	f44e                	sd	s3,40(sp)
    80001c6e:	f052                	sd	s4,32(sp)
    80001c70:	ec56                	sd	s5,24(sp)
    80001c72:	e85a                	sd	s6,16(sp)
    80001c74:	e45e                	sd	s7,8(sp)
    80001c76:	e062                	sd	s8,0(sp)
    80001c78:	0880                	add	s0,sp,80
    80001c7a:	8792                	mv	a5,tp
  int id = r_tp();
    80001c7c:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c7e:	00779b13          	sll	s6,a5,0x7
    80001c82:	0000e717          	auipc	a4,0xe
    80001c86:	dae70713          	add	a4,a4,-594 # 8000fa30 <pid_lock>
    80001c8a:	975a                	add	a4,a4,s6
    80001c8c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001c90:	0000e717          	auipc	a4,0xe
    80001c94:	dd870713          	add	a4,a4,-552 # 8000fa68 <cpus+0x8>
    80001c98:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001c9a:	4c11                	li	s8,4
        c->proc = p;
    80001c9c:	079e                	sll	a5,a5,0x7
    80001c9e:	0000ea17          	auipc	s4,0xe
    80001ca2:	d92a0a13          	add	s4,s4,-622 # 8000fa30 <pid_lock>
    80001ca6:	9a3e                	add	s4,s4,a5
        found = 1;
    80001ca8:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001caa:	00014997          	auipc	s3,0x14
    80001cae:	bb698993          	add	s3,s3,-1098 # 80015860 <tickslock>
    80001cb2:	a0a9                	j	80001cfc <scheduler+0x9a>
      release(&p->lock);
    80001cb4:	8526                	mv	a0,s1
    80001cb6:	f83fe0ef          	jal	80000c38 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cba:	16848493          	add	s1,s1,360
    80001cbe:	03348563          	beq	s1,s3,80001ce8 <scheduler+0x86>
      acquire(&p->lock);
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	eddfe0ef          	jal	80000ba0 <acquire>
      if(p->state == RUNNABLE) {
    80001cc8:	4c9c                	lw	a5,24(s1)
    80001cca:	ff2795e3          	bne	a5,s2,80001cb4 <scheduler+0x52>
        p->state = RUNNING;
    80001cce:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001cd2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001cd6:	06048593          	add	a1,s1,96
    80001cda:	855a                	mv	a0,s6
    80001cdc:	5b4000ef          	jal	80002290 <swtch>
        c->proc = 0;
    80001ce0:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001ce4:	8ade                	mv	s5,s7
    80001ce6:	b7f9                	j	80001cb4 <scheduler+0x52>
    if(found == 0) {
    80001ce8:	000a9a63          	bnez	s5,80001cfc <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cf0:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf4:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001cf8:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d00:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d04:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d08:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d0a:	0000e497          	auipc	s1,0xe
    80001d0e:	15648493          	add	s1,s1,342 # 8000fe60 <proc>
      if(p->state == RUNNABLE) {
    80001d12:	490d                	li	s2,3
    80001d14:	b77d                	j	80001cc2 <scheduler+0x60>

0000000080001d16 <sched>:
{
    80001d16:	7179                	add	sp,sp,-48
    80001d18:	f406                	sd	ra,40(sp)
    80001d1a:	f022                	sd	s0,32(sp)
    80001d1c:	ec26                	sd	s1,24(sp)
    80001d1e:	e84a                	sd	s2,16(sp)
    80001d20:	e44e                	sd	s3,8(sp)
    80001d22:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001d24:	b0dff0ef          	jal	80001830 <myproc>
    80001d28:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d2a:	e0dfe0ef          	jal	80000b36 <holding>
    80001d2e:	c92d                	beqz	a0,80001da0 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d30:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d32:	2781                	sext.w	a5,a5
    80001d34:	079e                	sll	a5,a5,0x7
    80001d36:	0000e717          	auipc	a4,0xe
    80001d3a:	cfa70713          	add	a4,a4,-774 # 8000fa30 <pid_lock>
    80001d3e:	97ba                	add	a5,a5,a4
    80001d40:	0a87a703          	lw	a4,168(a5)
    80001d44:	4785                	li	a5,1
    80001d46:	06f71363          	bne	a4,a5,80001dac <sched+0x96>
  if(p->state == RUNNING)
    80001d4a:	4c98                	lw	a4,24(s1)
    80001d4c:	4791                	li	a5,4
    80001d4e:	06f70563          	beq	a4,a5,80001db8 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d56:	8b89                	and	a5,a5,2
  if(intr_get())
    80001d58:	e7b5                	bnez	a5,80001dc4 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d5a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d5c:	0000e917          	auipc	s2,0xe
    80001d60:	cd490913          	add	s2,s2,-812 # 8000fa30 <pid_lock>
    80001d64:	2781                	sext.w	a5,a5
    80001d66:	079e                	sll	a5,a5,0x7
    80001d68:	97ca                	add	a5,a5,s2
    80001d6a:	0ac7a983          	lw	s3,172(a5)
    80001d6e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d70:	2781                	sext.w	a5,a5
    80001d72:	079e                	sll	a5,a5,0x7
    80001d74:	0000e597          	auipc	a1,0xe
    80001d78:	cf458593          	add	a1,a1,-780 # 8000fa68 <cpus+0x8>
    80001d7c:	95be                	add	a1,a1,a5
    80001d7e:	06048513          	add	a0,s1,96
    80001d82:	50e000ef          	jal	80002290 <swtch>
    80001d86:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001d88:	2781                	sext.w	a5,a5
    80001d8a:	079e                	sll	a5,a5,0x7
    80001d8c:	993e                	add	s2,s2,a5
    80001d8e:	0b392623          	sw	s3,172(s2)
}
    80001d92:	70a2                	ld	ra,40(sp)
    80001d94:	7402                	ld	s0,32(sp)
    80001d96:	64e2                	ld	s1,24(sp)
    80001d98:	6942                	ld	s2,16(sp)
    80001d9a:	69a2                	ld	s3,8(sp)
    80001d9c:	6145                	add	sp,sp,48
    80001d9e:	8082                	ret
    panic("sched p->lock");
    80001da0:	00005517          	auipc	a0,0x5
    80001da4:	4b050513          	add	a0,a0,1200 # 80007250 <digits+0x218>
    80001da8:	9b7fe0ef          	jal	8000075e <panic>
    panic("sched locks");
    80001dac:	00005517          	auipc	a0,0x5
    80001db0:	4b450513          	add	a0,a0,1204 # 80007260 <digits+0x228>
    80001db4:	9abfe0ef          	jal	8000075e <panic>
    panic("sched running");
    80001db8:	00005517          	auipc	a0,0x5
    80001dbc:	4b850513          	add	a0,a0,1208 # 80007270 <digits+0x238>
    80001dc0:	99ffe0ef          	jal	8000075e <panic>
    panic("sched interruptible");
    80001dc4:	00005517          	auipc	a0,0x5
    80001dc8:	4bc50513          	add	a0,a0,1212 # 80007280 <digits+0x248>
    80001dcc:	993fe0ef          	jal	8000075e <panic>

0000000080001dd0 <yield>:
{
    80001dd0:	1101                	add	sp,sp,-32
    80001dd2:	ec06                	sd	ra,24(sp)
    80001dd4:	e822                	sd	s0,16(sp)
    80001dd6:	e426                	sd	s1,8(sp)
    80001dd8:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001dda:	a57ff0ef          	jal	80001830 <myproc>
    80001dde:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001de0:	dc1fe0ef          	jal	80000ba0 <acquire>
  p->state = RUNNABLE;
    80001de4:	478d                	li	a5,3
    80001de6:	cc9c                	sw	a5,24(s1)
  sched();
    80001de8:	f2fff0ef          	jal	80001d16 <sched>
  release(&p->lock);
    80001dec:	8526                	mv	a0,s1
    80001dee:	e4bfe0ef          	jal	80000c38 <release>
}
    80001df2:	60e2                	ld	ra,24(sp)
    80001df4:	6442                	ld	s0,16(sp)
    80001df6:	64a2                	ld	s1,8(sp)
    80001df8:	6105                	add	sp,sp,32
    80001dfa:	8082                	ret

0000000080001dfc <sleep>:

/* Atomically release lock and sleep on chan. */
/* Reacquires lock when awakened. */
void
sleep(void *chan, struct spinlock *lk)
{
    80001dfc:	7179                	add	sp,sp,-48
    80001dfe:	f406                	sd	ra,40(sp)
    80001e00:	f022                	sd	s0,32(sp)
    80001e02:	ec26                	sd	s1,24(sp)
    80001e04:	e84a                	sd	s2,16(sp)
    80001e06:	e44e                	sd	s3,8(sp)
    80001e08:	1800                	add	s0,sp,48
    80001e0a:	89aa                	mv	s3,a0
    80001e0c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e0e:	a23ff0ef          	jal	80001830 <myproc>
    80001e12:	84aa                	mv	s1,a0
  /* Once we hold p->lock, we can be */
  /* guaranteed that we won't miss any wakeup */
  /* (wakeup locks p->lock), */
  /* so it's okay to release lk. */

  acquire(&p->lock);  /*DOC: sleeplock1 */
    80001e14:	d8dfe0ef          	jal	80000ba0 <acquire>
  release(lk);
    80001e18:	854a                	mv	a0,s2
    80001e1a:	e1ffe0ef          	jal	80000c38 <release>

  /* Go to sleep. */
  p->chan = chan;
    80001e1e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e22:	4789                	li	a5,2
    80001e24:	cc9c                	sw	a5,24(s1)

  sched();
    80001e26:	ef1ff0ef          	jal	80001d16 <sched>

  /* Tidy up. */
  p->chan = 0;
    80001e2a:	0204b023          	sd	zero,32(s1)

  /* Reacquire original lock. */
  release(&p->lock);
    80001e2e:	8526                	mv	a0,s1
    80001e30:	e09fe0ef          	jal	80000c38 <release>
  acquire(lk);
    80001e34:	854a                	mv	a0,s2
    80001e36:	d6bfe0ef          	jal	80000ba0 <acquire>
}
    80001e3a:	70a2                	ld	ra,40(sp)
    80001e3c:	7402                	ld	s0,32(sp)
    80001e3e:	64e2                	ld	s1,24(sp)
    80001e40:	6942                	ld	s2,16(sp)
    80001e42:	69a2                	ld	s3,8(sp)
    80001e44:	6145                	add	sp,sp,48
    80001e46:	8082                	ret

0000000080001e48 <wakeup>:

/* Wake up all processes sleeping on chan. */
/* Must be called without any p->lock. */
void
wakeup(void *chan)
{
    80001e48:	7139                	add	sp,sp,-64
    80001e4a:	fc06                	sd	ra,56(sp)
    80001e4c:	f822                	sd	s0,48(sp)
    80001e4e:	f426                	sd	s1,40(sp)
    80001e50:	f04a                	sd	s2,32(sp)
    80001e52:	ec4e                	sd	s3,24(sp)
    80001e54:	e852                	sd	s4,16(sp)
    80001e56:	e456                	sd	s5,8(sp)
    80001e58:	0080                	add	s0,sp,64
    80001e5a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e5c:	0000e497          	auipc	s1,0xe
    80001e60:	00448493          	add	s1,s1,4 # 8000fe60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e64:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e66:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e68:	00014917          	auipc	s2,0x14
    80001e6c:	9f890913          	add	s2,s2,-1544 # 80015860 <tickslock>
    80001e70:	a801                	j	80001e80 <wakeup+0x38>
      }
      release(&p->lock);
    80001e72:	8526                	mv	a0,s1
    80001e74:	dc5fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e78:	16848493          	add	s1,s1,360
    80001e7c:	03248263          	beq	s1,s2,80001ea0 <wakeup+0x58>
    if(p != myproc()){
    80001e80:	9b1ff0ef          	jal	80001830 <myproc>
    80001e84:	fea48ae3          	beq	s1,a0,80001e78 <wakeup+0x30>
      acquire(&p->lock);
    80001e88:	8526                	mv	a0,s1
    80001e8a:	d17fe0ef          	jal	80000ba0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001e8e:	4c9c                	lw	a5,24(s1)
    80001e90:	ff3791e3          	bne	a5,s3,80001e72 <wakeup+0x2a>
    80001e94:	709c                	ld	a5,32(s1)
    80001e96:	fd479ee3          	bne	a5,s4,80001e72 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001e9a:	0154ac23          	sw	s5,24(s1)
    80001e9e:	bfd1                	j	80001e72 <wakeup+0x2a>
    }
  }
}
    80001ea0:	70e2                	ld	ra,56(sp)
    80001ea2:	7442                	ld	s0,48(sp)
    80001ea4:	74a2                	ld	s1,40(sp)
    80001ea6:	7902                	ld	s2,32(sp)
    80001ea8:	69e2                	ld	s3,24(sp)
    80001eaa:	6a42                	ld	s4,16(sp)
    80001eac:	6aa2                	ld	s5,8(sp)
    80001eae:	6121                	add	sp,sp,64
    80001eb0:	8082                	ret

0000000080001eb2 <reparent>:
{
    80001eb2:	7179                	add	sp,sp,-48
    80001eb4:	f406                	sd	ra,40(sp)
    80001eb6:	f022                	sd	s0,32(sp)
    80001eb8:	ec26                	sd	s1,24(sp)
    80001eba:	e84a                	sd	s2,16(sp)
    80001ebc:	e44e                	sd	s3,8(sp)
    80001ebe:	e052                	sd	s4,0(sp)
    80001ec0:	1800                	add	s0,sp,48
    80001ec2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ec4:	0000e497          	auipc	s1,0xe
    80001ec8:	f9c48493          	add	s1,s1,-100 # 8000fe60 <proc>
      pp->parent = initproc;
    80001ecc:	00006a17          	auipc	s4,0x6
    80001ed0:	a2ca0a13          	add	s4,s4,-1492 # 800078f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ed4:	00014997          	auipc	s3,0x14
    80001ed8:	98c98993          	add	s3,s3,-1652 # 80015860 <tickslock>
    80001edc:	a029                	j	80001ee6 <reparent+0x34>
    80001ede:	16848493          	add	s1,s1,360
    80001ee2:	01348b63          	beq	s1,s3,80001ef8 <reparent+0x46>
    if(pp->parent == p){
    80001ee6:	7c9c                	ld	a5,56(s1)
    80001ee8:	ff279be3          	bne	a5,s2,80001ede <reparent+0x2c>
      pp->parent = initproc;
    80001eec:	000a3503          	ld	a0,0(s4)
    80001ef0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001ef2:	f57ff0ef          	jal	80001e48 <wakeup>
    80001ef6:	b7e5                	j	80001ede <reparent+0x2c>
}
    80001ef8:	70a2                	ld	ra,40(sp)
    80001efa:	7402                	ld	s0,32(sp)
    80001efc:	64e2                	ld	s1,24(sp)
    80001efe:	6942                	ld	s2,16(sp)
    80001f00:	69a2                	ld	s3,8(sp)
    80001f02:	6a02                	ld	s4,0(sp)
    80001f04:	6145                	add	sp,sp,48
    80001f06:	8082                	ret

0000000080001f08 <exit>:
{
    80001f08:	7179                	add	sp,sp,-48
    80001f0a:	f406                	sd	ra,40(sp)
    80001f0c:	f022                	sd	s0,32(sp)
    80001f0e:	ec26                	sd	s1,24(sp)
    80001f10:	e84a                	sd	s2,16(sp)
    80001f12:	e44e                	sd	s3,8(sp)
    80001f14:	e052                	sd	s4,0(sp)
    80001f16:	1800                	add	s0,sp,48
    80001f18:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f1a:	917ff0ef          	jal	80001830 <myproc>
    80001f1e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f20:	00006797          	auipc	a5,0x6
    80001f24:	9d87b783          	ld	a5,-1576(a5) # 800078f8 <initproc>
    80001f28:	0d050493          	add	s1,a0,208
    80001f2c:	15050913          	add	s2,a0,336
    80001f30:	00a79f63          	bne	a5,a0,80001f4e <exit+0x46>
    panic("init exiting");
    80001f34:	00005517          	auipc	a0,0x5
    80001f38:	36450513          	add	a0,a0,868 # 80007298 <digits+0x260>
    80001f3c:	823fe0ef          	jal	8000075e <panic>
      fileclose(f);
    80001f40:	71f010ef          	jal	80003e5e <fileclose>
      p->ofile[fd] = 0;
    80001f44:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f48:	04a1                	add	s1,s1,8
    80001f4a:	01248563          	beq	s1,s2,80001f54 <exit+0x4c>
    if(p->ofile[fd]){
    80001f4e:	6088                	ld	a0,0(s1)
    80001f50:	f965                	bnez	a0,80001f40 <exit+0x38>
    80001f52:	bfdd                	j	80001f48 <exit+0x40>
  begin_op();
    80001f54:	2f7010ef          	jal	80003a4a <begin_op>
  iput(p->cwd);
    80001f58:	1509b503          	ld	a0,336(s3)
    80001f5c:	3fc010ef          	jal	80003358 <iput>
  end_op();
    80001f60:	355010ef          	jal	80003ab4 <end_op>
  p->cwd = 0;
    80001f64:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001f68:	0000e497          	auipc	s1,0xe
    80001f6c:	ae048493          	add	s1,s1,-1312 # 8000fa48 <wait_lock>
    80001f70:	8526                	mv	a0,s1
    80001f72:	c2ffe0ef          	jal	80000ba0 <acquire>
  reparent(p);
    80001f76:	854e                	mv	a0,s3
    80001f78:	f3bff0ef          	jal	80001eb2 <reparent>
  wakeup(p->parent);
    80001f7c:	0389b503          	ld	a0,56(s3)
    80001f80:	ec9ff0ef          	jal	80001e48 <wakeup>
  acquire(&p->lock);
    80001f84:	854e                	mv	a0,s3
    80001f86:	c1bfe0ef          	jal	80000ba0 <acquire>
  p->xstate = status;
    80001f8a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001f8e:	4795                	li	a5,5
    80001f90:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001f94:	8526                	mv	a0,s1
    80001f96:	ca3fe0ef          	jal	80000c38 <release>
  sched();
    80001f9a:	d7dff0ef          	jal	80001d16 <sched>
  panic("zombie exit");
    80001f9e:	00005517          	auipc	a0,0x5
    80001fa2:	30a50513          	add	a0,a0,778 # 800072a8 <digits+0x270>
    80001fa6:	fb8fe0ef          	jal	8000075e <panic>

0000000080001faa <kill>:
/* Kill the process with the given pid. */
/* The victim won't exit until it tries to return */
/* to user space (see usertrap() in trap.c). */
int
kill(int pid)
{
    80001faa:	7179                	add	sp,sp,-48
    80001fac:	f406                	sd	ra,40(sp)
    80001fae:	f022                	sd	s0,32(sp)
    80001fb0:	ec26                	sd	s1,24(sp)
    80001fb2:	e84a                	sd	s2,16(sp)
    80001fb4:	e44e                	sd	s3,8(sp)
    80001fb6:	1800                	add	s0,sp,48
    80001fb8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001fba:	0000e497          	auipc	s1,0xe
    80001fbe:	ea648493          	add	s1,s1,-346 # 8000fe60 <proc>
    80001fc2:	00014997          	auipc	s3,0x14
    80001fc6:	89e98993          	add	s3,s3,-1890 # 80015860 <tickslock>
    acquire(&p->lock);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	bd5fe0ef          	jal	80000ba0 <acquire>
    if(p->pid == pid){
    80001fd0:	589c                	lw	a5,48(s1)
    80001fd2:	01278b63          	beq	a5,s2,80001fe8 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	c61fe0ef          	jal	80000c38 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001fdc:	16848493          	add	s1,s1,360
    80001fe0:	ff3495e3          	bne	s1,s3,80001fca <kill+0x20>
  }
  return -1;
    80001fe4:	557d                	li	a0,-1
    80001fe6:	a819                	j	80001ffc <kill+0x52>
      p->killed = 1;
    80001fe8:	4785                	li	a5,1
    80001fea:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001fec:	4c98                	lw	a4,24(s1)
    80001fee:	4789                	li	a5,2
    80001ff0:	00f70d63          	beq	a4,a5,8000200a <kill+0x60>
      release(&p->lock);
    80001ff4:	8526                	mv	a0,s1
    80001ff6:	c43fe0ef          	jal	80000c38 <release>
      return 0;
    80001ffa:	4501                	li	a0,0
}
    80001ffc:	70a2                	ld	ra,40(sp)
    80001ffe:	7402                	ld	s0,32(sp)
    80002000:	64e2                	ld	s1,24(sp)
    80002002:	6942                	ld	s2,16(sp)
    80002004:	69a2                	ld	s3,8(sp)
    80002006:	6145                	add	sp,sp,48
    80002008:	8082                	ret
        p->state = RUNNABLE;
    8000200a:	478d                	li	a5,3
    8000200c:	cc9c                	sw	a5,24(s1)
    8000200e:	b7dd                	j	80001ff4 <kill+0x4a>

0000000080002010 <setkilled>:

void
setkilled(struct proc *p)
{
    80002010:	1101                	add	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	1000                	add	s0,sp,32
    8000201a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000201c:	b85fe0ef          	jal	80000ba0 <acquire>
  p->killed = 1;
    80002020:	4785                	li	a5,1
    80002022:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002024:	8526                	mv	a0,s1
    80002026:	c13fe0ef          	jal	80000c38 <release>
}
    8000202a:	60e2                	ld	ra,24(sp)
    8000202c:	6442                	ld	s0,16(sp)
    8000202e:	64a2                	ld	s1,8(sp)
    80002030:	6105                	add	sp,sp,32
    80002032:	8082                	ret

0000000080002034 <killed>:

int
killed(struct proc *p)
{
    80002034:	1101                	add	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	e04a                	sd	s2,0(sp)
    8000203e:	1000                	add	s0,sp,32
    80002040:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002042:	b5ffe0ef          	jal	80000ba0 <acquire>
  k = p->killed;
    80002046:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000204a:	8526                	mv	a0,s1
    8000204c:	bedfe0ef          	jal	80000c38 <release>
  return k;
}
    80002050:	854a                	mv	a0,s2
    80002052:	60e2                	ld	ra,24(sp)
    80002054:	6442                	ld	s0,16(sp)
    80002056:	64a2                	ld	s1,8(sp)
    80002058:	6902                	ld	s2,0(sp)
    8000205a:	6105                	add	sp,sp,32
    8000205c:	8082                	ret

000000008000205e <wait>:
{
    8000205e:	715d                	add	sp,sp,-80
    80002060:	e486                	sd	ra,72(sp)
    80002062:	e0a2                	sd	s0,64(sp)
    80002064:	fc26                	sd	s1,56(sp)
    80002066:	f84a                	sd	s2,48(sp)
    80002068:	f44e                	sd	s3,40(sp)
    8000206a:	f052                	sd	s4,32(sp)
    8000206c:	ec56                	sd	s5,24(sp)
    8000206e:	e85a                	sd	s6,16(sp)
    80002070:	e45e                	sd	s7,8(sp)
    80002072:	e062                	sd	s8,0(sp)
    80002074:	0880                	add	s0,sp,80
    80002076:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002078:	fb8ff0ef          	jal	80001830 <myproc>
    8000207c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000207e:	0000e517          	auipc	a0,0xe
    80002082:	9ca50513          	add	a0,a0,-1590 # 8000fa48 <wait_lock>
    80002086:	b1bfe0ef          	jal	80000ba0 <acquire>
    havekids = 0;
    8000208a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000208c:	4a15                	li	s4,5
        havekids = 1;
    8000208e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002090:	00013997          	auipc	s3,0x13
    80002094:	7d098993          	add	s3,s3,2000 # 80015860 <tickslock>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    80002098:	0000ec17          	auipc	s8,0xe
    8000209c:	9b0c0c13          	add	s8,s8,-1616 # 8000fa48 <wait_lock>
    800020a0:	a871                	j	8000213c <wait+0xde>
          pid = pp->pid;
    800020a2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020a6:	000b0c63          	beqz	s6,800020be <wait+0x60>
    800020aa:	4691                	li	a3,4
    800020ac:	02c48613          	add	a2,s1,44
    800020b0:	85da                	mv	a1,s6
    800020b2:	05093503          	ld	a0,80(s2)
    800020b6:	c32ff0ef          	jal	800014e8 <copyout>
    800020ba:	02054b63          	bltz	a0,800020f0 <wait+0x92>
          freeproc(pp);
    800020be:	8526                	mv	a0,s1
    800020c0:	8e3ff0ef          	jal	800019a2 <freeproc>
          release(&pp->lock);
    800020c4:	8526                	mv	a0,s1
    800020c6:	b73fe0ef          	jal	80000c38 <release>
          release(&wait_lock);
    800020ca:	0000e517          	auipc	a0,0xe
    800020ce:	97e50513          	add	a0,a0,-1666 # 8000fa48 <wait_lock>
    800020d2:	b67fe0ef          	jal	80000c38 <release>
}
    800020d6:	854e                	mv	a0,s3
    800020d8:	60a6                	ld	ra,72(sp)
    800020da:	6406                	ld	s0,64(sp)
    800020dc:	74e2                	ld	s1,56(sp)
    800020de:	7942                	ld	s2,48(sp)
    800020e0:	79a2                	ld	s3,40(sp)
    800020e2:	7a02                	ld	s4,32(sp)
    800020e4:	6ae2                	ld	s5,24(sp)
    800020e6:	6b42                	ld	s6,16(sp)
    800020e8:	6ba2                	ld	s7,8(sp)
    800020ea:	6c02                	ld	s8,0(sp)
    800020ec:	6161                	add	sp,sp,80
    800020ee:	8082                	ret
            release(&pp->lock);
    800020f0:	8526                	mv	a0,s1
    800020f2:	b47fe0ef          	jal	80000c38 <release>
            release(&wait_lock);
    800020f6:	0000e517          	auipc	a0,0xe
    800020fa:	95250513          	add	a0,a0,-1710 # 8000fa48 <wait_lock>
    800020fe:	b3bfe0ef          	jal	80000c38 <release>
            return -1;
    80002102:	59fd                	li	s3,-1
    80002104:	bfc9                	j	800020d6 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002106:	16848493          	add	s1,s1,360
    8000210a:	03348063          	beq	s1,s3,8000212a <wait+0xcc>
      if(pp->parent == p){
    8000210e:	7c9c                	ld	a5,56(s1)
    80002110:	ff279be3          	bne	a5,s2,80002106 <wait+0xa8>
        acquire(&pp->lock);
    80002114:	8526                	mv	a0,s1
    80002116:	a8bfe0ef          	jal	80000ba0 <acquire>
        if(pp->state == ZOMBIE){
    8000211a:	4c9c                	lw	a5,24(s1)
    8000211c:	f94783e3          	beq	a5,s4,800020a2 <wait+0x44>
        release(&pp->lock);
    80002120:	8526                	mv	a0,s1
    80002122:	b17fe0ef          	jal	80000c38 <release>
        havekids = 1;
    80002126:	8756                	mv	a4,s5
    80002128:	bff9                	j	80002106 <wait+0xa8>
    if(!havekids || killed(p)){
    8000212a:	cf19                	beqz	a4,80002148 <wait+0xea>
    8000212c:	854a                	mv	a0,s2
    8000212e:	f07ff0ef          	jal	80002034 <killed>
    80002132:	e919                	bnez	a0,80002148 <wait+0xea>
    sleep(p, &wait_lock);  /*DOC: wait-sleep */
    80002134:	85e2                	mv	a1,s8
    80002136:	854a                	mv	a0,s2
    80002138:	cc5ff0ef          	jal	80001dfc <sleep>
    havekids = 0;
    8000213c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000213e:	0000e497          	auipc	s1,0xe
    80002142:	d2248493          	add	s1,s1,-734 # 8000fe60 <proc>
    80002146:	b7e1                	j	8000210e <wait+0xb0>
      release(&wait_lock);
    80002148:	0000e517          	auipc	a0,0xe
    8000214c:	90050513          	add	a0,a0,-1792 # 8000fa48 <wait_lock>
    80002150:	ae9fe0ef          	jal	80000c38 <release>
      return -1;
    80002154:	59fd                	li	s3,-1
    80002156:	b741                	j	800020d6 <wait+0x78>

0000000080002158 <either_copyout>:
/* Copy to either a user address, or kernel address, */
/* depending on usr_dst. */
/* Returns 0 on success, -1 on error. */
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002158:	7179                	add	sp,sp,-48
    8000215a:	f406                	sd	ra,40(sp)
    8000215c:	f022                	sd	s0,32(sp)
    8000215e:	ec26                	sd	s1,24(sp)
    80002160:	e84a                	sd	s2,16(sp)
    80002162:	e44e                	sd	s3,8(sp)
    80002164:	e052                	sd	s4,0(sp)
    80002166:	1800                	add	s0,sp,48
    80002168:	84aa                	mv	s1,a0
    8000216a:	892e                	mv	s2,a1
    8000216c:	89b2                	mv	s3,a2
    8000216e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002170:	ec0ff0ef          	jal	80001830 <myproc>
  if(user_dst){
    80002174:	cc99                	beqz	s1,80002192 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002176:	86d2                	mv	a3,s4
    80002178:	864e                	mv	a2,s3
    8000217a:	85ca                	mv	a1,s2
    8000217c:	6928                	ld	a0,80(a0)
    8000217e:	b6aff0ef          	jal	800014e8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	64e2                	ld	s1,24(sp)
    80002188:	6942                	ld	s2,16(sp)
    8000218a:	69a2                	ld	s3,8(sp)
    8000218c:	6a02                	ld	s4,0(sp)
    8000218e:	6145                	add	sp,sp,48
    80002190:	8082                	ret
    memmove((char *)dst, src, len);
    80002192:	000a061b          	sext.w	a2,s4
    80002196:	85ce                	mv	a1,s3
    80002198:	854a                	mv	a0,s2
    8000219a:	b37fe0ef          	jal	80000cd0 <memmove>
    return 0;
    8000219e:	8526                	mv	a0,s1
    800021a0:	b7cd                	j	80002182 <either_copyout+0x2a>

00000000800021a2 <either_copyin>:
/* Copy from either a user address, or kernel address, */
/* depending on usr_src. */
/* Returns 0 on success, -1 on error. */
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800021a2:	7179                	add	sp,sp,-48
    800021a4:	f406                	sd	ra,40(sp)
    800021a6:	f022                	sd	s0,32(sp)
    800021a8:	ec26                	sd	s1,24(sp)
    800021aa:	e84a                	sd	s2,16(sp)
    800021ac:	e44e                	sd	s3,8(sp)
    800021ae:	e052                	sd	s4,0(sp)
    800021b0:	1800                	add	s0,sp,48
    800021b2:	892a                	mv	s2,a0
    800021b4:	84ae                	mv	s1,a1
    800021b6:	89b2                	mv	s3,a2
    800021b8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021ba:	e76ff0ef          	jal	80001830 <myproc>
  if(user_src){
    800021be:	cc99                	beqz	s1,800021dc <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021c0:	86d2                	mv	a3,s4
    800021c2:	864e                	mv	a2,s3
    800021c4:	85ca                	mv	a1,s2
    800021c6:	6928                	ld	a0,80(a0)
    800021c8:	bd8ff0ef          	jal	800015a0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800021cc:	70a2                	ld	ra,40(sp)
    800021ce:	7402                	ld	s0,32(sp)
    800021d0:	64e2                	ld	s1,24(sp)
    800021d2:	6942                	ld	s2,16(sp)
    800021d4:	69a2                	ld	s3,8(sp)
    800021d6:	6a02                	ld	s4,0(sp)
    800021d8:	6145                	add	sp,sp,48
    800021da:	8082                	ret
    memmove(dst, (char*)src, len);
    800021dc:	000a061b          	sext.w	a2,s4
    800021e0:	85ce                	mv	a1,s3
    800021e2:	854a                	mv	a0,s2
    800021e4:	aedfe0ef          	jal	80000cd0 <memmove>
    return 0;
    800021e8:	8526                	mv	a0,s1
    800021ea:	b7cd                	j	800021cc <either_copyin+0x2a>

00000000800021ec <procdump>:
/* Print a process listing to console.  For debugging. */
/* Runs when user types ^P on console. */
/* No lock to avoid wedging a stuck machine further. */
void
procdump(void)
{
    800021ec:	715d                	add	sp,sp,-80
    800021ee:	e486                	sd	ra,72(sp)
    800021f0:	e0a2                	sd	s0,64(sp)
    800021f2:	fc26                	sd	s1,56(sp)
    800021f4:	f84a                	sd	s2,48(sp)
    800021f6:	f44e                	sd	s3,40(sp)
    800021f8:	f052                	sd	s4,32(sp)
    800021fa:	ec56                	sd	s5,24(sp)
    800021fc:	e85a                	sd	s6,16(sp)
    800021fe:	e45e                	sd	s7,8(sp)
    80002200:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002202:	00005517          	auipc	a0,0x5
    80002206:	ebe50513          	add	a0,a0,-322 # 800070c0 <digits+0x88>
    8000220a:	a94fe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000220e:	0000e497          	auipc	s1,0xe
    80002212:	daa48493          	add	s1,s1,-598 # 8000ffb8 <proc+0x158>
    80002216:	00013917          	auipc	s2,0x13
    8000221a:	7a290913          	add	s2,s2,1954 # 800159b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000221e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002220:	00005997          	auipc	s3,0x5
    80002224:	09898993          	add	s3,s3,152 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002228:	00005a97          	auipc	s5,0x5
    8000222c:	098a8a93          	add	s5,s5,152 # 800072c0 <digits+0x288>
    printf("\n");
    80002230:	00005a17          	auipc	s4,0x5
    80002234:	e90a0a13          	add	s4,s4,-368 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002238:	00005b97          	auipc	s7,0x5
    8000223c:	0c8b8b93          	add	s7,s7,200 # 80007300 <states.0>
    80002240:	a829                	j	8000225a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002242:	ed86a583          	lw	a1,-296(a3)
    80002246:	8556                	mv	a0,s5
    80002248:	a56fe0ef          	jal	8000049e <printf>
    printf("\n");
    8000224c:	8552                	mv	a0,s4
    8000224e:	a50fe0ef          	jal	8000049e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002252:	16848493          	add	s1,s1,360
    80002256:	03248263          	beq	s1,s2,8000227a <procdump+0x8e>
    if(p->state == UNUSED)
    8000225a:	86a6                	mv	a3,s1
    8000225c:	ec04a783          	lw	a5,-320(s1)
    80002260:	dbed                	beqz	a5,80002252 <procdump+0x66>
      state = "???";
    80002262:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002264:	fcfb6fe3          	bltu	s6,a5,80002242 <procdump+0x56>
    80002268:	02079713          	sll	a4,a5,0x20
    8000226c:	01d75793          	srl	a5,a4,0x1d
    80002270:	97de                	add	a5,a5,s7
    80002272:	6390                	ld	a2,0(a5)
    80002274:	f679                	bnez	a2,80002242 <procdump+0x56>
      state = "???";
    80002276:	864e                	mv	a2,s3
    80002278:	b7e9                	j	80002242 <procdump+0x56>
  }
}
    8000227a:	60a6                	ld	ra,72(sp)
    8000227c:	6406                	ld	s0,64(sp)
    8000227e:	74e2                	ld	s1,56(sp)
    80002280:	7942                	ld	s2,48(sp)
    80002282:	79a2                	ld	s3,40(sp)
    80002284:	7a02                	ld	s4,32(sp)
    80002286:	6ae2                	ld	s5,24(sp)
    80002288:	6b42                	ld	s6,16(sp)
    8000228a:	6ba2                	ld	s7,8(sp)
    8000228c:	6161                	add	sp,sp,80
    8000228e:	8082                	ret

0000000080002290 <swtch>:
    80002290:	00153023          	sd	ra,0(a0)
    80002294:	00253423          	sd	sp,8(a0)
    80002298:	e900                	sd	s0,16(a0)
    8000229a:	ed04                	sd	s1,24(a0)
    8000229c:	03253023          	sd	s2,32(a0)
    800022a0:	03353423          	sd	s3,40(a0)
    800022a4:	03453823          	sd	s4,48(a0)
    800022a8:	03553c23          	sd	s5,56(a0)
    800022ac:	05653023          	sd	s6,64(a0)
    800022b0:	05753423          	sd	s7,72(a0)
    800022b4:	05853823          	sd	s8,80(a0)
    800022b8:	05953c23          	sd	s9,88(a0)
    800022bc:	07a53023          	sd	s10,96(a0)
    800022c0:	07b53423          	sd	s11,104(a0)
    800022c4:	0005b083          	ld	ra,0(a1)
    800022c8:	0085b103          	ld	sp,8(a1)
    800022cc:	6980                	ld	s0,16(a1)
    800022ce:	6d84                	ld	s1,24(a1)
    800022d0:	0205b903          	ld	s2,32(a1)
    800022d4:	0285b983          	ld	s3,40(a1)
    800022d8:	0305ba03          	ld	s4,48(a1)
    800022dc:	0385ba83          	ld	s5,56(a1)
    800022e0:	0405bb03          	ld	s6,64(a1)
    800022e4:	0485bb83          	ld	s7,72(a1)
    800022e8:	0505bc03          	ld	s8,80(a1)
    800022ec:	0585bc83          	ld	s9,88(a1)
    800022f0:	0605bd03          	ld	s10,96(a1)
    800022f4:	0685bd83          	ld	s11,104(a1)
    800022f8:	8082                	ret

00000000800022fa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800022fa:	1141                	add	sp,sp,-16
    800022fc:	e406                	sd	ra,8(sp)
    800022fe:	e022                	sd	s0,0(sp)
    80002300:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002302:	00005597          	auipc	a1,0x5
    80002306:	02e58593          	add	a1,a1,46 # 80007330 <states.0+0x30>
    8000230a:	00013517          	auipc	a0,0x13
    8000230e:	55650513          	add	a0,a0,1366 # 80015860 <tickslock>
    80002312:	80ffe0ef          	jal	80000b20 <initlock>
}
    80002316:	60a2                	ld	ra,8(sp)
    80002318:	6402                	ld	s0,0(sp)
    8000231a:	0141                	add	sp,sp,16
    8000231c:	8082                	ret

000000008000231e <trapinithart>:

/* set up to take exceptions and traps while in the kernel. */
void
trapinithart(void)
{
    8000231e:	1141                	add	sp,sp,-16
    80002320:	e422                	sd	s0,8(sp)
    80002322:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002324:	00003797          	auipc	a5,0x3
    80002328:	dcc78793          	add	a5,a5,-564 # 800050f0 <kernelvec>
    8000232c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002330:	6422                	ld	s0,8(sp)
    80002332:	0141                	add	sp,sp,16
    80002334:	8082                	ret

0000000080002336 <usertrapret>:
/* */
/* return to user space */
/* */
void
usertrapret(void)
{
    80002336:	1141                	add	sp,sp,-16
    80002338:	e406                	sd	ra,8(sp)
    8000233a:	e022                	sd	s0,0(sp)
    8000233c:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    8000233e:	cf2ff0ef          	jal	80001830 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002342:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002346:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002348:	10079073          	csrw	sstatus,a5
  /* kerneltrap() to usertrap(), so turn off interrupts until */
  /* we're back in user space, where usertrap() is correct. */
  intr_off();

  /* send syscalls, interrupts, and exceptions to uservec in trampoline.S */
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000234c:	00004697          	auipc	a3,0x4
    80002350:	cb468693          	add	a3,a3,-844 # 80006000 <_trampoline>
    80002354:	00004717          	auipc	a4,0x4
    80002358:	cac70713          	add	a4,a4,-852 # 80006000 <_trampoline>
    8000235c:	8f15                	sub	a4,a4,a3
    8000235e:	040007b7          	lui	a5,0x4000
    80002362:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002364:	07b2                	sll	a5,a5,0xc
    80002366:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002368:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  /* set up trapframe values that uservec will need when */
  /* the process next traps into the kernel. */
  p->trapframe->kernel_satp = r_satp();         /* kernel page table */
    8000236c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000236e:	18002673          	csrr	a2,satp
    80002372:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; /* process's kernel stack */
    80002374:	6d30                	ld	a2,88(a0)
    80002376:	6138                	ld	a4,64(a0)
    80002378:	6585                	lui	a1,0x1
    8000237a:	972e                	add	a4,a4,a1
    8000237c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000237e:	6d38                	ld	a4,88(a0)
    80002380:	00000617          	auipc	a2,0x0
    80002384:	10c60613          	add	a2,a2,268 # 8000248c <usertrap>
    80002388:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         /* hartid for cpuid() */
    8000238a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000238c:	8612                	mv	a2,tp
    8000238e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002390:	10002773          	csrr	a4,sstatus
  /* set up the registers that trampoline.S's sret will use */
  /* to get to user space. */
  
  /* set S Previous Privilege mode to User. */
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; /* clear SPP to 0 for user mode */
    80002394:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; /* enable interrupts in user mode */
    80002398:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000239c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  /* set S Exception Program Counter to the saved user pc. */
  w_sepc(p->trapframe->epc);
    800023a0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800023a2:	6f18                	ld	a4,24(a4)
    800023a4:	14171073          	csrw	sepc,a4

  /* tell trampoline.S the user page table to switch to. */
  uint64 satp = MAKE_SATP(p->pagetable);
    800023a8:	6928                	ld	a0,80(a0)
    800023aa:	8131                	srl	a0,a0,0xc

  /* jump to userret in trampoline.S at the top of memory, which  */
  /* switches to the user page table, restores user registers, */
  /* and switches to user mode with sret. */
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800023ac:	00004717          	auipc	a4,0x4
    800023b0:	cf070713          	add	a4,a4,-784 # 8000609c <userret>
    800023b4:	8f15                	sub	a4,a4,a3
    800023b6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800023b8:	577d                	li	a4,-1
    800023ba:	177e                	sll	a4,a4,0x3f
    800023bc:	8d59                	or	a0,a0,a4
    800023be:	9782                	jalr	a5
}
    800023c0:	60a2                	ld	ra,8(sp)
    800023c2:	6402                	ld	s0,0(sp)
    800023c4:	0141                	add	sp,sp,16
    800023c6:	8082                	ret

00000000800023c8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800023c8:	1101                	add	sp,sp,-32
    800023ca:	ec06                	sd	ra,24(sp)
    800023cc:	e822                	sd	s0,16(sp)
    800023ce:	e426                	sd	s1,8(sp)
    800023d0:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    800023d2:	c32ff0ef          	jal	80001804 <cpuid>
    800023d6:	cd19                	beqz	a0,800023f4 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800023d8:	c01027f3          	rdtime	a5
  }

  /* ask for the next timer interrupt. this also clears */
  /* the interrupt request. 1000000 is about a tenth */
  /* of a second. */
  w_stimecmp(r_time() + 1000000);
    800023dc:	000f4737          	lui	a4,0xf4
    800023e0:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800023e4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800023e6:	14d79073          	csrw	stimecmp,a5
}
    800023ea:	60e2                	ld	ra,24(sp)
    800023ec:	6442                	ld	s0,16(sp)
    800023ee:	64a2                	ld	s1,8(sp)
    800023f0:	6105                	add	sp,sp,32
    800023f2:	8082                	ret
    acquire(&tickslock);
    800023f4:	00013497          	auipc	s1,0x13
    800023f8:	46c48493          	add	s1,s1,1132 # 80015860 <tickslock>
    800023fc:	8526                	mv	a0,s1
    800023fe:	fa2fe0ef          	jal	80000ba0 <acquire>
    ticks++;
    80002402:	00005517          	auipc	a0,0x5
    80002406:	4fe50513          	add	a0,a0,1278 # 80007900 <ticks>
    8000240a:	411c                	lw	a5,0(a0)
    8000240c:	2785                	addw	a5,a5,1
    8000240e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002410:	a39ff0ef          	jal	80001e48 <wakeup>
    release(&tickslock);
    80002414:	8526                	mv	a0,s1
    80002416:	823fe0ef          	jal	80000c38 <release>
    8000241a:	bf7d                	j	800023d8 <clockintr+0x10>

000000008000241c <devintr>:
/* returns 2 if timer interrupt, */
/* 1 if other device, */
/* 0 if not recognized. */
int
devintr()
{
    8000241c:	1101                	add	sp,sp,-32
    8000241e:	ec06                	sd	ra,24(sp)
    80002420:	e822                	sd	s0,16(sp)
    80002422:	e426                	sd	s1,8(sp)
    80002424:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002426:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000242a:	57fd                	li	a5,-1
    8000242c:	17fe                	sll	a5,a5,0x3f
    8000242e:	07a5                	add	a5,a5,9
    80002430:	00f70d63          	beq	a4,a5,8000244a <devintr+0x2e>
    /* now allowed to interrupt again. */
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002434:	57fd                	li	a5,-1
    80002436:	17fe                	sll	a5,a5,0x3f
    80002438:	0795                	add	a5,a5,5
    /* timer interrupt. */
    clockintr();
    return 2;
  } else {
    return 0;
    8000243a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000243c:	04f70463          	beq	a4,a5,80002484 <devintr+0x68>
  }
}
    80002440:	60e2                	ld	ra,24(sp)
    80002442:	6442                	ld	s0,16(sp)
    80002444:	64a2                	ld	s1,8(sp)
    80002446:	6105                	add	sp,sp,32
    80002448:	8082                	ret
    int irq = plic_claim();
    8000244a:	54f020ef          	jal	80005198 <plic_claim>
    8000244e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002450:	47a9                	li	a5,10
    80002452:	02f50363          	beq	a0,a5,80002478 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80002456:	4785                	li	a5,1
    80002458:	02f50363          	beq	a0,a5,8000247e <devintr+0x62>
    return 1;
    8000245c:	4505                	li	a0,1
    } else if(irq){
    8000245e:	d0ed                	beqz	s1,80002440 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002460:	85a6                	mv	a1,s1
    80002462:	00005517          	auipc	a0,0x5
    80002466:	ed650513          	add	a0,a0,-298 # 80007338 <states.0+0x38>
    8000246a:	834fe0ef          	jal	8000049e <printf>
      plic_complete(irq);
    8000246e:	8526                	mv	a0,s1
    80002470:	549020ef          	jal	800051b8 <plic_complete>
    return 1;
    80002474:	4505                	li	a0,1
    80002476:	b7e9                	j	80002440 <devintr+0x24>
      uartintr();
    80002478:	d3afe0ef          	jal	800009b2 <uartintr>
    if(irq)
    8000247c:	bfcd                	j	8000246e <devintr+0x52>
      virtio_disk_intr();
    8000247e:	1a4030ef          	jal	80005622 <virtio_disk_intr>
    if(irq)
    80002482:	b7f5                	j	8000246e <devintr+0x52>
    clockintr();
    80002484:	f45ff0ef          	jal	800023c8 <clockintr>
    return 2;
    80002488:	4509                	li	a0,2
    8000248a:	bf5d                	j	80002440 <devintr+0x24>

000000008000248c <usertrap>:
{
    8000248c:	1101                	add	sp,sp,-32
    8000248e:	ec06                	sd	ra,24(sp)
    80002490:	e822                	sd	s0,16(sp)
    80002492:	e426                	sd	s1,8(sp)
    80002494:	e04a                	sd	s2,0(sp)
    80002496:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002498:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000249c:	1007f793          	and	a5,a5,256
    800024a0:	ef85                	bnez	a5,800024d8 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024a2:	00003797          	auipc	a5,0x3
    800024a6:	c4e78793          	add	a5,a5,-946 # 800050f0 <kernelvec>
    800024aa:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800024ae:	b82ff0ef          	jal	80001830 <myproc>
    800024b2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800024b4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800024b6:	14102773          	csrr	a4,sepc
    800024ba:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024bc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800024c0:	47a1                	li	a5,8
    800024c2:	02f70163          	beq	a4,a5,800024e4 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800024c6:	f57ff0ef          	jal	8000241c <devintr>
    800024ca:	892a                	mv	s2,a0
    800024cc:	c135                	beqz	a0,80002530 <usertrap+0xa4>
  if(killed(p))
    800024ce:	8526                	mv	a0,s1
    800024d0:	b65ff0ef          	jal	80002034 <killed>
    800024d4:	cd1d                	beqz	a0,80002512 <usertrap+0x86>
    800024d6:	a81d                	j	8000250c <usertrap+0x80>
    panic("usertrap: not from user mode");
    800024d8:	00005517          	auipc	a0,0x5
    800024dc:	e8050513          	add	a0,a0,-384 # 80007358 <states.0+0x58>
    800024e0:	a7efe0ef          	jal	8000075e <panic>
    if(killed(p))
    800024e4:	b51ff0ef          	jal	80002034 <killed>
    800024e8:	e121                	bnez	a0,80002528 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800024ea:	6cb8                	ld	a4,88(s1)
    800024ec:	6f1c                	ld	a5,24(a4)
    800024ee:	0791                	add	a5,a5,4
    800024f0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800024f6:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024fa:	10079073          	csrw	sstatus,a5
    syscall();
    800024fe:	248000ef          	jal	80002746 <syscall>
  if(killed(p))
    80002502:	8526                	mv	a0,s1
    80002504:	b31ff0ef          	jal	80002034 <killed>
    80002508:	c901                	beqz	a0,80002518 <usertrap+0x8c>
    8000250a:	4901                	li	s2,0
    exit(-1);
    8000250c:	557d                	li	a0,-1
    8000250e:	9fbff0ef          	jal	80001f08 <exit>
  if(which_dev == 2)
    80002512:	4789                	li	a5,2
    80002514:	04f90563          	beq	s2,a5,8000255e <usertrap+0xd2>
  usertrapret();
    80002518:	e1fff0ef          	jal	80002336 <usertrapret>
}
    8000251c:	60e2                	ld	ra,24(sp)
    8000251e:	6442                	ld	s0,16(sp)
    80002520:	64a2                	ld	s1,8(sp)
    80002522:	6902                	ld	s2,0(sp)
    80002524:	6105                	add	sp,sp,32
    80002526:	8082                	ret
      exit(-1);
    80002528:	557d                	li	a0,-1
    8000252a:	9dfff0ef          	jal	80001f08 <exit>
    8000252e:	bf75                	j	800024ea <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002530:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002534:	5890                	lw	a2,48(s1)
    80002536:	00005517          	auipc	a0,0x5
    8000253a:	e4250513          	add	a0,a0,-446 # 80007378 <states.0+0x78>
    8000253e:	f61fd0ef          	jal	8000049e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002542:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002546:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000254a:	00005517          	auipc	a0,0x5
    8000254e:	e5e50513          	add	a0,a0,-418 # 800073a8 <states.0+0xa8>
    80002552:	f4dfd0ef          	jal	8000049e <printf>
    setkilled(p);
    80002556:	8526                	mv	a0,s1
    80002558:	ab9ff0ef          	jal	80002010 <setkilled>
    8000255c:	b75d                	j	80002502 <usertrap+0x76>
    yield();
    8000255e:	873ff0ef          	jal	80001dd0 <yield>
    80002562:	bf5d                	j	80002518 <usertrap+0x8c>

0000000080002564 <kerneltrap>:
{
    80002564:	7179                	add	sp,sp,-48
    80002566:	f406                	sd	ra,40(sp)
    80002568:	f022                	sd	s0,32(sp)
    8000256a:	ec26                	sd	s1,24(sp)
    8000256c:	e84a                	sd	s2,16(sp)
    8000256e:	e44e                	sd	s3,8(sp)
    80002570:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002572:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002576:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000257a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000257e:	1004f793          	and	a5,s1,256
    80002582:	c795                	beqz	a5,800025ae <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002584:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002588:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    8000258a:	eb85                	bnez	a5,800025ba <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000258c:	e91ff0ef          	jal	8000241c <devintr>
    80002590:	c91d                	beqz	a0,800025c6 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002592:	4789                	li	a5,2
    80002594:	04f50a63          	beq	a0,a5,800025e8 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002598:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000259c:	10049073          	csrw	sstatus,s1
}
    800025a0:	70a2                	ld	ra,40(sp)
    800025a2:	7402                	ld	s0,32(sp)
    800025a4:	64e2                	ld	s1,24(sp)
    800025a6:	6942                	ld	s2,16(sp)
    800025a8:	69a2                	ld	s3,8(sp)
    800025aa:	6145                	add	sp,sp,48
    800025ac:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800025ae:	00005517          	auipc	a0,0x5
    800025b2:	e2250513          	add	a0,a0,-478 # 800073d0 <states.0+0xd0>
    800025b6:	9a8fe0ef          	jal	8000075e <panic>
    panic("kerneltrap: interrupts enabled");
    800025ba:	00005517          	auipc	a0,0x5
    800025be:	e3e50513          	add	a0,a0,-450 # 800073f8 <states.0+0xf8>
    800025c2:	99cfe0ef          	jal	8000075e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025c6:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025ca:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800025ce:	85ce                	mv	a1,s3
    800025d0:	00005517          	auipc	a0,0x5
    800025d4:	e4850513          	add	a0,a0,-440 # 80007418 <states.0+0x118>
    800025d8:	ec7fd0ef          	jal	8000049e <printf>
    panic("kerneltrap");
    800025dc:	00005517          	auipc	a0,0x5
    800025e0:	e6450513          	add	a0,a0,-412 # 80007440 <states.0+0x140>
    800025e4:	97afe0ef          	jal	8000075e <panic>
  if(which_dev == 2 && myproc() != 0)
    800025e8:	a48ff0ef          	jal	80001830 <myproc>
    800025ec:	d555                	beqz	a0,80002598 <kerneltrap+0x34>
    yield();
    800025ee:	fe2ff0ef          	jal	80001dd0 <yield>
    800025f2:	b75d                	j	80002598 <kerneltrap+0x34>

00000000800025f4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800025f4:	1101                	add	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	1000                	add	s0,sp,32
    800025fe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002600:	a30ff0ef          	jal	80001830 <myproc>
  switch (n) {
    80002604:	4795                	li	a5,5
    80002606:	0497e163          	bltu	a5,s1,80002648 <argraw+0x54>
    8000260a:	048a                	sll	s1,s1,0x2
    8000260c:	00005717          	auipc	a4,0x5
    80002610:	e6c70713          	add	a4,a4,-404 # 80007478 <states.0+0x178>
    80002614:	94ba                	add	s1,s1,a4
    80002616:	409c                	lw	a5,0(s1)
    80002618:	97ba                	add	a5,a5,a4
    8000261a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000261c:	6d3c                	ld	a5,88(a0)
    8000261e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	add	sp,sp,32
    80002628:	8082                	ret
    return p->trapframe->a1;
    8000262a:	6d3c                	ld	a5,88(a0)
    8000262c:	7fa8                	ld	a0,120(a5)
    8000262e:	bfcd                	j	80002620 <argraw+0x2c>
    return p->trapframe->a2;
    80002630:	6d3c                	ld	a5,88(a0)
    80002632:	63c8                	ld	a0,128(a5)
    80002634:	b7f5                	j	80002620 <argraw+0x2c>
    return p->trapframe->a3;
    80002636:	6d3c                	ld	a5,88(a0)
    80002638:	67c8                	ld	a0,136(a5)
    8000263a:	b7dd                	j	80002620 <argraw+0x2c>
    return p->trapframe->a4;
    8000263c:	6d3c                	ld	a5,88(a0)
    8000263e:	6bc8                	ld	a0,144(a5)
    80002640:	b7c5                	j	80002620 <argraw+0x2c>
    return p->trapframe->a5;
    80002642:	6d3c                	ld	a5,88(a0)
    80002644:	6fc8                	ld	a0,152(a5)
    80002646:	bfe9                	j	80002620 <argraw+0x2c>
  panic("argraw");
    80002648:	00005517          	auipc	a0,0x5
    8000264c:	e0850513          	add	a0,a0,-504 # 80007450 <states.0+0x150>
    80002650:	90efe0ef          	jal	8000075e <panic>

0000000080002654 <fetchaddr>:
{
    80002654:	1101                	add	sp,sp,-32
    80002656:	ec06                	sd	ra,24(sp)
    80002658:	e822                	sd	s0,16(sp)
    8000265a:	e426                	sd	s1,8(sp)
    8000265c:	e04a                	sd	s2,0(sp)
    8000265e:	1000                	add	s0,sp,32
    80002660:	84aa                	mv	s1,a0
    80002662:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002664:	9ccff0ef          	jal	80001830 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) /* both tests needed, in case of overflow */
    80002668:	653c                	ld	a5,72(a0)
    8000266a:	02f4f663          	bgeu	s1,a5,80002696 <fetchaddr+0x42>
    8000266e:	00848713          	add	a4,s1,8
    80002672:	02e7e463          	bltu	a5,a4,8000269a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002676:	46a1                	li	a3,8
    80002678:	8626                	mv	a2,s1
    8000267a:	85ca                	mv	a1,s2
    8000267c:	6928                	ld	a0,80(a0)
    8000267e:	f23fe0ef          	jal	800015a0 <copyin>
    80002682:	00a03533          	snez	a0,a0
    80002686:	40a00533          	neg	a0,a0
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6902                	ld	s2,0(sp)
    80002692:	6105                	add	sp,sp,32
    80002694:	8082                	ret
    return -1;
    80002696:	557d                	li	a0,-1
    80002698:	bfcd                	j	8000268a <fetchaddr+0x36>
    8000269a:	557d                	li	a0,-1
    8000269c:	b7fd                	j	8000268a <fetchaddr+0x36>

000000008000269e <fetchstr>:
{
    8000269e:	7179                	add	sp,sp,-48
    800026a0:	f406                	sd	ra,40(sp)
    800026a2:	f022                	sd	s0,32(sp)
    800026a4:	ec26                	sd	s1,24(sp)
    800026a6:	e84a                	sd	s2,16(sp)
    800026a8:	e44e                	sd	s3,8(sp)
    800026aa:	1800                	add	s0,sp,48
    800026ac:	892a                	mv	s2,a0
    800026ae:	84ae                	mv	s1,a1
    800026b0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800026b2:	97eff0ef          	jal	80001830 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800026b6:	86ce                	mv	a3,s3
    800026b8:	864a                	mv	a2,s2
    800026ba:	85a6                	mv	a1,s1
    800026bc:	6928                	ld	a0,80(a0)
    800026be:	f69fe0ef          	jal	80001626 <copyinstr>
    800026c2:	00054c63          	bltz	a0,800026da <fetchstr+0x3c>
  return strlen(buf);
    800026c6:	8526                	mv	a0,s1
    800026c8:	f22fe0ef          	jal	80000dea <strlen>
}
    800026cc:	70a2                	ld	ra,40(sp)
    800026ce:	7402                	ld	s0,32(sp)
    800026d0:	64e2                	ld	s1,24(sp)
    800026d2:	6942                	ld	s2,16(sp)
    800026d4:	69a2                	ld	s3,8(sp)
    800026d6:	6145                	add	sp,sp,48
    800026d8:	8082                	ret
    return -1;
    800026da:	557d                	li	a0,-1
    800026dc:	bfc5                	j	800026cc <fetchstr+0x2e>

00000000800026de <argint>:

/* Fetch the nth 32-bit system call argument. */
void
argint(int n, int *ip)
{
    800026de:	1101                	add	sp,sp,-32
    800026e0:	ec06                	sd	ra,24(sp)
    800026e2:	e822                	sd	s0,16(sp)
    800026e4:	e426                	sd	s1,8(sp)
    800026e6:	1000                	add	s0,sp,32
    800026e8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800026ea:	f0bff0ef          	jal	800025f4 <argraw>
    800026ee:	c088                	sw	a0,0(s1)
}
    800026f0:	60e2                	ld	ra,24(sp)
    800026f2:	6442                	ld	s0,16(sp)
    800026f4:	64a2                	ld	s1,8(sp)
    800026f6:	6105                	add	sp,sp,32
    800026f8:	8082                	ret

00000000800026fa <argaddr>:
/* Retrieve an argument as a pointer. */
/* Doesn't check for legality, since */
/* copyin/copyout will do that. */
void
argaddr(int n, uint64 *ip)
{
    800026fa:	1101                	add	sp,sp,-32
    800026fc:	ec06                	sd	ra,24(sp)
    800026fe:	e822                	sd	s0,16(sp)
    80002700:	e426                	sd	s1,8(sp)
    80002702:	1000                	add	s0,sp,32
    80002704:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002706:	eefff0ef          	jal	800025f4 <argraw>
    8000270a:	e088                	sd	a0,0(s1)
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6105                	add	sp,sp,32
    80002714:	8082                	ret

0000000080002716 <argstr>:
/* Fetch the nth word-sized system call argument as a null-terminated string. */
/* Copies into buf, at most max. */
/* Returns string length if OK (including nul), -1 if error. */
int
argstr(int n, char *buf, int max)
{
    80002716:	7179                	add	sp,sp,-48
    80002718:	f406                	sd	ra,40(sp)
    8000271a:	f022                	sd	s0,32(sp)
    8000271c:	ec26                	sd	s1,24(sp)
    8000271e:	e84a                	sd	s2,16(sp)
    80002720:	1800                	add	s0,sp,48
    80002722:	84ae                	mv	s1,a1
    80002724:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002726:	fd840593          	add	a1,s0,-40
    8000272a:	fd1ff0ef          	jal	800026fa <argaddr>
  return fetchstr(addr, buf, max);
    8000272e:	864a                	mv	a2,s2
    80002730:	85a6                	mv	a1,s1
    80002732:	fd843503          	ld	a0,-40(s0)
    80002736:	f69ff0ef          	jal	8000269e <fetchstr>
}
    8000273a:	70a2                	ld	ra,40(sp)
    8000273c:	7402                	ld	s0,32(sp)
    8000273e:	64e2                	ld	s1,24(sp)
    80002740:	6942                	ld	s2,16(sp)
    80002742:	6145                	add	sp,sp,48
    80002744:	8082                	ret

0000000080002746 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002746:	1101                	add	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	e426                	sd	s1,8(sp)
    8000274e:	e04a                	sd	s2,0(sp)
    80002750:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002752:	8deff0ef          	jal	80001830 <myproc>
    80002756:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002758:	05853903          	ld	s2,88(a0)
    8000275c:	0a893783          	ld	a5,168(s2)
    80002760:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002764:	37fd                	addw	a5,a5,-1
    80002766:	4751                	li	a4,20
    80002768:	00f76f63          	bltu	a4,a5,80002786 <syscall+0x40>
    8000276c:	00369713          	sll	a4,a3,0x3
    80002770:	00005797          	auipc	a5,0x5
    80002774:	d2078793          	add	a5,a5,-736 # 80007490 <syscalls>
    80002778:	97ba                	add	a5,a5,a4
    8000277a:	639c                	ld	a5,0(a5)
    8000277c:	c789                	beqz	a5,80002786 <syscall+0x40>
    /* Use num to lookup the system call function for num, call it, */
    /* and store its return value in p->trapframe->a0 */
    p->trapframe->a0 = syscalls[num]();
    8000277e:	9782                	jalr	a5
    80002780:	06a93823          	sd	a0,112(s2)
    80002784:	a829                	j	8000279e <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002786:	15848613          	add	a2,s1,344
    8000278a:	588c                	lw	a1,48(s1)
    8000278c:	00005517          	auipc	a0,0x5
    80002790:	ccc50513          	add	a0,a0,-820 # 80007458 <states.0+0x158>
    80002794:	d0bfd0ef          	jal	8000049e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002798:	6cbc                	ld	a5,88(s1)
    8000279a:	577d                	li	a4,-1
    8000279c:	fbb8                	sd	a4,112(a5)
  }
}
    8000279e:	60e2                	ld	ra,24(sp)
    800027a0:	6442                	ld	s0,16(sp)
    800027a2:	64a2                	ld	s1,8(sp)
    800027a4:	6902                	ld	s2,0(sp)
    800027a6:	6105                	add	sp,sp,32
    800027a8:	8082                	ret

00000000800027aa <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800027aa:	1101                	add	sp,sp,-32
    800027ac:	ec06                	sd	ra,24(sp)
    800027ae:	e822                	sd	s0,16(sp)
    800027b0:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800027b2:	fec40593          	add	a1,s0,-20
    800027b6:	4501                	li	a0,0
    800027b8:	f27ff0ef          	jal	800026de <argint>
  exit(n);
    800027bc:	fec42503          	lw	a0,-20(s0)
    800027c0:	f48ff0ef          	jal	80001f08 <exit>
  return 0;  /* not reached */
}
    800027c4:	4501                	li	a0,0
    800027c6:	60e2                	ld	ra,24(sp)
    800027c8:	6442                	ld	s0,16(sp)
    800027ca:	6105                	add	sp,sp,32
    800027cc:	8082                	ret

00000000800027ce <sys_getpid>:

uint64
sys_getpid(void)
{
    800027ce:	1141                	add	sp,sp,-16
    800027d0:	e406                	sd	ra,8(sp)
    800027d2:	e022                	sd	s0,0(sp)
    800027d4:	0800                	add	s0,sp,16
  return myproc()->pid;
    800027d6:	85aff0ef          	jal	80001830 <myproc>
}
    800027da:	5908                	lw	a0,48(a0)
    800027dc:	60a2                	ld	ra,8(sp)
    800027de:	6402                	ld	s0,0(sp)
    800027e0:	0141                	add	sp,sp,16
    800027e2:	8082                	ret

00000000800027e4 <sys_fork>:

uint64
sys_fork(void)
{
    800027e4:	1141                	add	sp,sp,-16
    800027e6:	e406                	sd	ra,8(sp)
    800027e8:	e022                	sd	s0,0(sp)
    800027ea:	0800                	add	s0,sp,16
  return fork();
    800027ec:	b6aff0ef          	jal	80001b56 <fork>
}
    800027f0:	60a2                	ld	ra,8(sp)
    800027f2:	6402                	ld	s0,0(sp)
    800027f4:	0141                	add	sp,sp,16
    800027f6:	8082                	ret

00000000800027f8 <sys_wait>:

uint64
sys_wait(void)
{
    800027f8:	1101                	add	sp,sp,-32
    800027fa:	ec06                	sd	ra,24(sp)
    800027fc:	e822                	sd	s0,16(sp)
    800027fe:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002800:	fe840593          	add	a1,s0,-24
    80002804:	4501                	li	a0,0
    80002806:	ef5ff0ef          	jal	800026fa <argaddr>
  return wait(p);
    8000280a:	fe843503          	ld	a0,-24(s0)
    8000280e:	851ff0ef          	jal	8000205e <wait>
}
    80002812:	60e2                	ld	ra,24(sp)
    80002814:	6442                	ld	s0,16(sp)
    80002816:	6105                	add	sp,sp,32
    80002818:	8082                	ret

000000008000281a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000281a:	7179                	add	sp,sp,-48
    8000281c:	f406                	sd	ra,40(sp)
    8000281e:	f022                	sd	s0,32(sp)
    80002820:	ec26                	sd	s1,24(sp)
    80002822:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002824:	fdc40593          	add	a1,s0,-36
    80002828:	4501                	li	a0,0
    8000282a:	eb5ff0ef          	jal	800026de <argint>
  addr = myproc()->sz;
    8000282e:	802ff0ef          	jal	80001830 <myproc>
    80002832:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002834:	fdc42503          	lw	a0,-36(s0)
    80002838:	aceff0ef          	jal	80001b06 <growproc>
    8000283c:	00054863          	bltz	a0,8000284c <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002840:	8526                	mv	a0,s1
    80002842:	70a2                	ld	ra,40(sp)
    80002844:	7402                	ld	s0,32(sp)
    80002846:	64e2                	ld	s1,24(sp)
    80002848:	6145                	add	sp,sp,48
    8000284a:	8082                	ret
    return -1;
    8000284c:	54fd                	li	s1,-1
    8000284e:	bfcd                	j	80002840 <sys_sbrk+0x26>

0000000080002850 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002850:	7139                	add	sp,sp,-64
    80002852:	fc06                	sd	ra,56(sp)
    80002854:	f822                	sd	s0,48(sp)
    80002856:	f426                	sd	s1,40(sp)
    80002858:	f04a                	sd	s2,32(sp)
    8000285a:	ec4e                	sd	s3,24(sp)
    8000285c:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000285e:	fcc40593          	add	a1,s0,-52
    80002862:	4501                	li	a0,0
    80002864:	e7bff0ef          	jal	800026de <argint>
  if(n < 0)
    80002868:	fcc42783          	lw	a5,-52(s0)
    8000286c:	0607c563          	bltz	a5,800028d6 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002870:	00013517          	auipc	a0,0x13
    80002874:	ff050513          	add	a0,a0,-16 # 80015860 <tickslock>
    80002878:	b28fe0ef          	jal	80000ba0 <acquire>
  ticks0 = ticks;
    8000287c:	00005917          	auipc	s2,0x5
    80002880:	08492903          	lw	s2,132(s2) # 80007900 <ticks>
  while(ticks - ticks0 < n){
    80002884:	fcc42783          	lw	a5,-52(s0)
    80002888:	cb8d                	beqz	a5,800028ba <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000288a:	00013997          	auipc	s3,0x13
    8000288e:	fd698993          	add	s3,s3,-42 # 80015860 <tickslock>
    80002892:	00005497          	auipc	s1,0x5
    80002896:	06e48493          	add	s1,s1,110 # 80007900 <ticks>
    if(killed(myproc())){
    8000289a:	f97fe0ef          	jal	80001830 <myproc>
    8000289e:	f96ff0ef          	jal	80002034 <killed>
    800028a2:	ed0d                	bnez	a0,800028dc <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800028a4:	85ce                	mv	a1,s3
    800028a6:	8526                	mv	a0,s1
    800028a8:	d54ff0ef          	jal	80001dfc <sleep>
  while(ticks - ticks0 < n){
    800028ac:	409c                	lw	a5,0(s1)
    800028ae:	412787bb          	subw	a5,a5,s2
    800028b2:	fcc42703          	lw	a4,-52(s0)
    800028b6:	fee7e2e3          	bltu	a5,a4,8000289a <sys_sleep+0x4a>
  }
  release(&tickslock);
    800028ba:	00013517          	auipc	a0,0x13
    800028be:	fa650513          	add	a0,a0,-90 # 80015860 <tickslock>
    800028c2:	b76fe0ef          	jal	80000c38 <release>
  return 0;
    800028c6:	4501                	li	a0,0
}
    800028c8:	70e2                	ld	ra,56(sp)
    800028ca:	7442                	ld	s0,48(sp)
    800028cc:	74a2                	ld	s1,40(sp)
    800028ce:	7902                	ld	s2,32(sp)
    800028d0:	69e2                	ld	s3,24(sp)
    800028d2:	6121                	add	sp,sp,64
    800028d4:	8082                	ret
    n = 0;
    800028d6:	fc042623          	sw	zero,-52(s0)
    800028da:	bf59                	j	80002870 <sys_sleep+0x20>
      release(&tickslock);
    800028dc:	00013517          	auipc	a0,0x13
    800028e0:	f8450513          	add	a0,a0,-124 # 80015860 <tickslock>
    800028e4:	b54fe0ef          	jal	80000c38 <release>
      return -1;
    800028e8:	557d                	li	a0,-1
    800028ea:	bff9                	j	800028c8 <sys_sleep+0x78>

00000000800028ec <sys_kill>:

uint64
sys_kill(void)
{
    800028ec:	1101                	add	sp,sp,-32
    800028ee:	ec06                	sd	ra,24(sp)
    800028f0:	e822                	sd	s0,16(sp)
    800028f2:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    800028f4:	fec40593          	add	a1,s0,-20
    800028f8:	4501                	li	a0,0
    800028fa:	de5ff0ef          	jal	800026de <argint>
  return kill(pid);
    800028fe:	fec42503          	lw	a0,-20(s0)
    80002902:	ea8ff0ef          	jal	80001faa <kill>
}
    80002906:	60e2                	ld	ra,24(sp)
    80002908:	6442                	ld	s0,16(sp)
    8000290a:	6105                	add	sp,sp,32
    8000290c:	8082                	ret

000000008000290e <sys_uptime>:

/* return how many clock tick interrupts have occurred */
/* since start. */
uint64
sys_uptime(void)
{
    8000290e:	1101                	add	sp,sp,-32
    80002910:	ec06                	sd	ra,24(sp)
    80002912:	e822                	sd	s0,16(sp)
    80002914:	e426                	sd	s1,8(sp)
    80002916:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002918:	00013517          	auipc	a0,0x13
    8000291c:	f4850513          	add	a0,a0,-184 # 80015860 <tickslock>
    80002920:	a80fe0ef          	jal	80000ba0 <acquire>
  xticks = ticks;
    80002924:	00005497          	auipc	s1,0x5
    80002928:	fdc4a483          	lw	s1,-36(s1) # 80007900 <ticks>
  release(&tickslock);
    8000292c:	00013517          	auipc	a0,0x13
    80002930:	f3450513          	add	a0,a0,-204 # 80015860 <tickslock>
    80002934:	b04fe0ef          	jal	80000c38 <release>
  return xticks;
}
    80002938:	02049513          	sll	a0,s1,0x20
    8000293c:	9101                	srl	a0,a0,0x20
    8000293e:	60e2                	ld	ra,24(sp)
    80002940:	6442                	ld	s0,16(sp)
    80002942:	64a2                	ld	s1,8(sp)
    80002944:	6105                	add	sp,sp,32
    80002946:	8082                	ret

0000000080002948 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002948:	7179                	add	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	e052                	sd	s4,0(sp)
    80002956:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002958:	00005597          	auipc	a1,0x5
    8000295c:	be858593          	add	a1,a1,-1048 # 80007540 <syscalls+0xb0>
    80002960:	00013517          	auipc	a0,0x13
    80002964:	f1850513          	add	a0,a0,-232 # 80015878 <bcache>
    80002968:	9b8fe0ef          	jal	80000b20 <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    8000296c:	0001b797          	auipc	a5,0x1b
    80002970:	f0c78793          	add	a5,a5,-244 # 8001d878 <bcache+0x8000>
    80002974:	0001b717          	auipc	a4,0x1b
    80002978:	16c70713          	add	a4,a4,364 # 8001dae0 <bcache+0x8268>
    8000297c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002980:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002984:	00013497          	auipc	s1,0x13
    80002988:	f0c48493          	add	s1,s1,-244 # 80015890 <bcache+0x18>
    b->next = bcache.head.next;
    8000298c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000298e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002990:	00005a17          	auipc	s4,0x5
    80002994:	bb8a0a13          	add	s4,s4,-1096 # 80007548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002998:	2b893783          	ld	a5,696(s2)
    8000299c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000299e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800029a2:	85d2                	mv	a1,s4
    800029a4:	01048513          	add	a0,s1,16
    800029a8:	2f0010ef          	jal	80003c98 <initsleeplock>
    bcache.head.next->prev = b;
    800029ac:	2b893783          	ld	a5,696(s2)
    800029b0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800029b2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029b6:	45848493          	add	s1,s1,1112
    800029ba:	fd349fe3          	bne	s1,s3,80002998 <binit+0x50>
  }
}
    800029be:	70a2                	ld	ra,40(sp)
    800029c0:	7402                	ld	s0,32(sp)
    800029c2:	64e2                	ld	s1,24(sp)
    800029c4:	6942                	ld	s2,16(sp)
    800029c6:	69a2                	ld	s3,8(sp)
    800029c8:	6a02                	ld	s4,0(sp)
    800029ca:	6145                	add	sp,sp,48
    800029cc:	8082                	ret

00000000800029ce <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    800029ce:	7179                	add	sp,sp,-48
    800029d0:	f406                	sd	ra,40(sp)
    800029d2:	f022                	sd	s0,32(sp)
    800029d4:	ec26                	sd	s1,24(sp)
    800029d6:	e84a                	sd	s2,16(sp)
    800029d8:	e44e                	sd	s3,8(sp)
    800029da:	1800                	add	s0,sp,48
    800029dc:	892a                	mv	s2,a0
    800029de:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800029e0:	00013517          	auipc	a0,0x13
    800029e4:	e9850513          	add	a0,a0,-360 # 80015878 <bcache>
    800029e8:	9b8fe0ef          	jal	80000ba0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800029ec:	0001b497          	auipc	s1,0x1b
    800029f0:	1444b483          	ld	s1,324(s1) # 8001db30 <bcache+0x82b8>
    800029f4:	0001b797          	auipc	a5,0x1b
    800029f8:	0ec78793          	add	a5,a5,236 # 8001dae0 <bcache+0x8268>
    800029fc:	02f48b63          	beq	s1,a5,80002a32 <bread+0x64>
    80002a00:	873e                	mv	a4,a5
    80002a02:	a021                	j	80002a0a <bread+0x3c>
    80002a04:	68a4                	ld	s1,80(s1)
    80002a06:	02e48663          	beq	s1,a4,80002a32 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002a0a:	449c                	lw	a5,8(s1)
    80002a0c:	ff279ce3          	bne	a5,s2,80002a04 <bread+0x36>
    80002a10:	44dc                	lw	a5,12(s1)
    80002a12:	ff3799e3          	bne	a5,s3,80002a04 <bread+0x36>
      b->refcnt++;
    80002a16:	40bc                	lw	a5,64(s1)
    80002a18:	2785                	addw	a5,a5,1
    80002a1a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a1c:	00013517          	auipc	a0,0x13
    80002a20:	e5c50513          	add	a0,a0,-420 # 80015878 <bcache>
    80002a24:	a14fe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002a28:	01048513          	add	a0,s1,16
    80002a2c:	2a2010ef          	jal	80003cce <acquiresleep>
      return b;
    80002a30:	a889                	j	80002a82 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a32:	0001b497          	auipc	s1,0x1b
    80002a36:	0f64b483          	ld	s1,246(s1) # 8001db28 <bcache+0x82b0>
    80002a3a:	0001b797          	auipc	a5,0x1b
    80002a3e:	0a678793          	add	a5,a5,166 # 8001dae0 <bcache+0x8268>
    80002a42:	00f48863          	beq	s1,a5,80002a52 <bread+0x84>
    80002a46:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002a48:	40bc                	lw	a5,64(s1)
    80002a4a:	cb91                	beqz	a5,80002a5e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a4c:	64a4                	ld	s1,72(s1)
    80002a4e:	fee49de3          	bne	s1,a4,80002a48 <bread+0x7a>
  panic("bget: no buffers");
    80002a52:	00005517          	auipc	a0,0x5
    80002a56:	afe50513          	add	a0,a0,-1282 # 80007550 <syscalls+0xc0>
    80002a5a:	d05fd0ef          	jal	8000075e <panic>
      b->dev = dev;
    80002a5e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002a62:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002a66:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002a6a:	4785                	li	a5,1
    80002a6c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a6e:	00013517          	auipc	a0,0x13
    80002a72:	e0a50513          	add	a0,a0,-502 # 80015878 <bcache>
    80002a76:	9c2fe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002a7a:	01048513          	add	a0,s1,16
    80002a7e:	250010ef          	jal	80003cce <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002a82:	409c                	lw	a5,0(s1)
    80002a84:	cb89                	beqz	a5,80002a96 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002a86:	8526                	mv	a0,s1
    80002a88:	70a2                	ld	ra,40(sp)
    80002a8a:	7402                	ld	s0,32(sp)
    80002a8c:	64e2                	ld	s1,24(sp)
    80002a8e:	6942                	ld	s2,16(sp)
    80002a90:	69a2                	ld	s3,8(sp)
    80002a92:	6145                	add	sp,sp,48
    80002a94:	8082                	ret
    virtio_disk_rw(b, 0);
    80002a96:	4581                	li	a1,0
    80002a98:	8526                	mv	a0,s1
    80002a9a:	171020ef          	jal	8000540a <virtio_disk_rw>
    b->valid = 1;
    80002a9e:	4785                	li	a5,1
    80002aa0:	c09c                	sw	a5,0(s1)
  return b;
    80002aa2:	b7d5                	j	80002a86 <bread+0xb8>

0000000080002aa4 <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    80002aa4:	1101                	add	sp,sp,-32
    80002aa6:	ec06                	sd	ra,24(sp)
    80002aa8:	e822                	sd	s0,16(sp)
    80002aaa:	e426                	sd	s1,8(sp)
    80002aac:	1000                	add	s0,sp,32
    80002aae:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ab0:	0541                	add	a0,a0,16
    80002ab2:	29a010ef          	jal	80003d4c <holdingsleep>
    80002ab6:	c911                	beqz	a0,80002aca <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ab8:	4585                	li	a1,1
    80002aba:	8526                	mv	a0,s1
    80002abc:	14f020ef          	jal	8000540a <virtio_disk_rw>
}
    80002ac0:	60e2                	ld	ra,24(sp)
    80002ac2:	6442                	ld	s0,16(sp)
    80002ac4:	64a2                	ld	s1,8(sp)
    80002ac6:	6105                	add	sp,sp,32
    80002ac8:	8082                	ret
    panic("bwrite");
    80002aca:	00005517          	auipc	a0,0x5
    80002ace:	a9e50513          	add	a0,a0,-1378 # 80007568 <syscalls+0xd8>
    80002ad2:	c8dfd0ef          	jal	8000075e <panic>

0000000080002ad6 <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    80002ad6:	1101                	add	sp,sp,-32
    80002ad8:	ec06                	sd	ra,24(sp)
    80002ada:	e822                	sd	s0,16(sp)
    80002adc:	e426                	sd	s1,8(sp)
    80002ade:	e04a                	sd	s2,0(sp)
    80002ae0:	1000                	add	s0,sp,32
    80002ae2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ae4:	01050913          	add	s2,a0,16
    80002ae8:	854a                	mv	a0,s2
    80002aea:	262010ef          	jal	80003d4c <holdingsleep>
    80002aee:	c135                	beqz	a0,80002b52 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002af0:	854a                	mv	a0,s2
    80002af2:	222010ef          	jal	80003d14 <releasesleep>

  acquire(&bcache.lock);
    80002af6:	00013517          	auipc	a0,0x13
    80002afa:	d8250513          	add	a0,a0,-638 # 80015878 <bcache>
    80002afe:	8a2fe0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002b02:	40bc                	lw	a5,64(s1)
    80002b04:	37fd                	addw	a5,a5,-1
    80002b06:	0007871b          	sext.w	a4,a5
    80002b0a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002b0c:	e71d                	bnez	a4,80002b3a <brelse+0x64>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    80002b0e:	68b8                	ld	a4,80(s1)
    80002b10:	64bc                	ld	a5,72(s1)
    80002b12:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002b14:	68b8                	ld	a4,80(s1)
    80002b16:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002b18:	0001b797          	auipc	a5,0x1b
    80002b1c:	d6078793          	add	a5,a5,-672 # 8001d878 <bcache+0x8000>
    80002b20:	2b87b703          	ld	a4,696(a5)
    80002b24:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002b26:	0001b717          	auipc	a4,0x1b
    80002b2a:	fba70713          	add	a4,a4,-70 # 8001dae0 <bcache+0x8268>
    80002b2e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002b30:	2b87b703          	ld	a4,696(a5)
    80002b34:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002b36:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002b3a:	00013517          	auipc	a0,0x13
    80002b3e:	d3e50513          	add	a0,a0,-706 # 80015878 <bcache>
    80002b42:	8f6fe0ef          	jal	80000c38 <release>
}
    80002b46:	60e2                	ld	ra,24(sp)
    80002b48:	6442                	ld	s0,16(sp)
    80002b4a:	64a2                	ld	s1,8(sp)
    80002b4c:	6902                	ld	s2,0(sp)
    80002b4e:	6105                	add	sp,sp,32
    80002b50:	8082                	ret
    panic("brelse");
    80002b52:	00005517          	auipc	a0,0x5
    80002b56:	a1e50513          	add	a0,a0,-1506 # 80007570 <syscalls+0xe0>
    80002b5a:	c05fd0ef          	jal	8000075e <panic>

0000000080002b5e <bpin>:

void
bpin(struct buf *b) {
    80002b5e:	1101                	add	sp,sp,-32
    80002b60:	ec06                	sd	ra,24(sp)
    80002b62:	e822                	sd	s0,16(sp)
    80002b64:	e426                	sd	s1,8(sp)
    80002b66:	1000                	add	s0,sp,32
    80002b68:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002b6a:	00013517          	auipc	a0,0x13
    80002b6e:	d0e50513          	add	a0,a0,-754 # 80015878 <bcache>
    80002b72:	82efe0ef          	jal	80000ba0 <acquire>
  b->refcnt++;
    80002b76:	40bc                	lw	a5,64(s1)
    80002b78:	2785                	addw	a5,a5,1
    80002b7a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002b7c:	00013517          	auipc	a0,0x13
    80002b80:	cfc50513          	add	a0,a0,-772 # 80015878 <bcache>
    80002b84:	8b4fe0ef          	jal	80000c38 <release>
}
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6105                	add	sp,sp,32
    80002b90:	8082                	ret

0000000080002b92 <bunpin>:

void
bunpin(struct buf *b) {
    80002b92:	1101                	add	sp,sp,-32
    80002b94:	ec06                	sd	ra,24(sp)
    80002b96:	e822                	sd	s0,16(sp)
    80002b98:	e426                	sd	s1,8(sp)
    80002b9a:	1000                	add	s0,sp,32
    80002b9c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002b9e:	00013517          	auipc	a0,0x13
    80002ba2:	cda50513          	add	a0,a0,-806 # 80015878 <bcache>
    80002ba6:	ffbfd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002baa:	40bc                	lw	a5,64(s1)
    80002bac:	37fd                	addw	a5,a5,-1
    80002bae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002bb0:	00013517          	auipc	a0,0x13
    80002bb4:	cc850513          	add	a0,a0,-824 # 80015878 <bcache>
    80002bb8:	880fe0ef          	jal	80000c38 <release>
}
    80002bbc:	60e2                	ld	ra,24(sp)
    80002bbe:	6442                	ld	s0,16(sp)
    80002bc0:	64a2                	ld	s1,8(sp)
    80002bc2:	6105                	add	sp,sp,32
    80002bc4:	8082                	ret

0000000080002bc6 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    80002bc6:	1101                	add	sp,sp,-32
    80002bc8:	ec06                	sd	ra,24(sp)
    80002bca:	e822                	sd	s0,16(sp)
    80002bcc:	e426                	sd	s1,8(sp)
    80002bce:	e04a                	sd	s2,0(sp)
    80002bd0:	1000                	add	s0,sp,32
    80002bd2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002bd4:	00d5d59b          	srlw	a1,a1,0xd
    80002bd8:	0001b797          	auipc	a5,0x1b
    80002bdc:	37c7a783          	lw	a5,892(a5) # 8001df54 <sb+0x1c>
    80002be0:	9dbd                	addw	a1,a1,a5
    80002be2:	dedff0ef          	jal	800029ce <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002be6:	0074f713          	and	a4,s1,7
    80002bea:	4785                	li	a5,1
    80002bec:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002bf0:	14ce                	sll	s1,s1,0x33
    80002bf2:	90d9                	srl	s1,s1,0x36
    80002bf4:	00950733          	add	a4,a0,s1
    80002bf8:	05874703          	lbu	a4,88(a4)
    80002bfc:	00e7f6b3          	and	a3,a5,a4
    80002c00:	c29d                	beqz	a3,80002c26 <bfree+0x60>
    80002c02:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002c04:	94aa                	add	s1,s1,a0
    80002c06:	fff7c793          	not	a5,a5
    80002c0a:	8f7d                	and	a4,a4,a5
    80002c0c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002c10:	7b9000ef          	jal	80003bc8 <log_write>
  brelse(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	ec1ff0ef          	jal	80002ad6 <brelse>
}
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6902                	ld	s2,0(sp)
    80002c22:	6105                	add	sp,sp,32
    80002c24:	8082                	ret
    panic("freeing free block");
    80002c26:	00005517          	auipc	a0,0x5
    80002c2a:	95250513          	add	a0,a0,-1710 # 80007578 <syscalls+0xe8>
    80002c2e:	b31fd0ef          	jal	8000075e <panic>

0000000080002c32 <balloc>:
{
    80002c32:	711d                	add	sp,sp,-96
    80002c34:	ec86                	sd	ra,88(sp)
    80002c36:	e8a2                	sd	s0,80(sp)
    80002c38:	e4a6                	sd	s1,72(sp)
    80002c3a:	e0ca                	sd	s2,64(sp)
    80002c3c:	fc4e                	sd	s3,56(sp)
    80002c3e:	f852                	sd	s4,48(sp)
    80002c40:	f456                	sd	s5,40(sp)
    80002c42:	f05a                	sd	s6,32(sp)
    80002c44:	ec5e                	sd	s7,24(sp)
    80002c46:	e862                	sd	s8,16(sp)
    80002c48:	e466                	sd	s9,8(sp)
    80002c4a:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002c4c:	0001b797          	auipc	a5,0x1b
    80002c50:	2f07a783          	lw	a5,752(a5) # 8001df3c <sb+0x4>
    80002c54:	cff1                	beqz	a5,80002d30 <balloc+0xfe>
    80002c56:	8baa                	mv	s7,a0
    80002c58:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002c5a:	0001bb17          	auipc	s6,0x1b
    80002c5e:	2deb0b13          	add	s6,s6,734 # 8001df38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c62:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002c64:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c66:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002c68:	6c89                	lui	s9,0x2
    80002c6a:	a0b5                	j	80002cd6 <balloc+0xa4>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    80002c6c:	97ca                	add	a5,a5,s2
    80002c6e:	8e55                	or	a2,a2,a3
    80002c70:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002c74:	854a                	mv	a0,s2
    80002c76:	753000ef          	jal	80003bc8 <log_write>
        brelse(bp);
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	e5bff0ef          	jal	80002ad6 <brelse>
  bp = bread(dev, bno);
    80002c80:	85a6                	mv	a1,s1
    80002c82:	855e                	mv	a0,s7
    80002c84:	d4bff0ef          	jal	800029ce <bread>
    80002c88:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002c8a:	40000613          	li	a2,1024
    80002c8e:	4581                	li	a1,0
    80002c90:	05850513          	add	a0,a0,88
    80002c94:	fe1fd0ef          	jal	80000c74 <memset>
  log_write(bp);
    80002c98:	854a                	mv	a0,s2
    80002c9a:	72f000ef          	jal	80003bc8 <log_write>
  brelse(bp);
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	e37ff0ef          	jal	80002ad6 <brelse>
}
    80002ca4:	8526                	mv	a0,s1
    80002ca6:	60e6                	ld	ra,88(sp)
    80002ca8:	6446                	ld	s0,80(sp)
    80002caa:	64a6                	ld	s1,72(sp)
    80002cac:	6906                	ld	s2,64(sp)
    80002cae:	79e2                	ld	s3,56(sp)
    80002cb0:	7a42                	ld	s4,48(sp)
    80002cb2:	7aa2                	ld	s5,40(sp)
    80002cb4:	7b02                	ld	s6,32(sp)
    80002cb6:	6be2                	ld	s7,24(sp)
    80002cb8:	6c42                	ld	s8,16(sp)
    80002cba:	6ca2                	ld	s9,8(sp)
    80002cbc:	6125                	add	sp,sp,96
    80002cbe:	8082                	ret
    brelse(bp);
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	e15ff0ef          	jal	80002ad6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002cc6:	015c87bb          	addw	a5,s9,s5
    80002cca:	00078a9b          	sext.w	s5,a5
    80002cce:	004b2703          	lw	a4,4(s6)
    80002cd2:	04eaff63          	bgeu	s5,a4,80002d30 <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002cd6:	41fad79b          	sraw	a5,s5,0x1f
    80002cda:	0137d79b          	srlw	a5,a5,0x13
    80002cde:	015787bb          	addw	a5,a5,s5
    80002ce2:	40d7d79b          	sraw	a5,a5,0xd
    80002ce6:	01cb2583          	lw	a1,28(s6)
    80002cea:	9dbd                	addw	a1,a1,a5
    80002cec:	855e                	mv	a0,s7
    80002cee:	ce1ff0ef          	jal	800029ce <bread>
    80002cf2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002cf4:	004b2503          	lw	a0,4(s6)
    80002cf8:	000a849b          	sext.w	s1,s5
    80002cfc:	8762                	mv	a4,s8
    80002cfe:	fca4f1e3          	bgeu	s1,a0,80002cc0 <balloc+0x8e>
      m = 1 << (bi % 8);
    80002d02:	00777693          	and	a3,a4,7
    80002d06:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    80002d0a:	41f7579b          	sraw	a5,a4,0x1f
    80002d0e:	01d7d79b          	srlw	a5,a5,0x1d
    80002d12:	9fb9                	addw	a5,a5,a4
    80002d14:	4037d79b          	sraw	a5,a5,0x3
    80002d18:	00f90633          	add	a2,s2,a5
    80002d1c:	05864603          	lbu	a2,88(a2)
    80002d20:	00c6f5b3          	and	a1,a3,a2
    80002d24:	d5a1                	beqz	a1,80002c6c <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d26:	2705                	addw	a4,a4,1
    80002d28:	2485                	addw	s1,s1,1
    80002d2a:	fd471ae3          	bne	a4,s4,80002cfe <balloc+0xcc>
    80002d2e:	bf49                	j	80002cc0 <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002d30:	00005517          	auipc	a0,0x5
    80002d34:	86050513          	add	a0,a0,-1952 # 80007590 <syscalls+0x100>
    80002d38:	f66fd0ef          	jal	8000049e <printf>
  return 0;
    80002d3c:	4481                	li	s1,0
    80002d3e:	b79d                	j	80002ca4 <balloc+0x72>

0000000080002d40 <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    80002d40:	7179                	add	sp,sp,-48
    80002d42:	f406                	sd	ra,40(sp)
    80002d44:	f022                	sd	s0,32(sp)
    80002d46:	ec26                	sd	s1,24(sp)
    80002d48:	e84a                	sd	s2,16(sp)
    80002d4a:	e44e                	sd	s3,8(sp)
    80002d4c:	e052                	sd	s4,0(sp)
    80002d4e:	1800                	add	s0,sp,48
    80002d50:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;
  uint index1, index2; 

  if(bn < NDIRECT){
    80002d52:	47a9                	li	a5,10
    80002d54:	02b7ef63          	bltu	a5,a1,80002d92 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0){
    80002d58:	02059793          	sll	a5,a1,0x20
    80002d5c:	01e7d593          	srl	a1,a5,0x1e
    80002d60:	00b504b3          	add	s1,a0,a1
    80002d64:	0504a903          	lw	s2,80(s1)
    80002d68:	00090b63          	beqz	s2,80002d7e <bmap+0x3e>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	70a2                	ld	ra,40(sp)
    80002d70:	7402                	ld	s0,32(sp)
    80002d72:	64e2                	ld	s1,24(sp)
    80002d74:	6942                	ld	s2,16(sp)
    80002d76:	69a2                	ld	s3,8(sp)
    80002d78:	6a02                	ld	s4,0(sp)
    80002d7a:	6145                	add	sp,sp,48
    80002d7c:	8082                	ret
      addr = balloc(ip->dev);
    80002d7e:	4108                	lw	a0,0(a0)
    80002d80:	eb3ff0ef          	jal	80002c32 <balloc>
    80002d84:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002d88:	fe0902e3          	beqz	s2,80002d6c <bmap+0x2c>
      ip->addrs[bn] = addr;
    80002d8c:	0524a823          	sw	s2,80(s1)
    80002d90:	bff1                	j	80002d6c <bmap+0x2c>
  bn -= NDIRECT;
    80002d92:	ff55849b          	addw	s1,a1,-11
    80002d96:	0004871b          	sext.w	a4,s1
  if(bn < NINDIRECT){
    80002d9a:	0ff00793          	li	a5,255
    80002d9e:	06e7e263          	bltu	a5,a4,80002e02 <bmap+0xc2>
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002da2:	07c52903          	lw	s2,124(a0)
    80002da6:	00091b63          	bnez	s2,80002dbc <bmap+0x7c>
      addr = balloc(ip->dev);
    80002daa:	4108                	lw	a0,0(a0)
    80002dac:	e87ff0ef          	jal	80002c32 <balloc>
    80002db0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002db4:	fa090ce3          	beqz	s2,80002d6c <bmap+0x2c>
      ip->addrs[NDIRECT] = addr;
    80002db8:	0729ae23          	sw	s2,124(s3)
    bp = bread(ip->dev, addr);
    80002dbc:	85ca                	mv	a1,s2
    80002dbe:	0009a503          	lw	a0,0(s3)
    80002dc2:	c0dff0ef          	jal	800029ce <bread>
    80002dc6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002dc8:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002dcc:	02049713          	sll	a4,s1,0x20
    80002dd0:	01e75493          	srl	s1,a4,0x1e
    80002dd4:	94be                	add	s1,s1,a5
    80002dd6:	0004a903          	lw	s2,0(s1)
    80002dda:	00090663          	beqz	s2,80002de6 <bmap+0xa6>
    brelse(bp);
    80002dde:	8552                	mv	a0,s4
    80002de0:	cf7ff0ef          	jal	80002ad6 <brelse>
    return addr;
    80002de4:	b761                	j	80002d6c <bmap+0x2c>
      addr = balloc(ip->dev);
    80002de6:	0009a503          	lw	a0,0(s3)
    80002dea:	e49ff0ef          	jal	80002c32 <balloc>
    80002dee:	0005091b          	sext.w	s2,a0
      if(addr){
    80002df2:	fe0906e3          	beqz	s2,80002dde <bmap+0x9e>
        a[bn] = addr;
    80002df6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002dfa:	8552                	mv	a0,s4
    80002dfc:	5cd000ef          	jal	80003bc8 <log_write>
    80002e00:	bff9                	j	80002dde <bmap+0x9e>
  bn -= NINDIRECT;
    80002e02:	ef55849b          	addw	s1,a1,-267
    80002e06:	0004871b          	sext.w	a4,s1
  if (bn < NINDIRECT * NINDIRECT){
    80002e0a:	67c1                	lui	a5,0x10
    80002e0c:	06f77263          	bgeu	a4,a5,80002e70 <bmap+0x130>
    if((addr = ip->addrs[NDIRECT+1]) == 0){
    80002e10:	08052903          	lw	s2,128(a0)
    80002e14:	00091b63          	bnez	s2,80002e2a <bmap+0xea>
	addr = balloc(ip->dev);
    80002e18:	4108                	lw	a0,0(a0)
    80002e1a:	e19ff0ef          	jal	80002c32 <balloc>
    80002e1e:	0005091b          	sext.w	s2,a0
	if (addr == 0){
    80002e22:	f40905e3          	beqz	s2,80002d6c <bmap+0x2c>
        ip->addrs[NDIRECT + 1] = addr;
    80002e26:	0929a023          	sw	s2,128(s3)
    bp = bread(ip->dev, addr);
    80002e2a:	85ca                	mv	a1,s2
    80002e2c:	0009a503          	lw	a0,0(s3)
    80002e30:	b9fff0ef          	jal	800029ce <bread>
    80002e34:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002e36:	05850793          	add	a5,a0,88
    if((addr = a[index1]) == 0){
    80002e3a:	0084d59b          	srlw	a1,s1,0x8
    80002e3e:	058a                	sll	a1,a1,0x2
    80002e40:	00b784b3          	add	s1,a5,a1
    80002e44:	0004a903          	lw	s2,0(s1)
    80002e48:	00090663          	beqz	s2,80002e54 <bmap+0x114>
    brelse(bp);
    80002e4c:	8552                	mv	a0,s4
    80002e4e:	c89ff0ef          	jal	80002ad6 <brelse>
    return addr;
    80002e52:	bf29                	j	80002d6c <bmap+0x2c>
	addr = balloc(ip->dev);
    80002e54:	0009a503          	lw	a0,0(s3)
    80002e58:	ddbff0ef          	jal	80002c32 <balloc>
    80002e5c:	0005091b          	sext.w	s2,a0
	if (addr){
    80002e60:	fe0906e3          	beqz	s2,80002e4c <bmap+0x10c>
	    a[index1] = addr;
    80002e64:	0124a023          	sw	s2,0(s1)
	    log_write(bp);
    80002e68:	8552                	mv	a0,s4
    80002e6a:	55f000ef          	jal	80003bc8 <log_write>
    80002e6e:	bff9                	j	80002e4c <bmap+0x10c>
  panic("bmap: out of range");
    80002e70:	00004517          	auipc	a0,0x4
    80002e74:	73850513          	add	a0,a0,1848 # 800075a8 <syscalls+0x118>
    80002e78:	8e7fd0ef          	jal	8000075e <panic>

0000000080002e7c <iget>:
{
    80002e7c:	7179                	add	sp,sp,-48
    80002e7e:	f406                	sd	ra,40(sp)
    80002e80:	f022                	sd	s0,32(sp)
    80002e82:	ec26                	sd	s1,24(sp)
    80002e84:	e84a                	sd	s2,16(sp)
    80002e86:	e44e                	sd	s3,8(sp)
    80002e88:	e052                	sd	s4,0(sp)
    80002e8a:	1800                	add	s0,sp,48
    80002e8c:	89aa                	mv	s3,a0
    80002e8e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002e90:	0001b517          	auipc	a0,0x1b
    80002e94:	0c850513          	add	a0,a0,200 # 8001df58 <itable>
    80002e98:	d09fd0ef          	jal	80000ba0 <acquire>
  empty = 0;
    80002e9c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e9e:	0001b497          	auipc	s1,0x1b
    80002ea2:	0d248493          	add	s1,s1,210 # 8001df70 <itable+0x18>
    80002ea6:	0001d697          	auipc	a3,0x1d
    80002eaa:	9ca68693          	add	a3,a3,-1590 # 8001f870 <log>
    80002eae:	a039                	j	80002ebc <iget+0x40>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002eb0:	02090963          	beqz	s2,80002ee2 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002eb4:	08048493          	add	s1,s1,128
    80002eb8:	02d48863          	beq	s1,a3,80002ee8 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002ebc:	449c                	lw	a5,8(s1)
    80002ebe:	fef059e3          	blez	a5,80002eb0 <iget+0x34>
    80002ec2:	4098                	lw	a4,0(s1)
    80002ec4:	ff3716e3          	bne	a4,s3,80002eb0 <iget+0x34>
    80002ec8:	40d8                	lw	a4,4(s1)
    80002eca:	ff4713e3          	bne	a4,s4,80002eb0 <iget+0x34>
      ip->ref++;
    80002ece:	2785                	addw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    80002ed0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ed2:	0001b517          	auipc	a0,0x1b
    80002ed6:	08650513          	add	a0,a0,134 # 8001df58 <itable>
    80002eda:	d5ffd0ef          	jal	80000c38 <release>
      return ip;
    80002ede:	8926                	mv	s2,s1
    80002ee0:	a02d                	j	80002f0a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002ee2:	fbe9                	bnez	a5,80002eb4 <iget+0x38>
    80002ee4:	8926                	mv	s2,s1
    80002ee6:	b7f9                	j	80002eb4 <iget+0x38>
  if(empty == 0)
    80002ee8:	02090a63          	beqz	s2,80002f1c <iget+0xa0>
  ip->dev = dev;
    80002eec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ef0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ef4:	4785                	li	a5,1
    80002ef6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002efa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002efe:	0001b517          	auipc	a0,0x1b
    80002f02:	05a50513          	add	a0,a0,90 # 8001df58 <itable>
    80002f06:	d33fd0ef          	jal	80000c38 <release>
}
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	70a2                	ld	ra,40(sp)
    80002f0e:	7402                	ld	s0,32(sp)
    80002f10:	64e2                	ld	s1,24(sp)
    80002f12:	6942                	ld	s2,16(sp)
    80002f14:	69a2                	ld	s3,8(sp)
    80002f16:	6a02                	ld	s4,0(sp)
    80002f18:	6145                	add	sp,sp,48
    80002f1a:	8082                	ret
    panic("iget: no inodes");
    80002f1c:	00004517          	auipc	a0,0x4
    80002f20:	6a450513          	add	a0,a0,1700 # 800075c0 <syscalls+0x130>
    80002f24:	83bfd0ef          	jal	8000075e <panic>

0000000080002f28 <fsinit>:
fsinit(int dev) {
    80002f28:	7179                	add	sp,sp,-48
    80002f2a:	f406                	sd	ra,40(sp)
    80002f2c:	f022                	sd	s0,32(sp)
    80002f2e:	ec26                	sd	s1,24(sp)
    80002f30:	e84a                	sd	s2,16(sp)
    80002f32:	e44e                	sd	s3,8(sp)
    80002f34:	1800                	add	s0,sp,48
    80002f36:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002f38:	4585                	li	a1,1
    80002f3a:	a95ff0ef          	jal	800029ce <bread>
    80002f3e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002f40:	0001b997          	auipc	s3,0x1b
    80002f44:	ff898993          	add	s3,s3,-8 # 8001df38 <sb>
    80002f48:	02000613          	li	a2,32
    80002f4c:	05850593          	add	a1,a0,88
    80002f50:	854e                	mv	a0,s3
    80002f52:	d7ffd0ef          	jal	80000cd0 <memmove>
  brelse(bp);
    80002f56:	8526                	mv	a0,s1
    80002f58:	b7fff0ef          	jal	80002ad6 <brelse>
  if(sb.magic != FSMAGIC)
    80002f5c:	0009a703          	lw	a4,0(s3)
    80002f60:	102037b7          	lui	a5,0x10203
    80002f64:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f68:	02f71063          	bne	a4,a5,80002f88 <fsinit+0x60>
  initlog(dev, &sb);
    80002f6c:	0001b597          	auipc	a1,0x1b
    80002f70:	fcc58593          	add	a1,a1,-52 # 8001df38 <sb>
    80002f74:	854a                	mv	a0,s2
    80002f76:	251000ef          	jal	800039c6 <initlog>
}
    80002f7a:	70a2                	ld	ra,40(sp)
    80002f7c:	7402                	ld	s0,32(sp)
    80002f7e:	64e2                	ld	s1,24(sp)
    80002f80:	6942                	ld	s2,16(sp)
    80002f82:	69a2                	ld	s3,8(sp)
    80002f84:	6145                	add	sp,sp,48
    80002f86:	8082                	ret
    panic("invalid file system");
    80002f88:	00004517          	auipc	a0,0x4
    80002f8c:	64850513          	add	a0,a0,1608 # 800075d0 <syscalls+0x140>
    80002f90:	fcefd0ef          	jal	8000075e <panic>

0000000080002f94 <iinit>:
{
    80002f94:	7179                	add	sp,sp,-48
    80002f96:	f406                	sd	ra,40(sp)
    80002f98:	f022                	sd	s0,32(sp)
    80002f9a:	ec26                	sd	s1,24(sp)
    80002f9c:	e84a                	sd	s2,16(sp)
    80002f9e:	e44e                	sd	s3,8(sp)
    80002fa0:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002fa2:	00004597          	auipc	a1,0x4
    80002fa6:	64658593          	add	a1,a1,1606 # 800075e8 <syscalls+0x158>
    80002faa:	0001b517          	auipc	a0,0x1b
    80002fae:	fae50513          	add	a0,a0,-82 # 8001df58 <itable>
    80002fb2:	b6ffd0ef          	jal	80000b20 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002fb6:	0001b497          	auipc	s1,0x1b
    80002fba:	fca48493          	add	s1,s1,-54 # 8001df80 <itable+0x28>
    80002fbe:	0001d997          	auipc	s3,0x1d
    80002fc2:	8c298993          	add	s3,s3,-1854 # 8001f880 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002fc6:	00004917          	auipc	s2,0x4
    80002fca:	62a90913          	add	s2,s2,1578 # 800075f0 <syscalls+0x160>
    80002fce:	85ca                	mv	a1,s2
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	4c7000ef          	jal	80003c98 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002fd6:	08048493          	add	s1,s1,128
    80002fda:	ff349ae3          	bne	s1,s3,80002fce <iinit+0x3a>
}
    80002fde:	70a2                	ld	ra,40(sp)
    80002fe0:	7402                	ld	s0,32(sp)
    80002fe2:	64e2                	ld	s1,24(sp)
    80002fe4:	6942                	ld	s2,16(sp)
    80002fe6:	69a2                	ld	s3,8(sp)
    80002fe8:	6145                	add	sp,sp,48
    80002fea:	8082                	ret

0000000080002fec <ialloc>:
{
    80002fec:	7139                	add	sp,sp,-64
    80002fee:	fc06                	sd	ra,56(sp)
    80002ff0:	f822                	sd	s0,48(sp)
    80002ff2:	f426                	sd	s1,40(sp)
    80002ff4:	f04a                	sd	s2,32(sp)
    80002ff6:	ec4e                	sd	s3,24(sp)
    80002ff8:	e852                	sd	s4,16(sp)
    80002ffa:	e456                	sd	s5,8(sp)
    80002ffc:	e05a                	sd	s6,0(sp)
    80002ffe:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003000:	0001b717          	auipc	a4,0x1b
    80003004:	f4472703          	lw	a4,-188(a4) # 8001df44 <sb+0xc>
    80003008:	4785                	li	a5,1
    8000300a:	04e7f463          	bgeu	a5,a4,80003052 <ialloc+0x66>
    8000300e:	8aaa                	mv	s5,a0
    80003010:	8b2e                	mv	s6,a1
    80003012:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003014:	0001ba17          	auipc	s4,0x1b
    80003018:	f24a0a13          	add	s4,s4,-220 # 8001df38 <sb>
    8000301c:	00495593          	srl	a1,s2,0x4
    80003020:	018a2783          	lw	a5,24(s4)
    80003024:	9dbd                	addw	a1,a1,a5
    80003026:	8556                	mv	a0,s5
    80003028:	9a7ff0ef          	jal	800029ce <bread>
    8000302c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000302e:	05850993          	add	s3,a0,88
    80003032:	00f97793          	and	a5,s2,15
    80003036:	079a                	sll	a5,a5,0x6
    80003038:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    8000303a:	00099783          	lh	a5,0(s3)
    8000303e:	cb9d                	beqz	a5,80003074 <ialloc+0x88>
    brelse(bp);
    80003040:	a97ff0ef          	jal	80002ad6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003044:	0905                	add	s2,s2,1
    80003046:	00ca2703          	lw	a4,12(s4)
    8000304a:	0009079b          	sext.w	a5,s2
    8000304e:	fce7e7e3          	bltu	a5,a4,8000301c <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003052:	00004517          	auipc	a0,0x4
    80003056:	5a650513          	add	a0,a0,1446 # 800075f8 <syscalls+0x168>
    8000305a:	c44fd0ef          	jal	8000049e <printf>
  return 0;
    8000305e:	4501                	li	a0,0
}
    80003060:	70e2                	ld	ra,56(sp)
    80003062:	7442                	ld	s0,48(sp)
    80003064:	74a2                	ld	s1,40(sp)
    80003066:	7902                	ld	s2,32(sp)
    80003068:	69e2                	ld	s3,24(sp)
    8000306a:	6a42                	ld	s4,16(sp)
    8000306c:	6aa2                	ld	s5,8(sp)
    8000306e:	6b02                	ld	s6,0(sp)
    80003070:	6121                	add	sp,sp,64
    80003072:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003074:	04000613          	li	a2,64
    80003078:	4581                	li	a1,0
    8000307a:	854e                	mv	a0,s3
    8000307c:	bf9fd0ef          	jal	80000c74 <memset>
      dip->type = type;
    80003080:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80003084:	8526                	mv	a0,s1
    80003086:	343000ef          	jal	80003bc8 <log_write>
      brelse(bp);
    8000308a:	8526                	mv	a0,s1
    8000308c:	a4bff0ef          	jal	80002ad6 <brelse>
      return iget(dev, inum);
    80003090:	0009059b          	sext.w	a1,s2
    80003094:	8556                	mv	a0,s5
    80003096:	de7ff0ef          	jal	80002e7c <iget>
    8000309a:	b7d9                	j	80003060 <ialloc+0x74>

000000008000309c <iupdate>:
{
    8000309c:	1101                	add	sp,sp,-32
    8000309e:	ec06                	sd	ra,24(sp)
    800030a0:	e822                	sd	s0,16(sp)
    800030a2:	e426                	sd	s1,8(sp)
    800030a4:	e04a                	sd	s2,0(sp)
    800030a6:	1000                	add	s0,sp,32
    800030a8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800030aa:	415c                	lw	a5,4(a0)
    800030ac:	0047d79b          	srlw	a5,a5,0x4
    800030b0:	0001b597          	auipc	a1,0x1b
    800030b4:	ea05a583          	lw	a1,-352(a1) # 8001df50 <sb+0x18>
    800030b8:	9dbd                	addw	a1,a1,a5
    800030ba:	4108                	lw	a0,0(a0)
    800030bc:	913ff0ef          	jal	800029ce <bread>
    800030c0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800030c2:	05850793          	add	a5,a0,88
    800030c6:	40d8                	lw	a4,4(s1)
    800030c8:	8b3d                	and	a4,a4,15
    800030ca:	071a                	sll	a4,a4,0x6
    800030cc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800030ce:	04449703          	lh	a4,68(s1)
    800030d2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800030d6:	04649703          	lh	a4,70(s1)
    800030da:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800030de:	04849703          	lh	a4,72(s1)
    800030e2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800030e6:	04a49703          	lh	a4,74(s1)
    800030ea:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800030ee:	44f8                	lw	a4,76(s1)
    800030f0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800030f2:	03000613          	li	a2,48
    800030f6:	05048593          	add	a1,s1,80
    800030fa:	00c78513          	add	a0,a5,12
    800030fe:	bd3fd0ef          	jal	80000cd0 <memmove>
  log_write(bp);
    80003102:	854a                	mv	a0,s2
    80003104:	2c5000ef          	jal	80003bc8 <log_write>
  brelse(bp);
    80003108:	854a                	mv	a0,s2
    8000310a:	9cdff0ef          	jal	80002ad6 <brelse>
}
    8000310e:	60e2                	ld	ra,24(sp)
    80003110:	6442                	ld	s0,16(sp)
    80003112:	64a2                	ld	s1,8(sp)
    80003114:	6902                	ld	s2,0(sp)
    80003116:	6105                	add	sp,sp,32
    80003118:	8082                	ret

000000008000311a <idup>:
{
    8000311a:	1101                	add	sp,sp,-32
    8000311c:	ec06                	sd	ra,24(sp)
    8000311e:	e822                	sd	s0,16(sp)
    80003120:	e426                	sd	s1,8(sp)
    80003122:	1000                	add	s0,sp,32
    80003124:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003126:	0001b517          	auipc	a0,0x1b
    8000312a:	e3250513          	add	a0,a0,-462 # 8001df58 <itable>
    8000312e:	a73fd0ef          	jal	80000ba0 <acquire>
  ip->ref++;
    80003132:	449c                	lw	a5,8(s1)
    80003134:	2785                	addw	a5,a5,1
    80003136:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003138:	0001b517          	auipc	a0,0x1b
    8000313c:	e2050513          	add	a0,a0,-480 # 8001df58 <itable>
    80003140:	af9fd0ef          	jal	80000c38 <release>
}
    80003144:	8526                	mv	a0,s1
    80003146:	60e2                	ld	ra,24(sp)
    80003148:	6442                	ld	s0,16(sp)
    8000314a:	64a2                	ld	s1,8(sp)
    8000314c:	6105                	add	sp,sp,32
    8000314e:	8082                	ret

0000000080003150 <ilock>:
{
    80003150:	1101                	add	sp,sp,-32
    80003152:	ec06                	sd	ra,24(sp)
    80003154:	e822                	sd	s0,16(sp)
    80003156:	e426                	sd	s1,8(sp)
    80003158:	e04a                	sd	s2,0(sp)
    8000315a:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000315c:	c105                	beqz	a0,8000317c <ilock+0x2c>
    8000315e:	84aa                	mv	s1,a0
    80003160:	451c                	lw	a5,8(a0)
    80003162:	00f05d63          	blez	a5,8000317c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003166:	0541                	add	a0,a0,16
    80003168:	367000ef          	jal	80003cce <acquiresleep>
  if(ip->valid == 0){
    8000316c:	40bc                	lw	a5,64(s1)
    8000316e:	cf89                	beqz	a5,80003188 <ilock+0x38>
}
    80003170:	60e2                	ld	ra,24(sp)
    80003172:	6442                	ld	s0,16(sp)
    80003174:	64a2                	ld	s1,8(sp)
    80003176:	6902                	ld	s2,0(sp)
    80003178:	6105                	add	sp,sp,32
    8000317a:	8082                	ret
    panic("ilock");
    8000317c:	00004517          	auipc	a0,0x4
    80003180:	49450513          	add	a0,a0,1172 # 80007610 <syscalls+0x180>
    80003184:	ddafd0ef          	jal	8000075e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003188:	40dc                	lw	a5,4(s1)
    8000318a:	0047d79b          	srlw	a5,a5,0x4
    8000318e:	0001b597          	auipc	a1,0x1b
    80003192:	dc25a583          	lw	a1,-574(a1) # 8001df50 <sb+0x18>
    80003196:	9dbd                	addw	a1,a1,a5
    80003198:	4088                	lw	a0,0(s1)
    8000319a:	835ff0ef          	jal	800029ce <bread>
    8000319e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800031a0:	05850593          	add	a1,a0,88
    800031a4:	40dc                	lw	a5,4(s1)
    800031a6:	8bbd                	and	a5,a5,15
    800031a8:	079a                	sll	a5,a5,0x6
    800031aa:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800031ac:	00059783          	lh	a5,0(a1)
    800031b0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800031b4:	00259783          	lh	a5,2(a1)
    800031b8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800031bc:	00459783          	lh	a5,4(a1)
    800031c0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800031c4:	00659783          	lh	a5,6(a1)
    800031c8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800031cc:	459c                	lw	a5,8(a1)
    800031ce:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800031d0:	03000613          	li	a2,48
    800031d4:	05b1                	add	a1,a1,12
    800031d6:	05048513          	add	a0,s1,80
    800031da:	af7fd0ef          	jal	80000cd0 <memmove>
    brelse(bp);
    800031de:	854a                	mv	a0,s2
    800031e0:	8f7ff0ef          	jal	80002ad6 <brelse>
    ip->valid = 1;
    800031e4:	4785                	li	a5,1
    800031e6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800031e8:	04449783          	lh	a5,68(s1)
    800031ec:	f3d1                	bnez	a5,80003170 <ilock+0x20>
      panic("ilock: no type");
    800031ee:	00004517          	auipc	a0,0x4
    800031f2:	42a50513          	add	a0,a0,1066 # 80007618 <syscalls+0x188>
    800031f6:	d68fd0ef          	jal	8000075e <panic>

00000000800031fa <iunlock>:
{
    800031fa:	1101                	add	sp,sp,-32
    800031fc:	ec06                	sd	ra,24(sp)
    800031fe:	e822                	sd	s0,16(sp)
    80003200:	e426                	sd	s1,8(sp)
    80003202:	e04a                	sd	s2,0(sp)
    80003204:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003206:	c505                	beqz	a0,8000322e <iunlock+0x34>
    80003208:	84aa                	mv	s1,a0
    8000320a:	01050913          	add	s2,a0,16
    8000320e:	854a                	mv	a0,s2
    80003210:	33d000ef          	jal	80003d4c <holdingsleep>
    80003214:	cd09                	beqz	a0,8000322e <iunlock+0x34>
    80003216:	449c                	lw	a5,8(s1)
    80003218:	00f05b63          	blez	a5,8000322e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000321c:	854a                	mv	a0,s2
    8000321e:	2f7000ef          	jal	80003d14 <releasesleep>
}
    80003222:	60e2                	ld	ra,24(sp)
    80003224:	6442                	ld	s0,16(sp)
    80003226:	64a2                	ld	s1,8(sp)
    80003228:	6902                	ld	s2,0(sp)
    8000322a:	6105                	add	sp,sp,32
    8000322c:	8082                	ret
    panic("iunlock");
    8000322e:	00004517          	auipc	a0,0x4
    80003232:	3fa50513          	add	a0,a0,1018 # 80007628 <syscalls+0x198>
    80003236:	d28fd0ef          	jal	8000075e <panic>

000000008000323a <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    8000323a:	715d                	add	sp,sp,-80
    8000323c:	e486                	sd	ra,72(sp)
    8000323e:	e0a2                	sd	s0,64(sp)
    80003240:	fc26                	sd	s1,56(sp)
    80003242:	f84a                	sd	s2,48(sp)
    80003244:	f44e                	sd	s3,40(sp)
    80003246:	f052                	sd	s4,32(sp)
    80003248:	ec56                	sd	s5,24(sp)
    8000324a:	e85a                	sd	s6,16(sp)
    8000324c:	e45e                	sd	s7,8(sp)
    8000324e:	e062                	sd	s8,0(sp)
    80003250:	0880                	add	s0,sp,80
    80003252:	89aa                	mv	s3,a0
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a, *b;
   
  /* Direct Data Block */ 
  for(i = 0; i < NDIRECT; i++){
    80003254:	05050493          	add	s1,a0,80
    80003258:	07c50913          	add	s2,a0,124
    8000325c:	a021                	j	80003264 <itrunc+0x2a>
    8000325e:	0491                	add	s1,s1,4
    80003260:	01248b63          	beq	s1,s2,80003276 <itrunc+0x3c>
    if(ip->addrs[i]){
    80003264:	408c                	lw	a1,0(s1)
    80003266:	dde5                	beqz	a1,8000325e <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    80003268:	0009a503          	lw	a0,0(s3)
    8000326c:	95bff0ef          	jal	80002bc6 <bfree>
      ip->addrs[i] = 0;
    80003270:	0004a023          	sw	zero,0(s1)
    80003274:	b7ed                	j	8000325e <itrunc+0x24>
    }
  }

  /* Singly Indirect Data Block */
  if(ip->addrs[NDIRECT]){
    80003276:	07c9a583          	lw	a1,124(s3)
    8000327a:	e58d                	bnez	a1,800032a4 <itrunc+0x6a>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  /* Doubly Indirect Data Block */
  if (ip->addrs[NDIRECT+1]){
    8000327c:	0809a583          	lw	a1,128(s3)
    80003280:	e1b5                	bnez	a1,800032e4 <itrunc+0xaa>
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    ip->addrs[NDIRECT + 1] = 0;
  }
  ip->size = 0;
    80003282:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003286:	854e                	mv	a0,s3
    80003288:	e15ff0ef          	jal	8000309c <iupdate>
}
    8000328c:	60a6                	ld	ra,72(sp)
    8000328e:	6406                	ld	s0,64(sp)
    80003290:	74e2                	ld	s1,56(sp)
    80003292:	7942                	ld	s2,48(sp)
    80003294:	79a2                	ld	s3,40(sp)
    80003296:	7a02                	ld	s4,32(sp)
    80003298:	6ae2                	ld	s5,24(sp)
    8000329a:	6b42                	ld	s6,16(sp)
    8000329c:	6ba2                	ld	s7,8(sp)
    8000329e:	6c02                	ld	s8,0(sp)
    800032a0:	6161                	add	sp,sp,80
    800032a2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800032a4:	0009a503          	lw	a0,0(s3)
    800032a8:	f26ff0ef          	jal	800029ce <bread>
    800032ac:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800032ae:	05850493          	add	s1,a0,88
    800032b2:	45850913          	add	s2,a0,1112
    800032b6:	a021                	j	800032be <itrunc+0x84>
    800032b8:	0491                	add	s1,s1,4
    800032ba:	01248963          	beq	s1,s2,800032cc <itrunc+0x92>
      if(a[j])
    800032be:	408c                	lw	a1,0(s1)
    800032c0:	dde5                	beqz	a1,800032b8 <itrunc+0x7e>
        bfree(ip->dev, a[j]);
    800032c2:	0009a503          	lw	a0,0(s3)
    800032c6:	901ff0ef          	jal	80002bc6 <bfree>
    800032ca:	b7fd                	j	800032b8 <itrunc+0x7e>
    brelse(bp);
    800032cc:	8552                	mv	a0,s4
    800032ce:	809ff0ef          	jal	80002ad6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800032d2:	07c9a583          	lw	a1,124(s3)
    800032d6:	0009a503          	lw	a0,0(s3)
    800032da:	8edff0ef          	jal	80002bc6 <bfree>
    ip->addrs[NDIRECT] = 0;
    800032de:	0609ae23          	sw	zero,124(s3)
    800032e2:	bf69                	j	8000327c <itrunc+0x42>
    bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    800032e4:	0009a503          	lw	a0,0(s3)
    800032e8:	ee6ff0ef          	jal	800029ce <bread>
    800032ec:	8c2a                	mv	s8,a0
    for (j = 0; j < NINDIRECT; j++){
    800032ee:	05850a13          	add	s4,a0,88
    800032f2:	45850b13          	add	s6,a0,1112
    800032f6:	a03d                	j	80003324 <itrunc+0xea>
	    for (k = 0; k < NINDIRECT; k++){
    800032f8:	0491                	add	s1,s1,4
    800032fa:	00990963          	beq	s2,s1,8000330c <itrunc+0xd2>
		if (b[k]){
    800032fe:	408c                	lw	a1,0(s1)
    80003300:	dde5                	beqz	a1,800032f8 <itrunc+0xbe>
		    bfree(ip->dev, b[k]);
    80003302:	0009a503          	lw	a0,0(s3)
    80003306:	8c1ff0ef          	jal	80002bc6 <bfree>
    8000330a:	b7fd                	j	800032f8 <itrunc+0xbe>
	    brelse(bp2);
    8000330c:	855e                	mv	a0,s7
    8000330e:	fc8ff0ef          	jal	80002ad6 <brelse>
	    bfree(ip->dev, a[j]);
    80003312:	000aa583          	lw	a1,0(s5)
    80003316:	0009a503          	lw	a0,0(s3)
    8000331a:	8adff0ef          	jal	80002bc6 <bfree>
    for (j = 0; j < NINDIRECT; j++){
    8000331e:	0a11                	add	s4,s4,4
    80003320:	034b0063          	beq	s6,s4,80003340 <itrunc+0x106>
	if (a[j]){
    80003324:	8ad2                	mv	s5,s4
    80003326:	000a2583          	lw	a1,0(s4)
    8000332a:	d9f5                	beqz	a1,8000331e <itrunc+0xe4>
	    bp2 = bread(ip->dev, a[j]);
    8000332c:	0009a503          	lw	a0,0(s3)
    80003330:	e9eff0ef          	jal	800029ce <bread>
    80003334:	8baa                	mv	s7,a0
	    for (k = 0; k < NINDIRECT; k++){
    80003336:	05850493          	add	s1,a0,88
    8000333a:	45850913          	add	s2,a0,1112
    8000333e:	b7c1                	j	800032fe <itrunc+0xc4>
    brelse(bp);
    80003340:	8562                	mv	a0,s8
    80003342:	f94ff0ef          	jal	80002ad6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80003346:	0809a583          	lw	a1,128(s3)
    8000334a:	0009a503          	lw	a0,0(s3)
    8000334e:	879ff0ef          	jal	80002bc6 <bfree>
    ip->addrs[NDIRECT + 1] = 0;
    80003352:	0809a023          	sw	zero,128(s3)
    80003356:	b735                	j	80003282 <itrunc+0x48>

0000000080003358 <iput>:
{
    80003358:	1101                	add	sp,sp,-32
    8000335a:	ec06                	sd	ra,24(sp)
    8000335c:	e822                	sd	s0,16(sp)
    8000335e:	e426                	sd	s1,8(sp)
    80003360:	e04a                	sd	s2,0(sp)
    80003362:	1000                	add	s0,sp,32
    80003364:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003366:	0001b517          	auipc	a0,0x1b
    8000336a:	bf250513          	add	a0,a0,-1038 # 8001df58 <itable>
    8000336e:	833fd0ef          	jal	80000ba0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003372:	4498                	lw	a4,8(s1)
    80003374:	4785                	li	a5,1
    80003376:	02f70163          	beq	a4,a5,80003398 <iput+0x40>
  ip->ref--;
    8000337a:	449c                	lw	a5,8(s1)
    8000337c:	37fd                	addw	a5,a5,-1
    8000337e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003380:	0001b517          	auipc	a0,0x1b
    80003384:	bd850513          	add	a0,a0,-1064 # 8001df58 <itable>
    80003388:	8b1fd0ef          	jal	80000c38 <release>
}
    8000338c:	60e2                	ld	ra,24(sp)
    8000338e:	6442                	ld	s0,16(sp)
    80003390:	64a2                	ld	s1,8(sp)
    80003392:	6902                	ld	s2,0(sp)
    80003394:	6105                	add	sp,sp,32
    80003396:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003398:	40bc                	lw	a5,64(s1)
    8000339a:	d3e5                	beqz	a5,8000337a <iput+0x22>
    8000339c:	04a49783          	lh	a5,74(s1)
    800033a0:	ffe9                	bnez	a5,8000337a <iput+0x22>
    acquiresleep(&ip->lock);
    800033a2:	01048913          	add	s2,s1,16
    800033a6:	854a                	mv	a0,s2
    800033a8:	127000ef          	jal	80003cce <acquiresleep>
    release(&itable.lock);
    800033ac:	0001b517          	auipc	a0,0x1b
    800033b0:	bac50513          	add	a0,a0,-1108 # 8001df58 <itable>
    800033b4:	885fd0ef          	jal	80000c38 <release>
    itrunc(ip);
    800033b8:	8526                	mv	a0,s1
    800033ba:	e81ff0ef          	jal	8000323a <itrunc>
    ip->type = 0;
    800033be:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800033c2:	8526                	mv	a0,s1
    800033c4:	cd9ff0ef          	jal	8000309c <iupdate>
    ip->valid = 0;
    800033c8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800033cc:	854a                	mv	a0,s2
    800033ce:	147000ef          	jal	80003d14 <releasesleep>
    acquire(&itable.lock);
    800033d2:	0001b517          	auipc	a0,0x1b
    800033d6:	b8650513          	add	a0,a0,-1146 # 8001df58 <itable>
    800033da:	fc6fd0ef          	jal	80000ba0 <acquire>
    800033de:	bf71                	j	8000337a <iput+0x22>

00000000800033e0 <iunlockput>:
{
    800033e0:	1101                	add	sp,sp,-32
    800033e2:	ec06                	sd	ra,24(sp)
    800033e4:	e822                	sd	s0,16(sp)
    800033e6:	e426                	sd	s1,8(sp)
    800033e8:	1000                	add	s0,sp,32
    800033ea:	84aa                	mv	s1,a0
  iunlock(ip);
    800033ec:	e0fff0ef          	jal	800031fa <iunlock>
  iput(ip);
    800033f0:	8526                	mv	a0,s1
    800033f2:	f67ff0ef          	jal	80003358 <iput>
}
    800033f6:	60e2                	ld	ra,24(sp)
    800033f8:	6442                	ld	s0,16(sp)
    800033fa:	64a2                	ld	s1,8(sp)
    800033fc:	6105                	add	sp,sp,32
    800033fe:	8082                	ret

0000000080003400 <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80003400:	1141                	add	sp,sp,-16
    80003402:	e422                	sd	s0,8(sp)
    80003404:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003406:	411c                	lw	a5,0(a0)
    80003408:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000340a:	415c                	lw	a5,4(a0)
    8000340c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000340e:	04451783          	lh	a5,68(a0)
    80003412:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003416:	04a51783          	lh	a5,74(a0)
    8000341a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000341e:	04c56783          	lwu	a5,76(a0)
    80003422:	e99c                	sd	a5,16(a1)
}
    80003424:	6422                	ld	s0,8(sp)
    80003426:	0141                	add	sp,sp,16
    80003428:	8082                	ret

000000008000342a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000342a:	457c                	lw	a5,76(a0)
    8000342c:	0cd7ef63          	bltu	a5,a3,8000350a <readi+0xe0>
{
    80003430:	7159                	add	sp,sp,-112
    80003432:	f486                	sd	ra,104(sp)
    80003434:	f0a2                	sd	s0,96(sp)
    80003436:	eca6                	sd	s1,88(sp)
    80003438:	e8ca                	sd	s2,80(sp)
    8000343a:	e4ce                	sd	s3,72(sp)
    8000343c:	e0d2                	sd	s4,64(sp)
    8000343e:	fc56                	sd	s5,56(sp)
    80003440:	f85a                	sd	s6,48(sp)
    80003442:	f45e                	sd	s7,40(sp)
    80003444:	f062                	sd	s8,32(sp)
    80003446:	ec66                	sd	s9,24(sp)
    80003448:	e86a                	sd	s10,16(sp)
    8000344a:	e46e                	sd	s11,8(sp)
    8000344c:	1880                	add	s0,sp,112
    8000344e:	8b2a                	mv	s6,a0
    80003450:	8bae                	mv	s7,a1
    80003452:	8a32                	mv	s4,a2
    80003454:	84b6                	mv	s1,a3
    80003456:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003458:	9f35                	addw	a4,a4,a3
    return 0;
    8000345a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000345c:	08d76663          	bltu	a4,a3,800034e8 <readi+0xbe>
  if(off + n > ip->size)
    80003460:	00e7f463          	bgeu	a5,a4,80003468 <readi+0x3e>
    n = ip->size - off;
    80003464:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003468:	080a8f63          	beqz	s5,80003506 <readi+0xdc>
    8000346c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000346e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003472:	5c7d                	li	s8,-1
    80003474:	a80d                	j	800034a6 <readi+0x7c>
    80003476:	020d1d93          	sll	s11,s10,0x20
    8000347a:	020ddd93          	srl	s11,s11,0x20
    8000347e:	05890613          	add	a2,s2,88
    80003482:	86ee                	mv	a3,s11
    80003484:	963a                	add	a2,a2,a4
    80003486:	85d2                	mv	a1,s4
    80003488:	855e                	mv	a0,s7
    8000348a:	ccffe0ef          	jal	80002158 <either_copyout>
    8000348e:	05850763          	beq	a0,s8,800034dc <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003492:	854a                	mv	a0,s2
    80003494:	e42ff0ef          	jal	80002ad6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003498:	013d09bb          	addw	s3,s10,s3
    8000349c:	009d04bb          	addw	s1,s10,s1
    800034a0:	9a6e                	add	s4,s4,s11
    800034a2:	0559f163          	bgeu	s3,s5,800034e4 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800034a6:	00a4d59b          	srlw	a1,s1,0xa
    800034aa:	855a                	mv	a0,s6
    800034ac:	895ff0ef          	jal	80002d40 <bmap>
    800034b0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034b4:	c985                	beqz	a1,800034e4 <readi+0xba>
    bp = bread(ip->dev, addr);
    800034b6:	000b2503          	lw	a0,0(s6)
    800034ba:	d14ff0ef          	jal	800029ce <bread>
    800034be:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034c0:	3ff4f713          	and	a4,s1,1023
    800034c4:	40ec87bb          	subw	a5,s9,a4
    800034c8:	413a86bb          	subw	a3,s5,s3
    800034cc:	8d3e                	mv	s10,a5
    800034ce:	2781                	sext.w	a5,a5
    800034d0:	0006861b          	sext.w	a2,a3
    800034d4:	faf671e3          	bgeu	a2,a5,80003476 <readi+0x4c>
    800034d8:	8d36                	mv	s10,a3
    800034da:	bf71                	j	80003476 <readi+0x4c>
      brelse(bp);
    800034dc:	854a                	mv	a0,s2
    800034de:	df8ff0ef          	jal	80002ad6 <brelse>
      tot = -1;
    800034e2:	59fd                	li	s3,-1
  }
  return tot;
    800034e4:	0009851b          	sext.w	a0,s3
}
    800034e8:	70a6                	ld	ra,104(sp)
    800034ea:	7406                	ld	s0,96(sp)
    800034ec:	64e6                	ld	s1,88(sp)
    800034ee:	6946                	ld	s2,80(sp)
    800034f0:	69a6                	ld	s3,72(sp)
    800034f2:	6a06                	ld	s4,64(sp)
    800034f4:	7ae2                	ld	s5,56(sp)
    800034f6:	7b42                	ld	s6,48(sp)
    800034f8:	7ba2                	ld	s7,40(sp)
    800034fa:	7c02                	ld	s8,32(sp)
    800034fc:	6ce2                	ld	s9,24(sp)
    800034fe:	6d42                	ld	s10,16(sp)
    80003500:	6da2                	ld	s11,8(sp)
    80003502:	6165                	add	sp,sp,112
    80003504:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003506:	89d6                	mv	s3,s5
    80003508:	bff1                	j	800034e4 <readi+0xba>
    return 0;
    8000350a:	4501                	li	a0,0
}
    8000350c:	8082                	ret

000000008000350e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000350e:	457c                	lw	a5,76(a0)
    80003510:	0ed7eb63          	bltu	a5,a3,80003606 <writei+0xf8>
{
    80003514:	7159                	add	sp,sp,-112
    80003516:	f486                	sd	ra,104(sp)
    80003518:	f0a2                	sd	s0,96(sp)
    8000351a:	eca6                	sd	s1,88(sp)
    8000351c:	e8ca                	sd	s2,80(sp)
    8000351e:	e4ce                	sd	s3,72(sp)
    80003520:	e0d2                	sd	s4,64(sp)
    80003522:	fc56                	sd	s5,56(sp)
    80003524:	f85a                	sd	s6,48(sp)
    80003526:	f45e                	sd	s7,40(sp)
    80003528:	f062                	sd	s8,32(sp)
    8000352a:	ec66                	sd	s9,24(sp)
    8000352c:	e86a                	sd	s10,16(sp)
    8000352e:	e46e                	sd	s11,8(sp)
    80003530:	1880                	add	s0,sp,112
    80003532:	8aaa                	mv	s5,a0
    80003534:	8bae                	mv	s7,a1
    80003536:	8a32                	mv	s4,a2
    80003538:	8936                	mv	s2,a3
    8000353a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000353c:	9f35                	addw	a4,a4,a3
    8000353e:	0cd76663          	bltu	a4,a3,8000360a <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003542:	040437b7          	lui	a5,0x4043
    80003546:	c0078793          	add	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    8000354a:	0ce7e263          	bltu	a5,a4,8000360e <writei+0x100>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000354e:	0a0b0a63          	beqz	s6,80003602 <writei+0xf4>
    80003552:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003554:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003558:	5c7d                	li	s8,-1
    8000355a:	a825                	j	80003592 <writei+0x84>
    8000355c:	020d1d93          	sll	s11,s10,0x20
    80003560:	020ddd93          	srl	s11,s11,0x20
    80003564:	05848513          	add	a0,s1,88
    80003568:	86ee                	mv	a3,s11
    8000356a:	8652                	mv	a2,s4
    8000356c:	85de                	mv	a1,s7
    8000356e:	953a                	add	a0,a0,a4
    80003570:	c33fe0ef          	jal	800021a2 <either_copyin>
    80003574:	05850a63          	beq	a0,s8,800035c8 <writei+0xba>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003578:	8526                	mv	a0,s1
    8000357a:	64e000ef          	jal	80003bc8 <log_write>
    brelse(bp);
    8000357e:	8526                	mv	a0,s1
    80003580:	d56ff0ef          	jal	80002ad6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003584:	013d09bb          	addw	s3,s10,s3
    80003588:	012d093b          	addw	s2,s10,s2
    8000358c:	9a6e                	add	s4,s4,s11
    8000358e:	0569f063          	bgeu	s3,s6,800035ce <writei+0xc0>
    uint addr = bmap(ip, off/BSIZE);
    80003592:	00a9559b          	srlw	a1,s2,0xa
    80003596:	8556                	mv	a0,s5
    80003598:	fa8ff0ef          	jal	80002d40 <bmap>
    8000359c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800035a0:	c59d                	beqz	a1,800035ce <writei+0xc0>
    bp = bread(ip->dev, addr);
    800035a2:	000aa503          	lw	a0,0(s5)
    800035a6:	c28ff0ef          	jal	800029ce <bread>
    800035aa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800035ac:	3ff97713          	and	a4,s2,1023
    800035b0:	40ec87bb          	subw	a5,s9,a4
    800035b4:	413b06bb          	subw	a3,s6,s3
    800035b8:	8d3e                	mv	s10,a5
    800035ba:	2781                	sext.w	a5,a5
    800035bc:	0006861b          	sext.w	a2,a3
    800035c0:	f8f67ee3          	bgeu	a2,a5,8000355c <writei+0x4e>
    800035c4:	8d36                	mv	s10,a3
    800035c6:	bf59                	j	8000355c <writei+0x4e>
      brelse(bp);
    800035c8:	8526                	mv	a0,s1
    800035ca:	d0cff0ef          	jal	80002ad6 <brelse>
  }

  if(off > ip->size)
    800035ce:	04caa783          	lw	a5,76(s5)
    800035d2:	0127f463          	bgeu	a5,s2,800035da <writei+0xcc>
    ip->size = off;
    800035d6:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    800035da:	8556                	mv	a0,s5
    800035dc:	ac1ff0ef          	jal	8000309c <iupdate>

  return tot;
    800035e0:	0009851b          	sext.w	a0,s3
}
    800035e4:	70a6                	ld	ra,104(sp)
    800035e6:	7406                	ld	s0,96(sp)
    800035e8:	64e6                	ld	s1,88(sp)
    800035ea:	6946                	ld	s2,80(sp)
    800035ec:	69a6                	ld	s3,72(sp)
    800035ee:	6a06                	ld	s4,64(sp)
    800035f0:	7ae2                	ld	s5,56(sp)
    800035f2:	7b42                	ld	s6,48(sp)
    800035f4:	7ba2                	ld	s7,40(sp)
    800035f6:	7c02                	ld	s8,32(sp)
    800035f8:	6ce2                	ld	s9,24(sp)
    800035fa:	6d42                	ld	s10,16(sp)
    800035fc:	6da2                	ld	s11,8(sp)
    800035fe:	6165                	add	sp,sp,112
    80003600:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003602:	89da                	mv	s3,s6
    80003604:	bfd9                	j	800035da <writei+0xcc>
    return -1;
    80003606:	557d                	li	a0,-1
}
    80003608:	8082                	ret
    return -1;
    8000360a:	557d                	li	a0,-1
    8000360c:	bfe1                	j	800035e4 <writei+0xd6>
    return -1;
    8000360e:	557d                	li	a0,-1
    80003610:	bfd1                	j	800035e4 <writei+0xd6>

0000000080003612 <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    80003612:	1141                	add	sp,sp,-16
    80003614:	e406                	sd	ra,8(sp)
    80003616:	e022                	sd	s0,0(sp)
    80003618:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000361a:	4639                	li	a2,14
    8000361c:	f24fd0ef          	jal	80000d40 <strncmp>
}
    80003620:	60a2                	ld	ra,8(sp)
    80003622:	6402                	ld	s0,0(sp)
    80003624:	0141                	add	sp,sp,16
    80003626:	8082                	ret

0000000080003628 <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003628:	7139                	add	sp,sp,-64
    8000362a:	fc06                	sd	ra,56(sp)
    8000362c:	f822                	sd	s0,48(sp)
    8000362e:	f426                	sd	s1,40(sp)
    80003630:	f04a                	sd	s2,32(sp)
    80003632:	ec4e                	sd	s3,24(sp)
    80003634:	e852                	sd	s4,16(sp)
    80003636:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003638:	04451703          	lh	a4,68(a0)
    8000363c:	4785                	li	a5,1
    8000363e:	00f71a63          	bne	a4,a5,80003652 <dirlookup+0x2a>
    80003642:	892a                	mv	s2,a0
    80003644:	89ae                	mv	s3,a1
    80003646:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003648:	457c                	lw	a5,76(a0)
    8000364a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000364c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000364e:	e39d                	bnez	a5,80003674 <dirlookup+0x4c>
    80003650:	a095                	j	800036b4 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003652:	00004517          	auipc	a0,0x4
    80003656:	fde50513          	add	a0,a0,-34 # 80007630 <syscalls+0x1a0>
    8000365a:	904fd0ef          	jal	8000075e <panic>
      panic("dirlookup read");
    8000365e:	00004517          	auipc	a0,0x4
    80003662:	fea50513          	add	a0,a0,-22 # 80007648 <syscalls+0x1b8>
    80003666:	8f8fd0ef          	jal	8000075e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000366a:	24c1                	addw	s1,s1,16
    8000366c:	04c92783          	lw	a5,76(s2)
    80003670:	04f4f163          	bgeu	s1,a5,800036b2 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003674:	4741                	li	a4,16
    80003676:	86a6                	mv	a3,s1
    80003678:	fc040613          	add	a2,s0,-64
    8000367c:	4581                	li	a1,0
    8000367e:	854a                	mv	a0,s2
    80003680:	dabff0ef          	jal	8000342a <readi>
    80003684:	47c1                	li	a5,16
    80003686:	fcf51ce3          	bne	a0,a5,8000365e <dirlookup+0x36>
    if(de.inum == 0)
    8000368a:	fc045783          	lhu	a5,-64(s0)
    8000368e:	dff1                	beqz	a5,8000366a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003690:	fc240593          	add	a1,s0,-62
    80003694:	854e                	mv	a0,s3
    80003696:	f7dff0ef          	jal	80003612 <namecmp>
    8000369a:	f961                	bnez	a0,8000366a <dirlookup+0x42>
      if(poff)
    8000369c:	000a0463          	beqz	s4,800036a4 <dirlookup+0x7c>
        *poff = off;
    800036a0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800036a4:	fc045583          	lhu	a1,-64(s0)
    800036a8:	00092503          	lw	a0,0(s2)
    800036ac:	fd0ff0ef          	jal	80002e7c <iget>
    800036b0:	a011                	j	800036b4 <dirlookup+0x8c>
  return 0;
    800036b2:	4501                	li	a0,0
}
    800036b4:	70e2                	ld	ra,56(sp)
    800036b6:	7442                	ld	s0,48(sp)
    800036b8:	74a2                	ld	s1,40(sp)
    800036ba:	7902                	ld	s2,32(sp)
    800036bc:	69e2                	ld	s3,24(sp)
    800036be:	6a42                	ld	s4,16(sp)
    800036c0:	6121                	add	sp,sp,64
    800036c2:	8082                	ret

00000000800036c4 <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800036c4:	711d                	add	sp,sp,-96
    800036c6:	ec86                	sd	ra,88(sp)
    800036c8:	e8a2                	sd	s0,80(sp)
    800036ca:	e4a6                	sd	s1,72(sp)
    800036cc:	e0ca                	sd	s2,64(sp)
    800036ce:	fc4e                	sd	s3,56(sp)
    800036d0:	f852                	sd	s4,48(sp)
    800036d2:	f456                	sd	s5,40(sp)
    800036d4:	f05a                	sd	s6,32(sp)
    800036d6:	ec5e                	sd	s7,24(sp)
    800036d8:	e862                	sd	s8,16(sp)
    800036da:	e466                	sd	s9,8(sp)
    800036dc:	1080                	add	s0,sp,96
    800036de:	84aa                	mv	s1,a0
    800036e0:	8b2e                	mv	s6,a1
    800036e2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800036e4:	00054703          	lbu	a4,0(a0)
    800036e8:	02f00793          	li	a5,47
    800036ec:	00f70e63          	beq	a4,a5,80003708 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800036f0:	940fe0ef          	jal	80001830 <myproc>
    800036f4:	15053503          	ld	a0,336(a0)
    800036f8:	a23ff0ef          	jal	8000311a <idup>
    800036fc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800036fe:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003702:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003704:	4b85                	li	s7,1
    80003706:	a871                	j	800037a2 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003708:	4585                	li	a1,1
    8000370a:	4505                	li	a0,1
    8000370c:	f70ff0ef          	jal	80002e7c <iget>
    80003710:	8a2a                	mv	s4,a0
    80003712:	b7f5                	j	800036fe <namex+0x3a>
      iunlockput(ip);
    80003714:	8552                	mv	a0,s4
    80003716:	ccbff0ef          	jal	800033e0 <iunlockput>
      return 0;
    8000371a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000371c:	8552                	mv	a0,s4
    8000371e:	60e6                	ld	ra,88(sp)
    80003720:	6446                	ld	s0,80(sp)
    80003722:	64a6                	ld	s1,72(sp)
    80003724:	6906                	ld	s2,64(sp)
    80003726:	79e2                	ld	s3,56(sp)
    80003728:	7a42                	ld	s4,48(sp)
    8000372a:	7aa2                	ld	s5,40(sp)
    8000372c:	7b02                	ld	s6,32(sp)
    8000372e:	6be2                	ld	s7,24(sp)
    80003730:	6c42                	ld	s8,16(sp)
    80003732:	6ca2                	ld	s9,8(sp)
    80003734:	6125                	add	sp,sp,96
    80003736:	8082                	ret
      iunlock(ip);
    80003738:	8552                	mv	a0,s4
    8000373a:	ac1ff0ef          	jal	800031fa <iunlock>
      return ip;
    8000373e:	bff9                	j	8000371c <namex+0x58>
      iunlockput(ip);
    80003740:	8552                	mv	a0,s4
    80003742:	c9fff0ef          	jal	800033e0 <iunlockput>
      return 0;
    80003746:	8a4e                	mv	s4,s3
    80003748:	bfd1                	j	8000371c <namex+0x58>
  len = path - s;
    8000374a:	40998633          	sub	a2,s3,s1
    8000374e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003752:	099c5063          	bge	s8,s9,800037d2 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003756:	4639                	li	a2,14
    80003758:	85a6                	mv	a1,s1
    8000375a:	8556                	mv	a0,s5
    8000375c:	d74fd0ef          	jal	80000cd0 <memmove>
    80003760:	84ce                	mv	s1,s3
  while(*path == '/')
    80003762:	0004c783          	lbu	a5,0(s1)
    80003766:	01279763          	bne	a5,s2,80003774 <namex+0xb0>
    path++;
    8000376a:	0485                	add	s1,s1,1
  while(*path == '/')
    8000376c:	0004c783          	lbu	a5,0(s1)
    80003770:	ff278de3          	beq	a5,s2,8000376a <namex+0xa6>
    ilock(ip);
    80003774:	8552                	mv	a0,s4
    80003776:	9dbff0ef          	jal	80003150 <ilock>
    if(ip->type != T_DIR){
    8000377a:	044a1783          	lh	a5,68(s4)
    8000377e:	f9779be3          	bne	a5,s7,80003714 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003782:	000b0563          	beqz	s6,8000378c <namex+0xc8>
    80003786:	0004c783          	lbu	a5,0(s1)
    8000378a:	d7dd                	beqz	a5,80003738 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000378c:	4601                	li	a2,0
    8000378e:	85d6                	mv	a1,s5
    80003790:	8552                	mv	a0,s4
    80003792:	e97ff0ef          	jal	80003628 <dirlookup>
    80003796:	89aa                	mv	s3,a0
    80003798:	d545                	beqz	a0,80003740 <namex+0x7c>
    iunlockput(ip);
    8000379a:	8552                	mv	a0,s4
    8000379c:	c45ff0ef          	jal	800033e0 <iunlockput>
    ip = next;
    800037a0:	8a4e                	mv	s4,s3
  while(*path == '/')
    800037a2:	0004c783          	lbu	a5,0(s1)
    800037a6:	01279763          	bne	a5,s2,800037b4 <namex+0xf0>
    path++;
    800037aa:	0485                	add	s1,s1,1
  while(*path == '/')
    800037ac:	0004c783          	lbu	a5,0(s1)
    800037b0:	ff278de3          	beq	a5,s2,800037aa <namex+0xe6>
  if(*path == 0)
    800037b4:	cb8d                	beqz	a5,800037e6 <namex+0x122>
  while(*path != '/' && *path != 0)
    800037b6:	0004c783          	lbu	a5,0(s1)
    800037ba:	89a6                	mv	s3,s1
  len = path - s;
    800037bc:	4c81                	li	s9,0
    800037be:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800037c0:	01278963          	beq	a5,s2,800037d2 <namex+0x10e>
    800037c4:	d3d9                	beqz	a5,8000374a <namex+0x86>
    path++;
    800037c6:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800037c8:	0009c783          	lbu	a5,0(s3)
    800037cc:	ff279ce3          	bne	a5,s2,800037c4 <namex+0x100>
    800037d0:	bfad                	j	8000374a <namex+0x86>
    memmove(name, s, len);
    800037d2:	2601                	sext.w	a2,a2
    800037d4:	85a6                	mv	a1,s1
    800037d6:	8556                	mv	a0,s5
    800037d8:	cf8fd0ef          	jal	80000cd0 <memmove>
    name[len] = 0;
    800037dc:	9cd6                	add	s9,s9,s5
    800037de:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800037e2:	84ce                	mv	s1,s3
    800037e4:	bfbd                	j	80003762 <namex+0x9e>
  if(nameiparent){
    800037e6:	f20b0be3          	beqz	s6,8000371c <namex+0x58>
    iput(ip);
    800037ea:	8552                	mv	a0,s4
    800037ec:	b6dff0ef          	jal	80003358 <iput>
    return 0;
    800037f0:	4a01                	li	s4,0
    800037f2:	b72d                	j	8000371c <namex+0x58>

00000000800037f4 <dirlink>:
{
    800037f4:	7139                	add	sp,sp,-64
    800037f6:	fc06                	sd	ra,56(sp)
    800037f8:	f822                	sd	s0,48(sp)
    800037fa:	f426                	sd	s1,40(sp)
    800037fc:	f04a                	sd	s2,32(sp)
    800037fe:	ec4e                	sd	s3,24(sp)
    80003800:	e852                	sd	s4,16(sp)
    80003802:	0080                	add	s0,sp,64
    80003804:	892a                	mv	s2,a0
    80003806:	8a2e                	mv	s4,a1
    80003808:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000380a:	4601                	li	a2,0
    8000380c:	e1dff0ef          	jal	80003628 <dirlookup>
    80003810:	e52d                	bnez	a0,8000387a <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003812:	04c92483          	lw	s1,76(s2)
    80003816:	c48d                	beqz	s1,80003840 <dirlink+0x4c>
    80003818:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000381a:	4741                	li	a4,16
    8000381c:	86a6                	mv	a3,s1
    8000381e:	fc040613          	add	a2,s0,-64
    80003822:	4581                	li	a1,0
    80003824:	854a                	mv	a0,s2
    80003826:	c05ff0ef          	jal	8000342a <readi>
    8000382a:	47c1                	li	a5,16
    8000382c:	04f51b63          	bne	a0,a5,80003882 <dirlink+0x8e>
    if(de.inum == 0)
    80003830:	fc045783          	lhu	a5,-64(s0)
    80003834:	c791                	beqz	a5,80003840 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003836:	24c1                	addw	s1,s1,16
    80003838:	04c92783          	lw	a5,76(s2)
    8000383c:	fcf4efe3          	bltu	s1,a5,8000381a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003840:	4639                	li	a2,14
    80003842:	85d2                	mv	a1,s4
    80003844:	fc240513          	add	a0,s0,-62
    80003848:	d34fd0ef          	jal	80000d7c <strncpy>
  de.inum = inum;
    8000384c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003850:	4741                	li	a4,16
    80003852:	86a6                	mv	a3,s1
    80003854:	fc040613          	add	a2,s0,-64
    80003858:	4581                	li	a1,0
    8000385a:	854a                	mv	a0,s2
    8000385c:	cb3ff0ef          	jal	8000350e <writei>
    80003860:	1541                	add	a0,a0,-16
    80003862:	00a03533          	snez	a0,a0
    80003866:	40a00533          	neg	a0,a0
}
    8000386a:	70e2                	ld	ra,56(sp)
    8000386c:	7442                	ld	s0,48(sp)
    8000386e:	74a2                	ld	s1,40(sp)
    80003870:	7902                	ld	s2,32(sp)
    80003872:	69e2                	ld	s3,24(sp)
    80003874:	6a42                	ld	s4,16(sp)
    80003876:	6121                	add	sp,sp,64
    80003878:	8082                	ret
    iput(ip);
    8000387a:	adfff0ef          	jal	80003358 <iput>
    return -1;
    8000387e:	557d                	li	a0,-1
    80003880:	b7ed                	j	8000386a <dirlink+0x76>
      panic("dirlink read");
    80003882:	00004517          	auipc	a0,0x4
    80003886:	dd650513          	add	a0,a0,-554 # 80007658 <syscalls+0x1c8>
    8000388a:	ed5fc0ef          	jal	8000075e <panic>

000000008000388e <namei>:

struct inode*
namei(char *path)
{
    8000388e:	1101                	add	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003896:	fe040613          	add	a2,s0,-32
    8000389a:	4581                	li	a1,0
    8000389c:	e29ff0ef          	jal	800036c4 <namex>
}
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	6105                	add	sp,sp,32
    800038a6:	8082                	ret

00000000800038a8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800038a8:	1141                	add	sp,sp,-16
    800038aa:	e406                	sd	ra,8(sp)
    800038ac:	e022                	sd	s0,0(sp)
    800038ae:	0800                	add	s0,sp,16
    800038b0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800038b2:	4585                	li	a1,1
    800038b4:	e11ff0ef          	jal	800036c4 <namex>
}
    800038b8:	60a2                	ld	ra,8(sp)
    800038ba:	6402                	ld	s0,0(sp)
    800038bc:	0141                	add	sp,sp,16
    800038be:	8082                	ret

00000000800038c0 <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    800038c0:	1101                	add	sp,sp,-32
    800038c2:	ec06                	sd	ra,24(sp)
    800038c4:	e822                	sd	s0,16(sp)
    800038c6:	e426                	sd	s1,8(sp)
    800038c8:	e04a                	sd	s2,0(sp)
    800038ca:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800038cc:	0001c917          	auipc	s2,0x1c
    800038d0:	fa490913          	add	s2,s2,-92 # 8001f870 <log>
    800038d4:	01892583          	lw	a1,24(s2)
    800038d8:	02892503          	lw	a0,40(s2)
    800038dc:	8f2ff0ef          	jal	800029ce <bread>
    800038e0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800038e2:	02c92603          	lw	a2,44(s2)
    800038e6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800038e8:	00c05f63          	blez	a2,80003906 <write_head+0x46>
    800038ec:	0001c717          	auipc	a4,0x1c
    800038f0:	fb470713          	add	a4,a4,-76 # 8001f8a0 <log+0x30>
    800038f4:	87aa                	mv	a5,a0
    800038f6:	060a                	sll	a2,a2,0x2
    800038f8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800038fa:	4314                	lw	a3,0(a4)
    800038fc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800038fe:	0711                	add	a4,a4,4
    80003900:	0791                	add	a5,a5,4
    80003902:	fec79ce3          	bne	a5,a2,800038fa <write_head+0x3a>
  }
  bwrite(buf);
    80003906:	8526                	mv	a0,s1
    80003908:	99cff0ef          	jal	80002aa4 <bwrite>
  brelse(buf);
    8000390c:	8526                	mv	a0,s1
    8000390e:	9c8ff0ef          	jal	80002ad6 <brelse>
}
    80003912:	60e2                	ld	ra,24(sp)
    80003914:	6442                	ld	s0,16(sp)
    80003916:	64a2                	ld	s1,8(sp)
    80003918:	6902                	ld	s2,0(sp)
    8000391a:	6105                	add	sp,sp,32
    8000391c:	8082                	ret

000000008000391e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000391e:	0001c797          	auipc	a5,0x1c
    80003922:	f7e7a783          	lw	a5,-130(a5) # 8001f89c <log+0x2c>
    80003926:	08f05f63          	blez	a5,800039c4 <install_trans+0xa6>
{
    8000392a:	7139                	add	sp,sp,-64
    8000392c:	fc06                	sd	ra,56(sp)
    8000392e:	f822                	sd	s0,48(sp)
    80003930:	f426                	sd	s1,40(sp)
    80003932:	f04a                	sd	s2,32(sp)
    80003934:	ec4e                	sd	s3,24(sp)
    80003936:	e852                	sd	s4,16(sp)
    80003938:	e456                	sd	s5,8(sp)
    8000393a:	e05a                	sd	s6,0(sp)
    8000393c:	0080                	add	s0,sp,64
    8000393e:	8b2a                	mv	s6,a0
    80003940:	0001ca97          	auipc	s5,0x1c
    80003944:	f60a8a93          	add	s5,s5,-160 # 8001f8a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003948:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    8000394a:	0001c997          	auipc	s3,0x1c
    8000394e:	f2698993          	add	s3,s3,-218 # 8001f870 <log>
    80003952:	a829                	j	8000396c <install_trans+0x4e>
    brelse(lbuf);
    80003954:	854a                	mv	a0,s2
    80003956:	980ff0ef          	jal	80002ad6 <brelse>
    brelse(dbuf);
    8000395a:	8526                	mv	a0,s1
    8000395c:	97aff0ef          	jal	80002ad6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003960:	2a05                	addw	s4,s4,1
    80003962:	0a91                	add	s5,s5,4
    80003964:	02c9a783          	lw	a5,44(s3)
    80003968:	04fa5463          	bge	s4,a5,800039b0 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    8000396c:	0189a583          	lw	a1,24(s3)
    80003970:	014585bb          	addw	a1,a1,s4
    80003974:	2585                	addw	a1,a1,1
    80003976:	0289a503          	lw	a0,40(s3)
    8000397a:	854ff0ef          	jal	800029ce <bread>
    8000397e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    80003980:	000aa583          	lw	a1,0(s5)
    80003984:	0289a503          	lw	a0,40(s3)
    80003988:	846ff0ef          	jal	800029ce <bread>
    8000398c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    8000398e:	40000613          	li	a2,1024
    80003992:	05890593          	add	a1,s2,88
    80003996:	05850513          	add	a0,a0,88
    8000399a:	b36fd0ef          	jal	80000cd0 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    8000399e:	8526                	mv	a0,s1
    800039a0:	904ff0ef          	jal	80002aa4 <bwrite>
    if(recovering == 0)
    800039a4:	fa0b18e3          	bnez	s6,80003954 <install_trans+0x36>
      bunpin(dbuf);
    800039a8:	8526                	mv	a0,s1
    800039aa:	9e8ff0ef          	jal	80002b92 <bunpin>
    800039ae:	b75d                	j	80003954 <install_trans+0x36>
}
    800039b0:	70e2                	ld	ra,56(sp)
    800039b2:	7442                	ld	s0,48(sp)
    800039b4:	74a2                	ld	s1,40(sp)
    800039b6:	7902                	ld	s2,32(sp)
    800039b8:	69e2                	ld	s3,24(sp)
    800039ba:	6a42                	ld	s4,16(sp)
    800039bc:	6aa2                	ld	s5,8(sp)
    800039be:	6b02                	ld	s6,0(sp)
    800039c0:	6121                	add	sp,sp,64
    800039c2:	8082                	ret
    800039c4:	8082                	ret

00000000800039c6 <initlog>:
{
    800039c6:	7179                	add	sp,sp,-48
    800039c8:	f406                	sd	ra,40(sp)
    800039ca:	f022                	sd	s0,32(sp)
    800039cc:	ec26                	sd	s1,24(sp)
    800039ce:	e84a                	sd	s2,16(sp)
    800039d0:	e44e                	sd	s3,8(sp)
    800039d2:	1800                	add	s0,sp,48
    800039d4:	892a                	mv	s2,a0
    800039d6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800039d8:	0001c497          	auipc	s1,0x1c
    800039dc:	e9848493          	add	s1,s1,-360 # 8001f870 <log>
    800039e0:	00004597          	auipc	a1,0x4
    800039e4:	c8858593          	add	a1,a1,-888 # 80007668 <syscalls+0x1d8>
    800039e8:	8526                	mv	a0,s1
    800039ea:	936fd0ef          	jal	80000b20 <initlock>
  log.start = sb->logstart;
    800039ee:	0149a583          	lw	a1,20(s3)
    800039f2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800039f4:	0109a783          	lw	a5,16(s3)
    800039f8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800039fa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800039fe:	854a                	mv	a0,s2
    80003a00:	fcffe0ef          	jal	800029ce <bread>
  log.lh.n = lh->n;
    80003a04:	4d30                	lw	a2,88(a0)
    80003a06:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003a08:	00c05f63          	blez	a2,80003a26 <initlog+0x60>
    80003a0c:	87aa                	mv	a5,a0
    80003a0e:	0001c717          	auipc	a4,0x1c
    80003a12:	e9270713          	add	a4,a4,-366 # 8001f8a0 <log+0x30>
    80003a16:	060a                	sll	a2,a2,0x2
    80003a18:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003a1a:	4ff4                	lw	a3,92(a5)
    80003a1c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003a1e:	0791                	add	a5,a5,4
    80003a20:	0711                	add	a4,a4,4
    80003a22:	fec79ce3          	bne	a5,a2,80003a1a <initlog+0x54>
  brelse(buf);
    80003a26:	8b0ff0ef          	jal	80002ad6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    80003a2a:	4505                	li	a0,1
    80003a2c:	ef3ff0ef          	jal	8000391e <install_trans>
  log.lh.n = 0;
    80003a30:	0001c797          	auipc	a5,0x1c
    80003a34:	e607a623          	sw	zero,-404(a5) # 8001f89c <log+0x2c>
  write_head(); /* clear the log */
    80003a38:	e89ff0ef          	jal	800038c0 <write_head>
}
    80003a3c:	70a2                	ld	ra,40(sp)
    80003a3e:	7402                	ld	s0,32(sp)
    80003a40:	64e2                	ld	s1,24(sp)
    80003a42:	6942                	ld	s2,16(sp)
    80003a44:	69a2                	ld	s3,8(sp)
    80003a46:	6145                	add	sp,sp,48
    80003a48:	8082                	ret

0000000080003a4a <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    80003a4a:	1101                	add	sp,sp,-32
    80003a4c:	ec06                	sd	ra,24(sp)
    80003a4e:	e822                	sd	s0,16(sp)
    80003a50:	e426                	sd	s1,8(sp)
    80003a52:	e04a                	sd	s2,0(sp)
    80003a54:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003a56:	0001c517          	auipc	a0,0x1c
    80003a5a:	e1a50513          	add	a0,a0,-486 # 8001f870 <log>
    80003a5e:	942fd0ef          	jal	80000ba0 <acquire>
  while(1){
    if(log.committing){
    80003a62:	0001c497          	auipc	s1,0x1c
    80003a66:	e0e48493          	add	s1,s1,-498 # 8001f870 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a6a:	4979                	li	s2,30
    80003a6c:	a029                	j	80003a76 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003a6e:	85a6                	mv	a1,s1
    80003a70:	8526                	mv	a0,s1
    80003a72:	b8afe0ef          	jal	80001dfc <sleep>
    if(log.committing){
    80003a76:	50dc                	lw	a5,36(s1)
    80003a78:	fbfd                	bnez	a5,80003a6e <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003a7a:	5098                	lw	a4,32(s1)
    80003a7c:	2705                	addw	a4,a4,1
    80003a7e:	0027179b          	sllw	a5,a4,0x2
    80003a82:	9fb9                	addw	a5,a5,a4
    80003a84:	0017979b          	sllw	a5,a5,0x1
    80003a88:	54d4                	lw	a3,44(s1)
    80003a8a:	9fb5                	addw	a5,a5,a3
    80003a8c:	00f95763          	bge	s2,a5,80003a9a <begin_op+0x50>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    80003a90:	85a6                	mv	a1,s1
    80003a92:	8526                	mv	a0,s1
    80003a94:	b68fe0ef          	jal	80001dfc <sleep>
    80003a98:	bff9                	j	80003a76 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003a9a:	0001c517          	auipc	a0,0x1c
    80003a9e:	dd650513          	add	a0,a0,-554 # 8001f870 <log>
    80003aa2:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003aa4:	994fd0ef          	jal	80000c38 <release>
      break;
    }
  }
}
    80003aa8:	60e2                	ld	ra,24(sp)
    80003aaa:	6442                	ld	s0,16(sp)
    80003aac:	64a2                	ld	s1,8(sp)
    80003aae:	6902                	ld	s2,0(sp)
    80003ab0:	6105                	add	sp,sp,32
    80003ab2:	8082                	ret

0000000080003ab4 <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    80003ab4:	7139                	add	sp,sp,-64
    80003ab6:	fc06                	sd	ra,56(sp)
    80003ab8:	f822                	sd	s0,48(sp)
    80003aba:	f426                	sd	s1,40(sp)
    80003abc:	f04a                	sd	s2,32(sp)
    80003abe:	ec4e                	sd	s3,24(sp)
    80003ac0:	e852                	sd	s4,16(sp)
    80003ac2:	e456                	sd	s5,8(sp)
    80003ac4:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003ac6:	0001c497          	auipc	s1,0x1c
    80003aca:	daa48493          	add	s1,s1,-598 # 8001f870 <log>
    80003ace:	8526                	mv	a0,s1
    80003ad0:	8d0fd0ef          	jal	80000ba0 <acquire>
  log.outstanding -= 1;
    80003ad4:	509c                	lw	a5,32(s1)
    80003ad6:	37fd                	addw	a5,a5,-1
    80003ad8:	0007891b          	sext.w	s2,a5
    80003adc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003ade:	50dc                	lw	a5,36(s1)
    80003ae0:	ef9d                	bnez	a5,80003b1e <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003ae2:	04091463          	bnez	s2,80003b2a <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003ae6:	0001c497          	auipc	s1,0x1c
    80003aea:	d8a48493          	add	s1,s1,-630 # 8001f870 <log>
    80003aee:	4785                	li	a5,1
    80003af0:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    80003af2:	8526                	mv	a0,s1
    80003af4:	944fd0ef          	jal	80000c38 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003af8:	54dc                	lw	a5,44(s1)
    80003afa:	04f04b63          	bgtz	a5,80003b50 <end_op+0x9c>
    acquire(&log.lock);
    80003afe:	0001c497          	auipc	s1,0x1c
    80003b02:	d7248493          	add	s1,s1,-654 # 8001f870 <log>
    80003b06:	8526                	mv	a0,s1
    80003b08:	898fd0ef          	jal	80000ba0 <acquire>
    log.committing = 0;
    80003b0c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003b10:	8526                	mv	a0,s1
    80003b12:	b36fe0ef          	jal	80001e48 <wakeup>
    release(&log.lock);
    80003b16:	8526                	mv	a0,s1
    80003b18:	920fd0ef          	jal	80000c38 <release>
}
    80003b1c:	a00d                	j	80003b3e <end_op+0x8a>
    panic("log.committing");
    80003b1e:	00004517          	auipc	a0,0x4
    80003b22:	b5250513          	add	a0,a0,-1198 # 80007670 <syscalls+0x1e0>
    80003b26:	c39fc0ef          	jal	8000075e <panic>
    wakeup(&log);
    80003b2a:	0001c497          	auipc	s1,0x1c
    80003b2e:	d4648493          	add	s1,s1,-698 # 8001f870 <log>
    80003b32:	8526                	mv	a0,s1
    80003b34:	b14fe0ef          	jal	80001e48 <wakeup>
  release(&log.lock);
    80003b38:	8526                	mv	a0,s1
    80003b3a:	8fefd0ef          	jal	80000c38 <release>
}
    80003b3e:	70e2                	ld	ra,56(sp)
    80003b40:	7442                	ld	s0,48(sp)
    80003b42:	74a2                	ld	s1,40(sp)
    80003b44:	7902                	ld	s2,32(sp)
    80003b46:	69e2                	ld	s3,24(sp)
    80003b48:	6a42                	ld	s4,16(sp)
    80003b4a:	6aa2                	ld	s5,8(sp)
    80003b4c:	6121                	add	sp,sp,64
    80003b4e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b50:	0001ca97          	auipc	s5,0x1c
    80003b54:	d50a8a93          	add	s5,s5,-688 # 8001f8a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    80003b58:	0001ca17          	auipc	s4,0x1c
    80003b5c:	d18a0a13          	add	s4,s4,-744 # 8001f870 <log>
    80003b60:	018a2583          	lw	a1,24(s4)
    80003b64:	012585bb          	addw	a1,a1,s2
    80003b68:	2585                	addw	a1,a1,1
    80003b6a:	028a2503          	lw	a0,40(s4)
    80003b6e:	e61fe0ef          	jal	800029ce <bread>
    80003b72:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    80003b74:	000aa583          	lw	a1,0(s5)
    80003b78:	028a2503          	lw	a0,40(s4)
    80003b7c:	e53fe0ef          	jal	800029ce <bread>
    80003b80:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003b82:	40000613          	li	a2,1024
    80003b86:	05850593          	add	a1,a0,88
    80003b8a:	05848513          	add	a0,s1,88
    80003b8e:	942fd0ef          	jal	80000cd0 <memmove>
    bwrite(to);  /* write the log */
    80003b92:	8526                	mv	a0,s1
    80003b94:	f11fe0ef          	jal	80002aa4 <bwrite>
    brelse(from);
    80003b98:	854e                	mv	a0,s3
    80003b9a:	f3dfe0ef          	jal	80002ad6 <brelse>
    brelse(to);
    80003b9e:	8526                	mv	a0,s1
    80003ba0:	f37fe0ef          	jal	80002ad6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ba4:	2905                	addw	s2,s2,1
    80003ba6:	0a91                	add	s5,s5,4
    80003ba8:	02ca2783          	lw	a5,44(s4)
    80003bac:	faf94ae3          	blt	s2,a5,80003b60 <end_op+0xac>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    80003bb0:	d11ff0ef          	jal	800038c0 <write_head>
    install_trans(0); /* Now install writes to home locations */
    80003bb4:	4501                	li	a0,0
    80003bb6:	d69ff0ef          	jal	8000391e <install_trans>
    log.lh.n = 0;
    80003bba:	0001c797          	auipc	a5,0x1c
    80003bbe:	ce07a123          	sw	zero,-798(a5) # 8001f89c <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    80003bc2:	cffff0ef          	jal	800038c0 <write_head>
    80003bc6:	bf25                	j	80003afe <end_op+0x4a>

0000000080003bc8 <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    80003bc8:	1101                	add	sp,sp,-32
    80003bca:	ec06                	sd	ra,24(sp)
    80003bcc:	e822                	sd	s0,16(sp)
    80003bce:	e426                	sd	s1,8(sp)
    80003bd0:	e04a                	sd	s2,0(sp)
    80003bd2:	1000                	add	s0,sp,32
    80003bd4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003bd6:	0001c917          	auipc	s2,0x1c
    80003bda:	c9a90913          	add	s2,s2,-870 # 8001f870 <log>
    80003bde:	854a                	mv	a0,s2
    80003be0:	fc1fc0ef          	jal	80000ba0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003be4:	02c92603          	lw	a2,44(s2)
    80003be8:	47f5                	li	a5,29
    80003bea:	06c7c363          	blt	a5,a2,80003c50 <log_write+0x88>
    80003bee:	0001c797          	auipc	a5,0x1c
    80003bf2:	c9e7a783          	lw	a5,-866(a5) # 8001f88c <log+0x1c>
    80003bf6:	37fd                	addw	a5,a5,-1
    80003bf8:	04f65c63          	bge	a2,a5,80003c50 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003bfc:	0001c797          	auipc	a5,0x1c
    80003c00:	c947a783          	lw	a5,-876(a5) # 8001f890 <log+0x20>
    80003c04:	04f05c63          	blez	a5,80003c5c <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003c08:	4781                	li	a5,0
    80003c0a:	04c05f63          	blez	a2,80003c68 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003c0e:	44cc                	lw	a1,12(s1)
    80003c10:	0001c717          	auipc	a4,0x1c
    80003c14:	c9070713          	add	a4,a4,-880 # 8001f8a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003c18:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003c1a:	4314                	lw	a3,0(a4)
    80003c1c:	04b68663          	beq	a3,a1,80003c68 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003c20:	2785                	addw	a5,a5,1
    80003c22:	0711                	add	a4,a4,4
    80003c24:	fef61be3          	bne	a2,a5,80003c1a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003c28:	0621                	add	a2,a2,8
    80003c2a:	060a                	sll	a2,a2,0x2
    80003c2c:	0001c797          	auipc	a5,0x1c
    80003c30:	c4478793          	add	a5,a5,-956 # 8001f870 <log>
    80003c34:	97b2                	add	a5,a5,a2
    80003c36:	44d8                	lw	a4,12(s1)
    80003c38:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    80003c3a:	8526                	mv	a0,s1
    80003c3c:	f23fe0ef          	jal	80002b5e <bpin>
    log.lh.n++;
    80003c40:	0001c717          	auipc	a4,0x1c
    80003c44:	c3070713          	add	a4,a4,-976 # 8001f870 <log>
    80003c48:	575c                	lw	a5,44(a4)
    80003c4a:	2785                	addw	a5,a5,1
    80003c4c:	d75c                	sw	a5,44(a4)
    80003c4e:	a80d                	j	80003c80 <log_write+0xb8>
    panic("too big a transaction");
    80003c50:	00004517          	auipc	a0,0x4
    80003c54:	a3050513          	add	a0,a0,-1488 # 80007680 <syscalls+0x1f0>
    80003c58:	b07fc0ef          	jal	8000075e <panic>
    panic("log_write outside of trans");
    80003c5c:	00004517          	auipc	a0,0x4
    80003c60:	a3c50513          	add	a0,a0,-1476 # 80007698 <syscalls+0x208>
    80003c64:	afbfc0ef          	jal	8000075e <panic>
  log.lh.block[i] = b->blockno;
    80003c68:	00878693          	add	a3,a5,8
    80003c6c:	068a                	sll	a3,a3,0x2
    80003c6e:	0001c717          	auipc	a4,0x1c
    80003c72:	c0270713          	add	a4,a4,-1022 # 8001f870 <log>
    80003c76:	9736                	add	a4,a4,a3
    80003c78:	44d4                	lw	a3,12(s1)
    80003c7a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    80003c7c:	faf60fe3          	beq	a2,a5,80003c3a <log_write+0x72>
  }
  release(&log.lock);
    80003c80:	0001c517          	auipc	a0,0x1c
    80003c84:	bf050513          	add	a0,a0,-1040 # 8001f870 <log>
    80003c88:	fb1fc0ef          	jal	80000c38 <release>
}
    80003c8c:	60e2                	ld	ra,24(sp)
    80003c8e:	6442                	ld	s0,16(sp)
    80003c90:	64a2                	ld	s1,8(sp)
    80003c92:	6902                	ld	s2,0(sp)
    80003c94:	6105                	add	sp,sp,32
    80003c96:	8082                	ret

0000000080003c98 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003c98:	1101                	add	sp,sp,-32
    80003c9a:	ec06                	sd	ra,24(sp)
    80003c9c:	e822                	sd	s0,16(sp)
    80003c9e:	e426                	sd	s1,8(sp)
    80003ca0:	e04a                	sd	s2,0(sp)
    80003ca2:	1000                	add	s0,sp,32
    80003ca4:	84aa                	mv	s1,a0
    80003ca6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ca8:	00004597          	auipc	a1,0x4
    80003cac:	a1058593          	add	a1,a1,-1520 # 800076b8 <syscalls+0x228>
    80003cb0:	0521                	add	a0,a0,8
    80003cb2:	e6ffc0ef          	jal	80000b20 <initlock>
  lk->name = name;
    80003cb6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003cba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003cbe:	0204a423          	sw	zero,40(s1)
}
    80003cc2:	60e2                	ld	ra,24(sp)
    80003cc4:	6442                	ld	s0,16(sp)
    80003cc6:	64a2                	ld	s1,8(sp)
    80003cc8:	6902                	ld	s2,0(sp)
    80003cca:	6105                	add	sp,sp,32
    80003ccc:	8082                	ret

0000000080003cce <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003cce:	1101                	add	sp,sp,-32
    80003cd0:	ec06                	sd	ra,24(sp)
    80003cd2:	e822                	sd	s0,16(sp)
    80003cd4:	e426                	sd	s1,8(sp)
    80003cd6:	e04a                	sd	s2,0(sp)
    80003cd8:	1000                	add	s0,sp,32
    80003cda:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003cdc:	00850913          	add	s2,a0,8
    80003ce0:	854a                	mv	a0,s2
    80003ce2:	ebffc0ef          	jal	80000ba0 <acquire>
  while (lk->locked) {
    80003ce6:	409c                	lw	a5,0(s1)
    80003ce8:	c799                	beqz	a5,80003cf6 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003cea:	85ca                	mv	a1,s2
    80003cec:	8526                	mv	a0,s1
    80003cee:	90efe0ef          	jal	80001dfc <sleep>
  while (lk->locked) {
    80003cf2:	409c                	lw	a5,0(s1)
    80003cf4:	fbfd                	bnez	a5,80003cea <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003cf6:	4785                	li	a5,1
    80003cf8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003cfa:	b37fd0ef          	jal	80001830 <myproc>
    80003cfe:	591c                	lw	a5,48(a0)
    80003d00:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003d02:	854a                	mv	a0,s2
    80003d04:	f35fc0ef          	jal	80000c38 <release>
}
    80003d08:	60e2                	ld	ra,24(sp)
    80003d0a:	6442                	ld	s0,16(sp)
    80003d0c:	64a2                	ld	s1,8(sp)
    80003d0e:	6902                	ld	s2,0(sp)
    80003d10:	6105                	add	sp,sp,32
    80003d12:	8082                	ret

0000000080003d14 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003d14:	1101                	add	sp,sp,-32
    80003d16:	ec06                	sd	ra,24(sp)
    80003d18:	e822                	sd	s0,16(sp)
    80003d1a:	e426                	sd	s1,8(sp)
    80003d1c:	e04a                	sd	s2,0(sp)
    80003d1e:	1000                	add	s0,sp,32
    80003d20:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003d22:	00850913          	add	s2,a0,8
    80003d26:	854a                	mv	a0,s2
    80003d28:	e79fc0ef          	jal	80000ba0 <acquire>
  lk->locked = 0;
    80003d2c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003d30:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003d34:	8526                	mv	a0,s1
    80003d36:	912fe0ef          	jal	80001e48 <wakeup>
  release(&lk->lk);
    80003d3a:	854a                	mv	a0,s2
    80003d3c:	efdfc0ef          	jal	80000c38 <release>
}
    80003d40:	60e2                	ld	ra,24(sp)
    80003d42:	6442                	ld	s0,16(sp)
    80003d44:	64a2                	ld	s1,8(sp)
    80003d46:	6902                	ld	s2,0(sp)
    80003d48:	6105                	add	sp,sp,32
    80003d4a:	8082                	ret

0000000080003d4c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003d4c:	7179                	add	sp,sp,-48
    80003d4e:	f406                	sd	ra,40(sp)
    80003d50:	f022                	sd	s0,32(sp)
    80003d52:	ec26                	sd	s1,24(sp)
    80003d54:	e84a                	sd	s2,16(sp)
    80003d56:	e44e                	sd	s3,8(sp)
    80003d58:	1800                	add	s0,sp,48
    80003d5a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003d5c:	00850913          	add	s2,a0,8
    80003d60:	854a                	mv	a0,s2
    80003d62:	e3ffc0ef          	jal	80000ba0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d66:	409c                	lw	a5,0(s1)
    80003d68:	ef89                	bnez	a5,80003d82 <holdingsleep+0x36>
    80003d6a:	4481                	li	s1,0
  release(&lk->lk);
    80003d6c:	854a                	mv	a0,s2
    80003d6e:	ecbfc0ef          	jal	80000c38 <release>
  return r;
}
    80003d72:	8526                	mv	a0,s1
    80003d74:	70a2                	ld	ra,40(sp)
    80003d76:	7402                	ld	s0,32(sp)
    80003d78:	64e2                	ld	s1,24(sp)
    80003d7a:	6942                	ld	s2,16(sp)
    80003d7c:	69a2                	ld	s3,8(sp)
    80003d7e:	6145                	add	sp,sp,48
    80003d80:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d82:	0284a983          	lw	s3,40(s1)
    80003d86:	aabfd0ef          	jal	80001830 <myproc>
    80003d8a:	5904                	lw	s1,48(a0)
    80003d8c:	413484b3          	sub	s1,s1,s3
    80003d90:	0014b493          	seqz	s1,s1
    80003d94:	bfe1                	j	80003d6c <holdingsleep+0x20>

0000000080003d96 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003d96:	1141                	add	sp,sp,-16
    80003d98:	e406                	sd	ra,8(sp)
    80003d9a:	e022                	sd	s0,0(sp)
    80003d9c:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003d9e:	00004597          	auipc	a1,0x4
    80003da2:	92a58593          	add	a1,a1,-1750 # 800076c8 <syscalls+0x238>
    80003da6:	0001c517          	auipc	a0,0x1c
    80003daa:	c1250513          	add	a0,a0,-1006 # 8001f9b8 <ftable>
    80003dae:	d73fc0ef          	jal	80000b20 <initlock>
}
    80003db2:	60a2                	ld	ra,8(sp)
    80003db4:	6402                	ld	s0,0(sp)
    80003db6:	0141                	add	sp,sp,16
    80003db8:	8082                	ret

0000000080003dba <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    80003dba:	1101                	add	sp,sp,-32
    80003dbc:	ec06                	sd	ra,24(sp)
    80003dbe:	e822                	sd	s0,16(sp)
    80003dc0:	e426                	sd	s1,8(sp)
    80003dc2:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003dc4:	0001c517          	auipc	a0,0x1c
    80003dc8:	bf450513          	add	a0,a0,-1036 # 8001f9b8 <ftable>
    80003dcc:	dd5fc0ef          	jal	80000ba0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003dd0:	0001c497          	auipc	s1,0x1c
    80003dd4:	c0048493          	add	s1,s1,-1024 # 8001f9d0 <ftable+0x18>
    80003dd8:	0001d717          	auipc	a4,0x1d
    80003ddc:	b9870713          	add	a4,a4,-1128 # 80020970 <disk>
    if(f->ref == 0){
    80003de0:	40dc                	lw	a5,4(s1)
    80003de2:	cf89                	beqz	a5,80003dfc <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003de4:	02848493          	add	s1,s1,40
    80003de8:	fee49ce3          	bne	s1,a4,80003de0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003dec:	0001c517          	auipc	a0,0x1c
    80003df0:	bcc50513          	add	a0,a0,-1076 # 8001f9b8 <ftable>
    80003df4:	e45fc0ef          	jal	80000c38 <release>
  return 0;
    80003df8:	4481                	li	s1,0
    80003dfa:	a809                	j	80003e0c <filealloc+0x52>
      f->ref = 1;
    80003dfc:	4785                	li	a5,1
    80003dfe:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003e00:	0001c517          	auipc	a0,0x1c
    80003e04:	bb850513          	add	a0,a0,-1096 # 8001f9b8 <ftable>
    80003e08:	e31fc0ef          	jal	80000c38 <release>
}
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	60e2                	ld	ra,24(sp)
    80003e10:	6442                	ld	s0,16(sp)
    80003e12:	64a2                	ld	s1,8(sp)
    80003e14:	6105                	add	sp,sp,32
    80003e16:	8082                	ret

0000000080003e18 <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    80003e18:	1101                	add	sp,sp,-32
    80003e1a:	ec06                	sd	ra,24(sp)
    80003e1c:	e822                	sd	s0,16(sp)
    80003e1e:	e426                	sd	s1,8(sp)
    80003e20:	1000                	add	s0,sp,32
    80003e22:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003e24:	0001c517          	auipc	a0,0x1c
    80003e28:	b9450513          	add	a0,a0,-1132 # 8001f9b8 <ftable>
    80003e2c:	d75fc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003e30:	40dc                	lw	a5,4(s1)
    80003e32:	02f05063          	blez	a5,80003e52 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003e36:	2785                	addw	a5,a5,1
    80003e38:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003e3a:	0001c517          	auipc	a0,0x1c
    80003e3e:	b7e50513          	add	a0,a0,-1154 # 8001f9b8 <ftable>
    80003e42:	df7fc0ef          	jal	80000c38 <release>
  return f;
}
    80003e46:	8526                	mv	a0,s1
    80003e48:	60e2                	ld	ra,24(sp)
    80003e4a:	6442                	ld	s0,16(sp)
    80003e4c:	64a2                	ld	s1,8(sp)
    80003e4e:	6105                	add	sp,sp,32
    80003e50:	8082                	ret
    panic("filedup");
    80003e52:	00004517          	auipc	a0,0x4
    80003e56:	87e50513          	add	a0,a0,-1922 # 800076d0 <syscalls+0x240>
    80003e5a:	905fc0ef          	jal	8000075e <panic>

0000000080003e5e <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    80003e5e:	7139                	add	sp,sp,-64
    80003e60:	fc06                	sd	ra,56(sp)
    80003e62:	f822                	sd	s0,48(sp)
    80003e64:	f426                	sd	s1,40(sp)
    80003e66:	f04a                	sd	s2,32(sp)
    80003e68:	ec4e                	sd	s3,24(sp)
    80003e6a:	e852                	sd	s4,16(sp)
    80003e6c:	e456                	sd	s5,8(sp)
    80003e6e:	0080                	add	s0,sp,64
    80003e70:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003e72:	0001c517          	auipc	a0,0x1c
    80003e76:	b4650513          	add	a0,a0,-1210 # 8001f9b8 <ftable>
    80003e7a:	d27fc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003e7e:	40dc                	lw	a5,4(s1)
    80003e80:	04f05963          	blez	a5,80003ed2 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003e84:	37fd                	addw	a5,a5,-1
    80003e86:	0007871b          	sext.w	a4,a5
    80003e8a:	c0dc                	sw	a5,4(s1)
    80003e8c:	04e04963          	bgtz	a4,80003ede <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003e90:	0004a903          	lw	s2,0(s1)
    80003e94:	0094ca83          	lbu	s5,9(s1)
    80003e98:	0104ba03          	ld	s4,16(s1)
    80003e9c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ea0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ea4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ea8:	0001c517          	auipc	a0,0x1c
    80003eac:	b1050513          	add	a0,a0,-1264 # 8001f9b8 <ftable>
    80003eb0:	d89fc0ef          	jal	80000c38 <release>

  if(ff.type == FD_PIPE){
    80003eb4:	4785                	li	a5,1
    80003eb6:	04f90363          	beq	s2,a5,80003efc <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003eba:	3979                	addw	s2,s2,-2
    80003ebc:	4785                	li	a5,1
    80003ebe:	0327e663          	bltu	a5,s2,80003eea <fileclose+0x8c>
    begin_op();
    80003ec2:	b89ff0ef          	jal	80003a4a <begin_op>
    iput(ff.ip);
    80003ec6:	854e                	mv	a0,s3
    80003ec8:	c90ff0ef          	jal	80003358 <iput>
    end_op();
    80003ecc:	be9ff0ef          	jal	80003ab4 <end_op>
    80003ed0:	a829                	j	80003eea <fileclose+0x8c>
    panic("fileclose");
    80003ed2:	00004517          	auipc	a0,0x4
    80003ed6:	80650513          	add	a0,a0,-2042 # 800076d8 <syscalls+0x248>
    80003eda:	885fc0ef          	jal	8000075e <panic>
    release(&ftable.lock);
    80003ede:	0001c517          	auipc	a0,0x1c
    80003ee2:	ada50513          	add	a0,a0,-1318 # 8001f9b8 <ftable>
    80003ee6:	d53fc0ef          	jal	80000c38 <release>
  }
}
    80003eea:	70e2                	ld	ra,56(sp)
    80003eec:	7442                	ld	s0,48(sp)
    80003eee:	74a2                	ld	s1,40(sp)
    80003ef0:	7902                	ld	s2,32(sp)
    80003ef2:	69e2                	ld	s3,24(sp)
    80003ef4:	6a42                	ld	s4,16(sp)
    80003ef6:	6aa2                	ld	s5,8(sp)
    80003ef8:	6121                	add	sp,sp,64
    80003efa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003efc:	85d6                	mv	a1,s5
    80003efe:	8552                	mv	a0,s4
    80003f00:	2e8000ef          	jal	800041e8 <pipeclose>
    80003f04:	b7dd                	j	80003eea <fileclose+0x8c>

0000000080003f06 <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    80003f06:	715d                	add	sp,sp,-80
    80003f08:	e486                	sd	ra,72(sp)
    80003f0a:	e0a2                	sd	s0,64(sp)
    80003f0c:	fc26                	sd	s1,56(sp)
    80003f0e:	f84a                	sd	s2,48(sp)
    80003f10:	f44e                	sd	s3,40(sp)
    80003f12:	0880                	add	s0,sp,80
    80003f14:	84aa                	mv	s1,a0
    80003f16:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003f18:	919fd0ef          	jal	80001830 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003f1c:	409c                	lw	a5,0(s1)
    80003f1e:	37f9                	addw	a5,a5,-2
    80003f20:	4705                	li	a4,1
    80003f22:	02f76f63          	bltu	a4,a5,80003f60 <filestat+0x5a>
    80003f26:	892a                	mv	s2,a0
    ilock(f->ip);
    80003f28:	6c88                	ld	a0,24(s1)
    80003f2a:	a26ff0ef          	jal	80003150 <ilock>
    stati(f->ip, &st);
    80003f2e:	fb840593          	add	a1,s0,-72
    80003f32:	6c88                	ld	a0,24(s1)
    80003f34:	cccff0ef          	jal	80003400 <stati>
    iunlock(f->ip);
    80003f38:	6c88                	ld	a0,24(s1)
    80003f3a:	ac0ff0ef          	jal	800031fa <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003f3e:	46e1                	li	a3,24
    80003f40:	fb840613          	add	a2,s0,-72
    80003f44:	85ce                	mv	a1,s3
    80003f46:	05093503          	ld	a0,80(s2)
    80003f4a:	d9efd0ef          	jal	800014e8 <copyout>
    80003f4e:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003f52:	60a6                	ld	ra,72(sp)
    80003f54:	6406                	ld	s0,64(sp)
    80003f56:	74e2                	ld	s1,56(sp)
    80003f58:	7942                	ld	s2,48(sp)
    80003f5a:	79a2                	ld	s3,40(sp)
    80003f5c:	6161                	add	sp,sp,80
    80003f5e:	8082                	ret
  return -1;
    80003f60:	557d                	li	a0,-1
    80003f62:	bfc5                	j	80003f52 <filestat+0x4c>

0000000080003f64 <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80003f64:	7179                	add	sp,sp,-48
    80003f66:	f406                	sd	ra,40(sp)
    80003f68:	f022                	sd	s0,32(sp)
    80003f6a:	ec26                	sd	s1,24(sp)
    80003f6c:	e84a                	sd	s2,16(sp)
    80003f6e:	e44e                	sd	s3,8(sp)
    80003f70:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003f72:	00854783          	lbu	a5,8(a0)
    80003f76:	cbc1                	beqz	a5,80004006 <fileread+0xa2>
    80003f78:	84aa                	mv	s1,a0
    80003f7a:	89ae                	mv	s3,a1
    80003f7c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f7e:	411c                	lw	a5,0(a0)
    80003f80:	4705                	li	a4,1
    80003f82:	04e78363          	beq	a5,a4,80003fc8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f86:	470d                	li	a4,3
    80003f88:	04e78563          	beq	a5,a4,80003fd2 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f8c:	4709                	li	a4,2
    80003f8e:	06e79663          	bne	a5,a4,80003ffa <fileread+0x96>
    ilock(f->ip);
    80003f92:	6d08                	ld	a0,24(a0)
    80003f94:	9bcff0ef          	jal	80003150 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003f98:	874a                	mv	a4,s2
    80003f9a:	5094                	lw	a3,32(s1)
    80003f9c:	864e                	mv	a2,s3
    80003f9e:	4585                	li	a1,1
    80003fa0:	6c88                	ld	a0,24(s1)
    80003fa2:	c88ff0ef          	jal	8000342a <readi>
    80003fa6:	892a                	mv	s2,a0
    80003fa8:	00a05563          	blez	a0,80003fb2 <fileread+0x4e>
      f->off += r;
    80003fac:	509c                	lw	a5,32(s1)
    80003fae:	9fa9                	addw	a5,a5,a0
    80003fb0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003fb2:	6c88                	ld	a0,24(s1)
    80003fb4:	a46ff0ef          	jal	800031fa <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003fb8:	854a                	mv	a0,s2
    80003fba:	70a2                	ld	ra,40(sp)
    80003fbc:	7402                	ld	s0,32(sp)
    80003fbe:	64e2                	ld	s1,24(sp)
    80003fc0:	6942                	ld	s2,16(sp)
    80003fc2:	69a2                	ld	s3,8(sp)
    80003fc4:	6145                	add	sp,sp,48
    80003fc6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003fc8:	6908                	ld	a0,16(a0)
    80003fca:	34a000ef          	jal	80004314 <piperead>
    80003fce:	892a                	mv	s2,a0
    80003fd0:	b7e5                	j	80003fb8 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003fd2:	02451783          	lh	a5,36(a0)
    80003fd6:	03079693          	sll	a3,a5,0x30
    80003fda:	92c1                	srl	a3,a3,0x30
    80003fdc:	4725                	li	a4,9
    80003fde:	02d76663          	bltu	a4,a3,8000400a <fileread+0xa6>
    80003fe2:	0792                	sll	a5,a5,0x4
    80003fe4:	0001c717          	auipc	a4,0x1c
    80003fe8:	93470713          	add	a4,a4,-1740 # 8001f918 <devsw>
    80003fec:	97ba                	add	a5,a5,a4
    80003fee:	639c                	ld	a5,0(a5)
    80003ff0:	cf99                	beqz	a5,8000400e <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003ff2:	4505                	li	a0,1
    80003ff4:	9782                	jalr	a5
    80003ff6:	892a                	mv	s2,a0
    80003ff8:	b7c1                	j	80003fb8 <fileread+0x54>
    panic("fileread");
    80003ffa:	00003517          	auipc	a0,0x3
    80003ffe:	6ee50513          	add	a0,a0,1774 # 800076e8 <syscalls+0x258>
    80004002:	f5cfc0ef          	jal	8000075e <panic>
    return -1;
    80004006:	597d                	li	s2,-1
    80004008:	bf45                	j	80003fb8 <fileread+0x54>
      return -1;
    8000400a:	597d                	li	s2,-1
    8000400c:	b775                	j	80003fb8 <fileread+0x54>
    8000400e:	597d                	li	s2,-1
    80004010:	b765                	j	80003fb8 <fileread+0x54>

0000000080004012 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004012:	00954783          	lbu	a5,9(a0)
    80004016:	10078063          	beqz	a5,80004116 <filewrite+0x104>
{
    8000401a:	715d                	add	sp,sp,-80
    8000401c:	e486                	sd	ra,72(sp)
    8000401e:	e0a2                	sd	s0,64(sp)
    80004020:	fc26                	sd	s1,56(sp)
    80004022:	f84a                	sd	s2,48(sp)
    80004024:	f44e                	sd	s3,40(sp)
    80004026:	f052                	sd	s4,32(sp)
    80004028:	ec56                	sd	s5,24(sp)
    8000402a:	e85a                	sd	s6,16(sp)
    8000402c:	e45e                	sd	s7,8(sp)
    8000402e:	e062                	sd	s8,0(sp)
    80004030:	0880                	add	s0,sp,80
    80004032:	892a                	mv	s2,a0
    80004034:	8b2e                	mv	s6,a1
    80004036:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004038:	411c                	lw	a5,0(a0)
    8000403a:	4705                	li	a4,1
    8000403c:	02e78263          	beq	a5,a4,80004060 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004040:	470d                	li	a4,3
    80004042:	02e78363          	beq	a5,a4,80004068 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004046:	4709                	li	a4,2
    80004048:	0ce79163          	bne	a5,a4,8000410a <filewrite+0xf8>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000404c:	08c05f63          	blez	a2,800040ea <filewrite+0xd8>
    int i = 0;
    80004050:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004052:	6b85                	lui	s7,0x1
    80004054:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004058:	6c05                	lui	s8,0x1
    8000405a:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000405e:	a8b5                	j	800040da <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004060:	6908                	ld	a0,16(a0)
    80004062:	1de000ef          	jal	80004240 <pipewrite>
    80004066:	a071                	j	800040f2 <filewrite+0xe0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004068:	02451783          	lh	a5,36(a0)
    8000406c:	03079693          	sll	a3,a5,0x30
    80004070:	92c1                	srl	a3,a3,0x30
    80004072:	4725                	li	a4,9
    80004074:	0ad76363          	bltu	a4,a3,8000411a <filewrite+0x108>
    80004078:	0792                	sll	a5,a5,0x4
    8000407a:	0001c717          	auipc	a4,0x1c
    8000407e:	89e70713          	add	a4,a4,-1890 # 8001f918 <devsw>
    80004082:	97ba                	add	a5,a5,a4
    80004084:	679c                	ld	a5,8(a5)
    80004086:	cfc1                	beqz	a5,8000411e <filewrite+0x10c>
    ret = devsw[f->major].write(1, addr, n);
    80004088:	4505                	li	a0,1
    8000408a:	9782                	jalr	a5
    8000408c:	a09d                	j	800040f2 <filewrite+0xe0>
      if(n1 > max)
    8000408e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004092:	9b9ff0ef          	jal	80003a4a <begin_op>
      ilock(f->ip);
    80004096:	01893503          	ld	a0,24(s2)
    8000409a:	8b6ff0ef          	jal	80003150 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000409e:	8756                	mv	a4,s5
    800040a0:	02092683          	lw	a3,32(s2)
    800040a4:	01698633          	add	a2,s3,s6
    800040a8:	4585                	li	a1,1
    800040aa:	01893503          	ld	a0,24(s2)
    800040ae:	c60ff0ef          	jal	8000350e <writei>
    800040b2:	84aa                	mv	s1,a0
    800040b4:	00a05763          	blez	a0,800040c2 <filewrite+0xb0>
        f->off += r;
    800040b8:	02092783          	lw	a5,32(s2)
    800040bc:	9fa9                	addw	a5,a5,a0
    800040be:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800040c2:	01893503          	ld	a0,24(s2)
    800040c6:	934ff0ef          	jal	800031fa <iunlock>
      end_op();
    800040ca:	9ebff0ef          	jal	80003ab4 <end_op>

      if(r != n1){
    800040ce:	009a9f63          	bne	s5,s1,800040ec <filewrite+0xda>
        /* error from writei */
        break;
      }
      i += r;
    800040d2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800040d6:	0149db63          	bge	s3,s4,800040ec <filewrite+0xda>
      int n1 = n - i;
    800040da:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800040de:	0004879b          	sext.w	a5,s1
    800040e2:	fafbd6e3          	bge	s7,a5,8000408e <filewrite+0x7c>
    800040e6:	84e2                	mv	s1,s8
    800040e8:	b75d                	j	8000408e <filewrite+0x7c>
    int i = 0;
    800040ea:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800040ec:	033a1b63          	bne	s4,s3,80004122 <filewrite+0x110>
    800040f0:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    800040f2:	60a6                	ld	ra,72(sp)
    800040f4:	6406                	ld	s0,64(sp)
    800040f6:	74e2                	ld	s1,56(sp)
    800040f8:	7942                	ld	s2,48(sp)
    800040fa:	79a2                	ld	s3,40(sp)
    800040fc:	7a02                	ld	s4,32(sp)
    800040fe:	6ae2                	ld	s5,24(sp)
    80004100:	6b42                	ld	s6,16(sp)
    80004102:	6ba2                	ld	s7,8(sp)
    80004104:	6c02                	ld	s8,0(sp)
    80004106:	6161                	add	sp,sp,80
    80004108:	8082                	ret
    panic("filewrite");
    8000410a:	00003517          	auipc	a0,0x3
    8000410e:	5ee50513          	add	a0,a0,1518 # 800076f8 <syscalls+0x268>
    80004112:	e4cfc0ef          	jal	8000075e <panic>
    return -1;
    80004116:	557d                	li	a0,-1
}
    80004118:	8082                	ret
      return -1;
    8000411a:	557d                	li	a0,-1
    8000411c:	bfd9                	j	800040f2 <filewrite+0xe0>
    8000411e:	557d                	li	a0,-1
    80004120:	bfc9                	j	800040f2 <filewrite+0xe0>
    ret = (i == n ? n : -1);
    80004122:	557d                	li	a0,-1
    80004124:	b7f9                	j	800040f2 <filewrite+0xe0>

0000000080004126 <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004126:	7179                	add	sp,sp,-48
    80004128:	f406                	sd	ra,40(sp)
    8000412a:	f022                	sd	s0,32(sp)
    8000412c:	ec26                	sd	s1,24(sp)
    8000412e:	e84a                	sd	s2,16(sp)
    80004130:	e44e                	sd	s3,8(sp)
    80004132:	e052                	sd	s4,0(sp)
    80004134:	1800                	add	s0,sp,48
    80004136:	84aa                	mv	s1,a0
    80004138:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000413a:	0005b023          	sd	zero,0(a1)
    8000413e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004142:	c79ff0ef          	jal	80003dba <filealloc>
    80004146:	e088                	sd	a0,0(s1)
    80004148:	cd35                	beqz	a0,800041c4 <pipealloc+0x9e>
    8000414a:	c71ff0ef          	jal	80003dba <filealloc>
    8000414e:	00aa3023          	sd	a0,0(s4)
    80004152:	c52d                	beqz	a0,800041bc <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004154:	97dfc0ef          	jal	80000ad0 <kalloc>
    80004158:	892a                	mv	s2,a0
    8000415a:	cd31                	beqz	a0,800041b6 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    8000415c:	4985                	li	s3,1
    8000415e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004162:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004166:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000416a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000416e:	00003597          	auipc	a1,0x3
    80004172:	59a58593          	add	a1,a1,1434 # 80007708 <syscalls+0x278>
    80004176:	9abfc0ef          	jal	80000b20 <initlock>
  (*f0)->type = FD_PIPE;
    8000417a:	609c                	ld	a5,0(s1)
    8000417c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004180:	609c                	ld	a5,0(s1)
    80004182:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004186:	609c                	ld	a5,0(s1)
    80004188:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000418c:	609c                	ld	a5,0(s1)
    8000418e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004192:	000a3783          	ld	a5,0(s4)
    80004196:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000419a:	000a3783          	ld	a5,0(s4)
    8000419e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800041a2:	000a3783          	ld	a5,0(s4)
    800041a6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800041aa:	000a3783          	ld	a5,0(s4)
    800041ae:	0127b823          	sd	s2,16(a5)
  return 0;
    800041b2:	4501                	li	a0,0
    800041b4:	a005                	j	800041d4 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800041b6:	6088                	ld	a0,0(s1)
    800041b8:	e501                	bnez	a0,800041c0 <pipealloc+0x9a>
    800041ba:	a029                	j	800041c4 <pipealloc+0x9e>
    800041bc:	6088                	ld	a0,0(s1)
    800041be:	c11d                	beqz	a0,800041e4 <pipealloc+0xbe>
    fileclose(*f0);
    800041c0:	c9fff0ef          	jal	80003e5e <fileclose>
  if(*f1)
    800041c4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800041c8:	557d                	li	a0,-1
  if(*f1)
    800041ca:	c789                	beqz	a5,800041d4 <pipealloc+0xae>
    fileclose(*f1);
    800041cc:	853e                	mv	a0,a5
    800041ce:	c91ff0ef          	jal	80003e5e <fileclose>
  return -1;
    800041d2:	557d                	li	a0,-1
}
    800041d4:	70a2                	ld	ra,40(sp)
    800041d6:	7402                	ld	s0,32(sp)
    800041d8:	64e2                	ld	s1,24(sp)
    800041da:	6942                	ld	s2,16(sp)
    800041dc:	69a2                	ld	s3,8(sp)
    800041de:	6a02                	ld	s4,0(sp)
    800041e0:	6145                	add	sp,sp,48
    800041e2:	8082                	ret
  return -1;
    800041e4:	557d                	li	a0,-1
    800041e6:	b7fd                	j	800041d4 <pipealloc+0xae>

00000000800041e8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800041e8:	1101                	add	sp,sp,-32
    800041ea:	ec06                	sd	ra,24(sp)
    800041ec:	e822                	sd	s0,16(sp)
    800041ee:	e426                	sd	s1,8(sp)
    800041f0:	e04a                	sd	s2,0(sp)
    800041f2:	1000                	add	s0,sp,32
    800041f4:	84aa                	mv	s1,a0
    800041f6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800041f8:	9a9fc0ef          	jal	80000ba0 <acquire>
  if(writable){
    800041fc:	02090763          	beqz	s2,8000422a <pipeclose+0x42>
    pi->writeopen = 0;
    80004200:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004204:	21848513          	add	a0,s1,536
    80004208:	c41fd0ef          	jal	80001e48 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000420c:	2204b783          	ld	a5,544(s1)
    80004210:	e785                	bnez	a5,80004238 <pipeclose+0x50>
    release(&pi->lock);
    80004212:	8526                	mv	a0,s1
    80004214:	a25fc0ef          	jal	80000c38 <release>
    kfree((char*)pi);
    80004218:	8526                	mv	a0,s1
    8000421a:	fd4fc0ef          	jal	800009ee <kfree>
  } else
    release(&pi->lock);
}
    8000421e:	60e2                	ld	ra,24(sp)
    80004220:	6442                	ld	s0,16(sp)
    80004222:	64a2                	ld	s1,8(sp)
    80004224:	6902                	ld	s2,0(sp)
    80004226:	6105                	add	sp,sp,32
    80004228:	8082                	ret
    pi->readopen = 0;
    8000422a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000422e:	21c48513          	add	a0,s1,540
    80004232:	c17fd0ef          	jal	80001e48 <wakeup>
    80004236:	bfd9                	j	8000420c <pipeclose+0x24>
    release(&pi->lock);
    80004238:	8526                	mv	a0,s1
    8000423a:	9fffc0ef          	jal	80000c38 <release>
}
    8000423e:	b7c5                	j	8000421e <pipeclose+0x36>

0000000080004240 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004240:	711d                	add	sp,sp,-96
    80004242:	ec86                	sd	ra,88(sp)
    80004244:	e8a2                	sd	s0,80(sp)
    80004246:	e4a6                	sd	s1,72(sp)
    80004248:	e0ca                	sd	s2,64(sp)
    8000424a:	fc4e                	sd	s3,56(sp)
    8000424c:	f852                	sd	s4,48(sp)
    8000424e:	f456                	sd	s5,40(sp)
    80004250:	f05a                	sd	s6,32(sp)
    80004252:	ec5e                	sd	s7,24(sp)
    80004254:	e862                	sd	s8,16(sp)
    80004256:	1080                	add	s0,sp,96
    80004258:	84aa                	mv	s1,a0
    8000425a:	8aae                	mv	s5,a1
    8000425c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000425e:	dd2fd0ef          	jal	80001830 <myproc>
    80004262:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004264:	8526                	mv	a0,s1
    80004266:	93bfc0ef          	jal	80000ba0 <acquire>
  while(i < n){
    8000426a:	09405c63          	blez	s4,80004302 <pipewrite+0xc2>
  int i = 0;
    8000426e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004270:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004272:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004276:	21c48b93          	add	s7,s1,540
    8000427a:	a81d                	j	800042b0 <pipewrite+0x70>
      release(&pi->lock);
    8000427c:	8526                	mv	a0,s1
    8000427e:	9bbfc0ef          	jal	80000c38 <release>
      return -1;
    80004282:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004284:	854a                	mv	a0,s2
    80004286:	60e6                	ld	ra,88(sp)
    80004288:	6446                	ld	s0,80(sp)
    8000428a:	64a6                	ld	s1,72(sp)
    8000428c:	6906                	ld	s2,64(sp)
    8000428e:	79e2                	ld	s3,56(sp)
    80004290:	7a42                	ld	s4,48(sp)
    80004292:	7aa2                	ld	s5,40(sp)
    80004294:	7b02                	ld	s6,32(sp)
    80004296:	6be2                	ld	s7,24(sp)
    80004298:	6c42                	ld	s8,16(sp)
    8000429a:	6125                	add	sp,sp,96
    8000429c:	8082                	ret
      wakeup(&pi->nread);
    8000429e:	8562                	mv	a0,s8
    800042a0:	ba9fd0ef          	jal	80001e48 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800042a4:	85a6                	mv	a1,s1
    800042a6:	855e                	mv	a0,s7
    800042a8:	b55fd0ef          	jal	80001dfc <sleep>
  while(i < n){
    800042ac:	05495c63          	bge	s2,s4,80004304 <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    800042b0:	2204a783          	lw	a5,544(s1)
    800042b4:	d7e1                	beqz	a5,8000427c <pipewrite+0x3c>
    800042b6:	854e                	mv	a0,s3
    800042b8:	d7dfd0ef          	jal	80002034 <killed>
    800042bc:	f161                	bnez	a0,8000427c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    800042be:	2184a783          	lw	a5,536(s1)
    800042c2:	21c4a703          	lw	a4,540(s1)
    800042c6:	2007879b          	addw	a5,a5,512
    800042ca:	fcf70ae3          	beq	a4,a5,8000429e <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042ce:	4685                	li	a3,1
    800042d0:	01590633          	add	a2,s2,s5
    800042d4:	faf40593          	add	a1,s0,-81
    800042d8:	0509b503          	ld	a0,80(s3)
    800042dc:	ac4fd0ef          	jal	800015a0 <copyin>
    800042e0:	03650263          	beq	a0,s6,80004304 <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800042e4:	21c4a783          	lw	a5,540(s1)
    800042e8:	0017871b          	addw	a4,a5,1
    800042ec:	20e4ae23          	sw	a4,540(s1)
    800042f0:	1ff7f793          	and	a5,a5,511
    800042f4:	97a6                	add	a5,a5,s1
    800042f6:	faf44703          	lbu	a4,-81(s0)
    800042fa:	00e78c23          	sb	a4,24(a5)
      i++;
    800042fe:	2905                	addw	s2,s2,1
    80004300:	b775                	j	800042ac <pipewrite+0x6c>
  int i = 0;
    80004302:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004304:	21848513          	add	a0,s1,536
    80004308:	b41fd0ef          	jal	80001e48 <wakeup>
  release(&pi->lock);
    8000430c:	8526                	mv	a0,s1
    8000430e:	92bfc0ef          	jal	80000c38 <release>
  return i;
    80004312:	bf8d                	j	80004284 <pipewrite+0x44>

0000000080004314 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004314:	715d                	add	sp,sp,-80
    80004316:	e486                	sd	ra,72(sp)
    80004318:	e0a2                	sd	s0,64(sp)
    8000431a:	fc26                	sd	s1,56(sp)
    8000431c:	f84a                	sd	s2,48(sp)
    8000431e:	f44e                	sd	s3,40(sp)
    80004320:	f052                	sd	s4,32(sp)
    80004322:	ec56                	sd	s5,24(sp)
    80004324:	e85a                	sd	s6,16(sp)
    80004326:	0880                	add	s0,sp,80
    80004328:	84aa                	mv	s1,a0
    8000432a:	892e                	mv	s2,a1
    8000432c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000432e:	d02fd0ef          	jal	80001830 <myproc>
    80004332:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004334:	8526                	mv	a0,s1
    80004336:	86bfc0ef          	jal	80000ba0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    8000433a:	2184a703          	lw	a4,536(s1)
    8000433e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004342:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004346:	02f71363          	bne	a4,a5,8000436c <piperead+0x58>
    8000434a:	2244a783          	lw	a5,548(s1)
    8000434e:	cf99                	beqz	a5,8000436c <piperead+0x58>
    if(killed(pr)){
    80004350:	8552                	mv	a0,s4
    80004352:	ce3fd0ef          	jal	80002034 <killed>
    80004356:	e149                	bnez	a0,800043d8 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004358:	85a6                	mv	a1,s1
    8000435a:	854e                	mv	a0,s3
    8000435c:	aa1fd0ef          	jal	80001dfc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004360:	2184a703          	lw	a4,536(s1)
    80004364:	21c4a783          	lw	a5,540(s1)
    80004368:	fef701e3          	beq	a4,a5,8000434a <piperead+0x36>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    8000436c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000436e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004370:	05505263          	blez	s5,800043b4 <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    80004374:	2184a783          	lw	a5,536(s1)
    80004378:	21c4a703          	lw	a4,540(s1)
    8000437c:	02f70c63          	beq	a4,a5,800043b4 <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004380:	0017871b          	addw	a4,a5,1
    80004384:	20e4ac23          	sw	a4,536(s1)
    80004388:	1ff7f793          	and	a5,a5,511
    8000438c:	97a6                	add	a5,a5,s1
    8000438e:	0187c783          	lbu	a5,24(a5)
    80004392:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004396:	4685                	li	a3,1
    80004398:	fbf40613          	add	a2,s0,-65
    8000439c:	85ca                	mv	a1,s2
    8000439e:	050a3503          	ld	a0,80(s4)
    800043a2:	946fd0ef          	jal	800014e8 <copyout>
    800043a6:	01650763          	beq	a0,s6,800043b4 <piperead+0xa0>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    800043aa:	2985                	addw	s3,s3,1
    800043ac:	0905                	add	s2,s2,1
    800043ae:	fd3a93e3          	bne	s5,s3,80004374 <piperead+0x60>
    800043b2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    800043b4:	21c48513          	add	a0,s1,540
    800043b8:	a91fd0ef          	jal	80001e48 <wakeup>
  release(&pi->lock);
    800043bc:	8526                	mv	a0,s1
    800043be:	87bfc0ef          	jal	80000c38 <release>
  return i;
}
    800043c2:	854e                	mv	a0,s3
    800043c4:	60a6                	ld	ra,72(sp)
    800043c6:	6406                	ld	s0,64(sp)
    800043c8:	74e2                	ld	s1,56(sp)
    800043ca:	7942                	ld	s2,48(sp)
    800043cc:	79a2                	ld	s3,40(sp)
    800043ce:	7a02                	ld	s4,32(sp)
    800043d0:	6ae2                	ld	s5,24(sp)
    800043d2:	6b42                	ld	s6,16(sp)
    800043d4:	6161                	add	sp,sp,80
    800043d6:	8082                	ret
      release(&pi->lock);
    800043d8:	8526                	mv	a0,s1
    800043da:	85ffc0ef          	jal	80000c38 <release>
      return -1;
    800043de:	59fd                	li	s3,-1
    800043e0:	b7cd                	j	800043c2 <piperead+0xae>

00000000800043e2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800043e2:	1141                	add	sp,sp,-16
    800043e4:	e422                	sd	s0,8(sp)
    800043e6:	0800                	add	s0,sp,16
    800043e8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800043ea:	8905                	and	a0,a0,1
    800043ec:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800043ee:	8b89                	and	a5,a5,2
    800043f0:	c399                	beqz	a5,800043f6 <flags2perm+0x14>
      perm |= PTE_W;
    800043f2:	00456513          	or	a0,a0,4
    return perm;
}
    800043f6:	6422                	ld	s0,8(sp)
    800043f8:	0141                	add	sp,sp,16
    800043fa:	8082                	ret

00000000800043fc <exec>:

int
exec(char *path, char **argv)
{
    800043fc:	df010113          	add	sp,sp,-528
    80004400:	20113423          	sd	ra,520(sp)
    80004404:	20813023          	sd	s0,512(sp)
    80004408:	ffa6                	sd	s1,504(sp)
    8000440a:	fbca                	sd	s2,496(sp)
    8000440c:	f7ce                	sd	s3,488(sp)
    8000440e:	f3d2                	sd	s4,480(sp)
    80004410:	efd6                	sd	s5,472(sp)
    80004412:	ebda                	sd	s6,464(sp)
    80004414:	e7de                	sd	s7,456(sp)
    80004416:	e3e2                	sd	s8,448(sp)
    80004418:	ff66                	sd	s9,440(sp)
    8000441a:	fb6a                	sd	s10,432(sp)
    8000441c:	f76e                	sd	s11,424(sp)
    8000441e:	0c00                	add	s0,sp,528
    80004420:	892a                	mv	s2,a0
    80004422:	dea43c23          	sd	a0,-520(s0)
    80004426:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000442a:	c06fd0ef          	jal	80001830 <myproc>
    8000442e:	84aa                	mv	s1,a0

  begin_op();
    80004430:	e1aff0ef          	jal	80003a4a <begin_op>

  if((ip = namei(path)) == 0){
    80004434:	854a                	mv	a0,s2
    80004436:	c58ff0ef          	jal	8000388e <namei>
    8000443a:	c12d                	beqz	a0,8000449c <exec+0xa0>
    8000443c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000443e:	d13fe0ef          	jal	80003150 <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004442:	04000713          	li	a4,64
    80004446:	4681                	li	a3,0
    80004448:	e5040613          	add	a2,s0,-432
    8000444c:	4581                	li	a1,0
    8000444e:	8552                	mv	a0,s4
    80004450:	fdbfe0ef          	jal	8000342a <readi>
    80004454:	04000793          	li	a5,64
    80004458:	00f51a63          	bne	a0,a5,8000446c <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000445c:	e5042703          	lw	a4,-432(s0)
    80004460:	464c47b7          	lui	a5,0x464c4
    80004464:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004468:	02f70e63          	beq	a4,a5,800044a4 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000446c:	8552                	mv	a0,s4
    8000446e:	f73fe0ef          	jal	800033e0 <iunlockput>
    end_op();
    80004472:	e42ff0ef          	jal	80003ab4 <end_op>
  }
  return -1;
    80004476:	557d                	li	a0,-1
}
    80004478:	20813083          	ld	ra,520(sp)
    8000447c:	20013403          	ld	s0,512(sp)
    80004480:	74fe                	ld	s1,504(sp)
    80004482:	795e                	ld	s2,496(sp)
    80004484:	79be                	ld	s3,488(sp)
    80004486:	7a1e                	ld	s4,480(sp)
    80004488:	6afe                	ld	s5,472(sp)
    8000448a:	6b5e                	ld	s6,464(sp)
    8000448c:	6bbe                	ld	s7,456(sp)
    8000448e:	6c1e                	ld	s8,448(sp)
    80004490:	7cfa                	ld	s9,440(sp)
    80004492:	7d5a                	ld	s10,432(sp)
    80004494:	7dba                	ld	s11,424(sp)
    80004496:	21010113          	add	sp,sp,528
    8000449a:	8082                	ret
    end_op();
    8000449c:	e18ff0ef          	jal	80003ab4 <end_op>
    return -1;
    800044a0:	557d                	li	a0,-1
    800044a2:	bfd9                	j	80004478 <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    800044a4:	8526                	mv	a0,s1
    800044a6:	c32fd0ef          	jal	800018d8 <proc_pagetable>
    800044aa:	8b2a                	mv	s6,a0
    800044ac:	d161                	beqz	a0,8000446c <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044ae:	e7042d03          	lw	s10,-400(s0)
    800044b2:	e8845783          	lhu	a5,-376(s0)
    800044b6:	0e078863          	beqz	a5,800045a6 <exec+0x1aa>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044ba:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044bc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800044be:	6c85                	lui	s9,0x1
    800044c0:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    800044c4:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800044c8:	6a85                	lui	s5,0x1
    800044ca:	a085                	j	8000452a <exec+0x12e>
      panic("loadseg: address should exist");
    800044cc:	00003517          	auipc	a0,0x3
    800044d0:	24450513          	add	a0,a0,580 # 80007710 <syscalls+0x280>
    800044d4:	a8afc0ef          	jal	8000075e <panic>
    if(sz - i < PGSIZE)
    800044d8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800044da:	8726                	mv	a4,s1
    800044dc:	012c06bb          	addw	a3,s8,s2
    800044e0:	4581                	li	a1,0
    800044e2:	8552                	mv	a0,s4
    800044e4:	f47fe0ef          	jal	8000342a <readi>
    800044e8:	2501                	sext.w	a0,a0
    800044ea:	20a49a63          	bne	s1,a0,800046fe <exec+0x302>
  for(i = 0; i < sz; i += PGSIZE){
    800044ee:	012a893b          	addw	s2,s5,s2
    800044f2:	03397363          	bgeu	s2,s3,80004518 <exec+0x11c>
    pa = walkaddr(pagetable, va + i);
    800044f6:	02091593          	sll	a1,s2,0x20
    800044fa:	9181                	srl	a1,a1,0x20
    800044fc:	95de                	add	a1,a1,s7
    800044fe:	855a                	mv	a0,s6
    80004500:	a89fc0ef          	jal	80000f88 <walkaddr>
    80004504:	862a                	mv	a2,a0
    if(pa == 0)
    80004506:	d179                	beqz	a0,800044cc <exec+0xd0>
    if(sz - i < PGSIZE)
    80004508:	412984bb          	subw	s1,s3,s2
    8000450c:	0004879b          	sext.w	a5,s1
    80004510:	fcfcf4e3          	bgeu	s9,a5,800044d8 <exec+0xdc>
    80004514:	84d6                	mv	s1,s5
    80004516:	b7c9                	j	800044d8 <exec+0xdc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004518:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451c:	2d85                	addw	s11,s11,1
    8000451e:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004522:	e8845783          	lhu	a5,-376(s0)
    80004526:	08fdd163          	bge	s11,a5,800045a8 <exec+0x1ac>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000452a:	2d01                	sext.w	s10,s10
    8000452c:	03800713          	li	a4,56
    80004530:	86ea                	mv	a3,s10
    80004532:	e1840613          	add	a2,s0,-488
    80004536:	4581                	li	a1,0
    80004538:	8552                	mv	a0,s4
    8000453a:	ef1fe0ef          	jal	8000342a <readi>
    8000453e:	03800793          	li	a5,56
    80004542:	1af51c63          	bne	a0,a5,800046fa <exec+0x2fe>
    if(ph.type != ELF_PROG_LOAD)
    80004546:	e1842783          	lw	a5,-488(s0)
    8000454a:	4705                	li	a4,1
    8000454c:	fce798e3          	bne	a5,a4,8000451c <exec+0x120>
    if(ph.memsz < ph.filesz)
    80004550:	e4043483          	ld	s1,-448(s0)
    80004554:	e3843783          	ld	a5,-456(s0)
    80004558:	1af4ec63          	bltu	s1,a5,80004710 <exec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000455c:	e2843783          	ld	a5,-472(s0)
    80004560:	94be                	add	s1,s1,a5
    80004562:	1af4ea63          	bltu	s1,a5,80004716 <exec+0x31a>
    if(ph.vaddr % PGSIZE != 0)
    80004566:	df043703          	ld	a4,-528(s0)
    8000456a:	8ff9                	and	a5,a5,a4
    8000456c:	1a079863          	bnez	a5,8000471c <exec+0x320>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004570:	e1c42503          	lw	a0,-484(s0)
    80004574:	e6fff0ef          	jal	800043e2 <flags2perm>
    80004578:	86aa                	mv	a3,a0
    8000457a:	8626                	mv	a2,s1
    8000457c:	85ca                	mv	a1,s2
    8000457e:	855a                	mv	a0,s6
    80004580:	d61fc0ef          	jal	800012e0 <uvmalloc>
    80004584:	e0a43423          	sd	a0,-504(s0)
    80004588:	18050d63          	beqz	a0,80004722 <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000458c:	e2843b83          	ld	s7,-472(s0)
    80004590:	e2042c03          	lw	s8,-480(s0)
    80004594:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004598:	00098463          	beqz	s3,800045a0 <exec+0x1a4>
    8000459c:	4901                	li	s2,0
    8000459e:	bfa1                	j	800044f6 <exec+0xfa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045a0:	e0843903          	ld	s2,-504(s0)
    800045a4:	bfa5                	j	8000451c <exec+0x120>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045a6:	4901                	li	s2,0
  iunlockput(ip);
    800045a8:	8552                	mv	a0,s4
    800045aa:	e37fe0ef          	jal	800033e0 <iunlockput>
  end_op();
    800045ae:	d06ff0ef          	jal	80003ab4 <end_op>
  p = myproc();
    800045b2:	a7efd0ef          	jal	80001830 <myproc>
    800045b6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800045b8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800045bc:	6985                	lui	s3,0x1
    800045be:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800045c0:	99ca                	add	s3,s3,s2
    800045c2:	77fd                	lui	a5,0xfffff
    800045c4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800045c8:	4691                	li	a3,4
    800045ca:	6609                	lui	a2,0x2
    800045cc:	964e                	add	a2,a2,s3
    800045ce:	85ce                	mv	a1,s3
    800045d0:	855a                	mv	a0,s6
    800045d2:	d0ffc0ef          	jal	800012e0 <uvmalloc>
    800045d6:	892a                	mv	s2,a0
    800045d8:	e0a43423          	sd	a0,-504(s0)
    800045dc:	e509                	bnez	a0,800045e6 <exec+0x1ea>
  if(pagetable)
    800045de:	e1343423          	sd	s3,-504(s0)
    800045e2:	4a01                	li	s4,0
    800045e4:	aa29                	j	800046fe <exec+0x302>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800045e6:	75f9                	lui	a1,0xffffe
    800045e8:	95aa                	add	a1,a1,a0
    800045ea:	855a                	mv	a0,s6
    800045ec:	ed3fc0ef          	jal	800014be <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800045f0:	7bfd                	lui	s7,0xfffff
    800045f2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800045f4:	e0043783          	ld	a5,-512(s0)
    800045f8:	6388                	ld	a0,0(a5)
    800045fa:	cd39                	beqz	a0,80004658 <exec+0x25c>
    800045fc:	e9040993          	add	s3,s0,-368
    80004600:	f9040c13          	add	s8,s0,-112
    80004604:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004606:	fe4fc0ef          	jal	80000dea <strlen>
    8000460a:	0015079b          	addw	a5,a0,1
    8000460e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    80004612:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004616:	11796963          	bltu	s2,s7,80004728 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000461a:	e0043d03          	ld	s10,-512(s0)
    8000461e:	000d3a03          	ld	s4,0(s10)
    80004622:	8552                	mv	a0,s4
    80004624:	fc6fc0ef          	jal	80000dea <strlen>
    80004628:	0015069b          	addw	a3,a0,1
    8000462c:	8652                	mv	a2,s4
    8000462e:	85ca                	mv	a1,s2
    80004630:	855a                	mv	a0,s6
    80004632:	eb7fc0ef          	jal	800014e8 <copyout>
    80004636:	0e054b63          	bltz	a0,8000472c <exec+0x330>
    ustack[argc] = sp;
    8000463a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000463e:	0485                	add	s1,s1,1
    80004640:	008d0793          	add	a5,s10,8
    80004644:	e0f43023          	sd	a5,-512(s0)
    80004648:	008d3503          	ld	a0,8(s10)
    8000464c:	c909                	beqz	a0,8000465e <exec+0x262>
    if(argc >= MAXARG)
    8000464e:	09a1                	add	s3,s3,8
    80004650:	fb899be3          	bne	s3,s8,80004606 <exec+0x20a>
  ip = 0;
    80004654:	4a01                	li	s4,0
    80004656:	a065                	j	800046fe <exec+0x302>
  sp = sz;
    80004658:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000465c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000465e:	00349793          	sll	a5,s1,0x3
    80004662:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde4e0>
    80004666:	97a2                	add	a5,a5,s0
    80004668:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000466c:	00148693          	add	a3,s1,1
    80004670:	068e                	sll	a3,a3,0x3
    80004672:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004676:	ff097913          	and	s2,s2,-16
  sz = sz1;
    8000467a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000467e:	f77960e3          	bltu	s2,s7,800045de <exec+0x1e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004682:	e9040613          	add	a2,s0,-368
    80004686:	85ca                	mv	a1,s2
    80004688:	855a                	mv	a0,s6
    8000468a:	e5ffc0ef          	jal	800014e8 <copyout>
    8000468e:	0a054163          	bltz	a0,80004730 <exec+0x334>
  p->trapframe->a1 = sp;
    80004692:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004696:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000469a:	df843783          	ld	a5,-520(s0)
    8000469e:	0007c703          	lbu	a4,0(a5)
    800046a2:	cf11                	beqz	a4,800046be <exec+0x2c2>
    800046a4:	0785                	add	a5,a5,1
    if(*s == '/')
    800046a6:	02f00693          	li	a3,47
    800046aa:	a039                	j	800046b8 <exec+0x2bc>
      last = s+1;
    800046ac:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800046b0:	0785                	add	a5,a5,1
    800046b2:	fff7c703          	lbu	a4,-1(a5)
    800046b6:	c701                	beqz	a4,800046be <exec+0x2c2>
    if(*s == '/')
    800046b8:	fed71ce3          	bne	a4,a3,800046b0 <exec+0x2b4>
    800046bc:	bfc5                	j	800046ac <exec+0x2b0>
  safestrcpy(p->name, last, sizeof(p->name));
    800046be:	4641                	li	a2,16
    800046c0:	df843583          	ld	a1,-520(s0)
    800046c4:	158a8513          	add	a0,s5,344
    800046c8:	ef0fc0ef          	jal	80000db8 <safestrcpy>
  oldpagetable = p->pagetable;
    800046cc:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046d0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800046d4:	e0843783          	ld	a5,-504(s0)
    800046d8:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    800046dc:	058ab783          	ld	a5,88(s5)
    800046e0:	e6843703          	ld	a4,-408(s0)
    800046e4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    800046e6:	058ab783          	ld	a5,88(s5)
    800046ea:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046ee:	85e6                	mv	a1,s9
    800046f0:	a6cfd0ef          	jal	8000195c <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    800046f4:	0004851b          	sext.w	a0,s1
    800046f8:	b341                	j	80004478 <exec+0x7c>
    800046fa:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800046fe:	e0843583          	ld	a1,-504(s0)
    80004702:	855a                	mv	a0,s6
    80004704:	a58fd0ef          	jal	8000195c <proc_freepagetable>
  return -1;
    80004708:	557d                	li	a0,-1
  if(ip){
    8000470a:	d60a07e3          	beqz	s4,80004478 <exec+0x7c>
    8000470e:	bbb9                	j	8000446c <exec+0x70>
    80004710:	e1243423          	sd	s2,-504(s0)
    80004714:	b7ed                	j	800046fe <exec+0x302>
    80004716:	e1243423          	sd	s2,-504(s0)
    8000471a:	b7d5                	j	800046fe <exec+0x302>
    8000471c:	e1243423          	sd	s2,-504(s0)
    80004720:	bff9                	j	800046fe <exec+0x302>
    80004722:	e1243423          	sd	s2,-504(s0)
    80004726:	bfe1                	j	800046fe <exec+0x302>
  ip = 0;
    80004728:	4a01                	li	s4,0
    8000472a:	bfd1                	j	800046fe <exec+0x302>
    8000472c:	4a01                	li	s4,0
  if(pagetable)
    8000472e:	bfc1                	j	800046fe <exec+0x302>
  sz = sz1;
    80004730:	e0843983          	ld	s3,-504(s0)
    80004734:	b56d                	j	800045de <exec+0x1e2>

0000000080004736 <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004736:	7179                	add	sp,sp,-48
    80004738:	f406                	sd	ra,40(sp)
    8000473a:	f022                	sd	s0,32(sp)
    8000473c:	ec26                	sd	s1,24(sp)
    8000473e:	e84a                	sd	s2,16(sp)
    80004740:	1800                	add	s0,sp,48
    80004742:	892e                	mv	s2,a1
    80004744:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004746:	fdc40593          	add	a1,s0,-36
    8000474a:	f95fd0ef          	jal	800026de <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000474e:	fdc42703          	lw	a4,-36(s0)
    80004752:	47bd                	li	a5,15
    80004754:	02e7e963          	bltu	a5,a4,80004786 <argfd+0x50>
    80004758:	8d8fd0ef          	jal	80001830 <myproc>
    8000475c:	fdc42703          	lw	a4,-36(s0)
    80004760:	01a70793          	add	a5,a4,26
    80004764:	078e                	sll	a5,a5,0x3
    80004766:	953e                	add	a0,a0,a5
    80004768:	611c                	ld	a5,0(a0)
    8000476a:	c385                	beqz	a5,8000478a <argfd+0x54>
    return -1;
  if(pfd)
    8000476c:	00090463          	beqz	s2,80004774 <argfd+0x3e>
    *pfd = fd;
    80004770:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004774:	4501                	li	a0,0
  if(pf)
    80004776:	c091                	beqz	s1,8000477a <argfd+0x44>
    *pf = f;
    80004778:	e09c                	sd	a5,0(s1)
}
    8000477a:	70a2                	ld	ra,40(sp)
    8000477c:	7402                	ld	s0,32(sp)
    8000477e:	64e2                	ld	s1,24(sp)
    80004780:	6942                	ld	s2,16(sp)
    80004782:	6145                	add	sp,sp,48
    80004784:	8082                	ret
    return -1;
    80004786:	557d                	li	a0,-1
    80004788:	bfcd                	j	8000477a <argfd+0x44>
    8000478a:	557d                	li	a0,-1
    8000478c:	b7fd                	j	8000477a <argfd+0x44>

000000008000478e <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    8000478e:	1101                	add	sp,sp,-32
    80004790:	ec06                	sd	ra,24(sp)
    80004792:	e822                	sd	s0,16(sp)
    80004794:	e426                	sd	s1,8(sp)
    80004796:	1000                	add	s0,sp,32
    80004798:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000479a:	896fd0ef          	jal	80001830 <myproc>
    8000479e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047a0:	0d050793          	add	a5,a0,208
    800047a4:	4501                	li	a0,0
    800047a6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047a8:	6398                	ld	a4,0(a5)
    800047aa:	cb19                	beqz	a4,800047c0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800047ac:	2505                	addw	a0,a0,1
    800047ae:	07a1                	add	a5,a5,8
    800047b0:	fed51ce3          	bne	a0,a3,800047a8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047b4:	557d                	li	a0,-1
}
    800047b6:	60e2                	ld	ra,24(sp)
    800047b8:	6442                	ld	s0,16(sp)
    800047ba:	64a2                	ld	s1,8(sp)
    800047bc:	6105                	add	sp,sp,32
    800047be:	8082                	ret
      p->ofile[fd] = f;
    800047c0:	01a50793          	add	a5,a0,26
    800047c4:	078e                	sll	a5,a5,0x3
    800047c6:	963e                	add	a2,a2,a5
    800047c8:	e204                	sd	s1,0(a2)
      return fd;
    800047ca:	b7f5                	j	800047b6 <fdalloc+0x28>

00000000800047cc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800047cc:	715d                	add	sp,sp,-80
    800047ce:	e486                	sd	ra,72(sp)
    800047d0:	e0a2                	sd	s0,64(sp)
    800047d2:	fc26                	sd	s1,56(sp)
    800047d4:	f84a                	sd	s2,48(sp)
    800047d6:	f44e                	sd	s3,40(sp)
    800047d8:	f052                	sd	s4,32(sp)
    800047da:	ec56                	sd	s5,24(sp)
    800047dc:	e85a                	sd	s6,16(sp)
    800047de:	0880                	add	s0,sp,80
    800047e0:	8b2e                	mv	s6,a1
    800047e2:	89b2                	mv	s3,a2
    800047e4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800047e6:	fb040593          	add	a1,s0,-80
    800047ea:	8beff0ef          	jal	800038a8 <nameiparent>
    800047ee:	84aa                	mv	s1,a0
    800047f0:	10050763          	beqz	a0,800048fe <create+0x132>
    return 0;

  ilock(dp);
    800047f4:	95dfe0ef          	jal	80003150 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047f8:	4601                	li	a2,0
    800047fa:	fb040593          	add	a1,s0,-80
    800047fe:	8526                	mv	a0,s1
    80004800:	e29fe0ef          	jal	80003628 <dirlookup>
    80004804:	8aaa                	mv	s5,a0
    80004806:	c131                	beqz	a0,8000484a <create+0x7e>
    iunlockput(dp);
    80004808:	8526                	mv	a0,s1
    8000480a:	bd7fe0ef          	jal	800033e0 <iunlockput>
    ilock(ip);
    8000480e:	8556                	mv	a0,s5
    80004810:	941fe0ef          	jal	80003150 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004814:	4789                	li	a5,2
    80004816:	02fb1563          	bne	s6,a5,80004840 <create+0x74>
    8000481a:	044ad783          	lhu	a5,68(s5)
    8000481e:	37f9                	addw	a5,a5,-2
    80004820:	17c2                	sll	a5,a5,0x30
    80004822:	93c1                	srl	a5,a5,0x30
    80004824:	4705                	li	a4,1
    80004826:	00f76d63          	bltu	a4,a5,80004840 <create+0x74>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000482a:	8556                	mv	a0,s5
    8000482c:	60a6                	ld	ra,72(sp)
    8000482e:	6406                	ld	s0,64(sp)
    80004830:	74e2                	ld	s1,56(sp)
    80004832:	7942                	ld	s2,48(sp)
    80004834:	79a2                	ld	s3,40(sp)
    80004836:	7a02                	ld	s4,32(sp)
    80004838:	6ae2                	ld	s5,24(sp)
    8000483a:	6b42                	ld	s6,16(sp)
    8000483c:	6161                	add	sp,sp,80
    8000483e:	8082                	ret
    iunlockput(ip);
    80004840:	8556                	mv	a0,s5
    80004842:	b9ffe0ef          	jal	800033e0 <iunlockput>
    return 0;
    80004846:	4a81                	li	s5,0
    80004848:	b7cd                	j	8000482a <create+0x5e>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000484a:	85da                	mv	a1,s6
    8000484c:	4088                	lw	a0,0(s1)
    8000484e:	f9efe0ef          	jal	80002fec <ialloc>
    80004852:	8a2a                	mv	s4,a0
    80004854:	cd0d                	beqz	a0,8000488e <create+0xc2>
  ilock(ip);
    80004856:	8fbfe0ef          	jal	80003150 <ilock>
  ip->major = major;
    8000485a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000485e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004862:	4905                	li	s2,1
    80004864:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004868:	8552                	mv	a0,s4
    8000486a:	833fe0ef          	jal	8000309c <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    8000486e:	032b0563          	beq	s6,s2,80004898 <create+0xcc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004872:	004a2603          	lw	a2,4(s4)
    80004876:	fb040593          	add	a1,s0,-80
    8000487a:	8526                	mv	a0,s1
    8000487c:	f79fe0ef          	jal	800037f4 <dirlink>
    80004880:	06054363          	bltz	a0,800048e6 <create+0x11a>
  iunlockput(dp);
    80004884:	8526                	mv	a0,s1
    80004886:	b5bfe0ef          	jal	800033e0 <iunlockput>
  return ip;
    8000488a:	8ad2                	mv	s5,s4
    8000488c:	bf79                	j	8000482a <create+0x5e>
    iunlockput(dp);
    8000488e:	8526                	mv	a0,s1
    80004890:	b51fe0ef          	jal	800033e0 <iunlockput>
    return 0;
    80004894:	8ad2                	mv	s5,s4
    80004896:	bf51                	j	8000482a <create+0x5e>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004898:	004a2603          	lw	a2,4(s4)
    8000489c:	00003597          	auipc	a1,0x3
    800048a0:	e9458593          	add	a1,a1,-364 # 80007730 <syscalls+0x2a0>
    800048a4:	8552                	mv	a0,s4
    800048a6:	f4ffe0ef          	jal	800037f4 <dirlink>
    800048aa:	02054e63          	bltz	a0,800048e6 <create+0x11a>
    800048ae:	40d0                	lw	a2,4(s1)
    800048b0:	00003597          	auipc	a1,0x3
    800048b4:	e8858593          	add	a1,a1,-376 # 80007738 <syscalls+0x2a8>
    800048b8:	8552                	mv	a0,s4
    800048ba:	f3bfe0ef          	jal	800037f4 <dirlink>
    800048be:	02054463          	bltz	a0,800048e6 <create+0x11a>
  if(dirlink(dp, name, ip->inum) < 0)
    800048c2:	004a2603          	lw	a2,4(s4)
    800048c6:	fb040593          	add	a1,s0,-80
    800048ca:	8526                	mv	a0,s1
    800048cc:	f29fe0ef          	jal	800037f4 <dirlink>
    800048d0:	00054b63          	bltz	a0,800048e6 <create+0x11a>
    dp->nlink++;  /* for ".." */
    800048d4:	04a4d783          	lhu	a5,74(s1)
    800048d8:	2785                	addw	a5,a5,1
    800048da:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800048de:	8526                	mv	a0,s1
    800048e0:	fbcfe0ef          	jal	8000309c <iupdate>
    800048e4:	b745                	j	80004884 <create+0xb8>
  ip->nlink = 0;
    800048e6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800048ea:	8552                	mv	a0,s4
    800048ec:	fb0fe0ef          	jal	8000309c <iupdate>
  iunlockput(ip);
    800048f0:	8552                	mv	a0,s4
    800048f2:	aeffe0ef          	jal	800033e0 <iunlockput>
  iunlockput(dp);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ae9fe0ef          	jal	800033e0 <iunlockput>
  return 0;
    800048fc:	b73d                	j	8000482a <create+0x5e>
    return 0;
    800048fe:	8aaa                	mv	s5,a0
    80004900:	b72d                	j	8000482a <create+0x5e>

0000000080004902 <sys_dup>:
{
    80004902:	7179                	add	sp,sp,-48
    80004904:	f406                	sd	ra,40(sp)
    80004906:	f022                	sd	s0,32(sp)
    80004908:	ec26                	sd	s1,24(sp)
    8000490a:	e84a                	sd	s2,16(sp)
    8000490c:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000490e:	fd840613          	add	a2,s0,-40
    80004912:	4581                	li	a1,0
    80004914:	4501                	li	a0,0
    80004916:	e21ff0ef          	jal	80004736 <argfd>
    return -1;
    8000491a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000491c:	00054f63          	bltz	a0,8000493a <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80004920:	fd843903          	ld	s2,-40(s0)
    80004924:	854a                	mv	a0,s2
    80004926:	e69ff0ef          	jal	8000478e <fdalloc>
    8000492a:	84aa                	mv	s1,a0
    return -1;
    8000492c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000492e:	00054663          	bltz	a0,8000493a <sys_dup+0x38>
  filedup(f);
    80004932:	854a                	mv	a0,s2
    80004934:	ce4ff0ef          	jal	80003e18 <filedup>
  return fd;
    80004938:	87a6                	mv	a5,s1
}
    8000493a:	853e                	mv	a0,a5
    8000493c:	70a2                	ld	ra,40(sp)
    8000493e:	7402                	ld	s0,32(sp)
    80004940:	64e2                	ld	s1,24(sp)
    80004942:	6942                	ld	s2,16(sp)
    80004944:	6145                	add	sp,sp,48
    80004946:	8082                	ret

0000000080004948 <sys_read>:
{
    80004948:	7179                	add	sp,sp,-48
    8000494a:	f406                	sd	ra,40(sp)
    8000494c:	f022                	sd	s0,32(sp)
    8000494e:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004950:	fd840593          	add	a1,s0,-40
    80004954:	4505                	li	a0,1
    80004956:	da5fd0ef          	jal	800026fa <argaddr>
  argint(2, &n);
    8000495a:	fe440593          	add	a1,s0,-28
    8000495e:	4509                	li	a0,2
    80004960:	d7ffd0ef          	jal	800026de <argint>
  if(argfd(0, 0, &f) < 0)
    80004964:	fe840613          	add	a2,s0,-24
    80004968:	4581                	li	a1,0
    8000496a:	4501                	li	a0,0
    8000496c:	dcbff0ef          	jal	80004736 <argfd>
    80004970:	87aa                	mv	a5,a0
    return -1;
    80004972:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004974:	0007ca63          	bltz	a5,80004988 <sys_read+0x40>
  return fileread(f, p, n);
    80004978:	fe442603          	lw	a2,-28(s0)
    8000497c:	fd843583          	ld	a1,-40(s0)
    80004980:	fe843503          	ld	a0,-24(s0)
    80004984:	de0ff0ef          	jal	80003f64 <fileread>
}
    80004988:	70a2                	ld	ra,40(sp)
    8000498a:	7402                	ld	s0,32(sp)
    8000498c:	6145                	add	sp,sp,48
    8000498e:	8082                	ret

0000000080004990 <sys_write>:
{
    80004990:	7179                	add	sp,sp,-48
    80004992:	f406                	sd	ra,40(sp)
    80004994:	f022                	sd	s0,32(sp)
    80004996:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004998:	fd840593          	add	a1,s0,-40
    8000499c:	4505                	li	a0,1
    8000499e:	d5dfd0ef          	jal	800026fa <argaddr>
  argint(2, &n);
    800049a2:	fe440593          	add	a1,s0,-28
    800049a6:	4509                	li	a0,2
    800049a8:	d37fd0ef          	jal	800026de <argint>
  if(argfd(0, 0, &f) < 0)
    800049ac:	fe840613          	add	a2,s0,-24
    800049b0:	4581                	li	a1,0
    800049b2:	4501                	li	a0,0
    800049b4:	d83ff0ef          	jal	80004736 <argfd>
    800049b8:	87aa                	mv	a5,a0
    return -1;
    800049ba:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049bc:	0007ca63          	bltz	a5,800049d0 <sys_write+0x40>
  return filewrite(f, p, n);
    800049c0:	fe442603          	lw	a2,-28(s0)
    800049c4:	fd843583          	ld	a1,-40(s0)
    800049c8:	fe843503          	ld	a0,-24(s0)
    800049cc:	e46ff0ef          	jal	80004012 <filewrite>
}
    800049d0:	70a2                	ld	ra,40(sp)
    800049d2:	7402                	ld	s0,32(sp)
    800049d4:	6145                	add	sp,sp,48
    800049d6:	8082                	ret

00000000800049d8 <sys_close>:
{
    800049d8:	1101                	add	sp,sp,-32
    800049da:	ec06                	sd	ra,24(sp)
    800049dc:	e822                	sd	s0,16(sp)
    800049de:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049e0:	fe040613          	add	a2,s0,-32
    800049e4:	fec40593          	add	a1,s0,-20
    800049e8:	4501                	li	a0,0
    800049ea:	d4dff0ef          	jal	80004736 <argfd>
    return -1;
    800049ee:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049f0:	02054063          	bltz	a0,80004a10 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800049f4:	e3dfc0ef          	jal	80001830 <myproc>
    800049f8:	fec42783          	lw	a5,-20(s0)
    800049fc:	07e9                	add	a5,a5,26
    800049fe:	078e                	sll	a5,a5,0x3
    80004a00:	953e                	add	a0,a0,a5
    80004a02:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a06:	fe043503          	ld	a0,-32(s0)
    80004a0a:	c54ff0ef          	jal	80003e5e <fileclose>
  return 0;
    80004a0e:	4781                	li	a5,0
}
    80004a10:	853e                	mv	a0,a5
    80004a12:	60e2                	ld	ra,24(sp)
    80004a14:	6442                	ld	s0,16(sp)
    80004a16:	6105                	add	sp,sp,32
    80004a18:	8082                	ret

0000000080004a1a <sys_fstat>:
{
    80004a1a:	1101                	add	sp,sp,-32
    80004a1c:	ec06                	sd	ra,24(sp)
    80004a1e:	e822                	sd	s0,16(sp)
    80004a20:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004a22:	fe040593          	add	a1,s0,-32
    80004a26:	4505                	li	a0,1
    80004a28:	cd3fd0ef          	jal	800026fa <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004a2c:	fe840613          	add	a2,s0,-24
    80004a30:	4581                	li	a1,0
    80004a32:	4501                	li	a0,0
    80004a34:	d03ff0ef          	jal	80004736 <argfd>
    80004a38:	87aa                	mv	a5,a0
    return -1;
    80004a3a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a3c:	0007c863          	bltz	a5,80004a4c <sys_fstat+0x32>
  return filestat(f, st);
    80004a40:	fe043583          	ld	a1,-32(s0)
    80004a44:	fe843503          	ld	a0,-24(s0)
    80004a48:	cbeff0ef          	jal	80003f06 <filestat>
}
    80004a4c:	60e2                	ld	ra,24(sp)
    80004a4e:	6442                	ld	s0,16(sp)
    80004a50:	6105                	add	sp,sp,32
    80004a52:	8082                	ret

0000000080004a54 <sys_link>:
{
    80004a54:	7169                	add	sp,sp,-304
    80004a56:	f606                	sd	ra,296(sp)
    80004a58:	f222                	sd	s0,288(sp)
    80004a5a:	ee26                	sd	s1,280(sp)
    80004a5c:	ea4a                	sd	s2,272(sp)
    80004a5e:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a60:	08000613          	li	a2,128
    80004a64:	ed040593          	add	a1,s0,-304
    80004a68:	4501                	li	a0,0
    80004a6a:	cadfd0ef          	jal	80002716 <argstr>
    return -1;
    80004a6e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a70:	0c054663          	bltz	a0,80004b3c <sys_link+0xe8>
    80004a74:	08000613          	li	a2,128
    80004a78:	f5040593          	add	a1,s0,-176
    80004a7c:	4505                	li	a0,1
    80004a7e:	c99fd0ef          	jal	80002716 <argstr>
    return -1;
    80004a82:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a84:	0a054c63          	bltz	a0,80004b3c <sys_link+0xe8>
  begin_op();
    80004a88:	fc3fe0ef          	jal	80003a4a <begin_op>
  if((ip = namei(old)) == 0){
    80004a8c:	ed040513          	add	a0,s0,-304
    80004a90:	dfffe0ef          	jal	8000388e <namei>
    80004a94:	84aa                	mv	s1,a0
    80004a96:	c525                	beqz	a0,80004afe <sys_link+0xaa>
  ilock(ip);
    80004a98:	eb8fe0ef          	jal	80003150 <ilock>
  if(ip->type == T_DIR){
    80004a9c:	04449703          	lh	a4,68(s1)
    80004aa0:	4785                	li	a5,1
    80004aa2:	06f70263          	beq	a4,a5,80004b06 <sys_link+0xb2>
  ip->nlink++;
    80004aa6:	04a4d783          	lhu	a5,74(s1)
    80004aaa:	2785                	addw	a5,a5,1
    80004aac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	deafe0ef          	jal	8000309c <iupdate>
  iunlock(ip);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	f42fe0ef          	jal	800031fa <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004abc:	fd040593          	add	a1,s0,-48
    80004ac0:	f5040513          	add	a0,s0,-176
    80004ac4:	de5fe0ef          	jal	800038a8 <nameiparent>
    80004ac8:	892a                	mv	s2,a0
    80004aca:	c921                	beqz	a0,80004b1a <sys_link+0xc6>
  ilock(dp);
    80004acc:	e84fe0ef          	jal	80003150 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ad0:	00092703          	lw	a4,0(s2)
    80004ad4:	409c                	lw	a5,0(s1)
    80004ad6:	02f71f63          	bne	a4,a5,80004b14 <sys_link+0xc0>
    80004ada:	40d0                	lw	a2,4(s1)
    80004adc:	fd040593          	add	a1,s0,-48
    80004ae0:	854a                	mv	a0,s2
    80004ae2:	d13fe0ef          	jal	800037f4 <dirlink>
    80004ae6:	02054763          	bltz	a0,80004b14 <sys_link+0xc0>
  iunlockput(dp);
    80004aea:	854a                	mv	a0,s2
    80004aec:	8f5fe0ef          	jal	800033e0 <iunlockput>
  iput(ip);
    80004af0:	8526                	mv	a0,s1
    80004af2:	867fe0ef          	jal	80003358 <iput>
  end_op();
    80004af6:	fbffe0ef          	jal	80003ab4 <end_op>
  return 0;
    80004afa:	4781                	li	a5,0
    80004afc:	a081                	j	80004b3c <sys_link+0xe8>
    end_op();
    80004afe:	fb7fe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004b02:	57fd                	li	a5,-1
    80004b04:	a825                	j	80004b3c <sys_link+0xe8>
    iunlockput(ip);
    80004b06:	8526                	mv	a0,s1
    80004b08:	8d9fe0ef          	jal	800033e0 <iunlockput>
    end_op();
    80004b0c:	fa9fe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004b10:	57fd                	li	a5,-1
    80004b12:	a02d                	j	80004b3c <sys_link+0xe8>
    iunlockput(dp);
    80004b14:	854a                	mv	a0,s2
    80004b16:	8cbfe0ef          	jal	800033e0 <iunlockput>
  ilock(ip);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	e34fe0ef          	jal	80003150 <ilock>
  ip->nlink--;
    80004b20:	04a4d783          	lhu	a5,74(s1)
    80004b24:	37fd                	addw	a5,a5,-1
    80004b26:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	d70fe0ef          	jal	8000309c <iupdate>
  iunlockput(ip);
    80004b30:	8526                	mv	a0,s1
    80004b32:	8affe0ef          	jal	800033e0 <iunlockput>
  end_op();
    80004b36:	f7ffe0ef          	jal	80003ab4 <end_op>
  return -1;
    80004b3a:	57fd                	li	a5,-1
}
    80004b3c:	853e                	mv	a0,a5
    80004b3e:	70b2                	ld	ra,296(sp)
    80004b40:	7412                	ld	s0,288(sp)
    80004b42:	64f2                	ld	s1,280(sp)
    80004b44:	6952                	ld	s2,272(sp)
    80004b46:	6155                	add	sp,sp,304
    80004b48:	8082                	ret

0000000080004b4a <sys_unlink>:
{
    80004b4a:	7151                	add	sp,sp,-240
    80004b4c:	f586                	sd	ra,232(sp)
    80004b4e:	f1a2                	sd	s0,224(sp)
    80004b50:	eda6                	sd	s1,216(sp)
    80004b52:	e9ca                	sd	s2,208(sp)
    80004b54:	e5ce                	sd	s3,200(sp)
    80004b56:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b58:	08000613          	li	a2,128
    80004b5c:	f3040593          	add	a1,s0,-208
    80004b60:	4501                	li	a0,0
    80004b62:	bb5fd0ef          	jal	80002716 <argstr>
    80004b66:	12054b63          	bltz	a0,80004c9c <sys_unlink+0x152>
  begin_op();
    80004b6a:	ee1fe0ef          	jal	80003a4a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b6e:	fb040593          	add	a1,s0,-80
    80004b72:	f3040513          	add	a0,s0,-208
    80004b76:	d33fe0ef          	jal	800038a8 <nameiparent>
    80004b7a:	84aa                	mv	s1,a0
    80004b7c:	c54d                	beqz	a0,80004c26 <sys_unlink+0xdc>
  ilock(dp);
    80004b7e:	dd2fe0ef          	jal	80003150 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b82:	00003597          	auipc	a1,0x3
    80004b86:	bae58593          	add	a1,a1,-1106 # 80007730 <syscalls+0x2a0>
    80004b8a:	fb040513          	add	a0,s0,-80
    80004b8e:	a85fe0ef          	jal	80003612 <namecmp>
    80004b92:	10050a63          	beqz	a0,80004ca6 <sys_unlink+0x15c>
    80004b96:	00003597          	auipc	a1,0x3
    80004b9a:	ba258593          	add	a1,a1,-1118 # 80007738 <syscalls+0x2a8>
    80004b9e:	fb040513          	add	a0,s0,-80
    80004ba2:	a71fe0ef          	jal	80003612 <namecmp>
    80004ba6:	10050063          	beqz	a0,80004ca6 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004baa:	f2c40613          	add	a2,s0,-212
    80004bae:	fb040593          	add	a1,s0,-80
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	a75fe0ef          	jal	80003628 <dirlookup>
    80004bb8:	892a                	mv	s2,a0
    80004bba:	0e050663          	beqz	a0,80004ca6 <sys_unlink+0x15c>
  ilock(ip);
    80004bbe:	d92fe0ef          	jal	80003150 <ilock>
  if(ip->nlink < 1)
    80004bc2:	04a91783          	lh	a5,74(s2)
    80004bc6:	06f05463          	blez	a5,80004c2e <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bca:	04491703          	lh	a4,68(s2)
    80004bce:	4785                	li	a5,1
    80004bd0:	06f70563          	beq	a4,a5,80004c3a <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004bd4:	4641                	li	a2,16
    80004bd6:	4581                	li	a1,0
    80004bd8:	fc040513          	add	a0,s0,-64
    80004bdc:	898fc0ef          	jal	80000c74 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004be0:	4741                	li	a4,16
    80004be2:	f2c42683          	lw	a3,-212(s0)
    80004be6:	fc040613          	add	a2,s0,-64
    80004bea:	4581                	li	a1,0
    80004bec:	8526                	mv	a0,s1
    80004bee:	921fe0ef          	jal	8000350e <writei>
    80004bf2:	47c1                	li	a5,16
    80004bf4:	08f51563          	bne	a0,a5,80004c7e <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004bf8:	04491703          	lh	a4,68(s2)
    80004bfc:	4785                	li	a5,1
    80004bfe:	08f70663          	beq	a4,a5,80004c8a <sys_unlink+0x140>
  iunlockput(dp);
    80004c02:	8526                	mv	a0,s1
    80004c04:	fdcfe0ef          	jal	800033e0 <iunlockput>
  ip->nlink--;
    80004c08:	04a95783          	lhu	a5,74(s2)
    80004c0c:	37fd                	addw	a5,a5,-1
    80004c0e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c12:	854a                	mv	a0,s2
    80004c14:	c88fe0ef          	jal	8000309c <iupdate>
  iunlockput(ip);
    80004c18:	854a                	mv	a0,s2
    80004c1a:	fc6fe0ef          	jal	800033e0 <iunlockput>
  end_op();
    80004c1e:	e97fe0ef          	jal	80003ab4 <end_op>
  return 0;
    80004c22:	4501                	li	a0,0
    80004c24:	a079                	j	80004cb2 <sys_unlink+0x168>
    end_op();
    80004c26:	e8ffe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004c2a:	557d                	li	a0,-1
    80004c2c:	a059                	j	80004cb2 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004c2e:	00003517          	auipc	a0,0x3
    80004c32:	b1250513          	add	a0,a0,-1262 # 80007740 <syscalls+0x2b0>
    80004c36:	b29fb0ef          	jal	8000075e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c3a:	04c92703          	lw	a4,76(s2)
    80004c3e:	02000793          	li	a5,32
    80004c42:	f8e7f9e3          	bgeu	a5,a4,80004bd4 <sys_unlink+0x8a>
    80004c46:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c4a:	4741                	li	a4,16
    80004c4c:	86ce                	mv	a3,s3
    80004c4e:	f1840613          	add	a2,s0,-232
    80004c52:	4581                	li	a1,0
    80004c54:	854a                	mv	a0,s2
    80004c56:	fd4fe0ef          	jal	8000342a <readi>
    80004c5a:	47c1                	li	a5,16
    80004c5c:	00f51b63          	bne	a0,a5,80004c72 <sys_unlink+0x128>
    if(de.inum != 0)
    80004c60:	f1845783          	lhu	a5,-232(s0)
    80004c64:	ef95                	bnez	a5,80004ca0 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c66:	29c1                	addw	s3,s3,16
    80004c68:	04c92783          	lw	a5,76(s2)
    80004c6c:	fcf9efe3          	bltu	s3,a5,80004c4a <sys_unlink+0x100>
    80004c70:	b795                	j	80004bd4 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004c72:	00003517          	auipc	a0,0x3
    80004c76:	ae650513          	add	a0,a0,-1306 # 80007758 <syscalls+0x2c8>
    80004c7a:	ae5fb0ef          	jal	8000075e <panic>
    panic("unlink: writei");
    80004c7e:	00003517          	auipc	a0,0x3
    80004c82:	af250513          	add	a0,a0,-1294 # 80007770 <syscalls+0x2e0>
    80004c86:	ad9fb0ef          	jal	8000075e <panic>
    dp->nlink--;
    80004c8a:	04a4d783          	lhu	a5,74(s1)
    80004c8e:	37fd                	addw	a5,a5,-1
    80004c90:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c94:	8526                	mv	a0,s1
    80004c96:	c06fe0ef          	jal	8000309c <iupdate>
    80004c9a:	b7a5                	j	80004c02 <sys_unlink+0xb8>
    return -1;
    80004c9c:	557d                	li	a0,-1
    80004c9e:	a811                	j	80004cb2 <sys_unlink+0x168>
    iunlockput(ip);
    80004ca0:	854a                	mv	a0,s2
    80004ca2:	f3efe0ef          	jal	800033e0 <iunlockput>
  iunlockput(dp);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	f38fe0ef          	jal	800033e0 <iunlockput>
  end_op();
    80004cac:	e09fe0ef          	jal	80003ab4 <end_op>
  return -1;
    80004cb0:	557d                	li	a0,-1
}
    80004cb2:	70ae                	ld	ra,232(sp)
    80004cb4:	740e                	ld	s0,224(sp)
    80004cb6:	64ee                	ld	s1,216(sp)
    80004cb8:	694e                	ld	s2,208(sp)
    80004cba:	69ae                	ld	s3,200(sp)
    80004cbc:	616d                	add	sp,sp,240
    80004cbe:	8082                	ret

0000000080004cc0 <sys_open>:

uint64
sys_open(void)
{
    80004cc0:	7131                	add	sp,sp,-192
    80004cc2:	fd06                	sd	ra,184(sp)
    80004cc4:	f922                	sd	s0,176(sp)
    80004cc6:	f526                	sd	s1,168(sp)
    80004cc8:	f14a                	sd	s2,160(sp)
    80004cca:	ed4e                	sd	s3,152(sp)
    80004ccc:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cce:	f4c40593          	add	a1,s0,-180
    80004cd2:	4505                	li	a0,1
    80004cd4:	a0bfd0ef          	jal	800026de <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cd8:	08000613          	li	a2,128
    80004cdc:	f5040593          	add	a1,s0,-176
    80004ce0:	4501                	li	a0,0
    80004ce2:	a35fd0ef          	jal	80002716 <argstr>
    80004ce6:	87aa                	mv	a5,a0
    return -1;
    80004ce8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cea:	0807cc63          	bltz	a5,80004d82 <sys_open+0xc2>

  begin_op();
    80004cee:	d5dfe0ef          	jal	80003a4a <begin_op>

  if(omode & O_CREATE){
    80004cf2:	f4c42783          	lw	a5,-180(s0)
    80004cf6:	2007f793          	and	a5,a5,512
    80004cfa:	cfd9                	beqz	a5,80004d98 <sys_open+0xd8>
    ip = create(path, T_FILE, 0, 0);
    80004cfc:	4681                	li	a3,0
    80004cfe:	4601                	li	a2,0
    80004d00:	4589                	li	a1,2
    80004d02:	f5040513          	add	a0,s0,-176
    80004d06:	ac7ff0ef          	jal	800047cc <create>
    80004d0a:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d0c:	c151                	beqz	a0,80004d90 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d0e:	04449703          	lh	a4,68(s1)
    80004d12:	478d                	li	a5,3
    80004d14:	00f71763          	bne	a4,a5,80004d22 <sys_open+0x62>
    80004d18:	0464d703          	lhu	a4,70(s1)
    80004d1c:	47a5                	li	a5,9
    80004d1e:	0ae7e863          	bltu	a5,a4,80004dce <sys_open+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d22:	898ff0ef          	jal	80003dba <filealloc>
    80004d26:	892a                	mv	s2,a0
    80004d28:	cd4d                	beqz	a0,80004de2 <sys_open+0x122>
    80004d2a:	a65ff0ef          	jal	8000478e <fdalloc>
    80004d2e:	89aa                	mv	s3,a0
    80004d30:	0a054663          	bltz	a0,80004ddc <sys_open+0x11c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d34:	04449703          	lh	a4,68(s1)
    80004d38:	478d                	li	a5,3
    80004d3a:	0af70b63          	beq	a4,a5,80004df0 <sys_open+0x130>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d3e:	4789                	li	a5,2
    80004d40:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004d44:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004d48:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004d4c:	f4c42783          	lw	a5,-180(s0)
    80004d50:	0017c713          	xor	a4,a5,1
    80004d54:	8b05                	and	a4,a4,1
    80004d56:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d5a:	0037f713          	and	a4,a5,3
    80004d5e:	00e03733          	snez	a4,a4
    80004d62:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d66:	4007f793          	and	a5,a5,1024
    80004d6a:	c791                	beqz	a5,80004d76 <sys_open+0xb6>
    80004d6c:	04449703          	lh	a4,68(s1)
    80004d70:	4789                	li	a5,2
    80004d72:	08f70663          	beq	a4,a5,80004dfe <sys_open+0x13e>
    itrunc(ip);
  }

  iunlock(ip);
    80004d76:	8526                	mv	a0,s1
    80004d78:	c82fe0ef          	jal	800031fa <iunlock>
  end_op();
    80004d7c:	d39fe0ef          	jal	80003ab4 <end_op>

  return fd;
    80004d80:	854e                	mv	a0,s3
}
    80004d82:	70ea                	ld	ra,184(sp)
    80004d84:	744a                	ld	s0,176(sp)
    80004d86:	74aa                	ld	s1,168(sp)
    80004d88:	790a                	ld	s2,160(sp)
    80004d8a:	69ea                	ld	s3,152(sp)
    80004d8c:	6129                	add	sp,sp,192
    80004d8e:	8082                	ret
      end_op();
    80004d90:	d25fe0ef          	jal	80003ab4 <end_op>
      return -1;
    80004d94:	557d                	li	a0,-1
    80004d96:	b7f5                	j	80004d82 <sys_open+0xc2>
    if((ip = namei(path)) == 0){
    80004d98:	f5040513          	add	a0,s0,-176
    80004d9c:	af3fe0ef          	jal	8000388e <namei>
    80004da0:	84aa                	mv	s1,a0
    80004da2:	c115                	beqz	a0,80004dc6 <sys_open+0x106>
    ilock(ip);
    80004da4:	bacfe0ef          	jal	80003150 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004da8:	04449703          	lh	a4,68(s1)
    80004dac:	4785                	li	a5,1
    80004dae:	f6f710e3          	bne	a4,a5,80004d0e <sys_open+0x4e>
    80004db2:	f4c42783          	lw	a5,-180(s0)
    80004db6:	d7b5                	beqz	a5,80004d22 <sys_open+0x62>
      iunlockput(ip);
    80004db8:	8526                	mv	a0,s1
    80004dba:	e26fe0ef          	jal	800033e0 <iunlockput>
      end_op();
    80004dbe:	cf7fe0ef          	jal	80003ab4 <end_op>
      return -1;
    80004dc2:	557d                	li	a0,-1
    80004dc4:	bf7d                	j	80004d82 <sys_open+0xc2>
      end_op();
    80004dc6:	ceffe0ef          	jal	80003ab4 <end_op>
      return -1;
    80004dca:	557d                	li	a0,-1
    80004dcc:	bf5d                	j	80004d82 <sys_open+0xc2>
    iunlockput(ip);
    80004dce:	8526                	mv	a0,s1
    80004dd0:	e10fe0ef          	jal	800033e0 <iunlockput>
    end_op();
    80004dd4:	ce1fe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004dd8:	557d                	li	a0,-1
    80004dda:	b765                	j	80004d82 <sys_open+0xc2>
      fileclose(f);
    80004ddc:	854a                	mv	a0,s2
    80004dde:	880ff0ef          	jal	80003e5e <fileclose>
    iunlockput(ip);
    80004de2:	8526                	mv	a0,s1
    80004de4:	dfcfe0ef          	jal	800033e0 <iunlockput>
    end_op();
    80004de8:	ccdfe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004dec:	557d                	li	a0,-1
    80004dee:	bf51                	j	80004d82 <sys_open+0xc2>
    f->type = FD_DEVICE;
    80004df0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004df4:	04649783          	lh	a5,70(s1)
    80004df8:	02f91223          	sh	a5,36(s2)
    80004dfc:	b7b1                	j	80004d48 <sys_open+0x88>
    itrunc(ip);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	c3afe0ef          	jal	8000323a <itrunc>
    80004e04:	bf8d                	j	80004d76 <sys_open+0xb6>

0000000080004e06 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e06:	7175                	add	sp,sp,-144
    80004e08:	e506                	sd	ra,136(sp)
    80004e0a:	e122                	sd	s0,128(sp)
    80004e0c:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e0e:	c3dfe0ef          	jal	80003a4a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e12:	08000613          	li	a2,128
    80004e16:	f7040593          	add	a1,s0,-144
    80004e1a:	4501                	li	a0,0
    80004e1c:	8fbfd0ef          	jal	80002716 <argstr>
    80004e20:	02054363          	bltz	a0,80004e46 <sys_mkdir+0x40>
    80004e24:	4681                	li	a3,0
    80004e26:	4601                	li	a2,0
    80004e28:	4585                	li	a1,1
    80004e2a:	f7040513          	add	a0,s0,-144
    80004e2e:	99fff0ef          	jal	800047cc <create>
    80004e32:	c911                	beqz	a0,80004e46 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e34:	dacfe0ef          	jal	800033e0 <iunlockput>
  end_op();
    80004e38:	c7dfe0ef          	jal	80003ab4 <end_op>
  return 0;
    80004e3c:	4501                	li	a0,0
}
    80004e3e:	60aa                	ld	ra,136(sp)
    80004e40:	640a                	ld	s0,128(sp)
    80004e42:	6149                	add	sp,sp,144
    80004e44:	8082                	ret
    end_op();
    80004e46:	c6ffe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004e4a:	557d                	li	a0,-1
    80004e4c:	bfcd                	j	80004e3e <sys_mkdir+0x38>

0000000080004e4e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e4e:	7135                	add	sp,sp,-160
    80004e50:	ed06                	sd	ra,152(sp)
    80004e52:	e922                	sd	s0,144(sp)
    80004e54:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e56:	bf5fe0ef          	jal	80003a4a <begin_op>
  argint(1, &major);
    80004e5a:	f6c40593          	add	a1,s0,-148
    80004e5e:	4505                	li	a0,1
    80004e60:	87ffd0ef          	jal	800026de <argint>
  argint(2, &minor);
    80004e64:	f6840593          	add	a1,s0,-152
    80004e68:	4509                	li	a0,2
    80004e6a:	875fd0ef          	jal	800026de <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e6e:	08000613          	li	a2,128
    80004e72:	f7040593          	add	a1,s0,-144
    80004e76:	4501                	li	a0,0
    80004e78:	89ffd0ef          	jal	80002716 <argstr>
    80004e7c:	02054563          	bltz	a0,80004ea6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e80:	f6841683          	lh	a3,-152(s0)
    80004e84:	f6c41603          	lh	a2,-148(s0)
    80004e88:	458d                	li	a1,3
    80004e8a:	f7040513          	add	a0,s0,-144
    80004e8e:	93fff0ef          	jal	800047cc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e92:	c911                	beqz	a0,80004ea6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e94:	d4cfe0ef          	jal	800033e0 <iunlockput>
  end_op();
    80004e98:	c1dfe0ef          	jal	80003ab4 <end_op>
  return 0;
    80004e9c:	4501                	li	a0,0
}
    80004e9e:	60ea                	ld	ra,152(sp)
    80004ea0:	644a                	ld	s0,144(sp)
    80004ea2:	610d                	add	sp,sp,160
    80004ea4:	8082                	ret
    end_op();
    80004ea6:	c0ffe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004eaa:	557d                	li	a0,-1
    80004eac:	bfcd                	j	80004e9e <sys_mknod+0x50>

0000000080004eae <sys_chdir>:

uint64
sys_chdir(void)
{
    80004eae:	7135                	add	sp,sp,-160
    80004eb0:	ed06                	sd	ra,152(sp)
    80004eb2:	e922                	sd	s0,144(sp)
    80004eb4:	e526                	sd	s1,136(sp)
    80004eb6:	e14a                	sd	s2,128(sp)
    80004eb8:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004eba:	977fc0ef          	jal	80001830 <myproc>
    80004ebe:	892a                	mv	s2,a0
  
  begin_op();
    80004ec0:	b8bfe0ef          	jal	80003a4a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ec4:	08000613          	li	a2,128
    80004ec8:	f6040593          	add	a1,s0,-160
    80004ecc:	4501                	li	a0,0
    80004ece:	849fd0ef          	jal	80002716 <argstr>
    80004ed2:	04054163          	bltz	a0,80004f14 <sys_chdir+0x66>
    80004ed6:	f6040513          	add	a0,s0,-160
    80004eda:	9b5fe0ef          	jal	8000388e <namei>
    80004ede:	84aa                	mv	s1,a0
    80004ee0:	c915                	beqz	a0,80004f14 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ee2:	a6efe0ef          	jal	80003150 <ilock>
  if(ip->type != T_DIR){
    80004ee6:	04449703          	lh	a4,68(s1)
    80004eea:	4785                	li	a5,1
    80004eec:	02f71863          	bne	a4,a5,80004f1c <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ef0:	8526                	mv	a0,s1
    80004ef2:	b08fe0ef          	jal	800031fa <iunlock>
  iput(p->cwd);
    80004ef6:	15093503          	ld	a0,336(s2)
    80004efa:	c5efe0ef          	jal	80003358 <iput>
  end_op();
    80004efe:	bb7fe0ef          	jal	80003ab4 <end_op>
  p->cwd = ip;
    80004f02:	14993823          	sd	s1,336(s2)
  return 0;
    80004f06:	4501                	li	a0,0
}
    80004f08:	60ea                	ld	ra,152(sp)
    80004f0a:	644a                	ld	s0,144(sp)
    80004f0c:	64aa                	ld	s1,136(sp)
    80004f0e:	690a                	ld	s2,128(sp)
    80004f10:	610d                	add	sp,sp,160
    80004f12:	8082                	ret
    end_op();
    80004f14:	ba1fe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004f18:	557d                	li	a0,-1
    80004f1a:	b7fd                	j	80004f08 <sys_chdir+0x5a>
    iunlockput(ip);
    80004f1c:	8526                	mv	a0,s1
    80004f1e:	cc2fe0ef          	jal	800033e0 <iunlockput>
    end_op();
    80004f22:	b93fe0ef          	jal	80003ab4 <end_op>
    return -1;
    80004f26:	557d                	li	a0,-1
    80004f28:	b7c5                	j	80004f08 <sys_chdir+0x5a>

0000000080004f2a <sys_exec>:

uint64
sys_exec(void)
{
    80004f2a:	7121                	add	sp,sp,-448
    80004f2c:	ff06                	sd	ra,440(sp)
    80004f2e:	fb22                	sd	s0,432(sp)
    80004f30:	f726                	sd	s1,424(sp)
    80004f32:	f34a                	sd	s2,416(sp)
    80004f34:	ef4e                	sd	s3,408(sp)
    80004f36:	eb52                	sd	s4,400(sp)
    80004f38:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f3a:	e4840593          	add	a1,s0,-440
    80004f3e:	4505                	li	a0,1
    80004f40:	fbafd0ef          	jal	800026fa <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f44:	08000613          	li	a2,128
    80004f48:	f5040593          	add	a1,s0,-176
    80004f4c:	4501                	li	a0,0
    80004f4e:	fc8fd0ef          	jal	80002716 <argstr>
    80004f52:	87aa                	mv	a5,a0
    return -1;
    80004f54:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f56:	0a07c463          	bltz	a5,80004ffe <sys_exec+0xd4>
  }
  memset(argv, 0, sizeof(argv));
    80004f5a:	10000613          	li	a2,256
    80004f5e:	4581                	li	a1,0
    80004f60:	e5040513          	add	a0,s0,-432
    80004f64:	d11fb0ef          	jal	80000c74 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f68:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f6c:	89a6                	mv	s3,s1
    80004f6e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f70:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f74:	00391513          	sll	a0,s2,0x3
    80004f78:	e4040593          	add	a1,s0,-448
    80004f7c:	e4843783          	ld	a5,-440(s0)
    80004f80:	953e                	add	a0,a0,a5
    80004f82:	ed2fd0ef          	jal	80002654 <fetchaddr>
    80004f86:	02054663          	bltz	a0,80004fb2 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004f8a:	e4043783          	ld	a5,-448(s0)
    80004f8e:	cf8d                	beqz	a5,80004fc8 <sys_exec+0x9e>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f90:	b41fb0ef          	jal	80000ad0 <kalloc>
    80004f94:	85aa                	mv	a1,a0
    80004f96:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f9a:	cd01                	beqz	a0,80004fb2 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f9c:	6605                	lui	a2,0x1
    80004f9e:	e4043503          	ld	a0,-448(s0)
    80004fa2:	efcfd0ef          	jal	8000269e <fetchstr>
    80004fa6:	00054663          	bltz	a0,80004fb2 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004faa:	0905                	add	s2,s2,1
    80004fac:	09a1                	add	s3,s3,8
    80004fae:	fd4913e3          	bne	s2,s4,80004f74 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb2:	f5040913          	add	s2,s0,-176
    80004fb6:	6088                	ld	a0,0(s1)
    80004fb8:	c131                	beqz	a0,80004ffc <sys_exec+0xd2>
    kfree(argv[i]);
    80004fba:	a35fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fbe:	04a1                	add	s1,s1,8
    80004fc0:	ff249be3          	bne	s1,s2,80004fb6 <sys_exec+0x8c>
  return -1;
    80004fc4:	557d                	li	a0,-1
    80004fc6:	a825                	j	80004ffe <sys_exec+0xd4>
      argv[i] = 0;
    80004fc8:	0009079b          	sext.w	a5,s2
    80004fcc:	078e                	sll	a5,a5,0x3
    80004fce:	fd078793          	add	a5,a5,-48
    80004fd2:	97a2                	add	a5,a5,s0
    80004fd4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004fd8:	e5040593          	add	a1,s0,-432
    80004fdc:	f5040513          	add	a0,s0,-176
    80004fe0:	c1cff0ef          	jal	800043fc <exec>
    80004fe4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe6:	f5040993          	add	s3,s0,-176
    80004fea:	6088                	ld	a0,0(s1)
    80004fec:	c511                	beqz	a0,80004ff8 <sys_exec+0xce>
    kfree(argv[i]);
    80004fee:	a01fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff2:	04a1                	add	s1,s1,8
    80004ff4:	ff349be3          	bne	s1,s3,80004fea <sys_exec+0xc0>
  return ret;
    80004ff8:	854a                	mv	a0,s2
    80004ffa:	a011                	j	80004ffe <sys_exec+0xd4>
  return -1;
    80004ffc:	557d                	li	a0,-1
}
    80004ffe:	70fa                	ld	ra,440(sp)
    80005000:	745a                	ld	s0,432(sp)
    80005002:	74ba                	ld	s1,424(sp)
    80005004:	791a                	ld	s2,416(sp)
    80005006:	69fa                	ld	s3,408(sp)
    80005008:	6a5a                	ld	s4,400(sp)
    8000500a:	6139                	add	sp,sp,448
    8000500c:	8082                	ret

000000008000500e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000500e:	7139                	add	sp,sp,-64
    80005010:	fc06                	sd	ra,56(sp)
    80005012:	f822                	sd	s0,48(sp)
    80005014:	f426                	sd	s1,40(sp)
    80005016:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005018:	819fc0ef          	jal	80001830 <myproc>
    8000501c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000501e:	fd840593          	add	a1,s0,-40
    80005022:	4501                	li	a0,0
    80005024:	ed6fd0ef          	jal	800026fa <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005028:	fc840593          	add	a1,s0,-56
    8000502c:	fd040513          	add	a0,s0,-48
    80005030:	8f6ff0ef          	jal	80004126 <pipealloc>
    return -1;
    80005034:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005036:	0a054463          	bltz	a0,800050de <sys_pipe+0xd0>
  fd0 = -1;
    8000503a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000503e:	fd043503          	ld	a0,-48(s0)
    80005042:	f4cff0ef          	jal	8000478e <fdalloc>
    80005046:	fca42223          	sw	a0,-60(s0)
    8000504a:	08054163          	bltz	a0,800050cc <sys_pipe+0xbe>
    8000504e:	fc843503          	ld	a0,-56(s0)
    80005052:	f3cff0ef          	jal	8000478e <fdalloc>
    80005056:	fca42023          	sw	a0,-64(s0)
    8000505a:	06054063          	bltz	a0,800050ba <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000505e:	4691                	li	a3,4
    80005060:	fc440613          	add	a2,s0,-60
    80005064:	fd843583          	ld	a1,-40(s0)
    80005068:	68a8                	ld	a0,80(s1)
    8000506a:	c7efc0ef          	jal	800014e8 <copyout>
    8000506e:	00054e63          	bltz	a0,8000508a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005072:	4691                	li	a3,4
    80005074:	fc040613          	add	a2,s0,-64
    80005078:	fd843583          	ld	a1,-40(s0)
    8000507c:	0591                	add	a1,a1,4
    8000507e:	68a8                	ld	a0,80(s1)
    80005080:	c68fc0ef          	jal	800014e8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005084:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005086:	04055c63          	bgez	a0,800050de <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000508a:	fc442783          	lw	a5,-60(s0)
    8000508e:	07e9                	add	a5,a5,26
    80005090:	078e                	sll	a5,a5,0x3
    80005092:	97a6                	add	a5,a5,s1
    80005094:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005098:	fc042783          	lw	a5,-64(s0)
    8000509c:	07e9                	add	a5,a5,26
    8000509e:	078e                	sll	a5,a5,0x3
    800050a0:	94be                	add	s1,s1,a5
    800050a2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050a6:	fd043503          	ld	a0,-48(s0)
    800050aa:	db5fe0ef          	jal	80003e5e <fileclose>
    fileclose(wf);
    800050ae:	fc843503          	ld	a0,-56(s0)
    800050b2:	dadfe0ef          	jal	80003e5e <fileclose>
    return -1;
    800050b6:	57fd                	li	a5,-1
    800050b8:	a01d                	j	800050de <sys_pipe+0xd0>
    if(fd0 >= 0)
    800050ba:	fc442783          	lw	a5,-60(s0)
    800050be:	0007c763          	bltz	a5,800050cc <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800050c2:	07e9                	add	a5,a5,26
    800050c4:	078e                	sll	a5,a5,0x3
    800050c6:	97a6                	add	a5,a5,s1
    800050c8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050cc:	fd043503          	ld	a0,-48(s0)
    800050d0:	d8ffe0ef          	jal	80003e5e <fileclose>
    fileclose(wf);
    800050d4:	fc843503          	ld	a0,-56(s0)
    800050d8:	d87fe0ef          	jal	80003e5e <fileclose>
    return -1;
    800050dc:	57fd                	li	a5,-1
}
    800050de:	853e                	mv	a0,a5
    800050e0:	70e2                	ld	ra,56(sp)
    800050e2:	7442                	ld	s0,48(sp)
    800050e4:	74a2                	ld	s1,40(sp)
    800050e6:	6121                	add	sp,sp,64
    800050e8:	8082                	ret
    800050ea:	0000                	unimp
    800050ec:	0000                	unimp
	...

00000000800050f0 <kernelvec>:
    800050f0:	7111                	add	sp,sp,-256
    800050f2:	e006                	sd	ra,0(sp)
    800050f4:	e40a                	sd	sp,8(sp)
    800050f6:	e80e                	sd	gp,16(sp)
    800050f8:	ec12                	sd	tp,24(sp)
    800050fa:	f016                	sd	t0,32(sp)
    800050fc:	f41a                	sd	t1,40(sp)
    800050fe:	f81e                	sd	t2,48(sp)
    80005100:	e4aa                	sd	a0,72(sp)
    80005102:	e8ae                	sd	a1,80(sp)
    80005104:	ecb2                	sd	a2,88(sp)
    80005106:	f0b6                	sd	a3,96(sp)
    80005108:	f4ba                	sd	a4,104(sp)
    8000510a:	f8be                	sd	a5,112(sp)
    8000510c:	fcc2                	sd	a6,120(sp)
    8000510e:	e146                	sd	a7,128(sp)
    80005110:	edf2                	sd	t3,216(sp)
    80005112:	f1f6                	sd	t4,224(sp)
    80005114:	f5fa                	sd	t5,232(sp)
    80005116:	f9fe                	sd	t6,240(sp)
    80005118:	c4cfd0ef          	jal	80002564 <kerneltrap>
    8000511c:	6082                	ld	ra,0(sp)
    8000511e:	6122                	ld	sp,8(sp)
    80005120:	61c2                	ld	gp,16(sp)
    80005122:	7282                	ld	t0,32(sp)
    80005124:	7322                	ld	t1,40(sp)
    80005126:	73c2                	ld	t2,48(sp)
    80005128:	6526                	ld	a0,72(sp)
    8000512a:	65c6                	ld	a1,80(sp)
    8000512c:	6666                	ld	a2,88(sp)
    8000512e:	7686                	ld	a3,96(sp)
    80005130:	7726                	ld	a4,104(sp)
    80005132:	77c6                	ld	a5,112(sp)
    80005134:	7866                	ld	a6,120(sp)
    80005136:	688a                	ld	a7,128(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	add	sp,sp,256
    80005142:	10200073          	sret
	...

000000008000514e <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    8000514e:	1141                	add	sp,sp,-16
    80005150:	e422                	sd	s0,8(sp)
    80005152:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005154:	0c0007b7          	lui	a5,0xc000
    80005158:	4705                	li	a4,1
    8000515a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000515c:	c3d8                	sw	a4,4(a5)
}
    8000515e:	6422                	ld	s0,8(sp)
    80005160:	0141                	add	sp,sp,16
    80005162:	8082                	ret

0000000080005164 <plicinithart>:

void
plicinithart(void)
{
    80005164:	1141                	add	sp,sp,-16
    80005166:	e406                	sd	ra,8(sp)
    80005168:	e022                	sd	s0,0(sp)
    8000516a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000516c:	e98fc0ef          	jal	80001804 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005170:	0085171b          	sllw	a4,a0,0x8
    80005174:	0c0027b7          	lui	a5,0xc002
    80005178:	97ba                	add	a5,a5,a4
    8000517a:	40200713          	li	a4,1026
    8000517e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005182:	00d5151b          	sllw	a0,a0,0xd
    80005186:	0c2017b7          	lui	a5,0xc201
    8000518a:	97aa                	add	a5,a5,a0
    8000518c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005190:	60a2                	ld	ra,8(sp)
    80005192:	6402                	ld	s0,0(sp)
    80005194:	0141                	add	sp,sp,16
    80005196:	8082                	ret

0000000080005198 <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    80005198:	1141                	add	sp,sp,-16
    8000519a:	e406                	sd	ra,8(sp)
    8000519c:	e022                	sd	s0,0(sp)
    8000519e:	0800                	add	s0,sp,16
  int hart = cpuid();
    800051a0:	e64fc0ef          	jal	80001804 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a4:	00d5151b          	sllw	a0,a0,0xd
    800051a8:	0c2017b7          	lui	a5,0xc201
    800051ac:	97aa                	add	a5,a5,a0
  return irq;
}
    800051ae:	43c8                	lw	a0,4(a5)
    800051b0:	60a2                	ld	ra,8(sp)
    800051b2:	6402                	ld	s0,0(sp)
    800051b4:	0141                	add	sp,sp,16
    800051b6:	8082                	ret

00000000800051b8 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    800051b8:	1101                	add	sp,sp,-32
    800051ba:	ec06                	sd	ra,24(sp)
    800051bc:	e822                	sd	s0,16(sp)
    800051be:	e426                	sd	s1,8(sp)
    800051c0:	1000                	add	s0,sp,32
    800051c2:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c4:	e40fc0ef          	jal	80001804 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051c8:	00d5151b          	sllw	a0,a0,0xd
    800051cc:	0c2017b7          	lui	a5,0xc201
    800051d0:	97aa                	add	a5,a5,a0
    800051d2:	c3c4                	sw	s1,4(a5)
}
    800051d4:	60e2                	ld	ra,24(sp)
    800051d6:	6442                	ld	s0,16(sp)
    800051d8:	64a2                	ld	s1,8(sp)
    800051da:	6105                	add	sp,sp,32
    800051dc:	8082                	ret

00000000800051de <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    800051de:	1141                	add	sp,sp,-16
    800051e0:	e406                	sd	ra,8(sp)
    800051e2:	e022                	sd	s0,0(sp)
    800051e4:	0800                	add	s0,sp,16
  if(i >= NUM)
    800051e6:	479d                	li	a5,7
    800051e8:	04a7ca63          	blt	a5,a0,8000523c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800051ec:	0001b797          	auipc	a5,0x1b
    800051f0:	78478793          	add	a5,a5,1924 # 80020970 <disk>
    800051f4:	97aa                	add	a5,a5,a0
    800051f6:	0187c783          	lbu	a5,24(a5)
    800051fa:	e7b9                	bnez	a5,80005248 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051fc:	00451693          	sll	a3,a0,0x4
    80005200:	0001b797          	auipc	a5,0x1b
    80005204:	77078793          	add	a5,a5,1904 # 80020970 <disk>
    80005208:	6398                	ld	a4,0(a5)
    8000520a:	9736                	add	a4,a4,a3
    8000520c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005210:	6398                	ld	a4,0(a5)
    80005212:	9736                	add	a4,a4,a3
    80005214:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005218:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000521c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005220:	97aa                	add	a5,a5,a0
    80005222:	4705                	li	a4,1
    80005224:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005228:	0001b517          	auipc	a0,0x1b
    8000522c:	76050513          	add	a0,a0,1888 # 80020988 <disk+0x18>
    80005230:	c19fc0ef          	jal	80001e48 <wakeup>
}
    80005234:	60a2                	ld	ra,8(sp)
    80005236:	6402                	ld	s0,0(sp)
    80005238:	0141                	add	sp,sp,16
    8000523a:	8082                	ret
    panic("free_desc 1");
    8000523c:	00002517          	auipc	a0,0x2
    80005240:	54450513          	add	a0,a0,1348 # 80007780 <syscalls+0x2f0>
    80005244:	d1afb0ef          	jal	8000075e <panic>
    panic("free_desc 2");
    80005248:	00002517          	auipc	a0,0x2
    8000524c:	54850513          	add	a0,a0,1352 # 80007790 <syscalls+0x300>
    80005250:	d0efb0ef          	jal	8000075e <panic>

0000000080005254 <virtio_disk_init>:
{
    80005254:	1101                	add	sp,sp,-32
    80005256:	ec06                	sd	ra,24(sp)
    80005258:	e822                	sd	s0,16(sp)
    8000525a:	e426                	sd	s1,8(sp)
    8000525c:	e04a                	sd	s2,0(sp)
    8000525e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005260:	00002597          	auipc	a1,0x2
    80005264:	54058593          	add	a1,a1,1344 # 800077a0 <syscalls+0x310>
    80005268:	0001c517          	auipc	a0,0x1c
    8000526c:	83050513          	add	a0,a0,-2000 # 80020a98 <disk+0x128>
    80005270:	8b1fb0ef          	jal	80000b20 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005274:	100017b7          	lui	a5,0x10001
    80005278:	4398                	lw	a4,0(a5)
    8000527a:	2701                	sext.w	a4,a4
    8000527c:	747277b7          	lui	a5,0x74727
    80005280:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005284:	12f71f63          	bne	a4,a5,800053c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005288:	100017b7          	lui	a5,0x10001
    8000528c:	43dc                	lw	a5,4(a5)
    8000528e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005290:	4709                	li	a4,2
    80005292:	12e79863          	bne	a5,a4,800053c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005296:	100017b7          	lui	a5,0x10001
    8000529a:	479c                	lw	a5,8(a5)
    8000529c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000529e:	12e79263          	bne	a5,a4,800053c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052a2:	100017b7          	lui	a5,0x10001
    800052a6:	47d8                	lw	a4,12(a5)
    800052a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052aa:	554d47b7          	lui	a5,0x554d4
    800052ae:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052b2:	10f71863          	bne	a4,a5,800053c2 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052be:	4705                	li	a4,1
    800052c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c2:	470d                	li	a4,3
    800052c4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052c6:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052c8:	c7ffe6b7          	lui	a3,0xc7ffe
    800052cc:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fddcaf>
    800052d0:	8f75                	and	a4,a4,a3
    800052d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	472d                	li	a4,11
    800052d6:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052d8:	5bbc                	lw	a5,112(a5)
    800052da:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052de:	8ba1                	and	a5,a5,8
    800052e0:	0e078763          	beqz	a5,800053ce <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052e4:	100017b7          	lui	a5,0x10001
    800052e8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052ec:	43fc                	lw	a5,68(a5)
    800052ee:	2781                	sext.w	a5,a5
    800052f0:	0e079563          	bnez	a5,800053da <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052f4:	100017b7          	lui	a5,0x10001
    800052f8:	5bdc                	lw	a5,52(a5)
    800052fa:	2781                	sext.w	a5,a5
  if(max == 0)
    800052fc:	0e078563          	beqz	a5,800053e6 <virtio_disk_init+0x192>
  if(max < NUM)
    80005300:	471d                	li	a4,7
    80005302:	0ef77863          	bgeu	a4,a5,800053f2 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005306:	fcafb0ef          	jal	80000ad0 <kalloc>
    8000530a:	0001b497          	auipc	s1,0x1b
    8000530e:	66648493          	add	s1,s1,1638 # 80020970 <disk>
    80005312:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005314:	fbcfb0ef          	jal	80000ad0 <kalloc>
    80005318:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000531a:	fb6fb0ef          	jal	80000ad0 <kalloc>
    8000531e:	87aa                	mv	a5,a0
    80005320:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005322:	6088                	ld	a0,0(s1)
    80005324:	cd69                	beqz	a0,800053fe <virtio_disk_init+0x1aa>
    80005326:	0001b717          	auipc	a4,0x1b
    8000532a:	65273703          	ld	a4,1618(a4) # 80020978 <disk+0x8>
    8000532e:	cb61                	beqz	a4,800053fe <virtio_disk_init+0x1aa>
    80005330:	c7f9                	beqz	a5,800053fe <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    80005332:	6605                	lui	a2,0x1
    80005334:	4581                	li	a1,0
    80005336:	93ffb0ef          	jal	80000c74 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000533a:	0001b497          	auipc	s1,0x1b
    8000533e:	63648493          	add	s1,s1,1590 # 80020970 <disk>
    80005342:	6605                	lui	a2,0x1
    80005344:	4581                	li	a1,0
    80005346:	6488                	ld	a0,8(s1)
    80005348:	92dfb0ef          	jal	80000c74 <memset>
  memset(disk.used, 0, PGSIZE);
    8000534c:	6605                	lui	a2,0x1
    8000534e:	4581                	li	a1,0
    80005350:	6888                	ld	a0,16(s1)
    80005352:	923fb0ef          	jal	80000c74 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005356:	100017b7          	lui	a5,0x10001
    8000535a:	4721                	li	a4,8
    8000535c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000535e:	4098                	lw	a4,0(s1)
    80005360:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005364:	40d8                	lw	a4,4(s1)
    80005366:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000536a:	6498                	ld	a4,8(s1)
    8000536c:	0007069b          	sext.w	a3,a4
    80005370:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005374:	9701                	sra	a4,a4,0x20
    80005376:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000537a:	6898                	ld	a4,16(s1)
    8000537c:	0007069b          	sext.w	a3,a4
    80005380:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005384:	9701                	sra	a4,a4,0x20
    80005386:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000538a:	4705                	li	a4,1
    8000538c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000538e:	00e48c23          	sb	a4,24(s1)
    80005392:	00e48ca3          	sb	a4,25(s1)
    80005396:	00e48d23          	sb	a4,26(s1)
    8000539a:	00e48da3          	sb	a4,27(s1)
    8000539e:	00e48e23          	sb	a4,28(s1)
    800053a2:	00e48ea3          	sb	a4,29(s1)
    800053a6:	00e48f23          	sb	a4,30(s1)
    800053aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053ae:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b2:	0727a823          	sw	s2,112(a5)
}
    800053b6:	60e2                	ld	ra,24(sp)
    800053b8:	6442                	ld	s0,16(sp)
    800053ba:	64a2                	ld	s1,8(sp)
    800053bc:	6902                	ld	s2,0(sp)
    800053be:	6105                	add	sp,sp,32
    800053c0:	8082                	ret
    panic("could not find virtio disk");
    800053c2:	00002517          	auipc	a0,0x2
    800053c6:	3ee50513          	add	a0,a0,1006 # 800077b0 <syscalls+0x320>
    800053ca:	b94fb0ef          	jal	8000075e <panic>
    panic("virtio disk FEATURES_OK unset");
    800053ce:	00002517          	auipc	a0,0x2
    800053d2:	40250513          	add	a0,a0,1026 # 800077d0 <syscalls+0x340>
    800053d6:	b88fb0ef          	jal	8000075e <panic>
    panic("virtio disk should not be ready");
    800053da:	00002517          	auipc	a0,0x2
    800053de:	41650513          	add	a0,a0,1046 # 800077f0 <syscalls+0x360>
    800053e2:	b7cfb0ef          	jal	8000075e <panic>
    panic("virtio disk has no queue 0");
    800053e6:	00002517          	auipc	a0,0x2
    800053ea:	42a50513          	add	a0,a0,1066 # 80007810 <syscalls+0x380>
    800053ee:	b70fb0ef          	jal	8000075e <panic>
    panic("virtio disk max queue too short");
    800053f2:	00002517          	auipc	a0,0x2
    800053f6:	43e50513          	add	a0,a0,1086 # 80007830 <syscalls+0x3a0>
    800053fa:	b64fb0ef          	jal	8000075e <panic>
    panic("virtio disk kalloc");
    800053fe:	00002517          	auipc	a0,0x2
    80005402:	45250513          	add	a0,a0,1106 # 80007850 <syscalls+0x3c0>
    80005406:	b58fb0ef          	jal	8000075e <panic>

000000008000540a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000540a:	7159                	add	sp,sp,-112
    8000540c:	f486                	sd	ra,104(sp)
    8000540e:	f0a2                	sd	s0,96(sp)
    80005410:	eca6                	sd	s1,88(sp)
    80005412:	e8ca                	sd	s2,80(sp)
    80005414:	e4ce                	sd	s3,72(sp)
    80005416:	e0d2                	sd	s4,64(sp)
    80005418:	fc56                	sd	s5,56(sp)
    8000541a:	f85a                	sd	s6,48(sp)
    8000541c:	f45e                	sd	s7,40(sp)
    8000541e:	f062                	sd	s8,32(sp)
    80005420:	ec66                	sd	s9,24(sp)
    80005422:	e86a                	sd	s10,16(sp)
    80005424:	1880                	add	s0,sp,112
    80005426:	8a2a                	mv	s4,a0
    80005428:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000542a:	00c52c83          	lw	s9,12(a0)
    8000542e:	001c9c9b          	sllw	s9,s9,0x1
    80005432:	1c82                	sll	s9,s9,0x20
    80005434:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005438:	0001b517          	auipc	a0,0x1b
    8000543c:	66050513          	add	a0,a0,1632 # 80020a98 <disk+0x128>
    80005440:	f60fb0ef          	jal	80000ba0 <acquire>
  for(int i = 0; i < 3; i++){
    80005444:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005446:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005448:	0001bb17          	auipc	s6,0x1b
    8000544c:	528b0b13          	add	s6,s6,1320 # 80020970 <disk>
  for(int i = 0; i < 3; i++){
    80005450:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005452:	0001bc17          	auipc	s8,0x1b
    80005456:	646c0c13          	add	s8,s8,1606 # 80020a98 <disk+0x128>
    8000545a:	a8b1                	j	800054b6 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    8000545c:	00fb0733          	add	a4,s6,a5
    80005460:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005464:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005466:	0207c563          	bltz	a5,80005490 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    8000546a:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    8000546c:	0591                	add	a1,a1,4
    8000546e:	05560963          	beq	a2,s5,800054c0 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80005472:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005474:	0001b717          	auipc	a4,0x1b
    80005478:	4fc70713          	add	a4,a4,1276 # 80020970 <disk>
    8000547c:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000547e:	01874683          	lbu	a3,24(a4)
    80005482:	fee9                	bnez	a3,8000545c <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005484:	2785                	addw	a5,a5,1
    80005486:	0705                	add	a4,a4,1
    80005488:	fe979be3          	bne	a5,s1,8000547e <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    8000548c:	57fd                	li	a5,-1
    8000548e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005490:	00c05c63          	blez	a2,800054a8 <virtio_disk_rw+0x9e>
    80005494:	060a                	sll	a2,a2,0x2
    80005496:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    8000549a:	0009a503          	lw	a0,0(s3)
    8000549e:	d41ff0ef          	jal	800051de <free_desc>
      for(int j = 0; j < i; j++)
    800054a2:	0991                	add	s3,s3,4
    800054a4:	ffa99be3          	bne	s3,s10,8000549a <virtio_disk_rw+0x90>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a8:	85e2                	mv	a1,s8
    800054aa:	0001b517          	auipc	a0,0x1b
    800054ae:	4de50513          	add	a0,a0,1246 # 80020988 <disk+0x18>
    800054b2:	94bfc0ef          	jal	80001dfc <sleep>
  for(int i = 0; i < 3; i++){
    800054b6:	f9040993          	add	s3,s0,-112
{
    800054ba:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800054bc:	864a                	mv	a2,s2
    800054be:	bf55                	j	80005472 <virtio_disk_rw+0x68>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054c0:	f9042503          	lw	a0,-112(s0)
    800054c4:	00a50713          	add	a4,a0,10
    800054c8:	0712                	sll	a4,a4,0x4

  if(write)
    800054ca:	0001b797          	auipc	a5,0x1b
    800054ce:	4a678793          	add	a5,a5,1190 # 80020970 <disk>
    800054d2:	00e786b3          	add	a3,a5,a4
    800054d6:	01703633          	snez	a2,s7
    800054da:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    800054dc:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800054e0:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054e4:	f6070613          	add	a2,a4,-160
    800054e8:	6394                	ld	a3,0(a5)
    800054ea:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054ec:	00870593          	add	a1,a4,8
    800054f0:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800054f2:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054f4:	0007b803          	ld	a6,0(a5)
    800054f8:	9642                	add	a2,a2,a6
    800054fa:	46c1                	li	a3,16
    800054fc:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054fe:	4585                	li	a1,1
    80005500:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005504:	f9442683          	lw	a3,-108(s0)
    80005508:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000550c:	0692                	sll	a3,a3,0x4
    8000550e:	9836                	add	a6,a6,a3
    80005510:	058a0613          	add	a2,s4,88
    80005514:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005518:	0007b803          	ld	a6,0(a5)
    8000551c:	96c2                	add	a3,a3,a6
    8000551e:	40000613          	li	a2,1024
    80005522:	c690                	sw	a2,8(a3)
  if(write)
    80005524:	001bb613          	seqz	a2,s7
    80005528:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000552c:	00166613          	or	a2,a2,1
    80005530:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005534:	f9842603          	lw	a2,-104(s0)
    80005538:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    8000553c:	00250693          	add	a3,a0,2
    80005540:	0692                	sll	a3,a3,0x4
    80005542:	96be                	add	a3,a3,a5
    80005544:	58fd                	li	a7,-1
    80005546:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000554a:	0612                	sll	a2,a2,0x4
    8000554c:	9832                	add	a6,a6,a2
    8000554e:	f9070713          	add	a4,a4,-112
    80005552:	973e                	add	a4,a4,a5
    80005554:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80005558:	6398                	ld	a4,0(a5)
    8000555a:	9732                	add	a4,a4,a2
    8000555c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    8000555e:	4609                	li	a2,2
    80005560:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005564:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    80005568:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    8000556c:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005570:	6794                	ld	a3,8(a5)
    80005572:	0026d703          	lhu	a4,2(a3)
    80005576:	8b1d                	and	a4,a4,7
    80005578:	0706                	sll	a4,a4,0x1
    8000557a:	96ba                	add	a3,a3,a4
    8000557c:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005580:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    80005584:	6798                	ld	a4,8(a5)
    80005586:	00275783          	lhu	a5,2(a4)
    8000558a:	2785                	addw	a5,a5,1
    8000558c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005590:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    80005594:	100017b7          	lui	a5,0x10001
    80005598:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    8000559c:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800055a0:	0001b917          	auipc	s2,0x1b
    800055a4:	4f890913          	add	s2,s2,1272 # 80020a98 <disk+0x128>
  while(b->disk == 1) {
    800055a8:	4485                	li	s1,1
    800055aa:	00b79a63          	bne	a5,a1,800055be <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    800055ae:	85ca                	mv	a1,s2
    800055b0:	8552                	mv	a0,s4
    800055b2:	84bfc0ef          	jal	80001dfc <sleep>
  while(b->disk == 1) {
    800055b6:	004a2783          	lw	a5,4(s4)
    800055ba:	fe978ae3          	beq	a5,s1,800055ae <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    800055be:	f9042903          	lw	s2,-112(s0)
    800055c2:	00290713          	add	a4,s2,2
    800055c6:	0712                	sll	a4,a4,0x4
    800055c8:	0001b797          	auipc	a5,0x1b
    800055cc:	3a878793          	add	a5,a5,936 # 80020970 <disk>
    800055d0:	97ba                	add	a5,a5,a4
    800055d2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055d6:	0001b997          	auipc	s3,0x1b
    800055da:	39a98993          	add	s3,s3,922 # 80020970 <disk>
    800055de:	00491713          	sll	a4,s2,0x4
    800055e2:	0009b783          	ld	a5,0(s3)
    800055e6:	97ba                	add	a5,a5,a4
    800055e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055ec:	854a                	mv	a0,s2
    800055ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055f2:	bedff0ef          	jal	800051de <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055f6:	8885                	and	s1,s1,1
    800055f8:	f0fd                	bnez	s1,800055de <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055fa:	0001b517          	auipc	a0,0x1b
    800055fe:	49e50513          	add	a0,a0,1182 # 80020a98 <disk+0x128>
    80005602:	e36fb0ef          	jal	80000c38 <release>
}
    80005606:	70a6                	ld	ra,104(sp)
    80005608:	7406                	ld	s0,96(sp)
    8000560a:	64e6                	ld	s1,88(sp)
    8000560c:	6946                	ld	s2,80(sp)
    8000560e:	69a6                	ld	s3,72(sp)
    80005610:	6a06                	ld	s4,64(sp)
    80005612:	7ae2                	ld	s5,56(sp)
    80005614:	7b42                	ld	s6,48(sp)
    80005616:	7ba2                	ld	s7,40(sp)
    80005618:	7c02                	ld	s8,32(sp)
    8000561a:	6ce2                	ld	s9,24(sp)
    8000561c:	6d42                	ld	s10,16(sp)
    8000561e:	6165                	add	sp,sp,112
    80005620:	8082                	ret

0000000080005622 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005622:	1101                	add	sp,sp,-32
    80005624:	ec06                	sd	ra,24(sp)
    80005626:	e822                	sd	s0,16(sp)
    80005628:	e426                	sd	s1,8(sp)
    8000562a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000562c:	0001b497          	auipc	s1,0x1b
    80005630:	34448493          	add	s1,s1,836 # 80020970 <disk>
    80005634:	0001b517          	auipc	a0,0x1b
    80005638:	46450513          	add	a0,a0,1124 # 80020a98 <disk+0x128>
    8000563c:	d64fb0ef          	jal	80000ba0 <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005640:	10001737          	lui	a4,0x10001
    80005644:	533c                	lw	a5,96(a4)
    80005646:	8b8d                	and	a5,a5,3
    80005648:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000564a:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    8000564e:	689c                	ld	a5,16(s1)
    80005650:	0204d703          	lhu	a4,32(s1)
    80005654:	0027d783          	lhu	a5,2(a5)
    80005658:	04f70663          	beq	a4,a5,800056a4 <virtio_disk_intr+0x82>
    __sync_synchronize();
    8000565c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005660:	6898                	ld	a4,16(s1)
    80005662:	0204d783          	lhu	a5,32(s1)
    80005666:	8b9d                	and	a5,a5,7
    80005668:	078e                	sll	a5,a5,0x3
    8000566a:	97ba                	add	a5,a5,a4
    8000566c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000566e:	00278713          	add	a4,a5,2
    80005672:	0712                	sll	a4,a4,0x4
    80005674:	9726                	add	a4,a4,s1
    80005676:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000567a:	e321                	bnez	a4,800056ba <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000567c:	0789                	add	a5,a5,2
    8000567e:	0792                	sll	a5,a5,0x4
    80005680:	97a6                	add	a5,a5,s1
    80005682:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    80005684:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005688:	fc0fc0ef          	jal	80001e48 <wakeup>

    disk.used_idx += 1;
    8000568c:	0204d783          	lhu	a5,32(s1)
    80005690:	2785                	addw	a5,a5,1
    80005692:	17c2                	sll	a5,a5,0x30
    80005694:	93c1                	srl	a5,a5,0x30
    80005696:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000569a:	6898                	ld	a4,16(s1)
    8000569c:	00275703          	lhu	a4,2(a4)
    800056a0:	faf71ee3          	bne	a4,a5,8000565c <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800056a4:	0001b517          	auipc	a0,0x1b
    800056a8:	3f450513          	add	a0,a0,1012 # 80020a98 <disk+0x128>
    800056ac:	d8cfb0ef          	jal	80000c38 <release>
}
    800056b0:	60e2                	ld	ra,24(sp)
    800056b2:	6442                	ld	s0,16(sp)
    800056b4:	64a2                	ld	s1,8(sp)
    800056b6:	6105                	add	sp,sp,32
    800056b8:	8082                	ret
      panic("virtio_disk_intr status");
    800056ba:	00002517          	auipc	a0,0x2
    800056be:	1ae50513          	add	a0,a0,430 # 80007868 <syscalls+0x3d8>
    800056c2:	89cfb0ef          	jal	8000075e <panic>
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
