# Get-vRAConsumerResourceOperation

## SYNOPSIS
    
Get a consumer resource operation

## SYNTAX
 Get-vRAConsumerResourceOperation -Id <String[]> [<CommonParameters>]    

## DESCRIPTION

Consumer Resource Operation API exposed to users. A resource operation represents a Day-2 operation that can be performed on a resource.
Resource operations are registered in the Service Catalog and target a specific resource type. 
These operations can be invoked / accessed by consumers through the self-service interface on the resources they own.

## PARAMETERS


### Id

The id of the resource operation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAConsumerResourceOperation -Id "a4d57b16-9706-471b-9960-d0855fe544bb"
```

