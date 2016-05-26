function New-vRATenant {
<#
    .SYNOPSIS
    Create a vRA Tenant
    
    .DESCRIPTION
    Create a vRA Tenant
    
    .PARAMETER Name
    Tenant Name
    
    .PARAMETER Description
    Tenant Description
    
    .PARAMETER URLName
    Tenant URL Name

    .PARAMETER ContactEmail
    Tenant Contact Email

    .PARAMETER ID
    Tenant ID

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRATenant -Name Tenant01 -Description "This is Tenant01" -URLName Tenant01 -ContactEmail admin.user@tenant01.local -ID Tenant01
    
    .EXAMPLE
    $JSON = @"
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
    $JSON | New-vRATenant
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$URLName,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ContactEmail,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$ID,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {
    
    }
    
    process {
    
        # --- Set Body for REST request depending on ParameterSet
        if ($PSBoundParameters.ContainsKey("JSON")){
        
            $Data = ($JSON | ConvertFrom-Json)
            
            $Body = $JSON
            $ID =  $Data.id
            $Name = $Data.name     
        }
        else {
        
            $Body = @"
                {
                    "name" : "$($Name)",
                    "description" : "$($Description)",
                    "urlName" : "$($URLName)",
                    "contactEmail" : "$($ContactEmail)",
                    "id" : "$($ID)",
                    "defaultTenant" : false,
                    "password" : ""
                }
"@
        }   
           
        try {
            if ($PSCmdlet.ShouldProcess($Name)){

                $URI = "/identity/api/tenants/$($ID)"  

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                # --- Output the Successful Result
                Get-vRATenant -Id $ID
            }
            
        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}