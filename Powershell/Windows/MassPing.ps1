## Pulls in a txt file of hosts and pings them once to see if they're online - writes output to host ##

$ServerName = Get-Content "C:\scripts\serverhosts.txt"  
  
$output = foreach ($Server in $ServerName) {  
  
        if (Test-Connection -ComputerName $Server -Count 1 -Quiet) {   
          
            write-host $Server is Online
          
                    } 
                    
        else{

            write-host $Server is Offline 

                    }      
          
} 
