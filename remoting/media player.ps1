$scr
$res = "C:\Users\Public\rmdResource.csv"

function get-vidTime {
   param (
        [Parameter (Mandatory = $true)] [string]$path
    )
    
    $wmplayer = New-Object System.Windows.Media.MediaPlayer;
    $wmplayer.Open($path);
    Start-Sleep 2;
    $t = $wmplayer.NaturalDuration.TimeSpan.Seconds;
    $wmplayer.Close();
    $t
}

function get-vids {
   param (
        [Parameter (Mandatory = $true)] [string]$path
    )
    
    Get-ChildItem $path | ?{$_.Name -like "*.mp4" -or $_.Name -like "*.mp3" -or $_.Name -like "*.wav"} | %{$_.Name = $path + $_.Name}
}

function new-source{
    param (
        [Parameter (Mandatory = $true)] [string]$path
    )

    new-object psobject -Property @{
        path = $path
        time = (get-vidTime -path $path)
        }
}

if([system.io.file]::Exists($res[0..($res.Length - 5)])){
    `$scr = Import-Csv $res | Get-Random -Count 1
} else {
     $scr = ,([pscustomobject]@{path="filler"
     time=0})
     $scr | Export-Csv $res -NoTypeInformation
     (Get-Item -Path $res -Force).Attributes='Hidden'
     $scr = @()
}

if($scr.Count -eq 0){
    $scr = (get-vids -path 'C:\Users\Public');
    $scr | Export-Csv $res -NoTypeInformation
}else {
    if((get-vids -path 'C:\Users\Public').count -ne $scr.Count){
        (get-vids -path 'C:\Users\Public') | ?{-not @($scr | select path).Contains($_)} | %{$v = new-source -path $_; $scr += $v; Add-Content $res ($v)}
    }
}
$scr = $scr | Get-Random -Count 1

$player = new-object -com WMPLAYER.OCX
$player.openplayer($scr.path)

Start-Sleep ($scr.time + 1)
Stop-Process -Name "wmplayer" -Force