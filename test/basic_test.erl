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

simple_test() ->
    M = finger_tree:new(sum_monoid),
    T = M:empty(),
    T1 = lists:foldl(fun M:pushl/2, T, lists:seq(1,100)),
    100 = M:headl(T1).
