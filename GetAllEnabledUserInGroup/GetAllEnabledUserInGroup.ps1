#Get all enabled user in a group

$Groups = Import-Csv D:\groups.csv
$result = @()

foreach($group in $groups){

    $group = $group.Name
    #Include only domain groups
    if($group -like "*DomainSuffix*" ){
            
            

            $groupnamelength = $group.Length

            $groupname = $group.Substring(13)

            echo $groupname

            $EnableUsers = Get-ADGroupMember $groupname -Recursive | Where {$_.objectClass -eq "user"} | Get-ADUser  | where {$_.enabled -eq $true} | Select-Object -ExpandProperty SamAccountName

            

            
            foreach($enableuser in $EnableUsers){

                $description = Get-ADUser -Identity $enableuser -Properties Description | Select-Object -ExpandProperty Description

                $row = New-Object System.Object
                $row | Add-Member -MemberType NoteProperty -Name "group" -Value $groupname
                $row | Add-Member -MemberType NoteProperty -Name "user" -Value $enableuser
                $row | Add-Member -MemberType NoteProperty -Name "description" -Value $description

                $result += $row

            }
            

            #$Groups = Get-ADGroupMember $group.Name | Where {$_.objectClass -eq "Group"}
            

            #$result.GetEnumerator()| Select-Object -Property Name, Value | Export-Csv -NoTypeInformation -Append C:\GroupMemberResult.csv
    }

    
   # % { $path1 = $group; $AllgroupMembers }  | % { $_.access | Add-Member -MemberType NoteProperty '.\Application Data' -Value $path1 -passthru }

}

$result | Export-Csv -NoTypeInformation D:\GroupResult.csv