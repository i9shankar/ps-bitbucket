<#
.SYNOPSIS
    Set given branch as default branch
.DESCRIPTION

.PARAMETER project
    Mandatory - project id
.PARAMETER Repository
    Mandatory - Repository name
.PARAMETER Branch
    Optional - Branch name to set as default, develop is marked as default if no branch name passed.      
.EXAMPLE
    Set-DefaultBranch -Project "TES" -Repository "ABC"
.EXAMPLE
    Set-DefaultBranch -Project "TES" -Repository "ABC" -Branch "master"
#>
function Set-DefaultBranch {
    [CmdletBinding()]param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository,
         [Parameter(Mandatory=$false)]
         [ValidateNotNullOrEmpty()]
        [string]$Branch = "develop"
    )
    try
    {
        # Check if .gitignore file exist
        if ([string]::IsNullOrEmpty($Branch))
        {
           Write-Output "[Error:] Branch name is empty"
            Break;
        }
 
        $DefaultBranch = @{
            id = "refs/heads/$Branch"
        } | ConvertTo-Json
        
        Invoke-BitBucketWebRequest -Resource "projects/${Project}/repos/${Repository}/branches/default" -Method Put -Body $DefaultBranch
        $Manifest = Invoke-BitBucketWebRequest -Resource "projects/${Project}/repos/${Repository}/branches/default" | ConvertFrom-Json
        if ($Manifest.displayId -eq "$Branch")
        {
            Write-Output "[Info] $Branch set to default"
        }
        else {
            Write-Output "[Error] failed to set $Branch to default"
            Break;
        }
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
