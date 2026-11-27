# Useful history options:
# - https://www.soberkoder.com/better-zsh-history/
# - https://jdhao.github.io/2021/03/24/zsh_history_setup/
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000000
HISTFILESIZE=100000000000

setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
export HISTTIMEFORMAT="[%F %T] "

bindkey -e # emacs keybindings

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/g.clark/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# ISO Format Date
export TIME_STYLE=long-iso
# Aliases
alias ll="gls -lh" # Use coreutils ls to respect `TIME_STYLE`
alias g=git
alias gst="git status"
alias tf=terraform
# alias gitk="sed -i .bak 's/zoomed/normal/g' ~/.config/git/gitk && /usr/local/bin/gitk"
alias h1="history 1"
alias hrg='history 1 | rg'

mkcd() { mkdir -p -- "$1" && cd -P -- "$1"; }
rlcp() { greadlink -f "$1" | pbcopy }

s3head() {
    local uri=${1:-} lines=${2:-10} bucket prefix listing key

    if [[ $uri != s3://?*/* || $lines != <1-> ]]; then
        print -u2 -- 'Usage: s3head s3://bucket/prefix/ [lines]'
        return 2
    fi

    uri=${uri#s3://}
    bucket=${uri%%/*}
    prefix=${uri#*/}
    prefix=${prefix%/}

    listing=$(aws s3api list-objects-v2 --bucket "$bucket" \
        --prefix "${prefix:+$prefix/}part-" --delimiter / \
        --output json --no-cli-pager) || return

    key=$(jq -r '[.Contents[]? | select(.Key | endswith(".csv"))]
        | max_by(.LastModified) | .Key // empty' <<< "$listing") || return

    if [[ -z $key ]]; then
        print -u2 -- "No part-*.csv found under s3://$uri"
        return 1
    fi

    aws s3 cp "s3://$bucket/$key" - --only-show-errors | head -n "$lines"
}

# So that M-d jumps back by /levels/in/dir/paths
autoload -U select-word-style
select-word-style bash

# Kill word fn from https://unix.stackexchange.com/questions/250690/how-to-configure-ctrlw-as-delete-word-in-zsh
# Ctrl-w - delete a full WORD (including colon, dot, comma, quotes...)
my-backward-kill-word () {
    # Add colon, comma, single/double quotes to word chars
#   local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>:,"'"'"
    local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>:,"'"'"
    zle -f kill # Append to the kill ring on subsequent kills.
    zle backward-kill-word
}
zle -N my-backward-kill-word
bindkey '^w' my-backward-kill-word
#bindkey "\C-S-k" vi-kill-eol
bindkey '^[k' kill-line

# google-cloud-sdk auto-complete (from homebrew instructions)
# source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# Custom prompt
source ~/.dotfiles/zsh/.prompt.zsh

# K8s
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)
alias k=kubectl

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# eval "$(jenv init -)"

# Rancher Desktop
# $HOME/.rd/bin # From install ? Weird command
path+=('/Users/g.clark/.rd/bin')

# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:/Users/g.clark/Library/Application Support/Coursier/bin:$PATH"

# Auto Complete Passwordstore ?
if type brew &>/dev/null; then
	  FPATH=$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH

    autoload -Uz compinit
    compinit
  fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/gclark/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
