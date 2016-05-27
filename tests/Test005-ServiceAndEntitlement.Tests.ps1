# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Service and Entitlement Tests' -Fixture {

    It -Name "Create named Service $($JSON.Service.Name)" -Test {

        $ServiceA = New-vRAService -Name $JSON.Service.Name -Description $JSON.Service.Description
        $ServiceA.Name | Should Be $JSON.Service.Name
    }

    It -Name "Return named Service $($JSON.Service.Name)" -Test {

        $ServiceB = Get-vRAService -Name $JSON.Service.Name
        $ServiceB.Name | Should Be $JSON.Service.Name
    }

    It -Name "Update named Service $($JSON.Service.Name)" -Test {

        $ServiceC = Get-vRAService -Name $JSON.Service.Name
        $ServiceD = Set-vRAService -Id $ServiceC.Id -Description $JSON.Service.UpdatedDescription -Confirm:$false
        $ServiceD.Description | Should Be $JSON.Service.UpdatedDescription
    }

    $Global:Suffix = Get-Random -Minimum 0 -Maximum 10001
    It -Name "Create named Entitlement $($JSON.Entitlement.Name + $Global:Suffix)" -Test {
        
        $EntitlementA = New-vRAEntitlement -Name ($JSON.Entitlement.Name + $Global:Suffix) -Description $JSON.Entitlement.Description -BusinessGroup $JSON.Entitlement.BusinessGroup -Principals $JSON.Entitlement.Principals -EntitledServices $JSON.Entitlement.EntitledServices
        $EntitlementA.Name | Should Be ($JSON.Entitlement.Name + $Global:Suffix) 
    }

    It -Name "Return named Entitlement $($JSON.Entitlement.Name + $Global:Suffix)" -Test {

        $EntitlementB = Get-vRAEntitlement -Name ($JSON.Entitlement.Name + $Global:Suffix) 
        $EntitlementB.Name | Should Be ($JSON.Entitlement.Name + $Global:Suffix) 
    }

    It -Name "Update named Entitlement $($JSON.Entitlement.Name + $Global:Suffix)" -Test {

        $EntitlementC = Get-vRAEntitlement -Name ($JSON.Entitlement.Name + $Global:Suffix) 
        $EntitlementD = Set-vRAEntitlement -Id $EntitlementC.Id -Description $JSON.Entitlement.UpdatedDescription -Confirm:$false
        $EntitlementD.Description | Should Be $JSON.Entitlement.UpdatedDescription
    }

    It -Name "Remove named Service $($JSON.Service.Name)" -Test {

        $ServiceE = Get-vRAService -Name $JSON.Service.Name
        Remove-vRAService -Id $ServiceE.Id -Confirm:$false
        try {

            $ServiceF = Get-vRAService -Name $JSON.Service.Name
        }
        catch [Exception]{

        }
        $ServiceF | Should Be $null
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false