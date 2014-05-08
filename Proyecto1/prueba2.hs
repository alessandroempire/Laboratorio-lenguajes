import Data.Bits
import Data.List

arrayA = [ 0x7E, 0x11, 0x11, 0x11, 0x7E ]

--c:: (Num a) => Bits
--c = bit 

--un convertidor de decimal a binario que funcion
--bin = showIntAtBase 2 intToDigit 10 ""

--uso de testBist
--t = testBit 01010 3

--hagamos el font con map y fold!
{-
ideas:
aplicar el testBit a cada numero del arreglo...
veamos cada binario
aplicar testbit
-}
--fun array = map transform array

--transform:: (Bits b) => b -> (Int, [Char])
--transform:: (Eq t, Num t, Bits b) => [b] -> (t, [Char])
{-
transform bs = foldl bitToChar (0,[]) bs
        where bitToChar :: Bits a => (Int, [Char]) -> a -> (Int, [Char])
              bitToChar (a, acc) bs
                | a == 7                = (a, acc)
                | testBit bs a          = (a+1, '*' : acc)
                | testBit bs a == False = (a+1, ' ' : acc)
-}
  
--se ejecuta bitToChar (0, "") numero
--bitToChar:: Bits a => (Int, [char]) -> a -> [Char]
bitToChar :: Bits a => (Int, [Char]) -> a -> [Char]
bitToChar (a, acc) b
    |           a == 7     = acc
    | testBit b a          = bitToChar (a+1, '*' : acc) b
    | testBit b a == False = bitToChar (a+1, ' ' : acc) b

prueba array = map cambio array
    where cambio i = ["10101"]

prueba1 array = map cambio array
    where cambio i = [101010]


prueba2 array = map (bitToChar (0, "")) array


font as = reverse $ transpose $ map (bitToChar (0, "")) as
