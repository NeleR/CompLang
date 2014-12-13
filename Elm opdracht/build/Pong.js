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
   $Keyboard = Elm.Keyboard.make(_elm),
   $List = Elm.List.make(_elm),
   $Signal = Elm.Signal.make(_elm),
   $Text = Elm.Text.make(_elm),
   $Time = Elm.Time.make(_elm);
   var sq = function (x) {
      return x * x;
   };
   var distsq = F2(function (_v0,
   _v1) {
      return function () {
         switch (_v1.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v0.ctor)
                 {case "_Tuple2":
                    return sq(_v0._0 - _v1._0) + sq(_v0._1 - _v1._1);}
                 _E.Case($moduleName,
                 "on line 53, column 26 to 48");
              }();}
         _E.Case($moduleName,
         "on line 53, column 26 to 48");
      }();
   });
   var distsqPaddle = F2(function (_v8,
   _v9) {
      return function () {
         switch (_v9.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v8.ctor)
                 {case "_Tuple2":
                    return _U.cmp(_v9._1,
                      _v8._1 + 20) > -1 ? A2(distsq,
                      {ctor: "_Tuple2"
                      ,_0: _v8._0
                      ,_1: _v8._1 + 20},
                      {ctor: "_Tuple2"
                      ,_0: _v9._0
                      ,_1: _v9._1}) : _U.cmp(_v9._1,
                      _v8._1 - 20) < 1 ? A2(distsq,
                      {ctor: "_Tuple2"
                      ,_0: _v8._0
                      ,_1: _v8._1 - 20},
                      {ctor: "_Tuple2"
                      ,_0: _v9._0
                      ,_1: _v9._1}) : A2(distsq,
                      {ctor: "_Tuple2"
                      ,_0: 185
                      ,_1: _v9._1},
                      {ctor: "_Tuple2"
                      ,_0: $Basics.abs(_v9._0)
                      ,_1: _v9._1});}
                 _E.Case($moduleName,
                 "between lines 57 and 59");
              }();}
         _E.Case($moduleName,
         "between lines 57 and 59");
      }();
   });
   var showGameState = function (gs) {
      return function () {
         var paddle = A2($Graphics$Collage.filled,
         $Color.white,
         A2($Graphics$Collage.rect,
         10,
         40));
         var elements = function () {
            switch (gs.ctor)
            {case "Ended":
               return _L.fromArray([$Graphics$Collage.toForm($Text.centered(A2($Text.color,
                 $Color.white,
                 $Text.toText("Not playing"))))]);
               case "Playing":
               switch (gs._0.ctor)
                 {case "BallState":
                    return _L.fromArray([A2($Graphics$Collage.move,
                                        {ctor: "_Tuple2"
                                        ,_0: -190
                                        ,_1: gs._1},
                                        paddle)
                                        ,A2($Graphics$Collage.move,
                                        {ctor: "_Tuple2"
                                        ,_0: 190
                                        ,_1: gs._2},
                                        paddle)
                                        ,A2($Graphics$Collage.move,
                                        gs._0._0,
                                        A2($Graphics$Collage.filled,
                                        $Color.white,
                                        A2($Graphics$Collage.oval,
                                        15,
                                        15)))]);}
                 break;}
            _E.Case($moduleName,
            "between lines 35 and 42");
         }();
         var forms = _L.append(_L.fromArray([A2($Graphics$Collage.filled,
         $Color.black,
         A2($Graphics$Collage.rect,
         400,
         400))]),
         elements);
         return A3($Graphics$Collage.collage,
         400,
         400,
         forms);
      }();
   };
   var heartbeat = $Time.every($Time.second / 20);
   var KeybInput = F3(function (a,
   b,
   c) {
      return {ctor: "KeybInput"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var keybInput = function () {
      var realInput = A4($Signal.lift3,
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
      var sampledInput = A2($Signal.sampleOn,
      heartbeat,
      realInput);
      return A2($Signal.lift,
      $Debug.watch("keybInput"),
      sampledInput);
   }();
   var Ended = {ctor: "Ended"};
   var Playing = F3(function (a,
   b,
   c) {
      return {ctor: "Playing"
             ,_0: a
             ,_1: b
             ,_2: c};
   });
   var BallState = F2(function (a,
   b) {
      return {ctor: "BallState"
             ,_0: a
             ,_1: b};
   });
   var initialGameState = function () {
      var initialBallState = A2(BallState,
      {ctor: "_Tuple2",_0: 0,_1: 0},
      {ctor: "_Tuple2",_0: 2,_1: 1});
      return A3(Playing,
      initialBallState,
      0,
      0);
   }();
   var bounceVertically = function (_v22) {
      return function () {
         switch (_v22.ctor)
         {case "BallState":
            switch (_v22._0.ctor)
              {case "_Tuple2":
                 switch (_v22._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           var origState = A2(BallState,
                           {ctor: "_Tuple2"
                           ,_0: _v22._0._0
                           ,_1: _v22._0._1},
                           {ctor: "_Tuple2"
                           ,_0: _v22._1._0
                           ,_1: _v22._1._1});
                           var bouncedState = A2(BallState,
                           {ctor: "_Tuple2"
                           ,_0: _v22._0._0
                           ,_1: _v22._0._1},
                           {ctor: "_Tuple2"
                           ,_0: _v22._1._0
                           ,_1: 0 - _v22._1._1});
                           return _U.cmp($Basics.abs(_v22._0._1),
                           192) > -1 ? bouncedState : origState;
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "between lines 46 and 48");
      }();
   };
   var bounceOnPaddles = F3(function (paddlePos1,
   paddlePos2,
   _v30) {
      return function () {
         switch (_v30.ctor)
         {case "BallState":
            switch (_v30._0.ctor)
              {case "_Tuple2":
                 switch (_v30._1.ctor)
                   {case "_Tuple2":
                      return function () {
                           var origState = A2(BallState,
                           {ctor: "_Tuple2"
                           ,_0: _v30._0._0
                           ,_1: _v30._0._1},
                           {ctor: "_Tuple2"
                           ,_0: _v30._1._0
                           ,_1: _v30._1._1});
                           var bouncedState = A2(BallState,
                           {ctor: "_Tuple2"
                           ,_0: _v30._0._0
                           ,_1: _v30._0._1},
                           {ctor: "_Tuple2"
                           ,_0: 0 - _v30._1._0
                           ,_1: _v30._1._1});
                           return _U.cmp(_v30._1._0,
                           0) < 0 && _U.cmp(A2(distsqPaddle,
                           {ctor: "_Tuple2"
                           ,_0: -185
                           ,_1: paddlePos1},
                           {ctor: "_Tuple2"
                           ,_0: _v30._0._0
                           ,_1: _v30._0._1}),
                           50) < 1 ? bouncedState : _U.cmp(_v30._1._0,
                           0) > 0 && _U.cmp(A2(distsqPaddle,
                           {ctor: "_Tuple2"
                           ,_0: 185
                           ,_1: paddlePos2},
                           {ctor: "_Tuple2"
                           ,_0: _v30._0._0
                           ,_1: _v30._0._1}),
                           50) < 1 ? bouncedState : origState;
                        }();}
                   break;}
              break;}
         _E.Case($moduleName,
         "between lines 63 and 68");
      }();
   });
   var addPosVel = F2(function (_v38,
   _v39) {
      return function () {
         switch (_v39.ctor)
         {case "_Tuple2":
            return function () {
                 switch (_v38.ctor)
                 {case "_Tuple2":
                    return {ctor: "_Tuple2"
                           ,_0: _v38._0 + _v39._0
                           ,_1: _v38._1 + _v39._1};}
                 _E.Case($moduleName,
                 "on line 9, column 28 to 38");
              }();}
         _E.Case($moduleName,
         "on line 9, column 28 to 38");
      }();
   });
   var step = F2(function (_v46,
   gs) {
      return function () {
         switch (_v46.ctor)
         {case "KeybInput":
            return function () {
                 var outOfBounds = function (_v51) {
                    return function () {
                       switch (_v51.ctor)
                       {case "BallState":
                          switch (_v51._0.ctor)
                            {case "_Tuple2":
                               return _U.cmp($Basics.abs(_v51._0._0),
                                 200) > -1;}
                            break;}
                       _E.Case($moduleName,
                       "on line 76, column 45 to 59");
                    }();
                 };
                 var applySpeed = function (bs) {
                    return function () {
                       switch (bs.ctor)
                       {case "BallState":
                          return A2(BallState,
                            A2(addPosVel,bs._0,bs._1),
                            bs._1);}
                       _E.Case($moduleName,
                       "between lines 73 and 76");
                    }();
                 };
                 var bound = A2($Basics.clamp,
                 -180,
                 180);
                 return function () {
                    switch (gs.ctor)
                    {case "Ended":
                       return _v46._2 ? initialGameState : Ended;
                       case "Playing":
                       return outOfBounds(gs._0) ? Ended : A3(Playing,
                         A3(bounceOnPaddles,
                         gs._1,
                         gs._2,
                         bounceVertically(applySpeed(gs._0))),
                         bound(gs._1 + 5 * $Basics.toFloat(_v46._0)),
                         bound(gs._2 + 5 * $Basics.toFloat(_v46._1)));}
                    _E.Case($moduleName,
                    "between lines 77 and 82");
                 }();
              }();}
         _E.Case($moduleName,
         "between lines 72 and 82");
      }();
   });
   var gameState = A2($Signal.lift,
   $Debug.watch("Game state"),
   A3($Signal.foldp,
   step,
   Ended,
   keybInput));
   var main = A2($Signal.lift,
   showGameState,
   gameState);
   _elm.Main.values = {_op: _op
                      ,addPosVel: addPosVel
                      ,BallState: BallState
                      ,Playing: Playing
                      ,Ended: Ended
                      ,KeybInput: KeybInput
                      ,heartbeat: heartbeat
                      ,keybInput: keybInput
                      ,initialGameState: initialGameState
                      ,showGameState: showGameState
                      ,bounceVertically: bounceVertically
                      ,sq: sq
                      ,distsq: distsq
                      ,distsqPaddle: distsqPaddle
                      ,bounceOnPaddles: bounceOnPaddles
                      ,step: step
                      ,gameState: gameState
                      ,main: main};
   return _elm.Main.values;
};