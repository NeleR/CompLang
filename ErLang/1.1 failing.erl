-module(1.1 failing).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([test/0]).

%%
%% API Functions
%%

test()->
	% register
	register(killer, self()),
	intermittent ! {register,self(),killer},
	io:format("[Klr]\t I register myself with the server\n"),

	% awake the striker
	PIDstriker = spawn(srv,striker,[self()]),
	io:format("[Klr]\t I spawn my striker ~p\n",[PIDstriker]),	
	
	receive
		% initialisation
		{vals, ValAttack, ValDefense} ->
			io:format("[Klr]\t I receive ValAttack ~p and ValDefense ~p\n",[ValAttack, ValDefense]),
			loop(0,20,ValAttack,ValDefense)
	end,

	
	ok.



%%
%% Local Functions
%%

loop(State,HP,Attack,Defense)->
	receive
		% debug
		{comm, String, Arg} ->
			io:format("[Klr]\t comm ~p with args ~p\n",[String,Arg]),
			srv:logSer(String,Arg,killer),
			loop(State+1,HP,Attack,Defense);
		% attack
		strike ->
			try
				intermittent ! {atk, self(), killer, Attack},
				io:format("[Klr]\t I Strike\n"),
				loop(State+1,HP,Attack,Defense)
			catch
				error:_ ->
					killer ! strike,
					loop(State,HP,Attack,Defense)
			end;
		% defend
		{atk, _, _, WeaponPower} ->
			NewHP = HP - WeaponPower + Defense,
			if
				NewHP =< 0 ->
					io:format("[Klr]\t I Defend ~p and die\n",[WeaponPower]),
					killer ! die,
					loop(State+1,HP,Attack,Defense);
				true ->
					io:format("[Klr]\t I Defend ~p and have HP ~p left\n",[WeaponPower,NewHP]),
					loop(State+1,NewHP,Attack,Defense)
			end;
		% die
		die ->
			try
				intermittent ! {killed, self(), killer},
				io:format("[Klr]\t Alas, I die in ~p steps\n",[State])
			catch
				error:_ ->
					ok
			end
	end,
	ok.
