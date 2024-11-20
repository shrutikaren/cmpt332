
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
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	add	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7119                	add	sp,sp,-128
      76:	fc86                	sd	ra,120(sp)
      78:	f8a2                	sd	s0,112(sp)
      7a:	f4a6                	sd	s1,104(sp)
      7c:	f0ca                	sd	s2,96(sp)
      7e:	ecce                	sd	s3,88(sp)
      80:	e8d2                	sd	s4,80(sp)
      82:	e4d6                	sd	s5,72(sp)
      84:	e0da                	sd	s6,64(sp)
      86:	fc5e                	sd	s7,56(sp)
      88:	0100                	add	s0,sp,128
      8a:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8c:	4501                	li	a0,0
      8e:	335000ef          	jal	bc2 <sbrk>
      92:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      94:	00001517          	auipc	a0,0x1
      98:	05c50513          	add	a0,a0,92 # 10f0 <malloc+0xe0>
      9c:	307000ef          	jal	ba2 <mkdir>
  if(chdir("grindir") != 0){
      a0:	00001517          	auipc	a0,0x1
      a4:	05050513          	add	a0,a0,80 # 10f0 <malloc+0xe0>
      a8:	303000ef          	jal	baa <chdir>
      ac:	c911                	beqz	a0,c0 <go+0x4c>
    printf("grind: chdir grindir failed\n");
      ae:	00001517          	auipc	a0,0x1
      b2:	04a50513          	add	a0,a0,74 # 10f8 <malloc+0xe8>
      b6:	6a7000ef          	jal	f5c <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	27f000ef          	jal	b3a <exit>
  }
  chdir("/");
      c0:	00001517          	auipc	a0,0x1
      c4:	05850513          	add	a0,a0,88 # 1118 <malloc+0x108>
      c8:	2e3000ef          	jal	baa <chdir>
      cc:	00001997          	auipc	s3,0x1
      d0:	05c98993          	add	s3,s3,92 # 1128 <malloc+0x118>
      d4:	c489                	beqz	s1,de <go+0x6a>
      d6:	00001997          	auipc	s3,0x1
      da:	04a98993          	add	s3,s3,74 # 1120 <malloc+0x110>
  uint64 iters = 0;
      de:	4481                	li	s1,0
  int fd = -1;
      e0:	5a7d                	li	s4,-1
      e2:	00001917          	auipc	s2,0x1
      e6:	2f690913          	add	s2,s2,758 # 13d8 <malloc+0x3c8>
      ea:	a819                	j	100 <go+0x8c>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
      ec:	20200593          	li	a1,514
      f0:	00001517          	auipc	a0,0x1
      f4:	04050513          	add	a0,a0,64 # 1130 <malloc+0x120>
      f8:	283000ef          	jal	b7a <open>
      fc:	267000ef          	jal	b62 <close>
    iters++;
     100:	0485                	add	s1,s1,1
    if((iters % 500) == 0)
     102:	1f400793          	li	a5,500
     106:	02f4f7b3          	remu	a5,s1,a5
     10a:	e791                	bnez	a5,116 <go+0xa2>
      write(1, which_child?"B":"A", 1);
     10c:	4605                	li	a2,1
     10e:	85ce                	mv	a1,s3
     110:	4505                	li	a0,1
     112:	249000ef          	jal	b5a <write>
    int what = rand() % 23;
     116:	f43ff0ef          	jal	58 <rand>
     11a:	47dd                	li	a5,23
     11c:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     120:	4785                	li	a5,1
     122:	fcf505e3          	beq	a0,a5,ec <go+0x78>
    } else if(what == 2){
     126:	47d9                	li	a5,22
     128:	fca7ece3          	bltu	a5,a0,100 <go+0x8c>
     12c:	050a                	sll	a0,a0,0x2
     12e:	954a                	add	a0,a0,s2
     130:	411c                	lw	a5,0(a0)
     132:	97ca                	add	a5,a5,s2
     134:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     136:	20200593          	li	a1,514
     13a:	00001517          	auipc	a0,0x1
     13e:	00650513          	add	a0,a0,6 # 1140 <malloc+0x130>
     142:	239000ef          	jal	b7a <open>
     146:	21d000ef          	jal	b62 <close>
     14a:	bf5d                	j	100 <go+0x8c>
    } else if(what == 3){
      unlink("grindir/../a");
     14c:	00001517          	auipc	a0,0x1
     150:	fe450513          	add	a0,a0,-28 # 1130 <malloc+0x120>
     154:	237000ef          	jal	b8a <unlink>
     158:	b765                	j	100 <go+0x8c>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     15a:	00001517          	auipc	a0,0x1
     15e:	f9650513          	add	a0,a0,-106 # 10f0 <malloc+0xe0>
     162:	249000ef          	jal	baa <chdir>
     166:	ed11                	bnez	a0,182 <go+0x10e>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     168:	00001517          	auipc	a0,0x1
     16c:	ff050513          	add	a0,a0,-16 # 1158 <malloc+0x148>
     170:	21b000ef          	jal	b8a <unlink>
      chdir("/");
     174:	00001517          	auipc	a0,0x1
     178:	fa450513          	add	a0,a0,-92 # 1118 <malloc+0x108>
     17c:	22f000ef          	jal	baa <chdir>
     180:	b741                	j	100 <go+0x8c>
        printf("grind: chdir grindir failed\n");
     182:	00001517          	auipc	a0,0x1
     186:	f7650513          	add	a0,a0,-138 # 10f8 <malloc+0xe8>
     18a:	5d3000ef          	jal	f5c <printf>
        exit(1);
     18e:	4505                	li	a0,1
     190:	1ab000ef          	jal	b3a <exit>
    } else if(what == 5){
      close(fd);
     194:	8552                	mv	a0,s4
     196:	1cd000ef          	jal	b62 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     19a:	20200593          	li	a1,514
     19e:	00001517          	auipc	a0,0x1
     1a2:	fc250513          	add	a0,a0,-62 # 1160 <malloc+0x150>
     1a6:	1d5000ef          	jal	b7a <open>
     1aa:	8a2a                	mv	s4,a0
     1ac:	bf91                	j	100 <go+0x8c>
    } else if(what == 6){
      close(fd);
     1ae:	8552                	mv	a0,s4
     1b0:	1b3000ef          	jal	b62 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     1b4:	20200593          	li	a1,514
     1b8:	00001517          	auipc	a0,0x1
     1bc:	fb850513          	add	a0,a0,-72 # 1170 <malloc+0x160>
     1c0:	1bb000ef          	jal	b7a <open>
     1c4:	8a2a                	mv	s4,a0
     1c6:	bf2d                	j	100 <go+0x8c>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     1c8:	3e700613          	li	a2,999
     1cc:	00002597          	auipc	a1,0x2
     1d0:	e5458593          	add	a1,a1,-428 # 2020 <buf.0>
     1d4:	8552                	mv	a0,s4
     1d6:	185000ef          	jal	b5a <write>
     1da:	b71d                	j	100 <go+0x8c>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     1dc:	3e700613          	li	a2,999
     1e0:	00002597          	auipc	a1,0x2
     1e4:	e4058593          	add	a1,a1,-448 # 2020 <buf.0>
     1e8:	8552                	mv	a0,s4
     1ea:	169000ef          	jal	b52 <read>
     1ee:	bf09                	j	100 <go+0x8c>
    } else if(what == 9){
      mkdir("grindir/../a");
     1f0:	00001517          	auipc	a0,0x1
     1f4:	f4050513          	add	a0,a0,-192 # 1130 <malloc+0x120>
     1f8:	1ab000ef          	jal	ba2 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     1fc:	20200593          	li	a1,514
     200:	00001517          	auipc	a0,0x1
     204:	f8850513          	add	a0,a0,-120 # 1188 <malloc+0x178>
     208:	173000ef          	jal	b7a <open>
     20c:	157000ef          	jal	b62 <close>
      unlink("a/a");
     210:	00001517          	auipc	a0,0x1
     214:	f8850513          	add	a0,a0,-120 # 1198 <malloc+0x188>
     218:	173000ef          	jal	b8a <unlink>
     21c:	b5d5                	j	100 <go+0x8c>
    } else if(what == 10){
      mkdir("/../b");
     21e:	00001517          	auipc	a0,0x1
     222:	f8250513          	add	a0,a0,-126 # 11a0 <malloc+0x190>
     226:	17d000ef          	jal	ba2 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     22a:	20200593          	li	a1,514
     22e:	00001517          	auipc	a0,0x1
     232:	f7a50513          	add	a0,a0,-134 # 11a8 <malloc+0x198>
     236:	145000ef          	jal	b7a <open>
     23a:	129000ef          	jal	b62 <close>
      unlink("b/b");
     23e:	00001517          	auipc	a0,0x1
     242:	f7a50513          	add	a0,a0,-134 # 11b8 <malloc+0x1a8>
     246:	145000ef          	jal	b8a <unlink>
     24a:	bd5d                	j	100 <go+0x8c>
    } else if(what == 11){
      unlink("b");
     24c:	00001517          	auipc	a0,0x1
     250:	f3450513          	add	a0,a0,-204 # 1180 <malloc+0x170>
     254:	137000ef          	jal	b8a <unlink>
      link("../grindir/./../a", "../b");
     258:	00001597          	auipc	a1,0x1
     25c:	f0058593          	add	a1,a1,-256 # 1158 <malloc+0x148>
     260:	00001517          	auipc	a0,0x1
     264:	f6050513          	add	a0,a0,-160 # 11c0 <malloc+0x1b0>
     268:	133000ef          	jal	b9a <link>
     26c:	bd51                	j	100 <go+0x8c>
    } else if(what == 12){
      unlink("../grindir/../a");
     26e:	00001517          	auipc	a0,0x1
     272:	f6a50513          	add	a0,a0,-150 # 11d8 <malloc+0x1c8>
     276:	115000ef          	jal	b8a <unlink>
      link(".././b", "/grindir/../a");
     27a:	00001597          	auipc	a1,0x1
     27e:	ee658593          	add	a1,a1,-282 # 1160 <malloc+0x150>
     282:	00001517          	auipc	a0,0x1
     286:	f6650513          	add	a0,a0,-154 # 11e8 <malloc+0x1d8>
     28a:	111000ef          	jal	b9a <link>
     28e:	bd8d                	j	100 <go+0x8c>
    } else if(what == 13){
      int pid = fork();
     290:	0a3000ef          	jal	b32 <fork>
      if(pid == 0){
     294:	c519                	beqz	a0,2a2 <go+0x22e>
        exit(0);
      } else if(pid < 0){
     296:	00054863          	bltz	a0,2a6 <go+0x232>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     29a:	4501                	li	a0,0
     29c:	0a7000ef          	jal	b42 <wait>
     2a0:	b585                	j	100 <go+0x8c>
        exit(0);
     2a2:	099000ef          	jal	b3a <exit>
        printf("grind: fork failed\n");
     2a6:	00001517          	auipc	a0,0x1
     2aa:	f4a50513          	add	a0,a0,-182 # 11f0 <malloc+0x1e0>
     2ae:	4af000ef          	jal	f5c <printf>
        exit(1);
     2b2:	4505                	li	a0,1
     2b4:	087000ef          	jal	b3a <exit>
    } else if(what == 14){
      int pid = fork();
     2b8:	07b000ef          	jal	b32 <fork>
      if(pid == 0){
     2bc:	c519                	beqz	a0,2ca <go+0x256>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     2be:	00054d63          	bltz	a0,2d8 <go+0x264>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2c2:	4501                	li	a0,0
     2c4:	07f000ef          	jal	b42 <wait>
     2c8:	bd25                	j	100 <go+0x8c>
        fork();
     2ca:	069000ef          	jal	b32 <fork>
        fork();
     2ce:	065000ef          	jal	b32 <fork>
        exit(0);
     2d2:	4501                	li	a0,0
     2d4:	067000ef          	jal	b3a <exit>
        printf("grind: fork failed\n");
     2d8:	00001517          	auipc	a0,0x1
     2dc:	f1850513          	add	a0,a0,-232 # 11f0 <malloc+0x1e0>
     2e0:	47d000ef          	jal	f5c <printf>
        exit(1);
     2e4:	4505                	li	a0,1
     2e6:	055000ef          	jal	b3a <exit>
    } else if(what == 15){
      sbrk(6011);
     2ea:	6505                	lui	a0,0x1
     2ec:	77b50513          	add	a0,a0,1915 # 177b <digits+0x33b>
     2f0:	0d3000ef          	jal	bc2 <sbrk>
     2f4:	b531                	j	100 <go+0x8c>
    } else if(what == 16){
      if(sbrk(0) > break0)
     2f6:	4501                	li	a0,0
     2f8:	0cb000ef          	jal	bc2 <sbrk>
     2fc:	e0aaf2e3          	bgeu	s5,a0,100 <go+0x8c>
        sbrk(-(sbrk(0) - break0));
     300:	4501                	li	a0,0
     302:	0c1000ef          	jal	bc2 <sbrk>
     306:	40aa853b          	subw	a0,s5,a0
     30a:	0b9000ef          	jal	bc2 <sbrk>
     30e:	bbcd                	j	100 <go+0x8c>
    } else if(what == 17){
      int pid = fork();
     310:	023000ef          	jal	b32 <fork>
     314:	8b2a                	mv	s6,a0
      if(pid == 0){
     316:	c10d                	beqz	a0,338 <go+0x2c4>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     318:	02054d63          	bltz	a0,352 <go+0x2de>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     31c:	00001517          	auipc	a0,0x1
     320:	eec50513          	add	a0,a0,-276 # 1208 <malloc+0x1f8>
     324:	087000ef          	jal	baa <chdir>
     328:	ed15                	bnez	a0,364 <go+0x2f0>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     32a:	855a                	mv	a0,s6
     32c:	03f000ef          	jal	b6a <kill>
      wait(0);
     330:	4501                	li	a0,0
     332:	011000ef          	jal	b42 <wait>
     336:	b3e9                	j	100 <go+0x8c>
        close(open("a", O_CREATE|O_RDWR));
     338:	20200593          	li	a1,514
     33c:	00001517          	auipc	a0,0x1
     340:	e9450513          	add	a0,a0,-364 # 11d0 <malloc+0x1c0>
     344:	037000ef          	jal	b7a <open>
     348:	01b000ef          	jal	b62 <close>
        exit(0);
     34c:	4501                	li	a0,0
     34e:	7ec000ef          	jal	b3a <exit>
        printf("grind: fork failed\n");
     352:	00001517          	auipc	a0,0x1
     356:	e9e50513          	add	a0,a0,-354 # 11f0 <malloc+0x1e0>
     35a:	403000ef          	jal	f5c <printf>
        exit(1);
     35e:	4505                	li	a0,1
     360:	7da000ef          	jal	b3a <exit>
        printf("grind: chdir failed\n");
     364:	00001517          	auipc	a0,0x1
     368:	eb450513          	add	a0,a0,-332 # 1218 <malloc+0x208>
     36c:	3f1000ef          	jal	f5c <printf>
        exit(1);
     370:	4505                	li	a0,1
     372:	7c8000ef          	jal	b3a <exit>
    } else if(what == 18){
      int pid = fork();
     376:	7bc000ef          	jal	b32 <fork>
      if(pid == 0){
     37a:	c519                	beqz	a0,388 <go+0x314>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     37c:	00054d63          	bltz	a0,396 <go+0x322>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     380:	4501                	li	a0,0
     382:	7c0000ef          	jal	b42 <wait>
     386:	bbad                	j	100 <go+0x8c>
        kill(getpid());
     388:	033000ef          	jal	bba <getpid>
     38c:	7de000ef          	jal	b6a <kill>
        exit(0);
     390:	4501                	li	a0,0
     392:	7a8000ef          	jal	b3a <exit>
        printf("grind: fork failed\n");
     396:	00001517          	auipc	a0,0x1
     39a:	e5a50513          	add	a0,a0,-422 # 11f0 <malloc+0x1e0>
     39e:	3bf000ef          	jal	f5c <printf>
        exit(1);
     3a2:	4505                	li	a0,1
     3a4:	796000ef          	jal	b3a <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     3a8:	f9840513          	add	a0,s0,-104
     3ac:	79e000ef          	jal	b4a <pipe>
     3b0:	02054363          	bltz	a0,3d6 <go+0x362>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     3b4:	77e000ef          	jal	b32 <fork>
      if(pid == 0){
     3b8:	c905                	beqz	a0,3e8 <go+0x374>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     3ba:	08054263          	bltz	a0,43e <go+0x3ca>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3be:	f9842503          	lw	a0,-104(s0)
     3c2:	7a0000ef          	jal	b62 <close>
      close(fds[1]);
     3c6:	f9c42503          	lw	a0,-100(s0)
     3ca:	798000ef          	jal	b62 <close>
      wait(0);
     3ce:	4501                	li	a0,0
     3d0:	772000ef          	jal	b42 <wait>
     3d4:	b335                	j	100 <go+0x8c>
        printf("grind: pipe failed\n");
     3d6:	00001517          	auipc	a0,0x1
     3da:	e5a50513          	add	a0,a0,-422 # 1230 <malloc+0x220>
     3de:	37f000ef          	jal	f5c <printf>
        exit(1);
     3e2:	4505                	li	a0,1
     3e4:	756000ef          	jal	b3a <exit>
        fork();
     3e8:	74a000ef          	jal	b32 <fork>
        fork();
     3ec:	746000ef          	jal	b32 <fork>
        if(write(fds[1], "x", 1) != 1)
     3f0:	4605                	li	a2,1
     3f2:	00001597          	auipc	a1,0x1
     3f6:	e5658593          	add	a1,a1,-426 # 1248 <malloc+0x238>
     3fa:	f9c42503          	lw	a0,-100(s0)
     3fe:	75c000ef          	jal	b5a <write>
     402:	4785                	li	a5,1
     404:	00f51f63          	bne	a0,a5,422 <go+0x3ae>
        if(read(fds[0], &c, 1) != 1)
     408:	4605                	li	a2,1
     40a:	f9040593          	add	a1,s0,-112
     40e:	f9842503          	lw	a0,-104(s0)
     412:	740000ef          	jal	b52 <read>
     416:	4785                	li	a5,1
     418:	00f51c63          	bne	a0,a5,430 <go+0x3bc>
        exit(0);
     41c:	4501                	li	a0,0
     41e:	71c000ef          	jal	b3a <exit>
          printf("grind: pipe write failed\n");
     422:	00001517          	auipc	a0,0x1
     426:	e2e50513          	add	a0,a0,-466 # 1250 <malloc+0x240>
     42a:	333000ef          	jal	f5c <printf>
     42e:	bfe9                	j	408 <go+0x394>
          printf("grind: pipe read failed\n");
     430:	00001517          	auipc	a0,0x1
     434:	e4050513          	add	a0,a0,-448 # 1270 <malloc+0x260>
     438:	325000ef          	jal	f5c <printf>
     43c:	b7c5                	j	41c <go+0x3a8>
        printf("grind: fork failed\n");
     43e:	00001517          	auipc	a0,0x1
     442:	db250513          	add	a0,a0,-590 # 11f0 <malloc+0x1e0>
     446:	317000ef          	jal	f5c <printf>
        exit(1);
     44a:	4505                	li	a0,1
     44c:	6ee000ef          	jal	b3a <exit>
    } else if(what == 20){
      int pid = fork();
     450:	6e2000ef          	jal	b32 <fork>
      if(pid == 0){
     454:	c519                	beqz	a0,462 <go+0x3ee>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     456:	04054f63          	bltz	a0,4b4 <go+0x440>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     45a:	4501                	li	a0,0
     45c:	6e6000ef          	jal	b42 <wait>
     460:	b145                	j	100 <go+0x8c>
        unlink("a");
     462:	00001517          	auipc	a0,0x1
     466:	d6e50513          	add	a0,a0,-658 # 11d0 <malloc+0x1c0>
     46a:	720000ef          	jal	b8a <unlink>
        mkdir("a");
     46e:	00001517          	auipc	a0,0x1
     472:	d6250513          	add	a0,a0,-670 # 11d0 <malloc+0x1c0>
     476:	72c000ef          	jal	ba2 <mkdir>
        chdir("a");
     47a:	00001517          	auipc	a0,0x1
     47e:	d5650513          	add	a0,a0,-682 # 11d0 <malloc+0x1c0>
     482:	728000ef          	jal	baa <chdir>
        unlink("../a");
     486:	00001517          	auipc	a0,0x1
     48a:	cb250513          	add	a0,a0,-846 # 1138 <malloc+0x128>
     48e:	6fc000ef          	jal	b8a <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     492:	20200593          	li	a1,514
     496:	00001517          	auipc	a0,0x1
     49a:	db250513          	add	a0,a0,-590 # 1248 <malloc+0x238>
     49e:	6dc000ef          	jal	b7a <open>
        unlink("x");
     4a2:	00001517          	auipc	a0,0x1
     4a6:	da650513          	add	a0,a0,-602 # 1248 <malloc+0x238>
     4aa:	6e0000ef          	jal	b8a <unlink>
        exit(0);
     4ae:	4501                	li	a0,0
     4b0:	68a000ef          	jal	b3a <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	d3c50513          	add	a0,a0,-708 # 11f0 <malloc+0x1e0>
     4bc:	2a1000ef          	jal	f5c <printf>
        exit(1);
     4c0:	4505                	li	a0,1
     4c2:	678000ef          	jal	b3a <exit>
    } else if(what == 21){
      unlink("c");
     4c6:	00001517          	auipc	a0,0x1
     4ca:	dca50513          	add	a0,a0,-566 # 1290 <malloc+0x280>
     4ce:	6bc000ef          	jal	b8a <unlink>
      /* should always succeed. check that there are free i-nodes, */
      /* file descriptors, blocks. */
      int fd1 = open("c", O_CREATE|O_RDWR);
     4d2:	20200593          	li	a1,514
     4d6:	00001517          	auipc	a0,0x1
     4da:	dba50513          	add	a0,a0,-582 # 1290 <malloc+0x280>
     4de:	69c000ef          	jal	b7a <open>
     4e2:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     4e4:	04054763          	bltz	a0,532 <go+0x4be>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     4e8:	4605                	li	a2,1
     4ea:	00001597          	auipc	a1,0x1
     4ee:	d5e58593          	add	a1,a1,-674 # 1248 <malloc+0x238>
     4f2:	668000ef          	jal	b5a <write>
     4f6:	4785                	li	a5,1
     4f8:	04f51663          	bne	a0,a5,544 <go+0x4d0>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     4fc:	f9840593          	add	a1,s0,-104
     500:	855a                	mv	a0,s6
     502:	690000ef          	jal	b92 <fstat>
     506:	e921                	bnez	a0,556 <go+0x4e2>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     508:	fa843583          	ld	a1,-88(s0)
     50c:	4785                	li	a5,1
     50e:	04f59d63          	bne	a1,a5,568 <go+0x4f4>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     512:	f9c42583          	lw	a1,-100(s0)
     516:	0c800793          	li	a5,200
     51a:	06b7e163          	bltu	a5,a1,57c <go+0x508>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     51e:	855a                	mv	a0,s6
     520:	642000ef          	jal	b62 <close>
      unlink("c");
     524:	00001517          	auipc	a0,0x1
     528:	d6c50513          	add	a0,a0,-660 # 1290 <malloc+0x280>
     52c:	65e000ef          	jal	b8a <unlink>
     530:	bec1                	j	100 <go+0x8c>
        printf("grind: create c failed\n");
     532:	00001517          	auipc	a0,0x1
     536:	d6650513          	add	a0,a0,-666 # 1298 <malloc+0x288>
     53a:	223000ef          	jal	f5c <printf>
        exit(1);
     53e:	4505                	li	a0,1
     540:	5fa000ef          	jal	b3a <exit>
        printf("grind: write c failed\n");
     544:	00001517          	auipc	a0,0x1
     548:	d6c50513          	add	a0,a0,-660 # 12b0 <malloc+0x2a0>
     54c:	211000ef          	jal	f5c <printf>
        exit(1);
     550:	4505                	li	a0,1
     552:	5e8000ef          	jal	b3a <exit>
        printf("grind: fstat failed\n");
     556:	00001517          	auipc	a0,0x1
     55a:	d7250513          	add	a0,a0,-654 # 12c8 <malloc+0x2b8>
     55e:	1ff000ef          	jal	f5c <printf>
        exit(1);
     562:	4505                	li	a0,1
     564:	5d6000ef          	jal	b3a <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     568:	2581                	sext.w	a1,a1
     56a:	00001517          	auipc	a0,0x1
     56e:	d7650513          	add	a0,a0,-650 # 12e0 <malloc+0x2d0>
     572:	1eb000ef          	jal	f5c <printf>
        exit(1);
     576:	4505                	li	a0,1
     578:	5c2000ef          	jal	b3a <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     57c:	00001517          	auipc	a0,0x1
     580:	d8c50513          	add	a0,a0,-628 # 1308 <malloc+0x2f8>
     584:	1d9000ef          	jal	f5c <printf>
        exit(1);
     588:	4505                	li	a0,1
     58a:	5b0000ef          	jal	b3a <exit>
    } else if(what == 22){
      /* echo hi | cat */
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     58e:	f8840513          	add	a0,s0,-120
     592:	5b8000ef          	jal	b4a <pipe>
     596:	0a054563          	bltz	a0,640 <go+0x5cc>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     59a:	f9040513          	add	a0,s0,-112
     59e:	5ac000ef          	jal	b4a <pipe>
     5a2:	0a054963          	bltz	a0,654 <go+0x5e0>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     5a6:	58c000ef          	jal	b32 <fork>
      if(pid1 == 0){
     5aa:	cd5d                	beqz	a0,668 <go+0x5f4>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     5ac:	14054263          	bltz	a0,6f0 <go+0x67c>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     5b0:	582000ef          	jal	b32 <fork>
      if(pid2 == 0){
     5b4:	14050863          	beqz	a0,704 <go+0x690>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     5b8:	1e054663          	bltz	a0,7a4 <go+0x730>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5bc:	f8842503          	lw	a0,-120(s0)
     5c0:	5a2000ef          	jal	b62 <close>
      close(aa[1]);
     5c4:	f8c42503          	lw	a0,-116(s0)
     5c8:	59a000ef          	jal	b62 <close>
      close(bb[1]);
     5cc:	f9442503          	lw	a0,-108(s0)
     5d0:	592000ef          	jal	b62 <close>
      char buf[4] = { 0, 0, 0, 0 };
     5d4:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
     5d8:	4605                	li	a2,1
     5da:	f8040593          	add	a1,s0,-128
     5de:	f9042503          	lw	a0,-112(s0)
     5e2:	570000ef          	jal	b52 <read>
      read(bb[0], buf+1, 1);
     5e6:	4605                	li	a2,1
     5e8:	f8140593          	add	a1,s0,-127
     5ec:	f9042503          	lw	a0,-112(s0)
     5f0:	562000ef          	jal	b52 <read>
      read(bb[0], buf+2, 1);
     5f4:	4605                	li	a2,1
     5f6:	f8240593          	add	a1,s0,-126
     5fa:	f9042503          	lw	a0,-112(s0)
     5fe:	554000ef          	jal	b52 <read>
      close(bb[0]);
     602:	f9042503          	lw	a0,-112(s0)
     606:	55c000ef          	jal	b62 <close>
      int st1, st2;
      wait(&st1);
     60a:	f8440513          	add	a0,s0,-124
     60e:	534000ef          	jal	b42 <wait>
      wait(&st2);
     612:	f9840513          	add	a0,s0,-104
     616:	52c000ef          	jal	b42 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     61a:	f8442783          	lw	a5,-124(s0)
     61e:	f9842b83          	lw	s7,-104(s0)
     622:	0177eb33          	or	s6,a5,s7
     626:	180b1963          	bnez	s6,7b8 <go+0x744>
     62a:	00001597          	auipc	a1,0x1
     62e:	d7e58593          	add	a1,a1,-642 # 13a8 <malloc+0x398>
     632:	f8040513          	add	a0,s0,-128
     636:	2c8000ef          	jal	8fe <strcmp>
     63a:	ac0503e3          	beqz	a0,100 <go+0x8c>
     63e:	aab5                	j	7ba <go+0x746>
        fprintf(2, "grind: pipe failed\n");
     640:	00001597          	auipc	a1,0x1
     644:	bf058593          	add	a1,a1,-1040 # 1230 <malloc+0x220>
     648:	4509                	li	a0,2
     64a:	0e9000ef          	jal	f32 <fprintf>
        exit(1);
     64e:	4505                	li	a0,1
     650:	4ea000ef          	jal	b3a <exit>
        fprintf(2, "grind: pipe failed\n");
     654:	00001597          	auipc	a1,0x1
     658:	bdc58593          	add	a1,a1,-1060 # 1230 <malloc+0x220>
     65c:	4509                	li	a0,2
     65e:	0d5000ef          	jal	f32 <fprintf>
        exit(1);
     662:	4505                	li	a0,1
     664:	4d6000ef          	jal	b3a <exit>
        close(bb[0]);
     668:	f9042503          	lw	a0,-112(s0)
     66c:	4f6000ef          	jal	b62 <close>
        close(bb[1]);
     670:	f9442503          	lw	a0,-108(s0)
     674:	4ee000ef          	jal	b62 <close>
        close(aa[0]);
     678:	f8842503          	lw	a0,-120(s0)
     67c:	4e6000ef          	jal	b62 <close>
        close(1);
     680:	4505                	li	a0,1
     682:	4e0000ef          	jal	b62 <close>
        if(dup(aa[1]) != 1){
     686:	f8c42503          	lw	a0,-116(s0)
     68a:	528000ef          	jal	bb2 <dup>
     68e:	4785                	li	a5,1
     690:	00f50c63          	beq	a0,a5,6a8 <go+0x634>
          fprintf(2, "grind: dup failed\n");
     694:	00001597          	auipc	a1,0x1
     698:	c9c58593          	add	a1,a1,-868 # 1330 <malloc+0x320>
     69c:	4509                	li	a0,2
     69e:	095000ef          	jal	f32 <fprintf>
          exit(1);
     6a2:	4505                	li	a0,1
     6a4:	496000ef          	jal	b3a <exit>
        close(aa[1]);
     6a8:	f8c42503          	lw	a0,-116(s0)
     6ac:	4b6000ef          	jal	b62 <close>
        char *args[3] = { "echo", "hi", 0 };
     6b0:	00001797          	auipc	a5,0x1
     6b4:	c9878793          	add	a5,a5,-872 # 1348 <malloc+0x338>
     6b8:	f8f43c23          	sd	a5,-104(s0)
     6bc:	00001797          	auipc	a5,0x1
     6c0:	c9478793          	add	a5,a5,-876 # 1350 <malloc+0x340>
     6c4:	faf43023          	sd	a5,-96(s0)
     6c8:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     6cc:	f9840593          	add	a1,s0,-104
     6d0:	00001517          	auipc	a0,0x1
     6d4:	c8850513          	add	a0,a0,-888 # 1358 <malloc+0x348>
     6d8:	49a000ef          	jal	b72 <exec>
        fprintf(2, "grind: echo: not found\n");
     6dc:	00001597          	auipc	a1,0x1
     6e0:	c8c58593          	add	a1,a1,-884 # 1368 <malloc+0x358>
     6e4:	4509                	li	a0,2
     6e6:	04d000ef          	jal	f32 <fprintf>
        exit(2);
     6ea:	4509                	li	a0,2
     6ec:	44e000ef          	jal	b3a <exit>
        fprintf(2, "grind: fork failed\n");
     6f0:	00001597          	auipc	a1,0x1
     6f4:	b0058593          	add	a1,a1,-1280 # 11f0 <malloc+0x1e0>
     6f8:	4509                	li	a0,2
     6fa:	039000ef          	jal	f32 <fprintf>
        exit(3);
     6fe:	450d                	li	a0,3
     700:	43a000ef          	jal	b3a <exit>
        close(aa[1]);
     704:	f8c42503          	lw	a0,-116(s0)
     708:	45a000ef          	jal	b62 <close>
        close(bb[0]);
     70c:	f9042503          	lw	a0,-112(s0)
     710:	452000ef          	jal	b62 <close>
        close(0);
     714:	4501                	li	a0,0
     716:	44c000ef          	jal	b62 <close>
        if(dup(aa[0]) != 0){
     71a:	f8842503          	lw	a0,-120(s0)
     71e:	494000ef          	jal	bb2 <dup>
     722:	c919                	beqz	a0,738 <go+0x6c4>
          fprintf(2, "grind: dup failed\n");
     724:	00001597          	auipc	a1,0x1
     728:	c0c58593          	add	a1,a1,-1012 # 1330 <malloc+0x320>
     72c:	4509                	li	a0,2
     72e:	005000ef          	jal	f32 <fprintf>
          exit(4);
     732:	4511                	li	a0,4
     734:	406000ef          	jal	b3a <exit>
        close(aa[0]);
     738:	f8842503          	lw	a0,-120(s0)
     73c:	426000ef          	jal	b62 <close>
        close(1);
     740:	4505                	li	a0,1
     742:	420000ef          	jal	b62 <close>
        if(dup(bb[1]) != 1){
     746:	f9442503          	lw	a0,-108(s0)
     74a:	468000ef          	jal	bb2 <dup>
     74e:	4785                	li	a5,1
     750:	00f50c63          	beq	a0,a5,768 <go+0x6f4>
          fprintf(2, "grind: dup failed\n");
     754:	00001597          	auipc	a1,0x1
     758:	bdc58593          	add	a1,a1,-1060 # 1330 <malloc+0x320>
     75c:	4509                	li	a0,2
     75e:	7d4000ef          	jal	f32 <fprintf>
          exit(5);
     762:	4515                	li	a0,5
     764:	3d6000ef          	jal	b3a <exit>
        close(bb[1]);
     768:	f9442503          	lw	a0,-108(s0)
     76c:	3f6000ef          	jal	b62 <close>
        char *args[2] = { "cat", 0 };
     770:	00001797          	auipc	a5,0x1
     774:	c1078793          	add	a5,a5,-1008 # 1380 <malloc+0x370>
     778:	f8f43c23          	sd	a5,-104(s0)
     77c:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     780:	f9840593          	add	a1,s0,-104
     784:	00001517          	auipc	a0,0x1
     788:	c0450513          	add	a0,a0,-1020 # 1388 <malloc+0x378>
     78c:	3e6000ef          	jal	b72 <exec>
        fprintf(2, "grind: cat: not found\n");
     790:	00001597          	auipc	a1,0x1
     794:	c0058593          	add	a1,a1,-1024 # 1390 <malloc+0x380>
     798:	4509                	li	a0,2
     79a:	798000ef          	jal	f32 <fprintf>
        exit(6);
     79e:	4519                	li	a0,6
     7a0:	39a000ef          	jal	b3a <exit>
        fprintf(2, "grind: fork failed\n");
     7a4:	00001597          	auipc	a1,0x1
     7a8:	a4c58593          	add	a1,a1,-1460 # 11f0 <malloc+0x1e0>
     7ac:	4509                	li	a0,2
     7ae:	784000ef          	jal	f32 <fprintf>
        exit(7);
     7b2:	451d                	li	a0,7
     7b4:	386000ef          	jal	b3a <exit>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     7b8:	8b3e                	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     7ba:	f8040693          	add	a3,s0,-128
     7be:	865e                	mv	a2,s7
     7c0:	85da                	mv	a1,s6
     7c2:	00001517          	auipc	a0,0x1
     7c6:	bee50513          	add	a0,a0,-1042 # 13b0 <malloc+0x3a0>
     7ca:	792000ef          	jal	f5c <printf>
        exit(1);
     7ce:	4505                	li	a0,1
     7d0:	36a000ef          	jal	b3a <exit>

00000000000007d4 <iter>:
  }
}

void
iter()
{
     7d4:	7179                	add	sp,sp,-48
     7d6:	f406                	sd	ra,40(sp)
     7d8:	f022                	sd	s0,32(sp)
     7da:	ec26                	sd	s1,24(sp)
     7dc:	e84a                	sd	s2,16(sp)
     7de:	1800                	add	s0,sp,48
  unlink("a");
     7e0:	00001517          	auipc	a0,0x1
     7e4:	9f050513          	add	a0,a0,-1552 # 11d0 <malloc+0x1c0>
     7e8:	3a2000ef          	jal	b8a <unlink>
  unlink("b");
     7ec:	00001517          	auipc	a0,0x1
     7f0:	99450513          	add	a0,a0,-1644 # 1180 <malloc+0x170>
     7f4:	396000ef          	jal	b8a <unlink>
  
  int pid1 = fork();
     7f8:	33a000ef          	jal	b32 <fork>
  if(pid1 < 0){
     7fc:	00054f63          	bltz	a0,81a <iter+0x46>
     800:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     802:	e50d                	bnez	a0,82c <iter+0x58>
    rand_next ^= 31;
     804:	00001717          	auipc	a4,0x1
     808:	7fc70713          	add	a4,a4,2044 # 2000 <rand_next>
     80c:	631c                	ld	a5,0(a4)
     80e:	01f7c793          	xor	a5,a5,31
     812:	e31c                	sd	a5,0(a4)
    go(0);
     814:	4501                	li	a0,0
     816:	85fff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     81a:	00001517          	auipc	a0,0x1
     81e:	9d650513          	add	a0,a0,-1578 # 11f0 <malloc+0x1e0>
     822:	73a000ef          	jal	f5c <printf>
    exit(1);
     826:	4505                	li	a0,1
     828:	312000ef          	jal	b3a <exit>
    exit(0);
  }

  int pid2 = fork();
     82c:	306000ef          	jal	b32 <fork>
     830:	892a                	mv	s2,a0
  if(pid2 < 0){
     832:	02054063          	bltz	a0,852 <iter+0x7e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     836:	e51d                	bnez	a0,864 <iter+0x90>
    rand_next ^= 7177;
     838:	00001697          	auipc	a3,0x1
     83c:	7c868693          	add	a3,a3,1992 # 2000 <rand_next>
     840:	629c                	ld	a5,0(a3)
     842:	6709                	lui	a4,0x2
     844:	c0970713          	add	a4,a4,-1015 # 1c09 <digits+0x7c9>
     848:	8fb9                	xor	a5,a5,a4
     84a:	e29c                	sd	a5,0(a3)
    go(1);
     84c:	4505                	li	a0,1
     84e:	827ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     852:	00001517          	auipc	a0,0x1
     856:	99e50513          	add	a0,a0,-1634 # 11f0 <malloc+0x1e0>
     85a:	702000ef          	jal	f5c <printf>
    exit(1);
     85e:	4505                	li	a0,1
     860:	2da000ef          	jal	b3a <exit>
    exit(0);
  }

  int st1 = -1;
     864:	57fd                	li	a5,-1
     866:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     86a:	fdc40513          	add	a0,s0,-36
     86e:	2d4000ef          	jal	b42 <wait>
  if(st1 != 0){
     872:	fdc42783          	lw	a5,-36(s0)
     876:	eb99                	bnez	a5,88c <iter+0xb8>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     878:	57fd                	li	a5,-1
     87a:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     87e:	fd840513          	add	a0,s0,-40
     882:	2c0000ef          	jal	b42 <wait>

  exit(0);
     886:	4501                	li	a0,0
     888:	2b2000ef          	jal	b3a <exit>
    kill(pid1);
     88c:	8526                	mv	a0,s1
     88e:	2dc000ef          	jal	b6a <kill>
    kill(pid2);
     892:	854a                	mv	a0,s2
     894:	2d6000ef          	jal	b6a <kill>
     898:	b7c5                	j	878 <iter+0xa4>

000000000000089a <main>:
}

int
main()
{
     89a:	1101                	add	sp,sp,-32
     89c:	ec06                	sd	ra,24(sp)
     89e:	e822                	sd	s0,16(sp)
     8a0:	e426                	sd	s1,8(sp)
     8a2:	1000                	add	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     8a4:	00001497          	auipc	s1,0x1
     8a8:	75c48493          	add	s1,s1,1884 # 2000 <rand_next>
     8ac:	a809                	j	8be <main+0x24>
      iter();
     8ae:	f27ff0ef          	jal	7d4 <iter>
    sleep(20);
     8b2:	4551                	li	a0,20
     8b4:	316000ef          	jal	bca <sleep>
    rand_next += 1;
     8b8:	609c                	ld	a5,0(s1)
     8ba:	0785                	add	a5,a5,1
     8bc:	e09c                	sd	a5,0(s1)
    int pid = fork();
     8be:	274000ef          	jal	b32 <fork>
    if(pid == 0){
     8c2:	d575                	beqz	a0,8ae <main+0x14>
    if(pid > 0){
     8c4:	fea057e3          	blez	a0,8b2 <main+0x18>
      wait(0);
     8c8:	4501                	li	a0,0
     8ca:	278000ef          	jal	b42 <wait>
     8ce:	b7d5                	j	8b2 <main+0x18>

00000000000008d0 <start>:
/* */
/* wrapper so that it's OK if main() does not call exit(). */
/* */
void
start()
{
     8d0:	1141                	add	sp,sp,-16
     8d2:	e406                	sd	ra,8(sp)
     8d4:	e022                	sd	s0,0(sp)
     8d6:	0800                	add	s0,sp,16
  extern int main();
  main();
     8d8:	fc3ff0ef          	jal	89a <main>
  exit(0);
     8dc:	4501                	li	a0,0
     8de:	25c000ef          	jal	b3a <exit>

00000000000008e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8e2:	1141                	add	sp,sp,-16
     8e4:	e422                	sd	s0,8(sp)
     8e6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8e8:	87aa                	mv	a5,a0
     8ea:	0585                	add	a1,a1,1
     8ec:	0785                	add	a5,a5,1
     8ee:	fff5c703          	lbu	a4,-1(a1)
     8f2:	fee78fa3          	sb	a4,-1(a5)
     8f6:	fb75                	bnez	a4,8ea <strcpy+0x8>
    ;
  return os;
}
     8f8:	6422                	ld	s0,8(sp)
     8fa:	0141                	add	sp,sp,16
     8fc:	8082                	ret

00000000000008fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8fe:	1141                	add	sp,sp,-16
     900:	e422                	sd	s0,8(sp)
     902:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     904:	00054783          	lbu	a5,0(a0)
     908:	cb91                	beqz	a5,91c <strcmp+0x1e>
     90a:	0005c703          	lbu	a4,0(a1)
     90e:	00f71763          	bne	a4,a5,91c <strcmp+0x1e>
    p++, q++;
     912:	0505                	add	a0,a0,1
     914:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     916:	00054783          	lbu	a5,0(a0)
     91a:	fbe5                	bnez	a5,90a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     91c:	0005c503          	lbu	a0,0(a1)
}
     920:	40a7853b          	subw	a0,a5,a0
     924:	6422                	ld	s0,8(sp)
     926:	0141                	add	sp,sp,16
     928:	8082                	ret

000000000000092a <strlen>:

uint
strlen(const char *s)
{
     92a:	1141                	add	sp,sp,-16
     92c:	e422                	sd	s0,8(sp)
     92e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     930:	00054783          	lbu	a5,0(a0)
     934:	cf91                	beqz	a5,950 <strlen+0x26>
     936:	0505                	add	a0,a0,1
     938:	87aa                	mv	a5,a0
     93a:	86be                	mv	a3,a5
     93c:	0785                	add	a5,a5,1
     93e:	fff7c703          	lbu	a4,-1(a5)
     942:	ff65                	bnez	a4,93a <strlen+0x10>
     944:	40a6853b          	subw	a0,a3,a0
     948:	2505                	addw	a0,a0,1
    ;
  return n;
}
     94a:	6422                	ld	s0,8(sp)
     94c:	0141                	add	sp,sp,16
     94e:	8082                	ret
  for(n = 0; s[n]; n++)
     950:	4501                	li	a0,0
     952:	bfe5                	j	94a <strlen+0x20>

0000000000000954 <memset>:

void*
memset(void *dst, int c, uint n)
{
     954:	1141                	add	sp,sp,-16
     956:	e422                	sd	s0,8(sp)
     958:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     95a:	ca19                	beqz	a2,970 <memset+0x1c>
     95c:	87aa                	mv	a5,a0
     95e:	1602                	sll	a2,a2,0x20
     960:	9201                	srl	a2,a2,0x20
     962:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     966:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     96a:	0785                	add	a5,a5,1
     96c:	fee79de3          	bne	a5,a4,966 <memset+0x12>
  }
  return dst;
}
     970:	6422                	ld	s0,8(sp)
     972:	0141                	add	sp,sp,16
     974:	8082                	ret

0000000000000976 <strchr>:

char*
strchr(const char *s, char c)
{
     976:	1141                	add	sp,sp,-16
     978:	e422                	sd	s0,8(sp)
     97a:	0800                	add	s0,sp,16
  for(; *s; s++)
     97c:	00054783          	lbu	a5,0(a0)
     980:	cb99                	beqz	a5,996 <strchr+0x20>
    if(*s == c)
     982:	00f58763          	beq	a1,a5,990 <strchr+0x1a>
  for(; *s; s++)
     986:	0505                	add	a0,a0,1
     988:	00054783          	lbu	a5,0(a0)
     98c:	fbfd                	bnez	a5,982 <strchr+0xc>
      return (char*)s;
  return 0;
     98e:	4501                	li	a0,0
}
     990:	6422                	ld	s0,8(sp)
     992:	0141                	add	sp,sp,16
     994:	8082                	ret
  return 0;
     996:	4501                	li	a0,0
     998:	bfe5                	j	990 <strchr+0x1a>

000000000000099a <gets>:

char*
gets(char *buf, int max)
{
     99a:	711d                	add	sp,sp,-96
     99c:	ec86                	sd	ra,88(sp)
     99e:	e8a2                	sd	s0,80(sp)
     9a0:	e4a6                	sd	s1,72(sp)
     9a2:	e0ca                	sd	s2,64(sp)
     9a4:	fc4e                	sd	s3,56(sp)
     9a6:	f852                	sd	s4,48(sp)
     9a8:	f456                	sd	s5,40(sp)
     9aa:	f05a                	sd	s6,32(sp)
     9ac:	ec5e                	sd	s7,24(sp)
     9ae:	1080                	add	s0,sp,96
     9b0:	8baa                	mv	s7,a0
     9b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9b4:	892a                	mv	s2,a0
     9b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9b8:	4aa9                	li	s5,10
     9ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9bc:	89a6                	mv	s3,s1
     9be:	2485                	addw	s1,s1,1
     9c0:	0344d663          	bge	s1,s4,9ec <gets+0x52>
    cc = read(0, &c, 1);
     9c4:	4605                	li	a2,1
     9c6:	faf40593          	add	a1,s0,-81
     9ca:	4501                	li	a0,0
     9cc:	186000ef          	jal	b52 <read>
    if(cc < 1)
     9d0:	00a05e63          	blez	a0,9ec <gets+0x52>
    buf[i++] = c;
     9d4:	faf44783          	lbu	a5,-81(s0)
     9d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9dc:	01578763          	beq	a5,s5,9ea <gets+0x50>
     9e0:	0905                	add	s2,s2,1
     9e2:	fd679de3          	bne	a5,s6,9bc <gets+0x22>
  for(i=0; i+1 < max; ){
     9e6:	89a6                	mv	s3,s1
     9e8:	a011                	j	9ec <gets+0x52>
     9ea:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9ec:	99de                	add	s3,s3,s7
     9ee:	00098023          	sb	zero,0(s3)
  return buf;
}
     9f2:	855e                	mv	a0,s7
     9f4:	60e6                	ld	ra,88(sp)
     9f6:	6446                	ld	s0,80(sp)
     9f8:	64a6                	ld	s1,72(sp)
     9fa:	6906                	ld	s2,64(sp)
     9fc:	79e2                	ld	s3,56(sp)
     9fe:	7a42                	ld	s4,48(sp)
     a00:	7aa2                	ld	s5,40(sp)
     a02:	7b02                	ld	s6,32(sp)
     a04:	6be2                	ld	s7,24(sp)
     a06:	6125                	add	sp,sp,96
     a08:	8082                	ret

0000000000000a0a <stat>:

int
stat(const char *n, struct stat *st)
{
     a0a:	1101                	add	sp,sp,-32
     a0c:	ec06                	sd	ra,24(sp)
     a0e:	e822                	sd	s0,16(sp)
     a10:	e426                	sd	s1,8(sp)
     a12:	e04a                	sd	s2,0(sp)
     a14:	1000                	add	s0,sp,32
     a16:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a18:	4581                	li	a1,0
     a1a:	160000ef          	jal	b7a <open>
  if(fd < 0)
     a1e:	02054163          	bltz	a0,a40 <stat+0x36>
     a22:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a24:	85ca                	mv	a1,s2
     a26:	16c000ef          	jal	b92 <fstat>
     a2a:	892a                	mv	s2,a0
  close(fd);
     a2c:	8526                	mv	a0,s1
     a2e:	134000ef          	jal	b62 <close>
  return r;
}
     a32:	854a                	mv	a0,s2
     a34:	60e2                	ld	ra,24(sp)
     a36:	6442                	ld	s0,16(sp)
     a38:	64a2                	ld	s1,8(sp)
     a3a:	6902                	ld	s2,0(sp)
     a3c:	6105                	add	sp,sp,32
     a3e:	8082                	ret
    return -1;
     a40:	597d                	li	s2,-1
     a42:	bfc5                	j	a32 <stat+0x28>

0000000000000a44 <atoi>:

int
atoi(const char *s)
{
     a44:	1141                	add	sp,sp,-16
     a46:	e422                	sd	s0,8(sp)
     a48:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a4a:	00054683          	lbu	a3,0(a0)
     a4e:	fd06879b          	addw	a5,a3,-48
     a52:	0ff7f793          	zext.b	a5,a5
     a56:	4625                	li	a2,9
     a58:	02f66863          	bltu	a2,a5,a88 <atoi+0x44>
     a5c:	872a                	mv	a4,a0
  n = 0;
     a5e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a60:	0705                	add	a4,a4,1
     a62:	0025179b          	sllw	a5,a0,0x2
     a66:	9fa9                	addw	a5,a5,a0
     a68:	0017979b          	sllw	a5,a5,0x1
     a6c:	9fb5                	addw	a5,a5,a3
     a6e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a72:	00074683          	lbu	a3,0(a4)
     a76:	fd06879b          	addw	a5,a3,-48
     a7a:	0ff7f793          	zext.b	a5,a5
     a7e:	fef671e3          	bgeu	a2,a5,a60 <atoi+0x1c>
  return n;
}
     a82:	6422                	ld	s0,8(sp)
     a84:	0141                	add	sp,sp,16
     a86:	8082                	ret
  n = 0;
     a88:	4501                	li	a0,0
     a8a:	bfe5                	j	a82 <atoi+0x3e>

0000000000000a8c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a8c:	1141                	add	sp,sp,-16
     a8e:	e422                	sd	s0,8(sp)
     a90:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a92:	02b57463          	bgeu	a0,a1,aba <memmove+0x2e>
    while(n-- > 0)
     a96:	00c05f63          	blez	a2,ab4 <memmove+0x28>
     a9a:	1602                	sll	a2,a2,0x20
     a9c:	9201                	srl	a2,a2,0x20
     a9e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     aa2:	872a                	mv	a4,a0
      *dst++ = *src++;
     aa4:	0585                	add	a1,a1,1
     aa6:	0705                	add	a4,a4,1
     aa8:	fff5c683          	lbu	a3,-1(a1)
     aac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ab0:	fee79ae3          	bne	a5,a4,aa4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ab4:	6422                	ld	s0,8(sp)
     ab6:	0141                	add	sp,sp,16
     ab8:	8082                	ret
    dst += n;
     aba:	00c50733          	add	a4,a0,a2
    src += n;
     abe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ac0:	fec05ae3          	blez	a2,ab4 <memmove+0x28>
     ac4:	fff6079b          	addw	a5,a2,-1
     ac8:	1782                	sll	a5,a5,0x20
     aca:	9381                	srl	a5,a5,0x20
     acc:	fff7c793          	not	a5,a5
     ad0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ad2:	15fd                	add	a1,a1,-1
     ad4:	177d                	add	a4,a4,-1
     ad6:	0005c683          	lbu	a3,0(a1)
     ada:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ade:	fee79ae3          	bne	a5,a4,ad2 <memmove+0x46>
     ae2:	bfc9                	j	ab4 <memmove+0x28>

0000000000000ae4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ae4:	1141                	add	sp,sp,-16
     ae6:	e422                	sd	s0,8(sp)
     ae8:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     aea:	ca05                	beqz	a2,b1a <memcmp+0x36>
     aec:	fff6069b          	addw	a3,a2,-1
     af0:	1682                	sll	a3,a3,0x20
     af2:	9281                	srl	a3,a3,0x20
     af4:	0685                	add	a3,a3,1
     af6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     af8:	00054783          	lbu	a5,0(a0)
     afc:	0005c703          	lbu	a4,0(a1)
     b00:	00e79863          	bne	a5,a4,b10 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b04:	0505                	add	a0,a0,1
    p2++;
     b06:	0585                	add	a1,a1,1
  while (n-- > 0) {
     b08:	fed518e3          	bne	a0,a3,af8 <memcmp+0x14>
  }
  return 0;
     b0c:	4501                	li	a0,0
     b0e:	a019                	j	b14 <memcmp+0x30>
      return *p1 - *p2;
     b10:	40e7853b          	subw	a0,a5,a4
}
     b14:	6422                	ld	s0,8(sp)
     b16:	0141                	add	sp,sp,16
     b18:	8082                	ret
  return 0;
     b1a:	4501                	li	a0,0
     b1c:	bfe5                	j	b14 <memcmp+0x30>

0000000000000b1e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b1e:	1141                	add	sp,sp,-16
     b20:	e406                	sd	ra,8(sp)
     b22:	e022                	sd	s0,0(sp)
     b24:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     b26:	f67ff0ef          	jal	a8c <memmove>
}
     b2a:	60a2                	ld	ra,8(sp)
     b2c:	6402                	ld	s0,0(sp)
     b2e:	0141                	add	sp,sp,16
     b30:	8082                	ret

0000000000000b32 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b32:	4885                	li	a7,1
 ecall
     b34:	00000073          	ecall
 ret
     b38:	8082                	ret

0000000000000b3a <exit>:
.global exit
exit:
 li a7, SYS_exit
     b3a:	4889                	li	a7,2
 ecall
     b3c:	00000073          	ecall
 ret
     b40:	8082                	ret

0000000000000b42 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b42:	488d                	li	a7,3
 ecall
     b44:	00000073          	ecall
 ret
     b48:	8082                	ret

0000000000000b4a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b4a:	4891                	li	a7,4
 ecall
     b4c:	00000073          	ecall
 ret
     b50:	8082                	ret

0000000000000b52 <read>:
.global read
read:
 li a7, SYS_read
     b52:	4895                	li	a7,5
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <write>:
.global write
write:
 li a7, SYS_write
     b5a:	48c1                	li	a7,16
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <close>:
.global close
close:
 li a7, SYS_close
     b62:	48d5                	li	a7,21
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <kill>:
.global kill
kill:
 li a7, SYS_kill
     b6a:	4899                	li	a7,6
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b72:	489d                	li	a7,7
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <open>:
.global open
open:
 li a7, SYS_open
     b7a:	48bd                	li	a7,15
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b82:	48c5                	li	a7,17
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b8a:	48c9                	li	a7,18
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b92:	48a1                	li	a7,8
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <link>:
.global link
link:
 li a7, SYS_link
     b9a:	48cd                	li	a7,19
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ba2:	48d1                	li	a7,20
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     baa:	48a5                	li	a7,9
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <dup>:
.global dup
dup:
 li a7, SYS_dup
     bb2:	48a9                	li	a7,10
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bba:	48ad                	li	a7,11
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bc2:	48b1                	li	a7,12
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bca:	48b5                	li	a7,13
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bd2:	48b9                	li	a7,14
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
     bda:	48d9                	li	a7,22
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     be2:	1101                	add	sp,sp,-32
     be4:	ec06                	sd	ra,24(sp)
     be6:	e822                	sd	s0,16(sp)
     be8:	1000                	add	s0,sp,32
     bea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bee:	4605                	li	a2,1
     bf0:	fef40593          	add	a1,s0,-17
     bf4:	f67ff0ef          	jal	b5a <write>
}
     bf8:	60e2                	ld	ra,24(sp)
     bfa:	6442                	ld	s0,16(sp)
     bfc:	6105                	add	sp,sp,32
     bfe:	8082                	ret

0000000000000c00 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c00:	7139                	add	sp,sp,-64
     c02:	fc06                	sd	ra,56(sp)
     c04:	f822                	sd	s0,48(sp)
     c06:	f426                	sd	s1,40(sp)
     c08:	f04a                	sd	s2,32(sp)
     c0a:	ec4e                	sd	s3,24(sp)
     c0c:	0080                	add	s0,sp,64
     c0e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c10:	c299                	beqz	a3,c16 <printint+0x16>
     c12:	0805c763          	bltz	a1,ca0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c16:	2581                	sext.w	a1,a1
  neg = 0;
     c18:	4881                	li	a7,0
     c1a:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     c1e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c20:	2601                	sext.w	a2,a2
     c22:	00001517          	auipc	a0,0x1
     c26:	81e50513          	add	a0,a0,-2018 # 1440 <digits>
     c2a:	883a                	mv	a6,a4
     c2c:	2705                	addw	a4,a4,1
     c2e:	02c5f7bb          	remuw	a5,a1,a2
     c32:	1782                	sll	a5,a5,0x20
     c34:	9381                	srl	a5,a5,0x20
     c36:	97aa                	add	a5,a5,a0
     c38:	0007c783          	lbu	a5,0(a5)
     c3c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c40:	0005879b          	sext.w	a5,a1
     c44:	02c5d5bb          	divuw	a1,a1,a2
     c48:	0685                	add	a3,a3,1
     c4a:	fec7f0e3          	bgeu	a5,a2,c2a <printint+0x2a>
  if(neg)
     c4e:	00088c63          	beqz	a7,c66 <printint+0x66>
    buf[i++] = '-';
     c52:	fd070793          	add	a5,a4,-48
     c56:	00878733          	add	a4,a5,s0
     c5a:	02d00793          	li	a5,45
     c5e:	fef70823          	sb	a5,-16(a4)
     c62:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     c66:	02e05663          	blez	a4,c92 <printint+0x92>
     c6a:	fc040793          	add	a5,s0,-64
     c6e:	00e78933          	add	s2,a5,a4
     c72:	fff78993          	add	s3,a5,-1
     c76:	99ba                	add	s3,s3,a4
     c78:	377d                	addw	a4,a4,-1
     c7a:	1702                	sll	a4,a4,0x20
     c7c:	9301                	srl	a4,a4,0x20
     c7e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c82:	fff94583          	lbu	a1,-1(s2)
     c86:	8526                	mv	a0,s1
     c88:	f5bff0ef          	jal	be2 <putc>
  while(--i >= 0)
     c8c:	197d                	add	s2,s2,-1
     c8e:	ff391ae3          	bne	s2,s3,c82 <printint+0x82>
}
     c92:	70e2                	ld	ra,56(sp)
     c94:	7442                	ld	s0,48(sp)
     c96:	74a2                	ld	s1,40(sp)
     c98:	7902                	ld	s2,32(sp)
     c9a:	69e2                	ld	s3,24(sp)
     c9c:	6121                	add	sp,sp,64
     c9e:	8082                	ret
    x = -xx;
     ca0:	40b005bb          	negw	a1,a1
    neg = 1;
     ca4:	4885                	li	a7,1
    x = -xx;
     ca6:	bf95                	j	c1a <printint+0x1a>

0000000000000ca8 <vprintf>:
}

/* Print to the given fd. Only understands %d, %x, %p, %s. */
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ca8:	711d                	add	sp,sp,-96
     caa:	ec86                	sd	ra,88(sp)
     cac:	e8a2                	sd	s0,80(sp)
     cae:	e4a6                	sd	s1,72(sp)
     cb0:	e0ca                	sd	s2,64(sp)
     cb2:	fc4e                	sd	s3,56(sp)
     cb4:	f852                	sd	s4,48(sp)
     cb6:	f456                	sd	s5,40(sp)
     cb8:	f05a                	sd	s6,32(sp)
     cba:	ec5e                	sd	s7,24(sp)
     cbc:	e862                	sd	s8,16(sp)
     cbe:	e466                	sd	s9,8(sp)
     cc0:	e06a                	sd	s10,0(sp)
     cc2:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cc4:	0005c903          	lbu	s2,0(a1)
     cc8:	24090763          	beqz	s2,f16 <vprintf+0x26e>
     ccc:	8b2a                	mv	s6,a0
     cce:	8a2e                	mv	s4,a1
     cd0:	8bb2                	mv	s7,a2
  state = 0;
     cd2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     cd4:	4481                	li	s1,0
     cd6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     cd8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     cdc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     ce0:	06c00c93          	li	s9,108
     ce4:	a005                	j	d04 <vprintf+0x5c>
        putc(fd, c0);
     ce6:	85ca                	mv	a1,s2
     ce8:	855a                	mv	a0,s6
     cea:	ef9ff0ef          	jal	be2 <putc>
     cee:	a019                	j	cf4 <vprintf+0x4c>
    } else if(state == '%'){
     cf0:	03598263          	beq	s3,s5,d14 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     cf4:	2485                	addw	s1,s1,1
     cf6:	8726                	mv	a4,s1
     cf8:	009a07b3          	add	a5,s4,s1
     cfc:	0007c903          	lbu	s2,0(a5)
     d00:	20090b63          	beqz	s2,f16 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     d04:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d08:	fe0994e3          	bnez	s3,cf0 <vprintf+0x48>
      if(c0 == '%'){
     d0c:	fd579de3          	bne	a5,s5,ce6 <vprintf+0x3e>
        state = '%';
     d10:	89be                	mv	s3,a5
     d12:	b7cd                	j	cf4 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
     d14:	c7c9                	beqz	a5,d9e <vprintf+0xf6>
     d16:	00ea06b3          	add	a3,s4,a4
     d1a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     d1e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     d20:	c681                	beqz	a3,d28 <vprintf+0x80>
     d22:	9752                	add	a4,a4,s4
     d24:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     d28:	03878f63          	beq	a5,s8,d66 <vprintf+0xbe>
      } else if(c0 == 'l' && c1 == 'd'){
     d2c:	05978963          	beq	a5,s9,d7e <vprintf+0xd6>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d30:	07500713          	li	a4,117
     d34:	0ee78363          	beq	a5,a4,e1a <vprintf+0x172>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     d38:	07800713          	li	a4,120
     d3c:	12e78563          	beq	a5,a4,e66 <vprintf+0x1be>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     d40:	07000713          	li	a4,112
     d44:	14e78a63          	beq	a5,a4,e98 <vprintf+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     d48:	07300713          	li	a4,115
     d4c:	18e78863          	beq	a5,a4,edc <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     d50:	02500713          	li	a4,37
     d54:	04e79563          	bne	a5,a4,d9e <vprintf+0xf6>
        putc(fd, '%');
     d58:	02500593          	li	a1,37
     d5c:	855a                	mv	a0,s6
     d5e:	e85ff0ef          	jal	be2 <putc>
        /* Unknown % sequence.  Print it to draw attention. */
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     d62:	4981                	li	s3,0
     d64:	bf41                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
     d66:	008b8913          	add	s2,s7,8
     d6a:	4685                	li	a3,1
     d6c:	4629                	li	a2,10
     d6e:	000ba583          	lw	a1,0(s7)
     d72:	855a                	mv	a0,s6
     d74:	e8dff0ef          	jal	c00 <printint>
     d78:	8bca                	mv	s7,s2
      state = 0;
     d7a:	4981                	li	s3,0
     d7c:	bfa5                	j	cf4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
     d7e:	06400793          	li	a5,100
     d82:	02f68963          	beq	a3,a5,db4 <vprintf+0x10c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     d86:	06c00793          	li	a5,108
     d8a:	04f68263          	beq	a3,a5,dce <vprintf+0x126>
      } else if(c0 == 'l' && c1 == 'u'){
     d8e:	07500793          	li	a5,117
     d92:	0af68063          	beq	a3,a5,e32 <vprintf+0x18a>
      } else if(c0 == 'l' && c1 == 'x'){
     d96:	07800793          	li	a5,120
     d9a:	0ef68263          	beq	a3,a5,e7e <vprintf+0x1d6>
        putc(fd, '%');
     d9e:	02500593          	li	a1,37
     da2:	855a                	mv	a0,s6
     da4:	e3fff0ef          	jal	be2 <putc>
        putc(fd, c0);
     da8:	85ca                	mv	a1,s2
     daa:	855a                	mv	a0,s6
     dac:	e37ff0ef          	jal	be2 <putc>
      state = 0;
     db0:	4981                	li	s3,0
     db2:	b789                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
     db4:	008b8913          	add	s2,s7,8
     db8:	4685                	li	a3,1
     dba:	4629                	li	a2,10
     dbc:	000ba583          	lw	a1,0(s7)
     dc0:	855a                	mv	a0,s6
     dc2:	e3fff0ef          	jal	c00 <printint>
        i += 1;
     dc6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     dc8:	8bca                	mv	s7,s2
      state = 0;
     dca:	4981                	li	s3,0
        i += 1;
     dcc:	b725                	j	cf4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     dce:	06400793          	li	a5,100
     dd2:	02f60763          	beq	a2,a5,e00 <vprintf+0x158>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     dd6:	07500793          	li	a5,117
     dda:	06f60963          	beq	a2,a5,e4c <vprintf+0x1a4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     dde:	07800793          	li	a5,120
     de2:	faf61ee3          	bne	a2,a5,d9e <vprintf+0xf6>
        printint(fd, va_arg(ap, uint64), 16, 0);
     de6:	008b8913          	add	s2,s7,8
     dea:	4681                	li	a3,0
     dec:	4641                	li	a2,16
     dee:	000ba583          	lw	a1,0(s7)
     df2:	855a                	mv	a0,s6
     df4:	e0dff0ef          	jal	c00 <printint>
        i += 2;
     df8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     dfa:	8bca                	mv	s7,s2
      state = 0;
     dfc:	4981                	li	s3,0
        i += 2;
     dfe:	bddd                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e00:	008b8913          	add	s2,s7,8
     e04:	4685                	li	a3,1
     e06:	4629                	li	a2,10
     e08:	000ba583          	lw	a1,0(s7)
     e0c:	855a                	mv	a0,s6
     e0e:	df3ff0ef          	jal	c00 <printint>
        i += 2;
     e12:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e14:	8bca                	mv	s7,s2
      state = 0;
     e16:	4981                	li	s3,0
        i += 2;
     e18:	bdf1                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 0);
     e1a:	008b8913          	add	s2,s7,8
     e1e:	4681                	li	a3,0
     e20:	4629                	li	a2,10
     e22:	000ba583          	lw	a1,0(s7)
     e26:	855a                	mv	a0,s6
     e28:	dd9ff0ef          	jal	c00 <printint>
     e2c:	8bca                	mv	s7,s2
      state = 0;
     e2e:	4981                	li	s3,0
     e30:	b5d1                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e32:	008b8913          	add	s2,s7,8
     e36:	4681                	li	a3,0
     e38:	4629                	li	a2,10
     e3a:	000ba583          	lw	a1,0(s7)
     e3e:	855a                	mv	a0,s6
     e40:	dc1ff0ef          	jal	c00 <printint>
        i += 1;
     e44:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e46:	8bca                	mv	s7,s2
      state = 0;
     e48:	4981                	li	s3,0
        i += 1;
     e4a:	b56d                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e4c:	008b8913          	add	s2,s7,8
     e50:	4681                	li	a3,0
     e52:	4629                	li	a2,10
     e54:	000ba583          	lw	a1,0(s7)
     e58:	855a                	mv	a0,s6
     e5a:	da7ff0ef          	jal	c00 <printint>
        i += 2;
     e5e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     e60:	8bca                	mv	s7,s2
      state = 0;
     e62:	4981                	li	s3,0
        i += 2;
     e64:	bd41                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 16, 0);
     e66:	008b8913          	add	s2,s7,8
     e6a:	4681                	li	a3,0
     e6c:	4641                	li	a2,16
     e6e:	000ba583          	lw	a1,0(s7)
     e72:	855a                	mv	a0,s6
     e74:	d8dff0ef          	jal	c00 <printint>
     e78:	8bca                	mv	s7,s2
      state = 0;
     e7a:	4981                	li	s3,0
     e7c:	bda5                	j	cf4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e7e:	008b8913          	add	s2,s7,8
     e82:	4681                	li	a3,0
     e84:	4641                	li	a2,16
     e86:	000ba583          	lw	a1,0(s7)
     e8a:	855a                	mv	a0,s6
     e8c:	d75ff0ef          	jal	c00 <printint>
        i += 1;
     e90:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     e92:	8bca                	mv	s7,s2
      state = 0;
     e94:	4981                	li	s3,0
        i += 1;
     e96:	bdb9                	j	cf4 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
     e98:	008b8d13          	add	s10,s7,8
     e9c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ea0:	03000593          	li	a1,48
     ea4:	855a                	mv	a0,s6
     ea6:	d3dff0ef          	jal	be2 <putc>
  putc(fd, 'x');
     eaa:	07800593          	li	a1,120
     eae:	855a                	mv	a0,s6
     eb0:	d33ff0ef          	jal	be2 <putc>
     eb4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     eb6:	00000b97          	auipc	s7,0x0
     eba:	58ab8b93          	add	s7,s7,1418 # 1440 <digits>
     ebe:	03c9d793          	srl	a5,s3,0x3c
     ec2:	97de                	add	a5,a5,s7
     ec4:	0007c583          	lbu	a1,0(a5)
     ec8:	855a                	mv	a0,s6
     eca:	d19ff0ef          	jal	be2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ece:	0992                	sll	s3,s3,0x4
     ed0:	397d                	addw	s2,s2,-1
     ed2:	fe0916e3          	bnez	s2,ebe <vprintf+0x216>
        printptr(fd, va_arg(ap, uint64));
     ed6:	8bea                	mv	s7,s10
      state = 0;
     ed8:	4981                	li	s3,0
     eda:	bd29                	j	cf4 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
     edc:	008b8993          	add	s3,s7,8
     ee0:	000bb903          	ld	s2,0(s7)
     ee4:	00090f63          	beqz	s2,f02 <vprintf+0x25a>
        for(; *s; s++)
     ee8:	00094583          	lbu	a1,0(s2)
     eec:	c195                	beqz	a1,f10 <vprintf+0x268>
          putc(fd, *s);
     eee:	855a                	mv	a0,s6
     ef0:	cf3ff0ef          	jal	be2 <putc>
        for(; *s; s++)
     ef4:	0905                	add	s2,s2,1
     ef6:	00094583          	lbu	a1,0(s2)
     efa:	f9f5                	bnez	a1,eee <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     efc:	8bce                	mv	s7,s3
      state = 0;
     efe:	4981                	li	s3,0
     f00:	bbd5                	j	cf4 <vprintf+0x4c>
          s = "(null)";
     f02:	00000917          	auipc	s2,0x0
     f06:	53690913          	add	s2,s2,1334 # 1438 <malloc+0x428>
        for(; *s; s++)
     f0a:	02800593          	li	a1,40
     f0e:	b7c5                	j	eee <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     f10:	8bce                	mv	s7,s3
      state = 0;
     f12:	4981                	li	s3,0
     f14:	b3c5                	j	cf4 <vprintf+0x4c>
    }
  }
}
     f16:	60e6                	ld	ra,88(sp)
     f18:	6446                	ld	s0,80(sp)
     f1a:	64a6                	ld	s1,72(sp)
     f1c:	6906                	ld	s2,64(sp)
     f1e:	79e2                	ld	s3,56(sp)
     f20:	7a42                	ld	s4,48(sp)
     f22:	7aa2                	ld	s5,40(sp)
     f24:	7b02                	ld	s6,32(sp)
     f26:	6be2                	ld	s7,24(sp)
     f28:	6c42                	ld	s8,16(sp)
     f2a:	6ca2                	ld	s9,8(sp)
     f2c:	6d02                	ld	s10,0(sp)
     f2e:	6125                	add	sp,sp,96
     f30:	8082                	ret

0000000000000f32 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f32:	715d                	add	sp,sp,-80
     f34:	ec06                	sd	ra,24(sp)
     f36:	e822                	sd	s0,16(sp)
     f38:	1000                	add	s0,sp,32
     f3a:	e010                	sd	a2,0(s0)
     f3c:	e414                	sd	a3,8(s0)
     f3e:	e818                	sd	a4,16(s0)
     f40:	ec1c                	sd	a5,24(s0)
     f42:	03043023          	sd	a6,32(s0)
     f46:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f4a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f4e:	8622                	mv	a2,s0
     f50:	d59ff0ef          	jal	ca8 <vprintf>
}
     f54:	60e2                	ld	ra,24(sp)
     f56:	6442                	ld	s0,16(sp)
     f58:	6161                	add	sp,sp,80
     f5a:	8082                	ret

0000000000000f5c <printf>:

void
printf(const char *fmt, ...)
{
     f5c:	711d                	add	sp,sp,-96
     f5e:	ec06                	sd	ra,24(sp)
     f60:	e822                	sd	s0,16(sp)
     f62:	1000                	add	s0,sp,32
     f64:	e40c                	sd	a1,8(s0)
     f66:	e810                	sd	a2,16(s0)
     f68:	ec14                	sd	a3,24(s0)
     f6a:	f018                	sd	a4,32(s0)
     f6c:	f41c                	sd	a5,40(s0)
     f6e:	03043823          	sd	a6,48(s0)
     f72:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f76:	00840613          	add	a2,s0,8
     f7a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f7e:	85aa                	mv	a1,a0
     f80:	4505                	li	a0,1
     f82:	d27ff0ef          	jal	ca8 <vprintf>
}
     f86:	60e2                	ld	ra,24(sp)
     f88:	6442                	ld	s0,16(sp)
     f8a:	6125                	add	sp,sp,96
     f8c:	8082                	ret

0000000000000f8e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f8e:	1141                	add	sp,sp,-16
     f90:	e422                	sd	s0,8(sp)
     f92:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f94:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f98:	00001797          	auipc	a5,0x1
     f9c:	0787b783          	ld	a5,120(a5) # 2010 <freep>
     fa0:	a02d                	j	fca <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     fa2:	4618                	lw	a4,8(a2)
     fa4:	9f2d                	addw	a4,a4,a1
     fa6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     faa:	6398                	ld	a4,0(a5)
     fac:	6310                	ld	a2,0(a4)
     fae:	a83d                	j	fec <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     fb0:	ff852703          	lw	a4,-8(a0)
     fb4:	9f31                	addw	a4,a4,a2
     fb6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     fb8:	ff053683          	ld	a3,-16(a0)
     fbc:	a091                	j	1000 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fbe:	6398                	ld	a4,0(a5)
     fc0:	00e7e463          	bltu	a5,a4,fc8 <free+0x3a>
     fc4:	00e6ea63          	bltu	a3,a4,fd8 <free+0x4a>
{
     fc8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fca:	fed7fae3          	bgeu	a5,a3,fbe <free+0x30>
     fce:	6398                	ld	a4,0(a5)
     fd0:	00e6e463          	bltu	a3,a4,fd8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fd4:	fee7eae3          	bltu	a5,a4,fc8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     fd8:	ff852583          	lw	a1,-8(a0)
     fdc:	6390                	ld	a2,0(a5)
     fde:	02059813          	sll	a6,a1,0x20
     fe2:	01c85713          	srl	a4,a6,0x1c
     fe6:	9736                	add	a4,a4,a3
     fe8:	fae60de3          	beq	a2,a4,fa2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     fec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     ff0:	4790                	lw	a2,8(a5)
     ff2:	02061593          	sll	a1,a2,0x20
     ff6:	01c5d713          	srl	a4,a1,0x1c
     ffa:	973e                	add	a4,a4,a5
     ffc:	fae68ae3          	beq	a3,a4,fb0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1000:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1002:	00001717          	auipc	a4,0x1
    1006:	00f73723          	sd	a5,14(a4) # 2010 <freep>
}
    100a:	6422                	ld	s0,8(sp)
    100c:	0141                	add	sp,sp,16
    100e:	8082                	ret

0000000000001010 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1010:	7139                	add	sp,sp,-64
    1012:	fc06                	sd	ra,56(sp)
    1014:	f822                	sd	s0,48(sp)
    1016:	f426                	sd	s1,40(sp)
    1018:	f04a                	sd	s2,32(sp)
    101a:	ec4e                	sd	s3,24(sp)
    101c:	e852                	sd	s4,16(sp)
    101e:	e456                	sd	s5,8(sp)
    1020:	e05a                	sd	s6,0(sp)
    1022:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1024:	02051493          	sll	s1,a0,0x20
    1028:	9081                	srl	s1,s1,0x20
    102a:	04bd                	add	s1,s1,15
    102c:	8091                	srl	s1,s1,0x4
    102e:	0014899b          	addw	s3,s1,1
    1032:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    1034:	00001517          	auipc	a0,0x1
    1038:	fdc53503          	ld	a0,-36(a0) # 2010 <freep>
    103c:	c515                	beqz	a0,1068 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    103e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1040:	4798                	lw	a4,8(a5)
    1042:	02977f63          	bgeu	a4,s1,1080 <malloc+0x70>
  if(nu < 4096)
    1046:	8a4e                	mv	s4,s3
    1048:	0009871b          	sext.w	a4,s3
    104c:	6685                	lui	a3,0x1
    104e:	00d77363          	bgeu	a4,a3,1054 <malloc+0x44>
    1052:	6a05                	lui	s4,0x1
    1054:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1058:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    105c:	00001917          	auipc	s2,0x1
    1060:	fb490913          	add	s2,s2,-76 # 2010 <freep>
  if(p == (char*)-1)
    1064:	5afd                	li	s5,-1
    1066:	a885                	j	10d6 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
    1068:	00001797          	auipc	a5,0x1
    106c:	3a078793          	add	a5,a5,928 # 2408 <base>
    1070:	00001717          	auipc	a4,0x1
    1074:	faf73023          	sd	a5,-96(a4) # 2010 <freep>
    1078:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    107a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    107e:	b7e1                	j	1046 <malloc+0x36>
      if(p->s.size == nunits)
    1080:	02e48c63          	beq	s1,a4,10b8 <malloc+0xa8>
        p->s.size -= nunits;
    1084:	4137073b          	subw	a4,a4,s3
    1088:	c798                	sw	a4,8(a5)
        p += p->s.size;
    108a:	02071693          	sll	a3,a4,0x20
    108e:	01c6d713          	srl	a4,a3,0x1c
    1092:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1094:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1098:	00001717          	auipc	a4,0x1
    109c:	f6a73c23          	sd	a0,-136(a4) # 2010 <freep>
      return (void*)(p + 1);
    10a0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    10a4:	70e2                	ld	ra,56(sp)
    10a6:	7442                	ld	s0,48(sp)
    10a8:	74a2                	ld	s1,40(sp)
    10aa:	7902                	ld	s2,32(sp)
    10ac:	69e2                	ld	s3,24(sp)
    10ae:	6a42                	ld	s4,16(sp)
    10b0:	6aa2                	ld	s5,8(sp)
    10b2:	6b02                	ld	s6,0(sp)
    10b4:	6121                	add	sp,sp,64
    10b6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    10b8:	6398                	ld	a4,0(a5)
    10ba:	e118                	sd	a4,0(a0)
    10bc:	bff1                	j	1098 <malloc+0x88>
  hp->s.size = nu;
    10be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10c2:	0541                	add	a0,a0,16
    10c4:	ecbff0ef          	jal	f8e <free>
  return freep;
    10c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10cc:	dd61                	beqz	a0,10a4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10d0:	4798                	lw	a4,8(a5)
    10d2:	fa9777e3          	bgeu	a4,s1,1080 <malloc+0x70>
    if(p == freep)
    10d6:	00093703          	ld	a4,0(s2)
    10da:	853e                	mv	a0,a5
    10dc:	fef719e3          	bne	a4,a5,10ce <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
    10e0:	8552                	mv	a0,s4
    10e2:	ae1ff0ef          	jal	bc2 <sbrk>
  if(p == (char*)-1)
    10e6:	fd551ce3          	bne	a0,s5,10be <malloc+0xae>
        return 0;
    10ea:	4501                	li	a0,0
    10ec:	bf65                	j	10a4 <malloc+0x94>
