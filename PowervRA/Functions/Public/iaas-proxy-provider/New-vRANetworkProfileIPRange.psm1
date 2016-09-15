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

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Name,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$true)]
    [ValidateScript({$_ -match [IPAddress]$_ })]  
    [String]$StatIPv4Address,
    
    [parameter(Mandatory=$true)]
    [ValidateScript({$_ -match [IPAddress]$_ })]  
    [String]$EndIPv4Address

    )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             

    begin {
    
    }
    
    process {

        try {

            # --- Define ip address range
            $IPAddressRange = [pscustomobject] @{

                    name = "$($Name)"
                    description =  "$($Description)"
                    beginIPv4Address =  "$($StatIPv4Address)"
                    endIPv4Address = "$($EndIPv4Address)"
                    state = "UNALLOCATED"
                    networkProfileId = "$($NetworkProfileId)"
                    createdDate = $null
                    lastModifiedDate = $null
                    definedAddresses = @()
                }
    
            <# --- Calculate and add the definedAddresses - It looks like this is actually done automatically so probably not needed

            # --- Thanks to Dr. Tobias Weltner for this  >> http://powershell.com/cs/media/p/9437.aspx
            Write-Verbose -Message "Calculating IP Addresses For Range $($StatIPv4Address) -> $($EndIPv4Address)"

            $IP1 = ([System.Net.IPAddress]$StatIPv4Address).GetAddressBytes() 
            
            [Array]::Reverse($IP1) 
            
            $IP1 = ([System.Net.IPAddress]($IP1 -join '.')).Address 
   
            $IP2 = ([System.Net.IPAddress]$EndIPv4Address).GetAddressBytes() 
  
            [Array]::Reverse($IP2) 
  
            $IP2 = ([System.Net.IPAddress]($IP2 -join '.')).Address 
   
            for ($X=$IP1; $X -le $IP2; $X++) { 
    
                $IP = ([System.Net.IPAddress]$X).GetAddressBytes()
                 
                [Array]::Reverse($IP)
                
                $IPAddress = [pscustomobject] @{

                    id = $null
                    name = $null
                    description =  $null
                    networkProfileId = $null
                    staticIPv4RangeId = $null
                    virtualMachineId = $null
                    IPv4Address = "$($IP -join '.')"
                    IPSortValue = 0
                    state = "UNALLOCATED"
                    networkInterfaceCardOffset = $null
                    hostName = $null
                    createdDate = $null
                    lastModifiedDate = $null

                }                  
                
                $IPAddressRange.definedAddresses += $IPAddress               
                      
            }
            
            #>

            # --- Return the new ip address range
            $IPAddressRange

        }
        catch [Exception]{

            throw
        }

    }
    end {
        
    }
}