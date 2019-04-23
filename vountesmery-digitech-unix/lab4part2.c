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

int main(){
    int result;
    int buffer_size = 256;
    char buffer [ buffer_size ];

    // 1.Описує структуру struct sockaddr_in з параметрами: формат сокетів - PF_INET,
    // адреса - обчислена за викликом htonl(INADDR_LOOPBACK), порт - 3200 +
    // номер варіанта.
    struct sockaddr_in address;
    socklen_t addrlen = sizeof( struct sockaddr_in );
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    address.sin_port = htons( PORT );
    memset( &( address.sin_zero ), '\0', 8 );

    // 2. Формує сокет типу SOCK_STREAM формату PF_INET.
    int fd_serv;
    fd_serv = socket( PF_INET, SOCK_STREAM, 0);

    // 3. Налаштовує сокет на підключення до сервера за допомогою connect.
    result = connect( fd_serv, (struct sockaddr *)&address, addrlen);

    // 4. В нескінченному циклі запитує рядки від оператора, передає їх на сервер та
    // друкує отримані відповіді.
    int death = 0;
    result = fork();
    if(result == 0){
        //pid_recv = getpid();
        struct pollfd sfd;
        sfd.fd = fd_serv;
        sfd.events = POLLIN;
        while(1){

            if((result = poll(&sfd, 1, 1000)) == -1){
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
                    if(recv(fd_serv, buffer, buffer_size, 0) == -1){
                        perror("receive error:");
                        continue;
                    }
                    printf("Server:\t%s\n", buffer);
                    if(death == 1){
                        return 0;
                    };
                }
            }
        }
    } else {
        //pid_send = getpid();
        while(1){
            printf("Input a string:\t");
            result = scanf("%[^\n]s", buffer);
            if(result == -1){
                perror("scanf() error:");
                continue;
            }
            if(result > buffer_size){
                printf("The string is too big. The number of symbols must be less then %d.\n", buffer_size);
                continue;
            }

            send(fd_serv, buffer, strlen(buffer), 0);
            if( strcmp( buffer, "close" ) == 0){
                death = 1;
                return 0;
            }
            // 5. Робота закінчується після вводу оператором рядка "close" та отримання на
            // нього відповіді від сервера.
        }
    }
    return 0;
}
