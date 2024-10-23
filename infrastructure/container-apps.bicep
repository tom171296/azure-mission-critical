targetScope='resourceGroup'

param containerAppName string
param containerAppEnvironmentName string
param containerAppImage string
param containerAppCpu float = 0.5
param containerAppMemory string = '1.0Gi'
param containerAppPort int = 80
param containerAppDnsSuffix string
param logAnalyticsWorkspaceId string

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: containerAppEnvironmentName
  location: resourceGroup().location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspaceId
      }
    }
  }
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: resourceGroup().location
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: containerAppPort
        transport: 'auto'
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: containerAppImage
          resources: {
            cpu: containerAppCpu
            memory: containerAppMemory
          }
        }
      ]
    }
  }
}

output containerAppUrl string = 'https://${containerAppName}.${containerAppDnsSuffix}'
output containerAppId string = containerApp.id
