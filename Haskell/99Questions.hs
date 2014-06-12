import Data.List (group)


--1 Problem 1
myLast:: [a] -> a
myLast x = head $ reverse x
myLast'  = foldr1 $ flip const

--2 Problem 2
myButLast:: [a] -> a
myButLast x  = head . tail $ reverse x
myButLast' x = reverse x !! 1
myButLast''  = last . init  

--3 Problem 3
elementAt :: [a] -> Int -> a
elementAt list i = list !! (i-1)

--4 Problem 4 
--myLength:: [a] -> Int
myLength list  = foldl (\x _ -> x + 1) 0 list
myLength' list = foldr (\_ x -> x + 1) 0 list

--5 problem 5
myReverse:: [a] -> [a]
myReverse list  = foldl (\acc e -> e : acc) [] list

--6 problem 6
isPalindrome:: (Eq a) => [a] -> Bool
isPalindrome list = list == (reverse list)

-- 7 problem 7
--muy fumado

-- 8 problem 8
compress xs = map head (group xs)

-- 9 Problem 9
--['a', 'a', 'a', 'a', 'b', 'c', 'c', 'a', 'a', 'd', 'e', 'e', 'e', 'e']
pack xs = foldl aux [] xs
    where aux []     x = [[x]]
          aux (f:fs) x = if x == (head f)
                         then ((x:f):fs)
                         else ([x]:f:fs)
--queda alreves... usar foldr          
pack' xs = foldr aux [] xs
    where aux x []     = [[x]]
          aux x (f:fs) = if x == (head f)
                         then ((x:f):fs)
                         else ([x]:f:fs)

--10 problem 10
enconde xs = foldr aux [] xs
    where aux x []     = [(1,x)]
          aux x ((a,b):fs) = if x == b
                         then ((a+1,b):fs)
                         else ((1,x):(a,b):fs)

--1 problem 11

--2 problem 12

--3 problem 13

--4 problem 14
dupli list = foldl aux [] list
    where aux []     x = [x,x]
          aux (f:fs) x = (x:x:f:fs)
--de nuevo lo deja alreves
dupli' list = foldr aux [] list
    where aux x []     = [x,x]
          aux x (f:fs) = (x:x:f:fs) 

--5 problem 15
repli list i = foldr aux [] list
    where aux x []     = replicate i x
          aux x (f:fs) = ((replicate i x) ++ f : fs)
