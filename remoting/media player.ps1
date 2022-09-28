$filepath = "C:\Users\Owner\desktop\disappear.mp4"

#Here we use your code to get the duration of the video
$wmplayer = New-Object System.Windows.Media.MediaPlayer
$wmplayer.Open($filepath)
Start-Sleep 2 
$duration = $wmplayer.NaturalDuration.TimeSpan.Seconds
$wmplayer.Close()

#Here we just open media player and play the file, with an extra second for it to start playing
$proc = Start-process -FilePath wmplayer.exe -ArgumentList $filepath -PassThru
Start-Sleep ($duration + 1)

#Here we kill the media player
Stop-Process $proc.Id -force