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
    if
        % you are either an empty tile or a tile at the top
		Value == 0 || Id - 4 < 0 ->					
            Id ! {setvalue,Value,false};			% keep your current value
            Id + 4 ! up								% tell the tile below you to calculate its up movement
        % you are not empty and not the top
		true ->
            Id - 4 ! {yourValue, self()};			% ask the tile above you about its value
    end,
    receive ->
        {tilevalue, NId, NValue, NMerged}; ->
            if
				% the tile above you has the same value and is not merged yet: you can merge
				% or the tile above you is an empty tile and is the top: you can merge
                (NValue == Value && !NMerged)
				|| (NValue == 0 && NId - 4 < 0) ->						
                    NId ! {setvalue, NValue + Value, true};		% add your value to the tile above you
					Id ! {setvalue,0,false};						% make your own tile empty
					Id + 4 ! up										% tell the tile below you to calculate its up movement
				% the tile above you has another value or has been merged already: you cannot merge
				NValue != Value || NMerged ->						
					Id ! {setvalue,Value,false};					% keep your current value
					Id + 4 ! up										% tell the tile below you to calculate its up movement
                % the tile above you is an empty tile and not the top: you have to ask further
				NValue == 0 ->										
                    NId - 4 ! {yourValue, self()};  % the responsive tile is empty, ask the next tile
                true ->
                    % do nothing
            end,
    end,