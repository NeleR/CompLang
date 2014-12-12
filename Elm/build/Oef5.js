Elm.Main = Elm.Main || {};
Elm.Main.make = function (_elm) {
   "use strict";
   _elm.Main = _elm.Main || {};
   if (_elm.Main.values)
   return _elm.Main.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Main",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var main = $Signal.constant(A3($Graphics$Collage.collage,
   400,
   400,
   _L.fromArray([A2($Graphics$Collage.filled,
                $Color.black,
                A2($Graphics$Collage.rect,
                400,
                400))
                ,A2($Graphics$Collage.move,
                {ctor: "_Tuple2",_0: 0,_1: 85},
                A2($Graphics$Collage.filled,
                $Color.white,
                A2($Graphics$Collage.oval,
                50,
                50)))
                ,A2($Graphics$Collage.move,
                {ctor: "_Tuple2",_0: 0,_1: 0},
                A2($Graphics$Collage.filled,
                $Color.white,
                A2($Graphics$Collage.rect,
                50,
                100)))
                ,A2($Graphics$Collage.rotate,
                $Basics.degrees(-40),
                A2($Graphics$Collage.move,
                {ctor: "_Tuple2"
                ,_0: -49
                ,_1: 11},
                A2($Graphics$Collage.filled,
                $Color.white,
                A2($Graphics$Collage.rect,
                15,
                90))))
                ,A2($Graphics$Collage.rotate,
                $Basics.degrees(40),
                A2($Graphics$Collage.move,
                {ctor: "_Tuple2",_0: 49,_1: 11},
                A2($Graphics$Collage.filled,
                $Color.white,
                A2($Graphics$Collage.rect,
                15,
                90))))
                ,A2($Graphics$Collage.rotate,
                $Basics.degrees(-15),
                A2($Graphics$Collage.move,
                {ctor: "_Tuple2"
                ,_0: -30
                ,_1: -100},
                A2($Graphics$Collage.filled,
                $Color.white,
                A2($Graphics$Collage.rect,
                22,
                120))))
                ,A2($Graphics$Collage.rotate,
                $Basics.degrees(15),
                A2($Graphics$Collage.move,
                {ctor: "_Tuple2"
                ,_0: 30
                ,_1: -100},
                A2($Graphics$Collage.filled,
                $Color.white,
                A2($Graphics$Collage.rect,
                22,
                120))))])));
   _elm.Main.values = {_op: _op
                      ,main: main};
   return _elm.Main.values;
};