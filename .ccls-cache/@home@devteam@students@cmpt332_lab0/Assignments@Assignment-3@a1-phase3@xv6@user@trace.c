#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include <stdio.h>

int
main(int argc, char *argv[])
{
    if(argc < 3){
        printf(2, "Usage: trace <mask> <command> [args...]\n");
    }

    int mask = atoi(argv[1]);

    if(trace(mask) < 0){
        printf(2, "trac: failed to set trace mask!\n");
        exit();
    }

    exec(argv[2], &argc[2]);

    printf(2, "trace: exec failed\n");
    exit();

}
