#include <stdio.h>

#define TIMES  0xf

#include <standards.h>
#include <os.h>

double dval = 3.1415;


PID pida;
PID pidb;

PROCESS a(int sem)
{
#ifdef FLOATTEST
    double dval = 3.1415;  /* testing for printing float values */
#endif
    int times = TIMES; 
    P(sem);
    printf("1 done P\n");
    V(sem);
    printf("1 done V\n");

    printf("a is sending a message to b \n");
    Send(pidb, NULL, 0);


    printf("dval is %lf\n", dval);


    printf("a received a reply from b \n");


    while(times--)
	{
        Sleep(4);
	printf("fasttimo\n");
        }
    Kill(pidb); 
}

PROCESS b(int sem)
{
    int times = TIMES;
    int len;
    PID pid;
#ifdef FLOATTEST
    double pi = 3.14159;
    int  unusedInt = 0;

    printf("Pi is %lf   %d\n", pi,unusedInt); 
#endif

    printf(" in 2\n");
    V(sem);
    printf("2 done V\n");
    P(sem);
    printf("2 done P\n");

    Receive(&pid, &len);    /* await a message from a */
    printf("b received a message from a \n");

    Reply( pid, NULL, 0 );
    printf("b replied to a\n");

    while(times--)
	{
        Sleep(10);
	printf("              slowtimo\n");
	}
}

void mainp()
{
    long sem;

    setbuf(stdout, 0);
    sem = NewSem(0);
    pida = Create( (void(*)()) a, 16384, "a", (void *) sem, NORM, USR );
    pidb = Create( (void(*)()) b, 16384, "b", (void *) sem, NORM, USR );
    printf("threads created\n");
}
