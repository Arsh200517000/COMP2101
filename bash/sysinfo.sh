#!/bin/bash
# Store inportant information in variables
HOSTNAME=$hostname
FQDN=$(hostname --fqdn)
OS_NAME=$(lsb_release -d -s)
IP_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
DISK_SPACE=$(df -h / | awk 'NR==2 {print $4}')
#display the report using an output template
cat <<EOF
Report for $HOSTNAME
====================
FQDN: $FQDN
Operating System name and version name: $OS_NAME
IP Address: $IP_ADDRESS
Root Filesystem Free Space: $DISK_SPACE
====================
EOF
