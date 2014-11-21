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
   $Signal = Elm.Signal.make(_elm),
   $Text = Elm.Text.make(_elm),
   $Time = Elm.Time.make(_elm);
   var toElem = function (time) {
      return A2($Graphics$Element.beside,
      $Text.plainText("Time: "),
      $Text.asText(time));
   };
   var time = $Time.every($Time.second);
   var main = A2($Signal.lift,
   toElem,
   time);
   _elm.Main.values = {_op: _op
                      ,time: time
                      ,main: main
                      ,toElem: toElem};
   return _elm.Main.values;
};