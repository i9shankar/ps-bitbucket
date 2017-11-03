<#
.SYNOPSIS
    Sets the User full name and email id so can be used when commiting something on git repo
.DESCRIPTION
    Sets the User full name and email id so can be used when commiting something on git repo
.PARAMETER FullName
    Mandatory - User full name
.PARAMETER FullName
    Mandatory - User email id    
.EXAMPLE
    Set-UserFullNameAndEmail -FullName "Uma Shankar" -EmailId "itsmeshankar1@gmail.com"
#>
function Set-UserFullNameAndEmail {
    param(
        [Parameter(Mandatory)]
        [string]$FullName,
        [Parameter(Mandatory)]
        [string]$EmailId       
    )
    $script:UserFullName = $FullName
    $script:UserEmailAddress = $EmailId

}
