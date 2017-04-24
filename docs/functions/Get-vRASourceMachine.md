# Get-vRASourceMachine

## SYNOPSIS
Return a list of source machines

## SYNTAX

### Standard (Default)
```
Get-vRASourceMachine [-ManagedOnly] [-Limit <Int32>] [-Page <Int32>]
```

### ById
```
Get-vRASourceMachine -Id <String[]>
```

### ByName
```
Get-vRASourceMachine -Name <String[]>
```

### Standard-Template
```
Get-vRASourceMachine [-TemplatesOnly] [-Limit <Int32>] [-Page <Int32>]
```

## DESCRIPTION
Return a list of source machines.
A source machine represents an entity that is visible to the endpoint.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRASourceMachine -Id 597ff2c1-a35f-4a81-bfd3-ca014
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRASourceMachine -Name vra-template-01
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRASourceMachine
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRASourceMachine -Template
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRASourceMachine -Managed
```

## PARAMETERS

### -Id
The id of the Source Machine

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the Source Macine

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

### -ManagedOnly
Only return machines that are managed

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplatesOnly
Only return machines that are marked as templates

```yaml
Type: SwitchParameter
Parameter Sets: Standard-Template
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: Int32
Parameter Sets: Standard, Standard-Template
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The page of response to return.
By default this is 1.

```yaml
Type: Int32
Parameter Sets: Standard, Standard-Template
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String
System.Int

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

