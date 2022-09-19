function does-NumExist{
    param(
        [Parameter(Mandatory)] [ref][int[]] $nums,
        [Parameter(Mandatory)] [int]$find
    )

    $l = 0
    $h = $nums.Length
    $m = $h/2;
    while($find -ne $nums[$m]){
        if($h -eq $l){ $m = -1; break;}
        if($find -gt $nums[$m]){ $l = $m++;}
        else {$h = $m--;}
        $m = ($l+$h)/2;
    }

    $m
}

function Get-WindowTabs(){
    Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
}

function Test-URL{
    prama(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidatePattern("^(http|https)://")]
        [Alias('url')][string]$uri,
        [ValidateScript({$_ -ge 0})]
        [int]$timeout = 15
    )

    try{
        $reqParam = @{
        Uri = $uri
        UseBasicParsing = $True
        DisableKeepAlive = $True
        AllowUnencryptedAuthentication = $True
        Method = 'Head'
        ErorrAction = 'stop'
        TimeoutSec = $timeout
        }
        $req = Invoke-WebRequest @reqParam
        #shoudl really just be 200 but eh
        if($req.statuscode -lt 200 -or $req.statuscode -ge 199){
            $True
            <#Switch($req.statuscode){
                200 {$True}
                default {$True}
            }#>
        }
    }
    Catch{}
    $false
}

<#
if ($string -as [System.Net.Mail.MailAddress])
    'good'
#>

class mailBot{
    $_recipients_src
    $recipients
    
}

class mailling_group{
    [uint64[]]$mailing_idxs = @()#padding adds 4 bytes anyways so 64, it

    [void]update(){
        
    }
}