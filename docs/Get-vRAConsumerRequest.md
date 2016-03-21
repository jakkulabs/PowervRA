# Get-vRAConsumerRequest

## SYNOPSIS
    
Get information about vRA requests

## SYNTAX
 Get-vRAConsumerRequest [-Limit <String>] [<CommonParameters>] Get-vRAConsumerRequest -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAConsumerRequest -RequestNumber <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Get information about vRA requests. These are the same services that you will see via the service tab

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

C:\PS>Get-vRAConsumerRequest







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRAConsumerRequest -Limit 9999







-------------------------- EXAMPLE 3 --------------------------

C:\PS>Get-vRAConsumerRequest -Id 697db588-b706-4836-ae38-35e0c7221e3b







-------------------------- EXAMPLE 4 --------------------------

C:\PS>Get-vRAConsumerRequest -RequestNumber 3
```

