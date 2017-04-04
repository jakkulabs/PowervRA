# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password -AsPlainText -Force
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements

# --- Tests
Describe -Name 'Properties Service Tests' -Fixture {

    It -Name "Create named Property Definition $($JSON.PropertiesService.PropertyDefinition.Name)" -Test {

        $PropertyDefinitionA = New-vRAPropertyDefinition -Name $JSON.PropertiesService.PropertyDefinition.Name -Label $JSON.PropertiesService.PropertyDefinition.Label -Boolean -BooleanDisplay $JSON.PropertiesService.PropertyDefinition.BooleanDisplay
        $PropertyDefinitionA.Id | Should Be $JSON.PropertiesService.PropertyDefinition.Name
    }

    It -Name "Return named Property Definition $($JSON.PropertiesService.PropertyDefinition.Name)" -Test {

        $PropertyDefinitionB = Get-vRAPropertyDefinition -Id $JSON.PropertiesService.PropertyDefinition.Name
        $PropertyDefinitionB.Id | Should Be $JSON.PropertiesService.PropertyDefinition.Name
    }

    It -Name "Remove named Property Definition $($JSON.PropertiesService.PropertyDefinition.Name)" -Test {

        Remove-vRAPropertyDefinition -Id $JSON.PropertiesService.PropertyDefinition.Name -Confirm:$false
        try {
            $PropertyDefinitionD = Get-vRAPropertyDefinition -Id $JSON.PropertiesService.PropertyDefinition.Name
        }
        catch [Exception]{

        }
        $PropertyDefinitionD | Should Be $null
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false