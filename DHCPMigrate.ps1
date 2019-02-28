#This script migrates DHCP from an old server to a new server
#Script Tested on Source: Windows Server 2012R2 to Destination:Windows Server 2016
#Script is designed to run on destination server

$source = Read-Host "Enter source DHCP server(FQDN)"

Export-DhcpServer -ComputerName $source -Leases -File "C:\admin\DHCPconf.xml" –Verbose

Import-DhcpServer -Leases –File "C:\admin\DHCPconf.xml" -BackupPath "C:\admin\" –Verbose
