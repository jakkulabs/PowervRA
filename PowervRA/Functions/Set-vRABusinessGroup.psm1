function Set-vRABusinessGroup {
<#
    .SYNOPSIS
    Update a vRA Business Group
    
    .DESCRIPTION
    Update a vRA Business Group
    
    .PARAMETER TenantId
    Tenant ID

    .PARAMETER Id
    Business Group ID
    
    .PARAMETER Name
    Business Group Name
    
    .PARAMETER Description
    Business Group Description

    .PARAMETER MachinePrefixId
    Machine Prefix Id
    
    .PARAMETER SendManagerEmailsTo
    Send Manager Emails To

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-vRABusinessGroup -TenantId Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7" -Name BusinessGroup01 -Description "Business Group 01" -MachinePrefixId "87e99513-cbea-4589-8678-c84c5907bdf2" -SendManagerEmailsTo "busgroupmgr01@vrademo.local"
    
    .EXAMPLE
    $JSON = @"
    {
        "id": "f8e0d99e-c567-4031-99cb-d8410c841ed7",
        "name": "BusinessGroup01",
        "description": "Business Group 01",
        "extensionData": {
        "entries": [
            {
            "key": "iaas-machine-prefix",
            "value": {
                "type": "string",
                "value": "87e99513-cbea-4589-8678-c84c5907bdf2"
            }
            },
            {
            "key": "iaas-manager-emails",
            "value": {
                "type": "string",
                "value": "busgroupmgr01@vrademo.local"
            }
            }
        ]
        },
        "tenant": "Tenant01"
    }
    "@
    $JSON | Set-vRABusinessGroup -ID Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$TenantId,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$ID,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,
    
    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$MachinePrefixId,

    [parameter(Mandatory=$false,ParameterSetName="Standard")]
    [ValidateNotNullOrEmpty()]
    [String]$SendManagerEmailsTo,

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
            $Name = $Data.name
            
            # --- Check for existing Business Group
            try {

                $BusinessGroup = Get-vRABusinessGroup -TenantId $TenantId | Where-Object {$_.id -eq $ID}
            }
            catch [Exception]{

                throw
            }   
        }
        else {

            # --- Check for existing Business Group
            try {

                $BusinessGroup = Get-vRABusinessGroup -TenantId $TenantId | Where-Object {$_.id -eq $ID}
            }
            catch [Exception]{

                throw
            }

            
            # --- Set any properties not specified at function invocation
            if (-not($PSBoundParameters.ContainsKey("Name"))){

                if ($BusinessGroup.Name){

                    $Name = $BusinessGroup.Name
                }
            }
            if (-not($PSBoundParameters.ContainsKey("Description"))){

                if ($BusinessGroup.Description){

                    $Description = $BusinessGroup.Description
                }
            }
            if (-not($PSBoundParameters.ContainsKey("SendManagerEmailsTo"))){

                if ($BusinessGroup.ExtensionData.entries | Where-Object {$_.key -eq "iaas-manager-emails"}){

                    $SendManagerEmailsTo = ($BusinessGroup.ExtensionData.entries | Where-Object {$_.key -eq "iaas-manager-emails"}).value.value
                }
            }        
           if (-not($PSBoundParameters.ContainsKey("MachinePrefixId"))){

                if ($BusinessGroup.ExtensionData.entries | Where-Object {$_.key -eq "iaas-machine-prefix"}){

                    $MachinePrefixId = ($BusinessGroup.ExtensionData.entries | Where-Object {$_.key -eq "iaas-machine-prefix"}).value.value
                }

                if ($MachinePrefixId){
                $Body = @"
                {
                    "id": "$($ID)",
                    "name": "$($Name)",
                    "description": "$($Description)",
                    "extensionData": {
                    "entries": [
                        {
                        "key": "iaas-machine-prefix",
                        "value": {
                            "type": "string",
                            "value": "$($MachinePrefixId)"
                        }
                        },
                        {
                        "key": "iaas-manager-emails",
                        "value": {
                            "type": "string",
                            "value": "$($SendManagerEmailsTo)"
                        }
                        }
                    ]
                    },
                    "tenant": "$($TenantId)"
                }
"@
                }
                else {

                    $Body = @"
                    {
                        "id": "$($ID)",
                        "name": "$($Name)",
                        "description": "$($Description)",
                        "extensionData": {
                        "entries": [
                            {
                            "key": "iaas-manager-emails",
                            "value": {
                                "type": "string",
                                "value": "$($SendManagerEmailsTo)"
                            }
                            }
                        ]
                        },
                        "tenant": "$($TenantId)"
                    }
"@

                }

            }        

            else {

                $Body = @"
                {
                    "id": "$($ID)",
                    "name": "$($Name)",
                    "description": "$($Description)",
                    "extensionData": {
                    "entries": [
                        {
                        "key": "iaas-machine-prefix",
                        "value": {
                            "type": "string",
                            "value": "$($MachinePrefixId)"
                        }
                        },
                        {
                        "key": "iaas-manager-emails",
                        "value": {
                            "type": "string",
                            "value": "$($SendManagerEmailsTo)"
                        }
                        }
                    ]
                    },
                    "tenant": "$($TenantId)"
                }
"@

            }

            }    
        
        # --- Update existing Business Group 
        try {
            if ($PSCmdlet.ShouldProcess($Id)){

                $URI = "/identity/api/tenants/$($TenantId)/subtenants/$($Id)"  

                # --- Run vRA REST Request
                $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                # --- Output the Successful Result
                Get-vRABusinessGroup -TenantId $TenantId | Where-Object {$_.id -eq $ID}
            }
        }
        catch [Exception]{

            throw
        }
    }
    end {
        
    }
}