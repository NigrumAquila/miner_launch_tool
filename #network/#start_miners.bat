@echo off
setlocal EnableDelayedExpansion

set user=user
set password=password

for /f "tokens=*" %%g in (all.txt) do (
	set ip=%%g
	psexec \\!ip! -u %user% -p %password% -i cmd /c query session %user% | findstr %user% > temporary.txt
	set /p session_row=<%~dp0temporary.txt
	set session_id=!session_row:~45,1!
	pskill \\!ip! miner.exe
	psexec \\!ip! -u %user% -p %password% -d -i !session_id! "C:\Scripts\Cash_button.bat"
)

del %~dp0temporary.txt