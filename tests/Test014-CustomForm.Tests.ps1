# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password -AsPlainText -Force
$Connection = Connect-vRAServer -Server $JSON.Connection.vRAAppliance -Tenant $JSON.Connection.Tenant -Username $JSON.Connection.Username -Password $ConnectionPassword -IgnoreCertRequirements

# --- Tests
Describe -Name 'Custom Forms Tests' -Fixture {

  It -Name "Get vRA Custom Form by blueprint id $($JSON.Blueprint.BlueprintId)" -Test {

      $GetCustomFormA = Get-vRACustomForm -Id $JSON.Blueprint.BlueprintId
      $GetCustomFormA.BlueprintId | Should -Be $JSON.Blueprint.BlueprintId
      $GetCustomFormA.JSON | Should -BeOfType System.String
      $GetCustomFormA.JSON | Should -BeLikeExactly '{*}'

  }

  It -Name "Get form from pipped blueprint by id $($JSON.Blueprint.BlueprintId)" -Test {

      $GetCustomFormB = Get-vRACustomForm -Id $JSON.Blueprint.BlueprintId | Get-vRACustomForm
      $GetCustomFormB.BlueprintId | Should -Be $JSON.Blueprint.BlueprintId
      $GetCustomFormB.JSON | Should -BeOfType System.String
      $GetCustomFormB.JSON | Should -BeLikeExactly '{*}'

  }

  It -Name "Enable Custom Form of blueprint by id $($JSON.Blueprint.BlueprintId)" -Test {

      $SetCustomFormA = Get-vRACustomForm -Id $JSON.Blueprint.BlueprintId | Set-vRACustomForm -Action enable -Confirm:$false
      $SetCustomFormA | Should -Be "Custom form is enabled."

  }

  It -Name "Disable Custom Form of blueprint by id $($JSON.Blueprint.BlueprintId)" -Test {

      $SetCustomFormB = Get-vRACustomForm -Id $JSON.Blueprint.BlueprintId | Set-vRACustomForm -Action disable -Confirm:$false
      $SetCustomFormB | Should -Be "Custom form is disabled."

  }

  It -Name "Remove Custom Form of blueprint by id $($JSON.Blueprint.BlueprintId)" -Test {

      $RemoveCustomFormA = Remove-vRACustomForm -Id $JSON.Blueprint.BlueprintId -Confirm:$false

      try {

          $Form = Get-vRACustomForm -BlueprintId $JSON.Blueprint.BlueprintId -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

      }
      catch {}

      $Form | Should -be

  }

  It -Name "Add Custom Form to blueprint by id $($JSON.Blueprint.BlueprintId)" -Test {

      $AddCustomFormA = Add-vRACustomForm -Id $JSON.Blueprint.BlueprintId -Body $GetCustomFormA.JSON
      $AddCustomFormA | Should -BeOfType System.Management.Automation.PSCustomObject
      $AddCustomFormA.BlueprintId | Should -Be $JSON.Blueprint.BlueprintId
      $AddCustomFormA.CustomFormId | Should -BeOfType System.String

  }


}
