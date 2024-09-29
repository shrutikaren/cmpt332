#!/bin/bash

# Jack Donegan, Shruti Kaur
# lvf165, ich524
# 11357744, 11339265

# Check there is one only one input, piping doesn't count.
if [ $# -ne 1 ]
then
    echo "Invalid input."
    exit 1
fi

# No need to copy the function four times over.
if [[ "$1" == "partA1" || "$1" == "partA2" || \
    "$1" == "partA3" || "$1" == "partA4" ]] 
then
    # While on the lab assignment is was specified that $OS does not
    # work in the test environments, that hopefully only applies
    # to the linux test machines and not Windows.

    if [[ "$1" != "partA1" && "$OS" == "Windows_NT" ]]
    then
        echo "Cannot execute partA2-4 on Windows."
        exit 1
    else
        OS=$(uname -s)
    fi

    if [[ "$1" == "partA1" && "$OS" == "Linux" ]]
    then
        echo "Cannot execute partA1 on Linux."
        exit 1
    fi

    # Read over input until ctrl+d / newline is encountered.
    args=
    read args
    while [ ! -z "$args" ]
    do
        # Check number of arguments.
        arr=($args)
        if [ ${#arr[@]} -eq 3 ]
        then
            ./$1 $args
        else
            echo "Invalid number of arguements: $args"
        fi
        read args
    done
else
    echo "No valid executable specified."
fi
