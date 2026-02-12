# Pipewire Push-To-Mute

I've had it up to here dealing with shortcuts in wayland, so here's my little script for forcing vesktop to use push-to-mute by muting the audio input stream associated with it.

## Usage

You can adjust the audio stream this script hunts for by changing what the jq filter narrows down to. `wpctl status` and `wpctl inspect [id]` may be useful for this.

You may want to run evtest in the terminal so you can adjust the `$DEVICE` variable. If your input device does not appear, it may require root priviledges.

### Requirements

- pipewire & wireplumber
- jq
- evtest
- sudo (optionally)

### Runnning

```
./push-to-mute.sh
```