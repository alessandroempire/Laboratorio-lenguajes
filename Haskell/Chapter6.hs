--Learn you a Haskell

--Chapter 6

divideByTen:: (Floating a) => a -> a
divideByTen = (/10)

-- el (a->a) es una funcion que recibe a y devuelve a
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]  
zipWith' _ [] _ = []  
zipWith' _ _ [] = []  
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys  

flip1 :: (a -> b -> c) -> (b-> a -> c)
flip1 f x y = f y x 

--Funcion map!
--aplica una funcion a cada elemento del arreglo
map' :: (a -> b) -> [a] -> [b]
map' _ [] = [] 
map' f (x:xs) = f x : map' f xs

--Funcion filter 
--filtra todos los elementos del arreglo que cumplan la funcion
filter' :: (a -> Bool) -> [a] -> [a]  
filter' _ [] = []  
filter' p (x:xs)   
    | p x       = x : filter' p xs  
    | otherwise = filter' p xs  

chain :: (Integral a) => a -> [a]  
chain 1 = [1]  
chain n  
    | even n =  n:chain (n `div` 2)  
    | odd n  =  n:chain (n*3 + 1)  

--uso del map 
numLongChains :: Int
numLongChains = length (filter isLong (map chain[1..100]))
    where isLong xs = length xs > 15

--uso del lambda
-- (\<parametros> -> <funcion>)
numLongChains2 :: Int
numLongChains2 = length (filter (\xs -> length xs > 15) (map chain [1..100]))

fun = map (\(a,b) -> a + b) [(1,2),(3,5),(6,3)]

sum' = foldl (+) 0
