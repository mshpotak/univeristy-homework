#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <linux/unistd.h>
#include <sys/syscall.h>

#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>

#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define FILE2MODE 0644

int log_entry(int file_fd, const char* note){
    int result;
    time_t log_timestamp;
    char log_info[256];
    time( &log_timestamp );

    sprintf( log_info, "PID# %d; %.24s; \n%s\n\n", getpid(), ctime( &log_timestamp ), note );

    result = write( file_fd, (const char*)log_info, strlen(log_info) );
    if( result == -1 ){
        perror("write error:");
        if(close(file_fd) == -1){
            perror("close error:");
        };
        return -1;
    }

    //printf( "New log entry:\n \t%s\n", log_info );
    return 0;
}

int main(){
    int file_fd;

    file_fd = open( "log.txt", O_CREAT|O_RDWR|O_TRUNC, FILE2MODE );
    if( file_fd == -1 ){
        perror("open error:");
        return 0;
    }

    int result;

    if( log_entry(file_fd, "log started") == -1){
        return 0;
    }
    pid_t pid_main = getpid();
    pid_t ppid_main = getppid();
    pid_t sid_main = getsid(pid_main);
    pid_t tid_main = syscall(SYS_gettid);
    uid_t uid_main = getuid();
    gid_t gid_main = getgid();

    printf("Main process IDs:\n");
    printf("PID: %d\n", pid_main);
    printf("PPID: %d\n", ppid_main);
    printf("SID: %d\n", sid_main);
    printf("TID: %d\n", tid_main);
    printf("UID: %d\n", uid_main);
    printf("GID: %d\n\n", gid_main);

    pid_t pid_daemon;
    pid_t pid_current;

    result = fork();
    if( result == -1 ){
        perror("fork error:");
        if( close(file_fd) == -1 ){
            perror("close error:");
        };
        return 0;
    } else if ( result == 0){
        pid_daemon = getpid();
    } else {
        pid_daemon = result;
    }
    pid_current = getpid();


    if(pid_current == pid_main){
        if( log_entry(file_fd, "fork process started") == -1 ){
            if( close(file_fd) == -1 ){
                perror("close error:");
            };
            kill(pid_daemon, SIGKILL);
            return 0;
        }

        if( log_entry(file_fd, "main process closed") == -1 ){
            if(close(file_fd) == -1){
                perror("close error:");
            };
            kill(pid_daemon, SIGKILL);
            return 0;
        }

        exit(0);
    }

    pid_t sid_daemon = setsid();
    if( sid_daemon == -1 ){
        perror("setsid error:");
    }

    pid_main = pid_daemon;
    result = fork();
    if( result == -1 ){
        perror("fork error:");
        if( close(file_fd) == -1 ){
            perror("close error:");
        };
        return 0;
    } else if ( result == 0){
        pid_daemon = getpid();
    } else {
        pid_daemon = result;
    }
    pid_current = getpid();

    if(pid_current == pid_main){
        if( log_entry(file_fd, "daemon process started") == -1 ){
            if( close(file_fd) == -1 ){
                perror("close error:");
            };
            kill(pid_daemon, SIGKILL);
            return 0;
        }

        if( log_entry(file_fd, "fork process closed") == -1 ){
            if(close(file_fd) == -1){
                perror("close error:");
            };
            kill(pid_daemon, SIGKILL);
            return 0;
        }

        exit(0);
    }

    if( chdir("/") == -1 ){
        perror("chdir error:");
        if( close(file_fd) == -1 ){
            perror("close error:");
        };
        return 0;
    }

    if(close(file_fd) == -1){
        perror("close error:");
        return 0;
    };

    file_fd = open( "/dev/null", O_WRONLY);
    if( file_fd == -1 ){
        perror("open error:");
        return 0;
    }
    if( dup2(0, file_fd) == -1 ){     //redirect STDIN
        perror("dup2 error:");
        close(file_fd);
        return 0;
    };
    if( dup2(1, file_fd) == -1 ){     //redirect STDOUT
        perror("dup2 error:");
        close(file_fd);
        return 0;
    };
    if( dup2(2, file_fd) == -1 ){     //redirect STDERR
        perror("dup2 error:");
        close(file_fd);
        return 0;
    };

    if( close(file_fd) == -1 ){
        perror("close error:");
        return 0;
    };

    file_fd = open( "/home/mykhailo/github/university-homework/vountesmery-digitech-unix/log.txt", O_WRONLY|O_APPEND);
    if( file_fd == -1 ){
        perror("open1 error:");
        return 0;
    }

    pid_daemon = getpid();
    pid_t ppid_daemon = getppid();
    sid_daemon = getsid(pid_daemon);
    pid_t tid_daemon = syscall(SYS_gettid);
    uid_t uid_daemon = getuid();
    gid_t gid_daemon = getgid();

    printf("\nDaemon process IDs:\n");
    printf("PID: %d\n", pid_daemon);
    printf("PPID: %d\n", ppid_daemon);
    printf("SID: %d\n", sid_daemon);
    printf("TID: %d\n", tid_daemon);
    printf("UID: %d\n", uid_daemon);
    printf("GID: %d\n\n", gid_daemon);

    char buffer[512];
    sprintf(buffer, "daemon PID is #%d\ndaemon PPID is #%d\ndaemon SID is #%d\ndaemon TID is #%d\ndaemon UID is #%d\ndaemon GID is #%d", pid_daemon, ppid_daemon, sid_daemon, tid_daemon, uid_daemon, gid_daemon);
    if( log_entry(file_fd, buffer) == -1 ){
        if( close(file_fd) == -1 ){
            perror("close error:");
        };
        return 0;
    }

    while(1){};

    return 0;
}
