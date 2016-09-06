#!/bin/bash

# Open a link from an IRC log
# 0 argument → open last link from log of channel which name is hardcoded
# 1 argument → open last link from specified channel (if filename can be matched)
# >=2 arguments → open last link posted on a line matching arguments 1 to $#:
#       - from log of hardcoded channel if first argument does not match a channel name
#       - from log of channel specified by $1 otherwise

url_regex="https?://\S+"
#\bhttps?://.*?\b"
prefix=~/.config/hexchat/scrollback/myNetwork/
file="$prefix#myChannel.txt"
if [ $# -eq 0 ]; then
    link=$(grep -oE "$url_regex" $file  | tail -1)
else
    declare -a keywords
    first_keyword_pos=1
    chan="$1"
    custom_chan_file="$prefix#$chan.txt"
    if [ -r $custom_chan_file ]; then
        let "first_keyword_pos += 1"
        file=$custom_chan_file
    fi
    index=$first_keyword_pos
    links=$(grep -E "$url_regex" $file)
    while [ $index -le $# ]
    do
        keywords[$index]=${!index}
        links=$(echo "$links" | grep -i ${keywords[$index]})
        let "index += 1"
    done
    link=$(echo "$links" | grep -oE "$url_regex" | tail -1)
    if [ -z "$link" ]; then
        echo "No matching link found in $file"
    fi
fi

if [ ! -z "$link" ]; then
    echo "Opening $link"
    xdg-open "$link"
fi
