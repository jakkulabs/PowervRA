function Get-vRANATNetworkProfile {
<#
    .SYNOPSIS
    Get vRA NAT network profiles
    
    .DESCRIPTION
    Get vRA NAT network profiles

    .PARAMETER Id
    The id of the NAT network profile
    
    .PARAMETER Name
    The name of the NAT network profile

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
    Get-vRANATNetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014

    .EXAMPLE
    Get-vRANATNetworkProfile -Name NetworkProfile01

    .EXAMPLE
    Get-vRANATNetworkProfile

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$true,ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,    
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100,
    
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1
       
    )    

    try {

        switch ($PsCmdlet.ParameterSetName) {

            'ById' { 

                foreach ($NetworkProfileId in $Id) {

                    $URI = "/iaas-proxy-provider/api/network/profiles/$($NetworkProfileId)"
            
                    $NetworkProfile = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    if ($NetworkProfile) {

                        if ($NetworkProfile.profileType -ne "NAT") {

                            throw "Network profile type is not NAT"

                        }

                        [PSCustomObject] @{

                            Id = $NetworkProfile.id
                            Name = $NetworkProfile.name
                            Description = $NetworkProfile.description
                            CreatedDate = $NetworkProfile.createdDate
                            LastModifiedDate = $NetworkProfile.lastModifiedDate
                            IsHidden = $NetworkProfile.ishidden
                            DefinedRanges = $NetworkProfile.definedRanges
                            DefinedAddresses = $NetworkProfile.definedAddresses
                            ReclaimedAddresses = $NetworkProfile.reclaimedAddresses
                            IPAMEndpointId = $NetworkProfile.IPAMEndpointId
                            IPAMEndpointName = $NetworkProfile.IPAMEndpointName
                            AddressSpaceExternalId = $NetworkProfile.addressspaceExternalId
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

                    }
                    else {

                        throw "Could not find NAT network profile with Id $($NetworkProfileId)"

                    }

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
            
                    $URI = "/iaas-proxy-provider/api/network/profiles?`$filter=name eq '$($NetworkProfileName)' and profileType eq NAT"

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                    if ($Response.content.Count -eq 0) {

                        throw "Could not find NAT network profile with name $($NetworkProfileName)"

                    }

                    $Id = $Response.content.id

                    # --- Now we retrieve the network profile by id to see all information
                    $URI = "/iaas-proxy-provider/api/network/profiles/$($Id)"
            
                    $NetworkProfile = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    [PSCustomObject] @{

                        Id = $NetworkProfile.id
                        Name = $NetworkProfile.name
                        Description = $NetworkProfile.description
                        CreatedDate = $NetworkProfile.createdDate
                        LastModifiedDate = $NetworkProfile.lastModifiedDate
                        IsHidden = $NetworkProfile.ishidden
                        DefinedRanges = $NetworkProfile.definedRanges
                        DefinedAddresses = $NetworkProfile.definedAddresses
                        ReclaimedAddresses = $NetworkProfile.reclaimedAddresses
                        IPAMEndpointId = $NetworkProfile.IPAMEndpointId
                        IPAMEndpointName = $NetworkProfile.IPAMEndpointName
                        AddressSpaceExternalId = $NetworkProfile.addressspaceExternalId
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
                          
                }
                
                break                                          
        
            }

            'Standard' {

                $URI = "/iaas-proxy-provider/api/network/profiles?limit=$($Limit)&page=$($Page)&`$filter=profileType eq NAT"

                $EscapedURI = [uri]::EscapeUriString($URI)

                $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$verbosePreference

                foreach ($NetworkProfile in $Response.content) {

                    [PSCustomObject] @{

                        Id = $NetworkProfile.id
                        Name = $NetworkProfile.name
                        Description = $NetworkProfile.description
                        CreatedDate = $NetworkProfile.createdDate
                        LastModifiedDate = $NetworkProfile.lastModifiedDate
                        IsHidden = $NetworkProfile.ishidden
                        DefinedRanges = $NetworkProfile.definedRanges
                        DefinedAddresses = $NetworkProfile.definedAddresses
                        ReclaimedAddresses = $NetworkProfile.reclaimedAddresses
                        IPAMEndpointId = $NetworkProfile.IPAMEndpointId
                        IPAMEndpointName = $NetworkProfile.IPAMEndpointName
                        AddressSpaceExternalId = $NetworkProfile.addressspaceExternalId
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

                }

                Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"

                break

            }

        }
           
    }
    catch [Exception]{
        
        throw

    }   
     
}