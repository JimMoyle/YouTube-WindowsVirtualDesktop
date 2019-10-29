Import-Module 'D:\PoSHCode\GitHub\FSLogix.Powershell.Rules\FSLogix.PowerShell.Rules\FSLogix.PowerShell.Rules.psd1' -Force

#changable variables
$regfile = "S1E2\vstx.reg"
$ext = '.vstx'

#Non changeable variables
$defaultKey = '(default)'
$typeKey = 'Content Type'
$path = "[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\$ext]"

#Create path format that FSLogix file uses
$fslPath = $path.replace('[HKEY_LOCAL_MACHINE','HKLM').Replace(']','')

#Grab the relevant lines from the file
$content = Get-Content -Path $regfile | Select-String $path -context 2 -SimpleMatch

#Grab content from the lines
$defaultValue = ($content.context.PostContext[0] -split '=')[1].Replace('"','')
$typeValue = ($content.context.PostContext[1] -split '=')[1].Replace('"', '')

#set commom parameters
$paramFslRule = @{
    Path         = 'C:\JimM\FTA.fxr'
    RegValueType = 'String'
}

#set and add rules
Set-FslRule @paramFslRule -ValueData $defaultValue -FullName (Join-Path $fslPath $defaultKey)
Add-FslRule @paramFslRule -ValueData $typeValue -FullName (Join-Path $fslPath $typeKey)