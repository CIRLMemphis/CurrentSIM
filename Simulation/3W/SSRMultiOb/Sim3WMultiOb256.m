run("Sim3WMultiOb256Setup.m");

%% load the high resolution data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb512.mat";
load(matFile, 'g');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');