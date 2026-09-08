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


# Distribute bashrc into smaller, more specific files

source ~/.shells/defaults
source ~/.shells/functions
source ~/.shells/exports
source ~/.shells/git      # Conveniences - Display current branch etc
source ~/.shells/alias    # Alias - your define






# Add z.sh fro automatic jump
# Maintains a jump-list of the directories you actually use
# https://github.com/rupa/z/blob/master/z.sh
. ~/.shells/z.sh