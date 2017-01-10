# Thanks to Alan Renouf and the contributors to
# https://github.com/vmware/powerclicore for making
# the base for this Dockerfile public
FROM photon:1.0

MAINTAINER Jakku Labs

# Add PowerShell repository location to Photon OS
RUN echo $'[powershell]\n\

name=VMware Photon Linux 1.0(x86_64)\n\
baseurl=https://vmware.bintray.com/powershell\n\
gpgcheck=0\n\
enabled=1\n\
skip_if_unavailable=True\n '\
>> /etc/yum.repos.d/powershell.repo

# Install PowerShell on Photon 
RUN tdnf install -y powershell openssl

# Prepare directories
RUN mkdir -p /root/.config/powershell/
RUN mkdir -p /root/.local/share/powershell/Modules

# Bootstrap the image with PowervRA
ADD bootstrap.ps1 /tmp
RUN powershell ./tmp/bootstrap.ps1
RUN rm -f /tmp/bootstrap.ps1

# Change the default PowerShell profile to include the new profile
ADD profile.ps1 /root/.config/powershell

# Start PowerShell
CMD powershell -NoLogo