#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <sys/stat.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <signal.h>
#include <poll.h>

#define PORT        3210
#define BACKLOG     5
#define FILEMODE    0777
#define TIMEOUT_MS  60000
#define BUFF_SIZE   256
#define LOG_PATH    "/tmp/digitech-server"
// "/home/mykhailo/github/university-homework/vountesmery-digitech-unix"

// 2. Описує глобальний дескриптор файла логу.

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
    char log_info[BUFF_SIZE];
    time( &log_timestamp );

    sprintf( log_info, "PID#%d; %.24s; \n%s\n\n", getpid(), ctime( &log_timestamp ), note );

    for(int attempts = 0; attempts < 5; attempts++){
        result = write( fd_log, (const char*)log_info, strlen(log_info) );
        if( result == -1 ){
            if( attempts == 4 ) {
                perror("write error");
                return;
            }
        } else {
            break;
        }
    }
    printf("%.8s %s\n", ctime( &log_timestamp ) + 11, note);
    return;
}

int wait_for_connection( int fd_serv ){
    int result;
    struct pollfd sfd;
    sfd.fd = fd_serv;
    sfd.events = POLLIN;
    //wait until data is available
    while(1){
        result = poll(&sfd, 1, 0);
        if(result == 0){
            continue;
        }
        if(result == -1){
            continue;
        };
        if(result > 0){
            if(sfd.revents & POLLERR){
                continue;
            }
            //recv() if data is available
            if(sfd.revents & POLLIN){
                result = fork();
                if( result == 0 ) {
                    return 0;
                } else {
                    raise(SIGSTOP);
                    continue;
                }
            }
        }
    }
}

int wait_for_msg(int fd_serv, int timeout_ms){
    int result;
    struct pollfd sfd;
    sfd.fd = fd_serv;
    sfd.events = POLLIN;
    time_t time_current;

    //wait until data is available
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
                perror("poll error:");
                return -1;
            }
            if(sfd.revents & POLLIN){
                return 0;
            }
        }
    }
}


void add_prefix( char* msg ){
    char temp[BUFF_SIZE];
    pid_t pid = getpid();
    time_t timestamp = time(&timestamp);
    memset( temp, '\0', BUFF_SIZE);
    sprintf( temp, "PID#%d; %.24s; %s", pid, ctime(&timestamp), msg);
    memcpy( msg, temp, BUFF_SIZE);
}

int daemonize(){
    int result;

    result = fork();
    if( result == -1 ){
        perror( "fork error" );
        return -1;
    } else if ( result != 0){
        exit(1);
    }

    pid_t sid_daemon = setsid();
    if( sid_daemon == -1 ){
        perror("setsid error");
        return -1;
    }

    result = fork();
    if( result == -1 ){
        perror("fork error");
        return -1;
    } else if ( result != 0 ){
        exit(1);
    }

    if( chdir("/") == -1 ){
        perror("chdir error");
        return -1;
    }

    umask(0);

    freopen( "/dev/null", "w+", stdin );
    freopen( "/dev/null", "w+", stdout );
    freopen( "/dev/null", "w+", stderr );

    return 0;
}

int main( int argc, char *argv[] ){
    int result;
    pid_t pid_main;

    result = daemonize();
    if( result == 1 ){
        return 0;
    } else if( result == -1 ){
        return -1;
    }

    pid_main = getpid();
    result = mkdir(LOG_PATH, FILEMODE);
    if( result == -1){
        if(errno != EEXIST){
            perror("unxpected mkdir() error");
            return -1;
        }
    }

    char* file_path = set_path( LOG_PATH,  "/log_program.txt" );
    fd_log_prog = open( file_path, O_CREAT|O_TRUNC|O_RDWR, FILEMODE );
    free( file_path );
    if( fd_log_prog == -1 ){
        perror( "open log as daemon error" );
        return -1;
    }
    log_entry( fd_log_prog, "daemon program log created" );


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
    log_entry( fd_log_prog, "socket() success" );

    int option = 1;
    result = setsockopt( fd_serv, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(int) );
    if( result == -1 ){
        perror( "setsockopt() error:" );
        log_entry( fd_log_prog, strerror( errno ) );
        return -1;
    }
    log_entry( fd_log_prog, "setsockopt() success" );

    result = bind( fd_serv, (struct sockaddr *)&address, addrlen );
    if( result == -1 ){
        perror( "bind() error:" );
        log_entry( fd_log_prog, strerror(errno) );
        return -1;
    }
    log_entry( fd_log_prog, "bind() success" );

    result = listen( fd_serv, BACKLOG );
    if( result == -1 ){
        perror( "listen() error:" );
        log_entry( fd_log_prog, strerror(errno) );
        return -1;
    }
    log_entry( fd_log_prog, "listen() success" );

    file_path = set_path( LOG_PATH, "/log_server.txt" );
    fd_log_serv = open( file_path, O_CREAT|O_TRUNC|O_RDWR, FILEMODE);
    free(file_path);
    log_entry( fd_log_prog, "server log created" );
    log_entry( fd_log_serv, "server log created" );

    log_entry( fd_log_serv, "connection polling started" );
    wait_for_connection( fd_serv );
    log_entry( fd_log_serv, "connection found" );

    int fd_client;
    fd_client = accept( fd_serv, (struct sockaddr *)&address, &addrlen );
    if( fd_client == -1 ){
        perror("accept() error:");
        log_entry( fd_log_prog, strerror( errno ) );
        return -1;
    }
    close( fd_serv );
    log_entry( fd_log_prog, "close(fd_serv)" );
    log_entry( fd_log_serv, "socket closed" );
    kill( pid_main, SIGCONT );
    log_entry( fd_log_prog, "accept() success" );
    log_entry( fd_log_serv, "connection opened" );

    char buffer[BUFF_SIZE];
    memset( buffer, '\0', BUFF_SIZE);
    strcpy( buffer, "\n\t\t----------------------------\n\t\t-- Welcome to the server! --\n\t\t----------------------------\n" );
    send( fd_client, buffer, strlen( buffer ), 0 );
    log_entry( fd_log_serv, "welcome msg sent" );

    while( 1 ){
        result = wait_for_msg( fd_client, TIMEOUT_MS );
        if( result == 1 ){
            log_entry( fd_log_serv, "timeout: no client actvity detected" );
            break;
        }

        memset( buffer, '\0', BUFF_SIZE );
        recv( fd_client, buffer, BUFF_SIZE, 0 );
        log_entry( fd_log_serv, "msg recieved" );
        if( strcmp( buffer, "close" ) == 0 ){
            log_entry( fd_log_serv, buffer);
            add_prefix( buffer );
            strcat( buffer, "\n\t\t----------------------------\n\t\t--------- Goodbye! ---------\n\t\t----------------------------\n");
            send( fd_client, buffer, strlen(buffer), 0);
            break;
        }

        log_entry( fd_log_serv, buffer);
        add_prefix( buffer );
        send( fd_client, buffer, strlen(buffer), 0);
    }

    close(fd_client);
    log_entry( fd_log_serv, "connection closed" );
    log_entry( fd_log_prog, "close(fd_client)" );

    log_entry( fd_log_serv, "server log finished" );
    log_entry( fd_log_prog, "close(fd_log_serv)" );
    close(fd_log_serv);
    log_entry( fd_log_prog, "close(fd_client)" );
    log_entry( fd_log_prog, "program log finished" );
    close(fd_log_prog);
    return 0;
}
