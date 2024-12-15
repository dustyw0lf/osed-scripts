<#
Wondows VM setup script.
Based on Ben 'epi' Risher's install-mona.ps1
https://github.com/epi052/osed-scripts/blob/main/install-mona.ps1
#>

$ShareDir = "\\tsclient\_home_kali_share\windbg\"
$InstallDir = "C:\Users\Offsec\Desktop\windbg"
$MonaLogsDir = "C:\Users\Offsec\Desktop\monalogs"

Write-Output "[+] creating installation directory: $InstallDir"
New-Item -Path $InstallDir -Type Directory | Out-Null

Write-Output "[+] creating mona logs directory: $MonaLogsDir"
New-Item -Path $MonaLogsDir -Type Directory | Out-Null

# install old c++ runtime
Write-Output "[+] installing old c++ runtime"
Copy-Item "$ShareDir\vcredist_x86.exe" $InstallDir
Start-Process -FilePath "$InstallDir\vcredist_x86.exe" -Wait

# Write-Output "[+] backing up old pykd files"
# Move-Item "C:\Program Files\Windows Kits\10\Debuggers\x86\winext\pykd.pyd" "C:\Program Files\Windows Kits\10\Debuggers\x86\winext\pykd.pyd.bak"
# Move-Item "C:\Program Files\Windows Kits\10\Debuggers\x86\winext\pykd.dll" "C:\Program Files\Windows Kits\10\Debuggers\x86\winext\pykd.dll.bak"

# install python2.7
Write-Output "[+] installing python2.7"
Copy-Item "$ShareDir\python-2.7.17.msi" $InstallDir
Start-Process -FilePath msiexec.exe -ArgumentList "/i $InstallDir\python-2.7.17.msi /qn" -Wait

# register Python2.7 binaries in path before Python3
Write-Output "[+] adding python2.7 to the PATH"
$p = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('Path', "C:\Python27\;C:\Python27\Scripts;" + $p, [System.EnvironmentVariableTarget]::User)

# copy mona files
Write-Output "[+] copying over mona files and pykd"
Copy-Item "$ShareDir\windbglib.py" "C:\Program Files\Windows Kits\10\Debuggers\x86"
Copy-Item "$ShareDir\mona.py" "C:\Program Files\Windows Kits\10\Debuggers\x86"
Copy-Item "$ShareDir\pykd.pyd" "C:\Program Files\Windows Kits\10\Debuggers\x86\winext"

Write-Output "[=] in case you see something about symbols when running mona, try executing the following (the runtime took too long to install)"
Write-Output 'regsvr32 "C:\Program Files\Common Files\Microsoft Shared\VC\msdia90.dll"'

Copy-Item \\tsclient\_home_kali_share\windbg\dark-green-x64.wew C:\Users\Offsec\Desktop\windbg\dark-green-x64.wew