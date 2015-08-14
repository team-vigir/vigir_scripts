#!/bin/bash

function vigir() {
    command=$1
    shift

    if [[ "$command" = "--help" || -z "$command" ]]; then
        _vigir_help
        return 0
    fi

    if [ -x "$WORKSPACE_SCRIPTS/${command}.sh" ]; then
        $WORKSPACE_SCRIPTS/${command}.sh "$@"
        return
    elif [ -r "$WORKSPACE_SCRIPTS/${command}.sh" ]; then
        source $WORKSPACE_SCRIPTS/${command}.sh "$@"
        return
    else
        echo "Unknown vigir command: $command"
        _vigir_help 
    fi

    return 1
}

function _vigir_commands() {
    local WORKSPACE_COMMANDS=()

    for i in `find $WORKSPACE_SCRIPTS/ -type f -name "*.sh"`; do
        command=${i#$WORKSPACE_SCRIPTS/}
        command=${command%.sh}
        if [[ "$command" == "completion/"* ]]; then
            continue
        elif [ -r $i ]; then
            WORKSPACE_COMMANDS+=($command)
        fi
    done
    
    echo ${WORKSPACE_COMMANDS[@]}
}

function _vigir_help() {
    echo "The following commands are available:"

    commands=$(_vigir_commands)
    for i in ${commands[@]}; do
        if [ -x "$WORKSPACE_SCRIPTS/$i.sh" ]; then
            echo "   $i"
        elif [ -r "$WORKSPACE_SCRIPTS/$i.sh" ]; then
            echo "  *$i"
        fi
    done

    echo
    echo "(*) Commands marked with * may change your environment."
}

function _vigir_complete() {
    local cur
    local prev

    if ! type _get_comp_words_by_ref >/dev/null 2>&1; then
        return 0
    fi

    COMPREPLY=()
    _get_comp_words_by_ref cur prev

    # vigir <command>
    if [ $COMP_CWORD -eq 1 ]; then
        if [[ "$cur" == -* ]]; then
            COMPREPLY=( $( compgen -W '--help' -- "$cur" ) )
        else
            COMPREPLY=( $( compgen -W "$(_vigir_commands)" -- "$cur" ) )
        fi
    fi

    # vigir command <subcommand..>
    if [ $COMP_CWORD -ge 2 ]; then
        case ${prev} in
            install)
                #COMP_CWORD=$((COMP_CWORD+1))                
                COMP_WORDS=( vigir install $cur )
                COMP_CWORD=2
                _vigir_install_complete
                ;;

            uninstall)
                #COMP_CWORD=$((COMP_CWORD+1))                
                COMP_WORDS=( vigir uninstall $cur )
                COMP_CWORD=2
                _vigir_uninstall_complete
                ;;

            launch)
                if [[ "$cur" == -* ]]; then
                    COMPREPLY=( $( compgen -W "--screen" -- "$cur" ) )
                fi

                COMP_WORDS=( roslaunch vigir_mang_onboard_launch $cur )
                COMP_CWORD=2
                _roscomplete_launch
                ;;

            make|update)
                COMP_WORDS=( roscd $cur )
                COMP_CWORD=1
                _roscomplete
                ;;

            master)
                COMPREPLY=( $( compgen -W "localhost $ROBOT_HOSTNAMES" -- "$cur" ) )
                ;;

            motion)
                #COMP_CWORD=$((COMP_CWORD+1))          
                COMP_WORDS=( vigir motion $cur )
                COMP_CWORD=2
                _vigir_motion_complete
                ;;

            perception)
                #COMP_CWORD=$((COMP_CWORD+1))          
                COMP_WORDS=( vigir perception $cur )
                COMP_CWORD=2
                _vigir_perception_complete
                ;;
                
            onboard)
                #COMP_CWORD=$((COMP_CWORD+1))          
                COMP_WORDS=( vigir onboard $cur )
                COMP_CWORD=2
                _vigir_onboard_complete
                ;;
                
            field)
                #COMP_CWORD=$((COMP_CWORD+1))          
                COMP_WORDS=( vigir field $cur )
                COMP_CWORD=2
                _vigir_field_complete
                ;;

            screen)
                COMPREPLY=( $( compgen -W "start stop show" -- "$cur" ) )
                ;;

            *)
                COMPREPLY=()             
                ;;
        esac
    fi
} &&
complete -F _vigir_complete vigir
