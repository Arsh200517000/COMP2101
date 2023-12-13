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
    echo "CPU Core Count: $cpu_cores"
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
#Function to get RAM information of computer
get_ram_info() {
    section_title "RAM Information"
    ram_info=$(lshw -class memory 2>/dev/null)
    [ $? -ne 0 ] && handle_error 4 "Failed to retrive RAM information."

    echo ""
    echo "Installed Memory Components:"
    echo "---------------------------"
    echo "Manufacturer | Model | Size | Speed | Location"
    echo "---------------------------------------------"

    while IFS= read -r line; do
        manufacturer=$(echo "$line" | awk -F': ' '/vendor:/ {print $2}')
        model=$(echo "$line" | awk -F': ' '/product:/ {print $2}')
        size=$(echo "$line" | awk -F': ' '/size:/ {print $2}')
        speed=$(echo "$line" | awk -F': ' '/clock:/ {print $2}')
        location=$(echo "$line" | awk -F': ' '/slot:/ {print $2}')

        echo "$manufacturer | $model | $size | $speed | $location"
    done <<< "$(echo "$ram_info" | awk '/product:/ || /size:/ || /clock:/ || /slot:/')"

    echo "----------------------------------------------"
}

#Function to get the disk storage information of computer
get_disk_info() {
    section_title "Disk Storage Information"

    echo ""
    echo "Installed Disk Drives:"
    echo "-----------------------"
    echo "Manufacturer | Model | Size | Partition | Mount Point | Filesystem Size | Free Space"
    echo "------------------------------------------------------------------------------------"

    lsblk -o NAME,VENDOR,MODEL,SIZE,MOUNTPOINT -p -e 7,11 -nr | while read -r name vendor model size mount_point; do
        filesystem_size=$(df -h | awk -v mount="$mount_Point" '$6==mount {print $2}')
        free_space=$(df -h | awk -v mount="$mount_point" '$6==mount {print $4}')

        echo "$vendor | $model | $size | $mount_point | $filesystem_size | $free_space"
    done

    echo "----------------------------------------------------------------------------------"
}
#function to get and display information of computer
get_system_info
get_cpu_info
get_os_info
get_ram_info
get_disk_info
