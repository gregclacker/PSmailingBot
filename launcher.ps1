Using module ".\filerefrence.psm1"
#Add-Type -AssemblyName System.Windows.MessageBox
#(New-Object -ComObject Wscript.Shell).Popup( "note!!!", 0, (get-location).path, 0x1)

funciton Test-URL{
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

Write-Host "srcdir form roaming:`t" $dir_mailBot
if(-not (Test-Path -Path ($env:APPDATA+$dir_mailBots))){
    $message = "Could not find a previous set up at..n`t$env:APPDATA`nWould you like to create a new one?`n--selecting `"No`" will cancel the boot"

    $responce = [System.Windows.MessageBox]::Show($message, "Mail Bot Launcher", 'YesNo', 'Question')
    switch($responce){
        1{[System.IO.Directory]::CreateDirectory($env:APPDATA+$dir_mailBot)
            [System.Media.SystemSounds]::Beep.Play()}
        6{[System.IO.Directory]::CreateDirectory($env:APPDATA+$dir_mailBot)
            [System.Media.SystemSounds]::Asterisk.Play()}
        7{[System.Media.SystemSounds]::Exclamation.Play()
            exit}
    }
}


PowerShell.exe -File 'D:\bucke\Documents\mail bot\mailbotcli.ps1' -ExecutionPolicy Bypass