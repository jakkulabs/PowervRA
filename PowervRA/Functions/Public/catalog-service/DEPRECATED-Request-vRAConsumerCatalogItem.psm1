function Request-vRAConsumerCatalogItem {
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
    $Template = Get-vRAConsumerEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | Get-vRAConsumerCatalogItemRequestTemplate

    $Resource = Request-vRAConsumerCatalogItem -JSON $Template -Wait -Verbose
    
    .EXAMPLE
    $Template = Get-vRAConsumerEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | Get-vRAConsumerCatalogItemRequestTemplate

    $RequestId = Request-vRAConsumerCatalogItem -JSON $Template -Verbose

    .EXAMPLE
    Request-vRAConsumerCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e"

    .EXAMPLE
    Request-vRAConsumerCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Wait

    .EXAMPLE
    Request-vRAConsumerCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Description "Test" -Reasons "Test Reason"
      
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$false, ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,
    
    [parameter(Mandatory=$false, ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$RequestedFor,      

    [parameter(Mandatory=$false, ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,
    
    [parameter(Mandatory=$false, ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Reasons,

    [parameter(Mandatory=$true,ValueFromPipeline=$true, ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON,  
    
    [parameter(Mandatory=$false)] 
    [Switch]$Wait
    
    )    

    begin {

        Write-Warning -Message "This command is deprecated and will be removed in a future release. Please use Request-vRACatalogItem instead."

        # --- Test for vRA API version
        xRequires -Version 7 -Context $MyInvocation
    }
    
    process {
    
        try {

            if ($PSBoundParameters.ContainsKey("JSON")) {

                # --- Get the Id of the catalog Item being requested then POST            
                $Id = ($JSON | ConvertFrom-Json).catalogItemId      
                Write-Verbose -Message "Got cataligItemId from payload: $($Id)"

                }
            else {

                # --- Get request Template
                $JSON = Get-vRAConsumerCatalogItemRequestTemplate -Id $Id

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
                
                Write-Verbose -Message "Got catalog item id:  $($Id)"

                $URI = "/catalog-service/api/consumer/entitledCatalogItems/$($Id)/requests"
                
                Write-Verbose -Message "Preparing POST to $($URI)"

                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $JSON          
                
                Write-Verbose -Message "POST Success"              
                
                if ($PSBoundParameters.ContainsKey("Wait")) {
                    
                    Write-Verbose -Message "Wait switch detected"
 
                    Write-Verbose -Message "Preparing GET to $($URI)"
                    
                    While($true) {
                        
                        $URI = "/catalog-service/api/consumer/requests/$($Response.Id)"                       
                        
                        $Request = Invoke-vRARestMethod -Method Get -URI $URI
                        
                        # --- Undecided whether to use State or Phase property for this
                        Write-Verbose -Message "State: $($Request.state)"
                        Write-Verbose -Message "Phase: $($Request.phase)"
                        
                        if ($Request.state -eq "SUCCESSFUL" -or $Request.state -Like "*FAILED") {
                            
                            if ($Request.state -Like "*FAILED") {
                                
                                throw "$($Request.requestCompletion.completionDetails)"
                                
                            }
                            
                            Write-Verbose -Message "Request $($Request.id) was successful"
                            break
                        }
                        
                        Start-Sleep -Seconds 5
                        
                    }
                    
                    # --- Return the deployed resource
                    
                    Write-Verbose -Message "Getting deployed Resource"
                    
                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)/resourceViews"

                    foreach ($Resource in $Response.content) {

                        [pscustomobject] @{

                            ResourceId = $Resource.ResourceId
                            IconId = $Resource.IconId
                            Name = $Resource.Name
                            Description = $Resource.Description
                            Status = $Resource.Status
                            CatalogItemId = $Resource.CatalogItemId
                            CatalogItemLabel = $Resource.CatalogItemLabel
                            RequestId = $Resource.RequestId
                            ResourceType = $Resource.ResourceType
                            Owners = $Resource.Owners
                            BusinessGroupId = $Resource.BusinessGroupId
                            TenantId = $Resource.TenantId
                            DateCreated = $Resource.DateCreated
                            LastUpdated = $Resource.LastUpdated
                            Lease = $Resource.Lease
                            Costs = $Resource.Costs
                            CostToDate = $Resource.CostToDate
                            TotalCost = $Resource.TotalCost
                            ParentResourceId = $Resource.ParentResourceId
                            HasChildren = $Resource.HasChildren
                            Data = $Resource.Data
                            Links = $Resource.Links

                        }

                    }
                    
                }
                else {
                    
                    # --- Return the Id of the request
                    Write-Verbose -Message "Request id is $($Response.id)"
                    
                    [pscustomobject] @{
                        
                        RequestId = $Response.id
                        
                    }
                    
                }
             
            }                                 

        }
        catch [Exception]{
        
            throw
        
        }    
        
    }

}