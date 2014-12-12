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
   $Keyboard = Elm.Keyboard.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Text = Elm.Text.make(_elm);
   var KeybInput = F3(function (a,
   b,
   c) {
      return {ctor: "KeybInput"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var keybInput = A4($Signal.lift3,
   KeybInput,
   A2($Signal.lift,
   function (_) {
      return _.y;
   },
   $Keyboard.arrows),
   A2($Signal.lift,
   function (_) {
      return _.y;
   },
   $Keyboard.wasd),
   $Keyboard.space);
   var Started = {ctor: "Started"};
   var Ended = {ctor: "Ended"};
   var Playing = F2(function (a,
   b) {
      return {ctor: "Playing"
             ,_0: a
             ,_1: b};
   });
   var PlayerState = F3(function (a,
   b,
   c) {
      return {ctor: "PlayerState"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var W = {ctor: "W"};
   var S = {ctor: "S"};
   var E = {ctor: "E"};
   var initialPlayingState = function () {
      var initialPlayer1 = A3(PlayerState,
      {ctor: "_Tuple2"
      ,_0: -1000
      ,_1: 0},
      E,
      _L.fromArray([]));
      var initialPlayer2 = A3(PlayerState,
      {ctor: "_Tuple2"
      ,_0: 1000
      ,_1: 0},
      E,
      _L.fromArray([]));
      return A2(Playing,
      initialPlayer1,
      initialPlayer2);
   }();
   var step = F2(function (_v0,
   state) {
      return function () {
         switch (_v0.ctor)
         {case "KeybInput":
            return function () {
                 switch (state.ctor)
                 {case "Ended":
                    return _v0._2 ? initialPlayingState : Ended;
                    case "Playing":
                    return _v0._2 ? initialPlayingState : A2(Playing,
                      state._0,
                      state._1);
                    case "Started":
                    return _v0._2 ? initialPlayingState : Started;}
                 _E.Case($moduleName,
                 "between lines 68 and 72");
              }();}
         _E.Case($moduleName,
         "between lines 68 and 72");
      }();
   });
   var N = {ctor: "N"};
   var color2 = $Color.orange;
   var color1 = $Color.lightBlue;
   var tailWidth = 2;
   var showTail = F2(function (color,
   positions) {
      return A2($Graphics$Collage.traced,
      _U.replace([["width",tailWidth]
                 ,["color",color]],
      $Graphics$Collage.defaultLine),
      $Graphics$Collage.path(positions));
   });
   var playerH = 16;
   var playerW = 64;
   var showPlayer$ = F3(function (color,
   _v8,
   o) {
      return function () {
         switch (_v8.ctor)
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
                    "between lines 30 and 35");
                 }(),
                 xOffset = $._0,
                 yOffset = $._1,
                 degs = $._2;
                 return $Graphics$Collage.rotate($Basics.degrees(degs))($Graphics$Collage.move({ctor: "_Tuple2"
                                                                                               ,_0: xOffset
                                                                                               ,_1: yOffset})($Graphics$Collage.move({ctor: "_Tuple2"
                                                                                                                                     ,_0: _v8._0
                                                                                                                                     ,_1: _v8._1})($Graphics$Collage.outlined($Graphics$Collage.solid(color))(A2($Graphics$Collage.rect,
                 fw,
                 $Basics.toFloat(playerH))))));
              }();}
         _E.Case($moduleName,
         "between lines 29 and 39");
      }();
   });
   var height = 768;
   var width = 1024;
   var showPlayingState = F2(function (_v13,
   _v14) {
      return function () {
         switch (_v14.ctor)
         {case "PlayerState":
            switch (_v14._0.ctor)
              {case "_Tuple2":
                 return function () {
                      switch (_v13.ctor)
                      {case "PlayerState":
                         switch (_v13._0.ctor)
                           {case "_Tuple2":
                              return $Signal.constant(A3($Graphics$Collage.collage,
                                width,
                                height,
                                _L.fromArray([A2($Graphics$Collage.filled,
                                             $Color.black,
                                             A2($Graphics$Collage.rect,
                                             width,
                                             height))
                                             ,A3(showPlayer$,
                                             color1,
                                             {ctor: "_Tuple2"
                                             ,_0: _v13._0._0
                                             ,_1: _v13._0._1},
                                             _v13._1)
                                             ,A3(showPlayer$,
                                             color2,
                                             {ctor: "_Tuple2"
                                             ,_0: _v14._0._0
                                             ,_1: _v14._0._1},
                                             _v14._1)
                                             ,A2(showTail,color1,_v13._2)
                                             ,A2(showTail,
                                             color2,
                                             _v14._2)])));}
                           break;}
                      _E.Case($moduleName,
                      "between lines 81 and 87");
                   }();}
              break;}
         _E.Case($moduleName,
         "between lines 81 and 87");
      }();
   });
   var showState = function (state) {
      return function () {
         switch (state.ctor)
         {case "Ended":
            return $Signal.constant($Text.plainText("Player _ has won!"));
            case "Playing":
            return A2(showPlayingState,
              state._0,
              state._1);
            case "Started":
            return $Signal.constant($Text.plainText("Press space to start a new game"));}
         _E.Case($moduleName,
         "between lines 61 and 65");
      }();
   };
   var main = showState(Started);
   _elm.Main.values = {_op: _op
                      ,width: width
                      ,height: height
                      ,playerW: playerW
                      ,playerH: playerH
                      ,tailWidth: tailWidth
                      ,color1: color1
                      ,color2: color2
                      ,N: N
                      ,E: E
                      ,S: S
                      ,W: W
                      ,PlayerState: PlayerState
                      ,Playing: Playing
                      ,Ended: Ended
                      ,Started: Started
                      ,KeybInput: KeybInput
                      ,showPlayer$: showPlayer$
                      ,showTail: showTail
                      ,main: main
                      ,keybInput: keybInput
                      ,showState: showState
                      ,step: step
                      ,initialPlayingState: initialPlayingState
                      ,showPlayingState: showPlayingState};
   return _elm.Main.values;
};