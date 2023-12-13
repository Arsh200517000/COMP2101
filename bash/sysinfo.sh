#!/bin/bash
#Display information about a computer
#output template
output_template() {
    echo ""
    echo "Report for $hostname"
    echo "=============="
    echo "FQDN: $fqdn"
    echo "Operating system name and version: $os_name $os_version"
    echo "IP Address: $ip_address"
    echo "Root Filesystem Free Space: $root_fs_free_space"
    echo "=============="
    echo ""
}

#Get hostnae and domain name
hostname=$(hostname)
fdqn=$(hostname --fdqn)

#Get operating system information
os_info=$(cat /etc/os-release | grep -E 'PRETTY_NAME|VERSION_ID')
os_name=$(echo "$os_info" | grep -oP '(?<=PRETTY_NAME=")(.*?) (?=")')
os_version=$(echo "$os_info" | grep -oP '(?<=VERSION_ID=")(.?=")')

#Get IP Address
ip_address=$(ip route | awk '/default/ {print $9}')

#get root filesystem
root_fs_free_space=$(df -h / | awk 'NR==2 {print $4}')

#output the info
output_template

