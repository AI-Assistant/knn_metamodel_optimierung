function [Znewschlecht,Znewnormfin,tablenewnormfin]=posnice(Znewnorm,tablenewnorm,Zoldnorm,tableoldnorm,simset,Teileraprox)


%Finde Index gleicher tablerow
[~,aid,~] = intersect(tablenewnorm,tableoldnorm,'rows');

%Werte von Znewnorm löschen für die Werte von Zoldnorm existieren (aid)
Znewnorm( aid, : ) = [];
tablenewnorm( aid, : ) = [];

%Anzahl von N
Nnew=numel(Znewnorm);
Nold=numel(Zoldnorm);
%Alten werte werden absteigend sortiert damit die Umgebund der besten Werte
%die der schlechteren überschreibt. 

[Zoldnorm,I]=sort(Zoldnorm);
tableoldnorm=tableoldnorm(I,:);

%Anschließend die Alten Werte anhängen/wieder alte größe erreicht
Znewnorm=[Znewnorm;Zoldnorm];
tablenewnorm=[tablenewnorm;tableoldnorm];

step=2/Teileraprox ;
%Umgebung

%Dafür müssen nun nur die letzten Zeilen abgefragt werden
Znewnormcopy=zeros(Nnew,1);
for i=Nnew:Nnew+Nold
    %Die Umgebung wird nur für Werte >0.5 erzeugt
    if Znewnorm(i)>0.5
        
        
        %Ein Hyperwürfel mit der Seitenlänge l' *2 wird um den Punkt
        %konstruiert
        

        if simset==4
        x1=tablenewnorm(i,1)-step:step:tablenewnorm(i,1)+step;
        x2=tablenewnorm(i,2)-step:step:tablenewnorm(i,2)+step;
        x3=tablenewnorm(i,3)-step:step:tablenewnorm(i,3)+step;
        x4=tablenewnorm(i,4)-step:step:tablenewnorm(i,4)+step;
        [X1,X2,X3,X4] =  ndgrid(x1,x2,x3,x4);
        Hw = [X1(:), X2(:),X3(:), X4(:)];
        end
        
        if simset==6
        x1=tablenewnorm(i,1)-step:step:tablenewnorm(i,1)+step;
        x2=tablenewnorm(i,2)-step:step:tablenewnorm(i,2)+step;
        x3=tablenewnorm(i,3)-step:step:tablenewnorm(i,3)+step;
        x4=tablenewnorm(i,4)-step:step:tablenewnorm(i,4)+step;
        x5=tablenewnorm(i,5)-step:step:tablenewnorm(i,5)+step;
        x6=tablenewnorm(i,6)-step:step:tablenewnorm(i,6)+step;
        [X1,X2,X3,X4,X5,X6] =  ndgrid(x1,x2,x3,x4,x5,x6);
        Hw = [X1(:), X2(:),X3(:), X4(:),X5(:), X6(:)];
        end
        
        if simset==7
        x1=tablenewnorm(i,1)-step:step:tablenewnorm(i,1)+step;
        x2=tablenewnorm(i,2)-step:step:tablenewnorm(i,2)+step;
        x3=tablenewnorm(i,3)-step:step:tablenewnorm(i,3)+step;
        x4=tablenewnorm(i,4)-step:step:tablenewnorm(i,4)+step;
        x5=tablenewnorm(i,5)-step:step:tablenewnorm(i,5)+step;
        x6=tablenewnorm(i,6)-step:step:tablenewnorm(i,6)+step;
        x7=tablenewnorm(i,7)-step:step:tablenewnorm(i,7)+step;

        [X1,X2,X3,X4,X5,X6,X7] =  ndgrid(x1,x2,x3,x4,x5,x6,x7);
        Hw = [X1(:), X2(:),X3(:), X4(:),X5(:), X6(:), X7(:)];
        end
        
        
        %Punkte des Hyperwürfels werden gelöscht wenn sie die Grenzen
        %überschreiten 
        
        Hw2=[];
        for f=1:numel(Hw(:,1))

            ma=max(Hw(f,:));
            mi=min(Hw(f,:));

            if mi>=-1   &&  ma<=1
                Hw2=[Hw2;Hw(f,:)];
            end

        end
        
        
        %oder die Hyperkugel Bedingung verletzen
        %Abstand Hw(f,:) Punkt und tablenewnorm(i) wird berechnet
        Hw3=[];
        for f=1:numel(Hw2(:,1))
        
            Ab1=Hw2(f,1)-tablenewnorm(i,1);
            Ab2=Hw2(f,2)-tablenewnorm(i,2);
            Ab3=Hw2(f,3)-tablenewnorm(i,3);
            Ab4=Hw2(f,4)-tablenewnorm(i,4);
            
            dist=sqrt((Ab1^2)+(Ab2^2)+(Ab3^2)+(Ab4^2));

            if simset==6
            Ab5=Hw2(f,5)-tablenewnorm(i,5);
            Ab6=Hw2(f,6)-tablenewnorm(i,6);
            
            dist=sqrt((Ab1^2)+(Ab2^2)+(Ab3^2)+(Ab4^2)+(Ab5^2)+(Ab6^2));
            end

            if simset==7
            Ab5=Hw2(f,5)-tablenewnorm(i,5);
            Ab6=Hw2(f,6)-tablenewnorm(i,6);
            Ab7=Hw2(f,7)-tablenewnorm(i,7);

            
            dist=sqrt((Ab1^2)+(Ab2^2)+(Ab3^2)+(Ab4^2)+(Ab5^2)+(Ab6^2)+(Ab7^2));
            end
            
            if dist<= 1
               Hw3=[Hw3;Hw2(f,:)];
            end

            
            
            
        end
    %Die Punkte Hw3 werden in tablenenorm gesucht und ersetzt durch
    %Znewnorm(i) so wird die Umgebung mit dem Abstand 1 für alle Werte über
    %0 gleichgesetzt
    
    [~,aid,~] = intersect(tablenewnorm,Hw3,'rows');    
     
    for f=1:numel(aid)
        Znewnormcopy(aid(f),:)=Znewnorm(i);
    end    
  
    end%EndeZnewnorm(i)>0      

end%Ende von i=(Nnew-Nold):Nnew

%Die Werte von Znewnormcopy werden in Znewnorm geschrieben

indexnot0=find(Znewnormcopy~=0);

for f=1:numel(indexnot0)
    
    Znewnorm(indexnot0(f,1),1)=Znewnormcopy(indexnot0(f,1));
end




%Am Ende werden alle Werte < 0.5 entfernt
Znewnormfin=[];
Znewschlecht=[];
tablenewnormfin=[];
for f=1:numel(Znewnorm)
    if Znewnorm(f)>0.5
        Znewnormfin=[Znewnormfin;Znewnorm(f)];
        tablenewnormfin=[tablenewnormfin;tablenewnorm(f,:)];
    else
        Znewschlecht=[Znewschlecht;tablenewnorm(f,:)];
    end
    
end

end
