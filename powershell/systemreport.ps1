param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)

function Get-SystemInfo {
    "System Information:"
    "CPU: $(Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Name)"
    "OS: $(Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption)"
    "RAM: $(Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory) bytes"
    "Video: $(Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Caption)"
    "----------------------"
}

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

function Get-NetworkInfo {
    "Network Information:"
    Get-NetAdapter | ForEach-Object {
        "Interface: $($_.InterfaceDescription)"
        "   MAC Address: $($_.MacAddress)"
        "   Status: $($_.Status)"
        "----------------------"
    }
}

# Generate the system report based on provided parameters
if ($System) { Get-SystemInfo }
if ($Disks) { Get-DisksInfo }
if ($Network) { Get-NetworkInfo }

# If no parameters are provided, generate the full report
if (-not $PSBoundParameters.Keys) {
    Get-SystemInfo
    Get-DisksInfo
    Get-NetworkInfo
}
