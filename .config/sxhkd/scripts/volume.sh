#!/bin/sh

# Get volume value
volume="$(pactl get-sink-volume 0 | grep ^Volume | awk '{print $5}' | sed -e 's/%//')"
# Get if volume is muted
mute="$([ "$(pactl get-sink-mute 0 | awk '{print $2}')" = "yes" ] && printf " (muted)")"

if [ -n "$mute" ]; then
    icon="audio-volume-muted-symbolic"
else
    if [ "$volume" -le 30 ]; then
        icon="audio-volume-low-symbolic"
    elif [ "$volume" -le 60 ]; then
        icon="audio-volume-medium-symbolic"
    elif [ "$volume" -le 100 ]; then
        icon="audio-volume-high-symbolic"
    else
        icon="audio-volume-overamplified-symbolic"
    fi
fi

# Send notification
notify-send "Volume: ${volume}%${mute}" -h int:value:"${volume}" -i "${icon}" -r 1000 -t 2000 -u normal
