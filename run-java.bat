@echo off
cd bin/java
if "%1"=="debug" (
  :: run debug
  java -jar Main-Debug.jar
  pause
) else (
  :: run release
  java -jar Main.jar
)
