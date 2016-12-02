# Set-vRAUserPrincipal

## SYNOPSIS
Update a vRA local user principal

## SYNTAX

```
<<<<<<< HEAD
Set-vRAUserPrincipal [-Id] <String> [[-Tenant] <String>] [[-FirstName] <String>] [[-LastName] <String>]
 [[-EmailAddress] <String>] [[-Description] <String>] [[-Password] <String>] [-DisableAccount] [-EnableAccount]
=======
Set-vRAUserPrincipal -Id <String> [-Tenant <String>] [-FirstName <String>] [-LastName <String>]
 [-EmailAddress <String>] [-Description <String>] [-Password <String>] [-DisableAccount] [-EnableAccount]
>>>>>>> master
 [-WhatIf] [-Confirm]
```

## DESCRIPTION
Update a vRA Principal (user)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-vRAUserPrincipal -Id user@vsphere.local -FirstName FirstName-Updated -LastName LastName-Updated -EmailAddress userupdated@vsphere.local -Description Description-Updated
```

### -------------------------- EXAMPLE 2 --------------------------
```
Set-vRAUserPrincipal -Id user@vsphere.local -EnableAccount
```

### -------------------------- EXAMPLE 3 --------------------------
```
Set-vRAUserPrincipal -Id user@vsphere.local -DisableAccount
```

### -------------------------- EXAMPLE 4 --------------------------
```
Set-vRAUserPrincipal -Id user@vsphere.local -Password s3cur3p@ss!
```

## PARAMETERS

### -Id
The principal id of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
<<<<<<< HEAD
Position: 1
=======
Position: Named
>>>>>>> master
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
<<<<<<< HEAD
Position: 2
=======
Position: Named
>>>>>>> master
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
<<<<<<< HEAD
Position: 3
=======
Position: Named
>>>>>>> master
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
<<<<<<< HEAD
Position: 4
=======
Position: Named
>>>>>>> master
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
<<<<<<< HEAD
Position: 5
=======
Position: Named
>>>>>>> master
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
<<<<<<< HEAD
Position: 6
=======
Position: Named
>>>>>>> master
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Users password

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
<<<<<<< HEAD
Position: 7
=======
Position: Named
>>>>>>> master
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

## INPUTS

### System.String.
System.Diagnostics.Switch

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

