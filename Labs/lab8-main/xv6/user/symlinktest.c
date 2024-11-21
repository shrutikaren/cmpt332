/* Shruti Kaur 
 * ICH524
 * 11339265 */

#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "fs.h"

#undef memcpy
#undef memmove
#undef memset
#undef memcmp
#undef strchr
#undef strlen

#include "/usr/local/riscv/riscv64-unknown-elf/include/sys/errno.h"

int errno; /* Defining it globally */
int main(){
	symlink("targetfile", "symlinkfile");


	if (*__errno != EEXIST){
		printf("Error detected with following: %d\n", *__errno);
		exit(1);
	}
	printf("Successful at symbolic linking\n");
	return 0;
}

