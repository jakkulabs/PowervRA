---
external help file: Get-vRAResource-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAResource

## SYNOPSIS
Get a deployed resource

## SYNTAX

### Standard (Default)
```
Get-vRAResource [-Type <String>] [-WithExtendedData] [-WithOperations] [-ManagedOnly] [-Limit <Int32>]
 [-Page <Int32>]
```

### ById
```
Get-vRAResource -Id <String[]>
```

### ByName
```
Get-vRAResource -Name <String[]>
```

## DESCRIPTION
A deployment represents a collection of deployed artifacts that have been provisioned by a provider.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAResource
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRADeployment -WithExtendedData
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRADeployment -WithOperations
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRADeployment -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRADeployment -Name "CENTOS-555667"
```

## PARAMETERS

### -Id
The id of the resource

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
The Name of the resource

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

### -Type
Show resources that match a certain type.

Supported types ar:

    Deployment,
    Machine

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithExtendedData
Populate the resources extended data by calling their provider

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

### -WithOperations
Populate the resources operations attribute by calling the provider.
This will force withExtendedData to true.

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

### -ManagedOnly
Show resources owned by the users managed business groups, excluding any machines owned by the user in a non-managed
business group

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

### -Page
The index of the page to display

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

## INPUTS

### System.String
System.Int
Switch

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

