function Get-vRAApplianceServiceStatus {
<#
    .SYNOPSIS
    Get information about vRA services

    Deprecated. Use Get-vRAComponentRegistryServiceStatus instead.

    .DESCRIPTION
    Get information about vRA services. These are the same services that you will see via the service tab

    Deprecated. Use Get-vRAComponentRegistryServiceStatus instead.

    .PARAMETER Name
    The name of the service to query

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
     Get-vRAApplianceServiceStatus

    .EXAMPLE
     Get-vRAApplianceServiceStatus -Limit 9999

    .EXAMPLE
     Get-vRAApplianceServiceStatus -Name iaas-service
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$false,ValueFromPipeline=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Name,

        [Parameter(Mandatory=$false,ValueFromPipeline=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Limit = "100"

    )

    begin {}

    process {

        try {

            Write-Warning -Message "This function is now deprecated. Please use Get-vRAComponentRegsitryService instead"

            # --- Build base URI with limit
            $URI =  "/component-registry/services/status/current?limit=$($Limit)"

            # --- If the name parameter is passed returned detailed information about the service
            if ($PSBoundParameters.ContainsKey("Name")){

                foreach ($ServiceName in $Name) {

                    $Filter = "name%20eq%20'$($ServiceName)'"

                    Write-Verbose -Message "Preparing GET to $($URI)&`$filter=$($Filter)"

                    $Response = Invoke-vRARestMethod -Method GET -URI "$($URI)&`$filter=$($Filter)"

                    Write-Verbose -Message "SUCCESS"

                    if ($Response.content.Length -eq 0) {

                        throw "Could not find service"

                    }

                    [pscustomobject]@{

                        Id = $Response.content.serviceId
                        Name = $Response.content.serviceName
                        TypeId = $Response.content.serviceTypeId
                        NotAvailable = $Response.content.notAvailable
                        LastUpdated = $Response.content.lastUpdated
                        EndpointUrl = $Response.content.statusEndPointUrl

                        Initialized = $Response.content.serviceStatus.initialized
                        SolutionUser = $Response.content.serviceStatus.solutionUser
                        StartedTime = $Response.content.serviceStatus.startedTime
                        Status = $Response.content.serviceStatus.serviceInitializationStatus
                        ErrorMessage = $Response.content.serviceStatus.errorMessage
                        IdentityCertificateInfo = $Response.content.serviceStatus.identityCertificateInfo
                        ServiceRegistrationId = $Response.content.serviceStatus.serviceRegistrationId
                        SSLCertificateInfo = $Response.content.serviceStatus.sslCertificateInfo
                        DefaultServiceEndpointType = $Response.content.serviceStatus.defaultServiceEndpointType

                    }

                }

            }
            else {

                Write-Verbose -Message "Preparing GET to $($URI)"

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                Write-Verbose -Message "Response contains $($Response.content.Length) records"

                foreach ($Service in $Response.content) {

                    [pscustomobject]@{

                        Id = $Service.serviceId
                        Name = $Service.serviceName
                        TypeId = $Service.serviceTypeId
                        NotAvailable = $Service.notAvailable
                        LastUpdated = $Service.lastUpdated
                        EndpointUrl = $Response.content.statusEndPointUrl

                        Initialized = $Service.serviceStatus.initialized
                        SolutionUser = $Service.serviceStatus.solutionUser
                        StartedTime = $Service.serviceStatus.startedTime
                        Status = $Service.serviceStatus.serviceInitializationStatus
                        ErrorMessage = $Service.serviceStatus.errorMessage
                        IdentityCertificateInfo = $Service.serviceStatus.identityCertificateInfo
                        ServiceRegistrationId = $Service.serviceStatus.serviceRegistrationId
                        SSLCertificateInfo = $Service.serviceStatus.sslCertificateInfo
                        DefaultServiceEndpointType = $Service.serviceStatus.defaultServiceEndpointType

                    }

                }

            }

        }
        catch [Exception]{

            throw

        }
    }
}