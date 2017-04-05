# Get-vRAContent

## SYNOPSIS
Get available vRA content

## SYNTAX

### Standard (Default)
```
Get-vRAContent [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAContent -Id <String[]>
```

### ByName
```
Get-vRAContent -Name <String[]>
```

## DESCRIPTION
Get available vRA content

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAContent
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAContent -Id b2d72c5d-775b-400c-8d79-b2483e321bae
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAContent -Name "some content"
```

## PARAMETERS

### -Id
The Id of the content

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
The name of the content

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
This has a default value of 100

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

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

