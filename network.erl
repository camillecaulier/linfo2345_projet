-module(network).

-export([my_node/0, network_send_to_nodes/2, network_start/1]).

my_node()->
	
  receive
    Pid_list->
   
      io:fwrite("Received ~p je suis  ~p\n",[Pid_list,self()])
     end,
   my_node().

  

append([H|T], Tail) ->
    [H|append(T, Tail)];
append([], Tail) ->
    Tail.

network_start_pid(N,Pid_list) when N == 0 -> Pid_list;
network_start_pid(N,Pid_list) when N > 0 -> 
	Pid = [spawn(fun network:my_node/0)],
	New_Pid_list = append(Pid_list, Pid),
	io:fwrite("creating ~p \n",[New_Pid_list]),
	network_start_pid(N-1,New_Pid_list).


network_send_to_nodes(Pid_list, [])->
  io:fwrite("list sent");
network_send_to_nodes(Pid_list, [H|T])->
	io:fwrite("send to ~p the list ~p\n",[H,Pid_list]),

  H ! Pid_list,
  network_send_to_nodes(Pid_list, T).



network_start(N)->
  io:fwrite("start with ~p nodes\n",[N]),
  Pid_list = network_start_pid(N,[]),
  io:fwrite("start ~p \n", [Pid_list]),
  network_send_to_nodes(Pid_list,Pid_list).
