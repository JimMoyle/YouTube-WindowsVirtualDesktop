function Add-FslFtaInfo {
    [CmdletBinding()]
    param (
        $extension
    )
   
    process {

        $Path = Join-Path HKLM:\SOFTWARE\Classes\ $extension
        $defaultKey = '(default)'
        $typeKey = 'Content Type'

        $fslPath = $Path.Replace(':', '')

        $r = Get-ItemProperty -Path $Path

        $paramFslRule = @{
            Path         = 'C:\JimM\FTA.fxr'
            RegValueType = 'String'
        }

        Add-FslRule @paramFslRule -ValueData $r.$defaultKey -FullName (Join-Path $fslPath $defaultKey)

        Add-FslRule @paramFslRule -ValueData $r.$typeKey -FullName (Join-Path $fslPath $typeKey)
        
    }

}

$searchText = 'VisioViewer.Viewer'

$items = Get-ChildItem -Path HKLM:\SOFTWARE\Classes\ | Where-Object PSChildName -like '.*'

foreach ($item in $items) {
    $extension = Get-ItemProperty -path $item.pspath | where-Object '(Default)' -eq $searchText | Select-Object -ExpandProperty PSChildname
    Add-FslFtaInfo -extension $extension
}
