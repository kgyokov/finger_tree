# finger_tree
Implements a Finger Tree


http://www.staff.city.ac.uk/~ross/papers/FingerTree.html

Mostly direct translation to Erlang from the Haskell code in the paper

# Why is it implemented in an include file?

We need to inject a monoid implementation in the tree. That would require passing an extra argument in each of the myriad of functions just so we can use it in a couple of places. 

A much better solution than passing an extra argument everywhere would be the use of parameterized modules. (Actually, they seem to do the same thing "under the hood"). However, they have been removed in new version of Erlang. They are still maintained here:

https://github.com/erlang/pmod_transform. 

Tried using them, however I was not able to get them to work. One possible reason is the use of dynamically created *Funs* and the way the paremeterized modules implementation adds an extra argument to each function in a module.

Maybe Elixir's protocols could solve this problem (they seem to be similar in purpose as Haskell's type classes). **Elixir metaprogramming** appears to be the most promising solution.
