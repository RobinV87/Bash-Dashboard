#!/bin/bash

# Paths to your task, appointment, and weather files
TASKS_FILE="$HOME/todo_list.txt"
APPOINTMENTS_FILE="$HOME/appointments.txt"
WEATHER_FILE="$HOME/weather.txt"
LATITUDE="52.3702"  # Latitude for Almere
LONGITUDE="5.2141"  # Longitude for Almere

# Colors
COLOR_RESET="\033[0m"
COLOR_WHITE="\033[37m"
COLOR_BLUE="\033[34m"
COLOR_RED="\033[31m"

# Function to fetch weather
fetch_weather() {
    response=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LATITUDE}&longitude=${LONGITUDE}&current_weather=true")
    if [[ $? -ne 0 ]]; then
        echo "Failed to fetch weather data."
        return
    fi

    weather=$(echo "$response" | jq '.current_weather.weathercode' | tr -d '"')
    temp=$(echo "$response" | jq '.current_weather.temperature')

    # Interpret weather code (this is a simplified interpretation)
    case $weather in
        0) weather_desc="Clear sky" ;;
        1|2|3) weather_desc="Partly cloudy" ;;
        45|48) weather_desc="Fog" ;;
        51|53|55|56|57|61|63|65|66|67|80|81|82) weather_desc="Rain" ;;
        71|73|75|77|85|86) weather_desc="Snow" ;;
        95|96|99) weather_desc="Thunderstorm" ;;
        *) weather_desc="Unknown" ;;
    esac

    echo "Weather in Almere: $weather_desc, ${temp}°C" > "$WEATHER_FILE"
}

# Function to display date and time
display_date_time() {
    echo -e "${COLOR_WHITE}Date: $(date '+%Y-%m-%d')"
    echo -e "Time: $(date '+%H:%M:%S')${COLOR_RESET}"
    echo ""
}

# Function to display tasks
display_tasks() {
    echo -e "${COLOR_BLUE}Tasks:${COLOR_RESET}"
    if [[ -f "$TASKS_FILE" ]]; then
        cat "$TASKS_FILE"
    else
        echo "No tasks found."
    fi
    echo ""
}

# Function to display appointments
display_appointments() {
    echo -e "${COLOR_RED}Appointments:${COLOR_RESET}"
    if [[ -f "$APPOINTMENTS_FILE" ]]; then
        cat "$APPOINTMENTS_FILE"
    else
        echo "No appointments found."
    fi
    echo ""
}

# Function to display weather
display_weather() {
    echo -e "${COLOR_WHITE}Weather:${COLOR_RESET}"
    if [[ -f "$WEATHER_FILE" ]]; then
        cat "$WEATHER_FILE"
    else
        echo "Weather information not available."
    fi
    echo ""
}

# Fetch weather (you could set this up as a cron job instead to update periodically)
fetch_weather

# Display productivity dashboard
echo "---------------------"
echo "Productivity Dashboard"
echo "---------------------"
display_date_time
display_tasks
display_appointments
display_weather
