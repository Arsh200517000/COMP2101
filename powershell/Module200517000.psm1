# Module200517000.psm1
# Function to get system information
function Get-SystemInfo {
    "System Information:"
    "CPU: $(Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Name)"
    "OS: $(Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption)"
    "RAM: $(Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory) bytes"
    "Video: $(Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Caption)"
    "----------------------"
}

# Function to get disk information
function Get-DisksInfo {
    "Disk Information:"
    Get-CimInstance Win32_DiskDrive | ForEach-Object {
        "Drive: $($_.DeviceID)"
        "   Manufacturer: $($_.Manufacturer)"
        "   Model: $($_.Model)"
        "   Serial Number: $($_.SerialNumber)"
        "   Firmware Revision: $($_.FirmwareRevision)"
        "   Size: $($_.Size) bytes"
        "----------------------"
    }
}

# Function to get network information
function Get-NetworkInfo {
    "Network Information:"
    Get-NetAdapter | ForEach-Object {
        "Interface: $($_.InterfaceDescription)"
        "   MAC Address: $($_.MacAddress)"
        "   Status: $($_.Status)"
        "----------------------"
    }
}

Export-ModuleMember -Function Get-SystemInfo, Get-DisksInfo, Get-NetworkInfo
