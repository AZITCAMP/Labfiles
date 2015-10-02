# Lab 03 VMs and Subnets

Create 3 subnets and 2 virtual machines to support Lab 03 exercises.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAZITCAMP%2FLabfiles%2Fmaster%2Flab03%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template creates three subnets (FESubnet, BESubnet, and GatewaySubnet) and two STANDARD_A2 virtual machines. One virtual machine is attached to the FESubnet; the other virtual machine is attached to the BEsubnet.

The template additionally leverages Desired State Configuration to install files necessary for the lab steps and to install and configure additional services and features. 

