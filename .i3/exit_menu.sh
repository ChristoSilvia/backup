#!/bin/bash
while [ "$select" != "NOP" -a "$select" != "LOGOUT" -a "$select" != "SHUTDOWN" -a "$select" != "RESTART" ]; do
	select=$(echo -e 'NOP\nLOGOUT\nSHUTDOWN\nRESTART' | dmenu -nb '#151515' -nf '#999999' -sb '#f00060' -sf '#000000' -fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*' -i -p "You pressed the exit shortcut.  Options:")
	[ -z "$select" ] && exit 0
done
[ "$select" = "NOP" ] && exit 0
[ "$select" = "SHUTDOWN" ] && systemctl poweroff
[ "$select" = "RESTART" ] && systemctl reboot
i3-msg exit
