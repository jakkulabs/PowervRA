# Get-vRAResourceActionRequestTemplate

## SYNOPSIS
    
Get the request template of a resource action that the user is entitled to see

## SYNTAX
 Get-vRAResourceActionRequestTemplate -ActionId <String> -ResourceId <String[]> [<CommonParameters>]  Get-vRAResourceActionRequestTemplate -ActionId <String> -ResourceName <String[]> [<CommonParameters>]     

## DESCRIPTION

Get the request template of a resource action that the user is entitled to see

## PARAMETERS


### ActionId


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ResourceId


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### ResourceName


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.String

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceName vm01






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAResourceActionRequestTemplate -ActionId "fae08c75-3506-40f6-9c9b-35966fe9125c" -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd
```

