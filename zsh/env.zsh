# path
path+=$HOME/bin
path+=$HOME/.local/bin
path+=$HOME/.config/bin

# node
export NODE_ENV='development'

# less
export LESS='-R'

# defaults
export OPENER=$(findFirstInstalled xdg-open exo-open gnome-open )
export BROWSER=$(findFirstInstalled firefox chromium chromium-browser qutebrowser google-chrome $OPENER )
export BROWSERCLI=$(findFirstInstalled w3m links2 links lynx elinks $OPENER )
export BROWSERTOR=$(findFirstInstalled tor-browser-en)
export EBOOKER=$(findFirstInstalled ebook-viewer $OPENER )
export EDITOR=$(findFirstInstalled nvim vim vi nano $OPENER )
export VISUAL=$(findFirstInstalled nvim vim vi nano $OPENER )
export FILEMANAGER=$(findFirstInstalled thunar nautilus dolphin spacefm enlightenment_filemanager $OPENER )
export FILEMANAGERCLI=$(findFirstInstalled ranger vifm mc $OPENER )
export MUSICER=$(findFirstInstalled mpv mplayer mpg123 cvlc $OPENER )
export PAGER=$(findFirstInstalled most less more)
export GIT_PAGER=$(getGitPagerCommand)
export PLAYER=$(findFirstInstalled mpv mplayer ffplay cvlc $OPENER )
export READER=$(findFirstInstalled zathura mupdf evince $OPENER )
export ROOTER=$(findFirstInstalled gksudo kdesudo )
export IMAGEVIEWER=$(findFirstInstalled feh ristretto display eog $OPENER )
export QUEUER=$(findFirstInstalled tsp fq ts )
export TERMER=$(findFirstInstalled urxvt xterm uxterm termite lxterminal terminator mate-terminal pantheon-terminal konsole gnome-terminal xfce4-terminal $OPENER )

# termcap
# ks       make the keypad send commands
# ke       make the keypad send digits
# vb       emit visual bell
# mb       start blink
# md       start bold
# me       turn off bold, blink and underline
# so       start standout (reverse video)
# se       stop standout
# us       start underline
# ue       stop underline

man() {
	env \
		LESS_TERMCAP_md=$'\e[1;36m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[1;40;92m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[1;32m' \
		PAGER="${commands[less]:-$PAGER} -s -M +Gg" \
		man "$@"
}

# tree
if [ $(command -v tree) ]; then
  alias tree='tree -C'
fi

# tmux
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins/"

# urxvt
export URXVT_PERL_LIB="$HOME/.config/urxvt/ext/"
