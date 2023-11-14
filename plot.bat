@echo off

set maxN=%1
set dltT=%2
if "%maxN%"=="" (set maxN=10)
if "%dltT%"=="" (set dltT=500)

echo. > "plot.gp"
echo set title 'T(x,y)' >> "plot.gp"
echo set xlabel 'X' >> "plot.gp"
echo set ylabel 'Y' >> "plot.gp"
echo set zlabel 'T' >> "plot.gp"
echo splot "temp.txt" >> "plot.gp"
REM echo plot "temp.txt" with image >> "plot.gp"
echo reread >> "plot.gp"

start /B plot.gp

echo maxN=%maxN%, dltT=%dltT%ms
set /a i=0
:loop
if %i% equ %maxN% (
goto end
) else (
echo Nt=%i%
copy "DateRecord\Nt=%i%.txt" "temp.txt">nul
call :delay %dltT%
set /a i+=1
goto loop
)
:end

setlocal enabledelayedexpansion
for /f "delims=" %%i in ('type "plot.gp"') do (
set /a n+=1
set "m!n!=%%i")
set /a n-=1
(for /l %%i in ('1,1,!n!') do (
echo=!m%%i!))>"plot.gp"

:delay
echo WScript.Sleep %1>delay.vbs
cscript  //b delay.vbs
del delay.vbs