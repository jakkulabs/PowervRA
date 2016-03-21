# Get-vRARequest

## SYNOPSIS
    
Get information about vRA requests

## SYNTAX
 Get-vRARequest [-Limit <String>] [<CommonParameters>] Get-vRARequest -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRARequest -RequestNumber <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

The request captures the user's input (done through a form) and trigger the process that fulfills that order on the appropriate provider.

## PARAMETERS


### Id

The Id of the request to query
* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### RequestNumber

The reqest number of the request to query
* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Limit

The number of entries returned per page from the API. This has a default value of 100.
* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

C:\PS>Get-vRARequest







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRARequest -Limit 9999







-------------------------- EXAMPLE 3 --------------------------

C:\PS>Get-vRARequest -Id 697db588-b706-4836-ae38-35e0c7221e3b







-------------------------- EXAMPLE 4 --------------------------

C:\PS>Get-vRARequest -RequestNumber 3
```

