rem Hi I'm Kasey and this is my batch script for some simple stuff because if I'm 
rem going to learn how to script in linux I might as well make a terrible attempt
rem in Windows as well
rem Kasey Litchford - 01/12/2021 for NECCDC Quals

echo "Are you running as Admin?"
net sessions
if %errorlevel%==0 ( rem 'net sessions' fails and the error level stays as a non-zero if this isn't run as Admin
    echo "You're Admin, continuing . . ."
    goto :admin
)
else (
    echo "Please run as Admin!"
    pause
    exit
)

echo "persistence in USER run keys"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce"
echo "persistence in SYSTEM run keys"
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run"
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce"
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices"
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\0001"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\0001\Depend"

echo "turn on Windows automatic updates"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 3 /f

echo "Disable Guest User and rename to Tommy"
net user Guest | findstr active | findstr Yes
if %errorlevel%==1 (
    echo "Guest is Deactivated, yay!"
) else (
    echo "Guest is Activated, onto Deactivating"
    net user Guest /active:NO
    wmic useraccount where  name='Guest' rename Tommy
)

echo "Disable Administrator User"
net user | findstr Administrator
if %errorlevel%==1 (
    echo "Administrator is Deactivated, yay!"
) else (
    if "%username%"=="Administrator" (
        echo "Skipping because you're Administrator"
        goto :skipAdmin
    )
    echo "Administrator is Activated, onto Deactivating"
    net user Guest /active:NO
    wmic useraccount where  name='Administrator' rename XTommy
)

:skipAdmin
set /p pwd="Enter a new password for all users"
wmic useraccount get name | find /v "Name" > userlist.txt
(
    for /F %%h in (userlist.txt) do (
	net user %%h %pwd% >> passlist.txt
    )
)
