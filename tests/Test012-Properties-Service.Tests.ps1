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

    It -Name "Create a named Property Group $($JSON.PropetiesService.PropertyGroup.Name)" -Test {
        $PropertiesHash = @{}
        # Simple property
        $PropertiesHash.Add("SimpleProperty", $JSON.PropertiesService.PropertyGroup.SimpleProperty)
        # Complex Property
        $ComplexProperty = @{}

        # Complex Property Values
        $mandatory = $JSON.PropertiesService.PropertyGroup.ComplexProperty.mandatory
        $encrypted = $JSON.PropertiesService.PropertyGroup.ComplexProperty.encrypted
        $visibility = $JSON.PropertiesService.PropertyGroup.ComplexProperty.visibility
        $defaultValue = $JSON.PropertiesService.PropertyGroup.ComplexProperty.defaultValue

        # build complex property
        $ComplexProperty.Add("mandatory", $mandatory)
        $ComplexProperty.Add("encrypted", $encrypted)
        $ComplexProperty.Add("visibility", $visibility)
        $ComplexProperty.Add("defaultValue", $defaultValue)

        # add complex property to hash
        $PropertiesHash.Add("ComplexProperty", $ComplexProperty)
        
        $PropertyGroupA = New-vRAPropertyGroup -Name $JSON.PropertiesService.PropertyGroup.Name -Label $JSON.PropertiesService.PropertyGroup.Label `
                                        -Properties $PropertiesHash
        $PropertyGroupA.Id | Should Be $JSON.PropertiesService.PropertyGroup.Name
        $PropertyGroupA.Properties.Count | Should Be 2

        # check simple property first
        $PropertyGroupA.Properties.SimpleProperty.defaultValue | Should Be $JSON.PropertiesService.PropertyGroup.SimpleProperty

        # check complex property next
        $PropertyGroupA.Properties.ComplexProperty.mandatory | Should Be $JSON.PropertiesService.PropertyGroup.ComplexProperty.mandatory
        $PropertyGroupA.Properties.ComplexProperty.encrypted | Should Be $JSON.PropertiesService.PropertyGroup.ComplexProperty.encrypted
        $PropertyGroupA.Properties.ComplexProperty.visibility | Should Be $JSON.PropertiesService.PropertyGroup.ComplexProperty.visibility

        # check defaultValue if unencrypted 
        if (-Not $PropertyGroupA.Properties.ComplexProperty.encrypted) {
            $PropertyGroupA.Properties.ComplexProperty.defaultValue | Should Be $JSON.PropertiesService.PropertyGroup.ComplexProperty.defaultValue
        } else {
            # encrypted, so just check that value exists if value was passed
            if (-Not [string]::IsNullOrEmpty($JSON.PropertiesService.PropertyGroup.ComplexProperty.defaultValue)) {
                $PropertyGroupA.Properties.ComplexProperty.defaultValue | Should Not BeNullOrEmpty
            } else {
                $PropertyGroupA.Properties.ComplexProperty.defaultValue | Should BeNullOrEmpty
            }
        }
    }

    It -Name "Return named Property Group $($JSON.PropertiesService.PropertyGroup.Name)" -Test {

        $PropertyGroupB = Get-vRAPropertyGroup -Id $JSON.PropertiesService.PropertyGroup.Name
        $PropertygroupB.Id | Should Be $JSON.PropertiesService.PropertyGroup.Name
    }

    It -Name "Remove named Property Group $($JSON.PropertiesService.PropertyGroup.Name)" -Test {

        Remove-vRAPropertyGroup -Id $JSON.PropertiesService.PropertyGroup.Name -Confirm:$false
        try {
            $PropertyGroupD = Get-vRAPropertyGroup -Id $JSON.PropertiesService.PropertyGroup.Name
        }
        catch [Exception]{

        }
        $PropertyGroupD | Should Be $null
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false