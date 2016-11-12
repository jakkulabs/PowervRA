# Set-vRAEntitlement

## SYNOPSIS
Update an existing entitlement

## SYNTAX

```
Set-vRAEntitlement [-Id] <String> [[-Name] <String>] [[-Description] <String>] [[-Principals] <String[]>]
 [[-EntitledCatalogItems] <String[]>] [[-EntitledResourceOperations] <String[]>]
 [[-EntitledServices] <String[]>] [[-Status] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Update an existing entitlement

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-vRAEntitlement -Id "e5cd1c84-3b76-4ae9-9f2e-35114da6cfd2" -Name "Updated Name"
```

### -------------------------- EXAMPLE 2 --------------------------
```
Set-vRAEntitlement -Id "e5cd1c84-3b76-4ae9-9f2e-35114da6cfd2" -Name "Updated Name" -Description "Updated Description" -Principals "user@vsphere.local" -EntitledCatalogItems "Centos" -EntitledServices "A service" -EntitledResourceOperations "Infrastructure.Machine.Action.PowerOff" -Status ACTIVE
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAEntitlement -Name "Entitlement 1" | Set-vRAEntitlement -Description "Updated description!"
```

## PARAMETERS

### -Id
The id of the entitlement

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
The name of the entitlement

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
A description of the entitlement

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

### -Principals
Users or groups that will be associated with the entitlement

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntitledCatalogItems
One or more entitled catalog item

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntitledResourceOperations
The externalId of one or more entitled resource operation (e.g.
Infrastructure.Machine.Action.PowerOn)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntitledServices
One or more entitled service

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
The status of the entitlement.
Accepted values are ACTIVE and INACTIVE

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 8
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

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

