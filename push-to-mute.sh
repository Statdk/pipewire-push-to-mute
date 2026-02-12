#!/bin/bash

# Input device to watch
DEVICE="/dev/input/event3"

# Function to get the ID of discord's input stream
get_id() {
  # Dump pipewire's state and filter for our desired stream with jq
  local ID=$(pw-dump | jq '.[] 
    | select(.type=="PipeWire:Interface:Node" 
      and .info.props."application.process.binary"=="vesktop" 
      and .info.props."application.name"=="Chromium input") 
    | .id')

  # Return the ID
  echo "$ID"
}

# Make sure we're working by writing an ID to stdout
echo $(get_id)

# Continuously check for key presses
# Depending on the device you want to watch, this may require root
evtest "$DEVICE" | while read -r line; do
  # Slow down slightly for performance
  #sleep 0.05
  # Nevermind, this breaks it.
  # TODO is rewrite this to query evtest because dumping pipewire every mouse move event 
  #   isn't very nice to it.
  #   Alternatively, find a way to update $ID asyncronously


  # Check if key press matches
  if echo "$line" | grep -q "KEY_DELETE"; then
    # Grab the key state
    state=$(echo "$line" | awk '{print $NF}')
    # Grab the pipewire stream ID
    ID=$(get_id)

    # Check that $ID isn't empty
    [ -z "$ID" ] && continue

    # Toggle mute accordingly
    if [ "$state" = "1" ]; then
      wpctl set-mute "$ID" 1
    elif [ "$state" = "0" ]; then
      wpctl set-mute "$ID" 0
    fi

  fi
done
