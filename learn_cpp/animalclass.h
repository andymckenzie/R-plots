#include <iostream>

using namespace std;

class Animal {
	public: 
	    void /*non-virtual*/ move(void) {
	        cout << "This animal moves in some way" << endl;
	    }
	public: 
	    virtual void eat(void) {}
};

// The class "Animal" may possess a definition for eat() if desired.
class Llama : public Animal {
	public: 
	    // The non virtual function move() is inherited but cannot be overridden
	    void eat(void) {
	        cout << "Llamas eat grass!" << endl;
	    }
};