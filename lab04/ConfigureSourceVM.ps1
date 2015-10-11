Configuration ConfigureSourceVM
{
  param ($MachineName)

  Node $MachineName
  {
	Script ConfigureSourceVM { 
		SetScript = { 
			                    
        $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
        $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
        Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
        Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
        # Stop-Process -Name Explorer
        
        $regpath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\'
        $x= get-item -Path $regpath
        $pname = 'LocalAccountTokenFilterPolicy'
        New-ItemProperty $regpath -Name $pname -Value 1 -PropertyType "Dword" 
        
        $dir = "c:\Source"
        New-Item $dir -ItemType directory
        		    
        } 

		TestScript = { 
		#	if ($x.GetValue("$pname") -eq $null) {return $false} else {return $true}
        Test-path c:\source
		}  
		GetScript = { <# This must return a hash table #> }          }   
  }
} 