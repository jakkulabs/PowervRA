# Get-vRAComponentRegistryServiceEndpoint

## SYNOPSIS
Retrieve a list of endpoints for a service

## SYNTAX

```
Get-vRAComponentRegistryServiceEndpoint [-Id] <String[]>
```

## DESCRIPTION
Retrieve a list of endpoints for a service

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAComponentRegistryServiceEndpoint
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAComponentRegistryService -Id xxxxxxxxxxxxxxxxxxxxxxxx | Get-vRAComponentRegistryServiceEndpoint
```

## PARAMETERS

### -Id
The Id of the service.
Specifying the Id of the service will retrieve detailed information.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

