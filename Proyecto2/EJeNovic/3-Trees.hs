-- aptitude install libghc6-hgl-dev
-- runhaskell 3-Trees.hs test1.tree test2.tree
import qualified System.Environment as SE
import qualified Graphics.HGL as G

data Tree a = Null | Fork a (Tree a) (Tree a)
     deriving (Show,Read)

mapT :: (a -> b) -> Tree a -> Tree b
mapT _ Null         = Null
mapT f (Fork x l r) = Fork (f x) (mapT f l) (mapT f r)

inorderT :: Tree a -> [a]
inorderT Null         = []
inorderT (Fork x l r) = inorderT l ++ x : inorderT r

-- Layout Strategy
-- Para un nodo v cualquiera:
--   x(v) es la posición del nodo en la secuencia inorder
--   y(v) es la altura del nodo en el árbol

type Position = (Int,Int)

layout :: Tree a -> Tree (a, Position)
layout t = fst $ layout' 1 1 t
  where layout' x y Null         = (Null, x)
        layout' x y (Fork a l r) = (Fork (a, (x',y)) l' r', x'')
           where (l',x')  = layout' x      (y+1) l
                 (r',x'') = layout' (x'+1) (y+1) r

-- Dibujitos coloridos

ppn = 32

coord :: Position -> Position
coord (x,y) = (ppn*x,ppn*y)

node :: Show a => (a, Position) -> G.Graphic
node (l,p) = 
  G.withColor G.White $
    G.withTextAlignment (G.Center, G.Top) $
      G.text (coord p) $ show l

nodes :: Show a => Tree (a, Position) -> [G.Graphic]
nodes = inorderT . mapT node

branch :: Position -> Position -> G.Graphic
branch f t =
  G.withColor G.White $
    G.line (coord f) (coord t)

branches :: Tree (a,Position) -> [G.Graphic]
branches (Fork _     Null               Null              ) = []
branches (Fork (_,f) l@(Fork (_,t) _ _) Null              ) = 
  (branch f t) : branches l
branches (Fork (_,f) Null               r@(Fork (_,t) _ _)) = 
  (branch f t) : branches r
branches (Fork (_,f) l@(Fork (_,u) _ _) r@(Fork (_,v) _ _)) =
  (branch f u) : (branch f v) : (branches l ++ branches r)

----------------------------------------------------------------
--Mundo IO
main = do
  files <- SE.getArgs
  processFiles files

processFiles []       = putStrLn "Bye!"
processFiles (fn:fns) = do 
  putStrLn $ "Processing " ++ fn
  s <- readFile fn
  let t = (read s)::(Tree String)
  drawTree t
  processFiles fns

drawTree :: Show a => Tree a -> IO ()
drawTree t = do
  G.runGraphics $ do
    w <- G.openWindow "Drawing Trees" (640,480)
    G.clearWindow w
    let l = layout t
    G.drawInWindow w $ G.overGraphics $ nodes l
    G.drawInWindow w $ G.overGraphics $ branches l
    G.getKey w
    G.closeWindow w
