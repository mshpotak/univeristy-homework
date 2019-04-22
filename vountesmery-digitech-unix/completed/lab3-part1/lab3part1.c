#include <signal.h>
#include <sys/types.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <string.h>
#include <errno.h>

#define BUFFER_SIZE 256
#define FILE2MODE 0644

// 1. Описує глобальний дескриптор файла логу.
int fd_log;

// 2. Описує функцію-обробник сигналів, прототипу
// void signal_handler( int signo, siginfo_t *si, void *ucontext );
void signal_handler(int signum, siginfo_t *si, void *ucontext){
    int result;
    char buffer[BUFFER_SIZE];
    time_t curtime;
    time(&curtime);

    // 3. У функції-обробнику виконати запис у файлі логу з докладним розкриттям
    // структури siginfo_t, яка подана на вхід.
    result = sprintf(buffer, "%.24s: Program terminated\nTermination info: \n\tSIGNO: %d\n\tSIGERR: %d\n\tSIGCD: %d\n", ctime(&curtime), si->si_signo, si->si_errno, si->si_code);
    if( result == -1 ){
        perror("sprintf error:");
        close(fd_log);
        exit(-1);
    }

    result = write(fd_log, buffer, strlen(buffer));
    if( result == -1 ){
        perror("write error:");
        close(fd_log);
        exit(-1);
    }

    exit(0);
}

int main(int argc, const char *argv[]){
        // 4. Відкриває файл логу на запис.
    fd_log = open("log.txt", O_CREAT|O_TRUNC|O_RDWR, FILE2MODE);
    if(fd_log == -1){
        perror("fd_log open error:");
        return 0;
    }

    int result;
    char buffer[BUFFER_SIZE];
    pid_t pid = getpid();
    time_t curtime;
    time(&curtime);

        // 5. Відмічає в ньому факт власного запуску та свій pid.
    result = sprintf(buffer, "%.24s: Program started with PID: %d\n", ctime(&curtime), pid);
    if(result == -1){
        perror("main sprintf error:");
        close(fd_log);
        return 0;
    }

    result = write(fd_log, buffer, strlen(buffer));
    if( result == -1 ){
        perror("main write error:");
        close(fd_log);
        exit(-1);
    }

    // 6. Описує структуру sigaction, у якій вказує на функцію обробник.
    const struct sigaction action = {
        // void (*sa_handler)(int);
        // void (*sa_sigaction)(int, siginfo_t *, void *);
        .sa_sigaction = &signal_handler,
        // sigset_t sa_mask;
        // int sa_flags;
        .sa_flags = SA_SIGINFO
        // void (*sa_restorer)(void);
    };
    struct sigaction action_old;

    // 7. Реєструє обробник для сигналу SIGHUP із збереженням попереднього
    // обробника.
    // int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact);
    sigaction(SIGHUP, &action, &action_old);

    // 8. Переходить до нескінченного циклу із засинанням на кілька секунд та
    // відмітками у файлі логу.
    while(1){
        sleep(2);
        time(&curtime);
        result = sprintf(buffer, "%.24s: Waiting\n", ctime(&curtime));
        if(result == -1){
            perror("main sprintf error:");
            close(fd_log);
            return 0;
        }

        result = write(fd_log, buffer, strlen(buffer));
        if( result == -1 ){
            perror("main write error:");
            close(fd_log);
            exit(-1);
        }
    }

    return 0;
}
