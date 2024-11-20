
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if(fork() > 0)
   8:	278000ef          	jal	280 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  /* Let child exit before parent. */
  exit(0);
  10:	4501                	li	a0,0
  12:	276000ef          	jal	288 <exit>
    sleep(5);  /* Let child exit before parent. */
  16:	4515                	li	a0,5
  18:	300000ef          	jal	318 <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
  1e:	1141                	add	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	add	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	25c000ef          	jal	288 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	add	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	add	a1,a1,1
  3a:	0785                	add	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	add	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	add	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	add	a0,a0,1
  62:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	add	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	add	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	add	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	add	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	add	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	add	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	sll	a2,a2,0x20
  ae:	9201                	srl	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	add	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	add	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	add	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	add	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	add	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	add	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	add	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	add	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	add	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	186000ef          	jal	2a0 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	add	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	add	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	add	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e426                	sd	s1,8(sp)
 160:	e04a                	sd	s2,0(sp)
 162:	1000                	add	s0,sp,32
 164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 166:	4581                	li	a1,0
 168:	160000ef          	jal	2c8 <open>
  if(fd < 0)
 16c:	02054163          	bltz	a0,18e <stat+0x36>
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	16c000ef          	jal	2e0 <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	134000ef          	jal	2b0 <close>
  return r;
}
 180:	854a                	mv	a0,s2
 182:	60e2                	ld	ra,24(sp)
 184:	6442                	ld	s0,16(sp)
 186:	64a2                	ld	s1,8(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	add	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfc5                	j	180 <stat+0x28>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	add	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	add	a4,a4,1
 1b0:	0025179b          	sllw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	sllw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	add	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	add	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	sll	a2,a2,0x20
 1ea:	9201                	srl	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	add	a1,a1,1
 1f4:	0705                	add	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fee79ae3          	bne	a5,a4,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	add	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addw	a5,a2,-1
 216:	1782                	sll	a5,a5,0x20
 218:	9381                	srl	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	add	a1,a1,-1
 222:	177d                	add	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	add	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addw	a3,a2,-1
 23e:	1682                	sll	a3,a3,0x20
 240:	9281                	srl	a3,a3,0x20
 242:	0685                	add	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	add	a0,a0,1
    p2++;
 254:	0585                	add	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	add	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	add	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	add	sp,sp,16
 27e:	8082                	ret

0000000000000280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 280:	4885                	li	a7,1
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <exit>:
.global exit
exit:
 li a7, SYS_exit
 288:	4889                	li	a7,2
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <wait>:
.global wait
wait:
 li a7, SYS_wait
 290:	488d                	li	a7,3
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 298:	4891                	li	a7,4
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <read>:
.global read
read:
 li a7, SYS_read
 2a0:	4895                	li	a7,5
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <write>:
.global write
write:
 li a7, SYS_write
 2a8:	48c1                	li	a7,16
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <close>:
.global close
close:
 li a7, SYS_close
 2b0:	48d5                	li	a7,21
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b8:	4899                	li	a7,6
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c0:	489d                	li	a7,7
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <open>:
.global open
open:
 li a7, SYS_open
 2c8:	48bd                	li	a7,15
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d0:	48c5                	li	a7,17
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d8:	48c9                	li	a7,18
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e0:	48a1                	li	a7,8
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <link>:
.global link
link:
 li a7, SYS_link
 2e8:	48cd                	li	a7,19
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f0:	48d1                	li	a7,20
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f8:	48a5                	li	a7,9
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <dup>:
.global dup
dup:
 li a7, SYS_dup
 300:	48a9                	li	a7,10
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48ad                	li	a7,11
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 310:	48b1                	li	a7,12
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 318:	48b5                	li	a7,13
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 320:	48b9                	li	a7,14
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 328:	48d9                	li	a7,22
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 330:	1101                	add	sp,sp,-32
 332:	ec06                	sd	ra,24(sp)
 334:	e822                	sd	s0,16(sp)
 336:	1000                	add	s0,sp,32
 338:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 33c:	4605                	li	a2,1
 33e:	fef40593          	add	a1,s0,-17
 342:	f67ff0ef          	jal	2a8 <write>
}
 346:	60e2                	ld	ra,24(sp)
 348:	6442                	ld	s0,16(sp)
 34a:	6105                	add	sp,sp,32
 34c:	8082                	ret

000000000000034e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 34e:	7139                	add	sp,sp,-64
 350:	fc06                	sd	ra,56(sp)
 352:	f822                	sd	s0,48(sp)
 354:	f426                	sd	s1,40(sp)
 356:	f04a                	sd	s2,32(sp)
 358:	ec4e                	sd	s3,24(sp)
 35a:	0080                	add	s0,sp,64
 35c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35e:	c299                	beqz	a3,364 <printint+0x16>
 360:	0805c763          	bltz	a1,3ee <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 364:	2581                	sext.w	a1,a1
  neg = 0;
 366:	4881                	li	a7,0
 368:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 36c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 36e:	2601                	sext.w	a2,a2
 370:	00000517          	auipc	a0,0x0
 374:	4d850513          	add	a0,a0,1240 # 848 <digits>
 378:	883a                	mv	a6,a4
 37a:	2705                	addw	a4,a4,1
 37c:	02c5f7bb          	remuw	a5,a1,a2
 380:	1782                	sll	a5,a5,0x20
 382:	9381                	srl	a5,a5,0x20
 384:	97aa                	add	a5,a5,a0
 386:	0007c783          	lbu	a5,0(a5)
 38a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 38e:	0005879b          	sext.w	a5,a1
 392:	02c5d5bb          	divuw	a1,a1,a2
 396:	0685                	add	a3,a3,1
 398:	fec7f0e3          	bgeu	a5,a2,378 <printint+0x2a>
  if(neg)
 39c:	00088c63          	beqz	a7,3b4 <printint+0x66>
    buf[i++] = '-';
 3a0:	fd070793          	add	a5,a4,-48
 3a4:	00878733          	add	a4,a5,s0
 3a8:	02d00793          	li	a5,45
 3ac:	fef70823          	sb	a5,-16(a4)
 3b0:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3b4:	02e05663          	blez	a4,3e0 <printint+0x92>
 3b8:	fc040793          	add	a5,s0,-64
 3bc:	00e78933          	add	s2,a5,a4
 3c0:	fff78993          	add	s3,a5,-1
 3c4:	99ba                	add	s3,s3,a4
 3c6:	377d                	addw	a4,a4,-1
 3c8:	1702                	sll	a4,a4,0x20
 3ca:	9301                	srl	a4,a4,0x20
 3cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3d0:	fff94583          	lbu	a1,-1(s2)
 3d4:	8526                	mv	a0,s1
 3d6:	f5bff0ef          	jal	330 <putc>
  while(--i >= 0)
 3da:	197d                	add	s2,s2,-1
 3dc:	ff391ae3          	bne	s2,s3,3d0 <printint+0x82>
}
 3e0:	70e2                	ld	ra,56(sp)
 3e2:	7442                	ld	s0,48(sp)
 3e4:	74a2                	ld	s1,40(sp)
 3e6:	7902                	ld	s2,32(sp)
 3e8:	69e2                	ld	s3,24(sp)
 3ea:	6121                	add	sp,sp,64
 3ec:	8082                	ret
    x = -xx;
 3ee:	40b005bb          	negw	a1,a1
    neg = 1;
 3f2:	4885                	li	a7,1
    x = -xx;
 3f4:	bf95                	j	368 <printint+0x1a>

00000000000003f6 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3f6:	711d                	add	sp,sp,-96
 3f8:	ec86                	sd	ra,88(sp)
 3fa:	e8a2                	sd	s0,80(sp)
 3fc:	e4a6                	sd	s1,72(sp)
 3fe:	e0ca                	sd	s2,64(sp)
 400:	fc4e                	sd	s3,56(sp)
 402:	f852                	sd	s4,48(sp)
 404:	f456                	sd	s5,40(sp)
 406:	f05a                	sd	s6,32(sp)
 408:	ec5e                	sd	s7,24(sp)
 40a:	e862                	sd	s8,16(sp)
 40c:	e466                	sd	s9,8(sp)
 40e:	e06a                	sd	s10,0(sp)
 410:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 412:	0005c903          	lbu	s2,0(a1)
 416:	24090763          	beqz	s2,664 <vprintf+0x26e>
 41a:	8b2a                	mv	s6,a0
 41c:	8a2e                	mv	s4,a1
 41e:	8bb2                	mv	s7,a2
  state = 0;
 420:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 422:	4481                	li	s1,0
 424:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 426:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 42a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 42e:	06c00c93          	li	s9,108
 432:	a005                	j	452 <vprintf+0x5c>
        putc(fd, c0);
 434:	85ca                	mv	a1,s2
 436:	855a                	mv	a0,s6
 438:	ef9ff0ef          	jal	330 <putc>
 43c:	a019                	j	442 <vprintf+0x4c>
    } else if(state == '%'){
 43e:	03598263          	beq	s3,s5,462 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 442:	2485                	addw	s1,s1,1
 444:	8726                	mv	a4,s1
 446:	009a07b3          	add	a5,s4,s1
 44a:	0007c903          	lbu	s2,0(a5)
 44e:	20090b63          	beqz	s2,664 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 452:	0009079b          	sext.w	a5,s2
    if(state == 0){
 456:	fe0994e3          	bnez	s3,43e <vprintf+0x48>
      if(c0 == '%'){
 45a:	fd579de3          	bne	a5,s5,434 <vprintf+0x3e>
        state = '%';
 45e:	89be                	mv	s3,a5
 460:	b7cd                	j	442 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 462:	c7c9                	beqz	a5,4ec <vprintf+0xf6>
 464:	00ea06b3          	add	a3,s4,a4
 468:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 46c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 46e:	c681                	beqz	a3,476 <vprintf+0x80>
 470:	9752                	add	a4,a4,s4
 472:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 476:	03878f63          	beq	a5,s8,4b4 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 47a:	05978963          	beq	a5,s9,4cc <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 47e:	07500713          	li	a4,117
 482:	0ee78363          	beq	a5,a4,568 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 486:	07800713          	li	a4,120
 48a:	12e78563          	beq	a5,a4,5b4 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 48e:	07000713          	li	a4,112
 492:	14e78a63          	beq	a5,a4,5e6 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 496:	07300713          	li	a4,115
 49a:	18e78863          	beq	a5,a4,62a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 49e:	02500713          	li	a4,37
 4a2:	04e79563          	bne	a5,a4,4ec <vprintf+0xf6>
        putc(fd, '%');
 4a6:	02500593          	li	a1,37
 4aa:	855a                	mv	a0,s6
 4ac:	e85ff0ef          	jal	330 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4b0:	4981                	li	s3,0
 4b2:	bf41                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 4b4:	008b8913          	add	s2,s7,8
 4b8:	4685                	li	a3,1
 4ba:	4629                	li	a2,10
 4bc:	000ba583          	lw	a1,0(s7)
 4c0:	855a                	mv	a0,s6
 4c2:	e8dff0ef          	jal	34e <printint>
 4c6:	8bca                	mv	s7,s2
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	bfa5                	j	442 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 4cc:	06400793          	li	a5,100
 4d0:	02f68963          	beq	a3,a5,502 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4d4:	06c00793          	li	a5,108
 4d8:	04f68263          	beq	a3,a5,51c <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 4dc:	07500793          	li	a5,117
 4e0:	0af68063          	beq	a3,a5,580 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 4e4:	07800793          	li	a5,120
 4e8:	0ef68263          	beq	a3,a5,5cc <vprintf+0x1d6>
        putc(fd, '%');
 4ec:	02500593          	li	a1,37
 4f0:	855a                	mv	a0,s6
 4f2:	e3fff0ef          	jal	330 <putc>
        putc(fd, c0);
 4f6:	85ca                	mv	a1,s2
 4f8:	855a                	mv	a0,s6
 4fa:	e37ff0ef          	jal	330 <putc>
      state = 0;
 4fe:	4981                	li	s3,0
 500:	b789                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 502:	008b8913          	add	s2,s7,8
 506:	4685                	li	a3,1
 508:	4629                	li	a2,10
 50a:	000ba583          	lw	a1,0(s7)
 50e:	855a                	mv	a0,s6
 510:	e3fff0ef          	jal	34e <printint>
        i += 1;
 514:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 516:	8bca                	mv	s7,s2
      state = 0;
 518:	4981                	li	s3,0
        i += 1;
 51a:	b725                	j	442 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51c:	06400793          	li	a5,100
 520:	02f60763          	beq	a2,a5,54e <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 524:	07500793          	li	a5,117
 528:	06f60963          	beq	a2,a5,59a <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 52c:	07800793          	li	a5,120
 530:	faf61ee3          	bne	a2,a5,4ec <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 534:	008b8913          	add	s2,s7,8
 538:	4681                	li	a3,0
 53a:	4641                	li	a2,16
 53c:	000ba583          	lw	a1,0(s7)
 540:	855a                	mv	a0,s6
 542:	e0dff0ef          	jal	34e <printint>
        i += 2;
 546:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 548:	8bca                	mv	s7,s2
      state = 0;
 54a:	4981                	li	s3,0
        i += 2;
 54c:	bddd                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54e:	008b8913          	add	s2,s7,8
 552:	4685                	li	a3,1
 554:	4629                	li	a2,10
 556:	000ba583          	lw	a1,0(s7)
 55a:	855a                	mv	a0,s6
 55c:	df3ff0ef          	jal	34e <printint>
        i += 2;
 560:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 562:	8bca                	mv	s7,s2
      state = 0;
 564:	4981                	li	s3,0
        i += 2;
 566:	bdf1                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 568:	008b8913          	add	s2,s7,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	dd9ff0ef          	jal	34e <printint>
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b5d1                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 580:	008b8913          	add	s2,s7,8
 584:	4681                	li	a3,0
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	dc1ff0ef          	jal	34e <printint>
        i += 1;
 592:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 594:	8bca                	mv	s7,s2
      state = 0;
 596:	4981                	li	s3,0
        i += 1;
 598:	b56d                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	008b8913          	add	s2,s7,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000ba583          	lw	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	da7ff0ef          	jal	34e <printint>
        i += 2;
 5ac:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	8bca                	mv	s7,s2
      state = 0;
 5b0:	4981                	li	s3,0
        i += 2;
 5b2:	bd41                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 5b4:	008b8913          	add	s2,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4641                	li	a2,16
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	d8dff0ef          	jal	34e <printint>
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bda5                	j	442 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	008b8913          	add	s2,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4641                	li	a2,16
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	d75ff0ef          	jal	34e <printint>
        i += 1;
 5de:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
        i += 1;
 5e4:	bdb9                	j	442 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 5e6:	008b8d13          	add	s10,s7,8
 5ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ee:	03000593          	li	a1,48
 5f2:	855a                	mv	a0,s6
 5f4:	d3dff0ef          	jal	330 <putc>
  putc(fd, 'x');
 5f8:	07800593          	li	a1,120
 5fc:	855a                	mv	a0,s6
 5fe:	d33ff0ef          	jal	330 <putc>
 602:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 604:	00000b97          	auipc	s7,0x0
 608:	244b8b93          	add	s7,s7,580 # 848 <digits>
 60c:	03c9d793          	srl	a5,s3,0x3c
 610:	97de                	add	a5,a5,s7
 612:	0007c583          	lbu	a1,0(a5)
 616:	855a                	mv	a0,s6
 618:	d19ff0ef          	jal	330 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61c:	0992                	sll	s3,s3,0x4
 61e:	397d                	addw	s2,s2,-1
 620:	fe0916e3          	bnez	s2,60c <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 624:	8bea                	mv	s7,s10
      state = 0;
 626:	4981                	li	s3,0
 628:	bd29                	j	442 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 62a:	008b8993          	add	s3,s7,8
 62e:	000bb903          	ld	s2,0(s7)
 632:	00090f63          	beqz	s2,650 <vprintf+0x25a>
        for(; *s; s++)
 636:	00094583          	lbu	a1,0(s2)
 63a:	c195                	beqz	a1,65e <vprintf+0x268>
          putc(fd, *s);
 63c:	855a                	mv	a0,s6
 63e:	cf3ff0ef          	jal	330 <putc>
        for(; *s; s++)
 642:	0905                	add	s2,s2,1
 644:	00094583          	lbu	a1,0(s2)
 648:	f9f5                	bnez	a1,63c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 64a:	8bce                	mv	s7,s3
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bbd5                	j	442 <vprintf+0x4c>
          s = "(null)";
 650:	00000917          	auipc	s2,0x0
 654:	1f090913          	add	s2,s2,496 # 840 <malloc+0xe2>
        for(; *s; s++)
 658:	02800593          	li	a1,40
 65c:	b7c5                	j	63c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 65e:	8bce                	mv	s7,s3
      state = 0;
 660:	4981                	li	s3,0
 662:	b3c5                	j	442 <vprintf+0x4c>
    }
  }
}
 664:	60e6                	ld	ra,88(sp)
 666:	6446                	ld	s0,80(sp)
 668:	64a6                	ld	s1,72(sp)
 66a:	6906                	ld	s2,64(sp)
 66c:	79e2                	ld	s3,56(sp)
 66e:	7a42                	ld	s4,48(sp)
 670:	7aa2                	ld	s5,40(sp)
 672:	7b02                	ld	s6,32(sp)
 674:	6be2                	ld	s7,24(sp)
 676:	6c42                	ld	s8,16(sp)
 678:	6ca2                	ld	s9,8(sp)
 67a:	6d02                	ld	s10,0(sp)
 67c:	6125                	add	sp,sp,96
 67e:	8082                	ret

0000000000000680 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 680:	715d                	add	sp,sp,-80
 682:	ec06                	sd	ra,24(sp)
 684:	e822                	sd	s0,16(sp)
 686:	1000                	add	s0,sp,32
 688:	e010                	sd	a2,0(s0)
 68a:	e414                	sd	a3,8(s0)
 68c:	e818                	sd	a4,16(s0)
 68e:	ec1c                	sd	a5,24(s0)
 690:	03043023          	sd	a6,32(s0)
 694:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 698:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 69c:	8622                	mv	a2,s0
 69e:	d59ff0ef          	jal	3f6 <vprintf>
}
 6a2:	60e2                	ld	ra,24(sp)
 6a4:	6442                	ld	s0,16(sp)
 6a6:	6161                	add	sp,sp,80
 6a8:	8082                	ret

00000000000006aa <printf>:

void
printf(const char *fmt, ...)
{
 6aa:	711d                	add	sp,sp,-96
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	add	s0,sp,32
 6b2:	e40c                	sd	a1,8(s0)
 6b4:	e810                	sd	a2,16(s0)
 6b6:	ec14                	sd	a3,24(s0)
 6b8:	f018                	sd	a4,32(s0)
 6ba:	f41c                	sd	a5,40(s0)
 6bc:	03043823          	sd	a6,48(s0)
 6c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c4:	00840613          	add	a2,s0,8
 6c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6cc:	85aa                	mv	a1,a0
 6ce:	4505                	li	a0,1
 6d0:	d27ff0ef          	jal	3f6 <vprintf>
}
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	6125                	add	sp,sp,96
 6da:	8082                	ret

00000000000006dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6dc:	1141                	add	sp,sp,-16
 6de:	e422                	sd	s0,8(sp)
 6e0:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e2:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e6:	00001797          	auipc	a5,0x1
 6ea:	91a7b783          	ld	a5,-1766(a5) # 1000 <freep>
 6ee:	a02d                	j	718 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f0:	4618                	lw	a4,8(a2)
 6f2:	9f2d                	addw	a4,a4,a1
 6f4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	6398                	ld	a4,0(a5)
 6fa:	6310                	ld	a2,0(a4)
 6fc:	a83d                	j	73a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6fe:	ff852703          	lw	a4,-8(a0)
 702:	9f31                	addw	a4,a4,a2
 704:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 706:	ff053683          	ld	a3,-16(a0)
 70a:	a091                	j	74e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70c:	6398                	ld	a4,0(a5)
 70e:	00e7e463          	bltu	a5,a4,716 <free+0x3a>
 712:	00e6ea63          	bltu	a3,a4,726 <free+0x4a>
{
 716:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	fed7fae3          	bgeu	a5,a3,70c <free+0x30>
 71c:	6398                	ld	a4,0(a5)
 71e:	00e6e463          	bltu	a3,a4,726 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	fee7eae3          	bltu	a5,a4,716 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 726:	ff852583          	lw	a1,-8(a0)
 72a:	6390                	ld	a2,0(a5)
 72c:	02059813          	sll	a6,a1,0x20
 730:	01c85713          	srl	a4,a6,0x1c
 734:	9736                	add	a4,a4,a3
 736:	fae60de3          	beq	a2,a4,6f0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 73a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73e:	4790                	lw	a2,8(a5)
 740:	02061593          	sll	a1,a2,0x20
 744:	01c5d713          	srl	a4,a1,0x1c
 748:	973e                	add	a4,a4,a5
 74a:	fae68ae3          	beq	a3,a4,6fe <free+0x22>
    p->s.ptr = bp->s.ptr;
 74e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 750:	00001717          	auipc	a4,0x1
 754:	8af73823          	sd	a5,-1872(a4) # 1000 <freep>
}
 758:	6422                	ld	s0,8(sp)
 75a:	0141                	add	sp,sp,16
 75c:	8082                	ret

000000000000075e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75e:	7139                	add	sp,sp,-64
 760:	fc06                	sd	ra,56(sp)
 762:	f822                	sd	s0,48(sp)
 764:	f426                	sd	s1,40(sp)
 766:	f04a                	sd	s2,32(sp)
 768:	ec4e                	sd	s3,24(sp)
 76a:	e852                	sd	s4,16(sp)
 76c:	e456                	sd	s5,8(sp)
 76e:	e05a                	sd	s6,0(sp)
 770:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	02051493          	sll	s1,a0,0x20
 776:	9081                	srl	s1,s1,0x20
 778:	04bd                	add	s1,s1,15
 77a:	8091                	srl	s1,s1,0x4
 77c:	0014899b          	addw	s3,s1,1
 780:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 782:	00001517          	auipc	a0,0x1
 786:	87e53503          	ld	a0,-1922(a0) # 1000 <freep>
 78a:	c515                	beqz	a0,7b6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78e:	4798                	lw	a4,8(a5)
 790:	02977f63          	bgeu	a4,s1,7ce <malloc+0x70>
  if(nu < 4096)
 794:	8a4e                	mv	s4,s3
 796:	0009871b          	sext.w	a4,s3
 79a:	6685                	lui	a3,0x1
 79c:	00d77363          	bgeu	a4,a3,7a2 <malloc+0x44>
 7a0:	6a05                	lui	s4,0x1
 7a2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a6:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7aa:	00001917          	auipc	s2,0x1
 7ae:	85690913          	add	s2,s2,-1962 # 1000 <freep>
  if(p == (char*)-1)
 7b2:	5afd                	li	s5,-1
 7b4:	a885                	j	824 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 7b6:	00001797          	auipc	a5,0x1
 7ba:	85a78793          	add	a5,a5,-1958 # 1010 <base>
 7be:	00001717          	auipc	a4,0x1
 7c2:	84f73123          	sd	a5,-1982(a4) # 1000 <freep>
 7c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7cc:	b7e1                	j	794 <malloc+0x36>
      if(p->s.size == nunits)
 7ce:	02e48c63          	beq	s1,a4,806 <malloc+0xa8>
        p->s.size -= nunits;
 7d2:	4137073b          	subw	a4,a4,s3
 7d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d8:	02071693          	sll	a3,a4,0x20
 7dc:	01c6d713          	srl	a4,a3,0x1c
 7e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e6:	00001717          	auipc	a4,0x1
 7ea:	80a73d23          	sd	a0,-2022(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ee:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f2:	70e2                	ld	ra,56(sp)
 7f4:	7442                	ld	s0,48(sp)
 7f6:	74a2                	ld	s1,40(sp)
 7f8:	7902                	ld	s2,32(sp)
 7fa:	69e2                	ld	s3,24(sp)
 7fc:	6a42                	ld	s4,16(sp)
 7fe:	6aa2                	ld	s5,8(sp)
 800:	6b02                	ld	s6,0(sp)
 802:	6121                	add	sp,sp,64
 804:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 806:	6398                	ld	a4,0(a5)
 808:	e118                	sd	a4,0(a0)
 80a:	bff1                	j	7e6 <malloc+0x88>
  hp->s.size = nu;
 80c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 810:	0541                	add	a0,a0,16
 812:	ecbff0ef          	jal	6dc <free>
  return freep;
 816:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81a:	dd61                	beqz	a0,7f2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	fa9777e3          	bgeu	a4,s1,7ce <malloc+0x70>
    if(p == freep)
 824:	00093703          	ld	a4,0(s2)
 828:	853e                	mv	a0,a5
 82a:	fef719e3          	bne	a4,a5,81c <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 82e:	8552                	mv	a0,s4
 830:	ae1ff0ef          	jal	310 <sbrk>
  if(p == (char*)-1)
 834:	fd551ce3          	bne	a0,s5,80c <malloc+0xae>
        return 0;
 838:	4501                	li	a0,0
 83a:	bf65                	j	7f2 <malloc+0x94>
