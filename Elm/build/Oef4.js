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
   $Debug = Elm.Debug.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Time = Elm.Time.make(_elm);
   var showState = function (_v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return A3($Graphics$Collage.collage,
              400,
              400,
              _L.fromArray([A2($Graphics$Collage.filled,
                           $Color.black,
                           A2($Graphics$Collage.rect,
                           400,
                           400))
                           ,A2($Graphics$Collage.move,
                           {ctor: "_Tuple2"
                           ,_0: 0
                           ,_1: $Basics.toFloat(A2($Debug.watch,
                           "Position: ",
                           _v0._0)) / 2},
                           A2($Graphics$Collage.filled,
                           $Color.white,
                           A2($Graphics$Collage.oval,
                           15,
                           15)))]));}
         _E.Case($moduleName,
         "between lines 19 and 22");
      }();
   };
   var update = function (_v4) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2":
            return _U.cmp(_v4._0,
              0) < 1 ? {ctor: "_Tuple2"
                       ,_0: _v4._0 - _v4._1
                       ,_1: 20} : {ctor: "_Tuple2"
                                  ,_0: _v4._0 + _v4._1
                                  ,_1: _v4._1 - 1};}
         _E.Case($moduleName,
         "between lines 15 and 16");
      }();
   };
   var heartbeat = A2($Signal.lift,
   function (x) {
      return A2($Debug.watch,
      "Tijd: ",
      x);
   },
   $Time.every($Time.second / 50));
   var state = A3($Signal.foldp,
   F2(function (_v8,s) {
      return function () {
         return update(s);
      }();
   }),
   {ctor: "_Tuple2",_0: 21,_1: 20},
   heartbeat);
   var main = A2($Signal.lift,
   showState,
   state);
   _elm.Main.values = {_op: _op
                      ,heartbeat: heartbeat
                      ,update: update
                      ,showState: showState
                      ,state: state
                      ,main: main};
   return _elm.Main.values;
};