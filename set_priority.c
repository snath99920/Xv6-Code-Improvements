#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int 
main(int argc, char * argv[])
{
    int priority;
    int pid;
    
    if(argc<3)
    {
        printf(2, "Error: Exiting\n");
        exit();
    }
    pid = atoi(argv[1]);
    priority = atoi(argv[2]);
    if(priority < 0 || priority > 100)
    {
        printf(2, "Invalid priority!\n");
        exit();
    }
    printf(1, " Process %d\n Priority %d\n", pid, priority);
    set_priority(pid, priority);
    exit();
}