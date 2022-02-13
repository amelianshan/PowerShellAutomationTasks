$CreateEXOPSSession = (Get-ChildItem -Path $env:userprofile -Filter CreateExoPSSession.ps1 -Recurse -ErrorAction SilentlyContinue -Force | Select -Last 1).DirectoryName
. "$CreateEXOPSSession\CreateExoPSSession.ps1"

#After above script finished running, run below scripts
$cred = get-credential 
Connect-MsolService -Credential $cred 
Connect-EXOPSSession -UserPrincipalName username@email.com 
Connect-AzureAD
#Enable MFA
 $auth = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$auth.RelyingParty = "*"
$auth.State = "Enabled"
Set-MsolUser -UserPrincipalName username@email.com -StrongAuthenticationRequirements $auth
#Disable MFA
$mf= New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$mf.RelyingParty = “*”
$mfa = @($mf)
$mfa = @()
Set-MsolUser -UserPrincipalName username@email.com -StrongAuthenticationRequirements $mfa


$users =  import-csv -Path D:\MFAUsers.csv
foreach ($user in $users){
    $UserEmail = $user.EmailAddress
    Get-msoluser -UserPrincipalName $UserEmail | select DisplayName,@{N='Email';E={$_.UserPrincipalName}},@{N='StrongAuthenticationRequirements';E={($_ | Select -ExpandProperty StrongAuthenticationRequirements)}}
  #$auth = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
   #$auth.RelyingParty = "*"
#$auth.State = "Enabled"
#Set-MsolUser -UserPrincipalName $UserEmail -StrongAuthenticationRequirements $auth
   
    }

#$Status = 'StrongAuthenticationRequirements'
#Check User enable or not, if enabled, shows MOASR, if not, show nothing.
Get-msoluser -UserPrincipalName username@email.com | select DisplayName,@{N='Email';E={$_.UserPrincipalName}},@{N='StrongAuthenticationRequirements';E={($_ | Select -ExpandProperty StrongAuthenticationRequirements)}}

Get-PSSession | Remove-PSSession
