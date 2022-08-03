function [net] = NNetOptimizer(bounds,teiler,N2,model,teilermax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

opti.bounds=bounds;
[~,opti.simset]=size(opti.bounds);
opti.Teiler=teiler;
opti.N2=N2;
opti.model=model;
opti.Teileraproxmax=teilermax;
opti.Teileraprox=opti.Teiler*2;



%Löschen aller Cluster/Jobs
delete(gcp('nocreate'));
myCluster = parcluster('local');
delete(myCluster.Jobs);



opti.iter=1;
opti.protokoll=[];
%------------------Konkretisierungsschleife--------------------------------
while opti.Teileraprox < opti.Teileraproxmax

%--------------------------------------------------------------------------    
    %Laden der gespeicherten Ergebnisse
    if opti.simset==4
        opti.Mat=load('4P_res');
    end 
    if opti.simset==6
        opti.Mat=load('6P_res');
    end
    if opti.simset==7
        opti.Mat=load('7P_res');
    end
    
%--------------------------------------------------------------------------    
    
    %Erstellen des Grundrasters
    [opti.C,opti.Cnorm,opti.meshalt]=raster(opti.Teiler,opti.simset,opti.bounds);


    %Falls Ergebnisse vorhanden, mit Raster Abgleichen
    if isempty(opti.Mat.Eges)==0
    opti.A=round(opti.Mat.Eges(:,1:opti.simset),0);
    opti.B=round(opti.C,0);
    [~,aid,bid] = intersect(opti.A,opti.B,'rows');
    opti.C( bid, : ) = [];
    end
    
    
    
    %Wurden Alle Versuche aus dem Stützraster berechnet, Startet die
    %Schätzung
    while isempty(opti.C)==1    
    
    %Konstruktion des KNN    
    [net,opti.Cnorm,opti.ZappYh2snormnorm,opti.tablenewnorm,opti.Yh2snorm]=NNetconst(opti.Teileraprox,opti.Mat.Eges,opti.simset,opti.bounds);    
     
    
     
    %Neue Punkte erstellen 
    [opti.Znewschlecht,opti.Znewnorm,opti.tablenewnorm]  = posnice(opti.ZappYh2snormnorm,opti.tablenewnorm,opti.Yh2snorm,opti.Cnorm,opti.simset,opti.Teileraprox);
    

    %Auswahl aus den neuen Punkten
    [opti.C]=newexp(opti.Znewschlecht,opti.Znewnorm,opti.tablenewnorm,opti.Cnorm,opti.bounds,opti.N2,opti.simset);
    
    
    if isempty(opti.C)==1
    opti.Teileraprox=opti.Teileraprox*2;
    end
    
    end

   

    delete(gcp('nocreate'));
    myCluster = parcluster('local');
    delete(myCluster.Jobs);
    
     opti.Cnotdone=opti.C;

    backup=[];
    save('backupparcom','backup');

        %Solange nicht alle Berechnungen fertig sind
        while isempty(opti.Cnotdone)==0
            
            %Umwandling der Parameter und parallele Berechnung
            [par]=parcomfunc(opti.Cnotdone,opti.model,opti.simset);
            
            
            %Extraktion der Ergebnisse aus dem Logfile
            [par.Yh2e,opti.error]=resultstovector(opti.Cnotdone,par.out,par.in);
            
            %Ungültige oder ERROR Versuche wurden zuvor 0 gesetzt und jetzt
            %rausgesucht.

            opti.index0=find(par.Yh2e==0 | isnan(par.Yh2e)); 
            opti.indexnot0=find(par.Yh2e~=0 & ~isnan(par.Yh2e));
            
            %Alle Versuche mit Ergebnisse != 0 werden opti.Cdone
            %zugeordnet
            opti.Cdone=removerows(opti.Cnotdone,'ind',opti.index0);
            par.Yh2e=removerows(par.Yh2e,'ind',opti.index0);
          
            %Backup verhindert bei abstürzen komplett neu Berechnet werden
            %muss
            opti.backupload=load('backupparcom');
            if isempty(opti.backupload.backup)==0
            backup=[opti.backupload.backup;[opti.Cdone par.Yh2e]]; 
            else
                backup=[opti.Cdone par.Yh2e];
            end
            
            save('backupparcom','backup');
           
            %Alle Versuche mit Ergebnisse = 0 werden opti.Cnotdone
            %zugeordnet
            opti.Cnotdone=removerows(opti.Cnotdone,'ind',opti.indexnot0);


        end

    
    opti.backupload=load('backupparcom');
    opti.C=opti.backupload.backup(:,1:opti.simset);
    opti.Yh2e=opti.backupload.backup(:,end:end);
        
    
    savedeldouble(opti.C,opti.Yh2e,opti.simset);
    
    
    
    opti.L=load('6P_res');
    Eges=opti.L.Eges;
    opti.protokoll=[opti.protokoll; [opti.iter opti.Teileraprox (sum(par.Yh2e)/numel(par.Yh2e)) sum(Eges(:,end))/numel(Eges(:,end)) numel(Eges(:,end))]];
    
    opti.iter = opti.iter + 1;
end
end

