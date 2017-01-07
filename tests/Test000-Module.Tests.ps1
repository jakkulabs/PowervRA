# --- Tests
Describe -Name 'Module Tests' -Fixture {

    It -Name "Attempting to import the PowervRA Module" -Test {

        $Module = Import-Module -Name PowervRA -PassThru | Where-Object {$_.Name -eq 'PowervRA'}
        $Module.Name | Should be "PowervRA"
    }
}