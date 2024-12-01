#include <linux/circ_buf.h> /* For circular buffers */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

/* Creating the producer that produce those messages.
 * It will write data intothe circular buffer while
 * ensuring that it doesn't overwrite any data */

/* Consumer code that consumes the message produced */
