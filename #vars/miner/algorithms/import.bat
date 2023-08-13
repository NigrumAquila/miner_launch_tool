set filepath_algorithm="%~dp0%miner_name%\%algorithms%.txt"

call :check_file_exist %filepath_algorithm%
set /p algorithm_settings=<%filepath_algorithm%

goto :EOF

:check_file_exist
	set file=%1
	if not exist %file% echo File doesn't exist: %file% & pause & exit
	goto :EOF