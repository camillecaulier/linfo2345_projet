-module(network).
-export([network_send_to_nodes/2, network_start/1]).
-import(linkedList,[pushLl/3,getTable/2,run/0,getID/1]).


my_node()->

  receive
    {Pid_list}->

      io:fwrite("Received ~p je suis  ~p\n",[Pid_list,self()]);
	{RandomNumber,Pid_list,UpdatedBlockchain}->
		Value = (RandomNumber + Value ),
		Total = Total + 1,
  		if 
  			Total == length(Pid_list)-> 
  				Value = Value rem length(Pid_list),
  				Chosen_Node = lists:nth(Value,Pid_list),
  				Chosen_Node ! {"you are elected" , Blockchain, Pid_list}
  		end;
  	
    {"you are elected", Blockchain,Pid_list}->
        io:fwrite("tes moche charles\n"),  
        UpdatedBlockChain = pushLl(Blockchain,self(),[]),
        network_send_updated(UpdatedBlockchain,Pid_list,Pid_list);
        %broadcast_blockchain

    {UpdatedBlockchain,Pid_list}->
    	%getLastBlockPId
    	LastBlockPid =getLastId(UpdatedBlockchain),
    	RandomNumber = rand:uniform(length(Pid_list)),
    	LastBlockPid ! {RandomNumber,Pid_list,UpdatedBlockchain}
    
	end,
   my_node().

getLastId([H|T])->
	getID(H).

network_send_updated(UpdatedBlockchain,Pid_list, [])->
  io:fwrite("list sent\n");
network_send_updated(UpdatedBlockchain,Pid_list, [H|T])->
	io:fwrite("send to ~p the list ~p\n",[H,Pid_list]),

  H ! {UpdatedBlockchain,Pid_list},
  network_send_updated(UpdatedBlockchain,Pid_list, T).

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
  io:fwrite("list sent\n");
network_send_to_nodes(Pid_list, [H|T])->
	io:fwrite("send to ~p the list ~p\n",[H,Pid_list]),

  H ! {Pid_list},
  network_send_to_nodes(Pid_list, T).



network_start(N)->
  io:fwrite("start with ~p nodes\n",[N]),
  Pid_list = network_start_pid(N,[]),
  io:fwrite("start ~p \n", [Pid_list]),
  network_send_to_nodes(Pid_list,Pid_list),
  Elected_node = rand:uniform(N),
  Elected_node_pid = lists:nth(Elected_node,Pid_list),
  Blockchain = [],
  Elected_node_pid ! {"you are elected",Blockchain}.

% elect_node(N)->
% 		if(rien in blovkchain)
% 				node = random:uniform(N)-1;
% 				node elect => pid! execute order 66
% 		else
