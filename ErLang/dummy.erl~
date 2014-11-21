 -module(dummy).

%%
%% Include files
%%
-import(string).

%%
%% Exported Functions
%%
-export([test/0]).

%%
%% API Functions
%%

test()->
	% register
	register(lord, self()),
	knightServer ! {register,self(),lord},
	io:format("[Lrd]\t I register myself with the server\n"),

	% awake the striker
	PIDstriker = spawn(srv,striker,[self()]),
	io:format("[Lrd]\t I spawn my striker ~p\n",[PIDstriker]),	
	
	receive
		% initialisation
		{vals, ValAttack, ValDefense} ->
			io:format("[Lrd]\t I receive ValAttack ~p and ValDefense ~p\n",[ValAttack, ValDefense]),
			loop(0,20,ValAttack,ValDefense)
	end,

	
	ok.

spawn_knights(NumberLeft)->
	if
		NumberLeft > 0 ->
			register(concat(erlab_,NumberLeft),spawn(lord, knight,[self()])),
			spawn_knights(NumberLeft-1);
		true ->
			ok
	end.

%%
%% Local Functions
%%

loop(State,HP,Attack,Defense)->
	receive
		% debug
		{comm, String, Arg} ->
			io:format("[Lrd]\t comm ~p with args ~p\n",[String,Arg]),
			srv:logSer(String,Arg,lord),
			loop(State+1,HP,Attack,Defense);
		% attack
		strike ->
			try
				knightServer ! {atk, self(), lord, Attack},
				io:format("[Lrd]\t I Strike\n"),
				loop(State+1,HP,Attack,Defense)
			catch
				error:_ ->
					lord ! strike,
					loop(State,HP,Attack,Defense)
			end;
		% defend
		{atk, _, _, WeaponPower} ->
			NewHP = HP - WeaponPower + Defense,
			if
				NewHP =< 0 ->
					io:format("[Lrd]\t I Defend ~p and die\n",[WeaponPower]),
					lord ! die,
					loop(State+1,HP,Attack,Defense);
				true ->
					io:format("[Lrd]\t I Defend ~p and have HP ~p left\n",[WeaponPower,NewHP]),
					loop(State+1,NewHP,Attack,Defense)
			end;
		% die
		die ->
			try
				knightServer ! {killed, self(), lord},
				io:format("[Lrd]\t Alas, I die in ~p steps\n",[State])
			catch
				error:_ ->
					ok
			end
	end,
	ok.
