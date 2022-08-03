function [Yh2e,Errorall] = resultstovector(C,out,in)


Yh2e=[];

[~,anz]=size(out);
format longG
Errorall=0;

%Alterntiv: Vorgabe der Zyklen pro Simulation
cycles = 10;
num_time_values = 4*cycles+6; %Calculation of needed number of time vector values:
                                  %4 values per cycle + 6 for the heat up phase  
for i =1:anz


    
    %------------------------------------------
    %Errordetection
    Enames=getElementNames(out(1,i));
    %Falls kein log geschrieben wurde (lo==0)
    if ~any(strcmp(Enames,'logsout'))
    lo=1;
    else
    lo=1;
    end
    %----------------------------------------
        %Falls ERROR oder lo==0 Ergebnis = 0
        if isempty(out(1,i).ErrorMessage)==0 || lo==0
            H2perE=0;
            Errorall=1;
        else
            %Simulation results
            vector_index_ub = 1; %Counter variable

            %Calculation of H2, E and time till the end of penultimate cycle
            while (in(1,i).Variables(1, 4).Value(num_time_values - 3)) > ...
                    out(1,i).MH2_cum_kg.Time(vector_index_ub)
                vector_index_ub = vector_index_ub+1; %Calculation of the 
                                                     %corresponding vector index
            end
            
            %Saving the corresponding values from the simulation output
            H2_penultimate_cycle = out(1,i).MH2_cum_kg.Data(vector_index_ub);
            E_vap_penultimate_cycle = out(1,i).E_vap_cum_Wh.Data(vector_index_ub);
            E_solar_penultimate_cycle = out(1,i).E_solar_cum_Wh.Data(vector_index_ub);
            t_penultimate_cycle = out(1,i).MH2_cum_kg.Time(vector_index_ub);
            
            vector_index_lb = 1; %Counter variable

            %Calculation of H2, E and time at the beginning of the third last cycle
            while (in(1,i).Variables(1, 4).Value(num_time_values - 11)) > ...
                    out(1,i).MH2_cum_kg.Time(vector_index_lb)
                vector_index_lb = vector_index_lb+1;
            end
            
            %Saving the corresponding values from the simulation output
            H2_settling_process = out(1,i).MH2_cum_kg.Data(vector_index_lb);
            E_vap_settling_process = out(1,i).E_vap_cum_Wh.Data(vector_index_lb);
            E_solar_settling_process = out(1,i).E_solar_cum_Wh.Data(vector_index_lb);
            t_settling_process = out(1,i).MH2_cum_kg.Time(vector_index_lb);
            
            %Calculation of H2-Production, Energy and time of the settled process
            H2_settled = H2_penultimate_cycle - H2_settling_process;
            E_vap_settled = E_vap_penultimate_cycle - E_vap_settling_process;
            E_solar_settled = E_solar_penultimate_cycle - E_solar_settling_process;
            t_settled =  t_penultimate_cycle- t_settling_process;

            %Changing units
            E_solar_settled = E_solar_settled/1e3; %Change from Wh to kWh
            E_vap_settled = E_vap_settled/1e3; %Change from Wh to kWh
            t_settled = t_settled/3600; %Change from s to h
            
            %Calculation of the optimization Value
            % H2perT = -(H2_settled/t_settled);
            H2perE = (39.4*H2_settled/(E_solar_settled+E_vap_settled)); %[kWh/kWh]
            
            
        end

   

    Yh2e=[Yh2e;H2perE];
    


    
end
format short
end


