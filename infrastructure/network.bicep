targetScope='resourceGroup'

resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'csprivatelink.com'
  location: resourceGroup().location
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: 'cs-vnet'
  location: resourceGroup().location
  properties: {
    subnets: [
      {
        name: 'kubernetes_api_subnet'
        properties: {
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'node_pool'
        properties: {
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

output privateDnsId string = privateDns.id
output kubernetes_api_subnet_id string = vnet.properties.subnets[0].id
output node_pool_subnet_id string = vnet.properties.subnets[1].id

