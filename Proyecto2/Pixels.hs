-----------------------------------------------------
{- |
Module      :  
Description : El tipo Pixels y sus operaciones.  
CopyRight   : (c) Alessandro La Corte
                  Ivanhoe Gamarra

Definición del tipo Pixels y Pixel. 
-}
-----------------------------------------------------


module Pixels ( 
              -- * El tipo Pixels.
              Pixels (..)                -- :: Pixels { color = Color, dots = Pixel }
              ,Pixel (..)                -- :: Pixel  { on :: Boolean }

              -- * Funciones que operan sobre los Pixels.
              , font                     -- :: Map Char Pixels -> Char -> Pixels
              , stringToPixel            -- :: String -> Map Char Pixels -> Pixels
              , readFont                 -- :: Handle -> IO (Map Char Pixels)
              -- * Funciones que modifican un Pixel.
              , up                       -- :: Pixels -> Pixels
              , down                     -- :: Pixels -> Pixels
              , left                     -- :: Pixels -> Pixels
              , right                    -- :: Pixels -> Pixels
              , upsideDown               -- :: Pixels -> Pixels
              , backwards                -- :: Pixels -> Pixels
              , negative                 -- :: Pixels -> Pixels
              ) where

import qualified System.IO as SI
import qualified Graphics.HGL as G
import Data.Bool
import Data.Maybe (isJust, fromJust)
import qualified Data.Map as M
import Data.List (transpose, intercalate)

type Boolean = Bool

data Pixels = Pixels { color :: G.Color, dots  :: [[Pixel]] }
     deriving (Show)

data Pixel = Pixel { on :: Boolean }
     deriving (Show, Eq)

-- | Función que encuentra el pixel correspondiente a un caracter. 
font :: M.Map Char Pixels -> Char -> Pixels
font m c = if isJust findP
                then fromJust findP
                else getAllOn
    where findP    = M.lookup c m
          getAllOn = m M.! '\a'

-- | Función que lee cada letra y su respectiva representació en Pixels
readFont :: SI.Handle -> IO (M.Map Char Pixels)
readFont h = do s <- SI.hGetContents h
                let l     = lines s
                    n     = words $ head l
                    f     = map init $ tail l
                    nums  = checkNum n
                    allOn = allOnPix (nums !! 0) (nums !! 1)
                    amap  = M.insert '\a' allOn (M.empty)
                m <- readf f nums amap
                return (m)

readf :: [[Char]] -> [Int] -> M.Map Char Pixels -> IO (M.Map Char Pixels)
readf []     _    m = return (m)
readf (f:fs) nums m = do let char = checkChar $ f
                             a    = splitAt (nums !! 1) fs
                             x    = fst a
                             y    = snd a
                             pixs = toPixel x
                             --pixs = Pixels {color = G.White, dots = pix}
                             nmap = M.insert char pixs m
                         checkR x
                         checkC x $ head nums
                         checkN y
                         readf y nums nmap

--Esta funciona chequea que no existan filas de más de lo indicado.
checkN :: Monad m => [[Char]] -> m ()
checkN [] = return ()
checkN fs = if check
                then error "Error: existen más filas de lo indicado."
                else return ()
    where check = and $ map toBool $ head fs

-- Esta funcion chequea que no existan menos filas de lo indicado. 
checkR :: Monad m => [[Char]] -> m ()
checkR fs = if check 
                then return ()
                else error "Error: existen menos filas de lo indicado."
    where check = and $ map and $ map (map toBool) fs
          
toBool :: Char -> Bool
toBool c = if c == '*' then True
                       else if c == ' '
                           then True
                           else False

--Esta funcion chequea que exista el numero correcto de columnas.
checkC :: Monad m => [[a]] -> Int -> m ()
checkC fs num = if check 
                    then return ()
                    else error "Error: número de columnas incorrectas."
    where check    = and $ map toBool fs
          toBool s = if (length s) == num then True
                                     else False

checkNum :: [[Char]] -> [Int]
checkNum nums = if largo /= 2
                    then error "Error: Incorrecta cantidad de números."
                    else foldr toNum [] nums
    where largo       = length nums
          toNum n acc = if x < 0 
                           then error "Error: número negativo."
                           else x : acc
                        where x = read n :: Int

checkChar :: [a] -> a
checkChar c = if largo < 3
                  then error "Error: menos de un caracter."
                  else if largo > 3 
                      then error "Error: más de un caracter."
                      else c !! 1
    where largo = length c 

-- | Función que nos crea un Pixels con todos los Pixel prendidos.
allOnPix :: Int -> Int -> Pixels
allOnPix column row = toPixel pixArray
    where pixArray  = replicate row $ replicate column '*'

-- | Función que convierte un arreglo de String a un Pixels de color White. 
toPixel :: [[Char]] -> Pixels
toPixel array = Pixels {color = G.White, dots = map (map aux) array}
    where aux char = if char == '*' 
                     then Pixel {on = True}
                     else Pixel {on = False}  

-- | Función que convierte una palabra a un Pixel de color White.
stringToPixel :: String -> M.Map Char Pixels -> Pixels
stringToPixel cs pMap = Pixels {color = G.White, dots = toPix}
    where toPix           = map (intercalate [Pixel {on = False}]) $transpose $ foldr concatPix [] cs
          concatPix c acc = dots (font pMap c) : acc

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
up Pixels {color = c, dots = d} = Pixels {color = c, dots = moveUp}
    where moveUp = tail d ++ [head d]

-- | Función que desplaza una hilera hacia abajo.
down :: Pixels -> Pixels
down Pixels {color = c, dots = d} = Pixels {color = c, dots = moveDown}
    where moveDown = [last d] ++ init d

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
left Pixels {color = c, dots = d} = Pixels {color = c, dots = map toLeft d}
    where toLeft s = tail s ++ [head s]

-- |Función que desplaza una hilera hacia la derecha. 
right :: Pixels -> Pixels
right Pixels {color = c, dots = d} = Pixels {color = c, dots = map toRight d}
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
upsideDown Pixels {color = c, dots = d} = Pixels {color = c, dots = reverse d}

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
backwards Pixels {color = c, dots = d} = Pixels {color = c, dots = map reverse d}

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
negative :: Pixels -> Pixels
negative Pixels {color = c, dots = d} = Pixels {color = c, dots = map (map invertirPix) d}
    where invertirPix c = if c == Pixel {on = True} then Pixel {on = False} 
                                                    else Pixel {on = True}
