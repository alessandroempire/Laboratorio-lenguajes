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
                                             e <- readDisplayInfo fd
                                             let newacc = (:) e acc
                                             SI.hClose fd
                                             processEffects fns newacc
                                     else error $ "El nombre del archivo " ++ fn ++ " no existe."
