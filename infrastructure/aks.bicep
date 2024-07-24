targetScope='resourceGroup'

param nodePoolSubnetId string
param apiServerSubnetId string
param privateDnsId string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-05-02-preview' = {
  name: 'aksCluster'
  location: resourceGroup().location
  properties: {
    kubernetesVersion: '1.30.0'
    nodeResourceGroup: 'aksNodeResourceGroup'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        osDiskSizeGB: 30
        vnetSubnetID: nodePoolSubnetId
      }
    ]
    networkProfile: {
      networkPlugin: 'kubenet'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: true
      enableVnetIntegration: true
      privateDNSZone: privateDnsId
      enablePrivateClusterPublicFQDN: true
      subnetId: apiServerSubnetId
    }
  }
  dependsOn: []
}
