Vg_list = [0 -1 -2 -3 -4];   % Gate voltages
ID_all = {};
VDS_all = {};

for k = 1:length(Vg_list)
    Vg = Vg_list(k);              % Set gate voltage
    assignin('base','Vg',Vg);     % push to workspace
    simOut = sim('lab7_2');  % run Simulink model
    
    VDS_all{k} = simOut.logsout.get('VDS').Values.Data;
    ID_all{k}  = simOut.logsout.get('ID').Values.Data;
end