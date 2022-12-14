#declare name project

BINARY_NAME=""
LIB_BOOL=0
CLONED=0

#Function to clone github project
github_window() {
    option=$(yad --image dialog-question --center --width=500 --height=200 --title "C Project GitClone" --button=gtk-no:1 --button=gtk-yes:0 --text "Do you want to clone a repo github?")

    if [ $? == 0 ]; then
        repo_name=$(yad --entry --center --fixed --width=500 --height=200 --entry-label "Enter SSH key" --button=gtk-cancel:1 --button=gtk-ok:0 --entry-text="SSH key")
        name=$(yad --entry --center --fixed --width=500 --height=200 --text "Enter new directory name\n (You may left this empty it will get is default name)" --button=gtk-cancel:1 --button=gtk-ok:0)
        if [ -z $repo_name ]; then
            github_window
        else
            CLONED=1
            if [ -z $name ]; then
                git clone $repo_name
            else
                git clone $repo_name $name
            fi
        fi
    else
        CLONED=0
    fi
}

#Function to create src directory with wanted a main.c
create_src() {
    if [ $? == 0 ]; then
        mkdir src
        yad --image dialog-question --center --fixed --width=500 --height=200 --text "Do you want to create a file <b>main.c</b>?" --button=gtk-no:1 --button=gtk-yes:0
        if [ $? == 0 ] ; then
            cp c_structure/main.c src/
            sed -i 's/${PROJECT_NAME}/'$BINARY_NAME'/' ./src/main.c
        fi
    fi
}

#Function to create include directory with wanted a lib.h and PROJECT.h
create_include() {
    if [ $? == 0 ]; then
        mkdir include
        yad --image dialog-question --center --fixed --width=500 --height=200 --text "Do you want to create a file <b>"$BINARY_NAME".h</b>?" --button=gtk-no:1 --button=gtk-yes:0
        if [ $? == 0 ] ; then
            cp c_structure/lib.h include/$BINARY_NAME.h
            sed -i 's/${PROJECT_NAME_UP}/'${BINARY_NAME^^}'/' ./include/$BINARY_NAME.h
            sed -i 's/${PROJECT_NAME}/'$BINARY_NAME'/' ./include/$BINARY_NAME.h
        fi
    fi
}

#Function to create makefile file
create_makefile() {
    if [ $? == 0 ]; then
        echo $LIB_BOOL
        if [ $LIB_BOOL = 1 ]; then
            cp c_structure/Makefile_lib ./Makefile
        else
            cp c_structure/Makefile_nlib ./Makefile
        fi
        sed -i 's/${PROJECT_NAME}/'$BINARY_NAME'/' ./Makefile
        yad --image dialog-question --center --fixed --width=500 --height=200 --text "<b>CSFML</b> project?" --button=gtk-no:1 --button=gtk-yes:0
        if [ $? == 0 ] ; then
            sed -i 's/${CSFML_FLAG}/-lcsfml-graphics -lcsfml-audio -lcsfml-window -lcsfml-system -lcsfml-network/' ./Makefile
        else
            sed -i 's/${CSFML_FLAG}//' ./Makefile
        fi
    fi
}

#Function to insert a lib already in the pc
include_lib() {
    if [ $? == 0 ]; then
        select=$(yad --center --width=500 --height=200 --title "Select your lib" --file-selection)
        cp -rf $select .
        LIB_BOOL=1
    fi
}

#Function to set project directory (lib src include)
set_project() {
    BINARY_NAME=$(yad --entry --center --fixed --width=500 --height=200 --text "Enter binary name" --button=gtk-cancel:1 --button=gtk-ok:0)
    if [[ $BINARY_NAME == "" ]]; then
        main_loop
    fi           
    if [ ! -d "src" ]; then     
        yad --image dialog-question --center --width=500 --height=200 --title "Init C Project" --button=gtk-no:1 --button=gtk-yes:0 --text "Do you want to create a <b>src</b> directory ?"
        create_src
    else
        notify-send "Directory SRC already created"      
    fi                   
    if [ ! -d "include" ]; then 
        yad --image dialog-question --center --width=500 --height=200 --title "Init C Project" --button=gtk-no:1 --button=gtk-yes:0 --text "Do you want to create a <b>include</b> directory ?"
        create_include       
    else
        notify-send "Directory INCLUDE already created"   
    fi 
    if [ ! -d "lib" ]; then 
        yad --image dialog-question --center --width=500 --height=200 --title "Init C Project" --button=gtk-no:1 --button=gtk-yes:0 --text "Do you want to insert your lib ?"
        include_lib       
    else
        notify-send "Directory LIB already here"   
    fi 
    if [ ! -f "Makefile" ]; then
        yad --image dialog-question --center --fixed --width=500 --height=200 --title "Init C Project" --text "Do you want to create a file <b>Makefile</b>?" --button=gtk-no:1 --button=gtk-yes:0
        create_makefile
    else
        notify-send "MAKEFILE already exist"
    fi          
}

#Function display succesful message
done_project() {
    yad --info\
    --center --width=500 --height=200 \
    --wrap \
    --text="Project Created <span foreground='green'>Correctly</span> \nredirecting to YPA Panel"
    main_loop
}


#Function to create a c project
create_c_project() {
    github_window
    if [ $CLONED = 0 ]; then
        set_project
    fi
    done_project
}