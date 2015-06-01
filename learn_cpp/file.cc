#include <iostream> 
#include <fstream>

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