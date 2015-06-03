#include <string> // make the standard string facilities accessible 
#include <iostream> 

using namespace std; // make std names available without std:: prefix


string compose(const string& name, const string& domain) {
	return name + '@' + domain; 
}

int main(){
	auto addr = compose("dmr","bell−labs.com");
	cout << addr << "\n";
	
	int a = 1;
	int b = 2; 
	int c = a + b; 	
	cout << hex << 7887 << '\n'; 
	return 0;
}