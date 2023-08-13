set /a wallets& set /a counter=0& set temporary=%algorithms%
:add_wallet
  for /f "tokens=1,* delims=+" %%a in ("%temporary%") do (
    set algorithm=%%a
    if "!algorithm:_=!" NEQ "!algorithm!" (call :concat_wallets !algorithm!) else (
      set filepath_wallet="%~dp0!algorithm!.txt"
      call :check_file_exist !filepath_wallet!
      set /p wallet=<!filepath_wallet!
      call :check_wallet_isset "!wallet!" !filepath_wallet!
    )
    if "!key_wallet[%counter%]:~-1!" == "]" (set delimiter=) else (set delimiter= )
    if "!wallets!" NEQ "" (set wallets=!wallets! !key_wallet[%counter%]!!delimiter!!wallet!) else (set wallets=!key_wallet[%counter%]!!delimiter!!wallet!)

    set /a counter=!counter!+1
    set temporary=%%b
  )
if defined temporary goto :add_wallet
goto :EOF

:concat_wallets
  set algorithm=%1
  set "left_algorithm=%algorithm:_=" & set "right_algorithm=%"
  set left_filepath="%~dp0%left_algorithm%.txt"
  set right_filepath="%~dp0%right_algorithm%.txt"
  call :check_file_exist %left_filepath%
  call :check_file_exist %right_filepath%
  set /p left_wallet=<%left_filepath%
  set /p right_wallet=<%right_filepath%
  call :check_wallet_isset "%left_wallet%" %left_filepath%
  call :check_wallet_isset "%right_wallet%" %right_filepath%
  set wallet=%left_wallet%.%right_wallet%
  goto :EOF

:check_wallet_isset
  set "wallet=%~1"
  set "filepath=%~2"
  set "filesize=%~z2"
  if %filesize% == 0 (echo Wallet not set. Enter it in %filepath%& pause & exit)
  if "%wallet%" == "set wallet here" (echo Wallet not set. Enter it in %filepath%& pause & exit)
  goto :EOF

:check_file_exist
  set file=%1
  if not exist %file% echo File doesn't exist: %file% & pause & exit
  goto :EOF