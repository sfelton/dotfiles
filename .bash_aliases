#This file contains all the aliases that are loaded by ~/.bashrc

##########################
#        MOVEMENT        #
##########################
alias ..='cd ..'
alias ....='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

##########################
#      SIMPLICITY        #
##########################
alias c='clear'
alias cls='clear'
alias ls='ls -F'
alias ls1='ls -c1'
alias ll='ls -Fl'
alias lla='ls -Fla'
alias dir='ls -Alg'
alias tree="tree -C"
alias fuck='sudo $(history -p !!)'

#safe mode for rm, cp, and mv
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#Make PATH varialbes print nicely
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

##########################
#      APPLICATIONS      #
##########################
alias v='vim'

##########################
#        TMUX            #
##########################
alias tls='tmux list-sessions -F "#{line} | #S: #{session_windows} windows"'
alias tn='tmux new -s'
#ta is implimented as a function in .bashrc
alias screemux='echo TMUX;tmux ls;echo SCREEN; screen -ls'

##########################
#        BREW            #
##########################
alias brinfo='brew info'
alias brinstall='brew install'
alias bremove='brew remove'

##########################
#     COMMON MISTAKES    #
##########################
alias celar='clear'
alias cim='vim'

##########################
#     MISC ALIASES	 #
##########################
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias treefile='find . -exec file -b {} + | sort | uniq -c | sort -rn'
alias avassh='cat ~/.ssh/config | grep "host " | cut -d" " -f2-'
