#include <iostream>
#include <vector>
#include <algorithm> // std::min_element
#include <iterator>  // std::begin, std::end

int main() {
    std::vector<int> v = {5,14,10,4,6};
    auto result = std::min_element(std::begin(v), std::end(v));
    if (std::end(v)!=result)
        std::cout << *result << '\n';
}