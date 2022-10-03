<#
    everything needed to read the mail bot data, basically the root header file
    used in both MailBot.ps1 and launcher.ps1
#>

class _files{
    static [string] $version = '1'
    
    static [string] $source = '.PSMailBot'
    static [string] $log = '.log.txt'

    static [string] $profile = 'profile.txt'
    static [string] $settings = 'settings.txt'
    static [string] $mailingGroups = 'mailing groups.txt'
    static [string] $subjects = 'subjects.txt'
    static [string] $htmlBodies = 'html bodies.txt'
    static [string] $files = 'files.txt'

    <#static [void]setAppData([string]$newPath){
        
        [_files]::appdata = $newPath
        [_files]::source = $newPath + '\' + (Split-Path -Path ([_files]::source) -Leaf)
        [_files]::profile = $newPath + '\' + (Split-Path -Path ([_files]::profile) -Leaf)
        [_files]::log= $newPath + '\' + (Split-Path -Path ([_files]::log) -Leaf)
        [_files]::settings = $newPath + '\' + (Split-Path -Path ([_files]::settings) -Leaf)
        [_files]::mailingGroups = $newPath + '\' + (Split-Path -Path ([_files]::mailingGroups) -Leaf)
        [_files]::subjects = $newPath + '\' + (Split-Path -Path ([_files]::subjects) -Leaf)
        [_files]::htmlBodies = $newPath + '\' + (Split-Path -Path ([_files]::htmlBodies) -Leaf)
        [_files]::files= $newPath + '\' + (Split-Path -Path ([_files]::files) -Leaf)
    }#>
}

function Get-WindowTabs(){
    Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
}

function Test-URL{
    prama(
        [ValidatePattern("^(http|https)://")]
        [string]$uri,
        [ValidateScript({$_ -ge 0})]
        [int]$timeout = 15
    )

    $uri = "https://github.com/gregclacker/PSmailingBot"

    if(($uri -notlike "http://*") -and ($uri -notlike "https://*")){
        return $false;
    }

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

class mailingBot{
    [string]$profile_name
    [System.Management.Automation.PSCredential]$credentals
    $mailingGroups = @()
    $files = @()
    $subjects
    $htmlbodies

    mailBot([string]$name){
        $this.profile_name = $name
        if([System.IO.Directory]::Exists($env:APPDATA + [_files]::source + "\" + $name)){
            if([System.IO.File]::Exists([_files]::)
        } else {
            
        }
    }

    [void]promptCred(){
        $username = 'username'
        if($this.credentals -ne $null -and $this.credentals.UserName -ne $null){ $username = $this.credentals.UserName }

        $this.credentals = Get-Credential -UserName $username -Message ("Email for mail bot: " + $this.profile_name)
    }

    [bool]SendMail(){
        
        return $true;
    }
}

class mailling_group{
    [uint64[]]$mailing_idxs = @()#padding adds 4 bytes anyways so 64, it

    
}

function Get-MailBots{
    
}