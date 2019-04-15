#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <time.h>

void user_exit(){
    printf("Do you want to continue (y/n)? \n");
    char input;

    answer:
    if((input = getchar()) == 'y'){
        printf("\n\n");
        return;
    } else if(input == 'n'){
        printf("Parent process is dead!\n");
        exit(-1);
    } else {
        goto answer;
    }
    return;
}

int main(){
    //1
    printf("#1:\n");
    pid_t pid_me = getpid();
    pid_t pid_parent = getppid();
    pid_t pid_session = getsid(pid_me);
    printf("PID: %d\n", pid_me);
    printf("PPID: %d\n", pid_parent);
    printf("SID: %d\n\n", pid_session);

    getchar();

    //2
    printf("#2:\n");
    pid_t res;
    pid_t pid_fork1;
    pid_t pid_current;
    int status;
    int options = 0;
    clock_t timer_start;
    double time_end = 3;
    double time_count = 0;
    int period = 0;

    while(1){
        res = fork();
        pid_current = getpid();
        if(res == -1){
            perror("fork() error");
            continue;
        } else if(res == 0){
            pid_fork1 = pid_current;
            printf("Child process is born!\n");
            timer_start = clock();
        } else {
            pid_fork1 = res;
        }

        if(pid_current == pid_fork1){
            printf("FORK PID: %d\n", pid_fork1);
        }
        if(pid_current == pid_me){
            printf("MY PID: %d\n", pid_me);
        }

        while(1){
            if(pid_current == pid_me){
                res = wait(&status);
                if(res == -1){
                    perror("waitpid() error");
                    return 0;
                } else if(res == pid_fork1){
                    printf("Parent process is finished!\n");
                    break;
                }
            }
            if(pid_current == pid_fork1){
                time_count = (double)(clock() - timer_start)/CLOCKS_PER_SEC;
                if((int)time_count == period){
                    printf("Child lived %.0f out of %.0f...\n", time_count, time_end);
                    period++;
                }
                if(time_count >= time_end){
                    printf("Child process is dead!\n");
                    return 0;
                }
            }
        }
        user_exit();
    }
    printf("Parent process is dead!\n");
    return 0;
}
