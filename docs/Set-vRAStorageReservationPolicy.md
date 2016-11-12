---
external help file: Set-vRAStorageReservationPolicy-help.xml
online version: 
schema: 2.0.0
---

# Set-vRAStorageReservationPolicy

## SYNOPSIS
Update a vRA Storage Reservation Policy

## SYNTAX

### ById (Default)
```
Set-vRAStorageReservationPolicy -Id <String> [-NewName <String>] [-Description <String>] [-WhatIf] [-Confirm]
```

### ByName
```
Set-vRAStorageReservationPolicy -Name <String> [-NewName <String>] [-Description <String>] [-WhatIf] [-Confirm]
```

### JSON
```
Set-vRAStorageReservationPolicy -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Update a vRA Storage Reservation Policy

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-vRAStorageReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd" -NewName "NewName" -Description "This is the New Name"
```

### -------------------------- EXAMPLE 2 --------------------------
```
Set-vRAStorageReservationPolicy -Name StorageReservationPolicy01 -NewName "NewName" -Description "This is the New Name"
```

### -------------------------- EXAMPLE 3 --------------------------
```
$JSON = @"
```

{
  "id": "34ae1d6c-9972-4736-acdb-7ee109ad1dbd",
  "name": "StorageReservationPolicy01",
  "description": "This is Storage Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
}
"@
$JSON | Set-vRAStorageReservationPolicy -Confirm:$false

## PARAMETERS

### -Id
Storage Reservation Policy Id

```yaml
Type: String
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Storage Reservation Policy Name

```yaml
Type: String
Parameter Sets: ByName
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Storage Reservation Policy NewName

```yaml
Type: String
Parameter Sets: ById, ByName
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Storage Reservation Policy Description

```yaml
Type: String
Parameter Sets: ById, ByName
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JSON
Body text to send in JSON format

```yaml
Type: String
Parameter Sets: JSON
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

