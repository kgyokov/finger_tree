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

-export([id/0, as/2, ms/1]).

-include("finger_tree.hrl").


%% Monoid implementation


id()        -> 0.
as(A,B)     -> A+B.
%% Default implementation for measure (not part of the monoid)
ms(A)  -> A.