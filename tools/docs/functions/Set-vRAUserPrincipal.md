# Set-vRAUserPrincipal

## SYNOPSIS
Update a vRA local user principal

## SYNTAX

```
Set-vRAUserPrincipal [-Id] <String> [[-Tenant] <String>] [[-FirstName] <String>] [[-LastName] <String>]
 [[-EmailAddress] <String>] [[-Description] <String>] [[-Password] <SecureString>] [-DisableAccount]
 [-EnableAccount] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update a vRA Principal (user)

## EXAMPLES

### EXAMPLE 1
```
Set-vRAUserPrincipal -Id user@vsphere.local -FirstName FirstName-Updated -LastName LastName-Updated -EmailAddress userupdated@vsphere.local -Description Description-Updated
```

### EXAMPLE 2
```
Set-vRAUserPrincipal -Id user@vsphere.local -EnableAccount
```

### EXAMPLE 3
```
Set-vRAUserPrincipal -Id user@vsphere.local -DisableAccount
```

### EXAMPLE 4
```
$SecurePassword = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
```

Set-vRAUserPrincipal -Id user@vsphere.local -Password SecurePassword

## PARAMETERS

### -Id
The principal id of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrincipalId

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
The tenant of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Global:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstName
First Name

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

### -LastName
Last Name

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

### -EmailAddress
Email Address

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

### -Description
Users text description

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

### -Password
Users password

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAccount
Disable the user principal

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: LockAccount

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableAccount
Enable or unlock the user principal

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: UnlockAccount

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.SecureString
System.Diagnostics.Switch

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
