@echo off
cd bin/jvm
if "%1"=="debug" (
  :: run debug
  java -jar Main.jar
  pause
) else (
  :: run release
  java -jar Main.jar
)
