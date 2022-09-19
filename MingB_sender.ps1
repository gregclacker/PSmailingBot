<#mail maker.
	-no security for mailing account, WILL STORE THE ACCOUNT INFORMATION AND PASSWORD ITS GIVEN AS A TXT FILE
	-if you intend to run this in PowerShell ISE do it from the directory its in
	side note- bad memory pratice: loads all data then pokes through it one at a time, helped it along by deleting what it dosent need anymore as it goes but not a real solution
#>
cls
$settings_dir = '\mailmaker settings'

#sourcing format
function New-WeightedString {
    param (
        [Parameter (Mandatory = $true)] [string]$path,
        [Parameter (Mandatory = $true)] [float]$weight
    )

    new-object psobject -Property @{
        'path' = $path
        'weight' = $weight
        }
}

function throw-exception {
   param (
        [Parameter (Mandatory = $true)] [string]$message
    )
    
    (New-Object -ComObject Wscript.Shell).Popup($message, 0, (get-location).path, 0x1)
    exit
}

<#$wshell = New-Object -ComObject wscript.shell;
$wshell.SendKeys('a')#>

$scr_Dirs; #[weighted string]
$scr_files; #[weighted string]
$mail_to; #'email' = [string]
$mail_subjects; #'subject = [string]
$mail_bodies; #'path' = [string]

$mail_from = @{#could be converted to arr for mutiple emails to mail from but eh
    'from' = 'example@gmail.com'
    'password' = 'subjectively secure password'};

$_files = @{
    'profile' = '.'+ $settings_dir + '\profile.csv'
    'log' = '.'+ $settings_dir + '\mailLog.txt'
    'dirs' = '.'+ $settings_dir + '\sourceFolders.csv'
    'files' = '.'+ $settings_dir + '\sourceFiles.csv'
    'recipients'= '.'+ $settings_dir + '\recipients.csv'
    'subjects' = '.'+ $settings_dir + '\subjectLines.csv'
    'bodies' = '.'+ $settings_dir + '\htmlBodies.csv'
}

#get values or set defaults if no settings folder found
if(-not [system.io.directory]::Exists((Get-Location).Path + $settings_dir))
{
    'settings dne, making new ones...'

    $scr_Dirs = ,(New-WeightedString -path (Get-Location).Path -weight 1)
    $scr_file = ,(New-WeightedString -path (Get-Location).Path -weight 1)
    $mail_to = ,[pscustomobject]@{email="harbingerofemails@gmail.com"} #csv export takes apard the object so unnested strings onld get their length saved
    $mail_subjects = [pscustomobject]@{subject="bot mail"}, [pscustomobject]@{subject="bummer"}

    New-Item -Path ((Get-Location).Path + $settings_dir) -ItemType Directory;

    #read me
    ("how to input info:`n`tThe csv files are tables, the first row are the table keys. each line is a row and commas seperate collums. to leave a colloum blank just leave a comma over it. the profile.csv had additional fields for the rows
        `tkeys:`n`t`tsome csv files dont come with keys. c&p the line after the `":`" into the file if it dosne already have the keys in it.
        `t`tprofile.csv : `"Key`",`"Value`"
        `t`tsourceFolders.csv : `"path`",`"weight`"
        `t`tsourceFiles.csv : `"path`",`"weight`"
        `t`trecipients.csv : `"email`"
        `t`tsubjectLine.csv : `"subject`"
        `t`thtmlBodies.csv : `"path`"
        `t`tmailLog.csv (for user only)
      `nNote
      `t-htmlBodies takes .txt and .html file paths, if txt then it'll be wrapped into html paragraph
      `t-fourceFolders takes folder paths only, files will be picked out of the folder
      `t-sourceFiles takes both file nad folder paths but should a folder be chosen it'll send teh entire folder") | Out-File .\mailmaker_settings\README.txt

    $scr_Dirs | Export-Csv $_files.dirs -NoTypeInformation
    $scr_files | Export-Csv $_files.files -NoTypeInformation
    $mail_to | Export-Csv $_files.recipients -NoTypeInformation
    #$mail_from.GetEnumerator() | select -Property Key,Value | Export-Csv $_files.profile -NoTypeInformation
    $mail_subjects | Export-Csv $_files.subjects -NoTypeInformation
    $mail_bodies | Export-csv $_files.bodies -NoTypeInformation

    'asking for new credientals...'
        $cred = Get-Credential -Message 'no former email credentials found'
        if($cred -eq $null){"`tno credential given"; exit}
        $mail_from.from = $cred.GetNetworkCredential().UserName;
        $mail_from.password = $cred.GetNetworkCredential().Password;#not secure anymore
        $mail_from.GetEnumerator() | select -Property Key,Value | Export-Csv $_files.profile -NoTypeInformation
}
else
{
    'settings folder found, pulling info...'

    try{
        $scr_Dirs = @()
        $scr_Dirs += Import-Csv $_files.dirs | select path
        'source dirs found:' + $scr_Dirs
    } catch { $scr_Dirs = $null; "`tscr_Dris failed import > null" }
    try{
        $scr_files = @()
        $scr_files += Import-Csv $_files.files | select path
        'source files found:' + $scr_files
    } catch { $scr_files = $null; "`tscr_files failed iport > null"}

    
    if($scr_Dirs -eq 0 -and $scr_files -eq 0){
        'sources'
        "`tscr_Dirs:" + $scr_Dirs;
        "`tscr_files:" + $scr_files;
        throw-exception -message 'no given sources or source dne'
    }

    try{
        $mail_to = @()
        $mail_to += Import-Csv $_files.recipients | select email
    } catch {throw-exception -message 'no recipients for mailing found or source dne'}

    #didnt think this through. only way to change emails is to poke at the profile.txt or delete it and it should ask for a new one
    try{
        $mail_from = @{}
        foreach($v in Import-Csv $_files.profile){
            $mail_from[$v.Key] = $v.Value}
    } catch {
        'asking for new credientals...'
        $cred = Get-Credential -Message 'no former email credentials found' #no garbage collection? it should catch this but the ise still says it exists when completely outside of in instances
        $mail_from.from = $cred.GetNetworkCredential().UserName;
        $mail_from.password = $cred.GetNetworkCredential().Password;#not secure anymore
        if($mail_from.password -eq $null -or $mail_from.password.Length -eq 0){throw-exception -message "No password given.`nTry restart or delete the settings folder."}
        $mail_from.GetEnumerator() | select -Property Key,Value | Export-Csv $_files.profile -NoTypeInformation
    }

    try{
        $mail_subjects = Import-Csv $_files.subjects | select subject
    }catch {$mail_subjects += 'sentences, not file paths'; 'mail_subjects imported empty'}

    try{
        $mail_bodies = Import-Csv $_files.bodies | select paths
    }catch{$mail_bodies = @(); 'mail_bodies failed import'}#cant be null
}

'searching for duplicat/invalid info...'

#checks & removes invalid atachments
$w = 0
$w = $scr_Dirs.count + $scr_files.count + $mail_bodies.count

$mail_bodies = @($mail_bodies | ?{($_ -like "*.txt") -or ($_ -like "*.html")})

$scr_files = @($scr_files | ?{$_ -ne $null -and [system.io.file]::Exists($_.path)})

$scr_Dirs = @($scr_Dirs | ?{$_ -ne $null -and [system.io.directory]::Exists($_.path)})

if($w -ne $scr_Dirs.count + $scr_files.count + $mail_bodies.count)
{
    "`tfaulty info removed:" + ($w - $scr_Dirs.count + $scr_files.count + $mail_bodies.count)
    $mail_bodies | Export-csv $_files.bodies -NoTypeInformation
    $scr_Dirs | Export-Csv $_files.dirs -NoTypeInformation
    $scr_files | Export-Csv $_files.files -NoTypeInformation
}
else {"`tno invalid paths found :)"}

if(($scr_files -ne $null -or $scr_files.Count -gt 0) -and ($scr_Dirs -ne $null -or $scr_Dirs.Count -gt 0)){
        'remaining'
        "`tscr_Dirs:" + $scr_Dirs;
        "`tscr_files:" + $scr_files;
        "`tw:" + $w
        "`tcount:" + $scr_Dirs.count + $scr_files.count + $mail_bodies.count
        "`t"+ '$w-count:' + ($w - ($scr_Dirs.count + $scr_files.count + $mail_bodies.count))
        throw-exception -message 'there are no valid sources to use'
}

#random attachemnt
if($scr_files.Count -ne $null -and $scr_files.Count -gt 0){
    $w = ($scr_files | Measure-Object -Property weight).Sum }
else{
    $w = 0}
if($scr_Dirs -ne $null -and $scr_Dirs.Count -gt 0){
    "scr_Dirs:" + $scr_Dirs.Count
    $w += ($scr_Dirs | Measure-Object -Property weight).Sum }

'randomizeing attachment'
"`tmax weight:" + $w

$w = Get-Random -Maximum $w -Minimum 0

"`ttotal weight:" + $w;

$attachment_path;

foreach($v in (($scr_Dirs + $scr_files) | Get-Random -Count (($scr_Dirs + $scr_files).Count))){
    $attachment_path = $v.path
    ?($w -lt $v.weight){
        break
    }
    $w -= $v.weight
}
"attachemnt path:`t" + $attachment_path

#clean up
$scr_Dirs = $null
$scr_files = $null
$w = $null


#random subject
"randomizing subject"
$subject = ""
if($mail_subjects -eq $null -or $mail_subjects.length -eq 0){
    "`tno subject found"
}
else{
    $subject = $mail_subjects | Get-Random -Maximum $mail_subjects.length
}

#clean up
$mail_subjects = $null

#random html body
"randomizing body"
$body
if($mail_bodies -eq $null -or $mail_bodies.length -eq 0){
    $body = $null
    "`tno body found"
}
else{
    $body = $mail_bodies | select path | Get-Random -Maximum $mail_bodies.length
    if($body -like "_*.html"){
        $body = Get-Content $body -Raw
    }else{
        if($body -like "_*.txt"){
            $body = "<html><body><p>" + (Get-Content $body -Raw) + "</p></body></html>"
        }
    }
}

#clean up
$mail_bodies = $null


#make credential
"using credentials-"
"`tuserName:`t" + $mail_from.from
"`tpassword:`t" + $mail_from.password
$credentials = New-Object System.Management.Automation.PSCredential ($mail_from.from, (ConvertTo-SecureString $mail_from.password -AsPlainText -Force))

#clean up
$mail_from = $null

#send mail
"sending to..."
Send-MailMessage -From ("Mail Bot <"+$mail_from.from + ">") -To $mail_subjects[0] -Bcc $mail_to -Subject $subject -BodyAsHtml ("@``" + $body + "``@") -Attachments $attachment_path -DeliveryNotificationOption OnSuccess, OnFailure -Credential $credentials

#record log
"saving to log..."
Add-Content $_files.log ("<" +
"`nto:`"" + $mail_to + "`"" +
"`nbody:`"" + $body + "`"" +
"`ndate:`"" + (get-date).Date + "`"" +
"`nfrom:`"" + $mail_from.from + "`"" +
"`nsubject:`"" + $subject + "`"" +
"`nattachment:`"" + $attachment_path + "`"" +
"`n>")

<#Sleep 0.1
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('Windows PowerShell credential request')
$wshell.SendKeys('~ arg arg arg i own C poitn. !~ attack the D point!!')#>


#ports: 25 is default unencripted, 587 is for encrypted
#smptServer: defaults to '$PSEmailServer' is unassigned

throw-exception -message ("email bot has sent the file:`n`t" + $attachment_path + "`nto:`n`t" + $mail_to + "`nfrom:`n`t" + $mail_from.from)

#somethign to check if the attachment path is fiel or directory, if directory grab a file. and all paths in scr_dirs must actually havea a file in them
#put mail_to in BCC