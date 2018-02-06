##############################
#.SYNOPSIS
#Create new branch
#
#.DESCRIPTION
#create a new branch on bitbucket from given source branch
#
#.PARAMETER Project
#Project ID
#
#.PARAMETER Repository
#Repository Name
#
#.PARAMETER SourceBranch
#source branch (one which exist already)
#
#.PARAMETER NewBranch
#New branch (To be created)
#s
#.EXAMPLE
#New-CreateBranch -Project "TES" -Repository "TEST1" -SourceBranch "refs/heads/develop" -NewBranch "release/1.0"
#
#.NOTES
#General notes
##############################
function New-CreateBranch {
    [CmdletBinding()]param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Project,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceBranch,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$NewBranch
    )
    try
    {
        $NewBranchBody = @{
            name    = $NewBranch
            startPoint  = $SourceBranch
        } | ConvertTo-Json     

        Write-Verbose -Message "JsonBody - $NewBranchBody"
        Invoke-BitBucketWebRequest -Resource "projects/${Project}/repos/${Repository}/branches" -Method Post -Body $NewBranchBody
    }
    catch [System.Exception] 
    {
        Write-Output "[Return Message:] $Manifest"
        Throw $_.Exception.Message;
    }
    finally
    {
    }
}
