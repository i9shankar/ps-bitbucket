Import-Module $PSScriptRoot\PS.BitBucket.psm1 -force
Set-BitBucketServer -Url "http://localhost:7990"
Set-BitBucketCredential -Credential admin
Get-BitBucketServer
#Get-BitBucketInfo
#Get-BitBucketProjects
#Get-BitBucketRepoByProject -Project "TES1"
#Get-BitBucketAllRepo
#Get-BitBucketRepoSizeByProject -Project "TES1"
#Get-BitBucketAllRepoSize
Set-UserFullNameAndEmail -FullName "admin" -EmailId "itsmeshankar1@gmail.com"
#New-BitBucketRepo -Project "TES1" -Repository "Hello2"
#New-BitBucketRepo -Project "TES1" -Repository "Hello2" -WithGitFlowBranch
#New-BitBucketRepo -Project "TES1" -Repository "Hello3" -WithGitFlowBranch -SetDefaultBranch 
#New-BitBucketRepo -Project "TES1" -Repository "Hello4" -WithGitFlowBranch -SetDefaultBranch -SetBranchPermission
#New-BitBucketRepo -Project "TES1" -Repository "Hello8" -WithGitFlowBranch -SetDefaultBranch -GitIgnoreFileLoc "D:\Git\deployment.aws.application\.gitignore" -SetBranchPermission
#New-BitBucketRepo -Project "TES1" -Repository "Hello6" -WithGitFlowBranch -SetDefaultBranch -BranchPermissionJson "" -SetBranchPermission
#Set-DefaultBranch -Project "TES1" -Repository "Hello8" -Branch "develop"
Set-BranchPermission -Project "TES1" -Repository "Hello3"

Set-Location  $PSScriptRoot;