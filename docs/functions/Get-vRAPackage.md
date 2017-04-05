# Get-vRAPackage

## SYNOPSIS
Retrieve vRA Packages

## SYNTAX

### Standard (Default)
```
Get-vRAPackage [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAPackage -Id <String[]> [-Page <Int32>] [-Limit <Int32>]
```

### ByName
```
Get-vRAPackage -Name <String[]> [-Page <Int32>] [-Limit <Int32>]
```

## DESCRIPTION
Retrieve vRA Packages

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAPackage
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAPackage -Name "Package01","Package02"
```

## PARAMETERS

### -Id
Specify the ID of a Package

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
Specify the Name of a Package

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
Parameter Sets: (All)
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
Parameter Sets: (All)
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

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

