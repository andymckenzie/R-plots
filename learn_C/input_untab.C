#include "stdio.h"

int main(){ 
	FILE *fp;
	fp=fopen("test.txt", "r");
	char c;
	if (fp) {
	    while ((c = getc(fp)) != EOF)
			if(c == '\t'){
				printf(" ");
				printf(" ");
				printf(" ");
				printf(" ");
			} else { putchar(c); }
	    fclose(fp);
	}
	return(0);
}