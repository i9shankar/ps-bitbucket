Import-Module $PSScriptRoot\PS.BitBucket.psm1 -force
Set-BitBucketServer -Url "http://localhost:7990"
Set-BitBucketCredential -Credential admin
Get-BitBucketServer
Get-BitBucketInfo
Get-BitBucketProjects
Get-BitBucketRepoByProject -Project "TES"
Get-BitBucketAllRepo
Get-BitBucketRepoSizeByProject -Project "TES"
Get-BitBucketAllRepoSize
New-BitBucketRepo -Project "TES" -Repository "ABC4"