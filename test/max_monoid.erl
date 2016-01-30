%%%-------------------------------------------------------------------
%%% @author Kalin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jan 2016 9:56 PM
%%%-------------------------------------------------------------------
-module(max_monoid).
-author("Kalin").

-export([id/0, as/2, ms/1]).
-include("finger_tree.hrl").


id() -> min_infinity.

as(min_infinity,B)     -> B;
as(A,min_infinity)     -> A;
as(A,B)                -> max(A,B).
%% Default implementation for measure (not part of the monoid)
ms(A)  -> A.
