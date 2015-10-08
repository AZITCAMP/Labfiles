<# 
.SYNOPSIS 
   This script is used to create a starting point for the Azure ITPRO Camp lab exercises.The script first determines 
   a globally unique name for a storage account that can be used for the lab exercises and then creates a 
   new Azure resource group for use in the lab exercises.   
.DESCRIPTION | USAGE
   The script first attempts to remove any local Azure subscription certificates that might interfere with 
   logging into the subscription. You can ignore any errors, if they appear, before you are prompted to log on 
   to your Azure subscription.

    IMPORTANT: Before running this script, please note that you will be prompted to provide your intiails.
   These intials are used to determine a unique name for the storage account. For storage account names,
   you must use all lower case letters or numbers. No hyphens or other characters are allowed.

   
#> 

$init = Read-Host -Prompt "Please type your initials in lower case, and then press ENTER."

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


$loc = "West US"
$rgname = "RG-AZITCAMP-LAB01"
$deploymentname = "Simple-VM"
$templatefilepath = "C:\LabFiles\..."
$templatefileURI = "https://raw.githubusercontent.com/..."
$parameterfilepath = "C:\LabFiles\..."
$parameterfileURI = "https://raw.githubusercontent.com/..." 



# Use Test-Azure to determine unique name for storage account.	

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
Write-Host "Please note and use the following as the name for your storage account in subsequent lab exercises:"
            "`n"
Write-Host  "$storename" -ForegroundColor Black -BackgroundColor Green
            "`n"

Pause

#Switch to AzureResource Manager mode.

Switch-AzureMode AzureResourceManager

# If you are running this script on your own computer and not on the supplied host,
# you consider specifying a location that it is closer to your own physical location.

New-AzureResourceGroup -Name $rgname -Location $loc

# If you want to deploy a local template using this script, add values for the $deploymentname, $templatefilepath, and $parametefilepath
# and uncomment the following line.

# New-AzureResourceGroupDeployment -Name $deploymentname -ResourceGroupName $rgname -TemplateParameterFile $paremeterfilepath -TemplateFile $templatefilepath

# If you want to deploy a remote template using this script, add values for the $deploymentname, $templatefileURI, and $parametefileURI
# and uncomment the following line.

# New-AzureResourceGroupDeployment -Name $deploymentname -ResourceGroupName $rgname -TemplateParameterUri $parameterfileURI -TemplateUri $templatefileURI
