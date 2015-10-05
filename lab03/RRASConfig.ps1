# Microsoft Corporation
# Microsoft Azure Virtual Network

# This configuration sample applies to Microsoft RRAS running on Windows Server 2012.
# This configuration sample configures an IPSec VPN tunnel used to connect your on-premises VPN device with the Windows Azure Virtual Network gateway.

# !!! In this version, the following support restrictions apply for RRAS:
# !!! 1. Only IKEv2 is currently supported
# !!! 2. Only route-based VPN configuration is supported.

# Install RRAS role
Import-Module ServerManager
Install-WindowsFeature RemoteAccess -IncludeManagementTools
Add-WindowsFeature -name Routing -IncludeManagementTools

# !!! NOTE: You may be required to reboot before continuing on with the script.

# Install S2S VPN
Import-Module RemoteAccess
Install-RemoteAccess -VpnType VpnS2S

# Add S2S VPN interface
Add-VpnS2SInterface -Protocol IKEv2 -AuthenticationMethod PSKOnly -NumberOfTries 3 -ResponderAuthenticationMethod PSKOnly -Name <SP_AzureGatewayIpAddress> -Destination <SP_AzureGatewayIpAddress> -IPv4Subnet @("10.0.0.0/16:10") -SharedSecret abc123

# Restart the RRAS service
Restart-Service RemoteAccess

# Dial-in to Azure gateway (optional)
#Connect-VpnS2SInterface -Name <SP_AzureGatewayIpAddress> 