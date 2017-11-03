<#
.SYNOPSIS
    Set develop/master branch permission by default as attached screen shot and described in branchpermission.json file
.DESCRIPTION

.PARAMETER project
    Mandatory - project id
.PARAMETER Repository
    Mandatory - Repository name
.PARAMETER BranchPermissionJson
    Optional - BranchPermissionJson custom file path     
.EXAMPLE
    Set-BranchPermission -Project "TES" -Repository "ABC"
.EXAMPLE
    Set-BranchPermission -Project "TES" -Repository "ABC"  -BranchPermissionJson "C:\Abc\permission.json"
#>
function Set-BranchPermission {
    [CmdletBinding()]param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$BranchPermissionJson = "$PSScriptRoot\BranchPermission.Json"

    )
    try
    {
        $Json = Get-Content $BranchPermissionJson
        Invoke-BitBucketWebRequest -APIUrl "$Script:BitBucketServer/rest/branch-permissions" -ApiVersion "2.0" -Resource "projects/${Project}/repos/${Repository}/restrictions" -Method Post -ContentType "application/vnd.atl.bitbucket.bulk+json" -Body $Json
        $Manifest = Invoke-BitBucketWebRequest -APIUrl "$Script:BitBucketServer/rest/branch-permissions" -ApiVersion "2.0" -Resource "projects/${Project}/repos/${Repository}/restrictions" | ConvertFrom-Json
        Write-Output "[Info] Current permission:" $Manifest.values
    }
    catch [System.Exception] 
    {
        Write-Output "[Return Message:] $Manifest"
        Throw $_.Exception.Message;
    }
    finally
    {
       #Set-Location  $PSScriptRoot;
    }
}
