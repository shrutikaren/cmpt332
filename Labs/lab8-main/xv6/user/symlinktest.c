/* Shruti Kaur 
 * ICH524
 * 11339265 */

#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"

#undef memcpy
#undef memmove
#undef memset
#undef memcmp
#undef strchr
#undef strlen

#include <errno.h>

char *strerror(int errnum);

int main(){
	symlink("targetfile", "symlinkfile");


	if (errno != 0){
		char *error = strerror(errno);
		printf("Error detected with following: %s\n", error);
		exit(1);
	}
	printf("Successful at symbolic linking\n");
	return 0;
}

