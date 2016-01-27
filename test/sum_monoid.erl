%%%-------------------------------------------------------------------
%%% @author Kalin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Jan 2016 11:58 PM
%%%-------------------------------------------------------------------
-module(sum_monoid).
-author("Kalin").

%% API
-export([id/0, as/2, measure/1]).


id()        -> 0.
as(A,B)     -> A+B.
%% Default implementation for measure (not part of the monoid)
measure(A)  -> A.