#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>


int main(){
    // 1.Описує структуру struct sockaddr_in з параметрами: формат сокетів - PF_INET,
    // адреса - обчислена за викликом htonl(INADDR_LOOPBACK), порт - 3200 +
    // номер варіанта.
    sockaddr_in

    // 2. Формує сокет типу SOCK_STREAM формату PF_INET.
    socket(int __domain, int __type, int __protocol)

    // 3. Налаштовує сокет на підключення до сервера за допомогою connect.
    connect(int __fd, const struct sockaddr *__addr, socklen_t __len)

    while(1){
        // 4. В нескінченному циклі запитує рядки від оператора, передає їх на сервер та
        // друкує отримані відповіді.

        send()
        poll()
        recv()

        // 5. Робота закінчується після вводу оператором рядка "close" та отримання на
        // нього відповіді від сервера.
    }

    return 0;
}
