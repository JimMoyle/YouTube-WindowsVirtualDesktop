#Only needed to be run if the Aplications are installedd to the same directory

$fileName = 'Office2016.xml'
$fileName = 'Project2016.xml'
$fileName = 'Visio2016.xml'

Get-ChildItem 'C:\Program Files\Microsoft Office' -Recurse -File | Export-Clixml $fileName

#Run after you have collected the files

$path = 'D:\PoSHCode\GitHub\YouTube-WindowsVirtualDesktop\SampleFiles'

$files = Get-ChildItem $path *.fxr | Select-Object -ExpandProperty FullName

$outputPath = Join-Path $path 'Output'

New-Item $outputPath -ItemType Directory

Compare-FslRuleFile -Files $files -OutputPath $outputPath