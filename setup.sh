#!/usr/bin/env bash
#
# setup.sh - install .bashrc and .shells into $HOME
#
# Usage:
#   ./setup.sh            # install (backs up existing files)
#   ./setup.sh --force    # overwrite without prompting
#   ./setup.sh --no-backup
#   ./setup.sh --no-source
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FORCE=0
BACKUP=1
SOURCE=1

for arg in "$@"; do
	case "$arg" in
		--force)     FORCE=1 ;;
		--no-backup) BACKUP=0 ;;
		--no-source) SOURCE=0 ;;
		-h|--help)
			sed -n '2,12p' "$0"
			exit 0
			;;
		*)
			echo "Unknown option: $arg" >&2
			exit 1
			;;
	esac
done

# Self-conflict check.
# The install target is "$HOME/.bashrc" (a FILE), but this repo folder is also
# named ".bashrc". If the repo is placed at the home directory, then
# "$HOME/.bashrc" is a DIRECTORY and can never also be the real ~/.bashrc
# file that bash sources. Abort with guidance.
if [ -d "$HOME/.bashrc" ]; then
	home_bashrc_dir="$(cd "$HOME/.bashrc" && pwd)"
	if [ "$home_bashrc_dir" = "$SCRIPT_DIR" ]; then
		echo "ERROR: this repo is placed at \$HOME/.bashrc (a directory)." >&2
		echo "bash reads ~/.bashrc as a FILE, so the repo folder name conflicts." >&2
		echo "Move/clone it to a neutral name first, e.g.:" >&2
		echo "  mv \"$HOME/.bashrc\" \"$HOME/.dotfiles\" && cd \"$HOME/.dotfiles\" && ./setup.sh" >&2
		exit 1
	else
		echo "ERROR: \$HOME/.bashrc already exists and is a DIRECTORY (not this repo)." >&2
		echo "A file cannot replace a directory. Move it aside first, e.g.:" >&2
		echo "  mv \"$HOME/.bashrc\" \"$HOME/.bashrc.unused\"" >&2
		exit 1
	fi
fi

# Helpers
confirm_or_skip() {
	# $1 = path being replaced; returns 0 to proceed, 1 to skip
	[ "$FORCE" -eq 1 ] && return 0
	local ans
	read -r -p "$1 already exists. Overwrite? [y/N] " ans
	[[ "$ans" =~ ^[Yy]$ ]]
}

backup_if_needed() {
	# $1 = existing path to back up
	[ "$BACKUP" -eq 1 ] || return 0
	[ -e "$1" ] || return 0
	local bak="${1}.bak.$(date +%Y%m%d%H%M%S)"
	cp -a "$1" "$bak"
	echo "Backed up $1 -> $bak"
}

install_file() {
	local src="$1"
	local dst="$2"
	local name
	name="$(basename "$src")"
	if [ -e "$dst" ]; then
		confirm_or_skip "$dst" || { echo "Skipping $name"; return; }
		backup_if_needed "$dst"
	fi
	cp -a "$src" "$dst"
	echo "Installed $dst"
}

install_dir() {
	local src="$1"
	local dst="$2"
	local name
	name="$(basename "$src")"
	if [ -d "$dst" ] && [ "$(cd "$dst" && pwd)" = "$SCRIPT_DIR" ]; then
		echo "Skipping $dst (it is this repo itself)."
		return
	fi
	if [ -e "$dst" ]; then
		confirm_or_skip "$dst" || { echo "Skipping $name"; return; }
		backup_if_needed "$dst"
	fi
	rm -rf "$dst"
	cp -a "$src" "$dst"
	echo "Installed $dst"
}

# Install
install_file "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
install_dir  "$SCRIPT_DIR/.shells" "$HOME/.shells"

if [ "$SOURCE" -eq 1 ]; then
	echo "Sourcing ~/.bashrc ..."
	. "$HOME/.bashrc"
fi

echo "Done. Open a new shell or run: source ~/.bashrc"
