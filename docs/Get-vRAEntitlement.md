# Get-vRAEntitlement

## SYNOPSIS
    
Retrieve vRA entitlements

## SYNTAX
 Get-vRAEntitlement [-Limit <String>] [<CommonParameters>] Get-vRAEntitlement [-Id <String[]>] [-Limit <String>] [<CommonParameters>] Get-vRAEntitlement [-Name <String[]>] [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA entitlement either by id or name. Passing no parameters will return all entitlements

## PARAMETERS


### Id

The id of the entitlement

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The Name of the entitlement

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

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAEntitlement







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAEntitlement -Id 332d38d5-c8db-4519-87a7-7ef9f358091a







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAEntitlement -Name "Default Entitlement"
```

