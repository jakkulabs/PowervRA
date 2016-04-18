# Get-vRATenantDirectory

## SYNOPSIS
    
Retrieve vRA Tenant Directories

## SYNTAX
 Get-vRATenantDirectory [-Id] <String[]> [[-Limit] <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Tenant Directories

## PARAMETERS


### Id

Specify the ID of a Tenant

* Required: true
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

PS C:\>Get-vRATenantDirectory -Id Tenant01







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRATenantDirectory -Id Tenant01,Tenant02
```

