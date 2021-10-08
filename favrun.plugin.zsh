#!/usr/bin/env zsh

__favrun_usage() {
    echo "Usage: favrun [ -f | --file  ] [FILE] [ -s | --save ] [COMMANDNAME]  [COMMANDS]"
    return 1
}


__favrun_iterate() {
    local is_command block found=false commands newline=$'\n'

    [ ! -f "$1" ] && echo error file $1 does not exist && return 1

    # https://stackoverflow.com/a/12919766/6817191
    while read line || [ -n "$line" ]; do
        if [[ $line =~ "^#FAVRUN[[:space:]]+\b$2\b" ]]
        then
            if $found
            then
                echo "error, more than one instance of #FAVRUN ${2}"
                return 1
            else
                found=true
                continue
            fi
        fi

        # no point in continuing if the next command was found
        [[ $line =~ "^#FAVRUN" ]] && $found &&  break;

        $found && commands="$commands$newline$line"

    done < $1

    # check if no commands found
    [ -z $commands ] && echo "error, ${2} is not present or is empty" && return 1

    # https://stackoverflow.com/a/2924755/6817191
    echo $(tput bold)the commands to run:$(tput sgr0)$commands
    echo $(tput bold)the results:$(tput sgr0)
    eval $commands

}

__favrun_save() {
    local filename="$1" command="$2"
    shift 2
    # https://stackoverflow.com/a/2421790/6817191
    # https://stackoverflow.com/a/18527247/6817191
    test "$(tail -c 1 "$filename" | wc -l)" -eq 0  && (echo -en '\n' >> $filename)
    echo "#FAVRUN ${command}" >> $filename
    echo "$@" >> $filename
}

__favrun_get_filename() {
    [ ! -z "$1" ] && echo -n "$1" && return
    [ ! -z "$FAVRUNFILE" ] && echo -n "$FAVRUNFILE" && return
    echo -n "favrun.txt"
}

favrun() {

    local filename="" commands save=false valid_arguments=$?

    # https://www.shellscript.sh/tips/getopt/
    local parsed_arguments=$(getopt -a -n favrun -o c:f:s --long command:,file:,save, -- "$@")
    [ "$valid_arguments" != "0" ] && __favrun_usage

    eval set -- "$parsed_arguments"
    
    while :
    do
        case "$1" in
            -f | --file)    filename=$2; shift 2 ;;
            -c | --command) command="$2"  ; shift 2 ;;
            -s | --save) save=true      ; shift   ;;
            # -- means the end of the arguments; drop this, and break out of the while loop
            --) shift; break ;;
            # If invalid options were passed, then getopt should have reported an error,
            # which we checked as valid_arguments when getopt was called...
            *) echo "Unexpected option: $1 - this should not happen."
                __favrun_usage ;;
        esac
    done

    filename=$(__favrun_get_filename "$filename"); 

    # if -s or --save, save the command
    $save && __favrun_save $filename $command $@
    
    # if not save, then run the command
    ! $save && __favrun_iterate $filename $command

}

# vim:ft=zsh:tw=80:sw=4:sts=4:et:foldmarker=[[[,]]]
