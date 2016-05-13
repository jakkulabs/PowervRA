# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Catalog Item Tests' -Fixture {

    It -Name "Return named Catalog Item $($JSON.CatalogItem.Name)" -Test {

        $CatalogItemA = Get-vRACatalogItem -Name $JSON.CatalogItem.Name
        $CatalogItemA.Name | Should Be $JSON.CatalogItem.Name
    }

    It -Name "Update named Catalog Item $($JSON.CatalogItem.Name)" -Test {

        $Quota = Get-Random -Minimum 10 -Maximum 51
        $CatalogItemB = Get-vRACatalogItem -Name $JSON.CatalogItem.Name | Set-vRACatalogItem -Quota $Quota -Confirm:$false
        $CatalogItemB.Quota | Should Be $Quota
    }

    It -Name "Return named entitled Catalog Item $($JSON.CatalogItem.Name)" -Test {

        $CatalogItemC = Get-vRAEntitledCatalogItem -Name $JSON.CatalogItem.Name
        $CatalogItemC.Name | Should Be $JSON.CatalogItem.Name
    }

    It -Name "Return named Catalog Principal $($JSON.UserConnection.Username)" -Test {

        $CatalogPrincipalA = Get-vRACatalogPrincipal -Id $JSON.UserConnection.Username
        $CatalogPrincipalA.ref | Should Be $JSON.UserConnection.Username
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.UserConnection.vRAAppliance -Tenant $JSON.UserConnection.Tenant -Username $JSON.UserConnection.Username -Password $JSON.UserConnection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Consumer Catalog Item Tests' -Fixture {

    It -Name "Return named Consumer Catalog Item $($JSON.CatalogItem.Name)" -Test {

        $CatalogItemD = Get-vRAConsumerCatalogItem -Name $JSON.CatalogItem.Name
        $CatalogItemD.Name | Should Be $JSON.CatalogItem.Name
    }

    It -Name "Return named Consumer Catalog Item Request Template $($JSON.CatalogItem.Name)" -Test {

        $CatalogItemE = Get-vRAConsumerCatalogItem -Name $JSON.CatalogItem.Name
        $CatalogItemRequestTemplateA = Get-vRAConsumerCatalogItemRequestTemplate -Name $JSON.CatalogItem.Name
        $CatalogItemRequestTemplateA | ConvertFrom-JSON | Select-Object -ExpandProperty catalogItemId | Should Be $CatalogItemE.Id
    }

    It -Name "Return named entitled Catalog Item $($JSON.CatalogItem.Name)" -Test {

        $CatalogItemF = Get-vRAConsumerEntitledCatalogItem -Name $JSON.CatalogItem.Name
        $CatalogItemF.Name | Should Be $JSON.CatalogItem.Name
    }

    It -Name "Request named Consumer Catalog Item $($JSON.CatalogItem.Name)" -Test {

        $CatalogItemF = Get-vRAConsumerCatalogItem -Name $JSON.CatalogItem.Name
        $Global:RequestA = Request-vRAConsumerCatalogItem -Id $CatalogItemF.Id -Confirm:$false
        $Global:RequestA | Should Be $true
    }

    It -Name "Return named Consumer Request for Catalog Item $($JSON.CatalogItem.Name)" -Test {

        $RequestA = Get-vRAConsumerRequest -Id $Global:RequestA.RequestId
        $RequestA.Id | Should Be $Global:RequestA.RequestId
    }

    It -Name "Return named Consumer Resource for $($JSON.CatalogItem.ConsumerResource)" -Test {

        $ConsumerResourceA = Get-vRAConsumerResource -Name $JSON.CatalogItem.ConsumerResource
        $ConsumerResourceA.Name | Should Be $JSON.CatalogItem.ConsumerResource
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false