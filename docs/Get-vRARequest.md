# Get-vRARequest

## SYNOPSIS
    
Get information about vRA requests

## SYNTAX
 Get-vRARequest [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>]  Get-vRARequest -Id <String[]> [<CommonParameters>]  Get-vRARequest -RequestNumber <String[]> [<CommonParameters>]  Get-vRARequest [-RequestedFor <String>] [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>]  Get-vRARequest [-RequestedBy <String>] [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>]  Get-vRARequest [-State <String>] [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>]     

## DESCRIPTION

Get information about vRA requests. These are the same services that you will see via the service tab

## PARAMETERS


### Id

The Id of the request to query

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### RequestNumber

The reqest number of the request to query

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### RequestedFor

Show requests that were submitted on behalf of a certain user

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### RequestedBy

Show requests that were submitted by a certain user

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### State

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

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

### Page

The page of response to return

* Required: false
* Position: named
* Default value: 1
* Accept pipeline input: false

## INPUTS

System.String
System.Int

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRARequest






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRARequest -Limit 9999






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRARequest -RequestedFor user@vsphere.local






-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRARequest -RequestedBy user@vsphere.local






-------------------------- EXAMPLE 5 --------------------------

PS C:\>Get-vRARequest -Id 697db588-b706-4836-ae38-35e0c7221e3b






-------------------------- EXAMPLE 6 --------------------------

PS C:\>Get-vRARequest -RequestNumber 3
```

