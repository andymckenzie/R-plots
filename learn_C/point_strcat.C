#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int MAXSIZE = 100; 
char s[] = "hello";
char t[] = "world";

int main(){
	char *p = strcat(s, t);
	if (p){
		printf("%s\n", p);
	}
	return 0; 
}

char *strcat(char *s, char *t) {
	
	int i; 
	char *ret;
	/* don't know why I have to cast this, but otherwise 
	I'm getting a compiler error */
	ret = (char*)malloc(MAXSIZE);
	
	if(!ret){
		return NULL;
	}
		
		
	i = 0;
	
	while(*s++ != '\0'){
		ret[i] = *s;
		i++;
	}
	
	while(*t++ != '\0'){
		ret[i] = *t;
		i++;
	}
		
	/* nevermind, can't easily get length of array via pointers in C 
	int len_s; 
	len_s = strlen(*s); */
		
	/*printf("%s\n", ret); */
		
	return(ret);
		
}