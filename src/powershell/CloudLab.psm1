# Import private and public scripts and expose the public ones
$privateScripts = @(Get-ChildItem -Path "$PSScriptRoot\private" -Recurse -Filter "*.ps1")
$publicScripts = @(Get-ChildItem -Path "$PSScriptRoot\public" -Recurse -Filter "*.ps1")

foreach ($script in ($privateScripts + $publicScripts)) {
	try {
		. $script.FullName
	} catch {
		Write-Error -Message ("Failed to import function {0}: {1}" -f $script, $_)
	}
}