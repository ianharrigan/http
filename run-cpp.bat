@echo off
cd bin/cpp
if "%1"=="debug" (
  :: run debug
  Main-debug.exe
  pause
) else (
  :: run release
  Main.exe
)
