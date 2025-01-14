# This script is used to add/remove locks from all resource groups that contain the word "cust" 
# in their name.

# Function to handle errors
handle_error() {
  local exit_code=$1
  local msg=$2
  echo "Error: $msg (exit code: $exit_code)"
  exit $exit_code
}

# Get a list of all resource groups
resource_groups=$(az group list --query "[? contains(name,'cust')].name" -o tsv)
# Loop through each resource group and apply a lock
 for rg in $resource_groups; do
    rg=$(echo $rg | tr -d '\r')
    #echo "Applying lock to resource group: $rg"
    lock_name=$(az lock list --resource-group $rg --query "[].name" -o tsv)
    if [ -z "$lock_name" ]; then
      az lock create --name "DoNotDelete" --resource-group $rg --lock-type CanNotDelete --notes "This lock is to prevent accidental deletion of resources"
      echo "Lock created to resource group $rg"
    else
      #  echo "Lock already exists on resource group $rg"
      #az lock delete --name $lock_name --resource-group $rg
      echo "Lock $lock_name removed from resource group $rg"
    fi    
done


