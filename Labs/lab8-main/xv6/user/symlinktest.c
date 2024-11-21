/* Shruti Kaur 
 * ICH524
 * 11339265 */

#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/fctnl.h"

int main(){
	if (symlink("targetfile", "symlinkfile") < 0){
		printf("Unsuccessful at symbolic linking\n");
		exit(1);
	}
	printf("Successful at symbolic linking\n");
	exit(0);
}

