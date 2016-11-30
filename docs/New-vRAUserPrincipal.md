# New-vRAUserPrincipal

## SYNOPSIS
Create a vRA local user principal

## SYNTAX

### Password (Default)
```
New-vRAUserPrincipal -PrincipalId <String> [-Tenant <String>] -FirstName <String> -LastName <String>
 -EmailAddress <String> [-Description <String>] -Password <String> [-WhatIf] [-Confirm]
```

### Credential
```
New-vRAUserPrincipal [-Tenant <String>] -FirstName <String> -LastName <String> -EmailAddress <String>
 [-Description <String>] -Credential <PSCredential> [-WhatIf] [-Confirm]
```

### JSON
```
New-vRAUserPrincipal -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA Principal (user)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRAUserPrincipal -Tenant vsphere.local -FirstName "Test" -LastName "User" -EmailAddress "user@company.com" -Description "a description" -Password "password" -PrincipalId "user@vsphere.local"
```

### -------------------------- EXAMPLE 2 --------------------------
```
$JSON = @"
```

{
    "locked": "false",
    "disabled": "false",
    "firstName": "Test",
    "lastName": "User",
    "emailAddress": "user@company.com",
    "description": "no",
    "password": "password123",
    "principalId": {
        "domain": "vsphere.local",
        "name": "user"
    },
    "tenantName": "Tenant01",
    "name": "Test User"
    }
"@

$JSON | New-vRAUserPrincipal

## PARAMETERS

### -PrincipalId
Principal id in user@company.com format

```yaml
Type: String
Parameter Sets: Password
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
The tenant of the user

```yaml
Type: String
Parameter Sets: Password, Credential
Aliases: 

Required: False
Position: Named
Default value: $Global:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstName
First Name

```yaml
Type: String
Parameter Sets: Password, Credential
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastName
Last Name

```yaml
Type: String
Parameter Sets: Password, Credential
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddress
Email Address

```yaml
Type: String
Parameter Sets: Password, Credential
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Users text description

```yaml
Type: String
Parameter Sets: Password, Credential
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Users password

```yaml
Type: String
Parameter Sets: Password
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Credential object

```yaml
Type: PSCredential
Parameter Sets: Credential
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

