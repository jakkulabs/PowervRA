# Bootstrap the image with the Nuget package provider
# and the PowervRA module from the PowerShell Gallery

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PowervRA -Confirm:$false