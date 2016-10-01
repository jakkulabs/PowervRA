function New-vRANetworkProfileIPRange {
<#
    .SYNOPSIS
    Creates a new network profile ip range definition
        
    .DESCRIPTION
    Creates a new network profile ip range definition

    .PARAMETER NetworkProfileId
    The id of the network profile

    .PARAMETER Name
    The name of the network profile ip range

    .PARAMETER Description
    A description of the network profile ip range

    .PARAMETER StartIPv4Address
    The start ipv4 address

    .PARAMETER EndIPv4Address
    The end ipv4 address

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRANetworkProfileIPRange -Name "External-Range-01" -Description "Example" -StatIPv4Address "10.20.1.2" -EndIPv4Address "10.20.1.5"

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$StatIPv4Address,
        
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match [IPAddress]$_ })]  
        [String]$EndIPv4Address

    )

        # --- Define ip address range
        $IPAddressRange = [PSCustomObject] @{

                name = $Name
                description = $Description
                beginIPv4Address = $StatIPv4Address
                endIPv4Address = $EndIPv4Address
                state = "UNALLOCATED"
                networkProfileId = $NetworkProfileId
                createdDate = $null
                lastModifiedDate = $null
                definedAddresses = @()

            }

        # --- Return the new ip address range
        $IPAddressRange

}