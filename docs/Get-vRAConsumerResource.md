# Get-vRAConsumerResource

## SYNOPSIS
    
Get a provisioned resource

## SYNTAX
 Get-vRAConsumerResource [-WithExtendedData] [-WithOperations] [-Limit <String>] [<CommonParameters>] Get-vRAConsumerResource [-Id <String[]>] [-Limit <String>] [<CommonParameters>] Get-vRAConsumerResource [-Name <String[]>] [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

A Resource represents a deployed artifact that has been provisioned by a provider.

## PARAMETERS


### Id

The id of the resource

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The Name of the resource

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### WithExtendedData

Populate resources' extended data by calling their provider

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### WithOperations

Populate resources' operations attribute by calling the provider. This will force withExtendedData to true.

* Required: false
* Position: named
* Default value: False
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

C:\PS>Get-vRAConsumerResource







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRAConsumerResource -WithExtendedData







-------------------------- EXAMPLE 3 --------------------------

C:\PS>Get-vRAConsumerResource -WithOperations







-------------------------- EXAMPLE 4 --------------------------

C:\PS>Get-vRAConsumerResource -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"







-------------------------- EXAMPLE 5 --------------------------

C:\PS>Get-vRAConsumerResource -Name "vm-01"
```

