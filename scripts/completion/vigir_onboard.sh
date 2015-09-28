#!/bin/bash

function vigir_onboard() {
    command=$1
    shift

    if [[ "$command" == "--help" || -z "$command" ]]; then
        _vigir_onboard_help
        return 0
    fi

    # check if first a ssh connection to thor-onboard is required/requested
    if [ $command = 'ssh' ]; then
        if [ $(hostname) = $WORKSPACE_ONBOARD_HOSTNAME ]; then
            echo "You are already on $WORKSPACE_ONBOARD_HOSTNAME!"
        else
            thor ssh $WORKSPACE_ONBOARD_HOSTNAME
        fi
    elif [ ! $(hostname) = $WORKSPACE_ONBOARD_HOSTNAME ]; then
        thor ssh $WORKSPACE_ONBOARD_HOSTNAME "thor onboard $command $@"

    # we are on thor-onboard
    else
        if [ $command == "start" ]; then
            thor screen start "onboard" "roslaunch vigir_mang_onboard_launch onboard_all.launch $@"
        elif [ $command == "stop" ]; then
            thor screen stop "onboard" "$@"
        elif [ $command == "show" ]; then
            thor screen show "onboard" "$@"
        elif [ -x "$WORKSPACE_SCRIPTS/${command}.sh" ]; then
            thor $command "$@"
        else
            $command "$@"
        fi
    fi

    return 0
}

function _vigir_onboard_commands() {
    local WORKSPACE_COMMANDS=("start" "stop" "show")

    commands=$(_vigir_commands)
    for i in ${commands[@]}; do
        if [ $i == "onboard" ]; then
            continue
        fi
        WORKSPACE_COMMANDS+=($i)
    done
    
    echo ${WORKSPACE_COMMANDS[@]}
}

function _vigir_onboard_help() {
    echo "The following commands are available:"

    commands=$(_vigir_onboard_commands)
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

function _vigir_onboard_complete() {
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
        COMPREPLY=( $( compgen -W "$(_vigir_onboard_commands)" -- "$cur" ) )
    fi
} &&
complete -F _vigir_onboard_complete vigir_onboard
