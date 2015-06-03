#include <stdio.h> 
#include <ctype.h> 
#include <stdlib.h>
#include <unistd.h> 
#include <string.h>

int main(int argc, char *argv[])
{
	char input_buffer[100];
	int i = 0; /* index into input_buffer */
	int c;
	while ((c = getchar()) != EOF) {
	    input_buffer[i] = c;
	    i ++;
	}
	input_buffer[i] = '\0'; /* ensure that it's properly null-terminated */

    /* Possible warnings will be encountered here, about implicit declaration
     * of `write` and `strlen`
     */
	printf("%-10.15s \n",  input_buffer);
	
    /* write(1, input_buffer, strlen(input_buffer));
	strlen returns the number of bytes transferred, theoretically 
    `1` is the standard output file descriptor, a.k.a. `STDOUT_FILENO` */

    return 0;
}