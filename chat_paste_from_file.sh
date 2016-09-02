#!/bin/bash

# Small script to paste file contents into a HexChat window 
# and send that line by line
# Dependencies: xclip, xdotool

#set -o verbose
if [ "$#" -lt 1 ]; then
    echo "Usage: "$0" FILE"
    echo 'No file specified. Exiting.'
    exit 1
fi

file=$1

if [ ! -r "$file" ]; then
    echo 'File "$file" does not exist or is unreadable. Exiting.'
    exit 1
fi

exec<"$file" # use $file as input
# for some reason, specifying another desktop number doesn't work
win=$(xdotool search --sync --desktop 1 --class "HexChat")
xdotool windowactivate $win
eval $(xdotool getwindowgeometry -shell $win)
x=$(($X+$WIDTH/2)) # middle of window (X needed in case offset in multi-monitors setups)
y=$(($Y+$HEIGHT-10)) # rough location of text field (Y needed for same reason)
echo $x
echo $y
xdotool mousemove --sync $x $y
xdotool click 1
# Read each line, set the clipboard contents with it 
# and paste from the clipboard into the window
while read line
do
    echo "$line"
    len=${#line}
    if [ $len -eq 0 ]; then
        continue
    fi
    echo "$line" | xclip -selection clipboard
    xdotool key ctrl+v Return
done
