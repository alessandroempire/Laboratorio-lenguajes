-----------------------------------------------------
{- |
Module      :  
Description : El tipo Pixels y sus operaciones.  
CopyRight   : (c) Alessandro La Corte
                  Ivanhoe Gamarra

 
-}
-----------------------------------------------------

module Effects (
                Effects (..)
               ) where

import qualified Graphics.HGL as G

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
     deriving (Show, Read) 

--desarrollar
