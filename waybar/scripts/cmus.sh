#!/bin/bash

WIDTH=20

info=$(cmus-remote -Q 2>/dev/null)

status=$(echo "$info" | awk '/^status /{print $2}')
title=$(echo "$info" | sed -n 's/^tag title //p')

if [ -z "$title" ]; then
  file=$(echo "$info" | sed -n 's/^file //p')
  title=$(basename "$file" .mp3)
fi

if [ "$status" = "playing" ]; then
  icon=""
else
  icon=""
fi

# Don't scroll short titles
if [ ${#title} -le $WIDTH ]; then
  echo "$icon $title"
  exit
fi

STATE="$HOME/.cache/cmus-scroll"

mkdir -p "$(dirname "$STATE")"

offset=0
[ -f "$STATE" ] && offset=$(cat "$STATE")

scroll="$title   •   $title"
len=${#scroll}

visible="${scroll:$offset:$WIDTH}"

offset=$(((offset + 1) % len))
echo "$offset" >"$STATE"

echo "$icon $visible"
