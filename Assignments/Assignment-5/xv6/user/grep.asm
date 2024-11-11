
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
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	add	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	add	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	add	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	add	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	add	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	add	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	add	a1,a1,1
  ba:	00178513          	add	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	add	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	add	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	add	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	add	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	add	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	add	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	add	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	ed4a8a93          	add	s5,s5,-300 # 1010 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	add	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	20a080e7          	jalr	522(ra) # 358 <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	add	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	3d2080e7          	jalr	978(ra) # 550 <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	3b2080e7          	jalr	946(ra) # 548 <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	e5a50513          	add	a0,a0,-422 # 1010 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	2b4080e7          	jalr	692(ra) # 47e <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	add	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	add	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	add	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	add	s2,a1,16
 210:	ffd5099b          	addw	s3,a0,-3
 214:	02099793          	sll	a5,s3,0x20
 218:	01d7d993          	srl	s3,a5,0x1d
 21c:	05e1                	add	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	34a080e7          	jalr	842(ra) # 570 <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	316080e7          	jalr	790(ra) # 558 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	add	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	2de080e7          	jalr	734(ra) # 530 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	8e658593          	add	a1,a1,-1818 # b40 <malloc+0xee>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	708080e7          	jalr	1800(ra) # 96c <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2c2080e7          	jalr	706(ra) # 530 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2ac080e7          	jalr	684(ra) # 530 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	8d050513          	add	a0,a0,-1840 # b60 <malloc+0x10e>
 298:	00000097          	auipc	ra,0x0
 29c:	702080e7          	jalr	1794(ra) # 99a <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	28e080e7          	jalr	654(ra) # 530 <exit>

00000000000002aa <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
 2aa:	1141                	add	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	add	s0,sp,16
  extern int main();
  main();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	f3a080e7          	jalr	-198(ra) # 1ec <main>
  exit(0);
 2ba:	4501                	li	a0,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	274080e7          	jalr	628(ra) # 530 <exit>

00000000000002c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c4:	1141                	add	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ca:	87aa                	mv	a5,a0
 2cc:	0585                	add	a1,a1,1
 2ce:	0785                	add	a5,a5,1
 2d0:	fff5c703          	lbu	a4,-1(a1)
 2d4:	fee78fa3          	sb	a4,-1(a5)
 2d8:	fb75                	bnez	a4,2cc <strcpy+0x8>
    ;
  return os;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	add	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	add	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cb91                	beqz	a5,2fe <strcmp+0x1e>
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00f71763          	bne	a4,a5,2fe <strcmp+0x1e>
    p++, q++;
 2f4:	0505                	add	a0,a0,1
 2f6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	fbe5                	bnez	a5,2ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fe:	0005c503          	lbu	a0,0(a1)
}
 302:	40a7853b          	subw	a0,a5,a0
 306:	6422                	ld	s0,8(sp)
 308:	0141                	add	sp,sp,16
 30a:	8082                	ret

000000000000030c <strlen>:

uint
strlen(const char *s)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 312:	00054783          	lbu	a5,0(a0)
 316:	cf91                	beqz	a5,332 <strlen+0x26>
 318:	0505                	add	a0,a0,1
 31a:	87aa                	mv	a5,a0
 31c:	86be                	mv	a3,a5
 31e:	0785                	add	a5,a5,1
 320:	fff7c703          	lbu	a4,-1(a5)
 324:	ff65                	bnez	a4,31c <strlen+0x10>
 326:	40a6853b          	subw	a0,a3,a0
 32a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	add	sp,sp,16
 330:	8082                	ret
  for(n = 0; s[n]; n++)
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <strlen+0x20>

0000000000000336 <memset>:

void*
memset(void *dst, int c, uint n)
{
 336:	1141                	add	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 33c:	ca19                	beqz	a2,352 <memset+0x1c>
 33e:	87aa                	mv	a5,a0
 340:	1602                	sll	a2,a2,0x20
 342:	9201                	srl	a2,a2,0x20
 344:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 348:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34c:	0785                	add	a5,a5,1
 34e:	fee79de3          	bne	a5,a4,348 <memset+0x12>
  }
  return dst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	add	sp,sp,16
 356:	8082                	ret

0000000000000358 <strchr>:

char*
strchr(const char *s, char c)
{
 358:	1141                	add	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	add	s0,sp,16
  for(; *s; s++)
 35e:	00054783          	lbu	a5,0(a0)
 362:	cb99                	beqz	a5,378 <strchr+0x20>
    if(*s == c)
 364:	00f58763          	beq	a1,a5,372 <strchr+0x1a>
  for(; *s; s++)
 368:	0505                	add	a0,a0,1
 36a:	00054783          	lbu	a5,0(a0)
 36e:	fbfd                	bnez	a5,364 <strchr+0xc>
      return (char*)s;
  return 0;
 370:	4501                	li	a0,0
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	add	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strchr+0x1a>

000000000000037c <gets>:

char*
gets(char *buf, int max)
{
 37c:	711d                	add	sp,sp,-96
 37e:	ec86                	sd	ra,88(sp)
 380:	e8a2                	sd	s0,80(sp)
 382:	e4a6                	sd	s1,72(sp)
 384:	e0ca                	sd	s2,64(sp)
 386:	fc4e                	sd	s3,56(sp)
 388:	f852                	sd	s4,48(sp)
 38a:	f456                	sd	s5,40(sp)
 38c:	f05a                	sd	s6,32(sp)
 38e:	ec5e                	sd	s7,24(sp)
 390:	1080                	add	s0,sp,96
 392:	8baa                	mv	s7,a0
 394:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	892a                	mv	s2,a0
 398:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39a:	4aa9                	li	s5,10
 39c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39e:	89a6                	mv	s3,s1
 3a0:	2485                	addw	s1,s1,1
 3a2:	0344d863          	bge	s1,s4,3d2 <gets+0x56>
    cc = read(0, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	faf40593          	add	a1,s0,-81
 3ac:	4501                	li	a0,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	19a080e7          	jalr	410(ra) # 548 <read>
    if(cc < 1)
 3b6:	00a05e63          	blez	a0,3d2 <gets+0x56>
    buf[i++] = c;
 3ba:	faf44783          	lbu	a5,-81(s0)
 3be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c2:	01578763          	beq	a5,s5,3d0 <gets+0x54>
 3c6:	0905                	add	s2,s2,1
 3c8:	fd679be3          	bne	a5,s6,39e <gets+0x22>
  for(i=0; i+1 < max; ){
 3cc:	89a6                	mv	s3,s1
 3ce:	a011                	j	3d2 <gets+0x56>
 3d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d2:	99de                	add	s3,s3,s7
 3d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d8:	855e                	mv	a0,s7
 3da:	60e6                	ld	ra,88(sp)
 3dc:	6446                	ld	s0,80(sp)
 3de:	64a6                	ld	s1,72(sp)
 3e0:	6906                	ld	s2,64(sp)
 3e2:	79e2                	ld	s3,56(sp)
 3e4:	7a42                	ld	s4,48(sp)
 3e6:	7aa2                	ld	s5,40(sp)
 3e8:	7b02                	ld	s6,32(sp)
 3ea:	6be2                	ld	s7,24(sp)
 3ec:	6125                	add	sp,sp,96
 3ee:	8082                	ret

00000000000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	1101                	add	sp,sp,-32
 3f2:	ec06                	sd	ra,24(sp)
 3f4:	e822                	sd	s0,16(sp)
 3f6:	e426                	sd	s1,8(sp)
 3f8:	e04a                	sd	s2,0(sp)
 3fa:	1000                	add	s0,sp,32
 3fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fe:	4581                	li	a1,0
 400:	00000097          	auipc	ra,0x0
 404:	170080e7          	jalr	368(ra) # 570 <open>
  if(fd < 0)
 408:	02054563          	bltz	a0,432 <stat+0x42>
 40c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 40e:	85ca                	mv	a1,s2
 410:	00000097          	auipc	ra,0x0
 414:	178080e7          	jalr	376(ra) # 588 <fstat>
 418:	892a                	mv	s2,a0
  close(fd);
 41a:	8526                	mv	a0,s1
 41c:	00000097          	auipc	ra,0x0
 420:	13c080e7          	jalr	316(ra) # 558 <close>
  return r;
}
 424:	854a                	mv	a0,s2
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	64a2                	ld	s1,8(sp)
 42c:	6902                	ld	s2,0(sp)
 42e:	6105                	add	sp,sp,32
 430:	8082                	ret
    return -1;
 432:	597d                	li	s2,-1
 434:	bfc5                	j	424 <stat+0x34>

0000000000000436 <atoi>:

int
atoi(const char *s)
{
 436:	1141                	add	sp,sp,-16
 438:	e422                	sd	s0,8(sp)
 43a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 43c:	00054683          	lbu	a3,0(a0)
 440:	fd06879b          	addw	a5,a3,-48
 444:	0ff7f793          	zext.b	a5,a5
 448:	4625                	li	a2,9
 44a:	02f66863          	bltu	a2,a5,47a <atoi+0x44>
 44e:	872a                	mv	a4,a0
  n = 0;
 450:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 452:	0705                	add	a4,a4,1
 454:	0025179b          	sllw	a5,a0,0x2
 458:	9fa9                	addw	a5,a5,a0
 45a:	0017979b          	sllw	a5,a5,0x1
 45e:	9fb5                	addw	a5,a5,a3
 460:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 464:	00074683          	lbu	a3,0(a4)
 468:	fd06879b          	addw	a5,a3,-48
 46c:	0ff7f793          	zext.b	a5,a5
 470:	fef671e3          	bgeu	a2,a5,452 <atoi+0x1c>
  return n;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	add	sp,sp,16
 478:	8082                	ret
  n = 0;
 47a:	4501                	li	a0,0
 47c:	bfe5                	j	474 <atoi+0x3e>

000000000000047e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47e:	1141                	add	sp,sp,-16
 480:	e422                	sd	s0,8(sp)
 482:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 484:	02b57463          	bgeu	a0,a1,4ac <memmove+0x2e>
    while(n-- > 0)
 488:	00c05f63          	blez	a2,4a6 <memmove+0x28>
 48c:	1602                	sll	a2,a2,0x20
 48e:	9201                	srl	a2,a2,0x20
 490:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 494:	872a                	mv	a4,a0
      *dst++ = *src++;
 496:	0585                	add	a1,a1,1
 498:	0705                	add	a4,a4,1
 49a:	fff5c683          	lbu	a3,-1(a1)
 49e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4a2:	fee79ae3          	bne	a5,a4,496 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	add	sp,sp,16
 4aa:	8082                	ret
    dst += n;
 4ac:	00c50733          	add	a4,a0,a2
    src += n;
 4b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4b2:	fec05ae3          	blez	a2,4a6 <memmove+0x28>
 4b6:	fff6079b          	addw	a5,a2,-1
 4ba:	1782                	sll	a5,a5,0x20
 4bc:	9381                	srl	a5,a5,0x20
 4be:	fff7c793          	not	a5,a5
 4c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4c4:	15fd                	add	a1,a1,-1
 4c6:	177d                	add	a4,a4,-1
 4c8:	0005c683          	lbu	a3,0(a1)
 4cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4d0:	fee79ae3          	bne	a5,a4,4c4 <memmove+0x46>
 4d4:	bfc9                	j	4a6 <memmove+0x28>

00000000000004d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4d6:	1141                	add	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4dc:	ca05                	beqz	a2,50c <memcmp+0x36>
 4de:	fff6069b          	addw	a3,a2,-1
 4e2:	1682                	sll	a3,a3,0x20
 4e4:	9281                	srl	a3,a3,0x20
 4e6:	0685                	add	a3,a3,1
 4e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ea:	00054783          	lbu	a5,0(a0)
 4ee:	0005c703          	lbu	a4,0(a1)
 4f2:	00e79863          	bne	a5,a4,502 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4f6:	0505                	add	a0,a0,1
    p2++;
 4f8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 4fa:	fed518e3          	bne	a0,a3,4ea <memcmp+0x14>
  }
  return 0;
 4fe:	4501                	li	a0,0
 500:	a019                	j	506 <memcmp+0x30>
      return *p1 - *p2;
 502:	40e7853b          	subw	a0,a5,a4
}
 506:	6422                	ld	s0,8(sp)
 508:	0141                	add	sp,sp,16
 50a:	8082                	ret
  return 0;
 50c:	4501                	li	a0,0
 50e:	bfe5                	j	506 <memcmp+0x30>

0000000000000510 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 510:	1141                	add	sp,sp,-16
 512:	e406                	sd	ra,8(sp)
 514:	e022                	sd	s0,0(sp)
 516:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 518:	00000097          	auipc	ra,0x0
 51c:	f66080e7          	jalr	-154(ra) # 47e <memmove>
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	add	sp,sp,16
 526:	8082                	ret

0000000000000528 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 528:	4885                	li	a7,1
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <exit>:
.global exit
exit:
 li a7, SYS_exit
 530:	4889                	li	a7,2
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <wait>:
.global wait
wait:
 li a7, SYS_wait
 538:	488d                	li	a7,3
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 540:	4891                	li	a7,4
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <read>:
.global read
read:
 li a7, SYS_read
 548:	4895                	li	a7,5
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <write>:
.global write
write:
 li a7, SYS_write
 550:	48c1                	li	a7,16
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <close>:
.global close
close:
 li a7, SYS_close
 558:	48d5                	li	a7,21
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <kill>:
.global kill
kill:
 li a7, SYS_kill
 560:	4899                	li	a7,6
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <exec>:
.global exec
exec:
 li a7, SYS_exec
 568:	489d                	li	a7,7
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <open>:
.global open
open:
 li a7, SYS_open
 570:	48bd                	li	a7,15
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 578:	48c5                	li	a7,17
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 580:	48c9                	li	a7,18
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 588:	48a1                	li	a7,8
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <link>:
.global link
link:
 li a7, SYS_link
 590:	48cd                	li	a7,19
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 598:	48d1                	li	a7,20
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a0:	48a5                	li	a7,9
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5a8:	48a9                	li	a7,10
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b0:	48ad                	li	a7,11
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5b8:	48b1                	li	a7,12
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5c0:	48b5                	li	a7,13
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5c8:	48b9                	li	a7,14
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d0:	1101                	add	sp,sp,-32
 5d2:	ec06                	sd	ra,24(sp)
 5d4:	e822                	sd	s0,16(sp)
 5d6:	1000                	add	s0,sp,32
 5d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5dc:	4605                	li	a2,1
 5de:	fef40593          	add	a1,s0,-17
 5e2:	00000097          	auipc	ra,0x0
 5e6:	f6e080e7          	jalr	-146(ra) # 550 <write>
}
 5ea:	60e2                	ld	ra,24(sp)
 5ec:	6442                	ld	s0,16(sp)
 5ee:	6105                	add	sp,sp,32
 5f0:	8082                	ret

00000000000005f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f2:	7139                	add	sp,sp,-64
 5f4:	fc06                	sd	ra,56(sp)
 5f6:	f822                	sd	s0,48(sp)
 5f8:	f426                	sd	s1,40(sp)
 5fa:	f04a                	sd	s2,32(sp)
 5fc:	ec4e                	sd	s3,24(sp)
 5fe:	0080                	add	s0,sp,64
 600:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 602:	c299                	beqz	a3,608 <printint+0x16>
 604:	0805c963          	bltz	a1,696 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 608:	2581                	sext.w	a1,a1
  neg = 0;
 60a:	4881                	li	a7,0
 60c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 610:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 612:	2601                	sext.w	a2,a2
 614:	00000517          	auipc	a0,0x0
 618:	56c50513          	add	a0,a0,1388 # b80 <digits>
 61c:	883a                	mv	a6,a4
 61e:	2705                	addw	a4,a4,1
 620:	02c5f7bb          	remuw	a5,a1,a2
 624:	1782                	sll	a5,a5,0x20
 626:	9381                	srl	a5,a5,0x20
 628:	97aa                	add	a5,a5,a0
 62a:	0007c783          	lbu	a5,0(a5)
 62e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 632:	0005879b          	sext.w	a5,a1
 636:	02c5d5bb          	divuw	a1,a1,a2
 63a:	0685                	add	a3,a3,1
 63c:	fec7f0e3          	bgeu	a5,a2,61c <printint+0x2a>
  if(neg)
 640:	00088c63          	beqz	a7,658 <printint+0x66>
    buf[i++] = '-';
 644:	fd070793          	add	a5,a4,-48
 648:	00878733          	add	a4,a5,s0
 64c:	02d00793          	li	a5,45
 650:	fef70823          	sb	a5,-16(a4)
 654:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 658:	02e05863          	blez	a4,688 <printint+0x96>
 65c:	fc040793          	add	a5,s0,-64
 660:	00e78933          	add	s2,a5,a4
 664:	fff78993          	add	s3,a5,-1
 668:	99ba                	add	s3,s3,a4
 66a:	377d                	addw	a4,a4,-1
 66c:	1702                	sll	a4,a4,0x20
 66e:	9301                	srl	a4,a4,0x20
 670:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 674:	fff94583          	lbu	a1,-1(s2)
 678:	8526                	mv	a0,s1
 67a:	00000097          	auipc	ra,0x0
 67e:	f56080e7          	jalr	-170(ra) # 5d0 <putc>
  while(--i >= 0)
 682:	197d                	add	s2,s2,-1
 684:	ff3918e3          	bne	s2,s3,674 <printint+0x82>
}
 688:	70e2                	ld	ra,56(sp)
 68a:	7442                	ld	s0,48(sp)
 68c:	74a2                	ld	s1,40(sp)
 68e:	7902                	ld	s2,32(sp)
 690:	69e2                	ld	s3,24(sp)
 692:	6121                	add	sp,sp,64
 694:	8082                	ret
    x = -xx;
 696:	40b005bb          	negw	a1,a1
    neg = 1;
 69a:	4885                	li	a7,1
    x = -xx;
 69c:	bf85                	j	60c <printint+0x1a>

000000000000069e <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
 69e:	711d                	add	sp,sp,-96
 6a0:	ec86                	sd	ra,88(sp)
 6a2:	e8a2                	sd	s0,80(sp)
 6a4:	e4a6                	sd	s1,72(sp)
 6a6:	e0ca                	sd	s2,64(sp)
 6a8:	fc4e                	sd	s3,56(sp)
 6aa:	f852                	sd	s4,48(sp)
 6ac:	f456                	sd	s5,40(sp)
 6ae:	f05a                	sd	s6,32(sp)
 6b0:	ec5e                	sd	s7,24(sp)
 6b2:	e862                	sd	s8,16(sp)
 6b4:	e466                	sd	s9,8(sp)
 6b6:	e06a                	sd	s10,0(sp)
 6b8:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6ba:	0005c903          	lbu	s2,0(a1)
 6be:	28090963          	beqz	s2,950 <vprintf+0x2b2>
 6c2:	8b2a                	mv	s6,a0
 6c4:	8a2e                	mv	s4,a1
 6c6:	8bb2                	mv	s7,a2
  state = 0;
 6c8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6ca:	4481                	li	s1,0
 6cc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6ce:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6d2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6d6:	06c00c93          	li	s9,108
 6da:	a015                	j	6fe <vprintf+0x60>
        putc(fd, c0);
 6dc:	85ca                	mv	a1,s2
 6de:	855a                	mv	a0,s6
 6e0:	00000097          	auipc	ra,0x0
 6e4:	ef0080e7          	jalr	-272(ra) # 5d0 <putc>
 6e8:	a019                	j	6ee <vprintf+0x50>
    } else if(state == '%'){
 6ea:	03598263          	beq	s3,s5,70e <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 6ee:	2485                	addw	s1,s1,1
 6f0:	8726                	mv	a4,s1
 6f2:	009a07b3          	add	a5,s4,s1
 6f6:	0007c903          	lbu	s2,0(a5)
 6fa:	24090b63          	beqz	s2,950 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
 6fe:	0009079b          	sext.w	a5,s2
    if(state == 0){
 702:	fe0994e3          	bnez	s3,6ea <vprintf+0x4c>
      if(c0 == '%'){
 706:	fd579be3          	bne	a5,s5,6dc <vprintf+0x3e>
        state = '%';
 70a:	89be                	mv	s3,a5
 70c:	b7cd                	j	6ee <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 70e:	cbc9                	beqz	a5,7a0 <vprintf+0x102>
 710:	00ea06b3          	add	a3,s4,a4
 714:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 718:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 71a:	c681                	beqz	a3,722 <vprintf+0x84>
 71c:	9752                	add	a4,a4,s4
 71e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 722:	05878163          	beq	a5,s8,764 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 726:	05978d63          	beq	a5,s9,780 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 72a:	07500713          	li	a4,117
 72e:	10e78163          	beq	a5,a4,830 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 732:	07800713          	li	a4,120
 736:	14e78963          	beq	a5,a4,888 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 73a:	07000713          	li	a4,112
 73e:	18e78263          	beq	a5,a4,8c2 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 742:	07300713          	li	a4,115
 746:	1ce78663          	beq	a5,a4,912 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 74a:	02500713          	li	a4,37
 74e:	04e79963          	bne	a5,a4,7a0 <vprintf+0x102>
        putc(fd, '%');
 752:	02500593          	li	a1,37
 756:	855a                	mv	a0,s6
 758:	00000097          	auipc	ra,0x0
 75c:	e78080e7          	jalr	-392(ra) # 5d0 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 760:	4981                	li	s3,0
 762:	b771                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 764:	008b8913          	add	s2,s7,8
 768:	4685                	li	a3,1
 76a:	4629                	li	a2,10
 76c:	000ba583          	lw	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	00000097          	auipc	ra,0x0
 776:	e80080e7          	jalr	-384(ra) # 5f2 <printint>
 77a:	8bca                	mv	s7,s2
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bf85                	j	6ee <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 780:	06400793          	li	a5,100
 784:	02f68d63          	beq	a3,a5,7be <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 788:	06c00793          	li	a5,108
 78c:	04f68863          	beq	a3,a5,7dc <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
 790:	07500793          	li	a5,117
 794:	0af68c63          	beq	a3,a5,84c <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
 798:	07800793          	li	a5,120
 79c:	10f68463          	beq	a3,a5,8a4 <vprintf+0x206>
        putc(fd, '%');
 7a0:	02500593          	li	a1,37
 7a4:	855a                	mv	a0,s6
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e2a080e7          	jalr	-470(ra) # 5d0 <putc>
        putc(fd, c0);
 7ae:	85ca                	mv	a1,s2
 7b0:	855a                	mv	a0,s6
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e1e080e7          	jalr	-482(ra) # 5d0 <putc>
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bf0d                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7be:	008b8913          	add	s2,s7,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e26080e7          	jalr	-474(ra) # 5f2 <printint>
        i += 1;
 7d4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d6:	8bca                	mv	s7,s2
      state = 0;
 7d8:	4981                	li	s3,0
        i += 1;
 7da:	bf11                	j	6ee <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7dc:	06400793          	li	a5,100
 7e0:	02f60963          	beq	a2,a5,812 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e4:	07500793          	li	a5,117
 7e8:	08f60163          	beq	a2,a5,86a <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ec:	07800793          	li	a5,120
 7f0:	faf618e3          	bne	a2,a5,7a0 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f4:	008b8913          	add	s2,s7,8
 7f8:	4681                	li	a3,0
 7fa:	4641                	li	a2,16
 7fc:	000ba583          	lw	a1,0(s7)
 800:	855a                	mv	a0,s6
 802:	00000097          	auipc	ra,0x0
 806:	df0080e7          	jalr	-528(ra) # 5f2 <printint>
        i += 2;
 80a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 80c:	8bca                	mv	s7,s2
      state = 0;
 80e:	4981                	li	s3,0
        i += 2;
 810:	bdf9                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 812:	008b8913          	add	s2,s7,8
 816:	4685                	li	a3,1
 818:	4629                	li	a2,10
 81a:	000ba583          	lw	a1,0(s7)
 81e:	855a                	mv	a0,s6
 820:	00000097          	auipc	ra,0x0
 824:	dd2080e7          	jalr	-558(ra) # 5f2 <printint>
        i += 2;
 828:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 82a:	8bca                	mv	s7,s2
      state = 0;
 82c:	4981                	li	s3,0
        i += 2;
 82e:	b5c1                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
 830:	008b8913          	add	s2,s7,8
 834:	4681                	li	a3,0
 836:	4629                	li	a2,10
 838:	000ba583          	lw	a1,0(s7)
 83c:	855a                	mv	a0,s6
 83e:	00000097          	auipc	ra,0x0
 842:	db4080e7          	jalr	-588(ra) # 5f2 <printint>
 846:	8bca                	mv	s7,s2
      state = 0;
 848:	4981                	li	s3,0
 84a:	b555                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 84c:	008b8913          	add	s2,s7,8
 850:	4681                	li	a3,0
 852:	4629                	li	a2,10
 854:	000ba583          	lw	a1,0(s7)
 858:	855a                	mv	a0,s6
 85a:	00000097          	auipc	ra,0x0
 85e:	d98080e7          	jalr	-616(ra) # 5f2 <printint>
        i += 1;
 862:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 864:	8bca                	mv	s7,s2
      state = 0;
 866:	4981                	li	s3,0
        i += 1;
 868:	b559                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 86a:	008b8913          	add	s2,s7,8
 86e:	4681                	li	a3,0
 870:	4629                	li	a2,10
 872:	000ba583          	lw	a1,0(s7)
 876:	855a                	mv	a0,s6
 878:	00000097          	auipc	ra,0x0
 87c:	d7a080e7          	jalr	-646(ra) # 5f2 <printint>
        i += 2;
 880:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 882:	8bca                	mv	s7,s2
      state = 0;
 884:	4981                	li	s3,0
        i += 2;
 886:	b5a5                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
 888:	008b8913          	add	s2,s7,8
 88c:	4681                	li	a3,0
 88e:	4641                	li	a2,16
 890:	000ba583          	lw	a1,0(s7)
 894:	855a                	mv	a0,s6
 896:	00000097          	auipc	ra,0x0
 89a:	d5c080e7          	jalr	-676(ra) # 5f2 <printint>
 89e:	8bca                	mv	s7,s2
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	b5b1                	j	6ee <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8a4:	008b8913          	add	s2,s7,8
 8a8:	4681                	li	a3,0
 8aa:	4641                	li	a2,16
 8ac:	000ba583          	lw	a1,0(s7)
 8b0:	855a                	mv	a0,s6
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d40080e7          	jalr	-704(ra) # 5f2 <printint>
        i += 1;
 8ba:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8bc:	8bca                	mv	s7,s2
      state = 0;
 8be:	4981                	li	s3,0
        i += 1;
 8c0:	b53d                	j	6ee <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 8c2:	008b8d13          	add	s10,s7,8
 8c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8ca:	03000593          	li	a1,48
 8ce:	855a                	mv	a0,s6
 8d0:	00000097          	auipc	ra,0x0
 8d4:	d00080e7          	jalr	-768(ra) # 5d0 <putc>
  putc(fd, 'x');
 8d8:	07800593          	li	a1,120
 8dc:	855a                	mv	a0,s6
 8de:	00000097          	auipc	ra,0x0
 8e2:	cf2080e7          	jalr	-782(ra) # 5d0 <putc>
 8e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e8:	00000b97          	auipc	s7,0x0
 8ec:	298b8b93          	add	s7,s7,664 # b80 <digits>
 8f0:	03c9d793          	srl	a5,s3,0x3c
 8f4:	97de                	add	a5,a5,s7
 8f6:	0007c583          	lbu	a1,0(a5)
 8fa:	855a                	mv	a0,s6
 8fc:	00000097          	auipc	ra,0x0
 900:	cd4080e7          	jalr	-812(ra) # 5d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 904:	0992                	sll	s3,s3,0x4
 906:	397d                	addw	s2,s2,-1
 908:	fe0914e3          	bnez	s2,8f0 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
 90c:	8bea                	mv	s7,s10
      state = 0;
 90e:	4981                	li	s3,0
 910:	bbf9                	j	6ee <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 912:	008b8993          	add	s3,s7,8
 916:	000bb903          	ld	s2,0(s7)
 91a:	02090163          	beqz	s2,93c <vprintf+0x29e>
        for(; *s; s++)
 91e:	00094583          	lbu	a1,0(s2)
 922:	c585                	beqz	a1,94a <vprintf+0x2ac>
          putc(fd, *s);
 924:	855a                	mv	a0,s6
 926:	00000097          	auipc	ra,0x0
 92a:	caa080e7          	jalr	-854(ra) # 5d0 <putc>
        for(; *s; s++)
 92e:	0905                	add	s2,s2,1
 930:	00094583          	lbu	a1,0(s2)
 934:	f9e5                	bnez	a1,924 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 936:	8bce                	mv	s7,s3
      state = 0;
 938:	4981                	li	s3,0
 93a:	bb55                	j	6ee <vprintf+0x50>
          s = "(null)";
 93c:	00000917          	auipc	s2,0x0
 940:	23c90913          	add	s2,s2,572 # b78 <malloc+0x126>
        for(; *s; s++)
 944:	02800593          	li	a1,40
 948:	bff1                	j	924 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
 94a:	8bce                	mv	s7,s3
      state = 0;
 94c:	4981                	li	s3,0
 94e:	b345                	j	6ee <vprintf+0x50>
    }
  }
}
 950:	60e6                	ld	ra,88(sp)
 952:	6446                	ld	s0,80(sp)
 954:	64a6                	ld	s1,72(sp)
 956:	6906                	ld	s2,64(sp)
 958:	79e2                	ld	s3,56(sp)
 95a:	7a42                	ld	s4,48(sp)
 95c:	7aa2                	ld	s5,40(sp)
 95e:	7b02                	ld	s6,32(sp)
 960:	6be2                	ld	s7,24(sp)
 962:	6c42                	ld	s8,16(sp)
 964:	6ca2                	ld	s9,8(sp)
 966:	6d02                	ld	s10,0(sp)
 968:	6125                	add	sp,sp,96
 96a:	8082                	ret

000000000000096c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 96c:	715d                	add	sp,sp,-80
 96e:	ec06                	sd	ra,24(sp)
 970:	e822                	sd	s0,16(sp)
 972:	1000                	add	s0,sp,32
 974:	e010                	sd	a2,0(s0)
 976:	e414                	sd	a3,8(s0)
 978:	e818                	sd	a4,16(s0)
 97a:	ec1c                	sd	a5,24(s0)
 97c:	03043023          	sd	a6,32(s0)
 980:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 984:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 988:	8622                	mv	a2,s0
 98a:	00000097          	auipc	ra,0x0
 98e:	d14080e7          	jalr	-748(ra) # 69e <vprintf>
}
 992:	60e2                	ld	ra,24(sp)
 994:	6442                	ld	s0,16(sp)
 996:	6161                	add	sp,sp,80
 998:	8082                	ret

000000000000099a <printf>:

void
printf(const char *fmt, ...)
{
 99a:	711d                	add	sp,sp,-96
 99c:	ec06                	sd	ra,24(sp)
 99e:	e822                	sd	s0,16(sp)
 9a0:	1000                	add	s0,sp,32
 9a2:	e40c                	sd	a1,8(s0)
 9a4:	e810                	sd	a2,16(s0)
 9a6:	ec14                	sd	a3,24(s0)
 9a8:	f018                	sd	a4,32(s0)
 9aa:	f41c                	sd	a5,40(s0)
 9ac:	03043823          	sd	a6,48(s0)
 9b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9b4:	00840613          	add	a2,s0,8
 9b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9bc:	85aa                	mv	a1,a0
 9be:	4505                	li	a0,1
 9c0:	00000097          	auipc	ra,0x0
 9c4:	cde080e7          	jalr	-802(ra) # 69e <vprintf>
}
 9c8:	60e2                	ld	ra,24(sp)
 9ca:	6442                	ld	s0,16(sp)
 9cc:	6125                	add	sp,sp,96
 9ce:	8082                	ret

00000000000009d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9d0:	1141                	add	sp,sp,-16
 9d2:	e422                	sd	s0,8(sp)
 9d4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9da:	00000797          	auipc	a5,0x0
 9de:	6267b783          	ld	a5,1574(a5) # 1000 <freep>
 9e2:	a02d                	j	a0c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9e4:	4618                	lw	a4,8(a2)
 9e6:	9f2d                	addw	a4,a4,a1
 9e8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ec:	6398                	ld	a4,0(a5)
 9ee:	6310                	ld	a2,0(a4)
 9f0:	a83d                	j	a2e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9f2:	ff852703          	lw	a4,-8(a0)
 9f6:	9f31                	addw	a4,a4,a2
 9f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9fa:	ff053683          	ld	a3,-16(a0)
 9fe:	a091                	j	a42 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a00:	6398                	ld	a4,0(a5)
 a02:	00e7e463          	bltu	a5,a4,a0a <free+0x3a>
 a06:	00e6ea63          	bltu	a3,a4,a1a <free+0x4a>
{
 a0a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0c:	fed7fae3          	bgeu	a5,a3,a00 <free+0x30>
 a10:	6398                	ld	a4,0(a5)
 a12:	00e6e463          	bltu	a3,a4,a1a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a16:	fee7eae3          	bltu	a5,a4,a0a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a1a:	ff852583          	lw	a1,-8(a0)
 a1e:	6390                	ld	a2,0(a5)
 a20:	02059813          	sll	a6,a1,0x20
 a24:	01c85713          	srl	a4,a6,0x1c
 a28:	9736                	add	a4,a4,a3
 a2a:	fae60de3          	beq	a2,a4,9e4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a2e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a32:	4790                	lw	a2,8(a5)
 a34:	02061593          	sll	a1,a2,0x20
 a38:	01c5d713          	srl	a4,a1,0x1c
 a3c:	973e                	add	a4,a4,a5
 a3e:	fae68ae3          	beq	a3,a4,9f2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a42:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a44:	00000717          	auipc	a4,0x0
 a48:	5af73e23          	sd	a5,1468(a4) # 1000 <freep>
}
 a4c:	6422                	ld	s0,8(sp)
 a4e:	0141                	add	sp,sp,16
 a50:	8082                	ret

0000000000000a52 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a52:	7139                	add	sp,sp,-64
 a54:	fc06                	sd	ra,56(sp)
 a56:	f822                	sd	s0,48(sp)
 a58:	f426                	sd	s1,40(sp)
 a5a:	f04a                	sd	s2,32(sp)
 a5c:	ec4e                	sd	s3,24(sp)
 a5e:	e852                	sd	s4,16(sp)
 a60:	e456                	sd	s5,8(sp)
 a62:	e05a                	sd	s6,0(sp)
 a64:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a66:	02051493          	sll	s1,a0,0x20
 a6a:	9081                	srl	s1,s1,0x20
 a6c:	04bd                	add	s1,s1,15
 a6e:	8091                	srl	s1,s1,0x4
 a70:	0014899b          	addw	s3,s1,1
 a74:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a76:	00000517          	auipc	a0,0x0
 a7a:	58a53503          	ld	a0,1418(a0) # 1000 <freep>
 a7e:	c515                	beqz	a0,aaa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a80:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a82:	4798                	lw	a4,8(a5)
 a84:	02977f63          	bgeu	a4,s1,ac2 <malloc+0x70>
  if(nu < 4096)
 a88:	8a4e                	mv	s4,s3
 a8a:	0009871b          	sext.w	a4,s3
 a8e:	6685                	lui	a3,0x1
 a90:	00d77363          	bgeu	a4,a3,a96 <malloc+0x44>
 a94:	6a05                	lui	s4,0x1
 a96:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a9a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a9e:	00000917          	auipc	s2,0x0
 aa2:	56290913          	add	s2,s2,1378 # 1000 <freep>
  if(p == (char*)-1)
 aa6:	5afd                	li	s5,-1
 aa8:	a895                	j	b1c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 aaa:	00001797          	auipc	a5,0x1
 aae:	96678793          	add	a5,a5,-1690 # 1410 <base>
 ab2:	00000717          	auipc	a4,0x0
 ab6:	54f73723          	sd	a5,1358(a4) # 1000 <freep>
 aba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 abc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ac0:	b7e1                	j	a88 <malloc+0x36>
      if(p->s.size == nunits)
 ac2:	02e48c63          	beq	s1,a4,afa <malloc+0xa8>
        p->s.size -= nunits;
 ac6:	4137073b          	subw	a4,a4,s3
 aca:	c798                	sw	a4,8(a5)
        p += p->s.size;
 acc:	02071693          	sll	a3,a4,0x20
 ad0:	01c6d713          	srl	a4,a3,0x1c
 ad4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ad6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ada:	00000717          	auipc	a4,0x0
 ade:	52a73323          	sd	a0,1318(a4) # 1000 <freep>
      return (void*)(p + 1);
 ae2:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ae6:	70e2                	ld	ra,56(sp)
 ae8:	7442                	ld	s0,48(sp)
 aea:	74a2                	ld	s1,40(sp)
 aec:	7902                	ld	s2,32(sp)
 aee:	69e2                	ld	s3,24(sp)
 af0:	6a42                	ld	s4,16(sp)
 af2:	6aa2                	ld	s5,8(sp)
 af4:	6b02                	ld	s6,0(sp)
 af6:	6121                	add	sp,sp,64
 af8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 afa:	6398                	ld	a4,0(a5)
 afc:	e118                	sd	a4,0(a0)
 afe:	bff1                	j	ada <malloc+0x88>
  hp->s.size = nu;
 b00:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b04:	0541                	add	a0,a0,16
 b06:	00000097          	auipc	ra,0x0
 b0a:	eca080e7          	jalr	-310(ra) # 9d0 <free>
  return freep;
 b0e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b12:	d971                	beqz	a0,ae6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b16:	4798                	lw	a4,8(a5)
 b18:	fa9775e3          	bgeu	a4,s1,ac2 <malloc+0x70>
    if(p == freep)
 b1c:	00093703          	ld	a4,0(s2)
 b20:	853e                	mv	a0,a5
 b22:	fef719e3          	bne	a4,a5,b14 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b26:	8552                	mv	a0,s4
 b28:	00000097          	auipc	ra,0x0
 b2c:	a90080e7          	jalr	-1392(ra) # 5b8 <sbrk>
  if(p == (char*)-1)
 b30:	fd5518e3          	bne	a0,s5,b00 <malloc+0xae>
        return 0;
 b34:	4501                	li	a0,0
 b36:	bf45                	j	ae6 <malloc+0x94>
