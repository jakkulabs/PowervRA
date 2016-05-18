function New-vRAPrincipal {
<#
    .SYNOPSIS
    Create a vRA vIDM Loal user
    
    .DESCRIPTION
    Create a vRA Principal (user)

    .PARAMETER TenantId
    Tenant ID
    
    .PARAMETER name
    Principal Name

    .PARAMETER User
    Principal Username in x@y format
    
    .PARAMETER firstName
    First Name

    .PARAMETER lastName
    Last Name

    .PARAMETER emailAddress
    Email Address

    .PARAMETER description
    Users text description

    .PARAMETER password
    Users password
    

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAPrincipal -TenantId vsphere.local -firstName "brent" -lastName "Smit" -emailAddress "me@vmware.com" -description "a description" -password "password" -User "user@vsphere.local"
    
    .EXAMPLE
    $JSON = @"
   {
  "locked" : false,
  "disabled" : false,
  "firstName" : "...",
  "lastName" : "...",
  "emailAddress" : "...",
  "description" : "...",
  "password" : "...",
  "principalId" : {
    "domain" : "...",
    "name" : "..."
  },
  "tenantName" : "...",
}
    "@
    $JSON | New-vRAPrincipal -TenantId Tenant01 
#> 
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

   Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$TenantId,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$User,
    
    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$firstName,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$lastName,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$emailAddress,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String[]]$description,

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$password,

    [parameter(Mandatory=$false,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {
    
    }
    
    process {

        try {
    
        # --- Set Body for REST request depending on ParameterSet
        if ($PSBoundParameters.ContainsKey("JSON")){

            $Data = ($JSON | ConvertFrom-Json)
        
            $Body = $JSON
            $Name = $Data.name
        }
        else {
        
            $Body = @"
              {
              "locked" : "false",
              "disabled" : "false",
              "firstName" : "$($firstName)",
              "lastName" : "$($lastName)",
              "emailAddress" : "$($emailAddress)",
              "description" : "$($description)",
              "password" : "$($password)",
              "principalId": { "domain": "", "name": ""} ,
              "tenantName" : "$($TenantId)",
              "name" : "$($TenantId)"
              }
"@

            # --- If certain parameters are specified, ConvertFrom-Json, update, then ConvertTo-Json
            if ( $PSBoundParameters.ContainsKey("User")){
            write-host "DOING IT"
                $JSONObject = ( $Body | ConvertFrom-Json )
                write-host $JSONObject


                if ($PSBoundParameters.ContainsKey("User")){

                    foreach ($Entity in $User){

                        $Domain = ($Entity -split "@")[1]
                        $Username = ($Entity -split "@")[0]

                
                        $JSONObject.principalId.domain = $($Domain) 
                        $JSONObject.principalId.name = $($Username) 
                
                    }

                }
            

                $Body = $JSONObject | ConvertTo-Json -Depth 5
        }

        if ($PSCmdlet.ShouldProcess($TenantId)){

            $URI = "/identity/api/tenants/$($TenantId)/principals"  
            write-host $URI
            # --- Run vRA REST Request
            $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body

            # --- Output the Successful Result
            #Get-vRAPrincipal -TenantId $TenantId -User $User
        }

        }
        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}

