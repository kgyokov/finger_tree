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


stack_left_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun sum_monoid:pushl/2, T, L),
    ?assertEqual(10000,sum_monoid:headl(T1)),
    ?assertEqual(lists:reverse(L),left_recrusive_head(sum_monoid,T1)).

stack_right_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun(E,Acc) -> sum_monoid:pushr(Acc,E) end, T, L),
    ?assertEqual(10000,sum_monoid:headr(T1)),
    ?assertEqual(L,left_recrusive_head(sum_monoid,T1)).

queue_left_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun sum_monoid:pushl/2, T, L),
    ?assertEqual(1,sum_monoid:headr(T1)),
    ?assertEqual(L, right_recrusive_head(sum_monoid,T1)).

queue_right_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun(E,Acc) -> sum_monoid:pushr(Acc,E) end, T, L),
    ?assertEqual(1,sum_monoid:headl(T1)),
    ?assertEqual(lists:reverse(L), right_recrusive_head(sum_monoid,T1)).


measure_sum_test() ->
    T = sum_monoid:empty(),
    L = lists:seq(1,10000),
    T1 = lists:foldl(fun(E,Acc) -> sum_monoid:pushr(Acc,E) end, T, L),
    ?assertEqual(50005000,sum_monoid:measure(T1)).

%% Direction matters w/ monoids - the associative operation is not necessarily commutative
measure_left_directional_test() ->
    T = list_monoid:empty(),
    L = lists:seq(1,100),
    T1 = lists:foldl(fun(E,Acc) -> list_monoid:pushr(Acc,E) end, T, L),
    ?assertEqual(L,list_monoid:measure(T1)).

measure_right_directional_test() ->
    T = reverse_list_monoid:empty(),
    L = lists:seq(1,100),
    T1 = lists:foldl(fun(E,Acc) -> reverse_list_monoid:pushr(Acc,E) end, T, L),
    ?assertEqual(lists:reverse(L),reverse_list_monoid:measure(T1)).

concat_test() ->
    A = list_monoid:empty(),
    B = list_monoid:empty(),
    A1 = lists:foldl(fun(E,Acc) -> list_monoid:pushr(Acc,E) end, A, lists:seq(1,500)),
    B1 = lists:foldl(fun(E,Acc) -> list_monoid:pushr(Acc,E) end, B, lists:seq(501,1000)),
    C = list_monoid:concat(A1,B1),
    ?assertEqual(lists:seq(1,1000),left_recrusive_head(list_monoid,C)).

%% ============================================================================================
%% ============================================================================================
%% Utility functions
%% ============================================================================================
%% ============================================================================================

to_list_r(Mod,T,Acc) ->
    case Mod:is_empty(T) of
        true -> Acc;
        false ->
            H = Mod:headr(T),
            T1 = Mod:tailr(T),
            to_list_r(Mod,T1,[H|Acc])
    end.


left_recrusive_head(Mod,T) ->
    lists:reverse(to_list_l(Mod,T,[])).

to_list_l(Mod,T,Acc) ->
    case Mod:is_empty(T) of
        true -> Acc;
        false ->
            H = Mod:headl(T),
            T1 = Mod:taill(T),
            to_list_l(Mod,T1,[H|Acc])
    end.

right_recrusive_head(Mod,T) ->
    lists:reverse(to_list_r(Mod,T,[])).

