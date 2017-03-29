# Get-vRATenantDirectory

## SYNOPSIS
Retrieve vRA Tenant Directories

## SYNTAX

```
Get-vRATenantDirectory [-Id] <String[]> [[-Limit] <String>]
```

## DESCRIPTION
Retrieve vRA Tenant Directories

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRATenantDirectory -Id Tenant01
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRATenantDirectory -Id Tenant01,Tenant02
```

## PARAMETERS

### -Id
Specify the ID of a Tenant

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
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

