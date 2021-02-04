@echo off
cd bin/cs/bin
if "%1"=="debug" (
  :: run debug
  Main-debug.exe
  pause
) else (
  :: run release
  Main.exe
)
