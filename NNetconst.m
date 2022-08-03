function [nete,Cnorm,ZappYh2enormnorm,grid,Yh2enormnorm] = NNetconst(Teileraprox,Eges,simset,bounds)
%Ergebnis aufteilen
C=Eges(:,1:simset);
Yh2s=Eges(:,end-1:end-1);
Yh2z=Eges(:,end-2:end-2);
Yh2e=Eges(:,end:end);

%Target normalisieren
%Yh2snorm=normalize( Yh2s );
%Yh2znorm=normalize( Yh2z );
Yh2enorm=normalize( Yh2e );

Yh2enormnorm=normalised_diff(Yh2enorm);

Cnorm=normwbounds(C,bounds);

%Optimales Netz 
%[make.netz,~]=optimalnet([Cnorm Yh2znorm],0.8);
%[make.nets,~]=optimalnet([Cnorm Yh2snorm],0.8);
[nete,~]=optimalnet([Cnorm Yh2enorm],0.8);


function [Yh2zpred]=predYh2z(x)
     x=x.';
     Yh2zpred=make.netz(x);
end    

function [Yh2spred]=predYh2s(x)
     x=x.';
     Yh2spred=make.nets(x);
end    

function [Yh2epred]=predYh2e(x)
     x=x.';
     Yh2epred=nete(x);
end    

        l=2/Teileraprox;
        if simset==4
            x1=-1:l:1;
            x2=-1:l:1;
            x3=-1:l:1;
            x4=-1:l:1;
        [X1,X2,X3,X4] =  ndgrid(x1,x2,x3,x4);
        grid = [X1(:), X2(:), X3(:), X4(:)];
        mesh=  ndgrid(x1,x2,x3,x4);
        end
        
        if simset==6
        x1=-1:l:1;
        x2=-1:l:1;
        x3=-1:l:1;
        x4=-1:l:1;
        x5=-1:l:1;
        x6=-1:l:1;        
        [X1,X2,X3,X4,X5,X6] =  ndgrid(x1,x2,x3,x4,x5,x6);
        grid = [X1(:), X2(:),X3(:), X4(:),X5(:), X6(:)];
        mesh=ndgrid(x1,x2,x3,x4,x5,x6);
        end
        if simset==7
        x1=-1:l:1;
        x2=-1:l:1;
        x3=-1:l:1;
        x4=-1:l:1;
        x5=-1:l:1;
        x6=-1:l:1;  
        x7=-1:l:1;

        [X1,X2,X3,X4,X5,X6,X7] =  ndgrid(x1,x2,x3,x4,x5,x6,x7);
        grid = [X1(:), X2(:),X3(:), X4(:),X5(:), X6(:), X7(:)];
        mesh=ndgrid(x1,x2,x3,x4,x5,x6,x7);
        end
        


%ZappYh2snorm=predYh2s(grid);
ZappYh2enorm=predYh2e(grid);
%ZappYh2znorm=predYh2z(grid);





%ZappYh2snorm=transpose(ZappYh2snorm);
ZappYh2enorm=transpose(ZappYh2enorm);
%ZappYh2znorm=transpose(ZappYh2znorm);


%ZappYh2snormnorm=normalised_diff(ZappYh2snorm);
ZappYh2enormnorm=normalised_diff(ZappYh2enorm);
%ZappYh2znormnorm=normalised_diff(ZappYh2znorm);


end

function X = normalised_diff( data )

ma=max(max(data));
mi=min(min(data));
X=[];
    for i=1:numel(data(1,:))
        Xcol=[];
        for q=1:numel(data(:,1))
            zaeler=data(q,i)-(ma+mi)/2;
            nenner=(ma-mi)/2;
            Xcol=[Xcol;zaeler/nenner];
            
            
        end
        X=[X Xcol];
    end
end



