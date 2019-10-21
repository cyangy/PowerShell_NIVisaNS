#$a= [Reflection.Assembly]::LoadFile("D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.Static.dll")
#[System.Reflection.Assembly]::LoadWithPartialName("D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.Static.dll")
#$mathInstance = new-object [NationalInstruments.VisaNS]::MessageBasedSession
# Get-Module

<#
#https://social.technet.microsoft.com/wiki/contents/articles/31563.powershell-search-for-available-classmethodproperty-within-imported-assembly.aspx
 Import-Module  "D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.dll"
 Get-Module
$XCEED = ([appdomain]::CurrentDomain.GetAssemblies())|?{$_.Modules.name.contains("NationalInstruments.VisaNS.dll")}
$DRE = $XCEED.GetModules().gettypes()|?{$_.isPublic -AND $_.isClass}
#($DRE.DeclaredConstructors.GetParameters())[0]|ft member -AutoSize
$DRE.GetMembers()|ft memberType,Name -auto
new-object [NationalInstruments.VisaNS]::MessageBasedSession
#>
#最好的加载方式,分别交换两行注释观察区别,不带 | Out-Null 或 $LoadNationalInstrumentsVisaNS =  时 [NationalInstruments.VisaNS.MessageBasedSession].BaseType 会输出更多更详细信息
#$LoadNationalInstrumentsVisaNS = [System.Reflection.Assembly]::LoadFrom("D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.dll")
[System.Reflection.Assembly]::LoadFrom("D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.dll") 
#Add-Type -Path "D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.Static.dll" #加载出错
#$LoadNationalInstrumentsVisaNS = Add-Type -Path "D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.dll" # Load the .Net library
 $env:PATH += ";D:\Data\Github\VISA_CLI\lib\" 
#dll中命名空间可以从 VisualStudio 对象浏览器中查看、复制
[NationalInstruments.VisaNS.MessageBasedSession].BaseType