<# 
.SYNOPSIS 
   This script is used to create the infrastructure starting point for Lab 03 of the Azure ITPRO Camp lab exercises.
   The script creates a new resource group    and a new resource group deployment that comprises 2 virtual machines 
   and 3 subnets. The scrip requires that you provide your initials. It uses these initials to create the unique names
   required by the deployment.
      
.DESCRIPTION | USAGE
   The script first attempts to remove any local Azure subscription certificates that might interfere with 
   logging into the subscription. You can ignore any errors, if they appear, before you are prompted to log on 
   to your Azure subscription.

   IMPORTANT: Before running this script, please note that you will be prompted to provide your initials 
   and the IP address of your VPN device (if you are using the lab environment, this is the external IP 
   address of the EDGE virtual machine). *In the lab environment, you need to reconfigure the Edge 
   virtual machine to get a public IP address, as per the lab instructions. If you are doing this lab 
   using your own environment, please keep in mind that your VPN endpoint cannot be behind a NAT device. 
   If you do not have a VPN endpoint, you can enter a random IP address. You will still be able to most 
   of the lab steps.

   The intials are used to determine a unique name for the storage account and public DNS name. 

   
   Finally, just before the deployment begins, you will be prompted to provide the Admin password and the publick IP address
   of the public IP address of the VPN endpoint (the onprem VPN device or remote site) you are going to use for the lab
   exercises.  

   
   The scipt may take anywhere from 10 - 20 or more minutes to complete after you enter the Admin password. The VPN gateway takes some 
   time to provision, and will be the last element to be provisioned. Please be patient. You can log in to the Azure 
   to watch the progress of the deployment provisioning process. 
      
#> 

# Prompt for initals to use to create unique names required by the deployment.

$init = Read-Host -Prompt "Please type your initials in lower case, and then press ENTER."
Write-Host ""


#Remove any subscription information that could interfere with then sign out before signing into the Azure account.

Write-Host "Removing local Azure subscription certificates..."
foreach ($sub in Get-AzureSubscription)
{
    if ($sub.Name)
    {
        Remove-AzureSubscription $sub.Name -Force
    }
}
Write-Host "Signing out of Azure..."
foreach ($acct in Get-AzureAccount)
{
    Remove-AzureAccount $acct.Name -Force
}

# Sign into Azure
Add-AzureAccount

# Get the default subscription name and use it in $subname variable
$subname = ""
	foreach ($sub in Get-AzureSubscription)
	{
	    if ($sub.IsDefault -eq "True")
	    {
	        $subname = $sub.SubscriptionName
	    }
	}

# Make the default subscription the current subscription.
# If you wish to use a subscription other than the default, replace $subname with the name of the subscription.

Select-AzureSubscription -SubscriptionName $subname

#Declare variables for use in the script.

$loc = "West US"
$rand = Get-Random -Minimum 10000 -Maximum 99999
$publicDNSname = "$init" + "$rand"
$AdminName = "ITCampAdmin"
$rgname = "RG-AZITCAMP-LAB03"
$rgname1 = "RG-AZITCAMP-STD"
$rgname2 = "RG-AZITCAMP-PREM"
$deploymentname = "Multi-VM-Subnet"
$templatefilepath = "C:\LabFiles\AZITPROCamp\Lab03\azuredeploy.json"
$templatefileURI = "https://raw.githubusercontent.com/AZITCAMP/Labfiles/master/lab03/azuredeploy.json"
$parameterfilepath = "C:\LabFiles\AZITPROCamp\Lab03\azuredeploy.parameters.json"
$parameterfileURI = "https://raw.githubusercontent.com/AZITCAMP/Labfiles/master/lab03/azuredeploy.parameters.json" 
$assetlocation = "https://github.com/AZITCAMP/Labfiles/raw/master"



# Use Test-Azure to determine unique name for storage account.	
# This cmdlet requires that we be in Serive Management mode

#Ensure we are in Service Management mode to run the Test-AzureName cmdlet.
Switch-AzureMode AzureServiceManagement
 
 $uniquename = $false
 $counter = 0
 while ($uniqueName -eq $false)
	{
	    $counter ++
#	     
        $storeName = "$init" + "store" + "$counter"
	    if (!(Test-AzureName -Storage $storeName))
	       {
	            $uniquename = $true
	        }
     } 
	

Write-Host ""
Write-Host "Please note and use the following as the names for your storage and public DNS name in the subsequent lab exercises:" 
            "`n"
Write-Host  "$storename" -ForegroundColor Black -BackgroundColor Green
            "`n"
Write-host  "$publicDNSName" -ForegroundColor Black -BackgroundColor Green
#            "`n"      

Pause

#Switch to AzureResource Manager mode.

Switch-AzureMode AzureResourceManager

# Create resource group

New-AzureResourceGroup -Name $rgname -Location $loc

# Read the values from the parameters file and create a hashtable. We do this because we need to modify some of  
#   of the parameters. 

# First, get the parameters json file from a GitHub repo:

$dir = "c:\Source"
$FileURI = "https://raw.githubusercontent.com/AZITCAMP/Labfiles/master/lab03/azuredeploy.parameters.json"
    If (!(Test-Path $dir -PathType Container ) )
        {
           New-Item $dir -ItemType directory
        }
$parameterFile = "$dir\azuredeploy.parameters.json"
(New-Object System.Net.WebClient).DownloadFile($FileURI,$parameterFile)

# Then, create a hash table from the file

$parameters = New-Object -TypeName hashtable 
$jsonContent = Get-Content $ParameterFile -Raw | ConvertFrom-Json 
$jsonContent.parameters | Get-Member -MemberType NoteProperty | ForEach-Object { 
    $parameters.Add($_.Name, $jsonContent.parameterValues.($_.Name)) 
} 

# Set the StorageAccount and the PublicDNSName parameters to the unique value determined earlier by this script. 
# And, then set other parameters in the hash table to appropriate values.

# $parameters.storageAccountfromTemplate = $storeName
$parameters.storageAccount = $storeName
$parameters.publicDNSName = $publicDNSname
$parameters.adminUsername = $AdminName
$parameters.assetlocation = $assetlocation
 
# Create a new resource group deployment using the template file and template parameters stored in the hash table. 
 
New-AzureResourceGroupdeployment -Name $deploymentname -ResourceGroupName $rgname -TemplateParameterObject $parameters -TemplateUri $templatefileURI -Force 


# Display the public IP addresses used by the deployment

Write-Host ""
Write-Host "The following shows the public IP addresses used by the deployment. PubiP0 corresponds to FE1; PubIP1 corresponds to BE1."

Get-AzurePublicIpAddress | select name, IPaddress

Write-Host ""
Write-host "The fqdn for FE1 is:"
Write-host ""
Write-host "$publicDNSname.westus.cloudapp.azure.com"
Write-host ""
Write-host "BE1 does not have a corresponding DNS name. This is by design."
