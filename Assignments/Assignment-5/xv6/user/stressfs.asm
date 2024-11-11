
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	add	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	add	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	9ba78793          	add	a5,a5,-1606 # 9d0 <malloc+0x11c>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	97450513          	add	a0,a0,-1676 # 9a0 <malloc+0xec>
  34:	00000097          	auipc	ra,0x0
  38:	7c8080e7          	jalr	1992(ra) # 7fc <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	add	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	336080e7          	jalr	822(ra) # 38a <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	95050513          	add	a0,a0,-1712 # 9b8 <malloc+0x104>
  70:	00000097          	auipc	ra,0x0
  74:	78c080e7          	jalr	1932(ra) # 7fc <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	add	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	348080e7          	jalr	840(ra) # 3d2 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
/*    printf(fd, "%d\n", i); */
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	add	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	312080e7          	jalr	786(ra) # 3b2 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	30c080e7          	jalr	780(ra) # 3ba <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	91250513          	add	a0,a0,-1774 # 9c8 <malloc+0x114>
  be:	00000097          	auipc	ra,0x0
  c2:	73e080e7          	jalr	1854(ra) # 7fc <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	add	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	306080e7          	jalr	774(ra) # 3d2 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	add	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2c8080e7          	jalr	712(ra) # 3aa <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2ca080e7          	jalr	714(ra) # 3ba <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2a0080e7          	jalr	672(ra) # 39a <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	28e080e7          	jalr	654(ra) # 392 <exit>

000000000000010c <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 10c:	1141                	add	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	add	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	274080e7          	jalr	628(ra) # 392 <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	add	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	add	a1,a1,1
 130:	0785                	add	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	add	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	add	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	add	a0,a0,1
 158:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	add	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	add	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	add	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	add	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	add	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	add	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	sll	a2,a2,0x20
 1a4:	9201                	srl	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	add	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	add	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	add	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	add	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for(; *s; s++)
 1ca:	0505                	add	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	add	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	add	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	add	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	2485                	addw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	add	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	19a080e7          	jalr	410(ra) # 3aa <read>
    if(cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	add	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
  for(i=0; i+1 < max; ){
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	add	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	add	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e426                	sd	s1,8(sp)
 25a:	e04a                	sd	s2,0(sp)
 25c:	1000                	add	s0,sp,32
 25e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 260:	4581                	li	a1,0
 262:	00000097          	auipc	ra,0x0
 266:	170080e7          	jalr	368(ra) # 3d2 <open>
  if(fd < 0)
 26a:	02054563          	bltz	a0,294 <stat+0x42>
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	178080e7          	jalr	376(ra) # 3ea <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	13c080e7          	jalr	316(ra) # 3ba <close>
  return r;
}
 286:	854a                	mv	a0,s2
 288:	60e2                	ld	ra,24(sp)
 28a:	6442                	ld	s0,16(sp)
 28c:	64a2                	ld	s1,8(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	add	sp,sp,32
 292:	8082                	ret
    return -1;
 294:	597d                	li	s2,-1
 296:	bfc5                	j	286 <stat+0x34>

0000000000000298 <atoi>:

int
atoi(const char *s)
{
 298:	1141                	add	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29e:	00054683          	lbu	a3,0(a0)
 2a2:	fd06879b          	addw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	4625                	li	a2,9
 2ac:	02f66863          	bltu	a2,a5,2dc <atoi+0x44>
 2b0:	872a                	mv	a4,a0
  n = 0;
 2b2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b4:	0705                	add	a4,a4,1
 2b6:	0025179b          	sllw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	sllw	a5,a5,0x1
 2c0:	9fb5                	addw	a5,a5,a3
 2c2:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c6:	00074683          	lbu	a3,0(a4)
 2ca:	fd06879b          	addw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	fef671e3          	bgeu	a2,a5,2b4 <atoi+0x1c>
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	add	sp,sp,16
 2da:	8082                	ret
  n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x3e>

00000000000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	1141                	add	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57463          	bgeu	a0,a1,30e <memmove+0x2e>
    while(n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x28>
 2ee:	1602                	sll	a2,a2,0x20
 2f0:	9201                	srl	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	add	a1,a1,1
 2fa:	0705                	add	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	add	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 314:	fec05ae3          	blez	a2,308 <memmove+0x28>
 318:	fff6079b          	addw	a5,a2,-1
 31c:	1782                	sll	a5,a5,0x20
 31e:	9381                	srl	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 326:	15fd                	add	a1,a1,-1
 328:	177d                	add	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x46>
 336:	bfc9                	j	308 <memmove+0x28>

0000000000000338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	add	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	ca05                	beqz	a2,36e <memcmp+0x36>
 340:	fff6069b          	addw	a3,a2,-1
 344:	1682                	sll	a3,a3,0x20
 346:	9281                	srl	a3,a3,0x20
 348:	0685                	add	a3,a3,1
 34a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	add	a0,a0,1
    p2++;
 35a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x14>
  }
  return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x30>
      return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	add	sp,sp,16
 36c:	8082                	ret
  return 0;
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <memcmp+0x30>

0000000000000372 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 372:	1141                	add	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 37a:	00000097          	auipc	ra,0x0
 37e:	f66080e7          	jalr	-154(ra) # 2e0 <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	add	sp,sp,16
 388:	8082                	ret

000000000000038a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38a:	4885                	li	a7,1
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exit>:
.global exit
exit:
 li a7, SYS_exit
 392:	4889                	li	a7,2
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <wait>:
.global wait
wait:
 li a7, SYS_wait
 39a:	488d                	li	a7,3
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a2:	4891                	li	a7,4
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <read>:
.global read
read:
 li a7, SYS_read
 3aa:	4895                	li	a7,5
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <write>:
.global write
write:
 li a7, SYS_write
 3b2:	48c1                	li	a7,16
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <close>:
.global close
close:
 li a7, SYS_close
 3ba:	48d5                	li	a7,21
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c2:	4899                	li	a7,6
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ca:	489d                	li	a7,7
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <open>:
.global open
open:
 li a7, SYS_open
 3d2:	48bd                	li	a7,15
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3da:	48c5                	li	a7,17
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e2:	48c9                	li	a7,18
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ea:	48a1                	li	a7,8
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <link>:
.global link
link:
 li a7, SYS_link
 3f2:	48cd                	li	a7,19
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fa:	48d1                	li	a7,20
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 402:	48a5                	li	a7,9
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <dup>:
.global dup
dup:
 li a7, SYS_dup
 40a:	48a9                	li	a7,10
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 412:	48ad                	li	a7,11
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41a:	48b1                	li	a7,12
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 422:	48b5                	li	a7,13
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42a:	48b9                	li	a7,14
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 432:	1101                	add	sp,sp,-32
 434:	ec06                	sd	ra,24(sp)
 436:	e822                	sd	s0,16(sp)
 438:	1000                	add	s0,sp,32
 43a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43e:	4605                	li	a2,1
 440:	fef40593          	add	a1,s0,-17
 444:	00000097          	auipc	ra,0x0
 448:	f6e080e7          	jalr	-146(ra) # 3b2 <write>
}
 44c:	60e2                	ld	ra,24(sp)
 44e:	6442                	ld	s0,16(sp)
 450:	6105                	add	sp,sp,32
 452:	8082                	ret

0000000000000454 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 454:	7139                	add	sp,sp,-64
 456:	fc06                	sd	ra,56(sp)
 458:	f822                	sd	s0,48(sp)
 45a:	f426                	sd	s1,40(sp)
 45c:	f04a                	sd	s2,32(sp)
 45e:	ec4e                	sd	s3,24(sp)
 460:	0080                	add	s0,sp,64
 462:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 464:	c299                	beqz	a3,46a <printint+0x16>
 466:	0805c963          	bltz	a1,4f8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46a:	2581                	sext.w	a1,a1
  neg = 0;
 46c:	4881                	li	a7,0
 46e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 472:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 474:	2601                	sext.w	a2,a2
 476:	00000517          	auipc	a0,0x0
 47a:	57250513          	add	a0,a0,1394 # 9e8 <digits>
 47e:	883a                	mv	a6,a4
 480:	2705                	addw	a4,a4,1
 482:	02c5f7bb          	remuw	a5,a1,a2
 486:	1782                	sll	a5,a5,0x20
 488:	9381                	srl	a5,a5,0x20
 48a:	97aa                	add	a5,a5,a0
 48c:	0007c783          	lbu	a5,0(a5)
 490:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 494:	0005879b          	sext.w	a5,a1
 498:	02c5d5bb          	divuw	a1,a1,a2
 49c:	0685                	add	a3,a3,1
 49e:	fec7f0e3          	bgeu	a5,a2,47e <printint+0x2a>
  if(neg)
 4a2:	00088c63          	beqz	a7,4ba <printint+0x66>
    buf[i++] = '-';
 4a6:	fd070793          	add	a5,a4,-48
 4aa:	00878733          	add	a4,a5,s0
 4ae:	02d00793          	li	a5,45
 4b2:	fef70823          	sb	a5,-16(a4)
 4b6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4ba:	02e05863          	blez	a4,4ea <printint+0x96>
 4be:	fc040793          	add	a5,s0,-64
 4c2:	00e78933          	add	s2,a5,a4
 4c6:	fff78993          	add	s3,a5,-1
 4ca:	99ba                	add	s3,s3,a4
 4cc:	377d                	addw	a4,a4,-1
 4ce:	1702                	sll	a4,a4,0x20
 4d0:	9301                	srl	a4,a4,0x20
 4d2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d6:	fff94583          	lbu	a1,-1(s2)
 4da:	8526                	mv	a0,s1
 4dc:	00000097          	auipc	ra,0x0
 4e0:	f56080e7          	jalr	-170(ra) # 432 <putc>
  while(--i >= 0)
 4e4:	197d                	add	s2,s2,-1
 4e6:	ff3918e3          	bne	s2,s3,4d6 <printint+0x82>
}
 4ea:	70e2                	ld	ra,56(sp)
 4ec:	7442                	ld	s0,48(sp)
 4ee:	74a2                	ld	s1,40(sp)
 4f0:	7902                	ld	s2,32(sp)
 4f2:	69e2                	ld	s3,24(sp)
 4f4:	6121                	add	sp,sp,64
 4f6:	8082                	ret
    x = -xx;
 4f8:	40b005bb          	negw	a1,a1
    neg = 1;
 4fc:	4885                	li	a7,1
    x = -xx;
 4fe:	bf85                	j	46e <printint+0x1a>

0000000000000500 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 500:	711d                	add	sp,sp,-96
 502:	ec86                	sd	ra,88(sp)
 504:	e8a2                	sd	s0,80(sp)
 506:	e4a6                	sd	s1,72(sp)
 508:	e0ca                	sd	s2,64(sp)
 50a:	fc4e                	sd	s3,56(sp)
 50c:	f852                	sd	s4,48(sp)
 50e:	f456                	sd	s5,40(sp)
 510:	f05a                	sd	s6,32(sp)
 512:	ec5e                	sd	s7,24(sp)
 514:	e862                	sd	s8,16(sp)
 516:	e466                	sd	s9,8(sp)
 518:	e06a                	sd	s10,0(sp)
 51a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 51c:	0005c903          	lbu	s2,0(a1)
 520:	28090963          	beqz	s2,7b2 <vprintf+0x2b2>
 524:	8b2a                	mv	s6,a0
 526:	8a2e                	mv	s4,a1
 528:	8bb2                	mv	s7,a2
  state = 0;
 52a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 52c:	4481                	li	s1,0
 52e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 530:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 534:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 538:	06c00c93          	li	s9,108
 53c:	a015                	j	560 <vprintf+0x60>
        putc(fd, c0);
 53e:	85ca                	mv	a1,s2
 540:	855a                	mv	a0,s6
 542:	00000097          	auipc	ra,0x0
 546:	ef0080e7          	jalr	-272(ra) # 432 <putc>
 54a:	a019                	j	550 <vprintf+0x50>
    } else if(state == '%'){
 54c:	03598263          	beq	s3,s5,570 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 550:	2485                	addw	s1,s1,1
 552:	8726                	mv	a4,s1
 554:	009a07b3          	add	a5,s4,s1
 558:	0007c903          	lbu	s2,0(a5)
 55c:	24090b63          	beqz	s2,7b2 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 560:	0009079b          	sext.w	a5,s2
    if(state == 0){
 564:	fe0994e3          	bnez	s3,54c <vprintf+0x4c>
      if(c0 == '%'){
 568:	fd579be3          	bne	a5,s5,53e <vprintf+0x3e>
        state = '%';
 56c:	89be                	mv	s3,a5
 56e:	b7cd                	j	550 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 570:	cbc9                	beqz	a5,602 <vprintf+0x102>
 572:	00ea06b3          	add	a3,s4,a4
 576:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 57a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 57c:	c681                	beqz	a3,584 <vprintf+0x84>
 57e:	9752                	add	a4,a4,s4
 580:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 584:	05878163          	beq	a5,s8,5c6 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 588:	05978d63          	beq	a5,s9,5e2 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 58c:	07500713          	li	a4,117
 590:	10e78163          	beq	a5,a4,692 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 594:	07800713          	li	a4,120
 598:	14e78963          	beq	a5,a4,6ea <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 59c:	07000713          	li	a4,112
 5a0:	18e78263          	beq	a5,a4,724 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5a4:	07300713          	li	a4,115
 5a8:	1ce78663          	beq	a5,a4,774 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ac:	02500713          	li	a4,37
 5b0:	04e79963          	bne	a5,a4,602 <vprintf+0x102>
        putc(fd, '%');
 5b4:	02500593          	li	a1,37
 5b8:	855a                	mv	a0,s6
 5ba:	00000097          	auipc	ra,0x0
 5be:	e78080e7          	jalr	-392(ra) # 432 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b771                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 5c6:	008b8913          	add	s2,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e80080e7          	jalr	-384(ra) # 454 <printint>
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bf85                	j	550 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 5e2:	06400793          	li	a5,100
 5e6:	02f68d63          	beq	a3,a5,620 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ea:	06c00793          	li	a5,108
 5ee:	04f68863          	beq	a3,a5,63e <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 5f2:	07500793          	li	a5,117
 5f6:	0af68c63          	beq	a3,a5,6ae <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 5fa:	07800793          	li	a5,120
 5fe:	10f68463          	beq	a3,a5,706 <vprintf+0x206>
        putc(fd, '%');
 602:	02500593          	li	a1,37
 606:	855a                	mv	a0,s6
 608:	00000097          	auipc	ra,0x0
 60c:	e2a080e7          	jalr	-470(ra) # 432 <putc>
        putc(fd, c0);
 610:	85ca                	mv	a1,s2
 612:	855a                	mv	a0,s6
 614:	00000097          	auipc	ra,0x0
 618:	e1e080e7          	jalr	-482(ra) # 432 <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bf0d                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	008b8913          	add	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	00000097          	auipc	ra,0x0
 632:	e26080e7          	jalr	-474(ra) # 454 <printint>
        i += 1;
 636:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
        i += 1;
 63c:	bf11                	j	550 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63e:	06400793          	li	a5,100
 642:	02f60963          	beq	a2,a5,674 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 646:	07500793          	li	a5,117
 64a:	08f60163          	beq	a2,a5,6cc <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 64e:	07800793          	li	a5,120
 652:	faf618e3          	bne	a2,a5,602 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	008b8913          	add	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000ba583          	lw	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	00000097          	auipc	ra,0x0
 668:	df0080e7          	jalr	-528(ra) # 454 <printint>
        i += 2;
 66c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bdf9                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8913          	add	s2,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	00000097          	auipc	ra,0x0
 686:	dd2080e7          	jalr	-558(ra) # 454 <printint>
        i += 2;
 68a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	b5c1                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 692:	008b8913          	add	s2,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	00000097          	auipc	ra,0x0
 6a4:	db4080e7          	jalr	-588(ra) # 454 <printint>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b555                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	008b8913          	add	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000ba583          	lw	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d98080e7          	jalr	-616(ra) # 454 <printint>
        i += 1;
 6c4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
        i += 1;
 6ca:	b559                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	008b8913          	add	s2,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4629                	li	a2,10
 6d4:	000ba583          	lw	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	00000097          	auipc	ra,0x0
 6de:	d7a080e7          	jalr	-646(ra) # 454 <printint>
        i += 2;
 6e2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
        i += 2;
 6e8:	b5a5                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 6ea:	008b8913          	add	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	00000097          	auipc	ra,0x0
 6fc:	d5c080e7          	jalr	-676(ra) # 454 <printint>
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	b5b1                	j	550 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	008b8913          	add	s2,s7,8
 70a:	4681                	li	a3,0
 70c:	4641                	li	a2,16
 70e:	000ba583          	lw	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	00000097          	auipc	ra,0x0
 718:	d40080e7          	jalr	-704(ra) # 454 <printint>
        i += 1;
 71c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 1;
 722:	b53d                	j	550 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 724:	008b8d13          	add	s10,s7,8
 728:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 72c:	03000593          	li	a1,48
 730:	855a                	mv	a0,s6
 732:	00000097          	auipc	ra,0x0
 736:	d00080e7          	jalr	-768(ra) # 432 <putc>
  putc(fd, 'x');
 73a:	07800593          	li	a1,120
 73e:	855a                	mv	a0,s6
 740:	00000097          	auipc	ra,0x0
 744:	cf2080e7          	jalr	-782(ra) # 432 <putc>
 748:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74a:	00000b97          	auipc	s7,0x0
 74e:	29eb8b93          	add	s7,s7,670 # 9e8 <digits>
 752:	03c9d793          	srl	a5,s3,0x3c
 756:	97de                	add	a5,a5,s7
 758:	0007c583          	lbu	a1,0(a5)
 75c:	855a                	mv	a0,s6
 75e:	00000097          	auipc	ra,0x0
 762:	cd4080e7          	jalr	-812(ra) # 432 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 766:	0992                	sll	s3,s3,0x4
 768:	397d                	addw	s2,s2,-1
 76a:	fe0914e3          	bnez	s2,752 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 76e:	8bea                	mv	s7,s10
      state = 0;
 770:	4981                	li	s3,0
 772:	bbf9                	j	550 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 774:	008b8993          	add	s3,s7,8
 778:	000bb903          	ld	s2,0(s7)
 77c:	02090163          	beqz	s2,79e <vprintf+0x29e>
        for(; *s; s++)
 780:	00094583          	lbu	a1,0(s2)
 784:	c585                	beqz	a1,7ac <vprintf+0x2ac>
          putc(fd, *s);
 786:	855a                	mv	a0,s6
 788:	00000097          	auipc	ra,0x0
 78c:	caa080e7          	jalr	-854(ra) # 432 <putc>
        for(; *s; s++)
 790:	0905                	add	s2,s2,1
 792:	00094583          	lbu	a1,0(s2)
 796:	f9e5                	bnez	a1,786 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 798:	8bce                	mv	s7,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	bb55                	j	550 <vprintf+0x50>
          s = "(null)";
 79e:	00000917          	auipc	s2,0x0
 7a2:	24290913          	add	s2,s2,578 # 9e0 <malloc+0x12c>
        for(; *s; s++)
 7a6:	02800593          	li	a1,40
 7aa:	bff1                	j	786 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 7ac:	8bce                	mv	s7,s3
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b345                	j	550 <vprintf+0x50>
    }
  }
}
 7b2:	60e6                	ld	ra,88(sp)
 7b4:	6446                	ld	s0,80(sp)
 7b6:	64a6                	ld	s1,72(sp)
 7b8:	6906                	ld	s2,64(sp)
 7ba:	79e2                	ld	s3,56(sp)
 7bc:	7a42                	ld	s4,48(sp)
 7be:	7aa2                	ld	s5,40(sp)
 7c0:	7b02                	ld	s6,32(sp)
 7c2:	6be2                	ld	s7,24(sp)
 7c4:	6c42                	ld	s8,16(sp)
 7c6:	6ca2                	ld	s9,8(sp)
 7c8:	6d02                	ld	s10,0(sp)
 7ca:	6125                	add	sp,sp,96
 7cc:	8082                	ret

00000000000007ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ce:	715d                	add	sp,sp,-80
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	add	s0,sp,32
 7d6:	e010                	sd	a2,0(s0)
 7d8:	e414                	sd	a3,8(s0)
 7da:	e818                	sd	a4,16(s0)
 7dc:	ec1c                	sd	a5,24(s0)
 7de:	03043023          	sd	a6,32(s0)
 7e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ea:	8622                	mv	a2,s0
 7ec:	00000097          	auipc	ra,0x0
 7f0:	d14080e7          	jalr	-748(ra) # 500 <vprintf>
}
 7f4:	60e2                	ld	ra,24(sp)
 7f6:	6442                	ld	s0,16(sp)
 7f8:	6161                	add	sp,sp,80
 7fa:	8082                	ret

00000000000007fc <printf>:

void
printf(const char *fmt, ...)
{
 7fc:	711d                	add	sp,sp,-96
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	1000                	add	s0,sp,32
 804:	e40c                	sd	a1,8(s0)
 806:	e810                	sd	a2,16(s0)
 808:	ec14                	sd	a3,24(s0)
 80a:	f018                	sd	a4,32(s0)
 80c:	f41c                	sd	a5,40(s0)
 80e:	03043823          	sd	a6,48(s0)
 812:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 816:	00840613          	add	a2,s0,8
 81a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81e:	85aa                	mv	a1,a0
 820:	4505                	li	a0,1
 822:	00000097          	auipc	ra,0x0
 826:	cde080e7          	jalr	-802(ra) # 500 <vprintf>
}
 82a:	60e2                	ld	ra,24(sp)
 82c:	6442                	ld	s0,16(sp)
 82e:	6125                	add	sp,sp,96
 830:	8082                	ret

0000000000000832 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 832:	1141                	add	sp,sp,-16
 834:	e422                	sd	s0,8(sp)
 836:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 838:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83c:	00000797          	auipc	a5,0x0
 840:	7c47b783          	ld	a5,1988(a5) # 1000 <freep>
 844:	a02d                	j	86e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 846:	4618                	lw	a4,8(a2)
 848:	9f2d                	addw	a4,a4,a1
 84a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	6398                	ld	a4,0(a5)
 850:	6310                	ld	a2,0(a4)
 852:	a83d                	j	890 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 854:	ff852703          	lw	a4,-8(a0)
 858:	9f31                	addw	a4,a4,a2
 85a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 85c:	ff053683          	ld	a3,-16(a0)
 860:	a091                	j	8a4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 862:	6398                	ld	a4,0(a5)
 864:	00e7e463          	bltu	a5,a4,86c <free+0x3a>
 868:	00e6ea63          	bltu	a3,a4,87c <free+0x4a>
{
 86c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86e:	fed7fae3          	bgeu	a5,a3,862 <free+0x30>
 872:	6398                	ld	a4,0(a5)
 874:	00e6e463          	bltu	a3,a4,87c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 878:	fee7eae3          	bltu	a5,a4,86c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 87c:	ff852583          	lw	a1,-8(a0)
 880:	6390                	ld	a2,0(a5)
 882:	02059813          	sll	a6,a1,0x20
 886:	01c85713          	srl	a4,a6,0x1c
 88a:	9736                	add	a4,a4,a3
 88c:	fae60de3          	beq	a2,a4,846 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 890:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 894:	4790                	lw	a2,8(a5)
 896:	02061593          	sll	a1,a2,0x20
 89a:	01c5d713          	srl	a4,a1,0x1c
 89e:	973e                	add	a4,a4,a5
 8a0:	fae68ae3          	beq	a3,a4,854 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a6:	00000717          	auipc	a4,0x0
 8aa:	74f73d23          	sd	a5,1882(a4) # 1000 <freep>
}
 8ae:	6422                	ld	s0,8(sp)
 8b0:	0141                	add	sp,sp,16
 8b2:	8082                	ret

00000000000008b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b4:	7139                	add	sp,sp,-64
 8b6:	fc06                	sd	ra,56(sp)
 8b8:	f822                	sd	s0,48(sp)
 8ba:	f426                	sd	s1,40(sp)
 8bc:	f04a                	sd	s2,32(sp)
 8be:	ec4e                	sd	s3,24(sp)
 8c0:	e852                	sd	s4,16(sp)
 8c2:	e456                	sd	s5,8(sp)
 8c4:	e05a                	sd	s6,0(sp)
 8c6:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c8:	02051493          	sll	s1,a0,0x20
 8cc:	9081                	srl	s1,s1,0x20
 8ce:	04bd                	add	s1,s1,15
 8d0:	8091                	srl	s1,s1,0x4
 8d2:	0014899b          	addw	s3,s1,1
 8d6:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8d8:	00000517          	auipc	a0,0x0
 8dc:	72853503          	ld	a0,1832(a0) # 1000 <freep>
 8e0:	c515                	beqz	a0,90c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	02977f63          	bgeu	a4,s1,924 <malloc+0x70>
  if(nu < 4096)
 8ea:	8a4e                	mv	s4,s3
 8ec:	0009871b          	sext.w	a4,s3
 8f0:	6685                	lui	a3,0x1
 8f2:	00d77363          	bgeu	a4,a3,8f8 <malloc+0x44>
 8f6:	6a05                	lui	s4,0x1
 8f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8fc:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 900:	00000917          	auipc	s2,0x0
 904:	70090913          	add	s2,s2,1792 # 1000 <freep>
  if(p == (char*)-1)
 908:	5afd                	li	s5,-1
 90a:	a895                	j	97e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 90c:	00000797          	auipc	a5,0x0
 910:	70478793          	add	a5,a5,1796 # 1010 <base>
 914:	00000717          	auipc	a4,0x0
 918:	6ef73623          	sd	a5,1772(a4) # 1000 <freep>
 91c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 922:	b7e1                	j	8ea <malloc+0x36>
      if(p->s.size == nunits)
 924:	02e48c63          	beq	s1,a4,95c <malloc+0xa8>
        p->s.size -= nunits;
 928:	4137073b          	subw	a4,a4,s3
 92c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92e:	02071693          	sll	a3,a4,0x20
 932:	01c6d713          	srl	a4,a3,0x1c
 936:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 938:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93c:	00000717          	auipc	a4,0x0
 940:	6ca73223          	sd	a0,1732(a4) # 1000 <freep>
      return (void*)(p + 1);
 944:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 948:	70e2                	ld	ra,56(sp)
 94a:	7442                	ld	s0,48(sp)
 94c:	74a2                	ld	s1,40(sp)
 94e:	7902                	ld	s2,32(sp)
 950:	69e2                	ld	s3,24(sp)
 952:	6a42                	ld	s4,16(sp)
 954:	6aa2                	ld	s5,8(sp)
 956:	6b02                	ld	s6,0(sp)
 958:	6121                	add	sp,sp,64
 95a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 95c:	6398                	ld	a4,0(a5)
 95e:	e118                	sd	a4,0(a0)
 960:	bff1                	j	93c <malloc+0x88>
  hp->s.size = nu;
 962:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 966:	0541                	add	a0,a0,16
 968:	00000097          	auipc	ra,0x0
 96c:	eca080e7          	jalr	-310(ra) # 832 <free>
  return freep;
 970:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 974:	d971                	beqz	a0,948 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 976:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 978:	4798                	lw	a4,8(a5)
 97a:	fa9775e3          	bgeu	a4,s1,924 <malloc+0x70>
    if(p == freep)
 97e:	00093703          	ld	a4,0(s2)
 982:	853e                	mv	a0,a5
 984:	fef719e3          	bne	a4,a5,976 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 988:	8552                	mv	a0,s4
 98a:	00000097          	auipc	ra,0x0
 98e:	a90080e7          	jalr	-1392(ra) # 41a <sbrk>
  if(p == (char*)-1)
 992:	fd5518e3          	bne	a0,s5,962 <malloc+0xae>
        return 0;
 996:	4501                	li	a0,0
 998:	bf45                	j	948 <malloc+0x94>
