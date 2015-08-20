# System aliases

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -laF'
alias la='ls -A'
alias l='ls -CF'

# jump around
alias ..='cd ..'

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# git aliases

# other handy stuff
alias diff='colordiff'
alias h='history'
alias j='jobs -l'
alias sha1='openssl sha1'

# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

# Use netstat command to quickly list all TCP/UDP port on the server:
alias ports='netstat -tulanp'

# Add safety nets
## do not delete / or prompt if deleting more than 3 files at a time
alias rm='rm -I --preserve-root'
 
## confirmation
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
 
## Parenting changing perms on /
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# System updates
## install with apt-get
alias apt-get="sudo apt-get"
alias updatey="sudo apt-get --yes"
 
## update on one command 
alias update='sudo apt-get update && sudo apt-get upgrade'

# become root #
alias root='sudo -i'
alias su='sudo -i'

# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# Control web servers
# also pass it via sudo so whoever is admin can reload it without calling you #
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias lightyload='sudo /etc/init.d/lighttpd reload'
alias lightytest='sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -t'
alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
alias httpdtest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'

# Get system memory, cpu usage, and gpu memory info quickly
## pass options to free
alias meminfo='free -m -l -t -h'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem3='ps auxf | sort -nr -k 4 | head -3'
 
## get top process eating cpu
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu3='ps auxf | sort -nr -k 3 | head -3'
 
## Get server cpu info
alias cpuinfo='lscpu'
 
## get GPU ram on desktop / laptop 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

# resume wgets
alias wget='wget -c'

# safer rm
alias rm='rm -i'
