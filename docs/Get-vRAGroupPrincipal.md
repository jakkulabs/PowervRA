# Get-vRAGroupPrincipal

## SYNOPSIS
    
Finds groups.

## SYNTAX
 Get-vRAGroupPrincipal [-Tenant <String>] [-Limit <String>] [<CommonParameters>]  Get-vRAGroupPrincipal -Id <String[]> [-Tenant <String>] [<CommonParameters>]     

## DESCRIPTION

Finds groups in one of the identity providers configured for the tenant.

## PARAMETERS


### Id

The Id of the group

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Tenant

The tenant of the group

* Required: false
* Position: named
* Default value: $Global:vRAConnection.Tenant
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAGroupPrincipal






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAGroupPrincipal -Id group@vsphere.local






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAGroupPrincipal -PrincipalId group@vsphere.local
```

