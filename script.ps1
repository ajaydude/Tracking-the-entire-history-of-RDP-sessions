$RDPAuths = Get-WinEvent -LogName 'Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational' -FilterXPath @'
<QueryList><Query Id="0"><Select>
  *[System[EventID=1149]]
</Select></Query></QueryList>
'@ 

# Get specific properties from the event XML
[xml[]]$xml=$RDPAuths|Foreach{$_.ToXml()}
$EventData = Foreach ($event in $xml.Event) { 
  # Create custom object for event data
  New-Object PSObject -Property @{  
    TimeCreated = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm:ss K')
    User   = $event.UserData.EventXML.Param1
    Domain = $event.UserData.EventXML.Param2
    Client = $event.UserData.EventXML.Param3
  }
}
$EventData | FT
