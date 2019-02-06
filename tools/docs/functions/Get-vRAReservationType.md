# Get-vRAReservationType

## SYNOPSIS
Get supported Reservation Types

## SYNTAX

### Standard (Default)
```
Get-vRAReservationType [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>]
```

### ById
```
Get-vRAReservationType -Id <String[]> [<CommonParameters>]
```

### ByName
```
Get-vRAReservationType -Name <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get supported Reservation Types

## EXAMPLES

### EXAMPLE 1
```
# Get all available Reservation Types
```

Get-vRAReservationType

### EXAMPLE 2
```
# Get the vSphere Reservation Type in vRA 7.1
```

Get-vRAReservationType -Name "vSphere"

### EXAMPLE 3
```
# Get the vSphere Reservation Type in vRA 7.2 and later
```

Get-vRAReservationType -Name "vSphere (vCenter)"

### EXAMPLE 4
```
Get-vRAReservationType -Name "vCloud Director"
```

### EXAMPLE 5
```
Get-vRAReservationType -Id "Infrastructure.Reservation.Cloud.vCloud"
```

## PARAMETERS

### -Id
The id of the Reservation Type

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
The name of the Reservation Type
Valid names vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere,XenServer
Valid names vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer

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
All pages are retuend by default.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
System.Int.

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
