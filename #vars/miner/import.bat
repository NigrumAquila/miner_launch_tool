set filepath_miner="%~dp0..\..\%miner_name%\miner.exe"


call :check_file_exist %filepath_miner%
goto :EOF

:check_file_exist
	set file=%1
	if not exist %file% echo File doesn't exist: %file% & pause & exit
	goto :EOF