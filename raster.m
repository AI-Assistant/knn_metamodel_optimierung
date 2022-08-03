function [C,grid,mesh] = raster(Teiler,simset,bounds)
        l=2/Teiler;
        %Raster Erstellen
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
        mesh =  ndgrid(x1,x2,x3,x4,x5,x6);
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
        %Normiertes Raster umwandeln
        C=[];
        if isempty(bounds)==0
            C=grid;
            for q=1:numel(grid(:,1))
                for i=1:simset
                    Pm=(C(q,i)*(bounds(1,i)-bounds(2,i))+bounds(1,i)+bounds(2,i))/2;
                    C(q,i) = Pm;
                end
            end
        end
end

