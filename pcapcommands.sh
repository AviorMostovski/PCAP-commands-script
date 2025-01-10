#!/bin/bash

# Colors for user interaction
red='\033[0;31m'
blue='\033[0;34m'
green='\033[0;32m'
reset='\033[0m'

# Check if tshark is installed
if ! command -v tshark &> /dev/null; then
    echo -e "${red}Error: tshark is not installed.${reset}"
    echo -e "${blue}Installing tshark now...${reset}"

    # Install tshark based on the package manager
    if [[ -x "$(command -v apt)" ]]; then
        sudo apt update && sudo apt install -y tshark
    elif [[ -x "$(command -v yum)" ]]; then
        sudo yum install -y tshark
    elif [[ -x "$(command -v brew)" ]]; then
        brew install wireshark
    else
        echo -e "${red}Error: Package manager not supported. Please install tshark manually.${reset}"
        exit 1
    fi
    echo -e "${green}tshark has been installed!${reset}"
    echo
else
    echo -e "${green}tshark is already installed and will be used.${reset}"
    echo
fi

echo -e "${blue}"
echo "     _____"
echo "    /     \\"
echo "   | () () |"
echo "    \\  ^  /"
echo "     |||||"
echo "     |||||"
echo -e "${reset}"

echo -e "${blue}Welcome to Pcap Command Extractor by Avior Mostovski${reset}"
echo "----------------------------------------------------"
echo "This script will help you extract terminal commands from a pcap file."
echo "----------------------------------------------------"
echo

# Prompt user to input the pcap file path
echo -e "${blue}Enter the path to the pcap file:${reset}"
read -p "Here:   " pcap_file

# Check if the pcap file exists
if [ ! -f "$pcap_file" ]; then
    echo -e "${red}Error: File does not exist.${reset}"
    exit 1
fi

# Check if commands like 'whoami', 'pwd', 'ls', etc. exist in the pcap file
if [[ -z $(tshark -r "$pcap_file" -Y 'frame matches "whoami"' -T fields -e tcp.stream | sort | uniq | sort) ]]; then
    echo -e "${red}No commands were found in the pcap file.${reset}"
    exit 1
else
    echo -e "${green}Commands detected! Extracting them now...${reset}"
    echo

    # Define the output file name in the same directory as the pcap file
    output_file="$(dirname "$pcap_file")/extracted_commands.txt"

    # Clear the output file if it exists
    > "$output_file"

    # Notify user about extraction
    echo -e "${blue}Extracting commands and storing them in $output_file...${reset}"
    echo

    # Extract and display commands while saving them to the file
    for stream_id in $(tshark -r "$pcap_file" -Y 'frame matches "whoami"' -T fields -e tcp.stream | sort | uniq | sort); do
        # Extract only the command data and exclude packet info
        command_data=$(tshark -r "$pcap_file" -Y 'frame matches "whoami" || frame matches "pwd" || frame matches "ls" || frame matches "uname" || frame matches "ifconfig" || frame matches "ipconfig"' -z follow,tcp,ascii,$stream_id | sed -n '/PS /,/^$/p' | sed 's/^.*=== //')

        # Display only the commands (exclude packet details)
        if [[ -n "$command_data" ]]; then
            echo -e "${green}$command_data${reset}"

            # Write the commands to the output file
            echo "$command_data" >> "$output_file"
        fi
    done

    echo -e "${green}Commands have been extracted to $output_file.${reset}"
    echo
    echo -e "${blue}Extraction complete!${reset}"
fi

# Copyright (c) 2025 Avior Mostovski. All Rights Reserved.
