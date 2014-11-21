-module(esOne).

-export([start/1, func/1]).

start(Par) ->
	io:format("Client: I am ~p, I was spawned by the server: ~p \n",[self(),Par]),

	% 2.1 spawn a child
	spawn(esOne, func, [self()]),

	% 2.2 send a message to the server via PID
	Par ! {onPid,self()},

	% 2.3 send a message to the server via name => werkt niet!!
	%register(goofy,Par),
	%goofy ! {onName,self()},
	Par ! {onName,self()},

	% 2.4 receive a message
	receive 
		{reply,N} ->
			io:format("Client: reply received from ~p\n",[N])
	end,

	ok.



func(Parent)->
	io:format("Child: I am ~p, I was spawned from ~p \n",[self(),Parent]).
