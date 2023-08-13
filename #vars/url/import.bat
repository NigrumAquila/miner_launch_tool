set /a pools & set /a counter=0 & set temporary=%algorithms%
:add_pool
  for /f "tokens=1,* delims=+" %%a in ("%temporary%") do (
    set algorithm=%%a

    set filepath_url="%~dp0!algorithm!.txt"
    call :check_file_exist !filepath_url!
    set /p pool_url=<!filepath_url!
    call :check_pool_isset "!pool_url!" !filepath_url!
    if "!key_pool[%counter%]:~-1!" == "]" (set delimiter=) else (set delimiter= )
    if "!pools!" NEQ "" (set pools=!pools! !key_pool[%counter%]!!delimiter!!pool_url!) else (set pools=!key_pool[%counter%]!!delimiter!!pool_url!)
    set /a counter=!counter!+1
    set temporary=%%b
  )
if defined temporary goto :add_pool

goto :EOF

:check_pool_isset
  set "pool_url=%~1"
  set "filepath=%~2"
  set "filesize=%~z2"
  if %filesize% == 0 (echo URL not set. Enter it in %filepath% & pause & exit)
  if "%pool_url%" == "set url here" (echo URL not set. Enter it in %filepath% & pause & exit)
  goto :EOF

:check_file_exist
  set file=%1
  if not exist %file% echo File doesn't exist: %file% & pause & exit
  goto :EOF