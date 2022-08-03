function [net,rmse] = optimalnet(Daten,P)

%Daten mischen
rindx = randperm(size(Daten,1)); 
Daten = Daten(rindx,:);

[m,n] = size(Daten) ;

%Trainings und testdaten aufteilen
Training = Daten(1:round(P*m),:) ; 
Testing = Daten(round(P*m)+1:end,:);

XTrain = Training(:,1:n-1);
YTrain = Training(:,n);
XTest = Testing(:,1:n-1);
YTest = Testing(:,n);



xtrain = XTrain';
ytrain = YTrain';

[n,m] = size(xtrain);

%Validierungsdaten separieren
xval = xtrain(:,round(P*m)+1:end);
yval = ytrain(:,round(P*m)+1:end);

xtrain = xtrain(:,1:round(P*m)) ; 
ytrain = ytrain(:,1:round(P*m)) ; 

xtest  = XTest';
ytest  = YTest';

%Hyperparameter definieren
vars = [optimizableVariable('act1',{'purelin','tansig','logsig'},'Type','categorical'),
        optimizableVariable('act2',{'purelin','tansig','logsig'},'Type','categorical'),
        optimizableVariable('act3',{'purelin','tansig','logsig'},'Type','categorical'),
        optimizableVariable('hiddenLayernum', [1,3], 'Type', 'integer')
        optimizableVariable('hiddenLayersize', [10,17], 'Type', 'integer')];
                
%Optimierungsfunktion 
minfn = @(T)netbuild(xtrain,xtest,ytrain,ytest,T.act1,T.act2,T.act3,T.hiddenLayernum,T.hiddenLayersize);


results = bayesopt(minfn, vars,'IsObjectiveDeterministic', true,...
    'AcquisitionFunctionName', 'expected-improvement-plus','PlotFcn',[],'UseParallel',true);
T = bestPoint(results);


%Netz aus T bauen
layer=[];
for i =1:T.hiddenLayernum
        layer=[layer T.hiddenLayersize];

end

net = fitnet(layer,'trainlm');


if T.hiddenLayernum==1
net.layers{1}.transferFcn = string(T.act1);
end

if T.hiddenLayernum==2
net.layers{1}.transferFcn = string(T.act1);
net.layers{2}.transferFcn = string(T.act2);
end

if T.hiddenLayernum==3
net.layers{1}.transferFcn = string(T.act1);
net.layers{2}.transferFcn = string(T.act2);
net.layers{3}.transferFcn = string(T.act3);
end


%Netz final trainieren
net = train(net, xtrain,ytrain,'useParallel','no');
% Final test MSE
ypredictcl = net(xtest);
rmse = sqrt(mean((ypredictcl- ytest).^2));



function [rmse]=netbuild(xtrain,xtest,ytrain,ytest,act1,act2,act3,numLay,hidSize)

trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Erstellt ein Netz 

layer=[];
for i =1:numLay
        layer=[layer hidSize];

end


net = fitnet(layer,trainFcn);

if numel(layer)==1
net.layers{1}.transferFcn = string(act1);
end

if numel(layer)==2
net.layers{1}.transferFcn = string(act1);
net.layers{2}.transferFcn = string(act2);
end

if numel(layer)==3
net.layers{1}.transferFcn = string(act1);
net.layers{2}.transferFcn = string(act2);
net.layers{3}.transferFcn = string(act3);
end

% Data Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train 
[net,tr] = train(net,xtrain,ytrain);

% Test 
ypredictcl = net(xtest);





rmse = sqrt(mean((ypredictcl- ytest).^2));


end
end

