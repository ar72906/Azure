#Obtains the environment for Public Azure and add it to a variable
$env = Get-AzureRMEnvironment -Name AzureCloud

#Login to Azure
#Add-AzureRMAccount -EnvironmentName $env

#List Subscription name, Subscriptionid and tenantid
Get-AzureRmSubscription -SubscriptionId “7e6f18b7-120e-4fb8-aa7e-a71151cec09d"

#Change to the JebBlue Subscription
Select-AzureRmSubscription -SubscriptionName "JB-SelfService" -TenantId “d9217073-9527-487c-9687-b6bbd93ed621”

#Create the variables for the ARM Deployment
$ExtensionName = "MicrosoftMonitoringAgent"
$VMName = "JBMCLMTEST9100"
$RGName = "JB-test-temp"
$templateFile = "C:\Temp\azuredeploy.json"
$templateParameterFile = "C:\Temp\azuredeploy.parameters.json"

#Run the ARM deployment
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile $templateFile -TemplateParameterFile $templateParameterFile

#Check to see if the ARM Extension was installed.
Get-AzureRmVMExtension -ResourceGroupName $RGName -VMName $VMName -Name $ExtensionName 
