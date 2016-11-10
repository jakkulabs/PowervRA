# Get-vRAEntitledService

## SYNOPSIS
    
Retrieve vRA services that the user is entitled to see

## SYNTAX
 Get-vRAEntitledService [-Page <Int32>] [-Limit <Int32>] [<CommonParameters>]  Get-vRAEntitledService [-Id <String[]>] [<CommonParameters>]  Get-vRAEntitledService [-Name <String[]>] [<CommonParameters>]     

## DESCRIPTION

A service represents a customer-facing/user friendly set of activities. In the context of this Service Catalog, 
these activities are the catalog items and resource actions. 
A service must be owned by a specific organization and all the activities it contains should belongs to the same organization.

## PARAMETERS


### Id

The id of the service

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The Name of the service

* Required: false
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

PS C:\>Get-vRAEntitledService






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAEntitledService -Id 332d38d5-c8db-4519-87a7-7ef9f358091a






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAEntitledService -Name "Default Service"
```

