
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

/* what if you pass ridiculous string pointers to system calls? */
void
copyinstr1(char *s)
{
       0:	711d                	add	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00008797          	auipc	a5,0x8
      12:	63278793          	add	a5,a5,1586 # 8640 <malloc+0x2484>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	add	s1,s0,-88
      38:	fd040993          	add	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	00006097          	auipc	ra,0x6
      4a:	c94080e7          	jalr	-876(ra) # 5cda <open>
    if(fd >= 0){
      4e:	00055c63          	bgez	a0,66 <copyinstr1+0x66>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      52:	04a1                	add	s1,s1,8
      54:	ff3494e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	6125                	add	sp,sp,96
      64:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      66:	862a                	mv	a2,a0
      68:	85ca                	mv	a1,s2
      6a:	00006517          	auipc	a0,0x6
      6e:	24650513          	add	a0,a0,582 # 62b0 <malloc+0xf4>
      72:	00006097          	auipc	ra,0x6
      76:	092080e7          	jalr	146(ra) # 6104 <printf>
      exit(1);
      7a:	4505                	li	a0,1
      7c:	00006097          	auipc	ra,0x6
      80:	c1e080e7          	jalr	-994(ra) # 5c9a <exit>

0000000000000084 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      84:	0000a797          	auipc	a5,0xa
      88:	4e478793          	add	a5,a5,1252 # a568 <uninit>
      8c:	0000d697          	auipc	a3,0xd
      90:	bec68693          	add	a3,a3,-1044 # cc78 <buf>
    if(uninit[i] != '\0'){
      94:	0007c703          	lbu	a4,0(a5)
      98:	e709                	bnez	a4,a2 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      9a:	0785                	add	a5,a5,1
      9c:	fed79ce3          	bne	a5,a3,94 <bsstest+0x10>
      a0:	8082                	ret
{
      a2:	1141                	add	sp,sp,-16
      a4:	e406                	sd	ra,8(sp)
      a6:	e022                	sd	s0,0(sp)
      a8:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      aa:	85aa                	mv	a1,a0
      ac:	00006517          	auipc	a0,0x6
      b0:	22450513          	add	a0,a0,548 # 62d0 <malloc+0x114>
      b4:	00006097          	auipc	ra,0x6
      b8:	050080e7          	jalr	80(ra) # 6104 <printf>
      exit(1);
      bc:	4505                	li	a0,1
      be:	00006097          	auipc	ra,0x6
      c2:	bdc080e7          	jalr	-1060(ra) # 5c9a <exit>

00000000000000c6 <opentest>:
{
      c6:	1101                	add	sp,sp,-32
      c8:	ec06                	sd	ra,24(sp)
      ca:	e822                	sd	s0,16(sp)
      cc:	e426                	sd	s1,8(sp)
      ce:	1000                	add	s0,sp,32
      d0:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      d2:	4581                	li	a1,0
      d4:	00006517          	auipc	a0,0x6
      d8:	21450513          	add	a0,a0,532 # 62e8 <malloc+0x12c>
      dc:	00006097          	auipc	ra,0x6
      e0:	bfe080e7          	jalr	-1026(ra) # 5cda <open>
  if(fd < 0){
      e4:	02054663          	bltz	a0,110 <opentest+0x4a>
  close(fd);
      e8:	00006097          	auipc	ra,0x6
      ec:	bda080e7          	jalr	-1062(ra) # 5cc2 <close>
  fd = open("doesnotexist", 0);
      f0:	4581                	li	a1,0
      f2:	00006517          	auipc	a0,0x6
      f6:	21650513          	add	a0,a0,534 # 6308 <malloc+0x14c>
      fa:	00006097          	auipc	ra,0x6
      fe:	be0080e7          	jalr	-1056(ra) # 5cda <open>
  if(fd >= 0){
     102:	02055563          	bgez	a0,12c <opentest+0x66>
}
     106:	60e2                	ld	ra,24(sp)
     108:	6442                	ld	s0,16(sp)
     10a:	64a2                	ld	s1,8(sp)
     10c:	6105                	add	sp,sp,32
     10e:	8082                	ret
    printf("%s: open echo failed!\n", s);
     110:	85a6                	mv	a1,s1
     112:	00006517          	auipc	a0,0x6
     116:	1de50513          	add	a0,a0,478 # 62f0 <malloc+0x134>
     11a:	00006097          	auipc	ra,0x6
     11e:	fea080e7          	jalr	-22(ra) # 6104 <printf>
    exit(1);
     122:	4505                	li	a0,1
     124:	00006097          	auipc	ra,0x6
     128:	b76080e7          	jalr	-1162(ra) # 5c9a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     12c:	85a6                	mv	a1,s1
     12e:	00006517          	auipc	a0,0x6
     132:	1ea50513          	add	a0,a0,490 # 6318 <malloc+0x15c>
     136:	00006097          	auipc	ra,0x6
     13a:	fce080e7          	jalr	-50(ra) # 6104 <printf>
    exit(1);
     13e:	4505                	li	a0,1
     140:	00006097          	auipc	ra,0x6
     144:	b5a080e7          	jalr	-1190(ra) # 5c9a <exit>

0000000000000148 <truncate2>:
{
     148:	7179                	add	sp,sp,-48
     14a:	f406                	sd	ra,40(sp)
     14c:	f022                	sd	s0,32(sp)
     14e:	ec26                	sd	s1,24(sp)
     150:	e84a                	sd	s2,16(sp)
     152:	e44e                	sd	s3,8(sp)
     154:	1800                	add	s0,sp,48
     156:	89aa                	mv	s3,a0
  unlink("truncfile");
     158:	00006517          	auipc	a0,0x6
     15c:	1e850513          	add	a0,a0,488 # 6340 <malloc+0x184>
     160:	00006097          	auipc	ra,0x6
     164:	b8a080e7          	jalr	-1142(ra) # 5cea <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     168:	60100593          	li	a1,1537
     16c:	00006517          	auipc	a0,0x6
     170:	1d450513          	add	a0,a0,468 # 6340 <malloc+0x184>
     174:	00006097          	auipc	ra,0x6
     178:	b66080e7          	jalr	-1178(ra) # 5cda <open>
     17c:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     17e:	4611                	li	a2,4
     180:	00006597          	auipc	a1,0x6
     184:	1d058593          	add	a1,a1,464 # 6350 <malloc+0x194>
     188:	00006097          	auipc	ra,0x6
     18c:	b32080e7          	jalr	-1230(ra) # 5cba <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     190:	40100593          	li	a1,1025
     194:	00006517          	auipc	a0,0x6
     198:	1ac50513          	add	a0,a0,428 # 6340 <malloc+0x184>
     19c:	00006097          	auipc	ra,0x6
     1a0:	b3e080e7          	jalr	-1218(ra) # 5cda <open>
     1a4:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     1a6:	4605                	li	a2,1
     1a8:	00006597          	auipc	a1,0x6
     1ac:	1b058593          	add	a1,a1,432 # 6358 <malloc+0x19c>
     1b0:	8526                	mv	a0,s1
     1b2:	00006097          	auipc	ra,0x6
     1b6:	b08080e7          	jalr	-1272(ra) # 5cba <write>
  if(n != -1){
     1ba:	57fd                	li	a5,-1
     1bc:	02f51b63          	bne	a0,a5,1f2 <truncate2+0xaa>
  unlink("truncfile");
     1c0:	00006517          	auipc	a0,0x6
     1c4:	18050513          	add	a0,a0,384 # 6340 <malloc+0x184>
     1c8:	00006097          	auipc	ra,0x6
     1cc:	b22080e7          	jalr	-1246(ra) # 5cea <unlink>
  close(fd1);
     1d0:	8526                	mv	a0,s1
     1d2:	00006097          	auipc	ra,0x6
     1d6:	af0080e7          	jalr	-1296(ra) # 5cc2 <close>
  close(fd2);
     1da:	854a                	mv	a0,s2
     1dc:	00006097          	auipc	ra,0x6
     1e0:	ae6080e7          	jalr	-1306(ra) # 5cc2 <close>
}
     1e4:	70a2                	ld	ra,40(sp)
     1e6:	7402                	ld	s0,32(sp)
     1e8:	64e2                	ld	s1,24(sp)
     1ea:	6942                	ld	s2,16(sp)
     1ec:	69a2                	ld	s3,8(sp)
     1ee:	6145                	add	sp,sp,48
     1f0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1f2:	862a                	mv	a2,a0
     1f4:	85ce                	mv	a1,s3
     1f6:	00006517          	auipc	a0,0x6
     1fa:	16a50513          	add	a0,a0,362 # 6360 <malloc+0x1a4>
     1fe:	00006097          	auipc	ra,0x6
     202:	f06080e7          	jalr	-250(ra) # 6104 <printf>
    exit(1);
     206:	4505                	li	a0,1
     208:	00006097          	auipc	ra,0x6
     20c:	a92080e7          	jalr	-1390(ra) # 5c9a <exit>

0000000000000210 <createtest>:
{
     210:	7179                	add	sp,sp,-48
     212:	f406                	sd	ra,40(sp)
     214:	f022                	sd	s0,32(sp)
     216:	ec26                	sd	s1,24(sp)
     218:	e84a                	sd	s2,16(sp)
     21a:	1800                	add	s0,sp,48
  name[0] = 'a';
     21c:	06100793          	li	a5,97
     220:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     224:	fc040d23          	sb	zero,-38(s0)
     228:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     22c:	06400913          	li	s2,100
    name[1] = '0' + i;
     230:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     234:	20200593          	li	a1,514
     238:	fd840513          	add	a0,s0,-40
     23c:	00006097          	auipc	ra,0x6
     240:	a9e080e7          	jalr	-1378(ra) # 5cda <open>
    close(fd);
     244:	00006097          	auipc	ra,0x6
     248:	a7e080e7          	jalr	-1410(ra) # 5cc2 <close>
  for(i = 0; i < N; i++){
     24c:	2485                	addw	s1,s1,1
     24e:	0ff4f493          	zext.b	s1,s1
     252:	fd249fe3          	bne	s1,s2,230 <createtest+0x20>
  name[0] = 'a';
     256:	06100793          	li	a5,97
     25a:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     25e:	fc040d23          	sb	zero,-38(s0)
     262:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     266:	06400913          	li	s2,100
    name[1] = '0' + i;
     26a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     26e:	fd840513          	add	a0,s0,-40
     272:	00006097          	auipc	ra,0x6
     276:	a78080e7          	jalr	-1416(ra) # 5cea <unlink>
  for(i = 0; i < N; i++){
     27a:	2485                	addw	s1,s1,1
     27c:	0ff4f493          	zext.b	s1,s1
     280:	ff2495e3          	bne	s1,s2,26a <createtest+0x5a>
}
     284:	70a2                	ld	ra,40(sp)
     286:	7402                	ld	s0,32(sp)
     288:	64e2                	ld	s1,24(sp)
     28a:	6942                	ld	s2,16(sp)
     28c:	6145                	add	sp,sp,48
     28e:	8082                	ret

0000000000000290 <bigwrite>:
{
     290:	715d                	add	sp,sp,-80
     292:	e486                	sd	ra,72(sp)
     294:	e0a2                	sd	s0,64(sp)
     296:	fc26                	sd	s1,56(sp)
     298:	f84a                	sd	s2,48(sp)
     29a:	f44e                	sd	s3,40(sp)
     29c:	f052                	sd	s4,32(sp)
     29e:	ec56                	sd	s5,24(sp)
     2a0:	e85a                	sd	s6,16(sp)
     2a2:	e45e                	sd	s7,8(sp)
     2a4:	0880                	add	s0,sp,80
     2a6:	8baa                	mv	s7,a0
  unlink("bigwrite");
     2a8:	00006517          	auipc	a0,0x6
     2ac:	0e050513          	add	a0,a0,224 # 6388 <malloc+0x1cc>
     2b0:	00006097          	auipc	ra,0x6
     2b4:	a3a080e7          	jalr	-1478(ra) # 5cea <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b8:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2bc:	00006a97          	auipc	s5,0x6
     2c0:	0cca8a93          	add	s5,s5,204 # 6388 <malloc+0x1cc>
      int cc = write(fd, buf, sz);
     2c4:	0000da17          	auipc	s4,0xd
     2c8:	9b4a0a13          	add	s4,s4,-1612 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2cc:	6b0d                	lui	s6,0x3
     2ce:	1c9b0b13          	add	s6,s6,457 # 31c9 <diskfull+0x49>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2d2:	20200593          	li	a1,514
     2d6:	8556                	mv	a0,s5
     2d8:	00006097          	auipc	ra,0x6
     2dc:	a02080e7          	jalr	-1534(ra) # 5cda <open>
     2e0:	892a                	mv	s2,a0
    if(fd < 0){
     2e2:	04054d63          	bltz	a0,33c <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2e6:	8626                	mv	a2,s1
     2e8:	85d2                	mv	a1,s4
     2ea:	00006097          	auipc	ra,0x6
     2ee:	9d0080e7          	jalr	-1584(ra) # 5cba <write>
     2f2:	89aa                	mv	s3,a0
      if(cc != sz){
     2f4:	06a49263          	bne	s1,a0,358 <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2f8:	8626                	mv	a2,s1
     2fa:	85d2                	mv	a1,s4
     2fc:	854a                	mv	a0,s2
     2fe:	00006097          	auipc	ra,0x6
     302:	9bc080e7          	jalr	-1604(ra) # 5cba <write>
      if(cc != sz){
     306:	04951a63          	bne	a0,s1,35a <bigwrite+0xca>
    close(fd);
     30a:	854a                	mv	a0,s2
     30c:	00006097          	auipc	ra,0x6
     310:	9b6080e7          	jalr	-1610(ra) # 5cc2 <close>
    unlink("bigwrite");
     314:	8556                	mv	a0,s5
     316:	00006097          	auipc	ra,0x6
     31a:	9d4080e7          	jalr	-1580(ra) # 5cea <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     31e:	1d74849b          	addw	s1,s1,471
     322:	fb6498e3          	bne	s1,s6,2d2 <bigwrite+0x42>
}
     326:	60a6                	ld	ra,72(sp)
     328:	6406                	ld	s0,64(sp)
     32a:	74e2                	ld	s1,56(sp)
     32c:	7942                	ld	s2,48(sp)
     32e:	79a2                	ld	s3,40(sp)
     330:	7a02                	ld	s4,32(sp)
     332:	6ae2                	ld	s5,24(sp)
     334:	6b42                	ld	s6,16(sp)
     336:	6ba2                	ld	s7,8(sp)
     338:	6161                	add	sp,sp,80
     33a:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     33c:	85de                	mv	a1,s7
     33e:	00006517          	auipc	a0,0x6
     342:	05a50513          	add	a0,a0,90 # 6398 <malloc+0x1dc>
     346:	00006097          	auipc	ra,0x6
     34a:	dbe080e7          	jalr	-578(ra) # 6104 <printf>
      exit(1);
     34e:	4505                	li	a0,1
     350:	00006097          	auipc	ra,0x6
     354:	94a080e7          	jalr	-1718(ra) # 5c9a <exit>
      if(cc != sz){
     358:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     35a:	86aa                	mv	a3,a0
     35c:	864e                	mv	a2,s3
     35e:	85de                	mv	a1,s7
     360:	00006517          	auipc	a0,0x6
     364:	05850513          	add	a0,a0,88 # 63b8 <malloc+0x1fc>
     368:	00006097          	auipc	ra,0x6
     36c:	d9c080e7          	jalr	-612(ra) # 6104 <printf>
        exit(1);
     370:	4505                	li	a0,1
     372:	00006097          	auipc	ra,0x6
     376:	928080e7          	jalr	-1752(ra) # 5c9a <exit>

000000000000037a <badwrite>:
/* file is deleted? if the kernel has this bug, it will panic: balloc: */
/* out of blocks. assumed_free may need to be raised to be more than */
/* the number of free blocks. this test takes a long time. */
void
badwrite(char *s)
{
     37a:	7179                	add	sp,sp,-48
     37c:	f406                	sd	ra,40(sp)
     37e:	f022                	sd	s0,32(sp)
     380:	ec26                	sd	s1,24(sp)
     382:	e84a                	sd	s2,16(sp)
     384:	e44e                	sd	s3,8(sp)
     386:	e052                	sd	s4,0(sp)
     388:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     38a:	00006517          	auipc	a0,0x6
     38e:	04650513          	add	a0,a0,70 # 63d0 <malloc+0x214>
     392:	00006097          	auipc	ra,0x6
     396:	958080e7          	jalr	-1704(ra) # 5cea <unlink>
     39a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     39e:	00006997          	auipc	s3,0x6
     3a2:	03298993          	add	s3,s3,50 # 63d0 <malloc+0x214>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     3a6:	5a7d                	li	s4,-1
     3a8:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ac:	20100593          	li	a1,513
     3b0:	854e                	mv	a0,s3
     3b2:	00006097          	auipc	ra,0x6
     3b6:	928080e7          	jalr	-1752(ra) # 5cda <open>
     3ba:	84aa                	mv	s1,a0
    if(fd < 0){
     3bc:	06054b63          	bltz	a0,432 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     3c0:	4605                	li	a2,1
     3c2:	85d2                	mv	a1,s4
     3c4:	00006097          	auipc	ra,0x6
     3c8:	8f6080e7          	jalr	-1802(ra) # 5cba <write>
    close(fd);
     3cc:	8526                	mv	a0,s1
     3ce:	00006097          	auipc	ra,0x6
     3d2:	8f4080e7          	jalr	-1804(ra) # 5cc2 <close>
    unlink("junk");
     3d6:	854e                	mv	a0,s3
     3d8:	00006097          	auipc	ra,0x6
     3dc:	912080e7          	jalr	-1774(ra) # 5cea <unlink>
  for(int i = 0; i < assumed_free; i++){
     3e0:	397d                	addw	s2,s2,-1
     3e2:	fc0915e3          	bnez	s2,3ac <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3e6:	20100593          	li	a1,513
     3ea:	00006517          	auipc	a0,0x6
     3ee:	fe650513          	add	a0,a0,-26 # 63d0 <malloc+0x214>
     3f2:	00006097          	auipc	ra,0x6
     3f6:	8e8080e7          	jalr	-1816(ra) # 5cda <open>
     3fa:	84aa                	mv	s1,a0
  if(fd < 0){
     3fc:	04054863          	bltz	a0,44c <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     400:	4605                	li	a2,1
     402:	00006597          	auipc	a1,0x6
     406:	f5658593          	add	a1,a1,-170 # 6358 <malloc+0x19c>
     40a:	00006097          	auipc	ra,0x6
     40e:	8b0080e7          	jalr	-1872(ra) # 5cba <write>
     412:	4785                	li	a5,1
     414:	04f50963          	beq	a0,a5,466 <badwrite+0xec>
    printf("write failed\n");
     418:	00006517          	auipc	a0,0x6
     41c:	fd850513          	add	a0,a0,-40 # 63f0 <malloc+0x234>
     420:	00006097          	auipc	ra,0x6
     424:	ce4080e7          	jalr	-796(ra) # 6104 <printf>
    exit(1);
     428:	4505                	li	a0,1
     42a:	00006097          	auipc	ra,0x6
     42e:	870080e7          	jalr	-1936(ra) # 5c9a <exit>
      printf("open junk failed\n");
     432:	00006517          	auipc	a0,0x6
     436:	fa650513          	add	a0,a0,-90 # 63d8 <malloc+0x21c>
     43a:	00006097          	auipc	ra,0x6
     43e:	cca080e7          	jalr	-822(ra) # 6104 <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00006097          	auipc	ra,0x6
     448:	856080e7          	jalr	-1962(ra) # 5c9a <exit>
    printf("open junk failed\n");
     44c:	00006517          	auipc	a0,0x6
     450:	f8c50513          	add	a0,a0,-116 # 63d8 <malloc+0x21c>
     454:	00006097          	auipc	ra,0x6
     458:	cb0080e7          	jalr	-848(ra) # 6104 <printf>
    exit(1);
     45c:	4505                	li	a0,1
     45e:	00006097          	auipc	ra,0x6
     462:	83c080e7          	jalr	-1988(ra) # 5c9a <exit>
  }
  close(fd);
     466:	8526                	mv	a0,s1
     468:	00006097          	auipc	ra,0x6
     46c:	85a080e7          	jalr	-1958(ra) # 5cc2 <close>
  unlink("junk");
     470:	00006517          	auipc	a0,0x6
     474:	f6050513          	add	a0,a0,-160 # 63d0 <malloc+0x214>
     478:	00006097          	auipc	ra,0x6
     47c:	872080e7          	jalr	-1934(ra) # 5cea <unlink>

  exit(0);
     480:	4501                	li	a0,0
     482:	00006097          	auipc	ra,0x6
     486:	818080e7          	jalr	-2024(ra) # 5c9a <exit>

000000000000048a <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     48a:	715d                	add	sp,sp,-80
     48c:	e486                	sd	ra,72(sp)
     48e:	e0a2                	sd	s0,64(sp)
     490:	fc26                	sd	s1,56(sp)
     492:	f84a                	sd	s2,48(sp)
     494:	f44e                	sd	s3,40(sp)
     496:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     498:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     49a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     49e:	40000993          	li	s3,1024
    name[0] = 'z';
     4a2:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4a6:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4aa:	41f4d71b          	sraw	a4,s1,0x1f
     4ae:	01b7571b          	srlw	a4,a4,0x1b
     4b2:	009707bb          	addw	a5,a4,s1
     4b6:	4057d69b          	sraw	a3,a5,0x5
     4ba:	0306869b          	addw	a3,a3,48
     4be:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4c2:	8bfd                	and	a5,a5,31
     4c4:	9f99                	subw	a5,a5,a4
     4c6:	0307879b          	addw	a5,a5,48
     4ca:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4ce:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4d2:	fb040513          	add	a0,s0,-80
     4d6:	00006097          	auipc	ra,0x6
     4da:	814080e7          	jalr	-2028(ra) # 5cea <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4de:	60200593          	li	a1,1538
     4e2:	fb040513          	add	a0,s0,-80
     4e6:	00005097          	auipc	ra,0x5
     4ea:	7f4080e7          	jalr	2036(ra) # 5cda <open>
    if(fd < 0){
     4ee:	00054963          	bltz	a0,500 <outofinodes+0x76>
      /* failure is eventually expected. */
      break;
    }
    close(fd);
     4f2:	00005097          	auipc	ra,0x5
     4f6:	7d0080e7          	jalr	2000(ra) # 5cc2 <close>
  for(int i = 0; i < nzz; i++){
     4fa:	2485                	addw	s1,s1,1
     4fc:	fb3493e3          	bne	s1,s3,4a2 <outofinodes+0x18>
     500:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     502:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     506:	40000993          	li	s3,1024
    name[0] = 'z';
     50a:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     50e:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     512:	41f4d71b          	sraw	a4,s1,0x1f
     516:	01b7571b          	srlw	a4,a4,0x1b
     51a:	009707bb          	addw	a5,a4,s1
     51e:	4057d69b          	sraw	a3,a5,0x5
     522:	0306869b          	addw	a3,a3,48
     526:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     52a:	8bfd                	and	a5,a5,31
     52c:	9f99                	subw	a5,a5,a4
     52e:	0307879b          	addw	a5,a5,48
     532:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     536:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     53a:	fb040513          	add	a0,s0,-80
     53e:	00005097          	auipc	ra,0x5
     542:	7ac080e7          	jalr	1964(ra) # 5cea <unlink>
  for(int i = 0; i < nzz; i++){
     546:	2485                	addw	s1,s1,1
     548:	fd3491e3          	bne	s1,s3,50a <outofinodes+0x80>
  }
}
     54c:	60a6                	ld	ra,72(sp)
     54e:	6406                	ld	s0,64(sp)
     550:	74e2                	ld	s1,56(sp)
     552:	7942                	ld	s2,48(sp)
     554:	79a2                	ld	s3,40(sp)
     556:	6161                	add	sp,sp,80
     558:	8082                	ret

000000000000055a <copyin>:
{
     55a:	7159                	add	sp,sp,-112
     55c:	f486                	sd	ra,104(sp)
     55e:	f0a2                	sd	s0,96(sp)
     560:	eca6                	sd	s1,88(sp)
     562:	e8ca                	sd	s2,80(sp)
     564:	e4ce                	sd	s3,72(sp)
     566:	e0d2                	sd	s4,64(sp)
     568:	fc56                	sd	s5,56(sp)
     56a:	1880                	add	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     56c:	00008797          	auipc	a5,0x8
     570:	0d478793          	add	a5,a5,212 # 8640 <malloc+0x2484>
     574:	638c                	ld	a1,0(a5)
     576:	6790                	ld	a2,8(a5)
     578:	6b94                	ld	a3,16(a5)
     57a:	6f98                	ld	a4,24(a5)
     57c:	739c                	ld	a5,32(a5)
     57e:	f8b43c23          	sd	a1,-104(s0)
     582:	fac43023          	sd	a2,-96(s0)
     586:	fad43423          	sd	a3,-88(s0)
     58a:	fae43823          	sd	a4,-80(s0)
     58e:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     592:	f9840913          	add	s2,s0,-104
     596:	fc040a93          	add	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     59a:	00006a17          	auipc	s4,0x6
     59e:	e66a0a13          	add	s4,s4,-410 # 6400 <malloc+0x244>
    uint64 addr = addrs[ai];
     5a2:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5a6:	20100593          	li	a1,513
     5aa:	8552                	mv	a0,s4
     5ac:	00005097          	auipc	ra,0x5
     5b0:	72e080e7          	jalr	1838(ra) # 5cda <open>
     5b4:	84aa                	mv	s1,a0
    if(fd < 0){
     5b6:	08054763          	bltz	a0,644 <copyin+0xea>
    int n = write(fd, (void*)addr, 8192);
     5ba:	6609                	lui	a2,0x2
     5bc:	85ce                	mv	a1,s3
     5be:	00005097          	auipc	ra,0x5
     5c2:	6fc080e7          	jalr	1788(ra) # 5cba <write>
    if(n >= 0){
     5c6:	08055c63          	bgez	a0,65e <copyin+0x104>
    close(fd);
     5ca:	8526                	mv	a0,s1
     5cc:	00005097          	auipc	ra,0x5
     5d0:	6f6080e7          	jalr	1782(ra) # 5cc2 <close>
    unlink("copyin1");
     5d4:	8552                	mv	a0,s4
     5d6:	00005097          	auipc	ra,0x5
     5da:	714080e7          	jalr	1812(ra) # 5cea <unlink>
    n = write(1, (char*)addr, 8192);
     5de:	6609                	lui	a2,0x2
     5e0:	85ce                	mv	a1,s3
     5e2:	4505                	li	a0,1
     5e4:	00005097          	auipc	ra,0x5
     5e8:	6d6080e7          	jalr	1750(ra) # 5cba <write>
    if(n > 0){
     5ec:	08a04863          	bgtz	a0,67c <copyin+0x122>
    if(pipe(fds) < 0){
     5f0:	f9040513          	add	a0,s0,-112
     5f4:	00005097          	auipc	ra,0x5
     5f8:	6b6080e7          	jalr	1718(ra) # 5caa <pipe>
     5fc:	08054f63          	bltz	a0,69a <copyin+0x140>
    n = write(fds[1], (char*)addr, 8192);
     600:	6609                	lui	a2,0x2
     602:	85ce                	mv	a1,s3
     604:	f9442503          	lw	a0,-108(s0)
     608:	00005097          	auipc	ra,0x5
     60c:	6b2080e7          	jalr	1714(ra) # 5cba <write>
    if(n > 0){
     610:	0aa04263          	bgtz	a0,6b4 <copyin+0x15a>
    close(fds[0]);
     614:	f9042503          	lw	a0,-112(s0)
     618:	00005097          	auipc	ra,0x5
     61c:	6aa080e7          	jalr	1706(ra) # 5cc2 <close>
    close(fds[1]);
     620:	f9442503          	lw	a0,-108(s0)
     624:	00005097          	auipc	ra,0x5
     628:	69e080e7          	jalr	1694(ra) # 5cc2 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     62c:	0921                	add	s2,s2,8
     62e:	f7591ae3          	bne	s2,s5,5a2 <copyin+0x48>
}
     632:	70a6                	ld	ra,104(sp)
     634:	7406                	ld	s0,96(sp)
     636:	64e6                	ld	s1,88(sp)
     638:	6946                	ld	s2,80(sp)
     63a:	69a6                	ld	s3,72(sp)
     63c:	6a06                	ld	s4,64(sp)
     63e:	7ae2                	ld	s5,56(sp)
     640:	6165                	add	sp,sp,112
     642:	8082                	ret
      printf("open(copyin1) failed\n");
     644:	00006517          	auipc	a0,0x6
     648:	dc450513          	add	a0,a0,-572 # 6408 <malloc+0x24c>
     64c:	00006097          	auipc	ra,0x6
     650:	ab8080e7          	jalr	-1352(ra) # 6104 <printf>
      exit(1);
     654:	4505                	li	a0,1
     656:	00005097          	auipc	ra,0x5
     65a:	644080e7          	jalr	1604(ra) # 5c9a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     65e:	862a                	mv	a2,a0
     660:	85ce                	mv	a1,s3
     662:	00006517          	auipc	a0,0x6
     666:	dbe50513          	add	a0,a0,-578 # 6420 <malloc+0x264>
     66a:	00006097          	auipc	ra,0x6
     66e:	a9a080e7          	jalr	-1382(ra) # 6104 <printf>
      exit(1);
     672:	4505                	li	a0,1
     674:	00005097          	auipc	ra,0x5
     678:	626080e7          	jalr	1574(ra) # 5c9a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     67c:	862a                	mv	a2,a0
     67e:	85ce                	mv	a1,s3
     680:	00006517          	auipc	a0,0x6
     684:	dd050513          	add	a0,a0,-560 # 6450 <malloc+0x294>
     688:	00006097          	auipc	ra,0x6
     68c:	a7c080e7          	jalr	-1412(ra) # 6104 <printf>
      exit(1);
     690:	4505                	li	a0,1
     692:	00005097          	auipc	ra,0x5
     696:	608080e7          	jalr	1544(ra) # 5c9a <exit>
      printf("pipe() failed\n");
     69a:	00006517          	auipc	a0,0x6
     69e:	de650513          	add	a0,a0,-538 # 6480 <malloc+0x2c4>
     6a2:	00006097          	auipc	ra,0x6
     6a6:	a62080e7          	jalr	-1438(ra) # 6104 <printf>
      exit(1);
     6aa:	4505                	li	a0,1
     6ac:	00005097          	auipc	ra,0x5
     6b0:	5ee080e7          	jalr	1518(ra) # 5c9a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6b4:	862a                	mv	a2,a0
     6b6:	85ce                	mv	a1,s3
     6b8:	00006517          	auipc	a0,0x6
     6bc:	dd850513          	add	a0,a0,-552 # 6490 <malloc+0x2d4>
     6c0:	00006097          	auipc	ra,0x6
     6c4:	a44080e7          	jalr	-1468(ra) # 6104 <printf>
      exit(1);
     6c8:	4505                	li	a0,1
     6ca:	00005097          	auipc	ra,0x5
     6ce:	5d0080e7          	jalr	1488(ra) # 5c9a <exit>

00000000000006d2 <copyout>:
{
     6d2:	7119                	add	sp,sp,-128
     6d4:	fc86                	sd	ra,120(sp)
     6d6:	f8a2                	sd	s0,112(sp)
     6d8:	f4a6                	sd	s1,104(sp)
     6da:	f0ca                	sd	s2,96(sp)
     6dc:	ecce                	sd	s3,88(sp)
     6de:	e8d2                	sd	s4,80(sp)
     6e0:	e4d6                	sd	s5,72(sp)
     6e2:	e0da                	sd	s6,64(sp)
     6e4:	0100                	add	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     6e6:	00008797          	auipc	a5,0x8
     6ea:	f5a78793          	add	a5,a5,-166 # 8640 <malloc+0x2484>
     6ee:	7788                	ld	a0,40(a5)
     6f0:	7b8c                	ld	a1,48(a5)
     6f2:	7f90                	ld	a2,56(a5)
     6f4:	63b4                	ld	a3,64(a5)
     6f6:	67b8                	ld	a4,72(a5)
     6f8:	6bbc                	ld	a5,80(a5)
     6fa:	f8a43823          	sd	a0,-112(s0)
     6fe:	f8b43c23          	sd	a1,-104(s0)
     702:	fac43023          	sd	a2,-96(s0)
     706:	fad43423          	sd	a3,-88(s0)
     70a:	fae43823          	sd	a4,-80(s0)
     70e:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     712:	f9040913          	add	s2,s0,-112
     716:	fc040b13          	add	s6,s0,-64
    int fd = open("README", 0);
     71a:	00006a17          	auipc	s4,0x6
     71e:	da6a0a13          	add	s4,s4,-602 # 64c0 <malloc+0x304>
    n = write(fds[1], "x", 1);
     722:	00006a97          	auipc	s5,0x6
     726:	c36a8a93          	add	s5,s5,-970 # 6358 <malloc+0x19c>
    uint64 addr = addrs[ai];
     72a:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     72e:	4581                	li	a1,0
     730:	8552                	mv	a0,s4
     732:	00005097          	auipc	ra,0x5
     736:	5a8080e7          	jalr	1448(ra) # 5cda <open>
     73a:	84aa                	mv	s1,a0
    if(fd < 0){
     73c:	08054563          	bltz	a0,7c6 <copyout+0xf4>
    int n = read(fd, (void*)addr, 8192);
     740:	6609                	lui	a2,0x2
     742:	85ce                	mv	a1,s3
     744:	00005097          	auipc	ra,0x5
     748:	56e080e7          	jalr	1390(ra) # 5cb2 <read>
    if(n > 0){
     74c:	08a04a63          	bgtz	a0,7e0 <copyout+0x10e>
    close(fd);
     750:	8526                	mv	a0,s1
     752:	00005097          	auipc	ra,0x5
     756:	570080e7          	jalr	1392(ra) # 5cc2 <close>
    if(pipe(fds) < 0){
     75a:	f8840513          	add	a0,s0,-120
     75e:	00005097          	auipc	ra,0x5
     762:	54c080e7          	jalr	1356(ra) # 5caa <pipe>
     766:	08054c63          	bltz	a0,7fe <copyout+0x12c>
    n = write(fds[1], "x", 1);
     76a:	4605                	li	a2,1
     76c:	85d6                	mv	a1,s5
     76e:	f8c42503          	lw	a0,-116(s0)
     772:	00005097          	auipc	ra,0x5
     776:	548080e7          	jalr	1352(ra) # 5cba <write>
    if(n != 1){
     77a:	4785                	li	a5,1
     77c:	08f51e63          	bne	a0,a5,818 <copyout+0x146>
    n = read(fds[0], (void*)addr, 8192);
     780:	6609                	lui	a2,0x2
     782:	85ce                	mv	a1,s3
     784:	f8842503          	lw	a0,-120(s0)
     788:	00005097          	auipc	ra,0x5
     78c:	52a080e7          	jalr	1322(ra) # 5cb2 <read>
    if(n > 0){
     790:	0aa04163          	bgtz	a0,832 <copyout+0x160>
    close(fds[0]);
     794:	f8842503          	lw	a0,-120(s0)
     798:	00005097          	auipc	ra,0x5
     79c:	52a080e7          	jalr	1322(ra) # 5cc2 <close>
    close(fds[1]);
     7a0:	f8c42503          	lw	a0,-116(s0)
     7a4:	00005097          	auipc	ra,0x5
     7a8:	51e080e7          	jalr	1310(ra) # 5cc2 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     7ac:	0921                	add	s2,s2,8
     7ae:	f7691ee3          	bne	s2,s6,72a <copyout+0x58>
}
     7b2:	70e6                	ld	ra,120(sp)
     7b4:	7446                	ld	s0,112(sp)
     7b6:	74a6                	ld	s1,104(sp)
     7b8:	7906                	ld	s2,96(sp)
     7ba:	69e6                	ld	s3,88(sp)
     7bc:	6a46                	ld	s4,80(sp)
     7be:	6aa6                	ld	s5,72(sp)
     7c0:	6b06                	ld	s6,64(sp)
     7c2:	6109                	add	sp,sp,128
     7c4:	8082                	ret
      printf("open(README) failed\n");
     7c6:	00006517          	auipc	a0,0x6
     7ca:	d0250513          	add	a0,a0,-766 # 64c8 <malloc+0x30c>
     7ce:	00006097          	auipc	ra,0x6
     7d2:	936080e7          	jalr	-1738(ra) # 6104 <printf>
      exit(1);
     7d6:	4505                	li	a0,1
     7d8:	00005097          	auipc	ra,0x5
     7dc:	4c2080e7          	jalr	1218(ra) # 5c9a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     7e0:	862a                	mv	a2,a0
     7e2:	85ce                	mv	a1,s3
     7e4:	00006517          	auipc	a0,0x6
     7e8:	cfc50513          	add	a0,a0,-772 # 64e0 <malloc+0x324>
     7ec:	00006097          	auipc	ra,0x6
     7f0:	918080e7          	jalr	-1768(ra) # 6104 <printf>
      exit(1);
     7f4:	4505                	li	a0,1
     7f6:	00005097          	auipc	ra,0x5
     7fa:	4a4080e7          	jalr	1188(ra) # 5c9a <exit>
      printf("pipe() failed\n");
     7fe:	00006517          	auipc	a0,0x6
     802:	c8250513          	add	a0,a0,-894 # 6480 <malloc+0x2c4>
     806:	00006097          	auipc	ra,0x6
     80a:	8fe080e7          	jalr	-1794(ra) # 6104 <printf>
      exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	48a080e7          	jalr	1162(ra) # 5c9a <exit>
      printf("pipe write failed\n");
     818:	00006517          	auipc	a0,0x6
     81c:	cf850513          	add	a0,a0,-776 # 6510 <malloc+0x354>
     820:	00006097          	auipc	ra,0x6
     824:	8e4080e7          	jalr	-1820(ra) # 6104 <printf>
      exit(1);
     828:	4505                	li	a0,1
     82a:	00005097          	auipc	ra,0x5
     82e:	470080e7          	jalr	1136(ra) # 5c9a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     832:	862a                	mv	a2,a0
     834:	85ce                	mv	a1,s3
     836:	00006517          	auipc	a0,0x6
     83a:	cf250513          	add	a0,a0,-782 # 6528 <malloc+0x36c>
     83e:	00006097          	auipc	ra,0x6
     842:	8c6080e7          	jalr	-1850(ra) # 6104 <printf>
      exit(1);
     846:	4505                	li	a0,1
     848:	00005097          	auipc	ra,0x5
     84c:	452080e7          	jalr	1106(ra) # 5c9a <exit>

0000000000000850 <truncate1>:
{
     850:	711d                	add	sp,sp,-96
     852:	ec86                	sd	ra,88(sp)
     854:	e8a2                	sd	s0,80(sp)
     856:	e4a6                	sd	s1,72(sp)
     858:	e0ca                	sd	s2,64(sp)
     85a:	fc4e                	sd	s3,56(sp)
     85c:	f852                	sd	s4,48(sp)
     85e:	f456                	sd	s5,40(sp)
     860:	1080                	add	s0,sp,96
     862:	8aaa                	mv	s5,a0
  unlink("truncfile");
     864:	00006517          	auipc	a0,0x6
     868:	adc50513          	add	a0,a0,-1316 # 6340 <malloc+0x184>
     86c:	00005097          	auipc	ra,0x5
     870:	47e080e7          	jalr	1150(ra) # 5cea <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     874:	60100593          	li	a1,1537
     878:	00006517          	auipc	a0,0x6
     87c:	ac850513          	add	a0,a0,-1336 # 6340 <malloc+0x184>
     880:	00005097          	auipc	ra,0x5
     884:	45a080e7          	jalr	1114(ra) # 5cda <open>
     888:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     88a:	4611                	li	a2,4
     88c:	00006597          	auipc	a1,0x6
     890:	ac458593          	add	a1,a1,-1340 # 6350 <malloc+0x194>
     894:	00005097          	auipc	ra,0x5
     898:	426080e7          	jalr	1062(ra) # 5cba <write>
  close(fd1);
     89c:	8526                	mv	a0,s1
     89e:	00005097          	auipc	ra,0x5
     8a2:	424080e7          	jalr	1060(ra) # 5cc2 <close>
  int fd2 = open("truncfile", O_RDONLY);
     8a6:	4581                	li	a1,0
     8a8:	00006517          	auipc	a0,0x6
     8ac:	a9850513          	add	a0,a0,-1384 # 6340 <malloc+0x184>
     8b0:	00005097          	auipc	ra,0x5
     8b4:	42a080e7          	jalr	1066(ra) # 5cda <open>
     8b8:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     8ba:	02000613          	li	a2,32
     8be:	fa040593          	add	a1,s0,-96
     8c2:	00005097          	auipc	ra,0x5
     8c6:	3f0080e7          	jalr	1008(ra) # 5cb2 <read>
  if(n != 4){
     8ca:	4791                	li	a5,4
     8cc:	0cf51e63          	bne	a0,a5,9a8 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     8d0:	40100593          	li	a1,1025
     8d4:	00006517          	auipc	a0,0x6
     8d8:	a6c50513          	add	a0,a0,-1428 # 6340 <malloc+0x184>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	3fe080e7          	jalr	1022(ra) # 5cda <open>
     8e4:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     8e6:	4581                	li	a1,0
     8e8:	00006517          	auipc	a0,0x6
     8ec:	a5850513          	add	a0,a0,-1448 # 6340 <malloc+0x184>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	3ea080e7          	jalr	1002(ra) # 5cda <open>
     8f8:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     8fa:	02000613          	li	a2,32
     8fe:	fa040593          	add	a1,s0,-96
     902:	00005097          	auipc	ra,0x5
     906:	3b0080e7          	jalr	944(ra) # 5cb2 <read>
     90a:	8a2a                	mv	s4,a0
  if(n != 0){
     90c:	ed4d                	bnez	a0,9c6 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     90e:	02000613          	li	a2,32
     912:	fa040593          	add	a1,s0,-96
     916:	8526                	mv	a0,s1
     918:	00005097          	auipc	ra,0x5
     91c:	39a080e7          	jalr	922(ra) # 5cb2 <read>
     920:	8a2a                	mv	s4,a0
  if(n != 0){
     922:	e971                	bnez	a0,9f6 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     924:	4619                	li	a2,6
     926:	00006597          	auipc	a1,0x6
     92a:	c9258593          	add	a1,a1,-878 # 65b8 <malloc+0x3fc>
     92e:	854e                	mv	a0,s3
     930:	00005097          	auipc	ra,0x5
     934:	38a080e7          	jalr	906(ra) # 5cba <write>
  n = read(fd3, buf, sizeof(buf));
     938:	02000613          	li	a2,32
     93c:	fa040593          	add	a1,s0,-96
     940:	854a                	mv	a0,s2
     942:	00005097          	auipc	ra,0x5
     946:	370080e7          	jalr	880(ra) # 5cb2 <read>
  if(n != 6){
     94a:	4799                	li	a5,6
     94c:	0cf51d63          	bne	a0,a5,a26 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     950:	02000613          	li	a2,32
     954:	fa040593          	add	a1,s0,-96
     958:	8526                	mv	a0,s1
     95a:	00005097          	auipc	ra,0x5
     95e:	358080e7          	jalr	856(ra) # 5cb2 <read>
  if(n != 2){
     962:	4789                	li	a5,2
     964:	0ef51063          	bne	a0,a5,a44 <truncate1+0x1f4>
  unlink("truncfile");
     968:	00006517          	auipc	a0,0x6
     96c:	9d850513          	add	a0,a0,-1576 # 6340 <malloc+0x184>
     970:	00005097          	auipc	ra,0x5
     974:	37a080e7          	jalr	890(ra) # 5cea <unlink>
  close(fd1);
     978:	854e                	mv	a0,s3
     97a:	00005097          	auipc	ra,0x5
     97e:	348080e7          	jalr	840(ra) # 5cc2 <close>
  close(fd2);
     982:	8526                	mv	a0,s1
     984:	00005097          	auipc	ra,0x5
     988:	33e080e7          	jalr	830(ra) # 5cc2 <close>
  close(fd3);
     98c:	854a                	mv	a0,s2
     98e:	00005097          	auipc	ra,0x5
     992:	334080e7          	jalr	820(ra) # 5cc2 <close>
}
     996:	60e6                	ld	ra,88(sp)
     998:	6446                	ld	s0,80(sp)
     99a:	64a6                	ld	s1,72(sp)
     99c:	6906                	ld	s2,64(sp)
     99e:	79e2                	ld	s3,56(sp)
     9a0:	7a42                	ld	s4,48(sp)
     9a2:	7aa2                	ld	s5,40(sp)
     9a4:	6125                	add	sp,sp,96
     9a6:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     9a8:	862a                	mv	a2,a0
     9aa:	85d6                	mv	a1,s5
     9ac:	00006517          	auipc	a0,0x6
     9b0:	bac50513          	add	a0,a0,-1108 # 6558 <malloc+0x39c>
     9b4:	00005097          	auipc	ra,0x5
     9b8:	750080e7          	jalr	1872(ra) # 6104 <printf>
    exit(1);
     9bc:	4505                	li	a0,1
     9be:	00005097          	auipc	ra,0x5
     9c2:	2dc080e7          	jalr	732(ra) # 5c9a <exit>
    printf("aaa fd3=%d\n", fd3);
     9c6:	85ca                	mv	a1,s2
     9c8:	00006517          	auipc	a0,0x6
     9cc:	bb050513          	add	a0,a0,-1104 # 6578 <malloc+0x3bc>
     9d0:	00005097          	auipc	ra,0x5
     9d4:	734080e7          	jalr	1844(ra) # 6104 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9d8:	8652                	mv	a2,s4
     9da:	85d6                	mv	a1,s5
     9dc:	00006517          	auipc	a0,0x6
     9e0:	bac50513          	add	a0,a0,-1108 # 6588 <malloc+0x3cc>
     9e4:	00005097          	auipc	ra,0x5
     9e8:	720080e7          	jalr	1824(ra) # 6104 <printf>
    exit(1);
     9ec:	4505                	li	a0,1
     9ee:	00005097          	auipc	ra,0x5
     9f2:	2ac080e7          	jalr	684(ra) # 5c9a <exit>
    printf("bbb fd2=%d\n", fd2);
     9f6:	85a6                	mv	a1,s1
     9f8:	00006517          	auipc	a0,0x6
     9fc:	bb050513          	add	a0,a0,-1104 # 65a8 <malloc+0x3ec>
     a00:	00005097          	auipc	ra,0x5
     a04:	704080e7          	jalr	1796(ra) # 6104 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a08:	8652                	mv	a2,s4
     a0a:	85d6                	mv	a1,s5
     a0c:	00006517          	auipc	a0,0x6
     a10:	b7c50513          	add	a0,a0,-1156 # 6588 <malloc+0x3cc>
     a14:	00005097          	auipc	ra,0x5
     a18:	6f0080e7          	jalr	1776(ra) # 6104 <printf>
    exit(1);
     a1c:	4505                	li	a0,1
     a1e:	00005097          	auipc	ra,0x5
     a22:	27c080e7          	jalr	636(ra) # 5c9a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     a26:	862a                	mv	a2,a0
     a28:	85d6                	mv	a1,s5
     a2a:	00006517          	auipc	a0,0x6
     a2e:	b9650513          	add	a0,a0,-1130 # 65c0 <malloc+0x404>
     a32:	00005097          	auipc	ra,0x5
     a36:	6d2080e7          	jalr	1746(ra) # 6104 <printf>
    exit(1);
     a3a:	4505                	li	a0,1
     a3c:	00005097          	auipc	ra,0x5
     a40:	25e080e7          	jalr	606(ra) # 5c9a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     a44:	862a                	mv	a2,a0
     a46:	85d6                	mv	a1,s5
     a48:	00006517          	auipc	a0,0x6
     a4c:	b9850513          	add	a0,a0,-1128 # 65e0 <malloc+0x424>
     a50:	00005097          	auipc	ra,0x5
     a54:	6b4080e7          	jalr	1716(ra) # 6104 <printf>
    exit(1);
     a58:	4505                	li	a0,1
     a5a:	00005097          	auipc	ra,0x5
     a5e:	240080e7          	jalr	576(ra) # 5c9a <exit>

0000000000000a62 <writetest>:
{
     a62:	7139                	add	sp,sp,-64
     a64:	fc06                	sd	ra,56(sp)
     a66:	f822                	sd	s0,48(sp)
     a68:	f426                	sd	s1,40(sp)
     a6a:	f04a                	sd	s2,32(sp)
     a6c:	ec4e                	sd	s3,24(sp)
     a6e:	e852                	sd	s4,16(sp)
     a70:	e456                	sd	s5,8(sp)
     a72:	e05a                	sd	s6,0(sp)
     a74:	0080                	add	s0,sp,64
     a76:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a78:	20200593          	li	a1,514
     a7c:	00006517          	auipc	a0,0x6
     a80:	b8450513          	add	a0,a0,-1148 # 6600 <malloc+0x444>
     a84:	00005097          	auipc	ra,0x5
     a88:	256080e7          	jalr	598(ra) # 5cda <open>
  if(fd < 0){
     a8c:	0a054d63          	bltz	a0,b46 <writetest+0xe4>
     a90:	892a                	mv	s2,a0
     a92:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a94:	00006997          	auipc	s3,0x6
     a98:	b9498993          	add	s3,s3,-1132 # 6628 <malloc+0x46c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a9c:	00006a97          	auipc	s5,0x6
     aa0:	bc4a8a93          	add	s5,s5,-1084 # 6660 <malloc+0x4a4>
  for(i = 0; i < N; i++){
     aa4:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     aa8:	4629                	li	a2,10
     aaa:	85ce                	mv	a1,s3
     aac:	854a                	mv	a0,s2
     aae:	00005097          	auipc	ra,0x5
     ab2:	20c080e7          	jalr	524(ra) # 5cba <write>
     ab6:	47a9                	li	a5,10
     ab8:	0af51563          	bne	a0,a5,b62 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     abc:	4629                	li	a2,10
     abe:	85d6                	mv	a1,s5
     ac0:	854a                	mv	a0,s2
     ac2:	00005097          	auipc	ra,0x5
     ac6:	1f8080e7          	jalr	504(ra) # 5cba <write>
     aca:	47a9                	li	a5,10
     acc:	0af51a63          	bne	a0,a5,b80 <writetest+0x11e>
  for(i = 0; i < N; i++){
     ad0:	2485                	addw	s1,s1,1
     ad2:	fd449be3          	bne	s1,s4,aa8 <writetest+0x46>
  close(fd);
     ad6:	854a                	mv	a0,s2
     ad8:	00005097          	auipc	ra,0x5
     adc:	1ea080e7          	jalr	490(ra) # 5cc2 <close>
  fd = open("small", O_RDONLY);
     ae0:	4581                	li	a1,0
     ae2:	00006517          	auipc	a0,0x6
     ae6:	b1e50513          	add	a0,a0,-1250 # 6600 <malloc+0x444>
     aea:	00005097          	auipc	ra,0x5
     aee:	1f0080e7          	jalr	496(ra) # 5cda <open>
     af2:	84aa                	mv	s1,a0
  if(fd < 0){
     af4:	0a054563          	bltz	a0,b9e <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     af8:	7d000613          	li	a2,2000
     afc:	0000c597          	auipc	a1,0xc
     b00:	17c58593          	add	a1,a1,380 # cc78 <buf>
     b04:	00005097          	auipc	ra,0x5
     b08:	1ae080e7          	jalr	430(ra) # 5cb2 <read>
  if(i != N*SZ*2){
     b0c:	7d000793          	li	a5,2000
     b10:	0af51563          	bne	a0,a5,bba <writetest+0x158>
  close(fd);
     b14:	8526                	mv	a0,s1
     b16:	00005097          	auipc	ra,0x5
     b1a:	1ac080e7          	jalr	428(ra) # 5cc2 <close>
  if(unlink("small") < 0){
     b1e:	00006517          	auipc	a0,0x6
     b22:	ae250513          	add	a0,a0,-1310 # 6600 <malloc+0x444>
     b26:	00005097          	auipc	ra,0x5
     b2a:	1c4080e7          	jalr	452(ra) # 5cea <unlink>
     b2e:	0a054463          	bltz	a0,bd6 <writetest+0x174>
}
     b32:	70e2                	ld	ra,56(sp)
     b34:	7442                	ld	s0,48(sp)
     b36:	74a2                	ld	s1,40(sp)
     b38:	7902                	ld	s2,32(sp)
     b3a:	69e2                	ld	s3,24(sp)
     b3c:	6a42                	ld	s4,16(sp)
     b3e:	6aa2                	ld	s5,8(sp)
     b40:	6b02                	ld	s6,0(sp)
     b42:	6121                	add	sp,sp,64
     b44:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     b46:	85da                	mv	a1,s6
     b48:	00006517          	auipc	a0,0x6
     b4c:	ac050513          	add	a0,a0,-1344 # 6608 <malloc+0x44c>
     b50:	00005097          	auipc	ra,0x5
     b54:	5b4080e7          	jalr	1460(ra) # 6104 <printf>
    exit(1);
     b58:	4505                	li	a0,1
     b5a:	00005097          	auipc	ra,0x5
     b5e:	140080e7          	jalr	320(ra) # 5c9a <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b62:	8626                	mv	a2,s1
     b64:	85da                	mv	a1,s6
     b66:	00006517          	auipc	a0,0x6
     b6a:	ad250513          	add	a0,a0,-1326 # 6638 <malloc+0x47c>
     b6e:	00005097          	auipc	ra,0x5
     b72:	596080e7          	jalr	1430(ra) # 6104 <printf>
      exit(1);
     b76:	4505                	li	a0,1
     b78:	00005097          	auipc	ra,0x5
     b7c:	122080e7          	jalr	290(ra) # 5c9a <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b80:	8626                	mv	a2,s1
     b82:	85da                	mv	a1,s6
     b84:	00006517          	auipc	a0,0x6
     b88:	aec50513          	add	a0,a0,-1300 # 6670 <malloc+0x4b4>
     b8c:	00005097          	auipc	ra,0x5
     b90:	578080e7          	jalr	1400(ra) # 6104 <printf>
      exit(1);
     b94:	4505                	li	a0,1
     b96:	00005097          	auipc	ra,0x5
     b9a:	104080e7          	jalr	260(ra) # 5c9a <exit>
    printf("%s: error: open small failed!\n", s);
     b9e:	85da                	mv	a1,s6
     ba0:	00006517          	auipc	a0,0x6
     ba4:	af850513          	add	a0,a0,-1288 # 6698 <malloc+0x4dc>
     ba8:	00005097          	auipc	ra,0x5
     bac:	55c080e7          	jalr	1372(ra) # 6104 <printf>
    exit(1);
     bb0:	4505                	li	a0,1
     bb2:	00005097          	auipc	ra,0x5
     bb6:	0e8080e7          	jalr	232(ra) # 5c9a <exit>
    printf("%s: read failed\n", s);
     bba:	85da                	mv	a1,s6
     bbc:	00006517          	auipc	a0,0x6
     bc0:	afc50513          	add	a0,a0,-1284 # 66b8 <malloc+0x4fc>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	540080e7          	jalr	1344(ra) # 6104 <printf>
    exit(1);
     bcc:	4505                	li	a0,1
     bce:	00005097          	auipc	ra,0x5
     bd2:	0cc080e7          	jalr	204(ra) # 5c9a <exit>
    printf("%s: unlink small failed\n", s);
     bd6:	85da                	mv	a1,s6
     bd8:	00006517          	auipc	a0,0x6
     bdc:	af850513          	add	a0,a0,-1288 # 66d0 <malloc+0x514>
     be0:	00005097          	auipc	ra,0x5
     be4:	524080e7          	jalr	1316(ra) # 6104 <printf>
    exit(1);
     be8:	4505                	li	a0,1
     bea:	00005097          	auipc	ra,0x5
     bee:	0b0080e7          	jalr	176(ra) # 5c9a <exit>

0000000000000bf2 <writebig>:
{
     bf2:	7139                	add	sp,sp,-64
     bf4:	fc06                	sd	ra,56(sp)
     bf6:	f822                	sd	s0,48(sp)
     bf8:	f426                	sd	s1,40(sp)
     bfa:	f04a                	sd	s2,32(sp)
     bfc:	ec4e                	sd	s3,24(sp)
     bfe:	e852                	sd	s4,16(sp)
     c00:	e456                	sd	s5,8(sp)
     c02:	0080                	add	s0,sp,64
     c04:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     c06:	20200593          	li	a1,514
     c0a:	00006517          	auipc	a0,0x6
     c0e:	ae650513          	add	a0,a0,-1306 # 66f0 <malloc+0x534>
     c12:	00005097          	auipc	ra,0x5
     c16:	0c8080e7          	jalr	200(ra) # 5cda <open>
     c1a:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     c1c:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     c1e:	0000c917          	auipc	s2,0xc
     c22:	05a90913          	add	s2,s2,90 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     c26:	10c00a13          	li	s4,268
  if(fd < 0){
     c2a:	06054c63          	bltz	a0,ca2 <writebig+0xb0>
    ((int*)buf)[0] = i;
     c2e:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     c32:	40000613          	li	a2,1024
     c36:	85ca                	mv	a1,s2
     c38:	854e                	mv	a0,s3
     c3a:	00005097          	auipc	ra,0x5
     c3e:	080080e7          	jalr	128(ra) # 5cba <write>
     c42:	40000793          	li	a5,1024
     c46:	06f51c63          	bne	a0,a5,cbe <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     c4a:	2485                	addw	s1,s1,1
     c4c:	ff4491e3          	bne	s1,s4,c2e <writebig+0x3c>
  close(fd);
     c50:	854e                	mv	a0,s3
     c52:	00005097          	auipc	ra,0x5
     c56:	070080e7          	jalr	112(ra) # 5cc2 <close>
  fd = open("big", O_RDONLY);
     c5a:	4581                	li	a1,0
     c5c:	00006517          	auipc	a0,0x6
     c60:	a9450513          	add	a0,a0,-1388 # 66f0 <malloc+0x534>
     c64:	00005097          	auipc	ra,0x5
     c68:	076080e7          	jalr	118(ra) # 5cda <open>
     c6c:	89aa                	mv	s3,a0
  n = 0;
     c6e:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c70:	0000c917          	auipc	s2,0xc
     c74:	00890913          	add	s2,s2,8 # cc78 <buf>
  if(fd < 0){
     c78:	06054263          	bltz	a0,cdc <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c7c:	40000613          	li	a2,1024
     c80:	85ca                	mv	a1,s2
     c82:	854e                	mv	a0,s3
     c84:	00005097          	auipc	ra,0x5
     c88:	02e080e7          	jalr	46(ra) # 5cb2 <read>
    if(i == 0){
     c8c:	c535                	beqz	a0,cf8 <writebig+0x106>
    } else if(i != BSIZE){
     c8e:	40000793          	li	a5,1024
     c92:	0af51e63          	bne	a0,a5,d4e <writebig+0x15c>
    if(((int*)buf)[0] != n){
     c96:	00092683          	lw	a3,0(s2)
     c9a:	0c969963          	bne	a3,s1,d6c <writebig+0x17a>
    n++;
     c9e:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     ca0:	bff1                	j	c7c <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     ca2:	85d6                	mv	a1,s5
     ca4:	00006517          	auipc	a0,0x6
     ca8:	a5450513          	add	a0,a0,-1452 # 66f8 <malloc+0x53c>
     cac:	00005097          	auipc	ra,0x5
     cb0:	458080e7          	jalr	1112(ra) # 6104 <printf>
    exit(1);
     cb4:	4505                	li	a0,1
     cb6:	00005097          	auipc	ra,0x5
     cba:	fe4080e7          	jalr	-28(ra) # 5c9a <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     cbe:	8626                	mv	a2,s1
     cc0:	85d6                	mv	a1,s5
     cc2:	00006517          	auipc	a0,0x6
     cc6:	a5650513          	add	a0,a0,-1450 # 6718 <malloc+0x55c>
     cca:	00005097          	auipc	ra,0x5
     cce:	43a080e7          	jalr	1082(ra) # 6104 <printf>
      exit(1);
     cd2:	4505                	li	a0,1
     cd4:	00005097          	auipc	ra,0x5
     cd8:	fc6080e7          	jalr	-58(ra) # 5c9a <exit>
    printf("%s: error: open big failed!\n", s);
     cdc:	85d6                	mv	a1,s5
     cde:	00006517          	auipc	a0,0x6
     ce2:	a6250513          	add	a0,a0,-1438 # 6740 <malloc+0x584>
     ce6:	00005097          	auipc	ra,0x5
     cea:	41e080e7          	jalr	1054(ra) # 6104 <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	00005097          	auipc	ra,0x5
     cf4:	faa080e7          	jalr	-86(ra) # 5c9a <exit>
      if(n != MAXFILE){
     cf8:	10c00793          	li	a5,268
     cfc:	02f49a63          	bne	s1,a5,d30 <writebig+0x13e>
  close(fd);
     d00:	854e                	mv	a0,s3
     d02:	00005097          	auipc	ra,0x5
     d06:	fc0080e7          	jalr	-64(ra) # 5cc2 <close>
  if(unlink("big") < 0){
     d0a:	00006517          	auipc	a0,0x6
     d0e:	9e650513          	add	a0,a0,-1562 # 66f0 <malloc+0x534>
     d12:	00005097          	auipc	ra,0x5
     d16:	fd8080e7          	jalr	-40(ra) # 5cea <unlink>
     d1a:	06054863          	bltz	a0,d8a <writebig+0x198>
}
     d1e:	70e2                	ld	ra,56(sp)
     d20:	7442                	ld	s0,48(sp)
     d22:	74a2                	ld	s1,40(sp)
     d24:	7902                	ld	s2,32(sp)
     d26:	69e2                	ld	s3,24(sp)
     d28:	6a42                	ld	s4,16(sp)
     d2a:	6aa2                	ld	s5,8(sp)
     d2c:	6121                	add	sp,sp,64
     d2e:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     d30:	8626                	mv	a2,s1
     d32:	85d6                	mv	a1,s5
     d34:	00006517          	auipc	a0,0x6
     d38:	a2c50513          	add	a0,a0,-1492 # 6760 <malloc+0x5a4>
     d3c:	00005097          	auipc	ra,0x5
     d40:	3c8080e7          	jalr	968(ra) # 6104 <printf>
        exit(1);
     d44:	4505                	li	a0,1
     d46:	00005097          	auipc	ra,0x5
     d4a:	f54080e7          	jalr	-172(ra) # 5c9a <exit>
      printf("%s: read failed %d\n", s, i);
     d4e:	862a                	mv	a2,a0
     d50:	85d6                	mv	a1,s5
     d52:	00006517          	auipc	a0,0x6
     d56:	a3650513          	add	a0,a0,-1482 # 6788 <malloc+0x5cc>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	3aa080e7          	jalr	938(ra) # 6104 <printf>
      exit(1);
     d62:	4505                	li	a0,1
     d64:	00005097          	auipc	ra,0x5
     d68:	f36080e7          	jalr	-202(ra) # 5c9a <exit>
      printf("%s: read content of block %d is %d\n", s,
     d6c:	8626                	mv	a2,s1
     d6e:	85d6                	mv	a1,s5
     d70:	00006517          	auipc	a0,0x6
     d74:	a3050513          	add	a0,a0,-1488 # 67a0 <malloc+0x5e4>
     d78:	00005097          	auipc	ra,0x5
     d7c:	38c080e7          	jalr	908(ra) # 6104 <printf>
      exit(1);
     d80:	4505                	li	a0,1
     d82:	00005097          	auipc	ra,0x5
     d86:	f18080e7          	jalr	-232(ra) # 5c9a <exit>
    printf("%s: unlink big failed\n", s);
     d8a:	85d6                	mv	a1,s5
     d8c:	00006517          	auipc	a0,0x6
     d90:	a3c50513          	add	a0,a0,-1476 # 67c8 <malloc+0x60c>
     d94:	00005097          	auipc	ra,0x5
     d98:	370080e7          	jalr	880(ra) # 6104 <printf>
    exit(1);
     d9c:	4505                	li	a0,1
     d9e:	00005097          	auipc	ra,0x5
     da2:	efc080e7          	jalr	-260(ra) # 5c9a <exit>

0000000000000da6 <unlinkread>:
{
     da6:	7179                	add	sp,sp,-48
     da8:	f406                	sd	ra,40(sp)
     daa:	f022                	sd	s0,32(sp)
     dac:	ec26                	sd	s1,24(sp)
     dae:	e84a                	sd	s2,16(sp)
     db0:	e44e                	sd	s3,8(sp)
     db2:	1800                	add	s0,sp,48
     db4:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     db6:	20200593          	li	a1,514
     dba:	00006517          	auipc	a0,0x6
     dbe:	a2650513          	add	a0,a0,-1498 # 67e0 <malloc+0x624>
     dc2:	00005097          	auipc	ra,0x5
     dc6:	f18080e7          	jalr	-232(ra) # 5cda <open>
  if(fd < 0){
     dca:	0e054563          	bltz	a0,eb4 <unlinkread+0x10e>
     dce:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     dd0:	4615                	li	a2,5
     dd2:	00006597          	auipc	a1,0x6
     dd6:	a3e58593          	add	a1,a1,-1474 # 6810 <malloc+0x654>
     dda:	00005097          	auipc	ra,0x5
     dde:	ee0080e7          	jalr	-288(ra) # 5cba <write>
  close(fd);
     de2:	8526                	mv	a0,s1
     de4:	00005097          	auipc	ra,0x5
     de8:	ede080e7          	jalr	-290(ra) # 5cc2 <close>
  fd = open("unlinkread", O_RDWR);
     dec:	4589                	li	a1,2
     dee:	00006517          	auipc	a0,0x6
     df2:	9f250513          	add	a0,a0,-1550 # 67e0 <malloc+0x624>
     df6:	00005097          	auipc	ra,0x5
     dfa:	ee4080e7          	jalr	-284(ra) # 5cda <open>
     dfe:	84aa                	mv	s1,a0
  if(fd < 0){
     e00:	0c054863          	bltz	a0,ed0 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     e04:	00006517          	auipc	a0,0x6
     e08:	9dc50513          	add	a0,a0,-1572 # 67e0 <malloc+0x624>
     e0c:	00005097          	auipc	ra,0x5
     e10:	ede080e7          	jalr	-290(ra) # 5cea <unlink>
     e14:	ed61                	bnez	a0,eec <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     e16:	20200593          	li	a1,514
     e1a:	00006517          	auipc	a0,0x6
     e1e:	9c650513          	add	a0,a0,-1594 # 67e0 <malloc+0x624>
     e22:	00005097          	auipc	ra,0x5
     e26:	eb8080e7          	jalr	-328(ra) # 5cda <open>
     e2a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     e2c:	460d                	li	a2,3
     e2e:	00006597          	auipc	a1,0x6
     e32:	a2a58593          	add	a1,a1,-1494 # 6858 <malloc+0x69c>
     e36:	00005097          	auipc	ra,0x5
     e3a:	e84080e7          	jalr	-380(ra) # 5cba <write>
  close(fd1);
     e3e:	854a                	mv	a0,s2
     e40:	00005097          	auipc	ra,0x5
     e44:	e82080e7          	jalr	-382(ra) # 5cc2 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     e48:	660d                	lui	a2,0x3
     e4a:	0000c597          	auipc	a1,0xc
     e4e:	e2e58593          	add	a1,a1,-466 # cc78 <buf>
     e52:	8526                	mv	a0,s1
     e54:	00005097          	auipc	ra,0x5
     e58:	e5e080e7          	jalr	-418(ra) # 5cb2 <read>
     e5c:	4795                	li	a5,5
     e5e:	0af51563          	bne	a0,a5,f08 <unlinkread+0x162>
  if(buf[0] != 'h'){
     e62:	0000c717          	auipc	a4,0xc
     e66:	e1674703          	lbu	a4,-490(a4) # cc78 <buf>
     e6a:	06800793          	li	a5,104
     e6e:	0af71b63          	bne	a4,a5,f24 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e72:	4629                	li	a2,10
     e74:	0000c597          	auipc	a1,0xc
     e78:	e0458593          	add	a1,a1,-508 # cc78 <buf>
     e7c:	8526                	mv	a0,s1
     e7e:	00005097          	auipc	ra,0x5
     e82:	e3c080e7          	jalr	-452(ra) # 5cba <write>
     e86:	47a9                	li	a5,10
     e88:	0af51c63          	bne	a0,a5,f40 <unlinkread+0x19a>
  close(fd);
     e8c:	8526                	mv	a0,s1
     e8e:	00005097          	auipc	ra,0x5
     e92:	e34080e7          	jalr	-460(ra) # 5cc2 <close>
  unlink("unlinkread");
     e96:	00006517          	auipc	a0,0x6
     e9a:	94a50513          	add	a0,a0,-1718 # 67e0 <malloc+0x624>
     e9e:	00005097          	auipc	ra,0x5
     ea2:	e4c080e7          	jalr	-436(ra) # 5cea <unlink>
}
     ea6:	70a2                	ld	ra,40(sp)
     ea8:	7402                	ld	s0,32(sp)
     eaa:	64e2                	ld	s1,24(sp)
     eac:	6942                	ld	s2,16(sp)
     eae:	69a2                	ld	s3,8(sp)
     eb0:	6145                	add	sp,sp,48
     eb2:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     eb4:	85ce                	mv	a1,s3
     eb6:	00006517          	auipc	a0,0x6
     eba:	93a50513          	add	a0,a0,-1734 # 67f0 <malloc+0x634>
     ebe:	00005097          	auipc	ra,0x5
     ec2:	246080e7          	jalr	582(ra) # 6104 <printf>
    exit(1);
     ec6:	4505                	li	a0,1
     ec8:	00005097          	auipc	ra,0x5
     ecc:	dd2080e7          	jalr	-558(ra) # 5c9a <exit>
    printf("%s: open unlinkread failed\n", s);
     ed0:	85ce                	mv	a1,s3
     ed2:	00006517          	auipc	a0,0x6
     ed6:	94650513          	add	a0,a0,-1722 # 6818 <malloc+0x65c>
     eda:	00005097          	auipc	ra,0x5
     ede:	22a080e7          	jalr	554(ra) # 6104 <printf>
    exit(1);
     ee2:	4505                	li	a0,1
     ee4:	00005097          	auipc	ra,0x5
     ee8:	db6080e7          	jalr	-586(ra) # 5c9a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     eec:	85ce                	mv	a1,s3
     eee:	00006517          	auipc	a0,0x6
     ef2:	94a50513          	add	a0,a0,-1718 # 6838 <malloc+0x67c>
     ef6:	00005097          	auipc	ra,0x5
     efa:	20e080e7          	jalr	526(ra) # 6104 <printf>
    exit(1);
     efe:	4505                	li	a0,1
     f00:	00005097          	auipc	ra,0x5
     f04:	d9a080e7          	jalr	-614(ra) # 5c9a <exit>
    printf("%s: unlinkread read failed", s);
     f08:	85ce                	mv	a1,s3
     f0a:	00006517          	auipc	a0,0x6
     f0e:	95650513          	add	a0,a0,-1706 # 6860 <malloc+0x6a4>
     f12:	00005097          	auipc	ra,0x5
     f16:	1f2080e7          	jalr	498(ra) # 6104 <printf>
    exit(1);
     f1a:	4505                	li	a0,1
     f1c:	00005097          	auipc	ra,0x5
     f20:	d7e080e7          	jalr	-642(ra) # 5c9a <exit>
    printf("%s: unlinkread wrong data\n", s);
     f24:	85ce                	mv	a1,s3
     f26:	00006517          	auipc	a0,0x6
     f2a:	95a50513          	add	a0,a0,-1702 # 6880 <malloc+0x6c4>
     f2e:	00005097          	auipc	ra,0x5
     f32:	1d6080e7          	jalr	470(ra) # 6104 <printf>
    exit(1);
     f36:	4505                	li	a0,1
     f38:	00005097          	auipc	ra,0x5
     f3c:	d62080e7          	jalr	-670(ra) # 5c9a <exit>
    printf("%s: unlinkread write failed\n", s);
     f40:	85ce                	mv	a1,s3
     f42:	00006517          	auipc	a0,0x6
     f46:	95e50513          	add	a0,a0,-1698 # 68a0 <malloc+0x6e4>
     f4a:	00005097          	auipc	ra,0x5
     f4e:	1ba080e7          	jalr	442(ra) # 6104 <printf>
    exit(1);
     f52:	4505                	li	a0,1
     f54:	00005097          	auipc	ra,0x5
     f58:	d46080e7          	jalr	-698(ra) # 5c9a <exit>

0000000000000f5c <linktest>:
{
     f5c:	1101                	add	sp,sp,-32
     f5e:	ec06                	sd	ra,24(sp)
     f60:	e822                	sd	s0,16(sp)
     f62:	e426                	sd	s1,8(sp)
     f64:	e04a                	sd	s2,0(sp)
     f66:	1000                	add	s0,sp,32
     f68:	892a                	mv	s2,a0
  unlink("lf1");
     f6a:	00006517          	auipc	a0,0x6
     f6e:	95650513          	add	a0,a0,-1706 # 68c0 <malloc+0x704>
     f72:	00005097          	auipc	ra,0x5
     f76:	d78080e7          	jalr	-648(ra) # 5cea <unlink>
  unlink("lf2");
     f7a:	00006517          	auipc	a0,0x6
     f7e:	94e50513          	add	a0,a0,-1714 # 68c8 <malloc+0x70c>
     f82:	00005097          	auipc	ra,0x5
     f86:	d68080e7          	jalr	-664(ra) # 5cea <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f8a:	20200593          	li	a1,514
     f8e:	00006517          	auipc	a0,0x6
     f92:	93250513          	add	a0,a0,-1742 # 68c0 <malloc+0x704>
     f96:	00005097          	auipc	ra,0x5
     f9a:	d44080e7          	jalr	-700(ra) # 5cda <open>
  if(fd < 0){
     f9e:	10054763          	bltz	a0,10ac <linktest+0x150>
     fa2:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     fa4:	4615                	li	a2,5
     fa6:	00006597          	auipc	a1,0x6
     faa:	86a58593          	add	a1,a1,-1942 # 6810 <malloc+0x654>
     fae:	00005097          	auipc	ra,0x5
     fb2:	d0c080e7          	jalr	-756(ra) # 5cba <write>
     fb6:	4795                	li	a5,5
     fb8:	10f51863          	bne	a0,a5,10c8 <linktest+0x16c>
  close(fd);
     fbc:	8526                	mv	a0,s1
     fbe:	00005097          	auipc	ra,0x5
     fc2:	d04080e7          	jalr	-764(ra) # 5cc2 <close>
  if(link("lf1", "lf2") < 0){
     fc6:	00006597          	auipc	a1,0x6
     fca:	90258593          	add	a1,a1,-1790 # 68c8 <malloc+0x70c>
     fce:	00006517          	auipc	a0,0x6
     fd2:	8f250513          	add	a0,a0,-1806 # 68c0 <malloc+0x704>
     fd6:	00005097          	auipc	ra,0x5
     fda:	d24080e7          	jalr	-732(ra) # 5cfa <link>
     fde:	10054363          	bltz	a0,10e4 <linktest+0x188>
  unlink("lf1");
     fe2:	00006517          	auipc	a0,0x6
     fe6:	8de50513          	add	a0,a0,-1826 # 68c0 <malloc+0x704>
     fea:	00005097          	auipc	ra,0x5
     fee:	d00080e7          	jalr	-768(ra) # 5cea <unlink>
  if(open("lf1", 0) >= 0){
     ff2:	4581                	li	a1,0
     ff4:	00006517          	auipc	a0,0x6
     ff8:	8cc50513          	add	a0,a0,-1844 # 68c0 <malloc+0x704>
     ffc:	00005097          	auipc	ra,0x5
    1000:	cde080e7          	jalr	-802(ra) # 5cda <open>
    1004:	0e055e63          	bgez	a0,1100 <linktest+0x1a4>
  fd = open("lf2", 0);
    1008:	4581                	li	a1,0
    100a:	00006517          	auipc	a0,0x6
    100e:	8be50513          	add	a0,a0,-1858 # 68c8 <malloc+0x70c>
    1012:	00005097          	auipc	ra,0x5
    1016:	cc8080e7          	jalr	-824(ra) # 5cda <open>
    101a:	84aa                	mv	s1,a0
  if(fd < 0){
    101c:	10054063          	bltz	a0,111c <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1020:	660d                	lui	a2,0x3
    1022:	0000c597          	auipc	a1,0xc
    1026:	c5658593          	add	a1,a1,-938 # cc78 <buf>
    102a:	00005097          	auipc	ra,0x5
    102e:	c88080e7          	jalr	-888(ra) # 5cb2 <read>
    1032:	4795                	li	a5,5
    1034:	10f51263          	bne	a0,a5,1138 <linktest+0x1dc>
  close(fd);
    1038:	8526                	mv	a0,s1
    103a:	00005097          	auipc	ra,0x5
    103e:	c88080e7          	jalr	-888(ra) # 5cc2 <close>
  if(link("lf2", "lf2") >= 0){
    1042:	00006597          	auipc	a1,0x6
    1046:	88658593          	add	a1,a1,-1914 # 68c8 <malloc+0x70c>
    104a:	852e                	mv	a0,a1
    104c:	00005097          	auipc	ra,0x5
    1050:	cae080e7          	jalr	-850(ra) # 5cfa <link>
    1054:	10055063          	bgez	a0,1154 <linktest+0x1f8>
  unlink("lf2");
    1058:	00006517          	auipc	a0,0x6
    105c:	87050513          	add	a0,a0,-1936 # 68c8 <malloc+0x70c>
    1060:	00005097          	auipc	ra,0x5
    1064:	c8a080e7          	jalr	-886(ra) # 5cea <unlink>
  if(link("lf2", "lf1") >= 0){
    1068:	00006597          	auipc	a1,0x6
    106c:	85858593          	add	a1,a1,-1960 # 68c0 <malloc+0x704>
    1070:	00006517          	auipc	a0,0x6
    1074:	85850513          	add	a0,a0,-1960 # 68c8 <malloc+0x70c>
    1078:	00005097          	auipc	ra,0x5
    107c:	c82080e7          	jalr	-894(ra) # 5cfa <link>
    1080:	0e055863          	bgez	a0,1170 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    1084:	00006597          	auipc	a1,0x6
    1088:	83c58593          	add	a1,a1,-1988 # 68c0 <malloc+0x704>
    108c:	00006517          	auipc	a0,0x6
    1090:	94450513          	add	a0,a0,-1724 # 69d0 <malloc+0x814>
    1094:	00005097          	auipc	ra,0x5
    1098:	c66080e7          	jalr	-922(ra) # 5cfa <link>
    109c:	0e055863          	bgez	a0,118c <linktest+0x230>
}
    10a0:	60e2                	ld	ra,24(sp)
    10a2:	6442                	ld	s0,16(sp)
    10a4:	64a2                	ld	s1,8(sp)
    10a6:	6902                	ld	s2,0(sp)
    10a8:	6105                	add	sp,sp,32
    10aa:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    10ac:	85ca                	mv	a1,s2
    10ae:	00006517          	auipc	a0,0x6
    10b2:	82250513          	add	a0,a0,-2014 # 68d0 <malloc+0x714>
    10b6:	00005097          	auipc	ra,0x5
    10ba:	04e080e7          	jalr	78(ra) # 6104 <printf>
    exit(1);
    10be:	4505                	li	a0,1
    10c0:	00005097          	auipc	ra,0x5
    10c4:	bda080e7          	jalr	-1062(ra) # 5c9a <exit>
    printf("%s: write lf1 failed\n", s);
    10c8:	85ca                	mv	a1,s2
    10ca:	00006517          	auipc	a0,0x6
    10ce:	81e50513          	add	a0,a0,-2018 # 68e8 <malloc+0x72c>
    10d2:	00005097          	auipc	ra,0x5
    10d6:	032080e7          	jalr	50(ra) # 6104 <printf>
    exit(1);
    10da:	4505                	li	a0,1
    10dc:	00005097          	auipc	ra,0x5
    10e0:	bbe080e7          	jalr	-1090(ra) # 5c9a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    10e4:	85ca                	mv	a1,s2
    10e6:	00006517          	auipc	a0,0x6
    10ea:	81a50513          	add	a0,a0,-2022 # 6900 <malloc+0x744>
    10ee:	00005097          	auipc	ra,0x5
    10f2:	016080e7          	jalr	22(ra) # 6104 <printf>
    exit(1);
    10f6:	4505                	li	a0,1
    10f8:	00005097          	auipc	ra,0x5
    10fc:	ba2080e7          	jalr	-1118(ra) # 5c9a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1100:	85ca                	mv	a1,s2
    1102:	00006517          	auipc	a0,0x6
    1106:	81e50513          	add	a0,a0,-2018 # 6920 <malloc+0x764>
    110a:	00005097          	auipc	ra,0x5
    110e:	ffa080e7          	jalr	-6(ra) # 6104 <printf>
    exit(1);
    1112:	4505                	li	a0,1
    1114:	00005097          	auipc	ra,0x5
    1118:	b86080e7          	jalr	-1146(ra) # 5c9a <exit>
    printf("%s: open lf2 failed\n", s);
    111c:	85ca                	mv	a1,s2
    111e:	00006517          	auipc	a0,0x6
    1122:	83250513          	add	a0,a0,-1998 # 6950 <malloc+0x794>
    1126:	00005097          	auipc	ra,0x5
    112a:	fde080e7          	jalr	-34(ra) # 6104 <printf>
    exit(1);
    112e:	4505                	li	a0,1
    1130:	00005097          	auipc	ra,0x5
    1134:	b6a080e7          	jalr	-1174(ra) # 5c9a <exit>
    printf("%s: read lf2 failed\n", s);
    1138:	85ca                	mv	a1,s2
    113a:	00006517          	auipc	a0,0x6
    113e:	82e50513          	add	a0,a0,-2002 # 6968 <malloc+0x7ac>
    1142:	00005097          	auipc	ra,0x5
    1146:	fc2080e7          	jalr	-62(ra) # 6104 <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00005097          	auipc	ra,0x5
    1150:	b4e080e7          	jalr	-1202(ra) # 5c9a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1154:	85ca                	mv	a1,s2
    1156:	00006517          	auipc	a0,0x6
    115a:	82a50513          	add	a0,a0,-2006 # 6980 <malloc+0x7c4>
    115e:	00005097          	auipc	ra,0x5
    1162:	fa6080e7          	jalr	-90(ra) # 6104 <printf>
    exit(1);
    1166:	4505                	li	a0,1
    1168:	00005097          	auipc	ra,0x5
    116c:	b32080e7          	jalr	-1230(ra) # 5c9a <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1170:	85ca                	mv	a1,s2
    1172:	00006517          	auipc	a0,0x6
    1176:	83650513          	add	a0,a0,-1994 # 69a8 <malloc+0x7ec>
    117a:	00005097          	auipc	ra,0x5
    117e:	f8a080e7          	jalr	-118(ra) # 6104 <printf>
    exit(1);
    1182:	4505                	li	a0,1
    1184:	00005097          	auipc	ra,0x5
    1188:	b16080e7          	jalr	-1258(ra) # 5c9a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    118c:	85ca                	mv	a1,s2
    118e:	00006517          	auipc	a0,0x6
    1192:	84a50513          	add	a0,a0,-1974 # 69d8 <malloc+0x81c>
    1196:	00005097          	auipc	ra,0x5
    119a:	f6e080e7          	jalr	-146(ra) # 6104 <printf>
    exit(1);
    119e:	4505                	li	a0,1
    11a0:	00005097          	auipc	ra,0x5
    11a4:	afa080e7          	jalr	-1286(ra) # 5c9a <exit>

00000000000011a8 <validatetest>:
{
    11a8:	7139                	add	sp,sp,-64
    11aa:	fc06                	sd	ra,56(sp)
    11ac:	f822                	sd	s0,48(sp)
    11ae:	f426                	sd	s1,40(sp)
    11b0:	f04a                	sd	s2,32(sp)
    11b2:	ec4e                	sd	s3,24(sp)
    11b4:	e852                	sd	s4,16(sp)
    11b6:	e456                	sd	s5,8(sp)
    11b8:	e05a                	sd	s6,0(sp)
    11ba:	0080                	add	s0,sp,64
    11bc:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11be:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    11c0:	00006997          	auipc	s3,0x6
    11c4:	83898993          	add	s3,s3,-1992 # 69f8 <malloc+0x83c>
    11c8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11ca:	6a85                	lui	s5,0x1
    11cc:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    11d0:	85a6                	mv	a1,s1
    11d2:	854e                	mv	a0,s3
    11d4:	00005097          	auipc	ra,0x5
    11d8:	b26080e7          	jalr	-1242(ra) # 5cfa <link>
    11dc:	01251f63          	bne	a0,s2,11fa <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11e0:	94d6                	add	s1,s1,s5
    11e2:	ff4497e3          	bne	s1,s4,11d0 <validatetest+0x28>
}
    11e6:	70e2                	ld	ra,56(sp)
    11e8:	7442                	ld	s0,48(sp)
    11ea:	74a2                	ld	s1,40(sp)
    11ec:	7902                	ld	s2,32(sp)
    11ee:	69e2                	ld	s3,24(sp)
    11f0:	6a42                	ld	s4,16(sp)
    11f2:	6aa2                	ld	s5,8(sp)
    11f4:	6b02                	ld	s6,0(sp)
    11f6:	6121                	add	sp,sp,64
    11f8:	8082                	ret
      printf("%s: link should not succeed\n", s);
    11fa:	85da                	mv	a1,s6
    11fc:	00006517          	auipc	a0,0x6
    1200:	80c50513          	add	a0,a0,-2036 # 6a08 <malloc+0x84c>
    1204:	00005097          	auipc	ra,0x5
    1208:	f00080e7          	jalr	-256(ra) # 6104 <printf>
      exit(1);
    120c:	4505                	li	a0,1
    120e:	00005097          	auipc	ra,0x5
    1212:	a8c080e7          	jalr	-1396(ra) # 5c9a <exit>

0000000000001216 <bigdir>:
{
    1216:	715d                	add	sp,sp,-80
    1218:	e486                	sd	ra,72(sp)
    121a:	e0a2                	sd	s0,64(sp)
    121c:	fc26                	sd	s1,56(sp)
    121e:	f84a                	sd	s2,48(sp)
    1220:	f44e                	sd	s3,40(sp)
    1222:	f052                	sd	s4,32(sp)
    1224:	ec56                	sd	s5,24(sp)
    1226:	e85a                	sd	s6,16(sp)
    1228:	0880                	add	s0,sp,80
    122a:	89aa                	mv	s3,a0
  unlink("bd");
    122c:	00005517          	auipc	a0,0x5
    1230:	7fc50513          	add	a0,a0,2044 # 6a28 <malloc+0x86c>
    1234:	00005097          	auipc	ra,0x5
    1238:	ab6080e7          	jalr	-1354(ra) # 5cea <unlink>
  fd = open("bd", O_CREATE);
    123c:	20000593          	li	a1,512
    1240:	00005517          	auipc	a0,0x5
    1244:	7e850513          	add	a0,a0,2024 # 6a28 <malloc+0x86c>
    1248:	00005097          	auipc	ra,0x5
    124c:	a92080e7          	jalr	-1390(ra) # 5cda <open>
  if(fd < 0){
    1250:	0c054963          	bltz	a0,1322 <bigdir+0x10c>
  close(fd);
    1254:	00005097          	auipc	ra,0x5
    1258:	a6e080e7          	jalr	-1426(ra) # 5cc2 <close>
  for(i = 0; i < N; i++){
    125c:	4901                	li	s2,0
    name[0] = 'x';
    125e:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1262:	00005a17          	auipc	s4,0x5
    1266:	7c6a0a13          	add	s4,s4,1990 # 6a28 <malloc+0x86c>
  for(i = 0; i < N; i++){
    126a:	1f400b13          	li	s6,500
    name[0] = 'x';
    126e:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1272:	41f9571b          	sraw	a4,s2,0x1f
    1276:	01a7571b          	srlw	a4,a4,0x1a
    127a:	012707bb          	addw	a5,a4,s2
    127e:	4067d69b          	sraw	a3,a5,0x6
    1282:	0306869b          	addw	a3,a3,48
    1286:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    128a:	03f7f793          	and	a5,a5,63
    128e:	9f99                	subw	a5,a5,a4
    1290:	0307879b          	addw	a5,a5,48
    1294:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1298:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    129c:	fb040593          	add	a1,s0,-80
    12a0:	8552                	mv	a0,s4
    12a2:	00005097          	auipc	ra,0x5
    12a6:	a58080e7          	jalr	-1448(ra) # 5cfa <link>
    12aa:	84aa                	mv	s1,a0
    12ac:	e949                	bnez	a0,133e <bigdir+0x128>
  for(i = 0; i < N; i++){
    12ae:	2905                	addw	s2,s2,1
    12b0:	fb691fe3          	bne	s2,s6,126e <bigdir+0x58>
  unlink("bd");
    12b4:	00005517          	auipc	a0,0x5
    12b8:	77450513          	add	a0,a0,1908 # 6a28 <malloc+0x86c>
    12bc:	00005097          	auipc	ra,0x5
    12c0:	a2e080e7          	jalr	-1490(ra) # 5cea <unlink>
    name[0] = 'x';
    12c4:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    12c8:	1f400a13          	li	s4,500
    name[0] = 'x';
    12cc:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    12d0:	41f4d71b          	sraw	a4,s1,0x1f
    12d4:	01a7571b          	srlw	a4,a4,0x1a
    12d8:	009707bb          	addw	a5,a4,s1
    12dc:	4067d69b          	sraw	a3,a5,0x6
    12e0:	0306869b          	addw	a3,a3,48
    12e4:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    12e8:	03f7f793          	and	a5,a5,63
    12ec:	9f99                	subw	a5,a5,a4
    12ee:	0307879b          	addw	a5,a5,48
    12f2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    12f6:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    12fa:	fb040513          	add	a0,s0,-80
    12fe:	00005097          	auipc	ra,0x5
    1302:	9ec080e7          	jalr	-1556(ra) # 5cea <unlink>
    1306:	ed29                	bnez	a0,1360 <bigdir+0x14a>
  for(i = 0; i < N; i++){
    1308:	2485                	addw	s1,s1,1
    130a:	fd4491e3          	bne	s1,s4,12cc <bigdir+0xb6>
}
    130e:	60a6                	ld	ra,72(sp)
    1310:	6406                	ld	s0,64(sp)
    1312:	74e2                	ld	s1,56(sp)
    1314:	7942                	ld	s2,48(sp)
    1316:	79a2                	ld	s3,40(sp)
    1318:	7a02                	ld	s4,32(sp)
    131a:	6ae2                	ld	s5,24(sp)
    131c:	6b42                	ld	s6,16(sp)
    131e:	6161                	add	sp,sp,80
    1320:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1322:	85ce                	mv	a1,s3
    1324:	00005517          	auipc	a0,0x5
    1328:	70c50513          	add	a0,a0,1804 # 6a30 <malloc+0x874>
    132c:	00005097          	auipc	ra,0x5
    1330:	dd8080e7          	jalr	-552(ra) # 6104 <printf>
    exit(1);
    1334:	4505                	li	a0,1
    1336:	00005097          	auipc	ra,0x5
    133a:	964080e7          	jalr	-1692(ra) # 5c9a <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    133e:	fb040693          	add	a3,s0,-80
    1342:	864a                	mv	a2,s2
    1344:	85ce                	mv	a1,s3
    1346:	00005517          	auipc	a0,0x5
    134a:	70a50513          	add	a0,a0,1802 # 6a50 <malloc+0x894>
    134e:	00005097          	auipc	ra,0x5
    1352:	db6080e7          	jalr	-586(ra) # 6104 <printf>
      exit(1);
    1356:	4505                	li	a0,1
    1358:	00005097          	auipc	ra,0x5
    135c:	942080e7          	jalr	-1726(ra) # 5c9a <exit>
      printf("%s: bigdir unlink failed", s);
    1360:	85ce                	mv	a1,s3
    1362:	00005517          	auipc	a0,0x5
    1366:	71650513          	add	a0,a0,1814 # 6a78 <malloc+0x8bc>
    136a:	00005097          	auipc	ra,0x5
    136e:	d9a080e7          	jalr	-614(ra) # 6104 <printf>
      exit(1);
    1372:	4505                	li	a0,1
    1374:	00005097          	auipc	ra,0x5
    1378:	926080e7          	jalr	-1754(ra) # 5c9a <exit>

000000000000137c <pgbug>:
{
    137c:	7179                	add	sp,sp,-48
    137e:	f406                	sd	ra,40(sp)
    1380:	f022                	sd	s0,32(sp)
    1382:	ec26                	sd	s1,24(sp)
    1384:	1800                	add	s0,sp,48
  argv[0] = 0;
    1386:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    138a:	00008497          	auipc	s1,0x8
    138e:	c7648493          	add	s1,s1,-906 # 9000 <big>
    1392:	fd840593          	add	a1,s0,-40
    1396:	6088                	ld	a0,0(s1)
    1398:	00005097          	auipc	ra,0x5
    139c:	93a080e7          	jalr	-1734(ra) # 5cd2 <exec>
  pipe(big);
    13a0:	6088                	ld	a0,0(s1)
    13a2:	00005097          	auipc	ra,0x5
    13a6:	908080e7          	jalr	-1784(ra) # 5caa <pipe>
  exit(0);
    13aa:	4501                	li	a0,0
    13ac:	00005097          	auipc	ra,0x5
    13b0:	8ee080e7          	jalr	-1810(ra) # 5c9a <exit>

00000000000013b4 <badarg>:
{
    13b4:	7139                	add	sp,sp,-64
    13b6:	fc06                	sd	ra,56(sp)
    13b8:	f822                	sd	s0,48(sp)
    13ba:	f426                	sd	s1,40(sp)
    13bc:	f04a                	sd	s2,32(sp)
    13be:	ec4e                	sd	s3,24(sp)
    13c0:	0080                	add	s0,sp,64
    13c2:	64b1                	lui	s1,0xc
    13c4:	35048493          	add	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    13c8:	597d                	li	s2,-1
    13ca:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    13ce:	00005997          	auipc	s3,0x5
    13d2:	f1a98993          	add	s3,s3,-230 # 62e8 <malloc+0x12c>
    argv[0] = (char*)0xffffffff;
    13d6:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    13da:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    13de:	fc040593          	add	a1,s0,-64
    13e2:	854e                	mv	a0,s3
    13e4:	00005097          	auipc	ra,0x5
    13e8:	8ee080e7          	jalr	-1810(ra) # 5cd2 <exec>
  for(int i = 0; i < 50000; i++){
    13ec:	34fd                	addw	s1,s1,-1
    13ee:	f4e5                	bnez	s1,13d6 <badarg+0x22>
  exit(0);
    13f0:	4501                	li	a0,0
    13f2:	00005097          	auipc	ra,0x5
    13f6:	8a8080e7          	jalr	-1880(ra) # 5c9a <exit>

00000000000013fa <copyinstr2>:
{
    13fa:	7155                	add	sp,sp,-208
    13fc:	e586                	sd	ra,200(sp)
    13fe:	e1a2                	sd	s0,192(sp)
    1400:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1402:	f6840793          	add	a5,s0,-152
    1406:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    140a:	07800713          	li	a4,120
    140e:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1412:	0785                	add	a5,a5,1
    1414:	fed79de3          	bne	a5,a3,140e <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1418:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    141c:	f6840513          	add	a0,s0,-152
    1420:	00005097          	auipc	ra,0x5
    1424:	8ca080e7          	jalr	-1846(ra) # 5cea <unlink>
  if(ret != -1){
    1428:	57fd                	li	a5,-1
    142a:	0ef51063          	bne	a0,a5,150a <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    142e:	20100593          	li	a1,513
    1432:	f6840513          	add	a0,s0,-152
    1436:	00005097          	auipc	ra,0x5
    143a:	8a4080e7          	jalr	-1884(ra) # 5cda <open>
  if(fd != -1){
    143e:	57fd                	li	a5,-1
    1440:	0ef51563          	bne	a0,a5,152a <copyinstr2+0x130>
  ret = link(b, b);
    1444:	f6840593          	add	a1,s0,-152
    1448:	852e                	mv	a0,a1
    144a:	00005097          	auipc	ra,0x5
    144e:	8b0080e7          	jalr	-1872(ra) # 5cfa <link>
  if(ret != -1){
    1452:	57fd                	li	a5,-1
    1454:	0ef51b63          	bne	a0,a5,154a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1458:	00006797          	auipc	a5,0x6
    145c:	77078793          	add	a5,a5,1904 # 7bc8 <malloc+0x1a0c>
    1460:	f4f43c23          	sd	a5,-168(s0)
    1464:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1468:	f5840593          	add	a1,s0,-168
    146c:	f6840513          	add	a0,s0,-152
    1470:	00005097          	auipc	ra,0x5
    1474:	862080e7          	jalr	-1950(ra) # 5cd2 <exec>
  if(ret != -1){
    1478:	57fd                	li	a5,-1
    147a:	0ef51963          	bne	a0,a5,156c <copyinstr2+0x172>
  int pid = fork();
    147e:	00005097          	auipc	ra,0x5
    1482:	814080e7          	jalr	-2028(ra) # 5c92 <fork>
  if(pid < 0){
    1486:	10054363          	bltz	a0,158c <copyinstr2+0x192>
  if(pid == 0){
    148a:	12051463          	bnez	a0,15b2 <copyinstr2+0x1b8>
    148e:	00008797          	auipc	a5,0x8
    1492:	0d278793          	add	a5,a5,210 # 9560 <big.0>
    1496:	00009697          	auipc	a3,0x9
    149a:	0ca68693          	add	a3,a3,202 # a560 <big.0+0x1000>
      big[i] = 'x';
    149e:	07800713          	li	a4,120
    14a2:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    14a6:	0785                	add	a5,a5,1
    14a8:	fed79de3          	bne	a5,a3,14a2 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    14ac:	00009797          	auipc	a5,0x9
    14b0:	0a078a23          	sb	zero,180(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    14b4:	00007797          	auipc	a5,0x7
    14b8:	18c78793          	add	a5,a5,396 # 8640 <malloc+0x2484>
    14bc:	6fb0                	ld	a2,88(a5)
    14be:	73b4                	ld	a3,96(a5)
    14c0:	77b8                	ld	a4,104(a5)
    14c2:	7bbc                	ld	a5,112(a5)
    14c4:	f2c43823          	sd	a2,-208(s0)
    14c8:	f2d43c23          	sd	a3,-200(s0)
    14cc:	f4e43023          	sd	a4,-192(s0)
    14d0:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    14d4:	f3040593          	add	a1,s0,-208
    14d8:	00005517          	auipc	a0,0x5
    14dc:	e1050513          	add	a0,a0,-496 # 62e8 <malloc+0x12c>
    14e0:	00004097          	auipc	ra,0x4
    14e4:	7f2080e7          	jalr	2034(ra) # 5cd2 <exec>
    if(ret != -1){
    14e8:	57fd                	li	a5,-1
    14ea:	0af50e63          	beq	a0,a5,15a6 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    14ee:	55fd                	li	a1,-1
    14f0:	00005517          	auipc	a0,0x5
    14f4:	63050513          	add	a0,a0,1584 # 6b20 <malloc+0x964>
    14f8:	00005097          	auipc	ra,0x5
    14fc:	c0c080e7          	jalr	-1012(ra) # 6104 <printf>
      exit(1);
    1500:	4505                	li	a0,1
    1502:	00004097          	auipc	ra,0x4
    1506:	798080e7          	jalr	1944(ra) # 5c9a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    150a:	862a                	mv	a2,a0
    150c:	f6840593          	add	a1,s0,-152
    1510:	00005517          	auipc	a0,0x5
    1514:	58850513          	add	a0,a0,1416 # 6a98 <malloc+0x8dc>
    1518:	00005097          	auipc	ra,0x5
    151c:	bec080e7          	jalr	-1044(ra) # 6104 <printf>
    exit(1);
    1520:	4505                	li	a0,1
    1522:	00004097          	auipc	ra,0x4
    1526:	778080e7          	jalr	1912(ra) # 5c9a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    152a:	862a                	mv	a2,a0
    152c:	f6840593          	add	a1,s0,-152
    1530:	00005517          	auipc	a0,0x5
    1534:	58850513          	add	a0,a0,1416 # 6ab8 <malloc+0x8fc>
    1538:	00005097          	auipc	ra,0x5
    153c:	bcc080e7          	jalr	-1076(ra) # 6104 <printf>
    exit(1);
    1540:	4505                	li	a0,1
    1542:	00004097          	auipc	ra,0x4
    1546:	758080e7          	jalr	1880(ra) # 5c9a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    154a:	86aa                	mv	a3,a0
    154c:	f6840613          	add	a2,s0,-152
    1550:	85b2                	mv	a1,a2
    1552:	00005517          	auipc	a0,0x5
    1556:	58650513          	add	a0,a0,1414 # 6ad8 <malloc+0x91c>
    155a:	00005097          	auipc	ra,0x5
    155e:	baa080e7          	jalr	-1110(ra) # 6104 <printf>
    exit(1);
    1562:	4505                	li	a0,1
    1564:	00004097          	auipc	ra,0x4
    1568:	736080e7          	jalr	1846(ra) # 5c9a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    156c:	567d                	li	a2,-1
    156e:	f6840593          	add	a1,s0,-152
    1572:	00005517          	auipc	a0,0x5
    1576:	58e50513          	add	a0,a0,1422 # 6b00 <malloc+0x944>
    157a:	00005097          	auipc	ra,0x5
    157e:	b8a080e7          	jalr	-1142(ra) # 6104 <printf>
    exit(1);
    1582:	4505                	li	a0,1
    1584:	00004097          	auipc	ra,0x4
    1588:	716080e7          	jalr	1814(ra) # 5c9a <exit>
    printf("fork failed\n");
    158c:	00007517          	auipc	a0,0x7
    1590:	b5c50513          	add	a0,a0,-1188 # 80e8 <malloc+0x1f2c>
    1594:	00005097          	auipc	ra,0x5
    1598:	b70080e7          	jalr	-1168(ra) # 6104 <printf>
    exit(1);
    159c:	4505                	li	a0,1
    159e:	00004097          	auipc	ra,0x4
    15a2:	6fc080e7          	jalr	1788(ra) # 5c9a <exit>
    exit(747); /* OK */
    15a6:	2eb00513          	li	a0,747
    15aa:	00004097          	auipc	ra,0x4
    15ae:	6f0080e7          	jalr	1776(ra) # 5c9a <exit>
  int st = 0;
    15b2:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    15b6:	f5440513          	add	a0,s0,-172
    15ba:	00004097          	auipc	ra,0x4
    15be:	6e8080e7          	jalr	1768(ra) # 5ca2 <wait>
  if(st != 747){
    15c2:	f5442703          	lw	a4,-172(s0)
    15c6:	2eb00793          	li	a5,747
    15ca:	00f71663          	bne	a4,a5,15d6 <copyinstr2+0x1dc>
}
    15ce:	60ae                	ld	ra,200(sp)
    15d0:	640e                	ld	s0,192(sp)
    15d2:	6169                	add	sp,sp,208
    15d4:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    15d6:	00005517          	auipc	a0,0x5
    15da:	57250513          	add	a0,a0,1394 # 6b48 <malloc+0x98c>
    15de:	00005097          	auipc	ra,0x5
    15e2:	b26080e7          	jalr	-1242(ra) # 6104 <printf>
    exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00004097          	auipc	ra,0x4
    15ec:	6b2080e7          	jalr	1714(ra) # 5c9a <exit>

00000000000015f0 <truncate3>:
{
    15f0:	7159                	add	sp,sp,-112
    15f2:	f486                	sd	ra,104(sp)
    15f4:	f0a2                	sd	s0,96(sp)
    15f6:	eca6                	sd	s1,88(sp)
    15f8:	e8ca                	sd	s2,80(sp)
    15fa:	e4ce                	sd	s3,72(sp)
    15fc:	e0d2                	sd	s4,64(sp)
    15fe:	fc56                	sd	s5,56(sp)
    1600:	1880                	add	s0,sp,112
    1602:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1604:	60100593          	li	a1,1537
    1608:	00005517          	auipc	a0,0x5
    160c:	d3850513          	add	a0,a0,-712 # 6340 <malloc+0x184>
    1610:	00004097          	auipc	ra,0x4
    1614:	6ca080e7          	jalr	1738(ra) # 5cda <open>
    1618:	00004097          	auipc	ra,0x4
    161c:	6aa080e7          	jalr	1706(ra) # 5cc2 <close>
  pid = fork();
    1620:	00004097          	auipc	ra,0x4
    1624:	672080e7          	jalr	1650(ra) # 5c92 <fork>
  if(pid < 0){
    1628:	08054063          	bltz	a0,16a8 <truncate3+0xb8>
  if(pid == 0){
    162c:	e969                	bnez	a0,16fe <truncate3+0x10e>
    162e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1632:	00005a17          	auipc	s4,0x5
    1636:	d0ea0a13          	add	s4,s4,-754 # 6340 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    163a:	00005a97          	auipc	s5,0x5
    163e:	56ea8a93          	add	s5,s5,1390 # 6ba8 <malloc+0x9ec>
      int fd = open("truncfile", O_WRONLY);
    1642:	4585                	li	a1,1
    1644:	8552                	mv	a0,s4
    1646:	00004097          	auipc	ra,0x4
    164a:	694080e7          	jalr	1684(ra) # 5cda <open>
    164e:	84aa                	mv	s1,a0
      if(fd < 0){
    1650:	06054a63          	bltz	a0,16c4 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1654:	4629                	li	a2,10
    1656:	85d6                	mv	a1,s5
    1658:	00004097          	auipc	ra,0x4
    165c:	662080e7          	jalr	1634(ra) # 5cba <write>
      if(n != 10){
    1660:	47a9                	li	a5,10
    1662:	06f51f63          	bne	a0,a5,16e0 <truncate3+0xf0>
      close(fd);
    1666:	8526                	mv	a0,s1
    1668:	00004097          	auipc	ra,0x4
    166c:	65a080e7          	jalr	1626(ra) # 5cc2 <close>
      fd = open("truncfile", O_RDONLY);
    1670:	4581                	li	a1,0
    1672:	8552                	mv	a0,s4
    1674:	00004097          	auipc	ra,0x4
    1678:	666080e7          	jalr	1638(ra) # 5cda <open>
    167c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    167e:	02000613          	li	a2,32
    1682:	f9840593          	add	a1,s0,-104
    1686:	00004097          	auipc	ra,0x4
    168a:	62c080e7          	jalr	1580(ra) # 5cb2 <read>
      close(fd);
    168e:	8526                	mv	a0,s1
    1690:	00004097          	auipc	ra,0x4
    1694:	632080e7          	jalr	1586(ra) # 5cc2 <close>
    for(int i = 0; i < 100; i++){
    1698:	39fd                	addw	s3,s3,-1
    169a:	fa0994e3          	bnez	s3,1642 <truncate3+0x52>
    exit(0);
    169e:	4501                	li	a0,0
    16a0:	00004097          	auipc	ra,0x4
    16a4:	5fa080e7          	jalr	1530(ra) # 5c9a <exit>
    printf("%s: fork failed\n", s);
    16a8:	85ca                	mv	a1,s2
    16aa:	00005517          	auipc	a0,0x5
    16ae:	4ce50513          	add	a0,a0,1230 # 6b78 <malloc+0x9bc>
    16b2:	00005097          	auipc	ra,0x5
    16b6:	a52080e7          	jalr	-1454(ra) # 6104 <printf>
    exit(1);
    16ba:	4505                	li	a0,1
    16bc:	00004097          	auipc	ra,0x4
    16c0:	5de080e7          	jalr	1502(ra) # 5c9a <exit>
        printf("%s: open failed\n", s);
    16c4:	85ca                	mv	a1,s2
    16c6:	00005517          	auipc	a0,0x5
    16ca:	4ca50513          	add	a0,a0,1226 # 6b90 <malloc+0x9d4>
    16ce:	00005097          	auipc	ra,0x5
    16d2:	a36080e7          	jalr	-1482(ra) # 6104 <printf>
        exit(1);
    16d6:	4505                	li	a0,1
    16d8:	00004097          	auipc	ra,0x4
    16dc:	5c2080e7          	jalr	1474(ra) # 5c9a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    16e0:	862a                	mv	a2,a0
    16e2:	85ca                	mv	a1,s2
    16e4:	00005517          	auipc	a0,0x5
    16e8:	4d450513          	add	a0,a0,1236 # 6bb8 <malloc+0x9fc>
    16ec:	00005097          	auipc	ra,0x5
    16f0:	a18080e7          	jalr	-1512(ra) # 6104 <printf>
        exit(1);
    16f4:	4505                	li	a0,1
    16f6:	00004097          	auipc	ra,0x4
    16fa:	5a4080e7          	jalr	1444(ra) # 5c9a <exit>
    16fe:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1702:	00005a17          	auipc	s4,0x5
    1706:	c3ea0a13          	add	s4,s4,-962 # 6340 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    170a:	00005a97          	auipc	s5,0x5
    170e:	4cea8a93          	add	s5,s5,1230 # 6bd8 <malloc+0xa1c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1712:	60100593          	li	a1,1537
    1716:	8552                	mv	a0,s4
    1718:	00004097          	auipc	ra,0x4
    171c:	5c2080e7          	jalr	1474(ra) # 5cda <open>
    1720:	84aa                	mv	s1,a0
    if(fd < 0){
    1722:	04054763          	bltz	a0,1770 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    1726:	460d                	li	a2,3
    1728:	85d6                	mv	a1,s5
    172a:	00004097          	auipc	ra,0x4
    172e:	590080e7          	jalr	1424(ra) # 5cba <write>
    if(n != 3){
    1732:	478d                	li	a5,3
    1734:	04f51c63          	bne	a0,a5,178c <truncate3+0x19c>
    close(fd);
    1738:	8526                	mv	a0,s1
    173a:	00004097          	auipc	ra,0x4
    173e:	588080e7          	jalr	1416(ra) # 5cc2 <close>
  for(int i = 0; i < 150; i++){
    1742:	39fd                	addw	s3,s3,-1
    1744:	fc0997e3          	bnez	s3,1712 <truncate3+0x122>
  wait(&xstatus);
    1748:	fbc40513          	add	a0,s0,-68
    174c:	00004097          	auipc	ra,0x4
    1750:	556080e7          	jalr	1366(ra) # 5ca2 <wait>
  unlink("truncfile");
    1754:	00005517          	auipc	a0,0x5
    1758:	bec50513          	add	a0,a0,-1044 # 6340 <malloc+0x184>
    175c:	00004097          	auipc	ra,0x4
    1760:	58e080e7          	jalr	1422(ra) # 5cea <unlink>
  exit(xstatus);
    1764:	fbc42503          	lw	a0,-68(s0)
    1768:	00004097          	auipc	ra,0x4
    176c:	532080e7          	jalr	1330(ra) # 5c9a <exit>
      printf("%s: open failed\n", s);
    1770:	85ca                	mv	a1,s2
    1772:	00005517          	auipc	a0,0x5
    1776:	41e50513          	add	a0,a0,1054 # 6b90 <malloc+0x9d4>
    177a:	00005097          	auipc	ra,0x5
    177e:	98a080e7          	jalr	-1654(ra) # 6104 <printf>
      exit(1);
    1782:	4505                	li	a0,1
    1784:	00004097          	auipc	ra,0x4
    1788:	516080e7          	jalr	1302(ra) # 5c9a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    178c:	862a                	mv	a2,a0
    178e:	85ca                	mv	a1,s2
    1790:	00005517          	auipc	a0,0x5
    1794:	45050513          	add	a0,a0,1104 # 6be0 <malloc+0xa24>
    1798:	00005097          	auipc	ra,0x5
    179c:	96c080e7          	jalr	-1684(ra) # 6104 <printf>
      exit(1);
    17a0:	4505                	li	a0,1
    17a2:	00004097          	auipc	ra,0x4
    17a6:	4f8080e7          	jalr	1272(ra) # 5c9a <exit>

00000000000017aa <exectest>:
{
    17aa:	715d                	add	sp,sp,-80
    17ac:	e486                	sd	ra,72(sp)
    17ae:	e0a2                	sd	s0,64(sp)
    17b0:	fc26                	sd	s1,56(sp)
    17b2:	f84a                	sd	s2,48(sp)
    17b4:	0880                	add	s0,sp,80
    17b6:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    17b8:	00005797          	auipc	a5,0x5
    17bc:	b3078793          	add	a5,a5,-1232 # 62e8 <malloc+0x12c>
    17c0:	fcf43023          	sd	a5,-64(s0)
    17c4:	00005797          	auipc	a5,0x5
    17c8:	43c78793          	add	a5,a5,1084 # 6c00 <malloc+0xa44>
    17cc:	fcf43423          	sd	a5,-56(s0)
    17d0:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    17d4:	00005517          	auipc	a0,0x5
    17d8:	43450513          	add	a0,a0,1076 # 6c08 <malloc+0xa4c>
    17dc:	00004097          	auipc	ra,0x4
    17e0:	50e080e7          	jalr	1294(ra) # 5cea <unlink>
  pid = fork();
    17e4:	00004097          	auipc	ra,0x4
    17e8:	4ae080e7          	jalr	1198(ra) # 5c92 <fork>
  if(pid < 0) {
    17ec:	04054663          	bltz	a0,1838 <exectest+0x8e>
    17f0:	84aa                	mv	s1,a0
  if(pid == 0) {
    17f2:	e959                	bnez	a0,1888 <exectest+0xde>
    close(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	4cc080e7          	jalr	1228(ra) # 5cc2 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17fe:	20100593          	li	a1,513
    1802:	00005517          	auipc	a0,0x5
    1806:	40650513          	add	a0,a0,1030 # 6c08 <malloc+0xa4c>
    180a:	00004097          	auipc	ra,0x4
    180e:	4d0080e7          	jalr	1232(ra) # 5cda <open>
    if(fd < 0) {
    1812:	04054163          	bltz	a0,1854 <exectest+0xaa>
    if(fd != 1) {
    1816:	4785                	li	a5,1
    1818:	04f50c63          	beq	a0,a5,1870 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    181c:	85ca                	mv	a1,s2
    181e:	00005517          	auipc	a0,0x5
    1822:	40a50513          	add	a0,a0,1034 # 6c28 <malloc+0xa6c>
    1826:	00005097          	auipc	ra,0x5
    182a:	8de080e7          	jalr	-1826(ra) # 6104 <printf>
      exit(1);
    182e:	4505                	li	a0,1
    1830:	00004097          	auipc	ra,0x4
    1834:	46a080e7          	jalr	1130(ra) # 5c9a <exit>
     printf("%s: fork failed\n", s);
    1838:	85ca                	mv	a1,s2
    183a:	00005517          	auipc	a0,0x5
    183e:	33e50513          	add	a0,a0,830 # 6b78 <malloc+0x9bc>
    1842:	00005097          	auipc	ra,0x5
    1846:	8c2080e7          	jalr	-1854(ra) # 6104 <printf>
     exit(1);
    184a:	4505                	li	a0,1
    184c:	00004097          	auipc	ra,0x4
    1850:	44e080e7          	jalr	1102(ra) # 5c9a <exit>
      printf("%s: create failed\n", s);
    1854:	85ca                	mv	a1,s2
    1856:	00005517          	auipc	a0,0x5
    185a:	3ba50513          	add	a0,a0,954 # 6c10 <malloc+0xa54>
    185e:	00005097          	auipc	ra,0x5
    1862:	8a6080e7          	jalr	-1882(ra) # 6104 <printf>
      exit(1);
    1866:	4505                	li	a0,1
    1868:	00004097          	auipc	ra,0x4
    186c:	432080e7          	jalr	1074(ra) # 5c9a <exit>
    if(exec("echo", echoargv) < 0){
    1870:	fc040593          	add	a1,s0,-64
    1874:	00005517          	auipc	a0,0x5
    1878:	a7450513          	add	a0,a0,-1420 # 62e8 <malloc+0x12c>
    187c:	00004097          	auipc	ra,0x4
    1880:	456080e7          	jalr	1110(ra) # 5cd2 <exec>
    1884:	02054163          	bltz	a0,18a6 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1888:	fdc40513          	add	a0,s0,-36
    188c:	00004097          	auipc	ra,0x4
    1890:	416080e7          	jalr	1046(ra) # 5ca2 <wait>
    1894:	02951763          	bne	a0,s1,18c2 <exectest+0x118>
  if(xstatus != 0)
    1898:	fdc42503          	lw	a0,-36(s0)
    189c:	cd0d                	beqz	a0,18d6 <exectest+0x12c>
    exit(xstatus);
    189e:	00004097          	auipc	ra,0x4
    18a2:	3fc080e7          	jalr	1020(ra) # 5c9a <exit>
      printf("%s: exec echo failed\n", s);
    18a6:	85ca                	mv	a1,s2
    18a8:	00005517          	auipc	a0,0x5
    18ac:	39050513          	add	a0,a0,912 # 6c38 <malloc+0xa7c>
    18b0:	00005097          	auipc	ra,0x5
    18b4:	854080e7          	jalr	-1964(ra) # 6104 <printf>
      exit(1);
    18b8:	4505                	li	a0,1
    18ba:	00004097          	auipc	ra,0x4
    18be:	3e0080e7          	jalr	992(ra) # 5c9a <exit>
    printf("%s: wait failed!\n", s);
    18c2:	85ca                	mv	a1,s2
    18c4:	00005517          	auipc	a0,0x5
    18c8:	38c50513          	add	a0,a0,908 # 6c50 <malloc+0xa94>
    18cc:	00005097          	auipc	ra,0x5
    18d0:	838080e7          	jalr	-1992(ra) # 6104 <printf>
    18d4:	b7d1                	j	1898 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    18d6:	4581                	li	a1,0
    18d8:	00005517          	auipc	a0,0x5
    18dc:	33050513          	add	a0,a0,816 # 6c08 <malloc+0xa4c>
    18e0:	00004097          	auipc	ra,0x4
    18e4:	3fa080e7          	jalr	1018(ra) # 5cda <open>
  if(fd < 0) {
    18e8:	02054a63          	bltz	a0,191c <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    18ec:	4609                	li	a2,2
    18ee:	fb840593          	add	a1,s0,-72
    18f2:	00004097          	auipc	ra,0x4
    18f6:	3c0080e7          	jalr	960(ra) # 5cb2 <read>
    18fa:	4789                	li	a5,2
    18fc:	02f50e63          	beq	a0,a5,1938 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1900:	85ca                	mv	a1,s2
    1902:	00005517          	auipc	a0,0x5
    1906:	db650513          	add	a0,a0,-586 # 66b8 <malloc+0x4fc>
    190a:	00004097          	auipc	ra,0x4
    190e:	7fa080e7          	jalr	2042(ra) # 6104 <printf>
    exit(1);
    1912:	4505                	li	a0,1
    1914:	00004097          	auipc	ra,0x4
    1918:	386080e7          	jalr	902(ra) # 5c9a <exit>
    printf("%s: open failed\n", s);
    191c:	85ca                	mv	a1,s2
    191e:	00005517          	auipc	a0,0x5
    1922:	27250513          	add	a0,a0,626 # 6b90 <malloc+0x9d4>
    1926:	00004097          	auipc	ra,0x4
    192a:	7de080e7          	jalr	2014(ra) # 6104 <printf>
    exit(1);
    192e:	4505                	li	a0,1
    1930:	00004097          	auipc	ra,0x4
    1934:	36a080e7          	jalr	874(ra) # 5c9a <exit>
  unlink("echo-ok");
    1938:	00005517          	auipc	a0,0x5
    193c:	2d050513          	add	a0,a0,720 # 6c08 <malloc+0xa4c>
    1940:	00004097          	auipc	ra,0x4
    1944:	3aa080e7          	jalr	938(ra) # 5cea <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1948:	fb844703          	lbu	a4,-72(s0)
    194c:	04f00793          	li	a5,79
    1950:	00f71863          	bne	a4,a5,1960 <exectest+0x1b6>
    1954:	fb944703          	lbu	a4,-71(s0)
    1958:	04b00793          	li	a5,75
    195c:	02f70063          	beq	a4,a5,197c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1960:	85ca                	mv	a1,s2
    1962:	00005517          	auipc	a0,0x5
    1966:	30650513          	add	a0,a0,774 # 6c68 <malloc+0xaac>
    196a:	00004097          	auipc	ra,0x4
    196e:	79a080e7          	jalr	1946(ra) # 6104 <printf>
    exit(1);
    1972:	4505                	li	a0,1
    1974:	00004097          	auipc	ra,0x4
    1978:	326080e7          	jalr	806(ra) # 5c9a <exit>
    exit(0);
    197c:	4501                	li	a0,0
    197e:	00004097          	auipc	ra,0x4
    1982:	31c080e7          	jalr	796(ra) # 5c9a <exit>

0000000000001986 <pipe1>:
{
    1986:	711d                	add	sp,sp,-96
    1988:	ec86                	sd	ra,88(sp)
    198a:	e8a2                	sd	s0,80(sp)
    198c:	e4a6                	sd	s1,72(sp)
    198e:	e0ca                	sd	s2,64(sp)
    1990:	fc4e                	sd	s3,56(sp)
    1992:	f852                	sd	s4,48(sp)
    1994:	f456                	sd	s5,40(sp)
    1996:	f05a                	sd	s6,32(sp)
    1998:	ec5e                	sd	s7,24(sp)
    199a:	1080                	add	s0,sp,96
    199c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    199e:	fa840513          	add	a0,s0,-88
    19a2:	00004097          	auipc	ra,0x4
    19a6:	308080e7          	jalr	776(ra) # 5caa <pipe>
    19aa:	e93d                	bnez	a0,1a20 <pipe1+0x9a>
    19ac:	84aa                	mv	s1,a0
  pid = fork();
    19ae:	00004097          	auipc	ra,0x4
    19b2:	2e4080e7          	jalr	740(ra) # 5c92 <fork>
    19b6:	8a2a                	mv	s4,a0
  if(pid == 0){
    19b8:	c151                	beqz	a0,1a3c <pipe1+0xb6>
  } else if(pid > 0){
    19ba:	16a05e63          	blez	a0,1b36 <pipe1+0x1b0>
    close(fds[1]);
    19be:	fac42503          	lw	a0,-84(s0)
    19c2:	00004097          	auipc	ra,0x4
    19c6:	300080e7          	jalr	768(ra) # 5cc2 <close>
    total = 0;
    19ca:	8a26                	mv	s4,s1
    cc = 1;
    19cc:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    19ce:	0000ba97          	auipc	s5,0xb
    19d2:	2aaa8a93          	add	s5,s5,682 # cc78 <buf>
    19d6:	864e                	mv	a2,s3
    19d8:	85d6                	mv	a1,s5
    19da:	fa842503          	lw	a0,-88(s0)
    19de:	00004097          	auipc	ra,0x4
    19e2:	2d4080e7          	jalr	724(ra) # 5cb2 <read>
    19e6:	10a05263          	blez	a0,1aea <pipe1+0x164>
      for(i = 0; i < n; i++){
    19ea:	0000b717          	auipc	a4,0xb
    19ee:	28e70713          	add	a4,a4,654 # cc78 <buf>
    19f2:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19f6:	00074683          	lbu	a3,0(a4)
    19fa:	0ff4f793          	zext.b	a5,s1
    19fe:	2485                	addw	s1,s1,1
    1a00:	0cf69163          	bne	a3,a5,1ac2 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    1a04:	0705                	add	a4,a4,1
    1a06:	fec498e3          	bne	s1,a2,19f6 <pipe1+0x70>
      total += n;
    1a0a:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1a0e:	0019979b          	sllw	a5,s3,0x1
    1a12:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1a16:	670d                	lui	a4,0x3
    1a18:	fb377fe3          	bgeu	a4,s3,19d6 <pipe1+0x50>
        cc = sizeof(buf);
    1a1c:	698d                	lui	s3,0x3
    1a1e:	bf65                	j	19d6 <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    1a20:	85ca                	mv	a1,s2
    1a22:	00005517          	auipc	a0,0x5
    1a26:	25e50513          	add	a0,a0,606 # 6c80 <malloc+0xac4>
    1a2a:	00004097          	auipc	ra,0x4
    1a2e:	6da080e7          	jalr	1754(ra) # 6104 <printf>
    exit(1);
    1a32:	4505                	li	a0,1
    1a34:	00004097          	auipc	ra,0x4
    1a38:	266080e7          	jalr	614(ra) # 5c9a <exit>
    close(fds[0]);
    1a3c:	fa842503          	lw	a0,-88(s0)
    1a40:	00004097          	auipc	ra,0x4
    1a44:	282080e7          	jalr	642(ra) # 5cc2 <close>
    for(n = 0; n < N; n++){
    1a48:	0000bb17          	auipc	s6,0xb
    1a4c:	230b0b13          	add	s6,s6,560 # cc78 <buf>
    1a50:	416004bb          	negw	s1,s6
    1a54:	0ff4f493          	zext.b	s1,s1
    1a58:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a5c:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a5e:	6a85                	lui	s5,0x1
    1a60:	42da8a93          	add	s5,s5,1069 # 142d <copyinstr2+0x33>
{
    1a64:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a66:	0097873b          	addw	a4,a5,s1
    1a6a:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a6e:	0785                	add	a5,a5,1
    1a70:	fef99be3          	bne	s3,a5,1a66 <pipe1+0xe0>
        buf[i] = seq++;
    1a74:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a78:	40900613          	li	a2,1033
    1a7c:	85de                	mv	a1,s7
    1a7e:	fac42503          	lw	a0,-84(s0)
    1a82:	00004097          	auipc	ra,0x4
    1a86:	238080e7          	jalr	568(ra) # 5cba <write>
    1a8a:	40900793          	li	a5,1033
    1a8e:	00f51c63          	bne	a0,a5,1aa6 <pipe1+0x120>
    for(n = 0; n < N; n++){
    1a92:	24a5                	addw	s1,s1,9
    1a94:	0ff4f493          	zext.b	s1,s1
    1a98:	fd5a16e3          	bne	s4,s5,1a64 <pipe1+0xde>
    exit(0);
    1a9c:	4501                	li	a0,0
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	1fc080e7          	jalr	508(ra) # 5c9a <exit>
        printf("%s: pipe1 oops 1\n", s);
    1aa6:	85ca                	mv	a1,s2
    1aa8:	00005517          	auipc	a0,0x5
    1aac:	1f050513          	add	a0,a0,496 # 6c98 <malloc+0xadc>
    1ab0:	00004097          	auipc	ra,0x4
    1ab4:	654080e7          	jalr	1620(ra) # 6104 <printf>
        exit(1);
    1ab8:	4505                	li	a0,1
    1aba:	00004097          	auipc	ra,0x4
    1abe:	1e0080e7          	jalr	480(ra) # 5c9a <exit>
          printf("%s: pipe1 oops 2\n", s);
    1ac2:	85ca                	mv	a1,s2
    1ac4:	00005517          	auipc	a0,0x5
    1ac8:	1ec50513          	add	a0,a0,492 # 6cb0 <malloc+0xaf4>
    1acc:	00004097          	auipc	ra,0x4
    1ad0:	638080e7          	jalr	1592(ra) # 6104 <printf>
}
    1ad4:	60e6                	ld	ra,88(sp)
    1ad6:	6446                	ld	s0,80(sp)
    1ad8:	64a6                	ld	s1,72(sp)
    1ada:	6906                	ld	s2,64(sp)
    1adc:	79e2                	ld	s3,56(sp)
    1ade:	7a42                	ld	s4,48(sp)
    1ae0:	7aa2                	ld	s5,40(sp)
    1ae2:	7b02                	ld	s6,32(sp)
    1ae4:	6be2                	ld	s7,24(sp)
    1ae6:	6125                	add	sp,sp,96
    1ae8:	8082                	ret
    if(total != N * SZ){
    1aea:	6785                	lui	a5,0x1
    1aec:	42d78793          	add	a5,a5,1069 # 142d <copyinstr2+0x33>
    1af0:	02fa0163          	beq	s4,a5,1b12 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1af4:	8652                	mv	a2,s4
    1af6:	85ca                	mv	a1,s2
    1af8:	00005517          	auipc	a0,0x5
    1afc:	1d050513          	add	a0,a0,464 # 6cc8 <malloc+0xb0c>
    1b00:	00004097          	auipc	ra,0x4
    1b04:	604080e7          	jalr	1540(ra) # 6104 <printf>
      exit(1);
    1b08:	4505                	li	a0,1
    1b0a:	00004097          	auipc	ra,0x4
    1b0e:	190080e7          	jalr	400(ra) # 5c9a <exit>
    close(fds[0]);
    1b12:	fa842503          	lw	a0,-88(s0)
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	1ac080e7          	jalr	428(ra) # 5cc2 <close>
    wait(&xstatus);
    1b1e:	fa440513          	add	a0,s0,-92
    1b22:	00004097          	auipc	ra,0x4
    1b26:	180080e7          	jalr	384(ra) # 5ca2 <wait>
    exit(xstatus);
    1b2a:	fa442503          	lw	a0,-92(s0)
    1b2e:	00004097          	auipc	ra,0x4
    1b32:	16c080e7          	jalr	364(ra) # 5c9a <exit>
    printf("%s: fork() failed\n", s);
    1b36:	85ca                	mv	a1,s2
    1b38:	00005517          	auipc	a0,0x5
    1b3c:	1b050513          	add	a0,a0,432 # 6ce8 <malloc+0xb2c>
    1b40:	00004097          	auipc	ra,0x4
    1b44:	5c4080e7          	jalr	1476(ra) # 6104 <printf>
    exit(1);
    1b48:	4505                	li	a0,1
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	150080e7          	jalr	336(ra) # 5c9a <exit>

0000000000001b52 <exitwait>:
{
    1b52:	7139                	add	sp,sp,-64
    1b54:	fc06                	sd	ra,56(sp)
    1b56:	f822                	sd	s0,48(sp)
    1b58:	f426                	sd	s1,40(sp)
    1b5a:	f04a                	sd	s2,32(sp)
    1b5c:	ec4e                	sd	s3,24(sp)
    1b5e:	e852                	sd	s4,16(sp)
    1b60:	0080                	add	s0,sp,64
    1b62:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b64:	4901                	li	s2,0
    1b66:	06400993          	li	s3,100
    pid = fork();
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	128080e7          	jalr	296(ra) # 5c92 <fork>
    1b72:	84aa                	mv	s1,a0
    if(pid < 0){
    1b74:	02054a63          	bltz	a0,1ba8 <exitwait+0x56>
    if(pid){
    1b78:	c151                	beqz	a0,1bfc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b7a:	fcc40513          	add	a0,s0,-52
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	124080e7          	jalr	292(ra) # 5ca2 <wait>
    1b86:	02951f63          	bne	a0,s1,1bc4 <exitwait+0x72>
      if(i != xstate) {
    1b8a:	fcc42783          	lw	a5,-52(s0)
    1b8e:	05279963          	bne	a5,s2,1be0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b92:	2905                	addw	s2,s2,1
    1b94:	fd391be3          	bne	s2,s3,1b6a <exitwait+0x18>
}
    1b98:	70e2                	ld	ra,56(sp)
    1b9a:	7442                	ld	s0,48(sp)
    1b9c:	74a2                	ld	s1,40(sp)
    1b9e:	7902                	ld	s2,32(sp)
    1ba0:	69e2                	ld	s3,24(sp)
    1ba2:	6a42                	ld	s4,16(sp)
    1ba4:	6121                	add	sp,sp,64
    1ba6:	8082                	ret
      printf("%s: fork failed\n", s);
    1ba8:	85d2                	mv	a1,s4
    1baa:	00005517          	auipc	a0,0x5
    1bae:	fce50513          	add	a0,a0,-50 # 6b78 <malloc+0x9bc>
    1bb2:	00004097          	auipc	ra,0x4
    1bb6:	552080e7          	jalr	1362(ra) # 6104 <printf>
      exit(1);
    1bba:	4505                	li	a0,1
    1bbc:	00004097          	auipc	ra,0x4
    1bc0:	0de080e7          	jalr	222(ra) # 5c9a <exit>
        printf("%s: wait wrong pid\n", s);
    1bc4:	85d2                	mv	a1,s4
    1bc6:	00005517          	auipc	a0,0x5
    1bca:	13a50513          	add	a0,a0,314 # 6d00 <malloc+0xb44>
    1bce:	00004097          	auipc	ra,0x4
    1bd2:	536080e7          	jalr	1334(ra) # 6104 <printf>
        exit(1);
    1bd6:	4505                	li	a0,1
    1bd8:	00004097          	auipc	ra,0x4
    1bdc:	0c2080e7          	jalr	194(ra) # 5c9a <exit>
        printf("%s: wait wrong exit status\n", s);
    1be0:	85d2                	mv	a1,s4
    1be2:	00005517          	auipc	a0,0x5
    1be6:	13650513          	add	a0,a0,310 # 6d18 <malloc+0xb5c>
    1bea:	00004097          	auipc	ra,0x4
    1bee:	51a080e7          	jalr	1306(ra) # 6104 <printf>
        exit(1);
    1bf2:	4505                	li	a0,1
    1bf4:	00004097          	auipc	ra,0x4
    1bf8:	0a6080e7          	jalr	166(ra) # 5c9a <exit>
      exit(i);
    1bfc:	854a                	mv	a0,s2
    1bfe:	00004097          	auipc	ra,0x4
    1c02:	09c080e7          	jalr	156(ra) # 5c9a <exit>

0000000000001c06 <twochildren>:
{
    1c06:	1101                	add	sp,sp,-32
    1c08:	ec06                	sd	ra,24(sp)
    1c0a:	e822                	sd	s0,16(sp)
    1c0c:	e426                	sd	s1,8(sp)
    1c0e:	e04a                	sd	s2,0(sp)
    1c10:	1000                	add	s0,sp,32
    1c12:	892a                	mv	s2,a0
    1c14:	3e800493          	li	s1,1000
    int pid1 = fork();
    1c18:	00004097          	auipc	ra,0x4
    1c1c:	07a080e7          	jalr	122(ra) # 5c92 <fork>
    if(pid1 < 0){
    1c20:	02054c63          	bltz	a0,1c58 <twochildren+0x52>
    if(pid1 == 0){
    1c24:	c921                	beqz	a0,1c74 <twochildren+0x6e>
      int pid2 = fork();
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	06c080e7          	jalr	108(ra) # 5c92 <fork>
      if(pid2 < 0){
    1c2e:	04054763          	bltz	a0,1c7c <twochildren+0x76>
      if(pid2 == 0){
    1c32:	c13d                	beqz	a0,1c98 <twochildren+0x92>
        wait(0);
    1c34:	4501                	li	a0,0
    1c36:	00004097          	auipc	ra,0x4
    1c3a:	06c080e7          	jalr	108(ra) # 5ca2 <wait>
        wait(0);
    1c3e:	4501                	li	a0,0
    1c40:	00004097          	auipc	ra,0x4
    1c44:	062080e7          	jalr	98(ra) # 5ca2 <wait>
  for(int i = 0; i < 1000; i++){
    1c48:	34fd                	addw	s1,s1,-1
    1c4a:	f4f9                	bnez	s1,1c18 <twochildren+0x12>
}
    1c4c:	60e2                	ld	ra,24(sp)
    1c4e:	6442                	ld	s0,16(sp)
    1c50:	64a2                	ld	s1,8(sp)
    1c52:	6902                	ld	s2,0(sp)
    1c54:	6105                	add	sp,sp,32
    1c56:	8082                	ret
      printf("%s: fork failed\n", s);
    1c58:	85ca                	mv	a1,s2
    1c5a:	00005517          	auipc	a0,0x5
    1c5e:	f1e50513          	add	a0,a0,-226 # 6b78 <malloc+0x9bc>
    1c62:	00004097          	auipc	ra,0x4
    1c66:	4a2080e7          	jalr	1186(ra) # 6104 <printf>
      exit(1);
    1c6a:	4505                	li	a0,1
    1c6c:	00004097          	auipc	ra,0x4
    1c70:	02e080e7          	jalr	46(ra) # 5c9a <exit>
      exit(0);
    1c74:	00004097          	auipc	ra,0x4
    1c78:	026080e7          	jalr	38(ra) # 5c9a <exit>
        printf("%s: fork failed\n", s);
    1c7c:	85ca                	mv	a1,s2
    1c7e:	00005517          	auipc	a0,0x5
    1c82:	efa50513          	add	a0,a0,-262 # 6b78 <malloc+0x9bc>
    1c86:	00004097          	auipc	ra,0x4
    1c8a:	47e080e7          	jalr	1150(ra) # 6104 <printf>
        exit(1);
    1c8e:	4505                	li	a0,1
    1c90:	00004097          	auipc	ra,0x4
    1c94:	00a080e7          	jalr	10(ra) # 5c9a <exit>
        exit(0);
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	002080e7          	jalr	2(ra) # 5c9a <exit>

0000000000001ca0 <forkfork>:
{
    1ca0:	7179                	add	sp,sp,-48
    1ca2:	f406                	sd	ra,40(sp)
    1ca4:	f022                	sd	s0,32(sp)
    1ca6:	ec26                	sd	s1,24(sp)
    1ca8:	1800                	add	s0,sp,48
    1caa:	84aa                	mv	s1,a0
    int pid = fork();
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	fe6080e7          	jalr	-26(ra) # 5c92 <fork>
    if(pid < 0){
    1cb4:	04054163          	bltz	a0,1cf6 <forkfork+0x56>
    if(pid == 0){
    1cb8:	cd29                	beqz	a0,1d12 <forkfork+0x72>
    int pid = fork();
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	fd8080e7          	jalr	-40(ra) # 5c92 <fork>
    if(pid < 0){
    1cc2:	02054a63          	bltz	a0,1cf6 <forkfork+0x56>
    if(pid == 0){
    1cc6:	c531                	beqz	a0,1d12 <forkfork+0x72>
    wait(&xstatus);
    1cc8:	fdc40513          	add	a0,s0,-36
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	fd6080e7          	jalr	-42(ra) # 5ca2 <wait>
    if(xstatus != 0) {
    1cd4:	fdc42783          	lw	a5,-36(s0)
    1cd8:	ebbd                	bnez	a5,1d4e <forkfork+0xae>
    wait(&xstatus);
    1cda:	fdc40513          	add	a0,s0,-36
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	fc4080e7          	jalr	-60(ra) # 5ca2 <wait>
    if(xstatus != 0) {
    1ce6:	fdc42783          	lw	a5,-36(s0)
    1cea:	e3b5                	bnez	a5,1d4e <forkfork+0xae>
}
    1cec:	70a2                	ld	ra,40(sp)
    1cee:	7402                	ld	s0,32(sp)
    1cf0:	64e2                	ld	s1,24(sp)
    1cf2:	6145                	add	sp,sp,48
    1cf4:	8082                	ret
      printf("%s: fork failed", s);
    1cf6:	85a6                	mv	a1,s1
    1cf8:	00005517          	auipc	a0,0x5
    1cfc:	04050513          	add	a0,a0,64 # 6d38 <malloc+0xb7c>
    1d00:	00004097          	auipc	ra,0x4
    1d04:	404080e7          	jalr	1028(ra) # 6104 <printf>
      exit(1);
    1d08:	4505                	li	a0,1
    1d0a:	00004097          	auipc	ra,0x4
    1d0e:	f90080e7          	jalr	-112(ra) # 5c9a <exit>
{
    1d12:	0c800493          	li	s1,200
        int pid1 = fork();
    1d16:	00004097          	auipc	ra,0x4
    1d1a:	f7c080e7          	jalr	-132(ra) # 5c92 <fork>
        if(pid1 < 0){
    1d1e:	00054f63          	bltz	a0,1d3c <forkfork+0x9c>
        if(pid1 == 0){
    1d22:	c115                	beqz	a0,1d46 <forkfork+0xa6>
        wait(0);
    1d24:	4501                	li	a0,0
    1d26:	00004097          	auipc	ra,0x4
    1d2a:	f7c080e7          	jalr	-132(ra) # 5ca2 <wait>
      for(int j = 0; j < 200; j++){
    1d2e:	34fd                	addw	s1,s1,-1
    1d30:	f0fd                	bnez	s1,1d16 <forkfork+0x76>
      exit(0);
    1d32:	4501                	li	a0,0
    1d34:	00004097          	auipc	ra,0x4
    1d38:	f66080e7          	jalr	-154(ra) # 5c9a <exit>
          exit(1);
    1d3c:	4505                	li	a0,1
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	f5c080e7          	jalr	-164(ra) # 5c9a <exit>
          exit(0);
    1d46:	00004097          	auipc	ra,0x4
    1d4a:	f54080e7          	jalr	-172(ra) # 5c9a <exit>
      printf("%s: fork in child failed", s);
    1d4e:	85a6                	mv	a1,s1
    1d50:	00005517          	auipc	a0,0x5
    1d54:	ff850513          	add	a0,a0,-8 # 6d48 <malloc+0xb8c>
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	3ac080e7          	jalr	940(ra) # 6104 <printf>
      exit(1);
    1d60:	4505                	li	a0,1
    1d62:	00004097          	auipc	ra,0x4
    1d66:	f38080e7          	jalr	-200(ra) # 5c9a <exit>

0000000000001d6a <reparent2>:
{
    1d6a:	1101                	add	sp,sp,-32
    1d6c:	ec06                	sd	ra,24(sp)
    1d6e:	e822                	sd	s0,16(sp)
    1d70:	e426                	sd	s1,8(sp)
    1d72:	1000                	add	s0,sp,32
    1d74:	32000493          	li	s1,800
    int pid1 = fork();
    1d78:	00004097          	auipc	ra,0x4
    1d7c:	f1a080e7          	jalr	-230(ra) # 5c92 <fork>
    if(pid1 < 0){
    1d80:	00054f63          	bltz	a0,1d9e <reparent2+0x34>
    if(pid1 == 0){
    1d84:	c915                	beqz	a0,1db8 <reparent2+0x4e>
    wait(0);
    1d86:	4501                	li	a0,0
    1d88:	00004097          	auipc	ra,0x4
    1d8c:	f1a080e7          	jalr	-230(ra) # 5ca2 <wait>
  for(int i = 0; i < 800; i++){
    1d90:	34fd                	addw	s1,s1,-1
    1d92:	f0fd                	bnez	s1,1d78 <reparent2+0xe>
  exit(0);
    1d94:	4501                	li	a0,0
    1d96:	00004097          	auipc	ra,0x4
    1d9a:	f04080e7          	jalr	-252(ra) # 5c9a <exit>
      printf("fork failed\n");
    1d9e:	00006517          	auipc	a0,0x6
    1da2:	34a50513          	add	a0,a0,842 # 80e8 <malloc+0x1f2c>
    1da6:	00004097          	auipc	ra,0x4
    1daa:	35e080e7          	jalr	862(ra) # 6104 <printf>
      exit(1);
    1dae:	4505                	li	a0,1
    1db0:	00004097          	auipc	ra,0x4
    1db4:	eea080e7          	jalr	-278(ra) # 5c9a <exit>
      fork();
    1db8:	00004097          	auipc	ra,0x4
    1dbc:	eda080e7          	jalr	-294(ra) # 5c92 <fork>
      fork();
    1dc0:	00004097          	auipc	ra,0x4
    1dc4:	ed2080e7          	jalr	-302(ra) # 5c92 <fork>
      exit(0);
    1dc8:	4501                	li	a0,0
    1dca:	00004097          	auipc	ra,0x4
    1dce:	ed0080e7          	jalr	-304(ra) # 5c9a <exit>

0000000000001dd2 <createdelete>:
{
    1dd2:	7175                	add	sp,sp,-144
    1dd4:	e506                	sd	ra,136(sp)
    1dd6:	e122                	sd	s0,128(sp)
    1dd8:	fca6                	sd	s1,120(sp)
    1dda:	f8ca                	sd	s2,112(sp)
    1ddc:	f4ce                	sd	s3,104(sp)
    1dde:	f0d2                	sd	s4,96(sp)
    1de0:	ecd6                	sd	s5,88(sp)
    1de2:	e8da                	sd	s6,80(sp)
    1de4:	e4de                	sd	s7,72(sp)
    1de6:	e0e2                	sd	s8,64(sp)
    1de8:	fc66                	sd	s9,56(sp)
    1dea:	0900                	add	s0,sp,144
    1dec:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1dee:	4901                	li	s2,0
    1df0:	4991                	li	s3,4
    pid = fork();
    1df2:	00004097          	auipc	ra,0x4
    1df6:	ea0080e7          	jalr	-352(ra) # 5c92 <fork>
    1dfa:	84aa                	mv	s1,a0
    if(pid < 0){
    1dfc:	02054f63          	bltz	a0,1e3a <createdelete+0x68>
    if(pid == 0){
    1e00:	c939                	beqz	a0,1e56 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1e02:	2905                	addw	s2,s2,1
    1e04:	ff3917e3          	bne	s2,s3,1df2 <createdelete+0x20>
    1e08:	4491                	li	s1,4
    wait(&xstatus);
    1e0a:	f7c40513          	add	a0,s0,-132
    1e0e:	00004097          	auipc	ra,0x4
    1e12:	e94080e7          	jalr	-364(ra) # 5ca2 <wait>
    if(xstatus != 0)
    1e16:	f7c42903          	lw	s2,-132(s0)
    1e1a:	0e091263          	bnez	s2,1efe <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1e1e:	34fd                	addw	s1,s1,-1
    1e20:	f4ed                	bnez	s1,1e0a <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1e22:	f8040123          	sb	zero,-126(s0)
    1e26:	03000993          	li	s3,48
    1e2a:	5a7d                	li	s4,-1
    1e2c:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1e30:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1e32:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1e34:	07400a93          	li	s5,116
    1e38:	a29d                	j	1f9e <createdelete+0x1cc>
      printf("%s: fork failed\n", s);
    1e3a:	85e6                	mv	a1,s9
    1e3c:	00005517          	auipc	a0,0x5
    1e40:	d3c50513          	add	a0,a0,-708 # 6b78 <malloc+0x9bc>
    1e44:	00004097          	auipc	ra,0x4
    1e48:	2c0080e7          	jalr	704(ra) # 6104 <printf>
      exit(1);
    1e4c:	4505                	li	a0,1
    1e4e:	00004097          	auipc	ra,0x4
    1e52:	e4c080e7          	jalr	-436(ra) # 5c9a <exit>
      name[0] = 'p' + pi;
    1e56:	0709091b          	addw	s2,s2,112
    1e5a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e5e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e62:	4951                	li	s2,20
    1e64:	a015                	j	1e88 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e66:	85e6                	mv	a1,s9
    1e68:	00005517          	auipc	a0,0x5
    1e6c:	da850513          	add	a0,a0,-600 # 6c10 <malloc+0xa54>
    1e70:	00004097          	auipc	ra,0x4
    1e74:	294080e7          	jalr	660(ra) # 6104 <printf>
          exit(1);
    1e78:	4505                	li	a0,1
    1e7a:	00004097          	auipc	ra,0x4
    1e7e:	e20080e7          	jalr	-480(ra) # 5c9a <exit>
      for(i = 0; i < N; i++){
    1e82:	2485                	addw	s1,s1,1
    1e84:	07248863          	beq	s1,s2,1ef4 <createdelete+0x122>
        name[1] = '0' + i;
    1e88:	0304879b          	addw	a5,s1,48
    1e8c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e90:	20200593          	li	a1,514
    1e94:	f8040513          	add	a0,s0,-128
    1e98:	00004097          	auipc	ra,0x4
    1e9c:	e42080e7          	jalr	-446(ra) # 5cda <open>
        if(fd < 0){
    1ea0:	fc0543e3          	bltz	a0,1e66 <createdelete+0x94>
        close(fd);
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	e1e080e7          	jalr	-482(ra) # 5cc2 <close>
        if(i > 0 && (i % 2 ) == 0){
    1eac:	fc905be3          	blez	s1,1e82 <createdelete+0xb0>
    1eb0:	0014f793          	and	a5,s1,1
    1eb4:	f7f9                	bnez	a5,1e82 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1eb6:	01f4d79b          	srlw	a5,s1,0x1f
    1eba:	9fa5                	addw	a5,a5,s1
    1ebc:	4017d79b          	sraw	a5,a5,0x1
    1ec0:	0307879b          	addw	a5,a5,48
    1ec4:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1ec8:	f8040513          	add	a0,s0,-128
    1ecc:	00004097          	auipc	ra,0x4
    1ed0:	e1e080e7          	jalr	-482(ra) # 5cea <unlink>
    1ed4:	fa0557e3          	bgez	a0,1e82 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1ed8:	85e6                	mv	a1,s9
    1eda:	00005517          	auipc	a0,0x5
    1ede:	e8e50513          	add	a0,a0,-370 # 6d68 <malloc+0xbac>
    1ee2:	00004097          	auipc	ra,0x4
    1ee6:	222080e7          	jalr	546(ra) # 6104 <printf>
            exit(1);
    1eea:	4505                	li	a0,1
    1eec:	00004097          	auipc	ra,0x4
    1ef0:	dae080e7          	jalr	-594(ra) # 5c9a <exit>
      exit(0);
    1ef4:	4501                	li	a0,0
    1ef6:	00004097          	auipc	ra,0x4
    1efa:	da4080e7          	jalr	-604(ra) # 5c9a <exit>
      exit(1);
    1efe:	4505                	li	a0,1
    1f00:	00004097          	auipc	ra,0x4
    1f04:	d9a080e7          	jalr	-614(ra) # 5c9a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1f08:	f8040613          	add	a2,s0,-128
    1f0c:	85e6                	mv	a1,s9
    1f0e:	00005517          	auipc	a0,0x5
    1f12:	e7250513          	add	a0,a0,-398 # 6d80 <malloc+0xbc4>
    1f16:	00004097          	auipc	ra,0x4
    1f1a:	1ee080e7          	jalr	494(ra) # 6104 <printf>
        exit(1);
    1f1e:	4505                	li	a0,1
    1f20:	00004097          	auipc	ra,0x4
    1f24:	d7a080e7          	jalr	-646(ra) # 5c9a <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f28:	054b7163          	bgeu	s6,s4,1f6a <createdelete+0x198>
      if(fd >= 0)
    1f2c:	02055a63          	bgez	a0,1f60 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1f30:	2485                	addw	s1,s1,1
    1f32:	0ff4f493          	zext.b	s1,s1
    1f36:	05548c63          	beq	s1,s5,1f8e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1f3a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1f3e:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1f42:	4581                	li	a1,0
    1f44:	f8040513          	add	a0,s0,-128
    1f48:	00004097          	auipc	ra,0x4
    1f4c:	d92080e7          	jalr	-622(ra) # 5cda <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f50:	00090463          	beqz	s2,1f58 <createdelete+0x186>
    1f54:	fd2bdae3          	bge	s7,s2,1f28 <createdelete+0x156>
    1f58:	fa0548e3          	bltz	a0,1f08 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f5c:	014b7963          	bgeu	s6,s4,1f6e <createdelete+0x19c>
        close(fd);
    1f60:	00004097          	auipc	ra,0x4
    1f64:	d62080e7          	jalr	-670(ra) # 5cc2 <close>
    1f68:	b7e1                	j	1f30 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f6a:	fc0543e3          	bltz	a0,1f30 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f6e:	f8040613          	add	a2,s0,-128
    1f72:	85e6                	mv	a1,s9
    1f74:	00005517          	auipc	a0,0x5
    1f78:	e3450513          	add	a0,a0,-460 # 6da8 <malloc+0xbec>
    1f7c:	00004097          	auipc	ra,0x4
    1f80:	188080e7          	jalr	392(ra) # 6104 <printf>
        exit(1);
    1f84:	4505                	li	a0,1
    1f86:	00004097          	auipc	ra,0x4
    1f8a:	d14080e7          	jalr	-748(ra) # 5c9a <exit>
  for(i = 0; i < N; i++){
    1f8e:	2905                	addw	s2,s2,1
    1f90:	2a05                	addw	s4,s4,1
    1f92:	2985                	addw	s3,s3,1 # 3001 <fourteen+0x25>
    1f94:	0ff9f993          	zext.b	s3,s3
    1f98:	47d1                	li	a5,20
    1f9a:	02f90a63          	beq	s2,a5,1fce <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f9e:	84e2                	mv	s1,s8
    1fa0:	bf69                	j	1f3a <createdelete+0x168>
  for(i = 0; i < N; i++){
    1fa2:	2905                	addw	s2,s2,1
    1fa4:	0ff97913          	zext.b	s2,s2
    1fa8:	03490c63          	beq	s2,s4,1fe0 <createdelete+0x20e>
  name[0] = name[1] = name[2] = 0;
    1fac:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    1fae:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1fb2:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    1fb6:	f8040513          	add	a0,s0,-128
    1fba:	00004097          	auipc	ra,0x4
    1fbe:	d30080e7          	jalr	-720(ra) # 5cea <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1fc2:	2485                	addw	s1,s1,1
    1fc4:	0ff4f493          	zext.b	s1,s1
    1fc8:	ff3493e3          	bne	s1,s3,1fae <createdelete+0x1dc>
    1fcc:	bfd9                	j	1fa2 <createdelete+0x1d0>
    1fce:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1fd2:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    1fd6:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1fda:	04400a13          	li	s4,68
    1fde:	b7f9                	j	1fac <createdelete+0x1da>
}
    1fe0:	60aa                	ld	ra,136(sp)
    1fe2:	640a                	ld	s0,128(sp)
    1fe4:	74e6                	ld	s1,120(sp)
    1fe6:	7946                	ld	s2,112(sp)
    1fe8:	79a6                	ld	s3,104(sp)
    1fea:	7a06                	ld	s4,96(sp)
    1fec:	6ae6                	ld	s5,88(sp)
    1fee:	6b46                	ld	s6,80(sp)
    1ff0:	6ba6                	ld	s7,72(sp)
    1ff2:	6c06                	ld	s8,64(sp)
    1ff4:	7ce2                	ld	s9,56(sp)
    1ff6:	6149                	add	sp,sp,144
    1ff8:	8082                	ret

0000000000001ffa <linkunlink>:
{
    1ffa:	711d                	add	sp,sp,-96
    1ffc:	ec86                	sd	ra,88(sp)
    1ffe:	e8a2                	sd	s0,80(sp)
    2000:	e4a6                	sd	s1,72(sp)
    2002:	e0ca                	sd	s2,64(sp)
    2004:	fc4e                	sd	s3,56(sp)
    2006:	f852                	sd	s4,48(sp)
    2008:	f456                	sd	s5,40(sp)
    200a:	f05a                	sd	s6,32(sp)
    200c:	ec5e                	sd	s7,24(sp)
    200e:	e862                	sd	s8,16(sp)
    2010:	e466                	sd	s9,8(sp)
    2012:	1080                	add	s0,sp,96
    2014:	84aa                	mv	s1,a0
  unlink("x");
    2016:	00004517          	auipc	a0,0x4
    201a:	34250513          	add	a0,a0,834 # 6358 <malloc+0x19c>
    201e:	00004097          	auipc	ra,0x4
    2022:	ccc080e7          	jalr	-820(ra) # 5cea <unlink>
  pid = fork();
    2026:	00004097          	auipc	ra,0x4
    202a:	c6c080e7          	jalr	-916(ra) # 5c92 <fork>
  if(pid < 0){
    202e:	02054b63          	bltz	a0,2064 <linkunlink+0x6a>
    2032:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    2034:	06100c93          	li	s9,97
    2038:	c111                	beqz	a0,203c <linkunlink+0x42>
    203a:	4c85                	li	s9,1
    203c:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2040:	41c659b7          	lui	s3,0x41c65
    2044:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    2048:	690d                	lui	s2,0x3
    204a:	0399091b          	addw	s2,s2,57 # 3039 <fourteen+0x5d>
    if((x % 3) == 0){
    204e:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    2050:	4b05                	li	s6,1
      unlink("x");
    2052:	00004a97          	auipc	s5,0x4
    2056:	306a8a93          	add	s5,s5,774 # 6358 <malloc+0x19c>
      link("cat", "x");
    205a:	00005b97          	auipc	s7,0x5
    205e:	d76b8b93          	add	s7,s7,-650 # 6dd0 <malloc+0xc14>
    2062:	a825                	j	209a <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2064:	85a6                	mv	a1,s1
    2066:	00005517          	auipc	a0,0x5
    206a:	b1250513          	add	a0,a0,-1262 # 6b78 <malloc+0x9bc>
    206e:	00004097          	auipc	ra,0x4
    2072:	096080e7          	jalr	150(ra) # 6104 <printf>
    exit(1);
    2076:	4505                	li	a0,1
    2078:	00004097          	auipc	ra,0x4
    207c:	c22080e7          	jalr	-990(ra) # 5c9a <exit>
      close(open("x", O_RDWR | O_CREATE));
    2080:	20200593          	li	a1,514
    2084:	8556                	mv	a0,s5
    2086:	00004097          	auipc	ra,0x4
    208a:	c54080e7          	jalr	-940(ra) # 5cda <open>
    208e:	00004097          	auipc	ra,0x4
    2092:	c34080e7          	jalr	-972(ra) # 5cc2 <close>
  for(i = 0; i < 100; i++){
    2096:	34fd                	addw	s1,s1,-1
    2098:	c88d                	beqz	s1,20ca <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    209a:	033c87bb          	mulw	a5,s9,s3
    209e:	012787bb          	addw	a5,a5,s2
    20a2:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    20a6:	0347f7bb          	remuw	a5,a5,s4
    20aa:	dbf9                	beqz	a5,2080 <linkunlink+0x86>
    } else if((x % 3) == 1){
    20ac:	01678863          	beq	a5,s6,20bc <linkunlink+0xc2>
      unlink("x");
    20b0:	8556                	mv	a0,s5
    20b2:	00004097          	auipc	ra,0x4
    20b6:	c38080e7          	jalr	-968(ra) # 5cea <unlink>
    20ba:	bff1                	j	2096 <linkunlink+0x9c>
      link("cat", "x");
    20bc:	85d6                	mv	a1,s5
    20be:	855e                	mv	a0,s7
    20c0:	00004097          	auipc	ra,0x4
    20c4:	c3a080e7          	jalr	-966(ra) # 5cfa <link>
    20c8:	b7f9                	j	2096 <linkunlink+0x9c>
  if(pid)
    20ca:	020c0463          	beqz	s8,20f2 <linkunlink+0xf8>
    wait(0);
    20ce:	4501                	li	a0,0
    20d0:	00004097          	auipc	ra,0x4
    20d4:	bd2080e7          	jalr	-1070(ra) # 5ca2 <wait>
}
    20d8:	60e6                	ld	ra,88(sp)
    20da:	6446                	ld	s0,80(sp)
    20dc:	64a6                	ld	s1,72(sp)
    20de:	6906                	ld	s2,64(sp)
    20e0:	79e2                	ld	s3,56(sp)
    20e2:	7a42                	ld	s4,48(sp)
    20e4:	7aa2                	ld	s5,40(sp)
    20e6:	7b02                	ld	s6,32(sp)
    20e8:	6be2                	ld	s7,24(sp)
    20ea:	6c42                	ld	s8,16(sp)
    20ec:	6ca2                	ld	s9,8(sp)
    20ee:	6125                	add	sp,sp,96
    20f0:	8082                	ret
    exit(0);
    20f2:	4501                	li	a0,0
    20f4:	00004097          	auipc	ra,0x4
    20f8:	ba6080e7          	jalr	-1114(ra) # 5c9a <exit>

00000000000020fc <forktest>:
{
    20fc:	7179                	add	sp,sp,-48
    20fe:	f406                	sd	ra,40(sp)
    2100:	f022                	sd	s0,32(sp)
    2102:	ec26                	sd	s1,24(sp)
    2104:	e84a                	sd	s2,16(sp)
    2106:	e44e                	sd	s3,8(sp)
    2108:	1800                	add	s0,sp,48
    210a:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    210c:	4481                	li	s1,0
    210e:	3e800913          	li	s2,1000
    pid = fork();
    2112:	00004097          	auipc	ra,0x4
    2116:	b80080e7          	jalr	-1152(ra) # 5c92 <fork>
    if(pid < 0)
    211a:	02054863          	bltz	a0,214a <forktest+0x4e>
    if(pid == 0)
    211e:	c115                	beqz	a0,2142 <forktest+0x46>
  for(n=0; n<N; n++){
    2120:	2485                	addw	s1,s1,1
    2122:	ff2498e3          	bne	s1,s2,2112 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2126:	85ce                	mv	a1,s3
    2128:	00005517          	auipc	a0,0x5
    212c:	cc850513          	add	a0,a0,-824 # 6df0 <malloc+0xc34>
    2130:	00004097          	auipc	ra,0x4
    2134:	fd4080e7          	jalr	-44(ra) # 6104 <printf>
    exit(1);
    2138:	4505                	li	a0,1
    213a:	00004097          	auipc	ra,0x4
    213e:	b60080e7          	jalr	-1184(ra) # 5c9a <exit>
      exit(0);
    2142:	00004097          	auipc	ra,0x4
    2146:	b58080e7          	jalr	-1192(ra) # 5c9a <exit>
  if (n == 0) {
    214a:	cc9d                	beqz	s1,2188 <forktest+0x8c>
  if(n == N){
    214c:	3e800793          	li	a5,1000
    2150:	fcf48be3          	beq	s1,a5,2126 <forktest+0x2a>
  for(; n > 0; n--){
    2154:	00905b63          	blez	s1,216a <forktest+0x6e>
    if(wait(0) < 0){
    2158:	4501                	li	a0,0
    215a:	00004097          	auipc	ra,0x4
    215e:	b48080e7          	jalr	-1208(ra) # 5ca2 <wait>
    2162:	04054163          	bltz	a0,21a4 <forktest+0xa8>
  for(; n > 0; n--){
    2166:	34fd                	addw	s1,s1,-1
    2168:	f8e5                	bnez	s1,2158 <forktest+0x5c>
  if(wait(0) != -1){
    216a:	4501                	li	a0,0
    216c:	00004097          	auipc	ra,0x4
    2170:	b36080e7          	jalr	-1226(ra) # 5ca2 <wait>
    2174:	57fd                	li	a5,-1
    2176:	04f51563          	bne	a0,a5,21c0 <forktest+0xc4>
}
    217a:	70a2                	ld	ra,40(sp)
    217c:	7402                	ld	s0,32(sp)
    217e:	64e2                	ld	s1,24(sp)
    2180:	6942                	ld	s2,16(sp)
    2182:	69a2                	ld	s3,8(sp)
    2184:	6145                	add	sp,sp,48
    2186:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2188:	85ce                	mv	a1,s3
    218a:	00005517          	auipc	a0,0x5
    218e:	c4e50513          	add	a0,a0,-946 # 6dd8 <malloc+0xc1c>
    2192:	00004097          	auipc	ra,0x4
    2196:	f72080e7          	jalr	-142(ra) # 6104 <printf>
    exit(1);
    219a:	4505                	li	a0,1
    219c:	00004097          	auipc	ra,0x4
    21a0:	afe080e7          	jalr	-1282(ra) # 5c9a <exit>
      printf("%s: wait stopped early\n", s);
    21a4:	85ce                	mv	a1,s3
    21a6:	00005517          	auipc	a0,0x5
    21aa:	c7250513          	add	a0,a0,-910 # 6e18 <malloc+0xc5c>
    21ae:	00004097          	auipc	ra,0x4
    21b2:	f56080e7          	jalr	-170(ra) # 6104 <printf>
      exit(1);
    21b6:	4505                	li	a0,1
    21b8:	00004097          	auipc	ra,0x4
    21bc:	ae2080e7          	jalr	-1310(ra) # 5c9a <exit>
    printf("%s: wait got too many\n", s);
    21c0:	85ce                	mv	a1,s3
    21c2:	00005517          	auipc	a0,0x5
    21c6:	c6e50513          	add	a0,a0,-914 # 6e30 <malloc+0xc74>
    21ca:	00004097          	auipc	ra,0x4
    21ce:	f3a080e7          	jalr	-198(ra) # 6104 <printf>
    exit(1);
    21d2:	4505                	li	a0,1
    21d4:	00004097          	auipc	ra,0x4
    21d8:	ac6080e7          	jalr	-1338(ra) # 5c9a <exit>

00000000000021dc <kernmem>:
{
    21dc:	715d                	add	sp,sp,-80
    21de:	e486                	sd	ra,72(sp)
    21e0:	e0a2                	sd	s0,64(sp)
    21e2:	fc26                	sd	s1,56(sp)
    21e4:	f84a                	sd	s2,48(sp)
    21e6:	f44e                	sd	s3,40(sp)
    21e8:	f052                	sd	s4,32(sp)
    21ea:	ec56                	sd	s5,24(sp)
    21ec:	0880                	add	s0,sp,80
    21ee:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21f0:	4485                	li	s1,1
    21f2:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  /* did kernel kill child? */
    21f4:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21f6:	69b1                	lui	s3,0xc
    21f8:	35098993          	add	s3,s3,848 # c350 <uninit+0x1de8>
    21fc:	1003d937          	lui	s2,0x1003d
    2200:	090e                	sll	s2,s2,0x3
    2202:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    2206:	00004097          	auipc	ra,0x4
    220a:	a8c080e7          	jalr	-1396(ra) # 5c92 <fork>
    if(pid < 0){
    220e:	02054963          	bltz	a0,2240 <kernmem+0x64>
    if(pid == 0){
    2212:	c529                	beqz	a0,225c <kernmem+0x80>
    wait(&xstatus);
    2214:	fbc40513          	add	a0,s0,-68
    2218:	00004097          	auipc	ra,0x4
    221c:	a8a080e7          	jalr	-1398(ra) # 5ca2 <wait>
    if(xstatus != -1)  /* did kernel kill child? */
    2220:	fbc42783          	lw	a5,-68(s0)
    2224:	05579d63          	bne	a5,s5,227e <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2228:	94ce                	add	s1,s1,s3
    222a:	fd249ee3          	bne	s1,s2,2206 <kernmem+0x2a>
}
    222e:	60a6                	ld	ra,72(sp)
    2230:	6406                	ld	s0,64(sp)
    2232:	74e2                	ld	s1,56(sp)
    2234:	7942                	ld	s2,48(sp)
    2236:	79a2                	ld	s3,40(sp)
    2238:	7a02                	ld	s4,32(sp)
    223a:	6ae2                	ld	s5,24(sp)
    223c:	6161                	add	sp,sp,80
    223e:	8082                	ret
      printf("%s: fork failed\n", s);
    2240:	85d2                	mv	a1,s4
    2242:	00005517          	auipc	a0,0x5
    2246:	93650513          	add	a0,a0,-1738 # 6b78 <malloc+0x9bc>
    224a:	00004097          	auipc	ra,0x4
    224e:	eba080e7          	jalr	-326(ra) # 6104 <printf>
      exit(1);
    2252:	4505                	li	a0,1
    2254:	00004097          	auipc	ra,0x4
    2258:	a46080e7          	jalr	-1466(ra) # 5c9a <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    225c:	0004c683          	lbu	a3,0(s1)
    2260:	8626                	mv	a2,s1
    2262:	85d2                	mv	a1,s4
    2264:	00005517          	auipc	a0,0x5
    2268:	be450513          	add	a0,a0,-1052 # 6e48 <malloc+0xc8c>
    226c:	00004097          	auipc	ra,0x4
    2270:	e98080e7          	jalr	-360(ra) # 6104 <printf>
      exit(1);
    2274:	4505                	li	a0,1
    2276:	00004097          	auipc	ra,0x4
    227a:	a24080e7          	jalr	-1500(ra) # 5c9a <exit>
      exit(1);
    227e:	4505                	li	a0,1
    2280:	00004097          	auipc	ra,0x4
    2284:	a1a080e7          	jalr	-1510(ra) # 5c9a <exit>

0000000000002288 <MAXVAplus>:
{
    2288:	7179                	add	sp,sp,-48
    228a:	f406                	sd	ra,40(sp)
    228c:	f022                	sd	s0,32(sp)
    228e:	ec26                	sd	s1,24(sp)
    2290:	e84a                	sd	s2,16(sp)
    2292:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    2294:	4785                	li	a5,1
    2296:	179a                	sll	a5,a5,0x26
    2298:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    229c:	fd843783          	ld	a5,-40(s0)
    22a0:	cf85                	beqz	a5,22d8 <MAXVAplus+0x50>
    22a2:	892a                	mv	s2,a0
    if(xstatus != -1)  /* did kernel kill child? */
    22a4:	54fd                	li	s1,-1
    pid = fork();
    22a6:	00004097          	auipc	ra,0x4
    22aa:	9ec080e7          	jalr	-1556(ra) # 5c92 <fork>
    if(pid < 0){
    22ae:	02054b63          	bltz	a0,22e4 <MAXVAplus+0x5c>
    if(pid == 0){
    22b2:	c539                	beqz	a0,2300 <MAXVAplus+0x78>
    wait(&xstatus);
    22b4:	fd440513          	add	a0,s0,-44
    22b8:	00004097          	auipc	ra,0x4
    22bc:	9ea080e7          	jalr	-1558(ra) # 5ca2 <wait>
    if(xstatus != -1)  /* did kernel kill child? */
    22c0:	fd442783          	lw	a5,-44(s0)
    22c4:	06979463          	bne	a5,s1,232c <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    22c8:	fd843783          	ld	a5,-40(s0)
    22cc:	0786                	sll	a5,a5,0x1
    22ce:	fcf43c23          	sd	a5,-40(s0)
    22d2:	fd843783          	ld	a5,-40(s0)
    22d6:	fbe1                	bnez	a5,22a6 <MAXVAplus+0x1e>
}
    22d8:	70a2                	ld	ra,40(sp)
    22da:	7402                	ld	s0,32(sp)
    22dc:	64e2                	ld	s1,24(sp)
    22de:	6942                	ld	s2,16(sp)
    22e0:	6145                	add	sp,sp,48
    22e2:	8082                	ret
      printf("%s: fork failed\n", s);
    22e4:	85ca                	mv	a1,s2
    22e6:	00005517          	auipc	a0,0x5
    22ea:	89250513          	add	a0,a0,-1902 # 6b78 <malloc+0x9bc>
    22ee:	00004097          	auipc	ra,0x4
    22f2:	e16080e7          	jalr	-490(ra) # 6104 <printf>
      exit(1);
    22f6:	4505                	li	a0,1
    22f8:	00004097          	auipc	ra,0x4
    22fc:	9a2080e7          	jalr	-1630(ra) # 5c9a <exit>
      *(char*)a = 99;
    2300:	fd843783          	ld	a5,-40(s0)
    2304:	06300713          	li	a4,99
    2308:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    230c:	fd843603          	ld	a2,-40(s0)
    2310:	85ca                	mv	a1,s2
    2312:	00005517          	auipc	a0,0x5
    2316:	b5650513          	add	a0,a0,-1194 # 6e68 <malloc+0xcac>
    231a:	00004097          	auipc	ra,0x4
    231e:	dea080e7          	jalr	-534(ra) # 6104 <printf>
      exit(1);
    2322:	4505                	li	a0,1
    2324:	00004097          	auipc	ra,0x4
    2328:	976080e7          	jalr	-1674(ra) # 5c9a <exit>
      exit(1);
    232c:	4505                	li	a0,1
    232e:	00004097          	auipc	ra,0x4
    2332:	96c080e7          	jalr	-1684(ra) # 5c9a <exit>

0000000000002336 <stacktest>:
{
    2336:	7179                	add	sp,sp,-48
    2338:	f406                	sd	ra,40(sp)
    233a:	f022                	sd	s0,32(sp)
    233c:	ec26                	sd	s1,24(sp)
    233e:	1800                	add	s0,sp,48
    2340:	84aa                	mv	s1,a0
  pid = fork();
    2342:	00004097          	auipc	ra,0x4
    2346:	950080e7          	jalr	-1712(ra) # 5c92 <fork>
  if(pid == 0) {
    234a:	c115                	beqz	a0,236e <stacktest+0x38>
  } else if(pid < 0){
    234c:	04054463          	bltz	a0,2394 <stacktest+0x5e>
  wait(&xstatus);
    2350:	fdc40513          	add	a0,s0,-36
    2354:	00004097          	auipc	ra,0x4
    2358:	94e080e7          	jalr	-1714(ra) # 5ca2 <wait>
  if(xstatus == -1)  /* kernel killed child? */
    235c:	fdc42503          	lw	a0,-36(s0)
    2360:	57fd                	li	a5,-1
    2362:	04f50763          	beq	a0,a5,23b0 <stacktest+0x7a>
    exit(xstatus);
    2366:	00004097          	auipc	ra,0x4
    236a:	934080e7          	jalr	-1740(ra) # 5c9a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    236e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    2370:	77fd                	lui	a5,0xfffff
    2372:	97ba                	add	a5,a5,a4
    2374:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2378:	85a6                	mv	a1,s1
    237a:	00005517          	auipc	a0,0x5
    237e:	b0650513          	add	a0,a0,-1274 # 6e80 <malloc+0xcc4>
    2382:	00004097          	auipc	ra,0x4
    2386:	d82080e7          	jalr	-638(ra) # 6104 <printf>
    exit(1);
    238a:	4505                	li	a0,1
    238c:	00004097          	auipc	ra,0x4
    2390:	90e080e7          	jalr	-1778(ra) # 5c9a <exit>
    printf("%s: fork failed\n", s);
    2394:	85a6                	mv	a1,s1
    2396:	00004517          	auipc	a0,0x4
    239a:	7e250513          	add	a0,a0,2018 # 6b78 <malloc+0x9bc>
    239e:	00004097          	auipc	ra,0x4
    23a2:	d66080e7          	jalr	-666(ra) # 6104 <printf>
    exit(1);
    23a6:	4505                	li	a0,1
    23a8:	00004097          	auipc	ra,0x4
    23ac:	8f2080e7          	jalr	-1806(ra) # 5c9a <exit>
    exit(0);
    23b0:	4501                	li	a0,0
    23b2:	00004097          	auipc	ra,0x4
    23b6:	8e8080e7          	jalr	-1816(ra) # 5c9a <exit>

00000000000023ba <nowrite>:
{
    23ba:	7159                	add	sp,sp,-112
    23bc:	f486                	sd	ra,104(sp)
    23be:	f0a2                	sd	s0,96(sp)
    23c0:	eca6                	sd	s1,88(sp)
    23c2:	e8ca                	sd	s2,80(sp)
    23c4:	e4ce                	sd	s3,72(sp)
    23c6:	1880                	add	s0,sp,112
    23c8:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    23ca:	00006797          	auipc	a5,0x6
    23ce:	27678793          	add	a5,a5,630 # 8640 <malloc+0x2484>
    23d2:	7788                	ld	a0,40(a5)
    23d4:	7b8c                	ld	a1,48(a5)
    23d6:	7f90                	ld	a2,56(a5)
    23d8:	63b4                	ld	a3,64(a5)
    23da:	67b8                	ld	a4,72(a5)
    23dc:	6bbc                	ld	a5,80(a5)
    23de:	f8a43c23          	sd	a0,-104(s0)
    23e2:	fab43023          	sd	a1,-96(s0)
    23e6:	fac43423          	sd	a2,-88(s0)
    23ea:	fad43823          	sd	a3,-80(s0)
    23ee:	fae43c23          	sd	a4,-72(s0)
    23f2:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    23f6:	4481                	li	s1,0
    23f8:	4919                	li	s2,6
    pid = fork();
    23fa:	00004097          	auipc	ra,0x4
    23fe:	898080e7          	jalr	-1896(ra) # 5c92 <fork>
    if(pid == 0) {
    2402:	c505                	beqz	a0,242a <nowrite+0x70>
    } else if(pid < 0){
    2404:	04054a63          	bltz	a0,2458 <nowrite+0x9e>
    wait(&xstatus);
    2408:	fcc40513          	add	a0,s0,-52
    240c:	00004097          	auipc	ra,0x4
    2410:	896080e7          	jalr	-1898(ra) # 5ca2 <wait>
    if(xstatus == 0){
    2414:	fcc42783          	lw	a5,-52(s0)
    2418:	cfb1                	beqz	a5,2474 <nowrite+0xba>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    241a:	2485                	addw	s1,s1,1
    241c:	fd249fe3          	bne	s1,s2,23fa <nowrite+0x40>
  exit(0);
    2420:	4501                	li	a0,0
    2422:	00004097          	auipc	ra,0x4
    2426:	878080e7          	jalr	-1928(ra) # 5c9a <exit>
      volatile int *addr = (int *) addrs[ai];
    242a:	048e                	sll	s1,s1,0x3
    242c:	fd048793          	add	a5,s1,-48
    2430:	008784b3          	add	s1,a5,s0
    2434:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    2438:	47a9                	li	a5,10
    243a:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    243c:	85ce                	mv	a1,s3
    243e:	00005517          	auipc	a0,0x5
    2442:	a6a50513          	add	a0,a0,-1430 # 6ea8 <malloc+0xcec>
    2446:	00004097          	auipc	ra,0x4
    244a:	cbe080e7          	jalr	-834(ra) # 6104 <printf>
      exit(0);
    244e:	4501                	li	a0,0
    2450:	00004097          	auipc	ra,0x4
    2454:	84a080e7          	jalr	-1974(ra) # 5c9a <exit>
      printf("%s: fork failed\n", s);
    2458:	85ce                	mv	a1,s3
    245a:	00004517          	auipc	a0,0x4
    245e:	71e50513          	add	a0,a0,1822 # 6b78 <malloc+0x9bc>
    2462:	00004097          	auipc	ra,0x4
    2466:	ca2080e7          	jalr	-862(ra) # 6104 <printf>
      exit(1);
    246a:	4505                	li	a0,1
    246c:	00004097          	auipc	ra,0x4
    2470:	82e080e7          	jalr	-2002(ra) # 5c9a <exit>
      exit(1);
    2474:	4505                	li	a0,1
    2476:	00004097          	auipc	ra,0x4
    247a:	824080e7          	jalr	-2012(ra) # 5c9a <exit>

000000000000247e <manywrites>:
{
    247e:	711d                	add	sp,sp,-96
    2480:	ec86                	sd	ra,88(sp)
    2482:	e8a2                	sd	s0,80(sp)
    2484:	e4a6                	sd	s1,72(sp)
    2486:	e0ca                	sd	s2,64(sp)
    2488:	fc4e                	sd	s3,56(sp)
    248a:	f852                	sd	s4,48(sp)
    248c:	f456                	sd	s5,40(sp)
    248e:	f05a                	sd	s6,32(sp)
    2490:	ec5e                	sd	s7,24(sp)
    2492:	1080                	add	s0,sp,96
    2494:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    2496:	4981                	li	s3,0
    2498:	4911                	li	s2,4
    int pid = fork();
    249a:	00003097          	auipc	ra,0x3
    249e:	7f8080e7          	jalr	2040(ra) # 5c92 <fork>
    24a2:	84aa                	mv	s1,a0
    if(pid < 0){
    24a4:	02054963          	bltz	a0,24d6 <manywrites+0x58>
    if(pid == 0){
    24a8:	c521                	beqz	a0,24f0 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24aa:	2985                	addw	s3,s3,1
    24ac:	ff2997e3          	bne	s3,s2,249a <manywrites+0x1c>
    24b0:	4491                	li	s1,4
    int st = 0;
    24b2:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24b6:	fa840513          	add	a0,s0,-88
    24ba:	00003097          	auipc	ra,0x3
    24be:	7e8080e7          	jalr	2024(ra) # 5ca2 <wait>
    if(st != 0)
    24c2:	fa842503          	lw	a0,-88(s0)
    24c6:	ed6d                	bnez	a0,25c0 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    24c8:	34fd                	addw	s1,s1,-1
    24ca:	f4e5                	bnez	s1,24b2 <manywrites+0x34>
  exit(0);
    24cc:	4501                	li	a0,0
    24ce:	00003097          	auipc	ra,0x3
    24d2:	7cc080e7          	jalr	1996(ra) # 5c9a <exit>
      printf("fork failed\n");
    24d6:	00006517          	auipc	a0,0x6
    24da:	c1250513          	add	a0,a0,-1006 # 80e8 <malloc+0x1f2c>
    24de:	00004097          	auipc	ra,0x4
    24e2:	c26080e7          	jalr	-986(ra) # 6104 <printf>
      exit(1);
    24e6:	4505                	li	a0,1
    24e8:	00003097          	auipc	ra,0x3
    24ec:	7b2080e7          	jalr	1970(ra) # 5c9a <exit>
      name[0] = 'b';
    24f0:	06200793          	li	a5,98
    24f4:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    24f8:	0619879b          	addw	a5,s3,97
    24fc:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2500:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2504:	fa840513          	add	a0,s0,-88
    2508:	00003097          	auipc	ra,0x3
    250c:	7e2080e7          	jalr	2018(ra) # 5cea <unlink>
    2510:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2512:	0000ab17          	auipc	s6,0xa
    2516:	766b0b13          	add	s6,s6,1894 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    251a:	8a26                	mv	s4,s1
    251c:	0209ce63          	bltz	s3,2558 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2520:	20200593          	li	a1,514
    2524:	fa840513          	add	a0,s0,-88
    2528:	00003097          	auipc	ra,0x3
    252c:	7b2080e7          	jalr	1970(ra) # 5cda <open>
    2530:	892a                	mv	s2,a0
          if(fd < 0){
    2532:	04054763          	bltz	a0,2580 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2536:	660d                	lui	a2,0x3
    2538:	85da                	mv	a1,s6
    253a:	00003097          	auipc	ra,0x3
    253e:	780080e7          	jalr	1920(ra) # 5cba <write>
          if(cc != sz){
    2542:	678d                	lui	a5,0x3
    2544:	04f51e63          	bne	a0,a5,25a0 <manywrites+0x122>
          close(fd);
    2548:	854a                	mv	a0,s2
    254a:	00003097          	auipc	ra,0x3
    254e:	778080e7          	jalr	1912(ra) # 5cc2 <close>
        for(int i = 0; i < ci+1; i++){
    2552:	2a05                	addw	s4,s4,1
    2554:	fd49d6e3          	bge	s3,s4,2520 <manywrites+0xa2>
        unlink(name);
    2558:	fa840513          	add	a0,s0,-88
    255c:	00003097          	auipc	ra,0x3
    2560:	78e080e7          	jalr	1934(ra) # 5cea <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2564:	3bfd                	addw	s7,s7,-1
    2566:	fa0b9ae3          	bnez	s7,251a <manywrites+0x9c>
      unlink(name);
    256a:	fa840513          	add	a0,s0,-88
    256e:	00003097          	auipc	ra,0x3
    2572:	77c080e7          	jalr	1916(ra) # 5cea <unlink>
      exit(0);
    2576:	4501                	li	a0,0
    2578:	00003097          	auipc	ra,0x3
    257c:	722080e7          	jalr	1826(ra) # 5c9a <exit>
            printf("%s: cannot create %s\n", s, name);
    2580:	fa840613          	add	a2,s0,-88
    2584:	85d6                	mv	a1,s5
    2586:	00005517          	auipc	a0,0x5
    258a:	94250513          	add	a0,a0,-1726 # 6ec8 <malloc+0xd0c>
    258e:	00004097          	auipc	ra,0x4
    2592:	b76080e7          	jalr	-1162(ra) # 6104 <printf>
            exit(1);
    2596:	4505                	li	a0,1
    2598:	00003097          	auipc	ra,0x3
    259c:	702080e7          	jalr	1794(ra) # 5c9a <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25a0:	86aa                	mv	a3,a0
    25a2:	660d                	lui	a2,0x3
    25a4:	85d6                	mv	a1,s5
    25a6:	00004517          	auipc	a0,0x4
    25aa:	e1250513          	add	a0,a0,-494 # 63b8 <malloc+0x1fc>
    25ae:	00004097          	auipc	ra,0x4
    25b2:	b56080e7          	jalr	-1194(ra) # 6104 <printf>
            exit(1);
    25b6:	4505                	li	a0,1
    25b8:	00003097          	auipc	ra,0x3
    25bc:	6e2080e7          	jalr	1762(ra) # 5c9a <exit>
      exit(st);
    25c0:	00003097          	auipc	ra,0x3
    25c4:	6da080e7          	jalr	1754(ra) # 5c9a <exit>

00000000000025c8 <copyinstr3>:
{
    25c8:	7179                	add	sp,sp,-48
    25ca:	f406                	sd	ra,40(sp)
    25cc:	f022                	sd	s0,32(sp)
    25ce:	ec26                	sd	s1,24(sp)
    25d0:	1800                	add	s0,sp,48
  sbrk(8192);
    25d2:	6509                	lui	a0,0x2
    25d4:	00003097          	auipc	ra,0x3
    25d8:	74e080e7          	jalr	1870(ra) # 5d22 <sbrk>
  uint64 top = (uint64) sbrk(0);
    25dc:	4501                	li	a0,0
    25de:	00003097          	auipc	ra,0x3
    25e2:	744080e7          	jalr	1860(ra) # 5d22 <sbrk>
  if((top % PGSIZE) != 0){
    25e6:	03451793          	sll	a5,a0,0x34
    25ea:	e3c9                	bnez	a5,266c <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    25ec:	4501                	li	a0,0
    25ee:	00003097          	auipc	ra,0x3
    25f2:	734080e7          	jalr	1844(ra) # 5d22 <sbrk>
  if(top % PGSIZE){
    25f6:	03451793          	sll	a5,a0,0x34
    25fa:	e3d9                	bnez	a5,2680 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    25fc:	fff50493          	add	s1,a0,-1 # 1fff <linkunlink+0x5>
  *b = 'x';
    2600:	07800793          	li	a5,120
    2604:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2608:	8526                	mv	a0,s1
    260a:	00003097          	auipc	ra,0x3
    260e:	6e0080e7          	jalr	1760(ra) # 5cea <unlink>
  if(ret != -1){
    2612:	57fd                	li	a5,-1
    2614:	08f51363          	bne	a0,a5,269a <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2618:	20100593          	li	a1,513
    261c:	8526                	mv	a0,s1
    261e:	00003097          	auipc	ra,0x3
    2622:	6bc080e7          	jalr	1724(ra) # 5cda <open>
  if(fd != -1){
    2626:	57fd                	li	a5,-1
    2628:	08f51863          	bne	a0,a5,26b8 <copyinstr3+0xf0>
  ret = link(b, b);
    262c:	85a6                	mv	a1,s1
    262e:	8526                	mv	a0,s1
    2630:	00003097          	auipc	ra,0x3
    2634:	6ca080e7          	jalr	1738(ra) # 5cfa <link>
  if(ret != -1){
    2638:	57fd                	li	a5,-1
    263a:	08f51e63          	bne	a0,a5,26d6 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    263e:	00005797          	auipc	a5,0x5
    2642:	58a78793          	add	a5,a5,1418 # 7bc8 <malloc+0x1a0c>
    2646:	fcf43823          	sd	a5,-48(s0)
    264a:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    264e:	fd040593          	add	a1,s0,-48
    2652:	8526                	mv	a0,s1
    2654:	00003097          	auipc	ra,0x3
    2658:	67e080e7          	jalr	1662(ra) # 5cd2 <exec>
  if(ret != -1){
    265c:	57fd                	li	a5,-1
    265e:	08f51c63          	bne	a0,a5,26f6 <copyinstr3+0x12e>
}
    2662:	70a2                	ld	ra,40(sp)
    2664:	7402                	ld	s0,32(sp)
    2666:	64e2                	ld	s1,24(sp)
    2668:	6145                	add	sp,sp,48
    266a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    266c:	0347d513          	srl	a0,a5,0x34
    2670:	6785                	lui	a5,0x1
    2672:	40a7853b          	subw	a0,a5,a0
    2676:	00003097          	auipc	ra,0x3
    267a:	6ac080e7          	jalr	1708(ra) # 5d22 <sbrk>
    267e:	b7bd                	j	25ec <copyinstr3+0x24>
    printf("oops\n");
    2680:	00005517          	auipc	a0,0x5
    2684:	86050513          	add	a0,a0,-1952 # 6ee0 <malloc+0xd24>
    2688:	00004097          	auipc	ra,0x4
    268c:	a7c080e7          	jalr	-1412(ra) # 6104 <printf>
    exit(1);
    2690:	4505                	li	a0,1
    2692:	00003097          	auipc	ra,0x3
    2696:	608080e7          	jalr	1544(ra) # 5c9a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    269a:	862a                	mv	a2,a0
    269c:	85a6                	mv	a1,s1
    269e:	00004517          	auipc	a0,0x4
    26a2:	3fa50513          	add	a0,a0,1018 # 6a98 <malloc+0x8dc>
    26a6:	00004097          	auipc	ra,0x4
    26aa:	a5e080e7          	jalr	-1442(ra) # 6104 <printf>
    exit(1);
    26ae:	4505                	li	a0,1
    26b0:	00003097          	auipc	ra,0x3
    26b4:	5ea080e7          	jalr	1514(ra) # 5c9a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26b8:	862a                	mv	a2,a0
    26ba:	85a6                	mv	a1,s1
    26bc:	00004517          	auipc	a0,0x4
    26c0:	3fc50513          	add	a0,a0,1020 # 6ab8 <malloc+0x8fc>
    26c4:	00004097          	auipc	ra,0x4
    26c8:	a40080e7          	jalr	-1472(ra) # 6104 <printf>
    exit(1);
    26cc:	4505                	li	a0,1
    26ce:	00003097          	auipc	ra,0x3
    26d2:	5cc080e7          	jalr	1484(ra) # 5c9a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    26d6:	86aa                	mv	a3,a0
    26d8:	8626                	mv	a2,s1
    26da:	85a6                	mv	a1,s1
    26dc:	00004517          	auipc	a0,0x4
    26e0:	3fc50513          	add	a0,a0,1020 # 6ad8 <malloc+0x91c>
    26e4:	00004097          	auipc	ra,0x4
    26e8:	a20080e7          	jalr	-1504(ra) # 6104 <printf>
    exit(1);
    26ec:	4505                	li	a0,1
    26ee:	00003097          	auipc	ra,0x3
    26f2:	5ac080e7          	jalr	1452(ra) # 5c9a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    26f6:	567d                	li	a2,-1
    26f8:	85a6                	mv	a1,s1
    26fa:	00004517          	auipc	a0,0x4
    26fe:	40650513          	add	a0,a0,1030 # 6b00 <malloc+0x944>
    2702:	00004097          	auipc	ra,0x4
    2706:	a02080e7          	jalr	-1534(ra) # 6104 <printf>
    exit(1);
    270a:	4505                	li	a0,1
    270c:	00003097          	auipc	ra,0x3
    2710:	58e080e7          	jalr	1422(ra) # 5c9a <exit>

0000000000002714 <rwsbrk>:
{
    2714:	1101                	add	sp,sp,-32
    2716:	ec06                	sd	ra,24(sp)
    2718:	e822                	sd	s0,16(sp)
    271a:	e426                	sd	s1,8(sp)
    271c:	e04a                	sd	s2,0(sp)
    271e:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2720:	6509                	lui	a0,0x2
    2722:	00003097          	auipc	ra,0x3
    2726:	600080e7          	jalr	1536(ra) # 5d22 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    272a:	57fd                	li	a5,-1
    272c:	06f50263          	beq	a0,a5,2790 <rwsbrk+0x7c>
    2730:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2732:	7579                	lui	a0,0xffffe
    2734:	00003097          	auipc	ra,0x3
    2738:	5ee080e7          	jalr	1518(ra) # 5d22 <sbrk>
    273c:	57fd                	li	a5,-1
    273e:	06f50663          	beq	a0,a5,27aa <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2742:	20100593          	li	a1,513
    2746:	00004517          	auipc	a0,0x4
    274a:	7da50513          	add	a0,a0,2010 # 6f20 <malloc+0xd64>
    274e:	00003097          	auipc	ra,0x3
    2752:	58c080e7          	jalr	1420(ra) # 5cda <open>
    2756:	892a                	mv	s2,a0
  if(fd < 0){
    2758:	06054663          	bltz	a0,27c4 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    275c:	6785                	lui	a5,0x1
    275e:	94be                	add	s1,s1,a5
    2760:	40000613          	li	a2,1024
    2764:	85a6                	mv	a1,s1
    2766:	00003097          	auipc	ra,0x3
    276a:	554080e7          	jalr	1364(ra) # 5cba <write>
    276e:	862a                	mv	a2,a0
  if(n >= 0){
    2770:	06054763          	bltz	a0,27de <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    2774:	85a6                	mv	a1,s1
    2776:	00004517          	auipc	a0,0x4
    277a:	7ca50513          	add	a0,a0,1994 # 6f40 <malloc+0xd84>
    277e:	00004097          	auipc	ra,0x4
    2782:	986080e7          	jalr	-1658(ra) # 6104 <printf>
    exit(1);
    2786:	4505                	li	a0,1
    2788:	00003097          	auipc	ra,0x3
    278c:	512080e7          	jalr	1298(ra) # 5c9a <exit>
    printf("sbrk(rwsbrk) failed\n");
    2790:	00004517          	auipc	a0,0x4
    2794:	75850513          	add	a0,a0,1880 # 6ee8 <malloc+0xd2c>
    2798:	00004097          	auipc	ra,0x4
    279c:	96c080e7          	jalr	-1684(ra) # 6104 <printf>
    exit(1);
    27a0:	4505                	li	a0,1
    27a2:	00003097          	auipc	ra,0x3
    27a6:	4f8080e7          	jalr	1272(ra) # 5c9a <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27aa:	00004517          	auipc	a0,0x4
    27ae:	75650513          	add	a0,a0,1878 # 6f00 <malloc+0xd44>
    27b2:	00004097          	auipc	ra,0x4
    27b6:	952080e7          	jalr	-1710(ra) # 6104 <printf>
    exit(1);
    27ba:	4505                	li	a0,1
    27bc:	00003097          	auipc	ra,0x3
    27c0:	4de080e7          	jalr	1246(ra) # 5c9a <exit>
    printf("open(rwsbrk) failed\n");
    27c4:	00004517          	auipc	a0,0x4
    27c8:	76450513          	add	a0,a0,1892 # 6f28 <malloc+0xd6c>
    27cc:	00004097          	auipc	ra,0x4
    27d0:	938080e7          	jalr	-1736(ra) # 6104 <printf>
    exit(1);
    27d4:	4505                	li	a0,1
    27d6:	00003097          	auipc	ra,0x3
    27da:	4c4080e7          	jalr	1220(ra) # 5c9a <exit>
  close(fd);
    27de:	854a                	mv	a0,s2
    27e0:	00003097          	auipc	ra,0x3
    27e4:	4e2080e7          	jalr	1250(ra) # 5cc2 <close>
  unlink("rwsbrk");
    27e8:	00004517          	auipc	a0,0x4
    27ec:	73850513          	add	a0,a0,1848 # 6f20 <malloc+0xd64>
    27f0:	00003097          	auipc	ra,0x3
    27f4:	4fa080e7          	jalr	1274(ra) # 5cea <unlink>
  fd = open("README", O_RDONLY);
    27f8:	4581                	li	a1,0
    27fa:	00004517          	auipc	a0,0x4
    27fe:	cc650513          	add	a0,a0,-826 # 64c0 <malloc+0x304>
    2802:	00003097          	auipc	ra,0x3
    2806:	4d8080e7          	jalr	1240(ra) # 5cda <open>
    280a:	892a                	mv	s2,a0
  if(fd < 0){
    280c:	02054963          	bltz	a0,283e <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2810:	4629                	li	a2,10
    2812:	85a6                	mv	a1,s1
    2814:	00003097          	auipc	ra,0x3
    2818:	49e080e7          	jalr	1182(ra) # 5cb2 <read>
    281c:	862a                	mv	a2,a0
  if(n >= 0){
    281e:	02054d63          	bltz	a0,2858 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    2822:	85a6                	mv	a1,s1
    2824:	00004517          	auipc	a0,0x4
    2828:	74c50513          	add	a0,a0,1868 # 6f70 <malloc+0xdb4>
    282c:	00004097          	auipc	ra,0x4
    2830:	8d8080e7          	jalr	-1832(ra) # 6104 <printf>
    exit(1);
    2834:	4505                	li	a0,1
    2836:	00003097          	auipc	ra,0x3
    283a:	464080e7          	jalr	1124(ra) # 5c9a <exit>
    printf("open(rwsbrk) failed\n");
    283e:	00004517          	auipc	a0,0x4
    2842:	6ea50513          	add	a0,a0,1770 # 6f28 <malloc+0xd6c>
    2846:	00004097          	auipc	ra,0x4
    284a:	8be080e7          	jalr	-1858(ra) # 6104 <printf>
    exit(1);
    284e:	4505                	li	a0,1
    2850:	00003097          	auipc	ra,0x3
    2854:	44a080e7          	jalr	1098(ra) # 5c9a <exit>
  close(fd);
    2858:	854a                	mv	a0,s2
    285a:	00003097          	auipc	ra,0x3
    285e:	468080e7          	jalr	1128(ra) # 5cc2 <close>
  exit(0);
    2862:	4501                	li	a0,0
    2864:	00003097          	auipc	ra,0x3
    2868:	436080e7          	jalr	1078(ra) # 5c9a <exit>

000000000000286c <sbrkbasic>:
{
    286c:	7139                	add	sp,sp,-64
    286e:	fc06                	sd	ra,56(sp)
    2870:	f822                	sd	s0,48(sp)
    2872:	f426                	sd	s1,40(sp)
    2874:	f04a                	sd	s2,32(sp)
    2876:	ec4e                	sd	s3,24(sp)
    2878:	e852                	sd	s4,16(sp)
    287a:	0080                	add	s0,sp,64
    287c:	8a2a                	mv	s4,a0
  pid = fork();
    287e:	00003097          	auipc	ra,0x3
    2882:	414080e7          	jalr	1044(ra) # 5c92 <fork>
  if(pid < 0){
    2886:	02054c63          	bltz	a0,28be <sbrkbasic+0x52>
  if(pid == 0){
    288a:	ed21                	bnez	a0,28e2 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    288c:	40000537          	lui	a0,0x40000
    2890:	00003097          	auipc	ra,0x3
    2894:	492080e7          	jalr	1170(ra) # 5d22 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2898:	57fd                	li	a5,-1
    289a:	02f50f63          	beq	a0,a5,28d8 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    289e:	400007b7          	lui	a5,0x40000
    28a2:	97aa                	add	a5,a5,a0
      *b = 99;
    28a4:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28a8:	6705                	lui	a4,0x1
      *b = 99;
    28aa:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28ae:	953a                	add	a0,a0,a4
    28b0:	fef51de3          	bne	a0,a5,28aa <sbrkbasic+0x3e>
    exit(1);
    28b4:	4505                	li	a0,1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	3e4080e7          	jalr	996(ra) # 5c9a <exit>
    printf("fork failed in sbrkbasic\n");
    28be:	00004517          	auipc	a0,0x4
    28c2:	6da50513          	add	a0,a0,1754 # 6f98 <malloc+0xddc>
    28c6:	00004097          	auipc	ra,0x4
    28ca:	83e080e7          	jalr	-1986(ra) # 6104 <printf>
    exit(1);
    28ce:	4505                	li	a0,1
    28d0:	00003097          	auipc	ra,0x3
    28d4:	3ca080e7          	jalr	970(ra) # 5c9a <exit>
      exit(0);
    28d8:	4501                	li	a0,0
    28da:	00003097          	auipc	ra,0x3
    28de:	3c0080e7          	jalr	960(ra) # 5c9a <exit>
  wait(&xstatus);
    28e2:	fcc40513          	add	a0,s0,-52
    28e6:	00003097          	auipc	ra,0x3
    28ea:	3bc080e7          	jalr	956(ra) # 5ca2 <wait>
  if(xstatus == 1){
    28ee:	fcc42703          	lw	a4,-52(s0)
    28f2:	4785                	li	a5,1
    28f4:	00f70d63          	beq	a4,a5,290e <sbrkbasic+0xa2>
  a = sbrk(0);
    28f8:	4501                	li	a0,0
    28fa:	00003097          	auipc	ra,0x3
    28fe:	428080e7          	jalr	1064(ra) # 5d22 <sbrk>
    2902:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2904:	4901                	li	s2,0
    2906:	6985                	lui	s3,0x1
    2908:	38898993          	add	s3,s3,904 # 1388 <pgbug+0xc>
    290c:	a005                	j	292c <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    290e:	85d2                	mv	a1,s4
    2910:	00004517          	auipc	a0,0x4
    2914:	6a850513          	add	a0,a0,1704 # 6fb8 <malloc+0xdfc>
    2918:	00003097          	auipc	ra,0x3
    291c:	7ec080e7          	jalr	2028(ra) # 6104 <printf>
    exit(1);
    2920:	4505                	li	a0,1
    2922:	00003097          	auipc	ra,0x3
    2926:	378080e7          	jalr	888(ra) # 5c9a <exit>
    a = b + 1;
    292a:	84be                	mv	s1,a5
    b = sbrk(1);
    292c:	4505                	li	a0,1
    292e:	00003097          	auipc	ra,0x3
    2932:	3f4080e7          	jalr	1012(ra) # 5d22 <sbrk>
    if(b != a){
    2936:	04951c63          	bne	a0,s1,298e <sbrkbasic+0x122>
    *b = 1;
    293a:	4785                	li	a5,1
    293c:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2940:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    2944:	2905                	addw	s2,s2,1
    2946:	ff3912e3          	bne	s2,s3,292a <sbrkbasic+0xbe>
  pid = fork();
    294a:	00003097          	auipc	ra,0x3
    294e:	348080e7          	jalr	840(ra) # 5c92 <fork>
    2952:	892a                	mv	s2,a0
  if(pid < 0){
    2954:	04054e63          	bltz	a0,29b0 <sbrkbasic+0x144>
  c = sbrk(1);
    2958:	4505                	li	a0,1
    295a:	00003097          	auipc	ra,0x3
    295e:	3c8080e7          	jalr	968(ra) # 5d22 <sbrk>
  c = sbrk(1);
    2962:	4505                	li	a0,1
    2964:	00003097          	auipc	ra,0x3
    2968:	3be080e7          	jalr	958(ra) # 5d22 <sbrk>
  if(c != a + 1){
    296c:	0489                	add	s1,s1,2
    296e:	04a48f63          	beq	s1,a0,29cc <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    2972:	85d2                	mv	a1,s4
    2974:	00004517          	auipc	a0,0x4
    2978:	6a450513          	add	a0,a0,1700 # 7018 <malloc+0xe5c>
    297c:	00003097          	auipc	ra,0x3
    2980:	788080e7          	jalr	1928(ra) # 6104 <printf>
    exit(1);
    2984:	4505                	li	a0,1
    2986:	00003097          	auipc	ra,0x3
    298a:	314080e7          	jalr	788(ra) # 5c9a <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    298e:	872a                	mv	a4,a0
    2990:	86a6                	mv	a3,s1
    2992:	864a                	mv	a2,s2
    2994:	85d2                	mv	a1,s4
    2996:	00004517          	auipc	a0,0x4
    299a:	64250513          	add	a0,a0,1602 # 6fd8 <malloc+0xe1c>
    299e:	00003097          	auipc	ra,0x3
    29a2:	766080e7          	jalr	1894(ra) # 6104 <printf>
      exit(1);
    29a6:	4505                	li	a0,1
    29a8:	00003097          	auipc	ra,0x3
    29ac:	2f2080e7          	jalr	754(ra) # 5c9a <exit>
    printf("%s: sbrk test fork failed\n", s);
    29b0:	85d2                	mv	a1,s4
    29b2:	00004517          	auipc	a0,0x4
    29b6:	64650513          	add	a0,a0,1606 # 6ff8 <malloc+0xe3c>
    29ba:	00003097          	auipc	ra,0x3
    29be:	74a080e7          	jalr	1866(ra) # 6104 <printf>
    exit(1);
    29c2:	4505                	li	a0,1
    29c4:	00003097          	auipc	ra,0x3
    29c8:	2d6080e7          	jalr	726(ra) # 5c9a <exit>
  if(pid == 0)
    29cc:	00091763          	bnez	s2,29da <sbrkbasic+0x16e>
    exit(0);
    29d0:	4501                	li	a0,0
    29d2:	00003097          	auipc	ra,0x3
    29d6:	2c8080e7          	jalr	712(ra) # 5c9a <exit>
  wait(&xstatus);
    29da:	fcc40513          	add	a0,s0,-52
    29de:	00003097          	auipc	ra,0x3
    29e2:	2c4080e7          	jalr	708(ra) # 5ca2 <wait>
  exit(xstatus);
    29e6:	fcc42503          	lw	a0,-52(s0)
    29ea:	00003097          	auipc	ra,0x3
    29ee:	2b0080e7          	jalr	688(ra) # 5c9a <exit>

00000000000029f2 <sbrkmuch>:
{
    29f2:	7179                	add	sp,sp,-48
    29f4:	f406                	sd	ra,40(sp)
    29f6:	f022                	sd	s0,32(sp)
    29f8:	ec26                	sd	s1,24(sp)
    29fa:	e84a                	sd	s2,16(sp)
    29fc:	e44e                	sd	s3,8(sp)
    29fe:	e052                	sd	s4,0(sp)
    2a00:	1800                	add	s0,sp,48
    2a02:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a04:	4501                	li	a0,0
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	31c080e7          	jalr	796(ra) # 5d22 <sbrk>
    2a0e:	892a                	mv	s2,a0
  a = sbrk(0);
    2a10:	4501                	li	a0,0
    2a12:	00003097          	auipc	ra,0x3
    2a16:	310080e7          	jalr	784(ra) # 5d22 <sbrk>
    2a1a:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a1c:	06400537          	lui	a0,0x6400
    2a20:	9d05                	subw	a0,a0,s1
    2a22:	00003097          	auipc	ra,0x3
    2a26:	300080e7          	jalr	768(ra) # 5d22 <sbrk>
  if (p != a) {
    2a2a:	0ca49863          	bne	s1,a0,2afa <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a2e:	4501                	li	a0,0
    2a30:	00003097          	auipc	ra,0x3
    2a34:	2f2080e7          	jalr	754(ra) # 5d22 <sbrk>
    2a38:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a3a:	00a4f963          	bgeu	s1,a0,2a4c <sbrkmuch+0x5a>
    *pp = 1;
    2a3e:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a40:	6705                	lui	a4,0x1
    *pp = 1;
    2a42:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a46:	94ba                	add	s1,s1,a4
    2a48:	fef4ede3          	bltu	s1,a5,2a42 <sbrkmuch+0x50>
  *lastaddr = 99;
    2a4c:	064007b7          	lui	a5,0x6400
    2a50:	06300713          	li	a4,99
    2a54:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2a58:	4501                	li	a0,0
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	2c8080e7          	jalr	712(ra) # 5d22 <sbrk>
    2a62:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2a64:	757d                	lui	a0,0xfffff
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	2bc080e7          	jalr	700(ra) # 5d22 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2a6e:	57fd                	li	a5,-1
    2a70:	0af50363          	beq	a0,a5,2b16 <sbrkmuch+0x124>
  c = sbrk(0);
    2a74:	4501                	li	a0,0
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	2ac080e7          	jalr	684(ra) # 5d22 <sbrk>
  if(c != a - PGSIZE){
    2a7e:	77fd                	lui	a5,0xfffff
    2a80:	97a6                	add	a5,a5,s1
    2a82:	0af51863          	bne	a0,a5,2b32 <sbrkmuch+0x140>
  a = sbrk(0);
    2a86:	4501                	li	a0,0
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	29a080e7          	jalr	666(ra) # 5d22 <sbrk>
    2a90:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2a92:	6505                	lui	a0,0x1
    2a94:	00003097          	auipc	ra,0x3
    2a98:	28e080e7          	jalr	654(ra) # 5d22 <sbrk>
    2a9c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2a9e:	0aa49a63          	bne	s1,a0,2b52 <sbrkmuch+0x160>
    2aa2:	4501                	li	a0,0
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	27e080e7          	jalr	638(ra) # 5d22 <sbrk>
    2aac:	6785                	lui	a5,0x1
    2aae:	97a6                	add	a5,a5,s1
    2ab0:	0af51163          	bne	a0,a5,2b52 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2ab4:	064007b7          	lui	a5,0x6400
    2ab8:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2abc:	06300793          	li	a5,99
    2ac0:	0af70963          	beq	a4,a5,2b72 <sbrkmuch+0x180>
  a = sbrk(0);
    2ac4:	4501                	li	a0,0
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	25c080e7          	jalr	604(ra) # 5d22 <sbrk>
    2ace:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2ad0:	4501                	li	a0,0
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	250080e7          	jalr	592(ra) # 5d22 <sbrk>
    2ada:	40a9053b          	subw	a0,s2,a0
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	244080e7          	jalr	580(ra) # 5d22 <sbrk>
  if(c != a){
    2ae6:	0aa49463          	bne	s1,a0,2b8e <sbrkmuch+0x19c>
}
    2aea:	70a2                	ld	ra,40(sp)
    2aec:	7402                	ld	s0,32(sp)
    2aee:	64e2                	ld	s1,24(sp)
    2af0:	6942                	ld	s2,16(sp)
    2af2:	69a2                	ld	s3,8(sp)
    2af4:	6a02                	ld	s4,0(sp)
    2af6:	6145                	add	sp,sp,48
    2af8:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2afa:	85ce                	mv	a1,s3
    2afc:	00004517          	auipc	a0,0x4
    2b00:	53c50513          	add	a0,a0,1340 # 7038 <malloc+0xe7c>
    2b04:	00003097          	auipc	ra,0x3
    2b08:	600080e7          	jalr	1536(ra) # 6104 <printf>
    exit(1);
    2b0c:	4505                	li	a0,1
    2b0e:	00003097          	auipc	ra,0x3
    2b12:	18c080e7          	jalr	396(ra) # 5c9a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b16:	85ce                	mv	a1,s3
    2b18:	00004517          	auipc	a0,0x4
    2b1c:	56850513          	add	a0,a0,1384 # 7080 <malloc+0xec4>
    2b20:	00003097          	auipc	ra,0x3
    2b24:	5e4080e7          	jalr	1508(ra) # 6104 <printf>
    exit(1);
    2b28:	4505                	li	a0,1
    2b2a:	00003097          	auipc	ra,0x3
    2b2e:	170080e7          	jalr	368(ra) # 5c9a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2b32:	86aa                	mv	a3,a0
    2b34:	8626                	mv	a2,s1
    2b36:	85ce                	mv	a1,s3
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	56850513          	add	a0,a0,1384 # 70a0 <malloc+0xee4>
    2b40:	00003097          	auipc	ra,0x3
    2b44:	5c4080e7          	jalr	1476(ra) # 6104 <printf>
    exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	150080e7          	jalr	336(ra) # 5c9a <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2b52:	86d2                	mv	a3,s4
    2b54:	8626                	mv	a2,s1
    2b56:	85ce                	mv	a1,s3
    2b58:	00004517          	auipc	a0,0x4
    2b5c:	58850513          	add	a0,a0,1416 # 70e0 <malloc+0xf24>
    2b60:	00003097          	auipc	ra,0x3
    2b64:	5a4080e7          	jalr	1444(ra) # 6104 <printf>
    exit(1);
    2b68:	4505                	li	a0,1
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	130080e7          	jalr	304(ra) # 5c9a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2b72:	85ce                	mv	a1,s3
    2b74:	00004517          	auipc	a0,0x4
    2b78:	59c50513          	add	a0,a0,1436 # 7110 <malloc+0xf54>
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	588080e7          	jalr	1416(ra) # 6104 <printf>
    exit(1);
    2b84:	4505                	li	a0,1
    2b86:	00003097          	auipc	ra,0x3
    2b8a:	114080e7          	jalr	276(ra) # 5c9a <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2b8e:	86aa                	mv	a3,a0
    2b90:	8626                	mv	a2,s1
    2b92:	85ce                	mv	a1,s3
    2b94:	00004517          	auipc	a0,0x4
    2b98:	5b450513          	add	a0,a0,1460 # 7148 <malloc+0xf8c>
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	568080e7          	jalr	1384(ra) # 6104 <printf>
    exit(1);
    2ba4:	4505                	li	a0,1
    2ba6:	00003097          	auipc	ra,0x3
    2baa:	0f4080e7          	jalr	244(ra) # 5c9a <exit>

0000000000002bae <sbrkarg>:
{
    2bae:	7179                	add	sp,sp,-48
    2bb0:	f406                	sd	ra,40(sp)
    2bb2:	f022                	sd	s0,32(sp)
    2bb4:	ec26                	sd	s1,24(sp)
    2bb6:	e84a                	sd	s2,16(sp)
    2bb8:	e44e                	sd	s3,8(sp)
    2bba:	1800                	add	s0,sp,48
    2bbc:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2bbe:	6505                	lui	a0,0x1
    2bc0:	00003097          	auipc	ra,0x3
    2bc4:	162080e7          	jalr	354(ra) # 5d22 <sbrk>
    2bc8:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2bca:	20100593          	li	a1,513
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	5a250513          	add	a0,a0,1442 # 7170 <malloc+0xfb4>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	104080e7          	jalr	260(ra) # 5cda <open>
    2bde:	84aa                	mv	s1,a0
  unlink("sbrk");
    2be0:	00004517          	auipc	a0,0x4
    2be4:	59050513          	add	a0,a0,1424 # 7170 <malloc+0xfb4>
    2be8:	00003097          	auipc	ra,0x3
    2bec:	102080e7          	jalr	258(ra) # 5cea <unlink>
  if(fd < 0)  {
    2bf0:	0404c163          	bltz	s1,2c32 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2bf4:	6605                	lui	a2,0x1
    2bf6:	85ca                	mv	a1,s2
    2bf8:	8526                	mv	a0,s1
    2bfa:	00003097          	auipc	ra,0x3
    2bfe:	0c0080e7          	jalr	192(ra) # 5cba <write>
    2c02:	04054663          	bltz	a0,2c4e <sbrkarg+0xa0>
  close(fd);
    2c06:	8526                	mv	a0,s1
    2c08:	00003097          	auipc	ra,0x3
    2c0c:	0ba080e7          	jalr	186(ra) # 5cc2 <close>
  a = sbrk(PGSIZE);
    2c10:	6505                	lui	a0,0x1
    2c12:	00003097          	auipc	ra,0x3
    2c16:	110080e7          	jalr	272(ra) # 5d22 <sbrk>
  if(pipe((int *) a) != 0){
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	090080e7          	jalr	144(ra) # 5caa <pipe>
    2c22:	e521                	bnez	a0,2c6a <sbrkarg+0xbc>
}
    2c24:	70a2                	ld	ra,40(sp)
    2c26:	7402                	ld	s0,32(sp)
    2c28:	64e2                	ld	s1,24(sp)
    2c2a:	6942                	ld	s2,16(sp)
    2c2c:	69a2                	ld	s3,8(sp)
    2c2e:	6145                	add	sp,sp,48
    2c30:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c32:	85ce                	mv	a1,s3
    2c34:	00004517          	auipc	a0,0x4
    2c38:	54450513          	add	a0,a0,1348 # 7178 <malloc+0xfbc>
    2c3c:	00003097          	auipc	ra,0x3
    2c40:	4c8080e7          	jalr	1224(ra) # 6104 <printf>
    exit(1);
    2c44:	4505                	li	a0,1
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	054080e7          	jalr	84(ra) # 5c9a <exit>
    printf("%s: write sbrk failed\n", s);
    2c4e:	85ce                	mv	a1,s3
    2c50:	00004517          	auipc	a0,0x4
    2c54:	54050513          	add	a0,a0,1344 # 7190 <malloc+0xfd4>
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	4ac080e7          	jalr	1196(ra) # 6104 <printf>
    exit(1);
    2c60:	4505                	li	a0,1
    2c62:	00003097          	auipc	ra,0x3
    2c66:	038080e7          	jalr	56(ra) # 5c9a <exit>
    printf("%s: pipe() failed\n", s);
    2c6a:	85ce                	mv	a1,s3
    2c6c:	00004517          	auipc	a0,0x4
    2c70:	01450513          	add	a0,a0,20 # 6c80 <malloc+0xac4>
    2c74:	00003097          	auipc	ra,0x3
    2c78:	490080e7          	jalr	1168(ra) # 6104 <printf>
    exit(1);
    2c7c:	4505                	li	a0,1
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	01c080e7          	jalr	28(ra) # 5c9a <exit>

0000000000002c86 <argptest>:
{
    2c86:	1101                	add	sp,sp,-32
    2c88:	ec06                	sd	ra,24(sp)
    2c8a:	e822                	sd	s0,16(sp)
    2c8c:	e426                	sd	s1,8(sp)
    2c8e:	e04a                	sd	s2,0(sp)
    2c90:	1000                	add	s0,sp,32
    2c92:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2c94:	4581                	li	a1,0
    2c96:	00004517          	auipc	a0,0x4
    2c9a:	51250513          	add	a0,a0,1298 # 71a8 <malloc+0xfec>
    2c9e:	00003097          	auipc	ra,0x3
    2ca2:	03c080e7          	jalr	60(ra) # 5cda <open>
  if (fd < 0) {
    2ca6:	02054b63          	bltz	a0,2cdc <argptest+0x56>
    2caa:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cac:	4501                	li	a0,0
    2cae:	00003097          	auipc	ra,0x3
    2cb2:	074080e7          	jalr	116(ra) # 5d22 <sbrk>
    2cb6:	567d                	li	a2,-1
    2cb8:	fff50593          	add	a1,a0,-1
    2cbc:	8526                	mv	a0,s1
    2cbe:	00003097          	auipc	ra,0x3
    2cc2:	ff4080e7          	jalr	-12(ra) # 5cb2 <read>
  close(fd);
    2cc6:	8526                	mv	a0,s1
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	ffa080e7          	jalr	-6(ra) # 5cc2 <close>
}
    2cd0:	60e2                	ld	ra,24(sp)
    2cd2:	6442                	ld	s0,16(sp)
    2cd4:	64a2                	ld	s1,8(sp)
    2cd6:	6902                	ld	s2,0(sp)
    2cd8:	6105                	add	sp,sp,32
    2cda:	8082                	ret
    printf("%s: open failed\n", s);
    2cdc:	85ca                	mv	a1,s2
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	eb250513          	add	a0,a0,-334 # 6b90 <malloc+0x9d4>
    2ce6:	00003097          	auipc	ra,0x3
    2cea:	41e080e7          	jalr	1054(ra) # 6104 <printf>
    exit(1);
    2cee:	4505                	li	a0,1
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	faa080e7          	jalr	-86(ra) # 5c9a <exit>

0000000000002cf8 <sbrkbugs>:
{
    2cf8:	1141                	add	sp,sp,-16
    2cfa:	e406                	sd	ra,8(sp)
    2cfc:	e022                	sd	s0,0(sp)
    2cfe:	0800                	add	s0,sp,16
  int pid = fork();
    2d00:	00003097          	auipc	ra,0x3
    2d04:	f92080e7          	jalr	-110(ra) # 5c92 <fork>
  if(pid < 0){
    2d08:	02054263          	bltz	a0,2d2c <sbrkbugs+0x34>
  if(pid == 0){
    2d0c:	ed0d                	bnez	a0,2d46 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	014080e7          	jalr	20(ra) # 5d22 <sbrk>
    sbrk(-sz);
    2d16:	40a0053b          	negw	a0,a0
    2d1a:	00003097          	auipc	ra,0x3
    2d1e:	008080e7          	jalr	8(ra) # 5d22 <sbrk>
    exit(0);
    2d22:	4501                	li	a0,0
    2d24:	00003097          	auipc	ra,0x3
    2d28:	f76080e7          	jalr	-138(ra) # 5c9a <exit>
    printf("fork failed\n");
    2d2c:	00005517          	auipc	a0,0x5
    2d30:	3bc50513          	add	a0,a0,956 # 80e8 <malloc+0x1f2c>
    2d34:	00003097          	auipc	ra,0x3
    2d38:	3d0080e7          	jalr	976(ra) # 6104 <printf>
    exit(1);
    2d3c:	4505                	li	a0,1
    2d3e:	00003097          	auipc	ra,0x3
    2d42:	f5c080e7          	jalr	-164(ra) # 5c9a <exit>
  wait(0);
    2d46:	4501                	li	a0,0
    2d48:	00003097          	auipc	ra,0x3
    2d4c:	f5a080e7          	jalr	-166(ra) # 5ca2 <wait>
  pid = fork();
    2d50:	00003097          	auipc	ra,0x3
    2d54:	f42080e7          	jalr	-190(ra) # 5c92 <fork>
  if(pid < 0){
    2d58:	02054563          	bltz	a0,2d82 <sbrkbugs+0x8a>
  if(pid == 0){
    2d5c:	e121                	bnez	a0,2d9c <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	fc4080e7          	jalr	-60(ra) # 5d22 <sbrk>
    sbrk(-(sz - 3500));
    2d66:	6785                	lui	a5,0x1
    2d68:	dac7879b          	addw	a5,a5,-596 # dac <unlinkread+0x6>
    2d6c:	40a7853b          	subw	a0,a5,a0
    2d70:	00003097          	auipc	ra,0x3
    2d74:	fb2080e7          	jalr	-78(ra) # 5d22 <sbrk>
    exit(0);
    2d78:	4501                	li	a0,0
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	f20080e7          	jalr	-224(ra) # 5c9a <exit>
    printf("fork failed\n");
    2d82:	00005517          	auipc	a0,0x5
    2d86:	36650513          	add	a0,a0,870 # 80e8 <malloc+0x1f2c>
    2d8a:	00003097          	auipc	ra,0x3
    2d8e:	37a080e7          	jalr	890(ra) # 6104 <printf>
    exit(1);
    2d92:	4505                	li	a0,1
    2d94:	00003097          	auipc	ra,0x3
    2d98:	f06080e7          	jalr	-250(ra) # 5c9a <exit>
  wait(0);
    2d9c:	4501                	li	a0,0
    2d9e:	00003097          	auipc	ra,0x3
    2da2:	f04080e7          	jalr	-252(ra) # 5ca2 <wait>
  pid = fork();
    2da6:	00003097          	auipc	ra,0x3
    2daa:	eec080e7          	jalr	-276(ra) # 5c92 <fork>
  if(pid < 0){
    2dae:	02054a63          	bltz	a0,2de2 <sbrkbugs+0xea>
  if(pid == 0){
    2db2:	e529                	bnez	a0,2dfc <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2db4:	00003097          	auipc	ra,0x3
    2db8:	f6e080e7          	jalr	-146(ra) # 5d22 <sbrk>
    2dbc:	67ad                	lui	a5,0xb
    2dbe:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x298>
    2dc2:	40a7853b          	subw	a0,a5,a0
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	f5c080e7          	jalr	-164(ra) # 5d22 <sbrk>
    sbrk(-10);
    2dce:	5559                	li	a0,-10
    2dd0:	00003097          	auipc	ra,0x3
    2dd4:	f52080e7          	jalr	-174(ra) # 5d22 <sbrk>
    exit(0);
    2dd8:	4501                	li	a0,0
    2dda:	00003097          	auipc	ra,0x3
    2dde:	ec0080e7          	jalr	-320(ra) # 5c9a <exit>
    printf("fork failed\n");
    2de2:	00005517          	auipc	a0,0x5
    2de6:	30650513          	add	a0,a0,774 # 80e8 <malloc+0x1f2c>
    2dea:	00003097          	auipc	ra,0x3
    2dee:	31a080e7          	jalr	794(ra) # 6104 <printf>
    exit(1);
    2df2:	4505                	li	a0,1
    2df4:	00003097          	auipc	ra,0x3
    2df8:	ea6080e7          	jalr	-346(ra) # 5c9a <exit>
  wait(0);
    2dfc:	4501                	li	a0,0
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	ea4080e7          	jalr	-348(ra) # 5ca2 <wait>
  exit(0);
    2e06:	4501                	li	a0,0
    2e08:	00003097          	auipc	ra,0x3
    2e0c:	e92080e7          	jalr	-366(ra) # 5c9a <exit>

0000000000002e10 <sbrklast>:
{
    2e10:	7179                	add	sp,sp,-48
    2e12:	f406                	sd	ra,40(sp)
    2e14:	f022                	sd	s0,32(sp)
    2e16:	ec26                	sd	s1,24(sp)
    2e18:	e84a                	sd	s2,16(sp)
    2e1a:	e44e                	sd	s3,8(sp)
    2e1c:	e052                	sd	s4,0(sp)
    2e1e:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e20:	4501                	li	a0,0
    2e22:	00003097          	auipc	ra,0x3
    2e26:	f00080e7          	jalr	-256(ra) # 5d22 <sbrk>
  if((top % 4096) != 0)
    2e2a:	03451793          	sll	a5,a0,0x34
    2e2e:	ebd9                	bnez	a5,2ec4 <sbrklast+0xb4>
  sbrk(4096);
    2e30:	6505                	lui	a0,0x1
    2e32:	00003097          	auipc	ra,0x3
    2e36:	ef0080e7          	jalr	-272(ra) # 5d22 <sbrk>
  sbrk(10);
    2e3a:	4529                	li	a0,10
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	ee6080e7          	jalr	-282(ra) # 5d22 <sbrk>
  sbrk(-20);
    2e44:	5531                	li	a0,-20
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	edc080e7          	jalr	-292(ra) # 5d22 <sbrk>
  top = (uint64) sbrk(0);
    2e4e:	4501                	li	a0,0
    2e50:	00003097          	auipc	ra,0x3
    2e54:	ed2080e7          	jalr	-302(ra) # 5d22 <sbrk>
    2e58:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2e5a:	fc050913          	add	s2,a0,-64 # fc0 <linktest+0x64>
  p[0] = 'x';
    2e5e:	07800a13          	li	s4,120
    2e62:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2e66:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2e6a:	20200593          	li	a1,514
    2e6e:	854a                	mv	a0,s2
    2e70:	00003097          	auipc	ra,0x3
    2e74:	e6a080e7          	jalr	-406(ra) # 5cda <open>
    2e78:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2e7a:	4605                	li	a2,1
    2e7c:	85ca                	mv	a1,s2
    2e7e:	00003097          	auipc	ra,0x3
    2e82:	e3c080e7          	jalr	-452(ra) # 5cba <write>
  close(fd);
    2e86:	854e                	mv	a0,s3
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	e3a080e7          	jalr	-454(ra) # 5cc2 <close>
  fd = open(p, O_RDWR);
    2e90:	4589                	li	a1,2
    2e92:	854a                	mv	a0,s2
    2e94:	00003097          	auipc	ra,0x3
    2e98:	e46080e7          	jalr	-442(ra) # 5cda <open>
  p[0] = '\0';
    2e9c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ea0:	4605                	li	a2,1
    2ea2:	85ca                	mv	a1,s2
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	e0e080e7          	jalr	-498(ra) # 5cb2 <read>
  if(p[0] != 'x')
    2eac:	fc04c783          	lbu	a5,-64(s1)
    2eb0:	03479463          	bne	a5,s4,2ed8 <sbrklast+0xc8>
}
    2eb4:	70a2                	ld	ra,40(sp)
    2eb6:	7402                	ld	s0,32(sp)
    2eb8:	64e2                	ld	s1,24(sp)
    2eba:	6942                	ld	s2,16(sp)
    2ebc:	69a2                	ld	s3,8(sp)
    2ebe:	6a02                	ld	s4,0(sp)
    2ec0:	6145                	add	sp,sp,48
    2ec2:	8082                	ret
    sbrk(4096 - (top % 4096));
    2ec4:	0347d513          	srl	a0,a5,0x34
    2ec8:	6785                	lui	a5,0x1
    2eca:	40a7853b          	subw	a0,a5,a0
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	e54080e7          	jalr	-428(ra) # 5d22 <sbrk>
    2ed6:	bfa9                	j	2e30 <sbrklast+0x20>
    exit(1);
    2ed8:	4505                	li	a0,1
    2eda:	00003097          	auipc	ra,0x3
    2ede:	dc0080e7          	jalr	-576(ra) # 5c9a <exit>

0000000000002ee2 <sbrk8000>:
{
    2ee2:	1141                	add	sp,sp,-16
    2ee4:	e406                	sd	ra,8(sp)
    2ee6:	e022                	sd	s0,0(sp)
    2ee8:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2eea:	80000537          	lui	a0,0x80000
    2eee:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2ef0:	00003097          	auipc	ra,0x3
    2ef4:	e32080e7          	jalr	-462(ra) # 5d22 <sbrk>
  volatile char *top = sbrk(0);
    2ef8:	4501                	li	a0,0
    2efa:	00003097          	auipc	ra,0x3
    2efe:	e28080e7          	jalr	-472(ra) # 5d22 <sbrk>
  *(top-1) = *(top-1) + 1;
    2f02:	fff54783          	lbu	a5,-1(a0)
    2f06:	2785                	addw	a5,a5,1 # 1001 <linktest+0xa5>
    2f08:	0ff7f793          	zext.b	a5,a5
    2f0c:	fef50fa3          	sb	a5,-1(a0)
}
    2f10:	60a2                	ld	ra,8(sp)
    2f12:	6402                	ld	s0,0(sp)
    2f14:	0141                	add	sp,sp,16
    2f16:	8082                	ret

0000000000002f18 <execout>:
{
    2f18:	715d                	add	sp,sp,-80
    2f1a:	e486                	sd	ra,72(sp)
    2f1c:	e0a2                	sd	s0,64(sp)
    2f1e:	fc26                	sd	s1,56(sp)
    2f20:	f84a                	sd	s2,48(sp)
    2f22:	f44e                	sd	s3,40(sp)
    2f24:	f052                	sd	s4,32(sp)
    2f26:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f28:	4901                	li	s2,0
    2f2a:	49bd                	li	s3,15
    int pid = fork();
    2f2c:	00003097          	auipc	ra,0x3
    2f30:	d66080e7          	jalr	-666(ra) # 5c92 <fork>
    2f34:	84aa                	mv	s1,a0
    if(pid < 0){
    2f36:	02054063          	bltz	a0,2f56 <execout+0x3e>
    } else if(pid == 0){
    2f3a:	c91d                	beqz	a0,2f70 <execout+0x58>
      wait((int*)0);
    2f3c:	4501                	li	a0,0
    2f3e:	00003097          	auipc	ra,0x3
    2f42:	d64080e7          	jalr	-668(ra) # 5ca2 <wait>
  for(int avail = 0; avail < 15; avail++){
    2f46:	2905                	addw	s2,s2,1
    2f48:	ff3912e3          	bne	s2,s3,2f2c <execout+0x14>
  exit(0);
    2f4c:	4501                	li	a0,0
    2f4e:	00003097          	auipc	ra,0x3
    2f52:	d4c080e7          	jalr	-692(ra) # 5c9a <exit>
      printf("fork failed\n");
    2f56:	00005517          	auipc	a0,0x5
    2f5a:	19250513          	add	a0,a0,402 # 80e8 <malloc+0x1f2c>
    2f5e:	00003097          	auipc	ra,0x3
    2f62:	1a6080e7          	jalr	422(ra) # 6104 <printf>
      exit(1);
    2f66:	4505                	li	a0,1
    2f68:	00003097          	auipc	ra,0x3
    2f6c:	d32080e7          	jalr	-718(ra) # 5c9a <exit>
        if(a == 0xffffffffffffffffLL)
    2f70:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2f72:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2f74:	6505                	lui	a0,0x1
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	dac080e7          	jalr	-596(ra) # 5d22 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2f7e:	01350763          	beq	a0,s3,2f8c <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2f82:	6785                	lui	a5,0x1
    2f84:	97aa                	add	a5,a5,a0
    2f86:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0xa3>
      while(1){
    2f8a:	b7ed                	j	2f74 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2f8c:	01205a63          	blez	s2,2fa0 <execout+0x88>
        sbrk(-4096);
    2f90:	757d                	lui	a0,0xfffff
    2f92:	00003097          	auipc	ra,0x3
    2f96:	d90080e7          	jalr	-624(ra) # 5d22 <sbrk>
      for(int i = 0; i < avail; i++)
    2f9a:	2485                	addw	s1,s1,1
    2f9c:	ff249ae3          	bne	s1,s2,2f90 <execout+0x78>
      close(1);
    2fa0:	4505                	li	a0,1
    2fa2:	00003097          	auipc	ra,0x3
    2fa6:	d20080e7          	jalr	-736(ra) # 5cc2 <close>
      char *args[] = { "echo", "x", 0 };
    2faa:	00003517          	auipc	a0,0x3
    2fae:	33e50513          	add	a0,a0,830 # 62e8 <malloc+0x12c>
    2fb2:	faa43c23          	sd	a0,-72(s0)
    2fb6:	00003797          	auipc	a5,0x3
    2fba:	3a278793          	add	a5,a5,930 # 6358 <malloc+0x19c>
    2fbe:	fcf43023          	sd	a5,-64(s0)
    2fc2:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2fc6:	fb840593          	add	a1,s0,-72
    2fca:	00003097          	auipc	ra,0x3
    2fce:	d08080e7          	jalr	-760(ra) # 5cd2 <exec>
      exit(0);
    2fd2:	4501                	li	a0,0
    2fd4:	00003097          	auipc	ra,0x3
    2fd8:	cc6080e7          	jalr	-826(ra) # 5c9a <exit>

0000000000002fdc <fourteen>:
{
    2fdc:	1101                	add	sp,sp,-32
    2fde:	ec06                	sd	ra,24(sp)
    2fe0:	e822                	sd	s0,16(sp)
    2fe2:	e426                	sd	s1,8(sp)
    2fe4:	1000                	add	s0,sp,32
    2fe6:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	39850513          	add	a0,a0,920 # 7380 <malloc+0x11c4>
    2ff0:	00003097          	auipc	ra,0x3
    2ff4:	d12080e7          	jalr	-750(ra) # 5d02 <mkdir>
    2ff8:	e165                	bnez	a0,30d8 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	1de50513          	add	a0,a0,478 # 71d8 <malloc+0x101c>
    3002:	00003097          	auipc	ra,0x3
    3006:	d00080e7          	jalr	-768(ra) # 5d02 <mkdir>
    300a:	e56d                	bnez	a0,30f4 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    300c:	20000593          	li	a1,512
    3010:	00004517          	auipc	a0,0x4
    3014:	22050513          	add	a0,a0,544 # 7230 <malloc+0x1074>
    3018:	00003097          	auipc	ra,0x3
    301c:	cc2080e7          	jalr	-830(ra) # 5cda <open>
  if(fd < 0){
    3020:	0e054863          	bltz	a0,3110 <fourteen+0x134>
  close(fd);
    3024:	00003097          	auipc	ra,0x3
    3028:	c9e080e7          	jalr	-866(ra) # 5cc2 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    302c:	4581                	li	a1,0
    302e:	00004517          	auipc	a0,0x4
    3032:	27a50513          	add	a0,a0,634 # 72a8 <malloc+0x10ec>
    3036:	00003097          	auipc	ra,0x3
    303a:	ca4080e7          	jalr	-860(ra) # 5cda <open>
  if(fd < 0){
    303e:	0e054763          	bltz	a0,312c <fourteen+0x150>
  close(fd);
    3042:	00003097          	auipc	ra,0x3
    3046:	c80080e7          	jalr	-896(ra) # 5cc2 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    304a:	00004517          	auipc	a0,0x4
    304e:	2ce50513          	add	a0,a0,718 # 7318 <malloc+0x115c>
    3052:	00003097          	auipc	ra,0x3
    3056:	cb0080e7          	jalr	-848(ra) # 5d02 <mkdir>
    305a:	c57d                	beqz	a0,3148 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    305c:	00004517          	auipc	a0,0x4
    3060:	31450513          	add	a0,a0,788 # 7370 <malloc+0x11b4>
    3064:	00003097          	auipc	ra,0x3
    3068:	c9e080e7          	jalr	-866(ra) # 5d02 <mkdir>
    306c:	cd65                	beqz	a0,3164 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    306e:	00004517          	auipc	a0,0x4
    3072:	30250513          	add	a0,a0,770 # 7370 <malloc+0x11b4>
    3076:	00003097          	auipc	ra,0x3
    307a:	c74080e7          	jalr	-908(ra) # 5cea <unlink>
  unlink("12345678901234/12345678901234");
    307e:	00004517          	auipc	a0,0x4
    3082:	29a50513          	add	a0,a0,666 # 7318 <malloc+0x115c>
    3086:	00003097          	auipc	ra,0x3
    308a:	c64080e7          	jalr	-924(ra) # 5cea <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    308e:	00004517          	auipc	a0,0x4
    3092:	21a50513          	add	a0,a0,538 # 72a8 <malloc+0x10ec>
    3096:	00003097          	auipc	ra,0x3
    309a:	c54080e7          	jalr	-940(ra) # 5cea <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    309e:	00004517          	auipc	a0,0x4
    30a2:	19250513          	add	a0,a0,402 # 7230 <malloc+0x1074>
    30a6:	00003097          	auipc	ra,0x3
    30aa:	c44080e7          	jalr	-956(ra) # 5cea <unlink>
  unlink("12345678901234/123456789012345");
    30ae:	00004517          	auipc	a0,0x4
    30b2:	12a50513          	add	a0,a0,298 # 71d8 <malloc+0x101c>
    30b6:	00003097          	auipc	ra,0x3
    30ba:	c34080e7          	jalr	-972(ra) # 5cea <unlink>
  unlink("12345678901234");
    30be:	00004517          	auipc	a0,0x4
    30c2:	2c250513          	add	a0,a0,706 # 7380 <malloc+0x11c4>
    30c6:	00003097          	auipc	ra,0x3
    30ca:	c24080e7          	jalr	-988(ra) # 5cea <unlink>
}
    30ce:	60e2                	ld	ra,24(sp)
    30d0:	6442                	ld	s0,16(sp)
    30d2:	64a2                	ld	s1,8(sp)
    30d4:	6105                	add	sp,sp,32
    30d6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    30d8:	85a6                	mv	a1,s1
    30da:	00004517          	auipc	a0,0x4
    30de:	0d650513          	add	a0,a0,214 # 71b0 <malloc+0xff4>
    30e2:	00003097          	auipc	ra,0x3
    30e6:	022080e7          	jalr	34(ra) # 6104 <printf>
    exit(1);
    30ea:	4505                	li	a0,1
    30ec:	00003097          	auipc	ra,0x3
    30f0:	bae080e7          	jalr	-1106(ra) # 5c9a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    30f4:	85a6                	mv	a1,s1
    30f6:	00004517          	auipc	a0,0x4
    30fa:	10250513          	add	a0,a0,258 # 71f8 <malloc+0x103c>
    30fe:	00003097          	auipc	ra,0x3
    3102:	006080e7          	jalr	6(ra) # 6104 <printf>
    exit(1);
    3106:	4505                	li	a0,1
    3108:	00003097          	auipc	ra,0x3
    310c:	b92080e7          	jalr	-1134(ra) # 5c9a <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3110:	85a6                	mv	a1,s1
    3112:	00004517          	auipc	a0,0x4
    3116:	14e50513          	add	a0,a0,334 # 7260 <malloc+0x10a4>
    311a:	00003097          	auipc	ra,0x3
    311e:	fea080e7          	jalr	-22(ra) # 6104 <printf>
    exit(1);
    3122:	4505                	li	a0,1
    3124:	00003097          	auipc	ra,0x3
    3128:	b76080e7          	jalr	-1162(ra) # 5c9a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    312c:	85a6                	mv	a1,s1
    312e:	00004517          	auipc	a0,0x4
    3132:	1aa50513          	add	a0,a0,426 # 72d8 <malloc+0x111c>
    3136:	00003097          	auipc	ra,0x3
    313a:	fce080e7          	jalr	-50(ra) # 6104 <printf>
    exit(1);
    313e:	4505                	li	a0,1
    3140:	00003097          	auipc	ra,0x3
    3144:	b5a080e7          	jalr	-1190(ra) # 5c9a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3148:	85a6                	mv	a1,s1
    314a:	00004517          	auipc	a0,0x4
    314e:	1ee50513          	add	a0,a0,494 # 7338 <malloc+0x117c>
    3152:	00003097          	auipc	ra,0x3
    3156:	fb2080e7          	jalr	-78(ra) # 6104 <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	00003097          	auipc	ra,0x3
    3160:	b3e080e7          	jalr	-1218(ra) # 5c9a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3164:	85a6                	mv	a1,s1
    3166:	00004517          	auipc	a0,0x4
    316a:	22a50513          	add	a0,a0,554 # 7390 <malloc+0x11d4>
    316e:	00003097          	auipc	ra,0x3
    3172:	f96080e7          	jalr	-106(ra) # 6104 <printf>
    exit(1);
    3176:	4505                	li	a0,1
    3178:	00003097          	auipc	ra,0x3
    317c:	b22080e7          	jalr	-1246(ra) # 5c9a <exit>

0000000000003180 <diskfull>:
{
    3180:	b8010113          	add	sp,sp,-1152
    3184:	46113c23          	sd	ra,1144(sp)
    3188:	46813823          	sd	s0,1136(sp)
    318c:	46913423          	sd	s1,1128(sp)
    3190:	47213023          	sd	s2,1120(sp)
    3194:	45313c23          	sd	s3,1112(sp)
    3198:	45413823          	sd	s4,1104(sp)
    319c:	45513423          	sd	s5,1096(sp)
    31a0:	45613023          	sd	s6,1088(sp)
    31a4:	43713c23          	sd	s7,1080(sp)
    31a8:	43813823          	sd	s8,1072(sp)
    31ac:	43913423          	sd	s9,1064(sp)
    31b0:	48010413          	add	s0,sp,1152
    31b4:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    31b6:	00004517          	auipc	a0,0x4
    31ba:	21250513          	add	a0,a0,530 # 73c8 <malloc+0x120c>
    31be:	00003097          	auipc	ra,0x3
    31c2:	b2c080e7          	jalr	-1236(ra) # 5cea <unlink>
    31c6:	03000993          	li	s3,48
    name[0] = 'b';
    31ca:	06200b13          	li	s6,98
    name[1] = 'i';
    31ce:	06900a93          	li	s5,105
    name[2] = 'g';
    31d2:	06700a13          	li	s4,103
    31d6:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    31da:	07f00c13          	li	s8,127
    31de:	a269                	j	3368 <diskfull+0x1e8>
      printf("%s: could not create file %s\n", s, name);
    31e0:	b8040613          	add	a2,s0,-1152
    31e4:	85e6                	mv	a1,s9
    31e6:	00004517          	auipc	a0,0x4
    31ea:	1f250513          	add	a0,a0,498 # 73d8 <malloc+0x121c>
    31ee:	00003097          	auipc	ra,0x3
    31f2:	f16080e7          	jalr	-234(ra) # 6104 <printf>
      break;
    31f6:	a819                	j	320c <diskfull+0x8c>
        close(fd);
    31f8:	854a                	mv	a0,s2
    31fa:	00003097          	auipc	ra,0x3
    31fe:	ac8080e7          	jalr	-1336(ra) # 5cc2 <close>
    close(fd);
    3202:	854a                	mv	a0,s2
    3204:	00003097          	auipc	ra,0x3
    3208:	abe080e7          	jalr	-1346(ra) # 5cc2 <close>
  for(int i = 0; i < nzz; i++){
    320c:	4481                	li	s1,0
    name[0] = 'z';
    320e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3212:	08000993          	li	s3,128
    name[0] = 'z';
    3216:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    321a:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    321e:	41f4d71b          	sraw	a4,s1,0x1f
    3222:	01b7571b          	srlw	a4,a4,0x1b
    3226:	009707bb          	addw	a5,a4,s1
    322a:	4057d69b          	sraw	a3,a5,0x5
    322e:	0306869b          	addw	a3,a3,48
    3232:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3236:	8bfd                	and	a5,a5,31
    3238:	9f99                	subw	a5,a5,a4
    323a:	0307879b          	addw	a5,a5,48
    323e:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3242:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3246:	ba040513          	add	a0,s0,-1120
    324a:	00003097          	auipc	ra,0x3
    324e:	aa0080e7          	jalr	-1376(ra) # 5cea <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3252:	60200593          	li	a1,1538
    3256:	ba040513          	add	a0,s0,-1120
    325a:	00003097          	auipc	ra,0x3
    325e:	a80080e7          	jalr	-1408(ra) # 5cda <open>
    if(fd < 0)
    3262:	00054963          	bltz	a0,3274 <diskfull+0xf4>
    close(fd);
    3266:	00003097          	auipc	ra,0x3
    326a:	a5c080e7          	jalr	-1444(ra) # 5cc2 <close>
  for(int i = 0; i < nzz; i++){
    326e:	2485                	addw	s1,s1,1
    3270:	fb3493e3          	bne	s1,s3,3216 <diskfull+0x96>
  if(mkdir("diskfulldir") == 0)
    3274:	00004517          	auipc	a0,0x4
    3278:	15450513          	add	a0,a0,340 # 73c8 <malloc+0x120c>
    327c:	00003097          	auipc	ra,0x3
    3280:	a86080e7          	jalr	-1402(ra) # 5d02 <mkdir>
    3284:	12050e63          	beqz	a0,33c0 <diskfull+0x240>
  unlink("diskfulldir");
    3288:	00004517          	auipc	a0,0x4
    328c:	14050513          	add	a0,a0,320 # 73c8 <malloc+0x120c>
    3290:	00003097          	auipc	ra,0x3
    3294:	a5a080e7          	jalr	-1446(ra) # 5cea <unlink>
  for(int i = 0; i < nzz; i++){
    3298:	4481                	li	s1,0
    name[0] = 'z';
    329a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    329e:	08000993          	li	s3,128
    name[0] = 'z';
    32a2:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    32a6:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    32aa:	41f4d71b          	sraw	a4,s1,0x1f
    32ae:	01b7571b          	srlw	a4,a4,0x1b
    32b2:	009707bb          	addw	a5,a4,s1
    32b6:	4057d69b          	sraw	a3,a5,0x5
    32ba:	0306869b          	addw	a3,a3,48
    32be:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    32c2:	8bfd                	and	a5,a5,31
    32c4:	9f99                	subw	a5,a5,a4
    32c6:	0307879b          	addw	a5,a5,48
    32ca:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    32ce:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    32d2:	ba040513          	add	a0,s0,-1120
    32d6:	00003097          	auipc	ra,0x3
    32da:	a14080e7          	jalr	-1516(ra) # 5cea <unlink>
  for(int i = 0; i < nzz; i++){
    32de:	2485                	addw	s1,s1,1
    32e0:	fd3491e3          	bne	s1,s3,32a2 <diskfull+0x122>
    32e4:	03000493          	li	s1,48
    name[0] = 'b';
    32e8:	06200a93          	li	s5,98
    name[1] = 'i';
    32ec:	06900a13          	li	s4,105
    name[2] = 'g';
    32f0:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    32f4:	07f00913          	li	s2,127
    name[0] = 'b';
    32f8:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    32fc:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    3300:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    3304:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    3308:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    330c:	ba040513          	add	a0,s0,-1120
    3310:	00003097          	auipc	ra,0x3
    3314:	9da080e7          	jalr	-1574(ra) # 5cea <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    3318:	2485                	addw	s1,s1,1
    331a:	0ff4f493          	zext.b	s1,s1
    331e:	fd249de3          	bne	s1,s2,32f8 <diskfull+0x178>
}
    3322:	47813083          	ld	ra,1144(sp)
    3326:	47013403          	ld	s0,1136(sp)
    332a:	46813483          	ld	s1,1128(sp)
    332e:	46013903          	ld	s2,1120(sp)
    3332:	45813983          	ld	s3,1112(sp)
    3336:	45013a03          	ld	s4,1104(sp)
    333a:	44813a83          	ld	s5,1096(sp)
    333e:	44013b03          	ld	s6,1088(sp)
    3342:	43813b83          	ld	s7,1080(sp)
    3346:	43013c03          	ld	s8,1072(sp)
    334a:	42813c83          	ld	s9,1064(sp)
    334e:	48010113          	add	sp,sp,1152
    3352:	8082                	ret
    close(fd);
    3354:	854a                	mv	a0,s2
    3356:	00003097          	auipc	ra,0x3
    335a:	96c080e7          	jalr	-1684(ra) # 5cc2 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    335e:	2985                	addw	s3,s3,1
    3360:	0ff9f993          	zext.b	s3,s3
    3364:	eb8984e3          	beq	s3,s8,320c <diskfull+0x8c>
    name[0] = 'b';
    3368:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    336c:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    3370:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    3374:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    3378:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    337c:	b8040513          	add	a0,s0,-1152
    3380:	00003097          	auipc	ra,0x3
    3384:	96a080e7          	jalr	-1686(ra) # 5cea <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3388:	60200593          	li	a1,1538
    338c:	b8040513          	add	a0,s0,-1152
    3390:	00003097          	auipc	ra,0x3
    3394:	94a080e7          	jalr	-1718(ra) # 5cda <open>
    3398:	892a                	mv	s2,a0
    if(fd < 0){
    339a:	e40543e3          	bltz	a0,31e0 <diskfull+0x60>
    339e:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33a0:	40000613          	li	a2,1024
    33a4:	ba040593          	add	a1,s0,-1120
    33a8:	854a                	mv	a0,s2
    33aa:	00003097          	auipc	ra,0x3
    33ae:	910080e7          	jalr	-1776(ra) # 5cba <write>
    33b2:	40000793          	li	a5,1024
    33b6:	e4f511e3          	bne	a0,a5,31f8 <diskfull+0x78>
    for(int i = 0; i < MAXFILE; i++){
    33ba:	34fd                	addw	s1,s1,-1
    33bc:	f0f5                	bnez	s1,33a0 <diskfull+0x220>
    33be:	bf59                	j	3354 <diskfull+0x1d4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    33c0:	85e6                	mv	a1,s9
    33c2:	00004517          	auipc	a0,0x4
    33c6:	03650513          	add	a0,a0,54 # 73f8 <malloc+0x123c>
    33ca:	00003097          	auipc	ra,0x3
    33ce:	d3a080e7          	jalr	-710(ra) # 6104 <printf>
    33d2:	bd5d                	j	3288 <diskfull+0x108>

00000000000033d4 <iputtest>:
{
    33d4:	1101                	add	sp,sp,-32
    33d6:	ec06                	sd	ra,24(sp)
    33d8:	e822                	sd	s0,16(sp)
    33da:	e426                	sd	s1,8(sp)
    33dc:	1000                	add	s0,sp,32
    33de:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    33e0:	00004517          	auipc	a0,0x4
    33e4:	04850513          	add	a0,a0,72 # 7428 <malloc+0x126c>
    33e8:	00003097          	auipc	ra,0x3
    33ec:	91a080e7          	jalr	-1766(ra) # 5d02 <mkdir>
    33f0:	04054563          	bltz	a0,343a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    33f4:	00004517          	auipc	a0,0x4
    33f8:	03450513          	add	a0,a0,52 # 7428 <malloc+0x126c>
    33fc:	00003097          	auipc	ra,0x3
    3400:	90e080e7          	jalr	-1778(ra) # 5d0a <chdir>
    3404:	04054963          	bltz	a0,3456 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3408:	00004517          	auipc	a0,0x4
    340c:	06050513          	add	a0,a0,96 # 7468 <malloc+0x12ac>
    3410:	00003097          	auipc	ra,0x3
    3414:	8da080e7          	jalr	-1830(ra) # 5cea <unlink>
    3418:	04054d63          	bltz	a0,3472 <iputtest+0x9e>
  if(chdir("/") < 0){
    341c:	00004517          	auipc	a0,0x4
    3420:	07c50513          	add	a0,a0,124 # 7498 <malloc+0x12dc>
    3424:	00003097          	auipc	ra,0x3
    3428:	8e6080e7          	jalr	-1818(ra) # 5d0a <chdir>
    342c:	06054163          	bltz	a0,348e <iputtest+0xba>
}
    3430:	60e2                	ld	ra,24(sp)
    3432:	6442                	ld	s0,16(sp)
    3434:	64a2                	ld	s1,8(sp)
    3436:	6105                	add	sp,sp,32
    3438:	8082                	ret
    printf("%s: mkdir failed\n", s);
    343a:	85a6                	mv	a1,s1
    343c:	00004517          	auipc	a0,0x4
    3440:	ff450513          	add	a0,a0,-12 # 7430 <malloc+0x1274>
    3444:	00003097          	auipc	ra,0x3
    3448:	cc0080e7          	jalr	-832(ra) # 6104 <printf>
    exit(1);
    344c:	4505                	li	a0,1
    344e:	00003097          	auipc	ra,0x3
    3452:	84c080e7          	jalr	-1972(ra) # 5c9a <exit>
    printf("%s: chdir iputdir failed\n", s);
    3456:	85a6                	mv	a1,s1
    3458:	00004517          	auipc	a0,0x4
    345c:	ff050513          	add	a0,a0,-16 # 7448 <malloc+0x128c>
    3460:	00003097          	auipc	ra,0x3
    3464:	ca4080e7          	jalr	-860(ra) # 6104 <printf>
    exit(1);
    3468:	4505                	li	a0,1
    346a:	00003097          	auipc	ra,0x3
    346e:	830080e7          	jalr	-2000(ra) # 5c9a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3472:	85a6                	mv	a1,s1
    3474:	00004517          	auipc	a0,0x4
    3478:	00450513          	add	a0,a0,4 # 7478 <malloc+0x12bc>
    347c:	00003097          	auipc	ra,0x3
    3480:	c88080e7          	jalr	-888(ra) # 6104 <printf>
    exit(1);
    3484:	4505                	li	a0,1
    3486:	00003097          	auipc	ra,0x3
    348a:	814080e7          	jalr	-2028(ra) # 5c9a <exit>
    printf("%s: chdir / failed\n", s);
    348e:	85a6                	mv	a1,s1
    3490:	00004517          	auipc	a0,0x4
    3494:	01050513          	add	a0,a0,16 # 74a0 <malloc+0x12e4>
    3498:	00003097          	auipc	ra,0x3
    349c:	c6c080e7          	jalr	-916(ra) # 6104 <printf>
    exit(1);
    34a0:	4505                	li	a0,1
    34a2:	00002097          	auipc	ra,0x2
    34a6:	7f8080e7          	jalr	2040(ra) # 5c9a <exit>

00000000000034aa <exitiputtest>:
{
    34aa:	7179                	add	sp,sp,-48
    34ac:	f406                	sd	ra,40(sp)
    34ae:	f022                	sd	s0,32(sp)
    34b0:	ec26                	sd	s1,24(sp)
    34b2:	1800                	add	s0,sp,48
    34b4:	84aa                	mv	s1,a0
  pid = fork();
    34b6:	00002097          	auipc	ra,0x2
    34ba:	7dc080e7          	jalr	2012(ra) # 5c92 <fork>
  if(pid < 0){
    34be:	04054663          	bltz	a0,350a <exitiputtest+0x60>
  if(pid == 0){
    34c2:	ed45                	bnez	a0,357a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34c4:	00004517          	auipc	a0,0x4
    34c8:	f6450513          	add	a0,a0,-156 # 7428 <malloc+0x126c>
    34cc:	00003097          	auipc	ra,0x3
    34d0:	836080e7          	jalr	-1994(ra) # 5d02 <mkdir>
    34d4:	04054963          	bltz	a0,3526 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    34d8:	00004517          	auipc	a0,0x4
    34dc:	f5050513          	add	a0,a0,-176 # 7428 <malloc+0x126c>
    34e0:	00003097          	auipc	ra,0x3
    34e4:	82a080e7          	jalr	-2006(ra) # 5d0a <chdir>
    34e8:	04054d63          	bltz	a0,3542 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    34ec:	00004517          	auipc	a0,0x4
    34f0:	f7c50513          	add	a0,a0,-132 # 7468 <malloc+0x12ac>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	7f6080e7          	jalr	2038(ra) # 5cea <unlink>
    34fc:	06054163          	bltz	a0,355e <exitiputtest+0xb4>
    exit(0);
    3500:	4501                	li	a0,0
    3502:	00002097          	auipc	ra,0x2
    3506:	798080e7          	jalr	1944(ra) # 5c9a <exit>
    printf("%s: fork failed\n", s);
    350a:	85a6                	mv	a1,s1
    350c:	00003517          	auipc	a0,0x3
    3510:	66c50513          	add	a0,a0,1644 # 6b78 <malloc+0x9bc>
    3514:	00003097          	auipc	ra,0x3
    3518:	bf0080e7          	jalr	-1040(ra) # 6104 <printf>
    exit(1);
    351c:	4505                	li	a0,1
    351e:	00002097          	auipc	ra,0x2
    3522:	77c080e7          	jalr	1916(ra) # 5c9a <exit>
      printf("%s: mkdir failed\n", s);
    3526:	85a6                	mv	a1,s1
    3528:	00004517          	auipc	a0,0x4
    352c:	f0850513          	add	a0,a0,-248 # 7430 <malloc+0x1274>
    3530:	00003097          	auipc	ra,0x3
    3534:	bd4080e7          	jalr	-1068(ra) # 6104 <printf>
      exit(1);
    3538:	4505                	li	a0,1
    353a:	00002097          	auipc	ra,0x2
    353e:	760080e7          	jalr	1888(ra) # 5c9a <exit>
      printf("%s: child chdir failed\n", s);
    3542:	85a6                	mv	a1,s1
    3544:	00004517          	auipc	a0,0x4
    3548:	f7450513          	add	a0,a0,-140 # 74b8 <malloc+0x12fc>
    354c:	00003097          	auipc	ra,0x3
    3550:	bb8080e7          	jalr	-1096(ra) # 6104 <printf>
      exit(1);
    3554:	4505                	li	a0,1
    3556:	00002097          	auipc	ra,0x2
    355a:	744080e7          	jalr	1860(ra) # 5c9a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    355e:	85a6                	mv	a1,s1
    3560:	00004517          	auipc	a0,0x4
    3564:	f1850513          	add	a0,a0,-232 # 7478 <malloc+0x12bc>
    3568:	00003097          	auipc	ra,0x3
    356c:	b9c080e7          	jalr	-1124(ra) # 6104 <printf>
      exit(1);
    3570:	4505                	li	a0,1
    3572:	00002097          	auipc	ra,0x2
    3576:	728080e7          	jalr	1832(ra) # 5c9a <exit>
  wait(&xstatus);
    357a:	fdc40513          	add	a0,s0,-36
    357e:	00002097          	auipc	ra,0x2
    3582:	724080e7          	jalr	1828(ra) # 5ca2 <wait>
  exit(xstatus);
    3586:	fdc42503          	lw	a0,-36(s0)
    358a:	00002097          	auipc	ra,0x2
    358e:	710080e7          	jalr	1808(ra) # 5c9a <exit>

0000000000003592 <dirtest>:
{
    3592:	1101                	add	sp,sp,-32
    3594:	ec06                	sd	ra,24(sp)
    3596:	e822                	sd	s0,16(sp)
    3598:	e426                	sd	s1,8(sp)
    359a:	1000                	add	s0,sp,32
    359c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    359e:	00004517          	auipc	a0,0x4
    35a2:	f3250513          	add	a0,a0,-206 # 74d0 <malloc+0x1314>
    35a6:	00002097          	auipc	ra,0x2
    35aa:	75c080e7          	jalr	1884(ra) # 5d02 <mkdir>
    35ae:	04054563          	bltz	a0,35f8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    35b2:	00004517          	auipc	a0,0x4
    35b6:	f1e50513          	add	a0,a0,-226 # 74d0 <malloc+0x1314>
    35ba:	00002097          	auipc	ra,0x2
    35be:	750080e7          	jalr	1872(ra) # 5d0a <chdir>
    35c2:	04054963          	bltz	a0,3614 <dirtest+0x82>
  if(chdir("..") < 0){
    35c6:	00004517          	auipc	a0,0x4
    35ca:	f2a50513          	add	a0,a0,-214 # 74f0 <malloc+0x1334>
    35ce:	00002097          	auipc	ra,0x2
    35d2:	73c080e7          	jalr	1852(ra) # 5d0a <chdir>
    35d6:	04054d63          	bltz	a0,3630 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    35da:	00004517          	auipc	a0,0x4
    35de:	ef650513          	add	a0,a0,-266 # 74d0 <malloc+0x1314>
    35e2:	00002097          	auipc	ra,0x2
    35e6:	708080e7          	jalr	1800(ra) # 5cea <unlink>
    35ea:	06054163          	bltz	a0,364c <dirtest+0xba>
}
    35ee:	60e2                	ld	ra,24(sp)
    35f0:	6442                	ld	s0,16(sp)
    35f2:	64a2                	ld	s1,8(sp)
    35f4:	6105                	add	sp,sp,32
    35f6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    35f8:	85a6                	mv	a1,s1
    35fa:	00004517          	auipc	a0,0x4
    35fe:	e3650513          	add	a0,a0,-458 # 7430 <malloc+0x1274>
    3602:	00003097          	auipc	ra,0x3
    3606:	b02080e7          	jalr	-1278(ra) # 6104 <printf>
    exit(1);
    360a:	4505                	li	a0,1
    360c:	00002097          	auipc	ra,0x2
    3610:	68e080e7          	jalr	1678(ra) # 5c9a <exit>
    printf("%s: chdir dir0 failed\n", s);
    3614:	85a6                	mv	a1,s1
    3616:	00004517          	auipc	a0,0x4
    361a:	ec250513          	add	a0,a0,-318 # 74d8 <malloc+0x131c>
    361e:	00003097          	auipc	ra,0x3
    3622:	ae6080e7          	jalr	-1306(ra) # 6104 <printf>
    exit(1);
    3626:	4505                	li	a0,1
    3628:	00002097          	auipc	ra,0x2
    362c:	672080e7          	jalr	1650(ra) # 5c9a <exit>
    printf("%s: chdir .. failed\n", s);
    3630:	85a6                	mv	a1,s1
    3632:	00004517          	auipc	a0,0x4
    3636:	ec650513          	add	a0,a0,-314 # 74f8 <malloc+0x133c>
    363a:	00003097          	auipc	ra,0x3
    363e:	aca080e7          	jalr	-1334(ra) # 6104 <printf>
    exit(1);
    3642:	4505                	li	a0,1
    3644:	00002097          	auipc	ra,0x2
    3648:	656080e7          	jalr	1622(ra) # 5c9a <exit>
    printf("%s: unlink dir0 failed\n", s);
    364c:	85a6                	mv	a1,s1
    364e:	00004517          	auipc	a0,0x4
    3652:	ec250513          	add	a0,a0,-318 # 7510 <malloc+0x1354>
    3656:	00003097          	auipc	ra,0x3
    365a:	aae080e7          	jalr	-1362(ra) # 6104 <printf>
    exit(1);
    365e:	4505                	li	a0,1
    3660:	00002097          	auipc	ra,0x2
    3664:	63a080e7          	jalr	1594(ra) # 5c9a <exit>

0000000000003668 <subdir>:
{
    3668:	1101                	add	sp,sp,-32
    366a:	ec06                	sd	ra,24(sp)
    366c:	e822                	sd	s0,16(sp)
    366e:	e426                	sd	s1,8(sp)
    3670:	e04a                	sd	s2,0(sp)
    3672:	1000                	add	s0,sp,32
    3674:	892a                	mv	s2,a0
  unlink("ff");
    3676:	00004517          	auipc	a0,0x4
    367a:	fe250513          	add	a0,a0,-30 # 7658 <malloc+0x149c>
    367e:	00002097          	auipc	ra,0x2
    3682:	66c080e7          	jalr	1644(ra) # 5cea <unlink>
  if(mkdir("dd") != 0){
    3686:	00004517          	auipc	a0,0x4
    368a:	ea250513          	add	a0,a0,-350 # 7528 <malloc+0x136c>
    368e:	00002097          	auipc	ra,0x2
    3692:	674080e7          	jalr	1652(ra) # 5d02 <mkdir>
    3696:	38051663          	bnez	a0,3a22 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    369a:	20200593          	li	a1,514
    369e:	00004517          	auipc	a0,0x4
    36a2:	eaa50513          	add	a0,a0,-342 # 7548 <malloc+0x138c>
    36a6:	00002097          	auipc	ra,0x2
    36aa:	634080e7          	jalr	1588(ra) # 5cda <open>
    36ae:	84aa                	mv	s1,a0
  if(fd < 0){
    36b0:	38054763          	bltz	a0,3a3e <subdir+0x3d6>
  write(fd, "ff", 2);
    36b4:	4609                	li	a2,2
    36b6:	00004597          	auipc	a1,0x4
    36ba:	fa258593          	add	a1,a1,-94 # 7658 <malloc+0x149c>
    36be:	00002097          	auipc	ra,0x2
    36c2:	5fc080e7          	jalr	1532(ra) # 5cba <write>
  close(fd);
    36c6:	8526                	mv	a0,s1
    36c8:	00002097          	auipc	ra,0x2
    36cc:	5fa080e7          	jalr	1530(ra) # 5cc2 <close>
  if(unlink("dd") >= 0){
    36d0:	00004517          	auipc	a0,0x4
    36d4:	e5850513          	add	a0,a0,-424 # 7528 <malloc+0x136c>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	612080e7          	jalr	1554(ra) # 5cea <unlink>
    36e0:	36055d63          	bgez	a0,3a5a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    36e4:	00004517          	auipc	a0,0x4
    36e8:	ebc50513          	add	a0,a0,-324 # 75a0 <malloc+0x13e4>
    36ec:	00002097          	auipc	ra,0x2
    36f0:	616080e7          	jalr	1558(ra) # 5d02 <mkdir>
    36f4:	38051163          	bnez	a0,3a76 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    36f8:	20200593          	li	a1,514
    36fc:	00004517          	auipc	a0,0x4
    3700:	ecc50513          	add	a0,a0,-308 # 75c8 <malloc+0x140c>
    3704:	00002097          	auipc	ra,0x2
    3708:	5d6080e7          	jalr	1494(ra) # 5cda <open>
    370c:	84aa                	mv	s1,a0
  if(fd < 0){
    370e:	38054263          	bltz	a0,3a92 <subdir+0x42a>
  write(fd, "FF", 2);
    3712:	4609                	li	a2,2
    3714:	00004597          	auipc	a1,0x4
    3718:	ee458593          	add	a1,a1,-284 # 75f8 <malloc+0x143c>
    371c:	00002097          	auipc	ra,0x2
    3720:	59e080e7          	jalr	1438(ra) # 5cba <write>
  close(fd);
    3724:	8526                	mv	a0,s1
    3726:	00002097          	auipc	ra,0x2
    372a:	59c080e7          	jalr	1436(ra) # 5cc2 <close>
  fd = open("dd/dd/../ff", 0);
    372e:	4581                	li	a1,0
    3730:	00004517          	auipc	a0,0x4
    3734:	ed050513          	add	a0,a0,-304 # 7600 <malloc+0x1444>
    3738:	00002097          	auipc	ra,0x2
    373c:	5a2080e7          	jalr	1442(ra) # 5cda <open>
    3740:	84aa                	mv	s1,a0
  if(fd < 0){
    3742:	36054663          	bltz	a0,3aae <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3746:	660d                	lui	a2,0x3
    3748:	00009597          	auipc	a1,0x9
    374c:	53058593          	add	a1,a1,1328 # cc78 <buf>
    3750:	00002097          	auipc	ra,0x2
    3754:	562080e7          	jalr	1378(ra) # 5cb2 <read>
  if(cc != 2 || buf[0] != 'f'){
    3758:	4789                	li	a5,2
    375a:	36f51863          	bne	a0,a5,3aca <subdir+0x462>
    375e:	00009717          	auipc	a4,0x9
    3762:	51a74703          	lbu	a4,1306(a4) # cc78 <buf>
    3766:	06600793          	li	a5,102
    376a:	36f71063          	bne	a4,a5,3aca <subdir+0x462>
  close(fd);
    376e:	8526                	mv	a0,s1
    3770:	00002097          	auipc	ra,0x2
    3774:	552080e7          	jalr	1362(ra) # 5cc2 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3778:	00004597          	auipc	a1,0x4
    377c:	ed858593          	add	a1,a1,-296 # 7650 <malloc+0x1494>
    3780:	00004517          	auipc	a0,0x4
    3784:	e4850513          	add	a0,a0,-440 # 75c8 <malloc+0x140c>
    3788:	00002097          	auipc	ra,0x2
    378c:	572080e7          	jalr	1394(ra) # 5cfa <link>
    3790:	34051b63          	bnez	a0,3ae6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3794:	00004517          	auipc	a0,0x4
    3798:	e3450513          	add	a0,a0,-460 # 75c8 <malloc+0x140c>
    379c:	00002097          	auipc	ra,0x2
    37a0:	54e080e7          	jalr	1358(ra) # 5cea <unlink>
    37a4:	34051f63          	bnez	a0,3b02 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37a8:	4581                	li	a1,0
    37aa:	00004517          	auipc	a0,0x4
    37ae:	e1e50513          	add	a0,a0,-482 # 75c8 <malloc+0x140c>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	528080e7          	jalr	1320(ra) # 5cda <open>
    37ba:	36055263          	bgez	a0,3b1e <subdir+0x4b6>
  if(chdir("dd") != 0){
    37be:	00004517          	auipc	a0,0x4
    37c2:	d6a50513          	add	a0,a0,-662 # 7528 <malloc+0x136c>
    37c6:	00002097          	auipc	ra,0x2
    37ca:	544080e7          	jalr	1348(ra) # 5d0a <chdir>
    37ce:	36051663          	bnez	a0,3b3a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    37d2:	00004517          	auipc	a0,0x4
    37d6:	f1650513          	add	a0,a0,-234 # 76e8 <malloc+0x152c>
    37da:	00002097          	auipc	ra,0x2
    37de:	530080e7          	jalr	1328(ra) # 5d0a <chdir>
    37e2:	36051a63          	bnez	a0,3b56 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    37e6:	00004517          	auipc	a0,0x4
    37ea:	f3250513          	add	a0,a0,-206 # 7718 <malloc+0x155c>
    37ee:	00002097          	auipc	ra,0x2
    37f2:	51c080e7          	jalr	1308(ra) # 5d0a <chdir>
    37f6:	36051e63          	bnez	a0,3b72 <subdir+0x50a>
  if(chdir("./..") != 0){
    37fa:	00004517          	auipc	a0,0x4
    37fe:	f5650513          	add	a0,a0,-170 # 7750 <malloc+0x1594>
    3802:	00002097          	auipc	ra,0x2
    3806:	508080e7          	jalr	1288(ra) # 5d0a <chdir>
    380a:	38051263          	bnez	a0,3b8e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    380e:	4581                	li	a1,0
    3810:	00004517          	auipc	a0,0x4
    3814:	e4050513          	add	a0,a0,-448 # 7650 <malloc+0x1494>
    3818:	00002097          	auipc	ra,0x2
    381c:	4c2080e7          	jalr	1218(ra) # 5cda <open>
    3820:	84aa                	mv	s1,a0
  if(fd < 0){
    3822:	38054463          	bltz	a0,3baa <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3826:	660d                	lui	a2,0x3
    3828:	00009597          	auipc	a1,0x9
    382c:	45058593          	add	a1,a1,1104 # cc78 <buf>
    3830:	00002097          	auipc	ra,0x2
    3834:	482080e7          	jalr	1154(ra) # 5cb2 <read>
    3838:	4789                	li	a5,2
    383a:	38f51663          	bne	a0,a5,3bc6 <subdir+0x55e>
  close(fd);
    383e:	8526                	mv	a0,s1
    3840:	00002097          	auipc	ra,0x2
    3844:	482080e7          	jalr	1154(ra) # 5cc2 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3848:	4581                	li	a1,0
    384a:	00004517          	auipc	a0,0x4
    384e:	d7e50513          	add	a0,a0,-642 # 75c8 <malloc+0x140c>
    3852:	00002097          	auipc	ra,0x2
    3856:	488080e7          	jalr	1160(ra) # 5cda <open>
    385a:	38055463          	bgez	a0,3be2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    385e:	20200593          	li	a1,514
    3862:	00004517          	auipc	a0,0x4
    3866:	f7e50513          	add	a0,a0,-130 # 77e0 <malloc+0x1624>
    386a:	00002097          	auipc	ra,0x2
    386e:	470080e7          	jalr	1136(ra) # 5cda <open>
    3872:	38055663          	bgez	a0,3bfe <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3876:	20200593          	li	a1,514
    387a:	00004517          	auipc	a0,0x4
    387e:	f9650513          	add	a0,a0,-106 # 7810 <malloc+0x1654>
    3882:	00002097          	auipc	ra,0x2
    3886:	458080e7          	jalr	1112(ra) # 5cda <open>
    388a:	38055863          	bgez	a0,3c1a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    388e:	20000593          	li	a1,512
    3892:	00004517          	auipc	a0,0x4
    3896:	c9650513          	add	a0,a0,-874 # 7528 <malloc+0x136c>
    389a:	00002097          	auipc	ra,0x2
    389e:	440080e7          	jalr	1088(ra) # 5cda <open>
    38a2:	38055a63          	bgez	a0,3c36 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38a6:	4589                	li	a1,2
    38a8:	00004517          	auipc	a0,0x4
    38ac:	c8050513          	add	a0,a0,-896 # 7528 <malloc+0x136c>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	42a080e7          	jalr	1066(ra) # 5cda <open>
    38b8:	38055d63          	bgez	a0,3c52 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38bc:	4585                	li	a1,1
    38be:	00004517          	auipc	a0,0x4
    38c2:	c6a50513          	add	a0,a0,-918 # 7528 <malloc+0x136c>
    38c6:	00002097          	auipc	ra,0x2
    38ca:	414080e7          	jalr	1044(ra) # 5cda <open>
    38ce:	3a055063          	bgez	a0,3c6e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    38d2:	00004597          	auipc	a1,0x4
    38d6:	fce58593          	add	a1,a1,-50 # 78a0 <malloc+0x16e4>
    38da:	00004517          	auipc	a0,0x4
    38de:	f0650513          	add	a0,a0,-250 # 77e0 <malloc+0x1624>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	418080e7          	jalr	1048(ra) # 5cfa <link>
    38ea:	3a050063          	beqz	a0,3c8a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    38ee:	00004597          	auipc	a1,0x4
    38f2:	fb258593          	add	a1,a1,-78 # 78a0 <malloc+0x16e4>
    38f6:	00004517          	auipc	a0,0x4
    38fa:	f1a50513          	add	a0,a0,-230 # 7810 <malloc+0x1654>
    38fe:	00002097          	auipc	ra,0x2
    3902:	3fc080e7          	jalr	1020(ra) # 5cfa <link>
    3906:	3a050063          	beqz	a0,3ca6 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    390a:	00004597          	auipc	a1,0x4
    390e:	d4658593          	add	a1,a1,-698 # 7650 <malloc+0x1494>
    3912:	00004517          	auipc	a0,0x4
    3916:	c3650513          	add	a0,a0,-970 # 7548 <malloc+0x138c>
    391a:	00002097          	auipc	ra,0x2
    391e:	3e0080e7          	jalr	992(ra) # 5cfa <link>
    3922:	3a050063          	beqz	a0,3cc2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3926:	00004517          	auipc	a0,0x4
    392a:	eba50513          	add	a0,a0,-326 # 77e0 <malloc+0x1624>
    392e:	00002097          	auipc	ra,0x2
    3932:	3d4080e7          	jalr	980(ra) # 5d02 <mkdir>
    3936:	3a050463          	beqz	a0,3cde <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    393a:	00004517          	auipc	a0,0x4
    393e:	ed650513          	add	a0,a0,-298 # 7810 <malloc+0x1654>
    3942:	00002097          	auipc	ra,0x2
    3946:	3c0080e7          	jalr	960(ra) # 5d02 <mkdir>
    394a:	3a050863          	beqz	a0,3cfa <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    394e:	00004517          	auipc	a0,0x4
    3952:	d0250513          	add	a0,a0,-766 # 7650 <malloc+0x1494>
    3956:	00002097          	auipc	ra,0x2
    395a:	3ac080e7          	jalr	940(ra) # 5d02 <mkdir>
    395e:	3a050c63          	beqz	a0,3d16 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3962:	00004517          	auipc	a0,0x4
    3966:	eae50513          	add	a0,a0,-338 # 7810 <malloc+0x1654>
    396a:	00002097          	auipc	ra,0x2
    396e:	380080e7          	jalr	896(ra) # 5cea <unlink>
    3972:	3c050063          	beqz	a0,3d32 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3976:	00004517          	auipc	a0,0x4
    397a:	e6a50513          	add	a0,a0,-406 # 77e0 <malloc+0x1624>
    397e:	00002097          	auipc	ra,0x2
    3982:	36c080e7          	jalr	876(ra) # 5cea <unlink>
    3986:	3c050463          	beqz	a0,3d4e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    398a:	00004517          	auipc	a0,0x4
    398e:	bbe50513          	add	a0,a0,-1090 # 7548 <malloc+0x138c>
    3992:	00002097          	auipc	ra,0x2
    3996:	378080e7          	jalr	888(ra) # 5d0a <chdir>
    399a:	3c050863          	beqz	a0,3d6a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    399e:	00004517          	auipc	a0,0x4
    39a2:	05250513          	add	a0,a0,82 # 79f0 <malloc+0x1834>
    39a6:	00002097          	auipc	ra,0x2
    39aa:	364080e7          	jalr	868(ra) # 5d0a <chdir>
    39ae:	3c050c63          	beqz	a0,3d86 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39b2:	00004517          	auipc	a0,0x4
    39b6:	c9e50513          	add	a0,a0,-866 # 7650 <malloc+0x1494>
    39ba:	00002097          	auipc	ra,0x2
    39be:	330080e7          	jalr	816(ra) # 5cea <unlink>
    39c2:	3e051063          	bnez	a0,3da2 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39c6:	00004517          	auipc	a0,0x4
    39ca:	b8250513          	add	a0,a0,-1150 # 7548 <malloc+0x138c>
    39ce:	00002097          	auipc	ra,0x2
    39d2:	31c080e7          	jalr	796(ra) # 5cea <unlink>
    39d6:	3e051463          	bnez	a0,3dbe <subdir+0x756>
  if(unlink("dd") == 0){
    39da:	00004517          	auipc	a0,0x4
    39de:	b4e50513          	add	a0,a0,-1202 # 7528 <malloc+0x136c>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	308080e7          	jalr	776(ra) # 5cea <unlink>
    39ea:	3e050863          	beqz	a0,3dda <subdir+0x772>
  if(unlink("dd/dd") < 0){
    39ee:	00004517          	auipc	a0,0x4
    39f2:	07250513          	add	a0,a0,114 # 7a60 <malloc+0x18a4>
    39f6:	00002097          	auipc	ra,0x2
    39fa:	2f4080e7          	jalr	756(ra) # 5cea <unlink>
    39fe:	3e054c63          	bltz	a0,3df6 <subdir+0x78e>
  if(unlink("dd") < 0){
    3a02:	00004517          	auipc	a0,0x4
    3a06:	b2650513          	add	a0,a0,-1242 # 7528 <malloc+0x136c>
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	2e0080e7          	jalr	736(ra) # 5cea <unlink>
    3a12:	40054063          	bltz	a0,3e12 <subdir+0x7aa>
}
    3a16:	60e2                	ld	ra,24(sp)
    3a18:	6442                	ld	s0,16(sp)
    3a1a:	64a2                	ld	s1,8(sp)
    3a1c:	6902                	ld	s2,0(sp)
    3a1e:	6105                	add	sp,sp,32
    3a20:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a22:	85ca                	mv	a1,s2
    3a24:	00004517          	auipc	a0,0x4
    3a28:	b0c50513          	add	a0,a0,-1268 # 7530 <malloc+0x1374>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	6d8080e7          	jalr	1752(ra) # 6104 <printf>
    exit(1);
    3a34:	4505                	li	a0,1
    3a36:	00002097          	auipc	ra,0x2
    3a3a:	264080e7          	jalr	612(ra) # 5c9a <exit>
    printf("%s: create dd/ff failed\n", s);
    3a3e:	85ca                	mv	a1,s2
    3a40:	00004517          	auipc	a0,0x4
    3a44:	b1050513          	add	a0,a0,-1264 # 7550 <malloc+0x1394>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	6bc080e7          	jalr	1724(ra) # 6104 <printf>
    exit(1);
    3a50:	4505                	li	a0,1
    3a52:	00002097          	auipc	ra,0x2
    3a56:	248080e7          	jalr	584(ra) # 5c9a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a5a:	85ca                	mv	a1,s2
    3a5c:	00004517          	auipc	a0,0x4
    3a60:	b1450513          	add	a0,a0,-1260 # 7570 <malloc+0x13b4>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	6a0080e7          	jalr	1696(ra) # 6104 <printf>
    exit(1);
    3a6c:	4505                	li	a0,1
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	22c080e7          	jalr	556(ra) # 5c9a <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3a76:	85ca                	mv	a1,s2
    3a78:	00004517          	auipc	a0,0x4
    3a7c:	b3050513          	add	a0,a0,-1232 # 75a8 <malloc+0x13ec>
    3a80:	00002097          	auipc	ra,0x2
    3a84:	684080e7          	jalr	1668(ra) # 6104 <printf>
    exit(1);
    3a88:	4505                	li	a0,1
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	210080e7          	jalr	528(ra) # 5c9a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3a92:	85ca                	mv	a1,s2
    3a94:	00004517          	auipc	a0,0x4
    3a98:	b4450513          	add	a0,a0,-1212 # 75d8 <malloc+0x141c>
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	668080e7          	jalr	1640(ra) # 6104 <printf>
    exit(1);
    3aa4:	4505                	li	a0,1
    3aa6:	00002097          	auipc	ra,0x2
    3aaa:	1f4080e7          	jalr	500(ra) # 5c9a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3aae:	85ca                	mv	a1,s2
    3ab0:	00004517          	auipc	a0,0x4
    3ab4:	b6050513          	add	a0,a0,-1184 # 7610 <malloc+0x1454>
    3ab8:	00002097          	auipc	ra,0x2
    3abc:	64c080e7          	jalr	1612(ra) # 6104 <printf>
    exit(1);
    3ac0:	4505                	li	a0,1
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	1d8080e7          	jalr	472(ra) # 5c9a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3aca:	85ca                	mv	a1,s2
    3acc:	00004517          	auipc	a0,0x4
    3ad0:	b6450513          	add	a0,a0,-1180 # 7630 <malloc+0x1474>
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	630080e7          	jalr	1584(ra) # 6104 <printf>
    exit(1);
    3adc:	4505                	li	a0,1
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	1bc080e7          	jalr	444(ra) # 5c9a <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3ae6:	85ca                	mv	a1,s2
    3ae8:	00004517          	auipc	a0,0x4
    3aec:	b7850513          	add	a0,a0,-1160 # 7660 <malloc+0x14a4>
    3af0:	00002097          	auipc	ra,0x2
    3af4:	614080e7          	jalr	1556(ra) # 6104 <printf>
    exit(1);
    3af8:	4505                	li	a0,1
    3afa:	00002097          	auipc	ra,0x2
    3afe:	1a0080e7          	jalr	416(ra) # 5c9a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b02:	85ca                	mv	a1,s2
    3b04:	00004517          	auipc	a0,0x4
    3b08:	b8450513          	add	a0,a0,-1148 # 7688 <malloc+0x14cc>
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	5f8080e7          	jalr	1528(ra) # 6104 <printf>
    exit(1);
    3b14:	4505                	li	a0,1
    3b16:	00002097          	auipc	ra,0x2
    3b1a:	184080e7          	jalr	388(ra) # 5c9a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b1e:	85ca                	mv	a1,s2
    3b20:	00004517          	auipc	a0,0x4
    3b24:	b8850513          	add	a0,a0,-1144 # 76a8 <malloc+0x14ec>
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	5dc080e7          	jalr	1500(ra) # 6104 <printf>
    exit(1);
    3b30:	4505                	li	a0,1
    3b32:	00002097          	auipc	ra,0x2
    3b36:	168080e7          	jalr	360(ra) # 5c9a <exit>
    printf("%s: chdir dd failed\n", s);
    3b3a:	85ca                	mv	a1,s2
    3b3c:	00004517          	auipc	a0,0x4
    3b40:	b9450513          	add	a0,a0,-1132 # 76d0 <malloc+0x1514>
    3b44:	00002097          	auipc	ra,0x2
    3b48:	5c0080e7          	jalr	1472(ra) # 6104 <printf>
    exit(1);
    3b4c:	4505                	li	a0,1
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	14c080e7          	jalr	332(ra) # 5c9a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b56:	85ca                	mv	a1,s2
    3b58:	00004517          	auipc	a0,0x4
    3b5c:	ba050513          	add	a0,a0,-1120 # 76f8 <malloc+0x153c>
    3b60:	00002097          	auipc	ra,0x2
    3b64:	5a4080e7          	jalr	1444(ra) # 6104 <printf>
    exit(1);
    3b68:	4505                	li	a0,1
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	130080e7          	jalr	304(ra) # 5c9a <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    3b72:	85ca                	mv	a1,s2
    3b74:	00004517          	auipc	a0,0x4
    3b78:	bb450513          	add	a0,a0,-1100 # 7728 <malloc+0x156c>
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	588080e7          	jalr	1416(ra) # 6104 <printf>
    exit(1);
    3b84:	4505                	li	a0,1
    3b86:	00002097          	auipc	ra,0x2
    3b8a:	114080e7          	jalr	276(ra) # 5c9a <exit>
    printf("%s: chdir ./.. failed\n", s);
    3b8e:	85ca                	mv	a1,s2
    3b90:	00004517          	auipc	a0,0x4
    3b94:	bc850513          	add	a0,a0,-1080 # 7758 <malloc+0x159c>
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	56c080e7          	jalr	1388(ra) # 6104 <printf>
    exit(1);
    3ba0:	4505                	li	a0,1
    3ba2:	00002097          	auipc	ra,0x2
    3ba6:	0f8080e7          	jalr	248(ra) # 5c9a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3baa:	85ca                	mv	a1,s2
    3bac:	00004517          	auipc	a0,0x4
    3bb0:	bc450513          	add	a0,a0,-1084 # 7770 <malloc+0x15b4>
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	550080e7          	jalr	1360(ra) # 6104 <printf>
    exit(1);
    3bbc:	4505                	li	a0,1
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	0dc080e7          	jalr	220(ra) # 5c9a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bc6:	85ca                	mv	a1,s2
    3bc8:	00004517          	auipc	a0,0x4
    3bcc:	bc850513          	add	a0,a0,-1080 # 7790 <malloc+0x15d4>
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	534080e7          	jalr	1332(ra) # 6104 <printf>
    exit(1);
    3bd8:	4505                	li	a0,1
    3bda:	00002097          	auipc	ra,0x2
    3bde:	0c0080e7          	jalr	192(ra) # 5c9a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3be2:	85ca                	mv	a1,s2
    3be4:	00004517          	auipc	a0,0x4
    3be8:	bcc50513          	add	a0,a0,-1076 # 77b0 <malloc+0x15f4>
    3bec:	00002097          	auipc	ra,0x2
    3bf0:	518080e7          	jalr	1304(ra) # 6104 <printf>
    exit(1);
    3bf4:	4505                	li	a0,1
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	0a4080e7          	jalr	164(ra) # 5c9a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3bfe:	85ca                	mv	a1,s2
    3c00:	00004517          	auipc	a0,0x4
    3c04:	bf050513          	add	a0,a0,-1040 # 77f0 <malloc+0x1634>
    3c08:	00002097          	auipc	ra,0x2
    3c0c:	4fc080e7          	jalr	1276(ra) # 6104 <printf>
    exit(1);
    3c10:	4505                	li	a0,1
    3c12:	00002097          	auipc	ra,0x2
    3c16:	088080e7          	jalr	136(ra) # 5c9a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c1a:	85ca                	mv	a1,s2
    3c1c:	00004517          	auipc	a0,0x4
    3c20:	c0450513          	add	a0,a0,-1020 # 7820 <malloc+0x1664>
    3c24:	00002097          	auipc	ra,0x2
    3c28:	4e0080e7          	jalr	1248(ra) # 6104 <printf>
    exit(1);
    3c2c:	4505                	li	a0,1
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	06c080e7          	jalr	108(ra) # 5c9a <exit>
    printf("%s: create dd succeeded!\n", s);
    3c36:	85ca                	mv	a1,s2
    3c38:	00004517          	auipc	a0,0x4
    3c3c:	c0850513          	add	a0,a0,-1016 # 7840 <malloc+0x1684>
    3c40:	00002097          	auipc	ra,0x2
    3c44:	4c4080e7          	jalr	1220(ra) # 6104 <printf>
    exit(1);
    3c48:	4505                	li	a0,1
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	050080e7          	jalr	80(ra) # 5c9a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c52:	85ca                	mv	a1,s2
    3c54:	00004517          	auipc	a0,0x4
    3c58:	c0c50513          	add	a0,a0,-1012 # 7860 <malloc+0x16a4>
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	4a8080e7          	jalr	1192(ra) # 6104 <printf>
    exit(1);
    3c64:	4505                	li	a0,1
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	034080e7          	jalr	52(ra) # 5c9a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3c6e:	85ca                	mv	a1,s2
    3c70:	00004517          	auipc	a0,0x4
    3c74:	c1050513          	add	a0,a0,-1008 # 7880 <malloc+0x16c4>
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	48c080e7          	jalr	1164(ra) # 6104 <printf>
    exit(1);
    3c80:	4505                	li	a0,1
    3c82:	00002097          	auipc	ra,0x2
    3c86:	018080e7          	jalr	24(ra) # 5c9a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3c8a:	85ca                	mv	a1,s2
    3c8c:	00004517          	auipc	a0,0x4
    3c90:	c2450513          	add	a0,a0,-988 # 78b0 <malloc+0x16f4>
    3c94:	00002097          	auipc	ra,0x2
    3c98:	470080e7          	jalr	1136(ra) # 6104 <printf>
    exit(1);
    3c9c:	4505                	li	a0,1
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	ffc080e7          	jalr	-4(ra) # 5c9a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3ca6:	85ca                	mv	a1,s2
    3ca8:	00004517          	auipc	a0,0x4
    3cac:	c3050513          	add	a0,a0,-976 # 78d8 <malloc+0x171c>
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	454080e7          	jalr	1108(ra) # 6104 <printf>
    exit(1);
    3cb8:	4505                	li	a0,1
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	fe0080e7          	jalr	-32(ra) # 5c9a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cc2:	85ca                	mv	a1,s2
    3cc4:	00004517          	auipc	a0,0x4
    3cc8:	c3c50513          	add	a0,a0,-964 # 7900 <malloc+0x1744>
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	438080e7          	jalr	1080(ra) # 6104 <printf>
    exit(1);
    3cd4:	4505                	li	a0,1
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	fc4080e7          	jalr	-60(ra) # 5c9a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3cde:	85ca                	mv	a1,s2
    3ce0:	00004517          	auipc	a0,0x4
    3ce4:	c4850513          	add	a0,a0,-952 # 7928 <malloc+0x176c>
    3ce8:	00002097          	auipc	ra,0x2
    3cec:	41c080e7          	jalr	1052(ra) # 6104 <printf>
    exit(1);
    3cf0:	4505                	li	a0,1
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	fa8080e7          	jalr	-88(ra) # 5c9a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3cfa:	85ca                	mv	a1,s2
    3cfc:	00004517          	auipc	a0,0x4
    3d00:	c4c50513          	add	a0,a0,-948 # 7948 <malloc+0x178c>
    3d04:	00002097          	auipc	ra,0x2
    3d08:	400080e7          	jalr	1024(ra) # 6104 <printf>
    exit(1);
    3d0c:	4505                	li	a0,1
    3d0e:	00002097          	auipc	ra,0x2
    3d12:	f8c080e7          	jalr	-116(ra) # 5c9a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d16:	85ca                	mv	a1,s2
    3d18:	00004517          	auipc	a0,0x4
    3d1c:	c5050513          	add	a0,a0,-944 # 7968 <malloc+0x17ac>
    3d20:	00002097          	auipc	ra,0x2
    3d24:	3e4080e7          	jalr	996(ra) # 6104 <printf>
    exit(1);
    3d28:	4505                	li	a0,1
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	f70080e7          	jalr	-144(ra) # 5c9a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d32:	85ca                	mv	a1,s2
    3d34:	00004517          	auipc	a0,0x4
    3d38:	c5c50513          	add	a0,a0,-932 # 7990 <malloc+0x17d4>
    3d3c:	00002097          	auipc	ra,0x2
    3d40:	3c8080e7          	jalr	968(ra) # 6104 <printf>
    exit(1);
    3d44:	4505                	li	a0,1
    3d46:	00002097          	auipc	ra,0x2
    3d4a:	f54080e7          	jalr	-172(ra) # 5c9a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d4e:	85ca                	mv	a1,s2
    3d50:	00004517          	auipc	a0,0x4
    3d54:	c6050513          	add	a0,a0,-928 # 79b0 <malloc+0x17f4>
    3d58:	00002097          	auipc	ra,0x2
    3d5c:	3ac080e7          	jalr	940(ra) # 6104 <printf>
    exit(1);
    3d60:	4505                	li	a0,1
    3d62:	00002097          	auipc	ra,0x2
    3d66:	f38080e7          	jalr	-200(ra) # 5c9a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3d6a:	85ca                	mv	a1,s2
    3d6c:	00004517          	auipc	a0,0x4
    3d70:	c6450513          	add	a0,a0,-924 # 79d0 <malloc+0x1814>
    3d74:	00002097          	auipc	ra,0x2
    3d78:	390080e7          	jalr	912(ra) # 6104 <printf>
    exit(1);
    3d7c:	4505                	li	a0,1
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	f1c080e7          	jalr	-228(ra) # 5c9a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3d86:	85ca                	mv	a1,s2
    3d88:	00004517          	auipc	a0,0x4
    3d8c:	c7050513          	add	a0,a0,-912 # 79f8 <malloc+0x183c>
    3d90:	00002097          	auipc	ra,0x2
    3d94:	374080e7          	jalr	884(ra) # 6104 <printf>
    exit(1);
    3d98:	4505                	li	a0,1
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	f00080e7          	jalr	-256(ra) # 5c9a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3da2:	85ca                	mv	a1,s2
    3da4:	00004517          	auipc	a0,0x4
    3da8:	8e450513          	add	a0,a0,-1820 # 7688 <malloc+0x14cc>
    3dac:	00002097          	auipc	ra,0x2
    3db0:	358080e7          	jalr	856(ra) # 6104 <printf>
    exit(1);
    3db4:	4505                	li	a0,1
    3db6:	00002097          	auipc	ra,0x2
    3dba:	ee4080e7          	jalr	-284(ra) # 5c9a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3dbe:	85ca                	mv	a1,s2
    3dc0:	00004517          	auipc	a0,0x4
    3dc4:	c5850513          	add	a0,a0,-936 # 7a18 <malloc+0x185c>
    3dc8:	00002097          	auipc	ra,0x2
    3dcc:	33c080e7          	jalr	828(ra) # 6104 <printf>
    exit(1);
    3dd0:	4505                	li	a0,1
    3dd2:	00002097          	auipc	ra,0x2
    3dd6:	ec8080e7          	jalr	-312(ra) # 5c9a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3dda:	85ca                	mv	a1,s2
    3ddc:	00004517          	auipc	a0,0x4
    3de0:	c5c50513          	add	a0,a0,-932 # 7a38 <malloc+0x187c>
    3de4:	00002097          	auipc	ra,0x2
    3de8:	320080e7          	jalr	800(ra) # 6104 <printf>
    exit(1);
    3dec:	4505                	li	a0,1
    3dee:	00002097          	auipc	ra,0x2
    3df2:	eac080e7          	jalr	-340(ra) # 5c9a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3df6:	85ca                	mv	a1,s2
    3df8:	00004517          	auipc	a0,0x4
    3dfc:	c7050513          	add	a0,a0,-912 # 7a68 <malloc+0x18ac>
    3e00:	00002097          	auipc	ra,0x2
    3e04:	304080e7          	jalr	772(ra) # 6104 <printf>
    exit(1);
    3e08:	4505                	li	a0,1
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	e90080e7          	jalr	-368(ra) # 5c9a <exit>
    printf("%s: unlink dd failed\n", s);
    3e12:	85ca                	mv	a1,s2
    3e14:	00004517          	auipc	a0,0x4
    3e18:	c7450513          	add	a0,a0,-908 # 7a88 <malloc+0x18cc>
    3e1c:	00002097          	auipc	ra,0x2
    3e20:	2e8080e7          	jalr	744(ra) # 6104 <printf>
    exit(1);
    3e24:	4505                	li	a0,1
    3e26:	00002097          	auipc	ra,0x2
    3e2a:	e74080e7          	jalr	-396(ra) # 5c9a <exit>

0000000000003e2e <rmdot>:
{
    3e2e:	1101                	add	sp,sp,-32
    3e30:	ec06                	sd	ra,24(sp)
    3e32:	e822                	sd	s0,16(sp)
    3e34:	e426                	sd	s1,8(sp)
    3e36:	1000                	add	s0,sp,32
    3e38:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e3a:	00004517          	auipc	a0,0x4
    3e3e:	c6650513          	add	a0,a0,-922 # 7aa0 <malloc+0x18e4>
    3e42:	00002097          	auipc	ra,0x2
    3e46:	ec0080e7          	jalr	-320(ra) # 5d02 <mkdir>
    3e4a:	e549                	bnez	a0,3ed4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e4c:	00004517          	auipc	a0,0x4
    3e50:	c5450513          	add	a0,a0,-940 # 7aa0 <malloc+0x18e4>
    3e54:	00002097          	auipc	ra,0x2
    3e58:	eb6080e7          	jalr	-330(ra) # 5d0a <chdir>
    3e5c:	e951                	bnez	a0,3ef0 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e5e:	00003517          	auipc	a0,0x3
    3e62:	b7250513          	add	a0,a0,-1166 # 69d0 <malloc+0x814>
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	e84080e7          	jalr	-380(ra) # 5cea <unlink>
    3e6e:	cd59                	beqz	a0,3f0c <rmdot+0xde>
  if(unlink("..") == 0){
    3e70:	00003517          	auipc	a0,0x3
    3e74:	68050513          	add	a0,a0,1664 # 74f0 <malloc+0x1334>
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	e72080e7          	jalr	-398(ra) # 5cea <unlink>
    3e80:	c545                	beqz	a0,3f28 <rmdot+0xfa>
  if(chdir("/") != 0){
    3e82:	00003517          	auipc	a0,0x3
    3e86:	61650513          	add	a0,a0,1558 # 7498 <malloc+0x12dc>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	e80080e7          	jalr	-384(ra) # 5d0a <chdir>
    3e92:	e94d                	bnez	a0,3f44 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3e94:	00004517          	auipc	a0,0x4
    3e98:	c7450513          	add	a0,a0,-908 # 7b08 <malloc+0x194c>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	e4e080e7          	jalr	-434(ra) # 5cea <unlink>
    3ea4:	cd55                	beqz	a0,3f60 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3ea6:	00004517          	auipc	a0,0x4
    3eaa:	c8a50513          	add	a0,a0,-886 # 7b30 <malloc+0x1974>
    3eae:	00002097          	auipc	ra,0x2
    3eb2:	e3c080e7          	jalr	-452(ra) # 5cea <unlink>
    3eb6:	c179                	beqz	a0,3f7c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3eb8:	00004517          	auipc	a0,0x4
    3ebc:	be850513          	add	a0,a0,-1048 # 7aa0 <malloc+0x18e4>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	e2a080e7          	jalr	-470(ra) # 5cea <unlink>
    3ec8:	e961                	bnez	a0,3f98 <rmdot+0x16a>
}
    3eca:	60e2                	ld	ra,24(sp)
    3ecc:	6442                	ld	s0,16(sp)
    3ece:	64a2                	ld	s1,8(sp)
    3ed0:	6105                	add	sp,sp,32
    3ed2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3ed4:	85a6                	mv	a1,s1
    3ed6:	00004517          	auipc	a0,0x4
    3eda:	bd250513          	add	a0,a0,-1070 # 7aa8 <malloc+0x18ec>
    3ede:	00002097          	auipc	ra,0x2
    3ee2:	226080e7          	jalr	550(ra) # 6104 <printf>
    exit(1);
    3ee6:	4505                	li	a0,1
    3ee8:	00002097          	auipc	ra,0x2
    3eec:	db2080e7          	jalr	-590(ra) # 5c9a <exit>
    printf("%s: chdir dots failed\n", s);
    3ef0:	85a6                	mv	a1,s1
    3ef2:	00004517          	auipc	a0,0x4
    3ef6:	bce50513          	add	a0,a0,-1074 # 7ac0 <malloc+0x1904>
    3efa:	00002097          	auipc	ra,0x2
    3efe:	20a080e7          	jalr	522(ra) # 6104 <printf>
    exit(1);
    3f02:	4505                	li	a0,1
    3f04:	00002097          	auipc	ra,0x2
    3f08:	d96080e7          	jalr	-618(ra) # 5c9a <exit>
    printf("%s: rm . worked!\n", s);
    3f0c:	85a6                	mv	a1,s1
    3f0e:	00004517          	auipc	a0,0x4
    3f12:	bca50513          	add	a0,a0,-1078 # 7ad8 <malloc+0x191c>
    3f16:	00002097          	auipc	ra,0x2
    3f1a:	1ee080e7          	jalr	494(ra) # 6104 <printf>
    exit(1);
    3f1e:	4505                	li	a0,1
    3f20:	00002097          	auipc	ra,0x2
    3f24:	d7a080e7          	jalr	-646(ra) # 5c9a <exit>
    printf("%s: rm .. worked!\n", s);
    3f28:	85a6                	mv	a1,s1
    3f2a:	00004517          	auipc	a0,0x4
    3f2e:	bc650513          	add	a0,a0,-1082 # 7af0 <malloc+0x1934>
    3f32:	00002097          	auipc	ra,0x2
    3f36:	1d2080e7          	jalr	466(ra) # 6104 <printf>
    exit(1);
    3f3a:	4505                	li	a0,1
    3f3c:	00002097          	auipc	ra,0x2
    3f40:	d5e080e7          	jalr	-674(ra) # 5c9a <exit>
    printf("%s: chdir / failed\n", s);
    3f44:	85a6                	mv	a1,s1
    3f46:	00003517          	auipc	a0,0x3
    3f4a:	55a50513          	add	a0,a0,1370 # 74a0 <malloc+0x12e4>
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	1b6080e7          	jalr	438(ra) # 6104 <printf>
    exit(1);
    3f56:	4505                	li	a0,1
    3f58:	00002097          	auipc	ra,0x2
    3f5c:	d42080e7          	jalr	-702(ra) # 5c9a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f60:	85a6                	mv	a1,s1
    3f62:	00004517          	auipc	a0,0x4
    3f66:	bae50513          	add	a0,a0,-1106 # 7b10 <malloc+0x1954>
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	19a080e7          	jalr	410(ra) # 6104 <printf>
    exit(1);
    3f72:	4505                	li	a0,1
    3f74:	00002097          	auipc	ra,0x2
    3f78:	d26080e7          	jalr	-730(ra) # 5c9a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3f7c:	85a6                	mv	a1,s1
    3f7e:	00004517          	auipc	a0,0x4
    3f82:	bba50513          	add	a0,a0,-1094 # 7b38 <malloc+0x197c>
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	17e080e7          	jalr	382(ra) # 6104 <printf>
    exit(1);
    3f8e:	4505                	li	a0,1
    3f90:	00002097          	auipc	ra,0x2
    3f94:	d0a080e7          	jalr	-758(ra) # 5c9a <exit>
    printf("%s: unlink dots failed!\n", s);
    3f98:	85a6                	mv	a1,s1
    3f9a:	00004517          	auipc	a0,0x4
    3f9e:	bbe50513          	add	a0,a0,-1090 # 7b58 <malloc+0x199c>
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	162080e7          	jalr	354(ra) # 6104 <printf>
    exit(1);
    3faa:	4505                	li	a0,1
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	cee080e7          	jalr	-786(ra) # 5c9a <exit>

0000000000003fb4 <dirfile>:
{
    3fb4:	1101                	add	sp,sp,-32
    3fb6:	ec06                	sd	ra,24(sp)
    3fb8:	e822                	sd	s0,16(sp)
    3fba:	e426                	sd	s1,8(sp)
    3fbc:	e04a                	sd	s2,0(sp)
    3fbe:	1000                	add	s0,sp,32
    3fc0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3fc2:	20000593          	li	a1,512
    3fc6:	00004517          	auipc	a0,0x4
    3fca:	bb250513          	add	a0,a0,-1102 # 7b78 <malloc+0x19bc>
    3fce:	00002097          	auipc	ra,0x2
    3fd2:	d0c080e7          	jalr	-756(ra) # 5cda <open>
  if(fd < 0){
    3fd6:	0e054d63          	bltz	a0,40d0 <dirfile+0x11c>
  close(fd);
    3fda:	00002097          	auipc	ra,0x2
    3fde:	ce8080e7          	jalr	-792(ra) # 5cc2 <close>
  if(chdir("dirfile") == 0){
    3fe2:	00004517          	auipc	a0,0x4
    3fe6:	b9650513          	add	a0,a0,-1130 # 7b78 <malloc+0x19bc>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	d20080e7          	jalr	-736(ra) # 5d0a <chdir>
    3ff2:	cd6d                	beqz	a0,40ec <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3ff4:	4581                	li	a1,0
    3ff6:	00004517          	auipc	a0,0x4
    3ffa:	bca50513          	add	a0,a0,-1078 # 7bc0 <malloc+0x1a04>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	cdc080e7          	jalr	-804(ra) # 5cda <open>
  if(fd >= 0){
    4006:	10055163          	bgez	a0,4108 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    400a:	20000593          	li	a1,512
    400e:	00004517          	auipc	a0,0x4
    4012:	bb250513          	add	a0,a0,-1102 # 7bc0 <malloc+0x1a04>
    4016:	00002097          	auipc	ra,0x2
    401a:	cc4080e7          	jalr	-828(ra) # 5cda <open>
  if(fd >= 0){
    401e:	10055363          	bgez	a0,4124 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4022:	00004517          	auipc	a0,0x4
    4026:	b9e50513          	add	a0,a0,-1122 # 7bc0 <malloc+0x1a04>
    402a:	00002097          	auipc	ra,0x2
    402e:	cd8080e7          	jalr	-808(ra) # 5d02 <mkdir>
    4032:	10050763          	beqz	a0,4140 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4036:	00004517          	auipc	a0,0x4
    403a:	b8a50513          	add	a0,a0,-1142 # 7bc0 <malloc+0x1a04>
    403e:	00002097          	auipc	ra,0x2
    4042:	cac080e7          	jalr	-852(ra) # 5cea <unlink>
    4046:	10050b63          	beqz	a0,415c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    404a:	00004597          	auipc	a1,0x4
    404e:	b7658593          	add	a1,a1,-1162 # 7bc0 <malloc+0x1a04>
    4052:	00002517          	auipc	a0,0x2
    4056:	46e50513          	add	a0,a0,1134 # 64c0 <malloc+0x304>
    405a:	00002097          	auipc	ra,0x2
    405e:	ca0080e7          	jalr	-864(ra) # 5cfa <link>
    4062:	10050b63          	beqz	a0,4178 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    4066:	00004517          	auipc	a0,0x4
    406a:	b1250513          	add	a0,a0,-1262 # 7b78 <malloc+0x19bc>
    406e:	00002097          	auipc	ra,0x2
    4072:	c7c080e7          	jalr	-900(ra) # 5cea <unlink>
    4076:	10051f63          	bnez	a0,4194 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    407a:	4589                	li	a1,2
    407c:	00003517          	auipc	a0,0x3
    4080:	95450513          	add	a0,a0,-1708 # 69d0 <malloc+0x814>
    4084:	00002097          	auipc	ra,0x2
    4088:	c56080e7          	jalr	-938(ra) # 5cda <open>
  if(fd >= 0){
    408c:	12055263          	bgez	a0,41b0 <dirfile+0x1fc>
  fd = open(".", 0);
    4090:	4581                	li	a1,0
    4092:	00003517          	auipc	a0,0x3
    4096:	93e50513          	add	a0,a0,-1730 # 69d0 <malloc+0x814>
    409a:	00002097          	auipc	ra,0x2
    409e:	c40080e7          	jalr	-960(ra) # 5cda <open>
    40a2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40a4:	4605                	li	a2,1
    40a6:	00002597          	auipc	a1,0x2
    40aa:	2b258593          	add	a1,a1,690 # 6358 <malloc+0x19c>
    40ae:	00002097          	auipc	ra,0x2
    40b2:	c0c080e7          	jalr	-1012(ra) # 5cba <write>
    40b6:	10a04b63          	bgtz	a0,41cc <dirfile+0x218>
  close(fd);
    40ba:	8526                	mv	a0,s1
    40bc:	00002097          	auipc	ra,0x2
    40c0:	c06080e7          	jalr	-1018(ra) # 5cc2 <close>
}
    40c4:	60e2                	ld	ra,24(sp)
    40c6:	6442                	ld	s0,16(sp)
    40c8:	64a2                	ld	s1,8(sp)
    40ca:	6902                	ld	s2,0(sp)
    40cc:	6105                	add	sp,sp,32
    40ce:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    40d0:	85ca                	mv	a1,s2
    40d2:	00004517          	auipc	a0,0x4
    40d6:	aae50513          	add	a0,a0,-1362 # 7b80 <malloc+0x19c4>
    40da:	00002097          	auipc	ra,0x2
    40de:	02a080e7          	jalr	42(ra) # 6104 <printf>
    exit(1);
    40e2:	4505                	li	a0,1
    40e4:	00002097          	auipc	ra,0x2
    40e8:	bb6080e7          	jalr	-1098(ra) # 5c9a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    40ec:	85ca                	mv	a1,s2
    40ee:	00004517          	auipc	a0,0x4
    40f2:	ab250513          	add	a0,a0,-1358 # 7ba0 <malloc+0x19e4>
    40f6:	00002097          	auipc	ra,0x2
    40fa:	00e080e7          	jalr	14(ra) # 6104 <printf>
    exit(1);
    40fe:	4505                	li	a0,1
    4100:	00002097          	auipc	ra,0x2
    4104:	b9a080e7          	jalr	-1126(ra) # 5c9a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4108:	85ca                	mv	a1,s2
    410a:	00004517          	auipc	a0,0x4
    410e:	ac650513          	add	a0,a0,-1338 # 7bd0 <malloc+0x1a14>
    4112:	00002097          	auipc	ra,0x2
    4116:	ff2080e7          	jalr	-14(ra) # 6104 <printf>
    exit(1);
    411a:	4505                	li	a0,1
    411c:	00002097          	auipc	ra,0x2
    4120:	b7e080e7          	jalr	-1154(ra) # 5c9a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4124:	85ca                	mv	a1,s2
    4126:	00004517          	auipc	a0,0x4
    412a:	aaa50513          	add	a0,a0,-1366 # 7bd0 <malloc+0x1a14>
    412e:	00002097          	auipc	ra,0x2
    4132:	fd6080e7          	jalr	-42(ra) # 6104 <printf>
    exit(1);
    4136:	4505                	li	a0,1
    4138:	00002097          	auipc	ra,0x2
    413c:	b62080e7          	jalr	-1182(ra) # 5c9a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4140:	85ca                	mv	a1,s2
    4142:	00004517          	auipc	a0,0x4
    4146:	ab650513          	add	a0,a0,-1354 # 7bf8 <malloc+0x1a3c>
    414a:	00002097          	auipc	ra,0x2
    414e:	fba080e7          	jalr	-70(ra) # 6104 <printf>
    exit(1);
    4152:	4505                	li	a0,1
    4154:	00002097          	auipc	ra,0x2
    4158:	b46080e7          	jalr	-1210(ra) # 5c9a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    415c:	85ca                	mv	a1,s2
    415e:	00004517          	auipc	a0,0x4
    4162:	ac250513          	add	a0,a0,-1342 # 7c20 <malloc+0x1a64>
    4166:	00002097          	auipc	ra,0x2
    416a:	f9e080e7          	jalr	-98(ra) # 6104 <printf>
    exit(1);
    416e:	4505                	li	a0,1
    4170:	00002097          	auipc	ra,0x2
    4174:	b2a080e7          	jalr	-1238(ra) # 5c9a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4178:	85ca                	mv	a1,s2
    417a:	00004517          	auipc	a0,0x4
    417e:	ace50513          	add	a0,a0,-1330 # 7c48 <malloc+0x1a8c>
    4182:	00002097          	auipc	ra,0x2
    4186:	f82080e7          	jalr	-126(ra) # 6104 <printf>
    exit(1);
    418a:	4505                	li	a0,1
    418c:	00002097          	auipc	ra,0x2
    4190:	b0e080e7          	jalr	-1266(ra) # 5c9a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4194:	85ca                	mv	a1,s2
    4196:	00004517          	auipc	a0,0x4
    419a:	ada50513          	add	a0,a0,-1318 # 7c70 <malloc+0x1ab4>
    419e:	00002097          	auipc	ra,0x2
    41a2:	f66080e7          	jalr	-154(ra) # 6104 <printf>
    exit(1);
    41a6:	4505                	li	a0,1
    41a8:	00002097          	auipc	ra,0x2
    41ac:	af2080e7          	jalr	-1294(ra) # 5c9a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41b0:	85ca                	mv	a1,s2
    41b2:	00004517          	auipc	a0,0x4
    41b6:	ade50513          	add	a0,a0,-1314 # 7c90 <malloc+0x1ad4>
    41ba:	00002097          	auipc	ra,0x2
    41be:	f4a080e7          	jalr	-182(ra) # 6104 <printf>
    exit(1);
    41c2:	4505                	li	a0,1
    41c4:	00002097          	auipc	ra,0x2
    41c8:	ad6080e7          	jalr	-1322(ra) # 5c9a <exit>
    printf("%s: write . succeeded!\n", s);
    41cc:	85ca                	mv	a1,s2
    41ce:	00004517          	auipc	a0,0x4
    41d2:	aea50513          	add	a0,a0,-1302 # 7cb8 <malloc+0x1afc>
    41d6:	00002097          	auipc	ra,0x2
    41da:	f2e080e7          	jalr	-210(ra) # 6104 <printf>
    exit(1);
    41de:	4505                	li	a0,1
    41e0:	00002097          	auipc	ra,0x2
    41e4:	aba080e7          	jalr	-1350(ra) # 5c9a <exit>

00000000000041e8 <iref>:
{
    41e8:	7139                	add	sp,sp,-64
    41ea:	fc06                	sd	ra,56(sp)
    41ec:	f822                	sd	s0,48(sp)
    41ee:	f426                	sd	s1,40(sp)
    41f0:	f04a                	sd	s2,32(sp)
    41f2:	ec4e                	sd	s3,24(sp)
    41f4:	e852                	sd	s4,16(sp)
    41f6:	e456                	sd	s5,8(sp)
    41f8:	e05a                	sd	s6,0(sp)
    41fa:	0080                	add	s0,sp,64
    41fc:	8b2a                	mv	s6,a0
    41fe:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4202:	00004a17          	auipc	s4,0x4
    4206:	acea0a13          	add	s4,s4,-1330 # 7cd0 <malloc+0x1b14>
    mkdir("");
    420a:	00003497          	auipc	s1,0x3
    420e:	5ce48493          	add	s1,s1,1486 # 77d8 <malloc+0x161c>
    link("README", "");
    4212:	00002a97          	auipc	s5,0x2
    4216:	2aea8a93          	add	s5,s5,686 # 64c0 <malloc+0x304>
    fd = open("xx", O_CREATE);
    421a:	00004997          	auipc	s3,0x4
    421e:	9ae98993          	add	s3,s3,-1618 # 7bc8 <malloc+0x1a0c>
    4222:	a891                	j	4276 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4224:	85da                	mv	a1,s6
    4226:	00004517          	auipc	a0,0x4
    422a:	ab250513          	add	a0,a0,-1358 # 7cd8 <malloc+0x1b1c>
    422e:	00002097          	auipc	ra,0x2
    4232:	ed6080e7          	jalr	-298(ra) # 6104 <printf>
      exit(1);
    4236:	4505                	li	a0,1
    4238:	00002097          	auipc	ra,0x2
    423c:	a62080e7          	jalr	-1438(ra) # 5c9a <exit>
      printf("%s: chdir irefd failed\n", s);
    4240:	85da                	mv	a1,s6
    4242:	00004517          	auipc	a0,0x4
    4246:	aae50513          	add	a0,a0,-1362 # 7cf0 <malloc+0x1b34>
    424a:	00002097          	auipc	ra,0x2
    424e:	eba080e7          	jalr	-326(ra) # 6104 <printf>
      exit(1);
    4252:	4505                	li	a0,1
    4254:	00002097          	auipc	ra,0x2
    4258:	a46080e7          	jalr	-1466(ra) # 5c9a <exit>
      close(fd);
    425c:	00002097          	auipc	ra,0x2
    4260:	a66080e7          	jalr	-1434(ra) # 5cc2 <close>
    4264:	a889                	j	42b6 <iref+0xce>
    unlink("xx");
    4266:	854e                	mv	a0,s3
    4268:	00002097          	auipc	ra,0x2
    426c:	a82080e7          	jalr	-1406(ra) # 5cea <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4270:	397d                	addw	s2,s2,-1
    4272:	06090063          	beqz	s2,42d2 <iref+0xea>
    if(mkdir("irefd") != 0){
    4276:	8552                	mv	a0,s4
    4278:	00002097          	auipc	ra,0x2
    427c:	a8a080e7          	jalr	-1398(ra) # 5d02 <mkdir>
    4280:	f155                	bnez	a0,4224 <iref+0x3c>
    if(chdir("irefd") != 0){
    4282:	8552                	mv	a0,s4
    4284:	00002097          	auipc	ra,0x2
    4288:	a86080e7          	jalr	-1402(ra) # 5d0a <chdir>
    428c:	f955                	bnez	a0,4240 <iref+0x58>
    mkdir("");
    428e:	8526                	mv	a0,s1
    4290:	00002097          	auipc	ra,0x2
    4294:	a72080e7          	jalr	-1422(ra) # 5d02 <mkdir>
    link("README", "");
    4298:	85a6                	mv	a1,s1
    429a:	8556                	mv	a0,s5
    429c:	00002097          	auipc	ra,0x2
    42a0:	a5e080e7          	jalr	-1442(ra) # 5cfa <link>
    fd = open("", O_CREATE);
    42a4:	20000593          	li	a1,512
    42a8:	8526                	mv	a0,s1
    42aa:	00002097          	auipc	ra,0x2
    42ae:	a30080e7          	jalr	-1488(ra) # 5cda <open>
    if(fd >= 0)
    42b2:	fa0555e3          	bgez	a0,425c <iref+0x74>
    fd = open("xx", O_CREATE);
    42b6:	20000593          	li	a1,512
    42ba:	854e                	mv	a0,s3
    42bc:	00002097          	auipc	ra,0x2
    42c0:	a1e080e7          	jalr	-1506(ra) # 5cda <open>
    if(fd >= 0)
    42c4:	fa0541e3          	bltz	a0,4266 <iref+0x7e>
      close(fd);
    42c8:	00002097          	auipc	ra,0x2
    42cc:	9fa080e7          	jalr	-1542(ra) # 5cc2 <close>
    42d0:	bf59                	j	4266 <iref+0x7e>
    42d2:	03300493          	li	s1,51
    chdir("..");
    42d6:	00003997          	auipc	s3,0x3
    42da:	21a98993          	add	s3,s3,538 # 74f0 <malloc+0x1334>
    unlink("irefd");
    42de:	00004917          	auipc	s2,0x4
    42e2:	9f290913          	add	s2,s2,-1550 # 7cd0 <malloc+0x1b14>
    chdir("..");
    42e6:	854e                	mv	a0,s3
    42e8:	00002097          	auipc	ra,0x2
    42ec:	a22080e7          	jalr	-1502(ra) # 5d0a <chdir>
    unlink("irefd");
    42f0:	854a                	mv	a0,s2
    42f2:	00002097          	auipc	ra,0x2
    42f6:	9f8080e7          	jalr	-1544(ra) # 5cea <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42fa:	34fd                	addw	s1,s1,-1
    42fc:	f4ed                	bnez	s1,42e6 <iref+0xfe>
  chdir("/");
    42fe:	00003517          	auipc	a0,0x3
    4302:	19a50513          	add	a0,a0,410 # 7498 <malloc+0x12dc>
    4306:	00002097          	auipc	ra,0x2
    430a:	a04080e7          	jalr	-1532(ra) # 5d0a <chdir>
}
    430e:	70e2                	ld	ra,56(sp)
    4310:	7442                	ld	s0,48(sp)
    4312:	74a2                	ld	s1,40(sp)
    4314:	7902                	ld	s2,32(sp)
    4316:	69e2                	ld	s3,24(sp)
    4318:	6a42                	ld	s4,16(sp)
    431a:	6aa2                	ld	s5,8(sp)
    431c:	6b02                	ld	s6,0(sp)
    431e:	6121                	add	sp,sp,64
    4320:	8082                	ret

0000000000004322 <openiputtest>:
{
    4322:	7179                	add	sp,sp,-48
    4324:	f406                	sd	ra,40(sp)
    4326:	f022                	sd	s0,32(sp)
    4328:	ec26                	sd	s1,24(sp)
    432a:	1800                	add	s0,sp,48
    432c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    432e:	00004517          	auipc	a0,0x4
    4332:	9da50513          	add	a0,a0,-1574 # 7d08 <malloc+0x1b4c>
    4336:	00002097          	auipc	ra,0x2
    433a:	9cc080e7          	jalr	-1588(ra) # 5d02 <mkdir>
    433e:	04054263          	bltz	a0,4382 <openiputtest+0x60>
  pid = fork();
    4342:	00002097          	auipc	ra,0x2
    4346:	950080e7          	jalr	-1712(ra) # 5c92 <fork>
  if(pid < 0){
    434a:	04054a63          	bltz	a0,439e <openiputtest+0x7c>
  if(pid == 0){
    434e:	e93d                	bnez	a0,43c4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4350:	4589                	li	a1,2
    4352:	00004517          	auipc	a0,0x4
    4356:	9b650513          	add	a0,a0,-1610 # 7d08 <malloc+0x1b4c>
    435a:	00002097          	auipc	ra,0x2
    435e:	980080e7          	jalr	-1664(ra) # 5cda <open>
    if(fd >= 0){
    4362:	04054c63          	bltz	a0,43ba <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    4366:	85a6                	mv	a1,s1
    4368:	00004517          	auipc	a0,0x4
    436c:	9c050513          	add	a0,a0,-1600 # 7d28 <malloc+0x1b6c>
    4370:	00002097          	auipc	ra,0x2
    4374:	d94080e7          	jalr	-620(ra) # 6104 <printf>
      exit(1);
    4378:	4505                	li	a0,1
    437a:	00002097          	auipc	ra,0x2
    437e:	920080e7          	jalr	-1760(ra) # 5c9a <exit>
    printf("%s: mkdir oidir failed\n", s);
    4382:	85a6                	mv	a1,s1
    4384:	00004517          	auipc	a0,0x4
    4388:	98c50513          	add	a0,a0,-1652 # 7d10 <malloc+0x1b54>
    438c:	00002097          	auipc	ra,0x2
    4390:	d78080e7          	jalr	-648(ra) # 6104 <printf>
    exit(1);
    4394:	4505                	li	a0,1
    4396:	00002097          	auipc	ra,0x2
    439a:	904080e7          	jalr	-1788(ra) # 5c9a <exit>
    printf("%s: fork failed\n", s);
    439e:	85a6                	mv	a1,s1
    43a0:	00002517          	auipc	a0,0x2
    43a4:	7d850513          	add	a0,a0,2008 # 6b78 <malloc+0x9bc>
    43a8:	00002097          	auipc	ra,0x2
    43ac:	d5c080e7          	jalr	-676(ra) # 6104 <printf>
    exit(1);
    43b0:	4505                	li	a0,1
    43b2:	00002097          	auipc	ra,0x2
    43b6:	8e8080e7          	jalr	-1816(ra) # 5c9a <exit>
    exit(0);
    43ba:	4501                	li	a0,0
    43bc:	00002097          	auipc	ra,0x2
    43c0:	8de080e7          	jalr	-1826(ra) # 5c9a <exit>
  sleep(1);
    43c4:	4505                	li	a0,1
    43c6:	00002097          	auipc	ra,0x2
    43ca:	964080e7          	jalr	-1692(ra) # 5d2a <sleep>
  if(unlink("oidir") != 0){
    43ce:	00004517          	auipc	a0,0x4
    43d2:	93a50513          	add	a0,a0,-1734 # 7d08 <malloc+0x1b4c>
    43d6:	00002097          	auipc	ra,0x2
    43da:	914080e7          	jalr	-1772(ra) # 5cea <unlink>
    43de:	cd19                	beqz	a0,43fc <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    43e0:	85a6                	mv	a1,s1
    43e2:	00003517          	auipc	a0,0x3
    43e6:	98650513          	add	a0,a0,-1658 # 6d68 <malloc+0xbac>
    43ea:	00002097          	auipc	ra,0x2
    43ee:	d1a080e7          	jalr	-742(ra) # 6104 <printf>
    exit(1);
    43f2:	4505                	li	a0,1
    43f4:	00002097          	auipc	ra,0x2
    43f8:	8a6080e7          	jalr	-1882(ra) # 5c9a <exit>
  wait(&xstatus);
    43fc:	fdc40513          	add	a0,s0,-36
    4400:	00002097          	auipc	ra,0x2
    4404:	8a2080e7          	jalr	-1886(ra) # 5ca2 <wait>
  exit(xstatus);
    4408:	fdc42503          	lw	a0,-36(s0)
    440c:	00002097          	auipc	ra,0x2
    4410:	88e080e7          	jalr	-1906(ra) # 5c9a <exit>

0000000000004414 <forkforkfork>:
{
    4414:	1101                	add	sp,sp,-32
    4416:	ec06                	sd	ra,24(sp)
    4418:	e822                	sd	s0,16(sp)
    441a:	e426                	sd	s1,8(sp)
    441c:	1000                	add	s0,sp,32
    441e:	84aa                	mv	s1,a0
  unlink("stopforking");
    4420:	00004517          	auipc	a0,0x4
    4424:	93050513          	add	a0,a0,-1744 # 7d50 <malloc+0x1b94>
    4428:	00002097          	auipc	ra,0x2
    442c:	8c2080e7          	jalr	-1854(ra) # 5cea <unlink>
  int pid = fork();
    4430:	00002097          	auipc	ra,0x2
    4434:	862080e7          	jalr	-1950(ra) # 5c92 <fork>
  if(pid < 0){
    4438:	04054563          	bltz	a0,4482 <forkforkfork+0x6e>
  if(pid == 0){
    443c:	c12d                	beqz	a0,449e <forkforkfork+0x8a>
  sleep(20); /* two seconds */
    443e:	4551                	li	a0,20
    4440:	00002097          	auipc	ra,0x2
    4444:	8ea080e7          	jalr	-1814(ra) # 5d2a <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4448:	20200593          	li	a1,514
    444c:	00004517          	auipc	a0,0x4
    4450:	90450513          	add	a0,a0,-1788 # 7d50 <malloc+0x1b94>
    4454:	00002097          	auipc	ra,0x2
    4458:	886080e7          	jalr	-1914(ra) # 5cda <open>
    445c:	00002097          	auipc	ra,0x2
    4460:	866080e7          	jalr	-1946(ra) # 5cc2 <close>
  wait(0);
    4464:	4501                	li	a0,0
    4466:	00002097          	auipc	ra,0x2
    446a:	83c080e7          	jalr	-1988(ra) # 5ca2 <wait>
  sleep(10); /* one second */
    446e:	4529                	li	a0,10
    4470:	00002097          	auipc	ra,0x2
    4474:	8ba080e7          	jalr	-1862(ra) # 5d2a <sleep>
}
    4478:	60e2                	ld	ra,24(sp)
    447a:	6442                	ld	s0,16(sp)
    447c:	64a2                	ld	s1,8(sp)
    447e:	6105                	add	sp,sp,32
    4480:	8082                	ret
    printf("%s: fork failed", s);
    4482:	85a6                	mv	a1,s1
    4484:	00003517          	auipc	a0,0x3
    4488:	8b450513          	add	a0,a0,-1868 # 6d38 <malloc+0xb7c>
    448c:	00002097          	auipc	ra,0x2
    4490:	c78080e7          	jalr	-904(ra) # 6104 <printf>
    exit(1);
    4494:	4505                	li	a0,1
    4496:	00002097          	auipc	ra,0x2
    449a:	804080e7          	jalr	-2044(ra) # 5c9a <exit>
      int fd = open("stopforking", 0);
    449e:	00004497          	auipc	s1,0x4
    44a2:	8b248493          	add	s1,s1,-1870 # 7d50 <malloc+0x1b94>
    44a6:	4581                	li	a1,0
    44a8:	8526                	mv	a0,s1
    44aa:	00002097          	auipc	ra,0x2
    44ae:	830080e7          	jalr	-2000(ra) # 5cda <open>
      if(fd >= 0){
    44b2:	02055763          	bgez	a0,44e0 <forkforkfork+0xcc>
      if(fork() < 0){
    44b6:	00001097          	auipc	ra,0x1
    44ba:	7dc080e7          	jalr	2012(ra) # 5c92 <fork>
    44be:	fe0554e3          	bgez	a0,44a6 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44c2:	20200593          	li	a1,514
    44c6:	00004517          	auipc	a0,0x4
    44ca:	88a50513          	add	a0,a0,-1910 # 7d50 <malloc+0x1b94>
    44ce:	00002097          	auipc	ra,0x2
    44d2:	80c080e7          	jalr	-2036(ra) # 5cda <open>
    44d6:	00001097          	auipc	ra,0x1
    44da:	7ec080e7          	jalr	2028(ra) # 5cc2 <close>
    44de:	b7e1                	j	44a6 <forkforkfork+0x92>
        exit(0);
    44e0:	4501                	li	a0,0
    44e2:	00001097          	auipc	ra,0x1
    44e6:	7b8080e7          	jalr	1976(ra) # 5c9a <exit>

00000000000044ea <killstatus>:
{
    44ea:	7139                	add	sp,sp,-64
    44ec:	fc06                	sd	ra,56(sp)
    44ee:	f822                	sd	s0,48(sp)
    44f0:	f426                	sd	s1,40(sp)
    44f2:	f04a                	sd	s2,32(sp)
    44f4:	ec4e                	sd	s3,24(sp)
    44f6:	e852                	sd	s4,16(sp)
    44f8:	0080                	add	s0,sp,64
    44fa:	8a2a                	mv	s4,a0
    44fc:	06400913          	li	s2,100
    if(xst != -1) {
    4500:	59fd                	li	s3,-1
    int pid1 = fork();
    4502:	00001097          	auipc	ra,0x1
    4506:	790080e7          	jalr	1936(ra) # 5c92 <fork>
    450a:	84aa                	mv	s1,a0
    if(pid1 < 0){
    450c:	02054f63          	bltz	a0,454a <killstatus+0x60>
    if(pid1 == 0){
    4510:	c939                	beqz	a0,4566 <killstatus+0x7c>
    sleep(1);
    4512:	4505                	li	a0,1
    4514:	00002097          	auipc	ra,0x2
    4518:	816080e7          	jalr	-2026(ra) # 5d2a <sleep>
    kill(pid1);
    451c:	8526                	mv	a0,s1
    451e:	00001097          	auipc	ra,0x1
    4522:	7ac080e7          	jalr	1964(ra) # 5cca <kill>
    wait(&xst);
    4526:	fcc40513          	add	a0,s0,-52
    452a:	00001097          	auipc	ra,0x1
    452e:	778080e7          	jalr	1912(ra) # 5ca2 <wait>
    if(xst != -1) {
    4532:	fcc42783          	lw	a5,-52(s0)
    4536:	03379d63          	bne	a5,s3,4570 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    453a:	397d                	addw	s2,s2,-1
    453c:	fc0913e3          	bnez	s2,4502 <killstatus+0x18>
  exit(0);
    4540:	4501                	li	a0,0
    4542:	00001097          	auipc	ra,0x1
    4546:	758080e7          	jalr	1880(ra) # 5c9a <exit>
      printf("%s: fork failed\n", s);
    454a:	85d2                	mv	a1,s4
    454c:	00002517          	auipc	a0,0x2
    4550:	62c50513          	add	a0,a0,1580 # 6b78 <malloc+0x9bc>
    4554:	00002097          	auipc	ra,0x2
    4558:	bb0080e7          	jalr	-1104(ra) # 6104 <printf>
      exit(1);
    455c:	4505                	li	a0,1
    455e:	00001097          	auipc	ra,0x1
    4562:	73c080e7          	jalr	1852(ra) # 5c9a <exit>
        getpid();
    4566:	00001097          	auipc	ra,0x1
    456a:	7b4080e7          	jalr	1972(ra) # 5d1a <getpid>
      while(1) {
    456e:	bfe5                	j	4566 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4570:	85d2                	mv	a1,s4
    4572:	00003517          	auipc	a0,0x3
    4576:	7ee50513          	add	a0,a0,2030 # 7d60 <malloc+0x1ba4>
    457a:	00002097          	auipc	ra,0x2
    457e:	b8a080e7          	jalr	-1142(ra) # 6104 <printf>
       exit(1);
    4582:	4505                	li	a0,1
    4584:	00001097          	auipc	ra,0x1
    4588:	716080e7          	jalr	1814(ra) # 5c9a <exit>

000000000000458c <preempt>:
{
    458c:	7139                	add	sp,sp,-64
    458e:	fc06                	sd	ra,56(sp)
    4590:	f822                	sd	s0,48(sp)
    4592:	f426                	sd	s1,40(sp)
    4594:	f04a                	sd	s2,32(sp)
    4596:	ec4e                	sd	s3,24(sp)
    4598:	e852                	sd	s4,16(sp)
    459a:	0080                	add	s0,sp,64
    459c:	892a                	mv	s2,a0
  pid1 = fork();
    459e:	00001097          	auipc	ra,0x1
    45a2:	6f4080e7          	jalr	1780(ra) # 5c92 <fork>
  if(pid1 < 0) {
    45a6:	00054563          	bltz	a0,45b0 <preempt+0x24>
    45aa:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45ac:	e105                	bnez	a0,45cc <preempt+0x40>
    for(;;)
    45ae:	a001                	j	45ae <preempt+0x22>
    printf("%s: fork failed", s);
    45b0:	85ca                	mv	a1,s2
    45b2:	00002517          	auipc	a0,0x2
    45b6:	78650513          	add	a0,a0,1926 # 6d38 <malloc+0xb7c>
    45ba:	00002097          	auipc	ra,0x2
    45be:	b4a080e7          	jalr	-1206(ra) # 6104 <printf>
    exit(1);
    45c2:	4505                	li	a0,1
    45c4:	00001097          	auipc	ra,0x1
    45c8:	6d6080e7          	jalr	1750(ra) # 5c9a <exit>
  pid2 = fork();
    45cc:	00001097          	auipc	ra,0x1
    45d0:	6c6080e7          	jalr	1734(ra) # 5c92 <fork>
    45d4:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    45d6:	00054463          	bltz	a0,45de <preempt+0x52>
  if(pid2 == 0)
    45da:	e105                	bnez	a0,45fa <preempt+0x6e>
    for(;;)
    45dc:	a001                	j	45dc <preempt+0x50>
    printf("%s: fork failed\n", s);
    45de:	85ca                	mv	a1,s2
    45e0:	00002517          	auipc	a0,0x2
    45e4:	59850513          	add	a0,a0,1432 # 6b78 <malloc+0x9bc>
    45e8:	00002097          	auipc	ra,0x2
    45ec:	b1c080e7          	jalr	-1252(ra) # 6104 <printf>
    exit(1);
    45f0:	4505                	li	a0,1
    45f2:	00001097          	auipc	ra,0x1
    45f6:	6a8080e7          	jalr	1704(ra) # 5c9a <exit>
  pipe(pfds);
    45fa:	fc840513          	add	a0,s0,-56
    45fe:	00001097          	auipc	ra,0x1
    4602:	6ac080e7          	jalr	1708(ra) # 5caa <pipe>
  pid3 = fork();
    4606:	00001097          	auipc	ra,0x1
    460a:	68c080e7          	jalr	1676(ra) # 5c92 <fork>
    460e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4610:	02054e63          	bltz	a0,464c <preempt+0xc0>
  if(pid3 == 0){
    4614:	e525                	bnez	a0,467c <preempt+0xf0>
    close(pfds[0]);
    4616:	fc842503          	lw	a0,-56(s0)
    461a:	00001097          	auipc	ra,0x1
    461e:	6a8080e7          	jalr	1704(ra) # 5cc2 <close>
    if(write(pfds[1], "x", 1) != 1)
    4622:	4605                	li	a2,1
    4624:	00002597          	auipc	a1,0x2
    4628:	d3458593          	add	a1,a1,-716 # 6358 <malloc+0x19c>
    462c:	fcc42503          	lw	a0,-52(s0)
    4630:	00001097          	auipc	ra,0x1
    4634:	68a080e7          	jalr	1674(ra) # 5cba <write>
    4638:	4785                	li	a5,1
    463a:	02f51763          	bne	a0,a5,4668 <preempt+0xdc>
    close(pfds[1]);
    463e:	fcc42503          	lw	a0,-52(s0)
    4642:	00001097          	auipc	ra,0x1
    4646:	680080e7          	jalr	1664(ra) # 5cc2 <close>
    for(;;)
    464a:	a001                	j	464a <preempt+0xbe>
     printf("%s: fork failed\n", s);
    464c:	85ca                	mv	a1,s2
    464e:	00002517          	auipc	a0,0x2
    4652:	52a50513          	add	a0,a0,1322 # 6b78 <malloc+0x9bc>
    4656:	00002097          	auipc	ra,0x2
    465a:	aae080e7          	jalr	-1362(ra) # 6104 <printf>
     exit(1);
    465e:	4505                	li	a0,1
    4660:	00001097          	auipc	ra,0x1
    4664:	63a080e7          	jalr	1594(ra) # 5c9a <exit>
      printf("%s: preempt write error", s);
    4668:	85ca                	mv	a1,s2
    466a:	00003517          	auipc	a0,0x3
    466e:	71650513          	add	a0,a0,1814 # 7d80 <malloc+0x1bc4>
    4672:	00002097          	auipc	ra,0x2
    4676:	a92080e7          	jalr	-1390(ra) # 6104 <printf>
    467a:	b7d1                	j	463e <preempt+0xb2>
  close(pfds[1]);
    467c:	fcc42503          	lw	a0,-52(s0)
    4680:	00001097          	auipc	ra,0x1
    4684:	642080e7          	jalr	1602(ra) # 5cc2 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4688:	660d                	lui	a2,0x3
    468a:	00008597          	auipc	a1,0x8
    468e:	5ee58593          	add	a1,a1,1518 # cc78 <buf>
    4692:	fc842503          	lw	a0,-56(s0)
    4696:	00001097          	auipc	ra,0x1
    469a:	61c080e7          	jalr	1564(ra) # 5cb2 <read>
    469e:	4785                	li	a5,1
    46a0:	02f50363          	beq	a0,a5,46c6 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46a4:	85ca                	mv	a1,s2
    46a6:	00003517          	auipc	a0,0x3
    46aa:	6f250513          	add	a0,a0,1778 # 7d98 <malloc+0x1bdc>
    46ae:	00002097          	auipc	ra,0x2
    46b2:	a56080e7          	jalr	-1450(ra) # 6104 <printf>
}
    46b6:	70e2                	ld	ra,56(sp)
    46b8:	7442                	ld	s0,48(sp)
    46ba:	74a2                	ld	s1,40(sp)
    46bc:	7902                	ld	s2,32(sp)
    46be:	69e2                	ld	s3,24(sp)
    46c0:	6a42                	ld	s4,16(sp)
    46c2:	6121                	add	sp,sp,64
    46c4:	8082                	ret
  close(pfds[0]);
    46c6:	fc842503          	lw	a0,-56(s0)
    46ca:	00001097          	auipc	ra,0x1
    46ce:	5f8080e7          	jalr	1528(ra) # 5cc2 <close>
  printf("kill... ");
    46d2:	00003517          	auipc	a0,0x3
    46d6:	6de50513          	add	a0,a0,1758 # 7db0 <malloc+0x1bf4>
    46da:	00002097          	auipc	ra,0x2
    46de:	a2a080e7          	jalr	-1494(ra) # 6104 <printf>
  kill(pid1);
    46e2:	8526                	mv	a0,s1
    46e4:	00001097          	auipc	ra,0x1
    46e8:	5e6080e7          	jalr	1510(ra) # 5cca <kill>
  kill(pid2);
    46ec:	854e                	mv	a0,s3
    46ee:	00001097          	auipc	ra,0x1
    46f2:	5dc080e7          	jalr	1500(ra) # 5cca <kill>
  kill(pid3);
    46f6:	8552                	mv	a0,s4
    46f8:	00001097          	auipc	ra,0x1
    46fc:	5d2080e7          	jalr	1490(ra) # 5cca <kill>
  printf("wait... ");
    4700:	00003517          	auipc	a0,0x3
    4704:	6c050513          	add	a0,a0,1728 # 7dc0 <malloc+0x1c04>
    4708:	00002097          	auipc	ra,0x2
    470c:	9fc080e7          	jalr	-1540(ra) # 6104 <printf>
  wait(0);
    4710:	4501                	li	a0,0
    4712:	00001097          	auipc	ra,0x1
    4716:	590080e7          	jalr	1424(ra) # 5ca2 <wait>
  wait(0);
    471a:	4501                	li	a0,0
    471c:	00001097          	auipc	ra,0x1
    4720:	586080e7          	jalr	1414(ra) # 5ca2 <wait>
  wait(0);
    4724:	4501                	li	a0,0
    4726:	00001097          	auipc	ra,0x1
    472a:	57c080e7          	jalr	1404(ra) # 5ca2 <wait>
    472e:	b761                	j	46b6 <preempt+0x12a>

0000000000004730 <reparent>:
{
    4730:	7179                	add	sp,sp,-48
    4732:	f406                	sd	ra,40(sp)
    4734:	f022                	sd	s0,32(sp)
    4736:	ec26                	sd	s1,24(sp)
    4738:	e84a                	sd	s2,16(sp)
    473a:	e44e                	sd	s3,8(sp)
    473c:	e052                	sd	s4,0(sp)
    473e:	1800                	add	s0,sp,48
    4740:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4742:	00001097          	auipc	ra,0x1
    4746:	5d8080e7          	jalr	1496(ra) # 5d1a <getpid>
    474a:	8a2a                	mv	s4,a0
    474c:	0c800913          	li	s2,200
    int pid = fork();
    4750:	00001097          	auipc	ra,0x1
    4754:	542080e7          	jalr	1346(ra) # 5c92 <fork>
    4758:	84aa                	mv	s1,a0
    if(pid < 0){
    475a:	02054263          	bltz	a0,477e <reparent+0x4e>
    if(pid){
    475e:	cd21                	beqz	a0,47b6 <reparent+0x86>
      if(wait(0) != pid){
    4760:	4501                	li	a0,0
    4762:	00001097          	auipc	ra,0x1
    4766:	540080e7          	jalr	1344(ra) # 5ca2 <wait>
    476a:	02951863          	bne	a0,s1,479a <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    476e:	397d                	addw	s2,s2,-1
    4770:	fe0910e3          	bnez	s2,4750 <reparent+0x20>
  exit(0);
    4774:	4501                	li	a0,0
    4776:	00001097          	auipc	ra,0x1
    477a:	524080e7          	jalr	1316(ra) # 5c9a <exit>
      printf("%s: fork failed\n", s);
    477e:	85ce                	mv	a1,s3
    4780:	00002517          	auipc	a0,0x2
    4784:	3f850513          	add	a0,a0,1016 # 6b78 <malloc+0x9bc>
    4788:	00002097          	auipc	ra,0x2
    478c:	97c080e7          	jalr	-1668(ra) # 6104 <printf>
      exit(1);
    4790:	4505                	li	a0,1
    4792:	00001097          	auipc	ra,0x1
    4796:	508080e7          	jalr	1288(ra) # 5c9a <exit>
        printf("%s: wait wrong pid\n", s);
    479a:	85ce                	mv	a1,s3
    479c:	00002517          	auipc	a0,0x2
    47a0:	56450513          	add	a0,a0,1380 # 6d00 <malloc+0xb44>
    47a4:	00002097          	auipc	ra,0x2
    47a8:	960080e7          	jalr	-1696(ra) # 6104 <printf>
        exit(1);
    47ac:	4505                	li	a0,1
    47ae:	00001097          	auipc	ra,0x1
    47b2:	4ec080e7          	jalr	1260(ra) # 5c9a <exit>
      int pid2 = fork();
    47b6:	00001097          	auipc	ra,0x1
    47ba:	4dc080e7          	jalr	1244(ra) # 5c92 <fork>
      if(pid2 < 0){
    47be:	00054763          	bltz	a0,47cc <reparent+0x9c>
      exit(0);
    47c2:	4501                	li	a0,0
    47c4:	00001097          	auipc	ra,0x1
    47c8:	4d6080e7          	jalr	1238(ra) # 5c9a <exit>
        kill(master_pid);
    47cc:	8552                	mv	a0,s4
    47ce:	00001097          	auipc	ra,0x1
    47d2:	4fc080e7          	jalr	1276(ra) # 5cca <kill>
        exit(1);
    47d6:	4505                	li	a0,1
    47d8:	00001097          	auipc	ra,0x1
    47dc:	4c2080e7          	jalr	1218(ra) # 5c9a <exit>

00000000000047e0 <sbrkfail>:
{
    47e0:	7119                	add	sp,sp,-128
    47e2:	fc86                	sd	ra,120(sp)
    47e4:	f8a2                	sd	s0,112(sp)
    47e6:	f4a6                	sd	s1,104(sp)
    47e8:	f0ca                	sd	s2,96(sp)
    47ea:	ecce                	sd	s3,88(sp)
    47ec:	e8d2                	sd	s4,80(sp)
    47ee:	e4d6                	sd	s5,72(sp)
    47f0:	0100                	add	s0,sp,128
    47f2:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    47f4:	fb040513          	add	a0,s0,-80
    47f8:	00001097          	auipc	ra,0x1
    47fc:	4b2080e7          	jalr	1202(ra) # 5caa <pipe>
    4800:	e901                	bnez	a0,4810 <sbrkfail+0x30>
    4802:	f8040493          	add	s1,s0,-128
    4806:	fa840993          	add	s3,s0,-88
    480a:	8926                	mv	s2,s1
    if(pids[i] != -1)
    480c:	5a7d                	li	s4,-1
    480e:	a085                	j	486e <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4810:	85d6                	mv	a1,s5
    4812:	00002517          	auipc	a0,0x2
    4816:	46e50513          	add	a0,a0,1134 # 6c80 <malloc+0xac4>
    481a:	00002097          	auipc	ra,0x2
    481e:	8ea080e7          	jalr	-1814(ra) # 6104 <printf>
    exit(1);
    4822:	4505                	li	a0,1
    4824:	00001097          	auipc	ra,0x1
    4828:	476080e7          	jalr	1142(ra) # 5c9a <exit>
      sbrk(BIG - (uint64)sbrk(0));
    482c:	00001097          	auipc	ra,0x1
    4830:	4f6080e7          	jalr	1270(ra) # 5d22 <sbrk>
    4834:	064007b7          	lui	a5,0x6400
    4838:	40a7853b          	subw	a0,a5,a0
    483c:	00001097          	auipc	ra,0x1
    4840:	4e6080e7          	jalr	1254(ra) # 5d22 <sbrk>
      write(fds[1], "x", 1);
    4844:	4605                	li	a2,1
    4846:	00002597          	auipc	a1,0x2
    484a:	b1258593          	add	a1,a1,-1262 # 6358 <malloc+0x19c>
    484e:	fb442503          	lw	a0,-76(s0)
    4852:	00001097          	auipc	ra,0x1
    4856:	468080e7          	jalr	1128(ra) # 5cba <write>
      for(;;) sleep(1000);
    485a:	3e800513          	li	a0,1000
    485e:	00001097          	auipc	ra,0x1
    4862:	4cc080e7          	jalr	1228(ra) # 5d2a <sleep>
    4866:	bfd5                	j	485a <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4868:	0911                	add	s2,s2,4
    486a:	03390563          	beq	s2,s3,4894 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    486e:	00001097          	auipc	ra,0x1
    4872:	424080e7          	jalr	1060(ra) # 5c92 <fork>
    4876:	00a92023          	sw	a0,0(s2)
    487a:	d94d                	beqz	a0,482c <sbrkfail+0x4c>
    if(pids[i] != -1)
    487c:	ff4506e3          	beq	a0,s4,4868 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4880:	4605                	li	a2,1
    4882:	faf40593          	add	a1,s0,-81
    4886:	fb042503          	lw	a0,-80(s0)
    488a:	00001097          	auipc	ra,0x1
    488e:	428080e7          	jalr	1064(ra) # 5cb2 <read>
    4892:	bfd9                	j	4868 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4894:	6505                	lui	a0,0x1
    4896:	00001097          	auipc	ra,0x1
    489a:	48c080e7          	jalr	1164(ra) # 5d22 <sbrk>
    489e:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48a0:	597d                	li	s2,-1
    48a2:	a021                	j	48aa <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48a4:	0491                	add	s1,s1,4
    48a6:	01348f63          	beq	s1,s3,48c4 <sbrkfail+0xe4>
    if(pids[i] == -1)
    48aa:	4088                	lw	a0,0(s1)
    48ac:	ff250ce3          	beq	a0,s2,48a4 <sbrkfail+0xc4>
    kill(pids[i]);
    48b0:	00001097          	auipc	ra,0x1
    48b4:	41a080e7          	jalr	1050(ra) # 5cca <kill>
    wait(0);
    48b8:	4501                	li	a0,0
    48ba:	00001097          	auipc	ra,0x1
    48be:	3e8080e7          	jalr	1000(ra) # 5ca2 <wait>
    48c2:	b7cd                	j	48a4 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    48c4:	57fd                	li	a5,-1
    48c6:	04fa0163          	beq	s4,a5,4908 <sbrkfail+0x128>
  pid = fork();
    48ca:	00001097          	auipc	ra,0x1
    48ce:	3c8080e7          	jalr	968(ra) # 5c92 <fork>
    48d2:	84aa                	mv	s1,a0
  if(pid < 0){
    48d4:	04054863          	bltz	a0,4924 <sbrkfail+0x144>
  if(pid == 0){
    48d8:	c525                	beqz	a0,4940 <sbrkfail+0x160>
  wait(&xstatus);
    48da:	fbc40513          	add	a0,s0,-68
    48de:	00001097          	auipc	ra,0x1
    48e2:	3c4080e7          	jalr	964(ra) # 5ca2 <wait>
  if(xstatus != -1 && xstatus != 2)
    48e6:	fbc42783          	lw	a5,-68(s0)
    48ea:	577d                	li	a4,-1
    48ec:	00e78563          	beq	a5,a4,48f6 <sbrkfail+0x116>
    48f0:	4709                	li	a4,2
    48f2:	08e79d63          	bne	a5,a4,498c <sbrkfail+0x1ac>
}
    48f6:	70e6                	ld	ra,120(sp)
    48f8:	7446                	ld	s0,112(sp)
    48fa:	74a6                	ld	s1,104(sp)
    48fc:	7906                	ld	s2,96(sp)
    48fe:	69e6                	ld	s3,88(sp)
    4900:	6a46                	ld	s4,80(sp)
    4902:	6aa6                	ld	s5,72(sp)
    4904:	6109                	add	sp,sp,128
    4906:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4908:	85d6                	mv	a1,s5
    490a:	00003517          	auipc	a0,0x3
    490e:	4c650513          	add	a0,a0,1222 # 7dd0 <malloc+0x1c14>
    4912:	00001097          	auipc	ra,0x1
    4916:	7f2080e7          	jalr	2034(ra) # 6104 <printf>
    exit(1);
    491a:	4505                	li	a0,1
    491c:	00001097          	auipc	ra,0x1
    4920:	37e080e7          	jalr	894(ra) # 5c9a <exit>
    printf("%s: fork failed\n", s);
    4924:	85d6                	mv	a1,s5
    4926:	00002517          	auipc	a0,0x2
    492a:	25250513          	add	a0,a0,594 # 6b78 <malloc+0x9bc>
    492e:	00001097          	auipc	ra,0x1
    4932:	7d6080e7          	jalr	2006(ra) # 6104 <printf>
    exit(1);
    4936:	4505                	li	a0,1
    4938:	00001097          	auipc	ra,0x1
    493c:	362080e7          	jalr	866(ra) # 5c9a <exit>
    a = sbrk(0);
    4940:	4501                	li	a0,0
    4942:	00001097          	auipc	ra,0x1
    4946:	3e0080e7          	jalr	992(ra) # 5d22 <sbrk>
    494a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    494c:	3e800537          	lui	a0,0x3e800
    4950:	00001097          	auipc	ra,0x1
    4954:	3d2080e7          	jalr	978(ra) # 5d22 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4958:	87ca                	mv	a5,s2
    495a:	3e800737          	lui	a4,0x3e800
    495e:	993a                	add	s2,s2,a4
    4960:	6705                	lui	a4,0x1
      n += *(a+i);
    4962:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4966:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4968:	97ba                	add	a5,a5,a4
    496a:	ff279ce3          	bne	a5,s2,4962 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    496e:	8626                	mv	a2,s1
    4970:	85d6                	mv	a1,s5
    4972:	00003517          	auipc	a0,0x3
    4976:	47e50513          	add	a0,a0,1150 # 7df0 <malloc+0x1c34>
    497a:	00001097          	auipc	ra,0x1
    497e:	78a080e7          	jalr	1930(ra) # 6104 <printf>
    exit(1);
    4982:	4505                	li	a0,1
    4984:	00001097          	auipc	ra,0x1
    4988:	316080e7          	jalr	790(ra) # 5c9a <exit>
    exit(1);
    498c:	4505                	li	a0,1
    498e:	00001097          	auipc	ra,0x1
    4992:	30c080e7          	jalr	780(ra) # 5c9a <exit>

0000000000004996 <mem>:
{
    4996:	7139                	add	sp,sp,-64
    4998:	fc06                	sd	ra,56(sp)
    499a:	f822                	sd	s0,48(sp)
    499c:	f426                	sd	s1,40(sp)
    499e:	f04a                	sd	s2,32(sp)
    49a0:	ec4e                	sd	s3,24(sp)
    49a2:	0080                	add	s0,sp,64
    49a4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49a6:	00001097          	auipc	ra,0x1
    49aa:	2ec080e7          	jalr	748(ra) # 5c92 <fork>
    m1 = 0;
    49ae:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49b0:	6909                	lui	s2,0x2
    49b2:	71190913          	add	s2,s2,1809 # 2711 <copyinstr3+0x149>
  if((pid = fork()) == 0){
    49b6:	c115                	beqz	a0,49da <mem+0x44>
    wait(&xstatus);
    49b8:	fcc40513          	add	a0,s0,-52
    49bc:	00001097          	auipc	ra,0x1
    49c0:	2e6080e7          	jalr	742(ra) # 5ca2 <wait>
    if(xstatus == -1){
    49c4:	fcc42503          	lw	a0,-52(s0)
    49c8:	57fd                	li	a5,-1
    49ca:	06f50363          	beq	a0,a5,4a30 <mem+0x9a>
    exit(xstatus);
    49ce:	00001097          	auipc	ra,0x1
    49d2:	2cc080e7          	jalr	716(ra) # 5c9a <exit>
      *(char**)m2 = m1;
    49d6:	e104                	sd	s1,0(a0)
      m1 = m2;
    49d8:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    49da:	854a                	mv	a0,s2
    49dc:	00001097          	auipc	ra,0x1
    49e0:	7e0080e7          	jalr	2016(ra) # 61bc <malloc>
    49e4:	f96d                	bnez	a0,49d6 <mem+0x40>
    while(m1){
    49e6:	c881                	beqz	s1,49f6 <mem+0x60>
      m2 = *(char**)m1;
    49e8:	8526                	mv	a0,s1
    49ea:	6084                	ld	s1,0(s1)
      free(m1);
    49ec:	00001097          	auipc	ra,0x1
    49f0:	74e080e7          	jalr	1870(ra) # 613a <free>
    while(m1){
    49f4:	f8f5                	bnez	s1,49e8 <mem+0x52>
    m1 = malloc(1024*20);
    49f6:	6515                	lui	a0,0x5
    49f8:	00001097          	auipc	ra,0x1
    49fc:	7c4080e7          	jalr	1988(ra) # 61bc <malloc>
    if(m1 == 0){
    4a00:	c911                	beqz	a0,4a14 <mem+0x7e>
    free(m1);
    4a02:	00001097          	auipc	ra,0x1
    4a06:	738080e7          	jalr	1848(ra) # 613a <free>
    exit(0);
    4a0a:	4501                	li	a0,0
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	28e080e7          	jalr	654(ra) # 5c9a <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    4a14:	85ce                	mv	a1,s3
    4a16:	00003517          	auipc	a0,0x3
    4a1a:	40a50513          	add	a0,a0,1034 # 7e20 <malloc+0x1c64>
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	6e6080e7          	jalr	1766(ra) # 6104 <printf>
      exit(1);
    4a26:	4505                	li	a0,1
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	272080e7          	jalr	626(ra) # 5c9a <exit>
      exit(0);
    4a30:	4501                	li	a0,0
    4a32:	00001097          	auipc	ra,0x1
    4a36:	268080e7          	jalr	616(ra) # 5c9a <exit>

0000000000004a3a <sharedfd>:
{
    4a3a:	7159                	add	sp,sp,-112
    4a3c:	f486                	sd	ra,104(sp)
    4a3e:	f0a2                	sd	s0,96(sp)
    4a40:	eca6                	sd	s1,88(sp)
    4a42:	e8ca                	sd	s2,80(sp)
    4a44:	e4ce                	sd	s3,72(sp)
    4a46:	e0d2                	sd	s4,64(sp)
    4a48:	fc56                	sd	s5,56(sp)
    4a4a:	f85a                	sd	s6,48(sp)
    4a4c:	f45e                	sd	s7,40(sp)
    4a4e:	1880                	add	s0,sp,112
    4a50:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a52:	00003517          	auipc	a0,0x3
    4a56:	3ee50513          	add	a0,a0,1006 # 7e40 <malloc+0x1c84>
    4a5a:	00001097          	auipc	ra,0x1
    4a5e:	290080e7          	jalr	656(ra) # 5cea <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a62:	20200593          	li	a1,514
    4a66:	00003517          	auipc	a0,0x3
    4a6a:	3da50513          	add	a0,a0,986 # 7e40 <malloc+0x1c84>
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	26c080e7          	jalr	620(ra) # 5cda <open>
  if(fd < 0){
    4a76:	04054a63          	bltz	a0,4aca <sharedfd+0x90>
    4a7a:	892a                	mv	s2,a0
  pid = fork();
    4a7c:	00001097          	auipc	ra,0x1
    4a80:	216080e7          	jalr	534(ra) # 5c92 <fork>
    4a84:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4a86:	07000593          	li	a1,112
    4a8a:	e119                	bnez	a0,4a90 <sharedfd+0x56>
    4a8c:	06300593          	li	a1,99
    4a90:	4629                	li	a2,10
    4a92:	fa040513          	add	a0,s0,-96
    4a96:	00001097          	auipc	ra,0x1
    4a9a:	00a080e7          	jalr	10(ra) # 5aa0 <memset>
    4a9e:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4aa2:	4629                	li	a2,10
    4aa4:	fa040593          	add	a1,s0,-96
    4aa8:	854a                	mv	a0,s2
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	210080e7          	jalr	528(ra) # 5cba <write>
    4ab2:	47a9                	li	a5,10
    4ab4:	02f51963          	bne	a0,a5,4ae6 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4ab8:	34fd                	addw	s1,s1,-1
    4aba:	f4e5                	bnez	s1,4aa2 <sharedfd+0x68>
  if(pid == 0) {
    4abc:	04099363          	bnez	s3,4b02 <sharedfd+0xc8>
    exit(0);
    4ac0:	4501                	li	a0,0
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	1d8080e7          	jalr	472(ra) # 5c9a <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4aca:	85d2                	mv	a1,s4
    4acc:	00003517          	auipc	a0,0x3
    4ad0:	38450513          	add	a0,a0,900 # 7e50 <malloc+0x1c94>
    4ad4:	00001097          	auipc	ra,0x1
    4ad8:	630080e7          	jalr	1584(ra) # 6104 <printf>
    exit(1);
    4adc:	4505                	li	a0,1
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	1bc080e7          	jalr	444(ra) # 5c9a <exit>
      printf("%s: write sharedfd failed\n", s);
    4ae6:	85d2                	mv	a1,s4
    4ae8:	00003517          	auipc	a0,0x3
    4aec:	39050513          	add	a0,a0,912 # 7e78 <malloc+0x1cbc>
    4af0:	00001097          	auipc	ra,0x1
    4af4:	614080e7          	jalr	1556(ra) # 6104 <printf>
      exit(1);
    4af8:	4505                	li	a0,1
    4afa:	00001097          	auipc	ra,0x1
    4afe:	1a0080e7          	jalr	416(ra) # 5c9a <exit>
    wait(&xstatus);
    4b02:	f9c40513          	add	a0,s0,-100
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	19c080e7          	jalr	412(ra) # 5ca2 <wait>
    if(xstatus != 0)
    4b0e:	f9c42983          	lw	s3,-100(s0)
    4b12:	00098763          	beqz	s3,4b20 <sharedfd+0xe6>
      exit(xstatus);
    4b16:	854e                	mv	a0,s3
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	182080e7          	jalr	386(ra) # 5c9a <exit>
  close(fd);
    4b20:	854a                	mv	a0,s2
    4b22:	00001097          	auipc	ra,0x1
    4b26:	1a0080e7          	jalr	416(ra) # 5cc2 <close>
  fd = open("sharedfd", 0);
    4b2a:	4581                	li	a1,0
    4b2c:	00003517          	auipc	a0,0x3
    4b30:	31450513          	add	a0,a0,788 # 7e40 <malloc+0x1c84>
    4b34:	00001097          	auipc	ra,0x1
    4b38:	1a6080e7          	jalr	422(ra) # 5cda <open>
    4b3c:	8baa                	mv	s7,a0
  nc = np = 0;
    4b3e:	8ace                	mv	s5,s3
  if(fd < 0){
    4b40:	02054563          	bltz	a0,4b6a <sharedfd+0x130>
    4b44:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4b48:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b4c:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b50:	4629                	li	a2,10
    4b52:	fa040593          	add	a1,s0,-96
    4b56:	855e                	mv	a0,s7
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	15a080e7          	jalr	346(ra) # 5cb2 <read>
    4b60:	02a05f63          	blez	a0,4b9e <sharedfd+0x164>
    4b64:	fa040793          	add	a5,s0,-96
    4b68:	a01d                	j	4b8e <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b6a:	85d2                	mv	a1,s4
    4b6c:	00003517          	auipc	a0,0x3
    4b70:	32c50513          	add	a0,a0,812 # 7e98 <malloc+0x1cdc>
    4b74:	00001097          	auipc	ra,0x1
    4b78:	590080e7          	jalr	1424(ra) # 6104 <printf>
    exit(1);
    4b7c:	4505                	li	a0,1
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	11c080e7          	jalr	284(ra) # 5c9a <exit>
        nc++;
    4b86:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4b88:	0785                	add	a5,a5,1
    4b8a:	fd2783e3          	beq	a5,s2,4b50 <sharedfd+0x116>
      if(buf[i] == 'c')
    4b8e:	0007c703          	lbu	a4,0(a5)
    4b92:	fe970ae3          	beq	a4,s1,4b86 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4b96:	ff6719e3          	bne	a4,s6,4b88 <sharedfd+0x14e>
        np++;
    4b9a:	2a85                	addw	s5,s5,1
    4b9c:	b7f5                	j	4b88 <sharedfd+0x14e>
  close(fd);
    4b9e:	855e                	mv	a0,s7
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	122080e7          	jalr	290(ra) # 5cc2 <close>
  unlink("sharedfd");
    4ba8:	00003517          	auipc	a0,0x3
    4bac:	29850513          	add	a0,a0,664 # 7e40 <malloc+0x1c84>
    4bb0:	00001097          	auipc	ra,0x1
    4bb4:	13a080e7          	jalr	314(ra) # 5cea <unlink>
  if(nc == N*SZ && np == N*SZ){
    4bb8:	6789                	lui	a5,0x2
    4bba:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0x148>
    4bbe:	00f99763          	bne	s3,a5,4bcc <sharedfd+0x192>
    4bc2:	6789                	lui	a5,0x2
    4bc4:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0x148>
    4bc8:	02fa8063          	beq	s5,a5,4be8 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4bcc:	85d2                	mv	a1,s4
    4bce:	00003517          	auipc	a0,0x3
    4bd2:	2f250513          	add	a0,a0,754 # 7ec0 <malloc+0x1d04>
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	52e080e7          	jalr	1326(ra) # 6104 <printf>
    exit(1);
    4bde:	4505                	li	a0,1
    4be0:	00001097          	auipc	ra,0x1
    4be4:	0ba080e7          	jalr	186(ra) # 5c9a <exit>
    exit(0);
    4be8:	4501                	li	a0,0
    4bea:	00001097          	auipc	ra,0x1
    4bee:	0b0080e7          	jalr	176(ra) # 5c9a <exit>

0000000000004bf2 <fourfiles>:
{
    4bf2:	7135                	add	sp,sp,-160
    4bf4:	ed06                	sd	ra,152(sp)
    4bf6:	e922                	sd	s0,144(sp)
    4bf8:	e526                	sd	s1,136(sp)
    4bfa:	e14a                	sd	s2,128(sp)
    4bfc:	fcce                	sd	s3,120(sp)
    4bfe:	f8d2                	sd	s4,112(sp)
    4c00:	f4d6                	sd	s5,104(sp)
    4c02:	f0da                	sd	s6,96(sp)
    4c04:	ecde                	sd	s7,88(sp)
    4c06:	e8e2                	sd	s8,80(sp)
    4c08:	e4e6                	sd	s9,72(sp)
    4c0a:	e0ea                	sd	s10,64(sp)
    4c0c:	fc6e                	sd	s11,56(sp)
    4c0e:	1100                	add	s0,sp,160
    4c10:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c12:	00003797          	auipc	a5,0x3
    4c16:	2c678793          	add	a5,a5,710 # 7ed8 <malloc+0x1d1c>
    4c1a:	f6f43823          	sd	a5,-144(s0)
    4c1e:	00003797          	auipc	a5,0x3
    4c22:	2c278793          	add	a5,a5,706 # 7ee0 <malloc+0x1d24>
    4c26:	f6f43c23          	sd	a5,-136(s0)
    4c2a:	00003797          	auipc	a5,0x3
    4c2e:	2be78793          	add	a5,a5,702 # 7ee8 <malloc+0x1d2c>
    4c32:	f8f43023          	sd	a5,-128(s0)
    4c36:	00003797          	auipc	a5,0x3
    4c3a:	2ba78793          	add	a5,a5,698 # 7ef0 <malloc+0x1d34>
    4c3e:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c42:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c46:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c48:	4481                	li	s1,0
    4c4a:	4a11                	li	s4,4
    fname = names[pi];
    4c4c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c50:	854e                	mv	a0,s3
    4c52:	00001097          	auipc	ra,0x1
    4c56:	098080e7          	jalr	152(ra) # 5cea <unlink>
    pid = fork();
    4c5a:	00001097          	auipc	ra,0x1
    4c5e:	038080e7          	jalr	56(ra) # 5c92 <fork>
    if(pid < 0){
    4c62:	04054063          	bltz	a0,4ca2 <fourfiles+0xb0>
    if(pid == 0){
    4c66:	cd21                	beqz	a0,4cbe <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4c68:	2485                	addw	s1,s1,1
    4c6a:	0921                	add	s2,s2,8
    4c6c:	ff4490e3          	bne	s1,s4,4c4c <fourfiles+0x5a>
    4c70:	4491                	li	s1,4
    wait(&xstatus);
    4c72:	f6c40513          	add	a0,s0,-148
    4c76:	00001097          	auipc	ra,0x1
    4c7a:	02c080e7          	jalr	44(ra) # 5ca2 <wait>
    if(xstatus != 0)
    4c7e:	f6c42a83          	lw	s5,-148(s0)
    4c82:	0c0a9863          	bnez	s5,4d52 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4c86:	34fd                	addw	s1,s1,-1
    4c88:	f4ed                	bnez	s1,4c72 <fourfiles+0x80>
    4c8a:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4c8e:	00008a17          	auipc	s4,0x8
    4c92:	feaa0a13          	add	s4,s4,-22 # cc78 <buf>
    if(total != N*SZ){
    4c96:	6d05                	lui	s10,0x1
    4c98:	770d0d13          	add	s10,s10,1904 # 1770 <truncate3+0x180>
  for(i = 0; i < NCHILD; i++){
    4c9c:	03400d93          	li	s11,52
    4ca0:	a22d                	j	4dca <fourfiles+0x1d8>
      printf("%s: fork failed\n", s);
    4ca2:	85e6                	mv	a1,s9
    4ca4:	00002517          	auipc	a0,0x2
    4ca8:	ed450513          	add	a0,a0,-300 # 6b78 <malloc+0x9bc>
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	458080e7          	jalr	1112(ra) # 6104 <printf>
      exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	fe4080e7          	jalr	-28(ra) # 5c9a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cbe:	20200593          	li	a1,514
    4cc2:	854e                	mv	a0,s3
    4cc4:	00001097          	auipc	ra,0x1
    4cc8:	016080e7          	jalr	22(ra) # 5cda <open>
    4ccc:	892a                	mv	s2,a0
      if(fd < 0){
    4cce:	04054763          	bltz	a0,4d1c <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4cd2:	1f400613          	li	a2,500
    4cd6:	0304859b          	addw	a1,s1,48
    4cda:	00008517          	auipc	a0,0x8
    4cde:	f9e50513          	add	a0,a0,-98 # cc78 <buf>
    4ce2:	00001097          	auipc	ra,0x1
    4ce6:	dbe080e7          	jalr	-578(ra) # 5aa0 <memset>
    4cea:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4cec:	00008997          	auipc	s3,0x8
    4cf0:	f8c98993          	add	s3,s3,-116 # cc78 <buf>
    4cf4:	1f400613          	li	a2,500
    4cf8:	85ce                	mv	a1,s3
    4cfa:	854a                	mv	a0,s2
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	fbe080e7          	jalr	-66(ra) # 5cba <write>
    4d04:	85aa                	mv	a1,a0
    4d06:	1f400793          	li	a5,500
    4d0a:	02f51763          	bne	a0,a5,4d38 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4d0e:	34fd                	addw	s1,s1,-1
    4d10:	f0f5                	bnez	s1,4cf4 <fourfiles+0x102>
      exit(0);
    4d12:	4501                	li	a0,0
    4d14:	00001097          	auipc	ra,0x1
    4d18:	f86080e7          	jalr	-122(ra) # 5c9a <exit>
        printf("%s: create failed\n", s);
    4d1c:	85e6                	mv	a1,s9
    4d1e:	00002517          	auipc	a0,0x2
    4d22:	ef250513          	add	a0,a0,-270 # 6c10 <malloc+0xa54>
    4d26:	00001097          	auipc	ra,0x1
    4d2a:	3de080e7          	jalr	990(ra) # 6104 <printf>
        exit(1);
    4d2e:	4505                	li	a0,1
    4d30:	00001097          	auipc	ra,0x1
    4d34:	f6a080e7          	jalr	-150(ra) # 5c9a <exit>
          printf("write failed %d\n", n);
    4d38:	00003517          	auipc	a0,0x3
    4d3c:	1c050513          	add	a0,a0,448 # 7ef8 <malloc+0x1d3c>
    4d40:	00001097          	auipc	ra,0x1
    4d44:	3c4080e7          	jalr	964(ra) # 6104 <printf>
          exit(1);
    4d48:	4505                	li	a0,1
    4d4a:	00001097          	auipc	ra,0x1
    4d4e:	f50080e7          	jalr	-176(ra) # 5c9a <exit>
      exit(xstatus);
    4d52:	8556                	mv	a0,s5
    4d54:	00001097          	auipc	ra,0x1
    4d58:	f46080e7          	jalr	-186(ra) # 5c9a <exit>
          printf("%s: wrong char\n", s);
    4d5c:	85e6                	mv	a1,s9
    4d5e:	00003517          	auipc	a0,0x3
    4d62:	1b250513          	add	a0,a0,434 # 7f10 <malloc+0x1d54>
    4d66:	00001097          	auipc	ra,0x1
    4d6a:	39e080e7          	jalr	926(ra) # 6104 <printf>
          exit(1);
    4d6e:	4505                	li	a0,1
    4d70:	00001097          	auipc	ra,0x1
    4d74:	f2a080e7          	jalr	-214(ra) # 5c9a <exit>
      total += n;
    4d78:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d7c:	660d                	lui	a2,0x3
    4d7e:	85d2                	mv	a1,s4
    4d80:	854e                	mv	a0,s3
    4d82:	00001097          	auipc	ra,0x1
    4d86:	f30080e7          	jalr	-208(ra) # 5cb2 <read>
    4d8a:	02a05063          	blez	a0,4daa <fourfiles+0x1b8>
    4d8e:	00008797          	auipc	a5,0x8
    4d92:	eea78793          	add	a5,a5,-278 # cc78 <buf>
    4d96:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4d9a:	0007c703          	lbu	a4,0(a5)
    4d9e:	fa971fe3          	bne	a4,s1,4d5c <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4da2:	0785                	add	a5,a5,1
    4da4:	fed79be3          	bne	a5,a3,4d9a <fourfiles+0x1a8>
    4da8:	bfc1                	j	4d78 <fourfiles+0x186>
    close(fd);
    4daa:	854e                	mv	a0,s3
    4dac:	00001097          	auipc	ra,0x1
    4db0:	f16080e7          	jalr	-234(ra) # 5cc2 <close>
    if(total != N*SZ){
    4db4:	03a91863          	bne	s2,s10,4de4 <fourfiles+0x1f2>
    unlink(fname);
    4db8:	8562                	mv	a0,s8
    4dba:	00001097          	auipc	ra,0x1
    4dbe:	f30080e7          	jalr	-208(ra) # 5cea <unlink>
  for(i = 0; i < NCHILD; i++){
    4dc2:	0ba1                	add	s7,s7,8
    4dc4:	2b05                	addw	s6,s6,1
    4dc6:	03bb0d63          	beq	s6,s11,4e00 <fourfiles+0x20e>
    fname = names[i];
    4dca:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4dce:	4581                	li	a1,0
    4dd0:	8562                	mv	a0,s8
    4dd2:	00001097          	auipc	ra,0x1
    4dd6:	f08080e7          	jalr	-248(ra) # 5cda <open>
    4dda:	89aa                	mv	s3,a0
    total = 0;
    4ddc:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4dde:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4de2:	bf69                	j	4d7c <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4de4:	85ca                	mv	a1,s2
    4de6:	00003517          	auipc	a0,0x3
    4dea:	13a50513          	add	a0,a0,314 # 7f20 <malloc+0x1d64>
    4dee:	00001097          	auipc	ra,0x1
    4df2:	316080e7          	jalr	790(ra) # 6104 <printf>
      exit(1);
    4df6:	4505                	li	a0,1
    4df8:	00001097          	auipc	ra,0x1
    4dfc:	ea2080e7          	jalr	-350(ra) # 5c9a <exit>
}
    4e00:	60ea                	ld	ra,152(sp)
    4e02:	644a                	ld	s0,144(sp)
    4e04:	64aa                	ld	s1,136(sp)
    4e06:	690a                	ld	s2,128(sp)
    4e08:	79e6                	ld	s3,120(sp)
    4e0a:	7a46                	ld	s4,112(sp)
    4e0c:	7aa6                	ld	s5,104(sp)
    4e0e:	7b06                	ld	s6,96(sp)
    4e10:	6be6                	ld	s7,88(sp)
    4e12:	6c46                	ld	s8,80(sp)
    4e14:	6ca6                	ld	s9,72(sp)
    4e16:	6d06                	ld	s10,64(sp)
    4e18:	7de2                	ld	s11,56(sp)
    4e1a:	610d                	add	sp,sp,160
    4e1c:	8082                	ret

0000000000004e1e <concreate>:
{
    4e1e:	7135                	add	sp,sp,-160
    4e20:	ed06                	sd	ra,152(sp)
    4e22:	e922                	sd	s0,144(sp)
    4e24:	e526                	sd	s1,136(sp)
    4e26:	e14a                	sd	s2,128(sp)
    4e28:	fcce                	sd	s3,120(sp)
    4e2a:	f8d2                	sd	s4,112(sp)
    4e2c:	f4d6                	sd	s5,104(sp)
    4e2e:	f0da                	sd	s6,96(sp)
    4e30:	ecde                	sd	s7,88(sp)
    4e32:	1100                	add	s0,sp,160
    4e34:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e36:	04300793          	li	a5,67
    4e3a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e3e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e42:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e44:	4b0d                	li	s6,3
    4e46:	4a85                	li	s5,1
      link("C0", file);
    4e48:	00003b97          	auipc	s7,0x3
    4e4c:	0f0b8b93          	add	s7,s7,240 # 7f38 <malloc+0x1d7c>
  for(i = 0; i < N; i++){
    4e50:	02800a13          	li	s4,40
    4e54:	acc9                	j	5126 <concreate+0x308>
      link("C0", file);
    4e56:	fa840593          	add	a1,s0,-88
    4e5a:	855e                	mv	a0,s7
    4e5c:	00001097          	auipc	ra,0x1
    4e60:	e9e080e7          	jalr	-354(ra) # 5cfa <link>
    if(pid == 0) {
    4e64:	a465                	j	510c <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4e66:	4795                	li	a5,5
    4e68:	02f9693b          	remw	s2,s2,a5
    4e6c:	4785                	li	a5,1
    4e6e:	02f90b63          	beq	s2,a5,4ea4 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4e72:	20200593          	li	a1,514
    4e76:	fa840513          	add	a0,s0,-88
    4e7a:	00001097          	auipc	ra,0x1
    4e7e:	e60080e7          	jalr	-416(ra) # 5cda <open>
      if(fd < 0){
    4e82:	26055c63          	bgez	a0,50fa <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4e86:	fa840593          	add	a1,s0,-88
    4e8a:	00003517          	auipc	a0,0x3
    4e8e:	0b650513          	add	a0,a0,182 # 7f40 <malloc+0x1d84>
    4e92:	00001097          	auipc	ra,0x1
    4e96:	272080e7          	jalr	626(ra) # 6104 <printf>
        exit(1);
    4e9a:	4505                	li	a0,1
    4e9c:	00001097          	auipc	ra,0x1
    4ea0:	dfe080e7          	jalr	-514(ra) # 5c9a <exit>
      link("C0", file);
    4ea4:	fa840593          	add	a1,s0,-88
    4ea8:	00003517          	auipc	a0,0x3
    4eac:	09050513          	add	a0,a0,144 # 7f38 <malloc+0x1d7c>
    4eb0:	00001097          	auipc	ra,0x1
    4eb4:	e4a080e7          	jalr	-438(ra) # 5cfa <link>
      exit(0);
    4eb8:	4501                	li	a0,0
    4eba:	00001097          	auipc	ra,0x1
    4ebe:	de0080e7          	jalr	-544(ra) # 5c9a <exit>
        exit(1);
    4ec2:	4505                	li	a0,1
    4ec4:	00001097          	auipc	ra,0x1
    4ec8:	dd6080e7          	jalr	-554(ra) # 5c9a <exit>
  memset(fa, 0, sizeof(fa));
    4ecc:	02800613          	li	a2,40
    4ed0:	4581                	li	a1,0
    4ed2:	f8040513          	add	a0,s0,-128
    4ed6:	00001097          	auipc	ra,0x1
    4eda:	bca080e7          	jalr	-1078(ra) # 5aa0 <memset>
  fd = open(".", 0);
    4ede:	4581                	li	a1,0
    4ee0:	00002517          	auipc	a0,0x2
    4ee4:	af050513          	add	a0,a0,-1296 # 69d0 <malloc+0x814>
    4ee8:	00001097          	auipc	ra,0x1
    4eec:	df2080e7          	jalr	-526(ra) # 5cda <open>
    4ef0:	892a                	mv	s2,a0
  n = 0;
    4ef2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4ef4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4ef8:	02700b13          	li	s6,39
      fa[i] = 1;
    4efc:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4efe:	4641                	li	a2,16
    4f00:	f7040593          	add	a1,s0,-144
    4f04:	854a                	mv	a0,s2
    4f06:	00001097          	auipc	ra,0x1
    4f0a:	dac080e7          	jalr	-596(ra) # 5cb2 <read>
    4f0e:	08a05263          	blez	a0,4f92 <concreate+0x174>
    if(de.inum == 0)
    4f12:	f7045783          	lhu	a5,-144(s0)
    4f16:	d7e5                	beqz	a5,4efe <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f18:	f7244783          	lbu	a5,-142(s0)
    4f1c:	ff4791e3          	bne	a5,s4,4efe <concreate+0xe0>
    4f20:	f7444783          	lbu	a5,-140(s0)
    4f24:	ffe9                	bnez	a5,4efe <concreate+0xe0>
      i = de.name[1] - '0';
    4f26:	f7344783          	lbu	a5,-141(s0)
    4f2a:	fd07879b          	addw	a5,a5,-48
    4f2e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f32:	02eb6063          	bltu	s6,a4,4f52 <concreate+0x134>
      if(fa[i]){
    4f36:	fb070793          	add	a5,a4,-80 # fb0 <linktest+0x54>
    4f3a:	97a2                	add	a5,a5,s0
    4f3c:	fd07c783          	lbu	a5,-48(a5)
    4f40:	eb8d                	bnez	a5,4f72 <concreate+0x154>
      fa[i] = 1;
    4f42:	fb070793          	add	a5,a4,-80
    4f46:	00878733          	add	a4,a5,s0
    4f4a:	fd770823          	sb	s7,-48(a4)
      n++;
    4f4e:	2a85                	addw	s5,s5,1
    4f50:	b77d                	j	4efe <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f52:	f7240613          	add	a2,s0,-142
    4f56:	85ce                	mv	a1,s3
    4f58:	00003517          	auipc	a0,0x3
    4f5c:	00850513          	add	a0,a0,8 # 7f60 <malloc+0x1da4>
    4f60:	00001097          	auipc	ra,0x1
    4f64:	1a4080e7          	jalr	420(ra) # 6104 <printf>
        exit(1);
    4f68:	4505                	li	a0,1
    4f6a:	00001097          	auipc	ra,0x1
    4f6e:	d30080e7          	jalr	-720(ra) # 5c9a <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4f72:	f7240613          	add	a2,s0,-142
    4f76:	85ce                	mv	a1,s3
    4f78:	00003517          	auipc	a0,0x3
    4f7c:	00850513          	add	a0,a0,8 # 7f80 <malloc+0x1dc4>
    4f80:	00001097          	auipc	ra,0x1
    4f84:	184080e7          	jalr	388(ra) # 6104 <printf>
        exit(1);
    4f88:	4505                	li	a0,1
    4f8a:	00001097          	auipc	ra,0x1
    4f8e:	d10080e7          	jalr	-752(ra) # 5c9a <exit>
  close(fd);
    4f92:	854a                	mv	a0,s2
    4f94:	00001097          	auipc	ra,0x1
    4f98:	d2e080e7          	jalr	-722(ra) # 5cc2 <close>
  if(n != N){
    4f9c:	02800793          	li	a5,40
    4fa0:	00fa9763          	bne	s5,a5,4fae <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4fa4:	4a8d                	li	s5,3
    4fa6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fa8:	02800a13          	li	s4,40
    4fac:	a8c9                	j	507e <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4fae:	85ce                	mv	a1,s3
    4fb0:	00003517          	auipc	a0,0x3
    4fb4:	ff850513          	add	a0,a0,-8 # 7fa8 <malloc+0x1dec>
    4fb8:	00001097          	auipc	ra,0x1
    4fbc:	14c080e7          	jalr	332(ra) # 6104 <printf>
    exit(1);
    4fc0:	4505                	li	a0,1
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	cd8080e7          	jalr	-808(ra) # 5c9a <exit>
      printf("%s: fork failed\n", s);
    4fca:	85ce                	mv	a1,s3
    4fcc:	00002517          	auipc	a0,0x2
    4fd0:	bac50513          	add	a0,a0,-1108 # 6b78 <malloc+0x9bc>
    4fd4:	00001097          	auipc	ra,0x1
    4fd8:	130080e7          	jalr	304(ra) # 6104 <printf>
      exit(1);
    4fdc:	4505                	li	a0,1
    4fde:	00001097          	auipc	ra,0x1
    4fe2:	cbc080e7          	jalr	-836(ra) # 5c9a <exit>
      close(open(file, 0));
    4fe6:	4581                	li	a1,0
    4fe8:	fa840513          	add	a0,s0,-88
    4fec:	00001097          	auipc	ra,0x1
    4ff0:	cee080e7          	jalr	-786(ra) # 5cda <open>
    4ff4:	00001097          	auipc	ra,0x1
    4ff8:	cce080e7          	jalr	-818(ra) # 5cc2 <close>
      close(open(file, 0));
    4ffc:	4581                	li	a1,0
    4ffe:	fa840513          	add	a0,s0,-88
    5002:	00001097          	auipc	ra,0x1
    5006:	cd8080e7          	jalr	-808(ra) # 5cda <open>
    500a:	00001097          	auipc	ra,0x1
    500e:	cb8080e7          	jalr	-840(ra) # 5cc2 <close>
      close(open(file, 0));
    5012:	4581                	li	a1,0
    5014:	fa840513          	add	a0,s0,-88
    5018:	00001097          	auipc	ra,0x1
    501c:	cc2080e7          	jalr	-830(ra) # 5cda <open>
    5020:	00001097          	auipc	ra,0x1
    5024:	ca2080e7          	jalr	-862(ra) # 5cc2 <close>
      close(open(file, 0));
    5028:	4581                	li	a1,0
    502a:	fa840513          	add	a0,s0,-88
    502e:	00001097          	auipc	ra,0x1
    5032:	cac080e7          	jalr	-852(ra) # 5cda <open>
    5036:	00001097          	auipc	ra,0x1
    503a:	c8c080e7          	jalr	-884(ra) # 5cc2 <close>
      close(open(file, 0));
    503e:	4581                	li	a1,0
    5040:	fa840513          	add	a0,s0,-88
    5044:	00001097          	auipc	ra,0x1
    5048:	c96080e7          	jalr	-874(ra) # 5cda <open>
    504c:	00001097          	auipc	ra,0x1
    5050:	c76080e7          	jalr	-906(ra) # 5cc2 <close>
      close(open(file, 0));
    5054:	4581                	li	a1,0
    5056:	fa840513          	add	a0,s0,-88
    505a:	00001097          	auipc	ra,0x1
    505e:	c80080e7          	jalr	-896(ra) # 5cda <open>
    5062:	00001097          	auipc	ra,0x1
    5066:	c60080e7          	jalr	-928(ra) # 5cc2 <close>
    if(pid == 0)
    506a:	08090363          	beqz	s2,50f0 <concreate+0x2d2>
      wait(0);
    506e:	4501                	li	a0,0
    5070:	00001097          	auipc	ra,0x1
    5074:	c32080e7          	jalr	-974(ra) # 5ca2 <wait>
  for(i = 0; i < N; i++){
    5078:	2485                	addw	s1,s1,1
    507a:	0f448563          	beq	s1,s4,5164 <concreate+0x346>
    file[1] = '0' + i;
    507e:	0304879b          	addw	a5,s1,48
    5082:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5086:	00001097          	auipc	ra,0x1
    508a:	c0c080e7          	jalr	-1012(ra) # 5c92 <fork>
    508e:	892a                	mv	s2,a0
    if(pid < 0){
    5090:	f2054de3          	bltz	a0,4fca <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    5094:	0354e73b          	remw	a4,s1,s5
    5098:	00a767b3          	or	a5,a4,a0
    509c:	2781                	sext.w	a5,a5
    509e:	d7a1                	beqz	a5,4fe6 <concreate+0x1c8>
    50a0:	01671363          	bne	a4,s6,50a6 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    50a4:	f129                	bnez	a0,4fe6 <concreate+0x1c8>
      unlink(file);
    50a6:	fa840513          	add	a0,s0,-88
    50aa:	00001097          	auipc	ra,0x1
    50ae:	c40080e7          	jalr	-960(ra) # 5cea <unlink>
      unlink(file);
    50b2:	fa840513          	add	a0,s0,-88
    50b6:	00001097          	auipc	ra,0x1
    50ba:	c34080e7          	jalr	-972(ra) # 5cea <unlink>
      unlink(file);
    50be:	fa840513          	add	a0,s0,-88
    50c2:	00001097          	auipc	ra,0x1
    50c6:	c28080e7          	jalr	-984(ra) # 5cea <unlink>
      unlink(file);
    50ca:	fa840513          	add	a0,s0,-88
    50ce:	00001097          	auipc	ra,0x1
    50d2:	c1c080e7          	jalr	-996(ra) # 5cea <unlink>
      unlink(file);
    50d6:	fa840513          	add	a0,s0,-88
    50da:	00001097          	auipc	ra,0x1
    50de:	c10080e7          	jalr	-1008(ra) # 5cea <unlink>
      unlink(file);
    50e2:	fa840513          	add	a0,s0,-88
    50e6:	00001097          	auipc	ra,0x1
    50ea:	c04080e7          	jalr	-1020(ra) # 5cea <unlink>
    50ee:	bfb5                	j	506a <concreate+0x24c>
      exit(0);
    50f0:	4501                	li	a0,0
    50f2:	00001097          	auipc	ra,0x1
    50f6:	ba8080e7          	jalr	-1112(ra) # 5c9a <exit>
      close(fd);
    50fa:	00001097          	auipc	ra,0x1
    50fe:	bc8080e7          	jalr	-1080(ra) # 5cc2 <close>
    if(pid == 0) {
    5102:	bb5d                	j	4eb8 <concreate+0x9a>
      close(fd);
    5104:	00001097          	auipc	ra,0x1
    5108:	bbe080e7          	jalr	-1090(ra) # 5cc2 <close>
      wait(&xstatus);
    510c:	f6c40513          	add	a0,s0,-148
    5110:	00001097          	auipc	ra,0x1
    5114:	b92080e7          	jalr	-1134(ra) # 5ca2 <wait>
      if(xstatus != 0)
    5118:	f6c42483          	lw	s1,-148(s0)
    511c:	da0493e3          	bnez	s1,4ec2 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5120:	2905                	addw	s2,s2,1
    5122:	db4905e3          	beq	s2,s4,4ecc <concreate+0xae>
    file[1] = '0' + i;
    5126:	0309079b          	addw	a5,s2,48
    512a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    512e:	fa840513          	add	a0,s0,-88
    5132:	00001097          	auipc	ra,0x1
    5136:	bb8080e7          	jalr	-1096(ra) # 5cea <unlink>
    pid = fork();
    513a:	00001097          	auipc	ra,0x1
    513e:	b58080e7          	jalr	-1192(ra) # 5c92 <fork>
    if(pid && (i % 3) == 1){
    5142:	d20502e3          	beqz	a0,4e66 <concreate+0x48>
    5146:	036967bb          	remw	a5,s2,s6
    514a:	d15786e3          	beq	a5,s5,4e56 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    514e:	20200593          	li	a1,514
    5152:	fa840513          	add	a0,s0,-88
    5156:	00001097          	auipc	ra,0x1
    515a:	b84080e7          	jalr	-1148(ra) # 5cda <open>
      if(fd < 0){
    515e:	fa0553e3          	bgez	a0,5104 <concreate+0x2e6>
    5162:	b315                	j	4e86 <concreate+0x68>
}
    5164:	60ea                	ld	ra,152(sp)
    5166:	644a                	ld	s0,144(sp)
    5168:	64aa                	ld	s1,136(sp)
    516a:	690a                	ld	s2,128(sp)
    516c:	79e6                	ld	s3,120(sp)
    516e:	7a46                	ld	s4,112(sp)
    5170:	7aa6                	ld	s5,104(sp)
    5172:	7b06                	ld	s6,96(sp)
    5174:	6be6                	ld	s7,88(sp)
    5176:	610d                	add	sp,sp,160
    5178:	8082                	ret

000000000000517a <bigfile>:
{
    517a:	7139                	add	sp,sp,-64
    517c:	fc06                	sd	ra,56(sp)
    517e:	f822                	sd	s0,48(sp)
    5180:	f426                	sd	s1,40(sp)
    5182:	f04a                	sd	s2,32(sp)
    5184:	ec4e                	sd	s3,24(sp)
    5186:	e852                	sd	s4,16(sp)
    5188:	e456                	sd	s5,8(sp)
    518a:	0080                	add	s0,sp,64
    518c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    518e:	00003517          	auipc	a0,0x3
    5192:	e5250513          	add	a0,a0,-430 # 7fe0 <malloc+0x1e24>
    5196:	00001097          	auipc	ra,0x1
    519a:	b54080e7          	jalr	-1196(ra) # 5cea <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    519e:	20200593          	li	a1,514
    51a2:	00003517          	auipc	a0,0x3
    51a6:	e3e50513          	add	a0,a0,-450 # 7fe0 <malloc+0x1e24>
    51aa:	00001097          	auipc	ra,0x1
    51ae:	b30080e7          	jalr	-1232(ra) # 5cda <open>
    51b2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51b4:	4481                	li	s1,0
    memset(buf, i, SZ);
    51b6:	00008917          	auipc	s2,0x8
    51ba:	ac290913          	add	s2,s2,-1342 # cc78 <buf>
  for(i = 0; i < N; i++){
    51be:	4a51                	li	s4,20
  if(fd < 0){
    51c0:	0a054063          	bltz	a0,5260 <bigfile+0xe6>
    memset(buf, i, SZ);
    51c4:	25800613          	li	a2,600
    51c8:	85a6                	mv	a1,s1
    51ca:	854a                	mv	a0,s2
    51cc:	00001097          	auipc	ra,0x1
    51d0:	8d4080e7          	jalr	-1836(ra) # 5aa0 <memset>
    if(write(fd, buf, SZ) != SZ){
    51d4:	25800613          	li	a2,600
    51d8:	85ca                	mv	a1,s2
    51da:	854e                	mv	a0,s3
    51dc:	00001097          	auipc	ra,0x1
    51e0:	ade080e7          	jalr	-1314(ra) # 5cba <write>
    51e4:	25800793          	li	a5,600
    51e8:	08f51a63          	bne	a0,a5,527c <bigfile+0x102>
  for(i = 0; i < N; i++){
    51ec:	2485                	addw	s1,s1,1
    51ee:	fd449be3          	bne	s1,s4,51c4 <bigfile+0x4a>
  close(fd);
    51f2:	854e                	mv	a0,s3
    51f4:	00001097          	auipc	ra,0x1
    51f8:	ace080e7          	jalr	-1330(ra) # 5cc2 <close>
  fd = open("bigfile.dat", 0);
    51fc:	4581                	li	a1,0
    51fe:	00003517          	auipc	a0,0x3
    5202:	de250513          	add	a0,a0,-542 # 7fe0 <malloc+0x1e24>
    5206:	00001097          	auipc	ra,0x1
    520a:	ad4080e7          	jalr	-1324(ra) # 5cda <open>
    520e:	8a2a                	mv	s4,a0
  total = 0;
    5210:	4981                	li	s3,0
  for(i = 0; ; i++){
    5212:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5214:	00008917          	auipc	s2,0x8
    5218:	a6490913          	add	s2,s2,-1436 # cc78 <buf>
  if(fd < 0){
    521c:	06054e63          	bltz	a0,5298 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5220:	12c00613          	li	a2,300
    5224:	85ca                	mv	a1,s2
    5226:	8552                	mv	a0,s4
    5228:	00001097          	auipc	ra,0x1
    522c:	a8a080e7          	jalr	-1398(ra) # 5cb2 <read>
    if(cc < 0){
    5230:	08054263          	bltz	a0,52b4 <bigfile+0x13a>
    if(cc == 0)
    5234:	c971                	beqz	a0,5308 <bigfile+0x18e>
    if(cc != SZ/2){
    5236:	12c00793          	li	a5,300
    523a:	08f51b63          	bne	a0,a5,52d0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    523e:	01f4d79b          	srlw	a5,s1,0x1f
    5242:	9fa5                	addw	a5,a5,s1
    5244:	4017d79b          	sraw	a5,a5,0x1
    5248:	00094703          	lbu	a4,0(s2)
    524c:	0af71063          	bne	a4,a5,52ec <bigfile+0x172>
    5250:	12b94703          	lbu	a4,299(s2)
    5254:	08f71c63          	bne	a4,a5,52ec <bigfile+0x172>
    total += cc;
    5258:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    525c:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    525e:	b7c9                	j	5220 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5260:	85d6                	mv	a1,s5
    5262:	00003517          	auipc	a0,0x3
    5266:	d8e50513          	add	a0,a0,-626 # 7ff0 <malloc+0x1e34>
    526a:	00001097          	auipc	ra,0x1
    526e:	e9a080e7          	jalr	-358(ra) # 6104 <printf>
    exit(1);
    5272:	4505                	li	a0,1
    5274:	00001097          	auipc	ra,0x1
    5278:	a26080e7          	jalr	-1498(ra) # 5c9a <exit>
      printf("%s: write bigfile failed\n", s);
    527c:	85d6                	mv	a1,s5
    527e:	00003517          	auipc	a0,0x3
    5282:	d9250513          	add	a0,a0,-622 # 8010 <malloc+0x1e54>
    5286:	00001097          	auipc	ra,0x1
    528a:	e7e080e7          	jalr	-386(ra) # 6104 <printf>
      exit(1);
    528e:	4505                	li	a0,1
    5290:	00001097          	auipc	ra,0x1
    5294:	a0a080e7          	jalr	-1526(ra) # 5c9a <exit>
    printf("%s: cannot open bigfile\n", s);
    5298:	85d6                	mv	a1,s5
    529a:	00003517          	auipc	a0,0x3
    529e:	d9650513          	add	a0,a0,-618 # 8030 <malloc+0x1e74>
    52a2:	00001097          	auipc	ra,0x1
    52a6:	e62080e7          	jalr	-414(ra) # 6104 <printf>
    exit(1);
    52aa:	4505                	li	a0,1
    52ac:	00001097          	auipc	ra,0x1
    52b0:	9ee080e7          	jalr	-1554(ra) # 5c9a <exit>
      printf("%s: read bigfile failed\n", s);
    52b4:	85d6                	mv	a1,s5
    52b6:	00003517          	auipc	a0,0x3
    52ba:	d9a50513          	add	a0,a0,-614 # 8050 <malloc+0x1e94>
    52be:	00001097          	auipc	ra,0x1
    52c2:	e46080e7          	jalr	-442(ra) # 6104 <printf>
      exit(1);
    52c6:	4505                	li	a0,1
    52c8:	00001097          	auipc	ra,0x1
    52cc:	9d2080e7          	jalr	-1582(ra) # 5c9a <exit>
      printf("%s: short read bigfile\n", s);
    52d0:	85d6                	mv	a1,s5
    52d2:	00003517          	auipc	a0,0x3
    52d6:	d9e50513          	add	a0,a0,-610 # 8070 <malloc+0x1eb4>
    52da:	00001097          	auipc	ra,0x1
    52de:	e2a080e7          	jalr	-470(ra) # 6104 <printf>
      exit(1);
    52e2:	4505                	li	a0,1
    52e4:	00001097          	auipc	ra,0x1
    52e8:	9b6080e7          	jalr	-1610(ra) # 5c9a <exit>
      printf("%s: read bigfile wrong data\n", s);
    52ec:	85d6                	mv	a1,s5
    52ee:	00003517          	auipc	a0,0x3
    52f2:	d9a50513          	add	a0,a0,-614 # 8088 <malloc+0x1ecc>
    52f6:	00001097          	auipc	ra,0x1
    52fa:	e0e080e7          	jalr	-498(ra) # 6104 <printf>
      exit(1);
    52fe:	4505                	li	a0,1
    5300:	00001097          	auipc	ra,0x1
    5304:	99a080e7          	jalr	-1638(ra) # 5c9a <exit>
  close(fd);
    5308:	8552                	mv	a0,s4
    530a:	00001097          	auipc	ra,0x1
    530e:	9b8080e7          	jalr	-1608(ra) # 5cc2 <close>
  if(total != N*SZ){
    5312:	678d                	lui	a5,0x3
    5314:	ee078793          	add	a5,a5,-288 # 2ee0 <sbrklast+0xd0>
    5318:	02f99363          	bne	s3,a5,533e <bigfile+0x1c4>
  unlink("bigfile.dat");
    531c:	00003517          	auipc	a0,0x3
    5320:	cc450513          	add	a0,a0,-828 # 7fe0 <malloc+0x1e24>
    5324:	00001097          	auipc	ra,0x1
    5328:	9c6080e7          	jalr	-1594(ra) # 5cea <unlink>
}
    532c:	70e2                	ld	ra,56(sp)
    532e:	7442                	ld	s0,48(sp)
    5330:	74a2                	ld	s1,40(sp)
    5332:	7902                	ld	s2,32(sp)
    5334:	69e2                	ld	s3,24(sp)
    5336:	6a42                	ld	s4,16(sp)
    5338:	6aa2                	ld	s5,8(sp)
    533a:	6121                	add	sp,sp,64
    533c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    533e:	85d6                	mv	a1,s5
    5340:	00003517          	auipc	a0,0x3
    5344:	d6850513          	add	a0,a0,-664 # 80a8 <malloc+0x1eec>
    5348:	00001097          	auipc	ra,0x1
    534c:	dbc080e7          	jalr	-580(ra) # 6104 <printf>
    exit(1);
    5350:	4505                	li	a0,1
    5352:	00001097          	auipc	ra,0x1
    5356:	948080e7          	jalr	-1720(ra) # 5c9a <exit>

000000000000535a <bigargtest>:
{
    535a:	7121                	add	sp,sp,-448
    535c:	ff06                	sd	ra,440(sp)
    535e:	fb22                	sd	s0,432(sp)
    5360:	f726                	sd	s1,424(sp)
    5362:	0380                	add	s0,sp,448
    5364:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    5366:	00003517          	auipc	a0,0x3
    536a:	d6250513          	add	a0,a0,-670 # 80c8 <malloc+0x1f0c>
    536e:	00001097          	auipc	ra,0x1
    5372:	97c080e7          	jalr	-1668(ra) # 5cea <unlink>
  pid = fork();
    5376:	00001097          	auipc	ra,0x1
    537a:	91c080e7          	jalr	-1764(ra) # 5c92 <fork>
  if(pid == 0){
    537e:	c121                	beqz	a0,53be <bigargtest+0x64>
  } else if(pid < 0){
    5380:	0a054a63          	bltz	a0,5434 <bigargtest+0xda>
  wait(&xstatus);
    5384:	fdc40513          	add	a0,s0,-36
    5388:	00001097          	auipc	ra,0x1
    538c:	91a080e7          	jalr	-1766(ra) # 5ca2 <wait>
  if(xstatus != 0)
    5390:	fdc42503          	lw	a0,-36(s0)
    5394:	ed55                	bnez	a0,5450 <bigargtest+0xf6>
  fd = open("bigarg-ok", 0);
    5396:	4581                	li	a1,0
    5398:	00003517          	auipc	a0,0x3
    539c:	d3050513          	add	a0,a0,-720 # 80c8 <malloc+0x1f0c>
    53a0:	00001097          	auipc	ra,0x1
    53a4:	93a080e7          	jalr	-1734(ra) # 5cda <open>
  if(fd < 0){
    53a8:	0a054863          	bltz	a0,5458 <bigargtest+0xfe>
  close(fd);
    53ac:	00001097          	auipc	ra,0x1
    53b0:	916080e7          	jalr	-1770(ra) # 5cc2 <close>
}
    53b4:	70fa                	ld	ra,440(sp)
    53b6:	745a                	ld	s0,432(sp)
    53b8:	74ba                	ld	s1,424(sp)
    53ba:	6139                	add	sp,sp,448
    53bc:	8082                	ret
    memset(big, ' ', sizeof(big));
    53be:	19000613          	li	a2,400
    53c2:	02000593          	li	a1,32
    53c6:	e4840513          	add	a0,s0,-440
    53ca:	00000097          	auipc	ra,0x0
    53ce:	6d6080e7          	jalr	1750(ra) # 5aa0 <memset>
    big[sizeof(big)-1] = '\0';
    53d2:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    53d6:	00004797          	auipc	a5,0x4
    53da:	08a78793          	add	a5,a5,138 # 9460 <args.1>
    53de:	00004697          	auipc	a3,0x4
    53e2:	17a68693          	add	a3,a3,378 # 9558 <args.1+0xf8>
      args[i] = big;
    53e6:	e4840713          	add	a4,s0,-440
    53ea:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    53ec:	07a1                	add	a5,a5,8
    53ee:	fed79ee3          	bne	a5,a3,53ea <bigargtest+0x90>
    args[MAXARG-1] = 0;
    53f2:	00004597          	auipc	a1,0x4
    53f6:	06e58593          	add	a1,a1,110 # 9460 <args.1>
    53fa:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    53fe:	00001517          	auipc	a0,0x1
    5402:	eea50513          	add	a0,a0,-278 # 62e8 <malloc+0x12c>
    5406:	00001097          	auipc	ra,0x1
    540a:	8cc080e7          	jalr	-1844(ra) # 5cd2 <exec>
    fd = open("bigarg-ok", O_CREATE);
    540e:	20000593          	li	a1,512
    5412:	00003517          	auipc	a0,0x3
    5416:	cb650513          	add	a0,a0,-842 # 80c8 <malloc+0x1f0c>
    541a:	00001097          	auipc	ra,0x1
    541e:	8c0080e7          	jalr	-1856(ra) # 5cda <open>
    close(fd);
    5422:	00001097          	auipc	ra,0x1
    5426:	8a0080e7          	jalr	-1888(ra) # 5cc2 <close>
    exit(0);
    542a:	4501                	li	a0,0
    542c:	00001097          	auipc	ra,0x1
    5430:	86e080e7          	jalr	-1938(ra) # 5c9a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    5434:	85a6                	mv	a1,s1
    5436:	00003517          	auipc	a0,0x3
    543a:	ca250513          	add	a0,a0,-862 # 80d8 <malloc+0x1f1c>
    543e:	00001097          	auipc	ra,0x1
    5442:	cc6080e7          	jalr	-826(ra) # 6104 <printf>
    exit(1);
    5446:	4505                	li	a0,1
    5448:	00001097          	auipc	ra,0x1
    544c:	852080e7          	jalr	-1966(ra) # 5c9a <exit>
    exit(xstatus);
    5450:	00001097          	auipc	ra,0x1
    5454:	84a080e7          	jalr	-1974(ra) # 5c9a <exit>
    printf("%s: bigarg test failed!\n", s);
    5458:	85a6                	mv	a1,s1
    545a:	00003517          	auipc	a0,0x3
    545e:	c9e50513          	add	a0,a0,-866 # 80f8 <malloc+0x1f3c>
    5462:	00001097          	auipc	ra,0x1
    5466:	ca2080e7          	jalr	-862(ra) # 6104 <printf>
    exit(1);
    546a:	4505                	li	a0,1
    546c:	00001097          	auipc	ra,0x1
    5470:	82e080e7          	jalr	-2002(ra) # 5c9a <exit>

0000000000005474 <fsfull>:
{
    5474:	7135                	add	sp,sp,-160
    5476:	ed06                	sd	ra,152(sp)
    5478:	e922                	sd	s0,144(sp)
    547a:	e526                	sd	s1,136(sp)
    547c:	e14a                	sd	s2,128(sp)
    547e:	fcce                	sd	s3,120(sp)
    5480:	f8d2                	sd	s4,112(sp)
    5482:	f4d6                	sd	s5,104(sp)
    5484:	f0da                	sd	s6,96(sp)
    5486:	ecde                	sd	s7,88(sp)
    5488:	e8e2                	sd	s8,80(sp)
    548a:	e4e6                	sd	s9,72(sp)
    548c:	e0ea                	sd	s10,64(sp)
    548e:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    5490:	00003517          	auipc	a0,0x3
    5494:	c8850513          	add	a0,a0,-888 # 8118 <malloc+0x1f5c>
    5498:	00001097          	auipc	ra,0x1
    549c:	c6c080e7          	jalr	-916(ra) # 6104 <printf>
  for(nfiles = 0; ; nfiles++){
    54a0:	4481                	li	s1,0
    name[0] = 'f';
    54a2:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    54a6:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    54aa:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    54ae:	4b29                	li	s6,10
    printf("writing %s\n", name);
    54b0:	00003c97          	auipc	s9,0x3
    54b4:	c78c8c93          	add	s9,s9,-904 # 8128 <malloc+0x1f6c>
    name[0] = 'f';
    54b8:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    54bc:	0384c7bb          	divw	a5,s1,s8
    54c0:	0307879b          	addw	a5,a5,48
    54c4:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54c8:	0384e7bb          	remw	a5,s1,s8
    54cc:	0377c7bb          	divw	a5,a5,s7
    54d0:	0307879b          	addw	a5,a5,48
    54d4:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54d8:	0374e7bb          	remw	a5,s1,s7
    54dc:	0367c7bb          	divw	a5,a5,s6
    54e0:	0307879b          	addw	a5,a5,48
    54e4:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    54e8:	0364e7bb          	remw	a5,s1,s6
    54ec:	0307879b          	addw	a5,a5,48
    54f0:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    54f4:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    54f8:	f6040593          	add	a1,s0,-160
    54fc:	8566                	mv	a0,s9
    54fe:	00001097          	auipc	ra,0x1
    5502:	c06080e7          	jalr	-1018(ra) # 6104 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5506:	20200593          	li	a1,514
    550a:	f6040513          	add	a0,s0,-160
    550e:	00000097          	auipc	ra,0x0
    5512:	7cc080e7          	jalr	1996(ra) # 5cda <open>
    5516:	892a                	mv	s2,a0
    if(fd < 0){
    5518:	0a055563          	bgez	a0,55c2 <fsfull+0x14e>
      printf("open %s failed\n", name);
    551c:	f6040593          	add	a1,s0,-160
    5520:	00003517          	auipc	a0,0x3
    5524:	c1850513          	add	a0,a0,-1000 # 8138 <malloc+0x1f7c>
    5528:	00001097          	auipc	ra,0x1
    552c:	bdc080e7          	jalr	-1060(ra) # 6104 <printf>
  while(nfiles >= 0){
    5530:	0604c363          	bltz	s1,5596 <fsfull+0x122>
    name[0] = 'f';
    5534:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5538:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    553c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5540:	4929                	li	s2,10
  while(nfiles >= 0){
    5542:	5afd                	li	s5,-1
    name[0] = 'f';
    5544:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5548:	0344c7bb          	divw	a5,s1,s4
    554c:	0307879b          	addw	a5,a5,48
    5550:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5554:	0344e7bb          	remw	a5,s1,s4
    5558:	0337c7bb          	divw	a5,a5,s3
    555c:	0307879b          	addw	a5,a5,48
    5560:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5564:	0334e7bb          	remw	a5,s1,s3
    5568:	0327c7bb          	divw	a5,a5,s2
    556c:	0307879b          	addw	a5,a5,48
    5570:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5574:	0324e7bb          	remw	a5,s1,s2
    5578:	0307879b          	addw	a5,a5,48
    557c:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5580:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    5584:	f6040513          	add	a0,s0,-160
    5588:	00000097          	auipc	ra,0x0
    558c:	762080e7          	jalr	1890(ra) # 5cea <unlink>
    nfiles--;
    5590:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    5592:	fb5499e3          	bne	s1,s5,5544 <fsfull+0xd0>
  printf("fsfull test finished\n");
    5596:	00003517          	auipc	a0,0x3
    559a:	bc250513          	add	a0,a0,-1086 # 8158 <malloc+0x1f9c>
    559e:	00001097          	auipc	ra,0x1
    55a2:	b66080e7          	jalr	-1178(ra) # 6104 <printf>
}
    55a6:	60ea                	ld	ra,152(sp)
    55a8:	644a                	ld	s0,144(sp)
    55aa:	64aa                	ld	s1,136(sp)
    55ac:	690a                	ld	s2,128(sp)
    55ae:	79e6                	ld	s3,120(sp)
    55b0:	7a46                	ld	s4,112(sp)
    55b2:	7aa6                	ld	s5,104(sp)
    55b4:	7b06                	ld	s6,96(sp)
    55b6:	6be6                	ld	s7,88(sp)
    55b8:	6c46                	ld	s8,80(sp)
    55ba:	6ca6                	ld	s9,72(sp)
    55bc:	6d06                	ld	s10,64(sp)
    55be:	610d                	add	sp,sp,160
    55c0:	8082                	ret
    int total = 0;
    55c2:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    55c4:	00007a97          	auipc	s5,0x7
    55c8:	6b4a8a93          	add	s5,s5,1716 # cc78 <buf>
      if(cc < BSIZE)
    55cc:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    55d0:	40000613          	li	a2,1024
    55d4:	85d6                	mv	a1,s5
    55d6:	854a                	mv	a0,s2
    55d8:	00000097          	auipc	ra,0x0
    55dc:	6e2080e7          	jalr	1762(ra) # 5cba <write>
      if(cc < BSIZE)
    55e0:	00aa5563          	bge	s4,a0,55ea <fsfull+0x176>
      total += cc;
    55e4:	00a989bb          	addw	s3,s3,a0
    while(1){
    55e8:	b7e5                	j	55d0 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    55ea:	85ce                	mv	a1,s3
    55ec:	00003517          	auipc	a0,0x3
    55f0:	b5c50513          	add	a0,a0,-1188 # 8148 <malloc+0x1f8c>
    55f4:	00001097          	auipc	ra,0x1
    55f8:	b10080e7          	jalr	-1264(ra) # 6104 <printf>
    close(fd);
    55fc:	854a                	mv	a0,s2
    55fe:	00000097          	auipc	ra,0x0
    5602:	6c4080e7          	jalr	1732(ra) # 5cc2 <close>
    if(total == 0)
    5606:	f20985e3          	beqz	s3,5530 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    560a:	2485                	addw	s1,s1,1
    560c:	b575                	j	54b8 <fsfull+0x44>

000000000000560e <run>:
/* */

/* run each test in its own process. run returns 1 if child's exit() */
/* indicates success. */
int
run(void f(char *), char *s) {
    560e:	7179                	add	sp,sp,-48
    5610:	f406                	sd	ra,40(sp)
    5612:	f022                	sd	s0,32(sp)
    5614:	ec26                	sd	s1,24(sp)
    5616:	e84a                	sd	s2,16(sp)
    5618:	1800                	add	s0,sp,48
    561a:	84aa                	mv	s1,a0
    561c:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    561e:	00003517          	auipc	a0,0x3
    5622:	b5250513          	add	a0,a0,-1198 # 8170 <malloc+0x1fb4>
    5626:	00001097          	auipc	ra,0x1
    562a:	ade080e7          	jalr	-1314(ra) # 6104 <printf>
  if((pid = fork()) < 0) {
    562e:	00000097          	auipc	ra,0x0
    5632:	664080e7          	jalr	1636(ra) # 5c92 <fork>
    5636:	02054e63          	bltz	a0,5672 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    563a:	c929                	beqz	a0,568c <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    563c:	fdc40513          	add	a0,s0,-36
    5640:	00000097          	auipc	ra,0x0
    5644:	662080e7          	jalr	1634(ra) # 5ca2 <wait>
    if(xstatus != 0) 
    5648:	fdc42783          	lw	a5,-36(s0)
    564c:	c7b9                	beqz	a5,569a <run+0x8c>
      printf("FAILED\n");
    564e:	00003517          	auipc	a0,0x3
    5652:	b4a50513          	add	a0,a0,-1206 # 8198 <malloc+0x1fdc>
    5656:	00001097          	auipc	ra,0x1
    565a:	aae080e7          	jalr	-1362(ra) # 6104 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    565e:	fdc42503          	lw	a0,-36(s0)
  }
}
    5662:	00153513          	seqz	a0,a0
    5666:	70a2                	ld	ra,40(sp)
    5668:	7402                	ld	s0,32(sp)
    566a:	64e2                	ld	s1,24(sp)
    566c:	6942                	ld	s2,16(sp)
    566e:	6145                	add	sp,sp,48
    5670:	8082                	ret
    printf("runtest: fork error\n");
    5672:	00003517          	auipc	a0,0x3
    5676:	b0e50513          	add	a0,a0,-1266 # 8180 <malloc+0x1fc4>
    567a:	00001097          	auipc	ra,0x1
    567e:	a8a080e7          	jalr	-1398(ra) # 6104 <printf>
    exit(1);
    5682:	4505                	li	a0,1
    5684:	00000097          	auipc	ra,0x0
    5688:	616080e7          	jalr	1558(ra) # 5c9a <exit>
    f(s);
    568c:	854a                	mv	a0,s2
    568e:	9482                	jalr	s1
    exit(0);
    5690:	4501                	li	a0,0
    5692:	00000097          	auipc	ra,0x0
    5696:	608080e7          	jalr	1544(ra) # 5c9a <exit>
      printf("OK\n");
    569a:	00003517          	auipc	a0,0x3
    569e:	b0650513          	add	a0,a0,-1274 # 81a0 <malloc+0x1fe4>
    56a2:	00001097          	auipc	ra,0x1
    56a6:	a62080e7          	jalr	-1438(ra) # 6104 <printf>
    56aa:	bf55                	j	565e <run+0x50>

00000000000056ac <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    56ac:	7139                	add	sp,sp,-64
    56ae:	fc06                	sd	ra,56(sp)
    56b0:	f822                	sd	s0,48(sp)
    56b2:	f426                	sd	s1,40(sp)
    56b4:	f04a                	sd	s2,32(sp)
    56b6:	ec4e                	sd	s3,24(sp)
    56b8:	e852                	sd	s4,16(sp)
    56ba:	e456                	sd	s5,8(sp)
    56bc:	0080                	add	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    56be:	00853903          	ld	s2,8(a0)
    56c2:	06090263          	beqz	s2,5726 <runtests+0x7a>
    56c6:	84aa                	mv	s1,a0
    56c8:	89ae                	mv	s3,a1
    56ca:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    56cc:	4a89                	li	s5,2
    56ce:	a031                	j	56da <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    56d0:	04c1                	add	s1,s1,16
    56d2:	0084b903          	ld	s2,8(s1)
    56d6:	02090e63          	beqz	s2,5712 <runtests+0x66>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    56da:	00098963          	beqz	s3,56ec <runtests+0x40>
    56de:	85ce                	mv	a1,s3
    56e0:	854a                	mv	a0,s2
    56e2:	00000097          	auipc	ra,0x0
    56e6:	368080e7          	jalr	872(ra) # 5a4a <strcmp>
    56ea:	f17d                	bnez	a0,56d0 <runtests+0x24>
      if(!run(t->f, t->s)){
    56ec:	85ca                	mv	a1,s2
    56ee:	6088                	ld	a0,0(s1)
    56f0:	00000097          	auipc	ra,0x0
    56f4:	f1e080e7          	jalr	-226(ra) # 560e <run>
    56f8:	fd61                	bnez	a0,56d0 <runtests+0x24>
        if(continuous != 2){
    56fa:	fd5a0be3          	beq	s4,s5,56d0 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    56fe:	00003517          	auipc	a0,0x3
    5702:	aaa50513          	add	a0,a0,-1366 # 81a8 <malloc+0x1fec>
    5706:	00001097          	auipc	ra,0x1
    570a:	9fe080e7          	jalr	-1538(ra) # 6104 <printf>
          return 1;
    570e:	4505                	li	a0,1
    5710:	a011                	j	5714 <runtests+0x68>
        }
      }
    }
  }
  return 0;
    5712:	4501                	li	a0,0
}
    5714:	70e2                	ld	ra,56(sp)
    5716:	7442                	ld	s0,48(sp)
    5718:	74a2                	ld	s1,40(sp)
    571a:	7902                	ld	s2,32(sp)
    571c:	69e2                	ld	s3,24(sp)
    571e:	6a42                	ld	s4,16(sp)
    5720:	6aa2                	ld	s5,8(sp)
    5722:	6121                	add	sp,sp,64
    5724:	8082                	ret
  return 0;
    5726:	4501                	li	a0,0
    5728:	b7f5                	j	5714 <runtests+0x68>

000000000000572a <countfree>:
/* because out of memory with lazy allocation results in the process */
/* taking a fault and being killed, fork and report back. */
/* */
int
countfree()
{
    572a:	7139                	add	sp,sp,-64
    572c:	fc06                	sd	ra,56(sp)
    572e:	f822                	sd	s0,48(sp)
    5730:	f426                	sd	s1,40(sp)
    5732:	f04a                	sd	s2,32(sp)
    5734:	ec4e                	sd	s3,24(sp)
    5736:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5738:	fc840513          	add	a0,s0,-56
    573c:	00000097          	auipc	ra,0x0
    5740:	56e080e7          	jalr	1390(ra) # 5caa <pipe>
    5744:	06054763          	bltz	a0,57b2 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5748:	00000097          	auipc	ra,0x0
    574c:	54a080e7          	jalr	1354(ra) # 5c92 <fork>

  if(pid < 0){
    5750:	06054e63          	bltz	a0,57cc <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5754:	ed51                	bnez	a0,57f0 <countfree+0xc6>
    close(fds[0]);
    5756:	fc842503          	lw	a0,-56(s0)
    575a:	00000097          	auipc	ra,0x0
    575e:	568080e7          	jalr	1384(ra) # 5cc2 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5762:	597d                	li	s2,-1
        break;
      }

      /* modify the memory to make sure it's really allocated. */
      *(char *)(a + 4096 - 1) = 1;
    5764:	4485                	li	s1,1

      /* report back one more page. */
      if(write(fds[1], "x", 1) != 1){
    5766:	00001997          	auipc	s3,0x1
    576a:	bf298993          	add	s3,s3,-1038 # 6358 <malloc+0x19c>
      uint64 a = (uint64) sbrk(4096);
    576e:	6505                	lui	a0,0x1
    5770:	00000097          	auipc	ra,0x0
    5774:	5b2080e7          	jalr	1458(ra) # 5d22 <sbrk>
      if(a == 0xffffffffffffffff){
    5778:	07250763          	beq	a0,s2,57e6 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    577c:	6785                	lui	a5,0x1
    577e:	97aa                	add	a5,a5,a0
    5780:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0xa3>
      if(write(fds[1], "x", 1) != 1){
    5784:	8626                	mv	a2,s1
    5786:	85ce                	mv	a1,s3
    5788:	fcc42503          	lw	a0,-52(s0)
    578c:	00000097          	auipc	ra,0x0
    5790:	52e080e7          	jalr	1326(ra) # 5cba <write>
    5794:	fc950de3          	beq	a0,s1,576e <countfree+0x44>
        printf("write() failed in countfree()\n");
    5798:	00003517          	auipc	a0,0x3
    579c:	a6850513          	add	a0,a0,-1432 # 8200 <malloc+0x2044>
    57a0:	00001097          	auipc	ra,0x1
    57a4:	964080e7          	jalr	-1692(ra) # 6104 <printf>
        exit(1);
    57a8:	4505                	li	a0,1
    57aa:	00000097          	auipc	ra,0x0
    57ae:	4f0080e7          	jalr	1264(ra) # 5c9a <exit>
    printf("pipe() failed in countfree()\n");
    57b2:	00003517          	auipc	a0,0x3
    57b6:	a0e50513          	add	a0,a0,-1522 # 81c0 <malloc+0x2004>
    57ba:	00001097          	auipc	ra,0x1
    57be:	94a080e7          	jalr	-1718(ra) # 6104 <printf>
    exit(1);
    57c2:	4505                	li	a0,1
    57c4:	00000097          	auipc	ra,0x0
    57c8:	4d6080e7          	jalr	1238(ra) # 5c9a <exit>
    printf("fork failed in countfree()\n");
    57cc:	00003517          	auipc	a0,0x3
    57d0:	a1450513          	add	a0,a0,-1516 # 81e0 <malloc+0x2024>
    57d4:	00001097          	auipc	ra,0x1
    57d8:	930080e7          	jalr	-1744(ra) # 6104 <printf>
    exit(1);
    57dc:	4505                	li	a0,1
    57de:	00000097          	auipc	ra,0x0
    57e2:	4bc080e7          	jalr	1212(ra) # 5c9a <exit>
      }
    }

    exit(0);
    57e6:	4501                	li	a0,0
    57e8:	00000097          	auipc	ra,0x0
    57ec:	4b2080e7          	jalr	1202(ra) # 5c9a <exit>
  }

  close(fds[1]);
    57f0:	fcc42503          	lw	a0,-52(s0)
    57f4:	00000097          	auipc	ra,0x0
    57f8:	4ce080e7          	jalr	1230(ra) # 5cc2 <close>

  int n = 0;
    57fc:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    57fe:	4605                	li	a2,1
    5800:	fc740593          	add	a1,s0,-57
    5804:	fc842503          	lw	a0,-56(s0)
    5808:	00000097          	auipc	ra,0x0
    580c:	4aa080e7          	jalr	1194(ra) # 5cb2 <read>
    if(cc < 0){
    5810:	00054563          	bltz	a0,581a <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5814:	c105                	beqz	a0,5834 <countfree+0x10a>
      break;
    n += 1;
    5816:	2485                	addw	s1,s1,1
  while(1){
    5818:	b7dd                	j	57fe <countfree+0xd4>
      printf("read() failed in countfree()\n");
    581a:	00003517          	auipc	a0,0x3
    581e:	a0650513          	add	a0,a0,-1530 # 8220 <malloc+0x2064>
    5822:	00001097          	auipc	ra,0x1
    5826:	8e2080e7          	jalr	-1822(ra) # 6104 <printf>
      exit(1);
    582a:	4505                	li	a0,1
    582c:	00000097          	auipc	ra,0x0
    5830:	46e080e7          	jalr	1134(ra) # 5c9a <exit>
  }

  close(fds[0]);
    5834:	fc842503          	lw	a0,-56(s0)
    5838:	00000097          	auipc	ra,0x0
    583c:	48a080e7          	jalr	1162(ra) # 5cc2 <close>
  wait((int*)0);
    5840:	4501                	li	a0,0
    5842:	00000097          	auipc	ra,0x0
    5846:	460080e7          	jalr	1120(ra) # 5ca2 <wait>
  
  return n;
}
    584a:	8526                	mv	a0,s1
    584c:	70e2                	ld	ra,56(sp)
    584e:	7442                	ld	s0,48(sp)
    5850:	74a2                	ld	s1,40(sp)
    5852:	7902                	ld	s2,32(sp)
    5854:	69e2                	ld	s3,24(sp)
    5856:	6121                	add	sp,sp,64
    5858:	8082                	ret

000000000000585a <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    585a:	711d                	add	sp,sp,-96
    585c:	ec86                	sd	ra,88(sp)
    585e:	e8a2                	sd	s0,80(sp)
    5860:	e4a6                	sd	s1,72(sp)
    5862:	e0ca                	sd	s2,64(sp)
    5864:	fc4e                	sd	s3,56(sp)
    5866:	f852                	sd	s4,48(sp)
    5868:	f456                	sd	s5,40(sp)
    586a:	f05a                	sd	s6,32(sp)
    586c:	ec5e                	sd	s7,24(sp)
    586e:	e862                	sd	s8,16(sp)
    5870:	e466                	sd	s9,8(sp)
    5872:	e06a                	sd	s10,0(sp)
    5874:	1080                	add	s0,sp,96
    5876:	8aaa                	mv	s5,a0
    5878:	892e                	mv	s2,a1
    587a:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    587c:	00003b97          	auipc	s7,0x3
    5880:	9c4b8b93          	add	s7,s7,-1596 # 8240 <malloc+0x2084>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    5884:	00003b17          	auipc	s6,0x3
    5888:	78cb0b13          	add	s6,s6,1932 # 9010 <quicktests>
      if(continuous != 2) {
    588c:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    588e:	00004c17          	auipc	s8,0x4
    5892:	b52c0c13          	add	s8,s8,-1198 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    5896:	00003d17          	auipc	s10,0x3
    589a:	9c2d0d13          	add	s10,s10,-1598 # 8258 <malloc+0x209c>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    589e:	00003c97          	auipc	s9,0x3
    58a2:	9dac8c93          	add	s9,s9,-1574 # 8278 <malloc+0x20bc>
    58a6:	a839                	j	58c4 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    58a8:	856a                	mv	a0,s10
    58aa:	00001097          	auipc	ra,0x1
    58ae:	85a080e7          	jalr	-1958(ra) # 6104 <printf>
    58b2:	a089                	j	58f4 <drivetests+0x9a>
    if((free1 = countfree()) < free0) {
    58b4:	00000097          	auipc	ra,0x0
    58b8:	e76080e7          	jalr	-394(ra) # 572a <countfree>
    58bc:	04954863          	blt	a0,s1,590c <drivetests+0xb2>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    58c0:	06090363          	beqz	s2,5926 <drivetests+0xcc>
    printf("usertests starting\n");
    58c4:	855e                	mv	a0,s7
    58c6:	00001097          	auipc	ra,0x1
    58ca:	83e080e7          	jalr	-1986(ra) # 6104 <printf>
    int free0 = countfree();
    58ce:	00000097          	auipc	ra,0x0
    58d2:	e5c080e7          	jalr	-420(ra) # 572a <countfree>
    58d6:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    58d8:	864a                	mv	a2,s2
    58da:	85ce                	mv	a1,s3
    58dc:	855a                	mv	a0,s6
    58de:	00000097          	auipc	ra,0x0
    58e2:	dce080e7          	jalr	-562(ra) # 56ac <runtests>
    58e6:	c119                	beqz	a0,58ec <drivetests+0x92>
      if(continuous != 2) {
    58e8:	03491d63          	bne	s2,s4,5922 <drivetests+0xc8>
    if(!quick) {
    58ec:	fc0a94e3          	bnez	s5,58b4 <drivetests+0x5a>
      if (justone == 0)
    58f0:	fa098ce3          	beqz	s3,58a8 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    58f4:	864a                	mv	a2,s2
    58f6:	85ce                	mv	a1,s3
    58f8:	8562                	mv	a0,s8
    58fa:	00000097          	auipc	ra,0x0
    58fe:	db2080e7          	jalr	-590(ra) # 56ac <runtests>
    5902:	d94d                	beqz	a0,58b4 <drivetests+0x5a>
        if(continuous != 2) {
    5904:	fb4908e3          	beq	s2,s4,58b4 <drivetests+0x5a>
          return 1;
    5908:	4505                	li	a0,1
    590a:	a839                	j	5928 <drivetests+0xce>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    590c:	8626                	mv	a2,s1
    590e:	85aa                	mv	a1,a0
    5910:	8566                	mv	a0,s9
    5912:	00000097          	auipc	ra,0x0
    5916:	7f2080e7          	jalr	2034(ra) # 6104 <printf>
      if(continuous != 2) {
    591a:	fb4905e3          	beq	s2,s4,58c4 <drivetests+0x6a>
        return 1;
    591e:	4505                	li	a0,1
    5920:	a021                	j	5928 <drivetests+0xce>
        return 1;
    5922:	4505                	li	a0,1
    5924:	a011                	j	5928 <drivetests+0xce>
  return 0;
    5926:	854a                	mv	a0,s2
}
    5928:	60e6                	ld	ra,88(sp)
    592a:	6446                	ld	s0,80(sp)
    592c:	64a6                	ld	s1,72(sp)
    592e:	6906                	ld	s2,64(sp)
    5930:	79e2                	ld	s3,56(sp)
    5932:	7a42                	ld	s4,48(sp)
    5934:	7aa2                	ld	s5,40(sp)
    5936:	7b02                	ld	s6,32(sp)
    5938:	6be2                	ld	s7,24(sp)
    593a:	6c42                	ld	s8,16(sp)
    593c:	6ca2                	ld	s9,8(sp)
    593e:	6d02                	ld	s10,0(sp)
    5940:	6125                	add	sp,sp,96
    5942:	8082                	ret

0000000000005944 <main>:

int
main(int argc, char *argv[])
{
    5944:	1101                	add	sp,sp,-32
    5946:	ec06                	sd	ra,24(sp)
    5948:	e822                	sd	s0,16(sp)
    594a:	e426                	sd	s1,8(sp)
    594c:	e04a                	sd	s2,0(sp)
    594e:	1000                	add	s0,sp,32
    5950:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5952:	4789                	li	a5,2
    5954:	02f50363          	beq	a0,a5,597a <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5958:	4785                	li	a5,1
    595a:	06a7ca63          	blt	a5,a0,59ce <main+0x8a>
  char *justone = 0;
    595e:	4901                	li	s2,0
  int quick = 0;
    5960:	4501                	li	a0,0
  int continuous = 0;
    5962:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5964:	864a                	mv	a2,s2
    5966:	00000097          	auipc	ra,0x0
    596a:	ef4080e7          	jalr	-268(ra) # 585a <drivetests>
    596e:	c551                	beqz	a0,59fa <main+0xb6>
    exit(1);
    5970:	4505                	li	a0,1
    5972:	00000097          	auipc	ra,0x0
    5976:	328080e7          	jalr	808(ra) # 5c9a <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    597a:	0085b903          	ld	s2,8(a1)
    597e:	00003597          	auipc	a1,0x3
    5982:	92a58593          	add	a1,a1,-1750 # 82a8 <malloc+0x20ec>
    5986:	854a                	mv	a0,s2
    5988:	00000097          	auipc	ra,0x0
    598c:	0c2080e7          	jalr	194(ra) # 5a4a <strcmp>
    5990:	85aa                	mv	a1,a0
    5992:	c939                	beqz	a0,59e8 <main+0xa4>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5994:	00003597          	auipc	a1,0x3
    5998:	91c58593          	add	a1,a1,-1764 # 82b0 <malloc+0x20f4>
    599c:	854a                	mv	a0,s2
    599e:	00000097          	auipc	ra,0x0
    59a2:	0ac080e7          	jalr	172(ra) # 5a4a <strcmp>
    59a6:	c521                	beqz	a0,59ee <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    59a8:	00003597          	auipc	a1,0x3
    59ac:	91058593          	add	a1,a1,-1776 # 82b8 <malloc+0x20fc>
    59b0:	854a                	mv	a0,s2
    59b2:	00000097          	auipc	ra,0x0
    59b6:	098080e7          	jalr	152(ra) # 5a4a <strcmp>
    59ba:	cd0d                	beqz	a0,59f4 <main+0xb0>
  } else if(argc == 2 && argv[1][0] != '-'){
    59bc:	00094703          	lbu	a4,0(s2)
    59c0:	02d00793          	li	a5,45
    59c4:	00f70563          	beq	a4,a5,59ce <main+0x8a>
  int quick = 0;
    59c8:	4501                	li	a0,0
  int continuous = 0;
    59ca:	4581                	li	a1,0
    59cc:	bf61                	j	5964 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    59ce:	00003517          	auipc	a0,0x3
    59d2:	8f250513          	add	a0,a0,-1806 # 82c0 <malloc+0x2104>
    59d6:	00000097          	auipc	ra,0x0
    59da:	72e080e7          	jalr	1838(ra) # 6104 <printf>
    exit(1);
    59de:	4505                	li	a0,1
    59e0:	00000097          	auipc	ra,0x0
    59e4:	2ba080e7          	jalr	698(ra) # 5c9a <exit>
  char *justone = 0;
    59e8:	4901                	li	s2,0
    quick = 1;
    59ea:	4505                	li	a0,1
    59ec:	bfa5                	j	5964 <main+0x20>
  char *justone = 0;
    59ee:	4901                	li	s2,0
    continuous = 1;
    59f0:	4585                	li	a1,1
    59f2:	bf8d                	j	5964 <main+0x20>
    continuous = 2;
    59f4:	85a6                	mv	a1,s1
  char *justone = 0;
    59f6:	4901                	li	s2,0
    59f8:	b7b5                	j	5964 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    59fa:	00003517          	auipc	a0,0x3
    59fe:	8f650513          	add	a0,a0,-1802 # 82f0 <malloc+0x2134>
    5a02:	00000097          	auipc	ra,0x0
    5a06:	702080e7          	jalr	1794(ra) # 6104 <printf>
  exit(0);
    5a0a:	4501                	li	a0,0
    5a0c:	00000097          	auipc	ra,0x0
    5a10:	28e080e7          	jalr	654(ra) # 5c9a <exit>

0000000000005a14 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
    5a14:	1141                	add	sp,sp,-16
    5a16:	e406                	sd	ra,8(sp)
    5a18:	e022                	sd	s0,0(sp)
    5a1a:	0800                	add	s0,sp,16
  extern int main();
  main();
    5a1c:	00000097          	auipc	ra,0x0
    5a20:	f28080e7          	jalr	-216(ra) # 5944 <main>
  exit(0);
    5a24:	4501                	li	a0,0
    5a26:	00000097          	auipc	ra,0x0
    5a2a:	274080e7          	jalr	628(ra) # 5c9a <exit>

0000000000005a2e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5a2e:	1141                	add	sp,sp,-16
    5a30:	e422                	sd	s0,8(sp)
    5a32:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5a34:	87aa                	mv	a5,a0
    5a36:	0585                	add	a1,a1,1
    5a38:	0785                	add	a5,a5,1
    5a3a:	fff5c703          	lbu	a4,-1(a1)
    5a3e:	fee78fa3          	sb	a4,-1(a5)
    5a42:	fb75                	bnez	a4,5a36 <strcpy+0x8>
    ;
  return os;
}
    5a44:	6422                	ld	s0,8(sp)
    5a46:	0141                	add	sp,sp,16
    5a48:	8082                	ret

0000000000005a4a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5a4a:	1141                	add	sp,sp,-16
    5a4c:	e422                	sd	s0,8(sp)
    5a4e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    5a50:	00054783          	lbu	a5,0(a0)
    5a54:	cb91                	beqz	a5,5a68 <strcmp+0x1e>
    5a56:	0005c703          	lbu	a4,0(a1)
    5a5a:	00f71763          	bne	a4,a5,5a68 <strcmp+0x1e>
    p++, q++;
    5a5e:	0505                	add	a0,a0,1
    5a60:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    5a62:	00054783          	lbu	a5,0(a0)
    5a66:	fbe5                	bnez	a5,5a56 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5a68:	0005c503          	lbu	a0,0(a1)
}
    5a6c:	40a7853b          	subw	a0,a5,a0
    5a70:	6422                	ld	s0,8(sp)
    5a72:	0141                	add	sp,sp,16
    5a74:	8082                	ret

0000000000005a76 <strlen>:

uint
strlen(const char *s)
{
    5a76:	1141                	add	sp,sp,-16
    5a78:	e422                	sd	s0,8(sp)
    5a7a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5a7c:	00054783          	lbu	a5,0(a0)
    5a80:	cf91                	beqz	a5,5a9c <strlen+0x26>
    5a82:	0505                	add	a0,a0,1
    5a84:	87aa                	mv	a5,a0
    5a86:	86be                	mv	a3,a5
    5a88:	0785                	add	a5,a5,1
    5a8a:	fff7c703          	lbu	a4,-1(a5)
    5a8e:	ff65                	bnez	a4,5a86 <strlen+0x10>
    5a90:	40a6853b          	subw	a0,a3,a0
    5a94:	2505                	addw	a0,a0,1
    ;
  return n;
}
    5a96:	6422                	ld	s0,8(sp)
    5a98:	0141                	add	sp,sp,16
    5a9a:	8082                	ret
  for(n = 0; s[n]; n++)
    5a9c:	4501                	li	a0,0
    5a9e:	bfe5                	j	5a96 <strlen+0x20>

0000000000005aa0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5aa0:	1141                	add	sp,sp,-16
    5aa2:	e422                	sd	s0,8(sp)
    5aa4:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5aa6:	ca19                	beqz	a2,5abc <memset+0x1c>
    5aa8:	87aa                	mv	a5,a0
    5aaa:	1602                	sll	a2,a2,0x20
    5aac:	9201                	srl	a2,a2,0x20
    5aae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5ab2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5ab6:	0785                	add	a5,a5,1
    5ab8:	fee79de3          	bne	a5,a4,5ab2 <memset+0x12>
  }
  return dst;
}
    5abc:	6422                	ld	s0,8(sp)
    5abe:	0141                	add	sp,sp,16
    5ac0:	8082                	ret

0000000000005ac2 <strchr>:

char*
strchr(const char *s, char c)
{
    5ac2:	1141                	add	sp,sp,-16
    5ac4:	e422                	sd	s0,8(sp)
    5ac6:	0800                	add	s0,sp,16
  for(; *s; s++)
    5ac8:	00054783          	lbu	a5,0(a0)
    5acc:	cb99                	beqz	a5,5ae2 <strchr+0x20>
    if(*s == c)
    5ace:	00f58763          	beq	a1,a5,5adc <strchr+0x1a>
  for(; *s; s++)
    5ad2:	0505                	add	a0,a0,1
    5ad4:	00054783          	lbu	a5,0(a0)
    5ad8:	fbfd                	bnez	a5,5ace <strchr+0xc>
      return (char*)s;
  return 0;
    5ada:	4501                	li	a0,0
}
    5adc:	6422                	ld	s0,8(sp)
    5ade:	0141                	add	sp,sp,16
    5ae0:	8082                	ret
  return 0;
    5ae2:	4501                	li	a0,0
    5ae4:	bfe5                	j	5adc <strchr+0x1a>

0000000000005ae6 <gets>:

char*
gets(char *buf, int max)
{
    5ae6:	711d                	add	sp,sp,-96
    5ae8:	ec86                	sd	ra,88(sp)
    5aea:	e8a2                	sd	s0,80(sp)
    5aec:	e4a6                	sd	s1,72(sp)
    5aee:	e0ca                	sd	s2,64(sp)
    5af0:	fc4e                	sd	s3,56(sp)
    5af2:	f852                	sd	s4,48(sp)
    5af4:	f456                	sd	s5,40(sp)
    5af6:	f05a                	sd	s6,32(sp)
    5af8:	ec5e                	sd	s7,24(sp)
    5afa:	1080                	add	s0,sp,96
    5afc:	8baa                	mv	s7,a0
    5afe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5b00:	892a                	mv	s2,a0
    5b02:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5b04:	4aa9                	li	s5,10
    5b06:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5b08:	89a6                	mv	s3,s1
    5b0a:	2485                	addw	s1,s1,1
    5b0c:	0344d863          	bge	s1,s4,5b3c <gets+0x56>
    cc = read(0, &c, 1);
    5b10:	4605                	li	a2,1
    5b12:	faf40593          	add	a1,s0,-81
    5b16:	4501                	li	a0,0
    5b18:	00000097          	auipc	ra,0x0
    5b1c:	19a080e7          	jalr	410(ra) # 5cb2 <read>
    if(cc < 1)
    5b20:	00a05e63          	blez	a0,5b3c <gets+0x56>
    buf[i++] = c;
    5b24:	faf44783          	lbu	a5,-81(s0)
    5b28:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5b2c:	01578763          	beq	a5,s5,5b3a <gets+0x54>
    5b30:	0905                	add	s2,s2,1
    5b32:	fd679be3          	bne	a5,s6,5b08 <gets+0x22>
  for(i=0; i+1 < max; ){
    5b36:	89a6                	mv	s3,s1
    5b38:	a011                	j	5b3c <gets+0x56>
    5b3a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5b3c:	99de                	add	s3,s3,s7
    5b3e:	00098023          	sb	zero,0(s3)
  return buf;
}
    5b42:	855e                	mv	a0,s7
    5b44:	60e6                	ld	ra,88(sp)
    5b46:	6446                	ld	s0,80(sp)
    5b48:	64a6                	ld	s1,72(sp)
    5b4a:	6906                	ld	s2,64(sp)
    5b4c:	79e2                	ld	s3,56(sp)
    5b4e:	7a42                	ld	s4,48(sp)
    5b50:	7aa2                	ld	s5,40(sp)
    5b52:	7b02                	ld	s6,32(sp)
    5b54:	6be2                	ld	s7,24(sp)
    5b56:	6125                	add	sp,sp,96
    5b58:	8082                	ret

0000000000005b5a <stat>:

int
stat(const char *n, struct stat *st)
{
    5b5a:	1101                	add	sp,sp,-32
    5b5c:	ec06                	sd	ra,24(sp)
    5b5e:	e822                	sd	s0,16(sp)
    5b60:	e426                	sd	s1,8(sp)
    5b62:	e04a                	sd	s2,0(sp)
    5b64:	1000                	add	s0,sp,32
    5b66:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5b68:	4581                	li	a1,0
    5b6a:	00000097          	auipc	ra,0x0
    5b6e:	170080e7          	jalr	368(ra) # 5cda <open>
  if(fd < 0)
    5b72:	02054563          	bltz	a0,5b9c <stat+0x42>
    5b76:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5b78:	85ca                	mv	a1,s2
    5b7a:	00000097          	auipc	ra,0x0
    5b7e:	178080e7          	jalr	376(ra) # 5cf2 <fstat>
    5b82:	892a                	mv	s2,a0
  close(fd);
    5b84:	8526                	mv	a0,s1
    5b86:	00000097          	auipc	ra,0x0
    5b8a:	13c080e7          	jalr	316(ra) # 5cc2 <close>
  return r;
}
    5b8e:	854a                	mv	a0,s2
    5b90:	60e2                	ld	ra,24(sp)
    5b92:	6442                	ld	s0,16(sp)
    5b94:	64a2                	ld	s1,8(sp)
    5b96:	6902                	ld	s2,0(sp)
    5b98:	6105                	add	sp,sp,32
    5b9a:	8082                	ret
    return -1;
    5b9c:	597d                	li	s2,-1
    5b9e:	bfc5                	j	5b8e <stat+0x34>

0000000000005ba0 <atoi>:

int
atoi(const char *s)
{
    5ba0:	1141                	add	sp,sp,-16
    5ba2:	e422                	sd	s0,8(sp)
    5ba4:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ba6:	00054683          	lbu	a3,0(a0)
    5baa:	fd06879b          	addw	a5,a3,-48
    5bae:	0ff7f793          	zext.b	a5,a5
    5bb2:	4625                	li	a2,9
    5bb4:	02f66863          	bltu	a2,a5,5be4 <atoi+0x44>
    5bb8:	872a                	mv	a4,a0
  n = 0;
    5bba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5bbc:	0705                	add	a4,a4,1
    5bbe:	0025179b          	sllw	a5,a0,0x2
    5bc2:	9fa9                	addw	a5,a5,a0
    5bc4:	0017979b          	sllw	a5,a5,0x1
    5bc8:	9fb5                	addw	a5,a5,a3
    5bca:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5bce:	00074683          	lbu	a3,0(a4)
    5bd2:	fd06879b          	addw	a5,a3,-48
    5bd6:	0ff7f793          	zext.b	a5,a5
    5bda:	fef671e3          	bgeu	a2,a5,5bbc <atoi+0x1c>
  return n;
}
    5bde:	6422                	ld	s0,8(sp)
    5be0:	0141                	add	sp,sp,16
    5be2:	8082                	ret
  n = 0;
    5be4:	4501                	li	a0,0
    5be6:	bfe5                	j	5bde <atoi+0x3e>

0000000000005be8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5be8:	1141                	add	sp,sp,-16
    5bea:	e422                	sd	s0,8(sp)
    5bec:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5bee:	02b57463          	bgeu	a0,a1,5c16 <memmove+0x2e>
    while(n-- > 0)
    5bf2:	00c05f63          	blez	a2,5c10 <memmove+0x28>
    5bf6:	1602                	sll	a2,a2,0x20
    5bf8:	9201                	srl	a2,a2,0x20
    5bfa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5bfe:	872a                	mv	a4,a0
      *dst++ = *src++;
    5c00:	0585                	add	a1,a1,1
    5c02:	0705                	add	a4,a4,1
    5c04:	fff5c683          	lbu	a3,-1(a1)
    5c08:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5c0c:	fee79ae3          	bne	a5,a4,5c00 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5c10:	6422                	ld	s0,8(sp)
    5c12:	0141                	add	sp,sp,16
    5c14:	8082                	ret
    dst += n;
    5c16:	00c50733          	add	a4,a0,a2
    src += n;
    5c1a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5c1c:	fec05ae3          	blez	a2,5c10 <memmove+0x28>
    5c20:	fff6079b          	addw	a5,a2,-1 # 2fff <fourteen+0x23>
    5c24:	1782                	sll	a5,a5,0x20
    5c26:	9381                	srl	a5,a5,0x20
    5c28:	fff7c793          	not	a5,a5
    5c2c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5c2e:	15fd                	add	a1,a1,-1
    5c30:	177d                	add	a4,a4,-1
    5c32:	0005c683          	lbu	a3,0(a1)
    5c36:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5c3a:	fee79ae3          	bne	a5,a4,5c2e <memmove+0x46>
    5c3e:	bfc9                	j	5c10 <memmove+0x28>

0000000000005c40 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5c40:	1141                	add	sp,sp,-16
    5c42:	e422                	sd	s0,8(sp)
    5c44:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5c46:	ca05                	beqz	a2,5c76 <memcmp+0x36>
    5c48:	fff6069b          	addw	a3,a2,-1
    5c4c:	1682                	sll	a3,a3,0x20
    5c4e:	9281                	srl	a3,a3,0x20
    5c50:	0685                	add	a3,a3,1
    5c52:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5c54:	00054783          	lbu	a5,0(a0)
    5c58:	0005c703          	lbu	a4,0(a1)
    5c5c:	00e79863          	bne	a5,a4,5c6c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5c60:	0505                	add	a0,a0,1
    p2++;
    5c62:	0585                	add	a1,a1,1
  while (n-- > 0) {
    5c64:	fed518e3          	bne	a0,a3,5c54 <memcmp+0x14>
  }
  return 0;
    5c68:	4501                	li	a0,0
    5c6a:	a019                	j	5c70 <memcmp+0x30>
      return *p1 - *p2;
    5c6c:	40e7853b          	subw	a0,a5,a4
}
    5c70:	6422                	ld	s0,8(sp)
    5c72:	0141                	add	sp,sp,16
    5c74:	8082                	ret
  return 0;
    5c76:	4501                	li	a0,0
    5c78:	bfe5                	j	5c70 <memcmp+0x30>

0000000000005c7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5c7a:	1141                	add	sp,sp,-16
    5c7c:	e406                	sd	ra,8(sp)
    5c7e:	e022                	sd	s0,0(sp)
    5c80:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5c82:	00000097          	auipc	ra,0x0
    5c86:	f66080e7          	jalr	-154(ra) # 5be8 <memmove>
}
    5c8a:	60a2                	ld	ra,8(sp)
    5c8c:	6402                	ld	s0,0(sp)
    5c8e:	0141                	add	sp,sp,16
    5c90:	8082                	ret

0000000000005c92 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5c92:	4885                	li	a7,1
 ecall
    5c94:	00000073          	ecall
 ret
    5c98:	8082                	ret

0000000000005c9a <exit>:
.global exit
exit:
 li a7, SYS_exit
    5c9a:	4889                	li	a7,2
 ecall
    5c9c:	00000073          	ecall
 ret
    5ca0:	8082                	ret

0000000000005ca2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5ca2:	488d                	li	a7,3
 ecall
    5ca4:	00000073          	ecall
 ret
    5ca8:	8082                	ret

0000000000005caa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5caa:	4891                	li	a7,4
 ecall
    5cac:	00000073          	ecall
 ret
    5cb0:	8082                	ret

0000000000005cb2 <read>:
.global read
read:
 li a7, SYS_read
    5cb2:	4895                	li	a7,5
 ecall
    5cb4:	00000073          	ecall
 ret
    5cb8:	8082                	ret

0000000000005cba <write>:
.global write
write:
 li a7, SYS_write
    5cba:	48c1                	li	a7,16
 ecall
    5cbc:	00000073          	ecall
 ret
    5cc0:	8082                	ret

0000000000005cc2 <close>:
.global close
close:
 li a7, SYS_close
    5cc2:	48d5                	li	a7,21
 ecall
    5cc4:	00000073          	ecall
 ret
    5cc8:	8082                	ret

0000000000005cca <kill>:
.global kill
kill:
 li a7, SYS_kill
    5cca:	4899                	li	a7,6
 ecall
    5ccc:	00000073          	ecall
 ret
    5cd0:	8082                	ret

0000000000005cd2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5cd2:	489d                	li	a7,7
 ecall
    5cd4:	00000073          	ecall
 ret
    5cd8:	8082                	ret

0000000000005cda <open>:
.global open
open:
 li a7, SYS_open
    5cda:	48bd                	li	a7,15
 ecall
    5cdc:	00000073          	ecall
 ret
    5ce0:	8082                	ret

0000000000005ce2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5ce2:	48c5                	li	a7,17
 ecall
    5ce4:	00000073          	ecall
 ret
    5ce8:	8082                	ret

0000000000005cea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5cea:	48c9                	li	a7,18
 ecall
    5cec:	00000073          	ecall
 ret
    5cf0:	8082                	ret

0000000000005cf2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5cf2:	48a1                	li	a7,8
 ecall
    5cf4:	00000073          	ecall
 ret
    5cf8:	8082                	ret

0000000000005cfa <link>:
.global link
link:
 li a7, SYS_link
    5cfa:	48cd                	li	a7,19
 ecall
    5cfc:	00000073          	ecall
 ret
    5d00:	8082                	ret

0000000000005d02 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5d02:	48d1                	li	a7,20
 ecall
    5d04:	00000073          	ecall
 ret
    5d08:	8082                	ret

0000000000005d0a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5d0a:	48a5                	li	a7,9
 ecall
    5d0c:	00000073          	ecall
 ret
    5d10:	8082                	ret

0000000000005d12 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5d12:	48a9                	li	a7,10
 ecall
    5d14:	00000073          	ecall
 ret
    5d18:	8082                	ret

0000000000005d1a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5d1a:	48ad                	li	a7,11
 ecall
    5d1c:	00000073          	ecall
 ret
    5d20:	8082                	ret

0000000000005d22 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5d22:	48b1                	li	a7,12
 ecall
    5d24:	00000073          	ecall
 ret
    5d28:	8082                	ret

0000000000005d2a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5d2a:	48b5                	li	a7,13
 ecall
    5d2c:	00000073          	ecall
 ret
    5d30:	8082                	ret

0000000000005d32 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5d32:	48b9                	li	a7,14
 ecall
    5d34:	00000073          	ecall
 ret
    5d38:	8082                	ret

0000000000005d3a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5d3a:	1101                	add	sp,sp,-32
    5d3c:	ec06                	sd	ra,24(sp)
    5d3e:	e822                	sd	s0,16(sp)
    5d40:	1000                	add	s0,sp,32
    5d42:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5d46:	4605                	li	a2,1
    5d48:	fef40593          	add	a1,s0,-17
    5d4c:	00000097          	auipc	ra,0x0
    5d50:	f6e080e7          	jalr	-146(ra) # 5cba <write>
}
    5d54:	60e2                	ld	ra,24(sp)
    5d56:	6442                	ld	s0,16(sp)
    5d58:	6105                	add	sp,sp,32
    5d5a:	8082                	ret

0000000000005d5c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5d5c:	7139                	add	sp,sp,-64
    5d5e:	fc06                	sd	ra,56(sp)
    5d60:	f822                	sd	s0,48(sp)
    5d62:	f426                	sd	s1,40(sp)
    5d64:	f04a                	sd	s2,32(sp)
    5d66:	ec4e                	sd	s3,24(sp)
    5d68:	0080                	add	s0,sp,64
    5d6a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5d6c:	c299                	beqz	a3,5d72 <printint+0x16>
    5d6e:	0805c963          	bltz	a1,5e00 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5d72:	2581                	sext.w	a1,a1
  neg = 0;
    5d74:	4881                	li	a7,0
    5d76:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    5d7a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5d7c:	2601                	sext.w	a2,a2
    5d7e:	00003517          	auipc	a0,0x3
    5d82:	94250513          	add	a0,a0,-1726 # 86c0 <digits>
    5d86:	883a                	mv	a6,a4
    5d88:	2705                	addw	a4,a4,1
    5d8a:	02c5f7bb          	remuw	a5,a1,a2
    5d8e:	1782                	sll	a5,a5,0x20
    5d90:	9381                	srl	a5,a5,0x20
    5d92:	97aa                	add	a5,a5,a0
    5d94:	0007c783          	lbu	a5,0(a5)
    5d98:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5d9c:	0005879b          	sext.w	a5,a1
    5da0:	02c5d5bb          	divuw	a1,a1,a2
    5da4:	0685                	add	a3,a3,1
    5da6:	fec7f0e3          	bgeu	a5,a2,5d86 <printint+0x2a>
  if(neg)
    5daa:	00088c63          	beqz	a7,5dc2 <printint+0x66>
    buf[i++] = '-';
    5dae:	fd070793          	add	a5,a4,-48
    5db2:	00878733          	add	a4,a5,s0
    5db6:	02d00793          	li	a5,45
    5dba:	fef70823          	sb	a5,-16(a4)
    5dbe:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5dc2:	02e05863          	blez	a4,5df2 <printint+0x96>
    5dc6:	fc040793          	add	a5,s0,-64
    5dca:	00e78933          	add	s2,a5,a4
    5dce:	fff78993          	add	s3,a5,-1
    5dd2:	99ba                	add	s3,s3,a4
    5dd4:	377d                	addw	a4,a4,-1
    5dd6:	1702                	sll	a4,a4,0x20
    5dd8:	9301                	srl	a4,a4,0x20
    5dda:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5dde:	fff94583          	lbu	a1,-1(s2)
    5de2:	8526                	mv	a0,s1
    5de4:	00000097          	auipc	ra,0x0
    5de8:	f56080e7          	jalr	-170(ra) # 5d3a <putc>
  while(--i >= 0)
    5dec:	197d                	add	s2,s2,-1
    5dee:	ff3918e3          	bne	s2,s3,5dde <printint+0x82>
}
    5df2:	70e2                	ld	ra,56(sp)
    5df4:	7442                	ld	s0,48(sp)
    5df6:	74a2                	ld	s1,40(sp)
    5df8:	7902                	ld	s2,32(sp)
    5dfa:	69e2                	ld	s3,24(sp)
    5dfc:	6121                	add	sp,sp,64
    5dfe:	8082                	ret
    x = -xx;
    5e00:	40b005bb          	negw	a1,a1
    neg = 1;
    5e04:	4885                	li	a7,1
    x = -xx;
    5e06:	bf85                	j	5d76 <printint+0x1a>

0000000000005e08 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5e08:	711d                	add	sp,sp,-96
    5e0a:	ec86                	sd	ra,88(sp)
    5e0c:	e8a2                	sd	s0,80(sp)
    5e0e:	e4a6                	sd	s1,72(sp)
    5e10:	e0ca                	sd	s2,64(sp)
    5e12:	fc4e                	sd	s3,56(sp)
    5e14:	f852                	sd	s4,48(sp)
    5e16:	f456                	sd	s5,40(sp)
    5e18:	f05a                	sd	s6,32(sp)
    5e1a:	ec5e                	sd	s7,24(sp)
    5e1c:	e862                	sd	s8,16(sp)
    5e1e:	e466                	sd	s9,8(sp)
    5e20:	e06a                	sd	s10,0(sp)
    5e22:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5e24:	0005c903          	lbu	s2,0(a1)
    5e28:	28090963          	beqz	s2,60ba <vprintf+0x2b2>
    5e2c:	8b2a                	mv	s6,a0
    5e2e:	8a2e                	mv	s4,a1
    5e30:	8bb2                	mv	s7,a2
  state = 0;
    5e32:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    5e34:	4481                	li	s1,0
    5e36:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    5e38:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    5e3c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    5e40:	06c00c93          	li	s9,108
    5e44:	a015                	j	5e68 <vprintf+0x60>
        putc(fd, c0);
    5e46:	85ca                	mv	a1,s2
    5e48:	855a                	mv	a0,s6
    5e4a:	00000097          	auipc	ra,0x0
    5e4e:	ef0080e7          	jalr	-272(ra) # 5d3a <putc>
    5e52:	a019                	j	5e58 <vprintf+0x50>
    } else if(state == '%'){
    5e54:	03598263          	beq	s3,s5,5e78 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
    5e58:	2485                	addw	s1,s1,1
    5e5a:	8726                	mv	a4,s1
    5e5c:	009a07b3          	add	a5,s4,s1
    5e60:	0007c903          	lbu	s2,0(a5)
    5e64:	24090b63          	beqz	s2,60ba <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
    5e68:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5e6c:	fe0994e3          	bnez	s3,5e54 <vprintf+0x4c>
      if(c0 == '%'){
    5e70:	fd579be3          	bne	a5,s5,5e46 <vprintf+0x3e>
        state = '%';
    5e74:	89be                	mv	s3,a5
    5e76:	b7cd                	j	5e58 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
    5e78:	cbc9                	beqz	a5,5f0a <vprintf+0x102>
    5e7a:	00ea06b3          	add	a3,s4,a4
    5e7e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    5e82:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    5e84:	c681                	beqz	a3,5e8c <vprintf+0x84>
    5e86:	9752                	add	a4,a4,s4
    5e88:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    5e8c:	05878163          	beq	a5,s8,5ece <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
    5e90:	05978d63          	beq	a5,s9,5eea <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    5e94:	07500713          	li	a4,117
    5e98:	10e78163          	beq	a5,a4,5f9a <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    5e9c:	07800713          	li	a4,120
    5ea0:	14e78963          	beq	a5,a4,5ff2 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    5ea4:	07000713          	li	a4,112
    5ea8:	18e78263          	beq	a5,a4,602c <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    5eac:	07300713          	li	a4,115
    5eb0:	1ce78663          	beq	a5,a4,607c <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    5eb4:	02500713          	li	a4,37
    5eb8:	04e79963          	bne	a5,a4,5f0a <vprintf+0x102>
        putc(fd, '%');
    5ebc:	02500593          	li	a1,37
    5ec0:	855a                	mv	a0,s6
    5ec2:	00000097          	auipc	ra,0x0
    5ec6:	e78080e7          	jalr	-392(ra) # 5d3a <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    5eca:	4981                	li	s3,0
    5ecc:	b771                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
    5ece:	008b8913          	add	s2,s7,8
    5ed2:	4685                	li	a3,1
    5ed4:	4629                	li	a2,10
    5ed6:	000ba583          	lw	a1,0(s7)
    5eda:	855a                	mv	a0,s6
    5edc:	00000097          	auipc	ra,0x0
    5ee0:	e80080e7          	jalr	-384(ra) # 5d5c <printint>
    5ee4:	8bca                	mv	s7,s2
      state = 0;
    5ee6:	4981                	li	s3,0
    5ee8:	bf85                	j	5e58 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
    5eea:	06400793          	li	a5,100
    5eee:	02f68d63          	beq	a3,a5,5f28 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5ef2:	06c00793          	li	a5,108
    5ef6:	04f68863          	beq	a3,a5,5f46 <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
    5efa:	07500793          	li	a5,117
    5efe:	0af68c63          	beq	a3,a5,5fb6 <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
    5f02:	07800793          	li	a5,120
    5f06:	10f68463          	beq	a3,a5,600e <vprintf+0x206>
        putc(fd, '%');
    5f0a:	02500593          	li	a1,37
    5f0e:	855a                	mv	a0,s6
    5f10:	00000097          	auipc	ra,0x0
    5f14:	e2a080e7          	jalr	-470(ra) # 5d3a <putc>
        putc(fd, c0);
    5f18:	85ca                	mv	a1,s2
    5f1a:	855a                	mv	a0,s6
    5f1c:	00000097          	auipc	ra,0x0
    5f20:	e1e080e7          	jalr	-482(ra) # 5d3a <putc>
      state = 0;
    5f24:	4981                	li	s3,0
    5f26:	bf0d                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5f28:	008b8913          	add	s2,s7,8
    5f2c:	4685                	li	a3,1
    5f2e:	4629                	li	a2,10
    5f30:	000ba583          	lw	a1,0(s7)
    5f34:	855a                	mv	a0,s6
    5f36:	00000097          	auipc	ra,0x0
    5f3a:	e26080e7          	jalr	-474(ra) # 5d5c <printint>
        i += 1;
    5f3e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5f40:	8bca                	mv	s7,s2
      state = 0;
    5f42:	4981                	li	s3,0
        i += 1;
    5f44:	bf11                	j	5e58 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5f46:	06400793          	li	a5,100
    5f4a:	02f60963          	beq	a2,a5,5f7c <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    5f4e:	07500793          	li	a5,117
    5f52:	08f60163          	beq	a2,a5,5fd4 <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    5f56:	07800793          	li	a5,120
    5f5a:	faf618e3          	bne	a2,a5,5f0a <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5f5e:	008b8913          	add	s2,s7,8
    5f62:	4681                	li	a3,0
    5f64:	4641                	li	a2,16
    5f66:	000ba583          	lw	a1,0(s7)
    5f6a:	855a                	mv	a0,s6
    5f6c:	00000097          	auipc	ra,0x0
    5f70:	df0080e7          	jalr	-528(ra) # 5d5c <printint>
        i += 2;
    5f74:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5f76:	8bca                	mv	s7,s2
      state = 0;
    5f78:	4981                	li	s3,0
        i += 2;
    5f7a:	bdf9                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5f7c:	008b8913          	add	s2,s7,8
    5f80:	4685                	li	a3,1
    5f82:	4629                	li	a2,10
    5f84:	000ba583          	lw	a1,0(s7)
    5f88:	855a                	mv	a0,s6
    5f8a:	00000097          	auipc	ra,0x0
    5f8e:	dd2080e7          	jalr	-558(ra) # 5d5c <printint>
        i += 2;
    5f92:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5f94:	8bca                	mv	s7,s2
      state = 0;
    5f96:	4981                	li	s3,0
        i += 2;
    5f98:	b5c1                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
    5f9a:	008b8913          	add	s2,s7,8
    5f9e:	4681                	li	a3,0
    5fa0:	4629                	li	a2,10
    5fa2:	000ba583          	lw	a1,0(s7)
    5fa6:	855a                	mv	a0,s6
    5fa8:	00000097          	auipc	ra,0x0
    5fac:	db4080e7          	jalr	-588(ra) # 5d5c <printint>
    5fb0:	8bca                	mv	s7,s2
      state = 0;
    5fb2:	4981                	li	s3,0
    5fb4:	b555                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5fb6:	008b8913          	add	s2,s7,8
    5fba:	4681                	li	a3,0
    5fbc:	4629                	li	a2,10
    5fbe:	000ba583          	lw	a1,0(s7)
    5fc2:	855a                	mv	a0,s6
    5fc4:	00000097          	auipc	ra,0x0
    5fc8:	d98080e7          	jalr	-616(ra) # 5d5c <printint>
        i += 1;
    5fcc:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5fce:	8bca                	mv	s7,s2
      state = 0;
    5fd0:	4981                	li	s3,0
        i += 1;
    5fd2:	b559                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5fd4:	008b8913          	add	s2,s7,8
    5fd8:	4681                	li	a3,0
    5fda:	4629                	li	a2,10
    5fdc:	000ba583          	lw	a1,0(s7)
    5fe0:	855a                	mv	a0,s6
    5fe2:	00000097          	auipc	ra,0x0
    5fe6:	d7a080e7          	jalr	-646(ra) # 5d5c <printint>
        i += 2;
    5fea:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5fec:	8bca                	mv	s7,s2
      state = 0;
    5fee:	4981                	li	s3,0
        i += 2;
    5ff0:	b5a5                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
    5ff2:	008b8913          	add	s2,s7,8
    5ff6:	4681                	li	a3,0
    5ff8:	4641                	li	a2,16
    5ffa:	000ba583          	lw	a1,0(s7)
    5ffe:	855a                	mv	a0,s6
    6000:	00000097          	auipc	ra,0x0
    6004:	d5c080e7          	jalr	-676(ra) # 5d5c <printint>
    6008:	8bca                	mv	s7,s2
      state = 0;
    600a:	4981                	li	s3,0
    600c:	b5b1                	j	5e58 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
    600e:	008b8913          	add	s2,s7,8
    6012:	4681                	li	a3,0
    6014:	4641                	li	a2,16
    6016:	000ba583          	lw	a1,0(s7)
    601a:	855a                	mv	a0,s6
    601c:	00000097          	auipc	ra,0x0
    6020:	d40080e7          	jalr	-704(ra) # 5d5c <printint>
        i += 1;
    6024:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    6026:	8bca                	mv	s7,s2
      state = 0;
    6028:	4981                	li	s3,0
        i += 1;
    602a:	b53d                	j	5e58 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
    602c:	008b8d13          	add	s10,s7,8
    6030:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    6034:	03000593          	li	a1,48
    6038:	855a                	mv	a0,s6
    603a:	00000097          	auipc	ra,0x0
    603e:	d00080e7          	jalr	-768(ra) # 5d3a <putc>
  putc(fd, 'x');
    6042:	07800593          	li	a1,120
    6046:	855a                	mv	a0,s6
    6048:	00000097          	auipc	ra,0x0
    604c:	cf2080e7          	jalr	-782(ra) # 5d3a <putc>
    6050:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    6052:	00002b97          	auipc	s7,0x2
    6056:	66eb8b93          	add	s7,s7,1646 # 86c0 <digits>
    605a:	03c9d793          	srl	a5,s3,0x3c
    605e:	97de                	add	a5,a5,s7
    6060:	0007c583          	lbu	a1,0(a5)
    6064:	855a                	mv	a0,s6
    6066:	00000097          	auipc	ra,0x0
    606a:	cd4080e7          	jalr	-812(ra) # 5d3a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    606e:	0992                	sll	s3,s3,0x4
    6070:	397d                	addw	s2,s2,-1
    6072:	fe0914e3          	bnez	s2,605a <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
    6076:	8bea                	mv	s7,s10
      state = 0;
    6078:	4981                	li	s3,0
    607a:	bbf9                	j	5e58 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
    607c:	008b8993          	add	s3,s7,8
    6080:	000bb903          	ld	s2,0(s7)
    6084:	02090163          	beqz	s2,60a6 <vprintf+0x29e>
        for(; *s; s++)
    6088:	00094583          	lbu	a1,0(s2)
    608c:	c585                	beqz	a1,60b4 <vprintf+0x2ac>
          putc(fd, *s);
    608e:	855a                	mv	a0,s6
    6090:	00000097          	auipc	ra,0x0
    6094:	caa080e7          	jalr	-854(ra) # 5d3a <putc>
        for(; *s; s++)
    6098:	0905                	add	s2,s2,1
    609a:	00094583          	lbu	a1,0(s2)
    609e:	f9e5                	bnez	a1,608e <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
    60a0:	8bce                	mv	s7,s3
      state = 0;
    60a2:	4981                	li	s3,0
    60a4:	bb55                	j	5e58 <vprintf+0x50>
          s = "(null)";
    60a6:	00002917          	auipc	s2,0x2
    60aa:	61290913          	add	s2,s2,1554 # 86b8 <malloc+0x24fc>
        for(; *s; s++)
    60ae:	02800593          	li	a1,40
    60b2:	bff1                	j	608e <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
    60b4:	8bce                	mv	s7,s3
      state = 0;
    60b6:	4981                	li	s3,0
    60b8:	b345                	j	5e58 <vprintf+0x50>
    }
  }
}
    60ba:	60e6                	ld	ra,88(sp)
    60bc:	6446                	ld	s0,80(sp)
    60be:	64a6                	ld	s1,72(sp)
    60c0:	6906                	ld	s2,64(sp)
    60c2:	79e2                	ld	s3,56(sp)
    60c4:	7a42                	ld	s4,48(sp)
    60c6:	7aa2                	ld	s5,40(sp)
    60c8:	7b02                	ld	s6,32(sp)
    60ca:	6be2                	ld	s7,24(sp)
    60cc:	6c42                	ld	s8,16(sp)
    60ce:	6ca2                	ld	s9,8(sp)
    60d0:	6d02                	ld	s10,0(sp)
    60d2:	6125                	add	sp,sp,96
    60d4:	8082                	ret

00000000000060d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    60d6:	715d                	add	sp,sp,-80
    60d8:	ec06                	sd	ra,24(sp)
    60da:	e822                	sd	s0,16(sp)
    60dc:	1000                	add	s0,sp,32
    60de:	e010                	sd	a2,0(s0)
    60e0:	e414                	sd	a3,8(s0)
    60e2:	e818                	sd	a4,16(s0)
    60e4:	ec1c                	sd	a5,24(s0)
    60e6:	03043023          	sd	a6,32(s0)
    60ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    60ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    60f2:	8622                	mv	a2,s0
    60f4:	00000097          	auipc	ra,0x0
    60f8:	d14080e7          	jalr	-748(ra) # 5e08 <vprintf>
}
    60fc:	60e2                	ld	ra,24(sp)
    60fe:	6442                	ld	s0,16(sp)
    6100:	6161                	add	sp,sp,80
    6102:	8082                	ret

0000000000006104 <printf>:

void
printf(const char *fmt, ...)
{
    6104:	711d                	add	sp,sp,-96
    6106:	ec06                	sd	ra,24(sp)
    6108:	e822                	sd	s0,16(sp)
    610a:	1000                	add	s0,sp,32
    610c:	e40c                	sd	a1,8(s0)
    610e:	e810                	sd	a2,16(s0)
    6110:	ec14                	sd	a3,24(s0)
    6112:	f018                	sd	a4,32(s0)
    6114:	f41c                	sd	a5,40(s0)
    6116:	03043823          	sd	a6,48(s0)
    611a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    611e:	00840613          	add	a2,s0,8
    6122:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    6126:	85aa                	mv	a1,a0
    6128:	4505                	li	a0,1
    612a:	00000097          	auipc	ra,0x0
    612e:	cde080e7          	jalr	-802(ra) # 5e08 <vprintf>
}
    6132:	60e2                	ld	ra,24(sp)
    6134:	6442                	ld	s0,16(sp)
    6136:	6125                	add	sp,sp,96
    6138:	8082                	ret

000000000000613a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    613a:	1141                	add	sp,sp,-16
    613c:	e422                	sd	s0,8(sp)
    613e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6140:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6144:	00003797          	auipc	a5,0x3
    6148:	30c7b783          	ld	a5,780(a5) # 9450 <freep>
    614c:	a02d                	j	6176 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    614e:	4618                	lw	a4,8(a2)
    6150:	9f2d                	addw	a4,a4,a1
    6152:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    6156:	6398                	ld	a4,0(a5)
    6158:	6310                	ld	a2,0(a4)
    615a:	a83d                	j	6198 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    615c:	ff852703          	lw	a4,-8(a0)
    6160:	9f31                	addw	a4,a4,a2
    6162:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    6164:	ff053683          	ld	a3,-16(a0)
    6168:	a091                	j	61ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    616a:	6398                	ld	a4,0(a5)
    616c:	00e7e463          	bltu	a5,a4,6174 <free+0x3a>
    6170:	00e6ea63          	bltu	a3,a4,6184 <free+0x4a>
{
    6174:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6176:	fed7fae3          	bgeu	a5,a3,616a <free+0x30>
    617a:	6398                	ld	a4,0(a5)
    617c:	00e6e463          	bltu	a3,a4,6184 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6180:	fee7eae3          	bltu	a5,a4,6174 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    6184:	ff852583          	lw	a1,-8(a0)
    6188:	6390                	ld	a2,0(a5)
    618a:	02059813          	sll	a6,a1,0x20
    618e:	01c85713          	srl	a4,a6,0x1c
    6192:	9736                	add	a4,a4,a3
    6194:	fae60de3          	beq	a2,a4,614e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    6198:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    619c:	4790                	lw	a2,8(a5)
    619e:	02061593          	sll	a1,a2,0x20
    61a2:	01c5d713          	srl	a4,a1,0x1c
    61a6:	973e                	add	a4,a4,a5
    61a8:	fae68ae3          	beq	a3,a4,615c <free+0x22>
    p->s.ptr = bp->s.ptr;
    61ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    61ae:	00003717          	auipc	a4,0x3
    61b2:	2af73123          	sd	a5,674(a4) # 9450 <freep>
}
    61b6:	6422                	ld	s0,8(sp)
    61b8:	0141                	add	sp,sp,16
    61ba:	8082                	ret

00000000000061bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    61bc:	7139                	add	sp,sp,-64
    61be:	fc06                	sd	ra,56(sp)
    61c0:	f822                	sd	s0,48(sp)
    61c2:	f426                	sd	s1,40(sp)
    61c4:	f04a                	sd	s2,32(sp)
    61c6:	ec4e                	sd	s3,24(sp)
    61c8:	e852                	sd	s4,16(sp)
    61ca:	e456                	sd	s5,8(sp)
    61cc:	e05a                	sd	s6,0(sp)
    61ce:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    61d0:	02051493          	sll	s1,a0,0x20
    61d4:	9081                	srl	s1,s1,0x20
    61d6:	04bd                	add	s1,s1,15
    61d8:	8091                	srl	s1,s1,0x4
    61da:	0014899b          	addw	s3,s1,1
    61de:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    61e0:	00003517          	auipc	a0,0x3
    61e4:	27053503          	ld	a0,624(a0) # 9450 <freep>
    61e8:	c515                	beqz	a0,6214 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    61ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    61ec:	4798                	lw	a4,8(a5)
    61ee:	02977f63          	bgeu	a4,s1,622c <malloc+0x70>
  if(nu < 4096)
    61f2:	8a4e                	mv	s4,s3
    61f4:	0009871b          	sext.w	a4,s3
    61f8:	6685                	lui	a3,0x1
    61fa:	00d77363          	bgeu	a4,a3,6200 <malloc+0x44>
    61fe:	6a05                	lui	s4,0x1
    6200:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6204:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6208:	00003917          	auipc	s2,0x3
    620c:	24890913          	add	s2,s2,584 # 9450 <freep>
  if(p == (char*)-1)
    6210:	5afd                	li	s5,-1
    6212:	a895                	j	6286 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    6214:	0000a797          	auipc	a5,0xa
    6218:	a6478793          	add	a5,a5,-1436 # fc78 <base>
    621c:	00003717          	auipc	a4,0x3
    6220:	22f73a23          	sd	a5,564(a4) # 9450 <freep>
    6224:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6226:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    622a:	b7e1                	j	61f2 <malloc+0x36>
      if(p->s.size == nunits)
    622c:	02e48c63          	beq	s1,a4,6264 <malloc+0xa8>
        p->s.size -= nunits;
    6230:	4137073b          	subw	a4,a4,s3
    6234:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6236:	02071693          	sll	a3,a4,0x20
    623a:	01c6d713          	srl	a4,a3,0x1c
    623e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6240:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6244:	00003717          	auipc	a4,0x3
    6248:	20a73623          	sd	a0,524(a4) # 9450 <freep>
      return (void*)(p + 1);
    624c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6250:	70e2                	ld	ra,56(sp)
    6252:	7442                	ld	s0,48(sp)
    6254:	74a2                	ld	s1,40(sp)
    6256:	7902                	ld	s2,32(sp)
    6258:	69e2                	ld	s3,24(sp)
    625a:	6a42                	ld	s4,16(sp)
    625c:	6aa2                	ld	s5,8(sp)
    625e:	6b02                	ld	s6,0(sp)
    6260:	6121                	add	sp,sp,64
    6262:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    6264:	6398                	ld	a4,0(a5)
    6266:	e118                	sd	a4,0(a0)
    6268:	bff1                	j	6244 <malloc+0x88>
  hp->s.size = nu;
    626a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    626e:	0541                	add	a0,a0,16
    6270:	00000097          	auipc	ra,0x0
    6274:	eca080e7          	jalr	-310(ra) # 613a <free>
  return freep;
    6278:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    627c:	d971                	beqz	a0,6250 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    627e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6280:	4798                	lw	a4,8(a5)
    6282:	fa9775e3          	bgeu	a4,s1,622c <malloc+0x70>
    if(p == freep)
    6286:	00093703          	ld	a4,0(s2)
    628a:	853e                	mv	a0,a5
    628c:	fef719e3          	bne	a4,a5,627e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    6290:	8552                	mv	a0,s4
    6292:	00000097          	auipc	ra,0x0
    6296:	a90080e7          	jalr	-1392(ra) # 5d22 <sbrk>
  if(p == (char*)-1)
    629a:	fd5518e3          	bne	a0,s5,626a <malloc+0xae>
        return 0;
    629e:	4501                	li	a0,0
    62a0:	bf45                	j	6250 <malloc+0x94>
