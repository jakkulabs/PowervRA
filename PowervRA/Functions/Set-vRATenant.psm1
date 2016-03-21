function Set-vRATenant {
<#
    .SYNOPSIS
    Update a vRA Tenant
    
    .DESCRIPTION
    Update a vRA Tenant
    
    .PARAMETER Name
    Tenant Name
    
    .PARAMETER Description
    Tenant Description

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
    Set-vRATenant -Name Tenant01 -Description "This is the updated description" -ID Tenant01
    
    .EXAMPLE
    $JSON = @"
    {
      "name" : "Tenant02",
      "description" : "This is the updated description for Tenant02",
      "urlName" : "Tenant02",
      "contactEmail" : "test.user@tenant02.local",
      "id" : "Tenant02",
      "defaultTenant" : false,
      "password" : ""
    }
    "@
    $JSON | Set-vRATenant
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

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
            
            # --- Check for existing Tenant
            try {

                $Tenant = Get-vRATenant -Id $ID
            }
            catch [Exception]{

                throw
            }   
        }
        else {

            # --- Check for existing Tenant
            try {

                $Tenant = Get-vRATenant -Id $ID
            }
            catch [Exception]{

                throw
            }

            
            # --- Set any properties not specified at function invocation
            if (-not($PSBoundParameters.ContainsKey("Description"))){

                if ($Tenant.Description){

                    $Description = $Tenant.Description
                }
            }
            if (-not($PSBoundParameters.ContainsKey("ContactEmail"))){

                if ($Tenant.ContactEmail){

                    $ContactEmail = $Tenant.ContactEmail
                }
            }
        
            $Body = @"
                {
                    "name" : "$($Name)",
                    "description" : "$($Description)",
                    "urlName" : "$($Tenant.URLName)",
                    "contactEmail" : "$($ContactEmail)",
                    "id" : "$($ID)",
                    "defaultTenant" : false,
                    "password" : ""
                }
"@
        }
        
        # --- Update existing Tenant 
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