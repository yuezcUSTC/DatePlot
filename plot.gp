
 
set title 'T(x,y)' 
set xlabel 'X' 
set ylabel 'Y' 
set zlabel 'T' 
set view 45,135 
splot "temp.txt" with surface 
