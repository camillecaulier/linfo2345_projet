-module(network).

-export([my_node/0, network_send_to_nodes/2, network_start/1]).

my_node()->

  receive
    {Pid_list}->

      io:fwrite("Received ~p je suis  ~p\n",[Pid_list,self()]);
		% random->
		% 		value = (random + value ) rem N %quand est ce que tout est envoye?
		% 		totral = total + 1
  %       if total == N 
  %         chosen node = pidlist[value]
  %         send to value you are elected,Blockchain
  {Random,UpdatedBlockchain}->
  	
    {"you are elected", Blockchain}->
        io:fwrite("tes moche charles\n");   
        %push block 
        %broadcast_blockchain

    {UpdatedBlockchain}->
    	%getLastBlockPId
    	LastBlockPid ! RandomNumber
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
