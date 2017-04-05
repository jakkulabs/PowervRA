# Get-vRANetworkProfileIPRangeSummary

## SYNOPSIS
Returns a list of range summaries within the network profile.

## SYNTAX

```
Get-vRANetworkProfileIPRangeSummary [-NetworkProfileId] <String> [[-Limit] <Int32>] [[-Page] <Int32>]
```

## DESCRIPTION
Returns a list of range summaries within the network profile.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAExternalNetworkProfile -Name EXT-01 | Get-vRANetworkProfileIPRangeSummary
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAExternalNetworkProfile -Name EXT-01 | Get-vRANetworkProfileIPRangeSummary -Limit 10 -Page 1
```

## PARAMETERS

### -NetworkProfileId
The id of the network profile

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The page of response to return.
By default this is 1.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
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

