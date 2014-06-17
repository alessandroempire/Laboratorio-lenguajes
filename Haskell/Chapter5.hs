--Libro Learn you a Haskell

--Chapter 5

maxi :: (Ord a) => [a] -> a
maxi [] = error "lista vacia, no hay maximo"
maxi (x:xs)
   | null (xs) = x
   | x > p     = maxi(x:s)
   | x < p     = maxi(p:s)  
   where p = head(xs)
         s = tail(xs)

maximum' :: (Ord a) => [a] -> a  
maximum' [] = error "maximum of empty list"  
maximum' [x] = x  
maximum' (x:xs)   
    | x > maxTail = x  
    | otherwise = maxTail  
    where maxTail = maximum' xs  

repli :: (Num a, Ord a) => a -> b -> [b]
repli a b 
   | a <= 0 = []
   | otherwise = b : repli (a-1) b

take1 :: (Num i, Ord i) => i -> [a] -> [a]
take1 a _ 
   | a <= 0 = []
take1 _ [] = []
take1 a (x:xs) = x : take1 (a-1) xs

zip' :: [a] -> [b] -> [(a,b)]  
zip' _ [] = []  
zip' [] _ = []  
zip' (x:xs) (y:ys) = (x,y):zip' xs ys  
