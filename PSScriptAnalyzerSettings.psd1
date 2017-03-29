@{
    ExcludeRules=@(
        "PSAvoidUsingUserNameAndPassWordParams",
        "PSAvoidGlobalVars"
    )
    
    Severity=@(
        "Warning",
        "Error"
    )

    #Rules = @{
    #    Check if your script uses cmdlets that are compatible on PowerShell Core,
    #    version 6.0.0-alpha, on Linux.
    #    PSUseCompatibleCmdlets = @{Compatibility = @("core-6.0.0-alpha-linux")}
    #}

}