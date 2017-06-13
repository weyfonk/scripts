#!/bin/bash

# Reopen all files which have a backup file in vim, with one file per tab.
# This script does deliberately not (yet?) handle subdirectories,
# and is meant to ease session recovery after an unexpected termination,
# following a crash, power outage, etc.
# Takes an optional directory parameter, otherwise checks the current
# directory.

# TODO: handle case with no backup files available (display errmsg instead
# of opening vim)
# TODO: add option to delete initial backup files, since new ones are
# created upon successful reopen

if [ $# -eq 1 ]
then
    dir=$1
else
    dir=.
fi

bkp_files=$(ls -a $dir/.*sw[nop])
vim_files=""
for f in $bkp_files
do
    base=$(basename $f)
    base=${base/%\.sw[nop]/} # remove extension
    base=${base/#\./}        # remove dot prefix
    vim_file=$(dirname $f)/$base
    vim_files="$vim_files $vim_file"
done

vim -p $vim_files
