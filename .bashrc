# ~/.bashrc: executed by bash(1) for non-login shells.

## You never know, especially with dash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

## If not running interactively, don't do anything
[ -z "$PS1" ] && return

## After each command check window size to update LINES and COLUMNS if needed
shopt -s checkwinsize

## Treat the same way echo \n and \013 
shopt -s xpg_echo

## Complex completion
#shopt -s extglob progcomp
#complete -d pushd
#complete -d rmdir
#complete -d cd

## Use less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

## Bookmarks : m1 to mark pwd, g1 to go back there, lma to list, mdump to save
alias m1='alias g1="cd `pwd`"'
alias m2='alias g2="cd `pwd`"'
alias m3='alias g3="cd `pwd`"'
alias m4='alias g4="cd `pwd`"'
alias m5='alias g5="cd `pwd`"'
alias m6='alias g6="cd `pwd`"'
alias m7='alias g7="cd `pwd`"'
alias m8='alias g8="cd `pwd`"'
alias m9='alias g9="cd `pwd`"'
alias mdump='alias|grep -e "alias g[0-9]"|grep -v "alias m" > ~/.bookmarks'
alias lma='alias | grep -e "alias g[0-9]"|grep -v "alias m"|sed "s/alias //"'
touch ~/.bookmarks
source ~/.bookmarks

## Linux
alias ipa="ip -br -c a"
alias ipr="ip -br -c route"
alias tdp="tcpdump -i eth0 -AA -XX -vvv -e -s0"
alias su="/usr/bin/sudo bash" # add in /etc/sudoers: thisusername ALL=(ALL) ALL
## Windows
alias tmux=~/bin/sixel-tmux
alias mlterm="~/bin/mlterm -u=true"
alias ping="/c/Windows/System32/ping"
alias psql="/c/Program\ Files/PostgreSQL/12/bin/psql.exe"
alias gnuplot="/c/msys64/mingw64/bin/gnuplot"
## Common
alias sixel-check="tput smglr|base64" # check if terminfo ok
alias sixel-test="echo 'G1BxIjE7MTs5MzsxNCMwOzI7NjA7MDswIzE7MjswOzY2OzAjMjsyOzU2OzYwOzAjMzsyOzQ3OzM4\nOzk3IzQ7Mjs3MjswOzY5IzU7MjswOzY2OzcyIzY7Mjs3Mjs3Mjs3MiM3OzI7MDswOzAjMCExMX4j\nMSExMn4jMiExMn4jMyExMn4jNCExMn4jNSExMn4jNiExMn4jNyExMH4tIzAhMTF+IzEhMTJ+IzIh\nMTJ+IzMhMTJ+IzQhMTJ+IzUhMTJ+IzYhMTJ+IzchMTB+LSMwITExQiMxITEyQiMyITEyQiMzITEy\nQiM0ITEyQiM1ITEyQiM2ITEyQiM3ITEwQhtc' | base64 -d" # check if tmux can be displayed
alias vi=vim
alias ll="ls -lhaF --time-style=long-iso --show-control-chars"
alias l="ls -lhart --color --time-style=long-iso"
alias d="ls --color"
#alias s="screen -RAad"
#alias xs="screen -x"
#alias wget='wget --referer="http://www.google.com" --header="Accept-Encoding: gzip,deflate" --header="Keep-Alive: 300"'

## Default file creation mask
umask 022

## Remap ctrl-c to ctrl-x to copy/paste with ctrl-c and ctrl-v, and disable ctrl-s/ctrl-q
stty intr ^X -ixon
#stty intr ^X
#stty erase ^?

## Set solarized directory colors
#eval `dircolors $HOME/.dir_colors`
#eval "`dircolors`"
eval `SHELL=/usr/bin/bash dircolors $HOME/.dircolors.solarized_256`

## protect against ^O exec on bracketed paste handling
bind 'set enable-bracketed-paste on'
bind -r "\C-o"

## On linux console, remote the virtual terminal on exit if was spawned 
#trap "sleep 3 && deallocvt" EXIT

## Functions

# sixel protection if not using a proper sixel-aware multiplexer like old
# versions of tmux which requires unrecognized OSC sequences to be wrapped with:
# DCS tmux; <sequence> ST
#  also all ESCs in <sequence> to be replaced with ESC ESC.
#  also tmux only accepts ESC backslash for ST.
# Better use a sixel-tmux than having to cat image.six | __tmux_guard()
#  since even with __tmux_guard, regular tmux sometimes eats text when data outstanding gets too large
# (width * height * 8 bytes)
__tmux_guard() { printf "\u1bPtmux;" ; sed 's:\x1b:\x1b\x1b:g' ; printf "\u1b\\"; }
# Dropbox + git
function cmg() { git commit -a -m '$@' && git push dropbox master && git push origin master ;}

# Detect the bottom of the screen without stty, read -s to avoid deplaying instead
function __bottom() {
  local pos
  ## Detect the cursor position
  IFS='[;' read -p $'\e[6n' -d R -a pos -rs || echo "failed with error: $? ; ${pos[*]}"
  ## add one to the 0-initiated x-pos (+ no offset), to give an error code at the bottom
  CURLN=$((${pos[1]} +1 ))
  if [ "$CURLN" -ge "$LINES" ] ; then return -1 ; fi
}

#### Environment exports

## Terminal: remind me if screen is there
if [ "$TERM" = "screen" ]; then
 STYLST=`screen -ls |grep \( | sed -e 's/^	//g' -e 's/	.*//g' -e 's/.*\.//g' |tr -s '\n' ' '`
 echo "[ screen is activated ]"
 export STYLST
fi

## Long/Short hostname: not on windows
#if [ -z "$MINGW_CHOST" ] ; then
  HOST=`hostname | sed -e 's/\..*//g'`
#else
# HOSTNAME=`/bin/hostname -f`
# HOST=`/bin/hostname -s 2 >/dev/null`
# if [ "$?" -eq "1" ] ; then
#  HOST=`hostname | sed -e 's/\..*//g'`
# fi
#fi

## On a real console, change the title
if [ -x /usr/local/bin/isatty ] ; then
#  echo -ne "\e]0;$HOST\007"
  echo -ne "\e]2;$HOST\a"
fi

## colorful prompt basic idea: previous error code, user name and directory in color
# There are no variables, both to keep in mind the monstrosity we are building
# (try to understand powerline in a minute) and to limit the features creep. 
#
# step 0: read https://en.wikipedia.org/wiki/ANSI_escape_code to understand!
# step 1: \[ : say to bash this does not matter for prompt length:
# step 2: \e[30m\e[41m : print in color (here black fg, red bg)
# step 3: \] : say to bash prompt length starts
# step 4: the message
# step 5: \[ : say to bash this does not matter for prompt length:
# step 6: \e[0m\ : reset the color to normal
# step 7: \e[31m\e[42m : print in "upcoming color" (here red fg, green bg) 
# step 8: \] : say to bash prompt length really start heres

# One line version, does not leave much space to type a command or reverse search:
#PS1='`if [ $? != 0 ]; then echo "\[\e[30m\e[41m\]$?!\[\e[0m\e[31m\e[42m\]▙ \[\e[0m\]" ; fi`\[\e[30m\e[42m\]\u@\h\[\e[0m\e[32m\e[43m\]▙\[\e[0m\e[30m\e[43m\]\w\[\e[0m\e[33m\]▙\[\e[0m\]\e[s $  '
# Multiline version, also need PROMPT_COMMAND multiline (= empty)
# 16 colors multiline: solarized red and green
#PS1='`if [ $? != 0 ]; then echo "\[\e[30m\e[41m\]$?!\[\e[0m\e[31m\e[42m\]▙ \[\e[0m\]" ; fi`\[\e[30m\e[42m\]\u@\h\[\e[0m\e[32m\e[43m\]▙\[\e[0m\e[30m\e[43m\]\w\[\e[0m\e[33m\]▙\[\e[0m\]\e7\n$ '
# 256 colors multiline pastelized with an initial timestamp and e23m to cancel italics e39 for default foreground, no thin date
#PS1='`RETURN=$?; if [ $RETURN != 0 ]; then printf "\[\e[4m\e[3m\e[2m\e[31m\]#%03d:\[\e[39m\]" $RETURN ; else printf "\[\e[4m\e[3m\e[2m\e[39m\e[2;48;2;215;215;175m\]#    \[\e[49m\]" ; fi` \D{%b-%d_%H:%M:%S}\[\e7\e[23m\e[22m\] \u@\h \e[1m\w\[\e[24m\]\n\[\e[3m\e[1m\e[2;48;2;215;215;175m\]# \[\e[0m\]'
# thin date on mintty
PS1='`RETURN=$?; if [ $RETURN != 0 ]; then printf "\[\e[4m\e[3m\e[2m\e[31m\e[2;48;2;215;215;175m\]#%03d:\[\e[39m\e[49m\]" $RETURN ; else printf "\[\e[4m\e[3m\e[2m\e[39m\e[2;48;2;215;215;175m\]#    \[\e[49m\]" ; fi`\[\e[38;22;18;89;75m\] \D{%b-%d_%H:%M:%S}\[\e7\e[0m\e[23m\e[22m\] \u@\h \e[1m\w\[\e[24m\]\n\[\e[3m\e[1m\e[2;48;2;215;215;175m\]#\[\e[0m\] '

# WONTFIX: \033[u (RCP) is not supported by mosh,
# so instead use ESC 7 for RCP, ESC 8 for SCP

## PS0 is executed before the command, and is used to avoid the accumulation of colors
# step 1: RCP: \033[u or \e8 : restore the cursor position saved in PS1 by SCP: \033[s or \e7 
# optional \e[2A: go 2 lines up (when at the bottom of the screen)
# step 2: \r : go to the beginning of line
# step 3: \e[3m replace the stop italics placeholder by \e[3m start italic, likewise for color
# it is mostly wishful thinking as this does not change the line attributes in mintty
# step : skip forward 21 chars (length of timestamp)
# step 4: \033[0K (EL) : erases from cusor to 1K=beginning of line, 0K=end of line, 2K=full line
# step 5: RCP: restore the cursor position saved
# step 4: \e[2m\e[3m\e[4m : toggle faint, italics, underline
# step 5: \D{---%b-%d_%H:%M:%S---} : print the timestamp
# step 6: \e[0m : toggle off everything
# step 7: \n : go down one line
# step 8 : \r : go to the begging of the line
# step 9 : \e[3m\e[2m# \n\e[0m : toggle italics, underline, display #, go back to normal
# One line version
#PS0="\e[u\e[1K\r\e[3m\D{%b-%d_%H:%M:%S}\e[0m \n"
# Multiline version with 1 timestamp : no need to detect bottom, etc
# cf https://github.com/mobile-shell/mosh/issues/726
#PS0="\e[s\e[2A\r\e[2K\e[3m\D{---%b-%d_%H:%M:%S---}\e[0m\e[u\r"
# Multiline version with 2 timestamps
#PS0="\e8\r\e[0m\e[21C\e[0K\e[3m\e[2m\D{,%b-%d_%H:%M:%S}\n\r\e[3m\e[2m# \n\e[0m"
# PS0 is executed right after the command, not before the display of the output
# so it is not possible to know if the command may reach the bottom of the screen.
# So instead of PS0, PROMPT_COMMAND check for the bottom and sets PS0 accordingly

## PROMPT_COMMAND is eval() before printing PS1 (which can't export variables)
# use it to check if the output length reaches the bottom:
# Monoline version
#PROMPT_COMMAND='__bottom && export PS0="\e[u\e[1K\r\e[3m\D{---%b-%d_%H:%M:%S---}\e[0m\n" || export PS0="\e[u\e[1T\e[1K\r\e[3m\D{---%b-%d_%H:%M:%S---}\e[0m\n" '
# Multiline version
# to have all # in grey and (outside sixel-tmux) a thin date on mintty with \[\e[38;22;18;89;75m\]
PROMPT_COMMAND='__bottom && export PS0="\e8\r\e[0m\e[21C\e[0K\e[2m\e[3m\e[4m\[\e[38;22;18;89;75m\D{,%b-%d_%H:%M:%S}\e[0m\n\n\r" || export PS0="\e8\e[2A\r\e[0m\e[21C\e[0K\e[2m\e[3m\e[4m\[\e[38;22;18;89;75m\D{,%b-%d_%H:%M:%S}\e[0m\n\n\r"'
# to only keep the current prompt in grey
#PROMPT_COMMAND='__bottom && export PS0="\e8\r\e[0m\e[21C\e[0K\e[2m\e[3m\e[4m\D{,%b-%d_%H:%M:%S}\e[0m\n\r\e[3m\e[2m#\n\e[0m" || export PS0="\e8\e[2A\r\e[0m\e[21C\e[0K\e[2m\e[3m\e[4m\D{,%b-%d_%H:%M:%S}\e[0m\n\r\e[3m\e[2m#\n\e[0m"'

# FIXME: should also intercept tab completion and bash internal commands like ;
# see if it is possible to trap completion attempts to clear the saved line
#PS0='`if [ $COMP_LINE ] ; printf "\e8xxxxxxxxx" fi`'
#PS0="`if [ $COMP_LINE ] ; printf "\e8\e[2K"; fi`"

export PS1 PS0 USERNAME ENV EDITOR VISUAL HISTCONTROL CLICOLOR PAGER LS_OPTIONS LANG LC_ALL LESS
USERNAME=`whoami`
ENV=$HOME/.bashrc
PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bins
HISTCONTROL=ignoredups
## In memory, only 10000
HISTSIZE=10000
## On disk, unlimited
HISTFILESIZE=-1
CLICOLOR=yes
GNUTERM="sixelgd size  1280,720 truecolor font arial 16"
PAGER="less -iMSx4 -FX"
LESS=-X
EDITOR=vi
VISUAL=vim
LS_OPTIONS='--color=auto'
#LANG=C
#LANG=en_EN.utf-8
LANG=C.UTF-8
LC_ALL=C.UTF-8
export PS0 PS1 USERNAME ENV PATH EDITOR HISTCONTROL HISTSIZE HISTFILESIZE CLICOLOR GNUTERM PAGER LESS EDITOR VISUAL LS_OPTIONS LANG LC_ALL

## Perl and Oracle
#PERL5LIB=~/perl/:~/perl/lib/perl5/site_perl
#ORACLE_HOME=~/.cpan/instantclient_10_2
#DYLIB_LIBRARY_PATH=~/.cpan/instantclient_10_2
#DYLD_LIBRARY_PATH=~/.cpan/instantclient_10_2
#export PERL5LIB ORACLE_HOME DYLD_LIBRARY_PATH DYLIB_LIBRARY_PATH

## For debugging : bash -x
#export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

## DBUS over ssh
#if [[ -n $SSH_CLIENT ]] ;then
##export DBUS_SESSION_BUS_ADDRESS=`cat /proc/$(/pidof roxterm)/environ | tr '\0' '\n' | grep DBUS_SESSION_BUS_ADDRESS | cut -d '=' -f2-`
#fi

## Source global definitions
#if [ -f /etc/bashrc ]; then
#        . /etc/bashrc
#fi
