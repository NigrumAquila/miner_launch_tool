@echo off
setlocal EnableDelayedExpansion

for /f "tokens=*" %%g in (target.txt) do (
	set ip=%%g
	pskill \\!ip! miner.exe
)