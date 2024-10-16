#ifndef MONITOR_H
#define MONITOR_H

/* Function Prototypes */
RttMonInit(*void);
RttMonEnter(*void);
RttMonLeave(*void);
RttMonWait(int);
RttMonSignal(int);
MonServer(*void);

#endif /* MONITOR_H */
