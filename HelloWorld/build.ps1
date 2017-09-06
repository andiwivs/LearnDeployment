cls

$nugetPath = "$env:LOCALAPPDATA\NuGet\NuGet.exe"

# if nuget not found, download to expected location
if (!(Get-Command NuGet -ErrorAction SilentlyContinue) -and !(Test-Path $nugetPath)) {
	Write-Host "Downloading NuGet.exe to $nugetPath"
	(New-Object System.Net.WebClient).DownloadFile("https://dist.nuget.org/win-x86-commandline/latest/nuget.exe", $nugetPath)
}

# restore packages
if (Test-Path $nugetPath) {
	Set-Alias NuGet (Resolve-Path $nugetPath)
}

Write-Host "Restoring NuGet packages"
NuGet restore

. .\functions.ps1

# identify latest version of invoke-build package by enumerating using wildcard query, and extract latest version full name (ie path)
$invokeBuild = (Get-ChildItem('.\packages\Invoke-Build*\tools\Invoke-Build.ps1')).FullName | Sort-Object $_ | Select -Last 1

# call latest invoke build passing through arguments given to this script, followed by the tasks script to be used for build action
& $invokeBuild $args tasks.ps1