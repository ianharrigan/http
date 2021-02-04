@echo off
cd bin/neko
if "%1"=="debug" (
  :: run debug
  neko http.n
  pause
) else (
  :: run release
  neko http.n
)
