function New-vRAService {
<#
    .SYNOPSIS
    Create a vRA Service for the current tenant
    
    .DESCRIPTION
    Create a vRA Service for the current tenant

    Currently unsupported interactive actions:

    * HoursStartTime
    * HoursEndTime
    * ChangeWindowDayOfWeek
    * ChangeWindowStartTime
    * ChangeWindowEndTime

    .PARAMETER Name
    The name of the service

    .PARAMETER Description
    A description of the service

    .PARAMETER Owner
    The owner of the service

    .PARAMETER SupportTeam
    The support team of the service

    .PARAMETER JSON
    A json string of type service (catalog-service/api/docs/el_ns0_service.html)  
    
    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-vRAService -Name "New Service"
    
    .EXAMPLE
    New-vRAService -Name "New Service" -Description "A new service" -Owner user@vsphere.local -SupportTeam customgroup@vsphere.local
    
    .EXAMPLE
    $JSON = @"

        {
          "name": "New Service",
          "description": "A new Service",
          "status": "ACTIVE",
          "statusName": "Active",
          "version": 1,
          "organization": {
            "tenantRef": "Tenant01",
            "tenantLabel": "Tenant01",
            "subtenantRef": null,
            "subtenantLabel": null
          },
          "newDuration": null,
          "iconId": "cafe_default_icon_genericService"
        }
"@

    $JSON | New-vRAService
       
    
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
        
        [Parameter(Mandatory=$true,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Description,            

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Owner,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$SupportTeam,
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
        [ValidateNotNullOrEmpty()]
        [String]$JSON      
     
    )    

    Begin {
    
    }
    
    Process {

            if ($PSBoundParameters.ContainsKey("JSON")) {

                $Data = ($JSON | ConvertFrom-Json)
        
                $Body = $JSON
                $Name = $Data.name
            }
            else {

                $Body = @"
                    {
                        "name": "$($Name)",
                        "description": "$($Description)",
                        "status": "ACTIVE",
                        "statusName": "Active",
                        "version": 1,
                        "organization": {
                            "tenantRef": "$($Global:vRAConnection.Tenant)",
                            "tenantLabel": null,
                            "subtenantRef": null,
                            "subtenantLabel": null
                        },   
                        "newDuration": null,
                        "iconId": "cafe_default_icon_genericService"
                    }
"@

                # --- If certain parameters are specified, ConvertFrom-Json, update, then ConvertTo-Json
                if ($PSBoundParameters.ContainsKey("Owner") -or $PSBoundParameters.ContainsKey("SupportTeam")){

                    $Object = $Body | ConvertFrom-Json

                    # --- Add owner catalogPrincipal
                    if ($PSBoundParameters.ContainsKey("Owner")) {

                        Write-Verbose -Message "Adding owner principal: $($Owner)"

                        $CatalogPrincipal = Get-vRACatalogPrincipal -Id $Owner   

                        $Object | Add-Member -MemberType NoteProperty -Name "owner" -Value $CatalogPrincipal                                         

                    }

                    # --- Add supportTeam catalogPrincipal
                    if ($PSBoundParameters.ContainsKey("SupportTeam")) {

                        Write-Verbose -Message "Adding support team principal: $($SupportTeam)"

                        $CatalogPrincipal = Get-vRACatalogPrincipal -Id $SupportTeam   

                        $Object | Add-Member -MemberType NoteProperty -Name "supportTeam" -Value $CatalogPrincipal

                    }

                    $Body = $Object | ConvertTo-Json -Compress

                }
                        
            }
       
        # --- Create new service
        try {
            if ($PSCmdlet.ShouldProcess($Name)){
                
                # --- Build the URI string for the service         
            
                $URI = "/catalog-service/api/services"
                           
                $Response = Invoke-vRARestMethod -Method POST -URI $URI -Body $Body -Verbose:$VerbosePreference

                Get-vRAService -Name "$($Name)"

            }

        }
        catch [Exception] {
            
            throw
            
        }
    
    }

    End {

    }

}