run("Sim3W3DDataNNSetup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DDataNN_Pawpa.mat";

%% run forward model and save the results into CIRLDataPath
load('ObPawpa.mat');
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DDataNN_Pawpa256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');

%%
run("Sim3W3DDataNNSetup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DDataNN_Spath.mat";

%% run forward model and save the results into CIRLDataPath
load('ObSpath.mat');
g  = ForwardModel(ob, h, im, jm);
save(matFile, '-v7.3', 'g', 'ob');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3DDataNN_Spath256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');