# Get-vRABlueprint

## SYNOPSIS
    
Retrieve vRA Blueprints

## SYNTAX
 Get-vRABlueprint [-Limit <String>] [<CommonParameters>] Get-vRABlueprint -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRABlueprint -Name <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Blueprints

## PARAMETERS


### Id

Specify the ID of a Blueprint

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Specify the Name of a Blueprint

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

PS C:\>Get-vRABlueprint







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRABlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRABlueprint -Name "Blueprint01","Blueprint02"
```

