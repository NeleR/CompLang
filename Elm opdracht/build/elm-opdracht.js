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
   $Text = Elm.Text.make(_elm),
   $Time = Elm.Time.make(_elm);
   var heartbeat = $Time.every($Time.second / 50);
   var KeybInput = F5(function (a,
   b,
   c,
   d,
   e) {
      return {ctor: "KeybInput"
             ,_0: a
             ,_1: b
             ,_2: c
             ,_3: d
             ,_4: e};
   });
   var keybInput = A6($Signal.lift5,
   KeybInput,
   A2($Signal.lift,
   function (_) {
      return _.x;
   },
   $Keyboard.arrows),
   A2($Signal.lift,
   function (_) {
      return _.y;
   },
   $Keyboard.arrows),
   A2($Signal.lift,
   function (_) {
      return _.x;
   },
   $Keyboard.wasd),
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
   var proceed = function (_v0) {
      return function () {
         switch (_v0.ctor)
         {case "PlayerState":
            switch (_v0._0.ctor)
              {case "_Tuple2":
                 return function () {
                      switch (_v0._1.ctor)
                      {case "E":
                         return A3(PlayerState,
                           {ctor: "_Tuple2"
                           ,_0: _v0._0._0 - 1
                           ,_1: _v0._0._1},
                           _v0._1,
                           _v0._2);
                         case "N": return A3(PlayerState,
                           {ctor: "_Tuple2"
                           ,_0: _v0._0._0
                           ,_1: _v0._0._1 - 1},
                           _v0._1,
                           _v0._2);
                         case "S": return A3(PlayerState,
                           {ctor: "_Tuple2"
                           ,_0: _v0._0._0
                           ,_1: _v0._0._1 + 1},
                           _v0._1,
                           _v0._2);
                         case "W": return A3(PlayerState,
                           {ctor: "_Tuple2"
                           ,_0: _v0._0._0 + 1
                           ,_1: _v0._0._1},
                           _v0._1,
                           _v0._2);}
                      _E.Case($moduleName,
                      "between lines 98 and 117");
                   }();}
              break;}
         _E.Case($moduleName,
         "between lines 98 and 117");
      }();
   };
   var W = {ctor: "W"};
   var S = {ctor: "S"};
   var E = {ctor: "E"};
   var changeXDir = F2(function (d,
   _v8) {
      return function () {
         switch (_v8.ctor)
         {case "PlayerState":
            return _U.eq(d,
              1) ? A3(PlayerState,
              _v8._0,
              E,
              _v8._2) : _U.eq(d,
              -1) ? A3(PlayerState,
              _v8._0,
              W,
              _v8._2) : A3(PlayerState,
              _v8._0,
              _v8._1,
              _v8._2);}
         _E.Case($moduleName,
         "between lines 86 and 88");
      }();
   });
   var N = {ctor: "N"};
   var changeYDir = F2(function (d,
   _v13) {
      return function () {
         switch (_v13.ctor)
         {case "PlayerState":
            return _U.eq(d,
              1) ? A3(PlayerState,
              _v13._0,
              N,
              _v13._2) : _U.eq(d,
              -1) ? A3(PlayerState,
              _v13._0,
              S,
              _v13._2) : A3(PlayerState,
              _v13._0,
              _v13._1,
              _v13._2);}
         _E.Case($moduleName,
         "between lines 92 and 94");
      }();
   });
   var color2 = $Color.lightBlue;
   var color1 = $Color.orange;
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
   _v18,
   o) {
      return function () {
         switch (_v18.ctor)
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
                                                                                                                                     ,_0: _v18._0
                                                                                                                                     ,_1: _v18._1})($Graphics$Collage.outlined($Graphics$Collage.solid(color))(A2($Graphics$Collage.rect,
                 fw,
                 $Basics.toFloat(playerH))))));
              }();}
         _E.Case($moduleName,
         "between lines 29 and 39");
      }();
   });
   var height = 768;
   var width = 1024;
   var initialPlayingState = function () {
      var position1 = width / 2 - 50 - playerW;
      var position2 = 0 - width / 2 + 50 + playerW;
      var initialPlayer1 = A3(PlayerState,
      {ctor: "_Tuple2"
      ,_0: position1
      ,_1: 0},
      E,
      _L.fromArray([]));
      var initialPlayer2 = A3(PlayerState,
      {ctor: "_Tuple2"
      ,_0: position2
      ,_1: 0},
      W,
      _L.fromArray([]));
      return A2(Playing,
      initialPlayer1,
      initialPlayer2);
   }();
   var step = F2(function (_v23,
   state) {
      return function () {
         switch (_v23.ctor)
         {case "KeybInput":
            return function () {
                 switch (state.ctor)
                 {case "Ended":
                    return _v23._4 ? initialPlayingState : Ended;
                    case "Playing":
                    return _v23._4 ? initialPlayingState : A2(Playing,
                      proceed(state._0),
                      proceed(state._1));
                    case "Started":
                    return _v23._4 ? initialPlayingState : Started;}
                 _E.Case($moduleName,
                 "between lines 68 and 84");
              }();}
         _E.Case($moduleName,
         "between lines 68 and 84");
      }();
   });
   var gameState = A3($Signal.foldp,
   step,
   Started,
   keybInput);
   var showPlayingState = F2(function (_v33,
   _v34) {
      return function () {
         switch (_v34.ctor)
         {case "PlayerState":
            switch (_v34._0.ctor)
              {case "_Tuple2":
                 return function () {
                      switch (_v33.ctor)
                      {case "PlayerState":
                         switch (_v33._0.ctor)
                           {case "_Tuple2":
                              return A3($Graphics$Collage.collage,
                                width,
                                height,
                                _L.fromArray([A2($Graphics$Collage.filled,
                                             $Color.black,
                                             A2($Graphics$Collage.rect,
                                             width,
                                             height))
                                             ,A2($Graphics$Collage.move,
                                             {ctor: "_Tuple2",_0: 0,_1: 2},
                                             A3(showPlayer$,
                                             color1,
                                             {ctor: "_Tuple2"
                                             ,_0: _v33._0._0
                                             ,_1: _v33._0._1},
                                             _v33._1))
                                             ,A3(showPlayer$,
                                             color2,
                                             {ctor: "_Tuple2"
                                             ,_0: _v34._0._0
                                             ,_1: _v34._0._1},
                                             _v34._1)
                                             ,A2(showTail,color1,_v33._2)
                                             ,A2(showTail,
                                             color2,
                                             _v34._2)]));}
                           break;}
                      _E.Case($moduleName,
                      "between lines 131 and 137");
                   }();}
              break;}
         _E.Case($moduleName,
         "between lines 131 and 137");
      }();
   });
   var showState = function (state) {
      return function () {
         switch (state.ctor)
         {case "Ended":
            return $Text.plainText("Player _ has won!");
            case "Playing":
            return A2(showPlayingState,
              state._0,
              state._1);
            case "Started":
            return $Text.plainText("Press space to start a new game");}
         _E.Case($moduleName,
         "between lines 61 and 65");
      }();
   };
   var main = A2($Signal.lift,
   showState,
   gameState);
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
                      ,heartbeat: heartbeat
                      ,keybInput: keybInput
                      ,showState: showState
                      ,step: step
                      ,changeXDir: changeXDir
                      ,changeYDir: changeYDir
                      ,proceed: proceed
                      ,gameState: gameState
                      ,initialPlayingState: initialPlayingState
                      ,showPlayingState: showPlayingState};
   return _elm.Main.values;
};