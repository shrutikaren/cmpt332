/*
	Shruti Kaur
	ICH524
	11339265
*/

#ifndef MONITOR_H
#define MONITOR_H

/*			Adding the default C library			     */
#include <stdio.h>
#include <stdlib.h>

/* 			Adding the RT threads library 			     */
#include <rtthreads.h>
#include <string.h> /* redundant code */
#include <fcntl.h> /* redundant code */
#include <errno.h> /* redundant code */
#include <sys/types.h> /* redundant code */
#include <sys/time.h> /* redundant code */
#include <unistd.h> /* redundant code */

/*			Adding our list files 				     */
#include <list.h>

/*			Function prototypes 				     */
void RttMonInit();
void RttMonEnter();
void RttMonLeave();
void RttMonSignal(int);
void MonServer();

#endif //MONITOR_H
