#Obtains the environment for Public Azure and add it to a variable
$env = Get-AzureRMEnvironment -Name AzureCloud

#Login to Azure
Add-AzureRMAccount -Environment $env

#List Subscription name, Subscriptionid and tenantid
Get-AzureRmSubscription -SubscriptionId “7e6f18b7-120e-4fb8-aa7e-a71151cec09d"

#Change to the JebBlue Subscription
Select-AzureRmSubscription -SubscriptionName "JB-SelfService" -TenantId “d9217073-9527-487c-9687-b6bbd93ed621”

#Get list of servers and group names from a csv file
$serversrgrouplist = Import-Csv -LiteralPath C:\temp\ServerList.csv
#$serversrgrouplist = $serversrgrouplist | Select-Object -First 1

#Function to install the OMS agent using a list of servers and resource groups in a csv file
Function Install-OMSAgent {

#Loop through the list of servers and groups and install the oms agent
foreach ($serverrgroup in $serversrgrouplist)  {

#convert the server name and group name into a variable
$server = $serverrgroup.Name
$resourcegroup = $serverrgroup.rgroup

#Get the json parameter file and change the server name value to the next one in the loop
$templateParameterFile = Get-Content -Path "C:\temp\azuredeploy.parameters Template.json"
$templateParameterFile = $templateParameterFile -replace 'TestVM', "$server"
$templateParameterFile | Out-File -Force "C:\temp\azuredeploy.parameters.json"

#Kick off the Azure Extension installation
$ExtensionName = "MicrosoftMonitoringAgent"
$templateFile = "C:\Temp\azuredeploy.json"
$templateParameterFile = "C:\Temp\azuredeploy.parameters.json"
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourcegroup `
    -TemplateFile $templateFile `
      -TemplateParameterFile $templateParameterFile

#validate that the oms agent was successfully installed on the VM
Get-AzureRmVMExtension -ResourceGroupName $resourcegroup -VMName $server -Name $ExtensionName

}

}

Install-OMSAgent  
