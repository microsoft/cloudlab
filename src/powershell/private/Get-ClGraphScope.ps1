<#
 .Synopsis
    Returns the list of Graph scopes required to run CloudLab.

 .Description
    Use this cmdlet to connect to Microsoft Graph using Connect-MgGraph.

    This command is completely optional if you are already connected to Microsoft Graph and other services using Connect-MgGraph with the required scopes.

 .Example
    Connect-MgGraph -Scopes (Get-ClGraphScope)

    Connects to Microsoft Graph with the required scopes to run CloudLab.
#>

Function Get-ClGraphScope {

    [CmdletBinding()]
    param()

    # Any changes made to these permission scopes should be reflected in the documentation.
    # /website/docs/sections/permissions.md

    # Default read-only scopes required for the assessment.
    $scopes = @( #IMPORTANT: Read note above before adding any new scopes.
        'Directory.ReadWrite.All'
    )

    return $scopes | Sort-Object -Unique
}
