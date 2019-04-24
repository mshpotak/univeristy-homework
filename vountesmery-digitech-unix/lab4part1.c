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
#define BACKLOG 5

// 2. Описує глобальний дескриптор файла логу.

char path[] = "/home/mykhailo/github/university-homework/vountesmery-digitech-unix/";
int fd_log_prog;
int fd_log_serv;

char* set_path( char* path, char* file_name){
    int p_len = strlen(path);
    int fn_len = strlen(file_name);
    char* file_path = (char*)calloc(p_len+fn_len, sizeof(char));
    strcpy(file_path, path);
    strcat(file_path, file_name);
    return file_path;
}

void log_entry( int fd_log, const char* note ){
    int result;
    time_t log_timestamp;
    char log_info[256];
    int attempts = 0;
    time( &log_timestamp );

    sprintf( log_info, "PID#%d; %.24s; \n%s\n\n", getpid(), ctime( &log_timestamp ), note );

    retry:
    result = write( fd_log, (const char*)log_info, strlen(log_info) );
    if( result == -1 ){
        attempts++;
        if( attempts >= 5 ) {
            perror("write error:");
            return;
        }
        goto retry;
    }
    printf("%.8s %s\n", ctime( &log_timestamp ) + 11, note);
    return;
}

int wait_for_connection(int fd_serv){
    int result;
    struct pollfd sfd;
    sfd.fd = fd_serv;
    sfd.events = POLLIN;
    //wait until data is available
    while(1){
        result = poll(&sfd, 1, 5000);
        if(result == 0){
            //printf("%.8s No connections found...\n", ctime( &time_current ) + 11 );
            continue;
        }
        if(result == -1){
            perror("poll error:");
            return -1;
        };
        if(result > 0){
            //check for error
            if(sfd.revents & POLLERR){
                //perror("poll revents error:");
                continue;
            }
            //recv() if data is available
            if(sfd.revents & POLLIN){
                result = fork();
                if( result == 0 ) {
                    return 0;
                } else {
                    //continue;
                    exit(0);
                }
            }
        }
    }
    return 1;
}

int wait_for_msg(int fd_serv, double timeout){
    int result;
    struct pollfd sfd;
    sfd.fd = fd_serv;
    sfd.events = POLLIN;
    time_t time_start, time_current;
    time( &time_start );
    //wait until data is available
    time( &time_current );
    while( (timeout == 0) || ( difftime( time_current, time_start ) < timeout ) ){
        result = poll(&sfd, 1, 5000);
        time( &time_current );
        if(result == 0){
            printf("%.8s No connections found...\n", ctime( &time_current ) + 11 );
            continue;
        }
        if(result == -1){
            perror("poll error:");
            return -1;
        };
        if(result > 0){
            //check for error
            if(sfd.revents & POLLERR){
                //perror("poll revents error:");
                continue;
            }
            if(sfd.revents & POLLIN){
                return 0;

            }
        }
    }
    return 1;
}


void add_prefix( char* msg ){
    char temp[256];
    pid_t pid = getpid();
    time_t timestamp = time(&timestamp);
    memset( temp, '\0', 256);
    sprintf( temp, "PID#%d; %.24s; %s", pid, ctime(&timestamp), msg);
    memcpy( msg, temp, 256);
}

int main( int argc, char *argv[] ){
    int result;
    char* file_path = set_path( path,  "log_program.txt" );

    fd_log_prog = open( file_path, O_CREAT|O_TRUNC|O_RDWR, 0644 );
    log_entry( fd_log_prog, "program log created" );

    struct sockaddr_in address;
    socklen_t addrlen = sizeof( struct sockaddr_in );
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl( INADDR_ANY );
    address.sin_port = htons( PORT );
    memset( &( address.sin_zero ), '\0', 8 );

    int fd_serv;
    fd_serv = socket( PF_INET, SOCK_STREAM, 0);
    if( fd_serv == -1 ){
        perror( "socket() error:" );
        log_entry( fd_log_prog, strerror( errno ) );
        return -1;
    }
    log_entry( fd_log_prog, "socket created" );

    int option = 1;
    result = setsockopt( fd_serv, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(int) );
    if( result == -1 ){
        perror( "setsockopt() error:" );
        log_entry( fd_log_prog, strerror( errno ) );
        return -1;
    }
    log_entry( fd_log_prog, "address reuse enabled" );

    result = bind( fd_serv, (struct sockaddr *)&address, addrlen );
    if( result == -1 ){
        perror( "bind() error:" );
        log_entry( fd_log_prog, strerror(errno) );
        return -1;
    }
    log_entry( fd_log_prog, "bind created" );

    result = listen( fd_serv, BACKLOG );
    if( result == -1 ){
        perror( "listen() error:" );
        log_entry( fd_log_prog, strerror(errno) );
        return -1;
    }
    log_entry( fd_log_prog, "started listening" );

    file_path = set_path( path, "log_server.txt" );
    fd_log_serv = open( file_path, O_CREAT|O_TRUNC|O_RDWR, 0644);
    log_entry( fd_log_prog, "server log created" );
    log_entry( fd_log_serv, "server log created" );

    log_entry( fd_log_serv, "connection polling started" );
    result = wait_for_connection( fd_serv );
    if( result == -1 ){
        perror("polling error:");
        return 0;
    }
    log_entry( fd_log_serv, "connection found" );

    int fd_client;
    fd_client = accept( fd_serv, (struct sockaddr *)&address, &addrlen );
    close(fd_serv);

    if( fd_client == -1 ){
        perror( "accept() error:" );
        log_entry( fd_log_prog, strerror( errno ) );
        return -1;
    }
    log_entry( fd_log_serv, "connection opened" );

    char buffer[256] = {"\n\t\t----------------------------\n\t\t-- Welcome to the server! --\n\t\t----------------------------\n"};

    result = send( fd_client, buffer, strlen( buffer ), 0 );
    log_entry( fd_log_serv, "welcome msg sent" );

    while( 1 ){
        result = wait_for_msg( fd_client, 0 );
        if( result == 1 ){
            log_entry( fd_log_serv, "timeout: no client actvity detected" );
            close( fd_client );
            log_entry( fd_log_serv, "connection closed" );
            break;
        }

        memset( buffer, '\0', 256 );
        result = recv( fd_client, buffer, 256, 0 );
        log_entry( fd_log_serv, "msg recieved" );
        if( strcmp( buffer, "close" ) == 0 ){
            add_prefix( buffer );
            log_entry( fd_log_serv, buffer);
            strcat( buffer, "\n\t\t----------------------------\n\t\t--------- Goodbye! ---------\n\t\t----------------------------\n");
            result = send( fd_client, buffer, strlen(buffer), 0);
            break;
        }

        add_prefix( buffer );
        result = send( fd_client, buffer, strlen(buffer), 0);
        log_entry( fd_log_serv, buffer);
    }

    close(fd_client);
    close(fd_serv);
    close(fd_log_serv);
    close(fd_log_prog);
    return 0;
}
