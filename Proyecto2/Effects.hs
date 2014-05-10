-----------------------------------------------------
{- |
Module      :  
Description : El tipo Pixels y sus operaciones.  
CopyRight   : (c) Alessandro La Corte
                  Ivanhoe Gamarra

 
-}
-----------------------------------------------------

module Effects (
                -- * Tipo de datos Effects
                Effects (..)

                -- * Funciones que operan sobre el tipo Effects
                , stringToPixel                      -- :: String -> Map Char Pixels -> Pixels
                , changeColor                        -- :: Pixels -> Pixels
                , up                                 -- :: Pixels -> Pixels
                , down                               -- :: Pixels -> Pixels
                , left                               -- :: Pixels -> Pixels
                , right                              -- :: Pixels -> Pixels
                , upsideDown                         -- :: Pixels -> Pixels
                , backwards                          -- :: Pixels -> Pixels
                , negative                           -- :: Pixels -> Pixels
               ) where

import qualified Graphics.HGL as G
import qualified System.IO as SI
import qualified Data.Map as M
import Data.List (transpose, intercalate)
import Pixels

data Effects = Say String 
             | Up
             | Down
             | Left
             | Right
             | Backwards
             | UpsideDown
             | Negative
             | Delay Integer
             | Color G.Color
             | Repeat Integer [Effects]
             | Forever [Effects]
     deriving (Show, Read, Eq) 

-- | Función que convierte una palabra a un Pixel de color White.
stringToPixel :: String -> M.Map Char Pixels -> Pixels
stringToPixel cs pMap = Pixels {color = G.White, dots = toPix}
    where toPix           = map (intercalate [Pixel {on = False}]) $transpose $ foldr concatPix [] cs
          concatPix c acc = dots (font pMap c) : acc

-- | Función que cambia el color de un Pixels.
changeColor :: Pixels -> G.Color -> Pixels
changeColor p c = Pixels { color = c, dots = dots p}

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
