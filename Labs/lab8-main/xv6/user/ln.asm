
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	add	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	00f50c63          	beq	a0,a5,24 <main+0x24>
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	86058593          	add	a1,a1,-1952 # 870 <malloc+0xe4>
  18:	4509                	li	a0,2
  1a:	694000ef          	jal	6ae <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	296000ef          	jal	2b6 <exit>
  24:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  26:	698c                	ld	a1,16(a1)
  28:	6488                	ld	a0,8(s1)
  2a:	2ec000ef          	jal	316 <link>
  2e:	00054563          	bltz	a0,38 <main+0x38>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  32:	4501                	li	a0,0
  34:	282000ef          	jal	2b6 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  38:	6894                	ld	a3,16(s1)
  3a:	6490                	ld	a2,8(s1)
  3c:	00001597          	auipc	a1,0x1
  40:	84c58593          	add	a1,a1,-1972 # 888 <malloc+0xfc>
  44:	4509                	li	a0,2
  46:	668000ef          	jal	6ae <fprintf>
  4a:	b7e5                	j	32 <main+0x32>

000000000000004c <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
  4c:	1141                	add	sp,sp,-16
  4e:	e406                	sd	ra,8(sp)
  50:	e022                	sd	s0,0(sp)
  52:	0800                	add	s0,sp,16
  extern int main();
  main();
  54:	fadff0ef          	jal	0 <main>
  exit(0);
  58:	4501                	li	a0,0
  5a:	25c000ef          	jal	2b6 <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	add	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	87aa                	mv	a5,a0
  66:	0585                	add	a1,a1,1
  68:	0785                	add	a5,a5,1
  6a:	fff5c703          	lbu	a4,-1(a1)
  6e:	fee78fa3          	sb	a4,-1(a5)
  72:	fb75                	bnez	a4,66 <strcpy+0x8>
    ;
  return os;
}
  74:	6422                	ld	s0,8(sp)
  76:	0141                	add	sp,sp,16
  78:	8082                	ret

000000000000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	1141                	add	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  80:	00054783          	lbu	a5,0(a0)
  84:	cb91                	beqz	a5,98 <strcmp+0x1e>
  86:	0005c703          	lbu	a4,0(a1)
  8a:	00f71763          	bne	a4,a5,98 <strcmp+0x1e>
    p++, q++;
  8e:	0505                	add	a0,a0,1
  90:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  92:	00054783          	lbu	a5,0(a0)
  96:	fbe5                	bnez	a5,86 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  98:	0005c503          	lbu	a0,0(a1)
}
  9c:	40a7853b          	subw	a0,a5,a0
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	add	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strlen>:

uint
strlen(const char *s)
{
  a6:	1141                	add	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cf91                	beqz	a5,cc <strlen+0x26>
  b2:	0505                	add	a0,a0,1
  b4:	87aa                	mv	a5,a0
  b6:	86be                	mv	a3,a5
  b8:	0785                	add	a5,a5,1
  ba:	fff7c703          	lbu	a4,-1(a5)
  be:	ff65                	bnez	a4,b6 <strlen+0x10>
  c0:	40a6853b          	subw	a0,a3,a0
  c4:	2505                	addw	a0,a0,1
    ;
  return n;
}
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	add	sp,sp,16
  ca:	8082                	ret
  for(n = 0; s[n]; n++)
  cc:	4501                	li	a0,0
  ce:	bfe5                	j	c6 <strlen+0x20>

00000000000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	1141                	add	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d6:	ca19                	beqz	a2,ec <memset+0x1c>
  d8:	87aa                	mv	a5,a0
  da:	1602                	sll	a2,a2,0x20
  dc:	9201                	srl	a2,a2,0x20
  de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e6:	0785                	add	a5,a5,1
  e8:	fee79de3          	bne	a5,a4,e2 <memset+0x12>
  }
  return dst;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	add	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strchr>:

char*
strchr(const char *s, char c)
{
  f2:	1141                	add	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	add	s0,sp,16
  for(; *s; s++)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cb99                	beqz	a5,112 <strchr+0x20>
    if(*s == c)
  fe:	00f58763          	beq	a1,a5,10c <strchr+0x1a>
  for(; *s; s++)
 102:	0505                	add	a0,a0,1
 104:	00054783          	lbu	a5,0(a0)
 108:	fbfd                	bnez	a5,fe <strchr+0xc>
      return (char*)s;
  return 0;
 10a:	4501                	li	a0,0
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	add	sp,sp,16
 110:	8082                	ret
  return 0;
 112:	4501                	li	a0,0
 114:	bfe5                	j	10c <strchr+0x1a>

0000000000000116 <gets>:

char*
gets(char *buf, int max)
{
 116:	711d                	add	sp,sp,-96
 118:	ec86                	sd	ra,88(sp)
 11a:	e8a2                	sd	s0,80(sp)
 11c:	e4a6                	sd	s1,72(sp)
 11e:	e0ca                	sd	s2,64(sp)
 120:	fc4e                	sd	s3,56(sp)
 122:	f852                	sd	s4,48(sp)
 124:	f456                	sd	s5,40(sp)
 126:	f05a                	sd	s6,32(sp)
 128:	ec5e                	sd	s7,24(sp)
 12a:	1080                	add	s0,sp,96
 12c:	8baa                	mv	s7,a0
 12e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	892a                	mv	s2,a0
 132:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 134:	4aa9                	li	s5,10
 136:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 138:	89a6                	mv	s3,s1
 13a:	2485                	addw	s1,s1,1
 13c:	0344d663          	bge	s1,s4,168 <gets+0x52>
    cc = read(0, &c, 1);
 140:	4605                	li	a2,1
 142:	faf40593          	add	a1,s0,-81
 146:	4501                	li	a0,0
 148:	186000ef          	jal	2ce <read>
    if(cc < 1)
 14c:	00a05e63          	blez	a0,168 <gets+0x52>
    buf[i++] = c;
 150:	faf44783          	lbu	a5,-81(s0)
 154:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 158:	01578763          	beq	a5,s5,166 <gets+0x50>
 15c:	0905                	add	s2,s2,1
 15e:	fd679de3          	bne	a5,s6,138 <gets+0x22>
  for(i=0; i+1 < max; ){
 162:	89a6                	mv	s3,s1
 164:	a011                	j	168 <gets+0x52>
 166:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 168:	99de                	add	s3,s3,s7
 16a:	00098023          	sb	zero,0(s3)
  return buf;
}
 16e:	855e                	mv	a0,s7
 170:	60e6                	ld	ra,88(sp)
 172:	6446                	ld	s0,80(sp)
 174:	64a6                	ld	s1,72(sp)
 176:	6906                	ld	s2,64(sp)
 178:	79e2                	ld	s3,56(sp)
 17a:	7a42                	ld	s4,48(sp)
 17c:	7aa2                	ld	s5,40(sp)
 17e:	7b02                	ld	s6,32(sp)
 180:	6be2                	ld	s7,24(sp)
 182:	6125                	add	sp,sp,96
 184:	8082                	ret

0000000000000186 <stat>:

int
stat(const char *n, struct stat *st)
{
 186:	1101                	add	sp,sp,-32
 188:	ec06                	sd	ra,24(sp)
 18a:	e822                	sd	s0,16(sp)
 18c:	e426                	sd	s1,8(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	add	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	160000ef          	jal	2f6 <open>
  if(fd < 0)
 19a:	02054163          	bltz	a0,1bc <stat+0x36>
 19e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a0:	85ca                	mv	a1,s2
 1a2:	16c000ef          	jal	30e <fstat>
 1a6:	892a                	mv	s2,a0
  close(fd);
 1a8:	8526                	mv	a0,s1
 1aa:	134000ef          	jal	2de <close>
  return r;
}
 1ae:	854a                	mv	a0,s2
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	64a2                	ld	s1,8(sp)
 1b6:	6902                	ld	s2,0(sp)
 1b8:	6105                	add	sp,sp,32
 1ba:	8082                	ret
    return -1;
 1bc:	597d                	li	s2,-1
 1be:	bfc5                	j	1ae <stat+0x28>

00000000000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	1141                	add	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c6:	00054683          	lbu	a3,0(a0)
 1ca:	fd06879b          	addw	a5,a3,-48
 1ce:	0ff7f793          	zext.b	a5,a5
 1d2:	4625                	li	a2,9
 1d4:	02f66863          	bltu	a2,a5,204 <atoi+0x44>
 1d8:	872a                	mv	a4,a0
  n = 0;
 1da:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1dc:	0705                	add	a4,a4,1
 1de:	0025179b          	sllw	a5,a0,0x2
 1e2:	9fa9                	addw	a5,a5,a0
 1e4:	0017979b          	sllw	a5,a5,0x1
 1e8:	9fb5                	addw	a5,a5,a3
 1ea:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ee:	00074683          	lbu	a3,0(a4)
 1f2:	fd06879b          	addw	a5,a3,-48
 1f6:	0ff7f793          	zext.b	a5,a5
 1fa:	fef671e3          	bgeu	a2,a5,1dc <atoi+0x1c>
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	add	sp,sp,16
 202:	8082                	ret
  n = 0;
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <atoi+0x3e>

0000000000000208 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 208:	1141                	add	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20e:	02b57463          	bgeu	a0,a1,236 <memmove+0x2e>
    while(n-- > 0)
 212:	00c05f63          	blez	a2,230 <memmove+0x28>
 216:	1602                	sll	a2,a2,0x20
 218:	9201                	srl	a2,a2,0x20
 21a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21e:	872a                	mv	a4,a0
      *dst++ = *src++;
 220:	0585                	add	a1,a1,1
 222:	0705                	add	a4,a4,1
 224:	fff5c683          	lbu	a3,-1(a1)
 228:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 230:	6422                	ld	s0,8(sp)
 232:	0141                	add	sp,sp,16
 234:	8082                	ret
    dst += n;
 236:	00c50733          	add	a4,a0,a2
    src += n;
 23a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23c:	fec05ae3          	blez	a2,230 <memmove+0x28>
 240:	fff6079b          	addw	a5,a2,-1
 244:	1782                	sll	a5,a5,0x20
 246:	9381                	srl	a5,a5,0x20
 248:	fff7c793          	not	a5,a5
 24c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24e:	15fd                	add	a1,a1,-1
 250:	177d                	add	a4,a4,-1
 252:	0005c683          	lbu	a3,0(a1)
 256:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25a:	fee79ae3          	bne	a5,a4,24e <memmove+0x46>
 25e:	bfc9                	j	230 <memmove+0x28>

0000000000000260 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 260:	1141                	add	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 266:	ca05                	beqz	a2,296 <memcmp+0x36>
 268:	fff6069b          	addw	a3,a2,-1
 26c:	1682                	sll	a3,a3,0x20
 26e:	9281                	srl	a3,a3,0x20
 270:	0685                	add	a3,a3,1
 272:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 274:	00054783          	lbu	a5,0(a0)
 278:	0005c703          	lbu	a4,0(a1)
 27c:	00e79863          	bne	a5,a4,28c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 280:	0505                	add	a0,a0,1
    p2++;
 282:	0585                	add	a1,a1,1
  while (n-- > 0) {
 284:	fed518e3          	bne	a0,a3,274 <memcmp+0x14>
  }
  return 0;
 288:	4501                	li	a0,0
 28a:	a019                	j	290 <memcmp+0x30>
      return *p1 - *p2;
 28c:	40e7853b          	subw	a0,a5,a4
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	add	sp,sp,16
 294:	8082                	ret
  return 0;
 296:	4501                	li	a0,0
 298:	bfe5                	j	290 <memcmp+0x30>

000000000000029a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29a:	1141                	add	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2a2:	f67ff0ef          	jal	208 <memmove>
}
 2a6:	60a2                	ld	ra,8(sp)
 2a8:	6402                	ld	s0,0(sp)
 2aa:	0141                	add	sp,sp,16
 2ac:	8082                	ret

00000000000002ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ae:	4885                	li	a7,1
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b6:	4889                	li	a7,2
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <wait>:
.global wait
wait:
 li a7, SYS_wait
 2be:	488d                	li	a7,3
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c6:	4891                	li	a7,4
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <read>:
.global read
read:
 li a7, SYS_read
 2ce:	4895                	li	a7,5
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <write>:
.global write
write:
 li a7, SYS_write
 2d6:	48c1                	li	a7,16
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <close>:
.global close
close:
 li a7, SYS_close
 2de:	48d5                	li	a7,21
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e6:	4899                	li	a7,6
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ee:	489d                	li	a7,7
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <open>:
.global open
open:
 li a7, SYS_open
 2f6:	48bd                	li	a7,15
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fe:	48c5                	li	a7,17
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 306:	48c9                	li	a7,18
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30e:	48a1                	li	a7,8
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <link>:
.global link
link:
 li a7, SYS_link
 316:	48cd                	li	a7,19
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31e:	48d1                	li	a7,20
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 326:	48a5                	li	a7,9
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <dup>:
.global dup
dup:
 li a7, SYS_dup
 32e:	48a9                	li	a7,10
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 336:	48ad                	li	a7,11
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 33e:	48b1                	li	a7,12
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 346:	48b5                	li	a7,13
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34e:	48b9                	li	a7,14
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 356:	48d9                	li	a7,22
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 35e:	1101                	add	sp,sp,-32
 360:	ec06                	sd	ra,24(sp)
 362:	e822                	sd	s0,16(sp)
 364:	1000                	add	s0,sp,32
 366:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 36a:	4605                	li	a2,1
 36c:	fef40593          	add	a1,s0,-17
 370:	f67ff0ef          	jal	2d6 <write>
}
 374:	60e2                	ld	ra,24(sp)
 376:	6442                	ld	s0,16(sp)
 378:	6105                	add	sp,sp,32
 37a:	8082                	ret

000000000000037c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37c:	7139                	add	sp,sp,-64
 37e:	fc06                	sd	ra,56(sp)
 380:	f822                	sd	s0,48(sp)
 382:	f426                	sd	s1,40(sp)
 384:	f04a                	sd	s2,32(sp)
 386:	ec4e                	sd	s3,24(sp)
 388:	0080                	add	s0,sp,64
 38a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38c:	c299                	beqz	a3,392 <printint+0x16>
 38e:	0805c763          	bltz	a1,41c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 392:	2581                	sext.w	a1,a1
  neg = 0;
 394:	4881                	li	a7,0
 396:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 39a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39c:	2601                	sext.w	a2,a2
 39e:	00000517          	auipc	a0,0x0
 3a2:	50a50513          	add	a0,a0,1290 # 8a8 <digits>
 3a6:	883a                	mv	a6,a4
 3a8:	2705                	addw	a4,a4,1
 3aa:	02c5f7bb          	remuw	a5,a1,a2
 3ae:	1782                	sll	a5,a5,0x20
 3b0:	9381                	srl	a5,a5,0x20
 3b2:	97aa                	add	a5,a5,a0
 3b4:	0007c783          	lbu	a5,0(a5)
 3b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3bc:	0005879b          	sext.w	a5,a1
 3c0:	02c5d5bb          	divuw	a1,a1,a2
 3c4:	0685                	add	a3,a3,1
 3c6:	fec7f0e3          	bgeu	a5,a2,3a6 <printint+0x2a>
  if(neg)
 3ca:	00088c63          	beqz	a7,3e2 <printint+0x66>
    buf[i++] = '-';
 3ce:	fd070793          	add	a5,a4,-48
 3d2:	00878733          	add	a4,a5,s0
 3d6:	02d00793          	li	a5,45
 3da:	fef70823          	sb	a5,-16(a4)
 3de:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3e2:	02e05663          	blez	a4,40e <printint+0x92>
 3e6:	fc040793          	add	a5,s0,-64
 3ea:	00e78933          	add	s2,a5,a4
 3ee:	fff78993          	add	s3,a5,-1
 3f2:	99ba                	add	s3,s3,a4
 3f4:	377d                	addw	a4,a4,-1
 3f6:	1702                	sll	a4,a4,0x20
 3f8:	9301                	srl	a4,a4,0x20
 3fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3fe:	fff94583          	lbu	a1,-1(s2)
 402:	8526                	mv	a0,s1
 404:	f5bff0ef          	jal	35e <putc>
  while(--i >= 0)
 408:	197d                	add	s2,s2,-1
 40a:	ff391ae3          	bne	s2,s3,3fe <printint+0x82>
}
 40e:	70e2                	ld	ra,56(sp)
 410:	7442                	ld	s0,48(sp)
 412:	74a2                	ld	s1,40(sp)
 414:	7902                	ld	s2,32(sp)
 416:	69e2                	ld	s3,24(sp)
 418:	6121                	add	sp,sp,64
 41a:	8082                	ret
    x = -xx;
 41c:	40b005bb          	negw	a1,a1
    neg = 1;
 420:	4885                	li	a7,1
    x = -xx;
 422:	bf95                	j	396 <printint+0x1a>

0000000000000424 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 424:	711d                	add	sp,sp,-96
 426:	ec86                	sd	ra,88(sp)
 428:	e8a2                	sd	s0,80(sp)
 42a:	e4a6                	sd	s1,72(sp)
 42c:	e0ca                	sd	s2,64(sp)
 42e:	fc4e                	sd	s3,56(sp)
 430:	f852                	sd	s4,48(sp)
 432:	f456                	sd	s5,40(sp)
 434:	f05a                	sd	s6,32(sp)
 436:	ec5e                	sd	s7,24(sp)
 438:	e862                	sd	s8,16(sp)
 43a:	e466                	sd	s9,8(sp)
 43c:	e06a                	sd	s10,0(sp)
 43e:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 440:	0005c903          	lbu	s2,0(a1)
 444:	24090763          	beqz	s2,692 <vprintf+0x26e>
 448:	8b2a                	mv	s6,a0
 44a:	8a2e                	mv	s4,a1
 44c:	8bb2                	mv	s7,a2
  state = 0;
 44e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 450:	4481                	li	s1,0
 452:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 454:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 458:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 45c:	06c00c93          	li	s9,108
 460:	a005                	j	480 <vprintf+0x5c>
        putc(fd, c0);
 462:	85ca                	mv	a1,s2
 464:	855a                	mv	a0,s6
 466:	ef9ff0ef          	jal	35e <putc>
 46a:	a019                	j	470 <vprintf+0x4c>
    } else if(state == '%'){
 46c:	03598263          	beq	s3,s5,490 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 470:	2485                	addw	s1,s1,1
 472:	8726                	mv	a4,s1
 474:	009a07b3          	add	a5,s4,s1
 478:	0007c903          	lbu	s2,0(a5)
 47c:	20090b63          	beqz	s2,692 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 480:	0009079b          	sext.w	a5,s2
    if(state == 0){
 484:	fe0994e3          	bnez	s3,46c <vprintf+0x48>
      if(c0 == '%'){
 488:	fd579de3          	bne	a5,s5,462 <vprintf+0x3e>
        state = '%';
 48c:	89be                	mv	s3,a5
 48e:	b7cd                	j	470 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 490:	c7c9                	beqz	a5,51a <vprintf+0xf6>
 492:	00ea06b3          	add	a3,s4,a4
 496:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 49a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 49c:	c681                	beqz	a3,4a4 <vprintf+0x80>
 49e:	9752                	add	a4,a4,s4
 4a0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a4:	03878f63          	beq	a5,s8,4e2 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 4a8:	05978963          	beq	a5,s9,4fa <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ac:	07500713          	li	a4,117
 4b0:	0ee78363          	beq	a5,a4,596 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b4:	07800713          	li	a4,120
 4b8:	12e78563          	beq	a5,a4,5e2 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4bc:	07000713          	li	a4,112
 4c0:	14e78a63          	beq	a5,a4,614 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4c4:	07300713          	li	a4,115
 4c8:	18e78863          	beq	a5,a4,658 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4cc:	02500713          	li	a4,37
 4d0:	04e79563          	bne	a5,a4,51a <vprintf+0xf6>
        putc(fd, '%');
 4d4:	02500593          	li	a1,37
 4d8:	855a                	mv	a0,s6
 4da:	e85ff0ef          	jal	35e <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4de:	4981                	li	s3,0
 4e0:	bf41                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 4e2:	008b8913          	add	s2,s7,8
 4e6:	4685                	li	a3,1
 4e8:	4629                	li	a2,10
 4ea:	000ba583          	lw	a1,0(s7)
 4ee:	855a                	mv	a0,s6
 4f0:	e8dff0ef          	jal	37c <printint>
 4f4:	8bca                	mv	s7,s2
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	bfa5                	j	470 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 4fa:	06400793          	li	a5,100
 4fe:	02f68963          	beq	a3,a5,530 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 502:	06c00793          	li	a5,108
 506:	04f68263          	beq	a3,a5,54a <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 50a:	07500793          	li	a5,117
 50e:	0af68063          	beq	a3,a5,5ae <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 512:	07800793          	li	a5,120
 516:	0ef68263          	beq	a3,a5,5fa <vprintf+0x1d6>
        putc(fd, '%');
 51a:	02500593          	li	a1,37
 51e:	855a                	mv	a0,s6
 520:	e3fff0ef          	jal	35e <putc>
        putc(fd, c0);
 524:	85ca                	mv	a1,s2
 526:	855a                	mv	a0,s6
 528:	e37ff0ef          	jal	35e <putc>
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b789                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 530:	008b8913          	add	s2,s7,8
 534:	4685                	li	a3,1
 536:	4629                	li	a2,10
 538:	000ba583          	lw	a1,0(s7)
 53c:	855a                	mv	a0,s6
 53e:	e3fff0ef          	jal	37c <printint>
        i += 1;
 542:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 544:	8bca                	mv	s7,s2
      state = 0;
 546:	4981                	li	s3,0
        i += 1;
 548:	b725                	j	470 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54a:	06400793          	li	a5,100
 54e:	02f60763          	beq	a2,a5,57c <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 552:	07500793          	li	a5,117
 556:	06f60963          	beq	a2,a5,5c8 <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 55a:	07800793          	li	a5,120
 55e:	faf61ee3          	bne	a2,a5,51a <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 562:	008b8913          	add	s2,s7,8
 566:	4681                	li	a3,0
 568:	4641                	li	a2,16
 56a:	000ba583          	lw	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e0dff0ef          	jal	37c <printint>
        i += 2;
 574:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
        i += 2;
 57a:	bddd                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57c:	008b8913          	add	s2,s7,8
 580:	4685                	li	a3,1
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	df3ff0ef          	jal	37c <printint>
        i += 2;
 58e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
        i += 2;
 594:	bdf1                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 596:	008b8913          	add	s2,s7,8
 59a:	4681                	li	a3,0
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	dd9ff0ef          	jal	37c <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b5d1                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	008b8913          	add	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	dc1ff0ef          	jal	37c <printint>
        i += 1;
 5c0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
        i += 1;
 5c6:	b56d                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	add	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	da7ff0ef          	jal	37c <printint>
        i += 2;
 5da:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 2;
 5e0:	bd41                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 5e2:	008b8913          	add	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4641                	li	a2,16
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	d8dff0ef          	jal	37c <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bda5                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fa:	008b8913          	add	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	d75ff0ef          	jal	37c <printint>
        i += 1;
 60c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 1;
 612:	bdb9                	j	470 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 614:	008b8d13          	add	s10,s7,8
 618:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61c:	03000593          	li	a1,48
 620:	855a                	mv	a0,s6
 622:	d3dff0ef          	jal	35e <putc>
  putc(fd, 'x');
 626:	07800593          	li	a1,120
 62a:	855a                	mv	a0,s6
 62c:	d33ff0ef          	jal	35e <putc>
 630:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 632:	00000b97          	auipc	s7,0x0
 636:	276b8b93          	add	s7,s7,630 # 8a8 <digits>
 63a:	03c9d793          	srl	a5,s3,0x3c
 63e:	97de                	add	a5,a5,s7
 640:	0007c583          	lbu	a1,0(a5)
 644:	855a                	mv	a0,s6
 646:	d19ff0ef          	jal	35e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64a:	0992                	sll	s3,s3,0x4
 64c:	397d                	addw	s2,s2,-1
 64e:	fe0916e3          	bnez	s2,63a <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 652:	8bea                	mv	s7,s10
      state = 0;
 654:	4981                	li	s3,0
 656:	bd29                	j	470 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 658:	008b8993          	add	s3,s7,8
 65c:	000bb903          	ld	s2,0(s7)
 660:	00090f63          	beqz	s2,67e <vprintf+0x25a>
        for(; *s; s++)
 664:	00094583          	lbu	a1,0(s2)
 668:	c195                	beqz	a1,68c <vprintf+0x268>
          putc(fd, *s);
 66a:	855a                	mv	a0,s6
 66c:	cf3ff0ef          	jal	35e <putc>
        for(; *s; s++)
 670:	0905                	add	s2,s2,1
 672:	00094583          	lbu	a1,0(s2)
 676:	f9f5                	bnez	a1,66a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bbd5                	j	470 <vprintf+0x4c>
          s = "(null)";
 67e:	00000917          	auipc	s2,0x0
 682:	22290913          	add	s2,s2,546 # 8a0 <malloc+0x114>
        for(; *s; s++)
 686:	02800593          	li	a1,40
 68a:	b7c5                	j	66a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 68c:	8bce                	mv	s7,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	b3c5                	j	470 <vprintf+0x4c>
    }
  }
}
 692:	60e6                	ld	ra,88(sp)
 694:	6446                	ld	s0,80(sp)
 696:	64a6                	ld	s1,72(sp)
 698:	6906                	ld	s2,64(sp)
 69a:	79e2                	ld	s3,56(sp)
 69c:	7a42                	ld	s4,48(sp)
 69e:	7aa2                	ld	s5,40(sp)
 6a0:	7b02                	ld	s6,32(sp)
 6a2:	6be2                	ld	s7,24(sp)
 6a4:	6c42                	ld	s8,16(sp)
 6a6:	6ca2                	ld	s9,8(sp)
 6a8:	6d02                	ld	s10,0(sp)
 6aa:	6125                	add	sp,sp,96
 6ac:	8082                	ret

00000000000006ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ae:	715d                	add	sp,sp,-80
 6b0:	ec06                	sd	ra,24(sp)
 6b2:	e822                	sd	s0,16(sp)
 6b4:	1000                	add	s0,sp,32
 6b6:	e010                	sd	a2,0(s0)
 6b8:	e414                	sd	a3,8(s0)
 6ba:	e818                	sd	a4,16(s0)
 6bc:	ec1c                	sd	a5,24(s0)
 6be:	03043023          	sd	a6,32(s0)
 6c2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ca:	8622                	mv	a2,s0
 6cc:	d59ff0ef          	jal	424 <vprintf>
}
 6d0:	60e2                	ld	ra,24(sp)
 6d2:	6442                	ld	s0,16(sp)
 6d4:	6161                	add	sp,sp,80
 6d6:	8082                	ret

00000000000006d8 <printf>:

void
printf(const char *fmt, ...)
{
 6d8:	711d                	add	sp,sp,-96
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	add	s0,sp,32
 6e0:	e40c                	sd	a1,8(s0)
 6e2:	e810                	sd	a2,16(s0)
 6e4:	ec14                	sd	a3,24(s0)
 6e6:	f018                	sd	a4,32(s0)
 6e8:	f41c                	sd	a5,40(s0)
 6ea:	03043823          	sd	a6,48(s0)
 6ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f2:	00840613          	add	a2,s0,8
 6f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fa:	85aa                	mv	a1,a0
 6fc:	4505                	li	a0,1
 6fe:	d27ff0ef          	jal	424 <vprintf>
}
 702:	60e2                	ld	ra,24(sp)
 704:	6442                	ld	s0,16(sp)
 706:	6125                	add	sp,sp,96
 708:	8082                	ret

000000000000070a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70a:	1141                	add	sp,sp,-16
 70c:	e422                	sd	s0,8(sp)
 70e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 710:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	00001797          	auipc	a5,0x1
 718:	8ec7b783          	ld	a5,-1812(a5) # 1000 <freep>
 71c:	a02d                	j	746 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 71e:	4618                	lw	a4,8(a2)
 720:	9f2d                	addw	a4,a4,a1
 722:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 726:	6398                	ld	a4,0(a5)
 728:	6310                	ld	a2,0(a4)
 72a:	a83d                	j	768 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 72c:	ff852703          	lw	a4,-8(a0)
 730:	9f31                	addw	a4,a4,a2
 732:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 734:	ff053683          	ld	a3,-16(a0)
 738:	a091                	j	77c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	6398                	ld	a4,0(a5)
 73c:	00e7e463          	bltu	a5,a4,744 <free+0x3a>
 740:	00e6ea63          	bltu	a3,a4,754 <free+0x4a>
{
 744:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	fed7fae3          	bgeu	a5,a3,73a <free+0x30>
 74a:	6398                	ld	a4,0(a5)
 74c:	00e6e463          	bltu	a3,a4,754 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	fee7eae3          	bltu	a5,a4,744 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 754:	ff852583          	lw	a1,-8(a0)
 758:	6390                	ld	a2,0(a5)
 75a:	02059813          	sll	a6,a1,0x20
 75e:	01c85713          	srl	a4,a6,0x1c
 762:	9736                	add	a4,a4,a3
 764:	fae60de3          	beq	a2,a4,71e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 76c:	4790                	lw	a2,8(a5)
 76e:	02061593          	sll	a1,a2,0x20
 772:	01c5d713          	srl	a4,a1,0x1c
 776:	973e                	add	a4,a4,a5
 778:	fae68ae3          	beq	a3,a4,72c <free+0x22>
    p->s.ptr = bp->s.ptr;
 77c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77e:	00001717          	auipc	a4,0x1
 782:	88f73123          	sd	a5,-1918(a4) # 1000 <freep>
}
 786:	6422                	ld	s0,8(sp)
 788:	0141                	add	sp,sp,16
 78a:	8082                	ret

000000000000078c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78c:	7139                	add	sp,sp,-64
 78e:	fc06                	sd	ra,56(sp)
 790:	f822                	sd	s0,48(sp)
 792:	f426                	sd	s1,40(sp)
 794:	f04a                	sd	s2,32(sp)
 796:	ec4e                	sd	s3,24(sp)
 798:	e852                	sd	s4,16(sp)
 79a:	e456                	sd	s5,8(sp)
 79c:	e05a                	sd	s6,0(sp)
 79e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a0:	02051493          	sll	s1,a0,0x20
 7a4:	9081                	srl	s1,s1,0x20
 7a6:	04bd                	add	s1,s1,15
 7a8:	8091                	srl	s1,s1,0x4
 7aa:	0014899b          	addw	s3,s1,1
 7ae:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7b0:	00001517          	auipc	a0,0x1
 7b4:	85053503          	ld	a0,-1968(a0) # 1000 <freep>
 7b8:	c515                	beqz	a0,7e4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7bc:	4798                	lw	a4,8(a5)
 7be:	02977f63          	bgeu	a4,s1,7fc <malloc+0x70>
  if(nu < 4096)
 7c2:	8a4e                	mv	s4,s3
 7c4:	0009871b          	sext.w	a4,s3
 7c8:	6685                	lui	a3,0x1
 7ca:	00d77363          	bgeu	a4,a3,7d0 <malloc+0x44>
 7ce:	6a05                	lui	s4,0x1
 7d0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d8:	00001917          	auipc	s2,0x1
 7dc:	82890913          	add	s2,s2,-2008 # 1000 <freep>
  if(p == (char*)-1)
 7e0:	5afd                	li	s5,-1
 7e2:	a885                	j	852 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 7e4:	00001797          	auipc	a5,0x1
 7e8:	82c78793          	add	a5,a5,-2004 # 1010 <base>
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
 7f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7fa:	b7e1                	j	7c2 <malloc+0x36>
      if(p->s.size == nunits)
 7fc:	02e48c63          	beq	s1,a4,834 <malloc+0xa8>
        p->s.size -= nunits;
 800:	4137073b          	subw	a4,a4,s3
 804:	c798                	sw	a4,8(a5)
        p += p->s.size;
 806:	02071693          	sll	a3,a4,0x20
 80a:	01c6d713          	srl	a4,a3,0x1c
 80e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 810:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 814:	00000717          	auipc	a4,0x0
 818:	7ea73623          	sd	a0,2028(a4) # 1000 <freep>
      return (void*)(p + 1);
 81c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 820:	70e2                	ld	ra,56(sp)
 822:	7442                	ld	s0,48(sp)
 824:	74a2                	ld	s1,40(sp)
 826:	7902                	ld	s2,32(sp)
 828:	69e2                	ld	s3,24(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
 830:	6121                	add	sp,sp,64
 832:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	e118                	sd	a4,0(a0)
 838:	bff1                	j	814 <malloc+0x88>
  hp->s.size = nu;
 83a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 83e:	0541                	add	a0,a0,16
 840:	ecbff0ef          	jal	70a <free>
  return freep;
 844:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 848:	dd61                	beqz	a0,820 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	fa9777e3          	bgeu	a4,s1,7fc <malloc+0x70>
    if(p == freep)
 852:	00093703          	ld	a4,0(s2)
 856:	853e                	mv	a0,a5
 858:	fef719e3          	bne	a4,a5,84a <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 85c:	8552                	mv	a0,s4
 85e:	ae1ff0ef          	jal	33e <sbrk>
  if(p == (char*)-1)
 862:	fd551ce3          	bne	a0,s5,83a <malloc+0xae>
        return 0;
 866:	4501                	li	a0,0
 868:	bf65                	j	820 <malloc+0x94>
