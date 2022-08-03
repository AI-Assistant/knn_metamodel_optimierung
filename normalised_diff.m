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
