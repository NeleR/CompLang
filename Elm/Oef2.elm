-- Write a program that shows three text fields, arranged vertically.
-- The first shows the current mouse position and True or False
-- depending on whether the left mouse button is currently down. The
-- second text box is shown below the first and shows True or False
-- depending on whether or not the space bar is down. Finally, the
-- third text field shows the current value of Keyboard.arrows. Play
-- with the resulting program so that you understand the behaviour of
-- all these input signals.

import Mouse
import Keyboard

main : Signal Element
main = lift3 stack mouseP spaceD arrowV

stack : Element -> Element -> Element -> Element
stack a b c = above a (above b c)

mouseP : Signal Element
mouseP = lift2 beside (lift asText Mouse.position) (lift asText Mouse.isDown)

spaceD : Signal Element
spaceD = lift asText Keyboard.space

arrowV : Signal Element
arrowV = lift asText Keyboard.arrows
