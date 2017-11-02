# Copyright © 2017. All rights reserved.
$Public = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse #-ErrorAction SilentlyContinue
$Private = Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse
#Dot source the files
foreach ( $Import in $Public ) {
    try {
        . $Import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

foreach ( $Import in $Private ) {
    try {
        . $Import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

foreach ($item in $Public) {
    Write-Verbose "Exporting ${item.BaseName}"
    Export-ModuleMember -Function $item.BaseName
}