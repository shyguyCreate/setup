#!/bin/sh

# Get volume value
volume="$(pactl get-sink-volume 0 | grep ^Volume | awk '{print $5}' | sed -e 's/%//')"
# Get if volume is muted
mute="$([ "$(pactl get-sink-mute 0 | awk '{print $2}')" = "yes" ] && printf " (muted)")"

# Send notification
notify-send "Volume: ${volume}%${mute}" -h int:value:"${volume}" -r 1000
