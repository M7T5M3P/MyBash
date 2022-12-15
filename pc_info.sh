#!/bin/bash
#declare all color needed
BLACK="<span color='#000000'>"
ORANGE="<span color='#fe712f'>"
GREEN="<span color='#2ffe71'>"
RED="<span color='#ff0000'>"
Y1="<span color='#9d9d00'>"
Y2="<span color='#b1b100'>"
Y3="<span color='#c4c400'>"
Y4="<span color='#d8d800'>"
Y5="<span color='#ebeb00'>"
Y6="<span color='#ffff00'>"
Y7="<span color='#ffff1a'>"
Y8="<span color='#ffff4d'>"
PURPLE="<span color=\"\#712ffe\">"
CYAN="<span color='#00ffff'>"
WHITE="<span color='#f2f3f4'>"
UNDERLINE=" <span style='text-decoration:underline'>"
CENTER="\t\t\t\t\t\t"
TAB="\t\t"
CLOSE="</span>"

#Function to get pc informations
pc_info() {
    # Host Details
    my_ips=$(ip -4 address | grep "inet " | grep -v "127.0.0.1" | awk '{printf $2" "}')
    my_os=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | sed 's/\"//g')
    my_kernel=$(uname -r)
    my_uptime=$(uptime|sed 's/^ *//g')
    # CPU Details
    my_cpu_model=`lscpu | grep "Model name" | awk -F: '{print $2}' | sed 's/^ *//g'`
    my_cpu_sockets=`lscpu | grep "Socket(s)" | awk -F: '{print $2}' | sed 's/^ *//g'`
    my_cpu_cores=`lscpu | grep "Core(s) per socket" | awk -F: '{print $2}' | sed 's/^ *//g'`
    my_cpu_lps=`lscpu | grep "^CPU(s)" | awk -F: '{print $2}' | sed 's/^ *//g'`
    # Memory
    my_mem_total=$(grep -m 1 -w 'MemTotal' /proc/meminfo | awk -F: '{print $2 / 1024 / 1024 }' | sed 's/^ *//g')
    my_mem_free=$(grep -m 1 -w 'MemFree' /proc/meminfo | awk -F: '{print $2 / 1024 / 1024 }' | sed 's/^ *//g')
    my_swap_total=$(grep -m 1 -w 'SwapTotal' /proc/meminfo | awk -F: '{print $2 / 1024 / 1024 }' | sed 's/^ *//g')
    my_swap_free=$(grep -m 1 -w 'SwapFree' /proc/meminfo | awk -F: '{print $2 / 1024 / 1024 }' | sed 's/^ *//g')
    GTK_THEME="Adwaita-dark"
    yad --center --width=650 --height=350 --button="YPA Home":0 --text="\
    $CENTER$WHITE Welcome $CLOSE $CYAN <b>$USER</b> $CLOSE to $CYAN <b>$HOSTNAME</b> $CLOSE\n\
    $RED$CENTER$CENTER$TAB$TAB$TAB$(upower -i $(upower -e | grep '/battery') | grep --color=never -E 'state|to\ full')$CLOSE\n\
    $TAB$TAB$WHITE Date : $CLOSE$WHITE `date` $CLOSE\n\
    $RED$CENTER$CENTER$TAB$TAB$TAB$(upower -i $(upower -e | grep '/battery') | grep --color=never -E 'percentage')$CLOSE\n\
    $TAB$Y1 █████████ $TAB User  :  $(whoami) $CLOSE\n\
    $TAB$Y2 █████████ $TAB WM  : $GDMSESSION $CLOSE\n\
    $TAB$Y3 █████████ $TAB OS  : $(head -n1 /etc/issue | cut -f 1 -d ' ') $CLOSE\n\
    $TAB$Y4 █████████ $TAB Kernel  : $(uname -r) $CLOSE\n\
    $TAB$Y5 █████████ $TAB Shell  : $USING $CLOSE\n\
    $TAB$Y6 █████████ $TAB Terminal  : $TERM $CLOSE\n\
    $TAB$Y7 █████████ $TAB Wifi  : $(nmcli -g common | grep -m 1 connected | awk '{print($4)}') $CLOSE\n\n\
    $TAB$ORANGE# Host Details  :$CLOSE\n\n$TAB$ORANGE $TAB-  IPv4 Address(es)  : $CLOSE$CYAN$my_ips$CLOSE\n\
    $TAB$ORANGE $TAB-  Hostname  : $CLOSE$CYAN $HOSTNAME$CLOSE\n\
    $TAB$ORANGE $TAB-  Operating System  : $CLOSE$CYAN $my_os $CLOSE\n\
    $TAB$ORANGE $TAB-  Uptime  : $CLOSE$CYAN $my_uptime $CLOSE\n\n\
    $TAB$GREEN# CPU Details  :$CLOSE\n\n$TAB$GREEN $TAB-  CPU Model  : $CLOSE$CYAN $my_cpu_model $CLOSE\n\
    $TAB$GREEN $TAB-  CPU Sockets  : $CLOSE$CYAN $my_cpu_sockets $CLOSE\n\
    $TAB$GREEN $TAB-  CPU Cores/Socket  : $CLOSE$CYAN $my_cpu_cores $CLOSE\n\n\
    $TAB$WHITE# Memory  :$CLOSE\n\n$TAB$WHITE $TAB-  Logical Processors  : $CLOSE$CYAN $my_cpu_cores $CLOSE\n\
    $TAB$WHITE $TAB-  Total Memory  : $CLOSE$CYAN $my_mem_total GiB $CLOSE\n\
    $TAB$WHITE $TAB-  Free Memory  : $CLOSE$CYAN $my_mem_free GiB $CLOSE\n\n\
    $TAB$PURPLE# Partition  :$CLOSE\n\n\
    $(df -hT $1 | tail -n +2 | awk '{printf "'${TAB}${TAB}'<span color=\"\#712ffe\">-  <u>%s</u>  '${CLOSE}' <span color=\"\#00ffff\">(%s - %s)  [%s/%s] '${CLOSE}'<span color=\"\#8248fe\"> \t%s '${CLOSE}'\n", $7, $1, $2, $4, $3, $6}')"
    if [ $? = 0 ]; then
        main_loop
    fi
}