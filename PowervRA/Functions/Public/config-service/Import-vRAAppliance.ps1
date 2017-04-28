function Import-vRAAppliance {
<#
    .SYNOPSIS
    Imports the vRealize Automation Appliance to vCenter.
    
    .DESCRIPTION
    Deploys the appliance, sets the OVF properties and powers it on. 

    .PARAMETER ApplianceHostname
    The desired hostname value.

    .PARAMETER AppliancePassword
    The root password used for VAMI access.

    .PARAMETER ApplianceAddress
    The IP Address of the appliance.

    .PARAMETER ApplianceNetmask 
    The subnet mask of the appliance.

    .PARAMETER ApplianceGateway 
    The gateway address of the appliance.

    .PARAMETER ApplianceDNS
    The DNS Server(s) for the appliance.

    .PARAMETER ApplianceDomain 
    The domain suffix for the appliance. 

    .PARAMETER 
    
    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE 
    Set-vRAHostname -Hostname vra.lab.local

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]$ApplianceHostname,    

    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [SecureString]$AppliancePassword,

    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]$ApplianceAddress,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]$ApplianceNetmask,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]$ApplianceGateway,

    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String[]]$ApplianceDNS,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]$ApplianceDomain,

    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String]$AppliancePortgroup,

    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String[]]$Cluster,

    [parameter(Mandatory=$true)]
    [ValidateNotNullorEmpty()]
    [String[]]$OvaPath

    )  

    # --- Check prerequisites.
    $CheckPowerCLI = Check-PowerCliAssemblies
    
    if (($Global:DefaultVIServers.Count) -eq 0) {

        Write-Warning "You are not connected to any vCenter Servers."
        throw "Please connect to a vCenter Server and re-run the command."

    }

    # --- Convert Secure Credentials to a format for sending in the JSON payload

    $JSONAppliancePassword = (New-Object System.Management.Automation.PSCredential("username", $AppliancePassword)).GetNetworkCredential().Password

    # --- Set Appliance Variables for OVA Import 

    $ApplianceConfig = @{
        "common.vami.hostname"="$($ApplianceHostname)"
        "common.varoot_password"="$($JSONAppliancePassword)"
        "vami.VMware_vRealize_Appliance.gateway"="$($ApplianceGateway)"
        "vami.VMware_vRealize_Appliance.domain"="$($ApplianceDomain)"
        "vami.VMware_vRealize_Appliance.DNS"="$($ApplianceDNS)"
        "vami.VMware_vRealize_Appliance.ip0"="$($ApplianceAddress)"
        "vami.VMware_vRealize_Appliance.netmask0"="$($ApplianceNetmask)"
        "IpAssignment.IpProtocol"="IPv4"
        "NetworkMapping.Network_1"="$($AppliancePortgroup)"
    }

    # --- Import vRA Appliance 

    Write-Output "Importing vRealize Automation OVA."

    $VIHost = Get-Cluster $Cluster | Get-VMHost | Where {$_.PowerState -eq "PoweredOn" -and $_.ConnectionState -eq "Connected"} | Get-Random
    $Datastore = $VIHost | Get-Datastore | Sort FreeSpaceGB -Descending | Select -first 1

    Import-VApp -Source $OvaPath -OvfConfiguration $ApplianceConfig -Name $ApplianceHostname -VMHost $VIHost -Datastore $Datastore -DiskStorageFormatThin

    # --- Power On the Appliance 
    
    Write-Output "Powering On vRA Appliance."

    Get-VM $ApplianceHostname | Start-VM

}