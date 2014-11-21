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
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Keyboard = Elm.Keyboard.make(_elm),
   $Mouse = Elm.Mouse.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Text = Elm.Text.make(_elm);
   var plusIf = F2(function (cond,
   prevVal) {
      return cond ? prevVal + 1 : prevVal;
   });
   var spaces = $Keyboard.space;
   var spaceCount = A3($Signal.foldp,
   plusIf,
   0,
   spaces);
   var clicks = $Mouse.isDown;
   var clickCount = A3($Signal.foldp,
   plusIf,
   0,
   clicks);
   var combined = A2($Signal.merge,
   clicks,
   spaces);
   var combinedCount = A3($Signal.foldp,
   plusIf,
   0,
   combined);
   var main = A2($Signal.lift,
   $Text.asText,
   combinedCount);
   _elm.Main.values = {_op: _op
                      ,clicks: clicks
                      ,clickCount: clickCount
                      ,spaces: spaces
                      ,spaceCount: spaceCount
                      ,combined: combined
                      ,combinedCount: combinedCount
                      ,main: main
                      ,plusIf: plusIf};
   return _elm.Main.values;
};