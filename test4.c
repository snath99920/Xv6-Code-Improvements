#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char * argv[])
{
	int x=0;
	for (volatile long long int i = 0; i < 1000000*atoi(argv[1]); i++)
    {
        x++;
    }
    printf(1,"%d\n", atoi(argv[1]));
	
	exit();
}