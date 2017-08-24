param (
	$outputDirectory = (property outputDirectory "artifacts")
)

$absoluteOutputDirectory = "$((Get-Location).Path)\$outputDirectory"
$projects = Get-SolutionProjects

Task Clean {

	# delete artifacts folder and content if exists
	if (Test-Path $absoluteOutputDirectory)
	{
		Write-Host "Cleaning artifacts directory $absoluteOutputDirectory"
		Remove-Item "$absoluteOutputDirectory" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
	}

	# create new artifacts folder
	New-Item $absoluteOutputDirectory -ItemType Directory | Out-Null

	# clean existing bin and obj folders for all projects
	$projects |
		ForEach-Object {
			Write-Host "Cleaning bin and obj folders for $($_.Directory)"
			Remove-Item "$($_.Directory)\bin" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
			Remove-Item "$($_.Directory)\obj" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
		}
}

Task init {
	Write-Host "Hello, world!"
}

Task init2 {
	Write-Host "Hello, again"
}