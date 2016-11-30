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

    .PARAMETER State
    Show request that match a certain state

    Supported states are:

        UNSUBMITTED,
        SUBMITTED,
        DELETED,
        PENDING_PRE_APPROVAL,
        PRE_APPROVAL_SEND_ERROR,
        PRE_APPROVED,
        PRE_REJECTED,
        PROVIDER_DELETION_ERROR,
        IN_PROGRESS,
        PROVIDER_SEND_ERROR,
        PROVIDER_COMPLETED,
        PROVIDER_FAILED,
        PENDING_POST_APPROVAL,
        POST_APPROVAL_SEND_ERROR,
        POST_APPROVED,
        POST_REJECTION_RECEIVED,
        ROLLBACK_ERROR,
        POST_REJECTED,
        SUCCESSFUL,
        PARTIALLY_SUCCESSFUL,
        FAILED

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

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id,
        
        [Parameter(Mandatory=$true,ParameterSetName="ByRequestNumber")]
        [ValidateNotNullOrEmpty()]
        [String[]]$RequestNumber,

        [Parameter(Mandatory=$false,ParameterSetName="RequestedFor")]
        [ValidateNotNullOrEmpty()]
        [String]$RequestedFor,

        [Parameter(Mandatory=$false,ParameterSetName="RequestedBy")]
        [ValidateNotNullOrEmpty()]
        [String]$RequestedBy,

        [Parameter(Mandatory=$false,ParameterSetName="State")]
        [ValidateSet(
            "UNSUBMITTED",
            "SUBMITTED",
            "DELETED",
            "PENDING_PRE_APPROVAL",
            "PRE_APPROVAL_SEND_ERROR",
            "PRE_APPROVED",
            "PRE_REJECTED",
            "PROVIDER_DELETION_ERROR",
            "IN_PROGRESS",
            "PROVIDER_SEND_ERROR",
            "PROVIDER_COMPLETED",
            "PROVIDER_FAILED",
            "PENDING_POST_APPROVAL",
            "POST_APPROVAL_SEND_ERROR",
            "POST_APPROVED",
            "POST_REJECTION_RECEIVED",
            "ROLLBACK_ERROR",
            "POST_REJECTED",
            "SUCCESSFUL",
            "PARTIALLY_SUCCESSFUL",
            "FAILED"
        )]
        [String]$State,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [Parameter(Mandatory=$false,ParameterSetName="RequestedFor")]
        [Parameter(Mandatory=$false,ParameterSetName="RequestedBy")] 
        [Parameter(Mandatory=$false,ParameterSetName="State")]       
        [ValidateNotNullOrEmpty()]
        [Int]$Limit = 100,
    
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [Parameter(Mandatory=$false,ParameterSetName="RequestedFor")]
        [Parameter(Mandatory=$false,ParameterSetName="RequestedBy")]
        [Parameter(Mandatory=$false,ParameterSetName="State")]      
        [ValidateNotNullOrEmpty()]
        [int]$Page = 1

    )

    Begin {

    }

    Process {

        try {

            switch ($PsCmdlet.ParameterSetName) {

                # --- If the id parameter is passed returned detailed information about the request
                'ById' { 

                    foreach ($RequestId in $Id) {

                        $URI = "/catalog-service/api/consumer/requests/$($RequestId)"

                        $Request = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

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

                        $EscapedURI = [uri]::EscapeUriString($URI)

                        $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

                        if ($Response.content.Count -eq 0) {

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
                {('Standard') -or ('RequestedFor') -or ('RequestedBy') -or ('State')} {

                    $URI = "/catalog-service/api/consumer/requests?limit=$($Limit)&page=$($Page)&`$orderby=dateSubmitted desc"

                    if ($PSBoundParameters.ContainsKey("RequestedFor")) {

                        $URI = "$($URI)&`$filter=requestedFor eq '$($RequestedFor)'"

                    }

                    if ($PSBoundParameters.ContainsKey("RequestedBy")) {

                        $URI = "$($URI)&`$filter=requestedBy eq '$($RequestedBy)'"

                    }

                    if ($PSBoundParameters.ContainsKey("State")) {

                        $URI = "$($URI)&`$filter=state eq '$($State)'"

                    }

                    $EscapedURI = [uri]::EscapeUriString($URI)

                    # --- Make the first request to determine the size of the request
                    $Response = Invoke-vRARestMethod -Method GET -URI $EscapedURI -Verbose:$VerbosePreference

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

    End {

    }

}