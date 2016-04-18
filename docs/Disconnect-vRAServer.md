# Disconnect-vRAServer

## SYNOPSIS
    
Disconnect from a vRA server

## SYNTAX
 Disconnect-vRAServer [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Disconnect from a vRA server by removing the authorization token and the global vRAConnection variable from PowerShell

## PARAMETERS


### WhatIf


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Confirm


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false
## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Disconnect-vRAServer







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Disconnect-vRAServer -Confirm:$false
```

