# logging

This is a simple logging api that uses the PQueue.Max library as 
its priority queue.

Examples of how to use this library are in src/Main.hs. As long
as you import your Logger and LogReader modules, you have full
access to the functionality.

To run Main.hs to see the examples, follow these steps:

1) Install the latest version of stack (Haskell's package manager)
using this link: https://docs.haskellstack.org/en/stable/install_and_upgrade/

2) Clone this repository, and change directories to \<your path\>/logging

3) Run stack build, to build your executable.

4) Run "stack exec -- logging", and you will see the output of Main.
