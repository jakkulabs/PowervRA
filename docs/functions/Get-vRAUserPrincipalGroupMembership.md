# Get-vRAUserPrincipalGroupMembership

## SYNOPSIS
Retrieve a list of groups that a user is a member of

## SYNTAX

```
Get-vRAUserPrincipalGroupMembership [-Id] <String[]> [[-Tenant] <String>] [[-GroupType] <String>]
 [[-Limit] <Int32>] [[-Page] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve a list of groups that a user is a member of

## EXAMPLES

### EXAMPLE 1
```
Get-vRAUserPrincipal -Id user@vsphere.local | Get-vRAUserPrincipalGroupMembership
```

### EXAMPLE 2
```
Get-vRAUserPrincipal -Id user@vsphere.local | Get-vRAUserPrincipalGroupMembership -GroupType SSO
```

### EXAMPLE 3
```
Get-vRAUserPrincipalGroupMembership -Id user@vsphere.local
```

### EXAMPLE 4
```
Get-vRAUserPrincipalGroupMembership -UserPrincipal user@vsphere.local
```

## PARAMETERS

### -Id
The Id of the user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrincipalId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
Default value: $Script:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupType
Return either custom or sso groups

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

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The page of response to return.
By default this is 1.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.Int

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
