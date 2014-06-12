largo :: [a] -> Int

largo[] = 0 
largo (x:xs) = 1 + largo xs

largo1 :: [a] -> Int -> Int
largo1 [] v = v
largo1 (x:xs) v = largo1 xs (v+1)

largo2 x = largo1 x 0 
