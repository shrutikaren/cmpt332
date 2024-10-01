
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	346000ef          	jal	366 <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	33e000ef          	jal	36e <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	8d858593          	add	a1,a1,-1832 # 910 <malloc+0xec>
  40:	4509                	li	a0,2
  42:	704000ef          	jal	746 <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	306000ef          	jal	34e <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	add	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	8ca58593          	add	a1,a1,-1846 # 928 <malloc+0x104>
  66:	4509                	li	a0,2
  68:	6de000ef          	jal	746 <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	2e0000ef          	jal	34e <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	add	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	ec26                	sd	s1,24(sp)
  7a:	e84a                	sd	s2,16(sp)
  7c:	e44e                	sd	s3,8(sp)
  7e:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  80:	4785                	li	a5,1
  82:	02a7df63          	bge	a5,a0,c0 <main+0x4e>
  86:	00858913          	add	s2,a1,8
  8a:	ffe5099b          	addw	s3,a0,-2
  8e:	02099793          	sll	a5,s3,0x20
  92:	01d7d993          	srl	s3,a5,0x1d
  96:	05c1                	add	a1,a1,16
  98:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9a:	4581                	li	a1,0
  9c:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a0:	2ee000ef          	jal	38e <open>
  a4:	84aa                	mv	s1,a0
  a6:	02054363          	bltz	a0,cc <main+0x5a>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  aa:	f57ff0ef          	jal	0 <cat>
    close(fd);
  ae:	8526                	mv	a0,s1
  b0:	2c6000ef          	jal	376 <close>
  for(i = 1; i < argc; i++){
  b4:	0921                	add	s2,s2,8
  b6:	ff3912e3          	bne	s2,s3,9a <main+0x28>
  }
  exit(0);
  ba:	4501                	li	a0,0
  bc:	292000ef          	jal	34e <exit>
    cat(0);
  c0:	4501                	li	a0,0
  c2:	f3fff0ef          	jal	0 <cat>
    exit(0);
  c6:	4501                	li	a0,0
  c8:	286000ef          	jal	34e <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  cc:	00093603          	ld	a2,0(s2)
  d0:	00001597          	auipc	a1,0x1
  d4:	87058593          	add	a1,a1,-1936 # 940 <malloc+0x11c>
  d8:	4509                	li	a0,2
  da:	66c000ef          	jal	746 <fprintf>
      exit(1);
  de:	4505                	li	a0,1
  e0:	26e000ef          	jal	34e <exit>

00000000000000e4 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
  e4:	1141                	add	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	add	s0,sp,16
  extern int main();
  main();
  ec:	f87ff0ef          	jal	72 <main>
  exit(0);
  f0:	4501                	li	a0,0
  f2:	25c000ef          	jal	34e <exit>

00000000000000f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f6:	1141                	add	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fc:	87aa                	mv	a5,a0
  fe:	0585                	add	a1,a1,1
 100:	0785                	add	a5,a5,1
 102:	fff5c703          	lbu	a4,-1(a1)
 106:	fee78fa3          	sb	a4,-1(a5)
 10a:	fb75                	bnez	a4,fe <strcpy+0x8>
    ;
  return os;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	add	sp,sp,16
 110:	8082                	ret

0000000000000112 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 112:	1141                	add	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb91                	beqz	a5,130 <strcmp+0x1e>
 11e:	0005c703          	lbu	a4,0(a1)
 122:	00f71763          	bne	a4,a5,130 <strcmp+0x1e>
    p++, q++;
 126:	0505                	add	a0,a0,1
 128:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbe5                	bnez	a5,11e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 130:	0005c503          	lbu	a0,0(a1)
}
 134:	40a7853b          	subw	a0,a5,a0
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	add	sp,sp,16
 13c:	8082                	ret

000000000000013e <strlen>:

uint
strlen(const char *s)
{
 13e:	1141                	add	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 144:	00054783          	lbu	a5,0(a0)
 148:	cf91                	beqz	a5,164 <strlen+0x26>
 14a:	0505                	add	a0,a0,1
 14c:	87aa                	mv	a5,a0
 14e:	86be                	mv	a3,a5
 150:	0785                	add	a5,a5,1
 152:	fff7c703          	lbu	a4,-1(a5)
 156:	ff65                	bnez	a4,14e <strlen+0x10>
 158:	40a6853b          	subw	a0,a3,a0
 15c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	add	sp,sp,16
 162:	8082                	ret
  for(n = 0; s[n]; n++)
 164:	4501                	li	a0,0
 166:	bfe5                	j	15e <strlen+0x20>

0000000000000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	1141                	add	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16e:	ca19                	beqz	a2,184 <memset+0x1c>
 170:	87aa                	mv	a5,a0
 172:	1602                	sll	a2,a2,0x20
 174:	9201                	srl	a2,a2,0x20
 176:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17e:	0785                	add	a5,a5,1
 180:	fee79de3          	bne	a5,a4,17a <memset+0x12>
  }
  return dst;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	add	sp,sp,16
 188:	8082                	ret

000000000000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	1141                	add	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	add	s0,sp,16
  for(; *s; s++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb99                	beqz	a5,1aa <strchr+0x20>
    if(*s == c)
 196:	00f58763          	beq	a1,a5,1a4 <strchr+0x1a>
  for(; *s; s++)
 19a:	0505                	add	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbfd                	bnez	a5,196 <strchr+0xc>
      return (char*)s;
  return 0;
 1a2:	4501                	li	a0,0
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	add	sp,sp,16
 1a8:	8082                	ret
  return 0;
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strchr+0x1a>

00000000000001ae <gets>:

char*
gets(char *buf, int max)
{
 1ae:	711d                	add	sp,sp,-96
 1b0:	ec86                	sd	ra,88(sp)
 1b2:	e8a2                	sd	s0,80(sp)
 1b4:	e4a6                	sd	s1,72(sp)
 1b6:	e0ca                	sd	s2,64(sp)
 1b8:	fc4e                	sd	s3,56(sp)
 1ba:	f852                	sd	s4,48(sp)
 1bc:	f456                	sd	s5,40(sp)
 1be:	f05a                	sd	s6,32(sp)
 1c0:	ec5e                	sd	s7,24(sp)
 1c2:	1080                	add	s0,sp,96
 1c4:	8baa                	mv	s7,a0
 1c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	892a                	mv	s2,a0
 1ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1cc:	4aa9                	li	s5,10
 1ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d0:	89a6                	mv	s3,s1
 1d2:	2485                	addw	s1,s1,1
 1d4:	0344d663          	bge	s1,s4,200 <gets+0x52>
    cc = read(0, &c, 1);
 1d8:	4605                	li	a2,1
 1da:	faf40593          	add	a1,s0,-81
 1de:	4501                	li	a0,0
 1e0:	186000ef          	jal	366 <read>
    if(cc < 1)
 1e4:	00a05e63          	blez	a0,200 <gets+0x52>
    buf[i++] = c;
 1e8:	faf44783          	lbu	a5,-81(s0)
 1ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f0:	01578763          	beq	a5,s5,1fe <gets+0x50>
 1f4:	0905                	add	s2,s2,1
 1f6:	fd679de3          	bne	a5,s6,1d0 <gets+0x22>
  for(i=0; i+1 < max; ){
 1fa:	89a6                	mv	s3,s1
 1fc:	a011                	j	200 <gets+0x52>
 1fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 200:	99de                	add	s3,s3,s7
 202:	00098023          	sb	zero,0(s3)
  return buf;
}
 206:	855e                	mv	a0,s7
 208:	60e6                	ld	ra,88(sp)
 20a:	6446                	ld	s0,80(sp)
 20c:	64a6                	ld	s1,72(sp)
 20e:	6906                	ld	s2,64(sp)
 210:	79e2                	ld	s3,56(sp)
 212:	7a42                	ld	s4,48(sp)
 214:	7aa2                	ld	s5,40(sp)
 216:	7b02                	ld	s6,32(sp)
 218:	6be2                	ld	s7,24(sp)
 21a:	6125                	add	sp,sp,96
 21c:	8082                	ret

000000000000021e <stat>:

int
stat(const char *n, struct stat *st)
{
 21e:	1101                	add	sp,sp,-32
 220:	ec06                	sd	ra,24(sp)
 222:	e822                	sd	s0,16(sp)
 224:	e426                	sd	s1,8(sp)
 226:	e04a                	sd	s2,0(sp)
 228:	1000                	add	s0,sp,32
 22a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22c:	4581                	li	a1,0
 22e:	160000ef          	jal	38e <open>
  if(fd < 0)
 232:	02054163          	bltz	a0,254 <stat+0x36>
 236:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 238:	85ca                	mv	a1,s2
 23a:	16c000ef          	jal	3a6 <fstat>
 23e:	892a                	mv	s2,a0
  close(fd);
 240:	8526                	mv	a0,s1
 242:	134000ef          	jal	376 <close>
  return r;
}
 246:	854a                	mv	a0,s2
 248:	60e2                	ld	ra,24(sp)
 24a:	6442                	ld	s0,16(sp)
 24c:	64a2                	ld	s1,8(sp)
 24e:	6902                	ld	s2,0(sp)
 250:	6105                	add	sp,sp,32
 252:	8082                	ret
    return -1;
 254:	597d                	li	s2,-1
 256:	bfc5                	j	246 <stat+0x28>

0000000000000258 <atoi>:

int
atoi(const char *s)
{
 258:	1141                	add	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66863          	bltu	a2,a5,29c <atoi+0x44>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 274:	0705                	add	a4,a4,1
 276:	0025179b          	sllw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	sllw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1c>
  return n;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	add	sp,sp,16
 29a:	8082                	ret
  n = 0;
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <atoi+0x3e>

00000000000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	1141                	add	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a6:	02b57463          	bgeu	a0,a1,2ce <memmove+0x2e>
    while(n-- > 0)
 2aa:	00c05f63          	blez	a2,2c8 <memmove+0x28>
 2ae:	1602                	sll	a2,a2,0x20
 2b0:	9201                	srl	a2,a2,0x20
 2b2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b8:	0585                	add	a1,a1,1
 2ba:	0705                	add	a4,a4,1
 2bc:	fff5c683          	lbu	a3,-1(a1)
 2c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c4:	fee79ae3          	bne	a5,a4,2b8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	add	sp,sp,16
 2cc:	8082                	ret
    dst += n;
 2ce:	00c50733          	add	a4,a0,a2
    src += n;
 2d2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d4:	fec05ae3          	blez	a2,2c8 <memmove+0x28>
 2d8:	fff6079b          	addw	a5,a2,-1
 2dc:	1782                	sll	a5,a5,0x20
 2de:	9381                	srl	a5,a5,0x20
 2e0:	fff7c793          	not	a5,a5
 2e4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e6:	15fd                	add	a1,a1,-1
 2e8:	177d                	add	a4,a4,-1
 2ea:	0005c683          	lbu	a3,0(a1)
 2ee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f2:	fee79ae3          	bne	a5,a4,2e6 <memmove+0x46>
 2f6:	bfc9                	j	2c8 <memmove+0x28>

00000000000002f8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f8:	1141                	add	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fe:	ca05                	beqz	a2,32e <memcmp+0x36>
 300:	fff6069b          	addw	a3,a2,-1
 304:	1682                	sll	a3,a3,0x20
 306:	9281                	srl	a3,a3,0x20
 308:	0685                	add	a3,a3,1
 30a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30c:	00054783          	lbu	a5,0(a0)
 310:	0005c703          	lbu	a4,0(a1)
 314:	00e79863          	bne	a5,a4,324 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 318:	0505                	add	a0,a0,1
    p2++;
 31a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 31c:	fed518e3          	bne	a0,a3,30c <memcmp+0x14>
  }
  return 0;
 320:	4501                	li	a0,0
 322:	a019                	j	328 <memcmp+0x30>
      return *p1 - *p2;
 324:	40e7853b          	subw	a0,a5,a4
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	add	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <memcmp+0x30>

0000000000000332 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 332:	1141                	add	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 33a:	f67ff0ef          	jal	2a0 <memmove>
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	add	sp,sp,16
 344:	8082                	ret

0000000000000346 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 346:	4885                	li	a7,1
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exit>:
.global exit
exit:
 li a7, SYS_exit
 34e:	4889                	li	a7,2
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <wait>:
.global wait
wait:
 li a7, SYS_wait
 356:	488d                	li	a7,3
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35e:	4891                	li	a7,4
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <read>:
.global read
read:
 li a7, SYS_read
 366:	4895                	li	a7,5
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <write>:
.global write
write:
 li a7, SYS_write
 36e:	48c1                	li	a7,16
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <close>:
.global close
close:
 li a7, SYS_close
 376:	48d5                	li	a7,21
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <kill>:
.global kill
kill:
 li a7, SYS_kill
 37e:	4899                	li	a7,6
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <exec>:
.global exec
exec:
 li a7, SYS_exec
 386:	489d                	li	a7,7
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <open>:
.global open
open:
 li a7, SYS_open
 38e:	48bd                	li	a7,15
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 396:	48c5                	li	a7,17
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39e:	48c9                	li	a7,18
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a6:	48a1                	li	a7,8
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <link>:
.global link
link:
 li a7, SYS_link
 3ae:	48cd                	li	a7,19
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b6:	48d1                	li	a7,20
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3be:	48a5                	li	a7,9
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c6:	48a9                	li	a7,10
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ce:	48ad                	li	a7,11
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d6:	48b1                	li	a7,12
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3de:	48b5                	li	a7,13
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e6:	48b9                	li	a7,14
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ee:	48d9                	li	a7,22
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f6:	1101                	add	sp,sp,-32
 3f8:	ec06                	sd	ra,24(sp)
 3fa:	e822                	sd	s0,16(sp)
 3fc:	1000                	add	s0,sp,32
 3fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 402:	4605                	li	a2,1
 404:	fef40593          	add	a1,s0,-17
 408:	f67ff0ef          	jal	36e <write>
}
 40c:	60e2                	ld	ra,24(sp)
 40e:	6442                	ld	s0,16(sp)
 410:	6105                	add	sp,sp,32
 412:	8082                	ret

0000000000000414 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 414:	7139                	add	sp,sp,-64
 416:	fc06                	sd	ra,56(sp)
 418:	f822                	sd	s0,48(sp)
 41a:	f426                	sd	s1,40(sp)
 41c:	f04a                	sd	s2,32(sp)
 41e:	ec4e                	sd	s3,24(sp)
 420:	0080                	add	s0,sp,64
 422:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 424:	c299                	beqz	a3,42a <printint+0x16>
 426:	0805c763          	bltz	a1,4b4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 42a:	2581                	sext.w	a1,a1
  neg = 0;
 42c:	4881                	li	a7,0
 42e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 432:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 434:	2601                	sext.w	a2,a2
 436:	00000517          	auipc	a0,0x0
 43a:	52a50513          	add	a0,a0,1322 # 960 <digits>
 43e:	883a                	mv	a6,a4
 440:	2705                	addw	a4,a4,1
 442:	02c5f7bb          	remuw	a5,a1,a2
 446:	1782                	sll	a5,a5,0x20
 448:	9381                	srl	a5,a5,0x20
 44a:	97aa                	add	a5,a5,a0
 44c:	0007c783          	lbu	a5,0(a5)
 450:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 454:	0005879b          	sext.w	a5,a1
 458:	02c5d5bb          	divuw	a1,a1,a2
 45c:	0685                	add	a3,a3,1
 45e:	fec7f0e3          	bgeu	a5,a2,43e <printint+0x2a>
  if(neg)
 462:	00088c63          	beqz	a7,47a <printint+0x66>
    buf[i++] = '-';
 466:	fd070793          	add	a5,a4,-48
 46a:	00878733          	add	a4,a5,s0
 46e:	02d00793          	li	a5,45
 472:	fef70823          	sb	a5,-16(a4)
 476:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 47a:	02e05663          	blez	a4,4a6 <printint+0x92>
 47e:	fc040793          	add	a5,s0,-64
 482:	00e78933          	add	s2,a5,a4
 486:	fff78993          	add	s3,a5,-1
 48a:	99ba                	add	s3,s3,a4
 48c:	377d                	addw	a4,a4,-1
 48e:	1702                	sll	a4,a4,0x20
 490:	9301                	srl	a4,a4,0x20
 492:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 496:	fff94583          	lbu	a1,-1(s2)
 49a:	8526                	mv	a0,s1
 49c:	f5bff0ef          	jal	3f6 <putc>
  while(--i >= 0)
 4a0:	197d                	add	s2,s2,-1
 4a2:	ff391ae3          	bne	s2,s3,496 <printint+0x82>
}
 4a6:	70e2                	ld	ra,56(sp)
 4a8:	7442                	ld	s0,48(sp)
 4aa:	74a2                	ld	s1,40(sp)
 4ac:	7902                	ld	s2,32(sp)
 4ae:	69e2                	ld	s3,24(sp)
 4b0:	6121                	add	sp,sp,64
 4b2:	8082                	ret
    x = -xx;
 4b4:	40b005bb          	negw	a1,a1
    neg = 1;
 4b8:	4885                	li	a7,1
    x = -xx;
 4ba:	bf95                	j	42e <printint+0x1a>

00000000000004bc <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4bc:	711d                	add	sp,sp,-96
 4be:	ec86                	sd	ra,88(sp)
 4c0:	e8a2                	sd	s0,80(sp)
 4c2:	e4a6                	sd	s1,72(sp)
 4c4:	e0ca                	sd	s2,64(sp)
 4c6:	fc4e                	sd	s3,56(sp)
 4c8:	f852                	sd	s4,48(sp)
 4ca:	f456                	sd	s5,40(sp)
 4cc:	f05a                	sd	s6,32(sp)
 4ce:	ec5e                	sd	s7,24(sp)
 4d0:	e862                	sd	s8,16(sp)
 4d2:	e466                	sd	s9,8(sp)
 4d4:	e06a                	sd	s10,0(sp)
 4d6:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d8:	0005c903          	lbu	s2,0(a1)
 4dc:	24090763          	beqz	s2,72a <vprintf+0x26e>
 4e0:	8b2a                	mv	s6,a0
 4e2:	8a2e                	mv	s4,a1
 4e4:	8bb2                	mv	s7,a2
  state = 0;
 4e6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e8:	4481                	li	s1,0
 4ea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f4:	06c00c93          	li	s9,108
 4f8:	a005                	j	518 <vprintf+0x5c>
        putc(fd, c0);
 4fa:	85ca                	mv	a1,s2
 4fc:	855a                	mv	a0,s6
 4fe:	ef9ff0ef          	jal	3f6 <putc>
 502:	a019                	j	508 <vprintf+0x4c>
    } else if(state == '%'){
 504:	03598263          	beq	s3,s5,528 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 508:	2485                	addw	s1,s1,1
 50a:	8726                	mv	a4,s1
 50c:	009a07b3          	add	a5,s4,s1
 510:	0007c903          	lbu	s2,0(a5)
 514:	20090b63          	beqz	s2,72a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 518:	0009079b          	sext.w	a5,s2
    if(state == 0){
 51c:	fe0994e3          	bnez	s3,504 <vprintf+0x48>
      if(c0 == '%'){
 520:	fd579de3          	bne	a5,s5,4fa <vprintf+0x3e>
        state = '%';
 524:	89be                	mv	s3,a5
 526:	b7cd                	j	508 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 528:	c7c9                	beqz	a5,5b2 <vprintf+0xf6>
 52a:	00ea06b3          	add	a3,s4,a4
 52e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 532:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 534:	c681                	beqz	a3,53c <vprintf+0x80>
 536:	9752                	add	a4,a4,s4
 538:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 53c:	03878f63          	beq	a5,s8,57a <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 540:	05978963          	beq	a5,s9,592 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 544:	07500713          	li	a4,117
 548:	0ee78363          	beq	a5,a4,62e <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 54c:	07800713          	li	a4,120
 550:	12e78563          	beq	a5,a4,67a <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 554:	07000713          	li	a4,112
 558:	14e78a63          	beq	a5,a4,6ac <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 55c:	07300713          	li	a4,115
 560:	18e78863          	beq	a5,a4,6f0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 564:	02500713          	li	a4,37
 568:	04e79563          	bne	a5,a4,5b2 <vprintf+0xf6>
        putc(fd, '%');
 56c:	02500593          	li	a1,37
 570:	855a                	mv	a0,s6
 572:	e85ff0ef          	jal	3f6 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 576:	4981                	li	s3,0
 578:	bf41                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 57a:	008b8913          	add	s2,s7,8
 57e:	4685                	li	a3,1
 580:	4629                	li	a2,10
 582:	000ba583          	lw	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e8dff0ef          	jal	414 <printint>
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	bfa5                	j	508 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 592:	06400793          	li	a5,100
 596:	02f68963          	beq	a3,a5,5c8 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 59a:	06c00793          	li	a5,108
 59e:	04f68263          	beq	a3,a5,5e2 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 5a2:	07500793          	li	a5,117
 5a6:	0af68063          	beq	a3,a5,646 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 5aa:	07800793          	li	a5,120
 5ae:	0ef68263          	beq	a3,a5,692 <vprintf+0x1d6>
        putc(fd, '%');
 5b2:	02500593          	li	a1,37
 5b6:	855a                	mv	a0,s6
 5b8:	e3fff0ef          	jal	3f6 <putc>
        putc(fd, c0);
 5bc:	85ca                	mv	a1,s2
 5be:	855a                	mv	a0,s6
 5c0:	e37ff0ef          	jal	3f6 <putc>
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b789                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	008b8913          	add	s2,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e3fff0ef          	jal	414 <printint>
        i += 1;
 5da:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 1;
 5e0:	b725                	j	508 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e2:	06400793          	li	a5,100
 5e6:	02f60763          	beq	a2,a5,614 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5ea:	07500793          	li	a5,117
 5ee:	06f60963          	beq	a2,a5,660 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5f2:	07800793          	li	a5,120
 5f6:	faf61ee3          	bne	a2,a5,5b2 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fa:	008b8913          	add	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e0dff0ef          	jal	414 <printint>
        i += 2;
 60c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 2;
 612:	bddd                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 614:	008b8913          	add	s2,s7,8
 618:	4685                	li	a3,1
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	df3ff0ef          	jal	414 <printint>
        i += 2;
 626:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
        i += 2;
 62c:	bdf1                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 62e:	008b8913          	add	s2,s7,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000ba583          	lw	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	dd9ff0ef          	jal	414 <printint>
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	b5d1                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 646:	008b8913          	add	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	dc1ff0ef          	jal	414 <printint>
        i += 1;
 658:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 1;
 65e:	b56d                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 660:	008b8913          	add	s2,s7,8
 664:	4681                	li	a3,0
 666:	4629                	li	a2,10
 668:	000ba583          	lw	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	da7ff0ef          	jal	414 <printint>
        i += 2;
 672:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	8bca                	mv	s7,s2
      state = 0;
 676:	4981                	li	s3,0
        i += 2;
 678:	bd41                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 67a:	008b8913          	add	s2,s7,8
 67e:	4681                	li	a3,0
 680:	4641                	li	a2,16
 682:	000ba583          	lw	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	d8dff0ef          	jal	414 <printint>
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	bda5                	j	508 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 692:	008b8913          	add	s2,s7,8
 696:	4681                	li	a3,0
 698:	4641                	li	a2,16
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	d75ff0ef          	jal	414 <printint>
        i += 1;
 6a4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
        i += 1;
 6aa:	bdb9                	j	508 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 6ac:	008b8d13          	add	s10,s7,8
 6b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b4:	03000593          	li	a1,48
 6b8:	855a                	mv	a0,s6
 6ba:	d3dff0ef          	jal	3f6 <putc>
  putc(fd, 'x');
 6be:	07800593          	li	a1,120
 6c2:	855a                	mv	a0,s6
 6c4:	d33ff0ef          	jal	3f6 <putc>
 6c8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ca:	00000b97          	auipc	s7,0x0
 6ce:	296b8b93          	add	s7,s7,662 # 960 <digits>
 6d2:	03c9d793          	srl	a5,s3,0x3c
 6d6:	97de                	add	a5,a5,s7
 6d8:	0007c583          	lbu	a1,0(a5)
 6dc:	855a                	mv	a0,s6
 6de:	d19ff0ef          	jal	3f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e2:	0992                	sll	s3,s3,0x4
 6e4:	397d                	addw	s2,s2,-1
 6e6:	fe0916e3          	bnez	s2,6d2 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 6ea:	8bea                	mv	s7,s10
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bd29                	j	508 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 6f0:	008b8993          	add	s3,s7,8
 6f4:	000bb903          	ld	s2,0(s7)
 6f8:	00090f63          	beqz	s2,716 <vprintf+0x25a>
        for(; *s; s++)
 6fc:	00094583          	lbu	a1,0(s2)
 700:	c195                	beqz	a1,724 <vprintf+0x268>
          putc(fd, *s);
 702:	855a                	mv	a0,s6
 704:	cf3ff0ef          	jal	3f6 <putc>
        for(; *s; s++)
 708:	0905                	add	s2,s2,1
 70a:	00094583          	lbu	a1,0(s2)
 70e:	f9f5                	bnez	a1,702 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 710:	8bce                	mv	s7,s3
      state = 0;
 712:	4981                	li	s3,0
 714:	bbd5                	j	508 <vprintf+0x4c>
          s = "(null)";
 716:	00000917          	auipc	s2,0x0
 71a:	24290913          	add	s2,s2,578 # 958 <malloc+0x134>
        for(; *s; s++)
 71e:	02800593          	li	a1,40
 722:	b7c5                	j	702 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	b3c5                	j	508 <vprintf+0x4c>
    }
  }
}
 72a:	60e6                	ld	ra,88(sp)
 72c:	6446                	ld	s0,80(sp)
 72e:	64a6                	ld	s1,72(sp)
 730:	6906                	ld	s2,64(sp)
 732:	79e2                	ld	s3,56(sp)
 734:	7a42                	ld	s4,48(sp)
 736:	7aa2                	ld	s5,40(sp)
 738:	7b02                	ld	s6,32(sp)
 73a:	6be2                	ld	s7,24(sp)
 73c:	6c42                	ld	s8,16(sp)
 73e:	6ca2                	ld	s9,8(sp)
 740:	6d02                	ld	s10,0(sp)
 742:	6125                	add	sp,sp,96
 744:	8082                	ret

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	add	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	add	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 762:	8622                	mv	a2,s0
 764:	d59ff0ef          	jal	4bc <vprintf>
}
 768:	60e2                	ld	ra,24(sp)
 76a:	6442                	ld	s0,16(sp)
 76c:	6161                	add	sp,sp,80
 76e:	8082                	ret

0000000000000770 <printf>:

void
printf(const char *fmt, ...)
{
 770:	711d                	add	sp,sp,-96
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	add	s0,sp,32
 778:	e40c                	sd	a1,8(s0)
 77a:	e810                	sd	a2,16(s0)
 77c:	ec14                	sd	a3,24(s0)
 77e:	f018                	sd	a4,32(s0)
 780:	f41c                	sd	a5,40(s0)
 782:	03043823          	sd	a6,48(s0)
 786:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78a:	00840613          	add	a2,s0,8
 78e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 792:	85aa                	mv	a1,a0
 794:	4505                	li	a0,1
 796:	d27ff0ef          	jal	4bc <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6125                	add	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a2:	1141                	add	sp,sp,-16
 7a4:	e422                	sd	s0,8(sp)
 7a6:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ac:	00001797          	auipc	a5,0x1
 7b0:	8547b783          	ld	a5,-1964(a5) # 1000 <freep>
 7b4:	a02d                	j	7de <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b6:	4618                	lw	a4,8(a2)
 7b8:	9f2d                	addw	a4,a4,a1
 7ba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	6398                	ld	a4,0(a5)
 7c0:	6310                	ld	a2,0(a4)
 7c2:	a83d                	j	800 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c4:	ff852703          	lw	a4,-8(a0)
 7c8:	9f31                	addw	a4,a4,a2
 7ca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7cc:	ff053683          	ld	a3,-16(a0)
 7d0:	a091                	j	814 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d2:	6398                	ld	a4,0(a5)
 7d4:	00e7e463          	bltu	a5,a4,7dc <free+0x3a>
 7d8:	00e6ea63          	bltu	a3,a4,7ec <free+0x4a>
{
 7dc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	fed7fae3          	bgeu	a5,a3,7d2 <free+0x30>
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e6e463          	bltu	a3,a4,7ec <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	fee7eae3          	bltu	a5,a4,7dc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7ec:	ff852583          	lw	a1,-8(a0)
 7f0:	6390                	ld	a2,0(a5)
 7f2:	02059813          	sll	a6,a1,0x20
 7f6:	01c85713          	srl	a4,a6,0x1c
 7fa:	9736                	add	a4,a4,a3
 7fc:	fae60de3          	beq	a2,a4,7b6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 804:	4790                	lw	a2,8(a5)
 806:	02061593          	sll	a1,a2,0x20
 80a:	01c5d713          	srl	a4,a1,0x1c
 80e:	973e                	add	a4,a4,a5
 810:	fae68ae3          	beq	a3,a4,7c4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 814:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 816:	00000717          	auipc	a4,0x0
 81a:	7ef73523          	sd	a5,2026(a4) # 1000 <freep>
}
 81e:	6422                	ld	s0,8(sp)
 820:	0141                	add	sp,sp,16
 822:	8082                	ret

0000000000000824 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 824:	7139                	add	sp,sp,-64
 826:	fc06                	sd	ra,56(sp)
 828:	f822                	sd	s0,48(sp)
 82a:	f426                	sd	s1,40(sp)
 82c:	f04a                	sd	s2,32(sp)
 82e:	ec4e                	sd	s3,24(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
 836:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 838:	02051493          	sll	s1,a0,0x20
 83c:	9081                	srl	s1,s1,0x20
 83e:	04bd                	add	s1,s1,15
 840:	8091                	srl	s1,s1,0x4
 842:	0014899b          	addw	s3,s1,1
 846:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 848:	00000517          	auipc	a0,0x0
 84c:	7b853503          	ld	a0,1976(a0) # 1000 <freep>
 850:	c515                	beqz	a0,87c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 852:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 854:	4798                	lw	a4,8(a5)
 856:	02977f63          	bgeu	a4,s1,894 <malloc+0x70>
  if(nu < 4096)
 85a:	8a4e                	mv	s4,s3
 85c:	0009871b          	sext.w	a4,s3
 860:	6685                	lui	a3,0x1
 862:	00d77363          	bgeu	a4,a3,868 <malloc+0x44>
 866:	6a05                	lui	s4,0x1
 868:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 870:	00000917          	auipc	s2,0x0
 874:	79090913          	add	s2,s2,1936 # 1000 <freep>
  if(p == (char*)-1)
 878:	5afd                	li	s5,-1
 87a:	a885                	j	8ea <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 87c:	00001797          	auipc	a5,0x1
 880:	99478793          	add	a5,a5,-1644 # 1210 <base>
 884:	00000717          	auipc	a4,0x0
 888:	76f73e23          	sd	a5,1916(a4) # 1000 <freep>
 88c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 892:	b7e1                	j	85a <malloc+0x36>
      if(p->s.size == nunits)
 894:	02e48c63          	beq	s1,a4,8cc <malloc+0xa8>
        p->s.size -= nunits;
 898:	4137073b          	subw	a4,a4,s3
 89c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89e:	02071693          	sll	a3,a4,0x20
 8a2:	01c6d713          	srl	a4,a3,0x1c
 8a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ac:	00000717          	auipc	a4,0x0
 8b0:	74a73a23          	sd	a0,1876(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b4:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b8:	70e2                	ld	ra,56(sp)
 8ba:	7442                	ld	s0,48(sp)
 8bc:	74a2                	ld	s1,40(sp)
 8be:	7902                	ld	s2,32(sp)
 8c0:	69e2                	ld	s3,24(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	6121                	add	sp,sp,64
 8ca:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	e118                	sd	a4,0(a0)
 8d0:	bff1                	j	8ac <malloc+0x88>
  hp->s.size = nu;
 8d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d6:	0541                	add	a0,a0,16
 8d8:	ecbff0ef          	jal	7a2 <free>
  return freep;
 8dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e0:	dd61                	beqz	a0,8b8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	fa9777e3          	bgeu	a4,s1,894 <malloc+0x70>
    if(p == freep)
 8ea:	00093703          	ld	a4,0(s2)
 8ee:	853e                	mv	a0,a5
 8f0:	fef719e3          	bne	a4,a5,8e2 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	ae1ff0ef          	jal	3d6 <sbrk>
  if(p == (char*)-1)
 8fa:	fd551ce3          	bne	a0,s5,8d2 <malloc+0xae>
        return 0;
 8fe:	4501                	li	a0,0
 900:	bf65                	j	8b8 <malloc+0x94>
