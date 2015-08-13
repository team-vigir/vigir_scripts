#!/bin/bash

function thor_motion() {
    command=$1
    shift

    if [[ "$command" == "--help" || -z "$command" ]]; then
        _thor_motion_help
        return 0
    fi

    # check if first a ssh connection to thor-motion is required/requested
    if [ $command = 'ssh' ]; then
        if [ $(hostname) = $WORKSPACE_MOTION_HOSTNAME ]; then
            echo "You are already on $WORKSPACE_MOTION_HOSTNAME!"
        else
            thor ssh $WORKSPACE_MOTION_HOSTNAME
        fi
    elif [ ! $(hostname) = $WORKSPACE_MOTION_HOSTNAME ]; then
        thor ssh $WORKSPACE_MOTION_HOSTNAME "thor motion $command $@"

    # we are on thor-motion
    else
        if [ $command == "roscore" ]; then
            thor screen start "roscore" "roscore $@"
        elif [ $command == "start" ]; then
            thor screen start "motion" "roslaunch thor_mang_onboard_launch motion.launch $@"
        elif [ $command == "stop" ]; then
            thor screen stop "motion" "$@"
        elif [ $command == "show" ]; then
            thor screen show "motion" "$@"
        elif [ -x "$WORKSPACE_SCRIPTS/${command}.sh" ]; then
            thor $command "$@"
        else
            $command "$@"
        fi
    fi

    return 0
}

function _thor_motion_commands() {
    local WORKSPACE_COMMANDS=("roscore" "start" "stop" "show")

    commands=$(_thor_commands)
    for i in ${commands[@]}; do
        if [ $i == "motion" ]; then
            continue
        fi
        WORKSPACE_COMMANDS+=($i)
    done
    
    echo ${WORKSPACE_COMMANDS[@]}
}

function _thor_motion_help() {
    echo "The following commands are available:"

    commands=$(_thor_motion_commands)
    for i in ${commands[@]}; do       
        if [ $i == "roscore" ]; then
            echo "   $i"
        elif [ $i == "start" ]; then
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

function _thor_motion_complete() {
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
        COMPREPLY=( $( compgen -W "$(_thor_motion_commands)" -- "$cur" ) )
    fi
} &&
complete -F _thor_motion_complete thor_motion
