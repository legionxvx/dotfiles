#!/bin/sh

which imv > /dev/null 2>&1 && alias mv="imv"
which kitty > /dev/null 2>&1 && alias diff="kitty +kitten diff"
alias router="sensible-browser --new-tab $(ip r | awk 'NR==1{print $3}')"