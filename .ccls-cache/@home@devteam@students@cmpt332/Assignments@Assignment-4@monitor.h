/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

/* CMPT 332 GROUP 34 Change, Fall 2024 */
/* Phase 1 */

#ifndef MONITOR_H 
#define MONITOR_H

void MonEnter(void);
void MonLeave(void);
void MonWait(int);
void MonSignal(int);
void MonInit(void);

#endif // MONITOR_H


