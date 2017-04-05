# Get-vRAReservation

## SYNOPSIS
Get a reservation

## SYNTAX

### Standard (Default)
```
Get-vRAReservation [-Limit <Int32>] [-Page <Int32>]
```

### ById
```
Get-vRAReservation -Id <String[]>
```

### ByName
```
Get-vRAReservation -Name <String[]>
```

## DESCRIPTION
Get a reservation

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAReservation -Name Reservation1
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAReservation
```

## PARAMETERS

### -Id
The id of the reservation

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
The name of the reservation

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

### -Page
The page of response to return.
All pages are retuend by default

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

## OUTPUTS

### System.Management.Automation.PSObject
System.Object[]

## NOTES

## RELATED LINKS

