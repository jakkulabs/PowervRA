# Get-vRATenantDirectoryStatus

## SYNOPSIS
    
Retrieve vRA Tenant Directory Status

## SYNTAX
 Get-vRATenantDirectoryStatus [-Id] <String> [[-Domain] <String[]>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Tenant Directory Status

## PARAMETERS


### Id

Specify the ID of a Tenant

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: false

### Domain

Specify the Domain of a Tenant Directory

* Required: false
* Position: 2
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRATenantDirectoryStatus -Id Tenant01 -Domain vrademo.local







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRATenantDirectoryStatus -Id Tenant01 -Domain vrademo.local,test.local
```

