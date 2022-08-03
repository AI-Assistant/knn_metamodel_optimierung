 function []=savedeldouble(C,Yh2e,simset)
%Beim vergleich werden die Sets gerundet
 rou=0;

 %Die neuen Daten werden in die jeweiligen Dateien geschrieben,
 %dabei werden dublikate entfern.


    if simset==6
        Mat=load('6P_res');
        Resplus=Mat.Eges;

        
            if isempty(Resplus)==0
                
                
            Cplus=Resplus(:,1:end-1);
            Yh2eplus=Resplus(:,end);
            
                        
            A=round(Cplus,rou);
            B=round(C,rou);

            [~,~,bid] = intersect(A,B,'rows');

            
            C( bid, : ) = [];
            Yh2e(bid,:)=[];
            

            C=[C;Cplus];
            Yh2e=[Yh2e;Yh2eplus]; 
            
            
            index0=find(Yh2e==0);
            C=removerows(C,'ind',index0);

            Yh2e=removerows(Yh2e,'ind',index0);
            
      
            


            end


    Etableenergie=table(C(:,1),C(:,2),C(:,3),C(:,4),C(:,5),C(:,6),Yh2e);
    
    format longG
    Eges = [C Yh2e];
    format short
    
    save('6P_res.mat','Eges');
    end
    
    

    end