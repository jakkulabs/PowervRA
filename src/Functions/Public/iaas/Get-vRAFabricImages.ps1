function Get-vRAFabricImages {
    <#
        .SYNOPSIS
        Get a vRA FabricImages
    
        .DESCRIPTION
        Get a vRA FabricImages
    
        .PARAMETER Id
        The ID of the FabricImages
    
        .PARAMETER Name
        The Name of the FabricImages
    
        .INPUTS
        System.String
    
        .OUTPUTS
        System.Management.Automation.PSObject
    
        .EXAMPLE
        Get-vRAFabricImages
    
        .EXAMPLE
        Get-vRAFabricImages -Id '3492a6e8-r5d4-1293-b6c4-39037ba693f9'
    
        .EXAMPLE
        Get-vRAFabricImages -Name 'TestFabricImages'
    
    #>
    [CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]
    
        Param (
    
            [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ById")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Id,
    
            [Parameter(Mandatory=$true,ParameterSetName="ByName")]
            [ValidateNotNullOrEmpty()]
            [String[]]$Name
        )
    
        begin {
            $APIUrl = '/deployment/api/fabric-images'
    
            function CalculateOutput([PSCustomObject]$FabricImages) {
    
                [PSCustomObject] @{
                    OSFamily = $FabricImages.osFamily
                    ExternalRegionId = $FabricImages.externalRegionId
                    CustomProperties = $FabricImages.customProperties
                    IsPrivate = $FabricImages.isPrivate
                    ExternalId = $FabricImages.externalId
                    Name = $FabricImages.name
                    Description = $FabricImages.description
                    Id = $FabricImages.id
                    UpdatedAt = $FabricImages.updatedAt
                    OrganizationId = $FabricImages.organizationId
                    Links = $FabricImages._links
                }
            }
        }
    
        process {
    
            try {
    
                switch ($PsCmdlet.ParameterSetName) {
    
                    # --- Get Fabric Image by Id
                    'ById' {
    
                        foreach ($FabricImagesId in $Id){
    
                            $URI = "$($APIUrl)?`$filter=id eq '$($FabricImagesId)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricImages in $Response.content) {
                                CalculateOutput $FabricImages
                            }
                        }
    
                        break
                    }
                    # --- Get Fabric Image by Name
                    'ByName' {
    
                        foreach ($FabricImagesName in $Name){
    
                            $URI = "$($APIUrl)?`$filter=name eq '$($FabricImagesName)'"
                            $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference
    
                            foreach ($FabricImages in $Response.content) {
                                CalculateOutput $FabricImages
                            }
                        }
    
                        break
                    }
                    # --- No parameters passed so return all Fabric Images
                    'Standard' {
    
                        $URI = $APIUrl
                        $Response = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

                        foreach ($FabricImages in $Response.content) {
                            CalculateOutput $FabricImages
                        }
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
    