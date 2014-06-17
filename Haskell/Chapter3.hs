--Respuesta al libro learn you a haskell

--chapter 3

-- :t 'a' nos dice el tipo

addthree :: Int -> Int -> Int -> Int
addthree x y z = x + y + z

--Int es mas eficiente que integer!
factorial :: Integer -> Integer
factorial n = product [1..n]

circunferencia :: Float -> Float
circunferencia r = 2 * pi * r

-- double tiene el doble de precision que float

-- Eq es que los tipos deben ser iguales
-- Ord es que los tipos tiene un orden

x = 5 `compare` 3

sh = show 3 -- transforma a string

min = minBound :: Int
