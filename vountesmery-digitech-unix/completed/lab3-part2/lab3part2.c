// by Mykhailo SHPOTAK, Ivan PANCHENKO
// https://github.com/mshpotak/univeristy-homework/tree/master/vountesmery-digitech-unix/completed/lab3-part2

#include <signal.h>
#include <sys/types.h>
#include <sys/mman.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <string.h>
#include <errno.h>

#ifdef _POSIX_MAPPED_FILES
    void * mmap(void *start, size_t length, int prot , int flags, int fd, off_t offset);
    int munmap(void *start, size_t length);
#endif

#define STR_SIZE 256
#define FILE2MODE 0644

// Для приведення розміру розподіленого сегменту використовуйте ftruncate
// Перед читанням структури датуму з розподіленого сегменту, використовуйте msync

// 1. Описує структуру датума, яка містить ціле значення для ідентифікатора
// процесу, ціле значення для мітки часу та строку фіксованої довжини.
struct datum {
    int pid;
    long int timestamp;
    char str[STR_SIZE];
};

int write_shm(int fd_shm, struct datum *shmem_addr, int shm_size){
    int result;
    time_t curtime;

    result = msync(shmem_addr, shm_size, MS_SYNC);
    if(result == -1){
        perror("write_shm() msync() error:");
    }

    printf("Input a string:\t");
    while(1){
        result = scanf("%[^\n]s", shmem_addr->str);
        if(result == -1){
            perror("write_shm() scanf() error:");
            return -1;
        }
        if(result > STR_SIZE){
            printf("The string is too big. The number of symbols must be less then %d.\n", STR_SIZE);
            printf("Input another string:\t");
            continue;
        } else break;
    }
    shmem_addr->pid = getpid();
    time(&curtime);
    shmem_addr->timestamp = curtime;

    result = write(fd_shm, shmem_addr,shm_size);
    if(result == -1){
        perror("write_shm() write() error:");
        return -1;
    }
    printf("\nNew datum:\n\tPID:\t\t%d\n\tTimestamp:\t%.24s\n\tUser input:\t%s\n\n", shmem_addr->pid, ctime(&shmem_addr->timestamp), shmem_addr->str);
    while((getchar()) != '\n');
    getchar();

    return 0;
}

int read_shm(int fd_shm, struct datum *shmem_addr, int shm_size){
    int result;

    result = msync(shmem_addr, shm_size, MS_SYNC);
    if(result == -1){
        perror("read_shm() msync() error:");
        return -1;
    }

    result = read(fd_shm, shmem_addr, shm_size);
    if(result == -1){
        perror("read_shm() read() error:");
        return -1;
    }
    printf("Datum:\n\tPID:\t\t%d\n\tTimestamp:\t%.24s\n\tUser input:\t%s\n\n", shmem_addr->pid, ctime(&shmem_addr->timestamp), shmem_addr->str);
    getchar();

    return 0;
}

int rdwr_shm(int fd_shm, struct datum *shmem_addr, int shm_size){
    int result;
    time_t curtime;

    printf("\033c");
    // a. Запитує строку з клвіатури
    // b. Вичитує та презентує вміст структури датуму
    result = msync(shmem_addr, shm_size, MS_SYNC);
    if(result == -1){
        perror("rdwr_shm() msync() error:");
    }

    result = read(fd_shm, shmem_addr, shm_size);
    if(result == -1){
        perror("rdwr_shm() read() error:");
        return -1;
    }
    printf("Datum:\n\tPID:\t\t%d\n\tTimestamp:\t%.24s\n\tUser input:\t%s\n\n", shmem_addr->pid, ctime(&shmem_addr->timestamp), shmem_addr->str);
    // c. Записує у структуру натомість свій ідентификатор процесу, поточний час та отриману строку
    //memset(&mydata, 0, datum_size);
    printf("Input a string:\t");
    while(1){
        result = scanf("%[^\n]s", shmem_addr->str);
        if(result == -1){
            perror("rdwr_shm() scanf() error:");
            return -1;
        }
        if(result > STR_SIZE){
            printf("The string is too big. The number of symbols must be less then %d.\n", STR_SIZE);
            printf("Input another string:\t");
            continue;
        } else break;
    }
    shmem_addr->pid = getpid();
    time(&curtime);
    shmem_addr->timestamp = curtime;

    result = write(fd_shm, shmem_addr,shm_size);
    if(result == -1){
        perror("rdwr_shm() write() error:");
        return -1;
    }
    printf("\nNew datum:\n\tPID:\t\t%d\n\tTimestamp:\t%.24s\n\tUser input:\t%s\n\n", shmem_addr->pid, ctime(&shmem_addr->timestamp), shmem_addr->str);
    while((getchar()) != '\n');
    getchar();

    return 0;
}

int main(int argc, const char *argv[]){

    int result;
    struct datum *shmem_addr;
    int fd_shm;
    const int datum_size = sizeof(struct datum);
    int (*argfunc)(int, struct datum*, int) = NULL;

    // 2. Реєструє обїект розподіленої пам`яті через виклик shm_open
    //int shm_open(const char *name, int oflag, mode_t mode);
    fd_shm = shm_open("/shmlog.txt", O_CREAT|O_RDWR, FILE2MODE);
    if(fd_shm == -1){
        perror("shm_open() error:");
    }
    // 3. Приводить його до розміру кратного розміру структури датуму
    result = ftruncate(fd_shm, datum_size);
    if(result == -1){
        perror("ftruncate() error:");
    }
    // 4. Відображае отриманий об`єкт у пам`ять через показчик на структуру датуму та виклик mmap
    shmem_addr = (struct datum* ) mmap(NULL, datum_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd_shm, 0);
    if( shmem_addr == (void *) -1){
        perror("ftruncate() error:");
    }
    // 5. Переходить до нескінченного циклу у якому:
    if(argc == 2){
        if(!strcmp(argv[1],"-r")) argfunc = &read_shm;
        else if(!strcmp(argv[1],"-w")) argfunc = &write_shm;
        else if(!strcmp(argv[1],"-rw")) argfunc = &rdwr_shm;
        else printf("error: nonexistent argument");
    }else if(argc == 1){
        argfunc = &rdwr_shm;
    }else{
        printf("error: too many arguments.");
        return 0;
    }

    while(1){
        result = (*argfunc)(fd_shm, shmem_addr, datum_size);
        if(result == -1){
            continue;
        }
    }

    return 0;
}
