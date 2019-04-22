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

#define BUFFER_SIZE 256
#define FILE2MODE 0644

// Для приведення розміру розподіленого сегменту використовуйте ftruncate
// Перед читанням структури датуму з розподіленого сегменту, використовуйте msync

// 1. Описує структуру датума, яка містить ціле значення для ідентифікатора
// процесу, ціле значення для мітки часу та строку фіксованої довжини.
struct datum {
    int pid;
    long int timestamp;
    char str[128];
} data;

int main(int argc, const char *argv[]){
    int result;
    struct datum *shmem_addr;
    int fd_shm;
    const int datum_size = sizeof(struct datum);
    printf("%d", datum_size);
    //int page_size = getpagesize();
    char input_buff[128];
    struct datum mydata;
    //struct datum *pdata = &data;
    pid_t pid = getpid();
    time_t curtime;

    // 2. Реєструє обїект розподіленої пам`яті через виклик shm_open
    //int shm_open(const char *name, int oflag, mode_t mode);
    fd_shm = shm_open("/shmlog.txt", O_CREAT|O_TRUNC|O_RDWR, FILE2MODE);
    if(fd_shm == -1){
        perror("shm_open() error:");
    }
    // 3. Приводить його до розміру кратного розміру структури датуму
    result = ftruncate(fd_shm, datum_size);
    if(result == -1){
        perror("ftruncate() error:");
    }
    // 4. Відображае отриманий об`єкт у пам`ять через показчик на структуру датуму та виклик mmap
    shmem_addr = (struct datum* ) mmap(NULL, datum_size, PROT_NONE, MAP_SHARED, fd_shm, 0);
    if( shmem_addr == (void *) -1){
        perror("ftruncate() error:");
    }
    getchar();
    // 5. Переходить до нескінченного циклу у якому:
    while(1){
        printf("\033c");
        // a. Запитує строку з клвіатури
        // b. Вичитує та презентує вміст структури датуму
        result = msync(shmem_addr, datum_size, MS_SYNC);
        if(result == -1){
            perror("msync() error:");
        }
        //memcpy(&mydata, &data, datum_size);
        mydata = *shmem_addr;
        printf("Datum:\n\tPID:\t\t%d\n\tTimestamp:\t%.24s\n\tUser input:\t%s\n\n", mydata.pid, ctime(&mydata.timestamp), mydata.str);
        // c. Записує у структуру натомість свій ідентификатор процесу, поточний час та отриману строку
        memset(&mydata, 0, datum_size);
        printf("Input a string:\t");
        result = scanf("%[^\n]s", input_buff);

        mydata.pid = pid;
        time(&curtime);
        mydata.timestamp = curtime;
        strcpy(mydata.str, input_buff);
        //memcpy(&data, &mydata, datum_size);
        *shmem_addr = mydata;
        printf("\nNew datum:\n\tPID:\t\t%d\n\tTimestamp:\t%.24s\n\tUser input:\t%s\n\n", mydata.pid, ctime(&mydata.timestamp), mydata.str);
        while((getchar()) != '\n');
        getchar();
    }

}
