$domain = Read-Host 'Enter Domain To Check (domain.com)'
$searchroot = 'https://api.mxtoolbox.com/api/v1/lookup/mx/'
$query = $searchroot+$domain
$q = $query
#Write-host "Query is $($q)"

Write-host "Finding Email Provider for $($domain)" -ForegroundColor Yellow


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Search = Invoke-RestMethod "$q" -Method Get -ContentType JSON -Headers @{'Authorization'= 'MXtoolboxapikeyhere'}
#Test Email

if($Search.EmailServiceProvider -eq "Google Apps")
{

$wshell = New-Object -ComObject Wscript.Shell


$wshell.Popup("Best Guess Email Provider for doamin $($domain) is Google Apps",0,"Done")
Write-host "Email Provider is $($Search.EmailServiceProvider)"

}
elseif ($Search.EmailServiceProvider -eq "Microsoft Office")

{$wshell = New-Object -ComObject Wscript.Shell


$wshell.Popup("Best GuessEmail Provider for doamin $($domain) is Office 365",0,"Done")
Write-host " Email Provider is $($Search.EmailServiceProvider)"

}

if($Search.EmailServiceProvider -eq "Yahoo Biz")
{

$wshell = New-Object -ComObject Wscript.Shell


$wshell.Popup("Best Guess Email Provider for doamin $($domain) is Yahoo Biz",0,"Done")
Write-host "Email Provider is $($Search.EmailServiceProvider)"

}

#Unable to find
elseif (!$Search.EmailServiceProvider)
{
$wshell = New-Object -ComObject Wscript.Shell


$wshell.Popup("Unable to find Email Provider","Done")

Write-host "Unable to find email provider, check URL" -ForegroundColor Red

}

#Asume Exchange with Front end
elseif ($Search.EmailServiceProvider -ne "Microsoft Office" -or "Google Apps")
{
$wshell = New-Object -ComObject Wscript.Shell


$wshell.Popup("Best Guess Email Provider for doamin $($domain) is On Prem Exchange behind $($Search.EmailServiceProvider)",0,"Done",0x1)

Write-host "Email Provider is $($Search.EmailServiceProvider)"

}



# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost")
{
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}
