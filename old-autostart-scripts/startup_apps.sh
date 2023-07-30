#!/bin/bash

# Call the functions in the desired order
main() {
    launch_vscode
    launch_thunderbird
    launch_spotify
    set_default_volume
    check_user_status
    delayed_login_loop
    simulate_play_button
    set_spotify_volume
    set_default_volume_back
    launch_google_chrome
    open_sound_volume_control
}

# Function to launch VSCode
launch_vscode() {
    code &
    sleep 1
}

# Function to launch Thunderbird mail client
launch_thunderbird() {
    thunderbird &
    sleep 1
}

# Function to launch Spotify
launch_spotify() {
    spotify &
    sleep 1
}

# Function to set default volume
set_default_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ 30% &
    sleep 1
}

# Function to check user status
check_user_status() {
    if loginctl user-status $(id -u) | grep -q "State: active"; then
        echo "User is active"
        return 0
    else
        echo "User is inactive"
        return 1
    fi
}

# Wait until user is logged in
delayed_login_loop() {
    while ! check_user_status; do
        sleep 4
    done
}



#Functions below this line are the ones that need to be ran after login



# Function to simulate pressing the "play" button in Spotify (identify and focus spotify window, press spacebar)
simulate_play_button() {
    spotify_window_id=$(xdotool search --onlyvisible --name "Spotify")
    xdotool windowactivate --sync "$spotify_window_id" key space &
    sleep 5
}

# Function to set the volume for Spotify (identify the sink # for spotify; can adjust the percentage as desired)
set_spotify_volume() {
    spotify_sink_input=$(pactl list sink-inputs | grep -B 17 -i "spotify" | grep -oP "Sink Input #\K\d+")
    pactl set-sink-input-volume "$spotify_sink_input" 30% &
    sleep 1
}

# Function to set default volume back to normal
set_default_volume_back() {
    pactl set-sink-volume @DEFAULT_SINK@ 100% &
    sleep 1
}

# Function to launch Google Chrome
launch_google_chrome() {
    google-chrome
    sleep 1
    xdotool key Tab Tab Tab Tab Return &
    sleep 2
}

# Function to open the sound volume control (using a manually created shortcut in Kubuntu Linux)
open_sound_volume_control() {
    xdotool key Escape keydown Super_L key v keyup Super_L
}

# Call the main function
main