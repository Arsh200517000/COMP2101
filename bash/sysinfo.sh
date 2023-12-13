#!/bin/bash
#  sysinfo.sh -Display information about my computer

# Display FQDN using this commmand
echo "FQDN: $(hostname)"

# displays host information by using this command
echo "Host Information"
hostnamectl

# shows the computer ip addresses by this command
echo "IP Addresses:"
hostname -I | grep -V | '^127'

# shows root file system
echo "Root Filesystem Status:"
df -h /


