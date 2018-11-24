#!/bin/bash

# Looks for the most recently created file which name matches the given pattern
# in the specified directory
pattern=log-*mdwn
dir=.
echo $(find "$dir" -type f -iname "$pattern" -printf "%T@ %p\n" | sort -n | tail -n 1 | awk '{print $2}')
