createRandoms <- function(n) {
    i <- 1
    a <- vector('numeric', length = n)
    while (i <= n) {
        r1 <- runif(1)
        r2 <- runif(1)
        if (r2 < asin(sqrt(r1)) / (pi / 2)) {
            a[i] <- r1
            i <- i + 1
        }
    }
    return(a)
}

createRandomsFast <- function(n) {
    # in order to avoid a[i] operations and loops over arrays we generate quite
    # long vectors and then concatenate them
    a <- vector('numeric', length = 0)
    m <- floor(n / 10)
    while(length(a) < n) {
        r1 <- runif(m)
        f <- asin(sqrt(r1)) / (pi / 2)
        r2 <- runif(m)
        s <- sign(f - r2)
        s <- s * r1
        a <- c(a, s[s>0])
    }
    return(head(a, n))
}

filename <- "generated_rand_numbers"
n <- 2000000

t_1 <- Sys.time()
a <- createRandoms(n)
t0 <- Sys.time()

a <- createRandomsFast(n)
t1 <- Sys.time()

write(a, filename, sep = "\n")
t2 <- Sys.time()

b <- unlist(read.table(filename), use.names = FALSE)
r <- sum(b) / n
t3 <- Sys.time()

print("io.R")
print("result = ")
print(r)
print("generation...")
print(t0 - t_1)
print("fast generation...")
print(t1 - t0)
print("o time...")
print(t2 - t1)
print("i time...")
print(t3 - t2)
