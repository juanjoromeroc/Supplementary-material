startTime = tic;
X1=3:1:20 %Ncol
X2=50:50:200 %Vbatch
heatmapgenerator(X1,X2)
Wcog=(0:0.1:1);
%optimization from sensitivity
filename = 'heatmap.xlsx';
sheet = 1;
xlRange = 'A2:P626';
results=xlsread(filename,sheet,xlRange);
sizea=size(Wcog);
results=results(results(:,13)>0,:)
resultssize=size(results)
out=zeros(sizea(2),resultssize(2)+2)
COG=results(:,13)
COG=COG(COG>0)
cycletime=results(:,12)
cycletime=cycletime(cycletime>0)
mincog=min(COG)
mintime=min(cycletime)
for i=1:sizea(2)
    fval=Wcog(i)*(COG/mincog-ones(size(COG)))+(1-Wcog(i))*(cycletime/mintime-ones(size(COG)))
    [Fvalmin,minpos]=min(fval)
    out(i,:)=[Wcog(i),Fvalmin,results(minpos,:)];
end
%Mixed integer optimization for X2 (Vbatch)
%Initial values
sizea=size(Wcog);
resultsOpt=zeros(sizea(2),5)
X0_SEE=out(:,3:4)
X0_SEE(:,2)=X0_SEE(:,2)/50
LL=[min(X2)/50]
UL=[max(X2)/50]
for i=1:sizea(2)
    rng default
    x1=X0_SEE(i,1)
    fun=@(x2)membranesimulation(x1,x2,Wcog(i),mincog,mintime)
      x0= X0_SEE(i,2)
 [x2,fval,exitflag,output]  = fmincon(fun,x0,[],[],[],[],LL,UL)
resultsOpt(i,:)=[Wcog(i),x1,x2,fval,output.funcCount];
end

tag=["Wcog","Nmedia","Vbatch","Fval", "FuncCount"];
filename = 'Pareto.xlsx';
delete(filename)
writematrix(tag,filename,'Sheet',1,'Range','A1')
writematrix(resultsOpt,filename,'Sheet',1,'Range','A2')
    time_ga_sequential = toc(startTime)
    fprintf('Serial GA optimization takes %g seconds.\n',time_ga_sequential);