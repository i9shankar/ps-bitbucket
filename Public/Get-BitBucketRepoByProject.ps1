<#
.SYNOPSIS
    Gets the list of repos under given project.
.DESCRIPTION
   
.EXAMPLE
    Get-BitBucketRepoByProject -Project "TES"
#>
function Get-BitBucketRepoByProject {
    [CmdletBinding()]param(
        [Parameter(Mandatory=$true,ParameterSetName='Project')]
        [ValidateNotNullOrEmpty()]
        [string]$Project
    )

    $Manifest = Invoke-BitBucketWebRequest -Resource "projects/$Project/repos?limit=1000" | ConvertFrom-Json
    #Write-Output "[List:] Repos under project - $Project"
    return $Manifest.values.name
}
