# Get-vRAGroupPrincipal

## SYNOPSIS
    
Finds groups.

## SYNTAX
 Get-vRAGroupPrincipal [-Limit <String>] [<CommonParameters>] Get-vRAGroupPrincipal -Id <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Finds groups in one of the identity providers configured for the tenant.

## PARAMETERS


### Id

The Id of the group

* Required: true
* Position: named
* Default value: 
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

C:\PS>Get-vRAGroupPrincipal







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRAGroupPrincipal -Id group@vsphere.local







-------------------------- EXAMPLE 3 --------------------------

C:\PS>Get-vRAGroupPrincipal -GroupName group@vsphere.local
```

