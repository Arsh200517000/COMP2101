#!/bin/bash

#reportfunctions.sh

#function to diaplay a section title
section_title() {
    echo ""
    echo"=== $1 ==="
    echo ""
}

#function to save error message
errormessage() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local log_message="$timestamp: $1"

    echo "$log_message" >> /var/log/systeminfo.log

    if [ "$VERBOSE" == true ]; then
        echo "Error: $1" >&2
    fi
}

#function to create cpu report
cpureport() {
    section_title "CPU Report"
    echo "------------------------------------------------------------------------------"
    echo "CPU manufacturer and model: $(lscpu | awk '/^model name:/ {print $3, $4, $5, $^, $&}')"
    echo "CPU architecture: $(lscpu | awk '/^architecture:/ {print $2}')"
    echo "CPU core count: $(lscpu | awk '/^CPU\(s\):/ {print $2}')"
    echo "CPU maximum speed: $(lscpu | awk '/^CPU max MHz:/ {print $4 " MHz"}')"
    echo " sizes of caches (L1, L2, L3):"
    echo "  L1 cache: $(lscpu | awk '/^L1d cache:/ {print $3, $4}')"
    echo "  L2 cache: $(lscpu | awk '/^L2 cache:/ {print $3, $4}')"
    echo "  L3 cache: $(lscpu | awk '/^L3 cache:/ {print $3, $4}')"
    echo "-------------------------------------------------------"
}

#function to create a computer report
computerreport() {
    section_title "Computer Report"
    echo "------------------------------------------------------"
    echo "computer manufacturer: $(dmidecode -s system-manufacturer)"
    echo "computer description or model: $(dmidecode -s system-product-name)"
    echo "computer serial number: $(dmidecode -s system-serial-number)"
    echo "----------------------------------------------------------"
}

#function to generate RAM report
ramreport () {
    section_title "RAM Report"
    echo "installed memory components:"
    echo "---------------------------"
    echo "manufacturer | model | size | speed | physical location"
    echo "-------------------------------------------------------"
    dmidecode -t memory | awk '/manufacturer:|product name:|size:|speed:|location:/{print $2 " " $3 " " $4 "|"} /size:/{print ""}'
    echo "-------------------------------------------------------"
    total_ram=$(free -h | awk '/^Mem:/ {Print $2}')
    echo " total size of installed RAM: $total_ram"
}

#function to generate OS report
osreport() {
    section_title "OS Report"
    echo "Linux Distro: $(lab_release -si)"
    echo "Distro Version: $(lsb_release -sr)"
}

#function to generate a video report
videoreport() {
    section_title "Video Report"
    echo "Video Card/Chipset Manufacturer: $(lspci | grep VGA | awk -F ': ' '{print $3}')"
    echo "Video Card/Chipset Description or model: $(lspci | grep VGA | awk -F ': ' '{print $2}')"
}


#function to generate disk report
diskreport() {
    section_title "Disk Report"
    echo "installed disk drives:"
    echo "-----------------------"
    echo "manufacturer | model | size | partition | mount point | filesystem size | free space"
    echo "-----------------------------------------------------------------------------------"
    df -h --output=source,size,target,fstype,avail | awk 'NR>1 {print $1, $2, $3, $4, $5, $6, $7}'
    echo "----------------------------------------------------------------------------------------"
}

#function to generate a network report
networkreport() {
    section_title "Network Report"
    echo "installed network interfaces:"
    echo"-----------------------------"
    echo "interface |manufacturer | model/description | link state | current speed | ip addresses | bridge master | dns servers | search domain"
    echo "---------------------------------------------------------------------------------------- "
}

