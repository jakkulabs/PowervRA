function Get-vRARequest {
<#
    .SYNOPSIS
    Get information about vRA requests
    
    .DESCRIPTION
    Get information about vRA requests. These are the same services that you will see via the service tab 
    
    .PARAMETER Id
    The Id of the request to query
    
    .PARAMETER RequestNumber
    The reqest number of the request to query

    .PARAMETER RequestedFor
    Show requests that were submitted on behalf of a certain user

    .PARAMETER RequestedBy
    Show requests that were submitted by a certain user

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .PARAMETER Page
    The page of response to return

    .INPUTS
    System.String
    System.Int

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRARequest

    .EXAMPLE
    Get-vRARequest -Limit 9999

    .EXAMPLE
    Get-vRARequest -RequestedFor user@vsphere.local

    .EXAMPLE
    Get-vRARequest -RequestedBy user@vsphere.local

    .EXAMPLE
    Get-vRARequest -Id 697db588-b706-4836-ae38-35e0c7221e3b
    
    .EXAMPLE
    Get-vRARequest -RequestNumber 3

#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject', 'System.Object[]')]

    Param (

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName,ParameterSetName="ByRequestNumber")]
        [ValidateNotNullOrEmpty()]
        [String[]]$RequestNumber,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName,ParameterSetName="RequestedFor")]
        [ValidateNotNullOrEmpty()]
        [String]$RequestedFor,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName,ParameterSetName="RequestedBy")]
        [ValidateNotNullOrEmpty()]
        [String]$RequestedBy,

        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Standard")]
        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="RequestedFor")]
        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="RequestedBy")]      
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100,
    
        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Standard")]
        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="RequestedFor")]
        [Parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="RequestedBy")]        
        [ValidateNotNullOrEmpty()]
        [int]$Page = 1

    )

    try {

        # --- Build base URI

        switch ($PsCmdlet.ParameterSetName) {

            # --- If the id parameter is passed returned detailed information about the request
            'ById' { 

                foreach ($RequestId in $Id) {

                    $URI = "/catalog-service/api/consumer/requests/$($RequestId)"

                    $EncodedURI = [uri]::EscapeUriString($URI)

                    $Request = Invoke-vRARestMethod -Method GET -URI $EncodedURI -Verbose:$VerbosePreference

                    if ($Request.Length -eq 0) {

                        throw "Could not find request $($Id)"

                    }

                    [PSCustomObject] @{

                        Id = $Request.id
                        RequestNumber = $Request.RequestNumber
                        State = $Request.state
                        Description = $Request.description
                        CatalogItem = $Request.catalogItemRef.label
                        RequestedItemName = $Request.requestedItemName
                        RequestedItemDescription = $Request.requestedItemDescription                                                
                        Reasons = $Request.reasons
                        RequestedFor = $Request.requestedFor
                        RequestedBy = $Request.requestedBy
                        DateCreated = $Request.dateCreated
                        LastUpdated = $Request.lastUpdated
                        DateSubmitted = $Request.dateSubmitted
                        DateApproved = $Request.dateApproved
                        DateCompleted = $Request.dateCompleted
                        WaitingStatus = $Request.waitingStatus
                        ExecutionStatus = $Request.executionStatus
                        ApprovalStatus = $Request.approvalStatus
                        Phase = $Request.phase
                        IconId = $Request.iconId
                        Version = $Request.version
                        Organization = $Request.organization
                        RequestorEntitlementId = $Request.requestorEntitlementId
                        PreApprovalId = $Request.preApprovalId
                        PostApprovalId = $Request.postApprovalId
                        Quote = $Request.quote
                        RequestCompletion = $Request.requestCompletion
                        RequestData = $Request.requestData
                        RetriesRemaining = $Request.retriesRemaining
                        Components = $Request.components
                        StateName = $Request.stateName
                        CatalogItemProviderBinding = $Request.catalogItemProviderBinding

                    }

                }

                break

            }
            # --- If the requestnumber parameter is passed returned detailed information about the request
            'ByRequestNumber' {

                foreach ($RequestN in $RequestNumber) {

                    $URI = "/catalog-service/api/consumer/requests?`$filter=requestNumber eq '$($RequestN)'"

                    $EncodedURI = [uri]::EscapeUriString($URI)

                    $Response = Invoke-vRARestMethod -Method GET -URI $EncodedURI -Verbose:$VerbosePreference

                    if ($Response.content.Length -eq 0) {

                        throw "Could not find request number $($RequestN)"

                    }

                    $Request = $Response.content

                    [PSCustomObject] @{

                        Id = $Request.id
                        RequestNumber = $Request.RequestNumber
                        State = $Request.state
                        Description = $Request.description
                        CatalogItem = $Request.catalogItemRef.label
                        RequestedItemName = $Request.requestedItemName
                        RequestedItemDescription = $Request.requestedItemDescription                                                
                        Reasons = $Request.reasons
                        RequestedFor = $Request.requestedFor
                        RequestedBy = $Request.requestedBy
                        DateCreated = $Request.dateCreated
                        LastUpdated = $Request.lastUpdated
                        DateSubmitted = $Request.dateSubmitted
                        DateApproved = $Request.dateApproved
                        DateCompleted = $Request.dateCompleted
                        WaitingStatus = $Request.waitingStatus
                        ExecutionStatus = $Request.executionStatus
                        ApprovalStatus = $Request.approvalStatus
                        Phase = $Request.phase
                        IconId = $Request.iconId
                        Version = $Request.version
                        Organization = $Request.organization
                        RequestorEntitlementId = $Request.requestorEntitlementId
                        PreApprovalId = $Request.preApprovalId
                        PostApprovalId = $Request.postApprovalId
                        Quote = $Request.quote
                        RequestCompletion = $Request.requestCompletion
                        RequestData = $Request.requestData
                        RetriesRemaining = $Request.retriesRemaining
                        Components = $Request.components
                        StateName = $Request.stateName
                        CatalogItemProviderBinding = $Request.catalogItemProviderBinding

                    }

                }

                break

            }
            {('Standard') -or ('RequestedFor') -or ('RequestedBy')} {

                $URI = "/catalog-service/api/consumer/requests?limit=$($Limit)&page=$($Page)&`$orderby=dateSubmitted desc"

                if ($PSBoundParameters.ContainsKey("RequestedFor")) {

                    $URI = "$($URI)&`$filter=requestedFor eq '$($RequestedFor)'"

                }

                if ($PSBoundParameters.ContainsKey("RequestedBy")) {

                    $URI = "$($URI)&`$filter=requestedBy eq '$($RequestedBy)'"

                }

                $EncodedURI = [uri]::EscapeUriString($URI)

                # --- Make the first request to determine the size of the request
                $Response = Invoke-vRARestMethod -Method GET -URI $EncodedURI -Verbose:$VerbosePreference

                foreach ($Request in $Response.content) {

                    [PSCustomObject] @{

                        Id = $Request.id
                        RequestNumber = $Request.RequestNumber
                        State = $Request.state
                        Description = $Request.description
                        CatalogItem = $Request.catalogItemRef.label
                        RequestedItemName = $Request.requestedItemName
                        RequestedItemDescription = $Request.requestedItemDescription                                                
                        Reasons = $Request.reasons
                        RequestedFor = $Request.requestedFor
                        RequestedBy = $Request.requestedBy
                        DateCreated = $Request.dateCreated
                        LastUpdated = $Request.lastUpdated
                        DateSubmitted = $Request.dateSubmitted
                        DateApproved = $Request.dateApproved
                        DateCompleted = $Request.dateCompleted
                        WaitingStatus = $Request.waitingStatus
                        ExecutionStatus = $Request.executionStatus
                        ApprovalStatus = $Request.approvalStatus
                        Phase = $Request.phase
                        IconId = $Request.iconId
                        Version = $Request.version
                        Organization = $Request.organization
                        RequestorEntitlementId = $Request.requestorEntitlementId
                        PreApprovalId = $Request.preApprovalId
                        PostApprovalId = $Request.postApprovalId
                        Quote = $Request.quote
                        RequestCompletion = $Request.requestCompletion
                        RequestData = $Request.requestData
                        RetriesRemaining = $Request.retriesRemaining
                        Components = $Request.components
                        StateName = $Request.stateName
                        CatalogItemProviderBinding = $Request.catalogItemProviderBinding

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