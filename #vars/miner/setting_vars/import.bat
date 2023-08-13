set filepath_setting_vars="%~dp0%miner_name%.bat"

call :check_file_exist %filepath_setting_vars%
call %filepath_setting_vars%

goto :EOF

:check_file_exist
	set file=%1
	if not exist %file% echo File doesn't exist: %file% & pause & exit
	goto :EOF