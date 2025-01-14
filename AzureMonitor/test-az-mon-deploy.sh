RG_DEPLOY_TARGET=rg-z-cplus-monit-n-001
RG_PREFIX=RG-Z-CPLUS
RG_CUST_PREFIX=RG-Z-CUST
VNET_APP_GW_PREFIX=ag-z-cplus-gw
EXTERNAL_LB_PREFIX=elb-z-cplus
INTERNAL_LB_PREFIX=ilb-z-cplus
VNET_PREFIX=vnet-z-cplus
AKS_PREFIX=aks-z-cplus
DB_VMS_PREFIX=vm-z-orad
environment=dev

appGatewayIds=$(az network application-gateway list --query "[?starts_with(name, '$VNET_APP_GW_PREFIX')].{id:id,name:name}")
loadBalancerIds=$(az network lb list --query "[?starts_with(name, '$EXTERNAL_LB_PREFIX') || starts_with(name, '$INTERNAL_LB_PREFIX')].{id:id,name:name}")
vnetIds=$(az network vnet list --query "[?starts_with(name, '$VNET_PREFIX')].{id:id,name:name}")
aksIds=$(az aks list --query "[?starts_with(name, '$AKS_PREFIX')].{id:id,name:name}")
dbVmIds=$(az vm list --query "[?starts_with(name, '$DB_VMS_PREFIX')].{id:id,name:name}")

customers='{"value":[
 {
    "subDomain": "demo",
    "resourceTag": "demo",
    "rootPath": "demo"
  }
]}'

az deployment group what-if \
    --resource-group "$RG_DEPLOY_TARGET" \
    --template-file './az-monitor.bicep' \
    --parameters \
        appGatewayIds="$appGatewayIds" \
        loadBalancerIds="$loadBalancerIds" \
        vnetIds="$vnetIds" \
        aksIds="$aksIds" \
        dbVmIds="$dbVmIds" \
        environment="$environment" \
        customersString="$customers" \
        actionGroupWebHookUrl="test-webhook-url"