#include "animalclass.h"
#include <iostream>
#include <fstream>
#include <vector>

//supposed to sort an input file and output to something else, but not working...
//tried both implementations, would need to google but can't right now

using namespace std;

int main() {
	string from, to;
	cin >> from >> to;
	
	ifstream is {from};
	ofstream os {to};
	
	set<string> b {istream_iterator<string>{is},istream_iterator<string>{}}; 
	
	copy(b.begin(),b.end(),ostream_iterator<string>{os,"\n"});
	
	return !is.eof() || !os;
}