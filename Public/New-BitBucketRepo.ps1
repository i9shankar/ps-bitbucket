<#
.SYNOPSIS
    Create new repository under given project
.DESCRIPTION
   
.EXAMPLE
    New-BitBucketRepo -Project "TES" -Repository "ABC"
#>
function New-BitBucketRepo {
    [CmdletBinding()]param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository
    )
    try
    {
        $JsonBody = @{
            name        = $Repository 
            scmId       = 'git'
            forkable    = 'false'
        } | ConvertTo-Json

        $Manifest = Invoke-BitBucketWebRequest -Resource "projects/$Project/repos/" -Method Post -Body $JsonBody #| ConvertFrom-Json
        $Manifest1 = $Manifest | ConvertFrom-Json
        #$Status = $Manifest1.State
        if ($Manifest1.State -eq "AVAILABLE")
        {
            Write-Output "[Creation][Successful] URL: $script:BitBucketServer/projects/${Project}/repos/${Repository}/browse"
        }
        else {
            Write-Output "[Creation][Failed]"
        }
    }
    catch [System.Exception] 
    {
        Write-Output "[Return Message:] $Manifest"
        Throw $_.Exception.Message;
    }
    finally
    {
        Set-Location  $PSScriptRoot;
    }
}
