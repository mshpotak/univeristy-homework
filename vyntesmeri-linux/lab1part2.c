#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <select.h>

int main(int argc, const *char[] argv){
    //write argument identifier to the buffer

    //make a loop
        //set select() for *readfds with *timeout of 5 seconds

        //if data is availbale read data <1024 bytes long
        //print read data as identifier
        //if time has run out perror() identifier
}
