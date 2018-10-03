#include "xxhash.h"

#include <iostream>
#include <iterator>
#include <vector>

#include "a.h"

#include "prettyprint.hpp"

template <typename T, std::size_t N>
constexpr std::size_t size(const T(&)[N])
{
  return N;
}

int main()
{
  std::cout << "Hello world " << aa() << "\n";

  const char arr[] = "asd";
  std::cout << XXH64(arr, size(arr), 0) << "\n";

  std::cout << std::vector<int>{3, 4} << "\n";

  return 0;
}
