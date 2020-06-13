%%%-------------------------------------------------------------------
%%% @author warrenwhite
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Jun 2020 2:24 AM
%%%-------------------------------------------------------------------
-module(exchange).
-author("warrenwhite").
-export([start/0]).

start() ->
  io:fwrite("** Calls to be made **~n"),
  { ok, TUPLES } = file:consult("src/calls.txt"),
  print_list(TUPLES).

print_list(List)->
  [io:format("~p: ~p ~n",[tuple_head(X),tuple_tail(X)]) || X <- List].

tuple_head(List) ->
  {HEAD, _} = List,
  HEAD.

tuple_tail(List) ->
  {_, TAIL} = List,
  TAIL.