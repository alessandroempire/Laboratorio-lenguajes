import qualified Graphics.HGL as G
import Pixels

main = do draw 
       
draw = do G.runGraphics $ do 
            w <-G.openWindow "Drawing" (800,600)
            G.clearWindow w
            --G.drawInWindow w $ G.overGraphics $ esfera (30,30) (30+3,30+3)
            drawing w ((30,30), (40,40))
            let a = drawI w "*** *" ((10,10),(13,13))
            print a
            --G.drawInWindow w $ G.overGraphics $ esfera (30,41) (40,51)
            --G.drawInWindow w $ G.overGraphics $ esfera (30,80) (40,90)
            --G.drawInWindow w $ G.overGraphics $ esfera (30,100) (40,100)

--            G.drawInWindow w $ G.overGraphics $ esfera (45,25) (60,40)
            G.getKey w
            G.closeWindow w    

--esfera :: Position -> Position -> [G.Graphic]
--esfera = undefined
esfera a b = [G.ellipse a b]

type Position = ((Int, Int), (Int,Int))
--coord x y = (x,y)

--layout :: Pixel -> pos
{-
layout (p:ps) pos = do drawP
                       --dibujo p
                       --layout ps newPos
                       -}

drawI w ps ((x1,y1),(x2,y2)) = foldl aux ((x1,y1),(x2,y2)) ps 
    where aux ((a1,b1),(a2,b2)) a = do drawing w ((a1,b1),(a2,b2))
                                       ((a1+3,b1),(a2+3,b2))

--drawI w ps ((x1,y1), (x2,y2)) = 


drawing w (pos1, pos2) = G.drawInWindow w $ G.overGraphics $ esfera (pos1) (pos2)

a = ["*   *","*   *"," * * ","  *  "," * * ","*   *","*   *"]
pix = toPixel a 

toPixel :: [[Char]] -> Pixels
toPixel array = Pixels {color = G.White, dots = map (map aux) array}
    where aux char = if char == '*' 
                     then Pixel {on = True}
                     else Pixel {on = False}    
