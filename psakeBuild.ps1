Properties {
    [string]${workingDirectory} = $PSScriptRoot
     [double]$CoverageTheshold = 0
    [string]$ModuleName = "PS.BitBucket"
    [string]$script = "$PSScriptRoot\PS.BitBucket.psm1"
}

# Default task includes Analyzing and Testing of script
task default -depends Analyze, Test

# Analyze by running Invoke-ScriptAnalyzer. Check script against best known practices
task Analyze {
  $saResults = Invoke-ScriptAnalyzer -Path $script -Severity @('Error', 'Warning') -Recurse -Verbose:$false
  if ($saResults) {
    $saResults | Format-Table
    Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'
  }
}

# Run our test to make sure everything is in line
task Test -depends Analyze {
  $testResults = Invoke-Pester -Path $PSScriptRoot -PassThru
  if ($testResults.FailedCount -gt 0) {
    $testResults | Format-List
    Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
  }
}

Task Package -depends Test -precondition { return (${UnstableBranches}.Contains( $BranchName.ToLower())) } {
    try{
        if(!$(Test-Path ${workingDirectory}\bin\)) { mkdir ${workingDirectory}\bin }
        $zipFileName = Join-Path ${workingDirectory}\bin\ "${ModuleName}.zip"
        $zipFileContent = (Get-ChildItem -Path ${workingDirectory}* -Exclude *Test*, *psake*, build.*, *bin* ).FullName
        Compress-Archive -Path $zipFileContent -DestinationPath $zipFileName -Force -Verbose
    }
    catch{
        Write-Error  $_.Exception.Message
    }
}

Task Deploy -depends Package -precondition { return  (${UnstableBranches}.Contains( $BranchName.ToLower())) } {
  try{
        $version = Get-ManifestVersion "$ModuleName.psd1"
        $zipFileName = Join-Path ${workingDirectory}\bin\ "${ModuleName}.zip"
        $target = "$HOME\Documents\WindowsPowerShell\Modules\${ModuleName}"
        if(Test-Path $target){
            Write-Output "Cleaning current module deployment...."
            Remove-Item $target -Force -Recurse
        }
       Expand-Archive -Path $zipFileName -DestinationPath $target
        Write-Output "Importing Module......."
        Import-Module -Name $ModuleName -Verbose -Force
    }
    catch{
        Write-Error  $_.Exception.Message
    }
}

#Helper functions will be migrated to a separate module and installed as dependency for builds

function Get-ManifestVersion {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName="True", Position=0)]
        [Alias("PSPath")]
        [string]$Manifest
    )
    $ErrorActionPreference = "Stop"

    $ManifestVersion = (Test-ModuleManifest $Manifest).Version.ToString()
    $ManifestVersion
}