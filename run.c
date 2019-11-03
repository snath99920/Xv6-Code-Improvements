#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char * argv[])
{
    int pid;//, x = 0;
    if((pid = fork())==0){
        // for(int i=0; i<2147483648; i++)
        // {
        //     x = (x * i)%1024;
        //     // printf(1, "Giri gaiiiiiii!\n");
        // }
        // x = x + 12*21;
        sleep(5);
    }
    // int x = 0;
    sleep(4);
    // for(int i=0; i<200000000; i++)
    // {
    //     x = (x * i)%1024;
    //     // printf(1, "Giri gaiiiiiii!\n");
    // }
    printf(1, "Program ended\n");
    exit();
    }