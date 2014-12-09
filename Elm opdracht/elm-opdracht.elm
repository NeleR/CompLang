import Color
import Keyboard

-- default values
width = 1024
height = 768

playerW = 64
playerH = 16

tailWidth = 2

color1 = Color.lightBlue
color2 = Color.orange

type Position = (Float,Float)
type Tail = [(Float, Float)]
data Orientation = N | E | S | W

data PlayerState = PlayerState Position Orientation Tail
data GameState = Playing PlayerState PlayerState
               | Ended | Started
               
data KeybInput = KeybInput Int Int Bool

-- example use: showPlayer' Color.lightBlue (10, 10) N
showPlayer' : Color -> Position -> Orientation -> Form
showPlayer' color (x,y) o =
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
main = showState (step keybInput Started)

keybInput : Signal KeybInput
keybInput = lift3 KeybInput (lift (.y) Keyboard.arrows) (lift (.y) Keyboard.wasd) Keyboard.space

showState : GameState -> Signal Element
showState state
    = case state of
            Started -> constant <| plainText "Press space to start a new game"
            Ended -> constant <| plainText "Player _ has won!"
            Playing player1 player2 -> showPlayingState player1 player2
                        
step : KeybInput -> GameState -> GameState
step (KeybInput d1 d2 space) state
    = case state of
            Started -> if space then initialPlayingState else Started
            Ended -> if space then initialPlayingState else Ended
            Playing player1 player2 -> if space then initialPlayingState else Playing player1 player2
            
          gameState : Signal GameState
gameState = lift (Debug.watch "Game state")
            (foldp step Ended keybInput)
                        
initialPlayingState : GameState
initialPlayingState =
    let initialPlayer1 = PlayerState (-1000,0) E []
    in let initialPlayer2 = PlayerState (1000,0) E []
        in Playing initialPlayer1 initialPlayer2

showPlayingState : PlayerState -> PlayerState -> Signal Element
showPlayingState (PlayerState (x1,y1) o1 t1) (PlayerState (x2,y2) o2 t2)
        = constant (collage width height [
                                            filled black (rect width height), -- playing field
                                            showPlayer' color1 (x1, y1) o1, -- player 1
                                            showPlayer' color2 (x2, y2) o2, -- player 2
                                            showTail color1 t1, -- tail player 1
                                            showTail color2 t2 -- tail player 2
                                         ])

                    
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