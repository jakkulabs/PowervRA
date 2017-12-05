function Get-vRAComponentRegistryService {
<#
    .SYNOPSIS
    Get information about vRA services
    
    .DESCRIPTION
    Get information about vRA services.

    .PARAMETER Id
    The Id of the service. Specifying the Id of the service will retrieve detailed information.
    
    .PARAMETER Name
    The name of the service

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The index of the page to display.

    .INPUTS
    System.String
    System.Int
    System.Management.Automation.SwitchParameter

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
     Get-vRAComponentRegistryService

    .EXAMPLE
     Get-vRAComponentRegistryService -Limit 9999

    .EXAMPLE
     Get-vRAComponentRegistryService -Page 1

    .EXAMPLE
    Get-vRAComponentRegistryService -Id xxxxxxxxxxxxxxxxxxxxxxxx

    .EXAMPLE
    Get-vRAComponentRegistryService -Name "iaas-service"

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,

        [parameter(Mandatory=$true, ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1,

        [parameter(Mandatory=$false, ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100
       
    )

    Begin {

        $BaseURI = "/component-registry/services"

    }

    Process {

        try {

            switch($PSCmdlet.ParameterSetName) {

                'ById'{

                    foreach ($ServiceId in $Id) {

                        $URI = "$($BaseURI)/$($ServiceId)"

                        $Service = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        [PSCustomObject] @{

                            Id = $Service.id
                            Name = $Service.name
                            CreatedDate = $Service.createdDate
                            LastUpdated = $Service.lastUpdated
                            OwnerId = $Service.ownerId
                            ServiceVersion = $Service.serviceVersion
                            ServiceAttributes = $Service.serviceAttributes
                            EndPoints = $Service.endPoints
                            ServiceType = $Service.serviceType
                            NameMsgKey = $Service.nameMsgKey

                        }

                    }

                    break
                }

                'ByName' {

                    foreach ($ServiceName in $Name) {

                        $URI = "$($BaseURI)?`$filter=name eq '$($ServiceName)'"            

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Service = (Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference).content

                        if ($Service.Length -eq 0) {

                            throw "Could not find service with name $($ServiceName)"

                        }

                        [PSCustomObject] @{

                            Id = $Service.id
                            Name = $Service.name
                            CreatedDate = $Service.createdDate
                            LastUpdated = $Service.lastUpdated
                            OwnerId = $Service.ownerId
                            ServiceVersion = $Service.serviceVersion
                            ServiceAttributes = $Service.serviceAttributes
                            EndPoints = $Service.endPoints
                            ServiceType = $Service.serviceType
                            NameMsgKey = $Service.nameMsgKey

                        }

                    }

                    break
                }

                'Standard' {

                    # --- Build up the URI string depending on switch
                    $URI = "$($BaseURI)?limit=$($Limit)&page=$($Page)&`$orderby=name asc"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                    foreach ($Service in $Response.content) {

                        [PSCustomObject] @{

                            Id = $Service.id
                            Name = $Service.name
                            CreatedDate = $Service.createdDate
                            LastUpdated = $Service.lastUpdated
                            OwnerId = $Service.ownerId
                            ServiceVersion = $Service.serviceVersion
                            ServiceAttributes = $Service.serviceAttributes
                            EndPoints = $Service.endPoints
                            ServiceType = $Service.serviceType
                            NameMsgKey = $Service.nameMsgKey

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
     
}

