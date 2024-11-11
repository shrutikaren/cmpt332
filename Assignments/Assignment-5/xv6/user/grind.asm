
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

/* from FreeBSD. */
int
do_rand(unsigned long *ctx)
{
       0:	1141                	add	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	add	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xor	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	add	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	add	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	add	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	add	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	add	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	add	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	add	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	add	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	add	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	add	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7119                	add	sp,sp,-128
      7a:	fc86                	sd	ra,120(sp)
      7c:	f8a2                	sd	s0,112(sp)
      7e:	f4a6                	sd	s1,104(sp)
      80:	f0ca                	sd	s2,96(sp)
      82:	ecce                	sd	s3,88(sp)
      84:	e8d2                	sd	s4,80(sp)
      86:	e4d6                	sd	s5,72(sp)
      88:	e0da                	sd	s6,64(sp)
      8a:	fc5e                	sd	s7,56(sp)
      8c:	0100                	add	s0,sp,128
      8e:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      90:	4501                	li	a0,0
      92:	00001097          	auipc	ra,0x1
      96:	e28080e7          	jalr	-472(ra) # eba <sbrk>
      9a:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9c:	00001517          	auipc	a0,0x1
      a0:	3a450513          	add	a0,a0,932 # 1440 <malloc+0xec>
      a4:	00001097          	auipc	ra,0x1
      a8:	df6080e7          	jalr	-522(ra) # e9a <mkdir>
  if(chdir("grindir") != 0){
      ac:	00001517          	auipc	a0,0x1
      b0:	39450513          	add	a0,a0,916 # 1440 <malloc+0xec>
      b4:	00001097          	auipc	ra,0x1
      b8:	dee080e7          	jalr	-530(ra) # ea2 <chdir>
      bc:	cd11                	beqz	a0,d8 <go+0x60>
    printf("grind: chdir grindir failed\n");
      be:	00001517          	auipc	a0,0x1
      c2:	38a50513          	add	a0,a0,906 # 1448 <malloc+0xf4>
      c6:	00001097          	auipc	ra,0x1
      ca:	1d6080e7          	jalr	470(ra) # 129c <printf>
    exit(1);
      ce:	4505                	li	a0,1
      d0:	00001097          	auipc	ra,0x1
      d4:	d62080e7          	jalr	-670(ra) # e32 <exit>
  }
  chdir("/");
      d8:	00001517          	auipc	a0,0x1
      dc:	39050513          	add	a0,a0,912 # 1468 <malloc+0x114>
      e0:	00001097          	auipc	ra,0x1
      e4:	dc2080e7          	jalr	-574(ra) # ea2 <chdir>
      e8:	00001997          	auipc	s3,0x1
      ec:	39098993          	add	s3,s3,912 # 1478 <malloc+0x124>
      f0:	c489                	beqz	s1,fa <go+0x82>
      f2:	00001997          	auipc	s3,0x1
      f6:	37e98993          	add	s3,s3,894 # 1470 <malloc+0x11c>
  uint64 iters = 0;
      fa:	4481                	li	s1,0
  int fd = -1;
      fc:	5a7d                	li	s4,-1
      fe:	00001917          	auipc	s2,0x1
     102:	62a90913          	add	s2,s2,1578 # 1728 <malloc+0x3d4>
     106:	a839                	j	124 <go+0xac>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     108:	20200593          	li	a1,514
     10c:	00001517          	auipc	a0,0x1
     110:	37450513          	add	a0,a0,884 # 1480 <malloc+0x12c>
     114:	00001097          	auipc	ra,0x1
     118:	d5e080e7          	jalr	-674(ra) # e72 <open>
     11c:	00001097          	auipc	ra,0x1
     120:	d3e080e7          	jalr	-706(ra) # e5a <close>
    iters++;
     124:	0485                	add	s1,s1,1
    if((iters % 500) == 0)
     126:	1f400793          	li	a5,500
     12a:	02f4f7b3          	remu	a5,s1,a5
     12e:	eb81                	bnez	a5,13e <go+0xc6>
      write(1, which_child?"B":"A", 1);
     130:	4605                	li	a2,1
     132:	85ce                	mv	a1,s3
     134:	4505                	li	a0,1
     136:	00001097          	auipc	ra,0x1
     13a:	d1c080e7          	jalr	-740(ra) # e52 <write>
    int what = rand() % 23;
     13e:	00000097          	auipc	ra,0x0
     142:	f1a080e7          	jalr	-230(ra) # 58 <rand>
     146:	47dd                	li	a5,23
     148:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14c:	4785                	li	a5,1
     14e:	faf50de3          	beq	a0,a5,108 <go+0x90>
    } else if(what == 2){
     152:	47d9                	li	a5,22
     154:	fca7e8e3          	bltu	a5,a0,124 <go+0xac>
     158:	050a                	sll	a0,a0,0x2
     15a:	954a                	add	a0,a0,s2
     15c:	411c                	lw	a5,0(a0)
     15e:	97ca                	add	a5,a5,s2
     160:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     162:	20200593          	li	a1,514
     166:	00001517          	auipc	a0,0x1
     16a:	32a50513          	add	a0,a0,810 # 1490 <malloc+0x13c>
     16e:	00001097          	auipc	ra,0x1
     172:	d04080e7          	jalr	-764(ra) # e72 <open>
     176:	00001097          	auipc	ra,0x1
     17a:	ce4080e7          	jalr	-796(ra) # e5a <close>
     17e:	b75d                	j	124 <go+0xac>
    } else if(what == 3){
      unlink("grindir/../a");
     180:	00001517          	auipc	a0,0x1
     184:	30050513          	add	a0,a0,768 # 1480 <malloc+0x12c>
     188:	00001097          	auipc	ra,0x1
     18c:	cfa080e7          	jalr	-774(ra) # e82 <unlink>
     190:	bf51                	j	124 <go+0xac>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     192:	00001517          	auipc	a0,0x1
     196:	2ae50513          	add	a0,a0,686 # 1440 <malloc+0xec>
     19a:	00001097          	auipc	ra,0x1
     19e:	d08080e7          	jalr	-760(ra) # ea2 <chdir>
     1a2:	e115                	bnez	a0,1c6 <go+0x14e>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1a4:	00001517          	auipc	a0,0x1
     1a8:	30450513          	add	a0,a0,772 # 14a8 <malloc+0x154>
     1ac:	00001097          	auipc	ra,0x1
     1b0:	cd6080e7          	jalr	-810(ra) # e82 <unlink>
      chdir("/");
     1b4:	00001517          	auipc	a0,0x1
     1b8:	2b450513          	add	a0,a0,692 # 1468 <malloc+0x114>
     1bc:	00001097          	auipc	ra,0x1
     1c0:	ce6080e7          	jalr	-794(ra) # ea2 <chdir>
     1c4:	b785                	j	124 <go+0xac>
        printf("grind: chdir grindir failed\n");
     1c6:	00001517          	auipc	a0,0x1
     1ca:	28250513          	add	a0,a0,642 # 1448 <malloc+0xf4>
     1ce:	00001097          	auipc	ra,0x1
     1d2:	0ce080e7          	jalr	206(ra) # 129c <printf>
        exit(1);
     1d6:	4505                	li	a0,1
     1d8:	00001097          	auipc	ra,0x1
     1dc:	c5a080e7          	jalr	-934(ra) # e32 <exit>
    } else if(what == 5){
      close(fd);
     1e0:	8552                	mv	a0,s4
     1e2:	00001097          	auipc	ra,0x1
     1e6:	c78080e7          	jalr	-904(ra) # e5a <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1ea:	20200593          	li	a1,514
     1ee:	00001517          	auipc	a0,0x1
     1f2:	2c250513          	add	a0,a0,706 # 14b0 <malloc+0x15c>
     1f6:	00001097          	auipc	ra,0x1
     1fa:	c7c080e7          	jalr	-900(ra) # e72 <open>
     1fe:	8a2a                	mv	s4,a0
     200:	b715                	j	124 <go+0xac>
    } else if(what == 6){
      close(fd);
     202:	8552                	mv	a0,s4
     204:	00001097          	auipc	ra,0x1
     208:	c56080e7          	jalr	-938(ra) # e5a <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     20c:	20200593          	li	a1,514
     210:	00001517          	auipc	a0,0x1
     214:	2b050513          	add	a0,a0,688 # 14c0 <malloc+0x16c>
     218:	00001097          	auipc	ra,0x1
     21c:	c5a080e7          	jalr	-934(ra) # e72 <open>
     220:	8a2a                	mv	s4,a0
     222:	b709                	j	124 <go+0xac>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     224:	3e700613          	li	a2,999
     228:	00002597          	auipc	a1,0x2
     22c:	df858593          	add	a1,a1,-520 # 2020 <buf.0>
     230:	8552                	mv	a0,s4
     232:	00001097          	auipc	ra,0x1
     236:	c20080e7          	jalr	-992(ra) # e52 <write>
     23a:	b5ed                	j	124 <go+0xac>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     23c:	3e700613          	li	a2,999
     240:	00002597          	auipc	a1,0x2
     244:	de058593          	add	a1,a1,-544 # 2020 <buf.0>
     248:	8552                	mv	a0,s4
     24a:	00001097          	auipc	ra,0x1
     24e:	c00080e7          	jalr	-1024(ra) # e4a <read>
     252:	bdc9                	j	124 <go+0xac>
    } else if(what == 9){
      mkdir("grindir/../a");
     254:	00001517          	auipc	a0,0x1
     258:	22c50513          	add	a0,a0,556 # 1480 <malloc+0x12c>
     25c:	00001097          	auipc	ra,0x1
     260:	c3e080e7          	jalr	-962(ra) # e9a <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     264:	20200593          	li	a1,514
     268:	00001517          	auipc	a0,0x1
     26c:	27050513          	add	a0,a0,624 # 14d8 <malloc+0x184>
     270:	00001097          	auipc	ra,0x1
     274:	c02080e7          	jalr	-1022(ra) # e72 <open>
     278:	00001097          	auipc	ra,0x1
     27c:	be2080e7          	jalr	-1054(ra) # e5a <close>
      unlink("a/a");
     280:	00001517          	auipc	a0,0x1
     284:	26850513          	add	a0,a0,616 # 14e8 <malloc+0x194>
     288:	00001097          	auipc	ra,0x1
     28c:	bfa080e7          	jalr	-1030(ra) # e82 <unlink>
     290:	bd51                	j	124 <go+0xac>
    } else if(what == 10){
      mkdir("/../b");
     292:	00001517          	auipc	a0,0x1
     296:	25e50513          	add	a0,a0,606 # 14f0 <malloc+0x19c>
     29a:	00001097          	auipc	ra,0x1
     29e:	c00080e7          	jalr	-1024(ra) # e9a <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2a2:	20200593          	li	a1,514
     2a6:	00001517          	auipc	a0,0x1
     2aa:	25250513          	add	a0,a0,594 # 14f8 <malloc+0x1a4>
     2ae:	00001097          	auipc	ra,0x1
     2b2:	bc4080e7          	jalr	-1084(ra) # e72 <open>
     2b6:	00001097          	auipc	ra,0x1
     2ba:	ba4080e7          	jalr	-1116(ra) # e5a <close>
      unlink("b/b");
     2be:	00001517          	auipc	a0,0x1
     2c2:	24a50513          	add	a0,a0,586 # 1508 <malloc+0x1b4>
     2c6:	00001097          	auipc	ra,0x1
     2ca:	bbc080e7          	jalr	-1092(ra) # e82 <unlink>
     2ce:	bd99                	j	124 <go+0xac>
    } else if(what == 11){
      unlink("b");
     2d0:	00001517          	auipc	a0,0x1
     2d4:	20050513          	add	a0,a0,512 # 14d0 <malloc+0x17c>
     2d8:	00001097          	auipc	ra,0x1
     2dc:	baa080e7          	jalr	-1110(ra) # e82 <unlink>
      link("../grindir/./../a", "../b");
     2e0:	00001597          	auipc	a1,0x1
     2e4:	1c858593          	add	a1,a1,456 # 14a8 <malloc+0x154>
     2e8:	00001517          	auipc	a0,0x1
     2ec:	22850513          	add	a0,a0,552 # 1510 <malloc+0x1bc>
     2f0:	00001097          	auipc	ra,0x1
     2f4:	ba2080e7          	jalr	-1118(ra) # e92 <link>
     2f8:	b535                	j	124 <go+0xac>
    } else if(what == 12){
      unlink("../grindir/../a");
     2fa:	00001517          	auipc	a0,0x1
     2fe:	22e50513          	add	a0,a0,558 # 1528 <malloc+0x1d4>
     302:	00001097          	auipc	ra,0x1
     306:	b80080e7          	jalr	-1152(ra) # e82 <unlink>
      link(".././b", "/grindir/../a");
     30a:	00001597          	auipc	a1,0x1
     30e:	1a658593          	add	a1,a1,422 # 14b0 <malloc+0x15c>
     312:	00001517          	auipc	a0,0x1
     316:	22650513          	add	a0,a0,550 # 1538 <malloc+0x1e4>
     31a:	00001097          	auipc	ra,0x1
     31e:	b78080e7          	jalr	-1160(ra) # e92 <link>
     322:	b509                	j	124 <go+0xac>
    } else if(what == 13){
      int pid = fork();
     324:	00001097          	auipc	ra,0x1
     328:	b06080e7          	jalr	-1274(ra) # e2a <fork>
      if(pid == 0){
     32c:	c909                	beqz	a0,33e <go+0x2c6>
        exit(0);
      } else if(pid < 0){
     32e:	00054c63          	bltz	a0,346 <go+0x2ce>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     332:	4501                	li	a0,0
     334:	00001097          	auipc	ra,0x1
     338:	b06080e7          	jalr	-1274(ra) # e3a <wait>
     33c:	b3e5                	j	124 <go+0xac>
        exit(0);
     33e:	00001097          	auipc	ra,0x1
     342:	af4080e7          	jalr	-1292(ra) # e32 <exit>
        printf("grind: fork failed\n");
     346:	00001517          	auipc	a0,0x1
     34a:	1fa50513          	add	a0,a0,506 # 1540 <malloc+0x1ec>
     34e:	00001097          	auipc	ra,0x1
     352:	f4e080e7          	jalr	-178(ra) # 129c <printf>
        exit(1);
     356:	4505                	li	a0,1
     358:	00001097          	auipc	ra,0x1
     35c:	ada080e7          	jalr	-1318(ra) # e32 <exit>
    } else if(what == 14){
      int pid = fork();
     360:	00001097          	auipc	ra,0x1
     364:	aca080e7          	jalr	-1334(ra) # e2a <fork>
      if(pid == 0){
     368:	c909                	beqz	a0,37a <go+0x302>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     36a:	02054563          	bltz	a0,394 <go+0x31c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36e:	4501                	li	a0,0
     370:	00001097          	auipc	ra,0x1
     374:	aca080e7          	jalr	-1334(ra) # e3a <wait>
     378:	b375                	j	124 <go+0xac>
        fork();
     37a:	00001097          	auipc	ra,0x1
     37e:	ab0080e7          	jalr	-1360(ra) # e2a <fork>
        fork();
     382:	00001097          	auipc	ra,0x1
     386:	aa8080e7          	jalr	-1368(ra) # e2a <fork>
        exit(0);
     38a:	4501                	li	a0,0
     38c:	00001097          	auipc	ra,0x1
     390:	aa6080e7          	jalr	-1370(ra) # e32 <exit>
        printf("grind: fork failed\n");
     394:	00001517          	auipc	a0,0x1
     398:	1ac50513          	add	a0,a0,428 # 1540 <malloc+0x1ec>
     39c:	00001097          	auipc	ra,0x1
     3a0:	f00080e7          	jalr	-256(ra) # 129c <printf>
        exit(1);
     3a4:	4505                	li	a0,1
     3a6:	00001097          	auipc	ra,0x1
     3aa:	a8c080e7          	jalr	-1396(ra) # e32 <exit>
    } else if(what == 15){
      sbrk(6011);
     3ae:	6505                	lui	a0,0x1
     3b0:	77b50513          	add	a0,a0,1915 # 177b <malloc+0x427>
     3b4:	00001097          	auipc	ra,0x1
     3b8:	b06080e7          	jalr	-1274(ra) # eba <sbrk>
     3bc:	b3a5                	j	124 <go+0xac>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3be:	4501                	li	a0,0
     3c0:	00001097          	auipc	ra,0x1
     3c4:	afa080e7          	jalr	-1286(ra) # eba <sbrk>
     3c8:	d4aafee3          	bgeu	s5,a0,124 <go+0xac>
        sbrk(-(sbrk(0) - break0));
     3cc:	4501                	li	a0,0
     3ce:	00001097          	auipc	ra,0x1
     3d2:	aec080e7          	jalr	-1300(ra) # eba <sbrk>
     3d6:	40aa853b          	subw	a0,s5,a0
     3da:	00001097          	auipc	ra,0x1
     3de:	ae0080e7          	jalr	-1312(ra) # eba <sbrk>
     3e2:	b389                	j	124 <go+0xac>
    } else if(what == 17){
      int pid = fork();
     3e4:	00001097          	auipc	ra,0x1
     3e8:	a46080e7          	jalr	-1466(ra) # e2a <fork>
     3ec:	8b2a                	mv	s6,a0
      if(pid == 0){
     3ee:	c51d                	beqz	a0,41c <go+0x3a4>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3f0:	04054963          	bltz	a0,442 <go+0x3ca>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f4:	00001517          	auipc	a0,0x1
     3f8:	16450513          	add	a0,a0,356 # 1558 <malloc+0x204>
     3fc:	00001097          	auipc	ra,0x1
     400:	aa6080e7          	jalr	-1370(ra) # ea2 <chdir>
     404:	ed21                	bnez	a0,45c <go+0x3e4>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     406:	855a                	mv	a0,s6
     408:	00001097          	auipc	ra,0x1
     40c:	a5a080e7          	jalr	-1446(ra) # e62 <kill>
      wait(0);
     410:	4501                	li	a0,0
     412:	00001097          	auipc	ra,0x1
     416:	a28080e7          	jalr	-1496(ra) # e3a <wait>
     41a:	b329                	j	124 <go+0xac>
        close(open("a", O_CREATE|O_RDWR));
     41c:	20200593          	li	a1,514
     420:	00001517          	auipc	a0,0x1
     424:	10050513          	add	a0,a0,256 # 1520 <malloc+0x1cc>
     428:	00001097          	auipc	ra,0x1
     42c:	a4a080e7          	jalr	-1462(ra) # e72 <open>
     430:	00001097          	auipc	ra,0x1
     434:	a2a080e7          	jalr	-1494(ra) # e5a <close>
        exit(0);
     438:	4501                	li	a0,0
     43a:	00001097          	auipc	ra,0x1
     43e:	9f8080e7          	jalr	-1544(ra) # e32 <exit>
        printf("grind: fork failed\n");
     442:	00001517          	auipc	a0,0x1
     446:	0fe50513          	add	a0,a0,254 # 1540 <malloc+0x1ec>
     44a:	00001097          	auipc	ra,0x1
     44e:	e52080e7          	jalr	-430(ra) # 129c <printf>
        exit(1);
     452:	4505                	li	a0,1
     454:	00001097          	auipc	ra,0x1
     458:	9de080e7          	jalr	-1570(ra) # e32 <exit>
        printf("grind: chdir failed\n");
     45c:	00001517          	auipc	a0,0x1
     460:	10c50513          	add	a0,a0,268 # 1568 <malloc+0x214>
     464:	00001097          	auipc	ra,0x1
     468:	e38080e7          	jalr	-456(ra) # 129c <printf>
        exit(1);
     46c:	4505                	li	a0,1
     46e:	00001097          	auipc	ra,0x1
     472:	9c4080e7          	jalr	-1596(ra) # e32 <exit>
    } else if(what == 18){
      int pid = fork();
     476:	00001097          	auipc	ra,0x1
     47a:	9b4080e7          	jalr	-1612(ra) # e2a <fork>
      if(pid == 0){
     47e:	c909                	beqz	a0,490 <go+0x418>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     480:	02054563          	bltz	a0,4aa <go+0x432>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     484:	4501                	li	a0,0
     486:	00001097          	auipc	ra,0x1
     48a:	9b4080e7          	jalr	-1612(ra) # e3a <wait>
     48e:	b959                	j	124 <go+0xac>
        kill(getpid());
     490:	00001097          	auipc	ra,0x1
     494:	a22080e7          	jalr	-1502(ra) # eb2 <getpid>
     498:	00001097          	auipc	ra,0x1
     49c:	9ca080e7          	jalr	-1590(ra) # e62 <kill>
        exit(0);
     4a0:	4501                	li	a0,0
     4a2:	00001097          	auipc	ra,0x1
     4a6:	990080e7          	jalr	-1648(ra) # e32 <exit>
        printf("grind: fork failed\n");
     4aa:	00001517          	auipc	a0,0x1
     4ae:	09650513          	add	a0,a0,150 # 1540 <malloc+0x1ec>
     4b2:	00001097          	auipc	ra,0x1
     4b6:	dea080e7          	jalr	-534(ra) # 129c <printf>
        exit(1);
     4ba:	4505                	li	a0,1
     4bc:	00001097          	auipc	ra,0x1
     4c0:	976080e7          	jalr	-1674(ra) # e32 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c4:	f9840513          	add	a0,s0,-104
     4c8:	00001097          	auipc	ra,0x1
     4cc:	97a080e7          	jalr	-1670(ra) # e42 <pipe>
     4d0:	02054b63          	bltz	a0,506 <go+0x48e>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d4:	00001097          	auipc	ra,0x1
     4d8:	956080e7          	jalr	-1706(ra) # e2a <fork>
      if(pid == 0){
     4dc:	c131                	beqz	a0,520 <go+0x4a8>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4de:	0a054a63          	bltz	a0,592 <go+0x51a>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4e2:	f9842503          	lw	a0,-104(s0)
     4e6:	00001097          	auipc	ra,0x1
     4ea:	974080e7          	jalr	-1676(ra) # e5a <close>
      close(fds[1]);
     4ee:	f9c42503          	lw	a0,-100(s0)
     4f2:	00001097          	auipc	ra,0x1
     4f6:	968080e7          	jalr	-1688(ra) # e5a <close>
      wait(0);
     4fa:	4501                	li	a0,0
     4fc:	00001097          	auipc	ra,0x1
     500:	93e080e7          	jalr	-1730(ra) # e3a <wait>
     504:	b105                	j	124 <go+0xac>
        printf("grind: pipe failed\n");
     506:	00001517          	auipc	a0,0x1
     50a:	07a50513          	add	a0,a0,122 # 1580 <malloc+0x22c>
     50e:	00001097          	auipc	ra,0x1
     512:	d8e080e7          	jalr	-626(ra) # 129c <printf>
        exit(1);
     516:	4505                	li	a0,1
     518:	00001097          	auipc	ra,0x1
     51c:	91a080e7          	jalr	-1766(ra) # e32 <exit>
        fork();
     520:	00001097          	auipc	ra,0x1
     524:	90a080e7          	jalr	-1782(ra) # e2a <fork>
        fork();
     528:	00001097          	auipc	ra,0x1
     52c:	902080e7          	jalr	-1790(ra) # e2a <fork>
        if(write(fds[1], "x", 1) != 1)
     530:	4605                	li	a2,1
     532:	00001597          	auipc	a1,0x1
     536:	06658593          	add	a1,a1,102 # 1598 <malloc+0x244>
     53a:	f9c42503          	lw	a0,-100(s0)
     53e:	00001097          	auipc	ra,0x1
     542:	914080e7          	jalr	-1772(ra) # e52 <write>
     546:	4785                	li	a5,1
     548:	02f51363          	bne	a0,a5,56e <go+0x4f6>
        if(read(fds[0], &c, 1) != 1)
     54c:	4605                	li	a2,1
     54e:	f9040593          	add	a1,s0,-112
     552:	f9842503          	lw	a0,-104(s0)
     556:	00001097          	auipc	ra,0x1
     55a:	8f4080e7          	jalr	-1804(ra) # e4a <read>
     55e:	4785                	li	a5,1
     560:	02f51063          	bne	a0,a5,580 <go+0x508>
        exit(0);
     564:	4501                	li	a0,0
     566:	00001097          	auipc	ra,0x1
     56a:	8cc080e7          	jalr	-1844(ra) # e32 <exit>
          printf("grind: pipe write failed\n");
     56e:	00001517          	auipc	a0,0x1
     572:	03250513          	add	a0,a0,50 # 15a0 <malloc+0x24c>
     576:	00001097          	auipc	ra,0x1
     57a:	d26080e7          	jalr	-730(ra) # 129c <printf>
     57e:	b7f9                	j	54c <go+0x4d4>
          printf("grind: pipe read failed\n");
     580:	00001517          	auipc	a0,0x1
     584:	04050513          	add	a0,a0,64 # 15c0 <malloc+0x26c>
     588:	00001097          	auipc	ra,0x1
     58c:	d14080e7          	jalr	-748(ra) # 129c <printf>
     590:	bfd1                	j	564 <go+0x4ec>
        printf("grind: fork failed\n");
     592:	00001517          	auipc	a0,0x1
     596:	fae50513          	add	a0,a0,-82 # 1540 <malloc+0x1ec>
     59a:	00001097          	auipc	ra,0x1
     59e:	d02080e7          	jalr	-766(ra) # 129c <printf>
        exit(1);
     5a2:	4505                	li	a0,1
     5a4:	00001097          	auipc	ra,0x1
     5a8:	88e080e7          	jalr	-1906(ra) # e32 <exit>
    } else if(what == 20){
      int pid = fork();
     5ac:	00001097          	auipc	ra,0x1
     5b0:	87e080e7          	jalr	-1922(ra) # e2a <fork>
      if(pid == 0){
     5b4:	c909                	beqz	a0,5c6 <go+0x54e>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b6:	06054f63          	bltz	a0,634 <go+0x5bc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5ba:	4501                	li	a0,0
     5bc:	00001097          	auipc	ra,0x1
     5c0:	87e080e7          	jalr	-1922(ra) # e3a <wait>
     5c4:	b685                	j	124 <go+0xac>
        unlink("a");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	f5a50513          	add	a0,a0,-166 # 1520 <malloc+0x1cc>
     5ce:	00001097          	auipc	ra,0x1
     5d2:	8b4080e7          	jalr	-1868(ra) # e82 <unlink>
        mkdir("a");
     5d6:	00001517          	auipc	a0,0x1
     5da:	f4a50513          	add	a0,a0,-182 # 1520 <malloc+0x1cc>
     5de:	00001097          	auipc	ra,0x1
     5e2:	8bc080e7          	jalr	-1860(ra) # e9a <mkdir>
        chdir("a");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	f3a50513          	add	a0,a0,-198 # 1520 <malloc+0x1cc>
     5ee:	00001097          	auipc	ra,0x1
     5f2:	8b4080e7          	jalr	-1868(ra) # ea2 <chdir>
        unlink("../a");
     5f6:	00001517          	auipc	a0,0x1
     5fa:	e9250513          	add	a0,a0,-366 # 1488 <malloc+0x134>
     5fe:	00001097          	auipc	ra,0x1
     602:	884080e7          	jalr	-1916(ra) # e82 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     606:	20200593          	li	a1,514
     60a:	00001517          	auipc	a0,0x1
     60e:	f8e50513          	add	a0,a0,-114 # 1598 <malloc+0x244>
     612:	00001097          	auipc	ra,0x1
     616:	860080e7          	jalr	-1952(ra) # e72 <open>
        unlink("x");
     61a:	00001517          	auipc	a0,0x1
     61e:	f7e50513          	add	a0,a0,-130 # 1598 <malloc+0x244>
     622:	00001097          	auipc	ra,0x1
     626:	860080e7          	jalr	-1952(ra) # e82 <unlink>
        exit(0);
     62a:	4501                	li	a0,0
     62c:	00001097          	auipc	ra,0x1
     630:	806080e7          	jalr	-2042(ra) # e32 <exit>
        printf("grind: fork failed\n");
     634:	00001517          	auipc	a0,0x1
     638:	f0c50513          	add	a0,a0,-244 # 1540 <malloc+0x1ec>
     63c:	00001097          	auipc	ra,0x1
     640:	c60080e7          	jalr	-928(ra) # 129c <printf>
        exit(1);
     644:	4505                	li	a0,1
     646:	00000097          	auipc	ra,0x0
     64a:	7ec080e7          	jalr	2028(ra) # e32 <exit>
    } else if(what == 21){
      unlink("c");
     64e:	00001517          	auipc	a0,0x1
     652:	f9250513          	add	a0,a0,-110 # 15e0 <malloc+0x28c>
     656:	00001097          	auipc	ra,0x1
     65a:	82c080e7          	jalr	-2004(ra) # e82 <unlink>
      /* should always succeed. check that there are free i-nodes, */
      /* file descriptors, blocks. */
      int fd1 = open("c", O_CREATE|O_RDWR);
     65e:	20200593          	li	a1,514
     662:	00001517          	auipc	a0,0x1
     666:	f7e50513          	add	a0,a0,-130 # 15e0 <malloc+0x28c>
     66a:	00001097          	auipc	ra,0x1
     66e:	808080e7          	jalr	-2040(ra) # e72 <open>
     672:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     674:	04054f63          	bltz	a0,6d2 <go+0x65a>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     678:	4605                	li	a2,1
     67a:	00001597          	auipc	a1,0x1
     67e:	f1e58593          	add	a1,a1,-226 # 1598 <malloc+0x244>
     682:	00000097          	auipc	ra,0x0
     686:	7d0080e7          	jalr	2000(ra) # e52 <write>
     68a:	4785                	li	a5,1
     68c:	06f51063          	bne	a0,a5,6ec <go+0x674>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     690:	f9840593          	add	a1,s0,-104
     694:	855a                	mv	a0,s6
     696:	00000097          	auipc	ra,0x0
     69a:	7f4080e7          	jalr	2036(ra) # e8a <fstat>
     69e:	e525                	bnez	a0,706 <go+0x68e>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     6a0:	fa843583          	ld	a1,-88(s0)
     6a4:	4785                	li	a5,1
     6a6:	06f59d63          	bne	a1,a5,720 <go+0x6a8>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6aa:	f9c42583          	lw	a1,-100(s0)
     6ae:	0c800793          	li	a5,200
     6b2:	08b7e563          	bltu	a5,a1,73c <go+0x6c4>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b6:	855a                	mv	a0,s6
     6b8:	00000097          	auipc	ra,0x0
     6bc:	7a2080e7          	jalr	1954(ra) # e5a <close>
      unlink("c");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	f2050513          	add	a0,a0,-224 # 15e0 <malloc+0x28c>
     6c8:	00000097          	auipc	ra,0x0
     6cc:	7ba080e7          	jalr	1978(ra) # e82 <unlink>
     6d0:	bc91                	j	124 <go+0xac>
        printf("grind: create c failed\n");
     6d2:	00001517          	auipc	a0,0x1
     6d6:	f1650513          	add	a0,a0,-234 # 15e8 <malloc+0x294>
     6da:	00001097          	auipc	ra,0x1
     6de:	bc2080e7          	jalr	-1086(ra) # 129c <printf>
        exit(1);
     6e2:	4505                	li	a0,1
     6e4:	00000097          	auipc	ra,0x0
     6e8:	74e080e7          	jalr	1870(ra) # e32 <exit>
        printf("grind: write c failed\n");
     6ec:	00001517          	auipc	a0,0x1
     6f0:	f1450513          	add	a0,a0,-236 # 1600 <malloc+0x2ac>
     6f4:	00001097          	auipc	ra,0x1
     6f8:	ba8080e7          	jalr	-1112(ra) # 129c <printf>
        exit(1);
     6fc:	4505                	li	a0,1
     6fe:	00000097          	auipc	ra,0x0
     702:	734080e7          	jalr	1844(ra) # e32 <exit>
        printf("grind: fstat failed\n");
     706:	00001517          	auipc	a0,0x1
     70a:	f1250513          	add	a0,a0,-238 # 1618 <malloc+0x2c4>
     70e:	00001097          	auipc	ra,0x1
     712:	b8e080e7          	jalr	-1138(ra) # 129c <printf>
        exit(1);
     716:	4505                	li	a0,1
     718:	00000097          	auipc	ra,0x0
     71c:	71a080e7          	jalr	1818(ra) # e32 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     720:	2581                	sext.w	a1,a1
     722:	00001517          	auipc	a0,0x1
     726:	f0e50513          	add	a0,a0,-242 # 1630 <malloc+0x2dc>
     72a:	00001097          	auipc	ra,0x1
     72e:	b72080e7          	jalr	-1166(ra) # 129c <printf>
        exit(1);
     732:	4505                	li	a0,1
     734:	00000097          	auipc	ra,0x0
     738:	6fe080e7          	jalr	1790(ra) # e32 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     73c:	00001517          	auipc	a0,0x1
     740:	f1c50513          	add	a0,a0,-228 # 1658 <malloc+0x304>
     744:	00001097          	auipc	ra,0x1
     748:	b58080e7          	jalr	-1192(ra) # 129c <printf>
        exit(1);
     74c:	4505                	li	a0,1
     74e:	00000097          	auipc	ra,0x0
     752:	6e4080e7          	jalr	1764(ra) # e32 <exit>
    } else if(what == 22){
      /* echo hi | cat */
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     756:	f8840513          	add	a0,s0,-120
     75a:	00000097          	auipc	ra,0x0
     75e:	6e8080e7          	jalr	1768(ra) # e42 <pipe>
     762:	0c054f63          	bltz	a0,840 <go+0x7c8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     766:	f9040513          	add	a0,s0,-112
     76a:	00000097          	auipc	ra,0x0
     76e:	6d8080e7          	jalr	1752(ra) # e42 <pipe>
     772:	0e054563          	bltz	a0,85c <go+0x7e4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     776:	00000097          	auipc	ra,0x0
     77a:	6b4080e7          	jalr	1716(ra) # e2a <fork>
      if(pid1 == 0){
     77e:	cd6d                	beqz	a0,878 <go+0x800>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     780:	1a054663          	bltz	a0,92c <go+0x8b4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     784:	00000097          	auipc	ra,0x0
     788:	6a6080e7          	jalr	1702(ra) # e2a <fork>
      if(pid2 == 0){
     78c:	1a050e63          	beqz	a0,948 <go+0x8d0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     790:	28054a63          	bltz	a0,a24 <go+0x9ac>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     794:	f8842503          	lw	a0,-120(s0)
     798:	00000097          	auipc	ra,0x0
     79c:	6c2080e7          	jalr	1730(ra) # e5a <close>
      close(aa[1]);
     7a0:	f8c42503          	lw	a0,-116(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	6b6080e7          	jalr	1718(ra) # e5a <close>
      close(bb[1]);
     7ac:	f9442503          	lw	a0,-108(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	6aa080e7          	jalr	1706(ra) # e5a <close>
      char buf[4] = { 0, 0, 0, 0 };
     7b8:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
     7bc:	4605                	li	a2,1
     7be:	f8040593          	add	a1,s0,-128
     7c2:	f9042503          	lw	a0,-112(s0)
     7c6:	00000097          	auipc	ra,0x0
     7ca:	684080e7          	jalr	1668(ra) # e4a <read>
      read(bb[0], buf+1, 1);
     7ce:	4605                	li	a2,1
     7d0:	f8140593          	add	a1,s0,-127
     7d4:	f9042503          	lw	a0,-112(s0)
     7d8:	00000097          	auipc	ra,0x0
     7dc:	672080e7          	jalr	1650(ra) # e4a <read>
      read(bb[0], buf+2, 1);
     7e0:	4605                	li	a2,1
     7e2:	f8240593          	add	a1,s0,-126
     7e6:	f9042503          	lw	a0,-112(s0)
     7ea:	00000097          	auipc	ra,0x0
     7ee:	660080e7          	jalr	1632(ra) # e4a <read>
      close(bb[0]);
     7f2:	f9042503          	lw	a0,-112(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	664080e7          	jalr	1636(ra) # e5a <close>
      int st1, st2;
      wait(&st1);
     7fe:	f8440513          	add	a0,s0,-124
     802:	00000097          	auipc	ra,0x0
     806:	638080e7          	jalr	1592(ra) # e3a <wait>
      wait(&st2);
     80a:	f9840513          	add	a0,s0,-104
     80e:	00000097          	auipc	ra,0x0
     812:	62c080e7          	jalr	1580(ra) # e3a <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     816:	f8442783          	lw	a5,-124(s0)
     81a:	f9842b83          	lw	s7,-104(s0)
     81e:	0177eb33          	or	s6,a5,s7
     822:	200b1f63          	bnez	s6,a40 <go+0x9c8>
     826:	00001597          	auipc	a1,0x1
     82a:	ed258593          	add	a1,a1,-302 # 16f8 <malloc+0x3a4>
     82e:	f8040513          	add	a0,s0,-128
     832:	00000097          	auipc	ra,0x0
     836:	3b0080e7          	jalr	944(ra) # be2 <strcmp>
     83a:	8e0505e3          	beqz	a0,124 <go+0xac>
     83e:	a411                	j	a42 <go+0x9ca>
        fprintf(2, "grind: pipe failed\n");
     840:	00001597          	auipc	a1,0x1
     844:	d4058593          	add	a1,a1,-704 # 1580 <malloc+0x22c>
     848:	4509                	li	a0,2
     84a:	00001097          	auipc	ra,0x1
     84e:	a24080e7          	jalr	-1500(ra) # 126e <fprintf>
        exit(1);
     852:	4505                	li	a0,1
     854:	00000097          	auipc	ra,0x0
     858:	5de080e7          	jalr	1502(ra) # e32 <exit>
        fprintf(2, "grind: pipe failed\n");
     85c:	00001597          	auipc	a1,0x1
     860:	d2458593          	add	a1,a1,-732 # 1580 <malloc+0x22c>
     864:	4509                	li	a0,2
     866:	00001097          	auipc	ra,0x1
     86a:	a08080e7          	jalr	-1528(ra) # 126e <fprintf>
        exit(1);
     86e:	4505                	li	a0,1
     870:	00000097          	auipc	ra,0x0
     874:	5c2080e7          	jalr	1474(ra) # e32 <exit>
        close(bb[0]);
     878:	f9042503          	lw	a0,-112(s0)
     87c:	00000097          	auipc	ra,0x0
     880:	5de080e7          	jalr	1502(ra) # e5a <close>
        close(bb[1]);
     884:	f9442503          	lw	a0,-108(s0)
     888:	00000097          	auipc	ra,0x0
     88c:	5d2080e7          	jalr	1490(ra) # e5a <close>
        close(aa[0]);
     890:	f8842503          	lw	a0,-120(s0)
     894:	00000097          	auipc	ra,0x0
     898:	5c6080e7          	jalr	1478(ra) # e5a <close>
        close(1);
     89c:	4505                	li	a0,1
     89e:	00000097          	auipc	ra,0x0
     8a2:	5bc080e7          	jalr	1468(ra) # e5a <close>
        if(dup(aa[1]) != 1){
     8a6:	f8c42503          	lw	a0,-116(s0)
     8aa:	00000097          	auipc	ra,0x0
     8ae:	600080e7          	jalr	1536(ra) # eaa <dup>
     8b2:	4785                	li	a5,1
     8b4:	02f50063          	beq	a0,a5,8d4 <go+0x85c>
          fprintf(2, "grind: dup failed\n");
     8b8:	00001597          	auipc	a1,0x1
     8bc:	dc858593          	add	a1,a1,-568 # 1680 <malloc+0x32c>
     8c0:	4509                	li	a0,2
     8c2:	00001097          	auipc	ra,0x1
     8c6:	9ac080e7          	jalr	-1620(ra) # 126e <fprintf>
          exit(1);
     8ca:	4505                	li	a0,1
     8cc:	00000097          	auipc	ra,0x0
     8d0:	566080e7          	jalr	1382(ra) # e32 <exit>
        close(aa[1]);
     8d4:	f8c42503          	lw	a0,-116(s0)
     8d8:	00000097          	auipc	ra,0x0
     8dc:	582080e7          	jalr	1410(ra) # e5a <close>
        char *args[3] = { "echo", "hi", 0 };
     8e0:	00001797          	auipc	a5,0x1
     8e4:	db878793          	add	a5,a5,-584 # 1698 <malloc+0x344>
     8e8:	f8f43c23          	sd	a5,-104(s0)
     8ec:	00001797          	auipc	a5,0x1
     8f0:	db478793          	add	a5,a5,-588 # 16a0 <malloc+0x34c>
     8f4:	faf43023          	sd	a5,-96(s0)
     8f8:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     8fc:	f9840593          	add	a1,s0,-104
     900:	00001517          	auipc	a0,0x1
     904:	da850513          	add	a0,a0,-600 # 16a8 <malloc+0x354>
     908:	00000097          	auipc	ra,0x0
     90c:	562080e7          	jalr	1378(ra) # e6a <exec>
        fprintf(2, "grind: echo: not found\n");
     910:	00001597          	auipc	a1,0x1
     914:	da858593          	add	a1,a1,-600 # 16b8 <malloc+0x364>
     918:	4509                	li	a0,2
     91a:	00001097          	auipc	ra,0x1
     91e:	954080e7          	jalr	-1708(ra) # 126e <fprintf>
        exit(2);
     922:	4509                	li	a0,2
     924:	00000097          	auipc	ra,0x0
     928:	50e080e7          	jalr	1294(ra) # e32 <exit>
        fprintf(2, "grind: fork failed\n");
     92c:	00001597          	auipc	a1,0x1
     930:	c1458593          	add	a1,a1,-1004 # 1540 <malloc+0x1ec>
     934:	4509                	li	a0,2
     936:	00001097          	auipc	ra,0x1
     93a:	938080e7          	jalr	-1736(ra) # 126e <fprintf>
        exit(3);
     93e:	450d                	li	a0,3
     940:	00000097          	auipc	ra,0x0
     944:	4f2080e7          	jalr	1266(ra) # e32 <exit>
        close(aa[1]);
     948:	f8c42503          	lw	a0,-116(s0)
     94c:	00000097          	auipc	ra,0x0
     950:	50e080e7          	jalr	1294(ra) # e5a <close>
        close(bb[0]);
     954:	f9042503          	lw	a0,-112(s0)
     958:	00000097          	auipc	ra,0x0
     95c:	502080e7          	jalr	1282(ra) # e5a <close>
        close(0);
     960:	4501                	li	a0,0
     962:	00000097          	auipc	ra,0x0
     966:	4f8080e7          	jalr	1272(ra) # e5a <close>
        if(dup(aa[0]) != 0){
     96a:	f8842503          	lw	a0,-120(s0)
     96e:	00000097          	auipc	ra,0x0
     972:	53c080e7          	jalr	1340(ra) # eaa <dup>
     976:	cd19                	beqz	a0,994 <go+0x91c>
          fprintf(2, "grind: dup failed\n");
     978:	00001597          	auipc	a1,0x1
     97c:	d0858593          	add	a1,a1,-760 # 1680 <malloc+0x32c>
     980:	4509                	li	a0,2
     982:	00001097          	auipc	ra,0x1
     986:	8ec080e7          	jalr	-1812(ra) # 126e <fprintf>
          exit(4);
     98a:	4511                	li	a0,4
     98c:	00000097          	auipc	ra,0x0
     990:	4a6080e7          	jalr	1190(ra) # e32 <exit>
        close(aa[0]);
     994:	f8842503          	lw	a0,-120(s0)
     998:	00000097          	auipc	ra,0x0
     99c:	4c2080e7          	jalr	1218(ra) # e5a <close>
        close(1);
     9a0:	4505                	li	a0,1
     9a2:	00000097          	auipc	ra,0x0
     9a6:	4b8080e7          	jalr	1208(ra) # e5a <close>
        if(dup(bb[1]) != 1){
     9aa:	f9442503          	lw	a0,-108(s0)
     9ae:	00000097          	auipc	ra,0x0
     9b2:	4fc080e7          	jalr	1276(ra) # eaa <dup>
     9b6:	4785                	li	a5,1
     9b8:	02f50063          	beq	a0,a5,9d8 <go+0x960>
          fprintf(2, "grind: dup failed\n");
     9bc:	00001597          	auipc	a1,0x1
     9c0:	cc458593          	add	a1,a1,-828 # 1680 <malloc+0x32c>
     9c4:	4509                	li	a0,2
     9c6:	00001097          	auipc	ra,0x1
     9ca:	8a8080e7          	jalr	-1880(ra) # 126e <fprintf>
          exit(5);
     9ce:	4515                	li	a0,5
     9d0:	00000097          	auipc	ra,0x0
     9d4:	462080e7          	jalr	1122(ra) # e32 <exit>
        close(bb[1]);
     9d8:	f9442503          	lw	a0,-108(s0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	47e080e7          	jalr	1150(ra) # e5a <close>
        char *args[2] = { "cat", 0 };
     9e4:	00001797          	auipc	a5,0x1
     9e8:	cec78793          	add	a5,a5,-788 # 16d0 <malloc+0x37c>
     9ec:	f8f43c23          	sd	a5,-104(s0)
     9f0:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     9f4:	f9840593          	add	a1,s0,-104
     9f8:	00001517          	auipc	a0,0x1
     9fc:	ce050513          	add	a0,a0,-800 # 16d8 <malloc+0x384>
     a00:	00000097          	auipc	ra,0x0
     a04:	46a080e7          	jalr	1130(ra) # e6a <exec>
        fprintf(2, "grind: cat: not found\n");
     a08:	00001597          	auipc	a1,0x1
     a0c:	cd858593          	add	a1,a1,-808 # 16e0 <malloc+0x38c>
     a10:	4509                	li	a0,2
     a12:	00001097          	auipc	ra,0x1
     a16:	85c080e7          	jalr	-1956(ra) # 126e <fprintf>
        exit(6);
     a1a:	4519                	li	a0,6
     a1c:	00000097          	auipc	ra,0x0
     a20:	416080e7          	jalr	1046(ra) # e32 <exit>
        fprintf(2, "grind: fork failed\n");
     a24:	00001597          	auipc	a1,0x1
     a28:	b1c58593          	add	a1,a1,-1252 # 1540 <malloc+0x1ec>
     a2c:	4509                	li	a0,2
     a2e:	00001097          	auipc	ra,0x1
     a32:	840080e7          	jalr	-1984(ra) # 126e <fprintf>
        exit(7);
     a36:	451d                	li	a0,7
     a38:	00000097          	auipc	ra,0x0
     a3c:	3fa080e7          	jalr	1018(ra) # e32 <exit>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     a40:	8b3e                	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     a42:	f8040693          	add	a3,s0,-128
     a46:	865e                	mv	a2,s7
     a48:	85da                	mv	a1,s6
     a4a:	00001517          	auipc	a0,0x1
     a4e:	cb650513          	add	a0,a0,-842 # 1700 <malloc+0x3ac>
     a52:	00001097          	auipc	ra,0x1
     a56:	84a080e7          	jalr	-1974(ra) # 129c <printf>
        exit(1);
     a5a:	4505                	li	a0,1
     a5c:	00000097          	auipc	ra,0x0
     a60:	3d6080e7          	jalr	982(ra) # e32 <exit>

0000000000000a64 <iter>:
  }
}

void
iter()
{
     a64:	7179                	add	sp,sp,-48
     a66:	f406                	sd	ra,40(sp)
     a68:	f022                	sd	s0,32(sp)
     a6a:	ec26                	sd	s1,24(sp)
     a6c:	e84a                	sd	s2,16(sp)
     a6e:	1800                	add	s0,sp,48
  unlink("a");
     a70:	00001517          	auipc	a0,0x1
     a74:	ab050513          	add	a0,a0,-1360 # 1520 <malloc+0x1cc>
     a78:	00000097          	auipc	ra,0x0
     a7c:	40a080e7          	jalr	1034(ra) # e82 <unlink>
  unlink("b");
     a80:	00001517          	auipc	a0,0x1
     a84:	a5050513          	add	a0,a0,-1456 # 14d0 <malloc+0x17c>
     a88:	00000097          	auipc	ra,0x0
     a8c:	3fa080e7          	jalr	1018(ra) # e82 <unlink>
  
  int pid1 = fork();
     a90:	00000097          	auipc	ra,0x0
     a94:	39a080e7          	jalr	922(ra) # e2a <fork>
  if(pid1 < 0){
     a98:	02054163          	bltz	a0,aba <iter+0x56>
     a9c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a9e:	e91d                	bnez	a0,ad4 <iter+0x70>
    rand_next ^= 31;
     aa0:	00001717          	auipc	a4,0x1
     aa4:	56070713          	add	a4,a4,1376 # 2000 <rand_next>
     aa8:	631c                	ld	a5,0(a4)
     aaa:	01f7c793          	xor	a5,a5,31
     aae:	e31c                	sd	a5,0(a4)
    go(0);
     ab0:	4501                	li	a0,0
     ab2:	fffff097          	auipc	ra,0xfffff
     ab6:	5c6080e7          	jalr	1478(ra) # 78 <go>
    printf("grind: fork failed\n");
     aba:	00001517          	auipc	a0,0x1
     abe:	a8650513          	add	a0,a0,-1402 # 1540 <malloc+0x1ec>
     ac2:	00000097          	auipc	ra,0x0
     ac6:	7da080e7          	jalr	2010(ra) # 129c <printf>
    exit(1);
     aca:	4505                	li	a0,1
     acc:	00000097          	auipc	ra,0x0
     ad0:	366080e7          	jalr	870(ra) # e32 <exit>
    exit(0);
  }

  int pid2 = fork();
     ad4:	00000097          	auipc	ra,0x0
     ad8:	356080e7          	jalr	854(ra) # e2a <fork>
     adc:	892a                	mv	s2,a0
  if(pid2 < 0){
     ade:	02054263          	bltz	a0,b02 <iter+0x9e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ae2:	ed0d                	bnez	a0,b1c <iter+0xb8>
    rand_next ^= 7177;
     ae4:	00001697          	auipc	a3,0x1
     ae8:	51c68693          	add	a3,a3,1308 # 2000 <rand_next>
     aec:	629c                	ld	a5,0(a3)
     aee:	6709                	lui	a4,0x2
     af0:	c0970713          	add	a4,a4,-1015 # 1c09 <digits+0x479>
     af4:	8fb9                	xor	a5,a5,a4
     af6:	e29c                	sd	a5,0(a3)
    go(1);
     af8:	4505                	li	a0,1
     afa:	fffff097          	auipc	ra,0xfffff
     afe:	57e080e7          	jalr	1406(ra) # 78 <go>
    printf("grind: fork failed\n");
     b02:	00001517          	auipc	a0,0x1
     b06:	a3e50513          	add	a0,a0,-1474 # 1540 <malloc+0x1ec>
     b0a:	00000097          	auipc	ra,0x0
     b0e:	792080e7          	jalr	1938(ra) # 129c <printf>
    exit(1);
     b12:	4505                	li	a0,1
     b14:	00000097          	auipc	ra,0x0
     b18:	31e080e7          	jalr	798(ra) # e32 <exit>
    exit(0);
  }

  int st1 = -1;
     b1c:	57fd                	li	a5,-1
     b1e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b22:	fdc40513          	add	a0,s0,-36
     b26:	00000097          	auipc	ra,0x0
     b2a:	314080e7          	jalr	788(ra) # e3a <wait>
  if(st1 != 0){
     b2e:	fdc42783          	lw	a5,-36(s0)
     b32:	ef99                	bnez	a5,b50 <iter+0xec>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b34:	57fd                	li	a5,-1
     b36:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b3a:	fd840513          	add	a0,s0,-40
     b3e:	00000097          	auipc	ra,0x0
     b42:	2fc080e7          	jalr	764(ra) # e3a <wait>

  exit(0);
     b46:	4501                	li	a0,0
     b48:	00000097          	auipc	ra,0x0
     b4c:	2ea080e7          	jalr	746(ra) # e32 <exit>
    kill(pid1);
     b50:	8526                	mv	a0,s1
     b52:	00000097          	auipc	ra,0x0
     b56:	310080e7          	jalr	784(ra) # e62 <kill>
    kill(pid2);
     b5a:	854a                	mv	a0,s2
     b5c:	00000097          	auipc	ra,0x0
     b60:	306080e7          	jalr	774(ra) # e62 <kill>
     b64:	bfc1                	j	b34 <iter+0xd0>

0000000000000b66 <main>:
}

int
main()
{
     b66:	1101                	add	sp,sp,-32
     b68:	ec06                	sd	ra,24(sp)
     b6a:	e822                	sd	s0,16(sp)
     b6c:	e426                	sd	s1,8(sp)
     b6e:	1000                	add	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b70:	00001497          	auipc	s1,0x1
     b74:	49048493          	add	s1,s1,1168 # 2000 <rand_next>
     b78:	a829                	j	b92 <main+0x2c>
      iter();
     b7a:	00000097          	auipc	ra,0x0
     b7e:	eea080e7          	jalr	-278(ra) # a64 <iter>
    sleep(20);
     b82:	4551                	li	a0,20
     b84:	00000097          	auipc	ra,0x0
     b88:	33e080e7          	jalr	830(ra) # ec2 <sleep>
    rand_next += 1;
     b8c:	609c                	ld	a5,0(s1)
     b8e:	0785                	add	a5,a5,1
     b90:	e09c                	sd	a5,0(s1)
    int pid = fork();
     b92:	00000097          	auipc	ra,0x0
     b96:	298080e7          	jalr	664(ra) # e2a <fork>
    if(pid == 0){
     b9a:	d165                	beqz	a0,b7a <main+0x14>
    if(pid > 0){
     b9c:	fea053e3          	blez	a0,b82 <main+0x1c>
      wait(0);
     ba0:	4501                	li	a0,0
     ba2:	00000097          	auipc	ra,0x0
     ba6:	298080e7          	jalr	664(ra) # e3a <wait>
     baa:	bfe1                	j	b82 <main+0x1c>

0000000000000bac <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
     bac:	1141                	add	sp,sp,-16
     bae:	e406                	sd	ra,8(sp)
     bb0:	e022                	sd	s0,0(sp)
     bb2:	0800                	add	s0,sp,16
  extern int main();
  main();
     bb4:	00000097          	auipc	ra,0x0
     bb8:	fb2080e7          	jalr	-78(ra) # b66 <main>
  exit(0);
     bbc:	4501                	li	a0,0
     bbe:	00000097          	auipc	ra,0x0
     bc2:	274080e7          	jalr	628(ra) # e32 <exit>

0000000000000bc6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bc6:	1141                	add	sp,sp,-16
     bc8:	e422                	sd	s0,8(sp)
     bca:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bcc:	87aa                	mv	a5,a0
     bce:	0585                	add	a1,a1,1
     bd0:	0785                	add	a5,a5,1
     bd2:	fff5c703          	lbu	a4,-1(a1)
     bd6:	fee78fa3          	sb	a4,-1(a5)
     bda:	fb75                	bnez	a4,bce <strcpy+0x8>
    ;
  return os;
}
     bdc:	6422                	ld	s0,8(sp)
     bde:	0141                	add	sp,sp,16
     be0:	8082                	ret

0000000000000be2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     be2:	1141                	add	sp,sp,-16
     be4:	e422                	sd	s0,8(sp)
     be6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     be8:	00054783          	lbu	a5,0(a0)
     bec:	cb91                	beqz	a5,c00 <strcmp+0x1e>
     bee:	0005c703          	lbu	a4,0(a1)
     bf2:	00f71763          	bne	a4,a5,c00 <strcmp+0x1e>
    p++, q++;
     bf6:	0505                	add	a0,a0,1
     bf8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     bfa:	00054783          	lbu	a5,0(a0)
     bfe:	fbe5                	bnez	a5,bee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c00:	0005c503          	lbu	a0,0(a1)
}
     c04:	40a7853b          	subw	a0,a5,a0
     c08:	6422                	ld	s0,8(sp)
     c0a:	0141                	add	sp,sp,16
     c0c:	8082                	ret

0000000000000c0e <strlen>:

uint
strlen(const char *s)
{
     c0e:	1141                	add	sp,sp,-16
     c10:	e422                	sd	s0,8(sp)
     c12:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c14:	00054783          	lbu	a5,0(a0)
     c18:	cf91                	beqz	a5,c34 <strlen+0x26>
     c1a:	0505                	add	a0,a0,1
     c1c:	87aa                	mv	a5,a0
     c1e:	86be                	mv	a3,a5
     c20:	0785                	add	a5,a5,1
     c22:	fff7c703          	lbu	a4,-1(a5)
     c26:	ff65                	bnez	a4,c1e <strlen+0x10>
     c28:	40a6853b          	subw	a0,a3,a0
     c2c:	2505                	addw	a0,a0,1
    ;
  return n;
}
     c2e:	6422                	ld	s0,8(sp)
     c30:	0141                	add	sp,sp,16
     c32:	8082                	ret
  for(n = 0; s[n]; n++)
     c34:	4501                	li	a0,0
     c36:	bfe5                	j	c2e <strlen+0x20>

0000000000000c38 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c38:	1141                	add	sp,sp,-16
     c3a:	e422                	sd	s0,8(sp)
     c3c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c3e:	ca19                	beqz	a2,c54 <memset+0x1c>
     c40:	87aa                	mv	a5,a0
     c42:	1602                	sll	a2,a2,0x20
     c44:	9201                	srl	a2,a2,0x20
     c46:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c4a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c4e:	0785                	add	a5,a5,1
     c50:	fee79de3          	bne	a5,a4,c4a <memset+0x12>
  }
  return dst;
}
     c54:	6422                	ld	s0,8(sp)
     c56:	0141                	add	sp,sp,16
     c58:	8082                	ret

0000000000000c5a <strchr>:

char*
strchr(const char *s, char c)
{
     c5a:	1141                	add	sp,sp,-16
     c5c:	e422                	sd	s0,8(sp)
     c5e:	0800                	add	s0,sp,16
  for(; *s; s++)
     c60:	00054783          	lbu	a5,0(a0)
     c64:	cb99                	beqz	a5,c7a <strchr+0x20>
    if(*s == c)
     c66:	00f58763          	beq	a1,a5,c74 <strchr+0x1a>
  for(; *s; s++)
     c6a:	0505                	add	a0,a0,1
     c6c:	00054783          	lbu	a5,0(a0)
     c70:	fbfd                	bnez	a5,c66 <strchr+0xc>
      return (char*)s;
  return 0;
     c72:	4501                	li	a0,0
}
     c74:	6422                	ld	s0,8(sp)
     c76:	0141                	add	sp,sp,16
     c78:	8082                	ret
  return 0;
     c7a:	4501                	li	a0,0
     c7c:	bfe5                	j	c74 <strchr+0x1a>

0000000000000c7e <gets>:

char*
gets(char *buf, int max)
{
     c7e:	711d                	add	sp,sp,-96
     c80:	ec86                	sd	ra,88(sp)
     c82:	e8a2                	sd	s0,80(sp)
     c84:	e4a6                	sd	s1,72(sp)
     c86:	e0ca                	sd	s2,64(sp)
     c88:	fc4e                	sd	s3,56(sp)
     c8a:	f852                	sd	s4,48(sp)
     c8c:	f456                	sd	s5,40(sp)
     c8e:	f05a                	sd	s6,32(sp)
     c90:	ec5e                	sd	s7,24(sp)
     c92:	1080                	add	s0,sp,96
     c94:	8baa                	mv	s7,a0
     c96:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c98:	892a                	mv	s2,a0
     c9a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c9c:	4aa9                	li	s5,10
     c9e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     ca0:	89a6                	mv	s3,s1
     ca2:	2485                	addw	s1,s1,1
     ca4:	0344d863          	bge	s1,s4,cd4 <gets+0x56>
    cc = read(0, &c, 1);
     ca8:	4605                	li	a2,1
     caa:	faf40593          	add	a1,s0,-81
     cae:	4501                	li	a0,0
     cb0:	00000097          	auipc	ra,0x0
     cb4:	19a080e7          	jalr	410(ra) # e4a <read>
    if(cc < 1)
     cb8:	00a05e63          	blez	a0,cd4 <gets+0x56>
    buf[i++] = c;
     cbc:	faf44783          	lbu	a5,-81(s0)
     cc0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cc4:	01578763          	beq	a5,s5,cd2 <gets+0x54>
     cc8:	0905                	add	s2,s2,1
     cca:	fd679be3          	bne	a5,s6,ca0 <gets+0x22>
  for(i=0; i+1 < max; ){
     cce:	89a6                	mv	s3,s1
     cd0:	a011                	j	cd4 <gets+0x56>
     cd2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cd4:	99de                	add	s3,s3,s7
     cd6:	00098023          	sb	zero,0(s3)
  return buf;
}
     cda:	855e                	mv	a0,s7
     cdc:	60e6                	ld	ra,88(sp)
     cde:	6446                	ld	s0,80(sp)
     ce0:	64a6                	ld	s1,72(sp)
     ce2:	6906                	ld	s2,64(sp)
     ce4:	79e2                	ld	s3,56(sp)
     ce6:	7a42                	ld	s4,48(sp)
     ce8:	7aa2                	ld	s5,40(sp)
     cea:	7b02                	ld	s6,32(sp)
     cec:	6be2                	ld	s7,24(sp)
     cee:	6125                	add	sp,sp,96
     cf0:	8082                	ret

0000000000000cf2 <stat>:

int
stat(const char *n, struct stat *st)
{
     cf2:	1101                	add	sp,sp,-32
     cf4:	ec06                	sd	ra,24(sp)
     cf6:	e822                	sd	s0,16(sp)
     cf8:	e426                	sd	s1,8(sp)
     cfa:	e04a                	sd	s2,0(sp)
     cfc:	1000                	add	s0,sp,32
     cfe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d00:	4581                	li	a1,0
     d02:	00000097          	auipc	ra,0x0
     d06:	170080e7          	jalr	368(ra) # e72 <open>
  if(fd < 0)
     d0a:	02054563          	bltz	a0,d34 <stat+0x42>
     d0e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d10:	85ca                	mv	a1,s2
     d12:	00000097          	auipc	ra,0x0
     d16:	178080e7          	jalr	376(ra) # e8a <fstat>
     d1a:	892a                	mv	s2,a0
  close(fd);
     d1c:	8526                	mv	a0,s1
     d1e:	00000097          	auipc	ra,0x0
     d22:	13c080e7          	jalr	316(ra) # e5a <close>
  return r;
}
     d26:	854a                	mv	a0,s2
     d28:	60e2                	ld	ra,24(sp)
     d2a:	6442                	ld	s0,16(sp)
     d2c:	64a2                	ld	s1,8(sp)
     d2e:	6902                	ld	s2,0(sp)
     d30:	6105                	add	sp,sp,32
     d32:	8082                	ret
    return -1;
     d34:	597d                	li	s2,-1
     d36:	bfc5                	j	d26 <stat+0x34>

0000000000000d38 <atoi>:

int
atoi(const char *s)
{
     d38:	1141                	add	sp,sp,-16
     d3a:	e422                	sd	s0,8(sp)
     d3c:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d3e:	00054683          	lbu	a3,0(a0)
     d42:	fd06879b          	addw	a5,a3,-48
     d46:	0ff7f793          	zext.b	a5,a5
     d4a:	4625                	li	a2,9
     d4c:	02f66863          	bltu	a2,a5,d7c <atoi+0x44>
     d50:	872a                	mv	a4,a0
  n = 0;
     d52:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d54:	0705                	add	a4,a4,1
     d56:	0025179b          	sllw	a5,a0,0x2
     d5a:	9fa9                	addw	a5,a5,a0
     d5c:	0017979b          	sllw	a5,a5,0x1
     d60:	9fb5                	addw	a5,a5,a3
     d62:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d66:	00074683          	lbu	a3,0(a4)
     d6a:	fd06879b          	addw	a5,a3,-48
     d6e:	0ff7f793          	zext.b	a5,a5
     d72:	fef671e3          	bgeu	a2,a5,d54 <atoi+0x1c>
  return n;
}
     d76:	6422                	ld	s0,8(sp)
     d78:	0141                	add	sp,sp,16
     d7a:	8082                	ret
  n = 0;
     d7c:	4501                	li	a0,0
     d7e:	bfe5                	j	d76 <atoi+0x3e>

0000000000000d80 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d80:	1141                	add	sp,sp,-16
     d82:	e422                	sd	s0,8(sp)
     d84:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d86:	02b57463          	bgeu	a0,a1,dae <memmove+0x2e>
    while(n-- > 0)
     d8a:	00c05f63          	blez	a2,da8 <memmove+0x28>
     d8e:	1602                	sll	a2,a2,0x20
     d90:	9201                	srl	a2,a2,0x20
     d92:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d96:	872a                	mv	a4,a0
      *dst++ = *src++;
     d98:	0585                	add	a1,a1,1
     d9a:	0705                	add	a4,a4,1
     d9c:	fff5c683          	lbu	a3,-1(a1)
     da0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     da4:	fee79ae3          	bne	a5,a4,d98 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     da8:	6422                	ld	s0,8(sp)
     daa:	0141                	add	sp,sp,16
     dac:	8082                	ret
    dst += n;
     dae:	00c50733          	add	a4,a0,a2
    src += n;
     db2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     db4:	fec05ae3          	blez	a2,da8 <memmove+0x28>
     db8:	fff6079b          	addw	a5,a2,-1
     dbc:	1782                	sll	a5,a5,0x20
     dbe:	9381                	srl	a5,a5,0x20
     dc0:	fff7c793          	not	a5,a5
     dc4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dc6:	15fd                	add	a1,a1,-1
     dc8:	177d                	add	a4,a4,-1
     dca:	0005c683          	lbu	a3,0(a1)
     dce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dd2:	fee79ae3          	bne	a5,a4,dc6 <memmove+0x46>
     dd6:	bfc9                	j	da8 <memmove+0x28>

0000000000000dd8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dd8:	1141                	add	sp,sp,-16
     dda:	e422                	sd	s0,8(sp)
     ddc:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dde:	ca05                	beqz	a2,e0e <memcmp+0x36>
     de0:	fff6069b          	addw	a3,a2,-1
     de4:	1682                	sll	a3,a3,0x20
     de6:	9281                	srl	a3,a3,0x20
     de8:	0685                	add	a3,a3,1
     dea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dec:	00054783          	lbu	a5,0(a0)
     df0:	0005c703          	lbu	a4,0(a1)
     df4:	00e79863          	bne	a5,a4,e04 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     df8:	0505                	add	a0,a0,1
    p2++;
     dfa:	0585                	add	a1,a1,1
  while (n-- > 0) {
     dfc:	fed518e3          	bne	a0,a3,dec <memcmp+0x14>
  }
  return 0;
     e00:	4501                	li	a0,0
     e02:	a019                	j	e08 <memcmp+0x30>
      return *p1 - *p2;
     e04:	40e7853b          	subw	a0,a5,a4
}
     e08:	6422                	ld	s0,8(sp)
     e0a:	0141                	add	sp,sp,16
     e0c:	8082                	ret
  return 0;
     e0e:	4501                	li	a0,0
     e10:	bfe5                	j	e08 <memcmp+0x30>

0000000000000e12 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e12:	1141                	add	sp,sp,-16
     e14:	e406                	sd	ra,8(sp)
     e16:	e022                	sd	s0,0(sp)
     e18:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     e1a:	00000097          	auipc	ra,0x0
     e1e:	f66080e7          	jalr	-154(ra) # d80 <memmove>
}
     e22:	60a2                	ld	ra,8(sp)
     e24:	6402                	ld	s0,0(sp)
     e26:	0141                	add	sp,sp,16
     e28:	8082                	ret

0000000000000e2a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e2a:	4885                	li	a7,1
 ecall
     e2c:	00000073          	ecall
 ret
     e30:	8082                	ret

0000000000000e32 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e32:	4889                	li	a7,2
 ecall
     e34:	00000073          	ecall
 ret
     e38:	8082                	ret

0000000000000e3a <wait>:
.global wait
wait:
 li a7, SYS_wait
     e3a:	488d                	li	a7,3
 ecall
     e3c:	00000073          	ecall
 ret
     e40:	8082                	ret

0000000000000e42 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e42:	4891                	li	a7,4
 ecall
     e44:	00000073          	ecall
 ret
     e48:	8082                	ret

0000000000000e4a <read>:
.global read
read:
 li a7, SYS_read
     e4a:	4895                	li	a7,5
 ecall
     e4c:	00000073          	ecall
 ret
     e50:	8082                	ret

0000000000000e52 <write>:
.global write
write:
 li a7, SYS_write
     e52:	48c1                	li	a7,16
 ecall
     e54:	00000073          	ecall
 ret
     e58:	8082                	ret

0000000000000e5a <close>:
.global close
close:
 li a7, SYS_close
     e5a:	48d5                	li	a7,21
 ecall
     e5c:	00000073          	ecall
 ret
     e60:	8082                	ret

0000000000000e62 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e62:	4899                	li	a7,6
 ecall
     e64:	00000073          	ecall
 ret
     e68:	8082                	ret

0000000000000e6a <exec>:
.global exec
exec:
 li a7, SYS_exec
     e6a:	489d                	li	a7,7
 ecall
     e6c:	00000073          	ecall
 ret
     e70:	8082                	ret

0000000000000e72 <open>:
.global open
open:
 li a7, SYS_open
     e72:	48bd                	li	a7,15
 ecall
     e74:	00000073          	ecall
 ret
     e78:	8082                	ret

0000000000000e7a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e7a:	48c5                	li	a7,17
 ecall
     e7c:	00000073          	ecall
 ret
     e80:	8082                	ret

0000000000000e82 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e82:	48c9                	li	a7,18
 ecall
     e84:	00000073          	ecall
 ret
     e88:	8082                	ret

0000000000000e8a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e8a:	48a1                	li	a7,8
 ecall
     e8c:	00000073          	ecall
 ret
     e90:	8082                	ret

0000000000000e92 <link>:
.global link
link:
 li a7, SYS_link
     e92:	48cd                	li	a7,19
 ecall
     e94:	00000073          	ecall
 ret
     e98:	8082                	ret

0000000000000e9a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e9a:	48d1                	li	a7,20
 ecall
     e9c:	00000073          	ecall
 ret
     ea0:	8082                	ret

0000000000000ea2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ea2:	48a5                	li	a7,9
 ecall
     ea4:	00000073          	ecall
 ret
     ea8:	8082                	ret

0000000000000eaa <dup>:
.global dup
dup:
 li a7, SYS_dup
     eaa:	48a9                	li	a7,10
 ecall
     eac:	00000073          	ecall
 ret
     eb0:	8082                	ret

0000000000000eb2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     eb2:	48ad                	li	a7,11
 ecall
     eb4:	00000073          	ecall
 ret
     eb8:	8082                	ret

0000000000000eba <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     eba:	48b1                	li	a7,12
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ec2:	48b5                	li	a7,13
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     eca:	48b9                	li	a7,14
 ecall
     ecc:	00000073          	ecall
 ret
     ed0:	8082                	ret

0000000000000ed2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ed2:	1101                	add	sp,sp,-32
     ed4:	ec06                	sd	ra,24(sp)
     ed6:	e822                	sd	s0,16(sp)
     ed8:	1000                	add	s0,sp,32
     eda:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ede:	4605                	li	a2,1
     ee0:	fef40593          	add	a1,s0,-17
     ee4:	00000097          	auipc	ra,0x0
     ee8:	f6e080e7          	jalr	-146(ra) # e52 <write>
}
     eec:	60e2                	ld	ra,24(sp)
     eee:	6442                	ld	s0,16(sp)
     ef0:	6105                	add	sp,sp,32
     ef2:	8082                	ret

0000000000000ef4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ef4:	7139                	add	sp,sp,-64
     ef6:	fc06                	sd	ra,56(sp)
     ef8:	f822                	sd	s0,48(sp)
     efa:	f426                	sd	s1,40(sp)
     efc:	f04a                	sd	s2,32(sp)
     efe:	ec4e                	sd	s3,24(sp)
     f00:	0080                	add	s0,sp,64
     f02:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f04:	c299                	beqz	a3,f0a <printint+0x16>
     f06:	0805c963          	bltz	a1,f98 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f0a:	2581                	sext.w	a1,a1
  neg = 0;
     f0c:	4881                	li	a7,0
     f0e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     f12:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f14:	2601                	sext.w	a2,a2
     f16:	00001517          	auipc	a0,0x1
     f1a:	87a50513          	add	a0,a0,-1926 # 1790 <digits>
     f1e:	883a                	mv	a6,a4
     f20:	2705                	addw	a4,a4,1
     f22:	02c5f7bb          	remuw	a5,a1,a2
     f26:	1782                	sll	a5,a5,0x20
     f28:	9381                	srl	a5,a5,0x20
     f2a:	97aa                	add	a5,a5,a0
     f2c:	0007c783          	lbu	a5,0(a5)
     f30:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f34:	0005879b          	sext.w	a5,a1
     f38:	02c5d5bb          	divuw	a1,a1,a2
     f3c:	0685                	add	a3,a3,1
     f3e:	fec7f0e3          	bgeu	a5,a2,f1e <printint+0x2a>
  if(neg)
     f42:	00088c63          	beqz	a7,f5a <printint+0x66>
    buf[i++] = '-';
     f46:	fd070793          	add	a5,a4,-48
     f4a:	00878733          	add	a4,a5,s0
     f4e:	02d00793          	li	a5,45
     f52:	fef70823          	sb	a5,-16(a4)
     f56:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f5a:	02e05863          	blez	a4,f8a <printint+0x96>
     f5e:	fc040793          	add	a5,s0,-64
     f62:	00e78933          	add	s2,a5,a4
     f66:	fff78993          	add	s3,a5,-1
     f6a:	99ba                	add	s3,s3,a4
     f6c:	377d                	addw	a4,a4,-1
     f6e:	1702                	sll	a4,a4,0x20
     f70:	9301                	srl	a4,a4,0x20
     f72:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f76:	fff94583          	lbu	a1,-1(s2)
     f7a:	8526                	mv	a0,s1
     f7c:	00000097          	auipc	ra,0x0
     f80:	f56080e7          	jalr	-170(ra) # ed2 <putc>
  while(--i >= 0)
     f84:	197d                	add	s2,s2,-1
     f86:	ff3918e3          	bne	s2,s3,f76 <printint+0x82>
}
     f8a:	70e2                	ld	ra,56(sp)
     f8c:	7442                	ld	s0,48(sp)
     f8e:	74a2                	ld	s1,40(sp)
     f90:	7902                	ld	s2,32(sp)
     f92:	69e2                	ld	s3,24(sp)
     f94:	6121                	add	sp,sp,64
     f96:	8082                	ret
    x = -xx;
     f98:	40b005bb          	negw	a1,a1
    neg = 1;
     f9c:	4885                	li	a7,1
    x = -xx;
     f9e:	bf85                	j	f0e <printint+0x1a>

0000000000000fa0 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fa0:	711d                	add	sp,sp,-96
     fa2:	ec86                	sd	ra,88(sp)
     fa4:	e8a2                	sd	s0,80(sp)
     fa6:	e4a6                	sd	s1,72(sp)
     fa8:	e0ca                	sd	s2,64(sp)
     faa:	fc4e                	sd	s3,56(sp)
     fac:	f852                	sd	s4,48(sp)
     fae:	f456                	sd	s5,40(sp)
     fb0:	f05a                	sd	s6,32(sp)
     fb2:	ec5e                	sd	s7,24(sp)
     fb4:	e862                	sd	s8,16(sp)
     fb6:	e466                	sd	s9,8(sp)
     fb8:	e06a                	sd	s10,0(sp)
     fba:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fbc:	0005c903          	lbu	s2,0(a1)
     fc0:	28090963          	beqz	s2,1252 <vprintf+0x2b2>
     fc4:	8b2a                	mv	s6,a0
     fc6:	8a2e                	mv	s4,a1
     fc8:	8bb2                	mv	s7,a2
  state = 0;
     fca:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     fcc:	4481                	li	s1,0
     fce:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     fd0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     fd4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     fd8:	06c00c93          	li	s9,108
     fdc:	a015                	j	1000 <vprintf+0x60>
        putc(fd, c0);
     fde:	85ca                	mv	a1,s2
     fe0:	855a                	mv	a0,s6
     fe2:	00000097          	auipc	ra,0x0
     fe6:	ef0080e7          	jalr	-272(ra) # ed2 <putc>
     fea:	a019                	j	ff0 <vprintf+0x50>
    } else if(state == '%'){
     fec:	03598263          	beq	s3,s5,1010 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
     ff0:	2485                	addw	s1,s1,1
     ff2:	8726                	mv	a4,s1
     ff4:	009a07b3          	add	a5,s4,s1
     ff8:	0007c903          	lbu	s2,0(a5)
     ffc:	24090b63          	beqz	s2,1252 <vprintf+0x2b2>
    c0 = fmt[i] & 0xff;
    1000:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1004:	fe0994e3          	bnez	s3,fec <vprintf+0x4c>
      if(c0 == '%'){
    1008:	fd579be3          	bne	a5,s5,fde <vprintf+0x3e>
        state = '%';
    100c:	89be                	mv	s3,a5
    100e:	b7cd                	j	ff0 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
    1010:	cbc9                	beqz	a5,10a2 <vprintf+0x102>
    1012:	00ea06b3          	add	a3,s4,a4
    1016:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    101a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    101c:	c681                	beqz	a3,1024 <vprintf+0x84>
    101e:	9752                	add	a4,a4,s4
    1020:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1024:	05878163          	beq	a5,s8,1066 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
    1028:	05978d63          	beq	a5,s9,1082 <vprintf+0xe2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    102c:	07500713          	li	a4,117
    1030:	10e78163          	beq	a5,a4,1132 <vprintf+0x192>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1034:	07800713          	li	a4,120
    1038:	14e78963          	beq	a5,a4,118a <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    103c:	07000713          	li	a4,112
    1040:	18e78263          	beq	a5,a4,11c4 <vprintf+0x224>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1044:	07300713          	li	a4,115
    1048:	1ce78663          	beq	a5,a4,1214 <vprintf+0x274>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    104c:	02500713          	li	a4,37
    1050:	04e79963          	bne	a5,a4,10a2 <vprintf+0x102>
        putc(fd, '%');
    1054:	02500593          	li	a1,37
    1058:	855a                	mv	a0,s6
    105a:	00000097          	auipc	ra,0x0
    105e:	e78080e7          	jalr	-392(ra) # ed2 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1062:	4981                	li	s3,0
    1064:	b771                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
    1066:	008b8913          	add	s2,s7,8
    106a:	4685                	li	a3,1
    106c:	4629                	li	a2,10
    106e:	000ba583          	lw	a1,0(s7)
    1072:	855a                	mv	a0,s6
    1074:	00000097          	auipc	ra,0x0
    1078:	e80080e7          	jalr	-384(ra) # ef4 <printint>
    107c:	8bca                	mv	s7,s2
      state = 0;
    107e:	4981                	li	s3,0
    1080:	bf85                	j	ff0 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
    1082:	06400793          	li	a5,100
    1086:	02f68d63          	beq	a3,a5,10c0 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    108a:	06c00793          	li	a5,108
    108e:	04f68863          	beq	a3,a5,10de <vprintf+0x13e>
      } else if(c0 == 'l' && c1 == 'u'){
    1092:	07500793          	li	a5,117
    1096:	0af68c63          	beq	a3,a5,114e <vprintf+0x1ae>
      } else if(c0 == 'l' && c1 == 'x'){
    109a:	07800793          	li	a5,120
    109e:	10f68463          	beq	a3,a5,11a6 <vprintf+0x206>
        putc(fd, '%');
    10a2:	02500593          	li	a1,37
    10a6:	855a                	mv	a0,s6
    10a8:	00000097          	auipc	ra,0x0
    10ac:	e2a080e7          	jalr	-470(ra) # ed2 <putc>
        putc(fd, c0);
    10b0:	85ca                	mv	a1,s2
    10b2:	855a                	mv	a0,s6
    10b4:	00000097          	auipc	ra,0x0
    10b8:	e1e080e7          	jalr	-482(ra) # ed2 <putc>
      state = 0;
    10bc:	4981                	li	s3,0
    10be:	bf0d                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
    10c0:	008b8913          	add	s2,s7,8
    10c4:	4685                	li	a3,1
    10c6:	4629                	li	a2,10
    10c8:	000ba583          	lw	a1,0(s7)
    10cc:	855a                	mv	a0,s6
    10ce:	00000097          	auipc	ra,0x0
    10d2:	e26080e7          	jalr	-474(ra) # ef4 <printint>
        i += 1;
    10d6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    10d8:	8bca                	mv	s7,s2
      state = 0;
    10da:	4981                	li	s3,0
        i += 1;
    10dc:	bf11                	j	ff0 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    10de:	06400793          	li	a5,100
    10e2:	02f60963          	beq	a2,a5,1114 <vprintf+0x174>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    10e6:	07500793          	li	a5,117
    10ea:	08f60163          	beq	a2,a5,116c <vprintf+0x1cc>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    10ee:	07800793          	li	a5,120
    10f2:	faf618e3          	bne	a2,a5,10a2 <vprintf+0x102>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10f6:	008b8913          	add	s2,s7,8
    10fa:	4681                	li	a3,0
    10fc:	4641                	li	a2,16
    10fe:	000ba583          	lw	a1,0(s7)
    1102:	855a                	mv	a0,s6
    1104:	00000097          	auipc	ra,0x0
    1108:	df0080e7          	jalr	-528(ra) # ef4 <printint>
        i += 2;
    110c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    110e:	8bca                	mv	s7,s2
      state = 0;
    1110:	4981                	li	s3,0
        i += 2;
    1112:	bdf9                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1114:	008b8913          	add	s2,s7,8
    1118:	4685                	li	a3,1
    111a:	4629                	li	a2,10
    111c:	000ba583          	lw	a1,0(s7)
    1120:	855a                	mv	a0,s6
    1122:	00000097          	auipc	ra,0x0
    1126:	dd2080e7          	jalr	-558(ra) # ef4 <printint>
        i += 2;
    112a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    112c:	8bca                	mv	s7,s2
      state = 0;
    112e:	4981                	li	s3,0
        i += 2;
    1130:	b5c1                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 0);
    1132:	008b8913          	add	s2,s7,8
    1136:	4681                	li	a3,0
    1138:	4629                	li	a2,10
    113a:	000ba583          	lw	a1,0(s7)
    113e:	855a                	mv	a0,s6
    1140:	00000097          	auipc	ra,0x0
    1144:	db4080e7          	jalr	-588(ra) # ef4 <printint>
    1148:	8bca                	mv	s7,s2
      state = 0;
    114a:	4981                	li	s3,0
    114c:	b555                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
    114e:	008b8913          	add	s2,s7,8
    1152:	4681                	li	a3,0
    1154:	4629                	li	a2,10
    1156:	000ba583          	lw	a1,0(s7)
    115a:	855a                	mv	a0,s6
    115c:	00000097          	auipc	ra,0x0
    1160:	d98080e7          	jalr	-616(ra) # ef4 <printint>
        i += 1;
    1164:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1166:	8bca                	mv	s7,s2
      state = 0;
    1168:	4981                	li	s3,0
        i += 1;
    116a:	b559                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
    116c:	008b8913          	add	s2,s7,8
    1170:	4681                	li	a3,0
    1172:	4629                	li	a2,10
    1174:	000ba583          	lw	a1,0(s7)
    1178:	855a                	mv	a0,s6
    117a:	00000097          	auipc	ra,0x0
    117e:	d7a080e7          	jalr	-646(ra) # ef4 <printint>
        i += 2;
    1182:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1184:	8bca                	mv	s7,s2
      state = 0;
    1186:	4981                	li	s3,0
        i += 2;
    1188:	b5a5                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 16, 0);
    118a:	008b8913          	add	s2,s7,8
    118e:	4681                	li	a3,0
    1190:	4641                	li	a2,16
    1192:	000ba583          	lw	a1,0(s7)
    1196:	855a                	mv	a0,s6
    1198:	00000097          	auipc	ra,0x0
    119c:	d5c080e7          	jalr	-676(ra) # ef4 <printint>
    11a0:	8bca                	mv	s7,s2
      state = 0;
    11a2:	4981                	li	s3,0
    11a4:	b5b1                	j	ff0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
    11a6:	008b8913          	add	s2,s7,8
    11aa:	4681                	li	a3,0
    11ac:	4641                	li	a2,16
    11ae:	000ba583          	lw	a1,0(s7)
    11b2:	855a                	mv	a0,s6
    11b4:	00000097          	auipc	ra,0x0
    11b8:	d40080e7          	jalr	-704(ra) # ef4 <printint>
        i += 1;
    11bc:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    11be:	8bca                	mv	s7,s2
      state = 0;
    11c0:	4981                	li	s3,0
        i += 1;
    11c2:	b53d                	j	ff0 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
    11c4:	008b8d13          	add	s10,s7,8
    11c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    11cc:	03000593          	li	a1,48
    11d0:	855a                	mv	a0,s6
    11d2:	00000097          	auipc	ra,0x0
    11d6:	d00080e7          	jalr	-768(ra) # ed2 <putc>
  putc(fd, 'x');
    11da:	07800593          	li	a1,120
    11de:	855a                	mv	a0,s6
    11e0:	00000097          	auipc	ra,0x0
    11e4:	cf2080e7          	jalr	-782(ra) # ed2 <putc>
    11e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11ea:	00000b97          	auipc	s7,0x0
    11ee:	5a6b8b93          	add	s7,s7,1446 # 1790 <digits>
    11f2:	03c9d793          	srl	a5,s3,0x3c
    11f6:	97de                	add	a5,a5,s7
    11f8:	0007c583          	lbu	a1,0(a5)
    11fc:	855a                	mv	a0,s6
    11fe:	00000097          	auipc	ra,0x0
    1202:	cd4080e7          	jalr	-812(ra) # ed2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1206:	0992                	sll	s3,s3,0x4
    1208:	397d                	addw	s2,s2,-1
    120a:	fe0914e3          	bnez	s2,11f2 <vprintf+0x252>
        printptr(fd, va_arg(ap, uint64));
    120e:	8bea                	mv	s7,s10
      state = 0;
    1210:	4981                	li	s3,0
    1212:	bbf9                	j	ff0 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
    1214:	008b8993          	add	s3,s7,8
    1218:	000bb903          	ld	s2,0(s7)
    121c:	02090163          	beqz	s2,123e <vprintf+0x29e>
        for(; *s; s++)
    1220:	00094583          	lbu	a1,0(s2)
    1224:	c585                	beqz	a1,124c <vprintf+0x2ac>
          putc(fd, *s);
    1226:	855a                	mv	a0,s6
    1228:	00000097          	auipc	ra,0x0
    122c:	caa080e7          	jalr	-854(ra) # ed2 <putc>
        for(; *s; s++)
    1230:	0905                	add	s2,s2,1
    1232:	00094583          	lbu	a1,0(s2)
    1236:	f9e5                	bnez	a1,1226 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
    1238:	8bce                	mv	s7,s3
      state = 0;
    123a:	4981                	li	s3,0
    123c:	bb55                	j	ff0 <vprintf+0x50>
          s = "(null)";
    123e:	00000917          	auipc	s2,0x0
    1242:	54a90913          	add	s2,s2,1354 # 1788 <malloc+0x434>
        for(; *s; s++)
    1246:	02800593          	li	a1,40
    124a:	bff1                	j	1226 <vprintf+0x286>
        if((s = va_arg(ap, char*)) == 0)
    124c:	8bce                	mv	s7,s3
      state = 0;
    124e:	4981                	li	s3,0
    1250:	b345                	j	ff0 <vprintf+0x50>
    }
  }
}
    1252:	60e6                	ld	ra,88(sp)
    1254:	6446                	ld	s0,80(sp)
    1256:	64a6                	ld	s1,72(sp)
    1258:	6906                	ld	s2,64(sp)
    125a:	79e2                	ld	s3,56(sp)
    125c:	7a42                	ld	s4,48(sp)
    125e:	7aa2                	ld	s5,40(sp)
    1260:	7b02                	ld	s6,32(sp)
    1262:	6be2                	ld	s7,24(sp)
    1264:	6c42                	ld	s8,16(sp)
    1266:	6ca2                	ld	s9,8(sp)
    1268:	6d02                	ld	s10,0(sp)
    126a:	6125                	add	sp,sp,96
    126c:	8082                	ret

000000000000126e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    126e:	715d                	add	sp,sp,-80
    1270:	ec06                	sd	ra,24(sp)
    1272:	e822                	sd	s0,16(sp)
    1274:	1000                	add	s0,sp,32
    1276:	e010                	sd	a2,0(s0)
    1278:	e414                	sd	a3,8(s0)
    127a:	e818                	sd	a4,16(s0)
    127c:	ec1c                	sd	a5,24(s0)
    127e:	03043023          	sd	a6,32(s0)
    1282:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1286:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    128a:	8622                	mv	a2,s0
    128c:	00000097          	auipc	ra,0x0
    1290:	d14080e7          	jalr	-748(ra) # fa0 <vprintf>
}
    1294:	60e2                	ld	ra,24(sp)
    1296:	6442                	ld	s0,16(sp)
    1298:	6161                	add	sp,sp,80
    129a:	8082                	ret

000000000000129c <printf>:

void
printf(const char *fmt, ...)
{
    129c:	711d                	add	sp,sp,-96
    129e:	ec06                	sd	ra,24(sp)
    12a0:	e822                	sd	s0,16(sp)
    12a2:	1000                	add	s0,sp,32
    12a4:	e40c                	sd	a1,8(s0)
    12a6:	e810                	sd	a2,16(s0)
    12a8:	ec14                	sd	a3,24(s0)
    12aa:	f018                	sd	a4,32(s0)
    12ac:	f41c                	sd	a5,40(s0)
    12ae:	03043823          	sd	a6,48(s0)
    12b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12b6:	00840613          	add	a2,s0,8
    12ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12be:	85aa                	mv	a1,a0
    12c0:	4505                	li	a0,1
    12c2:	00000097          	auipc	ra,0x0
    12c6:	cde080e7          	jalr	-802(ra) # fa0 <vprintf>
}
    12ca:	60e2                	ld	ra,24(sp)
    12cc:	6442                	ld	s0,16(sp)
    12ce:	6125                	add	sp,sp,96
    12d0:	8082                	ret

00000000000012d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12d2:	1141                	add	sp,sp,-16
    12d4:	e422                	sd	s0,8(sp)
    12d6:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12d8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12dc:	00001797          	auipc	a5,0x1
    12e0:	d347b783          	ld	a5,-716(a5) # 2010 <freep>
    12e4:	a02d                	j	130e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12e6:	4618                	lw	a4,8(a2)
    12e8:	9f2d                	addw	a4,a4,a1
    12ea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    12ee:	6398                	ld	a4,0(a5)
    12f0:	6310                	ld	a2,0(a4)
    12f2:	a83d                	j	1330 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    12f4:	ff852703          	lw	a4,-8(a0)
    12f8:	9f31                	addw	a4,a4,a2
    12fa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    12fc:	ff053683          	ld	a3,-16(a0)
    1300:	a091                	j	1344 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1302:	6398                	ld	a4,0(a5)
    1304:	00e7e463          	bltu	a5,a4,130c <free+0x3a>
    1308:	00e6ea63          	bltu	a3,a4,131c <free+0x4a>
{
    130c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    130e:	fed7fae3          	bgeu	a5,a3,1302 <free+0x30>
    1312:	6398                	ld	a4,0(a5)
    1314:	00e6e463          	bltu	a3,a4,131c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1318:	fee7eae3          	bltu	a5,a4,130c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    131c:	ff852583          	lw	a1,-8(a0)
    1320:	6390                	ld	a2,0(a5)
    1322:	02059813          	sll	a6,a1,0x20
    1326:	01c85713          	srl	a4,a6,0x1c
    132a:	9736                	add	a4,a4,a3
    132c:	fae60de3          	beq	a2,a4,12e6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1330:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1334:	4790                	lw	a2,8(a5)
    1336:	02061593          	sll	a1,a2,0x20
    133a:	01c5d713          	srl	a4,a1,0x1c
    133e:	973e                	add	a4,a4,a5
    1340:	fae68ae3          	beq	a3,a4,12f4 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1344:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1346:	00001717          	auipc	a4,0x1
    134a:	ccf73523          	sd	a5,-822(a4) # 2010 <freep>
}
    134e:	6422                	ld	s0,8(sp)
    1350:	0141                	add	sp,sp,16
    1352:	8082                	ret

0000000000001354 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1354:	7139                	add	sp,sp,-64
    1356:	fc06                	sd	ra,56(sp)
    1358:	f822                	sd	s0,48(sp)
    135a:	f426                	sd	s1,40(sp)
    135c:	f04a                	sd	s2,32(sp)
    135e:	ec4e                	sd	s3,24(sp)
    1360:	e852                	sd	s4,16(sp)
    1362:	e456                	sd	s5,8(sp)
    1364:	e05a                	sd	s6,0(sp)
    1366:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1368:	02051493          	sll	s1,a0,0x20
    136c:	9081                	srl	s1,s1,0x20
    136e:	04bd                	add	s1,s1,15
    1370:	8091                	srl	s1,s1,0x4
    1372:	0014899b          	addw	s3,s1,1
    1376:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    1378:	00001517          	auipc	a0,0x1
    137c:	c9853503          	ld	a0,-872(a0) # 2010 <freep>
    1380:	c515                	beqz	a0,13ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1382:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1384:	4798                	lw	a4,8(a5)
    1386:	02977f63          	bgeu	a4,s1,13c4 <malloc+0x70>
  if(nu < 4096)
    138a:	8a4e                	mv	s4,s3
    138c:	0009871b          	sext.w	a4,s3
    1390:	6685                	lui	a3,0x1
    1392:	00d77363          	bgeu	a4,a3,1398 <malloc+0x44>
    1396:	6a05                	lui	s4,0x1
    1398:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    139c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    13a0:	00001917          	auipc	s2,0x1
    13a4:	c7090913          	add	s2,s2,-912 # 2010 <freep>
  if(p == (char*)-1)
    13a8:	5afd                	li	s5,-1
    13aa:	a895                	j	141e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    13ac:	00001797          	auipc	a5,0x1
    13b0:	05c78793          	add	a5,a5,92 # 2408 <base>
    13b4:	00001717          	auipc	a4,0x1
    13b8:	c4f73e23          	sd	a5,-932(a4) # 2010 <freep>
    13bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13c2:	b7e1                	j	138a <malloc+0x36>
      if(p->s.size == nunits)
    13c4:	02e48c63          	beq	s1,a4,13fc <malloc+0xa8>
        p->s.size -= nunits;
    13c8:	4137073b          	subw	a4,a4,s3
    13cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13ce:	02071693          	sll	a3,a4,0x20
    13d2:	01c6d713          	srl	a4,a3,0x1c
    13d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13dc:	00001717          	auipc	a4,0x1
    13e0:	c2a73a23          	sd	a0,-972(a4) # 2010 <freep>
      return (void*)(p + 1);
    13e4:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    13e8:	70e2                	ld	ra,56(sp)
    13ea:	7442                	ld	s0,48(sp)
    13ec:	74a2                	ld	s1,40(sp)
    13ee:	7902                	ld	s2,32(sp)
    13f0:	69e2                	ld	s3,24(sp)
    13f2:	6a42                	ld	s4,16(sp)
    13f4:	6aa2                	ld	s5,8(sp)
    13f6:	6b02                	ld	s6,0(sp)
    13f8:	6121                	add	sp,sp,64
    13fa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    13fc:	6398                	ld	a4,0(a5)
    13fe:	e118                	sd	a4,0(a0)
    1400:	bff1                	j	13dc <malloc+0x88>
  hp->s.size = nu;
    1402:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1406:	0541                	add	a0,a0,16
    1408:	00000097          	auipc	ra,0x0
    140c:	eca080e7          	jalr	-310(ra) # 12d2 <free>
  return freep;
    1410:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1414:	d971                	beqz	a0,13e8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1416:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1418:	4798                	lw	a4,8(a5)
    141a:	fa9775e3          	bgeu	a4,s1,13c4 <malloc+0x70>
    if(p == freep)
    141e:	00093703          	ld	a4,0(s2)
    1422:	853e                	mv	a0,a5
    1424:	fef719e3          	bne	a4,a5,1416 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1428:	8552                	mv	a0,s4
    142a:	00000097          	auipc	ra,0x0
    142e:	a90080e7          	jalr	-1392(ra) # eba <sbrk>
  if(p == (char*)-1)
    1432:	fd5518e3          	bne	a0,s5,1402 <malloc+0xae>
        return 0;
    1436:	4501                	li	a0,0
    1438:	bf45                	j	13e8 <malloc+0x94>
