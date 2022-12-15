#!/bin/bash

#declare color variables
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
CLOSE="<\/span>"

#Function message for the number of errors
message_norm() {
    if [ $MAJOR -ge 50 ]; then
        message="$GREEN#  Wha tu forces $MAJOR majeurs good luck ;)  #$CLOSE"
    elif [ $MAJOR -ge 10 ] && [ $MAJOR -lt 50 ]; then
        message="$GREEN#  Hmm ça fait mal mais tkt tu vas t'en sortir ;)  #$CLOSE"
    elif [ $MAJOR -ge 1 ] && [ $MAJOR -lt 10 ]; then
        message="$GREEN#  Aller ça va c'est pas tant que ça $MAJOR majeurs !  #$CLOSE"
    else
        message="$GREEN#  Bien joué 0 majeurs t'es chaud ;)  #$CLOSE"
    fi
    echo $message
}

#Function to modify norm file for yad
modify_file() {
    cp coding-style-reports.log tmp
    
    sed -i "s/hint:/hint/g" ./tmp
    sed -i "s/:[A-Z]/ C/g" ./tmp
    sed -i "s/:\ /<\/span>/g" ./tmp
    sed -i "s/^./$TAB$PURPLE <b>./g" ./tmp
    sed -i "s/:/<\/b>$CLOSE$TAB$ORANGE LIGNE =  /g" ./tmp
    sed -i "s/MAJOR/$TAB$RED MAJOR$CLOSE  :/" ./tmp
    sed -i "s/MINOR/$TAB$Y8 MINOR$CLOSE  :/" ./tmp
    sed -i "s/INFO/$TAB$CYAN INFO$CLOSE  :/" ./tmp
    norm_file=$(cat ./tmp)
    MAJOR=$(cat tmp | grep -o MAJOR | wc -l)
    MINOR=$(cat tmp | grep -o MINOR | wc -l)
    INFO=$(cat tmp | grep -o INFO | wc -l)
    message=$(message_norm $MAJOR $MINOR $INFO)
    yad --form --center --button="YPA Home":0 --button="Reload Norm":1 --field="\
    \n\n$CENTER$RED Majors  :  $MAJOR$CLOSE$TAB|$TAB$Y8 Minors  :  $MINOR$CLOSE$TAB|$TAB$CYAN Infos  :  $INFO$CLOSE\n\n
    $CENTER$message\n\n
    $TAB Prototype =>$PURPLE FILE $CLOSE$TAB|$TAB$ORANGE LIGNE $CLOSE$TAB|$TAB${RED}FA$CLOSE${ORANGE}UL$CLOSE${CYAN}TS $CLOSE$TAB|$TAB$WHITE TYPE OF FAULTS $CLOSE\n\n
    $norm_file\n\n":LBL --geometry 650x350 --scroll
    case $? in
        0)
            clear
            rm -f ./tmp ./coding-style-reports.log
            main_loop;;
        1)
            clear
            rm -f ./tmp ./coding-style-reports.log
            check_norm;;
    esac
}

#Function check sudo password
sudo_password() {
    password=$(yad --entry --entry-label="Enter sudo password" --hide-text)
    echo $password | sudo -S ~/coding-style-checker/coding-style.sh $1 .
    # if [ -f coding-style-reports.log ]; then
    #     modify_file
    # else
    #     sudo_password $1
    # fi
    
}

#Function to create file with norm errors if they are
check_norm() {
    DIRECTORY=$(yad --geometry=500x400+0+0 --button="Next":1 --form --field="Folder List:DIR" . | sed 's/|//')
    # cd $DIRECTORY
    # rm -f ./tmp ./coding-style-reports.log
    # cd -
    echo $DIRECTORY
    #sudo_password $DIRECTORY
}

#Function start mouli window
mouli_c() {
    found=$(find ~ -name coding-style-checker)
    if [ -z $found ]; then
        cd ~
        git clone https://github.com/Epitech/coding-style-checker.git
        cd -
    fi
    check_norm
}