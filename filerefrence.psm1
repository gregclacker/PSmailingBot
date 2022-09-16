$dir_mailBot = 'mailignbot'
$csv_recipients = 'recip'
$ShTask_name = 'mingBv'
$url = @{
    mailbotcli=""
    launcher=""
}


function Get-WindowTabs(){
    Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
}

<#
        with help from: https://petri.com/testing-uris-urls-powershell/
        -dont really understand most of whats happening and where hes pulling these variable names form.
            none of the https manuals sayanyhting about the names of those things
#>
function test-url{
    [cmdletbinding(DefaultParameterSetName="Default")]
    Param(
        [Parameter(Position=0,Mandatory,HelpMessage="Enter the URI path starting with HTTP or HTTPS",
        ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidatePattern( "^(http|https)://" )]
        [Alias("url")]
        [string]$URI,
        [Parameter(ParameterSetName="Detail")]
        [Switch]$Detail,
        [ValidateScript({$_ -ge 0})]
        [int]$Timeout = 10
    )

    Try {
     #hash table of parameter values for Invoke-Webrequest
     $paramHash = @{
     UseBasicParsing = $True
     DisableKeepAlive = $True
     Uri = $uri
     Method = 'Head'
     ErrorAction = 'stop'
     TimeoutSec = $Timeout
    }
    $test = Invoke-WebRequest @paramHash
    if($Detail){
        $test.BaseResponce | select ResponceURL,ContentType,LastModified,
            @{Name="Status";Expression={$test.StatusCode}}
    }
    else{
        
    }
}