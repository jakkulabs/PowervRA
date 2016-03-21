# Get-vRABusinessGroup

## SYNOPSIS
    
Retrieve vRA Business Groups

## SYNTAX
 Get-vRABusinessGroup [-TenantId] <String> [[-Name] <String[]>] [[-Limit] <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Business Groups

## PARAMETERS


### TenantId

Specify the ID of a Tenant

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: false

### Name

Specify the Name of a Business Group

* Required: false
* Position: 2
* Default value: 
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: 3
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

C:\PS>Get-vRABusinessGroup -TenantId Tenant01







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01,BusinessGroup02
```

