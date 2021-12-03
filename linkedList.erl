-module(linkedList).
-export([pushLl/3,getTable/2,run/0]).

%structure [id,pid,table]
getID(L)->
	lists:nth(1, L).



pushLl([H|T],PID,Table)->
	io:fwrite("Head = ~w\n", [H]),
	ID_prev = getID(H),
	ID = ID_prev +1,
	io:fwrite("my id = ~p\n", [ID]),
	Head = [ID,PID,Table],
	List = [H|T],
	% Newlist =[Head|List],
	% io:fwrite("the new list is : ~w\n", [Newlist]),
	[Head|List];
pushLl([],PID,Table)->
	io:fwrite("~w\n", [Table]),
	[[1,PID,Table]].
	

getTableIn(L)->
	lists:nth(3, L).	
getTable([H|T],Id)->
	MyIndex = getID([H]),
	if
		MyIndex == Id ->
			MyTable =getTableIn(H),
			MyTable;
		true->
			getTable([T],Id)
			
	end.
run()->
	NewList = pushLl([],1,[1,2,3]),
	io:fwrite("~w\n", [NewList]),
	NewList = pushLl(NewList,2,[4,5,6]),
	io:fwrite("dans le run :~w\n", [NewList]),
	NewList = pushLl(NewList,3,[7,8,9]).
	
	