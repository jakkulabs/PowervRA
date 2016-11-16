function Get-vRANetworkProfileIPAddressList {
<#
    .SYNOPSIS
    Get a list of IP addresses available within the network profile    

    .DESCRIPTION
    Get a list of IP addresses available within the network profile    

    .PARAMETER NetworkProfileId
    The id of the network profile

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The page of response to return. By default this is 1.

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAExternalNetworkProfile -Name EXT-01 | Get-vRANetworkProfileIPAddressList

    .EXAMPLE
     Get-vRAExternalNetworkProfile -Name EXT-01 | Get-vRANetworkProfileIPAddressList -Limit 10 -Page 1

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Alias("Id")]
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkProfileId,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100,
    
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1
       
    )    

    xRequires -Version 7.1

    try {

        $URI = "/iaas-proxy-provider/api/network/profiles/addresses/$($NetworkProfileId)?limit=$($limit)&page=$($page)"

        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$verbosePreference

        foreach ($NetworkProfileIPAddress in $Response.content) {

            [PSCustomObject] @{

                Id = $NetworkProfileIPAddress.id
                IPv4Address = $NetworkProfileIPAddress.ipv4Address
                IPSortValue = $NetworkProfileIPAddress.ipSortValue
                State = $NetworkProfileIPAddress.state
                StateValue = $NetworkProfileIPAddress.stateValue
                CreatedDate = $NetworkProfileIPAddress.createdDate
                LastModifiedDate = $NetworkProfileIPAddress.lastModifiedDate

            }

        }

        Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"
    
    }
    catch [Exception]{
        
        throw

    }   
     
}