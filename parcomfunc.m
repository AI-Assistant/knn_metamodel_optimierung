function [par] = parcomfunc(C,model,simset)

par.C=C;

isModelOpen       = bdIsLoaded(model);
load_system(model);
if isModelOpen==0
    load_system(model);
end

%Auswahl der Umwandlung
if simset==6
    par.S=simset_6P(par.C);
end

[par.anzexp,par.anzpara]=size(par.S);

%Hinterlegen der Variablen 
for i=1:par.anzexp
    
    in(i)=Simulink.SimulationInput(model); 

    in(i)=in(i).setVariable('t_sim',par.S{i,1});
    in(i)=in(i).setVariable('massflow_N',par.S{i,2});
    in(i)=in(i).setVariable('massflow_H2',par.S{i,3});
    in(i)=in(i).setVariable('t_temp',par.S{i,4});
    in(i)=in(i).setVariable('T',par.S{i,5});
    in(i)=in(i).setVariable('M_N',par.S{i,6});
    in(i)=in(i).setVariable('M_H2',par.S{i,7});
    
end


delete(gcp('nocreate'));
assignin('base','par', par)

par.in=in;

%Paralelle Berechnung 
par.out=parsim(par.in,'ShowProgress',"on","TransferBaseWorkspaceVariables","off","UseFastRestart","off");

if(~isModelOpen)
    close_system(model, 0);
end
delete(gcp('nocreate'));

end

