-----------------------------------------------------
{- |
Module      :  
Description : El tipo Pixels y sus operaciones.  
CopyRight   : (c) Alessandro La Corte
                  Ivanhoe Gamarra

Operaciones básicas sobre el tipo Pixel. 
-}
-----------------------------------------------------

module Pixels (
               -- * Lista de representación en pixels de caracteres.  
               fontBitmap,                         -- :: [[Integer]] 

               -- * Operación básica
               font,                               -- :: Char -> Pixels

               -- * Funciones para mostrar Pixeles en pantalla.
               pixelToString,                     -- :: Pixels -> String
               pixelListToPixels,                  -- :: [Pixels] -> Pixels
               pixelListToString,                  -- :: [Pixels] -> String

               -- * Funciones combinadoras. 
               concatPixels,                       -- :: [Pixels] -> Pixels
               messageToPixels,                    -- :: String -> Pixels

               -- * Funciones para efectos Especiales. 
               up,                                 -- :: Pixels -> Pixels
               down,                               -- :: Pixels -> Pixels
               left,                               -- :: Pixels -> Pixels
               right,                              -- :: Pixels -> Pixels
               upsideDown,                         -- :: Pixels -> Pixels
               backwards,                          -- :: Pixels -> Pixels
               negative                            -- :: Pixels -> Pixels
              ) where

import Data.List

type Pixels = [String]

{- |
   Función que permite obtener la representación en pixel de un 
    caracter imprimible particular del alfabeto. 
-}
fontBitmap :: [[Integer]]
fontBitmap =
  [
    [ 0x00, 0x00, 0x00, 0x00, 0x00 ], --  (space)
    [ 0x00, 0x00, 0x5F, 0x00, 0x00 ], --  !
    [ 0x00, 0x07, 0x00, 0x07, 0x00 ], --  "
    [ 0x14, 0x7F, 0x14, 0x7F, 0x14 ], --  #
    [ 0x24, 0x2A, 0x7F, 0x2A, 0x12 ], --  $
    [ 0x23, 0x13, 0x08, 0x64, 0x62 ], --  %
    [ 0x36, 0x49, 0x55, 0x22, 0x50 ], --  &
    [ 0x00, 0x05, 0x03, 0x00, 0x00 ], --  '
    [ 0x00, 0x1C, 0x22, 0x41, 0x00 ], --  (
    [ 0x00, 0x41, 0x22, 0x1C, 0x00 ], --  )
    [ 0x08, 0x2A, 0x1C, 0x2A, 0x08 ], --  *
    [ 0x08, 0x08, 0x3E, 0x08, 0x08 ], --  +
    [ 0x00, 0x50, 0x30, 0x00, 0x00 ], --  ,
    [ 0x08, 0x08, 0x08, 0x08, 0x08 ], --  -
    [ 0x00, 0x60, 0x60, 0x00, 0x00 ], --  .
    [ 0x20, 0x10, 0x08, 0x04, 0x02 ], --  /
    [ 0x3E, 0x51, 0x49, 0x45, 0x3E ], --  0
    [ 0x00, 0x42, 0x7F, 0x40, 0x00 ], --  1
    [ 0x42, 0x61, 0x51, 0x49, 0x46 ], --  2
    [ 0x21, 0x41, 0x45, 0x4B, 0x31 ], --  3
    [ 0x18, 0x14, 0x12, 0x7F, 0x10 ], --  4
    [ 0x27, 0x45, 0x45, 0x45, 0x39 ], --  5
    [ 0x3C, 0x4A, 0x49, 0x49, 0x30 ], --  6
    [ 0x01, 0x71, 0x09, 0x05, 0x03 ], --  7
    [ 0x36, 0x49, 0x49, 0x49, 0x36 ], --  8
    [ 0x06, 0x49, 0x49, 0x29, 0x1E ], --  9
    [ 0x00, 0x36, 0x36, 0x00, 0x00 ], --  :
    [ 0x00, 0x56, 0x36, 0x00, 0x00 ], --  ;
    [ 0x00, 0x08, 0x14, 0x22, 0x41 ], --  <
    [ 0x14, 0x14, 0x14, 0x14, 0x14 ], --  =
    [ 0x41, 0x22, 0x14, 0x08, 0x00 ], --  >
    [ 0x02, 0x01, 0x51, 0x09, 0x06 ], --  ?
    [ 0x32, 0x49, 0x79, 0x41, 0x3E ], --  @
    [ 0x7E, 0x11, 0x11, 0x11, 0x7E ], --  A
    [ 0x7F, 0x49, 0x49, 0x49, 0x36 ], --  B
    [ 0x3E, 0x41, 0x41, 0x41, 0x22 ], --  C
    [ 0x7F, 0x41, 0x41, 0x22, 0x1C ], --  D
    [ 0x7F, 0x49, 0x49, 0x49, 0x41 ], --  E
    [ 0x7F, 0x09, 0x09, 0x01, 0x01 ], --  F
    [ 0x3E, 0x41, 0x41, 0x51, 0x32 ], --  G
    [ 0x7F, 0x08, 0x08, 0x08, 0x7F ], --  H
    [ 0x00, 0x41, 0x7F, 0x41, 0x00 ], --  I
    [ 0x20, 0x40, 0x41, 0x3F, 0x01 ], --  J
    [ 0x7F, 0x08, 0x14, 0x22, 0x41 ], --  K
    [ 0x7F, 0x40, 0x40, 0x40, 0x40 ], --  L
    [ 0x7F, 0x02, 0x04, 0x02, 0x7F ], --  M
    [ 0x7F, 0x04, 0x08, 0x10, 0x7F ], --  N
    [ 0x3E, 0x41, 0x41, 0x41, 0x3E ], --  O
    [ 0x7F, 0x09, 0x09, 0x09, 0x06 ], --  P
    [ 0x3E, 0x41, 0x51, 0x21, 0x5E ], --  Q
    [ 0x7F, 0x09, 0x19, 0x29, 0x46 ], --  R
    [ 0x46, 0x49, 0x49, 0x49, 0x31 ], --  S
    [ 0x01, 0x01, 0x7F, 0x01, 0x01 ], --  T
    [ 0x3F, 0x40, 0x40, 0x40, 0x3F ], --  U
    [ 0x1F, 0x20, 0x40, 0x20, 0x1F ], --  V
    [ 0x7F, 0x20, 0x18, 0x20, 0x7F ], --  W
    [ 0x63, 0x14, 0x08, 0x14, 0x63 ], --  X
    [ 0x03, 0x04, 0x78, 0x04, 0x03 ], --  Y
    [ 0x61, 0x51, 0x49, 0x45, 0x43 ], --  Z
    [ 0x00, 0x00, 0x7F, 0x41, 0x41 ], --  [
    [ 0x02, 0x04, 0x08, 0x10, 0x20 ], --  \
    [ 0x41, 0x41, 0x7F, 0x00, 0x00 ], --  ]
    [ 0x04, 0x02, 0x01, 0x02, 0x04 ], --  ^
    [ 0x40, 0x40, 0x40, 0x40, 0x40 ], --  _
    [ 0x00, 0x01, 0x02, 0x04, 0x00 ], --  `
    [ 0x20, 0x54, 0x54, 0x54, 0x78 ], --  a
    [ 0x7F, 0x48, 0x44, 0x44, 0x38 ], --  b
    [ 0x38, 0x44, 0x44, 0x44, 0x20 ], --  c
    [ 0x38, 0x44, 0x44, 0x48, 0x7F ], --  d
    [ 0x38, 0x54, 0x54, 0x54, 0x18 ], --  e
    [ 0x08, 0x7E, 0x09, 0x01, 0x02 ], --  f
    [ 0x08, 0x14, 0x54, 0x54, 0x3C ], --  g
    [ 0x7F, 0x08, 0x04, 0x04, 0x78 ], --  h
    [ 0x00, 0x44, 0x7D, 0x40, 0x00 ], --  i
    [ 0x20, 0x40, 0x44, 0x3D, 0x00 ], --  j
    [ 0x00, 0x7F, 0x10, 0x28, 0x44 ], --  k
    [ 0x00, 0x41, 0x7F, 0x40, 0x00 ], --  l
    [ 0x7C, 0x04, 0x18, 0x04, 0x78 ], --  m
    [ 0x7C, 0x08, 0x04, 0x04, 0x78 ], --  n
    [ 0x38, 0x44, 0x44, 0x44, 0x38 ], --  o
    [ 0x7C, 0x14, 0x14, 0x14, 0x08 ], --  p
    [ 0x08, 0x14, 0x14, 0x18, 0x7C ], --  q
    [ 0x7C, 0x08, 0x04, 0x04, 0x08 ], --  r
    [ 0x48, 0x54, 0x54, 0x54, 0x20 ], --  s
    [ 0x04, 0x3F, 0x44, 0x40, 0x20 ], --  t
    [ 0x3C, 0x40, 0x40, 0x20, 0x7C ], --  u
    [ 0x1C, 0x20, 0x40, 0x20, 0x1C ], --  v
    [ 0x3C, 0x40, 0x30, 0x40, 0x3C ], --  w
    [ 0x44, 0x28, 0x10, 0x28, 0x44 ], --  x
    [ 0x0C, 0x50, 0x50, 0x50, 0x3C ], --  y
    [ 0x44, 0x64, 0x54, 0x4C, 0x44 ], --  z
    [ 0x00, 0x08, 0x36, 0x41, 0x00 ], --  {
    [ 0x00, 0x00, 0x7F, 0x00, 0x00 ], --  |
    [ 0x00, 0x41, 0x36, 0x08, 0x00 ]  --  }
  ]

{- Función no exportada. 
    Función que me da la posición en la Lista
     de Fontbitmap según su caracter.
-}
fontBitmapPos:: Char -> Int
fontBitmapPos ' '   = 0
fontBitmapPos '!'   = 1
fontBitmapPos '"'   = 2
fontBitmapPos '#'   = 3
fontBitmapPos '$'   = 4
fontBitmapPos '%'   = 5
fontBitmapPos '&'   = 6
fontBitmapPos '\''  = 7 
fontBitmapPos '('   = 8
fontBitmapPos ')'   = 9
fontBitmapPos '*'   = 10
fontBitmapPos '+'   = 11
fontBitmapPos ','   = 12
fontBitmapPos '-'   = 13
fontBitmapPos '.'   = 14
fontBitmapPos '/'   = 15
fontBitmapPos '0'   = 16
fontBitmapPos '1'   = 17
fontBitmapPos '2'   = 18
fontBitmapPos '3'   = 19
fontBitmapPos '4'   = 20
fontBitmapPos '5'   = 21
fontBitmapPos '6'   = 22
fontBitmapPos '7'   = 23
fontBitmapPos '8'   = 24
fontBitmapPos '9'   = 25
fontBitmapPos ':'   = 26
fontBitmapPos ';'   = 27
fontBitmapPos '<'   = 28
fontBitmapPos '='   = 29
fontBitmapPos '>'   = 30
fontBitmapPos '?'   = 31
fontBitmapPos '@'   = 32
fontBitmapPos 'A'   = 33
fontBitmapPos 'B'   = 34
fontBitmapPos 'C'   = 35
fontBitmapPos 'D'   = 36
fontBitmapPos 'E'   = 37
fontBitmapPos 'F'   = 38
fontBitmapPos 'G'   = 39
fontBitmapPos 'H'   = 40
fontBitmapPos 'I'   = 41
fontBitmapPos 'J'   = 42
fontBitmapPos 'K'   = 43
fontBitmapPos 'L'   = 44
fontBitmapPos 'M'   = 45
fontBitmapPos 'N'   = 46
fontBitmapPos 'O'   = 47
fontBitmapPos 'P'   = 48
fontBitmapPos 'Q'   = 49
fontBitmapPos 'R'   = 50
fontBitmapPos 'S'   = 51
fontBitmapPos 'T'   = 52
fontBitmapPos 'U'   = 53
fontBitmapPos 'V'   = 54
fontBitmapPos 'W'   = 55
fontBitmapPos 'X'   = 56
fontBitmapPos 'Y'   = 57
fontBitmapPos 'Z'   = 58
fontBitmapPos '['   = 59
fontBitmapPos '\\'  = 60  
fontBitmapPos ']'   = 61
fontBitmapPos '^'   = 62
fontBitmapPos '_'   = 63
fontBitmapPos '`'   = 64
fontBitmapPos 'a'   = 65
fontBitmapPos 'b'   = 66
fontBitmapPos 'c'   = 67
fontBitmapPos 'd'   = 68
fontBitmapPos 'e'   = 69
fontBitmapPos 'f'   = 70
fontBitmapPos 'g'   = 71
fontBitmapPos 'h'   = 72
fontBitmapPos 'i'   = 73
fontBitmapPos 'j'   = 74
fontBitmapPos 'k'   = 75
fontBitmapPos 'l'   = 76
fontBitmapPos 'm'   = 77
fontBitmapPos 'n'   = 78
fontBitmapPos 'o'   = 79
fontBitmapPos 'p'   = 80
fontBitmapPos 'q'   = 81
fontBitmapPos 'r'   = 82
fontBitmapPos 's'   = 83
fontBitmapPos 't'   = 84
fontBitmapPos 'u'   = 85
fontBitmapPos 'v'   = 86 
fontBitmapPos 'w'   = 87
fontBitmapPos 'x'   = 88
fontBitmapPos 'y'   = 89
fontBitmapPos 'z'   = 90
fontBitmapPos '{'   = 91
fontBitmapPos '|'   = 92
fontBitmapPos '}'   = 93
fontBitmapPos _     = 100

{- Función no exportada.  
   fontBitmapList: Función que recibe un caracter imprimible y 
    busca en fontBitmap su representación en Pixels. 
   val: Indica el valor de la posición del caracter correspondiente. 
-}
fontBitmapList:: Char -> [Integer]
fontBitmapList x 
    | val /= 100 = fontBitmap !! val
    | otherwise  = [127,127,127,127,127]
    where val:: Int
          val = fontBitmapPos x

-- Función no exportada. Convierte un número entero a binario.
toBinary:: Integer -> [Integer]
toBinary n = toBin [] n 7
    where toBin:: [Integer] -> Integer -> Integer -> [Integer]
          toBin (x) 0 0   = x
          toBin [] 0 7    = toBin [0] 0 (7-1)
          toBin (x) 0 acc = toBin(x ++ [0]) 0 (acc-1)
          toBin (x) n acc
            | n `mod` 2 == 1 = toBin (x ++ [1]) (n`div`2) (acc-1)
            | n `mod` 2 == 0 = toBin (x ++ [0]) (n`div`2) (acc-1)

{- 
   Función no exportada. 
   Recibe una lista de números enteros y convierte
   cada uno de ellos en una lista de números binarios. 
-}
binFont:: [Integer] -> [[Integer]]
binFont (x) = map toBinary x 

{- Funciones no exportadas. 
    transforma: Es una función que convierte una lista de 
     lista de enteros a una lista de lista de Char.
    transform: Es Una función que convierte una lista de
     enteros a una lista de Char.
-}
transforma:: [[Integer]] -> [[Char]]
transforma (x) = map transform x
    where transform:: [Integer] -> [Char]
          transform (x) = map intToArray x

-- Función no exportada. Intercambia un entero por un caracter.
intToArray:: Integer -> Char
intToArray 0 = ' '
intToArray 1 = '*'

{- |  
    Función que recibe un caracter y lo convierte en un Pixel.

   > font ’A’
   >[ " *** ",
   >  "*   *",
   >  "*   *",
   >  "*****",
   >  "*   *",
   >  "*   *",
   >  "*   *"] 
-}
font:: Char -> Pixels
font c = transforma (transpose (binFont (fontBitmapList c)))

{- |
    Función que recibe un Pixel y retorna su representación en String. 

   > pixelToString (font 'A')
   > " *** \n*   *\n*   *\n*   *\n*****\n*   *\n*   *"
-}
pixelToString:: Pixels -> String
pixelToString p = init (unlines p)

{- |
    Función que recibe una lista de Pixels y concatena cada
     Pixels entre sí separados por el String \"\".

-}
{-  
    pix: Función no exportada. Recursiva de cola que realiza el trabajo
     de pixelListtoPixels. 
-}
pixelListToPixels:: [Pixels] -> Pixels
pixelListToPixels []     = []
pixelListToPixels (x:xs) = pix [] (x:xs)
    where pix:: Pixels -> [Pixels] -> Pixels
          pix acc []     = init acc
          pix acc (x:xs) = pix (acc ++ x ++ [""]) xs

{- |
    Función que recibe una lista de Pixels, convierte cada elemento 
     a String usando 'pixelsToString' y luego los concatena entre sí 
     incorporando retornos de carro en medio.
-}
pixelListToString:: [Pixels] -> String
pixelListToString []     = ""
pixelListToString (x:xs) = init (pix [] (x:xs))
    where pix:: String -> [Pixels] -> String
          pix acc []     = acc
          pix acc (x:xs) = pix (acc ++ pixelToString x ++ ['\n']) xs

{- |
   Función que recibe una lista de Pixels y 
    concatena los Pixels en uno solo. 

   > concatPixels [font 'A', font 'B']
     >*** **** 
     >*   **   *
     >*   **   *
     >*   ***** 
     >******   *
     >*   **   *
     >*   ***** 
-}
{- 
   Sunion: Función no exportada. Recibe una lista de String y los
   convierte a un único String.
-}
concatPixels:: [Pixels] -> Pixels
concatPixels [] = []
concatPixels (x) = map sUnion (transpose x)
    where sUnion:: [String] -> String 
          sUnion xs = foldl (\acc x -> acc ++ x) [] xs 

{- |
    Función que recibe un String, 
     convierte cada caracter del String en un Pixel y los 
     concatena colocando un espacio en blanco entre sí. 

   > messageToPixels "AB"
    > ***  ****  
    >*   * *   * 
    >*   * *   * 
    >*   * ****  
    >***** *   * 
    >*   * *   * 
    >*   * ****  
-}
{-  Funciones no exportadas.  
    toPixels: Es una función que recibe un String, cada 
     caracter es convertido a un Pixel y luego son
     concatenados. 

    addWhiteSpace: Es una función que aplica "agregarWhiteSpace"
     a cada Pixel de un arreglo de Pixels. 

    agregarWhiteSpace: Es una función que agrega un espacio 
      en blanco al final de un Pixel. 
-}
messageToPixels:: String -> Pixels
messageToPixels "" = []
messageToPixels (x:xs) = concatPixels (addWhiteSpace (toPixels [] (x:xs)))
    where toPixels:: [Pixels] -> String -> [Pixels]
          toPixels acc []     = acc
          toPixels acc (x:xs) = toPixels (acc ++ [(font x)]) xs 

          addWhiteSpace:: [Pixels] -> [Pixels]
          addWhiteSpace p = map (agregarWhiteSpace) p

          agregarWhiteSpace:: Pixels -> Pixels
          agregarWhiteSpace p = map (++ " ") p

{- |
    Función que desplaza una hilera hacia arriba.

   > up (font 'A')
    >*   *
    >*   *
    >*   *
    >*****
    >*   *
    >*   *
    > *** 
-}
up:: Pixels -> Pixels
up [] = []
up p  = tail p ++ [head p]


-- | Función que desplaza una hilera hacia abajo.
down:: Pixels -> Pixels
down [] = []
down p  = [last p] ++ init p

{- |
    Función que desplaza una hilera hacia la izquierda. 

   > left (font 'A')
    >***  
    >   **
    >   **
    >   **
    >*****
    >   **
    >   **
-}
left:: Pixels -> Pixels
left [] = []
left p  = map (toLeft) p 
    where toLeft:: String -> String
          toLeft [] = []
          toLeft s  = tail s ++ [head s]

-- |Función que desplaza una hilera hacia la derecha. 
right:: Pixels -> Pixels
right [] = []
right p  = map (toRight) p
    where toRight:: String -> String
          toRight [] = []
          toRight s  = [last s] ++ init s

{- |
    Función que invierte el orden de la filas. 

   > upsideDown (font 'A')
    >*   *
    >*   *
    >*****
    >*   *
    >*   *
    >*   *
    > *** 
-}
upsideDown:: Pixels -> Pixels
upsideDown [] = []
upsideDown p = reverse p 

{- |
    Función que invierte el orden de las columnas. 

   > backwards (font 'B')
    > ****
    >*   *
    >*   *
    > ****   
    >*   *
    >*   *
    > ****
-}
backwards:: Pixels -> Pixels
backwards [] = [] 
backwards p  = map (reverse) p

{- |
   Función que intercambia espacios en blanco por 
    asteriscos y viceversa. 

   > negative (font 'A')
    >*   *
    > *** 
    > *** 
    > *** 
    >     
    > *** 
    > *** 
-}
{- Funciones no exportadas. 
   toNegative: Función que aplica invertirChar a 
    cada String de un Pixel. 

   invertirChar: Función que que realiza el intercambio
    mencionado anteriormente. 
-}
negative:: Pixels -> Pixels
negative [] = []
negative p  = map (toNegative) p
    where toNegative:: String -> String
          toNegative [] = []
          toNegative s  = map (invertirChar) s

          invertirChar:: Char -> Char
          invertirChar '*' = ' '
          invertirChar ' ' = '*'

-- Función no exportada. Función auxiliar para probar cada función. 
probar x = mapM putStrLn(x)
