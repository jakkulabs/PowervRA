function Set-vRAUserPrincipal {
<#
    .SYNOPSIS
    Update a vRA local user principal
    
    .DESCRIPTION
    Update a vRA Principal (user)

    .PARAMETER Id
    The principal id of the user
    
    .PARAMETER Tenant
    The tenant of the user
    
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
    
    .PARAMETER DisableAccount
    Disable the user principal
    
    .PARAMETER EnableAccount
    Enable or unlock the user principal

    .INPUTS
    System.String.
    System.Diagnostics.Switch

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-vRAUserPrincipal -Id user@vsphere.local -FirstName FirstName-Updated -LastName LastName-Updated -EmailAddress userupdated@vsphere.local -Description Description-Updated
    
    .EXAMPLE
    Set-vRAUserPrincipal -Id user@vsphere.local -EnableAccount
    
    .EXAMPLE
    Set-vRAUserPrincipal -Id user@vsphere.local -DisableAccount
    
    .EXAMPLE
    Set-vRAUserPrincipal -Id user@vsphere.local -Password s3cur3p@ss!   
#> 
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,
       
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Tenant = $Global:vRAConnection.Tenant,      
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$FirstName,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$LastName,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$EmailAddress,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Password,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Alias("LockAccount")]
    [Switch]$DisableAccount,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [Alias("UnlockAccount")]
    [Switch]$EnableAccount   

    )    

    begin {
    
    }
    
    process {

        try {
            
            foreach ($PrincipalId in $Id) {
                
                $URI = "/identity/api/tenants/$($Tenant)/principals/$($PrincipalId)"
                $PrincipalObject = Invoke-vRARestMethod -Method GET -URI $URI
                
                if ($PSBoundParameters.ContainsKey("FirstName")) {
                    
                    Write-Verbose -Message "Updating FirstName: $($PrincipalObject.FirstName) >> $($FirstName)"
                    $PrincipalObject.FirstName = $FirstName                    
                                        
                }                
                
                if ($PSBoundParameters.ContainsKey("LastName")) {
                    
                    Write-Verbose -Message "Updating LastName: $($PrincipalObject.LastName) >> $($LastName)"
                    $PrincipalObject.LastName = $LastName                    
                                        
                }                   
                
                if ($PSBoundParameters.ContainsKey("EmailAddress")) {
                    
                    Write-Verbose -Message "Updating EmailAddress: $($PrincipalObject.EmailAddress) >> $($EmailAddress)"
                    $PrincipalObject.EmailAddress = $EmailAddress                    
                                        
                }     
                
                if ($PSBoundParameters.ContainsKey("Description")) {
                    
                    Write-Verbose -Message "Updating Description: $($PrincipalObject.Description) >> $($Description)"
                    $PrincipalObject.Description = $Description                    
                                        
                } 
                
                if ($PSBoundParameters.ContainsKey("Password")) {
                    
                    Write-Verbose -Message "Updating Password"
                    $PrincipalObject.Password = $Password                    
                                        
                }                                                     
                
                if ($PSBoundParameters.ContainsKey("DisableAccount")) {
     
                    Write-Verbose -Message "Disabling Account"
                    $PrincipalObject.Disabled = $True                  
                                        
                }
                
                if ($PSBoundParameters.ContainsKey("EnableAccount")) {
                                           
                    Write-Verbose -Message "Enabling Account"
                    $PrincipalObject.Disabled = $False      
                    $PrincipalObject.Locked = $False                                   
                                        
                }                                              
                
                $Body = $PrincipalObject | ConvertTo-Json -Compress
                
                if ($PSCmdlet.ShouldProcess($PrincipalId)){

                    $URI = "/identity/api/tenants/$($Tenant)/principals/$($PrincipalId)"  

                    Write-Verbose -Message "Preparing PUT to $($URI)"     

                    # --- Run vRA REST Request           
                    Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body | Out-Null
                    
                    Get-vRAUserPrincipal -Tenant $Tenant -Id $PrincipalId
                    
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