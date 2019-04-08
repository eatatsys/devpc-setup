Param(
    [Switch] $restart
)

# enable hyper-v

$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
if($hyperv.State -ne "Enabled") {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

Set-VMHost -VirtualHardDiskPath 'D:\VirtualMachines\VHD' -VirtualMachinePath 'D:\VirtualMachines'

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
    $tempDir = "C:\temp"
    Set-Location $tempDir
    $url = "https://raw.githubusercontent.com/eatatsys/devpc-setup/master/packages.config"
    $output = "$tempDir\packages.config"
    Invoke-WebRequest -Uri $url -OutFile $output
}

function SetupChocoUpdateTask {
    $taskname = "Update all Chocolatey Packages"
    $task = (Get-ScheduledTaskInfo -TaskName $taskname -ErrorAction SilentlyContinue)
    if ($null -eq $task) {
        $taskdescription = "updates all Chocolatey Packages"
        $action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
        -Argument '-NoProfile -WindowStyle Hidden -command "choco upgrade all --accept-license --confirm --reduce-package-size *> C:\temp\update_choco_all.log"'
        $trigger =  New-ScheduledTaskTrigger -At 1am -Weekly -DaysOfWeek Saturday
        $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 2) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskname -Description $taskdescription -Settings $settings -User "System" -RunLevel Highest
    }
}

function InstallChoco() {
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
}

function ExecChoco($cmd) {
        $exp = 'choco ' + $cmd
        Invoke-Expression $exp
}

Setup
SetupChocoUpdateTask
ExecChoco -cmd "--version"
ExecChoco -cmd "feature enable -n=allowGlobalConfirmation"
ExecChoco -cmd "upgrade chocolatey"
ExecChoco -cmd "install packages.config --accept-license --confirm --reduce-package-size"
ExecChoco -cmd "upgrade all --accept-license --confirm --reduce-package-size"
ExecChoco -cmd "feature disable -n=allowGlobalConfirmation"

if($restart) {
    Restart-Computer
}
