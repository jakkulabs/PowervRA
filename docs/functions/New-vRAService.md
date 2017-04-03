# New-vRAService

## SYNOPSIS
Create a vRA Service for the current tenant

## SYNTAX

### Standard (Default)
```
New-vRAService -Name <String> [-Description <String>] [-Owner <String>] [-SupportTeam <String>]
 [-IconId <String>] [-WhatIf] [-Confirm]
```

### JSON
```
New-vRAService -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA Service for the current tenant

Currently unsupported interactive actions:

* HoursStartTime
* HoursEndTime
* ChangeWindowDayOfWeek
* ChangeWindowStartTime
* ChangeWindowEndTime

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRAService -Name "New Service"
```

### -------------------------- EXAMPLE 2 --------------------------
```
New-vRAService -Name "New Service" -Description "A new service" -Owner user@vsphere.local -SupportTeam customgroup@vsphere.local -IconId "cafe_icon_Service01"
```

### -------------------------- EXAMPLE 3 --------------------------
```
$JSON = @"
```

{
      "name": "New Service",
      "description": "A new Service",
      "status": "ACTIVE",
      "statusName": "Active",
      "version": 1,
      "organization": {
        "tenantRef": "Tenant01",
        "tenantLabel": "Tenant01",
        "subtenantRef": null,
        "subtenantLabel": null
      },
      "newDuration": null,
      "iconId": "cafe_default_icon_genericService"
    }
"@

$JSON | New-vRAService

## PARAMETERS

### -Name
The name of the service

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A description of the service

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Owner
The owner of the service

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SupportTeam
The support team of the service

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconId
The Icon Id of the service.
This must already exist in the Service Catalog.
Typically it would have already been created via Import-vRAServiceIcon

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JSON
A json string of type service (catalog-service/api/docs/el_ns0_service.html)

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

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

