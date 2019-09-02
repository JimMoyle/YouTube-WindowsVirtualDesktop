$path = 'D:\PoSHCode\GitHub\YouTube-WindowsVirtualDesktop\SampleFiles\Output'
$path = 'D:\JimM\YT'

#Only needed to be run if the Aplications are installedd to the same directory

$fileName = 'Office2016.xml'
$fileName = 'Project2016.xml'
$fileName = 'Visio2016.xml'

Get-ChildItem 'C:\Program Files\Microsoft Office' -Recurse -File | Export-Clixml $fileName

#Below steps are for all situations
#Run after you have collected the files

#Grab full paths to fxr files
$files = Get-ChildItem $path *.fxr | Select-Object -ExpandProperty FullName

#create variable with path to output
$outputPath = Join-Path $path 'Output'

#Create Output directory
New-Item $outputPath -ItemType Directory

#Create new hiding and redirect rule files in output
Compare-FslRuleFile -Files $files -OutputPath $outputPath

##IMPORTANT##
#The below steps are only needed if the applications are installed to same directory

#Open new Project 2016 hiding file and remove install directory, GUI method
Invoke-Item "$path\Project2016_Hiding.fxr"

#Open new Visio 2016 hiding file and remove install directory, PowerShell method
Remove-FslRule -Name '%ProgramFilesFolder64%\Microsoft Office' -Path "$path\Visio2016_Hiding.fxr"

#Grab xml file paths
$xmlFiles = Get-ChildItem $path *.xml | Select-Object -ExpandProperty FullName

#Create hiding rules for the unique application files
Compare-FslFilePath -Files $xmlFiles -OutputPath $path

#Open new files in GUI to show contents
Invoke-Item (Get-ChildItem $path *_uniquehiding.fxr).FullName

#Copy and paste rules from uniquehidingfile to previous hiding file in GUI for Project

#Copy and paste rules for Visio from uniquehidingfile to previous hiding file using PowerShell
Get-FslRule -Path "$path\Visio2016_UniqueHiding.fxr" | Add-FslRule -Path "$path\Visio2016_Hiding.fxr"

##End of commands only if the applications are installed to the same directory

#Copy Project rules files to VM

#Use GUI in VM to add assignments

#Add assignments to hiding rule
Set-FslAssignment -Path "$path\Visio2016_Hiding.fxa" -GroupName Everyone -RuleSetApplies

Add-FslAssignment -Path "$path\Visio2016_Hiding.fxa" -GroupName VisioGroup

#Using previously gathered data about Visio files, find all the executables and put them in an object with property name 'ProcessName'.
$visioFiles = Import-Clixml -Path "$path\Visio2016.xml" | 
    Where-Object 'Extension' -eq '.exe' | 
    Select-Object -Property @{n='ProcessName';e={$_}}

#Add assignments to hiding rule
Set-FslAssignment -Path "$path\Visio2016_Redirect.fxa" -GroupName Everyone

#Add All Visio processes to the assignment file
$visioFiles | Add-FslAssignment -Path "$path\Visio2016_Redirect.fxa" -IncludeChildProcess -RuleSetApplies

#Copy Visio files to VM