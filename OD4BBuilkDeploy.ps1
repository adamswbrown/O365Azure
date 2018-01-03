#Provision OneDrive/PersonalSite for Users that need it provisioned
#This runs slowly so run this overnight
 
#Install-Module -Name AzureAD 
Import-Module AzureAD
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
 
#update and store password as necessary
$logfile2 = 'c:\temp\OneDrivesProvisioned.txt';
 
 
 
#Must be SharePoint Administrator URL
$webUrl = "https://[ORGANIZATION SITE]-admin.sharepoint.com";
 
#MySite web URL
$mysitewebUrl = "https://[ORGANIZATION SITE]-my.sharepoint.com";
 
$username = "GlobalAdmin@contoso.com";
 
#Credential for Office 365 
$mycreds = Get-Credential -Message "Office 365 Credential" -UserName $username
 
 
 
 
#Connect to msolservice to query users
Connect-AzureAD -credential $mycreds;
 
$filter = 'accountEnabled eq true';
$licenseduserList = Get-AzureADUser -All $True -Filter $filter | Where { ($_.AssignedLicenses -ne $Null -and $_.AssignedLicenses.Count -gt 0) -and !($_.UserPrincipalName -like "8*" -or $_.UserPrincipalName -like "9*")} | Sort-Object UserPrincipalName
 
Disconnect-AzureAD
Write-Host "OneDrive Provisioning";
 
 
 
#Connect to SharePoint Online to Provision OneDrive
Connect-SPOService -Url $webUrl -Credential $mycreds
 
Write-Host "Connected to site and Provision Search Started: $webUrl" -ForegroundColor Green;
     
#Test view all sites
#Get-SPOSite
 
     
if ($licenseduserList)
{
         
    $usercount = 1;
    $usersToProvision = @();
    $usersprovisioned = @();
    foreach ($eachuser in $licenseduserList)
    {
 
        #Run OneDrive/PersonalSite Provisioning in batches of 10 
        if ($usercount -gt 10)
        {
            Write-Host "Batch Provisioning OneDrive for users:";
            Write-Host "Users Needing Provision:";
            $usersToProvision;
            Request-SPOPersonalSite -UserEmails $usersToProvision;
            $usersToProvision = @();
            $usercount = 1;
        }
             
        #To enqueue
             
        $onedriveuser = [string]$($eachuser.UserPrincipalName);
        Write-Host $usercount
        #$usersToProvision += $onedriveuser;
        $spouser1 = $null;
        try
        {
            #ignore the current user if no error
            $spouser1 = Get-SPOUser -Site $mysitewebUrl -LoginName $onedriveuser
            $usersprovisioned += $onedriveuser;
        }
        catch
        {
            #users not provisioned with onedrive get caught
            $usersToProvision += $onedriveuser;
            Add-Content $logfile2 $onedriveuser;
            $usercount++;
            #Write-Host $onedriveuser
        }
             
            
          
    }
 
    #Run last batch
    if ($usercount -gt 1)
    {
        Write-Host "Batch Provisioning OneDrive for users:";
        Write-Host "Users Needing Provision:";
        $usersToProvision;
        Request-SPOPersonalSite -UserEmails $usersToProvision;
        $usersToProvision = @();
        $usercount = 1;
    }
}
else 
{
    Write-Host "No Users to Provision";
}
 
Disconnect-SPOService;
 
Write-Host "One Drive Provisioning Completed" ;
 
 
#to Test Provisioning succeeded wait at least a few hours
#Login to Office 365 using an account then hit the url below replacing username as desired
#replace @ symbol and . with underscores in the UserPrincipalName
#https://[ORGANIZATION SITE]-my.sharepoint.com/personal/USERPRINCIPALNAME
