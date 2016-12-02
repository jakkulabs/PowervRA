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
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Tenant = $Global:vRAConnection.Tenant,      
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$FirstName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$LastName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$EmailAddress,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Password,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("LockAccount")]
        [Switch]$DisableAccount,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("UnlockAccount")]
        [Switch]$EnableAccount   

    )    

    Begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
<<<<<<< HEAD

        # --- Fix for bug found in 7.1 and 7.2 where the PUT will fail if the password attribute is sent back NULL
        # --- If the API version is 7.1 or 7.2 and the Password parameter is not passed Remove unsupported parameters from $PSBoundParameters
        # --- This will ensure that they are not evaluated below
        if (($Global:vRAConnection.APIVersion -eq "7.1") -or ($Global:vRAConnection.APIVersion -eq "7.2") -and (!$PSBoundParameters.ContainsKey("Password"))) {

            Write-Verbose -Message "API Version $($Global:vRAConnection.APIVersion) detected and Password parameter not passed. Removing unsupported parameters."

            $PSBoundParameters.Remove("FirstName") | Out-Null
            $PSBoundParameters.Remove("LastName") | Out-Null
            $PSBoundParameters.Remove("EmailAddress") | Out-Null
            $PSBoundParameters.Remove("Description") | Out-Null
            $PSBoundParameters.Remove("DisableAccount") | Out-Null
            $PSBoundParameters.Remove("EnableAccount") | Out-Null

        }

=======
>>>>>>> master
    }
    
    Process {

        try {
            
            foreach ($PrincipalId in $Id) {
                
                $URI = "/identity/api/tenants/$($Tenant)/principals/$($PrincipalId)"
                $PrincipalObject = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                # --- Should update will be set to true if a property is updated
                # --- This will stop PUT operations where password is null
                $ShouldUpdate = $false
                
                if ($PSBoundParameters.ContainsKey("FirstName")) {
                    
                    Write-Verbose -Message "Updating FirstName: $($PrincipalObject.FirstName) >> $($FirstName)"
                    $PrincipalObject.FirstName = $FirstName
                    $ShouldUpdate = $true
                                                
                }                
                
                if ($PSBoundParameters.ContainsKey("LastName")) {
                    
                    Write-Verbose -Message "Updating LastName: $($PrincipalObject.LastName) >> $($LastName)"
                    $PrincipalObject.LastName = $LastName   
                    $ShouldUpdate = $true
                                                         
                }                   
                
                if ($PSBoundParameters.ContainsKey("EmailAddress")) {
                    
                    Write-Verbose -Message "Updating EmailAddress: $($PrincipalObject.EmailAddress) >> $($EmailAddress)"
                    $PrincipalObject.EmailAddress = $EmailAddress                    
                    $ShouldUpdate = $true
                                        
                }     
                
                if ($PSBoundParameters.ContainsKey("Description")) {
                    
                    Write-Verbose -Message "Updating Description: $($PrincipalObject.Description) >> $($Description)"
                    $PrincipalObject.Description = $Description
                    $ShouldUpdate = $true                   
                                        
                } 
                
                if ($PSBoundParameters.ContainsKey("Password")) {
                    
                    Write-Verbose -Message "Updating Password"
                    $PrincipalObject.Password = $Password
                    $ShouldUpdate = $true
                                                       
                }                                                     
                
                if ($PSBoundParameters.ContainsKey("DisableAccount")) {
     
                    Write-Verbose -Message "Disabling Account"
                    $PrincipalObject.Disabled = $true           
                    $ShouldUpdate = $true       
                                        
                }
                
                if ($PSBoundParameters.ContainsKey("EnableAccount")) {
                                           
                    Write-Verbose -Message "Enabling Account"
                    $PrincipalObject.Disabled = $false      
                    $PrincipalObject.Locked = $false      
                    $ShouldUpdate = $true                             
                                        
                }                                              
                
                $Body = $PrincipalObject | ConvertTo-Json -Compress
                
                if ($ShouldUpdate){

                    Write-Verbose -Message "ShouldUpdate is true. Proceeding with Update."

                    if ($PSCmdlet.ShouldProcess($PrincipalId)){

                        # --- Run vRA REST Request           
                        Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null
                        
                        Get-vRAUserPrincipal -Tenant $Tenant -Id $PrincipalId -Verbose:$VerbosePrefernce
                        
                    }

                }                           
                
            }

        }
        catch [Exception]{

            throw
            
        }
        
    }
    End {
        
    }
}