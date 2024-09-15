#!/bin/bash

# Read in the version if given. 
version=$1
keepRunning=true

# Check if the input is redirected from a file
if [ -p /dev/stdin ]; then
    while read -r threads deadline size; do
        if [[ "$threads" =~ ^[0-9]+$ ]] && [[ "$deadline" =~ ^[0-9]+$ ]] && \
           [[ "$size" =~ ^[0-9]+$ ]]; then
            case $version in
                partA1)
                    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
                        ./partA1.exe "$threads" "$deadline" "$size"
                    else
                        echo "Part A.1 only works on Windows."
                    fi
                    ;;
                partA2)
                    ./partA2 "$threads" "$deadline" "$size"
                    ;;
                partA3)
                    ./partA3 "$threads" "$deadline" "$size"
                    ;;
                partA4)
                    ./partA4 "$threads" "$deadline" "$size"
                    ;;
                *)
                    echo "Invalid version. Please specify partA1, partA2, partA3, or partA4."
                    ;;
            esac
        else
            echo "Invalid input. Please ensure three positive integers per line."
        fi
    done

# If not in redirected mode then we are in Interactive mode
else
    while $keepRunning; do
        echo "Select an option:"
        echo "1. Execute Part A.1"
        echo "2. Execute Part A.2"
        echo "3. Execute Part A.3"
        echo "4. Execute Part A.4 (Bonus)"
        echo "5. Quit"
        read -p "Enter your choice [1-5]: " choice

        case $choice in
            1)
                if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
                    read -p "Enter threads: " threads
                    read -p "Enter deadline (sec): " deadline
                    read -p "Enter max int size: " size
                    if [[ "$threads" =~ ^[0-9]+$ ]] && \
                       [[ "$deadline" =~ ^[0-9]+$ ]] && [[ "$size" =~ ^[0-9]+$ ]]; then
                        ./partA1.exe "$threads" "$deadline" "$size"
                    else
                        echo "Invalid input. Positive integers only."
                    fi
                else
                    echo "Part A.1 only works on Windows."
                fi
                ;;
            2)
                read -p "Enter threads: " threads
                read -p "Enter deadline (sec): " deadline
                read -p "Enter max int size: " size
                if [[ "$threads" =~ ^[0-9]+$ ]] && \
                   [[ "$deadline" =~ ^[0-9]+$ ]] && [[ "$size" =~ ^[0-9]+$ ]]; then
                    ./partA2 "$threads" "$deadline" "$size"
                else
                    echo "Invalid input. Positive integers only."
                fi
                ;;
            3)
                read -p "Enter threads: " threads
                read -p "Enter deadline (sec): " deadline
                read -p "Enter max int size: " size
                if [[ "$threads" =~ ^[0-9]+$ ]] && \
                   [[ "$deadline" =~ ^[0-9]+$ ]] && [[ "$size" =~ ^[0-9]+$ ]]; then
                    ./partA3 "$threads" "$deadline" "$size"
                else
                    echo "Invalid input. Positive integers only."
                fi
                ;;
            4)
                read -p "Enter threads: " threads
                read -p "Enter deadline (sec): " deadline
                read -p "Enter max int size: " size
                if [[ "$threads" =~ ^[0-9]+$ ]] && \
                   [[ "$deadline" =~ ^[0-9]+$ ]] && [[ "$size" =~ ^[0-9]+$ ]]; then
                    ./partA4 "$threads" "$deadline" "$size"
                else
                    echo "Invalid input. Positive integers only."
                fi
                ;;
            5)
                echo "Exiting."
                keepRunning=false
                ;;
            *)
                echo "Invalid choice. Please select 1-5."
                ;;
        esac
    done
fi
