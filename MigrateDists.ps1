#on Soruce tennant
$Groups = Get-DistributionGroup -ResultSize Unlimited 
Foreach ($Group in $Groups) 
{     
 $Members = Get-DistributionGroupMember -Identity $($Group.PrimarySmtpAddress) 
 Foreach ($Member in $Members) 
 { 
 Out-File -FilePath c:\temp\DistributionGroupMember.csv -InputObject "$($Group.DisplayName),$($Member.DisplayName),$($Member.PrimarySMTPAddress)" -Encoding UTF8 -append 
 } 
} 

#On Destination tennat
Import-CSV C:\Temp\DL-Group.csv | ForEach {New-DistributionGroup -Name $_.name -Type $_.Type}
