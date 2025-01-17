# Peer Hub to Spoke Virtual Network
$templateFile = "./VirtualNetwork/VirtualNetworkPeering/vnetpeering-hubtospoke-template.json"
$templateParameterFile = "./VirtualNetwork/VirtualNetworkPeering/vnetpeering-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgSpokeName `
   --template-file $templateFile `
   --parameters $templateParameterFile

# Peer Spoke to Hub Virtual Network
$templateFile = "./VirtualNetwork/VirtualNetworkPeering/vnetpeering-spoketohub-template.json"
$templateParameterFile = "./VirtualNetwork/VirtualNetworkPeering/vnetpeering-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $templateParameterFile