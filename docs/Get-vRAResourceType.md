# Get-vRAResourceType

## SYNOPSIS
    
Get a resource type

## SYNTAX
 Get-vRAResourceType [-Page <Int32>] [-Limit <Int32>] [<CommonParameters>]  Get-vRAResourceType -Id <String[]> [<CommonParameters>]  Get-vRAResourceType -Name <String[]> [<CommonParameters>]     

## DESCRIPTION

A Resource type is a type assigned to resources. The types are defined by the provider types. 
It allows similar resources to be grouped together.

## PARAMETERS


### Id

The id of the resource type

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### Name

The Name of the resource type

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

PS C:\>Get-vRAResourceType






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAResourceType -Id "Infrastructure.Machine"






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAResourceType -Name "Machine"
```

