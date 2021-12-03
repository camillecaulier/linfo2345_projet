-module(linkedList).
-export([pushLl/3,getLl/2]).


getID(L)->
	lists:nth(1, L).

push_rec([H|T],Head)->
		Id = getID(H) +1,
		Head = [Id,PID,Table],
		[H|push_rec(T,Head)];
push_rec([],Head)->
			Head.

pushLl([H|T],PID,Table)->
	Head = [1,PID,Table],
	push_rec([H|T],Head);
pushLl([],PID,Table)->
	Head = [1,PID,Table].

getTable(L) ->
	lists:nth(3, L).
getLl([H|T],Id)->
	if 
		getID(H) == Id ->
			getTable(H);
		true ->
			getLl(T,Id)
	end.




