# Lab 03 Infrastructure: VMs, Subnets, and VPN Gateway

Create 3 subnets, 2 virtual machines, and a VPN gateway to support the Azure ITPRO Camp Lab 03 exercises.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAZITCAMP%2FLabfiles%2Fmaster%2Flab03%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template creates three subnets (FESubnet, BESubnet, and GatewaySubnet),  two STANDARD_A2 virtual machines, and a VPN Gateway. One virtual machine is attached to the FESubnet; the other virtual machine is attached to the BEsubnet.

The template additionally leverages Desired State Configuration to install files necessary for the lab steps and to install and configure additional services and features. 

To deploy this template to Azure, you you will need to provide values for the following parameters:

1. StorageAccount - this must be a global unique string that is all lower case and contains only letters and numbers. To create a unique name, use something like abcstore12345, where abc is your initials and 12345 is some random 5-digit number. 
2. PublicDNS - Unique public DNS prefix for the deployment. The fqdn will look something like this: 'PublicDNSName.westus.cloudapp.azure.com'. To create a unique name, use something like abc12345, where abc is your initials and 12345 is a random 5-digit number.
3. localGatewayIpAddress - Public IP address of the VPN endpoint (the onprem VPN device or remote site).* 
3. AdminPassword - password for the local admin accounts for the two virtual machines created in this deployment.

<i> *In the lab environment, you need to reconfigure the Edge virtual machine to get a public IP address, as per the lab instructions. If you are doing this lab using your own environment, please keep in mind that your VPN endpoint cannot be behind a NAT device. If you do not have a VPN endpoint, you can enter a random IP address. You will still be able to most of the lab steps.</i>

As an alternative to deploying the envrionment using the link above, you can deploy this template using the Lab03start.ps1 PowerShell script. This script requires your initials, Admin password, and localGatewayIPAddress as inputs. Both The Storage account and public DNS names are created using your intials to create the unique names required by the deployment. In the case of the storage account name, the script verifies that it is globally unique. Your initials and a random number between 10,000 and 99,999 are concatnated to create a unique dns name.

The Lab03Start.ps1 script provides a demonstration of how to convert a parameter.json file to a hash table, modify the key/value pairs in the hash table and then use the hash table as an input to the new-resourcegroupdeployment cmdlet.

