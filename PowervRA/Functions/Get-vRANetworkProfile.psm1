function Get-vRANetworkProfile {
<#
    .SYNOPSIS
    Get vRA network profiles
    
    .DESCRIPTION
    Get vRA network profiles

    .PARAMETER Id
    The id of the network profile
    
    .PARAMETER Name
    The name of the network profile

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The page of response to return. All pages are retuend by default

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject
    System.Object[]

    .EXAMPLE
    Get-vRANetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014

    .EXAMPLE
    Get-vRANetworkProfile -Name NetworkProfile01

    .EXAMPLE
    Get-vRANetworkProfile

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject', 'System.Object[]')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,    
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Limit = "100",
 
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Int]$Page = "1"
       
    )    

    # --- Define an internal function to return the correct network profile pscustomobject
    function _returnNetworkProfile {

        Param(

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$NetworkProfile

        )

        switch($NetworkProfile.profileType){

            'ROUTED' {

                # --- Return a routed network profile

                [pscustomobject] @{

                    Id = $NetworkProfile.id
                    Name = $NetworkProfile.name
                    Description = $NetworkProfile.description
                    CreatedDate = $NetworkProfile.createdDate
                    LastModifiedDate = $NetworkProfile.lastModifiedDate
                    IsHidden = $NetworkProfile.ishidden
                    DefinedRanges = $NetworkProfile.definedRanges
                    ProfileType = $NetworkProfile.profileType
                    RangeSubnetMask = $NetworkProfile.rangeSubnetMask
                    SubnetMask = $NetworkProfile.subnetMask
                    GatewayAddress = $NetworkProfile.gatewayAddress
                    PrimaryDnsAddress = $NetworkProfile.primaryDnsAddress
                    SecondaryDnsAddress = $NetworkProfile.secondaryDnsAddress
                    DnsSuffix = $NetworkProfile.DnsSuffix
                    DnsSearchSuffix = $NetworkProfile.DnsSearchSuffix
                    PrimaryWinsAddress = $NetworkProfile.PrimaryWinsAddress
                    SecondaryWinsAddress = $NetworkProfile.SecondaryWinsAddress
                    ExternalNetworkProfileId = $NetworkProfile.externalNetworkProfileId
                    ExternalNetworkProfileName = $NetworkProfile.externalNetworkProfileName
                    BaseIP = $NetworkProfile.baseIP

                }

                break

            }

            'NAT' {

                # --- Return a NAT network profile

                [pscustomobject] @{

                    Id = $NetworkProfile.id
                    Name = $NetworkProfile.name
                    Description = $NetworkProfile.description
                    CreatedDate = $NetworkProfile.createdDate
                    LastModifiedDate = $NetworkProfile.lastModifiedDate
                    IsHidden = $NetworkProfile.ishidden
                    DefinedRanges = $NetworkProfile.definedRanges
                    ProfileType = $NetworkProfile.profileType
                    NatType = $NetworkProfile.natType
                    SubnetMask = $NetworkProfile.subnetMask
                    GatewayAddress = $NetworkProfile.gatewayAddress
                    PrimaryDnsAddress = $NetworkProfile.primaryDnsAddress
                    SecondaryDnsAddress = $NetworkProfile.secondaryDnsAddress
                    DnsSuffix = $NetworkProfile.DnsSuffix
                    DnsSearchSuffix = $NetworkProfile.DnsSearchSuffix
                    PrimaryWinsAddress = $NetworkProfile.PrimaryWinsAddress
                    SecondaryWinsAddress = $NetworkProfile.SecondaryWinsAddress
                    ExternalNetworkProfileId = $NetworkProfile.externalNetworkProfileId
                    ExternalNetworkProfileName = $NetworkProfile.externalNetworkProfileName
                    DhcpConfig = $NetworkProfile.dhcpConfig

                }

                break

            }

            'EXTERNAL' {

                # --- Return an external network profile

                [pscustomobject] @{

                    Id = $NetworkProfile.id
                    Name = $NetworkProfile.name
                    Description = $NetworkProfile.description
                    CreatedDate = $NetworkProfile.createdDate
                    LastModifiedDate = $NetworkProfile.lastModifiedDate
                    IsHidden = $NetworkProfile.ishidden
                    DefinedRanges = $NetworkProfile.definedRanges
                    ProfileType = $NetworkProfile.profileType
                    SubnetMask = $NetworkProfile.subnetMask
                    GatewayAddress = $NetworkProfile.gatewayAddress
                    PrimaryDnsAddress = $NetworkProfile.primaryDnsAddress
                    SecondaryDnsAddress = $NetworkProfile.secondaryDnsAddress
                    DnsSuffix = $NetworkProfile.DnsSuffix
                    DnsSearchSuffix = $NetworkProfile.DnsSearchSuffix
                    PrimaryWinsAddress = $NetworkProfile.PrimaryWinsAddress
                    SecondaryWinsAddress = $NetworkProfile.SecondaryWinsAddress

                }

                break
                            
            }

        }  

    }

    try {

        switch ($PsCmdlet.ParameterSetName) {

            'ById' { 

                foreach ($NetworkProfileId in $Id) {

                    $URI = "/iaas-proxy-provider/api/network/profiles/$($NetworkProfileId)"
            
                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $NetworkProfile = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    if ($NetworkProfile.Count -eq 0) {

                        throw "Could not find network profile $($NetworkProfileId)"

                    }

                    _returnNetworkProfile -NetworkProfile $NetworkProfile

                }

                break

            }

            'ByName' {

                foreach ($NetworkProfileName in $Name) {

                    <#
                    
                        Filtering by name will only return a subset of information, just 
                        like /api/network/profiles. See the following from the API documentation:

                        This API will only return some basic information about each network profile. 
                        To get more details of a specific network profile use the /api/network/profiles/{id} API. 

                    #>
                                        
                    # --- Workaround to get the ID of the network profile            
            
                    Write-Verbose -Message "Retrieving network profile id"

                    $Response = Invoke-vRARestMethod -Method GET -URI "/iaas-proxy-provider/api/network/profiles?`$filter=name%20eq%20'$($NetworkProfileName)'"

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find network profile $($NetworkProfileName)"

                    }

                    $Id = $Response.content.id

                    # --- Now we retrieve the network profile by id to see all information

                    $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"
            
                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $NetworkProfile = Invoke-vRARestMethod -Method GET -URI "$($URI)"

                    Write-Verbose -Message "SUCCESS"

                    _returnNetworkProfile -NetworkProfile $NetworkProfile
                                     
                }
                
                break                                          
        
            }

            'Standard' {

                $URI = "/iaas-proxy-provider/api/network/profiles?limit=$($Limit)"

                # --- Make the first request to determine the size of the request
                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                if (!$PSBoundParameters.ContainsKey("Page")){

                    # --- Get every page back
                    $TotalPages = $Response.metadata.totalPages.ToInt32($null)

                }
                else {

                    # --- Set TotalPages to 1
                    $TotalPages = 1

                }

                # --- Initialise an empty array
                $ResponseObject = @()

                while ($true){

                    Write-Verbose -Message "Getting response for page $($Page) of $($Response.metadata.totalPages)"

                    $PagedUri = "$($URI)&page=$($Page)&`$orderby=name%20asc"

                    Write-Verbose -Message "GET : $($PagedUri)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $PagedUri
            
                    Write-Verbose -Message "Paged Response contains $($Response.content.Count) records"

                    foreach ($NetworkProfile in $Response.content) {
                                              
                        $ResponseObject += _returnNetworkProfile -NetworkProfile $NetworkProfile

                    }

                    # --- Break loop
                    if ($Page -ge $TotalPages) {

                        break

                    }

                    # --- Increment the current page by 1
                    $Page++

                }         

                # --- Return network profiles
                $ResponseObject

                break
    
            }

        }
           
    }
    catch [Exception]{
        
        throw

    }   
     
}