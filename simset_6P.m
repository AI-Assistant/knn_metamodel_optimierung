function [S]    =   simset_6P(C)
    
    S=[];
    

%Initializing input Parameters
    for c=C.'
        T_red = c(1);%Temperature during reduction
        T_ox  = c(2);%Temperature during oxidation
        t_red = c(3);%Duration of reduction
        t_ox  = c(4);%Duration of oxidation
        M_N2_red  = c(5);%Nitrogen mass flow
        M_H2O_ox = c(6);%Water seteam mass flow
        
        
        %Initializing needed variables %%%%%%%%%%%%%%%
        % simulation_time = 2500;
        % cycles = round(simulation_time/(t_red+t_ox)); %Number of simulated Cycles
        % if cycles < 3
        %     cycles = 3;
        % end
        % %%%%%%%%%%%%%
        %Alterntiv: Vorgabe der Zyklen pro Simulation
        cycles = 10;
        num_time_values = 4*cycles+6; %Calculation of needed number of time vector values:
                                          %4 values per cycle + 6 for the heat up phase                                
        t_change = 5; %Time for the change in Mass flow and Temperature between cycles:
                      %including the transfer functions in the model 1 equals 5s.
                      %Can never be 0 or below!
        time = zeros(1, num_time_values); %Time vector for the model
        T = zeros(1, num_time_values); %Temperature vector for the model                  
        M_N2 = zeros(1, num_time_values); %Nitrogen mass flow profile for the model
        M_H2O = zeros(1, num_time_values); %Oxygen mass flow profile for the model                            
        mass_flow_N2 = M_N2_red/100; %Calculation of nitrogen mass flow value: 0.1
                                        %equals 10kg/h
        mass_flow_H2O = M_H2O_ox/100; %Calculation of oxygen mass flow value: 0.1
                                        %equals 10kg/h

        %Heat up time (The duration of the following step will be
        %added to the previous time value of the time vector. 
        %The time vector has to be monotonicly rising)
        time(1) = 0;
        time(2) = time(1)+200; %Adding the duration of the first heat up step
        time(3) = time(2)+t_change; %Adding the change
        time(4) = time(3)+200; %Adding the duration of the second heat up step
        time(5) = time(4)+t_change; %Adding the change
        % time(6) = time(5)+3180; %Adding the duration of the third heat up step
        time(6) = time(5)+6780; % -> Aufheizphase um 1 Std verlängert, dafür werden danach weniger Zyklen gefahren (simulation time =2500 anstatt 5000)

        %Stepwise temperature profile during heat up
        T(1) = T_red/2; %Temperature of the first heat up step
        T(2) = T_red/2; %Temperature of the first heat up step
        T(3) = T_red*0.8; %Temperature of the second heat up step
        T(4) = T_red*0.8; %Temperature of the second heat up step
        T(5) = T_red; %Temperature of the third heat up step
        T(6) = T_red; %Temperature of the third heat up step

        %Mass flow profile during heat up
        for i = 1:6
        M_N2(i)= 1; % 1% of nitrogen mass flow 
        end
        for i = 1:6
        M_H2O(i) = 0; %No oxygen mass flow
        end

        %Filling the rest of the time vector following:
        %[...3003 (3003+t_red) (3003+t_red+t_change) (3003+t_red+t_change+t_ox)]
        for i = 7:num_time_values

            %Odd indexes -> t_change is added
            if mod(i , 2) ~= 0
                 time(i) = time(i-1)+ t_change;

            %Even indexes with i%4 = 0 -> reduction time is added
            elseif (mod(i , 2) == 0) && (mod(i, 4) == 0)
                 time(i) = time(i-1)+ t_red;

            %Even indexes with i%4 = 2 -> oxidation time is added
            elseif (mod(i , 2) == 0) && (mod(i, 4) == 2)
                 time(i) = time(i-1)+ t_ox;
            end
        end

        t_sim = time(num_time_values); %Definition of the total simulation time

        %Filling of the temperature- and mass flow vector following:
        %T = [... T_red Tred T_ox T_ox T_red T_red...]
        %M_H2O = [... 0 0 100 100 0 0 100 100...]
        %M_N2 = [... 100 100 1 1 100 100 1 1...]
        counter = 1; %Counter variable

        for i = 7:2:num_time_values
            if mod(counter , 2) ~= 0
              T(i) = T_red;
              T(i+1) = T_red;
              M_N2(i) = 100;
              M_N2(i+1) = 100;
              M_H2O(i) = 0;
              M_H2O(i+1) = 0;
            elseif mod(counter , 2) == 0
              T(i) = T_ox;
              T(i+1) = T_ox;
              M_N2(i) = 1;
              M_N2(i+1) = 1;
              M_H2O(i) = 100;
              M_H2O(i+1) = 100;
            end
            counter = counter +1;
        end



        simvec = {t_sim,[mass_flow_N2],[mass_flow_H2O], [time], [T],[M_N2],[M_H2O]};
        
        if size(S)==0
            S=[simvec];
        else
            S=[S;simvec];
        end
    end
    

end