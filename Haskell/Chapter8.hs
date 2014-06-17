--Libro Learn you a Haskell
--Capitulo 8 

--Nota: el nombre de un data siempre se comienza en mayuscula
--El circle es un constructor de un Shape

{-
module Shapes ( Point(..) --exporta todos los constructores 
               ,Shape(..)
               ,surface 
               ,surface1
              )
              where
-}

--vamos el bool para entender:

data Bool1 = False | True
--Bool1 denota el tipo
--False y True son los constructores (value constructors) 
--especifican los diferentes valores que Bool puede tener

data Shape = Circle Float Float Float 
             | Rectangle Float Float Float Float
           deriving (Show)

-- El Circle es un constructor con 3 campos
--Estos campos definen los valores que tendra Circle
--constructores son funciones que retorna un valor de un tipo de data
--circle regresa un valor de tipo shape

surface :: Shape -> Float
surface (Circle _ _ r) = pi * r^2

map1 = map (Circle 10 20) [4,5,6,6]

    --El tipo data anterior se puede mejorar

data Coordinates = Coordinates Float Float 
            deriving (Show)

data Shape1 = Circle1 Coordinates Float
            deriving (Show)

surface1 :: Shape1 -> Float
surface1 (Circle1 _ r) = pi * r ^ 2

csurface = surface1 (Circle1 (Coordinates 0 0) 24)


--Record syntax
data Person = Person { firstName :: String
                     , lastName :: String
                     , age :: Int
                     , height :: Float
                     }
                     deriving (Show, Eq, Read)

    --No importa el orden!
me = Person "Alessandro" "La Corte" 22 1.73

gf = Person {age = 18, lastName = "Cestari", height = 1.70, firstName = "Maria"}

--Type parameters

data Maybe a = Nothing1 | Just1 a
             deriving (Show)

--Instancias derivadas
-- agregar deriving (Show, Eq, Read)

me2 = Person { age = 22, height = 1.73, firstName = "Alessandro", lastName = "La Corte"}

--el read para leer un string y convertirlo a tipo que me interesa

dude = read "Person {firstName =\"Michael\", lastName =\"Diamond\", age = 43, height = 1.89}" :: Person  

dude1 = read "Person Michael Diamond 43 1.89}" :: Person  
