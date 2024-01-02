Connect-AzAccount

$githubOrganizationName = 'jone-aarre'
$githubRepositoryName = 'reusable-bicep-code'

$applicationRegistration = New-AzADApplication -DisplayName 'toy-reusable'
New-AzADAppFederatedCredential `
   -Name 'toy-reusable-branch' `
   -ApplicationObjectId $applicationRegistration.Id `
   -Issuer 'https://token.actions.githubusercontent.com' `
   -Audience 'api://AzureADTokenExchange' `
   -Subject "repo:$($githubOrganizationName)/$($githubRepositoryName):ref:refs/heads/main"

$resourceGroup = New-AzResourceGroup -Name ToyReusable -Location norwayeast

New-AzADServicePrincipal -AppId $applicationRegistration.AppId
New-AzRoleAssignment `
    -ApplicationId $applicationRegistration.AppId `
    -RoleDefinitionName Contributor `
    -Scope $resourceGroup.ResourceId

$azureContext = Get-AzContext
Write-Host "AZURE_CLIENT_ID: $($applicationRegistration.AppId)"
Write-Host "AZURE_TENANT_ID: $($azureContext.Tenant.Id)"
Write-Host "AZURE_SUBSCRIPTION_ID: $($azureContext.Subscription.Id)"