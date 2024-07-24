targetScope='subscription'

// Variables
var projectLocation = 'westeurope'

// Creating resource group
resource global_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'global-infrastructure'
  location: projectLocation
}

resource runtime_rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'runtime-infrastructure'
  location: projectLocation
}

module privateDns 'private-dns.bicep' = {
  name: 'PrivateDns'
  scope: global_rg
}

module network './network.bicep' = {
  name: 'Network'
  scope: runtime_rg
}

module aks './aks.bicep' = {
  name: 'AKS'
  scope: runtime_rg
  params: {
    apiServerSubnetId: network.outputs.kubernetes_api_subnet_id
    nodePoolSubnetId: network.outputs.node_pool_subnet_id
    privateDnsId: privateDns.outputs.privateDnsId
  }
}

// module frontDoor './front-door.bicep' = {
//   name: 'FrontDoor'
//   scope: rg
//   params: {
    
//   }
// }
