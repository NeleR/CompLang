import Text
import Keyboard
import Debug

type Pos = (Float, Float)
type Vel = Pos

addPosVel : Pos -> Vel -> Pos
addPosVel (x,y) (dx,dy) = (x+dx, y+dy)

data BallState = BallState Pos Vel
data GameState = Playing BallState Float Float
               | Ended

data KeybInput = KeybInput Int Int Bool


heartbeat = every (second/20)

keybInput : Signal KeybInput
keybInput =
    let realInput = lift3 KeybInput (lift (.y) Keyboard.arrows) (lift (.y) Keyboard.wasd) Keyboard.space
        sampledInput = sampleOn heartbeat realInput
    in lift (Debug.watch "keybInput") sampledInput

initialGameState : GameState
initialGameState =
    let initialBallState = BallState (0,0) (2,1)
    in Playing initialBallState 0 0

showGameState : GameState -> Element
showGameState gs =
    let paddle = filled white (rect 10 40)
        forms = [filled black (rect 400 400)] ++ elements
        elements = case gs of
                     Ended -> [toForm (centered (Text.color white (toText "Not playing")))]
                     (Playing (BallState pos _) pd1 pd2) ->
                         [ move (-190,pd1) paddle
                         , move (190,pd2) paddle
                         , move pos (filled white (oval 15 15))
                         ]
    in collage 400 400 forms

bounceVertically : BallState -> BallState
bounceVertically (BallState (bpx,bpy) (bvx,bvy)) =
  let bouncedState = BallState (bpx,bpy) (bvx,-bvy)
      origState = BallState (bpx,bpy) (bvx,bvy)
  in if abs bpy >= 192 then bouncedState else origState

sq x = x * x

distsq : Pos -> Pos -> Float
distsq (x1,y1) (x2,y2) = sq (x1-x2) + sq (y1-y2)

distsqPaddle : Pos -> Pos -> Float
distsqPaddle (paddlex,paddley) (x,y) =
  if y >= paddley + 20 then distsq (paddlex,paddley+20) (x,y)
  else if y <= paddley - 20 then distsq (paddlex,paddley-20) (x, y)
  else distsq (185,y) (abs x, y)

bounceOnPaddles : Float -> Float -> BallState -> BallState
bounceOnPaddles paddlePos1 paddlePos2 (BallState (bpx,bpy) (bvx,bvy)) =
  let bouncedState = BallState (bpx,bpy) (-bvx,bvy)
      origState = BallState (bpx,bpy) (bvx,bvy)
  in
  if bvx < 0 && distsqPaddle (-185,paddlePos1) (bpx,bpy) <= 50 then bouncedState
  else if bvx > 0 && distsqPaddle (185, paddlePos2) (bpx,bpy) <= 50 then bouncedState
  else origState

step : KeybInput -> GameState -> GameState
step (KeybInput d1 d2 space) gs =
    let bound = clamp -180 180
        applySpeed bs = case bs of
                          BallState pos vel ->
                              BallState (addPosVel pos vel) vel
        outOfBounds (BallState (bpx,_) _) = abs bpx >= 200
    in case gs of
         Ended -> if space then initialGameState else Ended
         Playing bs pd1 pd2 -> if outOfBounds bs then Ended else
             Playing (bounceOnPaddles pd1 pd2 (bounceVertically (applySpeed bs)))
                         (bound (pd1 + 5*toFloat d1))
                         (bound (pd2 + 5*toFloat d2))


gameState : Signal GameState
gameState = lift (Debug.watch "Game state")
            (foldp step Ended keybInput)

main = lift showGameState gameState

