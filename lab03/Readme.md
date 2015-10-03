# Lab 03 VMs and Subnets

Create 3 subnets and 2 virtual machines to support the Azure ITPRO Camp Lab 03 exercises.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAZITCAMP%2FLabfiles%2Fmaster%2Flab03%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template creates three subnets (FESubnet, BESubnet, and GatewaySubnet) and two STANDARD_A2 virtual machines. One virtual machine is attached to the FESubnet; the other virtual machine is attached to the BEsubnet.

The template additionally leverages Desired State Configuration to install files necessary for the lab steps and to install and configure additional services and features. 

To deploy this template to Azure, you you will need to provide values for the following parameters.

1. StorageAccount - this must be a global unique string that is all lower case and contains only letters and numbers.
2. PublicDNS - Unique public DNS prefix for the deployment. The fqdn will look something like '<dnsname>.westus.cloudapp.azure.com' 
3. AdminPassword - password for the local admin accounts for the two virtual machines created in this deployment.

Alternatively, you can deploy this template using the Lab03start.ps1 PowerShell script. This script requires your initials and the Admin password as inputs. Both The Storage account  and public DNS names are created using your intials. In the case of the storage account name, the script verifies that it is globally unique. Your initial and a random number between 10,000 and 99,999 are concatnated to create a unique dns name.

The Lab03Start.ps1 script provides a demonstration of how to convert a parameter.json file to a hash table, modify the key/value pairs in the hash table and then use the hash table as an input to the new-resourcegroupdeployment cmdlet.

