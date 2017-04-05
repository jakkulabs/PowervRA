# Get-vRAComponentRegistryService

## SYNOPSIS
Get information about vRA services

## SYNTAX

### Standard (Default)
```
Get-vRAComponentRegistryService [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAComponentRegistryService -Id <String[]>
```

### ByName
```
Get-vRAComponentRegistryService -Name <String[]>
```

## DESCRIPTION
Get information about vRA services.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAComponentRegistryService
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAComponentRegistryService -Limit 9999
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAComponentRegistryService -Page 1
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAComponentRegistryService -Id xxxxxxxxxxxxxxxxxxxxxxxx
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRAComponentRegistryService -Name "iaas-service"
```

## PARAMETERS

### -Id
The Id of the service.
Specifying the Id of the service will retrieve detailed information.

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
The name of the service

```yaml
Type: String[]
Parameter Sets: ByName
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The index of the page to display.

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String
System.Int
System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

