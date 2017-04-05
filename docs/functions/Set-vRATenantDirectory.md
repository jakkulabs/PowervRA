# Set-vRATenantDirectory

## SYNOPSIS
Update a vRA Tenant Directory

## SYNTAX

### Standard (Default)
```
Set-vRATenantDirectory -ID <String> [-Name <String>] [-Description <String>] [-Alias <String>] [-Type <String>]
 -Domain <String> [-UserNameDN <String>] [-Password <SecureString>] [-URL <String>]
 [-GroupBaseSearchDN <String>] [-UserBaseSearchDN <String>] [-Subdomains <String>]
 [-GroupBaseSearchDNs <String[]>] [-UserBaseSearchDNs <String[]>] [-DomainAdminUsername <String>]
 [-DomainAdminPassword <SecureString>] [-Certificate <String>] [-TrustAll] [-UseGlobalCatalog] [-WhatIf]
 [-Confirm]
```

### JSON
```
Set-vRATenantDirectory -ID <String> -Domain <String> -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Update a vRA Tenant Directory

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$SecurePassword = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
```

Set-vRATenantDirectory -ID Tenant01 -Domain vrademo.local -GroupBaseSearchDNs "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -userBaseSearchDNs "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -Password $SecurePassword -Confirm:$false

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
  "groupBaseSearchDn" : "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "password" : "P@ssword!",
  "url" : "ldap://dc01.vrademo.local:389",
  "userBaseSearchDn" : "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "domain" : "vrademo.local",
  "domainAdminUsername" : "",
  "domainAdminPassword" : "",
  "subdomains" : \[ "" \],
  "groupBaseSearchDns" : \[ "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" \],
  "userBaseSearchDns" : \[ "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" \],
  "certificate" : "",
  "trustAll" : true,
  "useGlobalCatalog" : false
}
"@
$JSON | Set-vRATenantDirectory -ID Tenant01 -Domain vrademo.local

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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A description for the directory

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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Tenant Directory Domain

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

### -UserNameDN
DN of the Username to authenticate the Tenant Directory with

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

### -Password
Password of the Username to authenticate the Tenant Directory with

```yaml
Type: SecureString
Parameter Sets: Standard
Aliases: 

Required: False
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

Required: False
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

Required: False
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

Required: False
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
Type: SecureString
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

### System.String
System.SecureString

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

