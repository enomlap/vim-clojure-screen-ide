# vim-clojure-screen-ide
A simple semi-IDE using vim and SCREEN

This is a very simple semi-IDE for edit Clojure source.
Use screen command to open 3 sessions, left one for vim editing, right top one for clojure server run (AND, it can also accept keyboard input),right bottom one for system operation jobs.

--Usage:
  >Press <F5> to save current file and send the code to REPL

--Test platform:
  >Lubuntu(ubuntu compatible) 14.04
  
  >screen --version
   Screen version 4.02.01 (GNU) 28-Apr-14

--Prerequirments:
** screen
** make something like this run secessful:
  >java -server -cp .:/home/op/bin/clojure/jline-1.0.jar:/home/op/bin/clojure/clojure-1.5.1.jar jline.ConsoleRunner clojure.main
  
  #above command just start a clojure REPL, you can change that to anything fit your need
  
--Runtime resource file
  >$HOME/.tmp/screenrc             #screen resource for this screen
  >$HOME/.tmp/never_use_this_temporal_pipe_file.this_file_is_used_for_clojure_input  #fifo pipe for accepting source code
  >$HOME/.tmp/serverinput-pts      #link to the /dev/pts/XX for accepting user keyboard input by REPL session

--Screen shot
![Image text](https://github.com/enomlap/vim-clojure-screen-ide/blob/master/%E6%97%A0%E6%A0%87%E9%A2%98.png)
