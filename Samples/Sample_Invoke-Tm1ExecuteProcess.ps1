Clear-Host
Import-Module -Name "C:\Applications\Powershell\TM1ps"
Invoke-Tm1ExecuteProcess -ConfigFilePath 'C:\Applications\Powershell\TM1ps\config.JSON' -Tm1ServerName 'tm1srv01' -Tm1ProcessName '}bedrock.server.wait' -Tm1ProcessParameters @{pLogOutput = 0;pWaitSec=8}
