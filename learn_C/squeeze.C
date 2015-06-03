#include <stdio.h>
#include <string.h>

int main()
{
	int i, len1, len2, len_short; 
	
	char s1[] = "october";
	char s2[] = "octopus";	
	
	len1 = strlen(s1); 
	len2 = strlen(s2); 
	
	if(len1 < len2){
		len_short = len2;
	} else {
		len_short = len1;
	}
	
	for(i = 0; i < len_short; i++){
		if (s1[i] == s2[i]){
			s1[i] = 'X'; 
		}
	}
		
	printf("%s\n", s1);
	
}