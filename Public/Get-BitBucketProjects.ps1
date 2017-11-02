<#
.SYNOPSIS
    Gets the list of projects.
.DESCRIPTION
   
.EXAMPLE
    Get-BitBucketProjects
#>
function Get-BitBucketProjects {
    [CmdletBinding()]param()
try{
    $Manifest = Invoke-BitBucketWebRequest -Resource "projects?limit=1000" | ConvertFrom-Json
  
    }catch {
        if ($_.ErrorDetails) {
            Write-Error $_.ErrorDetails.Message
        } else {
            Write-Error $_
        }
    }
    return $Manifest.values.key
}
