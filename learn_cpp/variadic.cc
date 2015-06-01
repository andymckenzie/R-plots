#include <iostream>

using namespace std; 

void f() { } // do nothing

template<typename T> 
void g(T x)
{
	cout << x << " "; 
}

template<typename T, typename... Tail> 
void f(T head, Tail... tail)
{
	g(head); // do something to head
	f(tail...); // try again with tail }
}

int main() {

	cout << "first: "; 
	f(1,2.2,"hello");

	cout << "\nsecond: "; 
	f(0.2,'c',"yuck!",0,1,2); 
	cout << "\n";

}