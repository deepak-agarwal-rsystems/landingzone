# Get a list of all resource groups
$resource_groups = $(az group list --query "[? contains(name,'cust')].name" -o tsv)

foreach ($resource_group in $resource_groups) {
    Write-Output "Resource Group: $resource_group"
    $alerts = $(az monitor metrics alert list --resource-group $resource_group --query "[].name" -o tsv)

    foreach ($alert in $alerts) {
        if ($alert -like "*Email Monitor-alert*" `
                -or $alert -like "*Test Alarm Flow-alert*" `
                -or $alert -like "*Test E2 Protocol-alert*" `
                -or $alert -like "*canary-alert*") {
            Write-Output "Deleting alert $alert"
            az monitor metrics alert delete --name $alert --resource-group $resource_group
        }
    }
}
