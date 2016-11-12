# Get-vRAEntitlement

## SYNOPSIS
Retrieve vRA entitlements

## SYNTAX

### Standard (Default)
```
Get-vRAEntitlement [-Page <Int32>] [-Limit <Int32>]
```

### ById
```
Get-vRAEntitlement -Id <String[]>
```

### ByName
```
Get-vRAEntitlement -Name <String[]>
```

## DESCRIPTION
Retrieve vRA entitlement either by id or name.
Passing no parameters will return all entitlements

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAEntitlement
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAEntitlement -Id 332d38d5-c8db-4519-87a7-7ef9f358091a
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAEntitlement -Name "Default Entitlement"
```

## PARAMETERS

### -Id
The id of the entitlement

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
The Name of the entitlement

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

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

