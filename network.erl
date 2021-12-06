-module(network).
-export([getLastBlockPId/1,my_node/5,network_start/1]).
-import(linkedList,[pushLl/3,getTable/2,run/0,getID/1]).

my_node(Pid_list_node,Blockchain,Random_value,Total_received,Stop)->
  % Pid_list_node = [],
  receive
    {"pid_list",Pid_list}->
      % Pid_list_node = Pid_list,
      % io:fwrite("Received ~p je suis  ~p\n",[Pid_list,self()]),
      my_node(Pid_list,Blockchain,Random_value,Total_received,Stop);
    {"stop", Empty}->

      io:fwrite("node die \n");
    {"random_number",Random}->
        % io:fwrite("charles a recu le chiffre nul ~p\n",[Random]),
        Total_received_new = Total_received +1,
        if
          Total_received_new == length(Pid_list_node) -1 ->
            New_random_value = (Random + Random_value) rem length(Pid_list_node),
            if
              New_random_value == 0 ->
                Elected_node = lists:nth(length(Pid_list_node),Pid_list_node);
              true->
                Elected_node = lists:nth(New_random_value,Pid_list_node)
            end,
            Elected_node ! {"you are elected", Blockchain},
            my_node(Pid_list_node,Blockchain,0,0,Stop);
          true->
            my_node(Pid_list_node,Blockchain,Random + Random_value,Total_received+1,Stop)
        end;
        % value = (random + value ) rem N %quand est ce que tout est envoye?
        % totral = total + 1
        % if total == N 
        %   chosen node = pidlist[value]
        %   send to value permission
        %   send to value you are elected,Blockchain
    % {Random,UpdatedBlockchain}->
    {"updated", New_blockchain}->
        io:fwrite("block revceivedfs\n"),
        Pid = lists:nth(2,lists:nth(1,New_blockchain)),

        % io:fwrite("pid = ~p\n",[Pid]),
        if 
          Pid =/= self()->
            % io:fwrite("pid = ~p\n",[Pid]),
            Pid ! {"random_number",rand:uniform(length(Pid_list_node))};
          true->
             io:fwrite("charles a tort\n")
        end,
          % rand:uniform(lists:length(Pid_list_node))
        my_node(Pid_list_node,New_blockchain,Random_value,Total_received,Stop);
        % Pid ! {"random_number", rand:uniform(lists:length(Pid_list_node))};
        % io:fwrite("je dois cahrles un burrito sorry\n");

    {"you are elected", Blockchain}->
        % io:fwrite("tes moche charles ~w \n", [Pid_list_node]),
        New_blockchain = linkedList:pushLl(Blockchain,self(),["charles a paye que dale a camille"]),
        % io:fwrite("new blockchain = ~w \n", [New_blockchain]),
        
        if
          Stop == 0->
            io:fwrite("node die \n"),
            network_send_to_nodes([],"stop", Pid_list_node);
          true ->
            network_send_to_nodes(New_blockchain,"updated",Pid_list_node),
            my_node(Pid_list_node,New_blockchain,0,0,Stop -1)
        end
        % broadcast_blockchain
     end,
     ok.

   
getLastBlockPId([H|T])->
    linkedList:getID(H).

append([H|T], Tail) ->
    [H|append(T, Tail)];
append([], Tail) ->
    Tail.

network_start_pid(N,Pid_list) when N == 0 -> Pid_list;
network_start_pid(N,Pid_list) when N > 0 ->
  Pid = [spawn(network, my_node,[[],[],0,0, 5])],
  New_Pid_list = append(Pid_list, Pid),
  io:fwrite("creating ~p \n",[New_Pid_list]),
  network_start_pid(N-1,New_Pid_list).

network_send_to_nodes(Data,Message, [])->
  io:fwrite("list sent\n");
network_send_to_nodes(Data,Message, [H|T])->
  io:fwrite("send to ~p the list ~p\n",[H,Data]),
  H ! {Message,Data},
  network_send_to_nodes(Data, Message, T).




network_start(N)->
  io:fwrite("start with ~p nodes\n",[N]),
  Pid_list = network_start_pid(N,[]),
  io:fwrite("start ~p \n", [Pid_list]),
  network_send_to_nodes(Pid_list,"pid_list",Pid_list),
  Elected_node = rand:uniform(N),
  Elected_node_pid = lists:nth(Elected_node,Pid_list),
  Blockchain = [],
  Elected_node_pid ! {"you are elected",Blockchain}.
% elect_node(N)->
%     if(rien in blovkchain)
%         node = random:uniform(N)-1;
%         node elect => pid! execute order 66
%     else