#!bin/bash
#System Report Script: systeminfo.sh

#function libarary
source "$(dirname "$0")/reportfunctions.sh"

#Function to display a help
display_help() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -h Display help and exit"
    echo "  -v Run verbosely, showing errors to the user"
    echo "  -system Run only the computerreport, osreport, cpureport, ramreport, and videoreport"
    echo "  -disk Run only the diskreport"
    echo " -network Run onlt the networkreport"
    exit 0
}

#check for root permission
if [ "$(id -u)" -ne 0 ]; then
 errormessage "Root permissions are required. Please run the script as root."
fi

#parase command line options
while getopts ":hvsdn" opt; do
    case $opt in
        h) display_help ;;
        v) VERBOSE=true ;;
        s) OPTION_SYSTEM=true ;;
        d) OPTION_DISK=true ;;
        n) OPTION_NETWORK=true ;;
        \?) errormessage "Invalid option: -$OPTARG. Use -h for help." ;;
    esac
done

#Default behavioir: Run all functions for result
if [ "$OPTION_SYSTEM" != true ] && [ "$OPTION_DISK" != true ] && [ "$OPTION_NETWORK" != true ]; then
    OPTION_SYSTEM=true
    OPTION_DISK=true
    OPTION_NETWORK=true
fi

#Run functions based on options on computer
if [ "$OPTION_SYSTEM" == true ]; then
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
fi

if [ "$OPTION_DISK" == true ]; then
    diskreport
fi

if [ "$OPTION_NETWORK" == true ]; then
    networkreport
fi

