-module(linkedList).
-export([pushLl/3]).

%structure [id,pid,table]
getID(L)->
	lists:nth(1, L).



pushLl([H|T],PID,Table)->
	{ID_prev, PID_prev, Table_prev} = H,
	ID = ID_prev +1,
	Head = [ID,PID,Table],
	List = [H|T],
	Newlist =[Head|List],
	io:fwrite("~p\n", Newlist);
pushLl([],PID,Table)->
	Head = [1,PID,Table],
	io:fwrite("~w\n", [Table]).
