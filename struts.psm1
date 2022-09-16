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