###############################################################################################################
#
# ABOUT THIS PROGRAM
#
#   BitlockerCheckDataDrives.ps1
#   https://github.com/Headbolt/BitlockerCheckDataDrives
#
#   This script was designed to Check the Bitlocker Status of a Machines Non USB Data Disks 
#	and then exit with an appropriate Exit code.
#
#	Intended use is in Microsoft Endpoint Manager, as the "Check" half of a Proactive Remediation Script
#
###############################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 14/04/2022
#
#   - 14/04/2022 - V1.0 - Created by Headbolt
#
###############################################################################################################
#
Write-Host
Write-Host '###############################################################################################################'
Write-Host
$Disks=(Get-Disk | Where BusType -ne USB | Get-Partition | Get-Volume | Where { $_.DriveLetter -ne $null })
#
$DataDrivesNonUSB=($Disks.DriveLetter | Get-BitlockerVolume | Where-Object {$_.VolumeType -eq 'Data'})
#
ForEach ($Drive in $DataDrivesNonUSB)
{

Write-Host 'Checking Drive' $Drive	
	If (($Drive.VolumeStatus -eq "FullyEncrypted") -or ($Drive.VolumeStatus -eq "Encrypting"))
		{
			Write-Host
			Write-Host 'Drive' $Drive 'Fully Encrypted Or Encrypting'
			Write-Host
			Write-Host '###############################################################################################################'
			Exit 0
		}
	Else
		{
			Write-Host
			Write-Host 'Drive' $Drive 'Is NOT Fully Encrypted Or Encrypting'
			Write-Host
			Write-Host '###############################################################################################################'
			Exit 1
		}
	Write-Host
}
Write-Host 'No Disks Found That Are Not USB or Operating System'
Write-Host
Write-Host 'Exiting'
Write-Host
Write-Host '###############################################################################################################'
Exit 0
