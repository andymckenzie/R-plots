/* #include <stdio.h> 
#include <ctype.h> 
#include <stdlib.h>
#include <unistd.h> */

int main(int argc, char *argv[])
{
    char str[] = "Hello world\n";

    /* Possible warnings will be encountered here, about implicit declaration
     * of `write` and `strlen`
     */
    write(1, str, strlen(str));
    /* `1` is the standard output file descriptor, a.k.a. `STDOUT_FILENO` */

    return 0;
}