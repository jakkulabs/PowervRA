# Invoke-vRARestMethod

## SYNOPSIS
Wrapper for Invoke-RestMethod with vRA specifics

## SYNTAX

```
Invoke-vRARestMethod [-Method] <String> [-URI] <String> [[-Body] <String>] [[-Headers] <IDictionary>]
 [[-OutFile] <String>]
```

## DESCRIPTION
Wrapper for Invoke-RestMethod with vRA specifics

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-vRARestMethod -Method GET -URI '/identity/api/tenants'
```

### -------------------------- EXAMPLE 2 --------------------------
```
$JSON = @"
```

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

## PARAMETERS

### -Method
REST Method: GET, POST, PUT or DELETE

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URI
API URI, e.g.
/identity/api/tenants

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
REST Body in JSON format

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
Optionally supply custom headers

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
Save the results to a file

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String
Switch

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

