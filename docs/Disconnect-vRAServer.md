# Disconnect-vRAServer

## SYNOPSIS
Disconnect from a vRA server

## SYNTAX

```
Disconnect-vRAServer [-WhatIf] [-Confirm]
```

## DESCRIPTION
Disconnect from a vRA server by removing the authorization token and the global vRAConnection variable from PowerShell

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Disconnect-vRAServer
```

### -------------------------- EXAMPLE 2 --------------------------
```
Disconnect-vRAServer -Confirm:$false
```

## PARAMETERS

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

