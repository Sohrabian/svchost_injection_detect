$svc = Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost\'
$svc_export = foreach ($a in $svc.Property) {
	
	[PSCustomObject]@{    ##using the pscustomeobject we define a table fields Name, Value of The Name. actually the Name reffered to the Service Group
		Name = $a
		Value = $svc.Getvalue($a)
	}

#$svc_export
#$svc_export.Value

$final_value = (compare-object -Referenceobject ($svc_export.value) -Differenceobject (Get-Content -Path '.\svchost (2).txt'))
$final_value

}