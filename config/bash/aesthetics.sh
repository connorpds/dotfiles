
#PS1='\[\033[34m\]\h\[\033[1m\]𓆰\[\033[0m\]\w\n\[$(if [ $? -eq 0 ]; then echo "\[\033[1;34m\]𖤇"; else echo "\[\033[1;31m\]𖤇"; fi)\]\[\033[0m\]  '
PS1='\[\033[34m\]\h\[\033[1m\]𓆰\[\033[0m\]\w\n\'"[$(if [ $? -eq 0 ]; then echo '\[\033[1;34m\]𖤇'; else echo '\[\033[1;31m\]𖤇"'; fi)"'\[\033[0m\]  '
#PS1='\[\033[34m\]\h\[\033[1m\]𓆰\[\033[0m\]\w\n\'"[$(if [ $? -eq 0 ]; then echo '\[\033[1;34m\]>>'; else echo '\[\033[1;31m\]>>'; fi)"'\[\033[0m\]  '

#set highlighting for global wx-permissioned directories to dark grey
export LS_COLORS="tw=1;34;48;5;238:ow=1;34;48;5;238:$(echo $LS_COLORS | sed -E 's/(tw|ow)=[^:]*:?//g')"
#force terminal colors to xterm so tmux doesn't mess up my life 
export TERM="xterm-256color"
