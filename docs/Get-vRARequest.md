# Get-vRARequest

## SYNOPSIS
Get information about vRA requests

## SYNTAX

### Standard (Default)
```
Get-vRARequest [-Limit <Int32>] [-Page <Int32>]
```

### ById
```
Get-vRARequest -Id <String[]>
```

### ByRequestNumber
```
Get-vRARequest -RequestNumber <String[]>
```

### RequestedFor
```
Get-vRARequest [-RequestedFor <String>] [-Limit <Int32>] [-Page <Int32>]
```

### RequestedBy
```
Get-vRARequest [-RequestedBy <String>] [-Limit <Int32>] [-Page <Int32>]
```

### State
```
Get-vRARequest [-State <String>] [-Limit <Int32>] [-Page <Int32>]
```

## DESCRIPTION
Get information about vRA requests.
These are the same services that you will see via the service tab

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRARequest
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRARequest -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRARequest -RequestedFor user@vsphere.local
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRARequest -RequestedBy user@vsphere.local
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRARequest -Id 697db588-b706-4836-ae38-35e0c7221e3b
```

### -------------------------- EXAMPLE 6 --------------------------
```
Get-vRARequest -RequestNumber 3
```

## PARAMETERS

### -Id
The Id of the request to query

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -RequestNumber
The reqest number of the request to query

```yaml
Type: String[]
Parameter Sets: ByRequestNumber
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestedFor
Show requests that were submitted on behalf of a certain user

```yaml
Type: String
Parameter Sets: RequestedFor
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestedBy
Show requests that were submitted by a certain user

```yaml
Type: String
Parameter Sets: RequestedBy
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
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

```yaml
Type: String
Parameter Sets: State
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: Int32
Parameter Sets: Standard, RequestedFor, RequestedBy, State
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The page of response to return

```yaml
Type: Int32
Parameter Sets: Standard, RequestedFor, RequestedBy, State
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String
System.Int

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

