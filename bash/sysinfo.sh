#!/bin/bash
#Display detailed information about a computer
#check for root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script requires root privileges. Please run as root."
    exit 1
fi

#Function to display a section
section_title() {
    echo ""
    echo "=== $1 ==="
    echo ""
}
#function to handle errors on computer
handle_error() {
    local exit_code=$1
    local error_message=$2

    echo "Error: $error_message"
    exit $exit_code
}

#Function to get system information
get_system_info() {
    section_title "System Description"
    lshw_out=$(lshw 2>/dev/null)
    [ $? -ne 0 ] && handle_error 1 " Failed to retrieve system information."

    computer_manufacture=$(echo "$lshw_out" | awk -F': ' '/vendor:/ {print $2}')
    computer_model=$(echo "$lshw_out" | awk -F':' '/product:/ {print $2}')
    serial_number=$(echo "$lshw_out" | awk -F': ' '/serial:/ {print $2}')

    echo "Computer Manufacturer: $computer_manufacturer"
    echo "Computer Model: $computer_model"
    echo "Serial Number: $serial_number"
}

#function to get cpu info
get_cpu_info() {
    section_title "CPU Information"
    lscpu_out=$(lscpu 2>/dev/null)
    [ $? -ne 0 ] && handle_error 2 "Failed to retrieve CPU information."

     cpu_model=$(echo "$lscpu_out" | awk -F': ' '/Model name:/ {print $2}')
     cpu_architecture=$(echo "$lscpu_out" | awk -F': ' '/Architecture:/ {print $2}')
     cpu_cores=$(echo "$lscpu_out" | awk -F': ' '/Core\(s\) per socket:/ {print $2}')
     cpu_speed=$(echo "$lscpu_out" | awk -F': ' '/Max CPU frequency:/ {print $2}')

     #using lshw to get the cache info
     cache_info=$(lshw -class cache 2>/dev/null | awk '/size:/ {print $2}' | tr '\n' ' ')

    echo "CPU Model: $cpu_model"
    echo "CPU Architecture: $cpu_architecture"
    echo "CPU Maximum Speed: $cpu_speed"
    echo "Cache Sizes: $cache_info"
}

#function to get OS information
get_os_info() {
    section_title "Operating System Information"

    distro_info=$(lsb_release -a 2>/dev/null)
    [ $? -ne 0 ] && handle_error 3 " Failed to retrieve OS information."

    linux_distro=$(echo "$distro_info" | awk '/Distributor ID:/ {print $3}')
    distro_version=$(echo "$distro_info" | awk '/Release:/ {print $2}')

    echo "Linux Distro: $linux_distro"
    echo "Distro Version: $distro_version"
}

#function to get and display information of computer 
get_system_info
get_cpu_info
get_os_info
 
