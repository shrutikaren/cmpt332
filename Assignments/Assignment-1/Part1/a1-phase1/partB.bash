#!/bin/bash

keepRunning=true

while $keepRunning; do
    
    # Read in our variables
    echo "Select an option:"
    echo "  1. Part A.1"
    echo "  2. Part A.2"
    echo "  3. Part A.3"
    echo "  4. Part A.4 (Bonus)"
    echo "  5. Quit"

    case $choice in 
        1)
            read -p "Enter number of threads: " threads
            read -p "Enter deadline (seconds): " threads
            read -p "Enter maximum integer size:: " threads

            if [[ "$threads" =~ ^[0-9]+$ ]] && [[ "$deadline" =~ ^[0-9]+$ ]] \
                && [[ "$size" =~ ^[0-9]+$ ]]; then
                ./partA1 "$threads" "$deadline" "$size"
            else
                echo "Sorry! Invalid input. Please try again."
            fi 
            ;;
       
        2)
            echo "Part A.2 (pthreads integers)"
            ;;

        3)
            echo "Part A.3 (pthreads integers)"
            ;;

        4)
            echo "Part A.4 (pthreads integers)"
            ;;

        5)
            echo "Exiting program."
            keepRunning=false
            ;;

        *) 
            echo "Invalid choic! Please choose from 1-5."
                
    esac

done



