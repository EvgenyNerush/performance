# -*- coding: utf-8 -*-

import time
import numpy as np
#from numba import jit

n = 2000000
rand_number = np.empty(n);

# 'numba' generation
#@jit
#def r2(m):
#    a = np.empty(m)
#    i = 0
#    while i < m:
#        r1 = np.random.rand()
#        r2 = np.random.rand()
#        if r2 < np.arcsin(np.sqrt(r1)) / (np.pi / 2):
#            a[i] = r1
#            i += 1
t_1 = time.perf_counter()
#rand_number = r2(n)

t0 = time.perf_counter()
# 'fast' method of generation
m = int(n / 10)
a = np.empty(0)
while len(a) < n:
    r1 = np.random.rand(m)
    f = np.arcsin(np.sqrt(r1)) / (np.pi / 2)
    r2 = np.random.rand(m)
    b = [x for i, x in enumerate(r1) if r2[i] < f[i]]
    a = np.append(a, b)
rand_number = a[:n]

t1 = time.perf_counter()
# 'slow' generation
i = 0
while i < n:
    r1 = np.random.rand()
    r2 = np.random.rand()
    if r2 < np.arcsin(np.sqrt(r1)) / (np.pi / 2):
        rand_number[i] = r1
        i += 1

t2 = time.perf_counter()

f = open('generated_rand_numbers', 'w')
for r in rand_number:
    f.write(str(r) + '\n')
f.close()

t3 = time.perf_counter()

f = open('generated_rand_numbers', 'r')

s = 0
for line in f:
    s += float(line)
f.close()

t4 = time.perf_counter()

print('io.py')
print("result = ", s / n)
print("numba generation took " + str(t_1 - t0) + " s")
print("fast generation took " + str(t1 - t0) + " s")
print("generation took " + str(t2 - t1) + " s")
print("o time = " + str(t3 - t2) + " s")
print("i time = " + str(t4 - t3) + " s")
