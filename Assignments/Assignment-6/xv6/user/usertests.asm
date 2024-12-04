
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
       e:	00007797          	auipc	a5,0x7
      12:	34278793          	add	a5,a5,834 # 7350 <malloc+0x2472>
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
      46:	20b040ef          	jal	4a50 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	add	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	add	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	f5a50513          	add	a0,a0,-166 # 4fc0 <malloc+0xe2>
      6e:	5bd040ef          	jal	4e2a <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	19d040ef          	jal	4a10 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	4f078793          	add	a5,a5,1264 # 9568 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	bf868693          	add	a3,a3,-1032 # bc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	add	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	add	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	f4050513          	add	a0,a0,-192 # 4fe0 <malloc+0x102>
      a8:	583040ef          	jal	4e2a <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	163040ef          	jal	4a10 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	add	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	add	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	f3850513          	add	a0,a0,-200 # 4ff8 <malloc+0x11a>
      c8:	189040ef          	jal	4a50 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	169040ef          	jal	4a38 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	f4250513          	add	a0,a0,-190 # 5018 <malloc+0x13a>
      de:	173040ef          	jal	4a50 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	add	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	f0e50513          	add	a0,a0,-242 # 5000 <malloc+0x122>
      fa:	531040ef          	jal	4e2a <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	111040ef          	jal	4a10 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	f2250513          	add	a0,a0,-222 # 5028 <malloc+0x14a>
     10e:	51d040ef          	jal	4e2a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	0fd040ef          	jal	4a10 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	add	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	add	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	f2850513          	add	a0,a0,-216 # 5050 <malloc+0x172>
     130:	131040ef          	jal	4a60 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	f1850513          	add	a0,a0,-232 # 5050 <malloc+0x172>
     140:	111040ef          	jal	4a50 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	f1858593          	add	a1,a1,-232 # 5060 <malloc+0x182>
     150:	0e1040ef          	jal	4a30 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	ef850513          	add	a0,a0,-264 # 5050 <malloc+0x172>
     160:	0f1040ef          	jal	4a50 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	f0058593          	add	a1,a1,-256 # 5068 <malloc+0x18a>
     170:	8526                	mv	a0,s1
     172:	0bf040ef          	jal	4a30 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	ed450513          	add	a0,a0,-300 # 5050 <malloc+0x172>
     184:	0dd040ef          	jal	4a60 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	0af040ef          	jal	4a38 <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	0a9040ef          	jal	4a38 <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	add	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	eca50513          	add	a0,a0,-310 # 5070 <malloc+0x192>
     1ae:	47d040ef          	jal	4e2a <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	05d040ef          	jal	4a10 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	add	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	add	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	add	a0,s0,-40
     1e4:	06d040ef          	jal	4a50 <open>
    close(fd);
     1e8:	051040ef          	jal	4a38 <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	add	a0,s0,-40
     212:	04f040ef          	jal	4a60 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	add	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	add	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	add	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	e5450513          	add	a0,a0,-428 # 5098 <malloc+0x1ba>
     24c:	015040ef          	jal	4a60 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	e44a8a93          	add	s5,s5,-444 # 5098 <malloc+0x1ba>
      int cc = write(fd, buf, sz);
     25c:	0000ca17          	auipc	s4,0xc
     260:	a1ca0a13          	add	s4,s4,-1508 # bc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	add	s6,s6,457 # 31c9 <rmdot+0x4d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	7e0040ef          	jal	4a50 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	7b2040ef          	jal	4a30 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	7a2040ef          	jal	4a30 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	7a0040ef          	jal	4a38 <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	7c2040ef          	jal	4a60 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	add	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	de650513          	add	a0,a0,-538 # 50a8 <malloc+0x1ca>
     2ca:	361040ef          	jal	4e2a <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	740040ef          	jal	4a10 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	dec50513          	add	a0,a0,-532 # 50c8 <malloc+0x1ea>
     2e4:	347040ef          	jal	4e2a <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	726040ef          	jal	4a10 <exit>

00000000000002ee <badwrite>:
/* file is deleted? if the kernel has this bug, it will panic: balloc: */
/* out of blocks. assumed_free may need to be raised to be more than */
/* the number of free blocks. this test takes a long time. */
void
badwrite(char *s)
{
     2ee:	7179                	add	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	de250513          	add	a0,a0,-542 # 50e0 <malloc+0x202>
     306:	75a040ef          	jal	4a60 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	dd298993          	add	s3,s3,-558 # 50e0 <malloc+0x202>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	72e040ef          	jal	4a50 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	700040ef          	jal	4a30 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	702040ef          	jal	4a38 <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	724040ef          	jal	4a60 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	d9650513          	add	a0,a0,-618 # 50e0 <malloc+0x202>
     352:	6fe040ef          	jal	4a50 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	d0a58593          	add	a1,a1,-758 # 5068 <malloc+0x18a>
     366:	6ca040ef          	jal	4a30 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	d9050513          	add	a0,a0,-624 # 5100 <malloc+0x222>
     378:	2b3040ef          	jal	4e2a <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	692040ef          	jal	4a10 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	d6650513          	add	a0,a0,-666 # 50e8 <malloc+0x20a>
     38a:	2a1040ef          	jal	4e2a <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	680040ef          	jal	4a10 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	d5450513          	add	a0,a0,-684 # 50e8 <malloc+0x20a>
     39c:	28f040ef          	jal	4e2a <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	66e040ef          	jal	4a10 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	690040ef          	jal	4a38 <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	d3450513          	add	a0,a0,-716 # 50e0 <malloc+0x202>
     3b4:	6ac040ef          	jal	4a60 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	656040ef          	jal	4a10 <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	add	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraw	a4,s1,0x1f
     3e2:	01b7571b          	srlw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraw	a3,a5,0x5
     3ee:	0306869b          	addw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	and	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	add	a0,s0,-80
     40a:	656040ef          	jal	4a60 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	add	a0,s0,-80
     416:	63a040ef          	jal	4a50 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      /* failure is eventually expected. */
      break;
    }
    close(fd);
     41e:	61a040ef          	jal	4a38 <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraw	a4,s1,0x1f
     43e:	01b7571b          	srlw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraw	a3,a5,0x5
     44a:	0306869b          	addw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	and	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	add	a0,s0,-80
     466:	5fa040ef          	jal	4a60 <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	add	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	add	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	add	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	ec078793          	add	a5,a5,-320 # 7350 <malloc+0x2472>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	add	s2,s0,-104
     4ba:	fc040a93          	add	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	c52a0a13          	add	s4,s4,-942 # 5110 <malloc+0x232>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	580040ef          	jal	4a50 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	552040ef          	jal	4a30 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	550040ef          	jal	4a38 <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	572040ef          	jal	4a60 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	538040ef          	jal	4a30 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	add	a0,s0,-112
     504:	51c040ef          	jal	4a20 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	51c040ef          	jal	4a30 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	518040ef          	jal	4a38 <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	510040ef          	jal	4a38 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	add	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	add	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	bd450513          	add	a0,a0,-1068 # 5118 <malloc+0x23a>
     54c:	0df040ef          	jal	4e2a <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	4be040ef          	jal	4a10 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	bd650513          	add	a0,a0,-1066 # 5130 <malloc+0x252>
     562:	0c9040ef          	jal	4e2a <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	4a8040ef          	jal	4a10 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	bf050513          	add	a0,a0,-1040 # 5160 <malloc+0x282>
     578:	0b3040ef          	jal	4e2a <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	492040ef          	jal	4a10 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	c0e50513          	add	a0,a0,-1010 # 5190 <malloc+0x2b2>
     58a:	0a1040ef          	jal	4e2a <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	480040ef          	jal	4a10 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	c0850513          	add	a0,a0,-1016 # 51a0 <malloc+0x2c2>
     5a0:	08b040ef          	jal	4e2a <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	46a040ef          	jal	4a10 <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	add	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	add	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	d9278793          	add	a5,a5,-622 # 7350 <malloc+0x2472>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	add	s2,s0,-112
     5ee:	fc040b13          	add	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	bdea0a13          	add	s4,s4,-1058 # 51d0 <malloc+0x2f2>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	a6ea8a93          	add	s5,s5,-1426 # 5068 <malloc+0x18a>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	446040ef          	jal	4a50 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	410040ef          	jal	4a28 <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	416040ef          	jal	4a38 <close>
    if(pipe(fds) < 0){
     626:	f8840513          	add	a0,s0,-120
     62a:	3f6040ef          	jal	4a20 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	3f6040ef          	jal	4a30 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	3dc040ef          	jal	4a28 <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	3e0040ef          	jal	4a38 <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	3d8040ef          	jal	4a38 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	add	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	add	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	b5a50513          	add	a0,a0,-1190 # 51d8 <malloc+0x2fa>
     686:	7a4040ef          	jal	4e2a <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	384040ef          	jal	4a10 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	b5c50513          	add	a0,a0,-1188 # 51f0 <malloc+0x312>
     69c:	78e040ef          	jal	4e2a <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	36e040ef          	jal	4a10 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	aea50513          	add	a0,a0,-1302 # 5190 <malloc+0x2b2>
     6ae:	77c040ef          	jal	4e2a <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	35c040ef          	jal	4a10 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	b6850513          	add	a0,a0,-1176 # 5220 <malloc+0x342>
     6c0:	76a040ef          	jal	4e2a <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	34a040ef          	jal	4a10 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	b6a50513          	add	a0,a0,-1174 # 5238 <malloc+0x35a>
     6d6:	754040ef          	jal	4e2a <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	334040ef          	jal	4a10 <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	add	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	add	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	95c50513          	add	a0,a0,-1700 # 5050 <malloc+0x172>
     6fc:	364040ef          	jal	4a60 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	94c50513          	add	a0,a0,-1716 # 5050 <malloc+0x172>
     70c:	344040ef          	jal	4a50 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	94c58593          	add	a1,a1,-1716 # 5060 <malloc+0x182>
     71c:	314040ef          	jal	4a30 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	316040ef          	jal	4a38 <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	92850513          	add	a0,a0,-1752 # 5050 <malloc+0x172>
     730:	320040ef          	jal	4a50 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	add	a1,s0,-96
     73e:	2ea040ef          	jal	4a28 <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	90450513          	add	a0,a0,-1788 # 5050 <malloc+0x172>
     754:	2fc040ef          	jal	4a50 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	8f450513          	add	a0,a0,-1804 # 5050 <malloc+0x172>
     764:	2ec040ef          	jal	4a50 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	add	a1,s0,-96
     772:	2b6040ef          	jal	4a28 <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	add	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	2a4040ef          	jal	4a28 <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	b3a58593          	add	a1,a1,-1222 # 52c8 <malloc+0x3ea>
     796:	854e                	mv	a0,s3
     798:	298040ef          	jal	4a30 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	add	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	282040ef          	jal	4a28 <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	add	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	26e040ef          	jal	4a28 <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	88c50513          	add	a0,a0,-1908 # 5050 <malloc+0x172>
     7cc:	294040ef          	jal	4a60 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	266040ef          	jal	4a38 <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	260040ef          	jal	4a38 <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	25a040ef          	jal	4a38 <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	add	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	a7050513          	add	a0,a0,-1424 # 5268 <malloc+0x38a>
     800:	62a040ef          	jal	4e2a <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	20a040ef          	jal	4a10 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	a7c50513          	add	a0,a0,-1412 # 5288 <malloc+0x3aa>
     814:	616040ef          	jal	4e2a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	a7c50513          	add	a0,a0,-1412 # 5298 <malloc+0x3ba>
     824:	606040ef          	jal	4e2a <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	1e6040ef          	jal	4a10 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	a8850513          	add	a0,a0,-1400 # 52b8 <malloc+0x3da>
     838:	5f2040ef          	jal	4e2a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	a5850513          	add	a0,a0,-1448 # 5298 <malloc+0x3ba>
     848:	5e2040ef          	jal	4e2a <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	1c2040ef          	jal	4a10 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	a7a50513          	add	a0,a0,-1414 # 52d0 <malloc+0x3f2>
     85e:	5cc040ef          	jal	4e2a <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	1ac040ef          	jal	4a10 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	a8450513          	add	a0,a0,-1404 # 52f0 <malloc+0x412>
     874:	5b6040ef          	jal	4e2a <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	196040ef          	jal	4a10 <exit>

000000000000087e <writetest>:
{
     87e:	7139                	add	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	add	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	a7850513          	add	a0,a0,-1416 # 5310 <malloc+0x432>
     8a0:	1b0040ef          	jal	4a50 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	a8c98993          	add	s3,s3,-1396 # 5338 <malloc+0x45a>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	abca8a93          	add	s5,s5,-1348 # 5370 <malloc+0x492>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	16a040ef          	jal	4a30 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	15a040ef          	jal	4a30 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	150040ef          	jal	4a38 <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	a2250513          	add	a0,a0,-1502 # 5310 <malloc+0x432>
     8f6:	15a040ef          	jal	4a50 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000b597          	auipc	a1,0xb
     908:	37458593          	add	a1,a1,884 # bc78 <buf>
     90c:	11c040ef          	jal	4a28 <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	11e040ef          	jal	4a38 <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	9f250513          	add	a0,a0,-1550 # 5310 <malloc+0x432>
     926:	13a040ef          	jal	4a60 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	add	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	9d450513          	add	a0,a0,-1580 # 5318 <malloc+0x43a>
     94c:	4de040ef          	jal	4e2a <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	0be040ef          	jal	4a10 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	9ee50513          	add	a0,a0,-1554 # 5348 <malloc+0x46a>
     962:	4c8040ef          	jal	4e2a <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	0a8040ef          	jal	4a10 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	a1050513          	add	a0,a0,-1520 # 5380 <malloc+0x4a2>
     978:	4b2040ef          	jal	4e2a <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	092040ef          	jal	4a10 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	a2450513          	add	a0,a0,-1500 # 53a8 <malloc+0x4ca>
     98c:	49e040ef          	jal	4e2a <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	07e040ef          	jal	4a10 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	a3050513          	add	a0,a0,-1488 # 53c8 <malloc+0x4ea>
     9a0:	48a040ef          	jal	4e2a <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	06a040ef          	jal	4a10 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	a3450513          	add	a0,a0,-1484 # 53e0 <malloc+0x502>
     9b4:	476040ef          	jal	4e2a <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	056040ef          	jal	4a10 <exit>

00000000000009be <writebig>:
{
     9be:	7139                	add	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	add	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	a2a50513          	add	a0,a0,-1494 # 5400 <malloc+0x522>
     9de:	072040ef          	jal	4a50 <open>
  if(fd < 0){
     9e2:	06054d63          	bltz	a0,a5c <writebig+0x9e>
     9e6:	89aa                	mv	s3,a0
     9e8:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9ea:	0000b917          	auipc	s2,0xb
     9ee:	28e90913          	add	s2,s2,654 # bc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f2:	6a41                	lui	s4,0x10
     9f4:	10ba0a13          	add	s4,s4,267 # 1010b <base+0x1493>
    ((int*)buf)[0] = i;
     9f8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fc:	40000613          	li	a2,1024
     a00:	85ca                	mv	a1,s2
     a02:	854e                	mv	a0,s3
     a04:	02c040ef          	jal	4a30 <write>
     a08:	40000793          	li	a5,1024
     a0c:	06f51263          	bne	a0,a5,a70 <writebig+0xb2>
  for(i = 0; i < MAXFILE; i++){
     a10:	2485                	addw	s1,s1,1
     a12:	ff4493e3          	bne	s1,s4,9f8 <writebig+0x3a>
  close(fd);
     a16:	854e                	mv	a0,s3
     a18:	020040ef          	jal	4a38 <close>
  fd = open("big", O_RDONLY);
     a1c:	4581                	li	a1,0
     a1e:	00005517          	auipc	a0,0x5
     a22:	9e250513          	add	a0,a0,-1566 # 5400 <malloc+0x522>
     a26:	02a040ef          	jal	4a50 <open>
     a2a:	89aa                	mv	s3,a0
  n = 0;
     a2c:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2e:	0000b917          	auipc	s2,0xb
     a32:	24a90913          	add	s2,s2,586 # bc78 <buf>
  if(fd < 0){
     a36:	04054863          	bltz	a0,a86 <writebig+0xc8>
    i = read(fd, buf, BSIZE);
     a3a:	40000613          	li	a2,1024
     a3e:	85ca                	mv	a1,s2
     a40:	854e                	mv	a0,s3
     a42:	7e7030ef          	jal	4a28 <read>
    if(i == 0){
     a46:	c931                	beqz	a0,a9a <writebig+0xdc>
    } else if(i != BSIZE){
     a48:	40000793          	li	a5,1024
     a4c:	08f51b63          	bne	a0,a5,ae2 <writebig+0x124>
    if(((int*)buf)[0] != n){
     a50:	00092683          	lw	a3,0(s2)
     a54:	0a969263          	bne	a3,s1,af8 <writebig+0x13a>
    n++;
     a58:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a5a:	b7c5                	j	a3a <writebig+0x7c>
    printf("%s: error: creat big failed!\n", s);
     a5c:	85d6                	mv	a1,s5
     a5e:	00005517          	auipc	a0,0x5
     a62:	9aa50513          	add	a0,a0,-1622 # 5408 <malloc+0x52a>
     a66:	3c4040ef          	jal	4e2a <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	7a5030ef          	jal	4a10 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a70:	8626                	mv	a2,s1
     a72:	85d6                	mv	a1,s5
     a74:	00005517          	auipc	a0,0x5
     a78:	9b450513          	add	a0,a0,-1612 # 5428 <malloc+0x54a>
     a7c:	3ae040ef          	jal	4e2a <printf>
      exit(1);
     a80:	4505                	li	a0,1
     a82:	78f030ef          	jal	4a10 <exit>
    printf("%s: error: open big failed!\n", s);
     a86:	85d6                	mv	a1,s5
     a88:	00005517          	auipc	a0,0x5
     a8c:	9c850513          	add	a0,a0,-1592 # 5450 <malloc+0x572>
     a90:	39a040ef          	jal	4e2a <printf>
    exit(1);
     a94:	4505                	li	a0,1
     a96:	77b030ef          	jal	4a10 <exit>
      if(n != MAXFILE){
     a9a:	67c1                	lui	a5,0x10
     a9c:	10b78793          	add	a5,a5,267 # 1010b <base+0x1493>
     aa0:	02f49663          	bne	s1,a5,acc <writebig+0x10e>
  close(fd);
     aa4:	854e                	mv	a0,s3
     aa6:	793030ef          	jal	4a38 <close>
  if(unlink("big") < 0){
     aaa:	00005517          	auipc	a0,0x5
     aae:	95650513          	add	a0,a0,-1706 # 5400 <malloc+0x522>
     ab2:	7af030ef          	jal	4a60 <unlink>
     ab6:	04054c63          	bltz	a0,b0e <writebig+0x150>
}
     aba:	70e2                	ld	ra,56(sp)
     abc:	7442                	ld	s0,48(sp)
     abe:	74a2                	ld	s1,40(sp)
     ac0:	7902                	ld	s2,32(sp)
     ac2:	69e2                	ld	s3,24(sp)
     ac4:	6a42                	ld	s4,16(sp)
     ac6:	6aa2                	ld	s5,8(sp)
     ac8:	6121                	add	sp,sp,64
     aca:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     acc:	8626                	mv	a2,s1
     ace:	85d6                	mv	a1,s5
     ad0:	00005517          	auipc	a0,0x5
     ad4:	9a050513          	add	a0,a0,-1632 # 5470 <malloc+0x592>
     ad8:	352040ef          	jal	4e2a <printf>
        exit(1);
     adc:	4505                	li	a0,1
     ade:	733030ef          	jal	4a10 <exit>
      printf("%s: read failed %d\n", s, i);
     ae2:	862a                	mv	a2,a0
     ae4:	85d6                	mv	a1,s5
     ae6:	00005517          	auipc	a0,0x5
     aea:	9b250513          	add	a0,a0,-1614 # 5498 <malloc+0x5ba>
     aee:	33c040ef          	jal	4e2a <printf>
      exit(1);
     af2:	4505                	li	a0,1
     af4:	71d030ef          	jal	4a10 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af8:	8626                	mv	a2,s1
     afa:	85d6                	mv	a1,s5
     afc:	00005517          	auipc	a0,0x5
     b00:	9b450513          	add	a0,a0,-1612 # 54b0 <malloc+0x5d2>
     b04:	326040ef          	jal	4e2a <printf>
      exit(1);
     b08:	4505                	li	a0,1
     b0a:	707030ef          	jal	4a10 <exit>
    printf("%s: unlink big failed\n", s);
     b0e:	85d6                	mv	a1,s5
     b10:	00005517          	auipc	a0,0x5
     b14:	9c850513          	add	a0,a0,-1592 # 54d8 <malloc+0x5fa>
     b18:	312040ef          	jal	4e2a <printf>
    exit(1);
     b1c:	4505                	li	a0,1
     b1e:	6f3030ef          	jal	4a10 <exit>

0000000000000b22 <unlinkread>:
{
     b22:	7179                	add	sp,sp,-48
     b24:	f406                	sd	ra,40(sp)
     b26:	f022                	sd	s0,32(sp)
     b28:	ec26                	sd	s1,24(sp)
     b2a:	e84a                	sd	s2,16(sp)
     b2c:	e44e                	sd	s3,8(sp)
     b2e:	1800                	add	s0,sp,48
     b30:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b32:	20200593          	li	a1,514
     b36:	00005517          	auipc	a0,0x5
     b3a:	9ba50513          	add	a0,a0,-1606 # 54f0 <malloc+0x612>
     b3e:	713030ef          	jal	4a50 <open>
  if(fd < 0){
     b42:	0a054f63          	bltz	a0,c00 <unlinkread+0xde>
     b46:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b48:	4615                	li	a2,5
     b4a:	00005597          	auipc	a1,0x5
     b4e:	9d658593          	add	a1,a1,-1578 # 5520 <malloc+0x642>
     b52:	6df030ef          	jal	4a30 <write>
  close(fd);
     b56:	8526                	mv	a0,s1
     b58:	6e1030ef          	jal	4a38 <close>
  fd = open("unlinkread", O_RDWR);
     b5c:	4589                	li	a1,2
     b5e:	00005517          	auipc	a0,0x5
     b62:	99250513          	add	a0,a0,-1646 # 54f0 <malloc+0x612>
     b66:	6eb030ef          	jal	4a50 <open>
     b6a:	84aa                	mv	s1,a0
  if(fd < 0){
     b6c:	0a054463          	bltz	a0,c14 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b70:	00005517          	auipc	a0,0x5
     b74:	98050513          	add	a0,a0,-1664 # 54f0 <malloc+0x612>
     b78:	6e9030ef          	jal	4a60 <unlink>
     b7c:	e555                	bnez	a0,c28 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7e:	20200593          	li	a1,514
     b82:	00005517          	auipc	a0,0x5
     b86:	96e50513          	add	a0,a0,-1682 # 54f0 <malloc+0x612>
     b8a:	6c7030ef          	jal	4a50 <open>
     b8e:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b90:	460d                	li	a2,3
     b92:	00005597          	auipc	a1,0x5
     b96:	9d658593          	add	a1,a1,-1578 # 5568 <malloc+0x68a>
     b9a:	697030ef          	jal	4a30 <write>
  close(fd1);
     b9e:	854a                	mv	a0,s2
     ba0:	699030ef          	jal	4a38 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba4:	660d                	lui	a2,0x3
     ba6:	0000b597          	auipc	a1,0xb
     baa:	0d258593          	add	a1,a1,210 # bc78 <buf>
     bae:	8526                	mv	a0,s1
     bb0:	679030ef          	jal	4a28 <read>
     bb4:	4795                	li	a5,5
     bb6:	08f51363          	bne	a0,a5,c3c <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bba:	0000b717          	auipc	a4,0xb
     bbe:	0be74703          	lbu	a4,190(a4) # bc78 <buf>
     bc2:	06800793          	li	a5,104
     bc6:	08f71563          	bne	a4,a5,c50 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bca:	4629                	li	a2,10
     bcc:	0000b597          	auipc	a1,0xb
     bd0:	0ac58593          	add	a1,a1,172 # bc78 <buf>
     bd4:	8526                	mv	a0,s1
     bd6:	65b030ef          	jal	4a30 <write>
     bda:	47a9                	li	a5,10
     bdc:	08f51463          	bne	a0,a5,c64 <unlinkread+0x142>
  close(fd);
     be0:	8526                	mv	a0,s1
     be2:	657030ef          	jal	4a38 <close>
  unlink("unlinkread");
     be6:	00005517          	auipc	a0,0x5
     bea:	90a50513          	add	a0,a0,-1782 # 54f0 <malloc+0x612>
     bee:	673030ef          	jal	4a60 <unlink>
}
     bf2:	70a2                	ld	ra,40(sp)
     bf4:	7402                	ld	s0,32(sp)
     bf6:	64e2                	ld	s1,24(sp)
     bf8:	6942                	ld	s2,16(sp)
     bfa:	69a2                	ld	s3,8(sp)
     bfc:	6145                	add	sp,sp,48
     bfe:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c00:	85ce                	mv	a1,s3
     c02:	00005517          	auipc	a0,0x5
     c06:	8fe50513          	add	a0,a0,-1794 # 5500 <malloc+0x622>
     c0a:	220040ef          	jal	4e2a <printf>
    exit(1);
     c0e:	4505                	li	a0,1
     c10:	601030ef          	jal	4a10 <exit>
    printf("%s: open unlinkread failed\n", s);
     c14:	85ce                	mv	a1,s3
     c16:	00005517          	auipc	a0,0x5
     c1a:	91250513          	add	a0,a0,-1774 # 5528 <malloc+0x64a>
     c1e:	20c040ef          	jal	4e2a <printf>
    exit(1);
     c22:	4505                	li	a0,1
     c24:	5ed030ef          	jal	4a10 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c28:	85ce                	mv	a1,s3
     c2a:	00005517          	auipc	a0,0x5
     c2e:	91e50513          	add	a0,a0,-1762 # 5548 <malloc+0x66a>
     c32:	1f8040ef          	jal	4e2a <printf>
    exit(1);
     c36:	4505                	li	a0,1
     c38:	5d9030ef          	jal	4a10 <exit>
    printf("%s: unlinkread read failed", s);
     c3c:	85ce                	mv	a1,s3
     c3e:	00005517          	auipc	a0,0x5
     c42:	93250513          	add	a0,a0,-1742 # 5570 <malloc+0x692>
     c46:	1e4040ef          	jal	4e2a <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	5c5030ef          	jal	4a10 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c50:	85ce                	mv	a1,s3
     c52:	00005517          	auipc	a0,0x5
     c56:	93e50513          	add	a0,a0,-1730 # 5590 <malloc+0x6b2>
     c5a:	1d0040ef          	jal	4e2a <printf>
    exit(1);
     c5e:	4505                	li	a0,1
     c60:	5b1030ef          	jal	4a10 <exit>
    printf("%s: unlinkread write failed\n", s);
     c64:	85ce                	mv	a1,s3
     c66:	00005517          	auipc	a0,0x5
     c6a:	94a50513          	add	a0,a0,-1718 # 55b0 <malloc+0x6d2>
     c6e:	1bc040ef          	jal	4e2a <printf>
    exit(1);
     c72:	4505                	li	a0,1
     c74:	59d030ef          	jal	4a10 <exit>

0000000000000c78 <linktest>:
{
     c78:	1101                	add	sp,sp,-32
     c7a:	ec06                	sd	ra,24(sp)
     c7c:	e822                	sd	s0,16(sp)
     c7e:	e426                	sd	s1,8(sp)
     c80:	e04a                	sd	s2,0(sp)
     c82:	1000                	add	s0,sp,32
     c84:	892a                	mv	s2,a0
  unlink("lf1");
     c86:	00005517          	auipc	a0,0x5
     c8a:	94a50513          	add	a0,a0,-1718 # 55d0 <malloc+0x6f2>
     c8e:	5d3030ef          	jal	4a60 <unlink>
  unlink("lf2");
     c92:	00005517          	auipc	a0,0x5
     c96:	94650513          	add	a0,a0,-1722 # 55d8 <malloc+0x6fa>
     c9a:	5c7030ef          	jal	4a60 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9e:	20200593          	li	a1,514
     ca2:	00005517          	auipc	a0,0x5
     ca6:	92e50513          	add	a0,a0,-1746 # 55d0 <malloc+0x6f2>
     caa:	5a7030ef          	jal	4a50 <open>
  if(fd < 0){
     cae:	0c054f63          	bltz	a0,d8c <linktest+0x114>
     cb2:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb4:	4615                	li	a2,5
     cb6:	00005597          	auipc	a1,0x5
     cba:	86a58593          	add	a1,a1,-1942 # 5520 <malloc+0x642>
     cbe:	573030ef          	jal	4a30 <write>
     cc2:	4795                	li	a5,5
     cc4:	0cf51e63          	bne	a0,a5,da0 <linktest+0x128>
  close(fd);
     cc8:	8526                	mv	a0,s1
     cca:	56f030ef          	jal	4a38 <close>
  if(link("lf1", "lf2") < 0){
     cce:	00005597          	auipc	a1,0x5
     cd2:	90a58593          	add	a1,a1,-1782 # 55d8 <malloc+0x6fa>
     cd6:	00005517          	auipc	a0,0x5
     cda:	8fa50513          	add	a0,a0,-1798 # 55d0 <malloc+0x6f2>
     cde:	593030ef          	jal	4a70 <link>
     ce2:	0c054963          	bltz	a0,db4 <linktest+0x13c>
  unlink("lf1");
     ce6:	00005517          	auipc	a0,0x5
     cea:	8ea50513          	add	a0,a0,-1814 # 55d0 <malloc+0x6f2>
     cee:	573030ef          	jal	4a60 <unlink>
  if(open("lf1", 0) >= 0){
     cf2:	4581                	li	a1,0
     cf4:	00005517          	auipc	a0,0x5
     cf8:	8dc50513          	add	a0,a0,-1828 # 55d0 <malloc+0x6f2>
     cfc:	555030ef          	jal	4a50 <open>
     d00:	0c055463          	bgez	a0,dc8 <linktest+0x150>
  fd = open("lf2", 0);
     d04:	4581                	li	a1,0
     d06:	00005517          	auipc	a0,0x5
     d0a:	8d250513          	add	a0,a0,-1838 # 55d8 <malloc+0x6fa>
     d0e:	543030ef          	jal	4a50 <open>
     d12:	84aa                	mv	s1,a0
  if(fd < 0){
     d14:	0c054463          	bltz	a0,ddc <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d18:	660d                	lui	a2,0x3
     d1a:	0000b597          	auipc	a1,0xb
     d1e:	f5e58593          	add	a1,a1,-162 # bc78 <buf>
     d22:	507030ef          	jal	4a28 <read>
     d26:	4795                	li	a5,5
     d28:	0cf51463          	bne	a0,a5,df0 <linktest+0x178>
  close(fd);
     d2c:	8526                	mv	a0,s1
     d2e:	50b030ef          	jal	4a38 <close>
  if(link("lf2", "lf2") >= 0){
     d32:	00005597          	auipc	a1,0x5
     d36:	8a658593          	add	a1,a1,-1882 # 55d8 <malloc+0x6fa>
     d3a:	852e                	mv	a0,a1
     d3c:	535030ef          	jal	4a70 <link>
     d40:	0c055263          	bgez	a0,e04 <linktest+0x18c>
  unlink("lf2");
     d44:	00005517          	auipc	a0,0x5
     d48:	89450513          	add	a0,a0,-1900 # 55d8 <malloc+0x6fa>
     d4c:	515030ef          	jal	4a60 <unlink>
  if(link("lf2", "lf1") >= 0){
     d50:	00005597          	auipc	a1,0x5
     d54:	88058593          	add	a1,a1,-1920 # 55d0 <malloc+0x6f2>
     d58:	00005517          	auipc	a0,0x5
     d5c:	88050513          	add	a0,a0,-1920 # 55d8 <malloc+0x6fa>
     d60:	511030ef          	jal	4a70 <link>
     d64:	0a055a63          	bgez	a0,e18 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d68:	00005597          	auipc	a1,0x5
     d6c:	86858593          	add	a1,a1,-1944 # 55d0 <malloc+0x6f2>
     d70:	00005517          	auipc	a0,0x5
     d74:	97050513          	add	a0,a0,-1680 # 56e0 <malloc+0x802>
     d78:	4f9030ef          	jal	4a70 <link>
     d7c:	0a055863          	bgez	a0,e2c <linktest+0x1b4>
}
     d80:	60e2                	ld	ra,24(sp)
     d82:	6442                	ld	s0,16(sp)
     d84:	64a2                	ld	s1,8(sp)
     d86:	6902                	ld	s2,0(sp)
     d88:	6105                	add	sp,sp,32
     d8a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d8c:	85ca                	mv	a1,s2
     d8e:	00005517          	auipc	a0,0x5
     d92:	85250513          	add	a0,a0,-1966 # 55e0 <malloc+0x702>
     d96:	094040ef          	jal	4e2a <printf>
    exit(1);
     d9a:	4505                	li	a0,1
     d9c:	475030ef          	jal	4a10 <exit>
    printf("%s: write lf1 failed\n", s);
     da0:	85ca                	mv	a1,s2
     da2:	00005517          	auipc	a0,0x5
     da6:	85650513          	add	a0,a0,-1962 # 55f8 <malloc+0x71a>
     daa:	080040ef          	jal	4e2a <printf>
    exit(1);
     dae:	4505                	li	a0,1
     db0:	461030ef          	jal	4a10 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db4:	85ca                	mv	a1,s2
     db6:	00005517          	auipc	a0,0x5
     dba:	85a50513          	add	a0,a0,-1958 # 5610 <malloc+0x732>
     dbe:	06c040ef          	jal	4e2a <printf>
    exit(1);
     dc2:	4505                	li	a0,1
     dc4:	44d030ef          	jal	4a10 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc8:	85ca                	mv	a1,s2
     dca:	00005517          	auipc	a0,0x5
     dce:	86650513          	add	a0,a0,-1946 # 5630 <malloc+0x752>
     dd2:	058040ef          	jal	4e2a <printf>
    exit(1);
     dd6:	4505                	li	a0,1
     dd8:	439030ef          	jal	4a10 <exit>
    printf("%s: open lf2 failed\n", s);
     ddc:	85ca                	mv	a1,s2
     dde:	00005517          	auipc	a0,0x5
     de2:	88250513          	add	a0,a0,-1918 # 5660 <malloc+0x782>
     de6:	044040ef          	jal	4e2a <printf>
    exit(1);
     dea:	4505                	li	a0,1
     dec:	425030ef          	jal	4a10 <exit>
    printf("%s: read lf2 failed\n", s);
     df0:	85ca                	mv	a1,s2
     df2:	00005517          	auipc	a0,0x5
     df6:	88650513          	add	a0,a0,-1914 # 5678 <malloc+0x79a>
     dfa:	030040ef          	jal	4e2a <printf>
    exit(1);
     dfe:	4505                	li	a0,1
     e00:	411030ef          	jal	4a10 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e04:	85ca                	mv	a1,s2
     e06:	00005517          	auipc	a0,0x5
     e0a:	88a50513          	add	a0,a0,-1910 # 5690 <malloc+0x7b2>
     e0e:	01c040ef          	jal	4e2a <printf>
    exit(1);
     e12:	4505                	li	a0,1
     e14:	3fd030ef          	jal	4a10 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e18:	85ca                	mv	a1,s2
     e1a:	00005517          	auipc	a0,0x5
     e1e:	89e50513          	add	a0,a0,-1890 # 56b8 <malloc+0x7da>
     e22:	008040ef          	jal	4e2a <printf>
    exit(1);
     e26:	4505                	li	a0,1
     e28:	3e9030ef          	jal	4a10 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e2c:	85ca                	mv	a1,s2
     e2e:	00005517          	auipc	a0,0x5
     e32:	8ba50513          	add	a0,a0,-1862 # 56e8 <malloc+0x80a>
     e36:	7f5030ef          	jal	4e2a <printf>
    exit(1);
     e3a:	4505                	li	a0,1
     e3c:	3d5030ef          	jal	4a10 <exit>

0000000000000e40 <validatetest>:
{
     e40:	7139                	add	sp,sp,-64
     e42:	fc06                	sd	ra,56(sp)
     e44:	f822                	sd	s0,48(sp)
     e46:	f426                	sd	s1,40(sp)
     e48:	f04a                	sd	s2,32(sp)
     e4a:	ec4e                	sd	s3,24(sp)
     e4c:	e852                	sd	s4,16(sp)
     e4e:	e456                	sd	s5,8(sp)
     e50:	e05a                	sd	s6,0(sp)
     e52:	0080                	add	s0,sp,64
     e54:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e56:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e58:	00005997          	auipc	s3,0x5
     e5c:	8b098993          	add	s3,s3,-1872 # 5708 <malloc+0x82a>
     e60:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e62:	6a85                	lui	s5,0x1
     e64:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e68:	85a6                	mv	a1,s1
     e6a:	854e                	mv	a0,s3
     e6c:	405030ef          	jal	4a70 <link>
     e70:	01251f63          	bne	a0,s2,e8e <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e74:	94d6                	add	s1,s1,s5
     e76:	ff4499e3          	bne	s1,s4,e68 <validatetest+0x28>
}
     e7a:	70e2                	ld	ra,56(sp)
     e7c:	7442                	ld	s0,48(sp)
     e7e:	74a2                	ld	s1,40(sp)
     e80:	7902                	ld	s2,32(sp)
     e82:	69e2                	ld	s3,24(sp)
     e84:	6a42                	ld	s4,16(sp)
     e86:	6aa2                	ld	s5,8(sp)
     e88:	6b02                	ld	s6,0(sp)
     e8a:	6121                	add	sp,sp,64
     e8c:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8e:	85da                	mv	a1,s6
     e90:	00005517          	auipc	a0,0x5
     e94:	88850513          	add	a0,a0,-1912 # 5718 <malloc+0x83a>
     e98:	793030ef          	jal	4e2a <printf>
      exit(1);
     e9c:	4505                	li	a0,1
     e9e:	373030ef          	jal	4a10 <exit>

0000000000000ea2 <bigdir>:
{
     ea2:	715d                	add	sp,sp,-80
     ea4:	e486                	sd	ra,72(sp)
     ea6:	e0a2                	sd	s0,64(sp)
     ea8:	fc26                	sd	s1,56(sp)
     eaa:	f84a                	sd	s2,48(sp)
     eac:	f44e                	sd	s3,40(sp)
     eae:	f052                	sd	s4,32(sp)
     eb0:	ec56                	sd	s5,24(sp)
     eb2:	e85a                	sd	s6,16(sp)
     eb4:	0880                	add	s0,sp,80
     eb6:	89aa                	mv	s3,a0
  unlink("bd");
     eb8:	00005517          	auipc	a0,0x5
     ebc:	88050513          	add	a0,a0,-1920 # 5738 <malloc+0x85a>
     ec0:	3a1030ef          	jal	4a60 <unlink>
  fd = open("bd", O_CREATE);
     ec4:	20000593          	li	a1,512
     ec8:	00005517          	auipc	a0,0x5
     ecc:	87050513          	add	a0,a0,-1936 # 5738 <malloc+0x85a>
     ed0:	381030ef          	jal	4a50 <open>
  if(fd < 0){
     ed4:	0c054163          	bltz	a0,f96 <bigdir+0xf4>
  close(fd);
     ed8:	361030ef          	jal	4a38 <close>
  for(i = 0; i < N; i++){
     edc:	4901                	li	s2,0
    name[0] = 'x';
     ede:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ee2:	00005a17          	auipc	s4,0x5
     ee6:	856a0a13          	add	s4,s4,-1962 # 5738 <malloc+0x85a>
  for(i = 0; i < N; i++){
     eea:	1f400b13          	li	s6,500
    name[0] = 'x';
     eee:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     ef2:	41f9571b          	sraw	a4,s2,0x1f
     ef6:	01a7571b          	srlw	a4,a4,0x1a
     efa:	012707bb          	addw	a5,a4,s2
     efe:	4067d69b          	sraw	a3,a5,0x6
     f02:	0306869b          	addw	a3,a3,48
     f06:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f0a:	03f7f793          	and	a5,a5,63
     f0e:	9f99                	subw	a5,a5,a4
     f10:	0307879b          	addw	a5,a5,48
     f14:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f18:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f1c:	fb040593          	add	a1,s0,-80
     f20:	8552                	mv	a0,s4
     f22:	34f030ef          	jal	4a70 <link>
     f26:	84aa                	mv	s1,a0
     f28:	e149                	bnez	a0,faa <bigdir+0x108>
  for(i = 0; i < N; i++){
     f2a:	2905                	addw	s2,s2,1
     f2c:	fd6911e3          	bne	s2,s6,eee <bigdir+0x4c>
  unlink("bd");
     f30:	00005517          	auipc	a0,0x5
     f34:	80850513          	add	a0,a0,-2040 # 5738 <malloc+0x85a>
     f38:	329030ef          	jal	4a60 <unlink>
    name[0] = 'x';
     f3c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f40:	1f400a13          	li	s4,500
    name[0] = 'x';
     f44:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f48:	41f4d71b          	sraw	a4,s1,0x1f
     f4c:	01a7571b          	srlw	a4,a4,0x1a
     f50:	009707bb          	addw	a5,a4,s1
     f54:	4067d69b          	sraw	a3,a5,0x6
     f58:	0306869b          	addw	a3,a3,48
     f5c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f60:	03f7f793          	and	a5,a5,63
     f64:	9f99                	subw	a5,a5,a4
     f66:	0307879b          	addw	a5,a5,48
     f6a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f72:	fb040513          	add	a0,s0,-80
     f76:	2eb030ef          	jal	4a60 <unlink>
     f7a:	e529                	bnez	a0,fc4 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f7c:	2485                	addw	s1,s1,1
     f7e:	fd4493e3          	bne	s1,s4,f44 <bigdir+0xa2>
}
     f82:	60a6                	ld	ra,72(sp)
     f84:	6406                	ld	s0,64(sp)
     f86:	74e2                	ld	s1,56(sp)
     f88:	7942                	ld	s2,48(sp)
     f8a:	79a2                	ld	s3,40(sp)
     f8c:	7a02                	ld	s4,32(sp)
     f8e:	6ae2                	ld	s5,24(sp)
     f90:	6b42                	ld	s6,16(sp)
     f92:	6161                	add	sp,sp,80
     f94:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f96:	85ce                	mv	a1,s3
     f98:	00004517          	auipc	a0,0x4
     f9c:	7a850513          	add	a0,a0,1960 # 5740 <malloc+0x862>
     fa0:	68b030ef          	jal	4e2a <printf>
    exit(1);
     fa4:	4505                	li	a0,1
     fa6:	26b030ef          	jal	4a10 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     faa:	fb040693          	add	a3,s0,-80
     fae:	864a                	mv	a2,s2
     fb0:	85ce                	mv	a1,s3
     fb2:	00004517          	auipc	a0,0x4
     fb6:	7ae50513          	add	a0,a0,1966 # 5760 <malloc+0x882>
     fba:	671030ef          	jal	4e2a <printf>
      exit(1);
     fbe:	4505                	li	a0,1
     fc0:	251030ef          	jal	4a10 <exit>
      printf("%s: bigdir unlink failed", s);
     fc4:	85ce                	mv	a1,s3
     fc6:	00004517          	auipc	a0,0x4
     fca:	7c250513          	add	a0,a0,1986 # 5788 <malloc+0x8aa>
     fce:	65d030ef          	jal	4e2a <printf>
      exit(1);
     fd2:	4505                	li	a0,1
     fd4:	23d030ef          	jal	4a10 <exit>

0000000000000fd8 <pgbug>:
{
     fd8:	7179                	add	sp,sp,-48
     fda:	f406                	sd	ra,40(sp)
     fdc:	f022                	sd	s0,32(sp)
     fde:	ec26                	sd	s1,24(sp)
     fe0:	1800                	add	s0,sp,48
  argv[0] = 0;
     fe2:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe6:	00007497          	auipc	s1,0x7
     fea:	01a48493          	add	s1,s1,26 # 8000 <big>
     fee:	fd840593          	add	a1,s0,-40
     ff2:	6088                	ld	a0,0(s1)
     ff4:	255030ef          	jal	4a48 <exec>
  pipe(big);
     ff8:	6088                	ld	a0,0(s1)
     ffa:	227030ef          	jal	4a20 <pipe>
  exit(0);
     ffe:	4501                	li	a0,0
    1000:	211030ef          	jal	4a10 <exit>

0000000000001004 <badarg>:
{
    1004:	7139                	add	sp,sp,-64
    1006:	fc06                	sd	ra,56(sp)
    1008:	f822                	sd	s0,48(sp)
    100a:	f426                	sd	s1,40(sp)
    100c:	f04a                	sd	s2,32(sp)
    100e:	ec4e                	sd	s3,24(sp)
    1010:	0080                	add	s0,sp,64
    1012:	64b1                	lui	s1,0xc
    1014:	35048493          	add	s1,s1,848 # c350 <buf+0x6d8>
    argv[0] = (char*)0xffffffff;
    1018:	597d                	li	s2,-1
    101a:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    101e:	00004997          	auipc	s3,0x4
    1022:	fda98993          	add	s3,s3,-38 # 4ff8 <malloc+0x11a>
    argv[0] = (char*)0xffffffff;
    1026:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    102a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102e:	fc040593          	add	a1,s0,-64
    1032:	854e                	mv	a0,s3
    1034:	215030ef          	jal	4a48 <exec>
  for(int i = 0; i < 50000; i++){
    1038:	34fd                	addw	s1,s1,-1
    103a:	f4f5                	bnez	s1,1026 <badarg+0x22>
  exit(0);
    103c:	4501                	li	a0,0
    103e:	1d3030ef          	jal	4a10 <exit>

0000000000001042 <copyinstr2>:
{
    1042:	7155                	add	sp,sp,-208
    1044:	e586                	sd	ra,200(sp)
    1046:	e1a2                	sd	s0,192(sp)
    1048:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    104a:	f6840793          	add	a5,s0,-152
    104e:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    1052:	07800713          	li	a4,120
    1056:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    105a:	0785                	add	a5,a5,1
    105c:	fed79de3          	bne	a5,a3,1056 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1060:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1064:	f6840513          	add	a0,s0,-152
    1068:	1f9030ef          	jal	4a60 <unlink>
  if(ret != -1){
    106c:	57fd                	li	a5,-1
    106e:	0cf51263          	bne	a0,a5,1132 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    1072:	20100593          	li	a1,513
    1076:	f6840513          	add	a0,s0,-152
    107a:	1d7030ef          	jal	4a50 <open>
  if(fd != -1){
    107e:	57fd                	li	a5,-1
    1080:	0cf51563          	bne	a0,a5,114a <copyinstr2+0x108>
  ret = link(b, b);
    1084:	f6840593          	add	a1,s0,-152
    1088:	852e                	mv	a0,a1
    108a:	1e7030ef          	jal	4a70 <link>
  if(ret != -1){
    108e:	57fd                	li	a5,-1
    1090:	0cf51963          	bne	a0,a5,1162 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1094:	00006797          	auipc	a5,0x6
    1098:	84478793          	add	a5,a5,-1980 # 68d8 <malloc+0x19fa>
    109c:	f4f43c23          	sd	a5,-168(s0)
    10a0:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a4:	f5840593          	add	a1,s0,-168
    10a8:	f6840513          	add	a0,s0,-152
    10ac:	19d030ef          	jal	4a48 <exec>
  if(ret != -1){
    10b0:	57fd                	li	a5,-1
    10b2:	0cf51563          	bne	a0,a5,117c <copyinstr2+0x13a>
  int pid = fork();
    10b6:	153030ef          	jal	4a08 <fork>
  if(pid < 0){
    10ba:	0c054d63          	bltz	a0,1194 <copyinstr2+0x152>
  if(pid == 0){
    10be:	0e051863          	bnez	a0,11ae <copyinstr2+0x16c>
    10c2:	00007797          	auipc	a5,0x7
    10c6:	49e78793          	add	a5,a5,1182 # 8560 <big.0>
    10ca:	00008697          	auipc	a3,0x8
    10ce:	49668693          	add	a3,a3,1174 # 9560 <big.0+0x1000>
      big[i] = 'x';
    10d2:	07800713          	li	a4,120
    10d6:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10da:	0785                	add	a5,a5,1
    10dc:	fed79de3          	bne	a5,a3,10d6 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10e0:	00008797          	auipc	a5,0x8
    10e4:	48078023          	sb	zero,1152(a5) # 9560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e8:	00006797          	auipc	a5,0x6
    10ec:	26878793          	add	a5,a5,616 # 7350 <malloc+0x2472>
    10f0:	6fb0                	ld	a2,88(a5)
    10f2:	73b4                	ld	a3,96(a5)
    10f4:	77b8                	ld	a4,104(a5)
    10f6:	7bbc                	ld	a5,112(a5)
    10f8:	f2c43823          	sd	a2,-208(s0)
    10fc:	f2d43c23          	sd	a3,-200(s0)
    1100:	f4e43023          	sd	a4,-192(s0)
    1104:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1108:	f3040593          	add	a1,s0,-208
    110c:	00004517          	auipc	a0,0x4
    1110:	eec50513          	add	a0,a0,-276 # 4ff8 <malloc+0x11a>
    1114:	135030ef          	jal	4a48 <exec>
    if(ret != -1){
    1118:	57fd                	li	a5,-1
    111a:	08f50663          	beq	a0,a5,11a6 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111e:	55fd                	li	a1,-1
    1120:	00004517          	auipc	a0,0x4
    1124:	71050513          	add	a0,a0,1808 # 5830 <malloc+0x952>
    1128:	503030ef          	jal	4e2a <printf>
      exit(1);
    112c:	4505                	li	a0,1
    112e:	0e3030ef          	jal	4a10 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1132:	862a                	mv	a2,a0
    1134:	f6840593          	add	a1,s0,-152
    1138:	00004517          	auipc	a0,0x4
    113c:	67050513          	add	a0,a0,1648 # 57a8 <malloc+0x8ca>
    1140:	4eb030ef          	jal	4e2a <printf>
    exit(1);
    1144:	4505                	li	a0,1
    1146:	0cb030ef          	jal	4a10 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    114a:	862a                	mv	a2,a0
    114c:	f6840593          	add	a1,s0,-152
    1150:	00004517          	auipc	a0,0x4
    1154:	67850513          	add	a0,a0,1656 # 57c8 <malloc+0x8ea>
    1158:	4d3030ef          	jal	4e2a <printf>
    exit(1);
    115c:	4505                	li	a0,1
    115e:	0b3030ef          	jal	4a10 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1162:	86aa                	mv	a3,a0
    1164:	f6840613          	add	a2,s0,-152
    1168:	85b2                	mv	a1,a2
    116a:	00004517          	auipc	a0,0x4
    116e:	67e50513          	add	a0,a0,1662 # 57e8 <malloc+0x90a>
    1172:	4b9030ef          	jal	4e2a <printf>
    exit(1);
    1176:	4505                	li	a0,1
    1178:	099030ef          	jal	4a10 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    117c:	567d                	li	a2,-1
    117e:	f6840593          	add	a1,s0,-152
    1182:	00004517          	auipc	a0,0x4
    1186:	68e50513          	add	a0,a0,1678 # 5810 <malloc+0x932>
    118a:	4a1030ef          	jal	4e2a <printf>
    exit(1);
    118e:	4505                	li	a0,1
    1190:	081030ef          	jal	4a10 <exit>
    printf("fork failed\n");
    1194:	00006517          	auipc	a0,0x6
    1198:	c6450513          	add	a0,a0,-924 # 6df8 <malloc+0x1f1a>
    119c:	48f030ef          	jal	4e2a <printf>
    exit(1);
    11a0:	4505                	li	a0,1
    11a2:	06f030ef          	jal	4a10 <exit>
    exit(747); /* OK */
    11a6:	2eb00513          	li	a0,747
    11aa:	067030ef          	jal	4a10 <exit>
  int st = 0;
    11ae:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11b2:	f5440513          	add	a0,s0,-172
    11b6:	063030ef          	jal	4a18 <wait>
  if(st != 747){
    11ba:	f5442703          	lw	a4,-172(s0)
    11be:	2eb00793          	li	a5,747
    11c2:	00f71663          	bne	a4,a5,11ce <copyinstr2+0x18c>
}
    11c6:	60ae                	ld	ra,200(sp)
    11c8:	640e                	ld	s0,192(sp)
    11ca:	6169                	add	sp,sp,208
    11cc:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ce:	00004517          	auipc	a0,0x4
    11d2:	68a50513          	add	a0,a0,1674 # 5858 <malloc+0x97a>
    11d6:	455030ef          	jal	4e2a <printf>
    exit(1);
    11da:	4505                	li	a0,1
    11dc:	035030ef          	jal	4a10 <exit>

00000000000011e0 <truncate3>:
{
    11e0:	7159                	add	sp,sp,-112
    11e2:	f486                	sd	ra,104(sp)
    11e4:	f0a2                	sd	s0,96(sp)
    11e6:	eca6                	sd	s1,88(sp)
    11e8:	e8ca                	sd	s2,80(sp)
    11ea:	e4ce                	sd	s3,72(sp)
    11ec:	e0d2                	sd	s4,64(sp)
    11ee:	fc56                	sd	s5,56(sp)
    11f0:	1880                	add	s0,sp,112
    11f2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11f4:	60100593          	li	a1,1537
    11f8:	00004517          	auipc	a0,0x4
    11fc:	e5850513          	add	a0,a0,-424 # 5050 <malloc+0x172>
    1200:	051030ef          	jal	4a50 <open>
    1204:	035030ef          	jal	4a38 <close>
  pid = fork();
    1208:	001030ef          	jal	4a08 <fork>
  if(pid < 0){
    120c:	06054263          	bltz	a0,1270 <truncate3+0x90>
  if(pid == 0){
    1210:	ed59                	bnez	a0,12ae <truncate3+0xce>
    1212:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1216:	00004a17          	auipc	s4,0x4
    121a:	e3aa0a13          	add	s4,s4,-454 # 5050 <malloc+0x172>
      int n = write(fd, "1234567890", 10);
    121e:	00004a97          	auipc	s5,0x4
    1222:	69aa8a93          	add	s5,s5,1690 # 58b8 <malloc+0x9da>
      int fd = open("truncfile", O_WRONLY);
    1226:	4585                	li	a1,1
    1228:	8552                	mv	a0,s4
    122a:	027030ef          	jal	4a50 <open>
    122e:	84aa                	mv	s1,a0
      if(fd < 0){
    1230:	04054a63          	bltz	a0,1284 <truncate3+0xa4>
      int n = write(fd, "1234567890", 10);
    1234:	4629                	li	a2,10
    1236:	85d6                	mv	a1,s5
    1238:	7f8030ef          	jal	4a30 <write>
      if(n != 10){
    123c:	47a9                	li	a5,10
    123e:	04f51d63          	bne	a0,a5,1298 <truncate3+0xb8>
      close(fd);
    1242:	8526                	mv	a0,s1
    1244:	7f4030ef          	jal	4a38 <close>
      fd = open("truncfile", O_RDONLY);
    1248:	4581                	li	a1,0
    124a:	8552                	mv	a0,s4
    124c:	005030ef          	jal	4a50 <open>
    1250:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1252:	02000613          	li	a2,32
    1256:	f9840593          	add	a1,s0,-104
    125a:	7ce030ef          	jal	4a28 <read>
      close(fd);
    125e:	8526                	mv	a0,s1
    1260:	7d8030ef          	jal	4a38 <close>
    for(int i = 0; i < 100; i++){
    1264:	39fd                	addw	s3,s3,-1
    1266:	fc0990e3          	bnez	s3,1226 <truncate3+0x46>
    exit(0);
    126a:	4501                	li	a0,0
    126c:	7a4030ef          	jal	4a10 <exit>
    printf("%s: fork failed\n", s);
    1270:	85ca                	mv	a1,s2
    1272:	00004517          	auipc	a0,0x4
    1276:	61650513          	add	a0,a0,1558 # 5888 <malloc+0x9aa>
    127a:	3b1030ef          	jal	4e2a <printf>
    exit(1);
    127e:	4505                	li	a0,1
    1280:	790030ef          	jal	4a10 <exit>
        printf("%s: open failed\n", s);
    1284:	85ca                	mv	a1,s2
    1286:	00004517          	auipc	a0,0x4
    128a:	61a50513          	add	a0,a0,1562 # 58a0 <malloc+0x9c2>
    128e:	39d030ef          	jal	4e2a <printf>
        exit(1);
    1292:	4505                	li	a0,1
    1294:	77c030ef          	jal	4a10 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1298:	862a                	mv	a2,a0
    129a:	85ca                	mv	a1,s2
    129c:	00004517          	auipc	a0,0x4
    12a0:	62c50513          	add	a0,a0,1580 # 58c8 <malloc+0x9ea>
    12a4:	387030ef          	jal	4e2a <printf>
        exit(1);
    12a8:	4505                	li	a0,1
    12aa:	766030ef          	jal	4a10 <exit>
    12ae:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12b2:	00004a17          	auipc	s4,0x4
    12b6:	d9ea0a13          	add	s4,s4,-610 # 5050 <malloc+0x172>
    int n = write(fd, "xxx", 3);
    12ba:	00004a97          	auipc	s5,0x4
    12be:	62ea8a93          	add	s5,s5,1582 # 58e8 <malloc+0xa0a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12c2:	60100593          	li	a1,1537
    12c6:	8552                	mv	a0,s4
    12c8:	788030ef          	jal	4a50 <open>
    12cc:	84aa                	mv	s1,a0
    if(fd < 0){
    12ce:	02054d63          	bltz	a0,1308 <truncate3+0x128>
    int n = write(fd, "xxx", 3);
    12d2:	460d                	li	a2,3
    12d4:	85d6                	mv	a1,s5
    12d6:	75a030ef          	jal	4a30 <write>
    if(n != 3){
    12da:	478d                	li	a5,3
    12dc:	04f51063          	bne	a0,a5,131c <truncate3+0x13c>
    close(fd);
    12e0:	8526                	mv	a0,s1
    12e2:	756030ef          	jal	4a38 <close>
  for(int i = 0; i < 150; i++){
    12e6:	39fd                	addw	s3,s3,-1
    12e8:	fc099de3          	bnez	s3,12c2 <truncate3+0xe2>
  wait(&xstatus);
    12ec:	fbc40513          	add	a0,s0,-68
    12f0:	728030ef          	jal	4a18 <wait>
  unlink("truncfile");
    12f4:	00004517          	auipc	a0,0x4
    12f8:	d5c50513          	add	a0,a0,-676 # 5050 <malloc+0x172>
    12fc:	764030ef          	jal	4a60 <unlink>
  exit(xstatus);
    1300:	fbc42503          	lw	a0,-68(s0)
    1304:	70c030ef          	jal	4a10 <exit>
      printf("%s: open failed\n", s);
    1308:	85ca                	mv	a1,s2
    130a:	00004517          	auipc	a0,0x4
    130e:	59650513          	add	a0,a0,1430 # 58a0 <malloc+0x9c2>
    1312:	319030ef          	jal	4e2a <printf>
      exit(1);
    1316:	4505                	li	a0,1
    1318:	6f8030ef          	jal	4a10 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    131c:	862a                	mv	a2,a0
    131e:	85ca                	mv	a1,s2
    1320:	00004517          	auipc	a0,0x4
    1324:	5d050513          	add	a0,a0,1488 # 58f0 <malloc+0xa12>
    1328:	303030ef          	jal	4e2a <printf>
      exit(1);
    132c:	4505                	li	a0,1
    132e:	6e2030ef          	jal	4a10 <exit>

0000000000001332 <exectest>:
{
    1332:	715d                	add	sp,sp,-80
    1334:	e486                	sd	ra,72(sp)
    1336:	e0a2                	sd	s0,64(sp)
    1338:	fc26                	sd	s1,56(sp)
    133a:	f84a                	sd	s2,48(sp)
    133c:	0880                	add	s0,sp,80
    133e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1340:	00004797          	auipc	a5,0x4
    1344:	cb878793          	add	a5,a5,-840 # 4ff8 <malloc+0x11a>
    1348:	fcf43023          	sd	a5,-64(s0)
    134c:	00004797          	auipc	a5,0x4
    1350:	5c478793          	add	a5,a5,1476 # 5910 <malloc+0xa32>
    1354:	fcf43423          	sd	a5,-56(s0)
    1358:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    135c:	00004517          	auipc	a0,0x4
    1360:	5bc50513          	add	a0,a0,1468 # 5918 <malloc+0xa3a>
    1364:	6fc030ef          	jal	4a60 <unlink>
  pid = fork();
    1368:	6a0030ef          	jal	4a08 <fork>
  if(pid < 0) {
    136c:	02054e63          	bltz	a0,13a8 <exectest+0x76>
    1370:	84aa                	mv	s1,a0
  if(pid == 0) {
    1372:	e92d                	bnez	a0,13e4 <exectest+0xb2>
    close(1);
    1374:	4505                	li	a0,1
    1376:	6c2030ef          	jal	4a38 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    137a:	20100593          	li	a1,513
    137e:	00004517          	auipc	a0,0x4
    1382:	59a50513          	add	a0,a0,1434 # 5918 <malloc+0xa3a>
    1386:	6ca030ef          	jal	4a50 <open>
    if(fd < 0) {
    138a:	02054963          	bltz	a0,13bc <exectest+0x8a>
    if(fd != 1) {
    138e:	4785                	li	a5,1
    1390:	04f50063          	beq	a0,a5,13d0 <exectest+0x9e>
      printf("%s: wrong fd\n", s);
    1394:	85ca                	mv	a1,s2
    1396:	00004517          	auipc	a0,0x4
    139a:	5a250513          	add	a0,a0,1442 # 5938 <malloc+0xa5a>
    139e:	28d030ef          	jal	4e2a <printf>
      exit(1);
    13a2:	4505                	li	a0,1
    13a4:	66c030ef          	jal	4a10 <exit>
     printf("%s: fork failed\n", s);
    13a8:	85ca                	mv	a1,s2
    13aa:	00004517          	auipc	a0,0x4
    13ae:	4de50513          	add	a0,a0,1246 # 5888 <malloc+0x9aa>
    13b2:	279030ef          	jal	4e2a <printf>
     exit(1);
    13b6:	4505                	li	a0,1
    13b8:	658030ef          	jal	4a10 <exit>
      printf("%s: create failed\n", s);
    13bc:	85ca                	mv	a1,s2
    13be:	00004517          	auipc	a0,0x4
    13c2:	56250513          	add	a0,a0,1378 # 5920 <malloc+0xa42>
    13c6:	265030ef          	jal	4e2a <printf>
      exit(1);
    13ca:	4505                	li	a0,1
    13cc:	644030ef          	jal	4a10 <exit>
    if(exec("echo", echoargv) < 0){
    13d0:	fc040593          	add	a1,s0,-64
    13d4:	00004517          	auipc	a0,0x4
    13d8:	c2450513          	add	a0,a0,-988 # 4ff8 <malloc+0x11a>
    13dc:	66c030ef          	jal	4a48 <exec>
    13e0:	00054d63          	bltz	a0,13fa <exectest+0xc8>
  if (wait(&xstatus) != pid) {
    13e4:	fdc40513          	add	a0,s0,-36
    13e8:	630030ef          	jal	4a18 <wait>
    13ec:	02951163          	bne	a0,s1,140e <exectest+0xdc>
  if(xstatus != 0)
    13f0:	fdc42503          	lw	a0,-36(s0)
    13f4:	c50d                	beqz	a0,141e <exectest+0xec>
    exit(xstatus);
    13f6:	61a030ef          	jal	4a10 <exit>
      printf("%s: exec echo failed\n", s);
    13fa:	85ca                	mv	a1,s2
    13fc:	00004517          	auipc	a0,0x4
    1400:	54c50513          	add	a0,a0,1356 # 5948 <malloc+0xa6a>
    1404:	227030ef          	jal	4e2a <printf>
      exit(1);
    1408:	4505                	li	a0,1
    140a:	606030ef          	jal	4a10 <exit>
    printf("%s: wait failed!\n", s);
    140e:	85ca                	mv	a1,s2
    1410:	00004517          	auipc	a0,0x4
    1414:	55050513          	add	a0,a0,1360 # 5960 <malloc+0xa82>
    1418:	213030ef          	jal	4e2a <printf>
    141c:	bfd1                	j	13f0 <exectest+0xbe>
  fd = open("echo-ok", O_RDONLY);
    141e:	4581                	li	a1,0
    1420:	00004517          	auipc	a0,0x4
    1424:	4f850513          	add	a0,a0,1272 # 5918 <malloc+0xa3a>
    1428:	628030ef          	jal	4a50 <open>
  if(fd < 0) {
    142c:	02054463          	bltz	a0,1454 <exectest+0x122>
  if (read(fd, buf, 2) != 2) {
    1430:	4609                	li	a2,2
    1432:	fb840593          	add	a1,s0,-72
    1436:	5f2030ef          	jal	4a28 <read>
    143a:	4789                	li	a5,2
    143c:	02f50663          	beq	a0,a5,1468 <exectest+0x136>
    printf("%s: read failed\n", s);
    1440:	85ca                	mv	a1,s2
    1442:	00004517          	auipc	a0,0x4
    1446:	f8650513          	add	a0,a0,-122 # 53c8 <malloc+0x4ea>
    144a:	1e1030ef          	jal	4e2a <printf>
    exit(1);
    144e:	4505                	li	a0,1
    1450:	5c0030ef          	jal	4a10 <exit>
    printf("%s: open failed\n", s);
    1454:	85ca                	mv	a1,s2
    1456:	00004517          	auipc	a0,0x4
    145a:	44a50513          	add	a0,a0,1098 # 58a0 <malloc+0x9c2>
    145e:	1cd030ef          	jal	4e2a <printf>
    exit(1);
    1462:	4505                	li	a0,1
    1464:	5ac030ef          	jal	4a10 <exit>
  unlink("echo-ok");
    1468:	00004517          	auipc	a0,0x4
    146c:	4b050513          	add	a0,a0,1200 # 5918 <malloc+0xa3a>
    1470:	5f0030ef          	jal	4a60 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1474:	fb844703          	lbu	a4,-72(s0)
    1478:	04f00793          	li	a5,79
    147c:	00f71863          	bne	a4,a5,148c <exectest+0x15a>
    1480:	fb944703          	lbu	a4,-71(s0)
    1484:	04b00793          	li	a5,75
    1488:	00f70c63          	beq	a4,a5,14a0 <exectest+0x16e>
    printf("%s: wrong output\n", s);
    148c:	85ca                	mv	a1,s2
    148e:	00004517          	auipc	a0,0x4
    1492:	4ea50513          	add	a0,a0,1258 # 5978 <malloc+0xa9a>
    1496:	195030ef          	jal	4e2a <printf>
    exit(1);
    149a:	4505                	li	a0,1
    149c:	574030ef          	jal	4a10 <exit>
    exit(0);
    14a0:	4501                	li	a0,0
    14a2:	56e030ef          	jal	4a10 <exit>

00000000000014a6 <pipe1>:
{
    14a6:	711d                	add	sp,sp,-96
    14a8:	ec86                	sd	ra,88(sp)
    14aa:	e8a2                	sd	s0,80(sp)
    14ac:	e4a6                	sd	s1,72(sp)
    14ae:	e0ca                	sd	s2,64(sp)
    14b0:	fc4e                	sd	s3,56(sp)
    14b2:	f852                	sd	s4,48(sp)
    14b4:	f456                	sd	s5,40(sp)
    14b6:	f05a                	sd	s6,32(sp)
    14b8:	ec5e                	sd	s7,24(sp)
    14ba:	1080                	add	s0,sp,96
    14bc:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    14be:	fa840513          	add	a0,s0,-88
    14c2:	55e030ef          	jal	4a20 <pipe>
    14c6:	e52d                	bnez	a0,1530 <pipe1+0x8a>
    14c8:	84aa                	mv	s1,a0
  pid = fork();
    14ca:	53e030ef          	jal	4a08 <fork>
    14ce:	8a2a                	mv	s4,a0
  if(pid == 0){
    14d0:	c935                	beqz	a0,1544 <pipe1+0x9e>
  } else if(pid > 0){
    14d2:	14a05063          	blez	a0,1612 <pipe1+0x16c>
    close(fds[1]);
    14d6:	fac42503          	lw	a0,-84(s0)
    14da:	55e030ef          	jal	4a38 <close>
    total = 0;
    14de:	8a26                	mv	s4,s1
    cc = 1;
    14e0:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    14e2:	0000aa97          	auipc	s5,0xa
    14e6:	796a8a93          	add	s5,s5,1942 # bc78 <buf>
    14ea:	864e                	mv	a2,s3
    14ec:	85d6                	mv	a1,s5
    14ee:	fa842503          	lw	a0,-88(s0)
    14f2:	536030ef          	jal	4a28 <read>
    14f6:	0ea05263          	blez	a0,15da <pipe1+0x134>
      for(i = 0; i < n; i++){
    14fa:	0000a717          	auipc	a4,0xa
    14fe:	77e70713          	add	a4,a4,1918 # bc78 <buf>
    1502:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1506:	00074683          	lbu	a3,0(a4)
    150a:	0ff4f793          	zext.b	a5,s1
    150e:	2485                	addw	s1,s1,1
    1510:	0af69363          	bne	a3,a5,15b6 <pipe1+0x110>
      for(i = 0; i < n; i++){
    1514:	0705                	add	a4,a4,1
    1516:	fec498e3          	bne	s1,a2,1506 <pipe1+0x60>
      total += n;
    151a:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    151e:	0019979b          	sllw	a5,s3,0x1
    1522:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1526:	670d                	lui	a4,0x3
    1528:	fd3771e3          	bgeu	a4,s3,14ea <pipe1+0x44>
        cc = sizeof(buf);
    152c:	698d                	lui	s3,0x3
    152e:	bf75                	j	14ea <pipe1+0x44>
    printf("%s: pipe() failed\n", s);
    1530:	85ca                	mv	a1,s2
    1532:	00004517          	auipc	a0,0x4
    1536:	45e50513          	add	a0,a0,1118 # 5990 <malloc+0xab2>
    153a:	0f1030ef          	jal	4e2a <printf>
    exit(1);
    153e:	4505                	li	a0,1
    1540:	4d0030ef          	jal	4a10 <exit>
    close(fds[0]);
    1544:	fa842503          	lw	a0,-88(s0)
    1548:	4f0030ef          	jal	4a38 <close>
    for(n = 0; n < N; n++){
    154c:	0000ab17          	auipc	s6,0xa
    1550:	72cb0b13          	add	s6,s6,1836 # bc78 <buf>
    1554:	416004bb          	negw	s1,s6
    1558:	0ff4f493          	zext.b	s1,s1
    155c:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1560:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1562:	6a85                	lui	s5,0x1
    1564:	42da8a93          	add	s5,s5,1069 # 142d <exectest+0xfb>
{
    1568:	87da                	mv	a5,s6
        buf[i] = seq++;
    156a:	0097873b          	addw	a4,a5,s1
    156e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1572:	0785                	add	a5,a5,1
    1574:	fef99be3          	bne	s3,a5,156a <pipe1+0xc4>
        buf[i] = seq++;
    1578:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    157c:	40900613          	li	a2,1033
    1580:	85de                	mv	a1,s7
    1582:	fac42503          	lw	a0,-84(s0)
    1586:	4aa030ef          	jal	4a30 <write>
    158a:	40900793          	li	a5,1033
    158e:	00f51a63          	bne	a0,a5,15a2 <pipe1+0xfc>
    for(n = 0; n < N; n++){
    1592:	24a5                	addw	s1,s1,9
    1594:	0ff4f493          	zext.b	s1,s1
    1598:	fd5a18e3          	bne	s4,s5,1568 <pipe1+0xc2>
    exit(0);
    159c:	4501                	li	a0,0
    159e:	472030ef          	jal	4a10 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15a2:	85ca                	mv	a1,s2
    15a4:	00004517          	auipc	a0,0x4
    15a8:	40450513          	add	a0,a0,1028 # 59a8 <malloc+0xaca>
    15ac:	07f030ef          	jal	4e2a <printf>
        exit(1);
    15b0:	4505                	li	a0,1
    15b2:	45e030ef          	jal	4a10 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15b6:	85ca                	mv	a1,s2
    15b8:	00004517          	auipc	a0,0x4
    15bc:	40850513          	add	a0,a0,1032 # 59c0 <malloc+0xae2>
    15c0:	06b030ef          	jal	4e2a <printf>
}
    15c4:	60e6                	ld	ra,88(sp)
    15c6:	6446                	ld	s0,80(sp)
    15c8:	64a6                	ld	s1,72(sp)
    15ca:	6906                	ld	s2,64(sp)
    15cc:	79e2                	ld	s3,56(sp)
    15ce:	7a42                	ld	s4,48(sp)
    15d0:	7aa2                	ld	s5,40(sp)
    15d2:	7b02                	ld	s6,32(sp)
    15d4:	6be2                	ld	s7,24(sp)
    15d6:	6125                	add	sp,sp,96
    15d8:	8082                	ret
    if(total != N * SZ){
    15da:	6785                	lui	a5,0x1
    15dc:	42d78793          	add	a5,a5,1069 # 142d <exectest+0xfb>
    15e0:	00fa0d63          	beq	s4,a5,15fa <pipe1+0x154>
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    15e4:	8652                	mv	a2,s4
    15e6:	85ca                	mv	a1,s2
    15e8:	00004517          	auipc	a0,0x4
    15ec:	3f050513          	add	a0,a0,1008 # 59d8 <malloc+0xafa>
    15f0:	03b030ef          	jal	4e2a <printf>
      exit(1);
    15f4:	4505                	li	a0,1
    15f6:	41a030ef          	jal	4a10 <exit>
    close(fds[0]);
    15fa:	fa842503          	lw	a0,-88(s0)
    15fe:	43a030ef          	jal	4a38 <close>
    wait(&xstatus);
    1602:	fa440513          	add	a0,s0,-92
    1606:	412030ef          	jal	4a18 <wait>
    exit(xstatus);
    160a:	fa442503          	lw	a0,-92(s0)
    160e:	402030ef          	jal	4a10 <exit>
    printf("%s: fork() failed\n", s);
    1612:	85ca                	mv	a1,s2
    1614:	00004517          	auipc	a0,0x4
    1618:	3e450513          	add	a0,a0,996 # 59f8 <malloc+0xb1a>
    161c:	00f030ef          	jal	4e2a <printf>
    exit(1);
    1620:	4505                	li	a0,1
    1622:	3ee030ef          	jal	4a10 <exit>

0000000000001626 <exitwait>:
{
    1626:	7139                	add	sp,sp,-64
    1628:	fc06                	sd	ra,56(sp)
    162a:	f822                	sd	s0,48(sp)
    162c:	f426                	sd	s1,40(sp)
    162e:	f04a                	sd	s2,32(sp)
    1630:	ec4e                	sd	s3,24(sp)
    1632:	e852                	sd	s4,16(sp)
    1634:	0080                	add	s0,sp,64
    1636:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1638:	4901                	li	s2,0
    163a:	06400993          	li	s3,100
    pid = fork();
    163e:	3ca030ef          	jal	4a08 <fork>
    1642:	84aa                	mv	s1,a0
    if(pid < 0){
    1644:	02054863          	bltz	a0,1674 <exitwait+0x4e>
    if(pid){
    1648:	c525                	beqz	a0,16b0 <exitwait+0x8a>
      if(wait(&xstate) != pid){
    164a:	fcc40513          	add	a0,s0,-52
    164e:	3ca030ef          	jal	4a18 <wait>
    1652:	02951b63          	bne	a0,s1,1688 <exitwait+0x62>
      if(i != xstate) {
    1656:	fcc42783          	lw	a5,-52(s0)
    165a:	05279163          	bne	a5,s2,169c <exitwait+0x76>
  for(i = 0; i < 100; i++){
    165e:	2905                	addw	s2,s2,1
    1660:	fd391fe3          	bne	s2,s3,163e <exitwait+0x18>
}
    1664:	70e2                	ld	ra,56(sp)
    1666:	7442                	ld	s0,48(sp)
    1668:	74a2                	ld	s1,40(sp)
    166a:	7902                	ld	s2,32(sp)
    166c:	69e2                	ld	s3,24(sp)
    166e:	6a42                	ld	s4,16(sp)
    1670:	6121                	add	sp,sp,64
    1672:	8082                	ret
      printf("%s: fork failed\n", s);
    1674:	85d2                	mv	a1,s4
    1676:	00004517          	auipc	a0,0x4
    167a:	21250513          	add	a0,a0,530 # 5888 <malloc+0x9aa>
    167e:	7ac030ef          	jal	4e2a <printf>
      exit(1);
    1682:	4505                	li	a0,1
    1684:	38c030ef          	jal	4a10 <exit>
        printf("%s: wait wrong pid\n", s);
    1688:	85d2                	mv	a1,s4
    168a:	00004517          	auipc	a0,0x4
    168e:	38650513          	add	a0,a0,902 # 5a10 <malloc+0xb32>
    1692:	798030ef          	jal	4e2a <printf>
        exit(1);
    1696:	4505                	li	a0,1
    1698:	378030ef          	jal	4a10 <exit>
        printf("%s: wait wrong exit status\n", s);
    169c:	85d2                	mv	a1,s4
    169e:	00004517          	auipc	a0,0x4
    16a2:	38a50513          	add	a0,a0,906 # 5a28 <malloc+0xb4a>
    16a6:	784030ef          	jal	4e2a <printf>
        exit(1);
    16aa:	4505                	li	a0,1
    16ac:	364030ef          	jal	4a10 <exit>
      exit(i);
    16b0:	854a                	mv	a0,s2
    16b2:	35e030ef          	jal	4a10 <exit>

00000000000016b6 <twochildren>:
{
    16b6:	1101                	add	sp,sp,-32
    16b8:	ec06                	sd	ra,24(sp)
    16ba:	e822                	sd	s0,16(sp)
    16bc:	e426                	sd	s1,8(sp)
    16be:	e04a                	sd	s2,0(sp)
    16c0:	1000                	add	s0,sp,32
    16c2:	892a                	mv	s2,a0
    16c4:	3e800493          	li	s1,1000
    int pid1 = fork();
    16c8:	340030ef          	jal	4a08 <fork>
    if(pid1 < 0){
    16cc:	02054663          	bltz	a0,16f8 <twochildren+0x42>
    if(pid1 == 0){
    16d0:	cd15                	beqz	a0,170c <twochildren+0x56>
      int pid2 = fork();
    16d2:	336030ef          	jal	4a08 <fork>
      if(pid2 < 0){
    16d6:	02054d63          	bltz	a0,1710 <twochildren+0x5a>
      if(pid2 == 0){
    16da:	c529                	beqz	a0,1724 <twochildren+0x6e>
        wait(0);
    16dc:	4501                	li	a0,0
    16de:	33a030ef          	jal	4a18 <wait>
        wait(0);
    16e2:	4501                	li	a0,0
    16e4:	334030ef          	jal	4a18 <wait>
  for(int i = 0; i < 1000; i++){
    16e8:	34fd                	addw	s1,s1,-1
    16ea:	fcf9                	bnez	s1,16c8 <twochildren+0x12>
}
    16ec:	60e2                	ld	ra,24(sp)
    16ee:	6442                	ld	s0,16(sp)
    16f0:	64a2                	ld	s1,8(sp)
    16f2:	6902                	ld	s2,0(sp)
    16f4:	6105                	add	sp,sp,32
    16f6:	8082                	ret
      printf("%s: fork failed\n", s);
    16f8:	85ca                	mv	a1,s2
    16fa:	00004517          	auipc	a0,0x4
    16fe:	18e50513          	add	a0,a0,398 # 5888 <malloc+0x9aa>
    1702:	728030ef          	jal	4e2a <printf>
      exit(1);
    1706:	4505                	li	a0,1
    1708:	308030ef          	jal	4a10 <exit>
      exit(0);
    170c:	304030ef          	jal	4a10 <exit>
        printf("%s: fork failed\n", s);
    1710:	85ca                	mv	a1,s2
    1712:	00004517          	auipc	a0,0x4
    1716:	17650513          	add	a0,a0,374 # 5888 <malloc+0x9aa>
    171a:	710030ef          	jal	4e2a <printf>
        exit(1);
    171e:	4505                	li	a0,1
    1720:	2f0030ef          	jal	4a10 <exit>
        exit(0);
    1724:	2ec030ef          	jal	4a10 <exit>

0000000000001728 <forkfork>:
{
    1728:	7179                	add	sp,sp,-48
    172a:	f406                	sd	ra,40(sp)
    172c:	f022                	sd	s0,32(sp)
    172e:	ec26                	sd	s1,24(sp)
    1730:	1800                	add	s0,sp,48
    1732:	84aa                	mv	s1,a0
    int pid = fork();
    1734:	2d4030ef          	jal	4a08 <fork>
    if(pid < 0){
    1738:	02054b63          	bltz	a0,176e <forkfork+0x46>
    if(pid == 0){
    173c:	c139                	beqz	a0,1782 <forkfork+0x5a>
    int pid = fork();
    173e:	2ca030ef          	jal	4a08 <fork>
    if(pid < 0){
    1742:	02054663          	bltz	a0,176e <forkfork+0x46>
    if(pid == 0){
    1746:	cd15                	beqz	a0,1782 <forkfork+0x5a>
    wait(&xstatus);
    1748:	fdc40513          	add	a0,s0,-36
    174c:	2cc030ef          	jal	4a18 <wait>
    if(xstatus != 0) {
    1750:	fdc42783          	lw	a5,-36(s0)
    1754:	ebb9                	bnez	a5,17aa <forkfork+0x82>
    wait(&xstatus);
    1756:	fdc40513          	add	a0,s0,-36
    175a:	2be030ef          	jal	4a18 <wait>
    if(xstatus != 0) {
    175e:	fdc42783          	lw	a5,-36(s0)
    1762:	e7a1                	bnez	a5,17aa <forkfork+0x82>
}
    1764:	70a2                	ld	ra,40(sp)
    1766:	7402                	ld	s0,32(sp)
    1768:	64e2                	ld	s1,24(sp)
    176a:	6145                	add	sp,sp,48
    176c:	8082                	ret
      printf("%s: fork failed", s);
    176e:	85a6                	mv	a1,s1
    1770:	00004517          	auipc	a0,0x4
    1774:	2d850513          	add	a0,a0,728 # 5a48 <malloc+0xb6a>
    1778:	6b2030ef          	jal	4e2a <printf>
      exit(1);
    177c:	4505                	li	a0,1
    177e:	292030ef          	jal	4a10 <exit>
{
    1782:	0c800493          	li	s1,200
        int pid1 = fork();
    1786:	282030ef          	jal	4a08 <fork>
        if(pid1 < 0){
    178a:	00054b63          	bltz	a0,17a0 <forkfork+0x78>
        if(pid1 == 0){
    178e:	cd01                	beqz	a0,17a6 <forkfork+0x7e>
        wait(0);
    1790:	4501                	li	a0,0
    1792:	286030ef          	jal	4a18 <wait>
      for(int j = 0; j < 200; j++){
    1796:	34fd                	addw	s1,s1,-1
    1798:	f4fd                	bnez	s1,1786 <forkfork+0x5e>
      exit(0);
    179a:	4501                	li	a0,0
    179c:	274030ef          	jal	4a10 <exit>
          exit(1);
    17a0:	4505                	li	a0,1
    17a2:	26e030ef          	jal	4a10 <exit>
          exit(0);
    17a6:	26a030ef          	jal	4a10 <exit>
      printf("%s: fork in child failed", s);
    17aa:	85a6                	mv	a1,s1
    17ac:	00004517          	auipc	a0,0x4
    17b0:	2ac50513          	add	a0,a0,684 # 5a58 <malloc+0xb7a>
    17b4:	676030ef          	jal	4e2a <printf>
      exit(1);
    17b8:	4505                	li	a0,1
    17ba:	256030ef          	jal	4a10 <exit>

00000000000017be <reparent2>:
{
    17be:	1101                	add	sp,sp,-32
    17c0:	ec06                	sd	ra,24(sp)
    17c2:	e822                	sd	s0,16(sp)
    17c4:	e426                	sd	s1,8(sp)
    17c6:	1000                	add	s0,sp,32
    17c8:	32000493          	li	s1,800
    int pid1 = fork();
    17cc:	23c030ef          	jal	4a08 <fork>
    if(pid1 < 0){
    17d0:	00054b63          	bltz	a0,17e6 <reparent2+0x28>
    if(pid1 == 0){
    17d4:	c115                	beqz	a0,17f8 <reparent2+0x3a>
    wait(0);
    17d6:	4501                	li	a0,0
    17d8:	240030ef          	jal	4a18 <wait>
  for(int i = 0; i < 800; i++){
    17dc:	34fd                	addw	s1,s1,-1
    17de:	f4fd                	bnez	s1,17cc <reparent2+0xe>
  exit(0);
    17e0:	4501                	li	a0,0
    17e2:	22e030ef          	jal	4a10 <exit>
      printf("fork failed\n");
    17e6:	00005517          	auipc	a0,0x5
    17ea:	61250513          	add	a0,a0,1554 # 6df8 <malloc+0x1f1a>
    17ee:	63c030ef          	jal	4e2a <printf>
      exit(1);
    17f2:	4505                	li	a0,1
    17f4:	21c030ef          	jal	4a10 <exit>
      fork();
    17f8:	210030ef          	jal	4a08 <fork>
      fork();
    17fc:	20c030ef          	jal	4a08 <fork>
      exit(0);
    1800:	4501                	li	a0,0
    1802:	20e030ef          	jal	4a10 <exit>

0000000000001806 <createdelete>:
{
    1806:	7175                	add	sp,sp,-144
    1808:	e506                	sd	ra,136(sp)
    180a:	e122                	sd	s0,128(sp)
    180c:	fca6                	sd	s1,120(sp)
    180e:	f8ca                	sd	s2,112(sp)
    1810:	f4ce                	sd	s3,104(sp)
    1812:	f0d2                	sd	s4,96(sp)
    1814:	ecd6                	sd	s5,88(sp)
    1816:	e8da                	sd	s6,80(sp)
    1818:	e4de                	sd	s7,72(sp)
    181a:	e0e2                	sd	s8,64(sp)
    181c:	fc66                	sd	s9,56(sp)
    181e:	0900                	add	s0,sp,144
    1820:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1822:	4901                	li	s2,0
    1824:	4991                	li	s3,4
    pid = fork();
    1826:	1e2030ef          	jal	4a08 <fork>
    182a:	84aa                	mv	s1,a0
    if(pid < 0){
    182c:	02054d63          	bltz	a0,1866 <createdelete+0x60>
    if(pid == 0){
    1830:	c529                	beqz	a0,187a <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    1832:	2905                	addw	s2,s2,1
    1834:	ff3919e3          	bne	s2,s3,1826 <createdelete+0x20>
    1838:	4491                	li	s1,4
    wait(&xstatus);
    183a:	f7c40513          	add	a0,s0,-132
    183e:	1da030ef          	jal	4a18 <wait>
    if(xstatus != 0)
    1842:	f7c42903          	lw	s2,-132(s0)
    1846:	0a091e63          	bnez	s2,1902 <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    184a:	34fd                	addw	s1,s1,-1
    184c:	f4fd                	bnez	s1,183a <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    184e:	f8040123          	sb	zero,-126(s0)
    1852:	03000993          	li	s3,48
    1856:	5a7d                	li	s4,-1
    1858:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    185c:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    185e:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1860:	07400a93          	li	s5,116
    1864:	a20d                	j	1986 <createdelete+0x180>
      printf("%s: fork failed\n", s);
    1866:	85e6                	mv	a1,s9
    1868:	00004517          	auipc	a0,0x4
    186c:	02050513          	add	a0,a0,32 # 5888 <malloc+0x9aa>
    1870:	5ba030ef          	jal	4e2a <printf>
      exit(1);
    1874:	4505                	li	a0,1
    1876:	19a030ef          	jal	4a10 <exit>
      name[0] = 'p' + pi;
    187a:	0709091b          	addw	s2,s2,112
    187e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1882:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1886:	4951                	li	s2,20
    1888:	a831                	j	18a4 <createdelete+0x9e>
          printf("%s: create failed\n", s);
    188a:	85e6                	mv	a1,s9
    188c:	00004517          	auipc	a0,0x4
    1890:	09450513          	add	a0,a0,148 # 5920 <malloc+0xa42>
    1894:	596030ef          	jal	4e2a <printf>
          exit(1);
    1898:	4505                	li	a0,1
    189a:	176030ef          	jal	4a10 <exit>
      for(i = 0; i < N; i++){
    189e:	2485                	addw	s1,s1,1
    18a0:	05248e63          	beq	s1,s2,18fc <createdelete+0xf6>
        name[1] = '0' + i;
    18a4:	0304879b          	addw	a5,s1,48
    18a8:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18ac:	20200593          	li	a1,514
    18b0:	f8040513          	add	a0,s0,-128
    18b4:	19c030ef          	jal	4a50 <open>
        if(fd < 0){
    18b8:	fc0549e3          	bltz	a0,188a <createdelete+0x84>
        close(fd);
    18bc:	17c030ef          	jal	4a38 <close>
        if(i > 0 && (i % 2 ) == 0){
    18c0:	fc905fe3          	blez	s1,189e <createdelete+0x98>
    18c4:	0014f793          	and	a5,s1,1
    18c8:	fbf9                	bnez	a5,189e <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18ca:	01f4d79b          	srlw	a5,s1,0x1f
    18ce:	9fa5                	addw	a5,a5,s1
    18d0:	4017d79b          	sraw	a5,a5,0x1
    18d4:	0307879b          	addw	a5,a5,48
    18d8:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    18dc:	f8040513          	add	a0,s0,-128
    18e0:	180030ef          	jal	4a60 <unlink>
    18e4:	fa055de3          	bgez	a0,189e <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    18e8:	85e6                	mv	a1,s9
    18ea:	00004517          	auipc	a0,0x4
    18ee:	18e50513          	add	a0,a0,398 # 5a78 <malloc+0xb9a>
    18f2:	538030ef          	jal	4e2a <printf>
            exit(1);
    18f6:	4505                	li	a0,1
    18f8:	118030ef          	jal	4a10 <exit>
      exit(0);
    18fc:	4501                	li	a0,0
    18fe:	112030ef          	jal	4a10 <exit>
      exit(1);
    1902:	4505                	li	a0,1
    1904:	10c030ef          	jal	4a10 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1908:	f8040613          	add	a2,s0,-128
    190c:	85e6                	mv	a1,s9
    190e:	00004517          	auipc	a0,0x4
    1912:	18250513          	add	a0,a0,386 # 5a90 <malloc+0xbb2>
    1916:	514030ef          	jal	4e2a <printf>
        exit(1);
    191a:	4505                	li	a0,1
    191c:	0f4030ef          	jal	4a10 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1920:	034b7d63          	bgeu	s6,s4,195a <createdelete+0x154>
      if(fd >= 0)
    1924:	02055863          	bgez	a0,1954 <createdelete+0x14e>
    for(pi = 0; pi < NCHILD; pi++){
    1928:	2485                	addw	s1,s1,1
    192a:	0ff4f493          	zext.b	s1,s1
    192e:	05548463          	beq	s1,s5,1976 <createdelete+0x170>
      name[0] = 'p' + pi;
    1932:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1936:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    193a:	4581                	li	a1,0
    193c:	f8040513          	add	a0,s0,-128
    1940:	110030ef          	jal	4a50 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1944:	00090463          	beqz	s2,194c <createdelete+0x146>
    1948:	fd2bdce3          	bge	s7,s2,1920 <createdelete+0x11a>
    194c:	fa054ee3          	bltz	a0,1908 <createdelete+0x102>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1950:	014b7763          	bgeu	s6,s4,195e <createdelete+0x158>
        close(fd);
    1954:	0e4030ef          	jal	4a38 <close>
    1958:	bfc1                	j	1928 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    195a:	fc0547e3          	bltz	a0,1928 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    195e:	f8040613          	add	a2,s0,-128
    1962:	85e6                	mv	a1,s9
    1964:	00004517          	auipc	a0,0x4
    1968:	15450513          	add	a0,a0,340 # 5ab8 <malloc+0xbda>
    196c:	4be030ef          	jal	4e2a <printf>
        exit(1);
    1970:	4505                	li	a0,1
    1972:	09e030ef          	jal	4a10 <exit>
  for(i = 0; i < N; i++){
    1976:	2905                	addw	s2,s2,1
    1978:	2a05                	addw	s4,s4,1
    197a:	2985                	addw	s3,s3,1 # 3001 <subdir+0x473>
    197c:	0ff9f993          	zext.b	s3,s3
    1980:	47d1                	li	a5,20
    1982:	02f90863          	beq	s2,a5,19b2 <createdelete+0x1ac>
    for(pi = 0; pi < NCHILD; pi++){
    1986:	84e2                	mv	s1,s8
    1988:	b76d                	j	1932 <createdelete+0x12c>
  for(i = 0; i < N; i++){
    198a:	2905                	addw	s2,s2,1
    198c:	0ff97913          	zext.b	s2,s2
    1990:	03490a63          	beq	s2,s4,19c4 <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    1994:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    1996:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    199a:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    199e:	f8040513          	add	a0,s0,-128
    19a2:	0be030ef          	jal	4a60 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19a6:	2485                	addw	s1,s1,1
    19a8:	0ff4f493          	zext.b	s1,s1
    19ac:	ff3495e3          	bne	s1,s3,1996 <createdelete+0x190>
    19b0:	bfe9                	j	198a <createdelete+0x184>
    19b2:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19b6:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19ba:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19be:	04400a13          	li	s4,68
    19c2:	bfc9                	j	1994 <createdelete+0x18e>
}
    19c4:	60aa                	ld	ra,136(sp)
    19c6:	640a                	ld	s0,128(sp)
    19c8:	74e6                	ld	s1,120(sp)
    19ca:	7946                	ld	s2,112(sp)
    19cc:	79a6                	ld	s3,104(sp)
    19ce:	7a06                	ld	s4,96(sp)
    19d0:	6ae6                	ld	s5,88(sp)
    19d2:	6b46                	ld	s6,80(sp)
    19d4:	6ba6                	ld	s7,72(sp)
    19d6:	6c06                	ld	s8,64(sp)
    19d8:	7ce2                	ld	s9,56(sp)
    19da:	6149                	add	sp,sp,144
    19dc:	8082                	ret

00000000000019de <linkunlink>:
{
    19de:	711d                	add	sp,sp,-96
    19e0:	ec86                	sd	ra,88(sp)
    19e2:	e8a2                	sd	s0,80(sp)
    19e4:	e4a6                	sd	s1,72(sp)
    19e6:	e0ca                	sd	s2,64(sp)
    19e8:	fc4e                	sd	s3,56(sp)
    19ea:	f852                	sd	s4,48(sp)
    19ec:	f456                	sd	s5,40(sp)
    19ee:	f05a                	sd	s6,32(sp)
    19f0:	ec5e                	sd	s7,24(sp)
    19f2:	e862                	sd	s8,16(sp)
    19f4:	e466                	sd	s9,8(sp)
    19f6:	1080                	add	s0,sp,96
    19f8:	84aa                	mv	s1,a0
  unlink("x");
    19fa:	00003517          	auipc	a0,0x3
    19fe:	66e50513          	add	a0,a0,1646 # 5068 <malloc+0x18a>
    1a02:	05e030ef          	jal	4a60 <unlink>
  pid = fork();
    1a06:	002030ef          	jal	4a08 <fork>
  if(pid < 0){
    1a0a:	02054b63          	bltz	a0,1a40 <linkunlink+0x62>
    1a0e:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1a10:	06100c93          	li	s9,97
    1a14:	c111                	beqz	a0,1a18 <linkunlink+0x3a>
    1a16:	4c85                	li	s9,1
    1a18:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a1c:	41c659b7          	lui	s3,0x41c65
    1a20:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <base+0x41c561f5>
    1a24:	690d                	lui	s2,0x3
    1a26:	0399091b          	addw	s2,s2,57 # 3039 <subdir+0x4ab>
    if((x % 3) == 0){
    1a2a:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1a2c:	4b05                	li	s6,1
      unlink("x");
    1a2e:	00003a97          	auipc	s5,0x3
    1a32:	63aa8a93          	add	s5,s5,1594 # 5068 <malloc+0x18a>
      link("cat", "x");
    1a36:	00004b97          	auipc	s7,0x4
    1a3a:	0aab8b93          	add	s7,s7,170 # 5ae0 <malloc+0xc02>
    1a3e:	a025                	j	1a66 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a40:	85a6                	mv	a1,s1
    1a42:	00004517          	auipc	a0,0x4
    1a46:	e4650513          	add	a0,a0,-442 # 5888 <malloc+0x9aa>
    1a4a:	3e0030ef          	jal	4e2a <printf>
    exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	7c1020ef          	jal	4a10 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a54:	20200593          	li	a1,514
    1a58:	8556                	mv	a0,s5
    1a5a:	7f7020ef          	jal	4a50 <open>
    1a5e:	7db020ef          	jal	4a38 <close>
  for(i = 0; i < 100; i++){
    1a62:	34fd                	addw	s1,s1,-1
    1a64:	c48d                	beqz	s1,1a8e <linkunlink+0xb0>
    x = x * 1103515245 + 12345;
    1a66:	033c87bb          	mulw	a5,s9,s3
    1a6a:	012787bb          	addw	a5,a5,s2
    1a6e:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1a72:	0347f7bb          	remuw	a5,a5,s4
    1a76:	dff9                	beqz	a5,1a54 <linkunlink+0x76>
    } else if((x % 3) == 1){
    1a78:	01678663          	beq	a5,s6,1a84 <linkunlink+0xa6>
      unlink("x");
    1a7c:	8556                	mv	a0,s5
    1a7e:	7e3020ef          	jal	4a60 <unlink>
    1a82:	b7c5                	j	1a62 <linkunlink+0x84>
      link("cat", "x");
    1a84:	85d6                	mv	a1,s5
    1a86:	855e                	mv	a0,s7
    1a88:	7e9020ef          	jal	4a70 <link>
    1a8c:	bfd9                	j	1a62 <linkunlink+0x84>
  if(pid)
    1a8e:	020c0263          	beqz	s8,1ab2 <linkunlink+0xd4>
    wait(0);
    1a92:	4501                	li	a0,0
    1a94:	785020ef          	jal	4a18 <wait>
}
    1a98:	60e6                	ld	ra,88(sp)
    1a9a:	6446                	ld	s0,80(sp)
    1a9c:	64a6                	ld	s1,72(sp)
    1a9e:	6906                	ld	s2,64(sp)
    1aa0:	79e2                	ld	s3,56(sp)
    1aa2:	7a42                	ld	s4,48(sp)
    1aa4:	7aa2                	ld	s5,40(sp)
    1aa6:	7b02                	ld	s6,32(sp)
    1aa8:	6be2                	ld	s7,24(sp)
    1aaa:	6c42                	ld	s8,16(sp)
    1aac:	6ca2                	ld	s9,8(sp)
    1aae:	6125                	add	sp,sp,96
    1ab0:	8082                	ret
    exit(0);
    1ab2:	4501                	li	a0,0
    1ab4:	75d020ef          	jal	4a10 <exit>

0000000000001ab8 <forktest>:
{
    1ab8:	7179                	add	sp,sp,-48
    1aba:	f406                	sd	ra,40(sp)
    1abc:	f022                	sd	s0,32(sp)
    1abe:	ec26                	sd	s1,24(sp)
    1ac0:	e84a                	sd	s2,16(sp)
    1ac2:	e44e                	sd	s3,8(sp)
    1ac4:	1800                	add	s0,sp,48
    1ac6:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ac8:	4481                	li	s1,0
    1aca:	3e800913          	li	s2,1000
    pid = fork();
    1ace:	73b020ef          	jal	4a08 <fork>
    if(pid < 0)
    1ad2:	02054263          	bltz	a0,1af6 <forktest+0x3e>
    if(pid == 0)
    1ad6:	cd11                	beqz	a0,1af2 <forktest+0x3a>
  for(n=0; n<N; n++){
    1ad8:	2485                	addw	s1,s1,1
    1ada:	ff249ae3          	bne	s1,s2,1ace <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ade:	85ce                	mv	a1,s3
    1ae0:	00004517          	auipc	a0,0x4
    1ae4:	02050513          	add	a0,a0,32 # 5b00 <malloc+0xc22>
    1ae8:	342030ef          	jal	4e2a <printf>
    exit(1);
    1aec:	4505                	li	a0,1
    1aee:	723020ef          	jal	4a10 <exit>
      exit(0);
    1af2:	71f020ef          	jal	4a10 <exit>
  if (n == 0) {
    1af6:	c89d                	beqz	s1,1b2c <forktest+0x74>
  if(n == N){
    1af8:	3e800793          	li	a5,1000
    1afc:	fef481e3          	beq	s1,a5,1ade <forktest+0x26>
  for(; n > 0; n--){
    1b00:	00905963          	blez	s1,1b12 <forktest+0x5a>
    if(wait(0) < 0){
    1b04:	4501                	li	a0,0
    1b06:	713020ef          	jal	4a18 <wait>
    1b0a:	02054b63          	bltz	a0,1b40 <forktest+0x88>
  for(; n > 0; n--){
    1b0e:	34fd                	addw	s1,s1,-1
    1b10:	f8f5                	bnez	s1,1b04 <forktest+0x4c>
  if(wait(0) != -1){
    1b12:	4501                	li	a0,0
    1b14:	705020ef          	jal	4a18 <wait>
    1b18:	57fd                	li	a5,-1
    1b1a:	02f51d63          	bne	a0,a5,1b54 <forktest+0x9c>
}
    1b1e:	70a2                	ld	ra,40(sp)
    1b20:	7402                	ld	s0,32(sp)
    1b22:	64e2                	ld	s1,24(sp)
    1b24:	6942                	ld	s2,16(sp)
    1b26:	69a2                	ld	s3,8(sp)
    1b28:	6145                	add	sp,sp,48
    1b2a:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1b2c:	85ce                	mv	a1,s3
    1b2e:	00004517          	auipc	a0,0x4
    1b32:	fba50513          	add	a0,a0,-70 # 5ae8 <malloc+0xc0a>
    1b36:	2f4030ef          	jal	4e2a <printf>
    exit(1);
    1b3a:	4505                	li	a0,1
    1b3c:	6d5020ef          	jal	4a10 <exit>
      printf("%s: wait stopped early\n", s);
    1b40:	85ce                	mv	a1,s3
    1b42:	00004517          	auipc	a0,0x4
    1b46:	fe650513          	add	a0,a0,-26 # 5b28 <malloc+0xc4a>
    1b4a:	2e0030ef          	jal	4e2a <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	6c1020ef          	jal	4a10 <exit>
    printf("%s: wait got too many\n", s);
    1b54:	85ce                	mv	a1,s3
    1b56:	00004517          	auipc	a0,0x4
    1b5a:	fea50513          	add	a0,a0,-22 # 5b40 <malloc+0xc62>
    1b5e:	2cc030ef          	jal	4e2a <printf>
    exit(1);
    1b62:	4505                	li	a0,1
    1b64:	6ad020ef          	jal	4a10 <exit>

0000000000001b68 <kernmem>:
{
    1b68:	715d                	add	sp,sp,-80
    1b6a:	e486                	sd	ra,72(sp)
    1b6c:	e0a2                	sd	s0,64(sp)
    1b6e:	fc26                	sd	s1,56(sp)
    1b70:	f84a                	sd	s2,48(sp)
    1b72:	f44e                	sd	s3,40(sp)
    1b74:	f052                	sd	s4,32(sp)
    1b76:	ec56                	sd	s5,24(sp)
    1b78:	0880                	add	s0,sp,80
    1b7a:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b7c:	4485                	li	s1,1
    1b7e:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  /* did kernel kill child? */
    1b80:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b82:	69b1                	lui	s3,0xc
    1b84:	35098993          	add	s3,s3,848 # c350 <buf+0x6d8>
    1b88:	1003d937          	lui	s2,0x1003d
    1b8c:	090e                	sll	s2,s2,0x3
    1b8e:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002e808>
    pid = fork();
    1b92:	677020ef          	jal	4a08 <fork>
    if(pid < 0){
    1b96:	02054763          	bltz	a0,1bc4 <kernmem+0x5c>
    if(pid == 0){
    1b9a:	cd1d                	beqz	a0,1bd8 <kernmem+0x70>
    wait(&xstatus);
    1b9c:	fbc40513          	add	a0,s0,-68
    1ba0:	679020ef          	jal	4a18 <wait>
    if(xstatus != -1)  /* did kernel kill child? */
    1ba4:	fbc42783          	lw	a5,-68(s0)
    1ba8:	05579563          	bne	a5,s5,1bf2 <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bac:	94ce                	add	s1,s1,s3
    1bae:	ff2492e3          	bne	s1,s2,1b92 <kernmem+0x2a>
}
    1bb2:	60a6                	ld	ra,72(sp)
    1bb4:	6406                	ld	s0,64(sp)
    1bb6:	74e2                	ld	s1,56(sp)
    1bb8:	7942                	ld	s2,48(sp)
    1bba:	79a2                	ld	s3,40(sp)
    1bbc:	7a02                	ld	s4,32(sp)
    1bbe:	6ae2                	ld	s5,24(sp)
    1bc0:	6161                	add	sp,sp,80
    1bc2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bc4:	85d2                	mv	a1,s4
    1bc6:	00004517          	auipc	a0,0x4
    1bca:	cc250513          	add	a0,a0,-830 # 5888 <malloc+0x9aa>
    1bce:	25c030ef          	jal	4e2a <printf>
      exit(1);
    1bd2:	4505                	li	a0,1
    1bd4:	63d020ef          	jal	4a10 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1bd8:	0004c683          	lbu	a3,0(s1)
    1bdc:	8626                	mv	a2,s1
    1bde:	85d2                	mv	a1,s4
    1be0:	00004517          	auipc	a0,0x4
    1be4:	f7850513          	add	a0,a0,-136 # 5b58 <malloc+0xc7a>
    1be8:	242030ef          	jal	4e2a <printf>
      exit(1);
    1bec:	4505                	li	a0,1
    1bee:	623020ef          	jal	4a10 <exit>
      exit(1);
    1bf2:	4505                	li	a0,1
    1bf4:	61d020ef          	jal	4a10 <exit>

0000000000001bf8 <MAXVAplus>:
{
    1bf8:	7179                	add	sp,sp,-48
    1bfa:	f406                	sd	ra,40(sp)
    1bfc:	f022                	sd	s0,32(sp)
    1bfe:	ec26                	sd	s1,24(sp)
    1c00:	e84a                	sd	s2,16(sp)
    1c02:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    1c04:	4785                	li	a5,1
    1c06:	179a                	sll	a5,a5,0x26
    1c08:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c0c:	fd843783          	ld	a5,-40(s0)
    1c10:	cb85                	beqz	a5,1c40 <MAXVAplus+0x48>
    1c12:	892a                	mv	s2,a0
    if(xstatus != -1)  /* did kernel kill child? */
    1c14:	54fd                	li	s1,-1
    pid = fork();
    1c16:	5f3020ef          	jal	4a08 <fork>
    if(pid < 0){
    1c1a:	02054963          	bltz	a0,1c4c <MAXVAplus+0x54>
    if(pid == 0){
    1c1e:	c129                	beqz	a0,1c60 <MAXVAplus+0x68>
    wait(&xstatus);
    1c20:	fd440513          	add	a0,s0,-44
    1c24:	5f5020ef          	jal	4a18 <wait>
    if(xstatus != -1)  /* did kernel kill child? */
    1c28:	fd442783          	lw	a5,-44(s0)
    1c2c:	04979c63          	bne	a5,s1,1c84 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c30:	fd843783          	ld	a5,-40(s0)
    1c34:	0786                	sll	a5,a5,0x1
    1c36:	fcf43c23          	sd	a5,-40(s0)
    1c3a:	fd843783          	ld	a5,-40(s0)
    1c3e:	ffe1                	bnez	a5,1c16 <MAXVAplus+0x1e>
}
    1c40:	70a2                	ld	ra,40(sp)
    1c42:	7402                	ld	s0,32(sp)
    1c44:	64e2                	ld	s1,24(sp)
    1c46:	6942                	ld	s2,16(sp)
    1c48:	6145                	add	sp,sp,48
    1c4a:	8082                	ret
      printf("%s: fork failed\n", s);
    1c4c:	85ca                	mv	a1,s2
    1c4e:	00004517          	auipc	a0,0x4
    1c52:	c3a50513          	add	a0,a0,-966 # 5888 <malloc+0x9aa>
    1c56:	1d4030ef          	jal	4e2a <printf>
      exit(1);
    1c5a:	4505                	li	a0,1
    1c5c:	5b5020ef          	jal	4a10 <exit>
      *(char*)a = 99;
    1c60:	fd843783          	ld	a5,-40(s0)
    1c64:	06300713          	li	a4,99
    1c68:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c6c:	fd843603          	ld	a2,-40(s0)
    1c70:	85ca                	mv	a1,s2
    1c72:	00004517          	auipc	a0,0x4
    1c76:	f0650513          	add	a0,a0,-250 # 5b78 <malloc+0xc9a>
    1c7a:	1b0030ef          	jal	4e2a <printf>
      exit(1);
    1c7e:	4505                	li	a0,1
    1c80:	591020ef          	jal	4a10 <exit>
      exit(1);
    1c84:	4505                	li	a0,1
    1c86:	58b020ef          	jal	4a10 <exit>

0000000000001c8a <stacktest>:
{
    1c8a:	7179                	add	sp,sp,-48
    1c8c:	f406                	sd	ra,40(sp)
    1c8e:	f022                	sd	s0,32(sp)
    1c90:	ec26                	sd	s1,24(sp)
    1c92:	1800                	add	s0,sp,48
    1c94:	84aa                	mv	s1,a0
  pid = fork();
    1c96:	573020ef          	jal	4a08 <fork>
  if(pid == 0) {
    1c9a:	cd11                	beqz	a0,1cb6 <stacktest+0x2c>
  } else if(pid < 0){
    1c9c:	02054c63          	bltz	a0,1cd4 <stacktest+0x4a>
  wait(&xstatus);
    1ca0:	fdc40513          	add	a0,s0,-36
    1ca4:	575020ef          	jal	4a18 <wait>
  if(xstatus == -1)  /* kernel killed child? */
    1ca8:	fdc42503          	lw	a0,-36(s0)
    1cac:	57fd                	li	a5,-1
    1cae:	02f50d63          	beq	a0,a5,1ce8 <stacktest+0x5e>
    exit(xstatus);
    1cb2:	55f020ef          	jal	4a10 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cb6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cb8:	77fd                	lui	a5,0xfffff
    1cba:	97ba                	add	a5,a5,a4
    1cbc:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0388>
    1cc0:	85a6                	mv	a1,s1
    1cc2:	00004517          	auipc	a0,0x4
    1cc6:	ece50513          	add	a0,a0,-306 # 5b90 <malloc+0xcb2>
    1cca:	160030ef          	jal	4e2a <printf>
    exit(1);
    1cce:	4505                	li	a0,1
    1cd0:	541020ef          	jal	4a10 <exit>
    printf("%s: fork failed\n", s);
    1cd4:	85a6                	mv	a1,s1
    1cd6:	00004517          	auipc	a0,0x4
    1cda:	bb250513          	add	a0,a0,-1102 # 5888 <malloc+0x9aa>
    1cde:	14c030ef          	jal	4e2a <printf>
    exit(1);
    1ce2:	4505                	li	a0,1
    1ce4:	52d020ef          	jal	4a10 <exit>
    exit(0);
    1ce8:	4501                	li	a0,0
    1cea:	527020ef          	jal	4a10 <exit>

0000000000001cee <nowrite>:
{
    1cee:	7159                	add	sp,sp,-112
    1cf0:	f486                	sd	ra,104(sp)
    1cf2:	f0a2                	sd	s0,96(sp)
    1cf4:	eca6                	sd	s1,88(sp)
    1cf6:	e8ca                	sd	s2,80(sp)
    1cf8:	e4ce                	sd	s3,72(sp)
    1cfa:	1880                	add	s0,sp,112
    1cfc:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1cfe:	00005797          	auipc	a5,0x5
    1d02:	65278793          	add	a5,a5,1618 # 7350 <malloc+0x2472>
    1d06:	7788                	ld	a0,40(a5)
    1d08:	7b8c                	ld	a1,48(a5)
    1d0a:	7f90                	ld	a2,56(a5)
    1d0c:	63b4                	ld	a3,64(a5)
    1d0e:	67b8                	ld	a4,72(a5)
    1d10:	6bbc                	ld	a5,80(a5)
    1d12:	f8a43c23          	sd	a0,-104(s0)
    1d16:	fab43023          	sd	a1,-96(s0)
    1d1a:	fac43423          	sd	a2,-88(s0)
    1d1e:	fad43823          	sd	a3,-80(s0)
    1d22:	fae43c23          	sd	a4,-72(s0)
    1d26:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d2a:	4481                	li	s1,0
    1d2c:	4919                	li	s2,6
    pid = fork();
    1d2e:	4db020ef          	jal	4a08 <fork>
    if(pid == 0) {
    1d32:	c105                	beqz	a0,1d52 <nowrite+0x64>
    } else if(pid < 0){
    1d34:	04054263          	bltz	a0,1d78 <nowrite+0x8a>
    wait(&xstatus);
    1d38:	fcc40513          	add	a0,s0,-52
    1d3c:	4dd020ef          	jal	4a18 <wait>
    if(xstatus == 0){
    1d40:	fcc42783          	lw	a5,-52(s0)
    1d44:	c7a1                	beqz	a5,1d8c <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d46:	2485                	addw	s1,s1,1
    1d48:	ff2493e3          	bne	s1,s2,1d2e <nowrite+0x40>
  exit(0);
    1d4c:	4501                	li	a0,0
    1d4e:	4c3020ef          	jal	4a10 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d52:	048e                	sll	s1,s1,0x3
    1d54:	fd048793          	add	a5,s1,-48
    1d58:	008784b3          	add	s1,a5,s0
    1d5c:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d60:	47a9                	li	a5,10
    1d62:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d64:	85ce                	mv	a1,s3
    1d66:	00004517          	auipc	a0,0x4
    1d6a:	e5250513          	add	a0,a0,-430 # 5bb8 <malloc+0xcda>
    1d6e:	0bc030ef          	jal	4e2a <printf>
      exit(0);
    1d72:	4501                	li	a0,0
    1d74:	49d020ef          	jal	4a10 <exit>
      printf("%s: fork failed\n", s);
    1d78:	85ce                	mv	a1,s3
    1d7a:	00004517          	auipc	a0,0x4
    1d7e:	b0e50513          	add	a0,a0,-1266 # 5888 <malloc+0x9aa>
    1d82:	0a8030ef          	jal	4e2a <printf>
      exit(1);
    1d86:	4505                	li	a0,1
    1d88:	489020ef          	jal	4a10 <exit>
      exit(1);
    1d8c:	4505                	li	a0,1
    1d8e:	483020ef          	jal	4a10 <exit>

0000000000001d92 <manywrites>:
{
    1d92:	711d                	add	sp,sp,-96
    1d94:	ec86                	sd	ra,88(sp)
    1d96:	e8a2                	sd	s0,80(sp)
    1d98:	e4a6                	sd	s1,72(sp)
    1d9a:	e0ca                	sd	s2,64(sp)
    1d9c:	fc4e                	sd	s3,56(sp)
    1d9e:	f852                	sd	s4,48(sp)
    1da0:	f456                	sd	s5,40(sp)
    1da2:	f05a                	sd	s6,32(sp)
    1da4:	ec5e                	sd	s7,24(sp)
    1da6:	1080                	add	s0,sp,96
    1da8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1daa:	4981                	li	s3,0
    1dac:	4911                	li	s2,4
    int pid = fork();
    1dae:	45b020ef          	jal	4a08 <fork>
    1db2:	84aa                	mv	s1,a0
    if(pid < 0){
    1db4:	02054563          	bltz	a0,1dde <manywrites+0x4c>
    if(pid == 0){
    1db8:	cd05                	beqz	a0,1df0 <manywrites+0x5e>
  for(int ci = 0; ci < nchildren; ci++){
    1dba:	2985                	addw	s3,s3,1
    1dbc:	ff2999e3          	bne	s3,s2,1dae <manywrites+0x1c>
    1dc0:	4491                	li	s1,4
    int st = 0;
    1dc2:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dc6:	fa840513          	add	a0,s0,-88
    1dca:	44f020ef          	jal	4a18 <wait>
    if(st != 0)
    1dce:	fa842503          	lw	a0,-88(s0)
    1dd2:	e169                	bnez	a0,1e94 <manywrites+0x102>
  for(int ci = 0; ci < nchildren; ci++){
    1dd4:	34fd                	addw	s1,s1,-1
    1dd6:	f4f5                	bnez	s1,1dc2 <manywrites+0x30>
  exit(0);
    1dd8:	4501                	li	a0,0
    1dda:	437020ef          	jal	4a10 <exit>
      printf("fork failed\n");
    1dde:	00005517          	auipc	a0,0x5
    1de2:	01a50513          	add	a0,a0,26 # 6df8 <malloc+0x1f1a>
    1de6:	044030ef          	jal	4e2a <printf>
      exit(1);
    1dea:	4505                	li	a0,1
    1dec:	425020ef          	jal	4a10 <exit>
      name[0] = 'b';
    1df0:	06200793          	li	a5,98
    1df4:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1df8:	0619879b          	addw	a5,s3,97
    1dfc:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e00:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e04:	fa840513          	add	a0,s0,-88
    1e08:	459020ef          	jal	4a60 <unlink>
    1e0c:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e0e:	0000ab17          	auipc	s6,0xa
    1e12:	e6ab0b13          	add	s6,s6,-406 # bc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e16:	8a26                	mv	s4,s1
    1e18:	0209c863          	bltz	s3,1e48 <manywrites+0xb6>
          int fd = open(name, O_CREATE | O_RDWR);
    1e1c:	20200593          	li	a1,514
    1e20:	fa840513          	add	a0,s0,-88
    1e24:	42d020ef          	jal	4a50 <open>
    1e28:	892a                	mv	s2,a0
          if(fd < 0){
    1e2a:	02054d63          	bltz	a0,1e64 <manywrites+0xd2>
          int cc = write(fd, buf, sz);
    1e2e:	660d                	lui	a2,0x3
    1e30:	85da                	mv	a1,s6
    1e32:	3ff020ef          	jal	4a30 <write>
          if(cc != sz){
    1e36:	678d                	lui	a5,0x3
    1e38:	04f51263          	bne	a0,a5,1e7c <manywrites+0xea>
          close(fd);
    1e3c:	854a                	mv	a0,s2
    1e3e:	3fb020ef          	jal	4a38 <close>
        for(int i = 0; i < ci+1; i++){
    1e42:	2a05                	addw	s4,s4,1
    1e44:	fd49dce3          	bge	s3,s4,1e1c <manywrites+0x8a>
        unlink(name);
    1e48:	fa840513          	add	a0,s0,-88
    1e4c:	415020ef          	jal	4a60 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e50:	3bfd                	addw	s7,s7,-1
    1e52:	fc0b92e3          	bnez	s7,1e16 <manywrites+0x84>
      unlink(name);
    1e56:	fa840513          	add	a0,s0,-88
    1e5a:	407020ef          	jal	4a60 <unlink>
      exit(0);
    1e5e:	4501                	li	a0,0
    1e60:	3b1020ef          	jal	4a10 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e64:	fa840613          	add	a2,s0,-88
    1e68:	85d6                	mv	a1,s5
    1e6a:	00004517          	auipc	a0,0x4
    1e6e:	d6e50513          	add	a0,a0,-658 # 5bd8 <malloc+0xcfa>
    1e72:	7b9020ef          	jal	4e2a <printf>
            exit(1);
    1e76:	4505                	li	a0,1
    1e78:	399020ef          	jal	4a10 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e7c:	86aa                	mv	a3,a0
    1e7e:	660d                	lui	a2,0x3
    1e80:	85d6                	mv	a1,s5
    1e82:	00003517          	auipc	a0,0x3
    1e86:	24650513          	add	a0,a0,582 # 50c8 <malloc+0x1ea>
    1e8a:	7a1020ef          	jal	4e2a <printf>
            exit(1);
    1e8e:	4505                	li	a0,1
    1e90:	381020ef          	jal	4a10 <exit>
      exit(st);
    1e94:	37d020ef          	jal	4a10 <exit>

0000000000001e98 <copyinstr3>:
{
    1e98:	7179                	add	sp,sp,-48
    1e9a:	f406                	sd	ra,40(sp)
    1e9c:	f022                	sd	s0,32(sp)
    1e9e:	ec26                	sd	s1,24(sp)
    1ea0:	1800                	add	s0,sp,48
  sbrk(8192);
    1ea2:	6509                	lui	a0,0x2
    1ea4:	3f5020ef          	jal	4a98 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1ea8:	4501                	li	a0,0
    1eaa:	3ef020ef          	jal	4a98 <sbrk>
  if((top % PGSIZE) != 0){
    1eae:	03451793          	sll	a5,a0,0x34
    1eb2:	e7bd                	bnez	a5,1f20 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eb4:	4501                	li	a0,0
    1eb6:	3e3020ef          	jal	4a98 <sbrk>
  if(top % PGSIZE){
    1eba:	03451793          	sll	a5,a0,0x34
    1ebe:	ebad                	bnez	a5,1f30 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ec0:	fff50493          	add	s1,a0,-1 # 1fff <rwsbrk+0x63>
  *b = 'x';
    1ec4:	07800793          	li	a5,120
    1ec8:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1ecc:	8526                	mv	a0,s1
    1ece:	393020ef          	jal	4a60 <unlink>
  if(ret != -1){
    1ed2:	57fd                	li	a5,-1
    1ed4:	06f51763          	bne	a0,a5,1f42 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ed8:	20100593          	li	a1,513
    1edc:	8526                	mv	a0,s1
    1ede:	373020ef          	jal	4a50 <open>
  if(fd != -1){
    1ee2:	57fd                	li	a5,-1
    1ee4:	06f51a63          	bne	a0,a5,1f58 <copyinstr3+0xc0>
  ret = link(b, b);
    1ee8:	85a6                	mv	a1,s1
    1eea:	8526                	mv	a0,s1
    1eec:	385020ef          	jal	4a70 <link>
  if(ret != -1){
    1ef0:	57fd                	li	a5,-1
    1ef2:	06f51e63          	bne	a0,a5,1f6e <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1ef6:	00005797          	auipc	a5,0x5
    1efa:	9e278793          	add	a5,a5,-1566 # 68d8 <malloc+0x19fa>
    1efe:	fcf43823          	sd	a5,-48(s0)
    1f02:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f06:	fd040593          	add	a1,s0,-48
    1f0a:	8526                	mv	a0,s1
    1f0c:	33d020ef          	jal	4a48 <exec>
  if(ret != -1){
    1f10:	57fd                	li	a5,-1
    1f12:	06f51a63          	bne	a0,a5,1f86 <copyinstr3+0xee>
}
    1f16:	70a2                	ld	ra,40(sp)
    1f18:	7402                	ld	s0,32(sp)
    1f1a:	64e2                	ld	s1,24(sp)
    1f1c:	6145                	add	sp,sp,48
    1f1e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f20:	0347d513          	srl	a0,a5,0x34
    1f24:	6785                	lui	a5,0x1
    1f26:	40a7853b          	subw	a0,a5,a0
    1f2a:	36f020ef          	jal	4a98 <sbrk>
    1f2e:	b759                	j	1eb4 <copyinstr3+0x1c>
    printf("oops\n");
    1f30:	00004517          	auipc	a0,0x4
    1f34:	cc050513          	add	a0,a0,-832 # 5bf0 <malloc+0xd12>
    1f38:	6f3020ef          	jal	4e2a <printf>
    exit(1);
    1f3c:	4505                	li	a0,1
    1f3e:	2d3020ef          	jal	4a10 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f42:	862a                	mv	a2,a0
    1f44:	85a6                	mv	a1,s1
    1f46:	00004517          	auipc	a0,0x4
    1f4a:	86250513          	add	a0,a0,-1950 # 57a8 <malloc+0x8ca>
    1f4e:	6dd020ef          	jal	4e2a <printf>
    exit(1);
    1f52:	4505                	li	a0,1
    1f54:	2bd020ef          	jal	4a10 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f58:	862a                	mv	a2,a0
    1f5a:	85a6                	mv	a1,s1
    1f5c:	00004517          	auipc	a0,0x4
    1f60:	86c50513          	add	a0,a0,-1940 # 57c8 <malloc+0x8ea>
    1f64:	6c7020ef          	jal	4e2a <printf>
    exit(1);
    1f68:	4505                	li	a0,1
    1f6a:	2a7020ef          	jal	4a10 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f6e:	86aa                	mv	a3,a0
    1f70:	8626                	mv	a2,s1
    1f72:	85a6                	mv	a1,s1
    1f74:	00004517          	auipc	a0,0x4
    1f78:	87450513          	add	a0,a0,-1932 # 57e8 <malloc+0x90a>
    1f7c:	6af020ef          	jal	4e2a <printf>
    exit(1);
    1f80:	4505                	li	a0,1
    1f82:	28f020ef          	jal	4a10 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f86:	567d                	li	a2,-1
    1f88:	85a6                	mv	a1,s1
    1f8a:	00004517          	auipc	a0,0x4
    1f8e:	88650513          	add	a0,a0,-1914 # 5810 <malloc+0x932>
    1f92:	699020ef          	jal	4e2a <printf>
    exit(1);
    1f96:	4505                	li	a0,1
    1f98:	279020ef          	jal	4a10 <exit>

0000000000001f9c <rwsbrk>:
{
    1f9c:	1101                	add	sp,sp,-32
    1f9e:	ec06                	sd	ra,24(sp)
    1fa0:	e822                	sd	s0,16(sp)
    1fa2:	e426                	sd	s1,8(sp)
    1fa4:	e04a                	sd	s2,0(sp)
    1fa6:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fa8:	6509                	lui	a0,0x2
    1faa:	2ef020ef          	jal	4a98 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1fae:	57fd                	li	a5,-1
    1fb0:	04f50863          	beq	a0,a5,2000 <rwsbrk+0x64>
    1fb4:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1fb6:	7579                	lui	a0,0xffffe
    1fb8:	2e1020ef          	jal	4a98 <sbrk>
    1fbc:	57fd                	li	a5,-1
    1fbe:	04f50a63          	beq	a0,a5,2012 <rwsbrk+0x76>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1fc2:	20100593          	li	a1,513
    1fc6:	00004517          	auipc	a0,0x4
    1fca:	c6a50513          	add	a0,a0,-918 # 5c30 <malloc+0xd52>
    1fce:	283020ef          	jal	4a50 <open>
    1fd2:	892a                	mv	s2,a0
  if(fd < 0){
    1fd4:	04054863          	bltz	a0,2024 <rwsbrk+0x88>
  n = write(fd, (void*)(a+4096), 1024);
    1fd8:	6785                	lui	a5,0x1
    1fda:	94be                	add	s1,s1,a5
    1fdc:	40000613          	li	a2,1024
    1fe0:	85a6                	mv	a1,s1
    1fe2:	24f020ef          	jal	4a30 <write>
    1fe6:	862a                	mv	a2,a0
  if(n >= 0){
    1fe8:	04054763          	bltz	a0,2036 <rwsbrk+0x9a>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    1fec:	85a6                	mv	a1,s1
    1fee:	00004517          	auipc	a0,0x4
    1ff2:	c6250513          	add	a0,a0,-926 # 5c50 <malloc+0xd72>
    1ff6:	635020ef          	jal	4e2a <printf>
    exit(1);
    1ffa:	4505                	li	a0,1
    1ffc:	215020ef          	jal	4a10 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2000:	00004517          	auipc	a0,0x4
    2004:	bf850513          	add	a0,a0,-1032 # 5bf8 <malloc+0xd1a>
    2008:	623020ef          	jal	4e2a <printf>
    exit(1);
    200c:	4505                	li	a0,1
    200e:	203020ef          	jal	4a10 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2012:	00004517          	auipc	a0,0x4
    2016:	bfe50513          	add	a0,a0,-1026 # 5c10 <malloc+0xd32>
    201a:	611020ef          	jal	4e2a <printf>
    exit(1);
    201e:	4505                	li	a0,1
    2020:	1f1020ef          	jal	4a10 <exit>
    printf("open(rwsbrk) failed\n");
    2024:	00004517          	auipc	a0,0x4
    2028:	c1450513          	add	a0,a0,-1004 # 5c38 <malloc+0xd5a>
    202c:	5ff020ef          	jal	4e2a <printf>
    exit(1);
    2030:	4505                	li	a0,1
    2032:	1df020ef          	jal	4a10 <exit>
  close(fd);
    2036:	854a                	mv	a0,s2
    2038:	201020ef          	jal	4a38 <close>
  unlink("rwsbrk");
    203c:	00004517          	auipc	a0,0x4
    2040:	bf450513          	add	a0,a0,-1036 # 5c30 <malloc+0xd52>
    2044:	21d020ef          	jal	4a60 <unlink>
  fd = open("README", O_RDONLY);
    2048:	4581                	li	a1,0
    204a:	00003517          	auipc	a0,0x3
    204e:	18650513          	add	a0,a0,390 # 51d0 <malloc+0x2f2>
    2052:	1ff020ef          	jal	4a50 <open>
    2056:	892a                	mv	s2,a0
  if(fd < 0){
    2058:	02054363          	bltz	a0,207e <rwsbrk+0xe2>
  n = read(fd, (void*)(a+4096), 10);
    205c:	4629                	li	a2,10
    205e:	85a6                	mv	a1,s1
    2060:	1c9020ef          	jal	4a28 <read>
    2064:	862a                	mv	a2,a0
  if(n >= 0){
    2066:	02054563          	bltz	a0,2090 <rwsbrk+0xf4>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    206a:	85a6                	mv	a1,s1
    206c:	00004517          	auipc	a0,0x4
    2070:	c1450513          	add	a0,a0,-1004 # 5c80 <malloc+0xda2>
    2074:	5b7020ef          	jal	4e2a <printf>
    exit(1);
    2078:	4505                	li	a0,1
    207a:	197020ef          	jal	4a10 <exit>
    printf("open(rwsbrk) failed\n");
    207e:	00004517          	auipc	a0,0x4
    2082:	bba50513          	add	a0,a0,-1094 # 5c38 <malloc+0xd5a>
    2086:	5a5020ef          	jal	4e2a <printf>
    exit(1);
    208a:	4505                	li	a0,1
    208c:	185020ef          	jal	4a10 <exit>
  close(fd);
    2090:	854a                	mv	a0,s2
    2092:	1a7020ef          	jal	4a38 <close>
  exit(0);
    2096:	4501                	li	a0,0
    2098:	179020ef          	jal	4a10 <exit>

000000000000209c <sbrkbasic>:
{
    209c:	7139                	add	sp,sp,-64
    209e:	fc06                	sd	ra,56(sp)
    20a0:	f822                	sd	s0,48(sp)
    20a2:	f426                	sd	s1,40(sp)
    20a4:	f04a                	sd	s2,32(sp)
    20a6:	ec4e                	sd	s3,24(sp)
    20a8:	e852                	sd	s4,16(sp)
    20aa:	0080                	add	s0,sp,64
    20ac:	8a2a                	mv	s4,a0
  pid = fork();
    20ae:	15b020ef          	jal	4a08 <fork>
  if(pid < 0){
    20b2:	02054863          	bltz	a0,20e2 <sbrkbasic+0x46>
  if(pid == 0){
    20b6:	e131                	bnez	a0,20fa <sbrkbasic+0x5e>
    a = sbrk(TOOMUCH);
    20b8:	40000537          	lui	a0,0x40000
    20bc:	1dd020ef          	jal	4a98 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    20c0:	57fd                	li	a5,-1
    20c2:	02f50963          	beq	a0,a5,20f4 <sbrkbasic+0x58>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20c6:	400007b7          	lui	a5,0x40000
    20ca:	97aa                	add	a5,a5,a0
      *b = 99;
    20cc:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    20d0:	6705                	lui	a4,0x1
      *b = 99;
    20d2:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20d6:	953a                	add	a0,a0,a4
    20d8:	fef51de3          	bne	a0,a5,20d2 <sbrkbasic+0x36>
    exit(1);
    20dc:	4505                	li	a0,1
    20de:	133020ef          	jal	4a10 <exit>
    printf("fork failed in sbrkbasic\n");
    20e2:	00004517          	auipc	a0,0x4
    20e6:	bc650513          	add	a0,a0,-1082 # 5ca8 <malloc+0xdca>
    20ea:	541020ef          	jal	4e2a <printf>
    exit(1);
    20ee:	4505                	li	a0,1
    20f0:	121020ef          	jal	4a10 <exit>
      exit(0);
    20f4:	4501                	li	a0,0
    20f6:	11b020ef          	jal	4a10 <exit>
  wait(&xstatus);
    20fa:	fcc40513          	add	a0,s0,-52
    20fe:	11b020ef          	jal	4a18 <wait>
  if(xstatus == 1){
    2102:	fcc42703          	lw	a4,-52(s0)
    2106:	4785                	li	a5,1
    2108:	00f70b63          	beq	a4,a5,211e <sbrkbasic+0x82>
  a = sbrk(0);
    210c:	4501                	li	a0,0
    210e:	18b020ef          	jal	4a98 <sbrk>
    2112:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2114:	4901                	li	s2,0
    2116:	6985                	lui	s3,0x1
    2118:	38898993          	add	s3,s3,904 # 1388 <exectest+0x56>
    211c:	a821                	j	2134 <sbrkbasic+0x98>
    printf("%s: too much memory allocated!\n", s);
    211e:	85d2                	mv	a1,s4
    2120:	00004517          	auipc	a0,0x4
    2124:	ba850513          	add	a0,a0,-1112 # 5cc8 <malloc+0xdea>
    2128:	503020ef          	jal	4e2a <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	0e3020ef          	jal	4a10 <exit>
    a = b + 1;
    2132:	84be                	mv	s1,a5
    b = sbrk(1);
    2134:	4505                	li	a0,1
    2136:	163020ef          	jal	4a98 <sbrk>
    if(b != a){
    213a:	04951263          	bne	a0,s1,217e <sbrkbasic+0xe2>
    *b = 1;
    213e:	4785                	li	a5,1
    2140:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2144:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    2148:	2905                	addw	s2,s2,1
    214a:	ff3914e3          	bne	s2,s3,2132 <sbrkbasic+0x96>
  pid = fork();
    214e:	0bb020ef          	jal	4a08 <fork>
    2152:	892a                	mv	s2,a0
  if(pid < 0){
    2154:	04054263          	bltz	a0,2198 <sbrkbasic+0xfc>
  c = sbrk(1);
    2158:	4505                	li	a0,1
    215a:	13f020ef          	jal	4a98 <sbrk>
  c = sbrk(1);
    215e:	4505                	li	a0,1
    2160:	139020ef          	jal	4a98 <sbrk>
  if(c != a + 1){
    2164:	0489                	add	s1,s1,2
    2166:	04a48363          	beq	s1,a0,21ac <sbrkbasic+0x110>
    printf("%s: sbrk test failed post-fork\n", s);
    216a:	85d2                	mv	a1,s4
    216c:	00004517          	auipc	a0,0x4
    2170:	bbc50513          	add	a0,a0,-1092 # 5d28 <malloc+0xe4a>
    2174:	4b7020ef          	jal	4e2a <printf>
    exit(1);
    2178:	4505                	li	a0,1
    217a:	097020ef          	jal	4a10 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    217e:	872a                	mv	a4,a0
    2180:	86a6                	mv	a3,s1
    2182:	864a                	mv	a2,s2
    2184:	85d2                	mv	a1,s4
    2186:	00004517          	auipc	a0,0x4
    218a:	b6250513          	add	a0,a0,-1182 # 5ce8 <malloc+0xe0a>
    218e:	49d020ef          	jal	4e2a <printf>
      exit(1);
    2192:	4505                	li	a0,1
    2194:	07d020ef          	jal	4a10 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2198:	85d2                	mv	a1,s4
    219a:	00004517          	auipc	a0,0x4
    219e:	b6e50513          	add	a0,a0,-1170 # 5d08 <malloc+0xe2a>
    21a2:	489020ef          	jal	4e2a <printf>
    exit(1);
    21a6:	4505                	li	a0,1
    21a8:	069020ef          	jal	4a10 <exit>
  if(pid == 0)
    21ac:	00091563          	bnez	s2,21b6 <sbrkbasic+0x11a>
    exit(0);
    21b0:	4501                	li	a0,0
    21b2:	05f020ef          	jal	4a10 <exit>
  wait(&xstatus);
    21b6:	fcc40513          	add	a0,s0,-52
    21ba:	05f020ef          	jal	4a18 <wait>
  exit(xstatus);
    21be:	fcc42503          	lw	a0,-52(s0)
    21c2:	04f020ef          	jal	4a10 <exit>

00000000000021c6 <sbrkmuch>:
{
    21c6:	7179                	add	sp,sp,-48
    21c8:	f406                	sd	ra,40(sp)
    21ca:	f022                	sd	s0,32(sp)
    21cc:	ec26                	sd	s1,24(sp)
    21ce:	e84a                	sd	s2,16(sp)
    21d0:	e44e                	sd	s3,8(sp)
    21d2:	e052                	sd	s4,0(sp)
    21d4:	1800                	add	s0,sp,48
    21d6:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21d8:	4501                	li	a0,0
    21da:	0bf020ef          	jal	4a98 <sbrk>
    21de:	892a                	mv	s2,a0
  a = sbrk(0);
    21e0:	4501                	li	a0,0
    21e2:	0b7020ef          	jal	4a98 <sbrk>
    21e6:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21e8:	06400537          	lui	a0,0x6400
    21ec:	9d05                	subw	a0,a0,s1
    21ee:	0ab020ef          	jal	4a98 <sbrk>
  if (p != a) {
    21f2:	0aa49463          	bne	s1,a0,229a <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    21f6:	4501                	li	a0,0
    21f8:	0a1020ef          	jal	4a98 <sbrk>
    21fc:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    21fe:	00a4f963          	bgeu	s1,a0,2210 <sbrkmuch+0x4a>
    *pp = 1;
    2202:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2204:	6705                	lui	a4,0x1
    *pp = 1;
    2206:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    220a:	94ba                	add	s1,s1,a4
    220c:	fef4ede3          	bltu	s1,a5,2206 <sbrkmuch+0x40>
  *lastaddr = 99;
    2210:	064007b7          	lui	a5,0x6400
    2214:	06300713          	li	a4,99
    2218:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1387>
  a = sbrk(0);
    221c:	4501                	li	a0,0
    221e:	07b020ef          	jal	4a98 <sbrk>
    2222:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2224:	757d                	lui	a0,0xfffff
    2226:	073020ef          	jal	4a98 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    222a:	57fd                	li	a5,-1
    222c:	08f50163          	beq	a0,a5,22ae <sbrkmuch+0xe8>
  c = sbrk(0);
    2230:	4501                	li	a0,0
    2232:	067020ef          	jal	4a98 <sbrk>
  if(c != a - PGSIZE){
    2236:	77fd                	lui	a5,0xfffff
    2238:	97a6                	add	a5,a5,s1
    223a:	08f51463          	bne	a0,a5,22c2 <sbrkmuch+0xfc>
  a = sbrk(0);
    223e:	4501                	li	a0,0
    2240:	059020ef          	jal	4a98 <sbrk>
    2244:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2246:	6505                	lui	a0,0x1
    2248:	051020ef          	jal	4a98 <sbrk>
    224c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    224e:	08a49663          	bne	s1,a0,22da <sbrkmuch+0x114>
    2252:	4501                	li	a0,0
    2254:	045020ef          	jal	4a98 <sbrk>
    2258:	6785                	lui	a5,0x1
    225a:	97a6                	add	a5,a5,s1
    225c:	06f51f63          	bne	a0,a5,22da <sbrkmuch+0x114>
  if(*lastaddr == 99){
    2260:	064007b7          	lui	a5,0x6400
    2264:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1387>
    2268:	06300793          	li	a5,99
    226c:	08f70363          	beq	a4,a5,22f2 <sbrkmuch+0x12c>
  a = sbrk(0);
    2270:	4501                	li	a0,0
    2272:	027020ef          	jal	4a98 <sbrk>
    2276:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2278:	4501                	li	a0,0
    227a:	01f020ef          	jal	4a98 <sbrk>
    227e:	40a9053b          	subw	a0,s2,a0
    2282:	017020ef          	jal	4a98 <sbrk>
  if(c != a){
    2286:	08a49063          	bne	s1,a0,2306 <sbrkmuch+0x140>
}
    228a:	70a2                	ld	ra,40(sp)
    228c:	7402                	ld	s0,32(sp)
    228e:	64e2                	ld	s1,24(sp)
    2290:	6942                	ld	s2,16(sp)
    2292:	69a2                	ld	s3,8(sp)
    2294:	6a02                	ld	s4,0(sp)
    2296:	6145                	add	sp,sp,48
    2298:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    229a:	85ce                	mv	a1,s3
    229c:	00004517          	auipc	a0,0x4
    22a0:	aac50513          	add	a0,a0,-1364 # 5d48 <malloc+0xe6a>
    22a4:	387020ef          	jal	4e2a <printf>
    exit(1);
    22a8:	4505                	li	a0,1
    22aa:	766020ef          	jal	4a10 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22ae:	85ce                	mv	a1,s3
    22b0:	00004517          	auipc	a0,0x4
    22b4:	ae050513          	add	a0,a0,-1312 # 5d90 <malloc+0xeb2>
    22b8:	373020ef          	jal	4e2a <printf>
    exit(1);
    22bc:	4505                	li	a0,1
    22be:	752020ef          	jal	4a10 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22c2:	86aa                	mv	a3,a0
    22c4:	8626                	mv	a2,s1
    22c6:	85ce                	mv	a1,s3
    22c8:	00004517          	auipc	a0,0x4
    22cc:	ae850513          	add	a0,a0,-1304 # 5db0 <malloc+0xed2>
    22d0:	35b020ef          	jal	4e2a <printf>
    exit(1);
    22d4:	4505                	li	a0,1
    22d6:	73a020ef          	jal	4a10 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22da:	86d2                	mv	a3,s4
    22dc:	8626                	mv	a2,s1
    22de:	85ce                	mv	a1,s3
    22e0:	00004517          	auipc	a0,0x4
    22e4:	b1050513          	add	a0,a0,-1264 # 5df0 <malloc+0xf12>
    22e8:	343020ef          	jal	4e2a <printf>
    exit(1);
    22ec:	4505                	li	a0,1
    22ee:	722020ef          	jal	4a10 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22f2:	85ce                	mv	a1,s3
    22f4:	00004517          	auipc	a0,0x4
    22f8:	b2c50513          	add	a0,a0,-1236 # 5e20 <malloc+0xf42>
    22fc:	32f020ef          	jal	4e2a <printf>
    exit(1);
    2300:	4505                	li	a0,1
    2302:	70e020ef          	jal	4a10 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2306:	86aa                	mv	a3,a0
    2308:	8626                	mv	a2,s1
    230a:	85ce                	mv	a1,s3
    230c:	00004517          	auipc	a0,0x4
    2310:	b4c50513          	add	a0,a0,-1204 # 5e58 <malloc+0xf7a>
    2314:	317020ef          	jal	4e2a <printf>
    exit(1);
    2318:	4505                	li	a0,1
    231a:	6f6020ef          	jal	4a10 <exit>

000000000000231e <sbrkarg>:
{
    231e:	7179                	add	sp,sp,-48
    2320:	f406                	sd	ra,40(sp)
    2322:	f022                	sd	s0,32(sp)
    2324:	ec26                	sd	s1,24(sp)
    2326:	e84a                	sd	s2,16(sp)
    2328:	e44e                	sd	s3,8(sp)
    232a:	1800                	add	s0,sp,48
    232c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    232e:	6505                	lui	a0,0x1
    2330:	768020ef          	jal	4a98 <sbrk>
    2334:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2336:	20100593          	li	a1,513
    233a:	00004517          	auipc	a0,0x4
    233e:	b4650513          	add	a0,a0,-1210 # 5e80 <malloc+0xfa2>
    2342:	70e020ef          	jal	4a50 <open>
    2346:	84aa                	mv	s1,a0
  unlink("sbrk");
    2348:	00004517          	auipc	a0,0x4
    234c:	b3850513          	add	a0,a0,-1224 # 5e80 <malloc+0xfa2>
    2350:	710020ef          	jal	4a60 <unlink>
  if(fd < 0)  {
    2354:	0204c963          	bltz	s1,2386 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2358:	6605                	lui	a2,0x1
    235a:	85ca                	mv	a1,s2
    235c:	8526                	mv	a0,s1
    235e:	6d2020ef          	jal	4a30 <write>
    2362:	02054c63          	bltz	a0,239a <sbrkarg+0x7c>
  close(fd);
    2366:	8526                	mv	a0,s1
    2368:	6d0020ef          	jal	4a38 <close>
  a = sbrk(PGSIZE);
    236c:	6505                	lui	a0,0x1
    236e:	72a020ef          	jal	4a98 <sbrk>
  if(pipe((int *) a) != 0){
    2372:	6ae020ef          	jal	4a20 <pipe>
    2376:	ed05                	bnez	a0,23ae <sbrkarg+0x90>
}
    2378:	70a2                	ld	ra,40(sp)
    237a:	7402                	ld	s0,32(sp)
    237c:	64e2                	ld	s1,24(sp)
    237e:	6942                	ld	s2,16(sp)
    2380:	69a2                	ld	s3,8(sp)
    2382:	6145                	add	sp,sp,48
    2384:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2386:	85ce                	mv	a1,s3
    2388:	00004517          	auipc	a0,0x4
    238c:	b0050513          	add	a0,a0,-1280 # 5e88 <malloc+0xfaa>
    2390:	29b020ef          	jal	4e2a <printf>
    exit(1);
    2394:	4505                	li	a0,1
    2396:	67a020ef          	jal	4a10 <exit>
    printf("%s: write sbrk failed\n", s);
    239a:	85ce                	mv	a1,s3
    239c:	00004517          	auipc	a0,0x4
    23a0:	b0450513          	add	a0,a0,-1276 # 5ea0 <malloc+0xfc2>
    23a4:	287020ef          	jal	4e2a <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	666020ef          	jal	4a10 <exit>
    printf("%s: pipe() failed\n", s);
    23ae:	85ce                	mv	a1,s3
    23b0:	00003517          	auipc	a0,0x3
    23b4:	5e050513          	add	a0,a0,1504 # 5990 <malloc+0xab2>
    23b8:	273020ef          	jal	4e2a <printf>
    exit(1);
    23bc:	4505                	li	a0,1
    23be:	652020ef          	jal	4a10 <exit>

00000000000023c2 <argptest>:
{
    23c2:	1101                	add	sp,sp,-32
    23c4:	ec06                	sd	ra,24(sp)
    23c6:	e822                	sd	s0,16(sp)
    23c8:	e426                	sd	s1,8(sp)
    23ca:	e04a                	sd	s2,0(sp)
    23cc:	1000                	add	s0,sp,32
    23ce:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    23d0:	4581                	li	a1,0
    23d2:	00004517          	auipc	a0,0x4
    23d6:	ae650513          	add	a0,a0,-1306 # 5eb8 <malloc+0xfda>
    23da:	676020ef          	jal	4a50 <open>
  if (fd < 0) {
    23de:	02054563          	bltz	a0,2408 <argptest+0x46>
    23e2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23e4:	4501                	li	a0,0
    23e6:	6b2020ef          	jal	4a98 <sbrk>
    23ea:	567d                	li	a2,-1
    23ec:	fff50593          	add	a1,a0,-1
    23f0:	8526                	mv	a0,s1
    23f2:	636020ef          	jal	4a28 <read>
  close(fd);
    23f6:	8526                	mv	a0,s1
    23f8:	640020ef          	jal	4a38 <close>
}
    23fc:	60e2                	ld	ra,24(sp)
    23fe:	6442                	ld	s0,16(sp)
    2400:	64a2                	ld	s1,8(sp)
    2402:	6902                	ld	s2,0(sp)
    2404:	6105                	add	sp,sp,32
    2406:	8082                	ret
    printf("%s: open failed\n", s);
    2408:	85ca                	mv	a1,s2
    240a:	00003517          	auipc	a0,0x3
    240e:	49650513          	add	a0,a0,1174 # 58a0 <malloc+0x9c2>
    2412:	219020ef          	jal	4e2a <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	5f8020ef          	jal	4a10 <exit>

000000000000241c <sbrkbugs>:
{
    241c:	1141                	add	sp,sp,-16
    241e:	e406                	sd	ra,8(sp)
    2420:	e022                	sd	s0,0(sp)
    2422:	0800                	add	s0,sp,16
  int pid = fork();
    2424:	5e4020ef          	jal	4a08 <fork>
  if(pid < 0){
    2428:	00054c63          	bltz	a0,2440 <sbrkbugs+0x24>
  if(pid == 0){
    242c:	e11d                	bnez	a0,2452 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    242e:	66a020ef          	jal	4a98 <sbrk>
    sbrk(-sz);
    2432:	40a0053b          	negw	a0,a0
    2436:	662020ef          	jal	4a98 <sbrk>
    exit(0);
    243a:	4501                	li	a0,0
    243c:	5d4020ef          	jal	4a10 <exit>
    printf("fork failed\n");
    2440:	00005517          	auipc	a0,0x5
    2444:	9b850513          	add	a0,a0,-1608 # 6df8 <malloc+0x1f1a>
    2448:	1e3020ef          	jal	4e2a <printf>
    exit(1);
    244c:	4505                	li	a0,1
    244e:	5c2020ef          	jal	4a10 <exit>
  wait(0);
    2452:	4501                	li	a0,0
    2454:	5c4020ef          	jal	4a18 <wait>
  pid = fork();
    2458:	5b0020ef          	jal	4a08 <fork>
  if(pid < 0){
    245c:	00054f63          	bltz	a0,247a <sbrkbugs+0x5e>
  if(pid == 0){
    2460:	e515                	bnez	a0,248c <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    2462:	636020ef          	jal	4a98 <sbrk>
    sbrk(-(sz - 3500));
    2466:	6785                	lui	a5,0x1
    2468:	dac7879b          	addw	a5,a5,-596 # dac <linktest+0x134>
    246c:	40a7853b          	subw	a0,a5,a0
    2470:	628020ef          	jal	4a98 <sbrk>
    exit(0);
    2474:	4501                	li	a0,0
    2476:	59a020ef          	jal	4a10 <exit>
    printf("fork failed\n");
    247a:	00005517          	auipc	a0,0x5
    247e:	97e50513          	add	a0,a0,-1666 # 6df8 <malloc+0x1f1a>
    2482:	1a9020ef          	jal	4e2a <printf>
    exit(1);
    2486:	4505                	li	a0,1
    2488:	588020ef          	jal	4a10 <exit>
  wait(0);
    248c:	4501                	li	a0,0
    248e:	58a020ef          	jal	4a18 <wait>
  pid = fork();
    2492:	576020ef          	jal	4a08 <fork>
  if(pid < 0){
    2496:	02054263          	bltz	a0,24ba <sbrkbugs+0x9e>
  if(pid == 0){
    249a:	e90d                	bnez	a0,24cc <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    249c:	5fc020ef          	jal	4a98 <sbrk>
    24a0:	67ad                	lui	a5,0xb
    24a2:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x1298>
    24a6:	40a7853b          	subw	a0,a5,a0
    24aa:	5ee020ef          	jal	4a98 <sbrk>
    sbrk(-10);
    24ae:	5559                	li	a0,-10
    24b0:	5e8020ef          	jal	4a98 <sbrk>
    exit(0);
    24b4:	4501                	li	a0,0
    24b6:	55a020ef          	jal	4a10 <exit>
    printf("fork failed\n");
    24ba:	00005517          	auipc	a0,0x5
    24be:	93e50513          	add	a0,a0,-1730 # 6df8 <malloc+0x1f1a>
    24c2:	169020ef          	jal	4e2a <printf>
    exit(1);
    24c6:	4505                	li	a0,1
    24c8:	548020ef          	jal	4a10 <exit>
  wait(0);
    24cc:	4501                	li	a0,0
    24ce:	54a020ef          	jal	4a18 <wait>
  exit(0);
    24d2:	4501                	li	a0,0
    24d4:	53c020ef          	jal	4a10 <exit>

00000000000024d8 <sbrklast>:
{
    24d8:	7179                	add	sp,sp,-48
    24da:	f406                	sd	ra,40(sp)
    24dc:	f022                	sd	s0,32(sp)
    24de:	ec26                	sd	s1,24(sp)
    24e0:	e84a                	sd	s2,16(sp)
    24e2:	e44e                	sd	s3,8(sp)
    24e4:	e052                	sd	s4,0(sp)
    24e6:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    24e8:	4501                	li	a0,0
    24ea:	5ae020ef          	jal	4a98 <sbrk>
  if((top % 4096) != 0)
    24ee:	03451793          	sll	a5,a0,0x34
    24f2:	ebad                	bnez	a5,2564 <sbrklast+0x8c>
  sbrk(4096);
    24f4:	6505                	lui	a0,0x1
    24f6:	5a2020ef          	jal	4a98 <sbrk>
  sbrk(10);
    24fa:	4529                	li	a0,10
    24fc:	59c020ef          	jal	4a98 <sbrk>
  sbrk(-20);
    2500:	5531                	li	a0,-20
    2502:	596020ef          	jal	4a98 <sbrk>
  top = (uint64) sbrk(0);
    2506:	4501                	li	a0,0
    2508:	590020ef          	jal	4a98 <sbrk>
    250c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    250e:	fc050913          	add	s2,a0,-64 # fc0 <bigdir+0x11e>
  p[0] = 'x';
    2512:	07800a13          	li	s4,120
    2516:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    251a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    251e:	20200593          	li	a1,514
    2522:	854a                	mv	a0,s2
    2524:	52c020ef          	jal	4a50 <open>
    2528:	89aa                	mv	s3,a0
  write(fd, p, 1);
    252a:	4605                	li	a2,1
    252c:	85ca                	mv	a1,s2
    252e:	502020ef          	jal	4a30 <write>
  close(fd);
    2532:	854e                	mv	a0,s3
    2534:	504020ef          	jal	4a38 <close>
  fd = open(p, O_RDWR);
    2538:	4589                	li	a1,2
    253a:	854a                	mv	a0,s2
    253c:	514020ef          	jal	4a50 <open>
  p[0] = '\0';
    2540:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2544:	4605                	li	a2,1
    2546:	85ca                	mv	a1,s2
    2548:	4e0020ef          	jal	4a28 <read>
  if(p[0] != 'x')
    254c:	fc04c783          	lbu	a5,-64(s1)
    2550:	03479263          	bne	a5,s4,2574 <sbrklast+0x9c>
}
    2554:	70a2                	ld	ra,40(sp)
    2556:	7402                	ld	s0,32(sp)
    2558:	64e2                	ld	s1,24(sp)
    255a:	6942                	ld	s2,16(sp)
    255c:	69a2                	ld	s3,8(sp)
    255e:	6a02                	ld	s4,0(sp)
    2560:	6145                	add	sp,sp,48
    2562:	8082                	ret
    sbrk(4096 - (top % 4096));
    2564:	0347d513          	srl	a0,a5,0x34
    2568:	6785                	lui	a5,0x1
    256a:	40a7853b          	subw	a0,a5,a0
    256e:	52a020ef          	jal	4a98 <sbrk>
    2572:	b749                	j	24f4 <sbrklast+0x1c>
    exit(1);
    2574:	4505                	li	a0,1
    2576:	49a020ef          	jal	4a10 <exit>

000000000000257a <sbrk8000>:
{
    257a:	1141                	add	sp,sp,-16
    257c:	e406                	sd	ra,8(sp)
    257e:	e022                	sd	s0,0(sp)
    2580:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2582:	80000537          	lui	a0,0x80000
    2586:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff138c>
    2588:	510020ef          	jal	4a98 <sbrk>
  volatile char *top = sbrk(0);
    258c:	4501                	li	a0,0
    258e:	50a020ef          	jal	4a98 <sbrk>
  *(top-1) = *(top-1) + 1;
    2592:	fff54783          	lbu	a5,-1(a0)
    2596:	2785                	addw	a5,a5,1 # 1001 <pgbug+0x29>
    2598:	0ff7f793          	zext.b	a5,a5
    259c:	fef50fa3          	sb	a5,-1(a0)
}
    25a0:	60a2                	ld	ra,8(sp)
    25a2:	6402                	ld	s0,0(sp)
    25a4:	0141                	add	sp,sp,16
    25a6:	8082                	ret

00000000000025a8 <execout>:
{
    25a8:	715d                	add	sp,sp,-80
    25aa:	e486                	sd	ra,72(sp)
    25ac:	e0a2                	sd	s0,64(sp)
    25ae:	fc26                	sd	s1,56(sp)
    25b0:	f84a                	sd	s2,48(sp)
    25b2:	f44e                	sd	s3,40(sp)
    25b4:	f052                	sd	s4,32(sp)
    25b6:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    25b8:	4901                	li	s2,0
    25ba:	49bd                	li	s3,15
    int pid = fork();
    25bc:	44c020ef          	jal	4a08 <fork>
    25c0:	84aa                	mv	s1,a0
    if(pid < 0){
    25c2:	00054c63          	bltz	a0,25da <execout+0x32>
    } else if(pid == 0){
    25c6:	c11d                	beqz	a0,25ec <execout+0x44>
      wait((int*)0);
    25c8:	4501                	li	a0,0
    25ca:	44e020ef          	jal	4a18 <wait>
  for(int avail = 0; avail < 15; avail++){
    25ce:	2905                	addw	s2,s2,1
    25d0:	ff3916e3          	bne	s2,s3,25bc <execout+0x14>
  exit(0);
    25d4:	4501                	li	a0,0
    25d6:	43a020ef          	jal	4a10 <exit>
      printf("fork failed\n");
    25da:	00005517          	auipc	a0,0x5
    25de:	81e50513          	add	a0,a0,-2018 # 6df8 <malloc+0x1f1a>
    25e2:	049020ef          	jal	4e2a <printf>
      exit(1);
    25e6:	4505                	li	a0,1
    25e8:	428020ef          	jal	4a10 <exit>
        if(a == 0xffffffffffffffffLL)
    25ec:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    25ee:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    25f0:	6505                	lui	a0,0x1
    25f2:	4a6020ef          	jal	4a98 <sbrk>
        if(a == 0xffffffffffffffffLL)
    25f6:	01350763          	beq	a0,s3,2604 <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    25fa:	6785                	lui	a5,0x1
    25fc:	97aa                	add	a5,a5,a0
    25fe:	ff478fa3          	sb	s4,-1(a5) # fff <pgbug+0x27>
      while(1){
    2602:	b7fd                	j	25f0 <execout+0x48>
      for(int i = 0; i < avail; i++)
    2604:	01205863          	blez	s2,2614 <execout+0x6c>
        sbrk(-4096);
    2608:	757d                	lui	a0,0xfffff
    260a:	48e020ef          	jal	4a98 <sbrk>
      for(int i = 0; i < avail; i++)
    260e:	2485                	addw	s1,s1,1
    2610:	ff249ce3          	bne	s1,s2,2608 <execout+0x60>
      close(1);
    2614:	4505                	li	a0,1
    2616:	422020ef          	jal	4a38 <close>
      char *args[] = { "echo", "x", 0 };
    261a:	00003517          	auipc	a0,0x3
    261e:	9de50513          	add	a0,a0,-1570 # 4ff8 <malloc+0x11a>
    2622:	faa43c23          	sd	a0,-72(s0)
    2626:	00003797          	auipc	a5,0x3
    262a:	a4278793          	add	a5,a5,-1470 # 5068 <malloc+0x18a>
    262e:	fcf43023          	sd	a5,-64(s0)
    2632:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2636:	fb840593          	add	a1,s0,-72
    263a:	40e020ef          	jal	4a48 <exec>
      exit(0);
    263e:	4501                	li	a0,0
    2640:	3d0020ef          	jal	4a10 <exit>

0000000000002644 <fourteen>:
{
    2644:	1101                	add	sp,sp,-32
    2646:	ec06                	sd	ra,24(sp)
    2648:	e822                	sd	s0,16(sp)
    264a:	e426                	sd	s1,8(sp)
    264c:	1000                	add	s0,sp,32
    264e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2650:	00004517          	auipc	a0,0x4
    2654:	a4050513          	add	a0,a0,-1472 # 6090 <malloc+0x11b2>
    2658:	420020ef          	jal	4a78 <mkdir>
    265c:	e555                	bnez	a0,2708 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    265e:	00004517          	auipc	a0,0x4
    2662:	88a50513          	add	a0,a0,-1910 # 5ee8 <malloc+0x100a>
    2666:	412020ef          	jal	4a78 <mkdir>
    266a:	e94d                	bnez	a0,271c <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    266c:	20000593          	li	a1,512
    2670:	00004517          	auipc	a0,0x4
    2674:	8d050513          	add	a0,a0,-1840 # 5f40 <malloc+0x1062>
    2678:	3d8020ef          	jal	4a50 <open>
  if(fd < 0){
    267c:	0a054a63          	bltz	a0,2730 <fourteen+0xec>
  close(fd);
    2680:	3b8020ef          	jal	4a38 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2684:	4581                	li	a1,0
    2686:	00004517          	auipc	a0,0x4
    268a:	93250513          	add	a0,a0,-1742 # 5fb8 <malloc+0x10da>
    268e:	3c2020ef          	jal	4a50 <open>
  if(fd < 0){
    2692:	0a054963          	bltz	a0,2744 <fourteen+0x100>
  close(fd);
    2696:	3a2020ef          	jal	4a38 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    269a:	00004517          	auipc	a0,0x4
    269e:	98e50513          	add	a0,a0,-1650 # 6028 <malloc+0x114a>
    26a2:	3d6020ef          	jal	4a78 <mkdir>
    26a6:	c94d                	beqz	a0,2758 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26a8:	00004517          	auipc	a0,0x4
    26ac:	9d850513          	add	a0,a0,-1576 # 6080 <malloc+0x11a2>
    26b0:	3c8020ef          	jal	4a78 <mkdir>
    26b4:	cd45                	beqz	a0,276c <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    26b6:	00004517          	auipc	a0,0x4
    26ba:	9ca50513          	add	a0,a0,-1590 # 6080 <malloc+0x11a2>
    26be:	3a2020ef          	jal	4a60 <unlink>
  unlink("12345678901234/12345678901234");
    26c2:	00004517          	auipc	a0,0x4
    26c6:	96650513          	add	a0,a0,-1690 # 6028 <malloc+0x114a>
    26ca:	396020ef          	jal	4a60 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26ce:	00004517          	auipc	a0,0x4
    26d2:	8ea50513          	add	a0,a0,-1814 # 5fb8 <malloc+0x10da>
    26d6:	38a020ef          	jal	4a60 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26da:	00004517          	auipc	a0,0x4
    26de:	86650513          	add	a0,a0,-1946 # 5f40 <malloc+0x1062>
    26e2:	37e020ef          	jal	4a60 <unlink>
  unlink("12345678901234/123456789012345");
    26e6:	00004517          	auipc	a0,0x4
    26ea:	80250513          	add	a0,a0,-2046 # 5ee8 <malloc+0x100a>
    26ee:	372020ef          	jal	4a60 <unlink>
  unlink("12345678901234");
    26f2:	00004517          	auipc	a0,0x4
    26f6:	99e50513          	add	a0,a0,-1634 # 6090 <malloc+0x11b2>
    26fa:	366020ef          	jal	4a60 <unlink>
}
    26fe:	60e2                	ld	ra,24(sp)
    2700:	6442                	ld	s0,16(sp)
    2702:	64a2                	ld	s1,8(sp)
    2704:	6105                	add	sp,sp,32
    2706:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2708:	85a6                	mv	a1,s1
    270a:	00003517          	auipc	a0,0x3
    270e:	7b650513          	add	a0,a0,1974 # 5ec0 <malloc+0xfe2>
    2712:	718020ef          	jal	4e2a <printf>
    exit(1);
    2716:	4505                	li	a0,1
    2718:	2f8020ef          	jal	4a10 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    271c:	85a6                	mv	a1,s1
    271e:	00003517          	auipc	a0,0x3
    2722:	7ea50513          	add	a0,a0,2026 # 5f08 <malloc+0x102a>
    2726:	704020ef          	jal	4e2a <printf>
    exit(1);
    272a:	4505                	li	a0,1
    272c:	2e4020ef          	jal	4a10 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2730:	85a6                	mv	a1,s1
    2732:	00004517          	auipc	a0,0x4
    2736:	83e50513          	add	a0,a0,-1986 # 5f70 <malloc+0x1092>
    273a:	6f0020ef          	jal	4e2a <printf>
    exit(1);
    273e:	4505                	li	a0,1
    2740:	2d0020ef          	jal	4a10 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2744:	85a6                	mv	a1,s1
    2746:	00004517          	auipc	a0,0x4
    274a:	8a250513          	add	a0,a0,-1886 # 5fe8 <malloc+0x110a>
    274e:	6dc020ef          	jal	4e2a <printf>
    exit(1);
    2752:	4505                	li	a0,1
    2754:	2bc020ef          	jal	4a10 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2758:	85a6                	mv	a1,s1
    275a:	00004517          	auipc	a0,0x4
    275e:	8ee50513          	add	a0,a0,-1810 # 6048 <malloc+0x116a>
    2762:	6c8020ef          	jal	4e2a <printf>
    exit(1);
    2766:	4505                	li	a0,1
    2768:	2a8020ef          	jal	4a10 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    276c:	85a6                	mv	a1,s1
    276e:	00004517          	auipc	a0,0x4
    2772:	93250513          	add	a0,a0,-1742 # 60a0 <malloc+0x11c2>
    2776:	6b4020ef          	jal	4e2a <printf>
    exit(1);
    277a:	4505                	li	a0,1
    277c:	294020ef          	jal	4a10 <exit>

0000000000002780 <diskfull>:
{
    2780:	b8010113          	add	sp,sp,-1152
    2784:	46113c23          	sd	ra,1144(sp)
    2788:	46813823          	sd	s0,1136(sp)
    278c:	46913423          	sd	s1,1128(sp)
    2790:	47213023          	sd	s2,1120(sp)
    2794:	45313c23          	sd	s3,1112(sp)
    2798:	45413823          	sd	s4,1104(sp)
    279c:	45513423          	sd	s5,1096(sp)
    27a0:	45613023          	sd	s6,1088(sp)
    27a4:	43713c23          	sd	s7,1080(sp)
    27a8:	43813823          	sd	s8,1072(sp)
    27ac:	43913423          	sd	s9,1064(sp)
    27b0:	48010413          	add	s0,sp,1152
    27b4:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    27b6:	00004517          	auipc	a0,0x4
    27ba:	92250513          	add	a0,a0,-1758 # 60d8 <malloc+0x11fa>
    27be:	2a2020ef          	jal	4a60 <unlink>
    27c2:	03000993          	li	s3,48
    name[0] = 'b';
    27c6:	06200b93          	li	s7,98
    name[1] = 'i';
    27ca:	06900b13          	li	s6,105
    name[2] = 'g';
    27ce:	06700a93          	li	s5,103
    27d2:	6a41                	lui	s4,0x10
    27d4:	10ba0a13          	add	s4,s4,267 # 1010b <base+0x1493>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    27d8:	07f00c13          	li	s8,127
    27dc:	aab9                	j	293a <diskfull+0x1ba>
      printf("%s: could not create file %s\n", s, name);
    27de:	b8040613          	add	a2,s0,-1152
    27e2:	85e6                	mv	a1,s9
    27e4:	00004517          	auipc	a0,0x4
    27e8:	90450513          	add	a0,a0,-1788 # 60e8 <malloc+0x120a>
    27ec:	63e020ef          	jal	4e2a <printf>
      break;
    27f0:	a039                	j	27fe <diskfull+0x7e>
        close(fd);
    27f2:	854a                	mv	a0,s2
    27f4:	244020ef          	jal	4a38 <close>
    close(fd);
    27f8:	854a                	mv	a0,s2
    27fa:	23e020ef          	jal	4a38 <close>
  for(int i = 0; i < nzz; i++){
    27fe:	4481                	li	s1,0
    name[0] = 'z';
    2800:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2804:	08000993          	li	s3,128
    name[0] = 'z';
    2808:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    280c:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2810:	41f4d71b          	sraw	a4,s1,0x1f
    2814:	01b7571b          	srlw	a4,a4,0x1b
    2818:	009707bb          	addw	a5,a4,s1
    281c:	4057d69b          	sraw	a3,a5,0x5
    2820:	0306869b          	addw	a3,a3,48
    2824:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2828:	8bfd                	and	a5,a5,31
    282a:	9f99                	subw	a5,a5,a4
    282c:	0307879b          	addw	a5,a5,48
    2830:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2834:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2838:	ba040513          	add	a0,s0,-1120
    283c:	224020ef          	jal	4a60 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2840:	60200593          	li	a1,1538
    2844:	ba040513          	add	a0,s0,-1120
    2848:	208020ef          	jal	4a50 <open>
    if(fd < 0)
    284c:	00054763          	bltz	a0,285a <diskfull+0xda>
    close(fd);
    2850:	1e8020ef          	jal	4a38 <close>
  for(int i = 0; i < nzz; i++){
    2854:	2485                	addw	s1,s1,1
    2856:	fb3499e3          	bne	s1,s3,2808 <diskfull+0x88>
  if(mkdir("diskfulldir") == 0)
    285a:	00004517          	auipc	a0,0x4
    285e:	87e50513          	add	a0,a0,-1922 # 60d8 <malloc+0x11fa>
    2862:	216020ef          	jal	4a78 <mkdir>
    2866:	12050063          	beqz	a0,2986 <diskfull+0x206>
  unlink("diskfulldir");
    286a:	00004517          	auipc	a0,0x4
    286e:	86e50513          	add	a0,a0,-1938 # 60d8 <malloc+0x11fa>
    2872:	1ee020ef          	jal	4a60 <unlink>
  for(int i = 0; i < nzz; i++){
    2876:	4481                	li	s1,0
    name[0] = 'z';
    2878:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    287c:	08000993          	li	s3,128
    name[0] = 'z';
    2880:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2884:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2888:	41f4d71b          	sraw	a4,s1,0x1f
    288c:	01b7571b          	srlw	a4,a4,0x1b
    2890:	009707bb          	addw	a5,a4,s1
    2894:	4057d69b          	sraw	a3,a5,0x5
    2898:	0306869b          	addw	a3,a3,48
    289c:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28a0:	8bfd                	and	a5,a5,31
    28a2:	9f99                	subw	a5,a5,a4
    28a4:	0307879b          	addw	a5,a5,48
    28a8:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28ac:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28b0:	ba040513          	add	a0,s0,-1120
    28b4:	1ac020ef          	jal	4a60 <unlink>
  for(int i = 0; i < nzz; i++){
    28b8:	2485                	addw	s1,s1,1
    28ba:	fd3493e3          	bne	s1,s3,2880 <diskfull+0x100>
    28be:	03000493          	li	s1,48
    name[0] = 'b';
    28c2:	06200a93          	li	s5,98
    name[1] = 'i';
    28c6:	06900a13          	li	s4,105
    name[2] = 'g';
    28ca:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    28ce:	07f00913          	li	s2,127
    name[0] = 'b';
    28d2:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    28d6:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    28da:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    28de:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    28e2:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28e6:	ba040513          	add	a0,s0,-1120
    28ea:	176020ef          	jal	4a60 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    28ee:	2485                	addw	s1,s1,1
    28f0:	0ff4f493          	zext.b	s1,s1
    28f4:	fd249fe3          	bne	s1,s2,28d2 <diskfull+0x152>
}
    28f8:	47813083          	ld	ra,1144(sp)
    28fc:	47013403          	ld	s0,1136(sp)
    2900:	46813483          	ld	s1,1128(sp)
    2904:	46013903          	ld	s2,1120(sp)
    2908:	45813983          	ld	s3,1112(sp)
    290c:	45013a03          	ld	s4,1104(sp)
    2910:	44813a83          	ld	s5,1096(sp)
    2914:	44013b03          	ld	s6,1088(sp)
    2918:	43813b83          	ld	s7,1080(sp)
    291c:	43013c03          	ld	s8,1072(sp)
    2920:	42813c83          	ld	s9,1064(sp)
    2924:	48010113          	add	sp,sp,1152
    2928:	8082                	ret
    close(fd);
    292a:	854a                	mv	a0,s2
    292c:	10c020ef          	jal	4a38 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2930:	2985                	addw	s3,s3,1
    2932:	0ff9f993          	zext.b	s3,s3
    2936:	ed8984e3          	beq	s3,s8,27fe <diskfull+0x7e>
    name[0] = 'b';
    293a:	b9740023          	sb	s7,-1152(s0)
    name[1] = 'i';
    293e:	b96400a3          	sb	s6,-1151(s0)
    name[2] = 'g';
    2942:	b9540123          	sb	s5,-1150(s0)
    name[3] = '0' + fi;
    2946:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    294a:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    294e:	b8040513          	add	a0,s0,-1152
    2952:	10e020ef          	jal	4a60 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2956:	60200593          	li	a1,1538
    295a:	b8040513          	add	a0,s0,-1152
    295e:	0f2020ef          	jal	4a50 <open>
    2962:	892a                	mv	s2,a0
    if(fd < 0){
    2964:	e6054de3          	bltz	a0,27de <diskfull+0x5e>
    2968:	84d2                	mv	s1,s4
      if(write(fd, buf, BSIZE) != BSIZE){
    296a:	40000613          	li	a2,1024
    296e:	ba040593          	add	a1,s0,-1120
    2972:	854a                	mv	a0,s2
    2974:	0bc020ef          	jal	4a30 <write>
    2978:	40000793          	li	a5,1024
    297c:	e6f51be3          	bne	a0,a5,27f2 <diskfull+0x72>
    for(int i = 0; i < MAXFILE; i++){
    2980:	34fd                	addw	s1,s1,-1
    2982:	f4e5                	bnez	s1,296a <diskfull+0x1ea>
    2984:	b75d                	j	292a <diskfull+0x1aa>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2986:	85e6                	mv	a1,s9
    2988:	00003517          	auipc	a0,0x3
    298c:	78050513          	add	a0,a0,1920 # 6108 <malloc+0x122a>
    2990:	49a020ef          	jal	4e2a <printf>
    2994:	bdd9                	j	286a <diskfull+0xea>

0000000000002996 <iputtest>:
{
    2996:	1101                	add	sp,sp,-32
    2998:	ec06                	sd	ra,24(sp)
    299a:	e822                	sd	s0,16(sp)
    299c:	e426                	sd	s1,8(sp)
    299e:	1000                	add	s0,sp,32
    29a0:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29a2:	00003517          	auipc	a0,0x3
    29a6:	79650513          	add	a0,a0,1942 # 6138 <malloc+0x125a>
    29aa:	0ce020ef          	jal	4a78 <mkdir>
    29ae:	02054f63          	bltz	a0,29ec <iputtest+0x56>
  if(chdir("iputdir") < 0){
    29b2:	00003517          	auipc	a0,0x3
    29b6:	78650513          	add	a0,a0,1926 # 6138 <malloc+0x125a>
    29ba:	0c6020ef          	jal	4a80 <chdir>
    29be:	04054163          	bltz	a0,2a00 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29c2:	00003517          	auipc	a0,0x3
    29c6:	7b650513          	add	a0,a0,1974 # 6178 <malloc+0x129a>
    29ca:	096020ef          	jal	4a60 <unlink>
    29ce:	04054363          	bltz	a0,2a14 <iputtest+0x7e>
  if(chdir("/") < 0){
    29d2:	00003517          	auipc	a0,0x3
    29d6:	7d650513          	add	a0,a0,2006 # 61a8 <malloc+0x12ca>
    29da:	0a6020ef          	jal	4a80 <chdir>
    29de:	04054563          	bltz	a0,2a28 <iputtest+0x92>
}
    29e2:	60e2                	ld	ra,24(sp)
    29e4:	6442                	ld	s0,16(sp)
    29e6:	64a2                	ld	s1,8(sp)
    29e8:	6105                	add	sp,sp,32
    29ea:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29ec:	85a6                	mv	a1,s1
    29ee:	00003517          	auipc	a0,0x3
    29f2:	75250513          	add	a0,a0,1874 # 6140 <malloc+0x1262>
    29f6:	434020ef          	jal	4e2a <printf>
    exit(1);
    29fa:	4505                	li	a0,1
    29fc:	014020ef          	jal	4a10 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a00:	85a6                	mv	a1,s1
    2a02:	00003517          	auipc	a0,0x3
    2a06:	75650513          	add	a0,a0,1878 # 6158 <malloc+0x127a>
    2a0a:	420020ef          	jal	4e2a <printf>
    exit(1);
    2a0e:	4505                	li	a0,1
    2a10:	000020ef          	jal	4a10 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a14:	85a6                	mv	a1,s1
    2a16:	00003517          	auipc	a0,0x3
    2a1a:	77250513          	add	a0,a0,1906 # 6188 <malloc+0x12aa>
    2a1e:	40c020ef          	jal	4e2a <printf>
    exit(1);
    2a22:	4505                	li	a0,1
    2a24:	7ed010ef          	jal	4a10 <exit>
    printf("%s: chdir / failed\n", s);
    2a28:	85a6                	mv	a1,s1
    2a2a:	00003517          	auipc	a0,0x3
    2a2e:	78650513          	add	a0,a0,1926 # 61b0 <malloc+0x12d2>
    2a32:	3f8020ef          	jal	4e2a <printf>
    exit(1);
    2a36:	4505                	li	a0,1
    2a38:	7d9010ef          	jal	4a10 <exit>

0000000000002a3c <exitiputtest>:
{
    2a3c:	7179                	add	sp,sp,-48
    2a3e:	f406                	sd	ra,40(sp)
    2a40:	f022                	sd	s0,32(sp)
    2a42:	ec26                	sd	s1,24(sp)
    2a44:	1800                	add	s0,sp,48
    2a46:	84aa                	mv	s1,a0
  pid = fork();
    2a48:	7c1010ef          	jal	4a08 <fork>
  if(pid < 0){
    2a4c:	02054e63          	bltz	a0,2a88 <exitiputtest+0x4c>
  if(pid == 0){
    2a50:	e541                	bnez	a0,2ad8 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a52:	00003517          	auipc	a0,0x3
    2a56:	6e650513          	add	a0,a0,1766 # 6138 <malloc+0x125a>
    2a5a:	01e020ef          	jal	4a78 <mkdir>
    2a5e:	02054f63          	bltz	a0,2a9c <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a62:	00003517          	auipc	a0,0x3
    2a66:	6d650513          	add	a0,a0,1750 # 6138 <malloc+0x125a>
    2a6a:	016020ef          	jal	4a80 <chdir>
    2a6e:	04054163          	bltz	a0,2ab0 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2a72:	00003517          	auipc	a0,0x3
    2a76:	70650513          	add	a0,a0,1798 # 6178 <malloc+0x129a>
    2a7a:	7e7010ef          	jal	4a60 <unlink>
    2a7e:	04054363          	bltz	a0,2ac4 <exitiputtest+0x88>
    exit(0);
    2a82:	4501                	li	a0,0
    2a84:	78d010ef          	jal	4a10 <exit>
    printf("%s: fork failed\n", s);
    2a88:	85a6                	mv	a1,s1
    2a8a:	00003517          	auipc	a0,0x3
    2a8e:	dfe50513          	add	a0,a0,-514 # 5888 <malloc+0x9aa>
    2a92:	398020ef          	jal	4e2a <printf>
    exit(1);
    2a96:	4505                	li	a0,1
    2a98:	779010ef          	jal	4a10 <exit>
      printf("%s: mkdir failed\n", s);
    2a9c:	85a6                	mv	a1,s1
    2a9e:	00003517          	auipc	a0,0x3
    2aa2:	6a250513          	add	a0,a0,1698 # 6140 <malloc+0x1262>
    2aa6:	384020ef          	jal	4e2a <printf>
      exit(1);
    2aaa:	4505                	li	a0,1
    2aac:	765010ef          	jal	4a10 <exit>
      printf("%s: child chdir failed\n", s);
    2ab0:	85a6                	mv	a1,s1
    2ab2:	00003517          	auipc	a0,0x3
    2ab6:	71650513          	add	a0,a0,1814 # 61c8 <malloc+0x12ea>
    2aba:	370020ef          	jal	4e2a <printf>
      exit(1);
    2abe:	4505                	li	a0,1
    2ac0:	751010ef          	jal	4a10 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ac4:	85a6                	mv	a1,s1
    2ac6:	00003517          	auipc	a0,0x3
    2aca:	6c250513          	add	a0,a0,1730 # 6188 <malloc+0x12aa>
    2ace:	35c020ef          	jal	4e2a <printf>
      exit(1);
    2ad2:	4505                	li	a0,1
    2ad4:	73d010ef          	jal	4a10 <exit>
  wait(&xstatus);
    2ad8:	fdc40513          	add	a0,s0,-36
    2adc:	73d010ef          	jal	4a18 <wait>
  exit(xstatus);
    2ae0:	fdc42503          	lw	a0,-36(s0)
    2ae4:	72d010ef          	jal	4a10 <exit>

0000000000002ae8 <dirtest>:
{
    2ae8:	1101                	add	sp,sp,-32
    2aea:	ec06                	sd	ra,24(sp)
    2aec:	e822                	sd	s0,16(sp)
    2aee:	e426                	sd	s1,8(sp)
    2af0:	1000                	add	s0,sp,32
    2af2:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2af4:	00003517          	auipc	a0,0x3
    2af8:	6ec50513          	add	a0,a0,1772 # 61e0 <malloc+0x1302>
    2afc:	77d010ef          	jal	4a78 <mkdir>
    2b00:	02054f63          	bltz	a0,2b3e <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b04:	00003517          	auipc	a0,0x3
    2b08:	6dc50513          	add	a0,a0,1756 # 61e0 <malloc+0x1302>
    2b0c:	775010ef          	jal	4a80 <chdir>
    2b10:	04054163          	bltz	a0,2b52 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b14:	00003517          	auipc	a0,0x3
    2b18:	6ec50513          	add	a0,a0,1772 # 6200 <malloc+0x1322>
    2b1c:	765010ef          	jal	4a80 <chdir>
    2b20:	04054363          	bltz	a0,2b66 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b24:	00003517          	auipc	a0,0x3
    2b28:	6bc50513          	add	a0,a0,1724 # 61e0 <malloc+0x1302>
    2b2c:	735010ef          	jal	4a60 <unlink>
    2b30:	04054563          	bltz	a0,2b7a <dirtest+0x92>
}
    2b34:	60e2                	ld	ra,24(sp)
    2b36:	6442                	ld	s0,16(sp)
    2b38:	64a2                	ld	s1,8(sp)
    2b3a:	6105                	add	sp,sp,32
    2b3c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b3e:	85a6                	mv	a1,s1
    2b40:	00003517          	auipc	a0,0x3
    2b44:	60050513          	add	a0,a0,1536 # 6140 <malloc+0x1262>
    2b48:	2e2020ef          	jal	4e2a <printf>
    exit(1);
    2b4c:	4505                	li	a0,1
    2b4e:	6c3010ef          	jal	4a10 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b52:	85a6                	mv	a1,s1
    2b54:	00003517          	auipc	a0,0x3
    2b58:	69450513          	add	a0,a0,1684 # 61e8 <malloc+0x130a>
    2b5c:	2ce020ef          	jal	4e2a <printf>
    exit(1);
    2b60:	4505                	li	a0,1
    2b62:	6af010ef          	jal	4a10 <exit>
    printf("%s: chdir .. failed\n", s);
    2b66:	85a6                	mv	a1,s1
    2b68:	00003517          	auipc	a0,0x3
    2b6c:	6a050513          	add	a0,a0,1696 # 6208 <malloc+0x132a>
    2b70:	2ba020ef          	jal	4e2a <printf>
    exit(1);
    2b74:	4505                	li	a0,1
    2b76:	69b010ef          	jal	4a10 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b7a:	85a6                	mv	a1,s1
    2b7c:	00003517          	auipc	a0,0x3
    2b80:	6a450513          	add	a0,a0,1700 # 6220 <malloc+0x1342>
    2b84:	2a6020ef          	jal	4e2a <printf>
    exit(1);
    2b88:	4505                	li	a0,1
    2b8a:	687010ef          	jal	4a10 <exit>

0000000000002b8e <subdir>:
{
    2b8e:	1101                	add	sp,sp,-32
    2b90:	ec06                	sd	ra,24(sp)
    2b92:	e822                	sd	s0,16(sp)
    2b94:	e426                	sd	s1,8(sp)
    2b96:	e04a                	sd	s2,0(sp)
    2b98:	1000                	add	s0,sp,32
    2b9a:	892a                	mv	s2,a0
  unlink("ff");
    2b9c:	00003517          	auipc	a0,0x3
    2ba0:	7cc50513          	add	a0,a0,1996 # 6368 <malloc+0x148a>
    2ba4:	6bd010ef          	jal	4a60 <unlink>
  if(mkdir("dd") != 0){
    2ba8:	00003517          	auipc	a0,0x3
    2bac:	69050513          	add	a0,a0,1680 # 6238 <malloc+0x135a>
    2bb0:	6c9010ef          	jal	4a78 <mkdir>
    2bb4:	2e051263          	bnez	a0,2e98 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb8:	20200593          	li	a1,514
    2bbc:	00003517          	auipc	a0,0x3
    2bc0:	69c50513          	add	a0,a0,1692 # 6258 <malloc+0x137a>
    2bc4:	68d010ef          	jal	4a50 <open>
    2bc8:	84aa                	mv	s1,a0
  if(fd < 0){
    2bca:	2e054163          	bltz	a0,2eac <subdir+0x31e>
  write(fd, "ff", 2);
    2bce:	4609                	li	a2,2
    2bd0:	00003597          	auipc	a1,0x3
    2bd4:	79858593          	add	a1,a1,1944 # 6368 <malloc+0x148a>
    2bd8:	659010ef          	jal	4a30 <write>
  close(fd);
    2bdc:	8526                	mv	a0,s1
    2bde:	65b010ef          	jal	4a38 <close>
  if(unlink("dd") >= 0){
    2be2:	00003517          	auipc	a0,0x3
    2be6:	65650513          	add	a0,a0,1622 # 6238 <malloc+0x135a>
    2bea:	677010ef          	jal	4a60 <unlink>
    2bee:	2c055963          	bgez	a0,2ec0 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2bf2:	00003517          	auipc	a0,0x3
    2bf6:	6be50513          	add	a0,a0,1726 # 62b0 <malloc+0x13d2>
    2bfa:	67f010ef          	jal	4a78 <mkdir>
    2bfe:	2c051b63          	bnez	a0,2ed4 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c02:	20200593          	li	a1,514
    2c06:	00003517          	auipc	a0,0x3
    2c0a:	6d250513          	add	a0,a0,1746 # 62d8 <malloc+0x13fa>
    2c0e:	643010ef          	jal	4a50 <open>
    2c12:	84aa                	mv	s1,a0
  if(fd < 0){
    2c14:	2c054a63          	bltz	a0,2ee8 <subdir+0x35a>
  write(fd, "FF", 2);
    2c18:	4609                	li	a2,2
    2c1a:	00003597          	auipc	a1,0x3
    2c1e:	6ee58593          	add	a1,a1,1774 # 6308 <malloc+0x142a>
    2c22:	60f010ef          	jal	4a30 <write>
  close(fd);
    2c26:	8526                	mv	a0,s1
    2c28:	611010ef          	jal	4a38 <close>
  fd = open("dd/dd/../ff", 0);
    2c2c:	4581                	li	a1,0
    2c2e:	00003517          	auipc	a0,0x3
    2c32:	6e250513          	add	a0,a0,1762 # 6310 <malloc+0x1432>
    2c36:	61b010ef          	jal	4a50 <open>
    2c3a:	84aa                	mv	s1,a0
  if(fd < 0){
    2c3c:	2c054063          	bltz	a0,2efc <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c40:	660d                	lui	a2,0x3
    2c42:	00009597          	auipc	a1,0x9
    2c46:	03658593          	add	a1,a1,54 # bc78 <buf>
    2c4a:	5df010ef          	jal	4a28 <read>
  if(cc != 2 || buf[0] != 'f'){
    2c4e:	4789                	li	a5,2
    2c50:	2cf51063          	bne	a0,a5,2f10 <subdir+0x382>
    2c54:	00009717          	auipc	a4,0x9
    2c58:	02474703          	lbu	a4,36(a4) # bc78 <buf>
    2c5c:	06600793          	li	a5,102
    2c60:	2af71863          	bne	a4,a5,2f10 <subdir+0x382>
  close(fd);
    2c64:	8526                	mv	a0,s1
    2c66:	5d3010ef          	jal	4a38 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c6a:	00003597          	auipc	a1,0x3
    2c6e:	6f658593          	add	a1,a1,1782 # 6360 <malloc+0x1482>
    2c72:	00003517          	auipc	a0,0x3
    2c76:	66650513          	add	a0,a0,1638 # 62d8 <malloc+0x13fa>
    2c7a:	5f7010ef          	jal	4a70 <link>
    2c7e:	2a051363          	bnez	a0,2f24 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2c82:	00003517          	auipc	a0,0x3
    2c86:	65650513          	add	a0,a0,1622 # 62d8 <malloc+0x13fa>
    2c8a:	5d7010ef          	jal	4a60 <unlink>
    2c8e:	2a051563          	bnez	a0,2f38 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2c92:	4581                	li	a1,0
    2c94:	00003517          	auipc	a0,0x3
    2c98:	64450513          	add	a0,a0,1604 # 62d8 <malloc+0x13fa>
    2c9c:	5b5010ef          	jal	4a50 <open>
    2ca0:	2a055663          	bgez	a0,2f4c <subdir+0x3be>
  if(chdir("dd") != 0){
    2ca4:	00003517          	auipc	a0,0x3
    2ca8:	59450513          	add	a0,a0,1428 # 6238 <malloc+0x135a>
    2cac:	5d5010ef          	jal	4a80 <chdir>
    2cb0:	2a051863          	bnez	a0,2f60 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2cb4:	00003517          	auipc	a0,0x3
    2cb8:	74450513          	add	a0,a0,1860 # 63f8 <malloc+0x151a>
    2cbc:	5c5010ef          	jal	4a80 <chdir>
    2cc0:	2a051a63          	bnez	a0,2f74 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2cc4:	00003517          	auipc	a0,0x3
    2cc8:	76450513          	add	a0,a0,1892 # 6428 <malloc+0x154a>
    2ccc:	5b5010ef          	jal	4a80 <chdir>
    2cd0:	2a051c63          	bnez	a0,2f88 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2cd4:	00003517          	auipc	a0,0x3
    2cd8:	78c50513          	add	a0,a0,1932 # 6460 <malloc+0x1582>
    2cdc:	5a5010ef          	jal	4a80 <chdir>
    2ce0:	2a051e63          	bnez	a0,2f9c <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2ce4:	4581                	li	a1,0
    2ce6:	00003517          	auipc	a0,0x3
    2cea:	67a50513          	add	a0,a0,1658 # 6360 <malloc+0x1482>
    2cee:	563010ef          	jal	4a50 <open>
    2cf2:	84aa                	mv	s1,a0
  if(fd < 0){
    2cf4:	2a054e63          	bltz	a0,2fb0 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2cf8:	660d                	lui	a2,0x3
    2cfa:	00009597          	auipc	a1,0x9
    2cfe:	f7e58593          	add	a1,a1,-130 # bc78 <buf>
    2d02:	527010ef          	jal	4a28 <read>
    2d06:	4789                	li	a5,2
    2d08:	2af51e63          	bne	a0,a5,2fc4 <subdir+0x436>
  close(fd);
    2d0c:	8526                	mv	a0,s1
    2d0e:	52b010ef          	jal	4a38 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d12:	4581                	li	a1,0
    2d14:	00003517          	auipc	a0,0x3
    2d18:	5c450513          	add	a0,a0,1476 # 62d8 <malloc+0x13fa>
    2d1c:	535010ef          	jal	4a50 <open>
    2d20:	2a055c63          	bgez	a0,2fd8 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d24:	20200593          	li	a1,514
    2d28:	00003517          	auipc	a0,0x3
    2d2c:	7c850513          	add	a0,a0,1992 # 64f0 <malloc+0x1612>
    2d30:	521010ef          	jal	4a50 <open>
    2d34:	2a055c63          	bgez	a0,2fec <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d38:	20200593          	li	a1,514
    2d3c:	00003517          	auipc	a0,0x3
    2d40:	7e450513          	add	a0,a0,2020 # 6520 <malloc+0x1642>
    2d44:	50d010ef          	jal	4a50 <open>
    2d48:	2a055c63          	bgez	a0,3000 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d4c:	20000593          	li	a1,512
    2d50:	00003517          	auipc	a0,0x3
    2d54:	4e850513          	add	a0,a0,1256 # 6238 <malloc+0x135a>
    2d58:	4f9010ef          	jal	4a50 <open>
    2d5c:	2a055c63          	bgez	a0,3014 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d60:	4589                	li	a1,2
    2d62:	00003517          	auipc	a0,0x3
    2d66:	4d650513          	add	a0,a0,1238 # 6238 <malloc+0x135a>
    2d6a:	4e7010ef          	jal	4a50 <open>
    2d6e:	2a055d63          	bgez	a0,3028 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2d72:	4585                	li	a1,1
    2d74:	00003517          	auipc	a0,0x3
    2d78:	4c450513          	add	a0,a0,1220 # 6238 <malloc+0x135a>
    2d7c:	4d5010ef          	jal	4a50 <open>
    2d80:	2a055e63          	bgez	a0,303c <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2d84:	00004597          	auipc	a1,0x4
    2d88:	82c58593          	add	a1,a1,-2004 # 65b0 <malloc+0x16d2>
    2d8c:	00003517          	auipc	a0,0x3
    2d90:	76450513          	add	a0,a0,1892 # 64f0 <malloc+0x1612>
    2d94:	4dd010ef          	jal	4a70 <link>
    2d98:	2a050c63          	beqz	a0,3050 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2d9c:	00004597          	auipc	a1,0x4
    2da0:	81458593          	add	a1,a1,-2028 # 65b0 <malloc+0x16d2>
    2da4:	00003517          	auipc	a0,0x3
    2da8:	77c50513          	add	a0,a0,1916 # 6520 <malloc+0x1642>
    2dac:	4c5010ef          	jal	4a70 <link>
    2db0:	2a050a63          	beqz	a0,3064 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2db4:	00003597          	auipc	a1,0x3
    2db8:	5ac58593          	add	a1,a1,1452 # 6360 <malloc+0x1482>
    2dbc:	00003517          	auipc	a0,0x3
    2dc0:	49c50513          	add	a0,a0,1180 # 6258 <malloc+0x137a>
    2dc4:	4ad010ef          	jal	4a70 <link>
    2dc8:	2a050863          	beqz	a0,3078 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2dcc:	00003517          	auipc	a0,0x3
    2dd0:	72450513          	add	a0,a0,1828 # 64f0 <malloc+0x1612>
    2dd4:	4a5010ef          	jal	4a78 <mkdir>
    2dd8:	2a050a63          	beqz	a0,308c <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2ddc:	00003517          	auipc	a0,0x3
    2de0:	74450513          	add	a0,a0,1860 # 6520 <malloc+0x1642>
    2de4:	495010ef          	jal	4a78 <mkdir>
    2de8:	2a050c63          	beqz	a0,30a0 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2dec:	00003517          	auipc	a0,0x3
    2df0:	57450513          	add	a0,a0,1396 # 6360 <malloc+0x1482>
    2df4:	485010ef          	jal	4a78 <mkdir>
    2df8:	2a050e63          	beqz	a0,30b4 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2dfc:	00003517          	auipc	a0,0x3
    2e00:	72450513          	add	a0,a0,1828 # 6520 <malloc+0x1642>
    2e04:	45d010ef          	jal	4a60 <unlink>
    2e08:	2c050063          	beqz	a0,30c8 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e0c:	00003517          	auipc	a0,0x3
    2e10:	6e450513          	add	a0,a0,1764 # 64f0 <malloc+0x1612>
    2e14:	44d010ef          	jal	4a60 <unlink>
    2e18:	2c050263          	beqz	a0,30dc <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e1c:	00003517          	auipc	a0,0x3
    2e20:	43c50513          	add	a0,a0,1084 # 6258 <malloc+0x137a>
    2e24:	45d010ef          	jal	4a80 <chdir>
    2e28:	2c050463          	beqz	a0,30f0 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	8d450513          	add	a0,a0,-1836 # 6700 <malloc+0x1822>
    2e34:	44d010ef          	jal	4a80 <chdir>
    2e38:	2c050663          	beqz	a0,3104 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e3c:	00003517          	auipc	a0,0x3
    2e40:	52450513          	add	a0,a0,1316 # 6360 <malloc+0x1482>
    2e44:	41d010ef          	jal	4a60 <unlink>
    2e48:	2c051863          	bnez	a0,3118 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e4c:	00003517          	auipc	a0,0x3
    2e50:	40c50513          	add	a0,a0,1036 # 6258 <malloc+0x137a>
    2e54:	40d010ef          	jal	4a60 <unlink>
    2e58:	2c051a63          	bnez	a0,312c <subdir+0x59e>
  if(unlink("dd") == 0){
    2e5c:	00003517          	auipc	a0,0x3
    2e60:	3dc50513          	add	a0,a0,988 # 6238 <malloc+0x135a>
    2e64:	3fd010ef          	jal	4a60 <unlink>
    2e68:	2c050c63          	beqz	a0,3140 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	90450513          	add	a0,a0,-1788 # 6770 <malloc+0x1892>
    2e74:	3ed010ef          	jal	4a60 <unlink>
    2e78:	2c054e63          	bltz	a0,3154 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2e7c:	00003517          	auipc	a0,0x3
    2e80:	3bc50513          	add	a0,a0,956 # 6238 <malloc+0x135a>
    2e84:	3dd010ef          	jal	4a60 <unlink>
    2e88:	2e054063          	bltz	a0,3168 <subdir+0x5da>
}
    2e8c:	60e2                	ld	ra,24(sp)
    2e8e:	6442                	ld	s0,16(sp)
    2e90:	64a2                	ld	s1,8(sp)
    2e92:	6902                	ld	s2,0(sp)
    2e94:	6105                	add	sp,sp,32
    2e96:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e98:	85ca                	mv	a1,s2
    2e9a:	00003517          	auipc	a0,0x3
    2e9e:	3a650513          	add	a0,a0,934 # 6240 <malloc+0x1362>
    2ea2:	789010ef          	jal	4e2a <printf>
    exit(1);
    2ea6:	4505                	li	a0,1
    2ea8:	369010ef          	jal	4a10 <exit>
    printf("%s: create dd/ff failed\n", s);
    2eac:	85ca                	mv	a1,s2
    2eae:	00003517          	auipc	a0,0x3
    2eb2:	3b250513          	add	a0,a0,946 # 6260 <malloc+0x1382>
    2eb6:	775010ef          	jal	4e2a <printf>
    exit(1);
    2eba:	4505                	li	a0,1
    2ebc:	355010ef          	jal	4a10 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ec0:	85ca                	mv	a1,s2
    2ec2:	00003517          	auipc	a0,0x3
    2ec6:	3be50513          	add	a0,a0,958 # 6280 <malloc+0x13a2>
    2eca:	761010ef          	jal	4e2a <printf>
    exit(1);
    2ece:	4505                	li	a0,1
    2ed0:	341010ef          	jal	4a10 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ed4:	85ca                	mv	a1,s2
    2ed6:	00003517          	auipc	a0,0x3
    2eda:	3e250513          	add	a0,a0,994 # 62b8 <malloc+0x13da>
    2ede:	74d010ef          	jal	4e2a <printf>
    exit(1);
    2ee2:	4505                	li	a0,1
    2ee4:	32d010ef          	jal	4a10 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee8:	85ca                	mv	a1,s2
    2eea:	00003517          	auipc	a0,0x3
    2eee:	3fe50513          	add	a0,a0,1022 # 62e8 <malloc+0x140a>
    2ef2:	739010ef          	jal	4e2a <printf>
    exit(1);
    2ef6:	4505                	li	a0,1
    2ef8:	319010ef          	jal	4a10 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2efc:	85ca                	mv	a1,s2
    2efe:	00003517          	auipc	a0,0x3
    2f02:	42250513          	add	a0,a0,1058 # 6320 <malloc+0x1442>
    2f06:	725010ef          	jal	4e2a <printf>
    exit(1);
    2f0a:	4505                	li	a0,1
    2f0c:	305010ef          	jal	4a10 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f10:	85ca                	mv	a1,s2
    2f12:	00003517          	auipc	a0,0x3
    2f16:	42e50513          	add	a0,a0,1070 # 6340 <malloc+0x1462>
    2f1a:	711010ef          	jal	4e2a <printf>
    exit(1);
    2f1e:	4505                	li	a0,1
    2f20:	2f1010ef          	jal	4a10 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f24:	85ca                	mv	a1,s2
    2f26:	00003517          	auipc	a0,0x3
    2f2a:	44a50513          	add	a0,a0,1098 # 6370 <malloc+0x1492>
    2f2e:	6fd010ef          	jal	4e2a <printf>
    exit(1);
    2f32:	4505                	li	a0,1
    2f34:	2dd010ef          	jal	4a10 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f38:	85ca                	mv	a1,s2
    2f3a:	00003517          	auipc	a0,0x3
    2f3e:	45e50513          	add	a0,a0,1118 # 6398 <malloc+0x14ba>
    2f42:	6e9010ef          	jal	4e2a <printf>
    exit(1);
    2f46:	4505                	li	a0,1
    2f48:	2c9010ef          	jal	4a10 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f4c:	85ca                	mv	a1,s2
    2f4e:	00003517          	auipc	a0,0x3
    2f52:	46a50513          	add	a0,a0,1130 # 63b8 <malloc+0x14da>
    2f56:	6d5010ef          	jal	4e2a <printf>
    exit(1);
    2f5a:	4505                	li	a0,1
    2f5c:	2b5010ef          	jal	4a10 <exit>
    printf("%s: chdir dd failed\n", s);
    2f60:	85ca                	mv	a1,s2
    2f62:	00003517          	auipc	a0,0x3
    2f66:	47e50513          	add	a0,a0,1150 # 63e0 <malloc+0x1502>
    2f6a:	6c1010ef          	jal	4e2a <printf>
    exit(1);
    2f6e:	4505                	li	a0,1
    2f70:	2a1010ef          	jal	4a10 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f74:	85ca                	mv	a1,s2
    2f76:	00003517          	auipc	a0,0x3
    2f7a:	49250513          	add	a0,a0,1170 # 6408 <malloc+0x152a>
    2f7e:	6ad010ef          	jal	4e2a <printf>
    exit(1);
    2f82:	4505                	li	a0,1
    2f84:	28d010ef          	jal	4a10 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f88:	85ca                	mv	a1,s2
    2f8a:	00003517          	auipc	a0,0x3
    2f8e:	4ae50513          	add	a0,a0,1198 # 6438 <malloc+0x155a>
    2f92:	699010ef          	jal	4e2a <printf>
    exit(1);
    2f96:	4505                	li	a0,1
    2f98:	279010ef          	jal	4a10 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f9c:	85ca                	mv	a1,s2
    2f9e:	00003517          	auipc	a0,0x3
    2fa2:	4ca50513          	add	a0,a0,1226 # 6468 <malloc+0x158a>
    2fa6:	685010ef          	jal	4e2a <printf>
    exit(1);
    2faa:	4505                	li	a0,1
    2fac:	265010ef          	jal	4a10 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fb0:	85ca                	mv	a1,s2
    2fb2:	00003517          	auipc	a0,0x3
    2fb6:	4ce50513          	add	a0,a0,1230 # 6480 <malloc+0x15a2>
    2fba:	671010ef          	jal	4e2a <printf>
    exit(1);
    2fbe:	4505                	li	a0,1
    2fc0:	251010ef          	jal	4a10 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fc4:	85ca                	mv	a1,s2
    2fc6:	00003517          	auipc	a0,0x3
    2fca:	4da50513          	add	a0,a0,1242 # 64a0 <malloc+0x15c2>
    2fce:	65d010ef          	jal	4e2a <printf>
    exit(1);
    2fd2:	4505                	li	a0,1
    2fd4:	23d010ef          	jal	4a10 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd8:	85ca                	mv	a1,s2
    2fda:	00003517          	auipc	a0,0x3
    2fde:	4e650513          	add	a0,a0,1254 # 64c0 <malloc+0x15e2>
    2fe2:	649010ef          	jal	4e2a <printf>
    exit(1);
    2fe6:	4505                	li	a0,1
    2fe8:	229010ef          	jal	4a10 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fec:	85ca                	mv	a1,s2
    2fee:	00003517          	auipc	a0,0x3
    2ff2:	51250513          	add	a0,a0,1298 # 6500 <malloc+0x1622>
    2ff6:	635010ef          	jal	4e2a <printf>
    exit(1);
    2ffa:	4505                	li	a0,1
    2ffc:	215010ef          	jal	4a10 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3000:	85ca                	mv	a1,s2
    3002:	00003517          	auipc	a0,0x3
    3006:	52e50513          	add	a0,a0,1326 # 6530 <malloc+0x1652>
    300a:	621010ef          	jal	4e2a <printf>
    exit(1);
    300e:	4505                	li	a0,1
    3010:	201010ef          	jal	4a10 <exit>
    printf("%s: create dd succeeded!\n", s);
    3014:	85ca                	mv	a1,s2
    3016:	00003517          	auipc	a0,0x3
    301a:	53a50513          	add	a0,a0,1338 # 6550 <malloc+0x1672>
    301e:	60d010ef          	jal	4e2a <printf>
    exit(1);
    3022:	4505                	li	a0,1
    3024:	1ed010ef          	jal	4a10 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3028:	85ca                	mv	a1,s2
    302a:	00003517          	auipc	a0,0x3
    302e:	54650513          	add	a0,a0,1350 # 6570 <malloc+0x1692>
    3032:	5f9010ef          	jal	4e2a <printf>
    exit(1);
    3036:	4505                	li	a0,1
    3038:	1d9010ef          	jal	4a10 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    303c:	85ca                	mv	a1,s2
    303e:	00003517          	auipc	a0,0x3
    3042:	55250513          	add	a0,a0,1362 # 6590 <malloc+0x16b2>
    3046:	5e5010ef          	jal	4e2a <printf>
    exit(1);
    304a:	4505                	li	a0,1
    304c:	1c5010ef          	jal	4a10 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3050:	85ca                	mv	a1,s2
    3052:	00003517          	auipc	a0,0x3
    3056:	56e50513          	add	a0,a0,1390 # 65c0 <malloc+0x16e2>
    305a:	5d1010ef          	jal	4e2a <printf>
    exit(1);
    305e:	4505                	li	a0,1
    3060:	1b1010ef          	jal	4a10 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3064:	85ca                	mv	a1,s2
    3066:	00003517          	auipc	a0,0x3
    306a:	58250513          	add	a0,a0,1410 # 65e8 <malloc+0x170a>
    306e:	5bd010ef          	jal	4e2a <printf>
    exit(1);
    3072:	4505                	li	a0,1
    3074:	19d010ef          	jal	4a10 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3078:	85ca                	mv	a1,s2
    307a:	00003517          	auipc	a0,0x3
    307e:	59650513          	add	a0,a0,1430 # 6610 <malloc+0x1732>
    3082:	5a9010ef          	jal	4e2a <printf>
    exit(1);
    3086:	4505                	li	a0,1
    3088:	189010ef          	jal	4a10 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    308c:	85ca                	mv	a1,s2
    308e:	00003517          	auipc	a0,0x3
    3092:	5aa50513          	add	a0,a0,1450 # 6638 <malloc+0x175a>
    3096:	595010ef          	jal	4e2a <printf>
    exit(1);
    309a:	4505                	li	a0,1
    309c:	175010ef          	jal	4a10 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    30a0:	85ca                	mv	a1,s2
    30a2:	00003517          	auipc	a0,0x3
    30a6:	5b650513          	add	a0,a0,1462 # 6658 <malloc+0x177a>
    30aa:	581010ef          	jal	4e2a <printf>
    exit(1);
    30ae:	4505                	li	a0,1
    30b0:	161010ef          	jal	4a10 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30b4:	85ca                	mv	a1,s2
    30b6:	00003517          	auipc	a0,0x3
    30ba:	5c250513          	add	a0,a0,1474 # 6678 <malloc+0x179a>
    30be:	56d010ef          	jal	4e2a <printf>
    exit(1);
    30c2:	4505                	li	a0,1
    30c4:	14d010ef          	jal	4a10 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c8:	85ca                	mv	a1,s2
    30ca:	00003517          	auipc	a0,0x3
    30ce:	5d650513          	add	a0,a0,1494 # 66a0 <malloc+0x17c2>
    30d2:	559010ef          	jal	4e2a <printf>
    exit(1);
    30d6:	4505                	li	a0,1
    30d8:	139010ef          	jal	4a10 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30dc:	85ca                	mv	a1,s2
    30de:	00003517          	auipc	a0,0x3
    30e2:	5e250513          	add	a0,a0,1506 # 66c0 <malloc+0x17e2>
    30e6:	545010ef          	jal	4e2a <printf>
    exit(1);
    30ea:	4505                	li	a0,1
    30ec:	125010ef          	jal	4a10 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30f0:	85ca                	mv	a1,s2
    30f2:	00003517          	auipc	a0,0x3
    30f6:	5ee50513          	add	a0,a0,1518 # 66e0 <malloc+0x1802>
    30fa:	531010ef          	jal	4e2a <printf>
    exit(1);
    30fe:	4505                	li	a0,1
    3100:	111010ef          	jal	4a10 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3104:	85ca                	mv	a1,s2
    3106:	00003517          	auipc	a0,0x3
    310a:	60250513          	add	a0,a0,1538 # 6708 <malloc+0x182a>
    310e:	51d010ef          	jal	4e2a <printf>
    exit(1);
    3112:	4505                	li	a0,1
    3114:	0fd010ef          	jal	4a10 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3118:	85ca                	mv	a1,s2
    311a:	00003517          	auipc	a0,0x3
    311e:	27e50513          	add	a0,a0,638 # 6398 <malloc+0x14ba>
    3122:	509010ef          	jal	4e2a <printf>
    exit(1);
    3126:	4505                	li	a0,1
    3128:	0e9010ef          	jal	4a10 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    312c:	85ca                	mv	a1,s2
    312e:	00003517          	auipc	a0,0x3
    3132:	5fa50513          	add	a0,a0,1530 # 6728 <malloc+0x184a>
    3136:	4f5010ef          	jal	4e2a <printf>
    exit(1);
    313a:	4505                	li	a0,1
    313c:	0d5010ef          	jal	4a10 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3140:	85ca                	mv	a1,s2
    3142:	00003517          	auipc	a0,0x3
    3146:	60650513          	add	a0,a0,1542 # 6748 <malloc+0x186a>
    314a:	4e1010ef          	jal	4e2a <printf>
    exit(1);
    314e:	4505                	li	a0,1
    3150:	0c1010ef          	jal	4a10 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3154:	85ca                	mv	a1,s2
    3156:	00003517          	auipc	a0,0x3
    315a:	62250513          	add	a0,a0,1570 # 6778 <malloc+0x189a>
    315e:	4cd010ef          	jal	4e2a <printf>
    exit(1);
    3162:	4505                	li	a0,1
    3164:	0ad010ef          	jal	4a10 <exit>
    printf("%s: unlink dd failed\n", s);
    3168:	85ca                	mv	a1,s2
    316a:	00003517          	auipc	a0,0x3
    316e:	62e50513          	add	a0,a0,1582 # 6798 <malloc+0x18ba>
    3172:	4b9010ef          	jal	4e2a <printf>
    exit(1);
    3176:	4505                	li	a0,1
    3178:	099010ef          	jal	4a10 <exit>

000000000000317c <rmdot>:
{
    317c:	1101                	add	sp,sp,-32
    317e:	ec06                	sd	ra,24(sp)
    3180:	e822                	sd	s0,16(sp)
    3182:	e426                	sd	s1,8(sp)
    3184:	1000                	add	s0,sp,32
    3186:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3188:	00003517          	auipc	a0,0x3
    318c:	62850513          	add	a0,a0,1576 # 67b0 <malloc+0x18d2>
    3190:	0e9010ef          	jal	4a78 <mkdir>
    3194:	e53d                	bnez	a0,3202 <rmdot+0x86>
  if(chdir("dots") != 0){
    3196:	00003517          	auipc	a0,0x3
    319a:	61a50513          	add	a0,a0,1562 # 67b0 <malloc+0x18d2>
    319e:	0e3010ef          	jal	4a80 <chdir>
    31a2:	e935                	bnez	a0,3216 <rmdot+0x9a>
  if(unlink(".") == 0){
    31a4:	00002517          	auipc	a0,0x2
    31a8:	53c50513          	add	a0,a0,1340 # 56e0 <malloc+0x802>
    31ac:	0b5010ef          	jal	4a60 <unlink>
    31b0:	cd2d                	beqz	a0,322a <rmdot+0xae>
  if(unlink("..") == 0){
    31b2:	00003517          	auipc	a0,0x3
    31b6:	04e50513          	add	a0,a0,78 # 6200 <malloc+0x1322>
    31ba:	0a7010ef          	jal	4a60 <unlink>
    31be:	c141                	beqz	a0,323e <rmdot+0xc2>
  if(chdir("/") != 0){
    31c0:	00003517          	auipc	a0,0x3
    31c4:	fe850513          	add	a0,a0,-24 # 61a8 <malloc+0x12ca>
    31c8:	0b9010ef          	jal	4a80 <chdir>
    31cc:	e159                	bnez	a0,3252 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    31ce:	00003517          	auipc	a0,0x3
    31d2:	64a50513          	add	a0,a0,1610 # 6818 <malloc+0x193a>
    31d6:	08b010ef          	jal	4a60 <unlink>
    31da:	c551                	beqz	a0,3266 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    31dc:	00003517          	auipc	a0,0x3
    31e0:	66450513          	add	a0,a0,1636 # 6840 <malloc+0x1962>
    31e4:	07d010ef          	jal	4a60 <unlink>
    31e8:	c949                	beqz	a0,327a <rmdot+0xfe>
  if(unlink("dots") != 0){
    31ea:	00003517          	auipc	a0,0x3
    31ee:	5c650513          	add	a0,a0,1478 # 67b0 <malloc+0x18d2>
    31f2:	06f010ef          	jal	4a60 <unlink>
    31f6:	ed41                	bnez	a0,328e <rmdot+0x112>
}
    31f8:	60e2                	ld	ra,24(sp)
    31fa:	6442                	ld	s0,16(sp)
    31fc:	64a2                	ld	s1,8(sp)
    31fe:	6105                	add	sp,sp,32
    3200:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3202:	85a6                	mv	a1,s1
    3204:	00003517          	auipc	a0,0x3
    3208:	5b450513          	add	a0,a0,1460 # 67b8 <malloc+0x18da>
    320c:	41f010ef          	jal	4e2a <printf>
    exit(1);
    3210:	4505                	li	a0,1
    3212:	7fe010ef          	jal	4a10 <exit>
    printf("%s: chdir dots failed\n", s);
    3216:	85a6                	mv	a1,s1
    3218:	00003517          	auipc	a0,0x3
    321c:	5b850513          	add	a0,a0,1464 # 67d0 <malloc+0x18f2>
    3220:	40b010ef          	jal	4e2a <printf>
    exit(1);
    3224:	4505                	li	a0,1
    3226:	7ea010ef          	jal	4a10 <exit>
    printf("%s: rm . worked!\n", s);
    322a:	85a6                	mv	a1,s1
    322c:	00003517          	auipc	a0,0x3
    3230:	5bc50513          	add	a0,a0,1468 # 67e8 <malloc+0x190a>
    3234:	3f7010ef          	jal	4e2a <printf>
    exit(1);
    3238:	4505                	li	a0,1
    323a:	7d6010ef          	jal	4a10 <exit>
    printf("%s: rm .. worked!\n", s);
    323e:	85a6                	mv	a1,s1
    3240:	00003517          	auipc	a0,0x3
    3244:	5c050513          	add	a0,a0,1472 # 6800 <malloc+0x1922>
    3248:	3e3010ef          	jal	4e2a <printf>
    exit(1);
    324c:	4505                	li	a0,1
    324e:	7c2010ef          	jal	4a10 <exit>
    printf("%s: chdir / failed\n", s);
    3252:	85a6                	mv	a1,s1
    3254:	00003517          	auipc	a0,0x3
    3258:	f5c50513          	add	a0,a0,-164 # 61b0 <malloc+0x12d2>
    325c:	3cf010ef          	jal	4e2a <printf>
    exit(1);
    3260:	4505                	li	a0,1
    3262:	7ae010ef          	jal	4a10 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3266:	85a6                	mv	a1,s1
    3268:	00003517          	auipc	a0,0x3
    326c:	5b850513          	add	a0,a0,1464 # 6820 <malloc+0x1942>
    3270:	3bb010ef          	jal	4e2a <printf>
    exit(1);
    3274:	4505                	li	a0,1
    3276:	79a010ef          	jal	4a10 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    327a:	85a6                	mv	a1,s1
    327c:	00003517          	auipc	a0,0x3
    3280:	5cc50513          	add	a0,a0,1484 # 6848 <malloc+0x196a>
    3284:	3a7010ef          	jal	4e2a <printf>
    exit(1);
    3288:	4505                	li	a0,1
    328a:	786010ef          	jal	4a10 <exit>
    printf("%s: unlink dots failed!\n", s);
    328e:	85a6                	mv	a1,s1
    3290:	00003517          	auipc	a0,0x3
    3294:	5d850513          	add	a0,a0,1496 # 6868 <malloc+0x198a>
    3298:	393010ef          	jal	4e2a <printf>
    exit(1);
    329c:	4505                	li	a0,1
    329e:	772010ef          	jal	4a10 <exit>

00000000000032a2 <dirfile>:
{
    32a2:	1101                	add	sp,sp,-32
    32a4:	ec06                	sd	ra,24(sp)
    32a6:	e822                	sd	s0,16(sp)
    32a8:	e426                	sd	s1,8(sp)
    32aa:	e04a                	sd	s2,0(sp)
    32ac:	1000                	add	s0,sp,32
    32ae:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32b0:	20000593          	li	a1,512
    32b4:	00003517          	auipc	a0,0x3
    32b8:	5d450513          	add	a0,a0,1492 # 6888 <malloc+0x19aa>
    32bc:	794010ef          	jal	4a50 <open>
  if(fd < 0){
    32c0:	0c054563          	bltz	a0,338a <dirfile+0xe8>
  close(fd);
    32c4:	774010ef          	jal	4a38 <close>
  if(chdir("dirfile") == 0){
    32c8:	00003517          	auipc	a0,0x3
    32cc:	5c050513          	add	a0,a0,1472 # 6888 <malloc+0x19aa>
    32d0:	7b0010ef          	jal	4a80 <chdir>
    32d4:	c569                	beqz	a0,339e <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32d6:	4581                	li	a1,0
    32d8:	00003517          	auipc	a0,0x3
    32dc:	5f850513          	add	a0,a0,1528 # 68d0 <malloc+0x19f2>
    32e0:	770010ef          	jal	4a50 <open>
  if(fd >= 0){
    32e4:	0c055763          	bgez	a0,33b2 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e8:	20000593          	li	a1,512
    32ec:	00003517          	auipc	a0,0x3
    32f0:	5e450513          	add	a0,a0,1508 # 68d0 <malloc+0x19f2>
    32f4:	75c010ef          	jal	4a50 <open>
  if(fd >= 0){
    32f8:	0c055763          	bgez	a0,33c6 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    32fc:	00003517          	auipc	a0,0x3
    3300:	5d450513          	add	a0,a0,1492 # 68d0 <malloc+0x19f2>
    3304:	774010ef          	jal	4a78 <mkdir>
    3308:	0c050963          	beqz	a0,33da <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    330c:	00003517          	auipc	a0,0x3
    3310:	5c450513          	add	a0,a0,1476 # 68d0 <malloc+0x19f2>
    3314:	74c010ef          	jal	4a60 <unlink>
    3318:	0c050b63          	beqz	a0,33ee <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    331c:	00003597          	auipc	a1,0x3
    3320:	5b458593          	add	a1,a1,1460 # 68d0 <malloc+0x19f2>
    3324:	00002517          	auipc	a0,0x2
    3328:	eac50513          	add	a0,a0,-340 # 51d0 <malloc+0x2f2>
    332c:	744010ef          	jal	4a70 <link>
    3330:	0c050963          	beqz	a0,3402 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3334:	00003517          	auipc	a0,0x3
    3338:	55450513          	add	a0,a0,1364 # 6888 <malloc+0x19aa>
    333c:	724010ef          	jal	4a60 <unlink>
    3340:	0c051b63          	bnez	a0,3416 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3344:	4589                	li	a1,2
    3346:	00002517          	auipc	a0,0x2
    334a:	39a50513          	add	a0,a0,922 # 56e0 <malloc+0x802>
    334e:	702010ef          	jal	4a50 <open>
  if(fd >= 0){
    3352:	0c055c63          	bgez	a0,342a <dirfile+0x188>
  fd = open(".", 0);
    3356:	4581                	li	a1,0
    3358:	00002517          	auipc	a0,0x2
    335c:	38850513          	add	a0,a0,904 # 56e0 <malloc+0x802>
    3360:	6f0010ef          	jal	4a50 <open>
    3364:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3366:	4605                	li	a2,1
    3368:	00002597          	auipc	a1,0x2
    336c:	d0058593          	add	a1,a1,-768 # 5068 <malloc+0x18a>
    3370:	6c0010ef          	jal	4a30 <write>
    3374:	0ca04563          	bgtz	a0,343e <dirfile+0x19c>
  close(fd);
    3378:	8526                	mv	a0,s1
    337a:	6be010ef          	jal	4a38 <close>
}
    337e:	60e2                	ld	ra,24(sp)
    3380:	6442                	ld	s0,16(sp)
    3382:	64a2                	ld	s1,8(sp)
    3384:	6902                	ld	s2,0(sp)
    3386:	6105                	add	sp,sp,32
    3388:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    338a:	85ca                	mv	a1,s2
    338c:	00003517          	auipc	a0,0x3
    3390:	50450513          	add	a0,a0,1284 # 6890 <malloc+0x19b2>
    3394:	297010ef          	jal	4e2a <printf>
    exit(1);
    3398:	4505                	li	a0,1
    339a:	676010ef          	jal	4a10 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    339e:	85ca                	mv	a1,s2
    33a0:	00003517          	auipc	a0,0x3
    33a4:	51050513          	add	a0,a0,1296 # 68b0 <malloc+0x19d2>
    33a8:	283010ef          	jal	4e2a <printf>
    exit(1);
    33ac:	4505                	li	a0,1
    33ae:	662010ef          	jal	4a10 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33b2:	85ca                	mv	a1,s2
    33b4:	00003517          	auipc	a0,0x3
    33b8:	52c50513          	add	a0,a0,1324 # 68e0 <malloc+0x1a02>
    33bc:	26f010ef          	jal	4e2a <printf>
    exit(1);
    33c0:	4505                	li	a0,1
    33c2:	64e010ef          	jal	4a10 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33c6:	85ca                	mv	a1,s2
    33c8:	00003517          	auipc	a0,0x3
    33cc:	51850513          	add	a0,a0,1304 # 68e0 <malloc+0x1a02>
    33d0:	25b010ef          	jal	4e2a <printf>
    exit(1);
    33d4:	4505                	li	a0,1
    33d6:	63a010ef          	jal	4a10 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33da:	85ca                	mv	a1,s2
    33dc:	00003517          	auipc	a0,0x3
    33e0:	52c50513          	add	a0,a0,1324 # 6908 <malloc+0x1a2a>
    33e4:	247010ef          	jal	4e2a <printf>
    exit(1);
    33e8:	4505                	li	a0,1
    33ea:	626010ef          	jal	4a10 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33ee:	85ca                	mv	a1,s2
    33f0:	00003517          	auipc	a0,0x3
    33f4:	54050513          	add	a0,a0,1344 # 6930 <malloc+0x1a52>
    33f8:	233010ef          	jal	4e2a <printf>
    exit(1);
    33fc:	4505                	li	a0,1
    33fe:	612010ef          	jal	4a10 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3402:	85ca                	mv	a1,s2
    3404:	00003517          	auipc	a0,0x3
    3408:	55450513          	add	a0,a0,1364 # 6958 <malloc+0x1a7a>
    340c:	21f010ef          	jal	4e2a <printf>
    exit(1);
    3410:	4505                	li	a0,1
    3412:	5fe010ef          	jal	4a10 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3416:	85ca                	mv	a1,s2
    3418:	00003517          	auipc	a0,0x3
    341c:	56850513          	add	a0,a0,1384 # 6980 <malloc+0x1aa2>
    3420:	20b010ef          	jal	4e2a <printf>
    exit(1);
    3424:	4505                	li	a0,1
    3426:	5ea010ef          	jal	4a10 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    342a:	85ca                	mv	a1,s2
    342c:	00003517          	auipc	a0,0x3
    3430:	57450513          	add	a0,a0,1396 # 69a0 <malloc+0x1ac2>
    3434:	1f7010ef          	jal	4e2a <printf>
    exit(1);
    3438:	4505                	li	a0,1
    343a:	5d6010ef          	jal	4a10 <exit>
    printf("%s: write . succeeded!\n", s);
    343e:	85ca                	mv	a1,s2
    3440:	00003517          	auipc	a0,0x3
    3444:	58850513          	add	a0,a0,1416 # 69c8 <malloc+0x1aea>
    3448:	1e3010ef          	jal	4e2a <printf>
    exit(1);
    344c:	4505                	li	a0,1
    344e:	5c2010ef          	jal	4a10 <exit>

0000000000003452 <iref>:
{
    3452:	7139                	add	sp,sp,-64
    3454:	fc06                	sd	ra,56(sp)
    3456:	f822                	sd	s0,48(sp)
    3458:	f426                	sd	s1,40(sp)
    345a:	f04a                	sd	s2,32(sp)
    345c:	ec4e                	sd	s3,24(sp)
    345e:	e852                	sd	s4,16(sp)
    3460:	e456                	sd	s5,8(sp)
    3462:	e05a                	sd	s6,0(sp)
    3464:	0080                	add	s0,sp,64
    3466:	8b2a                	mv	s6,a0
    3468:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    346c:	00003a17          	auipc	s4,0x3
    3470:	574a0a13          	add	s4,s4,1396 # 69e0 <malloc+0x1b02>
    mkdir("");
    3474:	00003497          	auipc	s1,0x3
    3478:	07448493          	add	s1,s1,116 # 64e8 <malloc+0x160a>
    link("README", "");
    347c:	00002a97          	auipc	s5,0x2
    3480:	d54a8a93          	add	s5,s5,-684 # 51d0 <malloc+0x2f2>
    fd = open("xx", O_CREATE);
    3484:	00003997          	auipc	s3,0x3
    3488:	45498993          	add	s3,s3,1108 # 68d8 <malloc+0x19fa>
    348c:	a835                	j	34c8 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    348e:	85da                	mv	a1,s6
    3490:	00003517          	auipc	a0,0x3
    3494:	55850513          	add	a0,a0,1368 # 69e8 <malloc+0x1b0a>
    3498:	193010ef          	jal	4e2a <printf>
      exit(1);
    349c:	4505                	li	a0,1
    349e:	572010ef          	jal	4a10 <exit>
      printf("%s: chdir irefd failed\n", s);
    34a2:	85da                	mv	a1,s6
    34a4:	00003517          	auipc	a0,0x3
    34a8:	55c50513          	add	a0,a0,1372 # 6a00 <malloc+0x1b22>
    34ac:	17f010ef          	jal	4e2a <printf>
      exit(1);
    34b0:	4505                	li	a0,1
    34b2:	55e010ef          	jal	4a10 <exit>
      close(fd);
    34b6:	582010ef          	jal	4a38 <close>
    34ba:	a82d                	j	34f4 <iref+0xa2>
    unlink("xx");
    34bc:	854e                	mv	a0,s3
    34be:	5a2010ef          	jal	4a60 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34c2:	397d                	addw	s2,s2,-1
    34c4:	04090263          	beqz	s2,3508 <iref+0xb6>
    if(mkdir("irefd") != 0){
    34c8:	8552                	mv	a0,s4
    34ca:	5ae010ef          	jal	4a78 <mkdir>
    34ce:	f161                	bnez	a0,348e <iref+0x3c>
    if(chdir("irefd") != 0){
    34d0:	8552                	mv	a0,s4
    34d2:	5ae010ef          	jal	4a80 <chdir>
    34d6:	f571                	bnez	a0,34a2 <iref+0x50>
    mkdir("");
    34d8:	8526                	mv	a0,s1
    34da:	59e010ef          	jal	4a78 <mkdir>
    link("README", "");
    34de:	85a6                	mv	a1,s1
    34e0:	8556                	mv	a0,s5
    34e2:	58e010ef          	jal	4a70 <link>
    fd = open("", O_CREATE);
    34e6:	20000593          	li	a1,512
    34ea:	8526                	mv	a0,s1
    34ec:	564010ef          	jal	4a50 <open>
    if(fd >= 0)
    34f0:	fc0553e3          	bgez	a0,34b6 <iref+0x64>
    fd = open("xx", O_CREATE);
    34f4:	20000593          	li	a1,512
    34f8:	854e                	mv	a0,s3
    34fa:	556010ef          	jal	4a50 <open>
    if(fd >= 0)
    34fe:	fa054fe3          	bltz	a0,34bc <iref+0x6a>
      close(fd);
    3502:	536010ef          	jal	4a38 <close>
    3506:	bf5d                	j	34bc <iref+0x6a>
    3508:	03300493          	li	s1,51
    chdir("..");
    350c:	00003997          	auipc	s3,0x3
    3510:	cf498993          	add	s3,s3,-780 # 6200 <malloc+0x1322>
    unlink("irefd");
    3514:	00003917          	auipc	s2,0x3
    3518:	4cc90913          	add	s2,s2,1228 # 69e0 <malloc+0x1b02>
    chdir("..");
    351c:	854e                	mv	a0,s3
    351e:	562010ef          	jal	4a80 <chdir>
    unlink("irefd");
    3522:	854a                	mv	a0,s2
    3524:	53c010ef          	jal	4a60 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3528:	34fd                	addw	s1,s1,-1
    352a:	f8ed                	bnez	s1,351c <iref+0xca>
  chdir("/");
    352c:	00003517          	auipc	a0,0x3
    3530:	c7c50513          	add	a0,a0,-900 # 61a8 <malloc+0x12ca>
    3534:	54c010ef          	jal	4a80 <chdir>
}
    3538:	70e2                	ld	ra,56(sp)
    353a:	7442                	ld	s0,48(sp)
    353c:	74a2                	ld	s1,40(sp)
    353e:	7902                	ld	s2,32(sp)
    3540:	69e2                	ld	s3,24(sp)
    3542:	6a42                	ld	s4,16(sp)
    3544:	6aa2                	ld	s5,8(sp)
    3546:	6b02                	ld	s6,0(sp)
    3548:	6121                	add	sp,sp,64
    354a:	8082                	ret

000000000000354c <openiputtest>:
{
    354c:	7179                	add	sp,sp,-48
    354e:	f406                	sd	ra,40(sp)
    3550:	f022                	sd	s0,32(sp)
    3552:	ec26                	sd	s1,24(sp)
    3554:	1800                	add	s0,sp,48
    3556:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3558:	00003517          	auipc	a0,0x3
    355c:	4c050513          	add	a0,a0,1216 # 6a18 <malloc+0x1b3a>
    3560:	518010ef          	jal	4a78 <mkdir>
    3564:	02054a63          	bltz	a0,3598 <openiputtest+0x4c>
  pid = fork();
    3568:	4a0010ef          	jal	4a08 <fork>
  if(pid < 0){
    356c:	04054063          	bltz	a0,35ac <openiputtest+0x60>
  if(pid == 0){
    3570:	e939                	bnez	a0,35c6 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3572:	4589                	li	a1,2
    3574:	00003517          	auipc	a0,0x3
    3578:	4a450513          	add	a0,a0,1188 # 6a18 <malloc+0x1b3a>
    357c:	4d4010ef          	jal	4a50 <open>
    if(fd >= 0){
    3580:	04054063          	bltz	a0,35c0 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3584:	85a6                	mv	a1,s1
    3586:	00003517          	auipc	a0,0x3
    358a:	4b250513          	add	a0,a0,1202 # 6a38 <malloc+0x1b5a>
    358e:	09d010ef          	jal	4e2a <printf>
      exit(1);
    3592:	4505                	li	a0,1
    3594:	47c010ef          	jal	4a10 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3598:	85a6                	mv	a1,s1
    359a:	00003517          	auipc	a0,0x3
    359e:	48650513          	add	a0,a0,1158 # 6a20 <malloc+0x1b42>
    35a2:	089010ef          	jal	4e2a <printf>
    exit(1);
    35a6:	4505                	li	a0,1
    35a8:	468010ef          	jal	4a10 <exit>
    printf("%s: fork failed\n", s);
    35ac:	85a6                	mv	a1,s1
    35ae:	00002517          	auipc	a0,0x2
    35b2:	2da50513          	add	a0,a0,730 # 5888 <malloc+0x9aa>
    35b6:	075010ef          	jal	4e2a <printf>
    exit(1);
    35ba:	4505                	li	a0,1
    35bc:	454010ef          	jal	4a10 <exit>
    exit(0);
    35c0:	4501                	li	a0,0
    35c2:	44e010ef          	jal	4a10 <exit>
  sleep(1);
    35c6:	4505                	li	a0,1
    35c8:	4d8010ef          	jal	4aa0 <sleep>
  if(unlink("oidir") != 0){
    35cc:	00003517          	auipc	a0,0x3
    35d0:	44c50513          	add	a0,a0,1100 # 6a18 <malloc+0x1b3a>
    35d4:	48c010ef          	jal	4a60 <unlink>
    35d8:	c919                	beqz	a0,35ee <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35da:	85a6                	mv	a1,s1
    35dc:	00002517          	auipc	a0,0x2
    35e0:	49c50513          	add	a0,a0,1180 # 5a78 <malloc+0xb9a>
    35e4:	047010ef          	jal	4e2a <printf>
    exit(1);
    35e8:	4505                	li	a0,1
    35ea:	426010ef          	jal	4a10 <exit>
  wait(&xstatus);
    35ee:	fdc40513          	add	a0,s0,-36
    35f2:	426010ef          	jal	4a18 <wait>
  exit(xstatus);
    35f6:	fdc42503          	lw	a0,-36(s0)
    35fa:	416010ef          	jal	4a10 <exit>

00000000000035fe <forkforkfork>:
{
    35fe:	1101                	add	sp,sp,-32
    3600:	ec06                	sd	ra,24(sp)
    3602:	e822                	sd	s0,16(sp)
    3604:	e426                	sd	s1,8(sp)
    3606:	1000                	add	s0,sp,32
    3608:	84aa                	mv	s1,a0
  unlink("stopforking");
    360a:	00003517          	auipc	a0,0x3
    360e:	45650513          	add	a0,a0,1110 # 6a60 <malloc+0x1b82>
    3612:	44e010ef          	jal	4a60 <unlink>
  int pid = fork();
    3616:	3f2010ef          	jal	4a08 <fork>
  if(pid < 0){
    361a:	02054b63          	bltz	a0,3650 <forkforkfork+0x52>
  if(pid == 0){
    361e:	c139                	beqz	a0,3664 <forkforkfork+0x66>
  sleep(20); /* two seconds */
    3620:	4551                	li	a0,20
    3622:	47e010ef          	jal	4aa0 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3626:	20200593          	li	a1,514
    362a:	00003517          	auipc	a0,0x3
    362e:	43650513          	add	a0,a0,1078 # 6a60 <malloc+0x1b82>
    3632:	41e010ef          	jal	4a50 <open>
    3636:	402010ef          	jal	4a38 <close>
  wait(0);
    363a:	4501                	li	a0,0
    363c:	3dc010ef          	jal	4a18 <wait>
  sleep(10); /* one second */
    3640:	4529                	li	a0,10
    3642:	45e010ef          	jal	4aa0 <sleep>
}
    3646:	60e2                	ld	ra,24(sp)
    3648:	6442                	ld	s0,16(sp)
    364a:	64a2                	ld	s1,8(sp)
    364c:	6105                	add	sp,sp,32
    364e:	8082                	ret
    printf("%s: fork failed", s);
    3650:	85a6                	mv	a1,s1
    3652:	00002517          	auipc	a0,0x2
    3656:	3f650513          	add	a0,a0,1014 # 5a48 <malloc+0xb6a>
    365a:	7d0010ef          	jal	4e2a <printf>
    exit(1);
    365e:	4505                	li	a0,1
    3660:	3b0010ef          	jal	4a10 <exit>
      int fd = open("stopforking", 0);
    3664:	00003497          	auipc	s1,0x3
    3668:	3fc48493          	add	s1,s1,1020 # 6a60 <malloc+0x1b82>
    366c:	4581                	li	a1,0
    366e:	8526                	mv	a0,s1
    3670:	3e0010ef          	jal	4a50 <open>
      if(fd >= 0){
    3674:	02055163          	bgez	a0,3696 <forkforkfork+0x98>
      if(fork() < 0){
    3678:	390010ef          	jal	4a08 <fork>
    367c:	fe0558e3          	bgez	a0,366c <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    3680:	20200593          	li	a1,514
    3684:	00003517          	auipc	a0,0x3
    3688:	3dc50513          	add	a0,a0,988 # 6a60 <malloc+0x1b82>
    368c:	3c4010ef          	jal	4a50 <open>
    3690:	3a8010ef          	jal	4a38 <close>
    3694:	bfe1                	j	366c <forkforkfork+0x6e>
        exit(0);
    3696:	4501                	li	a0,0
    3698:	378010ef          	jal	4a10 <exit>

000000000000369c <killstatus>:
{
    369c:	7139                	add	sp,sp,-64
    369e:	fc06                	sd	ra,56(sp)
    36a0:	f822                	sd	s0,48(sp)
    36a2:	f426                	sd	s1,40(sp)
    36a4:	f04a                	sd	s2,32(sp)
    36a6:	ec4e                	sd	s3,24(sp)
    36a8:	e852                	sd	s4,16(sp)
    36aa:	0080                	add	s0,sp,64
    36ac:	8a2a                	mv	s4,a0
    36ae:	06400913          	li	s2,100
    if(xst != -1) {
    36b2:	59fd                	li	s3,-1
    int pid1 = fork();
    36b4:	354010ef          	jal	4a08 <fork>
    36b8:	84aa                	mv	s1,a0
    if(pid1 < 0){
    36ba:	02054763          	bltz	a0,36e8 <killstatus+0x4c>
    if(pid1 == 0){
    36be:	cd1d                	beqz	a0,36fc <killstatus+0x60>
    sleep(1);
    36c0:	4505                	li	a0,1
    36c2:	3de010ef          	jal	4aa0 <sleep>
    kill(pid1);
    36c6:	8526                	mv	a0,s1
    36c8:	378010ef          	jal	4a40 <kill>
    wait(&xst);
    36cc:	fcc40513          	add	a0,s0,-52
    36d0:	348010ef          	jal	4a18 <wait>
    if(xst != -1) {
    36d4:	fcc42783          	lw	a5,-52(s0)
    36d8:	03379563          	bne	a5,s3,3702 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    36dc:	397d                	addw	s2,s2,-1
    36de:	fc091be3          	bnez	s2,36b4 <killstatus+0x18>
  exit(0);
    36e2:	4501                	li	a0,0
    36e4:	32c010ef          	jal	4a10 <exit>
      printf("%s: fork failed\n", s);
    36e8:	85d2                	mv	a1,s4
    36ea:	00002517          	auipc	a0,0x2
    36ee:	19e50513          	add	a0,a0,414 # 5888 <malloc+0x9aa>
    36f2:	738010ef          	jal	4e2a <printf>
      exit(1);
    36f6:	4505                	li	a0,1
    36f8:	318010ef          	jal	4a10 <exit>
        getpid();
    36fc:	394010ef          	jal	4a90 <getpid>
      while(1) {
    3700:	bff5                	j	36fc <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    3702:	85d2                	mv	a1,s4
    3704:	00003517          	auipc	a0,0x3
    3708:	36c50513          	add	a0,a0,876 # 6a70 <malloc+0x1b92>
    370c:	71e010ef          	jal	4e2a <printf>
       exit(1);
    3710:	4505                	li	a0,1
    3712:	2fe010ef          	jal	4a10 <exit>

0000000000003716 <preempt>:
{
    3716:	7139                	add	sp,sp,-64
    3718:	fc06                	sd	ra,56(sp)
    371a:	f822                	sd	s0,48(sp)
    371c:	f426                	sd	s1,40(sp)
    371e:	f04a                	sd	s2,32(sp)
    3720:	ec4e                	sd	s3,24(sp)
    3722:	e852                	sd	s4,16(sp)
    3724:	0080                	add	s0,sp,64
    3726:	892a                	mv	s2,a0
  pid1 = fork();
    3728:	2e0010ef          	jal	4a08 <fork>
  if(pid1 < 0) {
    372c:	00054563          	bltz	a0,3736 <preempt+0x20>
    3730:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3732:	ed01                	bnez	a0,374a <preempt+0x34>
    for(;;)
    3734:	a001                	j	3734 <preempt+0x1e>
    printf("%s: fork failed", s);
    3736:	85ca                	mv	a1,s2
    3738:	00002517          	auipc	a0,0x2
    373c:	31050513          	add	a0,a0,784 # 5a48 <malloc+0xb6a>
    3740:	6ea010ef          	jal	4e2a <printf>
    exit(1);
    3744:	4505                	li	a0,1
    3746:	2ca010ef          	jal	4a10 <exit>
  pid2 = fork();
    374a:	2be010ef          	jal	4a08 <fork>
    374e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3750:	00054463          	bltz	a0,3758 <preempt+0x42>
  if(pid2 == 0)
    3754:	ed01                	bnez	a0,376c <preempt+0x56>
    for(;;)
    3756:	a001                	j	3756 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3758:	85ca                	mv	a1,s2
    375a:	00002517          	auipc	a0,0x2
    375e:	12e50513          	add	a0,a0,302 # 5888 <malloc+0x9aa>
    3762:	6c8010ef          	jal	4e2a <printf>
    exit(1);
    3766:	4505                	li	a0,1
    3768:	2a8010ef          	jal	4a10 <exit>
  pipe(pfds);
    376c:	fc840513          	add	a0,s0,-56
    3770:	2b0010ef          	jal	4a20 <pipe>
  pid3 = fork();
    3774:	294010ef          	jal	4a08 <fork>
    3778:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    377a:	02054863          	bltz	a0,37aa <preempt+0x94>
  if(pid3 == 0){
    377e:	e921                	bnez	a0,37ce <preempt+0xb8>
    close(pfds[0]);
    3780:	fc842503          	lw	a0,-56(s0)
    3784:	2b4010ef          	jal	4a38 <close>
    if(write(pfds[1], "x", 1) != 1)
    3788:	4605                	li	a2,1
    378a:	00002597          	auipc	a1,0x2
    378e:	8de58593          	add	a1,a1,-1826 # 5068 <malloc+0x18a>
    3792:	fcc42503          	lw	a0,-52(s0)
    3796:	29a010ef          	jal	4a30 <write>
    379a:	4785                	li	a5,1
    379c:	02f51163          	bne	a0,a5,37be <preempt+0xa8>
    close(pfds[1]);
    37a0:	fcc42503          	lw	a0,-52(s0)
    37a4:	294010ef          	jal	4a38 <close>
    for(;;)
    37a8:	a001                	j	37a8 <preempt+0x92>
     printf("%s: fork failed\n", s);
    37aa:	85ca                	mv	a1,s2
    37ac:	00002517          	auipc	a0,0x2
    37b0:	0dc50513          	add	a0,a0,220 # 5888 <malloc+0x9aa>
    37b4:	676010ef          	jal	4e2a <printf>
     exit(1);
    37b8:	4505                	li	a0,1
    37ba:	256010ef          	jal	4a10 <exit>
      printf("%s: preempt write error", s);
    37be:	85ca                	mv	a1,s2
    37c0:	00003517          	auipc	a0,0x3
    37c4:	2d050513          	add	a0,a0,720 # 6a90 <malloc+0x1bb2>
    37c8:	662010ef          	jal	4e2a <printf>
    37cc:	bfd1                	j	37a0 <preempt+0x8a>
  close(pfds[1]);
    37ce:	fcc42503          	lw	a0,-52(s0)
    37d2:	266010ef          	jal	4a38 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    37d6:	660d                	lui	a2,0x3
    37d8:	00008597          	auipc	a1,0x8
    37dc:	4a058593          	add	a1,a1,1184 # bc78 <buf>
    37e0:	fc842503          	lw	a0,-56(s0)
    37e4:	244010ef          	jal	4a28 <read>
    37e8:	4785                	li	a5,1
    37ea:	02f50163          	beq	a0,a5,380c <preempt+0xf6>
    printf("%s: preempt read error", s);
    37ee:	85ca                	mv	a1,s2
    37f0:	00003517          	auipc	a0,0x3
    37f4:	2b850513          	add	a0,a0,696 # 6aa8 <malloc+0x1bca>
    37f8:	632010ef          	jal	4e2a <printf>
}
    37fc:	70e2                	ld	ra,56(sp)
    37fe:	7442                	ld	s0,48(sp)
    3800:	74a2                	ld	s1,40(sp)
    3802:	7902                	ld	s2,32(sp)
    3804:	69e2                	ld	s3,24(sp)
    3806:	6a42                	ld	s4,16(sp)
    3808:	6121                	add	sp,sp,64
    380a:	8082                	ret
  close(pfds[0]);
    380c:	fc842503          	lw	a0,-56(s0)
    3810:	228010ef          	jal	4a38 <close>
  printf("kill... ");
    3814:	00003517          	auipc	a0,0x3
    3818:	2ac50513          	add	a0,a0,684 # 6ac0 <malloc+0x1be2>
    381c:	60e010ef          	jal	4e2a <printf>
  kill(pid1);
    3820:	8526                	mv	a0,s1
    3822:	21e010ef          	jal	4a40 <kill>
  kill(pid2);
    3826:	854e                	mv	a0,s3
    3828:	218010ef          	jal	4a40 <kill>
  kill(pid3);
    382c:	8552                	mv	a0,s4
    382e:	212010ef          	jal	4a40 <kill>
  printf("wait... ");
    3832:	00003517          	auipc	a0,0x3
    3836:	29e50513          	add	a0,a0,670 # 6ad0 <malloc+0x1bf2>
    383a:	5f0010ef          	jal	4e2a <printf>
  wait(0);
    383e:	4501                	li	a0,0
    3840:	1d8010ef          	jal	4a18 <wait>
  wait(0);
    3844:	4501                	li	a0,0
    3846:	1d2010ef          	jal	4a18 <wait>
  wait(0);
    384a:	4501                	li	a0,0
    384c:	1cc010ef          	jal	4a18 <wait>
    3850:	b775                	j	37fc <preempt+0xe6>

0000000000003852 <reparent>:
{
    3852:	7179                	add	sp,sp,-48
    3854:	f406                	sd	ra,40(sp)
    3856:	f022                	sd	s0,32(sp)
    3858:	ec26                	sd	s1,24(sp)
    385a:	e84a                	sd	s2,16(sp)
    385c:	e44e                	sd	s3,8(sp)
    385e:	e052                	sd	s4,0(sp)
    3860:	1800                	add	s0,sp,48
    3862:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3864:	22c010ef          	jal	4a90 <getpid>
    3868:	8a2a                	mv	s4,a0
    386a:	0c800913          	li	s2,200
    int pid = fork();
    386e:	19a010ef          	jal	4a08 <fork>
    3872:	84aa                	mv	s1,a0
    if(pid < 0){
    3874:	00054e63          	bltz	a0,3890 <reparent+0x3e>
    if(pid){
    3878:	c121                	beqz	a0,38b8 <reparent+0x66>
      if(wait(0) != pid){
    387a:	4501                	li	a0,0
    387c:	19c010ef          	jal	4a18 <wait>
    3880:	02951263          	bne	a0,s1,38a4 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3884:	397d                	addw	s2,s2,-1
    3886:	fe0914e3          	bnez	s2,386e <reparent+0x1c>
  exit(0);
    388a:	4501                	li	a0,0
    388c:	184010ef          	jal	4a10 <exit>
      printf("%s: fork failed\n", s);
    3890:	85ce                	mv	a1,s3
    3892:	00002517          	auipc	a0,0x2
    3896:	ff650513          	add	a0,a0,-10 # 5888 <malloc+0x9aa>
    389a:	590010ef          	jal	4e2a <printf>
      exit(1);
    389e:	4505                	li	a0,1
    38a0:	170010ef          	jal	4a10 <exit>
        printf("%s: wait wrong pid\n", s);
    38a4:	85ce                	mv	a1,s3
    38a6:	00002517          	auipc	a0,0x2
    38aa:	16a50513          	add	a0,a0,362 # 5a10 <malloc+0xb32>
    38ae:	57c010ef          	jal	4e2a <printf>
        exit(1);
    38b2:	4505                	li	a0,1
    38b4:	15c010ef          	jal	4a10 <exit>
      int pid2 = fork();
    38b8:	150010ef          	jal	4a08 <fork>
      if(pid2 < 0){
    38bc:	00054563          	bltz	a0,38c6 <reparent+0x74>
      exit(0);
    38c0:	4501                	li	a0,0
    38c2:	14e010ef          	jal	4a10 <exit>
        kill(master_pid);
    38c6:	8552                	mv	a0,s4
    38c8:	178010ef          	jal	4a40 <kill>
        exit(1);
    38cc:	4505                	li	a0,1
    38ce:	142010ef          	jal	4a10 <exit>

00000000000038d2 <sbrkfail>:
{
    38d2:	7119                	add	sp,sp,-128
    38d4:	fc86                	sd	ra,120(sp)
    38d6:	f8a2                	sd	s0,112(sp)
    38d8:	f4a6                	sd	s1,104(sp)
    38da:	f0ca                	sd	s2,96(sp)
    38dc:	ecce                	sd	s3,88(sp)
    38de:	e8d2                	sd	s4,80(sp)
    38e0:	e4d6                	sd	s5,72(sp)
    38e2:	0100                	add	s0,sp,128
    38e4:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    38e6:	fb040513          	add	a0,s0,-80
    38ea:	136010ef          	jal	4a20 <pipe>
    38ee:	e901                	bnez	a0,38fe <sbrkfail+0x2c>
    38f0:	f8040493          	add	s1,s0,-128
    38f4:	fa840993          	add	s3,s0,-88
    38f8:	8926                	mv	s2,s1
    if(pids[i] != -1)
    38fa:	5a7d                	li	s4,-1
    38fc:	a0a1                	j	3944 <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    38fe:	85d6                	mv	a1,s5
    3900:	00002517          	auipc	a0,0x2
    3904:	09050513          	add	a0,a0,144 # 5990 <malloc+0xab2>
    3908:	522010ef          	jal	4e2a <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	102010ef          	jal	4a10 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3912:	186010ef          	jal	4a98 <sbrk>
    3916:	064007b7          	lui	a5,0x6400
    391a:	40a7853b          	subw	a0,a5,a0
    391e:	17a010ef          	jal	4a98 <sbrk>
      write(fds[1], "x", 1);
    3922:	4605                	li	a2,1
    3924:	00001597          	auipc	a1,0x1
    3928:	74458593          	add	a1,a1,1860 # 5068 <malloc+0x18a>
    392c:	fb442503          	lw	a0,-76(s0)
    3930:	100010ef          	jal	4a30 <write>
      for(;;) sleep(1000);
    3934:	3e800513          	li	a0,1000
    3938:	168010ef          	jal	4aa0 <sleep>
    393c:	bfe5                	j	3934 <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    393e:	0911                	add	s2,s2,4
    3940:	03390163          	beq	s2,s3,3962 <sbrkfail+0x90>
    if((pids[i] = fork()) == 0){
    3944:	0c4010ef          	jal	4a08 <fork>
    3948:	00a92023          	sw	a0,0(s2)
    394c:	d179                	beqz	a0,3912 <sbrkfail+0x40>
    if(pids[i] != -1)
    394e:	ff4508e3          	beq	a0,s4,393e <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    3952:	4605                	li	a2,1
    3954:	faf40593          	add	a1,s0,-81
    3958:	fb042503          	lw	a0,-80(s0)
    395c:	0cc010ef          	jal	4a28 <read>
    3960:	bff9                	j	393e <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    3962:	6505                	lui	a0,0x1
    3964:	134010ef          	jal	4a98 <sbrk>
    3968:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    396a:	597d                	li	s2,-1
    396c:	a021                	j	3974 <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    396e:	0491                	add	s1,s1,4
    3970:	01348b63          	beq	s1,s3,3986 <sbrkfail+0xb4>
    if(pids[i] == -1)
    3974:	4088                	lw	a0,0(s1)
    3976:	ff250ce3          	beq	a0,s2,396e <sbrkfail+0x9c>
    kill(pids[i]);
    397a:	0c6010ef          	jal	4a40 <kill>
    wait(0);
    397e:	4501                	li	a0,0
    3980:	098010ef          	jal	4a18 <wait>
    3984:	b7ed                	j	396e <sbrkfail+0x9c>
  if(c == (char*)0xffffffffffffffffL){
    3986:	57fd                	li	a5,-1
    3988:	02fa0d63          	beq	s4,a5,39c2 <sbrkfail+0xf0>
  pid = fork();
    398c:	07c010ef          	jal	4a08 <fork>
    3990:	84aa                	mv	s1,a0
  if(pid < 0){
    3992:	04054263          	bltz	a0,39d6 <sbrkfail+0x104>
  if(pid == 0){
    3996:	c931                	beqz	a0,39ea <sbrkfail+0x118>
  wait(&xstatus);
    3998:	fbc40513          	add	a0,s0,-68
    399c:	07c010ef          	jal	4a18 <wait>
  if(xstatus != -1 && xstatus != 2)
    39a0:	fbc42783          	lw	a5,-68(s0)
    39a4:	577d                	li	a4,-1
    39a6:	00e78563          	beq	a5,a4,39b0 <sbrkfail+0xde>
    39aa:	4709                	li	a4,2
    39ac:	06e79d63          	bne	a5,a4,3a26 <sbrkfail+0x154>
}
    39b0:	70e6                	ld	ra,120(sp)
    39b2:	7446                	ld	s0,112(sp)
    39b4:	74a6                	ld	s1,104(sp)
    39b6:	7906                	ld	s2,96(sp)
    39b8:	69e6                	ld	s3,88(sp)
    39ba:	6a46                	ld	s4,80(sp)
    39bc:	6aa6                	ld	s5,72(sp)
    39be:	6109                	add	sp,sp,128
    39c0:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    39c2:	85d6                	mv	a1,s5
    39c4:	00003517          	auipc	a0,0x3
    39c8:	11c50513          	add	a0,a0,284 # 6ae0 <malloc+0x1c02>
    39cc:	45e010ef          	jal	4e2a <printf>
    exit(1);
    39d0:	4505                	li	a0,1
    39d2:	03e010ef          	jal	4a10 <exit>
    printf("%s: fork failed\n", s);
    39d6:	85d6                	mv	a1,s5
    39d8:	00002517          	auipc	a0,0x2
    39dc:	eb050513          	add	a0,a0,-336 # 5888 <malloc+0x9aa>
    39e0:	44a010ef          	jal	4e2a <printf>
    exit(1);
    39e4:	4505                	li	a0,1
    39e6:	02a010ef          	jal	4a10 <exit>
    a = sbrk(0);
    39ea:	4501                	li	a0,0
    39ec:	0ac010ef          	jal	4a98 <sbrk>
    39f0:	892a                	mv	s2,a0
    sbrk(10*BIG);
    39f2:	3e800537          	lui	a0,0x3e800
    39f6:	0a2010ef          	jal	4a98 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    39fa:	87ca                	mv	a5,s2
    39fc:	3e800737          	lui	a4,0x3e800
    3a00:	993a                	add	s2,s2,a4
    3a02:	6705                	lui	a4,0x1
      n += *(a+i);
    3a04:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f1388>
    3a08:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a0a:	97ba                	add	a5,a5,a4
    3a0c:	ff279ce3          	bne	a5,s2,3a04 <sbrkfail+0x132>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3a10:	8626                	mv	a2,s1
    3a12:	85d6                	mv	a1,s5
    3a14:	00003517          	auipc	a0,0x3
    3a18:	0ec50513          	add	a0,a0,236 # 6b00 <malloc+0x1c22>
    3a1c:	40e010ef          	jal	4e2a <printf>
    exit(1);
    3a20:	4505                	li	a0,1
    3a22:	7ef000ef          	jal	4a10 <exit>
    exit(1);
    3a26:	4505                	li	a0,1
    3a28:	7e9000ef          	jal	4a10 <exit>

0000000000003a2c <mem>:
{
    3a2c:	7139                	add	sp,sp,-64
    3a2e:	fc06                	sd	ra,56(sp)
    3a30:	f822                	sd	s0,48(sp)
    3a32:	f426                	sd	s1,40(sp)
    3a34:	f04a                	sd	s2,32(sp)
    3a36:	ec4e                	sd	s3,24(sp)
    3a38:	0080                	add	s0,sp,64
    3a3a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a3c:	7cd000ef          	jal	4a08 <fork>
    m1 = 0;
    3a40:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a42:	6909                	lui	s2,0x2
    3a44:	71190913          	add	s2,s2,1809 # 2711 <fourteen+0xcd>
  if((pid = fork()) == 0){
    3a48:	cd11                	beqz	a0,3a64 <mem+0x38>
    wait(&xstatus);
    3a4a:	fcc40513          	add	a0,s0,-52
    3a4e:	7cb000ef          	jal	4a18 <wait>
    if(xstatus == -1){
    3a52:	fcc42503          	lw	a0,-52(s0)
    3a56:	57fd                	li	a5,-1
    3a58:	04f50363          	beq	a0,a5,3a9e <mem+0x72>
    exit(xstatus);
    3a5c:	7b5000ef          	jal	4a10 <exit>
      *(char**)m2 = m1;
    3a60:	e104                	sd	s1,0(a0)
      m1 = m2;
    3a62:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3a64:	854a                	mv	a0,s2
    3a66:	478010ef          	jal	4ede <malloc>
    3a6a:	f97d                	bnez	a0,3a60 <mem+0x34>
    while(m1){
    3a6c:	c491                	beqz	s1,3a78 <mem+0x4c>
      m2 = *(char**)m1;
    3a6e:	8526                	mv	a0,s1
    3a70:	6084                	ld	s1,0(s1)
      free(m1);
    3a72:	3ea010ef          	jal	4e5c <free>
    while(m1){
    3a76:	fce5                	bnez	s1,3a6e <mem+0x42>
    m1 = malloc(1024*20);
    3a78:	6515                	lui	a0,0x5
    3a7a:	464010ef          	jal	4ede <malloc>
    if(m1 == 0){
    3a7e:	c511                	beqz	a0,3a8a <mem+0x5e>
    free(m1);
    3a80:	3dc010ef          	jal	4e5c <free>
    exit(0);
    3a84:	4501                	li	a0,0
    3a86:	78b000ef          	jal	4a10 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3a8a:	85ce                	mv	a1,s3
    3a8c:	00003517          	auipc	a0,0x3
    3a90:	0a450513          	add	a0,a0,164 # 6b30 <malloc+0x1c52>
    3a94:	396010ef          	jal	4e2a <printf>
      exit(1);
    3a98:	4505                	li	a0,1
    3a9a:	777000ef          	jal	4a10 <exit>
      exit(0);
    3a9e:	4501                	li	a0,0
    3aa0:	771000ef          	jal	4a10 <exit>

0000000000003aa4 <sharedfd>:
{
    3aa4:	7159                	add	sp,sp,-112
    3aa6:	f486                	sd	ra,104(sp)
    3aa8:	f0a2                	sd	s0,96(sp)
    3aaa:	eca6                	sd	s1,88(sp)
    3aac:	e8ca                	sd	s2,80(sp)
    3aae:	e4ce                	sd	s3,72(sp)
    3ab0:	e0d2                	sd	s4,64(sp)
    3ab2:	fc56                	sd	s5,56(sp)
    3ab4:	f85a                	sd	s6,48(sp)
    3ab6:	f45e                	sd	s7,40(sp)
    3ab8:	1880                	add	s0,sp,112
    3aba:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3abc:	00003517          	auipc	a0,0x3
    3ac0:	09450513          	add	a0,a0,148 # 6b50 <malloc+0x1c72>
    3ac4:	79d000ef          	jal	4a60 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3ac8:	20200593          	li	a1,514
    3acc:	00003517          	auipc	a0,0x3
    3ad0:	08450513          	add	a0,a0,132 # 6b50 <malloc+0x1c72>
    3ad4:	77d000ef          	jal	4a50 <open>
  if(fd < 0){
    3ad8:	04054263          	bltz	a0,3b1c <sharedfd+0x78>
    3adc:	892a                	mv	s2,a0
  pid = fork();
    3ade:	72b000ef          	jal	4a08 <fork>
    3ae2:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3ae4:	07000593          	li	a1,112
    3ae8:	e119                	bnez	a0,3aee <sharedfd+0x4a>
    3aea:	06300593          	li	a1,99
    3aee:	4629                	li	a2,10
    3af0:	fa040513          	add	a0,s0,-96
    3af4:	537000ef          	jal	482a <memset>
    3af8:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3afc:	4629                	li	a2,10
    3afe:	fa040593          	add	a1,s0,-96
    3b02:	854a                	mv	a0,s2
    3b04:	72d000ef          	jal	4a30 <write>
    3b08:	47a9                	li	a5,10
    3b0a:	02f51363          	bne	a0,a5,3b30 <sharedfd+0x8c>
  for(i = 0; i < N; i++){
    3b0e:	34fd                	addw	s1,s1,-1
    3b10:	f4f5                	bnez	s1,3afc <sharedfd+0x58>
  if(pid == 0) {
    3b12:	02099963          	bnez	s3,3b44 <sharedfd+0xa0>
    exit(0);
    3b16:	4501                	li	a0,0
    3b18:	6f9000ef          	jal	4a10 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3b1c:	85d2                	mv	a1,s4
    3b1e:	00003517          	auipc	a0,0x3
    3b22:	04250513          	add	a0,a0,66 # 6b60 <malloc+0x1c82>
    3b26:	304010ef          	jal	4e2a <printf>
    exit(1);
    3b2a:	4505                	li	a0,1
    3b2c:	6e5000ef          	jal	4a10 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b30:	85d2                	mv	a1,s4
    3b32:	00003517          	auipc	a0,0x3
    3b36:	05650513          	add	a0,a0,86 # 6b88 <malloc+0x1caa>
    3b3a:	2f0010ef          	jal	4e2a <printf>
      exit(1);
    3b3e:	4505                	li	a0,1
    3b40:	6d1000ef          	jal	4a10 <exit>
    wait(&xstatus);
    3b44:	f9c40513          	add	a0,s0,-100
    3b48:	6d1000ef          	jal	4a18 <wait>
    if(xstatus != 0)
    3b4c:	f9c42983          	lw	s3,-100(s0)
    3b50:	00098563          	beqz	s3,3b5a <sharedfd+0xb6>
      exit(xstatus);
    3b54:	854e                	mv	a0,s3
    3b56:	6bb000ef          	jal	4a10 <exit>
  close(fd);
    3b5a:	854a                	mv	a0,s2
    3b5c:	6dd000ef          	jal	4a38 <close>
  fd = open("sharedfd", 0);
    3b60:	4581                	li	a1,0
    3b62:	00003517          	auipc	a0,0x3
    3b66:	fee50513          	add	a0,a0,-18 # 6b50 <malloc+0x1c72>
    3b6a:	6e7000ef          	jal	4a50 <open>
    3b6e:	8baa                	mv	s7,a0
  nc = np = 0;
    3b70:	8ace                	mv	s5,s3
  if(fd < 0){
    3b72:	02054363          	bltz	a0,3b98 <sharedfd+0xf4>
    3b76:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    3b7a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3b7e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3b82:	4629                	li	a2,10
    3b84:	fa040593          	add	a1,s0,-96
    3b88:	855e                	mv	a0,s7
    3b8a:	69f000ef          	jal	4a28 <read>
    3b8e:	02a05b63          	blez	a0,3bc4 <sharedfd+0x120>
    3b92:	fa040793          	add	a5,s0,-96
    3b96:	a839                	j	3bb4 <sharedfd+0x110>
    printf("%s: cannot open sharedfd for reading\n", s);
    3b98:	85d2                	mv	a1,s4
    3b9a:	00003517          	auipc	a0,0x3
    3b9e:	00e50513          	add	a0,a0,14 # 6ba8 <malloc+0x1cca>
    3ba2:	288010ef          	jal	4e2a <printf>
    exit(1);
    3ba6:	4505                	li	a0,1
    3ba8:	669000ef          	jal	4a10 <exit>
        nc++;
    3bac:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3bae:	0785                	add	a5,a5,1
    3bb0:	fd2789e3          	beq	a5,s2,3b82 <sharedfd+0xde>
      if(buf[i] == 'c')
    3bb4:	0007c703          	lbu	a4,0(a5)
    3bb8:	fe970ae3          	beq	a4,s1,3bac <sharedfd+0x108>
      if(buf[i] == 'p')
    3bbc:	ff6719e3          	bne	a4,s6,3bae <sharedfd+0x10a>
        np++;
    3bc0:	2a85                	addw	s5,s5,1
    3bc2:	b7f5                	j	3bae <sharedfd+0x10a>
  close(fd);
    3bc4:	855e                	mv	a0,s7
    3bc6:	673000ef          	jal	4a38 <close>
  unlink("sharedfd");
    3bca:	00003517          	auipc	a0,0x3
    3bce:	f8650513          	add	a0,a0,-122 # 6b50 <malloc+0x1c72>
    3bd2:	68f000ef          	jal	4a60 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3bd6:	6789                	lui	a5,0x2
    3bd8:	71078793          	add	a5,a5,1808 # 2710 <fourteen+0xcc>
    3bdc:	00f99763          	bne	s3,a5,3bea <sharedfd+0x146>
    3be0:	6789                	lui	a5,0x2
    3be2:	71078793          	add	a5,a5,1808 # 2710 <fourteen+0xcc>
    3be6:	00fa8c63          	beq	s5,a5,3bfe <sharedfd+0x15a>
    printf("%s: nc/np test fails\n", s);
    3bea:	85d2                	mv	a1,s4
    3bec:	00003517          	auipc	a0,0x3
    3bf0:	fe450513          	add	a0,a0,-28 # 6bd0 <malloc+0x1cf2>
    3bf4:	236010ef          	jal	4e2a <printf>
    exit(1);
    3bf8:	4505                	li	a0,1
    3bfa:	617000ef          	jal	4a10 <exit>
    exit(0);
    3bfe:	4501                	li	a0,0
    3c00:	611000ef          	jal	4a10 <exit>

0000000000003c04 <fourfiles>:
{
    3c04:	7135                	add	sp,sp,-160
    3c06:	ed06                	sd	ra,152(sp)
    3c08:	e922                	sd	s0,144(sp)
    3c0a:	e526                	sd	s1,136(sp)
    3c0c:	e14a                	sd	s2,128(sp)
    3c0e:	fcce                	sd	s3,120(sp)
    3c10:	f8d2                	sd	s4,112(sp)
    3c12:	f4d6                	sd	s5,104(sp)
    3c14:	f0da                	sd	s6,96(sp)
    3c16:	ecde                	sd	s7,88(sp)
    3c18:	e8e2                	sd	s8,80(sp)
    3c1a:	e4e6                	sd	s9,72(sp)
    3c1c:	e0ea                	sd	s10,64(sp)
    3c1e:	fc6e                	sd	s11,56(sp)
    3c20:	1100                	add	s0,sp,160
    3c22:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c24:	00003797          	auipc	a5,0x3
    3c28:	fc478793          	add	a5,a5,-60 # 6be8 <malloc+0x1d0a>
    3c2c:	f6f43823          	sd	a5,-144(s0)
    3c30:	00003797          	auipc	a5,0x3
    3c34:	fc078793          	add	a5,a5,-64 # 6bf0 <malloc+0x1d12>
    3c38:	f6f43c23          	sd	a5,-136(s0)
    3c3c:	00003797          	auipc	a5,0x3
    3c40:	fbc78793          	add	a5,a5,-68 # 6bf8 <malloc+0x1d1a>
    3c44:	f8f43023          	sd	a5,-128(s0)
    3c48:	00003797          	auipc	a5,0x3
    3c4c:	fb878793          	add	a5,a5,-72 # 6c00 <malloc+0x1d22>
    3c50:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3c54:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c58:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3c5a:	4481                	li	s1,0
    3c5c:	4a11                	li	s4,4
    fname = names[pi];
    3c5e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3c62:	854e                	mv	a0,s3
    3c64:	5fd000ef          	jal	4a60 <unlink>
    pid = fork();
    3c68:	5a1000ef          	jal	4a08 <fork>
    if(pid < 0){
    3c6c:	02054e63          	bltz	a0,3ca8 <fourfiles+0xa4>
    if(pid == 0){
    3c70:	c531                	beqz	a0,3cbc <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    3c72:	2485                	addw	s1,s1,1
    3c74:	0921                	add	s2,s2,8
    3c76:	ff4494e3          	bne	s1,s4,3c5e <fourfiles+0x5a>
    3c7a:	4491                	li	s1,4
    wait(&xstatus);
    3c7c:	f6c40513          	add	a0,s0,-148
    3c80:	599000ef          	jal	4a18 <wait>
    if(xstatus != 0)
    3c84:	f6c42a83          	lw	s5,-148(s0)
    3c88:	0a0a9463          	bnez	s5,3d30 <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3c8c:	34fd                	addw	s1,s1,-1
    3c8e:	f4fd                	bnez	s1,3c7c <fourfiles+0x78>
    3c90:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3c94:	00008a17          	auipc	s4,0x8
    3c98:	fe4a0a13          	add	s4,s4,-28 # bc78 <buf>
    if(total != N*SZ){
    3c9c:	6d05                	lui	s10,0x1
    3c9e:	770d0d13          	add	s10,s10,1904 # 1770 <forkfork+0x48>
  for(i = 0; i < NCHILD; i++){
    3ca2:	03400d93          	li	s11,52
    3ca6:	a0ed                	j	3d90 <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3ca8:	85e6                	mv	a1,s9
    3caa:	00002517          	auipc	a0,0x2
    3cae:	bde50513          	add	a0,a0,-1058 # 5888 <malloc+0x9aa>
    3cb2:	178010ef          	jal	4e2a <printf>
      exit(1);
    3cb6:	4505                	li	a0,1
    3cb8:	559000ef          	jal	4a10 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3cbc:	20200593          	li	a1,514
    3cc0:	854e                	mv	a0,s3
    3cc2:	58f000ef          	jal	4a50 <open>
    3cc6:	892a                	mv	s2,a0
      if(fd < 0){
    3cc8:	04054163          	bltz	a0,3d0a <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    3ccc:	1f400613          	li	a2,500
    3cd0:	0304859b          	addw	a1,s1,48
    3cd4:	00008517          	auipc	a0,0x8
    3cd8:	fa450513          	add	a0,a0,-92 # bc78 <buf>
    3cdc:	34f000ef          	jal	482a <memset>
    3ce0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3ce2:	00008997          	auipc	s3,0x8
    3ce6:	f9698993          	add	s3,s3,-106 # bc78 <buf>
    3cea:	1f400613          	li	a2,500
    3cee:	85ce                	mv	a1,s3
    3cf0:	854a                	mv	a0,s2
    3cf2:	53f000ef          	jal	4a30 <write>
    3cf6:	85aa                	mv	a1,a0
    3cf8:	1f400793          	li	a5,500
    3cfc:	02f51163          	bne	a0,a5,3d1e <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    3d00:	34fd                	addw	s1,s1,-1
    3d02:	f4e5                	bnez	s1,3cea <fourfiles+0xe6>
      exit(0);
    3d04:	4501                	li	a0,0
    3d06:	50b000ef          	jal	4a10 <exit>
        printf("%s: create failed\n", s);
    3d0a:	85e6                	mv	a1,s9
    3d0c:	00002517          	auipc	a0,0x2
    3d10:	c1450513          	add	a0,a0,-1004 # 5920 <malloc+0xa42>
    3d14:	116010ef          	jal	4e2a <printf>
        exit(1);
    3d18:	4505                	li	a0,1
    3d1a:	4f7000ef          	jal	4a10 <exit>
          printf("write failed %d\n", n);
    3d1e:	00003517          	auipc	a0,0x3
    3d22:	eea50513          	add	a0,a0,-278 # 6c08 <malloc+0x1d2a>
    3d26:	104010ef          	jal	4e2a <printf>
          exit(1);
    3d2a:	4505                	li	a0,1
    3d2c:	4e5000ef          	jal	4a10 <exit>
      exit(xstatus);
    3d30:	8556                	mv	a0,s5
    3d32:	4df000ef          	jal	4a10 <exit>
          printf("%s: wrong char\n", s);
    3d36:	85e6                	mv	a1,s9
    3d38:	00003517          	auipc	a0,0x3
    3d3c:	ee850513          	add	a0,a0,-280 # 6c20 <malloc+0x1d42>
    3d40:	0ea010ef          	jal	4e2a <printf>
          exit(1);
    3d44:	4505                	li	a0,1
    3d46:	4cb000ef          	jal	4a10 <exit>
      total += n;
    3d4a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d4e:	660d                	lui	a2,0x3
    3d50:	85d2                	mv	a1,s4
    3d52:	854e                	mv	a0,s3
    3d54:	4d5000ef          	jal	4a28 <read>
    3d58:	02a05063          	blez	a0,3d78 <fourfiles+0x174>
    3d5c:	00008797          	auipc	a5,0x8
    3d60:	f1c78793          	add	a5,a5,-228 # bc78 <buf>
    3d64:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3d68:	0007c703          	lbu	a4,0(a5)
    3d6c:	fc9715e3          	bne	a4,s1,3d36 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    3d70:	0785                	add	a5,a5,1
    3d72:	fed79be3          	bne	a5,a3,3d68 <fourfiles+0x164>
    3d76:	bfd1                	j	3d4a <fourfiles+0x146>
    close(fd);
    3d78:	854e                	mv	a0,s3
    3d7a:	4bf000ef          	jal	4a38 <close>
    if(total != N*SZ){
    3d7e:	03a91463          	bne	s2,s10,3da6 <fourfiles+0x1a2>
    unlink(fname);
    3d82:	8562                	mv	a0,s8
    3d84:	4dd000ef          	jal	4a60 <unlink>
  for(i = 0; i < NCHILD; i++){
    3d88:	0ba1                	add	s7,s7,8
    3d8a:	2b05                	addw	s6,s6,1
    3d8c:	03bb0763          	beq	s6,s11,3dba <fourfiles+0x1b6>
    fname = names[i];
    3d90:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3d94:	4581                	li	a1,0
    3d96:	8562                	mv	a0,s8
    3d98:	4b9000ef          	jal	4a50 <open>
    3d9c:	89aa                	mv	s3,a0
    total = 0;
    3d9e:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3da0:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3da4:	b76d                	j	3d4e <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3da6:	85ca                	mv	a1,s2
    3da8:	00003517          	auipc	a0,0x3
    3dac:	e8850513          	add	a0,a0,-376 # 6c30 <malloc+0x1d52>
    3db0:	07a010ef          	jal	4e2a <printf>
      exit(1);
    3db4:	4505                	li	a0,1
    3db6:	45b000ef          	jal	4a10 <exit>
}
    3dba:	60ea                	ld	ra,152(sp)
    3dbc:	644a                	ld	s0,144(sp)
    3dbe:	64aa                	ld	s1,136(sp)
    3dc0:	690a                	ld	s2,128(sp)
    3dc2:	79e6                	ld	s3,120(sp)
    3dc4:	7a46                	ld	s4,112(sp)
    3dc6:	7aa6                	ld	s5,104(sp)
    3dc8:	7b06                	ld	s6,96(sp)
    3dca:	6be6                	ld	s7,88(sp)
    3dcc:	6c46                	ld	s8,80(sp)
    3dce:	6ca6                	ld	s9,72(sp)
    3dd0:	6d06                	ld	s10,64(sp)
    3dd2:	7de2                	ld	s11,56(sp)
    3dd4:	610d                	add	sp,sp,160
    3dd6:	8082                	ret

0000000000003dd8 <concreate>:
{
    3dd8:	7135                	add	sp,sp,-160
    3dda:	ed06                	sd	ra,152(sp)
    3ddc:	e922                	sd	s0,144(sp)
    3dde:	e526                	sd	s1,136(sp)
    3de0:	e14a                	sd	s2,128(sp)
    3de2:	fcce                	sd	s3,120(sp)
    3de4:	f8d2                	sd	s4,112(sp)
    3de6:	f4d6                	sd	s5,104(sp)
    3de8:	f0da                	sd	s6,96(sp)
    3dea:	ecde                	sd	s7,88(sp)
    3dec:	1100                	add	s0,sp,160
    3dee:	89aa                	mv	s3,a0
  file[0] = 'C';
    3df0:	04300793          	li	a5,67
    3df4:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3df8:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3dfc:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3dfe:	4b0d                	li	s6,3
    3e00:	4a85                	li	s5,1
      link("C0", file);
    3e02:	00003b97          	auipc	s7,0x3
    3e06:	e46b8b93          	add	s7,s7,-442 # 6c48 <malloc+0x1d6a>
  for(i = 0; i < N; i++){
    3e0a:	02800a13          	li	s4,40
    3e0e:	a41d                	j	4034 <concreate+0x25c>
      link("C0", file);
    3e10:	fa840593          	add	a1,s0,-88
    3e14:	855e                	mv	a0,s7
    3e16:	45b000ef          	jal	4a70 <link>
    if(pid == 0) {
    3e1a:	a411                	j	401e <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e1c:	4795                	li	a5,5
    3e1e:	02f9693b          	remw	s2,s2,a5
    3e22:	4785                	li	a5,1
    3e24:	02f90563          	beq	s2,a5,3e4e <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e28:	20200593          	li	a1,514
    3e2c:	fa840513          	add	a0,s0,-88
    3e30:	421000ef          	jal	4a50 <open>
      if(fd < 0){
    3e34:	1e055063          	bgez	a0,4014 <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3e38:	fa840593          	add	a1,s0,-88
    3e3c:	00003517          	auipc	a0,0x3
    3e40:	e1450513          	add	a0,a0,-492 # 6c50 <malloc+0x1d72>
    3e44:	7e7000ef          	jal	4e2a <printf>
        exit(1);
    3e48:	4505                	li	a0,1
    3e4a:	3c7000ef          	jal	4a10 <exit>
      link("C0", file);
    3e4e:	fa840593          	add	a1,s0,-88
    3e52:	00003517          	auipc	a0,0x3
    3e56:	df650513          	add	a0,a0,-522 # 6c48 <malloc+0x1d6a>
    3e5a:	417000ef          	jal	4a70 <link>
      exit(0);
    3e5e:	4501                	li	a0,0
    3e60:	3b1000ef          	jal	4a10 <exit>
        exit(1);
    3e64:	4505                	li	a0,1
    3e66:	3ab000ef          	jal	4a10 <exit>
  memset(fa, 0, sizeof(fa));
    3e6a:	02800613          	li	a2,40
    3e6e:	4581                	li	a1,0
    3e70:	f8040513          	add	a0,s0,-128
    3e74:	1b7000ef          	jal	482a <memset>
  fd = open(".", 0);
    3e78:	4581                	li	a1,0
    3e7a:	00002517          	auipc	a0,0x2
    3e7e:	86650513          	add	a0,a0,-1946 # 56e0 <malloc+0x802>
    3e82:	3cf000ef          	jal	4a50 <open>
    3e86:	892a                	mv	s2,a0
  n = 0;
    3e88:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3e8a:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3e8e:	02700b13          	li	s6,39
      fa[i] = 1;
    3e92:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3e94:	4641                	li	a2,16
    3e96:	f7040593          	add	a1,s0,-144
    3e9a:	854a                	mv	a0,s2
    3e9c:	38d000ef          	jal	4a28 <read>
    3ea0:	06a05a63          	blez	a0,3f14 <concreate+0x13c>
    if(de.inum == 0)
    3ea4:	f7045783          	lhu	a5,-144(s0)
    3ea8:	d7f5                	beqz	a5,3e94 <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3eaa:	f7244783          	lbu	a5,-142(s0)
    3eae:	ff4793e3          	bne	a5,s4,3e94 <concreate+0xbc>
    3eb2:	f7444783          	lbu	a5,-140(s0)
    3eb6:	fff9                	bnez	a5,3e94 <concreate+0xbc>
      i = de.name[1] - '0';
    3eb8:	f7344783          	lbu	a5,-141(s0)
    3ebc:	fd07879b          	addw	a5,a5,-48
    3ec0:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3ec4:	02eb6063          	bltu	s6,a4,3ee4 <concreate+0x10c>
      if(fa[i]){
    3ec8:	fb070793          	add	a5,a4,-80 # fb0 <bigdir+0x10e>
    3ecc:	97a2                	add	a5,a5,s0
    3ece:	fd07c783          	lbu	a5,-48(a5)
    3ed2:	e78d                	bnez	a5,3efc <concreate+0x124>
      fa[i] = 1;
    3ed4:	fb070793          	add	a5,a4,-80
    3ed8:	00878733          	add	a4,a5,s0
    3edc:	fd770823          	sb	s7,-48(a4)
      n++;
    3ee0:	2a85                	addw	s5,s5,1
    3ee2:	bf4d                	j	3e94 <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3ee4:	f7240613          	add	a2,s0,-142
    3ee8:	85ce                	mv	a1,s3
    3eea:	00003517          	auipc	a0,0x3
    3eee:	d8650513          	add	a0,a0,-634 # 6c70 <malloc+0x1d92>
    3ef2:	739000ef          	jal	4e2a <printf>
        exit(1);
    3ef6:	4505                	li	a0,1
    3ef8:	319000ef          	jal	4a10 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3efc:	f7240613          	add	a2,s0,-142
    3f00:	85ce                	mv	a1,s3
    3f02:	00003517          	auipc	a0,0x3
    3f06:	d8e50513          	add	a0,a0,-626 # 6c90 <malloc+0x1db2>
    3f0a:	721000ef          	jal	4e2a <printf>
        exit(1);
    3f0e:	4505                	li	a0,1
    3f10:	301000ef          	jal	4a10 <exit>
  close(fd);
    3f14:	854a                	mv	a0,s2
    3f16:	323000ef          	jal	4a38 <close>
  if(n != N){
    3f1a:	02800793          	li	a5,40
    3f1e:	00fa9763          	bne	s5,a5,3f2c <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f22:	4a8d                	li	s5,3
    3f24:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f26:	02800a13          	li	s4,40
    3f2a:	a079                	j	3fb8 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f2c:	85ce                	mv	a1,s3
    3f2e:	00003517          	auipc	a0,0x3
    3f32:	d8a50513          	add	a0,a0,-630 # 6cb8 <malloc+0x1dda>
    3f36:	6f5000ef          	jal	4e2a <printf>
    exit(1);
    3f3a:	4505                	li	a0,1
    3f3c:	2d5000ef          	jal	4a10 <exit>
      printf("%s: fork failed\n", s);
    3f40:	85ce                	mv	a1,s3
    3f42:	00002517          	auipc	a0,0x2
    3f46:	94650513          	add	a0,a0,-1722 # 5888 <malloc+0x9aa>
    3f4a:	6e1000ef          	jal	4e2a <printf>
      exit(1);
    3f4e:	4505                	li	a0,1
    3f50:	2c1000ef          	jal	4a10 <exit>
      close(open(file, 0));
    3f54:	4581                	li	a1,0
    3f56:	fa840513          	add	a0,s0,-88
    3f5a:	2f7000ef          	jal	4a50 <open>
    3f5e:	2db000ef          	jal	4a38 <close>
      close(open(file, 0));
    3f62:	4581                	li	a1,0
    3f64:	fa840513          	add	a0,s0,-88
    3f68:	2e9000ef          	jal	4a50 <open>
    3f6c:	2cd000ef          	jal	4a38 <close>
      close(open(file, 0));
    3f70:	4581                	li	a1,0
    3f72:	fa840513          	add	a0,s0,-88
    3f76:	2db000ef          	jal	4a50 <open>
    3f7a:	2bf000ef          	jal	4a38 <close>
      close(open(file, 0));
    3f7e:	4581                	li	a1,0
    3f80:	fa840513          	add	a0,s0,-88
    3f84:	2cd000ef          	jal	4a50 <open>
    3f88:	2b1000ef          	jal	4a38 <close>
      close(open(file, 0));
    3f8c:	4581                	li	a1,0
    3f8e:	fa840513          	add	a0,s0,-88
    3f92:	2bf000ef          	jal	4a50 <open>
    3f96:	2a3000ef          	jal	4a38 <close>
      close(open(file, 0));
    3f9a:	4581                	li	a1,0
    3f9c:	fa840513          	add	a0,s0,-88
    3fa0:	2b1000ef          	jal	4a50 <open>
    3fa4:	295000ef          	jal	4a38 <close>
    if(pid == 0)
    3fa8:	06090363          	beqz	s2,400e <concreate+0x236>
      wait(0);
    3fac:	4501                	li	a0,0
    3fae:	26b000ef          	jal	4a18 <wait>
  for(i = 0; i < N; i++){
    3fb2:	2485                	addw	s1,s1,1
    3fb4:	0b448963          	beq	s1,s4,4066 <concreate+0x28e>
    file[1] = '0' + i;
    3fb8:	0304879b          	addw	a5,s1,48
    3fbc:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    3fc0:	249000ef          	jal	4a08 <fork>
    3fc4:	892a                	mv	s2,a0
    if(pid < 0){
    3fc6:	f6054de3          	bltz	a0,3f40 <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    3fca:	0354e73b          	remw	a4,s1,s5
    3fce:	00a767b3          	or	a5,a4,a0
    3fd2:	2781                	sext.w	a5,a5
    3fd4:	d3c1                	beqz	a5,3f54 <concreate+0x17c>
    3fd6:	01671363          	bne	a4,s6,3fdc <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    3fda:	fd2d                	bnez	a0,3f54 <concreate+0x17c>
      unlink(file);
    3fdc:	fa840513          	add	a0,s0,-88
    3fe0:	281000ef          	jal	4a60 <unlink>
      unlink(file);
    3fe4:	fa840513          	add	a0,s0,-88
    3fe8:	279000ef          	jal	4a60 <unlink>
      unlink(file);
    3fec:	fa840513          	add	a0,s0,-88
    3ff0:	271000ef          	jal	4a60 <unlink>
      unlink(file);
    3ff4:	fa840513          	add	a0,s0,-88
    3ff8:	269000ef          	jal	4a60 <unlink>
      unlink(file);
    3ffc:	fa840513          	add	a0,s0,-88
    4000:	261000ef          	jal	4a60 <unlink>
      unlink(file);
    4004:	fa840513          	add	a0,s0,-88
    4008:	259000ef          	jal	4a60 <unlink>
    400c:	bf71                	j	3fa8 <concreate+0x1d0>
      exit(0);
    400e:	4501                	li	a0,0
    4010:	201000ef          	jal	4a10 <exit>
      close(fd);
    4014:	225000ef          	jal	4a38 <close>
    if(pid == 0) {
    4018:	b599                	j	3e5e <concreate+0x86>
      close(fd);
    401a:	21f000ef          	jal	4a38 <close>
      wait(&xstatus);
    401e:	f6c40513          	add	a0,s0,-148
    4022:	1f7000ef          	jal	4a18 <wait>
      if(xstatus != 0)
    4026:	f6c42483          	lw	s1,-148(s0)
    402a:	e2049de3          	bnez	s1,3e64 <concreate+0x8c>
  for(i = 0; i < N; i++){
    402e:	2905                	addw	s2,s2,1
    4030:	e3490de3          	beq	s2,s4,3e6a <concreate+0x92>
    file[1] = '0' + i;
    4034:	0309079b          	addw	a5,s2,48
    4038:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    403c:	fa840513          	add	a0,s0,-88
    4040:	221000ef          	jal	4a60 <unlink>
    pid = fork();
    4044:	1c5000ef          	jal	4a08 <fork>
    if(pid && (i % 3) == 1){
    4048:	dc050ae3          	beqz	a0,3e1c <concreate+0x44>
    404c:	036967bb          	remw	a5,s2,s6
    4050:	dd5780e3          	beq	a5,s5,3e10 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4054:	20200593          	li	a1,514
    4058:	fa840513          	add	a0,s0,-88
    405c:	1f5000ef          	jal	4a50 <open>
      if(fd < 0){
    4060:	fa055de3          	bgez	a0,401a <concreate+0x242>
    4064:	bbd1                	j	3e38 <concreate+0x60>
}
    4066:	60ea                	ld	ra,152(sp)
    4068:	644a                	ld	s0,144(sp)
    406a:	64aa                	ld	s1,136(sp)
    406c:	690a                	ld	s2,128(sp)
    406e:	79e6                	ld	s3,120(sp)
    4070:	7a46                	ld	s4,112(sp)
    4072:	7aa6                	ld	s5,104(sp)
    4074:	7b06                	ld	s6,96(sp)
    4076:	6be6                	ld	s7,88(sp)
    4078:	610d                	add	sp,sp,160
    407a:	8082                	ret

000000000000407c <bigfile>:
{
    407c:	7139                	add	sp,sp,-64
    407e:	fc06                	sd	ra,56(sp)
    4080:	f822                	sd	s0,48(sp)
    4082:	f426                	sd	s1,40(sp)
    4084:	f04a                	sd	s2,32(sp)
    4086:	ec4e                	sd	s3,24(sp)
    4088:	e852                	sd	s4,16(sp)
    408a:	e456                	sd	s5,8(sp)
    408c:	0080                	add	s0,sp,64
    408e:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4090:	00003517          	auipc	a0,0x3
    4094:	c6050513          	add	a0,a0,-928 # 6cf0 <malloc+0x1e12>
    4098:	1c9000ef          	jal	4a60 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    409c:	20200593          	li	a1,514
    40a0:	00003517          	auipc	a0,0x3
    40a4:	c5050513          	add	a0,a0,-944 # 6cf0 <malloc+0x1e12>
    40a8:	1a9000ef          	jal	4a50 <open>
    40ac:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    40ae:	4481                	li	s1,0
    memset(buf, i, SZ);
    40b0:	00008917          	auipc	s2,0x8
    40b4:	bc890913          	add	s2,s2,-1080 # bc78 <buf>
  for(i = 0; i < N; i++){
    40b8:	4a51                	li	s4,20
  if(fd < 0){
    40ba:	08054663          	bltz	a0,4146 <bigfile+0xca>
    memset(buf, i, SZ);
    40be:	25800613          	li	a2,600
    40c2:	85a6                	mv	a1,s1
    40c4:	854a                	mv	a0,s2
    40c6:	764000ef          	jal	482a <memset>
    if(write(fd, buf, SZ) != SZ){
    40ca:	25800613          	li	a2,600
    40ce:	85ca                	mv	a1,s2
    40d0:	854e                	mv	a0,s3
    40d2:	15f000ef          	jal	4a30 <write>
    40d6:	25800793          	li	a5,600
    40da:	08f51063          	bne	a0,a5,415a <bigfile+0xde>
  for(i = 0; i < N; i++){
    40de:	2485                	addw	s1,s1,1
    40e0:	fd449fe3          	bne	s1,s4,40be <bigfile+0x42>
  close(fd);
    40e4:	854e                	mv	a0,s3
    40e6:	153000ef          	jal	4a38 <close>
  fd = open("bigfile.dat", 0);
    40ea:	4581                	li	a1,0
    40ec:	00003517          	auipc	a0,0x3
    40f0:	c0450513          	add	a0,a0,-1020 # 6cf0 <malloc+0x1e12>
    40f4:	15d000ef          	jal	4a50 <open>
    40f8:	8a2a                	mv	s4,a0
  total = 0;
    40fa:	4981                	li	s3,0
  for(i = 0; ; i++){
    40fc:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    40fe:	00008917          	auipc	s2,0x8
    4102:	b7a90913          	add	s2,s2,-1158 # bc78 <buf>
  if(fd < 0){
    4106:	06054463          	bltz	a0,416e <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    410a:	12c00613          	li	a2,300
    410e:	85ca                	mv	a1,s2
    4110:	8552                	mv	a0,s4
    4112:	117000ef          	jal	4a28 <read>
    if(cc < 0){
    4116:	06054663          	bltz	a0,4182 <bigfile+0x106>
    if(cc == 0)
    411a:	c155                	beqz	a0,41be <bigfile+0x142>
    if(cc != SZ/2){
    411c:	12c00793          	li	a5,300
    4120:	06f51b63          	bne	a0,a5,4196 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4124:	01f4d79b          	srlw	a5,s1,0x1f
    4128:	9fa5                	addw	a5,a5,s1
    412a:	4017d79b          	sraw	a5,a5,0x1
    412e:	00094703          	lbu	a4,0(s2)
    4132:	06f71c63          	bne	a4,a5,41aa <bigfile+0x12e>
    4136:	12b94703          	lbu	a4,299(s2)
    413a:	06f71863          	bne	a4,a5,41aa <bigfile+0x12e>
    total += cc;
    413e:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    4142:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4144:	b7d9                	j	410a <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    4146:	85d6                	mv	a1,s5
    4148:	00003517          	auipc	a0,0x3
    414c:	bb850513          	add	a0,a0,-1096 # 6d00 <malloc+0x1e22>
    4150:	4db000ef          	jal	4e2a <printf>
    exit(1);
    4154:	4505                	li	a0,1
    4156:	0bb000ef          	jal	4a10 <exit>
      printf("%s: write bigfile failed\n", s);
    415a:	85d6                	mv	a1,s5
    415c:	00003517          	auipc	a0,0x3
    4160:	bc450513          	add	a0,a0,-1084 # 6d20 <malloc+0x1e42>
    4164:	4c7000ef          	jal	4e2a <printf>
      exit(1);
    4168:	4505                	li	a0,1
    416a:	0a7000ef          	jal	4a10 <exit>
    printf("%s: cannot open bigfile\n", s);
    416e:	85d6                	mv	a1,s5
    4170:	00003517          	auipc	a0,0x3
    4174:	bd050513          	add	a0,a0,-1072 # 6d40 <malloc+0x1e62>
    4178:	4b3000ef          	jal	4e2a <printf>
    exit(1);
    417c:	4505                	li	a0,1
    417e:	093000ef          	jal	4a10 <exit>
      printf("%s: read bigfile failed\n", s);
    4182:	85d6                	mv	a1,s5
    4184:	00003517          	auipc	a0,0x3
    4188:	bdc50513          	add	a0,a0,-1060 # 6d60 <malloc+0x1e82>
    418c:	49f000ef          	jal	4e2a <printf>
      exit(1);
    4190:	4505                	li	a0,1
    4192:	07f000ef          	jal	4a10 <exit>
      printf("%s: short read bigfile\n", s);
    4196:	85d6                	mv	a1,s5
    4198:	00003517          	auipc	a0,0x3
    419c:	be850513          	add	a0,a0,-1048 # 6d80 <malloc+0x1ea2>
    41a0:	48b000ef          	jal	4e2a <printf>
      exit(1);
    41a4:	4505                	li	a0,1
    41a6:	06b000ef          	jal	4a10 <exit>
      printf("%s: read bigfile wrong data\n", s);
    41aa:	85d6                	mv	a1,s5
    41ac:	00003517          	auipc	a0,0x3
    41b0:	bec50513          	add	a0,a0,-1044 # 6d98 <malloc+0x1eba>
    41b4:	477000ef          	jal	4e2a <printf>
      exit(1);
    41b8:	4505                	li	a0,1
    41ba:	057000ef          	jal	4a10 <exit>
  close(fd);
    41be:	8552                	mv	a0,s4
    41c0:	079000ef          	jal	4a38 <close>
  if(total != N*SZ){
    41c4:	678d                	lui	a5,0x3
    41c6:	ee078793          	add	a5,a5,-288 # 2ee0 <subdir+0x352>
    41ca:	02f99163          	bne	s3,a5,41ec <bigfile+0x170>
  unlink("bigfile.dat");
    41ce:	00003517          	auipc	a0,0x3
    41d2:	b2250513          	add	a0,a0,-1246 # 6cf0 <malloc+0x1e12>
    41d6:	08b000ef          	jal	4a60 <unlink>
}
    41da:	70e2                	ld	ra,56(sp)
    41dc:	7442                	ld	s0,48(sp)
    41de:	74a2                	ld	s1,40(sp)
    41e0:	7902                	ld	s2,32(sp)
    41e2:	69e2                	ld	s3,24(sp)
    41e4:	6a42                	ld	s4,16(sp)
    41e6:	6aa2                	ld	s5,8(sp)
    41e8:	6121                	add	sp,sp,64
    41ea:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    41ec:	85d6                	mv	a1,s5
    41ee:	00003517          	auipc	a0,0x3
    41f2:	bca50513          	add	a0,a0,-1078 # 6db8 <malloc+0x1eda>
    41f6:	435000ef          	jal	4e2a <printf>
    exit(1);
    41fa:	4505                	li	a0,1
    41fc:	015000ef          	jal	4a10 <exit>

0000000000004200 <bigargtest>:
{
    4200:	7121                	add	sp,sp,-448
    4202:	ff06                	sd	ra,440(sp)
    4204:	fb22                	sd	s0,432(sp)
    4206:	f726                	sd	s1,424(sp)
    4208:	0380                	add	s0,sp,448
    420a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    420c:	00003517          	auipc	a0,0x3
    4210:	bcc50513          	add	a0,a0,-1076 # 6dd8 <malloc+0x1efa>
    4214:	04d000ef          	jal	4a60 <unlink>
  pid = fork();
    4218:	7f0000ef          	jal	4a08 <fork>
  if(pid == 0){
    421c:	c915                	beqz	a0,4250 <bigargtest+0x50>
  } else if(pid < 0){
    421e:	08054a63          	bltz	a0,42b2 <bigargtest+0xb2>
  wait(&xstatus);
    4222:	fdc40513          	add	a0,s0,-36
    4226:	7f2000ef          	jal	4a18 <wait>
  if(xstatus != 0)
    422a:	fdc42503          	lw	a0,-36(s0)
    422e:	ed41                	bnez	a0,42c6 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    4230:	4581                	li	a1,0
    4232:	00003517          	auipc	a0,0x3
    4236:	ba650513          	add	a0,a0,-1114 # 6dd8 <malloc+0x1efa>
    423a:	017000ef          	jal	4a50 <open>
  if(fd < 0){
    423e:	08054663          	bltz	a0,42ca <bigargtest+0xca>
  close(fd);
    4242:	7f6000ef          	jal	4a38 <close>
}
    4246:	70fa                	ld	ra,440(sp)
    4248:	745a                	ld	s0,432(sp)
    424a:	74ba                	ld	s1,424(sp)
    424c:	6139                	add	sp,sp,448
    424e:	8082                	ret
    memset(big, ' ', sizeof(big));
    4250:	19000613          	li	a2,400
    4254:	02000593          	li	a1,32
    4258:	e4840513          	add	a0,s0,-440
    425c:	5ce000ef          	jal	482a <memset>
    big[sizeof(big)-1] = '\0';
    4260:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    4264:	00004797          	auipc	a5,0x4
    4268:	1fc78793          	add	a5,a5,508 # 8460 <args.1>
    426c:	00004697          	auipc	a3,0x4
    4270:	2ec68693          	add	a3,a3,748 # 8558 <args.1+0xf8>
      args[i] = big;
    4274:	e4840713          	add	a4,s0,-440
    4278:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    427a:	07a1                	add	a5,a5,8
    427c:	fed79ee3          	bne	a5,a3,4278 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    4280:	00004597          	auipc	a1,0x4
    4284:	1e058593          	add	a1,a1,480 # 8460 <args.1>
    4288:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    428c:	00001517          	auipc	a0,0x1
    4290:	d6c50513          	add	a0,a0,-660 # 4ff8 <malloc+0x11a>
    4294:	7b4000ef          	jal	4a48 <exec>
    fd = open("bigarg-ok", O_CREATE);
    4298:	20000593          	li	a1,512
    429c:	00003517          	auipc	a0,0x3
    42a0:	b3c50513          	add	a0,a0,-1220 # 6dd8 <malloc+0x1efa>
    42a4:	7ac000ef          	jal	4a50 <open>
    close(fd);
    42a8:	790000ef          	jal	4a38 <close>
    exit(0);
    42ac:	4501                	li	a0,0
    42ae:	762000ef          	jal	4a10 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    42b2:	85a6                	mv	a1,s1
    42b4:	00003517          	auipc	a0,0x3
    42b8:	b3450513          	add	a0,a0,-1228 # 6de8 <malloc+0x1f0a>
    42bc:	36f000ef          	jal	4e2a <printf>
    exit(1);
    42c0:	4505                	li	a0,1
    42c2:	74e000ef          	jal	4a10 <exit>
    exit(xstatus);
    42c6:	74a000ef          	jal	4a10 <exit>
    printf("%s: bigarg test failed!\n", s);
    42ca:	85a6                	mv	a1,s1
    42cc:	00003517          	auipc	a0,0x3
    42d0:	b3c50513          	add	a0,a0,-1220 # 6e08 <malloc+0x1f2a>
    42d4:	357000ef          	jal	4e2a <printf>
    exit(1);
    42d8:	4505                	li	a0,1
    42da:	736000ef          	jal	4a10 <exit>

00000000000042de <fsfull>:
{
    42de:	7135                	add	sp,sp,-160
    42e0:	ed06                	sd	ra,152(sp)
    42e2:	e922                	sd	s0,144(sp)
    42e4:	e526                	sd	s1,136(sp)
    42e6:	e14a                	sd	s2,128(sp)
    42e8:	fcce                	sd	s3,120(sp)
    42ea:	f8d2                	sd	s4,112(sp)
    42ec:	f4d6                	sd	s5,104(sp)
    42ee:	f0da                	sd	s6,96(sp)
    42f0:	ecde                	sd	s7,88(sp)
    42f2:	e8e2                	sd	s8,80(sp)
    42f4:	e4e6                	sd	s9,72(sp)
    42f6:	e0ea                	sd	s10,64(sp)
    42f8:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    42fa:	00003517          	auipc	a0,0x3
    42fe:	b2e50513          	add	a0,a0,-1234 # 6e28 <malloc+0x1f4a>
    4302:	329000ef          	jal	4e2a <printf>
  for(nfiles = 0; ; nfiles++){
    4306:	4481                	li	s1,0
    name[0] = 'f';
    4308:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    430c:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4310:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4314:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4316:	00003c97          	auipc	s9,0x3
    431a:	b22c8c93          	add	s9,s9,-1246 # 6e38 <malloc+0x1f5a>
    name[0] = 'f';
    431e:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4322:	0384c7bb          	divw	a5,s1,s8
    4326:	0307879b          	addw	a5,a5,48
    432a:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    432e:	0384e7bb          	remw	a5,s1,s8
    4332:	0377c7bb          	divw	a5,a5,s7
    4336:	0307879b          	addw	a5,a5,48
    433a:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    433e:	0374e7bb          	remw	a5,s1,s7
    4342:	0367c7bb          	divw	a5,a5,s6
    4346:	0307879b          	addw	a5,a5,48
    434a:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    434e:	0364e7bb          	remw	a5,s1,s6
    4352:	0307879b          	addw	a5,a5,48
    4356:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    435a:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    435e:	f6040593          	add	a1,s0,-160
    4362:	8566                	mv	a0,s9
    4364:	2c7000ef          	jal	4e2a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4368:	20200593          	li	a1,514
    436c:	f6040513          	add	a0,s0,-160
    4370:	6e0000ef          	jal	4a50 <open>
    4374:	892a                	mv	s2,a0
    if(fd < 0){
    4376:	08055f63          	bgez	a0,4414 <fsfull+0x136>
      printf("open %s failed\n", name);
    437a:	f6040593          	add	a1,s0,-160
    437e:	00003517          	auipc	a0,0x3
    4382:	aca50513          	add	a0,a0,-1334 # 6e48 <malloc+0x1f6a>
    4386:	2a5000ef          	jal	4e2a <printf>
  while(nfiles >= 0){
    438a:	0604c163          	bltz	s1,43ec <fsfull+0x10e>
    name[0] = 'f';
    438e:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4392:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4396:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    439a:	4929                	li	s2,10
  while(nfiles >= 0){
    439c:	5afd                	li	s5,-1
    name[0] = 'f';
    439e:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    43a2:	0344c7bb          	divw	a5,s1,s4
    43a6:	0307879b          	addw	a5,a5,48
    43aa:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    43ae:	0344e7bb          	remw	a5,s1,s4
    43b2:	0337c7bb          	divw	a5,a5,s3
    43b6:	0307879b          	addw	a5,a5,48
    43ba:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    43be:	0334e7bb          	remw	a5,s1,s3
    43c2:	0327c7bb          	divw	a5,a5,s2
    43c6:	0307879b          	addw	a5,a5,48
    43ca:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    43ce:	0324e7bb          	remw	a5,s1,s2
    43d2:	0307879b          	addw	a5,a5,48
    43d6:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    43da:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    43de:	f6040513          	add	a0,s0,-160
    43e2:	67e000ef          	jal	4a60 <unlink>
    nfiles--;
    43e6:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    43e8:	fb549be3          	bne	s1,s5,439e <fsfull+0xc0>
  printf("fsfull test finished\n");
    43ec:	00003517          	auipc	a0,0x3
    43f0:	a7c50513          	add	a0,a0,-1412 # 6e68 <malloc+0x1f8a>
    43f4:	237000ef          	jal	4e2a <printf>
}
    43f8:	60ea                	ld	ra,152(sp)
    43fa:	644a                	ld	s0,144(sp)
    43fc:	64aa                	ld	s1,136(sp)
    43fe:	690a                	ld	s2,128(sp)
    4400:	79e6                	ld	s3,120(sp)
    4402:	7a46                	ld	s4,112(sp)
    4404:	7aa6                	ld	s5,104(sp)
    4406:	7b06                	ld	s6,96(sp)
    4408:	6be6                	ld	s7,88(sp)
    440a:	6c46                	ld	s8,80(sp)
    440c:	6ca6                	ld	s9,72(sp)
    440e:	6d06                	ld	s10,64(sp)
    4410:	610d                	add	sp,sp,160
    4412:	8082                	ret
    int total = 0;
    4414:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4416:	00008a97          	auipc	s5,0x8
    441a:	862a8a93          	add	s5,s5,-1950 # bc78 <buf>
      if(cc < BSIZE)
    441e:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4422:	40000613          	li	a2,1024
    4426:	85d6                	mv	a1,s5
    4428:	854a                	mv	a0,s2
    442a:	606000ef          	jal	4a30 <write>
      if(cc < BSIZE)
    442e:	00aa5563          	bge	s4,a0,4438 <fsfull+0x15a>
      total += cc;
    4432:	00a989bb          	addw	s3,s3,a0
    while(1){
    4436:	b7f5                	j	4422 <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    4438:	85ce                	mv	a1,s3
    443a:	00003517          	auipc	a0,0x3
    443e:	a1e50513          	add	a0,a0,-1506 # 6e58 <malloc+0x1f7a>
    4442:	1e9000ef          	jal	4e2a <printf>
    close(fd);
    4446:	854a                	mv	a0,s2
    4448:	5f0000ef          	jal	4a38 <close>
    if(total == 0)
    444c:	f2098fe3          	beqz	s3,438a <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    4450:	2485                	addw	s1,s1,1
    4452:	b5f1                	j	431e <fsfull+0x40>

0000000000004454 <run>:
/* */

/* run each test in its own process. run returns 1 if child's exit() */
/* indicates success. */
int
run(void f(char *), char *s) {
    4454:	7179                	add	sp,sp,-48
    4456:	f406                	sd	ra,40(sp)
    4458:	f022                	sd	s0,32(sp)
    445a:	ec26                	sd	s1,24(sp)
    445c:	e84a                	sd	s2,16(sp)
    445e:	1800                	add	s0,sp,48
    4460:	84aa                	mv	s1,a0
    4462:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4464:	00003517          	auipc	a0,0x3
    4468:	a1c50513          	add	a0,a0,-1508 # 6e80 <malloc+0x1fa2>
    446c:	1bf000ef          	jal	4e2a <printf>
  if((pid = fork()) < 0) {
    4470:	598000ef          	jal	4a08 <fork>
    4474:	02054a63          	bltz	a0,44a8 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4478:	c129                	beqz	a0,44ba <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    447a:	fdc40513          	add	a0,s0,-36
    447e:	59a000ef          	jal	4a18 <wait>
    if(xstatus != 0) 
    4482:	fdc42783          	lw	a5,-36(s0)
    4486:	cf9d                	beqz	a5,44c4 <run+0x70>
      printf("FAILED\n");
    4488:	00003517          	auipc	a0,0x3
    448c:	a2050513          	add	a0,a0,-1504 # 6ea8 <malloc+0x1fca>
    4490:	19b000ef          	jal	4e2a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4494:	fdc42503          	lw	a0,-36(s0)
  }
}
    4498:	00153513          	seqz	a0,a0
    449c:	70a2                	ld	ra,40(sp)
    449e:	7402                	ld	s0,32(sp)
    44a0:	64e2                	ld	s1,24(sp)
    44a2:	6942                	ld	s2,16(sp)
    44a4:	6145                	add	sp,sp,48
    44a6:	8082                	ret
    printf("runtest: fork error\n");
    44a8:	00003517          	auipc	a0,0x3
    44ac:	9e850513          	add	a0,a0,-1560 # 6e90 <malloc+0x1fb2>
    44b0:	17b000ef          	jal	4e2a <printf>
    exit(1);
    44b4:	4505                	li	a0,1
    44b6:	55a000ef          	jal	4a10 <exit>
    f(s);
    44ba:	854a                	mv	a0,s2
    44bc:	9482                	jalr	s1
    exit(0);
    44be:	4501                	li	a0,0
    44c0:	550000ef          	jal	4a10 <exit>
      printf("OK\n");
    44c4:	00003517          	auipc	a0,0x3
    44c8:	9ec50513          	add	a0,a0,-1556 # 6eb0 <malloc+0x1fd2>
    44cc:	15f000ef          	jal	4e2a <printf>
    44d0:	b7d1                	j	4494 <run+0x40>

00000000000044d2 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    44d2:	7139                	add	sp,sp,-64
    44d4:	fc06                	sd	ra,56(sp)
    44d6:	f822                	sd	s0,48(sp)
    44d8:	f426                	sd	s1,40(sp)
    44da:	f04a                	sd	s2,32(sp)
    44dc:	ec4e                	sd	s3,24(sp)
    44de:	e852                	sd	s4,16(sp)
    44e0:	e456                	sd	s5,8(sp)
    44e2:	0080                	add	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    44e4:	00853903          	ld	s2,8(a0)
    44e8:	04090c63          	beqz	s2,4540 <runtests+0x6e>
    44ec:	84aa                	mv	s1,a0
    44ee:	89ae                	mv	s3,a1
    44f0:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    44f2:	4a89                	li	s5,2
    44f4:	a031                	j	4500 <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    44f6:	04c1                	add	s1,s1,16
    44f8:	0084b903          	ld	s2,8(s1)
    44fc:	02090863          	beqz	s2,452c <runtests+0x5a>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4500:	00098763          	beqz	s3,450e <runtests+0x3c>
    4504:	85ce                	mv	a1,s3
    4506:	854a                	mv	a0,s2
    4508:	2cc000ef          	jal	47d4 <strcmp>
    450c:	f56d                	bnez	a0,44f6 <runtests+0x24>
      if(!run(t->f, t->s)){
    450e:	85ca                	mv	a1,s2
    4510:	6088                	ld	a0,0(s1)
    4512:	f43ff0ef          	jal	4454 <run>
    4516:	f165                	bnez	a0,44f6 <runtests+0x24>
        if(continuous != 2){
    4518:	fd5a0fe3          	beq	s4,s5,44f6 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    451c:	00003517          	auipc	a0,0x3
    4520:	99c50513          	add	a0,a0,-1636 # 6eb8 <malloc+0x1fda>
    4524:	107000ef          	jal	4e2a <printf>
          return 1;
    4528:	4505                	li	a0,1
    452a:	a011                	j	452e <runtests+0x5c>
        }
      }
    }
  }
  return 0;
    452c:	4501                	li	a0,0
}
    452e:	70e2                	ld	ra,56(sp)
    4530:	7442                	ld	s0,48(sp)
    4532:	74a2                	ld	s1,40(sp)
    4534:	7902                	ld	s2,32(sp)
    4536:	69e2                	ld	s3,24(sp)
    4538:	6a42                	ld	s4,16(sp)
    453a:	6aa2                	ld	s5,8(sp)
    453c:	6121                	add	sp,sp,64
    453e:	8082                	ret
  return 0;
    4540:	4501                	li	a0,0
    4542:	b7f5                	j	452e <runtests+0x5c>

0000000000004544 <countfree>:
/* because out of memory with lazy allocation results in the process */
/* taking a fault and being killed, fork and report back. */
/* */
int
countfree()
{
    4544:	7139                	add	sp,sp,-64
    4546:	fc06                	sd	ra,56(sp)
    4548:	f822                	sd	s0,48(sp)
    454a:	f426                	sd	s1,40(sp)
    454c:	f04a                	sd	s2,32(sp)
    454e:	ec4e                	sd	s3,24(sp)
    4550:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4552:	fc840513          	add	a0,s0,-56
    4556:	4ca000ef          	jal	4a20 <pipe>
    455a:	04054b63          	bltz	a0,45b0 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    455e:	4aa000ef          	jal	4a08 <fork>

  if(pid < 0){
    4562:	06054063          	bltz	a0,45c2 <countfree+0x7e>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4566:	e935                	bnez	a0,45da <countfree+0x96>
    close(fds[0]);
    4568:	fc842503          	lw	a0,-56(s0)
    456c:	4cc000ef          	jal	4a38 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4570:	597d                	li	s2,-1
        break;
      }

      /* modify the memory to make sure it's really allocated. */
      *(char *)(a + 4096 - 1) = 1;
    4572:	4485                	li	s1,1

      /* report back one more page. */
      if(write(fds[1], "x", 1) != 1){
    4574:	00001997          	auipc	s3,0x1
    4578:	af498993          	add	s3,s3,-1292 # 5068 <malloc+0x18a>
      uint64 a = (uint64) sbrk(4096);
    457c:	6505                	lui	a0,0x1
    457e:	51a000ef          	jal	4a98 <sbrk>
      if(a == 0xffffffffffffffff){
    4582:	05250963          	beq	a0,s2,45d4 <countfree+0x90>
      *(char *)(a + 4096 - 1) = 1;
    4586:	6785                	lui	a5,0x1
    4588:	97aa                	add	a5,a5,a0
    458a:	fe978fa3          	sb	s1,-1(a5) # fff <pgbug+0x27>
      if(write(fds[1], "x", 1) != 1){
    458e:	8626                	mv	a2,s1
    4590:	85ce                	mv	a1,s3
    4592:	fcc42503          	lw	a0,-52(s0)
    4596:	49a000ef          	jal	4a30 <write>
    459a:	fe9501e3          	beq	a0,s1,457c <countfree+0x38>
        printf("write() failed in countfree()\n");
    459e:	00003517          	auipc	a0,0x3
    45a2:	97250513          	add	a0,a0,-1678 # 6f10 <malloc+0x2032>
    45a6:	085000ef          	jal	4e2a <printf>
        exit(1);
    45aa:	4505                	li	a0,1
    45ac:	464000ef          	jal	4a10 <exit>
    printf("pipe() failed in countfree()\n");
    45b0:	00003517          	auipc	a0,0x3
    45b4:	92050513          	add	a0,a0,-1760 # 6ed0 <malloc+0x1ff2>
    45b8:	073000ef          	jal	4e2a <printf>
    exit(1);
    45bc:	4505                	li	a0,1
    45be:	452000ef          	jal	4a10 <exit>
    printf("fork failed in countfree()\n");
    45c2:	00003517          	auipc	a0,0x3
    45c6:	92e50513          	add	a0,a0,-1746 # 6ef0 <malloc+0x2012>
    45ca:	061000ef          	jal	4e2a <printf>
    exit(1);
    45ce:	4505                	li	a0,1
    45d0:	440000ef          	jal	4a10 <exit>
      }
    }

    exit(0);
    45d4:	4501                	li	a0,0
    45d6:	43a000ef          	jal	4a10 <exit>
  }

  close(fds[1]);
    45da:	fcc42503          	lw	a0,-52(s0)
    45de:	45a000ef          	jal	4a38 <close>

  int n = 0;
    45e2:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    45e4:	4605                	li	a2,1
    45e6:	fc740593          	add	a1,s0,-57
    45ea:	fc842503          	lw	a0,-56(s0)
    45ee:	43a000ef          	jal	4a28 <read>
    if(cc < 0){
    45f2:	00054563          	bltz	a0,45fc <countfree+0xb8>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    45f6:	cd01                	beqz	a0,460e <countfree+0xca>
      break;
    n += 1;
    45f8:	2485                	addw	s1,s1,1
  while(1){
    45fa:	b7ed                	j	45e4 <countfree+0xa0>
      printf("read() failed in countfree()\n");
    45fc:	00003517          	auipc	a0,0x3
    4600:	93450513          	add	a0,a0,-1740 # 6f30 <malloc+0x2052>
    4604:	027000ef          	jal	4e2a <printf>
      exit(1);
    4608:	4505                	li	a0,1
    460a:	406000ef          	jal	4a10 <exit>
  }

  close(fds[0]);
    460e:	fc842503          	lw	a0,-56(s0)
    4612:	426000ef          	jal	4a38 <close>
  wait((int*)0);
    4616:	4501                	li	a0,0
    4618:	400000ef          	jal	4a18 <wait>
  
  return n;
}
    461c:	8526                	mv	a0,s1
    461e:	70e2                	ld	ra,56(sp)
    4620:	7442                	ld	s0,48(sp)
    4622:	74a2                	ld	s1,40(sp)
    4624:	7902                	ld	s2,32(sp)
    4626:	69e2                	ld	s3,24(sp)
    4628:	6121                	add	sp,sp,64
    462a:	8082                	ret

000000000000462c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    462c:	711d                	add	sp,sp,-96
    462e:	ec86                	sd	ra,88(sp)
    4630:	e8a2                	sd	s0,80(sp)
    4632:	e4a6                	sd	s1,72(sp)
    4634:	e0ca                	sd	s2,64(sp)
    4636:	fc4e                	sd	s3,56(sp)
    4638:	f852                	sd	s4,48(sp)
    463a:	f456                	sd	s5,40(sp)
    463c:	f05a                	sd	s6,32(sp)
    463e:	ec5e                	sd	s7,24(sp)
    4640:	e862                	sd	s8,16(sp)
    4642:	e466                	sd	s9,8(sp)
    4644:	e06a                	sd	s10,0(sp)
    4646:	1080                	add	s0,sp,96
    4648:	8aaa                	mv	s5,a0
    464a:	892e                	mv	s2,a1
    464c:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    464e:	00003b97          	auipc	s7,0x3
    4652:	902b8b93          	add	s7,s7,-1790 # 6f50 <malloc+0x2072>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    4656:	00004b17          	auipc	s6,0x4
    465a:	9bab0b13          	add	s6,s6,-1606 # 8010 <quicktests>
      if(continuous != 2) {
    465e:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    4660:	00004c17          	auipc	s8,0x4
    4664:	d80c0c13          	add	s8,s8,-640 # 83e0 <slowtests>
        printf("usertests slow tests starting\n");
    4668:	00003d17          	auipc	s10,0x3
    466c:	900d0d13          	add	s10,s10,-1792 # 6f68 <malloc+0x208a>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4670:	00003c97          	auipc	s9,0x3
    4674:	918c8c93          	add	s9,s9,-1768 # 6f88 <malloc+0x20aa>
    4678:	a819                	j	468e <drivetests+0x62>
        printf("usertests slow tests starting\n");
    467a:	856a                	mv	a0,s10
    467c:	7ae000ef          	jal	4e2a <printf>
    4680:	a80d                	j	46b2 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    4682:	ec3ff0ef          	jal	4544 <countfree>
    4686:	04954063          	blt	a0,s1,46c6 <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    468a:	04090963          	beqz	s2,46dc <drivetests+0xb0>
    printf("usertests starting\n");
    468e:	855e                	mv	a0,s7
    4690:	79a000ef          	jal	4e2a <printf>
    int free0 = countfree();
    4694:	eb1ff0ef          	jal	4544 <countfree>
    4698:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    469a:	864a                	mv	a2,s2
    469c:	85ce                	mv	a1,s3
    469e:	855a                	mv	a0,s6
    46a0:	e33ff0ef          	jal	44d2 <runtests>
    46a4:	c119                	beqz	a0,46aa <drivetests+0x7e>
      if(continuous != 2) {
    46a6:	03491963          	bne	s2,s4,46d8 <drivetests+0xac>
    if(!quick) {
    46aa:	fc0a9ce3          	bnez	s5,4682 <drivetests+0x56>
      if (justone == 0)
    46ae:	fc0986e3          	beqz	s3,467a <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    46b2:	864a                	mv	a2,s2
    46b4:	85ce                	mv	a1,s3
    46b6:	8562                	mv	a0,s8
    46b8:	e1bff0ef          	jal	44d2 <runtests>
    46bc:	d179                	beqz	a0,4682 <drivetests+0x56>
        if(continuous != 2) {
    46be:	fd4902e3          	beq	s2,s4,4682 <drivetests+0x56>
          return 1;
    46c2:	4505                	li	a0,1
    46c4:	a829                	j	46de <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46c6:	8626                	mv	a2,s1
    46c8:	85aa                	mv	a1,a0
    46ca:	8566                	mv	a0,s9
    46cc:	75e000ef          	jal	4e2a <printf>
      if(continuous != 2) {
    46d0:	fb490fe3          	beq	s2,s4,468e <drivetests+0x62>
        return 1;
    46d4:	4505                	li	a0,1
    46d6:	a021                	j	46de <drivetests+0xb2>
        return 1;
    46d8:	4505                	li	a0,1
    46da:	a011                	j	46de <drivetests+0xb2>
  return 0;
    46dc:	854a                	mv	a0,s2
}
    46de:	60e6                	ld	ra,88(sp)
    46e0:	6446                	ld	s0,80(sp)
    46e2:	64a6                	ld	s1,72(sp)
    46e4:	6906                	ld	s2,64(sp)
    46e6:	79e2                	ld	s3,56(sp)
    46e8:	7a42                	ld	s4,48(sp)
    46ea:	7aa2                	ld	s5,40(sp)
    46ec:	7b02                	ld	s6,32(sp)
    46ee:	6be2                	ld	s7,24(sp)
    46f0:	6c42                	ld	s8,16(sp)
    46f2:	6ca2                	ld	s9,8(sp)
    46f4:	6d02                	ld	s10,0(sp)
    46f6:	6125                	add	sp,sp,96
    46f8:	8082                	ret

00000000000046fa <main>:

int
main(int argc, char *argv[])
{
    46fa:	1101                	add	sp,sp,-32
    46fc:	ec06                	sd	ra,24(sp)
    46fe:	e822                	sd	s0,16(sp)
    4700:	e426                	sd	s1,8(sp)
    4702:	e04a                	sd	s2,0(sp)
    4704:	1000                	add	s0,sp,32
    4706:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4708:	4789                	li	a5,2
    470a:	00f50f63          	beq	a0,a5,4728 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    470e:	4785                	li	a5,1
    4710:	06a7c063          	blt	a5,a0,4770 <main+0x76>
  char *justone = 0;
    4714:	4901                	li	s2,0
  int quick = 0;
    4716:	4501                	li	a0,0
  int continuous = 0;
    4718:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    471a:	864a                	mv	a2,s2
    471c:	f11ff0ef          	jal	462c <drivetests>
    4720:	c935                	beqz	a0,4794 <main+0x9a>
    exit(1);
    4722:	4505                	li	a0,1
    4724:	2ec000ef          	jal	4a10 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4728:	0085b903          	ld	s2,8(a1)
    472c:	00003597          	auipc	a1,0x3
    4730:	88c58593          	add	a1,a1,-1908 # 6fb8 <malloc+0x20da>
    4734:	854a                	mv	a0,s2
    4736:	09e000ef          	jal	47d4 <strcmp>
    473a:	85aa                	mv	a1,a0
    473c:	c139                	beqz	a0,4782 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    473e:	00003597          	auipc	a1,0x3
    4742:	88258593          	add	a1,a1,-1918 # 6fc0 <malloc+0x20e2>
    4746:	854a                	mv	a0,s2
    4748:	08c000ef          	jal	47d4 <strcmp>
    474c:	cd15                	beqz	a0,4788 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    474e:	00003597          	auipc	a1,0x3
    4752:	87a58593          	add	a1,a1,-1926 # 6fc8 <malloc+0x20ea>
    4756:	854a                	mv	a0,s2
    4758:	07c000ef          	jal	47d4 <strcmp>
    475c:	c90d                	beqz	a0,478e <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    475e:	00094703          	lbu	a4,0(s2)
    4762:	02d00793          	li	a5,45
    4766:	00f70563          	beq	a4,a5,4770 <main+0x76>
  int quick = 0;
    476a:	4501                	li	a0,0
  int continuous = 0;
    476c:	4581                	li	a1,0
    476e:	b775                	j	471a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4770:	00003517          	auipc	a0,0x3
    4774:	86050513          	add	a0,a0,-1952 # 6fd0 <malloc+0x20f2>
    4778:	6b2000ef          	jal	4e2a <printf>
    exit(1);
    477c:	4505                	li	a0,1
    477e:	292000ef          	jal	4a10 <exit>
  char *justone = 0;
    4782:	4901                	li	s2,0
    quick = 1;
    4784:	4505                	li	a0,1
    4786:	bf51                	j	471a <main+0x20>
  char *justone = 0;
    4788:	4901                	li	s2,0
    continuous = 1;
    478a:	4585                	li	a1,1
    478c:	b779                	j	471a <main+0x20>
    continuous = 2;
    478e:	85a6                	mv	a1,s1
  char *justone = 0;
    4790:	4901                	li	s2,0
    4792:	b761                	j	471a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4794:	00003517          	auipc	a0,0x3
    4798:	86c50513          	add	a0,a0,-1940 # 7000 <malloc+0x2122>
    479c:	68e000ef          	jal	4e2a <printf>
  exit(0);
    47a0:	4501                	li	a0,0
    47a2:	26e000ef          	jal	4a10 <exit>

00000000000047a6 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
    47a6:	1141                	add	sp,sp,-16
    47a8:	e406                	sd	ra,8(sp)
    47aa:	e022                	sd	s0,0(sp)
    47ac:	0800                	add	s0,sp,16
  extern int main();
  main();
    47ae:	f4dff0ef          	jal	46fa <main>
  exit(0);
    47b2:	4501                	li	a0,0
    47b4:	25c000ef          	jal	4a10 <exit>

00000000000047b8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    47b8:	1141                	add	sp,sp,-16
    47ba:	e422                	sd	s0,8(sp)
    47bc:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    47be:	87aa                	mv	a5,a0
    47c0:	0585                	add	a1,a1,1
    47c2:	0785                	add	a5,a5,1
    47c4:	fff5c703          	lbu	a4,-1(a1)
    47c8:	fee78fa3          	sb	a4,-1(a5)
    47cc:	fb75                	bnez	a4,47c0 <strcpy+0x8>
    ;
  return os;
}
    47ce:	6422                	ld	s0,8(sp)
    47d0:	0141                	add	sp,sp,16
    47d2:	8082                	ret

00000000000047d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    47d4:	1141                	add	sp,sp,-16
    47d6:	e422                	sd	s0,8(sp)
    47d8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    47da:	00054783          	lbu	a5,0(a0)
    47de:	cb91                	beqz	a5,47f2 <strcmp+0x1e>
    47e0:	0005c703          	lbu	a4,0(a1)
    47e4:	00f71763          	bne	a4,a5,47f2 <strcmp+0x1e>
    p++, q++;
    47e8:	0505                	add	a0,a0,1
    47ea:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    47ec:	00054783          	lbu	a5,0(a0)
    47f0:	fbe5                	bnez	a5,47e0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    47f2:	0005c503          	lbu	a0,0(a1)
}
    47f6:	40a7853b          	subw	a0,a5,a0
    47fa:	6422                	ld	s0,8(sp)
    47fc:	0141                	add	sp,sp,16
    47fe:	8082                	ret

0000000000004800 <strlen>:

uint
strlen(const char *s)
{
    4800:	1141                	add	sp,sp,-16
    4802:	e422                	sd	s0,8(sp)
    4804:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4806:	00054783          	lbu	a5,0(a0)
    480a:	cf91                	beqz	a5,4826 <strlen+0x26>
    480c:	0505                	add	a0,a0,1
    480e:	87aa                	mv	a5,a0
    4810:	86be                	mv	a3,a5
    4812:	0785                	add	a5,a5,1
    4814:	fff7c703          	lbu	a4,-1(a5)
    4818:	ff65                	bnez	a4,4810 <strlen+0x10>
    481a:	40a6853b          	subw	a0,a3,a0
    481e:	2505                	addw	a0,a0,1
    ;
  return n;
}
    4820:	6422                	ld	s0,8(sp)
    4822:	0141                	add	sp,sp,16
    4824:	8082                	ret
  for(n = 0; s[n]; n++)
    4826:	4501                	li	a0,0
    4828:	bfe5                	j	4820 <strlen+0x20>

000000000000482a <memset>:

void*
memset(void *dst, int c, uint n)
{
    482a:	1141                	add	sp,sp,-16
    482c:	e422                	sd	s0,8(sp)
    482e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4830:	ca19                	beqz	a2,4846 <memset+0x1c>
    4832:	87aa                	mv	a5,a0
    4834:	1602                	sll	a2,a2,0x20
    4836:	9201                	srl	a2,a2,0x20
    4838:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    483c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4840:	0785                	add	a5,a5,1
    4842:	fee79de3          	bne	a5,a4,483c <memset+0x12>
  }
  return dst;
}
    4846:	6422                	ld	s0,8(sp)
    4848:	0141                	add	sp,sp,16
    484a:	8082                	ret

000000000000484c <strchr>:

char*
strchr(const char *s, char c)
{
    484c:	1141                	add	sp,sp,-16
    484e:	e422                	sd	s0,8(sp)
    4850:	0800                	add	s0,sp,16
  for(; *s; s++)
    4852:	00054783          	lbu	a5,0(a0)
    4856:	cb99                	beqz	a5,486c <strchr+0x20>
    if(*s == c)
    4858:	00f58763          	beq	a1,a5,4866 <strchr+0x1a>
  for(; *s; s++)
    485c:	0505                	add	a0,a0,1
    485e:	00054783          	lbu	a5,0(a0)
    4862:	fbfd                	bnez	a5,4858 <strchr+0xc>
      return (char*)s;
  return 0;
    4864:	4501                	li	a0,0
}
    4866:	6422                	ld	s0,8(sp)
    4868:	0141                	add	sp,sp,16
    486a:	8082                	ret
  return 0;
    486c:	4501                	li	a0,0
    486e:	bfe5                	j	4866 <strchr+0x1a>

0000000000004870 <gets>:

char*
gets(char *buf, int max)
{
    4870:	711d                	add	sp,sp,-96
    4872:	ec86                	sd	ra,88(sp)
    4874:	e8a2                	sd	s0,80(sp)
    4876:	e4a6                	sd	s1,72(sp)
    4878:	e0ca                	sd	s2,64(sp)
    487a:	fc4e                	sd	s3,56(sp)
    487c:	f852                	sd	s4,48(sp)
    487e:	f456                	sd	s5,40(sp)
    4880:	f05a                	sd	s6,32(sp)
    4882:	ec5e                	sd	s7,24(sp)
    4884:	1080                	add	s0,sp,96
    4886:	8baa                	mv	s7,a0
    4888:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    488a:	892a                	mv	s2,a0
    488c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    488e:	4aa9                	li	s5,10
    4890:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4892:	89a6                	mv	s3,s1
    4894:	2485                	addw	s1,s1,1
    4896:	0344d663          	bge	s1,s4,48c2 <gets+0x52>
    cc = read(0, &c, 1);
    489a:	4605                	li	a2,1
    489c:	faf40593          	add	a1,s0,-81
    48a0:	4501                	li	a0,0
    48a2:	186000ef          	jal	4a28 <read>
    if(cc < 1)
    48a6:	00a05e63          	blez	a0,48c2 <gets+0x52>
    buf[i++] = c;
    48aa:	faf44783          	lbu	a5,-81(s0)
    48ae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    48b2:	01578763          	beq	a5,s5,48c0 <gets+0x50>
    48b6:	0905                	add	s2,s2,1
    48b8:	fd679de3          	bne	a5,s6,4892 <gets+0x22>
  for(i=0; i+1 < max; ){
    48bc:	89a6                	mv	s3,s1
    48be:	a011                	j	48c2 <gets+0x52>
    48c0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    48c2:	99de                	add	s3,s3,s7
    48c4:	00098023          	sb	zero,0(s3)
  return buf;
}
    48c8:	855e                	mv	a0,s7
    48ca:	60e6                	ld	ra,88(sp)
    48cc:	6446                	ld	s0,80(sp)
    48ce:	64a6                	ld	s1,72(sp)
    48d0:	6906                	ld	s2,64(sp)
    48d2:	79e2                	ld	s3,56(sp)
    48d4:	7a42                	ld	s4,48(sp)
    48d6:	7aa2                	ld	s5,40(sp)
    48d8:	7b02                	ld	s6,32(sp)
    48da:	6be2                	ld	s7,24(sp)
    48dc:	6125                	add	sp,sp,96
    48de:	8082                	ret

00000000000048e0 <stat>:

int
stat(const char *n, struct stat *st)
{
    48e0:	1101                	add	sp,sp,-32
    48e2:	ec06                	sd	ra,24(sp)
    48e4:	e822                	sd	s0,16(sp)
    48e6:	e426                	sd	s1,8(sp)
    48e8:	e04a                	sd	s2,0(sp)
    48ea:	1000                	add	s0,sp,32
    48ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    48ee:	4581                	li	a1,0
    48f0:	160000ef          	jal	4a50 <open>
  if(fd < 0)
    48f4:	02054163          	bltz	a0,4916 <stat+0x36>
    48f8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    48fa:	85ca                	mv	a1,s2
    48fc:	16c000ef          	jal	4a68 <fstat>
    4900:	892a                	mv	s2,a0
  close(fd);
    4902:	8526                	mv	a0,s1
    4904:	134000ef          	jal	4a38 <close>
  return r;
}
    4908:	854a                	mv	a0,s2
    490a:	60e2                	ld	ra,24(sp)
    490c:	6442                	ld	s0,16(sp)
    490e:	64a2                	ld	s1,8(sp)
    4910:	6902                	ld	s2,0(sp)
    4912:	6105                	add	sp,sp,32
    4914:	8082                	ret
    return -1;
    4916:	597d                	li	s2,-1
    4918:	bfc5                	j	4908 <stat+0x28>

000000000000491a <atoi>:

int
atoi(const char *s)
{
    491a:	1141                	add	sp,sp,-16
    491c:	e422                	sd	s0,8(sp)
    491e:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4920:	00054683          	lbu	a3,0(a0)
    4924:	fd06879b          	addw	a5,a3,-48
    4928:	0ff7f793          	zext.b	a5,a5
    492c:	4625                	li	a2,9
    492e:	02f66863          	bltu	a2,a5,495e <atoi+0x44>
    4932:	872a                	mv	a4,a0
  n = 0;
    4934:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4936:	0705                	add	a4,a4,1
    4938:	0025179b          	sllw	a5,a0,0x2
    493c:	9fa9                	addw	a5,a5,a0
    493e:	0017979b          	sllw	a5,a5,0x1
    4942:	9fb5                	addw	a5,a5,a3
    4944:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4948:	00074683          	lbu	a3,0(a4)
    494c:	fd06879b          	addw	a5,a3,-48
    4950:	0ff7f793          	zext.b	a5,a5
    4954:	fef671e3          	bgeu	a2,a5,4936 <atoi+0x1c>
  return n;
}
    4958:	6422                	ld	s0,8(sp)
    495a:	0141                	add	sp,sp,16
    495c:	8082                	ret
  n = 0;
    495e:	4501                	li	a0,0
    4960:	bfe5                	j	4958 <atoi+0x3e>

0000000000004962 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4962:	1141                	add	sp,sp,-16
    4964:	e422                	sd	s0,8(sp)
    4966:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4968:	02b57463          	bgeu	a0,a1,4990 <memmove+0x2e>
    while(n-- > 0)
    496c:	00c05f63          	blez	a2,498a <memmove+0x28>
    4970:	1602                	sll	a2,a2,0x20
    4972:	9201                	srl	a2,a2,0x20
    4974:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4978:	872a                	mv	a4,a0
      *dst++ = *src++;
    497a:	0585                	add	a1,a1,1
    497c:	0705                	add	a4,a4,1
    497e:	fff5c683          	lbu	a3,-1(a1)
    4982:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4986:	fee79ae3          	bne	a5,a4,497a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    498a:	6422                	ld	s0,8(sp)
    498c:	0141                	add	sp,sp,16
    498e:	8082                	ret
    dst += n;
    4990:	00c50733          	add	a4,a0,a2
    src += n;
    4994:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4996:	fec05ae3          	blez	a2,498a <memmove+0x28>
    499a:	fff6079b          	addw	a5,a2,-1 # 2fff <subdir+0x471>
    499e:	1782                	sll	a5,a5,0x20
    49a0:	9381                	srl	a5,a5,0x20
    49a2:	fff7c793          	not	a5,a5
    49a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    49a8:	15fd                	add	a1,a1,-1
    49aa:	177d                	add	a4,a4,-1
    49ac:	0005c683          	lbu	a3,0(a1)
    49b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    49b4:	fee79ae3          	bne	a5,a4,49a8 <memmove+0x46>
    49b8:	bfc9                	j	498a <memmove+0x28>

00000000000049ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    49ba:	1141                	add	sp,sp,-16
    49bc:	e422                	sd	s0,8(sp)
    49be:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    49c0:	ca05                	beqz	a2,49f0 <memcmp+0x36>
    49c2:	fff6069b          	addw	a3,a2,-1
    49c6:	1682                	sll	a3,a3,0x20
    49c8:	9281                	srl	a3,a3,0x20
    49ca:	0685                	add	a3,a3,1
    49cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    49ce:	00054783          	lbu	a5,0(a0)
    49d2:	0005c703          	lbu	a4,0(a1)
    49d6:	00e79863          	bne	a5,a4,49e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    49da:	0505                	add	a0,a0,1
    p2++;
    49dc:	0585                	add	a1,a1,1
  while (n-- > 0) {
    49de:	fed518e3          	bne	a0,a3,49ce <memcmp+0x14>
  }
  return 0;
    49e2:	4501                	li	a0,0
    49e4:	a019                	j	49ea <memcmp+0x30>
      return *p1 - *p2;
    49e6:	40e7853b          	subw	a0,a5,a4
}
    49ea:	6422                	ld	s0,8(sp)
    49ec:	0141                	add	sp,sp,16
    49ee:	8082                	ret
  return 0;
    49f0:	4501                	li	a0,0
    49f2:	bfe5                	j	49ea <memcmp+0x30>

00000000000049f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    49f4:	1141                	add	sp,sp,-16
    49f6:	e406                	sd	ra,8(sp)
    49f8:	e022                	sd	s0,0(sp)
    49fa:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    49fc:	f67ff0ef          	jal	4962 <memmove>
}
    4a00:	60a2                	ld	ra,8(sp)
    4a02:	6402                	ld	s0,0(sp)
    4a04:	0141                	add	sp,sp,16
    4a06:	8082                	ret

0000000000004a08 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4a08:	4885                	li	a7,1
 ecall
    4a0a:	00000073          	ecall
 ret
    4a0e:	8082                	ret

0000000000004a10 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4a10:	4889                	li	a7,2
 ecall
    4a12:	00000073          	ecall
 ret
    4a16:	8082                	ret

0000000000004a18 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4a18:	488d                	li	a7,3
 ecall
    4a1a:	00000073          	ecall
 ret
    4a1e:	8082                	ret

0000000000004a20 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4a20:	4891                	li	a7,4
 ecall
    4a22:	00000073          	ecall
 ret
    4a26:	8082                	ret

0000000000004a28 <read>:
.global read
read:
 li a7, SYS_read
    4a28:	4895                	li	a7,5
 ecall
    4a2a:	00000073          	ecall
 ret
    4a2e:	8082                	ret

0000000000004a30 <write>:
.global write
write:
 li a7, SYS_write
    4a30:	48c1                	li	a7,16
 ecall
    4a32:	00000073          	ecall
 ret
    4a36:	8082                	ret

0000000000004a38 <close>:
.global close
close:
 li a7, SYS_close
    4a38:	48d5                	li	a7,21
 ecall
    4a3a:	00000073          	ecall
 ret
    4a3e:	8082                	ret

0000000000004a40 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4a40:	4899                	li	a7,6
 ecall
    4a42:	00000073          	ecall
 ret
    4a46:	8082                	ret

0000000000004a48 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4a48:	489d                	li	a7,7
 ecall
    4a4a:	00000073          	ecall
 ret
    4a4e:	8082                	ret

0000000000004a50 <open>:
.global open
open:
 li a7, SYS_open
    4a50:	48bd                	li	a7,15
 ecall
    4a52:	00000073          	ecall
 ret
    4a56:	8082                	ret

0000000000004a58 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4a58:	48c5                	li	a7,17
 ecall
    4a5a:	00000073          	ecall
 ret
    4a5e:	8082                	ret

0000000000004a60 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4a60:	48c9                	li	a7,18
 ecall
    4a62:	00000073          	ecall
 ret
    4a66:	8082                	ret

0000000000004a68 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4a68:	48a1                	li	a7,8
 ecall
    4a6a:	00000073          	ecall
 ret
    4a6e:	8082                	ret

0000000000004a70 <link>:
.global link
link:
 li a7, SYS_link
    4a70:	48cd                	li	a7,19
 ecall
    4a72:	00000073          	ecall
 ret
    4a76:	8082                	ret

0000000000004a78 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4a78:	48d1                	li	a7,20
 ecall
    4a7a:	00000073          	ecall
 ret
    4a7e:	8082                	ret

0000000000004a80 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4a80:	48a5                	li	a7,9
 ecall
    4a82:	00000073          	ecall
 ret
    4a86:	8082                	ret

0000000000004a88 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4a88:	48a9                	li	a7,10
 ecall
    4a8a:	00000073          	ecall
 ret
    4a8e:	8082                	ret

0000000000004a90 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4a90:	48ad                	li	a7,11
 ecall
    4a92:	00000073          	ecall
 ret
    4a96:	8082                	ret

0000000000004a98 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4a98:	48b1                	li	a7,12
 ecall
    4a9a:	00000073          	ecall
 ret
    4a9e:	8082                	ret

0000000000004aa0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4aa0:	48b5                	li	a7,13
 ecall
    4aa2:	00000073          	ecall
 ret
    4aa6:	8082                	ret

0000000000004aa8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4aa8:	48b9                	li	a7,14
 ecall
    4aaa:	00000073          	ecall
 ret
    4aae:	8082                	ret

0000000000004ab0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4ab0:	1101                	add	sp,sp,-32
    4ab2:	ec06                	sd	ra,24(sp)
    4ab4:	e822                	sd	s0,16(sp)
    4ab6:	1000                	add	s0,sp,32
    4ab8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4abc:	4605                	li	a2,1
    4abe:	fef40593          	add	a1,s0,-17
    4ac2:	f6fff0ef          	jal	4a30 <write>
}
    4ac6:	60e2                	ld	ra,24(sp)
    4ac8:	6442                	ld	s0,16(sp)
    4aca:	6105                	add	sp,sp,32
    4acc:	8082                	ret

0000000000004ace <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4ace:	7139                	add	sp,sp,-64
    4ad0:	fc06                	sd	ra,56(sp)
    4ad2:	f822                	sd	s0,48(sp)
    4ad4:	f426                	sd	s1,40(sp)
    4ad6:	f04a                	sd	s2,32(sp)
    4ad8:	ec4e                	sd	s3,24(sp)
    4ada:	0080                	add	s0,sp,64
    4adc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4ade:	c299                	beqz	a3,4ae4 <printint+0x16>
    4ae0:	0805c763          	bltz	a1,4b6e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4ae4:	2581                	sext.w	a1,a1
  neg = 0;
    4ae6:	4881                	li	a7,0
    4ae8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    4aec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4aee:	2601                	sext.w	a2,a2
    4af0:	00003517          	auipc	a0,0x3
    4af4:	8e050513          	add	a0,a0,-1824 # 73d0 <digits>
    4af8:	883a                	mv	a6,a4
    4afa:	2705                	addw	a4,a4,1
    4afc:	02c5f7bb          	remuw	a5,a1,a2
    4b00:	1782                	sll	a5,a5,0x20
    4b02:	9381                	srl	a5,a5,0x20
    4b04:	97aa                	add	a5,a5,a0
    4b06:	0007c783          	lbu	a5,0(a5)
    4b0a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4b0e:	0005879b          	sext.w	a5,a1
    4b12:	02c5d5bb          	divuw	a1,a1,a2
    4b16:	0685                	add	a3,a3,1
    4b18:	fec7f0e3          	bgeu	a5,a2,4af8 <printint+0x2a>
  if(neg)
    4b1c:	00088c63          	beqz	a7,4b34 <printint+0x66>
    buf[i++] = '-';
    4b20:	fd070793          	add	a5,a4,-48
    4b24:	00878733          	add	a4,a5,s0
    4b28:	02d00793          	li	a5,45
    4b2c:	fef70823          	sb	a5,-16(a4)
    4b30:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    4b34:	02e05663          	blez	a4,4b60 <printint+0x92>
    4b38:	fc040793          	add	a5,s0,-64
    4b3c:	00e78933          	add	s2,a5,a4
    4b40:	fff78993          	add	s3,a5,-1
    4b44:	99ba                	add	s3,s3,a4
    4b46:	377d                	addw	a4,a4,-1
    4b48:	1702                	sll	a4,a4,0x20
    4b4a:	9301                	srl	a4,a4,0x20
    4b4c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4b50:	fff94583          	lbu	a1,-1(s2)
    4b54:	8526                	mv	a0,s1
    4b56:	f5bff0ef          	jal	4ab0 <putc>
  while(--i >= 0)
    4b5a:	197d                	add	s2,s2,-1
    4b5c:	ff391ae3          	bne	s2,s3,4b50 <printint+0x82>
}
    4b60:	70e2                	ld	ra,56(sp)
    4b62:	7442                	ld	s0,48(sp)
    4b64:	74a2                	ld	s1,40(sp)
    4b66:	7902                	ld	s2,32(sp)
    4b68:	69e2                	ld	s3,24(sp)
    4b6a:	6121                	add	sp,sp,64
    4b6c:	8082                	ret
    x = -xx;
    4b6e:	40b005bb          	negw	a1,a1
    neg = 1;
    4b72:	4885                	li	a7,1
    x = -xx;
    4b74:	bf95                	j	4ae8 <printint+0x1a>

0000000000004b76 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4b76:	711d                	add	sp,sp,-96
    4b78:	ec86                	sd	ra,88(sp)
    4b7a:	e8a2                	sd	s0,80(sp)
    4b7c:	e4a6                	sd	s1,72(sp)
    4b7e:	e0ca                	sd	s2,64(sp)
    4b80:	fc4e                	sd	s3,56(sp)
    4b82:	f852                	sd	s4,48(sp)
    4b84:	f456                	sd	s5,40(sp)
    4b86:	f05a                	sd	s6,32(sp)
    4b88:	ec5e                	sd	s7,24(sp)
    4b8a:	e862                	sd	s8,16(sp)
    4b8c:	e466                	sd	s9,8(sp)
    4b8e:	e06a                	sd	s10,0(sp)
    4b90:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4b92:	0005c903          	lbu	s2,0(a1)
    4b96:	24090763          	beqz	s2,4de4 <vprintf+0x26e>
    4b9a:	8b2a                	mv	s6,a0
    4b9c:	8a2e                	mv	s4,a1
    4b9e:	8bb2                	mv	s7,a2
  state = 0;
    4ba0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4ba2:	4481                	li	s1,0
    4ba4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4ba6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4baa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4bae:	06c00c93          	li	s9,108
    4bb2:	a005                	j	4bd2 <vprintf+0x5c>
        putc(fd, c0);
    4bb4:	85ca                	mv	a1,s2
    4bb6:	855a                	mv	a0,s6
    4bb8:	ef9ff0ef          	jal	4ab0 <putc>
    4bbc:	a019                	j	4bc2 <vprintf+0x4c>
    } else if(state == '%'){
    4bbe:	03598263          	beq	s3,s5,4be2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
    4bc2:	2485                	addw	s1,s1,1
    4bc4:	8726                	mv	a4,s1
    4bc6:	009a07b3          	add	a5,s4,s1
    4bca:	0007c903          	lbu	s2,0(a5)
    4bce:	20090b63          	beqz	s2,4de4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    4bd2:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4bd6:	fe0994e3          	bnez	s3,4bbe <vprintf+0x48>
      if(c0 == '%'){
    4bda:	fd579de3          	bne	a5,s5,4bb4 <vprintf+0x3e>
        state = '%';
    4bde:	89be                	mv	s3,a5
    4be0:	b7cd                	j	4bc2 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
    4be2:	c7c9                	beqz	a5,4c6c <vprintf+0xf6>
    4be4:	00ea06b3          	add	a3,s4,a4
    4be8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4bec:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4bee:	c681                	beqz	a3,4bf6 <vprintf+0x80>
    4bf0:	9752                	add	a4,a4,s4
    4bf2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4bf6:	03878f63          	beq	a5,s8,4c34 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
    4bfa:	05978963          	beq	a5,s9,4c4c <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4bfe:	07500713          	li	a4,117
    4c02:	0ee78363          	beq	a5,a4,4ce8 <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4c06:	07800713          	li	a4,120
    4c0a:	12e78563          	beq	a5,a4,4d34 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4c0e:	07000713          	li	a4,112
    4c12:	14e78a63          	beq	a5,a4,4d66 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4c16:	07300713          	li	a4,115
    4c1a:	18e78863          	beq	a5,a4,4daa <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4c1e:	02500713          	li	a4,37
    4c22:	04e79563          	bne	a5,a4,4c6c <vprintf+0xf6>
        putc(fd, '%');
    4c26:	02500593          	li	a1,37
    4c2a:	855a                	mv	a0,s6
    4c2c:	e85ff0ef          	jal	4ab0 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4c30:	4981                	li	s3,0
    4c32:	bf41                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
    4c34:	008b8913          	add	s2,s7,8
    4c38:	4685                	li	a3,1
    4c3a:	4629                	li	a2,10
    4c3c:	000ba583          	lw	a1,0(s7)
    4c40:	855a                	mv	a0,s6
    4c42:	e8dff0ef          	jal	4ace <printint>
    4c46:	8bca                	mv	s7,s2
      state = 0;
    4c48:	4981                	li	s3,0
    4c4a:	bfa5                	j	4bc2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
    4c4c:	06400793          	li	a5,100
    4c50:	02f68963          	beq	a3,a5,4c82 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4c54:	06c00793          	li	a5,108
    4c58:	04f68263          	beq	a3,a5,4c9c <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
    4c5c:	07500793          	li	a5,117
    4c60:	0af68063          	beq	a3,a5,4d00 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
    4c64:	07800793          	li	a5,120
    4c68:	0ef68263          	beq	a3,a5,4d4c <vprintf+0x1d6>
        putc(fd, '%');
    4c6c:	02500593          	li	a1,37
    4c70:	855a                	mv	a0,s6
    4c72:	e3fff0ef          	jal	4ab0 <putc>
        putc(fd, c0);
    4c76:	85ca                	mv	a1,s2
    4c78:	855a                	mv	a0,s6
    4c7a:	e37ff0ef          	jal	4ab0 <putc>
      state = 0;
    4c7e:	4981                	li	s3,0
    4c80:	b789                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4c82:	008b8913          	add	s2,s7,8
    4c86:	4685                	li	a3,1
    4c88:	4629                	li	a2,10
    4c8a:	000ba583          	lw	a1,0(s7)
    4c8e:	855a                	mv	a0,s6
    4c90:	e3fff0ef          	jal	4ace <printint>
        i += 1;
    4c94:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4c96:	8bca                	mv	s7,s2
      state = 0;
    4c98:	4981                	li	s3,0
        i += 1;
    4c9a:	b725                	j	4bc2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4c9c:	06400793          	li	a5,100
    4ca0:	02f60763          	beq	a2,a5,4cce <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4ca4:	07500793          	li	a5,117
    4ca8:	06f60963          	beq	a2,a5,4d1a <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4cac:	07800793          	li	a5,120
    4cb0:	faf61ee3          	bne	a2,a5,4c6c <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4cb4:	008b8913          	add	s2,s7,8
    4cb8:	4681                	li	a3,0
    4cba:	4641                	li	a2,16
    4cbc:	000ba583          	lw	a1,0(s7)
    4cc0:	855a                	mv	a0,s6
    4cc2:	e0dff0ef          	jal	4ace <printint>
        i += 2;
    4cc6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4cc8:	8bca                	mv	s7,s2
      state = 0;
    4cca:	4981                	li	s3,0
        i += 2;
    4ccc:	bddd                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cce:	008b8913          	add	s2,s7,8
    4cd2:	4685                	li	a3,1
    4cd4:	4629                	li	a2,10
    4cd6:	000ba583          	lw	a1,0(s7)
    4cda:	855a                	mv	a0,s6
    4cdc:	df3ff0ef          	jal	4ace <printint>
        i += 2;
    4ce0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4ce2:	8bca                	mv	s7,s2
      state = 0;
    4ce4:	4981                	li	s3,0
        i += 2;
    4ce6:	bdf1                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
    4ce8:	008b8913          	add	s2,s7,8
    4cec:	4681                	li	a3,0
    4cee:	4629                	li	a2,10
    4cf0:	000ba583          	lw	a1,0(s7)
    4cf4:	855a                	mv	a0,s6
    4cf6:	dd9ff0ef          	jal	4ace <printint>
    4cfa:	8bca                	mv	s7,s2
      state = 0;
    4cfc:	4981                	li	s3,0
    4cfe:	b5d1                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d00:	008b8913          	add	s2,s7,8
    4d04:	4681                	li	a3,0
    4d06:	4629                	li	a2,10
    4d08:	000ba583          	lw	a1,0(s7)
    4d0c:	855a                	mv	a0,s6
    4d0e:	dc1ff0ef          	jal	4ace <printint>
        i += 1;
    4d12:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d14:	8bca                	mv	s7,s2
      state = 0;
    4d16:	4981                	li	s3,0
        i += 1;
    4d18:	b56d                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d1a:	008b8913          	add	s2,s7,8
    4d1e:	4681                	li	a3,0
    4d20:	4629                	li	a2,10
    4d22:	000ba583          	lw	a1,0(s7)
    4d26:	855a                	mv	a0,s6
    4d28:	da7ff0ef          	jal	4ace <printint>
        i += 2;
    4d2c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d2e:	8bca                	mv	s7,s2
      state = 0;
    4d30:	4981                	li	s3,0
        i += 2;
    4d32:	bd41                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
    4d34:	008b8913          	add	s2,s7,8
    4d38:	4681                	li	a3,0
    4d3a:	4641                	li	a2,16
    4d3c:	000ba583          	lw	a1,0(s7)
    4d40:	855a                	mv	a0,s6
    4d42:	d8dff0ef          	jal	4ace <printint>
    4d46:	8bca                	mv	s7,s2
      state = 0;
    4d48:	4981                	li	s3,0
    4d4a:	bda5                	j	4bc2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d4c:	008b8913          	add	s2,s7,8
    4d50:	4681                	li	a3,0
    4d52:	4641                	li	a2,16
    4d54:	000ba583          	lw	a1,0(s7)
    4d58:	855a                	mv	a0,s6
    4d5a:	d75ff0ef          	jal	4ace <printint>
        i += 1;
    4d5e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d60:	8bca                	mv	s7,s2
      state = 0;
    4d62:	4981                	li	s3,0
        i += 1;
    4d64:	bdb9                	j	4bc2 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
    4d66:	008b8d13          	add	s10,s7,8
    4d6a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4d6e:	03000593          	li	a1,48
    4d72:	855a                	mv	a0,s6
    4d74:	d3dff0ef          	jal	4ab0 <putc>
  putc(fd, 'x');
    4d78:	07800593          	li	a1,120
    4d7c:	855a                	mv	a0,s6
    4d7e:	d33ff0ef          	jal	4ab0 <putc>
    4d82:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4d84:	00002b97          	auipc	s7,0x2
    4d88:	64cb8b93          	add	s7,s7,1612 # 73d0 <digits>
    4d8c:	03c9d793          	srl	a5,s3,0x3c
    4d90:	97de                	add	a5,a5,s7
    4d92:	0007c583          	lbu	a1,0(a5)
    4d96:	855a                	mv	a0,s6
    4d98:	d19ff0ef          	jal	4ab0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4d9c:	0992                	sll	s3,s3,0x4
    4d9e:	397d                	addw	s2,s2,-1
    4da0:	fe0916e3          	bnez	s2,4d8c <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
    4da4:	8bea                	mv	s7,s10
      state = 0;
    4da6:	4981                	li	s3,0
    4da8:	bd29                	j	4bc2 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
    4daa:	008b8993          	add	s3,s7,8
    4dae:	000bb903          	ld	s2,0(s7)
    4db2:	00090f63          	beqz	s2,4dd0 <vprintf+0x25a>
        for(; *s; s++)
    4db6:	00094583          	lbu	a1,0(s2)
    4dba:	c195                	beqz	a1,4dde <vprintf+0x268>
          putc(fd, *s);
    4dbc:	855a                	mv	a0,s6
    4dbe:	cf3ff0ef          	jal	4ab0 <putc>
        for(; *s; s++)
    4dc2:	0905                	add	s2,s2,1
    4dc4:	00094583          	lbu	a1,0(s2)
    4dc8:	f9f5                	bnez	a1,4dbc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4dca:	8bce                	mv	s7,s3
      state = 0;
    4dcc:	4981                	li	s3,0
    4dce:	bbd5                	j	4bc2 <vprintf+0x4c>
          s = "(null)";
    4dd0:	00002917          	auipc	s2,0x2
    4dd4:	5f890913          	add	s2,s2,1528 # 73c8 <malloc+0x24ea>
        for(; *s; s++)
    4dd8:	02800593          	li	a1,40
    4ddc:	b7c5                	j	4dbc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4dde:	8bce                	mv	s7,s3
      state = 0;
    4de0:	4981                	li	s3,0
    4de2:	b3c5                	j	4bc2 <vprintf+0x4c>
    }
  }
}
    4de4:	60e6                	ld	ra,88(sp)
    4de6:	6446                	ld	s0,80(sp)
    4de8:	64a6                	ld	s1,72(sp)
    4dea:	6906                	ld	s2,64(sp)
    4dec:	79e2                	ld	s3,56(sp)
    4dee:	7a42                	ld	s4,48(sp)
    4df0:	7aa2                	ld	s5,40(sp)
    4df2:	7b02                	ld	s6,32(sp)
    4df4:	6be2                	ld	s7,24(sp)
    4df6:	6c42                	ld	s8,16(sp)
    4df8:	6ca2                	ld	s9,8(sp)
    4dfa:	6d02                	ld	s10,0(sp)
    4dfc:	6125                	add	sp,sp,96
    4dfe:	8082                	ret

0000000000004e00 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4e00:	715d                	add	sp,sp,-80
    4e02:	ec06                	sd	ra,24(sp)
    4e04:	e822                	sd	s0,16(sp)
    4e06:	1000                	add	s0,sp,32
    4e08:	e010                	sd	a2,0(s0)
    4e0a:	e414                	sd	a3,8(s0)
    4e0c:	e818                	sd	a4,16(s0)
    4e0e:	ec1c                	sd	a5,24(s0)
    4e10:	03043023          	sd	a6,32(s0)
    4e14:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4e18:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4e1c:	8622                	mv	a2,s0
    4e1e:	d59ff0ef          	jal	4b76 <vprintf>
}
    4e22:	60e2                	ld	ra,24(sp)
    4e24:	6442                	ld	s0,16(sp)
    4e26:	6161                	add	sp,sp,80
    4e28:	8082                	ret

0000000000004e2a <printf>:

void
printf(const char *fmt, ...)
{
    4e2a:	711d                	add	sp,sp,-96
    4e2c:	ec06                	sd	ra,24(sp)
    4e2e:	e822                	sd	s0,16(sp)
    4e30:	1000                	add	s0,sp,32
    4e32:	e40c                	sd	a1,8(s0)
    4e34:	e810                	sd	a2,16(s0)
    4e36:	ec14                	sd	a3,24(s0)
    4e38:	f018                	sd	a4,32(s0)
    4e3a:	f41c                	sd	a5,40(s0)
    4e3c:	03043823          	sd	a6,48(s0)
    4e40:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4e44:	00840613          	add	a2,s0,8
    4e48:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4e4c:	85aa                	mv	a1,a0
    4e4e:	4505                	li	a0,1
    4e50:	d27ff0ef          	jal	4b76 <vprintf>
}
    4e54:	60e2                	ld	ra,24(sp)
    4e56:	6442                	ld	s0,16(sp)
    4e58:	6125                	add	sp,sp,96
    4e5a:	8082                	ret

0000000000004e5c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4e5c:	1141                	add	sp,sp,-16
    4e5e:	e422                	sd	s0,8(sp)
    4e60:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4e62:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4e66:	00003797          	auipc	a5,0x3
    4e6a:	5ea7b783          	ld	a5,1514(a5) # 8450 <freep>
    4e6e:	a02d                	j	4e98 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4e70:	4618                	lw	a4,8(a2)
    4e72:	9f2d                	addw	a4,a4,a1
    4e74:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4e78:	6398                	ld	a4,0(a5)
    4e7a:	6310                	ld	a2,0(a4)
    4e7c:	a83d                	j	4eba <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4e7e:	ff852703          	lw	a4,-8(a0)
    4e82:	9f31                	addw	a4,a4,a2
    4e84:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    4e86:	ff053683          	ld	a3,-16(a0)
    4e8a:	a091                	j	4ece <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4e8c:	6398                	ld	a4,0(a5)
    4e8e:	00e7e463          	bltu	a5,a4,4e96 <free+0x3a>
    4e92:	00e6ea63          	bltu	a3,a4,4ea6 <free+0x4a>
{
    4e96:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4e98:	fed7fae3          	bgeu	a5,a3,4e8c <free+0x30>
    4e9c:	6398                	ld	a4,0(a5)
    4e9e:	00e6e463          	bltu	a3,a4,4ea6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4ea2:	fee7eae3          	bltu	a5,a4,4e96 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    4ea6:	ff852583          	lw	a1,-8(a0)
    4eaa:	6390                	ld	a2,0(a5)
    4eac:	02059813          	sll	a6,a1,0x20
    4eb0:	01c85713          	srl	a4,a6,0x1c
    4eb4:	9736                	add	a4,a4,a3
    4eb6:	fae60de3          	beq	a2,a4,4e70 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    4eba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4ebe:	4790                	lw	a2,8(a5)
    4ec0:	02061593          	sll	a1,a2,0x20
    4ec4:	01c5d713          	srl	a4,a1,0x1c
    4ec8:	973e                	add	a4,a4,a5
    4eca:	fae68ae3          	beq	a3,a4,4e7e <free+0x22>
    p->s.ptr = bp->s.ptr;
    4ece:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    4ed0:	00003717          	auipc	a4,0x3
    4ed4:	58f73023          	sd	a5,1408(a4) # 8450 <freep>
}
    4ed8:	6422                	ld	s0,8(sp)
    4eda:	0141                	add	sp,sp,16
    4edc:	8082                	ret

0000000000004ede <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4ede:	7139                	add	sp,sp,-64
    4ee0:	fc06                	sd	ra,56(sp)
    4ee2:	f822                	sd	s0,48(sp)
    4ee4:	f426                	sd	s1,40(sp)
    4ee6:	f04a                	sd	s2,32(sp)
    4ee8:	ec4e                	sd	s3,24(sp)
    4eea:	e852                	sd	s4,16(sp)
    4eec:	e456                	sd	s5,8(sp)
    4eee:	e05a                	sd	s6,0(sp)
    4ef0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4ef2:	02051493          	sll	s1,a0,0x20
    4ef6:	9081                	srl	s1,s1,0x20
    4ef8:	04bd                	add	s1,s1,15
    4efa:	8091                	srl	s1,s1,0x4
    4efc:	0014899b          	addw	s3,s1,1
    4f00:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    4f02:	00003517          	auipc	a0,0x3
    4f06:	54e53503          	ld	a0,1358(a0) # 8450 <freep>
    4f0a:	c515                	beqz	a0,4f36 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4f0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4f0e:	4798                	lw	a4,8(a5)
    4f10:	02977f63          	bgeu	a4,s1,4f4e <malloc+0x70>
  if(nu < 4096)
    4f14:	8a4e                	mv	s4,s3
    4f16:	0009871b          	sext.w	a4,s3
    4f1a:	6685                	lui	a3,0x1
    4f1c:	00d77363          	bgeu	a4,a3,4f22 <malloc+0x44>
    4f20:	6a05                	lui	s4,0x1
    4f22:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4f26:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4f2a:	00003917          	auipc	s2,0x3
    4f2e:	52690913          	add	s2,s2,1318 # 8450 <freep>
  if(p == (char*)-1)
    4f32:	5afd                	li	s5,-1
    4f34:	a885                	j	4fa4 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
    4f36:	0000a797          	auipc	a5,0xa
    4f3a:	d4278793          	add	a5,a5,-702 # ec78 <base>
    4f3e:	00003717          	auipc	a4,0x3
    4f42:	50f73923          	sd	a5,1298(a4) # 8450 <freep>
    4f46:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4f48:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4f4c:	b7e1                	j	4f14 <malloc+0x36>
      if(p->s.size == nunits)
    4f4e:	02e48c63          	beq	s1,a4,4f86 <malloc+0xa8>
        p->s.size -= nunits;
    4f52:	4137073b          	subw	a4,a4,s3
    4f56:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4f58:	02071693          	sll	a3,a4,0x20
    4f5c:	01c6d713          	srl	a4,a3,0x1c
    4f60:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4f62:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    4f66:	00003717          	auipc	a4,0x3
    4f6a:	4ea73523          	sd	a0,1258(a4) # 8450 <freep>
      return (void*)(p + 1);
    4f6e:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4f72:	70e2                	ld	ra,56(sp)
    4f74:	7442                	ld	s0,48(sp)
    4f76:	74a2                	ld	s1,40(sp)
    4f78:	7902                	ld	s2,32(sp)
    4f7a:	69e2                	ld	s3,24(sp)
    4f7c:	6a42                	ld	s4,16(sp)
    4f7e:	6aa2                	ld	s5,8(sp)
    4f80:	6b02                	ld	s6,0(sp)
    4f82:	6121                	add	sp,sp,64
    4f84:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4f86:	6398                	ld	a4,0(a5)
    4f88:	e118                	sd	a4,0(a0)
    4f8a:	bff1                	j	4f66 <malloc+0x88>
  hp->s.size = nu;
    4f8c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4f90:	0541                	add	a0,a0,16
    4f92:	ecbff0ef          	jal	4e5c <free>
  return freep;
    4f96:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4f9a:	dd61                	beqz	a0,4f72 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4f9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4f9e:	4798                	lw	a4,8(a5)
    4fa0:	fa9777e3          	bgeu	a4,s1,4f4e <malloc+0x70>
    if(p == freep)
    4fa4:	00093703          	ld	a4,0(s2)
    4fa8:	853e                	mv	a0,a5
    4faa:	fef719e3          	bne	a4,a5,4f9c <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
    4fae:	8552                	mv	a0,s4
    4fb0:	ae9ff0ef          	jal	4a98 <sbrk>
  if(p == (char*)-1)
    4fb4:	fd551ce3          	bne	a0,s5,4f8c <malloc+0xae>
        return 0;
    4fb8:	4501                	li	a0,0
    4fba:	bf65                	j	4f72 <malloc+0x94>
