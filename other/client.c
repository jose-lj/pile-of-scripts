/* Client socket to obtain raw data from remote end in WR switch.
 * Non functional, just a sketch of what it needs to be.
 * Based on http://www.cs.rpi.edu/~moorthy/Courses/os98/Pgms/socket.html
 * examples by Mukkai S. Krishnamoorthy.
 */


#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 

void error(char *msg)
{
    perror(msg);
    exit(0);
}

int main(int argc, char *argv[])
{
    int sockfd, portno, n;

    struct sockaddr_in serv_addr;
    struct hostent *server;

    char buffer[512];
    if (argc < 3) {
       fprintf(stderr,"usage %s hostname port\n", argv[0]);
       exit(0);
    }
    portno = atoi(argv[2]);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname(argv[1]);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
    // printf("Please enter the message: ");
    bzero(buffer,512);
    for(;;)
    {
        //fgets(buffer,255,stdin);
        //n = write(sockfd,buffer,strlen(buffer));
        //if (n < 0) 
        //    error("ERROR writing to socket");
        n = recv(sockfd,buffer,sizeof(buffer),0);
        if (n < 0){
            error("ERROR reading from socket");
            return -1;
        }
        printf("%s",buffer);
        usleep(40000);
        // return 0;
    }
}
