function Set-vRAService {
<#
    .SYNOPSIS
    Set a vRA Service
    
    .DESCRIPTION
    Set a vRA Service

    Currently unsupported interactive actions:

    * HoursStartTime
    * HoursEndTime
    * ChangeWindowDayOfWeek
    * ChangeWindowStartTime
    * ChangeWindowEndTime
 
    .PARAMETER Id
    The id of the service

    .PARAMETER Name
    The name of the service

    .PARAMETER Description
    A description of the service

    .PARAMETER Status
    The status of the service

    .PARAMETER Owner
    The owner of the service

    .PARAMETER SupportTeam
    The support team of the service

    .PARAMETER IconId
    The Icon Id of the service. This must already exist in the Service Catalog. Typically it would have already been created via Import-vRAServiceIcon

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Get-vRAService -Name "Default" | Set-vRAService -Owner user@vsphere.local   
    
    .EXAMPLE   
    Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1"

    .EXAMPLE   
    Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh"

    .EXAMPLE   
    Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh" -Owner "user@vsphere.local"

    .EXAMPLE   
    Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh" -Owner "user@vsphere.local" -SupportTeam "support@vsphere.local"

    .EXAMPLE   
    Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh" -Owner "user@vsphere.local" -SupportTeam "support@vsphere.local" -Status INACTIVE
    
    .EXAMPLE   
    Set-vRAService -Id 25c0f3db-5906-4d42-8633-7b05f695432c -Name "Default 1" -Description "updated from posh" -Owner "user@vsphere.local" -SupportTeam "support@vsphere.local" -Status INACTIVE -IconId "cafe_icon_Service01"
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,            

        [Parameter(Mandatory=$false)]
        [ValidateSet("ACTIVE","RETIRED")]
        [String]$Status,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Owner,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$SupportTeam,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$IconId          
        
    )    

    Begin {
    
    }
    
    Process {

        # --- Check for existing service        
        try {

            Write-Verbose -Message "Testing for existing service"                       

            $URI = "/catalog-service/api/services/$($Id)"
            
            $Service = Invoke-vRARestMethod -Method GET -URI $URI

                        
        }
        catch [Exception] {
            
            throw
            
        }
        
        if ($PSBoundParameters.ContainsKey("Name")){

                Write-Verbose -Message "Updating Name: $($Service.name) >> $($Name)"
                $Service.name = $Name

            }

        if ($PSBoundParameters.ContainsKey("Description")){

               Write-Verbose -Message "Updating Description: $($Service.description) >> $($Description)"
               $Service.description = $Description

            }

        if ($PSBoundParameters.ContainsKey("Status")){
                
                Write-Verbose -Message "Updating Status: $($Service.status) >> $($Status)"
                $Service.status = $Status

            }

        if ($PSBoundParameters.ContainsKey("Owner")){

            # --- if the service does not have an owner, add one
            if(-not($Service.owner)) {

                Write-Verbose -Message "Adding owner principal: $($Owner)"

                $CatalogPrincipal = Get-vRACatalogPrincipal -Id $Owner   

                $Service | Add-Member -MemberType NoteProperty -Name "owner" -Value $catalogPrincipal    

            }
            else {

                Write-Verbose -Message "Updating Owner: $($Service.owner.ref) >> $($Owner)"           
                $Service.owner.ref = $Owner

                }

            }

        if ($PSBoundParameters.ContainsKey("SupportTeam")){

            # --- if the service does not have an support team, add one
            if(-not($Service.supportTeam)) {

                Write-Verbose -Message "Adding support team principal: $($SupportTeam)"

                $CatalogPrincipal = Get-vRACatalogPrincipal -Id $SupportTeam   

                $Service | Add-Member -MemberType NoteProperty -Name "supportTeam" -Value $catalogPrincipal    

            }
            else {

            Write-Verbose -Message "Updating Support Team: $($Service.supportTeam.ref) >> $($SupportTeam)"
            $Service.supportTeam.ref = $SupportTeam

            }
        }

        if ($PSBoundParameters.ContainsKey("IconId")){

                Write-Verbose -Message "Updating IconId: $($Service.iconId) >> $($IconId)"
                $Service.iconId = $IconId

            }

        # --- Update the existing service
        try {
            if ($PSCmdlet.ShouldProcess($Service.Name)){
                
                # --- Build the URI string for the service         
            
                $URI = "/catalog-service/api/services/$($Id)"
                           
                Invoke-vRARestMethod -Method PUT -URI $URI -Body ($Service | ConvertTo-Json -Compress) -Verbose:$VerbosePreference | Out-Null

                Get-vRAService -Id $Id
                
            }
                        
        }
        catch [Exception] {
            
            throw
            
        }
    
    }

    End {
        
    }

}