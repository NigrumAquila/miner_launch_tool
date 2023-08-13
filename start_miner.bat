@echo off 
setlocal EnableDelayedExpansion

set miner_name=%1
set algorithms=%2
set miner_settings=%~3
set miner_settings_params=%~4
set extraparams=%~5

call :validate_input

call "%~dp0#vars\miner\import.bat"
call "%~dp0#vars\miner\setting_vars\import.bat"
call "%~dp0#vars\miner\algorithms\import.bat"
call "%~dp0#vars\url\import.bat"
call "%~dp0#vars\wallet\import.bat"

set /a settings

if "%miner_settings%" == "" goto start_miner
if "%miner_settings%" == "set_common_settings" goto :set_common_settings
if "%miner_settings%" == "set_custom_settings" (
	if "%miner_settings_params%" == "" goto :set_common_settings
	if "%miner_settings_params%" == "-" goto :start_miner

	set miners_with_another_enumeration=;bzminer;gminer;

	:split_options
	for /f "tokens=1,*" %%a in ("%miner_settings_params%") do (
		for /f "tokens=1,2 delims==" %%s in ("%%a") do (
			set "settings_param_name=%%s"
			set "settings_param_value=%%t"
			if "!settings_param_value!" == "" echo Option value "!settings_param_name!" is empty. & pause & exit
			2>NUL CALL :SWITCH_add_option
			IF ERRORLEVEL 1 echo This option doesn't exist: !settings_param_name! & pause & exit	
		)
		set miner_settings_params=%%b
	)
	if defined miner_settings_params goto :split_options
	goto :start_miner


	:SWITCH_add_option
		CALL :CASE_%settings_param_name%
		goto :EOF

		:CASE_lock_core_clock
			call :add_options "^[0-9Xx*][,0-9*xX;]*$" "key_lock_core_clock"
			goto :EOF
		
		:CASE_lock_mem_clock
			call :add_options "^[0-9Xx*][,0-9*xX;]*$" "key_lock_mem_clock"
			goto :EOF
		
		:CASE_core_clock_offset
			call :add_options "^[-0-9Xx*@][,0-9*@xX;]*$" "key_core_clock_offset"
			goto :EOF

		:CASE_mem_clock_offset
			call :add_options "^[-0-9Xx*][,0-9*xX;]*$" "key_mem_clock_offset"
			goto :EOF
		
		:CASE_fan
			call :add_options "^[_t0-9Xx*][tXx*_,:[;\-0-9,\]]*$" "key_fan"
			goto :EOF

		:CASE_power_limit
			call :add_options "^[_0-9*][,_0-9*xX;]*$" "key_power_limit"
			goto :EOF

		:CASE_memory_tweaks
			call :add_options "^[_0-6][,_0-6!]*$" "key_memory_tweaks"
			goto :EOF

		:CASE_devices
			call :add_options "^[0-9][,0-9;]*$" "key_devices"
			goto :EOF	

		:CASE_kernel
			call :add_options "^[_1-3ab][,_1-3ab]*$" "key_kernel"
			goto :EOF

		:CASE_log
			call :validate_settings_param_value "^[a-zA-Z_:.\\\-#@0-9]*$" "%settings_param_value%"
			call :write_settings_param "%key_log%" "%settings_param_value%"
			goto :EOF

		:CASE_api
			call :validate_settings_param_value "^[.0-9:]*$" "%settings_param_value%"
			call :write_settings_param "%key_api%" "%settings_param_value%"
			goto :EOF

		:CASE_temp_limit
			call :validate_settings_param_value "^[t_][tcm[\],_\-0-9]*$" "%settings_param_value%"
			call :write_settings_param "%key_temp_limit%" "%settings_param_value%"
			goto :EOF
	
		:CASE_zil_caching
			call :validate_settings_param_value "^[0-1]$" "%settings_param_value%"
			call :write_settings_param "%key_zil_caching%" "%settings_param_value%"
			goto :EOF
		
		:CASE_password
			call :write_settings_param "%key_password%" "%settings_param_value%"
			goto :EOF
		
		:CASE_personalization
			call :write_settings_param "%key_personalization%" "%settings_param_value%"
			goto :EOF

	:add_options
		set /a algo_counter=0-1
		set temporary=%algorithms%
		:count_algorightms
			for /f "tokens=1,* delims=+" %%a in ("%temporary%") do (
				set /a algo_counter=!algo_counter!+1
				set temporary=%%b
			)
			if defined temporary goto :count_algorightms
		
		set counter_options=0
		set "pattern=%~1"
		set "key_name=%~2"

		:add_option
			for /f "tokens=1,* delims=/" %%g in ("%settings_param_value%") do (
				if !counter_options! GTR !algo_counter! (echo Option has more parameters than algorithms specified: %key_name:~4% & pause & exit)
				set option_value=%%g
				call :validate_settings_param_value "%pattern%" "!option_value!"
				call :write_settings_param "!%key_name%[%counter_options%]!" "!option_value!"
				set settings_param_value=%%h
				set /a counter_options=!counter_options!+1
			)
			if defined settings_param_value goto :add_option
			goto :EOF

	:write_settings_param
		set "option_name=%~1"
		set option_value=%~2
		if not defined option_name echo This option is not in the miner: %settings_param_name% & pause & exit
		if "%option_name:~-1%" == "]" (set delimiter=) else (set delimiter= )

		if "!miners_with_another_enumeration:;%miner_name%;=!" NEQ "!miners_with_another_enumeration!" (
			:replace_comma_to_space
				for /f "tokens=1,* delims=," %%a in ("%option_value%") do (
					set option_value=%%b
					if "!temporary!" NEQ "" (set temporary=!temporary! %%a) else (set temporary=%%a)
				)
				if defined option_value goto :replace_comma_to_space
				set option_value=!temporary!
				set "temporary="
		)

		if "%settings%" NEQ "" (set settings=%settings% %option_name%%delimiter%%option_value%) else (set settings=%option_name%%delimiter%%option_value%)
		goto :EOF

	:validate_settings_param_value
		set "pattern=%~1"
		set "option_value=%~2"
		echo %option_value%| findstr /r %pattern%>nul
		if %errorlevel% equ 1 echo Settings option "%settings_param_name%" value not valid: %option_value% & pause & exit
		goto :EOF
			
)
echo This miner settings doesn't exist: "%miner_settings%" & pause & exit

:validate_input
	if "%miner_name%" == "" echo Miner name not set. & pause & exit
	if "%algorithms%" == "" echo Miner algorithm not set. & pause & exit
	goto :EOF


:set_common_settings
	call "%~dp0#vars\miner\common_settings\import.bat"
	goto :start_miner


:start_miner
	%filepath_miner% %algorithm_settings% %pools% %wallets% %key_worker% %computername% %settings% %extraparams%