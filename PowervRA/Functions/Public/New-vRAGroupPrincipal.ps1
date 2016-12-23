function New-vRAGroupPrincipal {
<#
    .SYNOPSIS
    Create a vRA custom group
    
    .DESCRIPTION
    Create a vRA Principal (user)

    .PARAMETER Tenant
    The tenant of the group
    
    .PARAMETER Name
    Group name
    
    .PARAMETER Description
    A description for the group
    
    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAGroupPrincipal -Name TestGroup01 -Description "Test Group 01"
    
    .EXAMPLE
    $JSON = @"
        {
            "@type": "Group",
            "groupType": "CUSTOM",
            "name": "TestGroup01",
            "fqdn": "TestGroup01@Tenant",
            "domain": "Tenant",
            "description": "Test Group 01",
            "principalId": {
                "domain": "Tenant",
                "name": "TestGroup01"
            }
        }
"@    
   
#> 
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false,ParameterSetName="Standard")] 
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant,
    
    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

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
                $Tenant = ($JSON | ConvertFrom-Json).domain
                
            }
            else {

                $Body = @"
                    {
                        "@type": "Group",
                        "groupType": "CUSTOM",
                        "name": "$($Name)",
                        "fqdn": "$($Name)@$($Tenant)",
                        "domain": "$($Tenant)",
                        "description": "$($Description)",
                        "principalId": {
                            "domain": "$($Tenant)",
                            "name": "$($Name)"
                        }
                    }
"@

            }

            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/identity/api/tenants/$($Tenant)/groups"  

                Write-Verbose -Message "Preparing POST to $($URI)"     

                # --- Run vRA REST Request           
                Invoke-vRARestMethod -Method POST -URI $URI -Body $Body | Out-Null
                
                Get-vRAGroupPrincipal -Tenant $Tenant -Id "$($Name)@$($Tenant)"
                
            }

        }
        catch [Exception]{

            throw
            
        }
        
    }
    end {
        
    }
        
}