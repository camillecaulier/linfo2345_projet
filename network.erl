-module(network).
-export([my_node/4,network_start/1]).
-import(linkedList,[pushLl/3,getTable/2,run/0,getID/1]).

my_node(Pid_list_node,Blockchain,Random_value,Total_received)->
  % Pid_list_node = [],
  receive
    {Pid_list}->
      % Pid_list_node = Pid_list,
      io:fwrite("Received ~p je suis  ~p\n",[Pid_list,self()]),
      my_node(Pid_list,Blockchain,Random_value,Total_received);
    % random->
    %     value = (random + value ) rem N %quand est ce que tout est envoye?
    %     totral = total + 1
  %       if total == N 
  %         chosen node = pidlist[value]
  %         send to value permission
  %         send to value you are elected,Blockchain
    % {Random,UpdatedBlockchain}->

    {"you are elected", Blockchain}->
        io:fwrite("tes moche charles ~w \n", [Pid_list_node]),
        New_blockchain = linkedList:pushLl(Blockchain,self(),["charles a paye que dale a camille"]),
        % io:fwrite("new blockchain = ~w \n", [New_blockchain]),
        
        my_node(Pid_list_node,New_blockchain,0,0)
        % broadcast_blockchain
     end.
        % io:fwrite("tes moche charles\n");   
        %push block 
        %broadcast_blockchain

    % {UpdatedBlockchain}->
      %getLastBlockPId
      % LastBlockPid ! RandomNumber
   


append([H|T], Tail) ->
    [H|append(T, Tail)];
append([], Tail) ->
    Tail.

network_start_pid(N,Pid_list) when N == 0 -> Pid_list;
network_start_pid(N,Pid_list) when N > 0 ->
  Pid = [spawn(network, my_node,[[],[],0,0])],
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
%     if(rien in blovkchain)
%         node = random:uniform(N)-1;
%         node elect => pid! execute order 66
%     else