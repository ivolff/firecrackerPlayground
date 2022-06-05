#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sstream>
#include <iostream>



#ifdef EXEC_COMMAND
int main (int argc, char *argv[]) {
  printf("COMMAND NAME: %s",EXEC_COMMAND);
  int pipeFromSock[2];
  int pipeToSock[2];
  pipe(pipeFromSock);
  pipe(pipeToSock);
  char buffer[20];

  int num_bytes;
  if (fork()) {
    dup2(pipeToSock[0], 0);
    dup2(pipeFromSock[1], 1);
    close(pipeToSock[0]);
    close(pipeToSock[1]);
    close(pipeFromSock[0]);
    close(pipeFromSock[1]);
    execlp("/usr/host/nc-vsock", "/usr/host/nc-vsock", "-l", "52", NULL);
  } else {
    // Parent process
    close(pipeToSock[0]);
    close(pipeFromSock[1]);
    //if (argc == 2) {
    dup2(pipeToSock[1], 1);
    dup2(pipeFromSock[0], 0);
    system(EXEC_COMMAND);
    close(pipeToSock[1]);
    close(pipeFromSock[0]);
    system("reboot");
  }
  exit(EXIT_FAILURE);
}
#else
    #error "no DXEC_COMMAND given"
#endif
