#include <stdio.h> 
#include <ctype.h> 
#include <stdlib.h>
#include <unistd.h>

int main (){
	int c; 
	
	if (isatty(fileno(stdout)))  /* #include <unistd.h> */
	  setbuf(stdout, NULL);
	
	while ((c = getchar() != EOF))
		putchar(tolower(c));
	return 0; 
}
	