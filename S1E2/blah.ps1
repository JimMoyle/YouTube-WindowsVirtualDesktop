$Path = 'HKLM:\SOFTWARE\Classes\.vsdx'
$defaultKey = '(default)'
$typeKey = 'Content Type'

$fslPath = $Path.Replace(':','')

$r =  Get-ItemProperty -Path $Path

$paramFslRule =@{
    Path = 'C:\JimM\FTA.fxr'
    RegValueType = 'String'
}

Set-FslRule @paramFslRule -ValueData $r.$defaultKey -FullName (Join-Path $fslPath $defaultKey)

Add-FslRule @paramFslRule -ValueData $r.$typeKey -FullName (Join-Path $fslPath $typeKey)