#!/bin/bash

# Read in the version if given.
version=$1
keepRunning=true

# Detect the operating system
# Used from lab1
os_type=$(uname -s)

# Check if input is redirected from a file
if [ -p /dev/stdin ]; then
    while read -r threads deadline size; do
        if [[ "$threads" =~ ^[0-9]+$ ]] && \
           [[ "$deadline" =~ ^[0-9]+$ ]] && \
           [[ "$size" =~ ^[0-9]+$ ]]; then
            case $version in
            
                # First part of the assignment. 
                partA1)
                    if [[ "$os_type" == "MINGW32_NT" || \
                          "$os_type" == "MINGW64_NT" ]]; then
                        ./partA1.exe "$threads" "$deadline" "$size"
                    else
                        echo "Part A.1 only works on Windows."
                    fi
                    ;;
                
                # Part A2 
                partA2)
                    ./partA2 "$threads" "$deadline" "$size"
                    ;;
                
                # Part A3
                partA3)
                    ./partA3 "$threads" "$deadline" "$size"
                    ;;
                
                # For the bonus points. 
                partA4)
                    ./partA4 "$threads" "$deadline" "$size"
                    ;;
                
                # Default Case 
                *)
                    echo "Invalid version. Use partA1, partA2, partA3, partA4."
                    ;;
            esac
        else
            echo "Invalid input. Please provide three positive integers."
        fi
    done

# If not redirected, enter interactive mode
else
    while $keepRunning; do
        echo "Select an option:"
        echo "  1. Part A.1"
        echo "  2. Part A.2"
        echo "  3. Part A.3"
        echo "  4. Part A.4"
        echo "  5. Quit"
        read -p "Enter your choice [1-5]: " choice

        case $choice in
        
            # First part of the assignment. 
            # Asked the teacher and it looks like we are using MinGW. 
            1)
                if [[ "$os_type" == "MINGW32_NT" || \
                      "$os_type" == "MINGW64_NT" ]]; then
                    read -p "Enter threads: " threads
                    read -p "Enter deadline (sec): " deadline
                    read -p "Enter max int size: " size
                    if [[ "$threads" =~ ^[0-9]+$ ]] && \
                       [[ "$deadline" =~ ^[0-9]+$ ]] && \
                       [[ "$size" =~ ^[0-9]+$ ]]; then
                        ./partA1.exe "$threads" "$deadline" "$size"
                    else
                        echo "Invalid input. Positive integers only."
                    fi
                else
                    echo "Part A.1 only works on Windows (MinGW)."
                fi
                ;;
                
            # Part 2. 
            2)
                read -p "Enter threads: " threads
                read -p "Enter deadline (sec): " deadline
                read -p "Enter max int size: " size
                if [[ "$threads" =~ ^[0-9]+$ ]] && \
                   [[ "$deadline" =~ ^[0-9]+$ ]] && \
                   [[ "$size" =~ ^[0-9]+$ ]]; then
                    ./partA2 "$threads" "$deadline" "$size"
                else
                    echo "Invalid input. Positive integers only."
                fi
                ;;
                
            # Part 3. 
            3)
                read -p "Enter threads: " threads
                read -p "Enter deadline (sec): " deadline
                read -p "Enter max int size: " size
                if [[ "$threads" =~ ^[0-9]+$ ]] && \
                   [[ "$deadline" =~ ^[0-9]+$ ]] && \
                   [[ "$size" =~ ^[0-9]+$ ]]; then
                    ./partA3 "$threads" "$deadline" "$size"
                else
                    echo "Invalid input. Positive integers only."
                fi
                ;;
            
            # Bonus section of the assignment.
            4)
                read -p "Enter threads: " threads
                read -p "Enter deadline (sec): " deadline
                read -p "Enter max int size: " size
                if [[ "$threads" =~ ^[0-9]+$ ]] && \
                   [[ "$deadline" =~ ^[0-9]+$ ]] && \
                   [[ "$size" =~ ^[0-9]+$ ]]; then
                    ./partA4 "$threads" "$deadline" "$size"
                else
                    echo "Invalid input. Positive integers only."
                fi
                ;;
            
            # Exit the program. 
            5)
                echo "Exiting Program..."
                keepRunning=false
                ;;
            
            # Default Case 
            *)
                echo "Invalid choice. Please select 1-5."
                ;;
        esac
    done
fi
