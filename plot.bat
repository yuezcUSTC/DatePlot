@echo off

REM 两个可选参数：绘图数和间隔时间（ms），若不设置按默认值
set maxN=%1
set dltT=%2
if "%maxN%"=="" (set maxN=10)
if "%dltT%"=="" (set dltT=500)

REM 生成gnuplot绘图文件，可按需修改
echo. > "plot.gp"
echo set title 'T(x,y)' >> "plot.gp"
echo set xlabel 'X' >> "plot.gp"
echo set ylabel 'Y' >> "plot.gp"
echo set zlabel 'T' >> "plot.gp"
echo set view 45,135 >> "plot.gp" REM 设置视角
REM echo splot "temp.txt" >> "plot.gp" REM 绘制点图
echo splot "temp.txt" with surface >> "plot.gp" REM 绘制网格面图
REM echo splot "temp.txt" with pm3d >> "plot.gp" REM 绘制颜色面图
REM echo plot "temp.txt" with image >> "plot.gp" REM 其他数据格式绘制image
echo reread >> "plot.gp"

REM 以并行方式启动绘图（reread使图实时更新）
start /B plot.gp

REM 以固定间隔依次复制文件夹中的文件到绘图临时文件
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

REM 删除绘图文件最后一行（即reread），避免死循环
setlocal enabledelayedexpansion
for /f "delims=" %%i in ('type "plot.gp"') do (
set /a n+=1
set "m!n!=%%i")
set /a n-=1
(for /l %%i in ('1,1,!n!') do (
echo=!m%%i!))>"plot.gp"

REM 子函数，用于获得毫秒级时间间隔
:delay
echo WScript.Sleep %1>delay.vbs
cscript  //b delay.vbs
del delay.vbs