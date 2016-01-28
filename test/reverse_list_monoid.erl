%%%-------------------------------------------------------------------
%%% @author Kalin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jan 2016 12:25 AM
%%%-------------------------------------------------------------------
-module(reverse_list_monoid).
-author("Kalin").

-export([id/0, as/2, ms/1]).
-include("finger_tree.hrl").


id()        -> [].
as(A,B)     -> B ++ A.
%% Default implementation for measure (not part of the monoid)
ms(A)  -> [A].
