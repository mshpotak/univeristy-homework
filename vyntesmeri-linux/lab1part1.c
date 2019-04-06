#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>

void print_error(){
    perror("Error:\n");

    char input;
    prinf("Do you want to continue? y/n\n");

    answer:
    if((input = getchar()) == 'y'){
        continue;
    } else if(input == 'n'){
        exit();
    } else {
        goto answer;
    }
    return;
}

void alter_letters(char *buffer, int buffer_size){
    int pos;
    for(int i = 0; i < buffersize; i++)
        if((buffer[i]>=97)&&(buffer[i]<=122)) buffer[i] -= 32;
    printf("%s\n", buffer);
    return;
}

int main(int argc, const *char[] argv){
    //check for 2 arguments
    if(argc != 3) perror("Error. Enter 2 arguments.\n");
    int file1fd, file2fd;
    //open 1st file as RD
    if((file1fd = open(argv[1],O_RDONLY)) == -1)
        print_error();
    //open 2nd file as RDWR and rewrite
        //create 2nd file if it doesn't exist
    if((ile2fd = open(argv[2],(O_RDWR|O_CREAT|O_TRUNC)) == -1)
        print_error();

    int buffer_size = 512;
    char buffer[buffer_size];
    //make a loop
    int bytes_rd = 0, total_rd = 0;
    int bytes_wr = 0, total_wr = 0;
    do{
        //read 512 bytes from 1st file and count read bytes
        while(bytes_rd < 0){
            if((bytes_rd = read(file1fd, buffer, buffer_size)) == -1)
                print_error();
        }

            //make all small letters big
        alter_letters(buffer, bytes_rd);
        printf("%s\n", buffer);

        while(bytes_wr < 0){
        if((bytes_wr = write()) == -1)
            print_error();
        }
        //write 512 bytes to second file
            //count written bytes
        total_rd += bytes_rd;
        total_wr += bytes_wr;
        bytes_rd = 0;
        bytes_wr = 0;

        //break when EOF is reached
    } while(bytes_rd == buffer_size);
    //print and return the amount of written bytes
    printf("\n\nTotal bytes read:\t %d\n", bytes_rd);
    printf("\n\nTotal bytes written:\t %d\n", bytes_wr);
    return bytes_wr;
}
