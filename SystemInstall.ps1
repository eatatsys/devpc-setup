Param(
    [Switch] $restart
)

# enable hyper-v

$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
if($hyperv.State -ne "Enabled") {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

Set-VMHost -VirtualMachinePath 'd:\VirtualMachines'

# install choco and packages
function Setup {
    $requiredCommands = ("choco")
    foreach ($command in $requiredCommands) {
        if ($null -eq (Get-Command $command -ErrorAction SilentlyContinue)) {
            Write-Host "$command must be installed" -ForegroundColor Red
            if ($command -eq "choco") {
                InstallChoco
            }
        }
    }
    $url = "https://raw.githubusercontent.com/chrisb-de/scripts/master/packages.config"
    $output = "$PSScriptRoot\packages.config"
    Invoke-WebRequest -Uri $url -OutFile $output
}

function InstallChoco() {
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
}

function ExecChoco($cmd) {
        $exp = 'choco ' + $cmd
        Invoke-Expression $exp
}

Setup
ExecChoco -cmd "--version"
ExecChoco -cmd "feature enable -n=allowGlobalConfirmation"
ExecChoco -cmd "upgrade chocolatey"
ExecChoco -cmd "install packages.config --accept-license --confirm --reduce-package-size"
ExecChoco -cmd "feature disable -n=allowGlobalConfirmation"

if($restart) {
    Restart-Computer
}
