targetScope = 'resourceGroup'

resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'csprivatelink.com'
  location: 'global'
}

output privateDnsId string = privateDns.id
