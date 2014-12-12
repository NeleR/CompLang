-- Step 1: Change the below code so that it counts the number of user clicks.
-- Step 2: Change the code so that it counts the number of user clicks
--         and space bar presses.

import Mouse
import Keyboard

clicks : Signal Bool
clicks = Mouse.isDown

clickCount : Signal Int
clickCount = foldp plusIf 0 clicks

spaces : Signal Bool
spaces = Keyboard.space

spaceCount : Signal Int
spaceCount = foldp plusIf 0 spaces

combined : Signal Bool
combined = merge clicks spaces

combinedCount : Signal Int
combinedCount = foldp plusIf 0 combined

main : Signal Element
--main = lift asText clickCount 
--main = lift asText spaceCount
main = lift asText combinedCount

plusIf : Bool -> Int -> Int
plusIf cond prevVal = if cond then prevVal+1 else prevVal

