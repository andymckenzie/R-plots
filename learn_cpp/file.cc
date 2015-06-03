#include <iostream> 
#include <fstream>

// also tried to use sstreams, but that didn't get very far 

using namespace std;


fstream ifs("test.txt"); 
	
int main(){
	
	if (!ifs)
		cerr << "couldn't open 'source' for reading"; 
	
	if(ifs)
		cout << "yeah\n"; 
	
	string str; 
	
	ifs >> str; 
	
	cout << str; 
	 
}