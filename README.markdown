### Overview

Performance tests (for Linux) of (not only) programming languages for scientific
calculations, namely Python, Julia, R, C#, Rust and Haskell, which are compared
to C and C++.

Performance of math, file output and file input is measured as follows. First,
random numbers, uniform in (0,1), are generated. Pairs of random numbers are
used to generate floats distributed so that the distribution function is
proportional to `arcsin(sqrt(x))`, and these floats are dumped to the file
*generated\_rand\_numbers*. Then these numbers are read from the file and
center-of-mass of this distribution is computed. The answer should be `5/8 =
0.625`.

Running of all the tests can take about a minute. Rust
test can take time to install some crates. Haskell test can demand manual
installation of some packages (see `Haskell/io.cabal`).

### How to use

To run all the tests, execute  
`$ ./runMe.sh`  
Comment some lines containing `./run.sh` in `runMe.sh` file if you do not want run
tests for some languages.

Test results are stored in `report` files. To see them, run  
`$ ./showAll.sh`  
`report` files are rewritten every time you run the tests.

Test results can be then manually added to `results.py` file and plotted with
`plotResults.py`.

### First results

First, 'naive' tests were written. Their results obtained with Intel(R)
Xeon(R) X5550 CPU @ 2.67GHz processor are shown in Figure below.

![naive](results_set2.png)

Here marker type corresponds to test type ('o' to the random number generation,
'<' to output and '>' to input). Marker color corresponds to the language: blue
to C, light blue to C++, pink to Julia, violet to Haskell, yellow to Python,
green to Pypy, gray to R, light gray-purple to C#, orange to Rust. Note that
subplots differ only by scale of y axis.

It is seen that R and Python random-number generation is extremely slow, Rust is about twice slower
than C and Haskell is 1.5 times slower than Rust. Haskell input is also extremely slow.

With Pypy RN generation speed becomes 30 times higher than with Python interpreter, and I/O speed
becomes orders of magnitude higher with binary output. However, Pypy cannot be used with all Python
code, and files written in binary mode are not human-readable.

Test of C code together with *clang* compiler (that is based on *llvm* as well as *rustc*) shows
the same performance as was obtained with *gcc*.

### Slightly better code

In order to improve Rust code, Rust RNG was replaced by simple linear congruential generator,
similat to used by C and C++ codes. This lead to the same performance of Rust and C++ codes.

As far as `for` loops in R and Python are too slow, alternative, slightly tricky, methods for
generation of random numbers were provided. These methods are based on 'vector' operations and
require much less work of the interpreters than the previous methods.

Haskell code was also improved, with use of `Data.Vector.Unboxed` and binary I/O.

The obtained results are shown in Figure below.

![fast](results_set3.png)

### Conclusion

Performance of all the tested languages is not as crucial as choosing of 'right' methods and
algorithms. Python, R or Julian can be a good choise if sophisticated plotting features are needed
(provided by *matplotlib* in Python, *ggplot2* in R and *gadfly* in Julia). Haskell
is quite fast and interesting. C, C++ and Rust can be chosen if performance is really important.
