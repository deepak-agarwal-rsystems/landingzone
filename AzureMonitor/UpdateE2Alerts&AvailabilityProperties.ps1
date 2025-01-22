# # Get a list of all resource groups
$resource_groups = $(az group list --query "[? contains(name,'cust')].name" -o tsv)
#Write-Output "Resource Groups: $resource_groups"

foreach ($resource_group in $resource_groups) {
    #Write-Output "Resource Group: $resource_group"
    $resourceGroupSplits = $resource_group -split "-"
    Write-Output "Resource Group Splits: $($resourceGroupSplits[3])"
    $clientName = $resourceGroupSplits[3];
    $appInsightName = $(az monitor app-insights component show --resource-group $resource_group --query "[0].applicationId")
    Write-Output "App Insight Name: $appInsightName"
    $clientURl = $(az monitor app-insights web-test list --resource-group $resource_group --query "[? contains(name,'Test Login')].request.requestUrl" -o tsv)
    $clientMainUrl = $clientURl -split "JaruStats"
    Write-Output "Client Main URL: $($clientMainUrl[0])"
    # $alerts = $(az monitor metrics alert list --resource-group $resource_group --query "[? contains(name,'E2 Protocol-aggregate-alert')].name" -o tsv)

    # # Update the E2 Aggregate alert property Auto Mitigate as true
    # foreach ($alert in $alerts) {       
    #     Write-Output "Updating the Alert's property 'AutoMitigate' as true for $alert"
    #     az monitor metrics alert update --resource-group $resource_group -n $alert --set autoMitigate=true
    # }

    # All availability tests
    #$all_tests = $(az monitor app-insights web-test list --resource-group $resource_group -o tsv)
    #Write-Output "Availability Tests Count: $($all_tests.Count)"

    #$availability_tests = $(az monitor app-insights web-test list --resource-group $resource_group --query "[?!enabled].name" -o tsv)
    # Update the Availability Test frequency as 15min (900 seconds) and location as 'Central US'
    # foreach ($availability_test in $availability_tests) {        
    #     Write-Output "Updating the Availability Test frequency and location $availability_test"
    #     #az monitor app-insights web-test update --frequency 900 --locations id="us-fl-mia-edge" --resource-group $resource_group --name $availability_test
        
    # }

    $templateFile = "./AvailabilityTest/webtest-create-template.json"
    az deployment group create `
    --resource-group $resource_group `
    --template-file $templateFile `
    --parameters resourceGroupName=$resource_group appInsightName=$appInsightName clientName=$clientName clientMainUrl=$($clientMainUrl[0])

    Write-Output "Availability Tests created for $resource_group"
}


