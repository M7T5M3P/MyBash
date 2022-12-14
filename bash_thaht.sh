#!/bin/bash
source create_c_project.sh
source create_cpp_project.sh

#declare variable to get result of th selected option with yad
OUTPUT_OPTION=""

#First Window Presentation of options
starting_window() {
	#declare option tab for yad
	option=( "Init C Project" "Init C++ Project" "Get PC Info" "Extra")
	declare -i id=0

	OUTPUT_OPTION=$(for element in "${option[@]}"
		do
			id+=1
			echo "FALSE"
			echo "${id}"
			echo "${element}"
		done | yad \
		--center \
		--width="500" \
        --height="400" \
		--list \
		--title="(YPA) $(date +%Hh%M)" \
		--text="Your Project Assistant\n" \
		--button=Cancel:1 --button=gtk-yes:0 \
		--radiolist --column="Select" --column="Id" --column="Option" \
		--print-column="2" --separator=" ")
	echo ${option[@]}
}

#Select if he realy wants to leave
leave_start_window() {
	yad --splash --question --text="You sure you want to stop creating your project ?" --button=No:0 --button=Yes:1
	if [ $? == 1 ]; then
		if [ $1 == "ok" ]; then
    		notify-send "Left safely"
		else
			notify-send "An error appears !"
		fi
	else
		main_loop
	fi
    exit 1;
}

#Function to check button pressed on window
check_choice() {
	case $? in
	1)
		leave_start_window "ok"
		;;
	0)
		case $1 in
		1)
			create_c_project
			exit 1
			;;
		2)
			create_cpp_project
			exit 1
			;;
		3)
			echo "3"
			;;
		4)
			echo "4"
			;;
		*)
			main_loop
			;;
		esac
    esac
}

main_loop() {
	starting_window
	check_choice $OUTPUT_OPTION
}

main_loop