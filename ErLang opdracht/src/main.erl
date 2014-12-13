%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erlang Assignment - Comparative Programming Languages (2014-2015) %
% Nele Rober, r0262954                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(main).

-export([play/0,playnoblaster/0]).

play() ->
	P = spawn(fun manager:manage/0),	% create the manager and register it
	glob:registerName(manager,P),		% timer:sleep(200),
	spawn(fun blaster:blast/0), 		% create the blaster
	gui:display().						% continue as a gui


playnoblaster() ->
	P = spawn(fun manager:manage/0),
	glob:registerName(manager,P),	
	%Tmp = [1,2,3,4,5,6,7,9,8,9,10,11,12,13,14,15,16],
	
	T1 = spawn(fun tile:tilemain(1)/0)
	glob:registerName(1,T1),			% timer:sleep(200),
			
	gui:display().	