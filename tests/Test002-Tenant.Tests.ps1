# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.DefaultTenantConnection.vRAAppliance -Tenant $JSON.DefaultTenantConnection.Tenant -Username $JSON.DefaultTenantConnection.Username -Password $JSON.DefaultTenantConnection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Tenant Tests' -Fixture {

    It -Name "Create named Tenant $($JSON.Tenant.Name)" -Test {

        $TenantA = New-vRATenant -Name $JSON.Tenant.Name -Description $JSON.Tenant.Description -URLName $JSON.Tenant.URLName -ContactEmail $JSON.Tenant.ContactEmail -ID $JSON.Tenant.ID
        $TenantA.Name | Should Be $JSON.Tenant.Name
    }

    It -Name "Return named Tenant $($JSON.Tenant.Name)" -Test {

        $TenantB = Get-vRATenant -Id $JSON.Tenant.ID
        $TenantB.Name | Should Be $JSON.Tenant.Name
    }

    It -Name "Create named Tenant Directory $($JSON.TenantDirectory.Name)" -Test {

        $TenantDirectoryA = New-vRATenantDirectory -ID $JSON.TenantDirectory.ID -Name $JSON.TenantDirectory.Name -Description $JSON.TenantDirectory.Description -Type $JSON.TenantDirectory.Type -Domain $JSON.TenantDirectory.Domain -UserNameDN $JSON.TenantDirectory.UserNameDN -Password $JSON.TenantDirectory.Password -URL $JSON.TenantDirectory.URL -GroupBaseSearchDN $JSON.TenantDirectory.GroupBaseSearchDN -UserBaseSearchDN $JSON.TenantDirectory.UserBaseSearchDN -GroupBaseSearchDNs $JSON.TenantDirectory.GroupBaseSearchDNs -UserBaseSearchDNs $JSON.TenantDirectory.UserBaseSearchDNs -TrustAll
        $TenantDirectoryA.Name | Should Be $JSON.TenantDirectory.Name
    }

    It -Name "Return named Tenant Directory $($JSON.TenantDirectory.Name)" -Test {

        $TenantDirectoryB = Get-vRATenantDirectory -Id $JSON.TenantDirectory.ID
        $TenantDirectoryB.Name | Should Be $JSON.TenantDirectory.Name
    }

    It -Name "Return named Tenant Directory Status for $($JSON.Tenant.Name)" -Test {

        $TenantDirectoryStatusA = Get-vRATenantDirectoryStatus -Id $JSON.Tenant.Name -Domain $JSON.TenantDirectory.Domain
        $TenantDirectoryStatusA.Tenant | Should Be $JSON.Tenant.Name
    }

    It -Name "Add Named Principal to Tenant Role in $($JSON.Tenant.Name)" -Test {

        $TenantRoleA = Add-vRAPrincipalToTenantRole -TenantId $JSON.TenantRole.TenantId -PrincipalId $JSON.TenantRole.PrincipalId -RoleId $JSON.TenantRole.RoleId
        $TenantRoleA.Principal | Should Be $JSON.TenantRole.PrincipalId
    }

    It -Name "Return named Tenant Role in $($JSON.Tenant.Name)" -Test {

        $TenantRoleB = Get-vRATenantRole -TenantId $JSON.TenantRole.TenantId -PrincipalId $JSON.TenantRole.PrincipalId | Where-Object {$_.ID -eq $JSON.TenantRole.RoleId}
        $TenantRoleB.Principal | Should Be $JSON.TenantRole.PrincipalId
    }

    It -Name "Update named Tenant Directory $($JSON.TenantDirectory.Name)" -Test {

        $TenantDirectoryC = Set-vRATenantDirectory -ID $JSON.TenantDirectory.ID -Domain $JSON.TenantDirectory.Domain -GroupBaseSearchDNs $JSON.TenantDirectory.UpdatedGroupBaseSearchDNs -Confirm:$false
        $TenantDirectoryC.GroupBaseSearchDNs | Should Be $JSON.TenantDirectory.UpdatedGroupBaseSearchDNs
    }

    It -Name "Update named Tenant $($JSON.Tenant.Name)" -Test {

        $TenantC = Set-vRATenant -ID $JSON.Tenant.ID -Name $JSON.Tenant.Name -Description $JSON.Tenant.UpdatedDescription -Confirm:$false
        $TenantC.Description | Should Be $JSON.Tenant.UpdatedDescription
    }

    It -Name "Remove named Tenant Role in $($JSON.Tenant.Name)" -Test {

        Remove-vRAPrincipalFromTenantRole -TenantId $JSON.TenantRole.TenantId -PrincipalId $JSON.TenantRole.PrincipalId -RoleId $JSON.TenantRole.RoleId -Confirm:$false
        $TenantRoleC = Get-vRATenantRole -TenantId $JSON.TenantRole.TenantId -PrincipalId $JSON.TenantRole.PrincipalId | Where-Object {$_.ID -eq $JSON.TenantRole.RoleId}
        $TenantRoleC | Should Be $null
    }

    It -Name "Remove named Tenant Directory in $($JSON.Tenant.Name)" -Test {

        Remove-vRATenantDirectory -ID $JSON.TenantDirectory.ID -Domain $JSON.TenantDirectory.Domain -Confirm:$false
        $TenantDirectoryD = Get-vRATenantDirectory -Id $JSON.TenantDirectory.ID
        $TenantDirectoryD | Should Be $null
    }

    It -Name "Remove named Tenant $($JSON.Tenant.Name)" -Test {

        Remove-vRATenant -ID $JSON.Tenant.ID -Confirm:$false
        try {
            $TenantD = Get-vRATenant -Id $JSON.Tenant.ID
        }
        catch [Exception]{

        }
        $TenantD | Should Be $null
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false