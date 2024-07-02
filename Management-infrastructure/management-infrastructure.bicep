targetScope='subscription'

// Parameters
param projectLocation string = 'eastus'

// Variables
var projectName = 'management-infrastructure'

// Infrastructure Resources

// Creating resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: projectName
  location: projectLocation
}

// Runtime infrastructure
module runtimeInfrastructure 'runtime-infrastructure/runtime-infrastructure.bicep' = {
  name: 'RuntimeInfrastructure'
  scope: rg
  params: {
    location: rg.location
  }
}
