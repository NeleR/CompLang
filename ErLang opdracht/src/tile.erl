%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erlang Assignment - Comparative Programming Languages (2014-2015) %
% Nele Rober, r0262954                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(tile).
-import(string, [concat/2]).

-export([tilemain/1,atTheTop/2]).

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
			up(Id,Value);
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
            debug:debug("I, ~p, set my value: ~p, ~p.~n",[Id,Value,Merged]),
			tilelife(Id,Future,NewMerged)
	end,
	tilelife(Id,Value,Merged).
	
inBounds(Tile) when Tile < 0, Tile > 16 -> false;
inBounds(_) -> true.

% call this function as: atTheTop(Tile,inBounds(Tile))
atTheTop(Tile,true) when Tile < 5 -> true;
atTheTop(_,_) -> false.
	
% call this function as: propagateUp(Id,inBounds(Id + 4))
propagateUp(Id,true) -> glob:regformat(Id + 4) ! up;
propagateUp(_,_) -> false.

up(Id,Value)->
	noMerge(Id,Value,
		((Value == 0) or atTheTop(Id,inBounds(Id)))),
	glob:regformat(Id - 4) ! {yourValue, self()},
    receive
        {tilevalue, NId, NValue, NMerged} ->
        	% if possible, merge with the next tile
        	merge(Id,Value,NId,NValue,
        		((NValue == Value) and not NMerged) or ((NValue == 0) and atTheTop(NId,inBounds(Id)))),
        	% if needed, check the value of the next tile
        	checkNext(Id,Value,NId-4,
        		((NValue == 0) and inBounds(NId-4))),
        	% if no merge is possible
	    	noMerge(Id,Value,
	    		((NValue /= Value) or NMerged)) 
    end.
    
merge(Id,Value,NId,NValue,true) -> 
	glob:regformat(NId) ! {setvalue, NValue + Value, true},
	glob:regformat(Id) ! {setvalue,0,false},
	propagateUp(Id,inBounds(Id + 4)).
	
checkNext(Id,Value,NextId,true) ->
	glob:regformat(NextId) ! {yourValue, self()},
	up(Id,Value).
	
noMerge(Id,Value,true) ->
	glob:regformat(Id) ! {setvalue,Value,false},
	propagateUp(Id,inBounds(Id + 4)).
	
