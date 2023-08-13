set filepath_common_settings="%~dp0%miner_name%\%algorithms%.txt"

call :check_file_exist %filepath_common_settings%
set /p settings=<%filepath_common_settings%

goto :EOF

:check_file_exist
	set file=%1
	if not exist %file% echo File doesn't exist: %file% & pause & exit
	goto :EOF