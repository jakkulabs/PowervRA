# New-vRAEntitlement

## SYNOPSIS
Create a new entitlement

## SYNTAX

### Standard (Default)
```
New-vRAEntitlement -Name <String> [-Description <String>] -BusinessGroup <String> [-Principals <String[]>]
 [-EntitledCatalogItems <String[]>] [-EntitledResourceOperations <String[]>] [-EntitledServices <String[]>]
 [-WhatIf] [-Confirm]
```

### JSON
```
New-vRAEntitlement -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a new entitlement

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRAEntitlement -Name "TestEntitlement" -Description "a test" -BusinessGroup "Test01" -Principals "user@vsphere.local" -EntitledCatalogItems "centos7","centos6" -EntitledServices "Default service" -Verbose
```

### -------------------------- EXAMPLE 2 --------------------------
```
$JSON = @"
```

{
                  "description": "",
                  "entitledCatalogItems": \[\],
                  "entitledResourceOperations": \[\],
                  "entitledServices": \[\],
                  "expiryDate": null,
                  "id": null,
                  "lastUpdatedBy": null,
                  "lastUpdatedDate": null,
                  "name": "Test api 4",
                  "organization": {
                    "tenantRef": "Tenant01",
                    "tenantLabel": "Tenant",
                    "subtenantRef": "792e859a-8a5e-4814-bf04-e4489b27cada",
                    "subtenantLabel": "Default Business Group\[Tenant01\]"
                  },
                  "principals": \[
                    {
                      "tenantName": "Tenant01",
                      "ref": "user@vsphere.local",
                      "type": "USER",
                      "value": "Test User"
                    }
                  \],
                  "priorityOrder": 2,
                  "status": "ACTIVE",
                  "statusName": "Active",
                  "localScopeForActions": true,
                  "version": null
                }
"@

$JSON | New-vRAEntitlement -Verbose

## PARAMETERS

### -Name
The name of the entitlement

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
A description of the entitlement

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

### -BusinessGroup
The business group that will be associated with the entitlement

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

### -Principals
Users or groups that will be associated with the entitlement

If this parameter is not specified, the entitlement will be created as DRAFT

```yaml
Type: String[]
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntitledCatalogItems
One or more entitled catalog item

```yaml
Type: String[]
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntitledResourceOperations
The externalId of one or more entitled resource operation (e.g.
Infrastructure.Machine.Action.PowerOn)

```yaml
Type: String[]
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntitledServices
One or more entitled service

```yaml
Type: String[]
Parameter Sets: Standard
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

