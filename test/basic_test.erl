%%%-------------------------------------------------------------------
%%% @author Kalin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jan 2016 12:00 AM
%%%-------------------------------------------------------------------
-module(basic_test).
-author("Kalin").

-include_lib("eunit/include/eunit.hrl").

%%simple_test() ->
%%    M = finger_tree:new(sum_monoid),
%%    T = M:empty(),
%%    T1 = lists:foldl(fun M:pushl/2, T, lists:seq(1,100)),
%%    100 = M:headl(T1).


stack_left_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun sum_monoid:pushl/2, T, L),
    ?assertEqual(10000,sum_monoid:headl(T1)),
    ?assertEqual(lists:reverse(L),left_recrusive_head(T1)).

stack_right_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun(E,Acc) -> sum_monoid:pushr(Acc,E) end, T, L),
    ?assertEqual(10000,sum_monoid:headr(T1)),
    ?assertEqual(L,left_recrusive_head(T1)).

queue_left_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun sum_monoid:pushl/2, T, L),
    ?assertEqual(1,sum_monoid:headr(T1)),
    ?assertEqual(L, right_recrusive_head(T1)).

queue_right_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun(E,Acc) -> sum_monoid:pushr(Acc,E) end, T, L),
    ?assertEqual(1,sum_monoid:headl(T1)),
    ?assertEqual(lists:reverse(L), right_recrusive_head(T1)).

right_recrusive_head(T) ->
    lists:reverse(to_list_r(T,[])).


%% Utility functions
to_list_r(T,Acc) ->
    case sum_monoid:is_empty(T) of
        true -> Acc;
        false ->
            H = sum_monoid:headr(T),
            T1 = sum_monoid:tailr(T),
            to_list_r(T1,[H|Acc])
    end.


left_recrusive_head(T) ->
    lists:reverse(to_list_l(T,[])).

to_list_l(T,Acc) ->
    case sum_monoid:is_empty(T) of
        true -> Acc;
        false ->
            H = sum_monoid:headl(T),
            T1 = sum_monoid:taill(T),
            to_list_l(T1,[H|Acc])
    end.



