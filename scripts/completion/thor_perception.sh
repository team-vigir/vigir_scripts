#!/bin/bash

function thor_perception() {
    command=$1
    shift

    if [[ "$command" == "--help" || -z "$command" ]]; then
        _thor_perception_help
        return 0
    fi

    # check if first a ssh connection to thor-perception is required/requested
    if [ $command = 'ssh' ]; then
        if [ $(hostname) = $WORKSPACE_PERCEPTION_HOSTNAME ]; then
            echo "You are already on $WORKSPACE_PERCEPTION_HOSTNAME!"
        else
            thor ssh $WORKSPACE_PERCEPTION_HOSTNAME
        fi
    elif [ ! $(hostname) = $WORKSPACE_PERCEPTION_HOSTNAME ]; then
        thor ssh $WORKSPACE_PERCEPTION_HOSTNAME "thor perception $command $@"

    # we are on thor-perception
    else
        if [ $command == "start" ]; then
            thor master "thor-motion"
            thor screen start "perception" "roslaunch thor_mang_onboard_launch perception.launch $@"
        elif [ $command == "stop" ]; then
            thor screen stop "perception" "$@"
        elif [ $command == "show" ]; then
            thor screen show "perception" "$@"
        elif [ -x "$WORKSPACE_SCRIPTS/${command}.sh" ]; then
            thor $command "$@"
        else
            $command "$@"
        fi
    fi

    return 0
}

function _thor_perception_commands() {
    local WORKSPACE_COMMANDS=("start" "stop" "show")

    commands=$(_thor_commands)
    for i in ${commands[@]}; do
        if [ $i == "perception" ]; then
            continue
        fi
        WORKSPACE_COMMANDS+=($i)
    done
    
    echo ${WORKSPACE_COMMANDS[@]}
}

function _thor_perception_help() {
    echo "The following commands are available:"

    commands=$(_thor_perception_commands)
    for i in ${commands[@]}; do       
        if [ $i == "start" ]; then
            echo "   $i"
        elif [ $i == "stop" ]; then
            echo "   $i"
        elif [ $i == "show" ]; then
            echo "   $i"
        elif [ -x "$WORKSPACE_SCRIPTS/$i.sh" ]; then
            echo "   $i"
        elif [ -r "$WORKSPACE_SCRIPTS/$i.sh" ]; then
            echo "  *$i"
        fi
    done

    echo
    echo "(*) Commands marked with * may change your environment."
}

function _thor_perception_complete() {
    local cur
    local prev

    if ! type _get_comp_words_by_ref >/dev/null 2>&1; then
        return 0
    fi

    COMPREPLY=()
    _get_comp_words_by_ref cur prev

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W "--help" -- "$cur" ) )
    else
        COMPREPLY=( $( compgen -W "$(_thor_perception_commands)" -- "$cur" ) )
    fi
} &&
complete -F _thor_perception_complete thor_perception
