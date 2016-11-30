# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $JSON.Connection.Password -IgnoreCertRequirements

# --- Tests
Describe -Name 'Content-Management-Service Tests' -Fixture {

    Context -Name "Content" -Fixture {

        $TestContent = Get-vRAContent | Select-Object -First 1

        It -Name "Return content" -Test {

            $Content = Get-vRAContent
            $Content.Count | Should Not Be 0

        }

        It -Name "Return content by name" -Test {

            $Content = Get-vRAContent -Name $TestContent.Name
            $Content.Name | Should Be $TestContent.Name

        }

        It -Name "Return content by Id" -Test {

            $Content = Get-vRAContent -Id $TestContent.Id
            $Content.Id | Should Be $TestContent.Id

        }

        It -Name "Return content data string" -Test {

            $ContentData = Get-vRAContent -Id $TestContent.Id | Get-vRAContentData
            $ContentData.GetType().Name | Should Be "String"

        }

        It -Name "Return content-types" -Test {

            $ContentType = Get-vRAContentType
            $ContentType.Count | Should Not Be 0

        }

        It -Name "Return content-type by name" -Test {

            $TestContentType = Get-vRAContentType | Select-Object -First 1
            $ContentType = Get-vRAContentType -Name $TestContentType.Name
            $ContentType.Name | Should Be $TestContentType.Name

        }

        It -Name "Return content-type by id" -Test {

            $TestContentType = Get-vRAContentType | Select-Object -First 1
            $ContentType = Get-vRAContentType -Id $TestContentType.Id
            $ContentType.Id | Should Be $TestContentType.Id

        }

    }

    Context -Name "Package" -Fixture {

        It -Name "Create named Content Package $($JSON.Package.Name)" -Test {

            $PackageA = New-vRAPackage -Name $JSON.Package.Name -Description $JSON.Package.Description -BlueprintName $JSON.Package.BlueprintName
            $PackageA.Name | Should Be $JSON.Package.Name
        }

        It -Name "Return named Content Package $($JSON.Package.Name)" -Test {

            $PackageB = Get-vRAPackage -Name $JSON.Package.Name
            $PackageB.Name | Should Be $JSON.Package.Name
        }

        It -Name "Export named Content Package $($JSON.Package.Name)" -Test {

            $PackageC = Export-vRAPackage -Name $JSON.Package.Name -Path $JSON.Package.Path
            $PackageC.FullName | Should Be $JSON.Package.FileName
        }

        It -Name "Remove named Content Package $($JSON.Package.Name)" -Test {

            Remove-vRAPackage -Name $JSON.Package.Name -Confirm:$false
            
            try {
            
                $PackageD = Get-vRAPackage -Name $JSON.Package.Name
            }
            catch [Exception]{

            }
            $PackageD | Should Be $null
        }

        It -Name "Test named Content Package $($JSON.Package.Name)" -Test {

            $TestStatus = Test-vRAPackage -File $JSON.Package.FileName
            $TestStatus.operationStatus | Should Be $JSON.Package.TestStatusMessage
        }

        It -Name "Import named Content Package $($JSON.Package.Name)" -Test {

            $ImportStatus = Import-vRAPackage -File $JSON.Package.FileName -Confirm:$false
            $ImportStatus.operationResults.Messages | Should Be $JSON.Package.ImportStatusMessage
        }

    }

}

# --- Cleanup
Disconnect-vRAServer -Confirm:$false