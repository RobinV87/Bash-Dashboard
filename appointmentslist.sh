#!/bin/bash

# file to store the appointment list
FILE="$HOME/appointments.txt"

# ANSI color codes
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# function to display the menu
display_menu() {
    echo "Appointments Menu:"
    echo "1. View appointment List"
    echo -e "2. ${BLUE}Add appointment${NC}"
    echo -e "3. ${RED}Remove appointment${NC}"
    echo "4. Exit"
}

# function to view the appointment list
view_list() {
    if [[ ! -f "$FILE" ]]; then
        echo "No appointments found."
        return
    fi

    echo "Appointment list:"
    cat -n "$FILE"
}

# function to add an appointment to the appointment list
add_appointment() {
    echo -e "${BLUE}Enter the date of the appointment (DD-MM-YYYY):${NC}"
    read date
    if ! [[ "$date" =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
        echo "Invalid date format. Please use DD-MM-YYYY."
        return
    fi
    echo -e "${BLUE}Enter the time of the appointment (HH:MM):${NC}"
    read time
    if ! [[ "$time" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
        echo "Invalid time format. Please use HH:MM."
        return
    fi
    echo -e "${BLUE}Enter the appointment details:${NC}"
    read appointment
    echo "$date $time - $appointment" >> "$FILE"
    echo -e "${BLUE}Appointment added.${NC}"
}

# function to remove an appointment from the appointment list
remove_appointment() {
    view_list
    if [[ ! -f "$FILE" ]]; then
        return
    fi

    echo -e "${RED}Enter the appointment number to remove:${NC}"
    read appointment_number
    if ! [[ "$appointment_number" =~ ^[0-9]+$ ]]; then
        echo "Invalid input, please enter a number."
        return
    fi

    sed -i "${appointment_number}d" "$FILE"
    echo -e "${RED}Appointment removed.${NC}"
}

# main loop
while true; do
    display_menu
    read -p "Choose an option: " choice

    case $choice in
        1)
            view_list
            ;;
        2)
            add_appointment
            ;;
        3)
            remove_appointment
            ;;
        4)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
