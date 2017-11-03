<#
.SYNOPSIS
    Returns the currently used BitBucket Server URL.
.DESCRIPTION
    This cmdlet is a simple getter function for Set-BitBucketServer cmdlet.
.EXAMPLE
    Get-BitBucketServer
#>
function Get-BitBucketServer {
    $ServerURL = $script:BitBucketServer
    write-output "[BitBucket Host:] $ServerURL"
}
