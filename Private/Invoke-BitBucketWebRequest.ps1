<#
.SYNOPSIS
    Generic helper cmdlet to invoke Rest methods agains a target BitBucket server.
.DESCRIPTION
    This cmdlet extends the original Invoke-WebRequest cmdlet with BitBucket REST
    API specific parameters, so it does user authorization and provides easier resource access.
.PARAMETER Resource
    Mandatory - BitBucket REST API Resource that needs to be accessed
.PARAMETER Method
    Optional - REST method to be used for the call. (Default is GET)
.PARAMETER ApiVersion
    Optional - REST API version that needs to be targeted for the call. Default is the latest.
.PARAMETER AuthenticationToken
    Optional - Authentication Token to access BitBucket Server
.PARAMETER Body
    Optional - HTTP Body json

.EXAMPLE
    Invoke-BitBucketWebRequest -Resource "projects"
.EXAMPLE
    Invoke-BitBucketWebRequest -Resource "porjects" -Method Get
#>
function Invoke-BitBucketWebRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Resource,

        [ValidateSet('Get','Put','Post','Delete')]
        [string]$Method = 'Get',

        [string]$ApiVersion='latest',
        [string]$Server = $script:BitBucketServer,
        [string]$APIUrl="$Server/rest/api/$ApiVersion",
        [string]$BranchApiVersion='2.0',
        [string]$BranchPermissionApiUri="$Server/rest/branch-permissions/$BranchApiVersion/$Resource",        
        [string]$AuthenticationToken = $script:AuthenticationToken,
        [string]$ContentType='application/json',
        [psobject]$Headers=@{},
        [psobject]$Body
    )
    [string]$ResourceUrl="$APIUrl/$Resource"
    write-host "[Info:] URI: $ResourceUrl, Method: $Method, AuthToken: $AuthenticationToken"
    $Headers.Authorization = "Basic $AuthenticationToken"
    $WebRequestResponse = $null

    try {
        if ($Method -eq "Get")
        {
            $WebRequestResponse = Invoke-WebRequest -Uri "$ResourceUrl" -Method $Method -Headers $Headers -UseBasicParsing  #-ContentType $ContentType
        }
        else {
            if (-not ([string]::IsNullOrEmpty($Body)))
            {
                $WebRequestResponse = Invoke-WebRequest -Uri "$ResourceUrl" -Method $Method -Headers $Headers -UseBasicParsing -ContentType $ContentType -Body $Body
            }
            else {
                Write-Output "[info] Body param is mandatory for Put/Post request"
            }
        }
    } catch {
        if ($_.ErrorDetails) {
            Write-Error $_.ErrorDetails.Message
        } else {
            Write-Error $_
        }
    }
    #Write-Verbose "Response: $WebRequestResponse"
    return $WebRequestResponse
}
