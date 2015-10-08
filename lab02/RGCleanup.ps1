# This script is intended to remove a single resource group
# and all the resources contained within the resource group.
# In order to use this script, you must know the name of the 
# resource group you would like to delete. To determine the name
# of the resource group, you can issue the command Get-AzureResourceGroup

# Remove existing subscriptions and accounts from local PowerShell environment

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

# Delete resource group used for lab

Switch-AzureMode AzureResourceManager

Write-Host  "WARNING: This script will delete all resources in the resource groups named *AZITCAMP*" -ForegroundColor Red -BackgroundColor Yellow
            "`n"
            "If do not wish to delete any resources in your subscription, click No when prompted."
            "`n"

Get-AzureResourceGroup | where {$_.ResourceGroupName -like "*AZITCAMP*"} | Remove-AzureResourceGroup

# $RGNAME = Read-Host -Prompt "Enter the name of the Resource Group you wish to delete" 

# Get-AzureResourceGroup -name $RGNAME | Remove-AzureResourceGroup 

# Get-AzureResourceGroup | Remove-AzureResourceGroup