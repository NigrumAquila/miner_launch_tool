@echo off
setlocal EnableDelayedExpansion

for /f "tokens=*" %%g in (all.txt) do (
	set ip=%%g
	pskill \\!ip! miner.exe
)