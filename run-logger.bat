@echo off
title Rhyming Clock Auto-Logger
echo Starting Rhyming Clock Background Logger...
powershell -ExecutionPolicy Bypass -File "%~dp0logger-server.ps1"
pause
