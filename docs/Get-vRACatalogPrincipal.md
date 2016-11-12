---
external help file: Get-vRACatalogPrincipal-help.xml
online version: 
schema: 2.0.0
---

# Get-vRACatalogPrincipal

## SYNOPSIS
Finds catalog principals

## SYNTAX

```
Get-vRACatalogPrincipal -Id <String[]>
```

## DESCRIPTION
Internal function to find users or groups and return them as the api type catalogPrincipal.
 

DOCS: catalog-service/api/docs/ns0_catalogPrincipal.html

\[pscustomobject\] is returned with lowercase property names to commply with expected payload

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRACatalogPrincipal -Id group@vsphere.local
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRACatalogPrincipal -Id user@vsphere.local
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRACatalogPrincipal -Id group@vsphere.local
```

## PARAMETERS

### -Id
The Id of the group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Principal

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

