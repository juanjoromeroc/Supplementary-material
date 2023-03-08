function results=heatmapgenerator(x1,x2)
rng default
%search space
Avector=x1;
Bvector=x2;
 
Asize=size(Avector)
Bsize=size(Bvector)
results=zeros(Asize(2)*Bsize(2),16)
i=1
j=1

for i=1:Asize(2)
    for j=1:Bsize(2)
startTime = tic;
%process variables input=[RT,BatchRT,Vcol,Ncycles,Cin, Vbatch,Ncol]
input=[5,5,Avector(i),1,5,Bvector(j),1]
ncol=input(7);
ncart=1;
height=0.000419;
height2=height*2.9/1.6;
if (input(3)*0.0016/ncol)/(input(1)/3600)>(200/1000*60)
    restime=input(3)*0.0016/ncol/(200/1000*60);
else
    restime=input(1)/3600;
end
restime=input(1)/3600;
restimebatch=input(2)/3600;
Vcol=input(3)*0.0016/ncol;
Cin=input(5)/10;
Acart=Vcol/height;
Deq=(Acart*4/pi)^(1/2);
Vbatch=input(6)/1000;
ncycles=input(4);
washflowvel=2.25;
washbv=10;
elutebv=4;
regflowvel=3;
regbv=6;
eqflowvel=3;
eqbv=6;
reg2flowvel=3;
reg2bv=9;
minrec=0.99;
fracreleased=0.05;
error=0;
iter=1;
Vpfr1=0;
Vpfr2=0;
Vcstr1=height2*Acart*ncart;
Vcstr2=height2*Acart*ncart;
F=ncart*Acart*height/restime;
Fbatch=ncart*Acart*height/restimebatch;
flowvel=F/Acart/ncart;
flowvelbatch=Fbatch/Acart/ncart;
eluteflowvel=flowvel;
%fracret=input(8)
maxbt=1
colcapacity=1
    tbatch=0;
    loadtime=Vbatch/ncycles/F
  if Vbatch/ncycles/Vcol<=50
      [fracret, maxbt,colcapacity]=surrogate(Vcol,Vbatch,ncycles)
  else
      %Default values
      loadtime=-1
      COG=20
      yield=0.5
     productivity=5
  end
   fclose('all');  
if loadtime>=0
    if fracret>1;
        fracret=1;
    end
[productivity, prodconc, yield, cyclecapacity, cycletime,COG,capacity,buffer]=superprocalculationsCapture(height,height2,ncart,Cin,flowvel,fracret,ncycles,washflowvel,washbv,eluteflowvel,elutebv,regflowvel,regbv,eqflowvel,eqbv,reg2flowvel,reg2bv,flowvelbatch,ncol,Acart,Vbatch,fracreleased,Deq)
    finaltime = toc(startTime);
 results((i-1)*Bsize(2)+j,:)=[Avector(i),Bvector(j),maxbt, loadtime+tbatch, fracret,error,iter, productivity, prodconc*10, yield, cyclecapacity*ncycles*1000,cycletime*ncycles,COG,colcapacity,buffer,7200/cycletime*cyclecapacity*1000*(200-COG)]
 
else
  results((i-1)*Bsize(2)+j,:)=[Avector(i),Bvector(j),0,loadtime+tbatch,0,0,0,0,0,0,0,0,0,0,0,0] 
end
    end
end

filename = 'heatmap.xlsx';
delete(filename)
tag=["time","load","maxbt","load time","fracret","error","iter","productivity", "prodconc", "yield", "batchcapacity", "batchtime","COG","CU","buffer","Annual profit"]
writematrix(tag,filename,'Sheet',1,'Range','A1')
writematrix(results,filename,'Sheet',1,'Range','A2')
end
