# enable hyper-v
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# install choco and packages
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n=allowGlobalConfirmation
choco install packages.config -y
choco feature disable -n=allowGlobalConfirmation

Restart-Computer