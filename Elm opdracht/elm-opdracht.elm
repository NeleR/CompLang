import Color
import Keyboard
import Debug

-- default values
width = 1024
height = 768

bottomEdge = -(height/2)+playerW
topEdge = (height/2)-playerW
leftEdge = -(width/2)+playerW
rightEdge = (width/2)-playerW

playerW = 64
playerH = 16

tailWidth = 2

color1 = Color.lightBlue -- starts left
color2 = Color.orange -- starts right

type Position = (Float,Float)
type Tail = [(Float, Float)]
data Orientation = N | E | S | W

data PlayerState = PlayerState Position Orientation Tail
data GameState = Playing PlayerState PlayerState
               | Ended Int | Started
               
data KeybInput = KeybInput Int Int Int Int Bool

-- example use: showPlayer Color.lightBlue (10, 10) N
showPlayer : Color -> Position -> Orientation -> Form
showPlayer color (x,y) o =
    let fw = toFloat playerW
        (xOffset, yOffset, degs) = case o of
                    N -> (0, fw / 2, 90)
                    E -> (fw / 2, 0, 0)
                    S -> (0, -fw / 2, -90)
                    W -> (-fw / 2, 0, 180)
    in rect (fw) (toFloat playerH) 
        |> outlined (solid color)
        |> move (x, y)
        |> move (xOffset, yOffset)
        |> rotate (degrees degs) 


-- example use: showTail Color.lightBlue [(10, 10), (20, 10)]
showTail : Color -> Tail -> Form
showTail color positions = 
    traced { defaultLine |
        width <- tailWidth
        , color <- color
        } (path positions)

-- my own code
main : Signal Element
main = lift showState gameState

gameState : Signal GameState
gameState = foldp step Started keybInput
                        
initialPlayingState : GameState
initialPlayingState =
    let position1 = leftEdge+(50-playerW)
    in let position2 = rightEdge-(50-playerW)
        in let initialPlayer1 = PlayerState (position1,0) E []
            in let initialPlayer2 = PlayerState (position2,0) W []
                in Playing initialPlayer1 initialPlayer2

showPlayingState : PlayerState -> PlayerState -> Element
showPlayingState (PlayerState (x1,y1) o1 t1) (PlayerState (x2,y2) o2 t2)
       = collage width height   [
                                filled black (rect width height), -- playing field
                                showPlayer color1 (x1, y1) o1, -- player 1
                                showPlayer color2 (x2, y2) o2, -- player 2
                                showTail color1 t1, -- tail player 1
                                showTail color2 t2 -- tail player 2
                                ]

heartbeat : Signal Time
heartbeat = every (second/100)

keybInput : Signal KeybInput
keybInput = 
    let realInput = lift5 KeybInput (lift (.x) Keyboard.arrows) (lift (.y) Keyboard.arrows) (lift (.x) Keyboard.wasd) (lift (.y) Keyboard.wasd) Keyboard.space
    in let sampledInput = sampleOn heartbeat realInput
        in lift (Debug.watch "keybInput") sampledInput
     

showState : GameState -> Element
showState state
    = case state of
            Started -> plainText "Press space to start a new game"
            Ended winner -> beside (plainText ("Player ")) (beside (asText (winner)) (plainText (" has won")))
            Playing player1 player2 -> showPlayingState player1 player2
                        
step : KeybInput -> GameState -> GameState
step (KeybInput x2 y2 x1 y1 space) state
    = case state of
            Started -> if space then initialPlayingState else Started
            Ended p -> if space then initialPlayingState else Ended p
            Playing player1 player2 ->
                if  | space -> initialPlayingState
                    | atBorder player1 -> Ended 2
                    | atBorder player2 -> Ended 1
                    | otherwise -> 
                        case x1 of
                            0 -> case y1 of
                                0 -> case x2 of
                                    0 -> case y2 of
                                        0 -> Playing (proceed player1) (proceed player2)
                                        otherwise -> Playing (proceed player1) (changeYDir y2 (proceed player2))
                                    otherwise -> Playing (proceed player1) (changeXDir x2 (proceed player2))
                                otherwise -> Playing (changeYDir y1 (proceed player1)) (proceed player2)
                            otherwise -> Playing (changeXDir x1 (proceed player1)) (proceed player2)
                -- crossing player1 player2 -> Ended 1
                    -- crossing player2 player1 -> Ended 2
                   -- else Playing (proceed player1) (proceed player2)
          
changeXDir : Int -> PlayerState -> PlayerState
changeXDir d (PlayerState p o t) = if   | d == 1 -> (PlayerState p E t)
                                        | d == (-1) -> (PlayerState p W t)
                                        | otherwise -> (PlayerState p o t)
-- change tail!

changeYDir : Int -> PlayerState -> PlayerState
changeYDir d (PlayerState p o t) = if   | d == 1 -> (PlayerState p N t)
                                        | d == -1 -> (PlayerState p S t)
                                        | otherwise -> (PlayerState p o t)
-- change tail!

proceed : PlayerState -> PlayerState
proceed (PlayerState (x,y) o t) = case o of
                            N -> PlayerState (x,(y+1)) o (cutTail ((x,(y+1))::t))
                            S -> PlayerState (x,(y-1)) o (cutTail ((x,(y-1))::t))
                            E -> PlayerState ((x+1),y) o (cutTail (((x+1),y)::t))
                            W -> PlayerState ((x-1),y) o (cutTail (((x-1),y)::t))
                            
cutTail : Tail -> Tail
cutTail t1::t2::t3::t4::t5::t6::t7::t8::t9::t10::t11::t12::t13::t14::t15::t16::t17::t18::t19::t20::tail = t1::t2::t3::t4:t5:t6:t7:t8:t9::t10::t11::t12::t13::t14::t15::t16::t17::t18::t19::t20
                            
atBorder : PlayerState -> Bool
atBorder (PlayerState (x,y) o t) = if   | x > rightEdge && o == E -> True
                                        | x < leftEdge && o == W -> True
                                        | y > topEdge && o == N -> True
                                        | y < bottomEdge && o == S -> True
                                        | otherwise -> False
                    
-- playing field: widthxheight, black => floats, not ints!
-- game start: plainText "Press space to start a new game"
-- restart game by space
-- game end: "Player _ has won!"
-- player start 50 pixel from edge, towards center
-- 50 pixels per second
-- steering: arrows and wasd
-- draai instantanious
-- collision: de dozen mogen raken, de staarten niet
-- tail: vraagt een lijst van segmentpunten
-- locatie: staart start op het einde van de cycle
-- lengte staart: ongeveer gelijk maken als voorbeeld