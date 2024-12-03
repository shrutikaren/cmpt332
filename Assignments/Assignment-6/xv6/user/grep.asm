
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

/* matchstar: search for c*re at beginning of text */
int matchstar(int c, char *re, char *text)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	add	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  /* a * matches zero or more instances */
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	add	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	add	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	add	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	add	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	add	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	add	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	add	a1,a1,1
  b2:	00178513          	add	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	add	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	add	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	add	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	add	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	add	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	715d                	add	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	e062                	sd	s8,0(sp)
 11c:	0880                	add	s0,sp,80
 11e:	89aa                	mv	s3,a0
 120:	8b2e                	mv	s6,a1
  m = 0;
 122:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 124:	3ff00b93          	li	s7,1023
 128:	00001a97          	auipc	s5,0x1
 12c:	ee8a8a93          	add	s5,s5,-280 # 1010 <buf>
 130:	a835                	j	16c <grep+0x66>
      p = q+1;
 132:	00148913          	add	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 136:	45a9                	li	a1,10
 138:	854a                	mv	a0,s2
 13a:	1c6000ef          	jal	300 <strchr>
 13e:	84aa                	mv	s1,a0
 140:	c505                	beqz	a0,168 <grep+0x62>
      *q = 0;
 142:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 146:	85ca                	mv	a1,s2
 148:	854e                	mv	a0,s3
 14a:	f77ff0ef          	jal	c0 <match>
 14e:	d175                	beqz	a0,132 <grep+0x2c>
        *q = '\n';
 150:	47a9                	li	a5,10
 152:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 156:	00148613          	add	a2,s1,1
 15a:	4126063b          	subw	a2,a2,s2
 15e:	85ca                	mv	a1,s2
 160:	4505                	li	a0,1
 162:	382000ef          	jal	4e4 <write>
 166:	b7f1                	j	132 <grep+0x2c>
    if(m > 0){
 168:	03404563          	bgtz	s4,192 <grep+0x8c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 16c:	414b863b          	subw	a2,s7,s4
 170:	014a85b3          	add	a1,s5,s4
 174:	855a                	mv	a0,s6
 176:	366000ef          	jal	4dc <read>
 17a:	02a05963          	blez	a0,1ac <grep+0xa6>
    m += n;
 17e:	00aa0c3b          	addw	s8,s4,a0
 182:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 186:	014a87b3          	add	a5,s5,s4
 18a:	00078023          	sb	zero,0(a5)
    p = buf;
 18e:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 190:	b75d                	j	136 <grep+0x30>
      m -= p - buf;
 192:	00001517          	auipc	a0,0x1
 196:	e7e50513          	add	a0,a0,-386 # 1010 <buf>
 19a:	40a90a33          	sub	s4,s2,a0
 19e:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1a2:	8652                	mv	a2,s4
 1a4:	85ca                	mv	a1,s2
 1a6:	270000ef          	jal	416 <memmove>
 1aa:	b7c9                	j	16c <grep+0x66>
}
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	add	sp,sp,80
 1c2:	8082                	ret

00000000000001c4 <main>:
{
 1c4:	7179                	add	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	ec26                	sd	s1,24(sp)
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
 1d0:	e052                	sd	s4,0(sp)
 1d2:	1800                	add	s0,sp,48
  if(argc <= 1){
 1d4:	4785                	li	a5,1
 1d6:	04a7d663          	bge	a5,a0,222 <main+0x5e>
  pattern = argv[1];
 1da:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1de:	4789                	li	a5,2
 1e0:	04a7db63          	bge	a5,a0,236 <main+0x72>
 1e4:	01058913          	add	s2,a1,16
 1e8:	ffd5099b          	addw	s3,a0,-3
 1ec:	02099793          	sll	a5,s3,0x20
 1f0:	01d7d993          	srl	s3,a5,0x1d
 1f4:	05e1                	add	a1,a1,24
 1f6:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1f8:	4581                	li	a1,0
 1fa:	00093503          	ld	a0,0(s2)
 1fe:	306000ef          	jal	504 <open>
 202:	84aa                	mv	s1,a0
 204:	04054063          	bltz	a0,244 <main+0x80>
    grep(pattern, fd);
 208:	85aa                	mv	a1,a0
 20a:	8552                	mv	a0,s4
 20c:	efbff0ef          	jal	106 <grep>
    close(fd);
 210:	8526                	mv	a0,s1
 212:	2da000ef          	jal	4ec <close>
  for(i = 2; i < argc; i++){
 216:	0921                	add	s2,s2,8
 218:	ff3910e3          	bne	s2,s3,1f8 <main+0x34>
  exit(0);
 21c:	4501                	li	a0,0
 21e:	2a6000ef          	jal	4c4 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 222:	00001597          	auipc	a1,0x1
 226:	84e58593          	add	a1,a1,-1970 # a70 <malloc+0xde>
 22a:	4509                	li	a0,2
 22c:	688000ef          	jal	8b4 <fprintf>
    exit(1);
 230:	4505                	li	a0,1
 232:	292000ef          	jal	4c4 <exit>
    grep(pattern, 0);
 236:	4581                	li	a1,0
 238:	8552                	mv	a0,s4
 23a:	ecdff0ef          	jal	106 <grep>
    exit(0);
 23e:	4501                	li	a0,0
 240:	284000ef          	jal	4c4 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 244:	00093583          	ld	a1,0(s2)
 248:	00001517          	auipc	a0,0x1
 24c:	84850513          	add	a0,a0,-1976 # a90 <malloc+0xfe>
 250:	68e000ef          	jal	8de <printf>
      exit(1);
 254:	4505                	li	a0,1
 256:	26e000ef          	jal	4c4 <exit>

000000000000025a <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 25a:	1141                	add	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	add	s0,sp,16
  extern int main();
  main();
 262:	f63ff0ef          	jal	1c4 <main>
  exit(0);
 266:	4501                	li	a0,0
 268:	25c000ef          	jal	4c4 <exit>

000000000000026c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26c:	1141                	add	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 272:	87aa                	mv	a5,a0
 274:	0585                	add	a1,a1,1
 276:	0785                	add	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0x8>
    ;
  return os;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	add	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	add	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb91                	beqz	a5,2a6 <strcmp+0x1e>
 294:	0005c703          	lbu	a4,0(a1)
 298:	00f71763          	bne	a4,a5,2a6 <strcmp+0x1e>
    p++, q++;
 29c:	0505                	add	a0,a0,1
 29e:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbe5                	bnez	a5,294 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a6:	0005c503          	lbu	a0,0(a1)
}
 2aa:	40a7853b          	subw	a0,a5,a0
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	add	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strlen>:

uint
strlen(const char *s)
{
 2b4:	1141                	add	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	cf91                	beqz	a5,2da <strlen+0x26>
 2c0:	0505                	add	a0,a0,1
 2c2:	87aa                	mv	a5,a0
 2c4:	86be                	mv	a3,a5
 2c6:	0785                	add	a5,a5,1
 2c8:	fff7c703          	lbu	a4,-1(a5)
 2cc:	ff65                	bnez	a4,2c4 <strlen+0x10>
 2ce:	40a6853b          	subw	a0,a3,a0
 2d2:	2505                	addw	a0,a0,1
    ;
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	add	sp,sp,16
 2d8:	8082                	ret
  for(n = 0; s[n]; n++)
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strlen+0x20>

00000000000002de <memset>:

void*
memset(void *dst, int c, uint n)
{
 2de:	1141                	add	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e4:	ca19                	beqz	a2,2fa <memset+0x1c>
 2e6:	87aa                	mv	a5,a0
 2e8:	1602                	sll	a2,a2,0x20
 2ea:	9201                	srl	a2,a2,0x20
 2ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f4:	0785                	add	a5,a5,1
 2f6:	fee79de3          	bne	a5,a4,2f0 <memset+0x12>
  }
  return dst;
}
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	add	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	1141                	add	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	add	s0,sp,16
  for(; *s; s++)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cb99                	beqz	a5,320 <strchr+0x20>
    if(*s == c)
 30c:	00f58763          	beq	a1,a5,31a <strchr+0x1a>
  for(; *s; s++)
 310:	0505                	add	a0,a0,1
 312:	00054783          	lbu	a5,0(a0)
 316:	fbfd                	bnez	a5,30c <strchr+0xc>
      return (char*)s;
  return 0;
 318:	4501                	li	a0,0
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	add	sp,sp,16
 31e:	8082                	ret
  return 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <strchr+0x1a>

0000000000000324 <gets>:

char*
gets(char *buf, int max)
{
 324:	711d                	add	sp,sp,-96
 326:	ec86                	sd	ra,88(sp)
 328:	e8a2                	sd	s0,80(sp)
 32a:	e4a6                	sd	s1,72(sp)
 32c:	e0ca                	sd	s2,64(sp)
 32e:	fc4e                	sd	s3,56(sp)
 330:	f852                	sd	s4,48(sp)
 332:	f456                	sd	s5,40(sp)
 334:	f05a                	sd	s6,32(sp)
 336:	ec5e                	sd	s7,24(sp)
 338:	1080                	add	s0,sp,96
 33a:	8baa                	mv	s7,a0
 33c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33e:	892a                	mv	s2,a0
 340:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 342:	4aa9                	li	s5,10
 344:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 346:	89a6                	mv	s3,s1
 348:	2485                	addw	s1,s1,1
 34a:	0344d663          	bge	s1,s4,376 <gets+0x52>
    cc = read(0, &c, 1);
 34e:	4605                	li	a2,1
 350:	faf40593          	add	a1,s0,-81
 354:	4501                	li	a0,0
 356:	186000ef          	jal	4dc <read>
    if(cc < 1)
 35a:	00a05e63          	blez	a0,376 <gets+0x52>
    buf[i++] = c;
 35e:	faf44783          	lbu	a5,-81(s0)
 362:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 366:	01578763          	beq	a5,s5,374 <gets+0x50>
 36a:	0905                	add	s2,s2,1
 36c:	fd679de3          	bne	a5,s6,346 <gets+0x22>
  for(i=0; i+1 < max; ){
 370:	89a6                	mv	s3,s1
 372:	a011                	j	376 <gets+0x52>
 374:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 376:	99de                	add	s3,s3,s7
 378:	00098023          	sb	zero,0(s3)
  return buf;
}
 37c:	855e                	mv	a0,s7
 37e:	60e6                	ld	ra,88(sp)
 380:	6446                	ld	s0,80(sp)
 382:	64a6                	ld	s1,72(sp)
 384:	6906                	ld	s2,64(sp)
 386:	79e2                	ld	s3,56(sp)
 388:	7a42                	ld	s4,48(sp)
 38a:	7aa2                	ld	s5,40(sp)
 38c:	7b02                	ld	s6,32(sp)
 38e:	6be2                	ld	s7,24(sp)
 390:	6125                	add	sp,sp,96
 392:	8082                	ret

0000000000000394 <stat>:

int
stat(const char *n, struct stat *st)
{
 394:	1101                	add	sp,sp,-32
 396:	ec06                	sd	ra,24(sp)
 398:	e822                	sd	s0,16(sp)
 39a:	e426                	sd	s1,8(sp)
 39c:	e04a                	sd	s2,0(sp)
 39e:	1000                	add	s0,sp,32
 3a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a2:	4581                	li	a1,0
 3a4:	160000ef          	jal	504 <open>
  if(fd < 0)
 3a8:	02054163          	bltz	a0,3ca <stat+0x36>
 3ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ae:	85ca                	mv	a1,s2
 3b0:	16c000ef          	jal	51c <fstat>
 3b4:	892a                	mv	s2,a0
  close(fd);
 3b6:	8526                	mv	a0,s1
 3b8:	134000ef          	jal	4ec <close>
  return r;
}
 3bc:	854a                	mv	a0,s2
 3be:	60e2                	ld	ra,24(sp)
 3c0:	6442                	ld	s0,16(sp)
 3c2:	64a2                	ld	s1,8(sp)
 3c4:	6902                	ld	s2,0(sp)
 3c6:	6105                	add	sp,sp,32
 3c8:	8082                	ret
    return -1;
 3ca:	597d                	li	s2,-1
 3cc:	bfc5                	j	3bc <stat+0x28>

00000000000003ce <atoi>:

int
atoi(const char *s)
{
 3ce:	1141                	add	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d4:	00054683          	lbu	a3,0(a0)
 3d8:	fd06879b          	addw	a5,a3,-48
 3dc:	0ff7f793          	zext.b	a5,a5
 3e0:	4625                	li	a2,9
 3e2:	02f66863          	bltu	a2,a5,412 <atoi+0x44>
 3e6:	872a                	mv	a4,a0
  n = 0;
 3e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ea:	0705                	add	a4,a4,1
 3ec:	0025179b          	sllw	a5,a0,0x2
 3f0:	9fa9                	addw	a5,a5,a0
 3f2:	0017979b          	sllw	a5,a5,0x1
 3f6:	9fb5                	addw	a5,a5,a3
 3f8:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fc:	00074683          	lbu	a3,0(a4)
 400:	fd06879b          	addw	a5,a3,-48
 404:	0ff7f793          	zext.b	a5,a5
 408:	fef671e3          	bgeu	a2,a5,3ea <atoi+0x1c>
  return n;
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	add	sp,sp,16
 410:	8082                	ret
  n = 0;
 412:	4501                	li	a0,0
 414:	bfe5                	j	40c <atoi+0x3e>

0000000000000416 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 416:	1141                	add	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41c:	02b57463          	bgeu	a0,a1,444 <memmove+0x2e>
    while(n-- > 0)
 420:	00c05f63          	blez	a2,43e <memmove+0x28>
 424:	1602                	sll	a2,a2,0x20
 426:	9201                	srl	a2,a2,0x20
 428:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 42c:	872a                	mv	a4,a0
      *dst++ = *src++;
 42e:	0585                	add	a1,a1,1
 430:	0705                	add	a4,a4,1
 432:	fff5c683          	lbu	a3,-1(a1)
 436:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 43a:	fee79ae3          	bne	a5,a4,42e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 43e:	6422                	ld	s0,8(sp)
 440:	0141                	add	sp,sp,16
 442:	8082                	ret
    dst += n;
 444:	00c50733          	add	a4,a0,a2
    src += n;
 448:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 44a:	fec05ae3          	blez	a2,43e <memmove+0x28>
 44e:	fff6079b          	addw	a5,a2,-1
 452:	1782                	sll	a5,a5,0x20
 454:	9381                	srl	a5,a5,0x20
 456:	fff7c793          	not	a5,a5
 45a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 45c:	15fd                	add	a1,a1,-1
 45e:	177d                	add	a4,a4,-1
 460:	0005c683          	lbu	a3,0(a1)
 464:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 468:	fee79ae3          	bne	a5,a4,45c <memmove+0x46>
 46c:	bfc9                	j	43e <memmove+0x28>

000000000000046e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46e:	1141                	add	sp,sp,-16
 470:	e422                	sd	s0,8(sp)
 472:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 474:	ca05                	beqz	a2,4a4 <memcmp+0x36>
 476:	fff6069b          	addw	a3,a2,-1
 47a:	1682                	sll	a3,a3,0x20
 47c:	9281                	srl	a3,a3,0x20
 47e:	0685                	add	a3,a3,1
 480:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 482:	00054783          	lbu	a5,0(a0)
 486:	0005c703          	lbu	a4,0(a1)
 48a:	00e79863          	bne	a5,a4,49a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 48e:	0505                	add	a0,a0,1
    p2++;
 490:	0585                	add	a1,a1,1
  while (n-- > 0) {
 492:	fed518e3          	bne	a0,a3,482 <memcmp+0x14>
  }
  return 0;
 496:	4501                	li	a0,0
 498:	a019                	j	49e <memcmp+0x30>
      return *p1 - *p2;
 49a:	40e7853b          	subw	a0,a5,a4
}
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	add	sp,sp,16
 4a2:	8082                	ret
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	bfe5                	j	49e <memcmp+0x30>

00000000000004a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a8:	1141                	add	sp,sp,-16
 4aa:	e406                	sd	ra,8(sp)
 4ac:	e022                	sd	s0,0(sp)
 4ae:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 4b0:	f67ff0ef          	jal	416 <memmove>
}
 4b4:	60a2                	ld	ra,8(sp)
 4b6:	6402                	ld	s0,0(sp)
 4b8:	0141                	add	sp,sp,16
 4ba:	8082                	ret

00000000000004bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4bc:	4885                	li	a7,1
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c4:	4889                	li	a7,2
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4cc:	488d                	li	a7,3
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d4:	4891                	li	a7,4
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <read>:
.global read
read:
 li a7, SYS_read
 4dc:	4895                	li	a7,5
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <write>:
.global write
write:
 li a7, SYS_write
 4e4:	48c1                	li	a7,16
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <close>:
.global close
close:
 li a7, SYS_close
 4ec:	48d5                	li	a7,21
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f4:	4899                	li	a7,6
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4fc:	489d                	li	a7,7
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <open>:
.global open
open:
 li a7, SYS_open
 504:	48bd                	li	a7,15
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 50c:	48c5                	li	a7,17
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 514:	48c9                	li	a7,18
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 51c:	48a1                	li	a7,8
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <link>:
.global link
link:
 li a7, SYS_link
 524:	48cd                	li	a7,19
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 52c:	48d1                	li	a7,20
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 534:	48a5                	li	a7,9
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <dup>:
.global dup
dup:
 li a7, SYS_dup
 53c:	48a9                	li	a7,10
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 544:	48ad                	li	a7,11
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 54c:	48b1                	li	a7,12
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 554:	48b5                	li	a7,13
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 55c:	48b9                	li	a7,14
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 564:	1101                	add	sp,sp,-32
 566:	ec06                	sd	ra,24(sp)
 568:	e822                	sd	s0,16(sp)
 56a:	1000                	add	s0,sp,32
 56c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 570:	4605                	li	a2,1
 572:	fef40593          	add	a1,s0,-17
 576:	f6fff0ef          	jal	4e4 <write>
}
 57a:	60e2                	ld	ra,24(sp)
 57c:	6442                	ld	s0,16(sp)
 57e:	6105                	add	sp,sp,32
 580:	8082                	ret

0000000000000582 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 582:	7139                	add	sp,sp,-64
 584:	fc06                	sd	ra,56(sp)
 586:	f822                	sd	s0,48(sp)
 588:	f426                	sd	s1,40(sp)
 58a:	f04a                	sd	s2,32(sp)
 58c:	ec4e                	sd	s3,24(sp)
 58e:	0080                	add	s0,sp,64
 590:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 592:	c299                	beqz	a3,598 <printint+0x16>
 594:	0805c763          	bltz	a1,622 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 598:	2581                	sext.w	a1,a1
  neg = 0;
 59a:	4881                	li	a7,0
 59c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 5a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a2:	2601                	sext.w	a2,a2
 5a4:	00000517          	auipc	a0,0x0
 5a8:	50c50513          	add	a0,a0,1292 # ab0 <digits>
 5ac:	883a                	mv	a6,a4
 5ae:	2705                	addw	a4,a4,1
 5b0:	02c5f7bb          	remuw	a5,a1,a2
 5b4:	1782                	sll	a5,a5,0x20
 5b6:	9381                	srl	a5,a5,0x20
 5b8:	97aa                	add	a5,a5,a0
 5ba:	0007c783          	lbu	a5,0(a5)
 5be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c2:	0005879b          	sext.w	a5,a1
 5c6:	02c5d5bb          	divuw	a1,a1,a2
 5ca:	0685                	add	a3,a3,1
 5cc:	fec7f0e3          	bgeu	a5,a2,5ac <printint+0x2a>
  if(neg)
 5d0:	00088c63          	beqz	a7,5e8 <printint+0x66>
    buf[i++] = '-';
 5d4:	fd070793          	add	a5,a4,-48
 5d8:	00878733          	add	a4,a5,s0
 5dc:	02d00793          	li	a5,45
 5e0:	fef70823          	sb	a5,-16(a4)
 5e4:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 5e8:	02e05663          	blez	a4,614 <printint+0x92>
 5ec:	fc040793          	add	a5,s0,-64
 5f0:	00e78933          	add	s2,a5,a4
 5f4:	fff78993          	add	s3,a5,-1
 5f8:	99ba                	add	s3,s3,a4
 5fa:	377d                	addw	a4,a4,-1
 5fc:	1702                	sll	a4,a4,0x20
 5fe:	9301                	srl	a4,a4,0x20
 600:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 604:	fff94583          	lbu	a1,-1(s2)
 608:	8526                	mv	a0,s1
 60a:	f5bff0ef          	jal	564 <putc>
  while(--i >= 0)
 60e:	197d                	add	s2,s2,-1
 610:	ff391ae3          	bne	s2,s3,604 <printint+0x82>
}
 614:	70e2                	ld	ra,56(sp)
 616:	7442                	ld	s0,48(sp)
 618:	74a2                	ld	s1,40(sp)
 61a:	7902                	ld	s2,32(sp)
 61c:	69e2                	ld	s3,24(sp)
 61e:	6121                	add	sp,sp,64
 620:	8082                	ret
    x = -xx;
 622:	40b005bb          	negw	a1,a1
    neg = 1;
 626:	4885                	li	a7,1
    x = -xx;
 628:	bf95                	j	59c <printint+0x1a>

000000000000062a <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62a:	711d                	add	sp,sp,-96
 62c:	ec86                	sd	ra,88(sp)
 62e:	e8a2                	sd	s0,80(sp)
 630:	e4a6                	sd	s1,72(sp)
 632:	e0ca                	sd	s2,64(sp)
 634:	fc4e                	sd	s3,56(sp)
 636:	f852                	sd	s4,48(sp)
 638:	f456                	sd	s5,40(sp)
 63a:	f05a                	sd	s6,32(sp)
 63c:	ec5e                	sd	s7,24(sp)
 63e:	e862                	sd	s8,16(sp)
 640:	e466                	sd	s9,8(sp)
 642:	e06a                	sd	s10,0(sp)
 644:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 646:	0005c903          	lbu	s2,0(a1)
 64a:	24090763          	beqz	s2,898 <vprintf+0x26e>
 64e:	8b2a                	mv	s6,a0
 650:	8a2e                	mv	s4,a1
 652:	8bb2                	mv	s7,a2
  state = 0;
 654:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 656:	4481                	li	s1,0
 658:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 65a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 65e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 662:	06c00c93          	li	s9,108
 666:	a005                	j	686 <vprintf+0x5c>
        putc(fd, c0);
 668:	85ca                	mv	a1,s2
 66a:	855a                	mv	a0,s6
 66c:	ef9ff0ef          	jal	564 <putc>
 670:	a019                	j	676 <vprintf+0x4c>
    } else if(state == '%'){
 672:	03598263          	beq	s3,s5,696 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 676:	2485                	addw	s1,s1,1
 678:	8726                	mv	a4,s1
 67a:	009a07b3          	add	a5,s4,s1
 67e:	0007c903          	lbu	s2,0(a5)
 682:	20090b63          	beqz	s2,898 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 686:	0009079b          	sext.w	a5,s2
    if(state == 0){
 68a:	fe0994e3          	bnez	s3,672 <vprintf+0x48>
      if(c0 == '%'){
 68e:	fd579de3          	bne	a5,s5,668 <vprintf+0x3e>
        state = '%';
 692:	89be                	mv	s3,a5
 694:	b7cd                	j	676 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 696:	c7c9                	beqz	a5,720 <vprintf+0xf6>
 698:	00ea06b3          	add	a3,s4,a4
 69c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6a0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6a2:	c681                	beqz	a3,6aa <vprintf+0x80>
 6a4:	9752                	add	a4,a4,s4
 6a6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6aa:	03878f63          	beq	a5,s8,6e8 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
 6ae:	05978963          	beq	a5,s9,700 <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6b2:	07500713          	li	a4,117
 6b6:	0ee78363          	beq	a5,a4,79c <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ba:	07800713          	li	a4,120
 6be:	12e78563          	beq	a5,a4,7e8 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6c2:	07000713          	li	a4,112
 6c6:	14e78a63          	beq	a5,a4,81a <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6ca:	07300713          	li	a4,115
 6ce:	18e78863          	beq	a5,a4,85e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6d2:	02500713          	li	a4,37
 6d6:	04e79563          	bne	a5,a4,720 <vprintf+0xf6>
        putc(fd, '%');
 6da:	02500593          	li	a1,37
 6de:	855a                	mv	a0,s6
 6e0:	e85ff0ef          	jal	564 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bf41                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 6e8:	008b8913          	add	s2,s7,8
 6ec:	4685                	li	a3,1
 6ee:	4629                	li	a2,10
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	e8dff0ef          	jal	582 <printint>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bfa5                	j	676 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 700:	06400793          	li	a5,100
 704:	02f68963          	beq	a3,a5,736 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 708:	06c00793          	li	a5,108
 70c:	04f68263          	beq	a3,a5,750 <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
 710:	07500793          	li	a5,117
 714:	0af68063          	beq	a3,a5,7b4 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
 718:	07800793          	li	a5,120
 71c:	0ef68263          	beq	a3,a5,800 <vprintf+0x1d6>
        putc(fd, '%');
 720:	02500593          	li	a1,37
 724:	855a                	mv	a0,s6
 726:	e3fff0ef          	jal	564 <putc>
        putc(fd, c0);
 72a:	85ca                	mv	a1,s2
 72c:	855a                	mv	a0,s6
 72e:	e37ff0ef          	jal	564 <putc>
      state = 0;
 732:	4981                	li	s3,0
 734:	b789                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 736:	008b8913          	add	s2,s7,8
 73a:	4685                	li	a3,1
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	e3fff0ef          	jal	582 <printint>
        i += 1;
 748:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 1;
 74e:	b725                	j	676 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 750:	06400793          	li	a5,100
 754:	02f60763          	beq	a2,a5,782 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 758:	07500793          	li	a5,117
 75c:	06f60963          	beq	a2,a5,7ce <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 760:	07800793          	li	a5,120
 764:	faf61ee3          	bne	a2,a5,720 <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
 768:	008b8913          	add	s2,s7,8
 76c:	4681                	li	a3,0
 76e:	4641                	li	a2,16
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	e0dff0ef          	jal	582 <printint>
        i += 2;
 77a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
        i += 2;
 780:	bddd                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 782:	008b8913          	add	s2,s7,8
 786:	4685                	li	a3,1
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	df3ff0ef          	jal	582 <printint>
        i += 2;
 794:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 2;
 79a:	bdf1                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
 79c:	008b8913          	add	s2,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4629                	li	a2,10
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	dd9ff0ef          	jal	582 <printint>
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b5d1                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b4:	008b8913          	add	s2,s7,8
 7b8:	4681                	li	a3,0
 7ba:	4629                	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	dc1ff0ef          	jal	582 <printint>
        i += 1;
 7c6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
        i += 1;
 7cc:	b56d                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ce:	008b8913          	add	s2,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4629                	li	a2,10
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	da7ff0ef          	jal	582 <printint>
        i += 2;
 7e0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e2:	8bca                	mv	s7,s2
      state = 0;
 7e4:	4981                	li	s3,0
        i += 2;
 7e6:	bd41                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
 7e8:	008b8913          	add	s2,s7,8
 7ec:	4681                	li	a3,0
 7ee:	4641                	li	a2,16
 7f0:	000ba583          	lw	a1,0(s7)
 7f4:	855a                	mv	a0,s6
 7f6:	d8dff0ef          	jal	582 <printint>
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bda5                	j	676 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 800:	008b8913          	add	s2,s7,8
 804:	4681                	li	a3,0
 806:	4641                	li	a2,16
 808:	000ba583          	lw	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	d75ff0ef          	jal	582 <printint>
        i += 1;
 812:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 814:	8bca                	mv	s7,s2
      state = 0;
 816:	4981                	li	s3,0
        i += 1;
 818:	bdb9                	j	676 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 81a:	008b8d13          	add	s10,s7,8
 81e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 822:	03000593          	li	a1,48
 826:	855a                	mv	a0,s6
 828:	d3dff0ef          	jal	564 <putc>
  putc(fd, 'x');
 82c:	07800593          	li	a1,120
 830:	855a                	mv	a0,s6
 832:	d33ff0ef          	jal	564 <putc>
 836:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 838:	00000b97          	auipc	s7,0x0
 83c:	278b8b93          	add	s7,s7,632 # ab0 <digits>
 840:	03c9d793          	srl	a5,s3,0x3c
 844:	97de                	add	a5,a5,s7
 846:	0007c583          	lbu	a1,0(a5)
 84a:	855a                	mv	a0,s6
 84c:	d19ff0ef          	jal	564 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 850:	0992                	sll	s3,s3,0x4
 852:	397d                	addw	s2,s2,-1
 854:	fe0916e3          	bnez	s2,840 <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
 858:	8bea                	mv	s7,s10
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bd29                	j	676 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 85e:	008b8993          	add	s3,s7,8
 862:	000bb903          	ld	s2,0(s7)
 866:	00090f63          	beqz	s2,884 <vprintf+0x25a>
        for(; *s; s++)
 86a:	00094583          	lbu	a1,0(s2)
 86e:	c195                	beqz	a1,892 <vprintf+0x268>
          putc(fd, *s);
 870:	855a                	mv	a0,s6
 872:	cf3ff0ef          	jal	564 <putc>
        for(; *s; s++)
 876:	0905                	add	s2,s2,1
 878:	00094583          	lbu	a1,0(s2)
 87c:	f9f5                	bnez	a1,870 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 87e:	8bce                	mv	s7,s3
      state = 0;
 880:	4981                	li	s3,0
 882:	bbd5                	j	676 <vprintf+0x4c>
          s = "(null)";
 884:	00000917          	auipc	s2,0x0
 888:	22490913          	add	s2,s2,548 # aa8 <malloc+0x116>
        for(; *s; s++)
 88c:	02800593          	li	a1,40
 890:	b7c5                	j	870 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 892:	8bce                	mv	s7,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	b3c5                	j	676 <vprintf+0x4c>
    }
  }
}
 898:	60e6                	ld	ra,88(sp)
 89a:	6446                	ld	s0,80(sp)
 89c:	64a6                	ld	s1,72(sp)
 89e:	6906                	ld	s2,64(sp)
 8a0:	79e2                	ld	s3,56(sp)
 8a2:	7a42                	ld	s4,48(sp)
 8a4:	7aa2                	ld	s5,40(sp)
 8a6:	7b02                	ld	s6,32(sp)
 8a8:	6be2                	ld	s7,24(sp)
 8aa:	6c42                	ld	s8,16(sp)
 8ac:	6ca2                	ld	s9,8(sp)
 8ae:	6d02                	ld	s10,0(sp)
 8b0:	6125                	add	sp,sp,96
 8b2:	8082                	ret

00000000000008b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b4:	715d                	add	sp,sp,-80
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	1000                	add	s0,sp,32
 8bc:	e010                	sd	a2,0(s0)
 8be:	e414                	sd	a3,8(s0)
 8c0:	e818                	sd	a4,16(s0)
 8c2:	ec1c                	sd	a5,24(s0)
 8c4:	03043023          	sd	a6,32(s0)
 8c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d0:	8622                	mv	a2,s0
 8d2:	d59ff0ef          	jal	62a <vprintf>
}
 8d6:	60e2                	ld	ra,24(sp)
 8d8:	6442                	ld	s0,16(sp)
 8da:	6161                	add	sp,sp,80
 8dc:	8082                	ret

00000000000008de <printf>:

void
printf(const char *fmt, ...)
{
 8de:	711d                	add	sp,sp,-96
 8e0:	ec06                	sd	ra,24(sp)
 8e2:	e822                	sd	s0,16(sp)
 8e4:	1000                	add	s0,sp,32
 8e6:	e40c                	sd	a1,8(s0)
 8e8:	e810                	sd	a2,16(s0)
 8ea:	ec14                	sd	a3,24(s0)
 8ec:	f018                	sd	a4,32(s0)
 8ee:	f41c                	sd	a5,40(s0)
 8f0:	03043823          	sd	a6,48(s0)
 8f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f8:	00840613          	add	a2,s0,8
 8fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 900:	85aa                	mv	a1,a0
 902:	4505                	li	a0,1
 904:	d27ff0ef          	jal	62a <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6125                	add	sp,sp,96
 90e:	8082                	ret

0000000000000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	1141                	add	sp,sp,-16
 912:	e422                	sd	s0,8(sp)
 914:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 916:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91a:	00000797          	auipc	a5,0x0
 91e:	6e67b783          	ld	a5,1766(a5) # 1000 <freep>
 922:	a02d                	j	94c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 924:	4618                	lw	a4,8(a2)
 926:	9f2d                	addw	a4,a4,a1
 928:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 92c:	6398                	ld	a4,0(a5)
 92e:	6310                	ld	a2,0(a4)
 930:	a83d                	j	96e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 932:	ff852703          	lw	a4,-8(a0)
 936:	9f31                	addw	a4,a4,a2
 938:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93a:	ff053683          	ld	a3,-16(a0)
 93e:	a091                	j	982 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 940:	6398                	ld	a4,0(a5)
 942:	00e7e463          	bltu	a5,a4,94a <free+0x3a>
 946:	00e6ea63          	bltu	a3,a4,95a <free+0x4a>
{
 94a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94c:	fed7fae3          	bgeu	a5,a3,940 <free+0x30>
 950:	6398                	ld	a4,0(a5)
 952:	00e6e463          	bltu	a3,a4,95a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 956:	fee7eae3          	bltu	a5,a4,94a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 95a:	ff852583          	lw	a1,-8(a0)
 95e:	6390                	ld	a2,0(a5)
 960:	02059813          	sll	a6,a1,0x20
 964:	01c85713          	srl	a4,a6,0x1c
 968:	9736                	add	a4,a4,a3
 96a:	fae60de3          	beq	a2,a4,924 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 96e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 972:	4790                	lw	a2,8(a5)
 974:	02061593          	sll	a1,a2,0x20
 978:	01c5d713          	srl	a4,a1,0x1c
 97c:	973e                	add	a4,a4,a5
 97e:	fae68ae3          	beq	a3,a4,932 <free+0x22>
    p->s.ptr = bp->s.ptr;
 982:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 984:	00000717          	auipc	a4,0x0
 988:	66f73e23          	sd	a5,1660(a4) # 1000 <freep>
}
 98c:	6422                	ld	s0,8(sp)
 98e:	0141                	add	sp,sp,16
 990:	8082                	ret

0000000000000992 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 992:	7139                	add	sp,sp,-64
 994:	fc06                	sd	ra,56(sp)
 996:	f822                	sd	s0,48(sp)
 998:	f426                	sd	s1,40(sp)
 99a:	f04a                	sd	s2,32(sp)
 99c:	ec4e                	sd	s3,24(sp)
 99e:	e852                	sd	s4,16(sp)
 9a0:	e456                	sd	s5,8(sp)
 9a2:	e05a                	sd	s6,0(sp)
 9a4:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a6:	02051493          	sll	s1,a0,0x20
 9aa:	9081                	srl	s1,s1,0x20
 9ac:	04bd                	add	s1,s1,15
 9ae:	8091                	srl	s1,s1,0x4
 9b0:	0014899b          	addw	s3,s1,1
 9b4:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9b6:	00000517          	auipc	a0,0x0
 9ba:	64a53503          	ld	a0,1610(a0) # 1000 <freep>
 9be:	c515                	beqz	a0,9ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c2:	4798                	lw	a4,8(a5)
 9c4:	02977f63          	bgeu	a4,s1,a02 <malloc+0x70>
  if(nu < 4096)
 9c8:	8a4e                	mv	s4,s3
 9ca:	0009871b          	sext.w	a4,s3
 9ce:	6685                	lui	a3,0x1
 9d0:	00d77363          	bgeu	a4,a3,9d6 <malloc+0x44>
 9d4:	6a05                	lui	s4,0x1
 9d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9da:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9de:	00000917          	auipc	s2,0x0
 9e2:	62290913          	add	s2,s2,1570 # 1000 <freep>
  if(p == (char*)-1)
 9e6:	5afd                	li	s5,-1
 9e8:	a885                	j	a58 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 9ea:	00001797          	auipc	a5,0x1
 9ee:	a2678793          	add	a5,a5,-1498 # 1410 <base>
 9f2:	00000717          	auipc	a4,0x0
 9f6:	60f73723          	sd	a5,1550(a4) # 1000 <freep>
 9fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a00:	b7e1                	j	9c8 <malloc+0x36>
      if(p->s.size == nunits)
 a02:	02e48c63          	beq	s1,a4,a3a <malloc+0xa8>
        p->s.size -= nunits;
 a06:	4137073b          	subw	a4,a4,s3
 a0a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a0c:	02071693          	sll	a3,a4,0x20
 a10:	01c6d713          	srl	a4,a3,0x1c
 a14:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a16:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1a:	00000717          	auipc	a4,0x0
 a1e:	5ea73323          	sd	a0,1510(a4) # 1000 <freep>
      return (void*)(p + 1);
 a22:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a26:	70e2                	ld	ra,56(sp)
 a28:	7442                	ld	s0,48(sp)
 a2a:	74a2                	ld	s1,40(sp)
 a2c:	7902                	ld	s2,32(sp)
 a2e:	69e2                	ld	s3,24(sp)
 a30:	6a42                	ld	s4,16(sp)
 a32:	6aa2                	ld	s5,8(sp)
 a34:	6b02                	ld	s6,0(sp)
 a36:	6121                	add	sp,sp,64
 a38:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a3a:	6398                	ld	a4,0(a5)
 a3c:	e118                	sd	a4,0(a0)
 a3e:	bff1                	j	a1a <malloc+0x88>
  hp->s.size = nu;
 a40:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a44:	0541                	add	a0,a0,16
 a46:	ecbff0ef          	jal	910 <free>
  return freep;
 a4a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a4e:	dd61                	beqz	a0,a26 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a52:	4798                	lw	a4,8(a5)
 a54:	fa9777e3          	bgeu	a4,s1,a02 <malloc+0x70>
    if(p == freep)
 a58:	00093703          	ld	a4,0(s2)
 a5c:	853e                	mv	a0,a5
 a5e:	fef719e3          	bne	a4,a5,a50 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 a62:	8552                	mv	a0,s4
 a64:	ae9ff0ef          	jal	54c <sbrk>
  if(p == (char*)-1)
 a68:	fd551ce3          	bne	a0,s5,a40 <malloc+0xae>
        return 0;
 a6c:	4501                	li	a0,0
 a6e:	bf65                	j	a26 <malloc+0x94>
