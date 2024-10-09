/*
 * Shruti Kaur
 * ICH524
 * 11339265
 * */

#include <rtthreads.h>
#include <RttCommon.h>

#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <string.h>
#include <stdbool.h>

/* https://beej.us/guide/bgnet/html/split/man-pages.html#fcntlman */
#include <curses.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>                

/* Error Logging Macro */
#define LOG_ERROR(msg) do {                             \
    fprintf(stderr, "Log [Error] - %s: %s at %s:%d\n",  \
        msg, strerror(errno), __FILE__, __LINE__);      \
    exit(EXIT_FAILURE);                                 \
} while(0)

/* Constants */
#define MAX_SIZE 1024
#define SHORT_DURATION 1000  /* microseconds */
#define CTRL_C 3
#define ARGS 4

/* Data Structures */
typedef struct {
    char c;
    long timestamp;
    int controlFlags;
} CharacterData;

/* Queue Node Structure */
typedef struct QueueNode {
    CharacterData data;
    struct QueueNode* next;
} QueueNode;

/* Queue Structure */
typedef struct {
    QueueNode* head;
    QueueNode* tail;
} Queue;

/* Mutexes */
RttSem outgoingMutex;
RttSem incomingMutex;

/* Global Queues */
Queue outgoingQueue;
Queue incomingQueue;

/* Global Variables */
bool keepRunning = true;
int udpSocket;
struct sockaddr_in remoteAddress;

/* Function Prototypes */
void KeyboardInputThread();
void UdpInputThread();
void ScreenOutputThread();
void UdpTransmitThread();
void ServerThread();

/* Helper Function Prototypes */
CharacterData GetCurrentTime();
void DisplayCharacter(char c);
char* Serialize(CharacterData data);
CharacterData Deserialize(char* dataStr);
void InitializeQueue(Queue* queue);
void Enqueue(Queue* queue, CharacterData data, RttSem* mutex);
bool Dequeue(Queue* queue, CharacterData* data, RttSem* mutex);

/* Main Function */
int mainp(int argc, char* argv[]) {
    int local, remote;
    char* hostName;
    RttThreadId kbThread, udpInThread, screenOutThread, udpTransThread, 
	srvThread;

    if (argc != ARGS) {
        LOG_ERROR("Incorrect number of arguments");
    }

    local = atoi(argv[1]);
    hostName = argv[2];
    remote = atoi(argv[3]);

    /* Initialize curses */
    initscr();
    cbreak();
    noecho();
    nodelay(stdscr, TRUE);

    /* Initialize mutexes */
    if (RttAllocSem(&outgoingMutex, 1, RTTFCFS) != RTTOK) {
        LOG_ERROR("Failed to allocate outgoingMutex");
    }
    if (RttAllocSem(&incomingMutex, 1, RTTFCFS) != RTTOK) {
        LOG_ERROR("Failed to allocate incomingMutex");
    }

    /* Initialize Queues */
    InitializeQueue(&outgoingQueue);
    InitializeQueue(&incomingQueue);

    /* Initialize UDP Socket */
    udpSocket = socket(AF_INET, SOCK_DGRAM, 0);
    if (udpSocket < 0) {
        LOG_ERROR("Failed to create UDP socket");
    }

    memset(&remoteAddress, 0, sizeof(remoteAddress));
    remoteAddress.sin_family = AF_INET;
    remoteAddress.sin_port = htons(remote);
    if (inet_pton(AF_INET, hostName, &remoteAddress.sin_addr) <= 0) {
        LOG_ERROR("Invalid address/ Address not supported");
    }

    /* Create threads */
    if (RttCreate(&kbThread, KeyboardInputThread, 0, "KeyboardInputThread", 
                 NULL, RTTNODEADLINE, RTTHIGH) != RTTUSR) {
        LOG_ERROR("Failed to create KeyboardInputThread");
    }
    if (RttCreate(&udpInThread, UdpInputThread, 0, "UdpInputThread", 
                 NULL, RTTNODEADLINE, RTTHIGH) != RTTUSR) {
        LOG_ERROR("Failed to create UdpInputThread");
    }
    if (RttCreate(&screenOutThread, ScreenOutputThread, 0, 
                 "ScreenOutputThread", NULL, RTTNODEADLINE, RTTHIGH) != RTTUSR){
        LOG_ERROR("Failed to create ScreenOutputThread");
    }
    if (RttCreate(&udpTransThread, UdpTransmitThread, 0, 
                 "UdpTransmitThread", NULL, RTTNODEADLINE, RTTHIGH) != RTTUSR){
        LOG_ERROR("Failed to create UdpTransmitThread");
    }
    if (RttCreate(&srvThread, ServerThread, 0, "ServerThread", 
                 NULL, RTTNODEADLINE, RTTHIGH) != RTTUSR) {
        LOG_ERROR("Failed to create ServerThread");
    }

    /* Wait for threads to finish */

    /* Cleanup curses */
    endwin();

    return EXIT_SUCCESS;
}

/* Initialize Queue */
void InitializeQueue(Queue* queue) {
    queue->head = NULL;
    queue->tail = NULL;
}

/* Enqueue Function */
void Enqueue(Queue* queue, CharacterData data, RttSem* mutex) {

}

/* Dequeue Function */
bool Dequeue(Queue* queue, CharacterData* data, RttSem* mutex) {
    return false;
}

/* Keyboard Input Thread */
void KeyboardInputThread() {
    while (keepRunning) {
        RttUSleep(SHORT_DURATION);
    }
}

/* UDP Input Thread */
void UdpInputThread() {
    while (keepRunning) {
        RttUSleep(SHORT_DURATION);
    }
}

/* Screen Output Thread */
void ScreenOutputThread() {
    while (keepRunning) {
        RttUSleep(SHORT_DURATION);
    }
}

/* UDP Transmit Thread */
void UdpTransmitThread() {
    while (keepRunning) {
        RttUSleep(SHORT_DURATION);
    }
}

/* Server Thread */
void ServerThread() {
    while (keepRunning) {
        RttUSleep(SHORT_DURATION);
    }
}

/* Get Current Time */
CharacterData GetCurrentTime() {
    CharacterData data;
    return data;
}

/* Display Character */
void DisplayCharacter(char c) {
  
}

/* Serialize CharacterData */
char* Serialize(CharacterData data) {
    return NULL;
}

/* Deserialize Data */
CharacterData Deserialize(char* dataStr) {
    CharacterData data;
    return data;
}
