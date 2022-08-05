
%clear


%Löschen aller Cluster/Jobs
delete(gcp('nocreate'));
myCluster = parcluster('local');
delete(myCluster.Jobs);



%Oberen Grenzwerte/Falls eingegrenzt werden kann, tuen!!!

Tred_ub     =   1400;  %Temperature of reduction - upper bound
Tprod_ub    =   1400;  %Temperature of oxidation - upper bound

tred_ub     =   900;  %Duration of reduction - upper bound
tox_ub      =   900;   %Duration of oxidation - upper bound

M_red_ub    =   250;   %Massflow of nitrogen - upper bound
M_ox_ub     =   25;    %Massflow of oxygen - upper bound



%Unteren Grenzwerte
Tred_lb     =   1200;  %Temperature of reduction - lower bound
Tprod_lb    =   800;   %Temperature of oxidation - lower bound


tred_lb     =   120;   %Duration of reduction - lower bound
tox_lb      =   120;   %Duration of oxidation - lower bound

M_red_lb    =   50;    %Massflow of nitrogen - lower bound
M_ox_lb     =   5;     %Massflow of oxygen - lower bound




%////////////////////////////Optionen/////////////////////////////////////


%Model
model = 'reactor_7_opti_model';

%Raster Start a=L/Teiler n=4 Dim.  (2+a/a)^n   
Teiler=1;

%Anzahl der Experimente in der konkretisierung
N2=50;

%Grenzwerte Festlegen ub:upper bound lb:lower bound
bounds =   [Tred_ub Tprod_ub tred_ub tox_ub M_red_ub M_ox_ub; Tred_lb Tprod_lb tred_lb tox_lb M_red_lb M_ox_lb];

%Die maximale Teilung des Rasters
Teileraproxmax=4;

%/////////////////////////////////////////////////////////////////////////

%Die Experimente müssen in den jeweiligen "simset_Xp.m" Dateien in
%entsprechende Simulink-Signale umgewandelt werden.

%Die Anzahl der Inputparameter sowie deren Bezeichnung im Workspace müssen
%in "parcomfunc.m" festgelegt werden.

%Die Stützstellen werden in "Xp_res.mat" gespeichert und das darauf
%basierende optimierte NNetz wird mit "net" zurückgegeben
[net] = NNetOptimizer(bounds,Teiler,N2,model,Teileraproxmax);
