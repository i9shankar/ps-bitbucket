<#
.SYNOPSIS
    Sets the credential for the target BitBucket Server.
.DESCRIPTION
    All further cmdlets from Ps.BitBucket will be executed with the Authentication details passed by this command.
.PARAMETER Credential
    PSCredential to be used to login to the target BitBucket server
.EXAMPLE
    Set-BitBucketAuthentication -Credential username
#>

function Set-BitBucketCredential {
    [CmdletBinding(DefaultParameterSetName="ByCredential")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUsePSCredentialType", "Credential")]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ByCredential')]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )
    # Get UserName and Password from Credential
    $UserName=$Credential.UserName
    $Password = $null
    if ($Credential.GetNetworkCredential()) {
        $Password=$Credential.GetNetworkCredential().password
    } else {
        $Password=[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.password))
    } 
    $script:AuthenticationToken=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName,$Password)))
}
