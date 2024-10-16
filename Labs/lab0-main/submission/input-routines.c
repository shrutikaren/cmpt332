/*Name: KAUR Shruti
Student Number: 11339265
NSID: ICH524
*/

/* string input routines
 * @author: Kernighan/Ritchie
 * @date: 1978
 */

/* string input routines
 * @author: Kernighan/Ritchie
 * @date: 1978
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <qsort.h>

#define MAXLEN 100

int myGetline(char s[], int lim){

  int c, i = 0;	

	while(--lim > 0 && (c = getchar()) != EOF && c != '\n'){
		s[i++] = c;
	}

	if(c == '\n'){
		s[i++] = '\0';
	}

	s[i] = '\0';

  return i;

}

int readlines(char *lineptr[], int maxlines){

  int len, nlines;
  char *p = NULL, line[MAXLEN];

  nlines=0;
  while ((len = myGetline(line, MAXLEN)) > 0)
    {
      if (nlines >= maxlines || (p = (char *)malloc(len)) == NULL)
        return -1;
      else
        {
          line [len-1] = '\0';
          memmove(p, line, len);
          lineptr[nlines++] = p;
        }
    }

  return nlines;
}

void writelines(char *lineptr[], int nlines){
  while (nlines-- >0){
    printf("%s\n", *lineptr++);
  }
}
