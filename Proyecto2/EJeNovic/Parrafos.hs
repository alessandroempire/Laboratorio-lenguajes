import System.Environment

type Word = [Char]

-- Contar Palabras
wordCount = length . concat . map words . lines

-- Formato simple (quitar blancos de mas)
formatAll  = unlines . map formatLine . lines
formatLine = rebuild . words
             where
               rebuild ws = if null ws then []
                                       else unwords ws

-- Convertir parrafos

type Para = [Word]

breakOn x xs = if null zs then [xs] 
                          else ys : breakOn x (tail zs)
               where (ys,zs) = span (/= x) xs

paras = map concat . filter (not . null) . breakOn [] . map words . lines

-- Justificar parrafos

fillPara n ws = if null xs then []
                           else xs : fillPara n ys
                where (xs,ys) = splitAt (greedy n ws) ws

greedy n = length . takeWhile (<=n) . scanl1 mn1 . map length
           where m `mn1` n = m + n + 1

format'' n = unparas . map (fillPara n) . paras

joinWith x = foldr1 stick
             where xs `stick` ys = xs ++ [x] ++ ys

unparas = unlines . joinWith [] . map (map unwords)

main = do
          [margin] <- getArgs
          text <- getContents
          let n = format'' (read margin :: Int) text
          putStr n
