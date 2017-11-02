<#
.SYNOPSIS
    Sets the target BitBucket Server
.DESCRIPTION
    All further cmdlets from Ps.BitBucket will be executed against the server-enpoint specified by this cmdlet.
.PARAMETER Url
    Mandatory - Fully qualified HTTP endpoint for the target BitBucket Server.
.EXAMPLE
    Set-BitBucketServer -Url "http://localhost:7990"
#>
function Set-BitBucketServer {
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^(https?:\/\/)([\w\.-]+)(:\d+)*\/*')]
        [string]$Url
    )
    $script:BitBucketServer = $Url
}
