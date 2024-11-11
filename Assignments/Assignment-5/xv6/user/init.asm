
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	98250513          	add	a0,a0,-1662 # 990 <malloc+0xf0>
  16:	00000097          	auipc	ra,0x0
  1a:	3a8080e7          	jalr	936(ra) # 3be <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  /* stdout */
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3d2080e7          	jalr	978(ra) # 3f6 <dup>
  dup(0);  /* stderr */
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3c8080e7          	jalr	968(ra) # 3f6 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	96290913          	add	s2,s2,-1694 # 998 <malloc+0xf8>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	7a8080e7          	jalr	1960(ra) # 7e8 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	32e080e7          	jalr	814(ra) # 376 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      /* this call to wait() returns if the shell exits, */
      /* or if a parentless process exits. */
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	32c080e7          	jalr	812(ra) # 386 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        /* the shell exited; restart it. */
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	97e50513          	add	a0,a0,-1666 # 9e8 <malloc+0x148>
  72:	00000097          	auipc	ra,0x0
  76:	776080e7          	jalr	1910(ra) # 7e8 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	302080e7          	jalr	770(ra) # 37e <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	90850513          	add	a0,a0,-1784 # 990 <malloc+0xf0>
  90:	00000097          	auipc	ra,0x0
  94:	336080e7          	jalr	822(ra) # 3c6 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	8f650513          	add	a0,a0,-1802 # 990 <malloc+0xf0>
  a2:	00000097          	auipc	ra,0x0
  a6:	31c080e7          	jalr	796(ra) # 3be <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	90450513          	add	a0,a0,-1788 # 9b0 <malloc+0x110>
  b4:	00000097          	auipc	ra,0x0
  b8:	734080e7          	jalr	1844(ra) # 7e8 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c0080e7          	jalr	704(ra) # 37e <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	add	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	8fa50513          	add	a0,a0,-1798 # 9c8 <malloc+0x128>
  d6:	00000097          	auipc	ra,0x0
  da:	2e0080e7          	jalr	736(ra) # 3b6 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	8f250513          	add	a0,a0,-1806 # 9d0 <malloc+0x130>
  e6:	00000097          	auipc	ra,0x0
  ea:	702080e7          	jalr	1794(ra) # 7e8 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	28e080e7          	jalr	654(ra) # 37e <exit>

00000000000000f8 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
  f8:	1141                	add	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	add	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	274080e7          	jalr	628(ra) # 37e <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	add	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 118:	87aa                	mv	a5,a0
 11a:	0585                	add	a1,a1,1
 11c:	0785                	add	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
    ;
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	add	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	1141                	add	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
    p++, q++;
 142:	0505                	add	a0,a0,1
 144:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	add	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	add	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	add	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	add	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addw	a0,a0,1
    ;
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	add	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	add	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	sll	a2,a2,0x20
 190:	9201                	srl	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	add	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	add	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	add	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	add	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	add	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	add	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	add	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	add	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	add	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	19a080e7          	jalr	410(ra) # 396 <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	add	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
  for(i=0; i+1 < max; ){
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	add	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	add	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e426                	sd	s1,8(sp)
 246:	e04a                	sd	s2,0(sp)
 248:	1000                	add	s0,sp,32
 24a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24c:	4581                	li	a1,0
 24e:	00000097          	auipc	ra,0x0
 252:	170080e7          	jalr	368(ra) # 3be <open>
  if(fd < 0)
 256:	02054563          	bltz	a0,280 <stat+0x42>
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	178080e7          	jalr	376(ra) # 3d6 <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	13c080e7          	jalr	316(ra) # 3a6 <close>
  return r;
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	64a2                	ld	s1,8(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	add	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfc5                	j	272 <stat+0x34>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	add	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66863          	bltu	a2,a5,2c8 <atoi+0x44>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	add	a4,a4,1
 2a2:	0025179b          	sllw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	sllw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1c>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	add	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x3e>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	add	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d2:	02b57463          	bgeu	a0,a1,2fa <memmove+0x2e>
    while(n-- > 0)
 2d6:	00c05f63          	blez	a2,2f4 <memmove+0x28>
 2da:	1602                	sll	a2,a2,0x20
 2dc:	9201                	srl	a2,a2,0x20
 2de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e4:	0585                	add	a1,a1,1
 2e6:	0705                	add	a4,a4,1
 2e8:	fff5c683          	lbu	a3,-1(a1)
 2ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	add	sp,sp,16
 2f8:	8082                	ret
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 300:	fec05ae3          	blez	a2,2f4 <memmove+0x28>
 304:	fff6079b          	addw	a5,a2,-1
 308:	1782                	sll	a5,a5,0x20
 30a:	9381                	srl	a5,a5,0x20
 30c:	fff7c793          	not	a5,a5
 310:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 312:	15fd                	add	a1,a1,-1
 314:	177d                	add	a4,a4,-1
 316:	0005c683          	lbu	a3,0(a1)
 31a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x46>
 322:	bfc9                	j	2f4 <memmove+0x28>

0000000000000324 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 324:	1141                	add	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32a:	ca05                	beqz	a2,35a <memcmp+0x36>
 32c:	fff6069b          	addw	a3,a2,-1
 330:	1682                	sll	a3,a3,0x20
 332:	9281                	srl	a3,a3,0x20
 334:	0685                	add	a3,a3,1
 336:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 338:	00054783          	lbu	a5,0(a0)
 33c:	0005c703          	lbu	a4,0(a1)
 340:	00e79863          	bne	a5,a4,350 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 344:	0505                	add	a0,a0,1
    p2++;
 346:	0585                	add	a1,a1,1
  while (n-- > 0) {
 348:	fed518e3          	bne	a0,a3,338 <memcmp+0x14>
  }
  return 0;
 34c:	4501                	li	a0,0
 34e:	a019                	j	354 <memcmp+0x30>
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	add	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <memcmp+0x30>

000000000000035e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35e:	1141                	add	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 366:	00000097          	auipc	ra,0x0
 36a:	f66080e7          	jalr	-154(ra) # 2cc <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	add	sp,sp,16
 374:	8082                	ret

0000000000000376 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 376:	4885                	li	a7,1
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exit>:
.global exit
exit:
 li a7, SYS_exit
 37e:	4889                	li	a7,2
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <wait>:
.global wait
wait:
 li a7, SYS_wait
 386:	488d                	li	a7,3
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38e:	4891                	li	a7,4
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <read>:
.global read
read:
 li a7, SYS_read
 396:	4895                	li	a7,5
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <write>:
.global write
write:
 li a7, SYS_write
 39e:	48c1                	li	a7,16
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <close>:
.global close
close:
 li a7, SYS_close
 3a6:	48d5                	li	a7,21
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ae:	4899                	li	a7,6
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b6:	489d                	li	a7,7
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <open>:
.global open
open:
 li a7, SYS_open
 3be:	48bd                	li	a7,15
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d6:	48a1                	li	a7,8
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <link>:
.global link
link:
 li a7, SYS_link
 3de:	48cd                	li	a7,19
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e6:	48d1                	li	a7,20
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41e:	1101                	add	sp,sp,-32
 420:	ec06                	sd	ra,24(sp)
 422:	e822                	sd	s0,16(sp)
 424:	1000                	add	s0,sp,32
 426:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42a:	4605                	li	a2,1
 42c:	fef40593          	add	a1,s0,-17
 430:	00000097          	auipc	ra,0x0
 434:	f6e080e7          	jalr	-146(ra) # 39e <write>
}
 438:	60e2                	ld	ra,24(sp)
 43a:	6442                	ld	s0,16(sp)
 43c:	6105                	add	sp,sp,32
 43e:	8082                	ret

0000000000000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	7139                	add	sp,sp,-64
 442:	fc06                	sd	ra,56(sp)
 444:	f822                	sd	s0,48(sp)
 446:	f426                	sd	s1,40(sp)
 448:	f04a                	sd	s2,32(sp)
 44a:	ec4e                	sd	s3,24(sp)
 44c:	0080                	add	s0,sp,64
 44e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 450:	c299                	beqz	a3,456 <printint+0x16>
 452:	0805c963          	bltz	a1,4e4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 456:	2581                	sext.w	a1,a1
  neg = 0;
 458:	4881                	li	a7,0
 45a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 45e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 460:	2601                	sext.w	a2,a2
 462:	00000517          	auipc	a0,0x0
 466:	5ae50513          	add	a0,a0,1454 # a10 <digits>
 46a:	883a                	mv	a6,a4
 46c:	2705                	addw	a4,a4,1
 46e:	02c5f7bb          	remuw	a5,a1,a2
 472:	1782                	sll	a5,a5,0x20
 474:	9381                	srl	a5,a5,0x20
 476:	97aa                	add	a5,a5,a0
 478:	0007c783          	lbu	a5,0(a5)
 47c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 480:	0005879b          	sext.w	a5,a1
 484:	02c5d5bb          	divuw	a1,a1,a2
 488:	0685                	add	a3,a3,1
 48a:	fec7f0e3          	bgeu	a5,a2,46a <printint+0x2a>
  if(neg)
 48e:	00088c63          	beqz	a7,4a6 <printint+0x66>
    buf[i++] = '-';
 492:	fd070793          	add	a5,a4,-48
 496:	00878733          	add	a4,a5,s0
 49a:	02d00793          	li	a5,45
 49e:	fef70823          	sb	a5,-16(a4)
 4a2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4a6:	02e05863          	blez	a4,4d6 <printint+0x96>
 4aa:	fc040793          	add	a5,s0,-64
 4ae:	00e78933          	add	s2,a5,a4
 4b2:	fff78993          	add	s3,a5,-1
 4b6:	99ba                	add	s3,s3,a4
 4b8:	377d                	addw	a4,a4,-1
 4ba:	1702                	sll	a4,a4,0x20
 4bc:	9301                	srl	a4,a4,0x20
 4be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c2:	fff94583          	lbu	a1,-1(s2)
 4c6:	8526                	mv	a0,s1
 4c8:	00000097          	auipc	ra,0x0
 4cc:	f56080e7          	jalr	-170(ra) # 41e <putc>
  while(--i >= 0)
 4d0:	197d                	add	s2,s2,-1
 4d2:	ff3918e3          	bne	s2,s3,4c2 <printint+0x82>
}
 4d6:	70e2                	ld	ra,56(sp)
 4d8:	7442                	ld	s0,48(sp)
 4da:	74a2                	ld	s1,40(sp)
 4dc:	7902                	ld	s2,32(sp)
 4de:	69e2                	ld	s3,24(sp)
 4e0:	6121                	add	sp,sp,64
 4e2:	8082                	ret
    x = -xx;
 4e4:	40b005bb          	negw	a1,a1
    neg = 1;
 4e8:	4885                	li	a7,1
    x = -xx;
 4ea:	bf85                	j	45a <printint+0x1a>

00000000000004ec <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ec:	711d                	add	sp,sp,-96
 4ee:	ec86                	sd	ra,88(sp)
 4f0:	e8a2                	sd	s0,80(sp)
 4f2:	e4a6                	sd	s1,72(sp)
 4f4:	e0ca                	sd	s2,64(sp)
 4f6:	fc4e                	sd	s3,56(sp)
 4f8:	f852                	sd	s4,48(sp)
 4fa:	f456                	sd	s5,40(sp)
 4fc:	f05a                	sd	s6,32(sp)
 4fe:	ec5e                	sd	s7,24(sp)
 500:	e862                	sd	s8,16(sp)
 502:	e466                	sd	s9,8(sp)
 504:	e06a                	sd	s10,0(sp)
 506:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 508:	0005c903          	lbu	s2,0(a1)
 50c:	28090963          	beqz	s2,79e <vprintf+0x2b2>
 510:	8b2a                	mv	s6,a0
 512:	8a2e                	mv	s4,a1
 514:	8bb2                	mv	s7,a2
  state = 0;
 516:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 518:	4481                	li	s1,0
 51a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 51c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 520:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 524:	06c00c93          	li	s9,108
 528:	a015                	j	54c <vprintf+0x60>
        putc(fd, c0);
 52a:	85ca                	mv	a1,s2
 52c:	855a                	mv	a0,s6
 52e:	00000097          	auipc	ra,0x0
 532:	ef0080e7          	jalr	-272(ra) # 41e <putc>
 536:	a019                	j	53c <vprintf+0x50>
    } else if(state == '%'){
 538:	03598263          	beq	s3,s5,55c <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 53c:	2485                	addw	s1,s1,1
 53e:	8726                	mv	a4,s1
 540:	009a07b3          	add	a5,s4,s1
 544:	0007c903          	lbu	s2,0(a5)
 548:	24090b63          	beqz	s2,79e <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 54c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 550:	fe0994e3          	bnez	s3,538 <vprintf+0x4c>
      if(c0 == '%'){
 554:	fd579be3          	bne	a5,s5,52a <vprintf+0x3e>
        state = '%';
 558:	89be                	mv	s3,a5
 55a:	b7cd                	j	53c <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 55c:	cbc9                	beqz	a5,5ee <vprintf+0x102>
 55e:	00ea06b3          	add	a3,s4,a4
 562:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 566:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 568:	c681                	beqz	a3,570 <vprintf+0x84>
 56a:	9752                	add	a4,a4,s4
 56c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 570:	05878163          	beq	a5,s8,5b2 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 574:	05978d63          	beq	a5,s9,5ce <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 578:	07500713          	li	a4,117
 57c:	10e78163          	beq	a5,a4,67e <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 580:	07800713          	li	a4,120
 584:	14e78963          	beq	a5,a4,6d6 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 588:	07000713          	li	a4,112
 58c:	18e78263          	beq	a5,a4,710 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 590:	07300713          	li	a4,115
 594:	1ce78663          	beq	a5,a4,760 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 598:	02500713          	li	a4,37
 59c:	04e79963          	bne	a5,a4,5ee <vprintf+0x102>
        putc(fd, '%');
 5a0:	02500593          	li	a1,37
 5a4:	855a                	mv	a0,s6
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e78080e7          	jalr	-392(ra) # 41e <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b771                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 5b2:	008b8913          	add	s2,s7,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e80080e7          	jalr	-384(ra) # 440 <printint>
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bf85                	j	53c <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 5ce:	06400793          	li	a5,100
 5d2:	02f68d63          	beq	a3,a5,60c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	06c00793          	li	a5,108
 5da:	04f68863          	beq	a3,a5,62a <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 5de:	07500793          	li	a5,117
 5e2:	0af68c63          	beq	a3,a5,69a <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 5e6:	07800793          	li	a5,120
 5ea:	10f68463          	beq	a3,a5,6f2 <vprintf+0x206>
        putc(fd, '%');
 5ee:	02500593          	li	a1,37
 5f2:	855a                	mv	a0,s6
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e2a080e7          	jalr	-470(ra) # 41e <putc>
        putc(fd, c0);
 5fc:	85ca                	mv	a1,s2
 5fe:	855a                	mv	a0,s6
 600:	00000097          	auipc	ra,0x0
 604:	e1e080e7          	jalr	-482(ra) # 41e <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	bf0d                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8913          	add	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	00000097          	auipc	ra,0x0
 61e:	e26080e7          	jalr	-474(ra) # 440 <printint>
        i += 1;
 622:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	bf11                	j	53c <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 62a:	06400793          	li	a5,100
 62e:	02f60963          	beq	a2,a5,660 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 632:	07500793          	li	a5,117
 636:	08f60163          	beq	a2,a5,6b8 <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 63a:	07800793          	li	a5,120
 63e:	faf618e3          	bne	a2,a5,5ee <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	008b8913          	add	s2,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	00000097          	auipc	ra,0x0
 654:	df0080e7          	jalr	-528(ra) # 440 <printint>
        i += 2;
 658:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	bdf9                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	008b8913          	add	s2,s7,8
 664:	4685                	li	a3,1
 666:	4629                	li	a2,10
 668:	000ba583          	lw	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	00000097          	auipc	ra,0x0
 672:	dd2080e7          	jalr	-558(ra) # 440 <printint>
        i += 2;
 676:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	b5c1                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 67e:	008b8913          	add	s2,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000ba583          	lw	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	00000097          	auipc	ra,0x0
 690:	db4080e7          	jalr	-588(ra) # 440 <printint>
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	b555                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	008b8913          	add	s2,s7,8
 69e:	4681                	li	a3,0
 6a0:	4629                	li	a2,10
 6a2:	000ba583          	lw	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	00000097          	auipc	ra,0x0
 6ac:	d98080e7          	jalr	-616(ra) # 440 <printint>
        i += 1;
 6b0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
        i += 1;
 6b6:	b559                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b8913          	add	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	00000097          	auipc	ra,0x0
 6ca:	d7a080e7          	jalr	-646(ra) # 440 <printint>
        i += 2;
 6ce:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
        i += 2;
 6d4:	b5a5                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 6d6:	008b8913          	add	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000ba583          	lw	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	00000097          	auipc	ra,0x0
 6e8:	d5c080e7          	jalr	-676(ra) # 440 <printint>
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b5b1                	j	53c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8913          	add	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	00000097          	auipc	ra,0x0
 704:	d40080e7          	jalr	-704(ra) # 440 <printint>
        i += 1;
 708:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
        i += 1;
 70e:	b53d                	j	53c <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 710:	008b8d13          	add	s10,s7,8
 714:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 718:	03000593          	li	a1,48
 71c:	855a                	mv	a0,s6
 71e:	00000097          	auipc	ra,0x0
 722:	d00080e7          	jalr	-768(ra) # 41e <putc>
  putc(fd, 'x');
 726:	07800593          	li	a1,120
 72a:	855a                	mv	a0,s6
 72c:	00000097          	auipc	ra,0x0
 730:	cf2080e7          	jalr	-782(ra) # 41e <putc>
 734:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 736:	00000b97          	auipc	s7,0x0
 73a:	2dab8b93          	add	s7,s7,730 # a10 <digits>
 73e:	03c9d793          	srl	a5,s3,0x3c
 742:	97de                	add	a5,a5,s7
 744:	0007c583          	lbu	a1,0(a5)
 748:	855a                	mv	a0,s6
 74a:	00000097          	auipc	ra,0x0
 74e:	cd4080e7          	jalr	-812(ra) # 41e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 752:	0992                	sll	s3,s3,0x4
 754:	397d                	addw	s2,s2,-1
 756:	fe0914e3          	bnez	s2,73e <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 75a:	8bea                	mv	s7,s10
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbf9                	j	53c <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 760:	008b8993          	add	s3,s7,8
 764:	000bb903          	ld	s2,0(s7)
 768:	02090163          	beqz	s2,78a <vprintf+0x29e>
        for(; *s; s++)
 76c:	00094583          	lbu	a1,0(s2)
 770:	c585                	beqz	a1,798 <vprintf+0x2ac>
          putc(fd, *s);
 772:	855a                	mv	a0,s6
 774:	00000097          	auipc	ra,0x0
 778:	caa080e7          	jalr	-854(ra) # 41e <putc>
        for(; *s; s++)
 77c:	0905                	add	s2,s2,1
 77e:	00094583          	lbu	a1,0(s2)
 782:	f9e5                	bnez	a1,772 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 784:	8bce                	mv	s7,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	bb55                	j	53c <vprintf+0x50>
          s = "(null)";
 78a:	00000917          	auipc	s2,0x0
 78e:	27e90913          	add	s2,s2,638 # a08 <malloc+0x168>
        for(; *s; s++)
 792:	02800593          	li	a1,40
 796:	bff1                	j	772 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 798:	8bce                	mv	s7,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b345                	j	53c <vprintf+0x50>
    }
  }
}
 79e:	60e6                	ld	ra,88(sp)
 7a0:	6446                	ld	s0,80(sp)
 7a2:	64a6                	ld	s1,72(sp)
 7a4:	6906                	ld	s2,64(sp)
 7a6:	79e2                	ld	s3,56(sp)
 7a8:	7a42                	ld	s4,48(sp)
 7aa:	7aa2                	ld	s5,40(sp)
 7ac:	7b02                	ld	s6,32(sp)
 7ae:	6be2                	ld	s7,24(sp)
 7b0:	6c42                	ld	s8,16(sp)
 7b2:	6ca2                	ld	s9,8(sp)
 7b4:	6d02                	ld	s10,0(sp)
 7b6:	6125                	add	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ba:	715d                	add	sp,sp,-80
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	add	s0,sp,32
 7c2:	e010                	sd	a2,0(s0)
 7c4:	e414                	sd	a3,8(s0)
 7c6:	e818                	sd	a4,16(s0)
 7c8:	ec1c                	sd	a5,24(s0)
 7ca:	03043023          	sd	a6,32(s0)
 7ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d6:	8622                	mv	a2,s0
 7d8:	00000097          	auipc	ra,0x0
 7dc:	d14080e7          	jalr	-748(ra) # 4ec <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6161                	add	sp,sp,80
 7e6:	8082                	ret

00000000000007e8 <printf>:

void
printf(const char *fmt, ...)
{
 7e8:	711d                	add	sp,sp,-96
 7ea:	ec06                	sd	ra,24(sp)
 7ec:	e822                	sd	s0,16(sp)
 7ee:	1000                	add	s0,sp,32
 7f0:	e40c                	sd	a1,8(s0)
 7f2:	e810                	sd	a2,16(s0)
 7f4:	ec14                	sd	a3,24(s0)
 7f6:	f018                	sd	a4,32(s0)
 7f8:	f41c                	sd	a5,40(s0)
 7fa:	03043823          	sd	a6,48(s0)
 7fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 802:	00840613          	add	a2,s0,8
 806:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80a:	85aa                	mv	a1,a0
 80c:	4505                	li	a0,1
 80e:	00000097          	auipc	ra,0x0
 812:	cde080e7          	jalr	-802(ra) # 4ec <vprintf>
}
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6125                	add	sp,sp,96
 81c:	8082                	ret

000000000000081e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81e:	1141                	add	sp,sp,-16
 820:	e422                	sd	s0,8(sp)
 822:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 824:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	00000797          	auipc	a5,0x0
 82c:	7e87b783          	ld	a5,2024(a5) # 1010 <freep>
 830:	a02d                	j	85a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 832:	4618                	lw	a4,8(a2)
 834:	9f2d                	addw	a4,a4,a1
 836:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83a:	6398                	ld	a4,0(a5)
 83c:	6310                	ld	a2,0(a4)
 83e:	a83d                	j	87c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 840:	ff852703          	lw	a4,-8(a0)
 844:	9f31                	addw	a4,a4,a2
 846:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 848:	ff053683          	ld	a3,-16(a0)
 84c:	a091                	j	890 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6398                	ld	a4,0(a5)
 850:	00e7e463          	bltu	a5,a4,858 <free+0x3a>
 854:	00e6ea63          	bltu	a3,a4,868 <free+0x4a>
{
 858:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fed7fae3          	bgeu	a5,a3,84e <free+0x30>
 85e:	6398                	ld	a4,0(a5)
 860:	00e6e463          	bltu	a3,a4,868 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	fee7eae3          	bltu	a5,a4,858 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059813          	sll	a6,a1,0x20
 872:	01c85713          	srl	a4,a6,0x1c
 876:	9736                	add	a4,a4,a3
 878:	fae60de3          	beq	a2,a4,832 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 880:	4790                	lw	a2,8(a5)
 882:	02061593          	sll	a1,a2,0x20
 886:	01c5d713          	srl	a4,a1,0x1c
 88a:	973e                	add	a4,a4,a5
 88c:	fae68ae3          	beq	a3,a4,840 <free+0x22>
    p->s.ptr = bp->s.ptr;
 890:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	76f73f23          	sd	a5,1918(a4) # 1010 <freep>
}
 89a:	6422                	ld	s0,8(sp)
 89c:	0141                	add	sp,sp,16
 89e:	8082                	ret

00000000000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	7139                	add	sp,sp,-64
 8a2:	fc06                	sd	ra,56(sp)
 8a4:	f822                	sd	s0,48(sp)
 8a6:	f426                	sd	s1,40(sp)
 8a8:	f04a                	sd	s2,32(sp)
 8aa:	ec4e                	sd	s3,24(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
 8b2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b4:	02051493          	sll	s1,a0,0x20
 8b8:	9081                	srl	s1,s1,0x20
 8ba:	04bd                	add	s1,s1,15
 8bc:	8091                	srl	s1,s1,0x4
 8be:	0014899b          	addw	s3,s1,1
 8c2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8c4:	00000517          	auipc	a0,0x0
 8c8:	74c53503          	ld	a0,1868(a0) # 1010 <freep>
 8cc:	c515                	beqz	a0,8f8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	02977f63          	bgeu	a4,s1,910 <malloc+0x70>
  if(nu < 4096)
 8d6:	8a4e                	mv	s4,s3
 8d8:	0009871b          	sext.w	a4,s3
 8dc:	6685                	lui	a3,0x1
 8de:	00d77363          	bgeu	a4,a3,8e4 <malloc+0x44>
 8e2:	6a05                	lui	s4,0x1
 8e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e8:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ec:	00000917          	auipc	s2,0x0
 8f0:	72490913          	add	s2,s2,1828 # 1010 <freep>
  if(p == (char*)-1)
 8f4:	5afd                	li	s5,-1
 8f6:	a895                	j	96a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8f8:	00000797          	auipc	a5,0x0
 8fc:	72878793          	add	a5,a5,1832 # 1020 <base>
 900:	00000717          	auipc	a4,0x0
 904:	70f73823          	sd	a5,1808(a4) # 1010 <freep>
 908:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90e:	b7e1                	j	8d6 <malloc+0x36>
      if(p->s.size == nunits)
 910:	02e48c63          	beq	s1,a4,948 <malloc+0xa8>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	02071693          	sll	a3,a4,0x20
 91e:	01c6d713          	srl	a4,a3,0x1c
 922:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 924:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 928:	00000717          	auipc	a4,0x0
 92c:	6ea73423          	sd	a0,1768(a4) # 1010 <freep>
      return (void*)(p + 1);
 930:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 934:	70e2                	ld	ra,56(sp)
 936:	7442                	ld	s0,48(sp)
 938:	74a2                	ld	s1,40(sp)
 93a:	7902                	ld	s2,32(sp)
 93c:	69e2                	ld	s3,24(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
 944:	6121                	add	sp,sp,64
 946:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 948:	6398                	ld	a4,0(a5)
 94a:	e118                	sd	a4,0(a0)
 94c:	bff1                	j	928 <malloc+0x88>
  hp->s.size = nu;
 94e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 952:	0541                	add	a0,a0,16
 954:	00000097          	auipc	ra,0x0
 958:	eca080e7          	jalr	-310(ra) # 81e <free>
  return freep;
 95c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 960:	d971                	beqz	a0,934 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 962:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 964:	4798                	lw	a4,8(a5)
 966:	fa9775e3          	bgeu	a4,s1,910 <malloc+0x70>
    if(p == freep)
 96a:	00093703          	ld	a4,0(s2)
 96e:	853e                	mv	a0,a5
 970:	fef719e3          	bne	a4,a5,962 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 974:	8552                	mv	a0,s4
 976:	00000097          	auipc	ra,0x0
 97a:	a90080e7          	jalr	-1392(ra) # 406 <sbrk>
  if(p == (char*)-1)
 97e:	fd5518e3          	bne	a0,s5,94e <malloc+0xae>
        return 0;
 982:	4501                	li	a0,0
 984:	bf45                	j	934 <malloc+0x94>
