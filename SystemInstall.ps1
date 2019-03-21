Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n=allowGlobalConfirmation
choco install `
googlechrome `
microsoft-teams `
git `
dotnetfx `
dotnetcore `
dotnetcore-sdk `
nodejs `
conemu `
vscode `
docker-desktop `
kubernetes-cli `
Minikube `
visualstudio2017professional `
office365business `
teamviewer `
adobereader `
resharper `
microsoftazurestorageexplorer `
sql-server-management-studio `
azure-cli `
7zip `
git-fork `
openssh `
awscli `
sysinternals `
greenshot `
python `
python2 `
procexp `
-y
choco feature disable -n=allowGlobalConfirmation
Restart-Computer