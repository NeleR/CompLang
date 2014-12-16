%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erlang Assignment - Comparative Programming Languages (2014-2015) %
% Nele Rober, r0262954                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(manager).

-export([manage/0, sendmessage/2]).

manage() ->
	Tmp = [1,2,3,4,5,6,7,9,8,9,10,11,12,13,14,15,16],
	lists:map(fun registerTile/1, Tmp),

	manageloop().
	
registerTile(TileID) ->
	registerTile(TileID,0,false).

registerTile(TileID,Value,Merged) ->
	T = spawn(tile,tilemain,[TileID,Value,Merged]),
	glob:registerName(glob:regformat(TileID), T),
	debug:debug("MANAGER: register tile ~p at ~p.~n",[TileID,T]).

% when receiving the message $senddata, spawn a collector and a broadcaster for the collection of the data
% from the tiles. Then, once the $Data is collected, inform the lifeguard and the gui
manageloop() ->
	receive
		up ->
			Tmp = [1,2,3,4],
			lists:map(fun(X) -> sendmessage(X,up) end,Tmp),
			propagationloop(0,false);
		dn ->
			Tmp = [13,14,15,16],
			lists:map(fun(X) -> sendmessage(X,dn) end, Tmp),
			propagationloop(0,false);
		lx ->
			Tmp = [1,5,9,13],
			lists:map(fun(X) -> sendmessage(X,lx) end, Tmp),
			propagationloop(0,false);
		rx ->
			Tmp = [4,8,12,16],
			lists:map(fun(X) -> sendmessage(X,rx) end, Tmp),
			propagationloop(0,false);
		sendData ->
			Basetuple = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% this is the instruction mentioned in the text %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			%timer:sleep(700),
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% this is the instruction mentioned in the text %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			PidCollector = spawn( fun() -> collect( 0, Basetuple ) end),
			register( collector, PidCollector ),
			spawn( fun() -> broadcaster( 16, {yourValue, collector} ) end);
		{collectedData, TupleData} ->
			ListData = randomiseatile(TupleData),
			gui ! {values, ListData};
		{tileDies, Id,Value,Merged} ->
			registerTile(Id,Value,Merged)
	end,
	manageloop().

propagationloop(Num,AskedToSend) ->
	receive
		endOfPropagation ->
			case Num of
				3 -> 
					if
						AskedToSend -> manager ! sendData, manageloop();
						not AskedToSend -> manageloop()
					end;
				_ -> 
					propagationloop(Num+1,AskedToSend)
			end;gi
		{tileDies, Id,Value,Merged} ->
			registerTile(Id,Value,Merged),
			propagationloop(Num,AskedToSend);
		sendData ->
			propagationloop(Num,true)
	end.

% takes a tuple of data in input and returns it in a list format
% with two elements that were at 0 now randomised at 2
randomiseatile( Tuple )->
	{A1,A2,A3} = now(),
    random:seed(A1, A2, A3),
	case glob:zeroesintuple(Tuple) of
		0 ->
			Tu = Tuple;
		_ ->
			C1 = getCand(0, Tuple),
			V1 = 2,
			debug:debug("MANAGER: radomised in ~p.~n",[C1]),
			io:format("MANAGER: radomised in ~p.~n",[C1]),
			sendmessage(C1,{setvalue, V1, false}),
			Tu = erlang:setelement(C1,Tuple,V1)
	end,
	erlang:tuple_to_list(Tu).

% returns a number from 1 to 16 different from $Oth
% such that its value in $T is 0, i.e. $return can be initialised at random
getCand( Oth , T)->
	C = random:uniform(16),
	case C of
		Oth -> getCand(Oth, T);
		_ ->
			case erlang:element(C, T) of
				0 -> C;
				_ -> getCand(Oth, T)
			end
	end.

% collects 16 numbers in $T, then returns the related tuple
% $T is a tuple of length 16
collect( N , T) ->
	case N of
		16 -> 
			manager ! {collectedData, T};
		Num ->
			receive
				{tilevalue, Id, Value, _} ->
					collect( Num+1, erlang:setelement(Id, T, Value))
			end
	end.

% Sends message $Mess to all tiles
broadcaster( 0, _ )->
	ok;
broadcaster( N, Mess ) when N < 17 -> 
	sendmessage( N, Mess),
	broadcaster( N-1, Mess ).

sendmessage( N, Mess) when N > 0, N < 17 ->
	try glob:regformat(N) ! Mess of
		_ -> 
			debug:debug("send to ~p.~n",[N]),
			ok
	catch
		_:F -> 
			io:format("BROADCASTER: cannot commmunicate to ~p. A new empty tile is created.~n   Error ~p.~n",[N,F]),
			registerTile(N,0,false),
			sendmessage( N, Mess )
	end.
	
