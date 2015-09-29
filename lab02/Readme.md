# VM-high-iops-data-disks

Create a VM from 32 Data Disks configured for high IOPS

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/hhttps://raw.githubusercontent.com/AZITCAMP/Labfiles/master/lab02/azuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template creates a STANDARD_D2 VM instance with 4 data disks configured with a ReadOnly cache setting. The template, leveraging DSC, creates a storage pool and stripes the 4 disks. The new volume is presented as H:\. 
Additionally, the IOMETER setup executable and .icf file are downloaded to the C:\Source directory on the virtual machine. 

This template is based on the VM-high-iops-data-disks Azure Quickstart template. 

