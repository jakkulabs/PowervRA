# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Misc Tests' -Fixture {

    It -Name "Return named Appliance Service Status for $($JSON.Misc.ApplianceServiceName)" -Test {

        $ApplianceServiceStatusA = Get-vRAApplianceServiceStatus -Name $JSON.Misc.ApplianceServiceName
        $ApplianceServiceStatusA.Name | Should Be $JSON.Misc.ApplianceServiceName
    }

    It -Name "Return named Authorization Role $($JSON.Misc.AuthorizationRole)" -Test {

        $AuthorizationRoleA = Get-vRAAuthorizationRole -Id $JSON.Misc.AuthorizationRole
        $AuthorizationRoleA.Id | Should Be $JSON.Misc.AuthorizationRole
    }

    It -Name "Return Metrics for a named Resource $($JSON.Misc.MetricsVM)" -Test {
        
        $MetricsA = Get-vRAResourceMetric -Name $JSON.Misc.MetricsVM
        
        $MetricsA | Should Not Be $null
        
    }

}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false