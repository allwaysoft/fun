#List all modules available on a machine
Get-Module -ListAvailable #Will list all the modules installed on a machine
    
#Get a list of sub directories under a directory and their sizes. Change the $startDirectory variable to evaluate the required directory
    #gets the size of every directory under the $startDirectory directory
    #can sometimes be a little slow if a directory has a lot of folders in it
$startDirectory = 'E:\MSSQL\Backups\'#gets a list of folders under the $startDirectory directory
$directoryItems = Get-ChildItem $startDirectory | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
    #loops throught he list, calculating the size of each directory
foreach ($i in $directoryItems)
{
    $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1GB) + " GB"
}


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------#-- Get all AD groups of a AD user(Get-ADuser -Identity rraj -Properties memberof).memberof | Get-ADGroup | Select-Object name | Sort-Object name(Get-ADGroup -Identity SQL_Developers -Properties memberof).memberof | Get-ADGroup | Select-Object name | Sort-Object name#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-- Check if a AD user is part of a list of AD groups
$user = "SQL_Developers"
$groups = 'SQL_Developers', 'sec_devserveradmins'foreach ($group in $groups) {
    $members = Get-ADGroupMember -Identity $group -Recursive | Select-Object -ExpandProperty SamAccountName    If ($members -contains $user) {
        Write-Host "$user is a member of $group"
    } Else {
        Write-Host "$user is not a member of $group"
    }
}
Get-ADGroup -Filter {Name -like '*team*maesters*'}Get-ADGroup -Filter {Name -like 'Team 12 - POPS'}Get-ADGroup -Filter {Name -like 'Team 6 – Seal Team Six'}Get-ADGroupMember -Identity 'Team 8- Maesters'Get-ADGroupMember -Identity 'Team 12 - POPS'Get-ADGroupMember -Identity 'Team 6 – Seal Team Six'$FileName = "This/is the end. Bagels/ are. awesome."


#$stuff.Split(".",3)
#$stuff.IndexOf('/', $stuff.IndexOf('/') + 1)$Index = $FileName.IndexOf('/', $FileName.IndexOf('/') + 1)
$FileName.Substring(0,$Index)