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
import Control.Concurrent (threadDelay)
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
                                     e <- processEffects fns []
                                     --print m
                                     --print e
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
                                             e <- readDisplayInfo fd
                                             let newacc =  e : acc
                                             SI.hClose fd
                                             processEffects fns newacc
                                     else error $ "El nombre del archivo " ++ fn ++ " no existe."

-- | Función que lee cada efecto en un archivo y los retorna en un arreglo. 
--readDisplayInfo :: SI.Handle -> IO [Effects]
readDisplayInfo h = do s <- SI.hGetContents h
                       let a = lines s
                           b = checkf a
                       if isNothing b
                           then do let c = map read a :: [Effects]
                                   return $! (c)
                           else return ([])

--checkf ::
checkf (a:as) = do if largo == 0
                       then Just []
                       else if vacio
                           then Just []
                           else Nothing
    where largo = length a
          vacio = and $ map (== ' ') a

ledDisplay :: M.Map Char Pixels -> [Effects] -> IO ()
ledDisplay m []     = print "se acabo"
ledDisplay m es = do G.runGraphics $ do
                            w <- G.openWindow "Pixels" (800,600)
                            G.clearWindow w                            
                            applyEffect es m w defaultP 
                            --if G.isEscapeKey key
                              --  then do putStrLn "Hasta Luego."
                                --        return ()
                                --else do Nothing
                            --ledDisplay m es

-- \ESC es la tecla escape
  
--Valor inicial de la posición del Pixel en la pantalla
ini = ((5,5), (8,8))
  
 --applyEffects ::
applyEffect [] _ w _                  = do putStrLn "Se leyeron todos los efectos."
                                           putStrLn "Hasta Luego!."
                                           G.getKey w
                                           G.closeWindow w
                                           return ()

applyEffect ((Say a):es) m w _        = do G.clearWindow w
                                           let s = stringToPixel a m
                                           drawC w (dots s) ini (color s)
                                           applyEffect es m w s
 
applyEffect ((Up):es) m w p           = do G.clearWindow w
                                           let np = up p
                                           drawC w (dots np) ini (color np)
                                           applyEffect es m w np

applyEffect ((Down):es) m w p         = do G.clearWindow w
                                           let np = down p
                                           drawC w (dots np) ini (color np)
                                           applyEffect es m w np

applyEffect ((Effects.Left):es) m w p = do G.clearWindow w
                                           let np = left p
                                           drawC w (dots np) ini (color np)
                                           applyEffect es m w np

applyEffect ((Effects.Right):es) m w p = do G.clearWindow w
                                            let np = right p
                                            drawC w (dots np) ini (color np)
                                            applyEffect es m w np

applyEffect ((Backwards):es) m w p     = do G.clearWindow w
                                            let np = backwards p
                                            drawC w (dots np) ini (color np)
                                            applyEffect es m w np

applyEffect ((UpsideDown):es) m w p    = do G.clearWindow w
                                            let np = upsideDown p
                                            drawC w (dots np) ini (color np)
                                            applyEffect es m w np

applyEffect ((Negative):es) m w p      = do G.clearWindow w
                                            let np = negative p
                                            drawC w (dots np) ini (color np)
                                            applyEffect es m w np

applyEffect ((Delay i):es) m w p       = do drawC w (dots p) ini (color p) --falta aqui
                                            threadDelay $ fromEnum i
                                            applyEffect es m w p

applyEffect ((Color c):es) m w p       = do G.clearWindow w
                                            let newc = changeColor p c
                                            drawC w (dots p) ini (color newc)
                                            applyEffect es m w newc
{-
applyEffect (Forever xs)    = do print "en forever"
                                 print xs 
applyEffect (Repeat i xs)   = do print "en repeat"
-}

type Position = ((Int, Int), (Int,Int))

--esfera :: 
esfera a b = [G.ellipse a b]

--drawC ::
drawC w []     pos               color = return ()
drawC w (p:ps) ((x1,y1),(x2,y2)) color = do let pos  = ((x1,y1+1), (x2,y2+1))
                                                y    = snd $ snd pos
                                                npos = ((x1,y+4), (x2,y+7)) 
                                            newx <- drawR w p pos color
                                            drawC w ps npos color

--drawI :: G.Window -> [Bool] -> Position -> IO ()
drawR w []      pos              color = do return (pos)
drawR w (p:ps) ((x1,y1),(x2,y2)) color = do let pos  = ((x1+1, y1), (x2+1, y2))
                                                npos = ((x1+4, y1), (x2+4, y2))
                                            if (on p) 
                                                then do drawing w pos color
                                                        drawR w ps npos color
                                                else do drawR w ps npos color

--drawing ::
drawing w (pos1, pos2) color = G.drawInWindow w $ G.withColor color $ G.overGraphics $ esfera (pos1) (pos2)                                         
