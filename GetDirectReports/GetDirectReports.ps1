#Connect-AzureAD
#Connect-MsolService



Function getDirectreport($name){

    $directReports = @()
    $objectID = get-msoluser -UserPrincipalName $name | Select-Object -expandproperty ObjectID


   

    
    $directReportNames = Get-AzureADUserDirectReport -ObjectId $objectID | Select-Object -ExpandProperty UserPrincipalName

    $directReports += $directReportNames


     if($directReports.Count -eq 0){
        
        return

    }else{

        Write-Host $name, $directReportNames
        
        $directReportNames |   Out-File -Append c:\result.csv

        foreach($directReport in $directReports){

            
           getDirectreport($directReport)



        }




    }

    

}

getDirectreport("hua.huang@fountain-med.com")