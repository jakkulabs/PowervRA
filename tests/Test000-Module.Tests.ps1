# --- Tests
Describe -Name 'Module Tests' -Fixture {

    It -Name "Attempting to import the PowervRA Module" -Test {

        $Module = Import-Module -Name PowervRA -PassThru | Where-Object {$_.Name -eq 'PowervRA'}
        $Module.Name | Should be "PowervRA"
    }

    It -Name "Checking xRequires Private Function exists" -Test {

        try {
        
            xRequires -Version 7 -Context $MyInvocation
        }
        catch {

        }
        $Error[0].Exception | Should be "System.Management.Automation.RuntimeException: vRA Connection variable does not exist. Please run Connect-vRAServer first to create it"
    }
}
