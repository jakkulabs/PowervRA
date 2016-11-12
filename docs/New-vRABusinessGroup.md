# New-vRABusinessGroup

## SYNOPSIS
Create a vRA Business Group

## SYNTAX

### Standard (Default)
```
New-vRABusinessGroup [-TenantId <String>] -Name <String> [-Description <String>]
 [-BusinessGroupManager <String[]>] [-SupportUser <String[]>] [-User <String[]>] [-MachinePrefixId <String>]
 -SendManagerEmailsTo <String> [-WhatIf] [-Confirm]
```

### JSON
```
New-vRABusinessGroup [-TenantId <String>] -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA Business Group

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01 -Description "Business Group 01" -BusinessGroupManager "busgroupmgr01@vrademo.local","busgroupmgr02@vrademo.local" -SupportUser "supportusers@vrademo.local" `
```

-User "basicusers@vrademo.local" -MachinePrefixId "87e99513-cbea-4589-8678-c84c5907bdf2" -SendManagerEmailsTo "busgroupmgr01@vrademo.local"

### -------------------------- EXAMPLE 2 --------------------------
```
$JSON = @"
```

{
  "name": "BusinessGroup01",
  "description": "Business Group 01",
  "subtenantRoles": \[ {
    "name": "Business Group Manager",
    "scopeRoleRef" : "CSP_SUBTENANT_MANAGER",
    "principalId": \[
      {
        "domain": "vrademo.local",
        "name": "busgroupmgr01"
      },
      {
        "domain": "vrademo.local",
        "name": "busgroupmgr02"
      }
    \]
  },
  {
  "name": "Basic User",
      "scopeRoleRef": "CSP_CONSUMER",
      "principalId": \[
        {
          "domain": "vrademo.local",
          "name": "basicusers"
        }
      \] 
  } ,
  {
  "name": "Support User",
      "scopeRoleRef": "CSP_SUPPORT",
      "principalId": \[
        {
          "domain": "vrademo.local",
          "name": "supportusers"
        }
      \] 
  } \],
  "extensionData": {
    "entries": \[
      {
        "key": "iaas-machine-prefix",
        "value": {
          "type": "string",
          "value": "87e99513-cbea-4589-8678-c84c5907bdf2"
        }
      },
      {
        "key": "iaas-manager-emails",
        "value": {
          "type": "string",
          "value": "busgroupmgr01@vrademo.local"
        }
      }
    \]
  },
  "tenant": "Tenant01"
}
"@
$JSON | New-vRABusinessGroup -TenantId Tenant01

## PARAMETERS

### -TenantId
Tenant ID

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: $Global:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Business Group Name

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
Business Group Description

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

### -BusinessGroupManager
Business Group Managers

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

### -SupportUser
Business Group Support Users

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

### -User
Business Group Users

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

### -MachinePrefixId
Machine Prefix Id

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

### -SendManagerEmailsTo
Send Manager Emails To

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

