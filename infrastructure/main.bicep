targetScope='subscription'

// Variables
var projectLocation = 'eastus'

// Creating resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'global-infrastructure'
  location: projectLocation
}

module frontDoor './front-door.bicep' = {
  name: 'FrontDoor'
  scope: rg
}
