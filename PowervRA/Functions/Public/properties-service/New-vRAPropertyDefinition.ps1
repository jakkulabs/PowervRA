function New-vRAPropertyDefinition {
<#
    .SYNOPSIS
    Create a vRA local user principal
    
    .DESCRIPTION
    Create a vRA Principal (user)

    .PARAMETER Tenant
    The tenant of the user
    
    .PARAMETER PrincipalId
    Principal id in user@company.com format
    
    .PARAMETER FirstName
    First Name

    .PARAMETER LastName
    Last Name

    .PARAMETER EmailAddress
    Email Address

    .PARAMETER Description
    Users text description

    .PARAMETER Password
    Users password
    
    .PARAMETER Credential
    Credential object
    
    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAUserPrincipal -Tenant vsphere.local -FirstName "Test" -LastName "User" -EmailAddress "user@company.com" -Description "a description" -Password "password" -PrincipalId "user@vsphere.local"
    
    .EXAMPLE
    $JSON = @"
PUT /api/propertydefinitions/costcenter

{
 'id' : 'costcenter',
 'label' : 'Cost Center',
 'description' : null,
 'dataType' : {
   'type' : 'primitive',
   'typeId' : 'STRING'
 },
 'isMultiValued' : false,
 'displayAdvice' : 'DROPDOWN',
 'tenantId' : 'tenant1',
 'orderIndex' : null,
 'permissibleValues' : {
   'type' : 'dynamic',
   'customAllowed' : false,
   'dependencies' : [ ],
   'context' : {
     'providerEntityId' : 'org.example.accounts/getCostCenters'
   }
 }
}
   "@
   
   $JSON | New-vRAUserPrincipal
   
#> 
[CmdletBinding(ConfirmImpact="Low",DefaultParameterSetName="Property")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
    [parameter(Mandatory=$false,ParameterSetName="Property")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,
    
    [parameter(Mandatory=$false,ParameterSetName="Property")]    
    [ValidateNotNullOrEmpty()]
    [String]$Label,
    
    [parameter(Mandatory=$false,ParameterSetName="Property")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$false,ParameterSetName="Property")]
    [ValidateNotNullOrEmpty()]
    [String]$DataType,

    [parameter(Mandatory=$false,ParameterSetName="Property")] 
    [ValidateNotNullOrEmpty()]
    [Boolean]$IsMultiValued = $false,

    [parameter(Mandatory=$false,ParameterSetName="Property")] 
    [ValidateNotNullOrEmpty()]
    [String]$Display,
    
    [parameter(Mandatory=$false,ParameterSetName="Property")]    
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant,
    
    [parameter(Mandatory=$false,ParameterSetName="Property")]    
    [ValidateNotNullOrEmpty()]
    [Int]$DisplayIndex,

    [parameter(Mandatory=$false,ParameterSetName="Property")] 
    [ValidateNotNullOrEmpty()]
    [Boolean]$Required = $false,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    
    )    

    begin {

    }
    
    process {

        try {
    
            # --- Set Body for REST request depending on ParameterSet
            if ($PSBoundParameters.ContainsKey("JSON")){
        
                $Body = $JSON
                
            }
            else {                     
                $MultiValued = if($IsMultiValued) { "true" } else { "false" }
                $Mandatory = if($Required) { "true" } else { "false" }
                $Body = @"
                {
                    "id" : "$($Id)",
                    "label" : "$($Label)",
                    "description" : "$($Description)",
                    "dataType" : {
                        "type" : "primitive",
                        "typeId" : "$($DataType)"
                    },
                    "isMultiValued" : $($MultiValued),
                    "displayAdvice" : "$($Display)",
                    "tenantId" : "$($Tenant)",
                    "orderIndex": $($DisplayIndex),
                    "permissibleValues": {
                        "type": "static",
                        "customAllowed": false,
                        "values": [
                        {
                            "underlyingValue": {
                                "type": "string",
                                "value": "FirstValueValue"
                            },
                            "label": "FirstValueLabel"
                        },
                        {
                            "underlyingValue": {
                                "type": "string",
                                "value": "SecondValueValue"
                            },
                            "label": "SecondValueLabel"
                        }
                        ]
                    },
                    "facets": {
                        "mandatory": {
                            "type": "constant",
                            "value": {
                                "type": "boolean",
                                "value": $($Mandatory)
                            }
                        }
                    }
                }
"@

            }

            $URI = "/properties-service/api/propertydefinitions"  

            Write-Verbose -Message "Preparing POST to $($URI)"     

            # --- Run vRA REST Request           
            $Result = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body | Out-Null

            Get-vRAPropertyDefinition -Id $Id

        }
        catch [Exception]{

            throw
            
        }
        
    }
    end {
        
    }
    
}