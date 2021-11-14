@echo off
g++ -s -o %~dp0\uc2000dt.exe %~dp0\uc2000dt.cpp %~dp0\SerialPort.cpp
