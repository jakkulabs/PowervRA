# Get-vRACatalogPrincipal

## SYNOPSIS
    
Finds catalog principals

## SYNTAX
 Get-vRACatalogPrincipal -Id <String[]> [-Limit <String>] [<CommonParameters>]    

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

C:\PS>Get-vRACatalogPrincipal -Id group@vsphere.local







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRACatalogPrincipal -Id user@vsphere.local







-------------------------- EXAMPLE 3 --------------------------

C:\PS>Get-vRACatalogPrincipal -Id group@vsphere.local
```

