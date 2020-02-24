run("Sim3WMultiOb2P256Setup.m");

%% load the high resolution data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb2P512.mat";
load(matFile, '-v7.3', 'g');

%% get 256 data
matFile = CIRLDataPath + "/Simulation/3W/Sim3WMultiOb2P256.mat";
g = g(1:2:end, 1:2:end, 1:2:end, :,:);
save(matFile, '-v7.3', 'g');