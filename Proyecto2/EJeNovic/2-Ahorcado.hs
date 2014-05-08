main = do w <- getWord
          gameLoop "" w

gameLoop :: String -> String -> IO ()
gameLoop g w = 
  do if gameOver g w 
      then endGame g 
      else do putStrLn $ "Palabra hasta ahora:" ++  progress g w
              putStrLn $ "Intentos hasta ahora: " ++ g
              putStrLn "Intenta adivinar"
              putStr ">" 
              g' <- getLine
              gameLoop (g' ++ g) w
 
endGame g = 
    do putStrLn $ "Adivinaste en " ++ show (length g) ++ " intentos"
       putStrLn "(Escribe Enter para terminar)"  
       getLine
       return ()
          
clear = putStrLn $ replicate screenheight '\n'
        where screenheight = 40 

getWord = 
   do putStr "Ingresa la palabra a adivinar\n"
      putStr ">" 
      w <- getLine
      clear
      return w
            
gameOver g w = and [elem c g | c <- w ]

progress g w = [if elem c g then c else '*' | c <- w]

