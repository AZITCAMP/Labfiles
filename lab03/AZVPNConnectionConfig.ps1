 
 <# 
.SYNOPSIS 
   This simple script configure a virtual network gateway connection in Azure. \
   The script assumes that you have completed the comfiguration of a VPN gateway
   in Azure, either by deploying the Lab 03 template to create the lab infrasture or
   by creating the VPN gateway using another method. 
      
.DESCRIPTION | USAGE
   This script assumes that the resource group is named RG-AZITCAMP-LAB02 and that the resource
   group is located in West US. If this is not true, then change the variable to the appropriate values.
   This script also assumes that you have configured or will configure the RRAS to use an IKEv2
   shared key as 'abc123' 
      
#> 

 $loc = "West US"
 $rg = "RG-AZITCAMP-LAB03"
 $gw = Get-AzureVirtualNetworkGateway -Name vnetgw -ResourceGroupName $rg
 $ls = Get-AzureLocalNetworkGateway -Name LocalSiteGW -ResourceGroupName $rg

 New-AzureVirtualNetworkGatewayConnection -Name s2svpn -ResourceGroupName $rg -Location $loc -VirtualNetworkGateway1 $gw -LocalNetworkGateway2 $ls -ConnectionType IPsec -RoutingWeight 10 -SharedKey 'abc123'