# New-vRAReservationStorageDefinition

## SYNOPSIS
    
Creates a new storage definition for a reservation

## SYNTAX
 New-vRAReservationStorageDefinition -Type <String> -ComputeResourceId <String> -Path <String> -ReservedSizeGB <Int32>  [-Priority <Int32>] [<CommonParameters>]    

## DESCRIPTION

Creates a new storage definition for a reservation. This cmdlet is used to create a custom
complex storage object. One or more of these can be added to an array and passed to New-vRAReservation.

## PARAMETERS


### Type


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ComputeResourceId


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Path

The storage path

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ReservedSizeGB


* Required: true
* Position: named
* Default value: 0
* Accept pipeline input: false

### Priority

The priority of storage

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

## INPUTS

System.String.
System.Int.

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>$StorageDefinitionArray = @()


$Storage1 = New-vRAReservationStorageDefinition -Type vSphere -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 
-Path "Datastore01" -ReservedSizeGB 10 -Priority 0 
$StorageDefinitionArray += $Storage1
```

