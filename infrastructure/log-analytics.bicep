targetScope='resourceGroup'

param logAnalyticsWorkspaceName string
param logAnalyticsWorkspaceSku string = 'PerGB2018'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: resourceGroup().location
  sku: {
    name: logAnalyticsWorkspaceSku
  }
  properties: {}
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
