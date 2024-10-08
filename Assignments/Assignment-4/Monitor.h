/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

/* CMPT 332 GROUP 34 Change, Fall 2024 */
/* Phase 1 */

#ifndef MONITOR_H 
#define MONITOR_H

#include <os.h>
#include <standards.h>

void MonEnter();
void MonLeave();
void MonWait(int);
void MonSignal(int);
void MonInit();

#endif /* MONITOR_H */
