-- Make a program that draws a 500x500 black rectangle with a small
-- white 10x10 rectangle in the middle, so that you can move the small
-- rectangle with the keyboard arrows. Make use of the functions
-- Keyboard.arrows, Collage.collage, Collage.rect, Collage.filled,
-- Collage.move, Signal.foldp, toFloat and Signal.lift.


-- NIET AF!!!!


import Keyboard

updateOnSignal : Signal {x : Int, y : Int} -> (Float,Float)
updateOnSignal state = update (signalArrow lift Keyboard.arrows) state

update : (Int,Int) -> (Float,Float) -> (Float,Float)
update {arrowX,arrowY} (x,y) = (x + arrowX, y + arrowY)

showState : (Float,Float) -> Element
showState (x,y) = collage 500 500 [
                     filled black (rect 500 500),
                     move (x,y) (filled white (rect 10 10))
                   ]

signalArrow  : {x : Int, y : Int} -> (Int,Int)
signalArrow signal = if | signal == { x = 0, y = 0 } -> (0,0)
                        | signal == { x =-1, y = 0 } -> (-1,0)
                        | signal == { x = 1, y = 1 } -> (1,1)
                        | signal == { x = 0, y =-1 } -> (0,-1)
                        | otherwise -> (-2,-2)

state : Signal (Float,Float)
state = foldp updateOnSignal (0,0) Keyboard.arrows

main : Signal Element
main = lift showState state
