# Get-vRAResource

## SYNOPSIS
    
Get a deployed resource

## SYNTAX
 Get-vRAResource [-Type <String>] [-WithExtendedData] [-WithOperations] [-ManagedOnly] [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>]  Get-vRAResource -Id <String[]> [<CommonParameters>]  Get-vRAResource -Name <String[]> [<CommonParameters>]     

## DESCRIPTION

A deployment represents a collection of deployed artifacts that have been provisioned by a provider.

## PARAMETERS


### Id

The id of the resource

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### Name

The Name of the resource

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Type

Show resources that match a certain type.

Supported types ar:

    Deployment,
    Machine

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### WithExtendedData

Populate the resources extended data by calling their provider

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### WithOperations

Populate the resources operations attribute by calling the provider. This will force withExtendedData to true.

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### ManagedOnly

Show resources owned by the users managed business groups, excluding any machines owned by the user in a non-managed
business group

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

### Page

The index of the page to display

* Required: false
* Position: named
* Default value: 1
* Accept pipeline input: false

## INPUTS

System.String
System.Int
Switch

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAResource






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRADeployment -WithExtendedData






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRADeployment -WithOperations






-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRADeployment -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"






-------------------------- EXAMPLE 5 --------------------------

PS C:\>Get-vRADeployment -Name "CENTOS-555667"
```

