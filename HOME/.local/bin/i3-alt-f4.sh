#!/bin/bash

WINDOW_COUNT=$(i3-msg -t get_tree | jq -r '.. | select(.focused? and .type=="workspace") | .nodes | length')

if [ "$WINDOW_COUNT" -eq 0 ]; then
	exec ~/.config/rofi/applets/bin/powermenu.sh
else
	i3-msg 'kill'
fi
