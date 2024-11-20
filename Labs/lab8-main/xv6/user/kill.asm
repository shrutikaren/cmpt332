
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	19c000ef          	jal	1c4 <atoi>
  2c:	2be000ef          	jal	2ea <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	add	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	282000ef          	jal	2ba <exit>
    fprintf(2, "usage: kill pid...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	83458593          	add	a1,a1,-1996 # 870 <malloc+0xe0>
  44:	4509                	li	a0,2
  46:	66c000ef          	jal	6b2 <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	26e000ef          	jal	2ba <exit>

0000000000000050 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
  50:	1141                	add	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	add	s0,sp,16
  extern int main();
  main();
  58:	fa9ff0ef          	jal	0 <main>
  exit(0);
  5c:	4501                	li	a0,0
  5e:	25c000ef          	jal	2ba <exit>

0000000000000062 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  62:	1141                	add	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	add	a1,a1,1
  6c:	0785                	add	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0x8>
    ;
  return os;
}
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	add	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	add	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	cb91                	beqz	a5,9c <strcmp+0x1e>
  8a:	0005c703          	lbu	a4,0(a1)
  8e:	00f71763          	bne	a4,a5,9c <strcmp+0x1e>
    p++, q++;
  92:	0505                	add	a0,a0,1
  94:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	fbe5                	bnez	a5,8a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9c:	0005c503          	lbu	a0,0(a1)
}
  a0:	40a7853b          	subw	a0,a5,a0
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	add	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	1141                	add	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf91                	beqz	a5,d0 <strlen+0x26>
  b6:	0505                	add	a0,a0,1
  b8:	87aa                	mv	a5,a0
  ba:	86be                	mv	a3,a5
  bc:	0785                	add	a5,a5,1
  be:	fff7c703          	lbu	a4,-1(a5)
  c2:	ff65                	bnez	a4,ba <strlen+0x10>
  c4:	40a6853b          	subw	a0,a3,a0
  c8:	2505                	addw	a0,a0,1
    ;
  return n;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	add	sp,sp,16
  ce:	8082                	ret
  for(n = 0; s[n]; n++)
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strlen+0x20>

00000000000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	1141                	add	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  da:	ca19                	beqz	a2,f0 <memset+0x1c>
  dc:	87aa                	mv	a5,a0
  de:	1602                	sll	a2,a2,0x20
  e0:	9201                	srl	a2,a2,0x20
  e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ea:	0785                	add	a5,a5,1
  ec:	fee79de3          	bne	a5,a4,e6 <memset+0x12>
  }
  return dst;
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	add	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strchr>:

char*
strchr(const char *s, char c)
{
  f6:	1141                	add	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	add	s0,sp,16
  for(; *s; s++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cb99                	beqz	a5,116 <strchr+0x20>
    if(*s == c)
 102:	00f58763          	beq	a1,a5,110 <strchr+0x1a>
  for(; *s; s++)
 106:	0505                	add	a0,a0,1
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbfd                	bnez	a5,102 <strchr+0xc>
      return (char*)s;
  return 0;
 10e:	4501                	li	a0,0
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret
  return 0;
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strchr+0x1a>

000000000000011a <gets>:

char*
gets(char *buf, int max)
{
 11a:	711d                	add	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	1080                	add	s0,sp,96
 130:	8baa                	mv	s7,a0
 132:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 134:	892a                	mv	s2,a0
 136:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 138:	4aa9                	li	s5,10
 13a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13c:	89a6                	mv	s3,s1
 13e:	2485                	addw	s1,s1,1
 140:	0344d663          	bge	s1,s4,16c <gets+0x52>
    cc = read(0, &c, 1);
 144:	4605                	li	a2,1
 146:	faf40593          	add	a1,s0,-81
 14a:	4501                	li	a0,0
 14c:	186000ef          	jal	2d2 <read>
    if(cc < 1)
 150:	00a05e63          	blez	a0,16c <gets+0x52>
    buf[i++] = c;
 154:	faf44783          	lbu	a5,-81(s0)
 158:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15c:	01578763          	beq	a5,s5,16a <gets+0x50>
 160:	0905                	add	s2,s2,1
 162:	fd679de3          	bne	a5,s6,13c <gets+0x22>
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	a011                	j	16c <gets+0x52>
 16a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16c:	99de                	add	s3,s3,s7
 16e:	00098023          	sb	zero,0(s3)
  return buf;
}
 172:	855e                	mv	a0,s7
 174:	60e6                	ld	ra,88(sp)
 176:	6446                	ld	s0,80(sp)
 178:	64a6                	ld	s1,72(sp)
 17a:	6906                	ld	s2,64(sp)
 17c:	79e2                	ld	s3,56(sp)
 17e:	7a42                	ld	s4,48(sp)
 180:	7aa2                	ld	s5,40(sp)
 182:	7b02                	ld	s6,32(sp)
 184:	6be2                	ld	s7,24(sp)
 186:	6125                	add	sp,sp,96
 188:	8082                	ret

000000000000018a <stat>:

int
stat(const char *n, struct stat *st)
{
 18a:	1101                	add	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	e04a                	sd	s2,0(sp)
 194:	1000                	add	s0,sp,32
 196:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	4581                	li	a1,0
 19a:	160000ef          	jal	2fa <open>
  if(fd < 0)
 19e:	02054163          	bltz	a0,1c0 <stat+0x36>
 1a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a4:	85ca                	mv	a1,s2
 1a6:	16c000ef          	jal	312 <fstat>
 1aa:	892a                	mv	s2,a0
  close(fd);
 1ac:	8526                	mv	a0,s1
 1ae:	134000ef          	jal	2e2 <close>
  return r;
}
 1b2:	854a                	mv	a0,s2
 1b4:	60e2                	ld	ra,24(sp)
 1b6:	6442                	ld	s0,16(sp)
 1b8:	64a2                	ld	s1,8(sp)
 1ba:	6902                	ld	s2,0(sp)
 1bc:	6105                	add	sp,sp,32
 1be:	8082                	ret
    return -1;
 1c0:	597d                	li	s2,-1
 1c2:	bfc5                	j	1b2 <stat+0x28>

00000000000001c4 <atoi>:

int
atoi(const char *s)
{
 1c4:	1141                	add	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ca:	00054683          	lbu	a3,0(a0)
 1ce:	fd06879b          	addw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	4625                	li	a2,9
 1d8:	02f66863          	bltu	a2,a5,208 <atoi+0x44>
 1dc:	872a                	mv	a4,a0
  n = 0;
 1de:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e0:	0705                	add	a4,a4,1
 1e2:	0025179b          	sllw	a5,a0,0x2
 1e6:	9fa9                	addw	a5,a5,a0
 1e8:	0017979b          	sllw	a5,a5,0x1
 1ec:	9fb5                	addw	a5,a5,a3
 1ee:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f2:	00074683          	lbu	a3,0(a4)
 1f6:	fd06879b          	addw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	fef671e3          	bgeu	a2,a5,1e0 <atoi+0x1c>
  return n;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	add	sp,sp,16
 206:	8082                	ret
  n = 0;
 208:	4501                	li	a0,0
 20a:	bfe5                	j	202 <atoi+0x3e>

000000000000020c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20c:	1141                	add	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 212:	02b57463          	bgeu	a0,a1,23a <memmove+0x2e>
    while(n-- > 0)
 216:	00c05f63          	blez	a2,234 <memmove+0x28>
 21a:	1602                	sll	a2,a2,0x20
 21c:	9201                	srl	a2,a2,0x20
 21e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 222:	872a                	mv	a4,a0
      *dst++ = *src++;
 224:	0585                	add	a1,a1,1
 226:	0705                	add	a4,a4,1
 228:	fff5c683          	lbu	a3,-1(a1)
 22c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 230:	fee79ae3          	bne	a5,a4,224 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	add	sp,sp,16
 238:	8082                	ret
    dst += n;
 23a:	00c50733          	add	a4,a0,a2
    src += n;
 23e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 240:	fec05ae3          	blez	a2,234 <memmove+0x28>
 244:	fff6079b          	addw	a5,a2,-1
 248:	1782                	sll	a5,a5,0x20
 24a:	9381                	srl	a5,a5,0x20
 24c:	fff7c793          	not	a5,a5
 250:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 252:	15fd                	add	a1,a1,-1
 254:	177d                	add	a4,a4,-1
 256:	0005c683          	lbu	a3,0(a1)
 25a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25e:	fee79ae3          	bne	a5,a4,252 <memmove+0x46>
 262:	bfc9                	j	234 <memmove+0x28>

0000000000000264 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 264:	1141                	add	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26a:	ca05                	beqz	a2,29a <memcmp+0x36>
 26c:	fff6069b          	addw	a3,a2,-1
 270:	1682                	sll	a3,a3,0x20
 272:	9281                	srl	a3,a3,0x20
 274:	0685                	add	a3,a3,1
 276:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 278:	00054783          	lbu	a5,0(a0)
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00e79863          	bne	a5,a4,290 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 284:	0505                	add	a0,a0,1
    p2++;
 286:	0585                	add	a1,a1,1
  while (n-- > 0) {
 288:	fed518e3          	bne	a0,a3,278 <memcmp+0x14>
  }
  return 0;
 28c:	4501                	li	a0,0
 28e:	a019                	j	294 <memcmp+0x30>
      return *p1 - *p2;
 290:	40e7853b          	subw	a0,a5,a4
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	add	sp,sp,16
 298:	8082                	ret
  return 0;
 29a:	4501                	li	a0,0
 29c:	bfe5                	j	294 <memcmp+0x30>

000000000000029e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29e:	1141                	add	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2a6:	f67ff0ef          	jal	20c <memmove>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	add	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b2:	4885                	li	a7,1
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ba:	4889                	li	a7,2
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c2:	488d                	li	a7,3
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ca:	4891                	li	a7,4
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <read>:
.global read
read:
 li a7, SYS_read
 2d2:	4895                	li	a7,5
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <write>:
.global write
write:
 li a7, SYS_write
 2da:	48c1                	li	a7,16
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <close>:
.global close
close:
 li a7, SYS_close
 2e2:	48d5                	li	a7,21
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ea:	4899                	li	a7,6
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f2:	489d                	li	a7,7
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <open>:
.global open
open:
 li a7, SYS_open
 2fa:	48bd                	li	a7,15
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 302:	48c5                	li	a7,17
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30a:	48c9                	li	a7,18
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 312:	48a1                	li	a7,8
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <link>:
.global link
link:
 li a7, SYS_link
 31a:	48cd                	li	a7,19
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 322:	48d1                	li	a7,20
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32a:	48a5                	li	a7,9
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <dup>:
.global dup
dup:
 li a7, SYS_dup
 332:	48a9                	li	a7,10
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33a:	48ad                	li	a7,11
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 342:	48b1                	li	a7,12
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34a:	48b5                	li	a7,13
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 352:	48b9                	li	a7,14
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 35a:	48d9                	li	a7,22
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 362:	1101                	add	sp,sp,-32
 364:	ec06                	sd	ra,24(sp)
 366:	e822                	sd	s0,16(sp)
 368:	1000                	add	s0,sp,32
 36a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36e:	4605                	li	a2,1
 370:	fef40593          	add	a1,s0,-17
 374:	f67ff0ef          	jal	2da <write>
}
 378:	60e2                	ld	ra,24(sp)
 37a:	6442                	ld	s0,16(sp)
 37c:	6105                	add	sp,sp,32
 37e:	8082                	ret

0000000000000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	7139                	add	sp,sp,-64
 382:	fc06                	sd	ra,56(sp)
 384:	f822                	sd	s0,48(sp)
 386:	f426                	sd	s1,40(sp)
 388:	f04a                	sd	s2,32(sp)
 38a:	ec4e                	sd	s3,24(sp)
 38c:	0080                	add	s0,sp,64
 38e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 390:	c299                	beqz	a3,396 <printint+0x16>
 392:	0805c763          	bltz	a1,420 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 396:	2581                	sext.w	a1,a1
  neg = 0;
 398:	4881                	li	a7,0
 39a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 39e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a0:	2601                	sext.w	a2,a2
 3a2:	00000517          	auipc	a0,0x0
 3a6:	4ee50513          	add	a0,a0,1262 # 890 <digits>
 3aa:	883a                	mv	a6,a4
 3ac:	2705                	addw	a4,a4,1
 3ae:	02c5f7bb          	remuw	a5,a1,a2
 3b2:	1782                	sll	a5,a5,0x20
 3b4:	9381                	srl	a5,a5,0x20
 3b6:	97aa                	add	a5,a5,a0
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c0:	0005879b          	sext.w	a5,a1
 3c4:	02c5d5bb          	divuw	a1,a1,a2
 3c8:	0685                	add	a3,a3,1
 3ca:	fec7f0e3          	bgeu	a5,a2,3aa <printint+0x2a>
  if(neg)
 3ce:	00088c63          	beqz	a7,3e6 <printint+0x66>
    buf[i++] = '-';
 3d2:	fd070793          	add	a5,a4,-48
 3d6:	00878733          	add	a4,a5,s0
 3da:	02d00793          	li	a5,45
 3de:	fef70823          	sb	a5,-16(a4)
 3e2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3e6:	02e05663          	blez	a4,412 <printint+0x92>
 3ea:	fc040793          	add	a5,s0,-64
 3ee:	00e78933          	add	s2,a5,a4
 3f2:	fff78993          	add	s3,a5,-1
 3f6:	99ba                	add	s3,s3,a4
 3f8:	377d                	addw	a4,a4,-1
 3fa:	1702                	sll	a4,a4,0x20
 3fc:	9301                	srl	a4,a4,0x20
 3fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 402:	fff94583          	lbu	a1,-1(s2)
 406:	8526                	mv	a0,s1
 408:	f5bff0ef          	jal	362 <putc>
  while(--i >= 0)
 40c:	197d                	add	s2,s2,-1
 40e:	ff391ae3          	bne	s2,s3,402 <printint+0x82>
}
 412:	70e2                	ld	ra,56(sp)
 414:	7442                	ld	s0,48(sp)
 416:	74a2                	ld	s1,40(sp)
 418:	7902                	ld	s2,32(sp)
 41a:	69e2                	ld	s3,24(sp)
 41c:	6121                	add	sp,sp,64
 41e:	8082                	ret
    x = -xx;
 420:	40b005bb          	negw	a1,a1
    neg = 1;
 424:	4885                	li	a7,1
    x = -xx;
 426:	bf95                	j	39a <printint+0x1a>

0000000000000428 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 428:	711d                	add	sp,sp,-96
 42a:	ec86                	sd	ra,88(sp)
 42c:	e8a2                	sd	s0,80(sp)
 42e:	e4a6                	sd	s1,72(sp)
 430:	e0ca                	sd	s2,64(sp)
 432:	fc4e                	sd	s3,56(sp)
 434:	f852                	sd	s4,48(sp)
 436:	f456                	sd	s5,40(sp)
 438:	f05a                	sd	s6,32(sp)
 43a:	ec5e                	sd	s7,24(sp)
 43c:	e862                	sd	s8,16(sp)
 43e:	e466                	sd	s9,8(sp)
 440:	e06a                	sd	s10,0(sp)
 442:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 444:	0005c903          	lbu	s2,0(a1)
 448:	24090763          	beqz	s2,696 <vprintf+0x26e>
 44c:	8b2a                	mv	s6,a0
 44e:	8a2e                	mv	s4,a1
 450:	8bb2                	mv	s7,a2
  state = 0;
 452:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 454:	4481                	li	s1,0
 456:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 458:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 45c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 460:	06c00c93          	li	s9,108
 464:	a005                	j	484 <vprintf+0x5c>
        putc(fd, c0);
 466:	85ca                	mv	a1,s2
 468:	855a                	mv	a0,s6
 46a:	ef9ff0ef          	jal	362 <putc>
 46e:	a019                	j	474 <vprintf+0x4c>
    } else if(state == '%'){
 470:	03598263          	beq	s3,s5,494 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 474:	2485                	addw	s1,s1,1
 476:	8726                	mv	a4,s1
 478:	009a07b3          	add	a5,s4,s1
 47c:	0007c903          	lbu	s2,0(a5)
 480:	20090b63          	beqz	s2,696 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 484:	0009079b          	sext.w	a5,s2
    if(state == 0){
 488:	fe0994e3          	bnez	s3,470 <vprintf+0x48>
      if(c0 == '%'){
 48c:	fd579de3          	bne	a5,s5,466 <vprintf+0x3e>
        state = '%';
 490:	89be                	mv	s3,a5
 492:	b7cd                	j	474 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 494:	c7c9                	beqz	a5,51e <vprintf+0xf6>
 496:	00ea06b3          	add	a3,s4,a4
 49a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 49e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4a0:	c681                	beqz	a3,4a8 <vprintf+0x80>
 4a2:	9752                	add	a4,a4,s4
 4a4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a8:	03878f63          	beq	a5,s8,4e6 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 4ac:	05978963          	beq	a5,s9,4fe <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b0:	07500713          	li	a4,117
 4b4:	0ee78363          	beq	a5,a4,59a <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b8:	07800713          	li	a4,120
 4bc:	12e78563          	beq	a5,a4,5e6 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4c0:	07000713          	li	a4,112
 4c4:	14e78a63          	beq	a5,a4,618 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4c8:	07300713          	li	a4,115
 4cc:	18e78863          	beq	a5,a4,65c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4d0:	02500713          	li	a4,37
 4d4:	04e79563          	bne	a5,a4,51e <vprintf+0xf6>
        putc(fd, '%');
 4d8:	02500593          	li	a1,37
 4dc:	855a                	mv	a0,s6
 4de:	e85ff0ef          	jal	362 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4e2:	4981                	li	s3,0
 4e4:	bf41                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 4e6:	008b8913          	add	s2,s7,8
 4ea:	4685                	li	a3,1
 4ec:	4629                	li	a2,10
 4ee:	000ba583          	lw	a1,0(s7)
 4f2:	855a                	mv	a0,s6
 4f4:	e8dff0ef          	jal	380 <printint>
 4f8:	8bca                	mv	s7,s2
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	bfa5                	j	474 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 4fe:	06400793          	li	a5,100
 502:	02f68963          	beq	a3,a5,534 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 506:	06c00793          	li	a5,108
 50a:	04f68263          	beq	a3,a5,54e <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 50e:	07500793          	li	a5,117
 512:	0af68063          	beq	a3,a5,5b2 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 516:	07800793          	li	a5,120
 51a:	0ef68263          	beq	a3,a5,5fe <vprintf+0x1d6>
        putc(fd, '%');
 51e:	02500593          	li	a1,37
 522:	855a                	mv	a0,s6
 524:	e3fff0ef          	jal	362 <putc>
        putc(fd, c0);
 528:	85ca                	mv	a1,s2
 52a:	855a                	mv	a0,s6
 52c:	e37ff0ef          	jal	362 <putc>
      state = 0;
 530:	4981                	li	s3,0
 532:	b789                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 534:	008b8913          	add	s2,s7,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000ba583          	lw	a1,0(s7)
 540:	855a                	mv	a0,s6
 542:	e3fff0ef          	jal	380 <printint>
        i += 1;
 546:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 548:	8bca                	mv	s7,s2
      state = 0;
 54a:	4981                	li	s3,0
        i += 1;
 54c:	b725                	j	474 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54e:	06400793          	li	a5,100
 552:	02f60763          	beq	a2,a5,580 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 556:	07500793          	li	a5,117
 55a:	06f60963          	beq	a2,a5,5cc <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 55e:	07800793          	li	a5,120
 562:	faf61ee3          	bne	a2,a5,51e <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 566:	008b8913          	add	s2,s7,8
 56a:	4681                	li	a3,0
 56c:	4641                	li	a2,16
 56e:	000ba583          	lw	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	e0dff0ef          	jal	380 <printint>
        i += 2;
 578:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
        i += 2;
 57e:	bddd                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 580:	008b8913          	add	s2,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	df3ff0ef          	jal	380 <printint>
        i += 2;
 592:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	8bca                	mv	s7,s2
      state = 0;
 596:	4981                	li	s3,0
        i += 2;
 598:	bdf1                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 59a:	008b8913          	add	s2,s7,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000ba583          	lw	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	dd9ff0ef          	jal	380 <printint>
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b5d1                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b2:	008b8913          	add	s2,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	dc1ff0ef          	jal	380 <printint>
        i += 1;
 5c4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
        i += 1;
 5ca:	b56d                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	008b8913          	add	s2,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4629                	li	a2,10
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	da7ff0ef          	jal	380 <printint>
        i += 2;
 5de:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
        i += 2;
 5e4:	bd41                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 5e6:	008b8913          	add	s2,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4641                	li	a2,16
 5ee:	000ba583          	lw	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	d8dff0ef          	jal	380 <printint>
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bda5                	j	474 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fe:	008b8913          	add	s2,s7,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	d75ff0ef          	jal	380 <printint>
        i += 1;
 610:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	bdb9                	j	474 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 618:	008b8d13          	add	s10,s7,8
 61c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 620:	03000593          	li	a1,48
 624:	855a                	mv	a0,s6
 626:	d3dff0ef          	jal	362 <putc>
  putc(fd, 'x');
 62a:	07800593          	li	a1,120
 62e:	855a                	mv	a0,s6
 630:	d33ff0ef          	jal	362 <putc>
 634:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 636:	00000b97          	auipc	s7,0x0
 63a:	25ab8b93          	add	s7,s7,602 # 890 <digits>
 63e:	03c9d793          	srl	a5,s3,0x3c
 642:	97de                	add	a5,a5,s7
 644:	0007c583          	lbu	a1,0(a5)
 648:	855a                	mv	a0,s6
 64a:	d19ff0ef          	jal	362 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64e:	0992                	sll	s3,s3,0x4
 650:	397d                	addw	s2,s2,-1
 652:	fe0916e3          	bnez	s2,63e <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 656:	8bea                	mv	s7,s10
      state = 0;
 658:	4981                	li	s3,0
 65a:	bd29                	j	474 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 65c:	008b8993          	add	s3,s7,8
 660:	000bb903          	ld	s2,0(s7)
 664:	00090f63          	beqz	s2,682 <vprintf+0x25a>
        for(; *s; s++)
 668:	00094583          	lbu	a1,0(s2)
 66c:	c195                	beqz	a1,690 <vprintf+0x268>
          putc(fd, *s);
 66e:	855a                	mv	a0,s6
 670:	cf3ff0ef          	jal	362 <putc>
        for(; *s; s++)
 674:	0905                	add	s2,s2,1
 676:	00094583          	lbu	a1,0(s2)
 67a:	f9f5                	bnez	a1,66e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 67c:	8bce                	mv	s7,s3
      state = 0;
 67e:	4981                	li	s3,0
 680:	bbd5                	j	474 <vprintf+0x4c>
          s = "(null)";
 682:	00000917          	auipc	s2,0x0
 686:	20690913          	add	s2,s2,518 # 888 <malloc+0xf8>
        for(; *s; s++)
 68a:	02800593          	li	a1,40
 68e:	b7c5                	j	66e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 690:	8bce                	mv	s7,s3
      state = 0;
 692:	4981                	li	s3,0
 694:	b3c5                	j	474 <vprintf+0x4c>
    }
  }
}
 696:	60e6                	ld	ra,88(sp)
 698:	6446                	ld	s0,80(sp)
 69a:	64a6                	ld	s1,72(sp)
 69c:	6906                	ld	s2,64(sp)
 69e:	79e2                	ld	s3,56(sp)
 6a0:	7a42                	ld	s4,48(sp)
 6a2:	7aa2                	ld	s5,40(sp)
 6a4:	7b02                	ld	s6,32(sp)
 6a6:	6be2                	ld	s7,24(sp)
 6a8:	6c42                	ld	s8,16(sp)
 6aa:	6ca2                	ld	s9,8(sp)
 6ac:	6d02                	ld	s10,0(sp)
 6ae:	6125                	add	sp,sp,96
 6b0:	8082                	ret

00000000000006b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b2:	715d                	add	sp,sp,-80
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	add	s0,sp,32
 6ba:	e010                	sd	a2,0(s0)
 6bc:	e414                	sd	a3,8(s0)
 6be:	e818                	sd	a4,16(s0)
 6c0:	ec1c                	sd	a5,24(s0)
 6c2:	03043023          	sd	a6,32(s0)
 6c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ce:	8622                	mv	a2,s0
 6d0:	d59ff0ef          	jal	428 <vprintf>
}
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	6161                	add	sp,sp,80
 6da:	8082                	ret

00000000000006dc <printf>:

void
printf(const char *fmt, ...)
{
 6dc:	711d                	add	sp,sp,-96
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	add	s0,sp,32
 6e4:	e40c                	sd	a1,8(s0)
 6e6:	e810                	sd	a2,16(s0)
 6e8:	ec14                	sd	a3,24(s0)
 6ea:	f018                	sd	a4,32(s0)
 6ec:	f41c                	sd	a5,40(s0)
 6ee:	03043823          	sd	a6,48(s0)
 6f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	00840613          	add	a2,s0,8
 6fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fe:	85aa                	mv	a1,a0
 700:	4505                	li	a0,1
 702:	d27ff0ef          	jal	428 <vprintf>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6125                	add	sp,sp,96
 70c:	8082                	ret

000000000000070e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70e:	1141                	add	sp,sp,-16
 710:	e422                	sd	s0,8(sp)
 712:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 714:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	00001797          	auipc	a5,0x1
 71c:	8e87b783          	ld	a5,-1816(a5) # 1000 <freep>
 720:	a02d                	j	74a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 722:	4618                	lw	a4,8(a2)
 724:	9f2d                	addw	a4,a4,a1
 726:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 72a:	6398                	ld	a4,0(a5)
 72c:	6310                	ld	a2,0(a4)
 72e:	a83d                	j	76c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 730:	ff852703          	lw	a4,-8(a0)
 734:	9f31                	addw	a4,a4,a2
 736:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 738:	ff053683          	ld	a3,-16(a0)
 73c:	a091                	j	780 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73e:	6398                	ld	a4,0(a5)
 740:	00e7e463          	bltu	a5,a4,748 <free+0x3a>
 744:	00e6ea63          	bltu	a3,a4,758 <free+0x4a>
{
 748:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	fed7fae3          	bgeu	a5,a3,73e <free+0x30>
 74e:	6398                	ld	a4,0(a5)
 750:	00e6e463          	bltu	a3,a4,758 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 754:	fee7eae3          	bltu	a5,a4,748 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 758:	ff852583          	lw	a1,-8(a0)
 75c:	6390                	ld	a2,0(a5)
 75e:	02059813          	sll	a6,a1,0x20
 762:	01c85713          	srl	a4,a6,0x1c
 766:	9736                	add	a4,a4,a3
 768:	fae60de3          	beq	a2,a4,722 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 76c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 770:	4790                	lw	a2,8(a5)
 772:	02061593          	sll	a1,a2,0x20
 776:	01c5d713          	srl	a4,a1,0x1c
 77a:	973e                	add	a4,a4,a5
 77c:	fae68ae3          	beq	a3,a4,730 <free+0x22>
    p->s.ptr = bp->s.ptr;
 780:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 782:	00001717          	auipc	a4,0x1
 786:	86f73f23          	sd	a5,-1922(a4) # 1000 <freep>
}
 78a:	6422                	ld	s0,8(sp)
 78c:	0141                	add	sp,sp,16
 78e:	8082                	ret

0000000000000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	7139                	add	sp,sp,-64
 792:	fc06                	sd	ra,56(sp)
 794:	f822                	sd	s0,48(sp)
 796:	f426                	sd	s1,40(sp)
 798:	f04a                	sd	s2,32(sp)
 79a:	ec4e                	sd	s3,24(sp)
 79c:	e852                	sd	s4,16(sp)
 79e:	e456                	sd	s5,8(sp)
 7a0:	e05a                	sd	s6,0(sp)
 7a2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a4:	02051493          	sll	s1,a0,0x20
 7a8:	9081                	srl	s1,s1,0x20
 7aa:	04bd                	add	s1,s1,15
 7ac:	8091                	srl	s1,s1,0x4
 7ae:	0014899b          	addw	s3,s1,1
 7b2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7b4:	00001517          	auipc	a0,0x1
 7b8:	84c53503          	ld	a0,-1972(a0) # 1000 <freep>
 7bc:	c515                	beqz	a0,7e8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c0:	4798                	lw	a4,8(a5)
 7c2:	02977f63          	bgeu	a4,s1,800 <malloc+0x70>
  if(nu < 4096)
 7c6:	8a4e                	mv	s4,s3
 7c8:	0009871b          	sext.w	a4,s3
 7cc:	6685                	lui	a3,0x1
 7ce:	00d77363          	bgeu	a4,a3,7d4 <malloc+0x44>
 7d2:	6a05                	lui	s4,0x1
 7d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d8:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7dc:	00001917          	auipc	s2,0x1
 7e0:	82490913          	add	s2,s2,-2012 # 1000 <freep>
  if(p == (char*)-1)
 7e4:	5afd                	li	s5,-1
 7e6:	a885                	j	856 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 7e8:	00001797          	auipc	a5,0x1
 7ec:	82878793          	add	a5,a5,-2008 # 1010 <base>
 7f0:	00001717          	auipc	a4,0x1
 7f4:	80f73823          	sd	a5,-2032(a4) # 1000 <freep>
 7f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7fe:	b7e1                	j	7c6 <malloc+0x36>
      if(p->s.size == nunits)
 800:	02e48c63          	beq	s1,a4,838 <malloc+0xa8>
        p->s.size -= nunits;
 804:	4137073b          	subw	a4,a4,s3
 808:	c798                	sw	a4,8(a5)
        p += p->s.size;
 80a:	02071693          	sll	a3,a4,0x20
 80e:	01c6d713          	srl	a4,a3,0x1c
 812:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 814:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 818:	00000717          	auipc	a4,0x0
 81c:	7ea73423          	sd	a0,2024(a4) # 1000 <freep>
      return (void*)(p + 1);
 820:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 824:	70e2                	ld	ra,56(sp)
 826:	7442                	ld	s0,48(sp)
 828:	74a2                	ld	s1,40(sp)
 82a:	7902                	ld	s2,32(sp)
 82c:	69e2                	ld	s3,24(sp)
 82e:	6a42                	ld	s4,16(sp)
 830:	6aa2                	ld	s5,8(sp)
 832:	6b02                	ld	s6,0(sp)
 834:	6121                	add	sp,sp,64
 836:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 838:	6398                	ld	a4,0(a5)
 83a:	e118                	sd	a4,0(a0)
 83c:	bff1                	j	818 <malloc+0x88>
  hp->s.size = nu;
 83e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 842:	0541                	add	a0,a0,16
 844:	ecbff0ef          	jal	70e <free>
  return freep;
 848:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 84c:	dd61                	beqz	a0,824 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 850:	4798                	lw	a4,8(a5)
 852:	fa9777e3          	bgeu	a4,s1,800 <malloc+0x70>
    if(p == freep)
 856:	00093703          	ld	a4,0(s2)
 85a:	853e                	mv	a0,a5
 85c:	fef719e3          	bne	a4,a5,84e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 860:	8552                	mv	a0,s4
 862:	ae1ff0ef          	jal	342 <sbrk>
  if(p == (char*)-1)
 866:	fd551ce3          	bne	a0,s5,83e <malloc+0xae>
        return 0;
 86a:	4501                	li	a0,0
 86c:	bf65                	j	824 <malloc+0x94>
