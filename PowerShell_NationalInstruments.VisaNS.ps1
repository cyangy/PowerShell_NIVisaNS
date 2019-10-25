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
[System.Reflection.Assembly]::LoadFrom("$PSScriptRoot\lib\NationalInstruments.VisaNS.Static.dll") 
#Add-Type -Path "D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.Static.dll" #加载出错
#$LoadNationalInstrumentsVisaNS = Add-Type -Path "D:\Data\Github\VISA_CLI\lib\NationalInstruments.VisaNS.dll" # Load the .Net library
 $env:PATH += ";$PSScriptRoot\lib\"
#也可使用如下方式载入dll
#https://stackoverflow.com/questions/12923074/how-to-load-assemblies-in-powershell/37468429#37468429
 #$bytes = [System.IO.File]::ReadAllBytes("$PSScriptRoot\lib\NationalInstruments.VisaNS.Static.dll")
 #[System.Reflection.Assembly]::Load($bytes)
# Clear-Host 
#dll中命名空间可以从 VisualStudio 对象浏览器中查看、复制
#[NationalInstruments.VisaNS.MessageBasedSession].BaseType
#实际使用时直接使用实例，不要使用基类 MessageBasedSession  SerialSession
#[NationalInstruments.VisaNS.MessageBasedSession] $mbs = [NationalInstruments.VisaNS.ResourceManager]::GetLocalManager().Open("ASRL1::INSTR")
[NationalInstruments.VisaNS.SerialSession] $HP34401A_VinDDM = [NationalInstruments.VisaNS.ResourceManager]::GetLocalManager().Open("ASRL2::INSTR")
$HP34401A_VinDDM.BaudRate             = 9600  #波特率 The baud rate of the interface. The default value is 9600 baud
$HP34401A_VinDDM.DataBits             = 8     #数据位 Gets or sets the number of data bits (from 5 to 8) contained in each frame. The data bits for each frame are located in the low-order bits of every byte stored in memory. 
$HP34401A_VinDDM.StopBits             = [NationalInstruments.VisaNS.StopBitType]::One #停止位  One  OneAndOneHalf Two
$HP34401A_VinDDM.Parity               = [NationalInstruments.VisaNS.Parity]::None     #校验     NONE 0  Odd 1  Even 2 Mark 3 Space 4
$HP34401A_VinDDM.FlowControl          = [NationalInstruments.VisaNS.FlowControlTypes]::None  #Flow Control  NONE 0  XON/XOFF 1 
$HP34401A_VinDDM.TerminationCharacter = 0x0A #使用0x0A作为终止符
$HP34401A_VinDDM.ReadTermination      = [NationalInstruments.VisaNS.SerialTerminationMethod]::TerminationCharacter; #读回结束符选择  #结束符选择 None 0   LastBit 1   TerminationCharacter 2   Break 3
                                         #VI_ATTR_ASRL_END_IN indicates the method used to terminate read operations
$HP34401A_VinDDM.WriteTermination     = [NationalInstruments.VisaNS.SerialTerminationMethod]::TerminationCharacter #写入结束符选择  #结束符选择 None 0   LastBit 1   TerminationCharacter 2   Break 3
                                         #VI_ATTR_ASRL_END_OUT indicates the method used to terminate write operations
#使用Byte[]写入
$HP34401A_VinDDM.Query([System.Text.Encoding]::GetEncoding("iso-8859-1").GetBytes(("*IDN?`r`n")))
#最后一定要使用 Dispose() 释放串口,否则串口会一直处于锁定状态
$HP34401A_VinDDM.Dispose()

##############################################################################################GPIB示例
[NationalInstruments.VisaNS.MessageBasedSession] $mbs = [NationalInstruments.VisaNS.ResourceManager]::GetLocalManager().Open("GPIB0::2::INSTR")
$mbs.Query("*IDN?")
$mbs.Dispose()
##############################################################################################USBTMC示例
[NationalInstruments.VisaNS.MessageBasedSession] $mbs = [NationalInstruments.VisaNS.ResourceManager]::GetLocalManager().Open("USB0::0x0699::0x0415::C022855::INSTR")
$mbs.Query("*IDN?")
$mbs.Dispose()
##############################################################################################TCPIP示例
[NationalInstruments.VisaNS.MessageBasedSession] $mbs = [NationalInstruments.VisaNS.ResourceManager]::GetLocalManager().Open("TCPIP0::192.168.1.2::inst0::INSTR")
$mbs.Query("*IDN?")
$mbs.Dispose()