# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password-AsPlainText -Force
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements

# --- Tests
Describe -Name 'Catalog-Service Tests' -Fixture {

    Context -Name 'CatalogItem' -Fixture {

        $CatalogItemName = $JSON.CatalogService.CatalogItem.Name

        It -Name "Return named Catalog Item" -Test {

            $CatalogItem = Get-vRACatalogItem -Name $CatalogItemName
            $CatalogItem.Name | Should Be $CatalogItemName

        }

        It -Name "Return named entitled Catalog Item" -Test {

            $CatalogItem = Get-vRAEntitledCatalogItem -Name $CatalogItemName
            $CatalogItem.Name | Should Be $CatalogItemName

        }

        It -Name "Return named Catlaog Item request template" -Test {

            $CatalogItemRequestTemplate = Get-vRACatalogItemRequestTemplate -Name $CatalogItemName
            $CatalogItemRequestTemplate.getType().Name | Should Be "String"

        }

        It -Name "Update named Catalog Item" -Test {

            $Quota = Get-Random -Minimum 10 -Maximum 51
            $CatalogItem = Get-vRACatalogItem -Name $CatalogItemName | Set-vRACatalogItem -Quota $Quota -Confirm:$false
            $CatalogItem.Quota | Should Be $Quota

        }

    }

    Context -Name "Request" -Fixture {

        It -Name "Return a page of request" -Test {

            $Requests = Get-vRARequest -Limit 20 -Page 1
            $Requests.Count | Should be 20

        }
        
        It -Name "Return requests requested for a user" -Test {

            $RequestedFor = (Get-vRARequest -Limit 1).RequestedFor
            $Requests = Get-vRARequest -RequestedFor $RequestedFor
            $Requests.Count | Should BeGreaterThan 0
        }

        It -Name "Return requests requested by a user" -Test {

            $RequestedBy = (Get-vRARequest -Limit 1).RequestedBy
            $Requests = Get-vRARequest -RequestedBy $RequestedBy
            $Requests.Count | Should BeGreaterThan 0

        }

        It -Name "Return request by Id" -Test {

            $RequestId = (Get-vRARequest -Limit 1).Id
            $Request = Get-vRARequest -Id $RequestId
            $Request.Id | Should Be $RequestId

        }

        It -Name "Return request by request number" -Test {

            $RequestNumber = (Get-vRARequest -Limit 1).RequestNumber
            $Request = Get-vRARequest -RequestNumber $RequestNumber
            $Request.RequestNumber | Should Be $RequestNumber

        }

    }

    Context -Name "Catalog Principal" -Fixture {

        It -Name "Return named Catalog Principal" -Test {

            $UserPrincipalId = (Get-vRAUserPrincipal).PrincipalId
            $CatalogPrincipal = Get-vRACatalogPrincipal -Id $UserPrincipalId
            $CatalogPrincipal.ref | Should Be $UserPrincipalId

        }

    }

    Context -Name "Service" -Fixture {

        # --- Set Service Name
        $ServiceName = "Test Service - $(Get-Random -Maximum 20)"

        It -Name "Create named Service" -Test {

            $Service = New-vRAService -Name $ServiceName -Description "Test Description"
            $Service.Name | Should Be $ServiceName

        }

        It -Name "Return named Service" -Test {

            $Service = Get-vRAService -Name $ServiceName
            $Service.Name | Should Be $ServiceName

        }

        It -name "Return named Entitled Service" -Test {

            $EntitledService = Get-vRAEntitledService -Limit 1 -ErrorAction SilentlyContinue
            $EntitledService | Should Not Be $null

        }        

        It -Name "Update named Service" -Test {
            
            $Service = Get-vRAService -Name $ServiceName
            $UpdatedServiceDescription = "$($Service.Description) Updated"
            $Service = Set-vRAService -Id $Service.Id -Description $UpdatedServiceDescription -Confirm:$false
            $Service.Description | Should Be $UpdatedServiceDescription

        }

        It -Name "Remove named Service" -Test {

            Get-vRAService -Name $ServiceName | Remove-vRAService -Confirm:$false

            try {

                $Service = Get-vRAService -Name $ServiceName -ErrorAction SilentlyContinue

            }
            catch {}

            $Service | Should Be $null

        }

    }

    Context -Name "Entitlement" -Fixture {

        # --- Set Entitlement Name
        $EntitlementName = "Test Entitlement - $(Get-Random -Maximum 20)"

        It -Name "Create named Entitlement" -Test {
            
            $BusinessGroup = Get-vRABusinessGroup -Limit 1
            $BusinessUser = $BusinessGroup.UserRole | Select -First 1
            $UserPrincipal = "$($BusinessUser.name)@$($BusinessUser.domain)"
            $Entitlement = New-vRAEntitlement -Name $EntitlementName -Description "Test Description" -BusinessGroup $BusinessGroup.Name -Principals $UserPrincipal
            $Entitlement.Name | Should Be $EntitlementName

        }

        It -Name "Return named Entitlement" -Test {

            $Entitlement = Get-vRAEntitlement -Name $EntitlementName
            $Entitlement.Name | Should Be $EntitlementName

        }

        It -Name "Update named Entitlement" -Test {

            $Entitlement = Get-vRAEntitlement -Name $EntitlementName
            $UpdatedEntitlementDescription = "$($Entitlement.Description) Updated"
            $Entitlement = Set-vRAEntitlement -Id $Entitlement.Id -Description $UpdatedEntitlementDescription -Confirm:$false
            $Entitlement.Description | Should Be $UpdatedEntitlementDescription

        }

    }    
    
    Context -Name "Resource Action" -Fixture {

        It -Name "Return available Resource Actions for a Resource" -Test {

            $ResourceActions = Get-vRAResource -Type Machine -Limit 1 | Get-vRAResourceAction
            $ResourceActions.Count | Should Not Be 0
        }

        It -Name "Return available Resource Actions and Resouce Extensions" -Test {

            $ResourceOperations = Get-vRAResourceOperation
            $ResourceOperations.Count | Should Not Be 0

        }

        It -Name "Return Resource Operation by id" -Test {

            $ResourceOperationId = (Get-vRAResourceOperation -Limit 1).Id
            $ResourceOperation = Get-vRAResourceOperation -Id $ResourceOperationId
            $ResourceOperation.Id | Should Be $ResourceOperationId

        }
    
        It -Name "Return Resource Operation by external id" -Test {

            $ResourceOperationExternalId = (Get-vRAResourceOperation -Limit 1).ExternalId
            $ResourceOperation = Get-vRAResourceOperation -ExternalId $ResourceOperationExternalId
            $ResourceOperation.ExternalId | Should Be $ResourceOperationExternalId

        }

    }

    Context -Name "Resource Type" -Fixture {

        It -Name "Return available Resource Types" -Test {

            $ResourceTypes = Get-vRAResourceType
            $ResourceTypes.Count | Should Not Be $null

        }

        It -Name "Return Resource Type by id" -Test {

            $ResourceTypeId = (Get-vRAResourceType -Limit 1).Id
            $ResourceType = Get-vRAResourceType -Id $ResourceTypeId
            $ResourceType.Id | Should Be $ResourceTypeId

        }

        It -Name "Return Resource Type by name" -Test {

            $ResourceTypeName = (Get-vRAResourceType -Limit 1).Name
            $ResourceType = Get-vRAResourceType -Name $ResourceTypeName
            $ResourceType.Name | Should Be $ResourceTypeName

        }

    }

    Context -Name "Service Icons" -Fixture {

        It -Name "Create named Service Icon $($JSON.CatalogService.ServiceIcon.Id)" -Test {

            $ServiceIconA = Import-vRAServiceIcon -Id $JSON.CatalogService.ServiceIcon.Id -File $JSON.CatalogService.ServiceIcon.ImportFile -Confirm:$false
            $ServiceIconA.Id | Should Be $JSON.CatalogService.ServiceIcon.Id
        }

        It -Name "Return named Service Icon $($JSON.CatalogService.ServiceIcon.Id)" -Test {

            $ServiceIconB = Get-vRAServiceIcon -Id $JSON.CatalogService.ServiceIcon.Id
            $ServiceIconB.Id | Should Be $JSON.CatalogService.ServiceIcon.Id
        }

        It -Name "Export named Service Icon $($JSON.CatalogService.ServiceIcon.Id)" -Test {

            $ServiceIconC = Export-vRAServiceIcon -Id $JSON.CatalogService.ServiceIcon.Id -File $JSON.CatalogService.ServiceIcon.ExportFile
            $ServiceIconC.FullName | Should Be $JSON.CatalogService.ServiceIcon.ExportFile
        }

        It -Name "Remove named Service Icon $($JSON.CatalogService.ServiceIcon.Id)" -Test {

            Remove-vRAServiceIcon -Id $JSON.CatalogService.ServiceIcon.Id -Confirm:$false

            try {
                $ServiceIconD = Get-vRAServiceIcon -Id $JSON.CatalogService.ServiceIcon.Id
            }
            catch [Exception]{

            }
            $ServiceIconD | Should Be $null
        }
    }
}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false