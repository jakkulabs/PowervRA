function Set-vRAReservationPolicy {
<#
    .SYNOPSIS
    Update a vRA Reservation Policy
    
    .DESCRIPTION
    Update a vRA Reservation Policy

    .PARAMETER Id
    Reservation Policy Id
    
    .PARAMETER Name
    Reservation Policy Name

    .PARAMETER NewName
    Reservation Policy NewName
    
    .PARAMETER Description
    Reservation Policy Description

    .PARAMETER JSON
    Body text to send in JSON format

    .INPUTS
    System.String.

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-vRAReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd" -NewName "NewName" -Description "This is the New Name"

    .EXAMPLE
    Set-vRAReservationPolicy -Name ReservationPolicy01 -NewName "NewName" -Description "This is the New Name"
    
    .EXAMPLE
    $JSON = @"
    {
      "id": "34ae1d6c-9972-4736-acdb-7ee109ad1dbd",
      "name": "ReservationPolicy01",
      "description": "This is Reservation Policy 01",
      "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
    }
    "@
    $JSON | Set-vRAReservationPolicy -Confirm:$false
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
            
            # --- Check for existing Reservation Policy
            try {

                $ReservationPolicy = Get-vRAReservationPolicy -Id $Id
                
                if (-not $ReservationPolicy){

                    throw "Reservation Policy with id $($Id) does not exist"
                }
            }
            catch [Exception]{

                throw
            }
            
            # --- Set any properties not specified at function invocation
            if (-not($PSBoundParameters.ContainsKey("NewName"))){

                if ($ReservationPolicy.Name){

                    $Name = $ReservationPolicy.Name
                }
            }
            else {

                $Name = $NewName
            }
            if (-not($PSBoundParameters.ContainsKey("Description"))){

                if ($ReservationPolicy.Description){

                    $Description = $ReservationPolicy.Description
                }
            }
        
            $Body = @"
                {
                    "id": "$($Id)",
                    "name": "$($Name)",
                    "description": "$($Description)",
                    "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
                }
"@                                
            # --- Update existing Reservation Policy
            try {
                if ($PSCmdlet.ShouldProcess($Id)){

                    $URI = "/reservation-service/api/reservations/policies/$($Id)"  

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                    # --- Output the Successful Result
                    Get-vRAReservationPolicy -Id $Id
                }
            }
            catch [Exception]{

                throw
            }
                break
            }

            "ByName"  {                

            # --- Check for existing Reservation Policy
            try {

                $ReservationPolicy = Get-vRAReservationPolicy -Name $Name

                if (-not $ReservationPolicy){

                    throw "Reservation Policy with name $($Name) does not exist"
                }

                $Id = $ReservationPolicy.Id
            }
            catch [Exception]{

                throw
            }
            
            # --- Set any properties not specified at function invocation
            if (-not($PSBoundParameters.ContainsKey("NewName"))){

                if ($ReservationPolicy.Name){

                    $Name = $ReservationPolicy.Name
                }
            }
            else {

                $Name = $NewName
            }
            if (-not($PSBoundParameters.ContainsKey("Description"))){

                if ($ReservationPolicy.Description){

                    $Description = $ReservationPolicy.Description
                }
            }
        
            $Body = @"
                {
                    "id": "$($Id)",
                    "name": "$($Name)",
                    "description": "$($Description)",
                    "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
                }
"@                                
            # --- Update existing Reservation Policy
            try {
                if ($PSCmdlet.ShouldProcess($Name)){

                    $URI = "/reservation-service/api/reservations/policies/$($Id)"  

                    # --- Run vRA REST Request
                    $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                    # --- Output the Successful Result
                    Get-vRAReservationPolicy -Name $Name
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
            
                # --- Check for existing Reservation Policy
                try {

                    $ReservationPolicy = Get-vRAReservationPolicy -Id $Id
                
                    if (-not $ReservationPolicy){

                        throw "Reservation Policy with id $($Id) does not exist"
                    }
                }
                catch [Exception]{

                    throw
                }
                try {
                    if ($PSCmdlet.ShouldProcess($Id)){

                        $URI = "/reservation-service/api/reservations/policies/$($Id)"  

                        # --- Run vRA REST Request
                        $Response = Invoke-vRARestMethod -Method PUT -URI $URI -Body $Body

                        # --- Output the Successful Result
                        Get-vRAReservationPolicy -Id $Id
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