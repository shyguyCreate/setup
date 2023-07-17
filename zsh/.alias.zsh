#Shorten commands
alias \
    g='git' \
    cl='clear'

#Be verbose and interactive
alias \
    cp='cp -iv' \
    mv='mv -iv' \
    rm='rm -Iv' \
    mkdir='mkdir -pv'

#Aliases for ls
alias \
    ls='ls --color=auto --group-directories-first' \
    ll='ls -lh' \
    la='ls -A' \
    lla='ls -Alh'

#Add color
alias \
    grep='grep --colour=auto' \
    diff='diff --colour=auto'

#Change directory with special chars
alias \
    -='cd -' \
    ~='cd ~' \
    ..='cd ..' \
    ...='cd ../..' \
    ....='cd ../../..' \
    .....='cd ../../../..' \
    ......='cd ../../../../..'

#Use (dirs -v) to change directory
export DIRSTACKSIZE=10
alias \
    0='cd -0' \
    1='cd -1' \
    2='cd -2' \
    3='cd -3' \
    4='cd -4' \
    5='cd -5' \
    6='cd -6' \
    7='cd -7' \
    8='cd -8' \
    9='cd -9'

#Deal with space usage and memory
alias \
    df='df -h' \
    free='free -m'
