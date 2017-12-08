#Source outside files
[ -f ~/.bash_path ] && . ~/.bash_path
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_work ] && . ~/.bash_work

#source /usr/local/etc/bash_completion.d/password-store
export GEM_HOME=~/.gem/ruby
export GEM_PATH=$GEM_HOME/gems

# A lot is borrowed from from http://tldp.org/LDP/abs/html/sample-bashrc.html
#-------------------------------------------------------------
#  Automatic setting of $DISPLAY (if not set already).
#  This works for me - your mileage may vary. . . .
#  The problem is that different types of terminals give
#+ different answers to 'who am i' (rxvt in particular can be
#+ troublesome) - however this code seems to work in a majority
#+ of cases.
#--------------------------------------------------------------

function get_xserver ()
{
    case $TERM in
        xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d')''(' )
            XSERVER=${XSERVER%%:*}
            ;;
            aterm | rxvt)
            ;;
        esac
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER} || ${XSERVER} == $(hostname) ||
        ${XSERVER} == "unix" ]]; then
            DISPLAY=":0.0"      #Display on local host
    else
        DISPLAY=${XSERVER}:0.0  #Display on remote host
    fi
fi

TTY=$(tty)

export DISPLAY

#-------------------------------------------------------------
# Color Definitions
#-------------------------------------------------------------

#Set colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.

# Normal Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

NC='\033[m'               # Color Reset


ALERT=${BWhite}${On_Red} # Bold White on red background


#-------------------------------------------------------------
#Welcome & Goodbye  Message
#-------------------------------------------------------------
echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\
- DISPLAY on ${BRed}$DISPLAY${NC}"
echo -e "${BCyan}On TTY ${BRed}${TTY:5}${NC}\n"

if [ -x /usr/local/bin/fortune ]; then
    /usr/local/bin/fortune -a -s
fi

wh_res=`type -t work_hello`
if [ -n "$wh_res" -a "$wh_res" = "function" ]; then
    echo
    work_hello
fi

function _exit()
{
    echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT


#-------------------------------------------------------------
# Shell Prompt - for many examples, see:
#       http://www.debian-administration.org/articles/205
#       http://www.askapache.com/linux/bash-power-prompt.html
#       http://tldp.org/HOWTO/Bash-Prompt-HOWTO
#       https://github.com/nojhan/liquidprompt
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    Green     == machine load is low
#    Orange    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Green     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').

# Get what is running
OS=$(uname -s)

# Test connection type:
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Green}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${Cyan}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
elif [[ ${USER} != $(logname) ]]; then
    SU=${BRed}          # User is not login user.
else
    SU=${Cyan}         # User is normal (well ... most of us are).
fi


if [ $OS == 'Darwin' ]; then
    NCPU=$(sysctl -a | grep 'machdep.cpu.core_count' | grep -o "[^ ]*$")    # Number of CPUs
else
    NCPU=$(grep -c 'processor' /proc/cpuinfo)
fi
SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load

# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load()
{
    if [ $OS == 'Darwin' ]; then
        local SYSLOAD=$(sysctl -n vm.loadavg | cut -d " " -f2 | tr -d '.')
    else
        local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
    fi
    # System load of the current host.
    echo $((10#$SYSLOAD))       # Convert to decimal.
}

# Returns a color indicating system load.
function load_color()
{
    local SYSLOAD=$(load)
    if [ ${SYSLOAD} -gt ${XLOAD} ]; then
        echo -en ${ALERT}
    elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
        echo -en ${Red}
    elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
        echo -en ${Yellow}
    else
        echo -en ${Green}
fi
}

# Returns a color according to free disk space in $PWD.
function disk_color()
{
    if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}
        # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" |
            awk 'END {print $5}' | cut -d "%" -f1) 
        if [ ${used} -gt 95 ]; then
            echo -en ${ALERT}           # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${BRed}            # Free disk space almost gone.
        else
            echo -en ${Green}           # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
    fi
}

# Returns a color according to running/suspended jobs.
function job_color()
{
    if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${BRed}
    elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${BCyan}
    fi
}

#Check if git repository and print current branch
GIT_PROMPT=1
function git_branch()
{
    #Sometimes the takes a long time, set GIT_PROMPT = 0 to stop it
    if [ $GIT_PROMPT -eq 1 ]; then
        git rev-parse --git-dir > /dev/null 2>&1
            if [ $? -eq 0 ];then
            if [  $(git status --porcelain | wc -l) -gt "0" ];then
                echo -en ${BPurple}
            else
                echo -en ${Blue}
            fi
            GIT_BRANCH=$(git status | grep "On branch" | cut -d" " -f3)
            echo -en "(${GIT_BRANCH}) "
        fi
    fi
}

# Adds some text in the terminal frame (if applicable).


# Now we construct the prompt.
PROMPT_COMMAND="history -a"
case ${TERM} in
    *term* | rxvt | linux | screen*)
        PS1="\[\$(load_color)\][\A\[${NC}\] "
        # Time of day (with load info):
        PS1="\[\$(load_color)\][\A\[${NC}\] "
        # User@Host (with connection type info):
        PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] "
        # PWD (with 'disk space' info):
        PS1=${PS1}"\[\$(disk_color)\]\W]\[${NC}\] "
        # Current Git Branch if applicable
        PS1=${PS1}"\[\$(git_branch)\]\[${NC}\]"
        # Prompt (with 'job' info):
        PS1=${PS1}"\[\$(job_color)\]>\[${NC}\] "
        # Set title of current xterm:
        PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"
        ;;
    *)
        PS1="(\A \u@\h \W) > " # --> PS1="(\A \u@\h \w) > "
                               # --> Shows full pathname of current dir.
        ;;
esac


export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts
export CUTE_BATTERY_INDICATOR=1

#FUNCTIONS

#ta - tmux attach - attach session from line $1 (zero indexed)
function ta()
{
    session_name=$(tmux ls | sed -n $(($1 + 1))p | cut -d':' -f1)    
    tmux attach -t "$session_name"
}
