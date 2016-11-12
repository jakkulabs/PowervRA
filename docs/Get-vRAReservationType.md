---
external help file: Get-vRAReservationType-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAReservationType

## SYNOPSIS
Get supported reservation types

## SYNTAX

### Standard (Default)
```
Get-vRAReservationType [-Limit <Int32>] [-Page <Int32>]
```

### ById
```
Get-vRAReservationType -Id <String[]>
```

### ByName
```
Get-vRAReservationType -Name <String[]>
```

## DESCRIPTION
Get supported reservation types

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservationType -Id "Infrastructure.Reservation.Cloud.vCloud"
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAReservationType -Name "vCloud Director"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAReservationType
```

## PARAMETERS

### -Id
The id of the reservation type

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the reservation type

```yaml
Type: String[]
Parameter Sets: ByName
Aliases: 

Required: True
Position: Named
Default value: None
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

### -Page
The page of response to return.
All pages are retuend by default.

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

### System.String.
System.Int.

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

