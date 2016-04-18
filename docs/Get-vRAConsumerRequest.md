# Get-vRAConsumerRequest

## SYNOPSIS
    
Get information about vRA requests

## SYNTAX
 Get-vRAConsumerRequest [-Limit <String>] [-Page <Int32>] [<CommonParameters>] Get-vRAConsumerRequest -Id <String[]> [<CommonParameters>] Get-vRAConsumerRequest -RequestNumber <String[]> [<CommonParameters>]    

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

### Page

The page of response to return

* Required: false
* Position: named
* Default value: 1
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject
System.Object[]

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAConsumerRequest







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAConsumerRequest -Limit 9999







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAConsumerRequest -Id 697db588-b706-4836-ae38-35e0c7221e3b







-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRAConsumerRequest -RequestNumber 3
```

