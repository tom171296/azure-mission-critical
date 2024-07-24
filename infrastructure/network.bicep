targetScope='resourceGroup'

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: 'cs-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'kubernetes_api_subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'node_pool'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

output kubernetes_api_subnet_id string = vnet.properties.subnets[0].id
output node_pool_subnet_id string = vnet.properties.subnets[1].id
