targetScope='resourceGroup'

@description('If you are using Private Link to connect to the origin, this should specify the resource ID of the Private Link resource (e.g. an App Service application, Azure Storage account, etc). If you are not using Private Link then this should be empty.')
param privateEndpointResourceId string

@description('If you are using Private Link to connect to the origin, this should specify the resource type of the Private Link resource. The allowed value will depend on the specific Private Link resource type you are using. If you are not using Private Link then this should be empty.')
param privateLinkResourceType string

@description('If you are using Private Link to connect to the origin, this should specify the location of the Private Link resource. If you are not using Private Link then this should be empty.')
param privateEndpointLocation string 

@description('The name of the Front Door endpoint to create. This must be globally unique.')
param frontDoorEndpointName string = 'afd-${uniqueString(resourceGroup().id)}'

var frontDoorSkuName = 'Standard_AzureFrontDoor'
var frontDoorProfileName = 'CraftedSpecially'
var frontDoorOriginGroupName = 'CSOriginGroup'
var frontDoorOriginName = 'MyAppServiceOrigin'
var frontDoorRouteName = 'MyRoute'

var privateLinkOriginDetails = {
  privateLink: {
    id: privateEndpointResourceId
  }
  groupId: privateLinkResourceType
  privateLinkLocation: privateEndpointLocation
  requestMessage: 'Please approve this connection.'
}

resource frontDoorProfile 'Microsoft.Cdn/profiles@2024-05-01-preview' = {
  name: 'frontDoorProfile'
  location: 'global'
  sku: {
    name: frontDoorSkuName
  }
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: frontDoorEndpointName
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: frontDoorOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  name: frontDoorOriginName
  parent: frontDoorOriginGroup
  properties: {
    hostName: app.properties.defaultHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: app.properties.defaultHostName
    priority: 1
    weight: 1000
    sharedPrivateLinkResource: privateLinkOriginDetails
  }
}

// resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
//   name: frontDoorRouteName
//   parent: frontDoorEndpoint
//   dependsOn: [
//     frontDoorOrigin // This explicit dependency is required to ensure that the origin group is not empty when the route is created.
//   ]
//   properties: {
//     originGroup: {
//       id: frontDoorOriginGroup.id
//     }
//     supportedProtocols: [
//       'Http'
//       'Https'
//     ]
//     patternsToMatch: [
//       '/*'
//     ]
//     forwardingProtocol: 'HttpsOnly'
//     linkToDefaultDomain: 'Enabled'
//     httpsRedirect: 'Enabled'
//   }
// }
