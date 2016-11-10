# Get-vRAService

## SYNOPSIS
    
Retrieve vRA services that the user is has access to

## SYNTAX
 Get-vRAService [-Page <Int32>] [-Limit <Int32>] [<CommonParameters>]  Get-vRAService -Id <String[]> [<CommonParameters>]  Get-vRAService -Name <String[]> [<CommonParameters>]     

## DESCRIPTION

A service represents a customer-facing/user friendly set of activities. In the context of this Service Catalog, 
these activities are the catalog items and resource actions. 
A service must be owned by a specific organization and all the activities it contains should belongs to the same organization.

## PARAMETERS


### Id

The id of the service

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### Name

The Name of the service

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Page

The index of the page to display.

* Required: false
* Position: named
* Default value: 1
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String
System.Int

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAService






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAService -Id 332d38d5-c8db-4519-87a7-7ef9f358091a






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAService -Name "Default Service"
```

