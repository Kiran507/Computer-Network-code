
// Client side C program  
 
#include <arpa/inet.h> 
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h> 


#define PORT 8080
  
  
int main()
{ 
    int socketId = 0;   
    if((socketId = socket(AF_INET,SOCK_STREAM,0)) < 0) 
    {   printf("\n Socket creation error \n");
        return -1;   }
  
  
  
    struct sockaddr_in serv_addr;
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
   
    if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0)                 // Convert IPv4 and IPv6 addresses from text to binary form
    {   printf("\nInvalid address \n");
        return -1;    }
  
   
  
    int client_fd;
    if((client_fd = connect(socketId, (struct sockaddr*)&serv_addr, sizeof(serv_addr))) < 0) 
    {   printf("\nConnection Failed \n");
        return -1;    }
        
        
       
    char* messageClient = "Hello from client";   
    send(socketId, messageClient, strlen(messageClient), 0); 
    printf("Hello message sent\n");
    
    
    
    char buffer[1024] = {0};
    int valread = read(socketId, buffer, 1024);
    printf("%s\n", buffer);
  
    
    
    close(client_fd);                 // closing the connected socket 
}









