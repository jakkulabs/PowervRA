# Invoke-vRARestMethod

## SYNOPSIS
Wrapper for Invoke-RestMethod/Invoke-WebRequest with vRA specifics

## SYNTAX

### Standard (Default)
```
Invoke-vRARestMethod -Method <String> -URI <String> [-Headers <IDictionary>] [-WebRequest] [<CommonParameters>]
```

### OutFile
```
Invoke-vRARestMethod -Method <String> -URI <String> [-Headers <IDictionary>] [-OutFile <String>] [-WebRequest]
 [<CommonParameters>]
```

### Body
```
Invoke-vRARestMethod -Method <String> -URI <String> [-Headers <IDictionary>] [-Body <String>] [-WebRequest]
 [<CommonParameters>]
```

## DESCRIPTION
Wrapper for Invoke-RestMethod/Invoke-WebRequest with vRA specifics

## EXAMPLES

### EXAMPLE 1
```
Invoke-vRARestMethod -Method GET -URI '/identity/api/tenants'
```

### EXAMPLE 2
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

Invoke-vRARestMethod -Method PUT -URI '/identity/api/tenants/Tenant02' -Body $JSON -WebRequest

## PARAMETERS

### -Method
REST Method:
Supported Methods: GET, POST, PUT,DELETE

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

### -URI
API URI, e.g.
/identity/api/tenants

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

### -Headers
Optionally supply custom headers

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
REST Body in JSON format

```yaml
Type: String
Parameter Sets: Body
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
Save the results to a file

```yaml
Type: String
Parameter Sets: OutFile
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebRequest
Use Invoke-WebRequest rather than the default Invoke-RestMethod

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
Switch

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
