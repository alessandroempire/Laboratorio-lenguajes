--Respuestas al libro "Learn you a Haskell"

-- Chapter2

-- x + x no me deja
 
doubleme x = x + x

doubleus x y = x*2 + y*2

doubleus' x y = doubleme x + doubleme y

doubleSmallNumber x = if x > 100 then x
                                 else doubleme x

connan = "my name is connan"

lostnumbers = [4,8,15,16,23,42]

lostnumbers1 = [1,2] ++ [3,4]

name = ['w','o'] ++ ['o','t']

con = 'A' : "fuck"

nums = 5 : [1,2,3]

indice = "busqueda por indice" !! 6

--error al compilar
--let b = [[1,2],[3,4],[5,6]]
--c = [ [1,2], [3,4], [5,6]]

a = [3,2,1] > [2,10,200]
-- [3,2,1] > [2,1,0]

he = head [5,4,3]

ta = tail [5,4,3]

la = last [5,4,3]

ini = init [5,4,3,2,1]

ranger = [1..20]

ranger1 = [2,4..20]

tuple = (1,2)

first = fst tuple

last = snd (5,7)

--zip
