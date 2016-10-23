# Get-vRAResourceAction

## SYNOPSIS
    
Retrieve available Resource Actions for a resource

## SYNTAX
 Get-vRAResourceAction [-ResourceId] <String[]> [<CommonParameters>]     

## DESCRIPTION

A resourceAction is a specific type of ResourceOperation that is performed by submitting a request.

## PARAMETERS


### ResourceId

The id of the resource

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAConsumerResource -Name vm01 | Get-vRAResourceAction






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAConsumerResource -Name vm01 | Get-vRAResourceAction | Select Id, Name, BindingId
```

