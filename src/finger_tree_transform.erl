%%%-------------------------------------------------------------------
%%% @author Kalin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Jan 2016 6:09 PM
%%%-------------------------------------------------------------------
-module(finger_tree_transform).
-author("Kalin").

%% API
-export([parse_transform/2, format_error/1]).

-define(MOD,finger_tree_monoid@).

parse_transform(Forms,_Options) ->
    io:format("~p~n",Forms),
    Forms.

transform_monoid_ref(
        {
            remote,_,
            {atom,_,?MOD},
            {atom,L,Fun}
        }) ->
        {atom,L,Fun}.

%%{call,113,
%%{atom,113,
%%to_tree},
%%[{var,113,
%%'SF'}]}]}

format_error(Err) ->
    io:format("~p~n",Err),
    Err.

