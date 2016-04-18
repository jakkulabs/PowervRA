# Get-vRAServiceBlueprint

## SYNOPSIS
    
Retrieve vRA ASD Blueprints

## SYNTAX
 Get-vRAServiceBlueprint [-Limit <String>] [<CommonParameters>] Get-vRAServiceBlueprint -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAServiceBlueprint -Name <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA ASD Blueprints

## PARAMETERS


### Id

Specify the ID of an ASD Blueprint

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Specify the Name of an ASD Blueprint

* Required: true
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

PS C:\>Get-vRAServiceBlueprint







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAServiceBlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAServiceBlueprint -Name "ASDBlueprint01","ASDBlueprint02"
```

