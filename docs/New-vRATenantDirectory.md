---
external help file: New-vRATenantDirectory-help.xml
online version: 
schema: 2.0.0
---

# New-vRATenantDirectory

## SYNOPSIS
Create a vRA Tenant Directory

## SYNTAX

### Standard (Default)
```
New-vRATenantDirectory -ID <String> -Name <String> [-Description <String>] [-Alias <String>] -Type <String>
 -Domain <String> -UserNameDN <String> -Password <String> -URL <String> -GroupBaseSearchDN <String>
 [-UserBaseSearchDN <String>] [-Subdomains <String>] -GroupBaseSearchDNs <String[]>
 [-UserBaseSearchDNs <String[]>] [-DomainAdminUsername <String>] [-DomainAdminPassword <String>]
 [-Certificate <String>] [-TrustAll] [-UseGlobalCatalog] [-WhatIf] [-Confirm]
```

### JSON
```
New-vRATenantDirectory -ID <String> -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA Tenant Directory

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRATenantDirectory -ID Tenant01 -Name Tenant01 -Description "This is the Tenant01 Directory" -Type AD -Domain "vrademo.local" -UserNameDN "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local" `
```

-Password "P@ssw0rd" -URL "ldap://dc01.vrademo.local:389" -GroupBaseSearchDN "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -UserBaseSearchDN "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" \`
 -GroupBaseSearchDNs "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -UserBaseSearchDNs "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -TrustAll

### -------------------------- EXAMPLE 2 --------------------------
```
$JSON = @"
```

{
  "name" : "Tenant01",
  "description" : "Tenant01",
  "alias" : "",
  "type" : "AD",
  "userNameDn" : "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local",
  "groupBaseSearchDn" : "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "password" : "P@ssword!",
  "url" : "ldap://dc01.vrademo.local:389",
  "userBaseSearchDn" : "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "domain" : "vrademo.local",
  "domainAdminUsername" : "",
  "domainAdminPassword" : "",
  "subdomains" : \[ "" \],
  "groupBaseSearchDns" : \[ "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" \],
  "userBaseSearchDns" : \[ "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" \],
  "certificate" : "",
  "trustAll" : true,
  "useGlobalCatalog" : false
}
"@
$JSON | New-vRATenantDirectory -ID Tenant01

## PARAMETERS

### -ID
Tenant ID

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Tenant Directory Name

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
Tenant Directory Description

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

### -Alias
Tenant Directory Alias

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

### -Type
Tenant Directory Type

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

### -Domain
Tenant Directory Domain

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

### -UserNameDN
DN of the Username to authenticate the Tenant Directory with

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

### -Password
Password of the Username to authenticate the Tenant Directory with

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

### -URL
Tenant Directory URL, e.g.
ldap://dc01.vrademo.local:389

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

### -GroupBaseSearchDN
Tenant Directory GroupBaseSearchDN

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

### -UserBaseSearchDN
Tenant Directory UserBaseSearchDN

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

### -Subdomains
Tenant Directory Subdomains

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

### -GroupBaseSearchDNs
Tenant Directory GroupBaseSearchDNs

```yaml
Type: String[]
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserBaseSearchDNs
Tenant Directory UserBaseSearchDNs

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

### -DomainAdminUsername
Tenant Directory DomainAdminUserName

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

### -DomainAdminPassword
Tenant Directory DomainAdminPassword

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

### -Certificate
Tenant Directory Certificate

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

### -TrustAll
Tenant Directory TrustAll

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseGlobalCatalog
Tenant Directory UseGlobalCatalog

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
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

