import Color
import Keyboard

-- default values
width = 1024
height = 768

playerW = 64
playerH = 16

tailWidth = 2

color1 = Color.orange -- starts right
color2 = Color.lightBlue -- starts left

type Position = (Float,Float)
type Tail = [(Float, Float)]
data Orientation = N | E | S | W

data PlayerState = PlayerState Position Orientation Tail
data GameState = Playing PlayerState PlayerState
               | Ended | Started
               
data KeybInput = KeybInput Int Int Int Int Bool

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
main = lift showState gameState

heartbeat = every (second/50)

keybInput : Signal KeybInput
keybInput = lift5 KeybInput (lift (.x) Keyboard.arrows) (lift (.y) Keyboard.arrows) (lift (.x) Keyboard.wasd) (lift (.y) Keyboard.wasd) Keyboard.space

showState : GameState -> Element
showState state
    = case state of
            Started -> plainText "Press space to start a new game"
            Ended -> plainText "Player _ has won!"
            Playing player1 player2 -> showPlayingState player1 player2
                        
step : KeybInput -> GameState -> GameState
step (KeybInput x1 y1 x2 y2 space) state
    = case state of
            Started -> if space then initialPlayingState else Started
            Ended -> if space then initialPlayingState else Ended
            Playing player1 player2 -> if   -- | not (x1 == 0) -> Playing (changeXDir x1 player1) player2
                                            -- | not (y1 == 0) -> Playing (changeYDir y1 player1) player2
                                            -- | not (x2 == 0) -> Playing player1 (changeXDir x2 player2)
                                            -- | not (y2 == 0) -> Playing player1 (changeYDir y2 player2)
                                            | space -> initialPlayingState
                                            -- crossing player1 player2 -> Ended 1
                                            -- crossing player2 player1 -> Ended 2
                                            | otherwise -> Playing (proceed player1) (proceed player2)
                                            
-- Playing bs pd1 pd2 -> if outOfBounds bs then Ended else
             -- Playing (bounceOnPaddles pd1 pd2 (bounceVertically (applySpeed bs)))
                         -- (bound (pd1 + 5*toFloat d1))
                         -- (bound (pd2 + 5*toFloat d2))
            
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
                            N -> PlayerState (x,(y-1)) o t
                            S -> PlayerState (x,(y+1)) o t
                            E -> PlayerState ((x-1),y) o t
                            W -> PlayerState ((x+1),y) o t
 
            -- step : KeybInput -> GameState -> GameState
-- step (KeybInput x1 y1 x2 y2 space) gs =
    -- let bound = clamp -180 180
        -- applySpeed bs = case bs of
                          -- BallState pos vel ->
                              -- BallState (addPosVel pos vel) vel
        -- outOfBounds (BallState (bpx,_) _) = abs bpx >= 200
    -- in case gs of
         -- Ended -> if space then initialGameState else Ended
         -- Playing bs pd1 pd2 -> if outOfBounds bs then Ended else
             -- Playing (bounceOnPaddles pd1 pd2 (bounceVertically (applySpeed bs)))
                         -- (bound (pd1 + 5*toFloat d1))
                         -- (bound (pd2 + 5*toFloat d2))
            
gameState : Signal GameState
gameState = foldp step Started keybInput
                        
initialPlayingState : GameState
initialPlayingState =
    let position1 = (width/2)-50-(playerW)
    in let position2 = -(width/2)+50+(playerW)
        in let initialPlayer1 = PlayerState (position1,0) E []
            in let initialPlayer2 = PlayerState (position2,0) W []
                in Playing initialPlayer1 initialPlayer2

showPlayingState : PlayerState -> PlayerState -> Element
showPlayingState (PlayerState (x1,y1) o1 t1) (PlayerState (x2,y2) o2 t2)
       = collage width height   [
                                filled black (rect width height), -- playing field
                                showPlayer' color1 (x1, y1) o1, -- player 1
                                showPlayer' color2 (x2, y2) o2, -- player 2
                                showTail color1 t1, -- tail player 1
                                showTail color2 t2 -- tail player 2
                                ]
                    
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