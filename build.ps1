[cmdletbinding()]
param(
  [string[]]$Task = 'default' # This task is defined in psakeBuild. We are just setting a default here.
)

if((Get-PackageProvider -Name NuGet).Version -le 2.8.5.201) { Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201  -Scope CurrentUser -Force }
if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester -Scope CurrentUser -Force }
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake -Scope CurrentUser -Force }
if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force }

# Verify that we have PackageManagement module installed
if(!(Get-Command Install-Module)) {
  throw 'PackageManagement is not installed. You need V5 or https://www.microsoft.com/en-us/download/details.aspx?id=51451'
}

# Verify that our testing utilities are installed.
if (!(Get-Module -Name Pester -ListAvailable)) {
  Install-Module -Name Pester 
}
if (!(Get-Module -Name psake -ListAvailable)) {
  Install-Module -Name Psake 
}
if (!(Get-Module -Name PSDeploy -ListAvailable)) {
  Install-Module -Name PSDeploy 
}
if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) {
  Install-Module -Name PSScriptAnalyzer 
}

# Run our test
Invoke-psake -buildFile "$PSScriptRoot\psakeBuild.ps1" -taskList $Task -Verbose:$VerbosePreference
