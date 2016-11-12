function Get-vRANetworkProfileIPRangeSummary {
<#
    .SYNOPSIS
    Returns a list of range summaries within the network profile.

    .DESCRIPTION
    Returns a list of range summaries within the network profile.

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
    Get-vRAExternalNetworkProfile -Name EXT-01 | Get-vRANetworkProfileIPRangeSummary

    .EXAMPLE
     Get-vRAExternalNetworkProfile -Name EXT-01 | Get-vRANetworkProfileIPRangeSummary -Limit 10 -Page 1

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

        $URI = "/iaas-proxy-provider/api/network/profiles/range-summaries/$($NetworkProfileId)?limit=$($limit)&page=$($page)"

        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$verbosePreference

        foreach ($NetworkProfileRange in $Response.content) {

            [PSCustomObject] @{

                "Id" = $NetworkProfileRange.id
                "Name" = $NetworkProfileRange.name
                "Description" = $NetworkProfileRange.description
                "BeginIPv4Address" = $NetworkProfileRange.beginIPv4Address
                "EndIPv4Address" = $NetworkProfileRange.endIPv4Address
                "State" = $NetworkProfileRange.state
                "CreatedDate" = $NetworkProfileRange.createdDate
                "LastModifiedDate" = $NetworkProfileRange.lastModifiedDate
                "TotalAddresses" = $NetworkProfileRange.totalAddresses
                "AllocatedAddresses" = $NetworkProfileRange.allocatedAddresses
                "UnallocatedAddresses" = $NetworkProfileRange.unallocatedAddresses
                "DestroyedAddresses" = $NetworkProfileRange.destroyedAddresses
                "ExpiredAddresses" = $NetworkProfileRange.expiredAddresses

            }

        }

        Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"
    
    }
    catch [Exception]{
        
        throw

    }   
     
}