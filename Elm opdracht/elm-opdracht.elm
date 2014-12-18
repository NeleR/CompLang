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
tailLength = 250

color1 = Color.lightBlue -- starts left
color2 = Color.orange -- starts right

type Position = (Float,Float)
type Tail = [(Float, Float)]
data Orientation = N | E | S | W

data PlayerState
    = PlayerState Position Orientation Tail
data GameState
    = Playing PlayerState PlayerState | Ended Int | Started
               
data KeybInput
    = KeybInput Int Int Int Int Bool

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
    = collage width height  [
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
            Ended winner -> showEnd winner
            Playing player1 player2 -> showPlayingState player1 player2
            
showEnd : Int -> Element
showEnd winner
    = beside (plainText ("Player ")) (beside (asText (winner)) (plainText (" has won")))
                        
step : KeybInput -> GameState -> GameState
step (KeybInput x2 y2 x1 y1 space) state
    = case state of
            Started -> if space then initialPlayingState else Started
            Ended p -> if space then initialPlayingState else Ended p
            Playing player1 player2 ->
                if  | space -> initialPlayingState
                    | atBorder player1 -> Ended 2
                    | atBorder player2 -> Ended 1
                    | collision player1 player2 -> Ended 2
                    | collision player1 player1 -> Ended 2
                    | collision player2 player1 -> Ended 1
                    | collision player2 player2 -> Ended 1
                    | otherwise -> Playing (movePlayer x1 y1 player1) (movePlayer x2 y2 player2)

collision : PlayerState -> PlayerState -> Bool
collision (PlayerState p1 o1 t1) (PlayerState p2 o2 t2)
    = if    | isEmpty t2 -> False
            | isInCycle p1 o1 (head t2) -> True
            | otherwise -> collision (PlayerState p1 o1 t1) (PlayerState p2 o2 (tail t2))
            
isInCycle : Position -> Orientation -> Position -> Bool
isInCycle (x1,y1) o1 (x2,y2)
    = case o1 of
            N -> if | x2==x1 && y2==y1 -> True
                    | otherwise -> False
            E -> if | x2==x1 && y2==y1 -> True
                    | otherwise -> False
            S -> if | x2==x1
                        && y2<=(y1) && y2>=(y1-playerH) -> True
                    | otherwise -> False
            W -> if | x2==x1 && y2==y1 -> True
                    | otherwise -> False

movePlayer : Int -> Int -> PlayerState -> PlayerState
movePlayer dx dy player
    = proceed (changeDir dx dy player)
          
changeDir : Int -> Int -> PlayerState -> PlayerState
changeDir dx dy (PlayerState p o t) 
    = case dx of
        1 -> (PlayerState p E t)
        (-1) -> (PlayerState p W t)
        0 -> case dy of
            1 -> (PlayerState p N t)
            (-1) -> (PlayerState p S t)
            0 -> (PlayerState p o t)

proceed : PlayerState -> PlayerState
proceed (PlayerState (x,y) o t)
    = case o of
        N -> PlayerState (x,(y+1)) o (take tailLength ((x,y)::t))
        S -> PlayerState (x,(y-1)) o (take tailLength ((x,y)::t))
        E -> PlayerState ((x+1),y) o (take tailLength ((x,y)::t))
        W -> PlayerState ((x-1),y) o (take tailLength ((x,y)::t))
                            
atBorder : PlayerState -> Bool
atBorder (PlayerState (x,y) o t)
    = if    | x > rightEdge && o == E -> True
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