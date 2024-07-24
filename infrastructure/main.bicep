targetScope='subscription'

// Variables
var projectLocation = 'westeurope'

// Creating resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'global-infrastructure'
  location: projectLocation
}

module network './network.bicep' = {
  name: 'Network'
  scope: rg
}

module aks './aks.bicep' = {
  name: 'AKS'
  scope: rg
  params: {
    apiServerSubnetId: network.outputs.kubernetes_api_subnet_id
    nodePoolSubnetId: network.outputs.node_pool_subnet_id
    privateDnsId: network.outputs.privateDnsId
  }
}

// module frontDoor './front-door.bicep' = {
//   name: 'FrontDoor'
//   scope: rg
//   params: {
    
//   }
// }
