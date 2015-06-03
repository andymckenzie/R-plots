#include <iostream>

template<class TYPE>
void PrintTwice(TYPE data)
{
    std::cout<<"Twice: " << data * 2 << std::endl;
}

int main(void){
	
	int int_to_call = 120; 
	double doub_to_call = 120; 
	
	PrintTwice(int_to_call); // 240
	
	PrintTwice(doub_to_call); // 240
		
}