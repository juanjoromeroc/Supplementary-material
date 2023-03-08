function [productivity, prodconc, yield, cyclecapacity, cycletime,COG,capacity,buffer]=superprocalculationsCapture(height,height2,ncart,Cin,flowvel,fracret,ncycles,washflowvel,washbv,eluteflowvel,elutebv,regflowvel,regbv,eqflowvel,eqbv,reg2flowvel,reg2bv,flowvelbatch,ncol,Acart,Vbatch,fracreleased,Deq)
%write excel file
c=actxserver('Excel.Application');
% set(c, 'Visible', 1)
d=c.Workbooks;
e=d.Open(strcat(pwd,'\Capture membrane.xlsm'));
%e=d.Open('C:\Users\Juan Jose Romero\Desktop\Supplementary short\Capture membrane.xlsm');
f= e.Sheets.Item('Multiple Column');
g = f.Range('B1');
    g.Value=strcat(pwd,'\Capture membrane.spf');
c.Run('ThisWorkbook.OpenSPDFile');
g = f.Range('C6');
    g.Value=height;
g = f.Range('C7');
    g.Value=Deq;
g = f.Range('C29');
    g.Value=ncol;
g = f.Range('C3');
    g.Value=Cin;
g = f.Range('C33');
    g.Value=flowvel;
g = f.Range('C10');
    g.Value=fracret;
g = f.Range('C49');
    g.Value=ncycles;
g = f.Range('C12');
    g.Value=washflowvel;
g = f.Range('C13');
    g.Value=washbv;
g = f.Range('C15');
    g.Value=eluteflowvel;
g = f.Range('C17');
    g.Value=elutebv;
g = f.Range('C18');
    g.Value=regflowvel;
g = f.Range('C19');
    g.Value=regbv;
g = f.Range('C34');
    g.Value=eqflowvel;
g = f.Range('C35');
    g.Value=eqbv;
g = f.Range('C39');
    g.Value=reg2flowvel;
g = f.Range('C40');
    g.Value=reg2bv;
g = f.Range('C32');
    g.Value=flowvelbatch;
g = f.Range('C48');
    g.Value=Vbatch;

    g = f.Range('C8');
    g.Value=height2;
%     g = f.Range('C56');
%     g.Value=Acart;
        g = f.Range('C57');
    g.Value=fracreleased;
c.Run('ThisWorkbook.SetAll');
c.Run('ThisWorkbook.DoMEBalance');
c.Run('ThisWorkbook.DoEconomiccalc');
c.Run('ThisWorkbook.GetAll');
%read from excel
g = f.Range('C41');
    productivity=g.Value;
g = f.Range('C25');
    prodconc=g.Value;
g = f.Range('C26');
    yield=g.Value;
g = f.Range('C24');
    cyclecapacity=g.Value;
g = f.Range('C11');
    cycletime=g.Value ;
g = f.Range('C45');
    COG=g.Value ;
g = f.Range('C44');
    capacity=g.Value ;
g = f.Range('C56');
    buffer=g.Value ;
% Close and finish program
c.Run('ThisWorkbook.CloseSPDFile');
c.DisplayAlerts = 0;
d.Close;
delete(c);    
    
end