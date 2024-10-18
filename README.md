# platform-engineering
This is an example repository that contains an example setup of an AKS platform

## Management infrastructure deployment

step 1: https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Clinux#use-the-azure-login-action-with-openid-connect

## Bicep Validation and Linting

The pipeline now includes steps for bicep validation and lint validation. These steps ensure that the bicep files are validated and linted before deployment.

### Steps Added to the Pipeline

1. **Install Bicep CLI**: A step to install the bicep CLI before deploying the bicep file.
2. **Validate Bicep Files**: A step to validate bicep files using `az bicep build`.
3. **Lint Bicep Files**: A step to lint bicep files using `bicep lint`.

These steps help in maintaining the quality and correctness of the bicep files used in the infrastructure deployment.
