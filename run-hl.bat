@echo off
cd bin/hl
if "%1"=="debug" (
  :: run debug
  hl http.hl
  pause
) else (
  :: run release
  hl http.hl
)
