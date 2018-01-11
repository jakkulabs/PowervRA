# Connect-vRAServer

## SYNOPSIS
Connect to a vRA Server

## SYNTAX

### Username (Default)
```
Connect-vRAServer -Server <String> [-Tenant <String>] -Username <String> -Password <SecureString>
 [-IgnoreCertRequirements] [-SslProtocol <String>]
```

### Credential
```
Connect-vRAServer -Server <String> [-Tenant <String>] -Credential <PSCredential> [-IgnoreCertRequirements]
 [-SslProtocol <String>]
```

## DESCRIPTION
Connect to a vRA Server and generate a connection object with Servername, Token etc

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Credential (Get-Credential)
```

### -------------------------- EXAMPLE 2 --------------------------
```
$SecurePassword = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
```

Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Username TenantAdmin01 -Password $SecurePassword -IgnoreCertRequirements

## PARAMETERS

### -Server
vRA Server to connect to

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

### -Tenant
Tenant to connect to

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: Vsphere.local
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
Username to connect with

```yaml
Type: String
Parameter Sets: Username
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password to connect with

```yaml
Type: SecureString
Parameter Sets: Username
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Credential object to connect with

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreCertRequirements
Ignore requirements to use fully signed certificates

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

### -SslProtocol
Alternative Ssl protocol to use from the default
Requires vRA 7.x and above
Windows PowerShell: Ssl3, Tls, Tls11, Tls12
PowerShell Core: Tls, Tls11, Tls12

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

## INPUTS

### System.String
System.SecureString
Management.Automation.PSCredential
Switch

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

