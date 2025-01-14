# RG_DEPLOY_TARGET=rg-z-cplus-monit-p-001
# RG_PREFIX=rg-z-cplus
# RG_CUST_PREFIX=rg-z-cust
# VNET_APP_GW_PREFIX=ag-z-cplus-gw
# EXTERNAL_LB_PREFIX=elb-z-cplus
# INTERNAL_LB_PREFIX=ilb-z-cplus
# VNET_PREFIX=vnet-z-cplus
# AKS_PREFIX=aks-z-cplus
# DB_VMS_PREFIX=vm-z-orad
# environment=prod
# actionGroupWebHookUrl='https://events.pagerduty.com/integration/a515ac938f764f06d0c307115acecc6b/enqueue'
# whatIf='true'

appGatewayIds=$(az network application-gateway list --query "[?starts_with(name, '$VNET_APP_GW_PREFIX')].{id:id,name:name}")
loadBalancerIds=$(az network lb list --query "[?starts_with(name, '$EXTERNAL_LB_PREFIX') || starts_with(name, '$INTERNAL_LB_PREFIX')].{id:id,name:name}")
vnetIds=$(az network vnet list --query "[?starts_with(name, '$VNET_PREFIX')].{id:id,name:name}")
aksIds=$(az aks list --query "[?starts_with(name, '$AKS_PREFIX')].{id:id,name:name}")
dbVmIds=$(az vm list --query "[?starts_with(name, '$DB_VMS_PREFIX')].{id:id,name:name}")
rgIds=$(az group list --query "[?starts_with(name, '$RG_CUST_PREFIX')].{id:id,name:name}")
webTestIds=$(az monitor app-insights web-test list --query "[?contains(id, '$RG_CUST_PREFIX')].{id:id,name:name,enabled:enabled,request:request.requestUrl,resourceGroup:resourceGroup,validationRules:validationRules.contentValidation.contentMatch,headers:request.headers,requestBody:request.requestBody,ignoreHttpStatusCode:validationRules.ignoreHttpStatusCode,httpVerb:request.httpVerb}")
webTestAlertIds=$(az monitor metrics alert list --query "[?contains(id, '$RG_CUST_PREFIX')].{id:id,name:name,enabled:enabled,webTestId:criteria.webTestId,webTestName:criteria.allOf[0].dimensions[0].values[0],resourceGroup:resourceGroup,evaluationFrequency:evaluationFrequency,windowSize:windowSize,severity:severity,failedLocationCount:criteria.failedLocationCount}")

# Declare an associative array to hold web test details for each resource group
declare -A rgWebTests

# Iterate over each resource group ID
for rg in $(echo "$rgIds" | jq -r '.[] | @base64'); do
    
    # Function to decode base64 and extract JSON fields
    _jq() {
        echo "$rg" | base64 --decode | jq -r "$1"
    }
    # Extract resource group name and ID
    rgName=$(_jq '.name')
    rgId=$(_jq '.id')
    
    # Initialize an array to hold web test details for the current resource group
    webTests=()
    webTestAlerts=()

    # Processes a JSON array of web test IDs, filters them by a specified resource group, decodes each 
    # filtered web test ID from base64, and then re-encodes the results into a compact JSON array.
    webTestIdsJson=$(echo "$webTestIds" | jq -r --arg rg "$rgName" '
        .[] | select(.resourceGroup == $rg) | @base64' | while read -r webTest; do
            echo "$webTest" | base64 --decode | jq -c '.'
        done | jq -s '.')

    # Iterate over each web test ID and filter by the current resource group
    for webTest in $(echo "$webTestIdsJson" | jq -r '.[] | @base64'); do
        # Decode the web test details
        _webTest() {
            echo "$webTest" | base64 --decode | jq -r "$1"
        }

        # Extract web test details
        webTestId=$(_webTest '.id')
        webTestName=$(_webTest '.name')
        webTestEnabled=$(_webTest '.enabled')
        webTestRequest=$(_webTest '.request')
        webTestValidationRules=$(_webTest '.validationRules')
        webTestHeaders=$(_webTest '.headers')
        webTestRequestBody=$(_webTest '.requestBody')
        webTestIgnoreHttpStatusCode=$(_webTest '.ignoreHttpStatusCode')
        webTestHttpVerb=$(_webTest '.httpVerb')

        # Create a JSON object for the web test and add it to the array
        webTests+=($(jq -nc \
            --arg id "$webTestId" \
            --arg name "$webTestName" \
            --arg enabled "$webTestEnabled" \
            --arg request "$webTestRequest" \
            --arg validationRules "$webTestValidationRules" \
            --argjson headers "$webTestHeaders" \
            --arg requestBody "$webTestRequestBody" \
            --arg ignoreHttpStatusCode "$webTestIgnoreHttpStatusCode" \
            --arg httpVerb "$webTestHttpVerb" \
            '{
            id: $id, 
            name: ($name | if . == "null" then null else . end), 
            enabled: ($enabled | if . == "null" then null else . end), 
            request: ($request | if . == "null" then null else . end), 
            validationRules: ($validationRules | if . == "null" then null else . end), 
            headers: $headers, 
            requestBody: ($requestBody | if . == "null" then null else . end), 
            ignoreHttpStatusCode: ($ignoreHttpStatusCode | if . == "null" then null else . end), 
            httpVerb: ($httpVerb | if . == "null" then null else . end)
            }'))

    done

    # Processes a JSON array of web test alert IDs, filters them by a specified webTestId , decodes each 
    # filtered web test alert ID from base64, and then re-encodes the results into a compact JSON array.
    webTestAlertIdsJson=$(echo "$webTestAlertIds" | jq -r --arg rg "$rgName" '
        .[] | select(.resourceGroup == $rg) | @base64' | while read -r webTestAlert; do
            echo "$webTestAlert" | base64 --decode | jq -c '.'
        done | jq -s '.')

    # Iterate over each web test alert ID and filter by the current resource group
    for webTestAlert in $(echo "$webTestAlertIdsJson" | jq -r '.[] | @base64'); do
        _webTestAlert() {
            echo "$webTestAlert" | base64 --decode | jq -r "$1"
        }

        # Extract web test alert details
        webTestAlertId=$(_webTestAlert '.id')
        webTestAlertName=$(_webTestAlert '.name')
        webTestId=$(_webTestAlert '.webTestId')
        webTestName=$(_webTestAlert '.webTestName')
        webTestAlertEnabled=$(_webTestAlert '.enabled')
        webTestAlertSeverity=$(_webTestAlert '.severity')
        webTestAlertEvaluationFrequency=$(_webTestAlert '.evaluationFrequency')
        webTestAlertWindowSize=$(_webTestAlert '.windowSize')
        webTestAlertFailedLocationCount=$(_webTestAlert '.failedLocationCount')

        # Create a JSON object for the web test and add it to the array
        webTestAlerts+=($(jq -nc \
            --arg id "$webTestAlertId" \
            --arg name "$webTestAlertName" \
            --arg webTestId "$webTestId" \
            --arg webTestName "$webTestName" \
            --arg enabled "$webTestAlertEnabled" \
            --arg severity "$webTestAlertSeverity" \
            --arg evaluationFrequency "$webTestAlertEvaluationFrequency" \
            --arg windowSize "$webTestAlertWindowSize" \
            --arg failedLocationCount "$webTestAlertFailedLocationCount" \
            '{
            id: $id, 
            name: ($name | if . == "null" then null else . end), 
            webTestId: ($webTestId | if . == "null" then null else . end), 
            webTestName: ($webTestName | if . == "null" then null else . end), 
            enabled: ($enabled | if . == "null" then null else . end), 
            severity: ($severity | if . == "null" then null else . end), 
            evaluationFrequency: ($evaluationFrequency | if . == "null" then null else . end), 
            windowSize: ($windowSize | if . == "null" then null else . end), 
            failedLocationCount: ($failedLocationCount | if . == "null" then null else tonumber end)
            }'))

    done

    # Converts the array of web tests into a JSON array using jq and stores it in the variable webTestsJson.
    webTestsJson="$(echo "${webTests[@]}" | jq -s '.')"
    # Converts the array of web test alerts into a JSON array using jq and stores it in the variable webTestAlertsJson.
    webTestAlertsJson="$(echo "${webTestAlerts[@]}" | jq -s '.')"

    # Create a JSON object for the resource group, web tests, and alerts, and add it to the associative array
    rgWebTests["$rgName"]=$(jq -n \
        --arg name "$rgName" \
        --arg id "$rgId" \
        --argjson webTests "$webTestsJson" \
        --argjson webTestAlerts "$webTestAlertsJson" \
        '{name: $name, id: $id, webTests: $webTests, webTestAlerts: $webTestAlerts}')

done

# Convert the array of resource group web tests (rgWebTests) to a JSON array using jq.
rgWebTests="$(echo "${rgWebTests[@]}" | jq -s '.')"
# Write the JSON array to a file named customers.json.
echo "$rgWebTests" > ./customers.json

if [ $whatIf == 'true' ]; then
    az deployment group what-if \
    --resource-group "$RG_DEPLOY_TARGET" \
    --template-file './AzureMonitor/az-monitor.bicep' \
    --parameters \
        appGatewayIds="$appGatewayIds" \
        loadBalancerIds="$loadBalancerIds" \
        vnetIds="$vnetIds" \
        aksIds="$aksIds" \
        dbVmIds="$dbVmIds" \
        actionGroupWebHookUrl="$actionGroupWebHookUrl" \
        environment="$environment"
else
    az deployment group create \
    --resource-group "$RG_DEPLOY_TARGET" \
    --template-file './AzureMonitor/az-monitor.bicep' \
    --parameters \
        appGatewayIds="$appGatewayIds" \
        loadBalancerIds="$loadBalancerIds" \
        vnetIds="$vnetIds" \
        aksIds="$aksIds" \
        dbVmIds="$dbVmIds" \
        actionGroupWebHookUrl="$actionGroupWebHookUrl" \
        environment="$environment"
fi