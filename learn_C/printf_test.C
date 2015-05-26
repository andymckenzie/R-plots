#include <stdio.h> 
#include <ctype.h> 
#include <stdlib.h>

int main (){
	int c; 
	char ch[100];
	
	while ((c = getchar() != EOF))
		itoa(c, ch, 10);
		printf("%s", ch);
	return 0; 
}
	