%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erlang Assignment - Comparative Programming Languages (2014-2015) %
% Nele Rober, r0262954                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(tile).
-import(string, [concat/2]).

-export([tilemain/1]).

tilemain( Id ) ->
	tilemain(Id, 0).

tilemain( Id, Value ) ->
	glob:registerName(glob:regformat(Id), self()),
	tilelife(Id,Value,false).


%%%%%%%%%%%%%%%%%
% fill this out %
%%%%%%%%%%%%%%%%%
tilelife(Id,Value,Merged)->
	receive
		die ->
			debug:debug("I, ~p, die.~n",[Id]),
			exit(killed);
		up ->
			debug:debug("I, ~p, go up.~n",[Id]),
			CannotGoUp = ((Value == 0) or atEdge(up,Id)),
			if 
				CannotGoUp -> noMerge(up,Id,Value);
				not CannotGoUp -> checkNext(up,Id,Value,Id,0)
			end;
		dn ->
			debug:debug("I, ~p, go down.~n",[Id]),
            ok;
		lx ->
			debug:debug("I, ~p, go left.~n",[Id]),
            ok;
		rx ->
			debug:debug("I, ~p, go right.~n",[Id]),
            ok;
		{yourValue, Repl} ->
            debug:debug("I, ~p, send my value: ~p, ~p.~n",[Id,Value,Merged]),
			Repl ! {tilevalue, Id, Value, Merged};
		{setvalue, Future, NewMerged} ->
            debug:debug("I, ~p, set my value: ~p, ~p.~n",[Id,Future,NewMerged]),
			tilelife(Id,Future,NewMerged)
	end,
	tilelife(Id,Value,Merged).
	
inBounds(Tile) when Tile > 0, Tile < 17 -> true;
inBounds(_) -> false.

atEdge(up,Tile) when Tile > 0, Tile < 5 -> true;
atEdge(dn,Tile) when Tile > 12, Tile < 17 -> true;
atEdge(lx,Tile) when (Tile == 1) or (Tile == 5) or (Tile == 9) or (Tile == 13) -> true;
atEdge(lx,Tile) when (Tile == 4) or (Tile == 8) or (Tile == 12) or (Tile == 16) -> true;
atEdge(_,_) -> false.

nextTileToCheck(up,Tile) -> Tile-4;
nextTileToCheck(dn,Tile) -> Tile+4;
nextTileToCheck(lx,Tile) -> Tile-1;
nextTileToCheck(rx,Tile) -> Tile+1;
nextTileToCheck(_,_) -> 0.

nextTileToPropagate(up,Tile) -> Tile+4;
nextTileToPropagate(dn,Tile) -> Tile-4;
nextTileToPropagate(lx,Tile) -> Tile+1;
nextTileToPropagate(rx,Tile) -> Tile-1;
nextTileToPropagate(_,_) -> 0.

propagate(Dir,Id,Value,Merged) ->
	PropInBounds = inBounds(nextTileToPropagate(Dir,Id)),
	if 
		PropInBounds -> glob:regformat(nextTileToPropagate(Dir,Id)) ! Dir;
		not PropInBounds -> debug:debug("no ~p propagation after ~p~n",[Dir,Id])
	end,
	tilelife(Id,Value,Merged).

moveLoop(Dir,Id,Value,PrevId,PrevValue)->
    receive
        {tilevalue, NId, NValue, NMerged} ->
			CanMerge = (((NValue == Value) and not NMerged) or ((NValue == 0) and atEdge(Dir,NId))),
			NeedCheckNext = ((NValue == 0) and inBounds(nextTileToCheck(Dir,NId))),
			CannotMerge = (NValue =/= Value) or NMerged,
			CanMergeWithPrev = CannotMerge and (PrevId =/= Id),
			
			if
				CanMerge -> merge(Dir,Id,Value,NId,NValue);
				NeedCheckNext -> checkNext(Dir,Id,Value,NId,NValue);
				CanMergeWithPrev -> merge(Dir,Id,Value,PrevId,PrevValue);
				CannotMerge -> noMerge(Dir,Id,Value)
			end
    end.
    
merge(Dir,Id,Value,NId,NValue) -> 
	glob:regformat(NId) ! {setvalue, NValue + Value, true},
	propagate(Dir,Id,0,false).
	
checkNext(Dir,Id,Value,PrevId,PrevValue) ->
	glob:regformat(nextTileToCheck(Dir,PrevId)) ! {yourValue, self()},
	moveLoop(Dir,Id,Value,PrevId,PrevValue).
	
noMerge(Dir,Id,Value) ->
	propagate(Dir,Id,Value,false).
	
