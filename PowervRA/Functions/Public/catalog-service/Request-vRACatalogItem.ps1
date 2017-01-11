function Request-vRACatalogItem {
<#
    .SYNOPSIS
    Request a vRA catalog item
    
    .DESCRIPTION
    Request a vRA catalog item with a given request template payload. 
    
    If the wait switch is passed the cmdlet will wait until the request has completed. If successful informaiton
    about the new resource will be returned
    
    If no switch is passed then the request id will be returned
    
    .PARAMETER Id
    The Id of the catalog item to request

    .PARAMETER RequestedFor
    The user principal that the request is for (e.g. user@vsphere.local). If not specified the current user is used

    .PARAMETER Description
    A description for the request

    .PARAMETER Reasons
    Reasons for the request

    .PARAMETER JSON
    JSON string containing the request template

    .PARAMETER Wait
    Wait for the request to complete
    
    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    $Template = Get-vRAEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | Get-vRACatalogItemRequestTemplate

    $Resource = Request-vRACatalogItem -JSON $Template -Wait -Verbose
    
    .EXAMPLE
    $Template = Get-vRAEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | Get-vRACatalogItemRequestTemplate

    $RequestId = Request-vRACatalogItem -JSON $Template -Verbose

    .EXAMPLE
    Request-vRACatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e"

    .EXAMPLE
    Request-vRACatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Wait

    .EXAMPLE
    Request-vRACatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Description "Test" -Reasons "Test Reason"
      
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipeline=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Id,
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$RequestedFor,      

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Reasons,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON,  
        
        [Parameter(Mandatory=$false)] 
        [Switch]$Wait
    
    )    

    Begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
    }
    
    Process {
    
        try {

            if ($PSBoundParameters.ContainsKey("JSON")) {

                # --- Get the Id of the catalog Item being requested then POST            
                $Id = ($JSON | ConvertFrom-Json).catalogItemId      
                Write-Verbose -Message "Got cataligItemId from payload: $($Id)"

                }
            else {

                # --- Get request Template
                $JSON = Get-vRACatalogItemRequestTemplate -Id $Id

                if ($PSBoundParameters.ContainsKey("RequestedFor")-or 
                    $PSBoundParameters.ContainsKey("Description") -or 
                    $PSBoundParameters.ContainsKey("Reasons")){

                    $Object = $JSON | ConvertFrom-Json

                    if ($PSBoundParameters.ContainsKey("RequestedFor")) {

                        Write-Verbose -Message "Setting requestedFor: $($RequestedFor)"

                        $Object.requestedFor = $RequestedFor

                        }

                    if ($PSBoundParameters.ContainsKey("Description")) {

                        Write-Verbose -Message "Setting description: $($Description)"

                        $Object.description = $description

                        }

                    if ($PSBoundParameters.ContainsKey("Reasons")) {

                        Write-Verbose -Message "Setting reasons: $($Reasons)"

                        $Object.reasons = $reasons

                        }

                    # --- Overwrite JSON variable with new content
                    $JSON = $Object | ConvertTo-Json -Depth 100 -Compress
                
                    }

                }
 
            if ($PSCmdlet.ShouldProcess($Id)){
                
                $URI = "/catalog-service/api/consumer/entitledCatalogItems/$($Id)/requests"
                
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $JSON -Verbose:$VerbosePreference
                
                if ($PSBoundParameters.ContainsKey("Wait")) {

                    While($true) {
                        
                        $URI = "/catalog-service/api/consumer/requests/$($Response.Id)"                       
                        
                        $Request = Invoke-vRARestMethod -Method Get -URI $URI -Verbose:$VerbosePreference

                        Write-Verbose -Message "State: $($Request.state)"
                        
                        if ($Request.state -eq "SUCCESSFUL" -or $Request.state -Like "*FAILED") {
                            
                            if ($Request.state -Like "*FAILED") {
                                
                                throw "$($Request.requestCompletion.completionDetails)"
                                
                            }
                            
                            Write-Verbose -Message "Request $($Request.id) was successful"
                            break
                        }
                        
                        Start-Sleep -Seconds 5
                        
                    }
                    
                }

                # --- Return the request
                Get-vRARequest -Id $Response.Id

            }

        }
        catch [Exception]{

            throw

        }    

    }

    End {

    }

}