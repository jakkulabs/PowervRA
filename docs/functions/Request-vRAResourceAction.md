# Request-vRAResourceAction

## SYNOPSIS
Request an available resourceAction for a catalog resource

## SYNTAX

### ByResourceId (Default)
```
Request-vRAResourceAction -ActionId <String> -ResourceId <String> [-Wait] [-WhatIf] [-Confirm]
```

### ByResourceName
```
Request-vRAResourceAction -ActionId <String> -ResourceName <String> [-Wait] [-WhatIf] [-Confirm]
```

### JSON
```
Request-vRAResourceAction -JSON <String> [-Wait] [-WhatIf] [-Confirm]
```

## DESCRIPTION
A resourceAction is a specific type of ResourceOperation that is performed by submitting a request. 
Unlike ResourceExtensions, resource actions can be invoked via the Service Catalog service and subject to approvals.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$ResourceActionId = (Get-vRAResource -Name vm01 | Get-vRAResourceAction | Where-Object {$_.Name -eq "Reboot"}).id
```

Request-vRAResourceAction -Id $ResourceActionId -ResourceName vm01

### -------------------------- EXAMPLE 2 --------------------------
```
Request-vRAResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd
```

### -------------------------- EXAMPLE 3 --------------------------
```
Request-vRAResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceName vm01
```

### -------------------------- EXAMPLE 4 --------------------------
```
Request-vRAResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceName vm01 -Wait
```

### -------------------------- EXAMPLE 5 --------------------------
```
$JSON = @"
```

{
        "type":  "com.vmware.vcac.catalog.domain.request.CatalogResourceRequest",
        "resourceId":  "448fcd09-b8c0-482c-abbc-b3ab818c2e31",
        "actionId":  "fae08c75-3506-40f6-9c9b-35966fe9125c",
        "description":  null,
        "data":  {
                     "description":  null,
                     "reasons":  null
                 }
    }        
"@

$JSON | Request-vRAResourceAction

## PARAMETERS

### -ActionId
The Id for the resource action

```yaml
Type: String
Parameter Sets: ByResourceId, ByResourceName
Aliases: Id

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
The id of the resource that the resourceAction will execute against

```yaml
Type: String
Parameter Sets: ByResourceId
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ResourceName
The name of the resource that the resourceAction will execute against

```yaml
Type: String
Parameter Sets: ByResourceName
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JSON
A JSON payload for the request

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

### -Wait
Wait for the request to complete

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
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

