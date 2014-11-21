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
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Keyboard = Elm.Keyboard.make(_elm),
   $Mouse = Elm.Mouse.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Text = Elm.Text.make(_elm);
   var arrowV = A2($Signal.lift,
   $Text.asText,
   $Keyboard.arrows);
   var spaceD = A2($Signal.lift,
   $Text.asText,
   $Keyboard.space);
   var mouseP = A3($Signal.lift2,
   $Graphics$Element.beside,
   A2($Signal.lift,
   $Text.asText,
   $Mouse.position),
   A2($Signal.lift,
   $Text.asText,
   $Mouse.isDown));
   var stack = F3(function (a,
   b,
   c) {
      return A2($Graphics$Element.above,
      a,
      A2($Graphics$Element.above,
      b,
      c));
   });
   var main = A4($Signal.lift3,
   stack,
   mouseP,
   spaceD,
   arrowV);
   _elm.Main.values = {_op: _op
                      ,main: main
                      ,stack: stack
                      ,mouseP: mouseP
                      ,spaceD: spaceD
                      ,arrowV: arrowV};
   return _elm.Main.values;
};