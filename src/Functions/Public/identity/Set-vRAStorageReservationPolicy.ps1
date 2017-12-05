function Set-vRAStorageReservationPolicy {
<#
    .SYNOPSIS
    Update a vRA Storage Reservation Policy
    
    .DESCRIPTION
    Update a vRA Storage Reservation Policy

    .PARAMETER Id
    Storage Reservation Policy Id
    
    .PARAMETER Name
    Storage Reservation Policy Name

    .PARAMETER NewName
    Storage Reservation Policy NewName
    
    .PARAMETER Description
    Storage Reservation Policy Description

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-vRAStorageReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd" -NewName "NewName" -Description "This is the New Name"

    .EXAMPLE
    Set-vRAStorageReservationPolicy -Name StorageReservationPolicy01 -NewName "NewName" -Description "This is the New Name"
    
    .EXAMPLE
    $JSON = @"
    {
      "id": "34ae1d6c-9972-4736-acdb-7ee109ad1dbd",
      "name": "StorageReservationPolicy01",
      "description": "This is Storage Reservation Policy 01",
      "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
    }
    "@
    $JSON | Set-vRAStorageReservationPolicy -Confirm:$false
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High",DefaultParameterSetName="ById")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [parameter(Mandatory=$true,ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String]$Name,

    [parameter(Mandatory=$false,ParameterSetName="ByName")]
    [parameter(Mandatory=$false,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String]$NewName,
    
    [parameter(Mandatory=$false,ParameterSetName="ByName")]
    [parameter(Mandatory=$false,ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String]$Description,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="JSON")]
    [ValidateNotNullOrEmpty()]
    [String]$JSON
    )    

    begin {
    
    }
    
    process {

        switch ($PsCmdlet.ParameterSetName) 
        { 
            "ById"  {                
            
            # --- Check for existing Storage Reservation Policy
            try {

                $StorageReservationPolicy = Get-vRAStorageReservationPolicy -Id $Id
                
                if (-not $StorageReservationPolicy){

                    throw "Storage Reservation Policy with id $($Id) does not exist"
                }
            }
            catch [Exception]{

                throw
            }
            
            # --- Set any properties not specified at function invocation
            if (-not($PSBoundParameters.ContainsKey("NewName"))){

                if ($StorageReservationPolicy.Name){

                    $Name = $StorageReservationPolicy.Name
                }
            }
            else {

                $Name = $NewName
            }
            if (-not($PSBoundParameters.ContainsKey("Description"))){

                if ($StorageReservationPolicy.Description){

                    $Description = $StorageReservationPolicy.Description
                }
            }
        
            $Body = @"
                {
                    "id": "$($Id)",
                    "name": "$($Name)",
                    "description": "$($Description)",
                    "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
                }
"@                                
            # --- Update existing Storage Reservation Policy
            try {
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/reservation-service/api/reservations/policies/$($Id)"  

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                    # --- Output the Successful Result
                    Get-vRAStorageReservationPolicy -Id $Id
                }
            }
            catch [Exception]{

                throw
            }
                break
            }

            "ByName"  {                

            # --- Check for existing Storage Reservation Policy
            try {

                $StorageReservationPolicy = Get-vRAStorageReservationPolicy -Name $Name

                if (-not $StorageReservationPolicy){

                    throw "Storage Reservation Policy with name $($Name) does not exist"
                }

                $Id = $StorageReservationPolicy.Id
            }
            catch [Exception]{

                throw
            }
            
            # --- Set any properties not specified at function invocation
            if (-not($PSBoundParameters.ContainsKey("NewName"))){

                if ($StorageReservationPolicy.Name){

                    $Name = $StorageReservationPolicy.Name
                }
            }
            else {

                $Name = $NewName
            }
            if (-not($PSBoundParameters.ContainsKey("Description"))){

                if ($StorageReservationPolicy.Description){

                    $Description = $StorageReservationPolicy.Description
                }
            }
        
            $Body = @"
                {
                    "id": "$($Id)",
                    "name": "$($Name)",
                    "description": "$($Description)",
                    "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
                }
"@                                
            # --- Update existing Storage Reservation Policy
            try {
                if ($PSCmdlet.ShouldProcess($Name)){

                    $URI = "/reservation-service/api/reservations/policies/$($Id)"  

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                    # --- Output the Successful Result
                    Get-vRAStorageReservationPolicy -Name $Name
                }
            }
            catch [Exception]{

                throw
            }

                
                break
            }

            "JSON"  {

                $Data = ($JSON | ConvertFrom-Json)
            
                $Body = $JSON
                $ID =  $Data.id
                #$Name = $Data.name
            
                # --- Check for existing Storage Reservation Policy
                try {

                    $StorageReservationPolicy = Get-vRAStorageReservationPolicy -Id $Id
                
                    if (-not $StorageReservationPolicy){

                        throw "Storage Reservation Policy with id $($Id) does not exist"
                    }
                }
                catch [Exception]{

                    throw
                }
                try {
                    if ($PSCmdlet.ShouldProcess($Id)){

                        $URI = "/reservation-service/api/reservations/policies/$($Id)"  

                        # --- Run vRA REST Request
                        Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body -Verbose:$VerbosePreference | Out-Null

                        # --- Output the Successful Result
                        Get-vRAStorageReservationPolicy -Id $Id
                    }
                }
                catch [Exception]{

                    throw
                }
                
                break
            }
        }
    

    }
    end {
        
    }
}