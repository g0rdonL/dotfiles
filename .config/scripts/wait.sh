#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# rclone mount --allow-other --vfs-cache-mode full --vfs-cache-max-age 999h --vfs-read-chunk-size 8M --cache-writes --daemon x:/ ~/x

# Run xidlehookp$R!ZDJS7QdZzZx
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Undim & lock after 10 more seconds` \
  --timer 300 \
    '~/.config/scripts/lock.sh & sleep 5 && xset dpms force off' \
    '' \
