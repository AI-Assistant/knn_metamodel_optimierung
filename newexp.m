function [C] = newexp(Znewschlecht,Znewnorm,tablenewnorm,CnormEges,bounds,N,simset)

%Mit Hilfe der günstigen Punkte in 'Znewnorm', werden die neuen Experimente bestimmt. 


tablenewnormsort=tablenewnorm;

% Schon Berechnete Punkte werden Entfernt
[~,aid,~] = intersect(tablenewnormsort,CnormEges,'rows');
tablenewnormsort(aid,:)=[];
[~,aid,~] = intersect(Znewschlecht,CnormEges,'rows');
Znewschlecht(aid,:)=[];

%Sortieren
tablenewnormsort=unique(tablenewnormsort,'rows');

%Test auf doppelte
Znewschlecht=unique(Znewschlecht,'rows');

%Wenn noch Punkte bleiben
if isempty(tablenewnormsort)==0
    
    a = randn(numel(tablenewnormsort(:,1)),1);
   indicesa = randperm(length(a));
   
   b = randn(numel(Znewschlecht(:,1)),1);
   indicesb = randperm(length(b));

    %Ggf. anpassung von N
    if numel(tablenewnormsort(:,1))<N
    N=numel(tablenewnormsort(:,1));
    end
   
    
 %Anzahl der Experimente N muss auf ein Kontingent für Zufallspunkte Z und
 %gute Punkte G aufgeteilt werden /////Kontingen 10% 
    
 Z=floor(N/10);
 G=N-Z;
 
    indicesvona = indicesa(1:G);
    indicesvonb = indicesb(1:Z);
    dCE = [tablenewnormsort(indicesvona,:);Znewschlecht(indicesvonb,:)];



    C=dCE;
    for q=1:numel(dCE(:,1))
        for i=1:simset
            Pm=(C(q,i)*(bounds(1,i)-bounds(2,i))+bounds(1,i)+bounds(2,i))/2;
            C(q,i) = Pm;
        end
    end
else
C=tablenewnormsort;
end
end

