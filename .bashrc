############################################################
# Simple but Cute and Helpful (TM) Bash Settings
#
# cat feedback >> "kirtika.ruchandani@gmail.com"
############################################################

#!/usr/bin/env bash
# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# User Info

export USERNAME="Kirtika Ruchandani"
export NICKNAME="rkirti"

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

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
. ~/.shells/z.sh
