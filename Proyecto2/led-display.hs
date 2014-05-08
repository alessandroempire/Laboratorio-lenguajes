-----------------------------------------------------
{- |
Module      :  
Description : .... 
CopyRight   : (c) Alessandro La Corte
                  Ivanhoe Gamarra
Operaciones IO 
-}
-----------------------------------------------------

import qualified System.Environment as SE
import qualified System.Directory as SD
import qualified System.IO as SI 
import qualified Data.Map as M
import qualified Graphics.HGL as G
import Data.List (intercalate)
--import Data.Maybe
import Pixels
import Effects

-------------------- Funciones IO ----------------------------------

main = do files <- SE.getArgs
          processFont files

processFont :: [FilePath] -> IO ()
processFont []       = error "Error: No existen archivos especificados." 
processFont (fn:fns) = do fileExists <- SD.doesFileExist fn
                          if fileExists
                             then do fd <- SI.openFile fn SI.ReadMode
                                     putStrLn $ "Procesando " ++ fn
                                     m <- readFont fd
                                     SI.hClose fd
                                     e <- processEffects fns []
                                     print m
                                     print e
                                     ledDisplay m e
                             else    error $ "El nombre del archivo " ++ fn ++ " no existe."

processEffects :: [FilePath] -> [[Effects]] -> IO [Effects]
processEffects []       acc = do putStrLn "Se procesaron todos los efectos correctamente."
                                 let effectos = concat $ reverse acc
                                 return (effectos)
processEffects (fn:fns) acc = do fileExists <- SD.doesFileExist fn
                                 if fileExists
                                     then do fd <- SI.openFile fn SI.ReadMode
                                             putStrLn $ "Procesando " ++ fn
                                             --e <- readDisplayInfo fd
                                             readDisplayInfo fd
                                             --let newacc = (:) e acc
                                             SI.hClose fd
                                             --processEffects fns newacc
                                             processEffects fns acc
                                     else error $ "El nombre del archivo " ++ fn ++ " no existe."

-- | Función que lee cada efecto en un archivo y los retorna en un arreglo. 
--readDisplayInfo :: SI.Handle -> IO [Effects]
readDisplayInfo h = do s <- SI.hGetContents h
                       let a = lines s
                           b = checkf a
                       print a
                       --checkf a
                           --b = map read a :: [Effects]
                       --return $! (b)

--checkf ::
checkf (a:as) = do 
                   if largo == 0
                       then Just []
                       else if vacio
                           then Just []
                           else Nothing
    where largo = length a
          vacio = and $ map (== ' ') a

ledDisplay :: M.Map Char Pixels -> [Effects] -> IO ()
ledDisplay m []     = print "se acabo"
ledDisplay m (e:es) = do G.runGraphics $ do
                            w <- G.openWindow "Pixels" (800,600)
                            G.clearWindow w                            
                            applyEffect e m w
                            -- pos <- drawR w (dots pix
                            --acuerdate del getkey
                            ledDisplay m es

-- \ESC es la tecla escape
  
 --applyEffects ::
applyEffect (Say a) m w     = do let s = stringToPixel a m
                                 pos <- drawC w (dots s) ((5,5), (8,8))
                                 return s
{-                                 
applyEffect (Up)            = do print "en up"  --modificar mensaje e print
applyEffect (Down)          = do print "en down" 
applyEffect (Effects.Left)  = do print "en left"
applyEffect (Effects.Right) = do print "en right"
applyEffect (Backwards)     = do print "en back"
applyEffect (UpsideDown)    = do print "en upside"
applyEffect (Negative)      = do print "en negative"
applyEffect (Delay i)       = do print "en delay"
applyEffect (Color c)       = do print "en color"
applyEffect (Forever xs)    = do print "en forever"
                                 print xs 
applyEffect (Repeat i xs)   = do print "en repeat"
-}




type Position = ((Int, Int), (Int,Int))

--esfera :: 
esfera a b = [G.ellipse a b]

--drawC ::
drawC w []     pos               = return (pos)
drawC w (p:ps) ((x1,y1),(x2,y2)) = do let pos  = ((x1,y1+1), (x2,y2+1))
                                          y    = snd $ snd pos
                                          npos = ((x1,y+4), (x2,y+7)) 
                                      newx <- drawR w p pos
                                      drawC w ps npos

--drawI :: G.Window -> [Bool] -> Position -> IO ()
drawR w []      pos              = do return (pos)
drawR w (p:ps) ((x1,y1),(x2,y2)) = do 
                                      let pos  = ((x1+1, y1), (x2+1, y2))
                                          npos = ((x1+4, y1), (x2+4, y2))                                          
                                      print pos
                                      if (on p) 
                                          then do print "si entra aqui"
                                                  drawing w pos 
                                                  drawR w ps npos
                                          else do print "entra aqui"
                                                  drawR w ps npos

--drawing ::
drawing w (pos1, pos2) = G.drawInWindow w $ G.overGraphics $ esfera (pos1) (pos2)                                         
