#!/bin/bash

function vigir_field() {
    command=$1
    shift

    if [[ "$command" == "--help" || -z "$command" ]]; then
        _vigir_field_help
        return 0
    fi

    # check if first a ssh connection to thor-field is required/requested
    if [ $command = 'ssh' ]; then
        if [ $(hostname) = $WORKSPACE_FIELD_HOSTNAME ]; then
            echo "You are already on $WORKSPACE_FIELD_HOSTNAME!"
        else
            thor ssh $WORKSPACE_FIELD_HOSTNAME
        fi
    elif [ ! $(hostname) = $WORKSPACE_FIELD_HOSTNAME ]; then
        thor ssh $WORKSPACE_FIELD_HOSTNAME "thor field $command $@"

    # we are on thor-field
    else
        if [ $command == "start" ]; then
            thor screen start "field" "roslaunch vigir_mang_field_launch field.launch $@"
        elif [ $command == "stop" ]; then
            thor screen stop "field" "$@"
        elif [ $command == "show" ]; then
            thor screen show "field" "$@"
        elif [ -x "$WORKSPACE_SCRIPTS/${command}.sh" ]; then
            thor $command "$@"
        else
            $command "$@"
        fi
    fi

    return 0
}

function _vigir_field_commands() {
    local WORKSPACE_COMMANDS=("start" "stop" "show")

    commands=$(_vigir_commands)
    for i in ${commands[@]}; do
        if [ $i == "field" ]; then
            continue
        fi
        WORKSPACE_COMMANDS+=($i)
    done
    
    echo ${WORKSPACE_COMMANDS[@]}
}

function _vigir_field_help() {
    echo "The following commands are available:"

    commands=$(_vigir_field_commands)
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

function _vigir_field_complete() {
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
        COMPREPLY=( $( compgen -W "$(_vigir_field_commands)" -- "$cur" ) )
    fi
} &&
complete -F _vigir_field_complete vigir_field
