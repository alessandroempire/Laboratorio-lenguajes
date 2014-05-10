-----------------------------------------------------
{- 
Module  
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
import Data.Char
import Control.Concurrent
import Data.List (intercalate)
import Data.Maybe (isNothing)
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
                                     print fns
                                     checkEffects fns
                                     e <- processEffects fns []
                                     ledDisplay m e
                             else    error $ "El nombre del archivo " ++ fn ++ " no existe."

checkEffects :: Monad m => [t] -> m ()
checkEffects [] = error "Error: Se debe suministrar al menos un archivo de efectos." 
checkEffects fns = return ()

processEffects :: [FilePath] -> [[Effects]] -> IO [Effects]
processEffects []       acc = do putStrLn "Se procesaron todos los efectos correctamente."
                                 let effectos = concat $ reverse acc
                                 return (effectos)
processEffects (fn:fns) acc = do fileExists <- SD.doesFileExist fn
                                 if fileExists
                                     then do fd <- SI.openFile fn SI.ReadMode
                                             putStrLn $ "Procesando " ++ fn
                                             e <- readDisplayInfo fd
                                             let newacc =  e : acc
                                             SI.hClose fd
                                             processEffects fns newacc
                                     else error $ "El nombre del archivo " ++ fn ++ " no existe."

-- | Función que lee cada efecto en un archivo y los retorna en un arreglo. 
readDisplayInfo :: SI.Handle -> IO [Effects]
readDisplayInfo h = do s <- SI.hGetContents h
                       let l = lines s
                           p = map readEffects l
                       return $! (p)

readEffects :: String -> Effects
readEffects s = case filter (null . dropWhile isSpace . snd) (reads s) of
                  [(a, _)] -> a
                  x       -> error "Error: invalida sintaxis en archivo de efectos."

ledDisplay :: M.Map Char Pixels -> [Effects] -> IO ()
ledDisplay m []     = print "Hasta Luego."
ledDisplay m es = do G.runGraphics $ do
                            let t = getsize es
                                d = getWsize m t
                            w <- G.openWindow "Pixels" d
                            G.clearWindow w
                            thread <- forkIO $ do 
                                                  applyEffect es m w defaultP
                                                  G.getKey w
                                                  G.closeWindow w
                            endless w thread                     

-- | Función la cual monitorea si el usuario presiona la telca ESC
endless :: G.Window -> ThreadId -> IO ()
endless w thread = do 
                      key <- G.getKey w 
                      if G.isEscapeKey key
                          then do putStrLn "Se presiono tecla ESC, hasta Luego!"
                                  killThread thread
                                  G.closeWindow w
                                  return ()
                          else endless w thread

-- | Función que calcula la longitud mas larga de todos los efectos posibles.
getsize :: [Effects] -> Int
getsize eff = foldl gsize 0 eff
    where gsize acc (Say a)       = if largo > acc
                                        then largo
                                        else acc
                                    where largo = length a
          gsize acc (Repeat i xs) = if newacc > acc
                                         then newacc
                                         else acc 
                                    where newacc = getsize xs
          gsize acc (Forever  xs) = if newacc > acc 
                                         then newacc
                                         else acc
                                    where newacc = getsize xs 
          gsize acc  _            = acc

-- | Función que calcula las dimensiones de la pantalla a mostrar. 
getWsize :: M.Map Char Pixels -> Int -> (Int, Int)
getWsize m n = if n /= 0
                  then ( (n * column * 3) + n*(column + column) + n*5 , 
                       ( row * 3 + row + 1) + 5   )
                  else (30, 30)
    where pix    = dots $ m M.! '\a'
          row    = length pix
          column = length $ head pix
  
--Valor inicial de la posición del Pixel en la pantalla.
ini = ((0,0), (3,3))
  
-- | Función que determina cual efecto se debe aplicar. 
applyEffect :: [Effects] -> M.Map Char Pixels -> G.Window -> Pixels -> IO Pixels
applyEffect [] _ _ p                  = return(p)

applyEffect ((Say a):es) m w _        = do G.clearWindow w
                                           let s = stringToPixel a m
                                           drawC w (dots s) ini (color s)
                                           applyEffect es m w s
 
applyEffect ((Up):es) m w p           = if p /= defaultP
                                             then do let np = up p
                                                     drawC w (dots np) ini (color np)
                                                     applyEffect es m w np
                                             else applyEffect es m w p

applyEffect ((Down):es) m w p         = if p /= defaultP
                                             then do let np = down p
                                                     drawC w (dots np) ini (color np)
                                                     applyEffect es m w np
                                             else applyEffect es m w p

applyEffect ((Effects.Left):es) m w p = if p /= defaultP
                                             then do let np = left p
                                                     drawC w (dots np) ini (color np)
                                                     applyEffect es m w np
                                             else applyEffect es m w p

applyEffect ((Effects.Right):es) m w p = if p /= defaultP
                                              then do let np = right p
                                                      drawC w (dots np) ini (color np)
                                                      applyEffect es m w np
                                              else applyEffect es m w p

applyEffect ((Backwards):es) m w p     = if p /= defaultP
                                              then do let np = backwards p
                                                      drawC w (dots np) ini (color np)
                                                      applyEffect es m w np
                                              else applyEffect es m w p

applyEffect ((UpsideDown):es) m w p    = if p /= defaultP
                                              then do let np = upsideDown p
                                                      drawC w (dots np) ini (color np)
                                                      applyEffect es m w np
                                              else applyEffect es m w p

applyEffect ((Negative):es) m w p      = if p /= defaultP
                                              then do let np = negative p
                                                      drawC w (dots np) ini (color np)
                                                      applyEffect es m w np
                                              else applyEffect es m w p

applyEffect ((Delay i):es) m w p       = do drawC w (dots p) ini (color p)
                                            threadDelay $ fromEnum i
                                            applyEffect es m w p

applyEffect ((Color c):es) m w p       = do let newc = changeColor p c
                                            drawC w (dots p) ini (color newc)
                                            applyEffect es m w newc


applyEffect ((Repeat i xs):es) m w p   = do repeat i xs m w p 
    where repeat i ps a b c =  do if i > 0 
                                      then do newp <- applyEffect ps a b c 
                                              repeat (i-1) ps a b (Pixels {color = (color newp), dots = (dots newp)})
                                      else do applyEffect es m w c


applyEffect ((Forever xs):es) m w p    = do let infinite = cycle xs
                                            applyEffect infinite m w p 

type Position = ((Int, Int), (Int,Int))

esfera :: G.Point -> G.Point -> [G.Graphic]
esfera a b = [G.ellipse a b]

drawC :: G.Window -> [[Pixel]] -> Position -> G.Color -> IO ()
drawC w []     pos               color = return ()
drawC w (p:ps) ((x1,y1),(x2,y2)) color = do let pos  = ((x1,y1+1), (x2,y2+1))
                                                y    = snd $ snd pos
                                                npos = ((x1,y+1), (x2,y+4))
                                            newx <- drawR w p pos color
                                            drawC w ps npos color

drawR :: G.Window -> [Pixel] -> Position -> G.Color -> IO (Position)
drawR w []      pos              color = do return (pos)
drawR w (p:ps) ((x1,y1),(x2,y2)) color = do let pos  = ((x1+1, y1), (x2+1, y2))
                                                x    = fst $ snd pos
                                                npos = ((x+1, y1), (x+4, y2))
                                            if (on p) 
                                                then do drawing w pos color
                                                        drawR w ps npos color
                                                else do drawing w pos G.Black
                                                        drawR w ps npos color

drawing :: G.Window -> (G.Point, G.Point) -> G.Color -> IO ()
drawing w (pos1, pos2) color = G.drawInWindow w $ G.withColor color $ G.overGraphics $ esfera (pos1) (pos2)                                         
