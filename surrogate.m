function [fracret, maxbt,colcapacity]=surrogate(Vcol,Vbatch,ncycles)
%Relative load calculation
load=Vbatch/ncycles/Vcol;
%Loading library values
filename = 'Library.xlsx';
sheet = 1;
xlRange = 'A2:D51';
model=xlsread(filename,sheet,xlRange);
maxbt=interp1(model(:,1),model(:,2),load,'pchip');
fracret=interp1(model(:,1),model(:,3),load,'pchip');
colcapacity=interp1(model(:,1),model(:,4),load,'pchip');
system('taskkill /F /IM EXCEL.EXE');
 end
