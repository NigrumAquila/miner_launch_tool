@echo off

set miner_name=rigel
set algorithms=nexa+zil
set setting=set_custom_settings
set setting_vars="lock_core_clock=1500 lock_mem_clock=5000"
set extraparams=

set address=10.1.0.5
set filepath=miners\start_miner.bat

call "\\%address%\%filepath%" %miner_name% %algorithms% %setting% %setting_vars% %extraparams%