%%%-------------------------------------------------------------------
%%% @author Kalin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% Based on Finger Trees (http://www.staff.city.ac.uk/~ross/papers/FingerTree.html)
%%% Mostly direct translation to Erlang from the Haskell code in the paper
%%% @end
%%%-------------------------------------------------------------------
-module(finger_tree,[MOD]).
-author("Kalin").

-include("finger_tree.hrl").

%% API
-export([pushl/2, pushr/2, is_empty/1, headl/1, taill/1, concat/2, measure/1, empty/0]).

-type tree_node(E) ::
{node2,E,E}
|{node3,E,E}.

-type finger_tree(E) ::
    empty
    |{single,E}
    |{deep,any(),[E],finger_tree(tree_node(E)),[E]}.

empty() -> empty.

%%-spec pushl(E,finger_tree(E)) -> finger_tree(E).
%%-spec pushr(finger_tree(E),E) -> finger_tree(E).

pushl(A,empty)                      ->  {single,A};
pushl(A,{single,B})                 ->  deep([A],empty,[B]);
pushl(A,{deep,_,[B,C,D,E],M,SF})    ->  deep([A,B],pushl(node3(C,D,E),M),SF);
pushl(A,{deep,_,PR,M,SF})           ->  deep([A|PR],M,SF).

pushr(empty,A)                      ->  {single,A};
pushr({single,B},A)                 ->  deep([B],empty,[A]);
pushr({deep,_,PR,M,[E,D,C,B]},A)    ->  deep(PR,pushr(node3(E,D,C),M),[B,A]);
pushr({deep,_,PR,M,SF},A)           ->  deep(PR,M,SF++[A]).


%%
%% Reducers
%%

%%-spec reducer(Fun,XS,Z) -> Z when
%%    Fun :: fun((E,Z) -> Z),
%%    XS ::
%%        tree_node(E)
%%        |finger_tree(E)
%%        |[E].
%%-spec reducel(Fun,Z,XS) -> Z when
%%    Fun :: fun((Z,E) -> Z),
%%    XS ::
%%        tree_node(E)
%%        |finger_tree(E)
%%        |[E].

reducer(Fun,{node2,_,A,B},Z)    -> Fun(A,Fun(B,Z));
reducer(Fun,{node3,_,A,B,C},Z)  -> Fun(A,Fun(B,Fun(C,Z)));
reducer(_Fun,empty,Z)           -> Z;
reducer(Fun,{single,X},Z)       -> Fun(X,Z);
reducer(Fun,{deep,_,PR,M,SF},Z) ->
    Fun1 = fun(A,B) -> reducer(Fun,A,B)  end,
    Fun2 = fun(A,B) -> reducer(Fun1,A,B) end,
    Fun1(PR,Fun2(M,Fun1(SF,Z)));

reducer(Fun,L,Z) when is_list(L) -> lists:foldr(Fun,Z,L).


reducel(Fun,Z,{node2,_,B,A})    -> Fun(Fun(Z,B),A);
reducel(Fun,Z,{node3,_,C,B,A})  -> Fun(Fun(Fun(Z,C),B),A);
reducel(_Fun,Z,empty)           -> Z;
reducel(Fun,Z,{single,X})       -> Fun(Z,X);
reducel(Fun,Z,{deep,_,PR,M,SF}) ->
    Fun1 = fun(A,B) -> reducel(Fun,A,B)  end,
    Fun2 = fun(A,B) -> reducel(Fun1,A,B) end,
    Fun1(Fun2(Fun1(Z,PR),M),SF);

reducel(Fun,Z,L) when is_list(L) ->
    RFun = fun(Acc,Elem) -> Fun(Elem,Acc) end,
    lists:foldl(RFun,Z,L).

%%
%% Conversion
%%

%%-spec to_tree([E]) -> finger_tree(E).
%%-spec to_list(finger_tree(E)) -> [E].
to_tree(L) when is_list(L) -> lists:foldl(fun pushr/2,empty,L).
to_list(T) -> reducer(fun(H,XS) -> [H|XS] end,T,[]).


%%
%% Navigation
%%

%% @todo: lazy view???

viewl(empty)                -> nil;
viewl({single,A})           -> {A,nil};
viewl({deep,_,[H|T],M,SF})  -> {H,deepl(T,M,SF)}.

deepl([],M,SF)  ->
    case viewl(M) of
        nil     -> to_tree(SF);
        {A,M1}  -> deep(to_list(A),M1,SF)
    end;

deepl(PR,M,SF)  ->
    deep(PR,M,SF).

%%-spec headl(finger_tree(E)) -> E.
headl(T) ->
    {H,_} = viewl(T),
    H.

%%-spec taill(finger_tree(E)) -> finger_tree(E).
taill(T) ->
    {_,T} = viewl(T),
    T.

%%-spec is_empty(finger_tree(any())) -> true|false.
is_empty(T) ->
    case viewl(T) of
        nil     -> true;
        {_,_}   -> false
    end.


%%
%% Appending
%%

%% @todo: reducer and pushl???

%%-spec app3(finger_tree(E),[E],finger_tree(E)) -> finger_tree(E).

app3(empty,TS,XS)           -> reducer(fun pushl/2,TS,XS); %% @todo: optimize???
app3(XS,TS,empty)           -> reducel(fun pushr/2,XS,TS);
app3({single,X},TS,XS)      -> pushl(X,reducer(fun pushl/2,TS,XS));
app3(XS,TS,{single,X})      -> pushr(reducel(fun pushr/2,XS,TS),X);

app3({deep,_,PR1,M1,SF1},TS,{deep,_,PR2,M2,SF2}) ->
    M3 = app3(M1,to_nodes(SF1++TS++PR2),M2),
    deep(PR1,M3,SF2).

%%-spec to_nodes([E]) -> [tree_node(E)].
to_nodes([A,B])        -> [node2(A,B)];
to_nodes([A,B,C])      -> [node3(A,B,C)];
to_nodes([A,B,C,D])    -> [node2(A,B),node2(C,D)];
to_nodes([A,B,C|T])    -> [node3(A,B,C)|to_nodes(T)]. %% @todo: optimize???


concat(XS,TS) -> app3(XS,[],TS).

%%
%% Measuring
%%

%%
%% This might work much better with Elixir protocols, because we can define the Monoid {Id,As} using a protocol
%% instead of passing it around like crazy. Parameterized modules also would have worked :-(

node2(A,B) ->
    V = measure(A),
    V1 = measure(B),
    {node2,MOD:as(V,V1),A,B}.

node3(A,B,C)  ->
    V = measure(A),
    V1 = measure(B),
    V2 = measure(C),
    V3 = MOD:as(MOD:as(V,V1),V2),
    {node3,V3,A,B,C}.

deep(PR,M,SF) ->
    V = measure(PR),
    V1 = measure(M),
    V2 = measure(SF),
    V3 = MOD:as(MOD:as(V,V1),V2),
    {deep,V3,PR,M,SF}.


measure({node2,V,_,_})          -> V;
measure({node3,V,_,_,_})        -> V;
measure(D) when is_list(D)      -> reducel(fun(Z,E) -> MOD:as(Z,MOD:measure(E)) end,MOD:id(),D);
measure(empty)                  -> MOD:id();
measure({single,X})             -> measure(X);
measure({deep,V,_,_,_})         -> V;
measure(X)                      -> MOD:measure(X).