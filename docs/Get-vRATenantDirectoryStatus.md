# Get-vRATenantDirectoryStatus

## SYNOPSIS
Retrieve vRA Tenant Directory Status

## SYNTAX

```
Get-vRATenantDirectoryStatus [-Id] <String> [[-Domain] <String[]>]
```

## DESCRIPTION
Retrieve vRA Tenant Directory Status

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRATenantDirectoryStatus -Id Tenant01 -Domain vrademo.local
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRATenantDirectoryStatus -Id Tenant01 -Domain vrademo.local,test.local
```

## PARAMETERS

### -Id
Specify the ID of a Tenant

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

### -Domain
Specify the Domain of a Tenant Directory

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

