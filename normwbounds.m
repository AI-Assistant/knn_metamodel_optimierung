function X =normwbounds(data,bounds)



X=[];
    for i=1:numel(data(1,:))
        Xcol=[];
        for q=1:numel(data(:,1))
            ma=bounds(1,i);
            mi=bounds(2,i);
            
            zaeler=data(q,i)-(ma+mi)/2;
            nenner=(ma-mi)/2;
            Xcol=[Xcol;zaeler/nenner];
            
            
        end
        X=[X Xcol];
    end

end