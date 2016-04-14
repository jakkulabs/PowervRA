# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Business Group Tests' -Fixture {

    It -Name "Create named Business Group $($JSON.BusinessGroup.Name)" -Test {

        $BusinessGroupA = New-vRABusinessGroup -TenantId $JSON.Connection.Tenant -Name $JSON.BusinessGroup.Name -Description $JSON.BusinessGroup.Description -BusinessGroupManager $JSON.BusinessGroup.Manager -SupportUser $JSON.BusinessGroup.SupportUser -User $JSON.BusinessGroup.BasicUser -MachinePrefixId $JSON.BusinessGroup.MachinePrefixId -SendManagerEmailsTo $JSON.BusinessGroup.Manager
        $BusinessGroupA.Name | Should Be $JSON.BusinessGroup.Name
    }

    It -Name "Return named Business Group $($JSON.BusinessGroup.Name)" -Test {

        $BusinessGroupB = Get-vRABusinessGroup -Name $JSON.BusinessGroup.Name
        $BusinessGroupB.Name | Should Be $JSON.BusinessGroup.Name
    }

    It -Name "Update named Business Group $($JSON.BusinessGroup.Name)" -Test {

        $BusinessGroupD = Get-vRABusinessGroup -Name $JSON.BusinessGroup.Name
        $BusinessGroupE = Set-vRABusinessGroup -TenantId $JSON.Connection.Tenant -Id $BusinessGroupD.ID -Description $JSON.BusinessGroup.UpdatedDescription -Confirm:$false
        $BusinessGroupE.Description | Should Be $JSON.BusinessGroup.UpdatedDescription
    }

    It -Name "Remove named Business Group $($JSON.BusinessGroup.Name)" -Test {

        Remove-vRABusinessGroup -TenantId $JSON.Connection.Tenant -Name $JSON.BusinessGroup.Name -Confirm:$false
        $BusinessGroupF = Get-vRABusinessGroup -Name $JSON.BusinessGroup.Name
        $BusinessGroupF | Should Be $null
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false