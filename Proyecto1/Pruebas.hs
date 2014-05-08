--Archivo de pruebas para el proyecto

-- Funcion de decimal a binario
toBin2:: Int -> [Int]
toBin2 0 = []
toBin2 n
    | n `mod` 2 == 1 = toBin2(n `div` 2) ++ [1]
    | n `mod` 2 == 0 = toBin2(n `div` 2) ++ [0]

--Funcion de decimal a binario con recursion de cola
toBin1:: [Int] -> Int -> [Int]
toBin1 [] 0 = [0]
toBin1 (x) 0 = x 
toBin1 (x) n 
    | n `mod` 2 == 1 = toBin1 (1 : x) (n`div`2) 
    | n `mod` 2 == 0 = toBin1 (0 : x) (n`div`2)

--Funcion que llama a toBin1  
toBinF:: Int -> [Int]
toBinF n = toBin1 [] n 

--Funcion que convierte un decimal a binario 
toBinary:: Int -> [Int]
toBinary n = toBin [] n 7
    where toBin (x) 0 0   = x
          toBin [] 0 7    = toBin [0] 0 (7-1)
          toBin (x) 0 acc = toBin(x ++ [0]) 0 (acc-1)
          toBin (x) n acc
            | n `mod` 2 == 1 = toBin (x ++ [1]) (n`div`2) (acc-1)
            | n `mod` 2 == 0 = toBin (x ++ [0]) (n`div`2) (acc-1)


--Funcion que recibe la lista de enteros y los lleva cada entero a una listade binario. 
binFont:: [Int] -> [[Int]]
binFont (x) = map toBinary x 

--Funcion zip con recursion de cola
zipper (x) (y) = zip' x y [] 
    where zip' _ [] (acc)= acc  
          zip' [] _ (acc) = acc
          zip' (x:xs) (y:ys) (acc)= zip' xs ys (acc ++ [(x,y)])

--Funcion super especial de zipp
--zipp:: [a] -> [b] -> [c] -> [d] -> [e] -> (a,b,c,d,e)
--zipp (a:as) (b:bs) (c:cs) (d:ds) (e:es) = (1,2,3,4,5)

--Funcion que pone todo en 7

--Funcion
transform1:: [[Integer]] -> [[Char]]
transform1 (x) = map transform x


--Una funcion que transforma un arrary de integer a un array de char
transform:: [Integer] -> [Char]
transform (x) = map intToArray x

--Funcion
intToArray:: Integer -> Char
intToArray 0 = ' '
intToArray 1 = '*'





