
# Delete AI resource group
# $rgAIName = "rg-z-cplus-ai-p-001"
#az group delete --name $rgAIName --yes

# $rgDBName = "rg-z-cplus-db-n-001"
#az group delete --name $rgDBName --yes

$customers = @( @{'name'='publ'}, 
@{'name'='groc'}, 
@{'name'='cole'}, 
@{'name'='amaz'}, 
@{'name'='amsk'}, 
@{'name'='meij'}, 
@{'name'='whol'}, 
@{'name'='waca'}, 
@{'name'='cobo'}, 
@{'name'='emrl'})

foreach ( $customer in $customers ) {
    $rgCustomerName = "rg-z-cplus-$($customer.name)-p-001"
    #az group delete --name $rgCustomerName --yes
}
