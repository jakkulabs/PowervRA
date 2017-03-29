# Set-vRAService

## SYNOPSIS
Set a vRA Service

## SYNTAX

```
Set-vRAService [-Id] <String> [[-Name] <String>] [[-Description] <String>] [[-Status] <String>]
 [[-Owner] <String>] [[-SupportTeam] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Set a vRA Service

Currently unsupported interactive actions:

* HoursStartTime
* HoursEndTime
* ChangeWindowDayOfWeek
* ChangeWindowStartTime
* ChangeWindowEndTime

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAService -Name "Default" | Set-vRAService -Owner user@vsphere.local
```

### -------------------------- EXAMPLE 2 --------------------------
```
Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh"
```

### -------------------------- EXAMPLE 4 --------------------------
```
Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh" -Owner "user@vsphere.local"
```

### -------------------------- EXAMPLE 5 --------------------------
```
Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh" -Owner "user@vsphere.local" -SupportTeam "support@vsphere.local"
```

### -------------------------- EXAMPLE 6 --------------------------
```
Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh" -Owner "user@vsphere.local" -SupportTeam "support@vsphere.local" -Status INACTIVE
```

## PARAMETERS

### -Id
The id of the service

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
The name of the service

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A description of the service

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
The status of the service

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Owner
The owner of the service

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SupportTeam
The support team of the service

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
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

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

