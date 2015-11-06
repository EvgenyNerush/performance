#include <iostream>
#include <cmath>
#include <cstdlib>
#include <vector>
#include <chrono>
#include <fstream>

using namespace std;

int main() {
    const long n = 2000000;
    const float pi = M_PI;
    vector<float> rand_number;
    auto t0 = chrono::high_resolution_clock::now();
    long i = 0;
    while (i < n) {
        float r1 = rand() / (float) RAND_MAX;
        float r2 = rand() / (float) RAND_MAX;
        if (r2 < asin(sqrt(r1)) / (pi / 2)) {
            rand_number.push_back(r1);
            ++i;
        }
    }
    auto t1 = chrono::high_resolution_clock::now();
    fstream fs;
    fs.open("generated_rand_numbers", ios_base::out | ios_base::trunc);
    for (long i = 0; i < n; ++i) {
        fs << rand_number[i] << '\n';
    }
    fs.close();
    auto t2 = chrono::high_resolution_clock::now();
    fs.open("generated_rand_numbers", ios_base::in);
    float sum = 0;
    if (fs) {
        float a;
        fs >> a;
        while (fs.good()) {
            sum += a;
            fs >> a;
        }
    }
    fs.close();
    auto t3 = chrono::high_resolution_clock::now();
    cout << "io.cpp\n";
    cout << "result = " << sum / n << '\n';
    cout << "generation took = " << 1e-9 * (chrono::duration_cast \
            < chrono::nanoseconds > (t1 - t0)).count() << " s\n";
    cout << "o time = " << 1e-9 * (chrono::duration_cast \
            < chrono::nanoseconds > (t2 - t1)).count() << " s\ni time = " << \
        1e-9 * (chrono::duration_cast < chrono::nanoseconds > \
                (t3 - t2)).count() << " s\n";
    return 0;
}
