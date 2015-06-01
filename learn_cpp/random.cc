#include <numeric> 
#include <random> 
#include <iostream>

//this works ... nb that my compiler (g++) req'd use of double rather than single quotes around the asterisk 

using namespace std;

class Rand_int { 
	public:
		Rand_int(int low, int high) :dist{low,high} { }
		int operator()() { return dist(re); } // draw an int 
	private:
		default_random_engine re;
		uniform_int_distribution<> dist; 
};

int main() {
	constexpr int max = 8; 
	Rand_int rnd {0,max};

	vector<int> histogram(max +1);
	for (int i = 0; i != 200; ++i)
		++histogram[rnd()];
	for (int i = 0; i!=histogram.size(); ++i) { // write out a bar graph 
		cout << i << '\t';
		for (int j=0; j!=histogram[i]; ++j) cout << "*";
		cout << endl; 
	}
}
