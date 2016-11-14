{-# OPTIONS_GHC -O2 #-}
{-# LANGUAGE BangPatterns #-}

module Main where

import Data.Word
import qualified Data.Vector.Storable as U
import qualified Data.ByteString as BS
import qualified Data.Store as S
import System.Clock
import Formatting
import Formatting.Clock
import Control.DeepSeq

---------------------------------------------------------------------------------------------------
-- Simple version. Input and output are too slow (see earlier versions in git), so they are omitted
-- here.

-- Simple linear congruential RNG:
--
-- x_{n+1} = ( a x_n + c ) % m.
--
-- Accordingly to Knuth (Sec. 3.2.1, see https://goo.gl/VBzUEZ),
-- full period for all seeds is achieved if:
-- 
-- 1. c and m are relatively prime.
-- 
-- 2. a - 1 is divisible by all prime factors (prime divisors) of m.
-- 
-- 3. a - 1 is a multiple of 4 if m is a multiple of 4.
--
-- In Haskell maxBound :: Int is at least 2^29 - 1, so a, m and c are such that
-- a (m - 1) + c < maxBound :: Int:
--
-- m = 2^8 * 3^2 * 31 = 71424
-- a = 2^3 * 3^3 * 31 + 1 = 6697
-- c = 5^3 * 7^2 * 11 = 67375

m = 71424 :: Int
a = 6697 :: Int
c = 67375 :: Int

hIntRand :: Int -> [Int]
hIntRand = loop . seedToRange
    where seedToRange seed = mod (abs seed) m
          loop x = let x' = mod (a * x + c) m in
                 x' : (loop x')

hRand :: Int -> [Double]
hRand = (map (\x -> fromIntegral x / m')) . hIntRand
    where m' = fromIntegral m

-- non-uniform distribution
randoms :: Int -> [Double]
randoms = loop . hRand
    where loop (x:y:xs) = let z = (asin $ sqrt x) / (pi / 2) in
                        if y < z then x:(loop xs) else loop xs

-- this function assumes that [a] is infinite
mean :: Fractional a => Int -> [a] -> a
mean n xs = foldr (+) 0 (take n xs) / (fromIntegral n)

nRandoms = 2000000

---------------------------------------------------------------------------------------------------
-- Fast version. For better performance Vectors are used instead of lists, together with 'bang
-- patterns'. Input and output are written with BiteStrings and 'store' serialization library.
-- The code probably can be even faster if generation of random numbers would be written in a
-- single loop, but in this case we would give up modularity.

-- in order to avoid 'mod' operation, we can use, for example, m = 2^32 and calculate random
-- numbers in unsigned 32-bit integers. Here we use rng from old versions of glibc, see
-- https://en.wikipedia.org/wiki/Linear_congruential_generator#cite_ref-12
hIntRand' :: Int -> Word32 -> [Word32]
hIntRand' 0 _ = []
hIntRand' n !x = let x' = 69069 * x + 1 in
              x' : (hIntRand' (n - 1) x')

-- Uniform distribution
vIntRand :: Int -> Word32 -> U.Vector Word32
vIntRand n seed = U.fromList $ hIntRand' n seed

-- 2^32
m' :: Double
m' = 1 + fromIntegral (maxBound :: Word32)

myZip :: U.Vector Word32 -> U.Vector Word32 -> U.Vector Double
myZip x y = U.filter (> 0) $ U.zipWith f x y
    where p = 2 / pi
          f a b = let a' = fromIntegral a / m' in
                  let b' = fromIntegral b / m' in
                  if b' < p * (asin $ sqrt a') then a' else 0

-- Non-uniforn distribution of given length 'n'
vRandoms :: Int -> Word32 -> Word32 -> U.Vector Double
vRandoms n seed1 seed2 = loop n v1 v2
    where v1 = vIntRand n seed1
          v2 = vIntRand n seed2
          loop k x y = let z = myZip x y in
                     if k < U.length z then U.take k z
                     else let m = k - U.length z in
                          let m' = m + 1000 in
                          z U.++ loop m (vIntRand m' $ U.last x) (vIntRand m' $ U.last y)

vMean :: U.Vector Double -> Double
vMean xs = U.foldr (+) 0 xs / (fromIntegral $ U.length xs)

vectorToFile :: FilePath -> U.Vector Double -> IO ()
vectorToFile fname v = BS.writeFile fname $ S.encode v

vectorFromFile :: FilePath -> IO (U.Vector Double)
vectorFromFile fname = BS.readFile fname >>= (f . S.decode)
    where f (Left _) = return $ U.fromList []
          f (Right v) = return v

---------------------------------------------------------------------------------------------------
-- Time measurement

-- see http://chrisdone.com/posts/measuring-duration-in-haskell
printTimeSpent :: NFData b => (a -> IO b) -> a -> IO b
printTimeSpent f x =
    getTime Monotonic >>=
    \t1 -> f x >>=
    \res -> res `deepseq` getTime Monotonic >>=
    \t2 -> fprint (timeSpecs % string) t1 t2 " \n" >>
    return res

main :: IO ()
main = printTimeSpent printResSlow 123 >>
       printTimeSpent (genFast 123) 124 >>=
       printTimeSpent tf >>
       printTimeSpent ff "generated_rand_numbers" >>=
       printResult
    where printResSlow seed =
              putStrLn $ "(slow) result = " ++ (show . (mean nRandoms) $ randoms seed)
          genFast seed1 seed2 =
              putStrLn "(fast) generation takes" >> return (vRandoms nRandoms seed1 seed2)
          tf seed =
              putStrLn "file writing takes" >> vectorToFile "generated_rand_numbers" seed
          ff filename =
              putStrLn "file reading takes" >> vectorFromFile filename
          printResult x = putStrLn $ "(fast) result = " ++ (show $ vMean x)
