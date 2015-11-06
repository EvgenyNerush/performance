function createrandoms(n)
  i = 1
  a = zeros(n)
  while (i <= n)
    r1 = rand()
    r2 = rand()
    if (r2 < asin(sqrt(r1)) / (pi / 2))
      a[i] = r1
      i += 1
    end
  end
  return a
end

function tofile(a)
  outfile = open("generated_rand_numbers", "w")
  for x in a
    write(outfile, join(x), "\n")
  end
  close(outfile)
end

function fromfile()
  infile = open("generated_rand_numbers", "r")
  s = 0
  while !eof(infile)
    s += float(readline(infile))
  end
  close(infile)
  return s
end

n = 2000000

print("io.jl\n")

print("generation... ")
@time (a = createrandoms(n))

print("o time... ")
@time (tofile(a))

print("i time... ")
@time (s = fromfile())
print("result = ", s / n)
print('\n')
