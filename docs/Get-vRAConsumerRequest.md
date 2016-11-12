---
external help file: DEPRECATED-Get-vRAConsumerRequest-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAConsumerRequest

## SYNOPSIS
Get information about vRA requests

## SYNTAX

### Standard (Default)
```
Get-vRAConsumerRequest [-Limit <String>] [-Page <Int32>]
```

### ById
```
Get-vRAConsumerRequest -Id <String[]>
```

### ByRequestNumber
```
Get-vRAConsumerRequest -RequestNumber <String[]>
```

## DESCRIPTION
Get information about vRA requests.
These are the same services that you will see via the service tab

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAConsumerRequest
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAConsumerRequest -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAConsumerRequest -Id 697db588-b706-4836-ae38-35e0c7221e3b
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAConsumerRequest -RequestNumber 3
```

## PARAMETERS

### -Id
The Id of the request to query

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RequestNumber
The reqest number of the request to query

```yaml
Type: String[]
Parameter Sets: ByRequestNumber
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The page of response to return

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

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject
System.Object[]

## NOTES

## RELATED LINKS

