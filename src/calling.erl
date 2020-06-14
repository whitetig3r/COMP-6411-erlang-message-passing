 %%%-------------------------------------------------------------------
%%% @author Warren White
%%% @copyright (C) 2020
%%% @doc
%%% The child processes execute methods in this file.
%%% @end
%%% Created : 13. Jun 2020 4:02 AM
%%%-------------------------------------------------------------------
-module(calling).
-author("Warren White").
-export([receive_message/1, send_intro_message/2]).

 randomized_sleep() ->
   random:seed(now()),
   timer:sleep(random:uniform(100)).

 send_intro_message(CALLER, CALLEES) ->
   lists:foreach(
     fun(CALLEE) ->
       randomized_sleep(),
       CALLEE ! {CALLER, intro}
     end,
     CALLEES
     ).

 receive_message(CALLER) ->
   receive
     {PROCESS_IDENTIFIER, intro} ->
       INITIAL_CONTACT_TIMESTAMP = element(3,now()),
       master !
         [CALLER, intro, PROCESS_IDENTIFIER, INITIAL_CONTACT_TIMESTAMP],
       randomized_sleep(),
       PROCESS_IDENTIFIER ! {CALLER, INITIAL_CONTACT_TIMESTAMP, reply},
       receive_message(CALLER);
     {PROCESS_IDENTIFIER, INITIAL_CONTACT_TIMESTAMP, reply} ->
       master !
         [CALLER, reply, PROCESS_IDENTIFIER, INITIAL_CONTACT_TIMESTAMP],
       receive_message(CALLER);
     {CALLEES, start} ->
       send_intro_message(CALLER, CALLEES),
       receive_message(CALLER)
   after
    5000 ->
      io:fwrite("Process ~w has received no calls for 5 seconds, ending... ~n",[CALLER]),
      exit(CALLER)
   end.