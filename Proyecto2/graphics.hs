import qualified Graphics.HGL as G
import Pixels

main = do draw 
       
draw = do G.runGraphics $ do 
            w <-G.openWindow "Drawing" (800,600)
            G.clearWindow w
            --a <- drawR w ((dots pix) !! 0) ((5,5),(8,8))
            --b <- drawR w ((dots pix) !! 0) ((5,12),(8,15))
            --print a 
            a <- drawC w (dots pix) ((5,5), (8,8))
            print a
            print ((dots pix) !! 0)
            print "hizo lo q tenia que hacer"
            G.getKey w
            G.closeWindow w    


esfera a b = [G.ellipse a b]

type Position = ((Int, Int), (Int,Int))

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

drawing w (pos1, pos2) = G.drawInWindow w $ G.overGraphics $ esfera (pos1) (pos2)

---------------------ejemplo----------------------------------
a = ["*   *","*   *"," * * ","  *  "," * * ","*   *","*   *"]
pix = toPixel a 

toPixel :: [[Char]] -> Pixels
toPixel array = Pixels {color = G.White, dots = map (map aux) array}
    where aux char = if char == '*' 
                     then Pixel {on = True}
                     else Pixel {on = False}    



---comentarios
            --G.drawInWindow w $ G.overGraphics $ esfera (30,41) (40,51)
            --G.drawInWindow w $ G.overGraphics $ esfera (30,80) (40,90)
            --G.drawInWindow w $ G.overGraphics $ esfera (30,100) (40,100)

--          G.drawInWindow w $ G.overGraphics $ esfera (45,25) (60,40)                     
           --G.drawInWindow w $ G.overGraphics $ esfera (30,30) (30+3,30+3)
            --drawing w ((30,30), (40,40))

