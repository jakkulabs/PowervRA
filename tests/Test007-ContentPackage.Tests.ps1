# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Content Package Tests' -Fixture {

    It -Name "Create named Content Package $($JSON.ContentPackage.Name)" -Test {

        $ContentPackageA = New-vRAContentPackage -Name $JSON.ContentPackage.Name -Description $JSON.ContentPackage.Description -BlueprintName $JSON.ContentPackage.BlueprintName
        $ContentPackageA.Name | Should Be $JSON.ContentPackage.Name
    }

    It -Name "Return named Content Package $($JSON.ContentPackage.Name)" -Test {

        $ContentPackageB = Get-vRAContentPackage -Name $JSON.ContentPackage.Name
        $ContentPackageB.Name | Should Be $JSON.ContentPackage.Name
    }

    It -Name "Export named Content Package $($JSON.ContentPackage.Name)" -Test {

        $ContentPackageC = Export-vRAContentPackage -Name $JSON.ContentPackage.Name -File $JSON.ContentPackage.FileName
        $ContentPackageC.FullName | Should Be $JSON.ContentPackage.FileName
    }

    It -Name "Remove named Content Package $($JSON.ContentPackage.Name)" -Test {

        Remove-vRAContentPackage -Name $JSON.ContentPackage.Name -Confirm:$false
        
        try {
        
            $ContentPackageD = Get-vRAContentPackage -Name $JSON.ContentPackage.Name
        }
        catch [Exception]{

        }
        $ContentPackageD | Should Be $null
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false