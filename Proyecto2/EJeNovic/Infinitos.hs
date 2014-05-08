import Ratio

unos = 1 : unos

naturales = 1 : map (+1) naturales

impares = 1 : map (+2) impares

-- Números de Fibonacci
-- F(n) = F(n-1) + F(n-2)
fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

-- Números primos
primos = criba [2..]
  where criba (n:ns) = n : criba (filter (\m -> (m `mod` n) /= 0) ns)

-- Filas de una matriz
cols = foldr (zipWith (:)) (repeat [])

-- Triangulo de Pascal
pascal = iterate (\row -> zipWith (+) (0:row) (row ++ [0])) [1]



p = iterate f [1]
      where f r@(c:cs)        = 1:z (+) r cs
            z g xs []         = xs
            z g (x:xs) (y:ys) = g x y:z g xs ys



h = 1 : m (map (*2) h)
          (m (map (*3) h)
             (map (*5) h))
   where m (x:xs) (y:ys)
           | x == y    = x : m xs ys
           | x <  y    = x : m xs (y:ys)
           | otherwise = y : m (x:xs) ys


-- Enumerar los racionales
rats :: [Rational]
rats = iterate next 1 where
       next x = recip (fromInteger n+1-y) where (n,y) = properFraction x

-- Números de Catalan
-- C(0) = 1
-- C(n) = C(0)C(n) + C(1)C(n-1) + ... + C(n-1)C(1) + C(n)C(0)
-- cats = 1 : cats * cats
