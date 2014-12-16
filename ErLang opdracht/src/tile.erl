%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erlang Assignment - Comparative Programming Languages (2014-2015) %
% Nele Rober, r0262954                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(tile).
-import(string, [concat/2]).

-export([tilemain/3]).

tilemain( Id ) ->
	tilemain(Id, 0, false).

tilemain( Id, Value, Merged ) ->
	tilelife(Id,Value,Merged).


%%%%%%%%%%%%%%%%%
% fill this out %
%%%%%%%%%%%%%%%%%
tilelife(Id,Value,Merged)->
	receive
		die ->
			debug:debug("I, ~p, die.~n",[Id]),
			manager ! {tileDies, Id,Value,Merged},
			exit(killed);
		up ->
			debug:debug("I, ~p, go up.~n",[Id]),
			move(up,Id,Value);
		dn ->
			debug:debug("I, ~p, go down.~n",[Id]),
            move(dn,Id,Value);
		lx ->
			debug:debug("I, ~p, go left.~n",[Id]),
            move(lx,Id,Value);
		rx ->
			debug:debug("I, ~p, go right.~n",[Id]),
            move(rx,Id,Value);
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
atEdge(rx,Tile) when (Tile == 4) or (Tile == 8) or (Tile == 12) or (Tile == 16) -> true;
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
		PropInBounds -> manager:sendmessage(nextTileToPropagate(Dir,Id),Dir);
		not PropInBounds -> manager ! endOfPropagation
	end,
	tilelife(Id,Value,Merged).

move(Dir,Id,Value) ->
	CannotMove = ((Value == 0) or atEdge(Dir,Id)),
	if 
		CannotMove -> noMerge(Dir,Id,Value);
		not CannotMove -> checkNext(Dir,Id,Value,Id,0)
	end.

moveLoop(Dir,Id,Value,PrevId,PrevValue) ->
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
	manager:sendmessage(NId,{setvalue, NValue + Value, (NValue =/= 0)}),
	propagate(Dir,Id,0,false).
	
checkNext(Dir,Id,Value,PrevId,PrevValue) ->
	manager:sendmessage(nextTileToCheck(Dir,PrevId),{yourValue, self()}),
	moveLoop(Dir,Id,Value,PrevId,PrevValue).
	
noMerge(Dir,Id,Value) ->
	propagate(Dir,Id,Value,false).
	
