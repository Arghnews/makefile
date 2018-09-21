#include "xxhash.h"

#include <iostream>
#include <iterator>
#include <vector>

#include "a.h"

#include "prettyprint.hpp"

int main()

{
  std::cout << "Hello world " << aa() << "\n";

  char arr[] = "asd";
  std::cout << XXH64(arr, std::size(arr), 0) << "\n";


  std::cout << std::vector{3, 4} << "\n";

  return 0;
}
