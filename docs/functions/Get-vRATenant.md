# Get-vRATenant

## SYNOPSIS
Retrieve vRA Tenants

## SYNTAX

```
Get-vRATenant [[-Id] <String[]>] [[-Limit] <String>]
```

## DESCRIPTION
Retrieve vRA Tenants.
Make sure to have permission to access all Tenant information

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRATenant
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRATenant -Id Tenant01
```

## PARAMETERS

### -Id
Specify the ID of a Tenant

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
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
Position: 2
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

