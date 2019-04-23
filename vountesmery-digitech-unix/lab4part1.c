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

int fd_log_prog;
int fd_log_serv;

// 1. Кожна дія сервера супроводжується відміткою у логу.
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
    return;
}

int daemonize(){
    int result;
    pid_t pid_main = getpid();
    pid_t pid_current;
    pid_t pid_daemon;

    result = fork();
    if( result == -1 ){
        perror( "fork error:" );
        if( close(fd_log_prog) == -1 ){
            perror( "close error:" );
        };
        return -1;
    } else if ( result == 0){
        pid_daemon = getpid();
    } else {
        pid_daemon = result;
    }
    pid_current = getpid();


    if(pid_current == pid_main){
        log_entry( fd_log_prog, "fork process started" );
        log_entry( fd_log_prog, "main process closed" );
        return 0;
    }

    pid_t sid_daemon = setsid();
    if( sid_daemon == -1 ){
        perror("setsid error:");
    }

    pid_main = pid_daemon;
    result = fork();
    if( result == -1 ){
        perror("fork error:");
        if( close( fd_log_prog ) == -1 ){
            perror("close error:");
        };
        return -1;
    } else if ( result == 0 ){
        pid_daemon = getpid();
    } else {
        pid_daemon = result;
    }
    pid_current = getpid();

    if( pid_current == pid_main ){
        log_entry( fd_log_prog, "daemon process started" );
        log_entry( fd_log_prog, "fork process closed" );
        return 0;
    }

    if( chdir("/") == -1 ){
        perror("chdir error:");
        if( close(fd_log_prog) == -1 ){
            perror("close error:");
        };
        return -1;
    }

    if( close( fd_log_prog ) == -1) {
        perror("close fd_log_prog error:");
        return -1;
    };
    if( close(0) == -1 ){
        perror("close stdin error:");
        return -1;
    };
    if( close(1) == -1 ){
        perror("close stdout error:");
        return -1;
    };
    if( close(2) == -1 ){
        perror("close stderr error:");
        return -1;
    };

    freopen( "/dev/null", "w+", stdin );
    freopen( "/dev/null", "w+", stdout );
    freopen( "/dev/null", "w+", stderr );

    fd_log_prog = open( "/home/mykhailo/github/university-homework/vountesmery-digitech-unix/log_program.txt", O_WRONLY|O_APPEND);
    if( fd_log_prog == -1 ){
        perror("open log as daemon error:");
        return -1;
    }

    log_entry(fd_log_prog, "daemonize() succesfull");
    return pid_daemon;
}

void wait_for_connection(int fd_serv){
    int result;
    struct pollfd sfd;
    sfd.fd = fd_serv;
    sfd.events = POLLIN;

    //wait until data is available
    while(1){
        result = poll(&sfd, 1, 1000);
        if(result == -1){
            perror("poll error:");
            continue;
        };
        if(result > 0){
            //check for error
            if(sfd.revents & POLLERR){
                perror("poll revents error:");
                continue;
            }
            //recv() if data is available
            if(sfd.revents & POLLIN){
                result = fork();
                if( result == 1 ) {
                    continue;
                } else {
                    close(fd_serv);
                    return;
                }
            }
        }
    }
}

int main( int argc, char *argv[] ){
    int result;
    pid_t pid_prog = 0;

    fd_log_prog = open( "log_program.txt", O_CREAT|O_TRUNC|O_RDWR, 0644 );
    // 1. Виконує демонізацію, подальший функціонал стосується демона.
    // pid_prog = daemonize();
    // if( (pid_prog == 0) || (pid_prog < 0) ){
    //     return 0;
    // }
    // // 3. Описує структуру struct sockaddr_in з параметрами: формат сокетів - PF_INET,
    // // адреса - будь яка, порт - 3200 + номер варіанта.

    struct sockaddr_in address;
    socklen_t addrlen = sizeof( struct sockaddr_in );
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons( PORT );
    memset( &( address.sin_zero ), '\0', 8 );

    // // 4. Формує сокет типу SOCK_STREAM формату PF_INET.
    int fd_serv;
    fd_serv = socket( PF_INET, SOCK_STREAM, 0);
    log_entry( fd_log_prog, "socket created" );

    // // 5. Налаштовує сокет на очікування запитів за допомогою bind.
    result = bind( fd_serv, (struct sockaddr *)&address, addrlen);
    log_entry( fd_log_prog, "bind created" );
    // // 6. Запускає нескінченний цикл обробки запитів від клієнтів.
    int fd_client;
    pid_t pid_client;
    time_t curtime;
    int hname_size = 64;
    char hname [ hname_size ];
    int buffer_size = 256;
    char buffer [ buffer_size ];
    int bytes_read;
    int bytes_sent;
    // char send_buffer[256];
    // char recv_buffer[256];
    result = listen( fd_serv, BACKLOG );
    printf("Hey0");
    log_entry( fd_log_prog, "started listening" );
    printf("Hey1");
    fd_log_serv = open( "/home/mykhailo/github/university-homework/vountesmery-digitech-unix/log_server.txt", O_CREAT|O_TRUNC|O_RDWR, 0644);
    printf("Hey2");
    while(1){
        // 7. На кожний запит виконує fork для породження процесу обробки.
        wait_for_connection(fd_serv);
        log_entry( fd_log_serv, "connection found" );

        fd_client = accept( fd_serv, (struct sockaddr *)&address, &addrlen );
        log_entry( fd_log_serv, "opened connection" );

        pid_client = getpid();
        //sends welcome message to the new client
        time( &curtime );
        gethostname( hname, hname_size );
        sprintf( buffer, "\t\t-- Welcome to the server, %s! --\nPID#%dSERV_PID#%d; %.24s; Connection opened.\n", hname, pid_prog, pid_client, ctime( &curtime ) );
        send( fd_client, buffer, strlen( buffer ), 0 );
        log_entry( fd_log_serv, "welcome message sent" );
        // 9. Процес обробки в нескінченному циклі отримує від клієнта строки за
        // допомогою recv, додає до них свій префікс у вигляді поточного часу та
        // власного pid, та повертає клієнту за допомогою send.
        while(1){
            bytes_read = recv( fd_client, buffer, buffer_size, 0 );
            log_entry( fd_log_serv, "message recieved" );
            // 10. Процес обробки завершує обробку даних від клієнта отримавши строку
            // "close".
            if( strcmp( buffer, "close" ) == 0 ){
                time( &curtime );
                sprintf( buffer, "PID#%dSERV_PID#%d; %.24s; Connection closed.\n\t\t-- Goodbye, %s! --\n", pid_prog, pid_client, ctime( &curtime ), hname );
                bytes_sent = send( fd_client, buffer, strlen( buffer ), 0);
                close( fd_client);
                log_entry( fd_log_serv, "connection closed" );
                log_entry( fd_log_prog, "connection closed" );
                break;
            }

            time( &curtime);
            sprintf( buffer, "PID#%dSERV_PID#%d; %.24s; %s!\n", pid_prog, pid_client, ctime( &curtime ), buffer );
            bytes_sent = send( fd_client, buffer, strlen( buffer ), 0);
        }
    }
    // 8. Батьківський процес закриває сокет.

    return 0;
}
