#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <stdio.h>
#include <unistd.h>
#include <errno.h>

#include <stdlib.h>

#define FILE2MODE 0644

void print_error(){
    perror("Error:\t");

    char input;
    printf("Do you want to continue? y/n\n");

    answer:
    if((input = getchar()) == 'y'){
        return;
    } else if(input == 'n'){
        exit(-1);
    } else {
        goto answer;
    }
    return;
}

void alter_letters(char *buffer, int buffer_size){
    int pos;
    for(int i = 0; i < buffer_size; i++)
        if((buffer[i]>=97)&&(buffer[i]<=122)) buffer[i] -= 32;
    return;
}

int main(int argc, const char *argv[]){
    //check for 2 arguments
    if(argc != 3) {
        printf("Error. Enter 2 arguments.\n");
        return -1;
    }
    int file1fd, file2fd;
    //open 1st file as RD
    do{
      if((file1fd = open(argv[1], O_RDONLY)) == -1)
        print_error();
    }while(file1fd == -1);
    //open 2nd file as RDWR and rewrite
        //create 2nd file if it doesn't exist
    do{
      if((file2fd = open(argv[2], (O_RDWR|O_CREAT|O_TRUNC), FILE2MODE)) == -1)
          print_error();
    }while(file1fd == -1);

    int buffer_size = 512;
    char buffer[buffer_size];
    //make a loop
    int bytes_rd, total_rd = 0;
    int bytes_wr, total_wr = 0;
    do{
        bytes_rd = 0;
        bytes_wr = 0;
        //read 512 bytes from 1st file and count read bytes
        do{
            if((bytes_rd = read(file1fd, buffer, buffer_size)) == -1)
                print_error();
        }while(bytes_rd == -1);

            //make all small letters big
        alter_letters(buffer, bytes_rd);

        do{
            if((bytes_wr = write(file2fd,(const char*)buffer, bytes_rd)) == -1)
                print_error();
        }while(bytes_wr == -1);
        //write 512 bytes to second file
            //count written bytes
        total_rd += bytes_rd;
        total_wr += bytes_wr;
        //break when EOF is reached
    } while(bytes_rd == buffer_size);
    //print and return the amount of written bytes
    printf("\n\nTotal bytes read:\t %d\n", total_rd);
    printf("Total bytes written:\t %d\n", total_wr);
    return bytes_wr;
}
