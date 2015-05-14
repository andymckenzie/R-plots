#include <stdio.h> 

int main()
{
	int fahr, celsius; 
	int lower, upper, step; 
	
	lower = 0; 
	upper = 300; 
	step = 20;
		
	printf("hello, world\n");
	 
	for(fahr = lower; fahr <= upper; fahr += step){
		
		celsius = 5 * (fahr - 32)/9; 
		printf("%c[1;33m%d\t%d\n", 27, fahr, celsius); 	
		
	}
		
}