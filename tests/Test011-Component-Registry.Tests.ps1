# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Component-Registry Tests' -Fixture {

    Context -Name 'Services' -Fixture {

        $ServiceName = "catalog-service"

        It -Name "Return all Services" -Test {

            $Services = Get-vRAComponentRegistryService
            $Services.Count | Should BeGreaterThan 0
        }

        It -Name "Return Service by Name" -Test {

            $Service = Get-vRAComponentRegistryService -Name $ServiceName
            $Service.Name | Should Be $ServiceName
        }
        
        It -Name "Return Service by Id" -Test {

            $ServiceId = (Get-vRAComponentRegistryService -Name $ServiceName).Id
            $Service = Get-vRAComponentRegistryService -Id $ServiceId
            $Service.Id | Should Be $ServiceId
        }              

        It -Name "Return all Service Status" -Test {

            $ServiceStatus = Get-vRAComponentRegistryServiceStatus
            $ServiceStatus.Count | Should BeGreaterThan 0
        }

        It -Name "Return Service Status by Name" -Test {

            $ServiceStatus = Get-vRAComponentRegistryServiceStatus -Name $ServiceName
            $ServiceStatus.NotAvailable | Should Be "False"
        }

        It -Name "Return Service Status by Id" -Test {

            $ServiceId = (Get-vRAComponentRegistryService -Name $ServiceName).Id
            $ServiceStatus = Get-vRAComponentRegistryServiceStatus -Id $ServiceId
            $ServiceStatus.NotAvailable | Should Be "False"
        }

        It -Name "Return Service Endpoint by Service Id" -Test {

            $ServiceId = (Get-vRAComponentRegistryService -Name $ServiceName).Id
            $ServiceEndpoints = Get-vRAComponentRegistryServiceEndpoint -Id $ServiceId
            $ServiceEndpoints.Count | Should BeGreaterThan 0
        }            
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false