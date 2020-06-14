%%%-------------------------------------------------------------------
%%% @author Warren White
%%% @copyright (C) 2020
%%% @doc
%%% The master process runs the functions in this file.
%%% It spawns the required child processes.
%%% @end
%%% Created : 13. Jun 2020 2:24 AM
%%%-------------------------------------------------------------------
-module(exchange).
-author("warrenwhite").
-export([start/0, receive_messages_to_print/0]).

start() ->
  io:fwrite("** Calls to be made **~n"),
  { ok, TUPLES } = file:consult("calls.txt"),
  print_list(TUPLES),
  register(master, self()),
  lists:foreach(fun spawn_calling_process/1, TUPLES),
  [ CALLER ! {CALLEES, start} || {CALLER, CALLEES} <- TUPLES ],
  receive_messages_to_print().

print_list(List)->
  [io:format("~p: ~p ~n",[tuple_head(X),tuple_tail(X)]) || X <- List].

tuple_head(List) ->
  {HEAD, _} = List,
  HEAD.

tuple_tail(List) ->
  {_, TAIL} = List,
  TAIL.

spawn_calling_process(TUPLE) ->
  {CALLER, _} = TUPLE,
  register(CALLER, spawn(calling, receive_message, [CALLER])).

receive_messages_to_print() ->
  receive
    [CALLER, intro, PROCESS_IDENTIFIER, T_STAMP] ->
      io:fwrite("~w received ~w message from ~w (~w)~n",[CALLER, intro, PROCESS_IDENTIFIER, T_STAMP]),
      receive_messages_to_print();
    [CALLER, reply, PROCESS_IDENTIFIER, T_STAMP] ->
      io:fwrite("~w received ~w message from ~w (~w)~n",[CALLER, reply, PROCESS_IDENTIFIER, T_STAMP]),
      receive_messages_to_print()
    after
      10000 ->
        io:fwrite("Master has received no replies for 10 seconds, ending...")
  end.