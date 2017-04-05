# Get-vRAResourceOperation

## SYNOPSIS
Get a resource operation

## SYNTAX

### Standard (Default)
```
Get-vRAResourceOperation [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAResourceOperation -Id <String[]>
```

### ByExternalId
```
Get-vRAResourceOperation -ExternalId <String[]>
```

## DESCRIPTION
A resource operation represents a Day-2 operation that can be performed on a resource. 
Resource operations are registered in the Service Catalog and target a specific resource type. 
These operations can be invoked / accessed by consumers through the self-service interface on the resources they own.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAResourceOperation
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAResourceOperation -Id "a4d57b16-9706-471b-9960-d0855fe544bb"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAResourceOperation -Name "Power On"
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAResourceOperation -ExternalId "Infrastructure.Machine.Action.PowerOn"
```

## PARAMETERS

### -Id
The id of the resource operation

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ExternalId
The external id of the resource operation

```yaml
Type: String[]
Parameter Sets: ByExternalId
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The index of the page to display.

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String
System.Int

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

