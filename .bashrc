# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Setup Command History
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=15000
HISTCONTROL=ignoredups:ignorespace

# Keep window size updated
shopt -s checkwinsize

# Load bash files
for file in ~/.{prompt,aliases,functions,path,extra,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done

unset file;

