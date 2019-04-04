function ExecCode($cmd) {
    $exp = 'code ' + $cmd
    Invoke-Expression $exp
}

function InstallCodeExt($name) {
    ExecCode -cmd "--install-extension $name"
}

$extensions = (Get-Content .\vscode.ext -Raw).Split([System.Environment]::NewLine, [System.StringSplitOptions]::RemoveEmptyEntries)
foreach ($ext in $extensions) {
    $ext = $ext.Trim()
    Write-Host "Installing Extension $ext" -ForegroundColor Green
    InstallCodeExt -name $ext
}