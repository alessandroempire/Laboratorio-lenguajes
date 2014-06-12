--Respuesta al libro learn you a haskell

--chapter 4

lucky :: (Integral a) => a -> String
lucky 7 = "Lucky number seven"
lucky x = "sorry you are out of luck"

sayme :: (Integral a) => a -> String
sayme 1 = "one"
sayme 2 = "two"

factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)

charname :: Char -> String
charname 'a' = "Albert"
charname 'b' = "bro"

addvector :: (Num a) => (a,a) -> (a,a) -> (a,a)
addvector a b = (fst a + fst b, snd a + snd b)


addvector1 (x1,y1) (x2,y2) = (x1 + x2, y1 + y2) 

third :: (a,b,c) -> c
third (_,_,c) = c
-- el _ representa cualquier valor

cabeza :: [a] -> a
cabeza [] = error "lista vacia"
cabeza (x:_) = x

--uso del "if"
tell :: (RealFloat a) => a -> String
tell xtell
   | xtell <= 18.5 = "underweight"
   | xtell <= 25.0 = "normal"
   | xtell <= 30.0 = "fat"
   | otherwise     = "whale" 

--uso del where
tellc :: (RealFloat a) => a -> a -> String
tellc weight height
   | num <= 18.5 = "underweight"
   | num <= 25.0 = "normal"
   | num <= 30.0 = "fat"
   | otherwise   = "whale" 
   where num = weight / height ^ 2  

tell3 :: (RealFloat a) => a -> a -> String
tell3 weight height
   | num <= val1 = "underweight"
   | num <= val2 = "normal"
   | num <= val3 = "fat"
   | otherwise   = "whale" 
   where num  = weight / height ^ 2 
         val1 = 18.5
         val2 = 25.0
         val3 = 30.0

tell4 :: (RealFloat a) => a -> a -> String
tell4 weight height
   | num <= val1 = "underweight"
   | num <= val2 = "normal"
   | num <= val3 = "fat"
   | otherwise   = "whale" 
   where num  = weight / height ^ 2 
         (val1, val2, val3) = (18.5, 25.0, 30.0)

--uso del let in
--se usa let <bindings> in <expresion>
--the names that you define in the left part are accessible to the 
--expresion after the "in" part

cylinder r h = 
   let sidearea = 2 * pi * r * h
       toparea = pi * r^2
   in sidearea + 2 * toparea

--no se puede
--let zoot x y z = x * y + z
--let boot x y z = x * y + z
--in boot 3 4 2 
