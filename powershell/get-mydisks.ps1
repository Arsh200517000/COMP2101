# Create the get-mydisks function
function get-mydisks {
    $diskDrives = Get-CimInstance -ClassName Win32_DiskDrive

    foreach ($drive in $diskDrives) {
        $diskInfo = [PSCustomObject]@{
            Manufacturer      = $drive.Manufacturer
            Model             = $drive.Model
            SerialNumber      = $drive.SerialNumber
            FirmwareRevision  = $drive.FirmwareRevision
            Size              = [math]::Round($drive.Size / 1GB, 
        }

        # Display the custom object
        $diskInfo | Format-Table
    }
}


