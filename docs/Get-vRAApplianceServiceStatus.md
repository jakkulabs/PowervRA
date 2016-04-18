# Get-vRAApplianceServiceStatus

## SYNOPSIS
    
Get information about vRA services

## SYNTAX
 Get-vRAApplianceServiceStatus [[-Name] <String[]>] [[-Limit] <String>] [<CommonParameters>]    

## DESCRIPTION

Get information about vRA services. These are the same services that you will see via the service tab

## PARAMETERS


### Name

The name of the service to query

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

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAApplianceServiceStatus







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAApplianceServiceStatus -Limit 9999







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAApplianceServiceStatus -Name iaas-service
```

