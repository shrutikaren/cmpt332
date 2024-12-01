/* driver-PC.c - Driver Test Code */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/wait.h>

#define BUFFER_SIZE 256
#define FIFO_READ "/dev/fifo1"  /* Read end of the FIFO */
#define FIFO_WRITE "/dev/fifo0" /* Write end of the FIFO */

/* Function to handle critical errors */
void handle_error(const char *msg) {
    perror(msg);
    exit(EXIT_FAILURE);
}

int main() {
    pid_t pid;
    int fd_write, fd_read;
    char write_buf[] = "Hello from the producer process!";
    char read_buf[BUFFER_SIZE];
    ssize_t n, bytes_written, bytes_to_write;

    /* Create a child process */
    pid = fork();
    if (pid < 0) {
        handle_error("Failed to fork");
    }

    if (pid == 0) {
        /* Child process - Consumer */
        printf("Consumer: Opening read end of FIFO: %s\n", FIFO_READ);

        /* Open the FIFO for reading */
        fd_read = open(FIFO_READ, O_RDONLY);
        if (fd_read < 0) {
            handle_error("Consumer failed to open read end");
        }

        /* Read from the FIFO */
        printf("Consumer: Waiting for data...\n");
        n = read(fd_read, read_buf, BUFFER_SIZE - 1); /* Leave space for null terminator */
        if (n < 0) {
            perror("Consumer read failed");
            close(fd_read);
            exit(EXIT_FAILURE);
        } else if (n == 0) {
            /* No data to read */
            printf("Consumer: End of FIFO reached, no data to read.\n");
        } else {
            read_buf[n] = '\0'; /* Null-terminate the read buffer */
            printf("Consumer read: %s\n", read_buf);
        }

        /* Close the read end of the FIFO */
        close(fd_read);
        printf("Consumer: Read operation completed.\n");
    } else {
        /* Parent process - Producer */
        printf("Producer: Opening write end of FIFO: %s\n", FIFO_WRITE);

        /* Open the FIFO for writing */
        fd_write = open(FIFO_WRITE, O_WRONLY);
        if (fd_write < 0) {
            handle_error("Producer failed to open write end");
        }

        /* Ensure the consumer is ready before writing */
        sleep(1);

        /* Write to the FIFO */
        printf("Producer: Writing to FIFO...\n");
        bytes_to_write = strlen(write_buf);
        bytes_written = write(fd_write, write_buf, bytes_to_write);
        if (bytes_written < 0) {
            perror("Producer write failed");
            close(fd_write);
            exit(EXIT_FAILURE);
        } else if (bytes_written < bytes_to_write) {
            /* Handle partial writes */
            printf("Producer: Partial write. Expected %zd, but wrote %zd bytes.\n", bytes_to_write, bytes_written);
        } else {
            printf("Producer wrote: %s\n", write_buf);
        }

        /* Close the write end of the FIFO */
        close(fd_write);
        printf("Producer: Write operation completed.\n");

        /* Wait for the child process to complete */
        wait(NULL);
    }

    return 0;
}
