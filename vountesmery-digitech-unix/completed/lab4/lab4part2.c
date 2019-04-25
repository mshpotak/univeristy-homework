// by Mykhailo SHPOTAK
// https://github.com/mshpotak/univeristy-homework/tree/master/vountesmery-digitech-unix/completed/lab4

#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <signal.h>
#include <poll.h>

#define PORT 3210

int wait_for_msg(int fd_serv, int timeout_ms){
    int result;
    struct pollfd sfd;
    sfd.fd = fd_serv;
    sfd.events = POLLIN;
    time_t time_current;
    while(1){
        result = poll(&sfd, 1, timeout_ms);
        time( &time_current );
        if(result == 0){
            return 1;
        }
        if(result == -1){
            perror("poll error:");
            return -1;
        };
        if(result > 0){
            if(sfd.revents & POLLERR){
                return -1;
            }
            if(sfd.revents & POLLIN){
                return 0;
            }
        }
    }
    return 1;
}

int main(){
    int result;
    time_t time_current;

    struct sockaddr_in address;
    socklen_t addrlen = sizeof( struct sockaddr_in );
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl( INADDR_LOOPBACK );
    address.sin_port = htons( PORT );
    memset( &( address.sin_zero ), '\0', 8 );

    int fd_serv;
    fd_serv = socket( PF_INET, SOCK_STREAM, 0);
    if( fd_serv == -1 ){
        perror( "socket() error:" );
        return -1;
    }
    time(&time_current);
    printf("%.8s Socket created\n", ctime( &time_current ) + 11 );

    int option = 1;
    result = setsockopt( fd_serv, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(int) );
    if( result == -1 ){
        perror( "setsockopt() error:" );
        return -1;
    }
    time(&time_current);
    printf("%.8s Address reuse enabled\n", ctime( &time_current ) + 11 );

    result = connect( fd_serv, (struct sockaddr *)&address, addrlen );
    if( result == -1 ){
        perror( "connect() error:" );
        return -1;
    }
    time(&time_current);
    printf("%.8s Connection requested\n", ctime( &time_current ) + 11 );

    char buffer [256];
    while(1){
        result = wait_for_msg( fd_serv, 5 );
        if( result == 0 ){
            if( strcmp( buffer, "close" ) == 0 ){
                memset( buffer, '\0', 256 );
                result = recv( fd_serv, buffer, 256, 0 );
                time( &time_current );
                printf( "%.8s Server: %s\n", ctime( &time_current ) + 11, buffer );
                break;
            }
            memset( buffer, '\0', 256 );
            result = recv( fd_serv, buffer, 256, 0 );
            time( &time_current );
            printf( "%.8s Server: %s\n", ctime( &time_current ) + 11, buffer );
        } else if( result == -1 ){
            time( &time_current );
            printf( "%.8s Connection error", ctime( &time_current ) + 11 );
            break;
        } else if( result == 1 ){
            time( &time_current );
            printf( "%.8s Server not responding:\n", ctime( &time_current ) + 11 );
            if( strcmp( buffer, "close" ) == 0 ){
                break;
            }
        }

        memset( buffer, '\0', 256 );
        time( &time_current );
        printf( "%.8s    You: ", ctime( &time_current ) + 11 );
        scanf( "%[^\n]", buffer );
        while( ( getchar() ) != '\n' );
        result = send( fd_serv, buffer, strlen( buffer ), 0 );
    }

    close( fd_serv );
    time( &time_current );
    printf("%.8s Connection closed\n", ctime( &time_current ) + 11 );
    return 0;
}
