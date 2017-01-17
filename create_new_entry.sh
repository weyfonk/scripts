#!/bin/bash

# Creates a new journal entry for the current date, and opens it with
# Vim if available, otherwise with the default editor.
# If an additional parameter is specified, then the file is not opened,
# which can be useful for further automation.

# If Vim is available, it is used to open the new journal entry in
# a split window beside the currently focused file. This is useful in
# my workflow when writing the current day's journal entry while 
# keeping an eye on the previous day's entry.
# However, this requires Vim to be compiled with the `clientserver`
# feature enabled.
# If this feature is disabled, the new entry is simply opened in a new
# Vim instance.

dat=$(date +%F)
tim=$(date +%T)
dat_filename=$(date +%Y%m%d)
year=$(date +%Y)

metadata="[[!meta title=\"Journal entry $dat\"]]\n[[!meta date=\"$dat $tim\"]]"
dir="log/$year"
file_name="$dir/log-$dat_filename.mdwn"
vim_server_name=JOURNAL

# Specify a project code as first argument to create a journal entry
# dedicated to that project (morning: 4h, afternoon: 4h)
if [ $# -eq 1 ]; then proj_code="$1 (~4h):"; else proj_code=''; fi

if [ ! -d "$dir" ]
then
    mkdir "$dir"
    echo "Created folder $dir."
fi

if [ -e $file_name ]
then 
    echo "Achtung! File $file_name already exists."
    echo "Rename it, delete it, or get ready for data loss."
else
    echo -e $metadata > $file_name 
    echo -e "\n\nMorning:\n\n* $proj_code" >> $file_name
    line_for_edit=$(wc -l $file_name | awk '{print $1}')
    echo -e "\n\nAfternoon:\n\n* $proj_code" >> $file_name
    echo -e "\n\n→ TODO:\n\n* " >> $file_name
    if [ $# -lt 2 ]
    then
        if [ -z $(which vim) ]
        then
            sensible-editor $file_name
        else
            if [ -z "$(vim --version | grep clientserver)" ]
            then
                vim +$line_for_edit $file_name
            else
                vim --servername $vim_server_name --remote-send ":sp $file_name <Enter>"
                vim --servername $vim_server_name --remote-send "$((line_for_edit))G"
            fi
        fi
    fi
    echo $file_name
fi
