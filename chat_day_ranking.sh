#!/bin/bash

today_midnight=$(($(date -d 'today 00:00:00' +%s%3N)/1000))
file=~/.config/hexchat/scrollback/myNetwork/#myChannel.txt

res=$(awk -v midnight=$today_midnight '{ if ($2 >= midnight) print $0 }' $file)
echo "$res" | awk '{ if (match($3, "\*") != 0) print $4; else print $3 }' | sed -e 's/\W//g;s/18//g' | sort | uniq -c | sort -gr

