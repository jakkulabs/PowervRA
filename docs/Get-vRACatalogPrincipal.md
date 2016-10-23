# Get-vRACatalogPrincipal

## SYNOPSIS
    
Finds catalog principals

## SYNTAX
 Get-vRACatalogPrincipal -Id <String[]> [<CommonParameters>]     

## DESCRIPTION

Internal function to find users or groups and return them as the api type catalogPrincipal.  

DOCS: catalog-service/api/docs/ns0_catalogPrincipal.html

[pscustomobject] is returned with lowercase property names to commply with expected payload

## PARAMETERS


### Id

The Id of the group

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRACatalogPrincipal -Id group@vsphere.local






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRACatalogPrincipal -Id user@vsphere.local






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRACatalogPrincipal -Id group@vsphere.local
```

