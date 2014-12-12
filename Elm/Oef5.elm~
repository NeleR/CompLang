-- Modify main below, so that it draws a little person
-- figure. Use the functions from the Collage module to construct
-- Forms (circles, n-gons, lines etc.) to include in the collage.
-- You can find documentation here:
--    http://library.elm-lang.org/catalog/elm-lang-Elm/0.13/Graphics-Collage

main : Signal Element
main = constant (collage 400 400 [
                    filled black (rect 400 400),
                    move (0,85) (filled white (oval 50 50)),
                    move (0,00) (filled white (rect 50 100)),
                    rotate (degrees -40) (move (-49,11) (filled white (rect 15 90))),
                    rotate (degrees 40) (move (49,11) (filled white (rect 15 90))),
                    rotate (degrees -15) (move (-30,-100) (filled white (rect 22 120))),
                    rotate (degrees 15) (move (30,-100) (filled white (rect 22 120)))
                ])
