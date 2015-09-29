# Lab 02 VM - D2 VM with 4 striped data disks

Create a VM that uses 4 Data Disks to test IOPS

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAZITCAMP%2FLabfiles%2Fmaster%2Flab02%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template creates a STANDARD_D2 VM instance with 4 data disks configured with a ReadOnly cache setting. The template, leveraging DSC, creates a storage pool and stripes the 4 disks. The new volume is presented as H:\. 
Additionally, the IOMETER setup executable and .icf file are downloaded to the C:\Source directory on the virtual machine. 

This template is based on the VM-high-iops-data-disks Azure Quickstart template. 

