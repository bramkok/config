# Episode I: "The prompt_subst way"
# Also known as the Quick-Start-Way. Probably the simplest way to add
# vcs_info functionality to existing setups. You just drop a vcs_info call
# to your `precmd' (or into a `precmd_functions[]' entry) and include a
# single-quoted ${vcs_info_msg_0_} in your PS1 definition:

# precmd() { vcs_info }
# This needs prompt_subst set, hence the name. So:
# setopt prompt_subst
# PS1='%!-%3~ ${vcs_info_msg_0_}%# '

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
  [[ "$SSH_CONNECTION" != '' ]] && echo "%{$fg[yellow]%}%m%{$reset_color%} " || echo ''
}

# Echoes information about Git repository status when inside a Git repository
git_info() {
  local __PWD="$(pwd)" 
  local __HOME="${HOME}" 

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  if [ "$__PWD" = "$__HOME" ]
  then
    local GIT_LOCATION="" 
  else
    local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)} 
  fi

  local BLOCK_SYMBOL="▪"
  #local BLOCK_SYMBOL="■"
  local AHEAD="%{$fg[red]%}↑%{$reset_color%}"
  local BEHIND="%{$fg[cyan]%}↓%{$reset_color%}"
  local MERGING="%{$fg[magenta]%}MERGING%{$reset_color%}"
  local UNTRACKED="%{$fg[yellow]%}$BLOCK_SYMBOL%{$reset_color%}"
  local MODIFIED="%{$fg[red]%}$BLOCK_SYMBOL%{$reset_color%}"
  local STAGED="%{$fg[green]%}$BLOCK_SYMBOL%{$reset_color%}"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "\033[38;5;15m $GIT_LOCATION " )
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "\033[38;5;15m%{$reset_color%}" )
  echo "${(j::)GIT_INFO}"
}

# Use   as the non-root prompt character; # for root
# Change the prompt character color if the last command had a nonzero exit code
PS1='
 $(ssh_info)%{$fg[blue]%}%~%u $(git_info)
%(?.%{$fg[blue]%}.%{$fg[red]%})%(!.#.)%{$reset_color%} '
