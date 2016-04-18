# Invoke-vRARestMethod

## SYNOPSIS
    
Wrapper for Invoke-RestMethod with vRA specifics

## SYNTAX
 Invoke-vRARestMethod [-Method] <String> [-URI] <String> [[-Body] <String>] [<CommonParameters>]    

## DESCRIPTION

Wrapper for Invoke-RestMethod with vRA specifics

## PARAMETERS


### Method

REST Method: GET, POST, PUT or DELETE

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: false

### URI

API URI, e.g. /identity/api/tenants

* Required: true
* Position: 2
* Default value: 
* Accept pipeline input: false

### Body

REST Body in JSON format

* Required: false
* Position: 3
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String
Switch

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Invoke-vRARestMethod -Method GET -URI '/identity/api/tenants'







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
      "name" : "Tenant02",
      "description" : "This is Tenant02",
      "urlName" : "Tenant02",
      "contactEmail" : "test.user@tenant02.local",
      "id" : "Tenant02",
      "defaultTenant" : false,
      "password" : ""
    }
"@

Invoke-vRARestMethod -Method PUT -URI '/identity/api/tenants/Tenant02' -Body $JSON
```

