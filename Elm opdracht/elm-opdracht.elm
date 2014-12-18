---------------------------------------------------------------------
-- Elm Assignment - Comparative Programming Languages (2014-2015)  --
-- Nele Rober, r0262954                                            -- 
---------------------------------------------------------------------

{- imports -}

import Color
import Keyboard
import Debug


 
{- default values -}

width = 1024
height = 768

playerW = 64
playerH = 16

tailWidth = 2
tailLength = 250

color1 = Color.lightBlue
color2 = Color.orange

bottomEdge = -(height/2)+playerW
topEdge = (height/2)-playerW
leftEdge = -(width/2)+playerW
rightEdge = (width/2)-playerW


 
{- new data structures -}

type Position = (Float,Float)
type Tail = [(Float, Float)]
data Orientation = N | E | S | W

data PlayerState
    = PlayerState Position Orientation Tail
data GameState
    = Playing PlayerState PlayerState | Ended Int | Started
               
data KeybInput
    = KeybInput Int Int Int Int Bool


 
{- given code: to display the players and their tails -}

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


 
{----------------}
{- main program -}
{----------------}

-- main: this function is called when the program starts; it shows the game state throughout the game
main : Signal Element
main = lift showState gameState

-- starts the game in the Started game state and and makes the game progress from there on (based on keyboard input and the step function)
gameState : Signal GameState
gameState = foldp step Started keybInput
                        
-- describes the initial Playing game state: both players are put at their starting position with their appropriate staring orientation and an empty tail
initialPlayingState : GameState
initialPlayingState =
    let position1 = leftEdge+(50-playerW)
    in let position2 = rightEdge-(50-playerW)
        in let initialPlayer1 = PlayerState (position1,0) E []
            in let initialPlayer2 = PlayerState (position2,0) W []
                in Playing initialPlayer1 initialPlayer2


              
{-----------------------}
{- screen manipulation -}
{-----------------------}
     
-- show the current game state
showState : GameState -> Element
showState state
    = case state of
            Started -> plainText "Press space to start a new game"
            Ended winner -> showEnd winner
            Playing player1 player2 -> showPlayingState player1 player2
            
-- draws all elements of the Ended state on the screen: a text indicating who has won
showEnd : Int -> Element
showEnd winner
    = beside (plainText ("Player ")) (beside (asText (winner)) (plainText (" has won")))

-- draws all elements of a Playing state on the screen: the field, the players and their tails
showPlayingState : PlayerState -> PlayerState -> Element
showPlayingState (PlayerState (x1,y1) o1 t1) (PlayerState (x2,y2) o2 t2)
    = collage width height  [
                            filled black (rect width height), -- playing field
                            showPlayer color1 (x1, y1) o1, -- player 1
                            showPlayer color2 (x2, y2) o2, -- player 2
                            showTail color1 (tail t1), -- tail player 1
                            showTail color2 (tail t2) -- tail player 2
                            ]


 
{-----------------}
{- game progress -}
{-----------------}

-- makes the game progress appropriately according to the game state and the location of the players
-- this method is triggered either by a heartbeat signal or by a keyboard signal
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

-- moves a player one step forward and changes its direction if necessary
movePlayer : Int -> Int -> PlayerState -> PlayerState
movePlayer dx dy player
    = proceed (changeDir dx dy player)
    
-- makes the player proceed one step, in the appropriate direction
-- a new point is added to the tail and the last point of the tail is deleted 
proceed : PlayerState -> PlayerState
proceed (PlayerState (x,y) o t)
    = case o of
        N -> PlayerState (x,(y+1)) o (take tailLength ((x,y)::t))
        S -> PlayerState (x,(y-1)) o (take tailLength ((x,y)::t))
        E -> PlayerState ((x+1),y) o (take tailLength ((x,y)::t))
        W -> PlayerState ((x-1),y) o (take tailLength ((x,y)::t))
          
-- makes the direction of a player change appropriately
-- dx: whether the player turns in the x direction (value of a or d or left or right arrows)
-- dy: whether the player turns in the x direction (value of w or s or up or right down)
changeDir : Int -> Int -> PlayerState -> PlayerState
changeDir dx dy (PlayerState p o t) 
    = case dx of
        1 -> (PlayerState p E t)
        (-1) -> (PlayerState p W t)
        0 -> case dy of
            1 -> (PlayerState p N t)
            (-1) -> (PlayerState p S t)
            0 -> (PlayerState p o t)


 
{-----------------------}
{- collision detection -}
{-----------------------}
                         
-- decides whether a player is colliding with the border
-- example use: atBorder (PlayerState (520,0) E []) -> True
atBorder : PlayerState -> Bool
atBorder (PlayerState (x,y) o t)
    = if    | x > rightEdge && o == E -> True
            | x < leftEdge && o == W -> True
            | y > topEdge && o == N -> True
            | y < bottomEdge && o == S -> True
            | otherwise -> False

-- detects whether the first given player is hitting the tail of the second given player (they do not have to be different players)
collision : PlayerState -> PlayerState -> Bool
collision (PlayerState p1 o1 t1) (PlayerState p2 o2 t2)
    = if    | isEmpty t2 -> False
            | isInCycle (head t2) p1 o1 -> True
            | otherwise -> collision (PlayerState p1 o1 t1) (PlayerState p2 o2 (tail t2))

-- checks whether the given point (the first arg) lies within the light cycle of the player on the given position (the second arg) and with the given orientation (the third arg)
isInCycle : Position -> Position -> Orientation -> Bool
isInCycle (x2,y2) (x1,y1) o1
    = case o1 of
            N -> if | x2<=(x1+(playerH/2)) && x2>=(x1-(playerH/2)) &&
                        y2<=(y1+playerW) && y2>=(y1) -> True
                    | otherwise -> False
            E -> if | x2<=(x1+playerW) && x2>=(x1) &&
                        y2<=(y1+(playerH/2)) && y2>=(y1-(playerH/2)) -> True
                    | otherwise -> False
            S -> if | x2<=(x1+(playerH/2)) && x2>=(x1-(playerH/2)) &&
                        y2<=(y1) && y2>=(y1-playerW) -> True
                    | otherwise -> False
            W -> if | x2<=(x1) && x2>=(x1-playerW) &&
                        y2<=(y1+(playerH/2)) && y2>=(y1-(playerH/2)) -> True
                    | otherwise -> False


 
{-----------}
{- signals -}
{-----------}
            
-- gives a signal every so seconds; this indicates the speed of the players
heartbeat : Signal Time
heartbeat = every (second/100)

-- gives a signal whenever a key that matters is pressed
keybInput : Signal KeybInput
keybInput = 
    let realInput = lift5 KeybInput (lift (.x) Keyboard.arrows) (lift (.y) Keyboard.arrows) (lift (.x) Keyboard.wasd) (lift (.y) Keyboard.wasd) Keyboard.space
    in let sampledInput = sampleOn heartbeat realInput
        in lift (Debug.watch "keybInput") sampledInput