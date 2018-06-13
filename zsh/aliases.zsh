# misc
alias vi='$(findFirstInstalled nvim vim vi)'
alias :q='exit'
alias tmux='/usr/bin/tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'
alias rl-zsh='. ~/.zshrc'
alias rl-x='xrdb -merge ~/.Xresources'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

# replacement aliases
if (( $+commands[prettyping] )) ; then
  alias ping="prettyping --nolegend"
fi

if (( $+commands[bat] )) ; then
  alias cat="bat"
fi

if (( $+commands[exa] )) ; then
  alias l="exa --tree"
  alias ls="exa"
  alias ll="exa"
  alias la="exa -laa"
fi
