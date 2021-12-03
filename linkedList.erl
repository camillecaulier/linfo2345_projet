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
	io:fwrite("dans le get table :~w\n", [[H|T]]),
	MyIndex = getID(H),
	if
		MyIndex == Id -> getTableIn(H)
		; MyIndex /= Id->getTable(T,Id)	
	end.
run()->
	NewList = pushLl([],1,[1,2,3]),
	io:fwrite("~w\n", [NewList]),
	Fresh = pushLl(NewList,2,[4,5,6]),
	io:fwrite("dans le run :~w\n", [Fresh]),
	Fresh2 = pushLl(Fresh,3,[7,8,9]),
	io:fwrite("la table :~w\n", [Fresh2]),
	Table = getTable(Fresh2,1),
	io:fwrite("la table :~w\n", [Table]).

	


	
	