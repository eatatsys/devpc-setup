# enable hyper-v
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Set-VMHost -VirtualMachinePath 'd:\VirtualMachines'

# install choco and packages
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n=allowGlobalConfirmation
choco install packages.config -y
choco feature disable -n=allowGlobalConfirmation

Restart-Computer