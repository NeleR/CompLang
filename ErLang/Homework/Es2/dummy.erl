-module(dummy).

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
	dummy ! {register,self(),killer},
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
			io:format("[Klr]\t I Strike\n"),
			dummy ! {atk, self(), killer, Attack},
			loop(State+1,HP,Attack,Defense);
		% defend
		{atk, _, _, WeaponPower} ->
			NewHP = HP - WeaponPower + Defense,
			if
				NewHP =< 0 ->
					io:format("[Klr]\t I Defend and die\n"),
					killer ! die,
					loop(State+1,HP,Attack,Defense);
				true ->
					io:format("[Klr]\t I Defend and have HP ~p left\n",[NewHP]),
					loop(State+1,NewHP,Attack,Defense)
			end;
		% die
		die ->
			io:format("[Klr]\t Alas, I die in ~p steps\n",[State]),
			dummy ! {killed, self(), killer}
	end,
	ok.
