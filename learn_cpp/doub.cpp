#include <iostream>
#include <vector>

using namespace std;

class Vector { public:
Vector(int s) :elem{new double[s]}, sz{s} { } double& operator[](int i) { return elem[i]; } int size() { return sz; }
private:
double∗ elem; // pointer to the elements int sz; // the number of elements
// construct a Vector
// element access: subscripting
};

Vector v;

struct Vector {
int sz; // number of elements double∗ elem; // pointer to elements
};

void vector_init(Vector& v, int s) {
	v.elem = new double[s]; // allocate an array of s doubles
	v.sz = s; 
}

double read_and_sum(int s)
// read s integers from cin and return their sum; s is assumed to be positive
{
	vector v;
	vector_init(v,s); // allocate s elements for v for (int i=0; i!=s; ++i)
	cin>>v.elem[i]; // read into elements
	double sum = 0;
	for (int i=0; i!=s; ++i)
	sum+=v.elem[i]; // take the sum of the elements return sum;
}

int main ()
{
	int SIZE = 3; 
	int res;
	res = read_and_sum(SIZE);
	cout << res;
	
	return 0; 
	
}