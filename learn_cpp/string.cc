#include <string> // make the standard string facilities accessible 
#include <iostream> 

using namespace std; // make std names available without std:: prefix


string compose(const string& name, const string& domain) {
	return name + '@' + domain; 
}

int main(){
	auto addr = compose("dmr","bell−labs.com");
	cout << addr << "\n";
	
	string a = "test"; 
	string b = "er"; 
	string c = a + b; 
	c += '\n'; 
	
	cout << c; 
	return 0;
}