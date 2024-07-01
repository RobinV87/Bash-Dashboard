#!/bin/bash

# file to store the to-do list
TODO_FILE="$HOME/todo_list.txt"

# ANSI color codes
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# function to display the menu
display_menu() {
    echo "To-Do List Menu:"
    echo "1. View To-Do List"
    echo -e "2. ${BLUE}Add Task${NC}"
    echo -e "3. ${RED}Remove Task${NC}"
    echo "4. Exit"
}

# function to view the to-do list
view_list() {
    if [[ ! -f "$TODO_FILE" ]]; then
        echo "No tasks found."
        return
    fi

    echo "To-Do list:"
    cat -n "$TODO_FILE"
}

# function to add a task to the to-do list
add_task() {
    echo -e "${BLUE}Enter the task you want to add:${NC}"
    read task
    echo "$task" >> "$TODO_FILE"
    echo -e "${BLUE}Task added.${NC}"
}

# function to remove a task from the to-do list
remove_task() {
    view_list
    if [[ ! -f "$TODO_FILE" ]]; then
        return
    fi

    echo -e "${RED}Enter the task number to remove:${NC}"
    read task_number
    if ! [[ "$task_number" =~ ^[0-9]+$ ]]; then
        echo "Invalid input, please enter a number."
        return
    fi

    sed -i "${task_number}d" "$TODO_FILE"
    echo -e "${RED}Task removed.${NC}"
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
            add_task
            ;;
        3)
            remove_task
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
