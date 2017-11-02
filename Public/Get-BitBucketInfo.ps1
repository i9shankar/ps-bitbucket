<#
.SYNOPSIS
    Gets the current BitBucket Server information and version Detail.
.DESCRIPTION
    The cmdlet simply returns the

.EXAMPLE
    Get-BitBucketInfo
    [Info:] Version: 4.3.2, Build Number: 4003002, DisplayName: Bitbucket
#>
function Get-BitBucketInfo {
    [CmdletBinding()]param()

    $Manifest = Invoke-BitBucketWebRequest -Resource 'application-properties' | ConvertFrom-Json
    Write-Output "[Info:] Version: $($Manifest.version), Build Number: $($Manifest.buildNumber), DisplayName: $($Manifest.displayName)"
}
