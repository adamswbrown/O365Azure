#The user that will get a license
$UserToLicense = Get-AzureADUser -ObjectId "johan@businesscocnut.co.uk"

#####
#Options for Enabled Plans (Taken from Ent E3)
#Run Get-AzureADSubscribedSku
# See https://blogs.technet.microsoft.com/treycarlee/2014/12/09/powershell-licensing-skus-in-office-365/ for full list
#Office 365 Enterprise E3 | ENTERPRISEPACK

#EXCHANGE_S_STANDARD	Exchange Online (Plan 2)
#MCOSTANDARD	Lync Online (Plan 2)
#SHAREPOINTENTERPRISE	SharePoint Online (Plan 2)
#SHAREPOINTWAC	Office Online
#OFFICESUBSCRIPTION	Office ProPlus
#RMS_S_ENTERPRISE	Azure Active Directory Rights Management
#YAMMER_ENTERPRISE	Yammer


 
#Define the plans that will be enabled (Exchange Online, Skype for Business and Office 365 ProPlus )
$EnabledPlans = 'EXCHANGE_S_ENTERPRISE','MCOSTANDARD','OFFICESUBSCRIPTION'
#Get the LicenseSKU and create the Disabled ServicePlans object
$LicenseSku = Get-AzureADSubscribedSku | Where-Object {$_.SkuPartNumber -eq 'ENTERPRISEPACK'} 
#Loop through all the individual plans and disable all plans except the one in $EnabledPlans
$DisabledPlans = $LicenseSku.ServicePlans | ForEach-Object -Process { 
  $_ | Where-Object -FilterScript {$_.ServicePlanName -notin $EnabledPlans }
}
 
#Create the AssignedLicense object with the License and DisabledPlans earlier created
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = $LicenseSku.SkuId
$License.DisabledPlans = $DisabledPlans.ServicePlanId
 
#Create the AssignedLicenses Object 
$AssignedLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$AssignedLicenses.AddLicenses = $License
$AssignedLicenses.RemoveLicenses = @()
 
#Assign the license to the user
Set-AzureADUserLicense -ObjectId $UserToLicense.ObjectId -AssignedLicenses $AssignedLicenses
