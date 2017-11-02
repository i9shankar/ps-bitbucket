<#
.SYNOPSIS
    Gets the size of all repos under given project.
.DESCRIPTION
   
.EXAMPLE
    Get-BitBucketRepoSizeByProject -Project "TES"
#>
function Get-BitBucketRepoSizeByProject {
    [CmdletBinding()]param(
        [Parameter(Mandatory=$true,ParameterSetName='Project')]
        [ValidateNotNullOrEmpty()]
        [string]$Project
    )
    $Repos = Get-BitBucketRepoByProject -Project "$Project"
    foreach ($Repo in $Repos)
    {
        $Manifest = Invoke-BitBucketWebRequest  -Resource "/projects/${Project}/repos/$Repo/sizes" -APIUrl "$script:BitBucketServer" | ConvertFrom-Json
        [int]$intNum = [convert]::ToInt32($Manifest.repository)
        [int]$InKB = ${intNum}/1024
        write-host "${Repo}:${InKB}"
    }

}
