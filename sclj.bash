#!/bin/bash
# zuo,Sep 13, 2018
# sclj.bash

if [ $# -ne 1 ]; then
	#	echo "missing source code, parameters number = $#";
	echo -e "Usage:\n\t$0 your_clojure_source_file";
	exit;
fi;
LISTEN_PIPE=$HOME/.tmp/never_use_this_temporal_pipe_file.this_file_is_used_for_clojure_input;

mkdir -p $HOME/.tmp/;

#** check if $LISTEN_PIPE exists
if [ ! -p $LISTEN_PIPE ];then # -p : 'is a pipe file?'
	mkfifo $LISTEN_PIPE;
fi

#** check if there is a clojure server exists already.
lsof -t $LISTEN_PIPE >/dev/null 2>&1; r=$?;
# in use: 0==$r; free to use/on error: 1==$r;
if [ 0 -eq $r ]; then
	echo 'LISTEN_PIPE already in use, that means a clojure server may be already running, script exit.';
	echo "or kill the server manually.";
	exit;
fi;

#** check if my screen-clojure IDE .screenrc exists:
if [ ! -f $HOME/.tmp/.screenrc ]; then
	echo "$HOME/.tmp/.screenrc NOT exists, need installation, exit.";
	echo -e "INSTALL:\n\n\t$0 -i\n\n";
	exit;
fi;

#** install screenrc:
if [ "-i" = "$1" ]; then # while loop starts
	echo "Do INSTALLATION ...";
cat>$HOME/.tmp/screenrc<<EOF
startup_message off #disable start up welcom message
termcapinfo xterm*|Eterm|mlterm|rxvt 'hs:ts=\E]0;:fs=\007:ds=\E]0;screen\007'
term xterm
escape ^__ # change command character from C-A to C-Z
setenv LC_CTYPE en_US.UTF-8
defutf8 on
setenv DISPLAY ':0'
nonblock on
vbell off
msgwait 10

bindkey "^[[A"     focus up        # UP key,change window with ctrl-up
bindkey "^[[B"     focus down      # DOWN key,change window with ctrl-down
bindkey "^[[D"     focus left      # [
bindkey "^[[C"     focus right     # ]

bindkey "^[\`" focus 0  
bindkey "^[1" focus 1  
bindkey "^[2" focus 2  
bindkey "^[3" focus 3  
bindkey "^[4" focus 4  
bindkey "^[5" focus 5  
bindkey "^[6" focus 6  
bindkey "^[7" focus 7  
bindkey "^[8" focus 8  
bindkey "^[9" focus 9

layout new
split -v
screen -t vim 1
focus next
screen -t result 2
exec /bin/bash -c "ln -sf \`readlink -f /proc/\$\$/fd/0\` /home/op/.tmp/serverinput-pts;exec 77<>/home/op/.tmp/never_use_this_temporal_pipe_file.this_file_is_used_for_clojure_input;eval 'cat /home/op/.tmp/serverinput-pts>/home/op/.tmp/never_use_this_temporal_pipe_file.this_file_is_used_for_clojure_input&';echo -n \"\n\n\tLunching Clojure server ...\n\n\n\";java -server -cp .:/home/op/bin/clojure/jline-1.0.jar:/home/op/bin/clojure/clojure-1.5.1.jar jline.ConsoleRunner clojure.main</home/op/.tmp/never_use_this_temporal_pipe_file.this_file_is_used_for_clojure_input "
split
focus bottom
screen -t bash 3
exec /bin/bash -c "sleep 5;"
focus left

bind = resize =
bind + resize +1
bind - resize -1
bind _ resize max
bind c screen 1 # Window numbering starts at 1, not 0.
bind 0 select 10
EOF
	echo "screenrc installed.";
	exit;
fi
 
echo -e "NOTE: the ESCAPE-KEY for this screen terminal is:\n\n\t\t\t`sed -n -e '/^escape/{s/^escape[[:space:]]*\([^[:space:]]*[[:space:]]*\)#*.*$/\1/;p;}' $HOME/.tmp/.screenrc`\n\n\nDo not forget otherwise you'll drown.\n\n";
read -t30 -n1 -r -p 'Press any key to progress...' key
#read -t30 -n1 -r -p 'Press any key in the next 30 seconds...' key
#-t30: wait most 30s
#-n1 : read only 1 char
#-r  : raw key is count in.
#-p  : promt
# I do not care what the key is.===#if [ "$?" -eq "0" ]; then
# I do not care what the key is.===#    echo 'A key was pressed.'
# I do not care what the key is.===#else
# I do not care what the key is.===#    echo 'No key was pressed.'
# I do not care what the key is.===#fi

TARGETFILE=$1;
#eval "exec 77>/home/op/.tmp/never_use_this_temporal_pipe_file.this_file_is_used_for_clojure_input";
echo "-----------------here normal";
#exec 3>never_use_this_temporal_pipe_file.this_file_is_used_for_clojure_input
echo "-----------------we can reach here";
screen -c $HOME/.tmp/screenrc -S myClojureIDE /bin/bash -c "exec 77>$LISTEN_PIPE; vim $1 -c \"map <F5> <Esc>:w<CR>:w! $LISTEN_PIPE <CR>\"";


#java -server -cp .:/home/op/bin/clojure/jline-1.0.jar:/home/op/bin/clojure/clojure-1.5.1.jar jline.ConsoleRunner clojure.main
#java -cp .:/home/op/bin/clojure/jline-1.0.jar:/home/op/bin/clojure/clojure-1.5.1.jar jline.ConsoleRunner clojure.main $@; #$* is same here
