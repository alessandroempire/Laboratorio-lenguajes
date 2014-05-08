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
               fontBitmap                          -- :: [[Integer]] 

               -- * Operación básica
               ,font                               -- :: Char -> Pixels

               -- * Funciones para mostrar Pixeles en pantalla.
               ,pixelToString                      -- :: Pixels -> String
               ,pixelListToPixels                  -- :: [Pixels] -> Pixels
               ,pixelListToString                  -- :: [Pixels] -> String

               -- * Funciones combinadoras. 
               ,concatPixels                       -- :: [Pixels] -> Pixels
               ,messageToPixels                    -- :: String -> Pixels

               -- * Funciones para efectos Especiales. 
               ,up                                 -- :: Pixels -> Pixels
               ,down                               -- :: Pixels -> Pixels
               ,left                               -- :: Pixels -> Pixels
               ,right                              -- :: Pixels -> Pixels
               ,upsideDown                         -- :: Pixels -> Pixels
               ,backwards                          -- :: Pixels -> Pixels
               ,negative                           -- :: Pixels -> Pixels
              ) where

import Data.Char (ord)
import Data.Bits (Bits, testBit)
import Data.List (transpose, intercalate)

type Pixels = [String]

{- |
   Función que permite obtener la representación en pixel de un 
    caracter imprimible particular del alfabeto. 
-}
fontBitmap :: Num t => [[t]]
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
   fontBitmapList: Función que recibe un caracter imprimible y 
    busca en fontBitmap su representación en Pixels. 
   val: Indica el valor de la posición del caracter correspondiente. 
-}
fontBitmapList :: Char -> [Int]
fontBitmapList c 
    | 0 <= val && val <= 93 = fontBitmap !! val
    | otherwise             = [0x7F, 0x7F, 0x7F, 0x7F, 0x7F]
     where val = ord c -32

{- Función no exportada. 
   Función que convierte un número entero a una lista 
   de caracteres que representan los bits prendidos
   o apagados. 
-}
bitToChar :: Bits a => (Int, [Char]) -> a -> [Char]
bitToChar (a, acc) b
    | a == 7      = acc
    | testBit b a = bitToChar (a+1, '*' : acc) b
    | otherwise   = bitToChar (a+1, ' ' : acc) b

{- |  
    Función que recibe un caracter y lo convierte en un Pixel.

   > font ’A’
   >[ " *** ",
   >  "*   *",
   >  "*   *",
   >  "*   *",
   >  "*****",
   >  "*   *",
   >  "*   *"] 
-}
font :: Char -> Pixels 
font c = reverse . transpose . map (bitToChar (0, "")) $ fontBitmapList c

{- |
    Función que recibe un Pixel y retorna su representación en String. 

   > pixelToString (font 'A')
   > " *** \n*   *\n*   *\n*   *\n*****\n*   *\n*   *"
-}
pixelToString :: Pixels -> String
pixelToString [] = ""
pixelToString p  = init $ unlines p

{- |
    Función que recibe una lista de Pixels y concatena cada
     Pixels entre sí separados por el String \"\".
-}
pixelListToPixels :: [Pixels] -> Pixels
pixelListToPixels [] = []
pixelListToPixels ps = intercalate [""] ps

{- |
    Función que recibe una lista de Pixels, convierte cada elemento 
     a String usando 'pixelsToString' y luego los concatena entre sí 
     incorporando retornos de carro en medio.
-}
pixelListToString :: [Pixels] -> String
pixelListToString [] = ""
pixelListToString ps = intercalate "\n" $ map pixelToString ps

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
concatPixels :: [Pixels] -> Pixels
concatPixels [] = []
concatPixels ps = map concat $ transpose ps

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
messageToPixels :: String -> Pixels
--messageToPixels "" = []
messageToPixels cs = map (intercalate " ") $ transpose . reverse $ foldl (\acc x -> font x : acc) [] cs

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
up :: Pixels -> Pixels
up [] = []
up p  = tail p ++ [head p]

-- | Función que desplaza una hilera hacia abajo.
down :: Pixels -> Pixels
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
left :: Pixels -> Pixels
left [] = []
left p  = map toLeft p 
    where toLeft s = tail s ++ [head s]

-- |Función que desplaza una hilera hacia la derecha. 
right :: Pixels -> Pixels
right [] = []
right p  = map toRight p
    where toRight s = [last s] ++ init s

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
upsideDown :: Pixels -> Pixels
upsideDown [] = []
upsideDown p  = reverse p 

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
backwards :: Pixels -> Pixels
backwards [] = [] 
backwards p  = map reverse p

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
   invertirChar: Función que que realiza el intercambio
    mencionado anteriormente. 
-}
negative :: Pixels -> Pixels
negative [] = []
negative p  = map (map invertirChar) p
    where invertirChar c = if c == '*' then ' ' 
                                       else '*'
