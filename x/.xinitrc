#!/bin/sh

if [ -f ~/.Xresources ]; then
	xrdb -merge ~/.Xresources
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xset s off
xset -dpms
xset s noblank

setxkbmap -layout us -option caps:escape &

exec i3
