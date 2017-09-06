param (
	$outputDirectory = (property outputDirectory "artifacts"),
	$configuration = (property configuration "Release")
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

Task Compile {
	use "15.0" MSBuild
	$projects |
		ForEach-Object {

			if ($_.IsWebProject)
			{
				$webOutputDir = "$absoluteOutputDirectory\$($_.Name)"
				$binOutputDir = "$absoluteOutputDirectory\$($_.Name)\bin"

				Write-Host "Compiling $($_.Name) to $webOutputDir"

				exec { MSBuild $($_.Path) /p:Configuration=$configuration /p:OutDir=$binOutputDir /p:WebProjectOutputDir=$webOutputDir `
					/nologo /p:DebugType=None /p:Platform=AnyCpu /verbosity:quiet }
			}
			else
			{
				$outputDir = "$absoluteOutputDirectory\$($_.Name)"
				
				Write-Host "Compiling $($_.Name) to $outputDir"

				exec { MSBuild $($_.Path) /p:Configuration=$configuration /p:OutDir=$outputDir `
					/nologo /p:DebugType=None /p:Platform=AnyCpu /verbosity:quiet }
			}
		}
}