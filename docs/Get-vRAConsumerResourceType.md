# Get-vRAConsumerResourceType

## SYNOPSIS
    
Get a consumer resource type

## SYNTAX
 Get-vRAConsumerResourceType [-Limit <String>] [<CommonParameters>] Get-vRAConsumerResourceType [-Id <String[]>] [-Limit <String>] [<CommonParameters>] Get-vRAConsumerResourceType [-Name <String[]>] [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

A Resource type is a type assigned to resources. The types are defined by the provider types. 
It allows similar resources to be grouped together.

## PARAMETERS


### Id

The id of the resource type

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The Name of the resource type

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAConsumerResourceType







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAConsumerResourceType -Id "Infrastructure.Machine"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAConsumerResourceType -Name "Machine"
```

