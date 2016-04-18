# Get-vRATenant

## SYNOPSIS
    
Retrieve vRA Tenants

## SYNTAX
 Get-vRATenant [[-Id] <String[]>] [[-Limit] <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Tenants. Make sure to have permission to access all Tenant information

## PARAMETERS


### Id

Specify the ID of a Tenant

* Required: false
* Position: 1
* Default value: 
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: 2
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRATenant







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRATenant -Id Tenant01
```

