# -*- coding: utf-8 -*-

import time
import random
import math
from array import array

n = 2000000
rand_number = array('f')

t1 = time.clock()

random.seed(float(t1))
i = 0
while i < n:
    r1 = random.random()
    r2 = random.random()
    if r2 < math.asin(math.sqrt(r1)) / (math.pi / 2):
        rand_number.append(r1)
        i += 1

t2 = time.clock()

f = open('generated_rand_numbers', 'wb')
rand_number.tofile(f)
f.close()

t3 = time.clock()

f = open('generated_rand_numbers', 'rb')
s = 0
rand_number = array('f')
rand_number.fromfile(f, n)
for r in rand_number:
    s += r
f.close()

t4 = time.clock()

print('io.py')
print("result = ", s / n)
print("generation took " + str(t2 - t1) + " s")
print("o time = " + str(t3 - t2) + " s")
print("i time = " + str(t4 - t3) + " s")
