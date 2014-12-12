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
   $Signal = Elm.Signal.make(_elm),
   $Text = Elm.Text.make(_elm);
   var main = $Signal.constant($Text.plainText("implement me"));
   var tailWidth = 2;
   var showTail = F2(function (color,
   positions) {
      return A2($Graphics$Collage.traced,
      _U.replace([["width",tailWidth]
                 ,["color",color]],
      $Graphics$Collage.defaultLine),
      $Graphics$Collage.path(positions));
   });
   var W = {ctor: "W"};
   var S = {ctor: "S"};
   var E = {ctor: "E"};
   var N = {ctor: "N"};
   var playerH = 16;
   var playerW = 64;
   var showPlayer$ = F3(function (color,
   _v0,
   o) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return function () {
                 var fw = $Basics.toFloat(playerW);
                 var $ = function () {
                    switch (o.ctor)
                    {case "E":
                       return {ctor: "_Tuple3"
                              ,_0: fw / 2
                              ,_1: 0
                              ,_2: 0};
                       case "N":
                       return {ctor: "_Tuple3"
                              ,_0: 0
                              ,_1: fw / 2
                              ,_2: 90};
                       case "S":
                       return {ctor: "_Tuple3"
                              ,_0: 0
                              ,_1: (0 - fw) / 2
                              ,_2: -90};
                       case "W":
                       return {ctor: "_Tuple3"
                              ,_0: (0 - fw) / 2
                              ,_1: 0
                              ,_2: 180};}
                    _E.Case($moduleName,
                    "between lines 15 and 20");
                 }(),
                 xOffset = $._0,
                 yOffset = $._1,
                 degs = $._2;
                 return $Graphics$Collage.rotate($Basics.degrees(degs))($Graphics$Collage.move({ctor: "_Tuple2"
                                                                                               ,_0: xOffset
                                                                                               ,_1: yOffset})($Graphics$Collage.move({ctor: "_Tuple2"
                                                                                                                                     ,_0: _v0._0
                                                                                                                                     ,_1: _v0._1})($Graphics$Collage.outlined($Graphics$Collage.solid(color))(A2($Graphics$Collage.rect,
                 fw,
                 $Basics.toFloat(playerH))))));
              }();}
         _E.Case($moduleName,
         "between lines 14 and 24");
      }();
   });
   var height = 768;
   var width = 1024;
   _elm.Main.values = {_op: _op
                      ,width: width
                      ,height: height
                      ,playerW: playerW
                      ,playerH: playerH
                      ,N: N
                      ,E: E
                      ,S: S
                      ,W: W
                      ,showPlayer$: showPlayer$
                      ,tailWidth: tailWidth
                      ,showTail: showTail
                      ,main: main};
   return _elm.Main.values;
};