# New-vRAPropertyDefinition

## SYNOPSIS
Create a custom Property Definition

## SYNTAX

### String
```
New-vRAPropertyDefinition -Name <String> [-Label <String>] [-Description <String>] [-Tenant <String>]
 [-Index <Int32>] [-Required] [-Encrypted] [-ExecuteAPICall] [-String] -StringDisplay <String>
```

### Boolean
```
New-vRAPropertyDefinition -Name <String> [-Label <String>] [-Description <String>] [-Tenant <String>]
 [-Index <Int32>] [-Required] [-Encrypted] [-ExecuteAPICall] [-Boolean] -BooleanDisplay <String>
```

### Integer
```
New-vRAPropertyDefinition -Name <String> [-Label <String>] [-Description <String>] [-Tenant <String>]
 [-Index <Int32>] [-Required] [-Encrypted] [-ExecuteAPICall] [-Integer] -IntegerDisplay <String>
```

### Decimal
```
New-vRAPropertyDefinition -Name <String> [-Label <String>] [-Description <String>] [-Tenant <String>]
 [-Index <Int32>] [-Required] [-Encrypted] [-ExecuteAPICall] [-Decimal] -DecimalDisplay <String>
```

### Datetime
```
New-vRAPropertyDefinition -Name <String> [-Label <String>] [-Description <String>] [-Tenant <String>]
 [-Index <Int32>] [-Required] [-Encrypted] [-ExecuteAPICall] [-Datetime] -DatetimeDisplay <String>
```

### JSON
```
New-vRAPropertyDefinition -Name <String> [-Label <String>] [-Description <String>] [-Tenant <String>]
 [-Index <Int32>] [-Required] [-Encrypted] [-ExecuteAPICall] -JSON <String>
```

## DESCRIPTION
Create a custom Property Definition

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Create a string dropdown with defined values
```

New-vRAPropertyDefinition -Name one -String -StringDisplay DROPDOWN -ValueType Static -Values @{Name1="Value1";Name2="Value2"}

### -------------------------- EXAMPLE 2 --------------------------
```
# Create an integer slider with min, max and increment
```

New-vRAPropertyDefinition -Name IntegerName -Label "Select an Integer" -Integer -IntegerDisplay SLIDER -MinimumValue 1 -MaximumValue 10 -Increment 1

### -------------------------- EXAMPLE 3 --------------------------
```
# Create a boolean checkbox
```

New-vRAPropertyDefinition -Name BooleanName -Label "Check this box" -Boolean -BooleanDisplay CHECKBOX

### -------------------------- EXAMPLE 4 --------------------------
```
# Create a new decimal slider with min, max and increment
```

New-vRAPropertyDefinition -Name DecimalTest -Decimal -DecimalDisplay SLIDER -MinimumValue 0 -MaximumValue 10 -Increment 0.5

## PARAMETERS

### -Name
The unique name (ID) of the Property

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
The text to display in forms for the Property

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: $Name
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the Property

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
The tenant in which to create the Property Definition (Defaults to the connection tenant )

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: $Global:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Index
The display index of the Property

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Required
Switch to flag the Property as required

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encrypted
Switch to flag the Property as Encrypted

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecuteAPICall
{{Fill ExecuteAPICall Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -String
{{Fill String Description}}

```yaml
Type: SwitchParameter
Parameter Sets: String
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -StringDisplay
{{Fill StringDisplay Description}}

```yaml
Type: String
Parameter Sets: String
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Boolean
{{Fill Boolean Description}}

```yaml
Type: SwitchParameter
Parameter Sets: Boolean
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BooleanDisplay
{{Fill BooleanDisplay Description}}

```yaml
Type: String
Parameter Sets: Boolean
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Integer
Switch to flag the Property type as Integer

```yaml
Type: SwitchParameter
Parameter Sets: Integer
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntegerDisplay
The form display option for integer

```yaml
Type: String
Parameter Sets: Integer
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Decimal
{{Fill Decimal Description}}

```yaml
Type: SwitchParameter
Parameter Sets: Decimal
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DecimalDisplay
{{Fill DecimalDisplay Description}}

```yaml
Type: String
Parameter Sets: Decimal
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Datetime
{{Fill Datetime Description}}

```yaml
Type: SwitchParameter
Parameter Sets: Datetime
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatetimeDisplay
{{Fill DatetimeDisplay Description}}

```yaml
Type: String
Parameter Sets: Datetime
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JSON
Property Definition to send in JSON format

```yaml
Type: String
Parameter Sets: JSON
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

