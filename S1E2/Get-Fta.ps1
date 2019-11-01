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

Import-Module 'C:\PoShCode\FSLogix.Powershell.Rules\FSLogix.PowerShell.Rules\FSLogix.PowerShell.Rules.psd1'

$searchText = 'VisioViewer.Viewer'
$outPath = 'C:\JimM\FTA.fxr'

$items = Get-ChildItem -Path HKLM:\SOFTWARE\Classes\ | Where-Object PSChildName -like '.*'

foreach ($item in $items) {
    Get-ItemProperty -path $item.pspath | where-Object '(Default)' -eq $searchText | Select-Object -ExpandProperty PSChildname | Add-FslFtaInfo -outPath $outPath
}
