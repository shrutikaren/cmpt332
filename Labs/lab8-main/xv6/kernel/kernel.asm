
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
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddbbf>
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
    800003ec:	6c078793          	add	a5,a5,1728 # 8001faa8 <devsw>
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
    80000a06:	23e78793          	add	a5,a5,574 # 80020c40 <end>
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
    80000ac0:	18450513          	add	a0,a0,388 # 80020c40 <end>
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
    80000ce8:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde3c1>
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
    80000e4e:	226040ef          	jal	80005074 <plicinithart>
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
    80000e9a:	1c4040ef          	jal	8000505e <plicinit>
    plicinithart();  /* ask PLIC for device interrupts */
    80000e9e:	1d6040ef          	jal	80005074 <plicinithart>
    binit();         /* buffer cache */
    80000ea2:	2b5010ef          	jal	80002956 <binit>
    iinit();         /* inode table */
    80000ea6:	08e020ef          	jal	80002f34 <iinit>
    fileinit();      /* file table */
    80000eaa:	601020ef          	jal	80003caa <fileinit>
    virtio_disk_init(); /* emulated hard disk */
    80000eae:	2b6040ef          	jal	80005164 <virtio_disk_init>
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
    80000f42:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde3b7>
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
    800016b6:	14fd                	add	s1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffde3bf>
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
    80001888:	640010ef          	jal	80002ec8 <fsinit>
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
    80001aea:	4b9010ef          	jal	800037a2 <namei>
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
    80001bf2:	13a020ef          	jal	80003d2c <filedup>
    80001bf6:	00a93023          	sd	a0,0(s2)
    80001bfa:	b7f5                	j	80001be6 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001bfc:	150ab503          	ld	a0,336(s5)
    80001c00:	4ba010ef          	jal	800030ba <idup>
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
    80001f40:	633010ef          	jal	80003d72 <fileclose>
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
    80001f54:	20b010ef          	jal	8000395e <begin_op>
  iput(p->cwd);
    80001f58:	1509b503          	ld	a0,336(s3)
    80001f5c:	312010ef          	jal	8000326e <iput>
  end_op();
    80001f60:	269010ef          	jal	800039c8 <end_op>
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
    80002328:	cdc78793          	add	a5,a5,-804 # 80005000 <kernelvec>
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
    8000244a:	45f020ef          	jal	800050a8 <plic_claim>
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
    80002470:	459020ef          	jal	800050c8 <plic_complete>
    return 1;
    80002474:	4505                	li	a0,1
    80002476:	b7e9                	j	80002440 <devintr+0x24>
      uartintr();
    80002478:	d3afe0ef          	jal	800009b2 <uartintr>
    if(irq)
    8000247c:	bfcd                	j	8000246e <devintr+0x52>
      virtio_disk_intr();
    8000247e:	0b4030ef          	jal	80005532 <virtio_disk_intr>
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
    800024a6:	b5e78793          	add	a5,a5,-1186 # 80005000 <kernelvec>
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

0000000080002948 <sys_symlink>:

uint64 sys_symlink(void){
    80002948:	1141                	add	sp,sp,-16
    8000294a:	e422                	sd	s0,8(sp)
    8000294c:	0800                	add	s0,sp,16
  return -1; 
}
    8000294e:	557d                	li	a0,-1
    80002950:	6422                	ld	s0,8(sp)
    80002952:	0141                	add	sp,sp,16
    80002954:	8082                	ret

0000000080002956 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002956:	7179                	add	sp,sp,-48
    80002958:	f406                	sd	ra,40(sp)
    8000295a:	f022                	sd	s0,32(sp)
    8000295c:	ec26                	sd	s1,24(sp)
    8000295e:	e84a                	sd	s2,16(sp)
    80002960:	e44e                	sd	s3,8(sp)
    80002962:	e052                	sd	s4,0(sp)
    80002964:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002966:	00005597          	auipc	a1,0x5
    8000296a:	bda58593          	add	a1,a1,-1062 # 80007540 <syscalls+0xb0>
    8000296e:	00013517          	auipc	a0,0x13
    80002972:	f0a50513          	add	a0,a0,-246 # 80015878 <bcache>
    80002976:	9aafe0ef          	jal	80000b20 <initlock>

  /* Create linked list of buffers */
  bcache.head.prev = &bcache.head;
    8000297a:	0001b797          	auipc	a5,0x1b
    8000297e:	efe78793          	add	a5,a5,-258 # 8001d878 <bcache+0x8000>
    80002982:	0001b717          	auipc	a4,0x1b
    80002986:	15e70713          	add	a4,a4,350 # 8001dae0 <bcache+0x8268>
    8000298a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000298e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002992:	00013497          	auipc	s1,0x13
    80002996:	efe48493          	add	s1,s1,-258 # 80015890 <bcache+0x18>
    b->next = bcache.head.next;
    8000299a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000299c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000299e:	00005a17          	auipc	s4,0x5
    800029a2:	baaa0a13          	add	s4,s4,-1110 # 80007548 <syscalls+0xb8>
    b->next = bcache.head.next;
    800029a6:	2b893783          	ld	a5,696(s2)
    800029aa:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800029ac:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800029b0:	85d2                	mv	a1,s4
    800029b2:	01048513          	add	a0,s1,16
    800029b6:	1f6010ef          	jal	80003bac <initsleeplock>
    bcache.head.next->prev = b;
    800029ba:	2b893783          	ld	a5,696(s2)
    800029be:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800029c0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029c4:	45848493          	add	s1,s1,1112
    800029c8:	fd349fe3          	bne	s1,s3,800029a6 <binit+0x50>
  }
}
    800029cc:	70a2                	ld	ra,40(sp)
    800029ce:	7402                	ld	s0,32(sp)
    800029d0:	64e2                	ld	s1,24(sp)
    800029d2:	6942                	ld	s2,16(sp)
    800029d4:	69a2                	ld	s3,8(sp)
    800029d6:	6a02                	ld	s4,0(sp)
    800029d8:	6145                	add	sp,sp,48
    800029da:	8082                	ret

00000000800029dc <bread>:
}

/* Return a locked buf with the contents of the indicated block. */
struct buf*
bread(uint dev, uint blockno)
{
    800029dc:	7179                	add	sp,sp,-48
    800029de:	f406                	sd	ra,40(sp)
    800029e0:	f022                	sd	s0,32(sp)
    800029e2:	ec26                	sd	s1,24(sp)
    800029e4:	e84a                	sd	s2,16(sp)
    800029e6:	e44e                	sd	s3,8(sp)
    800029e8:	1800                	add	s0,sp,48
    800029ea:	892a                	mv	s2,a0
    800029ec:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800029ee:	00013517          	auipc	a0,0x13
    800029f2:	e8a50513          	add	a0,a0,-374 # 80015878 <bcache>
    800029f6:	9aafe0ef          	jal	80000ba0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800029fa:	0001b497          	auipc	s1,0x1b
    800029fe:	1364b483          	ld	s1,310(s1) # 8001db30 <bcache+0x82b8>
    80002a02:	0001b797          	auipc	a5,0x1b
    80002a06:	0de78793          	add	a5,a5,222 # 8001dae0 <bcache+0x8268>
    80002a0a:	02f48b63          	beq	s1,a5,80002a40 <bread+0x64>
    80002a0e:	873e                	mv	a4,a5
    80002a10:	a021                	j	80002a18 <bread+0x3c>
    80002a12:	68a4                	ld	s1,80(s1)
    80002a14:	02e48663          	beq	s1,a4,80002a40 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002a18:	449c                	lw	a5,8(s1)
    80002a1a:	ff279ce3          	bne	a5,s2,80002a12 <bread+0x36>
    80002a1e:	44dc                	lw	a5,12(s1)
    80002a20:	ff3799e3          	bne	a5,s3,80002a12 <bread+0x36>
      b->refcnt++;
    80002a24:	40bc                	lw	a5,64(s1)
    80002a26:	2785                	addw	a5,a5,1
    80002a28:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a2a:	00013517          	auipc	a0,0x13
    80002a2e:	e4e50513          	add	a0,a0,-434 # 80015878 <bcache>
    80002a32:	a06fe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002a36:	01048513          	add	a0,s1,16
    80002a3a:	1a8010ef          	jal	80003be2 <acquiresleep>
      return b;
    80002a3e:	a889                	j	80002a90 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a40:	0001b497          	auipc	s1,0x1b
    80002a44:	0e84b483          	ld	s1,232(s1) # 8001db28 <bcache+0x82b0>
    80002a48:	0001b797          	auipc	a5,0x1b
    80002a4c:	09878793          	add	a5,a5,152 # 8001dae0 <bcache+0x8268>
    80002a50:	00f48863          	beq	s1,a5,80002a60 <bread+0x84>
    80002a54:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002a56:	40bc                	lw	a5,64(s1)
    80002a58:	cb91                	beqz	a5,80002a6c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a5a:	64a4                	ld	s1,72(s1)
    80002a5c:	fee49de3          	bne	s1,a4,80002a56 <bread+0x7a>
  panic("bget: no buffers");
    80002a60:	00005517          	auipc	a0,0x5
    80002a64:	af050513          	add	a0,a0,-1296 # 80007550 <syscalls+0xc0>
    80002a68:	cf7fd0ef          	jal	8000075e <panic>
      b->dev = dev;
    80002a6c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002a70:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002a74:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002a78:	4785                	li	a5,1
    80002a7a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a7c:	00013517          	auipc	a0,0x13
    80002a80:	dfc50513          	add	a0,a0,-516 # 80015878 <bcache>
    80002a84:	9b4fe0ef          	jal	80000c38 <release>
      acquiresleep(&b->lock);
    80002a88:	01048513          	add	a0,s1,16
    80002a8c:	156010ef          	jal	80003be2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002a90:	409c                	lw	a5,0(s1)
    80002a92:	cb89                	beqz	a5,80002aa4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002a94:	8526                	mv	a0,s1
    80002a96:	70a2                	ld	ra,40(sp)
    80002a98:	7402                	ld	s0,32(sp)
    80002a9a:	64e2                	ld	s1,24(sp)
    80002a9c:	6942                	ld	s2,16(sp)
    80002a9e:	69a2                	ld	s3,8(sp)
    80002aa0:	6145                	add	sp,sp,48
    80002aa2:	8082                	ret
    virtio_disk_rw(b, 0);
    80002aa4:	4581                	li	a1,0
    80002aa6:	8526                	mv	a0,s1
    80002aa8:	073020ef          	jal	8000531a <virtio_disk_rw>
    b->valid = 1;
    80002aac:	4785                	li	a5,1
    80002aae:	c09c                	sw	a5,0(s1)
  return b;
    80002ab0:	b7d5                	j	80002a94 <bread+0xb8>

0000000080002ab2 <bwrite>:

/* Write b's contents to disk.  Must be locked. */
void
bwrite(struct buf *b)
{
    80002ab2:	1101                	add	sp,sp,-32
    80002ab4:	ec06                	sd	ra,24(sp)
    80002ab6:	e822                	sd	s0,16(sp)
    80002ab8:	e426                	sd	s1,8(sp)
    80002aba:	1000                	add	s0,sp,32
    80002abc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002abe:	0541                	add	a0,a0,16
    80002ac0:	1a0010ef          	jal	80003c60 <holdingsleep>
    80002ac4:	c911                	beqz	a0,80002ad8 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ac6:	4585                	li	a1,1
    80002ac8:	8526                	mv	a0,s1
    80002aca:	051020ef          	jal	8000531a <virtio_disk_rw>
}
    80002ace:	60e2                	ld	ra,24(sp)
    80002ad0:	6442                	ld	s0,16(sp)
    80002ad2:	64a2                	ld	s1,8(sp)
    80002ad4:	6105                	add	sp,sp,32
    80002ad6:	8082                	ret
    panic("bwrite");
    80002ad8:	00005517          	auipc	a0,0x5
    80002adc:	a9050513          	add	a0,a0,-1392 # 80007568 <syscalls+0xd8>
    80002ae0:	c7ffd0ef          	jal	8000075e <panic>

0000000080002ae4 <brelse>:

/* Release a locked buffer. */
/* Move to the head of the most-recently-used list. */
void
brelse(struct buf *b)
{
    80002ae4:	1101                	add	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	e426                	sd	s1,8(sp)
    80002aec:	e04a                	sd	s2,0(sp)
    80002aee:	1000                	add	s0,sp,32
    80002af0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002af2:	01050913          	add	s2,a0,16
    80002af6:	854a                	mv	a0,s2
    80002af8:	168010ef          	jal	80003c60 <holdingsleep>
    80002afc:	c135                	beqz	a0,80002b60 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002afe:	854a                	mv	a0,s2
    80002b00:	128010ef          	jal	80003c28 <releasesleep>

  acquire(&bcache.lock);
    80002b04:	00013517          	auipc	a0,0x13
    80002b08:	d7450513          	add	a0,a0,-652 # 80015878 <bcache>
    80002b0c:	894fe0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002b10:	40bc                	lw	a5,64(s1)
    80002b12:	37fd                	addw	a5,a5,-1
    80002b14:	0007871b          	sext.w	a4,a5
    80002b18:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002b1a:	e71d                	bnez	a4,80002b48 <brelse+0x64>
    /* no one is waiting for it. */
    b->next->prev = b->prev;
    80002b1c:	68b8                	ld	a4,80(s1)
    80002b1e:	64bc                	ld	a5,72(s1)
    80002b20:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002b22:	68b8                	ld	a4,80(s1)
    80002b24:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002b26:	0001b797          	auipc	a5,0x1b
    80002b2a:	d5278793          	add	a5,a5,-686 # 8001d878 <bcache+0x8000>
    80002b2e:	2b87b703          	ld	a4,696(a5)
    80002b32:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002b34:	0001b717          	auipc	a4,0x1b
    80002b38:	fac70713          	add	a4,a4,-84 # 8001dae0 <bcache+0x8268>
    80002b3c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002b3e:	2b87b703          	ld	a4,696(a5)
    80002b42:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002b44:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002b48:	00013517          	auipc	a0,0x13
    80002b4c:	d3050513          	add	a0,a0,-720 # 80015878 <bcache>
    80002b50:	8e8fe0ef          	jal	80000c38 <release>
}
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6902                	ld	s2,0(sp)
    80002b5c:	6105                	add	sp,sp,32
    80002b5e:	8082                	ret
    panic("brelse");
    80002b60:	00005517          	auipc	a0,0x5
    80002b64:	a1050513          	add	a0,a0,-1520 # 80007570 <syscalls+0xe0>
    80002b68:	bf7fd0ef          	jal	8000075e <panic>

0000000080002b6c <bpin>:

void
bpin(struct buf *b) {
    80002b6c:	1101                	add	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	1000                	add	s0,sp,32
    80002b76:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002b78:	00013517          	auipc	a0,0x13
    80002b7c:	d0050513          	add	a0,a0,-768 # 80015878 <bcache>
    80002b80:	820fe0ef          	jal	80000ba0 <acquire>
  b->refcnt++;
    80002b84:	40bc                	lw	a5,64(s1)
    80002b86:	2785                	addw	a5,a5,1
    80002b88:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002b8a:	00013517          	auipc	a0,0x13
    80002b8e:	cee50513          	add	a0,a0,-786 # 80015878 <bcache>
    80002b92:	8a6fe0ef          	jal	80000c38 <release>
}
    80002b96:	60e2                	ld	ra,24(sp)
    80002b98:	6442                	ld	s0,16(sp)
    80002b9a:	64a2                	ld	s1,8(sp)
    80002b9c:	6105                	add	sp,sp,32
    80002b9e:	8082                	ret

0000000080002ba0 <bunpin>:

void
bunpin(struct buf *b) {
    80002ba0:	1101                	add	sp,sp,-32
    80002ba2:	ec06                	sd	ra,24(sp)
    80002ba4:	e822                	sd	s0,16(sp)
    80002ba6:	e426                	sd	s1,8(sp)
    80002ba8:	1000                	add	s0,sp,32
    80002baa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002bac:	00013517          	auipc	a0,0x13
    80002bb0:	ccc50513          	add	a0,a0,-820 # 80015878 <bcache>
    80002bb4:	fedfd0ef          	jal	80000ba0 <acquire>
  b->refcnt--;
    80002bb8:	40bc                	lw	a5,64(s1)
    80002bba:	37fd                	addw	a5,a5,-1
    80002bbc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002bbe:	00013517          	auipc	a0,0x13
    80002bc2:	cba50513          	add	a0,a0,-838 # 80015878 <bcache>
    80002bc6:	872fe0ef          	jal	80000c38 <release>
}
    80002bca:	60e2                	ld	ra,24(sp)
    80002bcc:	6442                	ld	s0,16(sp)
    80002bce:	64a2                	ld	s1,8(sp)
    80002bd0:	6105                	add	sp,sp,32
    80002bd2:	8082                	ret

0000000080002bd4 <bfree>:
}

/* Free a disk block. */
static void
bfree(int dev, uint b)
{
    80002bd4:	1101                	add	sp,sp,-32
    80002bd6:	ec06                	sd	ra,24(sp)
    80002bd8:	e822                	sd	s0,16(sp)
    80002bda:	e426                	sd	s1,8(sp)
    80002bdc:	e04a                	sd	s2,0(sp)
    80002bde:	1000                	add	s0,sp,32
    80002be0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002be2:	00d5d59b          	srlw	a1,a1,0xd
    80002be6:	0001b797          	auipc	a5,0x1b
    80002bea:	36e7a783          	lw	a5,878(a5) # 8001df54 <sb+0x1c>
    80002bee:	9dbd                	addw	a1,a1,a5
    80002bf0:	dedff0ef          	jal	800029dc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002bf4:	0074f713          	and	a4,s1,7
    80002bf8:	4785                	li	a5,1
    80002bfa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002bfe:	14ce                	sll	s1,s1,0x33
    80002c00:	90d9                	srl	s1,s1,0x36
    80002c02:	00950733          	add	a4,a0,s1
    80002c06:	05874703          	lbu	a4,88(a4)
    80002c0a:	00e7f6b3          	and	a3,a5,a4
    80002c0e:	c29d                	beqz	a3,80002c34 <bfree+0x60>
    80002c10:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002c12:	94aa                	add	s1,s1,a0
    80002c14:	fff7c793          	not	a5,a5
    80002c18:	8f7d                	and	a4,a4,a5
    80002c1a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002c1e:	6bf000ef          	jal	80003adc <log_write>
  brelse(bp);
    80002c22:	854a                	mv	a0,s2
    80002c24:	ec1ff0ef          	jal	80002ae4 <brelse>
}
    80002c28:	60e2                	ld	ra,24(sp)
    80002c2a:	6442                	ld	s0,16(sp)
    80002c2c:	64a2                	ld	s1,8(sp)
    80002c2e:	6902                	ld	s2,0(sp)
    80002c30:	6105                	add	sp,sp,32
    80002c32:	8082                	ret
    panic("freeing free block");
    80002c34:	00005517          	auipc	a0,0x5
    80002c38:	94450513          	add	a0,a0,-1724 # 80007578 <syscalls+0xe8>
    80002c3c:	b23fd0ef          	jal	8000075e <panic>

0000000080002c40 <balloc>:
{
    80002c40:	711d                	add	sp,sp,-96
    80002c42:	ec86                	sd	ra,88(sp)
    80002c44:	e8a2                	sd	s0,80(sp)
    80002c46:	e4a6                	sd	s1,72(sp)
    80002c48:	e0ca                	sd	s2,64(sp)
    80002c4a:	fc4e                	sd	s3,56(sp)
    80002c4c:	f852                	sd	s4,48(sp)
    80002c4e:	f456                	sd	s5,40(sp)
    80002c50:	f05a                	sd	s6,32(sp)
    80002c52:	ec5e                	sd	s7,24(sp)
    80002c54:	e862                	sd	s8,16(sp)
    80002c56:	e466                	sd	s9,8(sp)
    80002c58:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002c5a:	0001b797          	auipc	a5,0x1b
    80002c5e:	2e27a783          	lw	a5,738(a5) # 8001df3c <sb+0x4>
    80002c62:	cff1                	beqz	a5,80002d3e <balloc+0xfe>
    80002c64:	8baa                	mv	s7,a0
    80002c66:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002c68:	0001bb17          	auipc	s6,0x1b
    80002c6c:	2d0b0b13          	add	s6,s6,720 # 8001df38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c70:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002c72:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c74:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002c76:	6c89                	lui	s9,0x2
    80002c78:	a0b5                	j	80002ce4 <balloc+0xa4>
        bp->data[bi/8] |= m;  /* Mark block in use. */
    80002c7a:	97ca                	add	a5,a5,s2
    80002c7c:	8e55                	or	a2,a2,a3
    80002c7e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002c82:	854a                	mv	a0,s2
    80002c84:	659000ef          	jal	80003adc <log_write>
        brelse(bp);
    80002c88:	854a                	mv	a0,s2
    80002c8a:	e5bff0ef          	jal	80002ae4 <brelse>
  bp = bread(dev, bno);
    80002c8e:	85a6                	mv	a1,s1
    80002c90:	855e                	mv	a0,s7
    80002c92:	d4bff0ef          	jal	800029dc <bread>
    80002c96:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002c98:	40000613          	li	a2,1024
    80002c9c:	4581                	li	a1,0
    80002c9e:	05850513          	add	a0,a0,88
    80002ca2:	fd3fd0ef          	jal	80000c74 <memset>
  log_write(bp);
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	635000ef          	jal	80003adc <log_write>
  brelse(bp);
    80002cac:	854a                	mv	a0,s2
    80002cae:	e37ff0ef          	jal	80002ae4 <brelse>
}
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	60e6                	ld	ra,88(sp)
    80002cb6:	6446                	ld	s0,80(sp)
    80002cb8:	64a6                	ld	s1,72(sp)
    80002cba:	6906                	ld	s2,64(sp)
    80002cbc:	79e2                	ld	s3,56(sp)
    80002cbe:	7a42                	ld	s4,48(sp)
    80002cc0:	7aa2                	ld	s5,40(sp)
    80002cc2:	7b02                	ld	s6,32(sp)
    80002cc4:	6be2                	ld	s7,24(sp)
    80002cc6:	6c42                	ld	s8,16(sp)
    80002cc8:	6ca2                	ld	s9,8(sp)
    80002cca:	6125                	add	sp,sp,96
    80002ccc:	8082                	ret
    brelse(bp);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	e15ff0ef          	jal	80002ae4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002cd4:	015c87bb          	addw	a5,s9,s5
    80002cd8:	00078a9b          	sext.w	s5,a5
    80002cdc:	004b2703          	lw	a4,4(s6)
    80002ce0:	04eaff63          	bgeu	s5,a4,80002d3e <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002ce4:	41fad79b          	sraw	a5,s5,0x1f
    80002ce8:	0137d79b          	srlw	a5,a5,0x13
    80002cec:	015787bb          	addw	a5,a5,s5
    80002cf0:	40d7d79b          	sraw	a5,a5,0xd
    80002cf4:	01cb2583          	lw	a1,28(s6)
    80002cf8:	9dbd                	addw	a1,a1,a5
    80002cfa:	855e                	mv	a0,s7
    80002cfc:	ce1ff0ef          	jal	800029dc <bread>
    80002d00:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d02:	004b2503          	lw	a0,4(s6)
    80002d06:	000a849b          	sext.w	s1,s5
    80002d0a:	8762                	mv	a4,s8
    80002d0c:	fca4f1e3          	bgeu	s1,a0,80002cce <balloc+0x8e>
      m = 1 << (bi % 8);
    80002d10:	00777693          	and	a3,a4,7
    80002d14:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  /* Is block free? */
    80002d18:	41f7579b          	sraw	a5,a4,0x1f
    80002d1c:	01d7d79b          	srlw	a5,a5,0x1d
    80002d20:	9fb9                	addw	a5,a5,a4
    80002d22:	4037d79b          	sraw	a5,a5,0x3
    80002d26:	00f90633          	add	a2,s2,a5
    80002d2a:	05864603          	lbu	a2,88(a2)
    80002d2e:	00c6f5b3          	and	a1,a3,a2
    80002d32:	d5a1                	beqz	a1,80002c7a <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d34:	2705                	addw	a4,a4,1
    80002d36:	2485                	addw	s1,s1,1
    80002d38:	fd471ae3          	bne	a4,s4,80002d0c <balloc+0xcc>
    80002d3c:	bf49                	j	80002cce <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002d3e:	00005517          	auipc	a0,0x5
    80002d42:	85250513          	add	a0,a0,-1966 # 80007590 <syscalls+0x100>
    80002d46:	f58fd0ef          	jal	8000049e <printf>
  return 0;
    80002d4a:	4481                	li	s1,0
    80002d4c:	b79d                	j	80002cb2 <balloc+0x72>

0000000080002d4e <bmap>:
/* Return the disk block address of the nth block in inode ip. */
/* If there is no such block, bmap allocates one. */
/* returns 0 if out of disk space. */
static uint
bmap(struct inode *ip, uint bn)
{
    80002d4e:	7179                	add	sp,sp,-48
    80002d50:	f406                	sd	ra,40(sp)
    80002d52:	f022                	sd	s0,32(sp)
    80002d54:	ec26                	sd	s1,24(sp)
    80002d56:	e84a                	sd	s2,16(sp)
    80002d58:	e44e                	sd	s3,8(sp)
    80002d5a:	e052                	sd	s4,0(sp)
    80002d5c:	1800                	add	s0,sp,48
    80002d5e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002d60:	47ad                	li	a5,11
    80002d62:	02b7e663          	bltu	a5,a1,80002d8e <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
    80002d66:	02059793          	sll	a5,a1,0x20
    80002d6a:	01e7d593          	srl	a1,a5,0x1e
    80002d6e:	00b504b3          	add	s1,a0,a1
    80002d72:	0504a903          	lw	s2,80(s1)
    80002d76:	06091663          	bnez	s2,80002de2 <bmap+0x94>
      addr = balloc(ip->dev);
    80002d7a:	4108                	lw	a0,0(a0)
    80002d7c:	ec5ff0ef          	jal	80002c40 <balloc>
    80002d80:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002d84:	04090f63          	beqz	s2,80002de2 <bmap+0x94>
        return 0;
      ip->addrs[bn] = addr;
    80002d88:	0524a823          	sw	s2,80(s1)
    80002d8c:	a899                	j	80002de2 <bmap+0x94>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002d8e:	ff45849b          	addw	s1,a1,-12
    80002d92:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002d96:	0ff00793          	li	a5,255
    80002d9a:	06e7eb63          	bltu	a5,a4,80002e10 <bmap+0xc2>
    /* Load indirect block, allocating if necessary. */
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002d9e:	08052903          	lw	s2,128(a0)
    80002da2:	00091b63          	bnez	s2,80002db8 <bmap+0x6a>
      addr = balloc(ip->dev);
    80002da6:	4108                	lw	a0,0(a0)
    80002da8:	e99ff0ef          	jal	80002c40 <balloc>
    80002dac:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002db0:	02090963          	beqz	s2,80002de2 <bmap+0x94>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002db4:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002db8:	85ca                	mv	a1,s2
    80002dba:	0009a503          	lw	a0,0(s3)
    80002dbe:	c1fff0ef          	jal	800029dc <bread>
    80002dc2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002dc4:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002dc8:	02049713          	sll	a4,s1,0x20
    80002dcc:	01e75593          	srl	a1,a4,0x1e
    80002dd0:	00b784b3          	add	s1,a5,a1
    80002dd4:	0004a903          	lw	s2,0(s1)
    80002dd8:	00090e63          	beqz	s2,80002df4 <bmap+0xa6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002ddc:	8552                	mv	a0,s4
    80002dde:	d07ff0ef          	jal	80002ae4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002de2:	854a                	mv	a0,s2
    80002de4:	70a2                	ld	ra,40(sp)
    80002de6:	7402                	ld	s0,32(sp)
    80002de8:	64e2                	ld	s1,24(sp)
    80002dea:	6942                	ld	s2,16(sp)
    80002dec:	69a2                	ld	s3,8(sp)
    80002dee:	6a02                	ld	s4,0(sp)
    80002df0:	6145                	add	sp,sp,48
    80002df2:	8082                	ret
      addr = balloc(ip->dev);
    80002df4:	0009a503          	lw	a0,0(s3)
    80002df8:	e49ff0ef          	jal	80002c40 <balloc>
    80002dfc:	0005091b          	sext.w	s2,a0
      if(addr){
    80002e00:	fc090ee3          	beqz	s2,80002ddc <bmap+0x8e>
        a[bn] = addr;
    80002e04:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002e08:	8552                	mv	a0,s4
    80002e0a:	4d3000ef          	jal	80003adc <log_write>
    80002e0e:	b7f9                	j	80002ddc <bmap+0x8e>
  panic("bmap: out of range");
    80002e10:	00004517          	auipc	a0,0x4
    80002e14:	79850513          	add	a0,a0,1944 # 800075a8 <syscalls+0x118>
    80002e18:	947fd0ef          	jal	8000075e <panic>

0000000080002e1c <iget>:
{
    80002e1c:	7179                	add	sp,sp,-48
    80002e1e:	f406                	sd	ra,40(sp)
    80002e20:	f022                	sd	s0,32(sp)
    80002e22:	ec26                	sd	s1,24(sp)
    80002e24:	e84a                	sd	s2,16(sp)
    80002e26:	e44e                	sd	s3,8(sp)
    80002e28:	e052                	sd	s4,0(sp)
    80002e2a:	1800                	add	s0,sp,48
    80002e2c:	89aa                	mv	s3,a0
    80002e2e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002e30:	0001b517          	auipc	a0,0x1b
    80002e34:	12850513          	add	a0,a0,296 # 8001df58 <itable>
    80002e38:	d69fd0ef          	jal	80000ba0 <acquire>
  empty = 0;
    80002e3c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e3e:	0001b497          	auipc	s1,0x1b
    80002e42:	13248493          	add	s1,s1,306 # 8001df70 <itable+0x18>
    80002e46:	0001d697          	auipc	a3,0x1d
    80002e4a:	bba68693          	add	a3,a3,-1094 # 8001fa00 <log>
    80002e4e:	a039                	j	80002e5c <iget+0x40>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002e50:	02090963          	beqz	s2,80002e82 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e54:	08848493          	add	s1,s1,136
    80002e58:	02d48863          	beq	s1,a3,80002e88 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002e5c:	449c                	lw	a5,8(s1)
    80002e5e:	fef059e3          	blez	a5,80002e50 <iget+0x34>
    80002e62:	4098                	lw	a4,0(s1)
    80002e64:	ff3716e3          	bne	a4,s3,80002e50 <iget+0x34>
    80002e68:	40d8                	lw	a4,4(s1)
    80002e6a:	ff4713e3          	bne	a4,s4,80002e50 <iget+0x34>
      ip->ref++;
    80002e6e:	2785                	addw	a5,a5,1
    80002e70:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002e72:	0001b517          	auipc	a0,0x1b
    80002e76:	0e650513          	add	a0,a0,230 # 8001df58 <itable>
    80002e7a:	dbffd0ef          	jal	80000c38 <release>
      return ip;
    80002e7e:	8926                	mv	s2,s1
    80002e80:	a02d                	j	80002eaa <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    /* Remember empty slot. */
    80002e82:	fbe9                	bnez	a5,80002e54 <iget+0x38>
    80002e84:	8926                	mv	s2,s1
    80002e86:	b7f9                	j	80002e54 <iget+0x38>
  if(empty == 0)
    80002e88:	02090a63          	beqz	s2,80002ebc <iget+0xa0>
  ip->dev = dev;
    80002e8c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002e90:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002e94:	4785                	li	a5,1
    80002e96:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002e9a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002e9e:	0001b517          	auipc	a0,0x1b
    80002ea2:	0ba50513          	add	a0,a0,186 # 8001df58 <itable>
    80002ea6:	d93fd0ef          	jal	80000c38 <release>
}
    80002eaa:	854a                	mv	a0,s2
    80002eac:	70a2                	ld	ra,40(sp)
    80002eae:	7402                	ld	s0,32(sp)
    80002eb0:	64e2                	ld	s1,24(sp)
    80002eb2:	6942                	ld	s2,16(sp)
    80002eb4:	69a2                	ld	s3,8(sp)
    80002eb6:	6a02                	ld	s4,0(sp)
    80002eb8:	6145                	add	sp,sp,48
    80002eba:	8082                	ret
    panic("iget: no inodes");
    80002ebc:	00004517          	auipc	a0,0x4
    80002ec0:	70450513          	add	a0,a0,1796 # 800075c0 <syscalls+0x130>
    80002ec4:	89bfd0ef          	jal	8000075e <panic>

0000000080002ec8 <fsinit>:
fsinit(int dev) {
    80002ec8:	7179                	add	sp,sp,-48
    80002eca:	f406                	sd	ra,40(sp)
    80002ecc:	f022                	sd	s0,32(sp)
    80002ece:	ec26                	sd	s1,24(sp)
    80002ed0:	e84a                	sd	s2,16(sp)
    80002ed2:	e44e                	sd	s3,8(sp)
    80002ed4:	1800                	add	s0,sp,48
    80002ed6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ed8:	4585                	li	a1,1
    80002eda:	b03ff0ef          	jal	800029dc <bread>
    80002ede:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ee0:	0001b997          	auipc	s3,0x1b
    80002ee4:	05898993          	add	s3,s3,88 # 8001df38 <sb>
    80002ee8:	02000613          	li	a2,32
    80002eec:	05850593          	add	a1,a0,88
    80002ef0:	854e                	mv	a0,s3
    80002ef2:	ddffd0ef          	jal	80000cd0 <memmove>
  brelse(bp);
    80002ef6:	8526                	mv	a0,s1
    80002ef8:	bedff0ef          	jal	80002ae4 <brelse>
  if(sb.magic != FSMAGIC)
    80002efc:	0009a703          	lw	a4,0(s3)
    80002f00:	102037b7          	lui	a5,0x10203
    80002f04:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f08:	02f71063          	bne	a4,a5,80002f28 <fsinit+0x60>
  initlog(dev, &sb);
    80002f0c:	0001b597          	auipc	a1,0x1b
    80002f10:	02c58593          	add	a1,a1,44 # 8001df38 <sb>
    80002f14:	854a                	mv	a0,s2
    80002f16:	1c5000ef          	jal	800038da <initlog>
}
    80002f1a:	70a2                	ld	ra,40(sp)
    80002f1c:	7402                	ld	s0,32(sp)
    80002f1e:	64e2                	ld	s1,24(sp)
    80002f20:	6942                	ld	s2,16(sp)
    80002f22:	69a2                	ld	s3,8(sp)
    80002f24:	6145                	add	sp,sp,48
    80002f26:	8082                	ret
    panic("invalid file system");
    80002f28:	00004517          	auipc	a0,0x4
    80002f2c:	6a850513          	add	a0,a0,1704 # 800075d0 <syscalls+0x140>
    80002f30:	82ffd0ef          	jal	8000075e <panic>

0000000080002f34 <iinit>:
{
    80002f34:	7179                	add	sp,sp,-48
    80002f36:	f406                	sd	ra,40(sp)
    80002f38:	f022                	sd	s0,32(sp)
    80002f3a:	ec26                	sd	s1,24(sp)
    80002f3c:	e84a                	sd	s2,16(sp)
    80002f3e:	e44e                	sd	s3,8(sp)
    80002f40:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002f42:	00004597          	auipc	a1,0x4
    80002f46:	6a658593          	add	a1,a1,1702 # 800075e8 <syscalls+0x158>
    80002f4a:	0001b517          	auipc	a0,0x1b
    80002f4e:	00e50513          	add	a0,a0,14 # 8001df58 <itable>
    80002f52:	bcffd0ef          	jal	80000b20 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002f56:	0001b497          	auipc	s1,0x1b
    80002f5a:	02a48493          	add	s1,s1,42 # 8001df80 <itable+0x28>
    80002f5e:	0001d997          	auipc	s3,0x1d
    80002f62:	ab298993          	add	s3,s3,-1358 # 8001fa10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002f66:	00004917          	auipc	s2,0x4
    80002f6a:	68a90913          	add	s2,s2,1674 # 800075f0 <syscalls+0x160>
    80002f6e:	85ca                	mv	a1,s2
    80002f70:	8526                	mv	a0,s1
    80002f72:	43b000ef          	jal	80003bac <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002f76:	08848493          	add	s1,s1,136
    80002f7a:	ff349ae3          	bne	s1,s3,80002f6e <iinit+0x3a>
}
    80002f7e:	70a2                	ld	ra,40(sp)
    80002f80:	7402                	ld	s0,32(sp)
    80002f82:	64e2                	ld	s1,24(sp)
    80002f84:	6942                	ld	s2,16(sp)
    80002f86:	69a2                	ld	s3,8(sp)
    80002f88:	6145                	add	sp,sp,48
    80002f8a:	8082                	ret

0000000080002f8c <ialloc>:
{
    80002f8c:	7139                	add	sp,sp,-64
    80002f8e:	fc06                	sd	ra,56(sp)
    80002f90:	f822                	sd	s0,48(sp)
    80002f92:	f426                	sd	s1,40(sp)
    80002f94:	f04a                	sd	s2,32(sp)
    80002f96:	ec4e                	sd	s3,24(sp)
    80002f98:	e852                	sd	s4,16(sp)
    80002f9a:	e456                	sd	s5,8(sp)
    80002f9c:	e05a                	sd	s6,0(sp)
    80002f9e:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002fa0:	0001b717          	auipc	a4,0x1b
    80002fa4:	fa472703          	lw	a4,-92(a4) # 8001df44 <sb+0xc>
    80002fa8:	4785                	li	a5,1
    80002faa:	04e7f463          	bgeu	a5,a4,80002ff2 <ialloc+0x66>
    80002fae:	8aaa                	mv	s5,a0
    80002fb0:	8b2e                	mv	s6,a1
    80002fb2:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002fb4:	0001ba17          	auipc	s4,0x1b
    80002fb8:	f84a0a13          	add	s4,s4,-124 # 8001df38 <sb>
    80002fbc:	00495593          	srl	a1,s2,0x4
    80002fc0:	018a2783          	lw	a5,24(s4)
    80002fc4:	9dbd                	addw	a1,a1,a5
    80002fc6:	8556                	mv	a0,s5
    80002fc8:	a15ff0ef          	jal	800029dc <bread>
    80002fcc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002fce:	05850993          	add	s3,a0,88
    80002fd2:	00f97793          	and	a5,s2,15
    80002fd6:	079a                	sll	a5,a5,0x6
    80002fd8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  /* a free inode */
    80002fda:	00099783          	lh	a5,0(s3)
    80002fde:	cb9d                	beqz	a5,80003014 <ialloc+0x88>
    brelse(bp);
    80002fe0:	b05ff0ef          	jal	80002ae4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002fe4:	0905                	add	s2,s2,1
    80002fe6:	00ca2703          	lw	a4,12(s4)
    80002fea:	0009079b          	sext.w	a5,s2
    80002fee:	fce7e7e3          	bltu	a5,a4,80002fbc <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002ff2:	00004517          	auipc	a0,0x4
    80002ff6:	60650513          	add	a0,a0,1542 # 800075f8 <syscalls+0x168>
    80002ffa:	ca4fd0ef          	jal	8000049e <printf>
  return 0;
    80002ffe:	4501                	li	a0,0
}
    80003000:	70e2                	ld	ra,56(sp)
    80003002:	7442                	ld	s0,48(sp)
    80003004:	74a2                	ld	s1,40(sp)
    80003006:	7902                	ld	s2,32(sp)
    80003008:	69e2                	ld	s3,24(sp)
    8000300a:	6a42                	ld	s4,16(sp)
    8000300c:	6aa2                	ld	s5,8(sp)
    8000300e:	6b02                	ld	s6,0(sp)
    80003010:	6121                	add	sp,sp,64
    80003012:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003014:	04000613          	li	a2,64
    80003018:	4581                	li	a1,0
    8000301a:	854e                	mv	a0,s3
    8000301c:	c59fd0ef          	jal	80000c74 <memset>
      dip->type = type;
    80003020:	01699023          	sh	s6,0(s3)
      log_write(bp);   /* mark it allocated on the disk */
    80003024:	8526                	mv	a0,s1
    80003026:	2b7000ef          	jal	80003adc <log_write>
      brelse(bp);
    8000302a:	8526                	mv	a0,s1
    8000302c:	ab9ff0ef          	jal	80002ae4 <brelse>
      return iget(dev, inum);
    80003030:	0009059b          	sext.w	a1,s2
    80003034:	8556                	mv	a0,s5
    80003036:	de7ff0ef          	jal	80002e1c <iget>
    8000303a:	b7d9                	j	80003000 <ialloc+0x74>

000000008000303c <iupdate>:
{
    8000303c:	1101                	add	sp,sp,-32
    8000303e:	ec06                	sd	ra,24(sp)
    80003040:	e822                	sd	s0,16(sp)
    80003042:	e426                	sd	s1,8(sp)
    80003044:	e04a                	sd	s2,0(sp)
    80003046:	1000                	add	s0,sp,32
    80003048:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000304a:	415c                	lw	a5,4(a0)
    8000304c:	0047d79b          	srlw	a5,a5,0x4
    80003050:	0001b597          	auipc	a1,0x1b
    80003054:	f005a583          	lw	a1,-256(a1) # 8001df50 <sb+0x18>
    80003058:	9dbd                	addw	a1,a1,a5
    8000305a:	4108                	lw	a0,0(a0)
    8000305c:	981ff0ef          	jal	800029dc <bread>
    80003060:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003062:	05850793          	add	a5,a0,88
    80003066:	40d8                	lw	a4,4(s1)
    80003068:	8b3d                	and	a4,a4,15
    8000306a:	071a                	sll	a4,a4,0x6
    8000306c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000306e:	04449703          	lh	a4,68(s1)
    80003072:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003076:	04649703          	lh	a4,70(s1)
    8000307a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000307e:	04849703          	lh	a4,72(s1)
    80003082:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003086:	04a49703          	lh	a4,74(s1)
    8000308a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000308e:	44f8                	lw	a4,76(s1)
    80003090:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003092:	03400613          	li	a2,52
    80003096:	05048593          	add	a1,s1,80
    8000309a:	00c78513          	add	a0,a5,12
    8000309e:	c33fd0ef          	jal	80000cd0 <memmove>
  log_write(bp);
    800030a2:	854a                	mv	a0,s2
    800030a4:	239000ef          	jal	80003adc <log_write>
  brelse(bp);
    800030a8:	854a                	mv	a0,s2
    800030aa:	a3bff0ef          	jal	80002ae4 <brelse>
}
    800030ae:	60e2                	ld	ra,24(sp)
    800030b0:	6442                	ld	s0,16(sp)
    800030b2:	64a2                	ld	s1,8(sp)
    800030b4:	6902                	ld	s2,0(sp)
    800030b6:	6105                	add	sp,sp,32
    800030b8:	8082                	ret

00000000800030ba <idup>:
{
    800030ba:	1101                	add	sp,sp,-32
    800030bc:	ec06                	sd	ra,24(sp)
    800030be:	e822                	sd	s0,16(sp)
    800030c0:	e426                	sd	s1,8(sp)
    800030c2:	1000                	add	s0,sp,32
    800030c4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800030c6:	0001b517          	auipc	a0,0x1b
    800030ca:	e9250513          	add	a0,a0,-366 # 8001df58 <itable>
    800030ce:	ad3fd0ef          	jal	80000ba0 <acquire>
  ip->ref++;
    800030d2:	449c                	lw	a5,8(s1)
    800030d4:	2785                	addw	a5,a5,1
    800030d6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030d8:	0001b517          	auipc	a0,0x1b
    800030dc:	e8050513          	add	a0,a0,-384 # 8001df58 <itable>
    800030e0:	b59fd0ef          	jal	80000c38 <release>
}
    800030e4:	8526                	mv	a0,s1
    800030e6:	60e2                	ld	ra,24(sp)
    800030e8:	6442                	ld	s0,16(sp)
    800030ea:	64a2                	ld	s1,8(sp)
    800030ec:	6105                	add	sp,sp,32
    800030ee:	8082                	ret

00000000800030f0 <ilock>:
{
    800030f0:	1101                	add	sp,sp,-32
    800030f2:	ec06                	sd	ra,24(sp)
    800030f4:	e822                	sd	s0,16(sp)
    800030f6:	e426                	sd	s1,8(sp)
    800030f8:	e04a                	sd	s2,0(sp)
    800030fa:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800030fc:	c105                	beqz	a0,8000311c <ilock+0x2c>
    800030fe:	84aa                	mv	s1,a0
    80003100:	451c                	lw	a5,8(a0)
    80003102:	00f05d63          	blez	a5,8000311c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003106:	0541                	add	a0,a0,16
    80003108:	2db000ef          	jal	80003be2 <acquiresleep>
  if(ip->valid == 0){
    8000310c:	40bc                	lw	a5,64(s1)
    8000310e:	cf89                	beqz	a5,80003128 <ilock+0x38>
}
    80003110:	60e2                	ld	ra,24(sp)
    80003112:	6442                	ld	s0,16(sp)
    80003114:	64a2                	ld	s1,8(sp)
    80003116:	6902                	ld	s2,0(sp)
    80003118:	6105                	add	sp,sp,32
    8000311a:	8082                	ret
    panic("ilock");
    8000311c:	00004517          	auipc	a0,0x4
    80003120:	4f450513          	add	a0,a0,1268 # 80007610 <syscalls+0x180>
    80003124:	e3afd0ef          	jal	8000075e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003128:	40dc                	lw	a5,4(s1)
    8000312a:	0047d79b          	srlw	a5,a5,0x4
    8000312e:	0001b597          	auipc	a1,0x1b
    80003132:	e225a583          	lw	a1,-478(a1) # 8001df50 <sb+0x18>
    80003136:	9dbd                	addw	a1,a1,a5
    80003138:	4088                	lw	a0,0(s1)
    8000313a:	8a3ff0ef          	jal	800029dc <bread>
    8000313e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003140:	05850593          	add	a1,a0,88
    80003144:	40dc                	lw	a5,4(s1)
    80003146:	8bbd                	and	a5,a5,15
    80003148:	079a                	sll	a5,a5,0x6
    8000314a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000314c:	00059783          	lh	a5,0(a1)
    80003150:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003154:	00259783          	lh	a5,2(a1)
    80003158:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000315c:	00459783          	lh	a5,4(a1)
    80003160:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003164:	00659783          	lh	a5,6(a1)
    80003168:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000316c:	459c                	lw	a5,8(a1)
    8000316e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003170:	03400613          	li	a2,52
    80003174:	05b1                	add	a1,a1,12
    80003176:	05048513          	add	a0,s1,80
    8000317a:	b57fd0ef          	jal	80000cd0 <memmove>
    brelse(bp);
    8000317e:	854a                	mv	a0,s2
    80003180:	965ff0ef          	jal	80002ae4 <brelse>
    ip->valid = 1;
    80003184:	4785                	li	a5,1
    80003186:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003188:	04449783          	lh	a5,68(s1)
    8000318c:	f3d1                	bnez	a5,80003110 <ilock+0x20>
      panic("ilock: no type");
    8000318e:	00004517          	auipc	a0,0x4
    80003192:	48a50513          	add	a0,a0,1162 # 80007618 <syscalls+0x188>
    80003196:	dc8fd0ef          	jal	8000075e <panic>

000000008000319a <iunlock>:
{
    8000319a:	1101                	add	sp,sp,-32
    8000319c:	ec06                	sd	ra,24(sp)
    8000319e:	e822                	sd	s0,16(sp)
    800031a0:	e426                	sd	s1,8(sp)
    800031a2:	e04a                	sd	s2,0(sp)
    800031a4:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800031a6:	c505                	beqz	a0,800031ce <iunlock+0x34>
    800031a8:	84aa                	mv	s1,a0
    800031aa:	01050913          	add	s2,a0,16
    800031ae:	854a                	mv	a0,s2
    800031b0:	2b1000ef          	jal	80003c60 <holdingsleep>
    800031b4:	cd09                	beqz	a0,800031ce <iunlock+0x34>
    800031b6:	449c                	lw	a5,8(s1)
    800031b8:	00f05b63          	blez	a5,800031ce <iunlock+0x34>
  releasesleep(&ip->lock);
    800031bc:	854a                	mv	a0,s2
    800031be:	26b000ef          	jal	80003c28 <releasesleep>
}
    800031c2:	60e2                	ld	ra,24(sp)
    800031c4:	6442                	ld	s0,16(sp)
    800031c6:	64a2                	ld	s1,8(sp)
    800031c8:	6902                	ld	s2,0(sp)
    800031ca:	6105                	add	sp,sp,32
    800031cc:	8082                	ret
    panic("iunlock");
    800031ce:	00004517          	auipc	a0,0x4
    800031d2:	45a50513          	add	a0,a0,1114 # 80007628 <syscalls+0x198>
    800031d6:	d88fd0ef          	jal	8000075e <panic>

00000000800031da <itrunc>:

/* Truncate inode (discard contents). */
/* Caller must hold ip->lock. */
void
itrunc(struct inode *ip)
{
    800031da:	7179                	add	sp,sp,-48
    800031dc:	f406                	sd	ra,40(sp)
    800031de:	f022                	sd	s0,32(sp)
    800031e0:	ec26                	sd	s1,24(sp)
    800031e2:	e84a                	sd	s2,16(sp)
    800031e4:	e44e                	sd	s3,8(sp)
    800031e6:	e052                	sd	s4,0(sp)
    800031e8:	1800                	add	s0,sp,48
    800031ea:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800031ec:	05050493          	add	s1,a0,80
    800031f0:	08050913          	add	s2,a0,128
    800031f4:	a021                	j	800031fc <itrunc+0x22>
    800031f6:	0491                	add	s1,s1,4
    800031f8:	01248b63          	beq	s1,s2,8000320e <itrunc+0x34>
    if(ip->addrs[i]){
    800031fc:	408c                	lw	a1,0(s1)
    800031fe:	dde5                	beqz	a1,800031f6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003200:	0009a503          	lw	a0,0(s3)
    80003204:	9d1ff0ef          	jal	80002bd4 <bfree>
      ip->addrs[i] = 0;
    80003208:	0004a023          	sw	zero,0(s1)
    8000320c:	b7ed                	j	800031f6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000320e:	0809a583          	lw	a1,128(s3)
    80003212:	ed91                	bnez	a1,8000322e <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003214:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003218:	854e                	mv	a0,s3
    8000321a:	e23ff0ef          	jal	8000303c <iupdate>
}
    8000321e:	70a2                	ld	ra,40(sp)
    80003220:	7402                	ld	s0,32(sp)
    80003222:	64e2                	ld	s1,24(sp)
    80003224:	6942                	ld	s2,16(sp)
    80003226:	69a2                	ld	s3,8(sp)
    80003228:	6a02                	ld	s4,0(sp)
    8000322a:	6145                	add	sp,sp,48
    8000322c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000322e:	0009a503          	lw	a0,0(s3)
    80003232:	faaff0ef          	jal	800029dc <bread>
    80003236:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003238:	05850493          	add	s1,a0,88
    8000323c:	45850913          	add	s2,a0,1112
    80003240:	a021                	j	80003248 <itrunc+0x6e>
    80003242:	0491                	add	s1,s1,4
    80003244:	01248963          	beq	s1,s2,80003256 <itrunc+0x7c>
      if(a[j])
    80003248:	408c                	lw	a1,0(s1)
    8000324a:	dde5                	beqz	a1,80003242 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    8000324c:	0009a503          	lw	a0,0(s3)
    80003250:	985ff0ef          	jal	80002bd4 <bfree>
    80003254:	b7fd                	j	80003242 <itrunc+0x68>
    brelse(bp);
    80003256:	8552                	mv	a0,s4
    80003258:	88dff0ef          	jal	80002ae4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000325c:	0809a583          	lw	a1,128(s3)
    80003260:	0009a503          	lw	a0,0(s3)
    80003264:	971ff0ef          	jal	80002bd4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003268:	0809a023          	sw	zero,128(s3)
    8000326c:	b765                	j	80003214 <itrunc+0x3a>

000000008000326e <iput>:
{
    8000326e:	1101                	add	sp,sp,-32
    80003270:	ec06                	sd	ra,24(sp)
    80003272:	e822                	sd	s0,16(sp)
    80003274:	e426                	sd	s1,8(sp)
    80003276:	e04a                	sd	s2,0(sp)
    80003278:	1000                	add	s0,sp,32
    8000327a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000327c:	0001b517          	auipc	a0,0x1b
    80003280:	cdc50513          	add	a0,a0,-804 # 8001df58 <itable>
    80003284:	91dfd0ef          	jal	80000ba0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003288:	4498                	lw	a4,8(s1)
    8000328a:	4785                	li	a5,1
    8000328c:	02f70163          	beq	a4,a5,800032ae <iput+0x40>
  ip->ref--;
    80003290:	449c                	lw	a5,8(s1)
    80003292:	37fd                	addw	a5,a5,-1
    80003294:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003296:	0001b517          	auipc	a0,0x1b
    8000329a:	cc250513          	add	a0,a0,-830 # 8001df58 <itable>
    8000329e:	99bfd0ef          	jal	80000c38 <release>
}
    800032a2:	60e2                	ld	ra,24(sp)
    800032a4:	6442                	ld	s0,16(sp)
    800032a6:	64a2                	ld	s1,8(sp)
    800032a8:	6902                	ld	s2,0(sp)
    800032aa:	6105                	add	sp,sp,32
    800032ac:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032ae:	40bc                	lw	a5,64(s1)
    800032b0:	d3e5                	beqz	a5,80003290 <iput+0x22>
    800032b2:	04a49783          	lh	a5,74(s1)
    800032b6:	ffe9                	bnez	a5,80003290 <iput+0x22>
    acquiresleep(&ip->lock);
    800032b8:	01048913          	add	s2,s1,16
    800032bc:	854a                	mv	a0,s2
    800032be:	125000ef          	jal	80003be2 <acquiresleep>
    release(&itable.lock);
    800032c2:	0001b517          	auipc	a0,0x1b
    800032c6:	c9650513          	add	a0,a0,-874 # 8001df58 <itable>
    800032ca:	96ffd0ef          	jal	80000c38 <release>
    itrunc(ip);
    800032ce:	8526                	mv	a0,s1
    800032d0:	f0bff0ef          	jal	800031da <itrunc>
    ip->type = 0;
    800032d4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800032d8:	8526                	mv	a0,s1
    800032da:	d63ff0ef          	jal	8000303c <iupdate>
    ip->valid = 0;
    800032de:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800032e2:	854a                	mv	a0,s2
    800032e4:	145000ef          	jal	80003c28 <releasesleep>
    acquire(&itable.lock);
    800032e8:	0001b517          	auipc	a0,0x1b
    800032ec:	c7050513          	add	a0,a0,-912 # 8001df58 <itable>
    800032f0:	8b1fd0ef          	jal	80000ba0 <acquire>
    800032f4:	bf71                	j	80003290 <iput+0x22>

00000000800032f6 <iunlockput>:
{
    800032f6:	1101                	add	sp,sp,-32
    800032f8:	ec06                	sd	ra,24(sp)
    800032fa:	e822                	sd	s0,16(sp)
    800032fc:	e426                	sd	s1,8(sp)
    800032fe:	1000                	add	s0,sp,32
    80003300:	84aa                	mv	s1,a0
  iunlock(ip);
    80003302:	e99ff0ef          	jal	8000319a <iunlock>
  iput(ip);
    80003306:	8526                	mv	a0,s1
    80003308:	f67ff0ef          	jal	8000326e <iput>
}
    8000330c:	60e2                	ld	ra,24(sp)
    8000330e:	6442                	ld	s0,16(sp)
    80003310:	64a2                	ld	s1,8(sp)
    80003312:	6105                	add	sp,sp,32
    80003314:	8082                	ret

0000000080003316 <stati>:

/* Copy stat information from inode. */
/* Caller must hold ip->lock. */
void
stati(struct inode *ip, struct stat *st)
{
    80003316:	1141                	add	sp,sp,-16
    80003318:	e422                	sd	s0,8(sp)
    8000331a:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    8000331c:	411c                	lw	a5,0(a0)
    8000331e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003320:	415c                	lw	a5,4(a0)
    80003322:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003324:	04451783          	lh	a5,68(a0)
    80003328:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000332c:	04a51783          	lh	a5,74(a0)
    80003330:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003334:	04c56783          	lwu	a5,76(a0)
    80003338:	e99c                	sd	a5,16(a1)
}
    8000333a:	6422                	ld	s0,8(sp)
    8000333c:	0141                	add	sp,sp,16
    8000333e:	8082                	ret

0000000080003340 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003340:	457c                	lw	a5,76(a0)
    80003342:	0cd7ef63          	bltu	a5,a3,80003420 <readi+0xe0>
{
    80003346:	7159                	add	sp,sp,-112
    80003348:	f486                	sd	ra,104(sp)
    8000334a:	f0a2                	sd	s0,96(sp)
    8000334c:	eca6                	sd	s1,88(sp)
    8000334e:	e8ca                	sd	s2,80(sp)
    80003350:	e4ce                	sd	s3,72(sp)
    80003352:	e0d2                	sd	s4,64(sp)
    80003354:	fc56                	sd	s5,56(sp)
    80003356:	f85a                	sd	s6,48(sp)
    80003358:	f45e                	sd	s7,40(sp)
    8000335a:	f062                	sd	s8,32(sp)
    8000335c:	ec66                	sd	s9,24(sp)
    8000335e:	e86a                	sd	s10,16(sp)
    80003360:	e46e                	sd	s11,8(sp)
    80003362:	1880                	add	s0,sp,112
    80003364:	8b2a                	mv	s6,a0
    80003366:	8bae                	mv	s7,a1
    80003368:	8a32                	mv	s4,a2
    8000336a:	84b6                	mv	s1,a3
    8000336c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000336e:	9f35                	addw	a4,a4,a3
    return 0;
    80003370:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003372:	08d76663          	bltu	a4,a3,800033fe <readi+0xbe>
  if(off + n > ip->size)
    80003376:	00e7f463          	bgeu	a5,a4,8000337e <readi+0x3e>
    n = ip->size - off;
    8000337a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000337e:	080a8f63          	beqz	s5,8000341c <readi+0xdc>
    80003382:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003384:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003388:	5c7d                	li	s8,-1
    8000338a:	a80d                	j	800033bc <readi+0x7c>
    8000338c:	020d1d93          	sll	s11,s10,0x20
    80003390:	020ddd93          	srl	s11,s11,0x20
    80003394:	05890613          	add	a2,s2,88
    80003398:	86ee                	mv	a3,s11
    8000339a:	963a                	add	a2,a2,a4
    8000339c:	85d2                	mv	a1,s4
    8000339e:	855e                	mv	a0,s7
    800033a0:	db9fe0ef          	jal	80002158 <either_copyout>
    800033a4:	05850763          	beq	a0,s8,800033f2 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800033a8:	854a                	mv	a0,s2
    800033aa:	f3aff0ef          	jal	80002ae4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033ae:	013d09bb          	addw	s3,s10,s3
    800033b2:	009d04bb          	addw	s1,s10,s1
    800033b6:	9a6e                	add	s4,s4,s11
    800033b8:	0559f163          	bgeu	s3,s5,800033fa <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800033bc:	00a4d59b          	srlw	a1,s1,0xa
    800033c0:	855a                	mv	a0,s6
    800033c2:	98dff0ef          	jal	80002d4e <bmap>
    800033c6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800033ca:	c985                	beqz	a1,800033fa <readi+0xba>
    bp = bread(ip->dev, addr);
    800033cc:	000b2503          	lw	a0,0(s6)
    800033d0:	e0cff0ef          	jal	800029dc <bread>
    800033d4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800033d6:	3ff4f713          	and	a4,s1,1023
    800033da:	40ec87bb          	subw	a5,s9,a4
    800033de:	413a86bb          	subw	a3,s5,s3
    800033e2:	8d3e                	mv	s10,a5
    800033e4:	2781                	sext.w	a5,a5
    800033e6:	0006861b          	sext.w	a2,a3
    800033ea:	faf671e3          	bgeu	a2,a5,8000338c <readi+0x4c>
    800033ee:	8d36                	mv	s10,a3
    800033f0:	bf71                	j	8000338c <readi+0x4c>
      brelse(bp);
    800033f2:	854a                	mv	a0,s2
    800033f4:	ef0ff0ef          	jal	80002ae4 <brelse>
      tot = -1;
    800033f8:	59fd                	li	s3,-1
  }
  return tot;
    800033fa:	0009851b          	sext.w	a0,s3
}
    800033fe:	70a6                	ld	ra,104(sp)
    80003400:	7406                	ld	s0,96(sp)
    80003402:	64e6                	ld	s1,88(sp)
    80003404:	6946                	ld	s2,80(sp)
    80003406:	69a6                	ld	s3,72(sp)
    80003408:	6a06                	ld	s4,64(sp)
    8000340a:	7ae2                	ld	s5,56(sp)
    8000340c:	7b42                	ld	s6,48(sp)
    8000340e:	7ba2                	ld	s7,40(sp)
    80003410:	7c02                	ld	s8,32(sp)
    80003412:	6ce2                	ld	s9,24(sp)
    80003414:	6d42                	ld	s10,16(sp)
    80003416:	6da2                	ld	s11,8(sp)
    80003418:	6165                	add	sp,sp,112
    8000341a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000341c:	89d6                	mv	s3,s5
    8000341e:	bff1                	j	800033fa <readi+0xba>
    return 0;
    80003420:	4501                	li	a0,0
}
    80003422:	8082                	ret

0000000080003424 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003424:	457c                	lw	a5,76(a0)
    80003426:	0ed7ea63          	bltu	a5,a3,8000351a <writei+0xf6>
{
    8000342a:	7159                	add	sp,sp,-112
    8000342c:	f486                	sd	ra,104(sp)
    8000342e:	f0a2                	sd	s0,96(sp)
    80003430:	eca6                	sd	s1,88(sp)
    80003432:	e8ca                	sd	s2,80(sp)
    80003434:	e4ce                	sd	s3,72(sp)
    80003436:	e0d2                	sd	s4,64(sp)
    80003438:	fc56                	sd	s5,56(sp)
    8000343a:	f85a                	sd	s6,48(sp)
    8000343c:	f45e                	sd	s7,40(sp)
    8000343e:	f062                	sd	s8,32(sp)
    80003440:	ec66                	sd	s9,24(sp)
    80003442:	e86a                	sd	s10,16(sp)
    80003444:	e46e                	sd	s11,8(sp)
    80003446:	1880                	add	s0,sp,112
    80003448:	8aaa                	mv	s5,a0
    8000344a:	8bae                	mv	s7,a1
    8000344c:	8a32                	mv	s4,a2
    8000344e:	8936                	mv	s2,a3
    80003450:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003452:	00e687bb          	addw	a5,a3,a4
    80003456:	0cd7e463          	bltu	a5,a3,8000351e <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000345a:	00043737          	lui	a4,0x43
    8000345e:	0cf76263          	bltu	a4,a5,80003522 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003462:	0a0b0a63          	beqz	s6,80003516 <writei+0xf2>
    80003466:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003468:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000346c:	5c7d                	li	s8,-1
    8000346e:	a825                	j	800034a6 <writei+0x82>
    80003470:	020d1d93          	sll	s11,s10,0x20
    80003474:	020ddd93          	srl	s11,s11,0x20
    80003478:	05848513          	add	a0,s1,88
    8000347c:	86ee                	mv	a3,s11
    8000347e:	8652                	mv	a2,s4
    80003480:	85de                	mv	a1,s7
    80003482:	953a                	add	a0,a0,a4
    80003484:	d1ffe0ef          	jal	800021a2 <either_copyin>
    80003488:	05850a63          	beq	a0,s8,800034dc <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000348c:	8526                	mv	a0,s1
    8000348e:	64e000ef          	jal	80003adc <log_write>
    brelse(bp);
    80003492:	8526                	mv	a0,s1
    80003494:	e50ff0ef          	jal	80002ae4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003498:	013d09bb          	addw	s3,s10,s3
    8000349c:	012d093b          	addw	s2,s10,s2
    800034a0:	9a6e                	add	s4,s4,s11
    800034a2:	0569f063          	bgeu	s3,s6,800034e2 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800034a6:	00a9559b          	srlw	a1,s2,0xa
    800034aa:	8556                	mv	a0,s5
    800034ac:	8a3ff0ef          	jal	80002d4e <bmap>
    800034b0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034b4:	c59d                	beqz	a1,800034e2 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800034b6:	000aa503          	lw	a0,0(s5)
    800034ba:	d22ff0ef          	jal	800029dc <bread>
    800034be:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034c0:	3ff97713          	and	a4,s2,1023
    800034c4:	40ec87bb          	subw	a5,s9,a4
    800034c8:	413b06bb          	subw	a3,s6,s3
    800034cc:	8d3e                	mv	s10,a5
    800034ce:	2781                	sext.w	a5,a5
    800034d0:	0006861b          	sext.w	a2,a3
    800034d4:	f8f67ee3          	bgeu	a2,a5,80003470 <writei+0x4c>
    800034d8:	8d36                	mv	s10,a3
    800034da:	bf59                	j	80003470 <writei+0x4c>
      brelse(bp);
    800034dc:	8526                	mv	a0,s1
    800034de:	e06ff0ef          	jal	80002ae4 <brelse>
  }

  if(off > ip->size)
    800034e2:	04caa783          	lw	a5,76(s5)
    800034e6:	0127f463          	bgeu	a5,s2,800034ee <writei+0xca>
    ip->size = off;
    800034ea:	052aa623          	sw	s2,76(s5)

  /* write the i-node back to disk even if the size didn't change */
  /* because the loop above might have called bmap() and added a new */
  /* block to ip->addrs[]. */
  iupdate(ip);
    800034ee:	8556                	mv	a0,s5
    800034f0:	b4dff0ef          	jal	8000303c <iupdate>

  return tot;
    800034f4:	0009851b          	sext.w	a0,s3
}
    800034f8:	70a6                	ld	ra,104(sp)
    800034fa:	7406                	ld	s0,96(sp)
    800034fc:	64e6                	ld	s1,88(sp)
    800034fe:	6946                	ld	s2,80(sp)
    80003500:	69a6                	ld	s3,72(sp)
    80003502:	6a06                	ld	s4,64(sp)
    80003504:	7ae2                	ld	s5,56(sp)
    80003506:	7b42                	ld	s6,48(sp)
    80003508:	7ba2                	ld	s7,40(sp)
    8000350a:	7c02                	ld	s8,32(sp)
    8000350c:	6ce2                	ld	s9,24(sp)
    8000350e:	6d42                	ld	s10,16(sp)
    80003510:	6da2                	ld	s11,8(sp)
    80003512:	6165                	add	sp,sp,112
    80003514:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003516:	89da                	mv	s3,s6
    80003518:	bfd9                	j	800034ee <writei+0xca>
    return -1;
    8000351a:	557d                	li	a0,-1
}
    8000351c:	8082                	ret
    return -1;
    8000351e:	557d                	li	a0,-1
    80003520:	bfe1                	j	800034f8 <writei+0xd4>
    return -1;
    80003522:	557d                	li	a0,-1
    80003524:	bfd1                	j	800034f8 <writei+0xd4>

0000000080003526 <namecmp>:

/* Directories */

int
namecmp(const char *s, const char *t)
{
    80003526:	1141                	add	sp,sp,-16
    80003528:	e406                	sd	ra,8(sp)
    8000352a:	e022                	sd	s0,0(sp)
    8000352c:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000352e:	4639                	li	a2,14
    80003530:	811fd0ef          	jal	80000d40 <strncmp>
}
    80003534:	60a2                	ld	ra,8(sp)
    80003536:	6402                	ld	s0,0(sp)
    80003538:	0141                	add	sp,sp,16
    8000353a:	8082                	ret

000000008000353c <dirlookup>:

/* Look for a directory entry in a directory. */
/* If found, set *poff to byte offset of entry. */
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000353c:	7139                	add	sp,sp,-64
    8000353e:	fc06                	sd	ra,56(sp)
    80003540:	f822                	sd	s0,48(sp)
    80003542:	f426                	sd	s1,40(sp)
    80003544:	f04a                	sd	s2,32(sp)
    80003546:	ec4e                	sd	s3,24(sp)
    80003548:	e852                	sd	s4,16(sp)
    8000354a:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000354c:	04451703          	lh	a4,68(a0)
    80003550:	4785                	li	a5,1
    80003552:	00f71a63          	bne	a4,a5,80003566 <dirlookup+0x2a>
    80003556:	892a                	mv	s2,a0
    80003558:	89ae                	mv	s3,a1
    8000355a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000355c:	457c                	lw	a5,76(a0)
    8000355e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003560:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003562:	e39d                	bnez	a5,80003588 <dirlookup+0x4c>
    80003564:	a095                	j	800035c8 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003566:	00004517          	auipc	a0,0x4
    8000356a:	0ca50513          	add	a0,a0,202 # 80007630 <syscalls+0x1a0>
    8000356e:	9f0fd0ef          	jal	8000075e <panic>
      panic("dirlookup read");
    80003572:	00004517          	auipc	a0,0x4
    80003576:	0d650513          	add	a0,a0,214 # 80007648 <syscalls+0x1b8>
    8000357a:	9e4fd0ef          	jal	8000075e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000357e:	24c1                	addw	s1,s1,16
    80003580:	04c92783          	lw	a5,76(s2)
    80003584:	04f4f163          	bgeu	s1,a5,800035c6 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003588:	4741                	li	a4,16
    8000358a:	86a6                	mv	a3,s1
    8000358c:	fc040613          	add	a2,s0,-64
    80003590:	4581                	li	a1,0
    80003592:	854a                	mv	a0,s2
    80003594:	dadff0ef          	jal	80003340 <readi>
    80003598:	47c1                	li	a5,16
    8000359a:	fcf51ce3          	bne	a0,a5,80003572 <dirlookup+0x36>
    if(de.inum == 0)
    8000359e:	fc045783          	lhu	a5,-64(s0)
    800035a2:	dff1                	beqz	a5,8000357e <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800035a4:	fc240593          	add	a1,s0,-62
    800035a8:	854e                	mv	a0,s3
    800035aa:	f7dff0ef          	jal	80003526 <namecmp>
    800035ae:	f961                	bnez	a0,8000357e <dirlookup+0x42>
      if(poff)
    800035b0:	000a0463          	beqz	s4,800035b8 <dirlookup+0x7c>
        *poff = off;
    800035b4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800035b8:	fc045583          	lhu	a1,-64(s0)
    800035bc:	00092503          	lw	a0,0(s2)
    800035c0:	85dff0ef          	jal	80002e1c <iget>
    800035c4:	a011                	j	800035c8 <dirlookup+0x8c>
  return 0;
    800035c6:	4501                	li	a0,0
}
    800035c8:	70e2                	ld	ra,56(sp)
    800035ca:	7442                	ld	s0,48(sp)
    800035cc:	74a2                	ld	s1,40(sp)
    800035ce:	7902                	ld	s2,32(sp)
    800035d0:	69e2                	ld	s3,24(sp)
    800035d2:	6a42                	ld	s4,16(sp)
    800035d4:	6121                	add	sp,sp,64
    800035d6:	8082                	ret

00000000800035d8 <namex>:
/* If parent != 0, return the inode for the parent and copy the final */
/* path element into name, which must have room for DIRSIZ bytes. */
/* Must be called inside a transaction since it calls iput(). */
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800035d8:	711d                	add	sp,sp,-96
    800035da:	ec86                	sd	ra,88(sp)
    800035dc:	e8a2                	sd	s0,80(sp)
    800035de:	e4a6                	sd	s1,72(sp)
    800035e0:	e0ca                	sd	s2,64(sp)
    800035e2:	fc4e                	sd	s3,56(sp)
    800035e4:	f852                	sd	s4,48(sp)
    800035e6:	f456                	sd	s5,40(sp)
    800035e8:	f05a                	sd	s6,32(sp)
    800035ea:	ec5e                	sd	s7,24(sp)
    800035ec:	e862                	sd	s8,16(sp)
    800035ee:	e466                	sd	s9,8(sp)
    800035f0:	1080                	add	s0,sp,96
    800035f2:	84aa                	mv	s1,a0
    800035f4:	8b2e                	mv	s6,a1
    800035f6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800035f8:	00054703          	lbu	a4,0(a0)
    800035fc:	02f00793          	li	a5,47
    80003600:	00f70e63          	beq	a4,a5,8000361c <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003604:	a2cfe0ef          	jal	80001830 <myproc>
    80003608:	15053503          	ld	a0,336(a0)
    8000360c:	aafff0ef          	jal	800030ba <idup>
    80003610:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003612:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003616:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003618:	4b85                	li	s7,1
    8000361a:	a871                	j	800036b6 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    8000361c:	4585                	li	a1,1
    8000361e:	4505                	li	a0,1
    80003620:	ffcff0ef          	jal	80002e1c <iget>
    80003624:	8a2a                	mv	s4,a0
    80003626:	b7f5                	j	80003612 <namex+0x3a>
      iunlockput(ip);
    80003628:	8552                	mv	a0,s4
    8000362a:	ccdff0ef          	jal	800032f6 <iunlockput>
      return 0;
    8000362e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003630:	8552                	mv	a0,s4
    80003632:	60e6                	ld	ra,88(sp)
    80003634:	6446                	ld	s0,80(sp)
    80003636:	64a6                	ld	s1,72(sp)
    80003638:	6906                	ld	s2,64(sp)
    8000363a:	79e2                	ld	s3,56(sp)
    8000363c:	7a42                	ld	s4,48(sp)
    8000363e:	7aa2                	ld	s5,40(sp)
    80003640:	7b02                	ld	s6,32(sp)
    80003642:	6be2                	ld	s7,24(sp)
    80003644:	6c42                	ld	s8,16(sp)
    80003646:	6ca2                	ld	s9,8(sp)
    80003648:	6125                	add	sp,sp,96
    8000364a:	8082                	ret
      iunlock(ip);
    8000364c:	8552                	mv	a0,s4
    8000364e:	b4dff0ef          	jal	8000319a <iunlock>
      return ip;
    80003652:	bff9                	j	80003630 <namex+0x58>
      iunlockput(ip);
    80003654:	8552                	mv	a0,s4
    80003656:	ca1ff0ef          	jal	800032f6 <iunlockput>
      return 0;
    8000365a:	8a4e                	mv	s4,s3
    8000365c:	bfd1                	j	80003630 <namex+0x58>
  len = path - s;
    8000365e:	40998633          	sub	a2,s3,s1
    80003662:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003666:	099c5063          	bge	s8,s9,800036e6 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    8000366a:	4639                	li	a2,14
    8000366c:	85a6                	mv	a1,s1
    8000366e:	8556                	mv	a0,s5
    80003670:	e60fd0ef          	jal	80000cd0 <memmove>
    80003674:	84ce                	mv	s1,s3
  while(*path == '/')
    80003676:	0004c783          	lbu	a5,0(s1)
    8000367a:	01279763          	bne	a5,s2,80003688 <namex+0xb0>
    path++;
    8000367e:	0485                	add	s1,s1,1
  while(*path == '/')
    80003680:	0004c783          	lbu	a5,0(s1)
    80003684:	ff278de3          	beq	a5,s2,8000367e <namex+0xa6>
    ilock(ip);
    80003688:	8552                	mv	a0,s4
    8000368a:	a67ff0ef          	jal	800030f0 <ilock>
    if(ip->type != T_DIR){
    8000368e:	044a1783          	lh	a5,68(s4)
    80003692:	f9779be3          	bne	a5,s7,80003628 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003696:	000b0563          	beqz	s6,800036a0 <namex+0xc8>
    8000369a:	0004c783          	lbu	a5,0(s1)
    8000369e:	d7dd                	beqz	a5,8000364c <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800036a0:	4601                	li	a2,0
    800036a2:	85d6                	mv	a1,s5
    800036a4:	8552                	mv	a0,s4
    800036a6:	e97ff0ef          	jal	8000353c <dirlookup>
    800036aa:	89aa                	mv	s3,a0
    800036ac:	d545                	beqz	a0,80003654 <namex+0x7c>
    iunlockput(ip);
    800036ae:	8552                	mv	a0,s4
    800036b0:	c47ff0ef          	jal	800032f6 <iunlockput>
    ip = next;
    800036b4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800036b6:	0004c783          	lbu	a5,0(s1)
    800036ba:	01279763          	bne	a5,s2,800036c8 <namex+0xf0>
    path++;
    800036be:	0485                	add	s1,s1,1
  while(*path == '/')
    800036c0:	0004c783          	lbu	a5,0(s1)
    800036c4:	ff278de3          	beq	a5,s2,800036be <namex+0xe6>
  if(*path == 0)
    800036c8:	cb8d                	beqz	a5,800036fa <namex+0x122>
  while(*path != '/' && *path != 0)
    800036ca:	0004c783          	lbu	a5,0(s1)
    800036ce:	89a6                	mv	s3,s1
  len = path - s;
    800036d0:	4c81                	li	s9,0
    800036d2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800036d4:	01278963          	beq	a5,s2,800036e6 <namex+0x10e>
    800036d8:	d3d9                	beqz	a5,8000365e <namex+0x86>
    path++;
    800036da:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800036dc:	0009c783          	lbu	a5,0(s3)
    800036e0:	ff279ce3          	bne	a5,s2,800036d8 <namex+0x100>
    800036e4:	bfad                	j	8000365e <namex+0x86>
    memmove(name, s, len);
    800036e6:	2601                	sext.w	a2,a2
    800036e8:	85a6                	mv	a1,s1
    800036ea:	8556                	mv	a0,s5
    800036ec:	de4fd0ef          	jal	80000cd0 <memmove>
    name[len] = 0;
    800036f0:	9cd6                	add	s9,s9,s5
    800036f2:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800036f6:	84ce                	mv	s1,s3
    800036f8:	bfbd                	j	80003676 <namex+0x9e>
  if(nameiparent){
    800036fa:	f20b0be3          	beqz	s6,80003630 <namex+0x58>
    iput(ip);
    800036fe:	8552                	mv	a0,s4
    80003700:	b6fff0ef          	jal	8000326e <iput>
    return 0;
    80003704:	4a01                	li	s4,0
    80003706:	b72d                	j	80003630 <namex+0x58>

0000000080003708 <dirlink>:
{
    80003708:	7139                	add	sp,sp,-64
    8000370a:	fc06                	sd	ra,56(sp)
    8000370c:	f822                	sd	s0,48(sp)
    8000370e:	f426                	sd	s1,40(sp)
    80003710:	f04a                	sd	s2,32(sp)
    80003712:	ec4e                	sd	s3,24(sp)
    80003714:	e852                	sd	s4,16(sp)
    80003716:	0080                	add	s0,sp,64
    80003718:	892a                	mv	s2,a0
    8000371a:	8a2e                	mv	s4,a1
    8000371c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000371e:	4601                	li	a2,0
    80003720:	e1dff0ef          	jal	8000353c <dirlookup>
    80003724:	e52d                	bnez	a0,8000378e <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003726:	04c92483          	lw	s1,76(s2)
    8000372a:	c48d                	beqz	s1,80003754 <dirlink+0x4c>
    8000372c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000372e:	4741                	li	a4,16
    80003730:	86a6                	mv	a3,s1
    80003732:	fc040613          	add	a2,s0,-64
    80003736:	4581                	li	a1,0
    80003738:	854a                	mv	a0,s2
    8000373a:	c07ff0ef          	jal	80003340 <readi>
    8000373e:	47c1                	li	a5,16
    80003740:	04f51b63          	bne	a0,a5,80003796 <dirlink+0x8e>
    if(de.inum == 0)
    80003744:	fc045783          	lhu	a5,-64(s0)
    80003748:	c791                	beqz	a5,80003754 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000374a:	24c1                	addw	s1,s1,16
    8000374c:	04c92783          	lw	a5,76(s2)
    80003750:	fcf4efe3          	bltu	s1,a5,8000372e <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003754:	4639                	li	a2,14
    80003756:	85d2                	mv	a1,s4
    80003758:	fc240513          	add	a0,s0,-62
    8000375c:	e20fd0ef          	jal	80000d7c <strncpy>
  de.inum = inum;
    80003760:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003764:	4741                	li	a4,16
    80003766:	86a6                	mv	a3,s1
    80003768:	fc040613          	add	a2,s0,-64
    8000376c:	4581                	li	a1,0
    8000376e:	854a                	mv	a0,s2
    80003770:	cb5ff0ef          	jal	80003424 <writei>
    80003774:	1541                	add	a0,a0,-16
    80003776:	00a03533          	snez	a0,a0
    8000377a:	40a00533          	neg	a0,a0
}
    8000377e:	70e2                	ld	ra,56(sp)
    80003780:	7442                	ld	s0,48(sp)
    80003782:	74a2                	ld	s1,40(sp)
    80003784:	7902                	ld	s2,32(sp)
    80003786:	69e2                	ld	s3,24(sp)
    80003788:	6a42                	ld	s4,16(sp)
    8000378a:	6121                	add	sp,sp,64
    8000378c:	8082                	ret
    iput(ip);
    8000378e:	ae1ff0ef          	jal	8000326e <iput>
    return -1;
    80003792:	557d                	li	a0,-1
    80003794:	b7ed                	j	8000377e <dirlink+0x76>
      panic("dirlink read");
    80003796:	00004517          	auipc	a0,0x4
    8000379a:	ec250513          	add	a0,a0,-318 # 80007658 <syscalls+0x1c8>
    8000379e:	fc1fc0ef          	jal	8000075e <panic>

00000000800037a2 <namei>:

struct inode*
namei(char *path)
{
    800037a2:	1101                	add	sp,sp,-32
    800037a4:	ec06                	sd	ra,24(sp)
    800037a6:	e822                	sd	s0,16(sp)
    800037a8:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800037aa:	fe040613          	add	a2,s0,-32
    800037ae:	4581                	li	a1,0
    800037b0:	e29ff0ef          	jal	800035d8 <namex>
}
    800037b4:	60e2                	ld	ra,24(sp)
    800037b6:	6442                	ld	s0,16(sp)
    800037b8:	6105                	add	sp,sp,32
    800037ba:	8082                	ret

00000000800037bc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800037bc:	1141                	add	sp,sp,-16
    800037be:	e406                	sd	ra,8(sp)
    800037c0:	e022                	sd	s0,0(sp)
    800037c2:	0800                	add	s0,sp,16
    800037c4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800037c6:	4585                	li	a1,1
    800037c8:	e11ff0ef          	jal	800035d8 <namex>
}
    800037cc:	60a2                	ld	ra,8(sp)
    800037ce:	6402                	ld	s0,0(sp)
    800037d0:	0141                	add	sp,sp,16
    800037d2:	8082                	ret

00000000800037d4 <write_head>:
/* Write in-memory log header to disk. */
/* This is the true point at which the */
/* current transaction commits. */
static void
write_head(void)
{
    800037d4:	1101                	add	sp,sp,-32
    800037d6:	ec06                	sd	ra,24(sp)
    800037d8:	e822                	sd	s0,16(sp)
    800037da:	e426                	sd	s1,8(sp)
    800037dc:	e04a                	sd	s2,0(sp)
    800037de:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800037e0:	0001c917          	auipc	s2,0x1c
    800037e4:	22090913          	add	s2,s2,544 # 8001fa00 <log>
    800037e8:	01892583          	lw	a1,24(s2)
    800037ec:	02892503          	lw	a0,40(s2)
    800037f0:	9ecff0ef          	jal	800029dc <bread>
    800037f4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800037f6:	02c92603          	lw	a2,44(s2)
    800037fa:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800037fc:	00c05f63          	blez	a2,8000381a <write_head+0x46>
    80003800:	0001c717          	auipc	a4,0x1c
    80003804:	23070713          	add	a4,a4,560 # 8001fa30 <log+0x30>
    80003808:	87aa                	mv	a5,a0
    8000380a:	060a                	sll	a2,a2,0x2
    8000380c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000380e:	4314                	lw	a3,0(a4)
    80003810:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003812:	0711                	add	a4,a4,4
    80003814:	0791                	add	a5,a5,4
    80003816:	fec79ce3          	bne	a5,a2,8000380e <write_head+0x3a>
  }
  bwrite(buf);
    8000381a:	8526                	mv	a0,s1
    8000381c:	a96ff0ef          	jal	80002ab2 <bwrite>
  brelse(buf);
    80003820:	8526                	mv	a0,s1
    80003822:	ac2ff0ef          	jal	80002ae4 <brelse>
}
    80003826:	60e2                	ld	ra,24(sp)
    80003828:	6442                	ld	s0,16(sp)
    8000382a:	64a2                	ld	s1,8(sp)
    8000382c:	6902                	ld	s2,0(sp)
    8000382e:	6105                	add	sp,sp,32
    80003830:	8082                	ret

0000000080003832 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003832:	0001c797          	auipc	a5,0x1c
    80003836:	1fa7a783          	lw	a5,506(a5) # 8001fa2c <log+0x2c>
    8000383a:	08f05f63          	blez	a5,800038d8 <install_trans+0xa6>
{
    8000383e:	7139                	add	sp,sp,-64
    80003840:	fc06                	sd	ra,56(sp)
    80003842:	f822                	sd	s0,48(sp)
    80003844:	f426                	sd	s1,40(sp)
    80003846:	f04a                	sd	s2,32(sp)
    80003848:	ec4e                	sd	s3,24(sp)
    8000384a:	e852                	sd	s4,16(sp)
    8000384c:	e456                	sd	s5,8(sp)
    8000384e:	e05a                	sd	s6,0(sp)
    80003850:	0080                	add	s0,sp,64
    80003852:	8b2a                	mv	s6,a0
    80003854:	0001ca97          	auipc	s5,0x1c
    80003858:	1dca8a93          	add	s5,s5,476 # 8001fa30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000385c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    8000385e:	0001c997          	auipc	s3,0x1c
    80003862:	1a298993          	add	s3,s3,418 # 8001fa00 <log>
    80003866:	a829                	j	80003880 <install_trans+0x4e>
    brelse(lbuf);
    80003868:	854a                	mv	a0,s2
    8000386a:	a7aff0ef          	jal	80002ae4 <brelse>
    brelse(dbuf);
    8000386e:	8526                	mv	a0,s1
    80003870:	a74ff0ef          	jal	80002ae4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003874:	2a05                	addw	s4,s4,1
    80003876:	0a91                	add	s5,s5,4
    80003878:	02c9a783          	lw	a5,44(s3)
    8000387c:	04fa5463          	bge	s4,a5,800038c4 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); /* read log block */
    80003880:	0189a583          	lw	a1,24(s3)
    80003884:	014585bb          	addw	a1,a1,s4
    80003888:	2585                	addw	a1,a1,1
    8000388a:	0289a503          	lw	a0,40(s3)
    8000388e:	94eff0ef          	jal	800029dc <bread>
    80003892:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); /* read dst */
    80003894:	000aa583          	lw	a1,0(s5)
    80003898:	0289a503          	lw	a0,40(s3)
    8000389c:	940ff0ef          	jal	800029dc <bread>
    800038a0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  /* copy block to dst */
    800038a2:	40000613          	li	a2,1024
    800038a6:	05890593          	add	a1,s2,88
    800038aa:	05850513          	add	a0,a0,88
    800038ae:	c22fd0ef          	jal	80000cd0 <memmove>
    bwrite(dbuf);  /* write dst to disk */
    800038b2:	8526                	mv	a0,s1
    800038b4:	9feff0ef          	jal	80002ab2 <bwrite>
    if(recovering == 0)
    800038b8:	fa0b18e3          	bnez	s6,80003868 <install_trans+0x36>
      bunpin(dbuf);
    800038bc:	8526                	mv	a0,s1
    800038be:	ae2ff0ef          	jal	80002ba0 <bunpin>
    800038c2:	b75d                	j	80003868 <install_trans+0x36>
}
    800038c4:	70e2                	ld	ra,56(sp)
    800038c6:	7442                	ld	s0,48(sp)
    800038c8:	74a2                	ld	s1,40(sp)
    800038ca:	7902                	ld	s2,32(sp)
    800038cc:	69e2                	ld	s3,24(sp)
    800038ce:	6a42                	ld	s4,16(sp)
    800038d0:	6aa2                	ld	s5,8(sp)
    800038d2:	6b02                	ld	s6,0(sp)
    800038d4:	6121                	add	sp,sp,64
    800038d6:	8082                	ret
    800038d8:	8082                	ret

00000000800038da <initlog>:
{
    800038da:	7179                	add	sp,sp,-48
    800038dc:	f406                	sd	ra,40(sp)
    800038de:	f022                	sd	s0,32(sp)
    800038e0:	ec26                	sd	s1,24(sp)
    800038e2:	e84a                	sd	s2,16(sp)
    800038e4:	e44e                	sd	s3,8(sp)
    800038e6:	1800                	add	s0,sp,48
    800038e8:	892a                	mv	s2,a0
    800038ea:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800038ec:	0001c497          	auipc	s1,0x1c
    800038f0:	11448493          	add	s1,s1,276 # 8001fa00 <log>
    800038f4:	00004597          	auipc	a1,0x4
    800038f8:	d7458593          	add	a1,a1,-652 # 80007668 <syscalls+0x1d8>
    800038fc:	8526                	mv	a0,s1
    800038fe:	a22fd0ef          	jal	80000b20 <initlock>
  log.start = sb->logstart;
    80003902:	0149a583          	lw	a1,20(s3)
    80003906:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003908:	0109a783          	lw	a5,16(s3)
    8000390c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000390e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003912:	854a                	mv	a0,s2
    80003914:	8c8ff0ef          	jal	800029dc <bread>
  log.lh.n = lh->n;
    80003918:	4d30                	lw	a2,88(a0)
    8000391a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000391c:	00c05f63          	blez	a2,8000393a <initlog+0x60>
    80003920:	87aa                	mv	a5,a0
    80003922:	0001c717          	auipc	a4,0x1c
    80003926:	10e70713          	add	a4,a4,270 # 8001fa30 <log+0x30>
    8000392a:	060a                	sll	a2,a2,0x2
    8000392c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000392e:	4ff4                	lw	a3,92(a5)
    80003930:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003932:	0791                	add	a5,a5,4
    80003934:	0711                	add	a4,a4,4
    80003936:	fec79ce3          	bne	a5,a2,8000392e <initlog+0x54>
  brelse(buf);
    8000393a:	9aaff0ef          	jal	80002ae4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); /* if committed, copy from log to disk */
    8000393e:	4505                	li	a0,1
    80003940:	ef3ff0ef          	jal	80003832 <install_trans>
  log.lh.n = 0;
    80003944:	0001c797          	auipc	a5,0x1c
    80003948:	0e07a423          	sw	zero,232(a5) # 8001fa2c <log+0x2c>
  write_head(); /* clear the log */
    8000394c:	e89ff0ef          	jal	800037d4 <write_head>
}
    80003950:	70a2                	ld	ra,40(sp)
    80003952:	7402                	ld	s0,32(sp)
    80003954:	64e2                	ld	s1,24(sp)
    80003956:	6942                	ld	s2,16(sp)
    80003958:	69a2                	ld	s3,8(sp)
    8000395a:	6145                	add	sp,sp,48
    8000395c:	8082                	ret

000000008000395e <begin_op>:
}

/* called at the start of each FS system call. */
void
begin_op(void)
{
    8000395e:	1101                	add	sp,sp,-32
    80003960:	ec06                	sd	ra,24(sp)
    80003962:	e822                	sd	s0,16(sp)
    80003964:	e426                	sd	s1,8(sp)
    80003966:	e04a                	sd	s2,0(sp)
    80003968:	1000                	add	s0,sp,32
  acquire(&log.lock);
    8000396a:	0001c517          	auipc	a0,0x1c
    8000396e:	09650513          	add	a0,a0,150 # 8001fa00 <log>
    80003972:	a2efd0ef          	jal	80000ba0 <acquire>
  while(1){
    if(log.committing){
    80003976:	0001c497          	auipc	s1,0x1c
    8000397a:	08a48493          	add	s1,s1,138 # 8001fa00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000397e:	4979                	li	s2,30
    80003980:	a029                	j	8000398a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003982:	85a6                	mv	a1,s1
    80003984:	8526                	mv	a0,s1
    80003986:	c76fe0ef          	jal	80001dfc <sleep>
    if(log.committing){
    8000398a:	50dc                	lw	a5,36(s1)
    8000398c:	fbfd                	bnez	a5,80003982 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000398e:	5098                	lw	a4,32(s1)
    80003990:	2705                	addw	a4,a4,1
    80003992:	0027179b          	sllw	a5,a4,0x2
    80003996:	9fb9                	addw	a5,a5,a4
    80003998:	0017979b          	sllw	a5,a5,0x1
    8000399c:	54d4                	lw	a3,44(s1)
    8000399e:	9fb5                	addw	a5,a5,a3
    800039a0:	00f95763          	bge	s2,a5,800039ae <begin_op+0x50>
      /* this op might exhaust log space; wait for commit. */
      sleep(&log, &log.lock);
    800039a4:	85a6                	mv	a1,s1
    800039a6:	8526                	mv	a0,s1
    800039a8:	c54fe0ef          	jal	80001dfc <sleep>
    800039ac:	bff9                	j	8000398a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800039ae:	0001c517          	auipc	a0,0x1c
    800039b2:	05250513          	add	a0,a0,82 # 8001fa00 <log>
    800039b6:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800039b8:	a80fd0ef          	jal	80000c38 <release>
      break;
    }
  }
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6902                	ld	s2,0(sp)
    800039c4:	6105                	add	sp,sp,32
    800039c6:	8082                	ret

00000000800039c8 <end_op>:

/* called at the end of each FS system call. */
/* commits if this was the last outstanding operation. */
void
end_op(void)
{
    800039c8:	7139                	add	sp,sp,-64
    800039ca:	fc06                	sd	ra,56(sp)
    800039cc:	f822                	sd	s0,48(sp)
    800039ce:	f426                	sd	s1,40(sp)
    800039d0:	f04a                	sd	s2,32(sp)
    800039d2:	ec4e                	sd	s3,24(sp)
    800039d4:	e852                	sd	s4,16(sp)
    800039d6:	e456                	sd	s5,8(sp)
    800039d8:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800039da:	0001c497          	auipc	s1,0x1c
    800039de:	02648493          	add	s1,s1,38 # 8001fa00 <log>
    800039e2:	8526                	mv	a0,s1
    800039e4:	9bcfd0ef          	jal	80000ba0 <acquire>
  log.outstanding -= 1;
    800039e8:	509c                	lw	a5,32(s1)
    800039ea:	37fd                	addw	a5,a5,-1
    800039ec:	0007891b          	sext.w	s2,a5
    800039f0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800039f2:	50dc                	lw	a5,36(s1)
    800039f4:	ef9d                	bnez	a5,80003a32 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    800039f6:	04091463          	bnez	s2,80003a3e <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800039fa:	0001c497          	auipc	s1,0x1c
    800039fe:	00648493          	add	s1,s1,6 # 8001fa00 <log>
    80003a02:	4785                	li	a5,1
    80003a04:	d0dc                	sw	a5,36(s1)
    /* begin_op() may be waiting for log space, */
    /* and decrementing log.outstanding has decreased */
    /* the amount of reserved space. */
    wakeup(&log);
  }
  release(&log.lock);
    80003a06:	8526                	mv	a0,s1
    80003a08:	a30fd0ef          	jal	80000c38 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a0c:	54dc                	lw	a5,44(s1)
    80003a0e:	04f04b63          	bgtz	a5,80003a64 <end_op+0x9c>
    acquire(&log.lock);
    80003a12:	0001c497          	auipc	s1,0x1c
    80003a16:	fee48493          	add	s1,s1,-18 # 8001fa00 <log>
    80003a1a:	8526                	mv	a0,s1
    80003a1c:	984fd0ef          	jal	80000ba0 <acquire>
    log.committing = 0;
    80003a20:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003a24:	8526                	mv	a0,s1
    80003a26:	c22fe0ef          	jal	80001e48 <wakeup>
    release(&log.lock);
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	a0cfd0ef          	jal	80000c38 <release>
}
    80003a30:	a00d                	j	80003a52 <end_op+0x8a>
    panic("log.committing");
    80003a32:	00004517          	auipc	a0,0x4
    80003a36:	c3e50513          	add	a0,a0,-962 # 80007670 <syscalls+0x1e0>
    80003a3a:	d25fc0ef          	jal	8000075e <panic>
    wakeup(&log);
    80003a3e:	0001c497          	auipc	s1,0x1c
    80003a42:	fc248493          	add	s1,s1,-62 # 8001fa00 <log>
    80003a46:	8526                	mv	a0,s1
    80003a48:	c00fe0ef          	jal	80001e48 <wakeup>
  release(&log.lock);
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	9eafd0ef          	jal	80000c38 <release>
}
    80003a52:	70e2                	ld	ra,56(sp)
    80003a54:	7442                	ld	s0,48(sp)
    80003a56:	74a2                	ld	s1,40(sp)
    80003a58:	7902                	ld	s2,32(sp)
    80003a5a:	69e2                	ld	s3,24(sp)
    80003a5c:	6a42                	ld	s4,16(sp)
    80003a5e:	6aa2                	ld	s5,8(sp)
    80003a60:	6121                	add	sp,sp,64
    80003a62:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a64:	0001ca97          	auipc	s5,0x1c
    80003a68:	fcca8a93          	add	s5,s5,-52 # 8001fa30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); /* log block */
    80003a6c:	0001ca17          	auipc	s4,0x1c
    80003a70:	f94a0a13          	add	s4,s4,-108 # 8001fa00 <log>
    80003a74:	018a2583          	lw	a1,24(s4)
    80003a78:	012585bb          	addw	a1,a1,s2
    80003a7c:	2585                	addw	a1,a1,1
    80003a7e:	028a2503          	lw	a0,40(s4)
    80003a82:	f5bfe0ef          	jal	800029dc <bread>
    80003a86:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); /* cache block */
    80003a88:	000aa583          	lw	a1,0(s5)
    80003a8c:	028a2503          	lw	a0,40(s4)
    80003a90:	f4dfe0ef          	jal	800029dc <bread>
    80003a94:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003a96:	40000613          	li	a2,1024
    80003a9a:	05850593          	add	a1,a0,88
    80003a9e:	05848513          	add	a0,s1,88
    80003aa2:	a2efd0ef          	jal	80000cd0 <memmove>
    bwrite(to);  /* write the log */
    80003aa6:	8526                	mv	a0,s1
    80003aa8:	80aff0ef          	jal	80002ab2 <bwrite>
    brelse(from);
    80003aac:	854e                	mv	a0,s3
    80003aae:	836ff0ef          	jal	80002ae4 <brelse>
    brelse(to);
    80003ab2:	8526                	mv	a0,s1
    80003ab4:	830ff0ef          	jal	80002ae4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ab8:	2905                	addw	s2,s2,1
    80003aba:	0a91                	add	s5,s5,4
    80003abc:	02ca2783          	lw	a5,44(s4)
    80003ac0:	faf94ae3          	blt	s2,a5,80003a74 <end_op+0xac>
    write_log();     /* Write modified blocks from cache to log */
    write_head();    /* Write header to disk -- the real commit */
    80003ac4:	d11ff0ef          	jal	800037d4 <write_head>
    install_trans(0); /* Now install writes to home locations */
    80003ac8:	4501                	li	a0,0
    80003aca:	d69ff0ef          	jal	80003832 <install_trans>
    log.lh.n = 0;
    80003ace:	0001c797          	auipc	a5,0x1c
    80003ad2:	f407af23          	sw	zero,-162(a5) # 8001fa2c <log+0x2c>
    write_head();    /* Erase the transaction from the log */
    80003ad6:	cffff0ef          	jal	800037d4 <write_head>
    80003ada:	bf25                	j	80003a12 <end_op+0x4a>

0000000080003adc <log_write>:
/*   modify bp->data[] */
/*   log_write(bp) */
/*   brelse(bp) */
void
log_write(struct buf *b)
{
    80003adc:	1101                	add	sp,sp,-32
    80003ade:	ec06                	sd	ra,24(sp)
    80003ae0:	e822                	sd	s0,16(sp)
    80003ae2:	e426                	sd	s1,8(sp)
    80003ae4:	e04a                	sd	s2,0(sp)
    80003ae6:	1000                	add	s0,sp,32
    80003ae8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003aea:	0001c917          	auipc	s2,0x1c
    80003aee:	f1690913          	add	s2,s2,-234 # 8001fa00 <log>
    80003af2:	854a                	mv	a0,s2
    80003af4:	8acfd0ef          	jal	80000ba0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003af8:	02c92603          	lw	a2,44(s2)
    80003afc:	47f5                	li	a5,29
    80003afe:	06c7c363          	blt	a5,a2,80003b64 <log_write+0x88>
    80003b02:	0001c797          	auipc	a5,0x1c
    80003b06:	f1a7a783          	lw	a5,-230(a5) # 8001fa1c <log+0x1c>
    80003b0a:	37fd                	addw	a5,a5,-1
    80003b0c:	04f65c63          	bge	a2,a5,80003b64 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b10:	0001c797          	auipc	a5,0x1c
    80003b14:	f107a783          	lw	a5,-240(a5) # 8001fa20 <log+0x20>
    80003b18:	04f05c63          	blez	a5,80003b70 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b1c:	4781                	li	a5,0
    80003b1e:	04c05f63          	blez	a2,80003b7c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003b22:	44cc                	lw	a1,12(s1)
    80003b24:	0001c717          	auipc	a4,0x1c
    80003b28:	f0c70713          	add	a4,a4,-244 # 8001fa30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b2c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   /* log absorption */
    80003b2e:	4314                	lw	a3,0(a4)
    80003b30:	04b68663          	beq	a3,a1,80003b7c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003b34:	2785                	addw	a5,a5,1
    80003b36:	0711                	add	a4,a4,4
    80003b38:	fef61be3          	bne	a2,a5,80003b2e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b3c:	0621                	add	a2,a2,8
    80003b3e:	060a                	sll	a2,a2,0x2
    80003b40:	0001c797          	auipc	a5,0x1c
    80003b44:	ec078793          	add	a5,a5,-320 # 8001fa00 <log>
    80003b48:	97b2                	add	a5,a5,a2
    80003b4a:	44d8                	lw	a4,12(s1)
    80003b4c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  /* Add new block to log? */
    bpin(b);
    80003b4e:	8526                	mv	a0,s1
    80003b50:	81cff0ef          	jal	80002b6c <bpin>
    log.lh.n++;
    80003b54:	0001c717          	auipc	a4,0x1c
    80003b58:	eac70713          	add	a4,a4,-340 # 8001fa00 <log>
    80003b5c:	575c                	lw	a5,44(a4)
    80003b5e:	2785                	addw	a5,a5,1
    80003b60:	d75c                	sw	a5,44(a4)
    80003b62:	a80d                	j	80003b94 <log_write+0xb8>
    panic("too big a transaction");
    80003b64:	00004517          	auipc	a0,0x4
    80003b68:	b1c50513          	add	a0,a0,-1252 # 80007680 <syscalls+0x1f0>
    80003b6c:	bf3fc0ef          	jal	8000075e <panic>
    panic("log_write outside of trans");
    80003b70:	00004517          	auipc	a0,0x4
    80003b74:	b2850513          	add	a0,a0,-1240 # 80007698 <syscalls+0x208>
    80003b78:	be7fc0ef          	jal	8000075e <panic>
  log.lh.block[i] = b->blockno;
    80003b7c:	00878693          	add	a3,a5,8
    80003b80:	068a                	sll	a3,a3,0x2
    80003b82:	0001c717          	auipc	a4,0x1c
    80003b86:	e7e70713          	add	a4,a4,-386 # 8001fa00 <log>
    80003b8a:	9736                	add	a4,a4,a3
    80003b8c:	44d4                	lw	a3,12(s1)
    80003b8e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  /* Add new block to log? */
    80003b90:	faf60fe3          	beq	a2,a5,80003b4e <log_write+0x72>
  }
  release(&log.lock);
    80003b94:	0001c517          	auipc	a0,0x1c
    80003b98:	e6c50513          	add	a0,a0,-404 # 8001fa00 <log>
    80003b9c:	89cfd0ef          	jal	80000c38 <release>
}
    80003ba0:	60e2                	ld	ra,24(sp)
    80003ba2:	6442                	ld	s0,16(sp)
    80003ba4:	64a2                	ld	s1,8(sp)
    80003ba6:	6902                	ld	s2,0(sp)
    80003ba8:	6105                	add	sp,sp,32
    80003baa:	8082                	ret

0000000080003bac <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003bac:	1101                	add	sp,sp,-32
    80003bae:	ec06                	sd	ra,24(sp)
    80003bb0:	e822                	sd	s0,16(sp)
    80003bb2:	e426                	sd	s1,8(sp)
    80003bb4:	e04a                	sd	s2,0(sp)
    80003bb6:	1000                	add	s0,sp,32
    80003bb8:	84aa                	mv	s1,a0
    80003bba:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003bbc:	00004597          	auipc	a1,0x4
    80003bc0:	afc58593          	add	a1,a1,-1284 # 800076b8 <syscalls+0x228>
    80003bc4:	0521                	add	a0,a0,8
    80003bc6:	f5bfc0ef          	jal	80000b20 <initlock>
  lk->name = name;
    80003bca:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003bce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bd2:	0204a423          	sw	zero,40(s1)
}
    80003bd6:	60e2                	ld	ra,24(sp)
    80003bd8:	6442                	ld	s0,16(sp)
    80003bda:	64a2                	ld	s1,8(sp)
    80003bdc:	6902                	ld	s2,0(sp)
    80003bde:	6105                	add	sp,sp,32
    80003be0:	8082                	ret

0000000080003be2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003be2:	1101                	add	sp,sp,-32
    80003be4:	ec06                	sd	ra,24(sp)
    80003be6:	e822                	sd	s0,16(sp)
    80003be8:	e426                	sd	s1,8(sp)
    80003bea:	e04a                	sd	s2,0(sp)
    80003bec:	1000                	add	s0,sp,32
    80003bee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bf0:	00850913          	add	s2,a0,8
    80003bf4:	854a                	mv	a0,s2
    80003bf6:	fabfc0ef          	jal	80000ba0 <acquire>
  while (lk->locked) {
    80003bfa:	409c                	lw	a5,0(s1)
    80003bfc:	c799                	beqz	a5,80003c0a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003bfe:	85ca                	mv	a1,s2
    80003c00:	8526                	mv	a0,s1
    80003c02:	9fafe0ef          	jal	80001dfc <sleep>
  while (lk->locked) {
    80003c06:	409c                	lw	a5,0(s1)
    80003c08:	fbfd                	bnez	a5,80003bfe <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003c0a:	4785                	li	a5,1
    80003c0c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c0e:	c23fd0ef          	jal	80001830 <myproc>
    80003c12:	591c                	lw	a5,48(a0)
    80003c14:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c16:	854a                	mv	a0,s2
    80003c18:	820fd0ef          	jal	80000c38 <release>
}
    80003c1c:	60e2                	ld	ra,24(sp)
    80003c1e:	6442                	ld	s0,16(sp)
    80003c20:	64a2                	ld	s1,8(sp)
    80003c22:	6902                	ld	s2,0(sp)
    80003c24:	6105                	add	sp,sp,32
    80003c26:	8082                	ret

0000000080003c28 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c28:	1101                	add	sp,sp,-32
    80003c2a:	ec06                	sd	ra,24(sp)
    80003c2c:	e822                	sd	s0,16(sp)
    80003c2e:	e426                	sd	s1,8(sp)
    80003c30:	e04a                	sd	s2,0(sp)
    80003c32:	1000                	add	s0,sp,32
    80003c34:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c36:	00850913          	add	s2,a0,8
    80003c3a:	854a                	mv	a0,s2
    80003c3c:	f65fc0ef          	jal	80000ba0 <acquire>
  lk->locked = 0;
    80003c40:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c44:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c48:	8526                	mv	a0,s1
    80003c4a:	9fefe0ef          	jal	80001e48 <wakeup>
  release(&lk->lk);
    80003c4e:	854a                	mv	a0,s2
    80003c50:	fe9fc0ef          	jal	80000c38 <release>
}
    80003c54:	60e2                	ld	ra,24(sp)
    80003c56:	6442                	ld	s0,16(sp)
    80003c58:	64a2                	ld	s1,8(sp)
    80003c5a:	6902                	ld	s2,0(sp)
    80003c5c:	6105                	add	sp,sp,32
    80003c5e:	8082                	ret

0000000080003c60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c60:	7179                	add	sp,sp,-48
    80003c62:	f406                	sd	ra,40(sp)
    80003c64:	f022                	sd	s0,32(sp)
    80003c66:	ec26                	sd	s1,24(sp)
    80003c68:	e84a                	sd	s2,16(sp)
    80003c6a:	e44e                	sd	s3,8(sp)
    80003c6c:	1800                	add	s0,sp,48
    80003c6e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c70:	00850913          	add	s2,a0,8
    80003c74:	854a                	mv	a0,s2
    80003c76:	f2bfc0ef          	jal	80000ba0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c7a:	409c                	lw	a5,0(s1)
    80003c7c:	ef89                	bnez	a5,80003c96 <holdingsleep+0x36>
    80003c7e:	4481                	li	s1,0
  release(&lk->lk);
    80003c80:	854a                	mv	a0,s2
    80003c82:	fb7fc0ef          	jal	80000c38 <release>
  return r;
}
    80003c86:	8526                	mv	a0,s1
    80003c88:	70a2                	ld	ra,40(sp)
    80003c8a:	7402                	ld	s0,32(sp)
    80003c8c:	64e2                	ld	s1,24(sp)
    80003c8e:	6942                	ld	s2,16(sp)
    80003c90:	69a2                	ld	s3,8(sp)
    80003c92:	6145                	add	sp,sp,48
    80003c94:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c96:	0284a983          	lw	s3,40(s1)
    80003c9a:	b97fd0ef          	jal	80001830 <myproc>
    80003c9e:	5904                	lw	s1,48(a0)
    80003ca0:	413484b3          	sub	s1,s1,s3
    80003ca4:	0014b493          	seqz	s1,s1
    80003ca8:	bfe1                	j	80003c80 <holdingsleep+0x20>

0000000080003caa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003caa:	1141                	add	sp,sp,-16
    80003cac:	e406                	sd	ra,8(sp)
    80003cae:	e022                	sd	s0,0(sp)
    80003cb0:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003cb2:	00004597          	auipc	a1,0x4
    80003cb6:	a1658593          	add	a1,a1,-1514 # 800076c8 <syscalls+0x238>
    80003cba:	0001c517          	auipc	a0,0x1c
    80003cbe:	e8e50513          	add	a0,a0,-370 # 8001fb48 <ftable>
    80003cc2:	e5ffc0ef          	jal	80000b20 <initlock>
}
    80003cc6:	60a2                	ld	ra,8(sp)
    80003cc8:	6402                	ld	s0,0(sp)
    80003cca:	0141                	add	sp,sp,16
    80003ccc:	8082                	ret

0000000080003cce <filealloc>:

/* Allocate a file structure. */
struct file*
filealloc(void)
{
    80003cce:	1101                	add	sp,sp,-32
    80003cd0:	ec06                	sd	ra,24(sp)
    80003cd2:	e822                	sd	s0,16(sp)
    80003cd4:	e426                	sd	s1,8(sp)
    80003cd6:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003cd8:	0001c517          	auipc	a0,0x1c
    80003cdc:	e7050513          	add	a0,a0,-400 # 8001fb48 <ftable>
    80003ce0:	ec1fc0ef          	jal	80000ba0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ce4:	0001c497          	auipc	s1,0x1c
    80003ce8:	e7c48493          	add	s1,s1,-388 # 8001fb60 <ftable+0x18>
    80003cec:	0001d717          	auipc	a4,0x1d
    80003cf0:	e1470713          	add	a4,a4,-492 # 80020b00 <disk>
    if(f->ref == 0){
    80003cf4:	40dc                	lw	a5,4(s1)
    80003cf6:	cf89                	beqz	a5,80003d10 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003cf8:	02848493          	add	s1,s1,40
    80003cfc:	fee49ce3          	bne	s1,a4,80003cf4 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d00:	0001c517          	auipc	a0,0x1c
    80003d04:	e4850513          	add	a0,a0,-440 # 8001fb48 <ftable>
    80003d08:	f31fc0ef          	jal	80000c38 <release>
  return 0;
    80003d0c:	4481                	li	s1,0
    80003d0e:	a809                	j	80003d20 <filealloc+0x52>
      f->ref = 1;
    80003d10:	4785                	li	a5,1
    80003d12:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d14:	0001c517          	auipc	a0,0x1c
    80003d18:	e3450513          	add	a0,a0,-460 # 8001fb48 <ftable>
    80003d1c:	f1dfc0ef          	jal	80000c38 <release>
}
    80003d20:	8526                	mv	a0,s1
    80003d22:	60e2                	ld	ra,24(sp)
    80003d24:	6442                	ld	s0,16(sp)
    80003d26:	64a2                	ld	s1,8(sp)
    80003d28:	6105                	add	sp,sp,32
    80003d2a:	8082                	ret

0000000080003d2c <filedup>:

/* Increment ref count for file f. */
struct file*
filedup(struct file *f)
{
    80003d2c:	1101                	add	sp,sp,-32
    80003d2e:	ec06                	sd	ra,24(sp)
    80003d30:	e822                	sd	s0,16(sp)
    80003d32:	e426                	sd	s1,8(sp)
    80003d34:	1000                	add	s0,sp,32
    80003d36:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d38:	0001c517          	auipc	a0,0x1c
    80003d3c:	e1050513          	add	a0,a0,-496 # 8001fb48 <ftable>
    80003d40:	e61fc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003d44:	40dc                	lw	a5,4(s1)
    80003d46:	02f05063          	blez	a5,80003d66 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003d4a:	2785                	addw	a5,a5,1
    80003d4c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d4e:	0001c517          	auipc	a0,0x1c
    80003d52:	dfa50513          	add	a0,a0,-518 # 8001fb48 <ftable>
    80003d56:	ee3fc0ef          	jal	80000c38 <release>
  return f;
}
    80003d5a:	8526                	mv	a0,s1
    80003d5c:	60e2                	ld	ra,24(sp)
    80003d5e:	6442                	ld	s0,16(sp)
    80003d60:	64a2                	ld	s1,8(sp)
    80003d62:	6105                	add	sp,sp,32
    80003d64:	8082                	ret
    panic("filedup");
    80003d66:	00004517          	auipc	a0,0x4
    80003d6a:	96a50513          	add	a0,a0,-1686 # 800076d0 <syscalls+0x240>
    80003d6e:	9f1fc0ef          	jal	8000075e <panic>

0000000080003d72 <fileclose>:

/* Close file f.  (Decrement ref count, close when reaches 0.) */
void
fileclose(struct file *f)
{
    80003d72:	7139                	add	sp,sp,-64
    80003d74:	fc06                	sd	ra,56(sp)
    80003d76:	f822                	sd	s0,48(sp)
    80003d78:	f426                	sd	s1,40(sp)
    80003d7a:	f04a                	sd	s2,32(sp)
    80003d7c:	ec4e                	sd	s3,24(sp)
    80003d7e:	e852                	sd	s4,16(sp)
    80003d80:	e456                	sd	s5,8(sp)
    80003d82:	0080                	add	s0,sp,64
    80003d84:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d86:	0001c517          	auipc	a0,0x1c
    80003d8a:	dc250513          	add	a0,a0,-574 # 8001fb48 <ftable>
    80003d8e:	e13fc0ef          	jal	80000ba0 <acquire>
  if(f->ref < 1)
    80003d92:	40dc                	lw	a5,4(s1)
    80003d94:	04f05963          	blez	a5,80003de6 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003d98:	37fd                	addw	a5,a5,-1
    80003d9a:	0007871b          	sext.w	a4,a5
    80003d9e:	c0dc                	sw	a5,4(s1)
    80003da0:	04e04963          	bgtz	a4,80003df2 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003da4:	0004a903          	lw	s2,0(s1)
    80003da8:	0094ca83          	lbu	s5,9(s1)
    80003dac:	0104ba03          	ld	s4,16(s1)
    80003db0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003db4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003db8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003dbc:	0001c517          	auipc	a0,0x1c
    80003dc0:	d8c50513          	add	a0,a0,-628 # 8001fb48 <ftable>
    80003dc4:	e75fc0ef          	jal	80000c38 <release>

  if(ff.type == FD_PIPE){
    80003dc8:	4785                	li	a5,1
    80003dca:	04f90363          	beq	s2,a5,80003e10 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003dce:	3979                	addw	s2,s2,-2
    80003dd0:	4785                	li	a5,1
    80003dd2:	0327e663          	bltu	a5,s2,80003dfe <fileclose+0x8c>
    begin_op();
    80003dd6:	b89ff0ef          	jal	8000395e <begin_op>
    iput(ff.ip);
    80003dda:	854e                	mv	a0,s3
    80003ddc:	c92ff0ef          	jal	8000326e <iput>
    end_op();
    80003de0:	be9ff0ef          	jal	800039c8 <end_op>
    80003de4:	a829                	j	80003dfe <fileclose+0x8c>
    panic("fileclose");
    80003de6:	00004517          	auipc	a0,0x4
    80003dea:	8f250513          	add	a0,a0,-1806 # 800076d8 <syscalls+0x248>
    80003dee:	971fc0ef          	jal	8000075e <panic>
    release(&ftable.lock);
    80003df2:	0001c517          	auipc	a0,0x1c
    80003df6:	d5650513          	add	a0,a0,-682 # 8001fb48 <ftable>
    80003dfa:	e3ffc0ef          	jal	80000c38 <release>
  }
}
    80003dfe:	70e2                	ld	ra,56(sp)
    80003e00:	7442                	ld	s0,48(sp)
    80003e02:	74a2                	ld	s1,40(sp)
    80003e04:	7902                	ld	s2,32(sp)
    80003e06:	69e2                	ld	s3,24(sp)
    80003e08:	6a42                	ld	s4,16(sp)
    80003e0a:	6aa2                	ld	s5,8(sp)
    80003e0c:	6121                	add	sp,sp,64
    80003e0e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e10:	85d6                	mv	a1,s5
    80003e12:	8552                	mv	a0,s4
    80003e14:	2e8000ef          	jal	800040fc <pipeclose>
    80003e18:	b7dd                	j	80003dfe <fileclose+0x8c>

0000000080003e1a <filestat>:

/* Get metadata about file f. */
/* addr is a user virtual address, pointing to a struct stat. */
int
filestat(struct file *f, uint64 addr)
{
    80003e1a:	715d                	add	sp,sp,-80
    80003e1c:	e486                	sd	ra,72(sp)
    80003e1e:	e0a2                	sd	s0,64(sp)
    80003e20:	fc26                	sd	s1,56(sp)
    80003e22:	f84a                	sd	s2,48(sp)
    80003e24:	f44e                	sd	s3,40(sp)
    80003e26:	0880                	add	s0,sp,80
    80003e28:	84aa                	mv	s1,a0
    80003e2a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e2c:	a05fd0ef          	jal	80001830 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e30:	409c                	lw	a5,0(s1)
    80003e32:	37f9                	addw	a5,a5,-2
    80003e34:	4705                	li	a4,1
    80003e36:	02f76f63          	bltu	a4,a5,80003e74 <filestat+0x5a>
    80003e3a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e3c:	6c88                	ld	a0,24(s1)
    80003e3e:	ab2ff0ef          	jal	800030f0 <ilock>
    stati(f->ip, &st);
    80003e42:	fb840593          	add	a1,s0,-72
    80003e46:	6c88                	ld	a0,24(s1)
    80003e48:	cceff0ef          	jal	80003316 <stati>
    iunlock(f->ip);
    80003e4c:	6c88                	ld	a0,24(s1)
    80003e4e:	b4cff0ef          	jal	8000319a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e52:	46e1                	li	a3,24
    80003e54:	fb840613          	add	a2,s0,-72
    80003e58:	85ce                	mv	a1,s3
    80003e5a:	05093503          	ld	a0,80(s2)
    80003e5e:	e8afd0ef          	jal	800014e8 <copyout>
    80003e62:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e66:	60a6                	ld	ra,72(sp)
    80003e68:	6406                	ld	s0,64(sp)
    80003e6a:	74e2                	ld	s1,56(sp)
    80003e6c:	7942                	ld	s2,48(sp)
    80003e6e:	79a2                	ld	s3,40(sp)
    80003e70:	6161                	add	sp,sp,80
    80003e72:	8082                	ret
  return -1;
    80003e74:	557d                	li	a0,-1
    80003e76:	bfc5                	j	80003e66 <filestat+0x4c>

0000000080003e78 <fileread>:

/* Read from file f. */
/* addr is a user virtual address. */
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e78:	7179                	add	sp,sp,-48
    80003e7a:	f406                	sd	ra,40(sp)
    80003e7c:	f022                	sd	s0,32(sp)
    80003e7e:	ec26                	sd	s1,24(sp)
    80003e80:	e84a                	sd	s2,16(sp)
    80003e82:	e44e                	sd	s3,8(sp)
    80003e84:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e86:	00854783          	lbu	a5,8(a0)
    80003e8a:	cbc1                	beqz	a5,80003f1a <fileread+0xa2>
    80003e8c:	84aa                	mv	s1,a0
    80003e8e:	89ae                	mv	s3,a1
    80003e90:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e92:	411c                	lw	a5,0(a0)
    80003e94:	4705                	li	a4,1
    80003e96:	04e78363          	beq	a5,a4,80003edc <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e9a:	470d                	li	a4,3
    80003e9c:	04e78563          	beq	a5,a4,80003ee6 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ea0:	4709                	li	a4,2
    80003ea2:	06e79663          	bne	a5,a4,80003f0e <fileread+0x96>
    ilock(f->ip);
    80003ea6:	6d08                	ld	a0,24(a0)
    80003ea8:	a48ff0ef          	jal	800030f0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003eac:	874a                	mv	a4,s2
    80003eae:	5094                	lw	a3,32(s1)
    80003eb0:	864e                	mv	a2,s3
    80003eb2:	4585                	li	a1,1
    80003eb4:	6c88                	ld	a0,24(s1)
    80003eb6:	c8aff0ef          	jal	80003340 <readi>
    80003eba:	892a                	mv	s2,a0
    80003ebc:	00a05563          	blez	a0,80003ec6 <fileread+0x4e>
      f->off += r;
    80003ec0:	509c                	lw	a5,32(s1)
    80003ec2:	9fa9                	addw	a5,a5,a0
    80003ec4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ec6:	6c88                	ld	a0,24(s1)
    80003ec8:	ad2ff0ef          	jal	8000319a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ecc:	854a                	mv	a0,s2
    80003ece:	70a2                	ld	ra,40(sp)
    80003ed0:	7402                	ld	s0,32(sp)
    80003ed2:	64e2                	ld	s1,24(sp)
    80003ed4:	6942                	ld	s2,16(sp)
    80003ed6:	69a2                	ld	s3,8(sp)
    80003ed8:	6145                	add	sp,sp,48
    80003eda:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003edc:	6908                	ld	a0,16(a0)
    80003ede:	34a000ef          	jal	80004228 <piperead>
    80003ee2:	892a                	mv	s2,a0
    80003ee4:	b7e5                	j	80003ecc <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ee6:	02451783          	lh	a5,36(a0)
    80003eea:	03079693          	sll	a3,a5,0x30
    80003eee:	92c1                	srl	a3,a3,0x30
    80003ef0:	4725                	li	a4,9
    80003ef2:	02d76663          	bltu	a4,a3,80003f1e <fileread+0xa6>
    80003ef6:	0792                	sll	a5,a5,0x4
    80003ef8:	0001c717          	auipc	a4,0x1c
    80003efc:	bb070713          	add	a4,a4,-1104 # 8001faa8 <devsw>
    80003f00:	97ba                	add	a5,a5,a4
    80003f02:	639c                	ld	a5,0(a5)
    80003f04:	cf99                	beqz	a5,80003f22 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003f06:	4505                	li	a0,1
    80003f08:	9782                	jalr	a5
    80003f0a:	892a                	mv	s2,a0
    80003f0c:	b7c1                	j	80003ecc <fileread+0x54>
    panic("fileread");
    80003f0e:	00003517          	auipc	a0,0x3
    80003f12:	7da50513          	add	a0,a0,2010 # 800076e8 <syscalls+0x258>
    80003f16:	849fc0ef          	jal	8000075e <panic>
    return -1;
    80003f1a:	597d                	li	s2,-1
    80003f1c:	bf45                	j	80003ecc <fileread+0x54>
      return -1;
    80003f1e:	597d                	li	s2,-1
    80003f20:	b775                	j	80003ecc <fileread+0x54>
    80003f22:	597d                	li	s2,-1
    80003f24:	b765                	j	80003ecc <fileread+0x54>

0000000080003f26 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f26:	00954783          	lbu	a5,9(a0)
    80003f2a:	10078063          	beqz	a5,8000402a <filewrite+0x104>
{
    80003f2e:	715d                	add	sp,sp,-80
    80003f30:	e486                	sd	ra,72(sp)
    80003f32:	e0a2                	sd	s0,64(sp)
    80003f34:	fc26                	sd	s1,56(sp)
    80003f36:	f84a                	sd	s2,48(sp)
    80003f38:	f44e                	sd	s3,40(sp)
    80003f3a:	f052                	sd	s4,32(sp)
    80003f3c:	ec56                	sd	s5,24(sp)
    80003f3e:	e85a                	sd	s6,16(sp)
    80003f40:	e45e                	sd	s7,8(sp)
    80003f42:	e062                	sd	s8,0(sp)
    80003f44:	0880                	add	s0,sp,80
    80003f46:	892a                	mv	s2,a0
    80003f48:	8b2e                	mv	s6,a1
    80003f4a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f4c:	411c                	lw	a5,0(a0)
    80003f4e:	4705                	li	a4,1
    80003f50:	02e78263          	beq	a5,a4,80003f74 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f54:	470d                	li	a4,3
    80003f56:	02e78363          	beq	a5,a4,80003f7c <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f5a:	4709                	li	a4,2
    80003f5c:	0ce79163          	bne	a5,a4,8000401e <filewrite+0xf8>
    /* and 2 blocks of slop for non-aligned writes. */
    /* this really belongs lower down, since writei() */
    /* might be writing a device like the console. */
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f60:	08c05f63          	blez	a2,80003ffe <filewrite+0xd8>
    int i = 0;
    80003f64:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f66:	6b85                	lui	s7,0x1
    80003f68:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f6c:	6c05                	lui	s8,0x1
    80003f6e:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f72:	a8b5                	j	80003fee <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003f74:	6908                	ld	a0,16(a0)
    80003f76:	1de000ef          	jal	80004154 <pipewrite>
    80003f7a:	a071                	j	80004006 <filewrite+0xe0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f7c:	02451783          	lh	a5,36(a0)
    80003f80:	03079693          	sll	a3,a5,0x30
    80003f84:	92c1                	srl	a3,a3,0x30
    80003f86:	4725                	li	a4,9
    80003f88:	0ad76363          	bltu	a4,a3,8000402e <filewrite+0x108>
    80003f8c:	0792                	sll	a5,a5,0x4
    80003f8e:	0001c717          	auipc	a4,0x1c
    80003f92:	b1a70713          	add	a4,a4,-1254 # 8001faa8 <devsw>
    80003f96:	97ba                	add	a5,a5,a4
    80003f98:	679c                	ld	a5,8(a5)
    80003f9a:	cfc1                	beqz	a5,80004032 <filewrite+0x10c>
    ret = devsw[f->major].write(1, addr, n);
    80003f9c:	4505                	li	a0,1
    80003f9e:	9782                	jalr	a5
    80003fa0:	a09d                	j	80004006 <filewrite+0xe0>
      if(n1 > max)
    80003fa2:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003fa6:	9b9ff0ef          	jal	8000395e <begin_op>
      ilock(f->ip);
    80003faa:	01893503          	ld	a0,24(s2)
    80003fae:	942ff0ef          	jal	800030f0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fb2:	8756                	mv	a4,s5
    80003fb4:	02092683          	lw	a3,32(s2)
    80003fb8:	01698633          	add	a2,s3,s6
    80003fbc:	4585                	li	a1,1
    80003fbe:	01893503          	ld	a0,24(s2)
    80003fc2:	c62ff0ef          	jal	80003424 <writei>
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	00a05763          	blez	a0,80003fd6 <filewrite+0xb0>
        f->off += r;
    80003fcc:	02092783          	lw	a5,32(s2)
    80003fd0:	9fa9                	addw	a5,a5,a0
    80003fd2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fd6:	01893503          	ld	a0,24(s2)
    80003fda:	9c0ff0ef          	jal	8000319a <iunlock>
      end_op();
    80003fde:	9ebff0ef          	jal	800039c8 <end_op>

      if(r != n1){
    80003fe2:	009a9f63          	bne	s5,s1,80004000 <filewrite+0xda>
        /* error from writei */
        break;
      }
      i += r;
    80003fe6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fea:	0149db63          	bge	s3,s4,80004000 <filewrite+0xda>
      int n1 = n - i;
    80003fee:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003ff2:	0004879b          	sext.w	a5,s1
    80003ff6:	fafbd6e3          	bge	s7,a5,80003fa2 <filewrite+0x7c>
    80003ffa:	84e2                	mv	s1,s8
    80003ffc:	b75d                	j	80003fa2 <filewrite+0x7c>
    int i = 0;
    80003ffe:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004000:	033a1b63          	bne	s4,s3,80004036 <filewrite+0x110>
    80004004:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004006:	60a6                	ld	ra,72(sp)
    80004008:	6406                	ld	s0,64(sp)
    8000400a:	74e2                	ld	s1,56(sp)
    8000400c:	7942                	ld	s2,48(sp)
    8000400e:	79a2                	ld	s3,40(sp)
    80004010:	7a02                	ld	s4,32(sp)
    80004012:	6ae2                	ld	s5,24(sp)
    80004014:	6b42                	ld	s6,16(sp)
    80004016:	6ba2                	ld	s7,8(sp)
    80004018:	6c02                	ld	s8,0(sp)
    8000401a:	6161                	add	sp,sp,80
    8000401c:	8082                	ret
    panic("filewrite");
    8000401e:	00003517          	auipc	a0,0x3
    80004022:	6da50513          	add	a0,a0,1754 # 800076f8 <syscalls+0x268>
    80004026:	f38fc0ef          	jal	8000075e <panic>
    return -1;
    8000402a:	557d                	li	a0,-1
}
    8000402c:	8082                	ret
      return -1;
    8000402e:	557d                	li	a0,-1
    80004030:	bfd9                	j	80004006 <filewrite+0xe0>
    80004032:	557d                	li	a0,-1
    80004034:	bfc9                	j	80004006 <filewrite+0xe0>
    ret = (i == n ? n : -1);
    80004036:	557d                	li	a0,-1
    80004038:	b7f9                	j	80004006 <filewrite+0xe0>

000000008000403a <pipealloc>:
  int writeopen;  /* write fd is still open */
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000403a:	7179                	add	sp,sp,-48
    8000403c:	f406                	sd	ra,40(sp)
    8000403e:	f022                	sd	s0,32(sp)
    80004040:	ec26                	sd	s1,24(sp)
    80004042:	e84a                	sd	s2,16(sp)
    80004044:	e44e                	sd	s3,8(sp)
    80004046:	e052                	sd	s4,0(sp)
    80004048:	1800                	add	s0,sp,48
    8000404a:	84aa                	mv	s1,a0
    8000404c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000404e:	0005b023          	sd	zero,0(a1)
    80004052:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004056:	c79ff0ef          	jal	80003cce <filealloc>
    8000405a:	e088                	sd	a0,0(s1)
    8000405c:	cd35                	beqz	a0,800040d8 <pipealloc+0x9e>
    8000405e:	c71ff0ef          	jal	80003cce <filealloc>
    80004062:	00aa3023          	sd	a0,0(s4)
    80004066:	c52d                	beqz	a0,800040d0 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004068:	a69fc0ef          	jal	80000ad0 <kalloc>
    8000406c:	892a                	mv	s2,a0
    8000406e:	cd31                	beqz	a0,800040ca <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80004070:	4985                	li	s3,1
    80004072:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004076:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000407a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000407e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004082:	00003597          	auipc	a1,0x3
    80004086:	68658593          	add	a1,a1,1670 # 80007708 <syscalls+0x278>
    8000408a:	a97fc0ef          	jal	80000b20 <initlock>
  (*f0)->type = FD_PIPE;
    8000408e:	609c                	ld	a5,0(s1)
    80004090:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004094:	609c                	ld	a5,0(s1)
    80004096:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000409a:	609c                	ld	a5,0(s1)
    8000409c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040a0:	609c                	ld	a5,0(s1)
    800040a2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040a6:	000a3783          	ld	a5,0(s4)
    800040aa:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040ae:	000a3783          	ld	a5,0(s4)
    800040b2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040b6:	000a3783          	ld	a5,0(s4)
    800040ba:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040be:	000a3783          	ld	a5,0(s4)
    800040c2:	0127b823          	sd	s2,16(a5)
  return 0;
    800040c6:	4501                	li	a0,0
    800040c8:	a005                	j	800040e8 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040ca:	6088                	ld	a0,0(s1)
    800040cc:	e501                	bnez	a0,800040d4 <pipealloc+0x9a>
    800040ce:	a029                	j	800040d8 <pipealloc+0x9e>
    800040d0:	6088                	ld	a0,0(s1)
    800040d2:	c11d                	beqz	a0,800040f8 <pipealloc+0xbe>
    fileclose(*f0);
    800040d4:	c9fff0ef          	jal	80003d72 <fileclose>
  if(*f1)
    800040d8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040dc:	557d                	li	a0,-1
  if(*f1)
    800040de:	c789                	beqz	a5,800040e8 <pipealloc+0xae>
    fileclose(*f1);
    800040e0:	853e                	mv	a0,a5
    800040e2:	c91ff0ef          	jal	80003d72 <fileclose>
  return -1;
    800040e6:	557d                	li	a0,-1
}
    800040e8:	70a2                	ld	ra,40(sp)
    800040ea:	7402                	ld	s0,32(sp)
    800040ec:	64e2                	ld	s1,24(sp)
    800040ee:	6942                	ld	s2,16(sp)
    800040f0:	69a2                	ld	s3,8(sp)
    800040f2:	6a02                	ld	s4,0(sp)
    800040f4:	6145                	add	sp,sp,48
    800040f6:	8082                	ret
  return -1;
    800040f8:	557d                	li	a0,-1
    800040fa:	b7fd                	j	800040e8 <pipealloc+0xae>

00000000800040fc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800040fc:	1101                	add	sp,sp,-32
    800040fe:	ec06                	sd	ra,24(sp)
    80004100:	e822                	sd	s0,16(sp)
    80004102:	e426                	sd	s1,8(sp)
    80004104:	e04a                	sd	s2,0(sp)
    80004106:	1000                	add	s0,sp,32
    80004108:	84aa                	mv	s1,a0
    8000410a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000410c:	a95fc0ef          	jal	80000ba0 <acquire>
  if(writable){
    80004110:	02090763          	beqz	s2,8000413e <pipeclose+0x42>
    pi->writeopen = 0;
    80004114:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004118:	21848513          	add	a0,s1,536
    8000411c:	d2dfd0ef          	jal	80001e48 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004120:	2204b783          	ld	a5,544(s1)
    80004124:	e785                	bnez	a5,8000414c <pipeclose+0x50>
    release(&pi->lock);
    80004126:	8526                	mv	a0,s1
    80004128:	b11fc0ef          	jal	80000c38 <release>
    kfree((char*)pi);
    8000412c:	8526                	mv	a0,s1
    8000412e:	8c1fc0ef          	jal	800009ee <kfree>
  } else
    release(&pi->lock);
}
    80004132:	60e2                	ld	ra,24(sp)
    80004134:	6442                	ld	s0,16(sp)
    80004136:	64a2                	ld	s1,8(sp)
    80004138:	6902                	ld	s2,0(sp)
    8000413a:	6105                	add	sp,sp,32
    8000413c:	8082                	ret
    pi->readopen = 0;
    8000413e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004142:	21c48513          	add	a0,s1,540
    80004146:	d03fd0ef          	jal	80001e48 <wakeup>
    8000414a:	bfd9                	j	80004120 <pipeclose+0x24>
    release(&pi->lock);
    8000414c:	8526                	mv	a0,s1
    8000414e:	aebfc0ef          	jal	80000c38 <release>
}
    80004152:	b7c5                	j	80004132 <pipeclose+0x36>

0000000080004154 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004154:	711d                	add	sp,sp,-96
    80004156:	ec86                	sd	ra,88(sp)
    80004158:	e8a2                	sd	s0,80(sp)
    8000415a:	e4a6                	sd	s1,72(sp)
    8000415c:	e0ca                	sd	s2,64(sp)
    8000415e:	fc4e                	sd	s3,56(sp)
    80004160:	f852                	sd	s4,48(sp)
    80004162:	f456                	sd	s5,40(sp)
    80004164:	f05a                	sd	s6,32(sp)
    80004166:	ec5e                	sd	s7,24(sp)
    80004168:	e862                	sd	s8,16(sp)
    8000416a:	1080                	add	s0,sp,96
    8000416c:	84aa                	mv	s1,a0
    8000416e:	8aae                	mv	s5,a1
    80004170:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004172:	ebefd0ef          	jal	80001830 <myproc>
    80004176:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004178:	8526                	mv	a0,s1
    8000417a:	a27fc0ef          	jal	80000ba0 <acquire>
  while(i < n){
    8000417e:	09405c63          	blez	s4,80004216 <pipewrite+0xc2>
  int i = 0;
    80004182:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004184:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004186:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000418a:	21c48b93          	add	s7,s1,540
    8000418e:	a81d                	j	800041c4 <pipewrite+0x70>
      release(&pi->lock);
    80004190:	8526                	mv	a0,s1
    80004192:	aa7fc0ef          	jal	80000c38 <release>
      return -1;
    80004196:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004198:	854a                	mv	a0,s2
    8000419a:	60e6                	ld	ra,88(sp)
    8000419c:	6446                	ld	s0,80(sp)
    8000419e:	64a6                	ld	s1,72(sp)
    800041a0:	6906                	ld	s2,64(sp)
    800041a2:	79e2                	ld	s3,56(sp)
    800041a4:	7a42                	ld	s4,48(sp)
    800041a6:	7aa2                	ld	s5,40(sp)
    800041a8:	7b02                	ld	s6,32(sp)
    800041aa:	6be2                	ld	s7,24(sp)
    800041ac:	6c42                	ld	s8,16(sp)
    800041ae:	6125                	add	sp,sp,96
    800041b0:	8082                	ret
      wakeup(&pi->nread);
    800041b2:	8562                	mv	a0,s8
    800041b4:	c95fd0ef          	jal	80001e48 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041b8:	85a6                	mv	a1,s1
    800041ba:	855e                	mv	a0,s7
    800041bc:	c41fd0ef          	jal	80001dfc <sleep>
  while(i < n){
    800041c0:	05495c63          	bge	s2,s4,80004218 <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    800041c4:	2204a783          	lw	a5,544(s1)
    800041c8:	d7e1                	beqz	a5,80004190 <pipewrite+0x3c>
    800041ca:	854e                	mv	a0,s3
    800041cc:	e69fd0ef          	jal	80002034 <killed>
    800041d0:	f161                	bnez	a0,80004190 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ /*DOC: pipewrite-full */
    800041d2:	2184a783          	lw	a5,536(s1)
    800041d6:	21c4a703          	lw	a4,540(s1)
    800041da:	2007879b          	addw	a5,a5,512
    800041de:	fcf70ae3          	beq	a4,a5,800041b2 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041e2:	4685                	li	a3,1
    800041e4:	01590633          	add	a2,s2,s5
    800041e8:	faf40593          	add	a1,s0,-81
    800041ec:	0509b503          	ld	a0,80(s3)
    800041f0:	bb0fd0ef          	jal	800015a0 <copyin>
    800041f4:	03650263          	beq	a0,s6,80004218 <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041f8:	21c4a783          	lw	a5,540(s1)
    800041fc:	0017871b          	addw	a4,a5,1
    80004200:	20e4ae23          	sw	a4,540(s1)
    80004204:	1ff7f793          	and	a5,a5,511
    80004208:	97a6                	add	a5,a5,s1
    8000420a:	faf44703          	lbu	a4,-81(s0)
    8000420e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004212:	2905                	addw	s2,s2,1
    80004214:	b775                	j	800041c0 <pipewrite+0x6c>
  int i = 0;
    80004216:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004218:	21848513          	add	a0,s1,536
    8000421c:	c2dfd0ef          	jal	80001e48 <wakeup>
  release(&pi->lock);
    80004220:	8526                	mv	a0,s1
    80004222:	a17fc0ef          	jal	80000c38 <release>
  return i;
    80004226:	bf8d                	j	80004198 <pipewrite+0x44>

0000000080004228 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004228:	715d                	add	sp,sp,-80
    8000422a:	e486                	sd	ra,72(sp)
    8000422c:	e0a2                	sd	s0,64(sp)
    8000422e:	fc26                	sd	s1,56(sp)
    80004230:	f84a                	sd	s2,48(sp)
    80004232:	f44e                	sd	s3,40(sp)
    80004234:	f052                	sd	s4,32(sp)
    80004236:	ec56                	sd	s5,24(sp)
    80004238:	e85a                	sd	s6,16(sp)
    8000423a:	0880                	add	s0,sp,80
    8000423c:	84aa                	mv	s1,a0
    8000423e:	892e                	mv	s2,a1
    80004240:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004242:	deefd0ef          	jal	80001830 <myproc>
    80004246:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004248:	8526                	mv	a0,s1
    8000424a:	957fc0ef          	jal	80000ba0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    8000424e:	2184a703          	lw	a4,536(s1)
    80004252:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    80004256:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    8000425a:	02f71363          	bne	a4,a5,80004280 <piperead+0x58>
    8000425e:	2244a783          	lw	a5,548(s1)
    80004262:	cf99                	beqz	a5,80004280 <piperead+0x58>
    if(killed(pr)){
    80004264:	8552                	mv	a0,s4
    80004266:	dcffd0ef          	jal	80002034 <killed>
    8000426a:	e149                	bnez	a0,800042ec <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); /*DOC: piperead-sleep */
    8000426c:	85a6                	mv	a1,s1
    8000426e:	854e                	mv	a0,s3
    80004270:	b8dfd0ef          	jal	80001dfc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  /*DOC: pipe-empty */
    80004274:	2184a703          	lw	a4,536(s1)
    80004278:	21c4a783          	lw	a5,540(s1)
    8000427c:	fef701e3          	beq	a4,a5,8000425e <piperead+0x36>
  }
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004280:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004282:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    80004284:	05505263          	blez	s5,800042c8 <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    80004288:	2184a783          	lw	a5,536(s1)
    8000428c:	21c4a703          	lw	a4,540(s1)
    80004290:	02f70c63          	beq	a4,a5,800042c8 <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004294:	0017871b          	addw	a4,a5,1
    80004298:	20e4ac23          	sw	a4,536(s1)
    8000429c:	1ff7f793          	and	a5,a5,511
    800042a0:	97a6                	add	a5,a5,s1
    800042a2:	0187c783          	lbu	a5,24(a5)
    800042a6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042aa:	4685                	li	a3,1
    800042ac:	fbf40613          	add	a2,s0,-65
    800042b0:	85ca                	mv	a1,s2
    800042b2:	050a3503          	ld	a0,80(s4)
    800042b6:	a32fd0ef          	jal	800014e8 <copyout>
    800042ba:	01650763          	beq	a0,s6,800042c8 <piperead+0xa0>
  for(i = 0; i < n; i++){  /*DOC: piperead-copy */
    800042be:	2985                	addw	s3,s3,1
    800042c0:	0905                	add	s2,s2,1
    800042c2:	fd3a93e3          	bne	s5,s3,80004288 <piperead+0x60>
    800042c6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  /*DOC: piperead-wakeup */
    800042c8:	21c48513          	add	a0,s1,540
    800042cc:	b7dfd0ef          	jal	80001e48 <wakeup>
  release(&pi->lock);
    800042d0:	8526                	mv	a0,s1
    800042d2:	967fc0ef          	jal	80000c38 <release>
  return i;
}
    800042d6:	854e                	mv	a0,s3
    800042d8:	60a6                	ld	ra,72(sp)
    800042da:	6406                	ld	s0,64(sp)
    800042dc:	74e2                	ld	s1,56(sp)
    800042de:	7942                	ld	s2,48(sp)
    800042e0:	79a2                	ld	s3,40(sp)
    800042e2:	7a02                	ld	s4,32(sp)
    800042e4:	6ae2                	ld	s5,24(sp)
    800042e6:	6b42                	ld	s6,16(sp)
    800042e8:	6161                	add	sp,sp,80
    800042ea:	8082                	ret
      release(&pi->lock);
    800042ec:	8526                	mv	a0,s1
    800042ee:	94bfc0ef          	jal	80000c38 <release>
      return -1;
    800042f2:	59fd                	li	s3,-1
    800042f4:	b7cd                	j	800042d6 <piperead+0xae>

00000000800042f6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800042f6:	1141                	add	sp,sp,-16
    800042f8:	e422                	sd	s0,8(sp)
    800042fa:	0800                	add	s0,sp,16
    800042fc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800042fe:	8905                	and	a0,a0,1
    80004300:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004302:	8b89                	and	a5,a5,2
    80004304:	c399                	beqz	a5,8000430a <flags2perm+0x14>
      perm |= PTE_W;
    80004306:	00456513          	or	a0,a0,4
    return perm;
}
    8000430a:	6422                	ld	s0,8(sp)
    8000430c:	0141                	add	sp,sp,16
    8000430e:	8082                	ret

0000000080004310 <exec>:

int
exec(char *path, char **argv)
{
    80004310:	df010113          	add	sp,sp,-528
    80004314:	20113423          	sd	ra,520(sp)
    80004318:	20813023          	sd	s0,512(sp)
    8000431c:	ffa6                	sd	s1,504(sp)
    8000431e:	fbca                	sd	s2,496(sp)
    80004320:	f7ce                	sd	s3,488(sp)
    80004322:	f3d2                	sd	s4,480(sp)
    80004324:	efd6                	sd	s5,472(sp)
    80004326:	ebda                	sd	s6,464(sp)
    80004328:	e7de                	sd	s7,456(sp)
    8000432a:	e3e2                	sd	s8,448(sp)
    8000432c:	ff66                	sd	s9,440(sp)
    8000432e:	fb6a                	sd	s10,432(sp)
    80004330:	f76e                	sd	s11,424(sp)
    80004332:	0c00                	add	s0,sp,528
    80004334:	892a                	mv	s2,a0
    80004336:	dea43c23          	sd	a0,-520(s0)
    8000433a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000433e:	cf2fd0ef          	jal	80001830 <myproc>
    80004342:	84aa                	mv	s1,a0

  begin_op();
    80004344:	e1aff0ef          	jal	8000395e <begin_op>

  if((ip = namei(path)) == 0){
    80004348:	854a                	mv	a0,s2
    8000434a:	c58ff0ef          	jal	800037a2 <namei>
    8000434e:	c12d                	beqz	a0,800043b0 <exec+0xa0>
    80004350:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004352:	d9ffe0ef          	jal	800030f0 <ilock>

  /* Check ELF header */
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004356:	04000713          	li	a4,64
    8000435a:	4681                	li	a3,0
    8000435c:	e5040613          	add	a2,s0,-432
    80004360:	4581                	li	a1,0
    80004362:	8552                	mv	a0,s4
    80004364:	fddfe0ef          	jal	80003340 <readi>
    80004368:	04000793          	li	a5,64
    8000436c:	00f51a63          	bne	a0,a5,80004380 <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004370:	e5042703          	lw	a4,-432(s0)
    80004374:	464c47b7          	lui	a5,0x464c4
    80004378:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000437c:	02f70e63          	beq	a4,a5,800043b8 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004380:	8552                	mv	a0,s4
    80004382:	f75fe0ef          	jal	800032f6 <iunlockput>
    end_op();
    80004386:	e42ff0ef          	jal	800039c8 <end_op>
  }
  return -1;
    8000438a:	557d                	li	a0,-1
}
    8000438c:	20813083          	ld	ra,520(sp)
    80004390:	20013403          	ld	s0,512(sp)
    80004394:	74fe                	ld	s1,504(sp)
    80004396:	795e                	ld	s2,496(sp)
    80004398:	79be                	ld	s3,488(sp)
    8000439a:	7a1e                	ld	s4,480(sp)
    8000439c:	6afe                	ld	s5,472(sp)
    8000439e:	6b5e                	ld	s6,464(sp)
    800043a0:	6bbe                	ld	s7,456(sp)
    800043a2:	6c1e                	ld	s8,448(sp)
    800043a4:	7cfa                	ld	s9,440(sp)
    800043a6:	7d5a                	ld	s10,432(sp)
    800043a8:	7dba                	ld	s11,424(sp)
    800043aa:	21010113          	add	sp,sp,528
    800043ae:	8082                	ret
    end_op();
    800043b0:	e18ff0ef          	jal	800039c8 <end_op>
    return -1;
    800043b4:	557d                	li	a0,-1
    800043b6:	bfd9                	j	8000438c <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    800043b8:	8526                	mv	a0,s1
    800043ba:	d1efd0ef          	jal	800018d8 <proc_pagetable>
    800043be:	8b2a                	mv	s6,a0
    800043c0:	d161                	beqz	a0,80004380 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043c2:	e7042d03          	lw	s10,-400(s0)
    800043c6:	e8845783          	lhu	a5,-376(s0)
    800043ca:	0e078863          	beqz	a5,800044ba <exec+0x1aa>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ce:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043d0:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800043d2:	6c85                	lui	s9,0x1
    800043d4:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043d8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800043dc:	6a85                	lui	s5,0x1
    800043de:	a085                	j	8000443e <exec+0x12e>
      panic("loadseg: address should exist");
    800043e0:	00003517          	auipc	a0,0x3
    800043e4:	33050513          	add	a0,a0,816 # 80007710 <syscalls+0x280>
    800043e8:	b76fc0ef          	jal	8000075e <panic>
    if(sz - i < PGSIZE)
    800043ec:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043ee:	8726                	mv	a4,s1
    800043f0:	012c06bb          	addw	a3,s8,s2
    800043f4:	4581                	li	a1,0
    800043f6:	8552                	mv	a0,s4
    800043f8:	f49fe0ef          	jal	80003340 <readi>
    800043fc:	2501                	sext.w	a0,a0
    800043fe:	20a49a63          	bne	s1,a0,80004612 <exec+0x302>
  for(i = 0; i < sz; i += PGSIZE){
    80004402:	012a893b          	addw	s2,s5,s2
    80004406:	03397363          	bgeu	s2,s3,8000442c <exec+0x11c>
    pa = walkaddr(pagetable, va + i);
    8000440a:	02091593          	sll	a1,s2,0x20
    8000440e:	9181                	srl	a1,a1,0x20
    80004410:	95de                	add	a1,a1,s7
    80004412:	855a                	mv	a0,s6
    80004414:	b75fc0ef          	jal	80000f88 <walkaddr>
    80004418:	862a                	mv	a2,a0
    if(pa == 0)
    8000441a:	d179                	beqz	a0,800043e0 <exec+0xd0>
    if(sz - i < PGSIZE)
    8000441c:	412984bb          	subw	s1,s3,s2
    80004420:	0004879b          	sext.w	a5,s1
    80004424:	fcfcf4e3          	bgeu	s9,a5,800043ec <exec+0xdc>
    80004428:	84d6                	mv	s1,s5
    8000442a:	b7c9                	j	800043ec <exec+0xdc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000442c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004430:	2d85                	addw	s11,s11,1
    80004432:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004436:	e8845783          	lhu	a5,-376(s0)
    8000443a:	08fdd163          	bge	s11,a5,800044bc <exec+0x1ac>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000443e:	2d01                	sext.w	s10,s10
    80004440:	03800713          	li	a4,56
    80004444:	86ea                	mv	a3,s10
    80004446:	e1840613          	add	a2,s0,-488
    8000444a:	4581                	li	a1,0
    8000444c:	8552                	mv	a0,s4
    8000444e:	ef3fe0ef          	jal	80003340 <readi>
    80004452:	03800793          	li	a5,56
    80004456:	1af51c63          	bne	a0,a5,8000460e <exec+0x2fe>
    if(ph.type != ELF_PROG_LOAD)
    8000445a:	e1842783          	lw	a5,-488(s0)
    8000445e:	4705                	li	a4,1
    80004460:	fce798e3          	bne	a5,a4,80004430 <exec+0x120>
    if(ph.memsz < ph.filesz)
    80004464:	e4043483          	ld	s1,-448(s0)
    80004468:	e3843783          	ld	a5,-456(s0)
    8000446c:	1af4ec63          	bltu	s1,a5,80004624 <exec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004470:	e2843783          	ld	a5,-472(s0)
    80004474:	94be                	add	s1,s1,a5
    80004476:	1af4ea63          	bltu	s1,a5,8000462a <exec+0x31a>
    if(ph.vaddr % PGSIZE != 0)
    8000447a:	df043703          	ld	a4,-528(s0)
    8000447e:	8ff9                	and	a5,a5,a4
    80004480:	1a079863          	bnez	a5,80004630 <exec+0x320>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004484:	e1c42503          	lw	a0,-484(s0)
    80004488:	e6fff0ef          	jal	800042f6 <flags2perm>
    8000448c:	86aa                	mv	a3,a0
    8000448e:	8626                	mv	a2,s1
    80004490:	85ca                	mv	a1,s2
    80004492:	855a                	mv	a0,s6
    80004494:	e4dfc0ef          	jal	800012e0 <uvmalloc>
    80004498:	e0a43423          	sd	a0,-504(s0)
    8000449c:	18050d63          	beqz	a0,80004636 <exec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044a0:	e2843b83          	ld	s7,-472(s0)
    800044a4:	e2042c03          	lw	s8,-480(s0)
    800044a8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044ac:	00098463          	beqz	s3,800044b4 <exec+0x1a4>
    800044b0:	4901                	li	s2,0
    800044b2:	bfa1                	j	8000440a <exec+0xfa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044b4:	e0843903          	ld	s2,-504(s0)
    800044b8:	bfa5                	j	80004430 <exec+0x120>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044ba:	4901                	li	s2,0
  iunlockput(ip);
    800044bc:	8552                	mv	a0,s4
    800044be:	e39fe0ef          	jal	800032f6 <iunlockput>
  end_op();
    800044c2:	d06ff0ef          	jal	800039c8 <end_op>
  p = myproc();
    800044c6:	b6afd0ef          	jal	80001830 <myproc>
    800044ca:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800044cc:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800044d0:	6985                	lui	s3,0x1
    800044d2:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044d4:	99ca                	add	s3,s3,s2
    800044d6:	77fd                	lui	a5,0xfffff
    800044d8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800044dc:	4691                	li	a3,4
    800044de:	6609                	lui	a2,0x2
    800044e0:	964e                	add	a2,a2,s3
    800044e2:	85ce                	mv	a1,s3
    800044e4:	855a                	mv	a0,s6
    800044e6:	dfbfc0ef          	jal	800012e0 <uvmalloc>
    800044ea:	892a                	mv	s2,a0
    800044ec:	e0a43423          	sd	a0,-504(s0)
    800044f0:	e509                	bnez	a0,800044fa <exec+0x1ea>
  if(pagetable)
    800044f2:	e1343423          	sd	s3,-504(s0)
    800044f6:	4a01                	li	s4,0
    800044f8:	aa29                	j	80004612 <exec+0x302>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800044fa:	75f9                	lui	a1,0xffffe
    800044fc:	95aa                	add	a1,a1,a0
    800044fe:	855a                	mv	a0,s6
    80004500:	fbffc0ef          	jal	800014be <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004504:	7bfd                	lui	s7,0xfffff
    80004506:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004508:	e0043783          	ld	a5,-512(s0)
    8000450c:	6388                	ld	a0,0(a5)
    8000450e:	cd39                	beqz	a0,8000456c <exec+0x25c>
    80004510:	e9040993          	add	s3,s0,-368
    80004514:	f9040c13          	add	s8,s0,-112
    80004518:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000451a:	8d1fc0ef          	jal	80000dea <strlen>
    8000451e:	0015079b          	addw	a5,a0,1
    80004522:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; /* riscv sp must be 16-byte aligned */
    80004526:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    8000452a:	11796963          	bltu	s2,s7,8000463c <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000452e:	e0043d03          	ld	s10,-512(s0)
    80004532:	000d3a03          	ld	s4,0(s10)
    80004536:	8552                	mv	a0,s4
    80004538:	8b3fc0ef          	jal	80000dea <strlen>
    8000453c:	0015069b          	addw	a3,a0,1
    80004540:	8652                	mv	a2,s4
    80004542:	85ca                	mv	a1,s2
    80004544:	855a                	mv	a0,s6
    80004546:	fa3fc0ef          	jal	800014e8 <copyout>
    8000454a:	0e054b63          	bltz	a0,80004640 <exec+0x330>
    ustack[argc] = sp;
    8000454e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004552:	0485                	add	s1,s1,1
    80004554:	008d0793          	add	a5,s10,8
    80004558:	e0f43023          	sd	a5,-512(s0)
    8000455c:	008d3503          	ld	a0,8(s10)
    80004560:	c909                	beqz	a0,80004572 <exec+0x262>
    if(argc >= MAXARG)
    80004562:	09a1                	add	s3,s3,8
    80004564:	fb899be3          	bne	s3,s8,8000451a <exec+0x20a>
  ip = 0;
    80004568:	4a01                	li	s4,0
    8000456a:	a065                	j	80004612 <exec+0x302>
  sp = sz;
    8000456c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004570:	4481                	li	s1,0
  ustack[argc] = 0;
    80004572:	00349793          	sll	a5,s1,0x3
    80004576:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde350>
    8000457a:	97a2                	add	a5,a5,s0
    8000457c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004580:	00148693          	add	a3,s1,1
    80004584:	068e                	sll	a3,a3,0x3
    80004586:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000458a:	ff097913          	and	s2,s2,-16
  sz = sz1;
    8000458e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004592:	f77960e3          	bltu	s2,s7,800044f2 <exec+0x1e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004596:	e9040613          	add	a2,s0,-368
    8000459a:	85ca                	mv	a1,s2
    8000459c:	855a                	mv	a0,s6
    8000459e:	f4bfc0ef          	jal	800014e8 <copyout>
    800045a2:	0a054163          	bltz	a0,80004644 <exec+0x334>
  p->trapframe->a1 = sp;
    800045a6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800045aa:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045ae:	df843783          	ld	a5,-520(s0)
    800045b2:	0007c703          	lbu	a4,0(a5)
    800045b6:	cf11                	beqz	a4,800045d2 <exec+0x2c2>
    800045b8:	0785                	add	a5,a5,1
    if(*s == '/')
    800045ba:	02f00693          	li	a3,47
    800045be:	a039                	j	800045cc <exec+0x2bc>
      last = s+1;
    800045c0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045c4:	0785                	add	a5,a5,1
    800045c6:	fff7c703          	lbu	a4,-1(a5)
    800045ca:	c701                	beqz	a4,800045d2 <exec+0x2c2>
    if(*s == '/')
    800045cc:	fed71ce3          	bne	a4,a3,800045c4 <exec+0x2b4>
    800045d0:	bfc5                	j	800045c0 <exec+0x2b0>
  safestrcpy(p->name, last, sizeof(p->name));
    800045d2:	4641                	li	a2,16
    800045d4:	df843583          	ld	a1,-520(s0)
    800045d8:	158a8513          	add	a0,s5,344
    800045dc:	fdcfc0ef          	jal	80000db8 <safestrcpy>
  oldpagetable = p->pagetable;
    800045e0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800045e4:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800045e8:	e0843783          	ld	a5,-504(s0)
    800045ec:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  /* initial program counter = main */
    800045f0:	058ab783          	ld	a5,88(s5)
    800045f4:	e6843703          	ld	a4,-408(s0)
    800045f8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; /* initial stack pointer */
    800045fa:	058ab783          	ld	a5,88(s5)
    800045fe:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004602:	85e6                	mv	a1,s9
    80004604:	b58fd0ef          	jal	8000195c <proc_freepagetable>
  return argc; /* this ends up in a0, the first argument to main(argc, argv) */
    80004608:	0004851b          	sext.w	a0,s1
    8000460c:	b341                	j	8000438c <exec+0x7c>
    8000460e:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004612:	e0843583          	ld	a1,-504(s0)
    80004616:	855a                	mv	a0,s6
    80004618:	b44fd0ef          	jal	8000195c <proc_freepagetable>
  return -1;
    8000461c:	557d                	li	a0,-1
  if(ip){
    8000461e:	d60a07e3          	beqz	s4,8000438c <exec+0x7c>
    80004622:	bbb9                	j	80004380 <exec+0x70>
    80004624:	e1243423          	sd	s2,-504(s0)
    80004628:	b7ed                	j	80004612 <exec+0x302>
    8000462a:	e1243423          	sd	s2,-504(s0)
    8000462e:	b7d5                	j	80004612 <exec+0x302>
    80004630:	e1243423          	sd	s2,-504(s0)
    80004634:	bff9                	j	80004612 <exec+0x302>
    80004636:	e1243423          	sd	s2,-504(s0)
    8000463a:	bfe1                	j	80004612 <exec+0x302>
  ip = 0;
    8000463c:	4a01                	li	s4,0
    8000463e:	bfd1                	j	80004612 <exec+0x302>
    80004640:	4a01                	li	s4,0
  if(pagetable)
    80004642:	bfc1                	j	80004612 <exec+0x302>
  sz = sz1;
    80004644:	e0843983          	ld	s3,-504(s0)
    80004648:	b56d                	j	800044f2 <exec+0x1e2>

000000008000464a <argfd>:

/* Fetch the nth word-sized system call argument as a file descriptor */
/* and return both the descriptor and the corresponding struct file. */
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000464a:	7179                	add	sp,sp,-48
    8000464c:	f406                	sd	ra,40(sp)
    8000464e:	f022                	sd	s0,32(sp)
    80004650:	ec26                	sd	s1,24(sp)
    80004652:	e84a                	sd	s2,16(sp)
    80004654:	1800                	add	s0,sp,48
    80004656:	892e                	mv	s2,a1
    80004658:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000465a:	fdc40593          	add	a1,s0,-36
    8000465e:	880fe0ef          	jal	800026de <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004662:	fdc42703          	lw	a4,-36(s0)
    80004666:	47bd                	li	a5,15
    80004668:	02e7e963          	bltu	a5,a4,8000469a <argfd+0x50>
    8000466c:	9c4fd0ef          	jal	80001830 <myproc>
    80004670:	fdc42703          	lw	a4,-36(s0)
    80004674:	01a70793          	add	a5,a4,26
    80004678:	078e                	sll	a5,a5,0x3
    8000467a:	953e                	add	a0,a0,a5
    8000467c:	611c                	ld	a5,0(a0)
    8000467e:	c385                	beqz	a5,8000469e <argfd+0x54>
    return -1;
  if(pfd)
    80004680:	00090463          	beqz	s2,80004688 <argfd+0x3e>
    *pfd = fd;
    80004684:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004688:	4501                	li	a0,0
  if(pf)
    8000468a:	c091                	beqz	s1,8000468e <argfd+0x44>
    *pf = f;
    8000468c:	e09c                	sd	a5,0(s1)
}
    8000468e:	70a2                	ld	ra,40(sp)
    80004690:	7402                	ld	s0,32(sp)
    80004692:	64e2                	ld	s1,24(sp)
    80004694:	6942                	ld	s2,16(sp)
    80004696:	6145                	add	sp,sp,48
    80004698:	8082                	ret
    return -1;
    8000469a:	557d                	li	a0,-1
    8000469c:	bfcd                	j	8000468e <argfd+0x44>
    8000469e:	557d                	li	a0,-1
    800046a0:	b7fd                	j	8000468e <argfd+0x44>

00000000800046a2 <fdalloc>:

/* Allocate a file descriptor for the given file. */
/* Takes over file reference from caller on success. */
static int
fdalloc(struct file *f)
{
    800046a2:	1101                	add	sp,sp,-32
    800046a4:	ec06                	sd	ra,24(sp)
    800046a6:	e822                	sd	s0,16(sp)
    800046a8:	e426                	sd	s1,8(sp)
    800046aa:	1000                	add	s0,sp,32
    800046ac:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046ae:	982fd0ef          	jal	80001830 <myproc>
    800046b2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046b4:	0d050793          	add	a5,a0,208
    800046b8:	4501                	li	a0,0
    800046ba:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046bc:	6398                	ld	a4,0(a5)
    800046be:	cb19                	beqz	a4,800046d4 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800046c0:	2505                	addw	a0,a0,1
    800046c2:	07a1                	add	a5,a5,8
    800046c4:	fed51ce3          	bne	a0,a3,800046bc <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046c8:	557d                	li	a0,-1
}
    800046ca:	60e2                	ld	ra,24(sp)
    800046cc:	6442                	ld	s0,16(sp)
    800046ce:	64a2                	ld	s1,8(sp)
    800046d0:	6105                	add	sp,sp,32
    800046d2:	8082                	ret
      p->ofile[fd] = f;
    800046d4:	01a50793          	add	a5,a0,26
    800046d8:	078e                	sll	a5,a5,0x3
    800046da:	963e                	add	a2,a2,a5
    800046dc:	e204                	sd	s1,0(a2)
      return fd;
    800046de:	b7f5                	j	800046ca <fdalloc+0x28>

00000000800046e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046e0:	715d                	add	sp,sp,-80
    800046e2:	e486                	sd	ra,72(sp)
    800046e4:	e0a2                	sd	s0,64(sp)
    800046e6:	fc26                	sd	s1,56(sp)
    800046e8:	f84a                	sd	s2,48(sp)
    800046ea:	f44e                	sd	s3,40(sp)
    800046ec:	f052                	sd	s4,32(sp)
    800046ee:	ec56                	sd	s5,24(sp)
    800046f0:	e85a                	sd	s6,16(sp)
    800046f2:	0880                	add	s0,sp,80
    800046f4:	8b2e                	mv	s6,a1
    800046f6:	89b2                	mv	s3,a2
    800046f8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046fa:	fb040593          	add	a1,s0,-80
    800046fe:	8beff0ef          	jal	800037bc <nameiparent>
    80004702:	84aa                	mv	s1,a0
    80004704:	10050763          	beqz	a0,80004812 <create+0x132>
    return 0;

  ilock(dp);
    80004708:	9e9fe0ef          	jal	800030f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000470c:	4601                	li	a2,0
    8000470e:	fb040593          	add	a1,s0,-80
    80004712:	8526                	mv	a0,s1
    80004714:	e29fe0ef          	jal	8000353c <dirlookup>
    80004718:	8aaa                	mv	s5,a0
    8000471a:	c131                	beqz	a0,8000475e <create+0x7e>
    iunlockput(dp);
    8000471c:	8526                	mv	a0,s1
    8000471e:	bd9fe0ef          	jal	800032f6 <iunlockput>
    ilock(ip);
    80004722:	8556                	mv	a0,s5
    80004724:	9cdfe0ef          	jal	800030f0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004728:	4789                	li	a5,2
    8000472a:	02fb1563          	bne	s6,a5,80004754 <create+0x74>
    8000472e:	044ad783          	lhu	a5,68(s5)
    80004732:	37f9                	addw	a5,a5,-2
    80004734:	17c2                	sll	a5,a5,0x30
    80004736:	93c1                	srl	a5,a5,0x30
    80004738:	4705                	li	a4,1
    8000473a:	00f76d63          	bltu	a4,a5,80004754 <create+0x74>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000473e:	8556                	mv	a0,s5
    80004740:	60a6                	ld	ra,72(sp)
    80004742:	6406                	ld	s0,64(sp)
    80004744:	74e2                	ld	s1,56(sp)
    80004746:	7942                	ld	s2,48(sp)
    80004748:	79a2                	ld	s3,40(sp)
    8000474a:	7a02                	ld	s4,32(sp)
    8000474c:	6ae2                	ld	s5,24(sp)
    8000474e:	6b42                	ld	s6,16(sp)
    80004750:	6161                	add	sp,sp,80
    80004752:	8082                	ret
    iunlockput(ip);
    80004754:	8556                	mv	a0,s5
    80004756:	ba1fe0ef          	jal	800032f6 <iunlockput>
    return 0;
    8000475a:	4a81                	li	s5,0
    8000475c:	b7cd                	j	8000473e <create+0x5e>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000475e:	85da                	mv	a1,s6
    80004760:	4088                	lw	a0,0(s1)
    80004762:	82bfe0ef          	jal	80002f8c <ialloc>
    80004766:	8a2a                	mv	s4,a0
    80004768:	cd0d                	beqz	a0,800047a2 <create+0xc2>
  ilock(ip);
    8000476a:	987fe0ef          	jal	800030f0 <ilock>
  ip->major = major;
    8000476e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004772:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004776:	4905                	li	s2,1
    80004778:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000477c:	8552                	mv	a0,s4
    8000477e:	8bffe0ef          	jal	8000303c <iupdate>
  if(type == T_DIR){  /* Create . and .. entries. */
    80004782:	032b0563          	beq	s6,s2,800047ac <create+0xcc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004786:	004a2603          	lw	a2,4(s4)
    8000478a:	fb040593          	add	a1,s0,-80
    8000478e:	8526                	mv	a0,s1
    80004790:	f79fe0ef          	jal	80003708 <dirlink>
    80004794:	06054363          	bltz	a0,800047fa <create+0x11a>
  iunlockput(dp);
    80004798:	8526                	mv	a0,s1
    8000479a:	b5dfe0ef          	jal	800032f6 <iunlockput>
  return ip;
    8000479e:	8ad2                	mv	s5,s4
    800047a0:	bf79                	j	8000473e <create+0x5e>
    iunlockput(dp);
    800047a2:	8526                	mv	a0,s1
    800047a4:	b53fe0ef          	jal	800032f6 <iunlockput>
    return 0;
    800047a8:	8ad2                	mv	s5,s4
    800047aa:	bf51                	j	8000473e <create+0x5e>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047ac:	004a2603          	lw	a2,4(s4)
    800047b0:	00003597          	auipc	a1,0x3
    800047b4:	f8058593          	add	a1,a1,-128 # 80007730 <syscalls+0x2a0>
    800047b8:	8552                	mv	a0,s4
    800047ba:	f4ffe0ef          	jal	80003708 <dirlink>
    800047be:	02054e63          	bltz	a0,800047fa <create+0x11a>
    800047c2:	40d0                	lw	a2,4(s1)
    800047c4:	00003597          	auipc	a1,0x3
    800047c8:	f7458593          	add	a1,a1,-140 # 80007738 <syscalls+0x2a8>
    800047cc:	8552                	mv	a0,s4
    800047ce:	f3bfe0ef          	jal	80003708 <dirlink>
    800047d2:	02054463          	bltz	a0,800047fa <create+0x11a>
  if(dirlink(dp, name, ip->inum) < 0)
    800047d6:	004a2603          	lw	a2,4(s4)
    800047da:	fb040593          	add	a1,s0,-80
    800047de:	8526                	mv	a0,s1
    800047e0:	f29fe0ef          	jal	80003708 <dirlink>
    800047e4:	00054b63          	bltz	a0,800047fa <create+0x11a>
    dp->nlink++;  /* for ".." */
    800047e8:	04a4d783          	lhu	a5,74(s1)
    800047ec:	2785                	addw	a5,a5,1
    800047ee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047f2:	8526                	mv	a0,s1
    800047f4:	849fe0ef          	jal	8000303c <iupdate>
    800047f8:	b745                	j	80004798 <create+0xb8>
  ip->nlink = 0;
    800047fa:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047fe:	8552                	mv	a0,s4
    80004800:	83dfe0ef          	jal	8000303c <iupdate>
  iunlockput(ip);
    80004804:	8552                	mv	a0,s4
    80004806:	af1fe0ef          	jal	800032f6 <iunlockput>
  iunlockput(dp);
    8000480a:	8526                	mv	a0,s1
    8000480c:	aebfe0ef          	jal	800032f6 <iunlockput>
  return 0;
    80004810:	b73d                	j	8000473e <create+0x5e>
    return 0;
    80004812:	8aaa                	mv	s5,a0
    80004814:	b72d                	j	8000473e <create+0x5e>

0000000080004816 <sys_dup>:
{
    80004816:	7179                	add	sp,sp,-48
    80004818:	f406                	sd	ra,40(sp)
    8000481a:	f022                	sd	s0,32(sp)
    8000481c:	ec26                	sd	s1,24(sp)
    8000481e:	e84a                	sd	s2,16(sp)
    80004820:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004822:	fd840613          	add	a2,s0,-40
    80004826:	4581                	li	a1,0
    80004828:	4501                	li	a0,0
    8000482a:	e21ff0ef          	jal	8000464a <argfd>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004830:	00054f63          	bltz	a0,8000484e <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80004834:	fd843903          	ld	s2,-40(s0)
    80004838:	854a                	mv	a0,s2
    8000483a:	e69ff0ef          	jal	800046a2 <fdalloc>
    8000483e:	84aa                	mv	s1,a0
    return -1;
    80004840:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004842:	00054663          	bltz	a0,8000484e <sys_dup+0x38>
  filedup(f);
    80004846:	854a                	mv	a0,s2
    80004848:	ce4ff0ef          	jal	80003d2c <filedup>
  return fd;
    8000484c:	87a6                	mv	a5,s1
}
    8000484e:	853e                	mv	a0,a5
    80004850:	70a2                	ld	ra,40(sp)
    80004852:	7402                	ld	s0,32(sp)
    80004854:	64e2                	ld	s1,24(sp)
    80004856:	6942                	ld	s2,16(sp)
    80004858:	6145                	add	sp,sp,48
    8000485a:	8082                	ret

000000008000485c <sys_read>:
{
    8000485c:	7179                	add	sp,sp,-48
    8000485e:	f406                	sd	ra,40(sp)
    80004860:	f022                	sd	s0,32(sp)
    80004862:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004864:	fd840593          	add	a1,s0,-40
    80004868:	4505                	li	a0,1
    8000486a:	e91fd0ef          	jal	800026fa <argaddr>
  argint(2, &n);
    8000486e:	fe440593          	add	a1,s0,-28
    80004872:	4509                	li	a0,2
    80004874:	e6bfd0ef          	jal	800026de <argint>
  if(argfd(0, 0, &f) < 0)
    80004878:	fe840613          	add	a2,s0,-24
    8000487c:	4581                	li	a1,0
    8000487e:	4501                	li	a0,0
    80004880:	dcbff0ef          	jal	8000464a <argfd>
    80004884:	87aa                	mv	a5,a0
    return -1;
    80004886:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004888:	0007ca63          	bltz	a5,8000489c <sys_read+0x40>
  return fileread(f, p, n);
    8000488c:	fe442603          	lw	a2,-28(s0)
    80004890:	fd843583          	ld	a1,-40(s0)
    80004894:	fe843503          	ld	a0,-24(s0)
    80004898:	de0ff0ef          	jal	80003e78 <fileread>
}
    8000489c:	70a2                	ld	ra,40(sp)
    8000489e:	7402                	ld	s0,32(sp)
    800048a0:	6145                	add	sp,sp,48
    800048a2:	8082                	ret

00000000800048a4 <sys_write>:
{
    800048a4:	7179                	add	sp,sp,-48
    800048a6:	f406                	sd	ra,40(sp)
    800048a8:	f022                	sd	s0,32(sp)
    800048aa:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800048ac:	fd840593          	add	a1,s0,-40
    800048b0:	4505                	li	a0,1
    800048b2:	e49fd0ef          	jal	800026fa <argaddr>
  argint(2, &n);
    800048b6:	fe440593          	add	a1,s0,-28
    800048ba:	4509                	li	a0,2
    800048bc:	e23fd0ef          	jal	800026de <argint>
  if(argfd(0, 0, &f) < 0)
    800048c0:	fe840613          	add	a2,s0,-24
    800048c4:	4581                	li	a1,0
    800048c6:	4501                	li	a0,0
    800048c8:	d83ff0ef          	jal	8000464a <argfd>
    800048cc:	87aa                	mv	a5,a0
    return -1;
    800048ce:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048d0:	0007ca63          	bltz	a5,800048e4 <sys_write+0x40>
  return filewrite(f, p, n);
    800048d4:	fe442603          	lw	a2,-28(s0)
    800048d8:	fd843583          	ld	a1,-40(s0)
    800048dc:	fe843503          	ld	a0,-24(s0)
    800048e0:	e46ff0ef          	jal	80003f26 <filewrite>
}
    800048e4:	70a2                	ld	ra,40(sp)
    800048e6:	7402                	ld	s0,32(sp)
    800048e8:	6145                	add	sp,sp,48
    800048ea:	8082                	ret

00000000800048ec <sys_close>:
{
    800048ec:	1101                	add	sp,sp,-32
    800048ee:	ec06                	sd	ra,24(sp)
    800048f0:	e822                	sd	s0,16(sp)
    800048f2:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048f4:	fe040613          	add	a2,s0,-32
    800048f8:	fec40593          	add	a1,s0,-20
    800048fc:	4501                	li	a0,0
    800048fe:	d4dff0ef          	jal	8000464a <argfd>
    return -1;
    80004902:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004904:	02054063          	bltz	a0,80004924 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004908:	f29fc0ef          	jal	80001830 <myproc>
    8000490c:	fec42783          	lw	a5,-20(s0)
    80004910:	07e9                	add	a5,a5,26
    80004912:	078e                	sll	a5,a5,0x3
    80004914:	953e                	add	a0,a0,a5
    80004916:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000491a:	fe043503          	ld	a0,-32(s0)
    8000491e:	c54ff0ef          	jal	80003d72 <fileclose>
  return 0;
    80004922:	4781                	li	a5,0
}
    80004924:	853e                	mv	a0,a5
    80004926:	60e2                	ld	ra,24(sp)
    80004928:	6442                	ld	s0,16(sp)
    8000492a:	6105                	add	sp,sp,32
    8000492c:	8082                	ret

000000008000492e <sys_fstat>:
{
    8000492e:	1101                	add	sp,sp,-32
    80004930:	ec06                	sd	ra,24(sp)
    80004932:	e822                	sd	s0,16(sp)
    80004934:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004936:	fe040593          	add	a1,s0,-32
    8000493a:	4505                	li	a0,1
    8000493c:	dbffd0ef          	jal	800026fa <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004940:	fe840613          	add	a2,s0,-24
    80004944:	4581                	li	a1,0
    80004946:	4501                	li	a0,0
    80004948:	d03ff0ef          	jal	8000464a <argfd>
    8000494c:	87aa                	mv	a5,a0
    return -1;
    8000494e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004950:	0007c863          	bltz	a5,80004960 <sys_fstat+0x32>
  return filestat(f, st);
    80004954:	fe043583          	ld	a1,-32(s0)
    80004958:	fe843503          	ld	a0,-24(s0)
    8000495c:	cbeff0ef          	jal	80003e1a <filestat>
}
    80004960:	60e2                	ld	ra,24(sp)
    80004962:	6442                	ld	s0,16(sp)
    80004964:	6105                	add	sp,sp,32
    80004966:	8082                	ret

0000000080004968 <sys_link>:
{
    80004968:	7169                	add	sp,sp,-304
    8000496a:	f606                	sd	ra,296(sp)
    8000496c:	f222                	sd	s0,288(sp)
    8000496e:	ee26                	sd	s1,280(sp)
    80004970:	ea4a                	sd	s2,272(sp)
    80004972:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004974:	08000613          	li	a2,128
    80004978:	ed040593          	add	a1,s0,-304
    8000497c:	4501                	li	a0,0
    8000497e:	d99fd0ef          	jal	80002716 <argstr>
    return -1;
    80004982:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004984:	0c054663          	bltz	a0,80004a50 <sys_link+0xe8>
    80004988:	08000613          	li	a2,128
    8000498c:	f5040593          	add	a1,s0,-176
    80004990:	4505                	li	a0,1
    80004992:	d85fd0ef          	jal	80002716 <argstr>
    return -1;
    80004996:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004998:	0a054c63          	bltz	a0,80004a50 <sys_link+0xe8>
  begin_op();
    8000499c:	fc3fe0ef          	jal	8000395e <begin_op>
  if((ip = namei(old)) == 0){
    800049a0:	ed040513          	add	a0,s0,-304
    800049a4:	dfffe0ef          	jal	800037a2 <namei>
    800049a8:	84aa                	mv	s1,a0
    800049aa:	c525                	beqz	a0,80004a12 <sys_link+0xaa>
  ilock(ip);
    800049ac:	f44fe0ef          	jal	800030f0 <ilock>
  if(ip->type == T_DIR){
    800049b0:	04449703          	lh	a4,68(s1)
    800049b4:	4785                	li	a5,1
    800049b6:	06f70263          	beq	a4,a5,80004a1a <sys_link+0xb2>
  ip->nlink++;
    800049ba:	04a4d783          	lhu	a5,74(s1)
    800049be:	2785                	addw	a5,a5,1
    800049c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049c4:	8526                	mv	a0,s1
    800049c6:	e76fe0ef          	jal	8000303c <iupdate>
  iunlock(ip);
    800049ca:	8526                	mv	a0,s1
    800049cc:	fcefe0ef          	jal	8000319a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049d0:	fd040593          	add	a1,s0,-48
    800049d4:	f5040513          	add	a0,s0,-176
    800049d8:	de5fe0ef          	jal	800037bc <nameiparent>
    800049dc:	892a                	mv	s2,a0
    800049de:	c921                	beqz	a0,80004a2e <sys_link+0xc6>
  ilock(dp);
    800049e0:	f10fe0ef          	jal	800030f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049e4:	00092703          	lw	a4,0(s2)
    800049e8:	409c                	lw	a5,0(s1)
    800049ea:	02f71f63          	bne	a4,a5,80004a28 <sys_link+0xc0>
    800049ee:	40d0                	lw	a2,4(s1)
    800049f0:	fd040593          	add	a1,s0,-48
    800049f4:	854a                	mv	a0,s2
    800049f6:	d13fe0ef          	jal	80003708 <dirlink>
    800049fa:	02054763          	bltz	a0,80004a28 <sys_link+0xc0>
  iunlockput(dp);
    800049fe:	854a                	mv	a0,s2
    80004a00:	8f7fe0ef          	jal	800032f6 <iunlockput>
  iput(ip);
    80004a04:	8526                	mv	a0,s1
    80004a06:	869fe0ef          	jal	8000326e <iput>
  end_op();
    80004a0a:	fbffe0ef          	jal	800039c8 <end_op>
  return 0;
    80004a0e:	4781                	li	a5,0
    80004a10:	a081                	j	80004a50 <sys_link+0xe8>
    end_op();
    80004a12:	fb7fe0ef          	jal	800039c8 <end_op>
    return -1;
    80004a16:	57fd                	li	a5,-1
    80004a18:	a825                	j	80004a50 <sys_link+0xe8>
    iunlockput(ip);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	8dbfe0ef          	jal	800032f6 <iunlockput>
    end_op();
    80004a20:	fa9fe0ef          	jal	800039c8 <end_op>
    return -1;
    80004a24:	57fd                	li	a5,-1
    80004a26:	a02d                	j	80004a50 <sys_link+0xe8>
    iunlockput(dp);
    80004a28:	854a                	mv	a0,s2
    80004a2a:	8cdfe0ef          	jal	800032f6 <iunlockput>
  ilock(ip);
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ec0fe0ef          	jal	800030f0 <ilock>
  ip->nlink--;
    80004a34:	04a4d783          	lhu	a5,74(s1)
    80004a38:	37fd                	addw	a5,a5,-1
    80004a3a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	dfcfe0ef          	jal	8000303c <iupdate>
  iunlockput(ip);
    80004a44:	8526                	mv	a0,s1
    80004a46:	8b1fe0ef          	jal	800032f6 <iunlockput>
  end_op();
    80004a4a:	f7ffe0ef          	jal	800039c8 <end_op>
  return -1;
    80004a4e:	57fd                	li	a5,-1
}
    80004a50:	853e                	mv	a0,a5
    80004a52:	70b2                	ld	ra,296(sp)
    80004a54:	7412                	ld	s0,288(sp)
    80004a56:	64f2                	ld	s1,280(sp)
    80004a58:	6952                	ld	s2,272(sp)
    80004a5a:	6155                	add	sp,sp,304
    80004a5c:	8082                	ret

0000000080004a5e <sys_unlink>:
{
    80004a5e:	7151                	add	sp,sp,-240
    80004a60:	f586                	sd	ra,232(sp)
    80004a62:	f1a2                	sd	s0,224(sp)
    80004a64:	eda6                	sd	s1,216(sp)
    80004a66:	e9ca                	sd	s2,208(sp)
    80004a68:	e5ce                	sd	s3,200(sp)
    80004a6a:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a6c:	08000613          	li	a2,128
    80004a70:	f3040593          	add	a1,s0,-208
    80004a74:	4501                	li	a0,0
    80004a76:	ca1fd0ef          	jal	80002716 <argstr>
    80004a7a:	12054b63          	bltz	a0,80004bb0 <sys_unlink+0x152>
  begin_op();
    80004a7e:	ee1fe0ef          	jal	8000395e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a82:	fb040593          	add	a1,s0,-80
    80004a86:	f3040513          	add	a0,s0,-208
    80004a8a:	d33fe0ef          	jal	800037bc <nameiparent>
    80004a8e:	84aa                	mv	s1,a0
    80004a90:	c54d                	beqz	a0,80004b3a <sys_unlink+0xdc>
  ilock(dp);
    80004a92:	e5efe0ef          	jal	800030f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a96:	00003597          	auipc	a1,0x3
    80004a9a:	c9a58593          	add	a1,a1,-870 # 80007730 <syscalls+0x2a0>
    80004a9e:	fb040513          	add	a0,s0,-80
    80004aa2:	a85fe0ef          	jal	80003526 <namecmp>
    80004aa6:	10050a63          	beqz	a0,80004bba <sys_unlink+0x15c>
    80004aaa:	00003597          	auipc	a1,0x3
    80004aae:	c8e58593          	add	a1,a1,-882 # 80007738 <syscalls+0x2a8>
    80004ab2:	fb040513          	add	a0,s0,-80
    80004ab6:	a71fe0ef          	jal	80003526 <namecmp>
    80004aba:	10050063          	beqz	a0,80004bba <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004abe:	f2c40613          	add	a2,s0,-212
    80004ac2:	fb040593          	add	a1,s0,-80
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	a75fe0ef          	jal	8000353c <dirlookup>
    80004acc:	892a                	mv	s2,a0
    80004ace:	0e050663          	beqz	a0,80004bba <sys_unlink+0x15c>
  ilock(ip);
    80004ad2:	e1efe0ef          	jal	800030f0 <ilock>
  if(ip->nlink < 1)
    80004ad6:	04a91783          	lh	a5,74(s2)
    80004ada:	06f05463          	blez	a5,80004b42 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ade:	04491703          	lh	a4,68(s2)
    80004ae2:	4785                	li	a5,1
    80004ae4:	06f70563          	beq	a4,a5,80004b4e <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004ae8:	4641                	li	a2,16
    80004aea:	4581                	li	a1,0
    80004aec:	fc040513          	add	a0,s0,-64
    80004af0:	984fc0ef          	jal	80000c74 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af4:	4741                	li	a4,16
    80004af6:	f2c42683          	lw	a3,-212(s0)
    80004afa:	fc040613          	add	a2,s0,-64
    80004afe:	4581                	li	a1,0
    80004b00:	8526                	mv	a0,s1
    80004b02:	923fe0ef          	jal	80003424 <writei>
    80004b06:	47c1                	li	a5,16
    80004b08:	08f51563          	bne	a0,a5,80004b92 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004b0c:	04491703          	lh	a4,68(s2)
    80004b10:	4785                	li	a5,1
    80004b12:	08f70663          	beq	a4,a5,80004b9e <sys_unlink+0x140>
  iunlockput(dp);
    80004b16:	8526                	mv	a0,s1
    80004b18:	fdefe0ef          	jal	800032f6 <iunlockput>
  ip->nlink--;
    80004b1c:	04a95783          	lhu	a5,74(s2)
    80004b20:	37fd                	addw	a5,a5,-1
    80004b22:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b26:	854a                	mv	a0,s2
    80004b28:	d14fe0ef          	jal	8000303c <iupdate>
  iunlockput(ip);
    80004b2c:	854a                	mv	a0,s2
    80004b2e:	fc8fe0ef          	jal	800032f6 <iunlockput>
  end_op();
    80004b32:	e97fe0ef          	jal	800039c8 <end_op>
  return 0;
    80004b36:	4501                	li	a0,0
    80004b38:	a079                	j	80004bc6 <sys_unlink+0x168>
    end_op();
    80004b3a:	e8ffe0ef          	jal	800039c8 <end_op>
    return -1;
    80004b3e:	557d                	li	a0,-1
    80004b40:	a059                	j	80004bc6 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004b42:	00003517          	auipc	a0,0x3
    80004b46:	bfe50513          	add	a0,a0,-1026 # 80007740 <syscalls+0x2b0>
    80004b4a:	c15fb0ef          	jal	8000075e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b4e:	04c92703          	lw	a4,76(s2)
    80004b52:	02000793          	li	a5,32
    80004b56:	f8e7f9e3          	bgeu	a5,a4,80004ae8 <sys_unlink+0x8a>
    80004b5a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b5e:	4741                	li	a4,16
    80004b60:	86ce                	mv	a3,s3
    80004b62:	f1840613          	add	a2,s0,-232
    80004b66:	4581                	li	a1,0
    80004b68:	854a                	mv	a0,s2
    80004b6a:	fd6fe0ef          	jal	80003340 <readi>
    80004b6e:	47c1                	li	a5,16
    80004b70:	00f51b63          	bne	a0,a5,80004b86 <sys_unlink+0x128>
    if(de.inum != 0)
    80004b74:	f1845783          	lhu	a5,-232(s0)
    80004b78:	ef95                	bnez	a5,80004bb4 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b7a:	29c1                	addw	s3,s3,16
    80004b7c:	04c92783          	lw	a5,76(s2)
    80004b80:	fcf9efe3          	bltu	s3,a5,80004b5e <sys_unlink+0x100>
    80004b84:	b795                	j	80004ae8 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004b86:	00003517          	auipc	a0,0x3
    80004b8a:	bd250513          	add	a0,a0,-1070 # 80007758 <syscalls+0x2c8>
    80004b8e:	bd1fb0ef          	jal	8000075e <panic>
    panic("unlink: writei");
    80004b92:	00003517          	auipc	a0,0x3
    80004b96:	bde50513          	add	a0,a0,-1058 # 80007770 <syscalls+0x2e0>
    80004b9a:	bc5fb0ef          	jal	8000075e <panic>
    dp->nlink--;
    80004b9e:	04a4d783          	lhu	a5,74(s1)
    80004ba2:	37fd                	addw	a5,a5,-1
    80004ba4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ba8:	8526                	mv	a0,s1
    80004baa:	c92fe0ef          	jal	8000303c <iupdate>
    80004bae:	b7a5                	j	80004b16 <sys_unlink+0xb8>
    return -1;
    80004bb0:	557d                	li	a0,-1
    80004bb2:	a811                	j	80004bc6 <sys_unlink+0x168>
    iunlockput(ip);
    80004bb4:	854a                	mv	a0,s2
    80004bb6:	f40fe0ef          	jal	800032f6 <iunlockput>
  iunlockput(dp);
    80004bba:	8526                	mv	a0,s1
    80004bbc:	f3afe0ef          	jal	800032f6 <iunlockput>
  end_op();
    80004bc0:	e09fe0ef          	jal	800039c8 <end_op>
  return -1;
    80004bc4:	557d                	li	a0,-1
}
    80004bc6:	70ae                	ld	ra,232(sp)
    80004bc8:	740e                	ld	s0,224(sp)
    80004bca:	64ee                	ld	s1,216(sp)
    80004bcc:	694e                	ld	s2,208(sp)
    80004bce:	69ae                	ld	s3,200(sp)
    80004bd0:	616d                	add	sp,sp,240
    80004bd2:	8082                	ret

0000000080004bd4 <sys_open>:

uint64
sys_open(void)
{
    80004bd4:	7131                	add	sp,sp,-192
    80004bd6:	fd06                	sd	ra,184(sp)
    80004bd8:	f922                	sd	s0,176(sp)
    80004bda:	f526                	sd	s1,168(sp)
    80004bdc:	f14a                	sd	s2,160(sp)
    80004bde:	ed4e                	sd	s3,152(sp)
    80004be0:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004be2:	f4c40593          	add	a1,s0,-180
    80004be6:	4505                	li	a0,1
    80004be8:	af7fd0ef          	jal	800026de <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bec:	08000613          	li	a2,128
    80004bf0:	f5040593          	add	a1,s0,-176
    80004bf4:	4501                	li	a0,0
    80004bf6:	b21fd0ef          	jal	80002716 <argstr>
    80004bfa:	87aa                	mv	a5,a0
    return -1;
    80004bfc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bfe:	0807cc63          	bltz	a5,80004c96 <sys_open+0xc2>

  begin_op();
    80004c02:	d5dfe0ef          	jal	8000395e <begin_op>

  if(omode & O_CREATE){
    80004c06:	f4c42783          	lw	a5,-180(s0)
    80004c0a:	2007f793          	and	a5,a5,512
    80004c0e:	cfd9                	beqz	a5,80004cac <sys_open+0xd8>
    ip = create(path, T_FILE, 0, 0);
    80004c10:	4681                	li	a3,0
    80004c12:	4601                	li	a2,0
    80004c14:	4589                	li	a1,2
    80004c16:	f5040513          	add	a0,s0,-176
    80004c1a:	ac7ff0ef          	jal	800046e0 <create>
    80004c1e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c20:	c151                	beqz	a0,80004ca4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c22:	04449703          	lh	a4,68(s1)
    80004c26:	478d                	li	a5,3
    80004c28:	00f71763          	bne	a4,a5,80004c36 <sys_open+0x62>
    80004c2c:	0464d703          	lhu	a4,70(s1)
    80004c30:	47a5                	li	a5,9
    80004c32:	0ae7e863          	bltu	a5,a4,80004ce2 <sys_open+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c36:	898ff0ef          	jal	80003cce <filealloc>
    80004c3a:	892a                	mv	s2,a0
    80004c3c:	cd4d                	beqz	a0,80004cf6 <sys_open+0x122>
    80004c3e:	a65ff0ef          	jal	800046a2 <fdalloc>
    80004c42:	89aa                	mv	s3,a0
    80004c44:	0a054663          	bltz	a0,80004cf0 <sys_open+0x11c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c48:	04449703          	lh	a4,68(s1)
    80004c4c:	478d                	li	a5,3
    80004c4e:	0af70b63          	beq	a4,a5,80004d04 <sys_open+0x130>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c52:	4789                	li	a5,2
    80004c54:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c58:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c5c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c60:	f4c42783          	lw	a5,-180(s0)
    80004c64:	0017c713          	xor	a4,a5,1
    80004c68:	8b05                	and	a4,a4,1
    80004c6a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c6e:	0037f713          	and	a4,a5,3
    80004c72:	00e03733          	snez	a4,a4
    80004c76:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c7a:	4007f793          	and	a5,a5,1024
    80004c7e:	c791                	beqz	a5,80004c8a <sys_open+0xb6>
    80004c80:	04449703          	lh	a4,68(s1)
    80004c84:	4789                	li	a5,2
    80004c86:	08f70663          	beq	a4,a5,80004d12 <sys_open+0x13e>
    itrunc(ip);
  }

  iunlock(ip);
    80004c8a:	8526                	mv	a0,s1
    80004c8c:	d0efe0ef          	jal	8000319a <iunlock>
  end_op();
    80004c90:	d39fe0ef          	jal	800039c8 <end_op>

  return fd;
    80004c94:	854e                	mv	a0,s3
}
    80004c96:	70ea                	ld	ra,184(sp)
    80004c98:	744a                	ld	s0,176(sp)
    80004c9a:	74aa                	ld	s1,168(sp)
    80004c9c:	790a                	ld	s2,160(sp)
    80004c9e:	69ea                	ld	s3,152(sp)
    80004ca0:	6129                	add	sp,sp,192
    80004ca2:	8082                	ret
      end_op();
    80004ca4:	d25fe0ef          	jal	800039c8 <end_op>
      return -1;
    80004ca8:	557d                	li	a0,-1
    80004caa:	b7f5                	j	80004c96 <sys_open+0xc2>
    if((ip = namei(path)) == 0){
    80004cac:	f5040513          	add	a0,s0,-176
    80004cb0:	af3fe0ef          	jal	800037a2 <namei>
    80004cb4:	84aa                	mv	s1,a0
    80004cb6:	c115                	beqz	a0,80004cda <sys_open+0x106>
    ilock(ip);
    80004cb8:	c38fe0ef          	jal	800030f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cbc:	04449703          	lh	a4,68(s1)
    80004cc0:	4785                	li	a5,1
    80004cc2:	f6f710e3          	bne	a4,a5,80004c22 <sys_open+0x4e>
    80004cc6:	f4c42783          	lw	a5,-180(s0)
    80004cca:	d7b5                	beqz	a5,80004c36 <sys_open+0x62>
      iunlockput(ip);
    80004ccc:	8526                	mv	a0,s1
    80004cce:	e28fe0ef          	jal	800032f6 <iunlockput>
      end_op();
    80004cd2:	cf7fe0ef          	jal	800039c8 <end_op>
      return -1;
    80004cd6:	557d                	li	a0,-1
    80004cd8:	bf7d                	j	80004c96 <sys_open+0xc2>
      end_op();
    80004cda:	ceffe0ef          	jal	800039c8 <end_op>
      return -1;
    80004cde:	557d                	li	a0,-1
    80004ce0:	bf5d                	j	80004c96 <sys_open+0xc2>
    iunlockput(ip);
    80004ce2:	8526                	mv	a0,s1
    80004ce4:	e12fe0ef          	jal	800032f6 <iunlockput>
    end_op();
    80004ce8:	ce1fe0ef          	jal	800039c8 <end_op>
    return -1;
    80004cec:	557d                	li	a0,-1
    80004cee:	b765                	j	80004c96 <sys_open+0xc2>
      fileclose(f);
    80004cf0:	854a                	mv	a0,s2
    80004cf2:	880ff0ef          	jal	80003d72 <fileclose>
    iunlockput(ip);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	dfefe0ef          	jal	800032f6 <iunlockput>
    end_op();
    80004cfc:	ccdfe0ef          	jal	800039c8 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	bf51                	j	80004c96 <sys_open+0xc2>
    f->type = FD_DEVICE;
    80004d04:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d08:	04649783          	lh	a5,70(s1)
    80004d0c:	02f91223          	sh	a5,36(s2)
    80004d10:	b7b1                	j	80004c5c <sys_open+0x88>
    itrunc(ip);
    80004d12:	8526                	mv	a0,s1
    80004d14:	cc6fe0ef          	jal	800031da <itrunc>
    80004d18:	bf8d                	j	80004c8a <sys_open+0xb6>

0000000080004d1a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d1a:	7175                	add	sp,sp,-144
    80004d1c:	e506                	sd	ra,136(sp)
    80004d1e:	e122                	sd	s0,128(sp)
    80004d20:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d22:	c3dfe0ef          	jal	8000395e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d26:	08000613          	li	a2,128
    80004d2a:	f7040593          	add	a1,s0,-144
    80004d2e:	4501                	li	a0,0
    80004d30:	9e7fd0ef          	jal	80002716 <argstr>
    80004d34:	02054363          	bltz	a0,80004d5a <sys_mkdir+0x40>
    80004d38:	4681                	li	a3,0
    80004d3a:	4601                	li	a2,0
    80004d3c:	4585                	li	a1,1
    80004d3e:	f7040513          	add	a0,s0,-144
    80004d42:	99fff0ef          	jal	800046e0 <create>
    80004d46:	c911                	beqz	a0,80004d5a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d48:	daefe0ef          	jal	800032f6 <iunlockput>
  end_op();
    80004d4c:	c7dfe0ef          	jal	800039c8 <end_op>
  return 0;
    80004d50:	4501                	li	a0,0
}
    80004d52:	60aa                	ld	ra,136(sp)
    80004d54:	640a                	ld	s0,128(sp)
    80004d56:	6149                	add	sp,sp,144
    80004d58:	8082                	ret
    end_op();
    80004d5a:	c6ffe0ef          	jal	800039c8 <end_op>
    return -1;
    80004d5e:	557d                	li	a0,-1
    80004d60:	bfcd                	j	80004d52 <sys_mkdir+0x38>

0000000080004d62 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d62:	7135                	add	sp,sp,-160
    80004d64:	ed06                	sd	ra,152(sp)
    80004d66:	e922                	sd	s0,144(sp)
    80004d68:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d6a:	bf5fe0ef          	jal	8000395e <begin_op>
  argint(1, &major);
    80004d6e:	f6c40593          	add	a1,s0,-148
    80004d72:	4505                	li	a0,1
    80004d74:	96bfd0ef          	jal	800026de <argint>
  argint(2, &minor);
    80004d78:	f6840593          	add	a1,s0,-152
    80004d7c:	4509                	li	a0,2
    80004d7e:	961fd0ef          	jal	800026de <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d82:	08000613          	li	a2,128
    80004d86:	f7040593          	add	a1,s0,-144
    80004d8a:	4501                	li	a0,0
    80004d8c:	98bfd0ef          	jal	80002716 <argstr>
    80004d90:	02054563          	bltz	a0,80004dba <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d94:	f6841683          	lh	a3,-152(s0)
    80004d98:	f6c41603          	lh	a2,-148(s0)
    80004d9c:	458d                	li	a1,3
    80004d9e:	f7040513          	add	a0,s0,-144
    80004da2:	93fff0ef          	jal	800046e0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004da6:	c911                	beqz	a0,80004dba <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004da8:	d4efe0ef          	jal	800032f6 <iunlockput>
  end_op();
    80004dac:	c1dfe0ef          	jal	800039c8 <end_op>
  return 0;
    80004db0:	4501                	li	a0,0
}
    80004db2:	60ea                	ld	ra,152(sp)
    80004db4:	644a                	ld	s0,144(sp)
    80004db6:	610d                	add	sp,sp,160
    80004db8:	8082                	ret
    end_op();
    80004dba:	c0ffe0ef          	jal	800039c8 <end_op>
    return -1;
    80004dbe:	557d                	li	a0,-1
    80004dc0:	bfcd                	j	80004db2 <sys_mknod+0x50>

0000000080004dc2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dc2:	7135                	add	sp,sp,-160
    80004dc4:	ed06                	sd	ra,152(sp)
    80004dc6:	e922                	sd	s0,144(sp)
    80004dc8:	e526                	sd	s1,136(sp)
    80004dca:	e14a                	sd	s2,128(sp)
    80004dcc:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dce:	a63fc0ef          	jal	80001830 <myproc>
    80004dd2:	892a                	mv	s2,a0
  
  begin_op();
    80004dd4:	b8bfe0ef          	jal	8000395e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dd8:	08000613          	li	a2,128
    80004ddc:	f6040593          	add	a1,s0,-160
    80004de0:	4501                	li	a0,0
    80004de2:	935fd0ef          	jal	80002716 <argstr>
    80004de6:	04054163          	bltz	a0,80004e28 <sys_chdir+0x66>
    80004dea:	f6040513          	add	a0,s0,-160
    80004dee:	9b5fe0ef          	jal	800037a2 <namei>
    80004df2:	84aa                	mv	s1,a0
    80004df4:	c915                	beqz	a0,80004e28 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004df6:	afafe0ef          	jal	800030f0 <ilock>
  if(ip->type != T_DIR){
    80004dfa:	04449703          	lh	a4,68(s1)
    80004dfe:	4785                	li	a5,1
    80004e00:	02f71863          	bne	a4,a5,80004e30 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e04:	8526                	mv	a0,s1
    80004e06:	b94fe0ef          	jal	8000319a <iunlock>
  iput(p->cwd);
    80004e0a:	15093503          	ld	a0,336(s2)
    80004e0e:	c60fe0ef          	jal	8000326e <iput>
  end_op();
    80004e12:	bb7fe0ef          	jal	800039c8 <end_op>
  p->cwd = ip;
    80004e16:	14993823          	sd	s1,336(s2)
  return 0;
    80004e1a:	4501                	li	a0,0
}
    80004e1c:	60ea                	ld	ra,152(sp)
    80004e1e:	644a                	ld	s0,144(sp)
    80004e20:	64aa                	ld	s1,136(sp)
    80004e22:	690a                	ld	s2,128(sp)
    80004e24:	610d                	add	sp,sp,160
    80004e26:	8082                	ret
    end_op();
    80004e28:	ba1fe0ef          	jal	800039c8 <end_op>
    return -1;
    80004e2c:	557d                	li	a0,-1
    80004e2e:	b7fd                	j	80004e1c <sys_chdir+0x5a>
    iunlockput(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	cc4fe0ef          	jal	800032f6 <iunlockput>
    end_op();
    80004e36:	b93fe0ef          	jal	800039c8 <end_op>
    return -1;
    80004e3a:	557d                	li	a0,-1
    80004e3c:	b7c5                	j	80004e1c <sys_chdir+0x5a>

0000000080004e3e <sys_exec>:

uint64
sys_exec(void)
{
    80004e3e:	7121                	add	sp,sp,-448
    80004e40:	ff06                	sd	ra,440(sp)
    80004e42:	fb22                	sd	s0,432(sp)
    80004e44:	f726                	sd	s1,424(sp)
    80004e46:	f34a                	sd	s2,416(sp)
    80004e48:	ef4e                	sd	s3,408(sp)
    80004e4a:	eb52                	sd	s4,400(sp)
    80004e4c:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e4e:	e4840593          	add	a1,s0,-440
    80004e52:	4505                	li	a0,1
    80004e54:	8a7fd0ef          	jal	800026fa <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e58:	08000613          	li	a2,128
    80004e5c:	f5040593          	add	a1,s0,-176
    80004e60:	4501                	li	a0,0
    80004e62:	8b5fd0ef          	jal	80002716 <argstr>
    80004e66:	87aa                	mv	a5,a0
    return -1;
    80004e68:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e6a:	0a07c463          	bltz	a5,80004f12 <sys_exec+0xd4>
  }
  memset(argv, 0, sizeof(argv));
    80004e6e:	10000613          	li	a2,256
    80004e72:	4581                	li	a1,0
    80004e74:	e5040513          	add	a0,s0,-432
    80004e78:	dfdfb0ef          	jal	80000c74 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e7c:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e80:	89a6                	mv	s3,s1
    80004e82:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e84:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e88:	00391513          	sll	a0,s2,0x3
    80004e8c:	e4040593          	add	a1,s0,-448
    80004e90:	e4843783          	ld	a5,-440(s0)
    80004e94:	953e                	add	a0,a0,a5
    80004e96:	fbefd0ef          	jal	80002654 <fetchaddr>
    80004e9a:	02054663          	bltz	a0,80004ec6 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004e9e:	e4043783          	ld	a5,-448(s0)
    80004ea2:	cf8d                	beqz	a5,80004edc <sys_exec+0x9e>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ea4:	c2dfb0ef          	jal	80000ad0 <kalloc>
    80004ea8:	85aa                	mv	a1,a0
    80004eaa:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004eae:	cd01                	beqz	a0,80004ec6 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eb0:	6605                	lui	a2,0x1
    80004eb2:	e4043503          	ld	a0,-448(s0)
    80004eb6:	fe8fd0ef          	jal	8000269e <fetchstr>
    80004eba:	00054663          	bltz	a0,80004ec6 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004ebe:	0905                	add	s2,s2,1
    80004ec0:	09a1                	add	s3,s3,8
    80004ec2:	fd4913e3          	bne	s2,s4,80004e88 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ec6:	f5040913          	add	s2,s0,-176
    80004eca:	6088                	ld	a0,0(s1)
    80004ecc:	c131                	beqz	a0,80004f10 <sys_exec+0xd2>
    kfree(argv[i]);
    80004ece:	b21fb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ed2:	04a1                	add	s1,s1,8
    80004ed4:	ff249be3          	bne	s1,s2,80004eca <sys_exec+0x8c>
  return -1;
    80004ed8:	557d                	li	a0,-1
    80004eda:	a825                	j	80004f12 <sys_exec+0xd4>
      argv[i] = 0;
    80004edc:	0009079b          	sext.w	a5,s2
    80004ee0:	078e                	sll	a5,a5,0x3
    80004ee2:	fd078793          	add	a5,a5,-48
    80004ee6:	97a2                	add	a5,a5,s0
    80004ee8:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004eec:	e5040593          	add	a1,s0,-432
    80004ef0:	f5040513          	add	a0,s0,-176
    80004ef4:	c1cff0ef          	jal	80004310 <exec>
    80004ef8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004efa:	f5040993          	add	s3,s0,-176
    80004efe:	6088                	ld	a0,0(s1)
    80004f00:	c511                	beqz	a0,80004f0c <sys_exec+0xce>
    kfree(argv[i]);
    80004f02:	aedfb0ef          	jal	800009ee <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f06:	04a1                	add	s1,s1,8
    80004f08:	ff349be3          	bne	s1,s3,80004efe <sys_exec+0xc0>
  return ret;
    80004f0c:	854a                	mv	a0,s2
    80004f0e:	a011                	j	80004f12 <sys_exec+0xd4>
  return -1;
    80004f10:	557d                	li	a0,-1
}
    80004f12:	70fa                	ld	ra,440(sp)
    80004f14:	745a                	ld	s0,432(sp)
    80004f16:	74ba                	ld	s1,424(sp)
    80004f18:	791a                	ld	s2,416(sp)
    80004f1a:	69fa                	ld	s3,408(sp)
    80004f1c:	6a5a                	ld	s4,400(sp)
    80004f1e:	6139                	add	sp,sp,448
    80004f20:	8082                	ret

0000000080004f22 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f22:	7139                	add	sp,sp,-64
    80004f24:	fc06                	sd	ra,56(sp)
    80004f26:	f822                	sd	s0,48(sp)
    80004f28:	f426                	sd	s1,40(sp)
    80004f2a:	0080                	add	s0,sp,64
  uint64 fdarray; /* user pointer to array of two integers */
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f2c:	905fc0ef          	jal	80001830 <myproc>
    80004f30:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f32:	fd840593          	add	a1,s0,-40
    80004f36:	4501                	li	a0,0
    80004f38:	fc2fd0ef          	jal	800026fa <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f3c:	fc840593          	add	a1,s0,-56
    80004f40:	fd040513          	add	a0,s0,-48
    80004f44:	8f6ff0ef          	jal	8000403a <pipealloc>
    return -1;
    80004f48:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f4a:	0a054463          	bltz	a0,80004ff2 <sys_pipe+0xd0>
  fd0 = -1;
    80004f4e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f52:	fd043503          	ld	a0,-48(s0)
    80004f56:	f4cff0ef          	jal	800046a2 <fdalloc>
    80004f5a:	fca42223          	sw	a0,-60(s0)
    80004f5e:	08054163          	bltz	a0,80004fe0 <sys_pipe+0xbe>
    80004f62:	fc843503          	ld	a0,-56(s0)
    80004f66:	f3cff0ef          	jal	800046a2 <fdalloc>
    80004f6a:	fca42023          	sw	a0,-64(s0)
    80004f6e:	06054063          	bltz	a0,80004fce <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f72:	4691                	li	a3,4
    80004f74:	fc440613          	add	a2,s0,-60
    80004f78:	fd843583          	ld	a1,-40(s0)
    80004f7c:	68a8                	ld	a0,80(s1)
    80004f7e:	d6afc0ef          	jal	800014e8 <copyout>
    80004f82:	00054e63          	bltz	a0,80004f9e <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f86:	4691                	li	a3,4
    80004f88:	fc040613          	add	a2,s0,-64
    80004f8c:	fd843583          	ld	a1,-40(s0)
    80004f90:	0591                	add	a1,a1,4
    80004f92:	68a8                	ld	a0,80(s1)
    80004f94:	d54fc0ef          	jal	800014e8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f98:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f9a:	04055c63          	bgez	a0,80004ff2 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004f9e:	fc442783          	lw	a5,-60(s0)
    80004fa2:	07e9                	add	a5,a5,26
    80004fa4:	078e                	sll	a5,a5,0x3
    80004fa6:	97a6                	add	a5,a5,s1
    80004fa8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fac:	fc042783          	lw	a5,-64(s0)
    80004fb0:	07e9                	add	a5,a5,26
    80004fb2:	078e                	sll	a5,a5,0x3
    80004fb4:	94be                	add	s1,s1,a5
    80004fb6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fba:	fd043503          	ld	a0,-48(s0)
    80004fbe:	db5fe0ef          	jal	80003d72 <fileclose>
    fileclose(wf);
    80004fc2:	fc843503          	ld	a0,-56(s0)
    80004fc6:	dadfe0ef          	jal	80003d72 <fileclose>
    return -1;
    80004fca:	57fd                	li	a5,-1
    80004fcc:	a01d                	j	80004ff2 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004fce:	fc442783          	lw	a5,-60(s0)
    80004fd2:	0007c763          	bltz	a5,80004fe0 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004fd6:	07e9                	add	a5,a5,26
    80004fd8:	078e                	sll	a5,a5,0x3
    80004fda:	97a6                	add	a5,a5,s1
    80004fdc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004fe0:	fd043503          	ld	a0,-48(s0)
    80004fe4:	d8ffe0ef          	jal	80003d72 <fileclose>
    fileclose(wf);
    80004fe8:	fc843503          	ld	a0,-56(s0)
    80004fec:	d87fe0ef          	jal	80003d72 <fileclose>
    return -1;
    80004ff0:	57fd                	li	a5,-1
}
    80004ff2:	853e                	mv	a0,a5
    80004ff4:	70e2                	ld	ra,56(sp)
    80004ff6:	7442                	ld	s0,48(sp)
    80004ff8:	74a2                	ld	s1,40(sp)
    80004ffa:	6121                	add	sp,sp,64
    80004ffc:	8082                	ret
	...

0000000080005000 <kernelvec>:
    80005000:	7111                	add	sp,sp,-256
    80005002:	e006                	sd	ra,0(sp)
    80005004:	e40a                	sd	sp,8(sp)
    80005006:	e80e                	sd	gp,16(sp)
    80005008:	ec12                	sd	tp,24(sp)
    8000500a:	f016                	sd	t0,32(sp)
    8000500c:	f41a                	sd	t1,40(sp)
    8000500e:	f81e                	sd	t2,48(sp)
    80005010:	e4aa                	sd	a0,72(sp)
    80005012:	e8ae                	sd	a1,80(sp)
    80005014:	ecb2                	sd	a2,88(sp)
    80005016:	f0b6                	sd	a3,96(sp)
    80005018:	f4ba                	sd	a4,104(sp)
    8000501a:	f8be                	sd	a5,112(sp)
    8000501c:	fcc2                	sd	a6,120(sp)
    8000501e:	e146                	sd	a7,128(sp)
    80005020:	edf2                	sd	t3,216(sp)
    80005022:	f1f6                	sd	t4,224(sp)
    80005024:	f5fa                	sd	t5,232(sp)
    80005026:	f9fe                	sd	t6,240(sp)
    80005028:	d3cfd0ef          	jal	80002564 <kerneltrap>
    8000502c:	6082                	ld	ra,0(sp)
    8000502e:	6122                	ld	sp,8(sp)
    80005030:	61c2                	ld	gp,16(sp)
    80005032:	7282                	ld	t0,32(sp)
    80005034:	7322                	ld	t1,40(sp)
    80005036:	73c2                	ld	t2,48(sp)
    80005038:	6526                	ld	a0,72(sp)
    8000503a:	65c6                	ld	a1,80(sp)
    8000503c:	6666                	ld	a2,88(sp)
    8000503e:	7686                	ld	a3,96(sp)
    80005040:	7726                	ld	a4,104(sp)
    80005042:	77c6                	ld	a5,112(sp)
    80005044:	7866                	ld	a6,120(sp)
    80005046:	688a                	ld	a7,128(sp)
    80005048:	6e6e                	ld	t3,216(sp)
    8000504a:	7e8e                	ld	t4,224(sp)
    8000504c:	7f2e                	ld	t5,232(sp)
    8000504e:	7fce                	ld	t6,240(sp)
    80005050:	6111                	add	sp,sp,256
    80005052:	10200073          	sret
	...

000000008000505e <plicinit>:
/* the riscv Platform Level Interrupt Controller (PLIC). */
/* */

void
plicinit(void)
{
    8000505e:	1141                	add	sp,sp,-16
    80005060:	e422                	sd	s0,8(sp)
    80005062:	0800                	add	s0,sp,16
  /* set desired IRQ priorities non-zero (otherwise disabled). */
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005064:	0c0007b7          	lui	a5,0xc000
    80005068:	4705                	li	a4,1
    8000506a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000506c:	c3d8                	sw	a4,4(a5)
}
    8000506e:	6422                	ld	s0,8(sp)
    80005070:	0141                	add	sp,sp,16
    80005072:	8082                	ret

0000000080005074 <plicinithart>:

void
plicinithart(void)
{
    80005074:	1141                	add	sp,sp,-16
    80005076:	e406                	sd	ra,8(sp)
    80005078:	e022                	sd	s0,0(sp)
    8000507a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000507c:	f88fc0ef          	jal	80001804 <cpuid>
  
  /* set enable bits for this hart's S-mode */
  /* for the uart and virtio disk. */
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005080:	0085171b          	sllw	a4,a0,0x8
    80005084:	0c0027b7          	lui	a5,0xc002
    80005088:	97ba                	add	a5,a5,a4
    8000508a:	40200713          	li	a4,1026
    8000508e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  /* set this hart's S-mode priority threshold to 0. */
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005092:	00d5151b          	sllw	a0,a0,0xd
    80005096:	0c2017b7          	lui	a5,0xc201
    8000509a:	97aa                	add	a5,a5,a0
    8000509c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050a0:	60a2                	ld	ra,8(sp)
    800050a2:	6402                	ld	s0,0(sp)
    800050a4:	0141                	add	sp,sp,16
    800050a6:	8082                	ret

00000000800050a8 <plic_claim>:

/* ask the PLIC what interrupt we should serve. */
int
plic_claim(void)
{
    800050a8:	1141                	add	sp,sp,-16
    800050aa:	e406                	sd	ra,8(sp)
    800050ac:	e022                	sd	s0,0(sp)
    800050ae:	0800                	add	s0,sp,16
  int hart = cpuid();
    800050b0:	f54fc0ef          	jal	80001804 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050b4:	00d5151b          	sllw	a0,a0,0xd
    800050b8:	0c2017b7          	lui	a5,0xc201
    800050bc:	97aa                	add	a5,a5,a0
  return irq;
}
    800050be:	43c8                	lw	a0,4(a5)
    800050c0:	60a2                	ld	ra,8(sp)
    800050c2:	6402                	ld	s0,0(sp)
    800050c4:	0141                	add	sp,sp,16
    800050c6:	8082                	ret

00000000800050c8 <plic_complete>:

/* tell the PLIC we've served this IRQ. */
void
plic_complete(int irq)
{
    800050c8:	1101                	add	sp,sp,-32
    800050ca:	ec06                	sd	ra,24(sp)
    800050cc:	e822                	sd	s0,16(sp)
    800050ce:	e426                	sd	s1,8(sp)
    800050d0:	1000                	add	s0,sp,32
    800050d2:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050d4:	f30fc0ef          	jal	80001804 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050d8:	00d5151b          	sllw	a0,a0,0xd
    800050dc:	0c2017b7          	lui	a5,0xc201
    800050e0:	97aa                	add	a5,a5,a0
    800050e2:	c3c4                	sw	s1,4(a5)
}
    800050e4:	60e2                	ld	ra,24(sp)
    800050e6:	6442                	ld	s0,16(sp)
    800050e8:	64a2                	ld	s1,8(sp)
    800050ea:	6105                	add	sp,sp,32
    800050ec:	8082                	ret

00000000800050ee <free_desc>:
}

/* mark a descriptor as free. */
static void
free_desc(int i)
{
    800050ee:	1141                	add	sp,sp,-16
    800050f0:	e406                	sd	ra,8(sp)
    800050f2:	e022                	sd	s0,0(sp)
    800050f4:	0800                	add	s0,sp,16
  if(i >= NUM)
    800050f6:	479d                	li	a5,7
    800050f8:	04a7ca63          	blt	a5,a0,8000514c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800050fc:	0001c797          	auipc	a5,0x1c
    80005100:	a0478793          	add	a5,a5,-1532 # 80020b00 <disk>
    80005104:	97aa                	add	a5,a5,a0
    80005106:	0187c783          	lbu	a5,24(a5)
    8000510a:	e7b9                	bnez	a5,80005158 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000510c:	00451693          	sll	a3,a0,0x4
    80005110:	0001c797          	auipc	a5,0x1c
    80005114:	9f078793          	add	a5,a5,-1552 # 80020b00 <disk>
    80005118:	6398                	ld	a4,0(a5)
    8000511a:	9736                	add	a4,a4,a3
    8000511c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005120:	6398                	ld	a4,0(a5)
    80005122:	9736                	add	a4,a4,a3
    80005124:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005128:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000512c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005130:	97aa                	add	a5,a5,a0
    80005132:	4705                	li	a4,1
    80005134:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005138:	0001c517          	auipc	a0,0x1c
    8000513c:	9e050513          	add	a0,a0,-1568 # 80020b18 <disk+0x18>
    80005140:	d09fc0ef          	jal	80001e48 <wakeup>
}
    80005144:	60a2                	ld	ra,8(sp)
    80005146:	6402                	ld	s0,0(sp)
    80005148:	0141                	add	sp,sp,16
    8000514a:	8082                	ret
    panic("free_desc 1");
    8000514c:	00002517          	auipc	a0,0x2
    80005150:	63450513          	add	a0,a0,1588 # 80007780 <syscalls+0x2f0>
    80005154:	e0afb0ef          	jal	8000075e <panic>
    panic("free_desc 2");
    80005158:	00002517          	auipc	a0,0x2
    8000515c:	63850513          	add	a0,a0,1592 # 80007790 <syscalls+0x300>
    80005160:	dfefb0ef          	jal	8000075e <panic>

0000000080005164 <virtio_disk_init>:
{
    80005164:	1101                	add	sp,sp,-32
    80005166:	ec06                	sd	ra,24(sp)
    80005168:	e822                	sd	s0,16(sp)
    8000516a:	e426                	sd	s1,8(sp)
    8000516c:	e04a                	sd	s2,0(sp)
    8000516e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005170:	00002597          	auipc	a1,0x2
    80005174:	63058593          	add	a1,a1,1584 # 800077a0 <syscalls+0x310>
    80005178:	0001c517          	auipc	a0,0x1c
    8000517c:	ab050513          	add	a0,a0,-1360 # 80020c28 <disk+0x128>
    80005180:	9a1fb0ef          	jal	80000b20 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005184:	100017b7          	lui	a5,0x10001
    80005188:	4398                	lw	a4,0(a5)
    8000518a:	2701                	sext.w	a4,a4
    8000518c:	747277b7          	lui	a5,0x74727
    80005190:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005194:	12f71f63          	bne	a4,a5,800052d2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005198:	100017b7          	lui	a5,0x10001
    8000519c:	43dc                	lw	a5,4(a5)
    8000519e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051a0:	4709                	li	a4,2
    800051a2:	12e79863          	bne	a5,a4,800052d2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051a6:	100017b7          	lui	a5,0x10001
    800051aa:	479c                	lw	a5,8(a5)
    800051ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051ae:	12e79263          	bne	a5,a4,800052d2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051b2:	100017b7          	lui	a5,0x10001
    800051b6:	47d8                	lw	a4,12(a5)
    800051b8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051ba:	554d47b7          	lui	a5,0x554d4
    800051be:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051c2:	10f71863          	bne	a4,a5,800052d2 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051c6:	100017b7          	lui	a5,0x10001
    800051ca:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051ce:	4705                	li	a4,1
    800051d0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051d2:	470d                	li	a4,3
    800051d4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051d6:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800051d8:	c7ffe6b7          	lui	a3,0xc7ffe
    800051dc:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fddb1f>
    800051e0:	8f75                	and	a4,a4,a3
    800051e2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051e4:	472d                	li	a4,11
    800051e6:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800051e8:	5bbc                	lw	a5,112(a5)
    800051ea:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800051ee:	8ba1                	and	a5,a5,8
    800051f0:	0e078763          	beqz	a5,800052de <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800051f4:	100017b7          	lui	a5,0x10001
    800051f8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800051fc:	43fc                	lw	a5,68(a5)
    800051fe:	2781                	sext.w	a5,a5
    80005200:	0e079563          	bnez	a5,800052ea <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005204:	100017b7          	lui	a5,0x10001
    80005208:	5bdc                	lw	a5,52(a5)
    8000520a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000520c:	0e078563          	beqz	a5,800052f6 <virtio_disk_init+0x192>
  if(max < NUM)
    80005210:	471d                	li	a4,7
    80005212:	0ef77863          	bgeu	a4,a5,80005302 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005216:	8bbfb0ef          	jal	80000ad0 <kalloc>
    8000521a:	0001c497          	auipc	s1,0x1c
    8000521e:	8e648493          	add	s1,s1,-1818 # 80020b00 <disk>
    80005222:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005224:	8adfb0ef          	jal	80000ad0 <kalloc>
    80005228:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000522a:	8a7fb0ef          	jal	80000ad0 <kalloc>
    8000522e:	87aa                	mv	a5,a0
    80005230:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005232:	6088                	ld	a0,0(s1)
    80005234:	cd69                	beqz	a0,8000530e <virtio_disk_init+0x1aa>
    80005236:	0001c717          	auipc	a4,0x1c
    8000523a:	8d273703          	ld	a4,-1838(a4) # 80020b08 <disk+0x8>
    8000523e:	cb61                	beqz	a4,8000530e <virtio_disk_init+0x1aa>
    80005240:	c7f9                	beqz	a5,8000530e <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    80005242:	6605                	lui	a2,0x1
    80005244:	4581                	li	a1,0
    80005246:	a2ffb0ef          	jal	80000c74 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000524a:	0001c497          	auipc	s1,0x1c
    8000524e:	8b648493          	add	s1,s1,-1866 # 80020b00 <disk>
    80005252:	6605                	lui	a2,0x1
    80005254:	4581                	li	a1,0
    80005256:	6488                	ld	a0,8(s1)
    80005258:	a1dfb0ef          	jal	80000c74 <memset>
  memset(disk.used, 0, PGSIZE);
    8000525c:	6605                	lui	a2,0x1
    8000525e:	4581                	li	a1,0
    80005260:	6888                	ld	a0,16(s1)
    80005262:	a13fb0ef          	jal	80000c74 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005266:	100017b7          	lui	a5,0x10001
    8000526a:	4721                	li	a4,8
    8000526c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000526e:	4098                	lw	a4,0(s1)
    80005270:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005274:	40d8                	lw	a4,4(s1)
    80005276:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000527a:	6498                	ld	a4,8(s1)
    8000527c:	0007069b          	sext.w	a3,a4
    80005280:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005284:	9701                	sra	a4,a4,0x20
    80005286:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000528a:	6898                	ld	a4,16(s1)
    8000528c:	0007069b          	sext.w	a3,a4
    80005290:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005294:	9701                	sra	a4,a4,0x20
    80005296:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000529a:	4705                	li	a4,1
    8000529c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000529e:	00e48c23          	sb	a4,24(s1)
    800052a2:	00e48ca3          	sb	a4,25(s1)
    800052a6:	00e48d23          	sb	a4,26(s1)
    800052aa:	00e48da3          	sb	a4,27(s1)
    800052ae:	00e48e23          	sb	a4,28(s1)
    800052b2:	00e48ea3          	sb	a4,29(s1)
    800052b6:	00e48f23          	sb	a4,30(s1)
    800052ba:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800052be:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c2:	0727a823          	sw	s2,112(a5)
}
    800052c6:	60e2                	ld	ra,24(sp)
    800052c8:	6442                	ld	s0,16(sp)
    800052ca:	64a2                	ld	s1,8(sp)
    800052cc:	6902                	ld	s2,0(sp)
    800052ce:	6105                	add	sp,sp,32
    800052d0:	8082                	ret
    panic("could not find virtio disk");
    800052d2:	00002517          	auipc	a0,0x2
    800052d6:	4de50513          	add	a0,a0,1246 # 800077b0 <syscalls+0x320>
    800052da:	c84fb0ef          	jal	8000075e <panic>
    panic("virtio disk FEATURES_OK unset");
    800052de:	00002517          	auipc	a0,0x2
    800052e2:	4f250513          	add	a0,a0,1266 # 800077d0 <syscalls+0x340>
    800052e6:	c78fb0ef          	jal	8000075e <panic>
    panic("virtio disk should not be ready");
    800052ea:	00002517          	auipc	a0,0x2
    800052ee:	50650513          	add	a0,a0,1286 # 800077f0 <syscalls+0x360>
    800052f2:	c6cfb0ef          	jal	8000075e <panic>
    panic("virtio disk has no queue 0");
    800052f6:	00002517          	auipc	a0,0x2
    800052fa:	51a50513          	add	a0,a0,1306 # 80007810 <syscalls+0x380>
    800052fe:	c60fb0ef          	jal	8000075e <panic>
    panic("virtio disk max queue too short");
    80005302:	00002517          	auipc	a0,0x2
    80005306:	52e50513          	add	a0,a0,1326 # 80007830 <syscalls+0x3a0>
    8000530a:	c54fb0ef          	jal	8000075e <panic>
    panic("virtio disk kalloc");
    8000530e:	00002517          	auipc	a0,0x2
    80005312:	54250513          	add	a0,a0,1346 # 80007850 <syscalls+0x3c0>
    80005316:	c48fb0ef          	jal	8000075e <panic>

000000008000531a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000531a:	7159                	add	sp,sp,-112
    8000531c:	f486                	sd	ra,104(sp)
    8000531e:	f0a2                	sd	s0,96(sp)
    80005320:	eca6                	sd	s1,88(sp)
    80005322:	e8ca                	sd	s2,80(sp)
    80005324:	e4ce                	sd	s3,72(sp)
    80005326:	e0d2                	sd	s4,64(sp)
    80005328:	fc56                	sd	s5,56(sp)
    8000532a:	f85a                	sd	s6,48(sp)
    8000532c:	f45e                	sd	s7,40(sp)
    8000532e:	f062                	sd	s8,32(sp)
    80005330:	ec66                	sd	s9,24(sp)
    80005332:	e86a                	sd	s10,16(sp)
    80005334:	1880                	add	s0,sp,112
    80005336:	8a2a                	mv	s4,a0
    80005338:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000533a:	00c52c83          	lw	s9,12(a0)
    8000533e:	001c9c9b          	sllw	s9,s9,0x1
    80005342:	1c82                	sll	s9,s9,0x20
    80005344:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005348:	0001c517          	auipc	a0,0x1c
    8000534c:	8e050513          	add	a0,a0,-1824 # 80020c28 <disk+0x128>
    80005350:	851fb0ef          	jal	80000ba0 <acquire>
  for(int i = 0; i < 3; i++){
    80005354:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005356:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005358:	0001bb17          	auipc	s6,0x1b
    8000535c:	7a8b0b13          	add	s6,s6,1960 # 80020b00 <disk>
  for(int i = 0; i < 3; i++){
    80005360:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005362:	0001cc17          	auipc	s8,0x1c
    80005366:	8c6c0c13          	add	s8,s8,-1850 # 80020c28 <disk+0x128>
    8000536a:	a8b1                	j	800053c6 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    8000536c:	00fb0733          	add	a4,s6,a5
    80005370:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005374:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005376:	0207c563          	bltz	a5,800053a0 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    8000537a:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    8000537c:	0591                	add	a1,a1,4
    8000537e:	05560963          	beq	a2,s5,800053d0 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80005382:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005384:	0001b717          	auipc	a4,0x1b
    80005388:	77c70713          	add	a4,a4,1916 # 80020b00 <disk>
    8000538c:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000538e:	01874683          	lbu	a3,24(a4)
    80005392:	fee9                	bnez	a3,8000536c <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005394:	2785                	addw	a5,a5,1
    80005396:	0705                	add	a4,a4,1
    80005398:	fe979be3          	bne	a5,s1,8000538e <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    8000539c:	57fd                	li	a5,-1
    8000539e:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800053a0:	00c05c63          	blez	a2,800053b8 <virtio_disk_rw+0x9e>
    800053a4:	060a                	sll	a2,a2,0x2
    800053a6:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800053aa:	0009a503          	lw	a0,0(s3)
    800053ae:	d41ff0ef          	jal	800050ee <free_desc>
      for(int j = 0; j < i; j++)
    800053b2:	0991                	add	s3,s3,4
    800053b4:	ffa99be3          	bne	s3,s10,800053aa <virtio_disk_rw+0x90>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053b8:	85e2                	mv	a1,s8
    800053ba:	0001b517          	auipc	a0,0x1b
    800053be:	75e50513          	add	a0,a0,1886 # 80020b18 <disk+0x18>
    800053c2:	a3bfc0ef          	jal	80001dfc <sleep>
  for(int i = 0; i < 3; i++){
    800053c6:	f9040993          	add	s3,s0,-112
{
    800053ca:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800053cc:	864a                	mv	a2,s2
    800053ce:	bf55                	j	80005382 <virtio_disk_rw+0x68>
  }

  /* format the three descriptors. */
  /* qemu's virtio-blk.c reads them. */

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800053d0:	f9042503          	lw	a0,-112(s0)
    800053d4:	00a50713          	add	a4,a0,10
    800053d8:	0712                	sll	a4,a4,0x4

  if(write)
    800053da:	0001b797          	auipc	a5,0x1b
    800053de:	72678793          	add	a5,a5,1830 # 80020b00 <disk>
    800053e2:	00e786b3          	add	a3,a5,a4
    800053e6:	01703633          	snez	a2,s7
    800053ea:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; /* write the disk */
  else
    buf0->type = VIRTIO_BLK_T_IN; /* read the disk */
  buf0->reserved = 0;
    800053ec:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800053f0:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800053f4:	f6070613          	add	a2,a4,-160
    800053f8:	6394                	ld	a3,0(a5)
    800053fa:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800053fc:	00870593          	add	a1,a4,8
    80005400:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005402:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005404:	0007b803          	ld	a6,0(a5)
    80005408:	9642                	add	a2,a2,a6
    8000540a:	46c1                	li	a3,16
    8000540c:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000540e:	4585                	li	a1,1
    80005410:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005414:	f9442683          	lw	a3,-108(s0)
    80005418:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000541c:	0692                	sll	a3,a3,0x4
    8000541e:	9836                	add	a6,a6,a3
    80005420:	058a0613          	add	a2,s4,88
    80005424:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005428:	0007b803          	ld	a6,0(a5)
    8000542c:	96c2                	add	a3,a3,a6
    8000542e:	40000613          	li	a2,1024
    80005432:	c690                	sw	a2,8(a3)
  if(write)
    80005434:	001bb613          	seqz	a2,s7
    80005438:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; /* device reads b->data */
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; /* device writes b->data */
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000543c:	00166613          	or	a2,a2,1
    80005440:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005444:	f9842603          	lw	a2,-104(s0)
    80005448:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; /* device writes 0 on success */
    8000544c:	00250693          	add	a3,a0,2
    80005450:	0692                	sll	a3,a3,0x4
    80005452:	96be                	add	a3,a3,a5
    80005454:	58fd                	li	a7,-1
    80005456:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000545a:	0612                	sll	a2,a2,0x4
    8000545c:	9832                	add	a6,a6,a2
    8000545e:	f9070713          	add	a4,a4,-112
    80005462:	973e                	add	a4,a4,a5
    80005464:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80005468:	6398                	ld	a4,0(a5)
    8000546a:	9732                	add	a4,a4,a2
    8000546c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; /* device writes the status */
    8000546e:	4609                	li	a2,2
    80005470:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005474:	00071723          	sh	zero,14(a4)

  /* record struct buf for virtio_disk_intr(). */
  b->disk = 1;
    80005478:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    8000547c:	0146b423          	sd	s4,8(a3)

  /* tell the device the first index in our chain of descriptors. */
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005480:	6794                	ld	a3,8(a5)
    80005482:	0026d703          	lhu	a4,2(a3)
    80005486:	8b1d                	and	a4,a4,7
    80005488:	0706                	sll	a4,a4,0x1
    8000548a:	96ba                	add	a3,a3,a4
    8000548c:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005490:	0ff0000f          	fence

  /* tell the device another avail ring entry is available. */
  disk.avail->idx += 1; /* not % NUM ... */
    80005494:	6798                	ld	a4,8(a5)
    80005496:	00275783          	lhu	a5,2(a4)
    8000549a:	2785                	addw	a5,a5,1
    8000549c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054a0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; /* value is queue number */
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  /* Wait for virtio_disk_intr() to say request has finished. */
  while(b->disk == 1) {
    800054ac:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800054b0:	0001b917          	auipc	s2,0x1b
    800054b4:	77890913          	add	s2,s2,1912 # 80020c28 <disk+0x128>
  while(b->disk == 1) {
    800054b8:	4485                	li	s1,1
    800054ba:	00b79a63          	bne	a5,a1,800054ce <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    800054be:	85ca                	mv	a1,s2
    800054c0:	8552                	mv	a0,s4
    800054c2:	93bfc0ef          	jal	80001dfc <sleep>
  while(b->disk == 1) {
    800054c6:	004a2783          	lw	a5,4(s4)
    800054ca:	fe978ae3          	beq	a5,s1,800054be <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    800054ce:	f9042903          	lw	s2,-112(s0)
    800054d2:	00290713          	add	a4,s2,2
    800054d6:	0712                	sll	a4,a4,0x4
    800054d8:	0001b797          	auipc	a5,0x1b
    800054dc:	62878793          	add	a5,a5,1576 # 80020b00 <disk>
    800054e0:	97ba                	add	a5,a5,a4
    800054e2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800054e6:	0001b997          	auipc	s3,0x1b
    800054ea:	61a98993          	add	s3,s3,1562 # 80020b00 <disk>
    800054ee:	00491713          	sll	a4,s2,0x4
    800054f2:	0009b783          	ld	a5,0(s3)
    800054f6:	97ba                	add	a5,a5,a4
    800054f8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800054fc:	854a                	mv	a0,s2
    800054fe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005502:	bedff0ef          	jal	800050ee <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005506:	8885                	and	s1,s1,1
    80005508:	f0fd                	bnez	s1,800054ee <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000550a:	0001b517          	auipc	a0,0x1b
    8000550e:	71e50513          	add	a0,a0,1822 # 80020c28 <disk+0x128>
    80005512:	f26fb0ef          	jal	80000c38 <release>
}
    80005516:	70a6                	ld	ra,104(sp)
    80005518:	7406                	ld	s0,96(sp)
    8000551a:	64e6                	ld	s1,88(sp)
    8000551c:	6946                	ld	s2,80(sp)
    8000551e:	69a6                	ld	s3,72(sp)
    80005520:	6a06                	ld	s4,64(sp)
    80005522:	7ae2                	ld	s5,56(sp)
    80005524:	7b42                	ld	s6,48(sp)
    80005526:	7ba2                	ld	s7,40(sp)
    80005528:	7c02                	ld	s8,32(sp)
    8000552a:	6ce2                	ld	s9,24(sp)
    8000552c:	6d42                	ld	s10,16(sp)
    8000552e:	6165                	add	sp,sp,112
    80005530:	8082                	ret

0000000080005532 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005532:	1101                	add	sp,sp,-32
    80005534:	ec06                	sd	ra,24(sp)
    80005536:	e822                	sd	s0,16(sp)
    80005538:	e426                	sd	s1,8(sp)
    8000553a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000553c:	0001b497          	auipc	s1,0x1b
    80005540:	5c448493          	add	s1,s1,1476 # 80020b00 <disk>
    80005544:	0001b517          	auipc	a0,0x1b
    80005548:	6e450513          	add	a0,a0,1764 # 80020c28 <disk+0x128>
    8000554c:	e54fb0ef          	jal	80000ba0 <acquire>
  /* we've seen this interrupt, which the following line does. */
  /* this may race with the device writing new entries to */
  /* the "used" ring, in which case we may process the new */
  /* completion entries in this interrupt, and have nothing to do */
  /* in the next interrupt, which is harmless. */
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005550:	10001737          	lui	a4,0x10001
    80005554:	533c                	lw	a5,96(a4)
    80005556:	8b8d                	and	a5,a5,3
    80005558:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000555a:	0ff0000f          	fence

  /* the device increments disk.used->idx when it */
  /* adds an entry to the used ring. */

  while(disk.used_idx != disk.used->idx){
    8000555e:	689c                	ld	a5,16(s1)
    80005560:	0204d703          	lhu	a4,32(s1)
    80005564:	0027d783          	lhu	a5,2(a5)
    80005568:	04f70663          	beq	a4,a5,800055b4 <virtio_disk_intr+0x82>
    __sync_synchronize();
    8000556c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005570:	6898                	ld	a4,16(s1)
    80005572:	0204d783          	lhu	a5,32(s1)
    80005576:	8b9d                	and	a5,a5,7
    80005578:	078e                	sll	a5,a5,0x3
    8000557a:	97ba                	add	a5,a5,a4
    8000557c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000557e:	00278713          	add	a4,a5,2
    80005582:	0712                	sll	a4,a4,0x4
    80005584:	9726                	add	a4,a4,s1
    80005586:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000558a:	e321                	bnez	a4,800055ca <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000558c:	0789                	add	a5,a5,2
    8000558e:	0792                	sll	a5,a5,0x4
    80005590:	97a6                	add	a5,a5,s1
    80005592:	6788                	ld	a0,8(a5)
    b->disk = 0;   /* disk is done with buf */
    80005594:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005598:	8b1fc0ef          	jal	80001e48 <wakeup>

    disk.used_idx += 1;
    8000559c:	0204d783          	lhu	a5,32(s1)
    800055a0:	2785                	addw	a5,a5,1
    800055a2:	17c2                	sll	a5,a5,0x30
    800055a4:	93c1                	srl	a5,a5,0x30
    800055a6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055aa:	6898                	ld	a4,16(s1)
    800055ac:	00275703          	lhu	a4,2(a4)
    800055b0:	faf71ee3          	bne	a4,a5,8000556c <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800055b4:	0001b517          	auipc	a0,0x1b
    800055b8:	67450513          	add	a0,a0,1652 # 80020c28 <disk+0x128>
    800055bc:	e7cfb0ef          	jal	80000c38 <release>
}
    800055c0:	60e2                	ld	ra,24(sp)
    800055c2:	6442                	ld	s0,16(sp)
    800055c4:	64a2                	ld	s1,8(sp)
    800055c6:	6105                	add	sp,sp,32
    800055c8:	8082                	ret
      panic("virtio_disk_intr status");
    800055ca:	00002517          	auipc	a0,0x2
    800055ce:	29e50513          	add	a0,a0,670 # 80007868 <syscalls+0x3d8>
    800055d2:	98cfb0ef          	jal	8000075e <panic>
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
