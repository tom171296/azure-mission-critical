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

module containerApps './container-apps.bicep' = {
  name: 'ContainerApps'
  scope: runtime_rg
  params: {
    containerAppName: 'myContainerApp'
    containerAppEnvironmentName: 'myContainerAppEnvironment'
    containerAppImage: 'myContainerAppImage'
    containerAppDnsSuffix: 'myContainerAppDnsSuffix'
    logAnalyticsWorkspaceId: logAnalytics.outputs.logAnalyticsWorkspaceId
  }
}

module logAnalytics './log-analytics.bicep' = {
  name: 'LogAnalytics'
  scope: runtime_rg
  params: {
    logAnalyticsWorkspaceName: 'myLogAnalyticsWorkspace'
  }
}

// module frontDoor './front-door.bicep' = {
//   name: 'FrontDoor'
//   scope: rg
//   params: {
    
//   }
// }
