<# 
.SYNOPSIS 
   This script, in combination with an ARM template called by the script, is used to create the infrastructure 
   starting point for Lab 04 of the Azure ITPRO Camp lab exercises.The script creates two storage accounts:
   one in East US, and the other in East US 2. The script creates two virtual machines in East US. These
   virtual machines are used as the source and process server to configure and test ASR.The script uses classic 
   mode to create a virtual network in East US 2.
   
       
.DESCRIPTION | USAGE
   The script first attempts to remove any local Azure subscription certificates that might interfere with 
   logging into the subscription. You can ignore any errors, if they appear, before you are prompted to log on 
   to your Azure subscription.

   IMPORTANT: Before running this script, please note that you will be prompted to provide your initials.
   The intials are used to determine a unique name for the storage account and public DNS name. 

   
   Finally, just before the deployment begins, you will be prompted to provide the Admin password.  

   
   The scipt may take anywhere from 10 - 20 or more minutes to complete after you enter the Admin password.  
      
#> 

# Prompt for initals to use to create unique names required by the deployment.

$init = Read-Host -Prompt "Please type your initials in lower case, and then press ENTER."
Write-Host ""
# FORCE lowercase for users who do not read
$init = $init.ToLower()


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

$loc1 = "East US"
$loc2 = "Central US"
$rand = Get-Random -Minimum 10000 -Maximum 99999
$publicDNSname = "$init" + "$rand"
$AdminName = "ITCampAdmin"
$rgname1 = "RG-AZITCAMP-LAB04-S"
$rgname2 = "RG-AZITCAMP-LAB04-T"
$deploymentname = "ASR-LAB"
$templatefilepath = "C:\LabFiles\AZITPROCamp\Lab04\azuredeploy.json"
$templatefileURI = "https://raw.githubusercontent.com/AZITCAMP/Labfiles/master/lab04/azuredeploy.json"
$parameterfilepath = "C:\LabFiles\AZITPROCamp\Lab04\azuredeploy.parameters.json"
$parameterfileURI = "https://raw.githubusercontent.com/AZITCAMP/Labfiles/master/lab04/azuredeploy.parameters.json" 
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
        $sstoreName = "$init" + "sstore" + "$counter"
	    if (!(Test-AzureName -Storage $sstoreName))
	       {
	            $uniquename = $true
	        }
     } 



$uniquename = $false
$counter = 0
while ($uniqueName -eq $false)
	{
	    $counter ++
	    $tstoreName = "$init" + "tstore" + "$counter"
	    $cloudsvcname = "$init" + "tcloudsvc" + "$counter"
	    if (!(Test-AzureName -Storage $tstoreName))
	    {
	        if (!(Test-AzureName -Service $cloudsvcname))
	        {
	            $uniquename = $true
	        }
	    }
	}

# Write-Host "Creating cloud service $cloudsvcname in $loc2"
# New-AzureService -ServiceName $cloudsvcname -Location $loc2

Write-Host ""
	
Write-Host "Creating storage account $tstorename in $loc2"
New-AzureStorageAccount -StorageAccountName $tstoreName -Location $loc2

#Create VNET and subnet using classic mode

$dir = "c:\Source"
$FileURI = "https://github.com/AZITCAMP/Labfiles/raw/master/lab04/AzureNetwork.netcfg"
if(!(Test-path $dir)){New-Item $dir -ItemType directory}
$output = "$dir\AzureNetwork.netcfg"
(New-Object System.Net.WebClient).DownloadFile($FileURI,$output)

Write-Host "Creating Virtual Network"
Set-AzureVNetConfig -ConfigurationPath $output

Write-Host ""	

Write-host "Switching to Azure Resource Manager mode"

Write-Host ""

#Switch to AzureResource Manager mode.

Switch-AzureMode AzureResourceManager

# Create resource group

New-AzureResourceGroup -Name $rgname1 -Location $loc1
New-AzureResourceGroup -Name $rgname2 -Location $loc2


# Read the values from the parameters file and create a hashtable. We do this because we need to modify some of  
#   of the parameters. 

# First, get the parameters json file from a GitHub repo:

$dir = "c:\Source"
$FileURI = "https://raw.githubusercontent.com/AZITCAMP/Labfiles/master/lab04/azuredeploy.parameters.json"
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
$parameters.storageAccount = $sstoreName
$parameters.publicDNSName = $publicDNSname
$parameters.adminUsername = $AdminName
$parameters.assetlocation = $assetlocation
 
# Create a new resource group deployment using the template file and template parameters stored in the hash table. 
 
New-AzureResourceGroupdeployment -Name $deploymentname -ResourceGroupName $rgname1 -TemplateParameterObject $parameters -TemplateUri $templatefileURI -Force 





# Get-AzurePublicIpAddress -ResourceGroupName $rgname1 | select name, IPaddress

# Get-AzureResourceGroup | Remove-AzureResourceGroup -force
