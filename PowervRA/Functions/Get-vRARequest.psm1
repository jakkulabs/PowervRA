function Get-vRARequest {
<#
    .SYNOPSIS
    Get information about vRA requests
    
    .DESCRIPTION
    The request captures the user's input (done through a form) and trigger the process that fulfills that order on the appropriate provider.
    
    .PARAMETER Id
    The Id of the request to query
    
    .PARAMETER RequestNumber
    The reqest number of the request to query

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRARequest

    .EXAMPLE
    Get-vRARequest -Limit 9999
    
    .EXAMPLE
    Get-vRARequest -Id 697db588-b706-4836-ae38-35e0c7221e3b
    
    .EXAMPLE
    Get-vRARequest -RequestNumber 3
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="ByRequestNumber")]
    [ValidateNotNullOrEmpty()]
    [String[]]$RequestNumber,    
    
    [parameter(Mandatory=$false,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"    
       
    )    

    try {

        # --- Build base URI
        $URI = "/catalog-service/api/consumer/requests"

        switch ($PsCmdlet.ParameterSetName) {

            # --- If the id parameter is passed returned detailed information about the request
            'ById' { 

                foreach ($RequestId in $Id) {
            
                    Write-Verbose -Message "Preparing GET to $($URI)/$($RequestId)"

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)/$($RequestId)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.Length -eq 0) {

                        throw "Could not find request $($Id)"

                    }

                    [pscustomobject] @{

                        Id = $Response.id
                        IconId = $Response.iconId
                        Version = $Response.version
                        RequestNumber = $Response.RequestNumber
                        State = $Response.state
                        Description = $Response.description
                        Reasons = $Response.reasons
                        RequestedFor = $Response.requestedFor
                        RequestedBy = $Response.requestedBy
                        Organization = $Response.organization
                        RequestorEntitlementId = $Response.requestorEntitlementId
                        PreApprovalId = $Response.preApprovalId
                        PostApprovalId = $Response.postApprovalId
                        DateCreated = $Response.dateCreated
                        LastUpdated = $Response.lastUpdated
                        DateSubmitted = $Response.dateSubmitted
                        DateApproved = $Response.dateApproved
                        DateCompleted = $Response.dateCompleted
                        Quote = $Response.quote
                        RequestCompletion = $Response.requestCompletion
                        RequestData = $Response.requestData
                        RetriesRemaining = $Response.retriesRemaining
                        RequestedItemName = $Response.requestedItemName
                        RequestedItemDescription = $Response.requestedItemDescription
                        Components = $Response.components
                        StateName = $Response.stateName
                        CatalogItemProviderBinding = $Response.catalogItemProviderBinding
                        WaitingStatus = $Response.waitingStatus
                        ExecutionStatus = $Response.executionStatus
                        ApprovalStatus = $Response.approvalStatus
                        Phase = $Response.phase
                        CatalogItemRef = $Response.catalogItemRef

                    }

                }

                break

            }
            # --- If the requestnumber parameter is passed returned detailed information about the request
            'ByRequestNumber' {

                foreach ($RequestN in $RequestNumber) {
            
                    $Filter = "requestNumber%20eq%20'$($RequestN)'"            
            
                    Write-Verbose -Message "Preparing GET to $($URI)?&`$filter=$($Filter)"

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)?&`$filter=$($Filter)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.content.Length -eq 0) {

                        throw "Could not find request number $($RequestN)"

                    }

                    [pscustomobject] @{

                        Id = $Response.content.id
                        IconId = $Response.content.iconId
                        Version = $Response.content.version
                        RequestNumber = $Response.content.RequestNumber
                        State = $Response.content.state
                        Description = $Response.content.description
                        Reasons = $Response.content.reasons
                        RequestedFor = $Response.content.requestedFor
                        RequestedBy = $Response.content.requestedBy
                        Organization = $Response.content.organization
                        RequestorEntitlementId = $Response.content.requestorEntitlementId
                        PreApprovalId = $Response.content.preApprovalId
                        PostApprovalId = $Response.content.postApprovalId
                        DateCreated = $Response.content.dateCreated
                        LastUpdated = $Response.content.lastUpdated
                        DateSubmitted = $Response.content.dateSubmitted
                        DateApproved = $Response.content.dateApproved
                        DateCompleted = $Response.content.dateCompleted
                        Quote = $Response.content.quote
                        RequestCompletion = $Response.content.requestCompletion
                        RequestData = $Response.content.requestData
                        RetriesRemaining = $Response.content.retriesRemaining
                        RequestedItemName = $Response.content.requestedItemName
                        RequestedItemDescription = $Response.content.requestedItemDescription
                        Components = $Response.content.components
                        StateName = $Response.content.stateName
                        CatalogItemProviderBinding = $Response.content.catalogItemProviderBinding
                        WaitingStatus = $Response.content.waitingStatus
                        ExecutionStatus = $Response.content.executionStatus
                        ApprovalStatus = $Response.content.approvalStatus
                        Phase = $Response.content.phase
                        CatalogItemRef = $Response.content.catalogItemRef

                    }                    
                }
                
                break                                          
        
            }
            # --- If no parameters are passed return all requests
            'Standard' {
            
                Write-Verbose -Message "Preparing GET to $($URI)?limit=$($Limit)"

                $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)?limit=$($Limit)"
            
                Write-Verbose -Message "Response contains $($Response.content.Length) records"

                foreach ($Request in $Response.content) {

                    [pscustomobject] @{

                        Id = $Request.id
                        IconId = $Request.iconId
                        Version = $Requestt.version
                        RequestNumber = $Request.RequestNumber
                        State = $Request.state
                        Description = $Request.description
                        Reasons = $Request.reasons
                        RequestedFor = $Request.requestedFor
                        RequestedBy = $Request.requestedBy
                        Organization = $Request.organization
                        RequestorEntitlementId = $RRequest.requestorEntitlementId
                        PreApprovalId = $Request.preApprovalId
                        PostApprovalId = $Request.postApprovalId
                        DateCreated = $Request.dateCreated
                        LastUpdated = $Request.lastUpdated
                        DateSubmitted = $Request.dateSubmitted
                        DateApproved = $Request.dateApproved
                        DateCompleted = $Request.dateCompleted
                        Quote = $Request.quote
                        RequestCompletion = $Request.requestCompletion
                        RequestData = $Request.requestData
                        RetriesRemaining = $Request.retriesRemaining
                        RequestedItemName = $Request.requestedItemName
                        RequestedItemDescription = $Request.requestedItemDescription
                        Components = $Request.components
                        StateName = $Request.stateName
                        CatalogItemProviderBinding = $Request.catalogItemProviderBinding
                        WaitingStatus = $Requestt.waitingStatus
                        ExecutionStatus = $Request.executionStatus
                        ApprovalStatus = $Request.approvalStatus
                        Phase = $Request.phase
                        CatalogItemRef = $Requestt.catalogItemRef

                    }

                }

                break
    
            }

        }
           
    }
    catch [Exception]{
        
        throw

    }   
     
}