function Add-FslFtaInfo {
    [CmdletBinding()]
    param (
        [Parameter(
            ValuefromPipeline = $true
        )]
        $extension,
        
        $outPath
    )
   
    process {

        $Path = Join-Path HKLM:\SOFTWARE\Classes\ $extension
        $defaultKey = '(default)'
        $typeKey = 'Content Type'

        $fslPath = $Path.Replace(':', '')

        $r = Get-ItemProperty -Path $Path

        $paramFslRule = @{
            Path         = $outPath
            RegValueType = 'String'
        }

        Add-FslRule @paramFslRule -ValueData $r.$defaultKey -FullName (Join-Path $fslPath $defaultKey)
        Add-FslRule @paramFslRule -ValueData $r.$typeKey -FullName (Join-Path $fslPath $typeKey)
        
    }

}

Import-Module 'D:\PoSHCode\GitHub\FSLogix.Powershell.Rules\FSLogix.PowerShell.Rules\FSLogix.PowerShell.Rules.psd1' -Force

$searchText = 'txtfile'
$outPath = 'C:\JimM\FTA.fxr'

$items = Get-ChildItem -Path HKLM:\SOFTWARE\Classes\ | Where-Object PSChildName -Like '.*'

foreach ($item in $items) {
    $extension = Get-ItemProperty -path $item.pspath |
        where-Object '(Default)' -Match $searchText |
        Select-Object -ExpandProperty PSChildname |
        Add-FslFtaInfo -outPath $outPath
}
