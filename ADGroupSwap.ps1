<#
This script swaps memberships between 2 groups using a 3rd temp group
#>

#Enter Groups to swap, loop if group doesn't exist
do{
$group1 = Read-Host "Enter the first group"
$group1Verify = Get-ADGroup -Filter { Name -eq $group1 }
}while( $group1Verify )

do{
$group2 = Read-Host "Enter the second group"
$group2Verify = Get-ADGroup -Filter { Name -eq $group2 }
}while( $group2Verify )

do{
$tempGroup = Read-Host "Enter the temporary group"
$groupTempVerify = Get-ADGroup -Filter { Name -eq $tempGroup }
}while( $groupTempVerify )



#Move members from Group 1 to a temp group
Get-ADGroupMember $group1 | Get-ADUser | 
  Foreach-Object {
    Add-ADGroupMember -Identity $tempGroup -Members $_
    Remove-ADGroupMember -Identity $group1 -Members $_ -Confirm:$false
  }
  
#Move members from Group 1 to Group 2
Get-ADGroupMember $group2 | Get-ADUser | 
  Foreach-Object {
    Add-ADGroupMember -Identity $group1 -Members $_
    Remove-ADGroupMember -Identity $group2 -Members $_ -Confirm:$false
  }
  
#Move members from Group 1(Temporarily stored in Temp group) into Group 2
Get-ADGroupMember $tempGroup | Get-ADUser | 
  Foreach-Object {
    Add-ADGroupMember -Identity $group1 -Members $_
    Remove-ADGroupMember -Identity $tempGroup -Members $_ -Confirm:$false
  }
