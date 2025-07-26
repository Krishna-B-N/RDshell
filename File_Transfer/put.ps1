function global:put{
param(
    [String]$file
)
$path=(Get-Location).Path+"\"+$file
Invoke-WebRequest -Uri "http://$IPP/$file" -OutFile "$path"
}