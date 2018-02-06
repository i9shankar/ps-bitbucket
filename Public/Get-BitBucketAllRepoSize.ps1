<#
.SYNOPSIS
    Gets the size of all repo hosted on BitBucket.
.DESCRIPTION
   
.EXAMPLE
    Get-BitBucketAllRepoSize
#>
function Get-BitBucketAllRepoSize {
    [CmdletBinding()]param(
    )
    $Projects = Get-BitBucketProjects
    foreach ($Proj in $Projects)
    {
        Write-Output "[Info] Getting Size for Repo under project: $Proj"
        $Repos = Get-BitBucketRepoByProject -Project "$Proj"
        foreach ($Repo in $Repos)
        {
            $Manifest = Invoke-BitBucketWebRequest  -Resource "projects/${Proj}/repos/$Repo/sizes" -APIUrl "$script:BitBucketServer" -APIVersion "" | ConvertFrom-Json
            [int]$intNum = [convert]::ToInt32($Manifest.repository)
            [int]$InKB = ${intNum}/1024
            write-output "${Repo}:${InKB}"
        }        
    }
}
