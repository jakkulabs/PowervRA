function Set-vRACatalogItem {
<#
    .SYNOPSIS
    Update a vRA catalog item
    
    .DESCRIPTION
    Update a vRA catalog item    

    .PARAMETER Id
    The id of the catalog item
    
    .PARAMETER Status
    The status of the catalog item (e.g. PUBLISHED, RETIRED, STAGING)   
    
    .PARAMETER Quota
    The Quota of the catalog item
    
    .PARAMETER Service
    The Service to assign the catalog item to
    
    .PARAMETER NewAndNoteworthy
    Mark the catalog item as New and noteworthy in the UI

    .PARAMETER IconId
    The Icon Id of the catalog item. This must already exist in the Service Catalog. Typically it would have already been created via Import-vRAServiceIcon
    
    .INPUTS
    System.Int
    System.String
    System.Bool

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE    
    Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -Status PUBLISHED
    
    .EXAMPLE    
    Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -Quota 1
    
    .EXAMPLE    
    Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -Service "Default Service" 
    
    .EXAMPLE    
    Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -NewAndNoteworthy $false

    .EXAMPLE    
    Get-vRACatalogItem  -Name "Create cluster" | Set-vRACatalogItem -IconId "cafe_icon_CatalogItem01" -Confirm:$false           
    
    TODO:
    - Investigate / fix authorization error 
    
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Id,

        [Parameter(Mandatory=$false,ParameterSetName="SetStatus")]
        [ValidateSet("PUBLISHED","RETIRED","STAGING")]
        [String]$Status,
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Int]$Quota,

        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [String]$Service,
        
        [Parameter(Mandatory=$false,ParameterSetName="Standard")]
        [ValidateNotNullOrEmpty()]
        [Bool]$NewAndNoteworthy,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$IconId
    
    )    

    Begin {
        # --- Test for vRA API version
        xRequires -Version 7.0
    }
    
    Process {

        # --- Check for existing catalog item        
        try {

            Write-Verbose -Message "Testing for existing catalog item"                       
                
            #$CatalogItem = Get-vRACatalogItem -Id $($Id)                             

            $URI = "/catalog-service/api/catalogItems/$($Id)"
            $CatalogItem = Invoke-vRARestMethod -Method GET -URI $URI          
            
            
        }
        catch [Exception] {
            
            throw
            
        }
        
        if ($PSBoundParameters.ContainsKey("Status")){

                Write-Verbose -Message "Updating Status: $($CatalogItem.status) >> $($Status)"
                $CatalogItem.status = $Status

            }
            
        if ($PSBoundParameters.ContainsKey("Quota")){

                Write-Verbose -Message "Updating Quota: $($CatalogItem.quota) >> $($Quota)"
                $CatalogItem.quota = $Quota

            }
            
        if ($PSBoundParameters.ContainsKey("Service")){

                $NewService = Get-vRAService -Name $($Service)

                # --- If the catalog item does not currently have service assigned, add one
                if (-not($CatalogItem.serviceRef)) {

                    Write-Verbose -Message "Associating catalog item with service $($Service)"

                    $ServiceRef = [PSCustomObject] @{

                        id = $NewService.Id;
                        name = $NewService.Name;

                        }

                    $CatalogItem | Add-Member -MemberType NoteProperty -Name "serviceRef" -Value $ServiceRef -Force

                    }
                else {                             
                
                    Write-Verbose -Message "Updating Service >> $($Service)"
                
                    $CatalogItem.serviceRef.id = $NewService.Id
                    $CatalogItem.serviceRef.label = $NewService.Name

                    }
            } 
            
        if ($PSBoundParameters.ContainsKey("NewAndNoteworthy")){

                Write-Verbose -Message "Updating isNoteworthy: $($CatalogItem.isNoteworthy) >> $($NewAndNoteworthy)"

                $CatalogItem.isNoteworthy = $NewAndNoteworthy

            }

        if ($PSBoundParameters.ContainsKey("IconId")){

                Write-Verbose -Message "Updating IconId: $($CatalogItem.iconId) >> $($IconId)"
                $CatalogItem.iconId = $IconId

            }

        # --- Update the existing catalog item
        try {
            if ($PSCmdlet.ShouldProcess($Id)){
                
                # --- Build the URI string for the catalog item   
                $URI = "/catalog-service/api/catalogItems/$($Id)"      
            
                Invoke-vRARestMethod -Method PUT -URI $URI -Body ($CatalogItem | ConvertTo-Json -Depth 100) -Verbose:$VerbosePreference | Out-Null
                Get-vRACatalogItem -Id $($CatalogItem.id)
                
            }
                        
        }
        catch [Exception] {
            
            throw
            
        }
    
    }  

    End {

    }  

}