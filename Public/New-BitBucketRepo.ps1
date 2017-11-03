<#
.SYNOPSIS
    Create new repository under given project
.DESCRIPTION

.PARAMETER Project
    Mandatory - Bitbucket Project ID
.PARAMETER Repository
    Mandatory - New Repository name to be created
Note: all below command work if -WithGitFlowBranch is passed to True.
.PARAMETER WithGitFlowBranch
    Optional - Switch if repo to have develop/master branch with GitIgnore file - Default set to false
.PARAMETER GitIgnoreFileLoc
    Optional - if WithGitFlowBranch is set to true, then make sure you have a git ignore file at C:\Temp\.gitignore or 
    pass the different location with -GitIgnoreFileLoc
.PARAMETER ForkEnabled
    Optional - This is to set repository with fork enabled (true/false). default set to false
.PARAMETER SetDefaultBranch
    Optional - bydefault Master branch is set to default, to change default branch as develop, pass -SetDefaultBranch
.PARAMETER SetBranchPermission
    Optional - Set Master/Develop branch permission as attached screenshot
    to change the permission level/pattern/branch, have your own json file with permission leverl set similar to one available at Public\BranchPermission.json
    Pass the json file path with param -BranchPermissionJson <FileName>
.PARAMETER BranchPermissionJson
    Optional - BranchPermissionJson custom file path         
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
        [string]$Repository,
        [Parameter(Mandatory=$false)]
        [switch]$WithGitFlowBranch = $false,
        [Parameter(Mandatory=$false)]
        [string]$GitIgnoreFileLoc= "C:\Temp\.gitignore",
        [Parameter(Mandatory=$false)]
        [string]$RepoLocalPath= "C:\Git",
        [Parameter(Mandatory=$false)]
        [string]$ForkEnabled= "false",
        [Parameter(Mandatory=$false)]
        [switch]$SetDefaultBranch= $false,
        [Parameter(Mandatory=$false)]
        [switch]$SetBranchPermission= $false,
        [Parameter(Mandatory=$false)]
        [string]$BranchPermissionJson = "$PSScriptRoot\BranchPermission.Json"
    )
    try
    {
        # Check if .gitignore file exist
        if ($WithGitFlowBranch)
        {
            if ([string]::IsNullOrEmpty($script:UserFullName))
            {
                Write-Output "[Error:] Username wasnt set, use Set-UserFullNameAndEmail cmdlet to set it"
                Break;
            }
            if ([string]::IsNullOrEmpty($script:UserEmailAddress))
            {
                Break;
            }
            if (Test-Path $GitIgnoreFileLoc)
            {
                Write-Output "[Info:] Using .gitignore from $GitIgnoreFileLoc"
            }
            else {
                Write-Output "[Error] $GitIgnoreFileLoc file doesn't exist, either create a file at given location or pass different loc with -GitIgnoreFileLoc <filefullpath> "
                Write-Output "WithGitFlowBranch expect a default .gitignore file to add in both branch (master/develop)."
                Break;
            }
        }
        if (-Not (Test-Path $RepoLocalPath))
        {
            New-Item $RepoLocalPath -Type Directory
        }
        if (-Not (Test-Path $RepoLocalPath\$Repository))
        {
            New-Item $RepoLocalPath\$Repository -Type Directory
        }        

        $JsonBody = @{
            name        = $Repository 
            scmId       = 'git'
            forkable    = $ForkEnabled
        } | ConvertTo-Json

        $Manifest = Invoke-BitBucketWebRequest -Resource "projects/$Project/repos" -Method Post -Body $JsonBody #| ConvertFrom-Json
        $Manifest1 = $Manifest | ConvertFrom-Json
        #$Status = $Manifest1.State
        if ($Manifest1.State -eq "AVAILABLE")
        {
            Write-Output "[Creation][Successful] URL: $script:BitBucketServer/projects/${Project}/repos/${Repository}/browse"
            if (($WithGitFlowBranch) -and (Test-Path $GitIgnoreFileLoc))
            {
                Set-Location $RepoLocalPath\$Repository
                Copy-Item $GitIgnoreFileLoc .
                git config --global user.name "$script:UserFullName"
                git config --global user.email "$script:UserEmailAddress"
                git init
                git add .gitignore
                git commit -m "Add .gitignore file"
                git remote add origin $script:BitBucketServer/scm/$Project/$Repository.git
                git config credential.helper store
                git branch develop
                git push -u origin --all

                if ($SetDefaultBranch)
                {
                    Set-DefaultBranch -Project "$Project" -Repository "$Repository"
                }
                if ($SetBranchPermission)
                {
                    Set-BranchPermission -Project "$Project" -Repository "$Repository" -BranchPermissionJson "$BranchPermissionJson"
                }
            }
            else{
                #Write-Output "[Creation][Successful]"
            }
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
       #Set-Location  $PSScriptRoot;
    }
}
