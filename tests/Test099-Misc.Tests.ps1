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

    It -Name "Return named Consumer Resource Operation for Id $($JSON.Misc.ConsumerResourceOperationId)" -Test {

        $ConsumerResourceOperationA = Get-vRAConsumerResourceOperation -Id $JSON.Misc.ConsumerResourceOperationId
        $ConsumerResourceOperationA.Id | Should Be $JSON.Misc.ConsumerResourceOperationId
    }

    It -Name "Return named Consumer Resource Type for Id $($JSON.Misc.ResourceTypeId)" -Test {

        $ConsumerResourceTypeA = Get-vRAConsumerResourceType -Id $JSON.Misc.ResourceTypeId
        $ConsumerResourceTypeA.Id | Should Be $JSON.Misc.ResourceTypeId
    }

    It -Name "Return named Resource Operation for $($JSON.Misc.ResourceOperation)" -Test {

        $ResourceOperationA = Get-vRAResourceOperation -Name $JSON.Misc.ResourceOperation
        $ResourceOperationA.Name | Should Be $JSON.Misc.ResourceOperation
    }

    It -Name "Return named Resource Type for Id $($JSON.Misc.ResourceTypeId)" -Test {

        $ResourceTypeA = Get-vRAResourceType -Id $JSON.Misc.ResourceTypeId
        $ResourceTypeA.Id | Should Be $JSON.Misc.ResourceTypeId
    }

    It -Name "Return named Consumer Service for $($JSON.Misc.ConsumerService)" -Test {

        $ConsumerServiceA = Get-vRAConsumerService -Name $JSON.Misc.ConsumerService
        $ConsumerServiceA.Name | Should Be $JSON.Misc.ConsumerService
    }

    It -Name "Return Metrics for a named Resource $($JSON.Misc.MetricsVM)" -Test {
        
        $MetricsA = Get-vRAResourceMetrics -Name $JSON.Misc.MetricsVM
        
        $MetricsA | Should Not Be $null
        
    }

}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false