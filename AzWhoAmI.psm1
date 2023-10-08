function Get-AzUpn {
    <#
    .SYNOPSIS
        WhoAmi for Azure CloudShell
    .DESCRIPTION
        AzWhoAmI is a PowerShell module that provides a WhoAmI function for Azure CloudShell, returning the UPN of the current user.
    .OUTPUTS
        System.String
    .EXAMPLE
        PS C:\> Get-AzUpn

        admin@contoso.com
    .EXAMPLE
        PS C:\> WhoAmI

        admin@contoso.com
    .NOTES
        This only works in Azure Cloud Shell, including Azure Cloud Shell running inside Windows Terminal.
    .LINK
        https://github.com/sassdawe/AzWhoAmI/
    #>
    [cmdletbinding()]
    [alias("Get-WhoAmI")]
    [alias("WhoAmI")]
    [alias("AzWhoAmI")]
    param()
    $response = $(curl http://localhost:50342/oauth2/token --data "resource=https://management.azure.com/" -H Metadata:true -s)
    if ( [string]::IsNullOrEmpty($response) ) {
        Write-Error "Failed to get token from Azure Instance Metadata Service"
        return
    } else {
        $token = $response | ConvertFrom-Json | Select-Object -exp  access_token
        foreach ($i in 0..1) {
            $data = $token.Split('.')[$i].Replace('-', '+').Replace('_', '/')
            switch ($data.Length % 4) {
                0 { break }
                2 { $data += '==' }
                3 { $data += '=' }
            }
        }
        $decodedToken = [System.Text.Encoding]::UTF8.GetString([convert]::FromBase64String($data)) | ConvertFrom-Json
        return $decodedToken.upn
    }

}

Export-ModuleMember -Function Get-AzUpn -Alias 'Get-WhoAmI', 'WhoAmI', 'AzWhoAmI'