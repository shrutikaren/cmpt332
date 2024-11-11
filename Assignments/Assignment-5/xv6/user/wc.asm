
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	add	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	add	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	add	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9e8a0a13          	add	s4,s4,-1560 # a20 <malloc+0xee>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f2080e7          	jalr	498(ra) # 238 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	add	s1,s1,1
  54:	00998d63          	beq	s3,s1,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3ac080e7          	jalr	940(ra) # 428 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	f8648493          	add	s1,s1,-122 # 1010 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	99250513          	add	a0,a0,-1646 # a38 <malloc+0x106>
  ae:	00000097          	auipc	ra,0x0
  b2:	7cc080e7          	jalr	1996(ra) # 87a <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	add	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	95450513          	add	a0,a0,-1708 # a28 <malloc+0xf6>
  dc:	00000097          	auipc	ra,0x0
  e0:	79e080e7          	jalr	1950(ra) # 87a <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	32a080e7          	jalr	810(ra) # 410 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	add	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
  fa:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fc:	4785                	li	a5,1
  fe:	04a7d963          	bge	a5,a0,150 <main+0x62>
 102:	00858913          	add	s2,a1,8
 106:	ffe5099b          	addw	s3,a0,-2
 10a:	02099793          	sll	a5,s3,0x20
 10e:	01d7d993          	srl	s3,a5,0x1d
 112:	05c1                	add	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	334080e7          	jalr	820(ra) # 450 <open>
 124:	84aa                	mv	s1,a0
 126:	04054363          	bltz	a0,16c <main+0x7e>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	300080e7          	jalr	768(ra) # 438 <close>
  for(i = 1; i < argc; i++){
 140:	0921                	add	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2c8080e7          	jalr	712(ra) # 410 <exit>
    wc(0, "");
 150:	00001597          	auipc	a1,0x1
 154:	8f858593          	add	a1,a1,-1800 # a48 <malloc+0x116>
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	ea6080e7          	jalr	-346(ra) # 0 <wc>
    exit(0);
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	2ac080e7          	jalr	684(ra) # 410 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 16c:	00093583          	ld	a1,0(s2)
 170:	00001517          	auipc	a0,0x1
 174:	8e050513          	add	a0,a0,-1824 # a50 <malloc+0x11e>
 178:	00000097          	auipc	ra,0x0
 17c:	702080e7          	jalr	1794(ra) # 87a <printf>
      exit(1);
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	28e080e7          	jalr	654(ra) # 410 <exit>

000000000000018a <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 18a:	1141                	add	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	add	s0,sp,16
  extern int main();
  main();
 192:	00000097          	auipc	ra,0x0
 196:	f5c080e7          	jalr	-164(ra) # ee <main>
  exit(0);
 19a:	4501                	li	a0,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	274080e7          	jalr	628(ra) # 410 <exit>

00000000000001a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a4:	1141                	add	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1aa:	87aa                	mv	a5,a0
 1ac:	0585                	add	a1,a1,1
 1ae:	0785                	add	a5,a5,1
 1b0:	fff5c703          	lbu	a4,-1(a1)
 1b4:	fee78fa3          	sb	a4,-1(a5)
 1b8:	fb75                	bnez	a4,1ac <strcpy+0x8>
    ;
  return os;
}
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	add	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c0:	1141                	add	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cb91                	beqz	a5,1de <strcmp+0x1e>
 1cc:	0005c703          	lbu	a4,0(a1)
 1d0:	00f71763          	bne	a4,a5,1de <strcmp+0x1e>
    p++, q++;
 1d4:	0505                	add	a0,a0,1
 1d6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbe5                	bnez	a5,1cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1de:	0005c503          	lbu	a0,0(a1)
}
 1e2:	40a7853b          	subw	a0,a5,a0
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	add	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strlen>:

uint
strlen(const char *s)
{
 1ec:	1141                	add	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf91                	beqz	a5,212 <strlen+0x26>
 1f8:	0505                	add	a0,a0,1
 1fa:	87aa                	mv	a5,a0
 1fc:	86be                	mv	a3,a5
 1fe:	0785                	add	a5,a5,1
 200:	fff7c703          	lbu	a4,-1(a5)
 204:	ff65                	bnez	a4,1fc <strlen+0x10>
 206:	40a6853b          	subw	a0,a3,a0
 20a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	add	sp,sp,16
 210:	8082                	ret
  for(n = 0; s[n]; n++)
 212:	4501                	li	a0,0
 214:	bfe5                	j	20c <strlen+0x20>

0000000000000216 <memset>:

void*
memset(void *dst, int c, uint n)
{
 216:	1141                	add	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 21c:	ca19                	beqz	a2,232 <memset+0x1c>
 21e:	87aa                	mv	a5,a0
 220:	1602                	sll	a2,a2,0x20
 222:	9201                	srl	a2,a2,0x20
 224:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 228:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 22c:	0785                	add	a5,a5,1
 22e:	fee79de3          	bne	a5,a4,228 <memset+0x12>
  }
  return dst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	add	sp,sp,16
 236:	8082                	ret

0000000000000238 <strchr>:

char*
strchr(const char *s, char c)
{
 238:	1141                	add	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	add	s0,sp,16
  for(; *s; s++)
 23e:	00054783          	lbu	a5,0(a0)
 242:	cb99                	beqz	a5,258 <strchr+0x20>
    if(*s == c)
 244:	00f58763          	beq	a1,a5,252 <strchr+0x1a>
  for(; *s; s++)
 248:	0505                	add	a0,a0,1
 24a:	00054783          	lbu	a5,0(a0)
 24e:	fbfd                	bnez	a5,244 <strchr+0xc>
      return (char*)s;
  return 0;
 250:	4501                	li	a0,0
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	add	sp,sp,16
 256:	8082                	ret
  return 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <strchr+0x1a>

000000000000025c <gets>:

char*
gets(char *buf, int max)
{
 25c:	711d                	add	sp,sp,-96
 25e:	ec86                	sd	ra,88(sp)
 260:	e8a2                	sd	s0,80(sp)
 262:	e4a6                	sd	s1,72(sp)
 264:	e0ca                	sd	s2,64(sp)
 266:	fc4e                	sd	s3,56(sp)
 268:	f852                	sd	s4,48(sp)
 26a:	f456                	sd	s5,40(sp)
 26c:	f05a                	sd	s6,32(sp)
 26e:	ec5e                	sd	s7,24(sp)
 270:	1080                	add	s0,sp,96
 272:	8baa                	mv	s7,a0
 274:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	892a                	mv	s2,a0
 278:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 27a:	4aa9                	li	s5,10
 27c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 27e:	89a6                	mv	s3,s1
 280:	2485                	addw	s1,s1,1
 282:	0344d863          	bge	s1,s4,2b2 <gets+0x56>
    cc = read(0, &c, 1);
 286:	4605                	li	a2,1
 288:	faf40593          	add	a1,s0,-81
 28c:	4501                	li	a0,0
 28e:	00000097          	auipc	ra,0x0
 292:	19a080e7          	jalr	410(ra) # 428 <read>
    if(cc < 1)
 296:	00a05e63          	blez	a0,2b2 <gets+0x56>
    buf[i++] = c;
 29a:	faf44783          	lbu	a5,-81(s0)
 29e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a2:	01578763          	beq	a5,s5,2b0 <gets+0x54>
 2a6:	0905                	add	s2,s2,1
 2a8:	fd679be3          	bne	a5,s6,27e <gets+0x22>
  for(i=0; i+1 < max; ){
 2ac:	89a6                	mv	s3,s1
 2ae:	a011                	j	2b2 <gets+0x56>
 2b0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b2:	99de                	add	s3,s3,s7
 2b4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b8:	855e                	mv	a0,s7
 2ba:	60e6                	ld	ra,88(sp)
 2bc:	6446                	ld	s0,80(sp)
 2be:	64a6                	ld	s1,72(sp)
 2c0:	6906                	ld	s2,64(sp)
 2c2:	79e2                	ld	s3,56(sp)
 2c4:	7a42                	ld	s4,48(sp)
 2c6:	7aa2                	ld	s5,40(sp)
 2c8:	7b02                	ld	s6,32(sp)
 2ca:	6be2                	ld	s7,24(sp)
 2cc:	6125                	add	sp,sp,96
 2ce:	8082                	ret

00000000000002d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d0:	1101                	add	sp,sp,-32
 2d2:	ec06                	sd	ra,24(sp)
 2d4:	e822                	sd	s0,16(sp)
 2d6:	e426                	sd	s1,8(sp)
 2d8:	e04a                	sd	s2,0(sp)
 2da:	1000                	add	s0,sp,32
 2dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2de:	4581                	li	a1,0
 2e0:	00000097          	auipc	ra,0x0
 2e4:	170080e7          	jalr	368(ra) # 450 <open>
  if(fd < 0)
 2e8:	02054563          	bltz	a0,312 <stat+0x42>
 2ec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ee:	85ca                	mv	a1,s2
 2f0:	00000097          	auipc	ra,0x0
 2f4:	178080e7          	jalr	376(ra) # 468 <fstat>
 2f8:	892a                	mv	s2,a0
  close(fd);
 2fa:	8526                	mv	a0,s1
 2fc:	00000097          	auipc	ra,0x0
 300:	13c080e7          	jalr	316(ra) # 438 <close>
  return r;
}
 304:	854a                	mv	a0,s2
 306:	60e2                	ld	ra,24(sp)
 308:	6442                	ld	s0,16(sp)
 30a:	64a2                	ld	s1,8(sp)
 30c:	6902                	ld	s2,0(sp)
 30e:	6105                	add	sp,sp,32
 310:	8082                	ret
    return -1;
 312:	597d                	li	s2,-1
 314:	bfc5                	j	304 <stat+0x34>

0000000000000316 <atoi>:

int
atoi(const char *s)
{
 316:	1141                	add	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31c:	00054683          	lbu	a3,0(a0)
 320:	fd06879b          	addw	a5,a3,-48
 324:	0ff7f793          	zext.b	a5,a5
 328:	4625                	li	a2,9
 32a:	02f66863          	bltu	a2,a5,35a <atoi+0x44>
 32e:	872a                	mv	a4,a0
  n = 0;
 330:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 332:	0705                	add	a4,a4,1
 334:	0025179b          	sllw	a5,a0,0x2
 338:	9fa9                	addw	a5,a5,a0
 33a:	0017979b          	sllw	a5,a5,0x1
 33e:	9fb5                	addw	a5,a5,a3
 340:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 344:	00074683          	lbu	a3,0(a4)
 348:	fd06879b          	addw	a5,a3,-48
 34c:	0ff7f793          	zext.b	a5,a5
 350:	fef671e3          	bgeu	a2,a5,332 <atoi+0x1c>
  return n;
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	add	sp,sp,16
 358:	8082                	ret
  n = 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <atoi+0x3e>

000000000000035e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35e:	1141                	add	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 364:	02b57463          	bgeu	a0,a1,38c <memmove+0x2e>
    while(n-- > 0)
 368:	00c05f63          	blez	a2,386 <memmove+0x28>
 36c:	1602                	sll	a2,a2,0x20
 36e:	9201                	srl	a2,a2,0x20
 370:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 374:	872a                	mv	a4,a0
      *dst++ = *src++;
 376:	0585                	add	a1,a1,1
 378:	0705                	add	a4,a4,1
 37a:	fff5c683          	lbu	a3,-1(a1)
 37e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 382:	fee79ae3          	bne	a5,a4,376 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	add	sp,sp,16
 38a:	8082                	ret
    dst += n;
 38c:	00c50733          	add	a4,a0,a2
    src += n;
 390:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 392:	fec05ae3          	blez	a2,386 <memmove+0x28>
 396:	fff6079b          	addw	a5,a2,-1
 39a:	1782                	sll	a5,a5,0x20
 39c:	9381                	srl	a5,a5,0x20
 39e:	fff7c793          	not	a5,a5
 3a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a4:	15fd                	add	a1,a1,-1
 3a6:	177d                	add	a4,a4,-1
 3a8:	0005c683          	lbu	a3,0(a1)
 3ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b0:	fee79ae3          	bne	a5,a4,3a4 <memmove+0x46>
 3b4:	bfc9                	j	386 <memmove+0x28>

00000000000003b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b6:	1141                	add	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3bc:	ca05                	beqz	a2,3ec <memcmp+0x36>
 3be:	fff6069b          	addw	a3,a2,-1
 3c2:	1682                	sll	a3,a3,0x20
 3c4:	9281                	srl	a3,a3,0x20
 3c6:	0685                	add	a3,a3,1
 3c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	0005c703          	lbu	a4,0(a1)
 3d2:	00e79863          	bne	a5,a4,3e2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d6:	0505                	add	a0,a0,1
    p2++;
 3d8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 3da:	fed518e3          	bne	a0,a3,3ca <memcmp+0x14>
  }
  return 0;
 3de:	4501                	li	a0,0
 3e0:	a019                	j	3e6 <memcmp+0x30>
      return *p1 - *p2;
 3e2:	40e7853b          	subw	a0,a5,a4
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	add	sp,sp,16
 3ea:	8082                	ret
  return 0;
 3ec:	4501                	li	a0,0
 3ee:	bfe5                	j	3e6 <memcmp+0x30>

00000000000003f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f0:	1141                	add	sp,sp,-16
 3f2:	e406                	sd	ra,8(sp)
 3f4:	e022                	sd	s0,0(sp)
 3f6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3f8:	00000097          	auipc	ra,0x0
 3fc:	f66080e7          	jalr	-154(ra) # 35e <memmove>
}
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	add	sp,sp,16
 406:	8082                	ret

0000000000000408 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 408:	4885                	li	a7,1
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <exit>:
.global exit
exit:
 li a7, SYS_exit
 410:	4889                	li	a7,2
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <wait>:
.global wait
wait:
 li a7, SYS_wait
 418:	488d                	li	a7,3
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 420:	4891                	li	a7,4
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <read>:
.global read
read:
 li a7, SYS_read
 428:	4895                	li	a7,5
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <write>:
.global write
write:
 li a7, SYS_write
 430:	48c1                	li	a7,16
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <close>:
.global close
close:
 li a7, SYS_close
 438:	48d5                	li	a7,21
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <kill>:
.global kill
kill:
 li a7, SYS_kill
 440:	4899                	li	a7,6
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <exec>:
.global exec
exec:
 li a7, SYS_exec
 448:	489d                	li	a7,7
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <open>:
.global open
open:
 li a7, SYS_open
 450:	48bd                	li	a7,15
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 458:	48c5                	li	a7,17
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 460:	48c9                	li	a7,18
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 468:	48a1                	li	a7,8
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <link>:
.global link
link:
 li a7, SYS_link
 470:	48cd                	li	a7,19
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 478:	48d1                	li	a7,20
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 480:	48a5                	li	a7,9
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <dup>:
.global dup
dup:
 li a7, SYS_dup
 488:	48a9                	li	a7,10
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 490:	48ad                	li	a7,11
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 498:	48b1                	li	a7,12
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a0:	48b5                	li	a7,13
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a8:	48b9                	li	a7,14
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b0:	1101                	add	sp,sp,-32
 4b2:	ec06                	sd	ra,24(sp)
 4b4:	e822                	sd	s0,16(sp)
 4b6:	1000                	add	s0,sp,32
 4b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4bc:	4605                	li	a2,1
 4be:	fef40593          	add	a1,s0,-17
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f6e080e7          	jalr	-146(ra) # 430 <write>
}
 4ca:	60e2                	ld	ra,24(sp)
 4cc:	6442                	ld	s0,16(sp)
 4ce:	6105                	add	sp,sp,32
 4d0:	8082                	ret

00000000000004d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d2:	7139                	add	sp,sp,-64
 4d4:	fc06                	sd	ra,56(sp)
 4d6:	f822                	sd	s0,48(sp)
 4d8:	f426                	sd	s1,40(sp)
 4da:	f04a                	sd	s2,32(sp)
 4dc:	ec4e                	sd	s3,24(sp)
 4de:	0080                	add	s0,sp,64
 4e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e2:	c299                	beqz	a3,4e8 <printint+0x16>
 4e4:	0805c963          	bltz	a1,576 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e8:	2581                	sext.w	a1,a1
  neg = 0;
 4ea:	4881                	li	a7,0
 4ec:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f2:	2601                	sext.w	a2,a2
 4f4:	00000517          	auipc	a0,0x0
 4f8:	57c50513          	add	a0,a0,1404 # a70 <digits>
 4fc:	883a                	mv	a6,a4
 4fe:	2705                	addw	a4,a4,1
 500:	02c5f7bb          	remuw	a5,a1,a2
 504:	1782                	sll	a5,a5,0x20
 506:	9381                	srl	a5,a5,0x20
 508:	97aa                	add	a5,a5,a0
 50a:	0007c783          	lbu	a5,0(a5)
 50e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 512:	0005879b          	sext.w	a5,a1
 516:	02c5d5bb          	divuw	a1,a1,a2
 51a:	0685                	add	a3,a3,1
 51c:	fec7f0e3          	bgeu	a5,a2,4fc <printint+0x2a>
  if(neg)
 520:	00088c63          	beqz	a7,538 <printint+0x66>
    buf[i++] = '-';
 524:	fd070793          	add	a5,a4,-48
 528:	00878733          	add	a4,a5,s0
 52c:	02d00793          	li	a5,45
 530:	fef70823          	sb	a5,-16(a4)
 534:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 538:	02e05863          	blez	a4,568 <printint+0x96>
 53c:	fc040793          	add	a5,s0,-64
 540:	00e78933          	add	s2,a5,a4
 544:	fff78993          	add	s3,a5,-1
 548:	99ba                	add	s3,s3,a4
 54a:	377d                	addw	a4,a4,-1
 54c:	1702                	sll	a4,a4,0x20
 54e:	9301                	srl	a4,a4,0x20
 550:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 554:	fff94583          	lbu	a1,-1(s2)
 558:	8526                	mv	a0,s1
 55a:	00000097          	auipc	ra,0x0
 55e:	f56080e7          	jalr	-170(ra) # 4b0 <putc>
  while(--i >= 0)
 562:	197d                	add	s2,s2,-1
 564:	ff3918e3          	bne	s2,s3,554 <printint+0x82>
}
 568:	70e2                	ld	ra,56(sp)
 56a:	7442                	ld	s0,48(sp)
 56c:	74a2                	ld	s1,40(sp)
 56e:	7902                	ld	s2,32(sp)
 570:	69e2                	ld	s3,24(sp)
 572:	6121                	add	sp,sp,64
 574:	8082                	ret
    x = -xx;
 576:	40b005bb          	negw	a1,a1
    neg = 1;
 57a:	4885                	li	a7,1
    x = -xx;
 57c:	bf85                	j	4ec <printint+0x1a>

000000000000057e <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57e:	711d                	add	sp,sp,-96
 580:	ec86                	sd	ra,88(sp)
 582:	e8a2                	sd	s0,80(sp)
 584:	e4a6                	sd	s1,72(sp)
 586:	e0ca                	sd	s2,64(sp)
 588:	fc4e                	sd	s3,56(sp)
 58a:	f852                	sd	s4,48(sp)
 58c:	f456                	sd	s5,40(sp)
 58e:	f05a                	sd	s6,32(sp)
 590:	ec5e                	sd	s7,24(sp)
 592:	e862                	sd	s8,16(sp)
 594:	e466                	sd	s9,8(sp)
 596:	e06a                	sd	s10,0(sp)
 598:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 59a:	0005c903          	lbu	s2,0(a1)
 59e:	28090963          	beqz	s2,830 <vprintf+0x2b2>
 5a2:	8b2a                	mv	s6,a0
 5a4:	8a2e                	mv	s4,a1
 5a6:	8bb2                	mv	s7,a2
  state = 0;
 5a8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5aa:	4481                	li	s1,0
 5ac:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b6:	06c00c93          	li	s9,108
 5ba:	a015                	j	5de <vprintf+0x60>
        putc(fd, c0);
 5bc:	85ca                	mv	a1,s2
 5be:	855a                	mv	a0,s6
 5c0:	00000097          	auipc	ra,0x0
 5c4:	ef0080e7          	jalr	-272(ra) # 4b0 <putc>
 5c8:	a019                	j	5ce <vprintf+0x50>
    } else if(state == '%'){
 5ca:	03598263          	beq	s3,s5,5ee <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 5ce:	2485                	addw	s1,s1,1
 5d0:	8726                	mv	a4,s1
 5d2:	009a07b3          	add	a5,s4,s1
 5d6:	0007c903          	lbu	s2,0(a5)
 5da:	24090b63          	beqz	s2,830 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 5de:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5e2:	fe0994e3          	bnez	s3,5ca <vprintf+0x4c>
      if(c0 == '%'){
 5e6:	fd579be3          	bne	a5,s5,5bc <vprintf+0x3e>
        state = '%';
 5ea:	89be                	mv	s3,a5
 5ec:	b7cd                	j	5ce <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 5ee:	cbc9                	beqz	a5,680 <vprintf+0x102>
 5f0:	00ea06b3          	add	a3,s4,a4
 5f4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5f8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5fa:	c681                	beqz	a3,602 <vprintf+0x84>
 5fc:	9752                	add	a4,a4,s4
 5fe:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 602:	05878163          	beq	a5,s8,644 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 606:	05978d63          	beq	a5,s9,660 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 60a:	07500713          	li	a4,117
 60e:	10e78163          	beq	a5,a4,710 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 612:	07800713          	li	a4,120
 616:	14e78963          	beq	a5,a4,768 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 61a:	07000713          	li	a4,112
 61e:	18e78263          	beq	a5,a4,7a2 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 622:	07300713          	li	a4,115
 626:	1ce78663          	beq	a5,a4,7f2 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 62a:	02500713          	li	a4,37
 62e:	04e79963          	bne	a5,a4,680 <vprintf+0x102>
        putc(fd, '%');
 632:	02500593          	li	a1,37
 636:	855a                	mv	a0,s6
 638:	00000097          	auipc	ra,0x0
 63c:	e78080e7          	jalr	-392(ra) # 4b0 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 640:	4981                	li	s3,0
 642:	b771                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 644:	008b8913          	add	s2,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	00000097          	auipc	ra,0x0
 656:	e80080e7          	jalr	-384(ra) # 4d2 <printint>
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bf85                	j	5ce <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 660:	06400793          	li	a5,100
 664:	02f68d63          	beq	a3,a5,69e <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 668:	06c00793          	li	a5,108
 66c:	04f68863          	beq	a3,a5,6bc <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 670:	07500793          	li	a5,117
 674:	0af68c63          	beq	a3,a5,72c <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 678:	07800793          	li	a5,120
 67c:	10f68463          	beq	a3,a5,784 <vprintf+0x206>
        putc(fd, '%');
 680:	02500593          	li	a1,37
 684:	855a                	mv	a0,s6
 686:	00000097          	auipc	ra,0x0
 68a:	e2a080e7          	jalr	-470(ra) # 4b0 <putc>
        putc(fd, c0);
 68e:	85ca                	mv	a1,s2
 690:	855a                	mv	a0,s6
 692:	00000097          	auipc	ra,0x0
 696:	e1e080e7          	jalr	-482(ra) # 4b0 <putc>
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bf0d                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69e:	008b8913          	add	s2,s7,8
 6a2:	4685                	li	a3,1
 6a4:	4629                	li	a2,10
 6a6:	000ba583          	lw	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e26080e7          	jalr	-474(ra) # 4d2 <printint>
        i += 1;
 6b4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
        i += 1;
 6ba:	bf11                	j	5ce <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6bc:	06400793          	li	a5,100
 6c0:	02f60963          	beq	a2,a5,6f2 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6c4:	07500793          	li	a5,117
 6c8:	08f60163          	beq	a2,a5,74a <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6cc:	07800793          	li	a5,120
 6d0:	faf618e3          	bne	a2,a5,680 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	008b8913          	add	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	00000097          	auipc	ra,0x0
 6e6:	df0080e7          	jalr	-528(ra) # 4d2 <printint>
        i += 2;
 6ea:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	bdf9                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	008b8913          	add	s2,s7,8
 6f6:	4685                	li	a3,1
 6f8:	4629                	li	a2,10
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	00000097          	auipc	ra,0x0
 704:	dd2080e7          	jalr	-558(ra) # 4d2 <printint>
        i += 2;
 708:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
        i += 2;
 70e:	b5c1                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 710:	008b8913          	add	s2,s7,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000ba583          	lw	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	00000097          	auipc	ra,0x0
 722:	db4080e7          	jalr	-588(ra) # 4d2 <printint>
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
 72a:	b555                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	008b8913          	add	s2,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	00000097          	auipc	ra,0x0
 73e:	d98080e7          	jalr	-616(ra) # 4d2 <printint>
        i += 1;
 742:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
        i += 1;
 748:	b559                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	008b8913          	add	s2,s7,8
 74e:	4681                	li	a3,0
 750:	4629                	li	a2,10
 752:	000ba583          	lw	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	00000097          	auipc	ra,0x0
 75c:	d7a080e7          	jalr	-646(ra) # 4d2 <printint>
        i += 2;
 760:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
        i += 2;
 766:	b5a5                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 768:	008b8913          	add	s2,s7,8
 76c:	4681                	li	a3,0
 76e:	4641                	li	a2,16
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	00000097          	auipc	ra,0x0
 77a:	d5c080e7          	jalr	-676(ra) # 4d2 <printint>
 77e:	8bca                	mv	s7,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	b5b1                	j	5ce <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 784:	008b8913          	add	s2,s7,8
 788:	4681                	li	a3,0
 78a:	4641                	li	a2,16
 78c:	000ba583          	lw	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	00000097          	auipc	ra,0x0
 796:	d40080e7          	jalr	-704(ra) # 4d2 <printint>
        i += 1;
 79a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
        i += 1;
 7a0:	b53d                	j	5ce <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 7a2:	008b8d13          	add	s10,s7,8
 7a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7aa:	03000593          	li	a1,48
 7ae:	855a                	mv	a0,s6
 7b0:	00000097          	auipc	ra,0x0
 7b4:	d00080e7          	jalr	-768(ra) # 4b0 <putc>
  putc(fd, 'x');
 7b8:	07800593          	li	a1,120
 7bc:	855a                	mv	a0,s6
 7be:	00000097          	auipc	ra,0x0
 7c2:	cf2080e7          	jalr	-782(ra) # 4b0 <putc>
 7c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c8:	00000b97          	auipc	s7,0x0
 7cc:	2a8b8b93          	add	s7,s7,680 # a70 <digits>
 7d0:	03c9d793          	srl	a5,s3,0x3c
 7d4:	97de                	add	a5,a5,s7
 7d6:	0007c583          	lbu	a1,0(a5)
 7da:	855a                	mv	a0,s6
 7dc:	00000097          	auipc	ra,0x0
 7e0:	cd4080e7          	jalr	-812(ra) # 4b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e4:	0992                	sll	s3,s3,0x4
 7e6:	397d                	addw	s2,s2,-1
 7e8:	fe0914e3          	bnez	s2,7d0 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 7ec:	8bea                	mv	s7,s10
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bbf9                	j	5ce <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 7f2:	008b8993          	add	s3,s7,8
 7f6:	000bb903          	ld	s2,0(s7)
 7fa:	02090163          	beqz	s2,81c <vprintf+0x29e>
        for(; *s; s++)
 7fe:	00094583          	lbu	a1,0(s2)
 802:	c585                	beqz	a1,82a <vprintf+0x2ac>
          putc(fd, *s);
 804:	855a                	mv	a0,s6
 806:	00000097          	auipc	ra,0x0
 80a:	caa080e7          	jalr	-854(ra) # 4b0 <putc>
        for(; *s; s++)
 80e:	0905                	add	s2,s2,1
 810:	00094583          	lbu	a1,0(s2)
 814:	f9e5                	bnez	a1,804 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 816:	8bce                	mv	s7,s3
      state = 0;
 818:	4981                	li	s3,0
 81a:	bb55                	j	5ce <vprintf+0x50>
          s = "(null)";
 81c:	00000917          	auipc	s2,0x0
 820:	24c90913          	add	s2,s2,588 # a68 <malloc+0x136>
        for(; *s; s++)
 824:	02800593          	li	a1,40
 828:	bff1                	j	804 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 82a:	8bce                	mv	s7,s3
      state = 0;
 82c:	4981                	li	s3,0
 82e:	b345                	j	5ce <vprintf+0x50>
    }
  }
}
 830:	60e6                	ld	ra,88(sp)
 832:	6446                	ld	s0,80(sp)
 834:	64a6                	ld	s1,72(sp)
 836:	6906                	ld	s2,64(sp)
 838:	79e2                	ld	s3,56(sp)
 83a:	7a42                	ld	s4,48(sp)
 83c:	7aa2                	ld	s5,40(sp)
 83e:	7b02                	ld	s6,32(sp)
 840:	6be2                	ld	s7,24(sp)
 842:	6c42                	ld	s8,16(sp)
 844:	6ca2                	ld	s9,8(sp)
 846:	6d02                	ld	s10,0(sp)
 848:	6125                	add	sp,sp,96
 84a:	8082                	ret

000000000000084c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84c:	715d                	add	sp,sp,-80
 84e:	ec06                	sd	ra,24(sp)
 850:	e822                	sd	s0,16(sp)
 852:	1000                	add	s0,sp,32
 854:	e010                	sd	a2,0(s0)
 856:	e414                	sd	a3,8(s0)
 858:	e818                	sd	a4,16(s0)
 85a:	ec1c                	sd	a5,24(s0)
 85c:	03043023          	sd	a6,32(s0)
 860:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 864:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 868:	8622                	mv	a2,s0
 86a:	00000097          	auipc	ra,0x0
 86e:	d14080e7          	jalr	-748(ra) # 57e <vprintf>
}
 872:	60e2                	ld	ra,24(sp)
 874:	6442                	ld	s0,16(sp)
 876:	6161                	add	sp,sp,80
 878:	8082                	ret

000000000000087a <printf>:

void
printf(const char *fmt, ...)
{
 87a:	711d                	add	sp,sp,-96
 87c:	ec06                	sd	ra,24(sp)
 87e:	e822                	sd	s0,16(sp)
 880:	1000                	add	s0,sp,32
 882:	e40c                	sd	a1,8(s0)
 884:	e810                	sd	a2,16(s0)
 886:	ec14                	sd	a3,24(s0)
 888:	f018                	sd	a4,32(s0)
 88a:	f41c                	sd	a5,40(s0)
 88c:	03043823          	sd	a6,48(s0)
 890:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 894:	00840613          	add	a2,s0,8
 898:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 89c:	85aa                	mv	a1,a0
 89e:	4505                	li	a0,1
 8a0:	00000097          	auipc	ra,0x0
 8a4:	cde080e7          	jalr	-802(ra) # 57e <vprintf>
}
 8a8:	60e2                	ld	ra,24(sp)
 8aa:	6442                	ld	s0,16(sp)
 8ac:	6125                	add	sp,sp,96
 8ae:	8082                	ret

00000000000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	1141                	add	sp,sp,-16
 8b2:	e422                	sd	s0,8(sp)
 8b4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	00000797          	auipc	a5,0x0
 8be:	7467b783          	ld	a5,1862(a5) # 1000 <freep>
 8c2:	a02d                	j	8ec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c4:	4618                	lw	a4,8(a2)
 8c6:	9f2d                	addw	a4,a4,a1
 8c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	6310                	ld	a2,0(a4)
 8d0:	a83d                	j	90e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d2:	ff852703          	lw	a4,-8(a0)
 8d6:	9f31                	addw	a4,a4,a2
 8d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8da:	ff053683          	ld	a3,-16(a0)
 8de:	a091                	j	922 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	6398                	ld	a4,0(a5)
 8e2:	00e7e463          	bltu	a5,a4,8ea <free+0x3a>
 8e6:	00e6ea63          	bltu	a3,a4,8fa <free+0x4a>
{
 8ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ec:	fed7fae3          	bgeu	a5,a3,8e0 <free+0x30>
 8f0:	6398                	ld	a4,0(a5)
 8f2:	00e6e463          	bltu	a3,a4,8fa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f6:	fee7eae3          	bltu	a5,a4,8ea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8fa:	ff852583          	lw	a1,-8(a0)
 8fe:	6390                	ld	a2,0(a5)
 900:	02059813          	sll	a6,a1,0x20
 904:	01c85713          	srl	a4,a6,0x1c
 908:	9736                	add	a4,a4,a3
 90a:	fae60de3          	beq	a2,a4,8c4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 90e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 912:	4790                	lw	a2,8(a5)
 914:	02061593          	sll	a1,a2,0x20
 918:	01c5d713          	srl	a4,a1,0x1c
 91c:	973e                	add	a4,a4,a5
 91e:	fae68ae3          	beq	a3,a4,8d2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 922:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 924:	00000717          	auipc	a4,0x0
 928:	6cf73e23          	sd	a5,1756(a4) # 1000 <freep>
}
 92c:	6422                	ld	s0,8(sp)
 92e:	0141                	add	sp,sp,16
 930:	8082                	ret

0000000000000932 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 932:	7139                	add	sp,sp,-64
 934:	fc06                	sd	ra,56(sp)
 936:	f822                	sd	s0,48(sp)
 938:	f426                	sd	s1,40(sp)
 93a:	f04a                	sd	s2,32(sp)
 93c:	ec4e                	sd	s3,24(sp)
 93e:	e852                	sd	s4,16(sp)
 940:	e456                	sd	s5,8(sp)
 942:	e05a                	sd	s6,0(sp)
 944:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 946:	02051493          	sll	s1,a0,0x20
 94a:	9081                	srl	s1,s1,0x20
 94c:	04bd                	add	s1,s1,15
 94e:	8091                	srl	s1,s1,0x4
 950:	0014899b          	addw	s3,s1,1
 954:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 956:	00000517          	auipc	a0,0x0
 95a:	6aa53503          	ld	a0,1706(a0) # 1000 <freep>
 95e:	c515                	beqz	a0,98a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 962:	4798                	lw	a4,8(a5)
 964:	02977f63          	bgeu	a4,s1,9a2 <malloc+0x70>
  if(nu < 4096)
 968:	8a4e                	mv	s4,s3
 96a:	0009871b          	sext.w	a4,s3
 96e:	6685                	lui	a3,0x1
 970:	00d77363          	bgeu	a4,a3,976 <malloc+0x44>
 974:	6a05                	lui	s4,0x1
 976:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 97e:	00000917          	auipc	s2,0x0
 982:	68290913          	add	s2,s2,1666 # 1000 <freep>
  if(p == (char*)-1)
 986:	5afd                	li	s5,-1
 988:	a895                	j	9fc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 98a:	00001797          	auipc	a5,0x1
 98e:	88678793          	add	a5,a5,-1914 # 1210 <base>
 992:	00000717          	auipc	a4,0x0
 996:	66f73723          	sd	a5,1646(a4) # 1000 <freep>
 99a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a0:	b7e1                	j	968 <malloc+0x36>
      if(p->s.size == nunits)
 9a2:	02e48c63          	beq	s1,a4,9da <malloc+0xa8>
        p->s.size -= nunits;
 9a6:	4137073b          	subw	a4,a4,s3
 9aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ac:	02071693          	sll	a3,a4,0x20
 9b0:	01c6d713          	srl	a4,a3,0x1c
 9b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ba:	00000717          	auipc	a4,0x0
 9be:	64a73323          	sd	a0,1606(a4) # 1000 <freep>
      return (void*)(p + 1);
 9c2:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9c6:	70e2                	ld	ra,56(sp)
 9c8:	7442                	ld	s0,48(sp)
 9ca:	74a2                	ld	s1,40(sp)
 9cc:	7902                	ld	s2,32(sp)
 9ce:	69e2                	ld	s3,24(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
 9d6:	6121                	add	sp,sp,64
 9d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9da:	6398                	ld	a4,0(a5)
 9dc:	e118                	sd	a4,0(a0)
 9de:	bff1                	j	9ba <malloc+0x88>
  hp->s.size = nu;
 9e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e4:	0541                	add	a0,a0,16
 9e6:	00000097          	auipc	ra,0x0
 9ea:	eca080e7          	jalr	-310(ra) # 8b0 <free>
  return freep;
 9ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f2:	d971                	beqz	a0,9c6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f6:	4798                	lw	a4,8(a5)
 9f8:	fa9775e3          	bgeu	a4,s1,9a2 <malloc+0x70>
    if(p == freep)
 9fc:	00093703          	ld	a4,0(s2)
 a00:	853e                	mv	a0,a5
 a02:	fef719e3          	bne	a4,a5,9f4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a06:	8552                	mv	a0,s4
 a08:	00000097          	auipc	ra,0x0
 a0c:	a90080e7          	jalr	-1392(ra) # 498 <sbrk>
  if(p == (char*)-1)
 a10:	fd5518e3          	bne	a0,s5,9e0 <malloc+0xae>
        return 0;
 a14:	4501                	li	a0,0
 a16:	bf45                	j	9c6 <malloc+0x94>
