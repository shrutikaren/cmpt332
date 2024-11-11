
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
  20:	00000097          	auipc	ra,0x0
  24:	39a080e7          	jalr	922(ra) # 3ba <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	38e080e7          	jalr	910(ra) # 3c2 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	97058593          	add	a1,a1,-1680 # 9b0 <malloc+0xec>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	794080e7          	jalr	1940(ra) # 7de <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	34e080e7          	jalr	846(ra) # 3a2 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	add	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	95a58593          	add	a1,a1,-1702 # 9c8 <malloc+0x104>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	766080e7          	jalr	1894(ra) # 7de <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	320080e7          	jalr	800(ra) # 3a2 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	add	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  98:	4785                	li	a5,1
  9a:	04a7d763          	bge	a5,a0,e8 <main+0x5e>
  9e:	00858913          	add	s2,a1,8
  a2:	ffe5099b          	addw	s3,a0,-2
  a6:	02099793          	sll	a5,s3,0x20
  aa:	01d7d993          	srl	s3,a5,0x1d
  ae:	05c1                	add	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2) # 1010 <buf>
  b8:	00000097          	auipc	ra,0x0
  bc:	32a080e7          	jalr	810(ra) # 3e2 <open>
  c0:	84aa                	mv	s1,a0
  c2:	02054d63          	bltz	a0,fc <main+0x72>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	2fa080e7          	jalr	762(ra) # 3ca <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	add	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2c2080e7          	jalr	706(ra) # 3a2 <exit>
    cat(0);
  e8:	4501                	li	a0,0
  ea:	00000097          	auipc	ra,0x0
  ee:	f16080e7          	jalr	-234(ra) # 0 <cat>
    exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	2ae080e7          	jalr	686(ra) # 3a2 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fc:	00093603          	ld	a2,0(s2)
 100:	00001597          	auipc	a1,0x1
 104:	8e058593          	add	a1,a1,-1824 # 9e0 <malloc+0x11c>
 108:	4509                	li	a0,2
 10a:	00000097          	auipc	ra,0x0
 10e:	6d4080e7          	jalr	1748(ra) # 7de <fprintf>
      exit(1);
 112:	4505                	li	a0,1
 114:	00000097          	auipc	ra,0x0
 118:	28e080e7          	jalr	654(ra) # 3a2 <exit>

000000000000011c <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 11c:	1141                	add	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	add	s0,sp,16
  extern int main();
  main();
 124:	00000097          	auipc	ra,0x0
 128:	f66080e7          	jalr	-154(ra) # 8a <main>
  exit(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	274080e7          	jalr	628(ra) # 3a2 <exit>

0000000000000136 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 136:	1141                	add	sp,sp,-16
 138:	e422                	sd	s0,8(sp)
 13a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13c:	87aa                	mv	a5,a0
 13e:	0585                	add	a1,a1,1
 140:	0785                	add	a5,a5,1
 142:	fff5c703          	lbu	a4,-1(a1)
 146:	fee78fa3          	sb	a4,-1(a5)
 14a:	fb75                	bnez	a4,13e <strcpy+0x8>
    ;
  return os;
}
 14c:	6422                	ld	s0,8(sp)
 14e:	0141                	add	sp,sp,16
 150:	8082                	ret

0000000000000152 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 152:	1141                	add	sp,sp,-16
 154:	e422                	sd	s0,8(sp)
 156:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 158:	00054783          	lbu	a5,0(a0)
 15c:	cb91                	beqz	a5,170 <strcmp+0x1e>
 15e:	0005c703          	lbu	a4,0(a1)
 162:	00f71763          	bne	a4,a5,170 <strcmp+0x1e>
    p++, q++;
 166:	0505                	add	a0,a0,1
 168:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	fbe5                	bnez	a5,15e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 170:	0005c503          	lbu	a0,0(a1)
}
 174:	40a7853b          	subw	a0,a5,a0
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	add	sp,sp,16
 17c:	8082                	ret

000000000000017e <strlen>:

uint
strlen(const char *s)
{
 17e:	1141                	add	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 184:	00054783          	lbu	a5,0(a0)
 188:	cf91                	beqz	a5,1a4 <strlen+0x26>
 18a:	0505                	add	a0,a0,1
 18c:	87aa                	mv	a5,a0
 18e:	86be                	mv	a3,a5
 190:	0785                	add	a5,a5,1
 192:	fff7c703          	lbu	a4,-1(a5)
 196:	ff65                	bnez	a4,18e <strlen+0x10>
 198:	40a6853b          	subw	a0,a3,a0
 19c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	add	sp,sp,16
 1a2:	8082                	ret
  for(n = 0; s[n]; n++)
 1a4:	4501                	li	a0,0
 1a6:	bfe5                	j	19e <strlen+0x20>

00000000000001a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a8:	1141                	add	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ae:	ca19                	beqz	a2,1c4 <memset+0x1c>
 1b0:	87aa                	mv	a5,a0
 1b2:	1602                	sll	a2,a2,0x20
 1b4:	9201                	srl	a2,a2,0x20
 1b6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1be:	0785                	add	a5,a5,1
 1c0:	fee79de3          	bne	a5,a4,1ba <memset+0x12>
  }
  return dst;
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	add	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <strchr>:

char*
strchr(const char *s, char c)
{
 1ca:	1141                	add	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	add	s0,sp,16
  for(; *s; s++)
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	cb99                	beqz	a5,1ea <strchr+0x20>
    if(*s == c)
 1d6:	00f58763          	beq	a1,a5,1e4 <strchr+0x1a>
  for(; *s; s++)
 1da:	0505                	add	a0,a0,1
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	fbfd                	bnez	a5,1d6 <strchr+0xc>
      return (char*)s;
  return 0;
 1e2:	4501                	li	a0,0
}
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	add	sp,sp,16
 1e8:	8082                	ret
  return 0;
 1ea:	4501                	li	a0,0
 1ec:	bfe5                	j	1e4 <strchr+0x1a>

00000000000001ee <gets>:

char*
gets(char *buf, int max)
{
 1ee:	711d                	add	sp,sp,-96
 1f0:	ec86                	sd	ra,88(sp)
 1f2:	e8a2                	sd	s0,80(sp)
 1f4:	e4a6                	sd	s1,72(sp)
 1f6:	e0ca                	sd	s2,64(sp)
 1f8:	fc4e                	sd	s3,56(sp)
 1fa:	f852                	sd	s4,48(sp)
 1fc:	f456                	sd	s5,40(sp)
 1fe:	f05a                	sd	s6,32(sp)
 200:	ec5e                	sd	s7,24(sp)
 202:	1080                	add	s0,sp,96
 204:	8baa                	mv	s7,a0
 206:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 208:	892a                	mv	s2,a0
 20a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20c:	4aa9                	li	s5,10
 20e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 210:	89a6                	mv	s3,s1
 212:	2485                	addw	s1,s1,1
 214:	0344d863          	bge	s1,s4,244 <gets+0x56>
    cc = read(0, &c, 1);
 218:	4605                	li	a2,1
 21a:	faf40593          	add	a1,s0,-81
 21e:	4501                	li	a0,0
 220:	00000097          	auipc	ra,0x0
 224:	19a080e7          	jalr	410(ra) # 3ba <read>
    if(cc < 1)
 228:	00a05e63          	blez	a0,244 <gets+0x56>
    buf[i++] = c;
 22c:	faf44783          	lbu	a5,-81(s0)
 230:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 234:	01578763          	beq	a5,s5,242 <gets+0x54>
 238:	0905                	add	s2,s2,1
 23a:	fd679be3          	bne	a5,s6,210 <gets+0x22>
  for(i=0; i+1 < max; ){
 23e:	89a6                	mv	s3,s1
 240:	a011                	j	244 <gets+0x56>
 242:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 244:	99de                	add	s3,s3,s7
 246:	00098023          	sb	zero,0(s3)
  return buf;
}
 24a:	855e                	mv	a0,s7
 24c:	60e6                	ld	ra,88(sp)
 24e:	6446                	ld	s0,80(sp)
 250:	64a6                	ld	s1,72(sp)
 252:	6906                	ld	s2,64(sp)
 254:	79e2                	ld	s3,56(sp)
 256:	7a42                	ld	s4,48(sp)
 258:	7aa2                	ld	s5,40(sp)
 25a:	7b02                	ld	s6,32(sp)
 25c:	6be2                	ld	s7,24(sp)
 25e:	6125                	add	sp,sp,96
 260:	8082                	ret

0000000000000262 <stat>:

int
stat(const char *n, struct stat *st)
{
 262:	1101                	add	sp,sp,-32
 264:	ec06                	sd	ra,24(sp)
 266:	e822                	sd	s0,16(sp)
 268:	e426                	sd	s1,8(sp)
 26a:	e04a                	sd	s2,0(sp)
 26c:	1000                	add	s0,sp,32
 26e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 270:	4581                	li	a1,0
 272:	00000097          	auipc	ra,0x0
 276:	170080e7          	jalr	368(ra) # 3e2 <open>
  if(fd < 0)
 27a:	02054563          	bltz	a0,2a4 <stat+0x42>
 27e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 280:	85ca                	mv	a1,s2
 282:	00000097          	auipc	ra,0x0
 286:	178080e7          	jalr	376(ra) # 3fa <fstat>
 28a:	892a                	mv	s2,a0
  close(fd);
 28c:	8526                	mv	a0,s1
 28e:	00000097          	auipc	ra,0x0
 292:	13c080e7          	jalr	316(ra) # 3ca <close>
  return r;
}
 296:	854a                	mv	a0,s2
 298:	60e2                	ld	ra,24(sp)
 29a:	6442                	ld	s0,16(sp)
 29c:	64a2                	ld	s1,8(sp)
 29e:	6902                	ld	s2,0(sp)
 2a0:	6105                	add	sp,sp,32
 2a2:	8082                	ret
    return -1;
 2a4:	597d                	li	s2,-1
 2a6:	bfc5                	j	296 <stat+0x34>

00000000000002a8 <atoi>:

int
atoi(const char *s)
{
 2a8:	1141                	add	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ae:	00054683          	lbu	a3,0(a0)
 2b2:	fd06879b          	addw	a5,a3,-48
 2b6:	0ff7f793          	zext.b	a5,a5
 2ba:	4625                	li	a2,9
 2bc:	02f66863          	bltu	a2,a5,2ec <atoi+0x44>
 2c0:	872a                	mv	a4,a0
  n = 0;
 2c2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c4:	0705                	add	a4,a4,1
 2c6:	0025179b          	sllw	a5,a0,0x2
 2ca:	9fa9                	addw	a5,a5,a0
 2cc:	0017979b          	sllw	a5,a5,0x1
 2d0:	9fb5                	addw	a5,a5,a3
 2d2:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d6:	00074683          	lbu	a3,0(a4)
 2da:	fd06879b          	addw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	fef671e3          	bgeu	a2,a5,2c4 <atoi+0x1c>
  return n;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	add	sp,sp,16
 2ea:	8082                	ret
  n = 0;
 2ec:	4501                	li	a0,0
 2ee:	bfe5                	j	2e6 <atoi+0x3e>

00000000000002f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f0:	1141                	add	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f6:	02b57463          	bgeu	a0,a1,31e <memmove+0x2e>
    while(n-- > 0)
 2fa:	00c05f63          	blez	a2,318 <memmove+0x28>
 2fe:	1602                	sll	a2,a2,0x20
 300:	9201                	srl	a2,a2,0x20
 302:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 306:	872a                	mv	a4,a0
      *dst++ = *src++;
 308:	0585                	add	a1,a1,1
 30a:	0705                	add	a4,a4,1
 30c:	fff5c683          	lbu	a3,-1(a1)
 310:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 314:	fee79ae3          	bne	a5,a4,308 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	add	sp,sp,16
 31c:	8082                	ret
    dst += n;
 31e:	00c50733          	add	a4,a0,a2
    src += n;
 322:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 324:	fec05ae3          	blez	a2,318 <memmove+0x28>
 328:	fff6079b          	addw	a5,a2,-1
 32c:	1782                	sll	a5,a5,0x20
 32e:	9381                	srl	a5,a5,0x20
 330:	fff7c793          	not	a5,a5
 334:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 336:	15fd                	add	a1,a1,-1
 338:	177d                	add	a4,a4,-1
 33a:	0005c683          	lbu	a3,0(a1)
 33e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x46>
 346:	bfc9                	j	318 <memmove+0x28>

0000000000000348 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 348:	1141                	add	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34e:	ca05                	beqz	a2,37e <memcmp+0x36>
 350:	fff6069b          	addw	a3,a2,-1
 354:	1682                	sll	a3,a3,0x20
 356:	9281                	srl	a3,a3,0x20
 358:	0685                	add	a3,a3,1
 35a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35c:	00054783          	lbu	a5,0(a0)
 360:	0005c703          	lbu	a4,0(a1)
 364:	00e79863          	bne	a5,a4,374 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 368:	0505                	add	a0,a0,1
    p2++;
 36a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 36c:	fed518e3          	bne	a0,a3,35c <memcmp+0x14>
  }
  return 0;
 370:	4501                	li	a0,0
 372:	a019                	j	378 <memcmp+0x30>
      return *p1 - *p2;
 374:	40e7853b          	subw	a0,a5,a4
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	add	sp,sp,16
 37c:	8082                	ret
  return 0;
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <memcmp+0x30>

0000000000000382 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 382:	1141                	add	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 38a:	00000097          	auipc	ra,0x0
 38e:	f66080e7          	jalr	-154(ra) # 2f0 <memmove>
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	add	sp,sp,16
 398:	8082                	ret

000000000000039a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39a:	4885                	li	a7,1
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a2:	4889                	li	a7,2
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 3aa:	488d                	li	a7,3
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b2:	4891                	li	a7,4
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <read>:
.global read
read:
 li a7, SYS_read
 3ba:	4895                	li	a7,5
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <write>:
.global write
write:
 li a7, SYS_write
 3c2:	48c1                	li	a7,16
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <close>:
.global close
close:
 li a7, SYS_close
 3ca:	48d5                	li	a7,21
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d2:	4899                	li	a7,6
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <exec>:
.global exec
exec:
 li a7, SYS_exec
 3da:	489d                	li	a7,7
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <open>:
.global open
open:
 li a7, SYS_open
 3e2:	48bd                	li	a7,15
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ea:	48c5                	li	a7,17
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f2:	48c9                	li	a7,18
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fa:	48a1                	li	a7,8
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <link>:
.global link
link:
 li a7, SYS_link
 402:	48cd                	li	a7,19
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40a:	48d1                	li	a7,20
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 412:	48a5                	li	a7,9
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <dup>:
.global dup
dup:
 li a7, SYS_dup
 41a:	48a9                	li	a7,10
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 422:	48ad                	li	a7,11
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 42a:	48b1                	li	a7,12
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 432:	48b5                	li	a7,13
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43a:	48b9                	li	a7,14
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 442:	1101                	add	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	add	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44e:	4605                	li	a2,1
 450:	fef40593          	add	a1,s0,-17
 454:	00000097          	auipc	ra,0x0
 458:	f6e080e7          	jalr	-146(ra) # 3c2 <write>
}
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	6105                	add	sp,sp,32
 462:	8082                	ret

0000000000000464 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 464:	7139                	add	sp,sp,-64
 466:	fc06                	sd	ra,56(sp)
 468:	f822                	sd	s0,48(sp)
 46a:	f426                	sd	s1,40(sp)
 46c:	f04a                	sd	s2,32(sp)
 46e:	ec4e                	sd	s3,24(sp)
 470:	0080                	add	s0,sp,64
 472:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 474:	c299                	beqz	a3,47a <printint+0x16>
 476:	0805c963          	bltz	a1,508 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47a:	2581                	sext.w	a1,a1
  neg = 0;
 47c:	4881                	li	a7,0
 47e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 482:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 484:	2601                	sext.w	a2,a2
 486:	00000517          	auipc	a0,0x0
 48a:	57a50513          	add	a0,a0,1402 # a00 <digits>
 48e:	883a                	mv	a6,a4
 490:	2705                	addw	a4,a4,1
 492:	02c5f7bb          	remuw	a5,a1,a2
 496:	1782                	sll	a5,a5,0x20
 498:	9381                	srl	a5,a5,0x20
 49a:	97aa                	add	a5,a5,a0
 49c:	0007c783          	lbu	a5,0(a5)
 4a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a4:	0005879b          	sext.w	a5,a1
 4a8:	02c5d5bb          	divuw	a1,a1,a2
 4ac:	0685                	add	a3,a3,1
 4ae:	fec7f0e3          	bgeu	a5,a2,48e <printint+0x2a>
  if(neg)
 4b2:	00088c63          	beqz	a7,4ca <printint+0x66>
    buf[i++] = '-';
 4b6:	fd070793          	add	a5,a4,-48
 4ba:	00878733          	add	a4,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef70823          	sb	a5,-16(a4)
 4c6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4ca:	02e05863          	blez	a4,4fa <printint+0x96>
 4ce:	fc040793          	add	a5,s0,-64
 4d2:	00e78933          	add	s2,a5,a4
 4d6:	fff78993          	add	s3,a5,-1
 4da:	99ba                	add	s3,s3,a4
 4dc:	377d                	addw	a4,a4,-1
 4de:	1702                	sll	a4,a4,0x20
 4e0:	9301                	srl	a4,a4,0x20
 4e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e6:	fff94583          	lbu	a1,-1(s2)
 4ea:	8526                	mv	a0,s1
 4ec:	00000097          	auipc	ra,0x0
 4f0:	f56080e7          	jalr	-170(ra) # 442 <putc>
  while(--i >= 0)
 4f4:	197d                	add	s2,s2,-1
 4f6:	ff3918e3          	bne	s2,s3,4e6 <printint+0x82>
}
 4fa:	70e2                	ld	ra,56(sp)
 4fc:	7442                	ld	s0,48(sp)
 4fe:	74a2                	ld	s1,40(sp)
 500:	7902                	ld	s2,32(sp)
 502:	69e2                	ld	s3,24(sp)
 504:	6121                	add	sp,sp,64
 506:	8082                	ret
    x = -xx;
 508:	40b005bb          	negw	a1,a1
    neg = 1;
 50c:	4885                	li	a7,1
    x = -xx;
 50e:	bf85                	j	47e <printint+0x1a>

0000000000000510 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 510:	711d                	add	sp,sp,-96
 512:	ec86                	sd	ra,88(sp)
 514:	e8a2                	sd	s0,80(sp)
 516:	e4a6                	sd	s1,72(sp)
 518:	e0ca                	sd	s2,64(sp)
 51a:	fc4e                	sd	s3,56(sp)
 51c:	f852                	sd	s4,48(sp)
 51e:	f456                	sd	s5,40(sp)
 520:	f05a                	sd	s6,32(sp)
 522:	ec5e                	sd	s7,24(sp)
 524:	e862                	sd	s8,16(sp)
 526:	e466                	sd	s9,8(sp)
 528:	e06a                	sd	s10,0(sp)
 52a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52c:	0005c903          	lbu	s2,0(a1)
 530:	28090963          	beqz	s2,7c2 <vprintf+0x2b2>
 534:	8b2a                	mv	s6,a0
 536:	8a2e                	mv	s4,a1
 538:	8bb2                	mv	s7,a2
  state = 0;
 53a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 53c:	4481                	li	s1,0
 53e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 540:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 544:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 548:	06c00c93          	li	s9,108
 54c:	a015                	j	570 <vprintf+0x60>
        putc(fd, c0);
 54e:	85ca                	mv	a1,s2
 550:	855a                	mv	a0,s6
 552:	00000097          	auipc	ra,0x0
 556:	ef0080e7          	jalr	-272(ra) # 442 <putc>
 55a:	a019                	j	560 <vprintf+0x50>
    } else if(state == '%'){
 55c:	03598263          	beq	s3,s5,580 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 560:	2485                	addw	s1,s1,1
 562:	8726                	mv	a4,s1
 564:	009a07b3          	add	a5,s4,s1
 568:	0007c903          	lbu	s2,0(a5)
 56c:	24090b63          	beqz	s2,7c2 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 570:	0009079b          	sext.w	a5,s2
    if(state == 0){
 574:	fe0994e3          	bnez	s3,55c <vprintf+0x4c>
      if(c0 == '%'){
 578:	fd579be3          	bne	a5,s5,54e <vprintf+0x3e>
        state = '%';
 57c:	89be                	mv	s3,a5
 57e:	b7cd                	j	560 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 580:	cbc9                	beqz	a5,612 <vprintf+0x102>
 582:	00ea06b3          	add	a3,s4,a4
 586:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 58a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 58c:	c681                	beqz	a3,594 <vprintf+0x84>
 58e:	9752                	add	a4,a4,s4
 590:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 594:	05878163          	beq	a5,s8,5d6 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 598:	05978d63          	beq	a5,s9,5f2 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 59c:	07500713          	li	a4,117
 5a0:	10e78163          	beq	a5,a4,6a2 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5a4:	07800713          	li	a4,120
 5a8:	14e78963          	beq	a5,a4,6fa <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ac:	07000713          	li	a4,112
 5b0:	18e78263          	beq	a5,a4,734 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5b4:	07300713          	li	a4,115
 5b8:	1ce78663          	beq	a5,a4,784 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5bc:	02500713          	li	a4,37
 5c0:	04e79963          	bne	a5,a4,612 <vprintf+0x102>
        putc(fd, '%');
 5c4:	02500593          	li	a1,37
 5c8:	855a                	mv	a0,s6
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e78080e7          	jalr	-392(ra) # 442 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b771                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 5d6:	008b8913          	add	s2,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e80080e7          	jalr	-384(ra) # 464 <printint>
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bf85                	j	560 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 5f2:	06400793          	li	a5,100
 5f6:	02f68d63          	beq	a3,a5,630 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fa:	06c00793          	li	a5,108
 5fe:	04f68863          	beq	a3,a5,64e <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 602:	07500793          	li	a5,117
 606:	0af68c63          	beq	a3,a5,6be <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 60a:	07800793          	li	a5,120
 60e:	10f68463          	beq	a3,a5,716 <vprintf+0x206>
        putc(fd, '%');
 612:	02500593          	li	a1,37
 616:	855a                	mv	a0,s6
 618:	00000097          	auipc	ra,0x0
 61c:	e2a080e7          	jalr	-470(ra) # 442 <putc>
        putc(fd, c0);
 620:	85ca                	mv	a1,s2
 622:	855a                	mv	a0,s6
 624:	00000097          	auipc	ra,0x0
 628:	e1e080e7          	jalr	-482(ra) # 442 <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf0d                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8913          	add	s2,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	00000097          	auipc	ra,0x0
 642:	e26080e7          	jalr	-474(ra) # 464 <printint>
        i += 1;
 646:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	bf11                	j	560 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 64e:	06400793          	li	a5,100
 652:	02f60963          	beq	a2,a5,684 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 656:	07500793          	li	a5,117
 65a:	08f60163          	beq	a2,a5,6dc <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 65e:	07800793          	li	a5,120
 662:	faf618e3          	bne	a2,a5,612 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	008b8913          	add	s2,s7,8
 66a:	4681                	li	a3,0
 66c:	4641                	li	a2,16
 66e:	000ba583          	lw	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	00000097          	auipc	ra,0x0
 678:	df0080e7          	jalr	-528(ra) # 464 <printint>
        i += 2;
 67c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
        i += 2;
 682:	bdf9                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 684:	008b8913          	add	s2,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	00000097          	auipc	ra,0x0
 696:	dd2080e7          	jalr	-558(ra) # 464 <printint>
        i += 2;
 69a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	b5c1                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 6a2:	008b8913          	add	s2,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4629                	li	a2,10
 6aa:	000ba583          	lw	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	00000097          	auipc	ra,0x0
 6b4:	db4080e7          	jalr	-588(ra) # 464 <printint>
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b555                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b8913          	add	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	00000097          	auipc	ra,0x0
 6d0:	d98080e7          	jalr	-616(ra) # 464 <printint>
        i += 1;
 6d4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
        i += 1;
 6da:	b559                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	008b8913          	add	s2,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000ba583          	lw	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	00000097          	auipc	ra,0x0
 6ee:	d7a080e7          	jalr	-646(ra) # 464 <printint>
        i += 2;
 6f2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
        i += 2;
 6f8:	b5a5                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 6fa:	008b8913          	add	s2,s7,8
 6fe:	4681                	li	a3,0
 700:	4641                	li	a2,16
 702:	000ba583          	lw	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	00000097          	auipc	ra,0x0
 70c:	d5c080e7          	jalr	-676(ra) # 464 <printint>
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	b5b1                	j	560 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 716:	008b8913          	add	s2,s7,8
 71a:	4681                	li	a3,0
 71c:	4641                	li	a2,16
 71e:	000ba583          	lw	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	00000097          	auipc	ra,0x0
 728:	d40080e7          	jalr	-704(ra) # 464 <printint>
        i += 1;
 72c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 72e:	8bca                	mv	s7,s2
      state = 0;
 730:	4981                	li	s3,0
        i += 1;
 732:	b53d                	j	560 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 734:	008b8d13          	add	s10,s7,8
 738:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 73c:	03000593          	li	a1,48
 740:	855a                	mv	a0,s6
 742:	00000097          	auipc	ra,0x0
 746:	d00080e7          	jalr	-768(ra) # 442 <putc>
  putc(fd, 'x');
 74a:	07800593          	li	a1,120
 74e:	855a                	mv	a0,s6
 750:	00000097          	auipc	ra,0x0
 754:	cf2080e7          	jalr	-782(ra) # 442 <putc>
 758:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75a:	00000b97          	auipc	s7,0x0
 75e:	2a6b8b93          	add	s7,s7,678 # a00 <digits>
 762:	03c9d793          	srl	a5,s3,0x3c
 766:	97de                	add	a5,a5,s7
 768:	0007c583          	lbu	a1,0(a5)
 76c:	855a                	mv	a0,s6
 76e:	00000097          	auipc	ra,0x0
 772:	cd4080e7          	jalr	-812(ra) # 442 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 776:	0992                	sll	s3,s3,0x4
 778:	397d                	addw	s2,s2,-1
 77a:	fe0914e3          	bnez	s2,762 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 77e:	8bea                	mv	s7,s10
      state = 0;
 780:	4981                	li	s3,0
 782:	bbf9                	j	560 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 784:	008b8993          	add	s3,s7,8
 788:	000bb903          	ld	s2,0(s7)
 78c:	02090163          	beqz	s2,7ae <vprintf+0x29e>
        for(; *s; s++)
 790:	00094583          	lbu	a1,0(s2)
 794:	c585                	beqz	a1,7bc <vprintf+0x2ac>
          putc(fd, *s);
 796:	855a                	mv	a0,s6
 798:	00000097          	auipc	ra,0x0
 79c:	caa080e7          	jalr	-854(ra) # 442 <putc>
        for(; *s; s++)
 7a0:	0905                	add	s2,s2,1
 7a2:	00094583          	lbu	a1,0(s2)
 7a6:	f9e5                	bnez	a1,796 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 7a8:	8bce                	mv	s7,s3
      state = 0;
 7aa:	4981                	li	s3,0
 7ac:	bb55                	j	560 <vprintf+0x50>
          s = "(null)";
 7ae:	00000917          	auipc	s2,0x0
 7b2:	24a90913          	add	s2,s2,586 # 9f8 <malloc+0x134>
        for(; *s; s++)
 7b6:	02800593          	li	a1,40
 7ba:	bff1                	j	796 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 7bc:	8bce                	mv	s7,s3
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b345                	j	560 <vprintf+0x50>
    }
  }
}
 7c2:	60e6                	ld	ra,88(sp)
 7c4:	6446                	ld	s0,80(sp)
 7c6:	64a6                	ld	s1,72(sp)
 7c8:	6906                	ld	s2,64(sp)
 7ca:	79e2                	ld	s3,56(sp)
 7cc:	7a42                	ld	s4,48(sp)
 7ce:	7aa2                	ld	s5,40(sp)
 7d0:	7b02                	ld	s6,32(sp)
 7d2:	6be2                	ld	s7,24(sp)
 7d4:	6c42                	ld	s8,16(sp)
 7d6:	6ca2                	ld	s9,8(sp)
 7d8:	6d02                	ld	s10,0(sp)
 7da:	6125                	add	sp,sp,96
 7dc:	8082                	ret

00000000000007de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7de:	715d                	add	sp,sp,-80
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	add	s0,sp,32
 7e6:	e010                	sd	a2,0(s0)
 7e8:	e414                	sd	a3,8(s0)
 7ea:	e818                	sd	a4,16(s0)
 7ec:	ec1c                	sd	a5,24(s0)
 7ee:	03043023          	sd	a6,32(s0)
 7f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fa:	8622                	mv	a2,s0
 7fc:	00000097          	auipc	ra,0x0
 800:	d14080e7          	jalr	-748(ra) # 510 <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6161                	add	sp,sp,80
 80a:	8082                	ret

000000000000080c <printf>:

void
printf(const char *fmt, ...)
{
 80c:	711d                	add	sp,sp,-96
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	add	s0,sp,32
 814:	e40c                	sd	a1,8(s0)
 816:	e810                	sd	a2,16(s0)
 818:	ec14                	sd	a3,24(s0)
 81a:	f018                	sd	a4,32(s0)
 81c:	f41c                	sd	a5,40(s0)
 81e:	03043823          	sd	a6,48(s0)
 822:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 826:	00840613          	add	a2,s0,8
 82a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82e:	85aa                	mv	a1,a0
 830:	4505                	li	a0,1
 832:	00000097          	auipc	ra,0x0
 836:	cde080e7          	jalr	-802(ra) # 510 <vprintf>
}
 83a:	60e2                	ld	ra,24(sp)
 83c:	6442                	ld	s0,16(sp)
 83e:	6125                	add	sp,sp,96
 840:	8082                	ret

0000000000000842 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 842:	1141                	add	sp,sp,-16
 844:	e422                	sd	s0,8(sp)
 846:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 848:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	00000797          	auipc	a5,0x0
 850:	7b47b783          	ld	a5,1972(a5) # 1000 <freep>
 854:	a02d                	j	87e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 856:	4618                	lw	a4,8(a2)
 858:	9f2d                	addw	a4,a4,a1
 85a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 85e:	6398                	ld	a4,0(a5)
 860:	6310                	ld	a2,0(a4)
 862:	a83d                	j	8a0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 864:	ff852703          	lw	a4,-8(a0)
 868:	9f31                	addw	a4,a4,a2
 86a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 86c:	ff053683          	ld	a3,-16(a0)
 870:	a091                	j	8b4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	6398                	ld	a4,0(a5)
 874:	00e7e463          	bltu	a5,a4,87c <free+0x3a>
 878:	00e6ea63          	bltu	a3,a4,88c <free+0x4a>
{
 87c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87e:	fed7fae3          	bgeu	a5,a3,872 <free+0x30>
 882:	6398                	ld	a4,0(a5)
 884:	00e6e463          	bltu	a3,a4,88c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 888:	fee7eae3          	bltu	a5,a4,87c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 88c:	ff852583          	lw	a1,-8(a0)
 890:	6390                	ld	a2,0(a5)
 892:	02059813          	sll	a6,a1,0x20
 896:	01c85713          	srl	a4,a6,0x1c
 89a:	9736                	add	a4,a4,a3
 89c:	fae60de3          	beq	a2,a4,856 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a4:	4790                	lw	a2,8(a5)
 8a6:	02061593          	sll	a1,a2,0x20
 8aa:	01c5d713          	srl	a4,a1,0x1c
 8ae:	973e                	add	a4,a4,a5
 8b0:	fae68ae3          	beq	a3,a4,864 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8b4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74f73523          	sd	a5,1866(a4) # 1000 <freep>
}
 8be:	6422                	ld	s0,8(sp)
 8c0:	0141                	add	sp,sp,16
 8c2:	8082                	ret

00000000000008c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c4:	7139                	add	sp,sp,-64
 8c6:	fc06                	sd	ra,56(sp)
 8c8:	f822                	sd	s0,48(sp)
 8ca:	f426                	sd	s1,40(sp)
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	ec4e                	sd	s3,24(sp)
 8d0:	e852                	sd	s4,16(sp)
 8d2:	e456                	sd	s5,8(sp)
 8d4:	e05a                	sd	s6,0(sp)
 8d6:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d8:	02051493          	sll	s1,a0,0x20
 8dc:	9081                	srl	s1,s1,0x20
 8de:	04bd                	add	s1,s1,15
 8e0:	8091                	srl	s1,s1,0x4
 8e2:	0014899b          	addw	s3,s1,1
 8e6:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8e8:	00000517          	auipc	a0,0x0
 8ec:	71853503          	ld	a0,1816(a0) # 1000 <freep>
 8f0:	c515                	beqz	a0,91c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	02977f63          	bgeu	a4,s1,934 <malloc+0x70>
  if(nu < 4096)
 8fa:	8a4e                	mv	s4,s3
 8fc:	0009871b          	sext.w	a4,s3
 900:	6685                	lui	a3,0x1
 902:	00d77363          	bgeu	a4,a3,908 <malloc+0x44>
 906:	6a05                	lui	s4,0x1
 908:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 910:	00000917          	auipc	s2,0x0
 914:	6f090913          	add	s2,s2,1776 # 1000 <freep>
  if(p == (char*)-1)
 918:	5afd                	li	s5,-1
 91a:	a895                	j	98e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 91c:	00001797          	auipc	a5,0x1
 920:	8f478793          	add	a5,a5,-1804 # 1210 <base>
 924:	00000717          	auipc	a4,0x0
 928:	6cf73e23          	sd	a5,1756(a4) # 1000 <freep>
 92c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 932:	b7e1                	j	8fa <malloc+0x36>
      if(p->s.size == nunits)
 934:	02e48c63          	beq	s1,a4,96c <malloc+0xa8>
        p->s.size -= nunits;
 938:	4137073b          	subw	a4,a4,s3
 93c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93e:	02071693          	sll	a3,a4,0x20
 942:	01c6d713          	srl	a4,a3,0x1c
 946:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 948:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94c:	00000717          	auipc	a4,0x0
 950:	6aa73a23          	sd	a0,1716(a4) # 1000 <freep>
      return (void*)(p + 1);
 954:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 958:	70e2                	ld	ra,56(sp)
 95a:	7442                	ld	s0,48(sp)
 95c:	74a2                	ld	s1,40(sp)
 95e:	7902                	ld	s2,32(sp)
 960:	69e2                	ld	s3,24(sp)
 962:	6a42                	ld	s4,16(sp)
 964:	6aa2                	ld	s5,8(sp)
 966:	6b02                	ld	s6,0(sp)
 968:	6121                	add	sp,sp,64
 96a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 96c:	6398                	ld	a4,0(a5)
 96e:	e118                	sd	a4,0(a0)
 970:	bff1                	j	94c <malloc+0x88>
  hp->s.size = nu;
 972:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 976:	0541                	add	a0,a0,16
 978:	00000097          	auipc	ra,0x0
 97c:	eca080e7          	jalr	-310(ra) # 842 <free>
  return freep;
 980:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 984:	d971                	beqz	a0,958 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 986:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 988:	4798                	lw	a4,8(a5)
 98a:	fa9775e3          	bgeu	a4,s1,934 <malloc+0x70>
    if(p == freep)
 98e:	00093703          	ld	a4,0(s2)
 992:	853e                	mv	a0,a5
 994:	fef719e3          	bne	a4,a5,986 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 998:	8552                	mv	a0,s4
 99a:	00000097          	auipc	ra,0x0
 99e:	a90080e7          	jalr	-1392(ra) # 42a <sbrk>
  if(p == (char*)-1)
 9a2:	fd5518e3          	bne	a0,s5,972 <malloc+0xae>
        return 0;
 9a6:	4501                	li	a0,0
 9a8:	bf45                	j	958 <malloc+0x94>
