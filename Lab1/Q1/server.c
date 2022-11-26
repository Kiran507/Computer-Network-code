
// Server side C program
 
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>


#define PORT 8080


int main()
{  
    int socketId;
    if((socketId = socket(AF_INET, SOCK_STREAM, 0)) == 0)                                        // Creating socket file descriptor
    {   perror("socket failed");
        exit(EXIT_FAILURE);   }
  
  
  
    int opt = 1;
    if(setsockopt(socketId, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt)))        // Forcefully attaching socket to the port 8080
    {   perror("setsockopt");
        exit(EXIT_FAILURE);   }
        
        
        
    struct sockaddr_in address; 
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
  
  

    if(bind(socketId, (struct sockaddr*)&address, sizeof(address)) < 0)                         // Forcefully attaching socket to the port 8080
    {   perror("bind failed");
        exit(EXIT_FAILURE);    }
         
    if(listen(socketId, 3) < 0) 
    {   perror("listen");
        exit(EXIT_FAILURE);    }
        
        
        
    int newSocketId, addrlen=sizeof(address);
    if((newSocketId = accept(socketId, (struct sockaddr*)&address, (socklen_t*)&addrlen)) < 0) 
    {   perror("accept");
        exit(EXIT_FAILURE);    }
        
        
        
    char buffer[1024] = {0};
    int valread = read(newSocketId, buffer, 1024);
    printf("%s\n", buffer);
    
    
    
    char* serverMessage = "Hello from server";
    send(newSocketId, serverMessage, strlen(serverMessage), 0);
    printf("Hello message sent\n");
    
 
 
    close(newSocketId);                        // closing the connected socket   
    shutdown(socketId, SHUT_RDWR);             // closing the listening socket 
}









