# Get corporate device identifiers and export to CSV file

$ExportPath = "C:\Windows\Temp"
$ComputerName = $env:COMPUTERNAME

if (-not (Test-Path -Path $ExportPath)) {
	New-Item -Path $ExportPath -ItemType Directory -Force | Out-Null
}

$objBiosInfo = Get-CimInstance -ClassName Win32_BIOS
$objComputerInfo = Get-CimInstance -ClassName Win32_ComputerSystem
$strManufacturer = $objComputerInfo.Manufacturer
$strModel = $objComputerInfo.Model
$strSerialNumber = $objBiosInfo.SerialNumber

$device = [PSCustomObject]@{
	ComputerName = $ComputerName
	Manufacturer = $strManufacturer
	Model = $strModel
	SerialNumber = $strSerialNumber
}

$csvPath = Join-Path -Path $ExportPath -ChildPath "$($ComputerName)_DeviceIdentifier.csv"
$device | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Output "Exported device identifiers to $csvPath"