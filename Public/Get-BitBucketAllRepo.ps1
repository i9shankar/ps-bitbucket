<#
.SYNOPSIS
    Gets the list of all repo hosted on BitBucket.
.DESCRIPTION
   
.EXAMPLE
    Get-BitBucketAllRepo
#>
function Get-BitBucketAllRepo {
    [CmdletBinding()]param()

    $Projects = Get-BitBucketProjects    
    foreach ($Proj in $Projects)
    {
        Get-BitBucketRepoByProject -Project "$Proj"
    }
}

