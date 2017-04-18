function Get-vRASourceMachine {
<#
    .SYNOPSIS
    Return a list of source machines
    
    .DESCRIPTION
    Return a list of source machines. A source machine represents an entity that is visible to the endpoint.

    .PARAMETER Id
    The id of the Source Machine
    
    .PARAMETER Name
    The name of the Source Macine

    .PARAMETER ManagedOnly
    Only return machines that are managed

    .PARAMETER TemplatesOnly
    Only return machines that are marked as templates

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
    Get-vRASourceMachine -Id 597ff2c1-a35f-4a81-bfd3-ca014

    .EXAMPLE
    Get-vRASourceMachine -Name vra-template-01

    .EXAMPLE
    Get-vRAExternalNetworkProfile

    .EXAMPLE
    Get-vRAExternalNetworkProfile -Template

    .EXAMPLE
    Get-vRAExternalNetworkProfile -Managed

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
        [Switch]$ManagedOnly,    

        [Parameter(Mandatory=$false,ParameterSetName="Standard-Template")]
        [ValidateNotNullOrEmpty()]
        [Switch]$TemplatesOnly,  

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [Parameter(Mandatory=$false,ParameterSetName="Standard-Template")]     
 
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100,
    
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [Parameter(Mandatory=$false,ParameterSetName="Standard-Template")]            
        [ValidateNotNullOrEmpty()]
        [Int]$Page = 1
       
    )    

    Begin {

        xRequires -Version 7.1
        $PlatformTypeId = "Infrastructure.CatalogItem.Machine.Virtual.vSphere"

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                'ById' { 

                    foreach ($SourceMachineId in $Id) {

                        $SourceMachine = getSourceMachineById $SourceMachineId $PlatformTypeId

                        [PSCustomObject] @{

                            Id = $SourceMachine.id
                            Name = $SourceMachine.name
                            Description = $SourceMachine.description
                            ReservationName = $SourceMachine.reservationName
                            HostName = $SourceMachine.hostName
                            ExternalId = $SourceMachine.externalId
                            Status = $SourceMachine.status
                            EndpointName = $SourceMachine.endpointName
                            Region = $SourceMachine.region
                            ParentTemplate = $SourceMachine.parentTemplate
                            CPU = $SourceMachine.cpu
                            MemoryMB = $SourceMachine.memoryMB
                            StorageGB = $SourceMachine.storageGB
                            IsTemplate = $SourceMachine.isTemplate
                            GuestOsFamily = $SourceMachine.guestOSFamily
                            InterfaceType = $SourceMachine.interfaceType
                            Disks = $SourceMachine.disks
                            Properties = $SourceMachine.properties
                        }
                    }

                    break
                }

                'ByName' {

                    foreach ($SourceMachineName in $Name) {

                        $URI = "/iaas-proxy-provider/api/source-machines/?actionId=FullClone&platformTypeId=Infrastructure.CatalogItem.Machine.Virtual.vSphere&`$filter=name eq '$($SourceMachineName)'"
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$verbosePreference
                        
                        if ($Response.content.Count -eq 0) {
                            throw "Resource not found with name $($SourceMachineNamae)"
                        }

                        $Id = $Response.content[0].id

                        $SourceMachine = getSourceMachineById $Id $PlatformTypeId

                        [PSCustomObject] @{

                            Id = $SourceMachine.id
                            Name = $SourceMachine.name
                            Description = $SourceMachine.description
                            ReservationName = $SourceMachine.reservationName
                            HostName = $SourceMachine.hostName
                            ExternalId = $SourceMachine.externalId
                            Status = $SourceMachine.status
                            EndpointName = $SourceMachine.endpointName
                            Region = $SourceMachine.region
                            ParentTemplate = $SourceMachine.parentTemplate
                            CPU = $SourceMachine.cpu
                            MemoryMB = $SourceMachine.memoryMB
                            StorageGB = $SourceMachine.storageGB
                            IsTemplate = $SourceMachine.isTemplate
                            GuestOsFamily = $SourceMachine.guestOSFamily
                            InterfaceType = $SourceMachine.interfaceType
                            Disks = $SourceMachine.disks
                            Properties = $SourceMachine.properties
                        }
                    }
                    
                    break     
                }

                'Standard-Template' {

                    $LoadTemplates = $TemplatesOnly.IsPresent
                    Write-Verbose -Message "Loadtemplates: $LoadTemplates"
                    $URI = "/iaas-proxy-provider/api/source-machines?actionId=FullClone&platformTypeId=Infrastructure.CatalogItem.Machine.Virtual.vSphere&loadTemplates=$($LoadTemplates)&limit=$($Limit)&page=$($Page)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$verbosePreference

                    # -- Use helper function to process response from the endpoint
                    processStandardOutput($Response)

                    Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"
                    break
                }

                'Standard' {

                    $URI = "/iaas-proxy-provider/api/source-machines?actionId=FullClone&platformTypeId=Infrastructure.CatalogItem.Machine.Virtual.vSphere&loadTemplates=false&limit=$($Limit)&page=$($Page)"

                    # --- Managed and Template can't work together so only allow this param if
                    if ($PSBoundParameters.ContainsKey("ManagedOnly")) {
                        Write-Verbose -Message "Filtering results for managed machines"
                        $URI = $URI + "&`$filter=status ne 'Unmanaged'"
                    }

                    $EscapedURI = [uri]::EscapeUriString($URI)
                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$verbosePreference

                    # -- Use helper function to process response from the endpoint
                    processStandardOutput($Response)

                    Write-Verbose -Message "Total: $($Response.metadata.totalElements) | Page: $($Response.metadata.number) of $($Response.metadata.totalPages) | Size: $($Response.metadata.size)"
                    break
                }                
            }
        }
        catch [Exception]{
            
            throw $_
        }   
    }

    End {

    }
}

function getSourceMachineById($I, $P) {
    <#
    .SYNOPSIS
    Helper function to retrieve source machine by id
    .PARAMETER I
    The id of the source machine
    .PARAMETER P
    The PlatformTypeId
    #>
    $URI = "/iaas-proxy-provider/api/source-machines/$($I)?platformTypeId=$($P)"
    Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
}


function processStandardOutput([PSCustomObject[]]$Response){
    <#
    .SYNOPSIS
    Helper function to process response records from the api endpoint
    .PARAMETER Response
    An array of PSCusomObject Responses
    #>
    foreach ($Record in $Response.content) {

        # --- GET by id returns more information
        $SourceMachine = getSourceMachineById $Record.id $PlatformTypeId

        [PSCustomObject] @{

            Id = $SourceMachine.id
            Name = $SourceMachine.name
            Description = $SourceMachine.description
            ReservationName = $SourceMachine.reservationName
            HostName = $SourceMachine.hostName
            ExternalId = $SourceMachine.externalId
            Status = $SourceMachine.status
            EndpointName = $SourceMachine.endpointName
            Region = $SourceMachine.region
            ParentTemplate = $SourceMachine.parentTemplate
            CPU = $SourceMachine.cpu
            MemoryMB = $SourceMachine.memoryMB
            StorageGB = $SourceMachine.storageGB
            IsTemplate = $SourceMachine.isTemplate
            GuestOsFamily = $SourceMachine.guestOSFamily
            InterfaceType = $SourceMachine.interfaceType
            Disks = $SourceMachine.disks
            Properties = $SourceMachine.properties
        }
    }
}