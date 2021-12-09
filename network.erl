-module(network).
-export([my_node/7,network_start/2,main/0]).
-import(linkedList,[pushLl/3,getTable/2,run/0,getID/1]).
-import(merkleTree,[createTree/1]).

my_node(Pid_list_node,VCount,Blockchain,Random_value,Total_received,Stop,V)->
  % Pid_list_node = [],
  receive
    {"pid_list",Pid_list}->
      io:fwrite("node ~p is a viewer : \n",[self()]),
      my_node(Pid_list,VCount,Blockchain,Random_value,Total_received,Stop,V);

    {"pid_list",Pid_list,"You are V"}->
      io:fwrite("node ~p is a manager : \n",[self()]),
      my_node(Pid_list,VCount,Blockchain,Random_value,Total_received,Stop,1);

    {"stop", Empty}->
      Empty,
      io:fwrite("node die \n"),
      ok;

    {"random_number",Random}->
        io:fwrite("~p || received random ~p\n",[self(),Random]),
        Total_received_new = Total_received +1,
        if
          Total_received_new == VCount  ->
            New_random_value = (Random + Random_value) rem VCount,
            if
              New_random_value == 0 ->
                Elected_node = lists:nth(VCount,Pid_list_node);
              true->
                Elected_node = lists:nth(New_random_value,Pid_list_node)
            end,
            Elected_node ! {"you are elected", Blockchain},
            my_node(Pid_list_node,VCount,Blockchain,0,0,Stop,V);
          true->
            my_node(Pid_list_node,VCount,Blockchain,Random + Random_value,Total_received+1,Stop,V)
        end;
   
    {"updated", New_blockchain}->
        Pid = lists:nth(2,lists:nth(1,New_blockchain)),
        if 
          V == 1-> 
            io:fwrite("~p send random to : ~p\n",[self(),Pid]),
            Pid ! {"random_number",rand:uniform(length(Pid_list_node))};
          true->
            V
        end,
        my_node(Pid_list_node,VCount,New_blockchain,Random_value,Total_received,Stop,V);
       
    {"you are elected", Blockchain}->
        TransactionList = makeFakeTransactions(), %make transaction list between 1-10
        MerkleTreeRoot = merkleTree:createTree(TransactionList),
        New_blockchain = linkedList:pushLl(Blockchain,self(),MerkleTreeRoot),
        io:fwrite("~p broadcasting the updated blockchain\n",[self()]),
        if
          length(New_blockchain) == Stop->
            io:fwrite("node stopped \n"),
            network_send_to_nodes([],"stop", Pid_list_node,0),
            ok;
          true ->
            network_send_to_nodes(New_blockchain,"updated",Pid_list_node,0),
            my_node(Pid_list_node,VCount,New_blockchain,0,0,Stop,V)
        end
        % broadcast_blockchain
     end,
     ok.

   

append([H|T], Tail) ->
    [H|append(T, Tail)];
append([], Tail) ->
    Tail.

network_start_pid(N,Pid_list,_V) when N == 0 -> Pid_list;
network_start_pid(N,Pid_list,V) when N > 0 ->
  Pid = [spawn(network, my_node,[[],V,[],0,0, 5,0])],
  New_Pid_list = append(Pid_list, Pid),
  network_start_pid(N-1,New_Pid_list,V).

network_send_to_nodes(_Data,_Message, [],_N)->
  break;
network_send_to_nodes(Data,Message, [H|T],N)->
  if
    N > 0 ->
        H ! {Message,Data,"You are V"},
        network_send_to_nodes(Data, Message, T,N-1);
    true ->
      H ! {Message,Data},
      network_send_to_nodes(Data, Message, T,N)
    end.



network_start(N,V)->
  io:fwrite("start with ~p nodes\n",[N]),
  Pid_list = network_start_pid(N,[],V),
  io:fwrite("start ~p \n", [Pid_list]),
  network_send_to_nodes(Pid_list,"pid_list",Pid_list,V),
  Elected_node = rand:uniform(V),
  Elected_node_pid = lists:nth(Elected_node,Pid_list),
  Blockchain = [],
  Elected_node_pid ! {"you are elected",Blockchain}.

% create list of fake random transactions
makeFakeTransactions()->
    Fake_Transaction_List = ["charles a paye camille 10 euros", "camille a paye charles un burrito", "charles a paye des bisous a camille", "camille a paye cahrles rien","charles a paye camilles 10k euros", "camille a paye charles partiquement rien"],
    % creates a list of random transactions between 1 and 10 size 
    Random_size = rand:uniform(10),
    makeFakeTransactionsBis(Random_size,Fake_Transaction_List,[]).


makeFakeTransactionsBis(N, Fake_Transaction_List,ACC)->
    if 
      N==0->
        ACC;
      true->
        Random_transaction  = lists:nth(rand:uniform(length(Fake_Transaction_List)),Fake_Transaction_List),
        NewACC= [Random_transaction|ACC],
        makeFakeTransactionsBis(N-1, Fake_Transaction_List,NewACC)
    end.

main()->
  makeFakeTransactions().    