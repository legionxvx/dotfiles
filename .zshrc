autoload -Uz compinit promptinit up-line-or-beginning-search down-line-or-beginning-search
compinit -i
promptinit
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

kitty + complete setup zsh | source /dev/stdin

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

SAVEHIST=2000
HISTFILE=$HOME/.zsh_history

setopt prompt_subst

# This will set the default prompt to the walters theme
# prompt walters

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# Set up keys
[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -- "${key[Insert]}"        overwrite-mode
[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"     backward-delete-char
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-beginning-search
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-beginning-search
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"          backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"         forward-char
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}"     ]] && bindkey -- "${key[Shift-Tab]}"     reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo -n "${ref#refs/heads/} "
}

PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{white}$(git_current_branch)%F{blue}%B%~%b%f %# '

# Plugins
if [[ -d "$HOME/src/zsh-z/" ]] then
  source $HOME/src/zsh-z/zsh-z.plugin.zsh
fi

# Stupid dev stuff
if [[ $(basename $PWD) == "ardour" ]] then
  export TOP="$HOME/src/ardour"
fi

if [[ $(basename $PWD) == "mixbus" ]] then
  export TOP="$HOME/src/mixbus"
fi

# Export ardour build libs etc.
if [[ -d $TOP ]]; then
  source "$TOP/build/gtk2_ardour/ardev_common_waf.sh"
fi

# Aliases
if [[ -x "/bin/imv" ]] then
  alias mv="imv"
fi

alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
