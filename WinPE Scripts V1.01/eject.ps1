$Diskmaster = New-Object -ComObject IMAPI2.MsftDiscMaster2
$DiskRecorder = New-Object -ComObject IMAPI2.MsftDiscRecorder2
$DiskRecorder.InitializeDiscRecorder($DiskMaster)
$DiskRecorder.EjectMedia()