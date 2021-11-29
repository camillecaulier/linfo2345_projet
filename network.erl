-module(network).

-export([my_node/0, network_send_to_nodes/2, network_start/1]).

my_node()->
  receive
    {Received_pid_list}->
      Pid_list = Received_pid_list,
      io:fwrite("~p",[Pid_list]),
      my_node()
  end.



network_start_pid(N,Pid_list) when N == 0 -> Pid_list;
network_start_pid(N,Pid_list) when N > 0 -> Pid = [spawn(fun network:my_node/0)], network_start_pid(N-1,lists:append(Pid_list, Pid)).


network_send_to_nodes(Pid_list, [H|T])->
  H ! Pid_list,
  network_send_to_nodes(Pid_list, [T]);
network_send_to_nodes(Pid_list, [])->
  io:fwrite("list sent").


network_start(N)->
  io:fwrite("start with ~p nodes\n",[N]),
  Pid_list = network_start_pid(N,[]),
  network_send_to_nodes(Pid_list,Pid_list).
