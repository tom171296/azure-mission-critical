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

module azureMonitor './azure-monitor.bicep' = {
  name: 'AzureMonitor'
  scope: runtime_rg
}
