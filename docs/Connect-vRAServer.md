# Connect-vRAServer

## SYNOPSIS
    
Connect to a vRA Server

## SYNTAX
 Connect-vRAServer -Server <String> [-Tenant <String>] -Username <String> -Password <String> [-IgnoreCertRequirements]  [<CommonParameters>] Connect-vRAServer -Server <String> [-Tenant <String>] -Credential <PSCredential> [-IgnoreCertRequirements]  [<CommonParameters>]    

## DESCRIPTION

Connect to a vRA Server and generate a connection object with Servername, Token etc

## PARAMETERS


### Server

vRA Server to connect to

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Tenant

Tenant to connect to

* Required: false
* Position: named
* Default value: vsphere.local
* Accept pipeline input: false

### Username

Username to connect with

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Password

Password to connect with

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Credential

Credential object to connect with

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### IgnoreCertRequirements

Ignore requirements to use fully signed certificates

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

## INPUTS

System.String
Management.Automation.PSCredential
Switch

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Username TenantAdmin01 -Password 
P@ssword -IgnoreCertRequirements







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Connect-vRAServer -Server vraappliance01.domain.local -Tenant Tenant01 -Credential (Get-Credential)
```

