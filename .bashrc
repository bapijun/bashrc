############################################################
# Simple but Cute and Helpful (TM) Bash Settings
#
# cat feedback >> "bapijun@gmail.com"
############################################################

#!/usr/bin/env bash
# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# User Info

export USERNAME="wujun"
export NICKNAME="wujun"

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Distribute bashrc into smaller, more specific files

source ~/.shells/defaults
source ~/.shells/functions
source ~/.shells/exports
source ~/.shells/prompt   # Fancy prompt with time and current working dir
source ~/.shells/git      # Conveniences - Display current branch etc
source ~/.shells/alias    # Alias - your define
# Welcome message
echo -ne "Good Morning! It's "; date '+%A, %B %-d %Y'
echo
echo "Hardware Information:"
free -m # .bashrc





# Add z.sh fro automatic jump
# Maintains a jump-list of the directories you actually use
# https://github.com/rupa/z/blob/master/z.sh
. ~/.shells/z.sh
