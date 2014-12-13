%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erlang Assignment - Comparative Programming Languages (2014-2015) %
% Nele Rober, r0262954                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(tile).

-export([tilemain/1]).

tilemain( Id ) ->
	tilemain(Id, 0).

tilemain( Id, Value ) ->
	tilelife(Id,Value,false).


%%%%%%%%%%%%%%%%%
% fill this out %
%%%%%%%%%%%%%%%%%
tilelife(Id,CurrentValue,Merged)->
	receive
		die ->
			debug:debug("I, ~p, die.~n",[Id]),
			exit(killed);
		up ->
            debug:debug("I, ~p, go up.~n",[Id]),
			ok;
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
            debug:debug("I, ~p, send my value.~n",[Id]),
			Repl ! {tilevalue, Id, CurrentValue, Merged};
		{setvalue, Future, NewMerged} ->
            debug:debug("I, ~p, set my value.~n",[Id]),
			tilelife(Id,Future,NewMerged);
	end,
	tilelife( ).

up(Id,Value) ->
    receive ->
        {tilevalue, NId, NValue, NMerged}; ->
            if
                NValue == Value && NMerged == false ->
                    NId - 4 ! {setvalue, NValue + Value, true};  % merge with the next tile
                NValue == 0 && NId - 4 > 0 ->
                    NId - 4 ! {yourValue, self()};  % the responsive tile is empty, ask the next tile
                true ->
                    NId + 4 ! {setvalue, Value, false};  % you cannot merge
            end,
    end,