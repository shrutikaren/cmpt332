/* reader-writer.h
 * Dwight Makaroff October 27, 2011
 * necessary because I split up the 2 source files
 * for the reader-writer problem
 */

void Initialize(void);
void StartRead(void);
void StopRead(void);
void StartWrite(void);
void StopWrite(void);
