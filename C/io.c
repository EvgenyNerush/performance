#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

int main(void) {
    const long n = 2000000;
    const float pi = 3.14159265358979323846264338327950288419716939937510;
    float rand_number[n];
    clock_t t1, t2, t3, t4;
    srand(time(0)); // 0 -> NULL
    t1 = clock();
    long i = 0;
    while (i < n) {
        float r1 = rand() / (float) RAND_MAX;
        float r2 = rand() / (float) RAND_MAX;
        if (r2 < asin(sqrt(r1)) / (pi / 2)) {
            rand_number[i] = r1;
            i += 1;
        }
    }
    t2 = clock();
    FILE * f = fopen("generated_rand_numbers", "w+");
    for (i = 0; i < n; i += 1)
        fprintf(f, "%f\n", rand_number[i]);
    fclose(f);
    t3 = clock();
    f = fopen("generated_rand_numbers", "r"); // check r!
    float sum = 0;
    for (i = 0; i < n; i += 1) {
        float a;
        fscanf(f, "%f", &a);
        sum += a;
    }
    fclose(f);
    t4 = clock();
    puts("io.c");
    printf("result = %f\n", sum / n);
    printf("generation took = %f s\n", (t2 - t1) / (float) CLOCKS_PER_SEC);
    printf("o time = %f s\n", (t3 - t2) / (float) CLOCKS_PER_SEC);
    printf("i time = %f s\n", (t4 - t3) / (float) CLOCKS_PER_SEC);
    return EXIT_SUCCESS;
}
