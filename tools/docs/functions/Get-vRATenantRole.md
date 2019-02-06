# Get-vRATenantRole

## SYNOPSIS
Retrieve vRA Tenant Role

## SYNTAX

```
Get-vRATenantRole [-TenantId] <String> [-PrincipalId] <String[]> [[-Limit] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve vRA Tenant Role

## EXAMPLES

### EXAMPLE 1
```
Get-vRATenantRole -TenantId Tenant01 -PrincipalId Tenantadmin@vrademo.local
```

## PARAMETERS

### -TenantId
Specify the Tenant Id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrincipalId
Specify the Principal Id

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
