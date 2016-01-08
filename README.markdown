### Overview

Performance tests (for Linux) of (not only) programming languages for scientific
calculations, namely Python, Julia, R, C#, Rust and Haskell, which are compared
to C and C++.

Performance of math, file output and file input is measured as follows. First,
random numbers, uniform in (0,1), are generated. Pairs of random numbers are
used to generate floats distributed so that the distribution function is
proportional to *arcsin(sqrt(x))*, and these floats are dumped to the file
`generated_rand_numbers`. Then these numbers are read from the file and
center-of-mass of this distribution is computed. The answer should be *5/8 =
0.625*.

### How to use

WARNING: Running of all the tests can take tens of minutes! Do not run Haskell
tests to see results quickly. R and Python tests can also last minutes. Rust
test can take time to install some crates.

To run all the tests, execute  
`$ ./runMe.sh`  
Comment some lines containing `./run.sh` in that file if you do not want run
tests for some languages.

Test results are stored in `report` files. To see them, run  
`$ ./showAll.sh`  
`report` files are rewritten every time you run the tests.

Test results can be then manually added to `results.py` file and plotted with
`plotResults.py`.

### Example

Results obtained with Intel(R) Xeon(R) X5550 CPU @ 2.67GHz processor are shown
in the Figure below.

![results.png](results.png)

Here marker type corresponds to test type ('o' to the random number generation,
'<' to output and '>' to input). Marker color corresponds to the language: blue
to C, light blue to C++, pink to Julia, violet to Haskell, yellow to Python,
green to Pypy, gray to R, light gray-purple to C#, orange to Rust.

### Notes

As far as `for` loop in R and Python are too slow, alternative methods for
generation of random numbers are provided. For this reason alternative Python
script for running with Pypy is also provided.

Pypy io time is extremely short because binary io was used.

Input and output in Haskell is written with buffering, however this doesn't
improve io performance much. Functions like `readFile` can probably break
through.

Variation of generation test that uses ternary operator in C yield the same
speed as if-else generation.

Tests for C++ ran with g++ and clang++ took the same time. Rust compiler uses
llvm (as clang++ does) but generates slower code than clang++. This happens
because of very slow random generator used in Rust, if the RNG is replaced by
linear congruential generator, Rust code becomes as fast as C++ code.

### Dependencies

Haskell code uses *criterion* package.

Pypy is used.

Python3 is used.

g++ with -std=c++11 is used.
