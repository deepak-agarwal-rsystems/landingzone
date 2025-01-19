# Deploy VMs
$rgVMName = "rg-z-cust-$($virtualMachine.vmName)-p-001"

# Deploy the VM Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
# az deployment sub create `
#    --location $location `
#    --template-file $templateFile `
#    --parameters $globalParameterFile name=$rgVMName

# Deploy the VM NSG
$networkSecurityGroupName = "nsg-z-$($virtualMachine.vmName)-p-001"
$templateFile = "./NetworkSecurityGroup/nsg-template.json"
# az deployment group create `
#    --resource-group $rgVMName `
#    --template-file $templateFile `
#    --parameters $globalParameterFile networkSecurityGroupName=$networkSecurityGroupName

# Deploy the VM Subnet
$subnetName = "sn-z-$applicationName-$($virtualMachine.vmName)"
$subnetAddressPrefix = $virtualMachine.subnetAddressPrefix
$templateFile = "./VirtualNetwork/Subnet/subnet-template.json"
# az deployment group create `
#    --resource-group $rgSpokeName `
#    --template-file $templateFile `
#    --parameters virtualNetworkName=$spokeVirtualNetworkName `
#    subnetName=$subnetName `
#    subnetAddressPrefix=$subnetAddressPrefix `
#    nsgName=$networkSecurityGroupName `
#    nsgResourceGroupName=$rgVMName   

# Deploy the Customer VM
$templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
$noOfInstance = $virtualMachine.numberOfInstance
$counter = $virtualMachine.startingVMNumber
$noOfInstance = $noOfInstance+$counter
while ($counter -lt $noOfInstance) {
    $vmName = "vm-z-$($virtualMachine.vmName)-p-$($counter.ToString('000'))"
    $vmNICName = "$vmName-nic"    
# az deployment group create `
#     --resource-group $rgVMName `
#     --template-file $templateFile `
#     --parameters $globalParameterFile `
#     virtualMachineName=$vmName `
#     networkInterfacesName=$vmNICName `
#     virtualNetworkName=$spokeVirtualNetworkName `
#     subnetName=$subnetName `
#     infraResourceGroupName=$rgSpokeName `
#     vmSize=$($virtualMachine.vmSize) `
#     adminUserName=$($virtualMachine.adminUserName) `
#     adminPassword=$($virtualMachine.adminPassword)

    $counter += 1
}

# Deploy the Load Balancer
if ($virtualMachine.IsLoadBalancer) {
    $loadBalancerName = "lb-z-$($virtualMachine.vmName)-p-$(($virtualMachine.startingVMNumber).ToString('000'))"
    $backendAddressPoolsName = "bap-z-$($virtualMachine.vmName)-p-$(($virtualMachine.startingVMNumber).ToString('000'))"
    $templateFile = "./LoadBalancer/lb-template.json"
    az deployment group create `
        --resource-group $rgVMName `
        --template-file $templateFile `
        --parameters $globalParameterFile `
        loadBalancersName=$loadBalancerName `
        backendAddressPoolsName=$backendAddressPoolsName `
        virtualNetworksName=$spokeVirtualNetworkName `
        subNetName=$subnetName `
        infraResourceGroupname=$rgSpokeName
}

# Link the VMs to the Load Balancer using NICs
$templateFile = "./LoadBalancer/LinkLBWithNIC/lblinknic-template.json"
$noOfInstance = $virtualMachine.numberOfInstance
$counter = $virtualMachine.startingVMNumber
$noOfInstance = $noOfInstance+$counter
while ($counter -lt $noOfInstance) {
    $vmName = "vm-z-$($virtualMachine.vmName)-p-$($counter.ToString('000'))"
    $vmNICName = "$vmName-nic"  
    az deployment group create `
        --resource-group $rgVMName `
        --template-file $templateFile `
        --parameters $globalParameterFile `
        networkInterfacesName=$vmNICName `
        loadBalancersName=$loadBalancerName `
        backendAddressPoolsName=$backendAddressPoolsName `
        virtualNetworksName=$spokeVirtualNetworkName `
        subNetName=$subnetName `
        infraResourceGroupname=$rgSpokeName
   $counter += 1
}