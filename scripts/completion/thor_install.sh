#!/bin/bash

function thor_install() {
    rosinstall=$1
    shift

    if [[ "$rosinstall" = "--help" || -z "$rosinstall" ]]; then
        _thor_install_help
        return 0
    fi

    if [ -r "$WORKSPACE_ROOT/rosinstall/optional/${rosinstall}.rosinstall" ]; then
        local LAST_PWD=$PWD
        cd $WORKSPACE_ROOT/src
        wstool merge ../rosinstall/optional/${rosinstall}.rosinstall
        cd $LAST_PWD
        return 0
    else
        echo "Unknown rosinstall file: $rosinstall"
        _thor_install_help 
    fi

    return 1
}

function _thor_install_files() {
    local WORKSPACE_ROSINSTALL_FILES=()
 
    for i in `find $WORKSPACE_ROOT/rosinstall/optional/ -type f -name "*.rosinstall"`; do
        file=${i#$WORKSPACE_ROOT/rosinstall/optional/}
        file=${file%.rosinstall}
        if [ -r $i ]; then
            WORKSPACE_ROSINSTALL_FILES+=($file)
        fi
    done
    
    echo ${WORKSPACE_ROSINSTALL_FILES[@]}
}

function _thor_install_help() {
    echo "The following rosinstall files are available:"
    files=$(_thor_install_files)
    for i in ${files[@]}; do
        echo "   $i"
    done
}

function _thor_install_complete() {
    local cur

    if ! type _get_comp_words_by_ref >/dev/null 2>&1; then
        return 0
    fi

    COMPREPLY=()
    _get_comp_words_by_ref cur

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W "--help" -- "$cur" ) )
    else
        COMPREPLY=( $( compgen -W "$(_thor_install_files)" -- "$cur" ) )
    fi

    return 0
} &&
complete -F _thor_install_complete thor_install
