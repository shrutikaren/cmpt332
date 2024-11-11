
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	add	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d863          	bge	a5,a0,84 <main+0x84>
  18:	00858493          	add	s1,a1,8
  1c:	3579                	addw	a0,a0,-2
  1e:	02051793          	sll	a5,a0,0x20
  22:	01d7d513          	srl	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	add	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	8f0a8a93          	add	s5,s5,-1808 # 920 <malloc+0xea>
  38:	a819                	j	4e <main+0x4e>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	2f4080e7          	jalr	756(ra) # 334 <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	add	s1,s1,8
  4a:	03348d63          	beq	s1,s3,84 <main+0x84>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	00000097          	auipc	ra,0x0
  58:	09c080e7          	jalr	156(ra) # f0 <strlen>
  5c:	0005061b          	sext.w	a2,a0
  60:	85ca                	mv	a1,s2
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	2d0080e7          	jalr	720(ra) # 334 <write>
    if(i + 1 < argc){
  6c:	fd4497e3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  70:	4605                	li	a2,1
  72:	00001597          	auipc	a1,0x1
  76:	8b658593          	add	a1,a1,-1866 # 928 <malloc+0xf2>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2b8080e7          	jalr	696(ra) # 334 <write>
    }
  }
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	28e080e7          	jalr	654(ra) # 314 <exit>

000000000000008e <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
  8e:	1141                	add	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	add	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	274080e7          	jalr	628(ra) # 314 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	add	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	add	a1,a1,1
  b2:	0785                	add	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0x8>
    ;
  return os;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	add	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	1141                	add	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb91                	beqz	a5,e2 <strcmp+0x1e>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71763          	bne	a4,a5,e2 <strcmp+0x1e>
    p++, q++;
  d8:	0505                	add	a0,a0,1
  da:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbe5                	bnez	a5,d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e2:	0005c503          	lbu	a0,0(a1)
}
  e6:	40a7853b          	subw	a0,a5,a0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	add	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	1141                	add	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cf91                	beqz	a5,116 <strlen+0x26>
  fc:	0505                	add	a0,a0,1
  fe:	87aa                	mv	a5,a0
 100:	86be                	mv	a3,a5
 102:	0785                	add	a5,a5,1
 104:	fff7c703          	lbu	a4,-1(a5)
 108:	ff65                	bnez	a4,100 <strlen+0x10>
 10a:	40a6853b          	subw	a0,a3,a0
 10e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret
  for(n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strlen+0x20>

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	1141                	add	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1c>
 122:	87aa                	mv	a5,a0
 124:	1602                	sll	a2,a2,0x20
 126:	9201                	srl	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	add	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x12>
  }
  return dst;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	add	sp,sp,16
 13a:	8082                	ret

000000000000013c <strchr>:

char*
strchr(const char *s, char c)
{
 13c:	1141                	add	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	add	s0,sp,16
  for(; *s; s++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cb99                	beqz	a5,15c <strchr+0x20>
    if(*s == c)
 148:	00f58763          	beq	a1,a5,156 <strchr+0x1a>
  for(; *s; s++)
 14c:	0505                	add	a0,a0,1
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbfd                	bnez	a5,148 <strchr+0xc>
      return (char*)s;
  return 0;
 154:	4501                	li	a0,0
}
 156:	6422                	ld	s0,8(sp)
 158:	0141                	add	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfe5                	j	156 <strchr+0x1a>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	711d                	add	sp,sp,-96
 162:	ec86                	sd	ra,88(sp)
 164:	e8a2                	sd	s0,80(sp)
 166:	e4a6                	sd	s1,72(sp)
 168:	e0ca                	sd	s2,64(sp)
 16a:	fc4e                	sd	s3,56(sp)
 16c:	f852                	sd	s4,48(sp)
 16e:	f456                	sd	s5,40(sp)
 170:	f05a                	sd	s6,32(sp)
 172:	ec5e                	sd	s7,24(sp)
 174:	1080                	add	s0,sp,96
 176:	8baa                	mv	s7,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17e:	4aa9                	li	s5,10
 180:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 182:	89a6                	mv	s3,s1
 184:	2485                	addw	s1,s1,1
 186:	0344d863          	bge	s1,s4,1b6 <gets+0x56>
    cc = read(0, &c, 1);
 18a:	4605                	li	a2,1
 18c:	faf40593          	add	a1,s0,-81
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	19a080e7          	jalr	410(ra) # 32c <read>
    if(cc < 1)
 19a:	00a05e63          	blez	a0,1b6 <gets+0x56>
    buf[i++] = c;
 19e:	faf44783          	lbu	a5,-81(s0)
 1a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a6:	01578763          	beq	a5,s5,1b4 <gets+0x54>
 1aa:	0905                	add	s2,s2,1
 1ac:	fd679be3          	bne	a5,s6,182 <gets+0x22>
  for(i=0; i+1 < max; ){
 1b0:	89a6                	mv	s3,s1
 1b2:	a011                	j	1b6 <gets+0x56>
 1b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b6:	99de                	add	s3,s3,s7
 1b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1bc:	855e                	mv	a0,s7
 1be:	60e6                	ld	ra,88(sp)
 1c0:	6446                	ld	s0,80(sp)
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	6906                	ld	s2,64(sp)
 1c6:	79e2                	ld	s3,56(sp)
 1c8:	7a42                	ld	s4,48(sp)
 1ca:	7aa2                	ld	s5,40(sp)
 1cc:	7b02                	ld	s6,32(sp)
 1ce:	6be2                	ld	s7,24(sp)
 1d0:	6125                	add	sp,sp,96
 1d2:	8082                	ret

00000000000001d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d4:	1101                	add	sp,sp,-32
 1d6:	ec06                	sd	ra,24(sp)
 1d8:	e822                	sd	s0,16(sp)
 1da:	e426                	sd	s1,8(sp)
 1dc:	e04a                	sd	s2,0(sp)
 1de:	1000                	add	s0,sp,32
 1e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e2:	4581                	li	a1,0
 1e4:	00000097          	auipc	ra,0x0
 1e8:	170080e7          	jalr	368(ra) # 354 <open>
  if(fd < 0)
 1ec:	02054563          	bltz	a0,216 <stat+0x42>
 1f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f2:	85ca                	mv	a1,s2
 1f4:	00000097          	auipc	ra,0x0
 1f8:	178080e7          	jalr	376(ra) # 36c <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	00000097          	auipc	ra,0x0
 204:	13c080e7          	jalr	316(ra) # 33c <close>
  return r;
}
 208:	854a                	mv	a0,s2
 20a:	60e2                	ld	ra,24(sp)
 20c:	6442                	ld	s0,16(sp)
 20e:	64a2                	ld	s1,8(sp)
 210:	6902                	ld	s2,0(sp)
 212:	6105                	add	sp,sp,32
 214:	8082                	ret
    return -1;
 216:	597d                	li	s2,-1
 218:	bfc5                	j	208 <stat+0x34>

000000000000021a <atoi>:

int
atoi(const char *s)
{
 21a:	1141                	add	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 220:	00054683          	lbu	a3,0(a0)
 224:	fd06879b          	addw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	4625                	li	a2,9
 22e:	02f66863          	bltu	a2,a5,25e <atoi+0x44>
 232:	872a                	mv	a4,a0
  n = 0;
 234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 236:	0705                	add	a4,a4,1
 238:	0025179b          	sllw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	sllw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00074683          	lbu	a3,0(a4)
 24c:	fd06879b          	addw	a5,a3,-48
 250:	0ff7f793          	zext.b	a5,a5
 254:	fef671e3          	bgeu	a2,a5,236 <atoi+0x1c>
  return n;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	add	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <atoi+0x3e>

0000000000000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	add	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 268:	02b57463          	bgeu	a0,a1,290 <memmove+0x2e>
    while(n-- > 0)
 26c:	00c05f63          	blez	a2,28a <memmove+0x28>
 270:	1602                	sll	a2,a2,0x20
 272:	9201                	srl	a2,a2,0x20
 274:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 278:	872a                	mv	a4,a0
      *dst++ = *src++;
 27a:	0585                	add	a1,a1,1
 27c:	0705                	add	a4,a4,1
 27e:	fff5c683          	lbu	a3,-1(a1)
 282:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	add	sp,sp,16
 28e:	8082                	ret
    dst += n;
 290:	00c50733          	add	a4,a0,a2
    src += n;
 294:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 296:	fec05ae3          	blez	a2,28a <memmove+0x28>
 29a:	fff6079b          	addw	a5,a2,-1
 29e:	1782                	sll	a5,a5,0x20
 2a0:	9381                	srl	a5,a5,0x20
 2a2:	fff7c793          	not	a5,a5
 2a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a8:	15fd                	add	a1,a1,-1
 2aa:	177d                	add	a4,a4,-1
 2ac:	0005c683          	lbu	a3,0(a1)
 2b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x46>
 2b8:	bfc9                	j	28a <memmove+0x28>

00000000000002ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ba:	1141                	add	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c0:	ca05                	beqz	a2,2f0 <memcmp+0x36>
 2c2:	fff6069b          	addw	a3,a2,-1
 2c6:	1682                	sll	a3,a3,0x20
 2c8:	9281                	srl	a3,a3,0x20
 2ca:	0685                	add	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00e79863          	bne	a5,a4,2e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2da:	0505                	add	a0,a0,1
    p2++;
 2dc:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2de:	fed518e3          	bne	a0,a3,2ce <memcmp+0x14>
  }
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	a019                	j	2ea <memcmp+0x30>
      return *p1 - *p2;
 2e6:	40e7853b          	subw	a0,a5,a4
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	add	sp,sp,16
 2ee:	8082                	ret
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <memcmp+0x30>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	add	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2fc:	00000097          	auipc	ra,0x0
 300:	f66080e7          	jalr	-154(ra) # 262 <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	add	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b4:	1101                	add	sp,sp,-32
 3b6:	ec06                	sd	ra,24(sp)
 3b8:	e822                	sd	s0,16(sp)
 3ba:	1000                	add	s0,sp,32
 3bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c0:	4605                	li	a2,1
 3c2:	fef40593          	add	a1,s0,-17
 3c6:	00000097          	auipc	ra,0x0
 3ca:	f6e080e7          	jalr	-146(ra) # 334 <write>
}
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6105                	add	sp,sp,32
 3d4:	8082                	ret

00000000000003d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d6:	7139                	add	sp,sp,-64
 3d8:	fc06                	sd	ra,56(sp)
 3da:	f822                	sd	s0,48(sp)
 3dc:	f426                	sd	s1,40(sp)
 3de:	f04a                	sd	s2,32(sp)
 3e0:	ec4e                	sd	s3,24(sp)
 3e2:	0080                	add	s0,sp,64
 3e4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e6:	c299                	beqz	a3,3ec <printint+0x16>
 3e8:	0805c963          	bltz	a1,47a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ec:	2581                	sext.w	a1,a1
  neg = 0;
 3ee:	4881                	li	a7,0
 3f0:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f6:	2601                	sext.w	a2,a2
 3f8:	00000517          	auipc	a0,0x0
 3fc:	54050513          	add	a0,a0,1344 # 938 <digits>
 400:	883a                	mv	a6,a4
 402:	2705                	addw	a4,a4,1
 404:	02c5f7bb          	remuw	a5,a1,a2
 408:	1782                	sll	a5,a5,0x20
 40a:	9381                	srl	a5,a5,0x20
 40c:	97aa                	add	a5,a5,a0
 40e:	0007c783          	lbu	a5,0(a5)
 412:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 416:	0005879b          	sext.w	a5,a1
 41a:	02c5d5bb          	divuw	a1,a1,a2
 41e:	0685                	add	a3,a3,1
 420:	fec7f0e3          	bgeu	a5,a2,400 <printint+0x2a>
  if(neg)
 424:	00088c63          	beqz	a7,43c <printint+0x66>
    buf[i++] = '-';
 428:	fd070793          	add	a5,a4,-48
 42c:	00878733          	add	a4,a5,s0
 430:	02d00793          	li	a5,45
 434:	fef70823          	sb	a5,-16(a4)
 438:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 43c:	02e05863          	blez	a4,46c <printint+0x96>
 440:	fc040793          	add	a5,s0,-64
 444:	00e78933          	add	s2,a5,a4
 448:	fff78993          	add	s3,a5,-1
 44c:	99ba                	add	s3,s3,a4
 44e:	377d                	addw	a4,a4,-1
 450:	1702                	sll	a4,a4,0x20
 452:	9301                	srl	a4,a4,0x20
 454:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 458:	fff94583          	lbu	a1,-1(s2)
 45c:	8526                	mv	a0,s1
 45e:	00000097          	auipc	ra,0x0
 462:	f56080e7          	jalr	-170(ra) # 3b4 <putc>
  while(--i >= 0)
 466:	197d                	add	s2,s2,-1
 468:	ff3918e3          	bne	s2,s3,458 <printint+0x82>
}
 46c:	70e2                	ld	ra,56(sp)
 46e:	7442                	ld	s0,48(sp)
 470:	74a2                	ld	s1,40(sp)
 472:	7902                	ld	s2,32(sp)
 474:	69e2                	ld	s3,24(sp)
 476:	6121                	add	sp,sp,64
 478:	8082                	ret
    x = -xx;
 47a:	40b005bb          	negw	a1,a1
    neg = 1;
 47e:	4885                	li	a7,1
    x = -xx;
 480:	bf85                	j	3f0 <printint+0x1a>

0000000000000482 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 482:	711d                	add	sp,sp,-96
 484:	ec86                	sd	ra,88(sp)
 486:	e8a2                	sd	s0,80(sp)
 488:	e4a6                	sd	s1,72(sp)
 48a:	e0ca                	sd	s2,64(sp)
 48c:	fc4e                	sd	s3,56(sp)
 48e:	f852                	sd	s4,48(sp)
 490:	f456                	sd	s5,40(sp)
 492:	f05a                	sd	s6,32(sp)
 494:	ec5e                	sd	s7,24(sp)
 496:	e862                	sd	s8,16(sp)
 498:	e466                	sd	s9,8(sp)
 49a:	e06a                	sd	s10,0(sp)
 49c:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49e:	0005c903          	lbu	s2,0(a1)
 4a2:	28090963          	beqz	s2,734 <vprintf+0x2b2>
 4a6:	8b2a                	mv	s6,a0
 4a8:	8a2e                	mv	s4,a1
 4aa:	8bb2                	mv	s7,a2
  state = 0;
 4ac:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ae:	4481                	li	s1,0
 4b0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ba:	06c00c93          	li	s9,108
 4be:	a015                	j	4e2 <vprintf+0x60>
        putc(fd, c0);
 4c0:	85ca                	mv	a1,s2
 4c2:	855a                	mv	a0,s6
 4c4:	00000097          	auipc	ra,0x0
 4c8:	ef0080e7          	jalr	-272(ra) # 3b4 <putc>
 4cc:	a019                	j	4d2 <vprintf+0x50>
    } else if(state == '%'){
 4ce:	03598263          	beq	s3,s5,4f2 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 4d2:	2485                	addw	s1,s1,1
 4d4:	8726                	mv	a4,s1
 4d6:	009a07b3          	add	a5,s4,s1
 4da:	0007c903          	lbu	s2,0(a5)
 4de:	24090b63          	beqz	s2,734 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 4e2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e6:	fe0994e3          	bnez	s3,4ce <vprintf+0x4c>
      if(c0 == '%'){
 4ea:	fd579be3          	bne	a5,s5,4c0 <vprintf+0x3e>
        state = '%';
 4ee:	89be                	mv	s3,a5
 4f0:	b7cd                	j	4d2 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 4f2:	cbc9                	beqz	a5,584 <vprintf+0x102>
 4f4:	00ea06b3          	add	a3,s4,a4
 4f8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4fc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4fe:	c681                	beqz	a3,506 <vprintf+0x84>
 500:	9752                	add	a4,a4,s4
 502:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 506:	05878163          	beq	a5,s8,548 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	05978d63          	beq	a5,s9,564 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 50e:	07500713          	li	a4,117
 512:	10e78163          	beq	a5,a4,614 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 516:	07800713          	li	a4,120
 51a:	14e78963          	beq	a5,a4,66c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 51e:	07000713          	li	a4,112
 522:	18e78263          	beq	a5,a4,6a6 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 526:	07300713          	li	a4,115
 52a:	1ce78663          	beq	a5,a4,6f6 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 52e:	02500713          	li	a4,37
 532:	04e79963          	bne	a5,a4,584 <vprintf+0x102>
        putc(fd, '%');
 536:	02500593          	li	a1,37
 53a:	855a                	mv	a0,s6
 53c:	00000097          	auipc	ra,0x0
 540:	e78080e7          	jalr	-392(ra) # 3b4 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 544:	4981                	li	s3,0
 546:	b771                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 548:	008b8913          	add	s2,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000ba583          	lw	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	00000097          	auipc	ra,0x0
 55a:	e80080e7          	jalr	-384(ra) # 3d6 <printint>
 55e:	8bca                	mv	s7,s2
      state = 0;
 560:	4981                	li	s3,0
 562:	bf85                	j	4d2 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 564:	06400793          	li	a5,100
 568:	02f68d63          	beq	a3,a5,5a2 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56c:	06c00793          	li	a5,108
 570:	04f68863          	beq	a3,a5,5c0 <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 574:	07500793          	li	a5,117
 578:	0af68c63          	beq	a3,a5,630 <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 57c:	07800793          	li	a5,120
 580:	10f68463          	beq	a3,a5,688 <vprintf+0x206>
        putc(fd, '%');
 584:	02500593          	li	a1,37
 588:	855a                	mv	a0,s6
 58a:	00000097          	auipc	ra,0x0
 58e:	e2a080e7          	jalr	-470(ra) # 3b4 <putc>
        putc(fd, c0);
 592:	85ca                	mv	a1,s2
 594:	855a                	mv	a0,s6
 596:	00000097          	auipc	ra,0x0
 59a:	e1e080e7          	jalr	-482(ra) # 3b4 <putc>
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	bf0d                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a2:	008b8913          	add	s2,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e26080e7          	jalr	-474(ra) # 3d6 <printint>
        i += 1;
 5b8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
        i += 1;
 5be:	bf11                	j	4d2 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c0:	06400793          	li	a5,100
 5c4:	02f60963          	beq	a2,a5,5f6 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5c8:	07500793          	li	a5,117
 5cc:	08f60163          	beq	a2,a5,64e <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5d0:	07800793          	li	a5,120
 5d4:	faf618e3          	bne	a2,a5,584 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	008b8913          	add	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	00000097          	auipc	ra,0x0
 5ea:	df0080e7          	jalr	-528(ra) # 3d6 <printint>
        i += 2;
 5ee:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 2;
 5f4:	bdf9                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	008b8913          	add	s2,s7,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	00000097          	auipc	ra,0x0
 608:	dd2080e7          	jalr	-558(ra) # 3d6 <printint>
        i += 2;
 60c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 2;
 612:	b5c1                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 614:	008b8913          	add	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	00000097          	auipc	ra,0x0
 626:	db4080e7          	jalr	-588(ra) # 3d6 <printint>
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b555                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	008b8913          	add	s2,s7,8
 634:	4681                	li	a3,0
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	00000097          	auipc	ra,0x0
 642:	d98080e7          	jalr	-616(ra) # 3d6 <printint>
        i += 1;
 646:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	b559                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	008b8913          	add	s2,s7,8
 652:	4681                	li	a3,0
 654:	4629                	li	a2,10
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	00000097          	auipc	ra,0x0
 660:	d7a080e7          	jalr	-646(ra) # 3d6 <printint>
        i += 2;
 664:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	b5a5                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 66c:	008b8913          	add	s2,s7,8
 670:	4681                	li	a3,0
 672:	4641                	li	a2,16
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	00000097          	auipc	ra,0x0
 67e:	d5c080e7          	jalr	-676(ra) # 3d6 <printint>
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	b5b1                	j	4d2 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	008b8913          	add	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000ba583          	lw	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	00000097          	auipc	ra,0x0
 69a:	d40080e7          	jalr	-704(ra) # 3d6 <printint>
        i += 1;
 69e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	b53d                	j	4d2 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 6a6:	008b8d13          	add	s10,s7,8
 6aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ae:	03000593          	li	a1,48
 6b2:	855a                	mv	a0,s6
 6b4:	00000097          	auipc	ra,0x0
 6b8:	d00080e7          	jalr	-768(ra) # 3b4 <putc>
  putc(fd, 'x');
 6bc:	07800593          	li	a1,120
 6c0:	855a                	mv	a0,s6
 6c2:	00000097          	auipc	ra,0x0
 6c6:	cf2080e7          	jalr	-782(ra) # 3b4 <putc>
 6ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6cc:	00000b97          	auipc	s7,0x0
 6d0:	26cb8b93          	add	s7,s7,620 # 938 <digits>
 6d4:	03c9d793          	srl	a5,s3,0x3c
 6d8:	97de                	add	a5,a5,s7
 6da:	0007c583          	lbu	a1,0(a5)
 6de:	855a                	mv	a0,s6
 6e0:	00000097          	auipc	ra,0x0
 6e4:	cd4080e7          	jalr	-812(ra) # 3b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e8:	0992                	sll	s3,s3,0x4
 6ea:	397d                	addw	s2,s2,-1
 6ec:	fe0914e3          	bnez	s2,6d4 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 6f0:	8bea                	mv	s7,s10
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bbf9                	j	4d2 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 6f6:	008b8993          	add	s3,s7,8
 6fa:	000bb903          	ld	s2,0(s7)
 6fe:	02090163          	beqz	s2,720 <vprintf+0x29e>
        for(; *s; s++)
 702:	00094583          	lbu	a1,0(s2)
 706:	c585                	beqz	a1,72e <vprintf+0x2ac>
          putc(fd, *s);
 708:	855a                	mv	a0,s6
 70a:	00000097          	auipc	ra,0x0
 70e:	caa080e7          	jalr	-854(ra) # 3b4 <putc>
        for(; *s; s++)
 712:	0905                	add	s2,s2,1
 714:	00094583          	lbu	a1,0(s2)
 718:	f9e5                	bnez	a1,708 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 71a:	8bce                	mv	s7,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bb55                	j	4d2 <vprintf+0x50>
          s = "(null)";
 720:	00000917          	auipc	s2,0x0
 724:	21090913          	add	s2,s2,528 # 930 <malloc+0xfa>
        for(; *s; s++)
 728:	02800593          	li	a1,40
 72c:	bff1                	j	708 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 72e:	8bce                	mv	s7,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	b345                	j	4d2 <vprintf+0x50>
    }
  }
}
 734:	60e6                	ld	ra,88(sp)
 736:	6446                	ld	s0,80(sp)
 738:	64a6                	ld	s1,72(sp)
 73a:	6906                	ld	s2,64(sp)
 73c:	79e2                	ld	s3,56(sp)
 73e:	7a42                	ld	s4,48(sp)
 740:	7aa2                	ld	s5,40(sp)
 742:	7b02                	ld	s6,32(sp)
 744:	6be2                	ld	s7,24(sp)
 746:	6c42                	ld	s8,16(sp)
 748:	6ca2                	ld	s9,8(sp)
 74a:	6d02                	ld	s10,0(sp)
 74c:	6125                	add	sp,sp,96
 74e:	8082                	ret

0000000000000750 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 750:	715d                	add	sp,sp,-80
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	add	s0,sp,32
 758:	e010                	sd	a2,0(s0)
 75a:	e414                	sd	a3,8(s0)
 75c:	e818                	sd	a4,16(s0)
 75e:	ec1c                	sd	a5,24(s0)
 760:	03043023          	sd	a6,32(s0)
 764:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76c:	8622                	mv	a2,s0
 76e:	00000097          	auipc	ra,0x0
 772:	d14080e7          	jalr	-748(ra) # 482 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	add	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	add	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	add	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	add	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	00000097          	auipc	ra,0x0
 7a8:	cde080e7          	jalr	-802(ra) # 482 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6125                	add	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b4:	1141                	add	sp,sp,-16
 7b6:	e422                	sd	s0,8(sp)
 7b8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ba:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	00001797          	auipc	a5,0x1
 7c2:	8427b783          	ld	a5,-1982(a5) # 1000 <freep>
 7c6:	a02d                	j	7f0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c8:	4618                	lw	a4,8(a2)
 7ca:	9f2d                	addw	a4,a4,a1
 7cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	6310                	ld	a2,0(a4)
 7d4:	a83d                	j	812 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d6:	ff852703          	lw	a4,-8(a0)
 7da:	9f31                	addw	a4,a4,a2
 7dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7de:	ff053683          	ld	a3,-16(a0)
 7e2:	a091                	j	826 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e7e463          	bltu	a5,a4,7ee <free+0x3a>
 7ea:	00e6ea63          	bltu	a3,a4,7fe <free+0x4a>
{
 7ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	fed7fae3          	bgeu	a5,a3,7e4 <free+0x30>
 7f4:	6398                	ld	a4,0(a5)
 7f6:	00e6e463          	bltu	a3,a4,7fe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	fee7eae3          	bltu	a5,a4,7ee <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7fe:	ff852583          	lw	a1,-8(a0)
 802:	6390                	ld	a2,0(a5)
 804:	02059813          	sll	a6,a1,0x20
 808:	01c85713          	srl	a4,a6,0x1c
 80c:	9736                	add	a4,a4,a3
 80e:	fae60de3          	beq	a2,a4,7c8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 816:	4790                	lw	a2,8(a5)
 818:	02061593          	sll	a1,a2,0x20
 81c:	01c5d713          	srl	a4,a1,0x1c
 820:	973e                	add	a4,a4,a5
 822:	fae68ae3          	beq	a3,a4,7d6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 826:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 828:	00000717          	auipc	a4,0x0
 82c:	7cf73c23          	sd	a5,2008(a4) # 1000 <freep>
}
 830:	6422                	ld	s0,8(sp)
 832:	0141                	add	sp,sp,16
 834:	8082                	ret

0000000000000836 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 836:	7139                	add	sp,sp,-64
 838:	fc06                	sd	ra,56(sp)
 83a:	f822                	sd	s0,48(sp)
 83c:	f426                	sd	s1,40(sp)
 83e:	f04a                	sd	s2,32(sp)
 840:	ec4e                	sd	s3,24(sp)
 842:	e852                	sd	s4,16(sp)
 844:	e456                	sd	s5,8(sp)
 846:	e05a                	sd	s6,0(sp)
 848:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84a:	02051493          	sll	s1,a0,0x20
 84e:	9081                	srl	s1,s1,0x20
 850:	04bd                	add	s1,s1,15
 852:	8091                	srl	s1,s1,0x4
 854:	0014899b          	addw	s3,s1,1
 858:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 85a:	00000517          	auipc	a0,0x0
 85e:	7a653503          	ld	a0,1958(a0) # 1000 <freep>
 862:	c515                	beqz	a0,88e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	02977f63          	bgeu	a4,s1,8a6 <malloc+0x70>
  if(nu < 4096)
 86c:	8a4e                	mv	s4,s3
 86e:	0009871b          	sext.w	a4,s3
 872:	6685                	lui	a3,0x1
 874:	00d77363          	bgeu	a4,a3,87a <malloc+0x44>
 878:	6a05                	lui	s4,0x1
 87a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 882:	00000917          	auipc	s2,0x0
 886:	77e90913          	add	s2,s2,1918 # 1000 <freep>
  if(p == (char*)-1)
 88a:	5afd                	li	s5,-1
 88c:	a895                	j	900 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 88e:	00000797          	auipc	a5,0x0
 892:	78278793          	add	a5,a5,1922 # 1010 <base>
 896:	00000717          	auipc	a4,0x0
 89a:	76f73523          	sd	a5,1898(a4) # 1000 <freep>
 89e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a4:	b7e1                	j	86c <malloc+0x36>
      if(p->s.size == nunits)
 8a6:	02e48c63          	beq	s1,a4,8de <malloc+0xa8>
        p->s.size -= nunits;
 8aa:	4137073b          	subw	a4,a4,s3
 8ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b0:	02071693          	sll	a3,a4,0x20
 8b4:	01c6d713          	srl	a4,a3,0x1c
 8b8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8be:	00000717          	auipc	a4,0x0
 8c2:	74a73123          	sd	a0,1858(a4) # 1000 <freep>
      return (void*)(p + 1);
 8c6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ca:	70e2                	ld	ra,56(sp)
 8cc:	7442                	ld	s0,48(sp)
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	7902                	ld	s2,32(sp)
 8d2:	69e2                	ld	s3,24(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
 8da:	6121                	add	sp,sp,64
 8dc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	e118                	sd	a4,0(a0)
 8e2:	bff1                	j	8be <malloc+0x88>
  hp->s.size = nu;
 8e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e8:	0541                	add	a0,a0,16
 8ea:	00000097          	auipc	ra,0x0
 8ee:	eca080e7          	jalr	-310(ra) # 7b4 <free>
  return freep;
 8f2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f6:	d971                	beqz	a0,8ca <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fa:	4798                	lw	a4,8(a5)
 8fc:	fa9775e3          	bgeu	a4,s1,8a6 <malloc+0x70>
    if(p == freep)
 900:	00093703          	ld	a4,0(s2)
 904:	853e                	mv	a0,a5
 906:	fef719e3          	bne	a4,a5,8f8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 90a:	8552                	mv	a0,s4
 90c:	00000097          	auipc	ra,0x0
 910:	a90080e7          	jalr	-1392(ra) # 39c <sbrk>
  if(p == (char*)-1)
 914:	fd5518e3          	bne	a0,s5,8e4 <malloc+0xae>
        return 0;
 918:	4501                	li	a0,0
 91a:	bf45                	j	8ca <malloc+0x94>
