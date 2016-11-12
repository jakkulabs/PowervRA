# Get-vRAApplianceServiceStatus

## SYNOPSIS
Get information about vRA services

## SYNTAX

```
Get-vRAApplianceServiceStatus [[-Name] <String[]>] [[-Limit] <String>]
```

## DESCRIPTION
Get information about vRA services.
These are the same services that you will see via the service tab

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAApplianceServiceStatus
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAApplianceServiceStatus -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAApplianceServiceStatus -Name iaas-service
```

## PARAMETERS

### -Name
The name of the service to query

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

