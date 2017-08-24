cls

. .\functions.ps1

# identify latest version of invoke-build package by enumerating using wildcard query, and extract latest version full name (ie path)
$invokeBuild = (Get-ChildItem('.\packages\Invoke-Build*\tools\Invoke-Build.ps1')).FullName | Sort-Object $_ | Select -Last 1

# call latest invoke build passing through arguments given to this script, followed by the tasks script to be used for build action
& $invokeBuild $args tasks.ps1