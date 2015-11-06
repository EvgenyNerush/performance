import System.IO
import Criterion.Main

-- my experimental linear congruential RNG for use in Haskell code.
-- LC RNG: x_{n+1} = ( a x_n + c ) % m.
-- m = 443584512 = 2^12 * 3^4 * 7 * 191 < 2^29 - 1 = 536870911
-- a = 16045 = 5 * 3209 = 2^2 * 3 * 7 * 191 + 1
-- c = 57475 = 5^2 * 11^2 * 19
hIntRand :: Int -> [Int]
hIntRand seed = seed' : hIntRand seed'
    where seed' = mod (16045 * seed + 57475) 443584512

hRand :: Int -> [Float]
hRand seed = map (\x -> fromIntegral x / 443584512) (hIntRand seed)

-- non-uniform distribution
randoms :: Int -> Int -> [Float]
randoms seed1 seed2 = go (hRand seed1) (hRand seed2)
    where go (x:xs) (y:ys) = let z = (asin $ sqrt x) / (pi / 2) in
                             if y < z then x:(go xs ys) else go xs ys

nRandoms = 2000000
blockSize = Just 1048576

toFile :: Int -> Int -> Int -> IO ()
toFile n seed1 seed2 = openFile "generated_rand_numbers" WriteMode >>=
    \h -> (hSetBuffering h (BlockBuffering $ blockSize) >>
    writeLines h (take n $ randoms seed1 seed2))

writeLines :: Handle -> [Float] -> IO ()
writeLines h [] = hClose h
writeLines h (x:xs) = hPutStrLn h (show x) >> writeLines h xs

fromFile :: IO ()
fromFile = openFile "generated_rand_numbers" ReadMode >>=
    \h -> (hSetBuffering h (BlockBuffering $ blockSize) >>
    readLines h) >>=
    \x -> putStrLn $ "result: " ++ show (x / fromIntegral nRandoms)

readLines :: Handle -> IO Float
readLines h = go h 0
    where go h x = hIsEOF h >>=
                   \b -> if b then return x
                         else hGetLine h >>=
                              (\s -> return $ read s) >>= \y -> go h (x + y)

main = defaultMain [
        bench "generation" $ nf (\seed -> take nRandoms $ randoms 3 seed) 4,
        bench "generation + output" $ nfIO (toFile nRandoms 3 4),
        bench "input" $ nfIO fromFile
    ]

{-main = toFile nRandoms 3 4 >>
       fromFile
-}
